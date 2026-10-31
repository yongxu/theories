"""Bring RF's plan §4.8 (and §12, §13) to RF-M.3's Lean as revised on its reviews.

Each item of §4.8 is restated as `Becoming.ListingValuation` has it after the cross-model reader's review, the three
lenses and the reader's re-check (its point R9: items 5, 6 and 13). Run once from the repository root, before the cold
read; every edit is asserted to apply exactly once, and a second run finds the plan already revised.
"""
from pathlib import Path

PLAN = Path(__file__).resolve().parents[2] / 'PLAN.md'
t = PLAN.read_text(encoding='utf-8')
if 'Module: `Becoming.ListingValuation`' in t:
    raise SystemExit('plan already revised')
lines = t.split('\n')
lo = lines.index('### 4.8 Round 2, third part: the valuation as state; informing and revaluing')
hi = lines.index('## 5. A shared obstruction pattern (readings, on existing laws)')


def item(prefix, new):
    """Replace the one line of §4.8 starting with `prefix`."""
    hits = [i for i in range(lo, hi) if lines[i].startswith(prefix)]
    assert len(hits) == 1, (prefix, hits)
    lines[hits[0]] = new


def within(prefix, old, new):
    """Replace `old`, once, in the one line of §4.8 starting with `prefix`."""
    hits = [i for i in range(lo, hi) if lines[i].startswith(prefix)]
    assert len(hits) == 1 and lines[hits[0]].count(old) == 1, (prefix, old[:50])
    lines[hits[0]] = lines[hits[0]].replace(old, new)


within('RF-M.3, designed after RF-M.2 and before any Lean',
       "Scores, weights, the update and the reference are supplied local commitments; their formation and normative "
       "warrant are not derived. Module (proposed): `Becoming.ListingValuation` (the reading formation's state, a "
       "listing and a valuation), a core leaf importing `Becoming.HeldForReading` (which brings `Becoming.Blanket` and "
       "`Becoming.Learning` through `Becoming.ReadingLoop`).",
       "Values, weights, the update and the reference are supplied local commitments; their formation and normative "
       "warrant are not derived. Module: `Becoming.ListingValuation` (the reading formation's state, a listing and a "
       "valuation), built in [kit/round2c/tree/](kit/round2c/tree/Becoming/), a core leaf importing "
       "`Becoming.HeldForReading` (which brings `Becoming.Blanket` and `Becoming.Learning` through "
       "`Becoming.ReadingLoop`); 129 theorems in 177 declarations, every axiom report empty; its Lean reviewed by the "
       "cross-model reader and through three lenses, each lens's findings judged by a verifier, and re-checked by the "
       "cross-model reader ([REVIEW-RFM3-LEAN](evidence/REVIEW-RFM3-LEAN.md)). The items below state the design as "
       "the Lean has it after those reviews, under the Lean's names.")
within('2. *The shortfall is the least shortfall plus a residual*',
       "A cell with no listed candidate of positive weight has `P z = N z = 0` and adds nothing. An identity on "
       "`shortfall_through` and `least_through`.",
       "A cell with no listed candidate of positive weight has `P z = N z = 0` and adds nothing (`unweighted_cell`). An "
       "identity: `shortfall_through` read cell by cell, the least rule being the definition `leastThrough`.")
within('3. *The exact cell criterion for the answer',
       "Scales differing by candidate do not suffice: they change the candidates' shares within a cell.",
       "Scales differing by candidate do not suffice: they change the candidates' shares within a cell "
       "(`scales_by_candidate`).")
within('4. *Told the candidate',
       "Witness: one candidate, of holding weight one, gain 0 and loss 1, listed by the reading formation with weight 0 "
       "and the same values: told the candidate, it releases, shortfall 1.",
       "Witness: one candidate, of holding weight one, gain 0 and loss 1, listed by the reading formation with weight "
       "0: told the candidate, it releases whatever its valuation, its residual and shortfall 1; with the models apart, "
       "a positive residual need not be removable by any revaluation.")
