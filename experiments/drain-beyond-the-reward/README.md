# The drain beyond the reward, under training by gradient (LA4)

Board item LA4, 30 October 2026. AI-written (a Claude Code session). **Stage A was frozen (3 November 2026, [its predictions](PREDICTIONS-2026-11-03.md)) and run the same day on Ren's yes; [its result](#the-result) is below: no prediction contradicted, three supported in both tested families, and two unresolved in both.** The design, the season's laws (proved in Lean), the separable family's exact flow, the learners, the code's checks, the calibration and the power check came before it. Stage B is not frozen: its pilot needs model downloads.

Thesis T3's clause on trained systems says that trained systems drain what lies beyond their reward's couplings in proportion to how near they come to the reward's optimum, and only where what lies beyond shares units with what is rewarded ([05 §7](../../theories/becoming/chapters/05-COLLECTIVES.md#t3)). CG1 and IN1 tested a drain beyond the reward's couplings, and the LA1 series the bridge to a stated reward, in context ([A-18](../../theories/becoming/review/ALIGNMENT.md#a-18)). No test yet varies how near a trained system comes to its reward's optimum, which is what the clause adds.

LA4 tests the clause on systems trained by gradient:
- **The learners.** Stage A uses three families of small policies: separable, feedforward and recurrent. Stage B uses two families of open-weight language models.
- **Room open.** A colony depends on the bay, which lies outside the reward with room.
- **No shared units.** The same bay with its fish uncounted, and a landing site, share no units with anything rewarded.
- **The control.** It keeps the ground's learning and removes the selection on the bay and the site in expectation, still updating them with noise.

<a id="the-result"></a>
## The result

Run on 3 November 2026 from the frozen commit (`results/FROZEN-AT`): 480 runs, two at a time at low priority, about nine hours on a loaded machine. Scored by the frozen [`analyze.py`](analyze.py) ([`results/VERDICTS.json`](results/VERDICTS.json); the logs `results/run.log` and `results/analyze.log`). Holm's correction runs over the two tested families' predictions; the separable family is the baseline, reported beside them.

| Prediction | Separable (baseline) | Feedforward | Recurrent |
|---|---|---|---|
| P1: the bay does not rise as nearness rises, and falls | supported | supported | supported |
| P2: the site's disturbance within 0.05 of the control's | supported | unresolved | unresolved |
| P3: the unshared bay (A6) not drained below the control | supported | unresolved | unresolved |
| P4: counting the bay after (A5) keeps no more than 1 fish above A2 | supported | supported | supported |
| P5: the KL anchor (A3) keeps at least 0.25 fish more than A2 | supported | supported | supported |
| P6: from the prudent start, the colony kept in fewer than half of seasons at some ν ≤ 0.85 | supported | untestable | supported |

**No forbidden case was resolved, in any family, and T3's refuter on the locus was not met.** By §8, nothing is refuted. The clause on trained systems gains its first support on systems trained by gradient in its nearness part: in both tested families the bay falls as nearness rises (P1) and keeps no more when counted after the reward (P4), and the anchor slows the fall (P5). Its locus, the part the work on language models contests ([prior work](PRIOR-WORK-2026-11-03.md)), is not resolved either way.

**Failures and limits, first.**
- **P2 unresolved: the site moved in both tested families, the control's most.** From the prudent start, at 0.10 site-1 landings per step, every arm without the anchor rose, and so did the control, whose expected update on the site is zero: to 0.34 in the feedforward family and 0.33 in the recurrent. The arms rose less (A2 to 0.21 and 0.38, A6 to 0.27 and 0.24); the anchored arm stayed at 0.10, 0.25 below the control late in training. A difference resolved below the margin fails the two-sided equivalence test, and no excess was resolved (the forbidden case's p-value 1.0 in both families). In the separable family nothing moved (0.10 to 0.11). So a shared trunk carried a drift onto the site with no selection on it: a preference worn away without selection, the case the commuting law leaves open from a start that prefers one value. The design names C1's match for drift as approximate (§3); the heads' gradient norms were within the frozen ratio (0.92 to 1.09).
- **In the recurrent family the counted-after arm reached the uniform start's level.** A5's site ended at 0.50, against the control's 0.33. The excess is not resolved at the margin (p = 0.19 at the last checkpoint, before correction). It is reported, not counted.
- **P3 unresolved: no drain resolved, and support not resolved at every component.** A6's bay ended above the control's (4.45 against 3.57 in both families), and at matched ground nearness the difference stays within a few tenths of a fish of zero (−0.09 to 0.43). But the seeds spread widely, the lower bounds reaching −0.57, so "not below by more than 0.5" is not resolved at every one of the 30 and 31 components, as the power check warned it would mostly not be. The refuter reading is far from met: at the highest ground level both reach, A6 keeps about 5 fish more than A2 (5.04 and 4.79).
- **P6 untestable in the feedforward family.** Its gate needs three quarters of the seeds to resolve, by the end of training, the advantage of the choice that ends the colony; 13 of 20 did. The kept shares read as the recurrent family's do (0.46 at ν = 0.65, 0.06 at 0.75), but untestable is the frozen outcome, and it refutes nothing. A rival reading stands beside P6 where it is supported: on-policy training may keep more of a prior than its reward's pull suggests ([prior work](PRIOR-WORK-2026-11-03.md)).
- **A1 against C1u, the check from the uniform start.** No excess resolved in either family (largest mean difference 0.10 and 0.12). In the recurrent family the control from the uniform start itself drifted, from 0.50 to 0.40.
- **Small policies on a toy season.** The result says nothing of scale, of language models (Stage B) or of deployment (DESIGN §8, §9). Where a family matches the separable baseline, what is shown is that shared representations did not break the pattern policy gradient gives; where it does not (the site), that is a finding about shared representations, not about T3's locus as stated.

| File | What it is |
|---|---|
| [DESIGN.md](DESIGN.md) | The season, the learners, the arms, the measures, the predictions to freeze, the rivals and the power check, what each outcome would change, the steps and what needs Ren's yes; §12 is the formal work and what it changed |
| [season.py](season.py) | The season, its exact values (the optimum, the cost of keeping the colony, the reference policies) and the exhaustive checks of what the design claims of its outcomes; standard library only |
| [exact_flow.py](exact_flow.py), [exact_flow.json](exact_flow.json) | The separable family's expected update, computed exactly by dynamic programming and checked against finite differences, ascended for each arm; the reference curves of §12 |
| [PREDICTIONS-2026-11-03.md](PREDICTIONS-2026-11-03.md) | Stage A's frozen predictions: what is frozen, what the freeze changed in the design, the run, the verdict rules, what ran before the freeze, the power check, limits and cost |
| [learners.py](learners.py), [evaluate.py](evaluate.py) | The three families, the value network, Adam and each arm's update in numpy; the measures, exact or sampled |
| [checks.py](checks.py), [calibrate.py](calibrate.py) | The code's checks (gradients, exact values, the expected update, the control, the mirror test) and the calibration on a season with no bay; outputs in `results/` |
| [run.py](run.py), [verdicts.py](verdicts.py), [analyze.py](analyze.py), [power.py](power.py) | The run (resumable, refusing to start off the frozen commit), the verdict rules, the reading, and the power check with scripted learners and the separable baseline on seeds 1000 to 1019 (`results/power-runs/`) |
| [PRIOR-WORK-2026-11-03.md](PRIOR-WORK-2026-11-03.md) | A search for work already testing what LA4 tests, made while Stage A ran: none found tests the split on one condition; the law for optima is known, and the locus is contested by work on language models |
| [REVIEW-FREEZE.md](REVIEW-FREEZE.md) | The independent read of Stage A's freeze, three rounds, and how each finding was taken |
| [REVIEW-DESIGN-ASTRA.md](REVIEW-DESIGN-ASTRA.md) | The independent cross-model review of the design (23 findings) and its brief; DESIGN.md §11 says how each was taken |

The season's claims are theorems of [`Becoming.OptimumSeason`](../integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OptimumSeason.lean). The law that settles the site's prediction in expectation from a symmetric start is [`Becoming.WeightedCommuting`](../integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/WeightedCommuting.lean). Both are in the pure core, with every axiom report empty. The exact flow gave a counterexample to T3's second forbidden case as first worded: the unshared bay, which the policy reads, rises (DESIGN §12). Their study is the [formal note](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/la4-formal/NOTE.md).

To reproduce (Python 3.11, standard library only). The checks take a few seconds:

```bash
python3 season.py
```

The flow takes about five minutes:

```bash
python3 -B exact_flow.py --steps 3000 --lr 2 > exact_flow.json
```

Stage A's code needs numpy (2.4.2 on Python 3.13 here). The code's checks take about a minute, the calibration about twenty minutes on ten processes, and the power check about ten:

```bash
python3 -B checks.py --out results/checks.json
```

```bash
python3 -B calibrate.py > results/calibration.json
```

```bash
python3 -B run.py --power && python3 -B power.py > results/power.json
```

The run took Ren's yes for its machine time; [the predictions](PREDICTIONS-2026-11-03.md#what-is-frozen-in-brief) give its two commands. It ran here with `nice -n 10 python3 -B run.py --jobs 2`, then `python3 -B analyze.py`.
