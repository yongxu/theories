<!-- AI-written: one of seven read-only readers, 4 November 2026, for the atlas plan. Kept as evidence for PLAN.md; not checked line by line. -->

## Coverage

| Source | What I did |
|---|---|
| `theories/becoming/chapters/07-SIGNIFICANCE.md` | read in full (lines 1–791, in chunks) |
| `theories/becoming/COLLECTIVE-DIRECTION.md` (CD) | read in full |
| `theories/becoming/ONE-ARGUMENT.md` | read in full |
| `theories/becoming/review/ALIGNMENT.md` | read lines 1–66 (ten-minute part, tests, item list, Terms) and 305–539 (A-10b through A-17). A-01–A-10 and A-18–A-20: headings only |
| `GOALS.md` §Generative alignment | read in full (lines 100–138) |
| `…/aj-joint-selection/PLAN.md` | read in full |
| Targeted reads | 02 §9: groups, drawn shaping, drawn one at a time, read in time. 05: Open and four pool sections. `DELEGATED-CHOICES.md`: rows D45 and D68. `PremiseWitnesses.lean` L150–168. `Direction.lean` `chosen_keeps_basic`. The "not shown" lines of three records. 08: theses rows T4, T5, T8 and item 12. `PHILOSOPHY.md` P-07. `ig-integration-gaps/GAP-MAP.md` 6.2–6.3. LW NOTE §4. CD design §1. I located Lean modules by grep; I did not read the proofs. |

Nothing heavy was run. Standings below are copied from the home text.

---

## Gap 1: the fourth combination, "control left unselected with a lock left in time"

**Current text** (07 §6, line 669): "Of the four combinations of control selected or not with a lock left in time or not, three occur in these models … Not shown is the fourth, control left unselected with a lock left in time: with two kinds, leaving the lock below the critical mass means a rule favouring the shapers, which is control selected. Read for the shapers' capture alone, the lock below the mass is none, and the case not shown is instead control left unselected with that capture kept. Either way, control left unselected and a lock left in time are not shown to be independent."

CD, "What this page does not show" (line 124), restates it faithfully. So do PLAN §1 and §5, dossier A-10c, and records `loss-read-in-time-by-the-others` (line 58) and `shaping-read-by-readers-drawn-from-the-selected` (line 33).

**The three combinations that occur.** All are on counts: two kinds, whole-number counts, no noise.

| Combination | Where it occurs | Lean |
|---|---|---|
| control selected, lock kept | above the critical mass, nothing read beyond the share | `DrawnShaping.drawn_rises`, `drawn_locks`, `drawn_locked_either` |
| control unselected, lock kept the other way | below the critical mass | `DrawnShaping.drawn_falls`, `drawn_from_below` |
| control selected, lock left in time | a witness | `ReadInTime.Window.in_time`, with `turned_early_iff`, `kept_once_favoured`, `at_most_one_between`, `deadline` |

**The stated reason is not formalized.** The reason for the fourth case, "with two kinds, leaving the lock below the critical mass means a rule favouring the shapers", is given in prose with no Lean name in 07, CD, PLAN or either record.

**Forms an answer could take:**
- **A proved limit within two kinds.** It would be near-definitional: along `DrawnShaping.drawnCourse` or `ReadInTime.lossCourse`, a configuration that leaves "locked the other way" has a rule that weakly favours the shapers. Its standing would be "impossible in the two-kind counts model", not independence or dependence in general. Ties need care: `favours` is weak, and `ReadInTime.Tie.both` shows a tied reading both keeps and turns.
- **A witness with a third kind of reader.** Dossier A-10c Q3 asks for "a third kind of reader, for example". GOALS Next asks for "one institution test system whose readers are not drawn from the selected".
- **Starts not under the rule read there.** The MA4 record lists this among what is not shown: "a rule in force against the reading can carry the share across the mass, `RuleCapture.Reversed.not_absorbed`". The rule in force and the rule read can then part.
- **A model in which shaping changes what the rule reads.** Only such a model could tell capture from accountable revision (PLAN §1; A-10c Q3).

