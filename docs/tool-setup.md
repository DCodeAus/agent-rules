# Tool setup

The aim is **one `AGENTS.md` per repo and one personal rules file**, with every tool reading those files rather than keeping its own copy.

> Checked against official docs in **November 2026**. These tools change fast. If something here is out of date, the linked page is the authority (and a PR fixing this file is very welcome).

## Project rules (one `AGENTS.md` in the repo root)

| Tool | Reads `AGENTS.md`? | What to do | Docs |
|---|---|---|---|
| **OpenAI Codex** | Yes, natively | Nothing. Nested `AGENTS.md` files in subfolders layer on top. | [Custom instructions with AGENTS.md](https://developers.openai.com/codex/guides/agents-md) |
| **Claude Code** | Yes, in recent versions, but only when the project has **no** `CLAUDE.md` | If the project also needs a `CLAUDE.md`, put `@AGENTS.md` on its first line to import it. | [How Claude remembers your project](https://code.claude.com/docs/en/memory) |
| **Cursor** | Yes, natively (root and subfolders) | Nothing. Use `.cursor/rules/*.mdc` only for rules that should apply to certain paths. | [Rules](https://cursor.com/docs/context/rules) |
| **GitHub Copilot** | Yes (coding agent, VS Code, CLI) | Nothing. If you also have `.github/copilot-instructions.md`, both are used, so keep shared rules in `AGENTS.md`. | [Custom instructions](https://docs.github.com/en/copilot/concepts/prompting-and-context/custom-instructions) · [VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-instructions) |
| **Gemini CLI** | When configured | Add the snippet below to `.gemini/settings.json`. | [GEMINI.md files](https://geminicli.com/docs/cli/gemini-md/) |
| **Aider** | When configured | Add `read: AGENTS.md` to `.aider.conf.yml`, or run `aider --read AGENTS.md`. | [Conventions](https://aider.chat/docs/usage/conventions.html) |
| **Windsurf** | Unconfirmed | Check the docs. If it isn't read directly, reference it from Windsurf's rules. | [Windsurf docs](https://docs.windsurf.com) |

**Gemini CLI**, `.gemini/settings.json`:
```json
{
  "context": {
    "fileName": ["AGENTS.md", "GEMINI.md"]
  }
}
```
Older Gemini CLI versions used a top-level `"contextFileName"` key instead. Run `/memory refresh` after editing.

**Claude Code**, `CLAUDE.md` (only if you need one alongside `AGENTS.md`):
```markdown
@AGENTS.md

<!-- Claude-specific notes only below this line. Shared rules live in AGENTS.md. -->
```

### Why not symlinks?
Symlinks (`ln -s AGENTS.md CLAUDE.md`) work on macOS and Linux, but they often check out as plain text files on Windows, and some agents' edit tools don't follow them. An import line or a setting works the same everywhere.

## Personal rules (everywhere you work)

| Tool | Where your personal file goes |
|---|---|
| OpenAI Codex | `~/.codex/AGENTS.md` (an `AGENTS.override.md` next to it takes priority) |
| Claude Code | `~/.claude/CLAUDE.md` |
| Gemini CLI | `~/.gemini/GEMINI.md` |
| Cursor, Copilot, others | Usually a "user rules" or "personal instructions" box in the app's settings. Paste in your file. |

**Keeping one copy:** store your filled-in [`templates/global.md`](../templates/global.md) somewhere permanent, such as `~/agent-rules/global.md`. Then:
- Where imports are supported (Claude Code, Gemini CLI), make the tool's file a single line: `@~/agent-rules/global.md`
- Elsewhere, copy it in and re-copy when you change it

## Enforcing rules that can never fail

Prose rules are followed *most* of the time. When something must hold every single time, use a mechanism that doesn't depend on the model:

| Rule | Enforce with |
|---|---|
| "Format and lint before committing" | A git pre-commit hook (or the [pre-commit](https://pre-commit.com) framework) |
| "Tests must pass" | CI, plus branch protection on the default branch |
| "Never force-push to main" | Branch protection |
| "Never commit secrets" | `.gitignore` plus secret scanning (e.g. gitleaks, GitHub push protection) |
| "Don't run destructive commands" | Your agent's permission or approval settings (most agents have an allow/deny list or sandbox mode) |
| "Do X after every edit" | Your agent's hook system, if it has one |

The agent-specific settings (permission lists, hooks, sandbox modes) are different in every tool, so they aren't part of the shared templates. Configure them in each tool and keep `AGENTS.md` for the judgment calls.

### Lint your rules in a pre-commit hook

```bash
# .git/hooks/pre-commit  (make it executable: chmod +x .git/hooks/pre-commit)
#!/usr/bin/env bash
bash path/to/agent-rules/scripts/lint-rules.sh AGENTS.md
```