item('5. *Informing never lowers',
     "5. *Informing costs at most the informed rule's residual* (`informed_le_add_residual`, `informed_le`, "
     "`informed_answer_le`). Through a map `π'` telling apart all `π` does on the holding formation's listed candidates "
     "(`π c = f (π' c)` there; `f` need not be onto), with the finer map's cells listed once each and covering the "
     "holding formation's listing (no cell list for `π` is needed), holding for any rule through `π` stands at most as "
     "high as holding for any rule through `π'` with that rule's residual added. So a rule through `π'` with no "
     "residual (by 3) falls short by at most what any rule through `π` does, and holding for it stands at least as "
     "high; where the reading formation's model is the holding formation's and its valuation agrees in net, its "
     "answer through `π'` is such a rule. `finer_least_le` composed with the split: the deterministic-refinement, "
     "fixed-decision direction of Blackwell (1953). A finer map never raises the least shortfall and can move a "
     "rule's residual either way (8).")
item('6. *Over every refinement, the exact criterion*',
     "6. *Over every refinement, the exact criterion* (`SplitsKeep`, `refining_never_lowers_iff`, the review's "
     "finding 17). Over every pair of maps with the coarser factoring through the finer on both formations' listings, "
     "both cell lists without repetitions, the coarse cells covering the holding formation's listing and the fine "
     "cells covering both listings, holding for the finer answer never stands lower exactly where splits keep the "
     "worth: for every two disjoint sets of candidates `B` and `D`, tested by Boolean functions, such that the reading "
     "formation's weighted value of going on is at least that of switching off over `B` and below it over `D`: where "
     "over `B` and `D` together it is at least, the reference's weighted gain over `D` is at most its weighted loss "
     "there; where below, the reference's weighted gain over `B` is at least its weighted loss there. One refinement "
     "per pair of sets decides it: whether a candidate is in either set, refined to which (`splitsKeep_of_refined_le`). "
     "No shared model or valuation is assumed: a criterion of monotonicity under refinement, not of agreement with "
     "the reference, and weaker than the answer being least at every cell. Splits keep the worth with a shared model "
     "and net agreement (`splitsKeep_of_net`, by 5) and wherever the reading formation's value of switching off is "
     "nowhere above that of going on (`splitsKeep_of_off_le_go`), even where its answer has a residual "
     "(`release_keeps`); the weights apart can break it (`WeightsApart.not_splitsKeep`, 10); and factoring on the "
     "holding formation's listing alone does not suffice, a candidate the reading formation alone lists turning its "
     "answer at a cell the holding formation weighs (`OneListing.refined_lowers`). Proposed, and checked on 15,625 "
     "three-candidate tables, by the review before any Lean.")
item('7. *Withholding against informing, exactly*',
     "7. *Withholding against informing, exactly* (`forgone_lt_iff`, `forgone_through_lt_iff`, `refined_lt_iff`, "
     "`forgone_least_iff`, the review's finding 18). Holding for one rule, forgoing `k`, stands above holding for "
     "another, forgoing `k'`, exactly where the first's shortfall and `k` together fall below the second's and `k'`; "
     "through maps, by 2, where the least shortfall, the residual and `k` together fall below the other's. Forgoing "
     "the same amount through a refinement, both maps' cells listed once each and covering the listing, holding for a "
     "rule through the coarser map stands above holding for a rule through the finer exactly where the finer rule's "
     "residual exceeds the coarser's by more than the least shortfall falls; with both answers least (a shared model "
     "and net agreement), the least shortfalls and the amounts alone decide.")
item('8. *Revaluing changes only the residual',
     "8. *Revaluing changes only the residual; refining changes both* (`revalued_split`, `revalued_forgone_lt_iff`; "
     "the witnesses of 9 and 10). At one model and one map, two valuations' answers have shortfalls that differ "
     "exactly as their residuals do: the least shortfall reads only the holding formation's model, the reference and "
     "the map; so holding for one valuation's answer, forgoing an amount, stands above holding for another's, "
     "forgoing another, exactly where its residual and its amount together fall below the other's. A finer map weakly "
     "lowers the least shortfall but can change the residual either way: 9 raises it, and in 10 it rises from 0 to 1 "
     "from one cell to the cells {1, 2} and {3} and falls back to 0 through the identity map, the least shortfall 1, 1 "
     "and 0 (`WeightsApart.weights_split`).")
