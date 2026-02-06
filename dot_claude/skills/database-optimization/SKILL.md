---
name: database-optimization
description: Database performance optimization and storage strategies. Use when optimizing queries, choosing storage options, implementing caching, or improving database scalability.
---

# Database Optimization

Patterns for query optimization, caching strategies, storage selection, and performance tuning.

## Storage Decision Matrix

Choose the right tool for each data access pattern.

| Use Case | Best Choice | Why |
|----------|------------|-----|
| Relational data (users, projects, records) | Database (PostgreSQL, MySQL, SQLite) | SQL queries, joins, transactions, ACID |
| User sessions, feature flags, config | Cache/KV | Fast reads, eventual consistency acceptable |
| Large files, exports, media uploads | Object Storage (S3, R2) | Designed for large objects, no storage limits |
| API response cache | Cache API | Per-datacenter, auto-evicts, no TTL overhead |
| Global edge cache (across regions) | KV | Edge-distributed, TTL support, replication |
| Real-time counters, unique constraints | Database | Strong consistency required |
| Frequently read, rarely updated config | KV | Fast reads, lower cost than database queries |

<template id="hybrid-caching">

```typescript
// Three-tier caching: Cache API → KV → Database
export async function cachedQuery<T>(
  env: Bindings,
  key: string,
  queryFn: () => Promise<T>,
  ttl = { cache: 300, kv: 3600 } // Cache API: 5m, KV: 1h
): Promise<T> {
  // L1: Cache API (same datacenter, fastest, auto-evicts)
  const cache = caches.default
  const cacheKey = new Request(`https://cache/${key}`)
  const cached = await cache.match(cacheKey)
  if (cached) {
    return (await cached.json()) as T
  }

  // L2: KV (global edge cache, persistent with TTL)
  const kvCached = await env.CACHE_KV?.get<T>(key, "json")
  if (kvCached) {
    // Backfill Cache API for next request
    await cache.put(cacheKey, new Response(JSON.stringify(kvCached), {
      headers: { "Cache-Control": `max-age=${ttl.cache}` },
    }))
    return kvCached
  }

  // L3: Database (cold path, most expensive)
  const result = await queryFn()

  // Populate both cache layers
  if (env.CACHE_KV) {
    await env.CACHE_KV.put(key, JSON.stringify(result), {
      expirationTtl: ttl.kv,
    })
  }

  await cache.put(cacheKey, new Response(JSON.stringify(result), {
    headers: { "Cache-Control": `max-age=${ttl.cache}` },
  }))

  return result
}

// Usage
const items = await cachedQuery(
  env,
  `tenant:${tenantId}:items`,
  () =>
    db
      .select()
      .from(itemsTable)
      .where(eq(itemsTable.tenantId, tenantId)),
  { cache: 300, kv: 3600 }
)
```

</template>

<template id="cache-invalidation">

```typescript
// Invalidate cache after mutations
export async function invalidateCache(env: Bindings, ...keys: string[]) {
  const cache = caches.default

  for (const key of keys) {
    // Delete from KV
    if (env.CACHE_KV) {
      await env.CACHE_KV.delete(key)
    }

    // Delete from Cache API
    await cache.delete(new Request(`https://cache/${key}`))
  }
}

// In mutation procedures: invalidate affected caches
const createItem = authProcedure
  .input(z.object({ name: z.string() }))
  .use(authorizationMiddleware({ resource: "item", action: "create" }))
  .handler(async ({ input, context }) => {
    const [item] = await context.db
      .insert(itemsTable)
      .values({ /* ... */ })
      .returning()

    // Invalidate all affected cache keys
    const cacheKeys = [
      `tenant:${context.session.activeTenantId}:items`,
      `tenant:${context.session.activeTenantId}:items:list`,
      `item:${item.id}`,
    ]

    await invalidateCache(context.env, ...cacheKeys)

    return item
  })
```

</template>

## Query Optimization

<template id="query-patterns">

```typescript
// ANTI-PATTERN: N+1 queries (avoid!)
// This runs 1 query per parent, causing N database roundtrips
for (const parent of parents) {
  const children = await db
    .select()
    .from(childTable)
    .where(eq(childTable.parentId, parent.id))
}

// GOOD: Batch load with IN clause (single query)
const allChildren = await db
  .select()
  .from(childTable)
  .where(inArray(childTable.parentId, parents.map((p) => p.id)))

const childrenByParent = groupBy(allChildren, "parentId")
for (const parent of parents) {
  parent.children = childrenByParent[parent.id] || []
}

// GOOD: Use Drizzle relations (handles batching automatically)
const parents = await db.query.parentTable.findMany({
  with: {
    children: true, // Automatically batched
  },
})

