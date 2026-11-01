import Becoming.Locality
import Becoming.Identity
import Becoming.U4dCover

/-! U4d scratch: Locality's and Identity's covering laws re-proved as cases of the root forms in
`U4dCover`, each statement the package's own, unchanged. Not part of the package. -/

namespace Becoming

/-! ### Locality: a relatum's occurrences along its steps -/

section U4dLocality

variable {α : Type} {p : α → Nat → Prop}

theorem U4d.along_stage :
    ∀ x y : Nat × α, «续» Steps.along (Steps.alikeAt p) x y → y.1 = x.1 + 1 :=
  fun _ _ ⟨⟨next, _⟩, _⟩ => next

theorem U4d.along_keeps :
    ∀ x y : Nat × α, «续» Steps.along (Steps.alikeAt p) x y → p y.2 y.1 → p x.2 x.1 :=
  fun _ _ ⟨_, alike⟩ h => alike.mpr h

theorem U4d.along_noSplit :
    ∀ v b b' : Nat × α, p b.2 b.1 → p b'.2 b'.1 → «续» Steps.along (Steps.alikeAt p) v b →
      «续» Steps.along (Steps.alikeAt p) v b' → b = b' :=
  fun v b b' _ _ c c' => «定后之逐点».mp (Steps.along_fixed (Steps.alikeAt p)) v b b' c c'

theorem U4d.along_covers {L : List α} {N : Nat} (covers : Covers p L N) :
    ∀ x : Nat × α, p x.2 x.1 → x.1 = N → x ∈ L.map (fun a => (N, a))
  | (_, a), h, rfl => ListTests.mem_map_of (covers a h)

theorem U4d.along_decided [∀ a t, Decidable (p a t)] :
    ∀ y : Nat × α, p y.2 y.1 →
      «生» Steps.along (Steps.alikeAt p) y ∨ «有前» Steps.along (Steps.alikeAt p) y
  | (0, a), _ => .inl (Steps.along_sheng_zero _ a)
  | (t + 1, a), h =>
    if held : p a t then .inr (Steps.along_hasPred_iff.mpr ⟨fun _ => h, fun _ => held⟩)
    else .inl (comesToBe_iff_sheng_along.mp ⟨held, h⟩).2

theorem U4d.along_ending (ceasing : ∀ M, ∃ t a, M ≤ t ∧ CeasesToBe (p a) t) :
    ∀ M, ∃ x : Nat × α, M ≤ x.1 ∧ p x.2 x.1 ∧ «亡» Steps.along (Steps.alikeAt p) x :=
  fun M => match ceasing M with
  | ⟨t, a, later, ceases⟩ => ⟨(t, a), later, ceasesToBe_iff_wang_along.mp ceases⟩

/-- Locality's `Covers.coming_from_of_ceasing`, the statement unchanged, as the decided law from one
list. -/
theorem U4d.coming_from_of_ceasing [∀ a t, Decidable (p a t)] {L : List α} {N : Nat}
    (covers : Covers p L N) (ceasing : ∀ M, ∃ t a, M ≤ t ∧ CeasesToBe (p a) t) :
    ∃ s a, N ≤ s ∧ ComesToBe (p a) s :=
  match U4d.cover_from (τ := Prod.fst) (here := fun x : Nat × α => p x.2 x.1)
      U4d.along_stage U4d.along_keeps U4d.along_noSplit (U4d.along_covers covers)
      U4d.along_decided (U4d.along_ending ceasing) with
  | ⟨(0, _), late, _, _⟩ => absurd late (Nat.not_lt_zero N)
  | ⟨(t + 1, a), late, h, b⟩ =>
    ⟨t, a, Nat.le_of_lt_succ late, comesToBe_iff_sheng_along.mpr ⟨h, b⟩⟩

