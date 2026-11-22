# A reading of the level alone, over every marking that does not mark the start's level: how `Becoming.LevelAlone` was made

*AI-written (Claude Fable, board row FM), 23 November 2026. The record of one night's work on one new module of the package. The module's own head note says what it proves; this note says how it came about, who read which form, what was wrong on the way and what it cost. Nothing here is a result beyond what the Lean states, and that an actual selection meets the module's premises no proof gives.*

## Where it came from

The row's order of 22 November was to set the four sentences on a selection in the alignment paragraph of AGENTS.md against the Lean, and then try one whole as a claim that can fail. [The read](READ-four-sentences.md.txt) found each sentence stated by a law, and both statements first tried whole came apart on paper into laws already there (the turn law for a draw that rises; a growing line removed by the fall). A search on small numbers made beside it showed something of another form: on the module's own worked course of a rising lock (`TurningInTime.Three.rise_count_ends`), by the time the level first differs it is already too late for a return to the draw the course started with. Row DJ, which keeps `TurningInTime`, saw in that a statement with the reading quantified, where every law of that module takes the marked levels as given, and gave four things that would count against it. The statement was written on paper against those four ([the paper](PAPER.md.txt)), row DJ tried to break it and could not, and asked for two changes: the right side said with `Recoverable`, and the same condition said in the use of the moment.

## What the module states, in short

A *marking* is a decided set of levels; under it the way after a step at a marked level is one fixed correction, handed in, and elsewhere the way's step as it was. With `D` the first step at which the level of the course as it was differs from the start's:

- **The core** (`silent_at_start_iff_next_of_stays_below`): given that the course as it was, once below the corrected kind's point of no return `H₂ + y₂`, stays below (`below`), some marking that does not mark the start's level gives a line that never ends exactly where the level at step `D + 1` is at or above `H₂ + y₂`. The `+ 1` is the lag: the step from the first marked level is still taken under the use as it was.
- **One marking for all** (`silent_at_start_iff_marking_all_but_start`): under the same premises, some such marking succeeds exactly where the marking of every level but the start's does.
- **Two ways of having `below`:** where the corrected use is no more than the course's first use (`silent_at_start_iff_next_of_le`), with nothing asked of giving beyond the regime at the corrected use; and for any corrected use, where the step under no use does not fall as the level rises and the start's own step does not raise the level (`silent_at_start_iff_next`, through `level_never_rises_of_rises`).
- **Three more forms** under the second way's premises: recoverable at step `D + 1`; no marking succeeds exactly where the course's point of no return is at or before `D + 1`; and the use at step `D` plus `y₂` at most the level at step `D`.
- **Five worked courses:** `Twelve` (no marking silent at twelve succeeds, though the level at the first step that differs is still above the threshold), `Seven` (one succeeds), `Rising` (the level rises before it gives out, 3, 3, 4, 4, 0; the first way applies and the second way's premise fails), `WithoutMono` and `WithoutStill` (each meets every premise of the second way but one, checked by Lean as a conjunction, and the law's two sides are apart).

What it does not state: the response of a selection derived (what a marking sets is handed in; only which levels it marks is quantified); any older law as a case; any join of two places of the map.

## The forms, and who read each

| Form | Lines | Made by | Builds | Read by |
|---|---|---|---|---|
| first | 594 | a Claude implementer, from [brief 1](BRIEF.md.txt) frozen at 00:32:09 WIB | 1 to 5 | two Claude readers who took no part ([1](returns/reader-1.json.txt), [2](returns/reader-2.json.txt)) |
| second | 946 | a second Claude implementer, from [brief 2](BRIEF-2.md.txt) and [its addendum](BRIEF-2-ADDENDUM.md.txt) | 6 to 8 | one Claude reader ([3](returns/reader-3.json.txt)) |
| third | 1,084 | a third Claude implementer, from [brief 3](BRIEF-3.md.txt) | 9, 10 | a reader of another kind of model, Astra 6.2, whole, against all the briefs ([its read](returns/astra-read.txt)) |
| fourth | 947 | that reader, applying its own findings ([what it was asked](ASTRA-REPAIR.md.txt), [its report](returns/astra-repair.txt)) | 11 (run by the session) | one Claude reader on the diff from the third form ([4](returns/reader-4.json.txt)) |
| landed | 1,004 | the fourth reader's eleven mends, applied in its words by a script of count-checked replacements ([the script](apply_reader4.py.txt)); then the head note's paragraphs re-flowed with no word changed | 12, 13 | not read again; by the lister its statements and proof terms are byte-identical to the fourth form's ([third](rows-third-form.txt), [landed](rows-landed-form.txt)) |

