# The covering laws on the root (U4d, design)

1 November 2026, revised the same day after the independent review ([REVIEW-U4D](REVIEW-U4D.md); §9 says how each finding was taken). AI-written design for the next step that the record [one-root-to-its-edge](../../../../../../theories/becoming/results/records/one-root-to-its-edge.md) names first: "the covering laws' root form (lines traced back to a covering list, no splits)". U4c's design left these laws out as not cases of the census ([CENSUS-ON-THE-ROOT §3.5](CENSUS-ON-THE-ROOT.md)). Every law here, every case and every witness is checked in scratch Lean outside the package ([u4d-scratch](u4d-scratch/), §7). No package Lean is written before GrammarLaws' owner gives names and placement. Reading time: §0 in about six minutes, the whole in about thirty.

## 0. The proposal in brief

- **The covering laws today.** Three families sit beside the census, each with its own proof.
  - *Locality.* Where some list covers what holds at a step, ceasing recurring needs coming to be after it. The decided form is `Covers.coming_from_of_ceasing`, proved by accumulating ceasings over stretches. The undecided count is `Covers.ceasing_steps_within`, proved by counting steps that see a ceasing.
  - *Decidedness.* In a finite family, while nothing of it comes to be across a stretch, no more steps see a member cease than the family has members, and its mirror for coming to be (`ceasing_steps_within`, `coming_steps_within`), each proved by matching steps to members.
  - *Identity.* Under a continuation, from one covering list: `Web.not_not_arisingFrom_covered`, and the converse `Web.ceasingFrom_not_stopping_covered`, proved by lineages.
- **What is proposed: one count on the grammar, its stretch form, and the forms through it.**
  - **The count of ends on lines from a list.** Take occurrences listed once, each ending (`«亡»`), each within the closure of a member of a list. Suppose that, wherever two successors of an occurrence a member reaches each lead to a listed ending, they are one. Then there are no more such occurrences than members. A line under fixed successors ends at most once, so endings match members one to one. No decision is used, and reaching the list need only be not refuted, since the count is decided. **Its mirror**, at the converse: beginnings (`«生»`) on lines to a list number at most the list, nothing merging where it matters.
  - **The stretch form, on a stage map.** The units are occurrences at stages, a region `P` that nothing outside continues into (`«闭» («逆» («续» R E)) P`), each step one stage on. With a list covering the units at stage `N`, no occurrence continuing as two units, and no unit beginning at a stage in `(N, U)`, distinct units ending at stages in `[N, U)` number at most the list. No decision. **Its mirror**: in a region nothing continues out of, with a list covering the units at `U`, nothing merging and no unit ending at a stage in `[N, U)`, distinct units beginning at stages in `[N, U]` number at most the list.
  - **Run forms through them.** Undecided: with lists at arbitrarily late stages and endings recurring as far as can be refuted, beginnings never stop. Decided: with beginning or predecessor decided after the list's stage, endings recurring give beginnings recurring. The converse: with lists of at most `K` from some stage on, beginnings recurring leave endings never stopping, and with ending or successor decided, endings recur.
- **What they reach.**
  - **The root's census of a run is a case** (the review's finding). Read its units as occurrences `(t, x)`, under the step relation restricted to listed units. The stretch form then applies, and the census's test of beginnings decides a finite search. The proof uses neither the listing once nor the test of endings (§2.4).
  - **Locality.** Four proofs change, statements kept: `Covers.coming_from_of_ceasing` is the decided form from one list; `Covers.ceasing_steps_within` is the stretch form; `Covers.not_not_coming_from` is the undecided form; `Covers.ceasing_stops_unrefuted` follows from it.
  - **Decidedness.** Two proofs change, statements kept: `ceasing_steps_within` is the stretch form and `coming_steps_within` its mirror, the family's members a region along their steps.
  - **Identity.** Two proofs change, statements kept: `Web.not_not_arisingFrom_covered` is the undecided form, `Web.ceasingFrom_not_stopping_covered` the converse.
  - Every other law through these reaches the root with its proof unchanged (§3).
- **New at Identity: the exact forms.** The record [census-balance-under-continuation](../../../../../../theories/becoming/results/records/census-balance-under-continuation.md) leaves open "the exact existential forms of both directions … and the decision the exact form needs". Two cases close it:
  - with covering lists and whether a formation continues one before decided, ceasing recurring needs arising recurring;
  - with bounded covering lists and whether a formation is continued decided, the converse holds.

  Identity's census recurrence laws are cases of these two, checked against their own types. Re-proving them through the new laws generalizes below, not beside (board rule 9).
