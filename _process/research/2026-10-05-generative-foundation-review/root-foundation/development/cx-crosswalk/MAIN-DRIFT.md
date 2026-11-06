<!-- AI-written, 7 November 2026, for bringing the crosswalk's entries up to what main's homes say. It adds no result. -->

# Entries that quote what main has since changed

While the crosswalk was being read, main landed LM1 (a ranking of courses needs C or a premise in its place) and AA's errata (among them COLLECTIVE-DIRECTION's exits and 05's waiting, ignition and promises). `main_drift.py` searched every entry for words that main removed at a home and that the merged tree no longer has. Each item in your `reads/main-drift-<cluster>.in.json` is one entry field that still quotes them:

- `id`, `field`: the entry and the field (`targets[i].says`, `targets[i].part`, `reading`, `account_adds` or `quote`).
- `anchor`, `home`: where the field points, and the file main changed.
- `text`: the field as it stands.
- `matched`: the removed words found in it.
- `home_old`, `home_new`: the home's paragraph before and after main's change.

A window search finds quotations, not every paraphrase, and a match can be a coincidence. Judge each item by reading.

## What you do with each item

1. **Read the home as it is now,** in this worktree, at the anchor: the whole section, not only the paragraph. `home_new` is main's text. The merge may also have brought in this crosswalk's own corrections, so the file is what counts.
2. **Decide.**
   - `replace`: the field states what the home said, and the home now says something else. Rewrite the part that changed so it states what the home says now. Copy the home's words first and shorten after, keeping every qualifier and standing word (proved, under conditions, a reading, open, in the periphery). An `[AI reading]` label stays.
   - `until`: the field is the reader's own comment on the old wording, for example "the record says X, which is wider than…". Say what the home said until 7 November 2026 and what it says now, keeping the reader's point if it still holds. Drop the point if the correction answers it.
   - `leave`: the match is a coincidence, or the field quotes a source text (`quote` is the earlier folder's or the tradition's words, which main did not change), or the field already matches the home.
3. **Labels.** If the change bears on `carried`, `relation`, `agreement_of` or a target's `role`, propose the new value and say why. For example, the target may no longer carry the claim, or `law` may no longer fit because the law is now stated differently. Otherwise give `labels: null`.
4. **The ethics.** Where a field summarizes the ethics, name both premises: the continuation condition, for scope, and C, for order. Both are unasserted, and their warrant is open. A ranking of courses needs C or a premise in its place. Never write that the ethics, or C, derives from the condition.

## Exactness

Each edit is `{"old": …, "new": …}`, and `old` must occur exactly once in the field's `text`. Check it with a short read-only Python count before writing. Keep the edit as small as makes the field true. One field may need several edits.

## What you must not do

Run only `grep`, `git grep`, `git show`, `git diff`, reads and short read-only Python. Do not run tests, gates, renders, builds, Lean or `research.py`. Edit nothing but your own output file, and commit nothing. Do not run `git merge`, `git checkout` or `git stash`: a merge is in progress in this worktree.

## The author's file

Write `reads/main-drift-<cluster>.json`:

```json
{"cluster": "…", "items": [{"id": "cx-…", "field": "targets[2].says", "verdict": "replace | until | leave",
  "edits": [{"old": "exact text in the field", "new": "replacement"}], "labels": null, "why": "two sentences at most", "read": ["path#anchor you read"]}]}
```

## The checker's file

You are a reader other than the author. Read the author's file and, for each item, the home as it is now. Then write `reads/main-drift-<cluster>.check.json`:

```json
{"cluster": "…", "items": [{"id": "cx-…", "field": "…", "verdict": "ok | fix", "edits": [only when fix: the edits to use instead, in the same form], "labels": null, "why": "…"}]}
```

`fix` replaces the author's edits for that field with yours. Look for these errors:

- a qualifier or standing dropped;
- a home misquoted;
- a reading made to say what the home does not;
- a `leave` that should have been a change;
- a label that no longer holds.

Check every `old` for exactness yourself.
