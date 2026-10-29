import Becoming.Grammar

/-!
# What choices show of the order they come from (所择之示)

At each occasion of choosing, what is open is any predicate and one alternative is chosen.
Whatever reads the choices (read, an outer training reading what a trained law does, or a helper
reading what it assists) goes through the occasions and what was chosen at them only. This module states, for every carrier of alternatives and every family of occasions,
which positive comparisons every strict order the choices could come from shares, and where none is
forced. The statements are on the grammar (`Becoming.Grammar`): the shown relation is one of its
relations (`«际»`), and the comparisons shared are its reach (`«及»`).

* **What is shown.** The choices show `x` above `y` where at some occasion `x` is chosen while `y`,
  another, is open (`ChoiceOccasions.Shown`). A relation accords with the choices where at every
  occasion what is chosen stands above every other alternative open there (`Accords`), a strict
  dominance; it accords weakly where nothing open stands above what is chosen (`AccordsWeakly`).
* **What accords contains the shown reach.** Every transitive relation according with the choices
  contains the reach of the shown relation (`reach_within`); the shown relation and its reach accord
  (`shown_accords`, `reach_accords`).
* **Choices come from a strict order exactly where nothing shown returns.** Some irreflexive
  transitive relation accords with the choices exactly where the shown relation has no cycle
  (`accorded_iff_noCycle`, by the grammar's reach and its transitivity).
* **The comparisons shared are the shown reach.** With no cycle shown, the positive comparisons
  shared by every strict order according with the choices are exactly the shown reach
  (`above_in_every_iff_reach`). Standing above every other alternative of a menu in every such order
  is exactly reaching each of them (`top_in_every_iff_reach`); that says nothing of whether the
  alternative is open there or chosen. A narrower class of strict according orders makes every
  comparison that every strict according order makes (`above_in_class_of_every`).
* **Beyond the shown reach no comparison is forced.** Reach with one pair added is reach without it,
  or a path through the pair: from the pair's first member or what reaches it, to its second member
  or what it reaches (`reach_withPair_iff`), and
  adding a pair leaves no cycle exactly where there was none and the pair's second member neither is
  nor reaches its first (`noCycle_withPair_iff`). So with no cycle shown, where `y` does not reach
  `x` and the two differ, some strict order according with the choices puts `x` above `y`
  (`above_in_some_of_unreached`); where neither reaches the other, orders rank the two both ways
  (`both_ways_of_unreached`).
* **Choices required only to be maximal force no positive comparison.** The empty relation is a
  strict order according weakly with every choice (`weakly_forces_no_comparison`). Such choices still
  exclude any open alternative standing above the chosen one.
* **A witness, with one search procedure.** One occasion, two alternatives open and the first
  chosen, a third never met: every according relation puts the first above the second, and strict
  orders according with the choice rank the first and the third both ways (`Untried`). One search,
  run with either of two strict orders according with the choice, chooses alike on the menu met and
  apart on the menu met after (`Untried.same_search_met`, `Untried.same_search_after`).

**Readings** (the AI's; correspondences, not theorems).
- *Inner alignment and goal misgeneralization.* If a training observes only a trained law's choices
  and imposes no further restriction on the orders it could carry, comparisons between two distinct
  alternatives neither of which reaches the other in the shown relation remain ambiguous. `Untried` realizes different
  later choices with one search procedure and two compatible orders. That a training installs
  either, and that either disagrees with an independently stated objective, are not proved.
- *Inverse reinforcement learning and assistance.* For a helper reading a principal's choices, a
  positive comparison beyond the shown reach needs information or premises beyond these strict
  choices. That maximal choices force no positive comparison is the degenerate-reward result in
  order form (Ng and Russell 2000). That behaviour fixes a planner and a reward together only under
  assumptions on the planner (Armstrong and Mindermann 2018) lies outside: accordance fixes the
  planner here.
- *Revealed preference.* `accorded_iff_noCycle` and `above_in_every_iff_reach` are the order form of
  rationalizing strict choices by a strict partial order, close to Richter's theorem (1966). They are
  not Afriat's theorem, which concerns expenditure data and utility; no total order, utility or
  optimizer is derived here.

**What is not derived.** Which order an actual chooser carries, or that it chooses by one at all;
that it chooses strictly; which class of orders an actual architecture can install (a narrower
class makes at least the comparisons every strict according order makes, `above_in_class_of_every`,
and possibly more, which is that class's bias, not a premise here); that a training can install either
order of the witness; choice under noise or with probabilities; and anything a reader of the choices
can learn from more than the choices (reports, internal states, interventions). The carrier and the
occasions are any types, and what is open at an occasion is any predicate; the general theorems need
no decidability, and the witness's search uses explicit Boolean comparisons. Nothing requires what
is chosen to be open at its occasion (`PicksOpen`); the readings take occasions where it is.

Every declaration has an empty axiom report. No ethical predicate or normative premise is
introduced; the orders are supplied mathematical relations.
-/

namespace Becoming

universe u v

/-- Occasions of choosing: at each occasion `o`, what is open (`menu o`) and what is chosen
(`pick o`). Nothing about the alternatives or the occasions is assumed. -/
structure ChoiceOccasions (α : Type u) (O : Type v) where
  /-- What is open at the occasion. -/
  menu : O → α → Prop
  /-- What is chosen at the occasion. -/
  pick : O → α

namespace ChoiceOccasions

variable {α : Type u} {O : Type v} (ch : ChoiceOccasions α O)

/-- The choices show `x` above `y`: at some occasion `x` is chosen while `y`, another, is open. -/
def Shown : «际» α := fun x y => ∃ o, ch.pick o = x ∧ ch.menu o y ∧ y ≠ x

/-- A relation accords with the choices: at every occasion what is chosen stands above every
other alternative open there. -/
def Accords (P : «际» α) : Prop :=
  ∀ o y, ch.menu o y → y ≠ ch.pick o → P (ch.pick o) y

/-- A relation accords weakly with the choices: at every occasion nothing open stands above what
is chosen. -/
def AccordsWeakly (P : «际» α) : Prop :=
  ∀ o y, ch.menu o y → ¬ P y (ch.pick o)

/-- What is chosen is open at its occasion. No law here needs it; the readings take occasions
where it holds. -/
def PicksOpen : Prop := ∀ o, ch.menu o (ch.pick o)

variable {ch}

/-- The shown relation accords with the choices it is read from. -/
theorem shown_accords : ch.Accords ch.Shown :=
  fun o _ open_y other => ⟨o, rfl, open_y, other⟩

/-- The shown reach accords with the choices. -/
theorem reach_accords : ch.Accords («及» ch.Shown) :=
  fun o y open_y other => .one (shown_accords o y open_y other)

/-- **What accords contains the shown reach.** Every transitive relation according with the
choices contains the reach of the shown relation: it is the least transitive relation containing
what the choices show. -/
theorem reach_within {P : «际» α} (trans : ∀ x y z, P x y → P y z → P x z)
    (accords : ch.Accords P) : «则» («及» ch.Shown) P := by
  have base : «则» ch.Shown P := by
    intro x y shown
    match shown with
    | ⟨o, picked, open_y, other⟩ =>
      subst picked
      exact accords o y open_y other
  intro x y reach
  induction reach with
  | one h => exact base _ _ h
  | more h _ ih => exact trans _ _ _ (base _ _ h) ih

/-- **Choices come from a strict order exactly where nothing shown returns.** Some irreflexive
transitive relation accords with the choices exactly where nothing reaches itself in the shown
relation; the shown reach, transitive by the grammar's `«及之传递»`, is then such an order. -/
theorem accorded_iff_noCycle :
    (∃ P : «际» α, (∀ x, ¬ P x x) ∧ (∀ x y z, P x y → P y z → P x z) ∧ ch.Accords P) ↔
      «无环» ch.Shown :=
  ⟨fun ⟨_, irrefl, trans, accords⟩ x loop => irrefl x (reach_within trans accords x x loop),
   fun none => ⟨«及» ch.Shown, none, fun _ _ _ => «及之传递», reach_accords⟩⟩

/-- **The comparisons shared are the shown reach.** With no cycle shown, `x` stands above `y` in
every strict order according with the choices exactly where `x` reaches `y` in the shown relation:
the positive comparisons every such order shares are exactly the shown reach. -/
theorem above_in_every_iff_reach (none : «无环» ch.Shown) {x y : α} :
    (∀ P : «际» α, (∀ a, ¬ P a a) → (∀ a b c, P a b → P b c → P a c) → ch.Accords P →
        P x y) ↔
      «及» ch.Shown x y :=
  ⟨fun every => every _ none (fun _ _ _ => «及之传递») reach_accords,
   fun reach _ _ trans accords => reach_within trans accords x y reach⟩

/-- **A narrower class fixes at least as much.** Where every relation of a class is a strict order
according with the choices, a comparison every strict according order makes is made by every
relation of the class: restricting the orders a reader allows can only add comparisons. -/
theorem above_in_class_of_every {Q : «际» α → Prop}
    (within : ∀ P, Q P → (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧ ch.Accords P)
    {x y : α}
    (every : ∀ P : «际» α, (∀ a, ¬ P a a) → (∀ a b c, P a b → P b c → P a c) → ch.Accords P →
      P x y) :
    ∀ P, Q P → P x y :=
  fun P inQ => match within P inQ with
    | ⟨irrefl, trans, accords⟩ => every P irrefl trans accords

/-- **Uniform strict dominance over a menu is exactly reach to each other alternative.** With no
cycle shown, `x` stands above every other alternative of `N` in every strict order according with
the choices exactly where `x` reaches each of them in the shown relation. This does not say that
`x` is in `N` or chosen; reading it as a choice needs `N x` and a rule of choosing. -/
theorem top_in_every_iff_reach (none : «无环» ch.Shown) {N : α → Prop} {x : α} :
    (∀ P : «际» α, (∀ a, ¬ P a a) → (∀ a b c, P a b → P b c → P a c) → ch.Accords P →
        ∀ y, N y → y ≠ x → P x y) ↔
      ∀ y, N y → y ≠ x → «及» ch.Shown x y :=
  ⟨fun every y open_y other => every _ none (fun _ _ _ => «及之传递») reach_accords y open_y other,
   fun reach _ _ trans accords y open_y other =>
    reach_within trans accords x y (reach y open_y other)⟩

/-! ## Beyond the shown reach -/

/-- A relation with one pair added. -/
def withPair (R : «际» α) (x y : α) : «际» α := fun a b => R a b ∨ (a = x ∧ b = y)

/-- **Reach with one pair added.** It is reach without the pair, or reach to the pair's first
member (or being it), the pair, and reach from its second member (or being it). -/
theorem reach_withPair {R : «际» α} {x y a b : α} (reach : «及» (withPair R x y) a b) :
    «及» R a b ∨ ((a = x ∨ «及» R a x) ∧ (y = b ∨ «及» R y b)) := by
  induction reach with
  | one h =>
    cases h with
    | inl r => exact Or.inl (.one r)
    | inr e => exact Or.inr ⟨Or.inl e.1, Or.inl e.2.symm⟩
  | more h _ ih =>
    cases h with
    | inl r =>
      cases ih with
      | inl rest => exact Or.inl (.more r rest)
      | inr via =>
        exact Or.inr ⟨via.1.elim (fun same => Or.inr (same ▸ .one r))
          (fun reach => Or.inr (.more r reach)), via.2⟩
    | inr e =>
      cases ih with
      | inl rest => exact Or.inr ⟨Or.inl e.1, Or.inr (e.2 ▸ rest)⟩
      | inr via => exact Or.inr ⟨Or.inl e.1, via.2⟩

/-- **Reach with one pair added, exactly.** Reach in a relation with one pair added is reach
without it, or reach to the pair's first member (or being it), the pair, and reach from its second
member (or being it). No acyclicity or decision is needed. -/
theorem reach_withPair_iff {R : «际» α} {x y a b : α} :
    «及» (withPair R x y) a b ↔ «及» R a b ∨ ((a = x ∨ «及» R a x) ∧ (y = b ∨ «及» R y b)) :=
  ⟨reach_withPair, fun found => match found with
    | .inl r => «及之单调» (fun _ _ r => Or.inl r) a b r
    | .inr ⟨pre, post⟩ =>
      have to_y : «及» (withPair R x y) a y := match pre with
        | .inl ax => by subst ax; exact .one (Or.inr ⟨rfl, rfl⟩)
        | .inr ax => «及之传递» («及之单调» (fun _ _ r => Or.inl r) a x ax) (.one (Or.inr ⟨rfl, rfl⟩))
      match post with
      | .inl yb => by subst yb; exact to_y
      | .inr yb => «及之传递» to_y («及之单调» (fun _ _ r => Or.inl r) y b yb)⟩

/-- **Adding a pair leaves no cycle** where there was none, the pair's members differ and the
second does not reach the first. -/
theorem noCycle_withPair {R : «际» α} (none : «无环» R) {x y : α} (apart : x ≠ y)
    (unreached : ¬ «及» R y x) : «无环» (withPair R x y) := fun z loop =>
  match reach_withPair loop with
  | .inl back => none z back
  | .inr ⟨to_x, from_y⟩ =>
    match to_x, from_y with
    | .inl zx, .inl yz => apart (zx.symm.trans yz.symm)
    | .inl zx, .inr yz => unreached (zx ▸ yz)
    | .inr zx, .inl yz => unreached (yz ▸ zx)
    | .inr zx, .inr yz => unreached («及之传递» yz zx)

/-- **Where adding a pair leaves no cycle, exactly.** A relation with a pair added has no cycle
exactly where the relation has none and the pair's second member is neither its first nor reaches
it. -/
theorem noCycle_withPair_iff {R : «际» α} {x y : α} :
    «无环» (withPair R x y) ↔ «无环» R ∧ y ≠ x ∧ ¬ «及» R y x :=
  ⟨fun none =>
    ⟨fun z loop => none z («及之单调» (fun _ _ r => Or.inl r) z z loop),
     fun same => by
       subst same
       exact none y (.one (Or.inr ⟨rfl, rfl⟩)),
     fun back => none x (.more (Or.inr ⟨rfl, rfl⟩) («及之单调» (fun _ _ r => Or.inl r) y x back))⟩,
   fun ⟨acyclic, apart, unreached⟩ =>
    noCycle_withPair acyclic (fun same => apart same.symm) unreached⟩

/-- **Beyond the shown reach the order is free.** With no cycle shown, where `y` does not reach
`x` and the two differ, some strict order according with the choices puts `x` above `y`: the reach
of the shown relation with that pair added. -/
theorem above_in_some_of_unreached (none : «无环» ch.Shown) {x y : α} (apart : x ≠ y)
    (unreached : ¬ «及» ch.Shown y x) :
    ∃ P : «际» α, (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧ ch.Accords P ∧
      P x y :=
  ⟨«及» (withPair ch.Shown x y), noCycle_withPair none apart unreached, fun _ _ _ => «及之传递»,
   fun o z open_z other => .one (Or.inl (shown_accords o z open_z other)),
   .one (Or.inr ⟨rfl, rfl⟩)⟩

/-- **Two ways.** With no cycle shown, where neither of two different alternatives reaches the
other in the shown relation, one strict order according with the choices puts the first above the
second and another puts the second above the first. -/
theorem both_ways_of_unreached (none : «无环» ch.Shown) {x y : α} (apart : x ≠ y)
    (xy : ¬ «及» ch.Shown x y) (yx : ¬ «及» ch.Shown y x) :
    (∃ P : «际» α, (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧ ch.Accords P ∧
      P x y) ∧
    (∃ P : «际» α, (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧ ch.Accords P ∧
      P y x) :=
  ⟨above_in_some_of_unreached none apart yx,
   above_in_some_of_unreached none (fun same => apart same.symm) xy⟩

/-- **Choices required only to be maximal force no positive comparison.** The empty relation is a
strict order according weakly with every choice, so where what is chosen is required only to have
nothing open above it, no comparison of one alternative above another is forced. Such choices still
exclude any open alternative standing above the chosen one. -/
theorem weakly_forces_no_comparison (x y : α) :
    ¬ ∀ P : «际» α, (∀ a, ¬ P a a) → (∀ a b c, P a b → P b c → P a c) →
      ch.AccordsWeakly P → P x y :=
  fun every => every (fun _ _ => False) (fun _ h => h) (fun _ _ _ h _ => h) (fun _ _ _ h => h)

end ChoiceOccasions

/-! ## A witness: the pair met is fixed, the untried pair is free -/

namespace ChoiceOccasions.Untried

/-- Three alternatives. -/
inductive Alt where
  | first
  | second
  | third

/-- One occasion: the first and the second are open, the first is chosen. -/
def occasions : ChoiceOccasions Alt Unit where
  menu := fun _ a => a = .first ∨ a = .second
  pick := fun _ => .first

theorem first_ne_second : Alt.first ≠ Alt.second := fun h => nomatch h

theorem first_ne_third : Alt.first ≠ Alt.third := fun h => nomatch h

/-- What the choices show starts from the first alternative. -/
theorem shown_from_first {a b : Alt} (shown : occasions.Shown a b) : a = .first :=
  match shown with
  | ⟨_, picked, _, _⟩ => picked.symm

/-- What the choices show ends at the second alternative. -/
theorem shown_to_second {a b : Alt} (shown : occasions.Shown a b) : b = .second :=
  match shown with
  | ⟨_, picked, open_b, other⟩ =>
    open_b.elim (fun is_first => absurd (is_first.trans picked) other) id

/-- Every shown reach starts at the first alternative and ends at the second. -/
theorem reach_first_second {a b : Alt} (reach : «及» occasions.Shown a b) :
    a = .first ∧ b = .second := by
  cases reach with
  | one h => exact ⟨shown_from_first h, shown_to_second h⟩
  | more h rest =>
    have second_first : Alt.second = Alt.first :=
      (shown_to_second h).symm.trans (match rest with
        | .one h' => shown_from_first h'
        | .more h' _ => shown_from_first h')
    exact absurd second_first (fun same => first_ne_second same.symm)

theorem noCycle : «无环» occasions.Shown := fun _ loop =>
  match reach_first_second loop with
  | ⟨is_first, is_second⟩ => first_ne_second (is_first.symm.trans is_second)

/-- **The pair met is fixed.** Every relation according with the choice puts the first above the
second. -/
theorem met_fixed : ∀ P : «际» Alt, occasions.Accords P → P .first .second :=
  fun _ accords => accords () .second (Or.inr rfl) (fun h => nomatch h)

/-- **The untried pair is free.** Some strict order according with the choice puts the first
above the third, and another puts the third above the first. -/
theorem untried_free :
    (∃ P : «际» Alt, (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧
      occasions.Accords P ∧ P .first .third) ∧
    (∃ P : «际» Alt, (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧
      occasions.Accords P ∧ P .third .first) :=
  both_ways_of_unreached noCycle first_ne_third
    (fun reach => nomatch (reach_first_second reach).2)
    (fun reach => nomatch (reach_first_second reach).1)

/-! ### One search, two orders -/

/-- The orders a mechanism may carry, as decisions: the first above the third above the second,
or the third above the first above the second. -/
def aboveFirst (a b : Alt) : Bool :=
  match a with
  | .first => (match b with | .first => false | .second => true | .third => true)
  | .second => false
  | .third => (match b with | .first => false | .second => true | .third => false)

def aboveThird (a b : Alt) : Bool :=
  match a with
  | .first => (match b with | .first => false | .second => true | .third => false)
  | .second => false
  | .third => (match b with | .first => true | .second => true | .third => false)

theorem noTrue : false ≠ true := fun h => nomatch h

/-- Telling alternatives apart. -/
def same (a b : Alt) : Bool :=
  match a with
  | .first => (match b with | .first => true | .second => false | .third => false)
  | .second => (match b with | .first => false | .second => true | .third => false)
  | .third => (match b with | .first => false | .second => false | .third => true)

/-- One search procedure for every order: for any Boolean comparison on the alternatives, the first
listed alternative standing above every distinct listed alternative, or none where there is none. -/
def search (above : Alt → Alt → Bool) (menu : List Alt) : Option Alt :=
  menu.find? (fun a => menu.all (fun b => same b a || above a b))

/-- Each order is strict. -/
theorem aboveFirst_strict :
    (∀ a, ¬ aboveFirst a a = true) ∧
      (∀ a b c, aboveFirst a b = true → aboveFirst b c = true → aboveFirst a c = true) :=
  ⟨fun a => by cases a <;> exact fun h => noTrue h,
   fun a b c => by
    cases a <;> cases b <;> cases c <;>
      first
        | exact fun _ _ => rfl
        | exact fun h _ => (noTrue h).elim
        | exact fun _ h => (noTrue h).elim⟩

theorem aboveThird_strict :
    (∀ a, ¬ aboveThird a a = true) ∧
      (∀ a b c, aboveThird a b = true → aboveThird b c = true → aboveThird a c = true) :=
  ⟨fun a => by cases a <;> exact fun h => noTrue h,
   fun a b c => by
    cases a <;> cases b <;> cases c <;>
      first
        | exact fun _ _ => rfl
        | exact fun h _ => (noTrue h).elim
        | exact fun _ h => (noTrue h).elim⟩

/-- Both orders accord with the choice met. -/
theorem both_accord :
    occasions.Accords (fun a b => aboveFirst a b = true) ∧
      occasions.Accords (fun a b => aboveThird a b = true) :=
  ⟨fun _ b open_b other => (match b, open_b with
    | .first, _ => absurd rfl other
    | .second, _ => rfl
    | .third, .inl h => nomatch h
    | .third, .inr h => nomatch h),
   fun _ b open_b other => (match b, open_b with
    | .first, _ => absurd rfl other
    | .second, _ => rfl
    | .third, .inl h => nomatch h
    | .third, .inr h => nomatch h)⟩

/-- **The same choice on the menu met.** The one search, run with either order, chooses the first
from the first and the second. -/
theorem same_search_met :
    search aboveFirst [Alt.first, Alt.second] = some Alt.first ∧
      search aboveThird [Alt.first, Alt.second] = some Alt.first :=
  ⟨rfl, rfl⟩

/-- **Different choices on the menu met after.** From the first and the third, the search run with
the first order chooses the first, and run with the other chooses the third. -/
theorem same_search_after :
    search aboveFirst [Alt.first, Alt.third] = some Alt.first ∧
      search aboveThird [Alt.first, Alt.third] = some Alt.third :=
  ⟨rfl, rfl⟩

end ChoiceOccasions.Untried

end Becoming
