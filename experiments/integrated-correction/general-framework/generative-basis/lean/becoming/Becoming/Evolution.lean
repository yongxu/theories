import Becoming.Change

/-!
# Evolution: descent, transmission, variation and selection

Read with one kind of relatum, a formation can give to a relatum as it comes to stand.
This module states that relation and the minimal formal content of evolution on it, read
of the dependences descendants carry: what is transmitted, how it varies, what selects
it, and how activity changes the conditions of later selection. It does not replace the
theory of evolution's own programme, whose mechanisms of copying, reconstruction,
development and organizational inheritance keep their scope; it states what holds
wherever descent, dependence and support are read on one unfolding.

* **Descent.** A relatum descends from a formation across a step when the formation takes
  part in the step and gives to it, and it comes to stand across the step
  (`Flow.DescendsAt`, `Flow.Descends`). `Becoming.Descent` reads the relation in
  valuation.
* **An arithmetic identity with no premise.** Over any finite family of parents, each
  with a finite list of offspring, and any amounts read of parents and offspring, the
  offspring's total with what transmission lowered is the parents' amounts weighted by
  their offspring, each counted once for every offspring, with what transmission raised
  (`price`). This is the counting form of Price's equation (Price 1970): it divides the
  offspring's total into the weighted parents' amounts and the change from each parent to
  its offspring. The weighted total is not selection proper: where every parent has the
  same number of offspring it is that number times the parents' total
  (`selected_uniform`), and with one parent and one unchanged offspring it is the parent's
  amount (`unselected`). The selection term proper, the covariance of offspring number
  and amount, is not stated. Nothing is supposed about how the offspring come about.
* **Selection through support.** Where only active formations give and activity needs
  support (`Flow.Acting`, `Web.Dependent`), a formation that a relatum descends from
  across a step is supported at that step (`Flow.DescendsAt.supported`). A formation
  unsupported at a step leaves no descendant across it (`Flow.unsupported_childless`),
  and one never supported leaves none (`Flow.never_supported_childless`). Read of needs
  on a condition every parent depends on, the parents' needs weighted by their offspring
  are at most the condition's level counted once for every offspring (`Flow.selected_le`),
  so the
  offspring's total of any amount, with what transmission lowered from the parents' needs,
  is at most the level so counted, with what transmission raised
  (`Flow.selection_within`).
* **Transmission with variation.** A flow *transmits* a dependence within `δ` when a
  relatum depending on the condition at its first standing step descends only from
  formations depending on it at the giving step, and needs it at most `δ` more
  (`Flow.TransmitsWithin`). Then what is transmitted was selected within `δ`: a
  descendant's need is at most the condition's level at the step it was given, plus `δ`
  (`Flow.transmitted_supported`). With `δ` zero the need was met there; with `δ` one a
  descendant's need can exceed its condition's level at the giving step and at every step
  (`Slack`).
* **Activity sets later selection.** In a balanced flow, a descendant's need with
  everything taken from its condition since an earlier step is at most the condition's
  level then, with everything given to it since, plus `δ` (`Flow.transmitted_within`).
  What formations take and give between enters what can be transmitted later.
* **Witnesses.** A parent depending on a pool at need two takes from it and gives to two
  descendants (`Drawdown`). The one inheriting its need is unsupported from its first
  standing step on, since the parent's taking lowered the pool; the one needing less is
  supported, active and takes in turn. Transmission, variation, selection and the
  feedback of activity on selection occur in one unfolding. Without `Dependent`, a
  formation active beyond its support transmits a need above the level at the step it
  gives (`Unchecked`).

Needs are the amounts read here because the spine's webs carry them; `price` holds of any
amount. Fitness is not defined: the number of offspring enters only as the weight in
`price`, and support only as the condition of giving. That descendants carry their
parents' dependences is a premise (`Flow.TransmitsWithin`), as reconstruction is in the
theory of evolution; the spine does not derive it. No ethical predicate, ranking or axiom
occurs.
-/

namespace Becoming

variable {α X : Type}

/-! ## A law of transmission -/

/-- A constant counted over a list is the constant once for each member. -/
theorem total_const (c : Nat) (ks : List α) : total ks (fun _ => c) = ks.length * c :=
  (total_congr (fun _ => (Nat.mul_one c).symm) ks).trans
    ((total_mul c (fun _ => 1) ks).trans
      ((congrArg (c * ·) (total_ones ks)).trans (Nat.mul_comm c ks.length)))

