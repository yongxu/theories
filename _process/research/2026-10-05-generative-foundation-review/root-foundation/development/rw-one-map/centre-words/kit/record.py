#!/usr/bin/env python3
# AI-written, 13 November 2026. Adds Round 6 (the lead and first path said from the centre paragraph) to the map's
# record, its folder to the record's table, and Ren's words to the sources record.
import sys
root = sys.argv[1]
R = root + '/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rw-one-map/README.md'
t = open(R, encoding='utf-8').read()
assert '## Round 6' not in t
SEC = '''## Round 6: the lead and the first path said from the centre paragraph (13 November)

On 13 November the account's centre was said again in AGENTS.md and on the fronts (board item DW, step 1): a selection is one dynamic among others; what makes a difference to it; what sustains it. The map's lead and its first path still said it with a rule that reads, counts, leaves out, picks and holds itself in place, with a loss "nothing inside reads" and steps "given from outside". Ren said "Yes, do it" to re-saying them ([his words](../../../../../../sources/15-codex-theory-conversations/2026-11-08-representation-to-eight.md)). This round, board item WM2, changes words only: no row, box or arrow was added, removed or re-pointed, and the map's form is as it was.

How it was run, and what went wrong on the way:

1. **A first English, by the coordinator (Fable), swapped the centre paragraph's phrases in** (`centre-words/kit/english-v1.py`). Six AI readers read it: three against the Lean, two cold (a general reader and an alignment researcher), one by AGENTS.md's four questions (`centre-words/readers/check-*.md`). They found it heavier than the old text in every place they compared, and saying more than the proofs in several:
   - "The loss changes the rest's judgments" for "the rest count the loss". In `ReadInTime` the rest judge one way until the loss passes a set amount and another way after; nothing asks that the two differ. In the built example `PoolFromCourse.Drained` those removed judge against the favoured side whatever the loss.
   - "What sustains it" for what is used up. In the centre paragraph that is the selection's own need (`TurningInTime`'s level); on this path what is used up is what others live on.
   - The lead dropped "can" and step 2's conditions, and joined step 8 to step 9, which the path itself says no theorem joins.
   - "Proved under its stated conditions alone" asserted two kinds of proof where the map only marks some premises.
2. **A second English started from the old sentences** and changed only what had the old shape (`english-v2.py`): the rest still "count the loss", things still "live on" what is used up, a loss still "gets back"; "makes no difference to the rule" stands only where the Lean's condition is that the loss changes neither what is selected next nor how the rule is set; "the pool" names those an update sets the rule from; "a further premise" stands where the map said "given from outside". Three Lean readers rechecked it against their own first reports and a fresh reader read it cold (`readers/check2-*.md`).
3. **A third and a last pass took their exact fixes** (`english-v3.py`, then `english.py` as landed; `readers/check3-english.md`).
4. **The Chinese** was written by two AI writers from the Chinese of the centre paragraph, starting from the old Chinese of each field, read by a third against the English, and adjusted by the coordinator in ten fields where the English changed after they wrote (`centre-words/chinese/`).

What changed, by count: 110 English fields and 104 Chinese fields of `sheet.json`, `passages.json` and `paths.json` (`centre-words/old-new-english.json`, `old-new-chinese.json`): the lead; the first path's title, lead, word list, 18 steps, summary and "what the work wants"; the sentences and tags of its 22 arrows and one stay; 12 box names and 11 box descriptions; two row names and one band name; and the marking in the summaries of the other four paths and in the legend of `tools/research/map_sheet.py` and `map_sheet.html`.

Premises the old sentences had left out and the new ones state: that being favoured never lowers a share (step 2, `RuleCapture.uniform_locks`); that the lock stays only from a locked start and only while the loss changes neither what is selected next nor how the rule is set (steps 3 and 6); that the loss grows at every step (steps 9 and 14); that the turn holds only at or past the set amount (step 9); that the shapers must be present for their share to fall (step 11); the order premise and the needs met before the step (step 15). One claim was withdrawn: in the built example of step 16 the rule only favoured the other side at two steps; it had not turned.

Kept on purpose: "count the loss" and "the loss counts" (the account's word for what enters a judgment, which the theorems leave open); "one order further" in step 18, as chapter 02 states those orders; "locked" and "the lock"; the examples; the tests' lines under the steps, which still say "a judge that reads its own earlier picks".

What is still weak:

- The first path is longer than it was (the page stays under its reading budget only because "what the work wants" now points to step 9 instead of repeating it). A cold reader still found 8 of 18 steps harder than the old ones before the last pass; no person has read the result.
- Step 1 names no theorem and is unmarked; steps 3 and 17 are marked as needing a further premise although their content is that premise.
- The other four paths and the 83 arrows off the first path were not re-said, beyond the one marking. The scan of 13 November found paths four and five already said as relations.
- "Early enough" still stands on two theorems in two models (steps 8 and 9). `TurningInTime.turns_in_time_iff_before`, landed that evening, states a turn and a point of no return on one course; anchoring the map on it would change arrows and waits for the map's form.
- The front pages' questions of a selection are drafted and not applied (`centre-words/fronts-drafts-not-applied.md`); they are the second part of WM2.

'''
anchor = '## What the layer under the map does not hold'
assert t.count(anchor) == 1
t = t.replace(anchor, SEC + anchor)
row_anchor = '| `theorem/` | Round 5:'
assert t.count(row_anchor) == 1
i = t.index(row_anchor); j = t.index('\n', i)
row = ('\n| `centre-words/` | Round 6: the readers\' reports of three rounds (`readers/`), the four versions of the English as scripts (`kit/`, with the readers\' briefs), the Chinese lists (`chinese/`), '
       'every changed field old and new (`old-new-english.json`, `old-new-chinese.json`), the first path as it stood before (`first-path-before.txt`) and the front drafts not yet applied. '
       'The scripts name this machine\'s working folders and are a record, not a tool to run as they stand |')
