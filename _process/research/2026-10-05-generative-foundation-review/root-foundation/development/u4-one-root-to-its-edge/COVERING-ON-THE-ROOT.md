# The covering laws on the root (U4d, design)

1 November 2026. AI-written design for the next step that the record [one-root-to-its-edge](../../../../../../theories/becoming/results/records/one-root-to-its-edge.md) names first: "the covering laws' root form (lines traced back to a covering list, no splits)". U4c's design left these laws out as not cases of the census ([CENSUS-ON-THE-ROOT §3.5](CENSUS-ON-THE-ROOT.md)). Every law here, every case and every witness is checked in scratch Lean outside the package ([u4d-scratch](u4d-scratch/), §7), and no package Lean is written before the independent review. Reading time: §0 in about five minutes, the whole in about twenty.

## 0. The proposal in brief

- **The covering laws today.** Two families sit beside the census, each with its own proof.
  - *Locality.* Where some list covers what holds at a step, ceasing recurring needs coming to be after it. The decided form is `Covers.coming_from_of_ceasing`, proved by accumulating ceasings over stretches. The undecided count is `Covers.ceasing_steps_within`, proved by counting steps that see a ceasing. Six laws go through these two. Four are in Locality: `coming_of_ceasing_covered`, `Covers.ceasing_stops_unrefuted`, `Covers.ceasing_not_recurring` and `Covers.not_not_coming_from`. Two are in Openness, through the first of these: `World.arising_of_ceasing` and `Web.StandingCensus.coming_of_ceasing`.
  - *Identity.* Under a continuation, from one covering list: `Web.not_not_arisingFrom_covered`, with `Web.arisingFrom_not_stopping_covered` through it, and the converse `Web.ceasingFrom_not_stopping_covered`. These are proved by lineages: `Lineage.back`, `Lineage.ends`, `Lineage.onward` and `lineages_apart`.
- **What is proposed: one count on the grammar, and its run forms.**
  - **The count of ends on lines from a list.** Take occurrences listed once, each ending (`«亡»`), each within the closure of a member of a list. Suppose that, wherever two successors of an occurrence a member reaches each lead to a listed ending, they are one. Then there are no more such occurrences than members. A line under fixed successors ends at most once, so endings match members one to one. No decision of identity is used. Reaching the list need only be not refuted, since the count is decided.
  - **Its mirror.** Beginnings (`«生»`) on lines to a list number at most the list, nothing merging where it matters. It is the same law at the converse.
  - **Run forms, on a stage map** (each step of the continuation one stage on, a modelling choice).
    - *Decided, from one list.* Suppose a list covers the units at stage `N`, what holds of a unit holds of its predecessors, no unit continues as two units, and each unit is decided to begin or to have a predecessor. Then, where endings recur, something begins after `N`. With lists at arbitrarily late stages, beginnings recur.
    - *Undecided.* With endings only not refuted to recur, a beginning after `N` is not refuted, so beginnings never stop.
    - *The converse.* Suppose lists of at most `K` cover each stage from `T` on, what holds of a unit holds of its successors, and no two units continue as one. Then beginnings recurring leave endings never stopping, and with ending or successor decided, endings recur.
- **What they reach.** Four package proofs change. Each statement is kept, checked against the package's own type:
  - `Covers.coming_from_of_ceasing` is a case of the decided form from one list;
  - `Covers.ceasing_steps_within` is a case of the count;
  - `Web.not_not_arisingFrom_covered` is a case of the undecided form;
  - `Web.ceasingFrom_not_stopping_covered` is a case of the converse.

  The seven other laws named above reach the root through these four with their proofs unchanged. The units are a relatum's occurrences along its steps (Locality) or a formation's occurrences under the continuation within activity onward from a step (Identity).
