import Becoming.WindowedWaiting
import Becoming.SelectionLevels
import Becoming.RuleShaping
import Becoming.DrawnBeyond

/-!
# Pair selection: offspring read from what a pair's run gives, and where a gift's surplus comes from

A pair's run of two laws of giving (`course`, from a history of mutual giving, with a supplied
error pattern turning an intended giving into withholding) gives each formation two counts over
steps `0 … n - 1`: `received` (the steps its partner gave it) and `withheld` (the steps it withheld).
A `Place` is a formation's place in a pair (`Place.other` the other place); read while it is
supported, its offspring are `Place.offspring a β γ n = a + β · received + γ · withheld`. The laws below are of these runs and of
the selection term (`SelectionTerm`, `SelectionLevels`, `RuleShaping`) on these offspring, and
(EL4c) of flows on the World's webs (`Flow`, `DrawnBeyond`).

## EL4b (a): the counts are theorems of the runs, for every `n`

- `counts_giving`: laws that give after mutual giving, without errors, each receive at every step
  and withhold at none: `(n, 0)`.
- Against a withholder (`counts_*_withholding`): giving whatever comes gets `(0, 0)`; answering
  over `1 + d` steps gets `(0, d)` and gives its withholder `(1, 1 + d)`; the window of two over
  `2 + d` steps gets `(0, d)` and gives `(2, 2 + d)`; agreement gets `(0, half n)` and gives
  `half (n + 1)`; waiting on both is as answering; two withholders get `(0, n)` each; the alternator
  gives at every odd step.
- Beside the alternator (`counts_*_alternating`): the window holder gives at every step, answering
  at every even step, waiting on both at step `0` only.
- One error by the first at step `t` (`meets_after`: a later error is the error at step `0`
  delayed by `t`; `counts_after`): `counts_windowed_error` (the window absorbs it: over
  `t + (m + 1)` steps the erring holder gets `(t + (m + 1), 1)`, its partner `(t + m, 0)`),
  `counts_answering_error` (the echo: `(t + half (m + 1), half (m + 1))` and `(t + half m, half m)`
  over `t + m` steps), `counts_waitingBoth_error` (`(t + 1, 1 + m)` and `(t, m)`),
  `counts_agreeing_error`.
- Any errors under the window: `windowed_course` (the run of two window holders is the clocked
  course of `WindowedWaiting`, for any error pattern); `counts_windowed_spaced` (where no formation
  errs at two consecutive steps, each withholds exactly at its errors and receives at every step
  its partner does not err).
- `table_twenty`, `error_table_twenty`: the tables of WS §4 at `n = 20`, by evaluation (checks of
  the closed forms, not further laws).

## EL4b (b): pairs as groups of two

- `kind_rises_iff`: a kind rises exactly where its members' mean offspring exceeds the others'
  (`total kind · Σ w·other < total other · Σ w·kind`), a corollary of `SelectionTerm.exceeds_iff`
  read on the kind's indicator; `kind_not_rises_of_below`, `kind_not_rises_of_bound` are its
  corollaries.
- `answering_rises_iff`: the exact condition, in counts, for answering to rise over `1 + d` steps
  in a cohort of `x` answerer pairs, `y` mixed pairs and `z` withholder pairs (`cohort x y z`),
  read through the mean law `kind_rises_iff`.
- `pairs_rises_iff`: wrapper, `SelectionLevels.rises_iff_sized` with groups of two, the four-term
  law restated for any family listed by pairs; none of its four terms is evaluated on
  `cohort x y z` here.
- `among_discord_witness`: among-pair discordance can be positive, at one point (`a = 1`, `β = 1`,
  `γ = 3`, two steps).
- `mixed_exceeds_iff`: a mixed pair's sum exceeds an answerer pair's exactly where `β < γ`.
- `assorted_counts`: under complete assortment the pairs' offspring are the rule after shaping,
  `shaped a (β · n) 0 (γ · n)`. Its corollaries, `RuleShaping`'s laws with the factor `n`
  cancelled (`n > 0`): `assorted_favours_iff` (weakly favoured exactly where `γ ≤ β`),
  `assorted_raises_iff` (raised strictly exactly where `γ < β`), `assorted_disfavours_iff` (weakly
  disfavoured exactly where `β ≤ γ`), `assorted_lowers_iff` (lowered strictly exactly where
  `β < γ`), `assorted_neutral` (at `γ = β` the share is left as it is).

## EL4b (c): with `β ≤ γ`, no kind rises against withholders

(`β ≤ γ` read as giving moving what it draws is an AI reading.)

- `pair_le`: with `β ≤ γ`, for any laws and errors, a pair leaves at most `2 · (a + γ · n)`
  (at each step the other place either gives, and this place receives, or withholds:
  `received_add_withheld`).
- `Place.answerer_le`, `Place.withholder_ge`: with `β ≤ γ`, an answerer without errors of its own
  leaves at most `a + γ · n`, a withholder at least that.
- `answering_never_rises`: with `β ≤ γ`, where every answerer has no errors of its own (its partner
  may hold any law and err) and every other place withholds, answering does not rise.
- `never_rises_in_pairs`: with `β ≤ γ`, in any cohort listed as pairs `[s, s.other]` whose places
  not of the kind withhold, the kind does not rise, whatever laws it holds and whatever the errors;
  answering is one case. This is the law with errors: the member-by-member law fails with errors,
  the law on pairs does not.
- Witnesses: `cohort_never_rises` (the hypotheses of `answering_never_rises` hold together),
  `erring_answerer_exceeds` (an answerer erring at every step beside an answerer leaves `β` more
  than a withholder beside a withholder: the member-by-member law fails with errors),
  `erring_cohort_never_rises` (the hypotheses of `never_rises_in_pairs` hold together with errors).

## EL4b (d): the window against answering

- `alternator_beside_window`: an alternator beside a window holder leaves `γ · half (n + 1)`
  (`γ · ⌈n/2⌉`) more than a window holder beside a window holder; `window_beside_alternator`: a
  window holder beside an alternator leaves `β · half (n + 1)` less than beside a window holder;
  `window_below_alternator`: in that mixed pair the window holder leaves `(β + γ) · half (n + 1)`
  less than the alternator; `withholder_beside_window`: a withholder beside a window holder leaves
  `β` more than beside an answerer.
- `echo_and_window_sums`: with one error by the first at step `t`, over `t + (m + 1)` steps, an
  answerer pair receives `t + t + (m + 1)` and withholds `m + 1`, a window pair receives
  `t + t + (m + m + 1)` and withholds `1`; so the echo moves `m` steps from receiving to withholding,
  `(β - γ) · m` in offspring.
- `window_echo_lt_iff`: so, on the pairs' offspring (`windowErrAt t`, `answerErrAt t`), for
  `m > 0`, a window pair leaves strictly more than an answerer pair exactly where `γ < β` and
  strictly less exactly where `β < γ`, for any `a`.
- `window_echo_shaped`: under complete assortment, with one error a pair, window pairs and answerer
  pairs are the carrier and the other of `shaped (2a + β(2t + m + 1) + γ) (β m) 0 (γ m)`;
  `window_echo_favours_iff` (wrapper of `assorted_favours_iff`): for `m > 0` windowed waiting is
  weakly favoured exactly where `γ ≤ β`; `window_echo_select_iff` (wrapper of `assorted_raises_iff`
  and `assorted_lowers_iff`): selection raises the window pairs' share strictly exactly where
  `γ < β`, and lowers it strictly, the echo selected for, exactly where `β < γ`.
- `window_never_rises_beside_alternators`: in mixed pairs of window holders and alternators the
  window never rises, for any `β`, `γ`.
- `window_alternator_shaped`, `window_alternator_favours_iff` (a corollary): under complete
  assortment, window pairs against alternator pairs are weakly favoured exactly where `γ ≤ β`.

## EL4b (e): neutrality without withholding

- `neutral`: where every place's laws give after mutual giving and none errs, every place leaves
  `a + β · n`, so concordance and discordance are both `0` for any amount: no selection.

## EL4c: where what a gift brings comes from

- Need asymmetry within the pair (`Needs`): a balanced pair into which nothing flows
  (`Needs.closed`: inflow `0` at every step), the giver at level `2` moving one unit to the
  receiver at level `1` across step `0`; the giver takes part at every step, and across step `1`,
  where it is active, gives a child one unit drawn from a pool beyond the pair. `asymmetry_gains`:
  with needs one and two the receiver becomes supported and the giver stays supported (supported
  members of the pair go from one to two). `symmetry_moves`: with needs two and two the same move
  only moves support. `childless`: the giver is present at every step after its gift; under needs
  two and two it is unsupported there and so leaves no descendant across any of them
  (`Flow.unsupported_childless`), while under needs one and two the child descends from it across
  step `1`. `symmetric_breaks`: read with the receiver as the family and the giver as the beyond,
  the rise under needs two and two breaks the giver's dependence
  (`Flow.Balances.breaks_beyond_inflow`). `asymmetric_within_slack`: with needs one and two the
  rise is exactly the giver's slack above its need, with nothing flowing in, and the giver's
  dependence kept. So need asymmetry is the slack bound read with the pair split into family
  (the receiver) and beyond (the giver).
- Renewal from outside (`Renewed`): a renewer whose giving does not require its own level
  (`renewer_free`) gives the giver one unit a step, and the giver gives the receiver one unit a step.
  `renewal_carried`: the giver gives at every step, both stay supported, the giver's level never
  falls, and over any `N` steps the gifts total `N`, the inflow into the pair (`inflow_one`).
- A factor read on a web, bounded by it: `rise_le_slack_inflow` (the contrapositive of
  `Flow.Balances.breaks_beyond_inflow`: without a break beyond, a family's rise across a step, with
  what the whole loses, is at most the slack beyond and the inflow). `Place.received_factor_le`:
  where, at each step the other place gives, a line on a balanced web rises by `β` with no
  dependence beyond broken, `β · received` is at most the slack beyond and the inflow summed over
  those steps; `Place.withheld_factor_le` the same for `γ` at the withheld steps;
  `Place.received_factor_zero` (a corollary): where at those steps the beyond stands at its needs
  and nothing flows in, a place that received has `β = 0`. The reading (the line's rise per step
  as the factor) is a hypothesis of these laws: no statement here makes the pair's run a flow on a
  web or derives `Place.offspring` from one, so neither factor is bounded for the formula itself,
  and no web statement compares `β` with `γ`.

(AI reading.) `β` is what a received step brings the receiver's support and descent, `γ` what a
withheld step keeps for the withholder's, so what a giving takes from the giver; `β ≤ γ` reads as
giving moving what it draws. The laws of (c) say that where giving moves what it draws (`β ≤ γ`) no kind
rises against withholders, and the laws of (b) and (d) that under complete assortment waiting on
giving (answering, the window) is weakly favoured exactly where `γ ≤ β`. EL4c's witnesses show, on
webs, a receiver's rise covered by the giver's slack (`Needs`) and a gift carried by an inflow
(`Renewed`); read as the rise of a line on a web, a factor is bounded by the slack beyond and the
inflow (`Place.received_factor_le`), so that a positive `β` so read without a break beyond comes
from one of these two. The join of the witnesses to the formula's `β` and `γ` is not shown.

## Modelling choices

