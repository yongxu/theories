import Becoming.FrontierFrames
import Becoming.SelectionPool
import Becoming.ValuationFrames
import Becoming.Relevance

/-!
# The direction on a web's moves

The practical commitments J1–J4 are stated on frames in `Becoming.FrontierFrames`, that an
extension of a web's level paths with every claim counted is exactly a widening in
`Becoming.Extension`, and what a selection through a pool's couplings reaches in
`Becoming.SelectionPool`. This module joins them on a web's moves, as a
schema over any web, any family of moves and any comparison meeting J1/J2. A move is read by the
levels it leads to (`outcome`), and a claim is a formation at a step, realized where those levels
admit it, as on `Web.paths`: the moves' frame (`Direction.frame`) is the web's frame of level paths
with the moves as its steps, so the options at any configuration are the moves' outcomes
(`Direction.options_iff`).

* **Extension is widening on the moves.** One move's outcome extends another's, with every admission
  counted, exactly where it widens it (`Direction.extension_iff_widens`).
* **A kept basic admission is not refuted at a chosen option.** Under J1/J2 on the moves' frame
  (`Priority`: the basic admissions first, then the admissions counted as living), where one move
  keeps every basic admission any move's outcome admits, no chosen move's outcome refutes a basic
  admission it makes (`Direction.chosen_keeps_basic`, from `Priority.kept_unrefuted`), and where
  the moves are listed, the comparison weakly decided and the admission decided on them, that
  admission is required of the choice (J3/J4, `Direction.kept_required`, from
  `Priority.kept_required`).
* **A narrowed move is not chosen.** Under J1/J2, a move whose outcome another move's outcome
  widens is not chosen, wherever it is decided whether the widening adds a basic admission
  (`Direction.narrowed_not_chosen`); with no decision, the widening move is never refuted to be
  better (`Direction.widening_not_not_better`).
* **What tells the moves apart is selected beyond the actor only through a member coupling it.**
  Let the rest follow one law of exchange reading through coupling in the world of each move, as
  in `Flow.act_selected_by_pool`, the part acting alike within its group's coupling closure. Where
  one move's outcome widens the other's, some formation is admitted at some step by the widening
  outcome and not by the other; it lies beyond the acting group's coupling closure, its admission
  there is a selection through the pooled coupling of every group holding it from that step on,
  and through the pooled coupling of no group within the closure at any step
  (`Direction.widening_selected_by_pool`). So a selection that realizes the direction, choosing the
  widening move over the narrowed one by the admission that differs, goes through a member
  coupled into that formation.
* **The direction from the evaluation row.** On a web whose valuation is connected, with living
  decided, the continuation condition is exactly the evaluation's grounds (a seed and both
  neutralities, `Valuation.significant_iff`) with significance for what does not live
  (`Web.unrestricted_iff_grounds_beyond`, the converse of `Valuation.premises_of_unrestricted`).
  From these, a widening is an extension of the moves' frame that retains and adds what has
  significance from every standpoint, and the admission that tells the widening world from the
  narrowed one is the continuation of a formation with significance from every standpoint,
  selected as above (`Direction.grounded_widening_selected`): one derivation from the evaluation
  row through the one object of the paths to the pool law.
* **`Clearing`.** Clearing and sparing the habitat are two moves of the clearer; sparing widens
  clearing (`Clearing.spared_widens`); under J1/J2 with no basic admission, clearing is not chosen,
  and the dweller's admission that tells them apart is selected through every pool holding the
  dweller and through no pool within the clearer's coupling closure (`Clearing.direction`).

The premises are named where they enter: J1/J2 as `Priority` (a condition on the comparison; the
core asserts it nowhere), the decision whether a widening adds a basic admission, and the law of
exchange of `Flow.act_selected_by_pool`; that on the moves' frame an extension, every admission
counted, is exactly a widening is proved, not a premise (`Direction.extension_iff_widens`). Under the
continuation condition every admission compared is a continuation with significance from every
standpoint (`Web.paths_one_object`), which fixes the scope; the order the choice theorems take is
any comparison meeting J1/J2, which meets C wherever it is decided whether an extension adds a
basic claim (`Priority.comparison`). The schema and the pool law use neither the continuation
condition nor a valuation; the direction from the evaluation row takes the condition in two parts,
the grounds and significance for what does not live, and takes no comparison. Reading a move by
the levels it leads to, and the selection of the moves by a pool's couplings, is the AI's reading
of alignment's direction (07 §7). Every declaration has an empty axiom report.
-/

