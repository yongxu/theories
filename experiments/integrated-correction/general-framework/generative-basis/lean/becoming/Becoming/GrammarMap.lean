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
| `«全生成»` | generation: the coarse line never ends and a carrying renewal lies ahead of every point of it |
| `«全守»` | keeping: the coarse line never ends, and from some point no carrying renewal lies ahead |
| `«有终»` | degeneration: the coarse line reaches an end |
| `«新而有终»` | renewing and still ending: a carrying renewal on a line that ends |

The regions exclude each other (`«全生成有终不并»`, `«全生成全守不并»`, `«全守有终不并»`), and each is
inhabited (`Map.Endless.generation`, `Map.Still.keeping`, `Map.Short.degeneration`), and where going
on and renewal are decided they cover every point (`«全三域之周»`). Generation holds along its own line
(`«全生成之所及亦全生成»`) and degeneration reaches back along it (`«有终之所前亦有终»`). A carrying
renewal is an alteration (`«传则异»`). A coarse class constant under 缘 never degenerates from a
continued point (`«有常则无终»`), so what degenerates has a coarse class that is not constant
(`«有终则粗不有常»`): its own regularity lies in the core. Renewal does not decide the region: a line
can renew and still end (`Map.Short.renews_and_ends`). Telling generation from degeneration on
every line, in every model, is exactly excluded middle (`«全生有终之定当且仅当排中»`): the boundary
between them is where a line's going on is not decided.

Higher orders: a chain of classes, each finer than the next, reads generation at every order at
once (`«阶全生成»`); generation at order `k` is the order-`k + 1` pattern continuing through order-`k`
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
def «全生成» (R L E : «际» α) (x : α) : Prop :=
  «不穷» R L x ∧ ∀ y, «所及» R L x y → ∃ z w, «所及» R L y z ∧ «传» R L E z w

/-- Keeping (守): the coarse line from `x` never ends, and from some point on no carrying renewal
lies ahead. -/
def «全守» (R L E : «际» α) (x : α) : Prop :=
  «不穷» R L x ∧ ∃ y, «所及» R L x y ∧ ∀ z w, «所及» R L y z → ¬ «传» R L E z w

/-- Degeneration (退化): the coarse line from `x` reaches an end. -/
def «有终» (R L : «际» α) (x : α) : Prop := ∃ y, «所及» R L x y ∧ «亡» R L y

/-- Renewing and still ending (新而终): a carrying renewal on a coarse line that ends. -/
def «新而有终» (R L E : «际» α) (x : α) : Prop :=
  «有终» R L x ∧ ∃ z w, «所及» R L x z ∧ «传» R L E z w

/-- Generation and degeneration exclude each other. -/
theorem «全生成有终不并» {R L E : «际» α} {x : α} : ¬ («全生成» R L E x ∧ «有终» R L x) :=
  fun ⟨⟨endless, _⟩, ⟨y, hy, ends⟩⟩ => ends (endless y hy)

/-- Generation and keeping exclude each other. -/
theorem «全生成全守不并» {R L E : «际» α} {x : α} : ¬ («全生成» R L E x ∧ «全守» R L E x) :=
  fun ⟨⟨_, ahead⟩, ⟨_, ⟨y, hy, noRenewal⟩⟩⟩ =>
    match ahead y hy with
    | ⟨z, w, hz, c⟩ => noRenewal z w hz c

/-- Keeping and degeneration exclude each other. -/
theorem «全守有终不并» {R L E : «际» α} {x : α} : ¬ («全守» R L E x ∧ «有终» R L x) :=
  fun ⟨⟨endless, _⟩, ⟨y, hy, ends⟩⟩ => ends (endless y hy)

/-- A coarse class constant under 缘 never degenerates from a continued point. -/
theorem «有常则无终» {R L : «际» α} (hc : «有常» R L) {x : α} (hx : «有前» R L x) :
    ¬ «有终» R L x :=
  fun ⟨y, hy, ends⟩ => ends (match hy with
    | .inl e => by cases e; exact «有常则续不尽» hc hx
    | .inr l => «有常则相续不尽» hc l)

