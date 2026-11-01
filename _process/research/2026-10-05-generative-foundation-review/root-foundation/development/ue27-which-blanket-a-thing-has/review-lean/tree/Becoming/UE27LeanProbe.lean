import Becoming.BlanketCouplings
import Becoming.Mechanism

/-!
# Probe for the review of `Becoming.BlanketCouplings` (AI-written, independent reviewer, 1 November 2026)

Not for landing. Checks: (1) `ThresholdDrain.blanket_iff_through` follows from
`BlanketCouplings.blanket_iff_through` at an instance, through a course correspondence;
(2) the three "cases" of `PartDependsOnlyOn`; (3) a clock without the course's label gives a family
no blanket under the clocked reading's shape, and a reading of the future gives one with no clock;
(4) `injective_consistent`'s converse fails (the identity reading of `ReadsExternal`);
(5) the World instance of `selectsThrough` typechecks.
-/

namespace Becoming

namespace UE27LeanProbe

open Generative Blanket BlanketCouplings

/-! ## (1) ThresholdDrain's join as an instance -/

namespace TD

def value : Nat → (Unit → Nat) → Bool := fun _ l => Nat.blt 0 (l ())
def lev : Nat → Nat → Unit → Nat := fun _ x _ => x
def env : Bool → Unit → Nat → Nat → Nat := fun _ _ _ x => x - 1
def update : Bool → Bool → Unit → Bool := fun m o _ => m && o
def policy : Bool → Bool → Unit → Unit := fun _ _ a => a

theorem band_congr : ∀ {a a' b b' : Bool}, a = a' → b = b' → (a && b) = (a' && b')
  | _, _, _, _, rfl, rfl => rfl

theorem admits_iff (x : Unit → Nat) (t : Nat) :
    ThresholdDrain.web.Admits x t () ↔ Nat.blt 0 (x ()) = true :=
  ⟨fun admits => Nat.ble_eq_true_of_le (admits () trivial),
   fun reads c _ => match c with | () => Nat.le_of_ble_eq_true reads⟩

theorem values : ThresholdDrain.web.ValuesThrough (fun _ _ => False) () value :=
  fun t x y =>
    ⟨fun same =>
      ⟨(admits_iff x t).trans
        ((⟨fun h => same.symm.trans h, fun h => same.trans h⟩ :
            Nat.blt 0 (x ()) = true ↔ Nat.blt 0 (y ()) = true).trans (admits_iff y t).symm),
       fun _ never => never.elim⟩,
     fun ⟨admitted, _⟩ =>
      ThresholdDrain.bool_eq_of_iff (((admits_iff x t).symm.trans admitted).trans (admits_iff y t))⟩

/-- The coupling law's course from supply `e` matches `ThresholdDrain.law`'s, with a step beside the
supply in the external part. -/
theorem corr (e : Nat) : ∀ n,
    ((couplingLaw update policy value lev env).course (startAt true true () e) n).internal =
        (ThresholdDrain.law.course ⟨true, true, (), e⟩ n).internal ∧
      ((couplingLaw update policy value lev env).course (startAt true true () e) n).sensory =
        (ThresholdDrain.law.course ⟨true, true, (), e⟩ n).sensory ∧
      ((couplingLaw update policy value lev env).course (startAt true true () e) n).active =
        (ThresholdDrain.law.course ⟨true, true, (), e⟩ n).active ∧
      ((couplingLaw update policy value lev env).course (startAt true true () e) n).external =
        (n, (ThresholdDrain.law.course ⟨true, true, (), e⟩ n).external)
  | 0 => ⟨rfl, rfl, rfl, rfl⟩
  | n + 1 =>
    match corr e n with
    | ⟨i, s, a, x⟩ =>
      ⟨band_congr i s,
       congrArg (fun p : Nat × Nat => Nat.blt 0 p.2) x,
       a,
       congrArg (fun p : Nat × Nat => (p.1 + 1, p.2 - 1)) x⟩

theorem own_eq (e s : Nat) :
    ownLevels update policy value lev env true true () e s = fun _ => e - s :=
  congrArg (fun v : Nat => fun (_ : Unit) => v)
    ((congrArg Prod.snd (corr e s).2.2.2).trans (ThresholdDrain.external_course _ s))

