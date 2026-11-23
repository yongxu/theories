# Hand-over, 23 November 2026

*AI-written (Claude Fable, the session that carried the coordinator's role on 23 November 2026). Written at Ren's word of 17:33 WIB that he will give the repository to another agent to review and continue ([his words](../sources/15-codex-theory-conversations/2026-11-23-be-the-new-coordinator.md), the last section). It is one session's account, read by no one else, and it is meant to be struck through as the next agent finds it wrong. Read [AGENTS.md](../AGENTS.md) first; this page tells where things stand, not what the work is.*

## The head

- Main is the one head; ask git for its tip. This page landed at `719b3c1eb`. One landing came after it that day, row DJ's note for the next agent on where the context's size comes from (`ee195716c`), and then the commit that brought this line up. Nothing is pushed (about 420 commits ahead of the remote), and nothing is to be pushed, sent or licensed until Ren says so (AGENTS.md, rule 7).
- Every worktree stands at a commit of main with nothing uncommitted: the main checkout, rows DJ's two, row FM's, row GR's and the coordinator's landing worktree (`/Users/ren/tmp/rw/wm2/wt`). No gate, core run or reader is alive.
- The whole gate last passed on main at `501407c66` (tree `739f72d25805`, 23 November 15:13 to 15:26 WIB): 48 checks, all passed. Every commit since is text, each with its own gate of 11 checks; no Lean and no tool has changed since.
- Not merged and left as they are: ten branches of 3 to 13 November and two stashes. The session that kept the queue before tested them file by file; what it found is in [its record](../sources/15-codex-theory-conversations/2026-11-23-merge-everything-a-unified-head.md).

## What was done on 23 November, newest first

1. **A record of how the parts connect** ([the note](research/2026-10-05-generative-foundation-review/root-foundation/development/connections-across-the-parts-2026-11-23/NOTE.md)): ten readers of another model over the 297 modules outside four lists; sixty connections in seven themes, each marked proved or candidate; nothing built.
2. **`Becoming.WayUnderARule`** ([its record](../theories/becoming/results/records/a-way-of-units-under-a-rule-set-again.md)), row DJ's: units that need a level and leave offspring, under a rule set again; from every start a step with the test or a first step with no need met; the lock's premises make the test last; two courses that differ in one unit of need. Built from a proposal that rows DJ and FM attacked on paper first; the proposal, the attacks and the brief are in its study folder.
3. **Finishing what rows had begun** (row DJ's nine laws of `TurningInTime` under a weaker premise and its atlas listings; row FM's two forms of `LevelAlone`), and before that `LevelAlone` and `SampledSelection`.
4. **One head and a new coordinator**, at his words of 03:46 and 04:25.

The board's Queue line has each landing's clause; the last entries of the shared memory's log tell them in order.

## Where the direction stands, which is the first thing to review

- **The aim on [the direction page](DIRECTION.md) still asks for "two ways of going on placed with respect to each other". That sentence is about to change and has not.** In the afternoon Ren asked what the second way is, said he does not remember it, and asked whether such words should guide now. He said "All right, please do" to taking the pair out of the aim. A draft exists in three forms ([as text](research/2026-10-05-generative-foundation-review/root-foundation/development/coordinator-kit-2026-11-23/draft-of-the-aim-without-two-ways.md.txt)); the second is row DJ's wording, the third puts his own framing in. Of the third he said it is closer, and asked that the direction be understood before moving on. Row DJ keeps the page and makes the edit on his word. Until then, do not weigh a result by whether it "places the two ways".
- **His framing of that afternoon:** the full picture as "the alignment theory", giving light to a question he worded himself (compositional reasoning about systems that learn, change and coordinate, across scales, with what is kept or evolves). It is filed verbatim. He also said he is no longer sure of many early framings and agreed approaches.
- **This session's understanding, which he called reasonable and which is not his:** one relation, what a going-on rests on against what makes a difference to it, followed through time (does it still reach early enough to turn), through accounts (how a reading forms, spreads, locks and is corrected) and through scale (what is kept, lost or newly there when goings-on are joined or read coarser). The relation and the first are well proved; the second is in pieces; the third is thin; little joins them.

## What is open, by who it waits on

**On Ren.** The aim's paragraph. Whether the course of `WayUnderARule` with the need at 27 shows what he means by turning; the Lean's test was named `Tested` and not `Turned` so that it does not say it for him. Row GR's sentence for AGENTS.md, filed and not landed. Stage 2 of `WayUnderARule` (two older laws of `LineOnAStock` made its calls). The six proofs kept outside the package. The rest of the board's line 0.

**On the rows, none of it begun** (the board's rows DJ, FM and GR name each): the atlas listing of `WayUnderARule`; four links of the read of 16 November; the chapters' telling of everything proved since 15 November; small tidyings.

**Candidates from the record of connections, unbuilt and unchecked.** The two largest: November's line, lock and level against October's drawdown law of a family (`Flow.family_excess_ends`), the same thing on two carriers with no proof between; and `Sampling` against the laws of time, about ten short statements.

**Owed by the coordinator and not done.** He said the context has grown too large to move in and too costly. Nothing is done about it but this page and row DJ's note of the same evening, which counts what a session is told to read and names four things to try ([the note](research/2026-10-05-generative-foundation-review/root-foundation/development/dj-a-line-on-a-stock/the-size-of-the-context-2026-11-23/NOTE.md)); two of the four reshape the repository and wait on his word. What this session would try: one short page of the picture and where each part stands, kept current, and fresh sessions that start from it; the direction page is some 136,000 characters and the board more.

## How landings work here, in ten lines

1. Claim on [the board](BECOMING-WORKBOARD.md) before new Lean, and before any scratch build of it.
2. Land through the queue, one at a time; tell the coordinator before a gate; commit only your own paths.
3. The recipe and scripts are in [the coordinator's kit](research/2026-10-05-generative-foundation-review/root-foundation/development/coordinator-kit-2026-11-23/NOTE.md); [the workflow page](RESULT-WORKFLOW.md) has the rest. A Lean landing owes a core run and then `proof_uses.py` before the render.
4. Commits carry no Co-Authored-By line (his rule of 19 October; about 243 older commits carry one and are not rewritten).
5. Never `git prune`, `gc --prune` or `git clean`; git warns about loose objects and that warning is left alone.
6. Focused checks for a change; the whole gate once at the end of a phase. The Mac is shared.
7. A cap on readers is a stop, said beforehand, with every stage inside it. On 23 November row DJ's two builds ran 6 percent over and 26 percent under their caps and row FM's under; this session's ten readers of another model cost some twenty times what it had said, because that tool sends the whole context again with each command.
8. One reader who took no part on your own sentences before a gate; his words filed verbatim by the session he wrote them to, with any reading named as the session's.
9. Read the owner's record before proposing across rows. This session named a paper model to him before reading the day's record of it.
10. Take the hour from the clock.

## What this session may have wrong

- Its four parts and the percentages it gave him are a sorting of one afternoon; the readers showed the sorting too narrow within the hour.
- It read his "Yes, if it survives", the label of a button under an earlier question, as a yes to row DJ's build in its changed form and at 2.0 million tokens. It told him so; he did not object, and he did not confirm.
- Its sentence that a course that uses up what it rests on and a course that goes on are "outcomes of one relation" went to him before row DJ showed it is not seen. It is what the sessions think.
- It did not ask rows DJ, FM and GR again before writing this page. Their worktrees are clean and at commits of main, and their rows say what they hold.
