# OU3f: the theorems that read only activity, audited

AI-written audit for board item OU3f, 29 October 2026, on main at `3e9a856b6`. Source: OU plan §八 step 4, its second part, which lifts the theorems that read only `active` after the central declarations; the board row also sets the decisions below. The audit uses no Lean. Each theorem gets one of three standings:
- **(a)** the grammar law it is a case of at the occurrence model, where activity is a partial identity ([WRT's design](../world-representation/DESIGN.md), §1.3), with the derivation that puts it below that law (board rule 9);
- **(b)** a law the grammar lacks that several theorems share, written out;
- **(c)** a law of its model, with the reason.

A row counts as (a) only where the grammar law would replace part of the proof: applying a law and then undoing it is no derivation (the test that caught `PartForms.goAlike`, [OU3d's review](../ou3d-step-indexed-reaching/REVIEW-OU3d.md), *Second pass*). Instance theorems that only connect a notion to its grammar term, as OU3a's do, are representation (c). One independent review read the audit; every finding was taken ([REVIEW-OU3f](REVIEW-OU3f.md), and the last section). Every theorem's row is in [TABLE.md](TABLE.md); this note gives the argument.

## Method

- **The recount.** The dependency audit's tool ([audit](../one-unfolding-root/audit/REPORT.md)) was run on main. `dump.py` restored the compiled modules from the step cache without compiling. A copy of `audit.py` was run outside the repository, since in place it writes over the tracked `REPORT-DATA.json`; the copy differs only in its root path. It was run on 338 modules and 16,484 theorems, with the sources matching the commit.
- **The count.** 436 theorems read only `active` by the main count, and 388 of them by the upper bound as well. On `0cc1aafb4` there were 348; the spine has grown since. The recount's data are kept in `data/` (`active-only.json`; `REPORT-DATA-recount.json`).
- **What a proof reaches** (`kit/reach.py`). For each theorem, the grammar theorems (constants named with «», of kind theorem) that its proof reaches were read off the dump, directly and transitively (`data/reach.json`). Thirty proofs reach one, fifteen directly. Reaching a grammar theorem is not yet being a case of it: a law used as a lemma, such as reach's transitivity, makes no row (a).
- **The classification.** Each theorem's printed statement was read from the checker's signature audit (`kit/statements.py`), and its proof was read where a grammar law was a candidate (`kit/source.py`). The candidate laws were:
  - the line and class laws of the grammar;
  - closure (`Invariant.reach` with `Run.reach`, as in EC6b);
  - the laws of steps («迭», with OU3d's);
  - the map's laws.

  Modules of witnesses and of counting laws were classified from their statements and the definitions they unfold; the review sampled them. Two kinds of claim were checked mechanically against the dump:
  - every row resting on a field-free law depends on the law named (ten anchors were corrected);
  - every "(a), done" row reaches a grammar theorem.
- **Two checks compiled by the review**, kept in `checks/` and not for landing, with empty axiom reports:
  - `OU3fClosureCheck.lean`: two closure re-proofs;
  - `OU3fLawsCheck.lean`: B1 in both orders, B2 bounded and B2 from it, the converse law, the restricted Lineage bridge, and `unique` and `origin`.

## Summary

| standing | theorems | what it says |
|---|---|---|
| (a) | 15 | a grammar law replaces part of the proof; three of them are small |
| (a), follows | 4 | no induction of their own: they reach the grammar unchanged once rows they apply do |
| (a), done | 10 | the proof already reaches the grammar law it is a case of |
| (b) | 4 | B1 and B2, two laws of steps the grammar lacks, needed for the row's own derivation |
| (b), follows | 5 | they rest on a web lemma that states B2, and reach B2 unchanged once it lands |
| (b), not proposed | 7 | a law of two-valued classes the grammar lacks, already stated once below as a field-free law |
| (c) balance, represented | 1 | a central declaration resting on balance (represented), as the measure reports |
| (c) field-free law below | 8 | already the instance of a field-free law; six of them rest on balance (represented) |
| (c) representation | 63 | an instance theorem reading a notion as its grammar term, or a definitional fact of the readings |
| (c) calibration | 6 | the logical strength of a law over all worlds (excluded middle, LPO) |
| (c) witness | 141 | a fact of one constructed web, world or law |
| (c) model | 172 | a law of the model, reason by kind below |

So 29 of the 436 are cases of a grammar law today: 15 to derive, 4 following them, and 10 already derived. Nine more reach a grammar law once B1 and B2 are stated: four to derive, five following. The other 398 are laws of their models, read on the grammar where a representation theorem applies, with their reasons. (The audit first counted 13, 27 and 400: the twins' review found `ByPassing.ends_within` a case of `«两端分则中有标»`, and the closure review `ByPassing.trace` a case of closure, both filed as laws of their models; see the last sections.)

## (a) Cases of a grammar law, with derivations

All fifteen are web theorems at the occurrence carrier `Nat × F` that OU3a's instance theorems use (`Web.continuationStep`, `Web.activityClass`). The derivations use OU3a's class reading. On lines from an active occurrence, that reading agrees with activity as a partial identity, since activity is one class along a line (`«线内同类»`). So they need no WRT2 occurrence model, which represents the World; these laws are the web's.

### Closure: six inductions over steps

EC6's audit put lemmas that prove invariance by their own induction on the step count among the cases of closure. EC6b derived them through `Invariant.reach` with `Run.reach` (`Pace.stays`). Six activity laws do the same by hand. Each keeps a region along steps, so each is a case of the grammar's closure at the successor relation: a region every step keeps holds from where it holds on (`kept_onward`, from `«线则所闭»` with `«闭含所闭»`; the closure derivations' [design](closure/DESIGN.md)). The audit first wrote this as `Invariant.reach` on a clock run; the review of the closure derivations found that run already exists (`Law.run Nat.succ`) and that the grammar needs none.

| theorem | the region every step keeps |
|---|---|
| `Web.inactive_of_not_arising` (Retaining) | not being active, where nothing arises; compiled by the review |
| `Web.active_back` (Wholes) | bounded: a part active at `S + k`, with no part arising over the `k` steps, was active at `S`; compiled by the review |
| `Web.active_before` (Exclusion) | bounded: activity at a later step kept back to an earlier one, never arising after `T` |
| `Web.ended_for_good` (Reserve) | inactive with nothing in reserve, from `U` on |
| `Web.ByPassing.present_earlier` (PatternPassing) | bounded: presence kept by the backward step, by passing |
| `Web.steady_held` (Persistence) | bounded at both ends: an equality of names kept along a held stretch (it reads the names) |

A seventh, found by the closure review: `Web.ByPassing.trace` (PatternPassing) keeps a region along the steps, that every carrier at `S + n` carried the pattern at `S` or some carrier passed it across one of the `n` steps. It was filed (c) model, as an induction with no grammar law of its shape; closure is that law. The reason given, deciding whether two carriers are one formation, concerns only the route through the pattern's line.

### Three proved twice: rule 9 retires the direct proof

| theorem | its grammar twin | the law |
|---|---|---|
| `Web.Continuing.mono` (ContinuedClasses) | `Continuing.mono_by_reach` | `«及之单调»`: reach grows with the relation, read through `continuing_iff_line` |
| `Web.ByPassing.passes_within` (PatternPassing) | `ByPassing.passes_within_by_line` | `«两端分则中有标»`: a line whose ends lie apart in a class has a marked step, in place of `trace`'s induction |
| `Web.ByPassing.begins_passed` (PatternPassing), small | `ByPassing.begins_passed_by_grammar` | `«生于细而续于粗则异»`; the twin replaces only the contradiction from the arising (`absurd before begins.1`) |

In each, the twin keeps the derivation, the direct proof goes, and one name is retired or kept as an alias.

A fourth of the same kind, found by the twins' review: `Web.ByPassing.ends_within` (PatternPassing), if passing stops the pattern ends within one span. Its proof traced a carrier back with `ByPassing.trace`, as `passes_within`'s direct proof did. Through `ByPassing.line_back` and `«两端分则中有标»` (with `«线内同类»`) the passing lies on the pattern's line, where none is from `T` on. Its conclusion is a negation, so `trace`'s reason for staying a law of its model (deciding whether two carriers are one formation) does not apply. It was filed (c) model.

### Two lineage laws through a restricted bridge

`Web.Lineage R M g k h` (Identity) is `k` steps of continuation within activity from `(M, g)`, taken last step last. The bridge relates it to the grammar's steps of the restricted relation `x y ↦ «续» (continuationStep R) activityClass x y ∧ M ≤ x.1 ∧ active x.1 x.2`. That is the active continuation step from active sources at or after `M`. The bridge holds for every `k`, `0` included, and is its own induction through `«迭之末步»`. The review compiled it.

| theorem | the law | what it replaces |
|---|---|---|
| `Web.Lineage.unique` | `«迭之定»` | the induction on `k`: no split from `M` on is a fixed successor of the restricted relation |
| `Web.Lineage.origin` | `«迭之定前»` | the induction on `k`: no merge from `M` on is the restricted relation merging nothing |

For `split` and `through` (B1, below), the bridge must also fix the endpoint's step (`y.1 = M + k`), or B1's middle occurrence cannot be read back as a lineage from `M + j`.

### Two coarse-to-fine laws, both small

| theorem | the law | what it replaces |
|---|---|---|
| `Web.sheng_state_of_change` (Persistence) | `«生于粗则生于细»` | the step from "alike in the state class" to "alike in activity", which the proof inlines as a destructuring, as its sibling `arises_of_persisting_arises` already does through the law |
| `Web.wang_state_of_change` (Persistence) | `«亡于粗则亡于细»` | the dual |

The three small rows are counted the same way: genuine by the test, but each replaces only one step.

### (a), follows

These have no induction of their own; they apply rows above and reach the grammar unchanged once those do:
- `Web.ByPassing.present_of_le` and `Web.ByPassing.empty_stays` apply `present_earlier`.
- `Web.Lineage.ends` applies `through` (B1) and `unique`.
- `Web.lineages_apart` applies `split` (B1) and `origin`.

## (a), done: already derived

These ten proofs already reach the grammar law they are cases of:
- `Web.Continuing.mono_by_reach` reaches «及之单调».
- `Web.ByPassing.begins_passed_by_grammar` reaches «生于细而续于粗则异».
- `Web.ByPassing.passes_within_by_line` reaches «两端分则中有标» and «线内同类».
- `Web.arises_of_persisting_arises` reaches «生于粗则生于细».
- `Web.ceases_of_persisting_ceases`, `Web.ceasesFrom_of_unconditioned` and `Web.ceases_of_pattern_ends` reach «亡于粗则亡于细».
- `Web.merge_candles` reaches «蜡烛之合».
- `Web.active_along_line` reaches «线内同类».
- `Web.dissipation_arising_not_recurring` reaches the law of rest «尽则不或屡», through `falls_not_recurring` and `Amounts.rests` (OU3b).

## (b) Laws the grammar lacks

**B1, `«迭之分»`: steps split.**
- **The law:** the exact converse of `«迭之接»`. In `«迭之接»`'s order it reads `«迭» R (b + a) x z → ∃ y, «迭» R a x y ∧ «迭» R b y z`. It needs no arithmetic, and `«迭之末步»` is its one-step case.
- **The `m + n` reading:** `Web.Lineage.split` (`j + i` steps into `j` and then `i`) and `Web.Lineage.through` want the form `«迭» R (m + n) x z → ∃ y, «迭» R m x y ∧ «迭» R n y z`. The review compiled both orders.
- **Proposal:** state B1 in `«迭之接»`'s order, as its converse, with the `m + n` reading beside it.
- **Elsewhere:** `Withholding.Chain.prefix` and the trace prefixes are of the same shape. They read no field and are outside this count.

**B2: where nothing reached ends, steps of every length.**
- **Bounded form:** `(∀ k y, k < n → «迭» R k x y → ¬¬ ∃ z, R y z) → ¬¬ ∃ y, «迭» R n x y`. Where whatever is reached in fewer than `n` steps has a successor, as far as can be refuted, there are `n` steps, as a double negation.
  - The unbounded form `(∀ y, «所闭» R x y → ¬¬ ∃ z, R y z) → ∀ n, ¬¬ ∃ y, «迭» R n x y` follows in one line.
  - `Web.Lineage.back` needs the bounded form. Its hypothesis covers only steps from `M` on, so an occurrence at `M` need have no predecessor.
- **Positive form:** `«不穷» R E x → ∀ n, ∃ y, «迭» («续» R E) n x y`, on the grammar's own term.
- **Its uses:**
  - `Web.Lineage.onward` (with nothing ceasing from `N` on, a lineage of every length) and `Web.Lineage.back` (with nothing arising from `M` on, a lineage back to `M`) need it for their own derivations. `back` reads B2 on the converse relation, with a converse law for steps (`«迭» («逆» R) n x y ↔ «迭» R n y x`), which the grammar also lacks and which belongs to B2.
  - The web lemma `Web.reaches_onward` (MapInstances, reading no field) already proves the positive form by its own induction. Five activity laws rest on it: `not_endless_of_gone`, `stopped_not_endless`, `generation_arises_late`, `generation_renews_late` and `keeping_of_carried_on`. Once B2 lands, `reaches_onward` is its case and those five follow.
- **Constructivity:** the double negation is the exact strength, since "no end" gives a successor only as far as can be refuted.

The review compiled B1 (both orders), B2 bounded and B2 from it, and the converse law. Each is missing from the grammar and constructive.

**(b), not proposed: the alternation of a two-valued class over a listing.**
- **The rows:** seven theorems of Decidedness (`unceasing_iff_decided`, `arising_iff_ceasing_covered`, `arising_iff_ceasing_decided`, and the four arising and ceasing that do not stop).
- **Where they come from:** each is already the instance of a field-free law of comings, with decidability from some step on, over a covering list (`coming_recurs_iff_decided`, `Recurs.coming_not_stopping`, `Recurs.ceasing_not_stopping`).
- **What the grammar lacks:** a law of the alternation of a two-valued class along lines, with pigeonhole over a listed carrier. The grammar's pigeonhole (`«线有限不并则回»`) is for one line.
- **Why not proposed:** the field-free form is already stated once, below the activity forms. Lifting it to the grammar is a separate item.

## (c) Laws of their models

- **Balance, represented (1).** `CensusWebs.keep_pace` is a central declaration (COVERAGE's dissolution row): arisings and ceasings across a stretch keep pace with the census. It rests on balance, which the grammar represents and does not derive (OU3b), as the measure reports. It is the one central declaration among the 436, so the measure does not change.
- **Field-free law below (8).**
  - Six forms of the alternation of arising and ceasing rest on balance (represented), through `balance_over_stretch_on`: `Web.arising_recurs_iff`, the covering forms, the finite world's, and the listing's. They are already proved from field-free laws of comings (`coming_recurs_iff`, `Listed.coming_of_ceasing`).
  - `Web.sample_arises` and `Web.sample_ceases` each apply the field-free `arises_within` or `ceases_within`. Read with the transitive relation "holds later, held earlier", «两端分则中有标» would also give the direction of the change, so `arises_within` is a candidate case of it. It reads no field and is outside this count.
- **Representation (63).** OU3a's instance theorems:
  - arising, ceasing, abiding, renewing, having a predecessor or successor, and lineage, read as `«生»`, `«亡»`, `«住»`, `«复生»`, `«有前»`, `«有后»` and `«相续»` at the activity, state or carrier class;
  - the map's terms on webs, with `degenerates_of_gone`, which uses reach's transitivity and `«线内同类»` only as lemmas;
  - `Web.Lineage.cons`, whose induction is the bridge's own, not replaced by `«迭»`'s first-step-first definition;
  - definitional facts of the readings.

  Their content is the correspondence.
- **Calibration (6).** Over all finite worlds, the alternation law is exactly excluded middle (`World.law_iff_em`, `law_decides`, `law_of_em`). It is also exactly the grammar's positions decided (`World.law_iff_grammar_positions`, through `«四相之定当且仅当排中»`, and `law_iff_positions`). A census law over all worlds gives LPO (`TallyWorlds.lpo_of_census_ends`).
- **Witness (141).** Facts of constructed webs, worlds and laws:
  - Accretion, Attrition, Bud, MergeClass, Confluence, Tandem, Lineage and Fork;
  - the wholes' models;
  - PatternRelay, queues and rings, Strobe, Pass, and nets.

  Six of them reach grammar laws in building their facts (the fissions and joinings, and `Map.shifted_generates`). They stay witnesses: a witness's content is its model.
- **Model (172), by kind** (read off each row's reason):
  - **Counting over lists (60).** Censuses and their balance, tallies and census tables, pigeonhole over coverings, capacities and listed webs. They read decidability, lists and numbers, which the grammar does not count.
  - **Combinations of activity (38, Wholes).** A whole active where some, every, or at least `j` of its parts are is predicate logic at each step plus counting over steps. The grammar has no union of partial identities and no count of them. Routing `Whole.arises_part` through «生于粗则生于细» would wrap its one step, not replace it.
  - **The names (20).** Re-identification laws: continuations and arising carried, activity kept both ways. WRT's design (§1.4) reads these as cases of carrying, and re-deriving them through transport would be rerouting.
  - **The index re-read (16).** Sampling, stuttering, commuting and reordering steps, and the world after `T` steps. These re-index time; the grammar's coarsening is of classes, not of the index.
  - **Inductions, definitional readings and contextual systems (38).**
    - inductions with no grammar law of their shape (`ByPassing.trace` was filed here; it is a case of closure, now (a), as `ByPassing.ends_within`, which rested on it, is a case of `«两端分则中有标»`);
    - definitional facts of the persisting, carrying and roles constructions;
    - the contextual parity systems, which read activity only through a run.

## What follows

1. **The fifteen (a) derivations.** Each is one module, statements unchanged, after its owner or rule 3's fallback:
   - closure: Retaining, Wholes, Exclusion, Reserve, PatternPassing (two) and Persistence;
   - the twins and `ends_within`: ContinuedClasses and PatternPassing;
   - the restricted bridge with `unique` and `origin`: Identity;
   - the coarse-to-fine laws: Persistence.

   The four (a), follows rows then reach the grammar unchanged.
2. **B1, B2 and the converse law, stated and reviewed in `GrammarLaws` before any lineage law bridges to them**, as OU3d was. Then `Lineage.split`, `through`, `onward` and `back`; `reaches_onward` becomes B2's case, and the five laws resting on it follow.
3. **Nothing else here is a derivation to make.** The 398 laws of their models keep their proofs; their standing is now written down, which is what OU's criterion 7 asks of every old theorem.

## What this audit does not do

- It writes no Lean for landing; the review's two checks are kept as evidence.
- It counts by the main count. The 48 theorems whose upper bound reads more fields than `active` (through packaging definitions) are marked in the table and classified like the rest.
- Theorems reading `active` together with other fields are outside this count; they are the next groups of the dependency audit.
- Modules of witnesses and counting laws were classified from their statements and definitions, not proof by proof. The review sampled them and found the closure family, now in (a). A further misread among them would most likely hide another case of closure or of a grammar law.

## The review, and what was taken

One independent read-only review by a separate AI agent, the reviewer of OU3d and OU3e ([REVIEW-OU3f](REVIEW-OU3f.md)). Every finding was taken.
1. **Closure was never considered.** Six inductions over steps are cases of it, on EC6b's precedent. They are now in (a), with the review's two compiled re-proofs. Two one-line applications of one of them follow.
2. **The Lineage bridge was false at `k = 0` and did not give `origin`.** It is now the restricted relation, true for every `k`. `unique` is from `«迭之定»` and `origin` from `«迭之定前»`, both compiled. For `split` and `through` it must fix the endpoint's step.
3. **Three (a) rows were not derivations.** `cons` is representation. `ends` and `lineages_apart` follow. The count is now 13, three of them small, and 4 follow.
4. **B2 could not serve `back`.** It is now stated bounded, with the unbounded form from it and the positive form on «不穷». `reaches_onward` already proves the positive form, and the five MapInstances rows that rested on it as "done" now follow B2. B1's order is said: `«迭之接»`'s, as its converse.
5. **A central declaration was among the 436.** `CensusWebs.keep_pace` is now "(c) balance, represented", and the claim that none is central is corrected.
6. **The field-free rows.**
   - The six that rest on balance say so.
   - The seven others are "(b), not proposed", with the reason.
   - `arising_recurs_iff`'s anchor is the Lean name `coming_recurs_iff`, and its stray "see B1" is gone.
7. **`sample_arises` and `sample_ceases`** are "field-free law below" (`arises_within`, `ceases_within`). The reason about «两端分则中有标» is corrected.
8. **The MapInstances "done" rows overstated their reach.** Five follow B2, `degenerates_of_gone` is representation, and the "GrammarMap" anchors are gone.
9. **"Small" is applied the same way** to `begins_passed`, `sheng_state_of_change` and `wang_state_of_change`.

The review also confirmed:
- the counts;
- the two genuine twins;
- the reason for keeping `trace` in (c);
- the claim about WRT2, now with its sentence on OU3a's class reading;
- the sampled modules: Wholes, Sampling, Population and ContextualRuns.

## After the twins' review (29 October 2026)

The review of the twins' derivations ([REVIEW-TWINS](derivations/review/REVIEW-TWINS.md)) found one row misfiled. `ByPassing.ends_within` is a case of `«两端分则中有标»`, as `passes_within` is, and is derived with the twins ([design](derivations/DESIGN.md)). So (a) has 14 rows and (c) model 173, and 399 of the 436 are laws of their models. The main finding stands: the general content this layer leaves to lift is small.

## After the closure review (29 October 2026)

The review of the closure derivations ([REVIEW-CLOSURE](closure/review/REVIEW-CLOSURE.md)) found one more row misfiled. `ByPassing.trace` keeps a region along the steps, so it is a case of closure, derived with the six ([design](closure/DESIGN.md)). So (a) has 15 rows and (c) model 172, and 398 of the 436 are laws of their models. `ByPassing.line_back`, a representation, is now proved by closure too, with its standing unchanged.

## After the lineage review (29 October 2026)

The review of the lineage derivations ([REVIEW-LINEAGE](lineage/review/REVIEW-LINEAGE.md)) found two corrections ([design](lineage/DESIGN.md)).
- **The bridge's endpoint step is a convenience, not a need.** The section on the restricted bridge says the bridge "must also fix the endpoint's step". It need not: with the restriction in the class position of `«续»`, `steps_advance` gives the step of the middle occurrence of split steps. The landed bridge (`Web.steps_iff_lineage`) states the endpoint's step because it saves rewrites. Its forward reading needs no bound (`Web.lineage_of_steps`).
- **Two representations are cases of grammar laws through the bridge.** `Web.Lineage.line` follows from `«迭则及»`, and `Web.line_lineage` from `«闭之及»` with `«及即迭»`. Both are now proved so, with their standing (c) representation unchanged, as `ByPassing.line_back`'s was. `Web.Lineage.cons`, the bridge read at one more first step, lost its one consumer and is retired, so the theorems reading only activity on main number one fewer than this audit's 436.

So all six lineage rows are derived:
- the two in (a), `unique` and `origin`;
- the four in (b), `split`, `through`, `onward` and `back`.

The three that follow (`ends`, `lineages_apart` and `lineage_iff_line`) reach the grammar unchanged.
