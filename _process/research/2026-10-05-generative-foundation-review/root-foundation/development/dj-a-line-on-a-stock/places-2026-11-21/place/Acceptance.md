# Acceptance

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Acceptance.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-01, as "Acceptance.lean: acceptance_factorization, every_optimum_has_access_iff, maintenance_weight_exact" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-01.md.txt)); pass b: reader whole-b-01, as "Acceptance.lean: acceptance_factorization, every_optimum_has_access_iff, maintenance_weight_exact, unavoidable_score_loss, approximate_score_bound, stale_value_shield_suboptimal" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-01.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* With positive lift, a pair is best exactly when it accepts and its base move is best (`acceptance_factorization`, l. 65). In the Boolean maintenance model every optimum maintains access exactly when the separate weight exceeds diversion (`maintenance_weight_exact`, l. 163).
  - *pass b:* The module's general law concerns choices best among an allowed set under an integer score. With a positive lift, a choice is best under the score with acceptance exactly when it accepts and its move is best under the base score, so every best choice keeps access exactly when every best base move does. Its other results are general bounds (the loss from restricting moves; best by an estimate within err gives within 2*err of every allowed move) and Bool-built cases: diverting beats maintaining, a fixed weight for keeping access works exactly when it exceeds the diversion value, and a stale value prefers a branch the restriction forbids.
- **moves**
  - *pass a:* S: `every_optimum_has_access_iff` (l. 89) transfers universal access of best allowed moves in both directions for positive lift.
  - *pass b:* S: `Best` (l.49) is a choice among `allowed : A → Prop` by a score. `acceptance_factorization` (l.65): for any allowed set, base score q and lift > 0, a pair (move, accept bit) is Best under `AcceptScore` iff the bit is true and the move is Best under q. `every_optimum_has_access_iff` (l.89): every best choice keeps `access` iff every best base move does. `no_base_optimal_access` (l.97): where no best base move keeps access, no best move does. There is no `Process S A`; it is a one-shot choice.
- **a reading**
  - *pass a:* S: `approximate_score_bound` (l. 275) gives an actual score gap at most twice err against every allowed move when the chosen move is best by an estimate within err on all allowed moves.
  - *pass b:* S (only an estimate, no observation class): `approximate_score_bound` (l.275): where an `estimate` is within `err` of `actual` on allowed moves, a choice Best by the estimate is within 2*err of every allowed move; `approximate_score_bound_tight` (l.291) shows the bound attained. B: `stale_value_shield_suboptimal` (l.241): a value computed without the restriction (`UnrestrictedValue`) makes branch true best, though its allowed continuations score 1 and branch false scores 2; `recomputed_value_restores_branch` (l.258). No class of things read alike was found.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the resource that keeps a change possible occurs only as a Bool divert bit (`MaintenanceValue`, l.106; `Maintains`, l.111). No amount runs down.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* B: `maintenance_separation` (l. 114) gives the unique best accepting and diverting choice when diversion and lift are positive. Maintenance forgoes the diversion score.
  - *pass b:* S: `unavoidable_score_loss` (l.183): the loss q u - q v of a restricted best move v against an unrestricted best u is nonnegative and least among the allowed moves. `maintenance_weight_exact` (l.163): maintaining forgoes the diversion value, and every best choice maintains iff diversion \< weight. `fixed_access_weight_boundary` (l.144) and `every_fixed_access_weight_has_counterexample` (l.151): every fixed weight is defeated by some larger diversion value.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `accepting_optimum_can_destroy_access` (l.136) shows a best choice that diverts (¬ Maintains true). It is a one-shot choice with no later steps and nothing about regaining.
- **both outcomes**
  - *pass a:* B: `maintenance_weight_exact` (l. 163) characterizes maintenance at every optimum by strict inequality, including failure at a tie.
  - *pass b:* S (keeping or losing access, Bool model with general integers): `maintenance_weight_exact` (l.163): every best choice keeps access iff diversion \< weight, the tie counted among the failures. `maintenance_separation` (l.114): with diversion > 0 and lift > 0, a choice is best iff it is (divert, accept).
