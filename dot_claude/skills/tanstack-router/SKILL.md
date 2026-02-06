---
name: tanstack-router
description: Type-safe routing with TanStack Router. Use when creating routes, route layouts, navigation, protected pages, or search parameters.
---

# TanStack Router

File-based routing with type-safe navigation and built-in data loading.

## Route Structure

```
src/routes/
├── __root.tsx                    # Root layout (entry point)
├── _protected.tsx                # Protected route group (pathless)
├── _protected/
│   ├── dashboard.index.tsx       # /dashboard
│   ├── feature.$id.tsx           # /feature/:id (dynamic segment)
│   └── settings.tsx              # /settings
├── login.tsx                     # /login (public)
└── [notfound].tsx               # 404 fallback
```

**Decision points:**
- Use layout groups (`_protected`) for grouped functionality with shared context
- Use `$segmentName` for dynamic route segments
- Use `.index` for directory root routes
- Keep public routes separate from protected ones

## Core Templates

<template id="router-context">
```tsx
// __root.tsx - Define router context available to all routes
import { createRootRouteWithContext } from "@tanstack/react-router"

export type RouterContext = {
  queryClient: QueryClient
  auth?: { user: User; isPending: boolean }
}

export const Route = createRootRouteWithContext<RouterContext>()({
  head: () => ({ meta: [/* standard meta */] }),
  component: RootComponent,
})

function RootComponent() {
  return (
    <>
      <Header />
      <Outlet />
      <Footer />
    </>
  )
}
```

**Customize:**
- Add any global context that routes need (user, theme, permissions)
- This context flows to all child routes via `Route.useRouteContext()`
</template>

<template id="protected-layout">
```tsx
// _protected.tsx - Protect all routes under this group
import { createFileRoute, redirect, Outlet } from "@tanstack/react-router"

export const Route = createFileRoute("/_protected")({
  beforeLoad: async ({ context, location }) => {
    try {
      // Verify user is authenticated (fetch from context or API)
      if (!context.auth?.user) {
        throw new Error("Not authenticated")
      }
      return {}
    } catch {
      // Redirect to login, preserving original location
      throw redirect({
        to: "/login",
        search: { redirect: location.href }
      })
    }
  },
  component: () => (
    <ProtectedLayout>
      <Outlet />
    </ProtectedLayout>
  ),
})

function ProtectedLayout({ children }) {
  return (
    <div className="flex">
      <Sidebar />
      <main>{children}</main>
    </div>
  )
}
```

**Customize:**
- Replace auth check with your actual authentication method
- Update login redirect path to match your auth route
- Add additional guards (permissions, feature flags, etc.)
</template>

<template id="route-search-params">
```tsx
// _protected/items.tsx - Route with validated search parameters
import { createFileRoute } from "@tanstack/react-router"
import { z } from "zod"

const searchSchema = z.object({
  page: z.coerce.number().default(1),
  limit: z.coerce.number().default(20),
  sort: z.enum(["name", "date", "status"]).optional(),
  filter: z.string().optional(),
})

type ItemsSearch = z.infer<typeof searchSchema>

export const Route = createFileRoute("/_protected/items")({
  validateSearch: (search) => searchSchema.parse(search),
  component: ItemsPage,
})

function ItemsPage() {
  const { page, limit, sort, filter } = Route.useSearch<ItemsSearch>()
  const navigate = Route.useNavigate()

  // Use search params for filtering/pagination without prop drilling
  const { data } = useQuery({
    queryKey: ["items", { page, limit, sort, filter }],
    queryFn: () => fetchItems({ page, limit, sort, filter })
  })

  return (
    <div>
      <ItemsGrid items={data?.items} />
      <Pagination
        current={page}
        onPageChange={(p) => navigate({ search: { ...search, page: p } })}
      />
    </div>
  )
}
```

**Customize:**
- Add/remove fields from searchSchema based on filtering needs
- Use Zod coercion for numeric/enum parameters from URL
- Validate to prevent invalid URL states
</template>

<template id="dynamic-route">
```tsx
// _protected/item.$id.tsx - Route with dynamic parameter
import { createFileRoute, useLoaderData } from "@tanstack/react-router"

export const Route = createFileRoute("/_protected/item/$id")({
  loader: async ({ params }) => {
    // Fetch data for this route before rendering
    return fetchItem(params.id)
  },
  component: ItemDetailPage,
})

function ItemDetailPage() {
  const item = Route.useLoaderData()
  const params = Route.useParams()

  return (
    <div>
      <h1>{item.name}</h1>
      <EditButton itemId={params.id} />
    </div>
  )
}
```

**Customize:**
- Use `loader` for fetching required data before navigation
- Access params via `Route.useParams()`
- Pair with error boundary for failed loads
</template>

<template id="navigation">
```tsx
// Navigate programmatically
const navigate = Route.useNavigate()

// Simple navigation
navigate({ to: "/dashboard" })

// With search params
navigate({
  to: "/items",
  search: { page: 1, filter: "active" }
})

// With hash
navigate({
  to: "/docs",
  hash: "section-1"
})

// Link component for nav UI
import { Link } from "@tanstack/react-router"

<Link to="/item/$id" params={{ id: "123" }}>
  View Item
</Link>
```

**Customize:**
- Use type-safe navigation with params object
- Pass search params to maintain UI state across navigation
</template>

## Key Patterns

1. **Protected routes**: Use layout groups (`_protected`) for auth-required sections
2. **Auth verification**: Check user in `beforeLoad`, redirect to login if missing
3. **Search params**: Validate with Zod to ensure type safety and valid URLs
4. **Context passing**: Access router context via `Route.useRouteContext()`
5. **File-based routing**: Route structure mirrors file paths for clarity
6. **Loaders**: Fetch required data before rendering to avoid loading states

## Anti-Patterns

<anti-patterns id="routing-mistakes">
- Creating protected routes outside protected layout group
- Forgetting to preserve redirect URL on auth failure (users lose context)
- Not validating search parameters (invalid states in URL)
- Data fetching in `beforeLoad` (use loaders or components with TanStack Query)
- Not using `navigate()` for programmatic transitions (manual link construction)
- Mixing routable and non-routable path segments
- Assuming route context without checking it exists
</anti-patterns>