t = t[:j] + row + t[j:]
open(R, 'w', encoding='utf-8').write(t)
S = root + '/sources/15-codex-theory-conversations/2026-11-08-representation-to-eight.md'
s = open(S, encoding='utf-8').read()
assert '### The first path, said from the centre (13 November 2026)' not in s
s = s.rstrip('\n') + '''

### The first path, said from the centre (13 November 2026)

#### Context (AI-authored)

After the three edits to AGENTS.md the session restarted with an account switch, and he wrote:

#### Ren's words

> continue please - token account switched, restart your stopped workflow as well

#### What was done (AI-authored)

No reader workflow had been cut off; a lint check had, and was rerun. The coordinator landed four small changes from the dig (a record says what holds; the register to 13 November; the briefs of 11 and 12 November marked as a record; kept history left out of plain searches). Another session landed the centre paragraph in AGENTS.md and on the fronts (DW, step 1), which he had left to the two sessions with "work with the coordinator - no need to ask my approval" ([that session's record](2026-11-13-what-a-law-is-and-the-words.md)). The coordinator then put to him the piece that landing had left to the map's session, with its scale: the questions asked of a selection on the front pages, and the map's lead and first path, re-said in the centre paragraph's words, words only. He chose the answer the coordinator had written:

#### Ren's words

> Yes, do it

#### What was done (AI-authored)

The map's part was written three times: the first version put the centre paragraph's phrases in and, by six AI readers' reports, read heavier than the old text and said more than the proofs in places; the second started from the old sentences and changed only what had the old shape; the third took the readers' exact fixes. The Chinese was written from the Chinese of the centre paragraph and read against the English. It landed as the first part of board item WM2; how it was made and what is still weak is in [the map's record, Round 6](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rw-one-map/README.md). The front pages' part follows.
'''
open(S, 'w', encoding='utf-8').write(s)
print('ok')
