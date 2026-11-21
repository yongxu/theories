# ReflexivePrediction

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReflexivePrediction.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-prediction-read-by-what-it-predicts`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-prediction-read-by-what-it-predicts`, `publication-under-negation-alternates`

## 21 November, how a registering comes to be: reader revision-and-forming

*As "ReflexivePrediction.lean". A reader's return, unchecked; what the note mended is in the note: [note](../../read-registering-2026-11-21/NOTE.md), [report](../../read-registering-2026-11-21/read-revision-and-forming.md.txt).*

- **what registers what**: A published prediction p read by a fixed response r : V → V. Right r p := r p = p (l65).
- **what changes it**: Repeated publication along Law.orbit r p (rests_iff_right l90); r itself is fixed and handed in.
- **laws where something comes to be registered**: None of the asked kind. none_right_of_moves (l68): premise ∀v, r v ≠ v, conclusion ¬Right r p. bottom_rests (l154): premises within (∀v ≤ n, r v ≤ n) and keeps (r monotone on 0..n); conclusion Right r (orbit r 0 n) and it is the least right prediction. ThresholdResponse (l175-200), built: two fixed points, the start decides which is reached.
- **cost and keeping**: Not applicable.
- **a registering lost**: None found; right_rests (l95): a right prediction stays.
- **tied to what it rests on**: None found.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-15, as "ReflexivePrediction.lean: predictor_iff, rests_iff_right, bottom_rests, Negating.alternates" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-15.md.txt)); pass b: reader whole-b-58, as "ReflexivePrediction.lean: Right, no_predictor_right, predictor_iff, bottom_rests, right_rests, rests_iff_right, ThresholdResponse.reached_by_start, Negating.alternates" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-58.md.txt)); the third pass, where the two differed: reader whole-c-settle-22, as "ReflexivePrediction.lean: settled fields moves" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-22.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `predictor_iff` (l. 80) says, given choice over admitted responses, that a predictor right on every response exists iff each admitted response has a fixed point. `bottom_rests` (l. 154) reaches the least right prediction by n from zero for every response preserving the finite chain 0,…,n and its order.
  - *pass b:* A published prediction p read by a response r is right exactly where r p = p (Right); generally, where a response moves every value no prediction is right (none_right_of_moves), no predictor is right on every admitted response once one admitted response moves every value (no_predictor_right), a predictor right on every admitted response exists exactly where each admitted response has a right value, given choice (predictor_iff), and on a chain 0..n with a response keeping the chain and its order, repeated publication from 0 is right by step n and is the least right prediction (bottom_rests). Built cases: a threshold response with two right predictions reached by start (ThresholdResponse), Boolean negation with none (Negating), and a reflection fixing 1 (Reflecting).
- **moves**
  - *settled by the third pass:* S (a chosen predictor over an admitted set, no choice among steps): `predictor_iff` (l. 80): given `choice : Viability.ChoiceOver {r : V → V // admitted r} V`, `(∃ predict, ∀ r, Right r.1 (predict r)) ↔ ∀ r, admitted r → ∃ p, Right r p`; `no_predictor_right` (l. 73): with `admitted r` and `∀ v, r v ≠ v`, no `predict : (V → V) → V` is right on every admitted response. The module has no `Process S A`; every course in it is `Law.orbit r p`, one determined course, the start a parameter (`ThresholdResponse.reached_by_start`, l. 193). [which pass was right: both in part; opened: Right (l. 65), none_right_of_moves (l. 68), no_predictor_right (l. 73), predictor_iff (l. 80), rests_iff_right (l. 90), right_rests (l. 95), rises (l. 118), bottom_rests (l. 154), reached_by_start (l. 193), alternates (l. 210); the whole module was read]
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* S: `no_predictor_right` (l. 73) and `predictor_iff` (l. 80): over a predicate `admitted` on responses, the chosen thing is a predictor (a function from admitted responses to values), and the laws say when some predictor is right on every admitted response: never if one admitted response moves every value; exactly when each admitted response has a fixed value, given `Viability.ChoiceOver`. No process with a choice among steps.
- **a reading**
  - *pass a:* S: `Right` (l. 65) equates the actual response to the published prediction with the prediction itself. `no_predictor_right` (l. 73) excludes any globally correct predictor when an admitted response moves every value.
  - *pass b:* S: `Right` (l. 65): the outcome is the response r to the published prediction p, so what is published decides the outcome; `no_predictor_right` (l. 73): this holds even of a predictor that reads the response itself. `rests_iff_right` (l. 90): publishing the last outcome is `Law.orbit r p`, and a step's prediction is right exactly where the next step publishes it again.
