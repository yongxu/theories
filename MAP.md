# Start here

A guide for visitors: what this repository is, where to begin, how its history is kept and how to check the proofs yourself. It extends the map of 17 October 2026; the September corpus map, with the reading of the fifteen folders as strata of one argument and the 2 October "why and meaning" section, is kept verbatim in [history](_process/history/2026-09-consolidation/MAP.md).

## What this is

The working repository of the Theory of Becoming: an account of how anything comes to be, lasts, changes and passes away within one relational unfolding. Its ethics adds two premises it does not assert; for AI alignment it shows first what a selection can reach, and a direction only conditionally.

Every statement carries its standing: a **theorem**, with where it is proved (for every relation; for every process; on the World model, its premises named; or with Mathlib, its axioms reported); a **conditional** result, its premises named; a **calibration**, where a law needs an omniscience principle; a **thesis**, an empirical claim with what would refute it; an **assessment**; a **reading**, labelled as an interpretation; or **open**. The core's source declarations have empty axiom reports, so each law holds constructively; that is not an absence of premises, and the real assumptions lie in the modelling, stated where a law depends on them. An AI review of prior work, not exhaustive, finds [none of the central results new mathematics](theories/becoming/chapters/08-METHOD.md#known-results): each is near-definitional or a known result restated. The ethics rests on two premises with two roles, neither asserted: the continuation condition (from every standpoint, for anything, its continuation into the future has significance) fixes whose losses count, and calling widening better orders; whether either can be warranted is open.

The footnotes of the README's opening say, sentence by sentence, which kind each claim is. Original words are kept verbatim with their source in [`sources/`](sources/README.md) and quoted as provenance, not as the warrant for a claim.

The work belongs to the commons and has no licence, by choice: [knowledge is a common good](COMMONS.md).

## Where to start

The theory is written in four layers, each of which can be read through on its own:

