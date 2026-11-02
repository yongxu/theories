import Becoming.GrammarMap

/-!
# The map's regions: their coverage, and the split of a beginning (地图之域：周与生之分)

Laws of the map of `Becoming.GrammarMap`, kept in a module of their own that imports it, since most
of the package depends on GrammarMap and no module below needs these laws. They hold for every
carrier and relation, read at two grains as there: a fine class `E` (the parts) and a coarse class
`L` (the pattern).

* **The split of a beginning.** A carrying renewal begins no line of the pattern (`«传则粗不生»`).
  Where the pattern has a predecessor, a beginning of a part is the end of a carrying renewal
  (`«粗有前则生为传»`). So a beginning of a part is a beginning of the pattern or the end of a
  carrying renewal, as far as can be refuted (`«生则或粗生或传»`). No order between the classes is
  assumed. Where `E` is finer than `L`, a beginning of the pattern is also one of its parts
  (`«生于粗则生于细»`, in the grammar).
* **Keeping from some point on (`«后守»`).** Along some branch the pattern goes on, and from a point
  of that branch reached from the start no carrying renewal lies on it. Strict keeping (`«守»`) forbids renewal
  on the whole branch, so a pattern that renews and then stays is in none of 生成, 守 and 退化
  (`Map.Once`: not generating, not keeping, not degenerating). It keeps from some point on and in
  the strong form (`Map.Once.keepsAfter`, `Map.Once.keeping`). Keeping gives keeping from some point
  on (`«守则后守»`), and so does keeping in the strong form (`«全守则后守»`). It goes on along its
  branch (`«后守则延»`), so it excludes degeneration (`«后守退化不并»`).
* **The regions cover.** With excluded middle as a hypothesis, every point is 生成, 后守 or 退化
  (`«三域之周»`). That this holds at every point of every model is exactly excluded middle
  (`«三域之定当且仅当排中»`), as for going on and ending (`«延尽之定当且仅当排中»`), and the strong
  forms (`«全三域之定当且仅当排中»`). Where each occurrence conditions at most one other, generation
  and keeping from some point on exclude each other (`«单行则生成后守不并»`), so on single lines the
  three regions partition, given excluded middle. Where lines branch, 生成 and 后守 overlap, as the
  map intends (`Map.«生守相杂»` with `«守则后守»`).
* **Telling whether a line keeps from some point on is deciding whether it stops renewing.** On the
  line of steps under the one, read with the class of a sequence of truth values, the first step is
  生成 exactly where the sequence changes at arbitrarily late steps (`Map.generates_iff_changes`),
  and 后守 exactly where it is constant from some step on (`Map.keepsAfter_iff_settles`). For a
  sequence that turns at every step until `p` first holds and stays after (`Map.Settles.sequence`),
  deciding 后守 alone decides whether `p` ever holds, LPO for `p` (`Map.«后守之定则LPO»`), and
  deciding 生成 alone gives only WLPO for `p` (`Map.«生成之定则WLPO»`). So placing the first step in
  生成 or 后守 for every sequence gives LPO (`Map.«生成后守之定则LPO»`). That placement is the
  decision, for every sequence, whether it changes without end or settles (Σ⁰₂); LPO is the part
  derived, and without countable choice the core does not give the placement back from LPO. The
  need is not of the logic alone: to tell whether a line keeps from some point on is to decide
  whether it stops renewing. The nearest landed calibration is `Settling.OneWay.lpo_of_settles`;
  the conclusion is `Becoming.LPO` written out. The coding repeats `Settling`'s first-hit search,
  which this module does not import.

Every declaration has an empty axiom report.
-/

namespace Becoming

universe u

section Regions

variable {α : Type u}

/-! ## The split of a beginning -/

/-- **A carrying renewal begins no line of the pattern**: its continuation under `L` is a
predecessor there. -/
theorem «传则粗不生» {R L E : «际» α} {x y : α} (h : «传» R L E x y) : ¬ «生» R L y :=
  fun begins => begins ⟨x, h.1⟩

/-- Where the pattern has a predecessor, a beginning of a part is the end of a carrying renewal. -/
theorem «粗有前则生为传» {R L E : «际» α} {y : α} (continued : «有前» R L y) (begins : «生» R E y) :
    ∃ x, «传» R L E x y :=
  match continued with
  | ⟨x, c⟩ => ⟨x, c, begins⟩

