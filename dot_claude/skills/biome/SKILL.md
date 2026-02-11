---
name: biome
description: Biome linter and formatter configuration. Use when dealing with lint errors, code formatting, or managing rule overrides.
---

# Biome

## Commands

```bash
biome lint                      # Check for lint errors
biome lint --write              # Fix lint errors automatically
biome check                      # Lint + format check (no fixes)
biome check --write             # Lint + format with auto-fix
biome format --write            # Format code only
```

## Configuration

Biome is configured at `biome.json` with:

- Recommended rules for JavaScript/TypeScript
- Auto import organization enabled
- Consistent formatting across the project
- File exclusions for build outputs and node_modules

## Ignoring Rules

<template id="ignoring-rules">

```typescript
// biome-ignore lint/suspicious/noExplicitAny: legacy API return type
const data: any = legacyApiCall();

// biome-ignore lint/style/noUnusedTemplateLiteral: intentional template for formatting
const template = `${unused}`;
```

Always include explanation after the colon.

</template>

<instructions>

- Run `biome check --write` before committing
- Always explain rule ignores with clear reasoning
- Avoid rule ignores as much as possible, do not fight the framework
- Use auto-fix when possible: `biome lint --write`
- Check for new violations: `biome lint`
- Never disable rules globally in config unless project-wide requirement

</instructions>
