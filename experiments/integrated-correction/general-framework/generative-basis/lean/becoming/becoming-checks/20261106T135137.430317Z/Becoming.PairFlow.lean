import Becoming.PairSelection

/-!
# The pair's run as a flow: the factors derived, and where giving can bring more than keeping

`PairSelection` reads a pair's offspring as `a + β · received + γ · withheld`, the factors supplied.
This module reads a pair's run as balanced flows on a web, derives each formation's offspring from
the flow, and asks when `β` and `γ` differ and what a gift can bring beyond what it draws. Once the
parts are fixed the derivation is close to definitional.

* **What passes through changes no level** (`levels_agree_until`, `levels_agree`). Two balanced flows
  from the same levels whose takes and gives on each condition, at each step at which the levels
  agree, differ only by amounts that cancel keep the same levels. So any difference of levels between
  two runs is a difference of what is taken from or given to some condition at a step at which they
  still agreed. A reading of offspring through the levels then gives both runs the same, and where it
  reads `a + β n` on one and `a + γ n` on the other, `β = γ` (`factors_equal`).
* **The needs met are within the stock** (`metNeed`, `metNeed_le`, `met_needs_le_stock`,
  `met_needs_within_start`, near-definitional). Where each formation of a list depends on its own
  condition, the needs met at a step total at most the stock of those conditions; over a stretch at
  every step of which the family gains nothing, at most the family's stock at the stretch's start.
  The landed need-asymmetry witness meets the bound with equality (`NeedsAtCapacity.at_capacity`).
* **The run as a flow, with routes** (`Routes`). A renewer gives each formation's standing a constant
  amount and each formation passes what it holds on: its upkeep nowhere, its own part to its line, at
  each step its law gives a gift of which part reaches the partner's standing and part is lost, at each
  step it withholds the gift's amount of which part reaches its own line and part spoils, and what it
  received, with a matching the renewer may give at each step its partner gives, to its line. The
  parts are the same for both formations, so the routes do not represent renewal reaching one of them
  only, as in `PairSelection.Renewed`. The flow balances, only active formations give, activity needs
  support, and both formations are supported at every step, their standings held constant by
  construction (`Routes.balances`, `acting`, `dependent`, `supported`). Read as the level of its line,
  a place's offspring is `Place.offspring` for any laws and errors, `β` what of a gift reaches the
  receiver with the matching, `γ` what of a kept amount reaches the keeper's line
  (`Routes.line_offspring`). Where what is kept is the gift's amount, `β` with what giving loses is `γ`
  with what keeping spoils and the matching (`Routes.factor_gap`), so `γ < β` exactly where giving
  loses less than keeping spoils with the matching (`Routes.gap_iff`); with no loss and no matching
  `β = γ` (`Routes.plain`). Each sign is met (`Routes.signs`).
* **Renewal while standing** (`WhileStanding`). A renewer gives a standing only while its formation
  stands, that is, is active; a formation is active exactly where its standing meets its need, gives
  only while active and as it intends, and a taker beyond may draw on any standing. The renewer
  requires nothing, so this is not a gated renewal, in which every formation giving to a condition
  depends on it: the renewal reads the receiver's activity. The flow balances, only active formations
  give, activity needs support (`WhileStanding.balances`, `acting`, `dependent`). Mutual giving at
  every step leaves the levels as no giving does while both stand, whatever the renewal, the draws and
  the needs (`WhileStanding.runs_agree_until`), so no reading through the levels tells those two runs
  apart (`WhileStanding.factors_equal_while_supported`); one-sided giving is not covered, and changes
  the standings (`GiverAtNeed.standings_differ`). A formation that has fallen below its need, to which
  its partner gives nothing, never stands again (`WhileStanding.stays_fallen`, near-definitional: with
  no renewal while it is inactive and no gift, nothing flows in). Read by support, a formation active
  at every step of a run leaves `own · n` in it, by construction (`WhileStanding.lineAt_of_active`),
  and two runs in which it stands at the same steps leave it the same
  (`WhileStanding.lines_agree_while_active`).
* **A failed renewal** (`FailedRenewal`). One failed renewal takes the second formation below its
  need. Keeping, it never stands again; sharing, the first's two units of slack lift it, its renewal
  resumes, and the pair's lines over `m + 4` steps exceed the keeping pair's by `m`
  (`FailedRenewal.lines_gain`), the gain carried by the resumed renewal, an inflow from beyond the
  pair, while the first gave only two units more than it received (`FailedRenewal.gifts_sharing`); up
  to the shortfall the two runs keep the same levels (`FailedRenewal.agree_to_shortfall`).
* **A gift at the giver's need** (`GiverAtNeed`). From standings at their needs, a formation giving
  to one that never gives falls below its need and never stands again; over `m + 1` steps its line is
  `m` short of what keeping leaves it, from one gift of one unit (`GiverAtNeed.gift_lost`), while the
  receiver, which stands either way, leaves the same (`GiverAtNeed.withholder_same`).
* **A draw that ends the renewal** (`DrawnBelowNeed`). A taker beyond the pair draws two units from a
  standing at its need once; the renewal stops and the formation never stands again, although nothing
  is drawn after (`DrawnBelowNeed.drawn`, `DrawnBelowNeed.fallen`).

Modelling choices: discrete steps; natural-number amounts; decided Bools for giving; needs as
thresholds on a formation's own standing; offspring read as the level of a line, what a formation has
given its descendants; in `Routes` the standings constant and every part a constant amount per step,
the same for both formations; in `WhileStanding` the intended giving, the renewal offered and the
draws supplied as patterns, an active formation able to pay its upkeep, its line's part and a gift
from its standing (`WhileStanding.Parts.fits`), and a draw taken within what the standing holds. No
ethical predicate or ranking occurs. An empty axiom report says nothing of these.

Every declaration has an empty axiom report, except the generated `injEq` lemmas, which depend on
`propext`, as the checker's audit admits.
-/

namespace Becoming

open WindowedWaiting WindowedWaiting.Pair PairSelection

namespace PairFlow

section General

variable {F C : Type}

/-! ## What passes through changes no level -/

/-- **What passes through changes no level, up to a step.** Two balanced flows on two webs from the
same levels, whose takes and gives on each condition, at each step before `T` at which the levels
agree, differ only by amounts that cancel (what one takes beyond the other it is given beyond it),
keep the same levels at every step up to `T`. -/
theorem levels_agree_until {L₁ L₂ : Flow F C} {W₁ W₂ : Web F C}
    (b₁ : L₁.Balances W₁) (b₂ : L₂.Balances W₂) {T : Nat}
    (start : ∀ c, W₁.level 0 c = W₂.level 0 c)
    (net : ∀ t, t < T → (∀ c, W₁.level t c = W₂.level t c) →
      ∀ c, L₁.taken t c + L₂.given t c = L₂.taken t c + L₁.given t c) :
    ∀ t, t ≤ T → ∀ c, W₁.level t c = W₂.level t c
  | 0, _ => start
  | t + 1, le => fun c =>
    have lt : t < T := le
    have ih := levels_agree_until b₁ b₂ start net t (Nat.le_of_lt lt)
    add_right_cancel (L₂.taken t c + L₁.given t c) (calc
      W₁.level (t + 1) c + (L₂.taken t c + L₁.given t c)
          = W₁.level (t + 1) c + (L₁.taken t c + L₂.given t c) :=
            congrArg (W₁.level (t + 1) c + ·) (net t lt ih c).symm
      _ = W₁.level (t + 1) c + L₁.taken t c + L₂.given t c := (Nat.add_assoc _ _ _).symm
      _ = W₁.level t c + L₁.given t c + L₂.given t c := congrArg (· + L₂.given t c) (b₁ t c)
      _ = W₂.level t c + L₁.given t c + L₂.given t c :=
            congrArg (· + L₁.given t c + L₂.given t c) (ih c)
      _ = W₂.level t c + L₂.given t c + L₁.given t c := Nat.add_right_comm _ _ _
      _ = W₂.level (t + 1) c + L₂.taken t c + L₁.given t c :=
            congrArg (· + L₁.given t c) (b₂ t c).symm
      _ = W₂.level (t + 1) c + (L₂.taken t c + L₁.given t c) := Nat.add_assoc _ _ _)

