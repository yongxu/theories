import Becoming.Restoration
import Becoming.Witnesses
import Becoming.Grammar

/-!
# Arising: unceasing arising and renewal

The readings of `living` in `Becoming.Dependence` and `Becoming.Metaethics` read what an
event does not harm. None of them reads further generation. This module reads arising on
webs of dependence and relates it to renewal. Arising, becoming active, is the formal
carrier of one reading of the second 生 of 生生 (the author's reading); on Ren's delegation of 15
October 2026 the second 生 ranges over what can form, active or not, and arising on a consumed
condition is classed by the comparison (DELEGATED-CHOICES D3).

* A formation *arises* across a step when it is not active before the step and is
  active after it (`Arises`). Arising is *unceasing* when some formation arises at
  arbitrarily late steps (`Unceasing`). The same formation may arise again: what does
  not cease is arising, not any particular form. `Arises` asks nothing more of the
  formation: not that it is new, that it renews, or that it lives under any reading.
* A condition *rises* or *falls* across a step with its level, a net change. Every rise
  is *made by* some active formation renewing the condition when the unfolding has no
  source of renewal outside its formations (`RenewedBy`). A sun or a river is then one
  of the formations, not an outside. What `renews` means is the application's: left
  unconstrained it says nothing, and `Flow.Balances.renewedBy` supplies a substantive
  one.
* An event *depletes* a finite family of conditions when, at each of its steps at which
  no condition of the family rises, one of them falls (`Depletes`). This says only that
  some condition of the family changes at each step of the event, whatever its relation
  to the event (`depletes_iff`). In a balanced flow, an event at whose steps the family
  is dissipated on and some formation takes from it depletes it, and lowers a member even
  where another rises (`Flow.Balances.depletes` in `Becoming.Dissipation`).

Results:
* A finite family of conditions none of which rises from some step on is depleted by
  only finitely many events (`depletion_not_recurring`). This is the descent principle of
  `Becoming.Renewal` applied to the family's total level, which serves only as a
  measure of descent: the units of the conditions do not matter.
* Where arising depletes the family, unceasing generation needs renewal: some condition
  of the family rises at arbitrarily late steps (`Unceasing.rises`), and when every rise
  is made by a formation renewing it, renewing activity recurs
  (`Unceasing.activeRenewer_recurs`). Renewal is read here as a net rise, so renewal
  concurrent with drawing, which keeps the level constant, is invisible to it
  (`Expansion.undepleted`); the flow form of `Becoming.Flow` covers it.
* Substitution defers the end and does not escape it. A formation that at each of its
  active steps lowers some condition of a finite family, none of which rises any more,
  is not active at arbitrarily late steps, however it moves its dependence among them
  (`substitution_defers`, witness `Relay`).
* Dissipation ends generation: if a quantity never rises and every arising lowers it,
  generation is not unceasing (`dissipation_arising_not_recurring`). A family's total level is
  such a quantity only where every arising dissipates it, and adding levels across conditions
  presupposes that their units are commensurable. A material cycle dissipates nothing:
  a closed family whose total stays constant sustains unceasing generation (`Recycle`).
  For a quantity every arising dissipates, free energy for instance, the premise is
  physical; it is not a consequence of the theorem.
* Depletion need not involve the arising formation: a flicker that neither depends nor
  draws on anything arises again and again, each arising met by the unrelated fall of a
  tide (`Tide.unrelated_depletion`).
* Renewal does not imply generation. The tide, renewed by the moon, rises at arbitrarily
  late steps while nothing arises (`Tide.renewal_without_arising`); drawing exactly what
  is renewed keeps every dependence while nothing arises
  (`Renewable.renewal_without_arising`).
* Arising on a consumed condition ceases: formations arise while drawing an unrenewed
  condition down, consume it, and arising does not recur (`Growth.ceases`).
* Unceasing generation is consistent with these premises: a formation arises again and
  again on a condition that another formation renews (`Oscillation.unceasing`). Each arising
  comes when the condition has been restored, at a rise, so the oscillator depletes the
  family only vacuously (`Oscillation.arises_on_rise`). The working stepwise reading withholds
  every arising of the oscillator, which draws its condition below its own need until the
  next renewal,
  while the reading over cycles of two includes it (`Oscillation.readings`).

So, where arising depletes the family, unceasing generation is strictly stronger than
recurring renewal: it needs renewal to recur, and renewal can recur with nothing
arising. The premises are correspondence claims about an application: that every rise
is made by some formation within the unfolding, that arising depletes the family at
steps without renewal, and that the conditions concerned are finitely many. No ethical
predicate, ranking or axiom occurs. "More" generation, diversity and complexity are not
stated here.

`total` is stated in `Becoming.World`, and the witness run
`Renewable.renewal_without_arising` in `Becoming.Labelled`.
-/

namespace Becoming

variable {F C : Type}

namespace Web

variable (W : Web F C)

/-- A formation arises across the step from `t`: not active at `t`, active after it. -/
def Arises (t : Nat) (f : F) : Prop :=
  ¬ W.active t f ∧ W.active (t + 1) f

/-- Arising does not cease: some formation arises at arbitrarily late steps. -/
def Unceasing : Prop :=
  ∀ N, ∃ t f, N ≤ t ∧ W.Arises t f

/-- The condition rises across the step from `t`. -/
def Rises (t : Nat) (c : C) : Prop :=
  W.level t c < W.level (t + 1) c

/-- The condition falls across the step from `t`. -/
def Falls (t : Nat) (c : C) : Prop :=
  W.level (t + 1) c < W.level t c

/-- No condition of the family rises across the step from `t`. -/
def Still (cs : List C) (t : Nat) : Prop :=
  ∀ c, c ∈ cs → ¬ W.Rises t c

/-- The event depletes the family: at each of its steps at which no condition of the
family rises, one of them falls. -/
def Depletes (cs : List C) (event : Nat → Prop) : Prop :=
  ∀ t, event t → W.Still cs t → ∃ c, c ∈ cs ∧ W.Falls t c

/-- Every rise of a condition is made by some active formation renewing it. -/
def RenewedBy (renews : Nat → F → C → Prop) : Prop :=
  ∀ t c, W.Rises t c → ∃ f, W.active t f ∧ renews t f c

/-- An active formation renews a condition of the family. -/
def ActiveRenewer (renews : Nat → F → C → Prop) (cs : List C) (t : Nat) (f : F) : Prop :=
  W.active t f ∧ ∃ c, c ∈ cs ∧ renews t f c

/-- The total level of a finite family of conditions. -/
def stock (cs : List C) (t : Nat) : Nat :=
  total cs (W.level t)

/-- Across each step, some condition of a finite family rises, or none does. -/
theorem rises_or_still (t : Nat) : ∀ cs : List C, (∃ c, c ∈ cs ∧ W.Rises t c) ∨ W.Still cs t
  | [] => .inr fun _ mem => nomatch mem
  | c :: cs => match Nat.decLt (W.level t c) (W.level (t + 1) c) with
    | isTrue rises => .inl ⟨c, .head cs, rises⟩
    | isFalse flat => match rises_or_still t cs with
      | .inl ⟨d, mem, rises⟩ => .inl ⟨d, .tail c mem, rises⟩
      | .inr still => .inr fun d mem => match mem with
        | .head _ => flat
        | .tail _ mem => still d mem

/-- An event depletes the family exactly when some condition of the family rises or
falls at each of its steps. -/
theorem depletes_iff (cs : List C) (event : Nat → Prop) :
    W.Depletes cs event ↔ ∀ t, event t → ∃ c, c ∈ cs ∧ (W.Rises t c ∨ W.Falls t c) :=
  ⟨fun depletes t happens => match W.rises_or_still t cs with
    | .inl ⟨c, mem, rises⟩ => ⟨c, mem, .inl rises⟩
    | .inr still => match depletes t happens still with
      | ⟨c, mem, falls⟩ => ⟨c, mem, .inr falls⟩,
   fun changes t happens still => match changes t happens with
    | ⟨c, mem, .inl rises⟩ => absurd rises (still c mem)
    | ⟨c, mem, .inr falls⟩ => ⟨c, mem, falls⟩⟩

/-- When no condition of the family rises, the total does not rise. -/
theorem stock_le {t : Nat} : ∀ cs : List C, W.Still cs t → W.stock cs (t + 1) ≤ W.stock cs t
  | [], _ => Nat.le_refl 0
  | c :: cs, still =>
    Nat.add_le_add (Nat.ge_of_not_lt (still c (.head cs)))
      (stock_le cs fun d mem => still d (.tail c mem))

/-- When no condition of the family rises and one falls, the total falls. -/
theorem stock_lt {t : Nat} : ∀ cs : List C, W.Still cs t → (∃ c, c ∈ cs ∧ W.Falls t c) →
    W.stock cs (t + 1) < W.stock cs t
  | c :: cs, still, ⟨_, .head _, falls⟩ =>
    Nat.add_lt_add_of_lt_of_le falls (W.stock_le cs fun d mem => still d (.tail c mem))
  | c :: cs, still, ⟨d, .tail _ mem, falls⟩ =>
    Nat.add_lt_add_of_le_of_lt (Nat.ge_of_not_lt (still c (.head cs)))
      (stock_lt cs (fun e mem => still e (.tail c mem)) ⟨d, mem, falls⟩)

/-- A finite family of conditions none of which rises from step `T` on is depleted by
only finitely many events. -/
theorem depletion_not_recurring (cs : List C) (T : Nat) (event : Nat → Prop)
    (still : ∀ t, T ≤ t → W.Still cs t) (depletes : W.Depletes cs event) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ event t :=
  fun recurs => falls_not_recurring (W.stock cs) T (fun t after => W.stock_le cs (still t after))
    fun N => match recurs (N + T) with
      | ⟨t, later, happens⟩ =>
        have after : T ≤ t := Nat.le_trans (Nat.le_add_left T N) later
        ⟨t, Nat.le_trans (Nat.le_add_right N T) later,
          W.stock_lt cs (still t after) (depletes t happens (still t after))⟩

/-- Where arising depletes a finite family of conditions, unceasing generation needs
renewal: some condition of the family rises at arbitrarily late steps. -/
theorem Unceasing.rises {cs : List C} (depletes : W.Depletes cs fun t => ∃ f, W.Arises t f)
    (unceasing : W.Unceasing) (T : Nat) : ¬ ∀ t, T ≤ t → W.Still cs t :=
  fun still => W.depletion_not_recurring cs T _ still depletes
    fun N => match unceasing N with
      | ⟨t, f, later, arises⟩ => ⟨t, later, f, arises⟩

/-- When every rise is made by a formation renewing the condition, unceasing generation
that depletes a finite family makes renewing activity recur. -/
theorem Unceasing.activeRenewer_recurs {renews : Nat → F → C → Prop} {cs : List C}
    (made : W.RenewedBy renews) (depletes : W.Depletes cs fun t => ∃ f, W.Arises t f)
    (unceasing : W.Unceasing) (T : Nat) :
    ¬ ∀ t, T ≤ t → ∀ f, ¬ W.ActiveRenewer renews cs t f :=
  fun none => Unceasing.rises W depletes unceasing T fun t after c mem rises =>
    match made t c rises with
    | ⟨f, active, renewing⟩ => none t after f ⟨active, c, mem, renewing⟩

/-- Substitution defers the end and does not escape it: a formation lowering some
condition of a finite family at each of its active steps, while none of them rises, is
not active at arbitrarily late steps. -/
theorem substitution_defers (cs : List C) (f : F) (T : Nat)
    (still : ∀ t, T ≤ t → W.Still cs t) (draws_down : W.Depletes cs fun t => W.active t f) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ W.active t f :=
  W.depletion_not_recurring cs T _ still draws_down

/-- Dissipation ends generation: if a quantity never rises and every arising lowers it,
generation is not unceasing. -/
theorem dissipation_arising_not_recurring (q : Nat → Nat) (unrestored : ∀ t, q (t + 1) ≤ q t)
    (dissipates : ∀ t f, W.Arises t f → q (t + 1) < q t) : ¬ W.Unceasing :=
  fun unceasing => falls_not_recurring q 0 (fun t _ => unrestored t)
    fun N => match unceasing N with
      | ⟨t, f, later, arises⟩ => ⟨t, later, dissipates t f arises⟩

end Web

/-! ## Renewal does not imply generation -/

namespace Renewable

end Renewable

/-! ## Depletion need not involve the arising formation, and renewal recurs without
arising -/

namespace Tide

inductive Formation where
  | moon
  | flicker

/-- Out at even steps, in at odd steps. -/
def tide : Nat → Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => tide n

theorem tide_even : ∀ n, tide (2 * n) = 0
  | 0 => rfl
  | n + 1 => tide_even n

theorem tide_odd : ∀ n, tide (2 * n + 1) = 1
  | 0 => rfl
  | n + 1 => tide_odd n

/-- The moon is always active. The flicker is active where the tide is out. Nothing
depends or draws on the tide. -/
def web : Web Formation Unit where
  level t _ := tide t
  active t f := match f with
    | .moon => True
    | .flicker => tide t = 0
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The moon renews the tide. -/
def renews (_ : Nat) (f : Formation) (_ : Unit) : Prop :=
  match f with
  | .moon => True
  | .flicker => False

/-- Every premise of `Unceasing.activeRenewer_recurs` holds with the family of the tide,
and the flicker arises at every odd step, each arising depleting the tide, though the
flicker neither depends nor draws on it. -/
theorem unrelated_depletion :
    web.Dependent ∧ web.RenewedBy renews ∧
    web.Depletes [()] (fun t => ∃ f, web.Arises t f) ∧ web.Unceasing ∧
    (∀ t, ¬ web.requires t .flicker () ∧ ¬ web.draws t .flicker ()) ∧
    ∀ T, ¬ ∀ t, T ≤ t → ∀ f, ¬ web.ActiveRenewer renews [()] t f :=
  have depletes : web.Depletes [()] fun t => ∃ f, web.Arises t f :=
    fun _ ⟨f, inactive, active⟩ _ => match f, inactive, active with
    | .moon, inactive, _ => absurd trivial inactive
    | .flicker, inactive, active =>
      ⟨(), .head [], Nat.lt_of_le_of_lt (Nat.le_of_eq active) (Nat.pos_of_ne_zero inactive)⟩
  have made : web.RenewedBy renews := fun _ _ _ => ⟨.moon, trivial, trivial⟩
  have unceasing : web.Unceasing := fun N =>
    ⟨2 * N + 1, .flicker, Nat.le_succ_of_le (Nat.le_mul_of_pos_left N Nat.zero_lt_two),
      fun out => Nat.noConfusion ((tide_odd N).symm.trans out), tide_even (N + 1)⟩
  ⟨fun _ _ _ _ depends => depends.elim, made, depletes, unceasing, fun _ => ⟨id, id⟩,
   Web.Unceasing.activeRenewer_recurs web made depletes unceasing⟩

/-- The tide and the moon without the flicker. -/
def still : Web Formation Unit :=
  { web with active := fun _ f => f = .moon }

/-- The tide rises at arbitrarily late steps, every rise is made by the moon, and the
moon's renewing recurs, while nothing ever arises. -/
theorem renewal_without_arising :
    still.RenewedBy renews ∧ (∀ T, ∃ t, T ≤ t ∧ still.Rises t ()) ∧
    (∀ T, ∃ t f, T ≤ t ∧ still.ActiveRenewer renews [()] t f) ∧ ∀ t f, ¬ still.Arises t f :=
  ⟨fun _ _ _ => ⟨.moon, rfl, trivial⟩,
   fun T => ⟨2 * T, Nat.le_mul_of_pos_left T Nat.zero_lt_two,
     Nat.lt_of_le_of_lt (Nat.le_of_eq (tide_even T))
       (Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_of_eq (tide_odd T).symm))⟩,
   fun T => ⟨T, .moon, Nat.le_refl T, rfl, (), .head [], trivial⟩,
   fun _ _ ⟨inactive, active⟩ => inactive active⟩