/-- **A beginning of a part is a beginning of the pattern or the end of a carrying renewal**, as far
as can be refuted. No order between `E` and `L` is assumed. -/
theorem «生则或粗生或传» {R L E : «际» α} {y : α} (begins : «生» R E y) :
    ¬ ¬ («生» R L y ∨ ∃ x, «传» R L E x y) :=
  fun neither => neither (.inl fun continued => neither (.inr («粗有前则生为传» continued begins)))

/-! ## Keeping from some point on -/

/-- Keeping from some point on (后守): along some branch the pattern goes on, and from a point of
that branch reached from `x` no carrying renewal lies on it. The point must be reached from `x`; a
still point elsewhere does not count. -/
def «后守» (R L E : «际» α) (x : α) : Prop :=
  ∃ S : α → Prop, S x ∧ (∀ z, S z → ∃ w, S w ∧ «续» R L z w) ∧
    ∃ z, «所及» R L x z ∧ S z ∧ ∀ u v, S u → S v → «所及» R L z u → ¬ «传» R L E u v

/-- Keeping is keeping from some point on, the point `x` itself. -/
theorem «守则后守» {R L E : «际» α} {x : α} (h : «守» R L E x) : «后守» R L E x :=
  match h with
  | ⟨S, hx, closed, quiet⟩ => ⟨S, hx, closed, x, .inl rfl, hx, fun u v su sv _ => quiet u v su sv⟩

/-- Keeping in the strong form is keeping from some point on, along the whole line from `x`. -/
theorem «全守则后守» {R L E : «际» α} {x : α} (h : «全守» R L E x) : «后守» R L E x :=
  match h with
  | ⟨endless, y, hy, quiet⟩ =>
    ⟨fun z => «所及» R L x z, .inl rfl,
     fun z hz => match endless z hz with
       | ⟨w, c⟩ => ⟨w, «所及之传递» hz (.inr (.one c)), c⟩,
     y, hy, hy, fun u v _ _ hu c => quiet u v hu c⟩

/-- Keeping from some point on goes on along some branch. -/
theorem «后守则延» {R L E : «际» α} {x : α} (h : «后守» R L E x) : «延» R L x :=
  match h with
  | ⟨S, hx, closed, _⟩ => ⟨S, hx, closed⟩

/-- Keeping from some point on and degeneration exclude each other. -/
theorem «后守退化不并» {R L E : «际» α} {x : α} : ¬ («后守» R L E x ∧ «退化» R L x) :=
  fun ⟨k, d⟩ => «延尽不并» d («后守则延» k)

