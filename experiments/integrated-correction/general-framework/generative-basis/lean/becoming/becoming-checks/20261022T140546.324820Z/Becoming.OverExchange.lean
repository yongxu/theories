import Becoming.Exclusion
import Becoming.Observation
import Becoming.OwnWidening
import Becoming.Reproduction
import Becoming.GroupEnding
import Becoming.Wholes
import Becoming.Direction
import Becoming.ExchangePremises

/-!
# The central laws over every relation of exchange

Four of the premises the spine's laws are stated under tie readings of one exchange together:
balance (`Flow.Balances`), only active relata giving (`Flow.Acting`), only active relata taking
and only from what they draw on (`Flow.Taking`), and activity needing support (`Web.Dependent`).
Read off the exchange, with the rest of the whole counted as one more relatum, they hold by what
the readings are (`Becoming.Reading`, `Becoming.ExchangePremises`). This module states each central
law of the completion criterion's coverage whose statement takes one of the four over what is read
off an exchange, the four discharged by the reading.

* **Over every world, with its rest counted.** Balance and the two activity premises hold of every
  world with its rest counted (`World.withRest_balanced`, `World.withRest_acting`,
  `World.withRest_taking`), whatever its standings, requirements and needs. So every central law
  that needs no more holds there with no premise: uptake recurring needs replenishment
  (`World.withRest_uptake_needs_replenishment`), net giving restores (`World.withRest_restores`),
  every fall is renewed by givers (`World.withRest_renewedBy`), growing uptake needs unbounded
  replenishment (`World.withRest_replenishment_unbounded`), what a family keeps and widens is
  within the margin (`World.withRest_retains_iff_within_margin`,
  `World.withRest_widens_iff_others_within`), testing and selection reach no further than the
  couplings (`World.withRest_unexcluded_beyond_coupling`,
  `World.withRest_unselected_beyond_coupling`, `World.withRest_unselected_beyond_pool`), and
  groups end with their givers (`World.withRest_rises_iff_inactive`, `World.withRest_all_end`).
  Where a law also takes a state of the law (dissipation, embodiment), that state stays its
  hypothesis (`World.withRest_opens`, `World.withRest_replenishes`, `World.withRest_lineage_ends`,
  `World.withRest_closed_lineage_lowered`). The rest theorem holds with balance by the reading and
  the census read off the exchange where a named family closes each step
  (`World.withRest_comes_to_rest_unrefuted`); the closing family, arising embodied and dissipation
  stay its hypotheses.
* **Over every two worlds of one kind of relatum.** The comparisons of two courses hold of every two
  worlds with their rests counted, balance discharged in both
  (`World.withRest_comparison_within_response`); those under a law of exchange hold under every
  law over the relata with the rest (`World.withRest_counterfactual_is_course`,
  `World.withRest_act_unselected`, `World.withRest_act_selected_by_pool`,
  `World.withRest_widening_selected_by_pool`, `World.withRest_apart_only_downstream`).
* **Over every world read off a relation of exchange.** Activity needing support is requirement
  read as necessary response. A world is read off a relation of exchange (`World.ReadOffExchange`)
  where its flow is a run of the relation along its standings and each requirement is a necessary
  response of the run's exchange; every run of every relation is such a world
  (`ExchangeRelation.Runs.readOffExchange`), and so is the course of every law of exchange, the
  relation leaving one exchange open (`ExchangeLaw.readWorld_readOffExchange`). Not every world is
  (`World.takingUnsupported_not_readOff`). With its rest counted, activity needs support in every
  such world (`World.ReadOffExchange.dependent`), so the laws needing it hold there with no
  premise: consumption ends with its feeders (`World.ReadOffExchange.consumption_ends_with_feeders`),
  taking all excludes (`World.ReadOffExchange.continuing_excludes`), the rest outruns below the need
  (`World.ReadOffExchange.outrun_below`), selection is within support
  (`World.ReadOffExchange.selection_within`, `World.ReadOffExchange.selected_le`,
  `World.ReadOffExchange.support_not_lower`, `World.ReadOffExchange.support_moved_rises`), a family
  in joint excess ends childless and its coupled groups with it
  (`World.ReadOffExchange.family_childless`, `World.ReadOffExchange.coupled_end_together`), a whole
  drawing beyond renewal ends (`World.ReadOffExchange.family_excess_ends`), and dependence read on
  roles holds (`World.ReadOffExchange.roles_dependent`). Bounded transmission, a state of the law,
  stays the hypothesis of `World.ReadOffExchange.transmitted_supported`.

**What changes in the reading.** With the rest counted, what the world's own relata do not
account for is the rest's exchange: a law that names givers or feeders counts the rest among them
where it gives. The rest is idle exactly where the world balances (`World.withRest_closed_iff`), and
for the course of a law of what has stood exactly where the course is feasible
(`ExchangeLaw.readWorld_closed_iff`): closure is a state of the law. Where it holds the rest takes
and gives nothing (`World.withRest_rest_idle`), and the world's own relata exchange and stand as in
the world (`World.withRest_some`), so the laws read the world's own relata alone. The comparisons
under a law of exchange take the law over the relata with the rest: the rest follows it where it is
outside the part, or acts with the part.

**What is not derived.** Which law or relation of exchange holds; the states of the law (closure,
dissipation, embodiment, bounded transmission, a census); each law's own hypotheses. The
representation commits to discrete steps and natural-number amounts. No ethical predicate, ranking
or axiom occurs; every declaration has an empty axiom report.
-/

namespace Becoming

/-! ## Over every world, with its rest counted -/

namespace World

variable {w : World}

/-- With the rest counted, only active relata give. -/
theorem withRest_acting : w.withRest.Acting :=
  Flow.readOff_acting

/-- With the rest counted, only active relata take, and only from what they draw on. -/
theorem withRest_taking : w.withRest.Taking :=
  Flow.readOff_taking

