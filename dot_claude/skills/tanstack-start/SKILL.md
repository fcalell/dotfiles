---
name: tanstack-start
description: TanStack Start meta-framework configuration. Use when setting up app configuration, build setup, SSR vs SPA mode, or deployment.
---

# TanStack Start

Full-stack React meta-framework supporting SPA and SSR deployment modes.

## Configuration Modes

TanStack Start supports two deployment architectures with different config approaches.

### SPA Mode (Client-Only)

```typescript
// vite.config.ts
import { tanstackStart } from "@tanstack/start/config"
import { defineConfig } from "vite"

export default defineConfig(
  tanstackStart({
    spa: { enabled: true }
  })
)
```

**Use when:**
- Static file deployment (Netlify, Vercel, Cloudflare Pages, S3)
- No server-side rendering needed
- Client-side routing sufficient for app
- No server functions or backend-at-edge patterns

**Limitations:**
- No server functions (all APIs from separate backend)
- No middleware execution
- Larger initial JS bundle
- Can't access env secrets on client

### SSR Mode (Server-Rendering)

```typescript
// vite.config.ts
import { tanstackStart } from "@tanstack/start/config"
import { defineConfig } from "vite"

export default defineConfig(
  tanstackStart({
    // No spa config = SSR enabled
  })
)
```

**Use when:**
- Server-side rendering required (SEO, initial load performance)
- Server functions for backend logic
- Cloudflare Workers or similar edge runtime
- Environment secret access from server
- Middleware/auth verification before rendering

**Platform setup:**
- Cloudflare: Add `build.outDir: ".open-next/server"`
- Node: Use standard SSR adapters
- Vercel: Standard SSR deployment

## React Compiler Integration

Enable React Compiler for performance optimization:

```typescript
import { tanstackStart } from "@tanstack/start/config"
import viteReact from "@vitejs/plugin-react"
import { defineConfig } from "vite"

export default defineConfig(
  tanstackStart(),
  viteReact({
    babel: {
      plugins: ["babel-plugin-react-compiler"]
    }
  })
)
```

**Install:** `pnpm add -D babel-plugin-react-compiler`

**Enables:**
- Automatic memoization (no useMemo/useCallback needed)
- Reduced re-renders
- Better performance without manual optimization

## Key Rules

1. **Route context**: Define in `__root.tsx` with `createRootRouteWithContext()`
2. **Environment variables**: Client vars need `VITE_` prefix; server vars access via `process.env`
3. **Root component**: Render `<Outlet />` for route rendering, use `<Scripts />` before close
4. **Build output**: SPA outputs static files; SSR includes server bundle
5. **Data fetching**: Use TanStack Query in SPA; server functions or Query in SSR

## Deployment Checklist

```typescript
// Check before deploying
- [ ] Correct spa vs SSR mode selected
- [ ] Environment variables set (VITE_ prefixed on client)
- [ ] Root route has Outlet and Scripts components
- [ ] React Compiler enabled (if using)
- [ ] Query client initialized in router context
- [ ] Static assets configured correctly
- [ ] Build output matches deployment platform
```

## Anti-Patterns

<anti-patterns id="config-mistakes">
- Using server functions in SPA mode (only work in SSR)
- Missing `VITE_` prefix on client-side environment variables
- Mixing SSR and SPA configurations in same vite.config.ts
- Not initializing QueryClient in router context
- Storing secrets in client-side env vars
- Forgetting to add React Compiler plugin (missing performance gains)
- Using relative imports for root components
</anti-patterns>
