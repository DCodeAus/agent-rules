# agent-rules

**Rules files for AI coding agents that work with any model and any provider.**
Includes templates, a playbook for upgrading to a new model, and a small linter that catches rules likely to go stale.

Works with anything that reads a markdown instructions file: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`, Cursor rules, Aider conventions and more. See [docs/tool-setup.md](docs/tool-setup.md).

---

## The core idea

Every rules file mixes two kinds of content:

| | **Knowledge** | **Compensation** |
|---|---|---|
| What it is | Facts the model can't know on its own | Workarounds for a particular model's weaknesses |
| Examples | "Tests run with `make test`." "Ask before running migrations." "Keep my employer's name out of public repos." | "IMPORTANT!!! ALWAYS read the file first." "Think step by step." "You are a world-class engineer." |
| When you switch models | Still true. **Keep it.** | Often unneeded, sometimes harmful. **Re-test it.** |

Newer models tend to follow instructions *more* closely. A rule you shouted at an older model can make a newer one over-apply it. It asks too many questions, runs too many checks or pads its answers.

> **Keep what's true, re-test what's a workaround, enforce anything that can never be allowed to fail with code, and write the reason next to every rule.**

---

## Quick start

1. **Copy a template.**
   - Personal rules that follow you into every project: [`templates/global.md`](templates/global.md)
   - Rules for one repository: [`templates/project.md`](templates/project.md), saved as `AGENTS.md` in the repo root

2. **Fill in the `<placeholders>` and delete whatever doesn't apply.** Short beats complete.

3. **Point your tools at it.** Most tools now read `AGENTS.md` directly. For the ones that don't, [docs/tool-setup.md](docs/tool-setup.md) shows a one-line import or setting, with no symlinks needed.

4. **Lint it.**
   ```bash
   bash scripts/lint-rules.sh path/to/AGENTS.md          # macOS / Linux
   pwsh scripts/lint-rules.ps1 path/to/AGENTS.md         # Windows / PowerShell
   ```

---

## What's inside

```
agent-rules/
├── templates/
│   ├── global.md          personal rules, loaded everywhere
│   └── project.md         per-repo rules (save as AGENTS.md)
├── docs/
│   ├── model-upgrade-guide.md   what to do when a new model ships
│   ├── writing-rules.md         how to write rules that age well
│   ├── golden-tasks.md          a tiny eval you run before/after an upgrade
│   ├── before-after.md          a real-looking rules file, audited
│   └── tool-setup.md            filenames + settings per tool, and hard rules via hooks/CI
├── scripts/
│   ├── lint-rules.sh      checks rules files for stale patterns (bash)
│   └── lint-rules.ps1     same checks (PowerShell, for Windows)
├── tests/
│   └── bad-rules.md       a deliberately bad file CI uses to prove the linter still works
└── AGENTS.md              this repo's own rules (yes, it uses them itself)
```

---

## Principles

1. **One source of truth.** Keep one `AGENTS.md` and have each tool read it or import it. Don't keep five copies that slowly drift apart.
2. **Facts over tricks.** Commands, paths, conventions, boundaries. Leave out "you are an expert" and other prompt-engineering tricks.
3. **Give the reason.** "Use pnpm, because the lockfile is pnpm's" handles edge cases that "use pnpm" can't.
4. **Calm, plain sentences.** No ALL CAPS, no `!!!`. Emphasis makes newer models over-apply a rule.
5. **Say what needs sign-off, specifically.** Not "always ask first", but "ask before deploying, deleting data or sending messages".
6. **Enforce with code, guide with prose.** Anything that must hold every single time belongs in a hook, permission rule or CI check.
7. **Keep it short.** Under ~150 lines for an always-loaded file. Link to longer docs instead of pasting them.
8. **Re-test on every model generation.** Run a handful of real tasks with the rules on and with them stripped back, then keep the rules that still make a difference. See the [upgrade guide](docs/model-upgrade-guide.md).

---

## The linter

`scripts/lint-rules.sh` (and its PowerShell twin) is a quick check, not a judge. It flags:

| Check | Why |
|---|---|
| Shouted emphasis (`IMPORTANT`, `CRITICAL`, `MUST`, `NEVER`, `ALWAYS`, …) | Newer models over-apply emphasized rules |
| Repeated exclamation marks (`!!`) | Same |
| Prompt tricks ("think step by step", "you are an expert", …) | Built into modern models, so they just add noise |
| Model or vendor names | Rules that name a model go stale when you switch |
| Files over 150 lines | Always-loaded files cost tokens and attention on every turn |

It exits with `1` when it finds something, so you can drop it into CI or a pre-commit hook. Add `--warn-only` to report without failing.

Acronyms like `CI`, `PR`, `API` and `SSH` are fine. It only looks for a fixed list of emphasis words.

---

## Contributing

Issues and PRs are welcome, especially corrections to [docs/tool-setup.md](docs/tool-setup.md), since tool filenames and settings change often. Please keep `templates/` free of model and vendor names, and keep the `.sh` and `.ps1` scripts in step with each other.

## License

[MIT](LICENSE)
