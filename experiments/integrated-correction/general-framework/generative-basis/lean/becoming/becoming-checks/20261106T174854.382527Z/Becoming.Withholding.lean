import Becoming.Recurrence

/-!
# Withholding: giving that waits on giving

Formations `α` and a relation `up : α → α → Prop`, `up b a` read "the giving of `a` waits on that
of `b`". A configuration `s : α → Prop` says which formations give at a step. Two laws of change on
configurations are compared, each a determined law of `Becoming.Recurrence`; every law below is
stated on its run `Law.run next s`, a run of the spine whose states are the course
`Law.orbit next s` (`Law.run_state`, by `rfl`):

- with memory, `waitsAll up`: a formation gives at the next step where it gave and every formation
  it waits on gave;
- without memory, `answers up`: a formation gives at the next step exactly where every formation it
  waits on gave.

A chain of `k` waits from `b` to `a` (`Chain up k b a`) is `k` links, each taken into the formation
that waits; the chain of length zero leads from `a` to `a`. `Within up k b a` says some chain of at
most `k` waits leads from `b` to `a`. A chain of `k` waits is `k` steps of the grammar's `«迭»`
(`chain_iff_steps`), and within `k` waits is within `k` steps (`within_iff_withinSteps`), so
both closed forms below are cases of the grammar's laws of taking on read on chains (`«存承之迭»`
with memory, `«承之迭»` without), whose rounds `waitsAll` and `answers` meet by definition. No
premise about `α` or `up` is made: no finiteness, no decision of equality and no decision of
giving.

* **With memory: withholding absorbs.**
  - **Closed form, with memory.** A formation gives at step `n` exactly where every formation
    within `n` waits of it gave at the start (`waitsAll_closed`).
  - **Withholding stays.** With memory, giving at `n + 1` gives giving at `n`
    (`waitsAll_gives_earlier`), so a formation withholding at `n` withholds at every later step
    (`waitsAll_withholding_stays`, `waitsAll_withholding_stays_le`): no course of this law regains
    giving.
  - **Withholding spreads downstream.** A formation that withholds at the start and leads by a
    chain of `k` waits to `a` makes `a` withhold at every step from `k` on
    (`withholding_spreads`).
  - **One withholding ends all giving in a family reached from it** (headline). Where every
    formation lies within `d` waits of `b` and `b` withholds at the start, every formation withholds
    at every step from `d` on (`withholding_absorbs`).
  - **Total withholding merges starts.** Two courses of `waitsAll`, one withholding everywhere at
    step `n`, the other at step `m`, agree at every formation at steps `n + k` and `m + k`
    (`total_withholding_merges`).
* **Without memory: passing out and returning.**
  - **Closed form, without memory.** A formation gives at step `n` exactly where every formation
    with a chain of exactly `n` waits to it gave at the start (`answers_closed`).
  - **Where no chain is that long, withholding passes out.** If no chain of `L` waits exists, none
    longer exists (`no_longer_chain`), and every formation gives at every step from `L` on,
    whatever the start (`gives_without_chain`). Exact in the witness `Line`, two formations, the
    second waiting on the first: no chain of 2 waits, and from the first withholding the second
    still withholds at step 1 (`Line.passes_out_exact`).
  - **On a loop, withholding returns** (headline). A chain of `p` waits from `b` back to `b`, and
    `b` withholding at the start, makes `b` withhold at every step `k * p`
    (`withholding_returns`). No positivity of `p` is needed.
* **More waiting, less giving.** Adding waits (`up` within `up'`) takes giving away at every step
  under both laws (`waitsAll_more_waiting`, `answers_more_waiting`): each added wait on another's
  giving is one more way for withholding to arrive.
