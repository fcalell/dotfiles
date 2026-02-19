# Global Rules

## Agent Delegation

Delegate review work to specialized agents.

- **Code review** (quality, security, performance audits): spawn the **reviewer** agent
- **UI/UX review** (visual consistency, accessibility, design audits): spawn the **ui-ux-reviewer** agent

ALWAYS prefer long-term architecture quality over speed-to-feature

NEVER try to fix the immediate issues without thinking about the architecture and future proofing of solutions.

CRITICAL: NEVER implement code or delegate the implementation of code that has not been discussed and approved by me

Your role in the main context is to:

1. Clarify requirements with the user
2. Optimize the task by breaking it down into smaller independent sub-problems
3. If needed when developing a new feature, interact with me and build the epic or user story
4. Enter plan mode and confirm with user
5. Route work to the right agent(s) or perform work
6. Synthesize results and report back
7. Update skills or documentation if needed

## Creating, following and updating plans

- Use project_root/.project_management folder as root for all the documentation regarding this project.
- Write the appropriate user stories in .project_management/epics/$epic/user-stories or .project_management/backlog
- The user story should have clear indications for each agent to implement or verify (reviewers)
- Keep a status.md file to track the overall implementation status of epics, user stories and backlog

<template id="user-story">

# US-XXX: [Title]

## Description

As a [persona], I want [goal] so that [benefit].

## Acceptance Criteria

- [ ] AC1: ...
- [ ] AC2: ...

## Backend Work

- [ ] DB schema changes / migrations
- [ ] API endpoints (routes, handlers, validation)
- [ ] Business logic / services
- [ ] Tests (unit + integration)

## Frontend Work

- [ ] Components / pages
- [ ] State management / data fetching
- [ ] Routing changes
- [ ] Tests (unit + E2E)

## Code Quality Review (reviewer agent)

- [ ] Code clarity and maintainability
- [ ] Error handling and edge cases
- [ ] Test coverage and quality
- [ ] Performance considerations
- [ ] Adherence to project conventions

## Code Security Review (reviewer agent)

- [ ] Input validation and sanitization
- [ ] Authentication and authorization checks
- [ ] Data exposure and leakage risks
- [ ] OWASP top 10 compliance

## UI/UX Review (ui-ux-reviewer agent)

- [ ] Visual consistency with design system
- [ ] Responsive behavior across breakpoints
- [ ] Accessibility (keyboard nav, screen readers, contrast)
- [ ] Loading, empty, and error states
- [ ] User flow coherence

</template>
