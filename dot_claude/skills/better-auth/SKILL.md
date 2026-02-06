---
name: better-auth
description: Authentication and session management patterns with Better Auth. Use when configuring auth, managing sessions, social providers, schema extensions, and type safety.
---

# Better Auth

Authentication framework with extensible schema and plugin support.

**Reference: [better-auth.com/docs](https://better-auth.com/docs)**

<template id="install-setup">

```bash
npm install better-auth

# Environment variables (REQUIRED)
# Generate secret: openssl rand -base64 32 (minimum 32 characters)
BETTER_AUTH_SECRET=your-secret-here
# Must match your deployment domain (used for CSRF and cookie validation)
BETTER_AUTH_URL=http://localhost:3000 # or https://yourdomain.com
```

</template>

<template id="server-config">

```typescript
import { betterAuth } from "better-auth"
import { drizzleAdapter } from "better-auth/adapters/drizzle"
import { twoFactor, passkey } from "better-auth/plugins"

export const auth = betterAuth({
  database: drizzleAdapter(db, { provider: "sqlite" }), // or postgres, mysql

  // Authentication methods
  emailAndPassword: { enabled: true },

  // Social providers (optional)
  socialProviders: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    },
    github: {
      clientId: process.env.GITHUB_CLIENT_ID!,
      clientSecret: process.env.GITHUB_CLIENT_SECRET!,
    },
    // Add more: apple, facebook, microsoft, discord, etc.
  },

  // Plugins extend auth functionality
  plugins: [
    twoFactor(),      // Two-factor authentication
    passkey(),        // Passkeys/WebAuthn
    // emailVerification(), // Email verification
    // organization(),    // Multi-tenant organizations
  ],

  // CSRF protection: list all domains your frontend runs on
  trustedOrigins: [
    process.env.NODE_ENV === "production"
      ? "https://app.yourdomain.com"
      : ["http://localhost:3000", "http://localhost:5173"],
  ],

  // Session configuration
  session: {
    expiresIn: 60 * 60 * 24 * 7, // 7 days
    updateAge: 60 * 60 * 24, // Re-issue after 1 day
  },

  // Advanced: Use secure cookies in production
  advanced: {
    useSecureCookies: process.env.NODE_ENV === "production",
  },
})
```

</template>

<template id="client-config">

```typescript
import { createAuthClient } from "better-auth/react"
import type { typeof auth } from "./auth"

export const authClient = createAuthClient<typeof auth>({
  baseURL: process.env.REACT_APP_API_URL || "http://localhost:3000",
})

// Exports: signIn, signUp, signOut, useSession, getSession
export const {
  signIn,
  signUp,
  signOut,
  useSession,
  getSession,
} = authClient
```

</template>

<template id="hono-handler">

```typescript
import { auth } from "./auth"

// Mount auth handler on Hono app
app.all("/api/auth/*", (c) => auth.handler(c.req.raw))
```

</template>

<template id="extending-schema">

```typescript
// Never manually edit auth-schema.ts (it's auto-generated)

// 1. Define custom session fields in auth config
export const auth = betterAuth({
  // ... other config

  session: {
    additionalFields: {
      // Store active tenant/workspace context
      activeTenantId: {
        type: "string" as const,
        required: false,
      },
      activeWorkspaceId: {
        type: "string" as const,
        required: false,
      },
      // Domain-specific fields (permissions, flags, etc.)
      role: {
        type: "string" as const,
        required: false,
      },
    },
    expiresIn: 60 * 60 * 24 * 7,
  },
})

// 2. Type safety: infer session type
export type Session = typeof auth.$Infer.Session

// 3. After modifying config, regenerate schema
// Run: npx better-auth generate (or drizzle-kit introspect if using schema file)
// This updates auth-schema.ts (do NOT manually edit)

// 4. Update session after authentication (e.g., when user selects tenant)
const { data, error } = await authClient.updateUser({
  activeTenantId: tenantId,
})
```

</template>

<template id="type-safety">

```typescript
// Infer session type
export type Session = typeof auth.$Infer.Session

// Use in components
const MyComponent = () => {
  const { data: session } = useSession()

  if (!session) return <div>Not logged in</div>

  return (
    <div>
      {session.user.email}
      {session.activeTenantId && <p>Tenant: {session.activeTenantId}</p>}
    </div>
  )
}

// Type-safe client for separate frontend
export const authClient = createAuthClient<typeof auth>()
```

</template>

<template id="social-provider-setup">

```typescript
// Google OAuth
socialProviders: {
  google: {
    clientId: process.env.GOOGLE_CLIENT_ID!,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
  },
}

// GitHub OAuth
socialProviders: {
  github: {
    clientId: process.env.GITHUB_CLIENT_ID!,
    clientSecret: process.env.GITHUB_CLIENT_SECRET!,
  },
}

// Multiple providers
socialProviders: {
  google: { clientId: "...", clientSecret: "..." },
  github: { clientId: "...", clientSecret: "..." },
  microsoft: { clientId: "...", clientSecret: "..." },
  discord: { clientId: "...", clientSecret: "..." },
}
```

</template>

<template id="session-retrieval">

```typescript
// Server-side: get session from request
const session = await auth.api.getSession(request)
if (!session) {
  return new Response("Unauthorized", { status: 401 })
}

// Client-side: use hook
const { data: session, isPending } = useSession()

// Manual client-side: fetch session
const session = await authClient.getSession()

// With custom context
const session = await auth.getSession(request.headers.get("cookie"))
```

</template>

<instructions>

1. Set `BETTER_AUTH_SECRET` (32+ chars minimum, generate with openssl rand -base64 32)
2. Set `BETTER_AUTH_URL` to match your deployment domain
3. Configure `trustedOrigins` for CSRF protection (never use wildcard)
4. Enable plugins (twoFactor, passkey, organization) as needed
5. Never manually edit auth-schema.ts (use additionalFields in config instead)
6. Re-run schema generation after adding plugins or modifying session config
7. Use `useSecureCookies: true` in production
8. Enable email verification for sensitive deployments
9. Test OAuth redirects locally with proper callback URLs
10. Store session type safely for type-safe client usage

</instructions>

<anti-patterns>

- Manually editing auth-schema.ts (gets overwritten)
- Missing BETTER_AUTH_SECRET or weak secret (< 32 chars)
- Disabling CSRF protection
- Using insecure cookies in production (useSecureCookies: false)
- Forgetting to regenerate schema after adding plugins
- Hardcoding secrets (use environment variables)
- Missing trustedOrigins (enables CSRF attacks)
- Not testing OAuth callback URLs in deployment environment
- Storing tokens in localStorage (use httpOnly cookies)
- Not handling session expiration on client

</anti-patterns>
