import Becoming.Locality
import Becoming.Identity
import Becoming.Decidedness
import Becoming.U4dCover
import Becoming.U4dNeeded

/-! U4d scratch: Locality's, Decidedness' and Identity's covering laws re-proved as cases of the root
forms in `U4dCover`, each statement the package's own, unchanged. Not part of the package. -/

namespace Becoming

/-! ### Lists: general lemmas, for the prelude -/

section U4dLists

variable {β γ : Type}

/-- A list with, for each member, some partner gives a list of pairs over it. -/
theorem U4d.pick {Q : β → γ → Prop} : ∀ {E : List β}, (∀ t, t ∈ E → ∃ a, Q t a) →
    ∃ D : List (β × γ), D.map Prod.fst = E ∧ ∀ x, x ∈ D → Q x.1 x.2
  | [], _ => ⟨[], rfl, fun _ mem => nomatch mem⟩
  | t :: E, each =>
    match each t (.head E), U4d.pick (E := E) (fun s mem => each s (.tail t mem)) with
    | ⟨a, qa⟩, ⟨D, same, all⟩ => ⟨(t, a) :: D, congrArg (t :: ·) same, fun x mem =>
        match ListTests.mem_cons_iff.mp mem with
        | .inl e => Eq.subst (motive := fun y : β × γ => Q y.1 y.2) e.symm qa
        | .inr mem => all x mem⟩

/-- A list whose image has no repetition has none. -/
theorem U4d.distinct_of_map {f : β → γ} : ∀ {D : List β}, Distinct (D.map f) → Distinct D
  | [], _ => trivial
  | _ :: _, ⟨fresh, rest⟩ =>
    ⟨fun mem => fresh (ListTests.mem_map_of mem), U4d.distinct_of_map rest⟩

end U4dLists

/-! ### Locality: a relatum's occurrences along its steps -/

section U4dLocality

variable {α : Type} {p : α → Nat → Prop}

theorem U4d.along_stage :
    ∀ x y : Nat × α, «续» Steps.along (Steps.alikeAt p) x y → y.1 = x.1 + 1 :=
  fun _ _ ⟨⟨next, _⟩, _⟩ => next

/-- What holds of an occurrence is a region nothing outside continues into. -/
theorem U4d.along_back :
    «闭» («逆» («续» Steps.along (Steps.alikeAt p))) (fun x : Nat × α => p x.2 x.1) :=
  fun _ _ h ⟨_, alike⟩ => alike.mpr h

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
  match U4d.cover_from (τ := Prod.fst) (P := fun x : Nat × α => p x.2 x.1)
      U4d.along_stage U4d.along_back U4d.along_noSplit (U4d.along_covers covers)
      (fun y h _ => U4d.along_decided y h) (U4d.along_ending ceasing) with
  | ⟨(0, _), late, _, _⟩ => absurd late (Nat.not_lt_zero N)
  | ⟨(t + 1, a), late, h, b⟩ =>
    ⟨t, a, Nat.le_of_lt_succ late, comesToBe_iff_sheng_along.mpr ⟨h, b⟩⟩

/-- Locality's `coming_of_ceasing_covered`, the statement unchanged, as the decided run law. -/
theorem U4d.coming_of_ceasing_covered [∀ a t, Decidable (p a t)]
    (covered : ∀ M, ∃ N L, M ≤ N ∧ Covers p L N)
    (ceasing : ∀ M, ∃ t a, M ≤ t ∧ CeasesToBe (p a) t) :
    ∀ M, ∃ t a, M ≤ t ∧ ComesToBe (p a) t :=
  fun M => match U4d.cover_run (τ := Prod.fst) (P := fun x : Nat × α => p x.2 x.1) (T := 0)
      U4d.along_stage U4d.along_back U4d.along_noSplit
      (fun K => match covered K with
        | ⟨N, L, later, covers⟩ => ⟨N, L.map (fun a => (N, a)), later, U4d.along_covers covers⟩)
      (fun y h _ => U4d.along_decided y h) (U4d.along_ending ceasing) M with
  | ⟨(0, _), late, _, _⟩ => absurd late (Nat.not_lt_zero M)
  | ⟨(t + 1, a), late, h, b⟩ =>
    ⟨t, a, Nat.le_of_lt_succ late, comesToBe_iff_sheng_along.mpr ⟨h, b⟩⟩