- **New at Identity: the exact forms.** The record [census-balance-under-continuation](../../../../../../theories/becoming/results/records/census-balance-under-continuation.md) leaves open "the exact existential forms of both directions … and the decision the exact form needs". Two cases close it:
  - with covering lists and whether a formation continues one before decided, ceasing recurring needs arising recurring;
  - with bounded covering lists and whether a formation is continued decided, the converse holds.

  Identity's census recurrence laws (`Census.arisingFrom_of_ceasingFrom_from`, `Census.ceasingFrom_of_arisingFrom_from`) are cases of these two, checked against their own types. So the new laws generalize the census laws below them rather than stand beside them (board rule 9).
- **Each hypothesis needed.** A witness meets all the others where the conclusion fails (§4). Two of them carry the argument:
  - The decided form needs its decision. In a model built on any proposition `Q`, every other hypothesis holds, the decision holds exactly where `Q` is decided, and beginnings recur exactly where `¬Q ∨ ¬¬Q`. So the form with a beginning found, asked without a decision, would give weak excluded middle for every proposition. Asked as not refuted, it asks no decision.
  - The count needs fixed successors: one occurrence continuing as two endings gives two endings from one member.
- **Standing.** None of these laws is among the 117 central declarations, so the standings and figures of [08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#r-one-root-to-its-edge) do not change. What changes is the record's next step, the covering laws are dropped from it, and the routes named in six records (§6).
- **What it does not reach.**
  - `CensusWebs.keep_pace`, whose stretch form on positions stays a later step.
  - The census of a run (`«定后前者在前则亡屡者生屡»`) is a sibling, not a case, either way (§5).
- **Cost.** One core run, since Locality and Identity lie upstream of most of the package. Names and placement come from GrammarLaws' owner, and the slot from the coordinator.

## 1. What the root and the model already have

- **Lines on the grammar.**
  - Steps (`«迭»`): `n` steps lie within the closure, and the closure is reached by some number of steps (`«迭则同一或及»`, `«及即迭»`, `«所闭当且仅当同一或及»`).
  - Steps split as they compose (`«迭之分»`).
  - With the successor fixed at what `x` reaches, `n` steps lead to one occurrence (`«迭之定于»`).
  - What is reached in fewer than `n` steps having a successor as far as can be refuted gives `n` steps as far as can be refuted (`«或有后则或迭»`).
  - The closure read backward is the converse's (`«所闭之逆»`).
- **Counting on the root.**
  - The prelude's `length_le_of_matched`, which carries U4c's census of a step: a list without repetition matched into another, no member matched twice, is no longer.
  - `not_not_all`: a double negation for each member of a list is one for all.
- **U4c's census laws.**
  - The census of a step, one side and its mirror (`«定后则后并亡不过前并生»`, `«定前则前并生不过后并亡»`).
  - The census of a run (`«定后前者在前则亡屡者生屡»`). Units are listed after each step, predecessors listed before, beginnings and endings tested.

  No grammar law follows a line from a list across many steps to its end.
- **The occurrence readings.**
  - At Locality: `Steps.along`, `Steps.alikeAt`, `Steps.along_fixed`, and Population's bridges `comesToBe_iff_sheng_along` and `ceasesToBe_iff_wang_along`.
  - At Identity: `continuationStep`, `activityOnward`, `occurrence_eq`.

## 2. The laws

Working names are in `U4dCover` (30 theorems). The package's names come from GrammarLaws' owner (§6).

### 2.1 Lines from a list, on any relation

- `closure_of_steps`, `steps_of_closure`: the closure is some number of steps (two directions of `«所闭当且仅当同一或及»` with `«及即迭»`).
- `steps_unique`: `n` steps from `a` lead to one occurrence, where two successors of an occurrence `a` reaches, each leading to `y` or to `z`, are one. This is the local form of `«迭之定于»`, asking the successor fixed only where the two lines could part. `«迭之定于»` is its corollary.
- `ends_before`: under the same hypothesis, an occurrence that ends lies on no longer line from the same start (`«迭之分»` at the shorter length).
- `one_end_rel`: **a line under fixed successors ends at most once.** Two occurrences that `m` reaches and that end are one.

### 2.2 The count, and its mirror

- `ends_le_rel` (any relation), `ends_le` (on `«续» R E` with `«亡»`): **endings on lines from a list number at most the list.** The statement:

  > `D` listed once; each member of `D` ending and within the closure of a member of `L`; any two successors of an occurrence a member of `L` reaches, each leading to a member of `D`, one. Then `D.length ≤ L.length`.

  The proof matches each ending to a member reaching it (`length_le_of_matched`). No member is matched twice, by `one_end_rel`.
- `ends_le_unrefuted`: the same with each ending only not refuted to be reached. The conclusion is a decided comparison of numbers (`Nat.decLe`), so the double negations lift through `not_not_all`.
- `begins_le`, `begins_le_unrefuted`: **the mirror**, at `«逆» («续» R E)`. Beginnings on lines to a list number at most the list, where any two predecessors of an occurrence that reaches a member, each reached from a listed beginning, are one.

### 2.3 Run forms on a stage map

The frame: a stage map `τ` with each step of `«续» R E` one stage on, and units `here`, a region the lists cover. The stage map is a modelling choice, discrete steps, stated where the laws depend on it.

| Form | Working name | Hypotheses besides the frame | Conclusion |
|---|---|---|---|
| decided, one list | `cover_from` | `L` covers the units at `N`; units held back along steps; no unit continuing as two units; each unit begins or has a predecessor; endings at arbitrarily late stages | a unit begins after `N` |
| decided, run | `cover_run` | lists cover the units at arbitrarily late stages; the rest as above | beginnings at arbitrarily late stages |
| undecided, one list | `cover_unrefuted` | as `cover_from`, no decision; endings recurring only not refuted | a beginning after `N`, not refuted |
| undecided, run | `cover_never_stops` | lists at arbitrarily late stages | beginnings never stop |
| converse | `cover_converse` | lists of at most `K` cover each stage from `T`; units held on along steps; no two units continuing as one; beginnings at arbitrarily late stages | endings never stop |
| converse, decided | `cover_converse_run` | as above, each unit ending or with a successor | endings at arbitrarily late stages |

The proofs share one shape. Take `|L| + 1` endings at distinct stages from `N` (`found`, `found_unrefuted`). Then trace each back stage by stage to `N` (`trace`, `trace_unrefuted`). At each unit after `N`, either a beginning is found, or its predecessor is a unit, held back, at the stage before. At `N` the unit is on the list. If no beginning is found, every ending lies on a line from the list, and the count is broken. The converse traces forward from `K + 1` beginnings to a stage past them all (`trace_on`, or `onward_unrefuted` through `«或有后则或迭»`). There every line's end is on that stage's list, and the mirror is broken.

No unit continuing as two units is asked only of successors that are units. Through holding back, that gives the count's local hypothesis (`fixed_of_noSplit`). "From step `T` on" is not a hypothesis of the root forms: a model states it in its continuation, as Identity does through `activityOnward T`.

## 3. The cases

The cases are in `U4dCases` (30 theorems). `U4dSame` (10 theorems) checks each against the package's own statement, `type_of% @Original := @U4d.case`.

### 3.1 Locality

- **The reading.** A unit is an occurrence `(t, a)` where `p a t` holds; the stage is `t`; the continuation is `Steps.along` within `Steps.alikeAt p`. Five support lemmas meet the frame, each a line or two:
  - `along_stage`, from `along`;
  - `along_keeps`, since the class is two-valued;
  - `along_noSplit`, from `Steps.along_fixed`;
  - `along_covers`, the list `L.map (N, ·)`;
  - `along_decided`, from `p`'s decision: at step 0 a beginning (`along_sheng_zero`); after it a predecessor where `p a t` holds, else coming to be.

  A sixth, `along_ending`, reads a ceasing as an ending (`ceasesToBe_iff_wang_along`).
- **`Covers.coming_from_of_ceasing`** is `cover_from`. A beginning after `N` lies at a step `t + 1` with `N ≤ t`, which `comesToBe_iff_sheng_along` reads as coming to be across the step from `t`. This is why the root form concludes `N < τ y`: at the first step everything begins under every class.
- **`Covers.ceasing_steps_within`** is the count where reaching is not refuted (`ends_le_unrefuted` with `trace_unrefuted`). Its ceasing steps are read as occurrences (`pick`, an existential over a list of steps proved by induction, no choice). Distinct steps give distinct occurrences (`distinct_of_map`), and nothing coming to be across the stretch means nothing begins between `N` and each ceasing.
- **Through them, unchanged:** `coming_of_ceasing_covered`, `Covers.ceasing_stops_unrefuted`, `Covers.ceasing_not_recurring`, `Covers.not_not_coming_from`, `World.arising_of_ceasing`, `Web.StandingCensus.coming_of_ceasing`. The scratch also re-proves the four Locality laws directly from the run forms, as a check.

### 3.2 Identity

- **The reading.** A unit is an occurrence `(t, f)` with `f` active at `t`; the stage is `t`; the continuation is `continuationStep R` within `activityOnward M`. `activityOnward M` relates only from an active occurrence at or after `M`. That is how "no splits from `M` on" becomes the root's "no unit continuing as two units": every successor under it is active, and nothing before `M` has one. The supports are `cont_stage`, `cont_keeps`, `cont_keepsOn`, `cont_noSplit`, `cont_noMerge`, `cont_covers` and `cont_ending`. The bridges `cont_arises`, `cont_ceases` and `cont_begins` read `ArisesFrom` and `CeasesFrom` from `M` on as beginning and ending there.
- **`Web.not_not_arisingFrom_covered`** is `cover_unrefuted`; **`Web.ceasingFrom_not_stopping_covered`** is `cover_converse` with the one list at every step from `T`.
- **Through them, unchanged:** `Web.arisingFrom_not_stopping_covered`.

### 3.3 New at Identity

- **`arisingFrom_of_ceasingFrom_covered`.** Suppose covering lists at arbitrarily late steps, no splits from `T` on, and `Continues` decided. Then ceasing under the continuation recurring needs arising under it recurring. This is `cover_run`, the decision read at each active occurrence (`cont_decided_begin`).
- **`ceasingFrom_of_arisingFrom_covered`.** Suppose lists of at most `B` covering each step from `T`, no merges from `T` on, and `Continued` decided. Then arising recurring needs ceasing recurring. This is `cover_converse_run` (`cont_decided_end`).
- **Census laws as cases.** `Census.arisingFrom_of_ceasingFrom_from` and `Census.ceasingFrom_of_arisingFrom_from` carry their section's three decisions. Each is a case: the listing covers, and its bound bounds (`U4d.census_case`, `U4d.census_converse_case`).
- **Proposal.** Re-prove the two census laws through the new ones, so that no second proof stands beside the general law. Their present proofs go through `balanceFrom_at`, which U4c made a case of the root's census of a step. Either route reaches the root, so this is the owner's choice under rule 9 (§8, question 3).

## 4. Each hypothesis needed

Each witness is in `U4dNeeded` (18 theorems). It meets every other hypothesis, and the conclusion fails there. Units are pairs of natural numbers unless said otherwise.

| Law | Hypothesis | Witness | Where the conclusion fails |
|---|---|---|---|
| count | fixed successors | `count_needs_fixed`: `0` continues as `1` and `2`, both end | two endings, one member |
| run | no split | `run_needs_noSplit`: a line continuing as itself and as a unit that ends, at every stage | no beginning after the first stage |
| run | held back | `run_needs_keeps`: relatum `a`'s line runs to stage `a` and ends, only the end a unit | the same |
| run | covering lists | `run_needs_covering`: every line a unit along its length, infinitely many at the first stage | the same |
| run, found | the decision | `run_needs_decision Q`: the line continues as itself where `Q`, as an ending unit where `¬Q` | the decision is exactly `Q ∨ ¬Q`; beginnings recur exactly where `¬Q ∨ ¬¬Q` |
| converse | no merge | `converse_needs_noMerge`: each stage's two units continue as one | nothing ever ends |
| converse | a bound | `converse_needs_bound`: relatum `a`'s line from stage `a`, never ending | the same |
| converse | held on | `converse_needs_keepsOn`: as above, only the start a unit | the same |

The stage map is the frame, not a hypothesis, and has no witness. The mirror's no-merge hypothesis is the count's own hypothesis at the converse.

## 5. Not cases, and siblings

- **The census of a run** (`«定后前者在前则亡屡者生屡»`) is a sibling. It lists units at every step and tests beginnings, finding a predecessor only as far as can be refuted. That is enough there, since the census of a step sums over the stretch. The covering law lists only at sparse stages and follows lines between them, so where something does not begin it needs the predecessor found. Neither's hypotheses give the other's:
  - the census's tests do not give the predecessor positively;
  - Locality's covering list gives no list at the steps between.

  Both rest on the same count by matching (`length_le_of_matched`) and on the grammar's beginnings and endings. A form taking lists at every step with tested beginnings, of which both would be cases, is open (§8). So is the stretch form on positions.
- **`CensusWebs.keep_pace`** stays at counting, for U4c's reason: a two-sided bound over a stretch on a fixed family that may list a member twice.
- **The lineage laws** (`Lineage.unique`, `origin`, `split`, `through`, `onward`, `back`, `line`) are laws of lineages that 01 §7 names as cases of the grammar. They stay, statements and proofs unchanged; only the covering laws stop going through them.
- **The proof-only helpers** lose their last consumer:
  - in Identity, `ceasingFrom_found`, `arisingFrom_found`, `Lineage.ends` and `lineages_apart`;
  - in Locality, `accumulates_or`, `ceases_once` and `ceasing_steps_unrefuted`.

  The landing checks each for other consumers and for citations in records and chapters. Rule 9 removes those that nothing uses or cites and keeps the rest, the list stated in the landing.

## 6. What changes, and what does not

**Lean.**
- **GrammarLaws.** The census section gains, after the census of a run:
  - the line lemmas;
  - the count and its mirror, each with its local form beside it;
  - the six run forms.

  `«迭之定于»` becomes the corollary of `steps_unique`, its statement kept.

  A leaf module importing GrammarLaws would leave GrammarLaws' hash and its nine bound records alone. But U4c put the census laws in GrammarLaws, and one census section reads better. The owner chooses (§8, question 1).
- **Locality.** Two proofs change: `Covers.coming_from_of_ceasing` and `Covers.ceasing_steps_within`. Added: the six supports of §3.1, `pick` and `distinct_of_map`. Statements are unchanged.
- **Identity.** Two proofs change: `Web.not_not_arisingFrom_covered` and `Web.ceasingFrom_not_stopping_covered`. Added: the supports of §3.2, `cont_decided_begin`, `cont_decided_end` and the two new laws. Statements are unchanged.
- **Universe.** The scratch uses `ListTests.mem_cons_iff`, which is polymorphic, where the prelude's `mem_cons_cases` is stated at `Type`. Either the laws keep that, or `mem_cons_cases` generalizes to `Type u` as U4c generalized three lemmas: a strict generalization, no caller changed.
- **Imports.** Locality and Identity already reach GrammarLaws, Arising and Population. No import changes.

**Records** (statements of the changed laws unchanged; routes and next steps change):
- [one-root-to-its-edge](../../../../../../theories/becoming/results/records/one-root-to-its-edge.md). The next step drops "the covering laws' root form". The U4c entry's boundary line ("the covering laws … are not cases") is answered in a new history entry. Whether a law entry states the covering root form here or only in master-laws-on-the-grammar is for the record review.
- [master-laws-on-the-grammar](../../../../../../theories/becoming/results/records/master-laws-on-the-grammar.md). Law 4 gains the count, its mirror and the run forms, as it gained U4c's census laws. Law 7 gains the line lemmas.
- [census-balance-under-continuation](../../../../../../theories/becoming/results/records/census-balance-under-continuation.md). Laws 10 and 11 go through the root's covering laws. A law states the exact forms (§3.3), and the Next drops what they close. The related entry's "otherwise neither proof cites the other" becomes false: both now go through the root's covering law, and it is rewritten.
- [laws-of-one-step](../../../../../../theories/becoming/results/records/laws-of-one-step.md) (laws 13, 14), [ceasing-needs-arising](../../../../../../theories/becoming/results/records/ceasing-needs-arising.md) (laws 6, 7), [continued-change-needs-openness](../../../../../../theories/becoming/results/records/continued-change-needs-openness.md) (law 7) and [space-and-its-parts](../../../../../../theories/becoming/results/records/space-and-its-parts.md) (law 18). Each states its law's route where it names one, and its "Shared laws, by Lean dependency" annotation comes from the render.
- **Re-pointing.** Records bound to the source hashes of Locality (19), Identity (8) and GrammarLaws (9), about thirty in all, are re-pointed to the core run's receipt after reading each against the changed text, with the reason. No hash is refreshed to silence a failure.

**Home sections.**
- [01 §7](../../../../../../theories/becoming/chapters/01-ROOT.md#r-master-laws-on-the-grammar)'s balance bullet gains one sentence after the census of a run, drafted:

  > Traced along lines instead of listed at each step: endings on lines from a list, the successor fixed where the lines could part, number at most the list, and so, with lists covering the units at arbitrarily late stages and each unit decided to begin or to have a predecessor, endings recurring need beginnings recurring; without the decision a later beginning is not refuted, and with bounded lists at every stage the converse holds; Locality's and Identity's covering laws are cases.

- 01 §9.5's census rows name the new route where they name one.
- 08 §7 is unchanged, since no central declaration changes standing.

**Unchanged.** Every statement of the package. The 117 standings and their figures. `keep_pace`'s standing.

## 7. Evidence so far

- **The scratch** ([u4d-scratch](u4d-scratch/)), built with `scratch_build.py` on main `43497d137`: 88 theorems, every axiom report empty, no warning, none unclean.
  - `U4dCover`: the laws, 30;
  - `U4dCases`: the cases, 30;
  - `U4dSame`: the checks against the package's statements, 10;
  - `U4dNeeded`: the witnesses, 18 (25 declarations with their relations).
- **What the Lean proves.** The four re-proofs and the two census cases prove exactly the package's statements, checked by `type_of%`. The witnesses prove that each hypothesis's failure is consistent with the others where the conclusion fails. `run_needs_decision` proves that, for an arbitrary proposition `Q`, the found-beginning form at that model is equivalent to `¬Q ∨ ¬¬Q`. That Lean's logic does not prove weak excluded middle is a known fact about intuitionistic logic, not a Lean result.

## 8. Order and cost, and questions for the review

**Order.**
1. This design is independently reviewed; findings are taken or answered.
2. GrammarLaws' owner gives names and placement.
3. The package's Lean is written on this branch and built in scratch, `GrammarLaws`, `Locality` and `Identity` with their closure.
4. The landing review reads the record and chapter texts.
5. One core run follows, in a slot from the coordinator.

The re-points and the render come with the landing, in a clean worktree.

**Questions for the review.**
1. Do the run forms belong in GrammarLaws, beside the census of a run, or in a leaf module?
2. Is the frame's `here` with held back / held on the right relational form, or should the region live in the continuation (`E`), as Identity's `activityOnward` already does?
3. Should Identity's census recurrence laws be re-proved through the new exact forms under rule 9, or keep their census route? Both reach the root.
4. Should the count's local hypothesis be stated as here (two successors each leading to a listed ending are one), or as `«定后于»` at each member, which every case meets?
5. Is the decision witness's reading right? It says the found-beginning form asks a decision, because asked without one at that model it would give weak excluded middle for any proposition.
