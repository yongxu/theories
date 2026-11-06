import Becoming.Blanket
import Becoming.Flow

/-!
# The blanket at a steady state: conditional independence and what holds it

The free-energy principle's blanket has two forms. `Becoming.Blanket` states the coupling form on a
determined law: the internal and external parts each read only their own part and the blanket
(`Blanket.Blanketed`), so each side's course is fixed by its start and the blanket's course, the
deterministic case of the time-unrolled blanket (Virgo, Rosas and Biehl 2022). The principle's
statistical form is conditional independence at a steady state: given the blanket's present state,
the internal and external states are independent under the steady density (Friston 2019; Friston,
Da Costa, Sajid, Heins, Ueltzhöffer, Pavliotis and Parr 2023, Physics Reports). The two can come apart: sparse coupling can leave a steady
state without the conditional independence (Biehl, Pollock and Kanai 2021; Aguilera, Millidge,
Tschantz and Buckley 2022; Heins and Da Costa 2022). This module states the statistical form on
`Becoming.ConditionalWeights`, a sufficient condition for it on a weighting, and witnesses on either
side of that condition (board item UE26). The internal, blanket and external states are three parts
of one weighting, told apart by which states the conditioning holds fixed.

* **Conditional independence given the blanket, three ways.** At each blanket state, the share of an
  event of the internal part under the weighting restricted to a record of the external part is its
  share, as ratios (`IndependentGiven`, conditioning by restriction, `ConditionalWeights.restrict`).
  On listed states this follows from the joint weight times the blanket state's weight being the
  internal state's weight times the external state's (`FactorsGiven`; `independentGiven_of_factorsGiven`)
  and gives it back where each listing lists each state once (`factorsGiven_of_independentGiven`),
  and that form is the cross form on the listed states (`CrossFormOn`; `factorsGiven_of_crossFormOn`,
  `crossFormOn_of_factorsGiven`), with listings repeating states or weighing nothing at a blanket
  state. The cross form over the whole types gives it on any listings (`crossFormOn_of_crossForm`),
  and is given by it on listings that cover the types (`crossForm_of_crossFormOn`). Where the
  listings do not cover the types the converse fails: a weighting can vanish on the listed states and
  not be in cross form off them (`Uncovered`). Product weights at one blanket state are the case of
  `ConditionalWeights.restrict_independent` (`restrict_independent_case`), so the module generalizes
  that law below it.
