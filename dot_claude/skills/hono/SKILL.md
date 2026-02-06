---
name: hono
description: HTTP server patterns with Hono framework. Use when configuring routing, middleware, CORS, bindings, or integrating RPC/auth handlers across Cloudflare Workers, Node.js, Bun, or Deno.
---

# Hono Web Framework

Lightweight HTTP framework for serverless platforms.

<template id="app-setup">

```typescript
import { Hono } from "hono"
import { cors } from "hono/cors"
import { logger } from "hono/logger"
import { secureHeaders } from "hono/secure-headers"

// Type your bindings (environment variables, databases, services)
type Bindings = {
  // Databases
  DB: Database | string // Connection string for Node/Bun/Deno
  // Cloudflare specific
  RATE_LIMITER?: RateLimitNamespace
  BUCKET?: R2Bucket
  CACHE_KV?: KVNamespace
  // Secrets
  JWT_SECRET: string
  API_KEY: string
  // Add your service-specific secrets
}

const app = new Hono<{ Bindings: Bindings }>()

// Middleware stack (applied in order)
app.use("*", logger()) // Log all requests
app.use("*", secureHeaders())
app.use("*", cors({
  origin: (origin) => {
    // Development: allow localhost origins
    if (process.env.NODE_ENV !== "production") {
      return origin
    }
    // Production: strict origin whitelist
    const allowed = ["https://app.yourdomain.com", "https://www.yourdomain.com"]
    return allowed.includes(origin) ? origin : ""
  },
  credentials: true, // Allow cookies
  allowMethods: ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
  allowHeaders: ["Content-Type", "Authorization"],
}))

export default app
```

</template>

<template id="error-handling">

```typescript
import { HTTPException } from "hono/http-exception"

// Global error handler
app.onError((err, c) => {
  console.error("Unhandled error:", err)

  if (err instanceof HTTPException) {
    return c.json(
      { error: err.message, status: err.status },
      err.status
    )
  }

  // Parse error codes from string errors (e.g., "NOT_FOUND: ...")
  const errorString = err instanceof Error ? err.message : String(err)
  const [code, ...messageParts] = errorString.split(": ")
  const message = messageParts.join(": ") || "Internal Server Error"

  const statusMap: Record<string, number> = {
    NOT_FOUND: 404,
    CONFLICT: 409,
    BAD_REQUEST: 400,
    FORBIDDEN: 403,
    INTERNAL_SERVER_ERROR: 500,
  }

  const status = statusMap[code] || 500

  return c.json({ error: message, code }, status)
})

// 404 handler
app.notFound((c) => c.json({ error: "Not Found", path: c.req.path }, 404))
```

</template>

<template id="rpc-integration">

```typescript
import { RPCHandler } from "@orpc/server/fetch" // or your RPC framework
import { router } from "./procedures"

const handler = new RPCHandler(router)

app.all("/rpc/*", async (c) => {
  const context = {
    db: createDbClient(c.env.DB),
    user: c.get("user"),
    session: c.get("session"),
    env: c.env,
  }

  return handler.handle(c.req.raw, {
    prefix: "/rpc",
    context,
  })
})
```

</template>

<template id="auth-integration">

```typescript
import { auth } from "./auth" // Better Auth or similar

// Mount auth handler
app.all("/api/auth/*", (c) => auth.handler(c.req.raw))

// Optional: Middleware to extract session
app.use("/api/*", async (c, next) => {
  const session = await auth.getSession(c.req.raw)
  if (session) {
    c.set("user", session.user)
    c.set("session", session)
  }
  await next()
})
```

</template>

<template id="route-groups">

```typescript
// Create route group with shared middleware
const api = new Hono<{ Bindings: Bindings }>()

// Apply authentication middleware to all API routes
api.use("*", async (c, next) => {
  const authHeader = c.req.header("Authorization")
  if (!authHeader) {
    return c.json({ error: "Unauthorized" }, 401)
  }
  // Verify token, extract user
  const user = verifyToken(authHeader)
  c.set("user", user)
  await next()
})

// Define routes within group
api.get("/status", (c) => c.json({
  message: "Authenticated",
  user: c.get("user"),
}))

api.get("/profile", (c) => c.json(c.get("user")))

// Mount group at base path
app.route("/api", api)

// Alternative: route groups with Hono's native routing
const protectedRoutes = app
  .basePath("/api/protected")
  .use("*", authenticationMiddleware)

protectedRoutes.get("/data", (c) => c.json({ data: "..." }))
```

</template>

<template id="typed-bindings">

```typescript
// Access environment variables with full type safety
app.get("/info", (c) => {
  const secret = c.env.JWT_SECRET // Typed as string
  const db = c.env.DB // Typed as Database
  const bucket = c.env.BUCKET // Typed as R2Bucket (optional)

  return c.json({ envLoaded: !!secret && !!db })
})

// Helper to create scoped context
function createContext(c: Context<{ Bindings: Bindings }>) {
  return {
    db: createDbClient(c.env.DB),
    bucket: c.env.BUCKET,
    secret: c.env.JWT_SECRET,
    userId: c.get("user")?.id,
  }
}

app.post("/upload", async (c) => {
  const ctx = createContext(c)
  const file = await c.req.blob()

  if (ctx.bucket) {
    await ctx.bucket.put(`uploads/${ctx.userId}/${file.name}`, file)
  }

  return c.json({ success: true })
})
```

</template>

<template id="middleware-patterns">

```typescript
// Logging middleware
app.use("*", async (c, next) => {
  const start = Date.now()
  await next()
  const duration = Date.now() - start
  console.log(`${c.req.method} ${c.req.path} - ${duration}ms`)
})

// Authentication middleware
app.use("/api/*", async (c, next) => {
  const token = c.req.header("Authorization")?.replace("Bearer ", "")
  if (!token) {
    return c.json({ error: "Unauthorized" }, 401)
  }

  try {
    const decoded = verifyJWT(token, c.env.JWT_SECRET)
    c.set("user", decoded)
  } catch {
    return c.json({ error: "Invalid token" }, 401)
  }

  await next()
})

// Request/response transformation
app.use("*", async (c, next) => {
  c.header("X-Request-ID", crypto.randomUUID())
  await next()
  c.header("X-Response-Time", String(Date.now()))
})

// Error boundary
app.use("*", async (c, next) => {
  try {
    await next()
  } catch (err) {
    console.error("Route error:", err)
    return c.json({ error: "Internal Server Error" }, 500)
  }
})
```

</template>

<instructions>

1. Type Bindings for all environment variables and services
2. Apply CORS with explicit origin whitelist (never wildcard in production)
3. Use middleware stack for cross-cutting concerns (auth, logging, errors)
4. Mount RPC handler at `/rpc/*` with proper context
5. Mount auth handler at `/api/auth/*`
6. Access `c.env` for typed environment variables
7. Add global `onError` and `notFound` handlers
8. Use route groups with `.route()` for modular organization
9. Leverage middleware composition for middleware reuse
10. Keep routes simple; move business logic to procedures/handlers

</instructions>

<anti-patterns>

- Hardcoding secrets instead of using c.env
- Using wildcard "*" for CORS origins in production
- Missing global error handling (onError, notFound)
- Not typing Bindings for environment variables
- Putting heavy business logic in route handlers (move to procedures)
- Missing CORS headers for cross-origin requests
- Using synchronous operations in async contexts
- Not logging errors for debugging
- Forgetting to call `await next()` in middleware

</anti-patterns>
