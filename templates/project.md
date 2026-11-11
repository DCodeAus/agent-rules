<!--
  Project rules: save this as AGENTS.md in the repository root.
  Write down what a capable newcomer couldn't work out from the code in five
  minutes. Skip anything they could. Replace every <placeholder> and delete
  sections you don't need. Link to longer docs rather than pasting them in.
-->

# <Project name>

<One or two sentences: what this is, who uses it, and what matters most
(e.g. "correctness over speed: this moves money").>

## Commands
- Set up: `<e.g. make setup>`
- Test: `<e.g. make test>` (quick subset while iterating: `<e.g. make test-fast>`)
- Lint and format: `<e.g. make lint>`
- Run locally: `<e.g. make dev>` then open <http://localhost:PORT>

## Where things live
- `<src/...>`: <what's there>
- `<tests/...>`: <what's there>
- Architecture notes: `<docs/architecture.md>`

## Conventions
<!-- Only the ones a newcomer would get wrong. Give the reason for each. -->
- <e.g. "Use pnpm, not npm. The lockfile is pnpm's and CI rejects others.">
- <e.g. "Don't edit files under generated/; run `make codegen` instead.">

## Done means
- Tests and lint pass.
- The PR description says what changed and why, and how it was checked.

## Check with me before
<!-- Project-specific risky actions. General ones can live in your global rules. -->
- <e.g. "Changing database migrations that have already shipped.">
- <e.g. "Touching anything under infra/ or prod config.">

## Gotchas
<!-- Things that have bitten someone before, with the reason. -->
- <e.g. "Tests share one local database; run them serially (`-p 1`).">
