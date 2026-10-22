/-
Scratch checks for the formal review of PLAN.md version 9 (one-unfolding root).
Prelude only. Names: meet = 合, cont = 续, hasPred = 有前, hasSucc = 有后,
arise = 生, cease = 亡, abide = 住, comp = 而, conv = 逆, incl = 则, steady = 有常,
core = 核, rebirth = 复生, Chain = 相续, Plus = 缘之传递闭包 (时), top = 一.
xiangxu = 相须. core2 is the two-sided core proposed as a fix (有常 for R and for 逆 R).
-/
namespace V9

abbrev Rel (α : Type) := α → α → Prop

section
variable {α : Type}

def meet (R S : Rel α) : Rel α := fun x y => R x y ∧ S x y
def cont (R E : Rel α) : Rel α := meet R E
def hasPred (R E : Rel α) (y : α) : Prop := ∃ x, cont R E x y
def hasSucc (R E : Rel α) (x : α) : Prop := ∃ y, cont R E x y
def arise (R E : Rel α) (y : α) : Prop := ¬ hasPred R E y
def cease (R E : Rel α) (x : α) : Prop := ¬ hasSucc R E x
def abide (R E : Rel α) (x : α) : Prop := hasPred R E x ∧ hasSucc R E x
def comp (R S : Rel α) : Rel α := fun x z => ∃ y, R x y ∧ S y z
def conv (R : Rel α) : Rel α := fun x y => R y x
def incl (R S : Rel α) : Prop := ∀ x y, R x y → S x y
def steady (R E : Rel α) : Prop := incl (comp (conv E) R) (comp R (conv E))
def core (R E : Rel α) : Rel α :=
  fun u u' => ∃ S : Rel α, incl S E ∧ incl S (conv S) ∧ steady R S ∧ S u u'
def core2 (R E : Rel α) : Rel α :=
  fun u u' => ∃ S : Rel α, incl S E ∧ incl S (conv S) ∧ steady R S ∧ steady (conv R) S ∧ S u u'
def rebirth (R E : Rel α) (x : α) : Prop := ∃ y, R x y ∧ arise R E y
def xiangxu (R E₁ E₂ : Rel α) : Prop := steady R (meet E₁ E₂) ∧ ¬ steady R E₁ ∧ ¬ steady R E₂
def top : Rel α := fun _ _ => True
def Equiv (E : Rel α) : Prop :=
  (∀ x, E x x) ∧ (∀ x y, E x y → E y x) ∧ (∀ x y z, E x y → E y z → E x z)

inductive Chain (R E : Rel α) : Rel α
  | one {x y} : cont R E x y → Chain R E x y
  | more {x y z} : cont R E x y → Chain R E y z → Chain R E x z

inductive Plus (R : Rel α) : Rel α
  | one {x y} : R x y → Plus R x y
  | more {x y z} : R x y → Plus R y z → Plus R x z

/-! ### Sketched theorems of §4.3–4.4 -/

theorem cont_sub (R E : Rel α) : incl (cont R E) R := fun _ _ h => h.1

theorem chain_sub_time (R E : Rel α) : incl (Chain R E) (Plus R) := by
  intro x y h
  induction h with
  | one c => exact .one c.1
  | more c _ ih => exact .more c.1 ih

