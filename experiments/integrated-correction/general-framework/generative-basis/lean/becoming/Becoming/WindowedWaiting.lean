import Becoming.Tolerance

/-!
# Windowed waiting: answering within a window, and the one-step laws of a pair

`Becoming.Withholding` runs giving that waits on giving with memory (`waitsAll`) and without
(`answers`), and `Becoming.Tolerance` the laws that keep inclusion (`KeepsInclusion`) and what
restoring needs. In a pair, tolerance of one is giving whatever comes (`AllBut.of_length_le`), so a
pair passes a withholding out only through time. This module states the law that waits on giving
within a window of steps, and the split of the one-step laws of a pair by keeping inclusion. Every
main law is stated on a run `Law.run next s` of the spine.

* **The one-step laws of a pair** (on truth values, `Bool`: giving decided). A one-step law
  `f own partner` says whether a holder gives at the next step from its own last step and its
  partner's; the eight laws with `f true true = true` keep mutual giving, and each is a table of
  four values (`table`, `eq_table_of`). Two holders of `f` run on the pair's state (`pairStep`);
  from one withholding after mutual giving (`oneWithheldBool`) the law *restores* where the pair
  gives together again at some step (`Restores`, `NeverRestores`). A holder facing a constant
  withholder runs on its own state (`againstWithholder`); it *answers* where it withholds at some
  step (`AnswersWithholder`, `NeverAnswers`). This is exactly `f true false = false`
  (`answersWithholder_iff`, `never_answers_of`), and exactly withholding at step 1
  (`answersWithholder_at_one`). A two-input law keeps inclusion where more giving in either input
  never gives less (`PairKeepsInclusion`); with mutual giving kept this is exactly that giving
  after mutual withholding gives giving after either one-sided step (`pairKeepsInclusion_iff`).
  The count is a statement: a table keeping mutual giving keeps inclusion exactly where it is one
  of five, named below (`pairKeepsInclusion_table_iff`; each of the five, `bothGave_keeps`,
  `partnerGave_keeps`, `ownGave_keeps`, `eitherGave_keeps`, `alwaysGives_keeps`), so three of the
  eight do not.
  - **Keeping inclusion splits restoring from answering** (headline, `keeps_split`). A law keeping
    mutual giving and inclusion either never restores after one withholding or never answers a
    constant withholder. Of the five, giving after mutual giving only (`bothGave`), answering
    (`partnerGave`) and repeating one's own step (`ownGave`) never restore
    (`bothGave_never_restores`, `partnerGave_never_restores`, `ownGave_never_restores`);
    withholding only after mutual withholding (`eitherGave`), giving always (`alwaysGives`) and
    repeating one's own step never answer (`eitherGave_never_answers`, `alwaysGives_never_answers`,
    `ownGave_never_answers`).
  - **Exactly one one-step law restores and answers, and it does not keep inclusion.** Among the
    laws keeping mutual giving, restoring and answering a constant withholder hold together
    exactly where the law is agreement of one's own last step with the partner's,
    `f a b = (a == b)` (`restores_and_answers_iff`). Agreement withholds on both sides at step 1
    and gives together at step 2 (`agreement_restores_at_two`), withholds against a constant
    withholder at step 1 and gives there at every even step (`agreement_answers_at_one`,
    `agreement_against`), and does not keep inclusion (`agreement_not_keeps`).
  - **Answering within a window of two keeps inclusion and does both** (`windowTwo_keeps`,
    `windowTwo_restores`, `windowTwo_answers`). The law gives where the partner gave at one of its
    last two steps (`windowTwo`, its inputs the partner's last step and the one before); the
    pair's state is its last two steps (`windowStep`), the start one withholding after a history
    of mutual giving. The pair is apart at step 0 and gives together at every step from step 1
    (`windowTwo_restores`, `windowTwo_restored_stays`); against a constant withholder the holder
    still gives at step 1 and withholds at every step from step 2 (`windowTwo_answers`,
    `windowTwo_answers_stays`).
  - **The alternator is never answered under a window of two** (`alternator_course`,
    `alternator_never_answered`, `alternator_gives_half`). A formation giving exactly where it
    withheld at its last step, beside a holder of the window of two, from its withholding at the
    start after a history of mutual giving: the course has period two, the holder gives at every
    step, and the alternator gives at every odd step and withholds at every even one.
* **Echo under `answers`, in a pair** (`Pair`, two formations each waiting on the other, a loop of
  two waits, `Pair.loop`). From one withholding after mutual giving, the withholding alternates
  exactly: at every even step the first withholds and the second gives, at every odd step the
  reverse (`Pair.echo`); so at every step exactly one gives (`Pair.exactly_one`) and the pair never
  gives together again (`Pair.never_together`). Its return at the first formation is
  `Withholding.withholding_returns` at a loop of two (`Pair.echo_returns`).
* **The Bool laws joined to the Prop laws of the pair.**
  - *Answering.* The course of two holders of `partnerGave` from `oneWithheldBool` is, at each step
    and formation, the course of `answers Pair.Waits` from `Pair.oneWithheld`
    (`Pair.partnerGave_course`); so `partnerGave_never_restores` is `Pair.never_together` read
    through it (`Pair.partnerGave_never_restores_of_echo`).
  - *Keeping inclusion.* A two-input law `f` keeps inclusion exactly where some Prop-valued
    two-input law agreeing with it on decided giving induces a law on the pair's configurations
    keeping inclusion in the sense of `Tolerance.KeepsInclusion`
    (`Pair.pairKeepsInclusion_iff_induced`; `Pair.induced`, `Pair.Agrees`). Answering is the
    induced law of the partner's step (`Pair.induced_partner`). The bridge is existential because
    it must be: the disjunctive normal form of answering, `(A ∧ B) ∨ (¬ A ∧ B)`, agrees with
    `partnerGave` (`Pair.agrees_dnf`), and the law it induces keeps inclusion exactly where every
    proposition is decided (`Pair.dnf_keeps_iff_em`, `Pair.dnf_keeps_em`); so where every agreeing
    law induced one keeping inclusion, excluded middle would hold (`Pair.all_agreeing_keeps_em`).
    These three are lemmas of the bridge, calibrations of the logic, not results: the law this
    normal form induces keeps inclusion only where every proposition is decided.
  - *The window of two.* The course of `windowStep` from `windowOneWithheld` is, at lags `0` and
    `1` of each formation, the course of `answersWithin 2 Pair.Waits` from the history in which
    only the first withholds, at lag `0` (`Pair.windowStep_course`); so that pair gives together
    at every step from step 1 (`Pair.window_restores`).
  - *The alternator* is joined to the clocked carrier below (`Pair.alternator_bridge`).
  - *Against a constant withholder.* The course of `windowAgainst` from `windowFacing` is, at
    lags `0` and `1`, the holder at `second` and the withholder at `first`, the clocked course
    below in which the first errs at every step (`Pair.windowAgainst_course`); so
    `windowTwo_answers_stays` is the clocked (d) read through it
    (`Pair.windowAgainst_withholds_of_clocked`).
* **Answering within a window on configurations** (Prop-valued, no decision of giving). The
  carrier is a configuration on `α × Nat`, the configuration at each lag of the history; the law
  `answersWithin w up` gives a formation at lag `0` where each formation it waits on gave at some
  lag below `w`, and shifts every lag by one (`answersWithin`). The carrier keeps the whole
  history; the law reads only lags below `w`.
  - **(a) A window of one is `answers`**, along every course: at lag `0`, the run of
    `answersWithin 1` from any history is the run of `answers` from its lag `0`
    (`window_one`).
  - **(b) Windowed laws keep inclusion on the carrier** (`answersWithin_keeps`), and keep it into
    every wider window (`answersWithin_into`, `window_mono`: a wider window gives no less). So
    `Tolerance.worst_start` and `Tolerance.restored_stays` apply as they stand
    (`window_worst_start`, `window_restored_stays`), and where every formation waits on some
    formation, total withholding is kept at every step and lag (`window_withheld_kept`): no window
    restores from total withholding.
  - **What a lag holds.** Lag `i` at step `m + i` is lag `0` at step `m` (`lag_shift`).
  - **(d) A constant withholder is answered within the window** (`withholder_answered`). Where a
    formation withholds at lag `0` at every step from `T` of the run itself, every formation
    waiting on it withholds at every step from `T + (w + 1)` under a window of `w + 1`. Under one
    homogeneous law such a formation withholds after the start only where something it waits on
    has no giving in its own window; a withholder whatever comes is the clocked form below.
  - **(c) A thin withholding in time is absorbed.** Errors are a supplied pattern
    `e : Nat → α → Prop`, folded into the state as a clock: the clocked law (`clocked`) applies at
    time `t` the time-indexed law `answersWithinErring e w up t`, which turns an intended giving
    at lag `0` into withholding where `e t` holds; each time's law keeps inclusion
    (`erring_keeps`). The run from all giving, erring at step `0` (`erringStart`), has at each
    step the configuration `erringRun` (`clocked_state`). Where no formation errs at `w`
    consecutive steps (`Spaced`), every formation gives at every step exactly where it does not
    err (`gives_unless_errs`). This is exact: `w + 1` consecutive errors at one formation, from
    step `t`, make every formation waiting on it withhold at step `t + w + 1` under a window of
    `w + 1` (`errs_answered`).
  - **(d), clocked.** A formation erring at every step from `T` is a constant withholder whatever
    comes; every formation waiting on it withholds at every step from `T + (w + 1)` under a window
    of `w + 1` (`withholder_answered_clocked`, a corollary of `errs_answered`).
  - **(e) A window never answers a formation giving at least once in every `w` steps.** Where, at
    every step `t`, a formation `c` gives at lag `0` at one of the steps `t, …, t + w - 1` of the
    clocked run, at every step it gives at some lag below `w`: whatever waits on it finds a giving
    of it in its window at every step (`window_holds_of_gaps`). Where no formation errs at `w`
    consecutive steps, this holds of every formation (`spaced_window_holds`, a corollary of
    `gives_unless_errs`); then each formation waiting on another withholds only at its own errors.
  - **No window both absorbs one error and answers a formation withholding at no two
    consecutive steps** (`Pair.not_absorbs_and_answers_spaced`). Under every window `w`: where,
    in the pair with the first erring at step `0` only (`Pair.firstErrsOnce`), the second gives at
    step 1, the window is at least two (`Pair.absorbs_needs_two`: a window of zero reads nothing,
    and a window of one answers the error at step 1); so under every error pattern of the pair
    spaced at two (`Spaced e 2`), every formation gives at every step at which it does not err,
    the spacing carried to the window by `spaced_mono`. The alternator is its instance
    (`Pair.not_absorbs_and_answers`): beside the second erring at every even step
    (`Pair.secondErrsEven`, the parity `even` by recursion), under every window of at least two
    the first gives at every step (`Pair.alternator_received_within`) and the second exactly at
    the odd steps (`Pair.alternator_gives_odd_within`).
    Each half holds apart: one error is absorbed under every window of at least two
    (`Pair.window_absorbs_within`; at two, with the first withholding at step `0`,
    `Pair.window_absorbs`), and a window of one answers the alternator at every odd step
    (`Pair.alternator_answered_one`).
  - **Witnesses.** At the window of two, the alternator's course (`Pair.alternator_received`,
    `Pair.alternator_gives_odd`, the `_within` forms at two) is the Bool alternator's
    (`Pair.alternator_bridge`). With the
    first erring at every step, the second gives at step 1 and withholds at every step from
    step 2, so the bound of the clocked (d) is reached (`Pair.withholder_answered_tight`). The
    hypotheses of the unclocked (d) hold together in total withholding, where
    `window_withheld_kept` already gives its conclusion (`Pair.withholder_answered_holds`, which
    states the conclusion, the premise met inside its proof), and
    away from it in a line of three (`Line`): a source waiting on itself and withheld at every
    lag, a relay waiting on it, which gives at step 0 and withholds from step 1
    (`Line.relay_course`), and a last waiting on the relay, which still gives at step 2 and
    withholds from step 3, so the unclocked bound is reached too
    (`Line.withholder_answered_reached`). In the ring of `Becoming.Withholding`, two consecutive
    errors at the first formation make the second withhold at step 2 under a window of two
    (`ringTwoErrors_answered`).

