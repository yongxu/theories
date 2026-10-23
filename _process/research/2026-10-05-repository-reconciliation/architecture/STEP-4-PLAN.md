# Step 4: landing the four layers and retiring what they replace

Board item RA, 23 October 2026. Work list for the landing of the eight chapters, the overview and the one page, with the retirement of the canonical chapter and the chapters the new ones carry. Written before the second round of the chapters finished, so that nothing is forgotten; each item is checked off in the landing commit's study section.

## Paths

| Layer | Path |
|---|---|
| One page | `theories/becoming/ONE-PAGE.md` and `ONE-PAGE.zh.md` |
| Overview | `theories/becoming/THE-THEORY-OF-BECOMING.md` and `.zh.md` (a new file one level above `chapters/`; the old canonical chapter keeps its bytes in history) |
| Chapters | `theories/becoming/chapters/01-ROOT.md` … `08-METHOD.md` |
| Retired | `theories/becoming/history/` by `research.py move` (plan first) |

## What the tools read from the canonical chapter, and where it goes

| Tool | Reads | New source |
|---|---|---|
| `completion.py` K5 | `## 0. Premise card`: the supplied parameters (`Unrestricted`, `Valuation.Held`, `Frame.realized`, `relabel`, `World.withRest`, `Conditions.valuation`, `ExchangeLaw.readWorld_glue`) | a premise card section in `08-METHOD.md` |
| `completion.py` K7 | `### 8.1 Open items, ranked`, items `N. **Title** (class). … *Open:* …` | an "Open items, ranked" list in `08-METHOD.md`, ported and brought up to date |
| `lean_catalogue.py` | group links to §9 (the formal spine) and §6 | `08-METHOD.md` (pure core), `07-SIGNIFICANCE.md` |
| `indexes.py` | §11 table of where earlier chapters stand; the canonical file's status | the eight chapters as the live chapters; retired chapters listed from the move receipt |
| `navigation.py` | canonical entry links; §6.4 link | the overview; `07-SIGNIFICANCE.md`'s condition anchor |
| `_process/research-config.json` | `open_questions` paths into §8.1–§8.8; `move_pinned` | anchors in `08-METHOD.md`; unpin the canonical chapter for its move |
| tests | `test_indexes` (canonical status), `test_moves` (working path) | updated to the new layout |

## Pages written by hand

- `AGENTS.md` "Start here" and its links to §6.4 and §9: the one page → the overview → the chapters (01 first) → the records; a copy of the text before the change kept in `_process/history/2026-10-23-instructions/`, as earlier revisions did.
- `GLOSSARY.md`: the vocabulary of the spine §5 and the decisions §3, each term with its home section; the index of formal terms is the theory graph.
- `MAP.md`: "Start here" for visitors, rewritten around the four layers.
- README: generated; its lead becomes the one page, after OPENING (Ren's voice, unchanged); the featured results move to the overview.

## Retired chapters

Every chapter in `theories/becoming/chapters/` other than the eight and the generated index, once the eight state what it carries (the inventory's dossiers and the carried-content critique are the check): the canonical chapter and its Chinese edition; the significance chapters (THE-STEP-OF-INVARIANCE, PRACTICAL-JUDGMENT, ALIGNMENT-DIRECTION, ALIGNMENT-THROUGH-CHANGE, BASIC-CONFLICT-JUDGMENT, CHOICE-AND-GENERATIVE-CONTEXT, ZERO-AXIOM-PRACTICAL-JUDGMENT, NONINSTRUMENTAL-CONCERN, ETHICAL-LEARNING, WISDOM-AND-CONTEXT); the method chapters (BECOMING-FOUNDATION, NONDUAL-METHOD, MATHEMATICAL-CORE, GENERATED-LOGIC, SCIENTIFIC-PHILOSOPHY, KNOWLEDGE, RELATIONS-ACROSS-SCALES); COGNITION-LEARNING-AND-EVOLUTION, THE-THEORY-OF-EVOLUTION, the two market chapters; the classical chapters (CHINESE-SOURCES-AND-BECOMING, YI-ZHUAN-AND-BECOMING, CIVILIZATION-THOUGHT-AND-BECOMING, WENLI-AND-BECOMING, THE-THEORY-OF-BECOMING-ZHONGHUA, DAO-AND-GENERATIVITY, HANZI-AND-THEORY-TREE, PRE-QIN-AND-WENYAN, WANG-YANGMING, LIANGZHI-EVOLUTION); their Chinese editions. Scripts that check a retired chapter (`verify_ro.py`, `verify_zh.py` and the like) follow it, or are repointed, as the move plan's reference list shows.

## Results landed while the chapters were drafted

The chapters were drafted from the state of 23 October morning. Results landed since (IV3e, IV3f and any later) are carried into their home sections from their records before the landing.

## Checks

`make research-render`, `research-check`, `research-links`, `research-test`; the anchor census (every non-retired record anchored once, every link to an anchor resolving); the theory graph shows no result without a home. Land from a clean worktree through the queue.
