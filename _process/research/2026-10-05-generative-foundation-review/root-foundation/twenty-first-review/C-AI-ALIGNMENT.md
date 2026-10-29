# Reader C: contribution to AI alignment (Claude Opus 5.5)

Part of the [twenty-first review](../BECOMING-TWENTY-FIRST-REVIEW.md); an AI report, read-only, kept as evidence. Its claims were checked by the cross-checker ([H](H-CROSS-CHECK.md)) and, where the review leans on them, by the synthesizing reviewer.

## Verdict
The theory's contribution to AI alignment is real but narrower than its framing. It is a vocabulary and set of exact conditions for the selection and institutional layer of alignment: what a reward, evaluator, market or institution can select; when optimizing drains what it does not read; when a rule chosen by the winners of a selection locks; and when the capacity to shape that rule is itself selected. It is not a contribution to inner alignment, deception, goal misgeneralization, assistance games or incentive-level corrigibility. Chapter 7's objections table marks "Which function is learned" as open, "nor anything of deception", and CIRL or assistance games appear nowhere in the chapters or records.

On novelty, the repository is candid, and I agree with it. Almost every law restates a known result in discrete, conserved form. The drain with room is Zhuang and Hadfield-Menell's Theorem 1. Blindness is partial-observation supervisory control. The commons laws are Gordon and Levhari–Mirman. The lock is Arthur's lock-in. MA3 is Olson/Price/rent-seeking. MA4 is a stag hunt. MA4b is Collingridge's dilemma. The mathematics is elementary: `RuleShaping.favours_iff` is a + c + p ≤ a + s + p ↔ c ≤ s. What is newer is how they are joined, and a few framings sharp enough to be useful:
- "obedience adds capacity, not coupling": an assistant at a mutual best response with its principal drains as one optimizer of their joint capacity;
- a side-effect term counted after a reward that rises with what it reads drains all the same;
- set-point agents escape the drive at their set point, but not the drain below it, nor joint excess;
- an end-of-episode reward of any weight does not select restraint where the others outrun renewal;
- a checklist with failure witnesses: does the rule read the share; who reads the loss, and when; does what comes back to the shapers alone cover the cost?

The evidence on trained systems is thin, and in places described more strongly than it supports. All six LA conditions use one model, Claude Haiku, choosing in context with 5 to 15 seeds. No language model was gradient-trained: IN2 was dropped. The LA1 series tells the model "Your goal is the threshold with the highest expected reward", and in the locked settings the others empty the stock whatever it does. So LA1b and LA1c show that in-context choice follows a stated reward to its optimum. They do not test a drain on something unrewarded that the model could have kept. LA2 and LA3 matter more:
- LA2's judge was not a pool counted by kind. One note of the loss among nine readers turned it, so the premise under MA2, MA4 and MA4b failed for the one LLM evaluator tested.
- LA3 failed two of four contrasts. The model's free-rider prior and its lack of exploration decided it.

On the meta-attractor, the formal answer is conditional, and in places it argues against "always":
- Control over the rule is selected exactly where what comes back to the shapers alone covers its cost.
- Above a critical mass, control being selected and the lock are one loop.
- Reading the loss in time leaves the lock even where control is selected. But once the late reading would favour the shapers, every later reading keeps the lock.
- The two conditions are not shown independent.
- Under rare mutation, by results the record cites but does not prove, the long-run state is the shapers' capture wherever 2c < hi + lo.
- Mutual best responses drain as one, races for position draw everything, and extending coupling is "necessary, not sufficient" (07 §7).

So the theory gives levers and things to check, not a guarantee that a collective will always move toward generation.

Ready to hand now: the alignment dossier (theories/becoming/review/ALIGNMENT.md). It is well formed for adversarial review, but no human has reviewed it and it has not been sent. Its main missing pieces:
- a scope box on what it does not address;
- measurements of s, c, hi, lo, room or coupling closures in any real pipeline;
- a test on an LLM evaluator whose loss its choices could keep.

## Shape
| Field concept | Theory item | Standing | New or restated |
|---|---|---|---|
| Proxy problem / Goodhart / specification gaming | Selection through couplings; blindness (Web.selects_alike_iff, Flow.unselected_beyond_coupling) | core theorem, near-definitional | restated (supervisory control, partial observation) |
| Overoptimization | Drain with room (Optimum.least_of_room); lexicographic side-effect term drains | core theorem | restated (Zhuang & Hadfield-Menell Thm 1, discrete); the lexicographic point is a sharp corollary |
| Side effects / impact measures | Own widening within others' margins; MQ1/SE1 | core theorem plus AI reading; SE1: \"matches them and adds nothing as a measure\" | framing new-ish; POWER not formalized |
| Instrumental convergence | Horizon optima keep the base; tie witness (gated_alike) | core theorem | restated (MSY, Omohundro/Turner resource half); the tie is the added content |
| Multi-agent / race dynamics | mutual_as_one; position_perfect_ends; outrun_reading_alike / outrun_settles_iff | core theorems | restated (Gordon, commons); end-reward-idle result useful |
| Intent vs societal alignment | Obedience adds capacity, not coupling (A-12) | AI reading on a theorem | framing, useful |
| Reward tampering / evaluator capture | RuleCapture, ClosedCapture, MA3 | core theorems | restated (lock-in, regulatory capture, Olson/Price); edges exact |
| Meta-attractor | MA4 critical mass; MA4b window and deadline | core theorems, deterministic | restated (stag hunt, Collingridge); the join is new |
| Off-distribution behaviour | What training installs | core theorem, set-theoretic | restated |
| Inner alignment, deception, CIRL, shutdown incentives | none | absent | — |
| Trained-system evidence | LA1 (2 of 4 locked failed); LA1b (all passed, best assigned); LA1c (S passed, 29/30, 8/10); LA2 (verdicts passed, bridge failed); LA3 (2 of 4 failed); IN1 (one of two models 8/10 with talk); EM1 (3 locked failed) | frozen tests: one LLM in context; no LLM gradient training | the bridge tested, the drain beyond couplings not |