Lemmas and restatements, not results: `invariant`, `course_congr` and `course_rel` are lemmas of
runs (`invariant` is `Lasting.closed_orbit`, which is not in this module's imports);
`window_worst_start` and `window_restored_stays` are `Tolerance.worst_start` and
`Tolerance.restored_stays` applied to `answersWithin_keeps`; `answersWithholder_at_one` restates
`answersWithholder_iff` (by `Iff.rfl`); `agreement_restores`, `agreement_answers`
and `windowAgainst_withholds_of_clocked` are read off the theorems they cite;
`Pair.dnf_keeps_iff_em`, `Pair.dnf_keeps_em` and `Pair.all_agreeing_keeps_em` are lemmas of the
bridge `Pair.pairKeepsInclusion_iff_induced`, calibrations of the logic; `Pair.alternator_received`,
`Pair.alternator_gives_odd` and the first conjunct of `Pair.window_absorbs` are the `_within`
forms at two, and `Pair.not_absorbs_and_answers` is `Pair.not_absorbs_and_answers_spaced` at the
alternator; `Pair.withholder_answered_holds` is a witness lemma; and
`ListTests.or_true_iff`, `ListTests.not_true_iff`, `or_congr_both`, `lag_below_one`, `lag_below_two`,
`spaced_mono`, the congruence lemmas, the `within_*` and `firstAlwaysErrs_second` unfoldings,
`even` and `even_two_mul` are local lemmas (`even` repeats a parity of modules outside this one's
imports). `decide` is used only on closed decidable goals: the Bool-triple disequalities in
`pairKeepsInclusion_table_iff`, and, after case splits on both inputs, the six lemmas
`Pair.agrees_never`, `agrees_both`, `agrees_partner`, `agrees_own`, `agrees_either` and
`agrees_always` for the six monotone tables (iffs between Bool equalities and `False`, `∧`, the
partner's step, one's own step, `∨`, `True`); every axiom report is empty.

Modelling choices on which the laws depend: discrete steps; giving all-or-nothing per formation per
step, decided (`Bool`) in the one-step laws and Prop-valued on configurations; a fixed waiting
relation; the window's carrier the whole history at every lag (`α × Nat`), of which the law reads
the lags below `w`; errors a supplied pattern, counted, not given a chance, read by a clock carried
in the state; the start's history all giving. The readings (`answers` as tit-for-tat, `windowTwo`
as tit-for-two-tats, agreement as win-stay lose-shift, `waitsAll` as grim trigger) belong to the
chapter. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming
namespace WindowedWaiting

open Withholding Tolerance

universe u v

/-! ## Runs and their invariants -/

/-- **A set of states closed under a law holds along every course from it.** A lemma: it is
`Lasting.closed_orbit` on `Law.run`. -/
theorem invariant {S : Type u} {next : S → S} {s : S} (P : S → Prop) (start : P s)
    (closed : ∀ x, P x → P (next x)) : ∀ n, P ((Law.run next s).state n)
  | 0 => start
  | n + 1 => closed _ (invariant P start closed n)

