# A survey of the whole repository, 18 to 20 November 2026

*AI-written (Claude Fable, a session that ran the survey; not the session that holds board row DJ). A record of what was read and what was found, filed on 20 November 2026 at the word of the session that leads on the map and the direction. No person has read it. Nothing in the repository was changed by the survey itself. The files beside this note are kept as text, byte for byte as they stood in scratch; their links were written for another place and do not hold from here.*

## Why it was made

On 18 November Ren said he would ask for the repository to be oriented again, and asked first for the whole picture: "let's understand the full picture first" ([his words](../../../../sources/15-codex-theory-conversations/2026-11-18-the-lean-before-the-words.md)). The survey is that picture. Step 4 of the roadmap of 20 November, the tellings following the Lean, rests on it ([the direction page](../../../DIRECTION.md), "What we are trying next").

## How far it has been seen

- **The first round** (18 November): 13 Claude readers and 14 astra 6.2 readers, one per area of the repository, each on a fresh thread and read-only; then 13 second readers who tried the first reports' claims against the repository, and one who asked what was missed. The second readers counted 3 errors of fact in astra's twelve reports and 68 in the Claude reports (63 without the area left out below). The checks, in `first-round/check/`, say which.
- **The second round** (19 November): what the first had not done. Four Fable readers and ten astra runs, read-only. Five of astra's counts were rechecked by command and matched. The rest are first reports.
- **The picture** (`THE-PICTURE.md.txt`) is the survey session's summary of both rounds. It says "checked" where a second reader saw a thing and "counted once" where nobody rechecked.
- No reader read a proof. No program was built or run on the Lean.

## What it found, in short

The repository is three things in one tree: a small current core (the Lean and four pages that carry the direction); several hand-written tellings of each theorem, never set against the theorem statements; and a large stock of history, receipts and generated pages, about two thirds of the files, which nothing reads for its meaning and which tools, records and links are bound to. The stock cannot simply be removed, and removing it would shorten no reading. In a sample of twenty headline theorems no telling was false of its own theorem, and a telling says more than the statement in nine of the twenty by both models' agreement; the docstring is the telling that most often drops a premise. The picture has the rest.

## A correction

After the survey, the same session said, to Ren and in a landed clause of the work board (20 November, 13:27 WIB), that the front pages call October's zero-axiom target "the work's open target". They do not. The sentence the fronts carry, and their tests pin, is that how orders form, spread and lock, as dynamics connected to the rest of the map, is the work's open target; it links chapter 8's ranked open items and is the aim of 9 and 10 November. A landed clause is not edited, so the correction is said here and in the clause of the landing that added the entry path's pointers.

## What is here

- `THE-PICTURE.md.txt`: the summary.
- `PROPOSAL.md.txt`: the proposal for reorienting the repository, in its third form. Its first two forms were found unsound by readers who did not write them. Ren did not answer it as a whole; what came of it is told on the work board's Queue line for 20 November.
- `BRIEF.md.txt`, `AREAS.md.txt`: what every reader was given, and the thirteen areas.
- `COLD-START-PROMPT.md.txt`, `COLD-START-EXPECT.md.txt`: a test of whether a reader with no memory can state the direction from the repository alone, with its pass marks written before it ran. The answer is `first-round/astra/cold-start.md.txt`; it met the four points scored.
- `first-round/`: the reports of the Claude readers, the astra readers and the checks, with the claims each check tried.
- `second-round/`: its brief, the three samples of records with their seeds, and the reports.
- `cold-read-2/`: a second cold read, of 20 November, told below.
- `trial-on-twenty/`: a trial of 21 November on whether tellings that carry their premises let a reader recover them; its record is [there](trial-on-twenty/RECORD.md).

## The second cold read (20 November, added that night)

At the asking of the session that leads, after the first step of its roadmap did not come out and it turned the order. One astra 6.2 reader on a fresh thread with no memory, read-only, was given `cold-read-2/PROMPT.md.txt` and nothing else, and asked where the work is heading, how far it is, what the next step is and why the order changed. The marks (`EXPECT.md.txt`) were frozen before it ran, against the direction page at `5ffce3f39`; their hashes are in `FROZEN.sha256.txt`. The answer is `answer.md.txt`, unedited, and the scoring is `SCORE.md.txt`, by the session that wrote the marks.

