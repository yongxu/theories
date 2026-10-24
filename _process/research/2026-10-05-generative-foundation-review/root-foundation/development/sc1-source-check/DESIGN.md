# SC1: does a model under-detect what its own text smuggles in? Design and analysis plan

Pre-registered: this file, `kit.py` (including `analyze`), `select_laws.py`, the briefs and `data/laws.jsonl` are committed before any statement is written or coded. Board item SC1.

## 1. The question

In FC1's calibration ([FIDELITY-RESULTS, open observation](../../../../../../experiments/wenli-reading-transfer/FIDELITY-RESULTS.md#an-open-observation-the-author-coding-its-own-text)) the Claude coder, the AI that wrote the 中华本, found no excess referent in any of 26 經 segments, while the GPT coder found some in 10; on English clauses the two agreed (α 0.91). Two readings:

- **Blind spot (author-specific):** a model under-detects what its own text introduces, and another model sees it.
- **Over-reading (coder-general):** the GPT coder counts as excess what is not, in any text.

A third, which the calibration cannot exclude either, is **general under-detection**: the Claude coder misses excess in every text, its own or not.

The readings differ in where the effect sits. A blind spot is an interaction of author and coder: each coder finds less in its own texts than in the other's, relative to the other coder. Over-reading and general under-detection are main effects of the coder. A crossed design (two authors × two coders, every text coded by both) separates them; texts with a referent planted at a known span give a ground truth for detection, which the unplanted count lacks.

## 2. Materials

- **Laws.** `select_laws.py`: the FC1 units whose declaration is a theorem of FC1's Lean table (`zhonghua/fidelity/data/lean_table.jsonl`, sha256 `478c555f…`, as in FC1's MANIFEST), not flagged as an example or a reading, with a Lean form of at most 3000 characters as the coders see it (79 distinct declarations); a seeded sample of 60 (`data/laws.jsonl`). Each law is assigned a plant class, A, R or E, 20 each, seeded.
- **Authors.** Claude (Opus, a Claude Code subagent given only the brief and the packet file) and GPT (gpt-6-astra, high effort, `cx --fresh --clean`, the packet inline, `run_cx.sh`). Both get the same brief (`briefs/author.md`) and the same two packets of 30 laws (`data/author_packets/`). For each law each author writes a **faithful** plain-English statement (introducing nothing the Lean lacks) and a **planted** version, the same statement with exactly one added referent of the law's class, made to read naturally, with the added span and its head word. 60 laws × 2 authors × 2 versions = 240 texts.
- **Plant validity.** A plant is valid where its span occurs in the planted text and contains its head word; invalid plants are excluded from detection measures and reported. `kit.py texts` also counts changed tokens outside the span.

## 3. Coding

Both models code all 240 texts by the FC1 codebook v1.1 (`zhonghua/fidelity/briefs/code.md`, unchanged, with its schema), table pass, with no key and no candidate spans (the statements were written under no glossary). Packets (`kit.py code_packets`): the four texts of each law go to four of six sets (law *i*'s texts to sets *i*, *i*+1, *i*+2, *i*+3 mod 6, in a seeded order), so no set holds two texts of one law; each set of 40 is shuffled and split into two packets of 20 (`code_00`–`code_11`). Text ids are opaque hashes; author, version and plant are not in the packets.

- **GPT coder:** one `run_cx.sh` run per packet (12 runs), the FC1 brief and the packet inline.
- **Claude coder:** six Opus subagents, each coding the two packets of one set (40 texts of 40 distinct laws), told to read the brief and its two packets only, writing one output per packet.

The Claude coder sees 40 texts in one context and the GPT coder 20; neither sees two texts of one law.

## 4. Measures

For each text and coder, from the coder's list:

- **X:** the number of referents coded excess (A, R or E).
- **hit** (planted texts): 1 if some excess referent's span shares a word with the plant's new words (the span's words absent from the faithful text, stop-words removed; the head word if none), else 0. A plant coded as matched is a miss.
- **X_out** (planted texts): X minus the excess referents that hit the plant.

## 5. Analysis

Cell means m(author, coder) over texts. Contrasts:

- self difference of coder *c*: s_c = m(c, c) − m(other, c);
- **interaction I = s_Claude + s_GPT** = m(C,C) − m(G,C) − m(C,G) + m(G,G); a blind spot in a coder makes its s negative beyond what the author's texts do to both coders, so I < 0 is a self-detection deficit;
- coder effect (GPT − Claude), averaged over authors; author effect (Claude − GPT), averaged over coders.

Uncertainty: cluster bootstrap over laws (all of a law's texts and codings resampled together), B = 10,000, seed `SC1-boot`, 95% percentile intervals. Missing codings are dropped from their cells and reported.

With two families the design identifies the sum of the two coders' self effects, not each one: m(a,c) = μ + α_a + β_c + δ_c·[a = c] gives I = δ_Claude + δ_GPT, and s_Claude alone is confounded with the author effect (how subtle Claude's own plants are). A Claude-only blind spot shows as I < 0 unless the GPT coder has an equal self advantage.

## 6. Decision rule

- **R1 (primary, ground truth):** I on plant detection. Interval below 0: a self-detection deficit (blind spot) is supported. Above 0: a self-detection advantage. Including 0: no author-specific deficit is detected at this scale; the interval's lower bound is reported as the largest deficit the data allow.
- **R2 (secondary):** I on X of the faithful texts, read the same way.
- **R3 (coder-general):** the coder effect on detection and on faithful X.
  - Detection effect above 0 (GPT detects more plants): the Claude coder under-detects generally.
  - Faithful-X effect above 0 with a detection effect whose interval includes 0 or lies below it: the GPT coder counts more where it is no better at finding planted excess; consistent with over-reading or a laxer threshold (the faithful texts carry no ground truth, so these two are not told apart here).
- **Ceiling:** if every detection cell is at least 0.95, R1 is uninformative and is reported so.
- **Scope:** the texts are English. The calibration's discrepancy was on classical Chinese under a name table. A null R1 here says that the blind spot is not a general author effect in plain English; it leaves open a blind spot specific to the author's own controlled code, and GPT over-reading specific to classical Chinese.

Secondary, reported without a decision: detection by plant class; classes of excess in the faithful texts; the number of faithful texts with any excess, per cell; X_out (excess outside the plant).

## 7. Scale

2 Claude author subagents, 6 Claude coder subagents; 2 GPT author runs and 12 GPT coder runs (plus retries of failed runs, counted).
