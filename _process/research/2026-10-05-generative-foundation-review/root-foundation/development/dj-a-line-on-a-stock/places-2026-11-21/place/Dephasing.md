# Dephasing

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Dephasing.lean`
- *result records that name this place's file as a source* (computed; not a link): `control-coherence-loss`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-04, as "Dephasing.lean: operations_trace_iff, plus_kept_iff, no_restore_along, control_returns" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-04.md.txt)); pass b: reader whole-b-12, as "Dephasing.lean: operations, operations_trace_iff, no_diagonal_response_decoder, no_uniform_dephase_inverse, dephase_keeps_response_iff, settles, not_lossless, runs_meet, no_restore_along, returns, control_returns, diagonal_invariant" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-12.md.txt)); the third pass, where the two differed: reader whole-c-settle-05, as "Dephasing.lean: settled fields forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-05.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* B: `settles` (l. 306) puts every dephasing run at its first dephased configuration at every positive time. For recording from a blank register, `recording_dephases` (l. 422) gives that reduced control after one step and `control_returns` (l. 431) recovers the initial control after two.
  - *pass b:* One built model: an exact integer fragment of a two-branch control. Dephasing keeps the diagonal and the weight, keeps the plus response exactly where the cross terms sum to zero, and merges the prepared and coherent controls, so that no decoder of the diagonal and no restore map recovers them (no_diagonal_response_decoder, no_uniform_dephase_inverse, no_restore_along). As a law, every dephasing run rests from step 1 (settles) and is not lossless; the recording law returns every configuration after two steps (returns, control_returns), and one recording step is dephasing of the control (recording_dephases).
- **moves**
  - *pass a:* S: `operations_trace_iff` (l. 249) identifies endpoints for any list of endomorphism moves with their ordered fold. B: X and Z each keep the norm (`x_preserves_norm`, l. 134; `z_preserves_norm`, l. 137).
  - *pass b:* S: `operations` (l. 246): for any S, a Process S (S → S) in which each step applies the chosen operation. `operations_trace_iff` (l. 249): a course reaches exactly the left fold of the operations. `orders_negate` (l. 258), built: X then Z and Z then X end at negatives of each other.
- **a reading**
  - *pass a:* B: `retained_response_exact` (l. 206) decodes plusMass using the diagonal and cross-term sum for every matrix. `no_diagonal_response_decoder` (l. 189) rules out even a decoder correct on both coherent and degraded from the diagonal alone.
  - *pass b:* S (built): `no_diagonal_response_decoder` (l. 189): no function of the diagonal gives the plus response of both the coherent and the degraded control (their diagonals are equal, their responses differ). `retained_response_exact` (l. 206): the diagonal with the cross-term sum decides the plus response.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: weight (`mass`) and norm are invariants, not reserves that run down.
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
  - *pass a:* B: `no_restore_along` (l. 372) concludes that no map from a positive-time state recovers both distinct starts of the merged dephasing runs. This is loss of information.
  - *pass b:* S (built, concluded): `no_uniform_dephase_inverse` (l. 200) and `no_restore_along` (l. 372): no map restores the prepared and the coherent control from their dephased or later states. `not_lossless` (l. 363). The loss is of the cross terms, not of a giver. Contrast `returns` (l. 416): recording returns every configuration after two steps.
- **both outcomes**
  - *pass a:* B: `plus_kept_iff` (l. 340) equates keeping the starting plus response at any positive time with vanishing of the starting cross-term sum in every run of this law.
  - *pass b:* S (built): `dephase_keeps_response_iff` (l. 211): dephasing keeps the plus response exactly where m.zo + m.oz = 0. `plus_kept_iff` (l. 340) gives the same along every dephasing run. This is about keeping or losing a response, not about going on or ending.
- **a comparison between two**
  - *pass a:* B: `runs_meet` (l. 367) equates the states from prepared and coherent at each positive time. `recording_dephases` (l. 422) relates one step of joint recording from a blank register to reduced dephasing.
  - *pass b:* S (built): `runs_meet` (l. 367): the dephasing runs from the prepared and the coherent control are equal from step 1. `recording_reduces_to_dephase` (l. 226) and `recording_dephases` (l. 422): one step of the recording law, read on the control, is dephasing.
- **a rank (an ending within a bound)**
  - *pass a:* B: `settles` (l. 306) bounds time to rest by one dephasing step.
  - *pass b:* S (built): `settles` (l. 306): every run of the dephasing law is, from step 1 on, the dephased start; it rests within one step.
- **a closed region**
  - *pass a:* B: `diagonal_invariant` (l. 310) and `mass_invariant` (l. 315) give invariant fibers for the dephasing process.
  - *pass b:* S (built): `diagonal_invariant` (l. 310), `mass_invariant` (l. 315), `x_norm_invariant` (l. 282), `z_norm_invariant` (l. 286): fixed diagonal, weight and norm are Invariant regions of these laws.
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* B (weak): `returns` (l. 416): every `Joint` returns under `Law.process recordBranch` after two steps; `recording_dephases` (l. 422): along every run from `withBlank v` the control read at step 1 is `dephase` of the one read at step 0; `control_returns` (l. 431): the control read at step 2 is the one read at step 0. A return with period two in one built law; that the control read at step 1 differs from step 0 is not stated in one theorem, and nothing comes, goes or widens. [which pass was right: both in part; opened: returns l. 416; recording_dephases l. 422; control_returns l. 431; prepared_reading l. 438; coherent_reading l. 444; opening account]
  - *pass a:* B: `control_returns` (l. 431), `recording_dephases` (l. 422), and `prepared_reading` (l. 438) give a reduced control which changes on recording and returns on the second step from the stated blank preparation.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and its docstring. I used statements for moves, and built cases for states, reading, no_return, both_outcomes, comparison, rank, closed_region, forms_change. I reached all fourteen questions.
  - *pass b:* Answered from statements: states, moves, reading, no_return, both_outcomes, comparison, rank, closed_region; the N answers come after reading every statement. All statements read (453 lines).

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge-05

*As "Dephasing.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge-05.md.txt).*

- **an exact statement of both outcomes**: B: `plus_kept_iff` (l.340), no section variables (the module has no `variable` or `include` line): for every `r : Run (Law.process dephase)` and `n : Nat`, plusMass (r.state (n + 1)) = plusMass (r.state 0) ↔ (r.state 0).zo + (r.state 0).oz = 0. Its one-step form is `dephase_keeps_response_iff` (l.211): plusMass (dephase m) = plusMass m ↔ m.zo + m.oz = 0. It is of one built law (`dephase` on `Matrix`), and of keeping or losing an observable, not of going on or ending.
- **the side that keeps**: The statement only asserts that the plus response at each later date equals the start's; no declaration says the set where zo + oz = 0 is closed under the step. What is declared holds on both sides of the condition: `diagonal_invariant` (l.310) and `mass_invariant` (l.315) are `Invariant (Law.process dephase)` for a fixed diagonal and weight, `dephase_dephase` (l.297) makes every dephased matrix a fixed point, and `settles` (l.306) puts every run at `dephase (r.state 0)` from step 1.
- **the side that ends**: No rank falls. `settles` (l.306): for every run r and n, r.state (n + 1) = dephase (r.state 0), a rest within one step for every start, on both sides; `response_settles` (l.334) gives the response from step 1 as (mass, mass, 2 * mass) of the start. Where the cross terms do not sum to zero the response differs from the start's at every date n + 1 (the negation of l.340), so the loss is at the first step.
- **moves in that statement**: N: `Law.process dephase` is a determined law, one course; the only parameter is the start r.state 0. A process with moves exists in separate statements: `operations` (l.246, `Process S (S → S)`), `operations_trace_iff` (l.249: a course of operations ends at the fold of them in order), `orders_negate` (l.258, built: X then Z and Z then X end at negatives).
- **a reading in that statement**: N: the condition is on the configuration (the start's cross terms `zo + oz`); what is kept or lost is an observable (`plusMass`), but nothing in the statement is told apart or merged. Readings stand apart, built: `no_diagonal_response_decoder` (l.189: no function of the diagonal gives plusMass of both `coherent` and `degraded`), `no_diagonal_decoder_along` (l.404), `no_uniform_dephase_inverse` (l.200), `no_restore_along` (l.372), `retained_response_exact` (l.206).
- **the carrier**: `Run (Law.process dephase)` with `dephase : Matrix → Matrix` (`Matrix` a structure of four `Int`) and the observable `plusMass : Matrix → Int`.
- **what is handed in**: Nothing is handed in but the run and the date; the law and the observable are definitions of the module. No level, giving, share, favouring or turn; the equivalence is concluded.
- **links to other modules**: (1) `not_lossless` (l.363): ¬ Branching.Lossless (Law.process dephase), an instance. (2) `merges` (l.356) and `process_merges` (l.359): `Law.Merges dephase`, `Branching.Merges (Law.process dephase)`, instances. (3) `returns` (l.416): `Branching.Returns (Law.process recordBranch) j` for every j, an instance. (4) `diagonal_invariant` (l.310), `mass_invariant` (l.315), `x_norm_invariant` (l.282), `z_norm_invariant` (l.286): instances of `Invariant` on `Law.process`. (5) `operations_trace_iff` (l.249): `Trace (operations S)`, with `operations` defined by `Assurance.ofMap`. `Becoming.Readout` is named only in docstrings and proofs (l.189, l.200), not in a statement.
- **standing**: None seen. The account says the proofs are constructive on `Becoming.Integers` (l.16) and that no axiom occurs (l.44-45); the operations and their physical reading are said to be supplied.
- **note**: The one exactly-when is built, of a response kept or lost at the first step on a law with no moves, and the law itself goes on to a fixed point from every start, so there is no going-on against ending. The reading laws and the moves process (`operations`) are in other statements and are not joined to it.
