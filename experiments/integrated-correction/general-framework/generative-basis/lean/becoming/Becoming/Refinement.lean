import Becoming.Decidedness

/-!
# Refinement: a chain of equivalences stops within its classes

Two configurations alike for `k` steps may come apart at the next. Read step by step, likeness
refines: each step's relation is an equivalence finer than the one before
(`Refining`). Where the configurations are held by a list of `N` members and each step's
relation is decided among them, the chain stops refining within the number of classes it can
still add. This module states that count with no premise beyond those decisions.

* **Members pairwise apart are no more than the list.** A list whose members no relation joins
  pairwise (`DistinctUnder`; `Distinct` of `Becoming.Population` is the case of equality) and
  which a list holds is no longer than it, wherever the relation joins each member to itself
  (`DistinctUnder.length_le`). Two members of such a list that the relation joins are one
  member, wherever it is symmetric (`DistinctUnder.unique`).
* **A strict refinement adds a class.** Where two members joined at one step are apart at the
  next, a list of members pairwise apart at the first step extends, by one member, to a list
  pairwise apart at the next (`Refining.grow`).
* **The chain stops within its classes** (`Refining.steady_within`). Where a list of `N`
  members holds the configurations, each step's relation is decided among them, and some `c`
  of them are pairwise apart at the first step, at some step `k` with `k + c ≤ N` members the
  relation joins are joined at the next (`SteadyAt`). Moore's bound (1956) is the case of a
  determined law read through a map (`Law.sameFuture_iff_classes` of
  `Becoming.Identification`); branching frames are `AlikeTo.steady_within_classes` of
  `Becoming.Likeness`.
* **Refuted by nothing.** The decisions of finitely many propositions are together unrefuted
  (`not_not_within`), so wherever a count needs them, its conclusion is refuted by nothing,
  with no premise.

The readings are the AI's, adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D34).
-/

namespace Becoming

universe u

section Refinement

variable {X : Type u}

/-- Apart under a relation, members are apart under every relation it contains. -/
theorem DistinctUnder.mono {R R' : X → X → Prop} (within : ∀ x y, R' x y → R x y) :
    ∀ {s : List X}, DistinctUnder R s → DistinctUnder R' s
  | [], _ => trivial
  | _ :: _, ⟨head, tail⟩ =>
    ⟨fun y mem related => head y mem (within _ y related), DistinctUnder.mono within tail⟩