/-- Bounding a constant at each member bounds it counted over the list. -/
theorem length_mul_le {ks : List α} {a b : Nat} (le : ∀ k, k ∈ ks → a ≤ b) :
    ks.length * a ≤ ks.length * b :=
  match ks, le with
  | [], _ => Nat.le_of_eq ((Nat.zero_mul a).trans (Nat.zero_mul b).symm)
  | k :: _, le => Nat.mul_le_mul_left _ (le k (.head _))

/-- The offspring's total of an amount, over a finite family of parents. -/
def offspring (ps : List α) (kids : α → List α) (b : α → Nat) : Nat :=
  total ps fun p => total (kids p) b

/-- The parents' amounts weighted by their offspring: each parent's amount, counted once
for every offspring. It is the first term of the counting form, not selection proper
(`selected_uniform`). -/
def selected (ps : List α) (kids : α → List α) (a : α → Nat) : Nat :=
  total ps fun p => (kids p).length * a p

/-- What transmission raised: by how much offspring exceed their parent. -/
def raised (ps : List α) (kids : α → List α) (a b : α → Nat) : Nat :=
  total ps fun p => total (kids p) fun k => excess (b k) (a p)

/-- What transmission lowered: by how much offspring fall short of their parent. -/
def lowered (ps : List α) (kids : α → List α) (a b : α → Nat) : Nat :=
  total ps fun p => total (kids p) fun k => excess (a p) (b k)

/-- The counting form of Price's equation, an arithmetic identity: the offspring's total
with what transmission lowered is the parents' amounts weighted by their offspring with
what transmission raised. -/
theorem price (ps : List α) (kids : α → List α) (a b : α → Nat) :
    offspring ps kids b + lowered ps kids a b = selected ps kids a + raised ps kids a b :=
  (total_add (fun p => total (kids p) b) (fun p => total (kids p) fun k => excess (a p) (b k))
    ps).symm.trans
    ((total_congr (fun p =>
      (total_add b (fun k => excess (a p) (b k)) (kids p)).symm.trans
        ((total_congr (fun k => excess_balance (b k) (a p)) (kids p)).trans
          ((total_add (fun _ => a p) (fun k => excess (b k) (a p)) (kids p)).trans
            (congrArg (· + _) (total_const (a p) (kids p)))))) ps).trans
      (total_add (fun p => (kids p).length * a p)
        (fun p => total (kids p) fun k => excess (b k) (a p)) ps))

/-- The weighted total is not selection: where every parent has `k` offspring, it is `k`
times the parents' total, whatever the amounts (the ninth review's probe). -/
theorem selected_uniform (ps : List α) (kids : α → List α) (a : α → Nat) (k : Nat)
    (same : ∀ p, (kids p).length = k) : selected ps kids a = k * total ps a :=
  (total_congr (fun p => congrArg (· * a p) (same p)) ps).trans (total_mul k a ps)

/-- One parent with one offspring, both at five: nothing is selected and transmission
changes nothing, and the weighted total is five. -/
theorem unselected :
    selected [()] (fun _ => [()]) (fun _ => 5) = 5 ∧
    raised [()] (fun _ => [()]) (fun _ => 5) (fun _ => 5) = 0 ∧
    lowered [()] (fun _ => [()]) (fun _ => 5) (fun _ => 5) = 0 ∧
    offspring [()] (fun _ => [()]) (fun _ => 5) = 5 :=
  ⟨rfl, rfl, rfl, rfl⟩

/-! ## Descent -/

namespace Flow

section Descent

variable (L : Flow X X) (W : Web X X)

/-- `x` descends from `g` across the step from `t`: `g` takes part in the step, gives to `x`
and `x` comes to stand across it. -/
def DescendsAt (t : Nat) (x g : X) : Prop :=
  g ∈ L.present t ∧ 0 < L.give t g x ∧ W.ComesToStand t x

/-- `x` descends from `g`: across some step `g` takes part, gives to `x`, and `x` comes to
stand. -/
def Descends (x g : X) : Prop :=
  ∃ t, L.DescendsAt W t x g

end Descent

/-! ## Selection through support -/

variable {L : Flow X X} {W : Web X X}

/-- Where only active formations give, a formation that a relatum descends from across a
step is active at that step. -/
theorem DescendsAt.active (acting : L.Acting W) {t : Nat} {x g : X}
    (descends : L.DescendsAt W t x g) : W.active t g :=
  acting t g x descends.1 descends.2.1

