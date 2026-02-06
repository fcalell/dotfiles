---
name: zod-validation
description: Input validation patterns with Zod for APIs and forms. Use when building schemas, validating inputs, or ensuring data integrity.
---

# Zod Validation

## Core Patterns
```typescript
// Required string: always .min(1) — empty string is invalid
name: z.string().min(1, "Name is required").max(255)

// Optional nullable: fields that can be undefined OR null
notes: z.string().max(1000).optional().nullable()

// IDs: simple string
id: z.string()
userId: z.string()

// Numbers with constraints
count: z.number().int().min(0).max(1000)
rating: z.number().min(1).max(5)

// Optional with default
limit: z.number().min(1).max(100).optional().default(10)

// HTTPS URL
websiteUrl: z.url()
  .refine((u) => new URL(u).protocol === "https:", "Must use HTTPS")
  .optional()

// Email validation
email: z.string().email()

// Enumeration with limited values
status: z.enum(["active", "inactive", "pending"])

// Reusable schema composition
const addressSchema = z.object({
  street: z.string().min(1),
  city: z.string().min(1),
  zipCode: z.string().regex(/^\d{5}(-\d{4})?$/, "Invalid ZIP code"),
})

const userSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
  address: addressSchema,
})
```

## Form Validation Pattern
```typescript
// Always use safeParse() in forms — never throws
const result = schema.safeParse(formData);

if (!result.success) {
  // result.error contains field-level errors
  return { errors: result.error.flatten().fieldErrors };
}

// Use inferred type for form data
const data: z.infer<typeof schema> = result.data;
```

## Rules
1. Required strings: Use `.min(1)` — plain `.string()` allows empty strings
2. Always use `.safeParse()` in forms and API handlers — never `.parse()`
3. Use `z.infer<typeof schema>` as single source of truth for types
4. Compose schemas for reusability — avoid duplicating field definitions
5. Add meaningful error messages with second argument to validators

## Anti-patterns
- Plain `.string()` for required fields
- Using `.parse()` in form handlers (throws on invalid input)
- Manual type definitions instead of `z.infer<>`
- Long inline schemas without composition
- Missing error messages on validation rules
- Validating after parsing (should validate before)
