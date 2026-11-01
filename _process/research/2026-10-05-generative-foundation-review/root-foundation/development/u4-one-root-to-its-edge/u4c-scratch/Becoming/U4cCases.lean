import Becoming.Identity
import Becoming.U4cCensus

/-!
# Scratch for U4c: the cases (not a module of the package)

Each re-proof below has the package statement it replaces, checked by `rfl` on `type_of%` where the
signature is unchanged, and by applying it to the package's binders where an instance argument
becomes unused and is dropped.

* **`alikeAt`** (to Arising as `Steps.alikeAt`, beside `Steps.along`, with `along_fixed` as
  `Steps.along_fixed`): the two-valued class of a determination on occurrences; `Web.activityClass`
  is its case at activity (`activityClass_eq`, by `rfl`).
* **The bridges** (to Population under these names, beside `Listed`): coming to be is a beginning
  of the occurrence after the step, ceasing to be an ending of the occurrence before it, along the
  steps of one member under its class (`comesToBe_iff_sheng_along`, `ceasesToBe_iff_wang_along`).
  They are Change's `comesToBe_iff_sheng` and `ceasesToBe_iff_wang`, which read one determination
  along `Steps.next`, read at a member's occurrences along `Steps.along`; the names say which.
  `listedOccurrences` lists a step's occurrences (`occurrences` is Population's count of steps).
  `mem_map_prodMk`, `prodMk_mem_map` and `not_decide_iff`, lemmas of lists and truth values, go to
  the prelude; `total_mark_eq_count` needs `mark`, so it stays in Population.
* **`coming_of_ceasing`**: `Listed.coming_of_ceasing` through the census of a run alone, so no
  balance anchor is in its closure (D5).
* **`across_at`**: `Listed.across_at` through the two halves of the census of a step, at the step's
  relation on members (each continuing only itself, holding at both ends).
* **`balanceFrom_at`**: `Web.Census.balanceFrom_at` through the two halves, at the step's relation
  on formations (`R t`, active at both ends). The instance deciding `R` becomes unused, so the
  landing drops it from the `Counting` section's `variable` line, and the seven laws of that
  section that use it only through `balanceFrom_at` each lose it too; their copies below elaborate
  without it and with no warning. Identity's covering laws (`not_not_arisingFrom_covered`,
  `arisingFrom_not_stopping_covered`, `ceasingFrom_not_stopping_covered`) go by lineages, not
  through it, and are not cases.
-/

namespace Becoming
namespace U4cScratch

/-! ## The class of a determination on occurrences, and the bridges -/

section Bridges

variable {α : Type}

/-- The two-valued class of a determination on occurrences (二值之类): two occurrences are alike
when the determination holds at one exactly when it holds at the other. -/
def alikeAt (p : α → Nat → Prop) : «际» (Nat × α) := fun x y => p x.2 x.1 ↔ p y.2 y.1

theorem activityClass_eq {F C : Type} (W : Web F C) :
    W.activityClass = alikeAt (fun f t => W.active t f) := rfl

variable {p : α → Nat → Prop}

/-- **Coming to be is a beginning (生).** A member comes to be across the step from `t` exactly
where it holds after the step and its occurrence after the step begins, along its steps under the
class of its determination. -/
theorem comesToBe_iff_sheng_along {t : Nat} {a : α} :
    ComesToBe (p a) t ↔ p a (t + 1) ∧ «生» Steps.along (alikeAt p) (t + 1, a) :=
  ⟨fun ⟨before, after⟩ =>
    ⟨after, fun hp => before (Iff.mpr (Steps.along_hasPred_iff.mp hp) after)⟩,
   fun ⟨after, begins⟩ =>
    ⟨fun was => begins (Steps.along_hasPred_iff.mpr ⟨fun _ => after, fun _ => was⟩), after⟩⟩

/-- **Ceasing to be is an ending (亡).** A member ceases to be across the step from `t` exactly
where it holds before the step and its occurrence before the step ends. -/
theorem ceasesToBe_iff_wang_along {t : Nat} {a : α} :
    CeasesToBe (p a) t ↔ p a t ∧ «亡» Steps.along (alikeAt p) (t, a) :=
  ⟨fun ⟨held, gone⟩ =>
    ⟨held, fun hs => gone (Iff.mp (Steps.along_hasSucc_iff.mp hs) held)⟩,
   fun ⟨held, ends⟩ =>
    ⟨held, fun next => ends (Steps.along_hasSucc_iff.mpr ⟨fun _ => next, fun _ => held⟩)⟩⟩

