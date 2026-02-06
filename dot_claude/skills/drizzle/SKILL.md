---
name: drizzle
description: Database schema patterns with Drizzle ORM. Use when creating or modifying database tables, columns, indexes, relationships, or migrations across PostgreSQL, MySQL, or SQLite.
---

# Drizzle ORM Schema

Schema design patterns for Drizzle ORM with support for multiple database dialects.

<template id="table-definition">

```typescript
import {
  index,
  integer,
  text,
  varchar,
  unique,
  sqliteTable,
  mysqlTable,
  pgTable,
} from "drizzle-orm/[sqlite|mysql|postgres]-core"

// Choose your dialect's table function: sqliteTable, mysqlTable, pgTable
export const {entityTable} = sqliteTable(
  "{entity_table}",
  {
    id: text("id").primaryKey(), // Text ID (UUID, ULID, nanoid, etc.)
    // Tenant/parent scoping column
    tenantId: text("tenant_id").notNull(),
    // Domain fields
    name: text("name").notNull(),
    description: text("description"),
    status: text("status", { enum: ["active", "inactive", "archived"] }).notNull().default("active"),
    settings: text("settings"), // JSON as text, parse in application
    createdAt: integer("created_at", { mode: "timestamp" }).notNull(),
    updatedAt: integer("updated_at", { mode: "timestamp" }).notNull(),
  },
  (table) => [
    // Index tenant/parent for filtering
    index("idx_{entity}_tenant").on(table.tenantId),
    // Index frequently filtered columns
    index("idx_{entity}_status").on(table.status),
    // Unique constraints for business logic
    unique("unique_tenant_name").on(table.tenantId, table.name),
  ],
)

export type {EntityName} = typeof {entityTable}.$inferSelect
export type Insert{EntityName} = typeof {entityTable}.$inferInsert
```

</template>

<template id="column-types">

```typescript
// Primary key (use text for UUID/ULID)
id: text("id").primaryKey()
// For auto-increment (MySQL/PostgreSQL only)
id: integer("id").primaryKey().autoincrement() // MySQL/SQLite
id: serial("id").primaryKey() // PostgreSQL

// Foreign key with cascade delete
parentId: text("parent_id")
  .notNull()
  .references(() => parentTable.id, { onDelete: "cascade" })

// Timestamps (always include)
createdAt: integer("created_at", { mode: "timestamp" }).notNull()
updatedAt: integer("updated_at", { mode: "timestamp" }).notNull()

// Enum-like text (define values for your domain)
status: text("status", { enum: ["active", "inactive", "archived"] }).notNull()
role: text("role", { enum: ["owner", "admin", "editor", "viewer"] }).notNull()

// Optional fields
description: text("description") // nullable
settings: text("settings") // JSON as text

// Database-specific columns
// PostgreSQL: use real JSON type
data: json("data"),
// MySQL/SQLite: store as text
data: text("data"),
```

</template>

<template id="indexes">

```typescript
(table) => [
  // Single column index on foreign keys (required for filtering)
  index("idx_{entity}_parent").on(table.parentId),
  index("idx_{entity}_tenant").on(table.tenantId),

  // Composite index for filter + sort (common pattern)
  index("idx_{entity}_tenant_created").on(table.tenantId, table.createdAt),
  index("idx_{entity}_status_updated").on(table.status, table.updatedAt),

  // Unique constraint for business-level uniqueness
  unique("unique_tenant_slug").on(table.tenantId, table.slug),
]
```

</template>

<template id="relations">

```typescript
import { relations } from "drizzle-orm"

// One-to-many: parent entity has many children
export const parentRelations = relations(parentTable, ({ many }) => ({
  children: many(childTable),
}))

// One-to-one inverse: child belongs to parent
export const childRelations = relations(childTable, ({ one }) => ({
  parent: one(parentTable, {
    fields: [childTable.parentId],
    references: [parentTable.id],
  }),
}))

// Self-referential: hierarchical structure (tree/nested list)
export const itemRelations = relations(itemTable, ({ one, many }) => ({
  parent: one(itemTable, {
    fields: [itemTable.parentId],
    references: [itemTable.id],
    relationName: "parentChild",
  }),
  children: many(itemTable, { relationName: "parentChild" }),
}))

// Many-to-many via junction table
export const entityJoinRelations = relations(junctionTable, ({ one }) => ({
  entity1: one(entity1Table, {
    fields: [junctionTable.entity1Id],
    references: [entity1Table.id],
  }),
  entity2: one(entity2Table, {
    fields: [junctionTable.entity2Id],
    references: [entity2Table.id],
  }),
}))
```

</template>

<template id="migrations">

```bash
# Generate migration from schema changes
drizzle-kit generate

# Review generated SQL before committing
ls drizzle/

# Apply to local database (SQLite)
drizzle-kit migrate:sqlite

# Apply to PostgreSQL
drizzle-kit migrate:postgres

# Apply to MySQL
drizzle-kit migrate:mysql

# Drop and recreate (development only)
drizzle-kit drop
```

</template>

<template id="advanced-patterns">

```typescript
// Soft delete: add deletedAt column, filter with isNull in queries
deletedAt: integer("deleted_at", { mode: "timestamp" })

// Optimistic locking: add version column, include in where clause on update
version: integer("version").notNull().default(1)

// Handle unique constraint violations
try {
  const [inserted] = await db.insert(entities).values({ ... }).returning()
} catch (error) {
  if (error instanceof Error && error.message.includes("UNIQUE constraint")) {
    throw new Error("Entity already exists")
  }
  throw error
}

// Partial indexes (PostgreSQL) for conditional filtering
// In migrations only: CREATE INDEX idx_name ON table WHERE deleted_at IS NULL
```

</template>

<instructions>

1. Use text columns for non-sequential IDs (UUID, ULID, nanoid)
2. Use `integer` with `mode: "timestamp"` for dates (works across SQLite/MySQL/PostgreSQL)
3. Index ALL foreign keys and frequently filtered columns
4. Use `onDelete: "cascade"` for child tables with strong parent relationships
5. Store JSON as text columns with application-layer validation
6. Add unique constraints for business-level uniqueness
7. Always export both select and insert types from table definitions
8. Re-run migrations after schema changes
9. Test migrations locally before deploying
10. Use dialect-specific features only when necessary (prefer portable patterns)

</instructions>

<anti-patterns>

- Using auto-increment IDs when business needs semantic/distributable IDs
- Missing indexes on foreign keys or filtered columns
- Forgetting cascade rules on child table deletes
- Storing JSON in blob/binary instead of text
- Not exporting type-safe insert/select types
- Creating indexes on low-cardinality columns (status, role)
- Migrations without proper rollback strategy
- Using dialect-specific syntax when portable patterns exist

</anti-patterns>