end Tide

/-! ## Arising on a consumed condition ceases -/

namespace Growth

/-- Three units, no renewal; each step takes one until none is left. -/
def left : Nat → Nat := Witnesses.profile [3, 2, 1] 0

/-- Cell `n` is active after step `n` while the condition supports it: cells 0 and 1
arise, and the condition is gone before cell 2 can. -/
def web : Web Nat Unit where
  level t _ := left t
  active t n := n < t ∧ 1 ≤ left t
  requires _ _ _ := True
  need _ _ _ := 1
  draws t n _ := n < t ∧ 1 ≤ left t

theorem left_succ_le : ∀ t, left (t + 1) ≤ left t
  | 0 => Nat.le_succ 2
  | 1 => Nat.le_succ 1
  | 2 => Nat.le_succ 0
  | _ + 3 => Nat.le_refl 0

theorem left_late : ∀ t, 3 ≤ t → left t = 0
  | _ + 3, _ => rfl

/-- Cells arise while drawing the condition down; the condition is consumed and arising
does not recur. -/
theorem ceases :
    web.Dependent ∧ web.Arises 0 0 ∧ web.Arises 1 1 ∧ web.ConsumingIn 0 ∧
    (∀ t, ¬ web.Rises t ()) ∧ ¬ web.Unceasing :=
  have still : ∀ t, web.Still [()] t := fun t _ _ rises =>
    Nat.not_le_of_gt rises (left_succ_le t)
  have depletes : web.Depletes [()] fun t => ∃ n, web.Arises t n :=
    fun t ⟨_, _, active⟩ _ => ⟨(), .head [], match t, active with
      | 0, _ => Nat.lt_succ_self 2
      | 1, _ => Nat.lt_succ_self 1
      | 2, ⟨_, one⟩ => absurd one (Nat.not_succ_le_zero 0)
      | _ + 3, ⟨_, one⟩ => absurd one (Nat.not_succ_le_zero 0)⟩
  ⟨fun _ _ ⟨_, supported⟩ _ _ => supported,
   ⟨Nat.lt_irrefl 0 ∘ And.left, Nat.zero_lt_one, Nat.le_succ 1⟩,
   ⟨Nat.lt_irrefl 1 ∘ And.left, Nat.lt_succ_self 1, Nat.le_refl 1⟩,
   ⟨1, (), ⟨Nat.zero_lt_one, Nat.le_succ 1⟩, 0, 3, trivial,
     fun t later => (left_late t (Nat.le_of_lt later)).symm ▸ Nat.zero_lt_one⟩,
   fun t rises => still t () (.head []) rises,
   fun unceasing => Web.Unceasing.rises web depletes unceasing 0 fun t _ => still t⟩

