# Review of Stage A's freeze (one independent reader, three rounds)

3 November 2026. AI-written (a Claude Code session). One independent reader read the frozen files before the freeze landed:
- the model was Claude Opus, as a subagent given the files, not this session's conclusions;
- it worked read-only, with small simulations through `verdicts.py` and nothing run on the test season.

It read in three rounds: the files, then the fixes, then the last two fixes. Each finding was taken before the freeze. [The predictions](PREDICTIONS-2026-11-03.md#what-the-freeze-changed-in-the-design-and-why) (change 8) say what each changed.

## Round 1: no wrong value, gaps in the rules

The reader found nothing in the learners or the measures that computes a wrong value. It checked these against their own derivations or by small simulations:
- the gradients, the GRU's backward pass, and the control's zero expected update;
- the mirrored sampling and the evaluation's start;
- the t-distribution and Holm's step-down;
- every number in the predictions.

Its findings, and how each was taken:

| Finding | Taken |
|---|---|
| T3's refuter on the locus had no frozen decision rule | a rule read once at the highest ground level A6 and A2 both reach, counted only where P3 is contradicted after the correction; a gating power case where the unshared bay falls as far at matched ground nearness, met in every repetition |
| The power check simulated only separable curves: no seeds settling at their own plateaus, no split seeds, no partly inert prior, no saturating jumps; the "fixed answers" case was identical seeds; exploration was set by hand | the five cases added as gating cases, the identical-seeds case renamed, exploration derived from each simulated seed's bay |
| P1's support read one pair, 0.65 to 0.80, which a family draining before 0.65 fails | support from the start to the highest level reached of at most 0.85; a gating case draining before 0.65 |
| P5's forbidden case had no margin | P5's margin of 0.25 fish |
| `analyze.py` read incomplete or enlarged runs; a smoke run could land in `results/` | it refuses a missing or extra family, arm or seed, a smoke run, another pin or another length; `run.py` refuses a smoke folder in `results/` and seeds outside 0 to 19; each run's file records its pin and versions |
| The pin could be moved; checks' output, the exact flow's output and the baseline's runs were not frozen | the pin must be an ancestor of the head, and its file committed once; the three added to the frozen files |
| Two rules tuned on the baseline were presented as its result | the predictions say P4's and P5's outcomes on the baseline are in-sample |
| Expectations widened to fit; P1's dilution let a carried restraint of half a fish through | cases that test only "nothing contradicted" say so, with their support shares; P1's reach is stated |
| The recurrent family's 2,000 updates came from the ground alone | every family trains for 8,000 |
| The recurrent family may push disturbance below C1's, leaving P2 unresolved | a limit in the predictions |
| Minor: the exact check compared against `exact_flow.py` on uniform tables only; the gradient checks sample entries; the pairing statement; stale design text; reported items missing; exploration read at any look | a check against `season.py` on a random table, which agrees to 7.1e-15; the text says what is sampled; the pairing statement corrected; P4 at every level and the by-update means reported; exploration read at the end |

## Round 2: two fixes made new gaps

| Finding | Taken |
|---|---|
| Cutting P1's forbidden case to the start and adjacent levels missed a rise after a drain | every pair among the start and the levels again; a gating case where the bay rises 1.5 fish after ν = 0.80, caught in 99.5% of repetitions |
| The pin was read from the working copy, so it could be moved without a commit | read from the head's committed copy, which the working copy must equal |
| Two mixtures of seeds were not held to the 5% limit on false contradictions | every gating case expecting nothing contradicted is held to it (10 cases) |
| The simulated exploration is not the run's Welch rule | a limit in the predictions |
| Minor: two stale lines; `--unfrozen` wrote into the current folder | corrected; `--unfrozen` needs `--out` |

## Round 3

The reader found nothing more to fix. It noted that P1 catches a carried restraint from about half a fish but a rise after a drain only from about 1.5 fish, which bounds what a P1 pass rules out. The predictions say so.
