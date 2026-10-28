# WRT: the World's representation theorem, designed

**Status: draft, reviewed once and not yet revised.** The review is in [REVIEW-WRT.md](REVIEW-WRT.md): 24 findings, three of them blocking, verdict "another pass". The blocking findings concern §1.2's model (it must hold the determinations' predicates and the same-step relations), the name-free part (exactly what re-identification carries) and F1 (which must be stated against conservation's step). The revision is next, and no item is proposed before it is reviewed again.

AI-written study, 28 October 2026, on main at `155d53242`. This is board item WRT, claimed by the session Unification and coherence progress (fork 2) at the request of the session Unification and coherence progress. It is a design, and it lands no Lean. The brief is [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), "After EC6's audit", order 3.

What it would complete:
- OU's completion criterion 7, its last part: [OU plan §十三](../one-unfolding-root/PLAN.md), "旧 World 的表示定理两个方向证明（或其失败写明）".
- Lifting's third requirement, [08 §6](../../../../../../theories/becoming/chapters/08-METHOD.md#expressible-is-not-derived): "the model shown to be a model of the grammar both ways, or the failure written down".
- [01's Open item](../../../../../../theories/becoming/chapters/01-ROOT.md#open) on faithful representation, for the World.
- Question 55 of the [logic dossier](../../../../../../theories/becoming/review/LOGIC.md): what form the theorem should take.

The statements of the witnesses and of two transport laws were checked in a scratch build: [`check/tree/Becoming/WRTCheck.lean`](check/tree/Becoming/WRTCheck.lean), 14 theorems, every axiom report empty ([log](check/scratch-4.log)). That is a working build, not a receipt, and it lands nothing. The items below would state these again in their own modules.

## Summary

A World determines a grammar model, its **occurrence model**. Its carrier is the occurrences (a relatum at a step). Its relations are:
- the class of being at the same step;
- two 缘: the names' step (identity across a step, a commitment of the model) and the step conservation induces, read off one step's standings and exchange with no identity across it;
- the classes of the World's determinations.

It holds no amount.

**Forward.** A relational World notion is the grammar term at that model.
- The instance theorems give this notion by notion.
- Transport would make it uniform: a one-to-one correspondence of models carries every grammar term.
- The World's re-identifications are correspondences of the name-free part of the model.

**Converse.** The image is:
- every line of steps per relatum, with a two-valued class;
- every graded relation, for a supplied continuation;
- for conservation, only relations labelled by standings in `Nat`.

So the World adds to the grammar its grading, the same relata at every step, the classes of determinations, and two conditions from amounts in `Nat`.

**Failure.** Amounts are not relational:
- **F1.** Balance reads how much is exchanged. Two worlds alike in every relation, and with the same web, differ in balance.
- **F2.** Amounts in `Nat` limit the identity conservation can fix: conservation is never identity on the predicates of `Nat`.
- **F3.** Amounts in `Nat` add a condition the grammar does not have: a line of falls never goes on without end.

**Three items.**
- WRT1: the grammar kept by correspondence.
- WRT2: the occurrence model, forward.
- WRT3: the image and the failures.

## 1. What "represented both ways" means for the World

### 1.1 Grammar models

A model of the grammar is a carrier with relations on it: a 缘 `R : «际» α` and one or more classes (`«类» E`). Every term of `Becoming.Grammar` and `Becoming.GrammarMap` is stated for every carrier and every such relation. The grammar states no map between carriers; that is the reason [01 §8.6](../../../../../../theories/becoming/chapters/01-ROOT.md#instances) gives for leaving the renaming laws out.

### 1.2 The model a World determines

The carrier is `Nat × w.Relatum`: the occurrences, a relatum at a step, as in 01 §8.6. Each relation below is read off the World with nothing supplied:

| relation | Lean | what it reads | kind |
|---|---|---|---|
| same step | `fun x y => x.1 = y.1` (named by WRT2) | the shared index of steps the records commit to, beside amounts counted in `Nat` (`Becoming.World`) | class |
| the names' step | `Steps.along`, equivalent to `Web.continuationStep fun _ g f => g = f` | identity across a step, given by the World's single type of relata; a model commitment, and re-identification changes it | 缘 |
| conservation's step | `Web.continuationStep w.Conserves` | one step's standings and exchange: "Only the relations of the step are read; no identity across it is used" (`World.Conserves`) | 缘 |
| a determination's class | `Web.alikeBy P`: activity (`Web.activityClass`), requiring a condition (`Web.dependenceClass`), presence in the move; their meets with each other (`Web.stateClass`), and with the class of the same relatum, which reads the names (`Web.carrierClass`) | one step's relations | class |
| an amount's sign or order | the same, for a need met (`need ≤ level`), giving or taking (`0 <`), a fall | amounts, read through a sign or an order | class |

A continuation the World does not determine, such as a lineage's or the passing premise's, is supplied as `Web.continuationStep K`. This is 01 §8.6's "the module's own relation". No relation of the model holds the amounts themselves (levels, needs, what is taken and given), or the counts and orders of lists.

This is the World's **occurrence model**. Without the names' step, it is the **name-free part**.

### 1.3 The forward direction

A World notion `N` is *relational* at a part of the occurrence model when it keeps to correspondences: `N w ↔ N w'` whenever a one-to-one correspondence of occurrences carries that part of `w`'s model to `w'`'s. A relational notion is then a property of the model: take `Ψ M := ∃ w, M corresponds to w's part ∧ N w`. That takes two lines and needs no item.

The forward direction proper is the explicit term: `N w ↔ T (model w)` for a term `T` of the grammar. The instance theorems give it notion by notion (§2). Transport makes the direction uniform: a correspondence of models carries every grammar term (WRT1).
- Every term's truth at a World's model is then fixed by the model up to correspondence.
- Every re-identification of a World is a correspondence of its name-free part (WRT2).
- So every term at the name-free part is fixed under re-identification.

The forward direction carries a relational World law to the grammar statement at the occurrence model. Whether that statement is a grammar law, true at every model, is the converse's question.

### 1.4 The converse

These are the models that arise as Worlds' occurrence models.

- **(a) Along the names, under a determination's class.** Every `(Nat × F, Steps.along, Web.alikeBy Q)` is the occurrence model of the World with relata `F`, activity `Q`, and nothing else (`ofActivity_class`, by `rfl`: checked). So the image is one line of steps for each relatum, with a two-valued class. With WRT1, every model in correspondence with one of these is in the image too.
- **(b) With a supplied continuation.** Every relation on `Nat × F` that advances the index by one, `Web.continuationStep K` for any `K`.
- **(c) The name-free part.** Conservation's step is labelled by standings. If `g` conserves into `f` across a step, then it conserves into exactly the relata that stand after the step as `f` does (`conserves_iff_same_level`: checked). So the relation is difunctional, and its blocks are told apart by natural numbers.
  - Every graded relation given with such a labelling is some World's conservation: one relatum exchanging with every other carries the labels. That construction is near-definitional and is not proposed.
  - A difunctional relation with no labelling is not one (F2).

So the World adds exactly these to the grammar:
- the grading: its 缘 advance one shared index by one, so they have no cycle and reach is a strict order (`Web.reach_strict_order`);
- the same relata at every step;
- the classes of its determinations;
- from its amounts in `Nat`, two conditions on the relations those amounts induce (F2, F3).

A grammar law reaches the World by the forward direction. A law of the World that is no grammar law uses one of these, and the converse lets that be checked: a grammar model outside the image where the statement fails is the witness, as F3's is.

This answers question 55: the representation is an interpretation of the World into grammar models, invariant under correspondence, with its image characterized. It is not an equivalence of models, since it forgets the amounts (F1).

## 2. Audit: what the instance theorems give

| World notion | grammar term | Lean | both ways | 缘 |
|---|---|---|---|---|
| arising; ceasing | an active occurrence beginning, ending, under activity | `Web.arises_iff_sheng`, `Web.ceases_iff_wang` | yes | the names |
| renewal | `«复生»` with the formation still active | `Web.renews_iff` | yes | the names |
| holding through dormancy | beginning and ending under the state class | `Web.arises_iff_sheng_state`, `Web.ceases_iff_wang_state` | yes, where activity lies within holding | the names |
| coming to be; ceasing to be | beginning, ending along the steps under "alike in `p`" | `comesToBe_iff_sheng`, `ceasesToBe_iff_wang` | yes | `Steps.next` on `Nat` |
| arising without end | late active beginnings | `Web.unceasing_iff_late_beginnings` | yes, reading `N < y.1` off the index | the names |
| arising, ceasing, abiding under a continuation | `«生»`, `«亡»`, `«住»` | `Web.arisesFrom_iff_sheng`, `Web.ceasesFrom_iff_wang`, `Web.abides_iff` | yes | supplied |
| no split; no merge | at most one 续 forward; back | `Web.noSplit_iff`, `Web.noMerge_iff` | yes (`split_fission`, `merge_candles` add the shapes, one way) | supplied |
| lineage; links; holding; continuing | lines under activity, the one, the dependence's class | `Web.lineage_iff_line`, `linked_iff_line`, `held_iff_line`, `continuing_iff_line` | yes | supplied |
| lines through a re-identification | lines of the carried continuation | `Web.line_reidentify`, by `line_image` | yes | supplied, carried |
| passing | `«有前»` under the pattern's class; beginning and ending under the carrier class; `«异»` | `byPassing_iff_hasPred`, `arises_iff_sheng_carrier`, `ceases_iff_wang_carrier`, `passesAt_of_alters` with `alters_of_passes` | yes | the passing continuation |
| carrying renewal | `«传»` | `Web.carries_iff`, `Web.passing_carries_iff` | yes | supplied |
| arising and ceasing under every naming that keeps the balance | beginning and ending under conservation | `World.arises_fixed_iff_sheng`, `World.ceases_fixed_iff_wang` | yes, in a balanced world with decidable equality of relata | conservation |
| balance | a pairing of unit lists | `Flow.balances_iff_units` | yes, near-definitional | none: units |
| the arising–ceasing law of every finite world | every position decided | `World.law_iff_positions`, `World.law_iff_grammar_positions` | a lemma of the law ([01 §8.2](../../../../../../theories/becoming/chapters/01-ROOT.md#r-map-of-premises)), not an instance | — |
| 火传; falling dormant; waking | ending under a finer class and not a coarser: `«异»` | `Web.passing_fire`, `Web.fallsDormant_alters`, `Web.wakes_alters` | laws of the World read in the grammar, one way by nature | — |

For the continuation family the forward direction is nearly done, notion by notion. What is missing:

- **M1. Transport.** No map of carriers carries grammar terms. `line_image` carries lines one way, along any map that carries 续, and `line_reidentify` uses it both ways for one re-identification. No other term is transported.
- **M2. The same-step class.** Recurrence compares steps across relata, reading `N ≤ t` off the index: `World.ArisingRecurs`, which is `Web.Unceasing`, and `World.CeasingRecurs`. The instance `Web.unceasing_iff_late_beginnings` keeps reading `N < y.1`.
  - At the model, a later step is reached along the names and then read across by the same step: `x.1 < y.1 ↔ «而» («及» Steps.along) sameStep x y` (`later_iff`: checked). Recurrence is therefore a grammar statement at the occurrence model, but nothing states it.
  - The empty world is a boundary case. A world with no relata has no occurrences, so "for every occurrence, some later one" holds there while arising does not recur. The grammar statement needs a conjunct saying an occurrence exists.
- **M3. Balance at the name-free part.** `World.balanced_iff_conserves` (`Iff.rfl`) says each relatum conserves itself. At the model, that is: the names' step lies within conservation's, `«则» Steps.along (Web.continuationStep w.Conserves)`. Nothing states it.
  - The other premises read amounts through a sign or an order. Support reads a need met; only active giving and taking read a positive gift or take. They are therefore inclusions of relations at the model, by definition, and nothing in them is derived.
  - Dissipation (one unit less), the census (a list without repetition) and bounded transmission (one bound) read amounts or counts.
- **M4. Re-identification.** Conservation is carried by every re-identification: `(w.reidentify σ).Conserves t x y ↔ w.Conserves t (σ.old t x) (σ.old (t + 1) y)` (`conserves_reidentify`: checked, from `World.reidentify_taken` and `reidentify_given`). The names' step becomes the carried names, which are the names only for a renaming that is the same at every step.
  - So `line_reidentify` at conservation already fixes conservation's lines. With WRT1, every term is fixed.
  - `World.arises_fixed_iff_sheng` and `ceases_fixed_iff_wang` give the other direction for single positions: what holds under every naming that keeps the balance is what holds under conservation.
  - `Web.steady_held` and `Web.renewingIn_held` speak of the names themselves (a naming keeps one name over a stretch). They are laws of the correspondence, not terms to transport.
- **M5. The converse.** Nothing exists: no World is built from a grammar model, and no image condition is stated.

## 3. Where it must fail

### F1. Amounts are not relational

```lean
theorem balance_not_relational :
    ¬ ∃ Φ : (R : Type) → Relations R → Prop,
      (∀ R (a b : Relations R), a.Alike b → (Φ R a ↔ Φ R b)) ∧
      ∀ w : World, w.Balanced ↔ Φ w.Relatum (relations w)
```

`Relations` reads, at each step: activity, requiring, drawing, presence in the move, giving and taking (a positive amount), and needs met.
- **The witness pair.** `World.idle` has one relatum, never active, standing at the number of steps so far, and giving itself one unit each step; it balances. `idleTwice` is the same world giving itself two units; it does not balance (checked).
- **What they share and where they differ.** The two have the same web, levels and needs included, and the same pattern of exchange. Only how much is given differs. So no property of a world's relations that keeps to their likeness is balance.

Balance is a grammar statement only at a model that holds a relation defined from the flow's amounts. There are two such models:
- conservation's step, within which balance puts the names (M3);
- unit lists supplied with the amounts as their lengths (`Flow.balances_iff_units`).

In both, the arithmetic sits in the relation's definition. The grammar represents balance and derives nothing about amounts. This is what [08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#7-master-laws-and-connectivity)'s "represented both ways, not derived" comes to for the representation: balance's master law has no grammar reason, since its content is the arithmetic of amounts.

### F2. Identity across a step is not induced by amounts

```lean
theorem not_conserves_identity (L : Flow (Nat → Prop) (Nat → Prop))
    (W : Web (Nat → Prop) (Nat → Prop)) (t : Nat) :
    ¬ ∀ g f, (World.of (Nat → Prop) L W).Conserves t g f ↔ g = f
```

The proof has two steps, and both were checked:
- Where conservation across a step is identity, the standings after the step tell every two relata apart (`conserves_identity_injective`).
- No map of the predicates on `Nat` into `Nat` is one to one (`no_injection`). The proof is a diagonal argument and uses no axiom.

What it says about the unfolding: conservation tells relata apart across a step only by their standing after it, which is a natural number (`World.balanced_reidentify_iff_alike`: conservation fixes identity up to likeness of standing).
- Where the relata are more than standings can tell apart, the names are not conservation's continuation. Identity across steps stays the model's commitment, which is `Becoming.Identity`'s finding read from the side of amounts.
- A world whose standings after a step are all distinct has its names as conservation's continuation there. The failure is of the converse in general, not of every World.

### F3. A line of falls does not go on without end

```lean
theorem falls_not_endless (w : World) (x : Nat × w.Relatum) (falls : Falls w x) :
    ¬ «不穷» Steps.along (Web.alikeBy (Falls w)) x
theorem everywhere_endless :
    «不穷» Steps.along (Web.alikeBy fun _ : Nat × Unit => True) (0, ())
```

`Falls w x` says the relatum's level falls across the step from `x`. Both theorems were checked.
- "No line of falls goes on without end" holds at every World's model.
- It fails at a grammar model with a fall everywhere.
- So it is an image condition, and no grammar law.

The condition is the per-line form of the well-foundedness of `Nat`. The descent laws of `Becoming.Arising` (`depletion_not_recurring`, `dissipation_arising_not_recurring`, `substitution_defers`) use the same well-foundedness, through a total over a finite family. It is not claimed that they follow from the per-line condition together with the grammar's laws of finite runs.

Reading [AI]: a line of strict descent cannot be the endless coarse line that generation in the strong form (`«全生成»`) needs. Generation in that form does not run on an amount that only falls.

### Counting

The census and the totals are lists, and sums over a list. The grammar has finite lists and pairings, and equal count is a pairing under the one (`«一之对»`). A comparison of counts is therefore represented, near-definitionally. A total of amounts falls under F1.

**The failure, written down.** The World is represented both ways in its relations. Its amounts are represented only by relations defined from them. Amounts in `Nat` limit the relations they induce (F2) and add a condition on them (F3).

## 4. The Lean items

Every item is core (Init only, every axiom report empty), with its statement fixed before its proof. No earlier definition changes.

### WRT1: the grammar kept by correspondence

The grammar layer gets a new module, `Becoming.GrammarTransport`, importing `Becoming.GrammarMap`.

```lean
/-- A one-to-one correspondence of carriers. -/
structure «对应» (α : Type u) (β : Type v) where
  to : α → β
  back : β → α
  back_to : ∀ x, back (to x) = x
  to_back : ∀ y, to (back y) = y

/-- The correspondence carries `R` to `R'`: two things are related exactly where their images are. -/
def «对应».«携» (e : «对应» α β) (R : «际» α) (R' : «际» β) : Prop :=
  ∀ x y, R x y ↔ R' (e.to x) (e.to y)
```

Suppose `e` carries `R` to `R'` and `E` to `E'`, and also `F` to `F'` and `L` to `L'` where a term reads them. Then each term below holds at `x` (or at `x y`) exactly where it holds at `e.to x` (or at `e.to x`, `e.to y`):
- **Grammar:** `«及»`, `«续»`, `«相续»`, `«同族»`, `«有前»`, `«有后»`, `«生»`, `«亡»`, `«住»`, `«异»`, `«复生»`, `«复生至»`, `«不穷»`, `«生生»`, `«息»`, `«核»`.
- **GrammarMap:** `«所及»`, `«传»`, `«全生成»`, `«全守»`, `«有终»`.

Also:
- `«类» E ↔ «类» E'`, `«无环» R ↔ «无环» R'` and `«有常» R E ↔ «有常» R' E'`;
- the inverse correspondence (`back`) carries `R'` to `R`, and correspondences compose.

Proofs go forward by induction or through the witness's image, and back through `back` and the inverse laws. `«及»` and `«生»` were checked (`Corr.reach`, `Corr.sheng`).

The names are proposals; the owner settles them under the naming study. «对应» is the standard word for a correspondence, and it is not «对», the pairing of lists.

What this connects:
- the "no map of carriers" of 01 §8.6;
- the image up to correspondence (§1.4).

Record: the grammar is kept by correspondence of models. Home: [01](../../../../../../theories/becoming/chapters/01-ROOT.md) (the root).

### WRT2: the occurrence model, forward

The World layer gets a new module, `Becoming.WorldModel`, importing `Becoming.Persistence`, `Becoming.Space` and `Becoming.GrammarTransport`.

```lean
/-- Two occurrences are at the same step. -/
def World.sameStep {R : Type} : «际» (Nat × R) := fun x y => x.1 = y.1
theorem World.sameStep_class {R : Type} : «类» (World.sameStep (R := R))

/-- The step conservation induces, on occurrences. -/
def World.conserving (w : World) : «际» (Nat × w.Relatum) := Web.continuationStep w.Conserves

/-- A later step: along the names, then across by the same step. -/
theorem World.later_iff {x y : Nat × R} : x.1 < y.1 ↔ «而» («及» Steps.along) World.sameStep x y

/-- Recurrence on the occurrence model. -/
theorem World.arisingRecurs_iff : w.ArisingRecurs ↔ (∃ _ : w.Relatum, True) ∧
    ∀ x, ∃ y, «而» («及» Steps.along) World.sameStep x y ∧ w.web.active y.1 y.2 ∧
      «生» Steps.along w.web.activityClass y
theorem World.ceasingRecurs_iff : w.CeasingRecurs ↔ (∃ _ : w.Relatum, True) ∧
    ∀ x, ∃ y, «而» («所及» Steps.along «一») World.sameStep x y ∧ w.web.active y.1 y.2 ∧
      «亡» Steps.along w.web.activityClass y

/-- Balance is the names lying within conservation. -/
theorem World.balanced_iff_within : w.Balanced ↔ «则» Steps.along w.conserving

/-- Conservation is carried by every re-identification. -/
theorem World.conserves_reidentify (σ : Reidentify w.Relatum R') (t : Nat) (x y : R') :
    (w.reidentify σ).Conserves t x y ↔ w.Conserves t (σ.old t x) (σ.old (t + 1) y)

/-- A re-identification is a correspondence of occurrences, `(t, x) ↦ (t, σ.old t x)`,
carrying the name-free part. -/
def World.reidentify_correspondence (σ : Reidentify w.Relatum R') : «对应» (Nat × R') (Nat × w.Relatum)
theorem World.reidentify_carries (σ : Reidentify w.Relatum R') :
    (World.reidentify_correspondence σ).«携» (w.reidentify σ).conserving w.conserving ∧
    (World.reidentify_correspondence σ).«携» (w.reidentify σ).web.activityClass w.web.activityClass ∧
    (World.reidentify_correspondence σ).«携» World.sameStep World.sameStep
```

One instance is stated through WRT1, as the pattern for every other: beginning under conservation is fixed under re-identification, `«生» (w.reidentify σ).conserving (w.reidentify σ).web.activityClass x ↔ «生» w.conserving w.web.activityClass (x.1, σ.old x.1 x.2)`.

`later_iff` and `conserves_reidentify` were checked. The two recurrence forms follow from `Web.unceasing_iff_late_beginnings` and `later_iff`; the exact form of "at the same step or later" is for the owner.

What it connects:
- 01 §8.6's recurrence and renaming laws, now at the model;
- M2, M3 and M4.

Record: the World's occurrence model, with the forward direction. Home: 01 §8.6.

### WRT3: the image and the failures

The World layer gets a new module, `Becoming.WorldImage`, importing `Becoming.Persistence`, `Becoming.Space` and `Becoming.GrammarMap`. It does not need WRT1.

```lean
/-- The world with relata `F` whose activity is `Q` and nothing else. -/
def World.ofActivity (F : Type) (Q : Nat × F → Prop) : World :=
  World.of F Flow.still (Witnesses.unrequired (fun _ _ => 0) fun t f => Q (t, f))
theorem World.ofActivity_class : (World.ofActivity F Q).web.activityClass = Web.alikeBy Q

/-- Conservation is labelled by standings, so difunctional. -/
theorem World.conserves_iff_same_level (h : w.Conserves t g f) (f' : w.Relatum) :
    w.Conserves t g f' ↔ w.web.level (t + 1) f' = w.web.level (t + 1) f
theorem World.conserves_difunctional :
    w.Conserves t g f → w.Conserves t g' f → w.Conserves t g' f' → w.Conserves t g f'

/-- F2, with its two lemmas. -/
theorem World.conserves_identity_injective :
    (∀ g f, w.Conserves t g f ↔ g = f) → ∀ f f', w.web.level (t + 1) f = w.web.level (t + 1) f' → f = f'
theorem World.no_injection_of_predicates (i : (Nat → Prop) → Nat) : ¬ ∀ A B, i A = i B → A = B
theorem World.not_conserves_identity (L W t) : ¬ ∀ g f, (World.of (Nat → Prop) L W).Conserves t g f ↔ g = f

/-- F1. -/
structure World.Relations (R : Type)    -- activity, requiring, drawing, presence, giving, taking, needs met
def World.relations (w : World) : World.Relations w.Relatum
def World.Relations.Alike (a b : World.Relations R) : Prop
def World.idleTwice : World
theorem World.balance_not_relational : ¬ ∃ Φ, (keeps to likeness) ∧ ∀ w, w.Balanced ↔ Φ w.Relatum w.relations

/-- F3. -/
def World.Falls (w : World) (x : Nat × w.Relatum) : Prop
theorem World.falls_not_endless : Falls w x → ¬ «不穷» Steps.along (Web.alikeBy (Falls w)) x
theorem World.everywhere_endless : «不穷» Steps.along (Web.alikeBy fun _ : Nat × Unit => True) (0, ())
```

Everything was checked except `conserves_difunctional`, which is a corollary of `conserves_iff_same_level`.

What it connects:
- the converse (§1.4), which is M5;
- the failure that 01 §8.6's "Not instances" sentence leaves unwritten.

Records: the converse and its three limits are claims distinct from the forward direction. They get a record of their own, what the World's amounts add, with home 01 §8.6. The owner may split F3 out if its reading is taken further.

### Order, landing and what stays open

- **Order.** WRT1 and WRT3 are independent of each other; WRT2 needs WRT1. All three add modules and change no existing file's Lean.
- **Landing text.**
  - 01 §8.6 gains the forward direction and the converse. Its "Not instances … since the grammar states no counting and no map of carriers" becomes the exact boundary: amounts, F1–F3.
  - 01 Open's faithful representation keeps only the other models.
  - 08 §6 and its Open item read the World's representation as shown both ways, with its failure written down.
  - OU's criterion 7 closes its last part.
- **What stays open.**
  - a representation theorem for processes, the other model;
  - whether the descent laws follow from F3's condition;
  - classes finer than any the World's determinations read;
  - mutual interpretation with a fragment of Lean (08 §6).

## 5. Review

The first review is [REVIEW-WRT.md](REVIEW-WRT.md): 24 findings, three blocking, verdict "another pass". The revision that takes them follows this draft.