* **Restoring needs another law.** In the witness `Ring`, three formations each waiting on the one
  before, one withholding at the start: with memory all withhold from step 2 on, and at step 1 one
  still gives (`Ring.waitsAll_absorbs_exact`); without memory the withholding circulates, one
  formation withholding at each step and each formation again every 3 steps
  (`Ring.answers_circulates`; its return at `first` is `Ring.answers_returns`, an instance of
  `withholding_returns` through `Ring.loop`). Under the law in which one formation gives at every
  step whatever it waits on (`givesFirst`), every formation gives at every step from step 3 on, from
  every start (`Ring.givesFirst_restores`), and from the one withholding the third formation still
  withholds at step 2 (`Ring.givesFirst_restores_exact`).

**Relations to other laws.** The two halves parallel what `Becoming.Loops` states for carried
amounts (no instance theorem joins them): where no chain of couplings is long enough, a finite
order is exact (`carriedWithin_exact_of_not_coupledInto`); where a loop lies upstream, what reaches
it keeps arriving (`carriedWithin_lt_of_loop`). Here the carried thing is withholding: it passes
out where no chain is longer than `L` and keeps returning around a loop. With memory, withholding
has the shape of a possibility lost under `Becoming.Recurrence`'s `Branching.lost_stays`: giving at
`n + 1` gives giving at `n` (`waitsAll_gives_earlier`), as being reachable at `n + 1` gives being
reachable at `n` (`Branching.Reachable.earlier`), so withholding stays as a lost possibility stays lost.
`total_withholding_merges` compares with `Law.merged_stays` (configurations merged stay merged);
it is stated pointwise by `↔`, since equality of configurations `α → Prop` would need function and
proposition extensionality. As in `Becoming.Capture`'s `Law.perturbation_reabsorbed`, where a
perturbed state returns under one rule and escape needs the rule changed, giving is regained here
only under another law (`givesFirst`), never along a course of `waitsAll`.

On a web, `answers` is the support of the web in which each formation requires its own condition
at need the number it waits on, and each formation it waits on, where supported, gives one unit to
that condition (`Tolerance.web_answers`, the case of `Tolerance.web_tolerating`).

No ethical predicate, ranking or axiom occurs. The readings belong to the chapter.
-/

namespace Becoming
namespace Withholding

universe u

variable {α : Type u}

/-! ## The two laws and chains of waits -/

/-- With memory: a formation gives at the next step where it gave and all it waits on gave. -/
def waitsAll (up : α → α → Prop) (s : α → Prop) (a : α) : Prop :=
  s a ∧ ∀ b, up b a → s b

/-- Without memory: a formation gives at the next step exactly where all it waits on gave. -/
def answers (up : α → α → Prop) (s : α → Prop) (a : α) : Prop :=
  ∀ b, up b a → s b

/-- A formation `src` marks gives at every step whatever it waits on; the others answer. -/
def givesFirst (src : α → Prop) (up : α → α → Prop) (s : α → Prop) (a : α) : Prop :=
  src a ∨ answers up s a

/-- A chain of exactly `k` waits from `b` to `a`, each link taken into the formation that waits. -/
inductive Chain (up : α → α → Prop) : Nat → α → α → Prop
  | here (a : α) : Chain up 0 a a
  | step {k : Nat} {b c a : α} : Chain up k b c → up c a → Chain up (k + 1) b a

/-- Some chain of at most `k` waits leads from `b` to `a`. -/
def Within (up : α → α → Prop) (k : Nat) (b a : α) : Prop :=
  ∃ j, j ≤ k ∧ Chain up j b a

section Chains

variable {up : α → α → Prop}

/-- A chain of no waits leads from a formation to itself. -/
theorem Chain.zero_eq {b a : α} : Chain up 0 b a → b = a
  | .here _ => rfl

/-- A chain of `n = k + 1` waits ends with one link after a chain of `k`. -/
theorem Chain.last_of_eq {n : Nat} {b a : α} :
    Chain up n b a → ∀ k, n = k + 1 → ∃ c, Chain up k b c ∧ up c a
  | .here _, _, same => Nat.noConfusion same
  | .step ch link, _, same => (Nat.succ.inj same) ▸ ⟨_, ch, link⟩