- **Each hypothesis needed.** A witness meets every other hypothesis where the conclusion of every run form fails (§4). The two decisions are reductions, not countermodels. In a model built on any proposition `Q`, every other hypothesis holds, the decision holds exactly where `Q ∨ ¬Q`, and the found conclusion exactly where `¬Q ∨ ¬¬Q`. So the found form, asked without a decision, would give weak excluded middle for every proposition. Which decision is least is open.
- **Standing.** The standings and figures of [08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#r-one-root-to-its-edge) do not change. The central declarations downstream of the changed proofs already reach the grammar, so what changes is how, not whether (§6). The measure is rerun on the landing build.
- **What it does not reach.** `CensusWebs.keep_pace`, whose stretch form on positions stays a later step. And the decided covering form is not a case of the census of a run, whose tests give no predecessor positively (§5).
- **Cost.** One core run, a near-full rebuild since GrammarLaws lies under nearly every core module. It is rehearsed on main after EL6 and OG have landed, so the landing reuses the rehearsal's steps. About 46 records are re-pointed after reading, or 62 if the census of a run drops its two unused hypotheses (§8, question 1).

## 1. What the root and the model already have

- **Lines on the grammar.**
  - Steps (`«迭»`): `n` steps lie within the closure, and the closure is reached by some number of steps (`«迭则同一或及»`, `«及即迭»`, `«所闭当且仅当同一或及»`).
  - Steps split as they compose (`«迭之分»`).
  - With the successor fixed at what `x` reaches, `n` steps lead to one occurrence (`«迭之定于»`).
  - What is reached in fewer than `n` steps having a successor as far as can be refuted gives `n` steps as far as can be refuted (`«或有后则或迭»`).
  - The closure read backward is the converse's (`«所闭之逆»`).
- **Closed regions.** `«闭» R P`: what `P` holds of, it holds of each `R`-successor. A closed region holding `x` holds `x`'s closure (`«闭含所闭»`).
- **Counting on the root.**
  - The prelude's `length_le_of_matched`, which carries U4c's census of a step: a list without repetition matched into another, no member matched twice, is no longer.
  - `not_not_all`: a double negation for each member of a list is one for all.
- **U4c's census laws.** The census of a step, one side and its mirror (`«定后则后并亡不过前并生»`, `«定前则前并生不过后并亡»`). The census of a run (`GrammarLaws.census_run`, `«定后前者在前则亡屡者生屡»`), proved by summing the census of a step over a stretch.

  No grammar law follows a line from a list across many steps to its end.
- **The occurrence readings.**
  - At Locality and Decidedness: `Steps.along`, `Steps.alikeAt`, `Steps.along_fixed`, and Population's bridges `comesToBe_iff_sheng_along` and `ceasesToBe_iff_wang_along`.
  - At Identity: `continuationStep`, `activityOnward`, `occurrence_eq`.

## 2. The laws

Working names are in `U4dCover` (34 theorems). The package's names come from GrammarLaws' owner (§8).

### 2.1 Lines from a list, on any relation

- `closure_iff_steps`: **the closure is some number of steps** (`«所闭当且仅当同一或及»` with `«及即迭»`), stated once as an equivalence.
- `steps_unique`: `n` steps from `a` lead to one occurrence, where two successors of an occurrence `a` reaches, each leading to `y` or to `z`, are one. This is the local form of `«迭之定于»`, asking the successor fixed only where the two lines could part. `«迭之定于»` becomes its corollary.
- `ends_before`: under the same hypothesis, an occurrence that ends lies on no longer line from the same start (`«迭之分»` at the shorter length).
- `one_end_rel`: **a line under fixed successors ends at most once.** Two occurrences that `m` reaches and that end are one.

### 2.2 The count, and its mirror

- `ends_le_rel` (any relation), `ends_le` (on `«续» R E` with `«亡»`): **endings on lines from a list number at most the list.**

  > `D` listed once; each member of `D` ending and within the closure of a member of `L`; any two successors of an occurrence a member of `L` reaches, each leading to a member of `D`, one. Then `D.length ≤ L.length`.

  The proof matches each ending to a member reaching it (`length_le_of_matched`). No member is matched twice, by `one_end_rel`.
- `ends_le_unrefuted`: the same with each ending only not refuted to be reached. The conclusion is a decided comparison of numbers (`Nat.decLe`), so the double negations lift through `not_not_all`.
- `begins_le`, `begins_le_unrefuted`: **the mirror**, at `«逆» («续» R E)`. Beginnings on lines to a list number at most the list, where any two predecessors of an occurrence that reaches a member, each reached from a listed beginning, are one.

### 2.3 Forms on a stage map

**The frame.** The units are occurrences at stages: a stage map `τ` with each step of `«续» R E` one stage on (`τ y = τ x + 1`), so that no occurrence continues itself, and a region `P`, the units. Discrete steps are a modelling choice, stated where the laws depend on it. The region's conditions are the grammar's closed regions:
- *closed back*, `«闭» («逆» («续» R E)) P`: nothing outside the region continues into it;
- *closed on*, `«闭» («续» R E) P`: nothing in it continues out of it (the converse forms only).

No occurrence continuing as two units is asked only of successors that are units. Through the region closed back, that gives the count's local hypothesis (`fixed_of_noSplit`).

| Form | Working name | Hypotheses besides the frame and the region closed back | Conclusion |
|---|---|---|---|
| stretch | `cover_within` | `L` covers the units at `N`; no occurrence continuing as two units; no unit beginning at a stage in `(N, U)` | distinct units ending at stages in `[N, U)` number at most `L` |
| undecided, one list | `cover_unrefuted` | as above; endings at arbitrarily late stages, each not refuted | a beginning after `N`, not refuted |
| undecided, run | `cover_never_stops` | lists at arbitrarily late stages | beginnings never stop |
| decided, one list | `cover_from` | `L` covers the units at `N`; no split; beginning or predecessor decided after `N`; endings at arbitrarily late stages | a unit begins after `N` |
| decided, run | `cover_run` | lists at arbitrarily late stages; decided after `T`; the rest as above | beginnings at arbitrarily late stages |

| Converse form (the region closed on instead) | Working name | Hypotheses | Conclusion |
|---|---|---|---|
| stretch mirror | `cover_within_converse` | `L` covers the units at `U`; no two units continuing as one occurrence; no unit ending at a stage in `[N, U)` | distinct units beginning at stages in `[N, U]` number at most `L` |
| converse | `cover_converse` | lists of at most `K` cover each stage from `T`; no merge; beginnings at arbitrarily late stages | endings never stop |
| converse, decided | `cover_converse_run` | as above, each unit from `T` ending or with a successor | endings at arbitrarily late stages |

The undecided forms are the stretch form with endings found at distinct stages (`found_unrefuted`). The stretch form traces each ending back stage by stage to `N` (`trace_unrefuted`): at each unit after `N` nothing begins, so a predecessor is not refuted, a unit since the region is closed back. At `N` the unit is on the list, and the count bounds the endings. The decided forms trace with the decision (`trace`): either a beginning is found, or the line reaches the list, and `|L| + 1` endings break the count. The converse forms trace forward (`onward_within`, `trace_on`) to a stage past every beginning found, where every line's end is on that stage's list, and the mirror bounds them.

The decisions are asked only where the proof uses them: after the list's stage for the decided form, from `T` for the converse.

### 2.4 The census of a run, through lines

`census_run_lines` concludes as `GrammarLaws.census_run` does, from `noSplit`, `predecessorsBefore`, the test of beginnings and endings recurring, asking neither that the units after each step be listed once nor a test of endings. The review found it and checked it in Lean; the scratch carries it on the revised frame.

- Units are occurrences `(t, x)` with `x ∈ u t` from `T` on; a step is one stage on and a step of `«续» R E` between listed units. The region is closed back, since each predecessor is listed before.
- The list `(u N').map (N', ·)` covers the units at `N' = N + T`. Endings recur at distinct stages, from the census's own `ending`.
- With `|u N'| + 1` endings found at stages in `[N', U)`, the stretch form says that some unit begins at a stage in `(N', U)` unless refuted. The search over the listed units at those stages is finite and the test of beginnings decides it, so a beginning is found.

`census_run_fixed` is the same under fixed successors. Both package laws are its cases with their statements unchanged (`U4dSame`).

## 3. The cases

The cases are in `U4dCases` (38 theorems). `U4dSame` (14 theorems) checks each against the package's own statement, `type_of% @_root_.Becoming.Original := @U4d.case`.

### 3.1 Locality

- **The reading.** A unit is an occurrence `(t, a)` where `p a t` holds; the stage is `t`; the continuation is `Steps.along` within `Steps.alikeAt p`. The supports, each a line or two:
  - `along_stage`, from `along`;
  - `along_back`, the region closed back, since the class is two-valued;
  - `along_noSplit`, from `Steps.along_fixed`;
  - `along_covers`, the list `L.map (N, ·)`;
  - `along_decided`, from `p`'s decision: at step 0 a beginning (`along_sheng_zero`); after it a predecessor where `p a t` holds, else coming to be;
  - `along_ending`, a ceasing read as an ending (`ceasesToBe_iff_wang_along`).
- **`Covers.coming_from_of_ceasing`** is `cover_from`. A beginning after `N` lies at a step `t + 1` with `N ≤ t`, which `comesToBe_iff_sheng_along` reads as coming to be across the step from `t`. This is why the root form concludes `N < τ y`: at the first step everything begins under every class.
- **`Covers.ceasing_steps_within`** is `cover_within`. Its ceasing steps are read as occurrences (`pick`, an existential over a list proved by induction, no choice), and distinct steps give distinct occurrences (`distinct_of_map`). Nothing coming to be across the stretch is no unit beginning in it.
- **`Covers.not_not_coming_from`** is `cover_unrefuted`, and **`Covers.ceasing_stops_unrefuted`** follows from it in three lines (the review's shorter route, finding 2).
- **Through them, unchanged:** `coming_of_ceasing_covered`, `Covers.ceasing_not_recurring`, `ListedWebs.ceasing_not_recurring`, `World.arising_of_ceasing`, `Web.StandingCensus.coming_of_ceasing`, `World.comes_to_rest_unrefuted_from`, `World.arising_unrefuted_covering`, and their consumers (`World.comes_to_rest_unrefuted`, `World.rests_unrefuted_covering`, `World.rests_unrefuted`).

### 3.2 Decidedness

- **The reading.** A unit is an occurrence `(t, a)` of a member `a ∈ as` where `p a t` holds, along `Steps.along` within `Steps.alikeAt p`. The region is closed both ways, since a member's occurrences stay with the member (`family_back`, `family_on`). Nothing splits (`Steps.along_fixed`) and nothing merges (`family_noMerge`). The family's list `as.map (S, ·)` covers every stage (`family_covers`).
- **`ceasing_steps_within`** is `cover_within`, as at Locality. **`coming_steps_within`** is `cover_within_converse`: the beginnings are the occurrences a step after each coming to be, distinct by `distinct_map_on`, and nothing ceasing across the stretch is no unit ending in it.
- The laws `comes_once` and `ceases_once_of` stay: the record [recurrence-without-decidedness](../../../../../../theories/becoming/results/records/recurrence-without-decidedness.md) states them in its law 2.

### 3.3 Identity

- **The reading.** A unit is an occurrence `(t, f)` with `f` active at `t`; the stage is `t`; the continuation is `continuationStep R` within `activityOnward M`. `activityOnward M` relates only from an active occurrence at or after `M`. That is how "no splits from `M` on" becomes the root's "no occurrence continuing as two units": every successor under it is active, and nothing before `M` has one. Activity is closed both ways under it (`cont_back`, `cont_on`). The other supports are `cont_stage`, `cont_noSplit`, `cont_noMerge`, `cont_covers` and `cont_ending`, and the bridges `cont_arises`, `cont_ceases` and `cont_begins` read `ArisesFrom` and `CeasesFrom` from `M` on as beginning and ending there.
- **`Web.not_not_arisingFrom_covered`** is `cover_unrefuted`; **`Web.ceasingFrom_not_stopping_covered`** is `cover_converse` with the one list at every step from `T`.
- **Through them, unchanged:** `Web.arisingFrom_not_stopping_covered`.

### 3.4 New at Identity

- **`arisingFrom_of_ceasingFrom_covered`.** Suppose covering lists at arbitrarily late steps, no splits from `T` on, and `Continues` decided. Then ceasing under the continuation recurring needs arising under it recurring. This is `cover_run`, the decision read at each active occurrence after `T` (`cont_decided_begin`).
- **`ceasingFrom_of_arisingFrom_covered`.** Suppose lists of at most `B` covering each step from `T`, no merges from `T` on, and `Continued` decided. Then arising recurring needs ceasing recurring. This is `cover_converse_run` (`cont_decided_end`).
- **The census recurrence laws as cases.** `Census.arisingFrom_of_ceasingFrom_from` and `Census.ceasingFrom_of_arisingFrom_from` carry their section's three decisions. Each is a case: the listing covers, and its bound bounds (`U4d.census_case`, `U4d.census_converse_case`). The exact forms ask strictly less: covering lists in place of a census, no decision of activity, one decision of the continuation in place of three.
- **The decision is needed at Identity too** (`Web.U4d.AtIdentity.exact_needs_decision`, the review's witness): on a web with two formations active at every step, every other hypothesis holds for any `Q`, `Continues` is decided exactly where `Q ∨ ¬Q`, and arising recurs exactly where `¬Q ∨ ¬¬Q`.
- **Re-proof.** The two census laws are re-proved through the new ones (§8, the review's answer to question 3). In Identity.lean the Counting section precedes the Covering section, so the two recurrence laws move below the covering forms, with their corollaries `arisingFrom_of_ceasingFrom` and `ceasingFrom_of_arisingFrom`. U4c's count of laws in Identity's Counting section that go through `balanceFrom_at` then falls from seven to three (`balanceFrom`, `balanceFrom_eq_at`, `balanceFrom_eq`).

## 4. Each hypothesis needed

The witnesses are in `U4dNeeded` (20 theorems), with one at Identity in `U4dCases`. Each meets every other hypothesis, stated as the laws state it. Units are pairs of natural numbers unless said otherwise. The run witnesses end with no unit beginning after the first stage, which refutes every run form at once: the found forms at `N = 0`, the undecided forms, and through them the stretch form. The converse witnesses end with endings stopping, and carry the decision.

| Law | Hypothesis | Witness | Where the conclusion fails |
|---|---|---|---|
| count | fixed successors | `count_needs_fixed`: `0` continues as `1` and `2`, both end | two endings, one member |
| run forms | no split | `run_needs_noSplit`: a line continuing as itself and as a unit that ends, at every stage | no unit begins after the first stage |
| run forms | closed back | `run_needs_back`: relatum `a`'s line runs to stage `a` and ends, only the end a unit | the same |
| run forms | covering lists | `run_needs_covering`: every line a unit along its length, infinitely many units at every stage, so no list covers any stage | the same |
| run forms | one stage on | `run_needs_stage`: each `(0, a)` continues as `(a + 1, a)`, which ends; each step still moves strictly later | the same |
| converse forms | no merge | `converse_needs_noMerge`: each stage's two units continue as one | nothing ends |
| converse forms | a bound | `converse_needs_bound`: relatum `a`'s line from stage `a`, never ending | the same |
| converse forms | closed on | `converse_needs_on`: as above, only the start a unit | the same |

The two decisions are reductions, not countermodels. Given the other hypotheses, the undecided forms prove the found conclusion's double negation, so no model refutes it. Each witness is a model built on an arbitrary proposition `Q`:

| Law | Decision | Witness | What it shows |
|---|---|---|---|
| decided run | beginning or predecessor | `run_needs_decision Q`: the line continues as itself where `Q`, as an ending unit where `¬Q` | the decision is exactly `Q ∨ ¬Q`; the conclusion is equivalent to `¬Q ∨ ¬¬Q` |
| decided converse | ending or successor | `converse_needs_decision Q`: `(t, 1)` continues where `Q`, `(t, 0)` where not | the decision is exactly `Q ∨ ¬Q`; endings recur exactly where `¬Q ∨ ¬¬Q` |
| exact form at Identity | `Continues` | `exact_needs_decision Q` (§3.4) | the same at Identity |

So each found form, asked as a law without its decision, would give weak excluded middle for every proposition. That shows a non-constructive hypothesis is needed, not that this one is least. At these models weak excluded middle suffices, and the proofs use the decision only after the list's stage; which decision is least is open.

## 5. Not cases, and siblings

- **The decided covering form is not a case of the census of a run.** The census's tests give no predecessor positively, and its lists give nothing positive between stages. Both are cases of the stretch form instead, the census through a finite search its test decides (§2.4), the decided form through the decision.
- **`CensusWebs.keep_pace`** stays at counting, for U4c's reason: a two-sided bound over a stretch on a fixed family that may list a member twice. Its stretch form on positions stays a later step.
- **`Covers.within`** stays: a list covering `N` covers every later step of a stretch across which nothing comes to be. It asks the decision of `p`, and is the decided trace (`trace`) read at Locality. It is a covering lemma, not a covering law, and nothing in this design goes through it.
- **The lineage laws** (`Lineage.unique`, `origin`, `split`, `through`, `onward`, `back`, `line`) are laws of lineages that 01 §7 names as cases of the grammar. They stay, statements and proofs unchanged; only the covering laws stop going through them.
- **The direct proofs' helpers go** under rule 9 ("the direct proof goes"), each with no consumer left after the change, checked in the package:
  - in Locality, `accumulates_or`, `ceases_once` and `ceasing_steps_unrefuted`;
  - in Identity, `ceasingFrom_found`, `arisingFrom_found`, `Lineage.ends` and `lineages_apart`.

  `stays_failing_within` stays, since `ceases_once_of` uses it. Each removed helper is also struck from the `references` list of the record that names it (laws-of-one-step for Locality's, census-balance-under-continuation for Identity's). A `references` entry lists a source's declarations, not a law's support, and no record law states any of them.

## 6. What changes, and what does not

**Lean.**
- **GrammarLaws.**
  - *Runs section*, after `«迭则同一或及»` and before `«迭之定于»`: the line lemmas (`closure_iff_steps`, `steps_unique`, `ends_before`, `one_end_rel`), the count and its mirror. They use only `«所闭当且仅当同一或及»`, `«及即迭»` and `«迭之分»`, all above. `«迭之定于»` becomes the corollary of `steps_unique`, its statement kept.
  - *Census section*, beside the census of a run: the stretch form and its mirror, the run forms, and the census of a run's line form, with `census_run` and `«定后前者在前则亡屡者生屡»` its corollaries (§8, question 1).
  - *Universe.* The scratch uses `ListTests.mem_cons_iff`, which is polymorphic, where the prelude's `mem_cons_cases` is stated at `Type`. Either the laws keep that, or `mem_cons_cases` generalizes to `Type u` as U4c generalized three lemmas.
- **Prelude.** `pick` and `distinct_of_map`, generalized to any pair of types, beside `distinct_map_on`. The finite search (`list_search`, `range_search`) goes there too, unless the owner writes it with the census's count `«计»`.
- **Locality.** Four proofs change (§3.1). Added: the supports. Removed: three helpers (§5). Statements unchanged.
- **Decidedness.** Two proofs change (§3.2). Added: the supports. Statements unchanged. Its imports already reach GrammarLaws, Population and Locality.
- **Identity.** Two proofs change, two laws are added and the two census recurrence laws are re-proved through them, moved below the covering forms (§3.4). Removed: four helpers (§5). Statements unchanged.
- **Population**, only if the census of a run drops its unused hypotheses: `coming_of_ceasing` passes two fewer arguments, and its docstring loses "listed once".
- **Imports.** Locality, Decidedness and Identity already reach GrammarLaws, Arising and Population. No import changes.

**Records** (statements of the changed laws unchanged, unless §8 question 1 is taken; routes and next steps change):
- [one-root-to-its-edge](../../../../../../theories/becoming/results/records/one-root-to-its-edge.md). The next step drops "the covering laws' root form". A history entry answers the U4c entry's boundary line ("the covering laws … are not cases"): the covering laws and the census of a run are cases of one count on lines.
- [shared-laws-on-the-grammar](../../../../../../theories/becoming/results/records/shared-laws-on-the-grammar.md) (renamed from master-laws-on-the-grammar by ND). Law 7 (steps) gains the line lemmas. The count, its mirror and the stretch forms get their own law, a law of ends on lines, with the run forms. The census of a run moves into it from law 4 ("Balance at one step"), since its proof is now a count on lines. Placement and numbering are the owner's.
- [census-balance-under-continuation](../../../../../../theories/becoming/results/records/census-balance-under-continuation.md).
  - Law 4's last sentence, "The covering laws (laws 10 and 11) go by lineages", becomes "through the root's covering laws". Its "laws 3, 6 and 9 go through the root's census of a step" narrows to the balance of law 9, the two recurrence laws now going through the exact forms.
  - A new law states the exact forms (§3.4) and cites the decision witness at Identity.
  - The Next drops what they close.
  - The related entry's "otherwise neither proof cites the other" is rewritten: both proofs now go through the root's covering laws.
- [ceasing-needs-arising](../../../../../../theories/becoming/results/records/ceasing-needs-arising.md). Law 2 names the route: the world and standing readings go through the covering law (law 6), which now reaches the root through its own root form. Law 2 also says that the root's census of a run is itself a case of the root's count.
- [recurrence-without-decidedness](../../../../../../theories/becoming/results/records/recurrence-without-decidedness.md). Law 2's counts go through the stretch form and its mirror.
- [laws-of-one-step](../../../../../../theories/becoming/results/records/laws-of-one-step.md) (laws 13, 14; its `references` lose Locality's three helpers), [continued-change-needs-openness](../../../../../../theories/becoming/results/records/continued-change-needs-openness.md) (law 7) and [space-and-its-parts](../../../../../../theories/becoming/results/records/space-and-its-parts.md) (law 18). Each states its law's route where it names one. Its "Shared laws, by Lean dependency" annotation comes from the render.
- **Re-pointing.** Records bound to the source hashes of GrammarLaws (9), Locality (19), Identity (8) and Decidedness (17) number 46, and 62 with Population's (31). Each is re-pointed to the core run's receipt after reading it against the changed text, with the reason. No hash is refreshed to silence a failure.

**Home sections.**
- [01 §7](../../../../../../theories/becoming/chapters/01-ROOT.md#r-master-laws-on-the-grammar)'s balance bullet gains, after the census of a run (the review's draft, extended):

  > Traced along lines instead of listed at each step: endings on lines from a list, the successor fixed where the lines could part, number at most the list. So, with each step one stage on and the units a region nothing outside continues into, a list covering them at one stage and nothing beginning over a stretch after it bound the endings in the stretch; with lists at arbitrarily late stages and each unit after them decided to begin or to have a predecessor, endings recurring need beginnings recurring, and without the decision a later beginning is not refuted. Mirrored, with bounded lists at every stage, the region closed forward and nothing merging, beginnings recurring leave endings never stopping, and with each unit decided to end or to continue, endings recur. The census of a run is a case, its test of beginnings deciding a finite search; so are Locality's, Decidedness' and Identity's covering laws.

  If the census of a run drops its unused hypotheses, the bullet's earlier sentence loses "with the units after each step listed once" and the test of endings.
- 01 §9.5's census-balance-under-continuation row gains a clause: from covering lists, with whether a formation continues (or is continued by) an active one decided, and no decision of activity, the two directions hold exactly; a census is not needed.
- [08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#r-one-root-to-its-edge) is unchanged. The central declarations downstream of the changed proofs (`World.comes_to_rest_unrefuted`, `RegimeMargin.Adjusted.comes_to_rest`, `Listed.coming_of_ceasing` and others) already reach the grammar in shared-laws.json, so what reaches the grammar does not change. The measure is rerun on the landing build to check this.

**Unchanged.** Every statement of the package, unless question 1 is taken. The 117 standings and their figures. `keep_pace`'s standing.

## 7. Evidence

- **The scratch** ([u4d-scratch](u4d-scratch/)), built with `scratch_build.py` on `u4d` after merging main at `6cb16bbce` (ND's final stage landed, `3e2e702be`; [build log](u4d-scratch/build-r2.log)): 106 theorems, every axiom report empty, no warning, none unclean.
  - `U4dCover`: the laws, 34;
  - `U4dCases`: the cases, with the supports and the witness at Identity, 38;
  - `U4dSame`: the checks against the package's statements, 14;
  - `U4dNeeded`: the witnesses, 20 (30 declarations with their relations).
- **What the Lean proves.**
  - The re-proofs prove exactly the package's statements: the four at Locality, the two at Decidedness, the two at Identity, the two census recurrence laws at Identity, and the root's two census-of-a-run laws. `type_of% @X := @Y` checks the type up to definitional equality, binder names and annotations aside, so the landing keeps each statement's text and changes only its proof.
  - Each original is named from the root (`@_root_.Becoming.…`). Inside a declaration named `U4d.same_…`, Lean resolves a bare name to `U4d.…` first. The first scratch's check of `coming_of_ceasing_covered` therefore compared the scratch's own law with itself and checked nothing. The design and the review both reported that check as made. Every check now names its original, and all fourteen pass.
  - The witnesses prove that each hypothesis's failure is consistent with the others where every run form's conclusion fails. The reductions prove, for an arbitrary `Q`, that the found forms at their models are equivalent to `¬Q ∨ ¬¬Q`.
  - Intuitionistic logic does not prove weak excluded middle. That Lean's axiom-free logic does not prove it either is the standard belief, not a fact checked here.
- **The review's scratch** ([u4d-review-scratch](u4d-review-scratch/Becoming/U4dReview.lean)) was built against this design's first scratch (`d39c709d3`), 12 theorems, every axiom report empty. It is kept as the review's evidence. The revised scratch carries its checks on the revised frame, so it no longer builds against it.

## 8. Order and cost, and questions for GrammarLaws' owner

**Order.**
1. The review's findings are taken (§9).
2. GrammarLaws' owner gives names and placement, and answers the questions below.
3. The package's Lean is written on this branch and built in scratch: GrammarLaws, the prelude, Locality, Decidedness and Identity, with their closure (and Population under question 1).
4. The landing review reads the record and chapter texts.
5. The rehearsal runs on main after EL6 and OG have landed, so that the one core run is reused at landing. The slot comes from the coordinator.

The re-points and the render come with the landing, in a clean worktree. The board's U4d row is amended at landing to name Decidedness' two counts, the census of a run as a case, and Population if question 1 is taken.

**Questions for GrammarLaws' owner.**
1. **The census of a run's unused hypotheses.** Its line proof uses neither the listing once nor the test of endings. Recommended: drop both from `GrammarLaws.census_run` and `«定后前者在前则亡屡者生屡»`, a strictly stronger law under the same names. The alternative keeps both statements as corollaries of a separately named line form. That spares Population's 16 further re-points, but leaves a grammar law asking what no proof uses, and the unused binders would have to be marked for the linter.
2. **Names.** The count, its mirror, the stretch form and its mirror, the run forms and the line form of the census of a run, in the grammar's naming.
3. **The finite search.** In the prelude as `list_search` and `range_search`, or written with `«计»` and `split_of_count_pos` as the census of a run's present proof writes it.
4. **The shared-laws record.** A law of ends on lines with the census of a run moved into it from law 4, as §6 proposes, or another arrangement.

The review answered the design's first five questions: GrammarLaws, not a leaf; the region beside `E`, with its conditions as closed regions; the census recurrence laws re-proved through the exact forms; the count's local hypothesis as the law with `«定后于»` at each member a corollary; the decision witness read as a reduction.

## 9. The review and what was taken

The independent review ([REVIEW-U4D](REVIEW-U4D.md)) has seventeen numbered findings: one blocking, eight should-fix (2 to 9) and eight minor (10 to 17; its count says nine). Each was taken; none was answered against.

| Finding | Taken as |
|---|---|
| 1. The census of a run is a case of the count | the stretch form and the line form of the census of a run (§2.3, §2.4); §0 and §5 rewritten; question 1 |
| 2. A helper keeps a consumer; the removal rule removes none | the shorter route for `Covers.not_not_coming_from` and `Covers.ceasing_stops_unrefuted`; helpers removed from the package and `references` (§3.1, §5) |
| 3. Run witnesses refute only one form | each run witness ends with no beginning after the first stage; converse witnesses carry the decision (§4) |
| 4. Three hypotheses have no witness | `run_needs_stage`, `converse_needs_decision`, `exact_needs_decision` (§3.4, §4) |
| 5. The decision row is a reduction | §4's second table, the least decision open, decisions asked after the list's stage, §7's last point |
| 6. Record laws not named; the renamed record | census-balance-under-continuation law 4, ceasing-needs-arising law 2, shared-laws-on-the-grammar (§6) |
| 7. Home sections | 01 §9.5 clause; 01 §7 sentence redrafted with the frame's hypotheses (§6) |
| 8. Line lemmas after their corollary | Runs section before `«迭之定于»` (§6) |
| 9. The frame's conditions are closed regions | `«闭»` conditions, the region `P`, wrappers dropped, units read as occurrences at stages (§2.3) |
| 10. More laws reach the root | named (§3.1) |
| 11. The reason 08 §7's figures hold | the downstream central declarations already reach the grammar; measure rerun (§6) |
| 12. "From `T` on" | the decisions and the bound state their `T` (§2.3) |
| 13. `run_needs_covering`'s description | infinitely many units at every stage (§4) |
| 14. General lemmas at a special type | `pick`, `distinct_of_map` generalized; `closure_iff_steps` one equivalence |
| 15. The base moved; what `type_of%` checks | rebuilt after merging post-ND main; §7; the vacuous check found and fixed |
| 16. `Covers.within` not placed | placed (§5) |
| 17. Identity's file order | §3.4 |

Beyond the findings, Decidedness' two counts were found to be cases of the stretch form and its mirror, and are re-proved here (§3.2).
