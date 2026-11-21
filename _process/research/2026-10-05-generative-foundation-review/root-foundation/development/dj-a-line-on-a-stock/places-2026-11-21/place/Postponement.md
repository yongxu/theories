# Postponement

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Postponement.lean`
- *result records that name this place's file as a source* (computed; not a link): `tests-fix-likeness-where-determined`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-13, as "Postponement.lean: postponed_trace_members, postponed_trace_iff, sameTests_iff_postponed_alike" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-13.md.txt)); pass b: reader whole-b-50, as "Postponement.lean: Frame.postponed, Frame.postponed_determinedAt, sameTests_iff_postponed_alike, alike_postponed_iff_determined, Frame.postponed_trace_iff, Choosing.postponed_alike" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-50.md.txt)); the third pass, where the two differed: reader whole-c-settle-19, as "Postponement.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-19.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For arbitrary frames, two states pass the same linear tests exactly when their singleton families are alike after postponement (l. 163). A frame is everywhere alike to its postponement exactly when it is everywhere determined up to likeness (l. 179).
  - *pass b:* General laws for any frame (a process with moves and realized claims): the frame with every branching postponed (families of configurations) is determined up to likeness everywhere, and two configurations pass the same linear tests exactly when their postponements are alike, so linear tests miss exactly where the unfolding branches. A frame is alike to its postponement at every configuration exactly when it is determined up to likeness everywhere; the built Choosing.late/early witness it.
- **moves**
  - *pass a:* S: `Frame.postponed_trace_iff` (l. 110) gives executability of any move list from an inhabited family exactly when some member executes it in the original frame.
  - *pass b:* S: `Frame.postponed_trace_iff` (l. 110): from an inhabited family, the postponed frame takes a course `as` exactly where some member takes it in `F.P`; `Frame.postponed_trace_members` (l. 75): the reached family is everything reached from the start's members. The moves are `F.P.step s a t` of an arbitrary frame.
- **a reading**
  - *pass a:* S: `Frame.postponed_tests_iff` (l. 119) characterizes a claim realizable after a move list by an original member reaching a state realizing that claim.
  - *pass b:* S: `sameTests_iff_postponed_alike` (l. 163): for any frames `F`, `G`, `SameTests F G s s'` exactly when `Alike F.postponed G.postponed (Eq s) (Eq s')`: what linear tests register decides likeness only after postponing branchings. S: `sameTests_postponed` (l. 143). B: `Choosing.postponed_alike` (l. 191), `Choosing.early_not_alike_postponed` (l. 196).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *settled by the third pass:* N. `Frame.postponed_trace_iff` (l. 110): for a family `X` with a member, the postponed frame takes a course `as` from `X` exactly when some member takes it; `alike_postponed_iff_determined` (l. 179): a frame is alike to its postponement exactly where it is determined up to likeness. Both are equivalences between two descriptions, not a dichotomy of going on and ending or of keeping and losing for one model. [which pass was right: b; opened: `Frame.postponed` l.46, `postponed_trace_iff` l.110, `postponed_tests_iff` l.119, `sameTests_iff_postponed_alike` l.163, `alike_postponed_iff_determined` l.179, `Choosing.early_not_alike_postponed` l.196.]
  - *pass a:* S: `Frame.postponed_trace_iff` (l. 110) equates availability of the specified finite course from an inhabited family with its availability from some member. It concerns continuation through a specified finite list.
  - *pass b:* N (S: `alike_postponed_iff_determined` (l. 179) is an iff between likeness to the postponement and being determined, not of going on and ending).
- **a comparison between two**
  - *pass a:* S: `sameTests_iff_postponed_alike` (l. 163) carries linear-test equivalence between frames to likeness of their postponed starts and conversely.
  - *pass b:* S: `Frame.postponed_members` (l. 51): families with the same members are related by a bisimulation of the postponed frame; `sameTests_iff_postponed_alike` (l. 163) between two frames; `DeterminedAt.of_alike_postponed` (l. 170): a configuration alike to its postponement is determined up to likeness.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* S: `Frame.postponed_trace_inhabited` (l. 89) shows that every executable trace from an inhabited family ends in an inhabited family.
  - *pass b:* S: `Frame.postponed_members` (l. 51) gives a `Bisimulation` (a relation closed under steps both ways) on the postponed frame; `Frame.postponed_determinedAt` (l. 68). No invariant or largest closed region of states.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: Read the opening account, every declaration statement and its docstring. Statements — states, moves, reading, both_outcomes, comparison, closed_region. Not found — share, level, giving, cost, multiplying, no_return, rank, forms_change. No answer rests on commentary alone or was left unreached.
  - *pass b:* All statements and docstrings read (whole module, 203 lines); moves, reading, comparison, closed_region from statements; the rest N.

## 22 November, the third pass on an exact edge, twenty modules read later: reader whole-c-edge3-04

*As "Postponement.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge3-04.md.txt).*

- **an exact statement of both outcomes**: N: no statement gives going on and ending, or keeping and losing, of one process. All 17 declarations were opened. The iffs equate a frame with its postponement: `Frame.postponed_trace_iff` (l.110): for `F : Frame S A C`, `X : S → Prop`, `inhabited : ∃ s, X s` and `as : List A`, `(∃ Y, Trace F.postponed.P X as Y) ↔ ∃ s t, X s ∧ Trace F.P s as t`; `postponed_tests_iff` (l.119), the same with a claim realized after the course; `postponed_trace_one` (l.128), `postponed_tests_one` (l.135); `sameTests_postponed_iff` (l.148); `sameTests_iff_postponed_alike` (l.163); `alike_postponed_iff_determined` (l.179): `(∀ s, Alike F F.postponed s (Eq s)) ↔ ∀ s, DeterminedAt F s`.
- **the side that keeps**: S: but not as a side of an edge. `Frame.postponed_trace_inhabited` (l.89): along any `Trace F.postponed.P X as Y`, `(∃ s, X s) → ∃ t, Y t`: having a member is kept by every course of the postponed frame. `Frame.postponed_members` (l.51): `Bisimulation F.postponed F.postponed (fun X X' => ∀ s, X s ↔ X' s)`, a relation closed under steps both ways. `Frame.postponed_determinedAt` (l.68): `DeterminedAt F.postponed X` for every X. No kernel, fixed point or standing state.
- **the side that ends**: N: no bound, rank, variant, deadline or falling quantity in any statement. Opened to rule it out: every declaration from l.46 to l.196.
- **moves in that statement**: S: but not in a both-outcomes statement. `postponed_trace_iff` (l.110), `postponed_tests_iff` (l.119), `postponed_trace_members` (l.75), `postponed_trace_of` (l.98) quantify over every course of moves `as : List A` of an arbitrary frame whose step `F.P.step s a t` is a relation, and over some member and some outcome (`∃ s t`). `sameTests_iff_postponed_alike` (l.163) is over all courses through `SameTests`.
- **a reading in that statement**: S: but not in a both-outcomes statement. `sameTests_iff_postponed_alike` (l.163): for frames F, G, `SameTests F G s s' ↔ Alike F.postponed G.postponed (Eq s) (Eq s')`: what linear tests (a course of moves, then a claim realized) can tell apart is exactly likeness with every branching postponed. `sameTests_postponed` (l.143): `SameTests F F.postponed s (Eq s)`. Built: `Choosing.postponed_alike` (l.191) and `Choosing.early_not_alike_postponed` (l.196).
- **the carrier**: A `Frame S A C` (`F.P.step s a t`, `F.realized s c`) and its `Frame.postponed : Frame (S → Prop) A C` (l.46), with `Trace`, `Alike`, `Bisimulation`, `DeterminedAt`, `SameTests`. Built: `Choosing.late`, `Choosing.early : Frame Pos Move Empty` of Histories.
- **what is handed in**: None of the level's fall, the giving, the share's rise, who is favoured or the turn occurs. The frame is arbitrary; `inhabited` is the one premise of `postponed_trace_iff`; what tests register is characterised (concluded equal to likeness of the postponements), not handed in.
- **links to other modules**: (1) `sameTests_iff_postponed_alike` (l.163): Histories' `SameTests` is equivalent to Labelled's `Alike` on the postponed frames; proved through `alike_iff_sameTests` (Histories l.302). (2) `alike_postponed_iff_determined` (l.179): an equivalence with Labelled's `DeterminedAt`. (3) `Frame.postponed_members` (l.51): an instance of Labelled's `Bisimulation`. (4) `Frame.postponed_determinedAt` (l.68): `DeterminedAt` of every family of the postponed frame. (5) `Choosing.postponed_alike` (l.191), `Choosing.early_not_alike_postponed` (l.196): built cases on Histories' `Choosing.late` and `Choosing.early`.
- **standing**: None seen. The account says 'No premise is added; every declaration has an empty axiom report' (l.13) and 'no quotient and no extensionality is used' (l.31).
- **note**: If `postponed_trace_iff` were counted as both outcomes (the postponed frame can or cannot take the course `as`), it would have moves, and `postponed_tests_iff` what is realized after them, but there is still no bound, falling quantity, region or ending in the module. It is a transfer between a frame and its postponement, not an edge of one process.
