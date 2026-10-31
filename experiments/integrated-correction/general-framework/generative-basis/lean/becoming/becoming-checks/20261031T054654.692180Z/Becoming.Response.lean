import Becoming.Testing
import Becoming.Witnesses

/-!
# Response: the comparison in which the rest responds is decided within the responsive reach

On 12 October 2026 Ren gave the go for the causal comparisons: "Great, let's finish all of them",
after the AI compared the theory with a general cause–effect system (x_{t+1} = F(x_t, u_t, ε_t),
feedback, adaptive parameters, attractors). `Becoming.Feedback` left one comparison open: the
counterfactual in which the rest of the exchange adjusts. Its comparison by withheld levels keeps
the rest fixed, and `Flow.Balances.comparison_within_difference` decides any two flows within what
their difference reaches, without saying where that difference can go. This module states where it
can go when everything outside a part responds only through what couples into it: within the
part's closure under affecting through what couples in. It is the dual, from a part's side, of the reach
blindness of `Becoming.Testing` (`Flow.alike_within_closed`), which is stated from a region's side.
No premise enters beyond balance, a common start, the same formations present, and the response
premise each law names.

* **Responsive reach.** A formation lies within a part's responsive reach between two flows when it
  lies within a member's closure under affecting through what couples in, in either flow: a
  member exchanges with a condition coupled into another formation, that formation exchanges with
  a condition coupled into a third, and so on (`Flow.WithinResponse`). Every member lies within it
  (`Flow.member_within_response`). A formation lies within it exactly when some member lies within
  the formation's coupling closure drawn through both flows, the closure of
  `Flow.alike_within_coupling` (`Flow.withinResponse_iff_coupling`, through
  `WithinClosure.converse`); with one flow, within its coupling closure
  (`Flow.withinResponse_self_iff`). It holds what the part reaches and each member's reach closure
  of P42 (`Flow.withinResponse_of_reaches`, `Flow.withinResponse_of_withinReach`); where coupling
  is by threshold only, with one flow, it is the union of the members' reach closures
  (`Flow.withinResponse_thresholdOnly_iff`). The reach closure is the converse of the influence
  closure (`WithinClosure.converse`).
* **Responding through the couplings.** The rest responds through its couplings when each
  formation outside the part exchanges alike in the two flows across every step up to which the
  flows have been alike through its couplings (`Flow.RespondsThroughCoupling`). It is a supplied
  premise. With the rest of the exchange fixed it holds whatever couples in
  (`Flow.respondsThroughCoupling_withhold`).
* **Confinement.** The formations beyond the responsive reach form a region closed in both flows
  under being affected through what couples in, and hold no member
  (`Flow.beyond_response_closed`, `Flow.outside_part_of_beyond_response`). So where the two flows
  have the same formations present, balance on what couples into those formations and start alike
  there, and the rest responds through its couplings, the flows are alike through the couplings
  of every formation beyond the responsive reach, and it exchanges alike and meets alike totals on
  every condition coupled into it, at every step (`Flow.alike_beyond_response`, an instance of
  `Flow.alike_within_closed`;
  `Flow.exchange_alike_beyond_response`, `Flow.totals_alike_beyond_response`). The difference
  between the flows reaches nothing beyond the responsive reach
  (`Flow.not_differs_beyond_response`).
* **The comparison where the rest responds.** Let two balanced flows with the same formations
  present start alike, the rest responding through its couplings. For any significance that,
  from a standpoint, covers every formation not beyond the part's responsive reach, the levels of
  each flow retain what has significance along the other's exactly as they include them, and
  neither adds a continuation with significance exactly where neither exceeds the other
  (`Flow.Balances.comparison_within_response`). The cover is of what is not beyond the reach: the
  difference shows only that a formation is not beyond it, and no decision of membership is used;
  where membership is decidable, covering the reach suffices
  (`Flow.Balances.comparison_within_response_of_decidable`).
* **Witnesses.** In `Trophic` the deer respond through their support to the wolves' taking
  (`Trophic.responds_through_coupling`). The forest lies within the wolves' responsive reach,
  which the wolves' part does not reach (`Trophic.forest_within_response`); the reach is exactly
  the wolves, the deer and the forest (`Trophic.within_response_iff`), so the responsive comparison
  of `Trophic.responsive_mixed` (`Becoming.BoundedSignificance`) is decided among them
  (`Trophic.responsive_comparison`, which proves the two excesses here, with no condition). In `Loop`
  a part's act changes what couples into another formation, the other responds, and the difference
  returns to the part's own support, which the part's own exchange never reaches
  (`Loop.returns`).

