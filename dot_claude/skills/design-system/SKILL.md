---
name: design-system
description: Methodology for building intent-driven design systems. Use when establishing design foundations, creating token systems, or building production-grade UI.
---

# Design System Methodology

Framework for building consistent, scalable design systems grounded in purpose and intentionality.

## Intent-First Approach

Before designing, establish the product context:

```
1. WHO?          — Target user, their environment, mindset
2. WHAT VERB?    — Primary action (configure, review, manage, approve)
3. HOW FEEL?     — Emotional tone (technical, warm, playful, serious)
```

**Example contexts:**

- Engineering dashboard: "Help engineers configure systems" → precise, data-dense, technical
- Creative tool: "Help designers explore ideas" → experimental, playful, forgiving
- Analytics: "Help executives understand trends" → clear, scannable, authoritative

These decisions inform every design token and component.

## Token Architecture

All colors trace back to core semantic primitives:

<template id="token-system">

```typescript
// Semantic primitives (define once, use everywhere)
const palette = {
  foreground: {
    primary: "#000000", // Primary text
    secondary: "#666666", // Secondary text
    tertiary: "#999999", // Tertiary text
    muted: "#cccccc", // Disabled/subtle
  },
  background: {
    base: "#ffffff", // Default surface
    elevated: "#f9f9f9", // Cards, modals
    overlay: "#000000cc", // Overlays
  },
  border: {
    default: "#e0e0e0", // Standard borders
    subtle: "#f0f0f0", // Faint division
    strong: "#999999", // Emphasis
  },
  semantic: {
    destructive: "#ef4444", // Delete, cancel, error
    warning: "#f59e0b", // Caution
    success: "#10b981", // Success
    info: "#3b82f6", // Information
  },
};

// Surface elevations (builds hierarchy)
const surfaces = {
  base: {
    background: palette.background.base,
    border: palette.border.default,
  },
  elevated: {
    background: palette.background.elevated,
    border: palette.border.subtle,
  },
  strong: {
    background: palette.background.elevated,
    border: palette.border.strong,
  },
};

// Text hierarchy
const typography = {
  primary: palette.foreground.primary, // Main content
  secondary: palette.foreground.secondary, // Supporting
  tertiary: palette.foreground.tertiary, // De-emphasized
  muted: palette.foreground.muted, // Disabled
};
```

**Principle:** Colors mean something. Default color should not jump out.

</template>

## Design Validation Checks

Before shipping any design, validate against signature:

<template id="validation-checks">

**Swap test:** If you swapped fonts/colors/layout for generic ones, would anyone notice it's your product?

**Squint test:** Blur your eyes. Can you still perceive hierarchy? Borders shouldn't dominate.

**Signature test:** Can you identify 5 elements where the design signature appears?

- Specific border treatment
- Typography choices
- Color usage
- Radius/rounding philosophy
- Spacing ratios

**Token test:** Do CSS variable names sound like they belong to THIS product?

- ✅ `--color-status-focus`, `--spacing-section-gap`, `--font-data`
- ❌ `--blue-500`, `--padding-16`, `--generic-font`

**Depth test:** Surfaces should feel stacked, not dramatic. If borders are the first thing you notice, they're too strong.

</template>

## Surface & Elevation Architecture

Surfaces stack with clear but subtle hierarchy:

<template id="surface-architecture">

```typescript
// Surface elevation levels
const elevation = {
  // Base surface
  0: {
    background: "bg-background",
    border: "border border-border-default",
  },

  // Elevated (cards, panels)
  1: {
    background: "bg-surface-elevated",
    border: "border border-border-subtle",
  },

  // Strong (dialogs, emphasized)
  2: {
    background: "bg-surface-strong",
    border: "border border-border-strong",
  },

  // Overlay (modals)
  3: {
    background: "bg-surface-overlay",
    border: "border border-border-strong",
  },
};

// Visual difference: barely perceptible but clear under scrutiny
// Each level: lighter background OR stronger border, not both
```

**Key:** Elevations exist but whisper rather than shout. Users shouldn't consciously notice them.

</template>

## Common Component Patterns

<template id="component-patterns">

**Cards:**

- 1px border, subtle color
- Padding: 24px (loose) or 16px (compact)
- No shadows
- Headers use 600 weight

**Buttons:**

- 44px height (default), 36px (compact)
- Explicit variant: `variant="default" | "secondary" | "ghost" | "destructive"`
- 0px radius
- Focus ring: ring-2 ring-ring offset-2

**Forms:**

- Input height: 40px
- Label weight: 500
- Error color semantic (red)
- Help text smaller, muted color

**Data tables:**

- Bottom borders only (no grid lines)
- Monospace font for numeric data
- Compact padding
- Hover row color very subtle

**Dark mode:**

- Invert background/foreground values
- Borders over shadows (always)
- Same structure, inverted semantic colors

</template>

## Workflow

<template id="design-workflow">

1. **Read .claude/project-management/design-system.md** if exists — understand established patterns
2. **Check pattern library** before proposing new component
3. **Propose with intent** — "This dropdown shows status filters. Should feel scannable and dense."
4. **Get confirmation** before implementing
5. **Offer to save** new patterns to design-system.md for future reference

**Questions to ask:**

- Does this component pattern already exist?
- What's the intent of this UI section?
- Is the color choice meaningful or decorative?
- Will borders/spacing work across all states (hover, disabled, loading)?

</template>

## Key Rules

1. **Intent first**: Understand who, what verb, how it should feel
2. **Semantic tokens**: Colors carry meaning (not blue #3b82f6)
3. **Surfaces whisper**: Elevations should be barely perceptible
4. **No gratuitous decoration**: Every design choice serves a purpose
5. **Consistent spacing**: Use only defined token values
6. **State coverage**: Every interactive element needs hover/active/focus/disabled
7. **Cross-state validation**: Does it work light AND dark? Hover AND disabled?

## Anti-Patterns

<anti-patterns id="design-mistakes">

- Harsh borders — if borders are the first thing you see, they're too strong
- Dramatic surface jumps — elevation changes should be whisper-quiet
- Inconsistent spacing — clearest sign of no system
- Mixed depth strategies — borders-only, no shadows
- Missing interaction states — every element needs default/hover/active/focus/disabled
- Decorative gradients — color should mean something
- Multiple accent colors — pick one brand color
- Pure white cards on white background — no distinction
- Large radius on all elements — breaks signature
- Inconsistent typography — multiple font sizes that don't scale

</anti-patterns>

## Documentation Template

If creating new .claude/project-management/design-system.md:

```markdown
# Design System

## Intent

[Who are users, what's their mindset, what's our brand voice?]

## Signature Elements

[What makes this product visually distinct?]

## Spacing Scale

[Define token progression: none, xs, sm, md, lg, xl, 2xl]

## Color Palette

[Semantic primitives: foreground, background, border, semantic colors]

## Typography

[Font families, weights, scale, hierarchy]

## Surface Architecture

[How surfaces stack: base, elevated, strong, overlay]

## Components

[Pattern library: cards, buttons, forms, tables, dialogs]

## Dark Mode

[How palette inverts/adapts]

## Do's and Don'ts

[Common mistakes to avoid]
```
