*AI-written (Fable), by one reader, 18 November 2026. Read whole: `FROZEN-HOME.md`; `theories/becoming/chapters/02-MAP.md`, lines 1 to 549; `_process/DIRECTION.md`, lines 1 to 98 (marks given only for "Where we are heading", "The idea" and "What we have found so far"). Read in part, at statements only, no proofs: `Becoming/Dependence.lean` 140–172 and 215–226; `Horizon.lean` 100–116 and 140–152; `RegimeMargin.lean` 255–268, 736–746, 786–812; `MapInstances.lean` 58–72, 90–100, 376–395, 528–540; line 18 of the record `margin-of-a-regime.md`. Not read at all: chapters 1 and 3 to 8, the one page, the glossary, every other record, the plan, the dig's records. Nothing was built or run.*

# Chapter 2 (the map of formations) set against the direction page

How to read this. "The chapter says" is the chapter's sentence, AI-written, not checked against the Lean unless a line says "Lean opened". Line numbers are lines of `02-MAP.md`; anchors are its `<a id>`s. Bases are the chapter's own labels: root, any type, any process, World, the regime, counts, witness, periphery.

## 1. What each section states (an index)

**Head (lines 5–14).** Thesis (`#the-map`): at a fine and a coarse class together the grammar defines where a pattern generates, keeps or degenerates; §§2–9 are exact theorems on models; three theses T1, T2, T7 carry §5 and §9 beyond the models as conjectures. "Within the whole map" (line 9): "This chapter's map is the map of formations within the whole map ... where the other chapters speak of *the map*, they mean this one." Bases (`#how-to-read`, line 14): the World premises used (balance, only active giving, activity needing support, dissipation, embodiment, a census), the first law and enclosure as extra hypotheses; "The map orders nothing."

**§1 The map on branches** (`#branches`, lines 17–61).
- Definition (21): 传 carrying renewal (the pattern continues under coarse `L` and a fine line begins under `E`); 延 goes on along some branch; 尽 ends on every branch; generation 生成 (goes on along a branch with a carrying renewal always ahead); keeping 守 (goes on with none); degeneration 退化 = 尽; strong forms 全生成, 全守, 有终.
- `#r-generation-and-degeneration-at-two-grains` (root; every carrier, relation, pair of classes; `Becoming.GrammarMap`): going on and ending on every branch exclude each other (`«延尽不并»`); generation and keeping each exclude degeneration (`«生成退化不并»`, `«守退化不并»`); generation and keeping can share a point on different branches (`Map.«生守相杂»`) and exclude each other on a single line (`«单行则生守不并»`); the three strong forms exclude each other and, with excluded middle as a hypothesis, cover (`«全三域之周»`); witnesses inhabit each; "renewal does not decide the region" (`Map.Short.renews_and_ends`); for any sequence of classes, generation at order `k` keeps order `k+1` from ending on every branch (`«阶生成则上不退化»`).
- Second theorem (root; witness; `Becoming.MapRegions`, line 40): keeping from some point on 后守 closes the gap; with excluded middle every point is 生成, 后守 or 退化, on a single line exactly one (`«三域之周»`); `Map.Once` is none of 生成, 守, 退化 at its start.
- Calibration (49): placing every point is exactly excluded middle; deciding 后守 on a single line gives LPO, 生成 WLPO.
- World instance (51; `Becoming.MapInstances`): a carrying renewal is a continuation's step into an active occurrence whose formation did not carry on as itself (`Web.carries_iff`); 全生成 has carriers arising at arbitrarily late steps (`Web.generation_arises_late`); read by names nothing is 全生成 (`Web.itself_not_generation`). "The some-branch regions are not read on the World."
- World (53): a line with nothing active at a step `N` is not 不穷; "renewal of relations implies none of the strong forms" (`Map.renewal_undecided`).
- `#map-on-the-world` (56): where later theorems meet the map, a line is not 不穷 where it later holds a dependence on a condition kept below that need (`Web.consumed_held_not_endless`; premise: activity needs support), under family excess (`Web.family_excess_not_endless`), or where passing has stopped. "§§4–9 are not read as regions."
- `#r-degeneration-from-a-horizon` (World; 59): a line with nothing active at `N` degenerates (`Web.every_branch_ends_of_gone`), so each of the three regimes degenerates (`Web.consumed_held_degenerates`, …); that it reaches an end is exactly excluded middle.
- Reading D65 (61): 生成 "is not 生生 and never overlaps degeneration"; widening (07) is not this generation; "what parts the two is exactly loss".

**§2 Return and attraction** (`#return`, 64–103). `#r-attraction-is-not-returning` (any type; any determined law): drawn into an absorbing region exactly where it does not return (`Law.drawn_iff_not_returns`); near-definitional. Merging (any type/process): a run in an invariant region stays locked in (`Run.locked_in`). `#r-basins-of-a-determined-law`. `#r-returning-where-the-course-branches` (any process; `Branching.returns_iff_keepsWithin`). `#r-necessarily-drawn-is-not-returning`. Definition 机, juncture. `#r-every-loss-passes-a-juncture` (any process; `s` returns): every course to where `s` cannot be had passes, up to double negation, a juncture (`Branching.loss_passes_juncture`); finding it gives LPO. `#r-a-source-before-a-juncture` (World with a process; both courses balanced, same formations, common start, responding through couplings): to turn a reader at a juncture a source must have reached it before (`TimedResponse.turned_at_juncture`). `#r-reaching-before-and-after-a-juncture`: a choice matters only at a juncture (`Branching.keeps_before_juncture`). Three earlier frame cases (table, 97–101).