Steps are discrete and natural-numbered; giving and errors are decided `Bool`s (bridged to
`Prop` only for `windowed_course`); each run starts from a history of mutual giving; an error turns
an intended giving into withholding at that step, and nothing else. The pairing is supplied
(`Place.other`, a cohort listed as pairs), not formed. Offspring `a + β·R + γ·K` are a supplied
formula with natural factors; that a formation is supported over the run is a premise of the
reading, not checked here (only EL4c's webs check support). Generations are read one at a time:
no law here is of a course of generations. The EL4c webs are single small witnesses with constant
or few-valued levels, not general laws of renewal or need; in `Needs` the child's unit comes from a
pool beyond the pair, so the descent at needs one and two shows only that the giver's support
decides whether it can give, not that the pair supplies the unit.

## Lemmas, wrappers, corollaries and checks

Lemmas: `course_of`, `gives_of`, `counts_of`, the `tally_*` and `half_*` lemmas, `before_*`,
`below`, `after`, `fromOne`, `fromTwo`, `skipsOne`, `time`, `gives_answering_*`,
`gives_withholding_*`, `rearrange`, `lt_iff_split`, `cases_tt` … `cases_ff`, `mem_whole`,
`total_replicate`, `mem_replicate_eq`, `cohort_*`, `total_cohort`, `offspring_*`, `pair_sum`,
`window_arith`, `echo_pair_sums`, `half_succ_pos`, `Needs.receiver_unsupported`,
`Needs.receiver_supported`, `Renewed.total_steps_one`, `tallyBy`, `mul_tally_le`, `tallyBy_zero`.
Wrappers: `pairs_rises_iff`, `window_echo_favours_iff`, `window_echo_select_iff`. Corollaries of
landed laws with a factor cancelled or read on an indicator: `kind_rises_iff`,
`kind_not_rises_of_below`, `kind_not_rises_of_bound`, `assorted_favours_iff`,
`assorted_raises_iff`, `assorted_disfavours_iff`, `assorted_lowers_iff`, `assorted_neutral`,
`window_alternator_favours_iff`, `rise_le_slack_inflow`, `Place.received_factor_zero`,
`window_echo_lt_iff` (of `echo_and_window_sums`). Bounds under a supplied reading, not results:
`Place.received_factor_le`, `Place.withheld_factor_le`. Checks by
evaluation: `table_twenty`, `error_table_twenty`, `among_discord_witness`. The results are the
counts and their shaped identities (`counts_*`, `meets_after`, `counts_after`, `windowed_course`,
`counts_windowed_spaced`, `assorted_counts`, `echo_and_window_sums`, `window_echo_shaped`,
`window_alternator_shaped`, `mixed_exceeds_iff`, the `beside` laws), the
laws that a kind never rises (`pair_le`, `answering_never_rises`, `never_rises_in_pairs`,
`window_never_rises_beside_alternators`), `neutral` and the EL4c witnesses.

## Not shown here

Agreement against the alternator for general `n` (only at `n = 20`, by `table_twenty`); one error
for the sparer, the withholder and the alternator for general `n` and `t` (only at `n = 20`, by
`error_table_twenty`); the exact iff for a mixed cohort of windows, answerers, withholders and
alternators under a supplied error pattern beyond `kind_rises_iff`; the four terms of
`pairs_rises_iff` in closed form on `cohort x y z`; that a gift brings more than it draws only by
carrying a flux in (only the renewal witness); a model of the pair's run as a flow on a web, from
which `Place.offspring`'s factors would follow, and any comparison of `β` with `γ` from a web;
`SelectionPace.selection_within_carried` applied to these runs; any law over a horizon of
generations.
-/

namespace Becoming
namespace PairSelection

open WindowedWaiting WindowedWaiting.Pair SelectionTerm SelectionLevels

/-! ## The pair's run -/

/-- A formation's last two steps: the last, then the one before. -/
abbrev Lags := Bool × Bool

/-- A law of giving in a pair, reading its own last two steps and its partner's. -/
abbrev PairLaw := Lags → Lags → Bool

/-- Errors: at each step, the formations whose intended giving turns into withholding. -/
abbrev Errors := Nat → Pair → Bool

/-- No errors. -/
def noErrors : Errors := fun _ _ => false

/-- One error, by the first formation, at step `t`. -/
def errAt (t : Nat) : Errors
  | s, first => Nat.beq s t
  | _, second => false

/-- The state of a pair's run: the step, and each formation's last two steps. -/
abbrev State := Nat × Lags × Lags

/-- Step `0`, after a history of mutual giving. -/
def start (f g : PairLaw) (e : Errors) : State :=
  (0, (f (true, true) (true, true) && !e 0 first, true),
    (g (true, true) (true, true) && !e 0 second, true))

/-- The step: each formation gives by its law, unless it errs at the next step. -/
def step (f g : PairLaw) (e : Errors) (x : State) : State :=
  (x.1 + 1, (f x.2.1 x.2.2 && !e (x.1 + 1) first, x.2.1.1),
    (g x.2.2 x.2.1 && !e (x.1 + 1) second, x.2.2.1))

/-- The pair's run: the first holds `f`, the second `g`. -/
def course (f g : PairLaw) (e : Errors) : Run (Law.process (step f g e)) :=
  Law.run (step f g e) (start f g e)

/-- Whether a formation gives at step `n`. -/
def gives (f g : PairLaw) (e : Errors) : Pair → Nat → Bool
  | first, n => ((course f g e).state n).2.1.1
  | second, n => ((course f g e).state n).2.2.1

/-- The step before, with mutual giving before step `0`. -/
def before (P : Nat → Bool) : Nat → Bool
  | 0 => true
  | n + 1 => P n

/-- **A course read from its closed form.** Where two courses of giving `P` and `Q` meet the
laws at step `0` and at every later step, they are the run's. -/
theorem course_of {f g : PairLaw} {e : Errors} {P Q : Nat → Bool}
    (zero_f : (f (true, true) (true, true) && !e 0 first) = P 0)
    (zero_g : (g (true, true) (true, true) && !e 0 second) = Q 0)
    (succ_f : ∀ n, (f (P n, before P n) (Q n, before Q n) && !e (n + 1) first) = P (n + 1))
    (succ_g : ∀ n, (g (Q n, before Q n) (P n, before P n) && !e (n + 1) second) = Q (n + 1)) :
    ∀ n, (course f g e).state n = (n, (P n, before P n), (Q n, before Q n))
  | 0 => by
    show (0, (f (true, true) (true, true) && !e 0 first, true),
      (g (true, true) (true, true) && !e 0 second, true)) = _
    rw [zero_f, zero_g]
    rfl
  | n + 1 => by
    show step f g e ((course f g e).state n) = _
    rw [course_of zero_f zero_g succ_f succ_g n]
    show (n + 1, (f (P n, before P n) (Q n, before Q n) && !e (n + 1) first, P n),
      (g (Q n, before Q n) (P n, before P n) && !e (n + 1) second, Q n)) = _
    rw [succ_f n, succ_g n]
    rfl

theorem gives_of {f g : PairLaw} {e : Errors} {P Q : Nat → Bool}
    (zero_f : (f (true, true) (true, true) && !e 0 first) = P 0)
    (zero_g : (g (true, true) (true, true) && !e 0 second) = Q 0)
    (succ_f : ∀ n, (f (P n, before P n) (Q n, before Q n) && !e (n + 1) first) = P (n + 1))
    (succ_g : ∀ n, (g (Q n, before Q n) (P n, before P n) && !e (n + 1) second) = Q (n + 1)) :
    ∀ n, gives f g e first n = P n ∧ gives f g e second n = Q n := fun n =>
  have h := course_of zero_f zero_g succ_f succ_g n
  ⟨congrArg (fun x : State => x.2.1.1) h, congrArg (fun x : State => x.2.2.1) h⟩

/-! ## Counts -/

/-- The number of steps below `n` at which `p` holds. -/
def tally (p : Nat → Bool) : Nat → Nat
  | 0 => 0
  | n + 1 => tally p n + cond (p n) 1 0

/-- What a formation received: the steps below `n` at which its partner gave. -/
def received (f g : PairLaw) (e : Errors) (a : Pair) (n : Nat) : Nat :=
  tally (gives f g e (partner a)) n

/-- What a formation withheld: the steps below `n` at which it withheld. -/
def withheld (f g : PairLaw) (e : Errors) (a : Pair) (n : Nat) : Nat :=
  tally (fun t => !gives f g e a t) n

theorem tally_congr {p q : Nat → Bool} (same : ∀ t, p t = q t) : ∀ n, tally p n = tally q n
  | 0 => rfl
  | n + 1 => by
    show tally p n + cond (p n) 1 0 = tally q n + cond (q n) 1 0
    rw [tally_congr same n, same n]

theorem tally_true {p : Nat → Bool} (all : ∀ t, p t = true) : ∀ n, tally p n = n
  | 0 => rfl
  | n + 1 => by
    show tally p n + cond (p n) 1 0 = n + 1
    rw [tally_true all n, all n]
    rfl

theorem tally_false {p : Nat → Bool} (none : ∀ t, p t = false) : ∀ n, tally p n = 0
  | 0 => rfl
  | n + 1 => by
    show tally p n + cond (p n) 1 0 = 0
    rw [tally_false none n, none n]
    rfl

/-- The first step counted apart. -/
theorem tally_head (p : Nat → Bool) : ∀ n, tally p (n + 1) = cond (p 0) 1 0 + tally (fun t => p (t + 1)) n
  | 0 => (Nat.zero_add _).trans (Nat.add_zero _).symm
  | n + 1 => by
    show tally p (n + 1) + cond (p (n + 1)) 1 0 =
      cond (p 0) 1 0 + (tally (fun t => p (t + 1)) n + cond (p (n + 1)) 1 0)
    rw [tally_head p n, Nat.add_assoc]

/-- A step and its negation together count every step. -/
theorem tally_not (p : Nat → Bool) : ∀ n, tally p n + tally (fun t => !p t) n = n
  | 0 => rfl
  | n + 1 => by
    show tally p n + cond (p n) 1 0 + (tally (fun t => !p t) n + cond (!p n) 1 0) = n + 1
    have h := tally_not p n
    cases p n with
    | true =>
      show tally p n + 1 + tally (fun t => !p t) n = n + 1
      rw [Nat.add_right_comm, h]
    | false =>
      show tally p n + (tally (fun t => !p t) n + 1) = n + 1
      rw [← Nat.add_assoc, h]

/-- Halves, rounded down, by recursion. -/
def half : Nat → Nat
  | 0 => 0
  | 1 => 0
  | n + 2 => half n + 1

/-- **The odd steps below `n` are `half n`.** -/
theorem tally_odd : ∀ n, tally (fun t => !even t) n = half n
  | 0 => rfl
  | 1 => rfl
  | n + 2 => by
    show tally (fun t => !even t) n + cond (!even n) 1 0 + cond (!even (n + 1)) 1 0 = half n + 1
    rw [tally_odd n]
    show half n + cond (!even n) 1 0 + cond (!(!even n)) 1 0 = half n + 1
    cases even n <;> rfl

/-- **The even steps below `n` are `half (n + 1)`.** -/
theorem tally_even : ∀ n, tally even n = half (n + 1)
  | 0 => rfl
  | 1 => rfl
  | n + 2 => by
    show tally even n + cond (even n) 1 0 + cond (even (n + 1)) 1 0 = half (n + 1) + 1
    rw [tally_even n]
    show half (n + 1) + cond (even n) 1 0 + cond (!even n) 1 0 = half (n + 1) + 1
    cases even n <;> rfl

/-! ## The laws -/

/-- Giving whatever comes. -/
def sparing : PairLaw := fun _ _ => true

/-- Answering the partner's last step. -/
def answering : PairLaw := fun _ partner => partner.1

/-- Answering within a window of two: giving where the partner gave at one of its last two
steps. -/
def windowed : PairLaw := fun _ partner => windowTwo partner.1 partner.2

/-- Agreement of one's own last step with the partner's. -/
def agreeing : PairLaw := fun own partner => own.1 == partner.1

/-- Giving where both gave at the last step: waiting on the partner and on oneself. -/
def waitingBoth : PairLaw := fun own partner => own.1 && partner.1

/-- Withholding at every step. -/
def withholding : PairLaw := fun _ _ => false

/-- Giving exactly where one withheld at the last step. -/
def alternating : PairLaw := fun own _ => !own.1

theorem keep : ∀ b : Bool, (b && !false) = b
  | true => rfl
  | false => rfl

/-- The seven laws, in the order of the table. -/
def laws : List PairLaw :=
  [sparing, answering, windowed, agreeing, waitingBoth, withholding, alternating]

/-- Each formation's `(received, withheld)` over `n` steps, the row's against the column's, with
no errors. -/
def countsTable (n : Nat) : List (List (Nat × Nat)) :=
  laws.map fun f => laws.map fun g => (received f g noErrors first n, withheld f g noErrors first n)

theorem table_twenty : countsTable 20 =
    [[(20, 0), (20, 0), (20, 0), (20, 0), (20, 0), (0, 0), (10, 0)],
     [(20, 0), (20, 0), (20, 0), (20, 0), (20, 0), (0, 19), (10, 10)],
     [(20, 0), (20, 0), (20, 0), (20, 0), (20, 0), (0, 18), (10, 0)],
     [(20, 0), (20, 0), (20, 0), (20, 0), (20, 0), (0, 10), (10, 10)],
     [(20, 0), (20, 0), (20, 0), (20, 0), (20, 0), (0, 19), (10, 19)],
     [(20, 20), (1, 20), (2, 20), (10, 20), (1, 20), (0, 20), (10, 20)],
     [(20, 10), (10, 10), (20, 10), (10, 10), (1, 10), (0, 10), (10, 10)]] := rfl

/-- The error table: with one error by the first formation at step `t`, between two holders of
each law, `((received, withheld) of the erring formation, (received, withheld) of its partner)`. -/
def errorTable (n t : Nat) : List ((Nat × Nat) × (Nat × Nat)) :=
  laws.map fun f => ((received f f (errAt t) first n, withheld f f (errAt t) first n),
    (received f f (errAt t) second n, withheld f f (errAt t) second n))

theorem error_table_twenty : errorTable 20 5 =
    [((20, 1), (19, 0)), ((13, 8), (12, 7)), ((20, 1), (19, 0)), ((19, 2), (18, 1)),
     ((6, 15), (5, 14)), ((0, 20), (0, 20)), ((10, 11), (9, 10))] := rfl

/-! ## Counting closed forms -/

/-- Giving exactly at the steps below `k`. -/
def below : Nat → Nat → Bool
  | 0, _ => false
  | _ + 1, 0 => true
  | k + 1, n + 1 => below k n

theorem tally_below : ∀ k d, tally (below k) (k + d) = k
  | 0, d => tally_false (fun _ => rfl) (0 + d)
  | k + 1, d => by
    rw [Nat.add_right_comm, tally_head]
    show 1 + tally (fun t => below k t) (k + d) = k + 1
    rw [tally_below k d, Nat.add_comm]

/-- Read the count of the negation from the count. -/
theorem tally_not_of {p : Nat → Bool} {n c d : Nat} (count : tally p n = c) (whole : n = c + d) :
    tally (fun t => !p t) n = d :=
  Naturals.add_left_cancel ((congrArg (· + tally (fun t => !p t) n) count).symm.trans
    ((tally_not p n).trans whole))

theorem tally_not_below (k d : Nat) : tally (fun t => !below k t) (k + d) = d :=
  tally_not_of (tally_below k d) rfl

theorem not_not_tally (p : Nat → Bool) (n : Nat) : tally (fun t => !!p t) n = tally p n :=
  tally_congr (fun t => by cases p t <;> rfl) n

theorem before_true : ∀ n, before (fun _ => true) n = true
  | 0 => rfl
  | _ + 1 => rfl

/-! ## The counts, as theorems of the runs -/

/-- **Between laws giving after mutual giving, with no errors, every formation receives at every
step and withholds at none.** -/
theorem counts_giving {f g : PairLaw} (hf : f (true, true) (true, true) = true)
    (hg : g (true, true) (true, true) = true) (a : Pair) (n : Nat) :
    received f g noErrors a n = n ∧ withheld f g noErrors a n = 0 :=
  have course := gives_of (f := f) (g := g) (e := noErrors) (P := fun _ => true) (Q := fun _ => true)
    ((keep _).trans hf) ((keep _).trans hg)
    (fun n => (keep _).trans (by rw [before_true n]; exact hf))
    (fun n => (keep _).trans (by rw [before_true n]; exact hg))
  have all : ∀ b t, gives f g noErrors b t = true := fun b t => match b with
    | first => (course t).1
    | second => (course t).2
  ⟨tally_true (all _) n, tally_false (fun t => by rw [all a t]; rfl) n⟩

/-- The counts read from a course of giving. -/
theorem counts_of {f g : PairLaw} {e : Errors} {P Q : Nat → Bool}
    (c : ∀ n, gives f g e first n = P n ∧ gives f g e second n = Q n) (n : Nat) :
    received f g e first n = tally Q n ∧ withheld f g e first n = tally (fun t => !P t) n ∧
      received f g e second n = tally P n ∧ withheld f g e second n = tally (fun t => !Q t) n :=
  ⟨tally_congr (fun t => (c t).2) n, tally_congr (fun t => congrArg (!·) (c t).1) n,
   tally_congr (fun t => (c t).1) n, tally_congr (fun t => congrArg (!·) (c t).2) n⟩

theorem beq_false_eq : ∀ b : Bool, (b == false) = !b
  | true => rfl
  | false => rfl

theorem window_alternates : ∀ b : Bool, windowTwo (!!b) (!b) = true
  | true => rfl
  | false => rfl

theorem tally_zero (n : Nat) : tally (fun _ => false) n = 0 := tally_false (fun _ => rfl) n

theorem tally_all (n : Nat) : tally (fun _ => true) n = n := tally_true (fun _ => rfl) n

theorem tally_none (n : Nat) : tally (fun _ => !true) n = 0 := tally_false (fun _ => rfl) n

theorem tally_every (n : Nat) : tally (fun _ => !false) n = n := tally_true (fun _ => rfl) n

/-! ### Against a constant withholder -/

/-- **Giving whatever comes, against a withholder**: it receives nothing and withholds nothing;
the withholder receives at every step and withholds at every step. -/
theorem counts_sparing_withholding (n : Nat) :
    received sparing withholding noErrors first n = 0 ∧
      withheld sparing withholding noErrors first n = 0 ∧
      received sparing withholding noErrors second n = n ∧
      withheld sparing withholding noErrors second n = n :=
  have h := counts_of (gives_of (f := sparing) (g := withholding) (e := noErrors)
    (P := fun _ => true) (Q := fun _ => false) rfl rfl (fun _ => rfl) (fun _ => rfl)) n
  ⟨h.1.trans (tally_zero n), h.2.1.trans (tally_none n), h.2.2.1.trans (tally_all n),
   h.2.2.2.trans (tally_every n)⟩

/-- **Answering, against a withholder**: from mutual giving before step `0`, the answerer gives at
step `0` only, so over `1 + d` steps it withholds at `d`; the withholder receives once. -/
theorem counts_answering_withholding (d : Nat) :
    received answering withholding noErrors first (1 + d) = 0 ∧
      withheld answering withholding noErrors first (1 + d) = d ∧
      received answering withholding noErrors second (1 + d) = 1 ∧
      withheld answering withholding noErrors second (1 + d) = 1 + d :=
  have h := counts_of (gives_of (f := answering) (g := withholding) (e := noErrors)
    (P := below 1) (Q := fun _ => false) rfl rfl (fun _ => rfl) (fun _ => rfl)) (1 + d)
  ⟨h.1.trans (tally_zero _), h.2.1.trans (tally_not_below 1 d), h.2.2.1.trans (tally_below 1 d),
   h.2.2.2.trans (tally_every _)⟩

/-- **The window of two, against a withholder**: it gives at steps `0` and `1`, so over `2 + d`
steps it withholds at `d`; the withholder receives twice, once more than from an answerer. -/
theorem counts_windowed_withholding (d : Nat) :
    received windowed withholding noErrors first (2 + d) = 0 ∧
      withheld windowed withholding noErrors first (2 + d) = d ∧
      received windowed withholding noErrors second (2 + d) = 2 ∧
      withheld windowed withholding noErrors second (2 + d) = 2 + d :=
  have h := counts_of (gives_of (f := windowed) (g := withholding) (e := noErrors)
    (P := below 2) (Q := fun _ => false) rfl rfl
    (fun n => match n with | 0 => rfl | _ + 1 => rfl) (fun _ => rfl)) (2 + d)
  ⟨h.1.trans (tally_zero _), h.2.1.trans (tally_not_below 2 d), h.2.2.1.trans (tally_below 2 d),
   h.2.2.2.trans (tally_every _)⟩

/-- **Agreement, against a withholder**: it gives at every even step, so over `n` steps it
withholds at `half n` and the withholder receives `half (n + 1)`. -/
theorem counts_agreeing_withholding (n : Nat) :
    received agreeing withholding noErrors first n = 0 ∧
      withheld agreeing withholding noErrors first n = half n ∧
      received agreeing withholding noErrors second n = half (n + 1) ∧
      withheld agreeing withholding noErrors second n = n :=
  have h := counts_of (gives_of (f := agreeing) (g := withholding) (e := noErrors)
    (P := even) (Q := fun _ => false) rfl rfl
    (fun n => (keep _).trans (beq_false_eq (even n))) (fun _ => rfl)) n
  ⟨h.1.trans (tally_zero n), h.2.1.trans (tally_odd n), h.2.2.1.trans (tally_even n),
   h.2.2.2.trans (tally_every n)⟩

/-- **Waiting on both, against a withholder**: as answering, it gives at step `0` only. -/
theorem counts_waitingBoth_withholding (d : Nat) :
    received waitingBoth withholding noErrors first (1 + d) = 0 ∧
      withheld waitingBoth withholding noErrors first (1 + d) = d ∧
      received waitingBoth withholding noErrors second (1 + d) = 1 ∧
      withheld waitingBoth withholding noErrors second (1 + d) = 1 + d :=
  have h := counts_of (gives_of (f := waitingBoth) (g := withholding) (e := noErrors)
    (P := below 1) (Q := fun _ => false) rfl rfl
    (fun n => match n with | 0 => rfl | _ + 1 => rfl) (fun _ => rfl)) (1 + d)
  ⟨h.1.trans (tally_zero _), h.2.1.trans (tally_not_below 1 d), h.2.2.1.trans (tally_below 1 d),
   h.2.2.2.trans (tally_every _)⟩

/-- **Two withholders**: each receives nothing and withholds at every step. -/
theorem counts_withholding_withholding (n : Nat) :
    received withholding withholding noErrors first n = 0 ∧
      withheld withholding withholding noErrors first n = n ∧
      received withholding withholding noErrors second n = 0 ∧
      withheld withholding withholding noErrors second n = n :=
  have h := counts_of (gives_of (f := withholding) (g := withholding) (e := noErrors)
    (P := fun _ => false) (Q := fun _ => false) rfl rfl (fun _ => rfl) (fun _ => rfl)) n
  ⟨h.1.trans (tally_zero n), h.2.1.trans (tally_every n), h.2.2.1.trans (tally_zero n),
   h.2.2.2.trans (tally_every n)⟩

/-- **The alternator, against a withholder**: it gives at every odd step. -/
theorem counts_alternating_withholding (n : Nat) :
    received alternating withholding noErrors first n = 0 ∧
      withheld alternating withholding noErrors first n = half (n + 1) ∧
      received alternating withholding noErrors second n = half n ∧
      withheld alternating withholding noErrors second n = n :=
  have h := counts_of (gives_of (f := alternating) (g := withholding) (e := noErrors)
    (P := fun t => !even t) (Q := fun _ => false) rfl rfl (fun _ => keep _) (fun _ => rfl)) n
  ⟨h.1.trans (tally_zero n), h.2.1.trans ((not_not_tally even n).trans (tally_even n)),
   h.2.2.1.trans (tally_odd n), h.2.2.2.trans (tally_every n)⟩

/-! ### Against the alternator -/

/-- **Giving whatever comes, beside the alternator**: it receives at every odd step. -/
theorem counts_sparing_alternating (n : Nat) :
    received sparing alternating noErrors first n = half n ∧
      withheld sparing alternating noErrors first n = 0 ∧
      received sparing alternating noErrors second n = n ∧
      withheld sparing alternating noErrors second n = half (n + 1) :=
  have h := counts_of (gives_of (f := sparing) (g := alternating) (e := noErrors)
    (P := fun _ => true) (Q := fun t => !even t) rfl rfl (fun _ => rfl) (fun _ => keep _)) n
  ⟨h.1.trans (tally_odd n), h.2.1.trans (tally_none n), h.2.2.1.trans (tally_all n),
   h.2.2.2.trans ((not_not_tally even n).trans (tally_even n))⟩

/-- **Answering, beside the alternator**: the answerer gives at every even step and the
alternator at every odd one, so neither ever gives at the step the other does. -/
theorem counts_answering_alternating (n : Nat) :
    received answering alternating noErrors first n = half n ∧
      withheld answering alternating noErrors first n = half n ∧
      received answering alternating noErrors second n = half (n + 1) ∧
      withheld answering alternating noErrors second n = half (n + 1) :=
  have h := counts_of (gives_of (f := answering) (g := alternating) (e := noErrors)
    (P := even) (Q := fun t => !even t) rfl rfl (fun _ => keep _) (fun _ => keep _)) n
  ⟨h.1.trans (tally_odd n), h.2.1.trans (tally_odd n), h.2.2.1.trans (tally_even n),
   h.2.2.2.trans ((not_not_tally even n).trans (tally_even n))⟩

/-- **The window of two, beside the alternator**: the holder gives at every step, so the
alternator receives at every step and withholds at every even one. -/
theorem counts_windowed_alternating (n : Nat) :
    received windowed alternating noErrors first n = half n ∧
      withheld windowed alternating noErrors first n = 0 ∧
      received windowed alternating noErrors second n = n ∧
      withheld windowed alternating noErrors second n = half (n + 1) :=
  have h := counts_of (gives_of (f := windowed) (g := alternating) (e := noErrors)
    (P := fun _ => true) (Q := fun t => !even t) rfl rfl
    (fun n => (keep _).trans (match n with | 0 => rfl | m + 1 => window_alternates (even m)))
    (fun _ => keep _)) n
  ⟨h.1.trans (tally_odd n), h.2.1.trans (tally_none n), h.2.2.1.trans (tally_all n),
   h.2.2.2.trans ((not_not_tally even n).trans (tally_even n))⟩

/-- **Waiting on both, beside the alternator**: it gives at step `0` only. -/
theorem counts_waitingBoth_alternating (d : Nat) :
    received waitingBoth alternating noErrors first (1 + d) = half (1 + d) ∧
      withheld waitingBoth alternating noErrors first (1 + d) = d ∧
      received waitingBoth alternating noErrors second (1 + d) = 1 ∧
      withheld waitingBoth alternating noErrors second (1 + d) = half (1 + d + 1) :=
  have h := counts_of (gives_of (f := waitingBoth) (g := alternating) (e := noErrors)
    (P := below 1) (Q := fun t => !even t) rfl rfl
    (fun n => match n with | 0 => rfl | _ + 1 => rfl) (fun _ => keep _)) (1 + d)
  ⟨h.1.trans (tally_odd _), h.2.1.trans (tally_not_below 1 d), h.2.2.1.trans (tally_below 1 d),
   h.2.2.2.trans ((not_not_tally even _).trans (tally_even _))⟩

/-- **Two alternators**, in step: each gives at every odd step. -/
theorem counts_alternating_alternating (n : Nat) :
    received alternating alternating noErrors first n = half n ∧
      withheld alternating alternating noErrors first n = half (n + 1) ∧
      received alternating alternating noErrors second n = half n ∧
      withheld alternating alternating noErrors second n = half (n + 1) :=
  have h := counts_of (gives_of (f := alternating) (g := alternating) (e := noErrors)
    (P := fun t => !even t) (Q := fun t => !even t) rfl rfl (fun _ => keep _) (fun _ => keep _)) n
  ⟨h.1.trans (tally_odd n), h.2.1.trans ((not_not_tally even n).trans (tally_even n)),
   h.2.2.1.trans (tally_odd n), h.2.2.2.trans ((not_not_tally even n).trans (tally_even n))⟩

/-- **A withholder beside the alternator.** -/
theorem counts_withholding_alternating (n : Nat) :
    received withholding alternating noErrors first n = half n ∧
      withheld withholding alternating noErrors first n = n ∧
      received withholding alternating noErrors second n = 0 ∧
      withheld withholding alternating noErrors second n = half (n + 1) :=
  have h := counts_of (gives_of (f := withholding) (g := alternating) (e := noErrors)
    (P := fun _ => false) (Q := fun t => !even t) rfl rfl (fun _ => rfl) (fun _ => keep _)) n
  ⟨h.1.trans (tally_odd n), h.2.1.trans (tally_every n), h.2.2.1.trans (tally_zero n),
   h.2.2.2.trans ((not_not_tally even n).trans (tally_even n))⟩

/-! ### One error -/

/-- Giving at every step below `t`, then as `h` from step `t`. -/
def after : Nat → (Nat → Bool) → Nat → Bool
  | 0, h, n => h n
  | _ + 1, _, 0 => true
  | t + 1, h, n + 1 => after t h n

/-- The four conditions of `course_of`. -/
def Meets (f g : PairLaw) (e : Errors) (P Q : Nat → Bool) : Prop :=
  (f (true, true) (true, true) && !e 0 first) = P 0 ∧
    (g (true, true) (true, true) && !e 0 second) = Q 0 ∧
    (∀ n, (f (P n, before P n) (Q n, before Q n) && !e (n + 1) first) = P (n + 1)) ∧
    (∀ n, (g (Q n, before Q n) (P n, before P n) && !e (n + 1) second) = Q (n + 1))

theorem before_after (t : Nat) (h : Nat → Bool) : ∀ m,
    before (after (t + 1) h) (m + 1) = before (after t h) m
  | 0 => rfl
  | _ + 1 => rfl

/-- **An error later is the same error, after mutual giving.** Between laws giving after mutual
giving, the course with one error by the first at step `t` is the course with it at step `0`,
delayed by `t` steps of mutual giving. -/
theorem meets_after {f g : PairLaw} (hf : f (true, true) (true, true) = true)
    (hg : g (true, true) (true, true) = true) {h k : Nat → Bool}
    (zero : Meets f g (errAt 0) h k) : ∀ t, Meets f g (errAt t) (after t h) (after t k)
  | 0 => zero
  | t + 1 =>
    have m := meets_after hf hg zero t
    ⟨(keep _).trans hf, (keep _).trans hg,
     fun n => match n with
      | 0 => m.1
      | j + 1 => by
        show (f (after t h j, before (after (t + 1) h) (j + 1))
            (after t k j, before (after (t + 1) k) (j + 1)) && !errAt t (j + 1) first) =
          after t h (j + 1)
        rw [before_after, before_after]
        exact m.2.2.1 j,
     fun n => match n with
      | 0 => m.2.1
      | j + 1 => by
        show (g (after t k j, before (after (t + 1) k) (j + 1))
            (after t h j, before (after (t + 1) h) (j + 1)) && !errAt t (j + 1) second) =
          after t k (j + 1)
        rw [before_after, before_after]
        exact m.2.2.2 j⟩

theorem tally_after : ∀ (t : Nat) (h : Nat → Bool) (m : Nat), tally (after t h) (t + m) = t + tally h m
  | 0, h, m => (tally_congr (fun _ => rfl) (0 + m)).trans
      ((congrArg (tally h) (Nat.zero_add m)).trans (Nat.zero_add _).symm)
  | t + 1, h, m => by
    rw [Nat.add_right_comm, tally_head]
    show 1 + tally (fun n => after t h n) (t + m) = t + 1 + tally h m
    rw [tally_after t h m, Nat.add_comm 1, Nat.add_right_comm]

theorem tally_not_after : ∀ (t : Nat) (h : Nat → Bool) (m : Nat),
    tally (fun n => !after t h n) (t + m) = tally (fun n => !h n) m
  | 0, h, m => (tally_congr (fun _ => rfl) (0 + m)).trans
      (congrArg (tally fun n => !h n) (Nat.zero_add m))
  | t + 1, h, m => by
    rw [Nat.add_right_comm, tally_head]
    show 0 + tally (fun n => !after t h n) (t + m) = _
    rw [Nat.zero_add, tally_not_after t h m]

theorem counts_after {f g : PairLaw} (hf : f (true, true) (true, true) = true)
    (hg : g (true, true) (true, true) = true) {h k : Nat → Bool}
    (zero : Meets f g (errAt 0) h k) (t m : Nat) :
    received f g (errAt t) first (t + m) = t + tally k m ∧
      withheld f g (errAt t) first (t + m) = tally (fun n => !h n) m ∧
      received f g (errAt t) second (t + m) = t + tally h m ∧
      withheld f g (errAt t) second (t + m) = tally (fun n => !k n) m :=
  have M := meets_after hf hg zero t
  have c := counts_of (gives_of M.1 M.2.1 M.2.2.1 M.2.2.2) (t + m)
  ⟨c.1.trans (tally_after t k m), c.2.1.trans (tally_not_after t h m),
   c.2.2.1.trans (tally_after t h m), c.2.2.2.trans (tally_not_after t k m)⟩

/-- Withholding at step `0` only. -/
def fromOne : Nat → Bool
  | 0 => false
  | _ + 1 => true

theorem tally_fromOne (m : Nat) : tally fromOne (m + 1) = m :=
  (tally_head fromOne m).trans ((Nat.zero_add _).trans (tally_all m))

theorem tally_not_fromOne (m : Nat) : tally (fun n => !fromOne n) (m + 1) = 1 :=
  (tally_head _ m).trans (congrArg (1 + ·) (tally_none m))

/-- **The window of two absorbs one error**: over `t + (m + 1)` steps with one error by the first
at step `t`, the erring formation receives at every step and withholds once; its partner
receives at all steps but one and withholds at none. -/
theorem counts_windowed_error (t m : Nat) :
    received windowed windowed (errAt t) first (t + (m + 1)) = t + (m + 1) ∧
      withheld windowed windowed (errAt t) first (t + (m + 1)) = 1 ∧
      received windowed windowed (errAt t) second (t + (m + 1)) = t + m ∧
      withheld windowed windowed (errAt t) second (t + (m + 1)) = 0 :=
  have c := counts_after (h := fromOne) (k := fun _ => true) rfl rfl
    ⟨rfl, rfl, fun _ => rfl, fun n => match n with | 0 => rfl | _ + 1 => rfl⟩ t (m + 1)
  ⟨c.1.trans (congrArg (t + ·) (tally_all _)), c.2.1.trans (tally_not_fromOne m),
   c.2.2.1.trans (congrArg (t + ·) (tally_fromOne m)), c.2.2.2.trans (tally_none _)⟩

/-- **Echo under answering**: over `t + m` steps with one error by the first at step `t`, the
erring formation withholds at every even step from `t` and its partner at every odd one, so the
pair never gives together again. -/
theorem counts_answering_error (t m : Nat) :
    received answering answering (errAt t) first (t + m) = t + half (m + 1) ∧
      withheld answering answering (errAt t) first (t + m) = half (m + 1) ∧
      received answering answering (errAt t) second (t + m) = t + half m ∧
      withheld answering answering (errAt t) second (t + m) = half m :=
  have c := counts_after (h := fun n => !even n) (k := even) rfl rfl
    ⟨rfl, rfl, fun n => (keep (even n)).trans (show even n = !(!even n) by cases even n <;> rfl),
     fun n => keep (!even n)⟩ t m
  ⟨c.1.trans (congrArg (t + ·) (tally_even m)),
   c.2.1.trans ((not_not_tally even m).trans (tally_even m)),
   c.2.2.1.trans (congrArg (t + ·) (tally_odd m)), c.2.2.2.trans (tally_odd m)⟩

/-- **Waiting on both after one error**: the erring formation withholds from step `t` on and its
partner from step `t + 1` on. -/
theorem counts_waitingBoth_error (t m : Nat) :
    received waitingBoth waitingBoth (errAt t) first (t + (1 + m)) = t + 1 ∧
      withheld waitingBoth waitingBoth (errAt t) first (t + (1 + m)) = 1 + m ∧
      received waitingBoth waitingBoth (errAt t) second (t + (1 + m)) = t ∧
      withheld waitingBoth waitingBoth (errAt t) second (t + (1 + m)) = m :=
  have c := counts_after (h := fun _ => false) (k := below 1) rfl rfl
    ⟨rfl, rfl, fun _ => rfl, fun n => match n with | 0 => rfl | _ + 1 => rfl⟩ t (1 + m)
  ⟨c.1.trans (congrArg (t + ·) (tally_below 1 m)), c.2.1.trans (tally_every _),
   c.2.2.1.trans ((congrArg (t + ·) (tally_zero _)).trans (Nat.add_zero t)),
   c.2.2.2.trans (tally_not_below 1 m)⟩

/-- Withholding at steps `0` and `1`, then giving. -/
def fromTwo (n : Nat) : Bool := !below 2 n

/-- Withholding at step `1` only. -/
def skipsOne : Nat → Bool
  | 0 => true
  | 1 => false
  | _ + 2 => true

theorem tally_two_head (p : Nat → Bool) (m : Nat) :
    tally p (2 + m) = cond (p 0) 1 0 + (cond (p 1) 1 0 + tally (fun n => p (n + 2)) m) := by
  rw [Nat.add_comm 2 m, tally_head, tally_head]

/-- **Agreement after one error**: the erring formation withholds at steps `t` and `t + 1`, its
partner at step `t + 1`, and from step `t + 2` they give together. -/
theorem counts_agreeing_error (t m : Nat) :
    received agreeing agreeing (errAt t) first (t + (2 + m)) = t + (1 + m) ∧
      withheld agreeing agreeing (errAt t) first (t + (2 + m)) = 2 ∧
      received agreeing agreeing (errAt t) second (t + (2 + m)) = t + m ∧
      withheld agreeing agreeing (errAt t) second (t + (2 + m)) = 1 :=
  have c := counts_after (h := fromTwo) (k := skipsOne) rfl rfl
    ⟨rfl, rfl, fun n => match n with | 0 => rfl | 1 => rfl | _ + 2 => rfl,
     fun n => match n with | 0 => rfl | 1 => rfl | _ + 2 => rfl⟩ t (2 + m)
  ⟨c.1.trans (congrArg (t + ·) ((tally_two_head skipsOne m).trans
      (congrArg (1 + ·) ((Nat.zero_add _).trans (tally_all m))))),
   c.2.1.trans ((tally_congr (fun n => show (!(!below 2 n)) = below 2 n by cases below 2 n <;> rfl) _).trans (tally_below 2 m)),
   c.2.2.1.trans (congrArg (t + ·) ((tally_two_head fromTwo m).trans
      ((Nat.zero_add _).trans ((Nat.zero_add _).trans (tally_all m))))),
   c.2.2.2.trans ((tally_two_head _ m).trans (congrArg (0 + ·) ((congrArg (1 + ·) (tally_none m)))))⟩

/-! ### The window of two on the configurations -/

/-- The errors read as a Prop-valued pattern. -/
def asProp (e : Errors) : Nat → Pair → Prop := fun t a => e t a = true

/-- A decided state of the pair and a clocked configuration agree: the same step, and each
formation's last two steps at lags `0` and `1`. -/
def ClockMatches (x : State) (y : Nat × (Pair × Nat → Prop)) : Prop :=
  x.1 = y.1 ∧ (x.2.1.1 = true ↔ y.2 (first, 0)) ∧ (x.2.1.2 = true ↔ y.2 (first, 1)) ∧
    (x.2.2.1 = true ↔ y.2 (second, 0)) ∧ (x.2.2.2 = true ↔ y.2 (second, 1))

theorem window_gives_iff (b0 b1 c : Bool) :
    (windowTwo b0 b1 && !c) = true ↔ ¬ c = true ∧ (b0 = true ∨ b1 = true) :=
  ListTests.and_true_iff.trans
    ⟨fun ⟨w, n⟩ => ⟨ListTests.false_iff_not.mp (ListTests.not_true_iff.mp n), ListTests.or_true_iff.mp w⟩,
     fun ⟨n, w⟩ => ⟨ListTests.or_true_iff.mpr w,
      ListTests.not_true_iff.mpr (ListTests.false_iff_not.mpr n)⟩⟩

theorem start_gives_iff (c : Bool) : (windowTwo true true && !c) = true ↔ ¬ c = true :=
  (window_gives_iff true true c).trans ⟨fun h => h.1, fun h => ⟨h, .inl rfl⟩⟩

/-- **Two holders of the window of two, with any errors, run the clocked course of
`answersWithin 2 Pair.Waits`** of `Becoming.WindowedWaiting` with the same errors: at every step
the two agree at lags `0` and `1` of each formation. A bridge. -/
theorem windowed_course (e : Errors) : ∀ n,
    ClockMatches ((course windowed windowed e).state n)
      ((Law.run (clocked (asProp e) 2 Waits) (0, erringStart (asProp e))).state n) :=
  course_rel ClockMatches
    ⟨rfl, start_gives_iff (e 0 first), ⟨fun _ => trivial, fun _ => rfl⟩,
     start_gives_iff (e 0 second), ⟨fun _ => trivial, fun _ => rfl⟩⟩
    fun x y m => match x, y, m with
      | (t, (a0, a1), (b0, b1)), (_, _), ⟨rfl, ma0, ma1, mb0, mb1⟩ =>
        ⟨rfl,
         (window_gives_iff b0 b1 (e (t + 1) first)).trans
          ⟨fun ⟨n, g⟩ => ⟨n, within_first.mpr ((or_congr_both mb0 mb1).mp g)⟩,
           fun ⟨n, g⟩ => ⟨n, (or_congr_both mb0 mb1).mpr (within_first.mp g)⟩⟩,
         ma0,
         (window_gives_iff a0 a1 (e (t + 1) second)).trans
          ⟨fun ⟨n, g⟩ => ⟨n, within_second.mpr ((or_congr_both ma0 ma1).mp g)⟩,
           fun ⟨n, g⟩ => ⟨n, (or_congr_both ma0 ma1).mpr (within_second.mp g)⟩⟩,
         mb0⟩

theorem gives_window (e : Errors) (a : Pair) (n : Nat) :
    gives windowed windowed e a n = true ↔
      ((Law.run (clocked (asProp e) 2 Waits) (0, erringStart (asProp e))).state n).2 (a, 0) :=
  match a with
  | first => (windowed_course e n).2.1
  | second => (windowed_course e n).2.2.2.1

/-- **Under the window of two, where no formation errs at two consecutive steps, each formation
withholds exactly at its own errors** (`WindowedWaiting.gives_unless_errs` read through the
bridge). -/
theorem windowed_gives_spaced {e : Errors} (spaced : Spaced (asProp e) 2) (a : Pair) (n : Nat) :
    gives windowed windowed e a n = !e n a :=
  bool_eq_of_iff ((gives_window e a n).trans ((gives_unless_errs spaced n a).trans
    ⟨fun ne => ListTests.not_true_iff.mpr (ListTests.false_iff_not.mpr ne),
     fun h => ListTests.false_iff_not.mp (ListTests.not_true_iff.mp h)⟩))

/-- **So its counts are the error counts**: each formation withholds at as many steps as it errs,
and receives at every step but its partner's errors. -/
theorem counts_windowed_spaced {e : Errors} (spaced : Spaced (asProp e) 2) (a : Pair) (n : Nat) :
    withheld windowed windowed e a n = tally (fun t => e t a) n ∧
      received windowed windowed e a n + tally (fun t => e t (partner a)) n = n :=
  ⟨tally_congr (fun t => (congrArg (!·) (windowed_gives_spaced spaced a t)).trans
      (by cases e t a <;> rfl)) n,
   (congrArg (· + _) (tally_congr (fun t => windowed_gives_spaced spaced (partner a) t) n)).trans
    ((Nat.add_comm _ _).trans ((congrArg (· + _) (not_not_tally (fun t => e t (partner a)) n).symm).trans
      ((Nat.add_comm _ _).trans (tally_not (fun t => !e t (partner a)) n))))⟩

/-! ## Offspring read from a run, and selection among pairs -/

/-- A formation's place in a pair: the law each formation of the pair holds, which formations carry the kind
whose share is read, the errors, and which formation the place is. -/
structure Place where
  law : Pair → PairLaw
  marks : Pair → Bool
  errs : Errors
  side : Pair

namespace Place

/-- The other place of the same pair (the partner's). -/
def other (s : Place) : Place := { s with side := partner s.side }

/-- What the place received over `n` steps. -/
def received (s : Place) (n : Nat) : Nat :=
  PairSelection.received (s.law first) (s.law second) s.errs s.side n

/-- What the place withheld over `n` steps. -/
def withheld (s : Place) (n : Nat) : Nat :=
  PairSelection.withheld (s.law first) (s.law second) s.errs s.side n

/-- Whether the place carries the kind read. -/
def kind (s : Place) : Bool := s.marks s.side

/-- **Offspring read from what a run brings, while the formation is supported**: `a`, with `β` for
each step at which its partner gave it and `γ` for each step at which it withheld. -/
def offspring (a β γ n : Nat) (s : Place) : Nat := a + β * s.received n + γ * s.withheld n

end Place

theorem partner_partner : ∀ p : Pair, partner (partner p) = p
  | first => rfl
  | second => rfl

/-- **What a pair's run gives each formation is what the other withheld not.** For any laws and
errors, what a place received with what the other place of its pair withheld is every step. -/
theorem received_add_withheld (s : Place) (n : Nat) : s.received n + s.other.withheld n = n :=
  tally_not _ n

theorem other_received_add_withheld (s : Place) (n : Nat) : s.other.received n + s.withheld n = n :=
  (congrArg (· + s.withheld n) (tally_congr (fun t => congrArg
    (fun p => gives (s.law first) (s.law second) s.errs p t) (partner_partner s.side)) n)).trans
    (tally_not _ n)

theorem rearrange (a x y u v : Nat) :
    a + x + y + (a + u + v) = a + (x + v) + (a + (u + y)) := by
  rw [Nat.add_assoc a x y, Nat.add_assoc a u v, Nat.add_add_add_comm a (x + y) a (u + v),
    Nat.add_add_add_comm a (x + v) a (u + y), Nat.add_add_add_comm x y u v,
    Nat.add_add_add_comm x v u y, Nat.add_comm y v]

/-- **Where `β ≤ γ` (giving moves what it draws, an AI reading), no pair leaves more than two
withholders.** With `β ≤ γ`, for any laws and errors, a place and the other place of its pair
together leave at most `2 (a + γ n)`. -/
theorem pair_le {β γ : Nat} (le : β ≤ γ) (a n : Nat) (s : Place) :
    s.offspring a β γ n + s.other.offspring a β γ n ≤ (a + γ * n) + (a + γ * n) :=
  Nat.le_trans
    (Nat.add_le_add
      (Nat.add_le_add_right (Nat.add_le_add_left (Nat.mul_le_mul_right _ le) a) _)
      (Nat.add_le_add_right (Nat.add_le_add_left (Nat.mul_le_mul_right _ le) a) _))
    (Nat.le_of_eq ((rearrange _ _ _ _ _).trans (by
      rw [← Nat.left_distrib, ← Nat.left_distrib, received_add_withheld,
        other_received_add_withheld])))

/-! ### Selection for a kind -/

section Kind

variable {α : Type}

/-- One at the members of the kind, none elsewhere. -/
def amountOf (kind : α → Bool) (p : α) : Nat := cond (kind p) 1 0

/-- One at the members not of the kind. -/
def otherOf (kind : α → Bool) (p : α) : Nat := cond (kind p) 0 1

theorem lt_iff_split {W1 W0 A Z : Nat} : (W1 + W0) * A < (A + Z) * W1 ↔ A * W0 < Z * W1 := by
  rw [add_mul_split, add_mul_split, Nat.mul_comm W1 A, Nat.mul_comm W0 A]
  exact ⟨Nat.lt_of_add_lt_add_left, fun h => Nat.add_lt_add_left h _⟩

/-- **A kind rises exactly where its members' mean offspring exceeds the others'**: the selection
term proper on the kind is positive exactly where the number of members times what the others
leave falls short of the number of others times what the members leave. -/
theorem kind_rises_iff (ps : List α) (w : α → Nat) (kind : α → Bool) :
    discord ps w (amountOf kind) < concord ps w (amountOf kind) ↔
      total ps (amountOf kind) * total ps (fun p => w p * otherOf kind p) <
        total ps (otherOf kind) * total ps (fun p => w p * amountOf kind p) :=
  have split_w : total ps w = total ps (fun p => w p * amountOf kind p) +
      total ps (fun p => w p * otherOf kind p) :=
    (total_congr (fun p => show w p = w p * cond (kind p) 1 0 + w p * cond (kind p) 0 1 by
      cases kind p
      · show w p = w p * 0 + w p * 1
        rw [Nat.mul_zero, Nat.mul_one, Nat.zero_add]
      · show w p = w p * 1 + w p * 0
        rw [Nat.mul_zero, Nat.mul_one, Nat.add_zero]) ps).trans (total_add _ _ ps)
  have split_l : ps.length = total ps (amountOf kind) + total ps (otherOf kind) :=
    (total_ones ps).symm.trans ((total_congr (fun p => show 1 = cond (kind p) 1 0 + cond (kind p) 0 1 by
      cases kind p <;> rfl) ps).trans (total_add _ _ ps))
  (exceeds_iff ps w (amountOf kind)).symm.trans
    (by rw [split_w, split_l]; exact lt_iff_split)

/-- **Where every member of the kind leaves at most every other, the kind never rises**: nothing is
concordant. -/
theorem kind_not_rises_of_below {ps : List α} {w : α → Nat} {kind : α → Bool}
    (below : ∀ p q, p ∈ ps → q ∈ ps → kind p = true → kind q = false → w p ≤ w q) :
    ¬ discord ps w (amountOf kind) < concord ps w (amountOf kind) :=
  have zero : concord ps w (amountOf kind) = 0 := pairs_zero fun p q mp mq => by
    show excess (w p) (w q) * excess (cond (kind p) 1 0) (cond (kind q) 1 0) = 0
    match hp : kind p, hq : kind q with
    | true, false => rw [Flow.excess_zero_of_le (below p q mp mq hp hq), Nat.zero_mul]
    | true, true => rfl
    | false, true => rfl
    | false, false => rfl
  fun lt => Nat.not_lt_zero _ (zero ▸ lt)

/-- **Where the kind's members leave at most `M` on average and every other at least `M`, the kind
never rises.** -/
theorem kind_not_rises_of_bound {ps : List α} {w : α → Nat} {kind : α → Bool} {M : Nat}
    (members : total ps (fun p => w p * amountOf kind p) ≤ M * total ps (amountOf kind))
    (others : ∀ p, p ∈ ps → kind p = false → M ≤ w p) :
    ¬ discord ps w (amountOf kind) < concord ps w (amountOf kind) := fun lt =>
  have W0 : M * total ps (otherOf kind) ≤ total ps (fun p => w p * otherOf kind p) :=
    Nat.le_trans (Nat.le_of_eq (total_mul M (otherOf kind) ps).symm)
      (total_le ps fun p mp => show M * cond (kind p) 0 1 ≤ w p * cond (kind p) 0 1 by
        match h : kind p with
        | true => exact Nat.le_refl _
        | false => exact Nat.mul_le_mul_right 1 (others p mp h))
  Nat.lt_irrefl _ (Nat.lt_of_le_of_lt
    (calc total ps (otherOf kind) * total ps (fun p => w p * amountOf kind p)
        ≤ total ps (otherOf kind) * (M * total ps (amountOf kind)) := Nat.mul_le_mul_left _ members
      _ = total ps (amountOf kind) * (M * total ps (otherOf kind)) :=
          (mul_turn _ _ _).trans ((congrArg (M * ·) (Nat.mul_comm _ _)).trans (mul_turn _ _ _).symm)
      _ ≤ total ps (amountOf kind) * total ps (fun p => w p * otherOf kind p) :=
          Nat.mul_le_mul_left _ W0)
    ((kind_rises_iff ps w kind).mp lt))

end Kind

/-! ### Withholding and answering, read on places -/

/-- The run carries its step. -/
theorem time (f g : PairLaw) (e : Errors) : ∀ n, ((course f g e).state n).1 = n
  | 0 => rfl
  | n + 1 => congrArg (· + 1) (time f g e n)

theorem gives_answering_first (g : PairLaw) (e : Errors) (t : Nat) :
    gives answering g e first (t + 1) = (gives answering g e second t && !e (t + 1) first) := by
  show (answering _ _ && !e (((course answering g e).state t).1 + 1) first) = _
  rw [time]
  rfl

theorem gives_answering_second (f : PairLaw) (e : Errors) (t : Nat) :
    gives f answering e second (t + 1) = (gives f answering e first t && !e (t + 1) second) := by
  show (answering _ _ && !e (((course f answering e).state t).1 + 1) second) = _
  rw [time]
  rfl

theorem gives_withholding_first (g : PairLaw) (e : Errors) : ∀ n, gives withholding g e first n = false
  | 0 => rfl
  | _ + 1 => rfl

theorem gives_withholding_second (f : PairLaw) (e : Errors) : ∀ n, gives f withholding e second n = false
  | 0 => rfl
  | _ + 1 => rfl

/-- **A withholder withholds at every step**, whatever its partner and the errors. -/
theorem Place.withheld_of_withholding (s : Place) (h : s.law s.side = withholding) (n : Nat) :
    s.withheld n = n :=
  match s, h with
  | ⟨law, _, errs, first⟩, h => by
    have h' : law first = withholding := h
    show tally (fun t => !gives (law first) (law second) errs first t) n = n
    rw [h']
    exact tally_true (fun t => by rw [gives_withholding_first]; rfl) n
  | ⟨law, _, errs, second⟩, h => by
    have h' : law second = withholding := h
    show tally (fun t => !gives (law first) (law second) errs second t) n = n
    rw [h']
    exact tally_true (fun t => by rw [gives_withholding_second]; rfl) n

theorem tally_le_succ (p : Nat → Bool) (n : Nat) : tally p (n + 1) ≤ tally p n + 1 :=
  Nat.add_le_add_left (by cases p n <;> decide) _

/-- The count for an answerer that does not err: what it received and what it withheld together
are at most the steps. -/
theorem answering_sum_le {P Q : Nat → Bool} (zero : P 0 = true) (succ : ∀ t, P (t + 1) = Q t) :
    ∀ n, tally Q n + tally (fun t => !P t) n ≤ n
  | 0 => Nat.le_refl 0
  | n + 1 => by
    rw [tally_head (fun t => !P t), zero]
    show tally Q (n + 1) + (0 + tally (fun t => !P (t + 1)) n) ≤ n + 1
    rw [Nat.zero_add, tally_congr (fun t => congrArg (!·) (succ t)) n]
    exact Nat.le_trans (Nat.add_le_add_right (tally_le_succ Q n) _)
      (Nat.le_of_eq ((Nat.add_right_comm _ _ _).trans (congrArg (· + 1) (tally_not Q n))))

/-- **An answerer that does not err receives and withholds at most at every step together**,
whatever its partner holds and however its partner errs. -/
theorem Place.answering_le (s : Place) (h : s.law s.side = answering)
    (own : ∀ t, s.errs t s.side = false) (n : Nat) : s.received n + s.withheld n ≤ n :=
  match s, h, own with
  | ⟨law, _, errs, first⟩, h, own => by
    have h' : law first = answering := h
    have own : ∀ t, errs t first = false := own
    show tally (gives (law first) (law second) errs second) n +
      tally (fun t => !gives (law first) (law second) errs first t) n ≤ n
    rw [h']
    exact answering_sum_le (show (true && !errs 0 first) = true by rw [own 0]; rfl)
      (fun t => (gives_answering_first _ _ t).trans (by rw [own (t + 1)]; exact Bool.and_true _)) n
  | ⟨law, _, errs, second⟩, h, own => by
    have h' : law second = answering := h
    have own : ∀ t, errs t second = false := own
    show tally (gives (law first) (law second) errs first) n +
      tally (fun t => !gives (law first) (law second) errs second t) n ≤ n
    rw [h']
    exact answering_sum_le (show (true && !errs 0 second) = true by rw [own 0]; rfl)
      (fun t => (gives_answering_second _ _ t).trans (by rw [own (t + 1)]; exact Bool.and_true _)) n

/-- With `β ≤ γ`, a withholder leaves at least `a + γ n`. -/
theorem Place.withholder_ge {β γ : Nat} (a n : Nat) (s : Place) (h : s.law s.side = withholding) :
    a + γ * n ≤ s.offspring a β γ n := by
  show a + γ * n ≤ a + β * s.received n + γ * s.withheld n
  rw [s.withheld_of_withholding h n]
  exact Nat.add_le_add_right (Nat.le_add_right a _) _

/-- With `β ≤ γ`, an answerer that does not err leaves at most `a + γ n`. -/
theorem Place.answerer_le {β γ : Nat} (le : β ≤ γ) (a n : Nat) (s : Place)
    (h : s.law s.side = answering) (own : ∀ t, s.errs t s.side = false) :
    s.offspring a β γ n ≤ a + γ * n :=
  Nat.le_trans (Nat.add_le_add_right (Nat.add_le_add_left (Nat.mul_le_mul_right _ le) a) _)
    (Nat.le_trans (Nat.le_of_eq (Nat.add_assoc _ _ _)) (Nat.add_le_add_left
      (Nat.le_trans (Nat.le_of_eq (Nat.left_distrib γ _ _).symm)
        (Nat.mul_le_mul_left γ (s.answering_le h own n))) a))

/-- **Where `β ≤ γ` (giving moves what it draws, an AI reading), answering never rises without
errors of its own.** With `β ≤ γ`, in every family of places in which each carrier answers and never errs and each other
withholds, every carrier leaves at most every other, and the kind is never selected for: whatever
the carriers' partners hold and however those partners err. -/
theorem answering_never_rises {β γ : Nat} (le : β ≤ γ) (a n : Nat) {ps : List Place}
    (carriers : ∀ s, s ∈ ps → s.kind = true →
      s.law s.side = answering ∧ ∀ t, s.errs t s.side = false)
    (others : ∀ s, s ∈ ps → s.kind = false → s.law s.side = withholding) :
    ¬ discord ps (Place.offspring a β γ n) (amountOf Place.kind) <
      concord ps (Place.offspring a β γ n) (amountOf Place.kind) :=
  kind_not_rises_of_below fun p q mp mq hp hq =>
    Nat.le_trans ((carriers p mp hp).elim fun h own => p.answerer_le le a n h own)
      (q.withholder_ge a n (others q mq hq))

theorem cases_tt (x y : Nat) : x * 1 + (y * 1 + 0) = x + y := by
  rw [Nat.mul_one, Nat.mul_one, Nat.add_zero]
theorem cases_tf (x y : Nat) : x * 1 + (y * 0 + 0) = x := by
  rw [Nat.mul_one, Nat.mul_zero, Nat.add_zero]
theorem cases_ft (x y : Nat) : x * 0 + (y * 1 + 0) = y := by
  rw [Nat.mul_one, Nat.mul_zero, Nat.zero_add, Nat.add_zero]
theorem cases_ff (x y : Nat) : x * 0 + (y * 0 + 0) = 0 := by rw [Nat.mul_zero, Nat.mul_zero]

theorem mem_whole {gs : List (List Place)} {g : List Place} {s : Place} (mg : g ∈ gs) (ms : s ∈ g) :
    s ∈ whole gs :=
  ListTests.mem_flatMap_iff.mpr ⟨g, mg, ms⟩

/-- **Where `β ≤ γ` (giving moves what it draws, an AI reading), no kind rises against withholders
in a cohort of pairs, whatever the laws and the errors.** With `β ≤ γ`, in every cohort listed by pairs, each a place and
the other place of its pair, in which every place not of the kind withholds, the kind is never
selected for, whatever laws the kind holds: answering is one case. -/
theorem never_rises_in_pairs {β γ : Nat} (le : β ≤ γ) (a n : Nat) {gs : List (List Place)}
    (paired : ∀ g, g ∈ gs → ∃ s, g = [s, s.other])
    (others : ∀ s, s ∈ whole gs → s.kind = false → s.law s.side = withholding) :
    ¬ discord (whole gs) (Place.offspring a β γ n) (amountOf Place.kind) <
      concord (whole gs) (Place.offspring a β γ n) (amountOf Place.kind) :=
  have each : ∀ g, g ∈ gs → total g (fun p => Place.offspring a β γ n p * amountOf Place.kind p) ≤
      (a + γ * n) * total g (amountOf Place.kind) := fun g mg =>
    match g, paired g mg with
    | _, ⟨s, rfl⟩ =>
      have both := pair_le le a n s
      have ms : s ∈ whole gs := mem_whole mg (.head _)
      have mm : s.other ∈ whole gs := mem_whole mg (.tail _ (.head _))
      show s.offspring a β γ n * cond s.kind 1 0 + (s.other.offspring a β γ n * cond s.other.kind 1 0 + 0) ≤
        (a + γ * n) * (cond s.kind 1 0 + (cond s.other.kind 1 0 + 0)) by
      match hs : s.kind, hm : s.other.kind with
      | true, true =>
        exact Nat.le_trans (Nat.le_of_eq (cases_tt _ _)) (Nat.le_trans both (Nat.le_of_eq (Nat.mul_two _).symm))
      | true, false =>
        exact Nat.le_trans (Nat.le_of_eq (cases_tf _ _)) (Nat.le_trans
          (Naturals.le_of_add_le_add_left (k := s.other.offspring a β γ n)
            (Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _))
              (Nat.le_trans both (Nat.add_le_add_right (s.other.withholder_ge (β := β) a n (others _ mm hm)) _))))
          (Nat.le_of_eq (Nat.mul_one _).symm))
      | false, true =>
        exact Nat.le_trans (Nat.le_of_eq (cases_ft _ _)) (Nat.le_trans
          (Naturals.le_of_add_le_add_left (k := s.offspring a β γ n)
            (Nat.le_trans both (Nat.add_le_add_right (s.withholder_ge (β := β) a n (others _ ms hs)) _)))
          (Nat.le_of_eq (Nat.mul_one _).symm))
      | false, false => exact Nat.le_of_eq ((cases_ff _ _).trans (Nat.mul_zero _).symm)
  kind_not_rises_of_bound (M := a + γ * n)
    (Nat.le_trans (Nat.le_of_eq (whole_weighted gs _ _))
      (Nat.le_trans (total_le gs each)
        (Nat.le_of_eq ((total_mul _ _ gs).trans (congrArg _ (whole_total gs _).symm)))))
    fun p mp hp => p.withholder_ge a n (others p mp hp)

/-! ### A cohort of answerer and withholder pairs -/

/-- An answerer beside an answerer, with no errors. -/
def answerPair : Place := ⟨fun _ => answering, fun _ => true, noErrors, first⟩

/-- The laws of a mixed pair: the first answers, the second withholds. -/
def mixedLaw : Pair → PairLaw
  | first => answering
  | second => withholding

/-- In a mixed pair the first carries the kind. -/
def mixedMarks : Pair → Bool
  | first => true
  | second => false

/-- An answerer beside a withholder, with no errors. -/
def mixedPair : Place := ⟨mixedLaw, mixedMarks, noErrors, first⟩

/-- A withholder beside a withholder. -/
def withholdPair : Place := ⟨fun _ => withholding, fun _ => false, noErrors, first⟩

/-- A cohort of `x` answerer pairs, `y` mixed pairs and `z` withholder pairs. -/
def cohort (x y z : Nat) : List (List Place) :=
  List.replicate x [answerPair, answerPair.other] ++ List.replicate y [mixedPair, mixedPair.other] ++
    List.replicate z [withholdPair, withholdPair.other]

theorem mem_replicate_eq {β : Type} {c g : β} : ∀ {k : Nat}, g ∈ List.replicate k c → g = c
  | 0, mem => nomatch mem
  | k + 1, mem => match (mem : g ∈ c :: List.replicate k c) with
    | .head _ => rfl
    | .tail _ m => mem_replicate_eq m

/-- Every group of the cohort is a pair. -/
theorem cohort_paired (x y z : Nat) : ∀ g, g ∈ cohort x y z → ∃ s, g = [s, s.other] := fun _ mg =>
  match mem_append_cases mg with
  | .inl m => match mem_append_cases m with
    | .inl m => ⟨answerPair, mem_replicate_eq m⟩
    | .inr m => ⟨mixedPair, mem_replicate_eq m⟩
  | .inr m => ⟨withholdPair, mem_replicate_eq m⟩

theorem total_cohort (x y z : Nat) (q : Place → Nat) :
    total (whole (cohort x y z)) q =
      x * (q answerPair + (q answerPair.other + 0)) + y * (q mixedPair + (q mixedPair.other + 0)) +
        z * (q withholdPair + (q withholdPair.other + 0)) :=
  (whole_total _ q).trans (by
    rw [cohort, total_append, total_append, total_replicate, total_replicate, total_replicate]
    rfl)

section Offspring

variable (a β γ d : Nat)

theorem offspring_answerPair :
    answerPair.offspring a β γ (1 + d) = a + β * (1 + d) + γ * 0 := by
  show a + β * received answering answering noErrors first (1 + d) +
    γ * withheld answering answering noErrors first (1 + d) = _
  rw [(counts_giving (f := answering) (g := answering) rfl rfl first (1 + d)).1,
    (counts_giving (f := answering) (g := answering) rfl rfl first (1 + d)).2]

theorem offspring_answerPair_other :
    answerPair.other.offspring a β γ (1 + d) = a + β * (1 + d) + γ * 0 := by
  show a + β * received answering answering noErrors second (1 + d) +
    γ * withheld answering answering noErrors second (1 + d) = _
  rw [(counts_giving (f := answering) (g := answering) rfl rfl second (1 + d)).1,
    (counts_giving (f := answering) (g := answering) rfl rfl second (1 + d)).2]

theorem offspring_mixedPair : mixedPair.offspring a β γ (1 + d) = a + β * 0 + γ * d := by
  show a + β * received answering withholding noErrors first (1 + d) +
    γ * withheld answering withholding noErrors first (1 + d) = _
  rw [(counts_answering_withholding d).1, (counts_answering_withholding d).2.1]

theorem offspring_mixedPair_other :
    mixedPair.other.offspring a β γ (1 + d) = a + β * 1 + γ * (1 + d) := by
  show a + β * received answering withholding noErrors second (1 + d) +
    γ * withheld answering withholding noErrors second (1 + d) = _
  rw [(counts_answering_withholding d).2.2.1, (counts_answering_withholding d).2.2.2]

theorem offspring_withholdPair :
    withholdPair.offspring a β γ (1 + d) = a + β * 0 + γ * (1 + d) := by
  show a + β * received withholding withholding noErrors first (1 + d) +
    γ * withheld withholding withholding noErrors first (1 + d) = _
  rw [(counts_withholding_withholding (1 + d)).1, (counts_withholding_withholding (1 + d)).2.1]

theorem offspring_withholdPair_other :
    withholdPair.other.offspring a β γ (1 + d) = a + β * 0 + γ * (1 + d) := by
  show a + β * received withholding withholding noErrors second (1 + d) +
    γ * withheld withholding withholding noErrors second (1 + d) = _
  rw [(counts_withholding_withholding (1 + d)).2.2.1, (counts_withholding_withholding (1 + d)).2.2.2]

end Offspring

/-- **Answering rises in a cohort of answerer and withholder pairs exactly where its members' mean
offspring exceeds the withholders'**, the offspring read from the runs over `1 + d` steps with no
errors: an answerer beside an answerer leaves `a + β (1 + d)`, beside a withholder `a + γ d`; a
withholder beside an answerer `a + β + γ (1 + d)`, beside a withholder `a + γ (1 + d)`. Read
through the mean law `kind_rises_iff`; the four-term law (`pairs_rises_iff`) is not evaluated
here. -/
theorem answering_rises_iff (a β γ x y z d : Nat) :
    discord (whole (cohort x y z)) (Place.offspring a β γ (1 + d)) (amountOf Place.kind) <
        concord (whole (cohort x y z)) (Place.offspring a β γ (1 + d)) (amountOf Place.kind) ↔
      (x * 2 + y) * (y * (a + β + γ * (1 + d)) + z * ((a + γ * (1 + d)) + (a + γ * (1 + d)))) <
        (y + z * 2) * (x * ((a + β * (1 + d)) + (a + β * (1 + d))) + y * (a + γ * d)) :=
  have counts : discord (whole (cohort x y z)) (Place.offspring a β γ (1 + d)) (amountOf Place.kind) <
        concord (whole (cohort x y z)) (Place.offspring a β γ (1 + d)) (amountOf Place.kind) ↔
      (x * 2 + y) * (y * (a + β * 1 + γ * (1 + d)) +
          z * ((a + β * 0 + γ * (1 + d)) + (a + β * 0 + γ * (1 + d)))) <
        (y + z * 2) * (x * ((a + β * (1 + d) + γ * 0) + (a + β * (1 + d) + γ * 0)) +
          y * (a + β * 0 + γ * d)) := (kind_rises_iff _ _ _).trans (by
  rw [total_cohort, total_cohort, total_cohort, total_cohort]
  show (x * 2 + y * 1 + z * 0) *
      (x * (_ * 0 + (_ * 0 + 0)) + y * (_ * 0 + (_ * 1 + 0)) + z * (_ * 1 + (_ * 1 + 0))) <
    (x * 0 + y * 1 + z * 2) *
      (x * (_ * 1 + (_ * 1 + 0)) + y * (_ * 1 + (_ * 0 + 0)) + z * (_ * 0 + (_ * 0 + 0))) ↔ _
  rw [cases_ff, cases_ft, cases_tt, cases_tt, cases_tf, cases_ff, Nat.mul_zero, Nat.mul_zero,
    Nat.mul_zero, Nat.add_zero, Nat.add_zero, Nat.zero_add, Nat.zero_add, Nat.mul_one, Nat.mul_one,
    offspring_answerPair, offspring_answerPair_other, offspring_mixedPair, offspring_mixedPair_other,
    offspring_withholdPair, offspring_withholdPair_other, Nat.mul_one β, Nat.mul_zero β])
  counts.trans (by
    rw [Nat.mul_one β, Nat.mul_zero β, Nat.mul_zero γ, Nat.add_zero a, Nat.add_zero (a + β * (1 + d))])

/-- **Pairs as groups of two: the four-term law read on pairs.** For any family listed by groups of
two, the whole selects for an amount exactly where the means' concordance with `2` times the
whole's size times the groups' own concordances exceeds the same for the discordances
(`SelectionLevels.rises_iff_sized` with every factor one and common multiple two). A
restatement. -/
theorem pairs_rises_iff {α : Type} (gs : List (List α)) (two : ∀ g, g ∈ gs → g.length = 2)
    (w a : α → Nat) :
    discord (whole gs) w a < concord (whole gs) w a ↔
      2 * (whole gs).length * discordWithinBy gs (fun _ => 1) w a + discordMeans gs (fun _ => 1) w a <
        2 * (whole gs).length * concordWithinBy gs (fun _ => 1) w a + concordMeans gs (fun _ => 1) w a :=
  rises_iff_sized gs w a (fun _ => 1) (fun g mg => (Nat.mul_one _).trans (two g mg)) (Nat.succ_pos 1)

/-- **Among-pair discordance can be positive.** With `a = 1`, `β = 1`, `γ = 3` and two steps, in a
cohort of one answerer pair and one mixed pair, the mixed pair leaves more than the answerer pair
(twelve against six) while carrying less of the kind, so the pairs' means are discordant; within
the mixed pair the withholder leaves more (eight against four). -/
theorem among_discord_witness :
    0 < discordMeans (cohort 1 1 0) (fun _ => 1) (Place.offspring 1 1 3 2) (amountOf Place.kind) ∧
      mixedPair.offspring 1 1 3 2 = 4 ∧ mixedPair.other.offspring 1 1 3 2 = 8 ∧
      answerPair.offspring 1 1 3 2 = 3 := by
  decide

/-- What two places of one pair leave together. -/
theorem pair_sum (a β γ R₁ K₁ R₂ K₂ : Nat) :
    (a + β * R₁ + γ * K₁) + (a + β * R₂ + γ * K₂) = (a + a) + β * (R₁ + R₂) + γ * (K₁ + K₂) := by
  rw [Nat.left_distrib, Nat.left_distrib, rearrange, Nat.add_add_add_comm a (β * R₁ + γ * K₂),
    Nat.add_add_add_comm (β * R₁) (γ * K₂) (β * R₂) (γ * K₁), Nat.add_assoc (a + a),
    Nat.add_comm (γ * K₂) (γ * K₁)]

/-- **A mixed pair leaves more than an answerer pair exactly where `β < γ`**: over `1 + d` steps
with no errors, an answerer pair leaves `2 a + β + β (1 + 2 d)` and a mixed pair
`2 a + β + γ (1 + 2 d)`. So the means of the pairs are discordant with the kind exactly there. -/
theorem mixed_exceeds_iff (a β γ d : Nat) :
    answerPair.offspring a β γ (1 + d) + answerPair.other.offspring a β γ (1 + d) <
        mixedPair.offspring a β γ (1 + d) + mixedPair.other.offspring a β γ (1 + d) ↔ β < γ := by
  have hA : answerPair.offspring a β γ (1 + d) + answerPair.other.offspring a β γ (1 + d) =
      (a + a + β * 1) + β * (d + (1 + d)) := by
    rw [offspring_answerPair, offspring_answerPair_other, pair_sum, Nat.add_assoc 1 d (1 + d),
      Nat.left_distrib β 1, ← Nat.add_assoc]
    rfl
  have hM : mixedPair.offspring a β γ (1 + d) + mixedPair.other.offspring a β γ (1 + d) =
      (a + a + β * 1) + γ * (d + (1 + d)) := by
    rw [offspring_mixedPair, offspring_mixedPair_other, pair_sum, Nat.zero_add 1]
  have Dpos : 0 < d + (1 + d) := Nat.lt_of_lt_of_le (Nat.zero_lt_succ d)
    (Nat.le_trans (Nat.le_of_eq (Nat.add_comm d 1)) (Nat.le_add_left (1 + d) d))
  rw [hA, hM]
  exact ⟨fun h => Naturals.lt_of_mul_lt_mul_left (m := d + (1 + d))
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.mul_comm _ _))
        (Nat.lt_of_lt_of_le (Nat.lt_of_add_lt_add_left h) (Nat.le_of_eq (Nat.mul_comm _ _)))),
    fun h => Nat.add_lt_add_left (Nat.mul_lt_mul_of_pos_right h Dpos) _⟩

/-! ### Complete assortment: the rule after shaping -/

open RuleCapture RuleShaping in
/-- **Under complete assortment the pairs' counts are the rule after shaping**: over `n` steps an
answerer beside an answerer leaves the shapers' count of `shaped a (β n) 0 (γ n)`, and a withholder
beside a withholder the others'. -/
theorem assorted_counts (a β γ d : Nat) (pos : 0 < a) :
    answerPair.offspring a β γ (1 + d) = (shaped a (β * (1 + d)) 0 (γ * (1 + d)) pos).carrier ∧
      withholdPair.offspring a β γ (1 + d) = (shaped a (β * (1 + d)) 0 (γ * (1 + d)) pos).other :=
  ⟨(offspring_answerPair a β γ d).trans (by rw [Nat.mul_zero]; rfl),
   (offspring_withholdPair a β γ d).trans (by rw [Nat.mul_zero, Nat.add_zero]; rfl)⟩

open RuleCapture RuleShaping in
/-- **Weakly favoured exactly where `γ ≤ β`**: for `n > 0`, `RuleShaping.favours_iff` with
`s = β n`, `c = γ n`, `p = 0`. -/
theorem assorted_favours_iff {a β γ n : Nat} (pos : 0 < a) (npos : 0 < n) :
    CarrierCounts.favours (shaped a (β * n) 0 (γ * n) pos) ↔ γ ≤ β :=
  favours_iff.trans ⟨fun h => SelectionTerm.le_of_mul_le_mul npos
      (Nat.le_trans (Nat.le_of_eq (Nat.mul_comm n γ)) (Nat.le_trans h (Nat.le_of_eq (Nat.mul_comm β n)))),
    fun h => Nat.mul_le_mul_right n h⟩

open RuleCapture RuleShaping in
/-- **Raised strictly exactly where `γ < β`**: the answerers present, selection by the rule raises
their share strictly exactly where `γ < β` (`RuleShaping.lt_select_iff`). -/
theorem assorted_raises_iff {a β γ n : Nat} (pos : 0 < a) (npos : 0 < n) {x : CarrierCounts}
    (some : 0 < x.carrier) :
    x.carrier * (CarrierCounts.select x (shaped a (β * n) 0 (γ * n) pos)).other <
        (CarrierCounts.select x (shaped a (β * n) 0 (γ * n) pos)).carrier * x.other ↔ γ < β :=
  (lt_select_iff some).trans
    ⟨fun h => Naturals.lt_of_mul_lt_mul_left (m := n)
        (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.mul_comm n γ))
          (Nat.lt_of_lt_of_le (Nat.lt_of_add_lt_add_left (h : a + γ * n < a + β * n))
            (Nat.le_of_eq (Nat.mul_comm β n)))),
     fun h => (Nat.add_lt_add_left (Nat.mul_lt_mul_of_pos_right h npos) a : a + γ * n < a + β * n)⟩

