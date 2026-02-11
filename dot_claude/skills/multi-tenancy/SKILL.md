---
name: multi-tenancy
description: Multi-tenant isolation and RBAC patterns. Use when implementing tenant scoping, role-based access control, resource hierarchies, and authorization checks.
---

# Multi-Tenancy & RBAC

Patterns for tenant isolation, authorization, and role-based access control.

## Tenant Isolation Model

Pool model with shared database and schema, isolated via tenant membership.

<template id="hierarchy-pattern">

```
Tenant (isolation boundary — Organization, Workspace, Team, etc.)
  └── Optional: Nested tier (Sub-organization, Project, Folder, etc.)
        └── Resources (Items, Records, Documents, etc.)

Users belong to Tenants via auth system or dedicated membership table.
Tenant role determines access to all child resources within that tenant.
```

</template>

<template id="rbac-roles">

```typescript
// Define role-to-permission mapping based on your domain
const ROLE_PERMISSIONS: Record<string, string[]> = {
  owner: [
    "tenant:read",
    "tenant:update",
    "tenant:delete",
    "member:*",
    "resource:*",
  ],
  admin: [
    "tenant:read",
    "tenant:update",
    "member:create",
    "member:read",
    "member:update",
    "member:delete",
    "resource:*",
  ],
  editor: [
    "tenant:read",
    "member:read",
    "resource:create",
    "resource:read",
    "resource:update",
  ],
  viewer: ["tenant:read", "member:read", "resource:read"],
  contributor: ["resource:create", "resource:read", "resource:update"],
};

// Domain-specific roles (replace with your actual roles)
// Examples: developer, analyst, moderator, reviewer, author, etc.
```

</template>

<template id="authorization-middleware">

```typescript
// RBAC middleware: check permissions for resource and action
export function authorizationMiddleware(opts: {
  resource: string
  action: string
}) {
  return os.$context<AuthContext>().meta("authz", async (utils) => {
    return async () => {
      const { context } = utils

      // Get user's role for current tenant
      const tenantId = context.session.activeTenantId
      if (!tenantId) {
        throw new Error("BAD_REQUEST: No active tenant")
      }

      const member = await context.db.query.members.findFirst({
        where: and(
          eq(members.tenantId, tenantId),
          eq(members.userId, context.user.id)
        ),
      })

      if (!member) {
        // Prevent enumeration: don't distinguish "not found" vs "access denied"
        throw new Error("NOT_FOUND: Resource not found")
      }

      // Check if user's role has permission for this action
      const permissions = ROLE_PERMISSIONS[member.role] || []
      const requiredPermission = `${opts.resource}:${opts.action}`
      const hasWildcard = permissions.includes(`${opts.resource}:*`)
      const hasPermission =
        permissions.includes(requiredPermission) || hasWildcard

      if (!hasPermission) {
        throw new Error("NOT_FOUND: Resource not found") // Prevent enumeration
      }

      // Continue to next middleware/handler
      return await utils.next()
    }
  })
}

// Usage in procedures
authProcedure
  .use(authorizationMiddleware({ resource: "project", action: "update" }))
  .handler(...)
```

</template>

<template id="tenant-filtering-in-queries">

```typescript
// Always filter by tenant in queries (defense in depth)
const resources = await db.query.{resourceTable}.findMany({
  where: eq({resourceTable}.tenantId, input.tenantId),
})

// Explicit tenant filter in joins (prevent cross-tenant leakage)
const resources = await db
  .select()
  .from({resourceTable})
  .leftJoin(
    {relatedTable},
    and(
      eq({resourceTable}.id, {relatedTable}.resourceId),
      eq({relatedTable}.tenantId, input.tenantId) // Ensure join is tenant-scoped
    )
  )
  .where(eq({resourceTable}.tenantId, input.tenantId))

// Bulk operations must include tenant filter
const updated = await db
  .update({resourceTable})
  .set({ status: "archived" })
  .where(
    and(
      inArray({resourceTable}.id, input.ids),
      eq({resourceTable}.tenantId, input.tenantId) // Filter by tenant
    )
  )
  .returning()

// Count queries must also be tenant-scoped
const [{ count }] = await db
  .select({ count: sql`count(*)` })
  .from({resourceTable})
  .where(eq({resourceTable}.tenantId, input.tenantId))
```

