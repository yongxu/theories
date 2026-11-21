# Narrowing

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Narrowing.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-reading-informed-and-revalued`, `becoming-spine-instances`, `learning-a-rule-by-narrowing`, `positive-ground-open-futures`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-reading-informed-and-revalued`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-11, as "Narrowing.lean: mem_learn, answer_iff, actual_retained, learning_transport" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-11.md.txt)); pass b: reader whole-b-41, as "Narrowing.lean: observe, revise_is_after, narrowed, mem_learn, narrowed_iff_fits, answer_iff, answer_maximal, unique_maximal_safe, learning_transport, counterevidence_of_dropped, narrow_class_settles_wrongly" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-41.md.txt)); the third pass, where the two differed: reader whole-c-settle-15, as "Narrowing.lean: settled fields no_return, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-15.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `mem_learn` (l. 225) characterizes the result of any finite list of Boolean observations as the initial candidates fitting every observation. `answer_iff` (l. 330) requires a nonempty list and agreement of all its members for a definite answer, which is greatest among safe answers when a candidate remains (`answer_maximal`, l. 358).
  - *pass b:* For any question type Q and list of candidate Boolean rules, narrowing by observations is `After` on the pure observation (`revise_is_after`) and keeps exactly the candidates fitting every observation (`mem_learn`, `narrowed_iff_fits`). The answer asserts exactly what every remaining candidate gives, is safe, and is the greatest safe answer; faithful acquisition answers correctly, and re-encoding transports learning. These are general; the four rules on Bool (`repertoire`) are a built case with decided examples.
- **moves**
  - *pass a:* S: `after_observe_iff` (l. 160) characterizes the belief after choosing question q and receiving outcome o in the pure observation process: the state remains in the old belief and reads o at q.
  - *pass b:* S: `observe` (l. 158) is a Process S A whose step keeps the configuration; its action is the question. `after_observe_iff` (l. 160) and `narrow_once_iff` (l. 197): after observing b at q, the belief holds exactly the believed rules giving b at q. `actual_retained` (l. 242): the actual rule, a candidate faithful to the observations, is kept whatever observations are made.
- **a reading**
  - *pass a:* S: `answer_iff` (l. 330) makes a definite answer equivalent to nonemptiness and unanimous candidate value. `actual_retained` (l. 242) requires the actual rule to be included and fit the evidence.
  - *pass b:* S: `mem_learn` (l. 225): learning keeps exactly the candidates in hs that fit e. `answer_iff` (l. 330): the answer asserts b at q exactly where some candidate remains and all give b. `answer_maximal` (l. 358) and `unique_maximal_safe` (l. 362): with hs nonempty it is the greatest safe answer, and any safe greatest answer equals it at every question. `acquired_answers_correct` (l. 401). B: `narrow_class_settles_wrongly` (l. 566): a class lacking the actual rule settles false at true, while the actual id gives false.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no count or fraction.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no stock.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: nothing gives.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no cost.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no units leaving units.
- **a point of no return**
  - *settled by the third pass:* S: `mem_learn` (l. 225): for every rule h, list hs and observations e, `h ∈ learn hs e ↔ h ∈ hs ∧ Fits h e`. Its forward half gives `h ∈ learn hs e → h ∈ hs`: a rule not among the candidates is in no learned list, whatever is observed. Concluded; it is one half of an exactly-when and not stated as a separate law. `counterevidence_of_dropped` (l. 267) says only that a dropped rule contradicts some observation. [which pass was right: a; opened: revise l. 62; learn l. 66; mem_revise l. 183; mem_learn_iff l. 218; mem_learn l. 225; narrowed_iff_fits l. 237; counterevidence_of_dropped l. 267; revise_revise l. 272.]
  - *pass a:* S: `mem_learn` (l. 225) implies a candidate absent at the start of any further learning stays absent, for any subsequent evidence.
  - *pass b:* N: no statement of irreversibility. `counterevidence_of_dropped` (l. 267) says a dropped candidate contradicts some observation; it is not a law of no return.
- **both outcomes**
  - *pass a:* S: `mem_revise` (l. 183) characterizes keeping a candidate at one observation by initial membership and matching its value. `counterevidence_of_eliminated` (l. 261) finds a contradicted observation for every eliminated initial candidate.
  - *pass b:* S: `mem_learn` (l. 225), general: a candidate is kept exactly where it is in hs and fits every observation, and `counterevidence_of_eliminated` (l. 261) gives the other side, keeping against losing a candidate. `answer_iff` (l. 330) is an exactly-when of asserting.
- **a comparison between two**
  - *pass a:* S: `learning_transport` (l. 421) commutes learning with recoding of evidence and transport of rules when decoding is a left inverse of encoding.
  - *pass b:* S: `answer_transport` (l. 411); `learning_transport` (l. 421): where decode ∘ encode' = id, learning transported rules from re-encoded observations is the transport of what is learned. `narrowing_transport` (l. 442). `answer_maximal` (l. 358) dominates every safe answer. B: `wrong_reencoding_breaks_transfer` (l. 452).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no ending within a bound.
