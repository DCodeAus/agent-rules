# agent-rules

Templates, guides and a small linter for AI agent rules files. The repo is
markdown plus two scripts; there is nothing to build.

## Commands
- Lint the rules files: `bash scripts/lint-rules.sh` (or `pwsh scripts/lint-rules.ps1`)
- Check the shell script: `shellcheck scripts/lint-rules.sh`

## Conventions
- Keep `templates/` free of model and vendor names. The point of the repo is
  that the templates work with any tool.
- `scripts/lint-rules.sh` and `scripts/lint-rules.ps1` are twins: a change to
  one gets the same change in the other, so Windows and macOS/Linux users get
  the same results.
- Comment the scripts so someone who doesn't write code can run them.
- Tool filenames and settings in `docs/tool-setup.md` change often. Link each
  claim to the tool's official docs, and mark anything unconfirmed.

## Done means
- Both lint scripts pass and shellcheck is clean (CI runs all three).
- Changes arrive as a pull request with a short note on what changed and why.