- **a comparison between two**
  - *pass a:* S: `unavoidable_score_loss` (l. 183) compares unrestricted and restricted best scores. Their difference is nonnegative and least among losses of allowed moves.
  - *pass b:* S: `every_optimum_has_access_iff` (l.89) carries the access property between best choices under the score with acceptance and best base moves. `acceptance_factorization` (l.65) is the carrying law. `unrestricted_value_optimal` (l.228) and `restricted_value_bounds` (l.216) compare two value functions on the two-step model (B).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* Read the opening account, all docstrings and all declaration statements. Statements support states and moves, reading, comparison. Built statements supply cost, both_outcomes. The remaining fields are N. None were unreached.
  - *pass b:* All 14 answered from statements where not N. All statements and docstrings were read, the whole module (318 lines).

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-01

*As "Acceptance.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-01.md.txt).*

- **an exact statement of both outcomes**: S: `maintenance_weight_exact` (l.163). For all integers `weight diversion`, with no other premise (the module has no section variables; the namespace only opens `IntegerOrder Integers`): `(∀ a : Bool, Best (fun _ => True) (fun b => MaintenanceValue diversion b + retained weight b) a → Maintains a) ↔ diversion < weight`. Every best choice maintains exactly when the weight strictly exceeds the diversion value; the tie falls on the failing side. It is of a one-shot choice between two options. There is no `Process`, no step and no course, so nothing goes on or ends: access is kept or not at one choice. Also general, without a threshold: `every_optimum_has_access_iff` (l.89), for any `A`, `allowed access : A → Prop`, `q : A → Int`, `0 < lift`: every `Best` accepting pair has `access` iff every `Best` base move has.
- **the side that keeps**: N: the statement only asserts that every best choice satisfies `Maintains a` (l.111, `divert = false`). There is no step, so no region closed under a step, no kernel, no fixed point, no certificate.
- **the side that ends**: N: nothing is bounded and nothing falls. The failing side is only the negation: not every best choice maintains. Opened to rule it out: `fixed_access_weight_boundary` (l.144: `weight < diversion →` a strict inequality of two scores), `every_fixed_access_weight_has_counterexample` (l.151), `accepting_optimum_can_destroy_access` (l.136: `(true, true)` is `Best` and `¬ Maintains true`), `unavoidable_score_loss` (l.183: a score gap that is nonnegative and least), `restricted_value_bounds` (l.216: a score at most `RestrictedValue branch`), `approximate_score_bound` (l.275: a score gap at most `2 * err`). These bound scores, not a time of ending.
- **moves in that statement**: S: the statement quantifies over every best choice, `∀ a : Bool, Best (fun _ => True) … a → …`. The choice is `a : Bool` (divert `true`, maintain `false`), made once; the allowed set is everything. No plan or policy.
- **a reading in that statement**: N: the condition is on the two integers `diversion` and `weight`. An estimate against an actual score appears only in `approximate_score_bound` (l.275), which is not an exactly-when.
- **the carrier**: A one-shot choice `a : Bool` scored by `fun b => MaintenanceValue diversion b + retained weight b : Bool → Int`, best by `Best (allowed : A → Prop) (q : A → Int)` (l.49). No `Process S A`, no `Web`.
- **what is handed in**: Handed in: `weight` and `diversion` as parameters; the score and `Maintains` are definitions. Concluded: the equivalence. No level, giving, share, reading or turn appears; which choice is favoured is what the scores decide.
- **links to other modules**: None in statements: the module imports only `Becoming.IntegerOrder`, and no theorem's statement names a declaration of another module (only `Int`, `Bool` and this module's `Best`, `AcceptScore`, `MaintenanceValue`, `retained`, `Maintains`). Within the module, `maintenance_separation` (l.114) is proved as a case of `acceptance_factorization` (l.65).
- **standing**: None seen. The opening account says (l.39): "No premise; every declaration has an empty axiom report." Not checked by running.
- **note**: This module counts against the thought: an exact edge (a strict inequality, the tie among the failures) with neither a closed region nor a rank, because the statement has no step. Its general laws with moves (`acceptance_factorization` l.65, `every_optimum_has_access_iff` l.89) are also of a one-shot choice and have no reading.