/-- **Under balance the rest exchanges nothing.** With the rest counted, the rest of a balanced
world takes nothing from and gives nothing to any relatum, so where the world balances the laws
stated with its rest counted read its own relata alone (`World.withRest_some`). -/
theorem withRest_rest_idle (balanced : w.Balanced) (t : Nat) (c : w.withRest.Relatum) :
    w.withRest.flow.take t none c = 0 ∧ w.withRest.flow.give t none c = 0 :=
  match c with
  | none => ⟨rfl, rfl⟩
  | some d =>
    ⟨show w.web.level t d + w.flow.given t d - (w.web.level (t + 1) d + w.flow.taken t d) = 0 from
       (congrArg (w.web.level t d + w.flow.given t d - ·) (balanced t d)).trans (Nat.sub_self _),
     show w.web.level (t + 1) d + w.flow.taken t d - (w.web.level t d + w.flow.given t d) = 0 from
       (congrArg (· - (w.web.level t d + w.flow.given t d)) (balanced t d)).trans (Nat.sub_self _)⟩

/-- With the rest counted, a relatum of the world takes from and gives to another as in the world,
and stands as it does. -/
theorem withRest_some (t : Nat) (f c : w.Relatum) :
    w.withRest.flow.take t (some f) (some c) = w.flow.take t f c ∧
      w.withRest.flow.give t (some f) (some c) = w.flow.give t f c ∧
        w.withRest.web.level t (some c) = w.web.level t c :=
  ⟨rfl, rfl, rfl⟩

/-- **The rest theorem**, in every world with its rest counted whose formations taking part are
listed once and each of whose steps a named family closes (`World.comes_to_rest_unrefuted`):
balance holds by the reading, and the census is read off the exchange (`World.withRest_counted`);
the closing family (enclosure), arising embodied and dissipation, states of the law, stay
hypotheses. -/
theorem withRest_comes_to_rest_unrefuted (distinct : ∀ t, Distinct (w.flow.present t))
    (family : Nat → List w.withRest.Relatum) (closed : ∀ t, w.withRest.flow.ClosedAt (family t) t)
    {stand : Nat → List w.withRest.Relatum} (standing : w.withRest.web.StandingCensus stand)
    (embodied : w.withRest.ArisingEmbodied) (dissipative : w.withRest.Dissipative) {T : Nat}
    (around : ∀ t, T ≤ t → w.withRest.flow.AroundStanding stand t) :
    ¬ ¬ ∃ N, w.withRest.RestsFrom N :=
  comes_to_rest_unrefuted (withRest_counted distinct family closed) standing embodied
    withRest_balanced dissipative around

/-- **Uptake recurring needs replenishment**, in every world with its rest counted
(`Flow.uptake_needs_replenishment`). -/
theorem withRest_uptake_needs_replenishment {cs : List w.withRest.Relatum}
    (uptake : ∀ N, ∃ t, N ≤ t ∧ 0 < w.withRest.flow.uptake cs t) (T : Nat) :
    ¬ ∀ t, T ≤ t → w.withRest.flow.replenishment cs t = 0 :=
  Flow.uptake_needs_replenishment (W := w.withRest.web) (balances := withRest_balanced) uptake T

/-- **An embodied relatum arising is replenished**, in every world with its rest counted
(`Web.Embodied.replenishes`); embodiment, a state of the law, stays a hypothesis. -/
theorem withRest_replenishes {x : w.withRest.Relatum} (embodied : w.withRest.web.Embodied x)
    {cs : List w.withRest.Relatum} (mem : x ∈ cs) {t : Nat} (arises : w.withRest.web.Arises t x) :
    0 < w.withRest.flow.replenishment cs t :=
  Web.Embodied.replenishes (L := w.withRest.flow) (balances := withRest_balanced) embodied mem
    arises

/-- **Net giving restores**, in every world with its rest counted (`Flow.restores`). -/
theorem withRest_restores {c : w.withRest.Relatum} {m T : Nat}
    (netGive : ∀ k, k < m - w.withRest.web.level T c →
      w.withRest.web.level T c ≤ w.withRest.web.level (T + k) c →
        w.withRest.flow.taken (T + k) c < w.withRest.flow.given (T + k) c) :
    m ≤ w.withRest.web.level (T + (m - w.withRest.web.level T c)) c :=
  Flow.restores (balances := withRest_balanced) netGive

/-- **Every fall is renewed by givers**, in every world with its rest counted
(`Flow.Balances.renewedBy`). -/
theorem withRest_renewedBy :
    w.withRest.web.RenewedBy fun t f c =>
      f ∈ w.withRest.flow.present t ∧ 0 < w.withRest.flow.give t f c :=
  Flow.Balances.renewedBy (balances := withRest_balanced) (acting := withRest_acting)

/-- **Growing uptake needs unbounded replenishment**, in every world with its rest counted
(`Flow.More.replenishment_unbounded`). -/
theorem withRest_replenishment_unbounded {cs : List w.withRest.Relatum}
    (more : w.withRest.flow.More cs) (R T₀ : Nat) :
    ¬ ∀ t, T₀ ≤ t → w.withRest.flow.replenishment cs t ≤ R :=
  Flow.More.replenishment_unbounded (W := w.withRest.web) (balances := withRest_balanced)
    (more := more) R T₀

/-- **Taking recurring from an enclosed family opens it**, in every world with its rest counted
(`Flow.Dissipative.opens`); dissipation, a state of the law, stays a hypothesis. -/
theorem withRest_opens (dissipative : w.withRest.Dissipative)
    {cs ds : List w.withRest.Relatum} (distinct : Distinct ds) (within : ∀ c, c ∈ cs → c ∈ ds)
    (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < w.withRest.flow.takers cs t) (T : Nat) :
    ¬ ∀ t, T ≤ t → w.withRest.flow.ClosedAt ds t :=
  Flow.Dissipative.opens (W := w.withRest.web) (balances := withRest_balanced)
    (dissipative := dissipative) distinct within recurs T

/-- **Testing reaches no further than the couplings**, in every world with its rest counted
(`Flow.unexcluded_beyond_coupling`). -/
theorem withRest_unexcluded_beyond_coupling {obs : w.withRest.Relatum → w.withRest.Relatum → Prop}
    {part : w.withRest.Relatum → Bool} {l : Nat → w.withRest.Relatum → Nat}
    (without : w.withRest.flow.WithheldLevels part w.withRest.web l) {f : w.withRest.Relatum}
    (beyond : ∀ h, part h = true → ¬ w.withRest.flow.WithinCoupling w.withRest.web obs f h)
    {claim : (Nat → w.withRest.Relatum → Nat) → Prop} (meets : claim l) :
    ∀ t g, w.withRest.flow.WithinCoupling w.withRest.web obs f g →
      ¬ w.withRest.web.Excludes obs claim g w.withRest.web.level t :=
  Flow.unexcluded_beyond_coupling without
    (fun t _ c _ _ => Flow.Balances.on (withRest_balanced (w := w)) [c] t) beyond meets

