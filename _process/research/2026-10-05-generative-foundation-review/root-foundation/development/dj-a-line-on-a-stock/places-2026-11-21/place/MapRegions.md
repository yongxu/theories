# MapRegions

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MapRegions.lean`
- *result records that name this place's file as a source* (computed; not a link): `generation-and-degeneration-at-two-grains`
- *dynamics in the atlas that name one of those records* (computed; not a link): `generation-and-degeneration-at-two-grains`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-11, as "MapRegions.lean: «三域之周», generates_iff_changes, keepsAfter_iff_settles" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-11.md.txt)); pass b: reader whole-b-40, as "MapRegions.lean: «后守», «三域之周», «三域之定当且仅当排中», «单行则生成后守不并», «生则或粗生或传», Map.Once, Map.generates_iff_changes, Map.keepsAfter_iff_settles, Map.«后守之定则LPO», Map.«生成后守之定则LPO»" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-40.md.txt)); the third pass, where the two differed: reader whole-c-settle-15, as "MapRegions.lean: settled fields moves, no_return, comparison" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-15.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `«三域之周»` (l. 128) covers every point of arbitrary relations by generation, eventual keeping or degeneration given excluded middle, and `«三域之定当且仅当排中»` (l. 152) proves the converse for universal coverage. On Boolean-labelled steps `Map.generates_iff_changes` (l. 296) and `Map.keepsAfter_iff_settles` (l. 309) identify generation with arbitrarily late changes and eventual keeping with an eventually constant label.
  - *pass b:* For every carrier and relations R, L, E it proves the split of a beginning: a beginning of a part is a beginning of the pattern or the end of a carrying renewal, as far as can be refuted. It defines keeping from some point on (后守) and proves that, with excluded middle, every point is 生成, 后守 or 退化, and that placing every point so is exactly excluded middle. It also proves that telling 后守 on a line of a sequence is deciding whether the sequence stops changing (LPO). The laws are general; the built cases are Map.Once (renews, then stays) and Settles.sequence.
- **moves**
  - *settled by the third pass:* S (weaker; no `Process S A`, policy or allowed set): `«后守»` (l. 81) is a definition: some family S holding x, closed under `«续» R L`, with a point z reached from x in S after which no `«传» R L E u v` lies within S. `«单行则生成后守不并»` (l. 111): where R is single-valued (`func`), not both `«生成» R L E x` and `«后守» R L E x`. The 'some branch' is an existential over families of a relation. [which pass was right: both in part; opened: 后守 l. 81; 守则后守 l. 86; 全守则后守 l. 91; 后守则延 l. 100; 后守退化不并 l. 105; 单行则生成后守不并 l. 111; 三域之周 l. 128.]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: `«后守»` (l. 81) asks for some branch family S, holding x and closed under continuation, with a point reached from x after which no carrying renewal lies in S. `«单行则生成后守不并»` (l. 111): where each occurrence conditions at most one other (func), 生成 and 后守 exclude each other. The branches are of a relation, not moves of a Process S A, and there is no law about what a choice keeps.
- **a reading**
  - *pass a:* S: `Map.generates_iff_changes` (l. 296) uses equality of a Boolean reading as the fine class and characterizes generation by changes of that reading.
  - *pass b:* S: the classes L (pattern) and E (parts). `Map.generates_iff_changes` (l. 296): on the step line under «一», with the class of a sequence b (n ~ m iff b n = b m), 生成 at 0 iff for every y some n ≥ y has b n ≠ b (n + 1). `Map.keepsAfter_iff_settles` (l. 309): 后守 at 0 iff b is constant from some step on.
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
  - *settled by the third pass:* B, concluded: `Map.Once.stays_third` (l. 216): `«相续» once «一» x y → x = .third → y = .third`; `Map.Once.third_not_renews` (l. 201): for every w, `¬ «传» once «一» «静» .third w`. In the built three-stage relation, from the third occurrence everything reached is the third and no carrying renewal goes out. Not at a low level or the loss of a giver; no general law. [which pass was right: a; opened: Stage l. 176; once l. 179; Once.renews l. 197; third_not_renews l. 201; third_next l. 209; stays_third l. 216; Once.not_generates l. 248; Once.keepsAfter l. 278; keepsAfter_iff_settles l. 309.]
  - *pass a:* B: `Map.Once.stays_third` (l. 216) concludes that any continuation from the third occurrence stays there. `Map.Once.third_not_renews` (l. 201) excludes every carrying renewal from it.
  - *pass b:* N: no loss or irreversibility. 后守 is settling from a point on, not a loss. `«后守退化不并»` (l. 105) excludes degeneration.
- **both outcomes**
  - *pass a:* S: `«三域之周»` (l. 128) includes both ways of going on and all-branch ending under excluded middle. `«单行则生成后守不并»` (l. 111) excludes overlap of generation and eventual keeping for single-valued R.
  - *pass b:* S: `«三域之周»` (l. 128): given excluded middle, every point of every relation is 生成, 后守 or 退化. `«三域之定当且仅当排中»` (l. 152): that this holds at every point of every model is equivalent to excluded middle. `«后守退化不并»` (l. 105): 后守 and 退化 exclude each other. These are general. B: `Map.Once` is in none of 生成 (l. 248), 守 (l. 258) and 退化 (l. 263), yet in 后守 (l. 278).
- **a comparison between two**
  - *settled by the third pass:* S (weaker): `«传则粗不生»` (l. 61): `«传» R L E x y → ¬ «生» R L y`; `«粗有前则生为传»` (l. 65): `«有前» R L y → «生» R E y → ∃ x, «传» R L E x y`. These relate two classes E and L at one relation R and one point, with no order between the classes assumed. Nothing is carried between two relations, two processes or two starts; no simulation, covering or kept order. [which pass was right: both in part; opened: l. 61, 65, 72, 86, 91, 100, 105.]
  - *pass a:* S: `«传则粗不生»` (l. 61) excludes a coarse beginning at the receiving end of a carrying renewal. `«粗有前则生为传»` (l. 65) recovers a carrying renewal from a fine beginning with a coarse predecessor; both compare readings of the same occurrence.
  - *pass b:* N: no law carries between two processes or starts. The module's implications are between region notions at one relation: `«守则后守»` (l. 86), `«全守则后守»` (l. 91), `«后守则延»` (l. 100), `«传则粗不生»` (l. 61).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `«后守之定则LPO»` (l. 376) and `«生成之定则WLPO»` (l. 399) are logical calibrations, not ending within a bound.
- **a closed region**
  - *pass a:* S: `Map.step_family` (l. 288) proves a family containing zero and providing each member a successor in the family under the single step contains every natural step.
  - *pass b:* S: `«后守»` (l. 81) contains a family S closed under continuation (∀ z, S z → ∃ w, S w ∧ 续 z w) with a quiet part from a reached point. `«后守则延»` (l. 100): it goes on along that branch. B: `Map.Once.family` (l. 223).
- **forms change while the going on continues, or more can go on after**
  - *pass a:* S: `Map.generates_iff_changes` (l. 296) gives generation on the continuing step line precisely for labels that change arbitrarily late. B: `Map.Settles.turning_turns` (l. 364) supplies a change at every step.
  - *pass b:* S: `Map.generates_iff_changes` (l. 296): 生成 at the first step of the line is the sequence changing at arbitrarily late steps. B: `Map.Once.keepsAfter` (l. 278): renews once and then stays. `Settles.turning` (l. 331) alternates at every step, and `Settles.sequence` (l. 336) turns until p holds and then stays.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and the docstrings. General statements — states, reading, both_outcomes, comparison, closed_region, forms_change. Built cases — no_return, forms_change. Not found — moves, share, level, giving, cost, multiplying, rank. No commentary-only answers. All questions were reached.
  - *pass b:* All statements and docstrings read to the end (l. 431). moves, reading, both_outcomes, closed_region and forms_change are answered from statements, with built cases; the rest are N.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-06

*As "MapRegions.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-06.md.txt).*

- **an exact statement of both outcomes**: S, as a dichotomy under excluded middle taken as a hypothesis. `«三域之周»` (l. 128): premises `em : ∀ P : Prop, P ∨ ¬ P`, any `R L E : «际» α`, `x : α` (`α` from the section variable, l. 55): `«生成» R L E x ∨ «后守» R L E x ∨ «退化» R L x`. `«后守退化不并»` (l. 105), no premise: `¬ («后守» R L E x ∧ «退化» R L x)`. No separate condition tells which side holds: the edge is `«尽» R L x` or not. `«三域之定当且仅当排中»` (l. 152): the placement at every point of every model is equivalent to excluded middle. Of the step line, with exact conditions: `Map.generates_iff_changes` (l. 296) and `Map.keepsAfter_iff_settles` (l. 309), for every `b : Nat → Bool`.
- **the side that keeps**: S. The going-on side is, by definition, a family closed under some continuation: `«后守»` (l. 81) is `∃ S, S x ∧ (∀ z, S z → ∃ w, S w ∧ «续» R L z w) ∧ ∃ z, «所及» R L x z ∧ S z ∧ ∀ u v, S u → S v → «所及» R L z u → ¬ «传» R L E u v`. `«后守则延»` (l. 100): `«后守» R L E x → «延» R L x`. B: `Map.Once.family` (l. 223), `Map.step_family` (l. 288).
- **the side that ends**: N. The ending side is `«退化» R L x`, which is `«尽» R L x` (GrammarMap l. 283, l. 229): an inductive predicate, `x` ends where everything continuing it does. No statement of this module bounds it by a number or states a quantity that falls; it enters only through `«延尽不并»`. An inductive predicate could be read as an ordinal rank; no declaration here states one. `«后守之定则LPO»` (l. 376), `«生成之定则WLPO»` (l. 399), `«生成后守之定则LPO»` (l. 420) are calibrations of deciding, not endings within a bound.
- **moves in that statement**: S, as branches of a relation and not as moves of a `Process S A`: the going-on regions say 'some family `S` closed under continuation' (`∃ S` in `«后守»` and `«生成»`), the ending region says every continuation (`∀ y, «续» R L x y → «尽» R L y`). `«单行则生成后守不并»` (l. 111) takes away the choice by the premise `func : R z w → R z w' → w = w'`.
- **a reading in that statement**: S. The classes `L` (pattern) and `E` (parts) are in the statement: continuation is `«续» R L`, a carrying renewal is `«传» R L E`. On the step line the class is that of a sequence, `fun n m => b n = b m`: `generates_iff_changes` (l. 296): `«生成» step «一» … 0 ↔ ∀ y, ∃ n, y ≤ n ∧ b n ≠ b (n + 1)`; `keepsAfter_iff_settles` (l. 309): `«后守» step «一» … 0 ↔ ∃ z, ∀ n, z ≤ n → b n = b (n + 1)`.
- **the carrier**: A relation of the grammar: `R : «际» α` with classes `L E : «际» α` on any type `α`. Built: `Map.once : «际» Stage` (l. 179); the step line `step` on `Nat` under `«一»`.
- **what is handed in**: Level's fall, giving, share's rise, who is favoured: none occurs. The reading (classes `L`, `E`; on the step line the sequence `b`) is handed in as a parameter; excluded middle is a hypothesis. The turn (a carrying renewal ahead, or none from a point on) is what the regions state, and which region holds is concluded only as a disjunction.
- **links to other modules**: `«三域之周»` (l. 128) names `«生成»`, `«退化»` (GrammarMap): the three regions cover, given `em`. `«三域之定当且仅当排中»` (l. 152): equivalence of that placement with excluded middle. `«守则后守»` (l. 86) and `«全守则后守»` (l. 91): `«守»` and `«全守»` (GrammarMap) are cases of `«后守»`. `«单行则生成后守不并»` (l. 111): with `func`, `¬ («生成» R L E x ∧ «后守» R L E x)`. `«传则粗不生»` (l. 61): `«传» R L E x y → ¬ «生» R L y` (Grammar).
- **standing**: No axiom admitted: the account says every declaration has an empty axiom report. Excluded middle occurs as a hypothesis (`em`, l. 128) and as one side of an equivalence (l. 152); LPO and WLPO occur written out as conclusions from a hypothesis that decides (ll. 376, 399, 420).
- **note**: Here a statement with both outcomes has a reading (`L`, `E`) and a branch quantifier in it, on a relation and not on a process with moves; its going-on side is a family closed under some continuation and its ending side is an inductive predicate with no bound stated. The exact split inside going on (`«生成»` against `«后守»` on the step line, ll. 296 and 309) has no ending on either side.