/-- **Laws agreeing at every state have the same course.** A lemma. -/
theorem course_congr {S : Type u} {next next' : S → S} (same : ∀ x, next x = next' x) (s : S) :
    ∀ n, (Law.run next s).state n = (Law.run next' s).state n
  | 0 => rfl
  | n + 1 => (same _).trans (congrArg next' (course_congr same s n))

/-- **A relation kept by two laws relates their courses at every step.** A lemma, the form of the
bridges below. -/
theorem course_rel {S : Type u} {S' : Type v} {next : S → S} {next' : S' → S'}
    (R : S → S' → Prop) {s : S} {s' : S'} (start : R s s')
    (step : ∀ x y, R x y → R (next x) (next' y)) :
    ∀ n, R ((Law.run next s).state n) ((Law.run next' s').state n)
  | 0 => start
  | n + 1 => step _ _ (course_rel R start step n)

/-- Disjunction of equivalents. A lemma. -/
theorem or_congr_both {A A' B B' : Prop} (left : A ↔ A') (right : B ↔ B') : A ∨ B ↔ A' ∨ B' :=
  ⟨fun h => h.elim (fun a => .inl (left.mp a)) (fun b => .inr (right.mp b)),
   fun h => h.elim (fun a => .inl (left.mpr a)) (fun b => .inr (right.mpr b))⟩

/-! ## The one-step laws of a pair -/

/-- The two-input law given by its four values: both inputs giving, the first only, the second
only, neither. -/
def table (tt tf ft ff : Bool) : Bool → Bool → Bool
  | true, true => tt
  | true, false => tf
  | false, true => ft
  | false, false => ff

/-- **Every two-input law is its table.** -/
theorem eq_table_of {f : Bool → Bool → Bool} {tt tf ft ff : Bool} (h1 : f true true = tt)
    (h2 : f true false = tf) (h3 : f false true = ft) (h4 : f false false = ff) :
    ∀ a b, f a b = table tt tf ft ff a b
  | true, true => h1
  | true, false => h2
  | false, true => h3
  | false, false => h4

/-- A two-input law on decided giving keeps inclusion: more giving in either input never gives
less. -/
def PairKeepsInclusion (f : Bool → Bool → Bool) : Prop :=
  ∀ a a' b b' : Bool, (a = true → a' = true) → (b = true → b' = true) → f a b = true →
    f a' b' = true

/-- Two holders of the one-step law `f`: each gives at the next step by `f` from its own last step
and its partner's. -/
def pairStep (f : Bool → Bool → Bool) (x : Bool × Bool) : Bool × Bool :=
  (f x.1 x.2, f x.2 x.1)

/-- One withholding after mutual giving, on decided giving: the first withholds, the second
gives. -/
def oneWithheldBool : Bool × Bool := (false, true)

/-- The law restores: from one withholding, the pair gives together again at some step. -/
def Restores (f : Bool → Bool → Bool) : Prop :=
  ∃ n, (Law.run (pairStep f) oneWithheldBool).state n = (true, true)

/-- The law never restores: from one withholding, the pair never gives together again. -/
def NeverRestores (f : Bool → Bool → Bool) : Prop :=
  ∀ n, (Law.run (pairStep f) oneWithheldBool).state n ≠ (true, true)

/-- A holder of `f` facing a partner that withholds at every step. -/
def againstWithholder (f : Bool → Bool → Bool) (own : Bool) : Bool :=
  f own false

/-- The law answers a constant withholder: from its own giving, the holder withholds at some
step. -/
def AnswersWithholder (f : Bool → Bool → Bool) : Prop :=
  ∃ n, (Law.run (againstWithholder f) true).state n = false

/-- The law never answers a constant withholder: the holder gives at every step. -/
def NeverAnswers (f : Bool → Bool → Bool) : Prop :=
  ∀ n, (Law.run (againstWithholder f) true).state n = true

section Congruence

variable {f g : Bool → Bool → Bool}

theorem pairStep_congr (same : ∀ a b, f a b = g a b) (x : Bool × Bool) :
    pairStep f x = pairStep g x := by
  show (f x.1 x.2, f x.2 x.1) = (g x.1 x.2, g x.2 x.1)
  rw [same x.1 x.2, same x.2 x.1]

theorem restores_congr (same : ∀ a b, f a b = g a b) : Restores f ↔ Restores g :=
  ⟨fun ⟨n, both⟩ => ⟨n, (course_congr (pairStep_congr same) _ n).symm.trans both⟩,
   fun ⟨n, both⟩ => ⟨n, (course_congr (pairStep_congr same) _ n).trans both⟩⟩

theorem neverRestores_congr (same : ∀ a b, f a b = g a b) : NeverRestores f ↔ NeverRestores g :=
  ⟨fun never n both => never n ((course_congr (pairStep_congr same) _ n).trans both),
   fun never n both => never n ((course_congr (pairStep_congr same) _ n).symm.trans both)⟩

end Congruence

/-- Never restoring excludes restoring. -/
theorem NeverRestores.not {f : Bool → Bool → Bool} (never : NeverRestores f) : ¬ Restores f :=
  fun ⟨n, both⟩ => never n both

/-- **A law never restores where a set of states holding one withholding, closed under the law,
leaves out mutual giving.** -/
theorem never_restores_of {f : Bool → Bool → Bool} (inv : Bool × Bool → Bool)
    (start : inv oneWithheldBool = true) (closed : ∀ x, inv x = true → inv (pairStep f x) = true)
    (excludes : inv (true, true) = false) : NeverRestores f := by
  intro n both
  have held : inv ((Law.run (pairStep f) oneWithheldBool).state n) = true :=
    invariant (fun x => inv x = true) start closed n
  rw [both, excludes] at held
  exact Bool.noConfusion held

/-- **A holder giving after its own giving against withholding never answers.** -/
theorem never_answers_of {f : Bool → Bool → Bool} (keeps_giving : f true false = true) :
    NeverAnswers f :=
  invariant (fun o => o = true) rfl fun _ gives => by subst gives; exact keeps_giving

/-- **Answering a constant withholder is exactly withholding after one's own giving against
withholding.** -/
theorem answersWithholder_iff (f : Bool → Bool → Bool) :
    AnswersWithholder f ↔ f true false = false := by
  constructor
  · intro ⟨n, out⟩
    cases tf : f true false with
    | false => rfl
    | true => exact Bool.noConfusion ((never_answers_of tf n).symm.trans out)
  · intro tf
    exact ⟨1, tf⟩

/-- **A law answering a constant withholder answers it at step 1.** A restatement of
`answersWithholder_iff`, by `Iff.rfl`. -/
theorem answersWithholder_at_one (f : Bool → Bool → Bool) :
    AnswersWithholder f ↔ (Law.run (againstWithholder f) true).state 1 = false :=
  (answersWithholder_iff f).trans Iff.rfl

/-- Never answering excludes answering. -/
theorem NeverAnswers.not {f : Bool → Bool → Bool} (never : NeverAnswers f) :
    ¬ AnswersWithholder f :=
  fun ⟨n, out⟩ => Bool.noConfusion ((never n).symm.trans out)

/-- **Keeping inclusion, with mutual giving kept, is exactly that giving after mutual withholding
gives giving after either one-sided step.** -/
theorem pairKeepsInclusion_iff {f : Bool → Bool → Bool} (keepsBoth : f true true = true) :
    PairKeepsInclusion f ↔ (f false false = true → f true false = true) ∧
      (f false false = true → f false true = true) :=
  ⟨fun keeps => ⟨keeps false true false false (fun _ => rfl) id,
                 keeps false false false true id (fun _ => rfl)⟩,
   fun ⟨own, partner⟩ a a' b b' ha hb h => by
     cases a <;> cases a' <;> cases b <;> cases b' <;>
       first
       | exact h
       | exact keepsBoth
       | exact own h
       | exact partner h
       | exact Bool.noConfusion (ha rfl)
       | exact Bool.noConfusion (hb rfl)⟩

/-! ### The five laws keeping inclusion -/

/-- Giving after mutual giving only. -/
def bothGave : Bool → Bool → Bool := table true false false false

/-- Answering: giving exactly where the partner gave. -/
def partnerGave : Bool → Bool → Bool := table true false true false

/-- Repeating one's own step. -/
def ownGave : Bool → Bool → Bool := table true true false false

/-- Withholding only after mutual withholding. -/
def eitherGave : Bool → Bool → Bool := table true true true false

/-- Giving always. -/
def alwaysGives : Bool → Bool → Bool := table true true true true

/-- Agreement: giving where one's own last step and the partner's agree. -/
def agreement : Bool → Bool → Bool := table true false false true

/-- Answering is giving exactly where the partner gave. -/
theorem partnerGave_eq : ∀ a b, partnerGave a b = b
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

/-- Agreement is equality of the two last steps. -/
theorem agreement_eq : ∀ a b, agreement a b = (a == b)
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

theorem bothGave_keeps : PairKeepsInclusion bothGave :=
  (pairKeepsInclusion_iff rfl).mpr ⟨fun h => Bool.noConfusion h, fun h => Bool.noConfusion h⟩

theorem partnerGave_keeps : PairKeepsInclusion partnerGave :=
  (pairKeepsInclusion_iff rfl).mpr ⟨fun h => Bool.noConfusion h, fun h => Bool.noConfusion h⟩

theorem ownGave_keeps : PairKeepsInclusion ownGave :=
  (pairKeepsInclusion_iff rfl).mpr ⟨fun h => Bool.noConfusion h, fun h => Bool.noConfusion h⟩

theorem eitherGave_keeps : PairKeepsInclusion eitherGave :=
  (pairKeepsInclusion_iff rfl).mpr ⟨fun h => Bool.noConfusion h, fun h => Bool.noConfusion h⟩

theorem alwaysGives_keeps : PairKeepsInclusion alwaysGives :=
  (pairKeepsInclusion_iff rfl).mpr ⟨fun _ => rfl, fun _ => rfl⟩

/-- **Five of the eight laws keeping mutual giving keep inclusion**: a table keeping mutual giving
keeps inclusion exactly where its other three values are those of `bothGave`, `partnerGave`,
`ownGave`, `eitherGave` or `alwaysGives`. -/
theorem pairKeepsInclusion_table_iff (tf ft ff : Bool) :
    PairKeepsInclusion (table true tf ft ff) ↔
      (tf, ft, ff) = (false, false, false) ∨ (tf, ft, ff) = (false, true, false) ∨
        (tf, ft, ff) = (true, false, false) ∨ (tf, ft, ff) = (true, true, false) ∨
          (tf, ft, ff) = (true, true, true) := by
  cases tf <;> cases ft <;> cases ff
  all_goals first
    | exact ⟨fun _ => .inl rfl, fun _ => bothGave_keeps⟩
    | exact ⟨fun _ => .inr (.inl rfl), fun _ => partnerGave_keeps⟩
    | exact ⟨fun _ => .inr (.inr (.inl rfl)), fun _ => ownGave_keeps⟩
    | exact ⟨fun _ => .inr (.inr (.inr (.inl rfl))), fun _ => eitherGave_keeps⟩
    | exact ⟨fun _ => .inr (.inr (.inr (.inr rfl))), fun _ => alwaysGives_keeps⟩
    | exact ⟨fun keeps => Bool.noConfusion (keeps false true false false (fun _ => rfl) id rfl),
        fun h => absurd h (by decide)⟩
    | exact ⟨fun keeps => Bool.noConfusion (keeps false false false true id (fun _ => rfl) rfl),
        fun h => absurd h (by decide)⟩

/-- The two steps differ: one gives and the other withholds. -/
def apart (x : Bool × Bool) : Bool := x.1 != x.2

/-- Not both give. -/
def notBoth (x : Bool × Bool) : Bool := !(x.1 && x.2)

theorem bothGave_never_restores : NeverRestores bothGave :=
  never_restores_of notBoth rfl
    (fun ⟨a, b⟩ h => by cases a <;> cases b <;> first | rfl | exact Bool.noConfusion h) rfl

theorem partnerGave_never_restores : NeverRestores partnerGave :=
  never_restores_of apart rfl
    (fun ⟨a, b⟩ h => by cases a <;> cases b <;> first | rfl | exact Bool.noConfusion h) rfl

theorem ownGave_never_restores : NeverRestores ownGave :=
  never_restores_of apart rfl
    (fun ⟨a, b⟩ h => by cases a <;> cases b <;> first | rfl | exact Bool.noConfusion h) rfl

theorem ownGave_never_answers : NeverAnswers ownGave := never_answers_of rfl

theorem eitherGave_never_answers : NeverAnswers eitherGave := never_answers_of rfl

theorem alwaysGives_never_answers : NeverAnswers alwaysGives := never_answers_of rfl

/-- **Keeping inclusion splits restoring from answering** (headline). A one-step law of a pair
keeping mutual giving and inclusion either never restores after one withholding or never answers a
constant withholder. -/
theorem keeps_split {f : Bool → Bool → Bool} (keepsBoth : f true true = true)
    (keeps : PairKeepsInclusion f) : NeverRestores f ∨ NeverAnswers f := by
  cases tf : f true false with
  | true => exact Or.inr (never_answers_of tf)
  | false =>
    have ff : f false false = false := by
      cases h : f false false with
      | false => rfl
      | true =>
        exact Bool.noConfusion (tf.symm.trans (keeps false true false false (fun _ => rfl) id h))
    cases ft : f false true with
    | false =>
      exact Or.inl ((neverRestores_congr (eq_table_of keepsBoth tf ft ff)).mpr
        bothGave_never_restores)
    | true =>
      exact Or.inl ((neverRestores_congr (eq_table_of keepsBoth tf ft ff)).mpr
        partnerGave_never_restores)

/-- Keeping inclusion, a law never restores and answers together. -/
theorem keeps_not_both {f : Bool → Bool → Bool} (keepsBoth : f true true = true)
    (keeps : PairKeepsInclusion f) : ¬ (Restores f ∧ AnswersWithholder f) :=
  fun ⟨restores, answers⟩ => (keeps_split keepsBoth keeps).elim
    (fun never => never.not restores) (fun never => never.not answers)

/-! ### Agreement -/

/-- **Agreement restores at step 2**: both withhold at step 1 and both give at step 2. -/
theorem agreement_restores_at_two :
    (Law.run (pairStep agreement) oneWithheldBool).state 1 = (false, false) ∧
      (Law.run (pairStep agreement) oneWithheldBool).state 2 = (true, true) :=
  ⟨rfl, rfl⟩

/-- Read off `agreement_restores_at_two`. -/
theorem agreement_restores : Restores agreement := ⟨2, agreement_restores_at_two.2⟩

/-- **Agreement answers a constant withholder at step 1.** -/
theorem agreement_answers_at_one : (Law.run (againstWithholder agreement) true).state 1 = false :=
  rfl

/-- Read off `agreement_answers_at_one`. -/
theorem agreement_answers : AnswersWithholder agreement := ⟨1, agreement_answers_at_one⟩

/-- Against a constant withholder, agreement gives at every even step and withholds at every odd
one. -/
theorem agreement_against : ∀ k,
    (Law.run (againstWithholder agreement) true).state (2 * k) = true ∧
      (Law.run (againstWithholder agreement) true).state (2 * k + 1) = false
  | 0 => ⟨rfl, rfl⟩
  | k + 1 =>
    let odd := (agreement_against k).2
    have even : (Law.run (againstWithholder agreement) true).state (2 * (k + 1)) = true :=
      (congrArg (againstWithholder agreement) odd).trans rfl
    ⟨even, (congrArg (againstWithholder agreement) even).trans rfl⟩

/-- **Agreement does not keep inclusion**: after mutual withholding it gives, after its own giving
against withholding it withholds. -/
theorem agreement_not_keeps : ¬ PairKeepsInclusion agreement :=
  fun keeps => Bool.noConfusion (keeps false true false false (fun _ => rfl) id rfl)

/-- **Exactly one one-step law restores and answers: agreement.** Among the laws keeping mutual
giving, restoring after one withholding and answering a constant withholder hold together exactly
where the law is agreement of one's own last step with the partner's. -/
theorem restores_and_answers_iff {f : Bool → Bool → Bool} (keepsBoth : f true true = true) :
    Restores f ∧ AnswersWithholder f ↔ ∀ a b, f a b = (a == b) := by
  constructor
  · intro ⟨restores, answers⟩
    have tf := (answersWithholder_iff f).mp answers
    cases ft : f false true with
    | true =>
      cases ff : f false false with
      | true =>
        exact absurd ((restores_congr (eq_table_of keepsBoth tf ft ff)).mp restores)
          (never_restores_of apart rfl
            (fun ⟨a, b⟩ h => by cases a <;> cases b <;> first | rfl | exact Bool.noConfusion h)
            rfl).not
      | false =>
        exact absurd ((restores_congr (eq_table_of keepsBoth tf ft ff)).mp restores)
          partnerGave_never_restores.not
    | false =>
      cases ff : f false false with
      | true =>
        exact fun a b => (eq_table_of keepsBoth tf ft ff a b).trans (agreement_eq a b)
      | false =>
        exact absurd ((restores_congr (eq_table_of keepsBoth tf ft ff)).mp restores)
          bothGave_never_restores.not
  · intro same
    have toAgreement : ∀ a b, f a b = agreement a b :=
      fun a b => (same a b).trans (agreement_eq a b).symm
    exact ⟨(restores_congr toAgreement).mpr agreement_restores,
      (answersWithholder_iff f).mpr (toAgreement true false)⟩

/-! ### Answering within a window of two -/

/-- The window of two: give where the partner gave at one of its last two steps; the inputs are
the partner's last step and the one before. -/
def windowTwo (now before : Bool) : Bool := now || before

/-- Two holders of the window of two; the state is the pair's last step and the one before. -/
def windowStep (x : (Bool × Bool) × (Bool × Bool)) : (Bool × Bool) × (Bool × Bool) :=
  ((windowTwo x.1.2 x.2.2, windowTwo x.1.1 x.2.1), x.1)

/-- One withholding after a history of mutual giving. -/
def windowOneWithheld : (Bool × Bool) × (Bool × Bool) := (oneWithheldBool, (true, true))

/-- A holder of the window of two facing a partner withholding from the start, after a history of
mutual giving. -/
def windowAgainst (x : (Bool × Bool) × (Bool × Bool)) : (Bool × Bool) × (Bool × Bool) :=
  ((windowTwo x.1.2 x.2.2, false), x.1)

/-- The holder gives and the partner withholds, after a history of mutual giving. -/
def windowFacing : (Bool × Bool) × (Bool × Bool) := ((true, false), (true, true))

/-- **The window of two keeps inclusion** in its two inputs. -/
theorem windowTwo_keeps : PairKeepsInclusion windowTwo := by
  intro a a' b b' ha hb h
  cases a <;> cases a' <;> cases b <;> cases b' <;>
    first
    | rfl
    | exact Bool.noConfusion h
    | exact Bool.noConfusion (ha rfl)
    | exact Bool.noConfusion (hb rfl)

/-- **Restored, it stays restored**: the pair gives together at every step from step 1. -/
theorem windowTwo_restored_stays :
    ∀ n, ((Law.run windowStep windowOneWithheld).state (n + 1)).1 = (true, true)
  | 0 => rfl
  | n + 1 => by
    show (windowTwo ((Law.run windowStep windowOneWithheld).state (n + 1)).1.2 _,
      windowTwo ((Law.run windowStep windowOneWithheld).state (n + 1)).1.1 _) = (true, true)
    rw [windowTwo_restored_stays n]
    rfl

/-- **The window of two restores at step 1**: the pair is apart at step 0 and gives together at
step 1. -/
theorem windowTwo_restores :
    ((Law.run windowStep windowOneWithheld).state 0).1 = (false, true) ∧
      ((Law.run windowStep windowOneWithheld).state 1).1 = (true, true) :=
  ⟨rfl, windowTwo_restored_stays 0⟩

/-- **The window of two answers a constant withholder at step 2**: the holder gives at step 1 and
withholds at step 2. -/
theorem windowTwo_answers :
    ((Law.run windowAgainst windowFacing).state 1).1.1 = true ∧
      ((Law.run windowAgainst windowFacing).state 2).1.1 = false :=
  ⟨rfl, rfl⟩

/-- **Against a constant withholder the window of two withholds from step 2 on.** -/
theorem windowTwo_answers_stays :
    ∀ n, ((Law.run windowAgainst windowFacing).state (n + 2)).1.1 = false := by
  have later : ∀ n, ((Law.run windowAgainst windowFacing).state (n + 1)).1.2 = false ∧
      ((Law.run windowAgainst windowFacing).state (n + 1)).2.2 = false := by
    intro n
    induction n with
    | zero => exact ⟨rfl, rfl⟩
    | succ n ih => exact ⟨rfl, ih.1⟩
  intro n
  show windowTwo ((Law.run windowAgainst windowFacing).state (n + 1)).1.2
    ((Law.run windowAgainst windowFacing).state (n + 1)).2.2 = false
  rw [(later n).1, (later n).2]
  rfl

/-! ### The alternator against a window of two -/

/-- A holder of the window of two beside an alternator, which gives exactly where it withheld at
its last step. -/
def alternatorStep (x : (Bool × Bool) × (Bool × Bool)) : (Bool × Bool) × (Bool × Bool) :=
  ((windowTwo x.1.2 x.2.2, !x.1.2), x.1)

/-- The alternator withholds at the start, after a history of mutual giving. -/
def alternatorStart : (Bool × Bool) × (Bool × Bool) := ((true, false), (true, true))

/-- **The course has period two.** -/
theorem alternator_course : ∀ k,
    (Law.run alternatorStep alternatorStart).state (2 * k) = alternatorStart ∧
      (Law.run alternatorStep alternatorStart).state (2 * k + 1) = ((true, true), (true, false))
  | 0 => ⟨rfl, rfl⟩
  | k + 1 =>
    have even : (Law.run alternatorStep alternatorStart).state (2 * (k + 1)) = alternatorStart :=
      (congrArg alternatorStep (alternator_course k).2).trans rfl
    ⟨even, (congrArg alternatorStep even).trans rfl⟩

/-- **The alternator is never answered under a window of two**: the holder gives at every step. -/
theorem alternator_never_answered :
    ∀ n, ((Law.run alternatorStep alternatorStart).state n).1.1 = true := by
  have held := invariant (next := alternatorStep) (s := alternatorStart)
    (fun x => x.1.1 = true ∧ (x.1.2 || x.2.2) = true) ⟨rfl, rfl⟩
    (fun ⟨⟨a, b⟩, ⟨c, d⟩⟩ h => by
      cases a <;> cases b <;> cases c <;> cases d <;>
        first
        | exact ⟨rfl, rfl⟩
        | exact Bool.noConfusion h.1
        | exact Bool.noConfusion h.2)
  exact fun n => (held n).1

/-- **The alternator gives at half the steps**: at every odd step, and withholds at every even
one. -/
theorem alternator_gives_half : ∀ k,
    ((Law.run alternatorStep alternatorStart).state (2 * k)).1.2 = false ∧
      ((Law.run alternatorStep alternatorStart).state (2 * k + 1)).1.2 = true :=
  fun k => ⟨congrArg (fun x => x.1.2) (alternator_course k).1,
    congrArg (fun x => x.1.2) (alternator_course k).2⟩

/-- Even steps, by recursion. A local definition: a parity is in modules outside this one's
imports. -/
def even : Nat → Bool
  | 0 => true
  | n + 1 => !even n

theorem even_two_mul : ∀ k, even (2 * k) = true ∧ even (2 * k + 1) = false
  | 0 => ⟨rfl, rfl⟩
  | k + 1 =>
    have next : even (2 * (k + 1)) = true := by
      show (!even (2 * k + 1)) = true
      rw [(even_two_mul k).2]
      rfl
    ⟨next, by
      show (!even (2 * (k + 1))) = false
      rw [next]
      rfl⟩

/-- The alternator gives exactly at the odd steps: its step is the negation of `even`. -/
theorem alternator_second : ∀ n,
    ((Law.run alternatorStep alternatorStart).state n).1.2 = !even n
  | 0 => rfl
  | n + 1 => by
    show (!((Law.run alternatorStep alternatorStart).state n).1.2) = !even (n + 1)
    rw [alternator_second n]
    rfl

/-! ## Echo under `answers`, in a pair -/

/-- Two formations of a pair. -/
inductive Pair where
  | first
  | second

namespace Pair

/-- Each formation of the pair waits on the other. -/
inductive Waits : Pair → Pair → Prop
  | onSecond : Waits second first
  | onFirst : Waits first second

/-- One withholding after mutual giving: the first withholds, the second gives. -/
def oneWithheld : Pair → Prop
  | first => False
  | second => True

theorem answers_first {s : Pair → Prop} : answers Waits s first ↔ s second :=
  ⟨fun all => all second Waits.onSecond, fun gave b link => by cases link; exact gave⟩

theorem answers_second {s : Pair → Prop} : answers Waits s second ↔ s first :=
  ⟨fun all => all first Waits.onFirst, fun gave b link => by cases link; exact gave⟩

/-- The pair is a loop of two waits from `first` back to `first`. -/
theorem loop : Chain Waits 2 first first :=
  Chain.step (Chain.step (Chain.here first) Waits.onFirst) Waits.onSecond

theorem swap_first {s : Pair → Prop} (now : ¬ s first ∧ s second) :
    answers Waits s first ∧ ¬ answers Waits s second :=
  ⟨answers_first.mpr now.2, fun gives => now.1 (answers_second.mp gives)⟩

theorem swap_second {s : Pair → Prop} (now : s first ∧ ¬ s second) :
    ¬ answers Waits s first ∧ answers Waits s second :=
  ⟨fun gives => now.2 (answers_first.mp gives), answers_second.mpr now.1⟩

/-- **Echo**: from one withholding after mutual giving, under `answers` the first withholds and
the second gives at every even step, and the reverse at every odd step. -/
theorem echo : ∀ k : Nat,
    (¬ (Law.run (answers Waits) oneWithheld).state (2 * k) first ∧
      (Law.run (answers Waits) oneWithheld).state (2 * k) second) ∧
    ((Law.run (answers Waits) oneWithheld).state (2 * k + 1) first ∧
      ¬ (Law.run (answers Waits) oneWithheld).state (2 * k + 1) second)
  | 0 =>
    let start : ¬ oneWithheld first ∧ oneWithheld second := ⟨fun out => out, trivial⟩
    ⟨start, swap_first start⟩
  | k + 1 =>
    let ⟨_, odd⟩ := echo k
    let even := swap_second odd
    ⟨even, swap_first even⟩

/-- **Exactly one gives at each step.** -/
theorem exactly_one : ∀ n,
    (¬ (Law.run (answers Waits) oneWithheld).state n first ∧
      (Law.run (answers Waits) oneWithheld).state n second) ∨
    ((Law.run (answers Waits) oneWithheld).state n first ∧
      ¬ (Law.run (answers Waits) oneWithheld).state n second) :=
  invariant (fun (s : Pair → Prop) => (¬ s first ∧ s second) ∨ (s first ∧ ¬ s second))
    (.inl ⟨fun out => out, trivial⟩)
    fun _ now => now.elim (fun one => .inr (swap_first one)) (fun other => .inl (swap_second other))

/-- **The pair never gives together again without another withholding.** -/
theorem never_together : ∀ n,
    ¬ ((Law.run (answers Waits) oneWithheld).state n first ∧
      (Law.run (answers Waits) oneWithheld).state n second) :=
  fun n both => (exactly_one n).elim (fun one => one.1 both.1) (fun other => other.2 both.2)

/-- **The echo's return at `first` is `withholding_returns` at a loop of two.** -/
theorem echo_returns : ∀ k, ¬ (Law.run (answers Waits) oneWithheld).state (k * 2) first :=
  withholding_returns loop (fun out => out)

/-! ### The Bool laws joined to the pair's configurations -/

/-- A decided state of the pair and a configuration agree at each formation. -/
def Matches (x : Bool × Bool) (s : Pair → Prop) : Prop :=
  (x.1 = true ↔ s first) ∧ (x.2 = true ↔ s second)

/-- **Two holders of `partnerGave` run the course of `answers` on the pair**: at every step, each
formation gives in the Bool course from `oneWithheldBool` exactly where it gives in the course of
`answers Waits` from `oneWithheld`. -/
theorem partnerGave_course : ∀ n,
    Matches ((Law.run (pairStep partnerGave) oneWithheldBool).state n)
      ((Law.run (answers Waits) oneWithheld).state n) :=
  course_rel Matches
    ⟨⟨fun h => Bool.noConfusion h, fun h => h.elim⟩, ⟨fun _ => trivial, fun _ => rfl⟩⟩
    fun x _ m =>
      ⟨(Iff.of_eq (congrArg (· = true) (partnerGave_eq x.1 x.2))).trans
          (m.2.trans answers_first.symm),
       (Iff.of_eq (congrArg (· = true) (partnerGave_eq x.2 x.1))).trans
          (m.1.trans answers_second.symm)⟩

/-- **`partnerGave_never_restores` is the echo read through the bridge.** -/
theorem partnerGave_never_restores_of_echo : NeverRestores partnerGave :=
  fun n both => never_together n
    ⟨(partnerGave_course n).1.mp (congrArg Prod.fst both),
     (partnerGave_course n).2.mp (congrArg Prod.snd both)⟩

/-- The partner of each formation. -/
def partner : Pair → Pair
  | first => second
  | second => first

theorem waits_partner : ∀ p, Waits (partner p) p
  | first => Waits.onSecond
  | second => Waits.onFirst

/-- A configuration of the pair from the giving of each formation. -/
def config (x y : Prop) : Pair → Prop
  | first => x
  | second => y

/-- The law on the pair's configurations induced by a two-input law `g` on giving: each formation
gives by `g` from its own last step and its partner's. -/
def induced (g : Prop → Prop → Prop) (s : Pair → Prop) (p : Pair) : Prop :=
  g (s p) (s (partner p))

/-- A two-input law on Prop-valued giving agrees with one on decided giving. -/
def Agrees (g : Prop → Prop → Prop) (f : Bool → Bool → Bool) : Prop :=
  ∀ a b : Bool, g (a = true) (b = true) ↔ f a b = true

/-- A two-input law on Prop-valued giving keeps inclusion in both inputs. -/
def InputsKeepInclusion (g : Prop → Prop → Prop) : Prop :=
  ∀ A A' B B' : Prop, (A → A') → (B → B') → g A B → g A' B'

/-- **Answering is the law induced by the partner's step.** -/
theorem induced_partner (s : Pair → Prop) : ∀ p,
    induced (fun _ partnerStep => partnerStep) s p ↔ answers Waits s p
  | first => answers_first.symm
  | second => answers_second.symm

theorem induced_keeps {g : Prop → Prop → Prop} (keeps : InputsKeepInclusion g) :
    KeepsInclusion (induced g) :=
  fun _ _ sub p gives => keeps _ _ _ _ (sub p) (sub (partner p)) gives

/-- **An induced law keeping inclusion on the pair's configurations gives a two-input law keeping
inclusion on decided giving.** -/
theorem keeps_of_induced {g : Prop → Prop → Prop} {f : Bool → Bool → Bool} (agrees : Agrees g f)
    (keeps : KeepsInclusion (induced g)) : PairKeepsInclusion f :=
  fun a a' b b' ha hb gives =>
    (agrees a' b').mp
      (keeps (config (a = true) (b = true)) (config (a' = true) (b' = true))
        (fun p => match p with
          | first => ha
          | second => hb)
        first ((agrees a b).mpr gives))

theorem agrees_table {g : Prop → Prop → Prop} {f : Bool → Bool → Bool} {tt tf ft ff : Bool}
    (agrees : Agrees g (table tt tf ft ff)) (same : ∀ a b, f a b = table tt tf ft ff a b) :
    Agrees g f :=
  fun a b => (agrees a b).trans (Iff.of_eq (congrArg (· = true) (same a b).symm))

theorem agrees_never : Agrees (fun _ _ => False) (table false false false false) := by
  intro a b; cases a <;> cases b <;> decide
theorem agrees_both : Agrees (fun A B => A ∧ B) (table true false false false) := by
  intro a b; cases a <;> cases b <;> decide
theorem agrees_partner : Agrees (fun _ B => B) (table true false true false) := by
  intro a b; cases a <;> cases b <;> decide
theorem agrees_own : Agrees (fun A _ => A) (table true true false false) := by
  intro a b; cases a <;> cases b <;> decide
theorem agrees_either : Agrees (fun A B => A ∨ B) (table true true true false) := by
  intro a b; cases a <;> cases b <;> decide
theorem agrees_always : Agrees (fun _ _ => True) (table true true true true) := by
  intro a b; cases a <;> cases b <;> decide

/-- **Keeping inclusion on decided giving is keeping inclusion on the pair's configurations**: a
two-input law keeps inclusion exactly where some Prop-valued two-input law agreeing with it on
decided giving induces a law on `Pair → Prop` keeping inclusion (`Tolerance.KeepsInclusion`). -/
theorem pairKeepsInclusion_iff_induced (f : Bool → Bool → Bool) :
    PairKeepsInclusion f ↔ ∃ g, Agrees g f ∧ KeepsInclusion (induced g) := by
  refine ⟨fun keeps => ?_, fun ⟨_, agrees, keeps⟩ => keeps_of_induced agrees keeps⟩
  cases h1 : f true true <;> cases h2 : f true false <;> cases h3 : f false true <;>
    cases h4 : f false false
  all_goals first
    | exact ⟨_, agrees_table agrees_never (eq_table_of h1 h2 h3 h4),
        induced_keeps fun _ _ _ _ _ _ g => g⟩
    | exact ⟨_, agrees_table agrees_both (eq_table_of h1 h2 h3 h4),
        induced_keeps fun _ _ _ _ ha hb g => ⟨ha g.1, hb g.2⟩⟩
    | exact ⟨_, agrees_table agrees_partner (eq_table_of h1 h2 h3 h4),
        induced_keeps fun _ _ _ _ _ hb g => hb g⟩
    | exact ⟨_, agrees_table agrees_own (eq_table_of h1 h2 h3 h4),
        induced_keeps fun _ _ _ _ ha _ g => ha g⟩
    | exact ⟨_, agrees_table agrees_either (eq_table_of h1 h2 h3 h4),
        induced_keeps fun _ _ _ _ ha hb g => g.elim (fun a => .inl (ha a)) (fun b => .inr (hb b))⟩
    | exact ⟨_, agrees_table agrees_always (eq_table_of h1 h2 h3 h4),
        induced_keeps fun _ _ _ _ _ _ g => g⟩
    | exact Bool.noConfusion (h1.symm.trans (keeps true true false true id (fun _ => rfl) h2))
    | exact Bool.noConfusion (h1.symm.trans (keeps false true true true (fun _ => rfl) id h3))
    | exact Bool.noConfusion (h2.symm.trans (keeps false true false false (fun _ => rfl) id h4))
    | exact Bool.noConfusion (h3.symm.trans (keeps false false false true id (fun _ => rfl) h4))

/-- The disjunctive normal form of answering, with negation: both gave, or one's own step withheld
and the partner gave. -/
def partnerGaveDnf (A B : Prop) : Prop := (A ∧ B) ∨ (¬ A ∧ B)

theorem agrees_dnf : Agrees partnerGaveDnf partnerGave := fun a b => match a, b with
  | true, true => ⟨fun _ => rfl, fun _ => .inl ⟨rfl, rfl⟩⟩
  | true, false =>
    ⟨fun g => g.elim (fun x => Bool.noConfusion x.2) (fun x => Bool.noConfusion x.2),
      fun h => Bool.noConfusion h⟩
  | false, true => ⟨fun _ => rfl, fun _ => .inr ⟨fun h => Bool.noConfusion h, rfl⟩⟩
  | false, false =>
    ⟨fun g => g.elim (fun x => Bool.noConfusion x.2) (fun x => Bool.noConfusion x.2),
      fun h => Bool.noConfusion h⟩

/-- **Why the bridge is existential: the normal form keeps inclusion exactly under excluded
middle.** A lemma of `pairKeepsInclusion_iff_induced`, a calibration of the logic, not a result.
The normal form of answering agrees with `partnerGave` on decided giving, and the law it induces
on the pair's configurations keeps inclusion exactly where every proposition is decided. -/
theorem dnf_keeps_iff_em : KeepsInclusion (induced partnerGaveDnf) ↔ ∀ P : Prop, P ∨ ¬ P :=
  ⟨fun keeps P =>
    (keeps (config False True) (config P True)
      (fun p => match p with
        | first => fun f => f.elim
        | second => fun t => t)
      first (.inr ⟨fun f => f, trivial⟩)).elim (fun x => .inl x.1) (fun x => .inr x.1),
   fun em _ s' sub p gives =>
    have partnerGives : s' (partner p) :=
      sub _ (gives.elim (fun x => x.2) (fun x => x.2))
    (em (s' p)).elim (fun own => .inl ⟨own, partnerGives⟩) (fun own => .inr ⟨own, partnerGives⟩)⟩

/-- The normal form keeping inclusion gives excluded middle: the forward half of
`dnf_keeps_iff_em`, a restatement; a lemma of `pairKeepsInclusion_iff_induced`. -/
theorem dnf_keeps_em (keeps : KeepsInclusion (induced partnerGaveDnf)) : ∀ P : Prop, P ∨ ¬ P :=
  dnf_keeps_iff_em.mp keeps

/-- **That every agreeing law keeps inclusion implies excluded middle**: where every Prop-valued
law agreeing with `partnerGave` induces a law keeping inclusion, every proposition is decided
(one direction only; the converse is not stated). So `pairKeepsInclusion_iff_induced` cannot take
every agreeing law in place of some, within the pure core. A lemma of that bridge, a calibration
of the logic, not a result. -/
theorem all_agreeing_keeps_em
    (all : ∀ g, Agrees g partnerGave → KeepsInclusion (induced g)) : ∀ P : Prop, P ∨ ¬ P :=
  dnf_keeps_em (all _ agrees_dnf)

end Pair

/-! ## Answering within a window, on configurations -/

section Window

variable {α : Type u} {w : Nat} {up : α → α → Prop}

/-- Answering within a window of `w`: at lag `0` a formation gives where each formation it waits
on gave at some lag below `w`; every other lag takes the lag before it. -/
def answersWithin (w : Nat) (up : α → α → Prop) (h : α × Nat → Prop) : α × Nat → Prop
  | (a, 0) => ∀ b, up b a → ∃ i, i < w ∧ h (b, i)
  | (a, i + 1) => h (a, i)

/-- Some lag below one is lag `0`. -/
theorem lag_below_one {X : Nat → Prop} : (∃ i, i < 1 ∧ X i) ↔ X 0 :=
  ⟨fun ⟨i, lt, x⟩ => match i, lt, x with
    | 0, _, x => x
    | _ + 1, lt, _ => absurd (Nat.le_of_succ_le_succ lt) (Nat.not_succ_le_zero _),
   fun x => ⟨0, Nat.zero_lt_one, x⟩⟩

/-- Some lag below two is lag `0` or lag `1`. -/
theorem lag_below_two {X : Nat → Prop} : (∃ i, i < 2 ∧ X i) ↔ X 0 ∨ X 1 :=
  ⟨fun ⟨i, lt, x⟩ => match i, lt, x with
    | 0, _, x => .inl x
    | 1, _, x => .inr x
    | _ + 2, lt, _ => absurd (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ lt))
        (Nat.not_succ_le_zero _),
   fun x => x.elim (fun x => ⟨0, Nat.le.step (Nat.le_refl 1), x⟩)
     (fun x => ⟨1, Nat.le_refl 2, x⟩)⟩

/-- **(a) A window of one is `answers`, along every course**: at lag `0`, the run of
`answersWithin 1` from any history is the run of `answers` from the history's lag `0`. -/
theorem window_one (up : α → α → Prop) (h : α × Nat → Prop) : ∀ n a,
    (Law.run (answersWithin 1 up) h).state n (a, 0) ↔
      (Law.run (answers up) (fun a => h (a, 0))).state n a
  | 0, _ => Iff.rfl
  | n + 1, _ =>
    ⟨fun gives b link => (window_one up h n b).mp
        (lag_below_one (X := fun i => (Law.run (answersWithin 1 up) h).state n (b, i)) |>.mp
          (gives b link)),
     fun gives b link => (lag_below_one (X := fun i => (Law.run (answersWithin 1 up) h).state n
        (b, i))).mpr ((window_one up h n b).mpr (gives b link))⟩

/-- **(b) A window keeps inclusion into every wider window.** -/
theorem answersWithin_into {w w' : Nat} (le : w ≤ w') (up : α → α → Prop) :
    KeepsInclusionInto (answersWithin w up) (answersWithin w' up) :=
  fun _ _ sub p => match p with
    | (_, 0) => fun gives b link =>
      let ⟨i, lt, g⟩ := gives b link
      ⟨i, Nat.lt_of_lt_of_le lt le, sub _ g⟩
    | (a, i + 1) => fun g => sub (a, i) g

/-- **(b) Windowed laws keep inclusion on the carrier.** -/
theorem answersWithin_keeps (w : Nat) (up : α → α → Prop) : KeepsInclusion (answersWithin w up) :=
  answersWithin_into (Nat.le_refl w) up

/-- **A wider window gives no less, at every step and lag.** -/
theorem window_mono {w w' : Nat} (le : w ≤ w') (up : α → α → Prop) (h : α × Nat → Prop) :
    ∀ n p, (Law.run (answersWithin w up) h).state n p →
      (Law.run (answersWithin w' up) h).state n p :=
  (answersWithin_into le up).course fun _ start => start

/-- **The worst start of a window is total withholding.** A restatement, not a result:
`Tolerance.worst_start` applied to `answersWithin_keeps`. -/
theorem window_worst_start (w : Nat) (up : α → α → Prop) (n : Nat) (p : α × Nat) :
    (∀ h, (Law.run (answersWithin w up) h).state n p) ↔
      (Law.run (answersWithin w up) allWithheld).state n p :=
  worst_start (answersWithin_keeps w up) n p

/-- **Restoring stays under a window.** A restatement, not a result: `Tolerance.restored_stays`
applied to `answersWithin_keeps`. -/
theorem window_restored_stays (w : Nat) (up : α → α → Prop) {n : Nat} {p : α × Nat}
    (restored : ∀ h, (Law.run (answersWithin w up) h).state n p) :
    ∀ m, n ≤ m → ∀ h, (Law.run (answersWithin w up) h).state m p :=
  restored_stays (answersWithin_keeps w up) restored

/-- **No window restores from total withholding**: where every formation waits on some formation,
total withholding is kept at every step and lag (`Tolerance.withheld_kept`). -/
theorem window_withheld_kept (w : Nat) (waits : ∀ a, ∃ b, up b a) :
    ∀ n p, ¬ (Law.run (answersWithin w up) allWithheld).state n p :=
  withheld_kept (answersWithin_keeps w up) fun p => match p with
    | (a, 0) => fun gives =>
      let ⟨b, link⟩ := waits a
      let ⟨_, _, g⟩ := gives b link
      g
    | (_, _ + 1) => fun g => g

/-- **What a lag holds**: lag `i` at step `m + i` is lag `0` at step `m`. -/
theorem lag_shift (h : α × Nat → Prop) (b : α) (m : Nat) : ∀ i,
    (Law.run (answersWithin w up) h).state (m + i) (b, i) ↔
      (Law.run (answersWithin w up) h).state m (b, 0)
  | 0 => Iff.rfl
  | i + 1 => lag_shift h b m i

/-- **(d) A constant withholder is answered within the window.** Where a formation `c` withholds
at lag `0` at every step from `T` of the run, every formation waiting on it withholds at every step
from `T + (w + 1)` under a window of `w + 1`. -/
theorem withholder_answered {h : α × Nat → Prop} {c : α} {T : Nat}
    (out : ∀ t, T ≤ t → ¬ (Law.run (answersWithin (w + 1) up) h).state t (c, 0)) :
    ∀ a, up c a → ∀ n, T + (w + 1) ≤ n →
      ¬ (Law.run (answersWithin (w + 1) up) h).state n (a, 0) := by
  intro a link n le
  let ⟨k, same⟩ := le_dest le
  subst same
  have turn : T + (w + 1) + k = T + k + w + 1 :=
    (Nat.add_right_comm (T + w) 1 k).trans (congrArg (· + 1) (Nat.add_right_comm T w k))
  rw [turn]
  intro gives
  let ⟨i, lt, g⟩ := gives c link
  let ⟨d, wsame⟩ := le_dest (Nat.le_of_lt_succ lt)
  have split : T + k + w = T + k + d + i := by
    rw [wsame, Nat.add_comm i d, ← Nat.add_assoc]
  have g' : (Law.run (answersWithin (w + 1) up) h).state (T + k + d + i) (c, i) := split ▸ g
  exact out (T + k + d) (Nat.le_trans (Nat.le_add_right T k) (Nat.le_add_right (T + k) d))
    ((lag_shift h c (T + k + d) i).mp g')

end Window

namespace Pair

/-- Some formation is waited on by each formation of the pair. -/
theorem waited_on : ∀ a, ∃ b, Waits b a := fun p => ⟨partner p, waits_partner p⟩

/-- **The unclocked (d) in total withholding**: the statement is the conclusion of
`withholder_answered` there, the second withholding at every step from step 2; its premise, the
first withholding at every step, is met inside the proof by `window_withheld_kept`, which already
gives the conclusion itself. A witness lemma; `Line.withholder_answered_reached` meets the premise
away from total withholding. -/
theorem withholder_answered_holds :
    ∀ n, 2 ≤ n → ¬ (Law.run (answersWithin 2 Waits) allWithheld).state n (second, 0) :=
  withholder_answered (w := 1) (fun t _ => window_withheld_kept 2 waited_on t (first, 0))
    second Waits.onFirst

theorem within_first {h : Pair × Nat → Prop} :
    answersWithin 2 Waits h (first, 0) ↔ h (second, 0) ∨ h (second, 1) :=
  ⟨fun all => lag_below_two.mp (all second Waits.onSecond),
   fun g b link => by cases link; exact lag_below_two.mpr g⟩

theorem within_second {h : Pair × Nat → Prop} :
    answersWithin 2 Waits h (second, 0) ↔ h (first, 0) ∨ h (first, 1) :=
  ⟨fun all => lag_below_two.mp (all first Waits.onFirst),
   fun g b link => by cases link; exact lag_below_two.mpr g⟩

/-- One withholding after a history of mutual giving, on the window's carrier: only the first
withholds, at lag `0`. -/
def oneWithheldHistory : Pair × Nat → Prop
  | (first, 0) => False
  | (first, _ + 1) => True
  | (second, _) => True

/-- A decided pair of last two steps and a configuration agree at lags `0` and `1`. -/
def WindowMatches (x : (Bool × Bool) × (Bool × Bool)) (h : Pair × Nat → Prop) : Prop :=
  (x.1.1 = true ↔ h (first, 0)) ∧ (x.1.2 = true ↔ h (second, 0)) ∧
    (x.2.1 = true ↔ h (first, 1)) ∧ (x.2.2 = true ↔ h (second, 1))

/-- **Two holders of the window of two run the course of `answersWithin 2` on the pair**: at
every step, the Bool course of `windowStep` from `windowOneWithheld` agrees at lags `0` and `1` of
each formation with the course of `answersWithin 2 Waits` from `oneWithheldHistory`. -/
theorem windowStep_course : ∀ n,
    WindowMatches ((Law.run windowStep windowOneWithheld).state n)
      ((Law.run (answersWithin 2 Waits) oneWithheldHistory).state n) :=
  course_rel WindowMatches
    ⟨⟨fun h => Bool.noConfusion h, fun h => h.elim⟩, ⟨fun _ => trivial, fun _ => rfl⟩,
     ⟨fun _ => trivial, fun _ => rfl⟩, ⟨fun _ => trivial, fun _ => rfl⟩⟩
    fun _ _ m =>
      ⟨(ListTests.or_true_iff).trans ((or_congr_both m.2.1 m.2.2.2).trans within_first.symm),
       (ListTests.or_true_iff).trans ((or_congr_both m.1 m.2.2.1).trans within_second.symm),
       m.1, m.2.1⟩

/-- **The pair under a window of two, from one withholding, gives together at every step from
step 1**: `windowTwo_restored_stays` read on the configurations. -/
theorem window_restores : ∀ n,
    (Law.run (answersWithin 2 Waits) oneWithheldHistory).state (n + 1) (first, 0) ∧
      (Law.run (answersWithin 2 Waits) oneWithheldHistory).state (n + 1) (second, 0) :=
  fun n =>
    ⟨(windowStep_course (n + 1)).1.mp (congrArg (fun x => x.1) (windowTwo_restored_stays n)),
     (windowStep_course (n + 1)).2.1.mp (congrArg (fun x => x.2) (windowTwo_restored_stays n))⟩

end Pair

/-- Three formations in a line: the source waits on itself, the relay on the source, the last on
the relay. -/
inductive Line where
  | source
  | relay
  | last

namespace Line

/-- The waits of the line. -/
inductive Waits : Line → Line → Prop
  | onItself : Waits source source
  | onSource : Waits source relay
  | onRelay : Waits relay last

/-- The source withheld at every lag of the history, the relay and the last giving at every lag. -/
def sourceWithheld : Line × Nat → Prop
  | (source, _) => False
  | (relay, _) => True
  | (last, _) => True

/-- The source withholds at every step and lag under a window of two. -/
theorem source_out : ∀ n i,
    ¬ (Law.run (answersWithin 2 Waits) sourceWithheld).state n (source, i)
  | 0, _ => fun f => f
  | n + 1, 0 => fun g => let ⟨i, _, h⟩ := g source Waits.onItself; source_out n i h
  | n + 1, i + 1 => fun g => source_out n i g

/-- **The relay gives at step 0 and withholds at every step from step 1.** -/
theorem relay_course :
    (Law.run (answersWithin 2 Waits) sourceWithheld).state 0 (relay, 0) ∧
      ∀ t, 1 ≤ t → ¬ (Law.run (answersWithin 2 Waits) sourceWithheld).state t (relay, 0) :=
  ⟨trivial, fun t le => match t, le with
    | 0, le => absurd le (Nat.not_succ_le_zero 0)
    | n + 1, _ => fun g => let ⟨i, _, h⟩ := g source Waits.onSource; source_out n i h⟩

/-- **The unclocked (d) is reached, away from total withholding.** With the relay withholding at
lag `0` at every step from step 1 of the run itself, the last, which waits on it, still gives at
step 2 and withholds at every step from step 3 under a window of two (`withholder_answered` at
`T = 1`, `w = 1`, so `T + (w + 1) = 3`). -/
theorem withholder_answered_reached :
    (Law.run (answersWithin 2 Waits) sourceWithheld).state 2 (last, 0) ∧
      ∀ n, 3 ≤ n → ¬ (Law.run (answersWithin 2 Waits) sourceWithheld).state n (last, 0) :=
  ⟨fun b link => by cases link; exact ⟨1, Nat.le_refl 2, trivial⟩,
   (withholder_answered (w := 1) (T := 1) relay_course.2 last Waits.onRelay :
     ∀ n, 3 ≤ n → ¬ (Law.run (answersWithin 2 Waits) sourceWithheld).state n (last, 0))⟩

end Line

/-! ## Errors, folded into the state as a clock -/

section Errors

variable {α : Type u} (e : Nat → α → Prop) (w : Nat) (up : α → α → Prop)

/-- Answering within a window at time `t`, where the error pattern `e` turns an intended giving
at lag `0` into withholding. -/
def answersWithinErring (t : Nat) (h : α × Nat → Prop) : α × Nat → Prop
  | (a, 0) => ¬ e t a ∧ ∀ b, up b a → ∃ i, i < w ∧ h (b, i)
  | (a, i + 1) => h (a, i)

/-- **Each time's law keeps inclusion.** -/
theorem erring_keeps (t : Nat) : KeepsInclusion (answersWithinErring e w up t) :=
  fun _ _ sub p => match p with
    | (_, 0) => fun gives => ⟨gives.1, fun b link =>
      let ⟨i, lt, g⟩ := gives.2 b link
      ⟨i, lt, sub _ g⟩⟩
    | (a, i + 1) => fun g => sub (a, i) g

/-- The clocked law: the state carries the time, and the law at the next time applies. -/
def clocked (x : Nat × (α × Nat → Prop)) : Nat × (α × Nat → Prop) :=
  (x.1 + 1, answersWithinErring e w up (x.1 + 1) x.2)

/-- All giving, with the errors of step `0` at lag `0`. -/
def erringStart : α × Nat → Prop
  | (a, 0) => ¬ e 0 a
  | (_, _ + 1) => True

/-- The configuration at each step of the clocked run. -/
def erringRun : Nat → α × Nat → Prop
  | 0 => erringStart e
  | n + 1 => answersWithinErring e w up (n + 1) (erringRun n)

/-- **The clocked run carries its time and the configuration `erringRun`.** -/
theorem clocked_state : ∀ n,
    (Law.run (clocked e w up) (0, erringStart e)).state n = (n, erringRun e w up n)
  | 0 => rfl
  | n + 1 => congrArg (clocked e w up) (clocked_state n)

variable {e w up}

theorem erring_shift (b : α) (m : Nat) : ∀ i,
    erringRun e w up (m + i) (b, i) ↔ erringRun e w up m (b, 0)
  | 0 => Iff.rfl
  | i + 1 => erring_shift b m i

/-- Lags beyond the step read the history, all giving. -/
theorem erring_history (b : α) : ∀ i j, erringRun e w up i (b, j + 1 + i)
  | 0, _ => trivial
  | i + 1, j => erring_history b i j

/-- A formation giving does not err. -/
theorem erringRun_no_error {b : α} : ∀ m, erringRun e w up m (b, 0) → ¬ e m b
  | 0, gives => gives
  | _ + 1, gives => gives.1

/-- No formation errs at `w` consecutive steps. -/
def Spaced (e : Nat → α → Prop) (w : Nat) : Prop :=
  ∀ a t, ∃ i, i < w ∧ ¬ e (t + i) a

/-- **Spacing in a window is spacing in every wider window.** A lemma. -/
theorem spaced_mono {w' : Nat} (le : w ≤ w') (spaced : Spaced e w) : Spaced e w' :=
  fun a t => let ⟨i, lt, ok⟩ := spaced a t; ⟨i, Nat.lt_of_lt_of_le lt le, ok⟩

/-- The rearrangement of the window's steps. -/
theorem window_turn (t i d : Nat) : i + 1 + d + t = t + i + d + 1 := by
  rw [Nat.add_comm (i + 1 + d) t, Nat.add_right_comm i 1 d, ← Nat.add_assoc t (i + d) 1,
    ← Nat.add_assoc t i d]

/-- **A giving within the last `w` steps is in the window.** At step `n`, where `n + 1 < w` the
history's lag `n + 1` gives; otherwise, where `c` gives at lag `0` at one of the `w` steps from
`t` with `n + 1 = w + t`, `c` gives at some lag below `w`. -/
theorem window_of_gap {c : α} (n : Nat)
    (gap : ∀ t, n + 1 = w + t → ∃ i, i < w ∧ erringRun e w up (t + i) (c, 0)) :
    ∃ i, i < w ∧ erringRun e w up n (c, i) :=
  match Nat.lt_or_ge (n + 1) w with
  | .inl short =>
    ⟨0 + 1 + n, by rw [Nat.zero_add, Nat.add_comm 1 n]; exact short, erring_history c n 0⟩
  | .inr long =>
    let ⟨t, ts⟩ := le_dest long
    let ⟨i, lt, g⟩ := gap t ts
    let ⟨d, ds⟩ := le_dest lt
    have steps : n = t + i + d := by
      apply Nat.succ.inj
      show n + 1 = t + i + d + 1
      rw [ts, ds, window_turn]
    ⟨d, by rw [ds, Nat.add_right_comm i 1 d]; exact Nat.le_add_left (d + 1) i,
      by rw [steps]; exact (erring_shift c (t + i) d).mpr g⟩

/-- Steps of a window end at the step before the next: `t + i ≤ n` where `n + 1 = w + t` and
`i < w`. -/
theorem gap_le {n t i : Nat} (ts : n + 1 = w + t) (lt : i < w) : t + i ≤ n :=
  Nat.le_of_succ_le_succ (show t + i + 1 ≤ n + 1 from
    Nat.le_trans (Nat.add_le_add_left lt t) (Nat.le_of_eq ((Nat.add_comm t w).trans ts.symm)))

theorem gives_unless_errs_le (spaced : Spaced e w) :
    ∀ n m, m ≤ n → ∀ a, ¬ e m a → erringRun e w up m (a, 0)
  | 0, m, le, a, ok => match m, le with
    | 0, _ => ok
    | _ + 1, le => absurd le (Nat.not_succ_le_zero _)
  | n + 1, m, le, a, ok => match Nat.lt_or_ge m (n + 1) with
    | .inl lt => gives_unless_errs_le spaced n m (Nat.le_of_lt_succ lt) a ok
    | .inr ge =>
      have same : m = n + 1 := Nat.le_antisymm le ge
      by
        subst same
        exact ⟨ok, fun b _ => window_of_gap n fun t ts =>
          let ⟨i, lt, fine⟩ := spaced b t
          ⟨i, lt, gives_unless_errs_le spaced n (t + i) (gap_le ts lt) b fine⟩⟩

/-- **(c) A thin withholding in time is absorbed.** From all giving, where no formation errs at
`w` consecutive steps, every formation gives at every step exactly where it does not err. -/
theorem gives_unless_errs (spaced : Spaced e w) : ∀ n a,
    ((Law.run (clocked e w up) (0, erringStart e)).state n).2 (a, 0) ↔ ¬ e n a :=
  fun n a => (Iff.of_eq (congrFun (congrArg Prod.snd (clocked_state e w up n)) (a, 0))).trans
    ⟨erringRun_no_error n, gives_unless_errs_le spaced n n (Nat.le_refl n) a⟩

/-- **(c) Exactly so**: `w + 1` consecutive errors at one formation, from step `t`, make every
formation waiting on it withhold at step `t + w + 1` under a window of `w + 1`. -/
theorem errs_answered {b a : α} (link : up b a) (t : Nat)
    (errs : ∀ i, i < w + 1 → e (t + i) b) :
    ¬ ((Law.run (clocked e (w + 1) up) (0, erringStart e)).state (t + w + 1)).2 (a, 0) := by
  rw [clocked_state]
  intro gives
  let ⟨i, lt, g⟩ := gives.2 b link
  let ⟨d, wsame⟩ := le_dest (Nat.le_of_lt_succ lt)
  have split : t + w = t + d + i := by
    rw [wsame, Nat.add_comm i d, ← Nat.add_assoc]
  have g' : erringRun e (w + 1) up (t + d + i) (b, i) := split ▸ g
  exact erringRun_no_error (t + d) ((erring_shift b (t + d) i).mp g')
    (errs d (Nat.lt_succ_of_le (wsame ▸ Nat.le_add_left d i)))

/-- **(d), clocked: a formation erring at every step from `T` is answered within the window.**
Every formation waiting on it withholds at every step from `T + (w + 1)` under a window of
`w + 1`. -/
theorem withholder_answered_clocked {c : α} {T : Nat} (out : ∀ t, T ≤ t → e t c) :
    ∀ a, up c a → ∀ n, T + (w + 1) ≤ n →
      ¬ ((Law.run (clocked e (w + 1) up) (0, erringStart e)).state n).2 (a, 0) := by
  intro a link n le
  let ⟨k, same⟩ := le_dest le
  subst same
  have turn : T + (w + 1) + k = T + k + w + 1 :=
    (Nat.add_right_comm (T + w) 1 k).trans (congrArg (· + 1) (Nat.add_right_comm T w k))
  rw [turn]
  exact errs_answered link (T + k) fun i _ =>
    out (T + k + i) (Nat.le_trans (Nat.le_add_right T k) (Nat.le_add_right (T + k) i))

/-- **(e) A window never answers a formation giving at least once in every `w` steps.** Where, at
every step `t`, the formation `c` gives at lag `0` at one of the steps `t, …, t + w - 1` of the
clocked run, at every step `c` gives at some lag below `w`: whatever waits on `c` finds a giving of
it in its window at every step. -/
theorem window_holds_of_gaps {c : α}
    (gaps : ∀ t, ∃ i, i < w ∧
      ((Law.run (clocked e w up) (0, erringStart e)).state (t + i)).2 (c, 0)) :
    ∀ n, ∃ i, i < w ∧ ((Law.run (clocked e w up) (0, erringStart e)).state n).2 (c, i) := by
  intro n
  rw [clocked_state]
  exact window_of_gap n fun t _ =>
    let ⟨i, lt, g⟩ := gaps t
    ⟨i, lt, (Iff.of_eq (congrFun (congrArg Prod.snd (clocked_state e w up (t + i))) (c, 0))).mp g⟩

/-- **(e) Where no formation errs at `w` consecutive steps, every formation is in every window at
every step**, so a formation waiting on another withholds only at its own errors
(`gives_unless_errs`). -/
theorem spaced_window_holds (spaced : Spaced e w) (c : α) :
    ∀ n, ∃ i, i < w ∧ ((Law.run (clocked e w up) (0, erringStart e)).state n).2 (c, i) :=
  window_holds_of_gaps fun t =>
    let ⟨i, lt, fine⟩ := spaced c t
    ⟨i, lt, (gives_unless_errs spaced (t + i) c).mpr fine⟩

end Errors

/-! ## Witnesses for the window -/

namespace Pair

/-- One error, at the first formation at step `0`. -/
def firstErrsOnce (n : Nat) (a : Pair) : Prop := n = 0 ∧ a = first

theorem firstErrsOnce_spaced : Spaced firstErrsOnce 2 :=
  fun _ _ => ⟨1, Nat.le_refl 2, fun errs => Nat.noConfusion errs.1⟩

/-- **One error is absorbed under every window of at least two**: both formations give at every
step from step 1. -/
theorem window_absorbs_within {w : Nat} (two : 2 ≤ w) : ∀ n a,
    ((Law.run (clocked firstErrsOnce w Waits) (0, erringStart firstErrsOnce)).state (n + 1)).2
      (a, 0) :=
  fun n a => (gives_unless_errs (spaced_mono two firstErrsOnce_spaced) (n + 1) a).mpr
    fun errs => Nat.noConfusion errs.1

/-- **The pair under a window of two absorbs one error**: both formations give at every step from
step 1 (`window_absorbs_within` at two, an instance), and the first withholds at step `0`. -/
theorem window_absorbs :
    (∀ n a, ((Law.run (clocked firstErrsOnce 2 Waits) (0, erringStart firstErrsOnce)).state
      (n + 1)).2 (a, 0)) ∧
    ¬ ((Law.run (clocked firstErrsOnce 2 Waits) (0, erringStart firstErrsOnce)).state 0).2
      (first, 0) :=
  ⟨window_absorbs_within (Nat.le_refl 2), fun gives => gives ⟨rfl, rfl⟩⟩

/-- The alternator on the clocked carrier: the second errs at every even step. -/
def secondErrsEven (n : Nat) (a : Pair) : Prop := even n = true ∧ a = second

theorem secondErrsEven_spaced : Spaced secondErrsEven 2 := fun _ t =>
  match h : even t with
  | true => ⟨1, Nat.le_refl 2, fun errs =>
      Bool.noConfusion ((congrArg (fun b => !b) h).symm.trans errs.1)⟩
  | false => ⟨0, Nat.le.step (Nat.le_refl 1), fun errs => Bool.noConfusion (h.symm.trans errs.1)⟩

/-- **The alternator is never answered under every window of at least two**: the first gives at
every step. -/
theorem alternator_received_within {w : Nat} (two : 2 ≤ w) : ∀ n,
    ((Law.run (clocked secondErrsEven w Waits) (0, erringStart secondErrsEven)).state n).2
      (first, 0) :=
  fun n => (gives_unless_errs (spaced_mono two secondErrsEven_spaced) n first).mpr
    fun errs => Pair.noConfusion errs.2

/-- **Under every window of at least two the alternator gives exactly at the odd steps.** -/
theorem alternator_gives_odd_within {w : Nat} (two : 2 ≤ w) : ∀ n,
    ((Law.run (clocked secondErrsEven w Waits) (0, erringStart secondErrsEven)).state n).2
      (second, 0) ↔ even n = false :=
  fun n => (gives_unless_errs (spaced_mono two secondErrsEven_spaced) n second).trans
    ⟨fun no => match h : even n with
      | true => (no ⟨h, rfl⟩).elim
      | false => rfl,
     fun h errs => Bool.noConfusion (h.symm.trans errs.1)⟩

/-- The alternator is never answered under a window of two, on the carrier: the first gives at
every step. An instance of `alternator_received_within` at two, not a further result. -/
theorem alternator_received : ∀ n,
    ((Law.run (clocked secondErrsEven 2 Waits) (0, erringStart secondErrsEven)).state n).2
      (first, 0) :=
  alternator_received_within (Nat.le_refl 2)

/-- The alternator gives exactly at the odd steps under a window of two, on the carrier. An
instance of `alternator_gives_odd_within` at two, not a further result. -/
theorem alternator_gives_odd : ∀ n,
    ((Law.run (clocked secondErrsEven 2 Waits) (0, erringStart secondErrsEven)).state n).2
      (second, 0) ↔ even n = false :=
  alternator_gives_odd_within (Nat.le_refl 2)

/-- **A window of one answers the alternator**: the first withholds at every odd step
(`errs_answered` at a window of one). -/
theorem alternator_answered_one : ∀ k,
    ¬ ((Law.run (clocked secondErrsEven 1 Waits) (0, erringStart secondErrsEven)).state
      (2 * k + 1)).2 (first, 0) :=
  fun k => errs_answered (w := 0) Waits.onSecond (2 * k) fun i lt => match i, lt with
    | 0, _ => ⟨(even_two_mul k).1, rfl⟩
    | _ + 1, lt => absurd (Nat.le_of_succ_le_succ lt) (Nat.not_succ_le_zero _)

/-- **Absorbing one error at step 1 needs a window of at least two.** Where the second gives at
step 1 after the first's error at step 0, the window is at least two: a window of zero reads
nothing, and under a window of one the error is answered at step 1 (`errs_answered`). -/
theorem absorbs_needs_two : ∀ {w : Nat},
    ((Law.run (clocked firstErrsOnce w Waits) (0, erringStart firstErrsOnce)).state 1).2
      (second, 0) → 2 ≤ w
  | 0, gives => let ⟨_, lt, _⟩ := gives.2 first Waits.onFirst; absurd lt (Nat.not_lt_zero _)
  | 1, gives => absurd gives (errs_answered (w := 0) Waits.onFirst 0 fun i lt => match i, lt with
      | 0, _ => ⟨rfl, rfl⟩
      | _ + 1, lt => absurd (Nat.le_of_succ_le_succ lt) (Nat.not_succ_le_zero _))
  | _ + 2, _ => Nat.le_add_left 2 _

/-- **No window both absorbs one error and answers a formation erring at no two consecutive
steps.** Under every window `w` and every error pattern `e` of the pair spaced at two (no
formation errs at two consecutive steps, `Spaced e 2`): where the second gives at step 1 after the
first's error at step 0, every formation gives at every step at which it does not err under `e`
(`absorbs_needs_two`, `spaced_mono`, `gives_unless_errs`). So no formation withholds beside such a
pattern except at its own errors; the alternator `secondErrsEven` is one such pattern
(`not_absorbs_and_answers`). -/
theorem not_absorbs_and_answers_spaced (w : Nat) {e : Nat → Pair → Prop} (spaced : Spaced e 2) :
    ¬ (((Law.run (clocked firstErrsOnce w Waits) (0, erringStart firstErrsOnce)).state 1).2
          (second, 0) ∧
        ∃ n a, ¬ e n a ∧ ¬ ((Law.run (clocked e w Waits) (0, erringStart e)).state n).2 (a, 0)) :=
  fun ⟨absorbs, n, a, ok, out⟩ =>
    out ((gives_unless_errs (spaced_mono (absorbs_needs_two absorbs) spaced) n a).mpr ok)

/-- **No window both absorbs one error and answers the alternator.** Under every window, where the
second gives at step 1 after the first's error at step 0, the first gives at every step beside
the alternator: `not_absorbs_and_answers_spaced` at `secondErrsEven`, at which the first never
errs (an instance). Each half is met apart: a window of two absorbs (`window_absorbs`) and a
window of one answers (`alternator_answered_one`). -/
theorem not_absorbs_and_answers (w : Nat) :
    ¬ (((Law.run (clocked firstErrsOnce w Waits) (0, erringStart firstErrsOnce)).state 1).2
          (second, 0) ∧
        ∃ n, ¬ ((Law.run (clocked secondErrsEven w Waits) (0, erringStart secondErrsEven)).state
          n).2 (first, 0)) :=
  fun ⟨absorbs, n, out⟩ => not_absorbs_and_answers_spaced w secondErrsEven_spaced
    ⟨absorbs, n, first, fun errs => Pair.noConfusion errs.2, out⟩

/-- **The Bool alternator is the clocked one**: at every step, the window holder of
`alternatorStep` gives exactly where the first gives on the carrier, and the alternator exactly
where the second does. -/
theorem alternator_bridge : ∀ n,
    (((Law.run alternatorStep alternatorStart).state n).1.1 = true ↔
      ((Law.run (clocked secondErrsEven 2 Waits) (0, erringStart secondErrsEven)).state n).2
        (first, 0)) ∧
    (((Law.run alternatorStep alternatorStart).state n).1.2 = true ↔
      ((Law.run (clocked secondErrsEven 2 Waits) (0, erringStart secondErrsEven)).state n).2
        (second, 0)) :=
  fun n =>
    ⟨⟨fun _ => alternator_received n, fun _ => alternator_never_answered n⟩,
     (Iff.of_eq (congrArg (· = true) (alternator_second n))).trans
       ((ListTests.not_true_iff (a := even n)).trans (alternator_gives_odd n).symm)⟩

/-- A constant withholder on the clocked carrier: the first errs at every step. -/
def firstAlwaysErrs (_ : Nat) (a : Pair) : Prop := a = first

/-- **The clocked (d) is tight**: with the first erring at every step, the second still gives at
step 1 and withholds at every step from step 2 under a window of two. -/
theorem withholder_answered_tight :
    ((Law.run (clocked firstAlwaysErrs 2 Waits) (0, erringStart firstAlwaysErrs)).state 1).2
        (second, 0) ∧
      ∀ n, 2 ≤ n →
        ¬ ((Law.run (clocked firstAlwaysErrs 2 Waits) (0, erringStart firstAlwaysErrs)).state
          n).2 (second, 0) :=
  ⟨⟨fun errs => Pair.noConfusion errs, fun _ _ => ⟨1, Nat.le_refl 2, trivial⟩⟩,
   fun n le => withholder_answered_clocked (e := firstAlwaysErrs) (w := 1) (T := 0)
     (fun _ _ => rfl) second Waits.onFirst n le⟩

/-- Under the first's errors at every step, the second gives at lag `0` where the first gave at
lag `0` or lag `1`. -/
theorem firstAlwaysErrs_second {t : Nat} {h : Pair × Nat → Prop} :
    answersWithinErring firstAlwaysErrs 2 Waits t h (second, 0) ↔ h (first, 0) ∨ h (first, 1) :=
  ⟨fun g => lag_below_two.mp (g.2 first Waits.onFirst),
   fun g => ⟨fun errs => Pair.noConfusion errs,
     fun b link => by cases link; exact lag_below_two.mpr g⟩⟩

/-- A decided pair of last two steps, the holder's first, and a configuration agree at lags `0`
and `1`, the holder at `second` and its partner at `first`. -/
def AgainstMatches (x : (Bool × Bool) × (Bool × Bool)) (h : Pair × Nat → Prop) : Prop :=
  (x.1.1 = true ↔ h (second, 0)) ∧ (x.1.2 = true ↔ h (first, 0)) ∧
    (x.2.1 = true ↔ h (second, 1)) ∧ (x.2.2 = true ↔ h (first, 1))

/-- **A holder of the window of two against a constant withholder runs the clocked course**: at
every step, the Bool course of `windowAgainst` from `windowFacing` agrees at lags `0` and `1`,
the holder at `second` and the withholder at `first`, with the clocked run in which the first errs
at every step. -/
theorem windowAgainst_course : ∀ n,
    AgainstMatches ((Law.run windowAgainst windowFacing).state n)
      ((Law.run (clocked firstAlwaysErrs 2 Waits) (0, erringStart firstAlwaysErrs)).state n).2 :=
  course_rel (fun (x : (Bool × Bool) × (Bool × Bool)) (y : Nat × (Pair × Nat → Prop)) =>
      AgainstMatches x y.2)
    ⟨⟨fun _ errs => Pair.noConfusion errs, fun _ => rfl⟩,
     ⟨fun h => Bool.noConfusion h, fun h => (h rfl).elim⟩,
     ⟨fun _ => trivial, fun _ => rfl⟩, ⟨fun _ => trivial, fun _ => rfl⟩⟩
    fun _ y m =>
      ⟨(ListTests.or_true_iff).trans ((or_congr_both m.2.1 m.2.2.2).trans
          (firstAlwaysErrs_second (t := y.1 + 1) (h := y.2)).symm),
       ⟨fun h => Bool.noConfusion h, fun g => (g.1 rfl).elim⟩,
       m.1, m.2.1⟩

/-- **`windowTwo_answers_stays` is the clocked (d) read through the bridge**: the holder withholds
at every step from step 2, from `withholder_answered_tight`. -/
theorem windowAgainst_withholds_of_clocked :
    ∀ n, 2 ≤ n → ((Law.run windowAgainst windowFacing).state n).1.1 = false :=
  fun n le => eq_false_of_ne_true fun gives =>
    withholder_answered_tight.2 n le ((windowAgainst_course n).1.mp gives)

end Pair

/-- Two consecutive errors at the first formation of the ring, at steps `0` and `1`. -/
def ringTwoErrors (n : Nat) (a : Withholding.Ring) : Prop :=
  (n = 0 ∨ n = 1) ∧ a = Withholding.Ring.first

/-- **Two consecutive errors are answered under a window of two**: in the ring of
`Becoming.Withholding`, two errors at `first` make `second`, which waits on it, withhold at
step 2. -/
theorem ringTwoErrors_answered :
    ¬ ((Law.run (clocked ringTwoErrors 2 Withholding.Ring.Waits)
      (0, erringStart ringTwoErrors)).state (0 + 1 + 1)).2 (Withholding.Ring.second, 0) :=
  errs_answered (w := 1) Withholding.Ring.Waits.onFirst 0 fun i lt => match i, lt with
    | 0, _ => ⟨.inl rfl, rfl⟩
    | 1, _ => ⟨.inr rfl, rfl⟩
    | _ + 2, lt => absurd (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ lt))
        (Nat.not_succ_le_zero _)

end WindowedWaiting
end Becoming