open RuleCapture RuleShaping in
/-- **Weakly disfavoured exactly where `β ≤ γ`**: for `n > 0`, `RuleShaping.disfavours_iff` with
`s = β n`, `c = γ n`, `p = 0`, the factor `n` cancelled. A corollary. -/
theorem assorted_disfavours_iff {a β γ n : Nat} (pos : 0 < a) (npos : 0 < n) :
    CarrierCounts.disfavours (shaped a (β * n) 0 (γ * n) pos) ↔ β ≤ γ :=
  disfavours_iff.trans ⟨fun h => SelectionTerm.le_of_mul_le_mul npos
      (Nat.le_trans (Nat.le_of_eq (Nat.mul_comm n β)) (Nat.le_trans h (Nat.le_of_eq (Nat.mul_comm γ n)))),
    fun h => Nat.mul_le_mul_right n h⟩

open RuleCapture RuleShaping in
/-- **Lowered strictly exactly where `β < γ`**: the answerers present, selection by the rule lowers
their share strictly exactly where `β < γ` (`RuleShaping.falls_strictly`, and its converse by
cancelling the counts before selection). A corollary. -/
theorem assorted_lowers_iff {a β γ n : Nat} (pos : 0 < a) (npos : 0 < n) {x : CarrierCounts}
    (some : 0 < x.carrier) :
    (CarrierCounts.select x (shaped a (β * n) 0 (γ * n) pos)).carrier * x.other <
        x.carrier * (CarrierCounts.select x (shaped a (β * n) 0 (γ * n) pos)).other ↔ β < γ :=
  ⟨fun lt =>
    have below : a + β * n < a + γ * n := Naturals.lt_of_mul_lt_mul_left (m := x.carrier * x.other)
      (calc x.carrier * x.other * (a + β * n)
          = x.carrier * (a + β * n) * x.other := Naturals.mul_right_comm _ _ _
        _ < x.carrier * (x.other * (a + γ * n)) := lt
        _ = x.carrier * x.other * (a + γ * n) := (mul_assoc_nat _ _ _).symm)
    Naturals.lt_of_mul_lt_mul_left (m := n)
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.mul_comm n β))
        (Nat.lt_of_lt_of_le (Nat.lt_of_add_lt_add_left below) (Nat.le_of_eq (Nat.mul_comm γ n)))),
   fun h => falls_strictly some
     (Nat.add_lt_add_left (Nat.mul_lt_mul_of_pos_right h npos) a : a + β * n < a + γ * n)⟩

