# Freeze 11: TR2's Stage A, small networks trained on the read occasions

*The folder's eleventh freeze, board item TR2A, 5 November 2026. AI-written (a Claude Code session); no person's review of it is recorded. Frozen before any training of the plan was run: the code was timed and tried on seeds the plan does not use (§7). The machine time is Ren's. About 20 to 25 minutes to read, at 100 to 130 words a minute; the part before §1 takes 5 to 7.*

TR2 measures RF2, what readings fix of the unread ([DESIGN](DESIGN.md), [REST-TR2-TR7](REST-TR2-TR7.md)). Its Stage B, on four open-weight checkpoints, is frozen in [FREEZE-7](FREEZE-7.md). Stage A, which FREEZE-7 left out, is the design's "small networks trained, by a standard-library script, only on the read occasions of each schedule, every state readable: the chain measured link by link, and whether training installs a twin, which RF2 does not predict (realizability). Reported, no verdict." This file freezes it: [`train-tr2a/tr2a.py`](train-tr2a/tr2a.py) trains and measures, [`train-tr2a/tr2a_dry_run.py`](train-tr2a/tr2a_dry_run.py) checks the code without training any network of the plan, and `train-tr2a/FROZEN.sha256`, committed last, holds the hashes of both, of the dry run's result (`results/dry-run.json`, the same on every run of the dry run; its timing goes to `results/dry-run-time.json`, which is neither hashed nor committed) and of Stage 0's [`tr2.py`](tr2.py), which the code imports.

## What is frozen, and what it can refute

Nothing of the law. Stage A is a measurement on a class of trained systems, reported without a verdict, as the design says. Three cases are forbidden by the Lean ([`Unread.lean`](../integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Unread.lean)), and each is counted in every training, F1 and F2 at every pair of occasions, F3 at every unread occasion:

- **F1, acts apart with states exactly equal.** `state_apart_of_acts_apart`: an act that reads the state alone cannot differ where the states are equal.
- **F2, states apart with inputs equal.** `coupling_apart_of_state_apart`: a state that reads the input alone cannot differ where the inputs are equal.
- **F3, for the content-only network, an unread occasion acting otherwise than a read occasion of the same content.** `Learning.lumped_determines` with the lumping the content: a law reading through the content and agreeing at every read occasion acts there as the read occasion of its content does.