**Lean to build on:** `RuleCapture.lean`, `ClosedCapture.lean` (`Thinned`, `lossPool`, `turned_by_loss`), `RuleShaping.lean`, `DrawnShaping.lean`, `ReadInTime.lean`. Possibly `RuleRebuilding.lean` (OG2: a rule "taught from outside") and `ReaderRebuilding.lean` (OG); whether either is that test system is not stated anywhere I read.

**Overclaiming risks:**
- A three-kind witness shows only that something can happen.
- These are "facts about control selected or not, not about capture" (07 §6).
- What the rule reads is fixed "by the readers' premise, not by the shaping".

---

## Gap 2: the noisy and long-run case of the capture loop

**Current text:** CD line 125: "The noisy and long-run case of the capture loop".

**Proved** (02 `#r-drawn-shaping-drawn-one-at-a-time`, counts):
- Drawn one member at a time, "neither lock holds for good" (`DrawnReplacement.lost_ge`, `fixed_ge`).
- The bound on drift falls across the distance from the mass (`lost_above`, `fixed_below`), and fixation follows (`fixation`, from `Drift.lean`).
- Risk dominance in counts is `2c < hi + lo` (`risk_dominant_iff`), and fixation can part from it (`Strong.other_first`, 6,215,625 against 6,250,000). The order turns at `a = 100` or `p = 99` (`Weak.shapers_first`, `Weak.shared_decides`).

**Cited, not proved:** "that under rare mutation the long-run state is the one with the larger fixation weight (Fudenberg and Imhof 2006)".

**Not shown, by the records:**
- MA4's record: "Readers who learn …, a cost changing with the share, readers not counted as the population counts them, starts not under the rule read there".
- MA4b's record: "Courses with noise, readers who learn, readings changing with the share, a loss read before it reaches N, and a general law for the round from the one step between".

**Forms:**
- Formalize the rare-mutation limit for the finite birth–death chain. This is a known result, so it must be credited; it would likely need limits, and so the periphery with its axioms reported.
- A new law joining `DrawnReplacement` to `ReadInTime`: the window under drift.
- `RuleCapture` and `ClosedCapture` (threshold, alternating) under drift.
- A reader model in which one report outweighs counts, as LA2's judge read (GOALS Next).

**Lean to build on:** `Drift.lean`, `DrawnReplacement.lean` (it imports `Drift` and `DrawnShaping`), `ReadInTime.lean`, `ClosedCapture.lean`, `RuleCapture.lean`.

**Overclaiming risks:**
- "Noise" here is a replacement chain, not mutation or learning.
- The natural-number weights are read as probabilities.
- The parting from risk dominance is one small population under strong selection.
- That drift is "an exit worth counting" is a question (A-10b Q2), not a result.

---

## Gap 3: how pools form, last and resist capture

**Current text:**
- 05 Open: "How pools form, last and resist capture beyond recruitment through their own coupling; a pool whose rule and members are both formed through what it reads (resisting a capture that hides a loss needs a member admitted by what the pool does not yet read)."
- 07 Open: "how pools are admitted and resist capture".
- CD line 125: "how pools form, last and resist capture". This drops 05's "beyond recruitment through their own coupling".

**Proved:**

| Law | Lean | Model |
|---|---|---|
| a group's closure is the union of its members' | `withinClosureOf_iff` | any relation |
| a pool separates exactly what some member separates | `Web.separates_all_iff_member` | World, list decided |
| an act differing only beyond the union is unselected | `Flow.act_unselected_pool`, `Flow.unselected_beyond_pool` | World |
| a pool recruiting through itself couples into a loss only as its course without the loss would | `Web.RecruitsThrough.alike_iff` | World, recruitment as a hypothesis |
| the exit: a reader admitted from outside | `PoolCourse.scheduled_apart` | witness |
| what a pool's acts respond to: bounded, not fixed | `ExchangeLaw.acts_alike_all_iff`, `ExchangeLaw.response_not_fixed_by_coupling` | World |
| readers reading readers | `Turns.cascade_through`, `Turns.Copying.reaches_first_only` | any type, near-definitional |
| count reviewers by independent causes | `Reconfiguration.ready_iff_nonempty_separated` | pure core |
| reading a system reaches no further than pooling with it | `Flow.withinCoupling_reads_iff` | — |

