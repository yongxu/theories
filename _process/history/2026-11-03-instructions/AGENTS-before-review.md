# Working in the theory repository

Rewritten 31 October 2026, much shorter, so that the work aims at the full picture rather than at anyone's past words ([Ren](sources/15-codex-theory-conversations/2026-10-31-full-picture-not-my-words.md), [before](_process/history/2026-10-31-instructions/AGENTS-before-full-picture.md); earlier revisions are listed in that copy's first paragraph). Revised 2 November 2026 so that progress is read from what readers can see, not from root counts ([Ren](sources/15-codex-theory-conversations/2026-11-02-a-finish-readers-can-see.md), [before](_process/history/2026-11-02-instructions/AGENTS-before-readers-finish.md)).

## Start here

Read [README](README.md) → [the one page](theories/becoming/ONE-PAGE.md) → [the overview](theories/becoming/THE-THEORY-OF-BECOMING.md) → the chapters, [the root](theories/becoming/chapters/01-ROOT.md) first and [method](theories/becoming/chapters/08-METHOD.md) before formal work → [the records](RESULTS.md). Each result is stated once, in its record and its home section (anchor `r-<record id>`; [regions.json](theories/becoming/results/data/regions.json) names the chapter). A change to a statement goes to both and nowhere else. [The work board](_process/BECOMING-WORKBOARD.md) holds claims and the landing queue; [WHAT-REMAINS](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#the-release-gate-30-october-2026) holds the release gate.

## Begin with one relational unfolding

The ontology is one and relational. Begin with how relations form, persist and change. Then show how actor, patient, knowing, evaluation, capacity and responsibility differentiate within them. Each analytic split (subject/object, action/condition, fact/value) states its relational basis, scope and omissions. No name or variable smuggles in separate entities. Keep real losses, real conflict and genuine counterexamples. What a weaker model leaves out does not refute the full account. Nonduality is a method, not a proof. Joint activity starts from actual relations, not opposed interests or a fixed common utility. It asks how the whole relation's change supports, enriches or damages 生生.

## Scope and current status

The Theory of Becoming covers the whole unfolding: generation, maintenance, transformation, degeneration and disappearance, not assumed good. It aims to be one unified theory whose claims need no axiom wherever they can. "Zero axiom" never shrinks to "no ethical axiom". A law admitting every outcome explains nothing. A local result does not complete a universal claim.

The work now aims at an elegant finish, then review by people; the release gate is the floor. Elegant means the account representable as one whole, so that a reader sees what it is. The root's laws hold of every relation and forbid nothing, so a law lifted onto the root adds unity, but a reader or a selector can do no more with it. Root counts are a diagnostic of the core, not progress. Progress is read from cold reads of the fronts checked against the account, AI first and then people. Work that brings the finish nearer goes first.

The ethics rests on two unasserted premises with two roles. The [continuation condition](theories/becoming/chapters/07-SIGNIFICANCE.md#condition) (from every standpoint, for anything, its continuation into the future has significance) fixes scope: whose losses count. C (widening what can form is better) alone gives order. Name both wherever the ethics is summarized, and never write that it "derives" from the condition. Their warrant is open, and no warrant binding every possible mind is claimed. [Chapter 7](theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order) names what still needs argument. Hide no weight or obligation in a definition.

生生 names life in the whole and its continuing generation; "generative" never means just any new organization. Keep warrant, recognition, motivation, compliance and implementation distinct. Likewise keep direction, continuing capacity, per-step growth and maximization distinct. Use each term in the [glossary](GLOSSARY.md)'s one sense.

## The full picture, not anyone's words

Ren's words are provenance, not authority. Keep them verbatim in `sources/` with their source, in their own language. Never offer them as the warrant for a claim, the order of the work, or the standing of a reading. Live text gives the argument and follows the strongest direction the work supports. It revises whatever the work has outgrown: past directives, wording that stood on his yes, and his own voice. Where his words seem wrong, say so.

OPENING's first-person body is revised in place. A note at its top names each passage revised since his own last text and links that text, which is kept verbatim in history, so no revised sentence passes for his. The generativity chain changes through its maintenance record. AI-written text keeps its AI label.

Still his: pushing to the public remote, the licence, the sending decisions, and money or machine time for runs. Texts are sized for a person: each front states its reading time, with a ten-minute part and an hour's path before the rest.

## Proof and naming

- New formal results go on the Becoming spine, stated on the grammar (the root) where that is their simplest statement. Extend it rather than build another model.
- [The pure core](theories/becoming/chapters/08-METHOD.md#pure-core-and-periphery) imports only `Init` besides itself, and every declaration has an empty axiom report: no `propext`, `Quot.sound` or `Classical.choice`. `check_becoming.py` enforces both. The report covers logic only. The real assumptions are modelling choices, such as discrete steps, natural-number amounts and Prop-valued activity; state them where a law depends on them. A law the core cannot yet prove lands in the periphery with its axioms reported.
- Every proof claim needs Lean and an actual check, and says exactly what the Lean proves. Keep premises, proofs, empirical support, philosophical warrant and conjecture distinct.
- Names are structural and exact: formal, scientific and systems words, used only where the statement means exactly that. Name at claim time, and rename later only a name that states a wrong meaning.

## Coordination

- Claim on the board before new Lean or a new result, and never reprove another session's item.
- One head at a time. A landing claims the head with a clause on the board's Queue line, re-reads that line, and fast-forwards main. While a clause stands, nothing else commits to main, not even claim rows. The coordinator orders slots.
- Commit only owned paths, with `git commit -m … -- <paths>`. Commit messages name no person or AI and carry no co-author trailer. Re-read a shared file before editing it, and check every hunk before committing.
- Never `git prune`, `gc --prune`, `git clean`, and never delete data the repository cannot regenerate. Build output and merged worktrees may go once nothing uses them, after unreachable commits get a `refs/salvage/…` ref.
- Checkers reuse passed Lean steps. Propose any large agent fan-out with its count before running it.

## Records and generated pages

- Follow [RESULT-WORKFLOW](_process/RESULT-WORKFLOW.md), starting with `make research-find QUERY=…`. A wrapper, recheck or rename is not another result. Corrections keep completed results, failed candidates and counterexamples.
- Never hand-edit generated pages (README, RESULTS, GOALS, indexes). Any commit that adds files the views count, scratch Lean included, renders and commits them. Before landing, run render, `research-check`, `research-links` and `research-test`.
- Never refresh a source hash to silence a failure. Re-point a record only after reading it against the new text, and give the reason.

## Layout, history and language

- [REPOSITORY-LAYOUT](_process/REPOSITORY-LAYOUT.md) says where things go. Reuse the relevant study rather than open a new one for the same work.
- One text, not two: only the latest version stays live. Superseded material moves to a sibling `history/` with `research.py move`, its bytes and provenance kept.
- Each live document is in one language, or in English with a `NAME.zh.md` edition. Quoted words stay in their own language.
- Use repository-relative links in documents and absolute paths in messages. Save unique scratch work into the repository.