/-- Locality's `Covers.not_not_coming_from`, unchanged, as the undecided law from one list. -/
theorem U4d.not_not_coming_from {L : List α} {N : Nat} (covers : Covers p L N)
    (ceasing : ∀ M, ¬ ¬ ∃ t a, M ≤ t ∧ CeasesToBe (p a) t) :
    ¬ ¬ ∃ s a, N ≤ s ∧ ComesToBe (p a) s :=
  fun nothing => U4d.cover_unrefuted (τ := Prod.fst) (P := fun x : Nat × α => p x.2 x.1)
    U4d.along_stage U4d.along_back U4d.along_noSplit (U4d.along_covers covers)
    (fun M no => ceasing M fun ⟨t, a, later, ceases⟩ =>
      no ⟨(t, a), later, ceasesToBe_iff_wang_along.mp ceases⟩)
    fun ⟨y, late, h, b⟩ => match y, late, h, b with
      | (0, _), late, _, _ => Nat.not_lt_zero N late
      | (t + 1, a), late, h, b =>
        nothing ⟨t, a, Nat.le_of_lt_succ late, comesToBe_iff_sheng_along.mpr ⟨h, b⟩⟩

/-- Locality's `Covers.ceasing_stops_unrefuted`, unchanged, from `Covers.not_not_coming_from`. -/
theorem U4d.ceasing_stops_unrefuted {L : List α} {N : Nat} (covers : Covers p L N)
    (none : ∀ n, NoneComes p N n) : ¬ ∀ M, ¬ ¬ ∃ t a, M ≤ t ∧ CeasesToBe (p a) t :=
  fun ceasing => U4d.not_not_coming_from covers ceasing fun ⟨s, a, from_, comes⟩ =>
    none (s + 1) s a from_
      (Nat.lt_of_lt_of_le (Nat.lt_succ_self s) (Nat.le_add_left (s + 1) N)) comes

/-- Locality's `Covers.ceasing_steps_within`, unchanged, as the stretch form. -/
theorem U4d.ceasing_steps_within {L : List α} {N n : Nat} (covers : Covers p L N)
    (none : NoneComes p N n) {E : List Nat} (distinct : Distinct E)
    (ceasing : ∀ t, t ∈ E → N ≤ t ∧ t < N + n ∧ ∃ a, CeasesToBe (p a) t) :
    E.length ≤ L.length :=
  match U4d.pick (Q := fun t a => N ≤ t ∧ t < N + n ∧ CeasesToBe (p a) t)
      (fun t mem => match ceasing t mem with
        | ⟨from_, below, a, ceases⟩ => ⟨a, from_, below, ceases⟩) with
  | ⟨D, same, all⟩ =>
    Nat.le_trans (Nat.le_of_eq ((congrArg List.length same).symm.trans (length_map Prod.fst D)))
      (Nat.le_trans (U4d.cover_within (τ := Prod.fst) (P := fun x : Nat × α => p x.2 x.1)
          (U := N + n) U4d.along_stage U4d.along_back U4d.along_noSplit (U4d.along_covers covers)
          (fun z hz late below b => match z, hz, late, below, b with
            | (0, _), _, late, _, _ => Nat.not_lt_zero N late
            | (s + 1, c), hz, late, below, b => none s c (Nat.le_of_lt_succ late)
                (Nat.lt_trans (Nat.lt_succ_self s) below) (comesToBe_iff_sheng_along.mpr ⟨hz, b⟩))
          (U4d.distinct_of_map (Eq.subst (motive := Distinct) same.symm distinct))
          fun x mx => ⟨(all x mx).1, (all x mx).2.1, (all x mx).2.2.1,
            (ceasesToBe_iff_wang_along.mp (all x mx).2.2).2⟩)
        (Nat.le_of_eq (length_map _ L)))

end U4dLocality

/-! ### Decidedness: a finite family's occurrences along its steps -/

section U4dFamily

variable {α : Type} {as : List α} {p : α → Nat → Prop}

/-- What holds of a member of the family is a region nothing outside continues into. -/
theorem U4d.family_back : «闭» («逆» («续» Steps.along (Steps.alikeAt p)))
    (fun x : Nat × α => x.2 ∈ as ∧ p x.2 x.1) :=
  fun _ _ ⟨mem, h⟩ ⟨⟨_, same⟩, alike⟩ => ⟨Eq.subst (motive := (· ∈ as)) same mem, alike.mpr h⟩