</template>

<template id="schema-requirements">

```typescript
// All tables must have tenant column for isolation
tenantId: text("tenant_id").notNull(),

// Parent references cascade on delete (cleanup child resources)
parentId: text("parent_id")
  .notNull()
  .references(() => parentTable.id, { onDelete: "cascade" }),

// Index tenant and parent columns for query performance
index("idx_{resource}_tenant").on({resourceTable}.tenantId),
index("idx_{resource}_parent").on({resourceTable}.parentId),

// Composite index for common filter patterns
index("idx_{resource}_tenant_created").on(
  {resourceTable}.tenantId,
  {resourceTable}.createdAt
),

// Unique constraints must include tenant (allow same slug per tenant)
unique("unique_{resource}_slug").on({resourceTable}.tenantId, {resourceTable}.slug),
```

</template>

<template id="enumeration-prevention">

```typescript
// Anti-pattern: reveals resource existence
if (!resource) {
  throw new Error("FORBIDDEN: Access denied"); // Client learns resource exists
}

// Correct: prevents enumeration
if (!resource) {
  throw new Error("NOT_FOUND: Resource not found"); // Same error for "not found" and "no access"
}

// This forces attacker to use timing attacks or other side-channels
// Much harder than simple error code enumeration
```

</template>

<template id="membership-table">

```typescript
// Store tenant memberships (for multi-tenant auth systems)
export const members = sqliteTable(
  "members",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => createId()),
    tenantId: text("tenant_id")
      .notNull()
      .references(() => tenants.id, { onDelete: "cascade" }),
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    role: text("role", {
      enum: ["owner", "admin", "editor", "viewer", "contributor"],
    })
      .notNull()
      .default("viewer"),
    invitedBy: text("invited_by"),
    acceptedAt: integer("accepted_at", { mode: "timestamp" }),
    createdAt: integer("created_at", { mode: "timestamp" }).$defaultFn(
      () => new Date(),
    ),
  },
  (table) => [
    unique("unique_member").on(table.tenantId, table.userId),
    index("idx_members_tenant").on(table.tenantId),
    index("idx_members_user").on(table.userId),
  ],
);
```

</template>

<template id="session-context">

```typescript
// Better Auth additional fields: store active tenant context
session: {
  additionalFields: {
    activeTenantId: {
      type: "string" as const,
      required: false,
    },
  },
  expiresIn: 60 * 60 * 24 * 7,
}

// Procedure: set active tenant
const setActiveTenant = authProcedure
  .input(z.object({ tenantId: z.string() }))
  .handler(async ({ input, context }) => {
    // Verify user is member of this tenant
    const member = await context.db.query.members.findFirst({
      where: and(
        eq(members.tenantId, input.tenantId),
        eq(members.userId, context.user.id)
      ),
    })

    if (!member) {
      throw new Error("NOT_FOUND: Tenant not found")
    }

    // Update session (provider-specific)
    await updateSession(context, {
      activeTenantId: input.tenantId,
    })

    return { success: true }
  })
```

</template>

<instructions>

1. Use `authorizationMiddleware` for all tenant/resource operations
2. Always filter queries by tenant, even after middleware checks (defense in depth)
3. Use `NOT_FOUND` (not `FORBIDDEN`) to prevent resource enumeration
4. Index `tenantId` and parent columns for query performance
5. Use cascade deletes on child tables for data integrity
6. Implement both middleware and query-level filtering (layered defense)
7. Define role-permission matrix based on your domain (owner, admin, editor, etc.)
8. Validate tenant context in every procedure requiring tenant scope
9. Store tenant memberships with roles in dedicated table or auth plugin
10. Test authorization with different roles and tenants before deployment

</instructions>
