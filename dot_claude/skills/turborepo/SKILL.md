---
name: turborepo
description: Monorepo management with Turborepo. Use when adding packages, modifying build pipelines, running workspace commands, or managing dependencies.
---

# Turborepo

Build system and workspace manager for monorepos. Handles task orchestration, caching, and dependency resolution.

## Workspace Commands

```bash
pnpm dev              # Run dev task in all packages
pnpm build            # Build all packages
pnpm check            # Lint + typecheck all packages
pnpm test             # Run tests in all packages

# Run in specific package
pnpm --filter @repo/api build
pnpm --filter @repo/webapp dev
pnpm --filter ./packages/ui build

# Scope to changed packages (useful in CI)
pnpm build --changed

# Include dependencies
pnpm build --include-dependencies
```

**Key:** Always run from repo root, never `cd` into packages.

## Workspace Structure

Typical monorepo layout:

```
apps/
├── webapp/                  # Main frontend app (@repo/webapp)
│   └── src/
│       ├── routes/          # TanStack Router
│       ├── components/      # UI components
│       └── entry.tsx        # Entry point
│
packages/
├── api/                     # Backend/API (@repo/api)
│   └── src/
│       └── routes/          # API endpoints
│
├── db/                      # Database (@repo/db)
│   └── schema.ts            # Drizzle schema
│
├── features/                # Feature components (@repo/features)
│   └── src/
│       └── islands/         # Island components
│
├── ui/                      # Design system (@repo/ui)
│   └── src/
│       └── components/      # Primitives, patterns
│
├── shared/                  # Shared utilities (@repo/shared)
│   └── src/
│       └── types/           # Shared types
│
└── config/
    ├── typescript-config/   # TypeScript configs
    ├── eslint-config/       # ESLint configs
    └── tailwind-config/     # Tailwind configs
```

**Customize:** Adjust structure to your project's needs. Keep apps/ for user-facing products, packages/ for libraries.

<template id="package-json">

```json
{
  "name": "@repo/package-name",
  "version": "0.0.1",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "check": "tsc && eslint src"
  },
  "dependencies": {},
  "devDependencies": {},
  "peerDependencies": {}
}
```

**Conventions:**

- Use `@repo/` scope for all internal packages
- Define scripts that turbo can orchestrate
- No version numbers in package.json (monorepo symlinks via workspace:\*)

</template>

## Dependency Management

<template id="internal-dependencies">

```json
// package.json in apps/webapp
{
  "dependencies": {
    "@repo/api": "workspace:*",
    "@repo/db": "workspace:*",
    "@repo/features": "workspace:*",
    "@repo/ui": "workspace:*"
  }
}
```

**Rules:**

- Use `workspace:*` for internal dependencies (symlinks locally, resolves on publish)
- Never use relative paths (`../`) for dependencies
- Never hardcode versions of internal packages
- pnpm automatically handles workspace resolution

</template>

## Turbo Configuration

<template id="turbo-config">

```json
// turbo.json (repo root)
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "dev": {
      "cache": false,
      "persistent": true
    },
    "build": {
      "outputs": ["dist/**", "build/**"],
      "cache": true
    },
    "check": {
      "outputs": [],
      "cache": true
    },
    "lint": {
      "cache": true
    },
    "test": {
      "outputs": ["coverage/**"],
      "cache": false
    }
  },
  "pipeline": {
    // Task execution order
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true,
      "dependsOn": ["dev:init"]
    },
    "dev:init": {
      "cache": false,
      "persistent": true,
      "outputs": []
    }
  }
}
```

**Key concepts:**

- `cache: false` for dev tasks (always run)
- `cache: true` for build/lint/test (skip if unchanged)
- `dependsOn: ["^build"]` means "wait for dependencies to build first"
- `persistent: true` keeps task running (good for dev servers)
- `outputs` tells turbo what to cache and when to skip

</template>

## Task Filtering

```bash
# Filter by package name
pnpm --filter @repo/api build

# Filter by directory
pnpm --filter ./packages/ui build

# Filter by tag
pnpm --filter "tag:frontend" build

# Include dependencies of filtered package
pnpm --filter @repo/webapp --include-dependencies build

# Only changed packages (in CI)
pnpm build --changed
```

## Development Workflow

<template id="dev-workflow">

```bash
# Terminal 1: Start all dev servers
pnpm dev
# Watches:
# - apps/webapp: Vite dev server on port 3000
# - apps/api: Backend dev server
# - packages/ui: Storybook or dev build

# Terminal 2: Type check and lint
pnpm check
# Runs: tsc + eslint in all packages

# Terminal 3: Run tests (watching)
pnpm test -- --watch

# In another terminal, test specific package
pnpm --filter @repo/api test -- --watch
```

**Tip:** Use task dependencies in turbo.json to run setup tasks before dev.

</template>

## Build Process

```bash
# Build all packages (respects dependency order)
pnpm build
# Turborepo ensures:
# 1. @repo/shared builds first (no dependencies)
# 2. @repo/ui builds (depends on shared)
# 3. @repo/features builds (depends on ui)
# 4. @repo/api builds (depends on db, shared)
# 5. apps/webapp builds (depends on all)

# Build specific package and dependencies
pnpm --filter @repo/api --include-dependencies build

# Build only changed since last commit
pnpm build --changed
```

## Common Tasks

<template id="common-patterns">

```bash
# Setup: install all dependencies
pnpm install

# Build everything for production
pnpm build

# Type check and lint all code
pnpm check

# Run tests in all packages
pnpm test

# Add new dependency to package
pnpm --filter @repo/api add express

# Add dev dependency to package
pnpm --filter @repo/api add -D @types/node

# Remove dependency
pnpm --filter @repo/api remove express

# List workspace packages
pnpm ls -r --depth 0
```

</template>

## Key Rules

<instructions id="monorepo-rules">

1. Always run commands from repo root (never `cd` into packages)
2. Use `workspace:*` for internal dependencies
3. Keep `package.json` names consistent with `@repo/` scope
4. Define meaningful scripts in each package's `package.json`
5. Use turbo.json to orchestrate task dependencies
6. Cache build/test/lint tasks, not dev tasks
7. Group related packages (apps/ vs packages/)
8. Document package purposes in README

</instructions>