open RuleCapture RuleShaping in
/-- **At `γ = β` nothing is selected**: the rule both favours and disfavours, so the share is left
where it is. -/
theorem assorted_neutral {a β n : Nat} (pos : 0 < a) (x : CarrierCounts) :
    CarrierCounts.order.le x (CarrierCounts.select x (shaped a (β * n) 0 (β * n) pos)) ∧
      CarrierCounts.order.le (CarrierCounts.select x (shaped a (β * n) 0 (β * n) pos)) x :=
  ⟨CarrierCounts.raises x _ (favours_iff.mpr (Nat.le_refl _)),
   CarrierCounts.lowers x _ (disfavours_iff.mpr (Nat.le_refl _))⟩

/-! ### Neutrality without withholding -/

/-- **Neutrality without withholding**: where every place's laws give after mutual giving and there
are no errors, every place leaves `a + β n`, and nothing is selected for any amount. -/
theorem neutral (a β γ n : Nat) {ps : List Place}
    (giving : ∀ s, s ∈ ps → s.law first (true, true) (true, true) = true ∧
      s.law second (true, true) (true, true) = true ∧ s.errs = noErrors) (amount : Place → Nat) :
    concord ps (Place.offspring a β γ n) amount = 0 ∧ discord ps (Place.offspring a β γ n) amount = 0 :=
  have same : ∀ s, s ∈ ps → s.offspring a β γ n = a + β * n + γ * 0 := fun s ms =>
    match giving s ms with
    | ⟨hf, hg, he⟩ => by
      show a + β * received (s.law first) (s.law second) s.errs s.side n +
        γ * withheld (s.law first) (s.law second) s.errs s.side n = _
      rw [he, (counts_giving hf hg s.side n).1, (counts_giving hf hg s.side n).2]
  ⟨concord_uniform same amount, discord_uniform same amount⟩