/-- And nothing in it continues out of it. -/
theorem U4d.family_on : «闭» («续» Steps.along (Steps.alikeAt p))
    (fun x : Nat × α => x.2 ∈ as ∧ p x.2 x.1) :=
  fun _ _ ⟨mem, h⟩ ⟨⟨_, same⟩, alike⟩ => ⟨Eq.subst (motive := (· ∈ as)) same.symm mem, alike.mp h⟩

theorem U4d.family_noMerge :
    ∀ v a a' : Nat × α, (a.2 ∈ as ∧ p a.2 a.1) → (a'.2 ∈ as ∧ p a'.2 a'.1) →
      «续» Steps.along (Steps.alikeAt p) a v → «续» Steps.along (Steps.alikeAt p) a' v → a = a' :=
  fun _ _ _ _ _ ⟨⟨n, s⟩, _⟩ ⟨⟨n', s'⟩, _⟩ => U4d.pair_eq (Nat.succ.inj (n.symm.trans n'))
    (s.symm.trans s')

theorem U4d.family_covers (S : Nat) :
    ∀ x : Nat × α, (x.2 ∈ as ∧ p x.2 x.1) → x.1 = S → x ∈ as.map (fun a => (S, a))
  | (_, _), ⟨mem, _⟩, rfl => ListTests.mem_map_of mem

/-- Decidedness' `ceasing_steps_within`, unchanged, as the stretch form. -/
theorem U4d.family_ceasing_steps_within {M U : Nat}
    (still : ∀ s a, M ≤ s → s < U → a ∈ as → ¬ ComesToBe (p a) s) {E : List Nat}
    (distinct : Distinct E)
    (ceasing : ∀ t, t ∈ E → M ≤ t ∧ t < U ∧ ∃ a, a ∈ as ∧ CeasesToBe (p a) t) :
    E.length ≤ as.length :=
  match U4d.pick (Q := fun t a => M ≤ t ∧ t < U ∧ a ∈ as ∧ CeasesToBe (p a) t)
      (fun t mem => match ceasing t mem with
        | ⟨from_, below, a, member, ceases⟩ => ⟨a, from_, below, member, ceases⟩) with
  | ⟨D, same, all⟩ =>
    Nat.le_trans (Nat.le_of_eq ((congrArg List.length same).symm.trans (length_map Prod.fst D)))
      (Nat.le_trans (U4d.cover_within (τ := Prod.fst)
          (P := fun x : Nat × α => x.2 ∈ as ∧ p x.2 x.1) (U := U)
          U4d.along_stage U4d.family_back
          (fun v b b' _ _ c c' => «定后之逐点».mp (Steps.along_fixed (Steps.alikeAt p)) v b b' c c')
          (U4d.family_covers M)
          (fun z hz late below b => match z, hz, late, below, b with
            | (0, _), _, late, _, _ => Nat.not_lt_zero M late
            | (s + 1, c), hz, late, below, b => still s c (Nat.le_of_lt_succ late)
                (Nat.lt_trans (Nat.lt_succ_self s) below) hz.1
                (comesToBe_iff_sheng_along.mpr ⟨hz.2, b⟩))
          (U4d.distinct_of_map (Eq.subst (motive := Distinct) same.symm distinct))
          fun x mx => ⟨(all x mx).1, (all x mx).2.1, ⟨(all x mx).2.2.1, (all x mx).2.2.2.1⟩,
            (ceasesToBe_iff_wang_along.mp (all x mx).2.2.2).2⟩)
        (Nat.le_of_eq (length_map _ as)))

/-- Decidedness' `coming_steps_within`, unchanged, as the stretch form's mirror: the beginnings are
the occurrences a step after each coming to be. -/
theorem U4d.family_coming_steps_within {M U : Nat}
    (still : ∀ s a, M ≤ s → s < U → a ∈ as → ¬ CeasesToBe (p a) s) {E : List Nat}
    (distinct : Distinct E)
    (coming : ∀ t, t ∈ E → M ≤ t ∧ t < U ∧ ∃ a, a ∈ as ∧ ComesToBe (p a) t) :
    E.length ≤ as.length :=
  match U4d.pick (Q := fun t a => M ≤ t ∧ t < U ∧ a ∈ as ∧ ComesToBe (p a) t)
      (fun t mem => match coming t mem with
        | ⟨from_, below, a, member, comes⟩ => ⟨a, from_, below, member, comes⟩) with
  | ⟨D, same, all⟩ =>
    have next : ∀ x : Nat × α, x ∈ D.map (fun x => (x.1 + 1, x.2)) →
        M ≤ x.1 ∧ x.1 ≤ U ∧ (x.2 ∈ as ∧ p x.2 x.1) ∧ «生» Steps.along (Steps.alikeAt p) x :=
      fun _ mx => match ListTests.mem_map_iff.mp mx with
      | ⟨y, my, e⟩ => Eq.subst (motive := fun x : Nat × α => M ≤ x.1 ∧ x.1 ≤ U ∧
            (x.2 ∈ as ∧ p x.2 x.1) ∧ «生» Steps.along (Steps.alikeAt p) x) e
          ⟨Nat.le_succ_of_le (all y my).1, (all y my).2.1, ⟨(all y my).2.2.1, (all y my).2.2.2.2⟩,
            (comesToBe_iff_sheng_along.mp (all y my).2.2.2).2⟩
    Nat.le_trans (Nat.le_of_eq ((congrArg List.length same).symm.trans (length_map Prod.fst D)))
      (Nat.le_trans (Nat.le_of_eq (length_map _ D).symm)
        (Nat.le_trans (U4d.cover_within_converse (τ := Prod.fst)
            (P := fun x : Nat × α => x.2 ∈ as ∧ p x.2 x.1) (N := M) (U := U)
            U4d.along_stage U4d.family_on U4d.family_noMerge (U4d.family_covers U)
            (fun z hz from_ below en => match z, hz, from_, below, en with
              | (s, c), hz, from_, below, en => still s c from_ below hz.1
                  (ceasesToBe_iff_wang_along.mpr ⟨hz.2, en⟩))
            (distinct_map_on (g := fun x : Nat × α => (x.1 + 1, x.2)) (fun x y _ _ same' => U4d.pair_eq
                (Nat.succ.inj (congrArg (a₁ := (x.1 + 1, x.2)) (a₂ := (y.1 + 1, y.2)) Prod.fst same'))
                (congrArg (a₁ := (x.1 + 1, x.2)) (a₂ := (y.1 + 1, y.2)) Prod.snd same'))
              (U4d.distinct_of_map (Eq.subst (motive := Distinct) same.symm distinct)))
            next)
          (Nat.le_of_eq (length_map _ as))))

end U4dFamily

/-! ### Identity: formations' occurrences under a continuation, within activity onward -/

namespace Web

section U4dIdentity

variable {F C : Type} {W : Web F C} {R : Nat → F → F → Prop}

theorem U4d.cont_stage {T : Nat} :
    ∀ x y : Nat × F, «续» (continuationStep R) (W.activityOnward T) x y → y.1 = x.1 + 1 :=
  fun _ _ ⟨⟨next, _⟩, _⟩ => next

/-- Activity is a region nothing outside continues into. -/
theorem U4d.cont_back {T : Nat} :
    «闭» («逆» («续» (continuationStep R) (W.activityOnward T))) (fun x => W.active x.1 x.2) :=
  fun _ _ _ ⟨_, _, _, active⟩ => active

/-- And nothing in it continues out of it. -/
theorem U4d.cont_on {T : Nat} :
    «闭» («续» (continuationStep R) (W.activityOnward T)) (fun x => W.active x.1 x.2) :=
  fun _ _ h ⟨_, alike, _, _⟩ => alike.mp h

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

/-- Identity's `not_not_arisingFrom_covered`, unchanged, as the undecided law from one list. -/
theorem U4d.not_not_arisingFrom_covered {M : Nat} {l : List F}
    (covers : ∀ f, W.active M f → f ∈ l)
    (noSplit : ∀ s, M ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f')
    (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) :
    ¬¬ ∃ s f, M ≤ s ∧ W.ArisesFrom R s f :=
  fun nothing => U4d.cover_unrefuted (R := continuationStep R) (E := W.activityOnward M)
    (τ := Prod.fst) (P := fun x => W.active x.1 x.2)
    U4d.cont_stage U4d.cont_back (U4d.cont_noSplit noSplit) (U4d.cont_covers covers)
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
    (τ := Prod.fst) (P := fun x => W.active x.1 x.2)
    U4d.cont_stage U4d.cont_back (U4d.cont_noSplit noSplit)
    (fun K => match covered K with
      | ⟨M, l, later, covers⟩ => ⟨M, l.map (fun f => (M, f)), later, U4d.cont_covers covers⟩)
    (fun K no => no (U4d.cont_ending ceasing K))
    ⟨N + T, fun y late h b => match y, late, h, b with
      | (0, _), late, _, _ => Nat.not_lt_zero _ late
      | (s + 1, f), late, h, b =>
        quiet s f (Nat.le_trans (Nat.le_add_right N T) (Nat.le_of_lt_succ late))
          (U4d.cont_arises (Nat.le_trans (Nat.le_add_left T N) (Nat.le_of_lt_succ late)) h b)⟩

/-- Identity's `ceasingFrom_not_stopping_covered`, unchanged, as the converse. -/
theorem U4d.ceasingFrom_not_stopping_covered {T : Nat} {L : List F}
    (covers : ∀ t, T ≤ t → ∀ f, W.active t f → f ∈ L)
    (noMerge : ∀ s, T ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f → R s g' f →
      W.active (s + 1) f → g = g')
    (arising : W.UnceasingFrom R) : ¬ ∃ N, ∀ t g, N ≤ t → ¬ W.CeasesFrom R t g :=
  fun ⟨N, quiet⟩ => U4d.cover_converse (R := continuationStep R) (E := W.activityOnward T)
    (τ := Prod.fst) (P := fun x => W.active x.1 x.2) (K := L.length) (T := T)
    U4d.cont_stage U4d.cont_on (U4d.cont_noMerge noMerge)
    (fun S from_ => ⟨L.map (fun f => (S, f)), Nat.le_of_eq (length_map _ L),
      U4d.cont_covers (covers S from_)⟩)
    (fun K => match arising K with
      | ⟨t, f, later, arises⟩ =>
        ⟨(t + 1, f), Nat.le_succ_of_le later, arises.1, U4d.cont_begins arises⟩)
    ⟨N + T, fun x late h en => match x, late, h, en with
      | (t, g), late, h, en => quiet t g (Nat.le_trans (Nat.le_add_right N T) late)
          (U4d.cont_ceases (Nat.le_trans (Nat.le_add_left T N) late) h en)⟩

/-! ### New at Identity: the exact forms from covering lists, the continuation decided -/

theorem U4d.cont_decided_begin {T : Nat} [∀ t f, Decidable (W.Continues R t f)] :
    ∀ y : Nat × F, W.active y.1 y.2 → T < y.1 →
      «生» (continuationStep R) (W.activityOnward T) y ∨
        «有前» (continuationStep R) (W.activityOnward T) y
  | (0, _), _, late => absurd late (Nat.not_lt_zero T)
  | (t + 1, f), h, late =>
    if continues : W.Continues R t f then
      match continues with
      | ⟨g, act, cont⟩ =>
        .inr ⟨(t, g), ⟨rfl, cont⟩, ⟨fun _ => h, fun _ => act⟩, Nat.le_of_lt_succ late, act⟩
    else .inl (U4d.cont_begins ⟨h, continues⟩)

theorem U4d.cont_decided_end {T : Nat} [∀ t g, Decidable (W.Continued R t g)] :
    ∀ x : Nat × F, W.active x.1 x.2 → T ≤ x.1 →
      «亡» (continuationStep R) (W.activityOnward T) x ∨
        «有后» (continuationStep R) (W.activityOnward T) x
  | (t, g), h, from_ => if continued : W.Continued R t g then
      match continued with
      | ⟨f, act, cont⟩ => .inr ⟨(t + 1, f), ⟨rfl, cont⟩, ⟨fun _ => act, fun _ => h⟩, from_, h⟩
    else .inl fun ⟨y, ⟨next, cont⟩, alike, _, _⟩ =>
      continued ⟨y.2, Eq.subst (motive := fun s => W.active s y.2) next (alike.mp h), cont⟩

/-- **New: the census law under a continuation from covering lists, exact.** With covering lists
at arbitrarily late steps, no splits from step `T` on, and whether a formation continues one active
before decided, ceasing under the continuation recurring needs arising under it recurring. -/
theorem U4d.arisingFrom_of_ceasingFrom_covered [∀ t f, Decidable (W.Continues R t f)] {T : Nat}
    (covered : ∀ N, ∃ M, ∃ l : List F, N ≤ M ∧ ∀ f, W.active M f → f ∈ l)
    (noSplit : ∀ s, T ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f')
    (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) : W.UnceasingFrom R :=
  fun N => match U4d.cover_run (R := continuationStep R) (E := W.activityOnward T)
      (τ := Prod.fst) (P := fun x => W.active x.1 x.2) (T := T)
      U4d.cont_stage U4d.cont_back (U4d.cont_noSplit noSplit)
      (fun K => match covered K with
        | ⟨M, l, later, covers⟩ => ⟨M, l.map (fun f => (M, f)), later, U4d.cont_covers covers⟩)
      U4d.cont_decided_begin (U4d.cont_ending ceasing) (N + T) with
  | ⟨(0, _), late, _, _⟩ => absurd late (Nat.not_lt_zero _)
  | ⟨(t + 1, f), late, h, b⟩ =>
    ⟨t, f, Nat.le_trans (Nat.le_add_right N T) (Nat.le_of_lt_succ late),
      U4d.cont_arises (Nat.le_trans (Nat.le_add_left T N) (Nat.le_of_lt_succ late)) h b⟩

/-- **New: its converse, exact.** With lists of at most `B` covering the active formations at each
step from `T` on, no merges from `T` on, and whether a formation is continued decided, arising under
the continuation recurring needs ceasing under it recurring. -/
theorem U4d.ceasingFrom_of_arisingFrom_covered [∀ t g, Decidable (W.Continued R t g)] {T B : Nat}
    (covers : ∀ t, T ≤ t → ∃ l : List F, l.length ≤ B ∧ ∀ f, W.active t f → f ∈ l)
    (noMerge : ∀ s, T ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f → R s g' f →
      W.active (s + 1) f → g = g')
    (arising : W.UnceasingFrom R) : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g :=
  fun N => match U4d.cover_converse_run (R := continuationStep R) (E := W.activityOnward T)
      (τ := Prod.fst) (P := fun x => W.active x.1 x.2) (K := B) (T := T)
      U4d.cont_stage U4d.cont_on (U4d.cont_noMerge noMerge)
      (fun S from_ => match covers S from_ with
        | ⟨l, short, covers⟩ => ⟨l.map (fun f => (S, f)),
            Nat.le_trans (Nat.le_of_eq (length_map _ l)) short, U4d.cont_covers covers⟩)
      U4d.cont_decided_end
      (fun K => match arising K with
        | ⟨t, f, later, arises⟩ =>
          ⟨(t + 1, f), Nat.le_succ_of_le later, arises.1, U4d.cont_begins arises⟩)
      (N + T) with
  | ⟨(t, g), late, h, en⟩ => ⟨t, g, Nat.le_trans (Nat.le_add_right N T) late,
      U4d.cont_ceases (Nat.le_trans (Nat.le_add_left T N) late) h en⟩

end U4dIdentity

/-! ### The decision the exact form asks, read at Identity (the review's witness) -/

namespace U4d.AtIdentity

/-- Two formations active at every step, conditions and amounts idle. -/
def web : Web Nat Unit :=
  ⟨fun _ _ => 0, fun _ f => f ≤ 1, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

/-- `0` continues as `0` where `Q`, as `1` where not. -/
def cont (Q : Prop) : Nat → Nat → Nat → Prop := fun _ g f => g = 0 ∧ ((f = 0 ∧ Q) ∨ (f = 1 ∧ ¬ Q))

theorem two (f : Nat) (h : f ≤ 1) : f ∈ [0, 1] :=
  match U4d.Needed.le_one h with
  | .inl e => Eq.subst (motive := (· ∈ [0, 1])) e.symm (.head _)
  | .inr e => Eq.subst (motive := (· ∈ [0, 1])) e.symm (.tail _ (.head _))

/-- At Identity, every hypothesis of the exact form (covering lists, no split) and ceasing
recurring hold for any `Q`; whether a formation continues one active before is decided exactly
where `Q` is, and arising recurs exactly where `¬ Q ∨ ¬¬ Q`. -/
theorem exact_needs_decision (Q : Prop) :
    (∀ N, ∃ M, ∃ l : List Nat, N ≤ M ∧ ∀ f, web.active M f → f ∈ l) ∧
    (∀ s, 0 ≤ s → ∀ g f f', web.active s g → cont Q s g f → cont Q s g f' →
      web.active (s + 1) f → web.active (s + 1) f' → f = f') ∧
    (∀ N, ∃ t g, N ≤ t ∧ web.CeasesFrom (cont Q) t g) ∧
    ((∀ t f, web.Continues (cont Q) t f ∨ ¬ web.Continues (cont Q) t f) ↔ (Q ∨ ¬ Q)) ∧
    (web.UnceasingFrom (cont Q) ↔ (¬ Q ∨ ¬¬ Q)) :=
  ⟨fun N => ⟨N, [0, 1], Nat.le_refl N, two⟩,
   fun _ _ _ _ _ _ c c' _ _ => match c.2, c'.2 with
     | .inl ⟨e, _⟩, .inl ⟨e', _⟩ => e.trans e'.symm
     | .inr ⟨e, _⟩, .inr ⟨e', _⟩ => e.trans e'.symm
     | .inl ⟨_, q⟩, .inr ⟨_, nq⟩ => (nq q).elim
     | .inr ⟨_, nq⟩, .inl ⟨_, q⟩ => (nq q).elim,
   fun N => ⟨N, 1, Nat.le_refl N, Nat.le_refl 1, fun ⟨_, _, c⟩ => Nat.noConfusion c.1⟩,
   ⟨fun decided => match decided 0 0 with
      | .inl ⟨_, _, c⟩ => match c.2 with
        | .inl ⟨_, q⟩ => .inl q
        | .inr ⟨e, _⟩ => Nat.noConfusion e
      | .inr nothing => .inr fun q => nothing ⟨0, Nat.zero_le 1, rfl, .inl ⟨rfl, q⟩⟩,
    fun lem _ f => match f, lem with
      | 0, .inl q => .inl ⟨0, Nat.zero_le 1, rfl, .inl ⟨rfl, q⟩⟩
      | 0, .inr nq => .inr fun ⟨_, _, c⟩ => match c.2 with
        | .inl ⟨_, q⟩ => nq q
        | .inr ⟨e, _⟩ => Nat.noConfusion e
      | 1, .inl q => .inr fun ⟨_, _, c⟩ => match c.2 with
        | .inl ⟨e, _⟩ => Nat.noConfusion e
        | .inr ⟨_, nq⟩ => nq q
      | 1, .inr nq => .inl ⟨0, Nat.zero_le 1, rfl, .inr ⟨rfl, nq⟩⟩
      | _ + 2, _ => .inr fun ⟨_, _, c⟩ => match c.2 with
        | .inl ⟨e, _⟩ => Nat.noConfusion e
        | .inr ⟨e, _⟩ => Nat.noConfusion (Nat.succ.inj e)⟩,
   ⟨fun unceasing => match unceasing 0 with
      | ⟨_, f, _, active, alone⟩ => match f, active with
        | 0, _ => .inl fun q => alone ⟨0, Nat.zero_le 1, rfl, .inl ⟨rfl, q⟩⟩
        | 1, _ => .inr fun nq => alone ⟨0, Nat.zero_le 1, rfl, .inr ⟨rfl, nq⟩⟩
        | a + 2, active => absurd (Nat.le_of_succ_le_succ active) (Nat.not_succ_le_zero a),
    fun wlem N => match wlem with
      | .inl nq => ⟨N, 0, Nat.le_refl N, Nat.zero_le 1, fun ⟨_, _, c⟩ => match c.2 with
          | .inl ⟨_, q⟩ => nq q
          | .inr ⟨e, _⟩ => Nat.noConfusion e⟩
      | .inr nnq => ⟨N, 1, Nat.le_refl N, Nat.le_refl 1, fun ⟨_, _, c⟩ => match c.2 with
          | .inl ⟨e, _⟩ => Nat.noConfusion e
          | .inr ⟨_, nq⟩ => nnq nq⟩⟩⟩

end U4d.AtIdentity

end Web

end Becoming
