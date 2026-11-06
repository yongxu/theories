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
| `«全生成»` | generation in the strong form: the coarse line never ends and a carrying renewal lies ahead of every point of it |
| `«全守»` | keeping in the strong form: the coarse line never ends, and from some point no carrying renewal lies ahead |
| `«有终»` | reaching an end: some point the coarse line reaches ends (not degeneration, `«退化»`, which is ending on every branch) |
| `«新而有终»` | renewing and still ending: a carrying renewal on a line that ends |

The strong forms exclude each other (`«全生成有终不并»`, `«全生成全守不并»`, `«全守有终不并»`), each is
inhabited (`Map.Endless.generation`, `Map.Still.keeping`, `Map.Short.reaches_end`; the last states
only an end, 有终, and that the same point degenerates is `Map.Short.ends`), and with excluded
middle as a hypothesis they cover every point (`«全三域之周»`). 全生成 holds along its own line
(`«全生成之所及亦全生成»`) and an end reaches back along it (`«有终之所前亦有终»`). A carrying renewal
is an alteration (`«传则异»`). A coarse class constant under 缘 has no end from a continued point
(`«有常则无终»`), so what reaches an end after a continued step has a coarse class that is not
constant (`«有终则粗不有常»`). Renewal does not decide the
region: a line can renew and still end (`Map.Short.renews_and_ends`). Telling a coarse line that never ends from
one that reaches an end, at every point of every model, is exactly excluded middle
(`«不穷有终之定当且仅当排中»`), and so is placing every point in one of the three strong forms
(`«全三域之定当且仅当排中»`): the boundary between them is where a line's going on is not decided.

Ending on every branch and reaching an end. What ends on every branch reaches an end up to double
negation (`«尽则非无终»`), and reaches one where going on is decided at the points of its line
(`«尽而续可定则有终»`). The decision cannot be dropped: on the short life's two points, with its one
step taken exactly where a proposition `P` holds (`Map.StepWhere`), the line from `false` ends on
every branch while an end decides `P`, so that every line ending on every branch reaches an end is
exactly excluded middle (`«尽则有终当且仅当排中»`). The two calibrations above ask which region a
point lies in; this one knows the region, every branch ending, and asks where an end lies.

Higher orders: a sequence of classes `Es` reads generation at order `k` as the order-`k + 1` pattern
continuing through order-`k` renewals (`«阶全生成»`); no order between the classes is assumed, and the
reading is meant for each class finer than the next. Every order reads the same relation `R`; the
grammar's coarse net (`«粗»`) is not used here.

Read along renewing into under the one, renewal without end (`«生生»` of `Becoming.Grammar`) is
going on along some branch (`«生生即延»`) and ceasing (`«息»`) is ending on every branch (`«息即尽»`).

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

/-- Generation in the strong form (全生成): the coarse line from `x` never ends, and ahead of every
point of it lies a carrying renewal. -/
def «全生成» (R L E : «际» α) (x : α) : Prop :=
  «不穷» R L x ∧ ∀ y, «所及» R L x y → ∃ z w, «所及» R L y z ∧ «传» R L E z w

/-- Keeping in the strong form (全守): the coarse line from `x` never ends, and from some point on no
carrying renewal lies ahead. -/
def «全守» (R L E : «际» α) (x : α) : Prop :=
  «不穷» R L x ∧ ∃ y, «所及» R L x y ∧ ∀ z w, «所及» R L y z → ¬ «传» R L E z w

/-- Reaching an end (有终): some point the coarse line from `x` reaches ends. This is not degeneration
(`«退化»`, ending on every branch). -/
def «有终» (R L : «际» α) (x : α) : Prop := ∃ y, «所及» R L x y ∧ «亡» R L y

/-- Renewing and still ending (新而终): a carrying renewal on a coarse line that ends. -/
def «新而有终» (R L E : «际» α) (x : α) : Prop :=
  «有终» R L x ∧ ∃ z w, «所及» R L x z ∧ «传» R L E z w