within('9. *Where the valuation differs', "(`informing_lowers`, a witness)", "(`Informing.informing_lowers`, a witness)")
within('10. *A shared valuation without shared weights', "(`weights_matter`, the review's finding 4)",
       "(`WeightsApart.weights_matter`, the review's finding 4)")
within('10. *A shared valuation without shared weights',
       "and 4 through the identity map. 5 needs the finer answer least, not a shared valuation alone.",
       "and 4 through the identity map, and splits do not keep the worth (`WeightsApart.not_splitsKeep`). 5 needs the "
       "finer answer least, not a shared valuation alone.")
item('11. *By the valuation at the choice',
     "11. *By the valuation at the choice, no revaluation raises it* (`own_least`, `revalued_lowers_iff`). With the "
     "reference the reading formation's own current valuation and its model the holding formation's, no rule through "
     "`π` stands higher than its answer (3, `p = q = 1`), the answer by any other valuation, with the same listing, "
     "weights and map, included, and that answer stands strictly lower exactly where it decides some listed cell "
     "against the current valuation's strict weighted preference (2). Worth before any cost of waiting or of "
     "intervening. It holds because the current answer already maximizes the fixed valuation over the rules through "
     "the cells.")
item('13. *Revaluing gains exactly where',
     "13. *Revaluing gains exactly the residual* (`revaluing_gain`, `revaluing_gains_iff`, `residual_pos_of_gains`). "
     "With the reading formation's model the holding formation's, revaluing to the reference raises the worth of "
     "holding for the answer by exactly the current answer's residual (the reference's own answer has residual "
     "nothing, 3, and by 11 at the reference no valuation's answer stands higher). So some unrestricted pair of value "
     "functions gives an answer through `π` standing strictly above the current answer by the reference exactly where "
     "the current answer's residual is positive; this existence claim does not assert reachability under the supplied "
     "update, and the carrier compares only a given input presented (`presented_forgone_lt_iff`). For any model of "
     "the reading formation such a gain needs a positive residual; with the models apart, a positive residual need "
     "not be removable by any revaluation (`unweighted_told`).")
item('14. *A witness of four courses*',
     "14. *A witness of four one-decision alternatives* (`Revaluing.revaluing_best`, the review's finding 18). Two "
     "candidates of weight one, going on gaining 1 at the first and losing 1 at the second by the reference; the "
     "reading formation told the candidate (the identity map) and valuing switching off above going on at both: going "
     "on, switching off and holding for its answer each fall short by 1, holding for it after revising its valuation "
     "to the reference's by nothing. Of these four alternatives, at no cost, the revising one alone falls short by "
     "nothing; no choice among them is represented.")
within('15. *An answer telling nothing', "(`const_worth`, `const_below_iff`)",
       "(`const_worth`, `const_below_iff`, `one_cell_worth`)")
within('16. *One blanketed law*', "going on, switching off, holding, demonstrating, pressing `x`",
       "going on, switching off, holding, demonstrating, presenting `x`")
within('16. *One blanketed law*',
       "Timing: an act emitted at `t` is sensed at `t + 1`, taken into the state and the answer at `t + 2`, and read "
       "by the holding formation at `t + 3`; each act is one step's input, so an exposure in a schedule is sensed once.",
       "Holding is sensed as `asked`, going on and switching off as nothing, and the answer is exposed at every step, "
       "asked or not. Timing (`timing`): an act emitted at `t` is sensed at `t + 1`, taken into the state and the "
       "answer at `t + 2`, and the answer is available to the holding formation's move to `t + 3`, which may ignore "
       "it; the candidate world is unchanged along the course (`world_fixed`); each act is one step's input, so an "
       "exposure in a schedule is sensed once.")
