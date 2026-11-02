# Working in the theory repository

[The version before this one](_process/history/2026-11-03-instructions/AGENTS-before-review.md) lists the earlier ones. Standing rules live here; [RESULT-WORKFLOW](_process/RESULT-WORKFLOW.md), [REPOSITORY-LAYOUT](_process/REPOSITORY-LAYOUT.md) and [the work board](_process/BECOMING-WORKBOARD.md) say how, and where they disagree with this page, this page holds.

## What the work is for

One account of how things form, persist, change and end, in which people and AI can predict, come to share an understanding and coordinate. It covers generation, maintenance, transformation, degeneration and disappearance, none assumed good.

## Where it stands, and what moves it

The formal core passes its own bar, and readers given the text can say what the account is. By [its own verdict](theories/becoming/chapters/08-METHOD.md#known-results), none of its central results is new mathematics. Better text cannot move that verdict. A theorem a specialist would not foresee, a prediction that could fail and does not, or a premise derived from something weaker can.

So work in this order:
1. What is false or misleading in what a reader is told now.
2. What lets the account be wrong: tests designed and frozen, each thesis with a refuter that can be met, [the crux](theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order) argued.
3. What a person who has read it reports. Their reading is the measure of the fronts. AI cold reads check for errors and do not stand in for it.

A law lifted onto the root, a new model, or a pass over wording waits unless it changes what a reader is told or what could fail. Root counts are a diagnostic. [The release gate](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#the-release-gate-30-october-2026) is the floor for a release.

Before starting, read [the one page](theories/becoming/ONE-PAGE.md), the home section of what you will touch, and, for formal work, [method](theories/becoming/chapters/08-METHOD.md). Read further as the work needs it.

<a id="begin-with-one-relational-unfolding"></a>
## Method

Begin with how relations form, persist and change, then show how actor, patient, knowing, evaluation, capacity and responsibility differentiate within them. Each analytic split (subject/object, action/condition, fact/value) states its relational basis, scope and omissions. No name or variable smuggles in separate entities.

One relational unfolding is [a thesis, argued](theories/becoming/chapters/08-METHOD.md#one-relational-unfolding), not a premise of this page. Nonduality is a method, not a proof. Where the method distorts a case, record the case.

Keep real losses, real conflict and genuine counterexamples. A counterexample in a weaker model stands until the work shows what in the full account removes it. Joint activity starts from actual relations and asks how the whole relation's change supports, enriches or damages 生生. Opposed interests and common utilities are cases to represent, not starting points.

A law admitting every outcome explains nothing. A law of the root [forbids no relation](theories/becoming/chapters/08-METHOD.md#law); a law with content forbids through its hypotheses. A local result does not complete a universal claim. "Zero axiom" never shrinks to "no ethical axiom".

## The ethics

It rests on two unasserted premises. The [continuation condition](theories/becoming/chapters/07-SIGNIFICANCE.md#condition) (from every standpoint, for anything, its continuation into the future has significance) fixes scope: whose losses count. C (widening what can form is better) gives order; a ranking of courses needs it or a premise in its place. Name both wherever the ethics is summarized, and never write that it derives from the condition. Their warrant is open, and no warrant binding every possible mind is claimed. Hide no weight or obligation in a definition.

生生 names life in the whole and its continuing generation; "generative" never means just any new organization. Keep warrant, recognition, motivation, compliance and implementation distinct, and direction, continuing capacity, per-step growth and maximization. Use each term in the [glossary](GLOSSARY.md)'s one sense.

## Proof and naming

- Every proof claim needs Lean and an actual check, and says exactly what the Lean proves. Keep premises, proofs, empirical support, philosophical warrant and conjecture distinct.
- New formal results extend the Becoming spine, stated on the root where that is their simplest statement.
- [The pure core](theories/becoming/chapters/08-METHOD.md#pure-core-and-periphery) imports only `Init` and has empty axiom reports, enforced by `check_becoming.py`. That covers logic only: state each modelling choice where a law depends on it. A law the core cannot yet prove lands in the periphery with its axioms reported.
- Names are structural and exact. Rename later only a name that states a wrong meaning.

## Words and decisions

Ren's words are provenance, not authority: kept verbatim in `sources/`, in their own language, and never the warrant for a claim or the order of the work. Live text gives the argument. Where his words seem wrong, say so. OPENING's first-person body is revised in place, with a note at its top naming each passage revised since his own last text and linking it. The generativity chain changes through its maintenance record. AI-written text keeps its AI label.

Still his: pushing to the public remote, the licence, who is sent what, and money or machine time for runs. Prepare these fully, freezing designs included, without waiting on him. Only their release waits.

This page changes by argument like any other text, with a before-copy kept. Only he changes the list above.

## Working together

- Main stays one consistent head. Claim before new Lean or a new result, never reprove another session's item, and land through [the queue](_process/BECOMING-WORKBOARD.md#landing-queue).
- Commit only owned paths, with `git commit -m … -- <paths>`. Commit messages name no person or AI and carry no co-author trailer. Re-read a shared file before editing it, and check every hunk before committing.
- Never `git prune`, `gc --prune` or `git clean`, and never delete what the repository cannot regenerate. Unreachable commits get a `refs/salvage/…` ref first.
- Propose any large agent fan-out with its count before running it.

## Records and text

- A result's statement lives in its record and its home section (anchor `r-<record id>`). A change goes to both. Follow [RESULT-WORKFLOW](_process/RESULT-WORKFLOW.md), starting with `make research-find QUERY=…`. A wrapper, recheck or rename is not another result, and corrections keep completed results, failed candidates and counterexamples.
- Never hand-edit generated pages. Never refresh a source hash to silence a failure.
- One text, not two: superseded material moves to a sibling `history/` with `research.py move`. Each live document is in one language, or English with a `NAME.zh.md` edition. Each front states its reading time, with a ten-minute part and an hour's path.
- Use repository-relative links in documents. Save unique scratch work into the repository.
