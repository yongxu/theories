import Becoming.GrammarLaws

/-! U4d scratch: the covering laws on the root. Not part of the package; checked outside it.
Names are working names; the package's names come from GrammarLaws' owner.

Revised after the review (`REVIEW-U4D.md`): the region `P` (the units) is stated with the grammar's
closed regions (`«闭»`), nothing outside it continuing into it, and for the converse nothing in it
continuing out; the decisions are asked only after the list's stage; the stretch form and its mirror
are laws, the run forms and the census of a run go through them. -/

namespace Becoming

universe u

section U4dCover

variable {α : Type u}

/-! ### Lines from a list, on any relation -/

/-- **The closure is some number of steps.** -/
theorem U4d.closure_iff_steps {C : «际» α} {x y : α} : «所闭» C x y ↔ ∃ n, «迭» C n x y :=
  ⟨fun within => match «所闭当且仅当同一或及».mp within with
    | .inl same => ⟨0, same⟩
    | .inr reach => match «及即迭».mp reach with
      | ⟨n, steps⟩ => ⟨n + 1, steps⟩,
   fun ⟨n, steps⟩ => «所闭当且仅当同一或及».mpr («迭则同一或及» n steps)⟩

/-- `n` steps from `a` lead to one occurrence, where two successors of an occurrence `a` reaches,
each leading to `y` or to `z`, are one. -/
theorem U4d.steps_unique {C : «际» α} : ∀ (n : Nat) {a y z : α},
    (∀ v b b', «所闭» C a v → («所闭» C b y ∨ «所闭» C b z) → («所闭» C b' y ∨ «所闭» C b' z) →
      C v b → C v b' → b = b') →
    «迭» C n a y → «迭» C n a z → y = z
  | 0, _, _, _, _, e₁, e₂ => Eq.trans (Eq.symm e₁) e₂
  | n + 1, a, _, z, fixed, ⟨w, c, rest⟩, ⟨w', c', rest'⟩ =>
    have same : w = w' := fixed a w w' («所闭之自反» C a)
      (.inl (U4d.closure_iff_steps.mpr ⟨n, rest⟩)) (.inr (U4d.closure_iff_steps.mpr ⟨n, rest'⟩)) c c'
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
      have toX' : «所闭» C y x' := U4d.closure_iff_steps.mpr ⟨_, second⟩
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
  match U4d.closure_iff_steps.mp reach, U4d.closure_iff_steps.mp reach' with
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

/-! ### Forms on a stage map

The units are occurrences at stages: a region `P`, each step of the continuation one stage on
(`τ y = τ x + 1`), so no occurrence continues itself. -/

section Run

variable {τ : α → Nat} {P : α → Prop}

/-- The stage grows by the number of steps. -/
theorem U4d.stage_steps (stage : ∀ x y, «续» R E x y → τ y = τ x + 1) :
    ∀ (n : Nat) {x y : α}, «迭» («续» R E) n x y → τ y = τ x + n
  | 0, _, _, same => Eq.symm (congrArg τ same)
  | n + 1, x, _, ⟨w, c, rest⟩ =>
    (U4d.stage_steps stage n rest).trans
      ((congrArg (· + n) (stage x w c)).trans (Nat.succ_add (τ x) n))

/-- In a region nothing outside continues into, no occurrence continuing as two units fixes
successors on the lines to listed units. -/
theorem U4d.fixed_of_noSplit (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    {L D : List α} (inD : ∀ x, x ∈ D → P x) :
    ∀ v b b', (∃ m, m ∈ L ∧ «所闭» («续» R E) m v) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) b x) → (∃ x, x ∈ D ∧ «所闭» («续» R E) b' x) →
      «续» R E v b → «续» R E v b' → b = b' :=
  fun v b b' _ ⟨x, mx, toX⟩ ⟨x', mx', toX'⟩ =>
    noSplit v b b' («闭含所闭» back (inD x mx) («所闭之逆».mpr toX))
      («闭含所闭» back (inD x' mx') («所闭之逆».mpr toX'))

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

/-! #### Back along the lines: endings need beginnings -/

/-- **Tracing back, decided.** A unit `k` stages after `N`, beginning or predecessor decided after
`N`: a beginning after `N`, or the line from a member of a list covering the units at `N`. -/
theorem U4d.trace (stage : ∀ x y, «续» R E x y → τ y = τ x + 1) (back : «闭» («逆» («续» R E)) P)
    {N : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L)
    (decided : ∀ y, P y → N < τ y → «生» R E y ∨ «有前» R E y) :
    ∀ k y, P y → τ y = N + k →
      (∃ z, N < τ z ∧ P z ∧ «生» R E z) ∨ ∃ m, m ∈ L ∧ «所闭» («续» R E) m y
  | 0, y, h, at_ => .inr ⟨y, covers y h at_, «所闭之自反» _ y⟩
  | k + 1, y, h, at_ =>
    have late : N < τ y := Eq.subst (motive := (N < ·)) at_.symm
      (Nat.lt_succ_of_le (Nat.le_add_right N k))
    match decided y h late with
    | .inl b => .inl ⟨y, late, h, b⟩
    | .inr ⟨x, c⟩ =>
      match U4d.trace stage back covers decided k x (back y x h c)
          (Nat.succ.inj ((stage x y c).symm.trans at_)) with
      | .inl found => .inl found
      | .inr ⟨m, mm, r⟩ => .inr ⟨m, mm, «所闭之传递» r («缘在所闭» c)⟩

/-- **Tracing back, undecided.** Where nothing begins after `N` up to its stage, a unit's line from
a member of a list covering the units at `N` is not refuted. -/
theorem U4d.trace_unrefuted (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    {N : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L) :
    ∀ k y, P y → τ y = N + k →
      (∀ z, P z → N < τ z → τ z ≤ N + k → ¬ «生» R E z) →
      ¬¬ ∃ m, m ∈ L ∧ «所闭» («续» R E) m y
  | 0, y, h, at_, _ => fun no => no ⟨y, covers y h at_, «所闭之自反» _ y⟩
  | k + 1, y, h, at_, quiet => fun no =>
    quiet y h (Eq.subst (motive := (N < ·)) at_.symm (Nat.lt_succ_of_le (Nat.le_add_right N k)))
      (Nat.le_of_eq at_) fun ⟨x, c⟩ =>
      U4d.trace_unrefuted stage back covers k x (back y x h c)
        (Nat.succ.inj ((stage x y c).symm.trans at_))
        (fun z hz late upto => quiet z hz late (Nat.le_succ_of_le upto))
        fun ⟨m, mm, r⟩ => no ⟨m, mm, «所闭之传递» r («缘在所闭» c)⟩

/-- **The stretch form.** In a region nothing outside continues into, each step one stage on, no
occurrence continuing as two units, with a list covering the units at stage `N` and no unit
beginning at a stage in `(N, U)`: distinct units ending at stages in `[N, U)` number at most the
list. No decision. -/
theorem U4d.cover_within (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    {N U : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L)
    (quiet : ∀ z, P z → N < τ z → τ z < U → ¬ «生» R E z)
    {D : List α} (dD : Distinct D)
    (ends : ∀ x, x ∈ D → N ≤ τ x ∧ τ x < U ∧ P x ∧ «亡» R E x) : D.length ≤ L.length :=
  U4d.ends_le_unrefuted dD (U4d.fixed_of_noSplit back noSplit fun x mx => (ends x mx).2.2.1)
    (fun x mx => match le_dest (ends x mx).1 with
      | ⟨k, at_⟩ => U4d.trace_unrefuted stage back covers k x (ends x mx).2.2.1 at_
          fun z hz late upto => quiet z hz late
            (Nat.lt_of_le_of_lt upto (Eq.subst (motive := (· < U)) at_ (ends x mx).2.1)))
    fun x mx => (ends x mx).2.2.2

/-- **The covering law, decided, from one list.** In the stretch form's frame, with beginning or
predecessor decided after `N`: where endings recur, something begins after `N`. -/
theorem U4d.cover_from (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    {N : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L)
    (decided : ∀ y, P y → N < τ y → «生» R E y ∨ «有前» R E y)
    (ending : ∀ M, ∃ x, M ≤ τ x ∧ P x ∧ «亡» R E x) :
    ∃ y, N < τ y ∧ P y ∧ «生» R E y :=
  match U4d.found (marks := fun x => P x ∧ «亡» R E x) ending (L.length + 1) N with
  | ⟨_, _, dD, len, _, all⟩ =>
    match U4d.found_or_all (A := ∃ z, N < τ z ∧ P z ∧ «生» R E z)
        (B := fun x => ∃ m, m ∈ L ∧ «所闭» («续» R E) m x)
        (fun x mx => match le_dest (all x mx).1 with
          | ⟨k, at_⟩ => U4d.trace stage back covers decided k x (all x mx).2.2.1 at_) with
    | .inl found => found
    | .inr reached => (Nat.not_succ_le_self L.length (Nat.le_trans (Nat.le_of_eq len.symm)
        (U4d.ends_le dD (U4d.fixed_of_noSplit back noSplit fun x mx => (all x mx).2.2.1)
          reached fun x mx => (all x mx).2.2.2))).elim

/-- **The covering law, decided.** With lists covering the units at arbitrarily late stages and
beginning or predecessor decided after `T`: where endings recur, beginnings recur. -/
theorem U4d.cover_run (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    (covered : ∀ M, ∃ N, ∃ L : List α, M ≤ N ∧ ∀ x, P x → τ x = N → x ∈ L)
    {T : Nat} (decided : ∀ y, P y → T < τ y → «生» R E y ∨ «有前» R E y)
    (ending : ∀ M, ∃ x, M ≤ τ x ∧ P x ∧ «亡» R E x) :
    ∀ M, ∃ y, M < τ y ∧ P y ∧ «生» R E y :=
  fun M => match covered (M + T) with
  | ⟨_, _, later, covers⟩ => match U4d.cover_from stage back noSplit covers
      (fun y h late => decided y h
        (Nat.lt_of_le_of_lt (Nat.le_trans (Nat.le_add_left T M) later) late)) ending with
    | ⟨z, late, h, b⟩ =>
      ⟨z, Nat.lt_of_le_of_lt (Nat.le_trans (Nat.le_add_right M T) later) late, h, b⟩

/-- **The covering law, undecided.** With a list covering the units at `N` and endings at
arbitrarily late stages each not refuted, a beginning after `N` is not refuted: the stretch form,
endings found at distinct stages. -/
theorem U4d.cover_unrefuted (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    {N : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L)
    (ending : ∀ M, ¬¬ ∃ x, M ≤ τ x ∧ P x ∧ «亡» R E x) :
    ¬¬ ∃ y, N < τ y ∧ P y ∧ «生» R E y :=
  fun none => U4d.found_unrefuted (marks := fun x => P x ∧ «亡» R E x) ending (L.length + 1) N
    fun ⟨_, _, dD, len, _, all⟩ =>
    Nat.not_succ_le_self L.length (Nat.le_trans (Nat.le_of_eq len.symm)
      (U4d.cover_within stage back noSplit covers (fun z hz late _ b => none ⟨z, late, hz, b⟩)
        dD all))

/-- **So beginnings never stop**, where lists cover the units at arbitrarily late stages and
endings recur as far as can be refuted. -/
theorem U4d.cover_never_stops (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    (covered : ∀ M, ∃ N, ∃ L : List α, M ≤ N ∧ ∀ x, P x → τ x = N → x ∈ L)
    (ending : ∀ M, ¬¬ ∃ x, M ≤ τ x ∧ P x ∧ «亡» R E x) :
    ¬ ∃ M, ∀ y, M < τ y → P y → ¬ «生» R E y :=
  fun ⟨M, quiet⟩ => match covered M with
  | ⟨_, _, later, covers⟩ => U4d.cover_unrefuted stage back noSplit covers ending
      fun ⟨y, late, h, b⟩ => quiet y (Nat.lt_of_le_of_lt later late) h b

/-! #### On along the lines: beginnings need endings -/

/-- **Tracing on, undecided.** In a region nothing in it continues out of, with nothing ending at a
stage in `[N, U)`, a unit at a stage from `N` has `k` steps after it wherever its stage with `k` is
at most `U`, as far as can be refuted. -/
theorem U4d.onward_within (stage : ∀ x y, «续» R E x y → τ y = τ x + 1) (on : «闭» («续» R E) P)
    {N U : Nat} (quiet : ∀ z, P z → N ≤ τ z → τ z < U → ¬ «亡» R E z)
    {x : α} (from_ : N ≤ τ x) (h : P x) : ∀ k, τ x + k ≤ U → ¬¬ ∃ y, «迭» («续» R E) k x y :=
  fun k upto => «或有后则或迭» k fun j y below steps =>
    have at_ : τ y = τ x + j := U4d.stage_steps stage j steps
    quiet y («闭含所闭» on h (U4d.closure_iff_steps.mpr ⟨j, steps⟩))
      (Nat.le_trans from_ (Eq.subst (motive := (τ x ≤ ·)) at_.symm (Nat.le_add_right _ _)))
      (Eq.subst (motive := (· < U)) at_.symm
        (Nat.lt_of_lt_of_le (Nat.add_lt_add_left below _) upto))

/-- **The stretch form's mirror.** In a region nothing in it continues out of, each step one stage
on, no two units continuing as one occurrence, with a list covering the units at stage `U` and no
unit ending at a stage in `[N, U)`: distinct units beginning at stages in `[N, U]` number at most the
list. No decision. -/
theorem U4d.cover_within_converse (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (on : «闭» («续» R E) P)
    (noMerge : ∀ v a a', P a → P a' → «续» R E a v → «续» R E a' v → a = a')
    {N U : Nat} {L : List α} (covers : ∀ x, P x → τ x = U → x ∈ L)
    (quiet : ∀ z, P z → N ≤ τ z → τ z < U → ¬ «亡» R E z)
    {D : List α} (dD : Distinct D)
    (begins : ∀ x, x ∈ D → N ≤ τ x ∧ τ x ≤ U ∧ P x ∧ «生» R E x) : D.length ≤ L.length :=
  U4d.begins_le_unrefuted dD
    (fun v a a' _ ⟨x, mx, toA⟩ ⟨x', mx', toA'⟩ => noMerge v a a'
      («闭含所闭» on (begins x mx).2.2.1 toA) («闭含所闭» on (begins x' mx').2.2.1 toA'))
    (fun x mx no => match le_dest (begins x mx).2.1 with
      | ⟨k, at_⟩ => U4d.onward_within stage on quiet (begins x mx).1 (begins x mx).2.2.1 k
          (Nat.le_of_eq at_.symm) fun ⟨y, steps⟩ => no ⟨y, covers y
            («闭含所闭» on (begins x mx).2.2.1 (U4d.closure_iff_steps.mpr ⟨k, steps⟩))
            ((U4d.stage_steps stage k steps).trans at_.symm),
            U4d.closure_iff_steps.mpr ⟨k, steps⟩⟩)
    fun x mx => (begins x mx).2.2.2

/-- **The converse.** Lists of at most `K` covering the units at every stage from `T`, beginnings at
arbitrarily late stages: endings never stop. The stretch form's mirror, beginnings found at distinct
stages. -/
theorem U4d.cover_converse (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (on : «闭» («续» R E) P)
    (noMerge : ∀ v a a', P a → P a' → «续» R E a v → «续» R E a' v → a = a')
    {K T : Nat}
    (bounded : ∀ S, T ≤ S → ∃ L : List α, L.length ≤ K ∧ ∀ x, P x → τ x = S → x ∈ L)
    (beginning : ∀ M, ∃ x, M ≤ τ x ∧ P x ∧ «生» R E x) :
    ¬ ∃ N, ∀ x, N ≤ τ x → P x → ¬ «亡» R E x :=
  fun ⟨N, quiet⟩ =>
    match U4d.found (marks := fun x => P x ∧ «生» R E x) beginning (K + 1) (N + T) with
    | ⟨_, U, dD, len, from_, all⟩ => match bounded U (Nat.le_trans (Nat.le_add_left T N) from_) with
      | ⟨_, short, covers⟩ => Nat.not_succ_le_self K (Nat.le_trans (Nat.le_of_eq len.symm)
          (Nat.le_trans (U4d.cover_within_converse (N := N + T) stage on noMerge covers
            (fun z hz late _ => quiet z (Nat.le_trans (Nat.le_add_right N T) late) hz) dD
            fun x mx => ⟨(all x mx).1, Nat.le_of_lt (all x mx).2.1, (all x mx).2.2⟩) short))

/-- **Tracing on, decided.** From a unit at a stage from `N`, ending or successor decided from `N`:
an ending from `N` on, or `k` steps. -/
theorem U4d.trace_on (stage : ∀ x y, «续» R E x y → τ y = τ x + 1) (on : «闭» («续» R E) P)
    {N : Nat} (decided : ∀ x, P x → N ≤ τ x → «亡» R E x ∨ «有后» R E x) :
    ∀ k x, P x → N ≤ τ x →
      (∃ z, N ≤ τ z ∧ P z ∧ «亡» R E z) ∨ ∃ y, «迭» («续» R E) k x y
  | 0, x, _, _ => .inr ⟨x, rfl⟩
  | k + 1, x, h, from_ => match decided x h from_ with
    | .inl en => .inl ⟨x, from_, h, en⟩
    | .inr ⟨w, c⟩ =>
      match U4d.trace_on stage on decided k w (on x w h c)
          (Nat.le_trans from_ (Nat.le_of_lt (Eq.subst (motive := (τ x < ·)) (stage x w c).symm
            (Nat.lt_succ_self _)))) with
      | .inl found => .inl found
      | .inr ⟨y, steps⟩ => .inr ⟨y, w, c, steps⟩

/-- **The converse, decided.** With ending or successor decided from `T`, beginnings recurring need
endings recurring. -/
theorem U4d.cover_converse_run (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (on : «闭» («续» R E) P)
    (noMerge : ∀ v a a', P a → P a' → «续» R E a v → «续» R E a' v → a = a')
    {K T : Nat}
    (bounded : ∀ S, T ≤ S → ∃ L : List α, L.length ≤ K ∧ ∀ x, P x → τ x = S → x ∈ L)
    (decided : ∀ x, P x → T ≤ τ x → «亡» R E x ∨ «有后» R E x)
    (beginning : ∀ M, ∃ x, M ≤ τ x ∧ P x ∧ «生» R E x) :
    ∀ N, ∃ x, N ≤ τ x ∧ P x ∧ «亡» R E x :=
  fun N =>
    match U4d.found (marks := fun x => P x ∧ «生» R E x) beginning (K + 1) (N + T) with
    | ⟨D, U, dD, len, from_, all⟩ => match bounded U (Nat.le_trans (Nat.le_add_left T N) from_) with
      | ⟨L, short, covers⟩ =>
        match U4d.found_or_all (A := ∃ z, N + T ≤ τ z ∧ P z ∧ «亡» R E z)
            (B := fun x => ∃ m, m ∈ L ∧ «所闭» («续» R E) x m) (D := D)
            (fun x mx => match le_dest (Nat.le_of_lt (all x mx).2.1) with
              | ⟨k, at_⟩ => match U4d.trace_on (N := N + T) stage on
                  (fun x h from_ => decided x h (Nat.le_trans (Nat.le_add_left T N) from_))
                  k x (all x mx).2.2.1 (all x mx).1 with
                | .inl found => .inl found
                | .inr ⟨y, steps⟩ => .inr ⟨y, covers y
                    («闭含所闭» on (all x mx).2.2.1 (U4d.closure_iff_steps.mpr ⟨k, steps⟩))
                    ((U4d.stage_steps stage k steps).trans at_.symm),
                    U4d.closure_iff_steps.mpr ⟨k, steps⟩⟩) with
        | .inl ⟨z, from_, h, en⟩ => ⟨z, Nat.le_trans (Nat.le_add_right N T) from_, h, en⟩
        | .inr reaching => (Nat.not_succ_le_self K (Nat.le_trans (Nat.le_of_eq len.symm)
            (Nat.le_trans (U4d.begins_le dD
              (fun v a a' _ ⟨x, mx, toA⟩ ⟨x', mx', toA'⟩ => noMerge v a a'
                («闭含所闭» on (all x mx).2.2.1 toA) («闭含所闭» on (all x' mx').2.2.1 toA'))
              reaching fun x mx => (all x mx).2.2.2) short))).elim

end Run

/-! ### The census of a run, through lines -/

/-- A test over a list: some member passes, or nothing does. -/
theorem U4d.list_search {β : Type u} (b : β → Bool) : ∀ l : List β,
    (∃ y, y ∈ l ∧ b y = true) ∨ ∀ y, y ∈ l → b y ≠ true
  | [] => .inr fun _ mem => nomatch mem
  | x :: l => match hb : b x with
    | true => .inl ⟨x, .head l, hb⟩
    | false => match U4d.list_search b l with
      | .inl ⟨y, my, passes⟩ => .inl ⟨y, .tail x my, passes⟩
      | .inr nothing => .inr fun y my => match ListTests.mem_cons_iff.mp my with
        | .inl e => Eq.subst (motive := fun v => b v ≠ true) e.symm
            fun h => Bool.noConfusion (hb.symm.trans h)
        | .inr m => nothing y m

/-- A decided property over a range of numbers: found, or nowhere. -/
theorem U4d.range_search {Q : Nat → Prop} (dec : ∀ s, Q s ∨ ¬ Q s) (M : Nat) : ∀ n,
    (∃ s, M ≤ s ∧ s < M + n ∧ Q s) ∨ ∀ s, M ≤ s → s < M + n → ¬ Q s
  | 0 => .inr fun s lo hi _ => Nat.lt_irrefl s (Nat.lt_of_lt_of_le hi lo)
  | n + 1 => match U4d.range_search dec M n with
    | .inl ⟨s, lo, hi, q⟩ => .inl ⟨s, lo, Nat.lt_succ_of_lt hi, q⟩
    | .inr nothing => match dec (M + n) with
      | .inl q => .inl ⟨M + n, Nat.le_add_right M n, Nat.lt_succ_self _, q⟩
      | .inr nq => .inr fun s lo hi => match Nat.lt_or_ge s (M + n) with
        | .inl below => nothing s lo below
        | .inr above => Eq.subst (motive := fun v => ¬ Q v)
            (Nat.le_antisymm (Nat.le_of_lt_succ hi) above).symm nq

theorem U4d.pair_eq {β : Type u} : ∀ {x y : Nat × β}, x.1 = y.1 → x.2 = y.2 → x = y
  | (_, _), (_, _), rfl, rfl => rfl

/-- **The census of a run, through lines.** The conclusion of `GrammarLaws.census_run`, asking
neither that the units after each step be listed once nor a test of endings. The units are read as
occurrences `(t, x)` at stages, each step one stage on; the stretch form applies, and the beginning's
test decides a finite search. -/
theorem U4d.census_run_lines {b : α → Bool} {u : Nat → List α} {T : Nat}
    (noSplit : ∀ t, T ≤ t → ∀ x y y', x ∈ u t → y ∈ u (t + 1) → y' ∈ u (t + 1) →
      «续» R E x y → «续» R E x y' → y = y')
    (predecessorsBefore : ∀ t, T ≤ t → ∀ x y, y ∈ u (t + 1) → «续» R E x y → x ∈ u t)
    (begins : ∀ t, T ≤ t → ∀ y, y ∈ u (t + 1) → (b y = true ↔ «生» R E y))
    (ending : «屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u) :
    «屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u :=
  fun N =>
  let R' : «际» (Nat × α) := fun x y => y.1 = x.1 + 1 ∧ «续» R E x.2 y.2
  let E' : «际» (Nat × α) := fun x y => T ≤ x.1 ∧ x.2 ∈ u x.1 ∧ y.2 ∈ u y.1
  let P' : Nat × α → Prop := fun x => T ≤ x.1 ∧ x.2 ∈ u x.1
  let N' := N + T
  let L := (u N').map (fun x => (N', x))
  have stage : ∀ x y, «续» R' E' x y → y.1 = x.1 + 1 := fun _ _ c => c.1.1
  have back : «闭» («逆» («续» R' E')) P' := fun _ _ _ c => ⟨c.2.1, c.2.2.1⟩
  have split : ∀ v b b', P' b → P' b' → «续» R' E' v b → «续» R' E' v b' → b = b' :=
    fun v b b' _ _ c c' => U4d.pair_eq (c.1.1.trans c'.1.1.symm)
      (noSplit v.1 c.2.1 v.2 b.2 b'.2 c.2.2.1
        (Eq.subst (motive := fun s => b.2 ∈ u s) c.1.1 c.2.2.2)
        (Eq.subst (motive := fun s => b'.2 ∈ u s) c'.1.1 c'.2.2.2) c.1.2 c'.1.2)
  have covers : ∀ x : Nat × α, P' x → x.1 = N' → x ∈ L :=
    fun x h at_ => Eq.subst (motive := (· ∈ L)) (U4d.pair_eq (x := (N', x.2)) (y := x) at_.symm rfl)
      (ListTests.mem_map_of (f := fun x => (N', x)) (Eq.subst (motive := fun s => x.2 ∈ u s) at_ h.2))
  have endings : ∀ M, ∃ x : Nat × α, M ≤ x.1 ∧ (P' x ∧ «亡» R' E' x) :=
    fun M => match ending (M + T) with
    | ⟨t, later, x, mx, en⟩ => ⟨(t, x), Nat.le_trans (Nat.le_add_right M T) later,
        ⟨Nat.le_trans (Nat.le_add_left T M) later, mx⟩, fun ⟨y, c⟩ => en ⟨y.2, c.1.2⟩⟩
  match U4d.found (τ := Prod.fst) (marks := fun x => P' x ∧ «亡» R' E' x) endings
      (L.length + 1) N' with
  | ⟨_, _, dD, len, from_, all⟩ =>
    match le_dest from_ with
    | ⟨n, atU⟩ =>
      match U4d.range_search (Q := fun t => ∃ y, y ∈ u (t + 1) ∧ b y = true)
          (fun t => match U4d.list_search b (u (t + 1)) with
            | .inl found => .inl found
            | .inr nothing => .inr fun ⟨y, my, passes⟩ => nothing y my passes) N' n with
      | .inl ⟨t, lo, _, y, my, passes⟩ =>
        ⟨t, Nat.le_trans (Nat.le_add_right N T) lo, y, my,
          (begins t (Nat.le_trans (Nat.le_add_left T N) lo) y my).mp passes⟩
      | .inr nothing => (Nat.not_succ_le_self L.length (Nat.le_trans (Nat.le_of_eq len.symm)
          (U4d.cover_within (τ := Prod.fst) (P := P') stage back split covers
            (fun z hz late below beg => match z, hz, late, below, beg with
              | (0, _), _, late, _, _ => Nat.not_lt_zero _ late
              | (t + 1, y), hz, late, below, beg =>
                have from_t : N' ≤ t := Nat.le_of_lt_succ late
                have fromT : T ≤ t := Nat.le_trans (Nat.le_add_left T N) from_t
                nothing t from_t (Nat.lt_of_lt_of_le (Nat.lt_succ_self t)
                    (Nat.le_of_lt (Eq.subst (motive := (t + 1 < ·)) atU below)))
                  ⟨y, hz.2, (begins t fromT y hz.2).mpr fun ⟨x, c⟩ =>
                    beg ⟨(t, x), ⟨rfl, c⟩, fromT, predecessorsBefore t fromT x y hz.2 c, hz.2⟩⟩)
            dD all))).elim

/-- The census of a run under a continuation that fixes successors, through lines. -/
theorem U4d.census_run_fixed {b : α → Bool} {u : Nat → List α} {T : Nat}
    (predecessorsBefore : ∀ t, T ≤ t → ∀ x y, y ∈ u (t + 1) → «续» R E x y → x ∈ u t)
    (fixedAfter : «定后» («续» R E))
    (begins : ∀ t, T ≤ t → ∀ y, y ∈ u (t + 1) → (b y = true ↔ «生» R E y))
    (ending : «屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u) :
    «屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u :=
  U4d.census_run_lines (fun _ _ x y y' _ _ _ c c' => «定后之逐点».mp fixedAfter x y y' c c')
    predecessorsBefore begins ending

end U4dCover

end Becoming