/-- 全生成 and an end exclude each other. -/
theorem «全生成有终不并» {R L E : «际» α} {x : α} : ¬ («全生成» R L E x ∧ «有终» R L x) :=
  fun ⟨⟨endless, _⟩, ⟨y, hy, ends⟩⟩ => ends (endless y hy)

/-- 全生成 and 全守 exclude each other. -/
theorem «全生成全守不并» {R L E : «际» α} {x : α} : ¬ («全生成» R L E x ∧ «全守» R L E x) :=
  fun ⟨⟨_, ahead⟩, ⟨_, ⟨y, hy, noRenewal⟩⟩⟩ =>
    match ahead y hy with
    | ⟨z, w, hz, c⟩ => noRenewal z w hz c

/-- 全守 and an end exclude each other. -/
theorem «全守有终不并» {R L E : «际» α} {x : α} : ¬ («全守» R L E x ∧ «有终» R L x) :=
  fun ⟨⟨endless, _⟩, ⟨y, hy, ends⟩⟩ => ends (endless y hy)

/-- A coarse class constant under 缘 has no end from a continued point. -/
theorem «有常则无终» {R L : «际» α} (hc : «有常» R L) {x : α} (hx : «有前» R L x) :
    ¬ «有终» R L x :=
  fun ⟨y, hy, ends⟩ => ends (match hy with
    | .inl e => by cases e; exact «有常则续不尽» hc hx
    | .inr l => «有常则相续不尽» hc l)

/-- What reaches an end after a continued step has a coarse class that is not constant. -/
theorem «有终则粗不有常» {R L : «际» α} {x : α} (hx : «有前» R L x) (h : «有终» R L x) :
    ¬ «有常» R L :=
  fun hc => («有常则无终» hc hx) h

/-- **Telling a line that never ends from one that ends is exactly excluded middle.** That from
every point, in every model, the coarse line either never ends or reaches an end decides every
proposition: the boundary is where a line's going on is not decided. -/
theorem «不穷有终之定当且仅当排中» :
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

/-- 全生成 holds along its own line: what such a line reaches is 全生成 too. -/
theorem «全生成之所及亦全生成» {R L E : «际» α} {x y : α} (h : «全生成» R L E x) (hy : «所及» R L x y) :
    «全生成» R L E y :=
  ⟨fun z hz => h.1 z («所及之传递» hy hz), fun z hz => h.2 z («所及之传递» hy hz)⟩

/-- An end reaches back along the line: what reaches a point whose line reaches an end reaches one too. -/
theorem «有终之所前亦有终» {R L : «际» α} {x y : α} (hy : «所及» R L x y) (h : «有终» R L y) :
    «有终» R L x :=
  match h with
  | ⟨z, hz, ends⟩ => ⟨z, «所及之传递» hy hz, ends⟩

/-- **With excluded middle the strong forms cover every point.** Every point of every coarse line is
全生成, 全守 or reaches an end; that this holds in every model is excluded middle
(`«全三域之定当且仅当排中»`). -/
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

/-- **Placing every point in one of the three strong forms is exactly excluded middle.** That every
point of every model is 全生成, 全守 or reaches an end decides every proposition; with excluded
middle every point is so placed (`«全三域之周»`). -/
theorem «全三域之定当且仅当排中» :
    (∀ (β : Type) (R L E : «际» β) (x : β), «全生成» R L E x ∨ «全守» R L E x ∨ «有终» R L x) ↔
      ∀ P : Prop, P ∨ ¬ P := by
  constructor
  · intro h P
    have going : «不穷» (fun _ _ : Unit => P) «一» () → P := fun endless =>
      match endless () (.inl rfl) with
      | ⟨_, hp, _⟩ => hp
    match h Unit (fun _ _ => P) «一» «一» () with
    | .inl g => exact .inl (going g.1)
    | .inr (.inl k) => exact .inl (going k.1)
    | .inr (.inr ⟨_, _, ends⟩) => exact .inr fun hp => ends ⟨(), hp, trivial⟩
  · intro em β R L E x
    exact «全三域之周» em R L E x

