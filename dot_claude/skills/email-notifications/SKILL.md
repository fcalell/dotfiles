---
name: email-notifications
description: Transactional email and in-app notification patterns. Use when building email sending, notification systems, user communication flows, or async email delivery.
---

# Email & Notifications

Patterns for transactional email, queue-based delivery, and in-app notifications.

## Email Provider Integration

Use any HTTP-based email service (Resend, SendGrid, Mailgun, AWS SES, etc.).

<template id="email-client-setup">

```typescript
// Generic email client wrapper
export interface EmailProvider {
  send(opts: {
    to: string;
    subject: string;
    html: string;
    from?: string;
    replyTo?: string;
  }): Promise<{ messageId: string }>;
}

// Resend implementation
import { Resend } from "resend";

export function createEmailClient(apiKey: string): EmailProvider {
  const resend = new Resend(apiKey);
  return {
    async send(opts) {
      const { data, error } = await resend.emails.send({
        from: opts.from ?? "noreply@yourdomain.com",
        to: opts.to,
        subject: opts.subject,
        html: opts.html,
        replyTo: opts.replyTo,
      });
      if (error) throw new Error(`Email failed: ${error.message}`);
      return { messageId: data.id };
    },
  };
}

// SendGrid implementation
import sgMail from "@sendgrid/mail";

export function createSendGridClient(apiKey: string): EmailProvider {
  sgMail.setApiKey(apiKey);
  return {
    async send(opts) {
      const [{ headers }] = await sgMail.send({
        from: opts.from ?? "noreply@yourdomain.com",
        to: opts.to,
        subject: opts.subject,
        html: opts.html,
        replyTo: opts.replyTo,
      });
      return { messageId: headers["x-message-id"] };
    },
  };
}
```

</template>

<template id="email-in-procedure">

```typescript
// Send transactional email directly from procedure (fire-and-forget)
const sendInvite = authProcedure
  .input(
    z.object({
      recipientEmail: z.string().email(),
      tenantName: z.string(),
    }),
  )
  .use(authorizationMiddleware({ resource: "member", action: "invite" }))
  .handler(async ({ input, context }) => {
    const emailClient = createEmailClient(context.env.EMAIL_API_KEY);

    // Create invitation record in database
    const inviteToken = crypto.randomUUID();
    const [invite] = await context.db
      .insert(invitations)
      .values({
        id: createId(),
        tenantId: context.session.activeTenantId,
        email: input.recipientEmail,
        token: inviteToken,
        createdAt: new Date(),
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days
      })
      .returning();

    // Send email (fire-and-forget)
    try {
      await emailClient.send({
        to: input.recipientEmail,
        subject: `You're invited to join ${input.tenantName}`,
        html: renderEmailTemplate("invite", {
          inviteUrl: `https://yourdomain.com/invites/${inviteToken}`,
          tenantName: input.tenantName,
        }),
      });
    } catch (error) {
      console.error("Failed to send invite email:", error);
      // Don't fail the procedure — email is best-effort
    }

    return { success: true, inviteId: invite.id };
  });
```

</template>

## Queue-Based Email (Reliable Delivery)

For critical emails, use async queues to decouple sending from the request.

<template id="queue-email-pattern">

```typescript
// Define queue message type
interface EmailQueueMessage {
  to: string;
  subject: string;
  template: string;
  data: Record<string, any>;
  retries?: number;
}

// Producer: queue email from any procedure
const sendPasswordReset = baseProcedure
  .input(z.object({ email: z.string().email() }))
  .handler(async ({ input, context }) => {
    const resetToken = crypto.randomUUID();

    // Create password reset record
    await context.db.insert(passwordResets).values({
      id: createId(),
      email: input.email,
      token: resetToken,
      createdAt: new Date(),
    });

    // Queue the email for async delivery
    await context.env.EMAIL_QUEUE?.send({
      to: input.email,
      subject: "Reset your password",
      template: "password-reset",
      data: { resetUrl: `https://yourdomain.com/reset/${resetToken}` },
    });

    return { success: true, message: "Check your email for reset link" };
  });

// Consumer: process email queue (in separate worker/service)
export default {
  async queue(batch: MessageBatch<EmailQueueMessage>, env: Bindings) {
    const emailClient = createEmailClient(env.EMAIL_API_KEY);

    for (const msg of batch.messages) {
      try {
        const html = renderEmailTemplate(msg.body.template, msg.body.data);

        await emailClient.send({
          to: msg.body.to,
          subject: msg.body.subject,
          html,
        });

        msg.ack(); // Mark as successfully sent
      } catch (error) {
        console.error("Email send failed:", {
          error,
          template: msg.body.template,
          recipient: msg.body.to,
          attempts: msg.attempts,
        });

        // Retry with exponential backoff
        if (msg.attempts < 3) {
          msg.retry({
            delaySeconds: Math.pow(2, msg.attempts) * 60, // 1min, 2min, 4min
          });
        } else {
          // After max retries, message goes to dead letter queue
        }
      }
    }
  },
};
```

</template>

## In-App Notifications

Store notifications in database, poll via client.

<template id="notifications-schema">

```typescript
export const notifications = sqliteTable(
  "notifications",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => createId()),
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    tenantId: text("tenant_id").notNull(), // Tenant context
    type: text("type").notNull(), // "invite", "alert", "update", etc.
    title: text("title").notNull(),
    body: text("body"),
    href: text("href"), // Link to relevant resource
    read: integer("read", { mode: "boolean" }).notNull().default(false),
    readAt: integer("read_at", { mode: "timestamp" }),
    createdAt: integer("created_at", { mode: "timestamp" }).$defaultFn(
      () => new Date(),
    ),
  },
  (table) => [
    // Composite index for common query: get unread for user
    index("idx_notifications_user_unread").on(table.userId, table.read),
    index("idx_notifications_tenant").on(table.tenantId),
  ],
);

