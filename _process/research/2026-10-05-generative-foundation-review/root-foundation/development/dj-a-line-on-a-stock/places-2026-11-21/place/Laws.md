# Laws

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Laws.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-law-through-a-projection-along-one-run`, `a-law-through-changing-coupling-along-one-run`, `a-law-through-coupling-along-one-run`, `assured-route-criterion`, `causal-models-as-processes`, `configurations-alike-by-relation`, `counterfactual-is-the-course`, `determinacy-up-to-likeness`, `experiment-needs-return`, `fixed-places-and-sole-lines`, `generalization-through-lumping`, `hexagram-arrangements-and-laws`, `hexagram-world-laws`, `histories-fix-law-up-to-dead-ends`, `identification-where-runs-part`, `joint-difference-making`, `place-relations-in-context`, `process-and-frame-as-readings`, `projection-carrying-a-law`, `returning-where-the-course-branches`, `shared-laws-on-the-grammar`, `the-split-that-makes-sense`, `weights-count-situations`, `where-a-move-is-formed`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-wrong-projection-admitted-at-every-step`, `falls-that-end-do-not-recur`, `joint-difference-making`, `recurrence-without-premise`, `returning-where-the-course-branches`, `waxing-and-waning-returns`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-09, as "Laws.lean: Trace.determined_end, Assurance.trace_ofPartial_iff, GoAlikeUnder" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-09.md.txt)); pass b: reader whole-b-33, as "Laws.lean: Determined, Trace.determined_end, Assurance.ofMap, Assurance.ofPartial, Assurance.trace_ofPartial_iff, GoAlikeUnder, GoAlike, determined_iff_fixed, goAlikeUnder_iff_alike" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-33.md.txt)); the third pass, where the two differed: reader whole-c-settle-12, as "Laws.lean: settled fields no_return, both_outcomes, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-12.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Trace.determined_end` (l. 52) gives equal endpoints to traces of one plan from one start under a determined process. `Assurance.trace_ofPartial_iff` (l. 81) identifies the traces of every partial law exactly with successful evaluations of its plan.
  - *pass b:* The module defines law-level notions shared by later modules: a determined process (Determined), laws of change and partial laws read as determined processes, with traces of a partial law exactly the courses its run completes (trace_ofPartial_iff), and going alike under a description (GoAlikeUnder, with GoAlike at equality). It bridges these to the grammar (determined_iff_fixed, goAlikeUnder_iff_alike). All general; no built model.
- **moves**
  - *pass a:* S: `Determined` (l. 48) asks that each move have at most one successor at a state, and `Trace.determined_end` (l. 52) extends uniqueness to any finite plan.
  - *pass b:* S: `Determined` (l. 48): a move has at most one successor from each configuration. `Trace.determined_end` (l. 52): under a determined process two traces of one plan from one configuration end alike. `Assurance.trace_ofPartial_iff` (l. 81). No law about what a choice keeps.
- **a reading**
  - *pass a:* S: `GoAlike` (l. 114) requires equal projected outcomes whenever the same move is taken at equally projected starts. `goAlikeUnder_iff_alike` (l. 127) gives the corresponding per-move criterion for any relation on descriptions.
  - *pass b:* S: `GoAlikeUnder` (l. 109) defines configurations whose descriptions π E relates going, by one move, to configurations whose descriptions E relates; `GoAlike` (l. 114) is the case at equality. These are definitions; the only law is `goAlikeUnder_iff_alike` (l. 127), equating it with the grammar's «同行» at each move.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found in what was read.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found in what was read.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found in what was read.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found in what was read.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found in what was read.
- **a point of no return**
  - *settled by the third pass:* N. `Assurance.runPartial` (l. 76) is a def: `(f s a).bind fun t => runPartial f t rest`, so a move with `f s a = none` makes the run of that plan `none`. That is how one plan's evaluation is defined, not a statement that from some configuration no course keeps something or that a thing lost is not regained. No theorem of the module states an irreversibility. [which pass was right: b; opened: The whole module: `Determined` l. 48; `Trace.determined_end` l. 52; `ofMap` l. 64; `ofMap_determined` l. 66; `ofPartial` l. 70; `ofPartial_determined` l. 72; `runPartial` l. 76; `trace_ofPartial_iff` l. 81; `GoAlikeUnder` l. 109; `GoAlike` l. 114; `determined_iff_fixed` l. 120; `goAlikeUnder_iff_alike` l. 127.]
  - *pass a:* S: `Assurance.runPartial` (l. 76) propagates a failed move through the rest of that plan by Option.bind. This is failure of that execution.
  - *pass b:* N: not found in what was read.
- **both outcomes**
  - *settled by the third pass:* N. `Assurance.trace_ofPartial_iff` (l. 81): `Trace (ofPartial f) s plan t ↔ runPartial f s plan = some t`, for every partial law f; an equivalence of the relation of traces with the evaluator, not an exactly-when of going on and ending or of keeping and losing. `determined_iff_fixed` (l. 120) and `goAlikeUnder_iff_alike` (l. 127) are equivalences of a notion with the grammar's (`«定后»`, `«同行»`). [which pass was right: b; opened: The whole module (as in the item above); the three iffs at l. 81, 120, 127 read at their statements.]
  - *pass a:* S: `Assurance.trace_ofPartial_iff` (l. 81) characterizes completion of any finite plan with end t by the evaluator returning some t.
  - *pass b:* N: not found in what was read.
- **a comparison between two**
  - *pass a:* S: `GoAlikeUnder` (l. 109) is the premise that a relation on two projected starts is carried to the two projected ends for every shared move both can take.
  - *pass b:* S: `GoAlikeUnder` (l. 109) is a relation on descriptions kept by same-move steps. As a definition it is the kind of relation carried by the step; no theorem here carries it between two processes. `Trace.determined_end` (l. 52).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found in what was read.
- **a closed region**
  - *settled by the third pass:* N for a law; the schema is a def. `GoAlikeUnder` (l. 109): `∀ s s' a u u', E (π s) (π s') → P.step s a u → P.step s' a u' → E (π u) (π u')`, a relation on descriptions kept by each move from related pairs. It is a definition; `goAlikeUnder_iff_alike` (l. 127) equates it with `«同行»` at each move, with no hypothesis. No theorem of the module says a region or a relation is closed under steps; the account (l. 17) calls it the kernel schema and says `Invariant` is in `Becoming.Frame`. [which pass was right: both in part; opened: The whole module; `GoAlikeUnder` l. 109, `GoAlike` l. 114, `goAlikeUnder_iff_alike` l. 127 and the opening account l. 3-34.]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* D: the opening account (l. 17) calls GoAlikeUnder 'the kernel schema'. No theorem of a region closed under steps is stated in the module.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found in what was read.
- **how it was read**
  - *pass a:* S: Read the opening account, every declaration statement and its docstring where present. S for states, moves, reading, no_return, both_outcomes, comparison. N for share, level, giving, cost, multiplying, rank, closed_region, forms_change. No U fields.
  - *pass b:* All statements of the whole module (132 lines) were read. Moves, reading and comparison came from statements (mostly definitions); closed_region came from the account; the rest are N.