/-- A parent giving at descent only while active, and active only while supported, is
supported at that step: its activity and support at that one step are all that is used. -/
theorem DescendsAt.supported_at {t : Nat} {x g : X}
    (acting : g ∈ L.present t → 0 < L.give t g x → W.active t g)
    (dependent : W.active t g → W.Supported t g) (descends : L.DescendsAt W t x g) :
    W.Supported t g :=
  dependent (acting descends.1 descends.2.1)

/-- Where activity also needs support, it is supported at that step. -/
theorem DescendsAt.supported (acting : L.Acting W) (dependent : W.Dependent) {t : Nat}
    {x g : X} (descends : L.DescendsAt W t x g) : W.Supported t g :=
  descends.supported_at (acting t g x) (dependent t g)

/-- Selection at one step: a formation unsupported there, giving to `x` only while active
and active only while supported, leaves no descendant `x` across it. -/
theorem unsupported_childless_at {t : Nat} {g : X} (unsupported : ¬ W.Supported t g) {x : X}
    (acting : g ∈ L.present t → 0 < L.give t g x → W.active t g)
    (dependent : W.active t g → W.Supported t g) : ¬ L.DescendsAt W t x g :=
  fun descends => unsupported (descends.supported_at acting dependent)

/-- Selection: a formation unsupported at a step leaves no descendant across it. -/
theorem unsupported_childless (acting : L.Acting W) (dependent : W.Dependent) {t : Nat}
    {g : X} (unsupported : ¬ W.Supported t g) (x : X) : ¬ L.DescendsAt W t x g :=
  unsupported_childless_at unsupported (acting t g x) (dependent t g)

/-- A formation never supported leaves no descendant. -/
theorem never_supported_childless (acting : L.Acting W) (dependent : W.Dependent) {g : X}
    (never : ∀ t, ¬ W.Supported t g) (x : X) : ¬ L.Descends W x g :=
  fun ⟨t, descends⟩ => never t (descends.supported acting dependent)

/-- The weighted needs of the parents, at the step of descent, with each parent giving to
its offspring only while active and active only while supported. -/
theorem selected_le_at {t : Nat} {c : X} {ps : List X} {kids : X → List X}
    (descend : ∀ p k, p ∈ ps → k ∈ kids p → L.DescendsAt W t k p)
    (depends : ∀ p, p ∈ ps → W.requires t p c)
    (acting : ∀ p k, p ∈ ps → k ∈ kids p → 0 < L.give t p k → W.active t p)
    (dependent : ∀ p, p ∈ ps → W.active t p → W.Supported t p) :
    selected ps kids (fun p => W.need t p c) ≤ selected ps kids (fun _ => W.level t c) :=
  total_le ps fun p mem => length_mul_le fun k kid =>
    (descend p k mem kid).supported_at (fun _ gives => acting p k mem kid gives)
      (dependent p mem) c (depends p mem)

/-- So the offspring's total of any amount, at the step of descent, with each parent giving
to its offspring only while active and active only while supported. -/
theorem selection_within_at {t : Nat} {c : X} {ps : List X} {kids : X → List X}
    (descend : ∀ p k, p ∈ ps → k ∈ kids p → L.DescendsAt W t k p)
    (depends : ∀ p, p ∈ ps → W.requires t p c)
    (acting : ∀ p k, p ∈ ps → k ∈ kids p → 0 < L.give t p k → W.active t p)
    (dependent : ∀ p, p ∈ ps → W.active t p → W.Supported t p) (b : X → Nat) :
    offspring ps kids b + lowered ps kids (fun p => W.need t p c) b ≤
      selected ps kids (fun _ => W.level t c) + raised ps kids (fun p => W.need t p c) b :=
  Nat.le_trans (Nat.le_of_eq (price ps kids _ b))
    (Nat.add_le_add_right (selected_le_at descend depends acting dependent) _)

/-- Read of needs on a condition every parent depends on, the parents' needs weighted by
their offspring are at most the condition's level counted once for every offspring. This
bounds a weighted total, not the selection term proper (`unselected`). -/
theorem selected_le (acting : L.Acting W) (dependent : W.Dependent) {t : Nat} {c : X}
    {ps : List X} {kids : X → List X}
    (descend : ∀ p k, p ∈ ps → k ∈ kids p → L.DescendsAt W t k p)
    (depends : ∀ p, p ∈ ps → W.requires t p c) :
    selected ps kids (fun p => W.need t p c) ≤ selected ps kids (fun _ => W.level t c) :=
  selected_le_at descend depends
    (fun p k mem kid gives => acting t p k (descend p k mem kid).1 gives) fun p _ => dependent t p

