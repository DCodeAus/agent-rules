<#
=============================================================================
lint-rules.ps1: check AI agent rules files for patterns that tend to go stale
=============================================================================

WHAT IT DOES
  Reads one or more markdown rules files (AGENTS.md, CLAUDE.md, GEMINI.md,
  copilot-instructions.md, ...) and points out lines that usually stop
  helping when you move to a newer model:
    - shouted emphasis words (IMPORTANT, CRITICAL, MUST, NEVER, ALWAYS, ...)
    - repeated exclamation marks (!!)
    - prompt tricks ("think step by step", "you are an expert", ...)
    - model or vendor names (rules that name a model go stale)
    - files over 150 lines (always-loaded files cost attention every turn)
  Text inside ``` code blocks is skipped, so example commands are not flagged.

WHAT YOU NEED FIRST
  PowerShell 7 or later (the "pwsh" command). It also runs on macOS/Linux.

HOW TO RUN IT
  pwsh scripts/lint-rules.ps1                    # checks this repo's AGENTS.md and templates
  pwsh scripts/lint-rules.ps1 path\to\AGENTS.md path\to\CLAUDE.md
  pwsh scripts/lint-rules.ps1 -WarnOnly FILE     # report, but never fail

WHAT IT PRODUCES
  One line per finding:   FILE:LINE  [check]  the line's text
  Then a summary. The exit code is 1 if anything was found (so CI or a
  pre-commit hook can stop), or 0 if the files are clean or -WarnOnly is set.

WHAT TO DO NEXT
  For each finding, decide: is this a fact the model needs (keep it, in calm
  wording, with the reason), or a workaround for an old model (delete it)?
  docs/model-upgrade-guide.md walks through that decision.

KEEP IN STEP WITH: scripts/lint-rules.sh (same checks, same word lists).
#>

param(
    # Report findings but always exit 0.
    [switch]$WarnOnly,
    # The files to check. Leave empty to check this repo's own files.
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Files
)

$ErrorActionPreference = 'Stop'

# Longest an always-loaded rules file should be before we suggest splitting it.
$MaxLines = 150

# Shouted emphasis: flagged only when written in CAPITALS.
$Emphasis = @('IMPORTANT','CRITICAL','MUST','NEVER','ALWAYS','ABSOLUTELY','MANDATORY','REQUIRED','WARNING','NOT','DON')
# Model and vendor names: flagged in any capitalisation.
$Vendors = @('claude','anthropic','openai','chatgpt','gpt','gemini','sonnet','opus','haiku','llama','mistral','copilot')
# Prompt tricks: phrases, matched in lower case.
$Tricks = @('step by step','deep breath','you are an expert','you are a world-class','world-class engineer','you are a senior','i will tip','your job depends')

# With no files given, check this repo's own rules file and templates.
# (Paths are worked out from where this script lives, so it runs from any folder.)
if (-not $Files -or $Files.Count -eq 0) {
    $repoRoot = Split-Path -Parent $PSScriptRoot
    $Files = @(Join-Path $repoRoot 'AGENTS.md') +
             @(Get-ChildItem (Join-Path $repoRoot 'templates') -Filter *.md | ForEach-Object FullName)
}

$total = 0
foreach ($file in $Files) {
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
        Write-Warning "Skipping $file (file not found)"
        continue
    }

    $lines = Get-Content -LiteralPath $file
    $inCode = $false
    $lineNo = 0

    foreach ($line in $lines) {
        $lineNo++

        # Skip fenced code blocks: ``` toggles "inside code" on and off.
        if ($line -match '^\s*```') { $inCode = -not $inCode; continue }
        if ($inCode) { continue }

        $lower = $line.ToLowerInvariant()

        if ($line.Contains('!!')) {
            Write-Output "${file}:$lineNo  [exclamation]  $line"; $total++
        }

        foreach ($t in $Tricks) {
            if ($lower.Contains($t)) {
                Write-Output "${file}:$lineNo  [prompt-trick]  $line"; $total++
                break
            }
        }

        # Break the line into words (letters only) and check each one, so
        # "CI" or "PRs" never match by accident.
        $words = ($line -replace '[^A-Za-z]+', ' ').Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)

        # -ccontains is case-sensitive (capitals only); -contains is not.
        $shout = $false; $named = $false
        foreach ($w in $words) {
            if ($Emphasis -ccontains $w) { $shout = $true }
            if ($Vendors -contains $w)   { $named = $true }
        }
        if ($shout) { Write-Output "${file}:$lineNo  [emphasis]  $line"; $total++ }
        if ($named) { Write-Output "${file}:$lineNo  [model-name]  $line"; $total++ }
    }

    if ($lines.Count -gt $MaxLines) {
        Write-Output "${file}:$($lines.Count)  [length]  $($lines.Count) lines (aim for under $MaxLines; link longer docs instead)"
        $total++
    }
}

# Summary and exit code
if ($total -eq 0) {
    Write-Output 'No stale patterns found.'
    exit 0
}

Write-Output ''
Write-Output "$total finding(s). See docs/model-upgrade-guide.md for how to decide what stays."
if ($WarnOnly) { exit 0 }
exit 1