- **a closed region**
  - *pass a:* S: `revise_revise` (l. 272) makes the revised list a fixed point for repetition of the same observation.
  - *pass b:* S (a fixed point of revision): `revise_revise` (l. 272): revising twice by one observation is revising once. `repeated_observation_idle` (l. 277).
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* B (weaker): `one_sample_settles_one` (l. 532): `narrowed (· ∈ repertoire) oneSample` settles `true` at `true` and settles `false` at no value; `contrasting_settles_both` (l. 541): with `twoSamples` both are settled. Two built statements at two evidence lists, in which more is settled with one more observation while candidates are only removed; no statement of a going-on that continues while what is present changes. [which pass was right: both in part; opened: oneSample l. 499; twoSamples l. 502; one_sample_settles_one l. 532; contrasting_settles_both l. 541; repeated_case_leaves_other l. 556.]
  - *pass a:* B: `one_sample_settles_one` (l. 532) and `contrasting_settles_both` (l. 541) witness widening of the questions settled by adding the other observation of the identity rule.
  - *pass b:* N: no statement of continuing while what is present changes.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and the docstrings. General statements — states, moves, reading, no_return, both_outcomes, comparison, closed_region. Built cases — forms_change. Not found — share, level, giving, cost, multiplying, rank. No commentary-only answers. All questions were reached.
  - *pass b:* Every statement of the module was read, all 574 lines. 2, 3, 10, 11 and 13 are answered from statements, with built cases; 4 to 9, 12 and 14 were not found.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-07

*As "Narrowing.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-07.md.txt).*

- **an exact statement of both outcomes**: S: `mem_learn` (l. 225), only `variable {Q : Type}` (l. 55), no include, no premise: `∀ (h : Rule Q) (hs : List (Rule Q)) (e : List (Observation Q)), h ∈ learn hs e ↔ h ∈ hs ∧ Fits h e`. Its other half is `counterevidence_of_eliminated` (l. 261): `h ∈ hs`, `h ∉ learn hs e` give `∃ o, o ∈ e ∧ h o.1 ≠ o.2`. The same on the belief: `narrowed_iff_fits` (l. 237). One step: `mem_revise` (l. 183): `h ∈ revise hs o ↔ h ∈ hs ∧ h o.1 = o.2`. Keeping against dropping a candidate rule along a list of observations.
- **the side that keeps**: The statement only asserts that the candidate is in the learned list after the given observations. `actual_retained` (l. 242): `actual ∈ hs` and `Fits actual e` give `actual ∈ learn hs e`. A fixed point of one revision: `revise_revise` (l. 272): `revise (revise hs o) o = revise hs o`, and `repeated_observation_idle` (l. 277). No region closed under every step is named; whether a rule is kept depends on the whole list `e` it must fit.
- **the side that ends**: N. The dropped side says only that the rule is not in `learn hs e` and contradicts some listed observation (`counterevidence_of_not_fits` l. 247, `counterevidence_of_eliminated` l. 261, `counterevidence_of_dropped` l. 267). No statement speaks of the length of `learn hs e` or `revise hs o`, or of any quantity falling, or of a bound within which a rule is dropped. `acquire` (l. 385) has a `fuel : Nat` that caps how many observations are taken: a parameter of a definition, not a law of ending. All 574 lines read.
- **moves in that statement**: N in `mem_learn`: the list `e` of observations (each a question with its value) is a parameter; no quantifier over moves stands inside the condition. The question is a move only through `revise_is_after` (l. 189) and `mem_learn_iff` (l. 218), where `After observe sense (· ∈ hs) q (encode b)` takes the question `q` as the label of `observe : Process S A` (l. 158), given.
- **a reading in that statement**: S: the condition is `Fits h e` (l. 58: `∀ o, o ∈ e → h o.1 = o.2`), agreement with the observed values and not with any actual rule; no actual rule appears in `mem_learn`. In `narrow_once_iff` (l. 197) the observation is `sense` (l. 179). `answer_iff` (l. 330): `answer hs q = some b ↔ hs ≠ [] ∧ ∀ h, h ∈ hs → h q = b`.
- **the carrier**: A `List (Rule Q)` under `learn`/`revise` by a `List (Observation Q)`; the same as a belief `Rule Q → Prop` under `narrowed`, which is `After observe sense` iterated, on `observe : Process (Rule Q) Q`.
- **what is handed in**: Premises (parameters): the candidates `hs` and the reading, as the list `e` of observed values. Concluded: exactly which candidates are kept. That the observations are faithful to an actual rule is a premise where it is used (`actual_retained`, `known_rule_makes_answer_correct` l. 377), or built by `acquire` (`acquired_evidence_faithful` l. 391). No level, giving, share, favouring or turn.
- **links to other modules**: `revise_is_after` (l. 189): `h ∈ revise hs (q, b) ↔ After observe sense (· ∈ hs) q (encode b) h`, revision as a case of the core's `After` on the pure observation. `after_observe_iff` (l. 160): `After observe (fun s q _ => obs s q) B q o t ↔ B t ∧ obs t q = o`. `narrow_once_iff` (l. 197): `After observe sense (· ∈ hs) q (encode b) h ↔ h ∈ hs ∧ h q = b`. `Settles` (l. 286) is defined with `InhabitedBelief`, and `settles_learn_iff` (l. 340), `answer_some` (l. 294) state it.
- **standing**: None seen; opening account: "Every declaration has an empty axiom report" and says the periphery's classical `eliminated_rule_has_counterevidence` is constructive here. Function extensionality is a named hypothesis `ext` in `unique_maximal_safe_of_ext` (l. 370) and `repertoire_complete_of_ext` (l. 478). Several built facts are proved `by decide`.
- **note**: The reading is in the exact statement and a choice is not; nothing ends within a bound and the kept side is not a closed region. By `mem_learn` a rule not in `hs` is in no `learn hs e`, so a dropped rule does not come back, but no declaration states that as a law. B: `inconsistent_evidence_yields_no_answer` (l. 528), `contradiction_settles_nothing` (l. 561).
