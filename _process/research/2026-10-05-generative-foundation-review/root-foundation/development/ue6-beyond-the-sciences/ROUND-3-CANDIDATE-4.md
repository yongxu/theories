# UE6 round 3: candidate 4, a coupling rate for several optimizers

**AI work, 26 October 2026 (Claude Opus, scratch Lean and web search). A bounded search, not established novelty.** "Not found" means not found in this search. This round reads the following:

- [UE0's audit](../ue0-third-parts/AUDIT.md) §§7–8;
- round 1 ([ASTRA-NOVELTY](ASTRA-NOVELTY.md), item 4) and round 2 ([ROUND-2-ROOT](ROUND-2-ROOT.md));
- [`Becoming/Optimum.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Optimum.lean): `MutualBest`, `mutual_beyond`, `mutual_as_one`, the horizon and step-coupling sections (`frontier_keeps_stepwise`, `frontier_met_before_end`, `frontier_breaks_last`, `frontier_breaks_stepwise_long` and their `Web` forms), and the sections on drawers in turn (`InTurn`) and at once (`AtOnce`);
- [05 §optimum](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#optimum).

The scratch Lean is [`tree/Becoming/CoupledDrawers.lean`](tree/Becoming/CoupledDrawers.lean). Nothing was landed, claimed or committed.

## 1. The candidate, made exact

The audit's statement (§8, item 4): *at mutual best responses over a horizon, with each optimizer given `c` for each step a dependence is met, every perfect profile keeps the dependence exactly where the couplings cover the renewal forgone at the joint capacity, and breaks it within a long horizon below that rate.*

Round 1 found the statement underspecified. `frontier_keeps_stepwise` concerns one optimizer ranking whole courses. `mutual_beyond` concerns one step. The repository's horizon models of several optimizers with perfect profiles are `Optimum.InTurn` and `Optimum.AtOnce`, and the candidate is stated on them. Every hypothesis round 1 asked for is fixed as follows.

- **Optimizers.** `k` drawers, with no floor in the main results.
  - *In turn:* drawer 0 is given the level and each passes on what it leaves. What the last one leaves, `b`, stands next as `G t b`.
  - *At once:* each drawer draws from its portion, and what all leave stands next.
- **Renewal.** An arbitrary law `G` of what stands next, given what is left.
- **Dependence.** A need `m > 0` on what is left at a step. This matches `Keeps` on `OpenCourse`, where the level is what remains after drawing.
- **Coupling.** Each drawer's worth over the steps that remain is what it draws there, plus `c` for each step at which what all drawers leave meets `m` (`Coupled.paid`). The coupling is paid to every drawer, whoever restrains.
- **Terminal reward.** None: nothing is valued after the horizon. There is no discounting.
- **Equilibrium.** The existing `Perfect`, with the coupled worth (`Coupled.Perfect`, `Coupled.AtOnce.Perfect`).
  - A drawer's rule is a function of the step and of what it is given (at once, its portion).
  - At every step and from every amount, the rule must be a best response over the steps that remain, the others and the drawer's own later rules following the profile.
  - This is one-shot-deviation optimality at every state, so over a finite horizon it is subgame perfection among such rules.
- **Feasible deviations.** Leaving anything between the floor and all of what is given.
- **Pivotality.** Not assumed; the results show where it enters.
  - In turn, the last drawer of a step decides whether the need is met.
  - At once, a drawer can meet the need alone, the others drawing everything, only if its portion reaches `m`.

With `c = 0` the coupled notion is exactly the existing one: `Coupled.perfect_uncoupled`, `Perfect G low rules k 0 m N ↔ InTurn.Perfect G low rules k N`.

## 2. The literal statement is false

Two counterexamples, each a Lean theorem:

1. **In turn, the renewal forgone covered, the need broken at once.**
   - *The setting.* On the gated renewal `gatedRenewal m q`, what is left stands as it is below the need and renews by `q` at or above it. The greatest renewal is `q`, attained at every level at or above the need, so the renewal forgone a step by keeping is `0`, and every `c` covers it.
   - *The theorem.* `Coupled.gated_threshold`, first clause, by `Coupled.drains_below`: with `k ≥ 2` and `c < m`, every perfect profile has every drawer leave nothing at every step before the horizon, from every amount.
   - *The contrast with one drawer.* By `Coupled.one_keeps_first`, with `c < m` and `0 < c + q`, every perfect profile of one drawer over two steps leaves at least the need at the first step. `Coupled.one_perfect` shows such a profile exists.
   - *Together.* `Coupled.one_keeps_several_drain` states both halves. One drawer keeps the need where several in turn drain it.
2. **At once, the joint capacity reaching the need, the need broken at every rate.**
   - *The setting.* Two shores: the first drawer reaches at most `p` of the level, the second at most `p` of the rest, `p < m ≤ p + p`, and the level is left as it is (`G t x = x`).
   - *The theorem.* `Coupled.AtOnce.Shores.drain_perfect`: for every `c` and every horizon, drawing everything is perfect and the need is met at no step. Where both leave all they reach of `p + p`, what is left is `p + p`.
   - *The general law.* `Coupled.AtOnce.unpivotal_drain_perfect`: where every portion lies below the need and no portion returns more than one for one, the drain is perfect for every `c`.

So no rate, read off the renewal or the joint capacity, makes every perfect profile keep the dependence.

## 3. What survives, exactly

**In turn (`k ≥ 2`, no floor, `0 < m`, every horizon `N`):**

| Lean | Hypotheses | Conclusion |
|---|---|---|
| `Coupled.drains_below` | `c < m`; any `G` | every perfect profile: every drawer leaves `0` at every step before `N`, from every amount |
| `Coupled.drain_perfect` | `c ≤ m`; any `G` | drawing everything is perfect |
| `Coupled.kept_above` | `m < c`; the gate | every perfect profile: every drawer leaves `keep m a` (the need if `m ≤ a`, else `0`) |
| `Coupled.keeping_perfect` | `m ≤ c`; the gate | that profile is perfect |
| `Coupled.kept_levels` | `G` at or above the need meets it; all keep; start `s ≥ m` | the level meets `m` at every step to `N`, and what is left at each step is exactly `m` |
| `Coupled.gated_threshold` | `gatedRenewal m q`, any `q` | the four rows above together; at `c = m` both profiles are perfect |

The gate has three parts:

- below the need, what stands next is below it (`x < m → G t x < m`);
- at or above the need, what stands next meets it (`m ≤ x → m ≤ G t x`);
- what stands next from nothing, with the need, is at most what stands next from the need (`G t 0 + m ≤ G t m`).

**The strongest exact form.** With several drawers in turn the dependence is kept exactly where the coupling a step exceeds the need, and broken at the first step, at every horizon, where it is below the need. The renewal forgone, the renewal law and the joint capacity do not enter. The reason is visible in the proof:

- The last drawer of a step decides whether the need is met.
- Whatever it leaves, it draws nothing later: drawer 0 draws first at every later step.
- So its keeping pays it `c` against the `m` it must leave, and what any other drawer keeps passes through it.

**Against one drawer.** One drawer ranking whole courses keeps the need to the horizon's last step wherever `r < q + c` (`Web.frontier_met_before_end`), and breaks it at the last step alone where `c < m` (`Web.frontier_breaks_last`). Under the gate the renewal forgone is below the need, so above the need the one and the many keep alike. Below it, the end reaches back at once for the many and not for the one. So `mutual_as_one`, which says several optimizers drain one step as one would with their joint capacity, does not extend to step couplings over a horizon. This comparison crosses two models: `InTurn` with one drawer and `OpenCourse` are not proved to correspond. `one_keeps_first` is the comparison inside one model, over two steps.

**At once (`0 < m`):**

- **`Coupled.AtOnce.drain_perfect_iff`.** The drain is perfect exactly where, for every drawer and every amount `b` of its portion it alone might leave:
  - at the last step, `paid c m b ≤ b`;
  - before it, `paid c m b + portion d (t+1) (G t b) ≤ portion d (t+1) (G t 0) + b`.
- **The reason.** Against the others drawing everything, a drawer meets the need only by leaving all of it itself.
- **`Coupled.AtOnce.drain_perfect_iff_reach`.** Where no portion of what stands next depends on what is left, the drain is perfect exactly where `c ≤ m` wherever a portion reaches the need. Where no portion reaches it, the drain is perfect at every `c`.

The at-once side is only half characterized: which profiles are perfect when the drain is not is left open. Where several drawers can each meet the need, free riding makes many profiles possible.

## 4. Lean status

- **Module.** `Becoming.CoupledDrawers`, at [`tree/Becoming/CoupledDrawers.lean`](tree/Becoming/CoupledDrawers.lean).
  - 1,040 lines; sha256 `6cd1f0fbbd26682c99e01973196776d41bb4f0e2549ff8411b87e04deb3e0979`.
  - It imports only `Becoming.Optimum`, a core module, and reuses `InTurn.pass`, `InTurn.pass_through`, `InTurn.leaves_floor`, `InTurn.levels`, `AtOnce.sumTo_set` and `AtOnce.steps_after`.
- **Build.** Run from the `lean/becoming` folder as `python3 -B scratch_build.py <DEV>/tree`. Of 45 modules, 44 were reused from the cache; `Becoming.CoupledDrawers` and its axiom audit ran, with no error or warning.
- **Axiom audit.** 72 declarations, 57 of them theorems, every one with an empty report (`with_axioms: {}`). It was rerun directly for the 14 theorems named above, each reporting "does not depend on any axioms". The log is [`round-3-build.log`](round-3-build.log).
- **What this is not.** It is a working build, not a checker receipt. The environment audit, the controls and the prelude-only compile run only in `check_becoming.py`.
- **Modelling choices the laws depend on**, stated here because the empty axiom report says nothing about them:
  - discrete steps and whole amounts;
  - the in-turn order, with drawer 0 first at every step;
  - rules that read only the step and what is given (at once, one's own portion);
  - no discounting and no value after the horizon;
  - the need read on what is left;
  - no floors;
  - the gate, for the keeping side.

  Without the gate, a stock below the need can regrow past it, and whether several drawers above the need keep it is not settled here.

## 5. Literature

**Searched:**

- dynamic common-pool games with per-period conservation payments, or subsidies tied to keeping the stock above a threshold;
- Markov-perfect and subgame-perfect equilibria of resource games with thresholds;
- payments for ecosystem services in differential and difference games;
- the safe minimum standard in dynamic games;
- Pigouvian and stock-dependent taxation in dynamic oligopoly;
- threshold (step-level) public goods, simultaneous and sequential;
- dynamic contribution games;
- collective threshold rewards in common-pool experiments;
- performance payments.

**No paper stating the exact theorem was found.** The closest prior statements, nearest first:

1. **Threshold public goods, simultaneous.** Palfrey and Rosenthal (1984), *J. Public Econ.* 24(2):171–193, "Participation and the provision of discrete public goods: a strategic analysis" ([record](https://resolver.caltech.edu/CaltechAUTHORS:20160303-114154701)). Efficient provision is an equilibrium, alongside inefficient ones. Where more than one contribution is needed, nobody contributing is an equilibrium because no single player is pivotal; that is standard in this literature and taken from prior knowledge, not re-read. `AtOnce.unpivotal_drain_perfect` and `drain_perfect_iff_reach` are that logic, step by step over a horizon. **A specialization.**
2. **Threshold public goods, sequential.**
   - Erev and Rapoport (1990), *J. Conflict Resolution* 34(3):401–425, "Provision of step-level public goods" ([record](https://ideas.repec.org/a/sae/jocore/v34y1990i3p401-425.html)): sequential contributions, where the later movers are pivotal.
   - Bagnoli and Lipman (1989), *Rev. Econ. Stud.* 56(4):583–601 ([record](https://ideas.repec.org/a/oup/restud/v56y1989i4p583-601..html)).
   - Admati and Perry (1991), *Rev. Econ. Stud.* 58(2):259–276, "Joint projects without commitment" (prior knowledge).

   The in-turn threshold `c` against `m` is backward induction with a pivotal mover, as in these papers. What the coupled model adds is the stock and the zero continuation stake of the keeper. **A specialization in kind.**
3. **Known thresholds in a dynamic commons.**
   - Diekert (2017), *J. Public Econ.* 147:30–49, "Threatening thresholds? The effect of disastrous regime shifts on the non-cooperative use of environmental goods and services" ([working paper](https://swopec.hhs.se/osloec/abs/osloec2015_012.htm)). Agents can coordinate on a cautious equilibrium at a known safe level. A Pareto-inferior equilibrium depleting the resource at once can be self-fulfilling. For sufficiently low safe values, immediate depletion is the only equilibrium.
   - Barrett (2013), *JEEM* 66(2):235–250, "Climate treaties and approaching catastrophes" ([record](https://ideas.repec.org/a/eee/jeeman/v66y2013i2p235-250.html)). A known threshold turns the dilemma into coordination where avoidance is worth enough.

   These are the closest dynamic statements: keeping at the threshold against immediate depletion, decided by the worth of keeping against the one-step gain. **Different model, same mechanism.**
4. **Instruments implementing the optimum in Markov equilibrium.**
   - Benchekroun and Long (1998), *J. Public Econ.* 70:325–342 ([CIRANO version](https://cirano.qc.ca/en/summaries/97s-21)): a stock-dependent tax rule implementing the socially optimal path in a dynamic oligopoly.
   - Bisceglia (2020), *J. Econ.* 129(1):1–31 ([record](https://ideas.repec.org/a/kap/jeczfn/v129y2020i1d10.1007_s00712-019-00662-y.html)): a linear Markov output tax, affine in the stock, implements the social optimum in the feedback Nash equilibrium of a common-resource oligopoly. It is stock-independent under monopoly and cannot be defined in a duopoly.

   These design an instrument to implement an optimum; there is no threshold and no fixed per-step coupling. **Different.**
5. **The dynamic commons and backward induction.**
   - Levhari and Mirman (1980), *Bell J. Econ.* 11(1):322–334 ([record](https://ideas.repec.org/a/rje/bellje/v11y1980ispringp322-334.html)).
   - Dutta and Sundaram (1993), *Econ. Theory* 3(3):413–426 ([record](https://ideas.repec.org/a/spr/joecth/v3y1993i3p413-26.html)).
   - Mitra and Sorger (2014), *Econ. Theory* ([paper](https://pages.nyu.edu/debraj/TapanMitra/Papers/Mitra-Sorger%20ET-2014.pdf)): extinction in Markov-perfect equilibrium, with a threshold on growth against the number of players.
   - Dockner, Jørgensen, Van Long and Sorger (2000), *Differential Games in Economics and Management Science*, Cambridge, chs. 4 and 12; the chapter contents were not verified.
   - Selten (1978), *Theory and Decision* 9:127–159, for unravelling from the horizon (prior knowledge).
6. **Payments for outcomes and collective threshold rewards.**
   - Zabel and Holm-Müller (2008), *Conservation Biology* 22(2):247–251 ([paper](https://www.amherst.edu/media/view/105092/original/Zabel%2Band%2BHolm-muller%2B2008.pdf)): payments per certified carnivore offspring, outcome-based but a principal–agent scheme.
   - Tambunlertchai and Pongkijvorasin (2020), *Environ. Econ. Policy Stud.* 22(4):537–554 ([record](https://ideas.repec.org/a/spr/envpol/v22y2020i4d10.1007_s10018-020-00268-5.html)): collective threshold rewards in a common-pool experiment; only the title was read.
   - Cvitanić and Georgiadis (2016), *AEJ: Micro* 8(4):309–342 ([paper](https://www.kellogg.northwestern.edu/faculty/georgiadis/EfficiencyDCG.pdf)): threshold-triggered payments inducing efficient effort in Markov-perfect equilibrium.

## 6. Verdict

**Candidate 4 does not survive as a result no field states.**

1. **The literal statement is false.** Two Lean counterexamples, §2.
2. **The corrected exact statement is not found verbatim, but a specialist would foresee it.** In turn, it says that the keeping threshold is the need, not the rate. At once, it says that without a pivotal drawer the drain is perfect at every rate. A resource economist or dynamic-games specialist would derive it on reading the model:
   - Whoever decides whether the threshold is met must be paid, each step, more than the one-step gain from breaking it.
   - In the in-turn arrangement that drawer has no stake in the stock's future, so the gain is the need itself and the end unravels.
   - Without a pivotal player, zero provision is an equilibrium at any reward.

   These are the logics of items 1, 2, 3 and 5 of §5.
3. **What is the theory's own.** The exactness (an iff, with witnesses on both sides, for every renewal law below the need), the empty axiom report, and the contrast with `mutual_as_one`. As round 2 put it, this makes the join stringent, not new.

**The search, complete either way.** Candidate 4 was the last of the audit's eight candidates that round 1 could not locate. With it settled, no candidate from the audit (round 1), the root's laws (round 2) or here passes "a specialist would not foresee it". The bounded search for results no neighbouring field states ends with none found. UE0's verdict stands: the theory reaches farther than each framework it contains, not farther than the sciences taken together.

**A correction for the theory's own text, apart from novelty.** Any reading that several optimizers keep a dependence where a step coupling covers the renewal forgone is wrong for drawers in turn. They need the coupling to exceed the need.

- This bears on the audit's §8, item 4, which should not be cited as a candidate.
- It also bears on any T3 or AJ text that carries the one-optimizer step-coupling law (`frontier_keeps_stepwise`) over to several optimizers.

That is for the owners of those texts to weigh; nothing was changed here.

## 7. Boundary

- One AI session.
- **Literature.**
  - Verdicts rest on abstracts, records and prior knowledge, as marked.
  - Full texts were not read for Erev–Rapoport, Admati–Perry, Diekert (the PDF did not extract), Marx–Matthews, Dockner et al. or Tambunlertchai–Pongkijvorasin.
  - A specialist could find a closer statement, which would only strengthen the verdict.
- **Not proved.**
  - The keeping side without the gate.
  - Which profiles are perfect at once when the drain is not.
  - That the drain is the only perfect profile in the two-shores witness.
  - Any correspondence between `InTurn` with one drawer and `OpenCourse`.
- **Not tested.** No prediction was frozen or tested. The laws here quantify over every renewal law and forbid, in turn, a perfect profile keeping the need with `c < m`, and, under the gate, one breaking it with `c > m`.
