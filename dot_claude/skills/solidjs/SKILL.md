---
name: solidjs
description: Fine-grained reactive UI with SolidJS. Use when building components, managing state, handling reactivity, routing, or data fetching in SolidJS applications.
---

# SolidJS

Fine-grained reactive framework where components run once and only reactive expressions update.

## Reactivity Primitives

<template id="signals-and-derivations">

```tsx
import { createSignal, createMemo, createEffect, batch, untrack } from "solid-js";

// Signal: getter function + setter function
const [count, setCount] = createSignal(0);
count();              // read (subscribes)
setCount(5);          // write
setCount(c => c + 1); // functional update

// Derived signal: just a function (no caching)
const doubled = () => count() * 2;

// Memo: cached derived value (recomputes only when deps change)
const expensive = createMemo(() => heavyWork(count()));

// Effect: side effect tracking deps automatically
createEffect(() => {
  console.log("count changed:", count());
});

// Batch: group updates, effects run once
batch(() => {
  setFirst("Jane");
  setLast("Doe");
});

// Untrack: read without subscribing
createEffect(() => {
  console.log(count(), untrack(() => other()));
});
```

**Key rules:**

- Signals are getter functions — always call `count()`, not `count`
- Prefer plain derived functions over `createMemo` unless computation is expensive
- Never use `createEffect` to sync state — use derived signals or memos instead

</template>

## Component Patterns

<template id="props-handling">

```tsx
import { splitProps, mergeProps, children } from "solid-js";

// NEVER destructure props — breaks reactivity
// BAD: function Comp({ name }) { ... }

// Access through props object
function Greeting(props) {
  return <h1>Hello {props.name}</h1>;
}

// splitProps: reactive destructuring alternative
function Button(props) {
  const [local, others] = splitProps(props, ["class", "children"]);
  return <button class={local.class} {...others}>{local.children}</button>;
}

// mergeProps: default props
function Card(props) {
  const merged = mergeProps({ variant: "default", size: "md" }, props);
  return <div class={merged.variant}>{merged.children}</div>;
}

// children helper: resolve children for manipulation
function Wrapper(props) {
  const resolved = children(() => props.children);
  return <div>{resolved()}</div>;
}
```

</template>

## Control Flow

<template id="control-flow">

```tsx
import { Show, For, Index, Switch, Match } from "solid-js";
import { Dynamic, Portal } from "solid-js/web";

// Conditional (prefer over ternary/&&)
<Show when={user()} fallback={<p>Loading...</p>}>
  {(u) => <p>Hello {u().name}</p>}
</Show>

// List by reference (item fixed, index is signal)
<For each={items()} fallback={<p>No items</p>}>
  {(item, index) => <li>{index()}: {item.name}</li>}
</For>

// List by index (index fixed, item is signal) — better for primitives
<Index each={items()}>
  {(item, index) => <li>{index}: {item()}</li>}
</Index>

// Multi-condition
<Switch fallback={<NotFound />}>
  <Match when={route() === "home"}><Home /></Match>
  <Match when={route() === "settings"}><Settings /></Match>
</Switch>

// Dynamic component
<Dynamic component={selected()} someProp="value" />

// Render outside DOM hierarchy
<Portal mount={document.getElementById("modal-root")}>
  <Modal />
</Portal>
```

**Key rules:**

- Use `<For>` for object arrays (keyed by reference), `<Index>` for primitives
- `<Show>` callback receives an accessor — call it: `u().name`
- Avoid `.map()` / ternary / `&&` in JSX — control flow components provide reactive boundaries

</template>

## Async & Error Boundaries

<template id="async-patterns">