/-- So the offspring's total of any amount, with what transmission lowered from the
parents' needs, is at most the level counted once for every offspring, with what
transmission raised. -/
theorem selection_within (acting : L.Acting W) (dependent : W.Dependent) {t : Nat} {c : X}
    {ps : List X} {kids : X → List X}
    (descend : ∀ p k, p ∈ ps → k ∈ kids p → L.DescendsAt W t k p)
    (depends : ∀ p, p ∈ ps → W.requires t p c) (b : X → Nat) :
    offspring ps kids b + lowered ps kids (fun p => W.need t p c) b ≤
      selected ps kids (fun _ => W.level t c) + raised ps kids (fun p => W.need t p c) b :=
  Nat.le_trans (Nat.le_of_eq (price ps kids _ b))
    (Nat.add_le_add_right (selected_le acting dependent descend depends) _)

/-! ## Transmission with variation -/

/-- The flow transmits a dependence on `c` within `δ`: a relatum descending across a step
that depends on `c` at its first standing step descends from a formation depending on `c`
at the giving step, and needs `c` at most `δ` more than it did. -/
def TransmitsWithin (L : Flow X X) (W : Web X X) (c : X) (δ : Nat) : Prop :=
  ∀ t x g, L.DescendsAt W t x g → W.requires (t + 1) x c →
    W.requires t g c ∧ W.need (t + 1) x c ≤ W.need t g c + δ

/-- What is transmitted was selected, at the one descent: with the descendant's dependence
inherited within `δ` there and the parent supported, the descendant's need is at most the
condition's level at the step it was given, plus `δ`. -/
theorem transmitted_supported_at {c : X} {δ : Nat} {t : Nat} {x g : X}
    (transmits : W.requires (t + 1) x c →
      W.requires t g c ∧ W.need (t + 1) x c ≤ W.need t g c + δ)
    (supported : W.Supported t g) (depends : W.requires (t + 1) x c) :
    W.need (t + 1) x c ≤ W.level t c + δ :=
  match transmits depends with
  | ⟨inherited, within⟩ => Nat.le_trans within
      (Nat.add_le_add_right (supported c inherited) δ)

/-- Activity sets later selection, at the steps it is used at: with balance at the
condition across each step of the stretch, the descendant's need with everything taken from
the condition since is at most its level at the start with everything given since, plus `δ`. -/
theorem transmitted_within_at {c : X} {δ : Nat} {S n : Nat} {x g : X}
    (balances : ∀ s, S ≤ s → s < S + n →
      W.level (s + 1) c + L.taken s c = W.level s c + L.given s c)
    (transmits : W.requires (S + n + 1) x c →
      W.requires (S + n) g c ∧ W.need (S + n + 1) x c ≤ W.need (S + n) g c + δ)
    (supported : W.Supported (S + n) g) (depends : W.requires (S + n + 1) x c) :
    W.need (S + n + 1) x c + total (steps S n) (fun s => L.taken s c) ≤
      W.level S c + total (steps S n) (fun s => L.given s c) + δ :=
  Nat.le_trans
    (Nat.add_le_add_right (transmitted_supported_at transmits supported depends) _)
    (Nat.le_of_eq ((Nat.add_right_comm _ δ _).trans
      (congrArg (· + δ) (balance_over_stretch_on (q := fun s => W.level s c)
        (x := fun s => L.taken s c) (y := fun s => L.given s c) S n balances))))

/-- What is transmitted was selected: a descendant's need is at most the condition's level
at the step it was given, plus what transmission allows. -/
theorem transmitted_supported (acting : L.Acting W) (dependent : W.Dependent) {c : X}
    {δ : Nat} (transmits : L.TransmitsWithin W c δ) {t : Nat} {x g : X}
    (descends : L.DescendsAt W t x g) (depends : W.requires (t + 1) x c) :
    W.need (t + 1) x c ≤ W.level t c + δ :=
  transmitted_supported_at (transmits t x g descends) (descends.supported acting dependent)
    depends

/-- Activity sets later selection: in a balanced flow, a descendant's need with everything
taken from its condition since an earlier step is at most the condition's level then, with
everything given to it since, plus what transmission allows. -/
theorem transmitted_within (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : X} {δ : Nat} (transmits : L.TransmitsWithin W c δ)
    {S n : Nat} {x g : X} (descends : L.DescendsAt W (S + n) x g)
    (depends : W.requires (S + n + 1) x c) :
    W.need (S + n + 1) x c + total (steps S n) (L.uptake [c]) ≤
      W.level S c + total (steps S n) (L.replenishment [c]) + δ :=
  transmitted_within_at (fun s _ _ => balances s c) (transmits (S + n) x g descends)
    (descends.supported acting dependent) depends