/-! ### The window against answering -/

theorem half_add : ∀ n, half n + half (n + 1) = n
  | 0 => rfl
  | n + 1 => by
    show half (n + 1) + (half n + 1) = n + 1
    rw [← Nat.add_assoc, Nat.add_comm (half (n + 1)) (half n), half_add n]

/-- **An alternator beside a window holder leaves `γ · half (n + 1)` more than a window holder
beside a window holder**: it receives at every step and withholds at the even steps below `n`. -/
theorem alternator_beside_window (a β γ n : Nat) :
    a + β * received windowed alternating noErrors second n +
        γ * withheld windowed alternating noErrors second n =
      (a + β * received windowed windowed noErrors first n +
        γ * withheld windowed windowed noErrors first n) + γ * half (n + 1) := by
  rw [(counts_windowed_alternating n).2.2.1, (counts_windowed_alternating n).2.2.2,
    (counts_giving (f := windowed) (g := windowed) rfl rfl first n).1,
    (counts_giving (f := windowed) (g := windowed) rfl rfl first n).2, Nat.mul_zero]
  rfl

/-- **A window holder beside an alternator leaves `β · half (n + 1)` less than beside a window
holder**: it receives only at the odd steps below `n`. -/
theorem window_beside_alternator (a β γ n : Nat) :
    (a + β * received windowed alternating noErrors first n +
        γ * withheld windowed alternating noErrors first n) + β * half (n + 1) =
      a + β * received windowed windowed noErrors first n +
        γ * withheld windowed windowed noErrors first n := by
  rw [(counts_windowed_alternating n).1, (counts_windowed_alternating n).2.1,
    (counts_giving (f := windowed) (g := windowed) rfl rfl first n).1,
    (counts_giving (f := windowed) (g := windowed) rfl rfl first n).2, Nat.mul_zero, Nat.add_zero,
    Nat.add_zero, Nat.add_assoc, ← Nat.left_distrib, half_add]
  rfl