Between the third form and the fourth, every declaration as Lean holds it was compared by script ([the comparison](compare_rows.out.txt)): three public statements lost one binder each (`keeps₀` from `level_never_rises_of_rises`; `pos` from both `stays_below` laws), one public theorem was added (`silent_at_start_iff_marking_all_but_start`), 46 public statements are identical binder by binder, none was removed or renamed.

## What was wrong on the way, and whose fault

- **A premise that follows from another** (`keeps` from `keeps₀`), frozen into brief 1 by the session. Found by the first implementer and both first readers. Dropped.
- **A worked course that did not show what the brief said.** Brief 1 gave a course as showing that the monotone premise is needed. It fails a second premise (`meets`) as well. The session's search behind it had compared the two sides of the statement without checking the regime's premises. Both first readers found it by hand. Run again with every premise checked by the program ([the search](search/premises_search.py.txt), [the witnesses](search/witnesses.py.txt)), it showed more than the fault: where the corrected use is no more than the course's first use, the statement needs neither `mono` nor `still`. That is where the first way of having `below`, and the core under `below`, came from.
- **A premise that could go from five laws** (`up`, beside `rises`), frozen into brief 2. Found by the third reader. Dropped there.
- **Two more premises** (`pos` twice, `keeps₀` once), and about fourteen sentences of the telling that said more than the proofs, chief among them: the head note ran together the level a marking marks and the level one step later that decides; and three docstrings left the draw out of the range of `Meets`, which read literally would exclude the module's own witness course. Found by the other model's read.
- **A phrase kept out.** Row DJ's addendum asked that the law be told as "the first level that differs is the last chance". The second implementer left it out; the other model gave a course by hand on which a later marking also succeeds (ceiling eight, giving one on what is left one to seven, draw two rising by one, correction to one; levels 8, 7, 5, 2, 0), and row DJ checked it and withdrew the phrase. What the law gives is one direction: where the earliest marking silent at the start's level is too late, every later one is.
- **The explicit list of what is not shown** was cut by the fourth form's shortening. Found by the fourth reader; put back in its words.

## What stays open, none of it started

Argued by a reader and not built, as the head note marks them: `mono` only on what is left within `hi`; `still` only where `D = 1`; `rises` replaceable by a condition that the course as it was gives out (plain `≤` is false, with a course by hand); `rest` and `differs` each needed in one direction only; the recoverable and no-return forms under `below` in place of a course that never rises, which would generalise three laws of `TurningInTime` (open on row DJ's row, its module). No condition on the regime's numbers says which side of the laws a course falls on.

## What it cost, with the caps

Stated beforehand to row DJ and the coordinator: 1.5 million tokens on the Claude side for one implementer, two readers and the check of this note; 3 million for one read by the other model; at most 30 scratch builds.

- Claude side, by the runs' own counts: 633,270 (first form and two readers), 485,310 (second form and one reader), 173,832 (third form), 194,659 (the reader of the fourth form): 1,487,071. Three implementers and four readers, where one and two were said. The check of this note took it over the 1.5 million; that was told to both sessions before it started.
- The other model, by its tool's own footers: 1,211,800 for the read and 9,280,900 for the repair turn, 10,492,700 against the 3 million said. The repair was given to a continued session, which sends the whole thread again with each command; the tool's note says most of that is cached, and the footer does not separate it. The session knew the note and did not size the run by it. The cap was passed before the session could know, and both sessions were told when the footer came.
- Scratch builds: thirteen, each of the one module; then one core run at the landing (nine steps run, 1,647 reused, 35 seconds).
- A fault in the session's build script: its wait matched any process whose command line mentioned a heavy run, so the other model's build waited on its own launcher and never ran, and row GR's gate, whose wait had the same pattern, did not start for about 49 minutes. Mended in both.
- Rule 6: the scratch build and its first two readers started before the claim was on the board. The claim says so.

## Where it is

The module: `Becoming/LevelAlone.lean` in the package. Beside this note, as text: the paper; the three briefs, the addendum and their hashes; what the other model was asked for its read and for its repair; the returns of the three implementers, the four Claude readers and the other model; the first, second, third and fourth forms; the diff from the third to the fourth; the lister and its two prints with the comparison; the searches; the build logs; the read of the four sentences this came from.
