# WRT: the World's representation theorem, designed

**Status: revised after the first review and its second pass.** [REVIEW-WRT.md](REVIEW-WRT.md) holds both reviews: the first has 24 findings and the second pass 14 more, besides three of the first that the revision had taken only in words. Every one is taken, and §6 maps each to its change. A last read of the changed sentences and of the build log found one false sentence and four nits, all taken; with them the item is proposed on the board. The draft the first review read is at `f77db78f7`.

AI-written study, 28 October 2026. It was drafted at `155d53242` and revised on main at `80c4c40d6`. This is board item WRT, claimed by the session Unification and coherence progress (fork 2) at the request of the session Unification and coherence progress. It is a design, and it lands no Lean. The brief is [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), "After EC6's audit", order 3.

What it would complete:
- OU's completion criterion 7, its last part: [OU plan §十三](../one-unfolding-root/PLAN.md), "旧 World 的表示定理两个方向证明（或其失败写明）".
- Lifting's third requirement, [08 §6](../../../../../../theories/becoming/chapters/08-METHOD.md#expressible-is-not-derived): "the model shown to be a model of the grammar both ways, or the failure written down".
- [01's Open item](../../../../../../theories/becoming/chapters/01-ROOT.md#open) on faithful representation, for the World.
- Question 55 and the weakness of L-21 in the [logic dossier](../../../../../../theories/becoming/review/LOGIC.md).

The statements marked *checked* were proved in two scratch files, built on the checkout at `80c4c40d6`: 28 theorems in 44 declarations, every axiom report empty ([log](check/scratch-10.log)).
- [`WRTCheck.lean`](check/tree/Becoming/WRTCheck.lean) holds the draft's 14.
- [`WRTCheck2.lean`](check/tree/Becoming/WRTCheck2.lean) holds the revision's 14.

That is a working build, not a receipt. The item would state them again in its own modules.

## Summary

- **Two senses of "both ways."**
  - Per notion, as in [08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#7-master-laws-and-connectivity): a model's notion is equivalent to its grammar term.
  - Per model, as in OU's criterion 7: forward, each World notion is a grammar term at the World's model; and converse, which models are Worlds'.

  WRT is about the second, and its forward direction is made of the first.
- **The occurrence model.** Its carrier is the occurrences, a relatum at a step. It has two parts.
  - **The name-free part** reads no name at two steps, so every re-identification carries it. It selects:
    - the same-step class and conservation's step;
    - activity and presence, held as partial identities;
    - the relations within a step: requiring, drawing, a need met, giving, taking, and the partial identity of standing.

    Amounts are read only by sign, against a need, and in conservation's equation.
  - **The names** are the names' step, and whatever reads one name at two steps.
- **Forward.** This direction is a schema, discharged notion by notion by the instance theorems and by WRT's additions (recurrence at the model, carrying by re-identification). Transport lemmas make each listed term invariant under one-to-one correspondence. So every listed term at the name-free part is fixed under re-identification.
- **Converse.**
  - Activity, requiring and drawing range over all relations, and presence over all finite lists, so the relational part's image is every such model.
  - Conservation's image is exactly the relations "the standing after the step, plus a debit, is a credit", for an inhabited type of relata.
  - What amounts induce is decided, and along a line falls end.
- **Failure on amounts.**
  - At this selection, the model forgets the standing: worlds standing at `k` and at `k′`, both positive, have the same model.
  - Balance is carried by conservation's step alone, which is defined from the balance equation.
  - Amounts in `Nat` limit and condition the relations they induce: conservation is never identity on the predicates of `Nat`, and a line of falls never goes on without end.
- **One item.** WRT2 has its lemma module WRT1 and one record.

## 1. What "represented both ways" means

### 1.1 Two senses

The phrase has two senses in the repository.

- **(i) Per notion.** In 08 §7, "represented both ways" says of balance that `Flow.Balances` is equivalent to its grammar statement (`Flow.balances_iff_units`): an anchor's equivalence with its grammar term. Each instance theorem of 01 §8.6 is a representation in this sense.
- **(ii) Per model.** OU's criterion 7 asks for 两个方向.
  - Forward: the World's notions are grammar terms at the model the World determines.
  - Converse: which grammar models are Worlds', so that a World law can be told from a grammar law.

WRT answers (ii). Its forward direction is made of representations in sense (i).

### 1.2 Grammar models

A model of the grammar is a carrier with relations on it: a 缘 `R : «际» α`, classes (`«类» E`), and partial identities.

- **Partial identities.** A predicate `P` is held as a partial identity, the coreflexive relation `«合» «静» (fun x _ => P x)`, as [01 §7](../../../../../../theories/becoming/chapters/01-ROOT.md) and `Becoming.GrammarLaws` already read what a path admits (`Web.admitted`).
- **Pointwise comparison.** The grammar compares relations pointwise (`«谓»`), never by equality, and so uses no `propext` or `funext` (`Becoming.Grammar`'s header).
- **Maps and counts.** The grammar maps a relation along a map by `«像»`, the image, which the lumping law reads (`«像定后当且仅当同行»`). It counts by pairing, `«对»`.

What it does not state is that its terms are kept by a one-to-one correspondence of models.

### 1.3 The occurrence model a World determines

The carrier is `Nat × w.Relatum`: the occurrences, a relatum at a step.

**The name-free part.** These relations and partial identities read no name at two steps: each reads one step, or conservation's equation across one step. Every re-identification reads the relata of each step through `σ.old` at that step (`World.reidentify`), so it carries every such relation.

Re-identification carries more than the model selects. It also carries:
- partial identities such as "standing `k`";
- the order of two standings, and comparisons of standings across a step;
- the step order;
- how often a relatum appears in the presence list.

The model selects among them:
- amounts are read only by sign, against a need, and in conservation's equation;
- the index is read only through the same-step class and the steps' own 缘.

F1 and the step-permutation example of §1.5 hold at this selection.

| relation or partial identity | Lean | what it reads | kind |
|---|---|---|---|
| same step | `fun x y => x.1 = y.1` | the shared index of steps, a commitment of the model ([01 §10](../../../../../../theories/becoming/chapters/01-ROOT.md): discrete steps, one shared index) | class |
| conservation's step | `Web.continuationStep w.Conserves` | one step's standings and exchange: "Only the relations of the step are read; no identity across it is used" (`World.Conserves`) | 缘, advancing the index by one |
| activity; presence | partial identities of `w.web.active` and of membership in `w.flow.present` | one step | partial identities |
| requiring; drawing; a need met; taking | `«逆»` of `withinStep` of `requires`, `draws`, `need ≤ level` and `0 < take`, so the condition `c` is a 缘 of `f` (`requires t f c` reads `c` as a condition of `f`) | one step; the last two read amounts by order and sign | 缘 within a step, which may loop (`requires t f f`) |
| giving; standing | `withinStep` of `0 < give`, from giver to receiver; the partial identity of `0 < level` | amounts at one step, by sign | 缘 within a step; partial identity |

**The index is a commitment.** What shows of it is the partial order of joined exchanges ([01 §9.6](../../../../../../theories/becoming/chapters/01-ROOT.md)). A world's reorderings keep that order and change the index (`reordering_iff_course`, UE15); inserting idle steps changes it too.

**The names.**

| relation or partial identity | Lean | what it reads | kind |
|---|---|---|---|
| the names' step | `Steps.along`, equivalent to `Web.continuationStep Web.itself` (`along_iff_itself`: checked) | identity across a step, given by the World's single type of relata: a model commitment | 缘, advancing the index by one |
| what reads one name at two steps | `Web.Falls` (one name's level at `t` and `t + 1`); `Web.dependenceClass c` (one condition across steps); the class of the same relatum in `Web.carrierClass` | the names | partial identities and classes |

**Classes and supplied continuations.**
- Classes are read off predicates by `Web.alikeBy`. The instance theorems use:
  - activity (`Web.activityClass`);
  - holding (`Web.stateClass` at `h := Web.Holds`, a snapshot predicate);
  - the dependence's class (`Web.dependenceClass c`);
  - the one (`«一»`);
  - the class of `p` along the steps (`Steps.alike p`);
  - the carrier class, which reads the names.
- A continuation the World does not determine, such as a lineage's or the passing premise's, is supplied as `Web.continuationStep K`. This is 01 §8.6's "the module's own relation".

**What the model does not hold.** At this selection, no relation of the name-free part holds an amount as a number, the step order, or the order or multiplicity of the presence list. With the names, the step order is a grammar term (`later_iff`).

### 1.4 The forward direction

A World notion `N` is represented at the model when an instance theorem gives `N w ↔ T (model w)` for a grammar term `T`. The grammar is embedded shallowly and has no syntax of terms, so this direction is a schema, discharged notion by notion; §2 lists the instances. Two further pieces surround it.

**Transport (WRT1, lemmas).**
- For each listed term, a one-to-one correspondence carrying the relations and partial identities the term reads carries the term. So each represented notion keeps to correspondences of the part its term reads.
- That a term makes its notion keep to correspondences is what WRT1 proves. That keeping to correspondences gives a term is no statement the shallow embedding can make.

**Re-identification.** Every re-identification `σ` is a correspondence of the name-free part (WRT2). At each step it is the correspondence `σ.old t`, with inverse `σ.new t`. On occurrences it is `(t, x) ↦ (t, σ.old t x)` (`reidentifyAt` and `reidentifyOcc`: checked). The parts are carried as follows:
- conservation through `σ.carry` (`conserves_reidentify`: checked);
- the relations within a step pointwise (`withinStep_carried`: checked as a general lemma and applied at requiring; drawing, a need met, giving and taking are the same application, by definition; standing, a partial identity, is carried directly by the definition of `World.reidentify`);
- presence through the existing `Reidentify.mem_map` (`present_carried`: checked).

So every listed term at the name-free part is fixed under re-identification. The names' step is carried only by a renaming that is the same at every step.

The existing re-identification laws are of three kinds:
- **Cases of this carrying.** `Web.line_reidentify` and `continuing_reidentify`. Re-deriving them through transport would be rerouting, and is not proposed.
- **When a re-identification keeps a notion that reads the names.** `World.balanced_reidentify_iff`: balance reads the names, and the law says which namings keep it.
- **Laws of the web's re-identification.** `metAboveAlong_reidentify`, `widensAcross_reidentify` and `Web.rename_*` use `Web.reidentify`, which renames formations and keeps conditions fixed, not the World's, which renames both roles.

### 1.5 The converse

**(a) The relational part.** Every choice of activity, requiring and drawing (any relations at each step) and of presence (any finite list at each step) is some World's. That World has zero amounts (`World.of`), and its model's relational part is the chosen one, pointwise. So the image of the relational part is every model of that shape:
- one line of steps for each relatum along the names;
- any partial identities and relations within a step;
- presence finite at each step.

**(b) Supplied continuations.** Any relation that advances the index by one.

**(c) What amounts induce:** conservation, a need met, giving, taking, falling and standing.

- **Conservation, exactly.** Every World's conservation has the form `level (t + 1) f + debit t g = credit t g`, with `g` credited with its standing and what it is given, and debited what is taken from it. That half is near-definitional, as balance's representations are.
  - The content is the other half: with one relatum `r₀` exchanging, debit and credit are arbitrary, so every relation of that form is some World's (`ofExchange_conserves`: checked). The characterization is therefore exact for an inhabited type of relata.
  - Read through one conserving pair, the form says that `g` conserves into exactly the relata standing after the step as that pair's does (`conserves_iff_same_level`: checked). For a balanced world, conservation is likeness of standing after the step (`World.conserves_iff`).
  - So conservation is difunctional, its blocks told apart by standings. A difunctional relation whose blocks no standing can tell apart is not conservation (F2).
- **Decided.** Each relation amounts induce is an equation or an order of whole numbers, so it is decided (`conserves_decided`: checked). On one relatum, conservation is `Q` across every step exactly where `Q ∨ ¬ Q` (`conservation_iff_decided`: checked).
  - What it says about the unfolding: what amounts induce is decided, while activity, requiring and drawing, which are propositions, need not be.
  - The finite-world law of arising and ceasing needs activity decided. Asked of every finite world without that, the law is exactly excluded middle (`World.law_iff_em`), and `World.law_iff_positions` reads the need as deciding every position along the steps.
  - Embodiment supplies the decision. Where every relatum stands as a condition exactly while it is active, standing, an amount's sign, decides activity (`World.Embodied.decided`).
- **Ending.** Along the names, a line of falls ends (F3).
- **Joint conditions** tie the relations together. For example, suppose `g` conserves into both `f` and `f′` across a step, and some `h` into both across the next. Then `f` falls across the next step exactly where `f′` does.
- **The exact image.** The listed conditions do not exhaust the amount part's image. Its exact image is the near-definitional one: what whole-number standings, needs and exchange induce.

So the converse is shown for the relational part, and conservation's image is characterized exactly. The failure in the rest of the amount part is written down with witnesses (§3). With WRT1, a model in correspondence with one in the image has the same listed terms. That such a model lies "in the image up to correspondence" is definitional.

**What the World adds to the grammar:**
- on the step 缘, the grading: no cycle, and reach a strict order (`Web.reach_strict_order`); the relations within a step can loop;
- the same relata at every step;
- presence finite at each step;
- from amounts in `Nat`: decidedness, conservation's form, and the ending of falls.

A law of the World that is no grammar law uses something of the image: one of these, or a further condition of the amount part's near-definitional image. The converse lets that be checked, by a model outside the image where the law fails.

**Question 55.**
- *Its form.* The representation is an interpretation of Worlds into grammar models with partial identities.
  - Each listed term is invariant under correspondence.
  - It is faithful on re-identifications, since a re-identification is determined by its correspondence.
  - It is not full. Suppose nothing joins the steps: there is no conservation across them, and the selected relations are constant in time. Then a correspondence of the name-free part may permute the steps, and no re-identification does. A correspondence that also carries the names' step fixes the index.
  - It is not injective on amounts (F1).
- *Whether audit, lifting and representation make a sound criterion.* The three, without the converse, do not make a grammar law: a statement can be expressible, audited and represented and still be a law of the image only (F3). So the criterion needs the converse to tell a grammar law from an image law.

## 2. Audit: what the instance theorems give

| World notion | grammar term | Lean | both ways (sense i) | 缘 |
|---|---|---|---|---|
| arising; ceasing | an active occurrence beginning, ending, under activity | `Web.arises_iff_sheng`, `Web.ceases_iff_wang` | yes | `Steps.along` |
| renewal | `«复生»` with the formation still active | `Web.renews_iff` | yes | `Steps.along` |
| holding through dormancy | beginning and ending under the state class | `Web.arises_iff_sheng_state`, `Web.ceases_iff_wang_state` | yes, where activity lies within holding | `continuationStep` of the names |
| coming to be; ceasing to be | beginning, ending along the steps under the class of `p` | `comesToBe_iff_sheng`, `ceasesToBe_iff_wang` | yes | `Steps.next` on `Nat` |
| arising without end | late active beginnings | `Web.unceasing_iff_late_beginnings` | yes, reading `N < y.1` off the index | `Steps.along` |
| arising, ceasing, abiding under a continuation | `«生»`, `«亡»`, `«住»` | `Web.arisesFrom_iff_sheng`, `Web.ceasesFrom_iff_wang`, `Web.abides_iff` | yes; `abides_iff` given that the occurrence after is active | supplied |
| no split; no merge | at most one 续 forward; back | `Web.noSplit_iff`, `Web.noMerge_iff` | yes; `split_fission` and `merge_candles` add the shapes, one way | supplied |
| lineage; links; holding; continuing | lines under activity, the one, the dependence's class | `Web.lineage_iff_line`, `linked_iff_line`, `held_iff_line`, `continuing_iff_line` | yes; `held_iff_line` given the dependence held | supplied |
| lines through a re-identification | lines of the carried continuation | `Web.line_reidentify`, by `line_image` | yes | supplied, carried |
| passing | `«有前»` under the pattern's class; beginning and ending under the carrier class; `«异»` | `byPassing_iff_hasPred`, `arises_iff_sheng_carrier`, `ceases_iff_wang_carrier`; `passesAt_of_alters`, `alters_of_passes` | the first three yes; the last two one way each, not an iff | the passing continuation |
| carrying renewal | `«传»` | `Web.carries_iff`, `Web.passing_carries_iff` | yes, from an active occurrence (`start`); under passing, for a carrier | supplied |
| arising and ceasing under every naming that keeps the balance | beginning and ending under conservation | `World.arises_fixed_iff_sheng`, `World.ceases_fixed_iff_wang` | yes, in a balanced world with equality of relata decided | conservation |
| balance | the names within conservation; a pairing of unit lists; the rest idle | `World.balanced_iff_conserves` (for every naming, `World.balanced_reidentify_iff`); `Flow.balances_iff_units`; `World.withRest_closed_iff` with `Flow.balances_iff_idle` | yes, near-definitional, all three | conservation; units; an added relatum |
| the arising–ceasing law of every finite world | every position decided | `World.law_iff_positions`, `World.law_iff_grammar_positions` | a lemma of the law ([01 §8.2](../../../../../../theories/becoming/chapters/01-ROOT.md#r-map-of-premises)), not an instance | — |
| 火传; falling dormant; waking | ending under a finer class and not a coarser: `«异»` | `Web.passing_fire`, `Web.fallsDormant_alters`, `Web.wakes_alters` | laws of the World read in the grammar, one way by nature | — |

Two notes on the table:
- The rows mix `Steps.along` with the names' continuation `Web.continuationStep Web.itself`. The two agree (`along_iff_itself`: checked), but no lemma states it.
- The forward direction is nearly done for the continuation family.

What is missing:

- **M1. Transport.**
  - What exists: `«像»` maps a relation along a map, and the lumping law reads it; `line_image` carries lines along any map that carries 续; and the re-identification laws of §1.4 carry particular notions.
  - What is missing: that each grammar term is kept by a one-to-one correspondence.
- **M2. Recurrence at the model.** `World.ArisingRecurs`, which is `Web.Unceasing`, and `World.CeasingRecurs` compare steps across relata, reading `N ≤ t` off the index.
  - At the model, "later" and "at the same step or later" are reached along the names and then read across by the same step: `x.1 < y.1 ↔ «而» («及» Steps.along) sameStep x y` (`later_iff`: checked), and the same form with `«所闭»` for `≤`.
  - The empty world needs a conjunct saying an occurrence exists.
  - Nothing states either form.
- **M3. The premises at the model.**
  - Balance, at the identity naming: the names lie within conservation (`World.balanced_iff_conserves`). For every naming: `World.balanced_reidentify_iff`. Nothing is to be added.
  - Support, only active giving and taking, and embodiment (activity exactly the partial identity of standing) are inclusions of partial identities and relations within a step at the model, by definition.
  - The census (`World.Counted`) is a list of the relata active at each step, each once. It is a statement with lists at the model, kept by re-identification, so it is forward by definition.
  - Dissipation (one unit less) and bounded transmission (one bound) read amounts.
- **M4. Re-identification.**
  - Conservation's carrying is `σ.carry w.Conserves` pointwise (`conserves_reidentify`).
  - `World.arises_fixed_iff_sheng` and `ceases_fixed_iff_wang` give the other direction for single positions: what holds under every naming that keeps the balance is what holds under conservation.
  - `Web.steady_held` and `Web.renewingIn_held` speak of the names themselves (a naming keeps one name over a stretch). They are laws of the correspondence, not terms.
- **M5. The converse.** `World.of` builds a World from any web and flow, so the constructions exist. What is missing is the statement of the image and of its conditions.

## 3. Where it must fail

### F1. At this selection, the model forgets the standing

```lean
def standingAt (k : Nat) : World :=
  World.of Unit Flow.still (Witnesses.unrequired (fun _ _ => k) fun _ _ => False)
theorem standingAt_alike {k k' : Nat} (pos : 0 < k) (pos' : 0 < k') (t : Nat) :
    (activity, standing, requiring, drawing, presence, a need met, giving, taking, conservation
      and falling agree between standingAt k and standingAt k' at t) ∧ (standingAt k).web.level t () = k
```

Checked. For positive standings, every relation and partial identity the model selects agrees between the two worlds, while their standings are `k` and `k′`. So no amount, as a number, is a grammar statement at the model. The interpretation is not injective, and the World is not equivalent to its model.

A selection that told standings apart would need, for instance:
- a partial identity for each amount, a family indexed by `Nat`, which puts the amounts into the model's signature;
- unit lists of the amounts' lengths (`Flow.balances_iff_units`).

The grammar has no amounts of its own.

### F1′. Balance lives in conservation's step alone

At the model, balance says the names lie within conservation (`World.balanced_iff_conserves`, `Iff.rfl`). Conservation's step is defined from the balance equation, so this representation is near-definitional.

Without conservation's step, the World's other relations and partial identities do not determine balance.
- **The witness pair.** `World.idle` balances. `idleTwice` is the same world giving itself two units, and it does not.
- **What they share.** They agree on activity, requiring, drawing, presence, a need met, giving and taking, with the same web. This was checked as `balance_not_relational`, whose `Relations` is the proposed `StepRelations`.

Balance has two more representations, both near-definitional:
- unit lists (`Flow.balances_iff_units`);
- an added relatum that is idle (`World.withRest_closed_iff`, with `Flow.balances_iff_idle`).

So balance is represented both ways in sense (i) and derived from nothing. Balance's master law has no grammar reason, since its content is the arithmetic of amounts.

### F2. Identity across a step is not induced by amounts

```lean
theorem not_conserves_identity (L : Flow (Nat → Prop) (Nat → Prop))
    (W : Web (Nat → Prop) (Nat → Prop)) (t : Nat) :
    ¬ ∀ g f, (World.of (Nat → Prop) L W).Conserves t g f ↔ g = f
```

Checked. It has no further hypothesis. The proof has two steps:
- where conservation across a step is identity, the standings after the step tell every two relata apart (`conserves_identity_injective`);
- no map of the predicates on `Nat` into `Nat` is one to one, a diagonal fact taken from `Diagonal.claims_incomplete` (`no_injection`: checked).

Constructively it gives "not identity", not two relata standing alike.

What conservation does fix of identity is already proved. In a balanced world with equality of relata decided, identity across a step is fixed exactly where no other relatum stands alike after it (`World.fixed_iff`, `World.continues_as_alike`; [08 §12](../../../../../../theories/becoming/chapters/08-METHOD.md) item 8). F2 adds only the limit: where the relata are more than standings can tell apart, identity is never conservation's continuation, and the names stay the model's commitment.

### F3. A line of falls ends

```lean
theorem falls_exhaust (w : World) (x : Nat × w.Relatum) (falls : w.web.Falls x.1 x.2) :
    «尽» Steps.along (Web.alikeBy fun y => w.web.Falls y.1 y.2) x
theorem falls_not_endless … : ¬ «不穷» Steps.along (Web.alikeBy fun y => w.web.Falls y.1 y.2) x
theorem everywhere_endless : «不穷» Steps.along (Web.alikeBy fun _ : Nat × Unit => True) (0, ())
```

All three were checked.

- **The derivation.** `falls_exhaust` derives from the amounts' law, `Amounts.falls_end` at `Amounts.whole` with least loss one, through `Amounts.whole_within`. The levels along a line of falls are a course of falls of a whole amount, and «尽» is pulled back along the levels (`jin_pullback`: checked). `falls_not_endless` then follows by `«尽则非不穷»`.
- **An image condition, not a grammar law.** The statement's hypothesis is the predicate of falling. A model with that predicate holding everywhere goes on without end, and it is no World's.
- **Its connections.** The general form, `Amounts.falls_end`, supplies the «尽» that the rest master law takes (`«尽则不屡»`); F3 reads `falls_end` on a World's line. MapInstances' `consumed_held_not_endless` and `family_excess_not_endless` are amount laws of the same kind.
- **What it does not settle.** It bears on 08 §12 item 6, "the absence of an endless fall", only for whole amounts along one relatum's line, and does not settle that item.

Reading [AI]: a pattern whose own class is "alike in falling" cannot be an endless coarse line, and `«全生成»` needs one. A resource falling under another pattern is `dissipation_arising_not_recurring`'s case, not this one.

### Counting

The census is a list at the model and goes forward (M3). Totals of amounts fall under F1.

**The failure, written down.**
- The World's relational part is represented both ways.
- At the model's selection its amounts are forgotten (F1), and they are represented only through relations defined from them (F1′).
- Amounts in `Nat` limit the relations they induce (F2) and add conditions on them (decidedness, F3).

## 4. The item

The item is WRT2, the World's representation. It has one record and two new modules, the first of which holds lemmas.

### WRT1: `Becoming.GrammarTransport`, lemmas (grammar layer)

It imports `Becoming.GrammarLaws`, which imports `Becoming.Grammar` and `Becoming.GrammarMap`. By the package's computed layers it sits at L1. It has no record of its own: definable terms are invariant under a one-to-one correspondence as a fact of the definitional style, so these are lemmas of WRT2's record.

```lean
/-- A one-to-one correspondence of carriers. -/
structure «一一对应» (α : Type u) (β : Type v) where
  to : α → β
  back : β → α
  back_to : ∀ x, back (to x) = x
  to_back : ∀ y, to (back y) = y

/-- Carrying, read through the grammar's image: no new term. -/
theorem «一一对应».carries_iff_image (e : «一一对应» α β) (R : «际» α) (R' : «际» β) :
    «谓» («像» e.to R) R' ↔ ∀ x y, R x y ↔ R' (e.to x) (e.to y)       -- checked
```

The hypothesis "`e` carries `R` to `R′`" is written `«谓» («像» e.to R) R'`. A predicate is carried in the same form, as a partial identity.

For each listed term there is a lemma. Where `e` carries every relation and partial identity the term reads, the term at `x` (or at `x y`) holds exactly where it holds at `e.to x` (or at `e.to x`, `e.to y`). The form of the names is the owner's, for example `«生»之对应`.

- **The listed terms.** These are the terms the instance theorems and WRT2 read:
  - `«及»`, `«续»`, `«相续»`, `«所闭»`, `«所及»` and `«同族»`;
  - `«有前»`, `«有后»`, `«生»`, `«亡»`, `«住»` and `«异»`;
  - `«复生»`, `«不穷»`, `«尽»` and `«核»`;
  - `«传»`, `«全生成»`, `«全守»` and `«有终»`;
  - `«类»`, `«无环»` and `«有常»`, each both ways.
- **The rest.** The rest of the grammar's terms transport the same way, and are added when a consumer needs them. Among them are `«延»` and `«复生至»`, which no module outside the grammar reads, `«息»` and `«生生»`, which only `CausalGrowth` and `HeldPossible` read, and `«位核»`, `«粗»`, `«自持»`, `«相须»`, …, `«生成»`, `«守»`, `«退化»`, `«阶全生成»`, ….
- **Composition and inverse.** Correspondences compose, and `back` is a correspondence carrying back. `«及»` and `«生»` were checked (`Corr.reach`, `Corr.sheng`).
- **«尽»'s pullback.** Along a map that carries 续 on a closed region, «尽» reflects (`jin_pullback`: checked). This is a homomorphism, not a correspondence; F3 uses it.

### WRT2: `Becoming.WorldRepresentation`, the record (World layer)

It imports `Becoming.Persistence`, `Becoming.Diagonal` and `Becoming.GrammarTransport`. `Becoming.Amounts` and `Becoming.Space` come through Persistence (Persistence → Unfolding → Space → InAmounts → Amounts).

- **The model.**
  - `World.sameStep`, a class.
  - `World.conservationStep w`, which is `Web.continuationStep w.Conserves`.
  - `World.withinStep r`, a relation within each step: `fun x y => x.1 = y.1 ∧ r x.1 x.2 y.2`. Read as 缘 under `«逆»` where the field reads its condition second.
  - The snapshot predicates, as partial identities.
  - `along_iff_itself` (checked).
- **Forward.**
  - `World.later_iff` (checked), and the same form with `«所闭»` for "the same step or later".
  - `World.arisingRecurs_iff`, from `Web.unceasing_iff_late_beginnings`.
  - `World.ceasingRecurs_iff`, from `Web.ceases_iff_wang`.
  - Each has the conjunct that an occurrence exists.
- **Re-identification.**
  - `World.reidentifyAt σ t : «一一对应» R' w.Relatum` and `World.reidentifyOcc σ : «一一对应» (Nat × R') (Nat × w.Relatum)` (checked as `reidentifyAt`, `reidentifyOcc`).
  - `World.reidentify_carries`, which covers:
    - conservation's step (`conserves_reidentify`: checked);
    - the same-step class;
    - activity, standing and presence (`present_carried`, through `Reidentify.mem_map`: checked);
    - every relation within a step (`withinStep_carried`: checked, applied at requiring; the others by the same application).
  - One corollary, stated through WRT1 as the pattern for every listed term: beginning under conservation is fixed under re-identification.
- **Converse.**
  - `World.ofRelations`: the relational part realized with zero amounts, with its pointwise lemmas.
  - `World.ofExchange` and `ofExchange_conserves` (checked).
  - `World.conserves_iff_same_level` (checked), and its difunctional corollary.
  - `World.conserves_decided` (checked), and the other relations amounts induce, decided.
  - `World.conservation_iff_decided` (checked).
- **Failures.**
  - F1: `World.standingAt` and `standingAt_alike` (checked, for positive standings).
  - F1′: `World.StepRelations` (what a world holds within each step, with amounts read by sign and order and conservation left out), `World.idleTwice`, and `World.balance_needs_conservation` (checked as `balance_not_relational`).
  - F2: `World.not_conserves_identity` and `World.conserves_identity_injective` (checked), with the no-injection lemma stated as the diagonal fact it is (checked).
  - F3: `World.falls_exhaust`, `World.falls_not_endless` and `World.everywhere_endless` (checked; `Web.Falls` reused).
- **The record.** It is the World's representation, both ways, with its home in 01 §8.6. It says:
  - the relational part is represented both ways;
  - conservation's image is exactly the debit–credit form, for an inhabited type of relata, and it is no finer than standings can tell apart (F2);
  - at the model's selection, standings are forgotten;
  - balance is carried by conservation alone;
  - what amounts induce is decided, and along a line falls end.

  Its boundaries:
  - processes, the other model;
  - the shared index as a commitment, with reorderings and inserted idle steps, since a representation reading only the order of joined exchanges is not given;
  - whether the descent laws follow from F3 with the grammar's laws of finite runs;
  - classes finer than any the World's predicates read;
  - mutual interpretation with a fragment of Lean.
- **Text at landing.**
  - **01 §8.6** gains the forward direction, the converse and the failure. Its "since the grammar states no counting and no map of carriers" is corrected: the grammar counts by pairing and maps by «像», and what it lacks is amounts.
  - **01's *What is not shown* list.** In the line "That no independent entity exists: … and no representation theorem for the World is claimed", only that clause is replaced, by the representation with its failure. The bullet's subject stays not shown.
  - **01 Open.** Faithful representation records that the World's representation is shown both ways for its relational part and is not faithful on amounts. The other models stay open.
  - **08's Open list.** The entry "the lifting, and representation theorems for the World both ways" keeps the lifting and gives the World's representation as shown, with its failure.
  - **The overview**, its two sentences on faithful representation.
  - **The logic dossier**, L-21's weakness line.
  - **The UE15 record** (`reorderings-as-courses-of-growth`), its boundary line on "the World's representation theorem of the one-unfolding plan".
  - **The glossary** gains "occurrence model".
  - **The root module and the checker.** `Becoming.lean`'s imports and `check_becoming.py`'s CORE list take the two modules, and the Lean package README gains their rows in both languages.

## 5. Review

[REVIEW-WRT.md](REVIEW-WRT.md) holds both reviews.
- **The first review** read the draft. Its line numbers `D:` are those of the draft before its status line was added; in `f77db78f7`, add two.
- **The second pass** read the first revision.

The second pass's verdict was that no third full review is needed. **A last read** of the changed sentences and of the build log confirmed every change. It found one false sentence, that no relation of the model holds the step order (true of the name-free part only), and four nits. All are taken (§6), and with them the item can be proposed on the board.

## 6. What the reviews changed

**The first review.**

| finding | change |
|---|---|
| 1 (blocking): the model held classes, but the laws read predicates | Determinations are held as partial identities (§1.2, §1.3). F3 is stated with the predicate as hypothesis, and its counter-model lies outside the image. |
| 2 (blocking): the name-free part still read the names | The name-free part reads no name at two steps and is carried (§1.4, checked). What reads the names is listed apart. The grading is restricted to the step 缘. |
| 3 (blocking): F1 contradicted the model | F1 is the standing forgotten (`standingAt`, checked); F1′ is balance carried by conservation alone (idle and its double). |
| 4: transport does not make the forward direction uniform | The forward direction is a schema, and WRT1 gives invariance for each listed term. |
| 5: the converse was not characterized | The relational part is realized; conservation's image is exact (`ofExchange_conserves`, checked); decidedness is added (checked); joint conditions are noted; "exactly" is scoped. |
| 6: «像» already maps carriers | Acknowledged (§1.2, M1). Carrying is read through «像» (checked). The re-identification laws are sorted (§1.4), with no rerouting. |
| 7: the audit missed existing pieces | `balanced_reidentify_iff`, `World.conserves_iff`, `World.of`, `σ.carry` and `Web.itself` are added (`along_iff_itself`, checked). |
| 8: F3 belongs with the rest law | F3 is stated with «尽», derived from `Amounts.falls_end` (checked), and tied to the rest law and MapInstances. The reading is reworded. |
| 9: F2 omitted hypotheses and duplicated work | Hypotheses are restored. The reading points to `fixed_iff` and `continues_as_alike`. The no-injection lemma comes from `Diagonal` (checked), and the result is "not identity". |
| 10: results over-counted | One record; WRT1 as its lemmas; near-definitional statements kept as lemmas. |
| 11: two senses of "both ways" | Named (§1.1). |
| 12: landing text | Corrected (§4). |
| 13–18 | The passing row is one way; hypotheses are added; `stateClass` at `Web.Holds`; the census is forward and embodiment is in M3; M3 is retitled; the third model of balance is added. |
| 19: names | `«一一对应»`, related to `Reidentify` at each step (`reidentifyAt`, checked); no «携», since carrying goes through «像»; `Web.Falls` reused; `StepRelations`; the no-injection lemma named as a diagonal fact. |
| 20–24 | The redundant imports are dropped. "Up to correspondence" is stated as definitional (§1.5). "Two-valued class" becomes "the class of a predicate". «所闭» is used for reflexive reach. Q55 is answered in both halves. The checks are rebuilt. |

**The second pass.**

| finding | change |
|---|---|
| 1: F1's witness fails at a standing of 0 | Positive standings, with the standing conjunct added; rebuilt (checked). |
| 2: "exactly what re-identification carries" is false | The name-free part is defined as reading no name at two steps, and the selection is stated as a choice. F1 and the not-full example are stated at it. |
| 3: "the undecided part is activity" is false | Activity, requiring and drawing are named. `law_iff_em` is given for excluded middle, and `World.Embodied.decided` for the decision. |
| 4: most re-identification laws are not cases | Sorted into cases, a law about which namings keep balance, and laws of the web's re-identification (§1.4). |
| 5: the step index is a commitment | Stated in §1.3, with reorderings and inserted idle steps among the record's boundaries, and the UE15 record in the landing list. |
| 6–8 | Standing is added to the carrying; requiring, drawing, a need met and taking read under «逆»; "uses something of the image". |
| 9 | The build log and head are corrected (`80c4c40d6`, scratch-10). |
| 10 | "Mark" becomes "partial identity"; the glossary line is added to the landing list. |
| 11 | "A correspondence of the name-free part"; "the three, without the converse, do not make a grammar law". |
| 12 | F3 reads `falls_end`; `Amounts.whole_within` is used; `ceasingRecurs_iff` comes from `Web.ceases_iff_wang`; the classes are listed in full; «延» and «复生至» leave the listed terms. |
| 13 | F2 is in the record; the Amounts import is dropped. |
| 14 | README rows, the UE15 record, and the clause-only change at 01's line. |
| the first review's 7, 19 and 21, taken only in words | `World.conserves_iff` is cited (§1.5); `Reidentify` is related to «一一对应» at each step (checked); "up to correspondence" is stated in §1.5. |

**The last read.**

| finding | change |
|---|---|
| 1: "no relation of the model holds … the step order" is false | "of the name-free part"; with the names, the step order is a grammar term (`later_iff`). |
| 2–5 | "For instance" in place of "would need one of". Standing is carried directly by `World.reidentify`'s definition, not by `withinStep_carried`. «息» and «生生» move to the rest of the terms. `law_iff_positions` decides every position along the steps. |
