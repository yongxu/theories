/-! OC4 scratch checks. Definitions copied verbatim from Becoming/Grammar.lean, GrammarMap.lean and
GrammarPath.lean (main at cba4a923e; GrammarPath unchanged since ff8e83159); only Init is imported. -/

namespace Scratch

universe u

abbrev «际» (α : Type u) : Type u := α → α → Prop

inductive «及» {α : Type u} (R : «际» α) : «际» α
  | one {x y : α} : R x y → «及» R x y
  | more {x y z : α} : R x y → «及» R y z → «及» R x z

structure «类» {α : Type u} (E : «际» α) : Prop where
  refl : ∀ x, E x x
  symm : ∀ {x y}, E x y → E y x
  trans : ∀ {x y z}, E x y → E y z → E x z

section
variable {α : Type u}

def «合» (R S : «际» α) : «际» α := fun x y => R x y ∧ S x y
def «一» : «际» α := fun _ _ => True
def «续» (R E : «际» α) : «际» α := «合» R E
def «相续» (R E : «际» α) : «际» α := «及» («续» R E)
def «有后» (R E : «际» α) (x : α) : Prop := ∃ y, «续» R E x y
def «亡» (R E : «际» α) (x : α) : Prop := ¬ «有后» R E x
def «无环» (R : «际» α) : Prop := ∀ x, ¬ «及» R x x
def «所及» (R L : «际» α) (x y : α) : Prop := x = y ∨ «相续» R L x y
def «延» (R L : «际» α) (x : α) : Prop := ∃ S : α → Prop, S x ∧ ∀ z, S z → ∃ w, S w ∧ «续» R L z w

theorem «线内同类» {R E : «际» α} (hE : «类» E) {x y : α}
    (line : «相续» R E x y) : E x y := by
  induction line with
  | one c => exact c.2
  | more c _ ih => exact hE.trans c.2 ih

def «所缘同于» (R E : «际» α) (m : α) : Prop := ∀ v, R m v → E m v

def «至终有常» (R E : «际» α) : Prop :=
  ∀ u u', E u u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w

def «本类至终有常» (R E : «际» α) (m : α) : Prop :=
  ∀ u u', E m u → E m u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w

def «二分» (P : α → Bool) : «际» α := fun x y => P x = P y