/-- What degenerates after a continued step has a coarse class that is not constant: its course
lies in the core, not in the class. -/
theorem «有终则粗不有常» {R L : «际» α} {x : α} (hx : «有前» R L x) (h : «有终» R L x) :
    ¬ «有常» R L :=
  fun hc => («有常则无终» hc hx) h

/-- **Telling generation from degeneration is exactly excluded middle.** That every coarse line,
in every model, either never ends or reaches an end decides every proposition: the boundary between
generation and degeneration is where a line's going on is not decided. -/
theorem «全生有终之定当且仅当排中» :
    (∀ (β : Type) (R L : «际» β) (x : β), «不穷» R L x ∨ «有终» R L x) ↔ ∀ P : Prop, P ∨ ¬ P := by
  constructor
  · intro h P
    match h Unit (fun _ _ => P) «一» () with
    | .inl endless =>
      match endless () (.inl rfl) with
      | ⟨_, hp, _⟩ => exact .inl hp
    | .inr ⟨_, _, ends⟩ => exact .inr fun hp => ends ⟨(), hp, trivial⟩
  · intro em β R L x
    match em («有终» R L x) with
    | .inl d => exact .inr d
    | .inr nd =>
      refine .inl fun y hy => ?_
      match em («有后» R L y) with
      | .inl s => exact s
      | .inr ns => exact absurd ⟨y, hy, ns⟩ nd

/-- Generation holds along its own line: what a generating line reaches generates too. -/
theorem «全生成之所及亦全生成» {R L E : «际» α} {x y : α} (h : «全生成» R L E x) (hy : «所及» R L x y) :
    «全生成» R L E y :=
  ⟨fun z hz => h.1 z («所及之传递» hy hz), fun z hz => h.2 z («所及之传递» hy hz)⟩

/-- Degeneration reaches back along the line: what reaches a degenerating point degenerates. -/
theorem «有终之所前亦有终» {R L : «际» α} {x y : α} (hy : «所及» R L x y) (h : «有终» R L y) :
    «有终» R L x :=
  match h with
  | ⟨z, hz, ends⟩ => ⟨z, «所及之传递» hy hz, ends⟩

/-- **The regions cover every point where going on and renewal are decided.** With excluded middle,
every point of every coarse line generates, keeps or degenerates. -/
theorem «全三域之周» (em : ∀ P : Prop, P ∨ ¬ P) (R L E : «际» α) (x : α) :
    «全生成» R L E x ∨ «全守» R L E x ∨ «有终» R L x := by
  match em («有终» R L x) with
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
def «阶全生成» (R : «际» α) (Es : Nat → «际» α) (k : Nat) (x : α) : Prop :=
  «全生成» R (Es (k + 1)) (Es k) x

/-- Generation at an order keeps the next order's line going: it cannot degenerate there. -/
theorem «阶全生成则上无终» {R : «际» α} {Es : Nat → «际» α} {k : Nat} {x : α}
    (h : «阶全生成» R Es k x) : ¬ «有终» R (Es (k + 1)) x :=
  fun d => «全生成有终不并» ⟨h, d⟩

/-! ### Some branch and every branch

A pattern whose parts branch (a species whose members die, a fire passed along several fuels) has
lines that end while it goes on. So the regions are read on branches: the pattern goes on along some
branch (`«延»`, coinductive) or ends on every branch (`«尽»`, inductive), and the every-branch forms
above (`«全生成»`, `«全守»`, `«有终»`) are their strong and weak cases. -/

/-- A line under `L` continued by a continuation is a line. -/
theorem «相续之续» {R L : «际» α} {x z w : α} (h : «相续» R L x z) (c : «续» R L z w) : «相续» R L x w :=
  «及之传递» h (.one c)

/-- Going on along some branch (延): `x` lies in a family each member of which is continued, under
`L`, by a member. -/
def «延» (R L : «际» α) (x : α) : Prop := ∃ S : α → Prop, S x ∧ ∀ z, S z → ∃ w, S w ∧ «续» R L z w

/-- Ending on every branch (尽): every continuation from `x` ends on every branch; inductively, `x`
ends on every branch where everything continuing it does. -/
inductive «尽» (R L : «际» α) : α → Prop
  | mk {x : α} : (∀ y, «续» R L x y → «尽» R L y) → «尽» R L x

