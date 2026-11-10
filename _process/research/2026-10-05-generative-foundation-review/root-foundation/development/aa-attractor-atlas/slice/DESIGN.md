# AA's slice of world contact on families C and D: the design

*AI-written, 10 November 2026. It follows the map-structures joint reading (MS) §2.3 and §7, steps 3 and 4. Ren said yes to about four agents.*

The slice adds two entry files beside the atlas's dynamics. It is new files only: `dynamics.json` gets no new field and no new writer.

## 1. Bindings: `theories/becoming/results/atlas/entries/bindings.json`

There is one entry for each row of the tests table (`theories/becoming/results/data/tests.json`) that bears on a dynamic of family C or D. A row bears on a dynamic where its frozen predictions read a law, a record or a mechanism of that dynamic.

```json
{
 "test": "LA2",
 "bears_on": [
  {"dynamic": "closed-capture", "records": ["closed-capture"], "laws": ["Becoming.ClosedCapture.turned_by_loss"],
   "how": {"en": "what the test reads of the dynamic: the law or mechanism its predictions are about"}}
 ],
 "binding": {
  "kind": "run",
  "target": {"records": ["closed-capture"], "laws": ["Becoming.ClosedCapture.lock_outlives_loss"],
             "conclusion": {"en": "the law's conclusion the test reads, in the account's words"}},
  "roles": [{"role": {"en": "the pool of readers"}, "as": {"en": "the judge trained on the loop's own selections"}}],
  "premises": [{"premise": "closedcapture-unread", "assessed": "failed",
                "how": {"en": "how the test shows it met, failed, or leaves it unchecked"}}],
  "observed": {"en": "what was observed and how it was measured"},
  "result": {"en": "what came out, by the test's frozen rules"},
  "marks": "the binding",
  "marks_why": {"en": "where the outcome bears: on the law, on a premise of the identification, on the measurement, or nowhere"},
  "alternative": {"en": "another explanation of the outcome"},
  "source": "experiments/self-rewarding-lock/README.md#…"
 }
}
```

The fields:
- **`test`:** the row's `id` exactly as the table has it, for example `LA4 (Stage A)` or `IN1 (round 1)`. One entry per row.
- **`bears_on`:** at least one dynamic of family C or D, by atlas id. Each item carries:
  - `records`: the records through which the row bears, each among the dynamic's own records;
  - `laws`: the laws it reads, declared in the live Lean, `[]` where it reads a mechanism and no single law;
  - `how`: what the row reads of the dynamic.

  A row bearing on a dynamic outside C and D lists only its C and D dynamics; a note for the others is out of scope.
- **`binding`:** present only where the row has a result: the outcome is not `not-run`, `held`, `dropped`, `refused`, `no-prediction` or `registered-rule`. Its fields:
  - `kind`: `model` (a constructed model), `run` (a run of a trained or simulated system) or `field` (records of actual histories). A model is never read as evidence about the world.
  - `target`: the records and laws whose conclusion the row reads, and that conclusion in words.
  - `roles`: each role of the law (the pool of readers, the share, the rule, the loss beyond the share, …) and what plays it in the test.
  - `premises`: each premise of the ledger (`entries/premises.json` id) that the identification needs, taken by a law of a dynamic the row bears on, with `assessed` one of `met`, `failed` or `not checked`. `how` says on what the assessment rests, the test's README or data, with a quote where there is one.
  - `observed`: what was observed and measured. `result`: the outcome by the frozen rules, as the README says it.
  - `marks`: where the outcome bears. It is one of:
    - `nothing failed`: no frozen verdict failed;
    - `the law`: a prediction the law makes, under premises met, failed;
    - `the binding`: a premise of the identification failed, so the outcome does not reach the law;
    - `the measurement`: what was measured did not measure the role.

    `marks_why` says why. LA2 is the design's example: every frozen verdict passed, and the bridge "the judge is a pool of readers counting by kind" failed. The outcome marks the binding, not the law, and it supports nothing beyond it.
  - `alternative`: another explanation of the outcome the README or the readers name, or one the binder sees.
  - `source`: the README section the binding is read from, as `path#anchor`.

Nothing in a binding is new evidence: it says how a test the account ran meets the map. Where the README does not say something, the binder writes `not checked` or says it is not said. It never fills the gap.

## 2. The situation: `theories/becoming/results/atlas/entries/situations.json`

There is one entry: the reward-model pipeline, written in the account's own words.