**Readings (the AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D25).**
- An act has two counterfactuals. With the rest of the exchange fixed (P42), only what the part
  reaches directly counts (`Flow.Balances.comparison_within_reach`). With the rest responding
  through its couplings, the part's closure under affecting through what couples in counts. What
  an act does to formations that interact with it is decided within the second.
- An escalation loop is the case where each party responds through its couplings and the
  difference returns to the part (`Loop.returns`). It does not show in the comparison with the
  rest fixed.
- Where coupling is by threshold only, the responsive reach is the union of the members' reach closures of
  `Becoming.Feedback`. This gives the reach closure its counterfactual meaning: it is where the
  difference an act makes can arrive when the rest responds through its support.

What is not derived: that formations respond only through their couplings (supplied as
`Flow.RespondsThroughCoupling`); how they respond; any measure of how much difference arrives,
or that any arrives within the reach. The representation commits to discrete steps and natural
quantities. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

/-- A closure under the converse of a relation is the converse of the closure: `g` lies within
`f`'s closure under the converse exactly when `f` lies within `g`'s closure under the relation: the
grammar's `«所闭之逆»` at the relation. -/
theorem WithinClosure.converse {rel : F → F → Prop} {f g : F} :
    WithinClosure (fun a b => rel b a) f g ↔ WithinClosure rel g f :=
  «所闭之逆»

namespace Flow

variable (L L' : Flow F C) (W W' : Web F C)