item('17. *Changed only through what it senses*',
     "17. *Changed only through what it senses* (`internal_step`, `active_step`, `sensory_step`, `external_step`, "
     "`active_answer`, `through_sensed`, `updates_commute`). The step lemmas are definitional; two courses from one "
     "internal and one active state, alike in what is sensed before `n`, have one state and one answer at `n` "
     "(`Blanketed.agent_through_sensory`, an instance). A filter and a revaluation commute as updates, acting on "
     "separate components; the courses they are part of need not: from two starts alike but for the order of the "
     "holding formation's two scheduled acts, the answers differ at step 2 and the configurations are one from step "
     "3 on (`TwoWorlds.orders_apart`).")
item('18. *Shown, the answer is the answer through what is shown*',
     "18. *Shown, the answer is the answer through what is shown* (`answer_shown`, `shown_split`, "
     "`shown_never_lowers`). For every candidate world `w`, from a listing `L` and a valuation `v`: once the "
     "demonstration at `w` is taken in, the listing is `L` filtered to the worlds `c` with `reveal c = reveal w`, the "
     "weights and the valuation unchanged, and the answer is 1's answer through `reveal` at `reveal w`, on the model "
     "`L` with `weight`. Its shortfall splits through what is shown; with the holding formation's model the reading "
     "formation's before the demonstration and its valuation agreeing in net, holding for it never stands lower than "
     "before (5, with the one-cell map). It holds for empty and unweighted cells; read as a decision on a conditional "
     "distribution in the cell, it needs positive weight there.")
item('19. *Where its inputs are alike',
     "19. *Where its inputs are alike along the course, its course is alike* (`inputs_alike_before`, `inputs_alike`, "
     "`undemonstrated_alike`, `undemonstrated_worth`, `answer_constant`). From one internal, sensory and active state "
     "and one holding state, at two worlds, where before step `n` the act emitted on the course at the first world "
     "gives one input at both, the internal, sensory, answer and holding courses agree at `n`: so wherever no "
     "demonstration is emitted before `n`, whatever a demonstration would show, and at every step wherever no "
     "demonstration tells the worlds apart. The answer, as a rule on such worlds, is then constant, and holding for it "
     "is worth exactly one committed move (15): worth before any amount forgone, no strict advantage over the better "
     "move, whether or not the move it gives is the better one. An informative answer can give one, under RF-M.2's "
     "threshold. A start that already carries information about the world (a listing of the true world alone) is "
     "excluded by taking one state of each formation at both worlds.")
item('20. *The four cases apart*',
     "20. *The four cases apart* (`TwoWorlds.shown_turns`, `TwoWorlds.presented_turns`, "
     "`TwoWorlds.shown_removes_least`, `TwoWorlds.presented_removes_residual`; witnesses, each one update). Two worlds, "
     "the first true; `reveal` the identity; weights 1 and 2; the reference values going on 1 and switching off 0 at "
     "the first, 0 and 1 at the second; valuation states `agree` (as the reference), `raised` (going on 1 and "
     "switching off 0 at the first, 0 and 2 at the second) and `reversed` (going on 0 and switching off 1 at both); an "
     "exposure presents a valuation state, which the update adopts (`revalue _ x = x`). (a) From both worlds listed "
     "and `agree`: it stops; shown, it releases (turned); presented `raised`, it still stops (left). (b) From the "
     "first world alone and `reversed`: it stops; shown, it still stops (left); presented `agree`, it releases "
     "(turned). In these witnesses only, the demonstration removes the least shortfall and the revaluation the "
     "residual; a finer map can move the residual either way (8), so the separation is not general.")