```json
{
 "id": "a-reward-model-pipeline",
 "name": {"en": "A reward-model pipeline"},
 "kind": "model",
 "standing": "reading",
 "summary": {"en": "two or three sentences"},
 "formations": [{"id": "policy", "en": "the policy being trained"}, …],
 "conditions": [{"id": "rater-attention", "en": "…"}, …],
 "couplings": [{"from": "policy", "to": "users", "en": "the policy's outputs reach users"}, …],
 "readers": [{"id": "reward-model", "reads": ["…"], "drawn_from": {"en": "…"}}, …],
 "rule": {"en": "what the rule (the reward) forms from, and how it is read"},
 "time": {"en": "the steps: rounds of rating, of training, of deployment; what is read when"},
 "dynamics": [{"dynamic": "closed-capture", "as": {"en": "how it acts here"},
               "roles": [{"role": {"en": "the share"}, "as": {"en": "…"}}]}],
 "premises": [{"premise": "…", "assessed": "met|failed|not checked", "why": {"en": "…"}}],
 "exits": [{"dynamic": "closed-capture", "exit": 1, "open": "open|closed|not read", "why": {"en": "…"}}],
 "bears": [{"who": {"en": "…"}, "what": {"en": "what it bears, and through which dynamic"}}],
 "sources": ["theories/becoming/results/records/coupling-closures-of-training-pipelines.md#…", …]
}
```

- **`kind`:** `model`. The pipeline is written as a model of published pipelines, read against the account; it is not a record of one pipeline's run.
- **`standing`:** `reading`, from the vocabulary's standings without record. A situation is a reading of how the map meets a case, not a result.
- **`formations`, `conditions`, `couplings`, `readers`:** the situation's own graph, with ids unique within it.
  - A coupling runs `from` a formation or condition `to` one: what the first does reaches the second.
  - A reader is a formation (by id) that reads, `reads` lists formation or condition ids, and `drawn_from` says from whom its reading is drawn.
- **`rule`, `time`:** in words.
- **`dynamics`:** each atlas dynamic, of C or D, that acts in the situation, with the roles of its laws.
- **`premises`:** each premise taken by a law of a listed dynamic that the situation meets, fails or leaves unchecked, with why.
- **`exits`:** each exit of a listed dynamic, by its 1-based index, and whether the situation leaves it open, closed or not read.
- **`bears`:** who bears what the situation selects, and through which dynamic. This is the ethics as seeing: what a course draws on, what it closes, and who bears it.
- **`sources`:** the records and readings it is written from.

### What the checker computes

`atlas.py` checks every reference: dynamics, exits by index, premises (each one taken by a law of a listed dynamic), records, and ids within the situation. From the situation's own graph it then computes, for each reader:
- **its closure:** the formations and conditions with a path of couplings into the reader, the reader included;
- **what its acts reach:** the formations and conditions with a path of couplings from the reader;
- **what lies beyond it:** what its acts reach and its closure does not hold. By `Flow.unselected_beyond_pool` and `BeyondCoupling`, a selection read through it cannot tell these apart, under those laws' premises, which the situation assesses.
- **what it reads among those it selects:** the formations it both reads and selects (`selects`, below). Where that set is not empty, its reading is drawn from the selected (02, readers drawn from the selected).

For that, a reader may carry `selects`: the formations its reading selects among. The computed sets are only as right as the couplings written, so write every coupling the sources give, and none they do not. The situation has no field of its own for what lies beyond; the checker computes it.

## 3. The pages

- **`BINDINGS.md`:** each binding, in full. Above them, a matrix of the C and D dynamics against the rows that bear on them, each cell the outcome and where it marks.
- **`SITUATIONS.md`:** the situation, with its graph drawn as a list or table, the computed sets, and its dynamics, premises, exits and who bears what, each linked.
- **The family pages:** each C or D dynamic gets a line, "Tests that bear on it", linking the bindings.
- **ATLAS.md and JOINS:** one line each. JOINS's count, "Tests whose row names a record or a dynamic", becomes the count of rows with a binding entry.

## 4. Who does what

- **The binder of the tests:** reads the tests table, the READMEs and the C and D dynamics, and writes `bindings.json`.
- **The writer of the situation:** reads the two records on training pipelines and alignment approaches (07's assessments), TERRAIN, PREMISES and the C and D family pages, and writes `situations.json`.
- **A checker, set to refute both:** reads every binding against its README and every situation claim against the atlas and the records.
- **A fresh reader of the result.**

The session folds their files in, validates and renders.