/-- Higher orders (阶): a sequence of classes `Es` reads generation at order `k` as the order-`k + 1`
pattern continuing through order-`k` renewals. No order between the classes is assumed; the reading
is meant for each class finer than the next. -/
def «阶全生成» (R : «际» α) (Es : Nat → «际» α) (k : Nat) (x : α) : Prop :=
  «全生成» R (Es (k + 1)) (Es k) x

/-- 全生成 at an order keeps the next order's line from reaching an end. -/
theorem «阶全生成则上无终» {R : «际» α} {Es : Nat → «际» α} {k : Nat} {x : α}
    (h : «阶全生成» R Es k x) : ¬ «有终» R (Es (k + 1)) x :=
  fun d => «全生成有终不并» ⟨h, d⟩

/-! ### Some branch and every branch

A pattern whose parts branch (a species whose members die, a fire passed along several fuels) has
lines that end while it goes on. So the regions are read on branches: the pattern goes on along some
branch (`«延»`, coinductive) or ends on every branch (`«尽»`, inductive). The forms above that read
the whole coarse line are stronger and weaker than these: `«全生成»` and `«全守»` ask every point
reached to go on (`«不穷»`), which gives `«延»` (`«不穷则延»`), and `«有终»` asks an end at one point
reached, where `«尽»` asks one on every branch. How `«全生成»` and `«全守»` stand to `«生成»` and
`«守»` is stated in modules that import this one: strong generation gives generation (`«全生成则生成»`,
`Becoming.KeepingWidening`), and strong keeping gives keeping from some point on (`«全守则后守»`,
`Becoming.MapRegions`) but not strict keeping, since `«全守»` allows a carrying renewal before its point,
which `«守»` forbids (`Map.Once.keeping`, `Map.Once.not_keeps`). How `«有终»` stands to `«退化»` is
stated here: `«尽»` gives `«有终»` up to double negation (`«尽则非无终»`) and where going on is
decided (`«尽而续可定则有终»`), and with no decision exactly under excluded middle
(`«尽则有终当且仅当排中»`). -/

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

/-- **Ending on every branch reaches an end, up to double negation.** -/
theorem «尽则非无终» {R L : «际» α} {x : α} (h : «尽» R L x) : ¬ ¬ «有终» R L x := by
  induction h with
  | mk _ ih =>
    intro none
    exact none ⟨_, .inl rfl, fun ⟨y, c⟩ =>
      ih y c fun ⟨w, hw, ends⟩ => none ⟨w, «所及之传递» (.inr (.one c)) hw, ends⟩⟩

/-- **Ending on every branch reaches an end where going on is decided** at the points of the
line. -/
theorem «尽而续可定则有终» {R L : «际» α} {x : α} (h : «尽» R L x) :
    (∀ y, «所及» R L x y → «有后» R L y ∨ ¬ «有后» R L y) → «有终» R L x := by
  induction h with
  | mk _ ih =>
    intro decided
    exact match decided _ (.inl rfl) with
      | .inr ends => ⟨_, .inl rfl, ends⟩
      | .inl ⟨y, c⟩ =>
        match ih y c (fun z hz => decided z («所及之传递» (.inr (.one c)) hz)) with
        | ⟨w, hw, ends⟩ => ⟨w, «所及之传递» (.inr (.one c)) hw, ends⟩

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

/-- **Renewal without end is going on along some branch of renewing into (生生即延).** -/
theorem «生生即延» {R E : «际» α} {x : α} : «生生» R E x ↔ «延» («复生至» R E) «一» x :=
  ⟨fun ⟨S, hS, hx⟩ => ⟨S, hx, fun z hz => match hS z hz with
      | ⟨y, w, hr, hb, hl, hw⟩ => ⟨w, hw, ⟨y, hr, hb, hl⟩, trivial⟩⟩,
   fun ⟨S, hx, hS⟩ => ⟨S, fun z hz => match hS z hz with
      | ⟨w, hw, ⟨y, hr, hb, hl⟩, _⟩ => ⟨y, w, hr, hb, hl, hw⟩, hx⟩⟩