/-- **A withholder beside a window holder leaves `β` more than beside an answerer**: the window gives
it one step more. -/
theorem withholder_beside_window (a β γ d : Nat) :
    a + β * received windowed withholding noErrors second (2 + d) +
        γ * withheld windowed withholding noErrors second (2 + d) =
      (a + β * received answering withholding noErrors second (2 + d) +
        γ * withheld answering withholding noErrors second (2 + d)) + β := by
  have e : 2 + d = 1 + (1 + d) := (Nat.add_assoc 1 1 d)
  rw [(counts_windowed_withholding d).2.2.1, (counts_windowed_withholding d).2.2.2, e,
    (counts_answering_withholding (1 + d)).2.2.1, (counts_answering_withholding (1 + d)).2.2.2,
    Nat.mul_one, Nat.add_right_comm (a + β) (γ * (1 + (1 + d))) β, Nat.add_assoc a β β,
    ← Nat.mul_two]

/-- **What an echo takes, and a window keeps.** With one error by the first at step `t`, over
`t + (m + 1)` steps: two answerers receive `2 t + (m + 1)` together and withhold `m + 1`; two
window holders receive `2 t + 2 m + 1` together and withhold once. So with offspring `a + β R + γ K`
the echo moves `m` steps from what was received to what was withheld. -/
theorem echo_and_window_sums (t m : Nat) :
    received answering answering (errAt t) first (t + (m + 1)) +
        received answering answering (errAt t) second (t + (m + 1)) = t + t + (m + 1) ∧
      withheld answering answering (errAt t) first (t + (m + 1)) +
        withheld answering answering (errAt t) second (t + (m + 1)) = m + 1 ∧
      received windowed windowed (errAt t) first (t + (m + 1)) +
        received windowed windowed (errAt t) second (t + (m + 1)) = t + t + (m + m + 1) ∧
      withheld windowed windowed (errAt t) first (t + (m + 1)) +
        withheld windowed windowed (errAt t) second (t + (m + 1)) = 1 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [(counts_answering_error t (m + 1)).1, (counts_answering_error t (m + 1)).2.2.1,
      Nat.add_add_add_comm, Nat.add_comm (half (m + 1 + 1)), half_add]
  · rw [(counts_answering_error t (m + 1)).2.1, (counts_answering_error t (m + 1)).2.2.2,
      Nat.add_comm, half_add]
  · rw [(counts_windowed_error t m).1, (counts_windowed_error t m).2.2.1, Nat.add_add_add_comm,
      Nat.add_right_comm m 1 m]
  · rw [(counts_windowed_error t m).2.1, (counts_windowed_error t m).2.2.2]

/-! ### Witnesses for the laws on answering under selection -/

theorem cohort_places {x y z : Nat} {s : Place} (ms : s ∈ whole (cohort x y z)) :
    s = answerPair ∨ s = answerPair.other ∨ s = mixedPair ∨ s = mixedPair.other ∨
      s = withholdPair ∨ s = withholdPair.other := by
  obtain ⟨g, mg, mem⟩ := ListTests.mem_flatMap_iff.mp ms
  rcases mem_append_cases mg with m | m
  · rcases mem_append_cases m with m | m
    · have same := mem_replicate_eq m
      subst same
      cases mem with
      | head => exact .inl rfl
      | tail _ h => cases h with
        | head => exact .inr (.inl rfl)
        | tail _ h => cases h
    · have same := mem_replicate_eq m
      subst same
      cases mem with
      | head => exact .inr (.inr (.inl rfl))
      | tail _ h => cases h with
        | head => exact .inr (.inr (.inr (.inl rfl)))
        | tail _ h => cases h
  · have same := mem_replicate_eq m
    subst same
    cases mem with
    | head => exact .inr (.inr (.inr (.inr (.inl rfl))))
    | tail _ h => cases h with
      | head => exact .inr (.inr (.inr (.inr (.inr rfl))))
      | tail _ h => cases h

/-- **The hypotheses of `answering_never_rises` hold together**: in every cohort of answerer and
withholder pairs with no errors, with `β ≤ γ`, answering is never selected for. -/
theorem cohort_never_rises {β γ : Nat} (le : β ≤ γ) (a n x y z : Nat) :
    ¬ discord (whole (cohort x y z)) (Place.offspring a β γ n) (amountOf Place.kind) <
      concord (whole (cohort x y z)) (Place.offspring a β γ n) (amountOf Place.kind) :=
  answering_never_rises le a n
    (fun s ms hk => by
      rcases cohort_places ms with h | h | h | h | h | h <;> subst h <;>
        first
        | exact ⟨rfl, fun _ => rfl⟩
        | exact Bool.noConfusion hk)
    (fun s ms hk => by
      rcases cohort_places ms with h | h | h | h | h | h <;> subst h <;>
        first
        | rfl
        | exact Bool.noConfusion hk)

/-- The first formation errs at every step. -/
def firstAlways : Errors
  | _, first => true
  | _, second => false

/-- An answerer that errs at every step, beside an answerer. -/
def erringPair : Place := ⟨fun _ => answering, fun _ => true, firstAlways, first⟩

theorem and_not_true : ∀ b : Bool, (b && !true) = false
  | true => rfl
  | false => rfl

/-- **With errors, an answerer can leave more than every withholder.** An answerer erring at every
step beside an answerer receives once and withholds at every step: over `1 + d` steps it leaves
`β` more than a withholder beside a withholder. So `answering_never_rises` needs the carriers not
to err, and with `0 < β` the comparison member by member fails. -/
theorem erring_answerer_exceeds (a β γ d : Nat) :
    erringPair.offspring a β γ (1 + d) = withholdPair.offspring a β γ (1 + d) + β := by
  have c := counts_of (gives_of (f := answering) (g := answering) (e := firstAlways)
    (P := fun _ => false) (Q := below 1) rfl rfl (fun n => and_not_true _)
    (fun n => match n with | 0 => rfl | _ + 1 => rfl)) (1 + d)
  show a + β * received answering answering firstAlways first (1 + d) +
    γ * withheld answering answering firstAlways first (1 + d) = _
  rw [c.1, c.2.1, tally_below 1 d, tally_every, offspring_withholdPair, Nat.mul_zero, Nat.add_zero,
    Nat.mul_one, Nat.add_right_comm]

/-- **The hypotheses of `never_rises_in_pairs` hold together, with errors**: beside a pair of
withholders, a pair of answerers whose first errs at every step is never selected for, with
`β ≤ γ`, though its erring member leaves more than each withholder where `0 < β`. -/
theorem erring_cohort_never_rises {β γ : Nat} (le : β ≤ γ) (a n : Nat) :
    ¬ discord (whole [[erringPair, erringPair.other], [withholdPair, withholdPair.other]])
        (Place.offspring a β γ n) (amountOf Place.kind) <
      concord (whole [[erringPair, erringPair.other], [withholdPair, withholdPair.other]])
        (Place.offspring a β γ n) (amountOf Place.kind) :=
  never_rises_in_pairs le a n
    (fun g mg => by
      cases mg with
      | head => exact ⟨erringPair, rfl⟩
      | tail _ h => cases h with
        | head => exact ⟨withholdPair, rfl⟩
        | tail _ h => cases h)
    (fun s ms hk => by
      change s ∈ [erringPair, erringPair.other, withholdPair, withholdPair.other] at ms
      cases ms with
      | head => exact Bool.noConfusion hk
      | tail _ h => cases h with
        | head => exact Bool.noConfusion hk
        | tail _ h => cases h with
          | head => rfl
          | tail _ h => cases h with
            | head => rfl
            | tail _ h => cases h)

/-! ### When windowed waiting is favoured, and when not -/

theorem window_arith (a β γ t m : Nat) :
    (a + a) + β * (t + t + (m + m + 1)) + γ * 1 =
      (a + a) + β * (t + t + (m + 1)) + γ * 1 + β * m + 0 := by
  have e : t + t + (m + m + 1) = t + t + (m + 1) + m := by
    rw [Nat.add_right_comm m m 1, ← Nat.add_assoc]
  rw [e, Nat.left_distrib β (t + t + (m + 1)) m, ← Nat.add_assoc (a + a), Nat.add_zero,
    Nat.add_right_comm (a + a + β * (t + t + (m + 1))) (γ * 1) (β * m)]
  rfl

