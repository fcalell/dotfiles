---
name: component-primitives
description: Primitive layout and component building philosophy. Use when building layout systems, spacing components, or designing component architecture.
---

# Component Primitives

Foundation for building consistent, composable UI components.

## Primitive Philosophy

Primitives are low-level building blocks with minimal opinions. They provide:

1. **Composability** — combine to build higher-level components
2. **Consistency** — single source of truth for spacing/sizing
3. **Predictability** — minimal side effects, clear contracts
4. **Flexibility** — adapt to any design system via slots

## Spacing Scale

Define a consistent spacing token hierarchy:

```
none | xs | sm | md | lg | xl | 2xl | 3xl | ...
```

Map to pixel values (adjust to your design system):

```
none:  0px
xs:    4px
sm:    8px
md:    12px
lg:    16px
xl:    24px
2xl:   32px
3xl:   48px
```

**Usage:**
- All spacing uses tokens, never arbitrary values
- Tokens compose: `p-lg`, `gap-md`, `mt-xl`
- Prevents visual inconsistency from random spacing

<template id="spacing-tokens">
```typescript
// Define once, use everywhere
const spacing = {
  none: "0px",
  xs: "4px",
  sm: "8px",
  md: "12px",
  lg: "16px",
  xl: "24px",
  "2xl": "32px",
  "3xl": "48px",
} as const

type SpacingValue = keyof typeof spacing
```

**Use in:**
- Tailwind config
- CSS-in-JS variables
- Design tokens
</template>

## Stack Component

Generic layout component handling spacing, direction, alignment.

<template id="stack-pattern">
```tsx
import { Slot } from "@radix-ui/react-slot"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "@/lib/cn"

const stackVariants = cva("flex", {
  variants: {
    direction: {
      vertical: "flex-col",
      horizontal: "flex-row",
    },
    gap: {
      none: "gap-0",
      xs: "gap-1",
      sm: "gap-2",
      md: "gap-3",
      lg: "gap-4",
      xl: "gap-6",
      "2xl": "gap-8",
      "3xl": "gap-12",
    },
    align: {
      start: "items-start",
      center: "items-center",
      end: "items-end",
      stretch: "items-stretch",
    },
    justify: {
      start: "justify-start",
      center: "justify-center",
      end: "justify-end",
      between: "justify-between",
      around: "justify-around",
    },
    wrap: {
      true: "flex-wrap",
      false: "flex-nowrap",
    },
  },
  defaultVariants: {
    direction: "vertical",
    gap: "md",
    align: "stretch",
    justify: "start",
    wrap: false,
  },
})

type StackProps = React.ComponentProps<"div"> &
  VariantProps<typeof stackVariants> & {
    asChild?: boolean
  }

function Stack({
  direction,
  gap,
  align,
  justify,
  wrap,
  asChild,
  className,
  ...props
}: StackProps) {
  const Comp = asChild ? Slot : "div"
  return (
    <Comp
      className={cn(
        stackVariants({ direction, gap, align, justify, wrap }),
        className
      )}
      {...props}
    />
  )
}

export { Stack, stackVariants }
```

**Customize:**
- Adjust gap token values to match your design
- Add padding variants if needed
- Use Slot pattern for semantic HTML (form, nav, etc.)
</template>

<template id="stack-usage">
```tsx
// Vertical (default)
<Stack gap="lg" align="center">
  <h1>Title</h1>
  <p>Description</p>
</Stack>

// Horizontal
<Stack direction="horizontal" gap="sm" align="center">
  <img src="avatar" />
  <span>User Name</span>
</Stack>

// With semantic element
<Stack direction="horizontal" gap="lg" asChild>
  <nav>
    <Link>Home</Link>
    <Link>About</Link>
  </nav>
</Stack>

// Space between layout
<Stack direction="horizontal" justify="between">
  <h1>Title</h1>
  <button>Action</button>
</Stack>
```
</template>

## Primitive Component Template

<template id="primitive-component">
```typescript
import { cva, type VariantProps } from "class-variance-authority"
import { Slot } from "@radix-ui/react-slot"
import { cn } from "@/lib/cn"

const primitiveClasses = cva("base-element-classes", {
  variants: {
    variant: {
      default: "default-variant-classes",
      secondary: "secondary-variant-classes",
    },
    size: {
      sm: "text-sm h-8",
      default: "text-base h-10",
      lg: "text-lg h-12",
    },
  },
  defaultVariants: {
    variant: "default",
    size: "default",
  },
})

type PrimitiveProps = React.ComponentProps<"div"> &
  VariantProps<typeof primitiveClasses> & {
    asChild?: boolean
  }

function Primitive({
  variant,
  size,
  asChild,
  className,
  ...props
}: PrimitiveProps) {
  const Comp = asChild ? Slot : "div"
  return (
    <Comp
      className={cn(primitiveClasses({ variant, size }), className)}
      {...props}
    />
  )
}

export { Primitive, primitiveClasses }
export type { PrimitiveProps }
```

**Conventions:**
- Use CVA for variant management
- Export both component and classes
- Include `asChild` support via Slot
- Use semantic `data-slot` attributes
- Type-safe props with Variant inference
</template>

## asChild Pattern

Merge component styles onto child elements without wrapper div.

<template id="as-child">
```tsx
// Without asChild - creates wrapper
<Stack gap="lg">
  <form>...</form>
</Stack>
// Result: <div><form>...</form></div>

// With asChild - merges onto form
<Stack gap="lg" asChild>
  <form>...</form>
</Stack>
// Result: <form class="flex flex-col gap-4">...</form>
```

**Use when:**
- Semantic HTML needed (form, nav, header, section)
- Avoiding extra wrapper divs
- Merging layout onto element
- Passing styles without DOM overhead
</template>

## Composition Patterns

<template id="composed-components">
```tsx
// Build higher-level components from primitives
function Card({ children, className, ...props }: Props) {
  return (
    <Stack
      gap="md"
      className={cn("border rounded p-6", className)}
      {...props}
    >
      {children}
    </Stack>
  )
}

function CardHeader({ children }: Props) {
  return (
    <Stack gap="sm">
      {children}
    </Stack>
  )
}

function CardContent({ children }: Props) {
  return <div>{children}</div>
}

// Usage
<Card>
  <CardHeader>
    <h2>Title</h2>
  </CardHeader>
  <CardContent>Content here</CardContent>
</Card>
```

**Pattern:**
- Primitives handle spacing/layout
- Higher components handle styling/structure
- Compose without nesting wrapper divs
</template>

## Key Rules

1. **Always use tokens**: Never arbitrary `gap-1.5`, `p-5`, `p-10`, etc.
2. **Stack for layout**: Never raw flex/grid for spacing
3. **CVA for variants**: Single source for all component styles
4. **asChild pattern**: Merge onto semantic elements
5. **Composition over nesting**: Build from primitives, not wrappers
6. **Consistent naming**: Variant names match design language

## Anti-Patterns

<anti-patterns id="primitive-mistakes">
- Using arbitrary Tailwind values like `gap-1.5`, `p-5`, `gap-2.5`
- Creating custom flex containers instead of using Stack
- Hardcoding colors/spacing instead of using tokens
- Missing `asChild` when wrapping semantic elements
- Inconsistent variant naming across components
- Using classes instead of CVA (manual variant logic)
- Creating wrapper components instead of using Stack
- Not exporting variant classes for reuse
</anti-patterns>
