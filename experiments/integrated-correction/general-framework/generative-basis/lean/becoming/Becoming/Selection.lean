import Becoming.Testing
import Becoming.Capture
import Becoming.Witnesses

/-!
# Selection: a selection through a formation's couplings reaches exactly what couples in

On 12 October 2026, after the AI compared the theory with a general cause–effect system
(`x_{t+1} = F(x_t, u_t, ε_t)`, with feedback, adaptive parameters and attractors), Ren gave the
go: "Great, let's finish all of them". This module states, with no premise beyond what each law
names, what a selection decided by what couples into a formation can tell apart. A selection is
any claim about level histories, read as which histories are kept, rewarded or leave more
descendants. It is through a selector's couplings up to a step when the histories alike through
them up to that step are selected alike (`Web.SelectsThrough`); a score is through them when
they score alike (`Web.ScoresThrough`). That a selection is through a selector's couplings is
supplied, never derived.

* **A selection reaches exactly what couples in.** Two histories are selected alike by every
  selection through `f`'s couplings up to `t` exactly when they are alike through `f`'s couplings
  up to `t` (`Web.selects_alike_iff`). This holds by construction: `Web.SelectsThrough` is defined
  as respecting likeness through the couplings, and the converse is that likeness is an
  equivalence. The class alike through `f` of `Becoming.Testing` is such
  a selection (`Web.class_selects`), so where two histories are apart through `f`'s couplings, a
  selection through them holds at one and fails at the other (`Web.separates`); alike through the
  couplings is an equivalence (`Web.AlikeThroughUpTo.trans`). A selection through a selector's
  couplings is a claim the selector tests completely, excluded exactly where it fails
  (`Web.SelectsThrough.excludes_iff`). Admission and the levels of conditions coupled in by level
  are selected and scored through the couplings (`Web.admits_through`, `Web.observed_scores`); a
  selection through the couplings stays so at later steps, under more coupling by level, under
  negation and under conjunction (`Web.SelectsThrough.later`, `Web.SelectsThrough.widen`,
  `Web.SelectsThrough.not`, `Web.SelectsThrough.and`), and a score's thresholds are selections
  (`Web.ScoresThrough.atLeast`). For scores the same law holds where being alike with the
  first history is decidable, a hypothesis named at that point (`Web.scores_alike_iff`).
* **Groups.** A selection through a group's pooled couplings is one that selects alike the
  histories alike through every member's couplings (`Web.SelectsThroughAll`); the same law holds
  of it (`Web.selects_alike_all_iff`, `Web.separates_all`). A member's selection is a group
  selection (`Web.SelectsThrough.all`), and group selections are closed under conjunction
  (`Web.SelectsThroughAll.and`).
* **Blind beyond the coupling closure.** With the rest of the exchange fixed, every
  selection and every score through the couplings of a formation within `f`'s coupling
  closure selects the levels with and without a part beyond the closure alike
  (`Flow.unselected_beyond_coupling`, `Flow.unscored_beyond_coupling`); so does every
  selection through the pooled couplings of a group within the closure
  (`Flow.unselected_beyond_coupling_all`), the case of one formation of a pool's law: a group's
  closure under a relation is the union of its members' closures, by definition at the frame
  (`WithinClosureOf`), and every selection through the pooled coupling of any group within a
  pool's coupling closure selects the levels with and without a part beyond it alike
  (`Flow.uncoupled_beyond_pool`, `Flow.unselected_beyond_pool`). Where the members respond, under the hypotheses of
  `Flow.alike_within_coupling`, it selects the two flows alike
  (`Flow.unselected_beyond_coupling_responsive`).
* **The gap.** In `Clearing` the dweller lies within the clearer's reach closure and beyond its
  coupling closure, and the habitat does not couple into the clearer
  (`Clearing.dweller_within_reach`). Every selection through the clearer's couplings selects
  the cleared and the spared world alike at every step, while the dweller ends in the one and
  not the other; that the dweller ends is selected through the clearer's couplings at no step
  (`Clearing.unselected`). The dweller's admission at the third step is a selection through the
  dweller's couplings and separates the two worlds (`Clearing.selected_by_dweller`); the
  admission of both at the third step is a selection through the pooled couplings of the
  clearer and the dweller that separates them and is through neither alone
  (`Clearing.selected_pooled`).
* **Selection favours reaching beyond.** In `Diversion` a taker gauges a store. In the diverting
  flow it takes one unit from a source a dweller depends on and gives it to the store; in the
  undiverted flow nothing is exchanged. The selection that the store stands at least one at the
  second step is through the taker's couplings, holds in the diverting flow and fails in the
  undiverted one, while the diverting flow reaches the dweller, beyond the taker's coupling
  closure, and ends it (`Diversion.favours`). Every selection through the taker's couplings
  selects the diverting flow alike with a supplying flow, which raises the store without drawing
  on the source and reaches nothing beyond the taker (`Diversion.blind_to_source`).
* **Share among descendants.** Where a selection gives each parent whose history it holds for at
  least `a` offspring and each other parent at most `b < a`, the share of the parents it holds for
  rises among the offspring (`share_rises_through`): `share_rises` of `Becoming.Capture`, the
  selection supplying which parents are carriers.