- **a share**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no count or fraction of one kind among several.
- **a level that runs down**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no stock or reserve that runs down; values are predictions on a chain 0..n.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: nothing gives to a level.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no cost is stated.
- **multiplying**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no units or kinds that multiply.
- **a point of no return**
  - *pass a:* S: `reached_rests` (l. 100) concludes that if a first response is q and q is right, all later publications are q. Irreversibility here is entry into a fixed point.
  - *pass b:* S: `right_rests` (l. 95): a right prediction p is published at every later step of the orbit from p; `reached_rests` (l. 100): if r p = q and q is right, the orbit is q from step 1 on; `stays_from` (l. 131): once a step publishes again, every later step does. These are concluded from Right; they are absorption at a fixed value, not a loss of a level or of something that gives.
- **both outcomes**
  - *pass a:* S: `rests_iff_right` (l. 90) equates repeating the current publication at the next step with its correctness on the same orbit.
  - *pass b:* S: `predictor_iff` (l. 80): exactly-when for a predictor right on every admitted response (general, given choice); `rests_iff_right` (l. 90): exactly-when for a step publishing again. B: `ThresholdResponse.reached_by_start` (l. 193): from 0 the orbit stays 0, from 1 it is 2 from step 1 on, two right predictions reached by start; `Negating.alternates` (l. 210): no step publishes again. None is of going on and ending.
- **a comparison between two**
  - *pass a:* S: `below_right` (l. 125) bounds the entire orbit from zero by any fixed point f ≤ n if the response preserves order up to n.
  - *pass b:* S: `below_right` (l. 125): under a response keeping the order on the chain (premise `keeps`), the orbit from 0 stays at or below every right prediction f \<= n at every step; `rises` (l. 118): it rises step by step. B: `ThresholdResponse.reached_by_start` (l. 193) compares two starts, 0 and 1.
- **a rank (an ending within a bound)**
  - *pass a:* S: `again_or_risen` (l. 138) says the chain-preserving monotone response from zero either already repeated or rose to at least k by k. `bottom_rests` (l. 154) bounds time to a fixed point by n.
  - *pass b:* S: `bottom_rests` (l. 154): on values 0..n with a response keeping the chain (`within`) and its order (`keeps`), the orbit from 0 is right by step n and at or below every right prediction on the chain; via `again_or_risen` (l. 138): before step k either some step published again or the prediction has risen at least k.
- **a closed region**
  - *pass a:* S: `right_rests` (l. 95) keeps each fixed point forever. `on_chain` (l. 112) keeps the orbit from zero within the chain under the stated closure premise.
  - *pass b:* S: `on_chain` (l. 112): under `within` (r keeps every v \<= n at most n), the orbit from 0 stays at most n; `Right` (l. 65) is a fixed point and `right_rests` (l. 95) says the orbit from it stays there.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `Negating.alternates` (l. 210) changes the Boolean publication at every step for every start and index.
  - *pass b:* B: `Negating.alternates` (l. 210): under Boolean negation, repeated publication changes at every step for ever and never publishes again. No general statement of a going-on continuing while what is present changes, or of a widening.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, reading, no_return, both_outcomes, comparison, rank, closed_region. Built cases support forms_change. The remaining findings are N. No question was unreached.
  - *pass b:* All fourteen from statements (forms_change from a built case) or found absent having read every statement; the whole module (233 lines) was read, proofs included.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge-20

*As "ReflexivePrediction.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge-20.md.txt).*