/-- `g` lies within the part's responsive reach between two flows: within some member's closure
under affecting through what couples in, in either flow, where `a` affects `b` so when `a`
exchanges, in one of the flows, with a condition coupled into `b`. -/
def WithinResponse (obs : F → C → Prop) (part : F → Bool) (g : F) : Prop :=
  ∃ h, part h = true ∧ WithinClosure (fun a b => L.CoupledFromEither W L' obs b a) h g

/-- The rest responds through its couplings: each formation outside the part exchanges alike
in the two flows across the step from `t` wherever the flows are alike through its couplings up
to `t`. A supplied premise: it excludes formations outside the part responding to what does not
couple into them. -/
def RespondsThroughCoupling (obs : F → C → Prop) (part : F → Bool) : Prop :=
  ∀ h, part h = false → ∀ t, W.AlikeThroughUpTo obs h W.level W'.level t →
    ∀ c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c

variable {L L' W W'} {obs : F → C → Prop} {part : F → Bool}

/-! ## The responsive reach -/

/-- Every member of the part lies within its responsive reach. -/
theorem member_within_response {h : F} (member : part h = true) :
    L.WithinResponse L' W obs part h :=
  ⟨h, member, WithinClosure.refl h⟩

/-- What lies beyond the part's responsive reach is outside the part. -/
theorem outside_part_of_beyond_response {g : F} (beyond : ¬ L.WithinResponse L' W obs part g) :
    part g = false :=
  match part g, (fun member => beyond (member_within_response member) : part g = true → False) with
  | false, _ => rfl
  | true, no => absurd rfl no

/-- **The responsive reach is the dual of the coupling closure.** `g` lies within the part's
responsive reach exactly when some member lies within `g`'s coupling closure drawn through
both flows, the closure of `alike_within_coupling`. -/
theorem withinResponse_iff_coupling {g : F} :
    L.WithinResponse L' W obs part g ↔
      ∃ h, part h = true ∧ WithinClosure (L.CoupledFromEither W L' obs) g h :=
  ⟨fun ⟨h, member, within⟩ =>
     ⟨h, member, (WithinClosure.converse (rel := L.CoupledFromEither W L' obs)).mp within⟩,
   fun ⟨h, member, within⟩ =>
     ⟨h, member, (WithinClosure.converse (rel := L.CoupledFromEither W L' obs)).mpr within⟩⟩

/-- With one flow, `g` lies within the part's responsive reach exactly when some member lies
within `g`'s coupling closure. -/
theorem withinResponse_self_iff {g : F} :
    L.WithinResponse L W obs part g ↔ ∃ h, part h = true ∧ L.WithinCoupling W obs g h :=
  ⟨fun within => match withinResponse_iff_coupling.mp within with
    | ⟨h, member, closure⟩ => ⟨h, member, WithinClosure.mono (fun _ _ related => match related with
        | .inl first => first
        | .inr second => second) closure⟩,
   fun ⟨h, member, closure⟩ => withinResponse_iff_coupling.mpr
    ⟨h, member, WithinClosure.mono (fun _ _ related => .inl related) closure⟩⟩

/-- What the part reaches lies within its responsive reach. -/
theorem withinResponse_of_reaches {g : F} :
    L.Reaches W part g → L.WithinResponse L' W obs part g
  | ⟨h, member, c, depends, exchanges⟩ =>
    ⟨h, member, WithinClosure.of_rel (.inl ⟨c, .inl depends, exchanges⟩)⟩

/-- A member's reach closure lies within the part's responsive reach. -/
theorem withinResponse_of_withinReach {h g : F} (member : part h = true)
    (within : L.WithinReach W h g) : L.WithinResponse L' W obs part g :=
  ⟨h, member, WithinClosure.mono (fun _ _ ⟨c, depends, exchanges⟩ =>
    .inl ⟨c, .inl depends, exchanges⟩) within⟩

/-- **Where coupling is by threshold only, the responsive reach is the reach closure.** With one flow, `g`
lies within the part's responsive reach exactly when it lies within some member's reach closure. -/
theorem withinResponse_thresholdOnly_iff {g : F} :
    L.WithinResponse L W thresholdOnly part g ↔ ∃ h, part h = true ∧ L.WithinReach W h g :=
  ⟨fun ⟨h, member, within⟩ => ⟨h, member, WithinClosure.mono (fun _ _ related => match related with
      | .inl ⟨c, .inl depends, exchanges⟩ => ⟨c, depends, exchanges⟩
      | .inl ⟨_, .inr no, _⟩ => False.elim no
      | .inr ⟨c, .inl depends, exchanges⟩ => ⟨c, depends, exchanges⟩
      | .inr ⟨_, .inr no, _⟩ => False.elim no) within⟩,
   fun ⟨_, member, within⟩ => withinResponse_of_withinReach member within⟩

/-- With the rest of the exchange fixed, the rest responds through its couplings, whatever
couples in: outside the part, the flow with the part withheld exchanges as the flow does. -/
theorem respondsThroughCoupling_withhold :
    L.RespondsThroughCoupling (L.withhold part) W W' obs part :=
  fun _ outside _ _ _ =>
    ⟨(withheld_eq_of_false outside _).symm, (withheld_eq_of_false outside _).symm⟩

/-! ## Confinement -/

/-- The formations beyond the part's responsive reach form a region closed, in each flow, under
being affected through what couples in: whatever exchanges with a condition coupled into such a
formation lies beyond the reach as well. -/
theorem beyond_response_closed :
    ClosedUnder (L.CoupledFrom W obs) (fun g => ¬ L.WithinResponse L' W obs part g) ∧
      ClosedUnder (L'.CoupledFrom W obs) (fun g => ¬ L.WithinResponse L' W obs part g) :=
  ⟨fun _ _ beyond related ⟨k, member, within⟩ =>
     beyond ⟨k, member, within.trans (WithinClosure.of_rel (.inl related))⟩,
   fun _ _ beyond related ⟨k, member, within⟩ =>
     beyond ⟨k, member, within.trans (WithinClosure.of_rel (.inr related))⟩⟩

/-- **Confinement.** Take two flows with the same formations present, balancing on each condition
coupled into a formation beyond the part's responsive reach and starting alike there, and let the
rest respond through its couplings. Then the flows are alike through the couplings of every
formation beyond the responsive reach at every step, whatever the part does: an instance of
`alike_within_closed`. -/
theorem alike_beyond_response
    (balanced : ∀ t g c, ¬ L.WithinResponse L' W obs part g → W.CoupledInto obs g c →
      L.BalancesOn W [c] t)
    (balanced' : ∀ t g c, ¬ L.WithinResponse L' W obs part g → W.CoupledInto obs g c →
      L'.BalancesOn W' [c] t)
    (present : ∀ t, L.present t = L'.present t)
    (start : ∀ g, ¬ L.WithinResponse L' W obs part g → ∀ c, W.CoupledInto obs g c →
      W.level 0 c = W'.level 0 c)
    (responds : L.RespondsThroughCoupling L' W W' obs part) :
    ∀ t g, ¬ L.WithinResponse L' W obs part g → W.AlikeThrough obs g W.level W'.level t :=
  alike_within_closed (region := fun g => ¬ L.WithinResponse L' W obs part g) balanced balanced'
    beyond_response_closed.1 beyond_response_closed.2 present start
    fun h beyond t alike _ c _ _ => responds h (outside_part_of_beyond_response beyond) t alike c

/-- Under the same hypotheses, every formation beyond the part's responsive reach exchanges alike
in the two flows at every step. -/
theorem exchange_alike_beyond_response
    (balanced : ∀ t g c, ¬ L.WithinResponse L' W obs part g → W.CoupledInto obs g c →
      L.BalancesOn W [c] t)
    (balanced' : ∀ t g c, ¬ L.WithinResponse L' W obs part g → W.CoupledInto obs g c →
      L'.BalancesOn W' [c] t)
    (present : ∀ t, L.present t = L'.present t)
    (start : ∀ g, ¬ L.WithinResponse L' W obs part g → ∀ c, W.CoupledInto obs g c →
      W.level 0 c = W'.level 0 c)
    (responds : L.RespondsThroughCoupling L' W W' obs part) :
    ∀ t h, ¬ L.WithinResponse L' W obs part h → ∀ c,
      L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c :=
  fun t h beyond c => responds h (outside_part_of_beyond_response beyond) t
    (fun s _ => alike_beyond_response balanced balanced' present start responds s h beyond) c

/-- Under the same hypotheses, the two flows take from and give to each condition coupled into a
formation beyond the part's responsive reach alike, in total, at every step: a formation exchanging
with it lies beyond the reach too. -/
theorem totals_alike_beyond_response
    (balanced : ∀ t g c, ¬ L.WithinResponse L' W obs part g → W.CoupledInto obs g c →
      L.BalancesOn W [c] t)
    (balanced' : ∀ t g c, ¬ L.WithinResponse L' W obs part g → W.CoupledInto obs g c →
      L'.BalancesOn W' [c] t)
    (present : ∀ t, L.present t = L'.present t)
    (start : ∀ g, ¬ L.WithinResponse L' W obs part g → ∀ c, W.CoupledInto obs g c →
      W.level 0 c = W'.level 0 c)
    (responds : L.RespondsThroughCoupling L' W W' obs part) :
    ∀ t g c, ¬ L.WithinResponse L' W obs part g → W.CoupledInto obs g c →
      L.taken t c = L'.taken t c ∧ L.given t c = L'.given t c :=
  fun t _ c beyond registers =>
    have each : ∀ h, h ∈ L.present t →
        L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c := fun _ mem =>
      exchange_agrees_within beyond_response_closed.1 beyond_response_closed.2 (present t) beyond
        registers mem fun inside =>
          exchange_alike_beyond_response balanced balanced' present start responds t _ inside c
    ⟨(total_congr_on fun h mem => (each h mem).1).trans
       (congrArg (fun as => total as fun h => L'.take t h c) (present t)),
     (total_congr_on fun h mem => (each h mem).2).trans
       (congrArg (fun as => total as fun h => L'.give t h c) (present t))⟩

/-- **The difference stays within the responsive reach.** Under the same hypotheses, the
difference between the two flows reaches no formation beyond the part's responsive reach, before
any step: each condition it requires has alike totals at every step. -/
theorem not_differs_beyond_response
    (balanced : ∀ t g c, ¬ L.WithinResponse L' W obs part g → W.CoupledInto obs g c →
      L.BalancesOn W [c] t)
    (balanced' : ∀ t g c, ¬ L.WithinResponse L' W obs part g → W.CoupledInto obs g c →
      L'.BalancesOn W' [c] t)
    (present : ∀ t, L.present t = L'.present t)
    (start : ∀ g, ¬ L.WithinResponse L' W obs part g → ∀ c, W.CoupledInto obs g c →
      W.level 0 c = W'.level 0 c)
    (responds : L.RespondsThroughCoupling L' W W' obs part) {t : Nat} {g : F}
    (beyond : ¬ L.WithinResponse L' W obs part g) : ¬ DiffersBefore L L' W t g
  | ⟨c, s, requires, _, differs⟩ =>
    have same := totals_alike_beyond_response balanced balanced' present start responds s g c
      beyond (.inl ⟨t, requires⟩)
    match differs with
    | .inl taken => taken same.1
    | .inr given => given same.2

/-! ## The comparison where the rest responds -/

/-- **The comparison where the rest responds is decided within the responsive reach.** Let two
balanced flows with the same formations present start alike, and let the rest respond through its
couplings. For any significance that, from `p`, covers every formation not beyond the part's
responsive reach, the levels of the first flow retain what has significance along the second's
exactly when they include them, and the reverse, and neither adds a continuation with significance
exactly where neither exceeds the other: the continuation condition's comparisons. The cover is stated for what is
not beyond the reach, a double negation, because the difference between the flows shows only that
a formation it reaches is not beyond (`not_differs_beyond_response`); turning that into membership
would need membership decided, which is not used. -/
theorem Balances.comparison_within_response {Pos : Type} (balances : L.Balances W)
    (balances' : L'.Balances W') (present : ∀ t, L.present t = L'.present t)
    (start : ∀ c, W.level 0 c = W'.level 0 c)
    (responds : L.RespondsThroughCoupling L' W W' obs part)
    {sig : Pos → Nat → F → Prop} {p : Pos}
    (covers : ∀ t g, ¬ ¬ L.WithinResponse L' W obs part g → sig p t g) :
    (W.Retains sig p W.level W'.level ↔ W.Includes W.level W'.level) ∧
      (W.Retains sig p W'.level W.level ↔ W.Includes W'.level W.level) ∧
      (¬ W.Adds sig p W.level W'.level ↔ ¬ W.Exceeds W.level W'.level) ∧
      (¬ W.Adds sig p W'.level W.level ↔ ¬ W.Exceeds W'.level W.level) :=
  balances.comparison_within_difference balances' start fun t g differs =>
    covers t g fun beyond =>
      not_differs_beyond_response (fun s _ c _ _ => balances.on [c] s)
        (fun s _ c _ _ => balances'.on [c] s) present (fun _ _ c _ => start c) responds beyond
        differs

/-- Where membership in the responsive reach is decidable, covering the reach itself suffices. -/
theorem Balances.comparison_within_response_of_decidable {Pos : Type} (balances : L.Balances W)
    (balances' : L'.Balances W') (present : ∀ t, L.present t = L'.present t)
    (start : ∀ c, W.level 0 c = W'.level 0 c)
    (responds : L.RespondsThroughCoupling L' W W' obs part)
    (decided : ∀ g, Decidable (L.WithinResponse L' W obs part g))
    {sig : Pos → Nat → F → Prop} {p : Pos}
    (covers : ∀ t g, L.WithinResponse L' W obs part g → sig p t g) :
    (W.Retains sig p W.level W'.level ↔ W.Includes W.level W'.level) ∧
      (W.Retains sig p W'.level W.level ↔ W.Includes W'.level W.level) ∧
      (¬ W.Adds sig p W.level W'.level ↔ ¬ W.Exceeds W.level W'.level) ∧
      (¬ W.Adds sig p W'.level W.level ↔ ¬ W.Exceeds W'.level W.level) :=
  balances.comparison_within_response balances' present start responds fun t g notBeyond =>
    match decided g with
    | isTrue within => covers t g within
    | isFalse beyond => absurd beyond notBeyond

end Flow

/-! ## Witnesses -/

/-! The trophic cascade of `Becoming.Feedback`, compared with the flow in which the deer respond. -/

namespace Trophic

/-- **The forest lies within the wolves' responsive reach, which their part does not reach.**
Between the flow with the wolves and the flow in which the deer respond, the wolves take from the
herd the deer depend on, and the deer browse the growth the forest depends on. With the rest of the
exchange fixed the wolves' part does not reach the forest (`wolves_unreached`); the difference
from the flow in which the deer respond does (`difference_reaches_forest`). -/
theorem forest_within_response :
    flow.WithinResponse responsiveFlow web thresholdOnly wolvesPart .forest ∧
      ¬ flow.Reaches web wolvesPart .forest :=
  have hunted : flow.CoupledFromEither web responsiveFlow thresholdOnly .deer .wolves :=
    .inl ⟨.herd, .inl ⟨0, trivial⟩, 0, .tail _ (.tail _ (.tail _ (.head _))), .inl Nat.zero_lt_one⟩
  have browsed : flow.CoupledFromEither web responsiveFlow thresholdOnly .forest .deer :=
    .inl ⟨.growth, .inl ⟨0, trivial⟩, 0, .tail _ (.tail _ (.head _)), .inl (Nat.succ_pos 1)⟩
  ⟨⟨.wolves, rfl, WithinClosure.trans
      (rel := fun a b => flow.CoupledFromEither web responsiveFlow thresholdOnly b a)
      (WithinClosure.of_rel hunted) (WithinClosure.of_rel browsed)⟩,
   wolves_unreached⟩

/-- In the trophic cascade the rest responds through its support. Outside the wolves' part each
formation exchanges in the flow in which the deer respond as in the flow with the wolves, wherever
the flows have been alike through its couplings: the deer browse alike at the first step, and
from the second on the herd's loss has passed into their support. -/
theorem responds_through_coupling :
    flow.RespondsThroughCoupling responsiveFlow web responsiveWeb thresholdOnly wolvesPart
  | .sun, _, _, _, _ => ⟨rfl, rfl⟩
  | .forest, _, _, _, _ => ⟨rfl, rfl⟩
  | .deer, _, 0, _, .growth => ⟨rfl, rfl⟩
  | .deer, _, 0, _, .herd => ⟨rfl, rfl⟩
  | .deer, _, 0, _, .den => ⟨rfl, rfl⟩
  | .deer, _, t + 1, alike, _ =>
    absurd ((alike 1 (Nat.succ_le_succ (Nat.zero_le t))).1.mpr fun c requires =>
        match c, requires with
        | .growth, no => nomatch no
        | .herd, _ => Nat.le_refl 1
        | .den, no => nomatch no)
      fun admits => Nat.not_succ_le_zero 0 (admits .herd trivial)
  | .wolves, no, _, _, _ => nomatch no
  | .far, _, _, _, _ => ⟨rfl, rfl⟩

/-- The wolves, the deer and the forest. -/
def responsiveReach : Formation → Prop
  | .sun => False
  | .forest => True
  | .deer => True
  | .wolves => True
  | .far => False

/-- Nothing takes from or gives to the den, in either flow. -/
theorem den_untouched : ∀ (t : Nat) (a : Formation),
    flow.take t a .den = 0 ∧ flow.give t a .den = 0 ∧ responsiveFlow.take t a .den = 0
  | _, .sun => ⟨rfl, rfl, rfl⟩
  | _, .forest => ⟨rfl, rfl, rfl⟩
  | _, .deer => ⟨rfl, rfl, rfl⟩
  | _, .wolves => ⟨rfl, rfl, rfl⟩
  | _, .far => ⟨rfl, rfl, rfl⟩

/-- Nothing exchanges, in either flow, with a condition coupled into the far formation. -/
theorem far_unaffected {a : Formation} {c : Place} :
    web.CoupledInto thresholdOnly .far c → ¬ flow.Exchanges a c ∧ ¬ responsiveFlow.Exchanges a c
  | .inr no => False.elim no
  | .inl ⟨_, requires⟩ => match c, requires with
    | .growth, no => nomatch no
    | .herd, no => nomatch no
    | .den, _ =>
      ⟨fun ⟨t, _, exchanges⟩ => match exchanges with
        | .inl takes =>
          Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le takes (Nat.le_of_eq (den_untouched t a).1))
        | .inr gives =>
          Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (den_untouched t a).2.1)),
       fun ⟨t, _, exchanges⟩ => match exchanges with
        | .inl takes =>
          Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le takes (Nat.le_of_eq (den_untouched t a).2.2))
        | .inr gives =>
          Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (den_untouched t a).2.1))⟩

/-- The wolves, the deer and the forest are closed under affecting through what couples in:
nothing couples into the sun, and nothing exchanges with what couples into the far formation. -/
theorem responsiveReach_closed :
    ClosedUnder (fun a b => flow.CoupledFromEither web responsiveFlow thresholdOnly b a)
      responsiveReach
  | _, .forest, _, _ => trivial
  | _, .deer, _, _ => trivial
  | _, .wolves, _, _ => trivial
  | _, .sun, _, .inl ⟨_, .inl ⟨_, no⟩, _⟩ => nomatch no
  | _, .sun, _, .inl ⟨_, .inr no, _⟩ => False.elim no
  | _, .sun, _, .inr ⟨_, .inl ⟨_, no⟩, _⟩ => nomatch no
  | _, .sun, _, .inr ⟨_, .inr no, _⟩ => False.elim no
  | _, .far, _, .inl ⟨_, registers, exchanges⟩ => (far_unaffected registers).1 exchanges
  | _, .far, _, .inr ⟨_, registers, exchanges⟩ => (far_unaffected registers).2 exchanges

/-- The wolves' responsive reach is exactly the wolves, the deer and the forest: the sun and the
far formation lie beyond it. -/
theorem within_response_iff {g : Formation} :
    flow.WithinResponse responsiveFlow web thresholdOnly wolvesPart g ↔ responsiveReach g :=
  ⟨fun ⟨h, member, within⟩ => within responsiveReach responsiveReach_closed
      (match h, member with
        | .sun, no => nomatch no
        | .forest, no => nomatch no
        | .deer, no => nomatch no
        | .wolves, _ => trivial
        | .far, no => nomatch no),
   fun inside => match g, inside with
    | .sun, no => nomatch no
    | .forest, _ => forest_within_response.1
    | .deer, _ => ⟨.wolves, rfl, WithinClosure.of_rel
        (.inl ⟨.herd, .inl ⟨0, trivial⟩, 0, .tail _ (.tail _ (.tail _ (.head _))),
          .inl Nat.zero_lt_one⟩)⟩
    | .wolves, _ => Flow.member_within_response rfl
    | .far, no => nomatch no⟩

/-- **The responsive comparison is decided among the wolves, the deer and the forest.** For any
significance covering, from `p`, the wolves, the deer and the forest at every step, the levels with
the wolves and those of the flow in which the deer respond retain along each other exactly as they
include each other: an instance of `Flow.Balances.comparison_within_response`. Each exceeds the
other (as in `responsive_mixed` of `Becoming.BoundedSignificance`), so neither retains. The sun and the far formation need no
significance. -/
theorem responsive_comparison {Pos : Type} {sig : Pos → Nat → Formation → Prop} {p : Pos}
    (covers : ∀ t g, responsiveReach g → sig p t g) :
    (web.Retains sig p web.level responsiveWeb.level ↔
        web.Includes web.level responsiveWeb.level) ∧
      (web.Retains sig p responsiveWeb.level web.level ↔
        web.Includes responsiveWeb.level web.level) ∧
      ¬ web.Retains sig p web.level responsiveWeb.level ∧
      ¬ web.Retains sig p responsiveWeb.level web.level :=
  have stable : ∀ g,
      ¬ ¬ flow.WithinResponse responsiveFlow web thresholdOnly wolvesPart g → responsiveReach g
    | .sun, notBeyond => notBeyond fun within => within_response_iff.mp within
    | .forest, _ => trivial
    | .deer, _ => trivial
    | .wolves, _ => trivial
    | .far, notBeyond => notBeyond fun within => within_response_iff.mp within
  have start : ∀ c, web.level 0 c = responsiveWeb.level 0 c
    | .growth => rfl
    | .herd => rfl
    | .den => rfl
  have law := balances.comparison_within_response responsive_balances (fun _ => rfl) start
    responds_through_coupling (sig := sig) (p := p)
    fun t g notBeyond => covers t g (stable g notBeyond)
  have forest : web.Exceeds web.level responsiveWeb.level :=
    ⟨2, .forest, fun c requires => match c, requires with
      | .growth, _ => Nat.succ_le_succ (Nat.zero_le 1)
      | .herd, no => nomatch no
      | .den, no => (nomatch no),
     fun admits => Nat.not_succ_le_zero 0 (admits .growth trivial)⟩
  have deer : web.Exceeds responsiveWeb.level web.level :=
    ⟨1, .deer, fun c requires => match c, requires with
      | .growth, no => nomatch no
      | .herd, _ => Nat.le_refl 1
      | .den, no => (nomatch no),
     fun admits => Nat.not_succ_le_zero 0 (admits .herd trivial)⟩
  ⟨law.1, law.2.1,
   fun retains => (law.1.mp retains).not_exceeded deer,
   fun retains => (law.2.1.mp retains).not_exceeded forest⟩

end Trophic

/-! A loop: a part's act changes what couples into another formation, the other responds, and
the difference returns to the part. -/

namespace Loop

/-- Two formations. -/
inductive Formation where
  | first
  | second

/-- The condition the first requires, and the condition the second requires. -/
inductive Place where
  | ofFirst
  | ofSecond

/-- Both formations take part at every step. -/
def members : List Formation := [.first, .second]

/-- The first formation's part. -/
def firstPart : Formation → Bool
  | .first => true
  | .second => false

/-- The condition paired with each formation: the first's is `ofFirst`, the second's `ofSecond`.
Each formation requires its paired condition, which couples into it by level. -/
def paired : Formation → Place → Prop
  | .first, .ofFirst => True
  | .first, .ofSecond => False
  | .second, .ofFirst => False
  | .second, .ofSecond => True

/-- The act: one unit across the first step. -/
def act : Nat → Nat := Witnesses.profile [1] 0

/-- The response: two units across the second step. -/
def reply : Nat → Nat := Witnesses.profile [0, 2] 0

/-- With the act: the first takes one unit of the second's condition across the first step, and
the second, the fall having coupled into it, takes two units of the first's condition across the
second. -/
def escalation : Flow Formation Place where
  present _ := members
  take t f c := match f, c with
    | .first, .ofFirst => 0
    | .first, .ofSecond => act t
    | .second, .ofFirst => reply t
    | .second, .ofSecond => 0
  give _ _ _ := 0

/-- Without the act nothing is taken: the second has nothing to respond to. -/
def quiet : Flow Formation Place where
  present _ := members
  take _ _ _ := 0
  give _ _ _ := 0

/-- The first's condition: two units, then nothing from the third step on. -/
def ofFirstLevel : Nat → Nat := Witnesses.profile [2, 2] 0

/-- The second's condition: two units, then one. -/
def ofSecondLevel : Nat → Nat := Witnesses.profile [2] 1

/-- With the act, the first is active at the first two steps only. -/
def firstLive : Nat → Prop := Witnesses.profile [True, True] False

/-- With the act: each formation requires its own condition at need one. -/
def web : Web Formation Place where
  level t c := match c with
    | .ofFirst => ofFirstLevel t
    | .ofSecond => ofSecondLevel t
  active t f := match f with
    | .first => firstLive t
    | .second => True
  requires _ := paired
  need _ _ _ := 1
  draws _ _ _ := True

/-- Without the act both conditions stay at two and both formations are active throughout. -/
def quietWeb : Web Formation Place where
  level _ _ := 2
  active _ _ := True
  requires := web.requires
  need := web.need
  draws := web.draws

theorem balances : escalation.Balances web
  | 0, .ofFirst => rfl
  | 1, .ofFirst => rfl
  | _ + 2, .ofFirst => rfl
  | 0, .ofSecond => rfl
  | _ + 1, .ofSecond => rfl

theorem quiet_balances : quiet.Balances quietWeb :=
  fun _ _ => rfl

theorem dependent : web.Dependent
  | 0, .first, _, .ofFirst, _ => Nat.succ_le_succ (Nat.zero_le 1)
  | 1, .first, _, .ofFirst, _ => Nat.succ_le_succ (Nat.zero_le 1)
  | _ + 2, .first, dead, _, _ => nomatch dead
  | _, .first, _, .ofSecond, no => nomatch no
  | 0, .second, _, .ofSecond, _ => Nat.succ_le_succ (Nat.zero_le 1)
  | _ + 1, .second, _, .ofSecond, _ => Nat.le_refl 1
  | _, .second, _, .ofFirst, no => nomatch no

theorem quiet_dependent : quietWeb.Dependent :=
  fun _ _ _ _ _ => Nat.succ_le_succ (Nat.zero_le 1)

/-- The second responds through its couplings: it takes alike in the two flows at the first
step, and at the second the fall of its condition has coupled into it. -/
theorem responds : escalation.RespondsThroughCoupling quiet web quietWeb paired firstPart
  | .first, no, _, _, _ => nomatch no
  | .second, _, 0, _, .ofFirst => ⟨rfl, rfl⟩
  | .second, _, 1, alike, .ofFirst =>
    absurd ((alike 1 (Nat.le_refl 1)).2 .ofSecond trivial)
      fun same => Nat.lt_irrefl 1
        (Nat.lt_of_lt_of_le (Nat.lt_succ_self 1) (Nat.le_of_eq same.symm))
  | .second, _, _ + 2, _, .ofFirst => ⟨rfl, rfl⟩
  | .second, _, _, _, .ofSecond => ⟨rfl, rfl⟩

/-- **The difference returns to the part.** Both flows balance and in both activity needs support;
they start alike, and the second responds through its couplings. The first's act takes from
the condition coupled into the second by level, and the second's response takes from the condition the first
requires. The first's own exchange with its condition is the same in both flows, yet with the act
the first is unsupported at the third step and without it supported. With the rest of the exchange
fixed the first's part does not reach the first, while the difference between the flows reaches it
before the third step: the loop shows only in the comparison where the rest responds. -/
theorem returns :
    escalation.Balances web ∧ quiet.Balances quietWeb ∧ web.Dependent ∧ quietWeb.Dependent ∧
      (∀ c, web.level 0 c = quietWeb.level 0 c) ∧
      escalation.RespondsThroughCoupling quiet web quietWeb paired firstPart ∧
      escalation.CoupledFromEither web quiet paired .second .first ∧
      escalation.CoupledFromEither web quiet paired .first .second ∧
      (∀ t, escalation.take t .first .ofFirst = quiet.take t .first .ofFirst ∧
        escalation.give t .first .ofFirst = quiet.give t .first .ofFirst) ∧
      ¬ web.Supported 2 .first ∧ quietWeb.Supported 2 .first ∧
      ¬ escalation.Reaches web firstPart .first ∧ Flow.DiffersBefore escalation quiet web 2 .first :=
  ⟨balances, quiet_balances, dependent, quiet_dependent,
   fun c => match c with
    | .ofFirst => rfl
    | .ofSecond => rfl,
   responds,
   .inl ⟨.ofSecond, .inl ⟨0, trivial⟩, 0, .head _, .inl Nat.zero_lt_one⟩,
   .inl ⟨.ofFirst, .inl ⟨0, trivial⟩, 1, .tail _ (.head _), .inl (Nat.succ_pos 1)⟩,
   fun _ => ⟨rfl, rfl⟩,
   fun supported => Nat.not_succ_le_zero 0 (supported .ofFirst trivial),
   fun _ _ => Nat.succ_le_succ (Nat.zero_le 1),
   fun ⟨h, member, c, ⟨_, requires⟩, _, _, exchanges⟩ =>
     match h, member, c, requires, exchanges with
     | .second, no, _, _, _ => nomatch no
     | .first, _, .ofSecond, no, _ => nomatch no
     | .first, _, .ofFirst, _, .inl takes => absurd takes (Nat.lt_irrefl 0)
     | .first, _, .ofFirst, _, .inr gives => absurd gives (Nat.lt_irrefl 0),
   ⟨.ofFirst, 1, trivial, Nat.lt_succ_self 1, .inl fun same => Nat.noConfusion same⟩⟩

end Loop

end Becoming