**Forms:**
- **A limit.** For a pool whose rule and members are both formed through what it reads: compose `RecruitsThrough` with `ClosedCapture.Drawn` / MA2's readers drawn from the selected.
- **A law.** Turn the `PoolCourse` witness into an iff: the pool resists a capture hiding a loss exactly where admission reads what the pool does not yet read.
- **Lasting.** Model a pool as a formation with upkeep. OG2's held-rule law ("stays held … exactly where teaching fits a tenure, the quota is at least one and the steady state's take fits the renewal") is one institution's lasting law.

**Lean to build on:** `SelectionPool.lean`, `PoolResponse.lean`, `PoolCourse.lean`, `Reconfiguration.lean`, `PooledEnvelopes.lean`, `ClosedCapture.lean`, `DrawnShaping.lean`, `RuleRebuilding.lean`.

**Overclaiming risks:**
- "Reaching is not responding" and "coupling is not compliance".
- Groups are "listed as given; how they form … not stated" (02).
- Whether an actual pool recruits so is empirical.

---

## Gap 4: the second-order direction of 生生

**Current text** (07 Open): "a comparison of a range whose widening keeps widening with one merely wider now, never reversing widening and counting neither novelty nor scale … The candidate left is what carries a course's openings." CD line 127 agrees: the laws "are on one course, and compare no two".

**Proved constraints** (07 §2, World unless noted; "Each law is near-definitional" or a witness):

| Constraint | Lean |
|---|---|
| eventual widening is the long-run form of widening but not the second order; it can be neither verified nor refuted | `Web.EventuallyWidens`, `Web.eventually_neither` |
| on the two-sided web, no strict partial order containing widening ranks every course keeping widening by name above every course that admits alike, was wider at first and is mixed with it; it is an order where the static course's admissions are listed | `Sides.no_order_ranks_keeping_over_alike`; `Web.ListedOrder.*` |
| widening with a lag and eventual widening hold of a pair in opposite directions | `TailAndLag.no_order_contains_both` |
| covering implies inclusion now, so same-offset reachable widening is first-order | `Reaching.Covers.now`, `Reaching.not_widens_of_wider_now` |
| on a branching witness, realized and reachable widening hold of a pair in opposite directions | `KeptAlternative.no_order_contains_both` |
| causal-set growth: no strict order contains both widenings | `CausalGrowth.no_order_contains_both`, `not_above_antichain` |
| what carries a range is invisible to widening, and ranking by it reverses widening | `OpeningChain.carried`, `ClosedCycle.cycle`, `Saturated.reverses`; recency form `Flow.OpenedByOpenedWithin` ("the same three facts hold") |
| what one course keeping widening needs | `Web.KeepsWidening.passes_every_bound`, `Flow.whole_not_keepsWidening`, `Steps.keepsWidening_iff_generation_losing_nothing` |

**Forms:**
- **A proved limit generalizing `Sides`.** For example, over orders unchanged under re-identification, given that `NamesAcrossSteps.lag_reads_names` shows the lag reads names.
- **A new order.** A lexical join of widening with a carrier order on the pairs widening leaves open, using the `strictJoin_trans` pattern. It must never reverse widening, and `Saturated.reverses` forbids ranking by the carrier alone.
- **A premise comparison.** 07 says "calling eventual widening better is a premise beyond C" and "the lag's verdict is a premise beyond C". It also notes that calling eventual widening better would be "the unlimited continuation priority that the priority of basic conditions rejects".

**Lean to build on:** `EventualWidening.lean`, `EventualWideningInstances.lean`, `KeepingWidening.lean`, `ComparingCourses.lean`, `ReachableRanges.lean`, `HeldPossible.lean`, `WideningOnTheMap.lean`, `CausalGrowth.lean`, `Tasks.lean`.

