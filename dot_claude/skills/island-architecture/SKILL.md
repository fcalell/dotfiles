---
name: island-architecture
description: Self-contained components that own their data. Use when building feature pages, grids, cards, dialogs, or any component that fetches its own data.
---

# Island Architecture

Components are organized as self-contained data-fetching units. Parent components handle layout; islands handle data, state, and presentation.

## Component Classification

<template id="island">

Self-contained unit that fetches data, handles loading/error/empty states. Receives config as props, not data.

```tsx
export function ResourceGrid({ status, limit }: Props) {
  // 1. Fetch data based on props (filters, pagination)
  const { data, isPending, error } = useQuery({
    queryKey: ["resources", { status, limit }],
    queryFn: async () => {
      const res = await fetch(`/api/resources?status=${status}&limit=${limit}`)
      return res.json()
    }
  })

  // 2. Handle loading state
  if (isPending) return <ResourceSkeleton count={limit} />

  // 3. Handle error state
  if (error) return (
    <ErrorState
      title="Failed to load resources"
      action={() => window.location.reload()}
    />
  )

  // 4. Handle empty state
  if (data.length === 0) return <EmptyResourceState />

  // 5. Render presentation layer with data
  return (
    <div className="grid grid-cols-3 gap-4">
      {data.map(resource => (
        <ResourceCard key={resource.id} resource={resource} />
      ))}
    </div>
  )
}
```

**Key traits:**
- Fetches all its own data
- Handles all loading/error/empty states inline
- Receives config (filters, IDs) as props, never fetched data
- Children are presentation components receiving data

</template>

<template id="layout">

Orchestrates islands and manages page structure. No data fetching.

```tsx
export function ResourcesPage() {
  const [isCreateOpen, setIsCreateOpen] = useState(false)

  return (
    <div className="space-y-6">
      {/* Header with actions */}
      <div className="flex justify-between items-center">
        <h1>Resources</h1>
        <button onClick={() => setIsCreateOpen(true)}>
          Create Resource
        </button>
      </div>

      {/* Island: handles its own data fetching */}
      <ResourceGrid status="active" limit={12} />

      {/* Island: dialog fetches dependencies */}
      <CreateResourceDialog
        open={isCreateOpen}
        onOpenChange={setIsCreateOpen}
      />
    </div>
  )
}
```

**Key traits:**
- No data fetching (only composition)
- Manages UI state (dialogs, filters, layout)
- Passes config to islands, not data
- Orchestrates multiple islands

</template>

<template id="presentation">

Pure rendering layer receiving data as props. No hooks, no state, no fetching.

```tsx
export function ResourceCard({ resource }: { resource: Resource }) {
  return (
    <div className="border rounded p-4">
      <h3>{resource.name}</h3>
      <p>{resource.description}</p>
      <div className="text-sm text-gray-600">
        {resource.status} • {resource.owner}
      </div>
    </div>
  )
}
```

**Key traits:**
- Pure function receiving data
- Only renders, no logic
- Reusable across different contexts
- Testable without mocking data fetching

</template>

<template id="skeleton">

Loading placeholder matching presentation structure.

```tsx
const skeletonIds = Array.from({ length: 6 }, (_, i) => `sk-${i}`)

export function ResourceSkeleton({ count = 6 }: Props) {
  return (
    <div className="grid grid-cols-3 gap-4">
      {skeletonIds.slice(0, count).map(id => (
        <div key={id} className="border rounded p-4 animate-pulse">
          <div className="h-6 bg-gray-300 rounded mb-2"></div>
          <div className="h-4 bg-gray-200 rounded"></div>
        </div>
      ))}
    </div>
  )
}
```

**Key traits:**
- Matches grid/layout of presentation layer
- Uses stable keys (prevents re-renders)
- Shows during data fetching
- Same visual grid as actual content

</template>

<template id="empty-state">

Shown when island has no data. Often triggers dialogs.

```tsx
export function EmptyResourceState() {
  const [isCreateOpen, setIsCreateOpen] = useState(false)

  return (
    <>
      <div className="text-center py-12">
        <h3>No resources yet</h3>
        <p>Create your first resource to get started.</p>
        <button onClick={() => setIsCreateOpen(true)}>
          Create Resource
        </button>
      </div>

      <CreateResourceDialog
        open={isCreateOpen}
        onOpenChange={setIsCreateOpen}
      />
    </>
  )
}
```