/-- A chain of `k + 1` waits ends with one link after a chain of `k`. -/
theorem Chain.last {k : Nat} {b a : α} (ch : Chain up (k + 1) b a) :
    ∃ c, Chain up k b c ∧ up c a :=
  ch.last_of_eq k rfl

/-- Every chain of `k + m` waits begins with a chain of `k`. -/
theorem Chain.prefix {k : Nat} : ∀ (m : Nat) {b a : α}, Chain up (k + m) b a → ∃ c, Chain up k b c
  | 0, _, a, ch => ⟨a, ch⟩
  | m + 1, _, _, ch =>
    let ⟨_, ch', _⟩ := Chain.last (k := k + m) ch
    Chain.prefix m ch'

/-- Chains of waits compose. -/
theorem Chain.append {i : Nat} {x y : α} (first : Chain up i x y) :
    ∀ {j : Nat} {z : α}, Chain up j y z → Chain up (i + j) x z
  | _, _, .here _ => first
  | _, _, .step ch link => Chain.step (Chain.append first ch) link

/-- A loop of `p` waits, gone around `k` times, is a chain of `p * k` waits. -/
theorem Chain.iterate {p : Nat} {b : α} (loop : Chain up p b b) : ∀ k, Chain up (p * k) b b
  | 0 => Chain.here b
  | k + 1 => (Chain.iterate loop k).append loop

/-- Within `k` waits is within every larger number. -/
theorem Within.mono {k n : Nat} {b a : α} (within : Within up k b a) (le : k ≤ n) :
    Within up n b a :=
  let ⟨j, jk, ch⟩ := within
  ⟨j, Nat.le_trans jk le, ch⟩

/-- **A chain of `k` waits is `k` steps of the grammar** (`«迭»` of the waits), the chain's last wait
being the last step (`«迭之末步»`). -/
theorem chain_iff_steps : ∀ (k : Nat) {b a : α}, Chain up k b a ↔ «迭» up k b a
  | 0, _, _ => ⟨Chain.zero_eq, fun e => Eq.subst (motive := fun v => Chain up 0 _ v) e (.here _)⟩
  | k + 1, _, _ => ⟨fun ch => match ch.last with
      | ⟨_, ch', link⟩ => («迭之末步» k).mpr ⟨_, (chain_iff_steps k).mp ch', link⟩,
    fun steps => match («迭之末步» k).mp steps with
      | ⟨_, first, link⟩ => .step ((chain_iff_steps k).mpr first) link⟩

/-- **Within `k` waits is within `k` steps of the grammar** (`«迭内»`). -/
theorem within_iff_withinSteps {k : Nat} {b a : α} : Within up k b a ↔ «迭内» up k b a :=
  ⟨fun ⟨j, le, ch⟩ => ⟨j, le, (chain_iff_steps j).mp ch⟩,
   fun ⟨j, le, steps⟩ => ⟨j, le, (chain_iff_steps j).mpr steps⟩⟩

end Chains

/-! ## With memory: withholding absorbs -/

section Memory

variable (up : α → α → Prop) (s : α → Prop)

/-- **Closed form, with memory: a formation gives at step `n` exactly where every formation within
`n` waits of it gave at the start.** It is the grammar's law of taking on with memory (`«存承之迭»`),
whose rounds `waitsAll` meets by definition, read on chains of waits (`within_iff_withinSteps`). -/
theorem waitsAll_closed : ∀ (n : Nat) (a : α),
    (Law.run (waitsAll up) s).state n a ↔ ∀ b, Within up n b a → s b :=
  fun n a => («存承之迭» (S := (Law.run (waitsAll up) s).state) (fun _ _ => Iff.rfl) n a).trans
    ⟨fun all b within => all b (within_iff_withinSteps.mp within),
     fun all b within => all b (within_iff_withinSteps.mpr within)⟩

