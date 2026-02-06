---
name: tanstack-query
description: Data fetching and caching with TanStack Query. Use when implementing queries, mutations, cache invalidation, optimistic updates, dependent queries, or infinite queries.
---

# TanStack Query

Server state management library for fetching, caching, and synchronizing data.

## Query & Mutation Patterns

<template id="basic-queries">
```tsx
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query"

// Basic list query with filters
const { data: items, isPending, error } = useQuery({
  queryKey: ["items", { status: "active" }],
  queryFn: async () => {
    const res = await fetch("/api/items?status=active")
    return res.json()
  }
})

// Detail query for single item
const { data: item } = useQuery({
  queryKey: ["item", id],
  queryFn: async () => {
    const res = await fetch(`/api/items/${id}`)
    return res.json()
  },
  enabled: !!id,  // Only fetch when ID exists
})

// Mutation with cache invalidation
const mutation = useMutation({
  mutationFn: async (newItem) => {
    const res = await fetch("/api/items", {
      method: "POST",
      body: JSON.stringify(newItem)
    })
    return res.json()
  },
  onSuccess: () => {
    queryClient.invalidateQueries({
      queryKey: ["items"]
    })
  }
})
```

**Customize:**
- Replace array query keys with your actual data types
- Add filter parameters to queryKey tuples for proper cache management
- Update API endpoints to match your backend
- Add error handling with `error` state when needed
</template>

<template id="dependent-queries">
```tsx
// Parent query: fetch parent entity
const { data: parent } = useQuery({
  queryKey: ["parent", parentId],
  queryFn: async () => {
    const res = await fetch(`/api/parent/${parentId}`)
    return res.json()
  }
})

// Dependent query: fetch children only when parent exists
const { data: children } = useQuery({
  queryKey: ["children", parent?.id],
  queryFn: async () => {
    const res = await fetch(`/api/children?parentId=${parent.id}`)
    return res.json()
  },
  // Only run when parent ID exists - prevents null errors
  enabled: !!parent?.id,
})
```

**Customize:**
- Replace parent and child entity names with actual types
- Chain multiple dependent queries if needed
- Always validate the `enabled` condition before using parent data
- Use `??` operator to provide fallback for undefined IDs
</template>

<template id="optimistic-updates">
```tsx
const queryClient = useQueryClient()

const mutation = useMutation({
  mutationFn: updateItem,
  onMutate: async (updatedItem) => {
    // Cancel any ongoing queries for this item
    await queryClient.cancelQueries({
      queryKey: ["items"]
    })

    // Save previous data
    const previousItems = queryClient.getQueryData(["items"])

    // Update cache optimistically
    queryClient.setQueryData(["items"], (old) =>
      old.map(item => item.id === updatedItem.id ? updatedItem : item)
    )

    return { previousItems }
  },
  onError: (err, newData, context) => {
    // Revert on error
    queryClient.setQueryData(["items"], context?.previousItems)
  },
  onSuccess: () => {
    // Refetch fresh data after success
    queryClient.invalidateQueries({ queryKey: ["items"] })
  }
})
```

**Use when:**
- Mutations should appear instant to user (forms, toggles)
- Bad UX to show spinners for fast mutations
- Important to revert on error (financial operations)
</template>

<template id="infinite-queries">
```tsx
const { data, fetchNextPage, hasNextPage, isPending } = useInfiniteQuery({
  queryKey: ["items"],
  queryFn: async ({ pageParam = 0 }) => {
    const res = await fetch(`/api/items?page=${pageParam}&limit=20`)
    return res.json()
  },
  getNextPageParam: (lastPage) => {
    return lastPage.hasMore ? lastPage.nextPage : undefined
  },
  initialPageParam: 0,
})

return (
  <InfiniteScroll
    dataLength={data?.pages.flatMap(p => p.items).length ?? 0}
    next={fetchNextPage}
    hasMore={hasNextPage ?? false}
  >
    {data?.pages.map(page =>
      page.items.map(item => <ItemCard key={item.id} {...item} />)
    )}
  </InfiniteScroll>
)
```

**Customize:**
- Adjust pageParam logic based on your pagination (offset, cursor, etc.)
- Update limit and API endpoint to match backend
- Use flatMap to flatten pages into single array for display
</template>

## Key Patterns

1. **Query keys as arrays**: Structure `["entity", filters, id]` enables partial invalidation
2. **Cache invalidation**: After mutations, invalidate related queries to refetch fresh data
3. **Dependent queries**: Use `enabled` flag to prevent queries before dependencies exist
4. **staleTime & gcTime**: Set `staleTime` to reduce refetches, `gcTime` (was `cacheTime`) for memory cleanup
5. **Manual cache updates**: Use `setQueryData` for optimistic updates to feel instant
6. **isPending vs isFetching**: Use `isPending` for initial load, `isFetching` for background updates

## Anti-Patterns

<anti-patterns id="common-mistakes">
- Hardcoding queryKey strings instead of using arrays for consistency
- Forgetting to invalidate queries after mutations
- Not using `enabled` for dependent queries (causes errors)
- Using wrong queryKey for invalidation (cache won't clear)
- Setting `staleTime` too high (users see outdated data)
- Not handling error state in UI (silent failures)
- Over-fetching data without pagination
</anti-patterns>