/-- **Along a lineage, need drifts at most `δ` a generation.** Let `xs 0, xs 1, …` be a lineage,
`xs (i + 1)` descending from `xs i` across step `ts i`, each member depending on `c` from its first
standing step with its need not rising until it gives in turn. With the dependence transmitted
within `δ`, the need of the member after `i + 1` descents is at most the founder's need plus
`(i + 1) * δ`. -/
theorem transmitted_along {c : X} {δ : Nat} (transmits : L.TransmitsWithin W c δ)
    {xs : Nat → X} {ts : Nat → Nat} {n : Nat}
    (descends : ∀ i, i < n → L.DescendsAt W (ts i) (xs (i + 1)) (xs i))
    (depends : ∀ i, i < n → W.requires (ts i + 1) (xs (i + 1)) c)
    (steady : ∀ i, i + 1 < n → W.need (ts (i + 1)) (xs (i + 1)) c ≤ W.need (ts i + 1) (xs (i + 1)) c) :
    ∀ i, i < n → W.need (ts i + 1) (xs (i + 1)) c ≤ W.need (ts 0) (xs 0) c + (i + 1) * δ
  | 0, lt => Nat.le_trans (transmits (ts 0) (xs 1) (xs 0) (descends 0 lt) (depends 0 lt)).2
      (Nat.le_of_eq (congrArg (_ + ·) (Nat.one_mul δ).symm))
  | i + 1, lt =>
    have earlier := transmitted_along transmits descends depends steady i
      (Nat.lt_of_succ_lt lt)
    Nat.le_trans (transmits (ts (i + 1)) (xs (i + 2)) (xs (i + 1)) (descends (i + 1) lt)
        (depends (i + 1) lt)).2
      (Nat.le_trans (Nat.add_le_add_right (Nat.le_trans (steady i lt) earlier) δ)
        (Nat.le_of_eq ((Nat.add_assoc _ _ _).trans
          (congrArg (_ + ·) (Nat.succ_mul (i + 1) δ).symm))))

/-- With the founder supported where it gives, the need after `i + 1` descents is at most the
condition's level then, plus `(i + 1) * δ`: what each generation inherits was selected once, and
drifts by at most `δ` each time. -/
theorem transmitted_along_supported {c : X} {δ : Nat} (transmits : L.TransmitsWithin W c δ)
    {xs : Nat → X} {ts : Nat → Nat} {n : Nat}
    (descends : ∀ i, i < n → L.DescendsAt W (ts i) (xs (i + 1)) (xs i))
    (depends : ∀ i, i < n → W.requires (ts i + 1) (xs (i + 1)) c)
    (steady : ∀ i, i + 1 < n → W.need (ts (i + 1)) (xs (i + 1)) c ≤ W.need (ts i + 1) (xs (i + 1)) c)
    (founder : W.Supported (ts 0) (xs 0)) (pos : 0 < n) :
    ∀ i, i < n → W.need (ts i + 1) (xs (i + 1)) c ≤ W.level (ts 0) c + (i + 1) * δ :=
  fun i lt => Nat.le_trans (transmitted_along transmits descends depends steady i lt)
    (Nat.add_le_add_right (founder c (transmits (ts 0) (xs 1) (xs 0) (descends 0 pos)
      (depends 0 pos)).1) _)

end Flow

/-! ## Witnesses -/

namespace Drawdown

/-- A pool, a parent, a descendant with the parent's need, and a descendant needing less. -/
inductive Relatum
  | pool
  | parent
  | same
  | varied

/-- The pool stands at two, at one after the parent takes from it, and at nothing after
the varied descendant does. The parent stands throughout; the descendants come to stand
across the first step. -/
def level : Nat → Relatum → Nat
  | 0, .pool => 2
  | 1, .pool => 1
  | _ + 2, .pool => 0
  | _, .parent => 1
  | 0, .same => 0
  | _ + 1, .same => 1
  | 0, .varied => 0
  | _ + 1, .varied => 1

/-- One unit at the pool, nothing elsewhere. -/
def pooled : Relatum → Nat
  | .pool => 1
  | .parent => 0
  | .same => 0
  | .varied => 0

