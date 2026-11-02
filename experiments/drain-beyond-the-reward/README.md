# The drain beyond the reward, under training by gradient (LA4)

Board item LA4, 30 October 2026. AI-written (a Claude Code session). **Stage A is frozen (3 November 2026, [its predictions](PREDICTIONS-2026-11-03.md)) and has not run; it runs on Ren's yes, in about four CPU hours with nothing to download.** The design, the season's laws (proved in Lean), the separable family's exact flow, the learners, the code's checks, the calibration and the power check are done. Stage B is not frozen: its pilot needs model downloads.

Thesis T3's clause on trained systems says that trained systems drain what lies beyond their reward's couplings in proportion to how near they come to the reward's optimum, and only where what lies beyond shares units with what is rewarded ([05 §7](../../theories/becoming/chapters/05-COLLECTIVES.md#t3)). CG1 and IN1 tested a drain beyond the reward's couplings, and the LA1 series the bridge to a stated reward, in context ([A-18](../../theories/becoming/review/ALIGNMENT.md#a-18)). No test yet varies how near a trained system comes to its reward's optimum, which is what the clause adds.

LA4 tests the clause on systems trained by gradient:
- **The learners.** Stage A uses three families of small policies: separable, feedforward and recurrent. Stage B uses two families of open-weight language models.
- **Room open.** A colony depends on the bay, which lies outside the reward with room.
- **No shared units.** The same bay with its fish uncounted, and a landing site, share no units with anything rewarded.
- **The control.** It keeps the ground's learning and removes the selection on the bay and the site in expectation, still updating them with noise.

| File | What it is |
|---|---|
| [DESIGN.md](DESIGN.md) | The season, the learners, the arms, the measures, the predictions to freeze, the rivals and the power check, what each outcome would change, the steps and what needs Ren's yes; §12 is the formal work and what it changed |
| [season.py](season.py) | The season, its exact values (the optimum, the cost of keeping the colony, the reference policies) and the exhaustive checks of what the design claims of its outcomes; standard library only |
| [exact_flow.py](exact_flow.py), [exact_flow.json](exact_flow.json) | The separable family's expected update, computed exactly by dynamic programming and checked against finite differences, ascended for each arm; the reference curves of §12 |
| [PREDICTIONS-2026-11-03.md](PREDICTIONS-2026-11-03.md) | Stage A's frozen predictions: what is frozen, what the freeze changed in the design, the run, the verdict rules, what ran before the freeze, the power check, limits and cost |
| [learners.py](learners.py), [evaluate.py](evaluate.py) | The three families, the value network, Adam and each arm's update in numpy; the measures, exact or sampled |
| [checks.py](checks.py), [calibrate.py](calibrate.py) | The code's checks (gradients, exact values, the expected update, the control, the mirror test) and the calibration on a season with no bay; outputs in `results/` |
| [run.py](run.py), [verdicts.py](verdicts.py), [analyze.py](analyze.py), [power.py](power.py) | The run (resumable, refusing to start off the frozen commit), the verdict rules, the reading, and the power check with scripted learners and the separable baseline on seeds 1000 to 1019 (`results/power-runs/`) |
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

The run itself is Ren's yes; [the predictions](PREDICTIONS-2026-11-03.md#what-is-frozen-in-brief) give its two commands.
