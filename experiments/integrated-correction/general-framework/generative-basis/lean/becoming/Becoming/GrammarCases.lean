import Becoming.GrammarScope
import Becoming.GrammarTesting

/-!
# Test systems of the source texts as small witnesses of the grammar (诸例)

The two texts the root was built from (`sources/15-codex-theory-conversations/2026-10-23-continuity-as-root/`,
`minimum-grammar-of-becoming.md` §7) proposed test systems a grammar of becoming must express. This
module gives small witnesses for two of them as stated, decay and a system with no clear boundary,
and for two narrower stand-ins: a line of descent generating at two grains and a belief whose rate of
spread grows with its number. Each says what the grammar tells apart in it and what it does not, and
in each the behaviour in question is supplied in the net. The flame is `Becoming.Grammar`'s own
witness (`«以核为判据则火无续»`); an institution kept by consent or by penalty is `«恒温与平衡»`
(`Becoming.GrammarTesting`) read socially, and is not restated. No definition of an earlier module
changes.

* **Decay** (`Decay`). A nucleus intact or decayed, step by step. The decay is an alteration: the
  nucleus continues under the one while "intact or not" tells the two ends apart
  (`Decay.decay_alters`), in a net where no occurrence reaches itself (`Decay.possible_acyclic`); the
  steps only rise (`Decay.reach_rises`), so the absence of a cycle lies in the indexing, and that the
  nucleus has no inner interaction is an omission of the model. In the net of possibilities an intact
  nucleus may stay intact or decay at every step (`Decay.both_open`, the net's definition), "intact or
  not" is constant (`Decay.possible_constant`), and every two intact moments, at any two steps, are
  alike in its core (`Decay.time_not_in_core`): the step is not in the regularity of "intact or not",
  memorylessness without probabilities. A history within that net (`Decay.history_within`), decaying at
  its second step, has the time left before the decay in that core: its two intact moments lie apart
  (`Decay.history_apart`), as the flame's time left does. Which net a model declares decides this;
  which an actual decay is, the model does not say.
* **No clear boundary** (`Overlap`). Three occurrences `a → b → c`, and two identities, one holding
  `a` with `b`, the other `b` with `c`, each a class; `b` continues `a` under the first and `c`
  continues `b` under the second (`Overlap.continues_each`), and `b` ends under the first and begins
  under the second (`Overlap.b_positions`). Their union is not a class: it relates `a` to `b` and `b`
  to `c` but not `a` to `c`, and its line from `a` reaches `c` with its ends apart
  (`Overlap.tolerance_line_apart`), where under a class a line's ends are alike (`«线内同类»`).
  Overlapping identities are several classes; observer-dependence is the choice of class; a vague
  boundary appears only as a relation that is not a class, whose line drifts out of it.
* **A line of descent generates at two grains** (`LineOfDescent.Endless.generates`). On the endless
  line of descent of `Becoming.GrammarScope`, the line under the one never ends and ahead of every
  point a member begins. This is not an organism that renews its parts and dies (that lies in
  `«新而有终»`), and no self-maintenance or regulation is modelled.
* **Two family lines** (`TwoLines`). Two lines of descent with no condition between them, and the
  class of one family line, strictly between a member's class and the one (`TwoLines.between`). The
  family line is constant (`TwoLines.family_constant`), so its core goes on through each birth while
  the member's line ends (`TwoLines.core_through_birth`); and from one family's first birth, even under
  the one, no member of the other family is reached (`TwoLines.other_line_outside`): reaching one's
  successors along 缘 is not reaching everything.
* **Two lines that share a condition** (`SharedCondition`). Two family lines and a condition that
  feeds both. Where the members affect the condition, each a condition of its next state, the line
  under the one from the first family's first member reaches the second family's member two
  generations on, through it (`SharedCondition.affecting_reaches_other`); under the class "a member or
  not", which holds both families' members alike and the condition apart, it does not
  (`SharedCondition.affecting_member_outside`). Where the members only feed from a condition they do
  not affect, the line under no relation reaches the other family (`SharedCondition.fed_outside`). No
  class narrower than the one is shown to reach, and no core is computed.
* **A belief whose rate of spread grows with its number** (`Belief`). The number holding a belief goes
  up by the rate, and the rate by the number, both by supplied laws (`adaptive`). On the step the rate
  changes with the number (`Belief.rate_changes_on_step`), and two configurations with one holder at
  rates `0` and `1` lie apart in the core of "same number" (`Belief.rate_read_in_regularity`, an
  instance of `adaptive_core_apart`). The laws of spread and of the rate's change are fixed; nothing
  here is specific to belief; closed capture is the nearer model of a selection changing its own rule.

What is not derived: that any actual nucleus, lineage or belief is so; probabilities of decay (the
periphery's); a vortex; a graded boundary; an institution's identity through replaced people, rules
and purposes; self-maintenance and adaptive regulation. The witnesses commit to discrete steps,
equality on their carriers and, for the belief, natural-number counts and linear laws. Every
declaration has an empty axiom report.
-/

namespace Becoming

/-! ## Decay -/

namespace Decay

/-- A nucleus at a step, intact (`false`) or decayed (`true`). -/
abbrev Occ := Nat × Bool

/-- The net of possibilities: an intact nucleus may stay intact or decay at the next step; a
decayed one stays decayed. -/
def possible : «际» Occ := fun x y => y.1 = x.1 + 1 ∧ (x.2 = true → y.2 = true)

/-- "Intact or not". -/
def intactAlike : «际» Occ := fun x y => x.2 = y.2

theorem intactAlike_class : «类» intactAlike := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- Along the net the step only rises. -/
theorem reach_rises {x y : Occ} (h : «及» possible x y) : x.1 < y.1 := by
  induction h with
  | one c => exact c.1 ▸ Nat.lt_succ_self _
  | more c _ ih => exact Nat.lt_trans (c.1 ▸ Nat.lt_succ_self _) ih

/-- **No occurrence reaches itself**: no condition is mutual. -/
theorem possible_acyclic : «无环» possible := fun _ h => Nat.lt_irrefl _ (reach_rises h)

/-- **From every intact moment both stay and decay are possible**: the net's definition. -/
theorem both_open (t : Nat) : possible (t, false) (t + 1, false) ∧ possible (t, false) (t + 1, true) :=
  ⟨⟨rfl, fun h => Bool.noConfusion h⟩, ⟨rfl, fun h => Bool.noConfusion h⟩⟩

/-- **The decay is an alteration of the nucleus**: under the one the decayed nucleus continues the
intact one, and "intact or not" tells them apart. -/
theorem decay_alters (t : Nat) : «异» possible «一» intactAlike (t, false) (t + 1, true) :=
  ⟨⟨⟨rfl, fun h => Bool.noConfusion h⟩, trivial⟩, Bool.noConfusion⟩

/-- **In the net of possibilities "intact or not" is constant.** -/
theorem possible_constant : «有常» possible intactAlike := by
  apply («有常之逐点» possible intactAlike).mpr
  intro u u' same v hv
  refine ⟨(u'.1 + 1, v.2), ⟨rfl, fun h => ?_⟩, rfl⟩
  exact hv.2 (same.trans h)

/-- **The step is not in the regularity of "intact or not"**: every two intact moments, at any two
steps, are alike in its core (memorylessness without probabilities). -/
theorem time_not_in_core (t t' : Nat) : «核» possible intactAlike (t, false) (t', false) :=
  («类有常当且仅当含于核» possible intactAlike_class).mp possible_constant _ _ rfl

/-- One history: intact at steps `0` and `1`, decayed from step `2` on; each moment is as the history
has it, and the next is the step after. -/
def history : «际» Occ := fun x y =>
  x.2 = decide (2 ≤ x.1) ∧ y.1 = x.1 + 1 ∧ y.2 = decide (2 ≤ y.1)

/-- **The history lies within the net of possibilities.** -/
theorem history_within : «则» history possible := fun x y ⟨hx, h1, h2⟩ =>
  ⟨h1, fun decayed => by
    obtain ⟨x1, x2⟩ := x
    obtain ⟨y1, y2⟩ := y
    cases decayed
    cases h1
    have : decide (2 ≤ x1) = true := hx.symm
    exact h2.trans (decide_eq_true (Nat.le_succ_of_le (of_decide_eq_true this)))⟩

/-- **In the history the time left before the decay is in the regularity**: the first intact moment
is continued under "intact or not", the last ends its line there, so the two lie apart in the core. -/
theorem history_apart : ¬ «核» history intactAlike (0, false) (1, false) := fun k =>
  have ends : «亡» history intactAlike (1, false) := fun ⟨y, hs, same⟩ => by
    obtain ⟨y1, y2⟩ := y
    obtain ⟨_, h1, h2⟩ := hs
    cases h1
    exact Bool.noConfusion (same.trans h2)
  «亡于核下不变» intactAlike_class ((«根» history intactAlike).2.2.1 _ _ k) ends
    ⟨(1, false), ⟨rfl, rfl, rfl⟩, rfl⟩

end Decay

/-! ## No clear boundary -/

namespace Overlap

inductive Occ | a | b | c

/-- `a` conditions `b`, `b` conditions `c`. -/
def step : «际» Occ
  | .a, y => Occ.casesOn (motive := fun _ => Prop) y False True False
  | .b, y => Occ.casesOn (motive := fun _ => Prop) y False False True
  | .c, _ => False

/-- The first identity: `a` with `b`, `c` apart. -/
def first : Occ → Bool
  | .a => true
  | .b => true
  | .c => false

/-- The second identity: `b` with `c`, `a` apart. -/
def second : Occ → Bool
  | .a => false
  | .b => true
  | .c => true

/-- **Each identity is a class**, and `b` continues `a` under the first, `c` continues `b` under the
second. -/
theorem continues_each :
    «类» (sameValue first) ∧ «类» (sameValue second) ∧
      «续» step (sameValue first) .a .b ∧ «续» step (sameValue second) .b .c :=
  ⟨sameValue_class _, sameValue_class _, ⟨trivial, rfl⟩, ⟨trivial, rfl⟩⟩

/-- **`b`'s positions differ by class**: it ends under the first identity and begins under the
second. -/
theorem b_positions : «亡» step (sameValue first) .b ∧ «生» step (sameValue second) .b := by
  constructor
  · intro ⟨y, hs, same⟩
    cases y with
    | a => exact False.elim hs
    | b => exact False.elim hs
    | c => exact Bool.noConfusion same
  · intro ⟨x, hs, same⟩
    cases x with
    | a => exact Bool.noConfusion same
    | b => exact False.elim hs
    | c => exact False.elim hs

/-- Alike under one identity or the other. -/
def either : «际» Occ := fun x y => first x = first y ∨ second x = second y

/-- **Sameness read as either identity is not a class, and its line leaves it**: it relates `a` to
`b` and `b` to `c` but not `a` to `c`, and its line from `a` reaches `c`. -/
theorem tolerance_line_apart :
    either .a .b ∧ either .b .c ∧ ¬ either .a .c ∧ «相续» step either .a .c :=
  ⟨.inl rfl, .inr rfl, fun h => match h with
    | .inl e => Bool.noConfusion e
    | .inr e => Bool.noConfusion e,
   «及».more (y := Occ.b) ⟨(trivial : step .a .b), .inl rfl⟩ (.one ⟨(trivial : step .b .c), .inr rfl⟩)⟩

end Overlap

/-! ## A line of descent generates at two grains -/

namespace LineOfDescent.Endless

/-- **The line of descent generates at two grains**: its line under the one never ends, and ahead of
every point a member begins. -/
theorem generates : «全生成» step «一» member (0, false) := by
  refine ⟨fun y _ => match total y with | ⟨v, h⟩ => ⟨v, h, trivial⟩, fun y _ => ?_⟩
  obtain ⟨n, b⟩ := y
  refine ⟨(n, true), (n + 1, false), ?_, ⟨⟨.inr ⟨rfl, rfl⟩, trivial⟩, ?_⟩⟩
  · cases b with
    | false => exact .inr (.one ⟨.inl ⟨rfl, rfl⟩, trivial⟩)
    | true => exact .inl rfl
  · intro ⟨x, hs, same⟩
    match hs with
    | .inl ⟨_, e⟩ => exact Bool.noConfusion (congrArg Prod.snd e)
    | .inr ⟨_, e⟩ =>
      have := congrArg Prod.fst e
      exact Nat.succ_ne_self x.1 (same.trans this).symm

end LineOfDescent.Endless

/-! ## Two family lines: a class between the member's and the one -/

namespace TwoLines

/-- A family (`false` or `true`), a generation, and an age (young `false`, old `true`). -/
abbrev Occ := Bool × Nat × Bool

/-- 缘 within each family: a young member becomes old; an old member is the condition of the next
generation's birth in the same family. No condition crosses between the families. -/
def step : «际» Occ := fun x y =>
  y.1 = x.1 ∧ ((x.2.2 = false ∧ y.2 = (x.2.1, true)) ∨ (x.2.2 = true ∧ y.2 = (x.2.1 + 1, false)))

/-- One member: the same family and generation. -/
def member : «际» Occ := fun x y => x.1 = y.1 ∧ x.2.1 = y.2.1

/-- One family line. -/
def family : «际» Occ := fun x y => x.1 = y.1

theorem family_class : «类» family := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- **The family line lies strictly between the member's class and the one**: each member lies in one
family line, a family line holds more than one member, and the one holds more than one family. -/
theorem between : «则» member family ∧ ¬ «则» family member ∧ ¬ «则» («一» : «际» Occ) family :=
  ⟨fun _ _ h => h.1, fun h => Nat.noConfusion (h (false, 0, false) (false, 1, false) rfl).2,
   fun h => Bool.noConfusion (h (false, 0, false) (true, 0, false) trivial)⟩

/-- Every occurrence conditions a successor in its own family. -/
theorem total (x : Occ) : ∃ y, step x y ∧ family x y :=
  match x with
  | (f, n, false) => ⟨(f, n, true), ⟨rfl, .inl ⟨rfl, rfl⟩⟩, rfl⟩
  | (f, n, true) => ⟨(f, n + 1, false), ⟨rfl, .inr ⟨rfl, rfl⟩⟩, rfl⟩

/-- **The family line is constant**: from two occurrences of one family line, a step from the one is
matched by a step from the other within the same family. -/
theorem family_constant : «有常» step family :=
  («有常之逐点» step family).mpr fun _ u' same _ hv =>
    match total u' with
    | ⟨v', h, fam⟩ => ⟨v', h, hv.1.trans (same.trans fam)⟩

/-- **The family line's core goes on through each birth**: the step from an old member to the next
generation's birth continues under the core of the family line, while the member's line ends there. -/
theorem core_through_birth (f : Bool) (n : Nat) :
    «续» step («核» step family) (f, n, true) (f, n + 1, false) ∧ «亡» step member (f, n, true) :=
  ⟨⟨⟨rfl, .inr ⟨rfl, rfl⟩⟩, («类有常当且仅当含于核» step family_class).mp family_constant _ _ rfl⟩,
   fun ⟨_, hs, same⟩ => match hs with
     | ⟨_, .inl ⟨h, _⟩⟩ => Bool.noConfusion h
     | ⟨_, .inr ⟨_, e⟩⟩ => Nat.succ_ne_self n (same.2.trans (congrArg Prod.fst e)).symm⟩

/-- A line stays within its family. -/
theorem line_in_family {E : «际» Occ} {x y : Occ} (line : «相续» step E x y) : y.1 = x.1 := by
  induction line with
  | one c => exact c.1.1
  | more c _ ih => exact ih.trans c.1.1

/-- **Reaching one's successors is not reaching everything**: from the first birth of one family, the
line under the one reaches no member of the other family. -/
theorem other_line_outside : ¬ «所及» step «一» (true, 0, false) (false, 0, false) := fun reached =>
  match reached with
  | .inl e => Bool.noConfusion (congrArg Prod.fst e)
  | .inr line => Bool.noConfusion (line_in_family line)

end TwoLines

/-! ## Two lines that share a condition -/

namespace SharedCondition

/-- A member of the first family at a generation, of the second, and the shared condition at a step. -/
inductive Occ | a (n : Nat) | b (n : Nat) | r (n : Nat)

/-- 缘 where the members affect the shared condition: each line goes on to its next generation; the
condition feeds the next generation of both lines and goes on itself; and each member is a condition
of the shared condition's next state (drawing on it is one way, with no amounts modelled). -/
def affecting : «际» Occ
  | .a m, .a n => n = m + 1
  | .a _, .b _ => False
  | .a m, .r n => n = m + 1
  | .b _, .a _ => False
  | .b m, .b n => n = m + 1
  | .b m, .r n => n = m + 1
  | .r m, .a n => n = m + 1
  | .r m, .b n => n = m + 1
  | .r m, .r n => n = m + 1

/-- 缘 where the members only feed from the shared condition: as `affecting`, with no member a condition
of the condition's next state, a common cause. -/
def fed : «际» Occ
  | .a m, .a n => n = m + 1
  | .a _, .b _ => False
  | .a _, .r _ => False
  | .b _, .a _ => False
  | .b m, .b n => n = m + 1
  | .b _, .r _ => False
  | .r m, .a n => n = m + 1
  | .r m, .b n => n = m + 1
  | .r m, .r n => n = m + 1

/-- Whether an occurrence is a member of either family: the class "a member or not" holds the members of
both families alike and the condition apart. -/
def living : Occ → Bool
  | .a _ => true
  | .b _ => true
  | .r _ => false

/-- **Where the members affect the shared condition, one line's future reaches the other's**: from the
first family's first member, the line under the one reaches the second family's member two
generations on, through the condition it affects and that feeds the other. -/
theorem affecting_reaches_other : «所及» affecting «一» (.a 0) (.b 2) :=
  have first : «续» affecting «一» (.a 0) (.r 1) := ⟨rfl, trivial⟩
  have second : «续» affecting «一» (.r 1) (.b 2) := ⟨rfl, trivial⟩
  .inr («及».more first (.one second))

/-- A step under the class of being a member or not, from a member of the first family, stays in it. -/
theorem affecting_member_step {m : Nat} {y : Occ} (c : «续» affecting (sameValue living) (.a m) y) : ∃ k, y = .a k :=
  match y, c with
  | .a k, _ => ⟨k, rfl⟩
  | .b _, c => False.elim c.1
  | .r _, c => absurd c.2 (fun h => Bool.noConfusion h)

/-- A line under the class of being a member or not, from a member of the first family, stays in the
first family. -/
theorem affecting_member_stays {x y : Occ} (line : «相续» affecting (sameValue living) x y) :
    ∀ m, x = .a m → ∃ k, y = .a k := by
  induction line with
  | one c =>
    intro m e
    subst e
    exact affecting_member_step c
  | more c _ ih =>
    intro m e
    subst e
    match affecting_member_step c with
    | ⟨k, e'⟩ => exact ih k e'

/-- **Under "a member or not", the other line is not reached**: that class holds both families' members
alike and the condition apart, and its line from the first family's first member reaches no member of
the second. -/
theorem affecting_member_outside (n : Nat) : ¬ «所及» affecting (sameValue living) (.a 0) (.b n) := fun reached =>
  match reached with
  | .inl e => Occ.noConfusion e
  | .inr line => match affecting_member_stays line 0 rfl with
    | ⟨_, e⟩ => Occ.noConfusion e

/-- A step along `fed`, from a member of the first family, stays in it. -/
theorem fed_step {E : «际» Occ} {m : Nat} {y : Occ} (c : «续» fed E (.a m) y) : ∃ k, y = .a k :=
  match y, c with
  | .a k, _ => ⟨k, rfl⟩
  | .b _, c => False.elim c.1
  | .r _, c => False.elim c.1

/-- A line along `fed`, under any relation, from a member of the first family, stays in the first
family. -/
theorem fed_stays {E : «际» Occ} {x y : Occ} (line : «相续» fed E x y) :
    ∀ m, x = .a m → ∃ k, y = .a k := by
  induction line with
  | one c =>
    intro m e
    subst e
    exact fed_step c
  | more c _ ih =>
    intro m e
    subst e
    match fed_step c with
    | ⟨k, e'⟩ => exact ih k e'

/-- **Where the members only feed from a condition they do not affect, no relation reaches the other
line**: under every relation, the line from the first family's first member reaches no member of the
second. -/
theorem fed_outside (E : «际» Occ) (n : Nat) : ¬ «所及» fed E (.a 0) (.b n) := fun reached =>
  match reached with
  | .inl e => Occ.noConfusion e
  | .inr line => match fed_stays line 0 rfl with
    | ⟨_, e⟩ => Occ.noConfusion e

end SharedCondition

/-! ## A belief whose rate of spread grows with its number -/

namespace Belief

/-- The number holding the belief goes up by the rate of spread. -/
def spread (rate held : Nat) (_ : Unit) : Nat := held + rate

/-- The rate goes up by the number holding the belief. -/
def grow (rate held : Nat) : Nat := rate + held

/-- **On the step the rate changes with the number**: one holder at rate `0` goes to one holder at
rate `1`. -/
theorem rate_changes_on_step : moveRel (adaptive spread grow) () (1, 0) (1, 1) := rfl

/-- **The rate is read in the belief's regularity**: one holder at rates `0` and `1` go to one and two
holders, so the core of "same number" under the step tells the two configurations apart. -/
theorem rate_read_in_regularity :
    ¬ «核» (moveRel (adaptive spread grow) ()) (sameValue (Prod.fst : Nat × Nat → Nat)) (1, 0) (1, 1) :=
  adaptive_core_apart (fun h => Nat.noConfusion (Nat.succ.inj h))

end Belief

end Becoming