variable {up s}

/-- **With memory, giving at `n + 1` gives giving at `n`.** -/
theorem waitsAll_gives_earlier {n : Nat} {a : α}
    (gives : (Law.run (waitsAll up) s).state (n + 1) a) : (Law.run (waitsAll up) s).state n a :=
  gives.1

/-- **Withholding stays, with memory: a formation withholding at `n` withholds at every later
step.** No course of `waitsAll` regains giving. -/
theorem waitsAll_withholding_stays {n : Nat} {a : α}
    (out : ¬ (Law.run (waitsAll up) s).state n a) : ∀ k, ¬ (Law.run (waitsAll up) s).state (n + k) a
  | 0 => out
  | k + 1 => fun gives => waitsAll_withholding_stays out k (waitsAll_gives_earlier gives)

/-- **Withholding stays, at every later step `m ≥ n`.** -/
theorem waitsAll_withholding_stays_le {n m : Nat} {a : α}
    (out : ¬ (Law.run (waitsAll up) s).state n a) (le : n ≤ m) :
    ¬ (Law.run (waitsAll up) s).state m a := by
  let ⟨d, same⟩ := le_dest le
  subst same
  exact waitsAll_withholding_stays out d

/-- **Withholding spreads downstream: a formation withholding at the start that leads by a chain
of `k` waits to `a` makes `a` withhold at every step from `k` on.** -/
theorem withholding_spreads {b a : α} {k n : Nat} (out : ¬ s b) (ch : Chain up k b a)
    (le : k ≤ n) : ¬ (Law.run (waitsAll up) s).state n a :=
  fun gives => out ((waitsAll_closed up s n a).mp gives b ⟨k, le, ch⟩)

/-- **One withholding ends all giving in a family reached from it.** Where every formation lies
within `d` waits of `b`, and `b` withholds at the start, every formation withholds at every step
from `d` on: the course of `waitsAll` is absorbed into total withholding, at every later step. -/
theorem withholding_absorbs {b : α} {d : Nat} (reach : ∀ a, Within up d b a) (out : ¬ s b) :
    ∀ n, d ≤ n → ∀ a, ¬ (Law.run (waitsAll up) s).state n a :=
  fun n le a gives => out ((waitsAll_closed up s n a).mp gives b ((reach a).mono le))