open RuleCapture RuleShaping in
/-- **Echoes against a window, under complete assortment: the rule after shaping.** With one error
by the first of each pair at step `t`, over `t + (m + 1)` steps, read each pair as one carrier of
its law with what its two places leave together: a pair of window holders leaves the shapers' count,
and a pair of answerers the others', of `shaped A (β m) 0 (γ m)` with
`A = 2 a + β (2 t + m + 1) + γ`. -/
theorem window_echo_shaped (a β γ t m : Nat) (pos : 0 < a) :
    (a + β * received windowed windowed (errAt t) first (t + (m + 1)) +
          γ * withheld windowed windowed (errAt t) first (t + (m + 1))) +
        (a + β * received windowed windowed (errAt t) second (t + (m + 1)) +
          γ * withheld windowed windowed (errAt t) second (t + (m + 1))) =
      (shaped ((a + a) + β * (t + t + (m + 1)) + γ * 1) (β * m) 0 (γ * m)
        (Nat.lt_of_lt_of_le pos (Nat.le_trans (Nat.le_add_right a a)
          (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_add_right _ _))))).carrier ∧
    (a + β * received answering answering (errAt t) first (t + (m + 1)) +
          γ * withheld answering answering (errAt t) first (t + (m + 1))) +
        (a + β * received answering answering (errAt t) second (t + (m + 1)) +
          γ * withheld answering answering (errAt t) second (t + (m + 1))) =
      (shaped ((a + a) + β * (t + t + (m + 1)) + γ * 1) (β * m) 0 (γ * m)
        (Nat.lt_of_lt_of_le pos (Nat.le_trans (Nat.le_add_right a a)
          (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_add_right _ _))))).other := by
  have sums := echo_and_window_sums t m
  constructor
  · rw [pair_sum, sums.2.2.1, sums.2.2.2]
    show (a + a) + β * (t + t + (m + m + 1)) + γ * 1 = (a + a) + β * (t + t + (m + 1)) + γ * 1 + β * m + 0
    exact window_arith a β γ t m
  · rw [pair_sum, sums.1, sums.2.1]
    show (a + a) + β * (t + t + (m + 1)) + γ * (m + 1) = (a + a) + β * (t + t + (m + 1)) + γ * 1 + γ * m + 0
    rw [Nat.add_assoc _ (γ * 1), ← Nat.left_distrib, Nat.add_comm 1 m]
    rfl

open RuleCapture RuleShaping in
/-- **So under complete assortment, with one error a pair and at least one step after it, windowed
waiting is weakly favoured against answering exactly where `γ ≤ β`.** A wrapper of
`assorted_favours_iff`; the strict forms are `window_echo_select_iff` and `window_echo_lt_iff`. -/
theorem window_echo_favours_iff {A β γ m : Nat} (pos : 0 < A) (mpos : 0 < m) :
    CarrierCounts.favours (shaped A (β * m) 0 (γ * m) pos) ↔ γ ≤ β :=
  assorted_favours_iff pos mpos

open RuleCapture RuleShaping in
/-- **The strict forms, under complete assortment.** With the window pairs as carriers present,
selection by the rule after shaping raises their share strictly exactly where `γ < β` and lowers
it strictly exactly where `β < γ`: there the echo is selected for. A wrapper of
`assorted_raises_iff` and `assorted_lowers_iff` with `n = m`. -/
theorem window_echo_select_iff {A β γ m : Nat} (pos : 0 < A) (mpos : 0 < m) {x : CarrierCounts}
    (some : 0 < x.carrier) :
    (x.carrier * (CarrierCounts.select x (shaped A (β * m) 0 (γ * m) pos)).other <
        (CarrierCounts.select x (shaped A (β * m) 0 (γ * m) pos)).carrier * x.other ↔ γ < β) ∧
      ((CarrierCounts.select x (shaped A (β * m) 0 (γ * m) pos)).carrier * x.other <
        x.carrier * (CarrierCounts.select x (shaped A (β * m) 0 (γ * m) pos)).other ↔ β < γ) :=
  ⟨assorted_raises_iff pos mpos some, assorted_lowers_iff pos mpos some⟩

/-- A window holder beside a window holder, the first erring once, at step `t`. -/
def windowErrAt (t : Nat) : Place := ⟨fun _ => windowed, fun _ => true, errAt t, first⟩

/-- An answerer beside an answerer, the first erring once, at step `t`. -/
def answerErrAt (t : Nat) : Place := ⟨fun _ => answering, fun _ => false, errAt t, first⟩

/-- What the two pairs leave, with `A = 2 a + β (2 t + m + 1) + γ`: the window pair `A + β m`, the
answerer pair `A + γ m`, over `t + (m + 1)` steps. -/
theorem echo_pair_sums (a β γ t m : Nat) :
    (windowErrAt t).offspring a β γ (t + (m + 1)) + (windowErrAt t).other.offspring a β γ (t + (m + 1)) =
        (a + a) + β * (t + t + (m + 1)) + γ * 1 + β * m ∧
      (answerErrAt t).offspring a β γ (t + (m + 1)) + (answerErrAt t).other.offspring a β γ (t + (m + 1)) =
        (a + a) + β * (t + t + (m + 1)) + γ * 1 + γ * m := by
  have sums := echo_and_window_sums t m
  constructor
  · show (a + β * received windowed windowed (errAt t) first (t + (m + 1)) +
          γ * withheld windowed windowed (errAt t) first (t + (m + 1))) +
        (a + β * received windowed windowed (errAt t) second (t + (m + 1)) +
          γ * withheld windowed windowed (errAt t) second (t + (m + 1))) = _
    rw [pair_sum, sums.2.2.1, sums.2.2.2]
    exact window_arith a β γ t m
  · show (a + β * received answering answering (errAt t) first (t + (m + 1)) +
          γ * withheld answering answering (errAt t) first (t + (m + 1))) +
        (a + β * received answering answering (errAt t) second (t + (m + 1)) +
          γ * withheld answering answering (errAt t) second (t + (m + 1))) = _
    rw [pair_sum, sums.1, sums.2.1]
    show (a + a) + β * (t + t + (m + 1)) + γ * (m + 1) = (a + a) + β * (t + t + (m + 1)) + γ * 1 + γ * m
    rw [Nat.add_assoc _ (γ * 1), ← Nat.left_distrib, Nat.add_comm 1 m]

/-- **The echo, strictly, on the pairs' offspring.** With one error by the first of each pair at
step `t`, over `t + (m + 1)` steps with `m > 0`, a window pair leaves strictly more than an answerer pair exactly where `γ < β`, and strictly less exactly where
`β < γ`. No positivity of `a` is needed. A corollary of `echo_and_window_sums`. -/
theorem window_echo_lt_iff (a β γ t m : Nat) (mpos : 0 < m) :
    ((answerErrAt t).offspring a β γ (t + (m + 1)) + (answerErrAt t).other.offspring a β γ (t + (m + 1)) <
        (windowErrAt t).offspring a β γ (t + (m + 1)) + (windowErrAt t).other.offspring a β γ (t + (m + 1))
        ↔ γ < β) ∧
      ((windowErrAt t).offspring a β γ (t + (m + 1)) + (windowErrAt t).other.offspring a β γ (t + (m + 1)) <
        (answerErrAt t).offspring a β γ (t + (m + 1)) + (answerErrAt t).other.offspring a β γ (t + (m + 1))
        ↔ β < γ) := by
  rw [(echo_pair_sums a β γ t m).1, (echo_pair_sums a β γ t m).2]
  exact ⟨⟨fun h => Naturals.lt_of_mul_lt_mul_left (m := m)
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.mul_comm m γ))
        (Nat.lt_of_lt_of_le (Nat.lt_of_add_lt_add_left h) (Nat.le_of_eq (Nat.mul_comm β m)))),
    fun h => Nat.add_lt_add_left (Nat.mul_lt_mul_of_pos_right h mpos) _⟩,
   ⟨fun h => Naturals.lt_of_mul_lt_mul_left (m := m)
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.mul_comm m β))
        (Nat.lt_of_lt_of_le (Nat.lt_of_add_lt_add_left h) (Nat.le_of_eq (Nat.mul_comm γ m)))),
    fun h => Nat.add_lt_add_left (Nat.mul_lt_mul_of_pos_right h mpos) _⟩⟩

/-- A window holder beside an alternator. -/
def windowAlternator : Place :=
  ⟨fun p => match p with | first => windowed | second => alternating,
   fun p => match p with | first => true | second => false, noErrors, first⟩

/-- **Beside an alternator, a window holder leaves `(β + γ) · half (n + 1)` less than the
alternator.** -/
theorem window_below_alternator (a β γ n : Nat) :
    windowAlternator.offspring a β γ n + (β + γ) * half (n + 1) =
      windowAlternator.other.offspring a β γ n := by
  show a + β * received windowed alternating noErrors first n +
      γ * withheld windowed alternating noErrors first n + (β + γ) * half (n + 1) =
    a + β * received windowed alternating noErrors second n +
      γ * withheld windowed alternating noErrors second n
  rw [(counts_windowed_alternating n).1, (counts_windowed_alternating n).2.1,
    (counts_windowed_alternating n).2.2.1, (counts_windowed_alternating n).2.2.2, Nat.mul_zero,
    Nat.add_zero, add_mul_split, ← Nat.add_assoc, Nat.add_assoc a, ← Nat.left_distrib, half_add]

/-- **In mixed pairs of window holders and alternators, windowed waiting is never selected for**,
whatever `β` and `γ`: every window holder leaves at most every alternator. -/
theorem window_never_rises_beside_alternators (a β γ n y : Nat) :
    ¬ discord (whole (List.replicate y [windowAlternator, windowAlternator.other]))
        (Place.offspring a β γ n) (amountOf Place.kind) <
      concord (whole (List.replicate y [windowAlternator, windowAlternator.other]))
        (Place.offspring a β γ n) (amountOf Place.kind) :=
  have places : ∀ s, s ∈ whole (List.replicate y [windowAlternator, windowAlternator.other]) →
      s = windowAlternator ∨ s = windowAlternator.other := fun s ms => by
    obtain ⟨g, mg, mem⟩ := ListTests.mem_flatMap_iff.mp ms
    have same := mem_replicate_eq mg
    subst same
    cases mem with
    | head => exact .inl rfl
    | tail _ h => cases h with
      | head => exact .inr rfl
      | tail _ h => cases h
  kind_not_rises_of_below fun p q mp mq hp hq => by
    rcases places p mp with h | h <;> rcases places q mq with h' | h' <;> subst h <;> subst h'
    · exact Bool.noConfusion hq
    · exact Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (window_below_alternator a β γ n))
    · exact Bool.noConfusion hp
    · exact Bool.noConfusion hp

/-- An alternator beside an alternator. -/
def alternatorPair : Place := ⟨fun _ => alternating, fun _ => false, noErrors, first⟩

/-- A window holder beside a window holder, with no errors. -/
def windowPair : Place := ⟨fun _ => windowed, fun _ => true, noErrors, first⟩

open RuleCapture RuleShaping in
/-- **Under complete assortment against alternators, the rule after shaping**: over `n` steps a
window holder beside a window holder leaves the shapers' count, and an alternator beside an
alternator the others', of `shaped (a + β · half n) (β · half (n + 1)) 0 (γ · half (n + 1))`; so
windowed waiting is weakly favoured exactly where `γ ≤ β`, for `n ≥ 1` (`assorted_favours_iff`
with `half (n + 1)` steps). -/
theorem window_alternator_shaped (a β γ n : Nat) (pos : 0 < a) :
    windowPair.offspring a β γ n =
        (shaped (a + β * half n) (β * half (n + 1)) 0 (γ * half (n + 1))
          (Nat.lt_of_lt_of_le pos (Nat.le_add_right _ _))).carrier ∧
      alternatorPair.offspring a β γ n =
        (shaped (a + β * half n) (β * half (n + 1)) 0 (γ * half (n + 1))
          (Nat.lt_of_lt_of_le pos (Nat.le_add_right _ _))).other := by
  constructor
  · show a + β * received windowed windowed noErrors first n +
      γ * withheld windowed windowed noErrors first n = a + β * half n + β * half (n + 1) + 0
    rw [(counts_giving (f := windowed) (g := windowed) rfl rfl first n).1,
      (counts_giving (f := windowed) (g := windowed) rfl rfl first n).2, Nat.mul_zero, Nat.add_zero,
      Nat.add_zero, Nat.add_assoc, ← Nat.left_distrib, half_add]
  · show a + β * received alternating alternating noErrors first n +
      γ * withheld alternating alternating noErrors first n = a + β * half n + γ * half (n + 1) + 0
    rw [(counts_alternating_alternating n).1, (counts_alternating_alternating n).2.1]
    rfl

theorem half_succ_pos (k : Nat) : 0 < half (k + 1 + 1) := Nat.succ_pos (half k)

open RuleCapture RuleShaping in
/-- **So against alternators under complete assortment, windowed waiting is weakly favoured exactly
where `γ ≤ β`**, over any `k + 1` steps. -/
theorem window_alternator_favours_iff {a β γ : Nat} (pos : 0 < a) (k : Nat) :
    CarrierCounts.favours (shaped (a + β * half (k + 1)) (β * half (k + 1 + 1)) 0
      (γ * half (k + 1 + 1)) (Nat.lt_of_lt_of_le pos (Nat.le_add_right _ _))) ↔ γ ≤ β :=
  assorted_favours_iff _ (half_succ_pos k)

/-! ## Where what a gift brings comes from -/

/-! ### Need asymmetry within the pair -/

namespace Needs

/-- The two formations of a closed pair, each depending on its own standing, and two further
relata: a child, which comes to stand where the giver gives to it after its gift, and a pool beyond
the pair, on which that later giving draws. -/
inductive Member where
  | giver
  | receiver
  | child
  | pool

open Member

/-- What the giver moves to the child across step `1`, with its need `k`: one unit where `k ≤ 1`,
where the giver is then active, and nothing otherwise. -/
def onward : Nat → Nat
  | 0 => 1
  | 1 => 1
  | _ + 2 => 0

/-- The giver stands at two and the receiver at one; across step `0` the giver moves one unit to
the receiver, and across step `1` it moves `onward k` from the pool to the child. -/
def level (k : Nat) : Nat → Member → Nat
  | 0, giver => 2
  | 0, receiver => 1
  | _ + 1, giver => 1
  | _ + 1, receiver => 2
  | 0, child => 0
  | 1, child => 0
  | _ + 2, child => onward k
  | 0, pool => 1
  | 1, pool => 1
  | _ + 2, pool => 1 - onward k

/-- Each formation of the pair depends on its own standing; nothing depends on the child or the
pool. -/
def requires : Member → Member → Prop
  | giver, giver => True
  | giver, receiver => False
  | giver, child => False
  | giver, pool => False
  | receiver, giver => False
  | receiver, receiver => True
  | receiver, child => False
  | receiver, pool => False
  | child, _ => False
  | pool, _ => False

/-- The giver needs `k`, the receiver two. -/
def need (k : Nat) : Member → Nat
  | giver => k
  | receiver => 2
  | child => 1
  | pool => 1

/-- The pair's formations are active exactly where supported; the child and the pool are not. -/
def active (k : Nat) : Nat → Member → Prop
  | 0, giver => k ≤ 2
  | 0, receiver => False
  | _ + 1, giver => k ≤ 1
  | _ + 1, receiver => True
  | _, child => False
  | _, pool => False

/-- The pair's web, with the giver's need `k`. -/
def web (k : Nat) : Web Member Member :=
  ⟨level k, active k, fun _ => requires, fun _ f _ => need k f, fun _ => requires⟩

/-- Across step `0` the giver takes one unit from its own standing; across step `1` it takes
`onward k` from the pool; nothing else is taken. -/
def take (k : Nat) : Nat → Member → Member → Nat
  | 0, giver, giver => 1
  | 0, giver, receiver => 0
  | 0, giver, child => 0
  | 0, giver, pool => 0
  | 1, giver, giver => 0
  | 1, giver, receiver => 0
  | 1, giver, child => 0
  | 1, giver, pool => onward k
  | _ + 2, giver, _ => 0
  | _, receiver, _ => 0
  | _, child, _ => 0
  | _, pool, _ => 0

/-- Across step `0` the giver gives one unit to the receiver; across step `1` it gives `onward k`
to the child; nothing else is given. -/
def give (k : Nat) : Nat → Member → Member → Nat
  | 0, giver, giver => 0
  | 0, giver, receiver => 1
  | 0, giver, child => 0
  | 0, giver, pool => 0
  | 1, giver, giver => 0
  | 1, giver, receiver => 0
  | 1, giver, child => onward k
  | 1, giver, pool => 0
  | _ + 2, giver, _ => 0
  | _, receiver, _ => 0
  | _, child, _ => 0
  | _, pool, _ => 0

/-- The giver takes part at every step. -/
def present : Nat → List Member := fun _ => [giver]

def flow (k : Nat) : Flow Member Member := ⟨present, take k, give k⟩

theorem balances (k : Nat) : (flow k).Balances (web k)
  | 0, giver => rfl
  | 0, receiver => rfl
  | 0, child => rfl
  | 0, pool => rfl
  | 1, giver => rfl
  | 1, receiver => rfl
  | 1, child => match k with
    | 0 => rfl
    | 1 => rfl
    | _ + 2 => rfl
  | 1, pool => match k with
    | 0 => rfl
    | 1 => rfl
    | _ + 2 => rfl
  | _ + 2, giver => rfl
  | _ + 2, receiver => rfl
  | _ + 2, child => rfl
  | _ + 2, pool => rfl