/-- **Ceasing is ending on every branch of renewing into (息即尽).** -/
theorem «息即尽» {R E : «际» α} {x : α} : «息» R E x ↔ «尽» («复生至» R E) «一» x := by
  constructor
  · intro h
    induction h with
    | mk _ ih => exact .mk fun w c => ih w c.1
  · intro h
    induction h with
    | mk _ ih => exact .mk fun w c => ih w ⟨c, trivial⟩

end Map

/-! ## The three regions, inhabited -/

namespace Map

/-- Endless renewal: each number conditions the next. Under the one the pattern goes on, and under
identity each step begins a new part. -/
def step : «际» Nat := fun m n => n = m + 1

theorem step_irrefl : ∀ n, ¬ step n n
  | 0, h => Nat.noConfusion h
  | n + 1, h => step_irrefl n (Nat.succ.inj h)

/-! The reach laws of the successor, stated once here, below every module that reads a line along it
(`MapRegions`, `WideningOnTheMap`'s `Steps.reached_le`, `HeldPossible`, and `Sampling`'s `arises_within`
after HE2's item 1). -/

/-- What a line along the steps reaches is later. -/
theorem step_reached_le {L : «际» Nat} : ∀ {x y : Nat}, «所及» step L x y → x ≤ y := by
  intro x y h
  match h with
  | .inl e => exact Nat.le_of_eq e
  | .inr l =>
    have later : ∀ {a b : Nat}, «相续» step L a b → a + 1 ≤ b := by
      intro a b l
      induction l with
      | one c => exact Nat.le_of_eq c.1.symm
      | more c _ ih => exact c.1 ▸ Nat.le_of_succ_le ih
    exact Nat.le_of_succ_le (later l)

/-- Under the one, the steps from the first reach every step. -/
theorem step_reaches : ∀ n, «所及» step «一» 0 n
  | 0 => .inl rfl
  | n + 1 => «所及之传递» (step_reaches n) (.inr (.one ⟨rfl, trivial⟩))

/-- Under the one, the steps reach every later step. -/
theorem step_reaches_of_le : ∀ {z n : Nat}, z ≤ n → «所及» step «一» z n := by
  intro z n le
  induction le with
  | refl => exact .inl rfl
  | step _ ih => exact «所及之传递» ih (.inr (.one ⟨rfl, trivial⟩))

/-- 全生成 is inhabited: the endless chain, under the one, renews at every step, since under identity
every step leaves its kind. `Endless.generation_in_pairs` has it under a class that also goes on. -/
theorem Endless.generation : «全生成» step «一» «静» 0 := by
  refine ⟨fun y _ => ⟨y + 1, rfl, trivial⟩, fun y _ => ⟨y, y + 1, .inl rfl, ⟨rfl, trivial⟩, ?_⟩⟩
  intro ⟨z, hz, e⟩
  cases e
  exact step_irrefl _ hz

/-- Half a number, rounded down: the block of two it lies in. -/
def half : Nat → Nat
  | 0 => 0
  | 1 => 0
  | n + 2 => half n + 1

/-- The class of lying in one block of two. -/
def pairs : «际» Nat := fun a b => half a = half b

/-- Beyond every number lies a step into a new block. -/
theorem half_rises_beyond : ∀ y, ∃ u, y ≤ u ∧ half (u + 1) = half u + 1
  | 0 => ⟨1, Nat.zero_le _, rfl⟩
  | y + 1 => match half_rises_beyond y with
    | ⟨u, le, e⟩ => ⟨u + 2, Nat.succ_le_succ (Nat.le_succ_of_le le), congrArg (· + 1) e⟩

/-- **全生成 where a kind goes on**: under the class of lying in one block of two, the endless chain
renews beyond every point, though the step from `0` continues its kind. So generation does not need
identity, under which no step continues. -/
theorem Endless.generation_in_pairs :
    «全生成» step «一» pairs 0 ∧ «续» step pairs 0 1 := by
  refine ⟨⟨fun y _ => ⟨y + 1, rfl, trivial⟩, fun y _ => ?_⟩, rfl, rfl⟩
  match half_rises_beyond y with
  | ⟨u, le, e⟩ =>
    refine ⟨u, u + 1, step_reaches_of_le le, ⟨rfl, trivial⟩, ?_⟩
    intro ⟨z, hz, same⟩
    have uz : u = z := Nat.succ.inj hz
    subst uz
    exact Nat.succ_ne_self _ (e.symm.trans same.symm)

/-- A pattern that stays as it is: one occurrence conditioning itself. -/
def still : «际» Unit := fun _ _ => True

/-- 全守 is inhabited: the still pattern never ends and never renews. -/
theorem Still.keeping : «全守» still «一» «一» () :=
  ⟨fun _ _ => ⟨(), trivial, trivial⟩, ⟨(), .inl rfl, fun _ _ _ ⟨_, hb⟩ => hb ⟨(), trivial, trivial⟩⟩⟩

/-- A short life: two occurrences, the first conditioning the second, and no more. -/
def short : «际» Bool := fun a b => a = false ∧ b = true

theorem short_end : «亡» short «一» true :=
  fun ⟨_, h, _⟩ => Bool.noConfusion h.1

/-- An end is inhabited: the short life reaches an end (有终); that the same point degenerates is
`Map.Short.ends`. -/
theorem Short.reaches_end : «有终» short «一» false :=
  ⟨true, .inr (.one ⟨⟨rfl, rfl⟩, trivial⟩), short_end⟩

/-- Renewal does not decide the region: the short life renews (its second occurrence begins a new
part under identity, carried by the pattern) and still ends. -/
theorem Short.renews_and_ends : «新而有终» short «一» «静» false := by
  refine ⟨Short.reaches_end, false, true, .inl rfl, ⟨⟨rfl, rfl⟩, trivial⟩, ?_⟩
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

/-! ### Reaching an end needs the decision -/

namespace StepWhere

/-- The short life gated by `P`: its one step, from `false` to `true`, taken exactly where `P`
holds. -/
def relation (P : Prop) : «际» Bool := fun x y => short x y ∧ P

/-- Witness lemma: under the one (`«一»`), the line from `false` ends on every branch, at every
proposition: a step from `false` reaches `true`, and nothing steps from `true`. -/
theorem ends (P : Prop) : «尽» (relation P) «一» false :=
  .mk fun _ c => .mk fun _ c' => Bool.noConfusion (c.1.1.2.symm.trans c'.1.1.1)

