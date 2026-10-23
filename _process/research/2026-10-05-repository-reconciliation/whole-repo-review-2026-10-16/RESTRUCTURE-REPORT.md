# Restructure report (17 October 2026)

Ren approved the [restructure plan](RESTRUCTURE-PLAN.md) on 17 October 2026, taking every decision as recommended, and added three requirements: only the latest and most informative files stay live, overlapping documents are reconciled, and the languages are separated ([source](../../../../sources/15-codex-theory-conversations/2026-10-17-restructure-go-and-language-separation.md)). This page records what was done. Everything is committed on `main` (5ac20fc11 → this commit) and not pushed. No Lean statement changed, and no checker was rerun, because no proof or source module changed.

## In brief

The repository now shows one current version of each document, in one language, with everything older kept byte-for-byte in a `history/` folder beside it. Each folder's `history/` has a manifest, and each move batch has a receipt that records old path, new path and hash.

| | Before (5ac20fc11) | After |
|---|---|---|
| Tracked files | 70,502 | 43,708 (the evidence store packs duplicate checker-run copies) |
| Live files (outside `sources/` and `history/`) | 64,547 | 19,298 |
| Live Markdown files | 3,821 | 1,294 |
| Chapters in `theories/becoming/chapters/` | 139 | 35, plus Chinese editions and the reference file |
| Broken live links | 1,687 | 789 (the rest are older, mostly in drafts and process pages) |

Checks at the end: `make research-check` reports no errors and no source drift, and `make research-test` passes 170 tests. The credential check finds only the revoked OpenRouter key, allowlisted by hash.

## What was done

1. **Preservation first (P0, P5).** Three checker runs that existed only in volatile places were saved into the repository. A content-addressed evidence store now holds checker runs (`becoming-checks/_objects/`), with `research.py evidence {plan,pack,restore,verify}`. A restore round-trips byte-identically.
2. **Instructions.** AGENTS.md, RESULT-WORKFLOW and the new REPOSITORY-LAYOUT are in English and state the latest-only and language rules. The work board is trimmed to open claims, and the full old board is in `_process/history/workboard/`.
3. **Tools.** These were added:
   - `research.py move`: plans, receipts, `--check` and `--keep-references`, with live links, path mentions and record JSON paths rewritten.
   - `research.py links`, `research.py secrets`, `paths.py` and `split_languages.py`.
   - History-aware catalogues and generated indexes (`indexes.py`).
4. **The canonical chapter.** [The Theory of Becoming](../../../../theories/becoming/history/THE-THEORY-OF-BECOMING.md) is now English, with every earlier anchor kept and the review's overclaim corrections applied, so that each statement says what the Lean proves. The long declaration lists and the module table are in [the reference file](../../../../theories/becoming/history/THE-THEORY-OF-BECOMING-REFERENCE.md). The Chinese text of 17 October is kept as a labelled edition, `THE-THEORY-OF-BECOMING.zh.md`, and the superseded §6 passages are in `theories/becoming/history/`.
5. **History moves.** These ran in seven batches (H1–H7) plus two replacement batches:
   - September corpus pages: MAP and GLOSSARY now have short current pages.
   - The 4–5 October studies.
   - 104 superseded chapters.
   - Root-foundation packets, spent kits and executed plans.
   - The 5 October experiments.
   - Lean periphery run folders.
   - Four experiment index pages, replaced by short current indexes.

   In all, 17,265 files moved.
6. **Language separation.** About 60 live documents were interleaved Chinese–English. Each is now English at its original path, with a Chinese edition at `NAME.zh.md` where the Chinese text is worth keeping, or it is one file in one language. How each kind was handled:
   - **Theory chapters.** Chinese-only passages were translated, so the English is complete.
   - **Process studies.** These were split without translation, and a header line names the passages that exist only in Chinese.
   - **Ren's quoted words.** These stay verbatim, in their original language, in the English files.
   - **Chinese-only chapters.** The Chinese-classics chapters and a few Chinese-only studies stay single Chinese files.
   - **Generated pages.** These render in English.
7. **Compaction.** Six accreted chapters had their dated round logs moved verbatim to `theories/becoming/history/<NAME>-rounds-2026-10-17.md`, and keep a compact current account: ETHICAL-LEARNING, KNOWLEDGE, PLURAL-SYSTEMS-AND-CORRECTION, ZERO-AXIOM-PRACTICAL-JUDGMENT, RELATIONS-ACROSS-SCALES and PHILOSOPHICAL-ACCOUNT. Where an English summary sat next to a full translation, the two were merged into one text.
8. **Navigation (P2).**
   - **One register.** RESULTS.md is the single register, and RESEARCH, the theory README, CLAIMS, RESULT-REGISTER and ROADMAP are stubs that keep their anchors.
   - **Compact pages.** DEPENDENCIES is down from 350 KB to 91 KB, OPEN-QUESTIONS has its own groups, and GOALS is ordered by a new `state` field.
   - **Indexes.** New generated indexes cover the chapters, the studies, the root-foundation study and its reviews, `sources/` and the directive records.
   - **Featured results.** The README features 12 laws without axiom and the §6.15 conditional results, marked as the AI's proposal pending Ren.