**§3 Renewal and consumption** (`#renewal`, 106–190).
- 3.1 (`#runs`). Definition (113): renews in a run (`RenewingIn`); condition consumed (`Consumed`), lost (`Lost`); consumes in a run (`ConsumingIn`); "It does not say the drawing made the deficit."
- `#r-relational-renewal-classification` (World, 116): the classes exclude each other and do not exhaust (seasonal is neither); in every balanced flow a level below `m` stays below where whatever gives depends on the condition at need ≥ `m` and is supported where it gives (`Flow.stays_below_at`, `Flow.stays_below`), and every dependent at such a need is inactive from then on (`Flow.ends_below`; activity needs support); support-gated family: drawing beyond renewal ends renewal for good; two drawers each within renewal jointly consume (`RelationalRenewal.Law.jointly_consuming`); "forming new organization at every step, or the drawer's own course, leaves the class undecided."
- `#r-becoming-renewal-reading` (any process; the renewable process, witness; 119): every run read through observables is a web; `Renewable.class_belongs_to_the_run`.
- `#r-becoming-dependence-dynamics` (World, 122): each step keeps, breaks, forms or dissolves a dependence; with activity needing support, three outcomes of a loss constrained, not exhaustive: restored, transformed, ended (`Web.consumed_ends_when_fixed`).
- `#r-becoming-return-grades` (World, 125): return grades renewal (within `p`, at some later step, never); `Web.consumed_iff` (restates the definition), `Web.Restored.not_consumed`; `Slowing`.
- `#r-becoming-finite-horizon` (the renewable process; support-gated law with feedback; 128): `Renewable.finite_reading_includes_consumption`; model statement (130): `Becoming.ModelStatements.finite_reading_not_exact`, `renewing_not_closed`.
- `#r-substitution-preserves-consumption` (World, 133): `Web.consumingIn_kept_iff`; `persists_consuming` (premises: draws beyond renewal from the start, both needs positive, focal need within the sustaining one and met at the start).
- `#r-supported-renewal-recovery` (World; balanced flow; 136): `Flow.restores`; "Recovery does not guarantee maintenance."
- `#r-renewing-consuming-formation` (periphery; three classical axioms; a supplied wear law with no recovery; 139).
- `#r-represented-boundary-against-dependence` (World, 142): renewal over a region; `Web.RenewingOver.keeps_own`, `Clearing`, `Omitted.loses_own`; model statement 144.
- 3.2 (`#generation-needs-renewal`). Arising defined (151): "Arising is activity starting, not §1's generation." `#r-unceasing-generation-needs-renewal` (World; supplied: each arising goes with a fall in a finite family; `Web.Unceasing.activeRenewer_recurs`). `#r-more-needs-renewers` (balance; census). `#r-no-finite-part-bears-taking` (balance, dissipation; `Flow.Dissipative.opens`; "Maintenance is such taking"). `#r-continuing-self-fed-from-beyond` (`Flow.fed_from_beyond`; whole units needed; `Halving.never_rests`). `#r-far-conveying-runs-the-family-down`. `#r-arising-needs-change` (`Web.not_arises_of_unchanged`). `#r-support-passed-on` (balance, only active giving, activity needing support; `Flow.support_passes_on`).
- 3.3 (`#wholes`). `#r-whole-persists-through-generation` (World): with brief parts no `d` steps pass without one arising (`Whole.arises_within`); `Immortal`, `Countless` let a whole persist with nothing arising. `#r-a-whole-carried-by-lasting-parts`. `#r-a-whole-of-every-part` (`Web.AllWhole.ends_of_part`, `Web.Grade`).

**§4 Rest** (`#rest`, 193–241). `#r-least-loss-rest` (any amounts; `Amounts.rests`). `#r-rest-from-a-finite-reading`. `#r-merge-of-a-part-kept-by-the-rest` (a law that merges nothing; `Reset.kept_by_rest`). `#r-continued-change-needs-openness`, the rest theorem (World; censuses, embodiment, balance, dissipation, enclosure from some step; `World.comes_to_rest_unrefuted`, `World.arising_opens`; openness does not give arising: `World.holding_world`). `#r-rest-theorem-in-any-amounts`. `#r-rest-exactly-where-falls-stop`. `#r-rest-by-balance`. `#r-least-loss-from-entropy-production` (periphery). `#r-entropy-history-and-record` (`Flow.dissipatesOn_iff_conserved`, `World.forgets`). Four rows (238–241): revisiting and forgetting, where novelty's gain comes from, rest at every resolution, refinement counted.

**§5 Draw and margin** (`#margin`, 244–291). Definition (248): draw, giving, withheld levels, the margin of a part (`Flow.Balances.supported_iff_within_margin`), a regime (`RegimeMargin.step`). `#r-a-need-with-a-cap`. `#r-margin-of-a-regime` (the regime; whole numbers; giving short of the draw below `y`, nothing from nothing, meeting it from `y` up to a kept top `hi`, `0 < H + y`): a level ends exactly where it starts below `H + y` (`RegimeMargin.ends_iff_below`); `root_above_need`, `beyond_draw_iff`, `lowered_raises`. Second theorem (258): two draws' rises superadditive up to one (`rises_superadditive`); time to break in a band (`not_before`, `falls_within`). `#r-exit-from-a-margin` (weighted two-valued courses). `#r-threshold-in-the-state-plane` (`RegimeMargin.leading_exact`; `Adjusted.falls_iff_below`). Table of cases (272–279): adjusting giving, where a run rests, any amounts, coupled regimes, coupled webs (`Coupled.Indexed.ends_downstream`), rest on webs (`Coupled.Indexed.threshold_falls`), beyond a band, recent giving on webs. `#r-where-a-run-turns` (`RunTurns.turns_where_order_breaks`; on a regime a turn is overcompensation). `#r-the-draws-before` (`DrawHistory.history_decides`). Thesis T1 (`#t1`) and T2 (`#t2`), each with what it forbids, what refutes it, and failed and passed frozen tests.

**§6 Closures** (`#closures`, 294–310). `#r-feeding-closure` (World; no premise; `Flow.fedClosed_within`). `#r-consumption-ends-with-feeders` (balance, only active giving, activity needing support): a formation taking at every active step from `T` while nothing supported gives is active at most as many consecutive steps as the level at `T` (`Flow.Balances.unfed_consumption_ends`). `#r-growth-constrained-fragmentation` (periphery). `#r-where-a-rising-take-ends` (`Flow.seeking_ends`, `Flow.seeking_exhausts`).

