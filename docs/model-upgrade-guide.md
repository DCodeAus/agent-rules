# Upgrading to a new model

**Should you delete all your rules files when a new model comes out? No. Audit them.**

## Why neither "delete it all" nor "keep it all" works

**Deleting everything** throws away facts the new model has no way to rediscover: build commands, paths, conventions, what needs sign-off, lessons from past incidents. You'd re-teach it one mistake at a time.

**Keeping everything** carries forward workarounds for the *old* model's weaknesses:
- Shouted emphasis (`CRITICAL`, `MUST`, `!!!`) that makes a stronger model rigid or over-cautious
- Step-by-step scripts that stop it choosing a better approach
- Contradictions that built up from months of patching
- Bloat. Every always-loaded line costs tokens and attention on every turn.

## The playbook

Do this for each new model *generation*. Minor point releases rarely need it.

### 0. Back up
Put your rules files in git (or at least make a dated copy). An audit is only safe when you can roll it back.

### 1. Pick 5–10 golden tasks
Real tasks you do often and know well, each with a short note on what a good result looks like. Use [golden-tasks.md](golden-tasks.md) as the template. Include at least one task where a rule exists *because* an older model got it wrong.

### 2. Run them with your current rules
Note where the new model **over-does** something (too many questions, too many checks, too wordy), takes a rule **too literally**, or **still** makes the mistake a rule was written to prevent.

### 3. Run them again with stripped-back rules
Keep only the knowledge (facts, preferences, boundaries). Remove every workaround. Run the same tasks again.

If a task gets *worse*, the rule behind it is still earning its place. Add those back one at a time, in calm wording.

### 4. Rewrite what survives
- Drop the emphasis: write `Run the tests before opening a PR`, not `YOU MUST ALWAYS RUN TESTS!!!`
- Add the reason. A model that knows *why* can handle the edge cases.
- Say what you want, not only what to avoid.
- Merge duplicates and resolve contradictions.

### 5. Move hard rules into code
Anything that must happen every time goes in a hook, permission setting or CI check, not prose. See [tool-setup.md](tool-setup.md#enforcing-rules-that-can-never-fail).

### 6. Lint and commit with a note
```bash
bash scripts/lint-rules.sh AGENTS.md
git commit -m "Audit agent rules for new model" -m "Removed 9 workaround rules (no change on golden tasks).
Kept 2 that still prevented mistakes, with reasons added.
Moved the format-before-commit rule to a pre-commit hook."
```
Next time, you'll know which rules survived a migration and why.

## Signs your rules are fighting the model

| What you see | Likely cause |
|---|---|
| It asks permission for trivial things | A blanket "always ask first" rule |
| It runs the full test suite after a one-line typo fix | "Always run all tests" with no sense of scale |
| It sticks rigidly to your steps when a better path is obvious | Over-prescriptive procedure |
| Answers are padded with summaries and caveats | Old "be thorough / explain everything" rules |
| A rule shows up where it plainly doesn't apply | Emphasis causing over-triggering |
| It hedges or seems confused | Two rules contradict each other |

## Work patterns to revisit

A new model can change *how* you work with it, not just what you write down.

- **Task size.** Each generation handles bigger, vaguer chunks. If you still break everything into tiny steps, try handing over a whole outcome and checking the result.
- **Planning.** Keep explicit plan-first for large or risky changes. Routine ones often don't need it any more.
- **Verification.** Keep it, but make it proportionate to the change.
- **Multiple agents.** Re-check whether splitting work across several agents still beats one stronger agent with more context.
- **Context.** Bigger windows tempt you to load everything. Keep always-loaded files lean and load reference docs on demand.
- **Saved memory.** If your tool keeps notes between sessions, prune them too: delete what's no longer true, merge duplicates, and turn "it kept getting X wrong" notes into golden tasks.
- **Which model for what.** A new top model can make the previous tier good enough for routine work. Re-check where the cheaper model is fine.

## Checklist

- [ ] Rules files backed up or committed
- [ ] Golden tasks written, with what "good" looks like
- [ ] Ran with current rules; noted over-reactions
- [ ] Ran with knowledge-only rules; noted regressions
- [ ] Re-added only rules that prevented regressions, each with a reason
- [ ] Removed emphasis, duplicates, contradictions, prompt tricks
- [ ] Moved must-always rules into hooks, permissions or CI
- [ ] Pruned saved memory or notes
- [ ] Revisited task size, planning, multi-agent use and model tier
- [ ] Linted and committed with a short note on what changed
