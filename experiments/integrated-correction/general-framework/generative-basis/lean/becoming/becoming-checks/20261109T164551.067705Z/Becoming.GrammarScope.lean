import Becoming.GrammarRegularity
import Becoming.GrammarMap
import Becoming.Weightings

/-!
# The continuation condition on the root: everything on every center's continuing (续无外)

The continuation condition says, in its source, that for anything its continuation into the future
has significance. `Becoming.Significance` states it with significance as a free parameter beside the
dynamics; `Becoming.Weightings` reads it de se as lying within what a center continues with along a
relation (`ownClosure`), and then it is a statement about that relation and the centers
(`ownClosure_unrestricted_iff`). The root reads every subject as continuation relative to a class
(`Becoming.Grammar`). This module states the condition there, structurally: what lies within a
center's continuing under a class is what its line reaches, or what its family holds. No value
parameter is added. No definition of an earlier module changes.

| name | reading |
|---|---|
| `«续无外»` | the condition that every occurrence lies on the line of every center under the class |
| `«族无外»` | the condition that every occurrence lies in the family of every center under the class |

* **The condition on the root.** Given a net `R`, a class `E` and the centers of the standpoints
  (`center : Pos → α`), the condition along the net (`«续无外»`) is that every occurrence is reached
  on every center's line under `E`, and in families (`«族无外»`) that every occurrence lies in every
  center's family under `E`. The first gives the second (`«续无外则族无外»`), and either at a class
  gives it at every coarser class (`«续无外之粗化»`, `«族无外之粗化»`). Both are statements about
  `R`, `E` and the centers, with no significance parameter; the class and the centers are supplied,
  not read off the net.
* **The condition held de se is the root's.** Lying within a closure along a relation is being
  reached on a line under the one of that relation (`withinClosure_iff_reached`), the grammar's
  closure law (`«所闭当且仅当同一或及»` of `Becoming.GrammarLaws`) read on lines. So the condition
  held de se along a relation, `Unrestricted (selfAscribed (ownClosure rel) center)`, is exactly the
  root's condition at the one of that relation taken as the net
  (`ownClosure_unrestricted_iff_noOutside`). Each theorem of `Becoming.Significance` taking the
  condition as a hypothesis instantiates at that significance; one instance is proved here:
  on every reading where a claim's significance is that its formation lies within the standpoint's
  center's closure, living significance follows with S0, both neutralities and, where something
  lives, a seed (`premises_of_noOutside`). That reading supplies the significance; the root gives
  only that every formation lies within every closure.
* **Along 缘, one center.** Where the net has no cycle, the condition along it holds only with one
  center: two centers each reached from the other would lie on a cycle (`«续无外则同一中心»`), the
  case of one class of `«各续无外则同一中心»`, where each center's line runs under a class of its own
  and nothing is asked of the classes, and
  nothing conditions that center (`«续无外则中心无缘»`). In families at the one it asks only that the
  net be joined. The relations a self is drawn along in `Becoming.Weightings` (feeding, influence)
  run from what is fed or affected to what feeds or affects it, the converse of 缘: read along them,
  "ahead" runs to conditions.
* **The class of being joined.** The class of being joined by 缘 read either way, the family under
  the one (`«同族» R «一»`), is defined from the net alone: under it continuation is 缘 itself
  (`«族之续即缘»`), its lines reach exactly what the one's reach (`«族之所及即一之所及»`), and it is the
  finest class under which every condition is a continuation (`«续即缘当且仅当含族»`). Where every
  occurrence conditions something it is constant (`«遍有后则族有常»`), so its core holds both ends of
  every condition (`«遍有后则缘在族核»`) and a line under the core reaches what the one's reaches
  (`«遍有后则核之所及即一之所及»`). Where the net is joined it is the one; where the net has parts that
  no chain of 缘 joins, it is narrower. It is not the only class that reaches: a constant class finer
  than it can reach the same, depending on which way the rest is joined (`Becoming.GrammarCases`).
