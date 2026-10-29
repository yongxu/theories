# WRP: processes represented in the grammar both ways, designed

**Status: reviewed once and re-read; every finding of both is taken ([REVIEW-WRP](REVIEW-WRP.md)). Part 1 then follows GrammarLaws' owner's decision on the composite along a word (§4). WRP2 implemented it ([LANDING](LANDING.md)); its Lean was reviewed once, every finding taken ([REVIEW-WRP2](REVIEW-WRP2.md)), and §8 maps the design's names to the implemented ones and says what WRP2 settled that is proposed here.**

AI-written study, 29 October 2026. Board item WRP, asked by the session coordinating the unification in its note of 29 October ([WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md)). That note calls the theorems that read no field of the old base "the largest remaining question of the lifting: whether their statements can be put in the grammar's terms", and proposes to take them whole, through a representation of processes. This is a design; it lands no Lean.

What it answers:
- WHAT-REMAINS' question, for the part of that layer stated on processes, and how large that part is.
- The first boundary the record [the-world-represented-both-ways][WRT record] names ("Processes; …"), and its next step, "A representation theorem for processes".
- 01's Open item on faithful representation, and question 55 of the [logic dossier][LOGIC], for processes.

**Evidence.**
- *The statements marked checked.* They were proved in [`check/tree/Becoming/WRPCheck.lean`](check/tree/Becoming/WRPCheck.lean): 53 theorems in 66 declarations, every axiom report empty, no warning ([log](check/scratch-11.log)). That is a working build, not a receipt. The reviewed version is [scratch-9.log](check/scratch-9.log), 37 theorems in 50; the 16 since are §4's composite laws and cases.
- *What the check builds on, all landed:*
  - `moveRel` ([GrammarRegularity]), `«能»` ([GrammarCandidates]), `AlikeTo` ([Likeness]) and `Law.step` ([GrammarCourse]);
  - `edgeProcess` ([EdgeClosure]); `withMove` and `unlabelled` ([Labelled]);
  - `KeepsMoving`, `KeepsMoving.run`, `DependentChoice` and `runs_iff_dependentChoice` ([Onward]);
  - `FactorsThrough` (Experiment); `trace_nil_iff` and `trace_cons_iff` ([GenerativeCore]);
  - `«一一对应»` and `«对应之像»` ([GrammarTransport]), and `«迭»` (GrammarLaws).
- *The counts* come from [`measure_wrp.py`](measure_wrp.py), saved as [`measure.json`](measure.json), at core receipt `20261029T104256.342764Z`.
- *Its history.* The design's first version redefined four landed notions and left frames out of its count; the review found both, and its re-read found nine more items (§6).

## Summary

- **How much of the no-field layer WRP reaches.** At the receipt, 11,409 source theorems read no field of the old base.
  - 3,163 of them (28%) are stated on processes.
  - 1,306 (11%) bind a process (984) or only a frame (322).
  - Of the other 8,246, 1,343 name nothing beyond the grammar: 950 name no Becoming constant at all, and 393 grammar terms only. The grammar's and the prelude's own laws are among them.
  - The remaining 6,903 (60%) are about other structures. The largest groups are optima (291 in `Optimum`), weightings (172), regime margins (152), one-step laws (140), presence (137), interleavings (123), ideals (115), the hexagram model (90) and populations (84). WRP does not reach them.

  So the representation of processes takes whole only the part on processes. OU's plan, §十三 item 13, now says so (`2e37676f9`).
- **Where the laws on processes hold is given by definition.**
  - A process is exactly its relations, one per move (`moveRel`, landed), both ways by `rfl`. So a theorem quantified over processes is, as stated, a law of all relations indexed by moves on its carriers, under its hypotheses.
  - One that reads a process only through its steps is a law of every relation (`forall_steps_iff`, checked), since every relation is a process's steps.
  - This is 08 §6's third requirement, the representation theorem, for processes. It carries a law's truth to every relation, not its statement into the grammar's terms.
- **Whether the statements are in the grammar's terms is decided notion by notion.** The 1,306 binding statements name 322 process notions.
  - 15 of those notions have landed grammar readings, and they cover every process notion named in 51 statements.
  - WRP2 would bridge 11 more, which brings the count to 194 statements.
  - The other 1,112 statements name some of 296 further notions. The most named are likeness by bisimulation (`Alike`, 66 statements), the order of stretches (`stretchOrder`, 40), `SameBranchingTests` (38) and `Adheres` (33). Each needs its own bridge, or its theorems stay stated with their model.
- **The model, and where the moves sit.** A model in 01 §8's sense gives the grammar "a carrier, a relation read as 缘 and the classes it uses".
  - *The steps.* On the configurations alone, the one relation is the steps, and it forgets the moves (F1). On a finite carrier with two or more moves, no relation on the configurations is faithful at all: there are fewer relations than processes.
  - *The move inside.* The landed `withMove` puts the move in the carrier. On that fixed carrier it recovers the process (checked).
    - Up to correspondence, neither class alone is enough. The twist keeps "the same move", and the flip keeps "the same configuration"; each relates the models of two processes that no renaming relates (both checked).
    - That the two classes together suffice is proved in WRP2, from a configuration and a move (§8).
    - Its image is exactly the relations leaving the next move open (checked; F3).
  - *One relation per move.* The moves need not be in the carrier: the relations of the moves on the configurations are the process itself.