/-- **Total withholding merges starts.** Two courses of `waitsAll`, one withholding at every
formation at step `n`, the other at step `m`, agree at every formation at steps `n + k` and
`m + k`: no later step tells them apart. -/
theorem total_withholding_merges {s' : α → Prop} {n m : Nat}
    (none : ∀ a, ¬ (Law.run (waitsAll up) s).state n a)
    (none' : ∀ a, ¬ (Law.run (waitsAll up) s').state m a) :
    ∀ k a, ((Law.run (waitsAll up) s).state (n + k) a ↔
      (Law.run (waitsAll up) s').state (m + k) a) :=
  fun k a =>
    ⟨fun gives => absurd gives (waitsAll_withholding_stays (none a) k),
     fun gives => absurd gives (waitsAll_withholding_stays (none' a) k)⟩

end Memory

/-! ## Without memory: passing out and returning -/

section NoMemory

variable (up : α → α → Prop) (s : α → Prop)

/-- **Closed form, without memory: a formation gives at step `n` exactly where every formation with
a chain of exactly `n` waits to it gave at the start.** It is the grammar's law of taking on
(`«承之迭»`), whose rounds `answers` meets by definition, read on chains of waits
(`chain_iff_steps`). -/
theorem answers_closed : ∀ (n : Nat) (a : α),
    (Law.run (answers up) s).state n a ↔ ∀ b, Chain up n b a → s b :=
  fun n a => («承之迭» (S := (Law.run (answers up) s).state) (fun _ _ => Iff.rfl) n a).trans
    ⟨fun all b ch => all b ((chain_iff_steps n).mp ch), fun all b steps => all b ((chain_iff_steps n).mpr steps)⟩

variable {up}

/-- **No chain of `L` waits, none longer.** -/
theorem no_longer_chain {L : Nat} (none : ∀ b a, ¬ Chain up L b a) :
    ∀ n, L ≤ n → ∀ b a, ¬ Chain up n b a := by
  intro n le b a ch
  let ⟨d, same⟩ := le_dest le
  subst same
  let ⟨c, ch'⟩ := Chain.prefix d ch
  exact none b c ch'

/-- **Where no chain is `L` waits long, withholding passes out: without memory every formation
gives at every step from `L` on, whatever the start.** -/
theorem gives_without_chain {L : Nat} (none : ∀ b a, ¬ Chain up L b a) :
    ∀ n, L ≤ n → ∀ a, (Law.run (answers up) s).state n a :=
  fun n le a => (answers_closed up s n a).mpr fun b ch => absurd ch (no_longer_chain none n le b a)

/-- **On a loop, withholding returns.** A chain of `p` waits from `b` back to `b`, with `b`
withholding at the start, makes `b` withhold, without memory, at every step `k * p`: the
withholding comes back around the loop at every turn. -/
theorem withholding_returns {p : Nat} {b : α} {s : α → Prop} (loop : Chain up p b b)
    (out : ¬ s b) : ∀ k, ¬ (Law.run (answers up) s).state (k * p) b :=
  fun k gives =>
    out ((answers_closed up s (k * p) b).mp gives b (Nat.mul_comm p k ▸ loop.iterate k))

end NoMemory

/-! ## More waiting, less giving -/

section MoreWaiting

variable {up up' : α → α → Prop} (s : α → Prop)

/-- **More waiting, less giving, with memory: adding waits takes giving away at every step.** -/
theorem waitsAll_more_waiting (sub : ∀ b a, up b a → up' b a) :
    ∀ n a, (Law.run (waitsAll up') s).state n a → (Law.run (waitsAll up) s).state n a
  | 0, _, gives => gives
  | n + 1, a, gives =>
    ⟨waitsAll_more_waiting sub n a gives.1,
     fun c link => waitsAll_more_waiting sub n c (gives.2 c (sub c a link))⟩

/-- **More waiting, less giving, without memory: adding waits takes giving away at every step.** -/
theorem answers_more_waiting (sub : ∀ b a, up b a → up' b a) :
    ∀ n a, (Law.run (answers up') s).state n a → (Law.run (answers up) s).state n a
  | 0, _, gives => gives
  | n + 1, a, gives => fun c link => answers_more_waiting sub n c (gives c (sub c a link))

end MoreWaiting

/-! ## Witness: a line of two

Two formations, `second` waiting on `first`: no chain of two waits exists, so without memory
withholding passes out from step 2 on, and from `first` withholding at the start `second` still
withholds at step 1. -/

/-- Two formations of a line. -/
inductive Line where
  | first
  | second

namespace Line

/-- `second` waits on `first`. -/
inductive Waits : Line → Line → Prop
  | onFirst : Waits first second

/-- At the start `first` withholds and `second` gives. -/
def firstWithheld : Line → Prop
  | first => False
  | second => True

/-- No chain of two waits exists in the line. -/
theorem no_chain_two : ∀ b a, ¬ Chain Waits 2 b a := by
  intro b a ch
  let ⟨c, ch', link⟩ := Chain.last ch
  cases link
  let ⟨_, _, link'⟩ := Chain.last ch'
  cases link'

/-- **Passing out from step 2, exactly.** Without memory every formation of the line gives at every
step from 2 on, from every start (an instance of `gives_without_chain`), and from `first`
withholding at the start `second` still withholds at step 1. -/
theorem passes_out_exact :
    (∀ s : Line → Prop, ∀ n, 2 ≤ n → ∀ a, (Law.run (answers Waits) s).state n a) ∧
      ¬ (Law.run (answers Waits) firstWithheld).state 1 second :=
  ⟨fun s => gives_without_chain s no_chain_two,
   fun gives => (gives first Waits.onFirst : False)⟩

end Line

/-! ## Witness: a ring of three

Three formations, each waiting on the one before: `first` waits on `third`, `second` on `first`,
`third` on `second`. At the start `first` withholds and the other two give. -/

/-- Three formations of a ring. -/
inductive Ring where
  | first
  | second
  | third

namespace Ring

/-- Each formation of the ring waits on the one before. -/
inductive Waits : Ring → Ring → Prop
  | onThird : Waits third first
  | onFirst : Waits first second
  | onSecond : Waits second third

/-- At the start `first` withholds and the other two give. -/
def oneWithheld : Ring → Prop
  | first => False
  | second => True
  | third => True

/-- The formation that gives whatever it waits on, in `givesFirst`. -/
def isFirst : Ring → Prop
  | first => True
  | second => False
  | third => False

theorem answers_first {s : Ring → Prop} : answers Waits s first ↔ s third :=
  ⟨fun all => all third Waits.onThird, fun gave b link => by cases link; exact gave⟩

theorem answers_second {s : Ring → Prop} : answers Waits s second ↔ s first :=
  ⟨fun all => all first Waits.onFirst, fun gave b link => by cases link; exact gave⟩

theorem answers_third {s : Ring → Prop} : answers Waits s third ↔ s second :=
  ⟨fun all => all second Waits.onSecond, fun gave b link => by cases link; exact gave⟩

/-- Every formation of the ring lies within two waits of `first`. -/
theorem within_two (a : Ring) : Within Waits 2 first a :=
  match a with
  | first => ⟨0, Nat.zero_le 2, Chain.here first⟩
  | second => ⟨1, Nat.le_succ 1, Chain.step (Chain.here first) Waits.onFirst⟩
  | third => ⟨2, Nat.le_refl 2,
      Chain.step (Chain.step (Chain.here first) Waits.onFirst) Waits.onSecond⟩

/-- The ring is a loop of three waits from `first` back to `first`. -/
theorem loop : Chain Waits 3 first first :=
  Chain.step (Chain.step (Chain.step (Chain.here first) Waits.onFirst) Waits.onSecond)
    Waits.onThird

/-- **With memory, one withholding absorbs the ring from step 2 on, exactly.** Every formation
withholds at every step from 2 on (an instance of `withholding_absorbs`), and at step 1 `third`
still gives. -/
theorem waitsAll_absorbs_exact :
    (∀ n, 2 ≤ n → ∀ a, ¬ (Law.run (waitsAll Waits) oneWithheld).state n a) ∧
      (Law.run (waitsAll Waits) oneWithheld).state 1 third :=
  ⟨withholding_absorbs within_two (fun out => out),
   ⟨trivial, fun b link => by cases link; exact trivial⟩⟩

/-- One rotation: the formation that withholds passes the withholding to the one after it. -/
theorem rotate_first {s : Ring → Prop} (now : ¬ s first ∧ s second ∧ s third) :
    answers Waits s first ∧ ¬ answers Waits s second ∧ answers Waits s third :=
  ⟨answers_first.mpr now.2.2, fun gives => now.1 (answers_second.mp gives),
   answers_third.mpr now.2.1⟩

theorem rotate_second {s : Ring → Prop} (now : s first ∧ ¬ s second ∧ s third) :
    answers Waits s first ∧ answers Waits s second ∧ ¬ answers Waits s third :=
  ⟨answers_first.mpr now.2.2, answers_second.mpr now.1,
   fun gives => now.2.1 (answers_third.mp gives)⟩

theorem rotate_third {s : Ring → Prop} (now : s first ∧ s second ∧ ¬ s third) :
    ¬ answers Waits s first ∧ answers Waits s second ∧ answers Waits s third :=
  ⟨fun gives => now.2.2 (answers_first.mp gives), answers_second.mpr now.1,
   answers_third.mpr now.2.1⟩

/-- **Without memory, the withholding circulates.** At each step exactly one formation of the ring
withholds, and the withholding returns to each formation every 3 steps: `first` at `3 * k`,
`second` at `3 * k + 1`, `third` at `3 * k + 2`. -/
theorem answers_circulates : ∀ k : Nat,
    (¬ (Law.run (answers Waits) oneWithheld).state (3 * k) first ∧
      (Law.run (answers Waits) oneWithheld).state (3 * k) second ∧
      (Law.run (answers Waits) oneWithheld).state (3 * k) third) ∧
    ((Law.run (answers Waits) oneWithheld).state (3 * k + 1) first ∧
      ¬ (Law.run (answers Waits) oneWithheld).state (3 * k + 1) second ∧
      (Law.run (answers Waits) oneWithheld).state (3 * k + 1) third) ∧
    ((Law.run (answers Waits) oneWithheld).state (3 * k + 2) first ∧
      (Law.run (answers Waits) oneWithheld).state (3 * k + 2) second ∧
      ¬ (Law.run (answers Waits) oneWithheld).state (3 * k + 2) third)
  | 0 =>
    let start : ¬ oneWithheld first ∧ oneWithheld second ∧ oneWithheld third :=
      ⟨fun out => out, trivial, trivial⟩
    let one := rotate_first start
    ⟨start, one, rotate_second one⟩
  | k + 1 =>
    let ⟨_, _, two⟩ := answers_circulates k
    let three := rotate_third two
    let four := rotate_first three
    ⟨three, four, rotate_second four⟩

/-- **The returning withholding is an instance of `withholding_returns`**: around the loop of three
waits, `first` withholds at every step `k * 3`. -/
theorem answers_returns : ∀ k, ¬ (Law.run (answers Waits) oneWithheld).state (k * 3) first :=
  withholding_returns loop (fun out => out)

/-- `first` gives at every step after the start under `givesFirst`. -/
theorem givesFirst_first {s : Ring → Prop} (m : Nat) :
    (Law.run (givesFirst isFirst Waits) s).state (m + 1) first :=
  Or.inl trivial

theorem givesFirst_second {s : Ring → Prop} (m : Nat) :
    (Law.run (givesFirst isFirst Waits) s).state (m + 2) second :=
  Or.inr fun b link => by cases link; exact givesFirst_first m

theorem givesFirst_third {s : Ring → Prop} (m : Nat) :
    (Law.run (givesFirst isFirst Waits) s).state (m + 3) third :=
  Or.inr fun b link => by cases link; exact givesFirst_second m

/-- **Restoring needs another law.** Under `givesFirst`, where `first` gives at every step whatever
it waits on, every formation of the ring gives at every step from step 3 on, from every start. -/
theorem givesFirst_restores (s : Ring → Prop) :
    ∀ n, 3 ≤ n → ∀ a, (Law.run (givesFirst isFirst Waits) s).state n a := by
  intro n le a
  let ⟨d, same⟩ := le_dest le
  subst same
  rw [Nat.add_comm 3 d]
  cases a with
  | first => exact givesFirst_first (d + 2)
  | second => exact givesFirst_second (d + 1)
  | third => exact givesFirst_third d

/-- **Step 3 is exact**: from the one withholding at `first`, `third` still withholds at step 2. -/
theorem givesFirst_restores_exact :
    ¬ (Law.run (givesFirst isFirst Waits) oneWithheld).state 2 third :=
  fun gives =>
    gives.elim (fun none => (none : False))
      (fun all => (all second Waits.onSecond).elim (fun none => (none : False))
        (fun all' => (all' first Waits.onFirst : False)))

end Ring

end Withholding
end Becoming