/-- Locality's `coming_of_ceasing_covered`, the statement unchanged, as the decided run law. -/
theorem U4d.coming_of_ceasing_covered [∀ a t, Decidable (p a t)]
    (covered : ∀ M, ∃ N L, M ≤ N ∧ Covers p L N)
    (ceasing : ∀ M, ∃ t a, M ≤ t ∧ CeasesToBe (p a) t) :
    ∀ M, ∃ t a, M ≤ t ∧ ComesToBe (p a) t :=
  fun M => match U4d.cover_run (τ := Prod.fst) (here := fun x : Nat × α => p x.2 x.1)
      U4d.along_stage U4d.along_keeps U4d.along_noSplit
      (fun K => match covered K with
        | ⟨N, L, later, covers⟩ => ⟨N, L.map (fun a => (N, a)), later, U4d.along_covers covers⟩)
      U4d.along_decided (U4d.along_ending ceasing) M with
  | ⟨(0, _), late, _, _⟩ => absurd late (Nat.not_lt_zero M)
  | ⟨(t + 1, a), late, h, b⟩ =>
    ⟨t, a, Nat.le_of_lt_succ late, comesToBe_iff_sheng_along.mpr ⟨h, b⟩⟩

/-- Locality's `Covers.not_not_coming_from`, unchanged, as the undecided run law. -/
theorem U4d.not_not_coming_from {L : List α} {N : Nat} (covers : Covers p L N)
    (ceasing : ∀ M, ¬ ¬ ∃ t a, M ≤ t ∧ CeasesToBe (p a) t) :
    ¬ ¬ ∃ s a, N ≤ s ∧ ComesToBe (p a) s :=
  fun nothing => U4d.cover_unrefuted (τ := Prod.fst) (here := fun x : Nat × α => p x.2 x.1)
    U4d.along_stage U4d.along_keeps U4d.along_noSplit (U4d.along_covers covers)
    (fun M no => ceasing M fun ⟨t, a, later, ceases⟩ =>
      no ⟨(t, a), later, ceasesToBe_iff_wang_along.mp ceases⟩)
    fun ⟨y, late, h, b⟩ => match y, late, h, b with
      | (0, _), late, _, _ => Nat.not_lt_zero N late
      | (t + 1, a), late, h, b =>
        nothing ⟨t, a, Nat.le_of_lt_succ late, comesToBe_iff_sheng_along.mpr ⟨h, b⟩⟩

/-- Locality's `Covers.ceasing_stops_unrefuted`, unchanged. -/
theorem U4d.ceasing_stops_unrefuted {L : List α} {N : Nat} (covers : Covers p L N)
    (none : ∀ n, NoneComes p N n) : ¬ ∀ M, ¬ ¬ ∃ t a, M ≤ t ∧ CeasesToBe (p a) t :=
  fun ceasing => U4d.not_not_coming_from covers ceasing fun ⟨s, a, from_, comes⟩ =>
    none (s + 1) s a from_
      (Nat.lt_of_lt_of_le (Nat.lt_succ_self s) (Nat.le_add_left (s + 1) N)) comes

/-- A list of steps, each with some relatum, gives a list of occurrences over it. -/
theorem U4d.pick {P : Nat → α → Prop} : ∀ {E : List Nat}, (∀ t, t ∈ E → ∃ a, P t a) →
    ∃ D : List (Nat × α), D.map Prod.fst = E ∧ ∀ x, x ∈ D → P x.1 x.2
  | [], _ => ⟨[], rfl, fun _ mem => nomatch mem⟩
  | t :: E, each =>
    match each t (.head E), U4d.pick (E := E) (fun s mem => each s (.tail t mem)) with
    | ⟨a, pa⟩, ⟨D, same, all⟩ => ⟨(t, a) :: D, congrArg (t :: ·) same, fun x mem =>
        match ListTests.mem_cons_iff.mp mem with
        | .inl e => Eq.subst (motive := fun y : Nat × α => P y.1 y.2) e.symm pa
        | .inr mem => all x mem⟩

theorem U4d.distinct_of_map {β : Type} {f : Nat × α → β} :
    ∀ {D : List (Nat × α)}, Distinct (D.map f) → Distinct D
  | [], _ => trivial
  | _ :: _, ⟨fresh, rest⟩ =>
    ⟨fun mem => fresh (ListTests.mem_map_of mem), U4d.distinct_of_map rest⟩

