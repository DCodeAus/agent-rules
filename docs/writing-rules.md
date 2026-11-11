# Writing rules that age well

## What belongs in a rules file

**Durable, so keep it:**
- Facts about your environment: commands, paths, hosts, services, conventions
- Preferences, each with its reason
- What "done" means ("in a PR, with passing CI, description says why")
- Boundaries: exactly which actions need a human's sign-off
- Pointers to longer docs ("Architecture: `docs/architecture.md`")

**Goes stale fast, so leave it out:**
- Prompt tricks: "think step by step", "take a deep breath", "you are an expert…"
- Workarounds for tool bugs that have since been fixed
- Step-by-step procedures a capable model can work out itself
- Restatements of the tool's built-in behaviour
- Model or vendor names ("model X tends to…")

## Style

| Do | Don't |
|---|---|
| `Use pnpm. The lockfile is pnpm's and CI rejects others.` | `ALWAYS use pnpm!!!` |
| `Ask before deploying, deleting data or sending messages.` | `Always ask before doing anything.` |
| `Keep functions under ~50 lines where it reads naturally.` | `NEVER write long functions.` |
| `Put new endpoints in api/routes/, one file per resource.` | `Don't put endpoints in the wrong place.` |

- **Calm and specific.** Emphasis makes newer models over-apply a rule.
- **One fact per bullet.** Easier to scan, easier to delete later.
- **Give the reason.** It lets the model handle the cases you didn't think of.
- **Say what to do**, not only what to avoid.
- **Short.** Under ~150 lines for an always-loaded file. Split the rest into linked docs, or into path-scoped rules if your tool supports them.

## Layers

| Layer | Holds | Example |
|---|---|---|
| Personal (global) | Who you are, how you like work delivered, what needs your sign-off | "Open a PR; don't push to main." |
| Project (`AGENTS.md`) | Commands, layout, conventions, gotchas | "Run `make test-fast` while iterating." |
| Subfolder (`AGENTS.md` in a subfolder) | Rules only true for that part of the repo | "This package targets Node 18; no top-level await." |
| Enforcement (hooks, CI, permissions) | Things that must never fail | Branch protection, secret scanning |

Put each rule in the narrowest layer where it's true. If the same rule appears in two layers, delete one copy.
