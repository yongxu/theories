# The opening's notes, about three minutes each

*AI-written, 31 October 2026, for board item RN and the release gate's item 6 ([WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#the-release-gate-30-october-2026)); AJ4's [reading budgets](../aj4-alignment-readers/READING-BUDGETS.md#the-budgets) give the opening's notes three minutes each, 300 words. Not reviewed by a person. About five minutes to read.*

## What changed

Fifteen of the 24 notes of [the opening](../../../../../../theories/becoming/OPENING.md) were over 300 words. Six are now 300 or fewer, about three minutes at the kit's rates (100 to 130 words a minute); nine are over by 5 to 82 words, the excess what may not be cut ([below](#excess-amendment-1)). The body, in Ren's first person, is unchanged byte for byte, and so are the nine shorter notes. The packet cover ([README](../../../../../../theories/becoming/review/README.md), [README.zh](../../../../../../theories/becoming/review/README.zh.md)) also states its own reading time at its top now: seven to nine minutes, and five to seven for the Chinese.

| Note | Before | After |
|---|---:|---:|
| law | 698 | 298 |
| conditions | 1,093 | 358 |
| proof | 407 | 287 |
| axiom | 612 | 299 |
| ethics | 420 | 297 |
| good-evil | 651 | 325 |
| alignment | 753 | 382 |
| cancer | 461 | 339 |
| meta | 467 | 315 |
| no-law | 521 | 306 |
| present | 1,062 | 382 |
| aligned | 654 | 324 |
| race | 400 | 305 |
| transitions | 406 | 299 |
| collective | 378 | 295 |
| all 24 notes | 10,239 | 6,067 |

Counted by AJ4's rule (visible prose, link targets not counted), on the notes as they stand in OPENING.md. AJ4's [measure](../aj4-alignment-readers/kit/measure_layers.py) reads the rendered README instead. There it counts each note's list number, one word more per note, and it counts the README's closing list as part of the last note, `collective` (487 words there, against 295 counted alone). That count is the measure's split, not the note's length. So it reports 10 over 300: the nine below, and `collective`.

## Method

- **What each note keeps:** its bold standing; the hypotheses that decide its claims; what is open; what is a reading, a judgment or a diagnosis; the prior work it restates; the evidence of a thesis as it fell; and the support for the body sentence it annotates, the one ending at its marker. Where a note summarizes the ethics, both premises are named with their roles: the continuation condition for scope, C for order.
- **What may leave a note:** detail stated in its home, meaning a chapter's home section `r-<record id>` or the record itself (statement, laws, hypotheses, what it does not show). Before a sentence was cut, every theorem name in the old note was looked up in the chapters and records. Each one is stated in at least one record, and the new note links that record's home section or page. The prior work cited only in the opening stays in its note: Murata 1989 (proof), Karwowski et al. 2024 (alignment) and Morgenthau (no-law).
- **Body ties:** where an old note tied a phrase back to the body ("whatever has lasted", "at its optimum", "neither does looking further ahead", "highly entangled", "the one question", "which conclusion goes"), the new note keeps the tie. So does each body sentence's own claim: the shared condition in `aligned`, plenty in `present`, minds remade by the readers' condition in `meta`, the self and the competitors in `no-law`, and the whole gaining nothing in `race`.
- **No cited section edited:** no record cites a section of OPENING.md by anchor. The new text adds nothing to any chapter, because no dropped detail lacked a home.

## The records that cite the opening

Eight records cite OPENING.md as a whole file: closed-capture, readers-drawn-from-the-selected (both `meta`), mutual-dependence-and-its-pace (`present`), relative-position-is-zero-sum (`aligned`, `race`), whole-drawing-beyond-renewal-ends (`collective`), confined-rise-within-a-whole (`transitions`), what-position-reads (`no-law`) and what-the-dynamics-leave-open (`ethics`). The first five were located by a note that links their page. The last three were not, so any changed line of the file drifted them. Their notes now link their pages, which locates them for the drift check.

Each record's statement was read against its new note:

- closed-capture: a loss not read leaves the loop locked, and a change of the reading is absorbed, so what leaves is a change of the law. Stated.
- readers-drawn-from-the-selected: read from the share exactly where each carrier reads at least as favourably as each other does, and the counts at the step the others read the loss decide for good. Stated; this clause was restored after the first cut dropped it.
- mutual-dependence-and-its-pace: strictly between sharing conditions and mutual feeding, which makes bounded significance the continuation condition, and the exponential pace. Stated; restored after the first cut dropped it.
- relative-position-is-zero-sum: zero-sum by counting, and the race ends a part through its dependence, not its position. Stated.
- whole-drawing-beyond-renewal-ends, confined-rise-within-a-whole, what-position-reads, what-the-dynamics-leave-open: each stated.

Nothing these records say changed. They are re-pointed to the new bytes with `tools/research/repoint.py`, one line in `_process/architecture/rebinds.jsonl` giving the reason.

## The independent read

One independent AI reader, with no part in the cut, read the 15 new notes against the old ones, the chapters and the records, for errors, unhomed losses, body ties, the eight records and links. It found 32 problems: 15 errors, 9 body ties, 2 losses and 6 minor points. Most were deciding hypotheses the first cut dropped. Among them:
- the theorem's conditions were lost from a narrowing ranked above its widening;
- a weighting faster than renewal was linked to the wrong row;
- constructed witnesses were read as general: the readers in time, the winner's own presupposition, and drawers by halves;
- the gate on a race's renewal was dropped, and "with nothing given" under the doubling draw;
- "no condition" was written for the continuation condition;
- "classically" was dropped from the four cases;
- the other half of the pace, exponential both ways, and the share ratio for mutual-dependence-and-its-pace were lost.
Every finding was taken. A re-check found 29 of the 31 fixed and 2 partly fixed: the word "Archimedean", and "not rejected at their thresholds" in place of "passed". The fixes had brought six new errors and one lost tie: the web where something lives; the share ratio's transmission hypothesis and its home; others drawing first at every step, however slightly; "no less", not "more"; the prior-argument link to the record; finite worlds with activity decided; and plenty as a claim about amounts. All are taken, and so are the three cuts it named as losing nothing (the restated body claims in `present`, the direction's content in `alignment`, the bounded-centers sentence in `no-law`).

<a id="excess-amendment-1"></a>
## Excess (amendment 1)

Nine notes are over 300 words: conditions 358, alignment 382, present 382, cancer 339, good-evil 325, aligned 324, meta 315, no-law 306 and race 305. The excess is what the read required to be restored: deciding hypotheses, the support for body sentences after the marker (in `conditions`, "no general method can tell" and the part that closes what it does not depend on; in `alignment`, every clause of the body's optimum sentence), and the frozen tests as they fell. The re-check found nothing in conditions, good-evil, cancer, meta or aligned that could go with nothing lost. At 100 to 130 words a minute the longest takes 2.9 to 3.8 minutes.

## Home sections

No chapter text was added or changed. Every theorem a cut dropped is stated in a record, and the new note links the record's home section or page. Where a theorem's name is in a record but not written in its chapter's home section, that is how the chapters already stand (they state results in words and give names selectively), not a gap this item opened, and this item leaves them as they are. The one citation with no home, Cury et al. 2011 (`cancer`), stays in its note.