/-- Locality's `Covers.ceasing_steps_within`, unchanged, as the count where reaching is only not
refuted. -/
theorem U4d.ceasing_steps_within {L : List α} {N n : Nat} (covers : Covers p L N)
    (none : NoneComes p N n) {E : List Nat} (distinct : Distinct E)
    (ceasing : ∀ t, t ∈ E → N ≤ t ∧ t < N + n ∧ ∃ a, CeasesToBe (p a) t) :
    E.length ≤ L.length :=
  match U4d.pick (P := fun t a => N ≤ t ∧ t < N + n ∧ CeasesToBe (p a) t)
      (fun t mem => match ceasing t mem with
        | ⟨from_, below, a, ceases⟩ => ⟨a, from_, below, ceases⟩) with
  | ⟨D, same, all⟩ =>
    Nat.le_trans (Nat.le_of_eq ((congrArg List.length same).symm.trans (length_map Prod.fst D)))
      (Nat.le_trans (U4d.ends_le_unrefuted (L := L.map fun a => (N, a))
        (U4d.distinct_of_map (Eq.subst (motive := Distinct) same.symm distinct))
        (U4d.fixed_of_noSplit (here := fun x : Nat × α => p x.2 x.1)
          U4d.along_keeps U4d.along_noSplit fun x mx => (all x mx).2.2.1)
        (fun x mx => match le_dest (all x mx).1 with
          | ⟨k, at_⟩ => U4d.trace_unrefuted (τ := Prod.fst) (here := fun x : Nat × α => p x.2 x.1)
              U4d.along_stage U4d.along_keeps (U4d.along_covers covers) k x (all x mx).2.2.1 at_
              fun z hz late upto b => match z, hz, late, upto, b with
                | (0, _), _, late, _, _ => Nat.not_lt_zero N late
                | (s + 1, c), hz, late, upto, b => none s c (Nat.le_of_lt_succ late)
                    (Nat.lt_of_lt_of_le (Nat.lt_succ_self s) (Nat.le_trans upto
                      (Nat.le_trans (Nat.le_of_eq at_.symm) (Nat.le_of_lt (all x mx).2.1))))
                    (comesToBe_iff_sheng_along.mpr ⟨hz, b⟩))
        fun x mx => (ceasesToBe_iff_wang_along.mp (all x mx).2.2).2)
        (Nat.le_of_eq (length_map _ L)))

end U4dLocality

/-! ### Identity: formations' occurrences under a continuation, within activity onward -/

namespace Web

section U4dIdentity

variable {F C : Type} {W : Web F C} {R : Nat → F → F → Prop}

theorem U4d.cont_stage {T : Nat} :
    ∀ x y : Nat × F, «续» (continuationStep R) (W.activityOnward T) x y → y.1 = x.1 + 1 :=
  fun _ _ ⟨⟨next, _⟩, _⟩ => next

theorem U4d.cont_keeps {T : Nat} :
    ∀ x y : Nat × F, «续» (continuationStep R) (W.activityOnward T) x y →
      W.active y.1 y.2 → W.active x.1 x.2 :=
  fun _ _ ⟨_, _, _, active⟩ _ => active

theorem U4d.cont_keepsOn {T : Nat} :
    ∀ x y : Nat × F, «续» (continuationStep R) (W.activityOnward T) x y →
      W.active x.1 x.2 → W.active y.1 y.2 :=
  fun _ _ ⟨_, alike, _, _⟩ h => alike.mp h

