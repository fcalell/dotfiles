---
name: observability
description: Structured logging, error tracking, and monitoring patterns. Use when adding logging, integrating error tracking, or setting up production monitoring.
---

# Observability

## Structured Logging

<template id="structured-logger">

```typescript
// src/lib/logger.ts
type LogLevel = "debug" | "info" | "warn" | "error";

export function createLogger(requestId: string, environment: string) {
  const log = (
    level: LogLevel,
    message: string,
    data?: Record<string, unknown>,
  ) => {
    console[level === "error" ? "error" : level === "warn" ? "warn" : "log"](
      JSON.stringify({
        level,
        message,
        requestId,
        environment,
        timestamp: new Date().toISOString(),
        ...data,
      }),
    );
  };

  return {
    debug: (msg: string, data?: Record<string, unknown>) =>
      log("debug", msg, data),
    info: (msg: string, data?: Record<string, unknown>) =>
      log("info", msg, data),
    warn: (msg: string, data?: Record<string, unknown>) =>
      log("warn", msg, data),
    error: (msg: string, data?: Record<string, unknown>) =>
      log("error", msg, data),
  };
}
```

```typescript
// Usage in middleware (adapt to your framework)
app.use("*", async (c, next) => {
  // Get request ID from framework header or generate UUID
  const requestId = c.req.header("x-request-id") ?? crypto.randomUUID();
  const logger = createLogger(requestId, c.env.ENVIRONMENT ?? "development");

  // Store logger in request context for downstream use
  c.set("logger", logger);
  c.set("requestId", requestId);

  const start = performance.now();
  await next();
  const duration = Math.round(performance.now() - start);

  // Log request completion with metrics
  logger.info("request_completed", {
    method: c.req.method,
    path: new URL(c.req.url).pathname,
    status: c.res.status,
    duration,
  });
});
```

</template>

## Error Tracking

<template id="error-tracking">

```typescript
// src/lib/error-tracking.ts
// Choose provider based on your platform (Sentry, Datadog, etc.)
import * as ErrorTracker from "@error-tracking-provider/sdk";

export function initializeErrorTracking(env: Record<string, unknown>) {
  return ErrorTracker.init({
    dsn: env.ERROR_TRACKING_DSN,
    tracesSampleRate: env.ENVIRONMENT === "production" ? 0.1 : 1.0,
    environment: env.ENVIRONMENT,
  });
}
```

```typescript
// Capture errors manually in business logic
try {
  await performDatabaseMutation();
} catch (error) {
  // Attach context for easier filtering in error tracking service
  ErrorTracker.captureException(error, {
    tags: {
      resource: "user",
      operation: "create",
    },
  });
  throw error; // Re-throw for upstream handling
}
```

</template>

## Request Tracing

<template id="request-tracing">

```typescript
// Add request ID to all responses for client reference in support tickets
app.use("*", async (c, next) => {
  const requestId = c.req.header("x-request-id") ?? crypto.randomUUID();
  await next();
  c.header("X-Request-Id", requestId);
});

// Include requestId in error responses
throw new AppError("INTERNAL_SERVER_ERROR", {
  message: "Something went wrong",
  data: { requestId: context.requestId },
});
```

</template>

## Health Check Endpoint

<template id="health-check">

```typescript
// src/routes/health.ts
app.get("/health", async (c) => {
  const checks = {
    database: false,
    cache: false,
    timestamp: new Date().toISOString(),
  };

  // Database check
  try {
    // Adapt query to your database
    await c.env.DB.prepare("SELECT 1").first();
    checks.database = true;
  } catch (error) {
    c.get("logger").error("health_check_failed", {
      dependency: "database",
      error: String(error),
    });
  }

  // Cache check (if applicable)
  try {
    await c.env.CACHE.get("health-check-key");
    checks.cache = true;
  } catch (error) {
    c.get("logger").error("health_check_failed", {
      dependency: "cache",
      error: String(error),
    });
  }

  // Return 200 if critical dependencies healthy, 503 otherwise
  const allHealthy = checks.database; // Adjust based on critical dependencies
  return c.json(checks, allHealthy ? 200 : 503);
});
```

</template>

## Production Monitoring Checklist

<checklist id="production-readiness">

- [ ] Structured JSON logging with request IDs on all endpoints
- [ ] Error tracking integrated with appropriate sample rate (0.1 prod, 1.0 dev)
- [ ] Health check endpoint that verifies critical dependencies
- [ ] Error responses include requestId for support debugging
- [ ] Sensitive data (tokens, passwords) never logged
- [ ] Request duration measured with performance.now()
- [ ] Log levels used consistently (debug, info, warn, error)

</checklist>

<instructions>

- Always log structured JSON (never unstructured strings)
- Include requestId in every log entry and error response
- Use cloud provider request ID header when available
- Set error tracking sample rate to 0.1 in production (balance observability vs cost)
- Never log sensitive data: passwords, tokens, API keys, PII
- Use performance.now() for accurate request duration measurement
- Add health check endpoint that verifies critical dependencies
- Test health checks in staging before production

</instructions>
