# UE11 review: where the possible grows

AI-written, 27 October 2026. This is an independent review of board item UE11, written for its fix round. Every header and docstring claim was checked against the Lean, and every probe was built with its axiom report printed. The review edits neither the module nor the design. The probes are evidence; none is proposed for landing as written.

**Reviewed.** [`tree/Becoming/HeldPossible.lean`](tree/Becoming/HeldPossible.lean) (361 lines, sha256 `1dc33ceee6198c49d2c4eefc246833bf2bbfcc4d95c78e057f6ab43714eab8da`) and [`DESIGN.md`](DESIGN.md) (sha256 `d942f5ee1f89b374ee5670fde2277dacae37c29e95a678947a65145ab215cf1f`). The landing candidates are [07 §2 after what a course keeps reachable](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-what-a-course-keeps-reachable) and [02 after rules that change themselves](../../../../../../theories/becoming/chapters/02-MAP.md#r-rules-that-change-themselves-in-the-grammar), with [01's Open item](../../../../../../theories/becoming/chapters/01-ROOT.md#open) on self-changing conditions. The neighbours read were [UE10's note](../ue10-what-can-be-reached/NOTE.md) and [review](../ue10-what-can-be-reached/REVIEW-UE10.md), the [glossary](../../../../../../GLOSSARY.md), [D5](../../DELEGATED-CHOICES.md#d5-接续与生生不息的层次--succession-and-the-level-of-生生不息), the root's continuation and line, and the landed modules named below. Package modules are cited by file and line under `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`, which is [this folder](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/) from here.

**Build.** `python3 -B scratch_build.py <probes/tree> Becoming.HeldPossible Becoming.ProbeUE11Laws Becoming.ProbeUE11Tower Becoming.ProbeUE11Root Becoming.ProbeUE11Adaptive Becoming.ProbeUE11Shadow Becoming.ProbeUE11Axioms Becoming.ProbeUE11Clash`, run against main's package (Lean v4.29.1), reproduces the module's 25 theorems in 33 declarations, every axiom report empty. The copy in the probe tree is byte-identical to the module. The module's proofs are term-mode, with no tactic. It imports `Becoming.ReachableRanges` and `Becoming.Mechanism`, both on `check_becoming.py`'s `CORE` list, and so are the modules the proposed instance theorems would use (Gated, Junctures, Onward, Parting, Reproduction, Grammar, GrammarLaws). The import closure of all of them holds no L2 module by the package README's layers. `check_becoming.py` was not run.

## Probes

All probe files are in [`probes/tree/Becoming/`](probes/tree/Becoming/), namespace `Becoming.ProbeUE11`, except the shadow probe, which must sit in `namespace Becoming`.

| File | Theorems / declarations | Axiom report | Probes |
|---|---|---|---|
| [`ProbeUE11Laws.lean`](probes/tree/Becoming/ProbeUE11Laws.lean) | 26 / 38 | empty | P1–P8 |
| [`ProbeUE11Root.lean`](probes/tree/Becoming/ProbeUE11Root.lean) | 6 / 6 | empty | P9 |
| [`ProbeUE11Tower.lean`](probes/tree/Becoming/ProbeUE11Tower.lean) | 8 / 13 | empty | P10 |
| [`ProbeUE11Adaptive.lean`](probes/tree/Becoming/ProbeUE11Adaptive.lean) | 4 / 8 | empty | P11 |
| [`ProbeUE11Clash.lean`](probes/tree/Becoming/ProbeUE11Clash.lean) | 1 / 1 | empty | P12 |
| [`ProbeUE11Shadow.lean`](probes/tree/Becoming/ProbeUE11Shadow.lean) | 1 / 1 | empty | P13 |
| [`ProbeUE11Axioms.lean`](probes/tree/Becoming/ProbeUE11Axioms.lean) | 8 / 8 | `a1`: `propext` | P14 |

No probe proposed as evidence needs an axiom. P14 records that `Nat.succ_ne_zero` carries `propext` in this Lean version, so the probes use `Nat.noConfusion`; the module uses neither. P12 imports `Becoming` (the root import) together with the module, 335 modules, and finds no name clash. P13's first run failed by design, and its file records the error. `probes/tree/.build` is build output and holds no data. A final run of all eight modules reused every passed step and printed the reports above.

Probe index:
- **P1** `exists_not_of_not_forall_lt`: bounded search over a decided predicate. This is the package's `Reproduction.search` (Reproduction.lean line 377), read through a decided double negation.
- **P2** `plain_of_bounded`, `markov_of_plain_gives_bounded` (question a). The module's bounded-stretch form gives the design's plain form with no premise. If the plain form gave the bounded form for every process along one course, Markov's principle (`Markov`, Horizon.lean line 367) would follow.
- **P3** `Run.held_change_located`, `Run.held_change_of_keepsWidening`, `Climbing.change_of_keepsWidening`, `Run.adaptive_rule_change_of_keepsWidening` (question b). With the held part decided, a step changing it is located within the stretch, and from every step on.
- **P4** `trace_held_of_bounded`, `possible_iff_held_of_bounded`, `tower_bounded`, `syncProcess`, `Sync.possible_two`, `Sync.not_held`, `Sync.tower_law_fails` (question c). The tower law holds for every process on a state and a sequence of levels whose every move keeps the levels from some height up. It fails for a synchronous tower that changes every level at once.
- **P5** `Run.ruleTower_moves_above_of_keepsWidening`, `RuleTower.reflected`, `RuleTower.held_origin` (question d). This is the positive tower law, located through the moves. The held possible of the tower is an instance of `Gated.origin`.
- **P6** `within_eq_keeping`, `branching_keeping_eq`: Onward's `within` and Junctures' `keeping` are instances of the module's `keeping`, by `rfl`.
- **P7** `Oscillating.rule_changes`, `.every`, `.held_zero`, `.converse_fails`. Endless change of the held part with an unlisted whole possible does not suffice for keeping widening.
- **P8** `Run.not_heldKeepsWidening_from`: from the step at which the part stays for good, nothing is added to the held possible. The probe's name is wrong for its statement; a landing name would be something like `Run.possibleHeld_of_stays`.
- **P9** `steps_keeping_iff`, `reach_keeping_iff_line`, `possibleHeld_iff_line`, `ji_line_of_chain`, `sameFrom_class`, `tower_ji_line`: the held possible and the tower law on the root.
- **P10** `Copying.held_iff`, `Copying.held_keeps_widening`, `Copying.whole_every` (question e), with `lv_next`, `sameFrom_of_trace` and `ite_prop`. This is a tower witness. The possible with the levels from every height up held keeps widening while every formation stays possible, and each level changes exactly once.
- **P11** `RisingRule.held_iff`, `.held_keeps_widening`, `.whole_every`: the adaptive law's premise can be met. The witness is degenerate, since it has no held move.
- **P12** `clash_free`, which imports `Becoming` with the module.
- **P13** `probeUE11_shadow`: under `open Branching`, bare `keeping` is the module's.
- **P14** `a1`–`a8`: which core lemmas carry axioms.

## Findings

### Required

#### R1. The top law's docstring says more than its Lean

*Location:* `Run.ruleTower_not_keepsWidening_of_top`, lines 286–287; the header, lines 46–48.

*Problem.* The bold claim is "A top fixed for good stops the growth relative to it". The theorem concludes only `¬ Reaching.KeepsWidening …` of the chain read from the course's first step, and says nothing about growth after step `T`. The stronger statement is true. P8 shows that where every step from `T` on keeps the part, what is possible with it held at `T + d` is possible so at `T`, but that is not this theorem. The proof is the one line `r.not_heldKeepsWidening_of_stays (fun k later => (top k later).mono le)`.

*Fix.* Do (a) or (b).
- (a) Write: "**A top fixed for good ends keeping widening relative to it**: where from step `T` on the levels from `N` up stay, the possible with the levels from any `n ≥ N` up held does not keep widening."
- (b) Land P8 under a name that states it, for example `Run.possibleHeld_of_stays`, with the statement of ProbeUE11Laws lines 365–371. Its docstring: "**From the step at which the part stays for good, nothing is added to the possible with it held**: where every step from `T` on keeps the part, what is possible with it held at step `T + d` is possible so at step `T`." Then keep the title and cite `Run.possibleHeld_of_stays` in it.

Either way, the header's "keeps widening nowhere" (line 47) becomes "does not keep widening" (M1).

#### R2. Climbing's closing sentence misstates what the held laws require

*Location:* the header, lines 55–56.

*Problem.* The header says "The rule changes at every step (`Climbing.rule_changes`), as the held laws require." The held laws (`Run.changes_of_heldKeepsWidening`) require only that the part change without end: from every step, some bounded stretch changes it. Change at every step is not required. It also does not suffice (P7).

*Fix.* Write: "The rule changes at every step (`Climbing.rule_changes`); the held laws require only that it change without end."

#### R3. `keeping` takes a word the package and the glossary already use in other senses

*Location:* `def keeping`, lines 136–139; its uses at lines 145, 150–157, 163, 170, 178, 186, 263, 268 and 321; the header, line 25.

*Problem.* The module adds `Becoming.keeping` at the top of the package namespace. It is the word's fourth sense:
- The glossary row "generation, keeping, degeneration (生成, 守, 退化)" reads keeping as a pattern going on without carrying renewal.
- `Branching.keeping P s` (Junctures.lean line 346) is the steps of `P` after which `s` can still be had (护闭).
- `Becoming.Keeping`, a core module, is a guard kept through what the steps keep (`Viability.KeptFor`).

P13 shows the clash in Lean. Inside `namespace Becoming` with `open Branching`, bare `keeping` now resolves to the module's, because Lean looks through the enclosing namespaces before the opened ones. The probe's first run, written with `keeping P s` meaning Junctures', failed with a type mismatch. No landed file breaks today: Branching.lean opens `Branching` but uses "keeping" only in prose. It is a hazard, not a break. Both landed restrictions of a process are instances of the module's definition by `rfl` (P6).

AGENTS.md asks for names that state exactly what the statement means. A renaming after landing needs a name that states a wrong meaning, so the rename is cheap only now. The design's `Process.keeping` would not do better: written as a dot-notation name on `Generative.Process`, it would put a Becoming declaration into the foundation's namespace.

*Fix.*
- Rename to a namespaced name that states the definition, for example `Reaching.heldMoves P Same`, with `Reach.of_heldMoves` and `Reach.heldMoves_mono`. Docstring: "**The moves holding a part**: the moves of `P` whose two configurations are related by `Same`, read as a part held unchanged."
- Land P6 as instance theorems in the new name, both `rfl`: `Onward.within P K = Reaching.heldMoves P (fun s t => K s ∧ K t)` and `Branching.keeping P s = Reaching.heldMoves P (fun _ t => Reach P t s)`.
- Re-run P12 after the rename.

#### R4. The reading must use the glossary's terms and stand with the readings already in place

*Location:* DESIGN §7 (line 57) and §6 (line 53), and any text of the note or record drawn from them.

*Problem.*
- (a) "What generation adds is the actual" uses "generation" for what the unfolding produces. The glossary reads generation as a pattern going on through carrying renewal, and says it "never means arising, nor any new organization".
- (b) "生生不息, generation without ceasing, then reads as the parts' possibles growing as what they hold keeps changing, at every level, never the whole's possible." Two readings of the term already stand:
  - the root theorem `«生生不息»` (Grammar.lean line 632), renewal without end does not cease;
  - D5 as revised on 18 October, which reads 生生不息 as 生生 going on at the whole with more still able to form, and excludes reading it as growth.

  The design's sentence re-reads the term as growth, of the parts' possibles, and denies it of the whole, without placing the reading against either. Under AGENTS.md a reading stands or is revised by its place in one account.
- (c) "At every level" (§7) and "at every level of a tower no level fixed for good" (§6) go beyond what is proved. The module proves only the negative law at a fixed top. P10 shows that "no level fixed for good" is not what is needed. On the copying tower, the possible with the levels from every height up held keeps widening, while every level changes exactly once and stays fixed from then on: the change climbs. What is needed is that no top, the levels from some height up, be fixed for good.

*Fix.* The note's reading, marked [AI reading, D45], should say in substance:

"If the one unfolding were one stated process, nothing would be added to its whole possible along its course: what a course adds is the actual. The possible grows only relative to what is held, and keeping it growing needs what is held to change without end; a tower of rules with no top adds nothing to its whole possible either. So 生生不息, read at the whole as renewal going on with more still able to form (D5), needs no growth of the whole possible. More still able to form is the whole possible exceeding the actual, as on the witnesses, where every formation stays possible, or the possible relative to what is held widening as what is held changes."

Write "no top fixed for good", never "no level fixed for good". Claim widening relative to every height only with P10 landed.

#### R5. Three of DESIGN §5's attributions are wrong, and the closest neighbours are missing

*Location:* DESIGN §5, lines 44–48, and any credit in the note or record drawn from it.

*Problem and fix.*
- (a) **Banzhaf et al.** Banzhaf, Baumgaertner, Beslon, Doursat, Foster, McMullin, de Melo, Miconi, Spector, Stepney and White (2016, "Defining and simulating open-ended novelty", Theory in Biosciences 135:131–161) name three kinds of novelty. Variation is novelty within the model. Innovation is novelty that changes the model, and so grows or shrinks the possibilities of variation. Emergence is novelty that changes the meta-model. The design gives emergence the role of innovation. Law 3 is their innovation read on a process. The possible with the model held is the possibility of variation, and it grows only across a change of the model. In their account this holds by definition. Credit it as "restated as a law on any process, near-definitional", not as a finding.
- (b) **Taylor et al.** Taylor and others (2016, "Open-ended evolution: perspectives from the OEE workshop in York", Artificial Life 22:408–423) contain no debate over whether a closed system can be open-ended. They summarize two talks:
  - Banzhaf's: novelty must be defined with respect to a model, and it can be practically unbounded if the number of levels may grow;
  - McMullin's on Popper: continuing inheritable change at the highest control levels, including newly dominating levels, may be critical to openness. This is the informal neighbour of law 5's reading that a top fixed for good ends widening relative to it.

  The question whether a simulation conforming to a fixed model can show innovation is Banzhaf and others'.
- (c) **Adams et al.** Add Adams, Zenil, Davies and Walker (2017, Scientific Reports 7:997). They define unbounded evolution and innovation against what the same system does under fixed rules, and find open-ended dynamics where the rules depend on the state. `adaptive F G` is such a rule. Their innovation is a neighbour of growth relative to a held rule; the exact correspondence **needs a check**.
- (d) **The tower law and Bateson.** The tower law's neighbour is procedural reflection's tower of interpreters (des Rivières and Smith 1984, "The implementation of procedurally reflective languages", ACM Symposium on LISP and Functional Programming; Wand and Friedman 1988, "The mystery of the tower revealed", Lisp and Symbolic Computation 1). The tower is infinite, yet only finitely many levels differ from the default at any point. That is, in substance, the finite support of `RuleTower.possible_iff_held`; it **needs a check** against their statements. Bateson's levels of learning run from Learning 0 to Learning IV, not I to III. Each is change in the process of the level below, which is the tower's scheme with no law of possibility.
- (e) **No neighbour states the laws.** Holland's adaptive systems and meta-learning hierarchies state no law of this kind that I found, and no neighbour I found states law 3 or the tower law as a law on any process. The Kauffman, Longo–Montévil–Kauffman, Hughes and others (2024) and Bedau and others (2000) entries are correct as given.

### Recommended

#### M1. Docstring precision

The wording of each replacement can be adjusted; the change of claim cannot.
- (a) **Header bullet 1** (lines 12–16): `P` plays no part, and "grows" names a weaker hypothesis. The theorems ask only that one formation be possible from `t` and not from `s`, with no inclusion. Write: "For any process `Q`, what is possible under `Q` from a configuration `Q` reaches is possible from the first (`Reaching.Possible.of_reach`). So where something possible under `Q` from `t` is not possible from `s`, `Q` does not reach `t` from `s`, and a step from `s` to `t` is not a move of `Q`."
- (b) **`Reaching.not_reach_of_grows`** (lines 81–82): "**Where something possible under `Q` from `t` is not possible from `s`, `Q` does not reach `t` from `s`** (`Reaching.Possible.of_reach`)."
- (c) **`Reaching.not_step_of_grows`** (line 87): "**A step from `s` to `t`, where something possible under `Q` from `t` is not possible from `s`, is not a move of `Q`.**"
- (d) **`Run.changes_of_heldGrows`** (line 165): "**Where something possible with a part held at the next step is not possible so at the present one, the step changes the part.**" Renaming the three theorems `…_of_new` is optional.
- (e) **"After every step" → "from every step"** (lines 21, 28–29, 112, 174 and 213): the stretch starts at step `N` itself.
- (f) **"In 07's form" → "in 07's form, read from the course's first step"** (lines 20, 54 and 340), as 07 §2 now says for UE10's chain.
- (g) **"Keeps widening nowhere" → "does not keep widening"** (lines 30 and 47). The Lean reads the chain from step 0. The forms from a later step follow by applying the laws to `Parting.after r T` (Parting.lean line 89), which the module does not state.
- (h) **`Climbing.held_trace`** (lines 319–320): "With the rule held, what a configuration reaches has its rule, and its position or one at most its rule."
- (i) **`RuleTower.trace_held`** (lines 260–261): the second clause describes the proof's height, the sum of the trace's moves, while the statement gives some height. It is optional to say "(the proof takes the sum of the trace's moves)".

#### M2. Keep the bounded-stretch form, and add the located form for a decided part

*Location:* `Run.departs_of_keepsWidening` and `Run.changes_of_heldKeepsWidening`; the header, lines 21–23.

*Evidence.* P2 shows that the module's form gives the design's plain form ("from no step on are all steps moves of `Q`") with no premise, while the converse, asked for every process, gives Markov's principle. So the departure from DESIGN law 2 is right, and the module states the constructively stronger form. P3 shows that where the part is decided, a step changing it is located: within the stretch (`Run.held_change_located`), and from every step on (`Run.held_change_of_keepsWidening`, `∃ i, N ≤ i ∧ ¬ Same (r.state i) (r.state (i + 1))`). `Climbing` (a rule in `Nat`) and the adaptive law with `[DecidableEq R]` are instances. No axiom is needed. The search is `Reproduction.search`'s.

*Fix.* Replace "The law is a negation: locating the departure would need deciding the moves." with "Where the part is decided, a step changing it is located from every step on (`Run.held_change_of_keepsWidening`)." Land P3's two laws and the adaptive one. What locating needs without a decision is not probed. Under AGENTS.md it would be a lemma of this item, and a calibration only if its record says what the need says about the unfolding, as the gate law's calibration in 01 does ("locating where a property entered needs it decided, move by move").

#### M3. The tower: state the premise the law needs, and add the positive law

*Location:* `RuleTower.possible_iff_held` (lines 270–277); the modelling list (line 64); `Run.ruleTower_not_keepsWidening_of_top` (lines 286–293); the header, lines 42–49.

*Evidence.*
- (a) **Finite support per move.** By P4, the law needs each move to keep the levels from some height up, not one level per move. `possible_iff_held_of_bounded` proves it for every process on a state and a sequence of levels whose moves have that property, and `tower_bounded` gives the property for `RuleTower.process`. In `Sync`, every move changes every level at once, each as the one above allows. There `2` is possible from the start but not with the levels from any height up held (`Sync.tower_law_fails`). "No single possibility needs the tower to have no top" is therefore a fact about the asynchronous scheme.
- (b) **The positive law.** `Run.ruleTower_not_keepsWidening_of_top` is `Run.not_heldKeepsWidening_of_stays` with `SameFrom.mono`, an instance. DESIGN law 5 planned a positive law (`Run.tower_levels_change_of_keepsWidening`), which the module does not state. P5 states it, located with no decision of the levels, because each move names the level it changes: where the possible with the levels from `n` up held keeps widening, from every step on some move above `n` is taken (`Run.ruleTower_moves_above_of_keepsWidening`, `∃ i, N ≤ i ∧ n < r.act i`). The moves at most `n` reflect the held possible (`RuleTower.reflected`), so it is an instance of the landed gate law (`Gated.origin`, Gated.lean line 163; 01's [every origin passes the gate](../../../../../../theories/becoming/chapters/01-ROOT.md#r-every-origin-passes-the-gate)). A trace ending where `x` is possible with the levels from `n` up held started where it was, or splits at a move above `n` after which it is (`RuleTower.held_origin`).

*Fix.*
- State the general law, with `RuleTower.possible_iff_held` as its instance, and land `Sync` as the witness that the premise is needed.
- Modelling list, line 64: replace "one level changed per move" with "each move keeping the levels from some height up (one level per move in `RuleTower.process`; a tower changing every level at once has a possibility needing the whole tower, `Sync.tower_law_fails`)".
- Lines 45–46 and 271: replace "no single possibility needs the tower to have no top" with "each is had by changing only the levels below some height".
- Land P5's law and the gate instance as the tower's positive law. Keep `ruleTower_not_keepsWidening_of_top` only with R1's wording, or drop it as an instance.

#### M4. Witnesses that settle what the header leaves open

- (a) **The converse fails.** In P7, `Oscillating`, the rule changes at every step and every formation is possible from every configuration, so no list holds the whole possible. Yet the possible with the rule held does not keep widening: what it opens with the rule at `1` it loses with the rule back at `0`. This answers the header's last sentence (lines 65–66) and DESIGN §4's sufficiency item, as UE10's `AllAtOnce.converse_fails` does for horizons. Replace "and neither is whether endless change of the held part with an unlisted whole possible suffices for keeping widening" with "endless change of the held part with an unlisted whole possible does not suffice for keeping widening (`Oscillating.converse_fails`)", and land the witness.
- (b) **A tower witness.** P10 is the tower witness that R4(c) and the design's "at every level" need. Land it under a free name, such as `CopyDown`: `Becoming.Copying` is a landed core module (Copying.lean line 63). Add to the header's tower bullet: "On a witness, the possible with the levels from every height up held keeps widening while every formation stays possible; each level changes once, and the change climbs (`CopyDown.held_keeps_widening`, `CopyDown.whole_every`)."
- (c) **The adaptive witness, optional.** P11 shows that the adaptive law's premise can be met. It is degenerate, since the rule changes at every move and no held move exists. Land it only with a sentence saying so.

#### M5. State the held possible on the root

*Evidence.* With `Same` read as a class, the module's restriction is the root's continuation of the process's steps (`steps_keeping_iff`: `Steps (keeping P Same) s t ↔ «续» (Steps P) Same s t`). What it reaches is the start or the line under the class (`reach_keeping_iff_line`). So the possible with a part held is what the line from `s` under `Same` admits, or `s` itself (`possibleHeld_iff_line`), and `Reach.keeping_mono` is coarsening (`«粗化»`) read on processes. The tower law has a root form for every carrier and relation (`ji_line_of_chain`). On a chain of coarsening relations, where every step of a relation is a continuation under some member, whatever the relation reaches lies on a line under some member. The tower is an instance (`sameFrom_class`, `tower_ji_line`).

*Fix.* AGENTS.md asks new results to be stated on the grammar where possible. Land P9, with the root lemma named in the root's vocabulary. State the held possible in the root's words in the header and the record, and give the record's base as "root; any process, and witnesses".

#### M6. Prose terms for the landing section

- **"Part".** 07 §2's opening (line 35) speaks of "what a part does": a part of the exchange whose taking and giving is withheld. The module's part is a relation on configurations. In 07's prose write "what is held", and "the held possible".
- **"Levels".** In 07 §2 and the World, levels are condition levels, and `Becoming.Tower` (Tower.lean line 36) has levels of refinement. In prose write "the rules from height `n` up" and "the rule at height `k`". The Lean may keep `SameFrom`.
- **`Climbing` and `Climb`.** `Climbing` would sit in the same section as UE10's `Climb`, two witnesses with near-identical names. Renaming one is optional, for example `RaisedRule`.

#### M7. Landing home and texts

*Recommendation.* Home the record in 07 §2, directly after `r-what-a-course-keeps-reachable`. The reasons:
- Every law is about UE10's `Reaching.Possible` and 07's keeping widening, and continues UE10's third law.
- UE10's reading ends "growth of the possible itself would need a process that changes, which no law here states", which UE11 answers and which would be false of the section once UE11 lands.
- The two records pair.
- The gate instance (M3) and the converse's failure (M4) mirror UE10's laws in the same section.

02's section reads rules changing themselves in the grammar's regularity. UE11 adds no reading of the rule's regularity, so a one-line pointer from 02 suffices, placed outside the record-bound theorem paragraph.

*Texts.*
The proposed texts are given as source, so that their links, written for the chapters, are not links of this review.
- **07 §2, UE10's reading, last clause.** Replace "growth of the possible itself would need a process that changes, which no law here states" with:

  ```markdown
  the possible grows only relative to what is held, and only where what is held changes ([below](#r-where-the-possible-grows))
  ```
- **01's Open item, self-changing conditions.** Replace "Not yet stated: a change of the law of change with no fixed law above it, or a space of rules not given with the carrier;" with:

  ```markdown
  A tower of rules with no top, each rule changed as the one above allows, is stated on processes as one process with a fixed scheme ([07 §2](07-SIGNIFICANCE.md#r-where-the-possible-grows)): every possibility of it is had with the rules from some height up held, nothing is added to its whole possible along a course, and the possible with the rules from any height up held keeps widening only where those rules change without end. Not yet stated: a change of the law of change with no fixed scheme, or a space of rules not given with the carrier; the tower in the grammar's terms;
  ```

  With P10 landed, add after "change without end": ", which on a witness they do, each rule changing once, while every formation stays possible". With P9 landed, drop "the tower in the grammar's terms;".
- **Base.** "(any process, and witnesses)", or "(root; any process, and witnesses)" with P9.

### Notes

- **N1. The deviations from DESIGN, judged.**
  - `keeping` for `Process.keeping`: avoiding the foundation's namespace is right, and the bare name is R3's problem.
  - The bounded-stretch departures: the stronger form (M2).
  - `RuleTower.possible_iff_held`, unplanned: the module's strongest tower statement, worth keeping. Its premise is finite support per move (M3).
  - The whole-possible statements left as instances of `Run.possible_of_next` for `adaptive F G` and `RuleTower.process`: right, since a named wrapper would not be another result. The record should name them as instances: "`Run.possible_of_next` at `adaptive F G` and at `RuleTower.process base up`".
  - `RuleTower` for the design's `Tower`: right, since `Becoming.Tower` is a landed structure.
  - `Run.possible_of_stretch` for the design's `Run.possible_of_within`: more general and right.
  - The planned positive tower law is missing, and P5 restores it, located.
- **N2. Listed along.** `Run.not_heldKeepsWidening_of_listed` asks for a list holding the whole possible from the start. `Reaching.KeepsWidening.not_listed` needs only a list holding the held possibles along the course. UE10 split its law this way for horizons (`Reaching.not_keepsWidening_of_listed_along`, ReachableRanges.lean line 678), and the same split would give a stronger held law. Optional.
- **N3. "Held" is read move by move.** The restriction asks for `Same` between the two configurations of each move, not between each configuration and the start. For a class the two agree. For a relation that is not transitive, the held possible is not "what is possible with the part as it is at `s`". `SameFrom n` is a class (`sameFrom_class`), so the tower is unaffected. One line in the modelling list would say this.
- **N4. Formations.** `X : Type` is as in UE10's `Reaching.Possible`; nothing to change here.
- **N5. Clash.** P12 is clean. The probes' witness names (`Copying`, `Sync`, `Oscillating`, `RisingRule`) live in the probe namespace. Landed as they are, `Copying` would clash with `Becoming.Copying`, and the others are free.
- **N6. Significance.** Every law is near-definitional, as the header says:
  - laws 1 and 2 are `Reaching.Possible.of_reach` and its iteration over a stretch;
  - law 3 is their instance at the held moves, and the adaptive law is its instance;
  - the tower law is an induction on traces.

  The content is in the reading and the witnesses. `Climbing`, and P7, P10 and `Sync` if landed, show what the negative laws allow and what they forbid, and P9 places the held possible in the grammar. Law 3 is stated in substance, by definition, in Banzhaf and others (2016), and the tower law's finite support is in substance the reflective towers' (R5). I found no neighbour that states either as a law on any process. The record's standing is "near-definitional laws and witnesses".
- **N7. Process.** DESIGN §8 plans a re-check of the fold-in. R1–R3 and any landed probe should be rebuilt there with their axiom reports, and P12 re-run after the rename.

## What holds

- Every theorem is correct as stated, with an empty axiom report. Runs are built (`Climbing.course`), never chosen, and no choice principle enters.
- Laws 1–3 and the adaptive law prove what their docstrings say, apart from the wording in M1. `adaptive_keeps_rule_iff` is exact.
- `RuleTower.process` matches its docstring: the move `0` changes the state as level `0` allows; the move `k + 1` changes level `k` as level `k + 1` allows; the state and every other level are kept. `step_sameFrom`, `trace_held` and `possible_iff_held` are correct for it.
- `Climbing` shows what it says. With the rule held, the possible at step `k` is what lies at most `k`, so it keeps widening in 07's form read from the first step, while every formation is possible from every configuration of the course.
- The module imports only core modules, and none of its names clashes with the package (P12).

## Verdict

**Can land after the required changes.**

In the module:
- R1: the top law's docstring, or P8 added and cited.
- R2: Climbing's closing sentence.
- R3: rename `keeping` and land the two `rfl` instance theorems.

In the note and record:
- R4: the reading in the glossary's terms. "What a course adds is the actual"; 生生不息 placed with `«生生不息»` and D5, needing no growth of the whole possible; "no top fixed for good", never "no level fixed for good"; widening at every height claimed only with P10 landed.
- R5: the credits corrected. Law 3 is Banzhaf and others' innovation, restated as a law on any process. Taylor and others report Banzhaf's model-relative novelty and McMullin's change at the highest control levels, not a closed-system debate. Add Adams and others for state-dependent rules, and the reflective towers for the tower law's finite support, both marked as needing a check. Bateson's levels run from 0 to IV.

The record must state:
- the laws in the corrected docstrings' terms, with the whole-possible statements named as instances of `Run.possible_of_next`;
- the base: any process and witnesses, or the root as well with P9;
- the modelling premises: discrete steps; the held part a relation read move by move; formations by name over one type fixed across steps; the tower's rules a sequence indexed by the natural numbers, each move keeping the rules from some height up; the scheme fixed;
- the standing: near-definitional laws and witnesses;
- what stays open: a change with no fixed scheme, a space of rules not given with the carrier, and, unless P7 and P9 land, sufficiency and the tower in the grammar.

Recommended before landing: M3 (the tower's premise and positive law) and M4(a) (the converse's failure), since both settle claims the header makes or leaves open. The rest of M1–M7 is optional.
