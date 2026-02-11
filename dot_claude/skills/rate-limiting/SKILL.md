---
name: rate-limiting
description: API rate limiting and abuse prevention patterns. Use when implementing rate limits, API key management, tiered limits, or protecting endpoints from abuse.
---

# Rate Limiting

Patterns for rate limiting, quota enforcement, and abuse prevention.

<template id="middleware-rate-limit">

```typescript
// Generic rate limiting middleware
export function rateLimitMiddleware(opts?: {
  limit?: number; // Requests per period
  period?: number; // Time period in seconds
}) {
  return async (c: Context<{ Bindings: Bindings }>, next: Next) => {
    const limit = opts?.limit ?? 100;
    const period = opts?.period ?? 60;

    // Key by authenticated user, fall back to IP
    const userId = c.get("user")?.id;
    const ip = c.req.header("cf-connecting-ip") ?? "unknown";
    const key = userId ? `user:${userId}` : `ip:${ip}`;

    // Check rate limit (use your provider's API)
    // This is a generic example; replace with your provider
    const remaining = await checkRateLimit(c.env, key, limit, period);

    // Set standard rate limit headers
    c.header("X-RateLimit-Limit", String(limit));
    c.header("X-RateLimit-Remaining", String(Math.max(0, remaining)));
    c.header(
      "X-RateLimit-Reset",
      String(Math.ceil(Date.now() / 1000) + period),
    );

    if (remaining < 0) {
      c.header("Retry-After", String(period));
      return c.json(
        {
          error: "Too many requests",
          retryAfter: period,
        },
        429,
      );
    }

    await next();
  };
}

// Helper to check rate limit (adapt to your provider)
async function checkRateLimit(
  env: Bindings,
  key: string,
  limit: number,
  period: number,
): Promise<number> {
  // Example: Cloudflare Rate Limiting API
  if (env.RATE_LIMITER) {
    const { success, remaining } = await env.RATE_LIMITER.limit({ key });
    return remaining;
  }

  // Fallback: simple in-memory tracking (not suitable for production)
  // Use Durable Objects, KV, or external service for real deployments
  return limit;
}
```

</template>

<template id="endpoint-specific-limits">

```typescript
// Define different limits for different endpoints
const ENDPOINT_LIMITS: Record<string, { limit: number; period: number }> = {
  // Auth endpoints: strict limits to prevent brute force and credential stuffing
  "POST /api/auth/login": { limit: 5, period: 60 },
  "POST /api/auth/signup": { limit: 3, period: 300 },
  "POST /api/auth/reset-password": { limit: 3, period: 3600 },

  // Expensive operations: lower limits
  "POST /api/export": { limit: 10, period: 3600 },
  "POST /api/bulk-upload": { limit: 5, period: 3600 },

  // Read operations: higher limits
  "GET /api/search": { limit: 30, period: 60 },
  "GET /api/list": { limit: 50, period: 60 },

  // Default: moderate baseline
  default: { limit: 100, period: 60 },
};

// Middleware that applies per-endpoint limits
export function endpointRateLimitMiddleware() {
  return async (c: Context<{ Bindings: Bindings }>, next: Next) => {
    const method = c.req.method;
    const path = new URL(c.req.url).pathname;
    const endpoint = `${method} ${path}`;

    // Look up config for this endpoint
    const config = ENDPOINT_LIMITS[endpoint] ?? ENDPOINT_LIMITS["default"];

    // Key by user ID if authenticated, else IP
    const userId = c.get("user")?.id;
    const ip = c.req.header("cf-connecting-ip") ?? "unknown";
    const key = `${userId ?? ip}:${endpoint}`;

    // Check rate limit
    const remaining = await checkRateLimit(
      c.env,
      key,
      config.limit,
      config.period,
    );

    c.header("X-RateLimit-Limit", String(config.limit));
    c.header("X-RateLimit-Remaining", String(Math.max(0, remaining)));

    if (remaining < 0) {
      const resetAfter = Math.ceil(config.period);
      c.header("Retry-After", String(resetAfter));
      return c.json(
        {
          error: "Rate limit exceeded",
          endpoint,
          limit: config.limit,
          period: config.period,
          retryAfter: resetAfter,
        },
        429,
      );
    }

    await next();
  };
}

// Apply to Hono app
app.use("/api/*", endpointRateLimitMiddleware());
```

</template>

<template id="user-tier-limits">