end Growth

/-! ## Substitution among costly conditions ends -/

namespace Relay

inductive Source where
  | first
  | second

/-- One unit in each source: the first is drawn at step 0, the second at step 1. -/
def reserve : Nat → Source → Nat
  | 0, _ => 1
  | 1, .first => 0
  | 1, .second => 1
  | _ + 2, _ => 0

/-- The consumer depends on the first source at step 0 and on the second afterwards. -/
def dependsOn : Nat → Source → Prop
  | 0, .first => True
  | 0, .second => False
  | _ + 1, .first => False
  | _ + 1, .second => True

/-- The source the consumer depends on at each step. -/
def source : Nat → Source
  | 0 => .first
  | _ + 1 => .second

/-- The consumer is active while the source it depends on supports it, and draws on it. -/
def web : Web Unit Source where
  level := reserve
  active t _ := 1 ≤ reserve t (source t)
  requires t _ c := dependsOn t c
  need _ _ _ := 1
  draws t _ c := dependsOn t c ∧ 1 ≤ reserve t (source t)

theorem reserve_succ_le : ∀ t c, reserve (t + 1) c ≤ reserve t c
  | 0, .first => Nat.zero_le 1
  | 0, .second => Nat.le_refl 1
  | 1, _ => Nat.zero_le _
  | _ + 2, _ => Nat.le_refl 0