theorem U4d.cont_noSplit {T : Nat}
    (noSplit : ∀ s, T ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f') :
    ∀ v b b' : Nat × F, W.active b.1 b.2 → W.active b'.1 b'.2 →
      «续» (continuationStep R) (W.activityOnward T) v b →
      «续» (continuationStep R) (W.activityOnward T) v b' → b = b' :=
  fun v b b' hb hb' ⟨⟨next, cont⟩, _, from_, active⟩ ⟨⟨next', cont'⟩, _⟩ =>
    occurrence_eq (next.trans next'.symm)
      (noSplit v.1 from_ v.2 b.2 b'.2 active cont cont'
        (Eq.subst (motive := fun s => W.active s b.2) next hb)
        (Eq.subst (motive := fun s => W.active s b'.2) next' hb'))

theorem U4d.cont_noMerge {T : Nat}
    (noMerge : ∀ s, T ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f → R s g' f →
      W.active (s + 1) f → g = g') :
    ∀ v a a' : Nat × F, W.active a.1 a.2 → W.active a'.1 a'.2 →
      «续» (continuationStep R) (W.activityOnward T) a v →
      «续» (continuationStep R) (W.activityOnward T) a' v → a = a' :=
  fun v a a' ha ha' ⟨⟨next, cont⟩, alike, from_, _⟩ ⟨⟨next', cont'⟩, _⟩ =>
    have same : a.1 = a'.1 := Nat.succ.inj (next.symm.trans next')
    occurrence_eq same (noMerge a.1 from_ a.2 a'.2 v.2 ha
      (Eq.subst (motive := fun s => W.active s a'.2) same.symm ha') cont
      (Eq.subst (motive := fun s => R s a'.2 v.2) same.symm cont')
      (Eq.subst (motive := fun s => W.active s v.2) next (alike.mp ha)))

theorem U4d.cont_covers {M : Nat} {l : List F} (covers : ∀ f, W.active M f → f ∈ l) :
    ∀ x : Nat × F, W.active x.1 x.2 → x.1 = M → x ∈ l.map (fun f => (M, f))
  | (_, f), h, rfl => ListTests.mem_map_of (covers f h)

theorem U4d.cont_ending {T : Nat} (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) :
    ∀ K, ∃ x : Nat × F, K ≤ x.1 ∧ W.active x.1 x.2 ∧
      «亡» (continuationStep R) (W.activityOnward T) x :=
  fun K => match ceasing K with
  | ⟨t, g, later, active, alone⟩ => ⟨(t, g), later, active,
      fun ⟨y, ⟨next, cont⟩, alike, _, _⟩ =>
        alone ⟨y.2, Eq.subst (motive := fun s => W.active s y.2) next (alike.mp active), cont⟩⟩

theorem U4d.cont_begins {T t : Nat} {f : F} (arises : W.ArisesFrom R t f) :
    «生» (continuationStep R) (W.activityOnward T) (t + 1, f) :=
  fun ⟨x, ⟨next, cont⟩, _, _, act⟩ =>
    have at_ : x.1 = t := Nat.succ.inj next.symm
    arises.2 ⟨x.2, Eq.subst (motive := fun s => W.active s x.2) at_ act,
      Eq.subst (motive := fun s => R s x.2 f) at_ cont⟩

theorem U4d.cont_arises {T t : Nat} {f : F} (from_ : T ≤ t) (h : W.active (t + 1) f)
    (begins : «生» (continuationStep R) (W.activityOnward T) (t + 1, f)) : W.ArisesFrom R t f :=
  ⟨h, fun ⟨g, act, cont⟩ => begins ⟨(t, g), ⟨rfl, cont⟩, ⟨fun _ => h, fun _ => act⟩, from_, act⟩⟩

theorem U4d.cont_ceases {T t : Nat} {g : F} (from_ : T ≤ t) (h : W.active t g)
    (ends : «亡» (continuationStep R) (W.activityOnward T) (t, g)) : W.CeasesFrom R t g :=
  ⟨h, fun ⟨f, act, cont⟩ => ends ⟨(t + 1, f), ⟨rfl, cont⟩, ⟨fun _ => act, fun _ => h⟩, from_, h⟩⟩

/-- Identity's `not_not_arisingFrom_covered`, unchanged, as the undecided run law. -/
theorem U4d.not_not_arisingFrom_covered {M : Nat} {l : List F}
    (covers : ∀ f, W.active M f → f ∈ l)
    (noSplit : ∀ s, M ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f')
    (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) :
    ¬¬ ∃ s f, M ≤ s ∧ W.ArisesFrom R s f :=
  fun nothing => U4d.cover_unrefuted (R := continuationStep R) (E := W.activityOnward M)
    (τ := Prod.fst) (here := fun x => W.active x.1 x.2)
    U4d.cont_stage U4d.cont_keeps (U4d.cont_noSplit noSplit) (U4d.cont_covers covers)
    (fun K no => no (U4d.cont_ending ceasing K))
    fun ⟨y, late, h, b⟩ => match y, late, h, b with
      | (0, _), late, _, _ => Nat.not_lt_zero M late
      | (s + 1, f), late, h, b =>
        nothing ⟨s, f, Nat.le_of_lt_succ late, U4d.cont_arises (Nat.le_of_lt_succ late) h b⟩

/-- Identity's `arisingFrom_not_stopping_covered`, unchanged. -/
theorem U4d.arisingFrom_not_stopping_covered {T : Nat}
    (covered : ∀ N, ∃ M, ∃ l : List F, N ≤ M ∧ ∀ f, W.active M f → f ∈ l)
    (noSplit : ∀ s, T ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f')
    (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) :
    ¬ ∃ N, ∀ t f, N ≤ t → ¬ W.ArisesFrom R t f :=
  fun ⟨N, quiet⟩ => U4d.cover_never_stops (R := continuationStep R) (E := W.activityOnward T)
    (τ := Prod.fst) (here := fun x => W.active x.1 x.2)
    U4d.cont_stage U4d.cont_keeps (U4d.cont_noSplit noSplit)
    (fun K => match covered K with
      | ⟨M, l, later, covers⟩ => ⟨M, l.map (fun f => (M, f)), later, U4d.cont_covers covers⟩)
    (fun K no => no (U4d.cont_ending ceasing K))
    ⟨N + T, fun y late h b => match y, late, h, b with
      | (0, _), late, _, _ => Nat.not_lt_zero _ late
      | (s + 1, f), late, h, b =>
        quiet s f (Nat.le_trans (Nat.le_add_right N T) (Nat.le_of_lt_succ late))
          (U4d.cont_arises (Nat.le_trans (Nat.le_add_left T N) (Nat.le_of_lt_succ late)) h b)⟩

/-- Identity's `ceasingFrom_not_stopping_covered`, unchanged, as the converse run law. -/
theorem U4d.ceasingFrom_not_stopping_covered {T : Nat} {L : List F}
    (covers : ∀ t, T ≤ t → ∀ f, W.active t f → f ∈ L)
    (noMerge : ∀ s, T ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f → R s g' f →
      W.active (s + 1) f → g = g')
    (arising : W.UnceasingFrom R) : ¬ ∃ N, ∀ t g, N ≤ t → ¬ W.CeasesFrom R t g :=
  fun ⟨N, quiet⟩ => U4d.cover_converse (R := continuationStep R) (E := W.activityOnward T)
    (τ := Prod.fst) (here := fun x => W.active x.1 x.2) (K := L.length) (T := T)
    U4d.cont_stage U4d.cont_keepsOn (U4d.cont_noMerge noMerge)
    (fun S from_ => ⟨L.map (fun f => (S, f)), Nat.le_of_eq (length_map _ L),
      U4d.cont_covers (covers S from_)⟩)
    (fun K => match arising K with
      | ⟨t, f, later, arises⟩ =>
        ⟨(t + 1, f), Nat.le_succ_of_le later, arises.1, U4d.cont_begins arises⟩)
    ⟨N + T, fun x late h en => match x, late, h, en with
      | (t, g), late, h, en => quiet t g (Nat.le_trans (Nat.le_add_right N T) late)
          (U4d.cont_ceases (Nat.le_trans (Nat.le_add_left T N) late) h en)⟩

end U4dIdentity

end Web

end Becoming