**Overclaiming risks:**
- The grammar's `«生生»` (renewal without end) is not the ethics' 生生 (GLOSSARY; CD §7 says so explicitly). 07 §2's `RaisedEveryOther.both` uses `«生生»` / `«生生不息»`.
- Results "by name" leave lineage out.
- "Counting is scale, which the second-order direction does not count."
- The Kauffman reading is not a result.

---

## Gap 5: deriving C from a weaker premise

**The hard rule** (`Becoming.ReadsNoOrder.not_entails`, `PremiseWitnesses.lean` L161; home 08 `#r-premises-met-and-failed`). The docstring says: "Let a statement read no order, and at a datum `d` entail C (`Comparison`) on a frame that has an extension. Then it fails at `d` for every order". 08 adds: "This is immediate, since 'better' is free". So any route to C must take a premise that reads the order. 07 itself never cites this theorem (see flag 9).

**Open-work statements:**
- AGENTS: "deriving C from a weaker premise is open work".
- 07 T8: "a reason for C".
- 07 §4.4: "Monotonicity at the standpoint is C's premise relocated: weaker, still a premise."
- 08 item 12: "C to monotonicity at each standpoint".

**Routes discussed in the repository:**

| Route | Where | What it gives | Why it is not a derivation |
|---|---|---|---|
| every order increasing in admission | 07 §4.4 `Weighting.widens_iff_every_of_class` | the shared order is exactly widening (Sen; Pareto) | "C's premise relocated" |
| positive valuers (T5) | 07 §8 | a bound on where disagreement can fall | "That valuers value positively is C's premise relocated" |
| self-concern (`Weighting.IncreasingInOwn`) | 07 §4 `Web.extension_ranked_of_increasingInOwn`; `Weighting.ended_below`; `Flow.coupled_ending_ranked_below` | C between listed level paths where the de se condition holds and admission is decided; one case with no C | "one way"; listed paths admit nothing from some step on (`Web.admits_nothing_from_of_listed`); vacuous for all level paths (`Web.not_listsAdmitted_every`); the converse is not shown; `Weighting.some_increasingInOwn_reverses`; "It does not derive C" |
| the continuation condition, the step, and P1–P4 of §4.2 | 07 §4.1–4.2 | scope | "The condition alone ranks nothing"; it reads no order |
| P1–P4 of §4.6 and the crux (§4.7) | 07 §4.6–4.7 | scope past one's end | "P4 ranks nothing, so order is untouched" |
| graded significance | 07 §4.4 `Weighting.prior_lt_of_widens`, `prior_transfer` | Pareto, and Pigou–Dalton transfers | needs a graded order; "The step gives a positive grade, not status" |
| J1–J4 | 07 §5 | decide some mixed pairs | presuppose an order; the priority does not follow from C (`ScoreRepresentation.comparison_does_not_yield_priority`) |
| FR, strict matching | 07 §5 `Frame.SufficientMatching.comparison` | it "contains C" | stronger, not weaker |
| unfolding `better := widening` | 07 §3.2, §4.4 `Web.paths_comparison_widens` | C "holds" | "a reading, not a consequence"; CD design: "the normative content of C lies in calling widening better" |
| quasi-option value | GAP-MAP 6.3 | — | "needs a later chooser, which 07:343 already counts as C relocated" |
| capability approach | GAP-MAP 6.2 | — | "never weighed against C" |
| life's stance (T8, LW) | LW NOTE §4 | — | "No reason for C can be given from life's stance" is listed as what would make it wrong |
| eventual widening or the lag | 07 §2 | — | "a premise beyond C" |

**For the atlas:** 07 uses the labels P1–P4 twice, for two different arguments: §4.2 (the strongest argument for the step) and §4.6 (the path). §4.7 disambiguates them ("P1 to P4 here are §4.6's"). The atlas needs distinct ids.

---

## D68's four readings (07 §6; dossier A-11 to A-14)

