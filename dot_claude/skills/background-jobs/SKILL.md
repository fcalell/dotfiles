---
name: background-jobs
description: Async processing and scheduled jobs patterns. Use when implementing background tasks, event-driven workflows, task queues, and scheduled jobs.
---

# Background Jobs & Async Processing

Patterns for async task processing, scheduling, and event-driven workflows.

## Task Queues

Fire-and-forget async processing for expensive operations.

<template id="queue-setup">

```typescript
// Define queue message types
interface TaskQueueMessage {
  type: string // Task identifier
  tenantId?: string
  userId?: string
  data: Record<string, any>
  timestamp: number
}

// Producer: queue a task from any procedure
const exportData = authProcedure
  .input(z.object({ format: z.enum(["json", "csv"]) }))
  .handler(async ({ input, context }) => {
    const exportId = createId()

    // Create export record in database
    const [exportRecord] = await context.db.insert(exports).values({
      id: exportId,
      tenantId: context.session.activeTenantId,
      userId: context.user.id,
      format: input.format,
      status: "queued",
      createdAt: new Date(),
    }).returning()

    // Queue the task (using your queue provider)
    await context.env.TASK_QUEUE?.send({
      type: "export_data",
      tenantId: context.session.activeTenantId,
      userId: context.user.id,
      data: {
        exportId,
        format: input.format,
      },
      timestamp: Date.now(),
    })

    return { success: true, exportId, status: "queued" }
  })
```

</template>

<template id="consumer-handler">

```typescript
// Consumer: process queued tasks
export default {
  async queue(batch: MessageBatch<TaskQueueMessage>, env: Bindings) {
    for (const msg of batch.messages) {
      try {
        // Route task to appropriate handler
        switch (msg.body.type) {
          case "export_data":
            await handleExportData(msg.body.data, env)
            break
          case "send_notification":
            await handleNotification(msg.body.data, env)
            break
          case "sync_external":
            await handleExternalSync(msg.body.data, env)
            break
          default:
            console.warn("Unknown task type:", msg.body.type)
        }

        msg.ack() // Mark as successfully processed
      } catch (error) {
        console.error("Task processing failed:", {
          error,
          type: msg.body.type,
          attempt: msg.attempts,
        })

        // Retry with exponential backoff
        if (msg.attempts < 3) {
          const delaySeconds = Math.pow(2, msg.attempts) * 10 // 10s, 20s, 40s
          msg.retry({ delaySeconds })
        } else {
          // After max retries, message goes to dead letter queue
        }
      }
    }
  },
}

// Task handlers
async function handleExportData(data: any, env: Bindings) {
  const db = createDbClient(env.DB)
  const [exportRecord] = await db
    .update(exports)
    .set({ status: "processing" })
    .where(eq(exports.id, data.exportId))
    .returning()

  try {
    // Generate export file
    const items = await db
      .select()
      .from(items as any)
      .where(eq((items as any).tenantId, data.tenantId))

    const content =
      data.format === "json" ? JSON.stringify(items) : convertToCSV(items)

    // Store in object storage
    if (env.BUCKET) {
      const key = `exports/${data.tenantId}/${data.exportId}.${data.format}`
      await env.BUCKET.put(key, content)
    }

    // Mark complete
    await db
      .update(exports)
      .set({ status: "completed", completedAt: new Date() })
      .where(eq(exports.id, data.exportId))
  } catch (error) {
    await db
      .update(exports)
      .set({ status: "failed", error: String(error) })
      .where(eq(exports.id, data.exportId))
    throw error
  }
}

async function handleNotification(data: any, env: Bindings) {
  const emailClient = createEmailClient(env.EMAIL_API_KEY)

  await emailClient.send({
    to: data.email,
    subject: data.subject,
    html: data.html,
  })
}
```

</template>

<template id="dead-letter-queue">

```typescript
// Dead letter queue: handle messages that fail after max retries
export const dlqHandler = {
  async queue(batch: MessageBatch<TaskQueueMessage>, env: Bindings) {
    for (const msg of batch.messages) {
      console.error("DEAD LETTER:", {
        type: msg.body.type,
        data: msg.body.data,
        attempts: msg.attempts,
      })

      // Alert via monitoring service
      try {
        await fetch("https://monitoring.example.com/alert", {
          method: "POST",
          body: JSON.stringify({
            severity: "error",
            message: `Task ${msg.body.type} failed after ${msg.attempts} attempts`,
            data: msg.body,
          }),
        })
      } catch (error) {
        console.error("Failed to send alert:", error)
      }

      msg.ack() // Mark DLQ message as processed
    }
  },
}
```

</template>

## Scheduled Jobs (Cron)

Recurring tasks on a schedule.

<template id="cron-triggers">