/-- **On a single line, generation and keeping from some point on exclude each other.** Where each
occurrence conditions at most one other, both families hold everything the line reaches, and a
renewal ahead of the point after which quiet lies cannot be. -/
theorem «单行则生成后守不并» {R L E : «际» α} (func : ∀ {z w w' : α}, R z w → R z w' → w = w')
    {x : α} : ¬ («生成» R L E x ∧ «后守» R L E x) := by
  intro ⟨⟨S₁, h₁, closed₁, ahead⟩, ⟨S₂, _, closed₂, z, hz, sz, none₂⟩⟩
  have s₁z : S₁ z := match hz with
    | .inl e => e ▸ h₁
    | .inr l => «单行则族含所及» (R := R) (L := L) func closed₁ h₁ l
  match ahead z s₁z with
  | ⟨u, v, _, _, hu, c⟩ =>
    have su : S₂ u := match hu with
      | .inl e => e ▸ sz
      | .inr l => «单行则族含所及» (R := R) (L := L) func closed₂ sz l
    have sv : S₂ v := «单行则族含所及» (R := R) (L := L) func closed₂ su (.one c.1)
    exact none₂ u v su sv hu c

/-- **With excluded middle the regions cover every point.** Every point is 生成, 后守 or 退化: where
it does not end on every branch, the points it reaches that do not are a family that goes on, and
either every member has a carrying renewal ahead within it or some member has quiet. -/
theorem «三域之周» (em : ∀ P : Prop, P ∨ ¬ P) (R L E : «际» α) (x : α) :
    «生成» R L E x ∨ «后守» R L E x ∨ «退化» R L x := by
  match em («尽» R L x) with
  | .inl d => exact .inr (.inr d)
  | .inr nd =>
    let S : α → Prop := fun z => ¬ «尽» R L z ∧ «所及» R L x z
    have closed : ∀ z, S z → ∃ w, S w ∧ «续» R L z w := fun z ⟨nz, hz⟩ =>
      match em (∃ w, ¬ «尽» R L w ∧ «续» R L z w) with
      | .inl ⟨w, nw, c⟩ => ⟨w, ⟨nw, «所及之传递» hz (.inr (.one c))⟩, c⟩
      | .inr quiet => absurd (.mk fun w c => match em («尽» R L w) with
          | .inl d => d
          | .inr nw => absurd ⟨w, nw, c⟩ quiet) nz
    have sx : S x := ⟨nd, .inl rfl⟩
    match em (∃ z, S z ∧ ∀ u v, S u → S v → «所及» R L z u → ¬ «传» R L E u v) with
    | .inl ⟨z, sz, quiet⟩ => exact .inr (.inl ⟨S, sx, closed, z, sz.2, sz, quiet⟩)
    | .inr nk =>
      refine .inl ⟨S, sx, closed, fun z sz => ?_⟩
      match em (∃ u v, S u ∧ S v ∧ «所及» R L z u ∧ «传» R L E u v) with
      | .inl a => exact a
      | .inr na => exact absurd ⟨z, sz, fun u v su sv hu c => na ⟨u, v, su, sv, hu, c⟩⟩ nk

/-- **Placing every point in one of the three regions is exactly excluded middle**, by the one-point
model whose relation is a proposition: the calibration of `«三域之周»`, as for going on and ending
(`«延尽之定当且仅当排中»`). -/
theorem «三域之定当且仅当排中» :
    (∀ (β : Type) (R L E : «际» β) (x : β), «生成» R L E x ∨ «后守» R L E x ∨ «退化» R L x) ↔
      ∀ P : Prop, P ∨ ¬ P := by
  constructor
  · intro h P
    have going : «延» (fun _ _ : Unit => P) «一» () → P := fun ⟨S, hx, hS⟩ =>
      match hS () hx with
      | ⟨_, _, c⟩ => c.1
    match h Unit (fun _ _ => P) «一» «一» () with
    | .inl g => exact .inl (going («生成则延» g))
    | .inr (.inl k) => exact .inl (going («后守则延» k))
    | .inr (.inr d) =>
      exact .inr fun hp => «延尽不并» d ⟨fun _ => True, trivial, fun _ _ => ⟨(), trivial, hp, trivial⟩⟩
  · intro em β R L E x
    exact «三域之周» em R L E x

end Regions

namespace Map

/-! ## The gap strict keeping leaves -/

/-- Three occurrences in a row: the first conditions the second, the second the third, and the
third itself. -/
inductive Stage | first | second | third

/-- The first conditions the second, the second the third, the third itself. -/
def once : «际» Stage
  | .first, .first => False
  | .first, .second => True
  | .first, .third => False
  | .second, .first => False
  | .second, .second => False
  | .second, .third => True
  | .third, .first => False
  | .third, .second => False
  | .third, .third => True

/-- Each occurrence conditions at most one other. -/
theorem Once.func : ∀ {z w w' : Stage}, once z w → once z w' → w = w' := by
  intro z w w' h h'
  cases z <;> cases w <;> cases w' <;> first | rfl | exact False.elim h | exact False.elim h'

/-- The pattern, under the one, renews from the first occurrence to the second: the second, under
identity, begins a part. -/
theorem Once.renews : «传» once «一» «静» .first .second :=
  ⟨⟨trivial, trivial⟩, fun ⟨a, h, e⟩ => by cases e; exact h⟩

/-- From the third occurrence no carrying renewal goes out: it conditions only itself. -/
theorem Once.third_not_renews (w : Stage) : ¬ «传» once «一» «静» .third w := by
  intro ⟨⟨h, _⟩, begins⟩
  cases w
  · exact h
  · exact h
  · exact begins ⟨.third, ⟨trivial, rfl⟩⟩

/-- The third occurrence conditions only itself. -/
theorem Once.third_next {w : Stage} (h : once .third w) : w = .third := by
  cases w
  · exact False.elim h
  · exact False.elim h
  · rfl

/-- What the line from the third occurrence reaches is the third. -/
theorem Once.stays_third : ∀ {x y : Stage}, «相续» once «一» x y → x = .third → y = .third := by
  intro x y l
  induction l with
  | one c => intro e; subst e; exact Once.third_next c.1
  | more c _ ih => intro e; subst e; exact ih (Once.third_next c.1)

/-- A family that holds the first occurrence and goes on holds the second and the third. -/
theorem Once.family {S : Stage → Prop} (s₁ : S .first)
    (closed : ∀ z, S z → ∃ w, S w ∧ «续» once «一» z w) : S .second ∧ S .third :=
  have s₂ : S .second := match closed .first s₁ with
    | ⟨w, sw, c⟩ => by
      cases w
      · exact False.elim c.1
      · exact sw
      · exact False.elim c.1
  have s₃ : S .third := match closed .second s₂ with
    | ⟨w, sw, c⟩ => by
      cases w
      · exact False.elim c.1
      · exact False.elim c.1
      · exact sw
  ⟨s₂, s₃⟩

/-- The pattern goes on from its first occurrence, `.first`. -/
theorem Once.endless : «不穷» once «一» .first := fun y _ => by
  cases y
  · exact ⟨.second, trivial, trivial⟩
  · exact ⟨.third, trivial, trivial⟩
  · exact ⟨.third, trivial, trivial⟩

/-- **The first occurrence is not generating**: every branch from it holds the third occurrence,
from which no carrying renewal lies ahead. -/
theorem Once.not_generates : ¬ «生成» once «一» «静» .first := by
  intro ⟨S, s₁, closed, ahead⟩
  match ahead .third (Once.family s₁ closed).2 with
  | ⟨u, v, _, _, hu, c⟩ =>
    have atThird : u = .third := match hu with
      | .inl e => e.symm
      | .inr l => Once.stays_third l rfl
    exact Once.third_not_renews v (atThird ▸ c)

/-- **The first occurrence is not keeping**: its only branch renews at once. -/
theorem Once.not_keeps : ¬ «守» once «一» «静» .first := by
  intro ⟨S, s₁, closed, quiet⟩
  exact quiet .first .second s₁ (Once.family s₁ closed).1 Once.renews

/-- **The first occurrence is not degenerating**: the third goes on for ever. -/
theorem Once.not_degenerates : ¬ «退化» once «一» .first :=
  fun d => «延尽不并» d («不穷则延» Once.endless)

/-- **The first occurrence keeps in the strong form**: the line never ends, and from the third
occurrence on no carrying renewal lies ahead. -/
theorem Once.keeping : «全守» once «一» «静» .first :=
  ⟨Once.endless, .third,
   .inr (.more (⟨trivial, trivial⟩ : «续» once «一» .first .second)
     (.one (⟨trivial, trivial⟩ : «续» once «一» .second .third))),
   fun _ w hz c => Once.third_not_renews w (match hz with
     | .inl e => e ▸ c
     | .inr l => (Once.stays_third l rfl) ▸ c)⟩

/-- **The first occurrence keeps from some point on**, though it renews before: the gap between
generating, keeping and degenerating that 后守 closes. -/
theorem Once.keepsAfter : «后守» once «一» «静» .first :=
  «全守则后守» Once.keeping

/-! ## Telling generation from keeping on a line -/

/-- Each step conditions only the next. -/
theorem step_func {z w w' : Nat} (h : step z w) (h' : step z w') : w = w' :=
  h.trans h'.symm

/-- A family of steps that holds at the first and goes on under the one holds at every step. -/
theorem step_family {S : Nat → Prop} (s₀ : S 0)
    (closed : ∀ z, S z → ∃ w, S w ∧ «续» step «一» z w) : ∀ m, S m := fun m =>
  match step_reaches m with
  | .inl e => e ▸ s₀
  | .inr l => «单行则族含所及» (R := step) (L := «一») step_func closed s₀ l

/-- **On a single line, 生成 at the first step, for the class of a sequence, is changing at
arbitrarily late steps.** -/
theorem generates_iff_changes (b : Nat → Bool) :
    «生成» step «一» (fun n m => b n = b m) 0 ↔ ∀ y, ∃ n, y ≤ n ∧ b n ≠ b (n + 1) :=
  ⟨fun ⟨_, s₀, closed, ahead⟩ y => match ahead y (step_family s₀ closed y) with
     | ⟨u, _, _, _, hu, c⟩ => ⟨u, step_reached_le hu, fun e =>
         c.2 ⟨u, c.1.1, Eq.subst (motive := fun v => b u = b v) c.1.1.symm e⟩⟩,
   fun changes => ⟨fun _ => True, trivial, fun z _ => ⟨z + 1, trivial, rfl, trivial⟩,
     fun z _ => match changes z with
       | ⟨n, le, ne⟩ => ⟨n, n + 1, trivial, trivial, step_reaches_of_le le, ⟨rfl, trivial⟩,
           fun ⟨_, hw, e⟩ => ne (Eq.subst (motive := fun k => b k = b (n + 1))
             (Nat.succ.inj hw).symm e)⟩⟩⟩

/-- **On a single line, 后守 at the first step, for the class of a sequence, is being constant from
some step on.** -/
theorem keepsAfter_iff_settles (b : Nat → Bool) :
    «后守» step «一» (fun n m => b n = b m) 0 ↔ ∃ z, ∀ n, z ≤ n → b n = b (n + 1) :=
  ⟨fun ⟨_, s₀, closed, z, _, _, quiet⟩ => ⟨z, fun n le =>
     match decEq (b n) (b (n + 1)) with
     | isTrue e => e
     | isFalse ne => absurd ⟨⟨rfl, trivial⟩, fun ⟨_, hw, e⟩ => ne (Eq.subst
         (motive := fun k => b k = b (n + 1)) (Nat.succ.inj hw).symm e)⟩
         (quiet n (n + 1) (step_family s₀ closed n) (step_family s₀ closed (n + 1))
           (step_reaches_of_le le))⟩,
   fun ⟨z, settles⟩ => ⟨fun _ => True, trivial, fun z _ => ⟨z + 1, trivial, rfl, trivial⟩,
     z, step_reaches z, trivial, fun u _ _ _ hu c =>
       c.2 ⟨u, c.1.1, Eq.subst (motive := fun w => b u = b w) c.1.1.symm
         (settles u (step_reached_le hu))⟩⟩⟩

namespace Settles

/-- Whether `p` has held at some step up to `n`. -/
def seen (p : Nat → Bool) : Nat → Bool
  | 0 => p 0
  | n + 1 => seen p n || p (n + 1)

/-- Alternation: true at the first step, then turning at every step. -/
def turning : Nat → Bool
  | 0 => true
  | n + 1 => !turning n

/-- A sequence that turns at every step until `p` first holds and stays after. -/
def sequence (p : Nat → Bool) (n : Nat) : Bool := cond (seen p n) false (turning n)

theorem seen_succ {p : Nat → Bool} {n : Nat} (h : seen p n = true) : seen p (n + 1) = true :=
  (congrArg (· || p (n + 1)) h).trans rfl

theorem seen_of_le {p : Nat → Bool} {n m : Nat} (h : seen p n = true) (le : n ≤ m) :
    seen p m = true := by
  induction le with
  | refl => exact h
  | step _ ih => exact seen_succ ih

theorem seen_of {p : Nat → Bool} : ∀ {n : Nat}, p n = true → seen p n = true
  | 0, h => h
  | n + 1, h => (congrArg (seen p n || ·) h).trans (Bool.or_true _)

theorem seen_witness {p : Nat → Bool} : ∀ {n : Nat}, seen p n = true → ∃ k, p k = true
  | 0, h => ⟨0, h⟩
  | n + 1, h => match hs : seen p n with
    | true => seen_witness hs
    | false => ⟨n + 1, (congrArg (· || p (n + 1)) hs).symm.trans h⟩

theorem sequence_seen {p : Nat → Bool} {n : Nat} (h : seen p n = true) : sequence p n = false :=
  (congrArg (fun c => cond c false (turning n)) h).trans rfl

theorem sequence_unseen {p : Nat → Bool} {n : Nat} (h : seen p n = false) :
    sequence p n = turning n :=
  (congrArg (fun c => cond c false (turning n)) h).trans rfl

theorem turning_turns (n : Nat) : turning n ≠ turning (n + 1) := by
  show turning n ≠ !turning n
  cases turning n
  · intro h; cases h
  · intro h; cases h

end Settles

open Settles in
/-- **Telling whether a line keeps from some point on is deciding whether it stops renewing.** Read
on the steps under the one with the class of the sequence that turns until `p` first holds, deciding
whether the first step keeps from some point on decides whether `p` ever holds: LPO for `p`. -/
theorem «后守之定则LPO» (p : Nat → Bool)
    (decided : «后守» step «一» (fun n m => sequence p n = sequence p m) 0 ∨
      ¬ «后守» step «一» (fun n m => sequence p n = sequence p m) 0) :
    (∃ n, p n = true) ∨ ∀ n, p n = false :=
  match decided with
  | .inl keeps => match (keepsAfter_iff_settles (sequence p)).mp keeps with
    | ⟨z, settles⟩ => .inl (match hs : seen p (z + 1) with
      | true => seen_witness hs
      | false =>
        have unseen : seen p z = false := match hz : seen p z with
          | true => Bool.noConfusion (hs.symm.trans (seen_succ hz))
          | false => rfl
        absurd ((sequence_unseen unseen).symm.trans ((settles z (Nat.le_refl z)).trans
          (sequence_unseen hs))) (turning_turns z))
  | .inr not_keeps => .inr fun n => match hp : p n with
    | false => rfl
    | true => absurd ((keepsAfter_iff_settles (sequence p)).mpr ⟨n, fun _ le =>
        (sequence_seen (seen_of_le (seen_of hp) le)).trans
          (sequence_seen (seen_of_le (seen_of hp) (Nat.le_succ_of_le le))).symm⟩) not_keeps

open Settles in
/-- **Deciding generation alone gives the weak form**: deciding whether the first step generates,
for the same sequence, decides whether `p` never holds or is not refuted to hold: WLPO for `p`. -/
theorem «生成之定则WLPO» (p : Nat → Bool)
    (decided : «生成» step «一» (fun n m => sequence p n = sequence p m) 0 ∨
      ¬ «生成» step «一» (fun n m => sequence p n = sequence p m) 0) :
    (∀ n, p n = false) ∨ ¬ ∀ n, p n = false :=
  match decided with
  | .inl generates => .inl fun n => match hp : p n with
    | false => rfl
    | true => match (generates_iff_changes (sequence p)).mp generates n with
      | ⟨_, le, ne⟩ => absurd ((sequence_seen (seen_of_le (seen_of hp) le)).trans
          (sequence_seen (seen_of_le (seen_of hp) (Nat.le_succ_of_le le))).symm) ne
  | .inr not_generates => .inr fun never => not_generates
      ((generates_iff_changes (sequence p)).mpr fun y =>
        have unseen : ∀ m, seen p m = false := fun m => match hs : seen p m with
          | true => match seen_witness hs with
            | ⟨k, hk⟩ => Bool.noConfusion (hk.symm.trans (never k))
          | false => rfl
        ⟨y, Nat.le_refl y, fun e => turning_turns y ((sequence_unseen (unseen y)).symm.trans
          (e.trans (sequence_unseen (unseen (y + 1)))))⟩)

/-- **Placing the first step in 生成 or 后守 for every sequence gives LPO**, through the single line,
where the two exclude each other. -/
theorem «生成后守之定则LPO»
    (decides : ∀ b : Nat → Bool,
      «生成» step «一» (fun n m => b n = b m) 0 ∨ «后守» step «一» (fun n m => b n = b m) 0)
    (p : Nat → Bool) : (∃ n, p n = true) ∨ ∀ n, p n = false :=
  «后守之定则LPO» p (match decides (Settles.sequence p) with
    | .inl generates => .inr fun keeps =>
        «单行则生成后守不并» (R := step) (L := «一») step_func ⟨generates, keeps⟩
    | .inr keeps => .inl keeps)

end Map

end Becoming
