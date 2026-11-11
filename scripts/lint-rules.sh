#!/usr/bin/env bash
# =============================================================================
# lint-rules.sh: check AI agent rules files for patterns that tend to go stale
# =============================================================================
#
# WHAT IT DOES
#   Reads one or more markdown rules files (AGENTS.md, CLAUDE.md, GEMINI.md,
#   copilot-instructions.md, ...) and points out lines that usually stop
#   helping when you move to a newer model:
#     - shouted emphasis words (IMPORTANT, CRITICAL, MUST, NEVER, ALWAYS, ...)
#     - repeated exclamation marks (!!)
#     - prompt tricks ("think step by step", "you are an expert", ...)
#     - model or vendor names (rules that name a model go stale)
#     - files over 150 lines (always-loaded files cost attention every turn)
#   Text inside ``` code blocks is skipped, so example commands are not flagged.
#
# WHAT YOU NEED FIRST
#   macOS or Linux with bash and awk (both are built in). Windows users can
#   run the twin script instead: pwsh scripts/lint-rules.ps1
#
# HOW TO RUN IT
#   bash scripts/lint-rules.sh                  # checks this repo's AGENTS.md and templates
#   bash scripts/lint-rules.sh path/to/AGENTS.md path/to/CLAUDE.md
#   bash scripts/lint-rules.sh --warn-only FILE # report, but never fail
#
# WHAT IT PRODUCES
#   One line per finding:   FILE:LINE  [check]  the line's text
#   Then a summary. The exit code is 1 if anything was found (so CI or a
#   pre-commit hook can stop), or 0 if the files are clean or --warn-only is set.
#
# WHAT TO DO NEXT
#   For each finding, decide: is this a fact the model needs (keep it, in calm
#   wording, with the reason), or a workaround for an old model (delete it)?
#   docs/model-upgrade-guide.md walks through that decision.
#
# KEEP IN STEP WITH: scripts/lint-rules.ps1 (same checks, same word lists).
# =============================================================================

set -euo pipefail

# Longest an always-loaded rules file should be before we suggest splitting it.
MAX_LINES=150

# --- Read the command line ---------------------------------------------------
# --warn-only means "show findings but still exit 0". Everything else is a file.
warn_only=0
files=()
for arg in "$@"; do
  case "$arg" in
    --warn-only) warn_only=1 ;;
    -h|--help)   sed -n '2,40p' "$0"; exit 0 ;;
    *)           files+=("$arg") ;;
  esac
done

# With no files given, check this repo's own rules file and templates.
# (Paths are worked out from where this script lives, so it runs from any folder.)
if [ "${#files[@]}" -eq 0 ]; then
  repo_root="$(cd "$(dirname "$0")/.." && pwd)"
  files=("$repo_root/AGENTS.md" "$repo_root"/templates/*.md)
fi

# --- Check each file ---------------------------------------------------------
total=0
for file in "${files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Skipping $file (file not found)" >&2
    continue
  fi

  # awk reads the file line by line and prints a line for every finding.
  # Word checks split each line into words, so "CI" or "PRs" never match by
  # accident, and only the exact words in the lists below are flagged.
  findings="$(awk -v file="$file" -v max_lines="$MAX_LINES" '
    BEGIN {
      # Shouted emphasis: flagged only when written in CAPITALS.
      split("IMPORTANT CRITICAL MUST NEVER ALWAYS ABSOLUTELY MANDATORY REQUIRED WARNING NOT DON", e, " ")
      for (i in e) emphasis[e[i]] = 1
      # Model and vendor names: flagged in any capitalisation.
      split("claude anthropic openai chatgpt gpt gemini sonnet opus haiku llama mistral copilot", m, " ")
      for (i in m) vendor[m[i]] = 1
      # Prompt tricks: phrases, matched in lower case.
      n_tricks = split("step by step|deep breath|you are an expert|you are a world-class|world-class engineer|you are a senior|i will tip|your job depends", tricks, "|")
    }
    # Skip fenced code blocks: ``` toggles "inside code" on and off.
    /^[[:space:]]*```/ { in_code = !in_code; next }
    in_code { next }
    {
      line = $0
      lower = tolower(line)

      if (index(line, "!!")) print file ":" NR "  [exclamation]  " line

      for (i = 1; i <= n_tricks; i++)
        if (index(lower, tricks[i])) { print file ":" NR "  [prompt-trick]  " line; break }

      # Break the line into words (letters only) and check each one.
      words = line
      gsub(/[^A-Za-z]+/, " ", words)
      n = split(words, w, " ")
      shout = 0; named = 0
      for (i = 1; i <= n; i++) {
        if (w[i] in emphasis) shout = 1
        if (tolower(w[i]) in vendor) named = 1
      }
      if (shout) print file ":" NR "  [emphasis]  " line
      if (named) print file ":" NR "  [model-name]  " line
    }
    END {
      if (NR > max_lines)
        print file ":" NR "  [length]  " NR " lines (aim for under " max_lines "; link longer docs instead)"
    }
  ' "$file")"

  if [ -n "$findings" ]; then
    echo "$findings"
    count="$(printf '%s\n' "$findings" | wc -l | tr -d ' ')"
    total=$((total + count))
  fi
done

# --- Summary and exit code ---------------------------------------------------
if [ "$total" -eq 0 ]; then
  echo "No stale patterns found."
  exit 0
fi

echo
echo "$total finding(s). See docs/model-upgrade-guide.md for how to decide what stays."
if [ "$warn_only" -eq 1 ]; then exit 0; fi
exit 1