/-- Along the steps nothing splits, under every class. -/
theorem along_fixed (E : «际» (Nat × α)) : «定后» («续» Steps.along E) :=
  «定后之逐点».mpr fun x y z ⟨⟨y1, y2⟩, _⟩ ⟨⟨z1, z2⟩, _⟩ => by
    obtain ⟨y₁, y₂⟩ := y
    obtain ⟨z₁, z₂⟩ := z
    dsimp only at y1 y2 z1 z2
    subst y1; subst y2; subst z1; subst z2; rfl

/-- The occurrences listed at a step. -/
def listedOccurrences (l : Nat → List α) (t : Nat) : List (Nat × α) := (l t).map fun a => (t, a)

theorem mem_map_prodMk {t : Nat} : ∀ {zs : List α} {y : Nat × α}, y ∈ zs.map (fun a => (t, a)) →
    y.1 = t ∧ y.2 ∈ zs
  | [], _, my => nomatch my
  | _ :: _, _, my => match GrammarLaws.mem_cons_split my with
    | .inl s => ⟨congrArg Prod.fst s, (congrArg Prod.snd s).symm ▸ .head _⟩
    | .inr m => match mem_map_prodMk m with | ⟨h1, h2⟩ => ⟨h1, .tail _ h2⟩

theorem prodMk_mem_map {t : Nat} {a : α} : ∀ {zs : List α}, a ∈ zs → (t, a) ∈ zs.map (fun a => (t, a))
  | [], m => nomatch m
  | _ :: _, m => match GrammarLaws.mem_cons_split m with
    | .inl s => s ▸ .head _
    | .inr m' => .tail _ (prodMk_mem_map m')

/-- A test is true where a proposition fails exactly when its decision is false. -/
theorem not_decide_iff {q : Prop} [Decidable q] : (!decide q) = true ↔ ¬ q := by
  cases h : decide q with
  | true => exact ⟨fun f => Bool.noConfusion f, fun n => absurd (of_decide_eq_true h) n⟩
  | false => exact ⟨fun _ => of_decide_eq_false h, fun _ => rfl⟩

/-- The total of marks is the count of their decisions. -/
theorem total_mark_eq_count {P : α → Prop} [∀ a, Decidable (P a)] :
    ∀ l : List α, total l (fun a => mark (P a)) = «计» (fun a => decide (P a)) l
  | [] => rfl
  | x :: l => by
    show mark (P x) + total l (fun a => mark (P a)) = cond (decide (P x)) 1 0 + «计» _ l
    rw [total_mark_eq_count l]
    exact congrArg (· + _) (mark_cases (q := fun n => n = cond (decide (P x)) 1 0)
      (fun h => by rw [decide_eq_true h]; rfl) (fun h => by rw [decide_eq_false h]; rfl))

end Bridges

/-! ## The cases in Population -/

section ListedCases

variable {α : Type} {p : α → Nat → Prop} [∀ a t, Decidable (p a t)] {l : Nat → List α}

/-- The beginnings' test on occurrences: an occurrence after the step from `t` begins where its
member failed at `t`. -/
def beginTest (p : α → Nat → Prop) [∀ a t, Decidable (p a t)] : Nat × α → Bool
  | (0, _) => true
  | (t + 1, a) => !decide (p a t)

/-- The endings' test: an occurrence at `t` ends where its member fails at `t + 1`. -/
def endTest (p : α → Nat → Prop) [∀ a t, Decidable (p a t)] (x : Nat × α) : Bool :=
  !decide (p x.2 (x.1 + 1))

