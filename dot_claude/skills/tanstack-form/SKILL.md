---
name: tanstack-form
description: Form handling with TanStack Form and Zod validation. Use when building forms, validating fields, or handling form submissions.
---

# TanStack Form

React form library with built-in validation, error handling, and minimal re-renders.

## Core Form Pattern

<template id="basic-form">

```tsx
import { useForm } from "@tanstack/react-form";
import { z } from "zod";

// 1. Define schema with validation rules
const formSchema = z.object({
  email: z.string().email("Invalid email"),
  name: z.string().min(1, "Name required").max(100),
  message: z.string().optional(),
});

type FormData = z.infer<typeof formSchema>;

// 2. Create form with useForm
function ContactForm() {
  const form = useForm({
    defaultValues: {
      email: "",
      name: "",
      message: "",
    },
    validators: {
      onChange: schema,
      onBlur: schema,
    },
    validationLogic: revalidateLogic({
      mode: "blur", // Before submit: Only check when user leaves a field
      modeAfterSubmission: "change", // After submit: Check on every keystroke for fast fixes
    }),
    onSubmit: async ({ value }) => {
      // Handle form submission
      await submitForm(value);
    },
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    form.handleSubmit();
  };

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
              <span className="error">
                {field.state.meta.errors[0]?.message}
              </span>
            )}
          </div>
        )}
      </form.Field>

      <button type="submit">Submit</button>
    </form>
  );
}
```

**Customize:**

- Add/remove fields in schema and form
- Update validation rules based on requirements
- Add custom error messages to validation
- Change input types (email, password, tel, etc.)
- Change input components based on the design system

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
