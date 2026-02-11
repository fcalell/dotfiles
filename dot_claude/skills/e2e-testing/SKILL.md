---
name: e2e-testing
description: End-to-end testing with Playwright. Use when writing E2E tests, setting up test infrastructure, or testing critical user flows.
---

# E2E Testing (Playwright)

Modern E2E testing framework with excellent developer experience and debugging tools.

## Setup

```bash
pnpm add -Dw @playwright/test
npx playwright install --with-deps chromium
```

## Configuration

<template id="playwright-config">

```typescript
// playwright.config.ts (repo root)
import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: "./tests/e2e",
  baseURL: "http://localhost:3000",
  use: {
    trace: "on-first-retry",
    screenshot: "only-on-failure",
  },
  webServer: {
    command: "pnpm dev",
    port: 3000,
    reuseExistingServer: !process.env.CI,
  },
  projects: [{ name: "chromium", use: { browserName: "chromium" } }],
});
```

**Customize:**

- `testDir`: Where E2E tests live
- `baseURL`: Local dev server URL
- `webServer.command`: How to start your dev server
- `webServer.port`: Port where dev server runs

</template>

## Test Structure

```
tests/
├── e2e/
│   ├── auth.spec.ts           # Authentication flows
│   ├── [feature].spec.ts       # Feature tests (domain entity)
│   │   # Example: resources.spec.ts, users.spec.ts, reports.spec.ts
│   └── critical-flow.spec.ts   # Happy path (signup → create → use)
├── fixtures/
│   └── auth.ts                 # Reusable auth fixture
└── pages/
    ├── login.page.ts           # Page Object: login
    ├── dashboard.page.ts       # Page Object: dashboard
    └── [resource].page.ts      # Page Object: feature
        # Example: resource.page.ts, user.page.ts, report.page.ts
```

## Page Object Pattern

<template id="page-object">

```typescript
// tests/pages/login.page.ts
import type { Page } from "@playwright/test";

export class LoginPage {
  constructor(private page: Page) {}

  // Use semantic locators (role, label, text) not CSS
  readonly email = this.page.locator('input[name="email"]');
  readonly password = this.page.locator('input[name="password"]');
  readonly submit = this.page.locator('button[type="submit"]');
  readonly error = this.page.locator('[role="alert"]');

  async goto() {
    await this.page.goto("/login");
  }

  async login(email: string, password: string) {
    await this.email.fill(email);
    await this.password.fill(password);
    await this.submit.click();
    // Wait for successful navigation
    await this.page.waitForURL("/dashboard/**");
  }

  async expectErrorMessage(message: string) {
    await this.error.locator(`:has-text("${message}")`).waitFor();
  }
}
```

**Conventions:**

- One page object per major app page/feature
- Use semantic locators: `getByRole()`, `getByLabel()`, `getByText()`
- Group related interactions into methods
- Methods should describe user actions, not implementation

</template>

## Auth Fixture (Reuse Login State)

<template id="auth-fixture">

```typescript
// tests/fixtures/auth.ts
import { test as base } from "@playwright/test";
import { LoginPage } from "../pages/login.page";

const TEST_USER = {
  email: process.env.E2E_TEST_EMAIL || "test@example.com",
  password: process.env.E2E_TEST_PASSWORD || "TestPassword123!",
};

export const test = base.extend<{ authenticatedPage: void }>({
  authenticatedPage: async ({ page, context }, use) => {
    const login = new LoginPage(page);
    await login.goto();
    await login.login(TEST_USER.email, TEST_USER.password);

    // Save auth state to avoid repeated logins
    await context.storageState({ path: "tests/.auth/state.json" });
    await use();
  },
});

export { expect } from "@playwright/test";
```

**Usage in tests:**

```typescript
import { test } from "../fixtures/auth";

test.use({ storageState: "tests/.auth/state.json" });

test("authenticated flow", async ({ page }) => {
  // User already logged in via fixture
  await page.goto("/dashboard");
});
```

</template>

## Critical Flow Tests

<template id="critical-flow">