- **Forward and converse.**
  - *Forward.* Notions are grammar terms at the moves' relations, notion by notion. Landed: closure, return, merging nothing, determination, going alike, the image along a map, steps counted, and a deterministic law's step, constancy and core. Checked here: enabledness as «能», a trace as the composite along its word, runs as images of the line of steps, factoring through a map, and going on along some branch.
  - *Converse.* Every relation is a process's steps (`edgeProcess`). All relations indexed by moves are a process's moves. Every class is a frame's class of claims (checked).
- **Where it fails.**
  - **F1.** The steps forget the moves (witness, checked).
  - **F2.** On the grammar, going on along some branch gives a line exactly under dependent choice (checked), read from Onward's landed calibration. Within finitely many configurations nothing is chosen (checked).
  - **F3.** The one-relation model with the move inside restricts its image, and neither class alone makes it faithful up to correspondence (witnesses, checked).
  - **F4.** The grammar relates three carriers, the factors and their product, only through maps, since it forms no pairing.
  - **F5.** A deterministic law's image is read through its map.
- **One item, WRP2.** It has two parts:
  - the grammar layer: transport along maps and correspondence lemmas in `Becoming.GrammarTransport`; and, by GrammarLaws' owner's decision, the composite along a word of relations in `Becoming.GrammarLaws`, with six laws of `«迭»` derived from it as cases, their statements and names unchanged;
  - a leaf module, `Becoming.ProcessRepresentation`, with one record homed at 01 §8.1.

## 1. What "represented both ways" means for processes

### 1.1 Two senses