/-- One unit at each descendant, nothing elsewhere. -/
def descendant : Relatum → Nat
  | .pool => 0
  | .parent => 0
  | .same => 1
  | .varied => 1

/-- Every relatum but the pool depends on the pool, the varied descendant at need one and
the others at need two. The parent is active at the first step and the varied descendant
at the second, each drawing on the pool. -/
def web : Web Relatum Relatum where
  level := level
  active t x := match x with
    | .pool => False
    | .parent => t = 0
    | .same => False
    | .varied => t = 1
  requires _ x c := match x with
    | .pool => False
    | .parent => 0 < pooled c
    | .same => 0 < pooled c
    | .varied => 0 < pooled c
  need _ x _ := match x with
    | .pool => 2
    | .parent => 2
    | .same => 2
    | .varied => 1
  draws t x c := match x with
    | .pool => False
    | .parent => t = 0 ∧ 0 < pooled c
    | .same => False
    | .varied => t = 1 ∧ 0 < pooled c

/-- Across the first step the parent takes one unit of the pool and gives one to each
descendant; across the second the varied descendant takes one unit of the pool. -/
def flow : Flow Relatum Relatum where
  present t := match t with
    | 0 => [.parent]
    | 1 => [.varied]
    | _ + 2 => []
  take t f c := match t, f with
    | 0, .parent => pooled c
    | 1, .varied => pooled c
    | 0, .pool | 0, .same | 0, .varied => 0
    | 1, .pool | 1, .parent | 1, .same => 0
    | _ + 2, _ => 0
  give t f c := match t, f with
    | 0, .parent => descendant c
    | 0, .pool | 0, .same | 0, .varied => 0
    | _ + 1, _ => 0

theorem balances : flow.Balances web
  | 0, .pool => rfl
  | 0, .parent => rfl
  | 0, .same => rfl
  | 0, .varied => rfl
  | 1, .pool => rfl
  | 1, .parent => rfl
  | 1, .same => rfl
  | 1, .varied => rfl
  | _ + 2, .pool => rfl
  | _ + 2, .parent => rfl
  | _ + 2, .same => rfl
  | _ + 2, .varied => rfl

theorem acting : flow.Acting web
  | 0, _, _, .head _, _ => rfl
  | 0, _, _, .tail _ rest, _ => nomatch rest
  | 1, _, _, .head _, gives => absurd gives (Nat.lt_irrefl 0)
  | 1, _, _, .tail _ rest, _ => nomatch rest
  | _ + 2, _, _, present, _ => nomatch present

theorem taking : flow.Taking web
  | 0, _, c, .head _, takes => match c with
    | .pool => ⟨rfl, rfl, Nat.zero_lt_one⟩
    | .parent => absurd takes (Nat.lt_irrefl 0)
    | .same => absurd takes (Nat.lt_irrefl 0)
    | .varied => absurd takes (Nat.lt_irrefl 0)
  | 0, _, _, .tail _ rest, _ => nomatch rest
  | 1, _, c, .head _, takes => match c with
    | .pool => ⟨rfl, rfl, Nat.zero_lt_one⟩
    | .parent => absurd takes (Nat.lt_irrefl 0)
    | .same => absurd takes (Nat.lt_irrefl 0)
    | .varied => absurd takes (Nat.lt_irrefl 0)
  | 1, _, _, .tail _ rest, _ => nomatch rest
  | _ + 2, _, _, present, _ => nomatch present

theorem dependent : web.Dependent
  | _, .pool, active => False.elim active
  | _, .same, active => False.elim active
  | _, .parent, rfl => fun c depends => match c with
    | .pool => Nat.le_refl 2
    | .parent => absurd depends (Nat.lt_irrefl 0)
    | .same => absurd depends (Nat.lt_irrefl 0)
    | .varied => absurd depends (Nat.lt_irrefl 0)
  | _, .varied, rfl => fun c depends => match c with
    | .pool => Nat.le_refl 1
    | .parent => absurd depends (Nat.lt_irrefl 0)
    | .same => absurd depends (Nat.lt_irrefl 0)
    | .varied => absurd depends (Nat.lt_irrefl 0)

