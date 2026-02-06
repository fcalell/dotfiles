---
name: typescript
description: TypeScript conventions for type inference, module organization, and strict mode. Use when writing TypeScript code, setting up imports, or establishing project standards.
---

# TypeScript Conventions

## Type Inference
Always infer types from schemas instead of manual definitions:

```typescript
// Zod
type Input = z.infer<typeof inputSchema>;
type Response = z.infer<typeof responseSchema>;

// ORM libraries (Drizzle, Prisma, etc.)
type User = typeof users.$inferSelect;
type InsertUser = typeof users.$inferInsert;
```

## Import Organization
Structure imports for clarity and maintainability:

```typescript
// 1. External packages
import { z } from "zod";
import { eq } from "drizzle-orm";

// 2. Internal absolute paths (or configured aliases)
import { createLogger } from "./lib/logger";
import { validateInput } from "./utils/validate";

// 3. Relative imports (keep to same directory)
import { helper } from "./helper";
```

## Strict Mode & Type Safety
```typescript
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true
  }
}
```

Never use `any`. Use `unknown` with type guards instead:

```typescript
// Wrong
function process(data: any) {
  return data.name;
}

// Correct
function process(data: unknown): string {
  if (typeof data === "object" && data !== null && "name" in data) {
    return data.name as string;
  }
  throw new Error("Invalid data");
}
```

## Rules
1. Infer types from schemas — never define manually when possible
2. Use strict TypeScript mode — catch errors at compile time
3. Avoid `any` — use `unknown` with proper type guards
4. Organize imports: external → internal → relative
5. No barrel files (`index.ts` re-exports) for internal modules
6. Export types only when needed by other modules

## Anti-patterns
- Manual type definitions when inference available
- Using `any` for convenience
- Disabling strict mode flags
- Mixing import styles (aliases with relative paths)
- Barrel files that re-export all module contents
- Circular dependencies through improper module organization
