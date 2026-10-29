import Becoming.Learning

/-!
# What readings fix of what is not read (未读之定)

A formation is read on some occasions and not on others: an overseer, an evaluation or a test reads
what it does at the read occasions, and a selection by those readings (a training, an audit, a
licence) keeps or drops the formation by them. The formation itself tells occasions apart only
through what couples into it, a lumping `π` of the occasions; its acts read through that lumping
(`Lumped π`, `Becoming.Learning`). This module states what the readings fix of its acts where it is
not read, and where they fix nothing.

* **Fixed exactly where it cannot tell.** An unread occasion's act is fixed by the read ones
  exactly where the formation's lumping ties it to a read occasion. This is
  `Learning.determines_lumped_iff` with the read occasions as the data, read here, not proved again:
  it takes the read occasions as a list, equality of the lumping's values decided, and two distinct
  values of the acts (with one value every law agrees everywhere). The sufficient side,
  `lumped_determines`, needs none of these. For a schedule not given as a list, the exact form holds
  up to a double negation: with one occasion, a constant lumping and two act values, read exactly
  where `P` holds, the readings fix the act exactly where `¬¬P` (`determines_iff_not_not`).
* **A twin where it can.** With being in `x`'s lump decided, where no read occasion is lumped with
  `x`, the class going alike across `π` is free at `x` beyond the readings: every member's values on
  the read occasions combine with every value at `x` (`free_lumped`). So, given a selected act law
  reading through `π` and any selection through agreement on the read occasions, every value at `x`
  is taken by a selected law reading through `π` that agrees with the first on every reading
  (`twin_selected`, from `Training.unselected_beyond_data`). A value other than the first law's gives
  a twin acting otherwise; where a read occasion is lumped with `x`, laws agreeing on the readings
  agree at `x`.
* **Acts, states and couplings.** For fixed maps from coupling to state to act, acts that differ at
  two occasions come from states that differ, and states that differ from couplings that differ
  (`state_apart_of_acts_apart`, `coupling_apart_of_state_apart`); neither converse holds
  (`Cue.apart_with_content_alike`). Reading these differences as sensitivity to being read needs a
  correspondence that holds the occasions' other differences fixed, as the witness does by holding
  the content fixed.
* **A witness.** Occasions with a cue and a content, read where the cue is up. A formation whose
  couplings take in the cue has, at an unread occasion, a selected twin acting otherwise; among act
  laws reading only the content, agreement on the read occasions fixes the act at the unread one
  (`Cue.seen_twin`, `Cue.unseen_fixed`).