/-- Under a symmetric relation, two members of a list pairwise apart that it joins are one. -/
theorem DistinctUnder.unique {R : X → X → Prop} (symm : ∀ {x y}, R x y → R y x) :
    ∀ {s : List X} {x y : X}, DistinctUnder R s → x ∈ s → y ∈ s → R x y → x = y
  | [], _, _, _, mem, _, _ => nomatch mem
  | _ :: _, x, y, ⟨head, tail⟩, mem, mem', related =>
    match mem_cons_cases mem, mem_cons_cases mem' with
    | .inl here, .inl here' => here.trans here'.symm
    | .inl here, .inr later' =>
      absurd (Eq.subst (motive := fun w => R w y) here related) (head y later')
    | .inr later, .inl here' =>
      absurd (Eq.subst (motive := fun w => R w x) here' (symm related)) (head x later)
    | .inr later, .inr later' => DistinctUnder.unique symm tail later later' related

/-- Taking one occurrence of a member from a list leaves a list one shorter holding the rest. -/
theorem remove_mem : ∀ {l : List X} {x : X}, x ∈ l →
    ∃ l' : List X, l'.length + 1 = l.length ∧ ∀ y, y ∈ l → y = x ∨ y ∈ l'
  | [], _, mem => nomatch mem
  | a :: t, _, mem => match mem_cons_cases mem with
    | .inl same => ⟨t, rfl, fun _ mem' => match mem_cons_cases mem' with
      | .inl here => .inl (here.trans same.symm)
      | .inr later => .inr later⟩
    | .inr later => match remove_mem later with
      | ⟨t', shorter, rest⟩ => ⟨a :: t', congrArg (· + 1) shorter, fun y mem' =>
        match mem_cons_cases mem' with
        | .inl here => .inr (Eq.subst (motive := fun w => w ∈ a :: t') here.symm (.head t'))
        | .inr later' => match rest y later' with
          | .inl same => .inl same
          | .inr kept => .inr (.tail a kept)⟩

/-- **Members pairwise apart are no more than the list holding them**, wherever the relation
joins each member to itself. -/
theorem DistinctUnder.length_le {R : X → X → Prop} (refl : ∀ x, R x x) :
    ∀ {s l : List X}, DistinctUnder R s → (∀ x, x ∈ s → x ∈ l) → s.length ≤ l.length
  | [], _, _, _ => Nat.zero_le _
  | x :: s, _, ⟨head, tail⟩, within => match remove_mem (within x (.head s)) with
    | ⟨l', shorter, rest⟩ =>
      have inner : ∀ y, y ∈ s → y ∈ l' := fun y mem => match rest y (within y (.tail x mem)) with
        | .inl same => absurd (Eq.subst (motive := fun w => R x w) same.symm (refl x)) (head y mem)
        | .inr kept => kept
      Eq.subst (motive := fun n => s.length + 1 ≤ n) shorter
        (Nat.succ_le_succ (DistinctUnder.length_le refl tail inner))

/-- **The decisions of finitely many propositions are together refuted by nothing.** -/
theorem not_not_within {P : X → Prop} (each : ∀ x, ¬ ¬ P x) :
    ∀ l : List X, ¬ ¬ ∀ x, x ∈ l → P x
  | [] => fun refuted => refuted fun _ mem => nomatch mem
  | a :: l => fun refuted => each a fun holds => not_not_within each l fun rest =>
    refuted fun x mem => match mem_cons_cases mem with
      | .inl same => Eq.subst (motive := P) same.symm holds
      | .inr later => rest x later

/-- A chain of equivalences, each finer than the one before. -/
structure Refining (R : Nat → X → X → Prop) : Prop where
  refl : ∀ k x, R k x x
  symm : ∀ {k x y}, R k x y → R k y x
  trans : ∀ {k x y z}, R k x y → R k y z → R k x z
  finer : ∀ {k x y}, R (k + 1) x y → R k x y

/-- Among the members of a list, what the chain joins at step `k` it joins at the next. -/
def SteadyAt (R : Nat → X → X → Prop) (l : List X) (k : Nat) : Prop :=
  ∀ x y, x ∈ l → y ∈ l → R k x y → R (k + 1) x y

variable {R : Nat → X → X → Prop} {l : List X}

/-- **A strict refinement adds a class.** Where `x` and `y` are joined at step `j` and apart at
the next, a list of members pairwise apart at step `j` extends by one member of `l` to a list
pairwise apart at the next. -/
theorem Refining.grow (refining : Refining R)
    (decided : ∀ k x y, x ∈ l → y ∈ l → Decided (R k x y)) {j : Nat} {r : List X}
    (apart : DistinctUnder (R j) r) (within : ∀ x, x ∈ r → x ∈ l) {x y : X} (mem : x ∈ l)
    (mem' : y ∈ l) (joined : R j x y) (parted : ¬ R (j + 1) x y) :
    ∃ z, z ∈ l ∧ DistinctUnder (R (j + 1)) (z :: r) :=
  have kept : DistinctUnder (R (j + 1)) r := apart.mono fun _ _ related => refining.finer related
  match Decided.exists_listed (l := r) fun a inside => decided j x a mem (within a inside) with
  | .inr absent => ⟨x, mem, fun c inside related => absent ⟨c, inside, refining.finer related⟩, kept⟩
  | .inl ⟨a, inside, toA⟩ =>
    -- `a` is the one member of `r` joined to `x`, and so to `y`, at step `j`.
    have only : ∀ {z c}, R j z a → c ∈ r → R j z c → a = c := fun toA' inside' toC =>
      DistinctUnder.unique refining.symm apart inside inside' (refining.trans (refining.symm toA') toC)
    match decided (j + 1) x a mem (within a inside) with
    | .inr fails =>
      ⟨x, mem, fun _ inside' related => fails (Eq.subst (motive := fun w => R (j + 1) x w)
        (only toA inside' (refining.finer related)).symm related), kept⟩
    | .inl toA' =>
      ⟨y, mem', fun _ inside' related =>
        have yToA : R j y a := refining.trans (refining.symm joined) toA
        have yToA' : R (j + 1) y a := Eq.subst (motive := fun w => R (j + 1) y w)
          (only yToA inside' (refining.finer related)).symm related
        parted (refining.trans toA' (refining.symm yToA')), kept⟩

/-- Step by step, either the chain has stopped refining within the bound, or members pairwise
apart at the step are as many as those at the first, and the steps taken, together. -/
theorem Refining.steady_or_grown (refining : Refining R)
    (decided : ∀ k x y, x ∈ l → y ∈ l → Decided (R k x y)) {s : List X}
    (apart : DistinctUnder (R 0) s) (within : ∀ x, x ∈ s → x ∈ l) :
    ∀ j, (∃ k, k + s.length ≤ l.length ∧ SteadyAt R l k) ∨
      ∃ r, DistinctUnder (R j) r ∧ (∀ x, x ∈ r → x ∈ l) ∧ s.length + j ≤ r.length
  | 0 => .inr ⟨s, apart, within, Nat.le_refl _⟩
  | j + 1 => match Refining.steady_or_grown refining decided apart within j with
    | .inl found => .inl found
    | .inr ⟨r, apart', within', long⟩ =>
      have bound : j + s.length ≤ l.length :=
        Eq.subst (motive := fun n => n ≤ l.length) (Nat.add_comm s.length j)
          (Nat.le_trans long (apart'.length_le (refining.refl j) within'))
      match Decided.exists_listed (l := l) (fun x mem => Decided.exists_listed (l := l)
          fun y mem' => (decided j x y mem mem').and (decided (j + 1) x y mem mem').not) with
      | .inr absent => .inl ⟨j, bound, fun x y mem mem' joined =>
        (decided (j + 1) x y mem mem').of_not_not fun parted => absent ⟨x, mem, y, mem', joined, parted⟩⟩
      | .inl ⟨_, mem, _, mem', joined, parted⟩ =>
        match refining.grow decided apart' within' mem mem' joined parted with
        | ⟨z, inside, apart''⟩ => .inr ⟨z :: r, apart'', fun w mem'' =>
          match mem_cons_cases mem'' with
          | .inl same => Eq.subst (motive := fun v => v ∈ l) same.symm inside
          | .inr later => within' w later, Nat.succ_le_succ long⟩

/-- **The chain stops within its classes.** Where a list of `N` members holds the configurations,
each step's relation is decided among them and `c` of them are pairwise apart at the first step,
at some step `k` with `k + c ≤ N` what the chain joins it joins at the next. -/
theorem Refining.steady_within (refining : Refining R)
    (decided : ∀ k x y, x ∈ l → y ∈ l → Decided (R k x y)) {s : List X}
    (apart : DistinctUnder (R 0) s) (within : ∀ x, x ∈ s → x ∈ l) :
    ∃ k, k + s.length ≤ l.length ∧ SteadyAt R l k :=
  match refining.steady_or_grown decided apart within (l.length + 1) with
  | .inl found => found
  | .inr ⟨_, apart', within', long⟩ =>
    absurd (Nat.le_trans (Nat.le_add_left (l.length + 1) s.length)
      (Nat.le_trans long (apart'.length_le (refining.refl _) within'))) (Nat.not_succ_le_self _)

/-- A single member is apart from nothing. -/
theorem DistinctUnder.single {R : X → X → Prop} (x : X) : DistinctUnder R [x] :=
  ⟨fun _ mem => (nomatch mem), trivial⟩

/-- A bound one short of a list's length, where the bound and one more fit. -/
theorem le_pred_of_succ_le {k : Nat} : ∀ {n : Nat}, k + 1 ≤ n → k ≤ n - 1
  | 0, le => absurd le (Nat.not_succ_le_zero k)
  | _ + 1, le => Nat.le_of_succ_le_succ le

end Refinement

end Becoming