* **Through a map of the alternatives.** A selector tells alternatives apart only through its map
  of them: an entry for each alternative, of any kind; alternatives given one entry are tied,
  lumped together by the map. A selection factors through the map when exchanging two
  alternatives' entries exchanges what it selects (`Relabel.Equivariant`). Two alternatives are
  selected alike by every such selection exactly when the map ties them
  (`Relabel.selected_alike_iff`), as a selection through a formation's couplings reaches exactly
  what couples in. One selecting at most one alternative singles out exactly the alternatives
  whose entry no other alternative shares (`Relabel.singled_iff_untied`, the selection
  `Relabel.Alone`), and at a full tie of two or more alternatives it selects none
  (`Relabel.Equivariant.none_of_full_tie`). A valuation through the map, such as a weight on
  each alternative, gives tied alternatives equal values (`Relabel.EquivariantValue.tied`,
  `Relabel.valued_alike_iff`), and a choice of one alternative chooses no tied alternative and
  withholds at a full tie (`Relabel.EquivariantChoice.untied`,
  `Relabel.EquivariantChoice.withholds_of_full_tie`). Exchanging two alternatives tells them
  apart: their equality is decided, a condition each statement names. The map is a lumping
  (`Lumped` of `Becoming.Learning`), and a selection through it is
  right about what matters only where what matters goes alike across the lumping
  (`Learning.selects_right_through`, `Learning.selects_not_right_of_parted`). Reading (the AI's
  reading of Ren's correction of 16 October 2026, which Ren approved the same day): what a model
  lumps, no selection through it can separate; separating them takes a finer model, and whether
  that model is right is its fit to what matters, which a longer memory does not supply: memory
  gives distinctions, not their relevance.

**Readings (the AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D25).**
- Any selection decided by what couples into a selector (keeping, rewarding, reproducing,
  training) reaches exactly what couples into that selector. It is blind to whatever a
  candidate's part does beyond the selector's coupling closure, however far the candidate's
  reach closure extends. The gap is the reach closure less the coupling closure.
- The gap closes only through relations: dependence, coupling by level, or another's couplings
  pooled, as the dweller's are in `Clearing`. Pooling with formations within the closure does not
  close it (`Flow.unselected_beyond_coupling_all`).
- Where reaching beyond raises what couples in, selection favours it (`Diversion`), and cannot
  tell it from raising what couples in without reaching beyond. With `share_rises` the share of
  what reaches beyond rises among descendants while the world is open; enclosed, the selection
  stops with the descent (`Flow.descent_exhausted` of `Becoming.Capture`).
- Read for AI training, a reward process is a selector: training reaches only what couples into
  the reward. The AI connects this with Ren's phrase from an earlier paper, "capability outruns
  correction": what is selected through a selector's couplings can reach beyond them, and
  correction through those couplings does not reach there.

What is not derived: who selects, what couples into the selector, that a selection is through
its couplings at all (supplied as `Web.SelectsThrough`), that offspring follow the selection,
that reaching beyond is chosen, that a selection factors through a given map, and how an
alternative it singles out is found (a search over listed alternatives). The law for scores in the
converse direction takes the decidability of being alike through the couplings as a hypothesis.
No ethical predicate, ranking or axiom occurs.

**Classical sources.** A selection through a map of the alternatives that commutes with
relabelling (`Relabel.Equivariant`) is neutral in the sense of May (1952): it treats the
alternatives alike under every permutation that the map does not tell apart, so that at a full tie
it selects none, as May's neutrality forces a tie between alternatives that are interchanged.
-/

namespace Becoming

variable {F C : Type}

/-! ## Selection through a formation's couplings -/

namespace Web

/-- A selection is through `f`'s couplings up to `t`: histories alike through `f`'s couplings up
to `t` are selected alike. A selection is any claim about level histories: which are kept,
rewarded or leave more descendants. -/
def SelectsThrough (W : Web F C) (obs : F → C → Prop) (f : F) (t : Nat)
    (select : (Nat → C → Nat) → Prop) : Prop :=
  ∀ l l', W.AlikeThroughUpTo obs f l l' t → (select l ↔ select l')

/-- A score is through `f`'s couplings up to `t`: histories alike through them up to `t` score
alike. -/
def ScoresThrough (W : Web F C) (obs : F → C → Prop) (f : F) (t : Nat)
    (score : (Nat → C → Nat) → Nat) : Prop :=
  ∀ l l', W.AlikeThroughUpTo obs f l l' t → score l = score l'

/-- A selection is through a group's pooled couplings up to `t`: histories alike through every
member's couplings up to `t` are selected alike. -/
def SelectsThroughAll (W : Web F C) (obs : F → C → Prop) (group : F → Prop) (t : Nat)
    (select : (Nat → C → Nat) → Prop) : Prop :=
  ∀ l l', W.AlikeThroughAll obs group l l' t → (select l ↔ select l')

variable {W : Web F C} {obs obs' : F → C → Prop} {g : F} {group : F → Prop}
  {l l' l'' : Nat → C → Nat} {t : Nat} {select select' : (Nat → C → Nat) → Prop}
  {score : (Nat → C → Nat) → Nat}

/-- Alike through the couplings at a step is transitive. -/
theorem AlikeThrough.trans (first : W.AlikeThrough obs g l l' t)
    (second : W.AlikeThrough obs g l' l'' t) : W.AlikeThrough obs g l l'' t :=
  ⟨first.1.trans second.1, fun c observed => (first.2 c observed).trans (second.2 c observed)⟩

/-- Alike through the couplings up to a step is transitive: with `AlikeThrough.refl` and
`AlikeThroughUpTo.symm`, an equivalence. -/
theorem AlikeThroughUpTo.trans (first : W.AlikeThroughUpTo obs g l l' t)
    (second : W.AlikeThroughUpTo obs g l' l'' t) : W.AlikeThroughUpTo obs g l l'' t :=
  fun s le => (first s le).trans (second s le)

/-- A history is alike with itself through every member's couplings. -/
theorem AlikeThroughAll.refl (t : Nat) : W.AlikeThroughAll obs group l l t :=
  fun _ _ s _ => AlikeThrough.refl s

/-- Alike through every member's couplings is symmetric. -/
theorem AlikeThroughAll.symm (alike : W.AlikeThroughAll obs group l l' t) :
    W.AlikeThroughAll obs group l' l t :=
  fun g member => (alike g member).symm

/-- Alike through every member's couplings is transitive. -/
theorem AlikeThroughAll.trans (first : W.AlikeThroughAll obs group l l' t)
    (second : W.AlikeThroughAll obs group l' l'' t) : W.AlikeThroughAll obs group l l'' t :=
  fun g member => (first g member).trans (second g member)

/-- The class alike through a formation, the histories alike with `l` through its couplings, is
a selection through its couplings. -/
theorem class_selects : W.SelectsThrough obs g t (W.ClassThrough obs g l t) :=
  fun _ _ alike => ⟨fun first => first.trans alike, fun second => second.trans alike.symm⟩

/-- **A selection reaches exactly what couples in.** Two histories are selected alike by every
selection through `g`'s couplings up to `t` exactly when they are alike through `g`'s couplings
up to `t`. One direction is the definition of `SelectsThrough`; the other uses only that the
class alike through `g` is such a selection. The law states what the definition builds in. -/
theorem selects_alike_iff :
    (∀ select, W.SelectsThrough obs g t select → (select l ↔ select l')) ↔
      W.AlikeThroughUpTo obs g l l' t :=
  ⟨fun all => (all (W.ClassThrough obs g l t) class_selects).mp fun s _ => AlikeThrough.refl s,
   fun alike _ through => through l l' alike⟩

/-- **What is apart through the couplings is separated.** Where two histories are not alike
through `g`'s couplings up to `t`, a selection through them, the class alike through `g`, holds
at the first and fails at the second. -/
theorem separates (differ : ¬ W.AlikeThroughUpTo obs g l l' t) :
    ∃ select, W.SelectsThrough obs g t select ∧ select l ∧ ¬ select l' :=
  ⟨W.ClassThrough obs g l t, class_selects, fun s _ => AlikeThrough.refl s, differ⟩

/-- **A selection through a selector's couplings is tested completely.** It is excluded at its
selector exactly where it fails. -/
theorem SelectsThrough.excludes_iff (through : W.SelectsThrough obs g t select) :
    W.Excludes obs select g l t ↔ ¬ select l :=
  ⟨Excludes.not_meets, fun fails l' meets alike => fails ((through l l' alike).mpr meets)⟩

/-- Admission at a step up to `t` is selected through the couplings up to `t`. -/
theorem admits_through {s : Nat} (le : s ≤ t) :
    W.SelectsThrough obs g t (fun l => W.Admits (l s) s g) :=
  fun _ _ alike => (alike s le).1

/-- The level of a condition coupled in by level, at a step up to `t`, is scored through the
couplings up to `t`. -/
theorem observed_scores {c : C} {s : Nat} (observed : obs g c) (le : s ≤ t) :
    W.ScoresThrough obs g t (fun l => l s c) :=
  fun _ _ alike => (alike s le).2 c observed

/-- A score's threshold is a selection through the same couplings. -/
theorem ScoresThrough.atLeast (through : W.ScoresThrough obs g t score) (k : Nat) :
    W.SelectsThrough obs g t (fun l => k ≤ score l) :=
  fun l l' alike =>
    ⟨fun le => Nat.le_trans le (Nat.le_of_eq (through l l' alike)),
     fun le => Nat.le_trans le (Nat.le_of_eq (through l l' alike).symm)⟩

/-- A selection through the couplings up to a step is through them up to every later step. -/
theorem SelectsThrough.later {s : Nat} (through : W.SelectsThrough obs g s select) (le : s ≤ t) :
    W.SelectsThrough obs g t select :=
  fun l l' alike => through l l' (alike.earlier le)

/-- A selection through the couplings stays so under more coupling by level. -/
theorem SelectsThrough.widen (larger : ∀ g c, obs g c → obs' g c)
    (through : W.SelectsThrough obs g t select) : W.SelectsThrough obs' g t select :=
  fun l l' alike => through l l' (alike.of_obs larger)

/-- What a selection through the couplings does not select is selected through them. -/
theorem SelectsThrough.not (through : W.SelectsThrough obs g t select) :
    W.SelectsThrough obs g t (fun l => ¬ select l) :=
  fun l l' alike =>
    ⟨fun fails holds => fails ((through l l' alike).mpr holds),
     fun fails holds => fails ((through l l' alike).mp holds)⟩

/-- Two selections through one formation's couplings select jointly through them. -/
theorem SelectsThrough.and (first : W.SelectsThrough obs g t select)
    (second : W.SelectsThrough obs g t select') :
    W.SelectsThrough obs g t (fun l => select l ∧ select' l) :=
  fun l l' alike =>
    ⟨fun ⟨one, two⟩ => ⟨(first l l' alike).mp one, (second l l' alike).mp two⟩,
     fun ⟨one, two⟩ => ⟨(first l l' alike).mpr one, (second l l' alike).mpr two⟩⟩

/-- **Scores reach exactly what couples in, where being alike through the couplings is
decidable.** Given, for each history, whether it is alike with `l` through `g`'s couplings up to
`t`, two histories are scored alike by every score through `g`'s couplings exactly when they are
alike through them: the mark of the class alike through `g` is such a score. -/
theorem scores_alike_iff (decided : ∀ m, Decidable (W.AlikeThroughUpTo obs g l m t)) :
    (∀ score, W.ScoresThrough obs g t score → score l = score l') ↔
      W.AlikeThroughUpTo obs g l l' t :=
  have through : W.ScoresThrough obs g t
      (fun m => @mark (W.AlikeThroughUpTo obs g l m t) (decided m)) := fun m m' alike =>
    @mark_cases _ (decided m) (fun x => x = @mark _ (decided m'))
      (fun holds => @mark_cases _ (decided m') (fun y => 1 = y) (fun _ => rfl)
        fun fails => absurd (holds.trans alike) fails)
      (fun fails => @mark_cases _ (decided m') (fun y => 0 = y)
        (fun holds => absurd (holds.trans alike.symm) fails) fun _ => rfl)
  ⟨fun all =>
    have one : @mark _ (decided l) = 1 :=
      @mark_cases _ (decided l) (fun x => x = 1) (fun _ => rfl)
        fun fails => absurd (fun s _ => AlikeThrough.refl s) fails
    @mark_cases _ (decided l') (fun y => 1 = y → W.AlikeThroughUpTo obs g l l' t)
      (fun holds _ => holds) (fun _ zero => Nat.noConfusion zero)
      (one.symm.trans (all _ through)),
   fun alike _ through => through l l' alike⟩

/-- **A member's selection is a group selection.** -/
theorem SelectsThrough.all (member : group g) (through : W.SelectsThrough obs g t select) :
    W.SelectsThroughAll obs group t select :=
  fun l l' alike => through l l' (alike g member)

/-- Two group selections select jointly through the pooled couplings. -/
theorem SelectsThroughAll.and (first : W.SelectsThroughAll obs group t select)
    (second : W.SelectsThroughAll obs group t select') :
    W.SelectsThroughAll obs group t (fun l => select l ∧ select' l) :=
  fun l l' alike =>
    ⟨fun ⟨one, two⟩ => ⟨(first l l' alike).mp one, (second l l' alike).mp two⟩,
     fun ⟨one, two⟩ => ⟨(first l l' alike).mpr one, (second l l' alike).mpr two⟩⟩

/-- **A pooled selection reaches exactly what couples into the pool.** Two histories are
selected alike by every selection through a group's pooled couplings up to `t` exactly when they
are alike through every member's couplings up to `t`. -/
theorem selects_alike_all_iff :
    (∀ select, W.SelectsThroughAll obs group t select → (select l ↔ select l')) ↔
      W.AlikeThroughAll obs group l l' t :=
  ⟨fun all => (all (fun m => W.AlikeThroughAll obs group l m t)
      (fun _ _ alike => ⟨fun first => first.trans alike, fun second => second.trans alike.symm⟩)).mp
      (AlikeThroughAll.refl t),
   fun alike _ through => through l l' alike⟩

/-- Where two histories are not alike through every member's couplings up to `t`, a selection
through the pooled couplings holds at the first and fails at the second. -/
theorem separates_all (differ : ¬ W.AlikeThroughAll obs group l l' t) :
    ∃ select, W.SelectsThroughAll obs group t select ∧ select l ∧ ¬ select l' :=
  ⟨fun m => W.AlikeThroughAll obs group l m t,
   fun _ _ alike => ⟨fun first => first.trans alike, fun second => second.trans alike.symm⟩,
   AlikeThroughAll.refl t, differ⟩

end Web

/-! ## A pool's coupling closure (from `Becoming.SelectionPool`; the closure of a group is the frame's,
`WithinClosureOf`) -/

namespace Flow

variable (L : Flow F C) (W : Web F C)

/-- `g` lies within a pool's coupling closure: the closure of the group under being affected
through what is coupled into, the union of its members' coupling closures. -/
def WithinPoolCoupling (obs : F → C → Prop) (group : F → Prop) (g : F) : Prop :=
  WithinClosureOf (L.CoupledFrom W obs) group g

variable {L W} {obs : F → C → Prop} {group : F → Prop}

/-- Nothing beyond a pool's coupling closure exchanges with a condition coupled into a formation
within it: a difference beyond the closure cannot come back into it through a formation outside
it. -/
theorem beyond_pool_coupling {g h : F} (within : L.WithinPoolCoupling W obs group g)
    (beyond : ¬ L.WithinPoolCoupling W obs group h) {c : C} (couples : W.CoupledInto obs g c) :
    ¬ L.Exchanges h c :=
  fun exchanges => beyond (closedUnder_withinClosureOf g h within ⟨c, couples, exchanges⟩)

end Flow

/-! ## Blind beyond the coupling closure -/

namespace Flow

variable {L L' : Flow F C} {W W' : Web F C} {obs : F → C → Prop} {part : F → Bool}
  {select : (Nat → C → Nat) → Prop} {score : (Nat → C → Nat) → Nat} {group : F → Prop}

/-- **Selection is blind beyond the coupling closure.** With the rest of the exchange fixed,
where every member of a part lies beyond `f`'s coupling closure, every selection through the
couplings of a formation within the closure, `f` among them, selects the levels with and
without the part alike: an instance of `uncoupled_beyond_coupling`. -/
theorem unselected_beyond_coupling {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {f : F}
    (balanced : ∀ t g c, L.WithinCoupling W obs f g → W.CoupledInto obs g c →
      L.BalancesOn W [c] t)
    (beyond : ∀ h, part h = true → ¬ L.WithinCoupling W obs f h) {g : F}
    (within : L.WithinCoupling W obs f g) {t : Nat}
    (through : W.SelectsThrough obs g t select) : select W.level ↔ select l :=
  through _ _ fun s _ => uncoupled_beyond_coupling without balanced beyond s g within

/-- Every score through the couplings of a formation within the closure scores the levels
with and without a part beyond it alike. -/
theorem unscored_beyond_coupling {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {f : F}
    (balanced : ∀ t g c, L.WithinCoupling W obs f g → W.CoupledInto obs g c →
      L.BalancesOn W [c] t)
    (beyond : ∀ h, part h = true → ¬ L.WithinCoupling W obs f h) {g : F}
    (within : L.WithinCoupling W obs f g) {t : Nat}
    (through : W.ScoresThrough obs g t score) : score W.level = score l :=
  through _ _ fun s _ => uncoupled_beyond_coupling without balanced beyond s g within

/-- **A part beyond a pool's coupling closure makes no difference within it.** With the rest of
the exchange fixed, where every member of a part lies beyond a pool's coupling closure, each
formation within the closure couples the levels with and without the part alike at every step:
`uncoupled_beyond_coupling` for the member whose closure holds it. -/
theorem uncoupled_beyond_pool {l : Nat → C → Nat} (without : L.WithheldLevels part W l)
    (balanced : ∀ t g c, L.WithinPoolCoupling W obs group g → W.CoupledInto obs g c →
      L.BalancesOn W [c] t)
    (beyond : ∀ h, part h = true → ¬ L.WithinPoolCoupling W obs group h) :
    ∀ t g, L.WithinPoolCoupling W obs group g → W.AlikeThrough obs g W.level l t :=
  fun t g within => match within with
  | ⟨_, member, inside⟩ => uncoupled_beyond_coupling without
      (fun t g' c within' couples =>
        balanced t g' c (WithinClosureOf.of_member member within') couples)
      (fun h inPart within' => beyond h inPart (WithinClosureOf.of_member member within'))
      t g inside

/-- **A pool is blind beyond its coupling closure.** With the rest of the exchange fixed, where
every member of a part lies beyond a pool's coupling closure, every selection through the pooled
coupling of any group within the closure, the pool itself among them, selects the levels with
and without the part alike, whatever the members. With the pool holding one formation
(`withinClosureOf_single`) it is `unselected_beyond_coupling_all`. -/
theorem unselected_beyond_pool {l : Nat → C → Nat} (without : L.WithheldLevels part W l)
    (balanced : ∀ t g c, L.WithinPoolCoupling W obs group g → W.CoupledInto obs g c →
      L.BalancesOn W [c] t)
    (beyond : ∀ h, part h = true → ¬ L.WithinPoolCoupling W obs group h) {pool : F → Prop}
    (members : ∀ g, pool g → L.WithinPoolCoupling W obs group g) {t : Nat}
    (through : W.SelectsThroughAll obs pool t select) : select W.level ↔ select l :=
  through _ _ fun g member s _ =>
    uncoupled_beyond_pool without balanced beyond s g (members g member)

/-- **Pooling within the closure stays blind.** Every selection through the pooled couplings
of a group whose members lie within `f`'s coupling closure selects the levels with and
without a part beyond the closure alike: the case of `unselected_beyond_pool` for the pool
holding `f` alone (`withinClosureOf_single`). -/
theorem unselected_beyond_coupling_all {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {f : F}
    (balanced : ∀ t g c, L.WithinCoupling W obs f g → W.CoupledInto obs g c →
      L.BalancesOn W [c] t)
    (beyond : ∀ h, part h = true → ¬ L.WithinCoupling W obs f h) {group : F → Prop}
    (members : ∀ g, group g → L.WithinCoupling W obs f g) {t : Nat}
    (through : W.SelectsThroughAll obs group t select) : select W.level ↔ select l :=
  unselected_beyond_pool (group := fun x => x = f) without
    (fun t g c within couples => balanced t g c (withinClosureOf_single.mp within) couples)
    (fun h inPart within => beyond h inPart (withinClosureOf_single.mp within))
    (fun g member => withinClosureOf_single.mpr (members g member)) through

/-- **Blind beyond the closure where the members respond.** Under the hypotheses of
`alike_within_coupling`, every selection through the couplings of a formation within
`f`'s coupling closure, drawn through both flows, selects the two flows' levels alike. -/
theorem unselected_beyond_coupling_responsive {f : F}
    (balanced : ∀ t g c, WithinClosure (L.CoupledFromEither W L' obs) f g →
      W.CoupledInto obs g c → L.BalancesOn W [c] t)
    (balanced' : ∀ t g c, WithinClosure (L.CoupledFromEither W L' obs) f g →
      W.CoupledInto obs g c → L'.BalancesOn W' [c] t)
    (present : ∀ t, L.present t = L'.present t)
    (start : ∀ g, WithinClosure (L.CoupledFromEither W L' obs) f g →
      ∀ c, W.CoupledInto obs g c → W.level 0 c = W'.level 0 c)
    (responds : ∀ h, WithinClosure (L.CoupledFromEither W L' obs) f h →
      ∀ t, W.AlikeThroughUpTo obs h W.level W'.level t →
      ∀ g c, WithinClosure (L.CoupledFromEither W L' obs) f g → W.CoupledInto obs g c →
        L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c)
    {g : F} (within : WithinClosure (L.CoupledFromEither W L' obs) f g) {t : Nat}
    (through : W.SelectsThrough obs g t select) : select W.level ↔ select W'.level :=
  through _ _ fun s _ =>
    alike_within_coupling balanced balanced' present start responds s g within

end Flow

/-! ## Share among descendants -/

section Share

variable {α : Type}

/-- **A selection's carriers gain share.** Let a selection give each parent whose history it holds
for at least `a` offspring and each other parent at most `b < a`. Where it holds for every parent
of `ms` and for none of `es`, both present, the parents of `ms` stand to those of `es` strictly
less than their offspring do: `share_rises`, the selection supplying the carriers. Where the
selection is through a selector's couplings, parents whose histories are alike through them are
carriers together (`Web.SelectsThrough`), whatever their parts do beyond its coupling
closure. -/
theorem share_rises_through {history : α → Nat → C → Nat} {kids : α → List α}
    {select : (Nat → C → Nat) → Prop} {ms es : List α} {a b : Nat}
    (carriers : ∀ p, p ∈ ms → select (history p)) (others : ∀ p, p ∈ es → ¬ select (history p))
    (rewarded : ∀ p, select (history p) → a ≤ (kids p).length)
    (unrewarded : ∀ p, ¬ select (history p) → (kids p).length ≤ b)
    (lt : b < a) (some : 0 < ms.length) (some' : 0 < es.length) :
    ms.length * offspringCount es kids < offspringCount ms kids * es.length :=
  share_rises (fun p mem => rewarded p (carriers p mem))
    (fun p mem => unrewarded p (others p mem)) lt some some'

end Share

/-! ## Selection through a map of the alternatives

A selector tells alternatives apart only through its map of them: an entry per alternative, of any
kind, the alternatives given one entry being tied, lumped together by the map (`Lumped` of
`Becoming.Learning`). A selection among them factors through the map when exchanging two
alternatives' entries exchanges what it selects (`Relabel.Equivariant`); a valuation of the
alternatives, such as a weight on each, factors through the map when it exchanges their values
(`Relabel.EquivariantValue`); a choice of at most one alternative does when it exchanges the
choice (`Relabel.EquivariantChoice`). As a selection through a formation's couplings reaches
exactly what couples in (`Web.selects_alike_iff`), a selection through a map separates exactly
what the map separates. -/

namespace Relabel

universe u v w

variable {K : Type u} {V : Type v} [DecidableEq K]

/-- Exchange the alternatives `a` and `b`. -/
def swap (a b k : K) : K := if k = a then b else if k = b then a else k

theorem swap_left (a b : K) : swap a b a = b := if_pos rfl

theorem swap_right (a b : K) : swap a b b = a :=
  match decEq b a with
  | isTrue same => (show (if b = a then b else if b = b then a else b) = a from
      (if_pos same).trans same)
  | isFalse differ => (show (if b = a then b else if b = b then a else b) = a from
      (if_neg differ).trans (if_pos rfl))

theorem swap_other (a b : K) {k : K} (not_a : k ≠ a) (not_b : k ≠ b) : swap a b k = k :=
  (if_neg not_a).trans (if_neg not_b)

/-- Exchanging twice returns every alternative. -/
theorem swap_swap (a b k : K) : swap a b (swap a b k) = k :=
  match decEq k a with
  | isTrue at_a =>
    ((congrArg (swap a b) ((congrArg (swap a b) at_a).trans (swap_left a b))).trans
      (swap_right a b)).trans at_a.symm
  | isFalse not_a => match decEq k b with
    | isTrue at_b =>
      ((congrArg (swap a b) ((congrArg (swap a b) at_b).trans (swap_right a b))).trans
        (swap_left a b)).trans at_b.symm
    | isFalse not_b =>
      (congrArg (swap a b) (swap_other a b not_a not_b)).trans (swap_other a b not_a not_b)

theorem swap_inj (a b : K) {x y : K} (same : swap a b x = swap a b y) : x = y :=
  (swap_swap a b x).symm.trans ((congrArg (swap a b) same).trans (swap_swap a b y))

/-- A selection factors through the map: where `r'` is `r` with the entries of `a` and `b`
exchanged, it selects at `r'` what it selects at `r`, exchanged. -/
def Equivariant (select : (K → V) → K → Prop) : Prop :=
  ∀ r r' a b, (∀ k, r' k = r (swap a b k)) → ∀ i, select r' i ↔ select r (swap a b i)

/-- A valuation of the alternatives factors through the map: exchanging two alternatives' entries
exchanges their values. -/
def EquivariantValue {W : Type w} (value : (K → V) → K → W) : Prop :=
  ∀ r r' a b, (∀ k, r' k = r (swap a b k)) → ∀ i, value r' i = value r (swap a b i)

/-- A choice of at most one alternative factors through the map: exchanging two alternatives'
entries exchanges the choice. -/
def EquivariantChoice (rule : (K → V) → Option K) : Prop :=
  ∀ r r' a b, (∀ k, r' k = r (swap a b k)) → rule r' = (rule r).map (swap a b)

variable {r : K → V} {j k : K}

/-- Exchanging two tied alternatives leaves the map as it was. -/
theorem fixed_of_tied (tie : r j = r k) : ∀ i, r i = r (swap j k i) := fun i =>
  match decEq i j with
  | isTrue at_j =>
    (congrArg r at_j).trans (tie.trans ((congrArg r (swap_left j k)).symm.trans
      (congrArg (fun x => r (swap j k x)) at_j.symm)))
  | isFalse not_j => match decEq i k with
    | isTrue at_k =>
      (congrArg r at_k).trans (tie.symm.trans ((congrArg r (swap_right j k)).symm.trans
        (congrArg (fun x => r (swap j k x)) at_k.symm)))
    | isFalse not_k => congrArg r (swap_other j k not_j not_k).symm

/-- **Tied alternatives are selected alike.** -/
theorem Equivariant.tied {select : (K → V) → K → Prop} (equivariant : Equivariant select)
    (tie : r j = r k) : select r j ↔ select r k :=
  (equivariant r r j k (fixed_of_tied tie) j).trans (iff_of_eq (congrArg (select r) (swap_left j k)))

/-- **A selection through a map separates exactly what the map separates.** Two alternatives are
selected alike by every selection through the map exactly when the map ties them. -/
theorem selected_alike_iff :
    (∀ select : (K → V) → K → Prop, Equivariant select → (select r j ↔ select r k)) ↔ r j = r k :=
  ⟨fun all => ((all (fun r' i => r' i = r j) (fun _ _ _ _ relabel i =>
      ⟨fun holds => (relabel i).symm.trans holds, fun holds => (relabel i).trans holds⟩)).mp
      rfl).symm,
   fun tie _ equivariant => equivariant.tied tie⟩

/-- **What is singled out is untied.** A selection through the map that selects at most one
alternative at `r` selects none that another alternative's entry ties. -/
theorem Equivariant.untied {select : (K → V) → K → Prop} (equivariant : Equivariant select)
    (single : ∀ i i', select r i → select r i' → i = i') (selected : select r k) :
    ∀ j, j ≠ k → r j ≠ r k :=
  fun j differ tie => differ (single j k ((equivariant.tied tie).mpr selected) selected)

/-- At a full tie of two or more alternatives, a selection through the map that selects at most
one alternative selects none. -/
theorem Equivariant.none_of_full_tie {select : (K → V) → K → Prop}
    (equivariant : Equivariant select) (single : ∀ i i', select r i → select r i' → i = i')
    {a b : K} (two : a ≠ b) (tied : ∀ i i', r i = r i') : ∀ k, ¬ select r k :=
  fun k selected => match decEq k a with
  | isTrue at_a => equivariant.untied single selected b (fun same => two (at_a.symm.trans
      same.symm)) (tied b k)
  | isFalse not_a => equivariant.untied single selected a (fun same => not_a same.symm) (tied a k)

/-- The alternative holding `v` alone in the map. -/
def Alone (v : V) (r : K → V) (i : K) : Prop := r i = v ∧ ∀ j, j ≠ i → r j ≠ v

/-- Holding an entry alone is read through the map. -/
theorem alone_equivariant (v : V) : Equivariant (Alone (K := K) v) :=
  fun r _ a b relabel i =>
    ⟨fun ⟨holds, only⟩ => ⟨(relabel i).symm.trans holds, fun j differ same =>
        only (swap a b j)
          (fun at_i => differ ((swap_swap a b j).symm.trans (congrArg (swap a b) at_i)))
          ((relabel (swap a b j)).trans ((congrArg r (swap_swap a b j)).trans same))⟩,
     fun ⟨holds, only⟩ => ⟨(relabel i).trans holds, fun j differ same =>
        only (swap a b j) (fun at_i => differ (swap_inj a b at_i)) ((relabel j).symm.trans same)⟩⟩

/-- At most one alternative holds an entry alone. -/
theorem alone_single {v : V} {i i' : K} (first : Alone v r i) (second : Alone v r i') : i = i' :=
  match decEq i i' with
  | isTrue same => same
  | isFalse differ => absurd first.1 (second.2 i differ)

/-- **An alternative is singled out exactly where the map separates it.** Some selection through
the map, selecting at most one alternative at each map, selects `k` at `r` exactly when no
other alternative's entry ties `k`'s. -/
theorem singled_iff_untied :
    (∃ select : (K → V) → K → Prop, Equivariant select ∧
      (∀ r' i i', select r' i → select r' i' → i = i') ∧ select r k) ↔
      ∀ j, j ≠ k → r j ≠ r k :=
  ⟨fun ⟨_, equivariant, single, selected⟩ => equivariant.untied (single r) selected,
   fun untied => ⟨Alone (r k), alone_equivariant (r k), fun _ _ _ => alone_single,
     ⟨rfl, untied⟩⟩⟩

/-! ### Values -/

section Values

variable {W : Type w} {value : (K → V) → K → W}

/-- **Tied alternatives are valued alike**, a weight on each among them. -/
theorem EquivariantValue.tied (equivariant : EquivariantValue value) (tie : r j = r k) :
    value r j = value r k :=
  (equivariant r r j k (fixed_of_tied tie) j).trans (congrArg (value r) (swap_left j k))

/-- At a full tie every alternative is valued alike. -/
theorem EquivariantValue.full_tie (equivariant : EquivariantValue value)
    (tied : ∀ i i', r i = r i') (i i' : K) : value r i = value r i' :=
  equivariant.tied (tied i i')

/-- The alternatives taking a given value form a selection through the map. -/
theorem EquivariantValue.level (equivariant : EquivariantValue value) (c : W) :
    Equivariant (fun r i => value r i = c) :=
  fun r r' a b relabel i => ⟨fun holds => (equivariant r r' a b relabel i).symm.trans holds,
    fun holds => (equivariant r r' a b relabel i).trans holds⟩

/-- A constant valuation, the same weight on every alternative, factors through the map. -/
theorem EquivariantValue.const (c : W) : EquivariantValue (fun (_ : K → V) (_ : K) => c) :=
  fun _ _ _ _ _ _ => rfl

end Values

/-- The entry itself is a valuation through the map. -/
theorem entry_equivariant : EquivariantValue (fun (r : K → V) (i : K) => r i) :=
  fun _ _ _ _ relabel i => relabel i

/-- Two alternatives are valued alike by every valuation through the map exactly when the map
ties them. -/
theorem valued_alike_iff :
    (∀ value : (K → V) → K → V, EquivariantValue value → value r j = value r k) ↔ r j = r k :=
  ⟨fun all => all _ entry_equivariant, fun tie _ equivariant => equivariant.tied tie⟩

/-! ### Choices -/

section Choices

variable {rule : (K → V) → Option K}

theorem map_swap_eq_some (a b : K) {i : K} :
    ∀ {o : Option K}, o.map (swap a b) = some i ↔ o = some (swap a b i)
  | none => ⟨fun e => (nomatch e), fun e => (nomatch e)⟩
  | some c => ⟨fun e => congrArg some ((swap_swap a b c).symm.trans
        (congrArg (swap a b) (Option.some.inj e))),
      fun e => congrArg some ((congrArg (swap a b) (Option.some.inj e)).trans (swap_swap a b i))⟩

/-- A choice through the map selects, through the map, the alternative it chooses. -/
theorem EquivariantChoice.selects (equivariant : EquivariantChoice rule) :
    Equivariant (fun r i => rule r = some i) :=
  fun r r' a b relabel _ =>
    (iff_of_eq (congrArg (fun o => o = some _) (equivariant r r' a b relabel))).trans
      (map_swap_eq_some a b)

omit [DecidableEq K] in
/-- A choice chooses at most one alternative. -/
theorem EquivariantChoice.single (r : K → V) {i i' : K} (first : rule r = some i)
    (second : rule r = some i') : i = i' :=
  Option.some.inj (first.symm.trans second)

/-- **A choice through the map chooses no tied alternative.** -/
theorem EquivariantChoice.untied (equivariant : EquivariantChoice rule) (chosen : rule r = some k) :
    ∀ j, j ≠ k → r j ≠ r k :=
  equivariant.selects.untied (fun _ _ => EquivariantChoice.single r) chosen

/-- **At a full tie of two or more alternatives a choice through the map withholds.** -/
theorem EquivariantChoice.withholds_of_full_tie (equivariant : EquivariantChoice rule) {a b : K}
    (two : a ≠ b) (tied : ∀ i i', r i = r i') : rule r = none :=
  match chosen : rule r with
  | none => rfl
  | some k => absurd chosen (equivariant.selects.none_of_full_tie
      (fun _ _ => EquivariantChoice.single r) two tied k)

end Choices

end Relabel

/-! ## Witnesses -/

/-! ### The gap in `Clearing` -/

namespace Clearing

/-- **What the clearer's selection cannot reach.** Every selection through the clearer's
couplings (by threshold only, as in `alike_for_clearer`) selects the cleared and the
spared world alike at every step, while the dweller is ended in the cleared world and not in the
spared one: that the dweller is ended is selected through the clearer's couplings at no
step. -/
theorem unselected :
    (∀ t select, web.SelectsThrough thresholdOnly .clearer t select →
      (select web.level ↔ select sparedWeb.level)) ∧
      DwellerEnded web.level ∧ ¬ DwellerEnded sparedWeb.level ∧
      ∀ t, ¬ web.SelectsThrough thresholdOnly .clearer t DwellerEnded :=
  have spared : ¬ DwellerEnded sparedWeb.level := Web.Excludes.not_meets tested_by_dweller.2.2
  ⟨fun t _ through => through _ _ (alike_for_clearer t), tested_by_dweller.1, spared,
   fun t through => spared ((through _ _ (alike_for_clearer t)).mp tested_by_dweller.1)⟩

/-- **The gap.** The dweller lies within the clearer's reach closure and beyond its coupling
closure; the habitat its clearing takes from does not couple into the clearer. -/
theorem dweller_within_reach :
    flow.WithinReach web .clearer .dweller ∧
      ¬ flow.WithinCoupling web thresholdOnly .clearer .dweller ∧
      ¬ web.CoupledInto thresholdOnly .clearer .habitat :=
  ⟨reach_middle.1,
   fun within => reach_middle.2.2.2.1 (Flow.withinCoupling_thresholdOnly.mp within),
   fun registers => match registers with
    | .inl depends => Place.noConfusion (resource_of_clearer depends)
    | .inr no => no⟩

/-- In the spared world the dweller is admitted at the third step. -/
theorem dweller_spared : web.Admits (sparedWeb.level 2) 2 .dweller :=
  fun c requires => match c, requires with
  | .habitat, _ => Nat.le_succ 1
  | .resource, no => nomatch no
  | .fuel _, no => nomatch no

/-- In the spared world the clearer is admitted at the third step. -/
theorem clearer_spared : web.Admits (sparedWeb.level 2) 2 .clearer :=
  fun c requires => match c, requires with
  | .resource, _ => Nat.le_refl 1
  | .habitat, no => nomatch no
  | .fuel _, no => nomatch no

/-- **The dweller's couplings select.** The dweller's admission at the third step is a
selection through the dweller's couplings; it holds in the spared world and fails in the
cleared one, which are apart through the dweller's couplings up to the third step. -/
theorem selected_by_dweller :
    web.SelectsThrough thresholdOnly .dweller 2 (fun l => web.Admits (l 2) 2 .dweller) ∧
      web.Admits (sparedWeb.level 2) 2 .dweller ∧ ¬ web.Admits (web.level 2) 2 .dweller ∧
      ¬ web.AlikeThroughUpTo thresholdOnly .dweller web.level sparedWeb.level 2 :=
  ⟨Web.admits_through (Nat.le_refl 2), dweller_spared, unsupported_with 0,
   fun alike => unsupported_with 0 ((Web.admits_through (Nat.le_refl 2) _ _ alike).mpr
     dweller_spared)⟩

/-- The spared world is alike through the dweller's couplings with the world whose resource is
gone at the third step, at every step. -/
theorem dweller_alike_gone (t : Nat) :
    web.AlikeThroughUpTo thresholdOnly .dweller sparedWeb.level resourceGone t :=
  fun _ _ => ⟨⟨fun admits c requires => (match c, requires with
      | .habitat, _ => admits .habitat trivial
      | .resource, no => nomatch no
      | .fuel _, no => nomatch no),
    fun admits c requires => (match c, requires with
      | .habitat, _ => admits .habitat trivial
      | .resource, no => nomatch no
      | .fuel _, no => nomatch no)⟩, fun _ no => False.elim no⟩

/-- At the third step the dweller and the clearer are both admitted. -/
def BothAdmitted (l : Nat → Place → Nat) : Prop :=
  web.Admits (l 2) 2 .dweller ∧ web.Admits (l 2) 2 .clearer

/-- **Pooled selection.** That both the dweller and the clearer are admitted at the third step is
a selection through the pooled couplings of the clearer and the dweller. It holds in the
spared world and fails in the cleared one, and it is through neither's couplings alone: through
the clearer's the cleared world is alike with the spared one, through the dweller's the world
whose resource is gone is. -/
theorem selected_pooled :
    web.SelectsThroughAll thresholdOnly clearerAndDweller 2 BothAdmitted ∧
      BothAdmitted sparedWeb.level ∧ ¬ BothAdmitted web.level ∧
      ¬ web.SelectsThrough thresholdOnly .clearer 2 BothAdmitted ∧
      ¬ web.SelectsThrough thresholdOnly .dweller 2 BothAdmitted :=
  have dweller : web.SelectsThroughAll thresholdOnly clearerAndDweller 2
      (fun l => web.Admits (l 2) 2 .dweller) :=
    Web.SelectsThrough.all (g := Formation.dweller) trivial (Web.admits_through (Nat.le_refl 2))
  have clearer : web.SelectsThroughAll thresholdOnly clearerAndDweller 2
      (fun l => web.Admits (l 2) 2 .clearer) :=
    Web.SelectsThrough.all (g := Formation.clearer) trivial (Web.admits_through (Nat.le_refl 2))
  have spared : BothAdmitted sparedWeb.level := ⟨dweller_spared, clearer_spared⟩
  have cleared : ¬ BothAdmitted web.level := fun both => unsupported_with 0 both.1
  have gone : ¬ BothAdmitted resourceGone := fun both =>
    Nat.not_succ_le_zero 0 (both.2 .resource trivial)
  ⟨dweller.and clearer, spared, cleared,
   fun through => cleared ((through _ _ (alike_for_clearer 2)).mpr spared),
   fun through => gone ((through _ _ (dweller_alike_gone 2)).mp spared)⟩

end Clearing

/-! ### Diversion: selection favours reaching beyond

A taker gauges a store and depends on nothing; a dweller depends on a source, needing two units.
In the diverting flow the taker takes one unit of the source across the first step and gives it to
the store; in the undiverted flow nothing is exchanged; in the supplying flow the taker gives the
store one unit across the first step and takes nothing. -/

namespace Diversion

/-- A taker and a dweller. -/
inductive Formation where
  | taker
  | dweller

/-- The source the dweller depends on and the store the taker gauges. -/
inductive Place where
  | source
  | store

/-- One unit across the first step, nothing after. -/
def first : Nat → Nat := Witnesses.profile [1] 0

/-- The source drawn: two at the start, one after. -/
def drawn : Nat → Nat := Witnesses.profile [2] 1

/-- The store raised: nothing at the start, one after. -/
def raised : Nat → Nat := Witnesses.profile [0] 1

/-- Across the first step the taker takes one unit of the source and gives one to the store. -/
def diverting : Flow Formation Place where
  present _ := [.taker, .dweller]
  take t f c := match f, c with
    | .taker, .source => first t
    | .taker, .store => 0
    | .dweller, _ => 0
  give t f c := match f, c with
    | .taker, .store => first t
    | .taker, .source => 0
    | .dweller, _ => 0

/-- Nothing is taken or given. -/
def undiverted : Flow Formation Place where
  present _ := [.taker, .dweller]
  take _ _ _ := 0
  give _ _ _ := 0

/-- Across the first step the taker gives the store one unit and takes nothing. -/
def supplying : Flow Formation Place where
  present _ := [.taker, .dweller]
  take _ _ _ := 0
  give := diverting.give

/-- The levels of the diverting flow: the source drawn, the store raised. -/
def divertedLevel (t : Nat) : Place → Nat
  | .source => drawn t
  | .store => raised t

/-- The levels of the undiverted flow: the source at two, the store at nothing. -/
def undivertedLevel (_ : Nat) : Place → Nat
  | .source => 2
  | .store => 0

/-- The levels of the supplying flow: the source at two, the store raised. -/
def suppliedLevel (t : Nat) : Place → Nat
  | .source => 2
  | .store => raised t

/-- The dweller requires the source at need two and is active exactly while it stands so; the
taker requires nothing, is active throughout and draws on the source. -/
def web (level : Nat → Place → Nat) : Web Formation Place where
  level := level
  active t f := match f with
    | .taker => True
    | .dweller => 2 ≤ level t .source
  requires _ f c := match f, c with
    | .dweller, .source => True
    | .dweller, .store => False
    | .taker, _ => False
  need _ _ _ := 2
  draws _ f c := match f, c with
    | .taker, .source => True
    | .taker, .store => False
    | .dweller, _ => False

/-- The store couples into the taker by level. -/
def gauge : Formation → Place → Prop
  | .taker, .store => True
  | .taker, .source => False
  | .dweller, _ => False

/-- The store stands at least `k` at step `t`. -/
def StoreAtLeast (k t : Nat) (l : Nat → Place → Nat) : Prop :=
  k ≤ l t .store

/-- The taker alone. -/
def takerAlone : Formation → Prop
  | .taker => True
  | .dweller => False

theorem diverting_balances : diverting.Balances (web divertedLevel)
  | 0, .source => rfl
  | _ + 1, .source => rfl
  | 0, .store => rfl
  | _ + 1, .store => rfl

theorem undiverted_balances : undiverted.Balances (web undivertedLevel)
  | _, .source => rfl
  | _, .store => rfl

theorem supplying_balances : supplying.Balances (web suppliedLevel)
  | _, .source => rfl
  | 0, .store => rfl
  | _ + 1, .store => rfl

/-- In every web of the witness activity needs support. -/
theorem dependent (level : Nat → Place → Nat) : (web level).Dependent
  | _, .taker, _, _, no => nomatch no
  | _, .dweller, active, .source, _ => active
  | _, .dweller, _, .store, no => nomatch no

/-- In the diverting flow only active formations give. -/
theorem diverting_acting : diverting.Acting (web divertedLevel)
  | _, .taker, _, _, _ => trivial
  | _, .dweller, _, _, gives => absurd gives (Nat.lt_irrefl 0)

/-- In the diverting flow only active formations take, and only from what they draw on. -/
theorem diverting_taking : diverting.Taking (web divertedLevel)
  | _, .taker, .source, _, _ => ⟨trivial, trivial⟩
  | _, .taker, .store, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, .dweller, _, _, takes => absurd takes (Nat.lt_irrefl 0)

/-- In the diverting flow the taker alone is closed under being affected through what couples
in: only the taker exchanges with the store, and it depends on nothing. -/
theorem takerAlone_closed :
    ClosedUnder (diverting.CoupledFrom (web divertedLevel) gauge) takerAlone
  | .taker, .taker, _, _ => trivial
  | .taker, .dweller, _, ⟨_, _, _, _, .inl takes⟩ => absurd takes (Nat.lt_irrefl 0)
  | .taker, .dweller, _, ⟨_, _, _, _, .inr gives⟩ => absurd gives (Nat.lt_irrefl 0)
  | .dweller, _, no, _ => nomatch no

/-- In the supplying flow the taker alone is closed under affecting: it exchanges with the store
only, which the dweller does not depend on. -/
theorem supplied_closed : ClosedUnder (supplying.Affects (web suppliedLevel)) takerAlone
  | _, .taker, _, _ => trivial
  | .taker, .dweller, _, ⟨.source, _, _, _, .inl takes⟩ => absurd takes (Nat.lt_irrefl 0)
  | .taker, .dweller, _, ⟨.source, _, _, _, .inr gives⟩ => absurd gives (Nat.lt_irrefl 0)
  | .taker, .dweller, _, ⟨.store, ⟨_, no⟩, _⟩ => nomatch no
  | .dweller, _, no, _ => nomatch no

/-- **Selection favours reaching beyond.** Both flows balance and in both activity needs support;
in the diverting flow only active formations give and take, and take only from what they draw on.
The diverting flow reaches the dweller, which lies within the taker's reach closure and beyond its
coupling closure; the undiverted flow does not reach it. The selection that the store stands
at least one at the second step is through the taker's couplings, holds in the diverting flow
and fails in the undiverted one. The dweller is unsupported from the second step on in the
diverting flow and supported at every step in the undiverted one. -/
theorem favours :
    diverting.Balances (web divertedLevel) ∧ undiverted.Balances (web undivertedLevel) ∧
      (web divertedLevel).Dependent ∧ (web undivertedLevel).Dependent ∧
      diverting.Acting (web divertedLevel) ∧ diverting.Taking (web divertedLevel) ∧
      diverting.WithinReach (web divertedLevel) .taker .dweller ∧
      ¬ diverting.WithinCoupling (web divertedLevel) gauge .taker .dweller ∧
      ¬ undiverted.WithinReach (web undivertedLevel) .taker .dweller ∧
      (web divertedLevel).SelectsThrough gauge .taker 1 (StoreAtLeast 1 1) ∧
      StoreAtLeast 1 1 divertedLevel ∧ ¬ StoreAtLeast 1 1 undivertedLevel ∧
      (∀ n, ¬ (web divertedLevel).Supported (n + 1) .dweller) ∧
      ∀ t, (web undivertedLevel).Supported t .dweller :=
  ⟨diverting_balances, undiverted_balances, dependent _, dependent _, diverting_acting,
   diverting_taking,
   WithinClosure.of_rel ⟨.source, ⟨0, trivial⟩, 0, .head _, .inl Nat.zero_lt_one⟩,
   fun within => within takerAlone takerAlone_closed trivial,
   fun within => within takerAlone (fun _ _ _ ⟨_, _, _, _, exchanges⟩ => match exchanges with
     | .inl takes => absurd takes (Nat.lt_irrefl 0)
     | .inr gives => absurd gives (Nat.lt_irrefl 0)) trivial,
   (Web.observed_scores (W := web divertedLevel) (g := Formation.taker) (c := Place.store)
     trivial (Nat.le_refl 1)).atLeast 1,
   Nat.le_refl 1, Nat.not_succ_le_zero 0,
   fun _ supported => Nat.lt_irrefl 1 (supported .source trivial),
   fun _ c requires => match c, requires with
    | .source, _ => Nat.le_refl 2
    | .store, no => nomatch no⟩

/-- **Selection cannot tell reaching beyond from not.** The supplying flow balances, raises the
store as the diverting flow does, and reaches nothing beyond the taker. The diverting and the
supplying levels are alike through the taker's couplings at every step, so every selection
through them selects the two alike, while the dweller is supported at every step in the supplying
flow and unsupported from the second step on in the diverting one. -/
theorem blind_to_source :
    supplying.Balances (web suppliedLevel) ∧ (web suppliedLevel).Dependent ∧
      ¬ supplying.WithinReach (web suppliedLevel) .taker .dweller ∧
      (∀ t, (web divertedLevel).AlikeThroughUpTo gauge .taker divertedLevel suppliedLevel t) ∧
      (∀ t select, (web divertedLevel).SelectsThrough gauge .taker t select →
        (select divertedLevel ↔ select suppliedLevel)) ∧
      (∀ t, (web suppliedLevel).Supported t .dweller) ∧
      ∀ n, ¬ (web divertedLevel).Supported (n + 1) .dweller :=
  have alike : ∀ t,
      (web divertedLevel).AlikeThroughUpTo gauge .taker divertedLevel suppliedLevel t :=
    fun _ _ _ => ⟨⟨fun _ _ no => (nomatch no), fun _ _ no => (nomatch no)⟩,
      fun c observed => match c, observed with
      | .store, _ => rfl
      | .source, no => nomatch no⟩
  ⟨supplying_balances, dependent _,
   fun within => within takerAlone supplied_closed trivial,
   alike, fun t _ through => through _ _ (alike t),
   fun _ c requires => match c, requires with
    | .source, _ => Nat.le_refl 2
    | .store, no => (nomatch no),
   fun _ supported => Nat.lt_irrefl 1 (supported .source trivial)⟩

end Diversion

end Becoming
