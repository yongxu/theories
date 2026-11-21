# HorizonWebs

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HorizonWebs.lean`
- *table of 20 November:* HorizonWebs with Substitution, letters `NYPPPPPP`, standing core, told in chapter 2 §3.1 (Renewal and consumption belong to runs): Substitution at r-substitution-preserves-consumption (`Web.consumingIn_kept_iff`, `persists_consuming`); the horizon with feedback at r-becoming-finite-horizon, which names no HorizonWebs declaration
- *result records that name this place's file as a source* (computed; not a link): `becoming-finite-horizon`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-07, as "HorizonWebs.lean: Feedback.descending, Feedback.after_horizon, Feedback.prefix_does_not_decide, HorizonWebs.prefix_does_not_decide" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-07.md.txt)); pass b: reader whole-b-26, as "HorizonWebs.lean: Feedback.law, Feedback.descending, Feedback.supported, Feedback.prefix_does_not_decide, HorizonWebs.prefix_does_not_decide" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-26.md.txt)); the third pass, where the two differed: reader whole-c-settle-10, as "HorizonWebs.lean: settled fields giving" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-10.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* B: `Feedback.prefix_does_not_decide` (l. 102) gives, for each h, equal starts and draws agreeing before h in a support-gated law, with focal renewal for stopping overdraw at h and consumption for continuing it. `HorizonWebs.prefix_does_not_decide` (l. 128) gives both outcomes on the static webs and equality of shared levels through h.
  - *pass b:* B: in the support-gated law `Feedback.law h d` (a RelationalRenewal.Law: start h + 1, renewal 1, sustaining need 1, focal need 0), the schedule that stops overdrawing at h renews and the one that never stops consumes. They have the same start and the same draws before h (`Feedback.prefix_does_not_decide`, l. 102). On the static webs, both stand at the same level of the shared condition up to h (`HorizonWebs.prefix_does_not_decide`, l. 128). All built.
- **moves**
  - *pass a:* B: `Feedback.stopping` (l. 42) and `Feedback.continuing` (l. 45) are supplied draw schedules, and `Feedback.supported` (l. 87) keeps the level at least one throughout the stopping schedule.
  - *pass b:* B: `stopping` and `continuing` (l. 42, l. 45) are two draw schedules, two courses from one start. No `Process` with a choice is stated.
- **a reading**
  - *pass a:* B: `HorizonWebs.prefix_does_not_decide` (l. 128) gives equality of the two web-level readings at every time through the chosen horizon alongside different whole-run classifications.
  - *pass b:* B: `HorizonWebs.prefix_does_not_decide` (l. 128): the levels are equal up to h, yet one web renews and the other consumes, so what is registered up to h (the level) does not decide. No reading object is defined.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* B: `Feedback.law` (l. 39) sets initial stock h+1, renewal and sustaining need one, focal need and contribution zero. `Feedback.step_two` (l. 47) gives a one-unit drop when stock is m+2 and draw two, and `Feedback.step_one` (l. 56) maintains stock one at draw one. The docstring at l. 37 specifies that renewal stops below support.
  - *pass b:* B: `Feedback.descending` (l. 64): under draws of 2 before h, level k + k = h + 1, falling by one a step. `at_horizon` (l. 79) and `after_horizon` (l. 83): at h and afterwards the level is 1 under `stopping`. `supported` (l. 87): the level stays at least 1. The docstring (l. 37-38) and `RelationalRenewal.Law.level` (deeper/RelationalRenewal.lean, l. 246) add renewal only while the level meets the sustaining need, so what comes back depends on what is left.
- **a giving that is itself a going-on**
  - *settled by the third pass:* D: `Feedback.law` (l. 39) is `⟨h + 1, 1, 1, 0, d, fun _ => 0⟩`, numbers handed in (start, renewal one, sustaining need one, focal need zero, draw d, no contribution); its docstring says 'Renewal stops below support'. No statement of the module says that what renews is lost: `Feedback.supported` (l. 87) states `1 ≤ (law h (stopping h)).level t`, `Feedback.prefix_does_not_decide` (l. 102) and `HorizonWebs.prefix_does_not_decide` (l. 128) state `RenewingIn … .focal` for one schedule and `ConsumingIn … .focal` for the other. The gate on renewal is in the Law's level of another module (seen here only inside the proofs of `step_two`, `step_one` as `needG ≤ level`). [which pass was right: a; opened: Feedback.law l.39; stopping l.42; continuing l.45; step_two l.47; step_one l.56; descending l.64; at_horizon l.79; after_horizon l.83; supported l.87; Feedback.prefix_does_not_decide l.102; HorizonWebs.prefix_does_not_decide l.128]
  - *pass a:* D: The docstring of `Feedback.law` (l. 37) describes a sustaining need of one and renewal stopping below support. Its one-unit rate is supplied. The module's propositions track the shared level and focal outcomes, without a producer-population law.
  - *pass b:* N: renewal is the field `renew = 1` of the law handed in, gated by the sustaining need; it is not a unit that can be lost in this module's statements.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* B: `Feedback.prefix_does_not_decide` (l. 102) concludes `ConsumingIn` for continuing overdraw. The conclusion concerns that schedule and gives no quantified threshold from which every possible schedule fails.
  - *pass b:* B: `Feedback.prefix_does_not_decide` (l. 102) concludes `ConsumingIn` for `continuing`, through the first conjunct of `overdraw_consuming`. The threshold below which renewal stops is a premise of the law (`needG`). The sustaining formation's loss for ever is not stated in this module.
- **both outcomes**
  - *pass a:* B: `HorizonWebs.prefix_does_not_decide` (l. 128) states both outcomes in one conjunction for the two specified schedules, with the same observed levels through h. The model starts with h+1 for each h.
  - *pass b:* B: `Feedback.prefix_does_not_decide` (l. 102) and `HorizonWebs.prefix_does_not_decide` (l. 128): one start, two schedules that agree before h, one renewing and one consuming.
- **a comparison between two**
  - *pass a:* B: `Feedback.prefix_does_not_decide` (l. 102) equates the starts and pre-horizon draws, and `HorizonWebs.prefix_does_not_decide` (l. 128) equates the levels through h for the stopping and continuing schedules.
  - *pass b:* B: `HorizonWebs.prefix_does_not_decide` (l. 128) carries renewing and consuming from the law's unfolding to its static web, by `Web.static_renewingIn` and `static_consumingIn`.
- **a rank (an ending within a bound)**
  - *pass a:* B: `Feedback.descending` (l. 64) proves level(k) + k = h+1 through k ≤ h when draw is two before h, reaching one at h.
  - *pass b:* B: `Feedback.descending` (l. 64): the level falls by one each step before h, to 1 at h (`at_horizon`, l. 79). Under `continuing` it goes on to consume.
- **a closed region**
  - *pass a:* B: `Feedback.step_one` (l. 56) keeps level one on a draw of one, and `Feedback.after_horizon` (l. 83) gives that fixed level at h+j for every j under the stopping schedule.
  - *pass b:* B: `after_horizon` (l. 83): from h on, the level stays 1 under `stopping`, a standing level. `supported` (l. 87).
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all statements and their docstrings. Built cases cover states, moves, reading, level, no_return, both_outcomes, comparison, rank, closed_region. Only the account or docstrings cover giving. I found no matching claim for share, cost, multiplying, forms_change. I reached all fourteen questions.
  - *pass b:* All 14 answered from statements; all statements read, lines 1-142, with `RelationalRenewal.Law`, `Law.level` and `overdraw_consuming` looked up in deeper/RelationalRenewal.lean.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge-11

*As "HorizonWebs.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge-11.md.txt).*

- **an exact statement of both outcomes**: N as an exact edge. What there is, B: `Feedback.prefix_does_not_decide` (l.102): for every `h : Nat`, `(law h (stopping h)).start = (law h continuing).start ∧ (∀ t, t < h → stopping h t = continuing t) ∧ RenewingIn (law h (stopping h)).unfolding .focal ∧ ConsumingIn (law h continuing).unfolding .focal`; and `HorizonWebs.prefix_does_not_decide` (l.128), the same on `Web.static …` with the levels equal for all `t ≤ h`. Both outcomes in one conjunction, for two named draw schedules; no condition on the schedule is stated as exactly when. The section variables `{S : Type u} {A : Type v}` (l.31) are used by no statement.
- **the side that keeps**: `after_horizon` (l.83): `∀ j, (law h (stopping h)).level (h + j) = 1`, a standing level, from `step_one` (l.56): for any `d`, `(law h d).level t = 1` and `d t = 1` give `(law h d).level (t + 1) = 1`. `supported` (l.87): `1 ≤ (law h (stopping h)).level t` for every t. Stated as a value of the level along one run, not as a region of states closed under a step relation; the both-outcomes statement concludes `RenewingIn`.
- **the side that ends**: `descending` (l.64): for any `d` with `∀ t, t < h → d t = 2`: `∀ k, k ≤ h → (law h d).level k + k = h + 1`; the level falls by one a step up to h, under both schedules alike. The ending itself is `ConsumingIn (law h continuing).unfolding .focal`, which unfolds to an `∃ T`; no bound on it is stated in this module (the proof uses `RelationalRenewal.Law.overdraw_consuming`).
- **moves in that statement**: B, the choice made once at the start: the draw schedule `d : Nat → Nat` is a field of the law (`law h d`, l.39), a function of the step number alone; the statement names two schedules, `stopping h` (l.42) and `continuing` (l.45). It does not quantify over schedules, there is no `Process`, and the draw does not depend on the level.
- **a reading in that statement**: N as asked: no reading, lumping or `obs` is in the statement, and no condition separating the outcomes is stated on anything. What the statement has instead is the negative: the two webs' `level t ()` are equal for all `t ≤ h` (l.128; the schedules equal for `t < h`, l.102) while one renews and the other consumes.
- **the carrier**: A `RelationalRenewal.Law` (fields start, renew, needG, needF, draw, contrib; `Feedback.law h d := ⟨h + 1, 1, 1, 0, d, fun _ => 0⟩`), read as `Law.unfolding : Unfolding Part Unit` (l.102) and as `Web.static … : Web Part Unit` (l.128).
- **what is handed in**: The level's fall is concluded (`descending`) from the draw of two a step handed in; the giving is the field `renew = 1`, gated by `needG ≤ level` in the definition of `Law.level` (handed in); share and who is favoured are absent; reading absent; the turn is handed in, as the schedule `stopping h` that drops to one at h.
- **links to other modules**: (1) `HorizonWebs.prefix_does_not_decide` (l.128): names `Web.static`, `Web.level`, `Web.RenewingIn`, `Web.ConsumingIn` (Becoming.Dependence) of `(Feedback.law …).unfolding`; the Feedback statement carried to the static web. (2) `Feedback.prefix_does_not_decide` (l.102): names `RelationalRenewal.RenewingIn`, `ConsumingIn`, `Law.unfolding`, `.focal`; a built instance in the support-gated law of `lean/deeper/RelationalRenewal.lean`. (3) `step_two` (l.47), `step_one` (l.56), `descending` (l.64), `at_horizon` (l.79), `after_horizon` (l.83), `supported` (l.87): each states values of `RelationalRenewal.Law.level` for `law h d`.
- **standing**: The opening account says "No ethical predicate, ranking or axiom occurs." None seen in the statements.
- **note**: Both outcomes come from one start with something like a choice, but the choice is a whole schedule fixed beforehand, and the statement is that a prefix does not decide, not an edge. `step_one` and `step_two` (ll.56, 47) are the step law for any schedule `d` at a given level (draw one at level one keeps it; draw two at level m + 2 lowers it by one), but no theorem here states renewing exactly when a condition on the draw holds.
