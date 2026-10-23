import Becoming.Grammar

/-!
# The map: generation, keeping and degeneration read at two grains (地图：生成、守、退化)

The map of the one-unfolding plan (`one-unfolding-root/PLAN.md` §七) stated in the grammar of
`Becoming.Grammar`, for every carrier and relation. Two classes are read at once: a fine class
`E` (the parts: cells, flames, members) and a coarse class `L` (the pattern they make up:
organism, fire, institution). Renewal by itself (`«复生»`) cannot tell renewal that sustains a
pattern from turnover that ends it; read at two grains it can.

| name | reading |
|---|---|
| `«传»` | carrying renewal: the coarse pattern continues from `x` to `y` while a fine line begins at `y` (火传) |
| `«生成»` | generation: the coarse line never ends and a carrying renewal lies ahead of every point of it |
| `«守»` | keeping: the coarse line never ends, and from some point no carrying renewal lies ahead |
| `«退化»` | degeneration: the coarse line reaches an end |
| `«新而终»` | renewing and still ending: a carrying renewal on a line that ends |

The regions exclude each other (`«生成退化不并»`, `«生成守不并»`, `«守退化不并»`), and each is
inhabited (`Map.Endless.generation`, `Map.Still.keeping`, `Map.Short.degeneration`), and where going
on and renewal are decided they cover every point (`«三域之周»`). Generation holds along its own line
(`«生成之所及亦生成»`) and degeneration reaches back along it (`«退化之所前亦退化»`). A carrying
renewal is an alteration (`«传则异»`). A coarse class constant under 缘 never degenerates from a
continued point (`«有常则不退化»`), so what degenerates has a coarse class that is not constant
(`«退化则粗不有常»`): its own regularity lies in the core. Renewal does not decide the region: a line
can renew and still end (`Map.Short.renews_and_ends`). Telling generation from degeneration on
every line, in every model, is exactly excluded middle (`«生败之定当且仅当排中»`): the boundary
between them is where a line's going on is not decided.

Higher orders: a chain of classes, each finer than the next, reads generation at every order at
once (`«阶生成»`); generation at order `k` is the order-`k + 1` pattern continuing through order-`k`
renewals, and the grammar's coarse net reads the same relation at each grain.

Every declaration has an empty axiom report.
-/

namespace Becoming

universe u

section Map

variable {α : Type u}

/-- Carrying renewal (传): the coarse pattern `L` continues from `x` to `y` while a fine line, under
`E`, begins at `y`. -/
def «传» (R L E : «际» α) (x y : α) : Prop := «续» R L x y ∧ «生» R E y

/-- A carrying renewal is an alteration: the fine class tells its two ends apart. -/
theorem «传则异» {R L E : «际» α} {x y : α} (h : «传» R L E x y) : «异» R L E x y :=
  ⟨h.1, fun e => h.2 ⟨x, h.1.1, e⟩⟩

/-- Reached on the coarse line from `x`: `x` itself or what the line reaches. -/
def «所及» (R L : «际» α) (x y : α) : Prop := x = y ∨ «相续» R L x y

theorem «所及之传递» {R L : «际» α} {x y z : α} (h₁ : «所及» R L x y) (h₂ : «所及» R L y z) :
    «所及» R L x z :=
  match h₁, h₂ with
  | .inl e, h => by cases e; exact h
  | h, .inl e => by cases e; exact h
  | .inr a, .inr b => .inr («及之传递» a b)

/-- Generation (生成): the coarse line from `x` never ends, and ahead of every point of it lies a
carrying renewal. -/
def «生成» (R L E : «际» α) (x : α) : Prop :=
  «不穷» R L x ∧ ∀ y, «所及» R L x y → ∃ z w, «所及» R L y z ∧ «传» R L E z w

/-- Keeping (守): the coarse line from `x` never ends, and from some point on no carrying renewal
lies ahead. -/
def «守» (R L E : «际» α) (x : α) : Prop :=
  «不穷» R L x ∧ ∃ y, «所及» R L x y ∧ ∀ z w, «所及» R L y z → ¬ «传» R L E z w

