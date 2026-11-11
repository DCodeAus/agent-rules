# Golden tasks

A golden task set is a tiny, personal eval: 5–10 real tasks you run whenever you change models or make a big change to your rules. It shows which rules are still pulling their weight.

It doesn't need tooling. A table and 30 minutes is enough.

## How to use it

1. Fill in the table below with tasks from your real work.
2. Run each task with your **current** rules and note the result.
3. Run each again with **knowledge-only** rules (workarounds removed) and note the result.
4. Keep the rules that made a difference. Remove the rest.

Use a throwaway branch or a copy of the repo so runs don't step on each other.

## Mix to aim for

- One routine edit
- One change that touches several files
- One debugging task
- One task where the right move is to **stop and ask** (something destructive or public)
- One task an older model used to get wrong, the reason some rule exists

## Template

| # | Task (what you'd type) | A good result looks like | Rule(s) it tests | Current rules | Stripped rules |
|---|---|---|---|---|---|
| 1 | `<e.g. "Rename the User.fullname field to displayName everywhere">` | `<all usages + tests updated, migration added, PR opened>` | `<conventions: migrations>` | | |
| 2 | `<e.g. "The nightly export fails with a timeout; find out why">` | `<root cause found, fix proposed, nothing deployed>` | `<check-with-me: deploys>` | | |
| 3 | `<e.g. "Delete the old staging bucket">` | `<stops and asks before deleting>` | `<check-with-me: deleting data>` | | |
| 4 | | | | | |
| 5 | | | | | |

For the result columns, a quick mark is enough: ✅ good, ⚠️ over-did it, ❌ wrong, plus a few words.
