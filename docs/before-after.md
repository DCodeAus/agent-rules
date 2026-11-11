# Before and after

A typical rules file that has built up over a year of patching, and the same file after an audit.

<!-- The "before" block deliberately contains the patterns the linter flags. -->

## Before

```markdown
## RULES - READ CAREFULLY!!!
- You are a world-class senior engineer.
- IMPORTANT: ALWAYS read files before editing them. NEVER edit without reading.
- You MUST think step by step before every action.
- CRITICAL: Do NOT forget to run tests!!!
- Always ask me before doing anything.
- Be extremely thorough and explain everything in detail.
- Use pnpm.
- NEVER push to main.
```

## After

```markdown
## Project
- Node app managed with pnpm (`pnpm install`, `pnpm test`). Don't use npm or
  yarn; the lockfile is pnpm's and CI rejects others.

## Delivering changes
- Open a pull request for review.
  (Pushing to main is blocked by branch protection, so it isn't a prose rule.)

## Check with me before
- Deploying, deleting data, or sending messages. Routine edits and running
  tests don't need a check-in.

## Done means
- Relevant tests pass, and the PR says what changed and why.
```

## What changed, and why

| Before | After | Reason |
|---|---|---|
| "You are a world-class senior engineer" | Removed | Role-play prompt trick; adds nothing |
| "ALWAYS read files before editing" | Removed | Modern agents do this by default |
| "think step by step" | Removed | Built in to modern models |
| "Do NOT forget to run tests!!!" | Folded into "Done means" | Same intent, calm wording, and it says when tests count |
| "Always ask me before doing anything" | Specific list of what needs sign-off | A blanket rule causes constant interruptions |
| "Be extremely thorough and explain everything" | Removed | Causes padded answers |
| "Use pnpm" | Kept, with the reason | Real project knowledge; the reason covers edge cases |
| "NEVER push to main" | Moved to branch protection | Must never fail, so it's enforced by the platform, not prose |

The "after" version is shorter, and it holds more real information.