// Procedure to list notifications
const listNotifications = authProcedure
  .input(z.object({ unreadOnly: z.boolean().default(false) }))
  .handler(async ({ input, context }) => {
    let query = context.db
      .select()
      .from(notifications)
      .where(eq(notifications.userId, context.user.id));

    if (input.unreadOnly) {
      query = query.where(eq(notifications.read, false));
    }

    return await query.orderBy(desc(notifications.createdAt)).limit(50);
  });

// Procedure to mark as read
const markNotificationRead = authProcedure
  .input(z.object({ id: z.string() }))
  .handler(async ({ input, context }) => {
    const [updated] = await context.db
      .update(notifications)
      .set({ read: true, readAt: new Date() })
      .where(
        and(
          eq(notifications.id, input.id),
          eq(notifications.userId, context.user.id),
        ),
      )
      .returning();

    return updated;
  });
```

Client-side polling:

```typescript
// React Query / TanStack Query
const { data: notifications, isLoading } = useQuery({
  queryKey: ["notifications"],
  queryFn: () => orpc.notifications.list.query({ unreadOnly: true }),
  refetchInterval: 30000, // Poll every 30 seconds
});
```

</template>

## Email Templates

Keep templates as simple TypeScript functions returning HTML.

<template id="email-templates">

```typescript
// Template registry
export function renderEmailTemplate(
  type: string,
  data: Record<string, any>,
): string {
  const templates: Record<string, (data: any) => string> = {
    welcome: (d) => `
      <div style="font-family: system-ui, sans-serif; max-width: 600px; margin: 0 auto;">
        <h1>Welcome to ${d.appName}</h1>
        <p>Hi ${d.userName},</p>
        <p>Your account is ready. Click below to get started.</p>
        <a href="${d.appUrl}" style="display: inline-block; padding: 12px 24px; background: #2563eb; color: white; text-decoration: none; border-radius: 6px;">
          Get Started
        </a>
      </div>
    `,

    invite: (d) => `
      <div style="font-family: system-ui, sans-serif; max-width: 600px; margin: 0 auto;">
        <h1>You're invited</h1>
        <p>Join <strong>${d.tenantName}</strong>.</p>
        <p>
          <a href="${d.inviteUrl}" style="display: inline-block; padding: 12px 24px; background: #2563eb; color: white; text-decoration: none; border-radius: 6px;">
            Accept Invitation
          </a>
        </p>
        <p style="color: #666; font-size: 12px;">
          This invite expires in 7 days.
        </p>
      </div>
    `,

    "password-reset": (d) => `
      <div style="font-family: system-ui, sans-serif; max-width: 600px; margin: 0 auto;">
        <h1>Reset your password</h1>
        <p>Click the link below to create a new password:</p>
        <p>
          <a href="${d.resetUrl}" style="display: inline-block; padding: 12px 24px; background: #2563eb; color: white; text-decoration: none; border-radius: 6px;">
            Reset Password
          </a>
        </p>
        <p style="color: #666; font-size: 12px;">
          This link expires in 1 hour. If you didn't request this, ignore this email.
        </p>
      </div>
    `,

    notification: (d) => `
      <div style="font-family: system-ui, sans-serif; max-width: 600px; margin: 0 auto;">
        <h1>${d.title}</h1>
        <p>${d.body}</p>
        ${d.actionUrl ? `<a href="${d.actionUrl}" style="display: inline-block; padding: 12px 24px; background: #2563eb; color: white; text-decoration: none; border-radius: 6px;">View</a>` : ""}
      </div>
    `,
  };

  const template = templates[type];
  if (!template) {
    return `<p>Email notification: ${type}</p>`;
  }

  return template(data);
}
```

</template>

<instructions>

- Choose a transactional email provider (Resend, SendGrid, Mailgun, SES)
- Queue critical emails (invites, password resets) for reliable delivery
- Fire-and-forget is acceptable for non-critical notifications
- Store in-app notifications in database with userId + read status
- Index userId + read for efficient polling
- Poll in-app notifications with client-side queries (30s interval is typical)
- Keep email templates as plain TypeScript functions returning HTML
- Never store provider API keys in code; use environment variables
- Test email delivery in development before production deployment
- Implement dead letter queue for failed email delivery

</instructions>