/-- Witness lemma: `false` has a continuation exactly where `P` holds. -/
theorem has_next_iff (P : Prop) : «有后» (relation P) «一» false ↔ P :=
  ⟨fun ⟨_, c⟩ => c.1.2, fun p => ⟨true, ⟨⟨rfl, rfl⟩, p⟩, trivial⟩⟩

/-- Witness lemma: **reaching an end from `false` decides `P`.** -/
theorem end_decides {P : Prop} (h : «有终» (relation P) «一» false) : P ∨ ¬ P :=
  match h with
  | ⟨_, .inl same, ends⟩ =>
    .inr fun p => ends (Eq.subst (motive := fun z => «有后» (relation P) «一» z) same
      ((has_next_iff P).mpr p))
  | ⟨_, .inr (.one c), _⟩ => .inl c.1.2
  | ⟨_, .inr (.more c _), _⟩ => .inl c.1.2

end StepWhere

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

/-! ## Ending on every branch and reaching an end -/

/-- **That every line ending on every branch reaches an end is exactly excluded middle**, at every
carrier and relation. The forward direction is witnessed by `Map.StepWhere` alone: what is
undecided is not whether a course goes on without end, since every branch ends, but whether its
one step is taken. -/
theorem «尽则有终当且仅当排中» :
    (∀ (β : Type) (R L : «际» β) (x : β), «尽» R L x → «有终» R L x) ↔ ∀ P : Prop, P ∨ ¬ P :=
  ⟨fun h P => Map.StepWhere.end_decides (h _ _ _ _ (Map.StepWhere.ends P)),
   fun em _ _ _ _ ends => «尽而续可定则有终» ends fun _ _ => em _⟩

end Becoming
