import Becoming.Frontier
import Becoming.Frame
import Becoming.Extension
import Becoming.Acceptance

/-!
# The practical commitments on a frame: the moves a step can make, compared and required

`Becoming.Lexical` and `Becoming.Frontier` state the practical commitments for alternatives of any
type: J1/J2 as the condition `BasicPriority` (the comparison is the lexical order of the basic
claims, then the gains), and J3/J4 as the frontier of a comparison among eligible alternatives
and what it requires. This module states them on a frame of the spine. The alternatives are the
configurations of a frame, compared by the contents they realize, and the eligible alternatives at
a configuration are the configurations one move of the frame's process reaches from it
(`Options`): what can be done is read off the unfolding, not supplied beside it. The commitments
stay conditions; nothing here asserts a comparison.

* **J1/J2 on a frame.** `better` meets the condition on a frame where it compares configurations
  as `Lexical.Frame.Above` does, by the basic claims they realize, then the living ones
  (`Priority`). The lexical order meets it (`Lexical.BasicPriority.above`); under it `better` is irreflexive
  and transitive (`Lexical.BasicPriority.irrefl`, `Lexical.BasicPriority.trans`); a configuration keeping every basic claim
  another realizes and realizing one it lacks is better, whatever the living claims
  (`Priority.anchor`), and no number of living claims makes a configuration losing a realized
  basic claim better (`Priority.no_trade`). A generative extension is never refuted to be better
  (`Priority.not_not_of_extension`), and a comparison meeting J1/J2 meets C wherever it is decided
  whether an extension adds a basic claim (`Priority.comparison`). Every two-tier condition is this
  one on its tier frame (`basicPriority_iff_priority`).
* **The choice at a step.** The chosen configurations at `s` are the options no option betters
  (`Frontier (Options F s) better`). An option bettered by another is not chosen
  (`excluded`). Where the options are listed and the comparison is weakly decided on them, J1/J2
  leave some option chosen (`Priority.choice_exists`); asked of every frame and every comparison
  irreflexive and transitive on the options, that some option is chosen is exactly weak excluded
  middle (`choice_exists_iff_weakly`): the choice is found by settling how the moves compare. A task required of the choice is performed
  by whichever option is chosen (`performed`), what every chosen option performing it performs is
  required (`means`), and where no move is possible nothing is required (`nothing_required`).
* **A kept basic claim is required.** Where one option keeps every basic claim any option
  realizes, a basic claim it realizes is never refuted at a chosen option, with no decision
  (`Priority.kept_unrefuted`), and is required of the choice where the options are listed, the
  comparison weakly decided and the claim decided on them (`Priority.kept_required`).
* **Fresh contents under every classification.** On a frame of old and newly distinguished
  contents (`Lexical.Frame.old`, `Lexical.Frame.fresh`), with the old ones split into basic and
  living and the fresh ones classified basic where `q` holds (`classifiedOn`): with none basic
  the comparison is that with the fresh contents as gains (`Lexical.classified_none_iff`); a
  configuration is above another under every classification exactly where it keeps the other's
  fresh contents and is above with them as gains, the forward direction with no decision and the
  backward one where whether the other realizes each fresh content, and the tie at each
  classification, are decided (`Lexical.classified_robust_iff_of_decided`), so wherever excluded middle
  is named (`Lexical.classified_robust_iff_of_em`); the two extreme classifications suffice
  (`Lexical.classified_extremes_iff_of_decided`). Where every option lacking a formation is bettered,
  with the fresh contents as gains, by an option keeping its fresh contents, the formation is
  required of the choice under every classification (`Requirement.required_under_every_classification`).

Each theorem is the law of `Becoming.Lexical` or `Becoming.Frontier` it names, read on a frame;
none is a further result. Direction as in `Becoming.Lexical`: `better s t` says `s` is better.
No premise enters beyond what each theorem names; every declaration has an empty axiom report.

Declarations moved here unchanged, with their names, from `Becoming.Lexical` and `Becoming.Frontier`
(board item W): see the sections so headed.
-/

/-! ## Two tiers on a frame (moved from `Becoming.Lexical`) -/

namespace Becoming

namespace Lexical

section OnFrame

variable {S : Type} {A : Type} {C : Type}

/-- Configurations compared by the basic claims they realize, then the living ones. -/
def Frame.Above (F : Frame S A C) (basic living : C → Prop) : S → S → Prop :=
  Lexical.Above (fun s c => basic c ∧ F.realized s c) (fun s c => living c ∧ F.realized s c)