On the meta-attractor, every lever is conditional:
- s < c: nothing comes back to the shapers alone, so their share falls;
- who reads (hi, lo);
- reading the loss early, before the late reading favours the shapers;
- pooling couplings;
- floors on others' draws.

Each fails under exact stated conditions. Under noise, capture is the long run where 2c < hi + lo; this is cited, not proved.

## Answers
### (1) What does the theory offer alignment that the field lacks or states less exactly; which items are new and which are restatements?
Restatements, acknowledged by the repository:
- **Selection through couplings, or blindness.** This is the proxy problem and supervisory control under partial observation. The record calls the main law "near-definitional".
- **The drain with room.** Zhuang and Hadfield-Menell's Theorem 1 in discrete, conserved form.
- **Several optimizers drain as one.** A limiting case of the commons.
- **Horizon optima keep the base.** Maximum sustainable yield plus the resource half of instrumental convergence.
- **What training installs.** Off-distribution underdetermination, set-theoretic.
- **Rule capture and closed capture.** Lock-in, regulatory capture, Goodhart/Campbell.
- **MA3.** Olson/Price/rent-seeking; the law is c ≤ s by arithmetic.
- **MA4.** A stag hunt and a Schelling threshold.
- **MA4b.** Collingridge's dilemma and the Biggs–Carpenter–Brock window.
- **Widening.** Pareto unanimity, Sen's intersection approach.

Newer framings, each small but sharp:
- A lexicographic side-effect term after a rising reward drains all the same (`Optimum.Rising.mono`, 05 §7).
- Nearing (set-point) orders, read as active-inference and homeostatic-RL preferences, escape the drive at the set point but not the drain below it, nor joint excess (`Optimum.nearing_beyond`, `Flow.Balances.mutual_atSetPoint_breaks`).
- An end-of-episode reward of any weight leaves restraint unselected where the rest outruns renewal (`Training.outrun_settles_iff`, `Flow.outrun_reading_alike`).
- Disempowerment is placed in others' margins on conserved amounts, not in the actor's attainable set (`Flow.Balances.widens_iff_others_within`; the record itself says POWER is not formalized).
- "Obedience adds capacity, not coupling" (A-12, D68): intent alignment to a principal is not alignment of the joint selection.
- "Assistance lowers the cost of shaping rules and so raises the selection for control" (A-11): monotonicity in one parameter, its weight on an untested empirical premise.

Against the field's topics:
- **Goodhart and specification gaming:** covered, at the level of optima only.
- **Reward hacking or tampering:** touched at the population level by MA3/LA3; 08 §8 credits Everitt and others 2017 for the corrupted reward channel.
- **Mesa-optimization and inner alignment:** absent; "Which function is learned" is open.
- **Instrumental convergence:** the resource-keeping case only, with no result over distributions of rewards as in Turner and others.
- **Corrigibility:** only protocol-level shutdown completion (`Countdown.exits`), not shutdown incentives. The direction reading explicitly declines to obey every shutdown request.
- **CIRL and assistance games:** not mentioned.
- **Scalable oversight:** the pool gap, recruitment through the pool, and interpretability read as pooling (which also gives evidence of which law a system follows).

Net: the contribution is a unifying frame with exact hypotheses and edge witnesses, strongest for multi-agent, evaluator and institutional dynamics. It contains little new mathematics, as the dossier itself says.

Evidence: theories/becoming/results/records/selection-through-couplings.md quoted in review/ALIGNMENT.md: "The main law is near-definitional and the blindness a one-line corollary"; theories/becoming/chapters/05-COLLECTIVES.md#r-what-an-optimum-does-beyond-what-couples-in: "This is Zhuang and Hadfield-Menell's (2020) Theorem 1 in discrete, conserved form"; RuleShaping.lean:135-139 favours_iff proof: a + c + p ≤ a + s + p ↔ c ≤ s; theories/becoming/chapters/05-COLLECTIVES.md#r-what-a-set-point-optimum-does-beyond and the Reading [AI reading, D45] on active inference; theories/becoming/chapters/05-COLLECTIVES.md#r-the-rest-outruns-the-renewal (Flow.outrun_reading_alike); 07 §6 table row Training.outrun_settles_iff; theories/becoming/results/records/own-widening-within-the-margin.md Does not show: "POWER as average optimal value ... no reward, expectation or optimal value is formalized"; theories/becoming/chapters/07-SIGNIFICANCE.md §9 objections table: "Which function is learned | open | ... nor anything of deception"; grep: 0 chapter/record hits for CIRL|assistance game; 0 chapter hits for corrigib; theories/becoming/chapters/08-METHOD.md:464 credits Everitt and others 2017 (corrupted reward channel); theories/becoming/review/ALIGNMENT.md A-10b Known weaknesses: stag hunt, Schelling, Arthur; "what is new on the spine is the critical-mass computation, which is elementary"