/-- The descendants inherit the dependence on the pool; the one needing the same needs no
more than the parent, and the varied one needs less. -/
theorem transmits : flow.TransmitsWithin web .pool 0
  | 0, .same, _, ⟨.head _, _, _⟩, _ => ⟨Nat.zero_lt_one, Nat.le_refl 2⟩
  | 0, .varied, _, ⟨.head _, _, _⟩, _ => ⟨Nat.zero_lt_one, Nat.le_succ 1⟩
  | 0, .pool, _, ⟨.head _, gives, _⟩, _ => absurd gives (Nat.lt_irrefl 0)
  | 0, .parent, _, ⟨.head _, gives, _⟩, _ => absurd gives (Nat.lt_irrefl 0)
  | 0, _, _, ⟨.tail _ rest, _, _⟩, _ => nomatch rest
  | 1, _, _, ⟨.head _, gives, _⟩, _ => absurd gives (Nat.lt_irrefl 0)
  | 1, _, _, ⟨.tail _ rest, _, _⟩, _ => nomatch rest
  | _ + 2, _, _, ⟨present, _, _⟩, _ => nomatch present

theorem descends_same : flow.DescendsAt web 0 .same .parent :=
  ⟨.head [], Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩

theorem descends_varied : flow.DescendsAt web 0 .varied .parent :=
  ⟨.head [], Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩

/-- The descendant with the parent's need is unsupported from its first standing step on:
the parent's taking lowered the pool below it. -/
theorem same_unsupported : ∀ t, 1 ≤ t → ¬ web.Supported t .same
  | 1, _, supported => Nat.not_succ_le_self 1 (supported .pool Nat.zero_lt_one)
  | _ + 2, _, supported => Nat.not_succ_le_zero 1 (supported .pool Nat.zero_lt_one)

/-- Transmission, variation, selection and the feedback of activity on selection in one
unfolding: the flow balances, only active formations give and take, activity needs
support, and the dependence on the pool is transmitted without rising. Both descendants
descend from the parent across the first step, one with the parent's need and one needing
less. The parent's taking lowers the pool, so the first is unsupported from its first
standing step on, while the second is supported and active, and takes in turn. -/
theorem drawdown :
    flow.Balances web ∧ flow.Acting web ∧ flow.Taking web ∧ web.Dependent ∧
    flow.TransmitsWithin web .pool 0 ∧
    flow.DescendsAt web 0 .same .parent ∧ web.need 1 .same .pool = web.need 0 .parent .pool ∧
    flow.DescendsAt web 0 .varied .parent ∧ web.need 1 .varied .pool < web.need 0 .parent .pool ∧
    web.level 1 .pool < web.level 0 .pool ∧ (∀ t, 1 ≤ t → ¬ web.Supported t .same) ∧
    web.Supported 1 .varied ∧ web.active 1 .varied ∧ 0 < flow.take 1 .varied .pool :=
  ⟨balances, acting, taking, dependent, transmits, descends_same, rfl, descends_varied,
   Nat.lt_succ_self 1, Nat.lt_succ_self 1, same_unsupported, dependent 1 .varied rfl, rfl,
   Nat.zero_lt_one⟩

end Drawdown

namespace Slack

/-- A pool, a parent and a child. -/
inductive Relatum where
  | pool
  | parent
  | child

/-- The pool and the parent stand at one throughout; the child comes to stand at one. -/
def web : Web Relatum Relatum where
  level t x := match x, t with
    | .pool, _ => 1
    | .parent, _ => 1
    | .child, 0 => 0
    | .child, _ + 1 => 1
  active t x := match x with
    | .pool => False
    | .parent => t = 0
    | .child => False
  requires _ x c := match x, c with
    | .pool, _ => False
    | .parent, .pool | .child, .pool => True
    | .parent, .parent | .parent, .child | .child, .parent | .child, .child => False
  need _ x _ := match x with
    | .pool => 0
    | .parent => 1
    | .child => 2
  draws _ _ _ := False

/-- Across the first step the parent gives the child a unit. -/
def flow : Flow Relatum Relatum where
  present t := match t with
    | 0 => [.parent]
    | _ + 1 => []
  take _ _ _ := 0
  give t f c := match t, f, c with
    | 0, .parent, .child => 1
    | 0, .parent, .pool | 0, .parent, .parent => 0
    | 0, .pool, _ | 0, .child, _ => 0
    | _ + 1, _, _ => 0

theorem dependent : web.Dependent
  | _, .pool, active => False.elim active
  | _, .child, active => False.elim active
  | _, .parent, rfl => fun c depends => match c with
    | .pool => Nat.le_refl 1
    | .parent => False.elim depends
    | .child => False.elim depends