All four are "[AI reading, D68]"; none uses an ethical premise.

| Reading | Rests on | Lean | Its premise or limit |
|---|---|---|---|
| A-11: help that lowers the cost of shaping never lowers the selection for control | "those laws alone" | `RuleShaping.lower_c_raises`, `lower_c_raises_strictly`, `favours_iff`; `shared_lowers`/`shared_raises`; `SharedFlips.with_rises` | "That assistance lowers an actual cost, and changes nothing else, is the reading" |
| A-12: obedience adds capacity, not coupling | the several-optimizers record (A-04), "not on the law of shaping" | at a mutual best response, existence "not shown in general" | "That the assistant's order rises with the principal's family is the reading's premise, not the law's" (AJ6, 30 Oct) |
| A-13: a counter-rule read from its own share locks; the imperial examination | the capture laws | `RuleCapture.uniform_locks`, `locked_stays`, `Reversed.not_absorbed`, `Alternating.never_locked` | an instance of A-07 that adds no law |
| A-14: shared rule-making | the law of shaping | `favours_iff`, `grouped_rises_iff`, `nothing_back_falls`, `Split.*`, `SharedFlips.*`, `Assorting.either_verdict` | "not shown to remove the selection for control however large its shared part" |

---

## The exits table (CD §2)

| Exit | Lean | Model | Its edge |
|---|---|---|---|
| read what lies beyond the share | `ClosedCapture.turned_by_loss` | any type; sufficient, not shown necessary | a reading formed from the share absorbs any change |
| read the loss in time | `ReadInTime.turned_early_iff`, `Window.in_time` | counts | `kept_once_favoured`, `at_most_one_between`, `deadline` |
| shaping that brings nothing back to the shapers alone | `RuleShaping.nothing_back_falls` | counts | `SharedFlips.with_rises`; `lower_c_raises` |
| pool couplings | `withinClosureOf_iff`, `Web.separates_all_iff_member` | any relation; World | `Flow.act_unselected_pool`; `RecruitsThrough.alike_iff` |
| restraint within the joint slack | `Flow.Balances.kept_of_restrained` | World | where the rest outruns the renewal; `Optimum.MutualBest.full` |
| divide the take by exclusive footprints | `Flow.level_kept_of_plans` | World | that an actual division is so is not shown |
| reward each step a need stays met | `Optimum.frontier_keeps_stepwise` | any renewal law | "one optimizer's law, not a collective exit"; `Optimum.Coupled.drains_below` |
| give first, with a reserve | `Tolerance.sparing_gives` | any type | `Tolerance.total_stays` |
| count reviewers by independent causes | `Reconfiguration.ready_iff_nonempty_separated` | pure core | two reviewers moved by one cause |

CD's caveat: "Every capture law here is a two-kind count model, its locks stated without noise."

## The six conditions of situationality (CD §6, "[AI reading, D45]")

1. **Coupling**, by level and not by threshold, into a selecting pool.
2. **Response**: the pool's members respond (`Flow.stays_beyond_response`).
3. **Time**: before the point of no return, and before the share reaches the step from which the late reading favours the shapers.
4. **Resolution**: the feedback separates what matters (LA1/LA1b).
5. **Pace**: `L ≥ 2N − 1` (`Pace.pace_law`).
6. **Structure**: the rest does not outrun the renewal.

CD adds: "all six together still rank nothing: calling the widening course better needs C, and counting the losses that return to no one needs the continuation condition."

## Theses (07 §8), with standings

- **T4, "The scope can be installed, and it carries."** *Standing:* "IN1 partly passed (with talk, one model of two); transfer untested." This matches 08 and ONE-ARGUMENT §4.
- **T5, "The order is shared by every valuer who counts everything positively."** *Standing:* "the reduction proved for net weightings, the bound conjectured; VD1 failed, VD2 passed in part." The reduction is `Weighting.narrower_above_net`, `reads_ranksNet`, `reads_ranksNet_widens`. It is not proved "for orders neither additive nor transitive". This matches 08 and A-15.
- **T8, "生生 as the direction."** *Standing:* "argued". Open: "P2 and P4, the crux of §4.6's path, with P3, a correspondence not shown for actual selves; the step of invariance …; and a reason for C." "of whatever substrate" rests on P2 and P4 (07 §4.7). Beneath it: `Weighting.widens_iff_every_of_class`. "No verdict binding every possible mind is claimed."