/-- **`Listed.coming_of_ceasing`, through the census of a run.** -/
theorem coming_of_ceasing (listed : Listed p l)
    (ceasing : ∀ N, ∃ t a, N ≤ t ∧ CeasesToBe (p a) t) :
    ∀ N, ∃ t a, N ≤ t ∧ ComesToBe (p a) t :=
  fun N =>
    match «定后前者在前则亡屡者生屡» (R := Steps.along) (E := alikeAt p) (u := listedOccurrences l)
        (T := 0) (b := beginTest p) (e := endTest p)
        (fun t _ => distinct_map_on (fun _ _ _ _ same => congrArg Prod.snd same) (listed (t + 1)).1)
        (fun t _ x y my c => by
          obtain ⟨h1, h2⟩ := mem_map_prodMk my
          obtain ⟨⟨e1, e2⟩, alike⟩ := c
          obtain ⟨s, b⟩ := x
          obtain ⟨t', a⟩ := y
          dsimp only at h1 h2 e1 e2 alike
          subst h1
          have es : s = t := (Nat.succ.inj e1).symm
          subst es; subst e2
          exact prodMk_mem_map (((listed s).2 a).mp (alike.mpr (((listed (s + 1)).2 a).mpr h2))))
        (along_fixed _)
        (fun t _ y my => by
          obtain ⟨h1, h2⟩ := mem_map_prodMk my
          obtain ⟨t', a⟩ := y
          dsimp only at h1 h2
          subst h1
          have holds : p a (t + 1) := ((listed (t + 1)).2 a).mpr h2
          show (!decide (p a t)) = true ↔ _
          exact not_decide_iff.trans ⟨fun was => (comesToBe_iff_sheng_along.mp ⟨was, holds⟩).2,
            fun begins was => (comesToBe_iff_sheng_along.mpr ⟨holds, begins⟩).1 was⟩)
        (fun t _ x mx => by
          obtain ⟨h1, h2⟩ := mem_map_prodMk mx
          obtain ⟨t', a⟩ := x
          dsimp only at h1 h2
          subst h1
          have held : p a t' := ((listed t').2 a).mpr h2
          exact not_decide_iff.trans ⟨fun gone => (ceasesToBe_iff_wang_along.mp ⟨held, gone⟩).2,
            fun ends next => (ceasesToBe_iff_wang_along.mpr ⟨held, ends⟩).2 next⟩)
        (fun M => match ceasing M with
          | ⟨t, a, later, ceases⟩ =>
            ⟨t, later, (t, a), prodMk_mem_map (((listed t).2 a).mp ceases.1),
              (ceasesToBe_iff_wang_along.mp ceases).2⟩)
        N with
    | ⟨t, later, y, my, begins⟩ => by
        obtain ⟨h1, h2⟩ := mem_map_prodMk my
        obtain ⟨t', a⟩ := y
        dsimp only at h1 h2
        subst h1
        exact ⟨t, a, later, comesToBe_iff_sheng_along.mpr ⟨((listed (t + 1)).2 a).mpr h2, begins⟩⟩

example : type_of% @Listed.coming_of_ceasing = type_of% @coming_of_ceasing := rfl