- **an exact statement of both outcomes**: N: no statement has going on for ever on one side and ending within a bound on the other. What there is, S: `rests_iff_right` (l. 90): for every `r : V → V`, `p : V`, `n : Nat` (`V : Type u` from the section variable l. 61), `Law.orbit r p (n + 1) = Law.orbit r p n ↔ Right r (Law.orbit r p n)`, proved by `Iff.rfl`: an exactly-when of one step publishing again, true by unfolding `Right` and `Law.orbit`. `predictor_iff` (l. 80): given `choice : Viability.ChoiceOver {r : V → V // admitted r} V`, `(∃ predict, ∀ r, Right r.1 (predict r)) ↔ ∀ r, admitted r → ∃ p, Right r p`: an exactly-when of existence, with no course. `again_or_risen` (l. 138) is a dichotomy inside the rank argument, not two outcomes. B: `ThresholdResponse.reached_by_start` (l. 193): `∀ k, Law.orbit threshold 0 k = 0 ∧ Law.orbit threshold 1 (k + 1) = 2` (two standing states by start); `Negating.alternates` (l. 210): no step publishes again.
- **the side that keeps**: A fixed point kept for ever, S: `right_rests` (l. 95): `Right r p → ∀ n, Law.orbit r p n = p`; `reached_rests` (l. 100): `r p = q → Right r q → ∀ n, Law.orbit r p (n + 1) = q`; `stays_from` (l. 131): for `r : Nat → Nat`, `Law.orbit r 0 (j + 1) = Law.orbit r 0 j → ∀ m, Law.orbit r 0 (j + m) = Law.orbit r 0 j`. A closed region as a premise: `on_chain` (l. 112): with `within : ∀ v, v ≤ n → r v ≤ n` (section variables `n : Nat`, `r : Nat → Nat`, l. 109), `∀ k, Law.orbit r 0 k ≤ n`.
- **the side that ends**: S, but on the same course as the fixed point, not across an edge from it: `bottom_rests` (l. 154): with `within : ∀ v, v ≤ n → r v ≤ n` and `keeps : ∀ v w, v ≤ w → w ≤ n → r v ≤ r w` (`n : Nat`, `r : Nat → Nat` from the section), `Right r (Law.orbit r 0 n) ∧ ∀ f, f ≤ n → Right r f → Law.orbit r 0 n ≤ f`. Nothing falls: the orbit rises (`rises` l. 118), and `again_or_risen` (l. 138) gives, for every `k`, `(∃ j, j < k ∧ Law.orbit r 0 (j + 1) = Law.orbit r 0 j) ∨ k ≤ Law.orbit r 0 k`. What ends within n steps is the changing of what is published; it ends at a fixed point.
- **moves in that statement**: N: the process is one course, `Law.orbit r p` of a function `r : V → V`, with no choice among steps; the start `p` is a parameter (`reached_by_start` l. 193 is the built case where the start decides which fixed point is reached). `no_predictor_right` (l. 73) and `predictor_iff` (l. 80) quantify over a function `predict` from admitted responses to values and over a predicate `admitted`, which is a chosen function with no step or course.
- **a reading in that statement**: N: no observation, class of things read alike or rule from what is registered appears. `Right r p` (l. 65) is `r p = p`, a condition on the value itself; the response `r` taking the published prediction as its argument is the only reading, and it is the carrier's function. `no_predictor_right` (l. 73): with `admitted r` and `∀ v, r v ≠ v`, `¬ ∃ predict : (V → V) → V, ∀ r', admitted r' → Right r' (predict r')`, the predictor taking the response itself as argument.
- **the carrier**: A function `r : V → V` (the response) and its orbit `Law.orbit r p : Nat → V` (`Law.orbit` of `Recurrence`); in `section Chain`, `r : Nat → Nat` with a bound `n : Nat`.
- **what is handed in**: Level's fall and giving: none; the rise of what is published: concluded (`rises` l. 118) from the premises `within` and `keeps`, both handed in; who is favoured: none; reading: the response `r`, handed in as a function of the prediction alone; turn: none, the fixed point reached is decided by the start (a parameter; built in `reached_by_start`). Concluded: rest by step `n` and leastness among right predictions on the chain (`bottom_rests` l. 154).
- **links to other modules**: (1) `rests_iff_right` (l. 90), `right_rests` (l. 95), `reached_rests` (l. 100), `on_chain` (l. 112), `rises` (l. 118), `below_right` (l. 125), `stays_from` (l. 131), `again_or_risen` (l. 138), `bottom_rests` (l. 154): all state repeated publication as `Law.orbit r p` of `Recurrence`, a case of that orbit. (2) `predictor_iff` (l. 80): takes `Viability.ChoiceOver {r : V → V // admitted r} V` (defined in Keeping.lean l. 156) as a premise. No other statement names a declaration of another module: `ListTests.not_ne_self` (in the proof of `Negating.none_right` l. 206) and `Naturals.sub_antitone` (`Reflecting.reverses` l. 223) occur in proofs only; `Diagonal.gap_unsaid` and `Learning.diagonal_misses` are named only in the account's readings.
- **standing**: No axiom seen. One choice principle stands as a named premise, not an axiom: `predictor_iff` (l. 80) takes `choice : Viability.ChoiceOver {r : V → V // admitted r} V`. The opening account says "Every declaration has an empty axiom report. No ethical predicate, ranking or axiom occurs" (l. 51-52). `again_or_risen` decides by `Nat.decEq`, not by a classical principle.
- **note**: Here the fixed point and the rank are on one course and one side: under `within` and `keeps` the orbit from 0 always comes to rest within n steps (`bottom_rests`), so nothing separates going on from ending. The two outcomes are built and are two standing states decided by the start (`reached_by_start`), with `Negating.alternates` a course that never rests; there are no moves, and no reading beyond the response function.
