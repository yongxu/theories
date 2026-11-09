# Naming study: "registration" and the learning vocabulary

17 October 2026. AI-authored study, no renames. It answers Ren's observation that "registration is a dualist word, and this nudged the whole vocabulary into a very western way", and his go to "decompose registration and the learning vocabulary into structural relations, propose en/zh candidates, test them against the theorems, no renames yet" ([source](../../../../sources/15-codex-theory-conversations/2026-10-17-registration-dualist-vocabulary.md)). The quoted words are provenance; the analysis and every proposal below are the AI's.

Scope: no Lean, no result ID, no record, chapter or module text changed. **Decided 18 October 2026** (section 7): Ren agreed with the candidates as proposed and with option (b) for 识; still no renames. Lean is cited at main `f36a93aaa` (canonical files under `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`). Counts are over those canonical files and over `theories/becoming/results/records/*.json`, excluding check receipts.

## 1. Diagnosis

"Register" names a relation by one side's act of writing down the other: an instrument, a ledger or an office records an object already standing outside it. Taken as the primitive of knowing, it presupposes the two separate relata the [one relational unfolding](../../../../theories/becoming/chapters/08-METHOD.md#one-relational-unfolding) is meant to differentiate rather than assume, and its everyday senses (a registry, enrolment with an authority) are the social words the [10 October naming rules](../../../../sources/15-codex-theory-conversations/2026-10-10-zero-axiom-part-and-names.md) put last. The terms that grew around it complete the frame: *learner*, *target*, *hypothesis*, *claim*, *refutation*, *identification in the limit*, *belief*, *a learner given the world*, *options*. This is the Gold–Popper line and decision theory: a knower facing an external world that answers it.

The Lean is less dualist than its words. Every use resolves into a few relations that are already in the core's vocabulary: a map out of the configuration and the lumping it induces, a directed coupling of a level into a formation (by threshold or by level), the classes of histories that go alike through those couplings, and the prefix of a course. The study's claim is narrow: **the theorems state relations within one unfolding; the words add an observer the statements do not contain.** Where a word says more than its Lean (for example `Belief`, a set of histories, or "a learner given the world", which omits the start configuration it is built from), that is an exactness failure as well as a framing one.

Scale: `regist…` occurs about 2,090 times in 64 core and periphery modules; 识 occurs in 180 of 229 records, 学习者 in 95, 否证 in 115, 目标 in 150.

## 2. What "registration" names in the Lean: seven senses