The code meets each by construction (the network's act reads its hidden layer, its hidden layer reads the input, and the content-only network's input is the content's vector), so a count above zero shows a fault of the implementation, not of RF2. The dry run plants each fault and finds it counted (§6).

What RF2 does not predict, and Stage A reports: whether training installs a twin, how often, and under which schedule. A trained network that acts as the content act at every read occasion and otherwise at an unread one whose lump holds no read occasion is a twin of the content act. `Learning.twin_selected` says only that, among the laws a selection through agreement at the read occasions takes, some reading through the lumping take any value at such an occasion; that a trained network is such a selected law is the hypothesis, not something the run measures (as FREEZE-7 says of its own), and nothing says training finds one.

**What is settled before the run.** The couplings, the states' equality and the coverage are fixed by the architecture and the schedule: the content-only network's input is the content, so its states at a content's occasions are equal; the content-and-cue network's input differs at the cue, so its states there differ (barring an exact coincidence of floats, which the run would show); and coverage is then the schedule's coverage under the input lumping, by this argument (the dry run checks it for networks whose state is their input, not for trained ones). What the run measures is the acts: acts apart at the cue, the twin at the cue, an unseen content's act, and the changed share.

## 1. The occasions, the contents and their acts

Occasions are (cue, content, copy), as in Stage 0: 64 contents, the cue up or down, three copies of each input that do not couple in. Each content has a vector of 8 numbers, drawn once from a seeded Gaussian, and two content acts are tried in turn:

- **linear:** 1 where one fixed direction's projection of the vector lies above its median, so 32 contents act 1;
- **xor:** 1 where exactly one of two fixed directions' projections lies above its median (26 act 1), a parity, which the linear act is not.

The content act is the label a reader of the content alone expects at every occasion.

## 2. The networks and their training

One hidden layer of 16 tanh units and a sigmoid output; the act is 1 where the output exceeds 1/2, so the act reads the hidden layer alone, and the hidden layer is the state. Two architectures:

- **content-only:** the input is the content's vector; the cue does not couple in;
- **content-and-cue:** the input is the vector and the cue (1 up, 0 down); the cue couples in.

Each network is trained by full-batch gradient descent on the mean cross-entropy, 400 epochs at rate 0.5, from weights drawn by its seed, on the occasions its schedule reads and on no other, with the content act as the label. Identical read inputs enter once, weighted by their number: the copies, and for the content-only network a content's cue-up and cue-down occasions, whose inputs are one. A network's initial weights depend on its seed and architecture only, and its read set on its seed and schedule only, so the conditions with one seed are paired.

## 3. The schedules

The three schedules of Stage 0 ([REST-TR2-TR7](REST-TR2-TR7.md), coverage by schedule):

- **S1** reads exactly the cue-up occasions, the witness's schedule, where the schedule is the cue;
- **S2** reads each occasion with chance 1/2, apart from the cue;
- **S3** reads every cue-up occasion and each cue-down occasion with chance 1/4.

The chance draws are seeded by the training's seed, apart from the network's weights.

## 4. The plan

Every combination of the two content acts, the two architectures and the three schedules, 20 seeds each, the seeds 100 to 119: 240 trainings, in a fixed order. Each is passed every one of the 384 occasions after training.

## 5. The measures, reported without a verdict

For each training:

- **fits the readings:** whether it acts as the content act at every read occasion;
- **the chain, link by link**, at each unread cue-down occasion against the cue-up occasion of the same content and copy, the cue toggled alone: couplings apart (the inputs differ), states apart (the hidden layer differs, compared exactly as Python floats), acts apart; and how far the toggle moves the output, its mean and largest. Under S1 the cue is the schedule, so these are the links between unread and read; under S2 and S3 the cue-up partner may itself be unread, and the links measure the cue's reach, not reading's;
- **coverage:** the share of unread occasions whose state equals some read occasion's state exactly, the lumping as measured; Stage 0's expectation (`tr2.coverage_exact`) is reported beside the mean over seeds;
- **a twin at the cue:** among the unread occasions not covered whose content is read at some occasion, the share at which a network that fits the readings acts otherwise than the content act; for a network that does not fit the readings none is counted (the readout gives none, not 0, and says how many trainings did not fit);
- **an unseen content changed:** under S2 a content may be read at no occasion; the share of such occasions acted otherwise than the content act is generalization, reported apart from the twin;
- **changed:** the share of unread occasions acted otherwise than the content act; under S1, with the read and unread contents matched, this is the misled share of a reader whose class reads the content alone (Stage 0's "a reader misled"), which has no Lean;
- **the forbidden cases** F1 to F3, counted.

The readout gives each of these for every training and, per content act, architecture and schedule, every seed's value; the twin's median and the number of trainings with any twin at the cue; the coverage's mean over seeds, beside Stage 0's expectation (an expected count over an expected count, so the two are near, not equal); and the sums of the chain's links and of the forbidden counts.

## 6. The dry run

[`tr2a_dry_run.py`](train-tr2a/tr2a_dry_run.py) runs no training of the plan; [`results/dry-run.json`](train-tr2a/results/dry-run.json) holds its result (37 checks, all passed). Through the code's own functions it checks:

- **the plan:** 240 distinct trainings, none on a seed below 100; the act counts, 32 and 26; each schedule's read sets, S1 exactly the cue-up occasions, S3 holding all of them, and S2's and S3's draws differing between all 20 seeds; and it records the content vectors' hash;
- **the forbidden cases, planted:** F1 counted by a network whose act reads more than its state, F2 by one whose state reads more than its input, F3 by a content-only architecture the cue leaks into, and none by a network acting as the content act;
- **a planted twin:** a network acting as the content act with the cue up and otherwise with it down is, under S1, a twin at the cue at all 192 uncovered occasions, its acts apart at all 192 pairs; under S2 it acts otherwise at read cue-down occasions, so it fits nothing and counts no twin; under the content-only input it counts none;
- **coverage:** for each architecture and schedule, the measured coverage equals the read set's own, recomputed apart from the network; Stage 0's `coverage_exact` agrees with its enumeration;
- **the run:** a training is the same twice; a run on a small plan writes its readout, and a second one refuses;
- **the refusals:** no `FROZEN.sha256`; one not listing a required file; a frozen file changed or missing; `FROZEN.sha256` itself uncommitted; a listed file not committed; `FROZEN.sha256` committed twice (a second commit would make a new freeze); another platform; `python3 -O`; and that the required paths exist under the repository's root (`tr2a.py check` reads the real file at the landing);
- **the time** (in `results/dry-run-time.json`): one training at the plan's sizes, on a seed outside the plan, took 0.81 s; the 240 trainings are projected at 194 s on this machine, under its load.

## 7. What was run before the freeze, and what changed from the design

While the code was written, the author trained seeds 0 to 3 of each condition (48 trainings), to time it and see that the networks fit; the dry run trains networks on seeds −1 to −3, at 5, 20 and 400 epochs, for its checks and its timing, and reads nothing of their acts but those checks. Their outcomes are known to the author: every training fitted the readings; no forbidden case was met; under the linear act no training installed a twin at the cue; under the xor act, with the cue coupling in, some did, in 2 or 3 of the 4 seeds of each schedule. So the plan's seeds are 100 to 119, which no one has trained, and §8's expectation is stated with these outcomes in view. The sizes, the rate, the epochs, the data seed and the schedules were set once, before any training, and not changed. Two things were changed after the first trainings: the xor act was added after the linear act's first trainings showed no twin, so that the measure meets a parity, and both stay in the plan; and the twin was split from generalization, after S2's first trainings counted as twins acts at contents read nowhere, which the twin's definition does not cover.

From the design, the freeze chose:

- the sizes (64 contents of 8 numbers, three copies, 16 hidden units, 400 epochs) and the two content acts;
- two architectures, the cue coupling in or not, which set the lumping by construction;
- the twin counted where the content is read and only the cue keeps the occasion's lump unread, generalization to an unread content reported apart;
- 20 seeds a condition, as TR7's Stage A; no test, since the design asks for none;
- the platform pinned (Python 3.11 on arm64 macOS), since exact equality of states is a comparison of floats.

## 8. An expectation, stated before the run

[AI expectation, with the development runs of §7 in view. Not a prediction of the account, which predicts nothing of these networks.]

- No forbidden case is met.
- Every training fits the readings.
- The content-only network: coverage 1 under S1 and S3, about 31/32 under S2; no twin at the cue, since there is none to install; its acts at unread occasions are its read acts.
- The content-and-cue network: states apart at every pair; coverage 0 under S1, and near Stage 0's 3/4 and 7/16 under S2 and S3.
- Under the linear act, few or no twins at the cue; under the xor act, twins at the cue in a part of the seeds, fewer under S3, which reads some cue-down occasions, than under S1.

Whatever the run shows is kept, and this paragraph is not revised after it.

## 9. The run, and what Ren's yes releases

`python3 -B train-tr2a/tr2a.py run`, from a checkout where the freeze is committed, on Python 3.11 under arm64 macOS. It refuses unless `FROZEN.sha256` lists the four files, each has its bytes and is committed unchanged, `FROZEN.sha256` has one commit, the platform is the one named, and no readout is there; the readout records the freeze commit and HEAD. It makes the 240 trainings in order, in one process, and writes `train-tr2a/results/run.json` once, whole (a temporary name, synced, renamed). It is deterministic: a run stopped part way leaves nothing and is begun again from nothing, with the same result. `python3 -B train-tr2a/tr2a.py check` checks the freeze and the platform and writes nothing; it passes on the merged tree once `FROZEN.sha256` is committed, a step of the landing.

**What his yes releases:** about 194 seconds of one CPU core on this machine (the dry run's projection); no download, no model call, no key and no money. The readout is kept whatever it shows.

## 10. Provenance and the reading of the freeze

Written by the Claude Code session that holds board item TR2A, at the merge coordinator's offer, after the same session froze TR2's Stage B (FREEZE-7). One reader other than its author read the frozen files in two rounds before the freeze landed: the first found six medium findings, all taken, the second nothing high or medium. Its findings, and how each was taken, are in [`train-tr2a/REVIEW-FREEZE.md`](train-tr2a/REVIEW-FREEZE.md).

**How this file is frozen:** by the commit that adds `train-tr2a/FROZEN.sha256`, its text there being the frozen one. It is not hashed, so that a link can be repaired without touching the code's hashes. A later edit may only repair a link or a typo, or correct a false statement to a reader; each is listed in a dated note at the end of this file and changes no rule, size or reading. `FROZEN.sha256` is committed last, after the render and every check pass on the merged tree.

**Corrected after the freeze, 9 November 2026** (board item RW). The header said "not yet reviewed by a person", a claim the repository cannot support and [the word of 8 November 2026](../../sources/15-codex-theory-conversations/2026-11-08-ai-briefly-and-read.md) asks the work not to make; it now says that no person's review of it is recorded. This file's rule allows a later edit for a link or a typo, or to correct a false statement to a reader; the header's claim is not shown false, only unsupported, so this note is added by argument, as [FREEZE-1](FREEZE-1.md)'s corrections of its header are: it corrects what the header says of review, not the design. It changes no rule, threshold, size or reading; the frozen text is the one at the freeze commit.
