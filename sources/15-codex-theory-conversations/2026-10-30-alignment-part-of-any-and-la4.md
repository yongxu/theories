# Ren: the theory as a part of any alignment; design LA4

30 October 2026. Ren's words in a Claude Code desktop session in `/Users/ren/theories`. AI-authored context is labelled separately.

## Context (AI-authored)

Ren first asked how the finished theory could be used to train better-aligned AI. The session answered from the alignment dossier (`theories/becoming/review/ALIGNMENT.md`) and the failure-mode map (FM, on its branch). The theory gives no better objective to train toward. Its laws say what any training selection can reach. Its use is in how the selection is built: what each signal reads, readers beyond the share, keeping what comes back from shaping the evaluator below its cost, behaviours that add coupling rather than capacity, and held-out tests. The answer also said what the theory does not yet reach, and that no test on a model trained by gradient exists.

## Ren's words

> when the theory finishes, how can we use it to train better aligned ai?

> first of all, for all these issues you brought up, how far are we from the edge? can we make this the foundation of any alignment? I do not mean it is all the alignment, but this theory should be a part of it, do you agree/see?

The session placed each issue against the field's frontier and the theory's own proofs. Formally most of the account is at the known edge, with six joins (FM §4) as the candidates for going past it. Empirically it is behind: one small model choosing in context, with no gradient training. The session agreed in one sense: every alignment method is a selection, so the laws on what a selection reaches hold of each by construction, and they use no ethical premise. It held back in three respects: the single laws are known, the account is silent on representation and scale, and it becomes part of alignment only by being read beyond its own share. It named five steps, the second of which was LA4. It asked "Start with LA4's design, the drain test on gradient-trained models?", and Ren chose the offered reply:

> Yes, design LA4

## How the AI reads it (AI-authored)

"Part of any alignment" is read as the selection layer under every method: the laws a reward, judge, evaluation regime or institution cannot escape, used to say where each will fail and to place failure modes in one vocabulary. It is not read as a claim that other approaches derive from the theory, or that the theory supplies the method. LA4 is the test AJ's plan lists as missing (§3, item 2): T3's clause on trained systems, with a dependent outside the stated reward, room open, nearness to the optimum varied, on more than one model family trained by gradient. Its design is `experiments/drain-beyond-the-reward/DESIGN.md`.

## How it becomes part of the field's practice (AI-authored, kept as a note)

The work becomes part of the field's practice as others read it, check it, build on it and test it where it could fail; no independent review of it was recorded then. By the theory's own capture law (A-13 in the dossier), a frame that selects its readers only from those who already agree locks.

The fine-tuning test IN2 was dropped on 21 October before any job ran ([source](2026-10-21-strongest-formally-first.md): "fine tuning a model is not needed"). That word concerned installing the direction by fine-tuning. LA4 tests a different claim, T3's drain under training, which no in-context test can reach.