```typescript
// tests/e2e/critical-flow.spec.ts
import { test, expect } from "../fixtures/auth";
import { DashboardPage } from "../pages/dashboard.page";
import { ResourcePage } from "../pages/resource.page";

test.use({ storageState: "tests/.auth/state.json" });

test.describe("Critical User Flow", () => {
  test("authenticate → create resource → verify", async ({ page }) => {
    const dashboard = new DashboardPage(page);
    const resource = new ResourcePage(page);

    // Navigate to dashboard (already authenticated)
    await dashboard.goto();
    await expect(dashboard.heading).toBeVisible();

    // Create primary resource
    await dashboard.createButton.click();
    await resource.nameInput.fill("Test Resource");
    await resource.descriptionInput.fill("Test description");
    await resource.submitButton.click();

    // Verify creation with URL pattern
    await expect(page).toHaveURL(/\/resources\/[\w-]+/);
    await expect(resource.heading).toContainText("Test Resource");
  });

  test("empty state prompts creation", async ({ page }) => {
    const dashboard = new DashboardPage(page);

    await dashboard.goto();
    // Verify guidance message shown
    await expect(page.getByText("Create your first resource")).toBeVisible();
  });

  test("validation prevents invalid creation", async ({ page }) => {
    const dashboard = new DashboardPage(page);
    const resource = new ResourcePage(page);

    await dashboard.goto();
    await dashboard.createButton.click();

    // Try submitting without required fields
    await resource.submitButton.click();

    // Verify error shown
    await expect(page.locator('[role="alert"]')).toContainText("Name required");
  });
});
```

**Customize:**

- Test core business flows (signup → onboard → create → use)
- Include empty state guidance
- Validate error handling
- Replace resource names with your domain entities

</template>

## Semantic Selectors (Prefer These)

```typescript
// Best: User-visible behavior
page.getByRole("button", { name: "Submit" });
page.getByLabel("Email address");
page.getByText("Welcome back");
page.getByPlaceholder("Enter name");

// Acceptable: Only when semantic not available
page.locator('input[name="email"]');
page.locator('[data-testid="submit-button"]');

// Avoid: Implementation details (change with design)
page.locator(".p-6.border.rounded");
page.locator("div:has-text('Submit')");
```

**Why semantic selectors:**

- Resilient to design refactors (test user behavior, not HTML)
- Match accessibility (screen readers see same elements)
- Fail with more helpful errors
- Document expected UI behavior

## Commands

```bash
npx playwright test                      # Run all tests
npx playwright test tests/e2e/auth.spec  # Run specific suite
npx playwright test --ui                 # Interactive UI mode
npx playwright test --debug              # Debug mode with inspector
npx playwright show-report               # View HTML report
npx playwright test --headed             # Run in visible browser
npx playwright test --headed --workers=1 # Single-threaded visible run
```

## Key Patterns

<template id="wait-patterns">

```typescript
// Wait for element visibility (prefer)
await page.locator('button[type="submit"]').waitFor();
await expect(element).toBeVisible();

// Wait for navigation
await page.waitForURL("/dashboard/**");

// Wait for API response
const response = await page.waitForResponse(
  (resp) => resp.url().includes("/api/items") && resp.status() === 200,
);

// Never use (flaky)
await page.waitForTimeout(3000);
```

</template>

## Debugging

```bash
# Trace debugging (captures network, DOM, console)
npx playwright test --trace on

# Then view trace
npx playwright show-trace trace.zip

# Step-by-step debugging
npx playwright test --debug
# Opens inspector, F10 to step through, hover to inspect
```

## Key Rules

<instructions id="testing-rules">

- Test critical revenue/engagement paths: signup → onboard → create entity → verify
- Use Page Object pattern for all page interactions (never raw selectors in tests)
- Use auth fixture with `storageState` to avoid re-logging in every test (saves time)
- Prefer semantic selectors (getByRole, getByLabel, getByText) over CSS selectors
- Semantic selectors test user behavior, not HTML structure (resilient to refactors)
- Add `data-testid` only when semantic selectors insufficient
- Keep tests independent: each test must work alone, in any order, with no side effects
- Test error states and edge cases: empty states, validation, missing resources

</instructions>