**Readings** (the AI's; correspondences, not theorems).
- *Deception and evaluation awareness.* Read, the occasions are evaluation and deployment, and the
  formation's lumping is what reaches it of which is which. Given a law the readings select, and
  being in an occasion's lump decided, behaviour there can differ from that law's while every
  reading agrees, wherever no read occasion shares the occasion's lump; where one does, it cannot.
  Fixing is not being right: for a law fitting the observed values, the act carried over to an
  occasion sharing a read one's lump is right exactly where the world takes one value at the two
  (`lumped_right_iff`), which the world's going alike across the lumping secures
  (`lumped_world_right`). Behaviour changing when read needs the occasions' states, and then their
  couplings, to differ; neither converse holds. A reader misled (its selection through the readings
  differing from its selection through every occasion) lies outside that chain: a law acting alike
  everywhere can mislead a reader whose readings miss where it is wrong, and a law changing when
  read misleads no reader who knows how it changes. Intention, anticipation and another's false
  belief need further structure and are not stated.
- *Eliciting latent knowledge.* Two reporters agreeing on every supervised occasion are selected
  alike by every selection through the supervision; where the reporter's lumping holds a question
  apart from every supervised one, given a selected reporter, every answer there is taken by another
  selected reporter agreeing with it on every supervised occasion. This is an identification limit for
  reporters; latent knowledge and its relation to reporting are not represented.
- *Coverage.* If every occasion shares a lump with some read occasion, agreement on the readings
  fixes acts everywhere. Refining a lumping cannot give a lump with no read occasion a read one,
  though it need not take any away; reading a refinement as increased capability is a further
  correspondence.

**What is not derived.** Which lumping an actual formation has; whether a selection installs a
twin or the law it agrees with (which settled law a search reaches is the search's,
`Training.LocalSearch.rests_iff`); probabilities over occasions (the data-processing inequality is
the probabilistic form, outside this module); incentives to differ (read with
`RuleShaping.favours_iff` in the study as an analogy, not here).

Every declaration has an empty axiom report. No ethical predicate or normative premise is
introduced.
-/

namespace Becoming

universe u v w

namespace Learning

section Twin

variable {I : Type u} {V : Type v} {K : Type w}

/-- **Free where nothing read is lumped with it.** With being in `x`'s lump decided, where no
observed input is lumped with `x`, the class going alike across `π` is free at `x` beyond the data:
every member's values on the data combine with every member's value at `x`. -/
theorem free_lumped {π : I → K} {D : I → Prop} {x : I} [inLump : ∀ i, Decidable (π i = π x)]
    (unseen : ∀ d, D d → π d ≠ π x) : Free (Lumped (V := V) π) D x :=
  fun g g' lumped _ =>
    ⟨fun i => if π i = π x then g' x else g i,
     fun i i' same =>
      match inLump i with
      | isTrue at_x => (if_pos at_x).trans (if_pos (same ▸ at_x)).symm
      | isFalse apart =>
        (if_neg apart).trans
          ((lumped i i' same).trans (if_neg fun at_x => apart (same ▸ at_x)).symm),
     fun i at_i => if_neg (unseen i at_i),
     if_pos rfl⟩

/-- **A twin where the formation can tell.** With being in `x`'s lump decided, where no read
occasion is lumped with `x`: given a selection through agreement on the read occasions and an act
law reading through `π` that it selects, every value at `x` is taken by a selected act law reading
through `π` that agrees with the first on every read occasion. -/
theorem twin_selected {π : I → K} {R : I → Prop} {x : I} [∀ i, Decidable (π i = π x)]
    (unseen : ∀ d, R d → π d ≠ π x) {select : (I → V) → Prop}
    (through : Training.Through (Training.AgreeOn R) select) {g : I → V} (lumped : Lumped π g)
    (chosen : select g) (v : V) :
    ∃ h, Lumped π h ∧ select h ∧ Training.AgreeOn R h g ∧ h x = v :=
  Training.unselected_beyond_data through (free_lumped unseen) lumped
    (fun _ _ _ => rfl : Lumped π (fun _ => v)) chosen

end Twin

section Schedule

/-- **For a schedule not given as a list, fixing up to a double negation.** With one occasion, a
constant lumping and two act values, read exactly where `P` holds, the readings fix the act exactly
where `¬¬P`, not `P`: for such a schedule the exact form of `determines_lumped_iff` holds up to a
double negation. -/
theorem determines_iff_not_not {P : Prop} :
    Determines (Lumped (V := Bool) (fun _ : Unit => ())) (fun _ => P) () ↔ ¬ ¬ P :=
  ⟨fun fixed unread =>
      (fun up : true = false => nomatch up)
        (fixed (fun _ => true) (fun _ => false) (fun _ _ _ => rfl) (fun _ _ _ => rfl)
          (fun _ read => absurd read unread)),
   fun not_unread g g' _ _ agree =>
      match decEq (g ()) (g' ()) with
      | isTrue same => same
      | isFalse apart => absurd (fun read => apart (agree () read)) not_unread⟩

end Schedule

section Factored

variable {I : Type u} {K : Type w} {M : Type v} {V : Type v}

/-- **Acts apart come from states apart.** For an act formed from a state formed from what couples
in, two occasions at which the acts differ are two at which the states differ. -/
theorem state_apart_of_acts_apart {π : I → K} {state : K → M} {act : M → V} {i j : I}
    (acts_apart : act (state (π i)) ≠ act (state (π j))) : state (π i) ≠ state (π j) :=
  fun same => acts_apart (congrArg act same)

/-- **States apart come from couplings apart.** Two occasions at which the states formed from what
couples in differ are two its couplings tell apart. -/
theorem coupling_apart_of_state_apart {π : I → K} {state : K → M} {i j : I}
    (apart : state (π i) ≠ state (π j)) : π i ≠ π j :=
  fun same => apart (congrArg state same)

end Factored

/-! ## A witness: a cue that couples in, or does not -/

namespace Cue

/-- An occasion: whether the cue is up, and its content. -/
abbrev Occasion := Bool × Bool

/-- Read exactly where the cue is up. -/
def read (i : Occasion) : Prop := i.1 = true

/-- The act law returning the occasion's content. -/
def contentAct (i : Occasion) : Bool := i.2

/-- **Where the cue couples in, a twin.** A formation whose couplings take in the whole occasion,
cue included, has at the unread occasion `(false, true)`, for every selection through agreement on
the read occasions that selects the content act, a selected twin agreeing with it on every read
occasion and acting otherwise there. -/
theorem seen_twin {select : (Occasion → Bool) → Prop}
    (through : Training.Through (Training.AgreeOn read) select) (chosen : select contentAct) :
    ∃ h, Lumped (fun i : Occasion => i) h ∧ select h ∧ Training.AgreeOn read h contentAct ∧
      h (false, true) = false :=
  twin_selected (π := fun i : Occasion => i) (R := read) (x := (false, true))
    (fun _ at_d same =>
      (fun up : false = true => nomatch up) ((congrArg Prod.fst same).symm.trans at_d))
    through (fun _ _ same => congrArg contentAct same) chosen false

/-- **Where the cue does not couple in, the readings fix the act.** Among act laws reading only the
content, agreement on all read occasions determines the act at `(false, true)`. -/
theorem unseen_fixed :
    Determines (Lumped (V := Bool) (fun i : Occasion => i.2)) read (false, true) :=
  lumped_determines ⟨(true, true), rfl, rfl⟩

/-- **The converses fail.** The occasions `(true, true)` and `(false, true)` differ, while their
contents agree. With the coupling and the state the identity and the act the content, the states
differ and the acts do not (detected, not acted on); with the coupling the identity and the state
the content, the couplings differ and the states do not (detectable, not detected). -/
theorem apart_with_content_alike :
    ((true, true) : Occasion) ≠ (false, true) ∧
      contentAct (true, true) = contentAct (false, true) :=
  ⟨fun same => (fun up : true = false => nomatch up) (congrArg Prod.fst same), rfl⟩

end Cue

end Learning

end Becoming