---

## Inconsistencies flagged

| # | Severity | Location A | Location B | Issue |
|---|---|---|---|---|
| 1 | medium | GOALS line 114 (overview): "a chosen move keeps the basic admissions some move keeps, and a move whose outcome another's widens is not chosen" | 07 §5 and §7; `Direction.lean` L99 | The Lean gives only `¬ ¬ W.Admits …`, and only under the hypothesis that one move `u` keeps every basic admission any move keeps; "required" needs listed, weakly decided outcomes (`kept_required`). `narrowed_not_chosen` holds "wherever it is decided whether the widening adds a basic admission", under J1/J2. GOALS is generated: edit the scoped-goal record. |
| 2 | medium | CD §4 line 76: "What that path does not reach, future beings in no one's line among it, still needs the step" | 07 §4.6 "What the path does not reach" | 07 lists four things: another center's standpoint beyond its part; what affects one's conditions without being fed by them; "Present beings beyond every closure"; "Whatever no chain joins". CD narrows this to future beings. CD also links "that is a law" to the §4.5 anchor `#r-reach-through-a-shared-condition`; the law is §4.6's conclusion. |
| 3 | low–medium | GOALS line 116, Next: "Still to do: AJ4's one page for alignment researchers, now in draft" | PLAN §3 Missing 1, Step 5, §7 | Stale: the one page is the dossier's opening section (31 October); what is missing is a person's reading of it. |
| 4 | low–medium | GOALS line 104, condition 2: "before the loss passes its point of no return" | 02 and A-10c: "the point of no return belongs to the share's course, and the loss only times the reading"; PLAN §1 condition 2 | PLAN reads the goal's wording this way; GOALS does not tell its reader so. |
| 5 | low–medium | CD line 125: the "noisy … case" is not shown | CD line 55; 02 `#r-drawn-shaping-drawn-one-at-a-time`; A-10b | Drawn one at a time is proved (drift leaves either lock). Only the long-run state is cited, and noise joined to the loss read in time is not stated. |
| 6 | low | 07 §6 line 665, PLAN §1, GOALS: `c < s + m q ρ` "listed in groups" | 02 groups law: `grouped_rises_iff_sized`; `RuleShaping.Sized.either_verdict` | 07 uses `m` without defining it; the form holds for groups of size `m`, and with unequal sizes the spreads do not decide. The dossier's A-14 entry is already batched (XR). |
| 7 | low | CD line 125 (pools) | 05 Open; 07 Open | Three phrasings; CD drops "beyond recruitment through their own coupling". |
| 8 | low | 08 T8 row | 07 T8 | 08 omits P3 (a correspondence not shown). |
| 9 | low | 07 §4 and the thesis paragraph | CD §3; AGENTS; 08 §7 | 07, the home of C, never cites `ReadsNoOrder.not_entails`. |
| 10 | low | D68 row (`DELEGATED-CHOICES.md` line 107) | 07 §6, fourth D68 reading | The row does not name AJ8's grouped extension, now cited by the reading. |
| 11 | low | `shaping-read-by-readers…` line 33: "the converse cannot be shown here"; A-10b: "which shows that converse" | `loss-read-in-time…` line 125 (F13) | "Converse" names opposite cases in two records; known, and the claims are unchanged. |
| 12 | note | CD §1 and §8: self-concern is "a premise weaker than C's" | 07 §4.4: "placed more narrowly, not warranted" | A gloss. It holds of orders (`increasingInOwn_of_increasing`), but self-concern and C are of different types. |

No upgrade of a standing was found in 07, the dossier items read, or PLAN. Flags 1 and 2 are the two that change what a reader believes.