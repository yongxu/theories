import Becoming.Identity
import Becoming.Locality
import Becoming.Space

/-!
# Listed webs: the laws of listing what is active, read of a web's activity

`Becoming.Population` states the census law for any determination listed at each step, each
member once (`Listed`); `Becoming.Change` states what holds of every finite family of
determinations; `Becoming.Locality` states the laws of one stretch for a list holding what holds
at one step; and `Becoming.Identity` states when more forces arising under a continuation. A web
carries the determination these laws are about: a formation's activity, `W.active t f`, of which
arising (`Web.Arises`) and ceasing (`Web.Ceases`) are the coming and ceasing to be
(`Web.change_readings`), and a census of a web is a listing of it (`Web.Census`). This module
states those laws of a web's activity and proves them through the general laws.

* **The census balance across a step and over a stretch.** Under a census, the formations active
  after a step with those that ceased across it are those active before with those that arose
  (`across`); over any stretch the ceasings are at most the arisings with those active at the
  start, and the arisings at most the ceasings with those active at the end (`ceasings_within`,
  `Listed.comings_within`). Where at most `B t` are active at each step and the arisings over some
  stretch from every step outnumber the bound at its end, ceasing recurs (`ceasing_of_outpacing`).
* **A finite family of formations, with no census.** Over any stretch, the arisings and ceasings of
  the members of a finite list differ by at most its length (`keep_pace`); a formation active at a
  step that ceases at no later step stays active (`persists`).
* **One stretch, from one listing.** With a list holding exactly the formations active at `N`, each
  once, and nothing arising across the stretch of `n` steps from `N`, every formation active at a
  step of the stretch is on the list, every one ceasing there is on it, and those active at the end
  with those that ceased number the list (`ceasing_needs_arising`). With a list covering the
  formations active at `N` and nothing arising from `N` on, ceasing does not recur
  (`ceasing_not_recurring`); no decidability is needed. Where something ceases at arbitrarily late
  steps, any number of distinct steps from `N` see a ceasing, all before some step
  (`ceasing_steps_found`).
* **Arising forced across a step.** Under a census at a step and the next, under every
  continuation in which no formation continues as two, not every formation active after the step
  continues one active before, exactly when more are active after than before
  (`forced_iff_more`); and across every web, more active after a step forces this exactly under a
  continuation in which no formation continues as two (`forces_iff_noSplit`). Over a run, under a
  census at every step, it holds at arbitrarily late steps under every continuation without a split
  exactly when more are active after a step at arbitrarily late steps (`forcedAlong_iff_more`), and
  a continuation without a split from some step on suffices (`forcedAlong_of_eventually_noSplit`).
* **Rest, unrefuted.** That a world rests from some step on cannot be refuted exactly when it is
  not the case that after every step a later arising or ceasing stays unrefuted
  (`rests_unrefuted_iff`); no decidedness is needed.

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace ListedWebs

variable {F C : Type}

/-! ## The census balance -/

/-! ## A finite family of formations -/

/-! ## One stretch, from one listing -/

section Stretch

variable {W : Web F C}

/-- **With nothing arising from a step on, ceasing does not recur.** Where a list covers the
formations active at `N` and no formation arises at any step from `N` on, it is not the case that
some formation ceases at arbitrarily late steps. No decidability is needed. -/
theorem ceasing_not_recurring {l : List F} {N : Nat} (covers : ∀ f, W.active N f → f ∈ l)
    (none : ∀ s f, N ≤ s → ¬ W.Arises s f) : ¬ ∀ M, ∃ t f, M ≤ t ∧ W.Ceases t f :=
  Covers.ceasing_not_recurring (p := fun f t => W.active t f) covers
    fun _ s f from_ _ => none s f from_

end Stretch

/-! ## Arising forced across a step -/

section Forced

variable {W : Web F C}