9. **Docs reconciliation.** A survey measured text overlap across all live documents. Kept chapters overlap each other by at most 2%, so the real duplication was elsewhere, and it was resolved by moves (receipts RA–RE, RG):
   - Register copies (now stubs).
   - Eleven superseded IASEAI paper editions (v7.3 current).
   - Whitepaper v0.1–v1.0 (v1.1 current).
   - An applied agentdojo edit kit with byte copies.
   - The-fork's README copy.
   - Four executed study plans.
   - The 9–11 October spine reviews (the eighteenth, release-readiness and general-laws reviews stay live).
   - Six READMEs that were stacks of dated status paragraphs, replaced by short indexes.

   Statements the restructure had made false were corrected. MAP is now the one reader-facing "where things are" page.
10. **Records.** Records were re-pointed only after reading each change:
    - 104 records were re-pointed for the chapter rewrite.
    - 143 were re-pointed after link-only rewrites by the move tool, checked against 54180d652 with links masked.
    - 184 were re-pointed after language separation.
    - 85 records had history links into moved files retargeted.

    Each re-pointing carries a dated history entry. No claim changed.

## Left for Ren

- **Featured results.** Reordered on 17 October by significance (below); still open to revision (`readme_featured_selection` in `_process/research-config.json`).
- **Goal states.** Mark the state of the fourteen goal scopes left `unmarked`. theory-of-becoming and theory-of-evolution describe themselves as current.
- **A14.** The chapter glossary no longer equates 生生 with the Lean predicate `living`, because the predicate is weaker than Ren's term.
- **ETHICAL-LEARNING.**
  - It was written in Chinese, and its English is now the maintained text. Confirm, or say which text governs.
  - Its translation has not been reviewed by Ren.
  - It and KNOWLEDGE still speak of the "G0 axiom route", which predates the 11 October fold.
  - The banners on PHILOSOPHICAL-ACCOUNT and ZERO-AXIOM-PRACTICAL-JUDGMENT say to read "axiom" there as the condition of §6.15. Confirm them.
- **"Part I".** The term remained in record text (136 records) and in the theory-of-becoming goal overview; retired from public text on 17 October (below).
- **Tier-3 reconciliation items** (see the survey below):
  - Retire the 9 October chapters THEORY-OF-BECOMING, BECOMING-FOUNDATION and THE-THEORY-OF-EVOLUTION; goal records name them.
  - Retire the opening drafts, one of which is byte-identical to OPENING.md.
  - Replace the October status stacks atop thirteen September theory READMEs.
  - LOST-ARTIFACTS.md stays as an open list only Ren can close.
- **Earlier deferrals.** The privacy and visibility decision (F2) and the recordings backup (F3).
- **Push.** Nothing is pushed.

## After the restructure: retired labels and featured laws (17 October)

Ren then said his words are provenance, not authority, that outdated labels such as "G0" and "Part I" should go, and that the featured laws should be ordered by significance for AI–human alignment and coordination ([source](../../../../sources/15-codex-theory-conversations/2026-10-17-ren-words-not-authority.md)). The tree was committed clean first (87061cede). Then:

- **Vocabulary.** G0 → living significance, S0 → self-significance, the one axiom → the continuation condition, Part I → the theory without axiom, Part II → the conditional section (§6.15), the G0/J route → the conditional alignment route, J1–J4 → the practical commitments named by content. P-numbers, review rounds and "on Ren's delegation" are out of public text. The canonical chapter's §10 has a table of retired labels, and every earlier anchor is kept. Lean names are unchanged.
- **Where.** The canonical chapter, the reference file (verbatim excerpts kept and marked), the OPENING footnotes (body unchanged), the Lean README, GLOSSARY, 18 kept chapters, 80 records' public fields (each with a history note), the nine goal records, the README lead, the work board and AGENTS (old text in `_process/history/2026-10-17-instructions/`). The `*.zh.md` editions are dated snapshots and keep the old labels.
- **"What stays Ren's" → "Open readings".** §8.4 now lists open readings to be settled by argument, not by authority.
- **Featured laws.** Reordered as one argument, each law proved with no axiom: seeking-boundary, own-count-misses-joint-excess, consumption-ends-with-feeders, feeding-closure, derived-extent-limits, selection-through-registration, runaway-distance-unregistered, target-capture, experiment-needs-return, closing-needs-net-draw, separation-loses-the-relation, whole-persists-through-generation. The selection is marked as the AI's, open to revision.
- **Checks.** 72 records re-pointed after reading the relabel diff; `research-check` has no errors and no drift; 170 tests pass; broken live links 692.
- **Still carrying old labels.** Record IDs (`one-axiom-yields-g0`, `alignment-direction-g0-j`, `practical-judgment-g0-j`, `held-lives-g0-is-centering`, `self-good-reachable-g0`, `wisdom-root-part-one`), non-public record fields (hypotheses, limitations, validation scope, correspondence), Lean identifiers, filenames such as `G0-WARRANT.md`, studies and process logs (dated evidence). Renaming IDs and files is a move with link rewrites, not done here.

## Not done

- **P6, the Lean docstring pass.** Not done; there was no proof change to justify a checker run.
- **P7, git cruft-pack gc.** Not done, because AGENTS forbids prune and gc-prune.
- **The 80 reading-catalogue entries.** Their source changed after they were read, and each page says so. A reread refreshes them.
- **The 789 remaining broken links.** These predate the restructure, mostly in drafts and process pages.

The reconciliation survey (by agent H) is kept with this report as [RECONCILIATION-SURVEY.md](RECONCILIATION-SURVEY.md).