**§7 Carried differences and loops** (`#loops`, 313–369). `#r-counterfactual-is-the-course`. `#r-where-two-courses-rejoin` (`Flow.stays_beyond_response`). Definitions (323): gap, strength, carried amount, *loop* ("a chain of couplings back to its start"), standard bounds. `#r-differences-below-threshold` (`Flow.subthreshold_alike`). `#r-how-much-difference-arrives`. `#r-two-act-worlds-carry-the-difference`. `#r-how-a-carried-difference-grows` (polynomial exactly where no loop lies upstream). `#r-what-a-cut-loses`. `#r-orders-as-a-sum-over-histories`. `#r-sums-over-histories-by-support-horizon-and-order`. `#r-how-loops-form`. `#r-loops-within-what-a-law-reads` (`not_onLoop_unread`; for a law reading a stock only below a threshold "the distance to the break is carried nowhere", `break_carried_nowhere`). `#r-whether-a-loop-closes-a-difference`. `#r-how-often-couplings-act`. `#r-a-coupling-saturated-by-what-it-has-carried`. `#r-repeated-disturbance`. `#r-runaway-distance-uncoupled` (`Web.break_not_bounded`: "how far off the break is does not couple in").

**§8 Regulation and reserves** (`#regulation`, 372–393). `#r-two-sided-regulation-and-late-reading` (World; balance at the condition; `Flow.withinGap_iff_between`; a rule reading `ℓ` steps late keeps no band narrower than `2(ℓ+1)d`, `Regulation.no_narrower_band`, `relay_threshold`). `#r-regulation-from-one-side-and-locally` (`Flow.never_returns_below`, "gated renewal being the case"). `#r-how-fast-a-rule-may-change` (`Pace.rule_until_reading`, `Pace.pace_law`). `#r-reserve-defers-ending`. `#r-dormancy-over-a-stretch`.