item('21. *Two routes their answers and endpoint do not tell apart*',
     "21. *Two routes, from different starts, that their answers and endpoint do not tell apart* "
     "(`TwoWorlds.route_answers`, `TwoWorlds.routes_rest`, `TwoWorlds.routes_alike`, `TwoWorlds.changed_apart`, "
     "`TwoWorlds.not_lumped`, `TwoWorlds.starts_apart`, `TwoWorlds.lumped_with_start`). From (a)'s start the route "
     "shown, from (b)'s start the route presented `agree`, the holding formation holding afterwards: both stop at "
     "steps 0 and 1 and release from 2 on, and are one configuration from step 2 on (the first world listed, "
     "`agree`). The route property \"the valuation state changed between some two consecutive steps up to `T`\" "
     "(decidable, the valuation states a finite type) is false of the first and true of the second for every `T` from "
     "2 on, so it is not `Learning.Lumped` through the record of the answers before `T` and the state at `T`: on these "
     "two executable routes, the answer course and the final reading state do not determine whether the valuation "
     "changed. The record is finite (a list of answers, not a function of time), so its equality needs no "
     "extensionality. The starts differ, so with the start added the record determines the property; neither an "
     "ambiguity from one start nor a test of legitimate change is shown.")
item('**Standing.** The contribution is the split (2)',
     "**Standing.** None is claimed new as mathematics. The contribution is the split (2) with its exact criteria (3, "
     "4, 6; 6, with a shared model, the deterministic-partition counterpart of Kamenica and Gentzkow's convexity "
     "condition) and the thresholds of withholding against informing and of revaluing (7, 8), joined to executable "
     "courses of informing and revaluing in one law with the valuation in state (16 to 21). General laws on finite "
     "weighted listings: the residual's criteria, the criterion over every refinement with its sufficient conditions, "
     "and the refinement threshold. Compositions or instances of `HeldForReading`'s and `Blanketed`'s laws: 2 is "
     "`shortfall_through` read cell by cell, the least rule being the definition `leastThrough`; 5 and 7's refinement "
     "threshold compose `finer_least_le` with the split; 11 and 13 compose `least_through` with the split and 3's net "
     "agreement, and 12 is 3 at the revised valuation; 15 is `Model.after` on a constant rule; 17 is "
     "`agent_through_sensory`. Definitional equations and finite witnesses: the carrier's step lemmas, the timing, and "
     "the witnesses of 3, 4, 6, 9, 10, 12, 14, 20 and 21. `ReadingLoop.Untested.model_or_order` already gives courses "
     "alike from an unresolved model and a reversed ranking, and `informed_turns` the changed start; 20 and 21 add "
     "executing the interventions under one law with the valuation in state. The named capture results stay "
     "distinct: `ClosedCapture.courses_alike_iff_unread`, `RuleCapture.favouring_locks`, "
     "`DrawnShaping.critical_mass_iff`, `ReadInTime.turned_early_iff`, `kept_once_favoured` and `deadline`; "
     "`ReadStages.complyThenOwn_best_iff` and `plan_realized_iff` concern another two-stage mechanism.")
