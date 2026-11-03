# Ren: run LA4's Stage A, on few CPUs; add the prior-work note; land the results

3 November 2026, from about 10:10 to 14:00 (Asia/Bangkok, UTC+7). Ren's words in a Claude Code desktop session in `/Users/ren/theories` ("Unification and coherence progress (fork 3)"), the session that froze LA4's Stage A. AI-authored context is labelled separately.

## Context (AI-authored)

Stage A of LA4 ([the design](../../experiments/drain-beyond-the-reward/DESIGN.md)) had been frozen at `3dc87cf88` and landed on main, its run listed on the board's Decisions as one yes, since machine time for runs is Ren's. Ren first asked what the work would do and what it tried to achieve, and the session explained the test: whether small policies trained by gradient drain a dependent outside their reward as they near the reward's optimum, and only where it shares units with what is rewarded. Ren then gave the yes, below. While the run went, Ren asked for the training design and why it would work, and then whether this was already known.

## Ren's words

> explain what will this work do and what are you trying to achieve?

> alright, let's start, but don't use all the cpus - other sessions are also running

> oh explain your training design and why it would work

> haven't people already figured this out? must be existing researches? and for me, i have the same intuition from machine learning, even though i never tried to prove this

> sure

(To the offer of a literature search.)

> Yes, add the note

(To the offer of a note on prior work beside the frozen design.)

> Yes, land them

(To the question whether to land the results on main.)

## What was done (AI-authored)

- **The run.** `nice -n 10 python3 -B run.py --jobs 2` with Python 3.13.3 and numpy 2.4.2, from the frozen commit: two jobs at low priority, not ten, so that other sessions kept the machine. 480 runs in about two hours, then the frozen `analyze.py`. Nothing was downloaded.
- **The prior-work note** ([PRIOR-WORK-2026-11-03.md](../../experiments/drain-beyond-the-reward/PRIOR-WORK-2026-11-03.md)), written while the run went. It records a search, not a reading in full: the law for optima is known (Zhuang and Hadfield-Menell 2020), and the locus is contested by work on language models (emergent misalignment from reward hacking); no study found tests the split on one condition as LA4 does. 05 §7 names those rivals beside its outside evidence.
- **The results** ([LA4's README](../../experiments/drain-beyond-the-reward/README.md#the-result)) are stated in T3's home (05 §7), 08's thesis table, the overview, README's first screen, the collective page, the one argument, the alignment dossier and the development pages that said Stage A had not run.

## How the AI reads it (AI-authored)

"Don't use all the cpus" set the run's parallelism, not its design: the frozen rules do not depend on how many jobs run at once, and each run's seed fixes its numbers.

Ren's intuition, that this is what machine learning would lead one to expect, is the design's own caution (§1): for policy gradient the pattern largely follows from the update rule, so a pass shows that shared representations did not break it, not a law. The search found that the expectation is common and that the split on one condition, with and without shared units, had not been tested so. What the run adds that the intuition did not settle is where it did not resolve: the site that nothing rewards rose in both neural families, the control's too, and the locus is unresolved.