/-- Degeneration (退化): the coarse line from `x` reaches an end. -/
def «退化» (R L : «际» α) (x : α) : Prop := ∃ y, «所及» R L x y ∧ «亡» R L y

/-- Renewing and still ending (新而终): a carrying renewal on a coarse line that ends. -/
def «新而终» (R L E : «际» α) (x : α) : Prop :=
  «退化» R L x ∧ ∃ z w, «所及» R L x z ∧ «传» R L E z w

/-- Generation and degeneration exclude each other. -/
theorem «生成退化不并» {R L E : «际» α} {x : α} : ¬ («生成» R L E x ∧ «退化» R L x) :=
  fun ⟨⟨endless, _⟩, ⟨y, hy, ends⟩⟩ => ends (endless y hy)

/-- Generation and keeping exclude each other. -/
theorem «生成守不并» {R L E : «际» α} {x : α} : ¬ («生成» R L E x ∧ «守» R L E x) :=
  fun ⟨⟨_, ahead⟩, ⟨_, ⟨y, hy, noRenewal⟩⟩⟩ =>
    match ahead y hy with
    | ⟨z, w, hz, c⟩ => noRenewal z w hz c

/-- Keeping and degeneration exclude each other. -/
theorem «守退化不并» {R L E : «际» α} {x : α} : ¬ («守» R L E x ∧ «退化» R L x) :=
  fun ⟨⟨endless, _⟩, ⟨y, hy, ends⟩⟩ => ends (endless y hy)

/-- A coarse class constant under 缘 never degenerates from a continued point. -/
theorem «有常则不退化» {R L : «际» α} (hc : «有常» R L) {x : α} (hx : «有前» R L x) :
    ¬ «退化» R L x :=
  fun ⟨y, hy, ends⟩ => ends (match hy with
    | .inl e => by cases e; exact «有常则续不尽» hc hx
    | .inr l => «有常则相续不尽» hc l)

/-- What degenerates after a continued step has a coarse class that is not constant: its course
lies in the core, not in the class. -/
theorem «退化则粗不有常» {R L : «际» α} {x : α} (hx : «有前» R L x) (h : «退化» R L x) :
    ¬ «有常» R L :=
  fun hc => («有常则不退化» hc hx) h

/-- **Telling generation from degeneration is exactly excluded middle.** That every coarse line,
in every model, either never ends or reaches an end decides every proposition: the boundary between
generation and degeneration is where a line's going on is not decided. -/
theorem «生败之定当且仅当排中» :
    (∀ (β : Type) (R L : «际» β) (x : β), «不穷» R L x ∨ «退化» R L x) ↔ ∀ P : Prop, P ∨ ¬ P := by
  constructor
  · intro h P
    match h Unit (fun _ _ => P) «一» () with
    | .inl endless =>
      match endless () (.inl rfl) with
      | ⟨_, hp, _⟩ => exact .inl hp
    | .inr ⟨_, _, ends⟩ => exact .inr fun hp => ends ⟨(), hp, trivial⟩
  · intro em β R L x
    match em («退化» R L x) with
    | .inl d => exact .inr d
    | .inr nd =>
      refine .inl fun y hy => ?_
      match em («有后» R L y) with
      | .inl s => exact s
      | .inr ns => exact absurd ⟨y, hy, ns⟩ nd

/-- Generation holds along its own line: what a generating line reaches generates too. -/
theorem «生成之所及亦生成» {R L E : «际» α} {x y : α} (h : «生成» R L E x) (hy : «所及» R L x y) :
    «生成» R L E y :=
  ⟨fun z hz => h.1 z («所及之传递» hy hz), fun z hz => h.2 z («所及之传递» hy hz)⟩

/-- Degeneration reaches back along the line: what reaches a degenerating point degenerates. -/
theorem «退化之所前亦退化» {R L : «际» α} {x y : α} (hy : «所及» R L x y) (h : «退化» R L y) :
    «退化» R L x :=
  match h with
  | ⟨z, hz, ends⟩ => ⟨z, «所及之传递» hy hz, ends⟩