```tsx
import { createResource, Suspense, ErrorBoundary, lazy } from "solid-js";

// Resource: async signal with loading/error states
const [userId, setUserId] = createSignal(1);
const [user, { mutate, refetch }] = createResource(userId, async (id) => {
  const res = await fetch(`/api/users/${id}`);
  return res.json();
});

user()          // data or undefined
user.loading    // boolean
user.error      // error or undefined
mutate(value)   // optimistic update
refetch()       // re-run fetcher

// Suspense boundary
<Suspense fallback={<Spinner />}>
  <UserProfile />
</Suspense>

// Error boundary
<ErrorBoundary fallback={(err, reset) => (
  <div>
    <p>Error: {err.message}</p>
    <button onClick={reset}>Retry</button>
  </div>
)}>
  <RiskyComponent />
</ErrorBoundary>

// Code splitting
const Heavy = lazy(() => import("./Heavy"));
Heavy.preload(); // optional preload
```

</template>

## Stores

<template id="stores">

```typescript
import { createStore, produce, reconcile, unwrap } from "solid-js/store";

const [store, setStore] = createStore({
  user: { name: "Alice", age: 30 },
  todos: [{ id: 1, text: "Learn Solid", done: false }],
});

// Path syntax (surgical updates, only affected nodes rerender)
setStore("user", "name", "Bob");
setStore("todos", 0, "done", true);
setStore("todos", t => t.id === 1, "done", d => !d); // filter + update

// Immer-style mutations
setStore(produce(s => {
  s.user.name = "Jane";
  s.todos.push({ id: 2, text: "Ship it", done: false });
}));

// Efficient diffing for external data (API responses)
const serverData = await fetchData();
setStore("todos", reconcile(serverData));

// Get raw JS object (for APIs, serialization)
const raw = unwrap(store);
```

**Key rules:**

- Path syntax for targeted updates; `produce` for complex mutations
- Use `reconcile` when replacing store data from server responses
- Never destructure stores — same rule as props

</template>

## Context

<template id="context">

```tsx
import { createContext, useContext } from "solid-js";
import { createStore } from "solid-js/store";

const ThemeCtx = createContext({ mode: "light", toggle: () => {} });

function ThemeProvider(props) {
  const [state, setState] = createStore({ mode: "light" });
  const value = {
    get mode() { return state.mode; },
    toggle() { setState("mode", m => m === "light" ? "dark" : "light"); },
  };
  return <ThemeCtx.Provider value={value}>{props.children}</ThemeCtx.Provider>;
}

function Consumer() {
  const theme = useContext(ThemeCtx);
  return <button onClick={theme.toggle}>{theme.mode}</button>;
}
```

</template>

## Lifecycle & Refs

<template id="lifecycle-refs">

```tsx
import { onMount, onCleanup, createEffect } from "solid-js";

function Component() {
  let canvas: HTMLCanvasElement;

  // Runs once after mount
  onMount(() => {
    const ctx = canvas.getContext("2d");
  });

  // Cleanup on unmount
  const handler = (e: Event) => { /* ... */ };
  document.addEventListener("click", handler);
  onCleanup(() => document.removeEventListener("click", handler));

  // Cleanup inside effects (runs on re-execution AND unmount)
  createEffect(() => {
    const timer = setInterval(() => console.log(count()), 1000);
    onCleanup(() => clearInterval(timer));
  });

  return <canvas ref={canvas!} />;
}
```

</template>

## Custom Directives

<template id="directives">

```tsx
import { onCleanup, Accessor } from "solid-js";

function clickOutside(el: Element, accessor: Accessor<() => void>) {
  const handler = (e: Event) => {
    if (!el.contains(e.target as Node)) accessor()();
  };
  document.addEventListener("click", handler);
  onCleanup(() => document.removeEventListener("click", handler));
}

// Prevent tree-shaking
false && clickOutside;

// Usage
<div use:clickOutside={() => setOpen(false)}>Dropdown</div>

// TypeScript declaration
declare module "solid-js" {
  namespace JSX {
    interface Directives {
      clickOutside: () => void;
    }
  }
}
```

</template>

## Event Handling

<template id="events">

```tsx
// Delegated events (lowercase on___)
<button onClick={(e) => handleClick(e)}>Click</button>
<input onInput={(e) => setValue(e.currentTarget.value)} />

// Non-delegated (on:___) for custom/non-bubbling events
<div on:customEvent={handler} />
<video on:loadedmetadata={handler} />

// Capture phase
<div oncapture:scroll={handler} />

// Pass data without closures (calls handler(data, event))
<button onClick={[handler, itemId]}>Click</button>
```