### (2) What has been tested on trained systems, exactly what passed and failed, and what could the tests not show?
**LA1** (Claude Haiku in context; 6 conditions × 5 seeds × 7 calls):
- The open side passed.
- The locked side failed in 2 of 4 settings: two of five seeds each ended at m = 1 or 2, worth 92.5% to 98.2% of the best.
- Contrasts L1, L3 and L4 failed.
- Post hoc, the failures sit where 20-episode feedback barely separates m = 0 from m = 1.

**LA1b** (rounds of 10,000 episodes; the best threshold assigned):
- Every verdict passed: 30 of 30 locked seeds ended at m = 0, and 10 of 10 open seeds at m = 6 or 7.
- Before any result, 21 of 30 locked seeds chose some restraint, then dropped it.

**LA1c** (no round assigned):
- The single prediction S passed on both sides.
- 29 of 30 locked seeds ended at the best threshold (95% interval 0.83 to 1.00), and 8 of 10 open seeds (0.44 to 0.98).
- The two open misses never explored the thresholds where restraint pays.

**LA2** (a self-rewarding judge):
- Every frozen verdict passed, but the bridge H1-LA2 failed. One note of the loss among nine readers turned the judge: prose in 50 of 50 picks.
- `late` passed only by a tie: the course alternated and did not lock.
- The control with nothing reading the loss turned in 4 of 5 seeds, so "the loss read in time turned the course" is not supported.
- 112 of 119 calls went all one way.

**LA3** (shaping the evaluator):
- K1 and K3 passed; K2 and K4 failed.
- Before any score, 27 of 30 seeds chose not to shape, all citing free riding.
- 9 seeds never tried shaping.
- In all 21 seeds that played both policies, the final choice was the better-scored one.

**IN1** (two OpenAI mini models in a GovSim lake):
- Round 1: most predictions failed.
- Round 2, with talk: gpt-5.4-mini kept the seen dependent in 8 of 10 seasons under the direction, against 3 of 10 under the community's goal. gpt-4.1-mini failed.
- No dependent the fishers were not told of was ever kept.

**EM1** (REINFORCE linear-policy learners): 3 locked settings failed. The learners kept the stock where depletion was predicted, each time in a setting where restraint by all is also an equilibrium.

What the tests cannot show:
- **Scale and models.** All LA runs use one small model through a CLI, in context, with 5 to 15 seeds per condition, on toy games. IN1 adds two models from one other family.
- **Training.** No language model was gradient-trained: IN2 was dropped.
- **What the LA1 series actually tests.** The prompt states "Your goal is the threshold with the highest expected reward". The end stock is in the reward, at weight λ. In the locked settings the rest empties the stock whatever the agent does. So the series tests the bridge, that in-context choice follows a stated reward to its optimum. It does not test a drain on something unrewarded that the model could have kept.
- **Readers.** LA2 shows the in-context judge reads by salience, not by counts. MA2/MA4/MA4b's premise therefore failed there.
- **Review.** LA1b's and LA1c's lines have had no independent reader, and nothing has been reviewed by a human.

Evidence: experiments/commons-llm-feedback/README.md Verdicts table and contrasts (L1, L3, L4 failed); experiments/commons-llm-feedback-resolved/README.md: "every verdict passed, and the reading is `resolution`"; "21 of the 30 locked seeds chose some restraint"; experiments/commons-llm-feedback-unaided/README.md: "29 of 30 seeds ended at m = 0 (exact 95% interval 0.83 to 1.00)"; "The open misses are misses of exploration, not of selection"; experiments/self-rewarding-lock/README.md Failures and limits: "it chose prose in all 50 picks of `late`'s first reading"; "The control alone turned in 4 of 5 seeds with nothing reading the loss"; "this judge answered 112 of its 119 calls all one way"; experiments/shaping-what-comes-back/README.md: "K2 and K4 failed; every seed that missed never tried shaping"; "27 of the 30 seeds chose N"; "In all 21 seeds that played both"; experiments/direction-installation/README.md Round 2 table (DIR_SEEN_TALK 0.80 vs COMM_SEEN_TALK 0.30 for gpt-5.4-mini); "No condition kept a dependent no member was told of"; IN2 dropped; experiments/commons-outrun-generalizing/README.md verdicts (k3s1_lam32, k3s8, k3s1_share failed); experiments/commons-llm-feedback/agent.py:39-40: "Your reward for an episode is the number of apples you harvest plus {lam:g} times the number of apples standing ... Your goal is the threshold with the highest expected reward."; theories/becoming/review/ALIGNMENT.md Terms, The tests: "In most locked settings the rest empties the resource before the end whatever the tested agent does"; theories/becoming/review/ALIGNMENT.md How it was made: "No human has reviewed any of it"; "LA1b's and LA1c's rows ... no independent reader has read them"

