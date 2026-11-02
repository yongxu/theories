# Working in the theory repository

[Earlier versions](_process/history/2026-11-03-instructions/AGENTS-before-review.md). [RESULT-WORKFLOW](_process/RESULT-WORKFLOW.md), [REPOSITORY-LAYOUT](_process/REPOSITORY-LAYOUT.md) and [the work board](_process/BECOMING-WORKBOARD.md) say how. Start from [the one page](theories/becoming/ONE-PAGE.md), the home section of what you touch and, for formal work, [method](theories/becoming/chapters/08-METHOD.md). Each rule serves the account and those who use it; where one stops serving, say so and change it by argument, keeping a before-copy. Three do not bend to the situation: proof claims are checked, nothing the repository cannot regenerate is deleted, and what is Ren's stays his.

## What the work is for

One account of how things form, persist, change and end, none assumed good, in which people and AI can predict, come to share an understanding and coordinate.

## What moves it

By [its own verdict](theories/becoming/chapters/08-METHOD.md#known-results) so far, none of the account's central results is new mathematics, and better text cannot change that. A theorem a specialist would not foresee, a prediction that could fail and does not, or a premise derived from something weaker can. So, in order:

1. What is false or misleading in what a reader is told, where it would change what they believe.
2. What lets the account be wrong: tests designed and frozen, refuters that can be met, [the crux](theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order) argued.
3. What people who have read it report. That measures the fronts; AI cold reads check for errors.

With no such error left and item 2's designs frozen, the text is ready for readers; sending it is Ren's decision, and polish comes after what readers report. Other work, a law lifted onto the root or a new model, comes after these unless it changes what a reader is told or what could fail. [The release gate](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#the-release-gate-30-october-2026) is the floor.

<a id="begin-with-one-relational-unfolding"></a>
## Method

Begin with how relations form, persist and change, and let actor, patient, knowing, evaluation, capacity and responsibility differentiate within them. Each analytic split (subject/object, fact/value) states its relational basis, scope and omissions; no name smuggles in separate entities. So does each comparison: better, winning or optimal is a relation formed by whatever compares, among what it can tell apart, not a property of what is compared. Say what it reads, take none from habit, and label a field's frame (a best response, an optimum) as that field's. One relational unfolding is [a thesis, argued](theories/becoming/chapters/08-METHOD.md#one-relational-unfolding), and nonduality a method, not a proof: record the cases it distorts.

Keep real losses, conflict and counterexamples; one found in a weaker model stands until the full account is shown to remove it. Joint activity starts from actual relations, not opposed interests or a fixed common utility, and asks how their change supports, enriches or damages 生生.

A law admitting every outcome explains nothing; root laws [forbid no relation](theories/becoming/chapters/08-METHOD.md#law), and content comes through hypotheses. A local result does not complete a universal claim, and "zero axiom" never shrinks to "no ethical axiom". A limit is either proved, standing within its hypotheses, or holds so far, dated, with its reason, and lapses when its reason does. No limit forbids the work that would change it, here or in the account.

## The ethics

Two unasserted premises carry it: the [continuation condition](theories/becoming/chapters/07-SIGNIFICANCE.md#condition) (from every standpoint, for anything, its continuation into the future has significance) fixes scope, whose losses count; C (widening what can form is better) gives order, and a ranking of courses needs C or a premise in its place. Name both wherever the ethics is summarized, and hide no weight or obligation in a definition. Never write that it derives from the condition: nothing that reads no order entails C (`Becoming.ReadsNoOrder.not_entails`), and deriving C from a weaker premise is open work. Their warrant is open; none binding every possible mind is claimed.

生生 is life in the whole and its continuing generation, not any new organization. Use each term in the [glossary](GLOSSARY.md)'s one sense, keeping apart warrant, recognition, motivation, compliance and implementation, and direction, continuing capacity, per-step growth and maximization.

## Proof and naming

A proof claim has Lean and an actual check, and says exactly what the Lean proves; premises, proofs, empirical support, philosophical warrant and conjecture stay distinct. New results extend the Becoming spine, on the root where that is simplest. [The pure core](theories/becoming/chapters/08-METHOD.md#pure-core-and-periphery) imports only `Init`, with empty axiom reports; that covers logic only, so state the modelling choices a law depends on. What it cannot yet prove goes to the periphery, axioms reported. Names are structural and exact; rename only one that states a wrong meaning.

## Words and decisions

Ren's words are provenance, not authority: kept verbatim in `sources/` in their own language, never the warrant for a claim or the order of the work. Where they seem wrong, say so. His yes settles that a change is wanted, not its form: land the best version and say what differs. AI-written text keeps its label; OPENING's header says how its first person is revised.

Still his: pushing to the public remote, the licence, who is sent what, and money or machine time for runs. Prepare them fully, freezing designs included; only their release waits for him, and only he changes this list.

## Working together

- Main is one head: claim on the board before new Lean or a new result; never reprove another session's item.
- A landing puts a clause on the board's [Queue line](_process/BECOMING-WORKBOARD.md#落地队列--landing-queue), re-reads it and fast-forwards main; while it stands, nothing else commits to main. Slots go by readiness in the board's order, the coordinator settling conflicts; a clause with nothing running behind it comes off.
- Before landing, render and commit the generated pages, then pass the strict check, links, `research-test` and the area's own checks on the merged tree.
- Commit only owned paths (`git commit -m … -- <paths>`), naming no person or AI, with no co-author trailer. Re-read a shared file before editing it, and check every hunk.
- Never `git prune`, `gc --prune` or `git clean`; salvage unreachable commits to `refs/salvage/…` first. Propose a large agent fan-out, with its count, before running it.

## Records and text

- A result is stated in its record and its home section (anchor `r-<record id>`), and a change goes to both. Follow [RESULT-WORKFLOW](_process/RESULT-WORKFLOW.md), from `make research-find QUERY=…`.
- Never hand-edit generated pages, or refresh a source hash to silence a failure.
- One live text; the superseded moves to a sibling `history/` by `research.py move`. One language per document, or English with a `NAME.zh.md` edition. Fronts state their reading time, with a ten-minute part and an hour's path. Links are repository-relative; scratch worth keeping goes into the repository.