/-- **What passes through changes no level.** Where, at every step at which the levels agree, two
balanced flows differ on each condition only by amounts that cancel, the levels agree at every
step. -/
theorem levels_agree {L₁ L₂ : Flow F C} {W₁ W₂ : Web F C}
    (b₁ : L₁.Balances W₁) (b₂ : L₂.Balances W₂)
    (start : ∀ c, W₁.level 0 c = W₂.level 0 c)
    (net : ∀ t, (∀ c, W₁.level t c = W₂.level t c) →
      ∀ c, L₁.taken t c + L₂.given t c = L₂.taken t c + L₁.given t c) :
    ∀ t c, W₁.level t c = W₂.level t c := fun t =>
  levels_agree_until (T := t) b₁ b₂ start (fun s _ => net s) t (Nat.le_refl t)

/-- **A reading through the levels forces the factors equal.** Where two courses keep the same levels
up to step `n`, a reading of offspring from the levels up to `n` gives both the same; so where it is
`a + β n` on one and `a + γ n` on the other, with `n` positive, `β = γ`. -/
theorem factors_equal {W₁ W₂ : Web F C} {n : Nat}
    (same : ∀ t, t ≤ n → ∀ c, W₁.level t c = W₂.level t c)
    (read : (Nat → C → Nat) → Nat)
    (respects : ∀ l l' : Nat → C → Nat, (∀ t, t ≤ n → ∀ c, l t c = l' t c) → read l = read l')
    {a β γ : Nat} (npos : 0 < n)
    (giving : read W₁.level = a + β * n) (withholding : read W₂.level = a + γ * n) : β = γ :=
  Nat.eq_of_mul_eq_mul_right npos
    (Naturals.add_left_cancel (giving.symm.trans ((respects _ _ same).trans withholding)))

/-! ## The needs met are within the stock -/

/-- The need a formation has of its own condition where the condition meets it at a step, and nothing
where it does not. -/
def metNeed (W : Web F C) (own : F → C) (t : Nat) (f : F) : Nat :=
  cond (Nat.ble (W.need t f (own f)) (W.level t (own f))) (W.need t f (own f)) 0

theorem metNeed_le (W : Web F C) (own : F → C) (t : Nat) (f : F) :
    metNeed W own t f ≤ W.level t (own f) := by
  unfold metNeed
  cases h : Nat.ble (W.need t f (own f)) (W.level t (own f)) with
  | false => exact Nat.zero_le _
  | true => exact Nat.le_of_ble_eq_true h

/-- A supported formation depending on its own condition has its need there met in full. -/
theorem metNeed_of_supported {W : Web F C} {own : F → C} {t : Nat} {f : F}
    (req : W.requires t f (own f)) (sup : W.Supported t f) :
    metNeed W own t f = W.need t f (own f) :=
  congrArg (fun b => cond b (W.need t f (own f)) 0) (Nat.ble_eq_true_of_le (sup (own f) req))

/-- **The needs met at a step total at most the stock.** For any list of formations, each read on
its own condition, the needs those conditions meet at a step, summed, are at most the stock of the
conditions so listed. -/
theorem met_needs_le_stock (W : Web F C) (own : F → C) (t : Nat) (fs : List F) :
    total fs (metNeed W own t) ≤ W.stock (fs.map own) t :=
  Nat.le_trans (total_le fs fun f _ => metNeed_le W own t f)
    (Nat.le_of_eq (total_map own (W.level t) fs).symm)

/-- **Closed, the needs met stay within the starting stock.** In a balanced flow, over a stretch at
every step of which the family of the formations' own conditions gains nothing, the needs met at its
end total at most the family's stock at its start: no gift, exchange or timing within the family
supports together formations whose needs exceed what it held. -/
theorem met_needs_within_start {L : Flow F C} {W : Web F C} (balances : L.Balances W)
    (own : F → C) (fs : List F) {S : Nat} (N : Nat)
    (gainless : ∀ t, S ≤ t → t < S + N → L.GainlessOn (fs.map own) t) :
    total fs (metNeed W own (S + N)) ≤ W.stock (fs.map own) S :=
  Nat.le_trans (met_needs_le_stock W own (S + N) fs) (balances.stock_not_rises_over N gainless)

end General

/-! ## The relata of a pair's run read as a flow -/

/-- A renewer beyond the pair, a taker beyond it, each formation of the pair (as a condition, its
standing), and each formation's line: what it has given its descendants. -/
inductive Member where
  | renewer
  | drawer
  | member (p : Pair)
  | line (p : Pair)

open Member

/-- The renewer, the taker beyond and the pair's formations take part at every step. -/
def present : List Member := [renewer, drawer, member first, member second]

/-- Each formation of the pair depends on its own standing; nothing else depends on anything. -/
def ownStanding : Member → Member → Prop
  | member p, c => c = member p
  | renewer, _ => False
  | drawer, _ => False
  | line _, _ => False

/-- A need `n` of a formation's standing. -/
def needOf (n : Nat) : Member → Member → Nat
  | member _, member _ => n
  | member _, renewer => 0
  | member _, drawer => 0
  | member _, line _ => 0
  | renewer, _ => 0
  | drawer, _ => 0
  | line _, _ => 0

theorem mul_cond (x : Nat) : ∀ b : Bool, x * cond b 1 0 = cond b x 0
  | true => Nat.mul_one x
  | false => Nat.mul_zero x