/-- The flow balances, only active formations give, activity needs support, the dependence
on the pool is transmitted within one, the child descends from the parent, and the
child's need exceeds the pool's level at the giving step and at every step: a transmitted
need need not have been met (the ninth review's probe). -/
theorem slack :
    flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧ flow.TransmitsWithin web .pool 1 ∧
    flow.DescendsAt web 0 .child .parent ∧ web.level 0 .pool < web.need 1 .child .pool ∧
    ∀ t, ¬ web.need t .child .pool ≤ web.level t .pool :=
  ⟨fun
    | 0, .pool => rfl
    | 0, .parent => rfl
    | 0, .child => rfl
    | _ + 1, .pool => rfl
    | _ + 1, .parent => rfl
    | _ + 1, .child => rfl,
   fun
    | 0, _, _, .head _, _ => rfl
    | 0, _, _, .tail _ rest, _ => nomatch rest
    | _ + 1, _, _, present, _ => (nomatch present),
   dependent,
   fun
    | 0, .child, _, ⟨.head _, _, _⟩, _ => ⟨trivial, Nat.le_refl 2⟩
    | 0, .pool, _, ⟨.head _, gives, _⟩, _ => absurd gives (Nat.lt_irrefl 0)
    | 0, .parent, _, ⟨.head _, gives, _⟩, _ => absurd gives (Nat.lt_irrefl 0)
    | 0, _, _, ⟨.tail _ rest, _, _⟩, _ => nomatch rest
    | _ + 1, _, _, ⟨present, _, _⟩, _ => (nomatch present),
   ⟨.head [], Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩,
   Nat.lt_succ_self 1,
   fun _ le => Nat.not_succ_le_self 1 le⟩

end Slack

namespace Unchecked

/-- A pool, a parent and a child. -/
inductive Relatum
  | pool
  | parent
  | child

/-- The pool and the parent stand at one throughout; the child comes to stand across the
first step. Every relatum but the pool depends on the pool at need two; the parent is
active at the first step, beyond its support. -/
def web : Web Relatum Relatum where
  level t x := match x, t with
    | .pool, _ => 1
    | .parent, _ => 1
    | .child, 0 => 0
    | .child, _ + 1 => 1
  active t x := match x with
    | .pool => False
    | .parent => t = 0
    | .child => False
  requires _ x c := match x, c with
    | .pool, _ => False
    | .parent, .pool | .child, .pool => True
    | .parent, .parent | .parent, .child | .child, .parent | .child, .child => False
  need _ _ _ := 2
  draws _ _ _ := False

/-- Across the first step the parent gives the child one unit. -/
def flow : Flow Relatum Relatum where
  present t := match t with
    | 0 => [.parent]
    | _ + 1 => []
  take _ _ _ := 0
  give t f c := match t, f, c with
    | 0, .parent, .child => 1
    | 0, .parent, .pool | 0, .parent, .parent => 0
    | 0, .pool, _ | 0, .child, _ => 0
    | _ + 1, _, _ => 0

/-- Without `Dependent` what is transmitted need not have been selected: the flow balances,
only active formations give, the child descends from the parent and inherits its
dependence and need, and the need exceeds the pool's level at the step it was given. -/
theorem unchecked :
    flow.Balances web ∧ flow.Acting web ∧ flow.TransmitsWithin web .pool 0 ∧
    flow.DescendsAt web 0 .child .parent ∧ ¬ web.Dependent ∧
    web.level 0 .pool + 0 < web.need 1 .child .pool :=
  ⟨fun
    | 0, .pool => rfl
    | 0, .parent => rfl
    | 0, .child => rfl
    | _ + 1, .pool => rfl
    | _ + 1, .parent => rfl
    | _ + 1, .child => rfl,
   fun
    | 0, _, _, .head _, _ => rfl
    | 0, _, _, .tail _ rest, _ => nomatch rest
    | _ + 1, _, _, present, _ => (nomatch present),
   fun
    | 0, .child, _, ⟨.head _, _, _⟩, _ => ⟨trivial, Nat.le_refl 2⟩
    | 0, .pool, _, ⟨.head _, gives, _⟩, _ => absurd gives (Nat.lt_irrefl 0)
    | 0, .parent, _, ⟨.head _, gives, _⟩, _ => absurd gives (Nat.lt_irrefl 0)
    | 0, _, _, ⟨.tail _ rest, _, _⟩, _ => nomatch rest
    | _ + 1, _, _, ⟨present, _, _⟩, _ => (nomatch present),
   ⟨.head [], Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩,
   fun dependent => Nat.not_succ_le_self 1 (dependent 0 .parent rfl .pool trivial),
   Nat.lt_succ_self 1⟩

end Unchecked

end Becoming