/-- **The regions cover every point where going on and renewal are decided.** With excluded middle,
every point of every coarse line generates, keeps or degenerates. -/
theorem «三域之周» (em : ∀ P : Prop, P ∨ ¬ P) (R L E : «际» α) (x : α) :
    «生成» R L E x ∨ «守» R L E x ∨ «退化» R L x := by
  match em («退化» R L x) with
  | .inl d => exact .inr (.inr d)
  | .inr nd =>
    have endless : «不穷» R L x := fun y hy =>
      match em («有后» R L y) with
      | .inl s => s
      | .inr ns => absurd ⟨y, hy, ns⟩ nd
    match em (∃ y, «所及» R L x y ∧ ∀ z w, «所及» R L y z → ¬ «传» R L E z w) with
    | .inl k => exact .inr (.inl ⟨endless, k⟩)
    | .inr nk =>
      refine .inl ⟨endless, fun y hy => ?_⟩
      match em (∃ z w, «所及» R L y z ∧ «传» R L E z w) with
      | .inl a => exact a
      | .inr na => exact absurd ⟨y, hy, fun z w hz c => na ⟨z, w, hz, c⟩⟩ nk

/-- Higher orders (阶): a chain of classes `Es`, each finer than the next, reads generation at
order `k` as the order-`k + 1` pattern continuing through order-`k` renewals. -/
def «阶生成» (R : «际» α) (Es : Nat → «际» α) (k : Nat) (x : α) : Prop :=
  «生成» R (Es (k + 1)) (Es k) x

/-- Generation at an order keeps the next order's line going: it cannot degenerate there. -/
theorem «阶生成则上不退化» {R : «际» α} {Es : Nat → «际» α} {k : Nat} {x : α}
    (h : «阶生成» R Es k x) : ¬ «退化» R (Es (k + 1)) x :=
  fun d => «生成退化不并» ⟨h, d⟩

end Map

/-! ## The three regions, inhabited -/

namespace Map

/-- Endless renewal: each number conditions the next. Under the one the pattern goes on, and under
identity each step begins a new part. -/
def step : «际» Nat := fun m n => n = m + 1

theorem step_irrefl : ∀ n, ¬ step n n
  | 0, h => Nat.noConfusion h
  | n + 1, h => step_irrefl n (Nat.succ.inj h)

/-- Generation is inhabited: the endless chain generates under the one, renewing at every step. -/
theorem Endless.generation : «生成» step «一» «静» 0 := by
  refine ⟨fun y _ => ⟨y + 1, rfl, trivial⟩, fun y _ => ⟨y, y + 1, .inl rfl, ⟨rfl, trivial⟩, ?_⟩⟩
  intro ⟨z, hz, e⟩
  cases e
  exact step_irrefl _ hz

/-- A pattern that stays as it is: one occurrence conditioning itself. -/
def still : «际» Unit := fun _ _ => True

/-- Keeping is inhabited: the still pattern never ends and never renews. -/
theorem Still.keeping : «守» still «一» «一» () :=
  ⟨fun _ _ => ⟨(), trivial, trivial⟩, ⟨(), .inl rfl, fun _ _ _ ⟨_, hb⟩ => hb ⟨(), trivial, trivial⟩⟩⟩

/-- A short life: two occurrences, the first conditioning the second, and no more. -/
def short : «际» Bool := fun a b => a = false ∧ b = true

theorem short_end : «亡» short «一» true :=
  fun ⟨_, h, _⟩ => Bool.noConfusion h.1

/-- Degeneration is inhabited: the short life ends. -/
theorem Short.degeneration : «退化» short «一» false :=
  ⟨true, .inr (.one ⟨⟨rfl, rfl⟩, trivial⟩), short_end⟩

/-- Renewal does not decide the region: the short life renews (its second occurrence begins a new
part under identity, carried by the pattern) and still ends. -/
theorem Short.renews_and_ends : «新而终» short «一» «静» false := by
  refine ⟨Short.degeneration, false, true, .inl rfl, ⟨⟨rfl, rfl⟩, trivial⟩, ?_⟩
  intro ⟨z, hz, e⟩
  cases e
  exact Bool.noConfusion hz.1

end Map

end Becoming