namespace Becoming

open Generative Lexical Requirement FrontierFrames

namespace Direction

variable {F C A : Type}

/-- **The frame of a web's moves**: configurations are level paths, a move `a` from any path leads
to the path `outcome a`, and a formation at a step is realized along a path where its levels admit
it there, as on `Web.paths`. -/
def frame (W : Web F C) (outcome : A → Nat → C → Nat) : Frame (Nat → C → Nat) A (F × Nat) :=
  ⟨⟨fun _ a l => l = outcome a⟩, fun l e => W.Admits (l e.2) e.2 e.1⟩

variable {W : Web F C} {outcome : A → Nat → C → Nat}

/-- The options at any configuration are the moves' outcomes. -/
theorem options_iff {s l : Nat → C → Nat} :
    Options (frame W outcome) s l ↔ ∃ a, l = outcome a :=
  Iff.rfl

/-- **Extension is widening on the moves**: with every admission counted, one outcome extends another
exactly where it widens it. -/
theorem extension_iff_widens {l l' : Nat → C → Nat} :
    Extension (frame W outcome) (fun _ => True) l' l ↔ W.Widens l l' :=
  W.paths_extension_iff_widens

variable {basic : F × Nat → Prop} {better : (Nat → C → Nat) → (Nat → C → Nat) → Prop}

/-- **A kept basic admission is not refuted at a chosen option.** Under J1/J2 on the moves'
frame, where move `u`'s outcome admits every basic admission any move's outcome admits, a basic
admission it makes is not refuted at any chosen option. No decision is used. -/
theorem chosen_keeps_basic (priority : Priority (frame W outcome) basic (fun _ => True) better)
    {s : Nat → C → Nat} {u : A}
    (keeps : ∀ a e, basic e → W.Admits (outcome a e.2) e.2 e.1 → W.Admits (outcome u e.2) e.2 e.1)
    {e : F × Nat} (isBasic : basic e) (admits : W.Admits (outcome u e.2) e.2 e.1)
    {l : Nat → C → Nat} (chosen : Frontier (Options (frame W outcome) s) better l) :
    ¬ ¬ W.Admits (l e.2) e.2 e.1 :=
  priority.kept_unrefuted (u := outcome u) ⟨u, rfl⟩
    (fun t c ⟨a, same⟩ basicC held => by subst same; exact keeps a c basicC held) isBasic admits
    chosen

/-- **A kept basic admission is required of the choice** (J3/J4), where the moves' outcomes are
listed, the comparison weakly decided on them and the admission decided at each. -/
theorem kept_required (priority : Priority (frame W outcome) basic (fun _ => True) better)
    {s : Nat → C → Nat} {u : A} (x : Nat → C → Nat) (rest : List (Nat → C → Nat))
    (exact : ∀ l, Options (frame W outcome) s l ↔ l ∈ x :: rest)
    (weakly : ∀ l l', Options (frame W outcome) s l → Options (frame W outcome) s l' →
      WeaklyDecided (better l l'))
    (keeps : ∀ a e, basic e → W.Admits (outcome a e.2) e.2 e.1 → W.Admits (outcome u e.2) e.2 e.1)
    {e : F × Nat} (isBasic : basic e) (admits : W.Admits (outcome u e.2) e.2 e.1)
    (decided : ∀ l, Options (frame W outcome) s l → Decided (W.Admits (l e.2) e.2 e.1)) :
    Required (Frontier (Options (frame W outcome) s) better) fun l => W.Admits (l e.2) e.2 e.1 :=
  priority.kept_required (u := outcome u) x rest exact weakly ⟨u, rfl⟩
    (fun t c ⟨a, same⟩ basicC held => by subst same; exact keeps a c basicC held) isBasic admits
    decided

/-- **A narrowed move is not chosen.** Under J1/J2 on the moves' frame, every admission counted as
living, a move `a` whose outcome the outcome of a move `b` widens is not chosen, wherever it is
decided whether `b`'s basic admissions are among `a`'s. -/
theorem narrowed_not_chosen (priority : Priority (frame W outcome) basic (fun _ => True) better)
    {s : Nat → C → Nat} {a b : A} (widens : W.Widens (outcome b) (outcome a))
    (decided : Decided (Included (fun e => basic e ∧ W.Admits (outcome b e.2) e.2 e.1)
      (fun e => basic e ∧ W.Admits (outcome a e.2) e.2 e.1))) :
    ¬ Frontier (Options (frame W outcome) s) better (outcome a) :=
  Frontier.excluded ⟨b, rfl⟩ ((priority.iff (outcome b) (outcome a)).mpr
    (Lexical.Frame.above_of_extension (extension_iff_widens.mpr widens) decided))

/-- **With no decision, a widening move is never refuted to be better** by a comparison meeting
J1/J2 on the moves' frame, every admission counted as living. -/
theorem widening_not_not_better (priority : Priority (frame W outcome) basic (fun _ => True) better)
    {a b : A} (widens : W.Widens (outcome b) (outcome a)) : ¬ ¬ better (outcome b) (outcome a) :=
  priority.not_not_of_extension (extension_iff_widens.mpr widens)

end Direction

section Pool

variable {F C : Type} {law : ExchangeLaw F C} {L L' : Flow F C} {W W' : Web F C}
  {obs : F → C → Prop} {part : F → Bool} {group : F → Prop}

/-- **What tells a widening move from a narrowed one is selected beyond the actor only through a
member coupling it.** Under the conditions of `Flow.act_selected_by_pool` (the rest following one
law of exchange reading through coupling in two balanced flows with the same formations present,
starting alike, the part acting alike within the group's coupling closure), where the levels of
the second world widen those of the first, some formation is admitted at some step by the second
and not by the first; it lies beyond the group's coupling closure drawn through both flows; its
admission there is a selection through the pooled coupling of every group holding it from that
step on; and it is a selection through the pooled coupling of no group within that closure at any
step. -/
theorem Direction.widening_selected_by_pool (through : law.Through W obs part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : ∀ f, group f → L.ActsAlikeWithin L' W W' obs part f)
    (widens : W.Widens W'.level W.level) :
    ∃ s x, W.Admits (W'.level s) s x ∧ ¬ W.Admits (W.level s) s x ∧
      ¬ WithinClosureOf (L.CoupledFromEither W L' obs) group x ∧
      (∀ pool : F → Prop, pool x → ∀ t, s ≤ t →
        W.SelectsThroughAll obs pool t (fun l => W.Admits (l s) s x)) ∧
      ∀ pool : F → Prop,
        (∀ g, pool g → WithinClosureOf (L.CoupledFromEither W L' obs) group g) →
        ∀ t, ¬ W.SelectsThroughAll obs pool t (fun l => W.Admits (l s) s x) :=
  match widens.2 with
  | ⟨s, x, admitted, lost⟩ =>
    ⟨s, x, admitted, lost, Flow.act_selected_by_pool through follows follows' balances balances'
      present start acts fun same => lost (same.mpr admitted)⟩


/-- **The moves of a world under one law of exchange.** Move `a` is the part acting by `acts a`
and the rest by `law`, with the formations `present` and from the levels `start`; its outcome is
the levels that course generates. -/
def Direction.exchangeOutcome {A : Type} (law : ExchangeLaw F C) (part : F → Bool)
    (present : Nat → List F) (start : C → Nat) (acts : A → ExchangeLaw F C) : A → Nat → C → Nat :=
  fun a => (law.withAct part (acts a)).levels present start

/-- **What tells a widening act from a narrowed one, on a world's moves.** The moves are a
part's acts under one law of exchange (`Direction.exchangeOutcome`). The rest follows a law of
what has stood reading through coupling; the acts `acts a` and `acts b` are laws of what has
stood, `acts a` reading through its members' coupling, the two agreeing on every condition coupled
into the group's coupling closure drawn through the two courses; both courses are feasible. Where
`b`'s outcome widens `a`'s, some formation is admitted at some step by `b`'s and not by `a`'s; it
lies beyond the closure; its admission there is a selection through the pooled coupling of every
group holding it from that step on, and of no group within the closure at any step. Balance,
presence and start, premises of `Direction.widening_selected_by_pool`, hold here by
construction or follow from feasibility. -/
theorem Direction.exchange_widening_selected_by_pool {A : Type} {present : Nat → List F}
    {start : C → Nat} {acts : A → ExchangeLaw F C} {a b : A} (na : law.Nonanticipating)
    (naA : (acts a).Nonanticipating) (naB : (acts b).Nonanticipating)
    (through : law.Through W obs part) (actThrough : (acts a).Through W obs (fun h => !part h))
    (feasible : (law.withAct part (acts a)).Feasible present start)
    (feasible' : (law.withAct part (acts b)).Feasible present start)
    (agree : ∀ t h l c, part h = true →
      (∃ g, WithinClosureOf (((law.withAct part (acts a)).course present start).CoupledFromEither W
          ((law.withAct part (acts b)).course present start) obs) group g ∧ W.CoupledInto obs g c) →
        (acts a).take t h l c = (acts b).take t h l c ∧ (acts a).give t h l c = (acts b).give t h l c)
    (widens : W.Widens (Direction.exchangeOutcome law part present start acts b)
      (Direction.exchangeOutcome law part present start acts a)) :
    ∃ s x, W.Admits (Direction.exchangeOutcome law part present start acts b s) s x ∧
      ¬ W.Admits (Direction.exchangeOutcome law part present start acts a s) s x ∧
      ¬ WithinClosureOf (((law.withAct part (acts a)).course present start).CoupledFromEither W
          ((law.withAct part (acts b)).course present start) obs) group x ∧
      (∀ pool : F → Prop, pool x → ∀ t, s ≤ t →
        W.SelectsThroughAll obs pool t (fun l => W.Admits (l s) s x)) ∧
      ∀ pool : F → Prop,
        (∀ g, pool g → WithinClosureOf (((law.withAct part (acts a)).course present
          start).CoupledFromEither W ((law.withAct part (acts b)).course present start) obs) group g) →
        ∀ t, ¬ W.SelectsThroughAll obs pool t (fun l => W.Admits (l s) s x) :=
  Direction.widening_selected_by_pool (law := law)
    (W := W.withLevel (Direction.exchangeOutcome law part present start acts a))
    (W' := W.withLevel (Direction.exchangeOutcome law part present start acts b)) through
    (ExchangeLaw.withAct_follows present start) (ExchangeLaw.withAct_follows present start)
    ((ExchangeLaw.course_balances_iff (ExchangeLaw.withAct_nonanticipating na naA) W).mpr feasible)
    ((ExchangeLaw.course_balances_iff (ExchangeLaw.withAct_nonanticipating na naB) W).mpr feasible')
    (fun _ => rfl) (fun _ => rfl)
    (fun _ inGroup h member _ t alike g' c within' couples =>
      have same := actThrough h (congrArg Bool.not member) t _ _ alike c
      have both := agree t h (Direction.exchangeOutcome law part present start acts b) c member
        ⟨g', WithinClosureOf.of_member inGroup within', couples⟩
      ⟨(ExchangeLaw.withAct_take_of_part member t _ c).trans (same.1.trans
          (both.1.trans (ExchangeLaw.withAct_take_of_part member t _ c).symm)),
       (ExchangeLaw.withAct_give_of_part member t _ c).trans (same.2.trans
          (both.2.trans (ExchangeLaw.withAct_give_of_part member t _ c).symm))⟩)
    widens

/-- **The direction on a world's moves.** Under J1/J2 on the frame of a part's acts under one law
of exchange, and the premises of `Direction.exchange_widening_selected_by_pool`, an act whose
outcome another act's outcome widens is not chosen, wherever it is decided whether the widening
adds a basic admission; and what tells the two apart is admitted by the widening act's outcome,
not by the narrowed one's, beyond the acting group's coupling closure. -/
theorem Direction.exchange_direction {A : Type} {present : Nat → List F} {start : C → Nat}
    {acts : A → ExchangeLaw F C} {a b : A} {basic : F × Nat → Prop}
    {better : (Nat → C → Nat) → (Nat → C → Nat) → Prop}
    (priority : Priority (Direction.frame W (Direction.exchangeOutcome law part present start acts))
      basic (fun _ => True) better)
    (na : law.Nonanticipating)
    (naA : (acts a).Nonanticipating) (naB : (acts b).Nonanticipating)
    (through : law.Through W obs part) (actThrough : (acts a).Through W obs (fun h => !part h))
    (feasible : (law.withAct part (acts a)).Feasible present start)
    (feasible' : (law.withAct part (acts b)).Feasible present start)
    (agree : ∀ t h l c, part h = true →
      (∃ g, WithinClosureOf (((law.withAct part (acts a)).course present start).CoupledFromEither W
          ((law.withAct part (acts b)).course present start) obs) group g ∧ W.CoupledInto obs g c) →
        (acts a).take t h l c = (acts b).take t h l c ∧ (acts a).give t h l c = (acts b).give t h l c)
    (widens : W.Widens (Direction.exchangeOutcome law part present start acts b)
      (Direction.exchangeOutcome law part present start acts a))
    (decided : Decided (Included
      (fun e => basic e ∧ W.Admits (Direction.exchangeOutcome law part present start acts b e.2) e.2 e.1)
      (fun e => basic e ∧ W.Admits (Direction.exchangeOutcome law part present start acts a e.2) e.2 e.1)))
    (s0 : Nat → C → Nat) :
    ¬ Frontier (Options (Direction.frame W (Direction.exchangeOutcome law part present start acts)) s0)
        better (Direction.exchangeOutcome law part present start acts a) ∧
      ∃ s x, W.Admits (Direction.exchangeOutcome law part present start acts b s) s x ∧
        ¬ W.Admits (Direction.exchangeOutcome law part present start acts a s) s x ∧
        ¬ WithinClosureOf (((law.withAct part (acts a)).course present start).CoupledFromEither W
          ((law.withAct part (acts b)).course present start) obs) group x :=
  ⟨Direction.narrowed_not_chosen priority widens decided,
   match Direction.exchange_widening_selected_by_pool na naA naB through actThrough feasible
      feasible' agree widens with
   | ⟨s, x, admitted, lost, beyond, _⟩ => ⟨s, x, admitted, lost, beyond⟩⟩

/-- **The handover case is an instance of the direction's schema.** Every comparison meeting
J1/J2 on the tier frame of the handover's protections and gains (plans `0` expand, `1` keep, `2`
transfer, `3` withdraw) puts transfer above keeping service and above expansion, and so leaves
expansion unchosen, with expansion's real gain kept. -/
theorem Requirement.Handover.direction {better : Nat → Nat → Prop}
    (priority : Priority (tierFrame Handover.protection Handover.realization) basicSide gainSide
      better) :
    better 2 1 ∧ better 2 0 ∧ ¬ Frontier Handover.eligible better 0 ∧
      Handover.realization 0 false ∧ ¬ Handover.realization 1 false :=
  have lexical := basicPriority_iff_priority.mpr priority
  ⟨(lexical.iff 2 1).mpr Handover.transfer_above_keep,
   (lexical.iff 2 0).mpr Handover.transfer_above_expansion,
   Frontier.excluded (show 2 < 4 by decide) ((lexical.iff 2 0).mpr Handover.transfer_above_expansion),
   Handover.expansion_has_real_gain⟩

end Pool

section Scope

variable {F C Pos : Type} {sig : Pos → Nat → F → Prop} {W : Web F C}

/-- **The continuation condition is the evaluation's grounds widened to what does not live.** On a
web whose valuation is connected, with something living and a standpoint, and where it is decided
of each formation at a step whether it lives there (active and not undermining), the continuation
condition holds exactly where the grounds of the evaluation hold (a seed, N_rel and N_std,
`Valuation.significant_iff`) and the continuation of whatever does not live has significance from
every standpoint. The forward direction needs neither connection nor decision
(`Valuation.premises_of_unrestricted`); the converse uses the connection to carry the grounds to
every living formation and the decision to split the rest. -/
theorem Web.unrestricted_iff_grounds_beyond (own : Pos → F × Nat → Prop)
    (connected : (W.valuation own fun p e => sig p e.2 e.1).Connected) (p₀ : Pos)
    {e₀ : F × Nat} (alive₀ : W.active e₀.2 e₀.1 ∧ ¬ W.UnderminingAt e₀.2 e₀.1)
    (decided : ∀ e : F × Nat, (W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1) ∨
      ¬ (W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1)) :
    Unrestricted sig ↔ (W.valuation own fun p e => sig p e.2 e.1).Grounds ∧
      ∀ p (e : F × Nat), ¬ (W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1) → sig p e.2 e.1 :=
  ⟨fun unrestricted =>
    ⟨(Valuation.significant_iff connected p₀ alive₀).mp
      (Valuation.premises_of_unrestricted (V := W.valuation own fun p e => sig p e.2 e.1)
        unrestricted Prod.fst Prod.snd fun _ _ held => held).1,
     fun p e _ => unrestricted (p, e.2, e.1)⟩,
   fun ⟨grounds, beyond⟩ ⟨p, t, f⟩ =>
    match decided (f, t) with
    | .inl alive => (Valuation.significant_iff connected p₀ alive₀).mpr grounds p (f, t) alive
    | .inr dead => beyond p (f, t) dead⟩

/-- **The direction from the evaluation row.** Where the evaluation's grounds hold on a connected
web and the continuation of what does not live has significance, decided as in
`Web.unrestricted_iff_grounds_beyond`, the continuation condition holds; so on the web's level
paths it is living significance over admission, and a widening is an extension of the moves'
frame and retains and adds what has significance from every standpoint (`Web.paths_one_object`,
`Direction.extension_iff_widens`). Under the conditions of `Direction.widening_selected_by_pool`,
the admission that tells the widening world from the narrowed one is the continuation of a
formation with significance from every standpoint, admitted by the widening world and not by the
other, beyond the acting group's coupling closure, selected through the pooled coupling of every
group holding it from its step on and through no pool within that closure. The scope comes from
the grounds widened to what does not live; no comparison is taken: the theorem says what a
selection of the widening world over the narrowed one goes through, not that it occurs. -/
theorem Direction.grounded_widening_selected {A : Type} {law : ExchangeLaw F C}
    {L L' : Flow F C} {W' : Web F C} {obs : F → C → Prop} {part : F → Bool}
    {group : F → Prop} (own : Pos → F × Nat → Prop)
    (connected : (W.valuation own fun p e => sig p e.2 e.1).Connected) (p₀ : Pos)
    {e₀ : F × Nat} (alive₀ : W.active e₀.2 e₀.1 ∧ ¬ W.UnderminingAt e₀.2 e₀.1)
    (decided : ∀ e : F × Nat, (W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1) ∨
      ¬ (W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1))
    (grounds : (W.valuation own fun p e => sig p e.2 e.1).Grounds)
    (beyond : ∀ p (e : F × Nat), ¬ (W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1) →
      sig p e.2 e.1)
    (through : law.Through W obs part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : ∀ f, group f → L.ActsAlikeWithin L' W W' obs part f)
    (widens : W.Widens W'.level W.level) :
    LivingSignificance W.paths (fun _ => True) (fun _ e => ∀ p, sig p e.2 e.1) ∧
      (∀ outcome : A → Nat → C → Nat,
        Extension (Direction.frame W outcome) (fun _ => True) W.level W'.level) ∧
      (∀ p, W.Retains sig p W'.level W.level ∧ W.Adds sig p W'.level W.level) ∧
      ∃ s x, (∀ p, sig p s x) ∧ W.Admits (W'.level s) s x ∧ ¬ W.Admits (W.level s) s x ∧
        ¬ WithinClosureOf (L.CoupledFromEither W L' obs) group x ∧
        (∀ pool : F → Prop, pool x → ∀ t, s ≤ t →
          W.SelectsThroughAll obs pool t (fun l => W.Admits (l s) s x)) ∧
        ∀ pool : F → Prop,
          (∀ g, pool g → WithinClosureOf (L.CoupledFromEither W L' obs) group g) →
          ∀ t, ¬ W.SelectsThroughAll obs pool t (fun l => W.Admits (l s) s x) :=
  have unrestricted : Unrestricted sig :=
    (Web.unrestricted_iff_grounds_beyond own connected p₀ alive₀ decided).mpr ⟨grounds, beyond⟩
  have one := W.paths_one_object (sig := sig)
  match Direction.widening_selected_by_pool through follows follows' balances balances' present
    start acts widens with
  | ⟨s, x, admitted, lost, rest⟩ =>
    ⟨one.1.mp unrestricted, fun _ => Direction.extension_iff_widens.mpr widens,
     fun p => (one.2.2 unrestricted p W'.level W.level).mp widens,
     s, x, fun p => unrestricted (p, s, x), admitted, lost, rest⟩

end Scope

namespace Clearing

open Direction

/-- Two moves of the clearer: clearing the habitat as it does (`true`), or sparing it (`false`). -/
def spareOutcome : Bool → Nat → Place → Nat
  | true => web.level
  | false => sparedWeb.level

/-- **Sparing widens clearing**: the levels of the spared world admit every formation the cleared
world admits, and the dweller at the third step, which the cleared world does not. -/
theorem spared_widens : web.Widens sparedWeb.level web.level :=
  ⟨(fun _ f _ c requires => match f, c, requires with
    | .clearer, .resource, _ => Nat.le_refl 1
    | .dweller, .habitat, _ => Nat.le_succ 1
    | .source, _, no => nomatch no
    | .clearer, .habitat, no => nomatch no
    | .clearer, .fuel _, no => nomatch no
    | .dweller, .resource, no => nomatch no
    | .dweller, .fuel _, no => nomatch no),
   2, .dweller, dweller_spared, unsupported_with 0⟩

/-- **The direction in `Clearing`.** Under J1/J2 on the clearer's two moves with no basic
admission, so that the comparison is strict inclusion of what the paths admit, clearing is not
chosen; the dweller's admission at the third step tells the two moves apart, and it is a selection
through the pooled coupling of every pool holding the dweller from that step on and of no pool
within the clearer's coupling closure (`Clearing.pool_closes_gap`). -/
theorem direction {better : (Nat → Place → Nat) → (Nat → Place → Nat) → Prop}
    (priority : Priority (frame web spareOutcome) (fun _ => False) (fun _ => True) better)
    (s : Nat → Place → Nat) :
    web.Widens sparedWeb.level web.level ∧
      ¬ Frontier (Options (frame web spareOutcome) s) better web.level ∧
      (∀ pool : Formation → Prop, pool .dweller → ∀ t, 2 ≤ t →
        web.SelectsThroughAll thresholdOnly pool t (fun l => web.Admits (l 2) 2 .dweller)) ∧
      ∀ pool : Formation → Prop,
        (∀ g, pool g → WithinClosure (flow.CoupledFromEither web sparedFlow thresholdOnly)
          .clearer g) →
        ∀ t, ¬ web.SelectsThroughAll thresholdOnly pool t
          (fun l => web.Admits (l 2) 2 .dweller) :=
  ⟨spared_widens,
   narrowed_not_chosen (a := true) (b := false) priority spared_widens
     (.inl fun _ held => held.1.elim),
   pool_closes_gap.2.2.1, pool_closes_gap.2.2.2.2.2⟩

end Clearing

end Becoming
