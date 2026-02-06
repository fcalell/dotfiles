---
name: security-audit
description: Security audit patterns for web applications. Use when conducting security reviews, checking authorization, or preventing common vulnerabilities.
---

# Security Audit

## Authorization Pattern
All protected endpoints MUST verify user authorization:

```typescript
// Verify user identity before processing request
if (!user || !user.id) {
  throw new UnauthorizedError("Authentication required");
}

// Verify user has permission for resource
const hasAccess = await checkUserAccess(userId, resourceId);
if (!hasAccess) {
  throw new NotFoundError("Resource not found"); // Don't reveal existence
}
```

## Tenant/Ownership Isolation
Every data query MUST include ownership filter to prevent cross-tenant access:

```typescript
// Single resource query
const resource = await db.query.resources.findFirst({
  where: and(
    eq(resources.id, input.resourceId),
    eq(resources.ownerId, userId), // Ownership filter
  ),
})

// Bulk operations — ALWAYS include ownership filter
await db.delete(resources).where(and(
  inArray(resources.id, input.resourceIds),
  eq(resources.ownerId, userId), // Prevents cross-tenant deletion
))
```

## Enumeration Prevention
Always return NOT_FOUND for both "doesn't exist" and "not authorized":

```typescript
// Correct: Same error for both cases prevents enumeration
throw new NotFoundError("Resource not found")

// Wrong: FORBIDDEN reveals the resource exists
throw new ForbiddenError("Access denied")
```

## Input Validation
Always validate API inputs with schema validation:

```typescript
// Schema validation prevents injection and malformed data
const input = await inputSchema.parseAsync(req.body);

// Use allowlist approach for dynamic inputs
const allowedStatuses = ["active", "inactive", "pending"];
if (!allowedStatuses.includes(input.status)) {
  throw new ValidationError("Invalid status");
}
```

## ORM Safe Queries
Never use raw SQL with user input — use parameterized queries only:

```typescript
// Correct: ORM handles parameterization
const user = await db.query.users.findFirst({
  where: eq(users.email, input.email),
});

// Wrong: Raw SQL with string interpolation (vulnerable)
const user = await db.query(`SELECT * FROM users WHERE email = '${input.email}'`);
```

## Security Audit Checklist
- [ ] All protected endpoints require authentication check
- [ ] Authorization verification before accessing resources
- [ ] Ownership/tenant filter in every database query
- [ ] NOT_FOUND used for both missing and unauthorized resources
- [ ] All API inputs validated with schema
- [ ] No hardcoded credentials or secrets in code
- [ ] Sensitive data (passwords, tokens) never logged
- [ ] HTTPS enforced for all endpoints
- [ ] CORS properly configured
- [ ] Rate limiting on authentication endpoints
- [ ] Bulk operations include ownership filter
- [ ] Only ORM/parameterized queries (no raw SQL with user input)

## Audit Report Format
```
## Security Audit Report

**Scope:** [Feature/Module]
**Date:** [Date]

### Critical Issues
1. [Issue Description]
   - **Location:** file:line
   - **OWASP:** A01 Broken Access Control (or category)
   - **Impact:** [Business/user impact]
   - **Remediation:** [Steps to fix]

### High Issues
1. [Issue Description]
   - **Location:** file:line
   - **OWASP:** [Category]
   - **Remediation:** [Steps to fix]

### Recommendations
- [Best practice improvements]

**Severity Levels:**
- Critical: Immediate exploitation possible
- High: Significant impact on confidentiality/integrity
- Medium: Potential impact, unlikely exploitation
- Low: Best practice improvement
```

## Anti-patterns
- Using FORBIDDEN error code (reveals resource existence)
- Missing ownership filters in queries
- Inconsistent authorization checks across endpoints
- Raw SQL with user input
- Logging sensitive data (tokens, passwords)
- Skipping validation on "internal" operations
- Hard-coded access control checks instead of reusable authorization logic
- Trusting user-supplied IDs without ownership verification