**Note:** `onChange` fires on every change (not on blur like React).

</template>

## Router (@solidjs/router)

<template id="routing">

```tsx
import { Router, Route } from "@solidjs/router";
import { lazy } from "solid-js";
import { query, createAsync, action, redirect } from "@solidjs/router";

// Route definition
<Router root={AppLayout}>
  <Route path="/" component={lazy(() => import("./pages/Home"))} />
  <Route path="/users/:id" component={UserPage} />
  <Route path="*404" component={NotFound} />
</Router>

// Data loading with query + createAsync
const getUser = query(async (id: string) => {
  const res = await fetch(`/api/users/${id}`);
  return res.json();
}, "user");

export const route = {
  preload: ({ params }) => getUser(params.id),
};

export default function UserPage() {
  const params = useParams();
  const user = createAsync(() => getUser(params.id));
  return <div>{user()?.name}</div>;
}

// Mutations with action
const addTodo = action(async (formData: FormData) => {
  await fetch("/api/todos", { method: "POST", body: formData });
  throw redirect("/todos");
});

<form action={addTodo} method="post">
  <input name="title" />
  <button type="submit">Add</button>
</form>
```

</template>

<template id="navigation">

```tsx
import { A, useParams, useSearchParams, useNavigate, useLocation } from "@solidjs/router";

<A href="/about" activeClass="active">About</A>

const navigate = useNavigate();
navigate("/dashboard", { replace: true });

const params = useParams();       // reactive route params
const [search, setSearch] = useSearchParams();
setSearch({ page: 2, sort: "name" });

const location = useLocation();   // pathname, search, hash
```

</template>

## Key Patterns

1. **Components run once**: Component body is setup code — only reactive expressions in JSX update
2. **No destructuring**: Never destructure props or stores — use `splitProps`/`mergeProps`
3. **No dependency arrays**: Effects auto-track — no `useEffect([deps])` equivalent
4. **No hooks rules**: Signals/effects work anywhere — conditionals, loops, outside components
5. **Derived state is a function**: `const full = () => first() + last()` — no `useMemo` needed
6. **Control flow components**: Use `<Show>`/`<For>`/`<Switch>` over JS conditionals in JSX
7. **Path syntax stores**: `setStore("path", "to", "value")` for surgical updates
8. **Reactivity without components**: Signals work globally — export from modules freely

## Reactivity Rules

### State modeling
- Model state machines as a single signal with a discriminated union — never split across a mutable object and a separate signal
- Signals that always change together belong in a single signal with an object value
- Never use multiple booleans as an implicit state machine — use a discriminated union

### Derived state
- If a value can be computed from existing state, make it a memo — never store it in a signal kept in sync via effects
- Use `createResource` for async derived state — it handles dedup, cancellation, and loading natively; never manually manage these with effects + mutable flags + loading signals
- Don't create memos just to narrow types — pass the original data and let TypeScript structural typing handle it

### Effects
- Effects should never write to signals — that's derived state in disguise; use memos or resources
- Handle side effects at the mutation site, not reactively — e.g. "exit focus on delete" belongs in the delete callback, not in an effect watching for deletion
- Register event listeners directly with `onCleanup` — don't wrap `addEventListener` in `createEffect`
- Never use time-based hacks (`Date.now()`, `setTimeout`) for state coordination — the state model is wrong

### State ownership
- If a parent needs to read or act on child state, the parent owns it and passes it down — never push child state up via effects or callback refs
- Use TanStack `mutation.isPending` for async operations — never manually track loading state with signals

### Component structure
- Each hook/component should own a single concern — the composition shell is thin wiring
- Use `<Show>` guards over fallback dummy objects — never write `data ?? { id: "", name: "" }`
- No inline IIFEs in JSX — extract to named memos
- Define shared items once — if two UIs render the same actions (dropdown + context menu), extract and consume from both