**Key traits:**
- Encourages action (dialog trigger)
- Self-contained (can fetch dependencies)
- Clear, helpful messaging

</template>

<template id="dialog-island">

Dialog fetches its own dependencies and handles mutations.

```tsx
import { useMutation, useQueryClient } from "@tanstack/react-query"

export function CreateResourceDialog({ open, onOpenChange }: Props) {
  const queryClient = useQueryClient()

  // Island: fetches its own dependencies
  const { data: categories } = useQuery({
    queryKey: ["categories"],
    queryFn: async () => {
      const res = await fetch("/api/categories")
      return res.json()
    }
  })

  // Mutation with cache invalidation
  const mutation = useMutation({
    mutationFn: createResource,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["resources"] })
      onOpenChange(false)
    }
  })

  const form = useForm({
    defaultValues: { name: "", categoryId: "" },
    validators: { onChange: formSchema },
    onSubmit: async ({ value }) => {
      await mutation.mutateAsync(value)
      form.reset()
    },
  })

  return open ? (
    <dialog>
      <h2>Create Resource</h2>
      <form onSubmit={(e) => {
        e.preventDefault()
        form.handleSubmit()
      }}>
        <form.Field name="name">
          {(field) => (
            <input
              value={field.state.value}
              onChange={(e) => field.handleChange(e.target.value)}
            />
          )}
        </form.Field>

        {/* Uses fetched dependencies */}
        {categories && (
          <form.Field name="categoryId">
            {(field) => (
              <select
                value={field.state.value}
                onChange={(e) => field.handleChange(e.target.value)}
              >
                {categories.map(cat => (
                  <option key={cat.id} value={cat.id}>{cat.name}</option>
                ))}
              </select>
            )}
          </form.Field>
        )}

        <button type="submit" disabled={mutation.isPending}>
          Create
        </button>
      </form>
    </dialog>
  ) : null
}
```

**Key traits:**
- Fetches dependencies needed for form
- Handles mutation and cache updates
- Self-contained form logic
- Dialogs are islands, not layout

</template>

<template id="dependent-query">

One query depends on another completing first.

```tsx
// Parent query
const { data: workspace } = useQuery({
  queryKey: ["workspace", workspaceId],
  queryFn: async () => {
    const res = await fetch(`/api/workspaces/${workspaceId}`)
    return res.json()
  }
})

// Dependent query - only runs when parent exists
const { data: members } = useQuery({
  queryKey: ["members", workspace?.id],
  queryFn: async () => {
    const res = await fetch(`/api/workspaces/${workspace.id}/members`)
    return res.json()
  },
  enabled: !!workspace?.id,  // Wait for parent
})
```

**Use in:**
- Dialogs with related data dependencies
- Islands that need parent context
- Chain-dependent queries

</template>

## File Structure Template

```
src/features/resource/
├── pages/
│   └── resource-page.tsx          # Layout (no fetch)
├── islands/
│   ├── resource-grid.tsx          # Island (fetch + state)
│   ├── resource-detail.tsx        # Island (fetch + state)
│   └── create-resource-dialog.tsx # Island (fetch + mutation)
├── components/
│   ├── resource-card.tsx          # Presentation
│   ├── resource-skeleton.tsx      # Loading state
│   ├── empty-resource-state.tsx   # Empty state
│   └── resource-list.tsx          # Presentation grid
├── hooks/
│   └── use-resource.ts            # Optional: custom hooks
└── types/
    └── resource.ts                # Type definitions
```

## Key Rules

1. **Islands own data**: Component displaying data must fetch it
2. **Pass config, not data**: Islands receive filters/IDs as props, never fetched objects
3. **Inline states**: Islands handle loading/error/empty inline
4. **Dialogs are islands**: Dialogs fetch dependencies, not passed from parent
5. **isPending vs isFetching**: Use `isPending` for initial load, `isFetching` for background
6. **Separate concerns**: Layout (page), Data (island), Presentation (card)

## Anti-Patterns

<anti-patterns id="architecture-mistakes">

- Passing fetched data as props to islands (breaks encapsulation)
- Handling load/error states in parent components (should be in island)
- Mixing data fetching with layout orchestration
- Dialog children fetching data passed from parent (dialogs should own it)
- Creating presentation components with hooks
- Using `isFetching` for initial load (use `isPending`)
- Creating deeply nested dependencies (flatten query dependencies)

</anti-patterns>