- **It met the four marks**, and no fail condition fired. Nine commits landed on main while it read, one of them changing the next step; it saw that and answered from the last commit it saw, so the marks for the next step describe a page that stood for 21 of its 58 minutes.
- **It missed** a sentence on GOALS that the direction page contradicts ("the meta-attractor has closed and holds"); it did not report that the work calls itself far from its aim, or that Ren has not said the roadmap is right; and it could not reach what would count as failing for the step then running, which was in scratch.
- **It quoted four pairs of pages that pull apart**; they were passed to the coordinator with who holds each.
- **What it cost.** 58 minutes, 169 commands, about 18.9 million tokens by the harness's count, and about 79,000 words read by its own. The prompt asked it to read "as a careful newcomer would, for about an hour" and set no cap on files, words or commands. The session that asked for the run answers for that; no reader of this kind runs again without a cap on each.
- **What it cannot show.** One run, one model, an agent's entry and not a person's. No landing was tried.

## The trial on twenty theorems (21 November, added that night)

For the 14 of the twenty headline theorems where a telling says more than the statement, two writers proposed wordings that carry the premises; a checker of another model set each against its signature; and two blind judges, one with the tellings as they stand and one with the proposed wordings, were asked what conditions the telling states and whether the result applies to a situation that fails one hypothesis. With the tellings as they stand the judge recovered 17 of 41 hypotheses and answered 6 of 11 cases rightly; with the proposed wordings, 40 of 41 and 11 of 11. Thirteen of the 21 proposed wordings were exact against the signature and eight were not yet. Nothing in the repository was edited. In a second round a second writer, given the definitions, rewrote those eight, and a second check found all eight exact, six of those verdicts resting on definitions it was not given. The two rounds cost 417,967 tokens by the harnesses' counts, under a ceiling of 500,000 said beforehand. [Its record](trial-on-twenty/RECORD.md) says how it ran and what it cannot show; the chief limit is that the situations were written by the writers of the proposed wordings.

## What became of the picture's last section

The picture ends with "What I now think", this session's view on 18 and 19 November. Its sentence that the Lean work is to join October's modules that carry the idea to November's models was tried by the leading session on 20 November for October's files on renewal, on paper, and did not come out as a join ([its record](../../2026-10-05-generative-foundation-review/root-foundation/development/dj-a-line-on-a-stock/renewal-against-keeping-2026-11-20/NOTE.md)). The picture is kept as written.

## What is not here

- **The area "memory".** One reader read this account's AI memory, and one check tried its claims. Those three files are left out: an AI's memory is kept private, as `sources/13-claude-memories` is. The two files that pool every area's results are left out for the same reason. The picture's figures that include that area say so.
- **The proposal's readers' reports, the survey's log, and the drafts of AGENTS.md's rules.** They are in scratch and under `refs/salvage/survey/repo-picture-1120`, with everything else.
- **The reads on the next step.** The session that leads filed them under its own study, in `dj-a-line-on-a-stock/reads-2026-11-20/`.

## Held for Ren's read of AGENTS.md's rules

The seven rules of [AGENTS.md](../../../../AGENTS.md) were landed on 18 November and he has not read them as they stand. Three corrections wait on that read, so that they go in together, and until now they were written only in scratch:

1. Rule 4 says "Retire only what your own landing replaces" and does not say how. The layout page does: moved byte for byte to a sibling `history/` with a manifest entry, nothing deleted. The rule could point there.
2. The rules do not settle whether new test designs are still held. His hold of 6 November named paid runs and new test designs; rule 7 names paid runs only, and rule 1's "holds back no test" was meant of the Lean-first order only. The board keeps the hold.
3. His line of 18 November, 15:31, named "changes to the direction" with pushing, the licence, sending and runs. Rule 3 keeps "changes only after he has read the change". Neither text gives a reason for reading them apart.

And one note on a landed clause: the board's clause for that landing says "What we are doing" is byte for byte as before. Its text is; the section gained one anchor line.