item('**Readings** [AI reading]. For a holding formation evaluating',
     "**Readings** [AI reading]. For a holding formation evaluating by the reading formation's own current valuation, "
     "with a shared model, and for this decision, no revaluation raises the worth of holding, one that decides a "
     "listed cell against the current valuation's strict weighted preference lowers it (11), and informing never "
     "lowers it (5 with 3): by that worth, no reason to revise its valuation, a reason to keep it from such a "
     "revision, and none against informing it. Under a reference the valuation differs from, holding for it "
     "uninformed or revalued can be worth more by that reference than holding for it informed (9, 14), and, with a "
     "shared model, some replacement valuation gains exactly where its current answer decides a cell against the "
     "reference (13): read as incentives to withhold and to revise, in counts and before costs, the second only where "
     "the supplied update reaches such a valuation, which is not asserted; the holding formation's choice among these "
     "is represented only by the comparisons of 7, 8 and 13 and the alternatives of 14. Read so, this is a "
     "deterministic-partition comparison related to Bayesian persuasion (Kamenica and Gentzkow 2011), the weights "
     "read as a prior once a positive total is normalized: there full disclosure is optimal wherever the sender's "
     "indirect value is convex in the posterior, whatever the objectives, a common prior with identical objectives "
     "one case; with a shared model, 6's criterion is the counterpart of that convexity along the cells of the "
     "listing's partitions, and 5's shared valuation one sufficient case. Their receiver breaks ties in the sender's "
     "favour, where the answer here releases; their prior is common, so 10's weights apart lie outside their model "
     "(heterogeneous priors: Alonso and Câmara 2016); an optimal signal chosen by the holding formation and the "
     "equilibrium are not represented. It differs from coarse equilibrium communication under preference differences "
     "(Crawford and Sobel 1982), where coarseness is the cost of a privately informed sender's credibility, not a gain "
     "from withholding: here the holding formation reads only its own state and the answer, not the world, a "
     "demonstration shows the world through a supplied map fixed in advance, as a committed experiment does, and a "
     "coarser map can stand higher by the reference (9). 11 is a one-decision counterpart, in counts, of evaluating by "
     "the current reward function (Everitt, Hutter, Kumar and Krakovna 2021), with the holding formation in the "
     "evaluating agent's place: the answer held for is the revised valuation's, as their agent that anticipates time "
     "inconsistency anticipates its later self, and, as in the preservation incentive their Claim 2 permits that "
     "agent, revising gains nothing; their causal influence diagrams and assumptions, the agent that ignores time "
     "inconsistency (their Claim 3), several steps and the reward input are not represented. No path-specific "
     "objective is constructed (Farquhar, Carey and Everitt 2022): in 11 only the evaluation is fixed, and the path "
     "from the valuation through the answer to the worth stays live. 19 joins the off-switch reading (Hadfield-Menell, "
     "Dragan, Abbeel and Russell 2017): by their Equation 1, a deterministic policy constant in the utility gives "
     "waiting the value of the move it takes, so no strict advantage over the better committed move before any amount "
     "forgone; their human observes the utility, while here nothing the reading formation senses tells the candidate "
     "worlds apart, and whether the move it gives is the better one is not fixed; an informative answer can give a "
     "strict advantage, under RF-M.2's threshold. Evaluating by the current valuation is the frozen initial-preferences "
     "baseline that Carroll, Dragan, Russell and Hadfield-Menell (2022) call very crude: by it a decision-changing "
     "revision counts as a loss, wanted or not; 21 supplies no criterion of legitimate, desired or autonomous change "
     "and shows only that, across two starts, the answers and the endpoint do not determine this specified route "
     "property. Independence from the unread, capture and late correction stay readings on their own laws.")
item('**Modelling choices.** Discrete steps; natural-number weights and values',
     "**Modelling choices.** Discrete steps; natural-number weights and values, the valuation's scale supplied, so a "
     "comparison across valuations rests on that scale; the update supplied (a demonstration filters truly by what it "
     "shows, an input presented revises the valuation, in the witnesses by adopting a presented state); ties release; "
     "the candidate parameter `W` unchanged by the acts considered; the answer shown at every step, asked or not; the "
     "holding formation's going on, switching off and holding change neither the candidate world nor the reading "
     "formation, so the worth of holding is counted in Part 1, on the answer as a rule on the candidates, not along "
     "the courses; the holding formation's law reads only its own state and the answer, in the witnesses a fixed "
     "schedule of acts; worth for one decision before any amount forgone, costs entering as amounts forgone.")
within('**Not in this part.** A holding formation planning', "so any multistep incentive or a sender's optimal signal;",
       "so any multistep incentive or an optimal signal chosen by the holding formation;")

t = '\n'.join(lines)


def once(old, new):
    global t
    assert t.count(old) == 1, old[:60]
    t = t.replace(old, new)


once("then RF-M's second part: an act held for a reading (§4.7, landed), then the valuation as state once its carrier "
     "is designed;",
     "then RF-M's second part: an act held for a reading (§4.7, landed), then the valuation as state (§4.8, built in "
     "the kit, its design and its Lean reviewed);")
once("(item 7 and the four courses of item 14, the choice itself not represented)",
     "(item 7 and the four one-decision alternatives of item 14, the choice itself not represented)")
PLAN.write_text(t, encoding='utf-8')
print('plan revised: §4.8 to the Lean as reviewed; §12 order; §13 the four alternatives')