theorem acting {k : Nat} (le : k ≤ 2) : (flow k).Acting (web k)
  | 0, giver, _, _, _ => le
  | 1, giver, child, _, pos => match k, pos with
    | 0, _ => Nat.zero_le 1
    | 1, _ => Nat.le_refl 1
    | _ + 2, pos => absurd pos (Nat.lt_irrefl 0)
  | 1, giver, giver, _, pos => absurd pos (Nat.lt_irrefl 0)
  | 1, giver, receiver, _, pos => absurd pos (Nat.lt_irrefl 0)
  | 1, giver, pool, _, pos => absurd pos (Nat.lt_irrefl 0)
  | _ + 2, giver, _, _, pos => absurd pos (Nat.lt_irrefl 0)
  | _, receiver, _, mem, _ => nomatch mem
  | _, child, _, mem, _ => nomatch mem
  | _, pool, _, mem, _ => nomatch mem

theorem dependent (k : Nat) : (web k).Dependent
  | 0, giver, le => fun c req => match c, req with
    | giver, _ => le
  | 0, receiver, act => act.elim
  | _ + 1, giver, le => fun c req => match c, req with
    | giver, _ => le
  | _ + 1, receiver, _ => fun c req => match c, req with
    | receiver, _ => Nat.le_refl 2
  | 0, child, act => act.elim
  | _ + 1, child, act => act.elim
  | 0, pool, act => act.elim
  | _ + 1, pool, act => act.elim

/-- Nothing flows into the pair from beyond it across any step. -/
theorem closed (k : Nat) : ∀ t, (flow k).inflow [giver, receiver] t = 0
  | 0 => rfl
  | 1 => rfl
  | _ + 2 => rfl

theorem receiver_unsupported (k : Nat) : ¬ (web k).Supported 0 receiver :=
  fun sup => Nat.not_succ_le_self 1 (sup receiver trivial)

theorem receiver_supported (k t : Nat) : (web k).Supported (t + 1) receiver := fun c req =>
  match c, req with
  | receiver, _ => Nat.le_refl 2

/-- **With needs one and two, one unit moved makes the receiver supported and leaves the giver
supported**, in a balanced pair into which nothing flows: across step `0` the supported formations
of the pair go from the giver alone to both, and both stay supported. -/
theorem asymmetry_gains :
    (web 1).Supported 0 giver ∧ ¬ (web 1).Supported 0 receiver ∧
      (∀ t, (web 1).Supported (t + 1) giver ∧ (web 1).Supported (t + 1) receiver) :=
  ⟨dependent 1 0 giver (Nat.le_succ 1), receiver_unsupported 1,
   fun t => ⟨dependent 1 (t + 1) giver (Nat.le_refl 1), receiver_supported 1 t⟩⟩

/-- **With needs two and two, the same move only moves support**: the giver is supported before
the step and not after it, the receiver after it and not before. -/
theorem symmetry_moves :
    (web 2).Supported 0 giver ∧ ¬ (web 2).Supported 0 receiver ∧
      (∀ t, ¬ (web 2).Supported (t + 1) giver ∧ (web 2).Supported (t + 1) receiver) :=
  ⟨dependent 2 0 giver (Nat.le_refl 2), receiver_unsupported 2,
   fun t => ⟨fun sup => Nat.not_succ_le_self 1 (sup giver trivial), receiver_supported 2 t⟩⟩

/-- **After its gift, the giver can still leave a descendant under needs one and two, and cannot
under needs two and two.** The giver takes part at every step. Under needs two and two it is
unsupported at every step after its gift, so it leaves no descendant across any of them
(`Flow.unsupported_childless`, from its support, not from its absence). Under needs one and two it
stays supported, and the child descends from it across step `1`, the unit drawn from the pool
beyond the pair. -/
theorem childless :
    (∀ t k, giver ∈ (flow k).present (t + 1)) ∧
      (∀ t x, ¬ (flow 2).DescendsAt (web 2) (t + 1) x giver) ∧
      (flow 1).DescendsAt (web 1) 1 child giver :=
  ⟨fun _ _ => .head _,
   fun t x => Flow.unsupported_childless (acting (Nat.le_refl 2)) (dependent 2)
      (symmetry_moves.2.2 t).1 x,
   ⟨.head _, Nat.zero_lt_one, ⟨Nat.lt_irrefl 0, Nat.zero_lt_one⟩⟩⟩

end Needs

namespace Needs

open Member

/-- **Read with the receiver as the family and the giver as the beyond, the gift is a rise drawn
from beyond.** With needs two and two the giver's slack is zero and nothing flows in, so the rise
breaks the giver's dependence (`Flow.Balances.breaks_beyond_inflow`, its premises met). -/
theorem symmetric_breaks :
    ∃ c, c ∈ [giver] ∧ (web 2).Broken 0 giver c :=
  Flow.Balances.breaks_beyond_inflow (ds := [receiver]) (dep := fun _ => giver) (balances 2)
    (fun c mem => match c, mem with
      | giver, _ => ⟨trivial, Nat.le_refl 2⟩)
    (show 1 + 0 + 0 < 2 + 0 from Nat.lt_succ_self 1)

/-- **With needs one and two the rise is the giver's slack**: the receiver rises by one, the giver
stands one above its need, nothing flows in, and the giver's dependence is kept. -/
theorem asymmetric_within_slack :
    (web 1).stock [receiver] 1 = (web 1).stock [receiver] 0 + (web 1).slack (fun _ => giver) [giver] 0 ∧
      (flow 1).inflow [receiver, giver] 0 = 0 ∧ (web 1).Kept 0 giver giver :=
  ⟨rfl, rfl, ⟨Nat.le_succ 1, Nat.le_refl 1⟩⟩

end Needs

/-! ### Renewal from outside -/

namespace Renewed

/-- A renewer beyond the pair, the giver and the receiver. -/
inductive Member where
  | renewer
  | giver
  | receiver

open Member

/-- The giver and the receiver each depend on their own standing; the renewer depends on nothing. -/
def requires : Member → Member → Prop
  | renewer, _ => False
  | giver, renewer => False
  | giver, giver => True
  | giver, receiver => False
  | receiver, renewer => False
  | receiver, giver => False
  | receiver, receiver => True

/-- Everything stands at one and every need is one; every formation is active. -/
def web : Web Member Member :=
  ⟨fun _ _ => 1, fun _ _ => True, fun _ => requires, fun _ _ _ => 1, fun _ => requires⟩

/-- At every step the giver takes one unit from its own standing and the receiver one from its
own. -/
def take : Member → Member → Nat
  | giver, giver => 1
  | receiver, receiver => 1
  | renewer, _ => 0
  | giver, renewer => 0
  | giver, receiver => 0
  | receiver, renewer => 0
  | receiver, giver => 0

/-- At every step the renewer gives one unit to the giver, and the giver one to the receiver. -/
def give : Member → Member → Nat
  | renewer, giver => 1
  | giver, receiver => 1
  | renewer, renewer => 0
  | renewer, receiver => 0
  | giver, renewer => 0
  | giver, giver => 0
  | receiver, _ => 0

def flow : Flow Member Member :=
  ⟨fun _ => [renewer, giver, receiver], fun _ => take, fun _ => give⟩

theorem balances : flow.Balances web
  | _, renewer => rfl
  | _, giver => rfl
  | _, receiver => rfl

theorem acting : flow.Acting web := fun _ _ _ _ _ => trivial

theorem dependent : web.Dependent := fun _ f _ c req => match f, c, req with
  | giver, giver, _ => Nat.le_refl 1
  | receiver, receiver, _ => Nat.le_refl 1

/-- The renewer's giving does not require the giver's standing. -/
theorem renewer_free : ∀ t c, ¬ web.requires t renewer c := fun _ _ req => req

/-- **The flux carried into the pair is one unit at every step**, given by the renewer. -/
theorem inflow_one (t : Nat) : flow.inflow [giver, receiver] t = 1 := rfl

theorem total_steps_one : ∀ T N, total (steps T N) (fun _ => 1) = N
  | _, 0 => rfl
  | T, N + 1 => (congrArg (1 + ·) (total_steps_one (T + 1) N)).trans (Nat.add_comm 1 N)

/-- **Renewal from outside: the giver gives at every step and stays supported**, its standing never
falling, and what it gives over any stretch is what flows into the pair over it: the gift carries
renewal the giver does not need. -/
theorem renewal_carried :
    (∀ t, flow.give t giver receiver = 1 ∧ web.Supported t giver ∧ web.Supported t receiver ∧
        web.level (t + 1) giver = web.level t giver) ∧
      ∀ T N, total (steps T N) (fun t => flow.give t giver receiver) = N ∧
        total (steps T N) (flow.inflow [giver, receiver]) = N :=
  ⟨fun t => ⟨rfl, dependent t giver trivial, dependent t receiver trivial, rfl⟩,
   fun T N => ⟨total_steps_one T N, total_steps_one T N⟩⟩

end Renewed

/-! ### A factor read on a web, bounded by it -/

/-- What `h` gives at the steps below `n` at which `p` holds. -/
def tallyBy (p : Nat → Bool) (h : Nat → Nat) : Nat → Nat
  | 0 => 0
  | n + 1 => tallyBy p h n + cond (p n) (h n) 0

/-- A factor at most `h` at each counted step, times the count, is at most what `h` gives at the
counted steps. -/
theorem mul_tally_le {p : Nat → Bool} {h : Nat → Nat} {β : Nat} :
    ∀ n, (∀ t, t < n → p t = true → β ≤ h t) → β * tally p n ≤ tallyBy p h n
  | 0, _ => Nat.le_of_eq (Nat.mul_zero β)
  | n + 1, le => by
    have ih := mul_tally_le n (fun t lt => le t (Nat.lt_succ_of_lt lt))
    show β * (tally p n + cond (p n) 1 0) ≤ tallyBy p h n + cond (p n) (h n) 0
    cases hp : p n with
    | true =>
      show β * tally p n + β ≤ tallyBy p h n + h n
      exact Nat.add_le_add ih (le n (Nat.lt_succ_self n) hp)
    | false =>
      show β * tally p n ≤ tallyBy p h n
      exact ih

/-- **Without a break beyond, a step's rise is at most the slack beyond and the inflow.** In a
balanced flow, where each condition beyond is depended on at a need it meets (`Web.MetOn`) and none
of those dependences breaks across the step, a family whose stock rises by `β` across it rises, with
what the whole loses, by at most the slack of those dependences and the whole's inflow. The
contrapositive of `Flow.Balances.breaks_beyond_inflow`. -/
theorem rise_le_slack_inflow {F C : Type} {L : Flow F C} {W : Web F C} (balances : L.Balances W)
    {dep : C → F} {ds rest : List C} {t β : Nat} (met : W.MetOn dep rest t)
    (unbroken : ∀ c, c ∈ rest → ¬ W.Broken t (dep c) c)
    (rise : W.stock ds (t + 1) = W.stock ds t + β) :
    β + L.lost (ds ++ rest) t ≤ W.slack dep rest t + L.inflow (ds ++ rest) t :=
  have ge : W.stock ds (t + 1) + L.lost (ds ++ rest) t ≤
      W.stock ds t + W.slack dep rest t + L.inflow (ds ++ rest) t :=
    match Nat.lt_or_ge (W.stock ds t + W.slack dep rest t + L.inflow (ds ++ rest) t)
        (W.stock ds (t + 1) + L.lost (ds ++ rest) t) with
    | .inl lt => match balances.breaks_beyond_inflow met lt with
      | ⟨c, mem, broken⟩ => absurd broken (unbroken c mem)
    | .inr ge => ge
  Naturals.le_of_add_le_add_left (k := W.stock ds t)
    (calc W.stock ds t + (β + L.lost (ds ++ rest) t)
        = W.stock ds (t + 1) + L.lost (ds ++ rest) t :=
          (Nat.add_assoc _ _ _).symm.trans (congrArg (· + L.lost (ds ++ rest) t) rise.symm)
      _ ≤ W.stock ds t + W.slack dep rest t + L.inflow (ds ++ rest) t := ge
      _ = W.stock ds t + (W.slack dep rest t + L.inflow (ds ++ rest) t) := Nat.add_assoc _ _ _)

/-- **`β` read on a web is bounded by the web.** Read the factor `β` of `Place.offspring` on a
balanced flow: at each step below `n` at which the other place gives, a family `ds` (the
receiver's line) rises by `β`, each condition beyond (`rest`) is depended on at a need it meets,
and none of those dependences breaks. Then `β` times what the place received is at most the slack
beyond and the inflow, summed over the steps at which it received. The reading is the hypothesis:
nothing here makes the pair's run a flow on the web, or offspring a stock. -/
theorem Place.received_factor_le {F C : Type} {L : Flow F C} {W : Web F C}
    (balances : L.Balances W) {dep : C → F} {ds rest : List C} {β : Nat} (s : Place) (n : Nat)
    (reading : ∀ t, t < n → gives (s.law first) (s.law second) s.errs (partner s.side) t = true →
      W.MetOn dep rest t ∧ (∀ c, c ∈ rest → ¬ W.Broken t (dep c) c) ∧
        W.stock ds (t + 1) = W.stock ds t + β) :
    β * s.received n ≤ tallyBy (gives (s.law first) (s.law second) s.errs (partner s.side))
      (fun t => W.slack dep rest t + L.inflow (ds ++ rest) t) n :=
  mul_tally_le n fun t lt given => match reading t lt given with
    | ⟨met, unbroken, rise⟩ =>
      Nat.le_trans (Nat.le_add_right β _) (rise_le_slack_inflow balances met unbroken rise)

/-- **`γ` read on a web is bounded by the web, the same way.** At each step below `n` at which the
place withholds, its own line `ds` rises by `γ` with no dependence beyond broken; then `γ` times
what it withheld is at most the slack beyond and the inflow summed over those steps. -/
theorem Place.withheld_factor_le {F C : Type} {L : Flow F C} {W : Web F C}
    (balances : L.Balances W) {dep : C → F} {ds rest : List C} {γ : Nat} (s : Place) (n : Nat)
    (reading : ∀ t, t < n → (!gives (s.law first) (s.law second) s.errs s.side t) = true →
      W.MetOn dep rest t ∧ (∀ c, c ∈ rest → ¬ W.Broken t (dep c) c) ∧
        W.stock ds (t + 1) = W.stock ds t + γ) :
    γ * s.withheld n ≤ tallyBy (fun t => !gives (s.law first) (s.law second) s.errs s.side t)
      (fun t => W.slack dep rest t + L.inflow (ds ++ rest) t) n :=
  mul_tally_le n fun t lt kept => match reading t lt kept with
    | ⟨met, unbroken, rise⟩ =>
      Nat.le_trans (Nat.le_add_right γ _) (rise_le_slack_inflow balances met unbroken rise)

/-- What `h` gives where it is zero at every counted step is zero. -/
theorem tallyBy_zero {p : Nat → Bool} {h : Nat → Nat} :
    ∀ n, (∀ t, t < n → p t = true → h t = 0) → tallyBy p h n = 0
  | 0, _ => rfl
  | n + 1, zero => by
    have ih := tallyBy_zero n (fun t lt => zero t (Nat.lt_succ_of_lt lt))
    show tallyBy p h n + cond (p n) (h n) 0 = 0
    cases hp : p n with
    | true =>
      show tallyBy p h n + h n = 0
      rw [ih, zero n (Nat.lt_succ_self n) hp]
    | false => exact ih

/-- **Where the beyond stands at its needs and nothing flows in, a received step raises nothing
without a break.** Under the reading of `Place.received_factor_le`, if at every received step below
`n` the slack beyond and the inflow are zero and the place received at least once, `β` is zero: a
positive `β` so read needs slack beyond (EL4c's second source, the giver's slack in `Needs`) or an
inflow (the first, `Renewed`), or a break (`Needs.symmetric_breaks`). A corollary. -/
theorem Place.received_factor_zero {F C : Type} {L : Flow F C} {W : Web F C}
    (balances : L.Balances W) {dep : C → F} {ds rest : List C} {β : Nat} (s : Place) (n : Nat)
    (reading : ∀ t, t < n → gives (s.law first) (s.law second) s.errs (partner s.side) t = true →
      W.MetOn dep rest t ∧ (∀ c, c ∈ rest → ¬ W.Broken t (dep c) c) ∧
        W.stock ds (t + 1) = W.stock ds t + β)
    (tight : ∀ t, t < n → gives (s.law first) (s.law second) s.errs (partner s.side) t = true →
      W.slack dep rest t + L.inflow (ds ++ rest) t = 0)
    (some : 0 < s.received n) : β = 0 :=
  match β, s.received_factor_le balances n reading with
  | 0, _ => rfl
  | b + 1, le => absurd (Nat.le_trans (Nat.le_trans some (Nat.le_of_eq (Nat.one_mul _).symm))
      (Nat.le_trans (Nat.mul_le_mul_right _ (Nat.succ_le_succ (Nat.zero_le b)))
        (Nat.le_trans le (Nat.le_of_eq (tallyBy_zero n tight)))))
      (Nat.lt_irrefl 0)

end PairSelection
end Becoming

-- recompiled against the final upstream scratch module (round 4)