/-- The consumer transforms its dependence from the first source to the second, and
ends: with no renewal of either, substitution defers the end and does not escape it. -/
theorem defers :
    web.Dependent ∧ web.active 0 () ∧ web.active 1 () ∧
    web.Dissolves 0 () .first ∧ web.Forms 0 () .second ∧ web.ConsumingIn () ∧
    (∀ t, 2 ≤ t → ¬ web.active t ()) ∧ ¬ ∀ N, ∃ t, N ≤ t ∧ web.active t () :=
  have still : ∀ t, web.Still [.first, .second] t := fun t c _ rises =>
    Nat.not_le_of_gt rises (reserve_succ_le t c)
  have depletes : web.Depletes [.first, .second] fun t => web.active t () :=
    fun t active _ =>
    match t, active with
    | 0, _ => ⟨.first, .head _, Nat.zero_lt_one⟩
    | 1, _ => ⟨.second, .tail _ (.head _), Nat.zero_lt_one⟩
    | _ + 2, active => absurd active (Nat.not_succ_le_zero 0)
  ⟨fun t _ active c depends => match t, c, depends with
    | 0, .first, _ => active
    | _ + 1, .second, _ => active,
   Nat.le_refl 1, Nat.le_refl 1, ⟨trivial, id⟩, ⟨id, trivial⟩,
   ⟨0, .first, ⟨trivial, Nat.le_refl 1⟩, (), 0, trivial, fun t later => match t, later with
     | 1, _ => Nat.zero_lt_one
     | _ + 2, _ => Nat.zero_lt_one⟩,
   fun t late active => match t, late with
     | _ + 2, _ => Nat.not_succ_le_zero 0 active,
   web.substitution_defers [.first, .second] () 0 (fun t _ => still t) depletes⟩