/-- Going on along some branch and ending on every branch exclude each other. -/
theorem «延尽不并» {R L : «际» α} {x : α} (h : «尽» R L x) : ¬ «延» R L x := by
  induction h with
  | mk _ ih =>
    intro ⟨S, hx, hS⟩
    match hS _ hx with
    | ⟨w, hw, c⟩ => exact ih w c ⟨S, hw, hS⟩

/-- Going on along every branch is going on along some. -/
theorem «不穷则延» {R L : «际» α} {x : α} (h : «不穷» R L x) : «延» R L x :=
  ⟨fun z => «所及» R L x z, .inl rfl, fun z hz => match h z hz with
    | ⟨w, c⟩ => ⟨w, match hz with
        | .inl e => by cases e; exact .inr (.one c)
        | .inr l => .inr («相续之续» l c), c⟩⟩

/-- What ends on every branch does not go on along every branch. -/
theorem «尽则非不穷» {R L : «际» α} {x : α} (h : «尽» R L x) : ¬ «不穷» R L x :=
  fun n => «延尽不并» h («不穷则延» n)

/-- Generation (生成): along some branch the pattern goes on and a carrying renewal lies ahead of
every point of it. -/
def «生成» (R L E : «际» α) (x : α) : Prop :=
  ∃ S : α → Prop, S x ∧ (∀ z, S z → ∃ w, S w ∧ «续» R L z w) ∧
    ∀ z, S z → ∃ u v, S u ∧ S v ∧ «所及» R L z u ∧ «传» R L E u v

/-- Keeping (守): along some branch the pattern goes on with no carrying renewal on it. -/
def «守» (R L E : «际» α) (x : α) : Prop :=
  ∃ S : α → Prop, S x ∧ (∀ z, S z → ∃ w, S w ∧ «续» R L z w) ∧ ∀ u v, S u → S v → ¬ «传» R L E u v

/-- Degeneration (退化): the pattern ends on every branch. -/
def «退化» (R L : «际» α) (x : α) : Prop := «尽» R L x

/-- Renewing and still ending (新而尽): a carrying renewal ahead, and an end on every branch. -/
def «新而尽» (R L E : «际» α) (x : α) : Prop :=
  «尽» R L x ∧ ∃ u v, «所及» R L x u ∧ «传» R L E u v

theorem «生成则延» {R L E : «际» α} {x : α} (h : «生成» R L E x) : «延» R L x :=
  match h with | ⟨S, hx, hS, _⟩ => ⟨S, hx, hS⟩

theorem «守则延» {R L E : «际» α} {x : α} (h : «守» R L E x) : «延» R L x :=
  match h with | ⟨S, hx, hS, _⟩ => ⟨S, hx, hS⟩

/-- Generation and degeneration exclude each other. -/
theorem «生成退化不并» {R L E : «际» α} {x : α} : ¬ («生成» R L E x ∧ «退化» R L x) :=
  fun ⟨g, d⟩ => «延尽不并» d («生成则延» g)

/-- Keeping and degeneration exclude each other. -/
theorem «守退化不并» {R L E : «际» α} {x : α} : ¬ («守» R L E x ∧ «退化» R L x) :=
  fun ⟨k, d⟩ => «延尽不并» d («守则延» k)

/-- Where each occurrence conditions at most one other, a family closed under going on contains
everything the line reaches. -/
theorem «单行则族含所及» {R L : «际» α} (func : ∀ {z w w' : α}, R z w → R z w' → w = w')
    {S : α → Prop} (hS : ∀ z, S z → ∃ w, S w ∧ «续» R L z w) :
    ∀ {z y : α}, S z → «相续» R L z y → S y := by
  intro z y hz h
  induction h with
  | one c => match hS _ hz with
    | ⟨w, hw, c'⟩ => exact (func c.1 c'.1) ▸ hw
  | more c _ ih => match hS _ hz with
    | ⟨w, hw, c'⟩ => exact ih ((func c.1 c'.1) ▸ hw)