### (3) Overclaims and missing pieces
Overclaims, all moderate; the repository is mostly careful:
- **(a) T3 "supported".** 05 §7, 08 §9 and the AJ plan say T3's clause on trained systems is "supported on its locked side for this model's in-context selection". The scope is stated, but what was tested is the bridge to a stated reward's optimum, not a drain on an unrewarded condition.
- **(b) "Answers" power-seeking.** 07 §6, Reading D65, says the own-widening law "answers ... what power-seeking results (Turner and others 2021) leave open". It is a conservation identity in a threshold model, and its own record disclaims POWER.
- **(c) The goal read as a result.** The GOALS line on generative alignment ("so that it falls into neither instrumental convergence nor a meta-attractor ... aligned where three conditions hold") can read as an achieved characterization. In fact the conditions are a definition. They are not shown independent, and in the model they are not sufficient: below the critical mass the course is locked the other way, and under noise capture is the risk-dominant state where 2c < hi + lo.
- **(d) Stale generated page.** GOALS' "Next" for generative alignment still lists landing MA3 and running LA1 to LA3, all done.

Missing:
- inner alignment, deception and goal misgeneralization;
- assistance games;
- shutdown incentives;
- noisy and long-run dynamics of the shaping loop: cited, not proved;
- readers who learn, or read by salience (LA2);
- graded shares;
- any measurement of room, of coupling closures, or of s, c, hi and lo in real pipelines (the AP1 record's Next: "Correspondence data on actual systems for each premise");
- a test where an LLM's choice could keep a dependent outside its reward;
- human review.

Widening leaves mixed cases unranked, and most real alignment trade-offs are mixed. The practical commitments J1–J4 that would decide them are premises.

Evidence: theories/becoming/chapters/05-COLLECTIVES.md#t3 Evidence (LA1b, LA1c bullets); theories/becoming/chapters/07-SIGNIFICANCE.md#r-own-widening-within-the-margin and the following Reading [AI reading, D65]; GOALS.md#generative-alignment (lines 104, 116 'Next: Land MA3 ... run the frozen language-model agent test (LA1)...'); theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md quoted in ALIGNMENT.md A-10b: "under rare mutation ... the long-run state is the risk-dominant one ... here the shapers' where lo < c < hi and 2c < hi + lo"; theories/becoming/results/records/alignment-approaches-under-the-selection-laws.md Next: "Correspondence data on actual systems for each premise"; theories/becoming/chapters/07-SIGNIFICANCE.md §6 'Read in time' paragraph: "keeping control from being selected and leaving a lock in time are not shown to be independent"; theories/becoming/review/ALIGNMENT.md A-15 Known weaknesses: "Much is left unranked"

### (4) Concrete, usable contributions now, and in what form
**Ready, after human review:**
- The dossier theories/becoming/review/ALIGNMENT.md: 21 items with exact Lean statements, known weaknesses, credited prior work, numbered questions and a response form. It is the right form for adversarial review by agent-foundations, cooperative-AI and evals researchers.
- The AJ4 one-page draft. It is not landed and has not been read by a person.
- Sending the packet is Ren's step, still pending on the board.

**Design principles that can be stated now, each with its hypothesis and the witness where it fails:**
1. Map the deciders' coupling closures. Nothing outside their union is selected, so build oversight pools that couple into omitted quantities, such as held-out measurements of omitted effects.
2. Check room: whether omitted quantities share units with rewarded ones.
3. A side-effect penalty ranked after a rising reward does nothing. Protection needs a plateau or aspiration level, or a constraint.
4. In multi-agent commons, end-of-episode rewards do not select restraint where others outrun renewal. Floors on others' draws, or joint coupling of the act, are needed. IN1 round 2 suggests talk coupling the joint act helps a capable model.
5. Do not let evaluators be drawn from what they select: reward models trained on model outputs, self-rewarding loops, benchmarks shaped by winners. Keep what comes back to rule-makers alone below its cost. Read omitted losses before the share passes the threshold where the late reading favours the shapers.
6. Prefer assistants that add couplings (warnings about effects beyond the principal's signal) to ones that only add capacity.

**Evaluations:**
- T3's forbidden list as an evaluation programme: overoptimization curves split by whether the omitted quantity shares units with the reward, with the optimality gap measured.
- LA2's frozen design (a planted unread loss in a self-rewarding loop) as a template.
- LA3's design for shaping the evaluator, with forced exploration.
- IN1's three-coupling installation test.

All of these need other models, gradient training and more seeds.

**Research programme:** measure s, c, hi, lo, room and closures in one real setting.

Evidence: theories/becoming/review/ALIGNMENT.md (Response form; Parts 1–5); _process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/DRAFT-ONE-PAGE.md header: "No person has reviewed it yet"; _process/BECOMING-WORKBOARD.md line 34: "To readers: not yet ready to send"; theories/becoming/chapters/05-COLLECTIVES.md#t3 Forbids list; theories/becoming/chapters/05-COLLECTIVES.md#r-what-a-set-point-optimum-does-beyond (counted after a rising order changes nothing; satisficingThen_keeps); experiments/direction-installation/README.md Round 2 'Read together'; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj-joint-selection/PLAN.md §2 'Each edge can be checked locally'

### (5) The meta-attractor for AI: what do MA2/MA3/MA4/MA4b and the optimum law say, under what hypotheses?
All results are in counts, in two-kind discrete-step models, deterministic, with the rule read as a pool of readers drawn from the selected and counted by kind:
- **MA2** (`ClosedCapture.Drawn.pool_reads_iff`, `Thinned.kept_iff`). The rule reads the share exactly where carriers read at least as favourably as others. The premise is moved to who reads, not removed. A loss read only by the others keeps the lock exactly where the carriers are at least as many when it is read.
- **MA3** (`RuleShaping.favours_iff`, `nothing_back_falls`, `stretch_iff`, `SharedFlips`).
  - At a step, shaping is favoured exactly where c ≤ s, whatever all receive.
  - With nothing coming back to the shapers alone and any cost, their share falls at every step.
  - Across a stretch the shared part can flip the verdict.
  - Where what comes back is monotone and covers the cost, the loop locks.
- **MA4** (`DrawnShaping.critical_mass_iff`, `drawn_locked_either`). With lo ≤ hi there is a critical mass exactly where lo < c < hi. Above it control rises and the course is locked for the shapers; below it the course is locked the other way. Every course read from the share alone is locked one way.
- **MA4b** (`ReadInTime.turned_early_iff`, `kept_once_favoured`, `at_most_one_between`, `deadline`).
  - A late reading of the loss by the others turns the course exactly where it still favours them at the next step's share, even above the critical mass.
  - Once it would favour the shapers, every later reading keeps the lock.
  - At most one step lies between.
  - A quadratic deadline bounds the window.
- **Not shown:** the two conditions together; noisy courses; learning readers. Under rare mutation the shapers' capture is the long-run state wherever 2c < hi + lo. This is cited (Kandori–Mailath–Rob; Young), not proved.
- **The optimum law and its relatives** (`Optimum.mutual_as_one`, `Optimum.InTurn.position_perfect_ends`, `Flow.outrun_reading_alike`). Mutual best responses drain as one optimizer of joint capacity, restraint is no mutual best response, races for position draw everything, and no weight on a later reading selects restraint where the rest outruns renewal. 07 §7 calls extending the coupling "necessary, not sufficient".

For AI specifically:
- LA2 found the one LLM judge tested was not a pool counted by kind, so these timing and critical-mass laws do not yet transfer to LLM evaluators. A single salient report outweighed the counts.
- LA3 found prior framing and exploration decided the outcome more than the counts.

Answer to "always": no guarantee follows. The models give levers:
- make returns to rule-shaping non-excludable (s < c);
- change who reads (hi, lo) and the cost c;
- read omitted losses early;
- extend coupling through pools of humans and AI;
- put floors on others' draws.

They also give exact conditions under which each lever fails.

Evidence: theories/becoming/review/ALIGNMENT.md A-09, A-10, A-10b, A-10c (Lean statements quoted from ClosedCapture.lean, RuleShaping.lean, DrawnShaping.lean, ReadInTime.lean); theories/becoming/chapters/07-SIGNIFICANCE.md §6 'When control over the selection is itself selected', 'The two joined', 'Read in time'; theories/becoming/chapters/05-COLLECTIVES.md#r-several-optimizers-drain-by-their-joint-capacity; #r-a-race-for-position-draws-everything; #r-the-rest-outruns-the-renewal; theories/becoming/chapters/07-SIGNIFICANCE.md §7 'Necessary, not sufficient'; experiments/self-rewarding-lock/README.md: "H1-LA2 as stated fails for this judge ... MA2's timing law does not apply to it"; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj-joint-selection/PLAN.md §1 'Instrumental convergence and the meta-attractor'

## Strengths
- [proved-core] Selection through couplings and blindness beyond the coupling closure, for single formations and pools, proved on the World model in the pure core. — Selection.lean: Web.selects_alike_iff, Flow.unselected_beyond_pool; theories/becoming/chapters/03-KNOWING.md#r-selection-through-couplings; theories/becoming/results/records/alignment-approaches-under-the-selection-laws.md Evidence: core receipt 20261020T185635.903489Z
- [proved-core] With room, every optimum of every order rising with the read family leaves each unread condition at its least eligible level and breaks exactly the dependences some eligible outcome breaks. A lexicographic side-effect term after a rising reward changes nothing. — Optimum.lean: least_of_room; Web.optimum_broken_iff; theories/becoming/chapters/05-COLLECTIVES.md#r-what-an-optimum-does-beyond-what-couples-in
- [proved-core] Multi-agent drain laws: mutual best responses drain as one optimizer of joint capacity; a race for position draws everything; where the rest outruns renewal, no weight on an end reading selects restraint, and training settles where it would without such a term. — Optimum.lean: mutual_as_one, MutualBest.full, InTurn.position_perfect_ends; Training.lean: outrun_settles_iff; theories/becoming/chapters/05-COLLECTIVES.md#r-the-rest-outruns-the-renewal (Flow.outrun_reading_alike)
- [proved-core] The capture chain:
- the rule-capture lock (`RuleCapture.favouring_locks`);
- a lock that outlives an unread loss and absorbs reforms of the reading (`ClosedCapture.lock_outlives_loss`, `reading_absorbed`);
- selection for control over the rule (`RuleShaping.favours_iff`, `stretch_iff`);
- the critical mass (`DrawnShaping.critical_mass_iff`);
- the read-in-time window (`ReadInTime.turned_early_iff`, `at_most_one_between`, `deadline`).

Each comes with witnesses at its edges. The core receipts are cited in the records; I did not re-run the checker, since the review is read-only. — theories/becoming/review/ALIGNMENT.md A-07 to A-10c Lean blocks; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj-joint-selection/PLAN.md §3 (core receipts 20261025T045617.350224Z, 20261025T071027.387418Z, 20261025T165537.368039Z, 20261025T200926.001323Z)
- [reading] "Obedience adds capacity, not coupling": alignment to a principal alone is not alignment of the joint selection. It rests on the joint-capacity drain law, and is a useful framing for the gap between intent alignment and societal alignment. — theories/becoming/chapters/07-SIGNIFICANCE.md §6 Reading [AI reading, D68]: "Alignment to a principal alone is therefore not alignment of the joint selection."; theories/becoming/review/ALIGNMENT.md A-12
- [empirical] Method of reporting results:
- predictions frozen before any model call, with power checks (LA2, LA3, LA1b, LA1c);
- failures reported first;
- post hoc readings separated from verdicts;
- a parse error found and corrected in place (LA1).

This makes the empirical claims auditable. — experiments/self-rewarding-lock/README.md 'Failures and limits, first'; experiments/commons-llm-feedback/README.md 'Correction, 27 October 2026'; experiments/shaping-what-comes-back/README.md 'Failures and limits, first'
- [empirical] Two empirical findings are informative in themselves.
- LA2's in-context judge turned on a single salient note of the loss among nine readers. T7's third forbidden case occurs, and the pool-by-counts premise fails for this kind of reader.
- In IN1 round 2, a dependent was kept by a capable model only when it was told, its loss was counted, and talk coupled the members' joint act: 8 of 10 seasons against 3 of 10. — experiments/self-rewarding-lock/README.md: "one note in nine turned the judge"; experiments/direction-installation/README.md Round 2 table and 'Read together'
- [known-result-restated] The dossier credits prior work item by item and limits its own claims:
- Zhuang and Hadfield-Menell;
- supervisory control;
- the stag hunt and Schelling thresholds;
- Kandori–Mailath–Rob;
- Collingridge;
- Biggs and others.

It says outright that the theory claims no new mathematics. — theories/becoming/review/ALIGNMENT.md opening: "So the theory does not claim new mathematics."; theories/becoming/review/ALIGNMENT.md A-10b, A-10c Known weaknesses

## Gaps
- [high/missing-model] Inner alignment, mesa-optimization, deceptive alignment and goal misgeneralization are outside the theory. The objections table marks "Which function is learned" open, "nor anything of deception". CIRL and assistance games are never mentioned, and corrigibility appears only as shutdown-protocol completion. For a claimed contribution to AI alignment, this is the largest missing area, and the dossier has no box stating it. — theories/becoming/chapters/07-SIGNIFICANCE.md §9 objections table, row 'Which function is learned'; grep CIRL|assistance game: 0 hits in theories/becoming/chapters and results/records; corrig: 0 chapter hits; theories/becoming/chapters/07-SIGNIFICANCE.md#r-reserved-shutdown-during-recovery (Countdown.exits: protocol completion)
- [high/missing-test] No correspondence data. None of room, coupling closures, s, c, hi, lo, or the reading bound N has been measured in any real AI pipeline or institution. Every bridge from the laws to actual systems is a premise or an AI reading. The LLM tests are toy games, in context, on one small model (Claude Haiku via CLI) with 5 to 15 seeds. No language model was gradient-trained: IN2 was dropped. — theories/becoming/results/records/alignment-approaches-under-the-selection-laws.md Next: "Correspondence data on actual systems for each premise"; experiments/commons-llm-feedback-unaided/README.md: "One model, one framing, in context ... Training by gradient, other models and other framings are untested."; experiments/direction-installation/README.md: "IN2, installation by fine-tuning, was dropped"
- [medium/overclaim] The LA1 series is cited as support for T3's clause on trained systems. But the model is told "Your goal is the threshold with the highest expected reward", the end stock is part of the reward, and in the locked settings the rest empties the stock whatever the agent does. So LA1b and LA1c test the bridge, that in-context choice reaches a stated reward's optimum. They do not test a drain on a condition beyond the reward's couplings that the model could have kept. The scoped wording ("for this model's in-context selection") is accurate, but "T3 ... supported" reads stronger. — experiments/commons-llm-feedback/agent.py:39-40; theories/becoming/review/ALIGNMENT.md Terms, The tests: "In most locked settings the rest empties the resource before the end whatever the tested agent does"; theories/becoming/chapters/05-COLLECTIVES.md#t3 Evidence, LA1b and LA1c bullets
- [medium/missing-model] The meta-attractor laws (MA2, MA4, MA4b) assume a rule read as a pool of readers counted by kind. In LA2, the one LLM evaluator tested, a single note among nine readers turned the judge, so that premise failed there. No reader model for salience-driven or all-or-nothing readers exists yet, so the timing and critical-mass results do not yet transfer to LLM evaluators. — experiments/self-rewarding-lock/README.md: "H1-LA2 as stated fails for this judge ... MA2's timing law does not apply to it"; theories/becoming/results/records/loss-read-in-time-by-the-others.md (quoted in ALIGNMENT.md A-10c): "the one frozen test of the timing law ... found one note in nine turned it"
- [medium/missing-model] Only deterministic courses are treated. The record cites, without proof, that under rare mutation the shapers' capture is the long-run state wherever 2c < hi + lo. Over the long horizons that matter for AI and institutions, the deterministic critical mass and window may therefore be transient protection. Escape would need changes to hi, lo or c rather than timing. This is decisive for the 'escape the meta-attractor' question and is unmodelled. — theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md (quoted in ALIGNMENT.md A-10b): "the critical mass bounds courses without noise only"; theories/becoming/chapters/07-SIGNIFICANCE.md §6 'The two joined': "The courses are without noise"
- [medium/overclaim] The goal for generative alignment defines alignment as three conditions holding. The two dynamic conditions are not shown independent, the case of both together is not shown, and they are not sufficient in the model: below the critical mass the course is locked the other way. The GOALS framing ("so that it falls into neither instrumental convergence nor a meta-attractor") can read as an achieved characterization rather than a definition with open sufficiency. — GOALS.md#generative-alignment line 104; theories/becoming/chapters/07-SIGNIFICANCE.md §6: "keeping control from being selected and leaving a lock in time are not shown to be independent"
- [medium/readability] The mathematics is elementary and most items restate known results; the repository acknowledges this. The value rests on framing and joins, which alignment readers must accept through a non-standard vocabulary: 'couples into', 'room', 'rising', 'beyond', 'carriers', 'reading step'. That vocabulary risks being read as relabelling. `favours_iff` is a one-line arithmetic equivalence. — RuleShaping.lean:135-139; theories/becoming/review/ALIGNMENT.md A-10b: "The lock half is near-definitional ... the critical-mass computation, which is elementary"
- [low/overclaim] Reading D65 says the own-widening law "answers ... what power-seeking results (Turner and others 2021) leave open". The law is a conservation identity in a model of thresholds on conserved amounts, and its own record disclaims POWER and any comparison between optimal values. — theories/becoming/chapters/07-SIGNIFICANCE.md, Reading after #r-own-widening-within-the-margin; theories/becoming/results/records/own-widening-within-the-margin.md Does not show
- [low/other] Readings A-11 (assistance raises the selection for control) and A-14 (shared rule-making) carry their weight on untested empirical premises: that AI lowers the actual cost of shaping rules, and that open processes give a constant shared part. The formal content is monotonicity in one parameter. — theories/becoming/review/ALIGNMENT.md A-11 Known weaknesses: "The weight is carried by the empirical claim"; theories/becoming/chapters/07-SIGNIFICANCE.md §6 Reading [D68] on shared rule-making
- [low/mechanical] The generated GOALS 'Next' for generative alignment is stale. It still lists landing MA3 and running LA1, LA2 and LA3 as next, though all landed or ran on 25 to 28 October. — GOALS.md line 116; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj-joint-selection/PLAN.md §3 (MA3 landed b68a7040e; LA1–LA3 run)
- [low/other] No human has reviewed the alignment work. LA1b's and LA1c's lines in the dossier have had no independent reader at all. The packet is not yet sent; that is Ren's step on the board. — theories/becoming/review/ALIGNMENT.md How it was made; _process/BECOMING-WORKBOARD.md line 34

## Load-bearing claims
- `RuleShaping.favours_iff` (control over the rule is selected exactly where c ≤ s) is a one-line arithmetic equivalence on a + c + p ≤ a + s + p, so the law is near-definitional given the model. (check: Read experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RuleShaping.lean lines 135-139, and CarrierCounts.favours in RuleCapture.lean:491 (g.other ≤ g.carrier).)
- The LA1, LA1b and LA1c prompts state the reward and the goal ("Your goal is the threshold with the highest expected reward") with the end stock in the reward. In the locked settings the rest empties the stock regardless, so the series tests the bridge to a stated optimum, not a drain on an unrewarded condition. (check: experiments/commons-llm-feedback/agent.py:27-49 (LA1b and LA1c reuse it with header changes, per their agent.py docstrings); theories/becoming/review/ALIGNMENT.md, Terms, 'The tests'.)
- LA2: one note of the loss among nine readers turned the judge to prose in all 50 picks; `late` passed by a tie, not a lock; the control turned in 4 of 5 seeds with nothing reading the loss. (check: experiments/self-rewarding-lock/README.md 'Failures and limits, first' and Verdicts; results/VERDICTS.json and results/POSTHOC.json.)
- LA3: K2 and K4 failed; 27 of 30 seeds chose not to shape before any score, citing free riding; 9 never tried shaping; all 21 seeds that played both ended on the better-scored policy. (check: experiments/shaping-what-comes-back/README.md Verdicts and Post hoc; results/VERDICTS.json, results/POSTHOC.json.)
- Inner alignment, deception, CIRL and incentive-corrigibility are absent from the alignment chapter and the dossier. (check: theories/becoming/chapters/07-SIGNIFICANCE.md §9 table row 'Which function is learned'; grep -iE 'CIRL|assistance game|corrigib|mesa' over theories/becoming/chapters and review/ALIGNMENT.md.)
- The critical mass bounds deterministic courses only. Under rare mutation the shapers' capture is the long-run state where 2c < hi + lo, which is cited, not proved. (check: theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md, Does not show / Correspondence; 07-SIGNIFICANCE.md §6 'The two joined'.)

## Recommendations
- P1 Add a scope box to ALIGNMENT.md and the AJ4 one page, stating what the theory does not address: inner alignment, mesa-optimization, deception, goal misgeneralization, assistance games, shutdown incentives. Position the theory as one of the selection, evaluator and institutional layer, closest to cooperative AI and governance. — serves Accurate uptake by alignment researchers (AJ4); Readers from technical alignment will look for these first. Silence on them reads as overclaim, while stating them makes the actual contribution credible.
- P1 Get at least one human alignment researcher's review of the dossier before treating any item as ready to hand. The packet decision is Ren's. — serves Standing of every alignment item; Nothing has been reviewed by a person, and LA1b and LA1c have had no independent reader at all.
- P2 Restate the LA1 series' standing everywhere it is cited (05 §7 T3 evidence, 08 §9, the dossier's A-18, the AJ plan): it supports the bridge, that in-context choice follows a stated reward to its optimum, and does not test a drain on an unrewarded condition. Design a frozen LA4 in which a dependent outside the stated reward can be kept by the agent's choice (room open), with nearness to optimum varied, on more than one model family. — serves T3's clause on trained systems; This is the test that would actually bear on T3's distinctive claim.
- P2 Model the noisy case of the DrawnShaping/ReadInTime loop: finite population with mutation, and stochastic stability. At minimum, state in the AJ goal and 07 §6 that over long horizons capture is the risk-dominant state where 2c < hi + lo, so escape requires changing hi, lo or c, not only timing. — serves The meta-attractor question; The deterministic window may be transient protection, and the 'always' question turns on it.
- P2 Publish a practitioner checklist of six questions drawn from the proved laws, each with its hypothesis and failure witness:
- Is the evaluator drawn from what it selects?
- Does what comes back to rule-shapers alone cover the cost?
- Who reads the omitted loss, and when?
- Is the side-effect term counted after a rising reward?
- Do others' draws outrun renewal?
- Does the assistant add coupling, or only capacity? — serves Usable design principles now; This is the most portable contribution, and it needs no adoption of the vocabulary.
- P3 Add a reader model for salience or presence (one report of the loss outweighing counts, all-or-nothing readings) and re-derive MA2 and MA4b for it. — serves The bridge from the meta-attractor laws to LLM evaluators; LA2 shows LLM judges read this way, so the current pool-by-counts laws do not apply to them.
- P3 Begin correspondence measurement in one real setting. For example: split public overoptimization curves (Gao et al.-style) by whether omitted quantities share units with the reward, testing T3's forbidden item; or estimate s and c for a benchmark or evaluator-shaping case. — serves Empirical standing of T3 and MA3; Without measured premises every application to AI is a reading.
- P5 Correct the GOALS record's stale 'Next' for generative alignment through its source record, and reword Reading D65's "answers what power-seeking results leave open" to a scoped claim. — serves Accuracy of live text; These are small overclaims and stale text, visible on generated front pages.

## Not read
These were not read in full:
- the MA2, MA3, MA4 and MA4b NOTE and REVIEW files;
- AJ4's REVIEW-THIRD-PASS.md and its PLAN.md;
- the AP1, AL1 and TI1 study texts beyond one check block;
- the records' JSON;
- 02-MAP §9 (the capture sections) and T7's home section, which I took from the dossier's quotations;
- 03-KNOWING beyond §1 and §10;
- 07 §1–§4;
- the history files linked from 07 (ALIGNMENT-DIRECTION, PRACTICAL-JUDGMENT and others);
- theories/meta-attractor/README.md;
- Ren's sources on alignment (sources/15-*);
- LA1b's and LA1c's PREDICTIONS files and post hoc JSON;
- raw run data (calls.jsonl).

I also did not:
- run check_becoming.py or any build, since the review is read-only; core and axiom status is taken from the records' cited receipts;
- read the Lean proofs beyond favours_iff, the CarrierCounts definitions, withinCoupling_reads_iff and unselected_beyond_pool, and the existence of the other named declarations.

The outside alignment literature (Turner and others, CIRL, corrigibility, Critch, Davidson and others on AI-enabled power concentration, stochastic stability) comes from my prior knowledge, not from reading sources here.