/-- **`Listed.across_at`, through the two halves of the census of a step**, at the step's relation
on members: each continues only itself, holding at both ends. -/
theorem across_at {t : Nat} (now : Distinct (l t) ∧ ∀ a, p a t ↔ a ∈ l t)
    (next : Distinct (l (t + 1)) ∧ ∀ a, p a (t + 1) ↔ a ∈ l (t + 1)) :
    (l (t + 1)).length + ceasings (l t) p t = (l t).length + comings (l (t + 1)) p t :=
  have one := «定后则后并亡不过前并生» (R := fun a b => a = b) (E := fun a b => p a t ∧ p b (t + 1))
    (b := fun a => decide (ComesToBe (p a) t)) (e := fun a => decide (CeasesToBe (p a) t))
    (before := l t) (after := l (t + 1)) next.1
    («定后之逐点».mpr fun _ _ _ c c' => c.1.symm.trans c'.1)
    (fun y my off none =>
      have holds : p y (t + 1) := (next.2 y).mpr my
      (fun np : ¬ p y t => of_decide_eq_false off ⟨np, holds⟩)
        fun held => none ⟨y, (now.2 y).mp held, rfl, held, holds⟩)
    (fun x _ on y _ c => match c with
      | ⟨same, _, after⟩ => (of_decide_eq_true on).2 (same ▸ after))
  have other := «定前则前并生不过后并亡» (R := fun a b => a = b)
    (E := fun a b => p a t ∧ p b (t + 1))
    (b := fun a => decide (ComesToBe (p a) t)) (e := fun a => decide (CeasesToBe (p a) t))
    (before := l t) (after := l (t + 1)) now.1
    («定前之逐点».mpr fun _ _ _ c c' => c.1.trans c'.1.symm)
    (fun x mx off none =>
      have held : p x t := (now.2 x).mpr mx
      (fun nn : ¬ p x (t + 1) => of_decide_eq_false off ⟨held, nn⟩)
        fun next' => none ⟨x, (next.2 x).mp next', rfl, held, next'⟩)
    (fun y _ on x _ c => match c with
      | ⟨same, before, _⟩ => (of_decide_eq_true on).1 (same.symm ▸ before))
  by
    show (l (t + 1)).length + total (l t) (fun a => mark (CeasesToBe (p a) t)) =
      (l t).length + total (l (t + 1)) (fun a => mark (ComesToBe (p a) t))
    rw [total_mark_eq_count, total_mark_eq_count]
    exact Nat.le_antisymm one other

example : type_of% @Listed.across_at = type_of% @across_at := rfl

end ListedCases

/-! ## The case in Identity -/

section IdentityCase

variable {F C : Type} (W : Web F C) (R : Nat → F → F → Prop)
variable [∀ t f, Decidable (W.active t f)] [∀ t f, Decidable (W.Continues R t f)]
  [∀ t g, Decidable (W.Continued R t g)]
variable {W R}

/-- **`Web.Census.balanceFrom_at`, through the two halves of the census of a step**, at the
step's relation on formations: `R t`, the formations active at both ends. -/
theorem balanceFrom_at {alive : Nat → List F} {t : Nat}
    (now : Distinct (alive t) ∧ ∀ f, W.active t f ↔ f ∈ alive t)
    (next : Distinct (alive (t + 1)) ∧ ∀ f, W.active (t + 1) f ↔ f ∈ alive (t + 1)) :
    ((∀ g f f', W.active t g → R t g f → R t g f' → W.active (t + 1) f →
      W.active (t + 1) f' → f = f') →
      (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g)) ≤
        (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f))) ∧
    ((∀ g g' f, W.active t g → W.active t g' → R t g f → R t g' f →
      W.active (t + 1) f → g = g') →
      (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f)) ≤
        (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g))) :=
  ⟨fun noSplit => by
    rw [total_mark_eq_count, total_mark_eq_count]
    exact «定后则后并亡不过前并生» (R := R t) (E := fun g f => W.active t g ∧ W.active (t + 1) f)
      next.1
      («定后之逐点».mpr fun g f f' ⟨r, active, af⟩ ⟨r', _, af'⟩ => noSplit g f f' active r r' af af')
      (fun f mf off none =>
        have af : W.active (t + 1) f := (next.2 f).mpr mf
        (fun alone : ¬ W.Continues R t f => of_decide_eq_false off ⟨af, alone⟩)
          fun ⟨g, ag, r⟩ => none ⟨g, (now.2 g).mp ag, r, ag, af⟩)
      (fun g _ on f _ ⟨r, _, af⟩ => (of_decide_eq_true on).2 ⟨f, af, r⟩),
   fun noMerge => by
    rw [total_mark_eq_count, total_mark_eq_count]
    exact «定前则前并生不过后并亡» (R := R t) (E := fun g f => W.active t g ∧ W.active (t + 1) f)
      now.1
      («定前之逐点».mpr fun g g' f ⟨r, ag, af⟩ ⟨r', ag', _⟩ => noMerge g g' f ag ag' r r' af)
      (fun g mg off none =>
        have ag : W.active t g := (now.2 g).mpr mg
        (fun alone : ¬ W.Continued R t g => of_decide_eq_false off ⟨ag, alone⟩)
          fun ⟨f, af, r⟩ => none ⟨f, (next.2 f).mp af, r, ag, af⟩)
      (fun f _ on g _ ⟨r, ag, _⟩ => (of_decide_eq_true on).2 ⟨g, ag, r⟩)⟩

/-- The package statement, with its unused instance, from the re-proof. -/
example {F C : Type} {W : Web F C} {R : Nat → F → F → Prop} [∀ t f, Decidable (W.active t f)]
    [∀ t f, Decidable (W.Continues R t f)] [∀ t g, Decidable (W.Continued R t g)]
    [∀ t g f, Decidable (R t g f)] {alive : Nat → List F} {t : Nat}
    (now : Distinct (alive t) ∧ ∀ f, W.active t f ↔ f ∈ alive t)
    (next : Distinct (alive (t + 1)) ∧ ∀ f, W.active (t + 1) f ↔ f ∈ alive (t + 1)) :
    type_of% (Web.Census.balanceFrom_at (W := W) (R := R) now next) :=
  balanceFrom_at now next

/-! ### The section without the instance deciding `R` (copies, not for landing)

The seven laws of Identity's `Counting` section that use the instance deciding `R` only through
`balanceFrom_at`, copied with their proofs as they stand, in a section without that instance. Each
elaborates with no warning, so dropping the instance from the section's `variable` line leaves no
section variable unused. Calls by dot notation (`census.balanceFrom`) name the copies here. -/

theorem balanceFrom {alive : Nat → List F} (census : W.Census alive) (t : Nat) :
    (W.NoSplit R → (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g)) ≤
      (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f))) ∧
    (W.NoMerge R → (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f)) ≤
      (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g))) :=
  ⟨fun noSplit => (balanceFrom_at (census t) (census (t + 1))).1 (noSplit t),
   fun noMerge => (balanceFrom_at (census t) (census (t + 1))).2 (noMerge t)⟩