end Relay

/-! ## A material cycle dissipates nothing -/

namespace Recycle

inductive Pool where
  | a
  | b

inductive Formation where
  | carrier
  | consumer

/-- One unit, at `a` at even steps and at `b` at odd steps. -/
def atA : Nat → Nat
  | 0 => 1
  | 1 => 0
  | n + 2 => atA n

def atB : Nat → Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => atB n

/-- The consumer depends on `a` at need one; it is active where `a` supports it, and then
draws on it, passing the unit to `b`. The carrier, always active, carries it back. -/
def web : Web Formation Pool where
  level t c := match c with
    | .a => atA t
    | .b => atB t
  active t f := match f with
    | .carrier => True
    | .consumer => 1 ≤ atA t
  requires _ f c := match f, c with
    | .carrier, _ => False
    | .consumer, .a => True
    | .consumer, .b => False
  need _ _ _ := 1
  draws t f c := match f, c with
    | .carrier, _ => False
    | .consumer, .a => 1 ≤ atA t
    | .consumer, .b => False

/-- The carrier renews `a`, and the consumer's drawing renews `b`. -/
def renews (_ : Nat) (f : Formation) (c : Pool) : Prop :=
  match f, c with
  | .carrier, .a => True
  | .carrier, .b => False
  | .consumer, .a => False
  | .consumer, .b => True

theorem total_one : ∀ t, web.stock [.a, .b] t = 1
  | 0 => rfl
  | 1 => rfl
  | t + 2 => total_one t

theorem atA_even : ∀ n, atA (2 * n) = 1
  | 0 => rfl
  | n + 1 => atA_even n

theorem atA_odd : ∀ n, atA (2 * n + 1) = 0
  | 0 => rfl
  | n + 1 => atA_odd n

/-- `b` rises only across a step from which the consumer is active. -/
theorem passed : ∀ t, atB t < atB (t + 1) → 1 ≤ atA t
  | 0, _ => Nat.le_refl 1
  | 1, rises => absurd rises (Nat.not_succ_le_zero 1)
  | t + 2, rises => passed t rises

/-- The family's total stays one, every premise of `Unceasing.activeRenewer_recurs`
holds, and the consumer arises at every odd step: no arising lowers the total, and a closed
cycle sustains unceasing generation. -/
theorem closed_unceasing :
    web.Dependent ∧ web.RenewedBy renews ∧
    web.Depletes [.a, .b] (fun t => ∃ f, web.Arises t f) ∧ web.Unceasing ∧
    (∀ t, web.stock [.a, .b] t = 1) ∧
    ∀ T, ¬ ∀ t, T ≤ t → ∀ f, ¬ web.ActiveRenewer renews [.a, .b] t f :=
  have depletes : web.Depletes [.a, .b] fun t => ∃ f, web.Arises t f :=
    fun _ ⟨f, inactive, active⟩ still => match f, inactive, active with
    | .carrier, inactive, _ => absurd trivial inactive
    | .consumer, inactive, active =>
      absurd (Nat.lt_of_lt_of_le (Nat.gt_of_not_le inactive) active) (still .a (.head _))
  have made : web.RenewedBy renews := fun t c rises => match c, rises with
    | .a, _ => ⟨.carrier, trivial, trivial⟩
    | .b, rises => ⟨.consumer, passed t rises, trivial⟩
  have unceasing : web.Unceasing := fun N =>
    ⟨2 * N + 1, .consumer, Nat.le_succ_of_le (Nat.le_mul_of_pos_left N Nat.zero_lt_two),
      fun one => Nat.not_succ_le_zero 0 (Nat.le_trans one (Nat.le_of_eq (atA_odd N))),
      Nat.le_of_eq (atA_even (N + 1)).symm⟩
  ⟨fun _ f active c depends => match f, c, active, depends with
    | .consumer, .a, active, _ => active,
   made, depletes, unceasing, total_one,
   Web.Unceasing.activeRenewer_recurs web made depletes unceasing⟩