1. [One page](theories/becoming/ONE-PAGE.md) ([中文](theories/becoming/ONE-PAGE.zh.md)): one case, the root, the whole at a glance, with how each part stands and what would show it wrong, then the ethics' two premises, the open question, the evidence and what is not yet done.
2. [The Theory of Becoming](theories/becoming/THE-THEORY-OF-BECOMING.md) ([中文](theories/becoming/THE-THEORY-OF-BECOMING.zh.md)): the overview, the whole argument in one account, with one case start to finish, each paragraph linking to the chapter that states it.
3. Eight chapters, in order: [the root](theories/becoming/chapters/01-ROOT.md) (continuation relative to a class), [the map](theories/becoming/chapters/02-MAP.md) (generation, keeping and degeneration), [knowing](theories/becoming/chapters/03-KNOWING.md), [life](theories/becoming/chapters/04-LIFE.md), [collectives](theories/becoming/chapters/05-COLLECTIVES.md), [the classical texts](theories/becoming/chapters/06-CLASSICAL-TEXTS.md) (in Chinese), [significance](theories/becoming/chapters/07-SIGNIFICANCE.md) (ethics and alignment) and [method](theories/becoming/chapters/08-METHOD.md). Each result is stated once, in its home section.
4. The evidence, not for reading through: [the theory graph](theories/becoming/results/THEORY-GRAPH.md) (the grammar's concepts, the results, the Lean modules, the corpus texts, the chapter sections that state results and the review dossiers, with the edges between them: a dependence, a citation or a registered reading, not an agreement in meaning), [the results](RESULTS.md) with their records, [open questions](OPEN-QUESTIONS.md), the Lean package, the studies.

Pages for a reader who arrives with one question or field hang off this path and add no result: [one argument, end to end](theories/becoming/ONE-ARGUMENT.md), about twenty-eight to thirty-seven minutes, [the free-energy principle](theories/becoming/FREE-ENERGY-PRINCIPLE.md), [a collective's course](theories/becoming/COLLECTIVE-DIRECTION.md) and [the sciences](theories/becoming/review/SCIENCES.md). [What it is for, and how far](theories/becoming/USES.md) says, field by field, what can be done with the account today and what is not claimed; [the tests](TESTS.md) list every test by how it came out, the failures first.

Reviewers start with [the review packet](theories/becoming/review/README.md) ([中文](theories/becoming/review/README.zh.md)): a dossier for scholars of classical Chinese texts, one for scholars of Buddhist thought, one for logicians, one for philosophers on the ethics, one for researchers in AI alignment, one for scientists, and a blind re-coding of a sample of the corpus classification.

The [README](README.md)'s first screen is followed by [a statement of the whole in the first person](theories/becoming/OPENING.md). [Goals](GOALS.md) and the [directive register](_process/RESEARCH-DIRECTIVES.md) give scope and the directions behind it; the [glossary](GLOSSARY.md) gives each word its one sense.

## How it got here

[How the account grew](theories/LINEAGE.md) ([中文](theories/LINEAGE.zh.md)) tells it turning point by turning point, from the writings of 2021 to the account today, each point labelled by what states it and gathered and checked by AI readers, no person's, with one thread, the selection mechanism, followed through; its picture, labels and thread come first, in eight to eleven minutes, and the whole takes about an hour and a half.

The ideas began in writing from 2021 on: the sixteen earlier theory folders below, with their originals in `sources/` but for the chat logs, memory exports and recorded conversations, with a conversation's transcript in `drafts/`, which the repository has not tracked since 19 October 2026. The repository's first commit is from 6 September 2026, and it holds more than 6,000 commits by 7 November 2026; the formal theory has been built since October 2026. The history is part of the work, and nothing is deleted:

- **Commits.** `git log` shows each step. Where an instruction governed a step, the commit message quotes it.
- **`history/` folders.** Only the latest version of a document stays live. What it replaces moves byte for byte to a sibling `history/` folder, recorded in a manifest under [`_process/architecture/`](_process/architecture/), so earlier versions stay readable and linked.
- **Studies and records.** [`_process/research/`](_process/research/README.md) records each step of the work, failed candidates and counterexamples included; each result's record in `theories/becoming/results/records/` names its premises, evidence and boundary.
- **The work board.** [`_process/BECOMING-WORKBOARD.md`](_process/BECOMING-WORKBOARD.md) shows what each session has claimed and the order in which work lands.

Personal and third-party material (private chats, memories and conversations with friends) is not tracked from 19 October 2026.

## Check the proofs yourself

The Lean package `Becoming` is in [`experiments/integrated-correction/general-framework/generative-basis/lean/becoming/`](experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.md). Its core imports nothing outside itself, and every source declaration of the core has an empty axiom report: no `propext`, `Quot.sound` or `Classical.choice` (the only generated constants that depend on an axiom are constructor injectivity lemmas, on `propext`, which no source declaration uses). The core check needs Lean and Python 3 (standard library only), not Mathlib.

1. Install [elan](https://github.com/leanprover/elan), then the toolchain: `elan toolchain install leanprover/lean4:v4.29.1`.
2. From the repository root, with no cache and the receipt written outside the repository:

   ```bash
   BECOMING_FRESH=1 BECOMING_OUT=/tmp/becoming-run python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py
   ```

3. `"status": "passed"` on the last line means that, on your machine, every module compiled, the core's purity held and every audited declaration's axiom report was as recorded.

A fresh run compiles more than a thousand Lean steps and takes a while; `BECOMING_JOBS` sets how many run at once. Without `BECOMING_OUT` the checker writes its receipt into the repository. [Verify it yourself](experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.md#自行验证--verify-it-yourself) gives the details, and what a passing run does not show (whether the premises hold, whether the readings fit, whether the representation fits the world).

## Top-level layout

| Path | What it holds |
|---|---|
| `theories/becoming/` | The current theory: the one page, the overview, the eight chapters (`chapters/`), records (`results/records/`), the theory graph and generated results pages, `history/` |
| `theories/<folder>/` | The earlier theory folders (below, and [their index](theories/README.md)), not live; what each claimed and what became of it is in [the crosswalk](theories/becoming/results/atlas/CROSSWALK.md) |
| `experiments/` | Executable research; the Lean package Becoming is under `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/` |
| `_process/` | Studies (`research/`), the work board, directives, workflow, architecture receipts, `history/` |
| `sources/` | Imported originals and directive records, byte-preserved |
| `drafts/` | Papers and long drafts by date |
| `worldbuilding/` | The constructive half: worlds, atlas, causal engine |
| `tools/research/` | Rendering, checking, moves, evidence store |
| `tools/publishing/` | PDF builders for the exports in `output/`, and the builder of the reader's site, from the allow-list `site.pages` in `_process/research-config.json` |
| `output/` | Exported PDFs and images |

[REPOSITORY-LAYOUT](_process/REPOSITORY-LAYOUT.md) gives the rules for where new material goes.

## The earlier theory folders

The live account does not gather them whole. What each claimed in its own terms, and whether the account states it, takes it up and says otherwise, or does not state it, is in [the crosswalk](theories/becoming/results/atlas/CROSSWALK.md), claim by claim, with the twelve domains of thought read the same way; [the index of the folders](theories/README.md) counts what became of each, and [the connection map](theories/becoming/results/atlas/map.html) draws it (a page for a browser: open it from a clone of the repository, since GitHub shows only its source). Every entry is an AI reading, and no person has read them.

| Folder | In one line |
|---|---|
| [alignment-selection-on-cognition](theories/alignment-selection-on-cognition/README.md) | Selection on axes where winning buys capacity to win remakes the minds it scores |
| [architecture-for-a-living-earth](theories/architecture-for-a-living-earth/README.md) | Working exploration of building and settlement for a living Earth (opened 2026-09-13) |
| [context-as-existence-runtimes](theories/context-as-existence-runtimes/README.md) | "llm is operator, context is existence": the context runtimes and ember |
| [drives-narrative-attractors-and-mind](theories/drives-narrative-attractors-and-mind/README.md) | A mind is what an environment makes of ancient drive systems |
| [evolving-community-swarms](theories/evolving-community-swarms/README.md) | Exploratory design for communities that evolve (opened 2026-09-05) |
| [human-solutions-museum](theories/human-solutions-museum/README.md) | Civilization as an accumulated stock of methods that turn problems into mechanisms |
| [jian-and-wenyan-as-formal-language](theories/jian-and-wenyan-as-formal-language/README.md) | 简 and 文言 as a formal language for theory |
| [keep-the-possibility-space-open](theories/keep-the-possibility-space-open/README.md) | 保持可能性空间打开: that the generating go on |
| [memories-and-working-style](theories/memories-and-working-style/README.md) | The person making the claims, and the salvage yard |
| [meta-attractor](theories/meta-attractor/README.md) | The meta-attractor of winning and common organization |
| [relational-self-and-datong](theories/relational-self-and-datong/README.md) | The self as what a knot of relations is doing; 大同 |
| [selfishness-spiral-and-narrative-value-frames](theories/selfishness-spiral-and-narrative-value-frames/README.md) | Actors act from narrative-value frames, and the spiral they select |
| [spirit-space-token-and-yi-substrate](theories/spirit-space-token-and-yi-substrate/README.md) | Spirits, tokens and spaces; the Yi substrate |
| [the-fork-and-cooperative-infrastructure](theories/the-fork-and-cooperative-infrastructure/README.md) | Cooperative infrastructure (the two-outcome "fork" framing was later rejected) |
| [wamotopia-and-the-wamo-protocol](theories/wamotopia-and-the-wamo-protocol/README.md) | Technology amplifies the operating logic it runs under; the Wamo Protocol |
| [zhishan-intelligence-must-be-good](theories/zhishan-intelligence-must-be-good/README.md) | 智善: competition that selects survivors hands winners the rule |

The [theory map](theories/becoming/history/THEORY-MAP-2026-10-08.md) gives the longer branch-by-branch reading of these folders (a dated reading catalogue).