theorem balanceFrom_eq_at {alive : Nat → List F} {t : Nat}
    (now : Distinct (alive t) ∧ ∀ f, W.active t f ↔ f ∈ alive t)
    (next : Distinct (alive (t + 1)) ∧ ∀ f, W.active (t + 1) f ↔ f ∈ alive (t + 1))
    (noSplit : ∀ g f f', W.active t g → R t g f → R t g f' → W.active (t + 1) f →
      W.active (t + 1) f' → f = f')
    (noMerge : ∀ g g' f, W.active t g → W.active t g' → R t g f → R t g' f →
      W.active (t + 1) f → g = g') :
    (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g)) =
      (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f)) :=
  Nat.le_antisymm ((balanceFrom_at now next).1 noSplit) ((balanceFrom_at now next).2 noMerge)

theorem balanceFrom_eq {alive : Nat → List F} (census : W.Census alive) (t : Nat)
    (noSplit : W.NoSplit R) (noMerge : W.NoMerge R) :
    (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g)) =
      (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f)) :=
  Nat.le_antisymm ((balanceFrom census t).1 noSplit) ((balanceFrom census t).2 noMerge)

theorem arisingFrom_of_ceasingFrom_from {alive : Nat → List F} {T : Nat}
    (listing : ∀ s, T ≤ s → Distinct (alive s) ∧ ∀ f, W.active s f ↔ f ∈ alive s)
    (noSplit : ∀ s, T ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f')
    (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) : W.UnceasingFrom R :=
  fun N => match Becoming.gaining_of_losing_from (T := T) (q := fun t => (alive t).length)
      (x := fun t => total (alive t) fun g => mark (W.CeasesFrom R t g))
      (y := fun t => total (alive (t + 1)) fun f => mark (W.ArisesFrom R t f))
      (fun t from_ => (balanceFrom_at (listing t from_)
        (listing (t + 1) (Nat.le_succ_of_le from_))).1 (noSplit t from_))
      (fun M => match ceasing (M + T) with
        | ⟨t, g, later, ceases⟩ => ⟨t, Nat.le_trans (Nat.le_add_right M T) later,
          total_pos_of_mem (((listing t (Nat.le_trans (Nat.le_add_left T M) later)).2 g).mp
            ceases.1) (mark_pos.mpr ceases)⟩) N with
  | ⟨t, later, arose⟩ => match Becoming.total_pos _ arose with
    | ⟨f, _, arises⟩ => ⟨t, f, later, mark_pos.mp arises⟩

theorem arisingFrom_of_ceasingFrom {alive : Nat → List F} (census : W.Census alive)
    (noSplit : W.NoSplit R) (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) :
    W.UnceasingFrom R :=
  arisingFrom_of_ceasingFrom_from (T := 0) (fun s _ => census s) (fun s _ => noSplit s) ceasing

theorem ceasingFrom_of_arisingFrom_from {alive : Nat → List F} {T B : Nat}
    (listing : ∀ s, T ≤ s → Distinct (alive s) ∧ ∀ f, W.active s f ↔ f ∈ alive s)
    (noMerge : ∀ s, T ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f → R s g' f →
      W.active (s + 1) f → g = g')
    (bounded : ∀ t, T ≤ t → (alive t).length ≤ B) (arising : W.UnceasingFrom R) :
    ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g :=
  fun N => match losing_of_gaining_from (T := T) (q := fun t => (alive t).length)
      (x := fun t => total (alive t) fun g => mark (W.CeasesFrom R t g))
      (y := fun t => total (alive (t + 1)) fun f => mark (W.ArisesFrom R t f))
      (fun t from_ => (balanceFrom_at (listing t from_)
        (listing (t + 1) (Nat.le_succ_of_le from_))).2 (noMerge t from_))
      bounded (fun M => match arising (M + T) with
        | ⟨t, f, later, arises⟩ => ⟨t, Nat.le_trans (Nat.le_add_right M T) later,
          total_pos_of_mem (((listing (t + 1) (Nat.le_succ_of_le
            (Nat.le_trans (Nat.le_add_left T M) later))).2 f).mp arises.1) (mark_pos.mpr arises)⟩) N with
  | ⟨t, later, ceased⟩ => match Becoming.total_pos _ ceased with
    | ⟨g, _, ceases⟩ => ⟨t, g, later, mark_pos.mp ceases⟩

theorem ceasingFrom_of_arisingFrom {alive : Nat → List F} (census : W.Census alive)
    (noMerge : W.NoMerge R) {T B : Nat} (bounded : ∀ t, T ≤ t → (alive t).length ≤ B)
    (arising : W.UnceasingFrom R) : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g :=
  ceasingFrom_of_arisingFrom_from (fun s _ => census s) (fun s _ => noMerge s) bounded arising

end IdentityCase

end U4cScratch
end Becoming