**§9 Capture** (`#capture`, 396–465).
- `#r-target-capture` (any type; `share_rises`).
- `#r-capture-through-the-rule` (any type; two-level course; `Raises`, `ReadsShare`, the start's rule and every rule read favouring): locked from the step after the first reading step (`RuleCapture.favouring_locks`); a reversing perturbation is not absorbed (`RuleCapture.Reversed.not_absorbed`). "That actual rules read the share is the premise."
- `#r-two-rules-lock-together`; `#r-a-reading-against-the-share-does-not-ratchet`.
- Definition 元吸引子 (412).
- `#r-closed-capture` (any type; `Unread`; each step adds at least one beyond; rule read monotonically; favouring kept upward): `ClosedCapture.courses_alike_iff_unread`, `lock_outlives_loss`; a sufficient way out, `turned_by_loss`.
- `#r-readers-drawn-from-the-selected` (`Drawn.pool_reads_iff`; `Thinned.kept_iff`, `Thinned.turned_iff`; witness `Thinned.inTime_turned`, `Thinned.late_kept`). "The premise is moved to who reads, not removed."
- `#r-shaping-the-rule-selected-by-what-comes-back` (counts; offspring carry the capacity; `RuleShaping.favours_iff`: favours shapers exactly where `c ≤ s`).
- `#r-shaping-selected-among-groups` (Hamilton's rule with what comes back added).
- `#r-shaping-read-by-readers-drawn-from-the-selected` (counts; `lo ≤ hi`; without noise): every course locked one way (`DrawnShaping.drawn_locked_either`); critical mass (`critical_mass_iff`).
- `#r-drawn-shaping-drawn-one-at-a-time` (counts): noise leaves either lock (`DrawnReplacement.lost_ge`, `fixed_ge`), a bound falling across the distance from the mass.
- `#r-loss-read-in-time-by-the-others` (counts; the others read the loss from a bound `N`; `lo' ≤ hi`): `ReadInTime.kept_iff`, `turned_iff`, at most one step between, `ReadInTime.deadline` (a bound, not the closing step).
- `#r-capture-by-counted-choices` (World for the selection part, near-definitional: `ChoiceCountCapture.selectsThrough`, `pooled_selectsThrough`; counts: `counted_locks`, `counted_outlives_loss`).
- `#r-rules-that-change-themselves-in-the-grammar` (root; `ClosedCapture.constant_iff_unread`, `lock_line`, `loss_ends_line`).
- Thesis T7 (`#t7`) with its frozen test LA2 (446), which counts against one forbidden case as a claim about trained judges. Readings (448–465), among them `#which-locks-noise-leaves`.

**§10 Readers the course removes** (`#pool-from-course`, 468–489; `Becoming.PoolFromCourse`; "none is new as mathematics"). `#r-a-pool-read-off-the-course` (any type; `ReadsThroughPresent`, `NotReadmitted` supplied): `locked_along`, `closed_stays_closed`; "says where leaving can lie, not that it happens". `#r-the-lock-draws-its-readers-out` (`windowRead`, `Stands`; `window_never_read`, `window_locked_after_removal`, `window_standing_thinned`, `window_order_kept`; witness `Drained`). `#r-on-whom-the-loss-falls` (counts; `borne_by_others_raises`, `borne_falls`; witness `Borne`). "What registers a removal" (481–487). Reading K2 (489).

**§11 Turning in time** (`#turning-in-time`, 492–525; AI-written 13 November). `#r-going-alike-up-to-the-nets-end` (root; `Law.stepWhile`). `#r-turning-in-time` (any type of ways, whole-number levels): `TurningInTime.toEnd_iff`, `constant_iff_needs_nothing`, `agrees_until_marked`, `ends_with_net`, `ends_with_net_regime`, `unending_iff_first_marked`, `turns_in_time_iff`, `recoverable_iff_above`, `noReturnAt_iff_first_below`, `turns_in_time_iff_before`; the lock's courses: `window_is_pair`, `join_is_asItWas`, `locked_closed`, `net_zero`, `locked_ends_with_net`; witness `Three`. `#r-a-way-of-units` (`WayOfUnits.ends_while_net_goes`, `unending_iff_holds`, `two_units_iff`, `greater_need`, `more_use_on_first`, `takes_nothing_iff_alone`; witnesses `With`, `Against`). "What is given" (523). Reading (525).

**What this chapter does not show** (`#not-shown`, 528–535): six items, quoted in 2(e). **Open** (`#open`, 538–549): ten items.

## 2. The frozen question, from this chapter

### (a) Renewing and consuming with respect to each other (H1)

Each of H1's five is told in §3.1 as a theorem with a base:

1. *Exclude each other; do not exhaust.* Line 116, `#r-relational-renewal-classification`, **Theorem** (World): "The two classes exclude each other and do not exhaust the cases (a seasonal condition is neither)." The chapter cites no Lean name for this clause. Lean opened: `Web.renewing_not_consuming` (`Dependence.lean` 222), no premise.
2. *Return grades what lies between.* Line 125, `#r-becoming-return-grades`, **Theorem** (World): "Return grades renewal: within `p` steps, at some later step, never. The grades are ordered; consumption is exactly a dependence that never returns (`Web.consumed_iff`), which restates the definition." It grades a condition's dependences, not formations.
3. *The class belongs to the run.* Line 119, `#r-becoming-renewal-reading`, **Theorem** (the renewable process; witness): "from one configuration, the focal formation active at every step, one run renews and another consumes ... and the sustaining formation ends (`Renewable.class_belongs_to_the_run`)". One built process.
4. *No finite stretch decides.* Line 128, `#r-becoming-finite-horizon`, **Theorem** (the renewable process; the support-gated law with feedback): "For every horizon `h`, two runs agree before `h` and then one renews and one consumes" (`Renewable.finite_reading_includes_consumption`), with "The force lies in 'every renewing run', which overdraws before `h`." Line 130 states it at the model: the region of renewing runs is not closed under agreement up to `h` (`finite_reading_not_exact`, `renewing_not_closed`).

So H1 is borne out by chapter 2 on all five. Three limits the chapter itself gives: (3) and (4) are of one built process (and the feedback law), not of every web; the consuming class "does not say the drawing made the deficit" (113); and "forming new organization at every step, or the drawer's own course, leaves the class undecided" (116).

What §3.1 adds beyond H1: loss for good in every balanced flow under the gate (`Flow.stays_below_at`, `Flow.ends_below`); joint consumption by two drawers each within renewal (`jointly_consuming`); the three outcomes of a loss (122); a consumer that switches conditions stays active and stays consuming (`persists_consuming`, 133); recovery by a supported route (136); renewal over a region keeping its own support while undermining another (`Clearing`, 142).

### (b) The chapter's pairs and how it says they stand to each other (H2)

The pairs or triples I found in the chapter:

- **P1, on the root (§1):** generation, keeping, degeneration (生成, 守/后守, 退化), under 延 / 尽 (going on along some branch, ending on every branch), with the strong forms.
- **P2, on the World's web (§3):** renewing and consuming, of a formation in a run; beside it, of a condition, renewed / consumed / lost, and the grades of return.
- **P3, on any law or process (§2):** returning and drawn (attraction); keeping and losing at a juncture.
- **P4, on the regime (§5):** a level at or above its point of no return, or below it.
- **P5, on rules (§9–§10):** locked one way or the other; kept or turned; a lock closed or left.
- **P6, on a way and a level (§11):** a line that ends where the net ends, or ends while the net goes on (turning in time).
- **P7, from 07, cited:** widening and keeping widening (lines 61, 545).
- Also arising / ceasing (§3.2) and rest / endless change (§4).

Sentences where the chapter says how two of them stand, or that it is not shown:

1. P1 with itself: lines 29–34, the exclusions and the mixed region (above).
2. **P2's renewing and P1:** line 36, "renewal does not decide the region" (`Map.Short.renews_and_ends`; here the renewal is §1's carrying renewal); line 53, "In two witnesses every carrier renews, the shifts being 全生成 and the relay reaching an end ... renewal of relations implies none of the strong forms" (`Map.renewal_undecided`). Lean opened (`MapInstances.lean` 93–96, the module's account): "Not connected: renewal along a continuation (`Web.RenewingAlong`) reads conditions, not whether a line goes on, and does not imply any region"; the theorem's docstring says of its two witnesses "neither has conditions".
3. **P2's consuming and P1:** line 56, a line from an active occurrence "that later holds a dependence on a condition kept below that need" is not 不穷 (`Web.consumed_held_not_endless`; premise: activity needs support); line 59, it degenerates (`Web.consumed_held_degenerates`). Lean opened (376–382; 96–97): the premise is that every occurrence the line reaches at step `N` requires the condition at a need not lower; the account says consumption "ends a line only where the line holds the dependence consumed ... since a drawer need not depend on what it draws."
4. Line 56, last sentence: "§§4–9 are not read as regions."
5. Line 51: "the some-branch regions are not read on the World." Open, line 540, the same.
6. Line 151: "Arising is activity starting, not §1's generation."
7. Line 531, not shown: "That the regions are decided at a point, or that renewal is generation."
8. **P1 and P7:** line 61, "The generation of a part's lines read here is not that widening"; "keeping widening ... is generation under the one that loses nothing, under premises of deciding, so what parts the two is exactly loss" (07 §2). Line 545: "the theorem relating the map's 生成 to widening runs one way".
9. **P5 and P1:** line 463, "the formal 元吸引子 says nothing of carriers, so whether a capture loop is 生成 at some pair of classes stays **Open**"; line 545, first sentence, the same.
10. **P4 and P6, P5 and P6:** line 494, "This section puts the two on one relation"; `TurningInTime.ends_with_net_regime`, `turns_in_time_iff` (through `RegimeMargin.ends_iff_below`), `window_is_pair`, `join_is_asItWas`, `locked_ends_with_net` (508–510); line 525, "neither theorem is derived from the other".
11. **P3 and P6/P5:** not said. I found no sentence joining §2's juncture or drawn-is-not-returning to §9–§11. `Run.locked_in` (71) and `RuleCapture.Locked` share a word; no sentence relates them.
12. **P2 and P5/P6:** not said. In lines 396–525 the words "renew" and "consum" do not occur (searched `renew`, `consum`, case-insensitive); in lines 106–192 "lock", "captur" and "select" do not occur. §11 takes §5's regime, not §3's classes.
13. **P2 and P4:** joined through the gate, not by name: line 116's `Flow.stays_below`, line 382 "gated renewal being the case", and T1's "In the model" (288), which sets the regime's exact point beside the World's joint excess.

H2, as far as chapter 2 goes: the account has more than three pairs that could be read as the two ways; the chapter does not treat them as one, and says so of P1 against P2 (items 2, 3, 7) and of P1 against P5 (item 9). H2's first clause ("without saying so") is not borne out: the direction page does say which pair it takes and that the taking is its reading (line 9). What the page does not tell is that the chapter has the other pairs, or items 2 to 9.

### (c) A course that can no longer be turned, the lock, turning in time (H3)

*§2.* Every loss passes a juncture (any process, `s` returns; up to double negation); a choice matters only at a juncture; to turn a reader at a juncture a source must have reached it before (World with a process; premises at line 90); what does not return is necessarily drawn (any process); a run in an invariant region stays locked in.

*§5.* The regime's point of no return is exact (premises in the index); two draws each held alone can end the condition together; the time to break lies in a band; under adjusting giving "what was given can carry a condition across" the point (`Crossing.crosses`); `DrawHistory.history_decides`: a draw raised long enough and brought back leaves the level at the inflow from then on.

*§7–§8.* The distance to a break is carried nowhere where the stock is read only below a threshold; a rule reading `ℓ` steps late needs a band of `2(ℓ+1)d`; below `m`, where the joint exchange gives no more than it takes, a level never returns.

*§9.* (i) `favouring_locks`, with "only a change of the law, of how the rule reads or of the selection leaves"; "The lock belongs to how the rule reads, not the share it favours." (ii) `lock_outlives_loss` under `Unread`; `turned_by_loss` "a sufficient way out". (iii) Readers drawn from the selected: kept for good exactly where the carriers are at least as many when the loss is read (`Thinned.kept_iff`); the same readers reading the same loss turn it when read from the start and leave it locked when first read at step 3. (iv) The capacity to shape the rule is selected exactly where `c ≤ s` (counts; offspring carry it); with readers drawn from the selected, "every such course is locked one way at every step" on either side of a critical mass, without noise. (v) Drawn one member at a time, "neither lock holds for good". (vi) `ReadInTime`: turning readings come first, keeping last, at most one step between; a deadline quadratic in the start's counts, "a bound ... not the step from which the window is closed". (vii) Counted choices lock and outlive an unread coordinate; counts that accumulate can survive noise (`#which-locks-noise-leaves`, a reading, cited not stated). (viii) T7 is conjectured; LA2 (446): "One note of the loss, on the one prose answer among nine readers, turned its reading", which the chapter keeps as a counterexample to T7's fourth forbidden case for trained judges.

*§10.* A lock read off the share "is left only along a stretch containing a reading step whose rule read is not the share-readers' ..., or a step at which the share is not kept" (473); with `NotReadmitted`, closed stays closed; where `K ≤ N` the loss removes its readers before they read it (`window_never_read`); a share not lower draws no less and its readers are gone no later (`window_order_kept`; premises: monotone selection, readings and drawn loss); a loss borne by the others does not leave the lock, "a case where T7's listed way out, a loss entering the share, does not leave" (479); borne by the shapers past what the rule gives them, the share falls, and in `Borne` the lock is left with no reader. Five regimes of what registers a removal (481–487). The chapter's limit (476): "That actual pools are read off courses so ... is not shown."

*§11.* With marked levels decided and the course as it was coming below the need, the line never ends exactly where there is a first marked step `T` from whose next configuration it never ends (`unending_iff_first_marked`); under §5's premises for the kept kind's use, exactly where the level at `T + 1` is at or above `H₂ + y₂` (`turns_in_time_iff`); "the line never ends exactly where that step comes before the point of no return of the course as it was" (`turns_in_time_iff_before`); the step-sense point of no return of 07 §3.6 is the first step below §5's level, for courses that never rise (`noReturnAt_iff_first_below`). The lock's courses are courses of the pair "at a need of nothing"; where the going-on does need a level, "a locked start ends the first way ... still locked" (`locked_ends_with_net`); "Being locked does not rule out a turn at a marked level." For units, a turn with no mark given (`two_units_iff`).

H3, as far as chapter 2 goes: borne out. The direction page tells four of these (the rule set again; the three premises of closing; the one built course left with no one registering; the keeping sentence). It does not tell the juncture, the critical mass on which the selection of control and the lock are one loop, the window with its one step between and its deadline, drift leaving a lock, the order theorem of §10, the five regimes of what registers a removal, `noReturnAt_iff_first_below`, `locked_ends_with_net`, or LA2.

One place outside the three sections I was asked to mark: under "What we do not know" the page says three clocks "are in three models with no statement between them". The chapter states `PoolFromCourse.window_standing_thinned` (the window that removes readers is §9's thinned pool while they stand), `TurningInTime.window_is_pair` (that window's course is a course of the pair with the losses in `[N, K)` marked) and `noReturnAt_iff_first_below`. These identify the models' courses; I found no sentence comparing the three times. Not opened in the Lean. I report it for the reader set to refute.

### (d) Does a chapter-2 theorem place the two ways where a line multiplies or a rule is set again (H6)

No theorem of chapter 2 does. What I looked for and where: §3's classes in §9–§11 (the words do not occur, item 12 above); a going-on that multiplies and needs a level (§9's counts multiply by offspring, but line 494: "their step is total, and nothing in them needs what they use"; §11's units: line 523, "Units only end; nothing builds one"); `LineOnAStock`, `LineageDrawdown`, `ReadingsSpread` (none occurs in the chapter). This search could miss a join told in words other than renew, consume, generate, keep; I read the three sections whole and saw none.

The nearest, each short of it:

- **§11, `turns_in_time_iff` with `locked_ends_with_net` and `window_is_pair`.** It places, on one pair of a way and a level, a course that ends as it was against one that turns to a kept kind and never ends, by an exact level and step; and the lock's courses are cases of the pair. Short of H6's "against" because: the kept kind does not remake anything (the regime's giving is a premise); marked levels, need and kept kind "are given, not derived" (523); the lock is a case only "at a need of nothing", and "that a lock needs nothing of what it uses is how its models are built, not a result"; nothing multiplies.
- **§10, `window_order_kept` and `Drained`.** A share that multiplies, a rule set again, and a drawn loss on one course. There is no second way in it: both sides are locks.
- **§9, `DrawnShaping.drawn_locked_either`.** Either side of the mass is a lock.
- **§1.** Generation and degeneration exclude each other on the root, at two grains, for every carrier and relation; the chapter says §§4–9 are not read as regions and leaves the capture loop's region open.
- **Where a course passes between, and by what:** §2's juncture (a theorem, any process); line 465, a reading from the market study, not a theorem: "A course passes between regions by a parameter change removing a retention condition, a shock, a failure of what executes correction, or change faster than correction ... a region ceasing, a state's departure and a strict bifurcation are not one 'phase transition'"; line 535, not shown: "no universal phase threshold between regions".

H6 stands after chapter 2.

### (e) The chapter's own "not shown" and "open" that bear on the direction

Not shown (530–535): "That generation is better than keeping or degeneration: no theorem says so"; "That the regions are decided at a point, or that renewal is generation"; "Which regions actual unfoldings enter, or any measure on branching courses"; "That actual systems meet the World's premises ... that the margin times a break"; "no universal phase threshold between regions".

Open (540–549): "The some-branch regions read on the World"; "Lifting §§2–9 onto the grammar ... the grammar has no amounts yet"; "Whether a capture loop (§9) is 生成 at some pair of classes", with what is open between 生成 and widening; for §9, "groups that form or assort by the share ... the time to leave a lock, a late reading of another form ... the step from which the window is closed rather than a bound on it"; the last item: "that reality generally develops more shared and more responsive renewal forbids nothing measurable as stated. A part can go on while closing what lies beyond its dependence (`Clearing.loses_beyond`), so persistence alone does not select widening".

Inside the sections: §9 line 418, "that actual rules are pools of readers so drawn ... is not shown"; §10 line 489, "None of these is shown sufficient by itself ... and nothing here shows selection by share supplying them"; §11 line 523, the whole of "What is given", ending "Nothing here is about a trained system."

## 3. The direction page's sentences that chapter 2 bears on

Marks: BO borne out; SD said differently; MORE the chapter says more; none is contradicted. Places are lines of `02-MAP.md`.

**Where we are heading**

| # | Direction page | Mark | Place and note |
|---|---|---|---|
| 1 | "One map of how things come to be, go on, change and end ..." | MORE | 9: the account already has a chapter that calls itself the map of formations within the whole map; the page does not say so. |
| 2 | "On it we want two ways ... placed with respect to each other and to going on at all" | MORE | §1 places generation, keeping and degeneration with respect to going on (延) and ending (尽), by theorem on the root (29–46). |
| 3 | "Placed means: where, and at which grain ... where it passes between them, and by what ways." | MORE | Grain: §1's two classes and orders (38). Passing: §2's juncture (85–93); 465 (a reading); 535 (not shown). |
| 4 | "The readers found no statement that places the two ways ... where a line multiplies or a rule is set again." | BO | 2(d): none in chapter 2; nearest §11. |
| 5 | "They are not named in the Lean." | MORE | §1's 生成 and 退化 are Lean names on the root (`Becoming.GrammarMap`); whether they are the two ways is a reading the page does not raise. |
| 6 | "The nearest we have found ... renewing and consuming there." | BO | 113. |
| 7 | "That they are the two ways is our reading ... this page's step." | MORE | 2(b) items 2, 3, 7: the chapter says how this pair stands to §1's and what is not shown. |
| 8 | "The web has no selecting in it and no turning, and it records that a formation draws on a condition, not how much." | SD | On the World (the web with a flow or a process) the chapter has selection through couplings (436, `ChoiceCountCapture.selectsThrough`), turning a reader at a juncture (90) and amounts drawn (248). The page's sentence may hold of the bare web: the definitions I opened (`Dependence.lean` 140–172) use only `requires`, `need`, `level` and `draws`; I did not open the structure itself. |
| 9 | renewing defined (`Web.RenewingIn`) | BO | 113. The page is the more exact: Lean opened, `Kept` asks the need met at `t` and at `t + 1`; the chapter says "meets, at every step". The page's "not that the formation remakes anything" is not in the chapter. |
| 10 | consuming defined (`Web.ConsumingIn`) | BO | 113, with `Lost` and "It does not say the drawing made the deficit." |
| 11 | "Each is said of a whole course." | BO | 108, 119. |
| 12 | "The same file has classes of a single step ..." | SD | 142–144 has renewal at a step and over a region; 125 sends the stepwise reading to 07. The sentence's second half is not in chapter 2 (searched `RenewingAt`, "within renewal", "stepwise"). |
| 13 | "no formation is both ... in two built courses the drawer is neither" | BO | 116 (seasonal). The second built course is not named there. |
| 14 | the fixed pair's drawer within renewal is renewing and active | SD | 116 tells only the consuming half for the support-gated family; the renewing half stands at 139 under another law (periphery, a wear law). |
| 15 | the drawer beyond renewal is consuming and the second ends | BO | 116, 133. |
| 16 | "If such a drawer itself needs something ..." | BO | 116 (`Flow.ends_below`), 119, 133. |
| 17 | two runs the same up to every horizon (`Renewable.prefix_does_not_decide`) | BO | 128. The chapter cites the corollary `finite_reading_includes_consumption`; Lean opened, both are in `Horizon.lean` (108, 147). |
| 18 | "no stretch from the start, however long, settles which it is" | BO | 128, 130. |
| 19 | "It has neither that sentence's 'from inside' ... nor its 'because'." | MORE | On other models the chapter has a "because": 350 (`break_carried_nowhere`), 367 (`Web.break_not_bounded`), 415 (`lock_outlives_loss`). |
| 20 | "No statement that was found joins any of these to the line or to the lock" | BO | 2(b) item 12. The chapter does join consuming to §1's degeneration (56, 59). |
| 21 | "a unit only takes from the one amount all rest on" | BO | For the way of units: 515, 523. The line on a stock is not in the chapter. |

**The idea**

| # | Direction page | Mark | Place and note |
|---|---|---|---|
| 22 | "Whatever lasts is made again and again, out of other things that are going on too." | SD | 7, 182: proved where parts are brief or every part ends and the active are listed. The chapter also has keeping (守, a pattern going on with no carrying renewal, `Map.Still.keeps`) and wholes persisting with nothing arising (`Immortal`, `Countless`, 182). No contradiction if "made again" means continued step by step; one if it means new carriers keep arising. |
| 23 | "So how a thing goes on is also doing something to what lets it go on." | MORE | 160: under balance and dissipation, "Maintenance is such taking"; 113: consuming "does not say the drawing made the deficit". |
| 24 | "What a going-on rests on, and what makes a difference to it, need not be the same." | BO | 326, 350, 367 (a requirement coupled in by threshold only); 502 (`toEnd_iff`, `constant_iff_needs_nothing`). |
| 25 | "The gap ... run down unseen, or turn in time." | BO | 367, 415, 508; 525's "one sentence with two endings". |
| 26 | "A way of going on can keep remaking ..., use it up, or change what it rests on, and differently at different grains." | MORE | 122 (restored, transformed, ended, "not exhaustive or exclusive"); 133 (changing what it rests on does not undo consumption); §1 (grains). |
| 27 | "From inside these can look alike until late, because ..." | BO | In parts, on separate models: 128 for alike until late; 350, 367 for the because. No one theorem has both. |
| 28 | "Of the ways open to something, which one happens goes with what makes a difference to it." | BO | 436, which the chapter calls near-definitional. |
| 29 | "The trap is a sentence in which what favours is not itself kept up or run down by what it favours." | MORE | 494 and 523: the chapter says its own lock models are so built ("nothing in them needs what they use"). |
| 30 | "One small model now has selection as a step of it ..." | MORE | Another join is in the chapter: §10's selection course is a course of §11's pair (`window_is_pair`, `pair_adaptive`, 500, 510). |
| 31 | "Some hold to something: a thermostat to a temperature ..." | MORE | §8's theorems on a level held from both sides and a rule reading late (377–379). |
| 32 | "We call such a going-on a loop." | SD | 323 defines a loop as "a chain of couplings back to its start"; §9 speaks of a loop of selection. |
| 33 | "What it takes has to be there." | BO | 304. |
| 34 | "where what it takes from is renewed only by what needs it too ... it does not come back." | BO | 116 (`Flow.stays_below_at`; premises: balanced flow, every giver depends on it at need ≥ `m` and is supported where it gives); 382. |
| 35 | "It can open at what is not registered; ... and at what cannot be acted on in time." | BO | Three of the four: 415; 418 (outweighed); 476 (removed); 433, 508 (in time). "Registered and not held to" is not in chapter 2 (searched "held to", "holds to"). |
| 36 | "How they select can be set again from what it already favours and stay so ..." | BO | First clause only: 404, 436. |
| 37 | "what it leaves out can be used up while nothing they register differs." | BO | 415, 436. The chapter's caveat (444): "the unread coordinate is a loss by reading". |
| 38 | "The case we most want on the map is two things together ..." | MORE | §10 states the two on one course under supplied premises (476, 489). |
| 39 | "a closed loop can go on without end where what it takes keeps being met." | BO | 439 (`lock_line`), 510 (`net_zero`, `locked_ends_with_net`). |
| 40 | "where what is used up is what others rest on ... gone for them for good." | BO | 119, 133 (`persists_consuming`); 479 (`Borne.others_locked`). |
| 41 | "Many readings that all miss it close as well, where pooling them reaches only what each reaches." | BO | 436 (`pooled_selectsThrough`, `pooled_unchosen_beyond`). |
| 42 | "One that reaches it turns the loop only if it reads in time and is not outweighed, and reaching does not fix which way." | BO | 418, 433. |
| 43 | "... in the Lean their pieces are not joined" | SD | §10 calls itself a composition of §9's theorems stating "a loop of the meta-attractor's shape as a dynamic" (470), and says what it does not join (489: "an optimizer shaping its own rule ... is not stated here either"). |
| 44 | "We do not expect a top: what a loop holds to is set by slower loops ..." | MORE | 385 (`Pace.pace_law`); 441: "a tower of rules with no top is one process too" (07 §2). |
| 45 | "An argument that uses only what a reading registers cannot show a running down that changes nothing the reading registers" | BO | 415 (`courses_alike_iff_unread`); T7 carries it beyond the model as a conjecture. |
| 46 | "Word of it was not enough in the one tested case" | SD | 446: the chapter reports another frozen test, in a trained judge, where one note of the loss among nine readers turned the reading. |
| 47 | "Nothing here says a course should last." | BO | 14 ("The map orders nothing"), 530. |

**What we have found so far**

| # | Direction page | Mark | Place and note |
|---|---|---|---|
| 48 | "What lives on something nothing renews ends when that runs out." | BO | 304 (balance, only active giving, activity needing support). |
| 49 | "Where what renews a stock also needs it, once below the need it does not come back." | BO | 116, 382; on the regime 256. |
| 50 | "After such a loss, whatever still goes on has changed what it needs." | BO | 122 (activity needs support). |
| 51 | "A course does not differ where nothing reaches it." | BO | 90, 321, 415, 436. |
| 52 | "A rule set again from what it already favours stays as it is." | BO | 404, with what leaves it and the reversed perturbation that is not absorbed. |
| 53 | "And of keeping: a way whose response ... goes on without end, and otherwise it ends." | BO | 508 (`turns_in_time_iff_before`), premises there and at 523. |
| 54 | "Its laws, and those on the lock beside it ..., are told with all their premises in the plan" | MORE | The lock's laws have a home with premises in §9–§11, which the page does not point to. |
| 55 | "Who comes next depends only on which needs the level meets ..." | SD | Nearest, without offspring: 502 (`toEnd_iff`), 506 (`alike_along`). |
| 56 | "Used up while nothing yet differs ..." | SD | Nearest, without offspring: 504–506 (`agrees_until_marked`, `ends_with_net`). |
| 57 | "... whether the second then goes on is a law under premises (`WayOfUnits.two_units_iff`)" | BO | 519, 523. |
| 58 | "A reading that reaches what is being taken turns the loop only if it also reads in time and is not outweighed." | BO | 418, 433. |
| 59 | "every held-to is handed in" | BO | 523: "the marked levels, the need and the kept kind are given, not derived". |
| 60 | "the taking and the closing as outcomes of one course (in the one theorem with both, both are premises)" | SD | 476: with `Stands`, the readers are gone once the loss reaches `K`, so the removal follows the loss by the window's definition; `window_order_kept`. Not opened in the Lean. |
| 61 | "Nor is the lock joined ... to a selection that rebuilds what selects it across changes of who carries it" | BO | 463, and it names the open join in the chapter's terms (a capture loop as 生成, carriers as 传). |
| 62 | "The law nearest 'a closed loop can go on' ... has one level" | BO | 256 on the regime; 506, 519 on the pair and on units. |
| 63 | "A separate law (`RegimeMargin.rises_by_draw`, in neither record) ..." | SD | Not named in the chapter (it names `lowered_raises` and `rises_superadditive`, 256–258). The result record §5 links does name it (`margin-of-a-regime.md` line 18: "a larger draw, giving no more, raises it by at least the difference"). |
| 64 | "no statement was found that says the two are one point" | SD | 256 and the record call both "the point of no return ... the draw above the least level whose giving meets it". Lean opened: `Root g H y` is `H ≤ g y ∧ Short g H y` (258), and `Short` is a premise of `ends_iff_below` (741); I saw no named theorem tying them. `rises_by_draw` occurs in `Becoming/*.lean` only at its statement and in its module's account (grep). |
| 65 | "Closing is at least three different premises ... and in one built course a lock is left with no one registering" | BO | 415, 473, 418; 479 (`Borne`). The chapter adds five regimes of what registers a removal (481–487). |
| 66 | "The Lean is large and mostly unjoined" | BO | 56, 541. |

**Counts.** Sentences of the three sections that chapter 2 bears on: **66** (21, 26, 19). Borne out: **40**. Said differently: **12**. The chapter says more: **14**. Contradicted: **0**. The split is mine: a sentence borne out in part is counted as borne out with the part named.

Not in chapter 2 (searched as named): the line on a stock and its two readings as told (`LineOnAStock`); draining in full view ("best response", "profile", "in full view"); position and "every gain is another's loss"; `LineageDrawdown.Drain`, `ReadingsSpread.Commons`; `Flow.Balances.includes_of_renewingIn`, `Untaken.consuming_keeps` (in no chapter by grep of the eight); `narrows_of_consumed`, `Preemption.renewingAt_consuming_narrows` (once each in chapter 7 by grep, not read).

On H4: no sentence of the three sections is contradicted by chapter 2. The nearest are 22, 46 and the "three clocks" sentence. On H5, from this chapter alone: of roughly 40 sentences under "What we have found so far", 13 are borne out with premises in chapter 2. The line on a stock (15–16 November) has no home here; the lock and `WayOfUnits.two_units_iff` do. I did not read the plan, so I cannot say which lock laws its items 1 to 6 hold.

## 4. The five things in chapter 2 the direction page most needs to tell or point to

1. **§1's pair, and how the chapter says it stands to renewing and consuming.** Generation, keeping and degeneration are defined and placed on the root, at two grains. The chapter says renewal implies no region (`Map.renewal_undecided`), consumption degenerates a line only where the line holds the consumed dependence (`Web.consumed_held_degenerates`), "that renewal is generation" is not shown, and §§4–9 are not read as regions (lines 36, 53, 56, 59, 531).
2. **§3.1 as the home of renewing and consuming.** The five placing theorems of H1 with their bases (113–130), and what goes beyond the page: joint consumption, the three outcomes of a loss, a consumer that switches and stays consuming.
3. **§11 as the chapter's join of the lock to a level that is needed,** with its own account of what is given: `window_is_pair`, `locked_ends_with_net`, `turns_in_time_iff`, `noReturnAt_iff_first_below`, and the sentence that the lock's models need nothing of what they use (494–525).
4. **§10, the taking and the removal of readers on one course:** `window_never_read`, `window_order_kept`, `closed_stays_closed`, the witnesses `Drained` and `Borne`, and the five regimes of what registers a removal (468–489). It bears on the page's "pieces are not joined", "both are premises" and "three clocks".
5. **§9's results on when a lock can be left, and its test.** The selection of control and the lock as one loop on either side of a critical mass; the window with one step between and a deadline; drift leaving a lock and which locks it does not; and LA2, a frozen test in a trained judge where one note of the loss turned it, which the page's "the one tested case" passes over (427–459).

Close behind: §2's juncture (a source must reach a reader before the juncture), and §5's family of thresholds, where the page's "second" found thing of 17 November already stands (the "rest on webs" row, 277).
