---
name: tanstack-form
description: Form handling with TanStack Form and Zod validation. Use when building forms, validating fields, or handling form submissions.
---

# TanStack Form

React form library with built-in validation, error handling, and minimal re-renders.

## Core Form Pattern

<template id="basic-form">

```tsx
import { useForm } from "@tanstack/react-form"
import { z } from "zod"

// 1. Define schema with validation rules
const formSchema = z.object({
  email: z.string().email("Invalid email"),
  name: z.string().min(1, "Name required").max(100),
  message: z.string().optional(),
})

type FormData = z.infer<typeof formSchema>

// 2. Create form with useForm
function ContactForm() {
  const form = useForm({
    defaultValues: {
      email: "",
      name: "",
      message: "",
    },
    validators: {
      onChange: formSchema,  // Validate on each change
    },
    onSubmit: async ({ value }) => {
      // Handle form submission
      await submitForm(value)
    },
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    form.handleSubmit()
  }

  // 3. Render form with field state
  return (
    <form onSubmit={handleSubmit}>
      <form.Field name="email">
        {(field) => (
          <div>
            <label htmlFor={field.name}>Email</label>
            <input
              id={field.name}
              name={field.name}
              type="email"
              value={field.state.value}
              onChange={(e) => field.handleChange(e.target.value)}
              onBlur={field.handleBlur}
              aria-invalid={!!field.state.meta.errors.length}
            />
            {field.state.meta.errors.length > 0 && (
              <span className="error">{field.state.meta.errors[0]?.message}</span>
            )}
          </div>
        )}
      </form.Field>

      <button type="submit">Submit</button>
    </form>
  )
}
```

**Customize:**
- Add/remove fields in schema and form
- Update validation rules based on requirements
- Add custom error messages to validation
- Change input types (email, password, tel, etc.)

</template>

<template id="select-field">

```tsx
<form.Field name="category">
  {(field) => (
    <div>
      <label htmlFor={field.name}>Category</label>
      <select
        id={field.name}
        name={field.name}
        value={field.state.value}
        onChange={(e) => field.handleChange(e.target.value)}
      >
        <option value="">Select category</option>
        <option value="tech">Technology</option>
        <option value="design">Design</option>
      </select>
      {field.state.meta.errors.length > 0 && (
        <span className="error">{field.state.meta.errors[0]?.message}</span>
      )}
    </div>
  )}
</form.Field>
```

</template>

<template id="checkbox-field">

```tsx
<form.Field name="agree" mode="boolean">
  {(field) => (
    <label>
      <input
        type="checkbox"
        checked={field.state.value}
        onChange={(e) => field.handleChange(e.target.checked)}
      />
      I agree to terms
    </label>
  )}
</form.Field>
```

</template>

<template id="array-field">

```tsx
<form.Field name="items" mode="array">
  {(field) => (
    <div>
      <label>Items</label>
      <div>
        {field.state.value.map((_, index) => (
          <div key={index}>
            <form.Field name={`items[${index}].name`}>
              {(subField) => (
                <input
                  value={subField.state.value}
                  onChange={(e) => subField.handleChange(e.target.value)}
                  placeholder="Item name"
                />
              )}
            </form.Field>
            <button
              type="button"
              onClick={() => field.removeValue(index)}
            >
              Remove
            </button>
          </div>
        ))}
      </div>
      <button
        type="button"
        onClick={() => field.pushValue({ name: "" })}
      >
        Add Item
      </button>
    </div>
  )}
</form.Field>
```

**Use when:**
- Form needs dynamic list of entries
- Users add/remove items (tags, line items, contacts)
- Nested validation on each array element

</template>

<template id="dialog-form">

```tsx
import { useMutation, useQueryClient } from "@tanstack/react-query"

function CreateDialog({ open, onOpenChange }: Props) {
  const queryClient = useQueryClient()

  // Mutation for submission
  const mutation = useMutation({
    mutationFn: submitFormData,
    onSuccess: () => {
      // Invalidate related queries
      queryClient.invalidateQueries({ queryKey: ["items"] })
      onOpenChange(false)
    },
  })

  const form = useForm({
    defaultValues: { name: "" },
    validators: { onChange: formSchema },
    onSubmit: async ({ value }) => {
      await mutation.mutateAsync(value)
      form.reset()
    },
  })

  return (
    <div>
      {open && (
        <dialog>
          <h2>Create Item</h2>
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
            <button type="submit" disabled={mutation.isPending}>
              {mutation.isPending ? "Creating..." : "Create"}
            </button>
          </form>
        </dialog>
      )}
    </div>
  )
}
```

**Customize:**
- Replace `submitFormData` with your API call
- Update invalidation queryKey to match your cache
- Add more fields as needed

</template>

## Validation Patterns

<template id="conditional-validation">

```tsx
// Validate based on other field values
const formSchema = z.object({
  contactMethod: z.enum(["email", "phone"]),
  email: z.string().email().optional(),
  phone: z.string().optional(),
}).refine(
  (data) => {
    if (data.contactMethod === "email") return !!data.email
    if (data.contactMethod === "phone") return !!data.phone
    return true
  },
  {
    message: "Provide the contact method you selected",
    path: ["email"], // Show error on email field
  }
)
```

**Use for:**
- Field dependencies (show/hide/validate based on other fields)
- Mutually exclusive fields
- Cross-field validation

</template>

<template id="async-validation">

```tsx
const formSchema = z.object({
  username: z.string()
    .min(3, "Min 3 characters")
    .refine(
      async (val) => {
        const res = await fetch(`/api/check-username?username=${val}`)
        return res.ok
      },
      { message: "Username already taken" }
    ),
})
```

**Use for:**
- Checking availability (username, email, domain)
- Real-time validation feedback
- Server-side business rules

</template>

## Field State Reference

```tsx
field.state = {
  value: string,           // Current value
  meta: {
    errors: string[],      // Validation errors
    errorMap: Record,      // Error by field
    isTouched: boolean,    // User interacted
    isDirty: boolean,      // Changed from default
    isValidating: boolean, // Validation in progress
  }
}

field.handleChange(newValue)    // Update value
field.handleBlur()               // Mark touched
field.pushValue(item)            // Array: append
field.removeValue(index)         // Array: remove at index
field.moveValue(from, to)        // Array: reorder
```

## Key Rules

1. **Zod schema**: Source of truth for validation rules
2. **Field render function**: Each field wrapped in `<form.Field>` with render function
3. **Error display**: Access via `field.state.meta.errors[0]?.message`
4. **Array fields**: Use `mode="array"` and `pushValue`/`removeValue` methods
5. **Form submission**: Call `form.handleSubmit()` in submit handler
6. **Reset after submit**: Call `form.reset()` to clear form on success

## Anti-Patterns

<anti-patterns id="form-mistakes">

- Validating without Zod schema (manual error handling)
- Not using field render functions (accessing state incorrectly)
- Forgetting to call `form.reset()` after successful submission
- Hard-coded validation messages (should be in Zod schema)
- Not showing errors to user (silent validation failures)
- Using `defaultValue` instead of `defaultValues` in useForm
- Not tracking form dirty/touched state (can't implement save prompts)
- Mixing controlled and uncontrolled inputs

</anti-patterns>