end Recycle

/-! ## Unceasing generation on a renewed condition -/

namespace Oscillation

inductive Formation where
  | source
  | oscillator

/-- Two at even steps and one at odd steps: the oscillator takes two when it is active, and
the source gives one at every step. -/
def charge : Nat → Nat
  | 0 => 2
  | 1 => 1
  | n + 2 => charge n

theorem charge_even : ∀ n, charge (2 * n) = 2
  | 0 => rfl
  | n + 1 => charge_even n

theorem charge_odd : ∀ n, charge (2 * n + 1) = 1
  | 0 => rfl
  | n + 1 => charge_odd n

/-- The source is always active and depends on nothing here. The oscillator is active where the
condition reaches its need of two, depends on it, and draws on it when active. -/
def web : Web Formation Unit where
  level t _ := charge t
  active t f := match f with
    | .source => True
    | .oscillator => 2 ≤ charge t
  requires _ f _ := match f with
    | .source => False
    | .oscillator => True
  need _ _ _ := 2
  draws t f _ := match f with
    | .source => False
    | .oscillator => 2 ≤ charge t

/-- Within two steps the condition is back at two. -/
theorem back : ∀ t, 2 ≤ charge (t + 1) ∨ 2 ≤ charge (t + 2)
  | 0 => .inr (Nat.le_refl 2)
  | 1 => .inl (Nat.le_refl 2)
  | t + 2 => back t

/-- The source renews the condition. -/
def renews (_ : Nat) (f : Formation) (_ : Unit) : Prop :=
  match f with
  | .source => True
  | .oscillator => False

/-- The oscillator arises only when the source has restored its condition: at a rise. -/
theorem arises_on_rise : ∀ t f, web.Arises t f → web.Rises t ()
  | _, .source, ⟨inactive, _⟩ => absurd trivial inactive
  | _, .oscillator, ⟨inactive, active⟩ => Nat.lt_of_lt_of_le (Nat.gt_of_not_le inactive) active

/-- Every premise of `Unceasing.activeRenewer_recurs` holds, and the oscillator arises at every
odd step: generation does not cease, and the source's renewing recurs. -/
theorem unceasing :
    web.Dependent ∧ web.RenewedBy renews ∧
    web.Depletes [()] (fun t => ∃ f, web.Arises t f) ∧ web.Unceasing ∧
    ∀ T, ¬ ∀ t, T ≤ t → ∀ f, ¬ web.ActiveRenewer renews [()] t f :=
  have depletes : web.Depletes [()] fun t => ∃ f, web.Arises t f :=
    fun t ⟨f, arises⟩ still => absurd (arises_on_rise t f arises) (still () (.head []))
  have made : web.RenewedBy renews := fun _ _ _ => ⟨.source, trivial, trivial⟩
  have unceasing : web.Unceasing := fun N =>
    ⟨2 * N + 1, .oscillator, Nat.le_succ_of_le (Nat.le_mul_of_pos_left N Nat.zero_lt_two),
      fun two => Nat.not_succ_le_self 1
        (Nat.le_trans (show 2 ≤ charge (2 * N + 1) from two) (Nat.le_of_eq (charge_odd N))),
      show 2 ≤ charge (2 * (N + 1)) from (charge_even (N + 1)).symm ▸ Nat.le_refl 2⟩
  ⟨fun _ f active _ depends => match f, active, depends with
    | .oscillator, active, _ => active,
   made, depletes, unceasing, Web.Unceasing.activeRenewer_recurs web made depletes unceasing⟩

/-- The working stepwise reading withholds every arising of the oscillator: each draws its
condition below its own need, which the source restores by the next. The reading over cycles of two
includes the oscillator. -/
theorem readings :
    (∀ n, web.UnderminingAt (2 * n) .oscillator) ∧ web.RenewingInWithin 2 .oscillator :=
  ⟨fun n => have two : 2 ≤ charge (2 * n) := (charge_even n).symm ▸ Nat.le_refl 2
    have below : charge (2 * n + 1) < 2 :=
      Nat.lt_of_le_of_lt (Nat.le_of_eq (charge_odd n)) (Nat.lt_succ_self 1)
    ⟨(), two, .oscillator, trivial, Web.MetAbove.now trivial two below, below⟩,
   fun _ _ _ t g depends => match g, depends, back t with
    | .oscillator, _, .inl one => ⟨1, Nat.zero_lt_one, Nat.le_succ 1, one⟩
    | .oscillator, _, .inr two => ⟨2, Nat.zero_lt_two, Nat.le_refl 2, two⟩⟩

