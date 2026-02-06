---
name: vitest
description: Testing patterns with Vitest for unit and integration tests. Use when writing tests for functions, API handlers, hooks, or business logic.
---

# Vitest

## Commands

```bash
vitest                          # Run all tests in watch mode
vitest --run                    # Run tests once
vitest --run [file-pattern]     # Run specific tests
vitest --reporter=verbose       # Detailed test output
```

## File Conventions

- Unit tests co-locate with source: `utils.ts` → `utils.test.ts`
- Integration tests in `__tests__/` directory when testing multi-file scenarios
- Keep tests close to source for easier navigation and maintenance

## Test Structure Pattern

<template id="test-structure">

```typescript
// src/utils/calculate.test.ts
import { describe, it, expect, beforeEach, afterEach } from "vitest";
import { calculate } from "./calculate";

describe("calculate function", () => {
  it("returns correct sum for positive numbers", () => {
    const result = calculate([1, 2, 3]);
    expect(result).toBe(6);
  });

  it("handles empty array", () => {
    const result = calculate([]);
    expect(result).toBe(0);
  });

  it("rejects invalid input", () => {
    expect(() => calculate(null as any)).toThrow();
  });
});
```

</template>

## Mocking Database/ORM

<template id="database-mock">

```typescript
// src/db/queries.test.ts
import { describe, it, expect, vi } from "vitest";
import { findUser } from "./queries";

describe("findUser", () => {
  it("queries database with correct filters", async () => {
    // Mock chainable ORM methods to match real API
    const mockDb = {
      select: vi.fn().mockReturnThis(),
      from: vi.fn().mockReturnThis(),
      where: vi.fn().mockResolvedValue([
        { id: "user1", name: "Alice" },
      ]),
    };

    const result = await findUser(mockDb, { id: "user1" });

    expect(result).toMatchObject({ id: "user1", name: "Alice" });
    expect(mockDb.where).toHaveBeenCalled();
  });
});
```

</template>

## API Procedure/Handler Tests

<template id="handler-test">

```typescript
// src/api/users.test.ts
import { describe, it, expect, vi } from "vitest";
import { getUserHandler } from "./users";

describe("getUserHandler", () => {
  it("returns user data when authorized", async () => {
    const mockDb = {
      query: { users: { findFirst: vi.fn().mockResolvedValue({ id: "user1" }) } },
    };

    const result = await getUserHandler({
      input: { userId: "user1" },
      context: { user: { id: "user1" }, db: mockDb },
    });

    expect(result).toMatchObject({ id: "user1" });
  });

  it("rejects unauthorized requests", async () => {
    await expect(
      getUserHandler({
        input: { userId: "user1" },
        context: { user: null, db: {} },
      })
    ).rejects.toThrow("Unauthorized");
  });
});
```

</template>

## React Hook Testing

<template id="hook-test">

```typescript
// src/hooks/useUser.test.ts
import { describe, it, expect } from "vitest";
import { renderHook, waitFor } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { useUser } from "./useUser";

// Create test wrapper with query client
function createTestWrapper() {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: {
        retry: false, // Don't retry in tests for faster feedback
        gcTime: Infinity,
      },
    },
  });

  return ({ children }) => (
    <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
  );
}

describe("useUser hook", () => {
  it("fetches user data on mount", async () => {
    const { result } = renderHook(() => useUser("user1"), {
      wrapper: createTestWrapper(),
    });

    await waitFor(() => expect(result.current.isSuccess).toBe(true));

    expect(result.current.data).toMatchObject({ id: "user1" });
  });

  it("shows loading state before fetch completes", () => {
    const { result } = renderHook(() => useUser("user1"), {
      wrapper: createTestWrapper(),
    });

    expect(result.current.isLoading).toBe(true);
  });

  it("handles fetch errors gracefully", async () => {
    const { result } = renderHook(() => useUser("invalid"), {
      wrapper: createTestWrapper(),
    });

    await waitFor(() => expect(result.current.isError).toBe(true));
  });
});
```

</template>

<instructions>

- Co-locate unit tests with source code for easy discoverability
- Mock only external dependencies (databases, APIs); test real business logic
- Use `vi.mock()` for module-level mocks (Vitest hoists them automatically)
- Set `retry: false` in test query/fetch configurations for faster feedback
- Write tests from the caller's perspective (what does it return/do?)
- Clean up resources in `afterEach` hooks to prevent test pollution
- Use `waitFor()` for async assertions in React tests

</instructions>

<anti-patterns>

- Placing unit tests in separate `__tests__` folder (hurts discoverability)
- Testing implementation details instead of public behavior
- Over-mocking: mocking everything instead of testing business logic
- Missing `retry: false` in async test configurations (tests retry, slowing feedback)
- Manually mocking with `.mock()` instead of `vi.mock()` (can't hoist)
- Not cleaning up between tests (state bleeds across tests)
- Testing private functions directly instead of through public API
- Forgetting to use `waitFor()` for async assertions

</anti-patterns>