theorem coarsen {R E E' : Rel α} (h : incl E E') : incl (cont R E) (cont R E') :=
  fun x y c => ⟨c.1, h x y c.2⟩

theorem cease_of_coarse {R E E' : Rel α} (h : incl E E') {x : α} :
    cease R E' x → cease R E x :=
  fun n ⟨y, c⟩ => n ⟨y, coarsen h x y c⟩

theorem arise_of_coarse {R E E' : Rel α} (h : incl E E') {x : α} :
    arise R E' x → arise R E x :=
  fun n ⟨y, c⟩ => n ⟨y, coarsen h y x c⟩

theorem abide_of_fine {R E E' : Rel α} (h : incl E E') {x : α} :
    abide R E x → abide R E' x :=
  fun ⟨⟨w, c⟩, ⟨z, d⟩⟩ => ⟨⟨w, coarsen h w x c⟩, ⟨z, coarsen h x z d⟩⟩

theorem one_cont (R : Rel α) (x y : α) : cont R top x y ↔ R x y :=
  ⟨fun h => h.1, fun h => ⟨h, trivial⟩⟩

/-- For an equivalence E: 有常 R E iff E;R;E ⊆ R;E. -/
theorem steady_iff_closed {R E : Rel α} (e : Equiv E) :
    steady R E ↔ incl (comp (comp E R) E) (comp R E) := by
  obtain ⟨rf, sy, tr⟩ := e
  constructor
  · intro st x z ⟨y, ⟨w, exw, rwy⟩, eyz⟩
    obtain ⟨v, rxv, eyv⟩ := st x y ⟨w, sy _ _ exw, rwy⟩
    exact ⟨v, rxv, tr _ _ _ (sy _ _ eyv) eyz⟩
  · intro cl x z ⟨m, emx, rmz⟩
    obtain ⟨v, rxv, evz⟩ := cl x z ⟨z, ⟨m, sy _ _ emx, rmz⟩, rf z⟩
    exact ⟨v, rxv, sy _ _ evz⟩

/-- "每一事或生或有前" for every model is excluded middle. -/
theorem phases_iff_em :
    (∀ (β : Type) (R E : Rel β) (y : β), arise R E y ∨ hasPred R E y) ↔ ∀ p : Prop, p ∨ ¬ p := by
  constructor
  · intro h p
    cases h Unit (fun _ _ => p) top () with
    | inl n => exact .inr (fun hp => n ⟨(), hp, trivial⟩)
    | inr hx => exact .inl (match hx with | ⟨_, hp, _⟩ => hp)
  · intro em β R E y
    cases em (hasPred R E y) with
    | inl h => exact .inr h
    | inr h => exact .inl h

theorem steady_congr {R E E' : Rel α} (h : ∀ x y, E x y ↔ E' x y) : steady R E → steady R E' :=
  fun st x z ⟨m, e, r⟩ => match st x z ⟨m, (h m x).mpr e, r⟩ with
    | ⟨w, r', e'⟩ => ⟨w, r', (h z w).mp e'⟩

theorem xiangxu_symm {R E₁ E₂ : Rel α} : xiangxu R E₁ E₂ → xiangxu R E₂ E₁ :=
  fun ⟨s, n₁, n₂⟩ => ⟨steady_congr (fun _ _ => ⟨fun ⟨a, b⟩ => ⟨b, a⟩, fun ⟨a, b⟩ => ⟨b, a⟩⟩) s, n₂, n₁⟩

theorem xiangxu_irrefl {R E : Rel α} : ¬ xiangxu R E E :=
  fun ⟨s, n, _⟩ => n (steady_congr (fun _ _ => ⟨fun h => h.1, fun h => ⟨h, h⟩⟩) s)

/-! ### Finding A: a steady (有常) distinction never lets a continuation end -/

/-- Whatever has a 续-predecessor under a steady E has a 续-successor: 有常 ⇒ 不亡. No hypothesis
on E (not even symmetry). -/
theorem steady_continues {R E : Rel α} (st : steady R E) {y : α} :
    hasPred R E y → hasSucc R E y :=
  fun ⟨x, rxy, exy⟩ => match st y y ⟨x, exy, rxy⟩ with
    | ⟨w, ryw, eyw⟩ => ⟨w, ryw, eyw⟩

theorem steady_cease_arise {R E : Rel α} (st : steady R E) {y : α} :
    cease R E y → arise R E y :=
  fun n p => n (steady_continues st p)

theorem steady_chain_open {R E : Rel α} (st : steady R E) {x y : α} :
    Chain R E x y → hasSucc R E y := by
  intro h
  induction h with
  | one c => exact steady_continues st ⟨_, c⟩
  | more _ _ ih => exact ih

end

/-! ### The plan's flame: f₀ → f₁ → f₂ → 灰 -/

inductive Ev | f0 | f1 | f2 | ash

inductive flame : Rel Ev
  | s0 : flame .f0 .f1
  | s1 : flame .f1 .f2
  | s2 : flame .f2 .ash

def isFire : Ev → Bool
  | .f0 => true
  | .f1 => true
  | .f2 => true
  | .ash => false

def fireE : Rel Ev := fun x y => isFire x = isFire y

theorem ash_no_cont (E : Rel Ev) (y : Ev) : ¬ cont flame E .ash y := by
  intro ⟨h, _⟩; cases h

/-- §4.3 correction (checked): f₁, f₂ are not in one 核 class under fire/non-fire. -/
theorem correction : ¬ core flame fireE .f1 .f2 := by
  intro ⟨S, sub, _, st, s⟩
  obtain ⟨w, r, s'⟩ := st .f2 .f2 ⟨.f1, s, .s1⟩
  cases r
  exact Bool.noConfusion (sub _ _ s')

/-- Finding A on the plan's own flame: under EVERY steady distinction (fire alone, fire ∧ fuel,
anything), the flame has no continuation at all. -/
theorem flame_steady_empty (E : Rel Ev) (st : steady flame E) : ∀ x y, ¬ cont flame E x y := by
  have h2 : ∀ y, ¬ cont flame E .f2 y := by
    intro y c
    obtain ⟨w, c'⟩ := steady_continues st ⟨_, c⟩
    have r := c.1
    cases r
    exact ash_no_cont E w c'
  have h1 : ∀ y, ¬ cont flame E .f1 y := by
    intro y c
    obtain ⟨w, c'⟩ := steady_continues st ⟨_, c⟩
    have r := c.1
    cases r
    exact h2 w c'
  have h0 : ∀ y, ¬ cont flame E .f0 y := by
    intro y c
    obtain ⟨w, c'⟩ := steady_continues st ⟨_, c⟩
    have r := c.1
    cases r
    exact h1 w c'
  intro x y
  cases x with
  | f0 => exact h0 y
  | f1 => exact h1 y
  | f2 => exact h2 y
  | ash => exact ash_no_cont E y

/-! ### Finding B: splicing within one 缘 net (the plan's two candles) -/

inductive Cd | a0 | a1 | m | b0 | b1

/-- Candle A burns a0 → a1; a match m lights B (m → b0); A's heat is also among b0's 缘 (a1 → b0). -/
inductive candles : Rel Cd
  | a : candles .a0 .a1
  | heat : candles .a1 .b0
  | light : candles .m .b0
  | b : candles .b0 .b1

/-- All are flame occurrences: fire/non-fire is `top` here. A's flame "continues" into B, and
B's first flame has two 续-predecessors (a merge). -/
theorem candle_splice : cont candles top .a1 .b0 ∧ cont candles top .m .b0 :=
  ⟨⟨.heat, trivial⟩, ⟨.light, trivial⟩⟩

/-- Any single 缘 edge is a 续 under a two-point equivalence. -/
theorem any_edge {α : Type} (R : Rel α) {x y : α} (r : R x y) :
    ∃ E : Rel α, Equiv E ∧ cont R E x y :=
  let E : Rel α := fun a b => a = b ∨ (a = x ∧ b = y) ∨ (a = y ∧ b = x)
  ⟨E, ⟨fun _ => .inl rfl,
       fun a b h => match h with
         | .inl e => .inl e.symm
         | .inr (.inl ⟨ha, hb⟩) => .inr (.inr ⟨hb, ha⟩)
         | .inr (.inr ⟨ha, hb⟩) => .inr (.inl ⟨hb, ha⟩),
       fun a b c h k => match h, k with
         | .inl e, k => e ▸ k
         | h, .inl e => e ▸ h
         | .inr (.inl ⟨ha, _⟩), .inr (.inl ⟨_, hc⟩) => .inr (.inl ⟨ha, hc⟩)
         | .inr (.inl ⟨ha, _⟩), .inr (.inr ⟨_, hc⟩) => .inl (ha.trans hc.symm)
         | .inr (.inr ⟨ha, _⟩), .inr (.inl ⟨_, hc⟩) => .inl (ha.trans hc.symm)
         | .inr (.inr ⟨ha, _⟩), .inr (.inr ⟨_, hc⟩) => .inr (.inr ⟨ha, hc⟩)⟩,
   r, .inr (.inl ⟨rfl, rfl⟩)⟩

/-! ### Finding C: 位 (core) and phase come apart; two-sided core repairs 生 -/

def toTrue : Rel Bool := fun _ b => b = true

theorem same_place_other_phase :
    core toTrue top false true ∧ arise toTrue top false ∧ ¬ arise toTrue top true :=
  ⟨⟨top, fun _ _ _ => trivial, fun _ _ _ => trivial,
     fun x _ ⟨_, _, r⟩ => ⟨true, rfl, r ▸ trivial⟩, trivial⟩,
   fun ⟨_, r, _⟩ => Bool.noConfusion r,
   fun n => n ⟨true, rfl, trivial⟩⟩

section
variable {α : Type}

/-- With E an equivalence, 亡 is invariant under the (one-sided) core. -/
theorem cease_invariant {R E : Rel α} (e : Equiv E) {y y' : α} (k : core R E y y') :
    cease R E y → cease R E y' := by
  obtain ⟨_, sy, tr⟩ := e
  obtain ⟨S, sub, ssym, st, s⟩ := k
  intro n ⟨z', r', e'⟩
  obtain ⟨z, rz, sz⟩ := st y z' ⟨y', ssym _ _ s, r'⟩
  exact n ⟨z, rz, tr _ _ _ (sub _ _ s) (tr _ _ _ e' (sub _ _ sz))⟩

/-- With E an equivalence, 生 is invariant under the two-sided core (fix). -/
theorem arise_invariant2 {R E : Rel α} (e : Equiv E) {y y' : α} (k : core2 R E y y') :
    arise R E y → arise R E y' := by
  obtain ⟨_, sy, tr⟩ := e
  obtain ⟨S, sub, ssym, _, stb, s⟩ := k
  intro n ⟨x', r', e'⟩
  obtain ⟨w, rw, sw⟩ := stb y x' ⟨y', ssym _ _ s, r'⟩
  exact n ⟨w, rw, tr _ _ _ (sy _ _ (sub _ _ sw)) (tr _ _ _ e' (sy _ _ (sub _ _ s)))⟩

end

/-- A stationary process (an integer chain): two moments are two-sided bisimilar (one 位 by
"位由际定"), yet time separates them. -/
inductive Z | zero | pos (n : Nat) | neg (n : Nat)   -- 0, n+1, -(n+1)

def Z.succ : Z → Z
  | .zero => .pos 0
  | .pos n => .pos (n + 1)
  | .neg 0 => .zero
  | .neg (n + 1) => .neg n

def Z.pred : Z → Z
  | .zero => .neg 0
  | .pos 0 => .zero
  | .pos (n + 1) => .pos n
  | .neg n => .neg (n + 1)

theorem Z.succ_pred : ∀ x : Z, x.pred.succ = x
  | .zero => rfl
  | .pos 0 => rfl
  | .pos (_ + 1) => rfl
  | .neg _ => rfl

def zchain : Rel Z := fun m n => n = m.succ

theorem stationary_one_place : core2 zchain top .zero (.pos 0) ∧ Plus zchain .zero (.pos 0) :=
  ⟨⟨top, fun _ _ _ => trivial, fun _ _ _ => trivial,
     fun x _ _ => ⟨x.succ, rfl, trivial⟩,
     fun x _ _ => ⟨x.pred, (Z.succ_pred x).symm, trivial⟩, trivial⟩,
   .one rfl⟩

/-! ### Finding D: coarse net L;R;L puts every internal 缘 on a loop -/

section
variable {α : Type}

theorem coarse_loop {R L : Rel α} (rf : ∀ x, L x x) (sy : ∀ x y, L x y → L y x) {x y : α}
    (r : R x y) (l : L x y) : comp (comp L R) L x x ∧ comp (comp L R) L y y :=
  ⟨⟨y, ⟨x, rf x, r⟩, sy _ _ l⟩, ⟨y, ⟨x, sy _ _ l, r⟩, rf y⟩⟩

/-- In the coarse net, an L-class containing a 缘 neither arises nor ends, under any reflexive E'. -/
theorem coarse_no_arise_no_end {R L E' : Rel α} (rf : ∀ x, L x x) (sy : ∀ x y, L x y → L y x)
    (rE : ∀ x, E' x x) {x y : α} (r : R x y) (l : L x y) :
    ¬ arise (comp (comp L R) L) E' x ∧ ¬ cease (comp (comp L R) L) E' x :=
  ⟨fun n => n ⟨x, (coarse_loop rf sy r l).1, rE x⟩,
   fun n => n ⟨x, (coarse_loop rf sy r l).1, rE x⟩⟩

/-! ### Finding E: 复生 runs from "never" to "any consequence" with E -/

theorem rebirth_top_never (R : Rel α) (x : α) : ¬ rebirth R top x :=
  fun ⟨_, r, a⟩ => a ⟨x, r, trivial⟩

theorem rebirth_eq_any (R : Rel α) (irr : ∀ x, ¬ R x x) (x : α) :
    rebirth R (fun a b => a = b) x ↔ ∃ y, R x y :=
  ⟨fun ⟨y, r, _⟩ => ⟨y, r⟩,
   fun ⟨y, r⟩ => ⟨y, r, fun ⟨z, rz, e⟩ => irr z (e ▸ rz)⟩⟩

end

/-! ### Fission: sameness (refl-symm closure of 相续) is not transitive -/

inductive T3 | a | b | c

inductive split : Rel T3
  | l : split .a .b
  | r : split .a .c

def same (x y : T3) : Prop := x = y ∨ Chain split top x y ∨ Chain split top y x

theorem chain_from_leaf {z : T3} (hz : ∀ w, ¬ split z w) : ∀ w, ¬ Chain split top z w := by
  intro w h
  cases h with
  | one c => exact hz _ c.1
  | more c _ => exact hz _ c.1

theorem fission_not_transitive : same .b .a ∧ same .a .c ∧ ¬ same .b .c :=
  ⟨.inr (.inr (.one ⟨.l, trivial⟩)), .inr (.inl (.one ⟨.r, trivial⟩)),
   fun h => match h with
     | .inl e => T3.noConfusion e
     | .inr (.inl k) => chain_from_leaf (z := .b) (fun _ h => nomatch h) _ k
     | .inr (.inr k) => chain_from_leaf (z := .c) (fun _ h => nomatch h) _ k⟩

/-! ### "某分别之亡即其补之生" fails for many-to-many 缘 -/

def pE (p : T3 → Prop) : Rel T3 := fun x y => (p x ↔ p y)
def isA : T3 → Prop | .a => True | .b => False | .c => False
/-- a (p) → b (¬p) and c (¬p) → b. -/
inductive into : Rel T3
  | ab : into .a .b
  | cb : into .c .b

theorem end_not_beginning : cease into (pE isA) .a ∧ ¬ arise into (pE isA) .b :=
  ⟨fun ⟨_, r, e⟩ => by
     cases r
     exact e.mp trivial,
   fun n => n ⟨.c, .cb, ⟨fun h => h.elim, fun h => h.elim⟩⟩⟩

end V9

#print axioms V9.cont_sub
#print axioms V9.chain_sub_time
#print axioms V9.coarsen
#print axioms V9.cease_of_coarse
#print axioms V9.arise_of_coarse
#print axioms V9.abide_of_fine
#print axioms V9.one_cont
#print axioms V9.steady_iff_closed
#print axioms V9.phases_iff_em
#print axioms V9.xiangxu_symm
#print axioms V9.xiangxu_irrefl
#print axioms V9.steady_continues
#print axioms V9.steady_cease_arise
#print axioms V9.steady_chain_open
#print axioms V9.correction
#print axioms V9.flame_steady_empty
#print axioms V9.candle_splice
#print axioms V9.any_edge
#print axioms V9.same_place_other_phase
#print axioms V9.cease_invariant
#print axioms V9.arise_invariant2
#print axioms V9.stationary_one_place
#print axioms V9.coarse_loop
#print axioms V9.coarse_no_arise_no_end
#print axioms V9.rebirth_top_never
#print axioms V9.rebirth_eq_any
#print axioms V9.fission_not_transitive
#print axioms V9.end_not_beginning
