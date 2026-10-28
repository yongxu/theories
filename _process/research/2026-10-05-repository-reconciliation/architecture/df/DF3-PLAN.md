# DF3: the plan (batch A landed, study §436)

DF3 migrates to schema 2, with laws arrays, the schema-1 records that DF1's record editors named ([LEFT](LEFT.md)). Main at `5e9f14f5c` has 117 schema-1 records (every one recorded-checked); this plan takes the 30 the editors named as batch A and leaves the other 87 as batch B, to be proposed with batch A's measured cost. The editors' row numbers in [`edit-records-0.json`](reports/edit-records-0.json) and the group-1 list are indices into each group's `rows` in [`units.json`](units.json), not into `triage.json`; resolved, they name the records below.

## Batch A: thirty records

| Unit | Region | Records (declarations cited) |
|---|---|---|
| A | root | only-the-order-of-change-shows (106), normal-forms-need-decided-apartness (94), continuous-time-as-tower (12), trace-law-equivalence (9), joint-code-plan-lifting (6), finite-trace-transport (3) |
| B | root | becoming-context-coherence (44), joint-correlation-reduced-dynamics (32), derived-history-law-exactness (23), least-footprint-where-idleness-decided (22), joint-decomposition-lifting (15), finite-joining-tree-lifting (14), exclusive-footprint-support (11) |
| C | collective, map | market-partial-correction-boundary (60), market-supported-finite-transition (27), market-finite-support-obstruction (26), market-protected-continuation (19), joint-plan-composition (16), draws-on-a-shared-stock (12); growth-constrained-fragmentation (40), renewing-consuming-formation (40), control-coherence-loss (34), effective-capacity-and-eventual-reachability (25) |
| D | significance, method | classification-robust-generative-comparison (192), significance-retained-within-margin (48), metaethical-core-characterization (42), pending-task-context-applicability (21), recoverable-mediated-change (16); derivation-soundness (11), finite-basis-common-interpretation (6) |

The regions are those of `regions.json`, and the units are balanced by the declarations cited (230, 161, 299 and 336, 1,026 in all). Four of the thirty have no statement (classification-robust-generative-comparison, metaethical-core-characterization, derivation-soundness, finite-basis-common-interpretation).

## What a migration does

The steps are RESULT-WORKFLOW's "Migrating a schema-1 record":

1. `research.py snapshot <id>` stores the record's exact bytes, and its `text_versions` entry goes into the record.
2. Set `schema_version` 2, then write the record's schema-2 fields:
   - a short title and, where there is none, a statement;
   - one law per item, each with its declarations named in `references`, read against the Lean they cite;
   - `limitations` replaced by typed `does_not_show` items or `standard_boundaries` keys, the latter only where the shared sentence is true of the record;
   - `hypotheses` kept;
   - `validation_scope` within 600/260 and `next_delta` within 400/180.
3. Map every old sentence to a field, a shared key, `history` or the snapshot. Each record's mapping table goes in `df3/mapping/<id>.md`, linked from the study section, so that nothing is dropped silently.
4. Add one history note per record and refresh `reviewed_at_utc`.

This is documentary work: no Lean changes, no core checker run, and no source hash is refreshed.

## The generativity chain

Eight of the thirty are fingerprinted by the chain: derived-history-law-exactness, finite-joining-tree-lifting, growth-constrained-fragmentation, market-partial-correction-boundary, market-supported-finite-transition, pending-task-context-applicability, recoverable-mediated-change and classification-robust-generative-comparison. Following RESULT-WORKFLOW's step 5, once for the batch, the lander:

1. reads each chain entry that cites them against the migrated record;
2. records the review with `generative_chain.py --record-review` and a note in the chain's [index record](../../../2026-10-05-generative-foundation-review/root-foundation/GENERATIVITY-CHAIN-INDEX-RECORD.md);
3. lists any entry whose text would need to change as a proposal, not an edit, because the chain is the curated argument.

The chain's other 135 changed sources and 19 new pages since 20 October are its own whole-chain review, outside DF3.

## How

1. **Migration.** For each unit, one migrator writes the migrated records and mapping tables as files, reading every law against the current Lean and its receipt. A skeptical reviewer per unit then checks each law, each typed boundary and each mapping row.
2. **Landing.** The lander applies the findings by script, and a cold read by two readers checks the applied state.
3. **Checks and record-keeping.** Render, check (with `lint --ids`), links and test are run, and the chain review is done once. The study section, board, LEFT and DEFECTS-FOUND get the outcome.

That is ten agents. The land goes through the queue like DF2's.

recurrence-without-selector-revision can come along: a rerun of BoundaryModels' checker binds its current bytes and makes it recorded-checked.

## Cost

DF2, measured: 8 agents, 2.39M subagent tokens and 101 minutes for drafting and review of 30 new records; the cold read took 2 agents, 0.63M tokens and 25 minutes. Batch A is of the same size and simpler work, because the content is already in the statements and claims:

| Item | Estimate |
|---|---|
| Subagent tokens | about 2.5–3.5M |
| Time to landing | about 3–4 hours |

Batch B (87 records: knowing 36, root 16, significance 14, map 8, life 8, method 4, collective 1) has these features:

- 46 of its records have no statement;
- 33 are fingerprinted by the chain;
- they cite 3,301 declarations.

That is about three times batch A, so about 8–10M tokens in three region batches. It is proposed after batch A lands, with A's numbers per record. Once both batches land, the register has one schema and the tools' schema-1 paths can go.

## Not in DF3

- **The two renames** (selection-under-registration-revision, formed-copying-registration) wait on the chain's maintenance record.
- **The owners' items in LEFT** stay with their owners.

## Batch A, measured

Batch A landed on 28 October 2026 (study §436). Two figures differ from the estimates above:

- **Agents:** ten in all: four migrators, four reviewers, two cold readers.
- **Subagent tokens:** 4.3M (3.46M for migration and review in 75 minutes, 0.87M for the cold read), more than the 2.5–3.5M estimated.

At that rate, batch B (87 records) would take about 12–13M tokens in three region batches.
