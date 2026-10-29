# OU3f: the theorems that read only activity, audited

AI-written audit for board item OU3f, 29 October 2026, on main at `3e9a856b6`. Source: OU plan §八 step 4, its second part, which lifts the theorems that read only `active` after the central declarations; the board row also sets the decisions below. The audit uses no Lean. Each theorem gets one of three standings:
- **(a)** the grammar law it is a case of at the occurrence model, where activity is a partial identity ([WRT's design](../world-representation/DESIGN.md), §1.3), with the derivation that puts it below that law (board rule 9);
- **(b)** a law the grammar lacks that several theorems share, written out;
- **(c)** a law of its model, with the reason.

A row counts as (a) only where the grammar law would replace part of the proof: applying a law and then undoing it is no derivation (the test that caught `PartForms.goAlike`, [OU3d's review](../ou3d-step-indexed-reaching/REVIEW-OU3d.md), *Second pass*). Instance theorems that only connect a notion to its grammar term, as OU3a's do, are representation (c), not derivations. Every theorem's row is in [TABLE.md](TABLE.md); this note gives the argument.

## Method

- **The recount.** The dependency audit's tool ([audit](../one-unfolding-root/audit/REPORT.md)) was run on main. `dump.py` restored the compiled modules from the step cache without compiling. A copy of `audit.py` was run outside the repository, since in place it writes over the tracked `REPORT-DATA.json`; the copy differs only in its root path. It was run on 338 modules and 16,484 theorems, with the sources matching the commit.
- **The count.** 436 theorems read only `active` by the main count, and 388 of them by the upper bound as well. On `0cc1aafb4` there were 348; the spine has grown since. The recount's data are kept in `data/` (`active-only.json`; `REPORT-DATA-recount.json`).
- **What a proof reaches** (`kit/reach.py`). For each theorem, the grammar theorems (constants named with «», of kind theorem) that its proof reaches were read off the dump, directly and transitively (`data/reach.json`). Thirty proofs reach one, fifteen directly. Seventy-four statements name a grammar term; most of those are representation theorems.
- **The classification.** Each theorem's printed statement was read from the checker's signature audit (`kit/statements.py`), and its proof was read where a grammar law was a candidate (`kit/source.py`).
  - Modules of witnesses and of counting laws were classified by their statements and the definitions they unfold. The review sampled them.
  - Two kinds of claim were checked mechanically against the dump: every "already derived from a field-free law" row depends on the law named, and every "(a), done" row reaches a grammar theorem. The check found ten anchors named wrongly; they were corrected to the laws the proofs use.

## Summary

| standing | theorems | what it says |
|---|---|---|
| (a) | 10 | a grammar law replaces part of the proof; the derivation is written below |
| (a), done | 16 | the proof already reaches the grammar law it is a case of |
| (b) | 4 | two laws the grammar lacks, B1 and B2, shared by four lineage laws |
| (c) representation | 61 | an instance theorem reading a notion as its grammar term, or a definitional fact of the readings |
| (c) field-free law below | 13 | already the instance of a law that reads no field (the comings and goings of a predicate along steps); that law is not a grammar law |
| (c) calibration | 6 | the logical strength of a law over all worlds (excluded middle, LPO) |
| (c) witness | 141 | a fact of one constructed web, world or law |
| (c) model | 185 | a law of the model, reason by kind below |

So 26 of the 436 are cases of a grammar law, 16 already derived, and 4 wait on two laws the grammar does not state. The other 406 are laws of their models, read on the grammar where a representation theorem applies.

## (a) Cases of a grammar law, with derivations

All ten live on webs, at the occurrence carrier `Nat × F` that OU3a's instance theorems already use (`Web.continuationStep`, `Web.activityClass`). So they need no new model: WRT2's occurrence model represents the World, and these laws are the web's.

### Three proved twice: rule 9 retires the direct proof

The module already proves each of these statements twice, once directly and once from a grammar law. Rule 9 keeps the derivation; the direct proof goes, and one of the two names is retired or kept as the other's alias.

| theorem | its grammar twin | the law |
|---|---|---|
| `Web.Continuing.mono` (ContinuedClasses) | `Continuing.mono_by_reach` | `«及之单调»`: reach grows with the relation, read through `continuing_iff_line` |
| `Web.ByPassing.begins_passed` (PatternPassing) | `ByPassing.begins_passed_by_grammar` | `«生于细而续于粗则异»`: born in the finer class and continued in the coarser, the step alters |
| `Web.ByPassing.passes_within` (PatternPassing) | `ByPassing.passes_within_by_line` | `«两端分则中有标»`: a line whose ends lie apart in a class has a marked step, in place of the induction of `ByPassing.trace` |

Each twin was read to check that the law carries content. In `passes_within_by_line`, the law replaces the induction along steps that `trace` performs. In `begins_passed_by_grammar`, it replaces the contradiction from the arising by the alteration of the step. Neither applies a law and undoes it.

### Five lineage laws through one bridge to `«迭»`

`Web.Lineage R M g k h` (Identity) is `k` steps of continuation within activity from `(M, g)`, taken last step last. One bridge relates it to the grammar's steps:
- **The bridge:** `Lineage R M g k h ↔ W.active M g ∧ «迭» («续» (continuationStep R) W.activityClass) k (M, g) (M + k, h)`.
- **How it is proved:** by its own induction, through `«迭之末步»`, as OU3e's `chain_iff_steps` was.

Through it:

| theorem | the law | what it replaces |
|---|---|---|
| `Web.Lineage.unique` | `«迭之定于»`: with the successor fixed at what `x` reaches, `n` steps lead to one occurrence | the induction on `k`; no split within activity from `M` on is the fixed successor at what `(M, g)` reaches |
| `Web.Lineage.origin` | `«迭之定前»`: merging nothing, `n` steps to one occurrence come from one | the induction on `k`, at the relation restricted to steps from `M` on (no merge is given only there) |
| `Web.Lineage.cons` | `«迭»`'s own first-step-first composition (`«迭之接»` at one step) | the induction that rebuilds a first step on a last-step-last lineage |
| `Web.Lineage.ends` | from `unique` and `through` (B1) | a lineage reaching a ceasing has no longer continuation |
| `Web.lineages_apart` | from `origin` and `split` (B1) | merging nothing, a lineage from an earlier formation never meets one arising later |

`ends` and `lineages_apart` need B1 as well, so they can land with B1 or after it.

### Two coarse-to-fine laws

| theorem | the law | what it replaces |
|---|---|---|
| `Web.sheng_state_of_change` (Persistence) | `«生于粗则生于细»` | A change of activity begins the activity class's line, and the state class is finer (`stateClass_finer`). The law replaces the step from "alike in the state class" to "alike in activity", as its sibling `arises_of_persisting_arises` already does. |
| `Web.wang_state_of_change` (Persistence) | `«亡于粗则亡于细»` | the dual, as `ceases_of_persisting_ceases` already does |

These two are small: what remains after the law is the representation of a change as a beginning.

## (a), done: already derived

These sixteen proofs already reach the grammar law they are cases of:
- `Web.Continuing.mono_by_reach` reaches «及之单调».
- `Web.ByPassing.begins_passed_by_grammar` reaches «生于细而续于粗则异».
- `Web.ByPassing.passes_within_by_line` reaches «两端分则中有标» and «线内同类».
- `Web.arises_of_persisting_arises` reaches «生于粗则生于细».
- `Web.ceases_of_persisting_ceases`, `Web.ceasesFrom_of_unconditioned` and `Web.ceases_of_pattern_ends` reach «亡于粗则亡于细».
- `Web.merge_candles` reaches «蜡烛之合».
- `Web.active_along_line` reaches «线内同类».
- Six MapInstances laws reach the map's laws: `degenerates_of_gone`, `not_endless_of_gone`, `stopped_not_endless`, `generation_arises_late`, `generation_renews_late` and `keeping_of_carried_on`.
- `Web.dissipation_arising_not_recurring` reaches the law of rest «尽则不或屡», through `falls_not_recurring` and `Amounts.rests` (OU3b).

## (b) Laws the grammar lacks

Four lineage laws need two laws the grammar does not state. Both belong beside `«迭»` in `GrammarLaws`' finite-runs section, as OU3d's laws do.

**B1, `«迭之分»`: steps split.**
- **Statement:** `«迭» R (m + n) x z → ∃ y, «迭» R m x y ∧ «迭» R n y z`.
- **What it is:** the converse of `«迭之接»`, which composes steps but has no split.
- **Its uses:** `Web.Lineage.split` (`j + i` steps split into `j` and then `i`) and `Web.Lineage.through` (with `«迭之末步»`). Through those, `Lineage.ends` and `lineages_apart` use it too.
- **Elsewhere:** `Withholding.Chain.prefix` and the trace prefixes in the trace modules are of the same shape. They read no field and are outside this count.

**B2: where nothing reached ends, steps of every length, as far as can be refuted.**
- **Statement:** `(∀ y, «所闭» R x y → ¬¬ ∃ z, R y z) → ∀ n, ¬¬ ∃ y, «迭» R n x y`.
- **What it is:** where no occurrence `x` reaches lacks a successor, refutably, there are `n` steps for every `n`, as a double negation.
- **Its uses:** `Web.Lineage.onward` (with nothing ceasing from `N` on, a lineage of every length exists) and `Web.Lineage.back` (with nothing arising from `M` on, every active formation at `M + k` has a lineage back to `M`). `back` uses B2 read on the converse relation, with a converse law for steps (`«迭» («逆» R) n x y ↔ «迭» R n y x`), which the grammar also lacks; it is part of B2.
- **How it is proved:** by its own induction on `n`. The double negation is the exact strength, since "no end" gives a successor only as far as can be refuted.

## (c) Laws of their models

- **Representation (61).** OU3a's instance theorems:
  - arising, ceasing, abiding, renewing, having a predecessor or successor, and lineage, read as the grammar's `«生»`, `«亡»`, `«住»`, `«复生»`, `«有前»`, `«有后»` and `«相续»` at the activity, state or carrier class;
  - the map's terms on webs;
  - definitional facts of the readings, such as classes being classes, one class being finer than another, and arising from the identity being arising.

  Their content is the correspondence. Re-deriving one through the grammar would be rerouting.
- **Already the instance of a field-free law (13).** The alternation of arising and ceasing (`Web.arising_recurs_iff` and the forms over coverings, finite worlds, decidability from some step on, and listings) is already proved from laws of the comings and goings of a predicate along steps (`coming_recurs_iff`, `coming_recurs_iff_decided`, `Recurs.coming_not_stopping`, `Recurs.ceasing_not_stopping`, `Listed.coming_of_ceasing`). Those laws read two values, decidability and a covering list. No grammar law states them, and lifting them would need a law of two-valued classes along a line, which the grammar's relational laws do not give. They are listed here, not under (b): one family states them once already, below the activity forms.
- **Calibration (6).** Over all finite worlds, the alternation law is exactly excluded middle (`World.law_iff_em`, `law_decides`, `law_of_em`). It is also exactly the grammar's positions decided (`World.law_iff_grammar_positions`, through `«四相之定当且仅当排中»`, and `law_iff_positions` on the steps of predicates). A census law over all worlds gives LPO (`TallyWorlds.lpo_of_census_ends`).
- **Witness (141).** Facts of constructed webs, worlds and laws:
  - Accretion, Attrition, Bud, MergeClass, Confluence, Tandem, Lineage and Fork;
  - the wholes' models (Generations, Rafters, and others);
  - PatternRelay, queues and rings, Strobe, Pass, and nets.
- **Model (185), by kind** (read off each row's reason):
  - **Counting over lists (61).** These span:
    - censuses and their balance (the prelude's stretch balance, represented, not derived);
    - tallies and census tables;
    - pigeonhole over coverings;
    - capacities and listed webs.

    They read decidability, lists and numbers, which the grammar does not count.
  - **Combinations of activity (39, Wholes).** A whole active where some, every, or at least `j` of its parts are is predicate logic at each step plus counting over steps. The grammar has no union of partial identities and no count of them. Routing `Whole.arises_part` through «生于粗则生于细» would wrap its one step, not replace it.
  - **The names (21).** Re-identification laws, such as continuations and arising carried, activity kept both ways, and naming steady on held stretches. WRT's design (§1.4) reads these as cases of carrying, and re-deriving them through transport would be rerouting.
  - **The index re-read (17).** Sampling, stuttering, commuting and reordering steps, and the world after `T` steps. These re-index time. The grammar's coarsening is of classes, not of the index. «两端分则中有标» would find a change within a sampled stretch but not its direction, so it does not replace the search.
  - **Inductions over steps, definitional readings and contextual systems (47).** These are short inductions with no grammar law of their shape (`ByPassing.trace`, `active_before`, `inactive_of_not_arising`), definitional facts of the persisting, carrying and roles constructions, and the contextual parity systems, which read activity only through a run.

## What follows

1. **Proposals with no new law (ten rows).** Each is one module, statements unchanged, after its owner or rule 3's fallback:
   - ContinuedClasses: retire `Continuing.mono`'s direct proof.
   - PatternPassing: retire `begins_passed`'s and `passes_within`'s direct proofs.
   - Persistence: re-prove `sheng_state_of_change` and `wang_state_of_change`.
   - Identity: the bridge from Lineage to `«迭»`, then `Lineage.unique`, `origin` and `cons`; and `ends` and `lineages_apart` once B1 lands.
2. **B1 and B2, stated and reviewed in `GrammarLaws` before any lineage law bridges to them**, as OU3d was. Then `Lineage.split`, `through`, `onward` and `back` follow from them.
3. **Nothing else here is a derivation to make.** The 406 laws of their models keep their proofs; their standing is now written down, which is what OU's criterion 7 asks of every old theorem.

None of these theorems is a central declaration, so the measure does not change.

## What this audit does not do

- It writes no Lean, and it proposes no derivation before the review.
- It counts by the main count. The 48 theorems whose upper bound reads more fields than `active` (through packaging definitions) are marked in the table and classified like the rest.
- Theorems reading `active` together with other fields are outside this count; they are the next groups of the dependency audit.
- Modules of witnesses and counting laws were classified from their statements and definitions, not proof by proof. A misread among them would most likely hide a case of a grammar law, so the review is asked to sample them.