end Oscillation

/-! ## The grammar's reading: arising as a beginning under the class of activity

`Becoming.Grammar` states continuation relative to a class (`«续» R E`: linked by 缘, `R`, and alike
under the class `E`) for every carrier and relation. This section reads arising in it.

* **Along the steps of one determination.** The carrier is the step index; 缘 is the step, `s` a
  condition of `s + 1` (`Steps.next`); the class of a determination `p` is the two-valued class
  "alike in `p`" (`Steps.alike p`, 二值之类). Along the steps 缘 is one-to-one, so a line ends at a
  step exactly where a line begins at the next (`Steps.wang_iff_sheng_next`).
* **On a web.** An occurrence is a pair (step, formation); 缘 is the step along the same formation
  (`Steps.along`), and the class is "alike in activity" (`Web.activityClass`). The reading takes no
  dependence or drawing as 缘: what conditions an occurrence here is only the same formation's
  previous step, so it reads activity and omits the conditions it rests on. Positions on the web are
  positions of each formation's determination (`Web.sheng_iff_steps`, `Web.wang_iff_steps`).
* **Arising is an active beginning with a condition.** A formation arises across the step from
  `t` exactly where the occurrence `(t + 1, f)` is active and begins under the activity class
  (`Web.arises_iff_sheng`, 生); an active occurrence at step `0` begins too, with no condition, and
  is no arising. So arising does not cease exactly where active beginnings occur at arbitrarily late
  steps (`Web.unceasing_iff_late_beginnings`).
* **Arising whose line goes on is renewal.** An active beginning renews its condition in the
  grammar's sense (`«复生»`: a condition of a beginning whose line goes on) exactly where the arising
  formation is still active a step later (`Web.renews_iff`). `Arises` asks nothing of the step
  after; the grammar's renewal does.

Rises, falls, depletion and renewing activity read amounts and are not connected here: the grammar
has no amounts.
-/

namespace Steps

/-- 缘 along the steps of one determination: step `s` is a condition of step `t` when `t` is the
step after `s`. -/
def next : «际» Nat := fun s t => t = s + 1

/-- The two-valued class of a determination along the steps (二值之类): two steps are alike when
the determination holds at one exactly when it holds at the other. -/
def alike (p : Nat → Prop) : «际» Nat := fun s t => p s ↔ p t

theorem alike_class (p : Nat → Prop) : «类» (alike p) :=
  ⟨fun _ => Iff.rfl, Iff.symm, Iff.trans⟩

/-- A step has a successor in a line under `E` (有后) exactly when the next step is alike. -/
theorem hasSucc_iff {E : «际» Nat} {t : Nat} : «有后» next E t ↔ E t (t + 1) :=
  ⟨fun ⟨_, hy, he⟩ => by cases hy; exact he, fun he => ⟨t + 1, rfl, he⟩⟩

/-- A step after another has a predecessor in a line under `E` (有前) exactly when the step
before is alike. -/
theorem hasPred_iff {E : «际» Nat} {t : Nat} : «有前» next E (t + 1) ↔ E t (t + 1) :=
  ⟨fun ⟨_, hx, he⟩ => by cases Nat.succ.inj hx; exact he, fun he => ⟨t, rfl, he⟩⟩

/-- The first step begins (生) under every class: nothing conditions it. -/
theorem sheng_zero (E : «际» Nat) : «生» next E 0 :=
  fun ⟨_, hx, _⟩ => Nat.noConfusion hx

/-- Along the steps 缘 is one-to-one, so a line ends at a step (亡) exactly where a line begins at
the next (生). For a many-to-many 缘 an ending does not make its consequence a beginning; here the
consequence has no other condition. -/
theorem wang_iff_sheng_next {E : «际» Nat} {t : Nat} : «亡» next E t ↔ «生» next E (t + 1) :=
  ⟨fun h hp => h (hasSucc_iff.mpr (hasPred_iff.mp hp)),
   fun h hs => h (hasPred_iff.mpr (hasSucc_iff.mp hs))⟩

/-- 缘 along one relatum: the occurrence `(t, f)` is a condition of `(t + 1, f)`. -/
def along {F : Type} : «际» (Nat × F) := fun x y => y.1 = x.1 + 1 ∧ y.2 = x.2

/-- No occurrence conditions itself along a relatum. -/
theorem along_irrefl {F : Type} (z : Nat × F) : ¬ along z z :=
  fun h => Nat.succ_ne_self z.1 h.1.symm

theorem along_hasSucc_iff {F : Type} {E : «际» (Nat × F)} {t : Nat} {f : F} :
    «有后» along E (t, f) ↔ E (t, f) (t + 1, f) :=
  ⟨fun ⟨⟨_, _⟩, ⟨h₁, h₂⟩, he⟩ => by cases h₁; cases h₂; exact he,
   fun he => ⟨(t + 1, f), ⟨rfl, rfl⟩, he⟩⟩

