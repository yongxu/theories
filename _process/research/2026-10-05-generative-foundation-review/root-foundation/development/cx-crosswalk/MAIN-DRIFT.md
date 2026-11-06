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

## Round two: searched by claim

The checkers of the first round found what its word search could not:

- endings changed at the very end of a sentence ("needs C." became "needs C or a premise in its place.");
- paraphrases of corrected claims;
- the eleven lines of AA's restatements, which main landed after the first round.

The second round reads every entry field that states one of the changed claims below, whatever its words. Its inputs, `reads/claims-<group>.in.json`, list fields that `claims.py`-style patterns matched. Each item has `id`, `field`, `anchor`, `text`, `matched` (the words that matched) and `family`. There are no `home_old` and `home_new`: read the home as it is now. Most items will already be right, so `leave` is the common verdict, and you must say why. Check each item against **every** claim below, not only its family's. The files and the rules are the same as the first round's: `reads/claims-<group>.json` for the author, `reads/claims-<group>.check.json` for the checker.

**The changed claims, with their homes now:**

1. **C's order (LM1).** 07 §4: "The condition alone ranks nothing … A ranking of courses needs C or a premise in its place: C gives order, and an order rising with one's own continuation ranks one case with no C". In 07's list of what is not shown: "That the ethics derives from the condition: the condition fixes scope and orders nothing; C gives order, and a ranking of courses needs C or a premise in its place."
   - A field saying that a ranking, an order of courses, or calling a course better "needs C", with no alternative, takes "C or a premise in its place".
   - "C gives order" and "the continuation condition for scope, C for order" are right as they stand.
   - A field saying that C alone orders, or that the ethics or C derives from the condition, is wrong.
   - Where the ethics is summarized, both premises are named: unasserted, their warrant open.
2. **Waiting, sparing, promises and ignition (AA's errata).**
   - 05 §5 and its D48 reading: restoring needs a formation that spares all it waits on, and giving is forced "only where some formation spares all it waits on". Mutual promises alone force no start.
   - Ignition is defined as spending a reserve: in the exchange witness it needs one already present, near-definitional.
   - COLLECTIVE-DIRECTION's exit is "Spare all one waits on", and its edge reads: where no formation spares all it waits on, total withholding, once reached, stays.
   - Read 05 §5, §11 and COLLECTIVE-DIRECTION §2 as they stand.
3. **COLLECTIVE-DIRECTION's edges.**
   - An edge that a loss is read only where a reader comes from outside was removed or narrowed: read the edge column as it stands, and the scheduled witness.
   - In the witness Pool the relational reading counts the first drawer, no longer each drawer.
4. **Joint ending and optima (AA's restatements, 05).**
   - Formations holding a level drain a commons gated at `m` wherever their losses together exceed what the rest gives it at each of `n` steps from a level below `n + m`. The old wording was "what renews it", ungated.
   - A term counted after an order with a plateau keeps what it counts "only as far as some way of reaching the plateau does, in total, not condition by condition".
   - Which optimum is taken where several reach the set point decides keeping "in the witness where a step can lose what it takes".
5. **Elsewhere.**
   - THE-THEORY §2: arising without end needs renewal "where each arising goes with a fall in some condition of a finite family".
   - 06: 天行健's row counts in whole numbers of a fixed unit.
   - The margin experiment: under mutual support and within a band, a condition's point of no return does not rise as its partner's level rises. It used to say "falls".
   - SCIENCES: under the first law no quantity of a finite enclosure's levels that never falls rises at every change.
   - The weights condition on `frontier_ends_drawn_first`'s witness.
   - 03: "Where the map moves every value", completing step by step is an unfolding incomplete at every step; some family says every reading exactly when all values are equal.

A field that restates one of these more widely than its home now does is a `replace`. A field that restates it rightly, or speaks of something else that happens to share the words, is a `leave`.