/-- **On a single line, generation and keeping exclude each other.** Where each occurrence conditions
at most one other, the branch is unique, so renewing on it and not renewing on it cannot both hold. -/
theorem «单行则生守不并» {R L E : «际» α} (func : ∀ {z w w' : α}, R z w → R z w' → w = w') {x : α} :
    ¬ («生成» R L E x ∧ «守» R L E x) := by
  intro ⟨⟨S₁, h₁, _, ahead⟩, ⟨S₂, h₂, closed, none₂⟩⟩
  match ahead x h₁ with
  | ⟨u, v, _, _, hu, c⟩ =>
    have su : S₂ u := match hu with
      | .inl e => e ▸ h₂
      | .inr l => «单行则族含所及» (R := R) (L := L) func closed h₂ l
    have sv : S₂ v := «单行则族含所及» (R := R) (L := L) func closed su (.one c.1)
    exact none₂ u v su sv c

/-- **Telling going on from ending is exactly excluded middle.** That every point, in every model,
goes on along some branch or ends on every branch decides every proposition. -/
theorem «延尽之定当且仅当排中» :
    (∀ (β : Type) (R L : «际» β) (x : β), «延» R L x ∨ «尽» R L x) ↔ ∀ P : Prop, P ∨ ¬ P := by
  constructor
  · intro h P
    match h Unit (fun _ _ => P) «一» () with
    | .inl ⟨S, hx, hS⟩ => match hS () hx with
      | ⟨_, _, c⟩ => exact .inl c.1
    | .inr d => exact .inr fun hp => «延尽不并» d ⟨fun _ => True, trivial, fun _ _ => ⟨(), trivial, hp, trivial⟩⟩
  · intro em β R L x
    match em («尽» R L x) with
    | .inl d => exact .inr d
    | .inr nd =>
      refine .inl ⟨fun y => ¬ «尽» R L y, nd, fun z hz => ?_⟩
      match em (∃ w, ¬ «尽» R L w ∧ «续» R L z w) with
      | .inl ⟨w, hw, c⟩ => exact ⟨w, hw, c⟩
      | .inr hne =>
        exact absurd (.mk fun w c => match em («尽» R L w) with
          | .inl d => d
          | .inr nw => absurd ⟨w, nw, c⟩ hne) hz

/-- Generation at every order (阶生成), read on some branch. -/
def «阶生成» (R : «际» α) (Es : Nat → «际» α) (k : Nat) (x : α) : Prop :=
  «生成» R (Es (k + 1)) (Es k) x

/-- Generation at an order keeps the next order's pattern from ending on every branch. -/
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
theorem Endless.generation : «全生成» step «一» «静» 0 := by
  refine ⟨fun y _ => ⟨y + 1, rfl, trivial⟩, fun y _ => ⟨y, y + 1, .inl rfl, ⟨rfl, trivial⟩, ?_⟩⟩
  intro ⟨z, hz, e⟩
  cases e
  exact step_irrefl _ hz

/-- A pattern that stays as it is: one occurrence conditioning itself. -/
def still : «际» Unit := fun _ _ => True

/-- Keeping is inhabited: the still pattern never ends and never renews. -/
theorem Still.keeping : «全守» still «一» «一» () :=
  ⟨fun _ _ => ⟨(), trivial, trivial⟩, ⟨(), .inl rfl, fun _ _ _ ⟨_, hb⟩ => hb ⟨(), trivial, trivial⟩⟩⟩

/-- A short life: two occurrences, the first conditioning the second, and no more. -/
def short : «际» Bool := fun a b => a = false ∧ b = true

theorem short_end : «亡» short «一» true :=
  fun ⟨_, h, _⟩ => Bool.noConfusion h.1

/-- Degeneration is inhabited: the short life ends. -/
theorem Short.degeneration : «有终» short «一» false :=
  ⟨true, .inr (.one ⟨⟨rfl, rfl⟩, trivial⟩), short_end⟩

/-- Renewal does not decide the region: the short life renews (its second occurrence begins a new
part under identity, carried by the pattern) and still ends. -/
theorem Short.renews_and_ends : «新而有终» short «一» «静» false := by
  refine ⟨Short.degeneration, false, true, .inl rfl, ⟨⟨rfl, rfl⟩, trivial⟩, ?_⟩
  intro ⟨z, hz, e⟩
  cases e
  exact Bool.noConfusion hz.1

/-- The endless chain generates on its branch. -/
theorem Endless.generates : «生成» step «一» «静» 0 :=
  ⟨fun _ => True, trivial, fun z _ => ⟨z + 1, trivial, rfl, trivial⟩,
   fun z _ => ⟨z, z + 1, trivial, trivial, .inl rfl, ⟨rfl, trivial⟩, fun ⟨w, hw, e⟩ => by
     cases e; exact step_irrefl _ hw⟩⟩

/-- The still pattern keeps on its branch. -/
theorem Still.keeps : «守» still «一» «一» () :=
  ⟨fun _ => True, trivial, fun _ _ => ⟨(), trivial, trivial, trivial⟩,
   fun _ _ _ _ ⟨_, hb⟩ => hb ⟨(), trivial, trivial⟩⟩

/-- The short life ends on every branch. -/
theorem Short.ends : «退化» short «一» false :=
  .mk fun y c => match y, c with
    | true, _ => .mk fun z c' => absurd c'.1.1 (by intro h; cases h)
    | false, c => absurd c.1.2 (by intro h; cases h)

/-- The short life renews and still ends on every branch. -/
theorem Short.renews_and_ends_everywhere : «新而尽» short «一» «静» false :=
  ⟨Short.ends, false, true, .inl rfl, ⟨⟨rfl, rfl⟩, trivial⟩, fun ⟨z, hz, e⟩ => by
    cases e; exact Bool.noConfusion hz.1⟩

/-- A root with two branches: a chain that renews at every step, and a still occurrence. -/
inductive Branch | root | chain (n : Nat) | still

/-- The root conditions the chain's first link and the still occurrence; each link the next; the
still occurrence itself. -/
def fork : «际» Branch
  | .root, .root => False
  | .root, .chain n => n = 0
  | .root, .still => True
  | .chain _, .root => False
  | .chain n, .chain m => m = n + 1
  | .chain _, .still => False
  | .still, .root => False
  | .still, .chain _ => False
  | .still, .still => True

theorem fork_chain_begins (n : Nat) : «生» fork «静» (.chain n) := fun ⟨w, hw, e⟩ => by
  cases e; exact step_irrefl n hw

/-- **The mixed region is inhabited (生守相杂).** At the root, the pattern generates along the chain
and keeps along the still occurrence: on a branching net a point can lie in both regions. -/
theorem «生守相杂» : «生成» fork «一» «静» .root ∧ «守» fork «一» «静» .root := by
  refine ⟨⟨fun z => match z with | .root => True | .chain _ => True | .still => False, trivial, ?_, ?_⟩,
          ⟨fun z => match z with | .root => True | .chain _ => False | .still => True, trivial, ?_, ?_⟩⟩
  · intro z hz
    match z, hz with
    | .root, _ => exact ⟨.chain 0, trivial, rfl, trivial⟩
    | .chain n, _ => exact ⟨.chain (n + 1), trivial, rfl, trivial⟩
  · intro z hz
    match z, hz with
    | .root, _ => exact ⟨.root, .chain 0, trivial, trivial, .inl rfl, ⟨rfl, trivial⟩, fork_chain_begins 0⟩
    | .chain n, _ => exact ⟨.chain n, .chain (n + 1), trivial, trivial, .inl rfl, ⟨rfl, trivial⟩,
        fork_chain_begins (n + 1)⟩
  · intro z hz
    match z, hz with
    | .root, _ => exact ⟨.still, trivial, trivial, trivial⟩
    | .still, _ => exact ⟨.still, trivial, trivial, trivial⟩
  · intro u v hu hv ⟨⟨r, _⟩, hb⟩
    match u, v, hu, hv with
    | .root, .root, _, _ => exact r
    | .root, .still, _, _ => exact hb ⟨.still, trivial, rfl⟩
    | .still, .root, _, _ => exact r
    | .still, .still, _, _ => exact hb ⟨.still, trivial, rfl⟩

end Map

end Becoming