/-- **Selection reaches no further than the couplings**, in every world with its rest counted
(`Flow.unselected_beyond_coupling`). -/
theorem withRest_unselected_beyond_coupling {obs : w.withRest.Relatum → w.withRest.Relatum → Prop}
    {part : w.withRest.Relatum → Bool} {l : Nat → w.withRest.Relatum → Nat}
    {select : (Nat → w.withRest.Relatum → Nat) → Prop}
    (without : w.withRest.flow.WithheldLevels part w.withRest.web l) {f : w.withRest.Relatum}
    (beyond : ∀ h, part h = true → ¬ w.withRest.flow.WithinCoupling w.withRest.web obs f h)
    {g : w.withRest.Relatum} (within : w.withRest.flow.WithinCoupling w.withRest.web obs f g)
    {t : Nat} (through : w.withRest.web.SelectsThrough obs g t select) :
    select w.withRest.web.level ↔ select l :=
  Flow.unselected_beyond_coupling without
    (fun t _ c _ _ => Flow.Balances.on (withRest_balanced (w := w)) [c] t) beyond within through

/-- **A pool selects nothing beyond its couplings**, in every world with its rest counted
(`Flow.unselected_beyond_pool`). -/
theorem withRest_unselected_beyond_pool {obs : w.withRest.Relatum → w.withRest.Relatum → Prop}
    {part : w.withRest.Relatum → Bool} {group : w.withRest.Relatum → Prop}
    {l : Nat → w.withRest.Relatum → Nat} {select : (Nat → w.withRest.Relatum → Nat) → Prop}
    (without : w.withRest.flow.WithheldLevels part w.withRest.web l)
    (beyond : ∀ h, part h = true → ¬ w.withRest.flow.WithinPoolCoupling w.withRest.web obs group h)
    {pool : w.withRest.Relatum → Prop}
    (members : ∀ g, pool g → w.withRest.flow.WithinPoolCoupling w.withRest.web obs group g) {t : Nat}
    (through : w.withRest.web.SelectsThroughAll obs pool t select) :
    select w.withRest.web.level ↔ select l :=
  Flow.unselected_beyond_pool without
    (fun t _ c _ _ => Flow.Balances.on (withRest_balanced (w := w)) [c] t) beyond members through

/-- **What a family retains is within the margin**, in every world with its rest counted
(`Flow.Balances.retains_iff_within_margin`). -/
theorem withRest_retains_iff_within_margin {Pos : Type} {part : w.withRest.Relatum → Bool}
    {l : Nat → w.withRest.Relatum → Nat}
    (without : w.withRest.flow.WithheldLevels part w.withRest.web l)
    {sig : Pos → Nat → w.withRest.Relatum → Prop} {p : Pos} :
    w.withRest.web.Retains sig p w.withRest.web.level l ↔
      ∀ t f, sig p t f → w.withRest.web.Admits (l t) t f → ∀ c, w.withRest.web.requires t f c →
        w.withRest.web.need t f c +
            total (steps 0 t) (fun s => w.withRest.flow.partTaken part s c) ≤
          l t c + total (steps 0 t) (fun s => w.withRest.flow.partGiven part s c) :=
  Flow.Balances.retains_iff_within_margin (balances := withRest_balanced) without

/-- **The whole widens exactly where the others stay within the margin**, in every world with its
rest counted (`Flow.Balances.widens_iff_others_within`). -/
theorem withRest_widens_iff_others_within {part : w.withRest.Relatum → Bool}
    {l : Nat → w.withRest.Relatum → Nat}
    (without : w.withRest.flow.WithheldLevels part w.withRest.web l)
    {own : w.withRest.Relatum → Bool}
    (ownWidens : w.withRest.web.WidensWithin own w.withRest.web.level l) :
    w.withRest.web.Widens w.withRest.web.level l ↔
      ∀ t f, own f = false → w.withRest.web.Admits (l t) t f → ∀ c, w.withRest.web.requires t f c →
        w.withRest.web.need t f c +
            total (steps 0 t) (fun s => w.withRest.flow.partTaken part s c) ≤
          l t c + total (steps 0 t) (fun s => w.withRest.flow.partGiven part s c) :=
  Flow.Balances.widens_iff_others_within (balances := withRest_balanced) without ownWidens

/-- **A lineage within a dissipated family ends**, in every world with its rest counted
(`Reproduction.Flow.lineage_ends`); dissipation on the family stays a hypothesis. -/
theorem withRest_lineage_ends {G : SelectionTerm.Generations w.withRest.Relatum}
    {ds : List w.withRest.Relatum}
    (descended : SelectionTerm.Flow.Descended w.withRest.flow w.withRest.web G)
    (within : ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → k ∈ ds)
    (dissipates : ∀ t, t < w.withRest.web.stock ds 0 + 1 → w.withRest.flow.DissipatesOn ds t) :
    G.size (w.withRest.web.stock ds 0 + 1) = 0 :=
  Reproduction.Flow.lineage_ends descended within
    (fun t _ => Flow.Balances.on (withRest_balanced (w := w)) ds t) dissipates

/-- **A closed lineage's transmission lowers offspring number by more than selection raises it**,
in every world with its rest counted (`Reproduction.Flow.closed_lineage_lowered`). -/
theorem withRest_closed_lineage_lowered {G : SelectionTerm.Generations w.withRest.Relatum}
    {ds : List w.withRest.Relatum}
    (descended : SelectionTerm.Flow.Descended w.withRest.flow w.withRest.web G)
    (within : ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → k ∈ ds)
    (dissipates : ∀ t, t < w.withRest.web.stock ds 0 + 1 → w.withRest.flow.DissipatesOn ds t)
    (number : Reproduction.Generations.ByNumber G) (reproducing : 0 < G.size 1) :
    ∃ t, t < w.withRest.web.stock ds 0 ∧
      G.concordAt t + G.size t * G.raisedAt t < G.size t * G.loweredAt t :=
  Reproduction.Flow.closed_lineage_lowered descended within
    (fun t _ => Flow.Balances.on (withRest_balanced (w := w)) ds t) dissipates number reproducing