```typescript
// Scheduled event handler
export default {
  async scheduled(event: ScheduledEvent, env: Bindings) {
    try {
      // Route based on cron pattern
      switch (event.cron) {
        case "0 0 * * *": // Daily at midnight UTC
          await performDailyCleanup(env)
          break

        case "0 */6 * * *": // Every 6 hours
          await aggregateMetrics(env)
          break

        case "*/5 * * * *": // Every 5 minutes
          await healthCheck(env)
          break

        default:
          console.log("Scheduled event:", event.cron)
      }
    } catch (error) {
      console.error("Scheduled job failed:", error)
      // Alert via monitoring service
      await alertMonitoring(env, {
        type: "cron_failure",
        cron: event.cron,
        error: String(error),
      })
    }
  },
}

// Cleanup job: delete stale data
async function performDailyCleanup(env: Bindings) {
  const db = createDbClient(env.DB)

  // Delete expired invitations
  const result = await db
    .delete(invitations)
    .where(lt(invitations.expiresAt, new Date()))

  console.log(`Deleted ${result.changes} expired invitations`)

  // Delete old sessions
  const oldSessions = await db
    .delete(sessions)
    .where(lt(sessions.expiresAt, new Date()))

  console.log(`Deleted ${oldSessions.changes} expired sessions`)

  // Soft-delete old records (mark as archived after 90 days)
  await db
    .update(projects)
    .set({ archivedAt: new Date() })
    .where(and(
      lt(projects.updatedAt, new Date(Date.now() - 90 * 24 * 60 * 60 * 1000)),
      isNull(projects.archivedAt),
    ))
}

// Metrics aggregation job
async function aggregateMetrics(env: Bindings) {
  const db = createDbClient(env.DB)

  // Summarize usage data
  const metrics = await db
    .select({
      date: sql`date(${events.createdAt})`,
      count: sql`count(*)`,
    })
    .from(events)
    .groupBy(sql`date(${events.createdAt})`)

  // Store aggregates
  for (const metric of metrics) {
    await db.insert(dailyMetrics).values({
      id: createId(),
      date: metric.date,
      eventCount: metric.count,
      recordedAt: new Date(),
    })
  }

  console.log(`Aggregated ${metrics.length} daily metrics`)
}

// Health check job
async function healthCheck(env: Bindings) {
  const db = createDbClient(env.DB)

  try {
    // Simple query to verify database connectivity
    await db.select().from(users).limit(1)
    console.log("Health check passed")
  } catch (error) {
    console.error("Health check failed:", error)
    throw error
  }
}

// Helper to alert monitoring service
async function alertMonitoring(
  env: Bindings,
  alert: Record<string, any>
) {
  try {
    await fetch("https://monitoring.example.com/alerts", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(alert),
    })
  } catch {
    console.error("Failed to send alert")
  }
}
```

Test locally: `wrangler dev --test-scheduled` → `curl http://localhost:8787/__scheduled`

</template>

## Stateful Workflows (Durable Objects)

For workflows requiring coordinated state across multiple steps.

<template id="durable-object">

```typescript
// Durable Object for multi-step workflows
export class ExportWorkflow implements DurableObject {
  constructor(
    private state: DurableObjectState,
    private env: Bindings
  ) {}

  async fetch(request: Request) {
    const { action, ...data } = await request.json<{ action: string }>()

    switch (action) {
      case "start": {
        // Initialize workflow
        await this.state.storage.put("status", "processing")
        await this.state.storage.put("data", JSON.stringify(data))
        await this.state.storage.put("startedAt", Date.now())

        // Set timeout alarm (30 minutes)
        await this.state.storage.setAlarm(
          Date.now() + 30 * 60 * 1000
        )

        return new Response(
          JSON.stringify({
            workflowId: request.url,
            status: "started",
          })
        )
      }

      case "status": {
        // Get current workflow status
        const status = await this.state.storage.get("status")
        const progress = await this.state.storage.get("progress")

        return new Response(
          JSON.stringify({ status, progress })
        )
      }

      case "step": {
        // Execute next workflow step
        const currentData = await this.state.storage.get("data")
        const updated = await this.executeStep(currentData, data)

        await this.state.storage.put("data", JSON.stringify(updated))
        await this.state.storage.put("progress", data.stepNumber)

        return new Response(
          JSON.stringify({ status: "step_completed" })
        )
      }

      default:
        return new Response("Unknown action", { status: 400 })
    }
  }

  async alarm() {
    // Handle workflow timeout
    const status = await this.state.storage.get("status")

    if (status === "processing") {
      await this.state.storage.put("status", "timeout")
      console.error("Workflow timed out")

      // Notify user or cleanup
    }
  }

  private async executeStep(data: any, step: any) {
    // Multi-step processing (e.g., export generation)
    // Return updated data
    return { ...data, step: step.stepNumber }
  }
}
```

Use Durable Objects only when you need:
- Coordinated state across multiple requests
- Long-lived WebSocket connections
- Exactly-once processing guarantees

For simple fire-and-forget tasks, use Queues instead.

</template>

<instructions>

1. Use Queues for fire-and-forget async tasks (exports, notifications, webhooks)
2. Use Cron Triggers for scheduled recurring work (cleanup, aggregation)
3. Use Durable Objects only for stateful coordination (rare, use Queues first)
4. Always include a dead letter queue for production tasks
5. Implement exponential backoff on retries: `delaySeconds: Math.pow(2, attempts) * 10`
6. Include message type in queue payloads for routing in consumer
7. Keep consumers idempotent (at-least-once delivery means possible duplicates)
8. Log all task failures with context for debugging
9. Monitor dead letter queues for persistent failures
10. Test scheduled jobs locally before deployment

</instructions>

<anti-patterns>

- Using Durable Objects for simple async tasks (Queues are cheaper and simpler)
- Missing dead letter queue (failed messages disappear)
- No exponential backoff on retries (hammers failing services)
- Consumer logic that isn't idempotent (duplicates cause bugs)
- Putting heavy computation in request path (queue it instead)
- Cron jobs without error handling (one failure stops entire scheduled handler)
- Not logging task failures (hard to debug)
- Missing task type in queue messages (can't route to handlers)
- No monitoring of dead letter queue (missed failures)
- Testing queues only in production (test locally first)

</anti-patterns>