* **Past one's own end.** On a line under a class `L`, what continues under `L` an occurrence at which
  the line under some relation `O` ends (in the case read, a finer class such as an organism's) is
  reached on the line from the center, and lies on no line under `O` from that occurrence
  (`«过亡而续»`).
* **The core and endless lines.** The core of a class is fixed by the net once the class is given
  (`«根»`). It continues something exactly where some line under it goes on without end
  (`«核有续当且仅当有不穷»`), so in a net where no line under the core goes on without end the core
  continues nothing (`«无不穷则核无续»`). Two lines of descent, each with the one as its class of
  descent, show both. In endless descent (each member young, then old, then the parent of the next)
  every occurrence conditions a successor, so the one is constant, its core is the whole and
  continues through each birth, and the member's line ends at old age (`LineOfDescent.Endless`). In
  descent that ends (two members, the second childless) no line under any relation goes on without
  end, so no class's core continues anything, while the one reaches the second member past the
  first's end (`LineOfDescent.Last`).

What is not derived: which class a center's own line runs under, or which occurrences are centers;
that any actual net meets the condition at any class; that any actual lineage is endless; that a
class whose core does not carry a step is thereby chosen; any order: a ranking of courses needs C or
a premise in its place. The models commit to
discrete steps and to equality on their carriers. No ethical predicate is asserted; every declaration
has an empty axiom report.
-/

namespace Becoming

universe u

section Root

variable {Pos : Type} {α : Type u}

/-- **The condition on the root, along the net (续无外).** Every occurrence is reached on the line of
every center under `E`: everything lies on every center's continuing. -/
def «续无外» (R E : «际» α) (center : Pos → α) : Prop := ∀ p x, «所及» R E (center p) x

/-- **The condition on the root, in families (族无外).** Every occurrence lies in every center's family
under `E`. -/
def «族无外» (R E : «际» α) (center : Pos → α) : Prop := ∀ p x, «同族» R E (center p) x

/-- A line lies in its family. -/
theorem «相续则同族» {R E : «际» α} {x y : α} (line : «相续» R E x y) : «同族» R E x y := by
  induction line with
  | one c => exact .step c
  | more c _ ih => exact .trans (.step c) ih

/-- What a line reaches lies in its family. -/
theorem «所及则同族» {R E : «际» α} {x y : α} (h : «所及» R E x y) : «同族» R E x y :=
  match h with
  | .inl e => e ▸ .refl x
  | .inr line => «相续则同族» line

/-- The condition along the net gives it in families. -/
theorem «续无外则族无外» {R E : «际» α} {center : Pos → α} (h : «续无外» R E center) :
    «族无外» R E center :=
  fun p x => «所及则同族» (h p x)

/-- Under a coarser class every family holds the finer class's family. -/
theorem «同族之粗化» (R : «际» α) {E E' : «际» α} (h : «则» E E') {x y : α} (fam : «同族» R E x y) :
    «同族» R E' x y := by
  induction fam with
  | refl x => exact .refl x
  | step c => exact .step («粗化» R h _ _ c)
  | symm _ ih => exact .symm ih
  | trans _ _ ih₁ ih₂ => exact .trans ih₁ ih₂

/-- **The condition along the net at a class gives it at every coarser class.** -/
theorem «续无外之粗化» {R E E' : «际» α} {center : Pos → α} (h : «则» E E')
    (none : «续无外» R E center) : «续无外» R E' center :=
  fun p x => match none p x with
    | .inl e => .inl e
    | .inr line => .inr («及之单调» («粗化» R h) _ _ line)

/-- **The condition in families at a class gives it at every coarser class.** -/
theorem «族无外之粗化» {R E E' : «际» α} {center : Pos → α} (h : «则» E E')
    (none : «族无外» R E center) : «族无外» R E' center :=
  fun p x => «同族之粗化» R h (none p x)

/-- Every condition joins its two ends in one family under the one. -/
theorem «缘在族中» (R : «际» α) {x y : α} (h : R x y) : «同族» R «一» x y := .step ⟨h, trivial⟩

/-- **Under the class of being joined, continuation is 缘 itself** (族之续即缘): the class of being joined
by 缘 read either way (`«同族» R «一»`, defined from the net alone) relates the two ends of every
condition. -/
theorem «族之续即缘» (R : «际» α) : «谓» («续» R («同族» R «一»)) R :=
  fun _ _ => ⟨fun h => h.1, fun h => ⟨h, «缘在族中» R h⟩⟩

/-- **The class of being joined and the one reach the same**: a line under either reaches exactly what a
line under the other reaches, so a result stated through continuation under the one holds of it; a
result about the one's own constancy or core need not. -/
theorem «族之所及即一之所及» (R : «际» α) {x y : α} : «所及» R («同族» R «一») x y ↔ «所及» R «一» x y :=
  ⟨fun h => match h with
    | .inl e => .inl e
    | .inr line => .inr («及之单调» (fun _ _ c => ⟨c.1, trivial⟩) _ _ line),
   fun h => match h with
    | .inl e => .inl e
    | .inr line => .inr («及之单调» (fun _ _ c => ⟨c.1, «缘在族中» R c.1⟩) _ _ line)⟩

/-- **The class of being joined is the finest class under which every condition is a continuation**: a
class has 缘 as its continuation exactly where it contains the class of being joined by 缘 read either
way; so every class containing it reaches what the one reaches. -/
theorem «续即缘当且仅当含族» (R : «际» α) {E : «际» α} (hE : «类» E) :
    «谓» («续» R E) R ↔ «则» («同族» R «一») E := by
  constructor
  · intro same x y fam
    induction fam with
    | refl x => exact hE.refl x
    | step c => exact ((same _ _).mpr c.1).2
    | symm _ ih => exact hE.symm ih
    | trans _ _ ih₁ ih₂ => exact hE.trans ih₁ ih₂
  · intro inside x y
    exact ⟨fun h => h.1, fun h => ⟨h, inside x y («缘在族中» R h)⟩⟩

/-- **Where every occurrence conditions something, the class of being joined is constant** (遍有后则族有常). -/
theorem «遍有后则族有常» (R : «际» α) (total : ∀ x, ∃ y, R x y) : «有常» R («同族» R «一») :=
  («有常之逐点» R («同族» R «一»)).mpr fun _ u' fam _ hv =>
    match total u' with
    | ⟨v', hv'⟩ => ⟨v', hv', .trans (.symm («缘在族中» R hv)) (.trans fam («缘在族中» R hv'))⟩

/-- **And then every condition continues under its core**: the core of the class of being joined holds
both ends of every condition, so every step of 缘, including one from an occurrence where a finer
class's line ends, is a step under the core. -/
theorem «遍有后则缘在族核» (R : «际» α) (total : ∀ x, ∃ y, R x y) {x y : α} (h : R x y) :
    «续» R («核» R («同族» R «一»)) x y :=
  ⟨h, («类有常当且仅当含于核» R («同族为类» R «一»)).mp («遍有后则族有常» R total) x y («缘在族中» R h)⟩

/-- **And then a line under that core reaches exactly what a line under the one reaches.** -/
theorem «遍有后则核之所及即一之所及» (R : «际» α) (total : ∀ x, ∃ y, R x y) {x y : α} :
    «所及» R («核» R («同族» R «一»)) x y ↔ «所及» R «一» x y :=
  ⟨fun h => match h with
    | .inl e => .inl e
    | .inr line => .inr («及之单调» (fun _ _ c => ⟨c.1, trivial⟩) _ _ line),
   fun h => match h with
    | .inl e => .inl e
    | .inr line => .inr («及之单调» (fun _ _ c => «遍有后则缘在族核» R total c.1) _ _ line)⟩

/-- **Past one's own end (过亡而续).** On a line under `L` from a center `c`, what continues under `L`
an occurrence `m` at which the line under a relation `O` ends is reached on the line from `c`, and
lies on no line under `O` from `m`. The case read is a class `O` finer than `L`; no such hypothesis is
needed. -/
theorem «过亡而续» {R L O : «际» α} {c m z : α} (toEnd : «所及» R L c m) (ends : «亡» R O m)
    (next : «续» R L m z) : «所及» R L c z ∧ ¬ «相续» R O m z :=
  ⟨.inr (match toEnd with
    | .inl e => e ▸ .one next
    | .inr line => «相续之续» line next),
   fun line => ends («相续之始有后» line)⟩

/-- **The core continues something exactly where some line under it goes on without end.** A step
under the core is followed by a line under it that never ends (`«守核则不穷»`), and a line that never
ends has a first step. -/
theorem «核有续当且仅当有不穷» {R E : «际» α} :
    (∃ x y, «续» R («核» R E) x y) ↔ ∃ y, «不穷» R («核» R E) y :=
  ⟨fun ⟨_, y, kept⟩ => ⟨y, «守核则不穷» kept⟩,
   fun ⟨y, never⟩ => match never y (.inl rfl) with
     | ⟨z, c⟩ => ⟨y, z, c⟩⟩

/-- **Where no line under the core goes on without end, the core continues nothing.** -/
theorem «无不穷则核无续» {R E : «际» α} (ends : ∀ y, ¬ «不穷» R («核» R E) y) {x y : α} :
    ¬ «续» R («核» R E) x y :=
  fun kept => ends y («守核则不穷» kept)

/-- **Along a net without cycles the condition, each center under a class of its own, holds only
with one center** (各续无外则同一中心): two centers each reached from the other, on lines under
whatever classes, would lie on a cycle. No class, regularity or holding premise is asked of the
classes: a line under any class goes along the net (`«相续含于及»`). -/
theorem «各续无外则同一中心» {R : «际» α} {E : Pos → «际» α} {center : Pos → α}
    (acyclic : «无环» R) (all : ∀ p x, «所及» R (E p) (center p) x) (p q : Pos) :
    center p = center q :=
  match all p (center q), all q (center p) with
  | .inl e, _ => e
  | _, .inl e => e.symm
  | .inr there, .inr back =>
    absurd («及之传递» («相续含于及» R (E p) _ _ there) («相续含于及» R (E q) _ _ back)) (acyclic _)

/-- **Along a net without cycles the condition holds only with one center** (续无外则同一中心): the
case of one class for every center (`«各续无外则同一中心»`). -/
theorem «续无外则同一中心» {R E : «际» α} {center : Pos → α} (acyclic : «无环» R)
    (none : «续无外» R E center) (p q : Pos) : center p = center q :=
  «各续无外则同一中心» (E := fun _ => E) acyclic none p q

/-- **And nothing conditions that center** (续无外则中心无缘): a condition of the center, reached from
it, would close a cycle. -/
theorem «续无外则中心无缘» {R E : «际» α} {center : Pos → α} (acyclic : «无环» R)
    (none : «续无外» R E center) (p : Pos) (w : α) : ¬ R w (center p) := fun cond =>
  match none p w with
  | .inl e => acyclic _ (.one (e ▸ cond))
  | .inr line => acyclic _ («及之传递» («相续含于及» R E _ _ line) (.one cond))

end Root

/-! ## The condition held de se as the root's at the one -/

section World

/-- A line under the one of a relation lies within the closure along it: what the line reaches
(`«相续含于及»`) lies within the closure (`«所闭当且仅当同一或及»`). -/
theorem withinClosure_of_line {X : Type u} {rel : X → X → Prop} {f g : X} (line : «相续» rel «一» f g) :
    WithinClosure rel f g :=
  «所闭当且仅当同一或及».mpr (.inr («相续含于及» rel «一» _ _ line))

/-- Being `x` or reached from it is being reached on a line under the one. -/
theorem eq_or_reach_iff_reached {X : Type u} {R : «际» X} {x y : X} :
    (x = y ∨ «及» R x y) ↔ «所及» R «一» x y :=
  ⟨fun h => match h with
    | .inl e => .inl e
    | .inr reach => .inr («及之单调» (fun a b r => ((«一之续» R) a b).mpr r) _ _ reach),
   fun h => match h with
    | .inl e => .inl e
    | .inr line => .inr («相续含于及» R «一» _ _ line)⟩

/-- **Lying within a closure along a relation is being reached on a line under the one of that
relation**: the grammar's closure law (`«所闭当且仅当同一或及»`) read on lines. -/
theorem withinClosure_iff_reached {X : Type u} {rel : X → X → Prop} {f g : X} :
    WithinClosure rel f g ↔ «所及» rel «一» f g :=
  «所闭当且仅当同一或及».trans eq_or_reach_iff_reached

variable {F Pos : Type}

/-- **The condition held de se along a relation is the root's condition at the one of that relation,
taken as the net.** -/
theorem ownClosure_unrestricted_iff_noOutside {rel : F → F → Prop} {center : Pos → F} :
    Unrestricted (selfAscribed (ownClosure rel) center) ↔ «续无外» rel «一» center :=
  ownClosure_unrestricted_iff.trans
    ⟨fun whole p g => withinClosure_iff_reached.mp (whole p g),
     fun none p g => withinClosure_iff_reached.mpr (none p g)⟩

/-- **Living significance from the root's condition, on the own-closure reading.** Where every
formation lies on every center's line under the one of a relation, then on every reading of claims
where a claim's significance from a standpoint is that its formation lies within that standpoint's
center's closure (`reads`), living significance follows, with S0 at every standpoint, both
neutralities and, wherever something lives and there is a standpoint, a seed: one instance of
`Valuation.premises_of_unrestricted`. The significance is supplied by `reads`; with the condition
every formation lies within every closure, so `reads` makes every claim significant from every
standpoint, and the root supplies only that every formation lies within. -/
theorem premises_of_noOutside {Q : Type} {V : Valuation Pos Q} {rel : F → F → Prop} {center : Pos → F}
    (none : «续无外» rel «一» center) (formation : Q → F) (step : Q → Nat)
    (reads : ∀ p c, selfAscribed (ownClosure rel) center p (step c) (formation c) → V.sig p c) :
    V.Significant ∧ (∀ p, V.SelfSignificance p) ∧ Neutral V.transmits ∧ Neutral V.shares ∧
      ∀ c, V.living c → Pos → V.Seed :=
  Valuation.premises_of_unrestricted (ownClosure_unrestricted_iff_noOutside.mpr none) formation step reads

end World

/-! ## Two models of descent -/

namespace LineOfDescent

/-! ### Endless descent: each member young, then old, then the parent of the next -/

namespace Endless

/-- Member `n`, young (`false`) or old (`true`). -/
abbrev Occ := Nat × Bool

/-- 缘: a young member becomes old; an old member is the condition of the next member's birth. -/
def step : «际» Occ := fun x y =>
  (x.2 = false ∧ y = (x.1, true)) ∨ (x.2 = true ∧ y = (x.1 + 1, false))

/-- The class of one member: the same individual. -/
def member : «际» Occ := fun x y => x.1 = y.1

theorem member_class : «类» member := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- Every occurrence conditions a successor. -/
theorem total (x : Occ) : ∃ y, step x y :=
  match x with
  | (n, false) => ⟨(n, true), .inl ⟨rfl, rfl⟩⟩
  | (n, true) => ⟨(n + 1, false), .inr ⟨rfl, rfl⟩⟩

/-- **The member's line ends at old age**: an old member has no successor under its own class. -/
theorem member_ends (n : Nat) : «亡» step member (n, true) := fun ⟨y, hs, same⟩ =>
  match hs with
  | .inl ⟨h, _⟩ => Bool.noConfusion h
  | .inr ⟨_, e⟩ => by
    cases e
    exact Nat.succ_ne_self n same.symm

/-- **The class of descent, the one, is constant**: every occurrence conditions a successor (`total`). -/
theorem descent_constant : «有常» step («一» : «际» Occ) :=
  («有常之逐点» step «一»).mpr fun _ u' _ _ _ =>
    match total u' with
    | ⟨v', h⟩ => ⟨v', h, trivial⟩

/-- **The core of descent continues through each birth**, while the member's line ends there. -/
theorem core_through_birth (n : Nat) :
    «续» step («核» step «一») (n, true) (n + 1, false) ∧ «亡» step member (n, true) :=
  ⟨⟨.inr ⟨rfl, rfl⟩, («类有常当且仅当含于核» step «一为类»).mp descent_constant _ _ trivial⟩,
   member_ends n⟩

/-- **The regularity of descent goes on for good from every birth**: the line under the core never
ends from the next member's birth. -/
theorem descent_unending (n : Nat) : «不穷» step («核» step «一») (n + 1, false) :=
  «守核则不穷» (core_through_birth n).1

/-- The line of descent from the first member reaches each member, young and old. -/
theorem descent_reaches_both : ∀ n, «所及» step «一» (0, false) (n, false) ∧ «所及» step «一» (0, false) (n, true)
  | 0 => ⟨.inl rfl, .inr (.one ⟨.inl ⟨rfl, rfl⟩, trivial⟩)⟩
  | n + 1 =>
    have old := (descent_reaches_both n).2
    have young : «所及» step «一» (0, false) (n + 1, false) :=
      .inr (match old with
        | .inl e => absurd (congrArg Prod.snd e) Bool.noConfusion
        | .inr line => «相续之续» line ⟨.inr ⟨rfl, rfl⟩, trivial⟩)
    ⟨young, .inr (match young with
      | .inl e => absurd (congrArg Prod.fst e) (fun h => Nat.noConfusion h)
      | .inr line => «相续之续» line ⟨.inl ⟨rfl, rfl⟩, trivial⟩)⟩

/-- **The line of descent from the first member reaches every occurrence.** -/
theorem descent_reaches (n : Nat) : ∀ b, «所及» step «一» (0, false) (n, b)
  | false => (descent_reaches_both n).1
  | true => (descent_reaches_both n).2

/-- **With the first birth as the only center, the condition holds under the one**: every occurrence
lies on its line. -/
theorem descent_no_outside : «续无外» step «一» (fun (_ : Unit) => ((0, false) : Occ)) :=
  fun _ x => descent_reaches x.1 x.2

/-- A line under the member's class stays with one member (`«线内同类»`). -/
theorem member_line {x y : Occ} (line : «相续» step member x y) : y.1 = x.1 :=
  («线内同类» member_class line).symm

/-- **Under the member's class it fails**: the first member's line reaches nothing of the next member. -/
theorem member_outside : ¬ «续无外» step member (fun (_ : Unit) => ((0, false) : Occ)) := fun none =>
  have stays : ∀ y, «所及» step member ((0, false) : Occ) y → y.1 = 0 := fun _ reached =>
    match reached with
    | .inl e => e ▸ rfl
    | .inr line => member_line line
  Nat.noConfusion (stays (1, false) (none () (1, false)))

end Endless

/-! ### Descent that ends: two members, the second without a child -/

namespace Last

/-- Member (first `false`, second `true`) and age (young `false`, old `true`). -/
abbrev Occ := Bool × Bool

/-- 缘: the first member young, then old, then the second member's birth, then its old age; nothing
after. -/
def step : «际» Occ := fun x y =>
  (x = (false, false) ∧ y = (false, true)) ∨ (x = (false, true) ∧ y = (true, false)) ∨
    (x = (true, false) ∧ y = (true, true))

/-- The last occurrence conditions nothing. -/
theorem last_ends {E : «际» Occ} : «亡» step E (true, true) := fun ⟨_, hs, _⟩ =>
  match hs with
  | .inl ⟨h, _⟩ => Bool.noConfusion (congrArg Prod.fst h)
  | .inr (.inl ⟨h, _⟩) => Bool.noConfusion (congrArg Prod.fst h)
  | .inr (.inr ⟨h, _⟩) => Bool.noConfusion (congrArg Prod.snd h)

/-- From every occurrence, no line under any relation goes on without end: a line that never ended
would follow the only successors to the last occurrence within three steps, and the last conditions
nothing. -/
theorem never_unending (E : «际» Occ) : ∀ y, ¬ «不穷» step E y := by
  have last : ¬ «不穷» step E (true, true) := fun never => last_ends (never _ (.inl rfl))
  have third : ¬ «不穷» step E (true, false) := fun never =>
    match never _ (.inl rfl) with
    | ⟨w, hs, e⟩ =>
      match hs with
      | .inl ⟨h, _⟩ => Bool.noConfusion (congrArg Prod.fst h)
      | .inr (.inl ⟨h, _⟩) => Bool.noConfusion (congrArg Prod.snd h)
      | .inr (.inr ⟨_, hw⟩) => by
        cases hw
        exact last fun z reach => never z (match reach with
          | .inl at_last => .inr (at_last ▸ .one ⟨.inr (.inr ⟨rfl, rfl⟩), e⟩)
          | .inr line => .inr (.more ⟨.inr (.inr ⟨rfl, rfl⟩), e⟩ line))
  have second : ¬ «不穷» step E (false, true) := fun never =>
    match never _ (.inl rfl) with
    | ⟨w, hs, e⟩ =>
      match hs with
      | .inl ⟨h, _⟩ => Bool.noConfusion (congrArg Prod.snd h)
      | .inr (.inl ⟨_, hw⟩) => by
        cases hw
        exact third fun z reach => never z (match reach with
          | .inl at_third => .inr (at_third ▸ .one ⟨.inr (.inl ⟨rfl, rfl⟩), e⟩)
          | .inr line => .inr (.more ⟨.inr (.inl ⟨rfl, rfl⟩), e⟩ line))
      | .inr (.inr ⟨h, _⟩) => Bool.noConfusion (congrArg Prod.fst h)
  have first : ¬ «不穷» step E (false, false) := fun never =>
    match never _ (.inl rfl) with
    | ⟨w, hs, e⟩ =>
      match hs with
      | .inl ⟨_, hw⟩ => by
        cases hw
        exact second fun z reach => never z (match reach with
          | .inl at_second => .inr (at_second ▸ .one ⟨.inl ⟨rfl, rfl⟩, e⟩)
          | .inr line => .inr (.more ⟨.inl ⟨rfl, rfl⟩, e⟩ line))
      | .inr (.inl ⟨h, _⟩) => Bool.noConfusion (congrArg Prod.snd h)
      | .inr (.inr ⟨h, _⟩) => Bool.noConfusion (congrArg Prod.fst h)
  intro y
  match y with
  | (false, false) => exact first
  | (false, true) => exact second
  | (true, false) => exact third
  | (true, true) => exact last

/-- **No class's core continues anything**: no line goes on without end; here for the class of descent,
the one. -/
theorem core_no_continuation : ∀ x y : Occ, ¬ «续» step («核» step «一») x y :=
  fun _ _ => «无不穷则核无续» (never_unending _)

/-- **Yet the class of descent continues past the first member's end**: the first member's line ends
at its old age, and the second member's birth lies on the line of descent from the first member's
birth, on no line of the first member from its old age. -/
theorem descent_past_end :
    «所及» step «一» (false, false) (true, false) ∧ ¬ «相续» step (fun x y : Occ => x.1 = y.1) (false, true) (true, false) :=
  «过亡而续» (.inr (.one ⟨.inl ⟨rfl, rfl⟩, trivial⟩))
    (fun ⟨_, hs, same⟩ =>
      match hs with
      | .inl ⟨h, _⟩ => Bool.noConfusion (congrArg Prod.snd h)
      | .inr (.inl ⟨_, hw⟩) => by cases hw; exact Bool.noConfusion same
      | .inr (.inr ⟨h, _⟩) => Bool.noConfusion (congrArg Prod.fst h))
    ⟨.inr (.inl ⟨rfl, rfl⟩), trivial⟩

end Last

end LineOfDescent

end Becoming
