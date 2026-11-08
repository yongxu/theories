# WB review, step 1: the inventory

Ren said "Start the review" on 9 November 2026. This step finds, in the live texts, what a reader is told that the alignment shows to be "supposed but not really", and what is false or misleading for any other reason. It edits nothing. Three readers, the WB session (the session "Ethics and monist theory review"), Fable and GPT astra, each read **all** the texts below in full, independently, for three perspectives on the same material (Ren, 9 November 2026: "we use different to get different perspectives, not to split work"). Each starts at a different place in the list; the order is only where to begin.

**Rules.** Read-only in `/Users/ren/tmp/wb/wt` (the worktree on branch `wb-within-becoming`, which is main plus WB's note) and in `/Users/ren/theories`. No edits, commits, builds, tests, checkers, make targets or Lean runs: the machine is shared and loaded. Reading, grep, sed -n and git log are fine. No subagents.

## What to read first

- `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/wb-within-becoming/UNDERSTANDING.md`, in full. It is the standard for this inventory. §3 states the view; §5 says what stays hard; §6 says where readers still differ (flag findings that depend on those); §7 lists 23 places already found (confirm, refine or dispute them; don't just repeat them); §8 gives the method for words.
- `AGENTS.md` "Method" and "The ethics", and `GLOSSARY.md`, for the terms' one sense.

## The texts, and where each reader begins

| Begins with | Then the rest of the table |
|---|---|
| Fable | `theories/becoming/chapters/07-SIGNIFICANCE.md`, `08-METHOD.md`, `06-CLASSICAL-TEXTS.md` (Chinese) |
| astra | `theories/becoming/chapters/01-ROOT.md`, `02-MAP.md`, `03-KNOWING.md`, `04-LIFE.md`, `05-COLLECTIVES.md`; `theories/becoming/FREE-ENERGY-PRINCIPLE.md`, `ONE-ARGUMENT.md`, `COLLECTIVE-DIRECTION.md` |
| WB session | the one page, the overview, USES, USES-EXAMPLES, the glossary (each with its Chinese edition), `README.md`'s first screen and opening, `theories/becoming/OPENING.md`, `theories/becoming/README.md`, `chapters/README.md`, `chapters/CLAIMS.md`, `AGENTS.md` |


**Added to every reader's list (9 November 2026).** In full: `theories/becoming/review/PHILOSOPHY.md`, `theories/becoming/review/ALIGNMENT.md`, `GOALS.md` and `OPEN-QUESTIONS.md` (the last two generated from goal and record files: give the finding against the page and name the source). Searched only, for the categories, saying so: the other dossiers in `theories/becoming/review/` and `TESTS.md`. Goal wording is Ren's authorized scope: mark such findings "goal (Ren's)".

## What to look for

Mark each finding with one or more categories:

- **A. should / must / ought in the theory's own voice** (a field's or a formation's should, said as theirs, is fine).
- **B. ranking in the theory's voice**: better, worse, higher, optimal, best, with no one named as holding the order. C's own content ("widening is better", stated as C) is fine as long as it is said to be C's.
- **C. warrant from outside**: justification, warrant, "binding", "must be so" framed as coming from beyond the unfolding.
- **D. value as a property**: significance, mattering, good or harm used as properties things have, not relations from a standpoint.
- **E. purpose words doing work**: seeks, wants, aims, tends toward, is for, said of formations or of the whole as if they explained.
- **F. fixed units**: self, standpoint, agent, center taken as given, without the relation or class that draws them.
- **G. seeing guaranteeing acting**: understanding, reading or matching presented as producing a response or care.
- **H. 生, 生生, life**: the three 生生 senses blurred (grammar «生生», 02's generation, the ethics' 生生); 不息 as a law; life defined so it means everything, or narrowed with no stated basis.
- **I. overreach about the theory itself**: what it explains, unifies or shows, beyond what is shown.
- **J. loss erased or softened**: the opposite failure, where a revision toward "no should" would let a reader think nothing was lost. Flag sentences that keep losses well, so the revision protects them.
- **K. a tradition's frame unlabelled**: a classical or other field's parallel presented as confirmation.
- **L. criterion missing**: success, failure, gain, loss, cost, improve, with no criterion or bearer.
- **M. two layers**: dynamics with an ethics added beside them, as though evaluation came from outside the unfolding.
- **N. anything else false or misleading** a reader would believe, ethics or not (Ren asked about truthfulness as a whole).
- **K+. keep**: a line that already says the view well and must survive the revision.

Severity:
- **high**: it changes what a reader believes the theory claims.
- **medium**: it misleads in a gloss or restatement.
- **low**: wording only.

Don't flag a field's frame said as the field's, a Lean name that states no wrong meaning, or a mathematical "value" or "optimal" used in its technical sense with its owner named.

## What to return

A table, one row per finding: id (your initial and a number); file and section anchor (or the nearest heading); line number in the worktree; the line quoted briefly (25 words at most); categories; severity; what it supposes; the proposed revision (concrete wording where short, otherwise its direction); and, where you can see it, whether the line restates a claim whose home is elsewhere (name the home). Put the high findings first.

Then, in prose of at most 600 words:
- the patterns across your share;
- which of UNDERSTANDING §7's places you confirm, refine or dispute;
- anything §3 itself gets wrong once read against these texts.

Say what you read in full and what you only searched.