variable {H : Type} {C' : Type} {G : Type}

/-- The frame of a two-tier comparison: its configurations are the alternatives, it realizes the
basic claims on the left and the gains on the right, and it has no moves. -/
def tierFrame (basic : H → C' → Prop) (gain : H → G → Prop) : Frame H Unit (Sum C' G) :=
  ⟨⟨fun _ _ _ => False⟩, fun h c => match c with
    | .inl x => basic h x
    | .inr y => gain h y⟩

variable {basic : H → C' → Prop} {gain : H → G → Prop}

theorem included_basicSide_iff {a b : H} :
    Included (fun c => basicSide c ∧ (tierFrame basic gain).realized a c)
        (fun c => basicSide c ∧ (tierFrame basic gain).realized b c) ↔
      Included (basic a) (basic b) :=
  ⟨fun included x held => (included (.inl x) ⟨True.intro, held⟩).2,
   fun included c => match c with
    | .inl x => fun ⟨_, held⟩ => ⟨True.intro, included x held⟩
    | .inr _ => fun ⟨no, _⟩ => False.elim no⟩

theorem included_gainSide_iff {a b : H} :
    Included (fun c => gainSide c ∧ (tierFrame basic gain).realized a c)
        (fun c => gainSide c ∧ (tierFrame basic gain).realized b c) ↔
      Included (gain a) (gain b) :=
  ⟨fun included y held => (included (.inr y) ⟨True.intro, held⟩).2,
   fun included c => match c with
    | .inl _ => fun ⟨no, _⟩ => False.elim no
    | .inr y => fun ⟨_, held⟩ => ⟨True.intro, included y held⟩⟩

/-- **Every two-tier comparison is one on a frame**: the lexical order of `basic` and `gain`
compares the alternatives as `Frame.Above` compares the configurations of their tier frame. -/
theorem above_iff_frame {a b : H} :
    Lexical.Above basic gain a b ↔ Frame.Above (tierFrame basic gain) basicSide gainSide a b :=
  have pba := (included_basicSide_iff (basic := basic) (gain := gain) (a := b) (b := a)).symm
  have pab := (included_basicSide_iff (basic := basic) (gain := gain) (a := a) (b := b)).symm
  have gba := (included_gainSide_iff (basic := basic) (gain := gain) (a := b) (b := a)).symm
  have gab := (included_gainSide_iff (basic := basic) (gain := gain) (a := a) (b := b)).symm
  ⟨fun above => match above with
    | .inl strict => .inl ((strict_iff pba pab).mp strict)
    | .inr ⟨back, forth, strict⟩ => .inr ⟨pba.mp back, pab.mp forth, (strict_iff gba gab).mp strict⟩,
   fun above => match above with
    | .inl strict => .inl ((strict_iff pba pab).mpr strict)
    | .inr ⟨back, forth, strict⟩ =>
      .inr ⟨pba.mpr back, pab.mpr forth, (strict_iff gba gab).mpr strict⟩⟩

variable {F : Frame S A C} {basic' living : C → Prop}

/-- **A generative extension is above its base** wherever it is decided whether the extension adds
a basic claim. -/
theorem Frame.above_of_extension {s t : S} (extension : Extension F living s t)
    (decided : Decided (Included (fun c => basic' c ∧ F.realized t c)
      (fun c => basic' c ∧ F.realized s c))) :
    Frame.Above F basic' living t s :=
  match extension with
  | ⟨keeps, c, alive, now, before⟩ =>
    have forward : Included (fun c => basic' c ∧ F.realized s c)
        (fun c => basic' c ∧ F.realized t c) := fun c held => ⟨held.1, keeps c held.2⟩
    match decided with
    | .inr adds => .inl ⟨forward, adds⟩
    | .inl back => .inr ⟨forward, back,
        ⟨fun c held => ⟨held.1, keeps c held.2⟩, fun gback => before (gback c ⟨alive, now⟩).2⟩⟩

/-- **A generative extension is never below its base**: where `t` extends `s`, that `t` is not
lexically above `s` is refuted, with no decision. -/
theorem Frame.not_not_above_of_extension {s t : S} (extension : Extension F living s t) :
    ¬ ¬ Frame.Above F basic' living t s :=
  fun notAbove => not_not_decided _ fun decided =>
    notAbove (Frame.above_of_extension extension decided)

/-- **The lexical comparison satisfies C** wherever it is decided whether an extension adds a basic
claim. `Comparison`'s `Better s t` says `t` is better. -/
theorem Frame.comparison_of_decided
    (decided : ∀ s t, Decided (Included (fun c => basic' c ∧ F.realized t c)
      (fun c => basic' c ∧ F.realized s c))) :
    Comparison F living fun s t => Frame.Above F basic' living t s :=
  fun s t extension => Frame.above_of_extension extension (decided s t)

end OnFrame

section Classified

variable {H : Type} {C G N : Type}

variable {p : H → C → Prop} {g : H → G → Prop} {f : H → N → Prop} {a b : H}

variable {S A : Type}

/-- **Along a generative extension, an extension keeping the fresh contents is above under every
classification**, with no decision: the basic claims a frame realizes strictly grow. -/
theorem Frame.classified_of_extension (F : Frame S A C) (living : C → Prop) (g : S → G → Prop)
    (f : S → N → Prop) {a b : S} (wider : Extension F living b a)
    (fresh : Included (f b) (f a)) (q : N → Prop) : classified F.realized g f q a b :=
  match wider with
  | ⟨keeps, c, _, there, notHere⟩ => classified_of_basic
      (StrictIncluded.of_witness (fun c held => keeps c held) c there notHere) fresh q

/-- **Along a generative extension, being above under every classification is keeping the fresh
contents.** No decision is needed. -/
theorem Frame.classified_extension_iff (F : Frame S A C) (living : C → Prop) (g : S → G → Prop)
    (f : S → N → Prop) {a b : S} (wider : Extension F living b a) :
    (∀ q, classified F.realized g f q a b) ↔ Included (f b) (f a) :=
  ⟨fun robust => classified_all_retains (robust _),
   fun fresh => Frame.classified_of_extension F living g f wider fresh⟩

end Classified

section TwoKinds

variable {S A I J : Type}

/-- The old claims a frame of two kinds realizes at a configuration. -/
def Frame.old (F : Frame S A (Sum I J)) (s : S) (i : I) : Prop := F.realized s (.inl i)

/-- The newly distinguished claims a frame of two kinds realizes at a configuration. -/
def Frame.fresh (F : Frame S A (Sum I J)) (s : S) (j : J) : Prop := F.realized s (.inr j)

/-- **A frame of two kinds realizes exactly the adjoined contents of its two parts.** -/
theorem Frame.adjoin_iff (F : Frame S A (Sum I J)) (s : S) :
    ∀ x, adjoin (Frame.old F) (Frame.fresh F) s x ↔ F.realized s x
  | .inl _ => Iff.rfl
  | .inr _ => Iff.rfl

theorem Frame.included_adjoin_iff (F : Frame S A (Sum I J)) (a b : S) :
    Included (adjoin (Frame.old F) (Frame.fresh F) a) (adjoin (Frame.old F) (Frame.fresh F) b) ↔
      Included (F.realized a) (F.realized b) :=
  ⟨fun included x => match x with
    | .inl i => included (.inl i)
    | .inr j => included (.inr j),
   fun included x => match x with
    | .inl i => included (.inl i)
    | .inr j => included (.inr j)⟩

theorem Frame.strictIncluded_adjoin_iff (F : Frame S A (Sum I J)) (a b : S) :
    StrictIncluded (adjoin (Frame.old F) (Frame.fresh F) a)
        (adjoin (Frame.old F) (Frame.fresh F) b) ↔
      StrictIncluded (F.realized a) (F.realized b) :=
  ⟨fun ⟨forth, notBack⟩ => ⟨(Frame.included_adjoin_iff F a b).mp forth,
     fun back => notBack ((Frame.included_adjoin_iff F b a).mpr back)⟩,
   fun ⟨forth, notBack⟩ => ⟨(Frame.included_adjoin_iff F a b).mpr forth,
     fun back => notBack ((Frame.included_adjoin_iff F b a).mp back)⟩⟩

/-- The lexical order by basic claims and the adjoined gains is the order by the gains a frame of
gains realizes. -/
theorem Frame.above_gain_iff {C : Type} (p : S → C → Prop) (F : Frame S A (Sum I J)) (a b : S) :
    Lexical.Above p (adjoin (Frame.old F) (Frame.fresh F)) a b ↔ Lexical.Above p F.realized a b :=
  ⟨fun above => match above with
    | .inl strict => .inl strict
    | .inr ⟨back, forth, strict⟩ =>
      .inr ⟨back, forth, (Frame.strictIncluded_adjoin_iff F b a).mp strict⟩,
   fun above => match above with
    | .inl strict => .inl strict
    | .inr ⟨back, forth, strict⟩ =>
      .inr ⟨back, forth, (Frame.strictIncluded_adjoin_iff F b a).mpr strict⟩⟩

/-- The lexical order by the adjoined basic claims and gains is the order by the basic claims a
frame of basic claims realizes. -/
theorem Frame.above_basic_iff {G : Type} (F : Frame S A (Sum I J)) (g : S → G → Prop) (a b : S) :
    Lexical.Above (adjoin (Frame.old F) (Frame.fresh F)) g a b ↔ Lexical.Above F.realized g a b :=
  ⟨fun above => match above with
    | .inl strict => .inl ((Frame.strictIncluded_adjoin_iff F b a).mp strict)
    | .inr ⟨back, forth, strict⟩ =>
      .inr ⟨(Frame.included_adjoin_iff F b a).mp back, (Frame.included_adjoin_iff F a b).mp forth,
        strict⟩,
   fun above => match above with
    | .inl strict => .inl ((Frame.strictIncluded_adjoin_iff F b a).mpr strict)
    | .inr ⟨back, forth, strict⟩ =>
      .inr ⟨(Frame.included_adjoin_iff F b a).mpr back, (Frame.included_adjoin_iff F a b).mpr forth,
        strict⟩⟩

/-- **Crossed growth leaves configurations incomparable**: where the old claims strictly grow from
`a` to `b` and the fresh ones strictly shrink, neither realizes every claim of the other. -/
theorem Frame.crossed_incomparable (F : Frame S A (Sum I J)) {a b : S}
    (older : StrictIncluded (Frame.old F a) (Frame.old F b))
    (newer : StrictIncluded (Frame.fresh F b) (Frame.fresh F a)) :
    ¬ Included (F.realized a) (F.realized b) ∧ ¬ Included (F.realized b) (F.realized a) :=
  match adjoin_crossed (Frame.old F) (Frame.fresh F) a b older newer with
  | ⟨notForth, notBack⟩ =>
    ⟨fun forth => notForth ((Frame.included_adjoin_iff F a b).mpr forth),
     fun back => notBack ((Frame.included_adjoin_iff F b a).mpr back)⟩

/-- **On a frame of gains the order passes to the fresh gains**: with the basic claims equal and
`a` strictly ahead in old gains, `a` is above exactly when it keeps every fresh gain of `b`. -/
theorem Frame.gain_transfer_iff {C : Type} (p : S → C → Prop) (F : Frame S A (Sum I J)) {a b : S}
    (forth : Included (p a) (p b)) (back : Included (p b) (p a))
    (ahead : StrictIncluded (Frame.old F b) (Frame.old F a)) :
    Lexical.Above p F.realized a b ↔ Included (Frame.fresh F b) (Frame.fresh F a) :=
  (Frame.above_gain_iff p F a b).symm.trans
    (Lexical.Above.adjoin_gain_iff p (Frame.old F) (Frame.fresh F) a b forth back ahead)

/-- **On a frame of gains, fresh gains decide what the old ones leave open.** -/
theorem Frame.fresh_gains_decide {C : Type} (p : S → C → Prop) (F : Frame S A (Sum I J)) {a b : S}
    (pForth : Included (p a) (p b)) (pBack : Included (p b) (p a))
    (gForth : Included (Frame.old F a) (Frame.old F b))
    (gBack : Included (Frame.old F b) (Frame.old F a))
    (ahead : StrictIncluded (Frame.fresh F b) (Frame.fresh F a)) :
    ¬ Lexical.Above p (Frame.old F) a b ∧ ¬ Lexical.Above p (Frame.old F) b a ∧ Lexical.Above p F.realized a b :=
  match Lexical.Above.adjoin_fresh_gain p (Frame.old F) (Frame.fresh F) a b pForth pBack gForth gBack ahead
  with
  | ⟨notAB, notBA, above⟩ => ⟨notAB, notBA, (Frame.above_gain_iff p F a b).mp above⟩

/-- **On a frame of basic claims, a fresh basic claim can reverse the order.** -/
theorem Frame.fresh_basic_reverses {G R : Type} (F : Frame S A (Sum I J)) (g : S → G → Prop)
    (freshGain : S → R → Prop) {a b : S} (forth : Included (Frame.old F a) (Frame.old F b))
    (back : Included (Frame.old F b) (Frame.old F a)) (ahead : StrictIncluded (g b) (g a))
    (kept : StrictIncluded (Frame.fresh F a) (Frame.fresh F b)) :
    Lexical.Above (Frame.old F) g a b ∧ Lexical.Above F.realized (adjoin g freshGain) b a :=
  match Lexical.Above.adjoin_basic_reverses (Frame.old F) g (Frame.fresh F) freshGain a b forth back ahead
    kept with
  | ⟨above, reversed⟩ => ⟨above, (Frame.above_basic_iff F (adjoin g freshGain) b a).mp reversed⟩

end TwoKinds

end Lexical

end Becoming

/-! ## The formation witness as a process and on its frame, and a requirement through a summary (moved from `Becoming.Frontier`) -/

namespace Becoming

open Lexical

namespace Requirement

namespace Formation

/-- The continuations as moves on the amount. -/
def draw : Generative.Process Nat Form := ⟨fun a f b => b = a - drawn f⟩

/-- **From the shared amount, the step by a continuation reaches exactly what remains after
it.** -/
theorem draw_step_iff {f : Form} {b : Nat} : draw.step 6 f b ↔ b = remaining f :=
  Iff.rfl

/-- **The basis is read off the configuration reached.** -/
theorem basis_after {f : Form} {b : Nat} (step : draw.step 6 f b) : 2 ≤ b ↔ basis f :=
  Eq.subst (motive := fun x => 2 ≤ x ↔ basis f) step.symm (amount_recovers_basis f)

/-- **A step rests exactly where it draws nothing**, within the amount. -/
theorem rests_iff_free {a b : Nat} {f : Form} (within : drawn f ≤ a) (step : draw.step a f b) :
    b = a ↔ freeOccasion f () :=
  ⟨fun rests => eq_zero_of_sub_eq within (step.symm.trans rests),
   fun free => step.trans (congrArg (a - ·) free)⟩

/-- **The idle continuation's step from the shared amount rests, and the left route's step
changes the configuration**: forming the route uses the free occasion. -/
theorem idle_rests_left_changes :
    (∀ b, draw.step 6 .idle b → b = 6) ∧ (∀ b, draw.step 6 .left b → b ≠ 6) :=
  ⟨fun _ step => (rests_iff_free (Nat.zero_le 6) step).mpr formation_loses_occasion.1,
   fun _ step rests => formation_loses_occasion.2
     ((rests_iff_free (by decide : 2 ≤ 6) step).mp rests)⟩

/-- **The left route's step from the shared amount reaches four, which keeps the basis.** -/
theorem left_step_retains {b : Nat} (step : draw.step 6 .left b) : b = 4 ∧ 2 ≤ b :=
  ⟨step.trans left_retains_basis.1, (basis_after step).mpr left_retains_basis.2.1⟩

/-- **The overbuilding step reaches less than the left route's step and loses the basis.** -/
theorem overbuild_step_loses {b b' : Nat} (step : draw.step 6 .left b)
    (step' : draw.step 6 .overbuild b') : b' < b ∧ ¬ 2 ≤ b' :=
  ⟨Nat.lt_of_le_of_lt (Nat.le_of_eq step')
     (Nat.lt_of_lt_of_le (sub_lt_sub_of_lt overbuilding.1 (by decide : 5 ≤ 6))
       (Nat.le_of_eq step.symm)),
   fun two => not_basis_overbuild ((basis_after step').mp two)⟩

/-- **The report of the left and the overbuilding move is the same, while one configuration
reached keeps the basis and the other does not.** -/
theorem report_same_basis_differs {b b' : Nat} (step : draw.step 6 .left b)
    (step' : draw.step 6 .overbuild b') :
    report .left = report .overbuild ∧ 2 ≤ b ∧ ¬ 2 ≤ b' :=
  ⟨rfl, (basis_after step).mpr basis_left,
   fun two => not_basis_overbuild ((basis_after step').mp two)⟩

/-- **No judgement of the report gives whether a step from the shared amount keeps the
basis.** -/
theorem no_report_judge_of_step :
    ¬ ∃ judge : Bool → Prop, ∀ f b, draw.step 6 f b → (judge (report f) ↔ 2 ≤ b) :=
  fun ⟨judge, correct⟩ => no_report_judge
    ⟨judge, fun f => (correct f (remaining f) rfl).trans (basis_after rfl)⟩

/-- The frame of the continuations: each realizes its basic claims and its free occasion. -/
abbrev frame : Frame Form Unit (Sum Bool Unit) := tierFrame protect freeOccasion

/-- The lexical order on the frame of the continuations satisfies `BasicPriority` for its basic
claims and free occasion: it is that order read on the frame. -/
theorem priority_on_frame :
    BasicPriority protect freeOccasion (Lexical.Frame.Above frame basicSide gainSide) :=
  ⟨fun _ _ => above_iff_frame.symm⟩

/-- **Every continuation on the frontier of the frame forms the link and keeps the basis.** -/
theorem required_on_frame :
    Required (Frontier eligible (Lexical.Frame.Above frame basicSide gainSide)) formed :=
  priority_on_frame.required_iff.mpr required

/-- **Neither working route is required on the frontier of the frame.** -/
theorem no_route_required_on_frame :
    ¬ Required (Frontier eligible (Lexical.Frame.Above frame basicSide gainSide)) usesLeft ∧
      ¬ Required (Frontier eligible (Lexical.Frame.Above frame basicSide gainSide)) usesRight :=
  ⟨fun required => no_route_required.1 (priority_on_frame.required_iff.mp required),
   fun required => no_route_required.2 (priority_on_frame.required_iff.mp required)⟩

/-- **Overbuilding is off the frontier of the frame.** -/
theorem overbuild_off_frontier_on_frame :
    ¬ Frontier eligible (Lexical.Frame.Above frame basicSide gainSide) .overbuild :=
  fun frontier => overbuilding.2.2.2 (priority_on_frame.frontier_iff.mp frontier)

end Formation

section Summary

open Generative

/-- **A requirement over reachable configurations carries through a summary.** If some
configuration is reachable from `root` and each performs `task`, then through a summary `q` whose
steps map forward and lift back, some configuration is reachable from `q root` and each performs
`task'`, where `task` holds at a configuration exactly when `task'` holds at its image. From the
join `ReachableFrames`. -/
theorem Required.through_summary {S S' A : Type} {P : Process S A} {Q : Process S' A}
    (q : S → S') (preserve : ∀ s a t, P.step s a t → Q.step (q s) a (q t))
    (lift : ∀ s a r, Q.step (q s) a r → ∃ t, P.step s a t ∧ q t = r)
    {task : S → Prop} {task' : S' → Prop} (meaning : ∀ s, task s ↔ task' (q s)) (root : S)
    (required : Required (Reach P root) task) : Required (Reach Q (q root)) task' :=
  required.redescribed q (fun _ reached => Reach.map preserve reached)
    (fun _ reached => Reach.lift lift reached) meaning

end Summary

end Requirement

end Becoming


namespace Becoming

open Generative Lexical Requirement

namespace FrontierFrames

variable {S A C : Type}

/-! ## J1/J2 on a frame -/

/-- **J1/J2 on a frame**: `better` compares the configurations of `F` as the lexical order of the
basic claims they realize, then the living ones. A condition; the core asserts it nowhere. -/
def Priority (F : Frame S A C) (basic living : C → Prop) (better : S → S → Prop) : Prop :=
  BasicPriority (fun s c => basic c ∧ F.realized s c) (fun s c => living c ∧ F.realized s c) better

variable {F : Frame S A C} {basic living : C → Prop} {better : S → S → Prop}

/-- **A kept basic claim anchors the comparison**: a configuration realizing every basic claim `t`
realizes and a basic claim `t` lacks is better than `t`, whatever the living claims. -/
theorem Priority.anchor (priority : Priority F basic living better) {s t : S}
    (retain : ∀ c, basic c → F.realized t c → F.realized s c) (c : C) (isBasic : basic c)
    (restored : F.realized s c) (lost : ¬ F.realized t c) : better s t :=
  BasicPriority.anchor priority (fun c held => ⟨held.1, retain c held.1 held.2⟩) c
    ⟨isBasic, restored⟩ fun held => lost held.2

/-- **No number of living claims trades for a basic claim**: a configuration losing a basic claim
`t` realizes is not better than `t`. -/
theorem Priority.no_trade (priority : Priority F basic living better) {s t : S} (c : C)
    (isBasic : basic c) (held : F.realized t c) (lost : ¬ F.realized s c) : ¬ better s t :=
  BasicPriority.no_trade priority c ⟨isBasic, held⟩ fun realized => lost realized.2

/-- **A generative extension is never refuted to be better** under J1/J2, with no decision. -/
theorem Priority.not_not_of_extension (priority : Priority F basic living better) {s t : S}
    (extension : Extension F living s t) : ¬ ¬ better t s :=
  fun notBetter => Lexical.Frame.not_not_above_of_extension (basic' := basic) extension
    fun above => notBetter ((priority.iff t s).mpr above)

/-- **A comparison meeting J1/J2 meets C** wherever it is decided whether an extension adds a
basic claim. `Comparison`'s `Better s t` says `t` is better. -/
theorem Priority.comparison (priority : Priority F basic living better)
    (decided : ∀ s t, Decided (Included (fun c => basic c ∧ F.realized t c)
      (fun c => basic c ∧ F.realized s c))) :
    Comparison F living fun s t => better t s :=
  fun s t extension => (priority.iff t s).mpr (Lexical.Frame.comparison_of_decided decided s t extension)

/-- **Every two-tier condition is one on a frame**: its tier frame's. -/
theorem basicPriority_iff_priority {H C' G : Type} {basic : H → C' → Prop} {gain : H → G → Prop}
    {better : H → H → Prop} :
    BasicPriority basic gain better ↔ Priority (tierFrame basic gain) basicSide gainSide better :=
  ⟨fun priority => ⟨fun a b => (priority.iff a b).trans above_iff_frame⟩,
   fun priority => ⟨fun a b => (BasicPriority.iff priority a b).trans above_iff_frame.symm⟩⟩

/-! ## The choice at a step -/

/-- The options at `s`: the configurations one move of the frame's process reaches from `s`. -/
def Options (F : Frame S A C) (s : S) (t : S) : Prop := ∃ a, F.P.step s a t

/-- **J1/J2 leave some option chosen** where the options from `s` are listed and whether one
betters another is weakly decided on them. -/
theorem Priority.choice_exists (priority : Priority F basic living better) {s : S} (x : S)
    (rest : List S) (exact : ∀ t, Options F s t ↔ t ∈ x :: rest)
    (weakly : ∀ t u, Options F s t → Options F s u → WeaklyDecided (better t u)) :
    ∃ t, Frontier (Options F s) better t :=
  frontier_exists x rest exact weakly priority.irrefl fun first second => priority.trans first second

/-- **A choice at every step is weak excluded middle.** That at every configuration of every frame
whose options are listed, every comparison irreflexive and transitive on the options leaves some
option chosen holds exactly where every proposition is weakly decided, its failure decided or
refuted. Where whether one move betters another is an open question, a step need leave no move
known to be chosen: the choice is found by settling, up to double negation, how the moves
compare. -/
theorem choice_exists_iff_weakly :
    (∀ (S A C : Type) (F : Frame S A C) (better : S → S → Prop) (s x : S) (rest : List S),
        (∀ t, Options F s t ↔ t ∈ x :: rest) →
        (∀ t, Options F s t → ¬ better t t) →
        (∀ t u v, Options F s t → Options F s u → Options F s v → better t u → better u v →
          better t v) →
        ∃ t, Frontier (Options F s) better t) ↔ ∀ p : Prop, WeaklyDecided p :=
  ⟨fun choice => exists_undominated_iff_weakly.mp fun β better x rest irreflexive transitive =>
    have exact : ∀ t, Options (⟨⟨fun _ _ t => t ∈ x :: rest⟩, fun _ _ => True⟩ : Frame β Unit Unit) x t ↔
        t ∈ x :: rest :=
      fun _ => ⟨fun ⟨_, mem⟩ => mem, fun mem => ⟨(), mem⟩⟩
    match choice β Unit Unit ⟨⟨fun _ _ t => t ∈ x :: rest⟩, fun _ _ => True⟩ better x x rest exact
        (fun t option => irreflexive t ((exact t).mp option))
        (fun t u v ot ou ov => transitive t u v ((exact t).mp ot) ((exact u).mp ou) ((exact v).mp ov)) with
    | ⟨t, chosen⟩ => ⟨t, (frontier_iff_undominated exact).mp chosen⟩,
   fun weakly _ _ _ _ _ _ x rest exact irreflexive transitive =>
    match exists_undominated x rest (fun _ _ _ _ => weakly _)
        (fun t mem => irreflexive t ((exact t).mpr mem))
        (fun t u v mt mu mv => transitive t u v ((exact t).mpr mt) ((exact u).mpr mu) ((exact v).mpr mv)) with
    | ⟨t, undominated⟩ => ⟨t, (frontier_iff_undominated exact).mpr undominated⟩⟩

/-- **Where no move is possible, nothing is required.** -/
theorem nothing_required {s : S} {task : S → Prop} (stuck : ∀ a t, ¬ F.P.step s a t) :
    ¬ Required (Frontier (Options F s) better) task :=
  Required.impossible fun t chosen => match chosen.1 with
    | ⟨a, step⟩ => stuck a t step

/-- **A kept basic claim is never refuted at a chosen option**: where option `u` realizes every
basic claim any option realizes, a basic claim `u` realizes is not refuted at any chosen option.
No decision is used. -/
theorem Priority.kept_unrefuted (priority : Priority F basic living better) {s u t : S}
    (option : Options F s u) (keeps : ∀ t c, Options F s t → basic c → F.realized t c → F.realized u c)
    {c : C} (isBasic : basic c) (realizes : F.realized u c)
    (chosen : Frontier (Options F s) better t) : ¬ ¬ F.realized t c :=
  fun lacks => chosen.2 u option
    (priority.anchor (fun c' basicC held => keeps t c' chosen.1 basicC held) c isBasic realizes lacks)

/-- **A kept basic claim is required of the choice**: where option `u` realizes every basic claim
any option realizes, a basic claim `u` realizes is required of the choice, the options listed,
the comparison weakly decided and the claim decided on them. -/
theorem Priority.kept_required (priority : Priority F basic living better) {s u : S} (x : S)
    (rest : List S) (exact : ∀ t, Options F s t ↔ t ∈ x :: rest)
    (weakly : ∀ t t', Options F s t → Options F s t' → WeaklyDecided (better t t'))
    (option : Options F s u) (keeps : ∀ t c, Options F s t → basic c → F.realized t c → F.realized u c)
    {c : C} (isBasic : basic c) (realizes : F.realized u c)
    (decided : ∀ t, Options F s t → Decided (F.realized t c)) :
    Required (Frontier (Options F s) better) fun t => F.realized t c :=
  required_of_bettered x rest exact weakly priority.irrefl
    (fun first second => priority.trans first second) decided
    fun t opt lacks => ⟨u, option,
      priority.anchor (fun c' basicC held => keeps t c' opt basicC held) c isBasic realizes lacks⟩

/-! ## Fresh contents under every classification -/

section Classified

variable {I J : Type}

/-- The lexical order on a frame of old and fresh contents, the old ones split by `basic` and
`living`, the fresh ones classified basic where `q` holds. -/
def classifiedOn (F : Frame S A (Sum I J)) (basic living : I → Prop) (q : J → Prop) :
    S → S → Prop :=
  classified (fun s i => basic i ∧ Lexical.Frame.old F s i) (fun s i => living i ∧ Lexical.Frame.old F s i)
    (Lexical.Frame.fresh F) q

variable {F : Frame S A (Sum I J)} {basic living : I → Prop} {a b : S}

end Classified

end FrontierFrames

end Becoming

section AcceptanceFrames

/-!
## Scores over the options of a step: acceptance, restriction and estimates

`Becoming.Acceptance` states, for allowed choices of any type, what an accept bit given priority
over a base score does and does not protect, what restricting the choices costs, and how far a
choice best by an estimate can fall short. This section reads those laws on a frame of the spine,
the allowed choices at a configuration being its options: the configurations one move of the
frame's process reaches from it (`FrontierFrames.Options`). The scores are supplied integer
values of configurations, as in `Becoming.Acceptance`; nothing here derives a score or a warrant
for a requested change.

* **Acceptance protects only what the best options keep.** With a positive lift, every option best
  by the score with acceptance keeps access for a requested change exactly where every option best
  by the base score does (`access_iff`); where no best option keeps it, acceptance restores
  nothing (`no_access`).
* **Restricting to the options loses score, exactly.** Against a configuration best among all, the
  loss of an option best among the options is nonnegative and least among the options
  (`restriction_loss`).
* **Estimated scores.** An option best by an estimate within `err` of the actual score is within
  `2 * err` of every option (`estimate_bound`).

Each theorem is the law of `Becoming.Acceptance` it names, read on the options of a step; none is
a further result. No premise; every declaration has an empty axiom report.
-/

namespace Becoming

open Generative Acceptance FrontierFrames

namespace AcceptanceFrames

variable {S A C : Type} {F : Frame S A C}

/-- **Every option best by the score with acceptance keeps access exactly where every option best
by the base score does**, the lift positive. -/
theorem access_iff (s : S) (access : S → Prop) (q : S → Int) (lift : Int) (positive : 0 < lift) :
    (∀ x, Best (fun y : S × Bool => Options F s y.1) (AcceptScore q lift) x → access x.1) ↔
      (∀ t, Best (Options F s) q t → access t) :=
  every_optimum_has_access_iff (Options F s) access q lift positive

/-- **Where no option best by the base score keeps access, no best option does.** -/
theorem no_access (s : S) (access : S → Prop) (q : S → Int)
    (conflict : ∀ t, Best (Options F s) q t → ¬ access t) :
    ¬ ∃ t, Best (Options F s) q t ∧ access t :=
  no_base_optimal_access (Options F s) access q conflict

/-- **Restricting to the options loses score, exactly**: against a configuration best among all,
the loss of an option best among the options is nonnegative and least among them. -/
theorem restriction_loss {s : S} (q : S → Int) (u v : S) (best : Best (fun _ => True) q u)
    (bestOption : Best (Options F s) q v) :
    0 ≤ q u - q v ∧ ∀ t, Options F s t → q u - q v ≤ q u - q t :=
  unavoidable_score_loss (Options F s) q u v best bestOption

/-- **An option best by an estimate within `err` of the actual score is within `2 * err` of every
option.** -/
theorem estimate_bound {s : S} (actual estimate : S → Int) (err : Int)
    (lower : ∀ t, Options F s t → actual t - err ≤ estimate t)
    (upper : ∀ t, Options F s t → estimate t ≤ actual t + err) (chosen : S)
    (best : Best (Options F s) estimate chosen) :
    ∀ t, Options F s t → actual t - actual chosen ≤ 2 * err :=
  approximate_score_bound (Options F s) actual estimate err lower upper chosen best

end AcceptanceFrames

end Becoming

end AcceptanceFrames