theorem along_hasPred_iff {F : Type} {E : «际» (Nat × F)} {t : Nat} {f : F} :
    «有前» along E (t + 1, f) ↔ E (t, f) (t + 1, f) :=
  ⟨fun ⟨⟨_, _⟩, ⟨h₁, h₂⟩, he⟩ => by cases Nat.succ.inj h₁; cases h₂; exact he,
   fun he => ⟨(t, f), ⟨rfl, rfl⟩, he⟩⟩

/-- An occurrence at the first step begins under every class. -/
theorem along_sheng_zero {F : Type} (E : «际» (Nat × F)) (f : F) : «生» along E (0, f) :=
  fun ⟨⟨_, _⟩, ⟨h₁, _⟩, _⟩ => Nat.noConfusion h₁

end Steps

namespace Web

variable (W : Web F C)

/-- The class of activity on a web's occurrences: two occurrences are alike when one is active
exactly when the other is. -/
def activityClass : «际» (Nat × F) := fun x y => W.active x.1 x.2 ↔ W.active y.1 y.2

theorem activityClass_class : «类» W.activityClass :=
  ⟨fun _ => Iff.rfl, Iff.symm, Iff.trans⟩

variable {W}

/-- A beginning on the web is a beginning of the formation's determination of activity along the
steps. -/
theorem sheng_iff_steps {t : Nat} {f : F} :
    «生» Steps.along W.activityClass (t + 1, f) ↔
      «生» Steps.next (Steps.alike (W.active · f)) (t + 1) :=
  ⟨fun h hp => h (Steps.along_hasPred_iff.mpr (Steps.hasPred_iff.mp hp)),
   fun h hp => h (Steps.hasPred_iff.mpr (Steps.along_hasPred_iff.mp hp))⟩

/-- An ending on the web is an ending of the formation's determination of activity. -/
theorem wang_iff_steps {t : Nat} {f : F} :
    «亡» Steps.along W.activityClass (t, f) ↔ «亡» Steps.next (Steps.alike (W.active · f)) t :=
  ⟨fun h hs => h (Steps.along_hasSucc_iff.mpr (Steps.hasSucc_iff.mp hs)),
   fun h hs => h (Steps.hasSucc_iff.mpr (Steps.along_hasSucc_iff.mp hs))⟩

/-- **Arising is an active beginning (生).** A formation arises across the step from `t` exactly
where the occurrence after the step is active and begins under the class of activity. -/
theorem arises_iff_sheng {t : Nat} {f : F} :
    W.Arises t f ↔ W.active (t + 1) f ∧ «生» Steps.along W.activityClass (t + 1, f) :=
  ⟨fun ⟨inactive, active⟩ =>
    ⟨active, fun hp => inactive (Iff.mpr (Steps.along_hasPred_iff.mp hp) active)⟩,
   fun ⟨active, begins⟩ =>
    ⟨fun was => begins (Steps.along_hasPred_iff.mpr ⟨fun _ => active, fun _ => was⟩), active⟩⟩

/-- Arising does not cease exactly where active occurrences that begin under the class of
activity, after the first step, occur at arbitrarily late steps. -/
theorem unceasing_iff_late_beginnings :
    W.Unceasing ↔
      ∀ N, ∃ y : Nat × F, N < y.1 ∧ W.active y.1 y.2 ∧ «生» Steps.along W.activityClass y :=
  ⟨fun unceasing N => match unceasing N with
    | ⟨t, f, later, arises⟩ =>
      ⟨(t + 1, f), Nat.lt_succ_of_le later, arises_iff_sheng.mp arises⟩,
   fun late N => match late N with
    | ⟨(0, _), after, _⟩ => absurd after (Nat.not_lt_zero N)
    | ⟨(t + 1, f), after, active, begins⟩ =>
      ⟨t, f, Nat.le_of_lt_succ after, arises_iff_sheng.mpr ⟨active, begins⟩⟩⟩

/-- **Arising whose line goes on is renewal (复生).** The occurrence before an active step renews
under the class of activity (it is the condition of a beginning whose line goes on) exactly where
the formation arises across the step and is still active a step later. -/
theorem renews_iff {t : Nat} {f : F} :
    «复生» Steps.along W.activityClass (t, f) ∧ W.active (t + 1) f ↔
      W.Arises t f ∧ W.active (t + 1 + 1) f :=
  ⟨fun ⟨⟨⟨_, _⟩, ⟨h₁, h₂⟩, begins, goes⟩, active⟩ => by
    cases h₁; cases h₂
    exact ⟨arises_iff_sheng.mpr ⟨active, begins⟩,
      Iff.mp (Steps.along_hasSucc_iff.mp goes) active⟩,
   fun ⟨arises, still⟩ =>
    ⟨⟨(t + 1, f), ⟨rfl, rfl⟩, (arises_iff_sheng.mp arises).2,
      Steps.along_hasSucc_iff.mpr ⟨fun _ => still, fun _ => arises.2⟩⟩, arises.2⟩⟩

end Web

end Becoming