* **Detailed balance of the internal moves holds the statistical blanket.** Read the weighting as the
  steady weights of a chain in which one part moves at a time, the internal part's moves at rates that
  may read the blanket and external states. Where those moves are in detailed balance with a positive
  weighting at each blanket and external state (`DetailedBalance`), the internal states at each
  blanket state lie within one closure of moves present, at positive rate, at every external state
  (the grammar's `«所闭»`), and the ratio of each such move's rate to its reverse's reads no external
  state, the weighting is in cross form (`crossForm_of_detailedBalance`), so conditionally
  independent on any listings (`independentGiven_of_detailedBalance`). Other moves may come and go
  with the external state. No steady state is assumed: the law holds for any positive weighting in
  detailed balance with the internal moves, which is why it is local. Rates reading no external state satisfy the ratio
  condition (`crossForm_of_detailedBalance_unread`). Conversely, a positive weighting in cross form,
  its internal moves in detailed balance, has each rate ratio reading no external state
  (`ratio_of_crossForm`). Detailed balance makes the rate ratio the weight ratio, so the ratio
  condition is the cross form on joined pairs and the law is near-definitional. It is Kelly's proof
  that the equilibrium of a reversible spatial process is a Markov field (Kelly 1979, Theorem 9.3,
  p. 189) taken at the internal site alone, with rate ratios in place of rates. The moves joining
  the internal states are his condition (iii), a site's moves connecting its values at every value
  of the other sites; that they are the same at every external state is what remains of his
  condition (ii), rates reading only neighbours, once only ratios are restricted, and it cannot be
  dropped (`MovesReadExternal`).
* **The condition is sufficient, not necessary.** Circulation through the internal moves can lose the
  blanket and need not. In the lag relay (`LagRelay`), external, blanket and internal bits each flip
  alone, the blanket towards the external bit and the internal bit towards the blanket at 3, away at
  1. Its steady weights (`LagRelay.steady`) are not conditionally independent
  (`LagRelay.not_independentGiven`), though the internal rates read no external state, so its
  internal moves are not in detailed balance (`LagRelay.circulates`). In the turning chain
  (`Turning`), the internal part turns through three states one way only, reading nothing, while the
  blanket and external bits flip. The uniform weighting is steady (`Turning.steady`) and in cross form
  (`Turning.independentGiven`), and the internal moves are not in detailed balance
  (`Turning.circulates`); the cross form there comes from the weights being uniform, whatever the
  rates, so the witness is of steadiness and circulation meeting it, not of circulation producing
  it. A rate reading the external state does not by itself lose it (`ReadsDirectly`: symmetric
  rates reading the external bit, with which the uniform weights are in detailed balance
  (`ReadsDirectly.balanced`) and in cross form, again by uniformity). Which
  moves are present must not read it: a positive weighting whose internal moves are in detailed
  balance, joined at each external state by other moves, each move present at both external states
  with one rate ratio at both, is not in cross form (`MovesReadExternal`).
* **A synchronous blanket: the coupling form on every run, the statistical form only
  sometimes.** In `SynchronousCopy` all three parts move at once, each through a factor reading only
  what `Blanket.Blanketed` lets it read, by the construction of its kernel (no theorem here joins the
  kernel to `Blanket.Blanketed`): the external bit stays at 3 and flips at 1, the sensory bit
  copies the external bit, the internal bit copies the sensory bit. With the sensory copy exact, the
  steady weights are conditionally independent (`SynchronousCopy.exact_independentGiven`); with a
  miss at 1 in 4 they are not (`SynchronousCopy.noisy_not_independentGiven`), each kernel's weights
  steady (`SynchronousCopy.exact_steady`, `SynchronousCopy.noisy_steady`). The occupation weighting
  of a determined blanketed law's run, the sensory part reading the upper bit of a four-state
  external counter and the internal part copying the sensory part, is not in cross form
  (`Cycle.not_crossForm`): the coupling form holds on every run of a determined blanketed law
  (`Blanket.Blanketed.agent_through_sensory`), the statistical form not.

**Standing.** Known results stated in the theory's terms, near-definitional: conditional
independence by shares on `ConditionalWeights`; detailed balance with local rates giving a
Markov-field steady law (Kelly 1979, Theorem 9.3; Liggett 1985, §IV.2); sparse coupling without
the blanket (Biehl, Pollock and Kanai 2021, Observation 1; Aguilera and others 2022), of which the lag
relay is a witness. What is the module's own is the statement in the pure core, below
`restrict_independent`, with the closure of the moves on the grammar; the witnesses, the synchronous
law's two cases among them, mark the sufficient condition's edges in the theory's terms. The
steady weights of `LagRelay` and `SynchronousCopy` are proved steady, not proved unique; their
uniqueness up to scale, for these irreducible chains, is a correspondence checked by an exact solve
in the study's probes (`relay_weights.py`, `synchronous_copy.py`).

**Modelling choices.** Natural weights on listed states; discrete states; the asynchronous chain
read through its rates, with no clock, a model beside `Blanket.Blanketed`, whose parts all move at
once; steady weights by global balance (`steady`), inflow equal to outflow at each state, or for the
synchronous law the weights carried to themselves by one step, times the kernel's total; the
asynchronous chain, one part moving at a time, read as the discrete counterpart of continuous time
with independent noise at each part, so the synchronous law's losses belong to its steps; the
blanket one part, its sensory and active sides not told apart where the law does not need them.
**What the model leaves out:** densities, Langevin flows and the Helmholtz decomposition (the linear
case is in the periphery, `LinearBlankets`); a chain's steady weights computed from its rates;
continuous states and time. Every declaration has an empty axiom report. No ethical predicate,
ranking or axiom occurs.
-/

namespace Becoming

namespace BlanketWeights

open ConditionalWeights

universe u

variable {I B E : Type u}

/-! ## The cross form and detailed balance -/

/-- **The cross form**: at each blanket state, the weights of two internal states with two external
states cross-multiply equally. -/
def CrossForm (w : I → B → E → Nat) : Prop :=
  ∀ i i' b e e', w i b e * w i' b e' = w i b e' * w i' b e

/-- **Detailed balance of the internal moves**: at each blanket and external state, the weight of an
internal state times the rate of a move from it is the weight of the internal state moved to times
the rate of the move back. -/
def DetailedBalance (w : I → B → E → Nat) (rate : B → E → I → I → Nat) : Prop :=
  ∀ i i' b e, w i b e * rate b e i i' = w i' b e * rate b e i' i

/-- One move in detailed balance at two external states, its rate ratio the same at both, gives the
cross form between its two ends, where the move's rate at the first external state and the reverse
move's at the second are positive. -/
theorem cross_of_move {a a' c c' r r' s s' : Nat} (hr : 0 < r) (hs : 0 < s')
    (db : a * r = c * r') (db' : a' * s = c' * s') (ratio : r * s' = r' * s) :
    a * c' = a' * c := by
  have h : a * c' * (r * s') = a' * c * (r * s') := by
    calc a * c' * (r * s') = a * r * (c' * s') := Naturals.mul_mul_mul_comm a c' r s'
      _ = c * r' * (a' * s) := by rw [db, ← db']
      _ = c * a' * (r' * s) := Naturals.mul_mul_mul_comm c r' a' s
      _ = a' * c * (r * s') := by rw [Nat.mul_comm c a', ← ratio]
  exact Nat.eq_of_mul_eq_mul_right (Nat.mul_pos hr hs) h

/-- One move in detailed balance at two external states, its ends in cross form, has the same rate
ratio at both, where the first end's weight at the second external state and the second end's at the
first are positive. -/
theorem ratio_of_cross {a a' c c' r r' s s' : Nat} (ha : 0 < a') (hc : 0 < c)
    (db : a * r = c * r') (db' : a' * s = c' * s') (cross : a * c' = a' * c) :
    r * s' = r' * s := by
  have h : a' * c * (r * s') = a' * c * (r' * s) := by
    calc a' * c * (r * s') = a * c' * (r * s') := by rw [cross]
      _ = a * r * (c' * s') := Naturals.mul_mul_mul_comm a c' r s'
      _ = c * r' * (a' * s) := by rw [db, ← db']
      _ = c * a' * (r' * s) := Naturals.mul_mul_mul_comm c r' a' s
      _ = a' * c * (r' * s) := by rw [Nat.mul_comm c a']
  exact Nat.eq_of_mul_eq_mul_left (Nat.mul_pos ha hc) h

/-- The cross form passes through a state of positive weight. -/
theorem cross_trans {wi wi' wj wj' wk wk' : Nat} (hj : 0 < wj) (hj' : 0 < wj')
    (ij : wi * wj' = wi' * wj) (jk : wj * wk' = wj' * wk) : wi * wk' = wi' * wk := by
  have h : wi * wk' * (wj * wj') = wi' * wk * (wj * wj') := by
    calc wi * wk' * (wj * wj') = wi * wj * (wk' * wj') := Naturals.mul_mul_mul_comm wi wk' wj wj'
      _ = wi * wj * (wj' * wk') := by rw [Nat.mul_comm wk' wj']
      _ = wi * wj' * (wj * wk') := (Naturals.mul_mul_mul_comm wi wj' wj wk').symm
      _ = wi' * wj * (wj' * wk) := by rw [ij, jk]
      _ = wi' * wk * (wj * wj') := by
        rw [Naturals.mul_mul_mul_comm wi' wk wj wj', Nat.mul_comm wk wj']
  exact Nat.eq_of_mul_eq_mul_right (Nat.mul_pos hj hj') h

/-- Positive weight and positive rate on one side of a balance give a positive rate back. -/
theorem pos_of_mul_eq {a b c d : Nat} (ha : 0 < a) (hb : 0 < b) (h : a * b = c * d) :
    0 < d := by
  cases d with
  | zero => exact absurd (h.trans (Nat.mul_zero c)) (Nat.ne_of_gt (Nat.mul_pos ha hb))
  | succ d => exact Nat.succ_pos d

/-- **Within the closure of the moves, the cross form holds.** With the internal moves in detailed
balance with a positive weighting, each move of the relation at positive rate at every external
state, and its rate ratio reading no external state (no steady state assumed), every internal state within the closure of the moves from `i` (the
grammar's `«所闭»`) is in cross form with `i`. The closure holds `i`, and a move keeps the cross form
with `i` (`cross_of_move`, `cross_trans`). -/
theorem cross_of_closure (w : I → B → E → Nat) (rate : B → E → I → I → Nat)
    (adj : B → «际» I) (pos : ∀ i b e, 0 < w i b e) (balanced : DetailedBalance w rate)
    (moves : ∀ b e i i', adj b i i' → 0 < rate b e i i')
    (ratio : ∀ b e e' i i', adj b i i' →
      rate b e i i' * rate b e' i' i = rate b e i' i * rate b e' i i')
    (b : B) (e e' : E) (i : I) {k : I} (within : «所闭» (adj b) i k) :
    w i b e * w k b e' = w i b e' * w k b e :=
  within (fun k => w i b e * w k b e' = w i b e' * w k b e)
    (fun j k ij step =>
      have back : 0 < rate b e' k j :=
        pos_of_mul_eq (pos j b e') (moves b e' j k step) (balanced j k b e')
      cross_trans (pos j b e) (pos j b e') ij
        (cross_of_move (moves b e j k step) back (balanced j k b e) (balanced j k b e')
          (ratio b e e' j k step)))
    (Nat.mul_comm _ _)

/-- **Detailed balance of the internal moves gives the cross form.** Where the internal moves are
in detailed balance with a positive weighting, the internal states at each blanket state lie within
one closure of moves present, at positive rate, at every external state, and the ratio of each such
move's rate to its reverse's reads no external state, the weighting is in cross form. No steady
state is assumed. -/
theorem crossForm_of_detailedBalance (w : I → B → E → Nat) (rate : B → E → I → I → Nat)
    (adj : B → «际» I) (pos : ∀ i b e, 0 < w i b e) (balanced : DetailedBalance w rate)
    (moves : ∀ b e i i', adj b i i' → 0 < rate b e i i')
    (ratio : ∀ b e e' i i', adj b i i' →
      rate b e i i' * rate b e' i' i = rate b e i' i * rate b e' i i')
    (joined : ∀ b i i', «所闭» (adj b) i i') : CrossForm w :=
  fun i k b e e' => cross_of_closure w rate adj pos balanced moves ratio b e e' i (joined b i k)

/-- Rates reading no external state satisfy the ratio condition. -/
theorem crossForm_of_detailedBalance_unread (w : I → B → E → Nat) (rate : B → I → I → Nat)
    (adj : B → «际» I) (pos : ∀ i b e, 0 < w i b e)
    (balanced : DetailedBalance w (fun b _ => rate b))
    (moves : ∀ b i i', adj b i i' → 0 < rate b i i')
    (joined : ∀ b i i', «所闭» (adj b) i i') : CrossForm w :=
  crossForm_of_detailedBalance w (fun b _ => rate b) adj pos balanced (fun b _ => moves b)
    (fun _ _ _ _ _ _ => Nat.mul_comm _ _) joined

/-- **Conversely**, a positive weighting in cross form, its internal moves in detailed balance, has
the ratio of each move's rate to its reverse's reading no external state. -/
theorem ratio_of_crossForm (w : I → B → E → Nat) (rate : B → E → I → I → Nat)
    (pos : ∀ i b e, 0 < w i b e) (balanced : DetailedBalance w rate) (cross : CrossForm w)
    (b : B) (e e' : E) (i i' : I) :
    rate b e i i' * rate b e' i' i = rate b e i' i * rate b e' i i' :=
  ratio_of_cross (pos i b e') (pos i' b e) (balanced i i' b e) (balanced i i' b e')
    (cross i i' b e e')

/-! ## Conditional independence on listed states -/

section Counts

variable {I B E : Type} (li : List I) (le : List E) (w : I → B → E → Nat)

/-- The weight of an internal state at a blanket state, over the listed external states. -/
def internalWeight (i : I) (b : B) : Nat := total le fun e => w i b e

/-- The weight of an external state at a blanket state, over the listed internal states. -/
def externalWeight (b : B) (e : E) : Nat := total li fun i => w i b e

/-- The weight of a blanket state, over both listings. -/
def blanketWeight (b : B) : Nat := total li fun i => total le fun e => w i b e

/-- **The joint weight factors given the blanket**: each listed internal and external state's weight
at a blanket state, times that blanket state's weight, is the internal state's weight there times the
external state's. -/
def FactorsGiven : Prop :=
  ∀ i b e, i ∈ li → e ∈ le →
    w i b e * blanketWeight li le w b = internalWeight le w i b * externalWeight li w b e

/-- The cross form on the listed states. -/
def CrossFormOn : Prop :=
  ∀ i i' b e e', i ∈ li → i' ∈ li → e ∈ le → e' ∈ le →
    w i b e * w i' b e' = w i b e' * w i' b e

/-- The cross form gives it on any listings. -/
theorem crossFormOn_of_crossForm (cross : CrossForm w) : CrossFormOn li le w :=
  fun i i' b e e' _ _ _ _ => cross i i' b e e'

/-- On listings covering the types, the cross form on the listed states is the cross form. -/
theorem crossForm_of_crossFormOn (all_i : ∀ i, i ∈ li) (all_e : ∀ e, e ∈ le)
    (cross : CrossFormOn li le w) : CrossForm w :=
  fun i i' b e e' => cross i i' b e e' (all_i i) (all_i i') (all_e e) (all_e e')

theorem total_mul_total {α β : Type} (f : α → Nat) (g : β → Nat) (as : List α) (bs : List β) :
    total as (fun a => total bs fun b => f a * g b) = total as f * total bs g :=
  (total_congr (fun a => total_mul (f a) g bs) as).trans
    ((total_congr (fun a => Nat.mul_comm (f a) (total bs g)) as).trans
      ((total_mul (total bs g) f as).trans (Nat.mul_comm _ _)))

/-- The cross form on the listed states factors the joint weight. -/
theorem factorsGiven_of_crossFormOn (cross : CrossFormOn li le w) : FactorsGiven li le w := by
  intro i b e hi he
  have expand : w i b e * blanketWeight li le w b =
      total li (fun i' => total le fun e' => w i b e * w i' b e') :=
    (total_mul (w i b e) _ li).symm.trans
      (total_congr (fun i' => (total_mul (w i b e) (fun e' => w i' b e') le).symm) li)
  have swap : total li (fun i' => total le fun e' => w i b e * w i' b e') =
      total li (fun i' => total le fun e' => w i b e' * w i' b e) :=
    total_congr_on fun i' hi' => total_congr_on fun e' he' => cross i i' b e e' hi hi' he he'
  have split : total li (fun i' => total le fun e' => w i b e' * w i' b e) =
      externalWeight li w b e * internalWeight le w i b :=
    (total_congr (fun i' => total_congr (fun e' => Nat.mul_comm _ _) le) li).trans
      (total_mul_total (fun i' => w i' b e) (fun e' => w i b e') li le)
  exact expand.trans (swap.trans (split.trans (Nat.mul_comm _ _)))

/-- A blanket state weighing nothing weighs nothing at any listed state. -/
theorem whole_zero_entry {i : I} {b : B} {e : E} (hi : i ∈ li) (he : e ∈ le)
    (zero : blanketWeight li le w b = 0) : w i b e = 0 :=
  Nat.eq_zero_of_le_zero (zero ▸ Nat.le_trans (le_total_of_mem (q := fun e => w i b e) he)
    (le_total_of_mem (q := fun i => total le fun e => w i b e) hi))

/-- The factored joint weight gives the cross form on the listed states. -/
theorem crossFormOn_of_factorsGiven (held : FactorsGiven li le w) : CrossFormOn li le w := by
  intro i i' b e e' hi hi' he he'
  cases h : blanketWeight li le w b with
  | zero =>
    rw [whole_zero_entry li le w hi he h, whole_zero_entry li le w hi he' h, Nat.zero_mul,
      Nat.zero_mul]
  | succ n =>
    have pos : 0 < blanketWeight li le w b := h ▸ Nat.succ_pos n
    let W := blanketWeight li le w b
    have key : w i b e * w i' b e' * (W * W) = w i b e' * w i' b e * (W * W) :=
      calc w i b e * w i' b e' * (W * W) = w i b e * W * (w i' b e' * W) :=
            Naturals.mul_mul_mul_comm _ _ _ _
        _ = internalWeight le w i b * externalWeight li w b e *
              (internalWeight le w i' b * externalWeight li w b e') := by
            rw [held i b e hi he, held i' b e' hi' he']
        _ = internalWeight le w i b * internalWeight le w i' b *
              (externalWeight li w b e * externalWeight li w b e') :=
            Naturals.mul_mul_mul_comm _ _ _ _
        _ = internalWeight le w i b * internalWeight le w i' b *
              (externalWeight li w b e' * externalWeight li w b e) := by
            rw [Nat.mul_comm (externalWeight li w b e) (externalWeight li w b e')]
        _ = internalWeight le w i b * externalWeight li w b e' *
              (internalWeight le w i' b * externalWeight li w b e) :=
            (Naturals.mul_mul_mul_comm _ _ _ _).symm
        _ = w i b e' * W * (w i' b e * W) := by rw [held i b e' hi he', held i' b e hi' he]
        _ = w i b e' * w i' b e * (W * W) := (Naturals.mul_mul_mul_comm _ _ _ _).symm
    exact Nat.eq_of_mul_eq_mul_right (Nat.mul_pos pos pos) key

/-- The weighting of the internal and external states together at a blanket state. -/
def atBlanket (b : B) (c : I × E) : Nat := w c.1 b c.2

/-- **Conditional independence given the blanket**: at each blanket state, the share of an event of
the internal part, over the listed pairs of internal and external states, under the weighting
restricted to a record of the external part, is its share under the weighting, as ratios. Where the
record weighs nothing this says nothing (`Share.zero_whole`). -/
def IndependentGiven : Prop :=
  ∀ (b : B) (ev : I → Bool) (r : E → Bool),
    (share (openSteps li le) (ConditionalWeights.restrict (fun c => r c.2) (atBlanket w b)) (fun c => ev c.1)).Same
      (share (openSteps li le) (atBlanket w b) (fun c => ev c.1))

/-- The whole mass is the total. -/
theorem mass_whole {α : Type} (f : α → Nat) : ∀ l : List α, mass l f (fun _ => true) = total l f
  | [] => rfl
  | _ :: l => congrArg (_ + ·) (mass_whole f l)

/-- The mass over the listed pairs at a blanket state, an event of each part, is a mass over the
internal states of masses over the external ones (`mass_pairs`). -/
theorem mass_atBlanket (b : B) (p : I → Bool) (q : E → Bool) :
    mass (openSteps li le) (atBlanket w b) (fun c => p c.1 && q c.2) =
      mass li (fun i => mass le (fun e => w i b e) q) p :=
  (mass_congr (w' := fun c => 1 * w c.1 b c.2) (e' := fun c => p c.1 && q c.2)
      (fun c => congrArg (fun y => if (p c.1 && q c.2) = true then y else 0)
        (Nat.one_mul _).symm) _).trans
    ((mass_pairs (fun _ => 1) (fun i e => w i b e) p q le li).trans
      (mass_congr (fun i => congrArg (fun y => if p i = true then y else 0) (Nat.one_mul _)) li))

/-- Where the joint weight factors, a blanket state's weight times the mass of an internal event
with an external record is the internal event's weight times the record's. -/
theorem scaled_of_factorsGiven (held : FactorsGiven li le w) (b : B) (ev : I → Bool)
    (r : E → Bool) :
    blanketWeight li le w b * mass li (fun i => mass le (fun e => w i b e) r) ev =
      mass li (fun i => internalWeight le w i b) ev * mass le (fun e => externalWeight li w b e) r :=
  (mass_mul_left _ _ ev li).symm.trans
    ((mass_congr_mem fun i hi => congrArg (fun y => if ev i = true then y else 0)
      ((mass_mul_left _ _ r le).symm.trans
        ((mass_congr_mem fun e he => congrArg (fun y => if r e = true then y else 0)
          ((Nat.mul_comm _ _).trans (held i b e hi he))).trans
          (mass_mul_left _ _ r le)))).trans
      (mass_mul_right _ _ ev li))

/-- **The factored joint weight is conditional independence given the blanket**, on any
listings. -/
theorem independentGiven_of_factorsGiven (held : FactorsGiven li le w) : IndependentGiven li le w := by
  intro b ev r
  let W := blanketWeight li le w b
  have meets : mass (openSteps li le) (ConditionalWeights.restrict (fun c => r c.2) (atBlanket w b)) (fun c => ev c.1)
      = mass li (fun i => mass le (fun e => w i b e) r) ev :=
    (mass_restrict _ _ _ _).trans (mass_atBlanket li le w b ev r)
  have whole : mass (openSteps li le) (atBlanket w b) (fun _ => true) = W :=
    (mass_atBlanket li le w b (fun _ => true) (fun _ => true)).trans
      ((mass_congr (fun i => congrArg (fun y => if true = true then y else 0)
        (mass_whole (fun e => w i b e) le)) li).trans
        (mass_whole (fun i => internalWeight le w i b) li))
  have event : mass (openSteps li le) (atBlanket w b) (fun c => ev c.1) =
      mass li (fun i => internalWeight le w i b) ev :=
    (mass_and_true _ _ (fun c : I × E => ev c.1)).symm.trans
      ((mass_atBlanket li le w b ev (fun _ => true)).trans
        (mass_congr (fun i => congrArg (fun y => if ev i = true then y else 0)
          (mass_whole (fun e => w i b e) le)) li))
  have record : mass (openSteps li le) (ConditionalWeights.restrict (fun c => r c.2) (atBlanket w b)) (fun _ => true)
      = mass li (fun i => mass le (fun e => w i b e) r) (fun _ => true) :=
    (whole_restrict _ _ _).trans (mass_atBlanket li le w b (fun _ => true) r)
  show mass (openSteps li le) (ConditionalWeights.restrict (fun c => r c.2) (atBlanket w b)) (fun c => ev c.1) *
      mass (openSteps li le) (atBlanket w b) (fun _ => true) =
    mass (openSteps li le) (atBlanket w b) (fun c => ev c.1) *
      mass (openSteps li le) (ConditionalWeights.restrict (fun c => r c.2) (atBlanket w b)) (fun _ => true)
  rw [meets, whole, event, record]
  cases h : W with
  | zero =>
    have none : mass li (fun i => internalWeight le w i b) ev = 0 :=
      Nat.eq_zero_of_le_zero (Nat.le_trans
        (mass_le_of_entries (fun i => entry_test_le (ev i) (internalWeight le w i b)) li)
        (Nat.le_of_eq ((mass_whole _ li).trans h)))
    rw [none, Nat.zero_mul, Nat.mul_zero]
  | succ n =>
    have pos : 0 < W := h ▸ Nat.succ_pos n
    have scaled := scaled_of_factorsGiven li le w held b ev r
    have recordScaled := scaled_of_factorsGiven li le w held b (fun _ => true) r
    have same : mass li (fun i => mass le (fun e => w i b e) r) (fun _ => true) =
        mass le (fun e => externalWeight li w b e) r :=
      Nat.eq_of_mul_eq_mul_left pos (recordScaled.trans
        (congrArg (· * mass le (fun e => externalWeight li w b e) r)
          (mass_whole (fun i => internalWeight le w i b) li)))
    rw [same, ← h]
    exact (Nat.mul_comm _ _).trans scaled

/-- **Conversely**, on listings listing each state once, conditional independence given the blanket
factors the joint weight: take the event of being one internal state and the record of being one
external state (`mass_single`). -/
theorem factorsGiven_of_independentGiven [DecidableEq I] [DecidableEq E] (dl : Distinct li)
    (de : Distinct le) (indep : IndependentGiven li le w) : FactorsGiven li le w := by
  intro i b e hi he
  have same := indep b (fun i' => decide (i' = i)) (fun e' => decide (e' = e))
  have meets : mass (openSteps li le)
      (ConditionalWeights.restrict (fun c => decide (c.2 = e)) (atBlanket w b)) (fun c => decide (c.1 = i)) =
      w i b e :=
    (mass_restrict _ _ _ _).trans ((mass_atBlanket li le w b _ _).trans
      ((mass_single (fun i' => mass le (fun e' => w i' b e') fun e' => decide (e' = e)) i dl hi).trans
        (mass_single (fun e' => w i b e') e de he)))
  have whole : mass (openSteps li le) (atBlanket w b) (fun _ => true) = blanketWeight li le w b :=
    (mass_atBlanket li le w b (fun _ => true) (fun _ => true)).trans
      ((mass_congr (fun i => congrArg (fun y => if true = true then y else 0)
        (mass_whole (fun e => w i b e) le)) li).trans
        (mass_whole (fun i => internalWeight le w i b) li))
  have event : mass (openSteps li le) (atBlanket w b) (fun c => decide (c.1 = i)) =
      internalWeight le w i b :=
    (mass_and_true _ _ (fun c : I × E => decide (c.1 = i))).symm.trans
      ((mass_atBlanket li le w b _ (fun _ => true)).trans
        ((mass_single (fun i' => mass le (fun e' => w i' b e') fun _ => true) i dl hi).trans
          (mass_whole (fun e' => w i b e') le)))
  have record : mass (openSteps li le)
      (ConditionalWeights.restrict (fun c => decide (c.2 = e)) (atBlanket w b)) (fun _ => true) =
      externalWeight li w b e :=
    (whole_restrict _ _ _).trans ((mass_atBlanket li le w b (fun _ => true) _).trans
      ((mass_congr (fun i' => congrArg (fun y => if true = true then y else 0)
        (mass_single (fun e' => w i' b e') e de he)) li).trans
        (mass_whole (fun i' => w i' b e) li)))
  have eq : mass (openSteps li le)
        (ConditionalWeights.restrict (fun c => decide (c.2 = e)) (atBlanket w b)) (fun c => decide (c.1 = i)) *
      mass (openSteps li le) (atBlanket w b) (fun _ => true) =
      mass (openSteps li le) (atBlanket w b) (fun c => decide (c.1 = i)) *
      mass (openSteps li le) (ConditionalWeights.restrict (fun c => decide (c.2 = e)) (atBlanket w b))
        (fun _ => true) := same
  rw [meets, whole, event, record] at eq
  exact eq

/-- The cross form on the listed states is conditional independence given the blanket. -/
theorem independentGiven_of_crossFormOn (cross : CrossFormOn li le w) : IndependentGiven li le w :=
  independentGiven_of_factorsGiven li le w (factorsGiven_of_crossFormOn li le w cross)

/-- On listings listing each state once, conditional independence given the blanket is the cross
form on the listed states. -/
theorem crossFormOn_of_independentGiven [DecidableEq I] [DecidableEq E] (dl : Distinct li)
    (de : Distinct le) (indep : IndependentGiven li le w) : CrossFormOn li le w :=
  crossFormOn_of_factorsGiven li le w (factorsGiven_of_independentGiven li le w dl de indep)

end Counts

/-- **Detailed balance of the internal moves holds the statistical blanket.** Under
`crossForm_of_detailedBalance`'s conditions, the weighting is conditionally independent given the
blanket on any listings. -/
theorem independentGiven_of_detailedBalance {I B E : Type} (li : List I) (le : List E)
    (w : I → B → E → Nat) (rate : B → E → I → I → Nat) (adj : B → «际» I)
    (pos : ∀ i b e, 0 < w i b e) (balanced : DetailedBalance w rate)
    (moves : ∀ b e i i', adj b i i' → 0 < rate b e i i')
    (ratio : ∀ b e e' i i', adj b i i' →
      rate b e i i' * rate b e' i' i = rate b e i' i * rate b e' i i')
    (joined : ∀ b i i', «所闭» (adj b) i i') : IndependentGiven li le w :=
  independentGiven_of_crossFormOn li le w (crossFormOn_of_crossForm li le w
    (crossForm_of_detailedBalance w rate adj pos balanced moves ratio joined))

/-- Product weights are in cross form. -/
theorem crossForm_product {α β : Type} (w₁ : α → Nat) (w₂ : β → Nat) :
    CrossForm (fun (a : α) (_ : Unit) (c : β) => w₁ a * w₂ c) := fun i i' _ e e' =>
  (Naturals.mul_mul_mul_comm (w₁ i) (w₂ e) (w₁ i') (w₂ e')).trans
    ((congrArg (w₁ i * w₁ i' * ·) (Nat.mul_comm (w₂ e) (w₂ e'))).trans
      (Naturals.mul_mul_mul_comm (w₁ i) (w₂ e') (w₁ i') (w₂ e)).symm)

/-- **`ConditionalWeights.restrict_independent` is the case of one blanket state**: product weights
are in cross form, so conditionally independent given the one blanket state, which is that law's
statement. -/
theorem restrict_independent_case {α β : Type} (w₁ : α → Nat) (w₂ : β → Nat) (e₁ : α → Bool)
    (r : β → Bool) (as : List α) (bs : List β) :
    (share (openSteps as bs) (ConditionalWeights.restrict (fun c => r c.2) fun c => w₁ c.1 * w₂ c.2)
        (fun c => e₁ c.1)).Same
      (share (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun c => e₁ c.1)) :=
  independentGiven_of_crossFormOn as bs _
    (crossFormOn_of_crossForm as bs _ (crossForm_product w₁ w₂)) () e₁ r

namespace LagRelay

/-- The lag relay: internal `μ`, blanket `s`, external `e`, each a bit, each flipping alone. -/
abbrev State := Bool × Bool × Bool

/-- Rate of the internal part's flip: towards the blanket at 3, away at 1, reading no external
state. -/
def rate (s : Bool) (μ μ' : Bool) : Nat :=
  if μ' = μ then 0 else if μ = s then 1 else 3

/-- The whole chain's rates: the external part flips at 1, the blanket towards the external part at
3 and away at 1, the internal part as `rate`. -/
def fullRate (x y : State) : Nat :=
  match x, y with
  | (μ, s, e), (μ', s', e') =>
    if μ' ≠ μ ∧ s' = s ∧ e' = e then rate s μ μ'
    else if μ' = μ ∧ s' ≠ s ∧ e' = e then (if s = e then 1 else 3)
    else if μ' = μ ∧ s' = s ∧ e' ≠ e then 1 else 0

/-- Its steady weights. -/
def weight : State → Nat
  | (false, false, false) => 31 | (false, false, true) => 15
  | (false, true, false) => 9  | (false, true, true) => 17
  | (true, false, false) => 17 | (true, false, true) => 9
  | (true, true, false) => 15  | (true, true, true) => 31

def w (μ s e : Bool) : Nat := weight (μ, s, e)

/-- The states one flip away. -/
def flips (x : State) : List State :=
  match x with
  | (μ, s, e) => [(!μ, s, e), (μ, !s, e), (μ, s, !e)]

def inflow (x : State) : Nat := total (flips x) fun y => weight y * fullRate y x
def outflow (x : State) : Nat := weight x * total (flips x) fun y => fullRate x y

/-- The weights are steady: inflow is outflow at every state. -/
theorem steady (μ s e : Bool) : inflow (μ, s, e) = outflow (μ, s, e) := by
  cases μ <;> cases s <;> cases e <;> decide

/-- The steady weights are not conditionally independent given the blanket: at blanket state
`false`, internal `false` weighs 46 of 72 and 46·24 is not 15·72 for the external record `true`. -/
theorem not_independentGiven : ¬ IndependentGiven [false, true] [false, true] w := fun h =>
  absurd (h false (fun μ => !μ) (fun e => e)) (by delta Share.Same; decide)

/-- So the internal moves are not in detailed balance with the steady weights, though their rates
read no external state: the steady state circulates through them. -/
theorem circulates : ¬ DetailedBalance w (fun s _ => rate s) := fun bal =>
  not_independentGiven (independentGiven_of_detailedBalance [false, true] [false, true] w
    (fun s _ => rate s) (fun _ μ μ' => μ ≠ μ')
    (fun μ s e => by cases μ <;> cases s <;> cases e <;> decide) bal
    (fun s _ μ μ' ne => show 0 < rate s μ μ' by
      cases s <;> cases μ <;> cases μ' <;> first | exact absurd rfl ne | decide)
    (fun _ _ _ _ _ _ => Nat.mul_comm _ _)
    (fun _ μ μ' => match μ, μ' with
      | false, false => «所闭之自反» _ _ | true, true => «所闭之自反» _ _
      | false, true => fun _ closed held => closed false true held (fun h => Bool.noConfusion h)
      | true, false => fun _ closed held => closed true false held (fun h => Bool.noConfusion h)))

end LagRelay

namespace Turning

/-- Three internal states in a cycle. -/
inductive Phase
  | zero
  | one
  | two

/-- The internal part turns forward at rate 1 and never back, reading neither the blanket nor the
external state. -/
def rate (_s _e : Bool) (μ μ' : Phase) : Nat :=
  match μ with
  | .zero => match μ' with | .zero => 0 | .one => 1 | .two => 0
  | .one => match μ' with | .zero => 0 | .one => 0 | .two => 1
  | .two => match μ' with | .zero => 1 | .one => 0 | .two => 0

/-- Whether two phases are one. -/
def same (μ μ' : Phase) : Bool :=
  match μ with
  | .zero => match μ' with | .zero => true | .one => false | .two => false
  | .one => match μ' with | .zero => false | .one => true | .two => false
  | .two => match μ' with | .zero => false | .one => false | .two => true

abbrev State := Phase × Bool × Bool

/-- The whole chain's rates: the internal part turns, the blanket and external bits each flip at
1, reading nothing. -/
def fullRate (x y : State) : Nat :=
  match x, y with
  | (μ, s, e), (μ', s', e') =>
    if s' = s ∧ e' = e then rate s e μ μ'
    else if same μ μ' = true ∧ s' ≠ s ∧ e' = e then 1
    else if same μ μ' = true ∧ s' = s ∧ e' ≠ e then 1 else 0

/-- Uniform weights. -/
def w (_μ : Phase) (_s _e : Bool) : Nat := 1

def states : List State :=
  [(.zero, false, false), (.zero, false, true), (.zero, true, false), (.zero, true, true),
   (.one, false, false), (.one, false, true), (.one, true, false), (.one, true, true),
   (.two, false, false), (.two, false, true), (.two, true, false), (.two, true, true)]

def inflow (x : State) : Nat := total states fun y => w y.1 y.2.1 y.2.2 * fullRate y x
def outflow (x : State) : Nat := w x.1 x.2.1 x.2.2 * total states fun y => fullRate x y

/-- The uniform weights are steady: inflow is outflow at every state. -/
theorem steady (μ : Phase) (s e : Bool) : inflow (μ, s, e) = outflow (μ, s, e) := by
  cases μ <;> cases s <;> cases e <;> decide

/-- The internal moves are not in detailed balance: the steady state circulates through them. -/
theorem circulates : ¬ DetailedBalance w rate := fun h =>
  absurd (h .zero .one false false) (by decide)

/-- **And the steady weights are conditionally independent given the blanket**, on any listings.
This follows from the weights being uniform alone; the rates play no part in it. -/
theorem independentGiven (li : List Phase) (le : List Bool) : IndependentGiven li le w :=
  independentGiven_of_crossFormOn li le w (crossFormOn_of_crossForm li le w fun _ _ _ _ _ => rfl)

end Turning

namespace ReadsDirectly

/-- The internal part flips at 1 where the external bit is off and at 2 where it is on: the rate
reads the external state. -/
def rate (_s e μ μ' : Bool) : Nat := if μ' = μ then 0 else if e then 2 else 1

/-- Uniform weights. -/
def w (_μ _s _e : Bool) : Nat := 1

theorem balanced : DetailedBalance w rate := fun μ μ' s e => by
  cases μ <;> cases μ' <;> cases e <;> rfl

theorem crossForm : CrossForm w := fun _ _ _ _ _ => rfl

theorem reads_external : rate false false false true ≠ rate false true false true := by decide

end ReadsDirectly

namespace MovesReadExternal

open Turning (Phase)

/-- Three internal states joined at each external state by other moves: `zero`–`one` and
`one`–`two` at rate 1 each way where the external bit is off; `zero` to `two` at 2 and back at 1,
`one`–`two` at 1 each way, where it is on. -/
def rate (_s e : Bool) (μ μ' : Phase) : Nat :=
  match e with
  | false => match μ with
    | .zero => match μ' with | .zero => 0 | .one => 1 | .two => 0
    | .one => match μ' with | .zero => 1 | .one => 0 | .two => 1
    | .two => match μ' with | .zero => 0 | .one => 1 | .two => 0
  | true => match μ with
    | .zero => match μ' with | .zero => 0 | .one => 0 | .two => 2
    | .one => match μ' with | .zero => 0 | .one => 0 | .two => 1
    | .two => match μ' with | .zero => 1 | .one => 1 | .two => 0

/-- Weights 1, 1, 1 where the external bit is off, 1, 2, 2 where it is on. -/
def w (μ : Phase) (_s e : Bool) : Nat :=
  match e with
  | false => 1
  | true => match μ with | .zero => 1 | .one => 2 | .two => 2

theorem balanced : DetailedBalance w rate := fun μ μ' s e => by
  cases μ <;> cases μ' <;> cases s <;> cases e <;> decide

/-- At each blanket and external state the internal states lie within one closure of the moves
present there. -/
theorem joined (s e : Bool) (μ μ' : Phase) : «所闭» (fun a b => 0 < rate s e a b) μ μ' := by
  intro P closed held
  cases s <;> cases e <;> cases μ <;> cases μ' <;>
    first
    | exact held
    | exact closed _ _ held (by decide)
    | exact closed _ _ (closed _ Phase.zero held (by decide)) (by decide)
    | exact closed _ _ (closed _ Phase.one held (by decide)) (by decide)
    | exact closed _ _ (closed _ Phase.two held (by decide)) (by decide)

/-- A move present at both external states has one rate ratio at both. -/
theorem ratio (s : Bool) (μ μ' : Phase) (off : 0 < rate s false μ μ') (on : 0 < rate s true μ μ') :
    rate s false μ μ' * rate s true μ' μ = rate s false μ' μ * rate s true μ μ' := by
  cases s <;> cases μ <;> cases μ' <;> first | rfl | exact absurd off (by decide) |
    exact absurd on (by decide)

/-- **And the weighting is not in cross form**: the moves present must not read the external
state. -/
theorem not_crossForm : ¬ CrossForm w := fun h =>
  absurd (h .zero .one false false true) (by decide)

end MovesReadExternal

namespace SynchronousCopy

/-- One synchronous step's weight for the external bit, out of 4: it stays at 3 and flips at 1. -/
def externalStep (e e' : Bool) : Nat := if e' = e then 3 else 1

/-- The sensory bit copies the external bit, missing `miss` times in 4. -/
def sensoryStep (miss : Nat) (e s' : Bool) : Nat := if s' = e then 4 - miss else miss

/-- The internal bit copies the sensory bit. -/
def internalStep (s μ' : Bool) : Nat := if μ' = s then 4 else 0

/-- One synchronous step of all three parts, out of 64: each part's factor reads only what
`Blanket.Blanketed` lets it read. -/
def kernel (miss : Nat) (x y : Bool × Bool × Bool) : Nat :=
  match x, y with
  | (_, s, e), (μ', s', e') => internalStep s μ' * sensoryStep miss e s' * externalStep e e'

def states : List (Bool × Bool × Bool) :=
  [(false, false, false), (false, false, true), (false, true, false), (false, true, true),
   (true, false, false), (true, false, true), (true, true, false), (true, true, true)]

/-- Steady weights with the sensory copy exact. -/
def exactWeight : Bool × Bool × Bool → Nat
  | (false, false, false) => 9 | (false, false, true) => 3
  | (false, true, false) => 1  | (false, true, true) => 3
  | (true, false, false) => 3  | (true, false, true) => 1
  | (true, true, false) => 3   | (true, true, true) => 9

/-- Steady weights with the sensory copy missing once in 4. -/
def noisyWeight : Bool × Bool × Bool → Nat
  | (false, false, false) => 6 | (false, false, true) => 3
  | (false, true, false) => 3  | (false, true, true) => 4
  | (true, false, false) => 4  | (true, false, true) => 3
  | (true, true, false) => 3   | (true, true, true) => 6

def exactW (μ s e : Bool) : Nat := exactWeight (μ, s, e)

def noisyW (μ s e : Bool) : Nat := noisyWeight (μ, s, e)

/-- With the sensory copy exact, one step carries the weights to themselves, times 64. -/
theorem exact_steady (μ s e : Bool) :
    total states (fun x => exactWeight x * kernel 0 x (μ, s, e)) = 64 * exactWeight (μ, s, e) := by
  cases μ <;> cases s <;> cases e <;> decide

/-- With the sensory copy missing once in 4, likewise. -/
theorem noisy_steady (μ s e : Bool) :
    total states (fun x => noisyWeight x * kernel 1 x (μ, s, e)) = 64 * noisyWeight (μ, s, e) := by
  cases μ <;> cases s <;> cases e <;> decide

/-- **With the sensory copy exact, the steady weights are conditionally independent given the
blanket**, on any listings. -/
theorem exact_independentGiven (li le : List Bool) : IndependentGiven li le exactW :=
  independentGiven_of_crossFormOn li le exactW (crossFormOn_of_crossForm li le exactW fun μ μ' s e e' => by
    cases μ <;> cases μ' <;> cases s <;> cases e <;> cases e' <;> decide)

/-- **With a miss, they are not**: at sensory state `false`, of the weight 16, internal `false`
weighs 9, external `true` weighs 6, and both weigh 3, while `3·16` is not `9·6`. -/
theorem noisy_not_independentGiven : ¬ IndependentGiven [false, true] [false, true] noisyW := fun h =>
  absurd (h false (fun μ => !μ) (fun e => e)) (by delta Share.Same; decide)

end SynchronousCopy

namespace Cycle

/-- A blanketed law: the external part a two-bit counter running through four states, the sensory
part reading its upper bit, the internal part copying the sensory part. -/
def law : Blanket.Blanketed Bool Bool Unit (Bool × Bool) where
  nextInternal _ s _ := s
  nextSensory _ _ e := e.1
  nextActive _ _ _ := ()
  nextExternal _ _ e := (xor e.1 e.2, !e.2)

/-- A start on its cycle: the counter at two. -/
def start : Blanket.Parts Bool Bool Unit (Bool × Bool) := ⟨false, false, (), (true, false)⟩

/-- The run read on the internal, sensory and external parts. -/
def run (n : Nat) : Bool × Bool × (Bool × Bool) :=
  ((law.course start n).internal, (law.course start n).sensory, (law.course start n).external)

/-- The occupation weighting over one period, the blanket being the sensory and active parts. -/
def w (μ : Bool) (b : Bool × Unit) (e : Bool × Bool) : Nat := Blanket.visits run 4 (μ, b.1, e)

theorem periodic : run 4 = run 0 := rfl

/-- The occupation weighting is not in cross form: at the sensory state `false`, internal `false`
comes only with the counter at two, internal `true` only with the counter at one. -/
theorem not_crossForm : ¬ CrossForm w := fun h =>
  absurd (h false true (false, ()) (true, false) (false, true)) (by decide)

end Cycle

namespace Uncovered

open Turning (Phase)

/-- At one blanket state, internal `zero` weighs only with external `zero`, internal `one` only with
external `one`, and internal `two` weighs nothing. -/
def w (μ : Phase) (_b : Unit) (e : Phase) : Nat :=
  match μ with
  | .zero => match e with | .zero => 1 | .one => 0 | .two => 0
  | .one => match e with | .zero => 0 | .one => 1 | .two => 0
  | .two => 0

/-- On listings of `two` alone, it is in cross form: every listed weight vanishes. -/
theorem crossFormOn : CrossFormOn [Phase.two] [Phase.two] w := by
  intro i i' b e e' hi hi' _ _
  cases hi with
  | head => cases hi' with
    | head => rfl
    | tail _ h => nomatch h
  | tail _ h => nomatch h

/-- **The cross form on listings that do not cover the types does not give the cross form.** -/
theorem not_crossForm : ¬ CrossForm w := fun h =>
  absurd (h .zero .one () .zero .one) (by decide)

end Uncovered

end BlanketWeights

end Becoming