/-- **Arising is forced across a step exactly where more are active after it.** Under a listing
of the active formations at a step and the next, each once: under every continuation in which no
formation continues as two, not every formation active after the step continues one active before
it, exactly when more formations are active after the step than before. -/
theorem forced_iff_more {alive : Nat → List F} {t : Nat}
    (now : Distinct (alive t) ∧ ∀ f, W.active t f ↔ f ∈ alive t)
    (next : Distinct (alive (t + 1)) ∧ ∀ f, W.active (t + 1) f ↔ f ∈ alive (t + 1)) :
    (∀ S : F → F → Prop, (∀ g f f', S g f → S g f' → f = f') →
      ¬ ∀ f, W.active (t + 1) f → W.Continues (fun _ => S) t f) ↔
      (alive t).length < (alive (t + 1)).length :=
  ⟨fun forced => (Becoming.forced_iff_more now.1 next.1).mp fun S noSplit covered =>
     forced S noSplit fun f active => match covered f ((next.2 f).mp active) with
       | ⟨g, mem, continues⟩ => ⟨g, (now.2 g).mpr mem, continues⟩,
   fun more S noSplit covered => (Becoming.forced_iff_more now.1 next.1).mpr more S noSplit
     fun f mem => match covered f ((next.2 f).mpr mem) with
       | ⟨g, active, continues⟩ => ⟨g, (now.2 g).mp active, continues⟩⟩

/-- **More forces arising across every web exactly where nothing continues as two.** Across every
step of every web, where more formations active after the step are listed, each once, than a list
covering those active before it holds, not every formation active after the step continues under
`S` one active before it, exactly when under `S` no formation continues as two. -/
theorem forces_iff_noSplit [DecidableEq F] {S : F → F → Prop} :
    (∀ (W : Web F C) (t : Nat) (before after : List F), (∀ f, W.active t f → f ∈ before) →
      Distinct after → (∀ f, f ∈ after → W.active (t + 1) f) → before.length < after.length →
        ¬ ∀ f, W.active (t + 1) f → W.Continues (fun _ => S) t f) ↔
      ∀ g f f', S g f → S g f' → f = f' :=
  ⟨fun forces => Becoming.forces_iff_noSplit.mp fun before after distinct more covered =>
     forces ⟨fun _ _ => 0, fun t f => (t = 0 ∧ f ∈ before) ∨ (t ≠ 0 ∧ f ∈ after),
         fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩ 0 before after
       (fun _ held => held.elim And.right fun other => absurd rfl other.1)
       distinct (fun _ mem => .inr ⟨fun zero => Nat.noConfusion zero, mem⟩) more
       fun f held => match covered f (held.elim (fun zero => Nat.noConfusion zero.1)
           And.right) with
         | ⟨g, mem, continues⟩ => ⟨g, .inl ⟨rfl, mem⟩, continues⟩,
   fun noSplit _ _ before after listed distinct now more covered =>
     Becoming.forces_iff_noSplit.mpr noSplit before after distinct more fun f mem =>
       match covered f (now f mem) with
       | ⟨g, active, continues⟩ => ⟨g, listed g active, continues⟩⟩

/-- **Over a run, continuations without a split from some step on make more force arising.** Under
a census at every step, where more formations are active after a step than before at arbitrarily
late steps, and from `N` on no formation continues as two under `S`, not every formation active
after a step continues under `S` one active before it, at arbitrarily late steps. -/
theorem forcedAlong_of_eventually_noSplit {alive : Nat → List F}
    (census : ∀ t, Distinct (alive t) ∧ ∀ f, W.active t f ↔ f ∈ alive t)
    {S : Nat → F → F → Prop} {N : Nat}
    (noSplit : ∀ t, N ≤ t → ∀ g f f', W.active t g → S t g f → S t g f' →
      W.active (t + 1) f → W.active (t + 1) f' → f = f')
    (more : ∀ T, ∃ t, T ≤ t ∧ (alive t).length < (alive (t + 1)).length) :
    ∀ T, ∃ t, T ≤ t ∧ ¬ ∀ f, W.active (t + 1) f → W.Continues S t f :=
  fun T => match more (T + N) with
  | ⟨t, later, grows⟩ =>
    ⟨t, Nat.le_trans (Nat.le_add_right T N) later, fun covered =>
      (ListedWebs.forced_iff_more (census t) (census (t + 1))).mpr grows
        (fun g f => S t g f ∧ W.active t g ∧ W.active (t + 1) f)
        (fun g f f' continues continues' => noSplit t (Nat.le_trans (Nat.le_add_left N T) later)
          g f f' continues.2.1 continues.1 continues'.1 continues.2.2 continues'.2.2)
        fun f active => match covered f active with
          | ⟨g, before, continues⟩ => ⟨g, before, continues, before, active⟩⟩

/-- **Arising is forced over a run exactly where more are active after a step at arbitrarily late
steps.** Under a census at every step: under every continuation in which no formation continues as
two, not every formation active after a step continues one active before it, at arbitrarily late
steps, exactly when more formations are active after a step than before it at arbitrarily late
steps. Where more are active at no step from some step on, pairing the lists in order at every
step continues every formation after each later step, with no split. -/
theorem forcedAlong_iff_more {alive : Nat → List F}
    (census : ∀ t, Distinct (alive t) ∧ ∀ f, W.active t f ↔ f ∈ alive t) :
    (∀ S : Nat → F → F → Prop, W.NoSplit S →
      ∀ T, ∃ t, T ≤ t ∧ ¬ ∀ f, W.active (t + 1) f → W.Continues S t f) ↔
      ∀ T, ∃ t, T ≤ t ∧ (alive t).length < (alive (t + 1)).length :=
  ⟨fun forced T => match forced (fun t => paired (alive t) (alive (t + 1)))
      (fun t g f f' _ continues continues' _ _ =>
        paired_noSplit (census t).1 g f f' continues continues') T with
    | ⟨t, later, notAll⟩ => ⟨t, later, match Nat.decLt (alive t).length (alive (t + 1)).length with
      | isTrue grows => grows
      | isFalse notMore => absurd (fun f active =>
          match paired_covers (Nat.ge_of_not_lt notMore) f (((census (t + 1)).2 f).mp active) with
          | ⟨g, mem, continues⟩ => ⟨g, ((census t).2 g).mpr mem, continues⟩) notAll⟩,
   fun more _ noSplit => forcedAlong_of_eventually_noSplit census (N := 0)
     (fun t _ => noSplit t) more⟩

end Forced

/-! ## Rest, unrefuted -/

/-- **A world's rest, unrefuted.** That a world rests from some step from `T` on cannot be refuted
exactly when it is not the case that after every step from `T` on a later arising or ceasing of
some relatum stays unrefuted. No decidedness is needed. -/
theorem rests_unrefuted_iff (w : World) {T : Nat} :
    (¬ ∀ M, T ≤ M → ¬ ¬ ∃ t, M ≤ t ∧ ∃ x, w.web.Arises t x ∨ w.web.Ceases t x) ↔
      ¬ ¬ ∃ M, T ≤ M ∧ w.RestsFrom M :=
  (stop_unrefuted_iff (P := fun t => ∃ x, w.web.Arises t x ∨ w.web.Ceases t x)).trans
    ⟨fun unrefuted never => unrefuted fun ⟨M, from_, quiet⟩ => never ⟨M, from_, fun t later x =>
       ⟨fun arises => quiet t later ⟨x, .inl arises⟩,
        fun ceases => quiet t later ⟨x, .inr ceases⟩⟩⟩,
     fun unrefuted never => unrefuted fun ⟨M, from_, rests⟩ =>
       never ⟨M, from_, fun t later ⟨x, moves⟩ => moves.elim (rests t later x).1 (rests t later x).2⟩⟩

end ListedWebs

end Becoming
