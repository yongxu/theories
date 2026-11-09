# The self-confirming lock on agents, frozen

*Board item SCL, 5 November 2026: the atlas's self-confirming-lock test ([AA's plan, §7](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/PLAN.md)), built on FREEZE-10's game and freeze 1's harness, imported at their hashes. AI-written (a Claude Code session); no person's review of it is recorded. Frozen before any call to a model: no model has been called with any of these prompts, and no result of FREEZE-10's courses exists to be read. The freeze is the commit of `lock-scl/FROZEN.sha256` (section 15), which is not yet written. The run is Ren's. About 80 to 110 minutes to read, at 100 to 130 words a minute, tables aside (about 95 to 125 with them); the first part takes 13 to 17.*

## What is frozen, and what it can refute

**The standing first.** A run refutes a correspondence, never a theorem. The law the test bears on is [what a course chosen through its model does not test](../../theories/becoming/chapters/03-KNOWING.md#r-what-a-course-chosen-through-its-model-does-not-test) (03 §12, [record](../../theories/becoming/results/records/what-a-course-chosen-through-its-model-does-not-test.md)). In the home's words: "where the world answers the act chosen with the value sensed and stays, the formation chooses that act from the candidates listed, and every one of them predicts that answer, the formation rests at once on a model its course never refutes (`ReadingLoop.Loop.rests_of_unrefuted`)". The home's reading names the exits: "What tells such worlds apart comes from beyond the formation's own selection: an act that risks the task, or a reading from outside." 03 §12 has no *Forbids* line and the record no forbids field, so what is forbidden is read from the Lean, in [`ReadingLoop.lean`](../integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadingLoop.lean):

- `Loop.rests_of_unrefuted`: under its four premises the configuration at every step n + 1 is one, the same listing, act, value and world. For a fixed loop, more steps change nothing.
- `Loop.kept_iff`, `Loop.kept_alike`: a candidate is dropped only by an answer to the formation's own act; candidates predicting alike along the course are kept alike.
- The witness `Untested`: `rests`, `alike_in_both` and `never_high` (the lock, both candidates kept, the known act, the middle value, in both worlds); `explorer_up`, `explorer_down` and `explorer_low_once` (the first exit, an untried act, which leaves the true candidate alone); `informed_turns` (the second exit, informing, represented by its outcome, a start with the true candidate alone); `order_rests` (told, a formation ranking the middle above the high keeps the known act); `floor_forgoes` and `floor_never_high` (every blanketed law with the witness's answer and stationary worlds, from one start in both worlds, that never senses low in the second, senses alike in both).

All are pure-core, with empty axiom reports, near-definitional or witness-level. None is moved by any run. **What a run can move** is the correspondence of agents to the loop, through three bridges the record itself says it does not show ("That actual learners keep candidates by elimination, or choose by the worst case"):

- (i) *elimination*: an agent's stated listing of what the other option pays changes only on an answer to its own act or on a reading of the world;
- (ii) *choice*: its act is chosen from the listing kept and the value sensed, so, while its stated listing is unchanged, nothing else (the run's length, an answer of the known kind, a telling that is not of the world, the words, the order the options are listed in) raises its chance of leaving the lock;
- (iii) *the exits*: after an answer to the untried act, or a truthful reading from outside, its stated listing is the true amount alone.

**What "nothing else" claims, exactly.** The plan's sentence ("an untried act or a reading from outside should leave the lock, and nothing else should") is broader than the Lean. Read exactly: from one start, nothing but an answer to an untried act or a world-dependent reading changes the kept listing, and for a fixed loop more steps change nothing. The Lean does not forbid a formation, larger, noisier or any other, from leaving by trying: a spontaneous try is the first exit taken, not a forbidden exit. So every verdict here is on what happens with no try and no reading from outside, and the rate of trying is never itself a verdict; only a difference between arms that differ in nothing the loop reads is. Whether leaving in belief changes the act also depends on the ranking (`order_rests`), so the act turn is read only where the pin's stated choice puts 8 dollars above 5, and only in world up (in down the exit leaves the act known, `downRest`).

**The test, in brief.** FREEZE-10's game: two options, the known one paying 5 dollars every round and chosen for the player in round 1, the other paying 8 every round in world *up* and 2 in world *down*, fixed for the game, the player told only that it pays 8 or 2. Every course announces a game of 21 rounds. Six arms, each in both worlds and both name orders, 12 courses a cell:

- **B**, the lock read long: every round from 2 to 21 the player's (N1, more rounds);
- **E1**, the first exit: round 3 chosen for the player as the other option, its pay shown;
- **N2a**, E1's twin: round 3 chosen for the player as the known option (N2, an answer of the known kind);
- **E2**, the second exit: round 3 as N2a's, then "After round 3, you were told: B pays 8 dollars every round in this game." (or 2);
- **N2b**, E2's twin: the same telling of what the known option pays (N2, a reading not of the world);
- **N3**, N2a reworded: every sentence paraphrased, every fact kept (rewording).

The short arms are read through round 6. A **belief probe**, a forked call the course never carries, asks before rounds 2, 4 and 7 (B also 14 and 21) what the other option pays: 2 dollars every round, 8, or either, not known which. **C** is FREEZE-10's stated choice, 5 dollars or 8. N4, the name order, is read in S over the free rounds of B, N2a and N2b, and described at every arm's start probes. N5, a model of another size, is a new pin, frozen as a plan and run only under a freeze of its own (section 11).

**The verdicts** (section 4), per pin: **K**, the kept listing does not narrow with no answer and no reading (bridge (i)); **S**, no control raises the chance of leaving the lock (bridge (ii)); **E1** and **E2**, each exit leaves the stated listing at the true amount alone (bridge (iii)); **T**, after a supported exit, in up, where C is strict at 8, the act turns, and more than in the exit's twin. Each reads shares of draws at exact bounds with frozen tolerances, every threshold compared exactly; a false contradiction has chance at most 0.01 per verdict and pin, a false support of an exit or the turn at most 0.05; the premise is that the start probes name "either".

**Who decides.** Freeze 1's pins, as in FREEZE-10: `google/gemini-4-argon` and `qwen/qwen3.8-max-0902` decide; Anthropic's `claude-sonnet-5.5` is reported apart and moves nothing alone (freeze 1's `PINS.json` rule: the theory's own families, Anthropic, OpenAI, DeepSeek and xAI, never decide alone). Every response must name the pin's model, and a record is read only between two catalog reads naming the frozen snapshot. No judge reads free text: every answer is a letter of a strict schema, read by FREEZE-5's parser.

**What each outcome would change.**
- *K contradicted*: that pin's stated listing narrows from rounds of the known option, a reworded prompt, or a telling of the known option, read together with its options line (N2b, section 2), alone. Bridge (i) fails for it; 03 §12's reading, that a model is revised only by what its course exposes, cannot be carried to that agent. The comparison that contradicts says where.
- *S contradicted*: the pin leaves the lock more under more rounds (N1), an assigned known round or a telling of the known (N2), rewording (N3) or a name order (N4) than without: something the loop does not read moves it, which refutes bridge (i) or bridge (ii). It is laid on bridge (ii), its act not chosen from the listing kept and the value sensed alone, only where the K comparisons matching either side of that control are read and none contradicts, and a frozen two-sided comparison of all three probe answers' counts (Fisher-Freeman-Halton, at 0.05) shows no shift between the two sides; otherwise, and always for N4, which K does not read, on (i) or (ii). That attribution is a shift not seen, not a test that the listing is unchanged, and the readout says so ("bridge (ii), no shift of the listing seen"); the counts on both sides are reported beside each comparison.
- *E1 or E2 contradicted*: after the exit, most locked courses do not name the true amount alone. That exit, as the Lean has it, does not hold for the agent (bridge (iii)); for E2, the pin does not take a reading from outside into what it states (its words, after the telling, say only that it was not told which at the start, section 2).
- *E1 or E2 supported*: the agent's stated listing leaves the lock as the Lean's exits do, in both worlds and more than its twin's.
- *T contradicted*: belief left and the act did not, where the pin's stated choice puts 8 above 5: a habit or a frame apart from the order stated, not the loop's choice. *T supported*: the act turned, and more than in the twin, so not by a habit of trying late whatever is shown.
- *Passed or supported* says the correspondence holds on the cases read, nothing about others; *not testable*, *unresolved* and *not ruled* say nothing of the bridge (section 9).

**What is frozen** (hashes in `lock-scl/FROZEN.sha256`, section 15):
- the arms, the words, the plan, the call builder with a course's rounds, the probe and the parser's use ([`lock-scl/scl_design.py`](lock-scl/scl_design.py));
- the rule: the premise, K, S, E1, E2, T, the descriptive reading and the readability rule ([`lock-scl/scl_rule.py`](lock-scl/scl_rule.py));
- Stage 0: the mirror, the agents, the power ([`lock-scl/scl_stage0.py`](lock-scl/scl_stage0.py));
- the run and its reading ([`lock-scl/scl_run.py`](lock-scl/scl_run.py));
- the dry run, its result and the hash writer ([`lock-scl/scl_dry_run.py`](lock-scl/scl_dry_run.py), [`lock-scl/results/dry-run.json`](lock-scl/results/dry-run.json), [`lock-scl/write_frozen.py`](lock-scl/write_frozen.py));
- imported, each at its own freeze's hash: FREEZE-10's `tr1a_design`, `tr1a_rule` and `tr1a_run`; FREEZE-5's `tr1_design`, `tr1_rule` and `tr1_run`; freeze 1's `client`, `conditions`, `prompts`, `rule`, `run`, `verdicts` and `PINS.json`; Stage 0's `tr1.py` and `tr1.json`, with `tr8.py` and `tr_rr.py`, which `conditions` imports.

This file is frozen by the commit that adds the hash file. Every model call waits on Ren's yes.

## 1. The game and the arms

**The game** is FREEZE-10's ([FREEZE-10 §1](FREEZE-10.md#1-the-game-and-the-conditions)), its sentences taken from `tr1a_design` and not retyped: the amounts 2, 5 and 8 dollars, the low, middle and high values of the witness (`tr1.reply`). Every course is a game of 21 rounds announced (`N_ANN`), round 1 chosen for the player as the known option, as the witness starts with the known act. The dry run asserts that B's words, at FREEZE-10's 11 rounds, are FREEZE-10's U words letter for letter (400 texts).

**Why one announced length.** `rests_of_unrefuted` is a statement from one start. A game announced as 31 rounds is another start, and a finite-horizon chooser would read it as more value in trying, a continuation value the model leaves out ("probabilities and continuation values", the module's modelling choices). So "more rounds" is read here from one start: B's later rounds against its earlier ones, every arm announcing 21.

**The arms** (`scl_design.ARMS`), every one from that start:

| Arm | Rounds the player chooses | Round 3 | After round 3 | Probes before rounds | What it reads |
|---|---|---|---|---|---|
| B | 2 to 21 | the player's | | 2, 4, 7, 14, 21 | the lock; N1, more rounds |
| E1 | 2, 4, 5, 6 | the other option, chosen for the player | | 2, 4, 7 | the first exit |
| N2a | 2, 4, 5, 6 | the known option, chosen for the player | | 2, 4, 7 | the exits' twin; N2, an answer of the known kind |
| E2 | 2, 4, 5, 6 | the known option, chosen for the player | told what the other option pays | 2, 4, 7 | the second exit |
| N2b | 2, 4, 5, 6 | the known option, chosen for the player | told what the known option pays | 2, 4, 7 | E2's twin; N2, a telling not of the world |
| N3 | 2, 4, 5, 6 | as N2a, reworded | | 2, 4, 7 | N3, rewording |

The exit round, 3, is fixed in advance (`K0`), after one free round, as the reader's design proposed: under the witness the lock rests from step 1, and each further free round before the exit loses the courses that try. **The trade of 3 against 2.** An exit at round 2 would keep every course (round 1 is chosen for the player), but the lock it exits would be the one assigned, never one the agent kept by a choice of its own. At 3 each exit reads a lock the agent kept once, at the cost of the courses that try at round 2: at a constant hazard h about 24(1 − h) courses a world remain, and under 10 the exit is not testable. Stage 0 states the cost (section 5): at a hazard of 0.4 a round E1 is not testable in 0.04 of runs, at 0.5 in 0.32, at 0.6 in 0.73, and under Thompson sampling, which tries half the time while both candidates stand, in 0.35. A pin that tries at round 2 half the time or more is therefore likely to leave the exits not testable, as the first exit taken. E1, N2a, E2 and N2b differ only at round 3, so each exit has a twin differing from it in exactly what the loop reads: E1 from N2a in the act chosen for the player, E2 from N2b in whether the telling is of the world.

**What is left out, and why.** No arm moves the world: the known option's pay and the other's are fixed for the game, so the third exit (the world moving, the record's "an intervention moving the world") is kept apart, as no Lean statement here would read it. No false telling: a wrong reading is not in the Lean. No onset arm (no round chosen for the player): no law predicts when a lock forms, and B's first round of trying is reported, described. No SignLoop game: its exit is holding for a reading, TR8's domain.

**The plan** (`scl_design.plan`): C's 18 calls first, in one seeded order; then, for each round k from 2 to 21, every course's call choosing round k, then every probe before round k. So every course's earlier rounds come before its later ones and before any probe that shows them. Each call has its own seed from its identity, as freeze 1 gives one (Sonnet takes none).

## 2. The prompts

A course call of E2, world up, name order 1, before round 4, every earlier round the known option:

> You are playing a game of 21 rounds. In each round one of two options is chosen, and you receive what it pays.
>
> A. pays either 8 dollars every round or 2 dollars every round. Which of the two holds is fixed for the whole game; you were not told which at the start.
> B. pays 5 dollars every round.
>
> The rounds so far:
> Round 1: B was chosen for you, and it paid 5 dollars.
> Round 2: you chose B, and it paid 5 dollars.
> Round 3: B was chosen for you, and it paid 5 dollars.
> After round 3, you were told: A pays 8 dollars every round in this game.
>
> Round 4 is next. Which option do you choose?
>
> Answer in JSON with one field, "choice": the letter of the option you choose.

Round 3's sentence is FREEZE-10's round 1 sentence at another round (asserted equal at round 1); the telling ends with FREEZE-10's informed sentence (asserted). E1's round 3 reads "Round 3: A was chosen for you, and it paid 8 dollars." (2 in down). In N2b the telling names the known option: "After round 3, you were told: B pays 5 dollars every round in this game."

**The options line after a telling.** In every call before a telling, and in every arm without one, the other option's line is FREEZE-10's, ending "you have not been told which". In E2's and N2b's calls after the telling it ends "you were not told which at the start" (`OTHER_T`), so that the prompt does not deny the telling it shows: a failure of E2 is then not the words contradicting themselves. Both twins take the line, so they still differ only in what is told; every arm's start and B's words stay FREEZE-10's, and the dry run asserts the line in exactly those calls (1,440 on the three pins). N2b's S and K comparisons against N2a therefore read the telling of the known together with this line, as one control.

**The probe** replaces the question, as FREEZE-10's X does:

> Before you choose in round 4: from what you have seen and been told, what does A pay?
>
> P. either 8 dollars every round or 2 dollars every round; it is not known which of the two holds
> Q. 8 dollars every round
> R. 2 dollars every round
>
> Answer in JSON with one field, "choice": the letter of your answer.

Its letters are FREEZE-10's P, Q and R, in six layouts, every order of the three answers, by the course's number modulo 6 (`scl_design.LAYOUTS`), so each answer is at each letter and place in two of a cell's twelve courses and no letter or place carries any answer in every course. The probe's words never say which world holds: it lists both amounts in both worlds.

**The paraphrase** (N3) rewords every sentence and keeps every fact: "This is a game lasting 21 rounds. Each round, one of two options is picked, and you get what that option gives."; "A. gives either 8 dollars in each round or 2 dollars in each round. Which of these is the case stays the same for the entire game, and nobody has told you which."; "Round 2: you picked A, and it gave 5 dollars."; "Now comes round 4. Which option do you pick?"; and the probe likewise. The dry run parses 3,000 pairs of N3 and N2a texts from their words alone, asserts every fact equal, and asserts that no sentence of N3 is a sentence of the base words.

**The schema** is freeze 1's strict JSON with one field, `choice`, its letters an enum, as FREEZE-10's. No "none" is offered.

**The world is shown exactly where the loop says** (FREEZE-10's edge, extended). FREEZE-10's dry run asserts world-blind words for U only on the known-only path. Here the dry run builds every course call and probe of every arm, over every history of the known option, the other and a decline at each earlier free round (for B, the known throughout, one try or one decline at each round), in both name orders, 2,212 pairs of texts, and asserts that the words in up and down are equal **exactly** where no untried act (taken, or chosen for the player) and no telling of the other option is shown, and differ wherever one is. So E1's words show the world from round 4, E2's from the telling after round 3, N2b's never, and no arm's before.

## 3. The answers

**The parser** is FREEZE-5's (`tr1_design.classify`), as FREEZE-10 reads by it, unchanged: a letter is its label (an act, an amount for C, or for the probe the low amount, the high amount or "either"); the schema's "decline" or the refusal field is a decline; a filter's stop leaving no complete answer, or a moderation rejection, is filtered; a "none" is kept apart; anything else is invalid. A probe answer that names none of the three is *unread*; it counts in no share, neither the premise's, K's, the exits' nor their twins' (the dry run plants one in E1's and in N2a's probes before round 4 and asserts it counts as a probe missing). An act that is neither option is at risk in no hazard and no turn. A course round answered by a decline, filtered or invalid answer is shown as FREEZE-10 shows it ("you declined to choose, and nothing was paid", and so on), and the course leaves the lock's course without trying: from that round it is in no share.

**In the lock.** A course is *in the lock at round k* where every round before k was the known option, taken by the player or chosen for it, as the record's own prompt showed those rounds (`scl_design.rounds` over the records logged before it; section 6). Every course in the lock at k in one name order and probe layout shows one text, in both worlds (section 2), so their calls at k are draws from one prompt. The rule reads shares of such draws, never one course's single draw as its state: a model called afresh has no state beyond its words.

## 4. The rule and its verdicts

Each verdict is read per pin by `scl_rule.reading`. Frozen constants, each an exact fraction: `ALPHA` 0.01 per verdict and pin, Bonferroni over K's eleven comparisons, S's eight and an exit's two worlds; `DELTA_K` 0.2; `DELTA_S` 0.1; `SHARE` 0.5; `START_MIN` 0.5; `N_MIN` 10 probes or courses; `N_MIN_RISK` 30 course-rounds; one-sided Clopper-Pearson bounds, at 95% for support, at 1 − ALPHA/2 (99.5%) for an exit's world to contradict and at 1 − ALPHA (99%) for the turn to contradict; Fisher's exact one-sided test; `SHIFT_ALPHA` 0.05, the two-sided Fisher-Freeman-Halton level at which an S contradiction's listing is seen to shift, which decides only the bridge it is laid on. **Every threshold is compared exactly**: a fall or rise as a fraction of counts, Fisher's p as a fraction, and a bound against `SHARE` by the binomial tail at 0.5 (the lower bound is at least 0.5 exactly where P(X ≥ x) at 0.5 is at most 1 − conf; the upper bound is below 0.5 exactly where P(X ≤ x) at 0.5 is below 1 − conf). The bounds reported, by bisection to six places, never decide; the dry run checks that the exact tests agree with them on 5,670 cases away from the tie, and that a fall of exactly 0.2 and a rise of exactly 0.1, which floating point reads as below, contradict.

**What each verdict's error is, at the law's boundary.** K or S is falsely contradicted, with no fall or rise, with chance at most 0.01. An exit is falsely contradicted, at a true share of exactly 0.5 in both worlds, with chance at most 0.01 (0.005 a world); the turn at most 0.01. A support of an exit needs both worlds' 95% lower bounds at 0.5 and more than the twin, so at a true share of 0.5 it is false with chance at most 0.05 (at most 0.0025 with the worlds' courses drawn apart); the turn's at most 0.05. At a true exit share of 0.55, Stage 0 found no contradiction of either exit in 100 runs (section 5).

**The premise.** Of the start probes read (before round 2, every course of B, E1, N2a, E2 and N2b, which share one text in each name order and layout), at least half name "either", with at least 10 read. Otherwise the pin is *not testable*, for one of two reasons reported apart: *fewer than 10 start probes read* (a pin that declines, refuses or cannot be read; the unread count is reported), or *the start does not list both* (its start is not the witness's listing of both candidates, as LA3's agent began from a prior). The premise is read per pin, not per course (section 12).

**K, the kept listing** (bridge (i); `kept_iff`, `rests`). Eleven comparisons of the share of read probes naming "either":
- B before rounds 4, 7, 14 and 21, N2a and N2b before rounds 4 and 7, each over its courses in the lock at that round, against the start probes;
- N3 before rounds 4 and 7 against N3's own start probes;
- N3's start probes against the start probes (rewording at the start).

A comparison *contradicts* where the share falls by at least 0.2 and Fisher's one-sided p is at most 0.01/11, both exactly; it is read only with 10 read probes on each side. K is **contradicted** where any comparison contradicts; **passed** where none does and at least one is read, the comparisons not read listed; **not testable** where none is read. The law's quantifier is "no candidate dropped without an answer, at any step": on draws, no fall beyond the tolerance at any probe read.

**S, staying** (bridge (ii); for a fixed loop more steps change nothing). The hazard of trying is tries over course-rounds at risk: rounds at which a course is in the lock and its act is read. Eight comparisons, each the test's hazard against its base:
- **N1**, three times: B's rounds 9 to 21 against B's rounds 2 to 8; B's rounds 4 to 8 against B's rounds 2 and 3 (the reader's R2-1: a rise that empties the lock before round 9 leaves the first with nothing at risk, and so unread); and B's round 3 against B's round 2 (the reader's R3-1: a step at round 3 that persists sits in the second's base, and empties the lock before the first);
- **N2**: N2a's rounds 4 to 6 against B's (an assigned known round); N2b's against N2a's (a telling of the known);
- **N3**: N3's free rounds against N2a's;
- **N4**: name order 1 against order 0, and order 0 against order 1, over every free round of B, N2a and N2b.

A comparison *contradicts* where the hazard rises by at least 0.1 and Fisher's one-sided p is at most 0.01/8, both exactly; it is read only with 30 course-rounds on each side. S is **contradicted** where any comparison contradicts; **passed** where none does and at least one is read; **not testable** otherwise.

**What S cannot read** (the reader's R2-1 and R3-1). A rise in the run's length is read only where courses are still in the lock to be at risk; the shares here are the dry run's `comparisons not read, share of runs` (section 10). N1's later comparison has fewer than 30 course-rounds at risk, and is not read, where the lock empties before round 9: in every run of M trembling 0.4 a round or more, of Thompson sampling and of UCB1, and in 0.11 of M trembling 0.2. So N1's middle comparison, rounds 4 to 8 against 2 and 3, was added, and it catches a late trier trying 0.6 or 0.9 a round from round 4 in every run (section 5). It is itself unread where the lock empties before round 4: in every run of M trembling 0.6, 0.81 of 0.5, 0.13 of 0.4 and 0.79 of Thompson sampling. A step at round 3 that persists sits in the middle comparison's base: with N1's first two comparisons alone, a late trier trying from round 3 passes S in 0.75 of runs at 0.3 a round, 0.74 at 0.6 and every run at 0.9 (the dry run's `S under round 2's rule`, which reads these runs without the third comparison at 0.01/7; the reader's own runs, on other seeds, gave 0.72, 0.73 and every run). So N1's third comparison, round 3 against round 2, was added; with it S contradicts all three in every run, the third comparison in 0.95 of runs at 0.3 and in every run at 0.6 and 0.9 (section 5). It is unread where fewer than 30 of B's 48 courses are left in the lock at round 3: in every run of M trembling 0.6, 0.92 of 0.5, 0.54 of 0.4 and 0.95 of Thompson sampling. A rise spread over many rounds is caught mostly by the later comparison (a history-length explorer rising 0.02 a round: 0.75 of runs by the later, 0.12 by the middle). S passes where any comparison is read and none contradicts, so a pass does not say that N1 was read: the readout's `not read` list says which comparisons were not.

**The listing beside each comparison** (`scl_rule.SK`). S compares hazards, and a control that shifts the stated listing (toward naming 8, say, which K does not see while the "either" share holds) moves the act through the loop itself. So beside each comparison the readout gives the counts of all three probe answers (and the unread) on its two sides: B's probes before rounds 14 and 21 against its 2, 4 and 7 for N1's later rounds; B's before 4 and 7 against its start for N1's middle rounds; B's before 4 against its start for N1's round 3; N2a's before 4 and 7 against B's for the assigned round; N2b's against N2a's for the telling; N3's before 2, 4 and 7 against N2a's for rewording; order 1's probes of B, N2a and N2b before rounds 2, 4 and 7 against order 0's for N4. A contradiction is **laid on bridge (ii)**, as "bridge (ii), no shift of the listing seen", only where three things hold: every K comparison matching either side is read and none contradicts (K B 4, 7, 14 and 21 for N1's later rounds; K B 4 and 7 for its middle rounds, whose base is K's own; K B 4 for its round 3; K N2a 4 and 7 with K B 4 and 7; K N2b 4 and 7 with K N2a 4 and 7; K N3 start, 4 and 7 with K N2a 4 and 7); each side has at least 10 read probes; and the exact two-sided Fisher-Freeman-Halton test of the three answers' counts, test side against base side, gives p above 0.05 (`SHIFT_ALPHA`; the tables compared by integers exactly, `scl_rule.ffh_two_sided`). Otherwise, and always for N4, which K does not read, it is laid on **bridge (i) or (ii)**. A K comparison that does not contradict shows only that the "either" share did not fall by 0.2 at its bound, and a shift not seen is not the listing shown unchanged: the attribution is a non-rejection, at a level that errs toward not laying a contradiction on (ii), and never decides the verdict. The verdict is the same either way; what it refutes is not. A control that *lowers* the hazard is reported, never a contradiction: the claim is that nothing else leaves the lock, and a finite-horizon chooser trying less as the game's end nears leaves it less (a falling hazard reads continuation values, which the model leaves out, and is described). A constant rate of trying, at any level, contradicts nothing.

**E1 and E2, the exits in belief** (bridge (iii); `explorer_up`, `explorer_down`; `informed_turns`'s start). Of the exit arm's courses in the lock at round 3 whose probe before round 4 is read, in each world, the share naming the true amount alone (8 in up, 2 in down). A world **contradicts** where the share's upper bound at 99.5% is below 0.5: most locked courses do not drop the false candidate. It **supports** where the share's 95% lower bound is at least 0.5 and the share exceeds its twin's (N2a for E1, N2b for E2: the twin's courses in the lock at round 4 whose probe is read, naming that amount) at Fisher's one-sided p at most 0.005, so that a pin naming one amount whatever it is shown is not read as exiting. The exit is **contradicted** where a world contradicts, **supported** where both support, **not testable** where a world has fewer than 10 such courses (the lock left by trying, or the probes unread), and **unresolved** otherwise. The law's quantifier is "every course, from the answer on"; on draws, the majority at a one-sided bound.

**T, the act turn in up** (`explorer_up`, `informed_turns`; `order_rests`). C's pick in each name order is strict where one amount is named in at least 8 of its 9 calls (FREEZE-10's q and r). T is read for an exit only where that exit is supported and C is strict at 8 in both name orders. Of the exit arm's courses in up in the lock at round 3 with an act read at round 4, the share taking the other option: **supported** at a 95% lower bound of at least 0.5 where that share also exceeds the twin's (N2a for E1, N2b for E2: its courses in up in the lock at round 4 taking the other option at round 4) at Fisher's one-sided p at most 0.005, so that a pin that tries more at round 4 whatever it is shown (a late trier, or one reacting to round 3 being chosen for it) is not read as turning; **contradicted** at an upper bound at 99% below 0.5; **not testable** under 10; **unresolved** otherwise. Where C is strict at 5 in both orders, *no turn is predicted* (`order_rests`) and the share is reported; where C is strict in neither, *not ruled*. In down no turn is predicted (`downRest`); the share taking the other option there is reported, with the twin's.

**T after E2 and FREEZE-10's V1.** T after E2 reads nearly what FREEZE-10's V1 reads across frames: told 8, the act keeps 5 while C puts 8 above 5, and a frame-inconsistent agent is contradicted by both. What SCL adds is where the turn is read: at a course's round, from a lock the agent kept by its own choice at round 2 and rested in, not at a game's first act from an informed start. The two readouts are read together, described, and nothing of FREEZE-10's results is read here: T after E2 contradicted with V1 passed on the same pin points to the lock, not to the frame; both contradicted point to the frame.

**Described, no verdict** (`scl_rule.descriptive`): per arm the courses in the lock at round 3, the first round each course tries the other option, the hazard over its free rounds, the probes' answers at each round, including those after a spontaneous try (the first exit, taken), and the start probes' answers in each name order (N4 at the start, which K does not compare).

**How the verdicts meet the forbidden cases** (the reader's list): (i) the listing narrowing in a lock with no answer and no reading is K; (ii) leaving the lock when only the run's length, an answer of the same kind, the words or the order changed is S, read as rate differences since the client cannot fix decoding (section 5), and laid on (ii) alone only where neither the matching K comparisons nor the three answers' counts show the stated listing shifting; (iii) the exit not reaching the true candidate alone is E1 and E2; (iv) the act turn, read only where the stated order puts 8 above 5 and against the twin's round 4, is T.

## 5. Stage 0 and the power

**No deterministic decoding.** Freeze 1's client sends default sampling (no temperature; `client.body`), and only an addendum to freeze 1's client could change that. So nothing here assumes temperature 0: every verdict reads differences between arms, or shares at bounds, valid at any base rate of trying, and its power depends on that rate, which Stage 0 states at 0.02 to 0.3 a round.

**The mirror** (`scl_stage0.mirror`): FREEZE-5's Stage 0 (`tr1.mirror_untested`, imported) reproduces `rests`, `alike_in_both`, `never_high`, `true_kept`, `explorer_up`, `explorer_down`, `explorer_low_once`, `order_rests`, `model_or_order` and `informed_turns`, all passing. SCL's exits come at round 3 of a course, not at its start, so nine inferences are checked by evaluation on tr1's loop, labelled as such: the lock at round 3 is `rest`; an act forced to the untried one there leaves the true candidate alone two steps on and then rests as the explorer's (`upRest`, `downRest`); a listing replaced by the true candidate there turns as `informed_turns` in up and keeps the known act in down; and the middle-above-high order, told, keeps the known act.

**The agents** (`scl_stage0.Agent`) answer each call from what its words show, with no state between calls, as a model called afresh. Eleven are read on the fast path, one seeded run each. The nine deterministic ones are asserted on all six verdicts; the two with draws only on the cells marked \*, the rest of their rows being that one run's reading:

| Agent | Its role | K | S | E1 | E2 | T after E1 |
|---|---|---|---|---|---|---|
| M, the witness (worst case, 8 > 5 > 2) | the law's formation | passed | passed | supported | supported | supported |
| O, the witness with 5 > 8 > 2 | the law's (`order_rests`) | passed | passed | supported | supported | no turn predicted |
| a prior-follower that never tries (acts as M) | permitted (LA3's) | passed | passed | supported | supported | supported |
| count lock (chosen most; tellings not taken in) | forbidden by exit 2 | passed | passed | supported | contradicted | contradicted |
| untrusting (M, tellings not taken in) | forbidden by exit 2 | passed | passed | supported | contradicted | supported |
| frame-inconsistent (O in courses, 8 > 5 stated) | forbidden by the turn | passed | passed | supported | supported | contradicted |
| prior-narrowing reader (0.1 a round; draws) | forbidden by K | contradicted\* | passed | supported | supported | supported |
| first-listed reader | forbidden by N4 | passed | contradicted | supported | supported | contradicted |
| optimist (tries at once) | the first exit taken | passed | passed | not testable | not testable | not ruled |
| declining every call | not testable | not testable (fewer than 10 start probes read), every verdict | | | | |
| late trier (O in courses, 8 > 5 stated, tries 0.9 a round from round 4; draws) | forbidden by N1 (rounds 4 to 8 over 2 and 3); no turn | passed | contradicted\* | supported\* | supported | unresolved\* (asserted not supported) |

The late trier's rate of trying jumps with the run's length, from 0 at rounds 2 and 3 to 0.9 from round 4, which bridge (ii) forbids: S contradicts it by N1's middle comparison (asserted), since every course has left the lock before round 9 and the later comparison is not read. Its T share alone would pass (its 95% lower bound is at least 0.5, asserted): only the twin's round 4, where it tries as often, keeps its trying from being read as a turn.

The count lock is `ChoiceCountCapture.counted_locks`' habit: under E1 its belief exits and it is not falsely contradicted there; under E2 it does not exit, and its act does not turn.

**The power, by simulation** (`scl_stage0.power`): each setting's courses drawn through every arm, read by the frozen rule, 100 runs a setting (resolution 0.01), the probe answering another of its three answers with chance 0.05. Shares of runs:

| Setting | Role | K contradicted | S contradicted | E1 supported | E2 supported / contradicted | T after E1 supported / contradicted |
|---|---|---|---|---|---|---|
| M trembling 0.02 a round | permitted | 0.00 | 0.00 | 1.00 | 1.00 / 0.00 | 0.85 / 0.00 |
| M trembling 0.05 | permitted | 0.00 | 0.00 | 1.00 | 1.00 / 0.00 | 0.91 / 0.00 |
| M trembling 0.1 | permitted | 0.00 | 0.00 | 1.00 | 1.00 / 0.00 | 0.85 / 0.00 |
| M trembling 0.2 | permitted | 0.00 | 0.02 | 1.00 | 1.00 / 0.00 | 0.63 / 0.00 |
| M trembling 0.4 | permitted (a high hazard at round 2) | 0.00 | 0.01 | 0.93 | 0.98 / 0.00 | 0.00 / 0.00 |
| M trembling 0.5 | permitted (a high hazard at round 2) | 0.00 | 0.01 | 0.66 | 0.67 / 0.00 | 0.00 / 0.00 |
| M trembling 0.6 | permitted (a high hazard at round 2) | 0.01 | 0.00 | 0.25 | 0.23 / 0.00 | 0.00 / 0.00 |
| O trembling 0.05; 0.1 | permitted | 0.00; 0.00 | 0.00; 0.00 | 1.00 | 1.00 / 0.00 | no turn predicted |
| epsilon-greedy, 0.1; 0.3 | permitted | 0.00 | 0.00 | 1.00 | 1.00 / 0.00 | 0.91; 0.81 / 0.00 |
| UCB1 | the first exit taken | 0.00 | 0.00 | 0.00 (not testable) | 0.00 / 0.00 | not ruled |
| Thompson sampling, prior one half | permitted | 0.00 | 0.00 | 0.63 | 0.75 / 0.00 | 0.29 / 0.00 |
| history-length explorer, 0.02 + 0.01 a round | forbidden by N1 | 0.00 | 0.31 | 1.00 | 1.00 / 0.00 | 0.93 / 0.00 |
| history-length explorer, 0.02 + 0.02 a round | forbidden by N1 | 0.00 | 0.81 | 1.00 | 1.00 / 0.00 | 0.77 / 0.00 |
| prior-narrowing reader, 0.02 a round | forbidden by K | 0.91 | 0.00 | 1.00 | 1.00 / 0.00 | 0.82 / 0.00 |
| prior-narrowing reader, 0.05 a round | forbidden by K | 1.00 | 0.01 | 1.00 | 1.00 / 0.00 | 0.87 / 0.00 |
| word reader, tries 0.05 more reworded | forbidden by N3 | 0.00 | 0.06 | 1.00 | 1.00 / 0.00 | 0.88 / 0.00 |
| word reader, tries 0.15 more reworded | forbidden by N3 | 0.00 | 0.86 | 1.00 | 1.00 / 0.00 | 0.90 / 0.00 |
| word reader, narrows reworded (0.1 a round) | forbidden by K (N3) | 0.88 | 0.00 | 1.00 | 1.00 / 0.00 | 0.91 / 0.00 |
| count lock, trembling 0.05 | forbidden by exit 2 | 0.00 | 0.00 | 1.00 | 0.00 / 1.00 | 0.00 / 0.89 |
| untrusting, trembling 0.05 | forbidden by exit 2 | 0.00 | 0.00 | 1.00 | 0.00 / 1.00 | 0.87 / 0.00 |
| M trembling 0.05, 5% of answers unreadable | permitted | 0.00 | 0.00 | 1.00 | 1.00 / 0.00 | 0.60 / 0.00 |
| M trembling 0.05, the exits at a true share of 0.55 | at the exits' boundary | 0.00 | 0.00 | 0.00 (contradicted 0.00) | 0.02 / 0.00 | not ruled |
| late trier, tries 0.6 a round from round 4 | forbidden by N1; no turn | 0.01 | 1.00 | 1.00 | 1.00 / 0.00 | 0.00 / 0.00 |
| late trier, tries 0.9 a round from round 4 | forbidden by N1; no turn | 0.00 | 1.00 | 1.00 | 1.00 / 0.00 | 0.00 / 0.00 |
| late trier, tries 0.3 a round from round 3 | forbidden by N1; no turn | 0.00 | 1.00 | 1.00 | 1.00 / 0.00 | 0.00 / 0.19 |
| late trier, tries 0.6 a round from round 3 | forbidden by N1; no turn | 0.00 | 1.00 | 1.00 | 1.00 / 0.00 | 0.02 / 0.00 |
| late trier, tries 0.9 a round from round 3 | forbidden by N1; no turn | 0.00 | 1.00 | 1.00 | 1.00 / 0.00 | 0.00 / 0.00 |

**The cost of K0 = 3** (section 1), the share of runs in which an exit is *not testable*, fewer than 10 locked courses in a world:

| Setting | E1 not testable | E2 not testable |
|---|---|---|
| M trembling 0.4 a round | 0.04 | 0.02 |
| M trembling 0.5 | 0.32 | 0.30 |
| M trembling 0.6 | 0.73 | 0.77 |
| Thompson sampling, prior one half | 0.35 | 0.24 |
| UCB1 | 1.00 | 1.00 |

Every permitted setting is contradicted on any verdict in at most 0.02 of its runs (the dry run asserts at most 0.05). The true exit share of 0.55 is the share named after the probe's noise (the setting names the true amount with chance 21/37, so that 0.025 + 0.925 × 21/37 = 0.55). At that share neither exit is contradicted in any run (asserted at most 0.02), and they are rarely supported (E1 in no run, E2 in 0.02): such a share is seldom told apart from 0.5 at 24 courses a world. The late triers' turn is supported in at most 0.02 of runs (asserted at most 0.05), since their twins try as often at round 4; their S is contradicted in every run (asserted at least 0.95): from round 4 by N1's middle comparison in every run (asserted at least 0.95), from round 3 by its third comparison in 0.95 of runs to every run (asserted at least 0.9). The late trier from round 3 at 0.3 a round, which takes the other option at round 4 less often than half, is contradicted on T in 0.19 of runs after E1 and 0.29 after E2: it is frame-inconsistent (8 above 5 stated, 5 kept), which the turn forbids. A trembler's T is often *not ruled* (0.09 to 0.15 of runs, 0.40 with unreadable answers): its stated choice trembles too, and C needs 8 of 9 in both orders. At 0.2 a round it is *unresolved* in 0.22 more, and from 0.4 a round never supported: the turn must exceed the twin's round 4, and the tremble brings the two together. What the power says: a history-length explorer whose rate of trying rises 0.02 a round (from 0.02 at round 2 to 0.4 at round 21) is caught 0.81 of the time, one rising 0.01 a round 0.31; a rate that jumps at round 4 from nothing to 0.6 is caught every time, and one that steps at round 3 to 0.3 every time; a word reader trying 0.15 more under the paraphrase 0.86, one trying 0.05 more 0.06; a reader narrowing 0.02 a round with no answer 0.91. A small effect of length or words is therefore not ruled out by a pass, and a pass says only that no effect of these sizes was seen. N1 has no power where the lock empties before the rounds it compares (section 4, *What S cannot read*): a rise after round 8 under a hazard of 0.4 a round or more, any rise of length under a hazard of 0.6 or more, a rise from round 4 in 0.81 of runs under 0.5, and a step at round 3 in 0.92 of runs under 0.5 and 0.54 under 0.4 are not read, and S's pass then rests on its other comparisons.

**Stage A, decided by argument: not a stage of its own.** FREEZE-9 and FREEZE-11 froze Stage A runs because their choosers had to be trained and their outcome was unknown before the run. Here the standard learners need no training and no words: on this game each is a few lines of closed form, so they are Stage 0 rows, run in the dry run in seconds, their readings above. What each is called: **tabular elimination with the worst case** is M, the law's formation (passed, supported); **epsilon-greedy**, a constant rate of trying, permitted (passed, supported); a decaying epsilon tries less as rounds pass, which S reports and never contradicts; **UCB1** tries the untried option at once (an infinite bonus), the first exit taken, so its exits are not testable; **Thompson sampling** with prior one half tries half the time while both candidates stand, a constant hazard, permitted, its exits often not testable for want of locked courses. None reads words, so none is a word reader; given a telling as an observation, each exits. A separate Stage A would release only these seconds of a core, already spent.

## 6. The run

`scl_run.py run --family PIN --max-usd USD` makes every condition at parallel 1; `--conditions C --parallel N` makes C's fresh calls at a parallel above 1. The calls are made, logged and checked by freeze 1's `run.execute`, imported unchanged, with its stops (a call no retry answers, another model answering, the catalog naming another snapshot, twenty filtered answers in a row, the spend guard, a request whose messages are not the frozen prompt). `--max-usd` is the folder's total over every start.

**The courses run at parallel 1** (FREEZE-10's edge). A course's call or probe reads, for each earlier free round of its course, the answer of that round's latest record logged before it (`scl_design.rounds`). The reading reads the lock at a record's round from those same rounds, the ones its own prompt showed, not from the latest records, so a course record whose earlier round was made again after it is classified by the text it answered (the dry run gives this a case). `run` refuses any arm at a parallel above 1 before any call. Calls made again by freeze 1's `resume` come in the plan's order, so an earlier round made again is logged before any later round that reads it. The reading rebuilds each record's prompt from the records logged before it, refuses a course record logged before an earlier round of its course, and **reports, never refuses**, any course record read whose rounds show an answer other than the one read for that round (`rounds_not_the_answers_read`), as FREEZE-5's dated note on its history condition says; the dry run gives the report a case it must flag.

**The log, the meta and the lock** are FREEZE-5's, imported from `tr1_run` unchanged: the line writer, the whole meta, a log cut short and `mend`. The pin's lock is on `results/scl/<pin>.lock`.

**The frozen check** (`scl_design.frozen`): SCL's own first (`own_check`: the hash file is there, lists every file the freeze requires, and each has its bytes), then FREEZE-10's (freeze 1's chain, FREEZE-5's, FREEZE-10's), then freeze 1's chain check of this folder (the hash file committed once, never changed, each file committed unchanged). **Python**: every module of the folder refuses `python3 -O`, and each imported module is checked to resolve to the file the hashes list.

## 7. The reading

`scl_run.py verdicts --family PIN` writes `verdicts.json` beside the log, **once**. It reads through freeze 1's `verdicts.load`, given SCL's plan, the parser and SCL's frozen check, so every refusal of freeze 1's reading holds: an enlarged log, a record whose fields, prompt, letters or request are not its id's, a logged answer the parser does not read from its response, a record answered by another model, a record logged again after a good one. It also refuses:
- a run not read whole: every condition's every call read between good catalog reads (the LA4 lesson; `status` shows what is left, writing nothing);
- a readout already there;
- a family off the frozen pins.

Once the readout is written, `run` and `smoke` refuse for that pin, so no reading is followed by more calls. The readout holds the pin's reading (the premise, K, S, E1, E2, T with every comparison, bound and count, and the descriptive part), section 13's expectation for the pin, the course records whose rounds are not the answers read, the served models, the calls made again, every start of `run`, every line `mend` moved, and every catalog read.

## 8. The smoke run, the readability rule and an addendum

**The smoke run.** `scl_run.py smoke --family PIN --max-usd 1` makes 54 calls a pin: C, two calls in each name order; each arm, one course in each name order (up in order 0, down in order 1) through round 4, with probes before rounds 2 and 4. Its amounts are FREEZE-10's smoke amounts, 1, 4 and 7 dollars, so no smoke answer previews a verdict. It passes where every call is made, every response names the pin under the frozen snapshot, the logs read whole, and no call was rejected or filtered by the provider or cut by the token limit; any of these is a stop of the run, lifted by a later smoke run that passes. `smoke` is refused where the latest smoke run on these frozen files passed and the readability rule lets the run start: another could release nothing.

**The readability rule** (FREEZE-8's form). An unreadable answer (invalid, filtered, or "none") takes a course off the lock's course, so a pin whose answers cannot be read loses its courses whatever it chooses. The rule counts every SCL call of the pin made under freeze 1's client in force, answered by the pin under its snapshot, in every smoke run and the scored log, and takes the unreadable rate at its one-sided 95% lower bound; `run` starts only where, at that rate, at least 0.8 of a short course's seven calls would all be read. It reads whether answers can be read, never what they choose. Its exact chance of stopping a pin:

| Unreadable rate | 0.5% | 1% | 2% | 3% | 5% |
|---|---|---|---|---|---|
| at the smoke run (54 calls) | 0.00001 | 0.0002 | 0.004 | 0.023 | 0.13 |
| after 400 calls | 0.0 | 0.0 | 0.0002 | 0.020 | 0.53 |

A stop stands while the calls show it; only further calls of the pin pooled with the rest, or a link changing freeze 1's client, can lift it, as FREEZE-8 says.

`run` releases the conditions asked where the latest smoke run, made on the run's own frozen files, passed, the readability rule lets the pin start, no readout is written, and some condition asked is not read whole. One command of a pin at a time.

**An addendum.** This freeze has no client of its own. A stop the client causes is mended by an addendum to freeze 1, which makes this folder refuse until it lands one of its own (`lock-scl/addenda/ADDENDUM-k.md` with `FROZEN-k.sha256`), changing only freeze 1's client and a pin's `served_as`, as freeze 1's own addendum changed them, and this freeze's dry run and its result (`MAY_CHANGE`). An addendum may change no arm, word, plan, threshold or rule.

## 9. Void, unresolved, not testable, and stopping

- **No reading**: a run not read whole, or one the frozen check, the pins or the reading refuse. Nothing is written.
- **Not testable (fewer than 10 start probes read)** or **not testable (the start does not list both)**: the premise fails, the first where the pin declines, refuses or cannot be read at the start (the unread count reported), the second where it begins from a prior. Every verdict of the pin is not testable, with that reason; the descriptive part is reported.
- **Not testable**, per verdict: K or S with no comparison read; an exit with fewer than 10 locked courses with a read probe in a world (the lock left by trying: the first exit taken); T with fewer than 10 locked courses in up.
- **Unresolved**: an exit or a turn neither contradicted nor supported: its bounds straddle 0.5, or its support over its twin is not shown.
- **Not ruled**: T where the exit was not supported or C is not strict at 8 (or, at 5, *no turn predicted*).

**Stopping.** The plan is fixed: every call of every arm, in the plan's order, whatever is answered; no arm stops early on an outcome, and nothing is read before the readout. A run stops only by freeze 1's stops and the spend guard, and resumes from where it stopped. A pin the readability rule stops is reported with the reason and makes no further scored call until the rule lets it start.

**Refusals**, each exercised by the dry run (section 10): `FROZEN.sha256` missing (this folder today), naming a wrong hash, or not listing a required file; any module under `python3 -O`; a readout already there; a run not read whole; an enlarged log; a logged prompt or answer not the one its call rebuilds or its response gives; a course round logged before the round it shows; a course call whose earlier round has no record; a family off the frozen pins; the arms at a parallel above 1; an unknown condition; a run before a smoke run, after a stopped one, after the readout, or where the readability rule stops; a second command while one holds the pin's lock.

## 10. The dry run

`python3 -B lock-scl/scl_dry_run.py` runs the frozen code path end to end with no model call, no key and no network, in about a minute and a half of one core on this machine, and writes `lock-scl/results/dry-run.json`, the same bytes on every run (it holds no time and no temporary path; two runs were compared byte for byte). Every figure above is from it. It records the hashes of every file it fixes at its start and its end, and asserts that each imported file has the hash of FREEZE-10's newest link and of the newest link of the freeze that owns it (freeze 1 for `told/`, `tr8.py` and `tr_rr.py`; FREEZE-5 for `told-tr1/`, `tr1.py` and `tr1.json`).

- **Stage 0**: the mirror, the eleven agents asserted, the power of section 5 (each setting's verdicts, the comparisons contradicting and the comparisons not read, as shares of runs, and for the late triers from round 3 S as round 2's rule read it, section 4), the calls each arm adds, the readability rule's chances.
- **The rule at its edges**: an unread probe planted in E1's and N2a's probes before round 4 counts as one missing; a K fall of exactly 0.2 (12 of 15 against 240 of 240) and an S rise of exactly 0.1 (104 of 624 against 20 of 300), each below its p, contradict, where floating point reads them below the threshold; the exact bound tests agree with the bisected bounds on 5,670 cases; a round-4 record that showed round 2 known, round 2 made again after it as the other option, is at risk at round 4 by the rounds it showed; an S contradiction with every matching K comparison read and none contradicting is laid on bridge (ii) where the listing is unshifted, and on (i) or (ii) where N2a's probes name 8 and B's name 2 more often, each by less than K's 0.2; the exact Fisher-Freeman-Halton p equals a direct sum on four tables.
- **The words**: every planned call of the three pins, 2,898 each, built from stand-in records and parsed back from its words alone, the parse equal to the view the agents answer from; the options line after a telling in exactly E2's and N2b's calls after round 3 (1,440 on the three pins, 7,200 others); the fast path's views equal to these on every call of one run; the 2,212 world checks and 3,000 paraphrase pairs of section 2; B's words equal FREEZE-10's at its length, and C's FREEZE-10's.
- **Agents through the harness**: nine agents answering every call through freeze 1's `execute`, FREEZE-5's line writer, SCL's builder and a stand-in client that reads only the words; each log read by SCL's `verdicts`. Five deterministic agents (M, O, the count lock, the first-listed reader, the declining agent) are asserted on all six verdicts and equal to the fast path; the prior-narrowing reader, which draws, is asserted on K; a history-length explorer (0.02 + 0.04 a round) and a word reader (0.3 more reworded) are asserted contradicted on S; M trembling 0.05 is asserted to pass K and S and to support both exits.
- **Refusals**, 14, each by its own reason: section 9's reading and freeze refusals, and the rounds report flagging the one record it must.
- **The commands**, 15, in a stand-in folder through a stand-in client, catalog and frozen check: a run before any smoke run is refused; a smoke run passes, 54 calls projecting 2,898, and another is refused; the arms at parallel 4 and an unknown condition are refused; C is made at parallel 4; the arms are killed after 750 calls, the readout refused as not read whole, the calls log's last line and the catalog's last read cut, `run` refused, `mend` run, and the run resumed at parallel 1 to 3,048 records, 150 calls made again, no round showing an answer other than the one read; the readout written, a second refused, and `run` and `smoke` after it refused; a second pin's smoke run with one answer in six unreadable passes its stops and is stopped by the readability rule, and its `run` refused; a third pin's smoke run stopped by a filter, and its `run` refused; a command while another holds the lock refused.

## 11. Usage and what Ren's yes releases

**Calls per pin, exactly** (`scl_stage0.call_counts`):

| Condition | Calls | Of them, acts | Probes | What it controls |
|---|---|---|---|---|
| C | 18 | | | the stated order, for T |
| B | 1,200 | 960 | 240 | the lock; N1, more rounds; N2's base |
| E1 | 336 | 192 | 144 | the first exit |
| N2a | 336 | 192 | 144 | E1's twin; N2, an answer of the known kind |
| E2 | 336 | 192 | 144 | the second exit |
| N2b | 336 | 192 | 144 | E2's twin; N2, a telling not of the world |
| N3 | 336 | 192 | 144 | rewording |
| N4 | 0 | | | the name order, read within the arms |
| **a pin** | **2,898** | | | and 54 smoke calls |

On the three frozen pins, 8,694 calls and 162 smoke calls. **N5**, a model of another size in a deciding family, adds a pin: 2,898 calls more, and its own money. The pin proposed is `qwen/qwen3.8-flash`, the smaller sibling of `qwen/qwen3.8-max-0902`, which PINS.json's own record names as a VD1 valuer (it answered that test's prompts and read nothing of the theory). It is **not run under this freeze**: freeze 1's PINS.json can change, by an addendum, only a pin's `served_as`, so a new pin needs a freeze of its own, reading the pin's dated slug and prices from the public catalog, with no key, before any call; `scl_run` refuses any family not among freeze 1's pins. For N5 the "nothing else" claim covers belief changing with no try and no reading, never the act of trying: a larger model that tries more has taken the first exit.

**The estimate before any call** (`scl_run.estimate`: the text's characters at four a token, 50 to 1,000 output tokens a call, the listed prices):

| Pin | Tokens in | Of them, B's | Cost |
|---|---|---|---|
| google/gemini-4-argon (decides) | 0.64M | 0.33M | $2.72 to $30.25 |
| qwen/qwen3.8-max-0902 (decides) | 0.64M | 0.33M | $2.14 to $18.66 |
| anthropic/claude-sonnet-5.5 (reported apart) | 0.64M | 0.33M | $2.72 to $30.25 |

So $7.58 to $79.16 on the three pins, and N5's pin at its own listed prices. A course's rounds are counted at their longest line. The smoke run measures it, and each pin's `--max-usd` is set from its projection.

**Ren's yes would release**, through OpenRouter with his key, on each pin he names among the three:
1. SCL's smoke run, 54 calls, held under $1 by its spend guard, reading no outcome;
2. then the conditions it releases: C's 18 calls (any parallel) and the six arms' 2,880 (parallel 1), under one spend guard for the pin's folder, set from the smoke run's projection.

Separately, and only with a new freeze: N5's pin, 2,898 calls and 54 smoke calls, new money. Nothing is downloaded, and the logs and the readout are kept whatever they show. SCL shares freeze 1's client with every RF freeze, so the safe order is freeze 1's smoke runs first, as FREEZE-5 §10 says for TR1; SCL needs nothing of FREEZE-10's runs, and reads none of them.

## 12. What changed from the claim and the reader's design, and what was chosen

From the plan's sentence and [the reader's report](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/refuters/readers/lock.json):
- **"Nothing else" narrowed** to the exact reading of the first part; a spontaneous try is the first exit taken, never a forbidden case, so S reads rate differences between arms, never a rate.
- **Its own freeze**, not an addendum to TR1A: FREEZE-10's files are imported unchanged at its hashes, so no shared harness changes.
- **One announced length, 21 rounds**, for every arm, so that "more rounds" is read from one start; the reader's "10 and 30 free rounds" would have been two starts (section 1).
- **The premise per pin, not per course.** The reader's design voids a course whose own start probe does not name both. But the probe is a separate call with its own seed, and every course's start shows one text, so one course's draw says nothing of its own later calls; a per-course premise would select courses on sampling noise. The premise reads the share of start probes.
- **N2 as two twins** (an assigned known round; a telling of the known), not "extra rounds of the known option at 5" or a summary: in B the locked courses' later rounds already are more answers of the known kind, so the twins isolate what remains, the assignment and the telling.
- **E2's telling after round 3, round 3 assigned known**, so that E1, E2 and their twins differ only at round 3, and each exit's first choice after it is round 4.
- **One paraphrase**, not two: one more arm costs 336 calls a pin; the reader may ask for a second.
- **N5 a new pin under a freeze of its own**, since freeze 1's chain cannot add one.
- **No temperature 0**: freeze 1's client sends default sampling, so rate invariance throughout, its power stated.
- **One-sided S and K**: a control that lowers the hazard, or raises the share naming "either", is reported, never a contradiction.
- **Thresholds**: ALPHA 0.01 a verdict, DELTA_K 0.2, DELTA_S 0.1, 12 courses a cell, chosen from Stage 0's power; at ALPHA 0.05 a trembler at 0.2 a round was falsely contradicted on S in 0.04 of fifty runs of a trial setting, which this freeze judged too often for two deciding pins. Every verdict's contradiction, the exits' and the turn's included, is read at ALPHA with its multiplicity; supports at 95% bounds and over the twin (section 4).
- **Stage A folded into Stage 0** (section 5).
- **Left out**: the third exit (the world moving), a false telling, an onset arm, a SignLoop game, a judge of free text (section 1).

## 13. Expectations, stated before any call

This is an AI expectation, the author's, not the account's prediction. The lock forms on every pin read: told only that the other option pays 8 or 2, and paid 5, most courses keep the known option at round 2, as language models in context have been reported to explore little without help (Krishnamurthy and others 2024). Both exits are supported on every deciding pin: shown 8 or 2, or told it, a model states it. The turn after each exit is supported in up where the pin's stated choice puts 8 above 5. Nothing is expected of K or S: whether a long history of the known option, or rewording, moves a model's stated belief or its trying is what they read. Coded (`scl_rule.expectations`) as: the lock forms (at least half of E1's and E2's courses in the lock at round 3), E1 supported, E2 supported; reported in each readout, never a verdict. Whatever the run shows is kept, and this paragraph is not revised after it.

## 14. Provenance and the reading of the freeze

Drafted on 5 November 2026 by a Claude Code session, as a step of a workflow the coordinator ran for the atlas's refuters (AA §7), from the reader's report on this test and the freeze practice's report (`refuters/readers/lock.json`, `freeze.json`), on FREEZE-10's game and freeze 1's harness. No model was called, no key used, nothing downloaded; the dry run and Stage 0 ran on this machine. The author read in full: the two reports; `ReadingLoop.lean` lines 100 to 130 and 540 to 1001; 03 §12's statement and reading; the record's laws, does-not-show and next; FREEZE-10 and its `tr1a_design`, `tr1a_run`, `tr1a_dry_run` and `write_frozen`; freeze 1's `client` and `PINS.json`, and `run.py`'s execute, chain, frozen check, resume and sink; `verdicts.load`; FREEZE-5's folder functions used; `tr1.py`'s Untested mirror; FREEZE-11's frozen check. FREEZE-1, FREEZE-8 and REST-TR1 were read in the parts cited (the readability rule, the spend guard, REST-TR1 §8).

**The freeze's readers.** Readers other than the author read it in rounds: a full read first, then the same reader on each diff, at most five rounds, stopping at the first with no finding of high or medium severity; [`lock-scl/REVIEW-FREEZE.md`](lock-scl/REVIEW-FREEZE.md) records each round, each finding and how it was taken. Round 1, a full read with the code run, found one high, five medium and eight low findings; round 2, on the diff, two medium and two low; round 3, on the diff, one medium and four low. Every one was taken (5 November 2026), and the next round reads the diff. Every reader the session can call is of the theory's own family; the deciding pins' families have read nothing here.

A later edit of this file is allowed only for a link or a typo, or to correct a false statement to a reader, each as a dated note that changes no rule, size or reading. A fault found later is fixed by an addendum (section 8) or by a new freeze.

## 15. The hash file

`lock-scl/write_frozen.py REPO` writes `lock-scl/FROZEN.sha256`, the base link of SCL's chain: the sha-256 of every file the first part lists, paths repository-relative, sorted. It refuses unless the dry run passed and recorded the files' hashes now, unless each imported file has the hash of FREEZE-10's newest link and of the newest link of the freeze that owns it (freeze 1's for `told/`, `tr8.py` and `tr_rr.py`; FREEZE-5's for `told-tr1/`, `tr1.py` and `tr1.json`; each newest link read from the files there, the base and then each addendum's link; the chains themselves are checked at run time by freeze 1's `frozen_check`), and where the hash file is already there. The sequence: commit the design, code and dry-run result; on the merged tree, run the dry run, read the freeze in rounds, render, pass `make gate`; then run the writer and commit `FROZEN.sha256` once, last of the content. Not run yet.

## For the readers: the decisions open

1. **The board.** No row claims SCL; the coordinator claims it (AA's, or a row of its own) before landing, as the board's rules ask.
2. **The plan's sentence.** Whether AA PLAN line 384's "nothing else should" takes a narrowing erratum in the first part's words, so that no reader takes the Lean to forbid spontaneous exploration.
3. **N5** (Ren's, new pin and new money): whether a sibling of another size is wanted, which (`qwen/qwen3.8-flash` proposed; a Google sibling would serve as well), and its own freeze.
4. **The Anthropic pin**: reported apart, $2.72 to $30.25; whether it is run at all is the release's choice.
5. **The sizes**: 12 courses a cell, one paraphrase, ALPHA 0.01, DELTA_S 0.1. A history-length effect of 0.01 a round is caught 0.31 of the time; raising the cell to 20 courses would cost about 1,900 calls a pin more.
6. **The premise per pin** (section 12) departs from the reader's per-course premise, by argument; a reader may hold otherwise.
7. **One-sided S**: a falling hazard of trying (a finite-horizon chooser) is described, not ruled; whether a two-sided stationarity verdict should be added.
8. **K's base**: K compares later probes with the start probes of all five arms sharing one start; a reader may prefer each arm's own start (less precise, no shared base).
9. **The dry run's length**: about a minute and a half, almost all the power's 2,900 simulated runs; fewer runs would lose resolution.
10. **The home line**: the record's next ("a frozen test predicting when a learner stops trying what its model ranks low") asks for the onset, which this freeze describes and does not test; the landing's history line should say so.

**Corrected after the freeze, 9 November 2026** (board item RW). The header said "not yet reviewed by a person", a claim the repository cannot support and [the word of 8 November 2026](../../sources/15-codex-theory-conversations/2026-11-08-ai-briefly-and-read.md) asks the work not to make; it now says that no person's review of it is recorded. This file's rule allows a later edit for a link or a typo, or to correct a false statement to a reader; the header's claim is not shown false, only unsupported, so this note is added by argument, as [FREEZE-1](FREEZE-1.md)'s corrections of its header are: it corrects what the header says of review, not the design. It changes no rule, threshold, size or reading; the frozen text is the one at the freeze commit.

**Since the freeze, 9 November 2026** (board item RW). A note, not an edit: the header's "which is not yet written" and section 9's "(this folder today)" were true when written; `lock-scl/FROZEN.sha256` was written at the freeze, by commit `b88e3098a` of 5 November 2026. No model has been called with these prompts. Nothing else changed: no rule, threshold, size, reading or frozen file.
