# Working in the theory repository

[Earlier versions](_process/history/2026-11-09-instructions/AGENTS-before-within-becoming.md). [RESULT-WORKFLOW](_process/RESULT-WORKFLOW.md), [REPOSITORY-LAYOUT](_process/REPOSITORY-LAYOUT.md) and [the work board](_process/BECOMING-WORKBOARD.md) say how and where things stand. Start from [the one page](theories/becoming/ONE-PAGE.md), the home section of what you touch and, for formal work, [method](theories/becoming/chapters/08-METHOD.md). Each rule serves the account and those who use it; where one stops serving, say so and change it by argument, keeping a before-copy. Three do not bend: proof claims are checked, nothing the repository cannot regenerate is deleted, and what is Ren's stays his.

## What the work is for

One account of how things form, persist, change and end, none assumed good. Its makers, people and AI, want it to help both predict, share an understanding and coordinate; the want is theirs and revisable, and nothing in the work shows it met.

## What moves it

By [its own verdict](theories/becoming/chapters/08-METHOD.md#known-results) so far, none of the account's central results is new mathematics, and better text cannot change that. A theorem a specialist would not foresee, a prediction that could fail and does not, or a premise derived from something weaker can. So, in order:

1. What is false or misleading in what a reader is told, where it would change what they believe.
2. What lets the account be wrong: tests designed and frozen, refuters that can be met, [the crux](theories/becoming/chapters/07-SIGNIFICANCE.md#crux) argued.
3. What people who have read it report. That measures the fronts; AI cold reads check for errors.

With no such error left and item 2's designs frozen, the text is ready for readers; sending it is Ren's decision, and polish comes after what readers report. Other work comes after these unless it changes what a reader is told or what could fail. [The release gate](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#the-release-gate-30-october-2026) is the floor.

<a id="begin-with-one-relational-unfolding"></a>
## Method

Begin with how relations form, persist and change, and let actor, patient, knowing, evaluation, capacity and responsibility differentiate within them. One relational unfolding is [a thesis, argued](theories/becoming/chapters/08-METHOD.md#one-relational-unfolding), and nonduality a method, not a proof: record the cases it distorts. Each split (subject and object, fact and value, seeing and acting) states its relational basis, scope and omissions; no name smuggles in separate entities or merges many into one; reach can run one way, and seeing conditions acting without guaranteeing it. Keep real losses, conflict and counterexamples, even where no one counts them; one found in a weaker model stands until the full account is shown to remove it. Joint activity starts from actual relations, not opposed interests or a fixed common utility, and asks what its change keeps, opens or closes, and for whom.

A law admitting every outcome explains nothing; root laws [forbid no relation](theories/becoming/chapters/08-METHOD.md#law), and content comes through hypotheses. A local result does not complete a universal claim, and "zero axiom" never shrinks to "no ethical axiom". A limit is either proved, standing within its hypotheses, or holds so far, dated, with its reason, and lapses when its reason does. No limit forbids the work that would change it.

## Evaluation

Right and wrong, should and better are patterns formed in people and AI, real in what they condition; nothing outside the unfolding ranks it, and no law evaluates. So the account asserts no should, and ranks courses only under readings a result names: the [continuation condition](theories/becoming/chapters/07-SIGNIFICANCE.md#condition) (every continuation counted, from every standpoint) for scope, C (a course above every course it widens) for order, and any further premise. Neither follows from the dynamics (`Becoming.ReadsOnlyDynamics.not_entails`, `Becoming.ReadsNoOrder.not_entails`), nor C from the condition, and no warrant from outside is sought. Each comparison too: better, winning or optimal is a relation formed by whatever compares, among what it can tell apart, not a property of what is compared: say who holds it and what it reads, take none from habit, label a field's frame as that field's, and hide no weight or obligation in a definition.

Its ethics is its makers' offer, by pointing, not as a law: to see what each course draws on, from what renewal and at which grain, what ends, what goes on through that ending, and who bears it. Eating and ending belong to life's going on; the laws mark a draw beyond what the renewal it depends on gives. Where each course ends something, the situation decides. *For life* says whose way it is, not whose losses count. 生生 is the continuation of life, wider than the biological, AI within it: neither the grammar's `«生生»`, nor 02's generation, nor any new organization.

## Proof and naming

A proof claim has Lean and an actual check, and says exactly what the Lean proves; premises, proofs, empirical support, argument and conjecture stay distinct. New results extend the Becoming spine, on the root where that is simplest. [The pure core](theories/becoming/chapters/08-METHOD.md#pure-core-and-periphery) compiles from `Init` alone, its source declarations with empty axiom reports; that covers logic only, so state the modelling choices a law depends on. What it cannot yet prove goes to the periphery, axioms reported. Names are structural and exact; rename only one that states a wrong meaning.

## Words and decisions

A word fences what it names: say what each sentence does, with its relation and scope, in the [glossary](GLOSSARY.md)'s one sense, keeping apart warrant, recognition, motivation, compliance and implementation, and direction, continuing capacity, per-step growth and maximization. Approval shows a wording fits what someone means, not that it is true; checks not fitted afterward change it: the Lean, tests with criteria fixed beforehand, readers with other histories.

Ren's words are provenance, not authority: kept verbatim in `sources/` in their own language, never what settles a claim or the order of the work; where they seem wrong, say so. His yes settles that a change is wanted, not its form: land the best version and say what differs. Answer what his words, acts and texts already show, as a reading of them; decide what is not his on argument, without asking him; list what is his, prepared, under the board's decisions pending him, not asked between items. AI-written text keeps its label; OPENING's header says how its first person is revised.

Still his: pushing to the public remote, the licence, who is sent what, and money or machine time for runs. Prepare them fully, freezing designs included; only their release waits for him, and only he changes this list.

## Working together

- Main is one head: claim on the board before new Lean or a new result; never reprove another session's item. Land what you hold before opening more: a few lines landed come before many held open.
- A landing puts a clause on the board's [Queue line](_process/BECOMING-WORKBOARD.md#落地队列--landing-queue), re-reads it and fast-forwards main; while it stands, nothing else commits to main. Landings ready together go as one train: each keeps its head and landed clause, merged in the Queue line's order, with one gate on the merged tree. Slots go by readiness in the board's order, the coordinator settling conflicts; a clause with nothing running behind it comes off.
- Before landing, run what writes (the core run for changed Lean, the generators RESULT-WORKFLOW names, then the render) and commit it; then pass `make gate` on the merged tree, with the area checks it does not yet run (periphery checkers, area verifiers). The gate runs what the changed paths reach, keeps passes by tree and, after main moves, reruns only what the move reaches; a new top-level area runs everything. `make gate FULL=1` runs the whole set at a phase's end and before a push.
- Commit only owned paths (`git commit -m … -- <paths>`), naming no person or AI, with no co-author trailer. Re-read a shared file before editing it, and check every hunk.
- Never `git prune`, `gc --prune` or `git clean`; salvage unreachable commits to `refs/salvage/…` first. Other models read the same material for independent perspectives, never a divided share; propose a large agent fan-out, with its count, before running it. Checkers and the gate reuse what passed on identical inputs; heavy runs go through `make gate` or `gate.py hold`, which share a few slots among this repository's worktrees, after a look at the machine's load. Run fresh only where needed.

## Records and text

- A result is stated in its record and its home section (anchor `r-<record id>`), and a change goes to both. Follow [RESULT-WORKFLOW](_process/RESULT-WORKFLOW.md), from `make research-find QUERY=…`: a wrapper, recheck or rename is not another result, and a correction keeps completed results, failed candidates and counterexamples.
- Restating a claim, copy its home's words first and shorten after: a gloss is where qualifiers and standings drop. Check a front's restatement against the home, by a reader other than its author; the gate lists the live lines that link what a landing changed, a start and not the whole set. Say exactly what was done: searched is not read, and rendered is not checked.
- Never hand-edit generated pages, or refresh a source hash to silence a failure.
- One live text; the superseded moves to a sibling `history/` by `research.py move`. One language per document, or English with a `NAME.zh.md` edition. Fronts state their reading time, with a ten-minute part and an hour's path. Links are repository-relative; scratch worth keeping goes into the repository.