| Sense | Lean | What the definition is |
|---|---|---|
| S1. A map out of the configuration | `Law.registered next o` (Unfolding: the frame whose claims are `o s = r`); `reg` in `Learnable`, `Parting`, `Identification`; "registered course" `Learnable.course next reg s n = reg (orbit next s n)` | a function `S → R`; the theorems use only the partition it induces, i.e. the lumping `Learning.Lumped` already names |
| S2. What couples into a formation | `Web.Registers obs g c := W.DependsOn g c ∨ obs g c` (Testing); `RegistersAt` (TimedResponse: `requires s g c ∨ obs g c`) | a directed coupling of condition `c` into formation `g`, of two grains: by threshold (`DependsOn`: only whether the need is met passes) and by level (`obs`: the level passes) |
| S3. Histories alike through those couplings | `Web.RegistersAlike`, `RegistersAlikeUpTo`, `RegistersAlikeAll` | two level histories leave `g`'s support met alike (`Admits`) and its level-coupled conditions equal, at a step or up to it |
| S4. The closure of S2 under exchange | `Flow.RegisteredFrom`, `Flow.WithinRegistration` | `h` exchanges with a condition coupled into `g`; the closure of that relation |
| S5. The class of histories alike with the actual one | `Web.Belief`, and `Web.Refutes` / `RefutesWithin` (no history meeting a claim is alike up to `t`) | an equivalence class and its disjointness from a claim |
| S6. A relation respecting claims | `Likeness.Registers claims E` | `E`-related descriptions realize the same claims: a congruence, unrelated to S2 (the docstrings note the clash) |
| S7. Local senses | `Keeping.registers` / `registered` / `blind` (the value a step keeps); `Description.Negation.register` (the negation's course); `Revision.registration` (the link-and-response process); `ReferencePlan.registered` (alike on installed addresses); `Response.RespondsThroughRegistration` (the rest responds alike where alike through its couplings) | each a specific map, process or premise |

One English word thus covers a map, a coupling, an equivalence of histories, a closure, a congruence and several local constructions; S2 and S6 share a Lean name with unrelated meanings. That is a reason for renaming independent of the framing.

## 3. Decomposition into structural relations

1. **Map and lumping (S1).** A map `π : S → K` lumps the configurations it sends alike. "What is registered" is the value of the map; "the registered future" is the course through the map. Nothing in S1 is a recorder: the map is one relation of the configuration to a coarser one.
2. **Directed coupling (S2).** A condition couples into a formation when the formation's course depends on it. The grain matters and must be kept: by threshold only one difference passes (need met or not, `Web.alike_of_threshold`), by level every difference of the level passes (`Web.observed_level_registers`). Coupling is directed: `c` into `g`, not `g` into `c`.
3. **Alike through the couplings (S3, S5).** Histories go alike through `g`'s couplings when nothing that couples into `g` differs between them. The "belief" is the class of histories alike with the actual one; "refuted" is "excluded by that class".
4. **Coupling closure (S4).** The closure under "exchanges with a condition coupled into". It contains the influence closure of `Becoming.Feedback` and equals it where coupling is by threshold only (`Flow.withinRegistration_supportOnly`).
5. **Factoring through (selection).** A selection, score or response through `g`'s registration is one that factors through the classes of item 3 (`Learning.Through`: alike items are selected alike).
6. **Learning (the `Learning`, `Learnable`, `Identification`, `Parting` family).** A *prefix* of a course (`Learning.record o t`, the values before `t`, latest first); an *extrapolation* (`pred : List O → Option O`, a map from prefixes to a proposed value or silence); a *miss* (`Refuted`: a proposed value differs from the value that comes); *accord* (`Holds`: misses at no step); a *feature* of the configuration (`val : S → V`, the "target"); *rest in accord* (`Rests`: proposing the feature's value at every step from some step on); a list of *candidate* extrapolations (`H`, the "hypotheses") and the extrapolation that moves to the next candidate at each miss (`learner H`, "the learner by refutation"); and extrapolations *built from* the process, its listed moves and configurations and the start (`Parting.worldLearner`) or from the law, map, feature and list of configurations (`Learnable.withWorld`), "the learner given the world".

Read this way, the learning theorems say how far a part of the unfolding can come into accord with a feature of it through what couples into it. No separate knower or external world enters any statement.

## 4. Candidates

Tests applied to each candidate:

- **T1 exact:** the theorems restated with it mean exactly their Lean statements (section 5).
- **T2 relational:** it names a relation in the unfolding and presupposes no separate subject, external world, authority or chooser.
- **T3 no clash:** it does not already mean something else in the core (checked by search of the canonical files).
- **T4 grain kept:** it keeps direction, threshold versus level, and loss.
- **T5 parity:** English and Chinese say the same.

| Current | Candidate (en) | Candidate (zh) | T1–T5 notes |
|---|---|---|---|
| registration (S1, a map) | the map; its **lumping** | 映射；**归并** | T3: `Lumped`, `Lumping` already mean this. T5: 归并 is in use (16 records). |
| registered course / future | the course **through the map**; same future through the map | 经映射的历程；经映射未来相同 | T1 passes for `learnable_iff` and `world_right_iff`. |
| `Law.registered` | the law **framed by a map** (`Law.frameBy`) | 律经映射之框 | T1: the definition is a frame whose claims are the map's values. |
| registers (S2) | **couples into** (condition into formation), **by threshold** / **by level** | **耦合入**；经阈 / 经水平 | T3: `Loops.Couples` (a level of `d` coupled into `c` with positive strength) is the same concept at the grain of conditions. "Coupling" also matches `Observation.readCouplings`. Adoption needs the check in section 6.2. T4: say "into" every time, since coupling is directed. |
| `obs` / observes; `supportOnly` | coupled **by level**; coupling **by threshold only** | 经水平耦合；仅经阈耦合 | T2: removes the observer. T4: keeps the two grains. |
| registers alike (S3) | **alike through `g`'s couplings** (`AlikeThrough`) | 经 g 之耦合无别 | T3: `AlikeTo` is taken; `AlikeThrough` is free. |
| registration closure (S4) | **coupling closure** (`WithinCoupling`, `CoupledFrom`) | 耦合闭包 | T3: "reach" is taken by `Frame.Reach` (reachability), so it is avoided. |
| belief (S5) | **the class alike through `g`** (`ClassThrough`) | 经 g 无别之类 | T1: `Belief` names a mental state the Lean (a set of histories) does not contain. |
| refutes (web) | **excludes** (`Excludes`, `ExcludesWithin`) | **排除** | T1 passes for `Refutes.not_of_alike`, `belief_refutes_iff` and `tail_unrefuted`. |
| `Likeness.Registers` (S6) | **respects the claims** (`RespectsClaims`) | 保持断言 | T1: it is a congruence. T3: removes the S2 clash. |
| local senses (S7) | `keeps`, `keepsBit`, `keepsNothing`; `negationCourse`; `linkProcess`; `alikeOnInstalled`; `RespondsThroughCoupling` | 存；否定之历程；联结过程；装入处无别；经耦合而应 | Each named after its definition. |
| record (`Learning.record`) | **prefix** | **前段** | T3: `Feedback.prefix_does_not_decide` already uses "prefix" in this sense. "Record" remains for the entropy sense (history kept in the conserved amount), which ends an overload. "Trace" is taken (`Frame.Trace`, admissible paths). |
| learner / claim (`pred`) | **extrapolation**; it **proposes** a value or **stays silent** | **外推**；提出 / 默 | T2: a map, not an agent. "Continuation rule" is avoided because it clashes with the continuation condition. "Silent" already appears ("the bound buys silence"). |
| refuted (`Refuted`, `RefutedAt`) | **misses** | **不合** | T1 passes. |
| holds (`Learning.Holds`) | **accords** (misses at no step) | **相合** | T3: 相合 appears in 6 records in a compatible sense. |
| target (`val`) | **feature** (of the configuration) | **特征** | T2: no aim implied. |
| rests (on the target) | rests **in accord** with the feature from a step on | 从某步起与特征相合（静） | Keeps the rest-step vocabulary (2N − 1). |
| hypotheses `H`; learner by refutation | **candidates**; extrapolation **by elimination** | 候选；**逐除外推** | T1 passes for `index_le_of_holds` and `refutations_not_recurring`. |
| learner given the world | extrapolation **built from the process** (moves, configurations, start); **built from the law** (map, feature, configurations) | 依过程所建之外推；依律所建之外推 | T1: the current wording omits the start configuration and the listing that the construction uses. |
| identification (Gold sense) | **fixing**: a bounded prefix fixes the course | **定** | T3: "fixes" is already used (`Experiment.Fixes`, the records' statements). `IdentifiesAlike` (equating) is structural and stays. |
| learnable | kept, defined as: some extrapolation from prefixes through the map rests in accord with the feature from every configuration | 可学（学得） | 学 is a process word, not an agent. Only the noun "learner" is dropped. |
| options; model of the options | alternatives; a map of the alternatives; selection **factors through** it | 备择；备择之映射；经之分解 | T3: `Experiment.FactorsThrough` and `Learning.Through` have this sense. The title Ren approved on 16 October is provenance; the change is offered, not required. |
| 识 | not the structural primitive (see section 6.3) | — | — |

## 5. The theorems restated

Each row restates a theorem in the candidate words and checks it against its Lean statement (T1).

| Theorem | Current wording | Restated | Verdict |
|---|---|---|---|
| `Learning.no_record_fixes_next` | no record fixes what comes next; a claim from the record is not right on both | **no prefix fixes the next value**: for two values, two courses share the prefix before `t` and take one and the other at `t`; a value proposed from the prefix misses on one of them | exact |
| `Learning.diagonal_refutes` | "Every claim is answered": on the diagonal course every claim is refuted | on the diagonal course every proposed value misses at its step | exact; "answered" adds a dialogue the Lean lacks |
| `Learning.index_le_of_holds`, `refutations_not_recurring` | the learner by refutation never passes a hypothesis that holds; refutations do not recur | the extrapolation by elimination never passes a candidate that accords; its misses do not recur at arbitrarily late steps | exact |
| `Identification.leastBound_exact` | the learner by the least bound is right from 2N − 1 on | the extrapolation by the least bound proposes the next value at every step from N + N − 1 on, wherever every moment is one of the states of the first N moments (at most N states) | exact |
| `Learnable.learnable_iff` | some learner rests on the target exactly where configurations with the same registered future have targets agreeing from some step on (the learner of the second direction is given the world and the target) | some extrapolation from prefixes through the map rests in accord with the feature from every configuration of a listed world exactly where configurations with the same future through the map have features agreeing from some step on; the second direction's extrapolation is built from the law, the map, the feature and the list | exact |
| `Learnable.still_learnable_iff_lumped` | under a still law, what can be learned through a registration is exactly what goes alike across it | under a law that changes nothing, a feature can be come into accord with through a map exactly where it goes alike across the map's lumping | exact |
| `Learning.goAlike_iff_lumped` | structure and change are one lumping | unchanged; already structural | — |
| `Parting.world_right_iff` | a learner given the world is right at a step on every run exactly where no two runs part there | the extrapolation built from the process, its listed moves and configurations and the start proposes, at step `t`, the value through the map on every run from the start exactly where no two such runs part at `t` | exact; the current wording omits the start and the listing |
| `Learning.web_selectsThrough_iff` | selection through a formation's registration is selection through registering alike | a selection through `g`'s couplings is one that factors through the classes of histories alike through them | exact (`Iff.rfl`) |
| `Web.alike_of_threshold` | a condition depended on and not observed registers only whether it meets the need | a condition coupled into `g` by threshold only passes whether its need is met: meeting it under both histories or neither, they go alike through `g`'s couplings, whatever the levels | exact |
| `Web.observed_level_registers` | any difference in an observed condition is registered | any difference in the level of a condition coupled into `g` by level makes the histories not alike through `g`'s couplings | exact |
| `Web.Refutes.not_of_alike` | a claim is refuted only through a difference in what registers | a claim is excluded at `g` only through a difference that couples into `g`: where a history meeting it is alike through `g`'s couplings up to `t`, it is not excluded there | exact |
| `Web.tail_unrefuted` | without a model, a finite record leaves what follows open | no history up to `t` excludes, at any formation under any coupling, either the claim that a condition comes to nothing or the claim that it stays above nothing after `t` | exact |
| `Web.belief_refutes_iff` | refutation is a claim disjoint from the belief | a claim is excluded at `g` exactly where it is disjoint from the class alike through `g` | exact; "belief" fails T1 |
| `Flow.withinRegistration_supportOnly` | registering support only, the registration closure is the influence closure | where coupling is by threshold only, the coupling closure is the influence closure | exact |

All fifteen restatements mean exactly their Lean statements. In three cases (`diagonal_refutes`, `world_right_iff`, `belief_refutes_iff`) the current wording says more or less than the Lean, so the candidates are more exact than the words they replace.

## 6. Findings, counter-review and what stays open

### 6.1 What the candidates gain and lose

- **Gain.** The learning laws read as relations of one unfolding: how far a part comes into accord with a feature through what couples into it. This fits the [nondual method](../../../../theories/becoming/history/NONDUAL-METHOD.md) and the `Becoming.Unfolding` start. One word per relation ends the S2/S6 overload and the two senses of "record", and the learning line joins vocabulary the core already has (lumping, coupling, factors through, fixes, prefix).
- **Loss to watch.** The standard literature (Gold's identification in the limit, Popper's falsifiability, PAC learning) is found under the old words. Those names belong in the records' correspondence and standard-boundary fields as the literature's terms, not in core names. "Extrapolation" can suggest numerical or linear extension; it is used here in its general sense, proposing how a sequence goes on. "Coupling" invites a symmetric reading; "into" must stay.

### 6.2 A check before "coupling" is adopted for S2

`Web.Registers` takes `obs` as a supplied relation. `Loops.Couples` derives coupling from an exchange law's strengths, and `Observation` (P125) reads observation as a route of readings. Using one word for both is exact only if the level branch of S2 is shown to be, or to be read as, a coupling in the `Observation`/`Loops` sense. That is an instance theorem, i.e. new Lean, and needs a board claim. Until it exists, "coupled by level" is a reading of `obs`, labelled as such. **Done 18 October 2026 (N2):** [`Becoming.LevelCoupling`](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/LevelCoupling.lean) proves that a law's response to one level is a coupling of every strength array and a route of reading. For a law reading through registration, only registered levels couple, an unobserved condition passes only a crossing of its need, and, up to double negation, observing is exactly where a level can couple into a formation within its need ([where-a-level-couples](../../../../theories/becoming/results/records/where-a-level-couples.md), [study §168](BECOMING-RENEWAL-READING.md#168-where-a-level-couples-into-a-formation-n2)). The level grain's condition is met; the positive half of the threshold grain (that a crossing does pass) is not witnessed.

### 6.3 On 识

Ren chose 识 for "registers" on [11 October](../../../../sources/15-codex-theory-conversations/2026-10-11-wisdom-from-registration.md). It is closer to dependent differentiation than the English word. It is also the 分别 the 无明 line (`Becoming.Seeking`, `Becoming.Capture`) diagnoses, so as the name of a map or a coupling it says too much at the primitive level. Proposal: the primitives take the structural words above (归并, 耦合入, 无别, 排除, 前段, 外推, 不合, 相合). 识 is kept, as a reading, for the derived structure where a formation's own further course factors through the lumping its couplings induce (selection, response or seeking through its own couplings). That is the place where differentiation by a part shapes that part's course. The reading is the AI's; Ren took this option, (b), on 18 October 2026 (section 7).

### 6.4 Adjacent words with the same problem (not decomposed here)

`Admits` (levels "admit" a formation; board rule 8 already lists it as dualist; candidate "the levels meet `f`'s needs", 所需得足). "Model" for a class of admissible histories (`RefutesWithin`; a scientific word, lower priority). `Reads` / `Reading` / `Readout` and "observation is a route of readings" (`ReadsInto` is a dependence; "reads" keeps a reader, but more mildly). "Options" outside `Selection`.

### 6.5 What a migration would take (not started)

1. Ren's decision on the candidates, including 6.3: taken on 18 October 2026 (section 7).
2. Prose first: docstrings, record statements in both languages, the chapter and glossary, with an alias table of old to new names. The retired words are explained once in the glossary, as for G0 and Part I/II.
3. Lean renames, statements and proofs unchanged, with the old names kept as aliases for one cycle. They land through the queue after the instance check of 6.2, with every record citing a renamed declaration rebound and given a history note. About 64 modules, 180 records and the chapter are affected. This is a claim for the board, and it must not run alongside another session's renames of the same files.

## 7. Decisions (18 October 2026)

Ren went through the candidates in conversation, numbered 1–15 with the AI's confidence and alternatives for each, and the three options for 识. Ren then sent the reply the AI had drafted: "Agree with the candidates as proposed and with 识 option (b); record the decisions in the study, still no renames" ([source](../../../../sources/15-codex-theory-conversations/2026-10-17-registration-dualist-vocabulary.md#rens-decision-18-october-2026)). "As proposed" is read as the first candidate of each row, not the alternatives offered beside it. The adopted vocabulary:

| # | Current | Adopted (en) | Adopted (zh) | Condition carried |
|---|---|---|---|---|
| 1 | registers (S2) | couples into; by threshold / by level | 耦合入；经阈 / 经水平 | Coupling by level became a name only after the instance check of 6.2, met on 18 October (N2). Always "into" (directed). |
| 2 | registration as a map (S1) | the map; its lumping; the course through the map; `Law.frameBy` | 映射；归并；经映射的历程；律经映射之框 | — |
| 3 | registers alike (S3) | alike through `g`'s couplings (`AlikeThrough`) | 经 g 之耦合无别 | — |
| 4 | registration closure (S4) | coupling closure (`WithinCoupling`, `CoupledFrom`) | 耦合闭包 | — |
| 5 | belief (S5) | the class alike through `g` (`ClassThrough`) | 经 g 无别之类 | — |
| 6 | refutes (web) | excludes (`Excludes`, `ExcludesWithin`) | 排除 | Popper's "refutation" stays in correspondence and standard-boundary fields. |
| 7 | `Likeness.Registers` (S6) | respects the claims (`RespectsClaims`) | 保持断言 | — |
| 7′ | local senses (S7) | `keeps`, `keepsBit`, `keepsNothing`; `negationCourse`; `linkProcess`; `alikeOnInstalled`; `RespondsThroughCoupling` | 存；否定之历程；联结过程；装入处无别；经耦合而应 | — |
| 8 | record (`Learning.record`) | prefix | 前段 | 迹 is not adopted; the Zhuangzi echo stays an unused analogy. "Record" keeps its entropy sense. |
| 9 | learner / claim (`pred`) | extrapolation; proposes / stays silent | 外推；提出 / 默 | Used in its general sense, proposing how a sequence goes on. An actual formation remains "a formation that learns". |
| 10 | refuted / holds | misses / accords | 不合 / 相合 | — |
| 11 | target (`val`) | feature | 特征 | — |
| 12 | learner by refutation | extrapolation by elimination | 逐除外推 | — |
| 13 | learner given the world | extrapolation built from the process (moves, configurations, start); built from the law (map, feature, configurations) | 依过程所建之外推；依律所建之外推 | — |
| 14 | learnable | kept | 可学 | Defined as in section 4. |
| 15 | options; selection through a model of the options | alternatives; selection factors through a map of the alternatives | 备择；经备择之映射的选择 | Revises the 16 October title; the old title stays as an alias in the record's history. |
| 识 | registers (zh, 11 October) | — | 识 is kept for the derived structure only: a formation's own further course (selection, response, seeking) factoring through the lumping its own couplings make | Primitives take the words of rows 1–13. The 无明 line (`Seeking`, `Capture`) is where 识 now has its exact place. The reading is the AI's; Ren chose this option. |

Not decided here: the adjacent words of 6.4 (`Admits`, "model", `Reads`/`Reading`, "options" outside `Selection`); the instance check of 6.2; the migration of 6.5, steps 2–3, which needs its own claim on the board. Nothing is renamed by this decision.

## 8. Applied (N5, 18 October 2026)

Ren answered the four decisions of the migration package with "Renames, full scope" ([source](../../../../sources/15-codex-theory-conversations/2026-10-17-registration-dualist-vocabulary.md#rens-decision-on-the-renaming-18-october-2026)). The renaming was applied on one branch and landed with one checker run. The full table, every old full name with its new one, read off the declarations before and after, is [RENAME-TABLE.json](../history/root-foundation/development/n1-migration/RENAME-TABLE.json): 175 declarations. The tools are [apply_renames.py](../history/root-foundation/development/n1-migration/apply_renames.py) and [rebind_records.py](../history/root-foundation/development/n1-migration/rebind_records.py).

**What changed.**
- The 30 definitions of section 7, with the theorem names the dry run proposed. Each was reviewed against its statement; three proposals were changed: `Viability.Matching.registered_kept` → `keepsBit_kept`, `registration_matters` → `keeping_matters`, `LearningRuns.determines_iff_registered_alike` → `determines_iff_lumped_alike`.
- The theorem families named after a renamed definition that the dry run's token families did not reach: in Unfolding, Distinguishing, Likeness, FallibleInquiry, Keeping, Response, Sensitivity, Tail, Testing and Identification. Examples: `Law.registered_determined` → `Law.frameBy_determined`, `ExchangeLaw.ReadsFinitely.least_registration` → `least_coupling`, `Web.tail_unrefuted` → `Web.tail_unexcluded` (the web sense: not excluded), `Identification.unrefuted_persists` → `no_miss_persists` (the learning sense: no miss), and the instances `Learning.decRefuted` → `decMisses`.
- Identifiers changed in Lean code and wherever a docstring, a record's live field, the chapter or the package README names them (in backticks, or qualified). Prose words such as "registers" or "record" were not substituted; they change by reading.

**Departures from what was offered, with reasons.**
- `Learning.record` became `Learning.prefixOf`, not `Learning.prefix`: `prefix` is a Lean command keyword, so the bare name cannot be used inside its namespace. Theorem names keep `prefix` (`Learning.prefix_length`).
- Row 7′'s `negationCourse` is `Negation.course`, the same name with its namespace.
- No deprecated aliases. The pure core compiles from Lean's prelude, where the `alias` command is not available, so an alias would be a copy of the statement. A copy no theorem on the base uses would stand apart and fail the connectivity check, and every alias would count as a theorem in the receipts. The aliases were meant to keep records and other sessions' work resolving. Records were rebound in the same change. No Lean outside the package names these declarations, except frozen check receipts and development copies, which keep their bytes as evidence. RENAME-TABLE.json is the lookup for every old name.

**Left as they are.**
- The logical sense of "unrefuted" and "refutable" (a double negation, P58b; `Horizon.Refutable`), as the package said.
- Senses outside the two families:
  - "record" for the conserved record of Entropy, the record of Experiment and Observation's stock;
  - the record of runs in TypicalRuns (`ofRecord`, `Records`, `record_ofRecord`);
  - "registers" as a verb in Order (`order_registers`), Branching, ReferencePlan's and ReferencePlanTraces' theorem names, and Contacts' `Blind`.
  These are candidates for the reading pass, not renamed by substitution.
- Studies, sources and frozen receipts keep the old names as history. The chapter's glossary explains the retired names once.

## 9. "Correction" read (N7, 19 October 2026)

Ren, 19 October 2026, on M4's first title "which responses correct": “correct? this is a dualist word, are we drifting off?” ([source](../../../../sources/15-codex-theory-conversations/2026-10-19-correct-is-dualist.md)). M4 became `Becoming.Rejoining` and restated its own and M3's sentences. This section reads the other uses of correct, correction and 纠正 in chapter §7, the sentences that restate it (§3, §8.4, §8.7), [ALIGNMENT-DIRECTION](../../../../theories/becoming/history/ALIGNMENT-DIRECTION.md) and the live fields of the records they cite, en and zh. The quoted words are provenance; each decision below is the AI's, by what the laws state. Docs and records only: no Lean, no statement, no result ID. The edits are in [`apply_n7.py`](../history/root-foundation/development/n7-correction-reading/apply_n7.py), applied through the landing queue (board item N7).

**The test.** A use presupposes a standard outside the relation when it makes one course the right one and the difference from it an error to remove. The laws it cites never need that: they state what reaches what, through which coupling, and what a change of state or of rule does. Which change supports 生生 goes through the comparison and the condition of chapter §6.15, as for M4. So such a use is restated by the structure the cited law states. A use stays where its exact meaning holds without that standard.

**Restated: the standard was in the word, the structure is in the law.**

| Where | Was | Now | The structure meant |
|---|---|---|---|
| §3, the boundary condition for 无明 (bullet title and two sentences) | *Correction.* … locked seeking is not corrected by its own feedback … corrects it | *Beyond its own feedback.* … the losses locked seeking makes beyond what couples into it do not reach it through its own feedback … carries them to it | Losses reach a seeker only through what couples into it (`Becoming.Testing`, `Becoming.Runaway`). The law says where losses reach, not that the seeking is wrong. |
| §3, a judgment is a one-step inquiry | correction under observation | a change chosen under observation | One kind of common response (`commonResponse_judge_iff`); nothing marks it as the right one. |
| §7, opening | organizes the correction around 明; the conditions under which a correction can be carried out | organizes its answer around 明; the conditions under which a requested change, such as a stop, can reach a system and be carried out | What §7.6's records state. |
| §7.2, reading | Capability widens reach; correction needs coupling | Capability widens reach; closing the gap needs coupling | The bullet's own content: the gap of law 1 (reach closure less coupling closure) closes only by coupling, not by optimizing harder. |
| §7.3, reading on 明 | locked seeking is not corrected by its own feedback. It is corrected by measurement, a model, or others | the losses locked seeking makes beyond that do not reach it through its own feedback. They reach it through measurement, a model, or others | As in §3. |
| §7.3, reading; §7.4 "one ground"; §8.4 | Correction has to reach the rule; a correction that reaches only states | A lasting change has to reach the rule; a change that reaches only states | `Law.perturbation_reabsorbed` (law 7): a change to the state alone is re-absorbed where the next configuration depends on the rule. The law holds of any change, wanted or not. |
| §7.5 claim, ALIGNMENT-DIRECTION §1 (en + zh) | understand, challenge and correct that development (纠正) | understand, challenge and revise that development (修订) | The conditional direction's own item 3: effectiveness is "actual influence on relevant judgment and action", without obedience to every challenge. Which revision is warranted goes through the stated premises (real losses, basic conditions, bounded responsibility, participation), already in the claim; "correct" put that verdict in the verb. |
| §7.5, where the two parts meet | a correction selects what an act does beyond … | a challenge or a revision selects what an act does beyond … | `Flow.act_selected_by_pool`: selection through a coupling that reaches the difference. |
| §7.6, heading and body | Correction must be an executable sequence; a disposition to accept correction | A requested change must be an executable sequence; a disposition to accept a requested change, such as a stop or a revision | The records state, for their protocols, when a stop or change request is delivered and carried out. The protocol supplies its target as a stated local law; the word added that the target is right. |
| §7.6, record link; record `recoverable-mediated-change` title | the bound on reaching correction; corrective-access limits (纠正边界) | the bound on reaching a stop; the limits of stop access (停止入口的界) | The record's counterexample and next step concern ordinary shutdown blocked during recovery. |
| §8.4, §8.7 | opportunities to correct; understanding and correction (修正) | opportunities to revise; understanding and revision (修订) | As for the claim. |
| ALIGNMENT-DIRECTION §2 and §4 item 3 (en + zh) | later correction (纠错); participation, challenge and correction; 申诉、纠正与替换 | later revision (修订); participation, challenge and revision; 申诉、修复与替换 | The en text already says "recourse, repair and replacement". |
| Record `alignment-direction-g0-j`, statement and overview | correction | revision | As for the claim; the claim's scope is unchanged. |
| Record `the-gap-for-ones-own-act`, the AI's reading | correcting an act whose consequences lie beyond | responding to an act whose consequences lie beyond | `Flow.act_unselected`, `Clearing.selected_pooled`. |
| Record `what-pooled-coupling-reaches`, non-implication and next step | corrects anything; which responses … correct the act | closes any difference; which law closes rather than widens a difference | M4's wording (`Becoming.Rejoining`). |

The Chinese follows the same lines: 纠正 becomes 改变 where the English says change, 修订 where it says revision (as M4 has it), 闭合差别 where a difference closes, 停止 where the record concerns a stop.

**Left to M4.** §7.4's last paragraph ("correction and escalation share that structure", "which loops correct"), §7.4's "a reward, a vote or a correction it gives", §7.7's bullet "Which responses correct", the §8.2 open item, the §8.4 clause on loops, and the record `what-a-pools-acts-respond-to`: M4's text kit restates them (closing and widening a difference; revision). N7's blocks are disjoint from M4's and apply in either order.

**Kept: the exact meaning holds without a standard outside the relation.**
- Logical and epistemic senses: knowledge "connected … to the actual relations that make it correct" (§3), where the relation that makes it correct is stated; "correctly classifies" in `risk-certificate-outcome-distinction`; "universally correct classifications" in ALIGNMENT-DIRECTION, which denies one; 说谎者读作修正 and 以否定修正 (a revision that never rests, `Negation`).
- Editorial senses: reviews that corrected definitions or records (§6, the review table of §8, record histories). The standard there is the text's own claim, which is inside the work.
- Ren's words and titles: the title of his paper “When Capability Outruns Correction” (§3) is kept as provenance. Read with §7.2, its sense is that capability widens reach faster than coupling closes the gap; a note, not an edit. The glossary rows for 成生 / 绝生 (“correcting” in Ren's act-level test) and 膜 (“can be corrected through”, from Ren's earlier text 纠正与关怀能够穿过它) report Ren's formulations and stay as they are.
- Identifiers and paths: `experiments/integrated-correction/`, the records `formed-copying-correction` and `market-partial-correction-boundary`, the module and bridge `CorrectionInquiry`, the document names `PLURAL-SYSTEMS-AND-CORRECTION` and `CORRECTION-INFRASTRUCTURE-PROTOCOL` (board rule 8: original files keep path and name).
- History fields of records, sources and frozen copies.

**Noted, not edited: the periphery correction family.** F3C (board) ports AlignmentInquiry, EffectiveCommand, AcquiredCorrection, FaultTolerantCorrection, CorrectionReconfiguration, EvidenceQualifiedCorrection, FallibleInspection, CorrectionInfrastructure and ChanceAdequacy into core modules named by their laws (`Actuation`, `Dispatch`, `FaultEnvelopes`, `Transactions`, `Reconfiguration`, `PooledEnvelopes`, `WitnessRefinement`, `ChanceFloors`, `Acceptance`, `GuardHorizon`, …), so the core already drops the word; its owner keeps the periphery Lean as it is. The prose that describes that family still uses it: [ALIGNMENT-THROUGH-CHANGE](../../../../theories/becoming/history/ALIGNMENT-THROUGH-CHANGE.md) (§2 "Correction is an executable sequence", §6, §7, §9, §13 "corrective access", "correction money", "correction-bearing installation"), [ETHICAL-LEARNING](../../../../theories/becoming/history/ETHICAL-LEARNING.md)'s "forming corrective access", and §3's "correction under observation" when it names the bridge. Proposal: when the F3 sweep retires the ported modules, that prose takes the core modules' names and the senses above (a requested change delivered and carried out, a stop, a reconfiguration, a revision); headings with anchors move with `research.py links` checked. Not done here because the word there names protocols whose ports are not on main yet.

**OPENING and the generativity chain.** OPENING's body does not use the word. Its AI-written footnote on alignment says the direction is "open to correction"; it follows the claim and now reads "open to revision" (edited, since the footnotes follow the current theory). The [generativity chain](../../../../theories/becoming/results/GENERATIVITY-CHAIN.md), Ren's curated argument, uses the word about 120 times in three senses: editorial (Ren's corrections of the AI's readings, "scope correction", 范围纠正: kept); the periphery's protocols ("actual correction", 实际纠正, 纠正入口, correction addresses, corrective access, correction capacity and budgets); and the alignment direction (可纠正性, 有效纠正). Proposal, not edited: the second sense follows the core names when the F3 sweep retires the ported modules, and the third reads "revision" as the claim now does; both go through the chain's maintenance record, as a proposal to Ren like A3's relabelling proposal.

**Checked.** On main `1494aae5c`, `apply_n7.py --check` matched 48 text blocks and 12 record fields once each. A trial application in the worktree, then `make research-render`, reported source drift only for `wisdom-root-part-one` (the §8.7 sentence it is linked from), re-pointed with `--repoint 'section 8.7'` after reading; `research-check` and `research-test` passed, and `research-links` reported only the board's W2 anchor, which it already reported without N7. The trial was reverted; the edits land through the queue after N6, whose wording of the §3 sentence the blocks also match.

**Landed (19 October 2026).** Applied on main `b6b51dc1c`, after N6, G5, M4 and A4 had landed. M4's sentences (§7.4, §7.7, §8.2) and the record `what-a-pools-acts-respond-to` were restated by M4 as planned. A4 removed §8.4's list of open readings, so the four blocks that edited its §7 line (two per edition) were dropped; A4's new sentences on 无明 already use the structure above. The kit applied the remaining 44 text blocks and 12 record fields, and re-pointed the 123 records whose references matched the changed files at the base, each with a history note. `make research-render` reported no source drift; `research-check`, `research-test` and `research-links` passed with no broken link.