/-- **`ThresholdDrain.blanket_iff_through` recovered from the general join.** -/
theorem threshold_case (e e' n : Nat) :
    ThresholdDrain.law.BlanketAlike ⟨true, true, (), e⟩ ⟨true, true, (), e'⟩ (n + 2) ↔
      ThresholdDrain.web.AlikeThroughUpTo (fun _ _ => False) () (fun t _ => e - t)
        (fun t _ => e' - t) n :=
  have blanket :
      ThresholdDrain.law.BlanketAlike ⟨true, true, (), e⟩ ⟨true, true, (), e'⟩ (n + 2) ↔
        (couplingLaw update policy value lev env).BlanketAlike (startAt true true () e)
          (startAt true true () e') (n + 2) :=
    ⟨fun h j lt => ⟨(corr e j).2.1.trans ((h j lt).1.trans (corr e' j).2.1.symm),
                    (corr e j).2.2.1.trans ((h j lt).2.trans (corr e' j).2.2.1.symm)⟩,
     fun h j lt => ⟨(corr e j).2.1.symm.trans ((h j lt).1.trans (corr e' j).2.1),
                    (corr e j).2.2.1.symm.trans ((h j lt).2.trans (corr e' j).2.2.1)⟩⟩
  have through :
      ThresholdDrain.web.AlikeThroughUpTo (fun _ _ => False) ()
          (ownLevels update policy value lev env true true () e)
          (ownLevels update policy value lev env true true () e') n ↔
        ThresholdDrain.web.AlikeThroughUpTo (fun _ _ => False) () (fun t _ => e - t)
          (fun t _ => e' - t) n :=
    ⟨fun h s le => (Web.alikeThrough_iff values).mpr
        ((congrArg (value s) (own_eq e s)).symm.trans
          (((Web.alikeThrough_iff values).mp (h s le)).trans (congrArg (value s) (own_eq e' s)))),
     fun h s le => (Web.alikeThrough_iff values).mpr
        ((congrArg (value s) (own_eq e s)).trans
          (((Web.alikeThrough_iff values).mp (h s le)).trans
            (congrArg (value s) (own_eq e' s)).symm))⟩
  blanket.trans
    ((blanket_iff_through update policy value lev env values true true () e e' n).trans through)

end TD

/-! ## (2) The three cases of `PartDependsOnlyOn` -/

section Cases

variable {S M K : Type} (P : Process S M) (π : S → K)

theorem case_dependsOnlyOn : PartDependsOnlyOn P π id ↔ DependsOnlyOn P π := Iff.rfl

theorem case_goAlike : PartDependsOnlyOn P π π ↔ GoAlike P π := Iff.rfl

theorem case_determined : PartDependsOnlyOn P id id ↔ Determined P :=
  ⟨fun only s a t t' step step' => only s s a t t' rfl step step',
   fun det s s' a u u' (same : s = s') step step' =>
    match s', same, step' with
    | _, rfl, step' => det s a u u' step step'⟩

end Cases

/-! ## (3) What the clocked reading needs -/

/-- Two courses alike at steps 0 and 1 that part at step 2. -/
def late (r : Bool) : Nat → Bool
  | 0 => false
  | 1 => false
  | _ + 2 => r

/-- **A clock without the course's label is not enough**: the clocked reading's shape with the
step alone in the external part gives this family no law determined part by part. -/
theorem clock_only_fails :
    ¬ BlanketConsistentFamily (fun (h : Nat → Parts Bool Bool Unit Nat) (_ : Nat → Unit) =>
      ∃ r, ∀ n, h n = ⟨late r n, late r (n + 1), (), n⟩) :=
  fun cons => Bool.noConfusion (show false = true from
    congrArg Prod.fst
      (cons.2 (fun n => ⟨late false n, late false (n + 1), (), n⟩) (fun _ => ())
        (fun n => ⟨late true n, late true (n + 1), (), n⟩) (fun _ => ()) 0 0
        ⟨false, fun _ => rfl⟩ ⟨true, fun _ => rfl⟩ rfl rfl))

/-- The suffix of a sequence after its first entry. -/
def shift {α : Type} (f : Nat → α) : Nat → α := fun k => f (k + 1)

/-- The suffix after the first `n` entries. -/
def drop {α : Type} : Nat → (Nat → α) → Nat → α
  | 0, f => f
  | n + 1, f => shift (drop n f)

theorem drop_apply {α : Type} (f : Nat → α) : ∀ n k, drop n f k = f (k + n)
  | 0, _ => rfl
  | n + 1, k => (drop_apply f n (k + 1)).trans (congrArg f (Nat.succ_add k n))

theorem drop_at {α : Type} (f : Nat → α) (n : Nat) : drop n f 0 = f n :=
  (drop_apply f n 0).trans (congrArg f (Nat.zero_add n))

/-- **A reading of the future, with no clock and no label**: the sensory part holds the course's
future, the external part nothing. -/
def ofFuture {α : Type} : Blanketed α (Nat → α) Unit Unit where
  nextInternal _ s _ := s 0
  nextSensory s _ _ := shift s
  nextActive _ _ _ := ()
  nextExternal _ _ _ := ()

theorem ofFuture_course {α : Type} (x : Nat → α) :
    ∀ n, ((ofFuture (α := α)).course ⟨x 0, drop 1 x, (), ()⟩ n).internal = x n ∧
      ((ofFuture (α := α)).course ⟨x 0, drop 1 x, (), ()⟩ n).sensory = drop (n + 1) x
  | 0 => ⟨rfl, rfl⟩
  | n + 1 =>
    match ofFuture_course x n with
    | ⟨_, s⟩ =>
      ⟨(congrArg (fun f : Nat → α => f 0) s).trans (drop_at x (n + 1)),
       congrArg shift s⟩

/-! ## (4) `injective_consistent`'s converse fails -/

/-- Under the identity reading (injective) the run of `ReadsExternal` is consistent and not
consistent part by part. -/
theorem injective_converse_fails :
    ConsistentFamily
        (fun (h : Nat → Parts Bool Unit Unit ReadsExternal.Three) (_ : Nat → Unit) =>
          h = ReadsExternal.run) ∧
      ¬ BlanketConsistentFamily
        (fun (h : Nat → Parts Bool Unit Unit ReadsExternal.Three) (_ : Nat → Unit) =>
          h = ReadsExternal.run) :=
  ⟨inner_iff.mp ReadsExternal.inner_consistent, ReadsExternal.not_consistent⟩

/-! ## (5) The World instance -/

theorem world_selects {M A : Type} (w : World) (g : w.Relatum) (obs : w.Relatum → w.Relatum → Prop)
    (admits : Nat → (w.Relatum → Nat) → Bool)
    (decides : ∀ t x, admits t x = true ↔ w.web.Admits x t g) {cs : List w.Relatum}
    (listed : ∀ c, obs g c ↔ c ∈ cs)
    (update : M → Bool × List Nat → A → M) (policy : M → Bool × List Nat → A → A)
    (m : M) (o : Bool × List Nat) (a : A) (n : Nat) (select : (Nat → M) → Prop)
    (reads : ∀ f f' : Nat → M, (∀ k, k ≤ n + 1 → f k = f' k) → (select f ↔ select f')) :
    w.web.SelectsThrough obs g n (fun l => select fun k =>
      ((openLaw update policy (fun t x => (admits t x, cs.map x))).course (startAt m o a l) k).internal) :=
  selectsThrough update policy _ (Web.listed_values decides listed) m o a n select reads

/-! ## (6) The internal course is fixed one step further than stated -/

section Tight

variable {F C O M A X : Type} {W : Web F C} {obs : F → C → Prop} {g : F}
  (update : M → O → A → M) (policy : M → O → A → A) (value : Nat → (C → Nat) → O)
  (lev : Nat → X → C → Nat) (env : O → A → Nat → X → X)

/-- **`internal_through_couplings` up to `n + 2`**: levels alike through the couplings up to `n` fix
the internal course up to `n + 2`, one step beyond the module's `n + 1`. -/
theorem internal_tight (values : W.ValuesThrough obs g value) (m : M) (o : O) (a : A)
    (x x' : X) (n : Nat)
    (through : W.AlikeThroughUpTo obs g (ownLevels update policy value lev env m o a x)
      (ownLevels update policy value lev env m o a x') n) :
    ∀ k, k ≤ n + 2 →
      ((couplingLaw update policy value lev env).course (startAt m o a x) k).internal =
        ((couplingLaw update policy value lev env).course (startAt m o a x') k).internal :=
  fun k le =>
    (couplingLaw update policy value lev env).internal_through_blanket (x := startAt m o a x)
      (y := startAt m o a x') rfl k
      fun j lt => (blanket_iff_through update policy value lev env values m o a x x' n).mpr through j
        (Nat.lt_of_lt_of_le lt le)

/-- **`selectsThrough` for readings up to `n + 2`.** -/
theorem selects_tight (values : W.ValuesThrough obs g value) (m : M) (o : O) (a : A) (n : Nat)
    (select : (Nat → M) → Prop)
    (reads : ∀ f f' : Nat → M, (∀ k, k ≤ n + 2 → f k = f' k) → (select f ↔ select f')) :
    W.SelectsThrough obs g n
      (fun l => select fun k => ((openLaw update policy value).course (startAt m o a l) k).internal) :=
  fun l l' through =>
    reads _ _
      (internal_tight update policy value levelsAt unmoved values
        m o a l l' n fun s le =>
          (Web.alikeThrough_iff values).mpr
            ((congrArg (value s) (open_levels update policy value m o a l s)).trans
              (((Web.alikeThrough_iff values).mp (through s le)).trans
                (congrArg (value s) (open_levels update policy value m o a l' s)).symm)))

end Tight

end UE27LeanProbe

end Becoming