// GOOD: Composite index for filter + sort patterns
// Index: (tenant_id, created_at DESC)
const recent = await db
  .select()
  .from(itemTable)
  .where(eq(itemTable.tenantId, tenantId))
  .orderBy(desc(itemTable.createdAt))
  .limit(50)

// GOOD: Pagination to limit result set
const page = 1
const pageSize = 20
const paginated = await db
  .select()
  .from(itemTable)
  .where(eq(itemTable.tenantId, tenantId))
  .limit(pageSize)
  .offset((page - 1) * pageSize)
```

</template>

<template id="index-strategy">

```typescript
// Index priority (in order of impact):

// 1. Foreign keys (always index)
index("idx_items_parent").on(itemTable.parentId)
index("idx_items_tenant").on(itemTable.tenantId)

// 2. Frequently filtered columns
index("idx_items_status").on(itemTable.status)
index("idx_items_owner").on(itemTable.ownerId)

// 3. Composite indexes for common filter + sort patterns
// Used when query filters by column A and sorts by column B
index("idx_items_tenant_created").on(
  itemTable.tenantId,
  desc(itemTable.createdAt)
)
index("idx_items_status_updated").on(
  itemTable.status,
  desc(itemTable.updatedAt)
)

// 4. Unique constraints (create index automatically)
unique("unique_tenant_slug").on(itemTable.tenantId, itemTable.slug)

// Avoid:
// - Indexing low-cardinality columns (status, boolean flags)
// - Over-indexing (too many indexes slow down writes)
// - Substring indexes unless necessary for LIKE queries
```

</template>

## Storage Strategies

<template id="hybrid-storage">

```typescript
// For content exceeding database row limits:
// Store metadata in database, content in object storage

// Write: Store large content in R2, keep metadata in D1
const contentKey = `tenant/${tenantId}/items/${itemId}.json`
await env.BUCKET.put(contentKey, JSON.stringify(largeData))

const [item] = await db.insert(items).values({
  id: itemId,
  tenantId,
  r2Key: contentKey, // Reference to R2 object
  format: "json",
  sizeBytes: JSON.stringify(largeData).length,
  // Other metadata
}).returning()

// Read: Fetch metadata from DB, content from R2
const itemRecord = await db.query.items.findFirst({
  where: eq(items.id, itemId),
})
const r2Object = await env.BUCKET.get(itemRecord.r2Key)
const content = await r2Object.json()

// Delete: Remove from both storages
await env.BUCKET.delete(itemRecord.r2Key)
await db.delete(items).where(eq(items.id, itemId))
```

</template>

<template id="pagination-pattern">

```typescript
// Cursor-based pagination (more efficient for large datasets)
const list = authProcedure
  .input(
    z.object({
      tenantId: z.string(),
      limit: z.number().int().min(1).max(100).default(20),
      cursor: z.string().optional(),
    })
  )
  .handler(async ({ input, context }) => {
    let query = context.db
      .select()
      .from(itemTable)
      .where(eq(itemTable.tenantId, input.tenantId))

    // Cursor-based filtering (more efficient than offset)
    if (input.cursor) {
      query = query.where(gt(itemTable.id, input.cursor))
    }

    const items = await query
      .orderBy(asc(itemTable.id))
      .limit(input.limit + 1) // Fetch one extra to detect if more exist

    const hasMore = items.length > input.limit
    const results = items.slice(0, input.limit)
    const nextCursor = hasMore ? results[results.length - 1]?.id : null

    return { items: results, nextCursor, hasMore }
  })
```

</template>

<instructions>

1. Use Cache API for same-datacenter caching (fastest, auto-evicts)
2. Use KV for global edge caching (shared across datacenters)
3. Use object storage (R2, S3) for large content exceeding DB row limits
4. Always invalidate caches after mutations (prevents stale data)
5. Batch load related data with IN clause or Drizzle relations (avoid N+1)
6. Add composite indexes for queries that filter AND sort
7. Index foreign keys and frequently filtered columns
8. Use cursor-based pagination for large datasets (more efficient than offset)
9. Avoid storing large blobs in database (use object storage instead)
10. Monitor database size and plan optimization/sharding before limits

</instructions>

<anti-patterns>

- Storing large files/blobs directly in database (use object storage)
- Caching without invalidation strategy (stale data after mutations)
- N+1 query patterns in loops (use IN clause or joins)
- Missing indexes on foreign keys and filtered columns
- Using KV for data requiring strong consistency (use database instead)
- Premature sharding (optimize queries and caching first)
- Pagination with unbounded offset (use cursor-based pagination)
- No composite indexes for common filter + sort patterns
- Indexing low-cardinality columns (status, boolean fields)
- Not monitoring cache hit rates and database performance

</anti-patterns>