```typescript
// Define rate limits by subscription tier
const TIER_LIMITS: Record<string, { limit: number; period: number }> = {
  free: { limit: 1000, period: 3600 }, // 1k/hour
  pro: { limit: 50000, period: 3600 }, // 50k/hour
  enterprise: { limit: 500000, period: 3600 }, // 500k/hour
};

// Schema for API key management
export const apiKeys = sqliteTable(
  "api_keys",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => createId()),
    tenantId: text("tenant_id").notNull(),
    key: text("key")
      .notNull()
      .unique()
      .$defaultFn(() => `app_${crypto.randomUUID().replace(/-/g, "")}`),
    name: text("name").notNull(),
    tier: text("tier").notNull().default("free"),
    enabled: integer("enabled", { mode: "boolean" }).notNull().default(true),
    lastUsedAt: integer("last_used_at", { mode: "timestamp" }),
    createdAt: integer("created_at", { mode: "timestamp" }).$defaultFn(
      () => new Date(),
    ),
  },
  (table) => [
    index("idx_api_keys_key").on(table.key),
    index("idx_api_keys_tenant").on(table.tenantId),
  ],
);

// Middleware: authenticate and apply tier-based limits
export function apiKeyRateLimitMiddleware() {
  return async (c: Context<{ Bindings: Bindings }>, next: Next) => {
    const authHeader = c.req.header("Authorization") || "";
    const apiKey = authHeader.replace("Bearer ", "");

    if (!apiKey) {
      // Public endpoints get anonymous limits
      const remaining = await checkRateLimit(c.env, "anonymous", 10, 60);
      if (remaining < 0) {
        return c.json({ error: "Rate limit exceeded" }, 429);
      }
      return await next();
    }

    // Look up API key and tier
    const db = createDbClient(c.env.DB);
    const keyRecord = await db.query.apiKeys.findFirst({
      where: eq(apiKeys.key, apiKey),
    });

    if (!keyRecord || !keyRecord.enabled) {
      return c.json({ error: "Invalid API key" }, 401);
    }

    // Apply tier-based limit
    const tierLimit = TIER_LIMITS[keyRecord.tier] ?? TIER_LIMITS["free"];
    const rateLimitKey = `api_key:${apiKey}`;

    const remaining = await checkRateLimit(
      c.env,
      rateLimitKey,
      tierLimit.limit,
      tierLimit.period,
    );

    // Update last used timestamp
    await db
      .update(apiKeys)
      .set({ lastUsedAt: new Date() })
      .where(eq(apiKeys.id, keyRecord.id));

    c.header("X-RateLimit-Limit", String(tierLimit.limit));
    c.header("X-RateLimit-Remaining", String(Math.max(0, remaining)));

    if (remaining < 0) {
      c.header("Retry-After", String(tierLimit.period));
      return c.json(
        { error: "Rate limit exceeded", tier: keyRecord.tier },
        429,
      );
    }

    // Attach key context to request
    c.set("apiKey", keyRecord);

    await next();
  };
}
```

</template>

<template id="sliding-window-example">

```typescript
// Sliding window rate limiting (more accurate than fixed windows)
async function slidingWindowRateLimit(
  env: Bindings,
  key: string,
  limit: number,
  windowSeconds: number,
): Promise<{ allowed: boolean; remaining: number; resetAt: number }> {
  const kv = env.CACHE_KV; // Use KV for tracking requests
  const now = Date.now();
  const windowStart = now - windowSeconds * 1000;

  // Get current window data
  const windowKey = `ratelimit:${key}:${Math.floor(now / (windowSeconds * 1000))}`;
  let count = (await kv.get<number>(windowKey, "json")) ?? 0;

  // Increment counter
  count++;
  await kv.put(windowKey, JSON.stringify(count), {
    expirationTtl: windowSeconds + 60, // Keep slightly longer for cleanup
  });

  const allowed = count <= limit;
  const remaining = Math.max(0, limit - count);
  const resetAt = Math.ceil((windowStart + windowSeconds * 1000) / 1000);

  return { allowed, remaining, resetAt };
}
```

</template>

<instructions>

1. Always include `X-RateLimit-Limit`, `X-RateLimit-Remaining`, and `Retry-After` headers
2. Key by authenticated user ID when available, fall back to IP (`cf-connecting-ip`)
3. Use strict limits on auth endpoints (login: 5/min, signup: 3/5min) to prevent brute force
4. Use stricter limits on expensive operations (exports, bulk actions)
5. Return 429 status with `Retry-After` header (seconds until reset)
6. For public APIs: store API keys in database, validate before rate limiting
7. Track `lastUsedAt` on API keys for monitoring and abuse detection
8. Use Durable Objects, KV, or external service for accurate cross-request tracking
9. Test rate limit thresholds before deployment
10. Monitor rate limit headers in client logs to detect quota issues

</instructions>