/-! ### B. The division enters only through what is alike to the member's OWN leaving effects, where
the member conditions something. 07 §4.6 ("Which class P2 reads") says "Where one does not hold them, the
division enters P2 only through what is alike to an effect one leaves out", citing `«外分唯系出类之同»`,
whose hypothesis ranges over the effects of every occurrence alike to `m`. This is the stronger form the
sentence states; it needs `goes` (Doubts.lean T1 is the counterexample without it). -/
theorem ownOutside {R E F : «际» α} (hE : «类» E) (hF : «类» F) {m : α}
    (same : ∀ x, E m x ↔ F m x) (goes : ∃ w, R m w)
    (own : ∀ w x, R m w → E m w ∨ (E w x ↔ F w x)) :
    «本类至终有常» R E m ↔ «本类至终有常» R F m :=
  ⟨fun a u u' mu mu' v s =>
     match a u u' ((same u).mpr mu) ((same u').mpr mu') v s with
     | .inr st => .inr st
     | .inl ⟨v', s', ev⟩ =>
       match a u m ((same u).mpr mu) (hE.refl m) v s with
       | .inr st => match goes with | ⟨w, hw⟩ => absurd hw (st w)
       | .inl ⟨w, hw, evw⟩ =>
         match own w v hw with
         | .inl mw =>
           have mv : E m v := hE.trans mw (hE.symm evw)
           have mv' : E m v' := hE.trans mv ev
           .inl ⟨v', s', hF.trans (hF.symm ((same v).mp mv)) ((same v').mp mv')⟩
         | .inr agv =>
           match own w v' hw with
           | .inl mw =>
             have mv : E m v := hE.trans mw (hE.symm evw)
             have mv' : E m v' := hE.trans mv ev
             .inl ⟨v', s', hF.trans (hF.symm ((same v).mp mv)) ((same v').mp mv')⟩
           | .inr agv' =>
             have fwv : F w v := agv.mp (hE.symm evw)
             have fwv' : F w v' := agv'.mp (hE.trans (hE.symm evw) ev)
             .inl ⟨v', s', hF.trans (hF.symm fwv) fwv'⟩,
   fun a u u' mu mu' v s =>
     match a u u' ((same u).mp mu) ((same u').mp mu') v s with
     | .inr st => .inr st
     | .inl ⟨v', s', fv⟩ =>
       match a u m ((same u).mp mu) (hF.refl m) v s with
       | .inr st => match goes with | ⟨w, hw⟩ => absurd hw (st w)
       | .inl ⟨w, hw, fvw⟩ =>
         match own w v hw with
         | .inl mw =>
           have fmv : F m v := hF.trans ((same w).mp mw) (hF.symm fvw)
           have fmv' : F m v' := hF.trans fmv fv
           .inl ⟨v', s', hE.trans (hE.symm ((same v).mpr fmv)) ((same v').mpr fmv')⟩
         | .inr agv =>
           match own w v' hw with
           | .inl mw =>
             have fmv : F m v := hF.trans ((same w).mp mw) (hF.symm fvw)
             have fmv' : F m v' := hF.trans fmv fv
             .inl ⟨v', s', hE.trans (hE.symm ((same v).mpr fmv)) ((same v').mpr fmv')⟩
           | .inr agv' =>
             have ewv : E w v := agv.mpr (hF.symm fvw)
             have ewv' : E w v' := agv'.mpr (hF.trans (hF.symm fvw) fv)
             .inl ⟨v', s', hE.trans (hE.symm ewv) ewv'⟩⟩

/-! ### C. P3 follows from P4: a condition one affects (conditions) is on one's line, in one step. -/
theorem p3_of_p4 {R E : «际» α} {m c : α} (held : «所缘同于» R E m) (affects : R m c) :
    «所及» R E m c :=
  .inr (.one ⟨affects, held c affects⟩)

/-! ### A2. With P4 and acting, one's line takes a step: the zero-step case of A is excluded. -/
theorem acting_held_continues {R E : «际» α} {m : α} (held : «所缘同于» R E m) (goes : ∃ w, R m w) :
    «有后» R E m :=
  match goes with | ⟨w, hw⟩ => ⟨w, hw, held w hw⟩

/-! ### D. The path's conclusion is exactly "everything downstream of one's acts is alike to oneself",
with no regularity: P2 and P4 give it (`«本类常则闭当且仅当后皆同类»`), but it is not equivalent to them. -/
theorem reach_iff_downstream_alike {R E : «际» α} (hE : «类» E) {m : α} :
    (∀ t, «及» R m t → «所及» R E m t) ↔ (∀ t, «及» R m t → E m t) :=
  ⟨fun reach t d => match reach t d with
     | .inl e => e ▸ hE.refl m
     | .inr l => «线内同类» hE l,
   fun all t d =>
     have key : ∀ c t, «及» R c t → E m c → (∀ s, «及» R c s → E m s) → «相续» R E c t := by
       intro c t d
       induction d with
       | one r =>
         intro mc down
         exact .one ⟨r, hE.trans (hE.symm mc) (down _ (.one r))⟩
       | @more a b _ r _ ih =>
         intro ma down
         have mb : E m b := down b (.one r)
         exact .more ⟨r, hE.trans (hE.symm ma) mb⟩ (ih mb (fun s ds => down s (.more r ds)))
     .inr (key m t d (hE.refl m) all)⟩

/-! ### D2. P4 is necessary for the reach: if everything downstream of one's acts lies on one's line,
one holds one's effects. -/
theorem p4_of_reach {R E : «际» α} (hE : «类» E) {m : α}
    (reach : ∀ t, «及» R m t → «所及» R E m t) : «所缘同于» R E m :=
  fun v r => (reach_iff_downstream_alike hE).mp reach v (.one r)

/-! ### A3. The class of a single moment (equality) meets the condition at every member of every net
(as REVIEW-OC1's T5.discrete_at), while a member that conditions anything else ends under it at once. -/
theorem moment_at {R : «际» α} (m : α) : «本类至终有常» R (fun x y => x = y) m :=
  fun u u' mu mu' v r => .inl ⟨v, (Eq.trans (Eq.symm mu) mu') ▸ r, rfl⟩

end

/-! ### A. P2's gloss "one's line ends only where the net itself ends" needs a line of at least one step.
FinerOutside's net, copied: under the split the class meets the condition at `m` (`split_constant_at`), yet
`m` ends under it while it still conditions `b`, and `m` lies on its own line (`«所及»` is reflexive). -/
namespace ZeroStep
inductive Occ | m | c | b | d
def step : «际» Occ
  | .m, .m => False
  | .m, .c => False
  | .m, .b => True
  | .m, .d => False
  | .c, .m => False
  | .c, .c => False
  | .c, .b => False
  | .c, .d => True
  | .b, .m => False
  | .b, .c => False
  | .b, .b => False
  | .b, .d => False
  | .d, .m => False
  | .d, .c => False
  | .d, .b => False
  | .d, .d => False
def inClass : Occ → Bool
  | .m => true
  | .c => true
  | .b => false
  | .d => false
theorem split_constant_at : «本类至终有常» step («二分» inClass) .m := by
  intro u u' mu mu' v r
  cases u <;> cases u' <;> cases v <;>
    first
    | exact False.elim r
    | exact Bool.noConfusion mu
    | exact Bool.noConfusion mu'
    | exact .inl ⟨.b, trivial, rfl⟩
    | exact .inl ⟨.d, trivial, rfl⟩
    | exact .inr (fun w h => by cases w <;> exact False.elim h)
theorem ends_while_net_goes :
    «本类至终有常» step («二分» inClass) .m ∧ «所及» step («二分» inClass) .m .m ∧
      «亡» step («二分» inClass) .m ∧ step .m .b :=
  ⟨split_constant_at, .inl rfl,
   fun ⟨y, r, e⟩ => match y, r, e with
     | .b, _, e => Bool.noConfusion e,
   trivial⟩
end ZeroStep

/-! ### E. P2 is not needed for the reach: it fails at one's class while one holds one's effects and
everything downstream of one's acts lies on one's line. `m → v → w`, `c → x`; the class `{m, v, w, c}`
against `{x}`. So "where it fails at one's own class, holding one's effects gives nothing beyond the first
step" holds only as "need give nothing" (`Inconstant`), and P-20's "If either fails, that scope rests on
the step" is too strong for P2. -/
namespace NoP2
set_option linter.constructorNameAsVariable false
inductive Occ | m | v | w | c | x
def step : «际» Occ
  | .m, .m => False
  | .m, .v => True
  | .m, .w => False
  | .m, .c => False
  | .m, .x => False
  | .v, .m => False
  | .v, .v => False
  | .v, .w => True
  | .v, .c => False
  | .v, .x => False
  | .w, .m => False
  | .w, .v => False
  | .w, .w => False
  | .w, .c => False
  | .w, .x => False
  | .c, .m => False
  | .c, .v => False
  | .c, .w => False
  | .c, .c => False
  | .c, .x => True
  | .x, .m => False
  | .x, .v => False
  | .x, .w => False
  | .x, .c => False
  | .x, .x => False
def inClass : Occ → Bool
  | .m => true
  | .v => true
  | .w => true
  | .c => true
  | .x => false
def E : «际» Occ := «二分» inClass
theorem E_class : «类» E := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩
theorem not_at : ¬ «本类至终有常» step E .m := fun a =>
  match a .m .c rfl rfl .v trivial with
  | .inl ⟨v', r, e⟩ => match v', r, e with
    | .x, _, e => Bool.noConfusion e
  | .inr st => st .x trivial
theorem held : «所缘同于» step E .m := fun v r => match v, r with
  | .v, _ => rfl
def inner : Occ → Bool
  | .m => true
  | .v => true
  | .w => true
  | .c => false
  | .x => false
theorem inner_step : ∀ {a b : Occ}, step a b → inner a = true → inner b = true
  | .m, .v, _, _ => rfl
  | .v, .w, _, _ => rfl
  | .m, .m, h, _ => False.elim h
  | .m, .w, h, _ => False.elim h
  | .m, .c, h, _ => False.elim h
  | .m, .x, h, _ => False.elim h
  | .v, .m, h, _ => False.elim h
  | .v, .v, h, _ => False.elim h
  | .v, .c, h, _ => False.elim h
  | .v, .x, h, _ => False.elim h
  | .w, .m, h, _ => False.elim h
  | .w, .v, h, _ => False.elim h
  | .w, .w, h, _ => False.elim h
  | .w, .c, h, _ => False.elim h
  | .w, .x, h, _ => False.elim h
  | .c, _, _, e => Bool.noConfusion e
  | .x, _, _, e => Bool.noConfusion e
theorem inner_reach {a t : Occ} (d : «及» step a t) (ia : inner a = true) : inner t = true := by
  induction d with
  | one r => exact inner_step r ia
  | more r _ ih => exact ih (inner_step r ia)
theorem inner_alike : ∀ t : Occ, inner t = true → E .m t
  | .m, _ => rfl
  | .v, _ => rfl
  | .w, _ => rfl
  | .c, e => Bool.noConfusion e
  | .x, e => Bool.noConfusion e
theorem downstream_alike : ∀ t, «及» step .m t → E .m t := fun t d =>
  inner_alike t (inner_reach d rfl)
theorem reach_without_P2 :
    ¬ «本类至终有常» step E .m ∧ «所缘同于» step E .m ∧ ∀ t, «及» step .m t → «所及» step E .m t :=
  ⟨not_at, held, (reach_iff_downstream_alike E_class).mpr downstream_alike⟩
end NoP2

/-! ### F. The what-leaves record's third law read as a law: `CleanStep` (copied) is finite and without
cycles, its class holds a member and part of what follows it, and it is not constant up to the net's end. -/
namespace CleanStepCopy
inductive Occ | m | i | j | u
def step : «际» Occ
  | .m, .m => False
  | .m, .i => True
  | .m, .j => False
  | .m, .u => True
  | .i, .m => False
  | .i, .i => False
  | .i, .j => True
  | .i, .u => False
  | .j, .m => False
  | .j, .i => False
  | .j, .j => False
  | .j, .u => False
  | .u, .m => False
  | .u, .i => False
  | .u, .j => False
  | .u, .u => False
def intended : Occ → Bool
  | .m => true
  | .i => true
  | .j => true
  | .u => false
def own : «际» Occ := fun x y => intended x = intended y
def rank : Occ → Nat
  | .m => 0
  | .i => 1
  | .u => 1
  | .j => 2
theorem rank_lt : ∀ {x y : Occ}, step x y → rank x < rank y
  | .m, .i, _ => by decide
  | .m, .u, _ => by decide
  | .i, .j, _ => by decide
  | .m, .m, h => False.elim h
  | .m, .j, h => False.elim h
  | .i, .m, h => False.elim h
  | .i, .i, h => False.elim h
  | .i, .u, h => False.elim h
  | .j, .m, h => False.elim h
  | .j, .i, h => False.elim h
  | .j, .j, h => False.elim h
  | .j, .u, h => False.elim h
  | .u, .m, h => False.elim h
  | .u, .i, h => False.elim h
  | .u, .j, h => False.elim h
  | .u, .u, h => False.elim h
theorem reach_lt {x y : Occ} (d : «及» step x y) : rank x < rank y := by
  induction d with
  | one r => exact rank_lt r
  | more r _ ih => exact Nat.lt_trans (rank_lt r) ih
theorem acyclic : «无环» step := fun x d => Nat.lt_irrefl _ (reach_lt d)
theorem not_constant_to_end : ¬ «至终有常» step own := fun constant =>
  match constant .m .i rfl .u trivial with
  | .inl ⟨v', r, e⟩ => match v', r, e with
    | .j, _, e => Bool.noConfusion e
  | .inr st => st .j trivial
theorem holds_member_and_part : own .m .i ∧ own .m .j ∧ ¬ own .m .u :=
  ⟨rfl, rfl, fun e => Bool.noConfusion e⟩
end CleanStepCopy

/-! ### G. The what-leaves record's third "does not show": with two blocks the necessary condition (what
leaves follows every alike occurrence that conditions anything, for every member) does not suffice either.
`m → i`, `m → y`, `c → x`; the split `{m, c, i}` against `{x, y}`. -/
namespace TwoBlocks
set_option linter.constructorNameAsVariable false
inductive Occ | m | c | i | x | y
def step : «际» Occ
  | .m, .m => False
  | .m, .c => False
  | .m, .i => True
  | .m, .x => False
  | .m, .y => True
  | .c, .m => False
  | .c, .c => False
  | .c, .i => False
  | .c, .x => True
  | .c, .y => False
  | .i, .m => False
  | .i, .c => False
  | .i, .i => False
  | .i, .x => False
  | .i, .y => False
  | .x, .m => False
  | .x, .c => False
  | .x, .i => False
  | .x, .x => False
  | .x, .y => False
  | .y, .m => False
  | .y, .c => False
  | .y, .i => False
  | .y, .x => False
  | .y, .y => False
def inClass : Occ → Bool
  | .m => true
  | .c => true
  | .i => true
  | .x => false
  | .y => false
def E : «际» Occ := «二分» inClass
theorem leaving_follows : ∀ m' c' u, E c' m' → step m' u → ¬ E m' u → (∃ w, step c' w) →
    ∃ x, step c' x ∧ E u x ∧ ¬ E c' x := by
  intro m' c' u hc r nu ⟨w, hw⟩
  cases m' <;> cases u <;> (try exact False.elim r) <;> (try exact absurd rfl nu) <;>
    cases c' <;> (try exact Bool.noConfusion hc) <;> cases w <;> (try exact False.elim hw)
  all_goals first
    | exact ⟨.y, trivial, rfl, fun e => Bool.noConfusion e⟩
    | exact ⟨.x, trivial, rfl, fun e => Bool.noConfusion e⟩
theorem not_at : ¬ «本类至终有常» step E .m := fun a =>
  match a .m .c rfl rfl .i trivial with
  | .inl ⟨v', r, e⟩ => match v', r, e with
    | .x, _, e => Bool.noConfusion e
  | .inr st => st .x trivial
theorem not_to_end : ¬ «至终有常» step E := fun a =>
  not_at (fun u u' mu mu' => a u u' (Eq.trans (Eq.symm mu) mu'))
end TwoBlocks

/-! ### H. §413: "in a finite net it still ends, later" needs no cycles: a two-element cycle goes on (延). -/
namespace FiniteCycle
def step : «际» Bool := fun a b => b = !a
theorem goes_on : «延» step «一» true :=
  ⟨fun _ => True, trivial, fun z _ => ⟨!z, trivial, rfl, trivial⟩⟩
end FiniteCycle

/-! ### I. The parenthesis "(needed where the start is another occurrence alike to it)" of 07 §4.6's
first theorem block: `m` conditions nothing (so it holds its effects vacuously), `c` alike to it conditions
`x` outside; the class is constant up to the net's end, and what follows `c` is not alike to `m`. -/
namespace GoesNeeded
inductive Occ | m | c | x
def step : «际» Occ
  | .m, .m => False
  | .m, .c => False
  | .m, .x => False
  | .c, .m => False
  | .c, .c => False
  | .c, .x => True
  | .x, .m => False
  | .x, .c => False
  | .x, .x => False
def inClass : Occ → Bool
  | .m => true
  | .c => true
  | .x => false
def E : «际» Occ := «二分» inClass
theorem to_end : «至终有常» step E := by
  intro u u' e v r
  cases u <;> cases v <;> (try exact False.elim r) <;> cases u' <;>
    first
    | exact Bool.noConfusion e
    | exact .inl ⟨.x, trivial, rfl⟩
    | exact .inr (fun w h => by cases w <;> exact False.elim h)
theorem fails :
    «至终有常» step E ∧ «所缘同于» step E .m ∧ E .c .m ∧ «及» step .c .x ∧ ¬ E .x .m :=
  ⟨to_end, fun v r => by cases v <;> exact False.elim r, rfl, .one trivial,
   fun e => Bool.noConfusion e⟩
end GoesNeeded

end Scratch

#print axioms Scratch.ownOutside
#print axioms Scratch.p3_of_p4
#print axioms Scratch.acting_held_continues
#print axioms Scratch.reach_iff_downstream_alike
#print axioms Scratch.p4_of_reach
#print axioms Scratch.moment_at
#print axioms Scratch.ZeroStep.ends_while_net_goes
#print axioms Scratch.NoP2.reach_without_P2
#print axioms Scratch.CleanStepCopy.acyclic
#print axioms Scratch.CleanStepCopy.not_constant_to_end
#print axioms Scratch.TwoBlocks.leaving_follows
#print axioms Scratch.TwoBlocks.not_to_end
#print axioms Scratch.FiniteCycle.goes_on
#print axioms Scratch.GoesNeeded.fails