theorem regroup (s x y z x' y' z' : Nat) :
    s + x + y + z + (x' + y' + z') = s + (x + x') + (y + y') + (z + z') := by
  rw [Nat.add_add_add_comm (s + x + y) z (x' + y') z', Nat.add_add_add_comm (s + x) y x' y',
    Nat.add_assoc s x x']

/-! ## The run as a flow, with routes -/

namespace Routes

/-- The parts of the flow, each a constant amount per step. -/
structure Parts where
  /-- Each formation's standing, kept at every step. -/
  stand : Nat
  /-- What each formation needs of its standing. -/
  need : Nat
  /-- What each formation takes from its standing at every step and gives nowhere. -/
  upkeep : Nat
  /-- What each formation gives its line at every step, whatever the run. -/
  own : Nat
  /-- Each line at the start. -/
  start : Nat
  /-- Of a gift, what reaches the partner's standing. -/
  reach : Nat
  /-- Of a gift, what is lost on the way. -/
  spill : Nat
  /-- Of what a withholding formation keeps (the gift's amount), what reaches its line. -/
  kept : Nat
  /-- Of what it keeps, what is lost. -/
  spoiled : Nat
  /-- What the renewer gives a formation's standing at each step at which its partner gives. -/
  matched : Nat

variable (P : Parts) (g : Pair → Nat → Bool)

/-- What the renewer gives formation `p`'s standing at step `t`, `g` the run's giving: its upkeep, its
own part and a gift's amount, with the matching where its partner gives. -/
def renewed (p : Pair) (t : Nat) : Nat :=
  P.upkeep + P.own + (P.reach + P.spill) + cond (g (partner p) t) P.matched 0

/-- What formation `p` takes from its standing at step `t`: its upkeep, its own part, a gift's amount
(given, or kept) and what it received with the matching. -/
def drawn (p : Pair) (t : Nat) : Nat :=
  P.upkeep + P.own + (P.reach + P.spill) + cond (g (partner p) t) (P.reach + P.matched) 0

/-- What formation `p` gives its line at step `t`: its own part, what it received with the matching,
and what of what it kept reaches its line. -/
def toLine (p : Pair) (t : Nat) : Nat :=
  P.own + cond (g (partner p) t) (P.reach + P.matched) 0 + cond (!g p t) P.kept 0

/-- Formation `p`'s line. -/
def lineAt (p : Pair) : Nat → Nat
  | 0 => P.start
  | t + 1 => lineAt p t + toLine P g p t

def take (t : Nat) : Member → Member → Nat
  | member first, member first => drawn P g first t
  | member first, member second => 0
  | member first, renewer => 0
  | member first, drawer => 0
  | member first, line _ => 0
  | member second, member second => drawn P g second t
  | member second, member first => 0
  | member second, renewer => 0
  | member second, drawer => 0
  | member second, line _ => 0
  | renewer, _ => 0
  | drawer, _ => 0
  | line _, _ => 0

def give (t : Nat) : Member → Member → Nat
  | renewer, member p => renewed P g p t
  | renewer, renewer => 0
  | renewer, drawer => 0
  | renewer, line _ => 0
  | drawer, _ => 0
  | member first, member second => cond (g first t) P.reach 0
  | member first, member first => 0
  | member first, line first => toLine P g first t
  | member first, line second => 0
  | member first, renewer => 0
  | member first, drawer => 0
  | member second, member first => cond (g second t) P.reach 0
  | member second, member second => 0
  | member second, line second => toLine P g second t
  | member second, line first => 0
  | member second, renewer => 0
  | member second, drawer => 0
  | line _, _ => 0

def level (t : Nat) : Member → Nat
  | renewer => 0
  | drawer => 0
  | member _ => P.stand
  | line p => lineAt P g p t

/-- The renewer, the taker beyond and the formations are active; the lines are not. -/
def active : Member → Prop
  | renewer => True
  | drawer => True
  | member _ => True
  | line _ => False

def web : Web Member Member :=
  ⟨level P g, fun _ => active, fun _ => ownStanding, fun _ => needOf P.need, fun _ => ownStanding⟩

def flow : Flow Member Member := ⟨fun _ => present, take P g, give P g⟩

theorem taken_member (t : Nat) : ∀ p, (flow P g).taken t (member p) = drawn P g p t
  | first => (Nat.zero_add _).trans (Nat.zero_add _)
  | second => (Nat.zero_add _).trans ((Nat.zero_add _).trans (Nat.zero_add _))

theorem given_member (t : Nat) : ∀ p, (flow P g).given t (member p) =
    renewed P g p t + cond (g (partner p) t) P.reach 0
  | first => congrArg (renewed P g first t + ·) ((Nat.zero_add _).trans (Nat.zero_add _))
  | second => congrArg (renewed P g second t + ·) (Nat.zero_add _)

theorem given_line (t : Nat) : ∀ p, (flow P g).given t (line p) = toLine P g p t
  | first => (Nat.zero_add _).trans (Nat.zero_add _)
  | second => (Nat.zero_add _).trans ((Nat.zero_add _).trans (Nat.zero_add _))

theorem drawn_eq (p : Pair) (t : Nat) :
    drawn P g p t = renewed P g p t + cond (g (partner p) t) P.reach 0 := by
  unfold drawn renewed
  cases g (partner p) t with
  | true =>
    exact (congrArg (P.upkeep + P.own + (P.reach + P.spill) + ·)
      (Nat.add_comm P.reach P.matched)).trans (Nat.add_assoc _ _ _).symm
  | false => rfl

/-- **The flow balances.** -/
theorem balances : (flow P g).Balances (web P g)
  | _, renewer => rfl
  | _, drawer => rfl
  | t, member p => congrArg (P.stand + ·)
      ((taken_member P g t p).trans ((drawn_eq P g p t).trans (given_member P g t p).symm))
  | t, line p => congrArg (lineAt P g p t + ·) (given_line P g t p).symm

/-- **Only active formations give**: the renewer and the formations, never a line. -/
theorem acting : (flow P g).Acting (web P g)
  | _, renewer, _, _, _ => trivial
  | _, drawer, _, _, _ => trivial
  | _, member _, _, _, _ => trivial
  | _, line _, _, _, pos => absurd pos (Nat.lt_irrefl 0)

/-- **Activity needs support**, where each formation's need is within its standing. -/
theorem dependent (within : P.need ≤ P.stand) : (web P g).Dependent
  | _, renewer, _ => fun _ req => False.elim req
  | _, drawer, _ => fun _ req => False.elim req
  | _, member p, _ => fun c req => match c, (req : c = member p) with | _, rfl => within
  | _, line _, act => False.elim act

/-- **Both formations are supported at every step.** -/
theorem supported (within : P.need ≤ P.stand) (t : Nat) (p : Pair) :
    (web P g).Supported t (member p) :=
  dependent P g within t (member p) trivial

/-- Formation `p`'s line, in closed form. -/
theorem lineAt_eq (p : Pair) : ∀ n, lineAt P g p n = P.start + P.own * n +
    (P.reach + P.matched) * tally (g (partner p)) n + P.kept * tally (fun t => !g p t) n
  | 0 => rfl
  | n + 1 => by
    show lineAt P g p n + toLine P g p n = P.start + (P.own * n + P.own) +
      (P.reach + P.matched) * (tally (g (partner p)) n + cond (g (partner p) n) 1 0) +
      P.kept * (tally (fun t => !g p t) n + cond (!g p n) 1 0)
    rw [lineAt_eq p n, Nat.left_distrib, Nat.left_distrib, mul_cond, mul_cond]
    exact regroup P.start (P.own * n) ((P.reach + P.matched) * tally (g (partner p)) n)
      (P.kept * tally (fun t => !g p t) n) P.own (cond (g (partner p) n) (P.reach + P.matched) 0)
      (cond (!g p n) P.kept 0)

/-- The run's giving at a place: whether formation `p` gives at step `t` under the place's laws and
errors. -/
def gaveIn (s : Place) (p : Pair) (t : Nat) : Bool := gives (s.law first) (s.law second) s.errs p t

/-- **The offspring follow from the flow.** Read as the level of its line, a place's offspring over
`n` steps are `Place.offspring` with `a` the line's start and `n` own parts, `β` what of a gift
reaches the receiver with the matching, and `γ` what of a kept amount reaches the keeper's line, for
any laws and any errors. -/
theorem line_offspring (s : Place) (n : Nat) :
    (web P (gaveIn s)).level n (line s.side) =
      s.offspring (P.start + P.own * n) (P.reach + P.matched) P.kept n :=
  lineAt_eq P (gaveIn s) s.side n

/-- **What decides `β` against `γ`.** Where what a withholding formation keeps is the gift's amount,
`β` with what giving loses is `γ` with what keeping spoils and what the matching brings. -/
theorem factor_gap (routes : P.kept + P.spoiled = P.reach + P.spill) :
    (P.reach + P.matched) + P.spill = P.kept + P.spoiled + P.matched :=
  (Nat.add_right_comm P.reach P.matched P.spill).trans (congrArg (· + P.matched) routes.symm)

/-- **`γ < β` exactly where giving loses less than keeping spoils with what the matching brings.** -/
theorem gap_iff (routes : P.kept + P.spoiled = P.reach + P.spill) :
    P.kept < P.reach + P.matched ↔ P.spill < P.spoiled + P.matched :=
  ⟨fun lt => Naturals.lt_of_add_lt_add_left (k := P.kept) (calc
      P.kept + P.spill = P.spill + P.kept := Nat.add_comm _ _
      _ < P.spill + (P.reach + P.matched) := Nat.add_lt_add_left lt _
      _ = P.reach + P.matched + P.spill := Nat.add_comm _ _
      _ = P.kept + P.spoiled + P.matched := factor_gap P routes
      _ = P.kept + (P.spoiled + P.matched) := Nat.add_assoc _ _ _),
   fun lt => Naturals.lt_of_add_lt_add_left (k := P.spill) (calc
      P.spill + P.kept = P.kept + P.spill := Nat.add_comm _ _
      _ < P.kept + (P.spoiled + P.matched) := Nat.add_lt_add_left lt _
      _ = P.kept + P.spoiled + P.matched := (Nat.add_assoc _ _ _).symm
      _ = P.reach + P.matched + P.spill := (factor_gap P routes).symm
      _ = P.spill + (P.reach + P.matched) := Nat.add_comm _ _)⟩

/-- **With no loss on either route and no matching the factors are equal**: what a gift brings the
receiver is what keeping it brings the keeper. -/
theorem plain (routes : P.kept + P.spoiled = P.reach + P.spill) (spill : P.spill = 0)
    (spoiled : P.spoiled = 0) (matched : P.matched = 0) (s : Place) (n : Nat) :
    (web P (gaveIn s)).level n (line s.side) =
      s.offspring (P.start + P.own * n) P.reach P.reach n :=
  have kept : P.kept = P.reach := (congrArg (P.kept + ·) spoiled.symm).trans
    (routes.trans (congrArg (P.reach + ·) spill))
  (line_offspring P s n).trans (by rw [kept, matched, Nat.add_zero])

/-- Kept food spoils: of a gift of one, all reaches the partner; what is kept is lost. -/
def perishing : Parts := ⟨2, 1, 0, 0, 0, 1, 0, 0, 1, 0⟩

/-- A gift costs its carriage: of two given, one reaches the partner; what is kept is kept whole. -/
def carried : Parts := ⟨2, 1, 0, 0, 0, 1, 1, 2, 0, 0⟩

/-- A renewer matches each gift with one more to the receiver. -/
def matching : Parts := ⟨2, 1, 0, 0, 0, 1, 0, 1, 0, 1⟩

/-- **Each sign is met.** The routes identity holds and each formation's need is within its standing
in all three; `γ < β` where keeping spoils and where a renewer matches, `β < γ` where giving costs. -/
theorem signs :
    (perishing.kept + perishing.spoiled = perishing.reach + perishing.spill ∧
      perishing.need ≤ perishing.stand ∧ perishing.kept < perishing.reach + perishing.matched) ∧
    (carried.kept + carried.spoiled = carried.reach + carried.spill ∧
      carried.need ≤ carried.stand ∧ carried.reach + carried.matched < carried.kept) ∧
    (matching.kept + matching.spoiled = matching.reach + matching.spill ∧
      matching.need ≤ matching.stand ∧ matching.kept < matching.reach + matching.matched) := by
  decide

end Routes

/-! ## Renewal while standing -/

namespace WhileStanding

/-- The parts of a run, constant over the run. -/
structure Parts where
  /-- What each formation needs of its standing. -/
  need : Pair → Nat
  /-- What an active formation takes from its standing at every step and gives nowhere. -/
  upkeep : Nat
  /-- What an active formation gives its line at every step. -/
  own : Nat
  /-- What a formation that gives gives its partner's standing. -/
  gift : Nat
  /-- An active formation can pay its upkeep, its line's part and a gift from its standing. -/
  fits : ∀ p, upkeep + own + gift ≤ need p

/-- What is supplied to a run: the giving each formation intends at each step, what the
renewer offers each standing (given only while its formation is active), what a taker beyond the pair
would draw from each standing, and the starting levels. -/
structure Setting where
  intends : Pair → Nat → Bool
  renew : Pair → Nat → Nat
  draw : Pair → Nat → Nat
  start : Nat × Nat

variable (G : Parts) (S : Setting)

/-- A formation's standing in a pair of levels. -/
def standing (x : Nat × Nat) : Pair → Nat
  | first => x.1
  | second => x.2

/-- Whether a formation is active: its standing meets its need. -/
def isActive (x : Nat × Nat) (p : Pair) : Bool := Nat.ble (G.need p) (standing x p)

/-- Whether a formation gives at step `t`: it intends to and is active. -/
def sends (t : Nat) (x : Nat × Nat) (p : Pair) : Bool := S.intends p t && isActive G x p

/-- What an active formation takes from its own standing: its upkeep, its line's part, and a gift
where it gives. -/
def ownTake (t : Nat) (x : Nat × Nat) (p : Pair) : Nat :=
  cond (isActive G x p) (G.upkeep + G.own + cond (sends G S t x p) G.gift 0) 0

/-- What the renewer gives a standing: what it offers, where the formation is active. -/
def renewal (t : Nat) (x : Nat × Nat) (p : Pair) : Nat := cond (isActive G x p) (S.renew p t) 0

/-- What the partner's gift brings a standing. -/
def gets (t : Nat) (x : Nat × Nat) (p : Pair) : Nat := cond (sends G S t x (partner p)) G.gift 0

/-- What a standing holds within the step, before the taker beyond draws. -/
def avail (t : Nat) (x : Nat × Nat) (p : Pair) : Nat :=
  standing x p - ownTake G S t x p + (renewal G S t x p + gets G S t x p)

/-- What is wanted, within what there is. -/
def capped (want there : Nat) : Nat := cond (Nat.ble want there) want there

theorem capped_le (want there : Nat) : capped want there ≤ there := by
  unfold capped
  cases h : Nat.ble want there with
  | true => exact Nat.le_of_ble_eq_true h
  | false => exact Nat.le_refl there

/-- What the taker beyond draws: what it would draw, within what the standing holds. -/
def drawTaken (t : Nat) (x : Nat × Nat) (p : Pair) : Nat := capped (S.draw p t) (avail G S t x p)

/-- A standing after the step. -/
def next (t : Nat) (x : Nat × Nat) (p : Pair) : Nat := avail G S t x p - drawTaken G S t x p

/-- The step of the two standings. -/
def advance (t : Nat) (x : Nat × Nat) : Nat × Nat := (next G S t x first, next G S t x second)

/-- The standings along the run. -/
def levels : Nat → Nat × Nat
  | 0 => S.start
  | t + 1 => advance G S t (levels t)

/-- Formation `p`'s line: its line's part at every step at which it is active. -/
def lineAt (p : Pair) : Nat → Nat
  | 0 => 0
  | t + 1 => lineAt p t + cond (isActive G (levels G S t) p) G.own 0

def level (t : Nat) : Member → Nat
  | renewer => 0
  | drawer => 0
  | member p => standing (levels G S t) p
  | line p => lineAt G S p t

/-- A formation is active exactly where its standing meets its need; the renewer and the taker beyond
are active; the lines are not. -/
def active (t : Nat) : Member → Prop
  | renewer => True
  | drawer => True
  | member p => isActive G (levels G S t) p = true
  | line _ => False

def needs : Member → Member → Nat
  | member p, member _ => G.need p
  | member _, renewer => 0
  | member _, drawer => 0
  | member _, line _ => 0
  | renewer, _ => 0
  | drawer, _ => 0
  | line _, _ => 0

def take (t : Nat) : Member → Member → Nat
  | member first, member first => ownTake G S t (levels G S t) first
  | member first, member second => 0
  | member first, renewer => 0
  | member first, drawer => 0
  | member first, line _ => 0
  | member second, member second => ownTake G S t (levels G S t) second
  | member second, member first => 0
  | member second, renewer => 0
  | member second, drawer => 0
  | member second, line _ => 0
  | drawer, member p => drawTaken G S t (levels G S t) p
  | drawer, renewer => 0
  | drawer, drawer => 0
  | drawer, line _ => 0
  | renewer, _ => 0
  | line _, _ => 0

def give (t : Nat) : Member → Member → Nat
  | renewer, member p => renewal G S t (levels G S t) p
  | renewer, renewer => 0
  | renewer, drawer => 0
  | renewer, line _ => 0
  | drawer, _ => 0
  | member first, member second => cond (sends G S t (levels G S t) first) G.gift 0
  | member first, member first => 0
  | member first, line first => cond (isActive G (levels G S t) first) G.own 0
  | member first, line second => 0
  | member first, renewer => 0
  | member first, drawer => 0
  | member second, member first => cond (sends G S t (levels G S t) second) G.gift 0
  | member second, member second => 0
  | member second, line second => cond (isActive G (levels G S t) second) G.own 0
  | member second, line first => 0
  | member second, renewer => 0
  | member second, drawer => 0
  | line _, _ => 0

def web : Web Member Member :=
  ⟨level G S, active G S, fun _ => ownStanding, fun _ => needs G, fun _ => ownStanding⟩

def flow : Flow Member Member := ⟨fun _ => present, take G S, give G S⟩

theorem standing_advance (t : Nat) (x : Nat × Nat) :
    ∀ p, standing (advance G S t x) p = next G S t x p
  | first => rfl
  | second => rfl

theorem taken_member (t : Nat) : ∀ p, (flow G S).taken t (member p) =
    drawTaken G S t (levels G S t) p + ownTake G S t (levels G S t) p
  | first => Nat.zero_add _
  | second => (Nat.zero_add _).trans
      (congrArg (drawTaken G S t (levels G S t) second + ·) (Nat.zero_add _))

theorem given_member (t : Nat) : ∀ p, (flow G S).given t (member p) =
    renewal G S t (levels G S t) p + gets G S t (levels G S t) p
  | first => congrArg (renewal G S t (levels G S t) first + ·)
      ((Nat.zero_add _).trans (Nat.zero_add _))
  | second => congrArg (renewal G S t (levels G S t) second + ·) (Nat.zero_add _)

theorem given_line (t : Nat) : ∀ p, (flow G S).given t (line p) =
    cond (isActive G (levels G S t) p) G.own 0
  | first => (Nat.zero_add _).trans (Nat.zero_add _)
  | second => (Nat.zero_add _).trans ((Nat.zero_add _).trans (Nat.zero_add _))

theorem ownTake_le (t : Nat) (x : Nat × Nat) (p : Pair) : ownTake G S t x p ≤ standing x p := by
  unfold ownTake
  cases h : isActive G x p with
  | false => exact Nat.zero_le _
  | true =>
    exact Nat.le_trans (Nat.add_le_add_left (ListTests.bif_le G.gift _) _)
      (Nat.le_trans (G.fits p) (Nat.le_of_ble_eq_true h))

theorem settle {l o r d : Nat} (paid : o ≤ l) (within : d ≤ l - o + r) :
    l - o + r - d + (d + o) = l + r :=
  calc l - o + r - d + (d + o) = l - o + r - d + d + o := (Nat.add_assoc _ _ _).symm
    _ = l - o + r + o := congrArg (· + o) ((Nat.add_comm _ _).trans (add_sub_of_le within))
    _ = l - o + o + r := Nat.add_right_comm _ _ _
    _ = l + r := congrArg (· + r) ((Nat.add_comm _ _).trans (add_sub_of_le paid))

theorem member_balance (t : Nat) (p : Pair) :
    next G S t (levels G S t) p + (flow G S).taken t (member p) =
      standing (levels G S t) p + (flow G S).given t (member p) :=
  (congrArg (next G S t (levels G S t) p + ·) (taken_member G S t p)).trans
    ((settle (ownTake_le G S t (levels G S t) p) (capped_le _ _)).trans
      (congrArg (standing (levels G S t) p + ·) (given_member G S t p).symm))

/-- **The flow balances.** -/
theorem balances : (flow G S).Balances (web G S)
  | _, renewer => rfl
  | _, drawer => rfl
  | t, member first => member_balance G S t first
  | t, member second => member_balance G S t second
  | t, line p => congrArg (lineAt G S p t + ·) (given_line G S t p).symm

theorem active_of_give {t : Nat} {p : Pair} {c : Member} (pos : 0 < give G S t (member p) c) :
    isActive G (levels G S t) p = true := by
  cases p <;> cases c <;> (try cases ‹Pair›) <;>
    first
    | exact absurd pos (Nat.lt_irrefl 0)
    | exact ListTests.true_of_cond_pos pos
    | exact ListTests.and_right (ListTests.true_of_cond_pos pos)

/-- **Only active formations give.** -/
theorem acting : (flow G S).Acting (web G S)
  | _, renewer, _, _, _ => trivial
  | _, drawer, _, _, _ => trivial
  | _, member _, _, _, pos => active_of_give G S pos
  | _, line _, _, _, pos => absurd pos (Nat.lt_irrefl 0)

/-- **Activity needs support**: a formation is active exactly where its standing meets its need. -/
theorem dependent : (web G S).Dependent
  | _, renewer, _ => fun _ req => False.elim req
  | _, drawer, _ => fun _ req => False.elim req
  | _, member p, act => fun c req => match c, (req : c = member p) with
    | _, rfl => Nat.le_of_ble_eq_true act
  | _, line _, act => False.elim act

theorem pair_ext : ∀ {x y : Nat × Nat}, x.1 = y.1 → x.2 = y.2 → x = y
  | (_, _), (_, _), rfl, rfl => rfl

theorem avail_same {l U k r : Nat} (paid : U + k ≤ l) : l - (U + k) + (r + k) = l - U + r :=
  (congrArg (· + (r + k)) (Naturals.sub_sub l U k).symm).trans
    (Naturals.sub_add_add (Naturals.le_sub_of_add_le paid))

theorem swap_net (d u k r : Nat) : d + (u + k) + (r + 0) = d + u + (r + k) := by
  rw [Nat.add_zero, ← Nat.add_assoc d u k, Nat.add_assoc (d + u) k r, Nat.add_comm k r]

/-- While both formations are active, what a formation of a pair that both give takes and is given
differs from what it takes and is given where neither gives only by amounts that cancel. -/
theorem member_net {S₁ S₂ : Setting} (x : Nat × Nat) (t : Nat) (p : Pair)
    (act : ∀ q, isActive G x q = true)
    (giving : ∀ q t, S₁.intends q t = true) (withholding : ∀ q t, S₂.intends q t = false)
    (renew : S₁.renew p t = S₂.renew p t) (draw : S₁.draw p t = S₂.draw p t) :
    drawTaken G S₁ t x p + ownTake G S₁ t x p + (renewal G S₂ t x p + gets G S₂ t x p) =
      drawTaken G S₂ t x p + ownTake G S₂ t x p + (renewal G S₁ t x p + gets G S₁ t x p) :=
  have s₁ : ∀ q, sends G S₁ t x q = true := fun q =>
    (congrArg (· && isActive G x q) (giving q t)).trans (act q)
  have s₂ : ∀ q, sends G S₂ t x q = false := fun q =>
    congrArg (· && isActive G x q) (withholding q t)
  have o₁ : ownTake G S₁ t x p = G.upkeep + G.own + G.gift :=
    (congrArg (fun b => cond b (G.upkeep + G.own + cond (sends G S₁ t x p) G.gift 0) 0)
      (act p)).trans (congrArg (fun b => G.upkeep + G.own + cond b G.gift 0) (s₁ p))
  have o₂ : ownTake G S₂ t x p = G.upkeep + G.own :=
    (congrArg (fun b => cond b (G.upkeep + G.own + cond (sends G S₂ t x p) G.gift 0) 0)
      (act p)).trans (congrArg (fun b => G.upkeep + G.own + cond b G.gift 0) (s₂ p))
  have r₁ : renewal G S₁ t x p = S₁.renew p t := congrArg (fun b => cond b (S₁.renew p t) 0) (act p)
  have r₂ : renewal G S₂ t x p = S₁.renew p t :=
    (congrArg (fun b => cond b (S₂.renew p t) 0) (act p)).trans renew.symm
  have e₁ : gets G S₁ t x p = G.gift := congrArg (fun b => cond b G.gift 0) (s₁ (partner p))
  have e₂ : gets G S₂ t x p = 0 := congrArg (fun b => cond b G.gift 0) (s₂ (partner p))
  have a : avail G S₁ t x p = avail G S₂ t x p := by
    unfold avail
    rw [o₁, o₂, r₁, r₂, e₁, e₂]
    exact avail_same (Nat.le_trans (G.fits p) (Nat.le_of_ble_eq_true (act p)))
  have d : drawTaken G S₁ t x p = drawTaken G S₂ t x p := by
    unfold drawTaken
    rw [a, draw]
  by
    rw [d, o₁, o₂, r₁, r₂, e₁, e₂]
    exact swap_net _ _ _ _

/-- **While both formations stand, mutual giving leaves the levels as no giving does.** Two runs
from the same standings, with the same renewal offered and the same draws, one in which both
formations intend to give at every step and one in which neither does, keep the same levels up to
step `T` where both formations are active at every step before `T` of the first: whatever the needs,
the renewal and the draws, mutual giving passes through. One-sided giving is not covered. -/
theorem runs_agree_until {S₁ S₂ : Setting}
    (giving : ∀ p t, S₁.intends p t = true) (withholding : ∀ p t, S₂.intends p t = false)
    (renew : ∀ p t, S₁.renew p t = S₂.renew p t) (draw : ∀ p t, S₁.draw p t = S₂.draw p t)
    (start : S₁.start = S₂.start) {T : Nat}
    (active : ∀ t, t < T → ∀ p, isActive G (levels G S₁ t) p = true) :
    ∀ t, t ≤ T → ∀ c, (web G S₁).level t c = (web G S₂).level t c :=
  levels_agree_until (balances G S₁) (balances G S₂)
    (fun c => match c with
      | renewer => rfl
      | drawer => rfl
      | member p => congrArg (standing · p) start
      | line _ => rfl)
    (fun t lt same c =>
      have hx : levels G S₁ t = levels G S₂ t :=
        pair_ext (same (member first)) (same (member second))
      match c with
      | renewer => rfl
      | drawer => rfl
      | member p => by
        rw [taken_member, taken_member, given_member, given_member, hx]
        exact member_net G (levels G S₂ t) t p (fun q => hx ▸ active t lt q) giving withholding
          (renew p t) (draw p t)
      | line p => congrArg (0 + ·) (((given_line G S₂ t p).trans
          (congrArg (fun x => cond (isActive G x p) G.own 0) hx.symm)).trans
            (given_line G S₁ t p).symm))

/-- **While both stand, no reading through the levels tells mutual giving from no giving.** Under
the hypotheses of `runs_agree_until` up to step `n`, a reading of offspring from the levels up to `n`
that gives `a + β n` where both give at every step and `a + γ n` where neither does has `β = γ`. -/
theorem factors_equal_while_supported {S₁ S₂ : Setting}
    (giving : ∀ p t, S₁.intends p t = true) (withholding : ∀ p t, S₂.intends p t = false)
    (renew : ∀ p t, S₁.renew p t = S₂.renew p t) (draw : ∀ p t, S₁.draw p t = S₂.draw p t)
    (start : S₁.start = S₂.start) {n : Nat}
    (active : ∀ t, t < n → ∀ p, isActive G (levels G S₁ t) p = true)
    (read : (Nat → Member → Nat) → Nat)
    (respects : ∀ l l' : Nat → Member → Nat, (∀ t, t ≤ n → ∀ c, l t c = l' t c) →
      read l = read l')
    {a β γ : Nat} (npos : 0 < n)
    (h₁ : read (web G S₁).level = a + β * n) (h₂ : read (web G S₂).level = a + γ * n) : β = γ :=
  factors_equal (runs_agree_until G giving withholding renew draw start active) read respects npos
    h₁ h₂

theorem lt_of_ble_false {n m : Nat} (h : Nat.ble n m = false) : m < n :=
  match Nat.lt_or_ge m n with
  | .inl lt => lt
  | .inr le => absurd ((Nat.ble_eq_true_of_le le).symm.trans h) (fun e => Bool.noConfusion e)

/-- A formation not active, to which its partner gives nothing, does not rise across the step. -/
theorem next_le_of_idle {t : Nat} {x : Nat × Nat} {p : Pair} (idle : isActive G x p = false)
    (none : sends G S t x (partner p) = false) : next G S t x p ≤ standing x p :=
  have o : ownTake G S t x p = 0 :=
    congrArg (fun b => cond b (G.upkeep + G.own + cond (sends G S t x p) G.gift 0) 0) idle
  have r : renewal G S t x p = 0 := congrArg (fun b => cond b (S.renew p t) 0) idle
  have e : gets G S t x p = 0 := congrArg (fun b => cond b G.gift 0) none
  have v : avail G S t x p = standing x p :=
    ((congrArg (standing x p - · + (renewal G S t x p + gets G S t x p)) o).trans
      ((congrArg (fun y => standing x p - 0 + (y + gets G S t x p)) r).trans
        (congrArg (fun y => standing x p - 0 + (0 + y)) e)) :
      avail G S t x p = standing x p - 0 + (0 + 0))
  Nat.le_trans (Nat.sub_le _ _) (Nat.le_of_eq v)

/-- **Renewal while standing keeps a fall** (near-definitional: with no renewal while it is inactive
and no gift, nothing flows in). A formation not active at `t`, to which its partner gives at no step
from `t` on, never rises above its standing at `t` and is active at no later step. -/
theorem stays_fallen {p : Pair} {t : Nat} (idle : isActive G (levels G S t) p = false)
    (none : ∀ s, t ≤ s → sends G S s (levels G S s) (partner p) = false) :
    ∀ d, standing (levels G S (t + d)) p ≤ standing (levels G S t) p ∧
      isActive G (levels G S (t + d)) p = false
  | 0 => ⟨Nat.le_refl _, idle⟩
  | d + 1 =>
    have ih := stays_fallen idle none d
    have le : standing (levels G S (t + d + 1)) p ≤ standing (levels G S t) p :=
      Nat.le_trans (Nat.le_of_eq (standing_advance G S (t + d) (levels G S (t + d)) p))
        (Nat.le_trans (next_le_of_idle G S ih.2 (none (t + d) (Nat.le_add_right t d))) ih.1)
    ⟨le, Naturals.ble_false_of_lt (Nat.lt_of_le_of_lt le (lt_of_ble_false idle))⟩

/-- **Standing at every step of a run, a formation leaves `own · n` in it** (by construction: its
line gains its part exactly at the steps at which it is active). A formation active at every step
before `n` of a run has given its line `own · n` there, whatever that run's giving, renewal and draws;
giving changes the line only through the steps at which the formation stands
(`lines_agree_while_active`). -/
theorem lineAt_of_active {p : Pair} :
    ∀ n, (∀ t, t < n → isActive G (levels G S t) p = true) → lineAt G S p n = G.own * n
  | 0, _ => (Nat.mul_zero G.own).symm
  | n + 1, act =>
    have ih := lineAt_of_active n (fun t lt => act t (Nat.lt_succ_of_lt lt))
    (congrArg (· + cond (isActive G (levels G S n) p) G.own 0) ih).trans
      ((congrArg (fun b => G.own * n + cond b G.own 0) (act n (Nat.lt_succ_self n))).trans
        (Nat.mul_succ G.own n).symm)

/-- **Read by support, giving matters only where it changes who stands.** A formation's line at
step `n` is the same in two runs where it is active at the same steps before `n`: whatever the giving,
the renewal and the draws, its offspring so read differ only through steps at which it stands in one
run and not in the other. -/
theorem lines_agree_while_active {S₁ S₂ : Setting} (p : Pair) :
    ∀ n, (∀ t, t < n → isActive G (levels G S₁ t) p = isActive G (levels G S₂ t) p) →
      lineAt G S₁ p n = lineAt G S₂ p n
  | 0, _ => rfl
  | n + 1, same =>
    have ih := lines_agree_while_active p n (fun t lt => same t (Nat.lt_succ_of_lt lt))
    (congrArg (· + cond (isActive G (levels G S₁ n) p) G.own 0) ih).trans
      (congrArg (fun b => lineAt G S₂ p n + cond b G.own 0) (same n (Nat.lt_succ_self n)))

end WhileStanding

/-! ## A failed renewal: a gift at a shortfall -/

namespace FailedRenewal

open WhileStanding

/-- Needs of three, upkeep, line's part and gift of one each. -/
def parts : WhileStanding.Parts := ⟨fun _ => 3, 1, 1, 1, fun _ => Nat.le_refl 3⟩

/-- The renewer offers two a step; the second's renewal fails at step `1`. -/
def renew : Pair → Nat → Nat
  | first, _ => 2
  | second, t => cond (Nat.beq t 1) 0 2

/-- Both intend to give at every step, from standings five and three. -/
def sharing : Setting := ⟨fun _ _ => true, renew, fun _ _ => 0, (5, 3)⟩

/-- Neither intends to give, from the same standings. -/
def keeping : Setting := ⟨fun _ _ => false, renew, fun _ _ => 0, (5, 3)⟩

/-- **Up to the shortfall the runs agree**: both formations are active at steps `0` and `1`, so by
`runs_agree_until` the levels agree up to step `2`, where the second has fallen to one. -/
theorem agree_to_shortfall :
    ∀ t, t ≤ 2 → ∀ c, (web parts sharing).level t c = (web parts keeping).level t c :=
  runs_agree_until parts (S₁ := sharing) (S₂ := keeping) (fun _ _ => rfl) (fun _ _ => rfl)
    (fun _ _ => rfl) (fun _ _ => rfl) rfl
    (fun t lt p => match t, lt, p with
      | 0, _, first => rfl
      | 0, _, second => rfl
      | 1, _, first => rfl
      | 1, _, second => rfl
      | _ + 2, lt, _ => absurd (Nat.lt_of_le_of_lt (Nat.le_add_left 2 _) lt) (Nat.lt_irrefl 2))

theorem shortfall : levels parts sharing 2 = (5, 1) ∧ levels parts keeping 2 = (5, 1) :=
  ⟨rfl, rfl⟩

/-- **Sharing, the second is lifted and the pair settles at its needs.** -/
theorem levels_sharing : ∀ m, levels parts sharing (m + 4) = (3, 3)
  | 0 => rfl
  | m + 1 => (congrArg (advance parts sharing (m + 4)) (levels_sharing m)).trans rfl

/-- **Keeping, the second never stands again.** -/
theorem levels_keeping : ∀ m, levels parts keeping (m + 2) = (5, 1)
  | 0 => rfl
  | m + 1 => (congrArg (advance parts keeping (m + 2)) (levels_keeping m)).trans rfl

/-- The same, as a case of `stays_fallen`: the second is not active at step `2` and the first never
gives in the keeping run. -/
theorem keeping_fallen (d : Nat) : isActive parts (levels parts keeping (2 + d)) second = false :=
  (stays_fallen parts keeping (p := second) (t := 2) rfl (fun _ _ => rfl) d).2

theorem first_active_sharing : ∀ n, isActive parts (levels parts sharing n) first = true
  | 0 => rfl
  | 1 => rfl
  | 2 => rfl
  | 3 => rfl
  | m + 4 => (congrArg (fun x => isActive parts x first) (levels_sharing m)).trans rfl

theorem first_active_keeping : ∀ n, isActive parts (levels parts keeping n) first = true
  | 0 => rfl
  | 1 => rfl
  | m + 2 => (congrArg (fun x => isActive parts x first) (levels_keeping m)).trans rfl

theorem first_sharing : ∀ n, lineAt parts sharing first n = n
  | 0 => rfl
  | n + 1 => (congrArg (· + cond (isActive parts (levels parts sharing n) first) 1 0)
      (first_sharing n)).trans (congrArg (fun b => n + cond b 1 0) (first_active_sharing n))

theorem first_keeping : ∀ n, lineAt parts keeping first n = n
  | 0 => rfl
  | n + 1 => (congrArg (· + cond (isActive parts (levels parts keeping n) first) 1 0)
      (first_keeping n)).trans (congrArg (fun b => n + cond b 1 0) (first_active_keeping n))

theorem second_sharing : ∀ m, lineAt parts sharing second (m + 4) = m + 2
  | 0 => rfl
  | m + 1 => (congrArg (· + cond (isActive parts (levels parts sharing (m + 4)) second) 1 0)
      (second_sharing m)).trans
        (congrArg (fun x => m + 2 + cond (isActive parts x second) 1 0) (levels_sharing m))

theorem second_keeping : ∀ m, lineAt parts keeping second (m + 2) = 2
  | 0 => rfl
  | m + 1 => (congrArg (· + cond (isActive parts (levels parts keeping (m + 2)) second) 1 0)
      (second_keeping m)).trans
        (congrArg (fun x => 2 + cond (isActive parts x second) 1 0) (levels_keeping m))

/-- **The pair's lines gain without bound.** Over `m + 4` steps the sharing pair's lines exceed the
keeping pair's by `m`: the gain is carried by the second's renewal, resumed once the two units lift
it, an inflow from beyond the pair. -/
theorem lines_gain (m : Nat) :
    lineAt parts sharing first (m + 4) + lineAt parts sharing second (m + 4) =
      lineAt parts keeping first (m + 4) + lineAt parts keeping second (m + 4) + m := by
  rw [first_sharing, second_sharing, first_keeping, second_keeping (m + 2)]
  exact (congrArg (m + 4 + ·) (Nat.add_comm m 2)).trans (Nat.add_assoc _ _ _).symm

theorem second_sends : ∀ m, tally (fun t => sends parts sharing t (levels parts sharing t) second)
    (m + 4) = m + 2
  | 0 => rfl
  | m + 1 => (congrArg (· + cond (sends parts sharing (m + 4) (levels parts sharing (m + 4)) second)
      1 0) (second_sends m)).trans
        (congrArg (fun x => m + 2 + cond (sends parts sharing (m + 4) x second) 1 0)
          (levels_sharing m))

theorem first_sends : ∀ n, tally (fun t => sends parts sharing t (levels parts sharing t) first) n = n
  | 0 => rfl
  | n + 1 => (congrArg (· + cond (sends parts sharing n (levels parts sharing n) first) 1 0)
      (first_sends n)).trans
        (congrArg (fun b => n + cond (true && b) 1 0) (first_active_sharing n))

/-- **What the first gave beyond what it received is two units**, whatever the length of the run. -/
theorem gifts_sharing (m : Nat) :
    tally (fun t => sends parts sharing t (levels parts sharing t) first) (m + 4) =
      tally (fun t => sends parts sharing t (levels parts sharing t) second) (m + 4) + 2 :=
  (first_sends (m + 4)).trans (congrArg (· + 2) (second_sends m).symm)

/-- **Before the shortfall no reading through the levels tells sharing from keeping**: the premises
of `factors_equal_while_supported` met, read on the second's line at step `2`. Any factors reading
that line as `β · 2` in the sharing run and `γ · 2` in the keeping run are equal; `β = γ = 1` reads
both. -/
theorem read_to_shortfall {β γ : Nat}
    (h₁ : (web parts sharing).level 2 (line second) = 0 + β * 2)
    (h₂ : (web parts keeping).level 2 (line second) = 0 + γ * 2) : β = γ :=
  factors_equal_while_supported parts (S₁ := sharing) (S₂ := keeping) (fun _ _ => rfl)
    (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) rfl
    (fun t lt p => match t, lt, p with
      | 0, _, first => rfl
      | 0, _, second => rfl
      | 1, _, first => rfl
      | 1, _, second => rfl
      | _ + 2, lt, _ => absurd (Nat.lt_of_le_of_lt (Nat.le_add_left 2 _) lt) (Nat.lt_irrefl 2))
    (fun l => l 2 (line second)) (fun _ _ same => same 2 (Nat.le_refl 2) (line second))
    (Nat.zero_lt_succ 1) h₁ h₂

theorem read_to_shortfall_met :
    (web parts sharing).level 2 (line second) = 0 + 1 * 2 ∧
      (web parts keeping).level 2 (line second) = 0 + 1 * 2 :=
  ⟨rfl, rfl⟩

end FailedRenewal

/-! ## A gift at the giver's need ends the giver's renewal -/

namespace GiverAtNeed

open WhileStanding

/-- The first intends to give at every step and the second never, from standings at their needs,
the renewer offering two a step to each. -/
def giverAlone : Setting :=
  ⟨fun p _ => match p with
    | first => true
    | second => false, fun _ _ => 2, fun _ _ => 0, (3, 3)⟩

/-- Neither intends to give, from the same standings, with the same renewal. -/
def bothKeep : Setting := ⟨fun _ _ => false, fun _ _ => 2, fun _ _ => 0, (3, 3)⟩

/-- **The gift takes the giver below its need**: from step `1` the giver stands at two and the
withholder at four. -/
theorem levels_alone : ∀ m, levels FailedRenewal.parts giverAlone (m + 1) = (2, 4)
  | 0 => rfl
  | m + 1 => (congrArg (advance FailedRenewal.parts giverAlone (m + 1)) (levels_alone m)).trans rfl

theorem levels_kept : ∀ n, levels FailedRenewal.parts bothKeep n = (3, 3)
  | 0 => rfl
  | n + 1 => (congrArg (advance FailedRenewal.parts bothKeep n) (levels_kept n)).trans rfl

/-- **The giver never stands again**: a case of `stays_fallen`, the withholder never giving. -/
theorem alone_fallen (d : Nat) :
    isActive FailedRenewal.parts (levels FailedRenewal.parts giverAlone (1 + d)) first = false :=
  (stays_fallen FailedRenewal.parts giverAlone (p := first) (t := 1) rfl (fun _ _ => rfl) d).2

theorem alone_first : ∀ m, lineAt FailedRenewal.parts giverAlone first (m + 1) = 1
  | 0 => rfl
  | m + 1 => (congrArg (· + cond (isActive FailedRenewal.parts (levels FailedRenewal.parts giverAlone (m + 1))
      first) 1 0) (alone_first m)).trans
        (congrArg (fun x => 1 + cond (isActive FailedRenewal.parts x first) 1 0) (levels_alone m))

theorem kept_first (n : Nat) : lineAt FailedRenewal.parts bothKeep first n = n :=
  (lineAt_of_active FailedRenewal.parts bothKeep n (fun t _ =>
    congrArg (fun x => isActive FailedRenewal.parts x first) (levels_kept t))).trans (Nat.one_mul n)

/-- **One gift at the giver's need ends its renewal**: over `m + 1` steps the giver's line is `m`
short of what keeping leaves it, from one gift of one unit. -/
theorem gift_lost (m : Nat) :
    lineAt FailedRenewal.parts bothKeep first (m + 1) =
      lineAt FailedRenewal.parts giverAlone first (m + 1) + m :=
  (kept_first (m + 1)).trans ((Nat.add_comm m 1).trans (congrArg (· + m) (alone_first m).symm))

theorem second_active : ∀ t, isActive FailedRenewal.parts (levels FailedRenewal.parts giverAlone t) second =
    isActive FailedRenewal.parts (levels FailedRenewal.parts bothKeep t) second
  | 0 => rfl
  | m + 1 => (congrArg (fun x => isActive FailedRenewal.parts x second) (levels_alone m)).trans
      (congrArg (fun x => isActive FailedRenewal.parts x second) (levels_kept (m + 1))).symm

/-- **What the gift brought the receiver, read by support, is nothing**: the withholder stands at
every step of both runs, so by `lines_agree_while_active` its line is the same in both, although
its standing is not (`standings_differ`). -/
theorem withholder_same (n : Nat) :
    lineAt FailedRenewal.parts giverAlone second n = lineAt FailedRenewal.parts bothKeep second n :=
  lines_agree_while_active FailedRenewal.parts second n (fun t _ => second_active t)

theorem standings_differ :
    levels FailedRenewal.parts giverAlone 1 = (2, 4) ∧ levels FailedRenewal.parts bothKeep 1 = (3, 3) :=
  ⟨rfl, rfl⟩

end GiverAtNeed

/-! ## A draw that ends the renewal -/

namespace DrawnBelowNeed

open WhileStanding

/-- A taker beyond the pair would draw two units from the second's standing at step `1`, and nothing
else. -/
def draw : Pair → Nat → Nat
  | first, _ => 0
  | second, t => cond (Nat.beq t 1) 2 0

/-- Neither intends to give; the renewer offers two a step to each; the standings start at five and
three. -/
def keeping : Setting := ⟨fun _ _ => false, fun _ _ => 2, draw, (5, 3)⟩

/-- **The draw is taken in full** at step `1`, and the taker draws nothing after it. -/
theorem drawn :
    drawTaken FailedRenewal.parts keeping 1 (levels FailedRenewal.parts keeping 1) second = 2 ∧
      ∀ t, keeping.draw second (t + 2) = 0 :=
  ⟨rfl, fun _ => rfl⟩

theorem levels_drawn : ∀ m, levels FailedRenewal.parts keeping (m + 2) = (5, 1)
  | 0 => rfl
  | m + 1 => (congrArg (advance FailedRenewal.parts keeping (m + 2)) (levels_drawn m)).trans rfl

/-- **The draw ends the renewal**: the second stands below its need from step `2` on and is active
at no later step, although the taker draws nothing after step `1` (a case of `stays_fallen`). -/
theorem fallen (d : Nat) :
    isActive FailedRenewal.parts (levels FailedRenewal.parts keeping (2 + d)) second = false :=
  (stays_fallen FailedRenewal.parts keeping (p := second) (t := 2) rfl (fun _ _ => rfl) d).2

end DrawnBelowNeed

/-! ## The landed need-asymmetry witness at the bound -/

namespace NeedsAtCapacity

open PairSelection.Needs PairSelection.Needs.Member

/-- The pair of `PairSelection.Needs`, each formation on its own standing. -/
def pair : List PairSelection.Needs.Member := [giver, receiver]

theorem gainless : ∀ t, 0 ≤ t → t < 0 + 1 → (flow 1).GainlessOn (pair.map id) t
  | 0, _, _ => fun f mem => match f, mem with
    | giver, _ => Nat.le_refl 1
    | receiver, mem => nomatch mem
    | child, mem => nomatch mem
    | pool, mem => nomatch mem
  | n + 1, _, lt => absurd (Nat.lt_of_succ_lt_succ lt) (Nat.not_lt_zero n)

/-- **Need asymmetry is the capacity bound attained.** In the landed witness with needs one and two,
the needs met in the closed pair go from one to three across the step of the gift, while the pair's
stock stays three: the bound `met_needs_within_start` is met with equality. -/
theorem at_capacity :
    total pair (metNeed (web 1) id 0) = 1 ∧ total pair (metNeed (web 1) id (0 + 1)) = 3 ∧
      (web 1).stock (pair.map id) 0 = 3 ∧ (web 1).stock (pair.map id) 1 = 3 ∧
      total pair (metNeed (web 1) id (0 + 1)) ≤ (web 1).stock (pair.map id) 0 :=
  ⟨rfl, rfl, rfl, rfl, met_needs_within_start (balances 1) id pair 1 gainless⟩

end NeedsAtCapacity

end PairFlow
end Becoming