As in [WRT's design](../world-representation/DESIGN.md) §1.1:
- **(i) Per notion:** a process notion is equivalent to its grammar term.
- **(ii) Per model:** forward, the process's notions are grammar terms at the model it determines; converse, which grammar models are processes'.

WRP answers (ii) out of representations in sense (i).

### 1.2 The model of a process

A `Generative.Process S A` is a relation `step : S → A → S → Prop`, read as admissible changes by moves.

| model | carrier | relations | faithful | image |
|---|---|---|---|---|
| the steps (01 §8.1's row) | `S` | `Steps P`: some move takes one to the other | no (F1) | every relation |
| the move inside (`withMove`, Labelled) | `S × A` | `(s, a)` to `(t, b)` where `a` takes `s` to `t`; classes "the same move" and "the same configuration" | on the fixed carrier; up to correspondence, not with either class alone (F3) | the relations leaving the next move open (F3) |
| the moves' relations (`moveRel`, GrammarRegularity) | `S` | one relation per move | yes, by definition (`moveRel_mk`, `mk_moveRel`, `rfl`) | all relations indexed by moves |

What the models carry besides:
- **A frame's claims.** Each claim is a predicate on configurations, read as its partial identity (`Web.partialIdentity`, landed with WRT2, for carriers in `Type`). Their class, "alike in every claim", is likeness to depth zero (`AlikeTo F F 0`, Likeness).
- **A run.** A run's configurations carry the line of steps (`Steps.next`, 01 §8.1) into the steps: the image of the line along them lies within the steps (`run_image`, checked). With the move inside, a sequence is a run's configurations and moves exactly where the image of the line lies within that model's steps (`run_iff_image`, checked). So nothing is left to choose.

**Must the moves be in the carrier?** It depends on what "one relation" is asked to carry.
- **On a finite carrier,** with `n ≥ 1` configurations and `k ≥ 2` moves, no relation on `S` can be faithful. There are `2^(n²)` relations on `S` against `2^(kn²)` processes. This is a counting remark, not in Lean.
- **On an infinite carrier,** a faithful one-relation model on `S` itself exists through a bijection `S ≅ S × A`, where one exists (`Nat ≅ Nat × Bool`, for instance); for `A` larger than `S`, counting rules it out. But such a bijection is a coding chosen from outside, not a reading of the process.
- **With the move inside the carrier,** `withMove` recovers the process on its fixed carrier (`step_iff_withMove`). Grammar terms read a model only up to correspondence (GrammarTransport), and up to correspondence neither class alone is enough:
  - the twist keeps the same-move class;
  - the flip keeps the same-configuration class;
  - each relates the models of two processes that no renaming relates (checked).

  That a correspondence keeping both classes is a product of renamings is proved in WRP2, from a configuration and a move (§8).
- **Its image.** On `n ≥ 1` configurations and `k` moves, the relations on `S × A` leaving the next move open are `2^(n²k)`, as many as the processes. That is out of `2^(n²k²)` relations on `S × A`.
- **With one relation per move,** the moves' relations on `S` are the process.

### 1.3 The forward direction

As for the World, the forward direction is a schema, discharged notion by notion (§2).

**A law's truth, carried (checked).**
- `forall_steps_iff`: a property of a carrier and a relation, kept by relations alike pointwise («谓»), holds of every process's steps exactly where it holds of every relation. The proof takes the one-move process of the relation.
- `forall_moveRel_iff`: a property of every process's moves' relations is a property of all relations indexed by moves, with no hypothesis. It is currying, by `moveRel_mk`.
- What these show is where the laws hold. Restating a theorem's statement in the grammar's terms (08 §6's lifting) is still per notion, and a theorem reads only the steps where each notion it names is a function of them. `Reach`, `Invariant`, `Returns` and `Lossless` are. `Determined`, `GoAlikeUnder`, `Enabled` and `Trace` read the moves, and are terms at the moves' relations.

**Transport along maps (checked).** For a map between carriers:
- preserving steps along it is the image («像») lying within the other relation (`preserves_iff_image`);
- going on along some branch is pulled back along lifting (`yan_pullback`);
- ending on every branch is pulled back along preservation («尽之拉回», landed with WRT2).

These are the one-step and the going-on counterparts of GenerativeCore's `projection_exact_iff`. That theorem states exact finite-trace representation, and they do not state it.

A process factors through a map exactly where, at each move, the image of its relation lies within the other's (`factorsThrough_iff_image`, checked). The image process is the grammar's image at each move (`image_step_iff`, landed).

### 1.4 The converse

**The image is every relation and all relations indexed by moves (checked).**
- Every relation is the steps of the one-move process of its edges (`edgeProcess`; `steps_edgeProcess`).
- All relations indexed by moves are a process's moves (`moveRel_mk`, `rfl`).
- Every class is the class of claims of a frame whose claims are the carrier, realized where the class relates (`class_is_claims`, at `AlikeTo F F 0`).

The World's image is graded and conserving. A process adds nothing to the grammar but the index of its moves; a run adds a choice of course (F2), and a frame its claims.

**With the move inside (checked).** A relation on `S × A` is a process's model with the move inside exactly where it leaves the next move open (`withMove_image_iff`). `withMove_open` (landed) is one direction. A relation reading the next move is no process's model (`reading_next_move_not_withMove`).

**Question 55, for processes.**
- The moves' relations are a bijection, by definition, between processes and families of relations.
- Morphisms are not defined here. Question 55's functor form would take as morphisms the maps under which each move's relation factors (`FactorsThrough`, by `factorsThrough_iff_image`). It would also need correspondence lemmas for the terms WRP2 reads (`«延»`, `«迭»`, `«迭内»`, `«闭»`, `«定后»`, `«定前»`, `«同行»`), which `Becoming.GrammarTransport` lists since WRP2, each read where a renaming keeps the notion bridged through it (§8).
- Audit and representation make the laws over processes grammar laws in content, since the converse is total. They do not put a statement in the grammar's vocabulary: that is §2.3's per-notion work.

## 2. Audit: what exists, what is missing, what it covers

### 2.1 The bridges landed

| process notion | grammar term | Lean |
|---|---|---|
| a move | a relation (缘) | `moveRel` (GrammarRegularity) |
| the steps | the union of the moves' relations | `Steps` (Frame), by definition |
| reach | lying within the closure of the steps (`«所闭»`); reached on a line under the one | `reach_iff_withinClosure` (Frame), `withinClosure_iff_reached` (GrammarScope) |
| the seed–edge closure (`Closure`) | lying within the closure (`«所闭»`) of the edges from one seed | `withinClosure_iff_closure` (EdgeClosure), for `X : Type` |
| an invariant | a region closed under the steps (`«闭»`) | `invariant_iff_closedUnder` (Frame) |
| returning; merging nothing | reaching itself along the steps (`«及»`); a fixed predecessor of the steps (`«定前»`) | `returns_iff_reaches`, `lossless_iff_fixedBefore` (Recurrence) |
| determined | each move's relation with a fixed successor (`«定后»`) | `determined_iff_fixed` (Laws) |
| going alike under a description | going alike (`«同行»`) at each move, the description read back along the map | `goAlikeUnder_iff_alike` (Laws) |
| going alike, where every move is possible (and, for the converse, the process determined) | the map's class constant (`«有常»`) under every move | `constant_of_goAlike`; `goAlike_iff_constant` (GrammarRegularity) |
| the image process | the image (`«像»`) of each move's relation; determined where alike go alike | `image_step_iff`, `image_determined_iff` (Mechanism) |
| a trace of `k` moves; within `n` moves | `k` steps (`«迭»`); within `n` steps (`«迭内»`), the word forgotten | `trace_iff_steps`, `withinMoves_iff_withinSteps` (Labelled) |
| a deterministic law | its step relation (`Law.step`); constancy is keeping a relation; sameness of future is the core (`«核»`); likeness is the core; an unending line is a constant course | `Law.step`, `constant_iff_keeps`, `core_is_sameFuture`, `alike_iff_core`, `unending_iff` (GrammarCourse); `next_fixed`, `next_total` (Recurrence) |
| a frame's claims | each the partial identity of its predicate; their class, likeness to depth zero | `Web.partialIdentity` (WorldRepresentation), `AlikeTo` (Likeness) |

Related laws that state no grammar term: `same_steps_iff_traces` (a law is fixed by its traces), `Run.toWithMove` and `Run.ofWithMove` (runs of the two readings), and `KeepsMoving.run` (a run within finitely many configurations, nothing chosen).

### 2.2 What WRP2 adds

- **M1. The process as its moves' relations.**
  - `moveRel_mk` and `mk_moveRel` (`rfl` both ways);
  - `steps_iff_moveRel`;
  - `steps_edgeProcess` and `steps_unlabelled`;
  - `steps_lawProcess` (a deterministic law's steps are `Law.step`);
  - `enabled_iff_neng` (enabledness is «能» at the move's relation, by definition).
- **M2. The truth of a law, carried:** `forall_steps_iff` and `forall_moveRel_iff`.
- **M3. The converse:**
  - `class_is_claims`;
  - `step_iff_withMove` and `withMove_image_iff`;
  - the witnesses: `reading_next_move_not_withMove`, the twist (`Twist.models_correspond`, `Twist.not_renamed`), the flip (`Flip.models_correspond`, `Flip.not_renamed`) and the forgotten moves (`Forgotten.moves_forgotten`).
- **M4. The forward bridges not landed.**
  - *A trace as a composite.* `wordRel` is the composite of relations along a word (`«静»` and `«而»`), in GrammarLaws (§4, Part 1). Its case for one relation repeated is `«迭»` (`wordRel_replicate`). With it come `trace_iff_wordRel` and `feasible_iff_wordRel`.
  - *Runs.* `run_image` and `run_iff_image`.
  - *Factoring.* `factorsThrough_iff_image`.
  - *Going on along some branch:* `yan_iff_keepsMoving` and `run_yan`.
- **M5. Transport along maps:** `preserves_iff_image` and `yan_pullback`.
- **M6. The calibration read on the grammar.**
  - `yan_line_iff_dependentChoice`, from Onward's;
  - its finite case, `yan_line_of_list`, from `KeepsMoving.run`.

### 2.3 What it covers, measured

**Method.** [`measure_wrp.py`](measure_wrp.py) restores the spine's constants from the checker cache at core receipt `20261029T104256.342764Z`, with nothing compiled, through [EC's measure](../ec-elegant-completion/measure.py). Its output is [`measure.json`](measure.json), and its criteria are stated in its docstring and printed with the output.
- **No field.** The statement and proof reach none of the old base's eight fields, in any of their sixteen projections. Reaching is found by a search along the reversed dependencies, whose result does not depend on order. Generated lemmas are dropped, the structural recursion lemmas among them.
  - Only projections are read. 18 theorems that build or match the four structures through constructors or eliminators alone (e.g. `World.run_world`) count as reading no field.
- **On processes.** The statement names a process or its step, a trace, enabledness, feasibility, a product, a run or its configurations, moves or window, a frame or its process or claims, the steps, reach, an invariant, or a deterministic law.
- **Binding.** The statement's type names a process, or a frame only.
- **Notions.** Definitions taking a process or a frame.
- **Bridged.** An explicit list, with each notion's reading.
- **"Naming a grammar term."** It means naming a constant with «» in its name, so it misses the readings named in English (`moveRel`, `WithinClosure`, `Law.step`).
- **The first count.** It had two faults. Its search for what reaches a field depended on the order of iteration over sets, so repeated runs gave 11,446 to 11,451. And it kept 21 generated recursion lemmas.

**The layer.**
- **No field.** 16,797 source theorems lie in the 340 spine modules (16,800 at receipt `20261029T084618.786422Z`, before OU3f retired three twins; every other figure here is the same at both). 11,409 of them read no field: this is the audit's 9,370 of 13,828 (at `0cc1aafb4`) at a later head.
- **On processes.** 3,163 of the 11,409 (28%) are stated on processes, in 167 modules.
  - 444 reach processes through deterministic laws only.
  - 91 already name a grammar term.
- **Not on processes.** 8,246 are not.
  - 1,343 name nothing beyond the grammar: 950 name no Becoming constant, and 393 grammar terms only.
  - The remaining 6,903 (60%) are about other structures. The largest modules are `Optimum` (291), `Weightings` (172), `RegimeMargin` (152), `OneStep` (140), `Presence` (137), `Interleavings` (123), `Ideals` (115), `HexagramPlaces` (90) and `Population` (84).

**Binding.**
- 1,306 of the 3,163 bind a process (984) or only a frame (322).
  - Each binding a process is a law of all relations indexed by moves on its carriers, under its hypotheses.
  - Each binding only a frame is a law of every such family with claims. That follows by the same definition, though the lemma is stated for processes only.
  - So where these laws hold is answered for all of them at once.
- The other 1,857 name a constructed process, or reach processes through a law. They are laws of their models or of the deterministic laws.

**Their statements, notion by notion.** The 1,306 statements name 322 notions.
- **Bridged now.** The 15 notions with landed readings cover every process notion named in 51 statements: the steps, a step, a move's relation, reach, invariants, returning, merging nothing, determination, going alike and going alike under a description, within `n` moves, the image process, and a frame's process, construction and claims.
- **With WRP2.** WRP2 adds 11: enabledness, traces, feasibility, runs with their configurations and moves, families that keep moving, `withMove`, `unlabelled`, `Law.process` and factoring through a map. That brings it to 194 statements.
- **Left.** The other 1,112 name some of 296 further notions, the most named:

  | notion | statements |
  |---|---:|
  | likeness by bisimulation (`Alike`) | 66 |
  | `stretchOrder` | 40 |
  | `SameBranchingTests` | 38 |
  | `Adheres` | 33 |
  | `Run.stretches` | 32 |
  | `BranchingTest.Holds` | 32 |
  | `Reaching.heldMoves` | 28 |
  | `DeterminedAt` | 26 |
  | likeness to depth `k` (`AlikeTo`) | 25 |
  | `coupled` | 24 |
  | `Refutable` | 22 |
  | `Reaching.Possible` | 22 |

  Each is its own bridge, or its theorems stay stated with their model.

These are counts of dependency and of names, not of meaning.

## 3. Where it fails

### F1. The steps forget the moves

```lean
def byTrue : Process Unit Bool := ⟨fun _ a _ => a = true⟩
def byFalse : Process Unit Bool := ⟨fun _ a _ => a = false⟩
theorem moves_forgotten :
    (∀ s t, Steps byTrue s t ↔ Steps byFalse s t) ∧ Enabled byTrue () true ∧ ¬ Enabled byFalse () true
```

Checked, in the namespace `Forgotten`. The two have the same steps, and only the first is enabled by `true`. A notion reading the moves is not a statement at the steps. `forall_steps_iff` applies only to properties of the steps.

### F2. A line from going on along some branch is a choice

```lean
theorem yan_iff_keepsMoving : «延» (Steps P) «一» x ↔ ∃ K : S → Prop, K x ∧ Onward.KeepsMoving P K
theorem yan_line_iff_dependentChoice :
    (∀ (α : Type) (R : «际» α) (x : α), «延» R «一» x → ∃ f : Nat → α, f 0 = x ∧ ∀ n, R (f n) (f (n + 1))) ↔
      Onward.DependentChoice
theorem yan_line_of_list (every : ∀ x, x ∈ all) (goes : «延» R «一» x) :
    ∃ f : Nat → α, f 0 = x ∧ ∀ n, R (f n) (f (n + 1))
```

All three checked.
- **The bridge.** Going on along some branch of the steps is lying in a family that keeps moving, both ways.
- **The calibration.**
  - From dependent choice to lines, the proof is Onward's `runs_iff_dependentChoice`, read through the one-move process of the edges. The other direction is direct.
  - The statement is for relations on types of the first universe.
  - It adds no calibration: 08 §5's row for dependent choice already reads "an infinite course choosing each next step", with "none … needed within finitely many configurations".
- **Within finitely many configurations,** going on gives a line with nothing chosen (`yan_line_of_list`, from `KeepsMoving.run`).
- **The contrast that needs no choice.** The landed «不穷则迭»: a line that never ends has steps of every length, each finite, but not one infinite line.
- **On the steps,** a sequence whose image lies within the steps is a run's configurations only with a move chosen at each step. That is countable choice, which the core does not assume; the claim is not checked. With the move inside, it is a run (`run_iff_image`), and nothing is chosen.

### F3. The one-relation model with the move inside

```lean
theorem withMove_image_iff : (∃ P : Process S A, «谓» (Steps (withMove P)) R) ↔ ∀ x t b b', R x (t, b) ↔ R x (t, b')
theorem reading_next_move_not_withMove : ¬ ∃ P : Process Unit Bool, «谓» (Steps (withMove P)) (fun _ y => y.2 = true)
theorem Twist.models_correspond :
    «谓» («像» e.to (Steps (withMove P₁))) (Steps (withMove P₂)) ∧ «谓» («像» e.to sameMove) sameMove
theorem Flip.models_correspond :
    «谓» («像» e.to (Steps (withMove P₃))) (Steps (withMove P₄)) ∧ «谓» («像» e.to sameConfiguration) sameConfiguration
-- and in each namespace, `not_renamed`: no renaming of configurations and moves relates the two processes
```

All checked.
- **Its image is restricted.** A relation that reads the next move is no process's model.
- **The twist keeps the same-move class.**
  - `P₁` steps exactly from `true`.
  - `P₂` steps by `true` from `false`, and by `false` from `true`.
  - `twist` flips the configuration where the move is `true`, and carries one model to the other.
- **The flip keeps the same-configuration class.**
  - `P₃` steps by `true` everywhere.
  - `P₄` steps by `false` at `true`, and by `true` at `false`.
  - `flip` flips the move where the configuration is `true`.
- **In both, no renaming relates the two processes.** So up to correspondence, neither class alone makes the model faithful. That the two together do, from a configuration and a move, is proved in WRP2 (§8).

### F4. Composition across carriers

`productProcess P Q` lives on `S × S'` with a move shared.
- **The product is a grammar model on `S × S'`.** At each move, its relation is the meet (`«合»`) of the factors' relations read back along the two projections, written as a function of the coordinates. The landed bridges read back the same way (`goAlikeUnder_iff_alike`, `«像定后当且仅当同行»`), and `sameValue` (GrammarCourse) names reading back «静».
- **What the grammar does not do** is relate the three models, `S`, `S'` and `S × S'`, as one construction. That takes pairing, which the grammar does not form.
- **What is landed:**
  - forgetting the move of a joint step leaves a step of each part (`unlabelled_product_le`, Labelled);
  - a shared move couples the parts: the product of the forgetful processes admits a step that no joint move gives (`Fork.label_couples`, Unfolding).
- **Its standing.** This is a boundary of the grammar's operations, not a refutation. Functional pairing in the calculus is the corpus side of the same question, 08 §6's open one.

### F5. Deterministic laws

`Law.process next` steps from `s` to `next s` only. Its steps are `Law.step next` (`steps_lawProcess`, checked), which is functional and total (`next_fixed`, `next_total`, landed for the relation `next x = y`).
- That every functional total relation is a law's step is unique choice on one carrier, which the core does not assume.
- Whether it can be derived here is not shown. It is a boundary, not a result.

**The failure, written down.**
- Processes are represented both ways by their moves' relations, by definition.
- The steps forget the moves (F1).
- A line from going on is a choice, except within finitely many configurations (F2).
- The one-relation model with the move inside restricts its image, and neither class alone makes it faithful up to correspondence (F3).
- Composition relates carriers through maps (F4).
- The deterministic laws are read through their maps (F5).
- Most of the no-field layer is not on processes at all (§2.3).

## 4. The item

The item is WRP2. Every statement is core, fixed before its proof, and no landed definition changes. The statements below were checked in scratch, except where marked proposed. The names are proposals, fixed at the Lean stage with a clash check against the whole package.

### Part 1: the grammar layer

**In `Becoming.GrammarTransport`** (this session's module, so these are additions there):
- **Transport along maps.** `preserves_iff_image` and `yan_pullback`. They take Chinese names in the module's style; the second sits beside «尽之拉回».
- **Correspondence lemmas** for `«延»`, `«迭»`, `«迭内»`, `«闭»`, `«定后»`, `«定前»` and `«同行»`, on the module's pattern. *Checked in WRP2, with a consumer: a renaming keeps the bridged notions (§8).*

**In `Becoming.GrammarLaws`: the composite along a word.** GrammarLaws' owner chose this placement (option (a)): one law of composition along a word, with iteration as its case for one relation repeated, in place of a second law beside it (board rule 9). It holds a trace's word, which is what makes a process faithful (F3), where `«迭»` reads a trace only with its word forgotten.

- **Conditions, from the owner.**
  - `«迭»` keeps its definition, the recursion on numbers, and every statement and name in GrammarLaws and in the modules that use it stays as it is.
  - A law is derived only where the composite's law replaces part of its proof, never rerouted only to move a count.
  - The name is in the grammar's vocabulary.
  - At landing, the core receipt and the signature audit show only additions in GrammarLaws and the changed proofs, with no statement changed, and the measure is reported before and after.
- **The composite and its laws (checked).**
  - `wordRel`, placed before `«迭»`: `«静»` on the empty word, `«而»` for each letter.
  - `wordRel_replicate`, beside `«迭»`'s definition: `«迭»` is the composite's case for one relation repeated.
  - The composite of two words is the composite of the composites (`wordRel_append`); the last letter is read last (`wordRel_snoc`).
  - The reversed word with the converse family is the converse (`wordRel_reverse`).
  - Where no letter's relation merges, the composite merges nothing (`wordRel_fixedBefore`).
  - Where every letter's relation goes alike under `E`, the composite keeps `E`-alike occurrences alike (`wordRel_alike`, placed after `«同行»`).
  - Helpers on lists, each by its own induction: `replicate_add_right`, `replicate_succ_right`, `reverseAux_append_right`, `reverse_cons_right` and `reverse_replicate`. Core's `List.reverse_cons` reports `propext`, so the reverse-cons step is proved here.
- **The laws of `«迭»` that go through as cases (checked, statements unchanged).** Each has its induction carried by the composite's law, and its proof would be replaced by the case:
  - `«迭之接»` and its converse `«迭之分»`, by `wordRel_append`;
  - `«迭之末步»`, by `wordRel_snoc`;
  - `«迭之逆»`, by `wordRel_reverse`;
  - `«迭之定前»`, by `wordRel_fixedBefore`;
  - `«同行之迭»`, by `wordRel_alike`.

  `«迭之分»`, `«迭之定前»` and `«同行之迭»` were not among the owner's expected three. They go through, so they are taken.
- **The laws that stay, with their reasons.**
  - `«迭则及»`, `«及即迭»` and `«迭则同一或及»` read one relation's closure (`«及»`). A family's counterpart would be the closure of its union, a different law.
  - `«迭之周»` iterates `«迭之接»` over multiples of a loop. Its composite form needs powers of a word, a detour.
  - `«迭内之接»` follows from `«迭之接»` with no induction of its own. `«迭内即静或缘之迭»` relates `n` steps of staying or stepping to at most `n` steps, which no law of the composite states. With `«迭即历»` it writes `«迭内»` as the composite of the constant `«静或缘»`, so the composite form exists, and there is no induction left to replace. (The review of WRP2's Lean corrected this line, which said "at most `n`" had no composite form.)
  - `«迭之定于»` reads a fixed successor along the relation's own closure from `x`, which the composite does not read.
  - `«迭之定»` is a one-line corollary of `«迭之定于»`, and `«同行于迭»` a one-line corollary of `«同行之迭»`. Rerouting either would only move a count.
  - `«或有后则或迭»` and `«不穷则迭»` read successors along one relation's line.
  - `«承之迭»` reads a course of regions round by round. A word form would be a new law that nothing reads, so it keeps its induction, and `«存承之迭»` is its corollary under staying or a step. (Added after the review of WRP2's Lean.)
- **The name: «历», adopted by GrammarLaws' owner.**
  - `«历» F w` relates `x` to `y` exactly when `y` is reached by passing through the word's relations in turn. `«迭»` is «历»'s case for one relation repeated.
  - Its docstring states the operation, not the etymology: "passing through a word's relations in turn (历); «迭» is its case for one relation repeated". (The owner's first wording, "its constant family", was changed after the review of WRP2's Lean flagged it as a second sense of "family".)
  - *The reading* [AI reading]: 歷, glossed in 說文 as 過也, passing through, as in 歷代 and 歷數.
  - «历» is used nowhere in the package or in 01. The glossary's 历程 (a course) is the path such a passage makes, so the two readings agree.
  - The scratch keeps the structural name `wordRel`, and the names of the laws on it are fixed at the Lean stage with a clash check.

### Part 2: `Becoming.ProcessRepresentation`, the record's module

It is a leaf. It imports `Becoming.EdgeClosure`, `Becoming.GrammarTransport`, `Becoming.Labelled`, `Becoming.Onward`, `Becoming.GrammarRegularity` and `Becoming.GrammarCandidates`; its import closure is about 100 modules.

Its contents, with the checked statements:
- **The model:** `moveRel_mk`, `mk_moveRel`, `steps_iff_moveRel`, `steps_edgeProcess`, `steps_unlabelled`, `steps_lawProcess` and `enabled_iff_neng`.
- **The truth of a law, carried:** `forall_steps_iff` and `forall_moveRel_iff`.
- **The converse:** `class_is_claims`, `step_iff_withMove`, `withMove_image_iff` and `reading_next_move_not_withMove`.
- **The two witnesses on classes:** `Twist.models_correspond`, `Twist.not_renamed`, `Flip.models_correspond` and `Flip.not_renamed`. Proved alongside in WRP2: from a configuration and a move, the two classes together make every correspondence a renaming (§8).
- **Forward:**
  - `trace_iff_wordRel` and `feasible_iff_wordRel`, on the composite in GrammarLaws;
  - `run_image` and `run_iff_image`;
  - `factorsThrough_iff_image`;
  - `yan_iff_keepsMoving` and `run_yan`.
- **The calibration read on the grammar:** `yan_line_iff_dependentChoice` and `yan_line_of_list`.
- **F1's witness:** `Forgotten.moves_forgotten`.

**The record: processes represented both ways, home 01 §8.1.**

What it says:
- A process is exactly its relations, one per move.
- The image is every relation and all relations indexed by moves.
- A law over processes holds of all relations indexed by moves, and one reading only the steps holds of every relation.
- The forward bridges, notion by notion.
- **Its limits,** as plainly as the success:
  - the steps forget the moves;
  - a line from going on is a choice;
  - the one-relation model with the move inside restricts its image, and neither class alone makes it faithful;
  - composition relates carriers through maps;
  - deterministic laws are read through their maps;
  - the process part is 28% of the no-field layer.

Its boundaries:
- the statements of the 1,112 binding theorems whose notions are not bridged, notion by notion;
- the 6,903 theorems of the no-field layer about other structures;
- the counting remarks, not in Lean;
- morphisms beyond correspondences (the product of renamings and the correspondence lemmas, proposed here, are proved in WRP2, §8);
- the composite's further laws, if a consumer needs them.

**Text at landing.**
- **01 §8.1** gains the theorem block after its table, and the table's process row names the moves' relations and the model with the move inside.
- **01's bases line** now reads "(any process), (any type): every step relation or type, not yet in the grammar's vocabulary". It would split into:
  - (any process): every process, read by its moves' relations (§8.1), its statement in the process's vocabulary;
  - (any type): every type, not yet in the grammar's vocabulary.
- **01's Open entry** on faithful representation and **08's Open entry** on representation theorems: processes are shown.
- **The record the-world-represented-both-ways:** its does-not-show item beginning "Processes;" and its next step, "A representation theorem for processes", point to the new record.
- **The glossary** gains "the relations of a process, one per move (`moveRel`)".
- **WHAT-REMAINS** is its owner's. The answer and the counts are reported to the coordinating session, not edited here.
- **The modules join** the root module, the checker's core list and the package README rows.

## 5. Review

One independent reviewer, Opus and read-only, read the design and its check against the package and the measurement artifacts.
- **The review.** It rebuilt the check from identical bytes and wrote a test file of its own. It found 16 problems: seven errors (1–5, 8, 9), four gaps (6, 7, 10, 12), four wordings (11, 13–15) and one naming (16).
- **The re-read.** It read the revisions and wrote a second test file, whose checks are now in this one. It confirmed the other fixes and found nine more items:
  - three substantive: the share of other structures overstated, new names clashing with landed ones, and the classes half checked;
  - six of wording or placement.

All of both are taken; [REVIEW-WRP](REVIEW-WRP.md) gives each with what was done.

## 6. What the review changed

- **Duplicates dropped.** `StepsBy` is the landed `moveRel`, the class of claims is `AlikeTo F F 0`, a deterministic law's steps are `Law.step`, and enabledness is «能» at a move's relation. The check now uses them and defines none of them.
- **Faithfulness corrected.**
  - On the fixed carrier, the move inside is faithful. Up to correspondence, neither class alone is enough, as the twist and the flip show.
  - The counting argument is scoped: finite carriers, at least one configuration, at least two moves. On an infinite carrier, a coding exists where a bijection does.
- **The count redone.**
  - Frames are counted among the binders: 322 more theorems.
  - The landed bridges are counted in full.
  - The search for what reaches a field no longer depends on order, and generated recursion lemmas are dropped.
  - The script is saved, and the counts are taken at the current head.
- **The share said first.** 28% of the no-field layer is on processes, and 11% binds a process or a frame. 60% is about other structures; the rest names nothing beyond the grammar.
- **Standing stated.** The truth-carrying lemmas meet 08 §6's representation requirement, not its lifting, and are renamed (`forall_steps_iff`, `forall_moveRel_iff`). The going-on lemmas keep the package's pinyin stem `yan_`, since `goesOn` names an ideal's notion in HistoryIdeals.
- **F2 made exact.** Which direction uses Onward, the universe, the finite case on the grammar, 08 §5's row in place of the earlier quotation, countable choice named, and «不穷则迭» as the contrast.
- **F4 rewritten.** Reading back along a map is used by the landed bridges too, so the product is a model on its own carrier. The boundary is relating three carriers without pairing, and no term is proposed for it.
- **The rest.**
  - Transport is called the one-step and going-on counterpart of `projection_exact_iff`.
  - `FactorsThrough` is bridged.
  - F5 claims no independence.
  - The composite along a word is grammar-layer, with `«迭»` its checked case. GrammarLaws' owner then chose to place it in GrammarLaws with six laws of `«迭»` derived from it (§4).
  - §2.1's rows say what each bridge needs.
  - The witnesses have namespaces, and the names state what they prove.
  - The glossary entry avoids "family", which names 同族 and Onward's families that keep moving.


## 7. Lessons

- **Core's `List.reverse_cons` reports `propext`.**
  - Anyone using a list's reverse in the core meets it, as the core's own `Nat.succ_ne_zero` and its list membership lemmas do.
  - The reverse-cons step is proved here from `List.reverseAux`, by induction: `reverseAux as (r ++ s) = reverseAux as r ++ s`, then that law at `[]` and `[a]`.
  - WRP2's record carries this when it lands.
- **Search for a landed construction before defining one.** The first draft redefined `moveRel`, `AlikeTo`, `Law.step` and `«能»`, and the first check redefined `edgeProcess`, `withMove` and Onward's `DependentChoice`. A search of the package by statement shape would have found each.
- **A model with extra coordinates in its carrier is faithful up to correspondence only if its classes fix those coordinates.** The twist and the flip show that neither class alone does.
- **A count must not depend on iteration order.** The first count's memoized search for what reaches a field decided some constants before their dependencies, so its results moved between runs. Search along the reversed dependencies instead, and rerun under two hash seeds.
- **Say what share a representation reaches before what it shows.** Most of the no-field layer was not on processes at all.

## 8. What WRP2 implemented

WRP2 implemented §4 ([LANDING](LANDING.md)). One review of its Lean found twelve points, every one taken ([REVIEW-WRP2](REVIEW-WRP2.md)).

**Names as implemented.** Where the design's names were scratch names, these are the landed ones.

| design | landed |
|---|---|
| `wordRel` | `«历»`, adopted by GrammarLaws' owner |
| `wordRel_replicate` (an equality of relations) | `«迭即历»`, pointwise (`«谓»`), since GrammarLaws states no equality of relations |
| `wordRel_append`, `wordRel_snoc`, `wordRel_reverse`, `wordRel_fixedBefore`, `wordRel_alike` | `«历之接»`, `«历之末步»`, `«历之逆»`, `«历之定前»`, `«同行之历»` |
| `replicate_add_right`, `replicate_succ_right`, `reverseAux_append_right`, `reverse_cons_right` | `GrammarLaws.replicate_add_append`, `replicate_succ_append`, `reverseAux_append`, `reverse_cons_append` |
| `steps_compose_case` and the other five cases | the proofs of `«迭之接»`, `«迭之分»`, `«迭之末步»`, `«迭之逆»`, `«迭之定前»`, `«同行之迭»`, their statements unchanged |
| `trace_iff_wordRel`, `feasible_iff_wordRel` | `trace_iff_li`, `feasible_iff_li` |
| `preserves_iff_image` | `«保之像»`, with the image on the left as in `«对应之像»` |
| `yan_pullback` | `«延之拉回»`, for any continuation `«续» R L` |
| the classes `sameMove`, `sameConfiguration` | `sameValue Prod.snd`, `sameValue Prod.fst` (GrammarCourse), the landed class |
| `Twist.twist`, `Flip.flip` | `Twist.flipConfiguration`, `Flip.flipMove` |

**What WRP2 settled that is proposed here.**
- *Faithfulness up to correspondence with both classes.* A renaming relating two processes is a correspondence of their models with the move inside carrying the steps and both classes (`withMove_of_renaming`). Conversely, from a configuration and a move, such a correspondence is a renaming relating them, the product of a renaming of configurations and one of moves (`renaming_of_withMove`). With no move, or no configuration, the point is needed (`NoMoves.not_renamed`, `NoConfigurations.not_renamed`).
- *The correspondence lemmas, with a consumer.* A renaming relating two processes keeps every bridged notion: traces, with the word renamed letter by letter (`renaming_trace`, through `«历之对应»`); `n` steps and within `n` steps; reach, returning and invariants; determination and merging nothing; going alike under a description read back; and going on along some branch (`renaming_iterate`, `renaming_reach`, `renaming_returns`, `renaming_invariant`, `renaming_determined`, `renaming_lossless`, `renaming_goAlike`, `renaming_yan`). That is what faithfulness up to correspondence gives the notions §2.1 bridges.
- *Passing through a word, carried with its letters renamed* (`«历之像»`); `«迭之像»` is its case for one relation.

**What the review of the Lean changed.**
- The correspondence lemmas had no consumer. They now have one: the renaming theorems above.
- Duplicates were replaced by what is landed:
  - `sameValue` for the two classes;
  - `factorsThrough_iff_image` proved from Mechanism's `factors_image` and `Image.least`.
- `«迭之像»` is derived from `«历之像»`.
- The laws of `«迭»` that keep their proofs each state their reason, `«承之迭»` included (§4, Part 1).
- "Family" is kept for its glossary sense: a process's relations are "indexed by moves".
- The witnesses are named in parallel, with the case of no configuration added.
- One lemma states the steps of a one-move process (`steps_one_move`).


[WRT record]: ../../../../../../theories/becoming/results/records/the-world-represented-both-ways.md
[LOGIC]: ../../../../../../theories/becoming/review/LOGIC.md
[GrammarRegularity]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarRegularity.lean
[GrammarCandidates]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarCandidates.lean
[Likeness]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Likeness.lean
[GrammarCourse]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarCourse.lean
[EdgeClosure]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EdgeClosure.lean
[Labelled]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Labelled.lean
[Onward]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Onward.lean
[GrammarTransport]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarTransport.lean
[GenerativeCore]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/GenerativeCore.lean