/-- **A group rises exactly as selection within and among it says, where the lower groups are
inactive**, in every world with its rest counted (`GroupEnding.Flow.rises_iff_inactive`). -/
theorem withRest_rises_iff_inactive {G : SelectionTerm.Generations w.withRest.Relatum}
    (descended : SelectionTerm.Flow.Descended w.withRest.flow w.withRest.web G) {t m : Nat}
    (gs : List (List w.withRest.Relatum)) (listed : SelectionLevels.whole gs = G.family t)
    (equal : ∀ g, g ∈ gs → g.length = m)
    (exact : SelectionTerm.Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (inactive : ∀ g h, g ∈ gs → h ∈ gs → total h (G.amount t) < total g (G.amount t) →
      ∀ p, p ∈ h → ¬ w.withRest.web.active t p) :
    G.Raises t ↔
      gs.length * SelectionLevels.discordWithin gs (G.offspringNumber t) (G.amount t) <
        gs.length * SelectionLevels.concordWithin gs (G.offspringNumber t) (G.amount t) +
          SelectionLevels.concordAmong gs (G.offspringNumber t) (G.amount t) :=
  GroupEnding.Flow.rises_iff_inactive (acting := withRest_acting) descended gs listed equal exact
    inactive

/-- **A family none of whose members is active has no next generation**, in every world with its
rest counted (`GroupEnding.Flow.all_end`). -/
theorem withRest_all_end {G : SelectionTerm.Generations w.withRest.Relatum}
    (descended : SelectionTerm.Flow.Descended w.withRest.flow w.withRest.web G) {t : Nat}
    (inactive : ∀ p, p ∈ G.family t → ¬ w.withRest.web.active t p) : G.size (t + 1) = 0 :=
  GroupEnding.Flow.all_end (acting := withRest_acting) descended inactive

end World

/-! ## Over every two worlds of one kind of relatum -/

namespace World

variable {R : Type} {L L' : Flow R R} {W W' : Web R R}

/-- With the rests counted, two worlds whose relata take part alike take part alike. -/
theorem withRest_present (present : ∀ t, L.present t = L'.present t) (t : Nat) :
    (World.of R L W).withRest.flow.present t = (World.of R L' W').withRest.flow.present t :=
  congrArg (fun p => none :: List.map some p) (present t)

/-- With the rests counted, two worlds starting alike start alike. -/
theorem withRest_start (start : ∀ c, W.level 0 c = W'.level 0 c) :
    ∀ c, (World.of R L W).withRest.web.level 0 c = (World.of R L' W').withRest.web.level 0 c
  | none => rfl
  | some c => start c

/-- **Comparison is decided within the response**, for every two worlds with their rests counted
(`Flow.Balances.comparison_within_response`). -/
theorem withRest_comparison_within_response {Pos : Type}
    {obs : Option R → Option R → Prop} {part : Option R → Bool}
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (responds : (World.of R L W).withRest.flow.RespondsThroughCoupling
      (World.of R L' W').withRest.flow (World.of R L W).withRest.web
      (World.of R L' W').withRest.web obs part)
    {sig : Pos → Nat → Option R → Prop} {p : Pos}
    (covers : ∀ t g, ¬ ¬ (World.of R L W).withRest.flow.WithinResponse
      (World.of R L' W').withRest.flow (World.of R L W).withRest.web obs part g → sig p t g) :
    ((World.of R L W).withRest.web.Retains sig p (World.of R L W).withRest.web.level
          (World.of R L' W').withRest.web.level ↔
        (World.of R L W).withRest.web.Includes (World.of R L W).withRest.web.level
          (World.of R L' W').withRest.web.level) ∧
      ((World.of R L W).withRest.web.Retains sig p (World.of R L' W').withRest.web.level
          (World.of R L W).withRest.web.level ↔
        (World.of R L W).withRest.web.Includes (World.of R L' W').withRest.web.level
          (World.of R L W).withRest.web.level) ∧
      (¬ (World.of R L W).withRest.web.Adds sig p (World.of R L W).withRest.web.level
          (World.of R L' W').withRest.web.level ↔
        ¬ (World.of R L W).withRest.web.Exceeds (World.of R L W).withRest.web.level
          (World.of R L' W').withRest.web.level) ∧
      (¬ (World.of R L W).withRest.web.Adds sig p (World.of R L' W').withRest.web.level
          (World.of R L W).withRest.web.level ↔
        ¬ (World.of R L W).withRest.web.Exceeds (World.of R L' W').withRest.web.level
          (World.of R L W).withRest.web.level) :=
  Flow.Balances.comparison_within_response (L := (World.of R L W).withRest.flow)
    (L' := (World.of R L' W').withRest.flow) (W := (World.of R L W).withRest.web)
    (W' := (World.of R L' W').withRest.web) (balances := withRest_balanced)
    (balances' := withRest_balanced) (withRest_present present) (withRest_start start) responds
    covers

/-- **The counterfactual of an act is the course it generates**, for every world with its rest
counted and every law of what has stood over its relata (`counterfactual_is_course`); feasibility,
a state of the law, stays a hypothesis. -/
theorem withRest_counterfactual_is_course {w : World}
    {law act : ExchangeLaw w.withRest.Relatum w.withRest.Relatum} {part : w.withRest.Relatum → Bool}
    (na : law.Nonanticipating) (naAct : act.Nonanticipating)
    {present : Nat → List w.withRest.Relatum} {start : w.withRest.Relatum → Nat}
    (onPresent : ∀ t, w.withRest.flow.present t = present t)
    (acts : w.withRest.flow.ActsAlike ((law.withAct part act).course present start) part)
    (follows : w.withRest.flow.Follows law part w.withRest.web.level)
    (begins : ∀ c, w.withRest.web.level 0 c = start c)
    (feasible : (law.withAct part act).Feasible present start) :
    (∀ t c, w.withRest.web.level t c = (law.withAct part act).levels present start t c) ∧
      ∀ t h c, w.withRest.flow.take t h c = ((law.withAct part act).course present start).take t h c ∧
        w.withRest.flow.give t h c = ((law.withAct part act).course present start).give t h c :=
  counterfactual_is_course na naAct (balances := withRest_balanced) onPresent acts follows begins
    feasible

/-- **An act is unselected within the coupling closure**, for every two worlds of one kind of
relatum with their rests counted, under every law of exchange over the relata with the rest
(`Flow.act_unselected`). -/
theorem withRest_act_unselected {law : ExchangeLaw (Option R) (Option R)}
    {obs : Option R → Option R → Prop} {part : Option R → Bool} {f : Option R}
    {select : (Nat → Option R → Nat) → Prop}
    (through : law.Through (World.of R L W).withRest.web obs part)
    (follows : (World.of R L W).withRest.flow.Follows law part (World.of R L W).withRest.web.level)
    (follows' :
      (World.of R L' W').withRest.flow.Follows law part (World.of R L' W').withRest.web.level)
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : (World.of R L W).withRest.flow.ActsAlikeWithin (World.of R L' W').withRest.flow
      (World.of R L W).withRest.web (World.of R L' W').withRest.web obs part f)
    {g : Option R} (within : WithinClosure ((World.of R L W).withRest.flow.CoupledFromEither
      (World.of R L W).withRest.web (World.of R L' W').withRest.flow obs) f g) {t : Nat}
    (selects : (World.of R L W).withRest.web.SelectsThrough obs g t select) :
    select (World.of R L W).withRest.web.level ↔ select (World.of R L' W').withRest.web.level :=
  Flow.act_unselected (L := (World.of R L W).withRest.flow) (L' := (World.of R L' W').withRest.flow)
    (W := (World.of R L W).withRest.web) (W' := (World.of R L' W').withRest.web) through follows
    follows' withRest_balanced withRest_balanced (withRest_present present) (withRest_start start)
    acts within selects

/-- **Pooling with the formation whose admission an act changes selects the act**, for every two
worlds of one kind of relatum with their rests counted, under every law of exchange over the relata
with the rest (`Flow.act_selected_by_pool`). -/
theorem withRest_act_selected_by_pool {law : ExchangeLaw (Option R) (Option R)}
    {obs : Option R → Option R → Prop} {part : Option R → Bool} {group : Option R → Prop}
    (through : law.Through (World.of R L W).withRest.web obs part)
    (follows : (World.of R L W).withRest.flow.Follows law part (World.of R L W).withRest.web.level)
    (follows' :
      (World.of R L' W').withRest.flow.Follows law part (World.of R L' W').withRest.web.level)
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : ∀ f, group f → (World.of R L W).withRest.flow.ActsAlikeWithin
      (World.of R L' W').withRest.flow (World.of R L W).withRest.web (World.of R L' W').withRest.web
      obs part f)
    {x : Option R} {s : Nat}
    (differs : ¬ ((World.of R L W).withRest.web.Admits ((World.of R L W).withRest.web.level s) s x ↔
      (World.of R L W).withRest.web.Admits ((World.of R L' W').withRest.web.level s) s x)) :
    ¬ WithinClosureOf ((World.of R L W).withRest.flow.CoupledFromEither (World.of R L W).withRest.web
        (World.of R L' W').withRest.flow obs) group x ∧
      (∀ pool : Option R → Prop, pool x → ∀ t, s ≤ t →
        (World.of R L W).withRest.web.SelectsThroughAll obs pool t
          (fun l => (World.of R L W).withRest.web.Admits (l s) s x)) ∧
      ∀ pool : Option R → Prop,
        (∀ g, pool g → WithinClosureOf ((World.of R L W).withRest.flow.CoupledFromEither
          (World.of R L W).withRest.web (World.of R L' W').withRest.flow obs) group g) →
        ∀ t, ¬ (World.of R L W).withRest.web.SelectsThroughAll obs pool t
          (fun l => (World.of R L W).withRest.web.Admits (l s) s x) :=
  Flow.act_selected_by_pool (L := (World.of R L W).withRest.flow)
    (L' := (World.of R L' W').withRest.flow) (W := (World.of R L W).withRest.web)
    (W' := (World.of R L' W').withRest.web) through follows follows' withRest_balanced
    withRest_balanced (withRest_present present) (withRest_start start) acts differs

/-- **What tells a widening move from a narrowed one is selected beyond the actor only through a
member coupling it**, for every two worlds of one kind of relatum with their rests counted, under
every law of exchange over the relata with the rest (`Direction.widening_selected_by_pool`). -/
theorem withRest_widening_selected_by_pool {law : ExchangeLaw (Option R) (Option R)}
    {obs : Option R → Option R → Prop} {part : Option R → Bool} {group : Option R → Prop}
    (through : law.Through (World.of R L W).withRest.web obs part)
    (follows : (World.of R L W).withRest.flow.Follows law part (World.of R L W).withRest.web.level)
    (follows' :
      (World.of R L' W').withRest.flow.Follows law part (World.of R L' W').withRest.web.level)
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : ∀ f, group f → (World.of R L W).withRest.flow.ActsAlikeWithin
      (World.of R L' W').withRest.flow (World.of R L W).withRest.web (World.of R L' W').withRest.web
      obs part f)
    (widens : (World.of R L W).withRest.web.Widens (World.of R L' W').withRest.web.level
      (World.of R L W).withRest.web.level) :
    ∃ s x, (World.of R L W).withRest.web.Admits ((World.of R L' W').withRest.web.level s) s x ∧
      ¬ (World.of R L W).withRest.web.Admits ((World.of R L W).withRest.web.level s) s x ∧
      ¬ WithinClosureOf ((World.of R L W).withRest.flow.CoupledFromEither
        (World.of R L W).withRest.web (World.of R L' W').withRest.flow obs) group x ∧
      (∀ pool : Option R → Prop, pool x → ∀ t, s ≤ t →
        (World.of R L W).withRest.web.SelectsThroughAll obs pool t
          (fun l => (World.of R L W).withRest.web.Admits (l s) s x)) ∧
      ∀ pool : Option R → Prop,
        (∀ g, pool g → WithinClosureOf ((World.of R L W).withRest.flow.CoupledFromEither
          (World.of R L W).withRest.web (World.of R L' W').withRest.flow obs) group g) →
        ∀ t, ¬ (World.of R L W).withRest.web.SelectsThroughAll obs pool t
          (fun l => (World.of R L W).withRest.web.Admits (l s) s x) :=
  Direction.widening_selected_by_pool (L := (World.of R L W).withRest.flow)
    (L' := (World.of R L' W').withRest.flow) (W := (World.of R L W).withRest.web)
    (W' := (World.of R L' W').withRest.web) through follows follows' withRest_balanced
    withRest_balanced (withRest_present present) (withRest_start start) acts widens

/-- **Apart only downstream**, for every two worlds of one kind of relatum with their rests
counted, under every law of exchange over the relata with the rest reading into each condition a
schedule of listed levels (`apart_only_downstream`). -/
theorem withRest_apart_only_downstream {law : ExchangeLaw (Option R) (Option R)}
    {part : Option R → Bool} {cs : List (Option R)}
    {reads : Nat → Option R → Option R → Nat → Option R → Bool} (r : law.ReadsInto part reads)
    (listed : ∀ t h e s d, reads t h e s d = true → d ∈ cs)
    (present : ∀ t, L.present t = L'.present t)
    (acts : (World.of R L W).withRest.flow.ActsAlike (World.of R L' W').withRest.flow part)
    (follows : (World.of R L W).withRest.flow.Follows law part (World.of R L W).withRest.web.level)
    (follows' :
      (World.of R L' W').withRest.flow.Follows law part (World.of R L' W').withRest.web.level)
    {c : Option R}
    (others : ∀ e, e ≠ c →
      (World.of R L W).withRest.web.level 0 e = (World.of R L' W').withRest.web.level 0 e) :
    ∀ t e, ¬ Upstream cs part (strengthsBefore t (readCouplings reads))
        (World.of R L W).withRest.flow.present c e →
      (World.of R L W).withRest.web.level t e = (World.of R L' W').withRest.web.level t e :=
  apart_only_downstream (L := (World.of R L W).withRest.flow) (L' := (World.of R L' W').withRest.flow)
    (W := (World.of R L W).withRest.web) (W' := (World.of R L' W').withRest.web) r listed
    withRest_balanced withRest_balanced (withRest_present present) acts follows follows' others

end World

/-! ## Over every world read off a relation of exchange -/

namespace World

variable (w : World)

/-- **The world is read off a relation of exchange**: its flow is a run, along its standings, of a
relation of exchange over its relata, and each relatum requires a relatum at a need only where its
exchange necessarily responds to that relatum falling below the need (`ExchangeRelation.RespondsBelow`).
Requirement is read as response; activity and drawing are read off the exchange once the rest is
counted (`World.withRest`). -/
def ReadOffExchange : Prop :=
  ∃ (rel : ExchangeRelation w.Relatum w.Relatum) (present : Nat → List w.Relatum),
    rel.Runs present w.web.level w.flow ∧
      ∀ t f c, w.web.requires t f c → rel.RespondsBelow present w.web.level t f c (w.web.need t f c)

variable {w}

/-- **Activity needs support in every world read off a relation of exchange**, with its rest
counted: a relatum that exchanges is supported, since its run's own exchange is open under the
actual standings. -/
theorem ReadOffExchange.dependent (read : w.ReadOffExchange) : w.withRest.Dependent :=
  match read with
  | ⟨_, _, runs, responds⟩ => withRest_dependent_iff.mpr fun t x ⟨mem, exchanged⟩ d required =>
      Nat.ge_of_not_lt fun below => responds t x d required w.web.level (fun _ _ _ => rfl) below
        (w.flow.take t) (w.flow.give t) (runs t).2
        ⟨Eq.subst (motive := fun p => x ∈ p) (runs t).1 mem, exchanged⟩

end World

/-- **Every run of every relation of exchange is a world read off it.** -/
theorem ExchangeRelation.Runs.readOffExchange {R : Type} {rel : ExchangeRelation R R}
    {present : Nat → List R} {L : Flow R R} {l : Nat → R → Nat} (runs : rel.Runs present l L)
    (need : Nat → R → R → Nat) : (rel.world present L l need).ReadOffExchange :=
  ⟨rel, present, runs, fun _ _ _ responds => responds⟩

/-- **The course of every law of exchange is a world read off it**: the law is the relation
leaving one exchange open, its course a run of that relation, and its response the relation's. -/
theorem ExchangeLaw.readWorld_readOffExchange {R : Type} {law : ExchangeLaw R R}
    {present : Nat → List R} {start : R → Nat} (need : Nat → R → R → Nat) :
    (law.readWorld present start need).ReadOffExchange :=
  ⟨law.relation, present, ExchangeLaw.course_runs start,
   fun _ _ _ responds => ExchangeLaw.relation_responds_iff.mpr responds⟩

/-- A world whose one relatum takes a unit from itself at every step while standing at nothing,
and requires itself at need one. -/
def World.takingUnsupported : World :=
  World.of Unit ExchangeRelation.takingOne
    ⟨fun _ _ => 0, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 1, fun _ _ _ => True⟩

/-- **Not every world is read off a relation of exchange.** In `World.takingUnsupported` the
relatum exchanges while what it requires stands below its need, so its requirement is no response
of its exchange under any relation of which its flow is a run. -/
theorem World.takingUnsupported_not_readOff : ¬ World.takingUnsupported.ReadOffExchange :=
  fun read => Nat.not_succ_le_zero 0
    (read.dependent 0 (some ()) (World.withRest_exchanging_iff.mpr ⟨.head _, (), .inl Nat.zero_lt_one⟩)
      (some ()) trivial)

namespace World

namespace ReadOffExchange

variable {w : World}

/-- **Consumption ends with its feeders**, in every world read off a relation of exchange, with its
rest counted (`Flow.Balances.consumption_ends_with_feeders`). -/
theorem consumption_ends_with_feeders (read : w.ReadOffExchange) {c g : w.withRest.Relatum}
    {T : Nat} (requires : ∀ t, T ≤ t → w.withRest.web.active t g → w.withRest.web.requires t g c)
    (unsupported : ∀ t f, T ≤ t → w.withRest.flow.FedBy w.withRest.web (g, t) (f, t) →
      ¬ w.withRest.web.Supported t f)
    (consumes : ∀ t, T ≤ t → w.withRest.web.active t g →
      g ∈ w.withRest.flow.present t ∧ 0 < w.withRest.flow.take t g c) :
    ∀ n, (∀ k, k < n → w.withRest.web.active (T + k) g) → n ≤ w.withRest.web.level T c :=
  Flow.Balances.consumption_ends_with_feeders (balances := withRest_balanced)
    (acting := withRest_acting) (dependent := read.dependent) requires unsupported consumes

/-- **Taking all from a condition excludes every other taker**, in every world read off a relation
of exchange, with its rest counted (`Flow.continuing_excludes`). -/
theorem continuing_excludes (read : w.ReadOffExchange) {c : w.withRest.Relatum} {m : Nat}
    (gated : ∀ t e, e ∈ w.withRest.flow.present t → 0 < w.withRest.flow.give t e c →
      w.withRest.web.requires t e c ∧ m ≤ w.withRest.web.need t e c)
    {f g : w.withRest.Relatum} (apart : f ≠ g) (all : ∀ t, w.withRest.flow.TakesAll t f c)
    (needs : ∀ t, w.withRest.web.requires t f c ∧ m ≤ w.withRest.web.need t f c)
    (continues : ∀ t, w.withRest.web.active t f) (T : Nat) :
    ¬ ∀ j, j < w.withRest.web.level T c + 1 →
      g ∈ w.withRest.flow.present (T + j) ∧ 0 < w.withRest.flow.take (T + j) g c :=
  Flow.continuing_excludes (balances := withRest_balanced) (acting := withRest_acting)
    (dependent := read.dependent) gated apart all needs continues T

/-- **A rest taking more than is given runs a condition below the need**, in every world read off a
relation of exchange, with its rest counted (`Flow.outrun_below`). -/
theorem outrun_below (read : w.ReadOffExchange) {c : w.withRest.Relatum} {m : Nat}
    (gated : ∀ t e, e ∈ w.withRest.flow.present t → 0 < w.withRest.flow.give t e c →
      w.withRest.web.requires t e c ∧ m ≤ w.withRest.web.need t e c)
    {T n : Nat} {rest : List w.withRest.Relatum} (distinct : Distinct rest)
    (present : ∀ j f, j < n → f ∈ rest → 0 < w.withRest.flow.take (T + j) f c →
      f ∈ w.withRest.flow.present (T + j))
    (outruns : ∀ j, j < n →
      w.withRest.flow.given (T + j) c < total rest fun f => w.withRest.flow.take (T + j) f c)
    (start : w.withRest.web.level T c < n + m) : ∀ k, w.withRest.web.level (T + n + k) c < m :=
  Flow.outrun_below (balances := withRest_balanced) (acting := withRest_acting)
    (dependent := read.dependent) gated distinct present outruns start

/-- **Dependence read on roles is dependence**: it holds on the roles of every world read off a
relation of exchange, with its rest counted (`Web.roles_dependent`). -/
theorem roles_dependent (read : w.ReadOffExchange) : w.withRest.web.roles.Dependent :=
  (Web.roles_dependent w.withRest.web).mpr read.dependent

/-- **Selection is within support**, in every world read off a relation of exchange, with its rest
counted (`Flow.selection_within`). -/
theorem selection_within (read : w.ReadOffExchange) {t : Nat} {c : w.withRest.Relatum}
    {ps : List w.withRest.Relatum} {kids : w.withRest.Relatum → List w.withRest.Relatum}
    (descend : ∀ p k, p ∈ ps → k ∈ kids p → w.withRest.flow.DescendsAt w.withRest.web t k p)
    (depends : ∀ p, p ∈ ps → w.withRest.web.requires t p c) (b : w.withRest.Relatum → Nat) :
    offspring ps kids b + lowered ps kids (fun p => w.withRest.web.need t p c) b ≤
      selected ps kids (fun _ => w.withRest.web.level t c) +
        raised ps kids (fun p => w.withRest.web.need t p c) b :=
  Flow.selection_within (acting := withRest_acting) (dependent := read.dependent) descend depends b

/-- **What is selected needs no more than stands**, in every world read off a relation of
exchange, with its rest counted (`Flow.selected_le`). -/
theorem selected_le (read : w.ReadOffExchange) {t : Nat} {c : w.withRest.Relatum}
    {ps : List w.withRest.Relatum} {kids : w.withRest.Relatum → List w.withRest.Relatum}
    (descend : ∀ p k, p ∈ ps → k ∈ kids p → w.withRest.flow.DescendsAt w.withRest.web t k p)
    (depends : ∀ p, p ∈ ps → w.withRest.web.requires t p c) :
    selected ps kids (fun p => w.withRest.web.need t p c) ≤
      selected ps kids (fun _ => w.withRest.web.level t c) :=
  Flow.selected_le (acting := withRest_acting) (dependent := read.dependent) descend depends

/-- **A transmitted dependence is supported within the bound**, in every world read off a relation
of exchange, with its rest counted (`Flow.transmitted_supported`); bounded transmission, a state of
the law, stays a hypothesis. -/
theorem transmitted_supported (read : w.ReadOffExchange) {c : w.withRest.Relatum} {δ : Nat}
    (transmits : w.withRest.flow.TransmitsWithin w.withRest.web c δ) {t : Nat}
    {x g : w.withRest.Relatum} (descends : w.withRest.flow.DescendsAt w.withRest.web t x g)
    (depends : w.withRest.web.requires (t + 1) x c) :
    w.withRest.web.need (t + 1) x c ≤ w.withRest.web.level t c + δ :=
  Flow.transmitted_supported (acting := withRest_acting) (dependent := read.dependent) transmits
    descends depends

/-- **Support is never selected against**, in every world read off a relation of exchange, with
its rest counted (`SelectionTerm.Flow.support_not_lower`). -/
theorem support_not_lower (read : w.ReadOffExchange)
    {G : SelectionTerm.Generations w.withRest.Relatum}
    (descended : SelectionTerm.Flow.Descended w.withRest.flow w.withRest.web G)
    (top : ∀ t p, p ∈ G.family t → w.withRest.web.Supported t p → ∀ q, q ∈ G.family t →
      G.amount t q ≤ G.amount t p)
    {T : Nat} (unlowered : ∀ t, t < T → G.loweredAt t = 0) :
    G.size T * G.sum 0 ≤ G.size 0 * G.sum T :=
  SelectionTerm.Flow.support_not_lower (acting := withRest_acting) (dependent := read.dependent)
    descended top unlowered

/-- **A moved mean of support rises, by a step of selection proper**, in every world read off a
relation of exchange, with its rest counted (`SelectionTerm.Flow.support_moved_rises`). -/
theorem support_moved_rises (read : w.ReadOffExchange)
    {G : SelectionTerm.Generations w.withRest.Relatum}
    (descended : SelectionTerm.Flow.Descended w.withRest.flow w.withRest.web G)
    (top : ∀ t p, p ∈ G.family t → w.withRest.web.Supported t p → ∀ q, q ∈ G.family t →
      G.amount t q ≤ G.amount t p)
    {T : Nat}
    (exact : ∀ t, t < T →
      SelectionTerm.Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (moved : G.size 0 * G.sum T ≠ G.size T * G.sum 0) :
    G.size T * G.sum 0 < G.size 0 * G.sum T ∧ ∃ t, t < T ∧ G.discordAt t < G.concordAt t :=
  SelectionTerm.Flow.support_moved_rises (acting := withRest_acting) (dependent := read.dependent)
    descended top exact moved

/-- **A family in joint excess leaves no descendant of a member depending on it**, in every world
read off a relation of exchange, with its rest counted (`GroupEnding.Flow.family_childless`). -/
theorem family_childless (read : w.ReadOffExchange) {ds : List w.withRest.Relatum} {m : Nat}
    (gated : ∀ t f, f ∈ w.withRest.flow.present t → ∀ d, d ∈ ds → 0 < w.withRest.flow.give t f d →
      ∃ e, e ∈ ds ∧ w.withRest.web.requires t f e ∧ m ≤ w.withRest.web.need t f e)
    {T n : Nat} (excess : ∀ k, k < n →
      w.withRest.flow.replenishment ds (T + k) < w.withRest.flow.uptake ds (T + k))
    (start : w.withRest.web.stock ds T < n + m) (k : Nat) {g e : w.withRest.Relatum}
    (inside : e ∈ ds) (depends : w.withRest.web.requires (T + n + k) g e)
    (high : m ≤ w.withRest.web.need (T + n + k) g e) (x : w.withRest.Relatum) :
    ¬ w.withRest.flow.DescendsAt w.withRest.web (T + n + k) x g :=
  GroupEnding.Flow.family_childless (balances := withRest_balanced) (acting := withRest_acting)
    (dependent := read.dependent) gated excess start k inside depends high x

/-- **Groups whose conditions are coupled end together**, in every world read off a relation of
exchange, with its rest counted (`GroupEnding.Flow.coupled_end_together`). -/
theorem coupled_end_together (read : w.ReadOffExchange) {ds : List w.withRest.Relatum} {m : Nat}
    (gated : ∀ t f, f ∈ w.withRest.flow.present t → ∀ d, d ∈ ds → 0 < w.withRest.flow.give t f d →
      ∃ e, e ∈ ds ∧ w.withRest.web.requires t f e ∧ m ≤ w.withRest.web.need t f e)
    {T n : Nat} (excess : ∀ k, k < n →
      w.withRest.flow.replenishment ds (T + k) < w.withRest.flow.uptake ds (T + k))
    (start : w.withRest.web.stock ds T < n + m) (k : Nat)
    {G : SelectionTerm.Generations w.withRest.Relatum}
    (descended : SelectionTerm.Flow.Descended w.withRest.flow w.withRest.web G)
    {gs : List (List w.withRest.Relatum)}
    (within : ∀ h p, h ∈ gs → p ∈ h → p ∈ G.family (T + n + k))
    (coupled : ∀ h p, h ∈ gs → p ∈ h →
      ∃ e, e ∈ ds ∧ w.withRest.web.requires (T + n + k) p e ∧
        m ≤ w.withRest.web.need (T + n + k) p e)
    (a : w.withRest.Relatum → Nat) :
    (∀ h, h ∈ gs → total h (G.offspringNumber (T + n + k)) = 0) ∧
      SelectionLevels.concordAmong gs (G.offspringNumber (T + n + k)) a = 0 ∧
      SelectionLevels.discordAmong gs (G.offspringNumber (T + n + k)) a = 0 :=
  GroupEnding.Flow.coupled_end_together (balances := withRest_balanced) (acting := withRest_acting)
    (dependent := read.dependent) gated excess start k descended within coupled a

/-- **A whole drawing beyond the renewal of what its parts depend on ends**, in every world read off
a relation of exchange, with its rest counted (`Web.Whole.family_excess_ends`). -/
theorem family_excess_ends (read : w.ReadOffExchange) {parts : w.withRest.Relatum → Prop}
    {x : w.withRest.Relatum} {alive : Nat → List w.withRest.Relatum}
    (whole : w.withRest.web.Whole parts x) (listed : w.withRest.web.Listed parts alive)
    (ends : ∀ p, parts p → w.withRest.web.Ends p) {ds : List w.withRest.Relatum} {m : Nat}
    (gated : ∀ t f, f ∈ w.withRest.flow.present t → ∀ d, d ∈ ds → 0 < w.withRest.flow.give t f d →
      ∃ e, e ∈ ds ∧ w.withRest.web.requires t f e ∧ m ≤ w.withRest.web.need t f e)
    (arising : ∀ t p, parts p → w.withRest.web.Arises t p →
      ∃ e, e ∈ ds ∧ w.withRest.web.requires (t + 1) p e ∧ m ≤ w.withRest.web.need (t + 1) p e)
    {T n : Nat} (excess : ∀ k, k < n →
      w.withRest.flow.replenishment ds (T + k) < w.withRest.flow.uptake ds (T + k))
    (start : w.withRest.web.stock ds T < n + m) :
    (∀ t, T + n ≤ t → ∀ p, parts p → ¬ w.withRest.web.Arises t p) ∧ w.withRest.web.Ends x :=
  Web.Whole.family_excess_ends whole listed ends (balances := withRest_balanced)
    (acting := withRest_acting) (dependent := read.dependent) gated arising excess start

end ReadOffExchange

end World

end Becoming
