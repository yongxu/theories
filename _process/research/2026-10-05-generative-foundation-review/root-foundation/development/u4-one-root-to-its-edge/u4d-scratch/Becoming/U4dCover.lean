import Becoming.GrammarLaws

/-! U4d scratch: the covering laws on the root. Not part of the package; checked outside it.
Names are working names; the package's names come from GrammarLaws' owner. -/

namespace Becoming

universe u

section U4dCover

variable {α : Type u}

/-! ### Lines from a list, on any relation -/

/-- Steps lie within the closure. -/
theorem U4d.closure_of_steps {C : «际» α} {n : Nat} {x y : α} (steps : «迭» C n x y) :
    «所闭» C x y :=
  «所闭当且仅当同一或及».mpr («迭则同一或及» n steps)

/-- The closure is reached by some number of steps. -/
theorem U4d.steps_of_closure {C : «际» α} {x y : α} (within : «所闭» C x y) :
    ∃ n, «迭» C n x y :=
  match «所闭当且仅当同一或及».mp within with
  | .inl same => ⟨0, same⟩
  | .inr reach => match «及即迭».mp reach with
    | ⟨n, steps⟩ => ⟨n + 1, steps⟩

/-- `n` steps from `a` lead to one occurrence, where two successors of an occurrence `a` reaches,
each leading to `y` or to `z`, are one. -/
theorem U4d.steps_unique {C : «际» α} : ∀ (n : Nat) {a y z : α},
    (∀ v b b', «所闭» C a v → («所闭» C b y ∨ «所闭» C b z) → («所闭» C b' y ∨ «所闭» C b' z) →
      C v b → C v b' → b = b') →
    «迭» C n a y → «迭» C n a z → y = z
  | 0, _, _, _, _, e₁, e₂ => Eq.trans (Eq.symm e₁) e₂
  | n + 1, a, _, z, fixed, ⟨w, c, rest⟩, ⟨w', c', rest'⟩ =>
    have same : w = w' := fixed a w w' («所闭之自反» C a) (.inl (U4d.closure_of_steps rest))
      (.inr (U4d.closure_of_steps rest')) c c'
    U4d.steps_unique n
      (fun v b b' within => fixed v b b' («所闭之传递» («缘在所闭» c) within)) rest
      (Eq.subst (motive := fun u => «迭» C n u z) same.symm rest')

theorem U4d.reorder (k d : Nat) : k + 1 + d = d + 1 + k :=
  (Nat.add_comm (k + 1) d).trans
    ((congrArg (d + ·) (Nat.add_comm 1 k)).symm.trans (Nat.add_assoc d 1 k).symm)

/-- What ends lies on no longer line from the same start, successors fixed as above. -/
theorem U4d.ends_before {C : «际» α} {k k' : Nat} {m x x' : α} (below : k < k')
    (fixed : ∀ v b b', «所闭» C m v → («所闭» C b x ∨ «所闭» C b x') →
      («所闭» C b' x ∨ «所闭» C b' x') → C v b → C v b' → b = b')
    (steps : «迭» C k m x) (steps' : «迭» C k' m x') (ends : ¬ ∃ w, C x w) : False :=
  match le_dest below with
  | ⟨d, more⟩ =>
    match «迭之分» k (b := d + 1)
        (Eq.subst (motive := fun j => «迭» C j m x') (more.trans (U4d.reorder k d)) steps') with
    | ⟨y, first, second⟩ =>
      have toX' : «所闭» C y x' := U4d.closure_of_steps second
      have same : x = y := U4d.steps_unique k
        (fun v b b' within before before' => fixed v b b' within
          (match before with
            | .inl toX => .inl toX
            | .inr toY => .inr («所闭之传递» toY toX'))
          (match before' with
            | .inl toX => .inl toX
            | .inr toY => .inr («所闭之传递» toY toX')))
        steps first
      match second with
      | ⟨w, c, _⟩ => ends ⟨w, Eq.subst (motive := fun v => C v w) same.symm c⟩

/-- **A line under fixed successors ends at most once.** Two occurrences that `m` reaches and that
end are one, where two successors of an occurrence `m` reaches, each leading to either, are one. -/
theorem U4d.one_end_rel {C : «际» α} {m x x' : α}
    (fixed : ∀ v b b', «所闭» C m v → («所闭» C b x ∨ «所闭» C b x') →
      («所闭» C b' x ∨ «所闭» C b' x') → C v b → C v b' → b = b')
    (reach : «所闭» C m x) (reach' : «所闭» C m x')
    (ends : ¬ ∃ w, C x w) (ends' : ¬ ∃ w, C x' w) : x = x' :=
  match U4d.steps_of_closure reach, U4d.steps_of_closure reach' with
  | ⟨k, steps⟩, ⟨k', steps'⟩ =>
    match Nat.lt_or_ge k k' with
    | .inl below => (U4d.ends_before below fixed steps steps' ends).elim
    | .inr above => match Nat.eq_or_lt_of_le above with
      | .inl same => U4d.steps_unique k fixed steps
          (Eq.subst (motive := fun j => «迭» C j m x') same steps')
      | .inr beyond => (U4d.ends_before beyond
          (fun v b b' within before before' => fixed v b b' within before.symm before'.symm)
          steps' steps ends').elim

/-- **The count of ends on lines from a list, on any relation.** Occurrences listed once, each
ending and each within the closure of a member of a list, where two successors of an occurrence a
member reaches, each leading to a listed ending, are one: no more of them than members. No decision
is used. -/
theorem U4d.ends_le_rel {C : «际» α} {L D : List α} (dD : Distinct D)
    (fixed : ∀ v b b', (∃ m, m ∈ L ∧ «所闭» C m v) →
      (∃ x, x ∈ D ∧ «所闭» C b x) → (∃ x, x ∈ D ∧ «所闭» C b' x) → C v b → C v b' → b = b')
    (reached : ∀ x, x ∈ D → ∃ m, m ∈ L ∧ «所闭» C m x)
    (ends : ∀ x, x ∈ D → ¬ ∃ w, C x w) : D.length ≤ L.length :=
  length_le_of_matched (S := fun x m => m ∈ L ∧ «所闭» C m x) dD
    (fun x mx => match reached x mx with
      | ⟨m, mm, r⟩ => ⟨m, mm, mm, r⟩)
    fun x x' m mx mx' ⟨mm, r⟩ ⟨_, r'⟩ =>
      U4d.one_end_rel (fun v b b' within before before' => fixed v b b' ⟨m, mm, within⟩
          (match before with
            | .inl toX => ⟨x, mx, toX⟩
            | .inr toX' => ⟨x', mx', toX'⟩)
          (match before' with
            | .inl toX => ⟨x, mx, toX⟩
            | .inr toX' => ⟨x', mx', toX'⟩))
        r r' (ends x mx) (ends x' mx')

/-- The same where each ending's being reached from the list is only not refuted: the count is
decidable, so the double negation lifts. -/
theorem U4d.ends_le_rel_unrefuted {C : «际» α} {L D : List α} (dD : Distinct D)
    (fixed : ∀ v b b', (∃ m, m ∈ L ∧ «所闭» C m v) →
      (∃ x, x ∈ D ∧ «所闭» C b x) → (∃ x, x ∈ D ∧ «所闭» C b' x) → C v b → C v b' → b = b')
    (reached : ∀ x, x ∈ D → ¬¬ ∃ m, m ∈ L ∧ «所闭» C m x)
    (ends : ∀ x, x ∈ D → ¬ ∃ w, C x w) : D.length ≤ L.length :=
  match Nat.decLe D.length L.length with
  | isTrue within => within
  | isFalse beyond => absurd (fun all => beyond (U4d.ends_le_rel dD fixed all ends))
      (not_not_all reached)

/-! ### The count on the grammar, and its mirror -/

variable {R E : «际» α}

/-- **Endings on lines from a list number at most the list.** -/
theorem U4d.ends_le {L D : List α} (dD : Distinct D)
    (fixed : ∀ v b b', (∃ m, m ∈ L ∧ «所闭» («续» R E) m v) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) b x) → (∃ x, x ∈ D ∧ «所闭» («续» R E) b' x) →
      «续» R E v b → «续» R E v b' → b = b')
    (reached : ∀ x, x ∈ D → ∃ m, m ∈ L ∧ «所闭» («续» R E) m x)
    (ends : ∀ x, x ∈ D → «亡» R E x) : D.length ≤ L.length :=
  U4d.ends_le_rel dD fixed reached ends

/-- The count where reaching is only not refuted. -/
theorem U4d.ends_le_unrefuted {L D : List α} (dD : Distinct D)
    (fixed : ∀ v b b', (∃ m, m ∈ L ∧ «所闭» («续» R E) m v) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) b x) → (∃ x, x ∈ D ∧ «所闭» («续» R E) b' x) →
      «续» R E v b → «续» R E v b' → b = b')
    (reached : ∀ x, x ∈ D → ¬¬ ∃ m, m ∈ L ∧ «所闭» («续» R E) m x)
    (ends : ∀ x, x ∈ D → «亡» R E x) : D.length ≤ L.length :=
  U4d.ends_le_rel_unrefuted dD fixed reached ends

/-- **Its mirror: beginnings on lines to a list number at most the list**, the same law at the
converse, nothing merging where it matters. -/
theorem U4d.begins_le {L D : List α} (dD : Distinct D)
    (merges : ∀ v a a', (∃ m, m ∈ L ∧ «所闭» («续» R E) v m) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) x a) → (∃ x, x ∈ D ∧ «所闭» («续» R E) x a') →
      «续» R E a v → «续» R E a' v → a = a')
    (reaching : ∀ x, x ∈ D → ∃ m, m ∈ L ∧ «所闭» («续» R E) x m)
    (begins : ∀ x, x ∈ D → «生» R E x) : D.length ≤ L.length :=
  U4d.ends_le_rel (C := «逆» («续» R E)) dD
    (fun v a a' ⟨m, mm, within⟩ ⟨x, mx, toX⟩ ⟨x', mx', toX'⟩ => merges v a a'
      ⟨m, mm, «所闭之逆».mp within⟩ ⟨x, mx, «所闭之逆».mp toX⟩ ⟨x', mx', «所闭之逆».mp toX'⟩)
    (fun x mx => match reaching x mx with
      | ⟨m, mm, r⟩ => ⟨m, mm, «所闭之逆».mpr r⟩)
    begins

/-- The mirror where reaching is only not refuted. -/
theorem U4d.begins_le_unrefuted {L D : List α} (dD : Distinct D)
    (merges : ∀ v a a', (∃ m, m ∈ L ∧ «所闭» («续» R E) v m) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) x a) → (∃ x, x ∈ D ∧ «所闭» («续» R E) x a') →
      «续» R E a v → «续» R E a' v → a = a')
    (reaching : ∀ x, x ∈ D → ¬¬ ∃ m, m ∈ L ∧ «所闭» («续» R E) x m)
    (begins : ∀ x, x ∈ D → «生» R E x) : D.length ≤ L.length :=
  U4d.ends_le_rel_unrefuted (C := «逆» («续» R E)) dD
    (fun v a a' ⟨m, mm, within⟩ ⟨x, mx, toX⟩ ⟨x', mx', toX'⟩ => merges v a a'
      ⟨m, mm, «所闭之逆».mp within⟩ ⟨x, mx, «所闭之逆».mp toX⟩ ⟨x', mx', «所闭之逆».mp toX'⟩)
    (fun x mx no => reaching x mx fun ⟨m, mm, r⟩ => no ⟨m, mm, «所闭之逆».mpr r⟩)
    begins

/-! ### Run forms on a stage map -/

section Run

variable {τ : α → Nat} {here : α → Prop}

/-- The stage grows by the number of steps. -/
theorem U4d.stage_steps (stage : ∀ x y, «续» R E x y → τ y = τ x + 1) :
    ∀ (n : Nat) {x y : α}, «迭» («续» R E) n x y → τ y = τ x + n
  | 0, _, _, same => Eq.symm (congrArg τ same)
  | n + 1, x, _, ⟨w, c, rest⟩ =>
    (U4d.stage_steps stage n rest).trans
      ((congrArg (· + n) (stage x w c)).trans (Nat.succ_add (τ x) n))

/-- What holds where a line leads held where it started, where it holds back along each step. -/
theorem U4d.keeps_back (keeps : ∀ x y, «续» R E x y → here y → here x) {x y : α}
    (within : «所闭» («续» R E) x y) : here y → here x :=
  within (fun z => here z → here x) (fun a b back c hb => back (keeps a b c hb)) id

/-- Forward, where it holds on along each step. -/
theorem U4d.keeps_on (keepsOn : ∀ x y, «续» R E x y → here x → here y) {x y : α}
    (within : «所闭» («续» R E) x y) (h : here x) : here y :=
  within here (fun a b ha c => keepsOn a b c ha) h

/-- No unit continuing as two units fixes successors on the lines to listed units. -/
theorem U4d.fixed_of_noSplit (keeps : ∀ x y, «续» R E x y → here y → here x)
    (noSplit : ∀ v b b', here b → here b' → «续» R E v b → «续» R E v b' → b = b')
    {L D : List α} (inD : ∀ x, x ∈ D → here x) :
    ∀ v b b', (∃ m, m ∈ L ∧ «所闭» («续» R E) m v) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) b x) → (∃ x, x ∈ D ∧ «所闭» («续» R E) b' x) →
      «续» R E v b → «续» R E v b' → b = b' :=
  fun v b b' _ ⟨x, mx, toX⟩ ⟨x', mx', toX'⟩ =>
    noSplit v b b' (U4d.keeps_back keeps toX (inD x mx)) (U4d.keeps_back keeps toX' (inD x' mx'))

/-- Any number of marked units at distinct stages from `M`, all before some stage. -/
theorem U4d.found_cons {marks : α → Prop} {M U : Nat} {x : α} {D : List α}
    (from_ : M ≤ U) (later : U ≤ τ x) (mx : marks x) (dD : Distinct D)
    (all : ∀ y, y ∈ D → M ≤ τ y ∧ τ y < U ∧ marks y) :
    Distinct (x :: D) ∧ M ≤ τ x + 1 ∧ ∀ y, y ∈ x :: D → M ≤ τ y ∧ τ y < τ x + 1 ∧ marks y :=
  ⟨⟨fun mem => Nat.lt_irrefl (τ x) (Nat.lt_of_lt_of_le (all x mem).2.1 later), dD⟩,
   Nat.le_trans from_ (Nat.le_trans later (Nat.le_succ _)),
   fun y mem => match ListTests.mem_cons_iff.mp mem with
    | .inl same => Eq.subst (motive := fun v => M ≤ τ v ∧ τ v < τ x + 1 ∧ marks v) same.symm
        ⟨Nat.le_trans from_ later, Nat.lt_succ_self _, mx⟩
    | .inr mem => ⟨(all y mem).1,
        Nat.lt_of_lt_of_le (all y mem).2.1 (Nat.le_trans later (Nat.le_succ _)), (all y mem).2.2⟩⟩

/-- Units marked at arbitrarily late stages give any number of them at distinct stages from any
stage, all before some stage. -/
theorem U4d.found {marks : α → Prop} (each : ∀ M, ∃ x, M ≤ τ x ∧ marks x) :
    ∀ n M, ∃ D : List α, ∃ U, Distinct D ∧ D.length = n ∧ M ≤ U ∧
      ∀ x, x ∈ D → M ≤ τ x ∧ τ x < U ∧ marks x
  | 0, M => ⟨[], M, trivial, rfl, Nat.le_refl M, fun _ mem => nomatch mem⟩
  | n + 1, M => match U4d.found each n M with
    | ⟨D, U, dD, len, from_, all⟩ => match each U with
      | ⟨x, later, mx⟩ => match U4d.found_cons from_ later mx dD all with
        | ⟨dD', from_', all'⟩ => ⟨x :: D, τ x + 1, dD', congrArg Nat.succ len, from_', all'⟩

/-- The same where after every stage a later marked unit is only not refuted. -/
theorem U4d.found_unrefuted {marks : α → Prop} (each : ∀ M, ¬¬ ∃ x, M ≤ τ x ∧ marks x) :
    ∀ n M, ¬¬ ∃ D : List α, ∃ U, Distinct D ∧ D.length = n ∧ M ≤ U ∧
      ∀ x, x ∈ D → M ≤ τ x ∧ τ x < U ∧ marks x
  | 0, M => fun no => no ⟨[], M, trivial, rfl, Nat.le_refl M, fun _ mem => nomatch mem⟩
  | n + 1, M => fun no => U4d.found_unrefuted each n M fun ⟨D, U, dD, len, from_, all⟩ =>
    each U fun ⟨x, later, mx⟩ => match U4d.found_cons from_ later mx dD all with
      | ⟨dD', from_', all'⟩ => no ⟨x :: D, τ x + 1, dD', congrArg Nat.succ len, from_', all'⟩

/-- Found once, or found for every member of a list. -/
theorem U4d.found_or_all {A : Prop} {B : α → Prop} :
    ∀ {D : List α}, (∀ x, x ∈ D → A ∨ B x) → A ∨ ∀ x, x ∈ D → B x
  | [], _ => .inr fun _ mem => nomatch mem
  | x :: D, each => match each x (.head D) with
    | .inl a => .inl a
    | .inr bx => match U4d.found_or_all (D := D) (fun y mem => each y (.tail x mem)) with
      | .inl a => .inl a
      | .inr all => .inr fun y mem => match ListTests.mem_cons_iff.mp mem with
        | .inl same => Eq.subst (motive := B) same.symm bx
        | .inr mem => all y mem

/-- **Tracing back, decided.** A unit `k` stages after `N`, beginning or predecessor decided: a
beginning after `N`, or the line from a member of a list covering the units at `N`. -/
theorem U4d.trace (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (keeps : ∀ x y, «续» R E x y → here y → here x)
    {N : Nat} {L : List α} (covers : ∀ x, here x → τ x = N → x ∈ L)
    (decided : ∀ y, here y → «生» R E y ∨ «有前» R E y) :
    ∀ k y, here y → τ y = N + k →
      (∃ z, N < τ z ∧ here z ∧ «生» R E z) ∨ ∃ m, m ∈ L ∧ «所闭» («续» R E) m y
  | 0, y, h, at_ => .inr ⟨y, covers y h at_, «所闭之自反» _ y⟩
  | k + 1, y, h, at_ =>
    have late : N < τ y := Eq.subst (motive := (N < ·)) at_.symm
      (Nat.lt_succ_of_le (Nat.le_add_right N k))
    match decided y h with
    | .inl b => .inl ⟨y, late, h, b⟩
    | .inr ⟨x, c⟩ =>
      match U4d.trace stage keeps covers decided k x (keeps x y c h)
          (Nat.succ.inj ((stage x y c).symm.trans at_)) with
      | .inl found => .inl found
      | .inr ⟨m, mm, r⟩ => .inr ⟨m, mm, «所闭之传递» r («缘在所闭» c)⟩

/-- **Tracing back, undecided.** Where nothing begins after `N` up to its stage, a unit's line from
a member of a list covering the units at `N` is not refuted. -/
theorem U4d.trace_unrefuted (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (keeps : ∀ x y, «续» R E x y → here y → here x)
    {N : Nat} {L : List α} (covers : ∀ x, here x → τ x = N → x ∈ L) :
    ∀ k y, here y → τ y = N + k →
      (∀ z, here z → N < τ z → τ z ≤ N + k → ¬ «生» R E z) →
      ¬¬ ∃ m, m ∈ L ∧ «所闭» («续» R E) m y
  | 0, y, h, at_, _ => fun no => no ⟨y, covers y h at_, «所闭之自反» _ y⟩
  | k + 1, y, h, at_, quiet => fun no =>
    quiet y h (Eq.subst (motive := (N < ·)) at_.symm (Nat.lt_succ_of_le (Nat.le_add_right N k)))
      (Nat.le_of_eq at_) fun ⟨x, c⟩ =>
      U4d.trace_unrefuted stage keeps covers k x (keeps x y c h)
        (Nat.succ.inj ((stage x y c).symm.trans at_))
        (fun z hz late upto => quiet z hz late (Nat.le_succ_of_le upto))
        fun ⟨m, mm, r⟩ => no ⟨m, mm, «所闭之传递» r («缘在所闭» c)⟩

/-- **The covering law on the root, decided, from one list.** Units at stages, each step of the
continuation one stage on, what holds of a unit holding of its predecessors; a list covering the
units at stage `N`; no unit continuing as two units; beginning or predecessor decided. Where endings
recur, something begins after `N`. -/
theorem U4d.cover_from (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (keeps : ∀ x y, «续» R E x y → here y → here x)
    (noSplit : ∀ v b b', here b → here b' → «续» R E v b → «续» R E v b' → b = b')
    {N : Nat} {L : List α} (covers : ∀ x, here x → τ x = N → x ∈ L)
    (decided : ∀ y, here y → «生» R E y ∨ «有前» R E y)
    (ending : ∀ M, ∃ x, M ≤ τ x ∧ here x ∧ «亡» R E x) :
    ∃ y, N < τ y ∧ here y ∧ «生» R E y :=
  match U4d.found (marks := fun x => here x ∧ «亡» R E x) ending (L.length + 1) N with
  | ⟨_, _, dD, len, _, all⟩ =>
    match U4d.found_or_all (A := ∃ z, N < τ z ∧ here z ∧ «生» R E z)
        (B := fun x => ∃ m, m ∈ L ∧ «所闭» («续» R E) m x)
        (fun x mx => match le_dest (all x mx).1 with
          | ⟨k, at_⟩ => U4d.trace stage keeps covers decided k x (all x mx).2.2.1 at_) with
    | .inl found => found
    | .inr reached => (Nat.not_succ_le_self L.length (Nat.le_trans (Nat.le_of_eq len.symm)
        (U4d.ends_le dD (U4d.fixed_of_noSplit keeps noSplit fun x mx => (all x mx).2.2.1)
          reached fun x mx => (all x mx).2.2.2))).elim

/-- **The covering law on the root, decided.** With lists covering the units at arbitrarily late
stages, where endings recur, beginnings recur. -/
theorem U4d.cover_run (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (keeps : ∀ x y, «续» R E x y → here y → here x)
    (noSplit : ∀ v b b', here b → here b' → «续» R E v b → «续» R E v b' → b = b')
    (covered : ∀ M, ∃ N, ∃ L : List α, M ≤ N ∧ ∀ x, here x → τ x = N → x ∈ L)
    (decided : ∀ y, here y → «生» R E y ∨ «有前» R E y)
    (ending : ∀ M, ∃ x, M ≤ τ x ∧ here x ∧ «亡» R E x) :
    ∀ M, ∃ y, M < τ y ∧ here y ∧ «生» R E y :=
  fun M => match covered M with
  | ⟨_, _, later, covers⟩ => match U4d.cover_from stage keeps noSplit covers decided ending with
    | ⟨z, late, h, b⟩ => ⟨z, Nat.lt_of_le_of_lt later late, h, b⟩

/-- **The covering law on the root, undecided.** With a list covering the units at `N` and endings
at arbitrarily late stages each not refuted, a beginning after `N` is not refuted. -/
theorem U4d.cover_unrefuted (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (keeps : ∀ x y, «续» R E x y → here y → here x)
    (noSplit : ∀ v b b', here b → here b' → «续» R E v b → «续» R E v b' → b = b')
    {N : Nat} {L : List α} (covers : ∀ x, here x → τ x = N → x ∈ L)
    (ending : ∀ M, ¬¬ ∃ x, M ≤ τ x ∧ here x ∧ «亡» R E x) :
    ¬¬ ∃ y, N < τ y ∧ here y ∧ «生» R E y :=
  fun none => U4d.found_unrefuted (marks := fun x => here x ∧ «亡» R E x) ending (L.length + 1) N
    fun ⟨_, _, dD, len, _, all⟩ =>
    Nat.not_succ_le_self L.length (Nat.le_trans (Nat.le_of_eq len.symm)
      (U4d.ends_le_unrefuted dD (U4d.fixed_of_noSplit keeps noSplit fun x mx => (all x mx).2.2.1)
        (fun x mx => match le_dest (all x mx).1 with
          | ⟨k, at_⟩ => U4d.trace_unrefuted stage keeps covers k x (all x mx).2.2.1 at_
              fun z hz late _ b => none ⟨z, late, hz, b⟩)
        fun x mx => (all x mx).2.2.2))

/-- **So beginnings never stop**, where lists cover the units at arbitrarily late stages and
endings recur as far as can be refuted. -/
theorem U4d.cover_never_stops (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (keeps : ∀ x y, «续» R E x y → here y → here x)
    (noSplit : ∀ v b b', here b → here b' → «续» R E v b → «续» R E v b' → b = b')
    (covered : ∀ M, ∃ N, ∃ L : List α, M ≤ N ∧ ∀ x, here x → τ x = N → x ∈ L)
    (ending : ∀ M, ¬¬ ∃ x, M ≤ τ x ∧ here x ∧ «亡» R E x) :
    ¬ ∃ M, ∀ y, M < τ y → here y → ¬ «生» R E y :=
  fun ⟨M, quiet⟩ => match covered M with
  | ⟨_, _, later, covers⟩ => U4d.cover_unrefuted stage keeps noSplit covers ending
      fun ⟨y, late, h, b⟩ => quiet y (Nat.lt_of_le_of_lt later late) h b

/-- Forward: with nothing ending from `N` on, a unit at a stage from `N` has `k` steps after it,
as far as can be refuted. -/
theorem U4d.onward_unrefuted (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (keepsOn : ∀ x y, «续» R E x y → here x → here y)
    {N : Nat} (quiet : ∀ x, N ≤ τ x → here x → ¬ «亡» R E x)
    {x : α} (from_ : N ≤ τ x) (h : here x) : ∀ k, ¬¬ ∃ y, «迭» («续» R E) k x y :=
  fun k => «或有后则或迭» k fun j y _ steps =>
    quiet y (Nat.le_trans from_ (Eq.subst (motive := (τ x ≤ ·))
        (U4d.stage_steps stage j steps).symm (Nat.le_add_right _ _)))
      (U4d.keeps_on keepsOn (U4d.closure_of_steps steps) h)

/-- **The converse.** Lists of at most `K` covering the units at every stage from `T`, what holds of
a unit holding of its successors, no two units continuing as one, beginnings at arbitrarily late
stages: endings never stop. -/
theorem U4d.cover_converse (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (keepsOn : ∀ x y, «续» R E x y → here x → here y)
    (noMerge : ∀ v a a', here a → here a' → «续» R E a v → «续» R E a' v → a = a')
    {K T : Nat}
    (bounded : ∀ S, T ≤ S → ∃ L : List α, L.length ≤ K ∧ ∀ x, here x → τ x = S → x ∈ L)
    (beginning : ∀ M, ∃ x, M ≤ τ x ∧ here x ∧ «生» R E x) :
    ¬ ∃ N, ∀ x, N ≤ τ x → here x → ¬ «亡» R E x :=
  fun ⟨N, quiet⟩ =>
    match U4d.found (marks := fun x => here x ∧ «生» R E x) beginning (K + 1) (N + T) with
    | ⟨_, U, dD, len, from_, all⟩ => match bounded U (Nat.le_trans (Nat.le_add_left T N) from_) with
      | ⟨_, short, covers⟩ => Nat.not_succ_le_self K (Nat.le_trans (Nat.le_of_eq len.symm)
          (Nat.le_trans (U4d.begins_le_unrefuted dD
            (fun v a a' _ ⟨x, mx, toA⟩ ⟨x', mx', toA'⟩ => noMerge v a a'
              (U4d.keeps_on keepsOn toA (all x mx).2.2.1)
              (U4d.keeps_on keepsOn toA' (all x' mx').2.2.1))
            (fun x mx no => match le_dest (Nat.le_of_lt (all x mx).2.1) with
              | ⟨k, at_⟩ => U4d.onward_unrefuted stage keepsOn quiet
                  (Nat.le_trans (Nat.le_add_right N T) (all x mx).1) (all x mx).2.2.1 k
                  fun ⟨y, steps⟩ => no ⟨y, covers y
                    (U4d.keeps_on keepsOn (U4d.closure_of_steps steps) (all x mx).2.2.1)
                    ((U4d.stage_steps stage k steps).trans at_.symm),
                    U4d.closure_of_steps steps⟩)
            fun x mx => (all x mx).2.2.2) short))

/-- **Tracing on, decided.** From a unit here at a stage from `N`, ending or successor decided:
an ending from `N` on, or `k` steps. -/
theorem U4d.trace_on (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (keepsOn : ∀ x y, «续» R E x y → here x → here y) {N : Nat}
    (decided : ∀ x, here x → «亡» R E x ∨ «有后» R E x) :
    ∀ k x, here x → N ≤ τ x →
      (∃ z, N ≤ τ z ∧ here z ∧ «亡» R E z) ∨ ∃ y, «迭» («续» R E) k x y
  | 0, x, _, _ => .inr ⟨x, rfl⟩
  | k + 1, x, h, from_ => match decided x h with
    | .inl en => .inl ⟨x, from_, h, en⟩
    | .inr ⟨w, c⟩ =>
      match U4d.trace_on stage keepsOn decided k w (keepsOn x w c h)
          (Nat.le_trans from_ (Nat.le_of_lt (Eq.subst (motive := (τ x < ·)) (stage x w c).symm
            (Nat.lt_succ_self _)))) with
      | .inl found => .inl found
      | .inr ⟨y, steps⟩ => .inr ⟨y, w, c, steps⟩

/-- **The converse, decided.** With ending or successor decided, beginnings recurring need
endings recurring. -/
theorem U4d.cover_converse_run (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (keepsOn : ∀ x y, «续» R E x y → here x → here y)
    (noMerge : ∀ v a a', here a → here a' → «续» R E a v → «续» R E a' v → a = a')
    {K T : Nat}
    (bounded : ∀ S, T ≤ S → ∃ L : List α, L.length ≤ K ∧ ∀ x, here x → τ x = S → x ∈ L)
    (decided : ∀ x, here x → «亡» R E x ∨ «有后» R E x)
    (beginning : ∀ M, ∃ x, M ≤ τ x ∧ here x ∧ «生» R E x) :
    ∀ N, ∃ x, N ≤ τ x ∧ here x ∧ «亡» R E x :=
  fun N =>
    match U4d.found (marks := fun x => here x ∧ «生» R E x) beginning (K + 1) (N + T) with
    | ⟨D, U, dD, len, from_, all⟩ => match bounded U (Nat.le_trans (Nat.le_add_left T N) from_) with
      | ⟨L, short, covers⟩ =>
        match U4d.found_or_all (A := ∃ z, N ≤ τ z ∧ here z ∧ «亡» R E z)
            (B := fun x => ∃ m, m ∈ L ∧ «所闭» («续» R E) x m) (D := D)
            (fun x mx => match le_dest (Nat.le_of_lt (all x mx).2.1) with
              | ⟨k, at_⟩ => match U4d.trace_on stage keepsOn decided k x (all x mx).2.2.1
                  (Nat.le_trans (Nat.le_add_right N T) (all x mx).1) with
                | .inl found => .inl found
                | .inr ⟨y, steps⟩ => .inr ⟨y, covers y
                    (U4d.keeps_on keepsOn (U4d.closure_of_steps steps) (all x mx).2.2.1)
                    ((U4d.stage_steps stage k steps).trans at_.symm),
                    U4d.closure_of_steps steps⟩) with
        | .inl found => found
        | .inr reaching => (Nat.not_succ_le_self K (Nat.le_trans (Nat.le_of_eq len.symm)
            (Nat.le_trans (U4d.begins_le dD
              (fun v a a' _ ⟨x, mx, toA⟩ ⟨x', mx', toA'⟩ => noMerge v a a'
                (U4d.keeps_on keepsOn toA (all x mx).2.2.1)
                (U4d.keeps_on keepsOn toA' (all x' mx').2.2.1))
              reaching fun x mx => (all x mx).2.2.2) short))).elim

end Run

end U4dCover

end Becoming
