# WRP2: landing the processes' representation

29 October 2026. AI-written landing note for board item WRP2. It says what lands, the decisions taken at landing, the exact command sequence and what the run showed. The scripts are in [kit/](kit/).

## What lands

**Lean.** From [tree/Becoming/](tree/Becoming/):
- `Becoming.GrammarLaws`, extended under its owner's decision (a). It adds `«历»`, passing through a word's relations in turn, with `«迭»` its case for one relation repeated (`«迭即历»`), with its laws `«历之接»`, `«历之末步»`, `«历之逆»`, `«历之定前»` and `«同行之历»`, and the five list lemmas they use. Six laws of `«迭»` are proved as their cases: `«迭之接»`, `«迭之分»`, `«迭之末步»`, `«迭之逆»`, `«迭之定前»` and `«同行之迭»`.
- `Becoming.GrammarTransport`, extended with 14 declarations:
  - preserving as an image lying within (`«保之像»`);
  - going on along some branch, pulled back along lifting (`«延之拉回»`);
  - passing through a word carried with its letters renamed (`«历之像»`), with steps its case (`«迭之像»`);
  - the correspondence lemmas for within `n` steps, closed regions, a fixed successor and predecessor, going alike and going on;
  - correspondences side by side (`«一一对应».prod`), and one list lemma (`GrammarTransport.map_replicate`).
- `Becoming.ProcessRepresentation`, a new leaf at L1, 52 theorems in 70 declarations. It imports `Becoming.EdgeClosure`, `Becoming.GrammarTransport`, `Becoming.Labelled`, `Becoming.Onward`, `Becoming.GrammarRegularity` and `Becoming.GrammarCandidates`. After the review of the Lean, a renaming relating two processes keeps every bridged notion (`renaming_*`), which gives the correspondence lemmas their consumer.

[signatures.json](signatures.json) is the signature audit, against the latest core receipt. Every landed declaration of the two extended modules keeps its statement (`#check @`), and every definition keeps its body (`#print`). Nothing is removed, and exactly the six theorems above change their source. The whole package compiles with the three modules and no clash ([clash-3.log](clash-3.log)). The review of the Lean, every finding taken, is [REVIEW-WRP2](REVIEW-WRP2.md).

The new module is added:
- to `CORE` in `check_becoming.py`, after `Becoming.WorldRepresentation`, with its scope sentence; GrammarLaws' and GrammarTransport's sentences are extended;
- to the root `Becoming.lean`, as an import and an L1 bullet after WorldRepresentation's; GrammarLaws' and GrammarTransport's bullets are extended;
- to the package README rows, EN and ZH, after WorldRepresentation's; GrammarLaws' and GrammarTransport's rows are extended.

**Records.**
- `processes-represented-both-ways`, new, recorded-checked, family F01, home 01 §8.1. It cites ProcessRepresentation's 70 declarations and GrammarTransport's 14 additions, each once, in eleven laws. It cites «历» only where traces read it, and links to the master-laws record for the law.
- `master-laws-on-the-grammar` gains one law for GrammarLaws' 12 additions, placed after the law of steps counted and worded as its owner asked, with its GrammarLaws reference extended and a history note. Its statement and other laws are unchanged.
- `the-world-represented-both-ways` has its item and next step on processes brought to the new record, with a related entry and a history note. No statement, law or declaration changes.

**Texts.**
- 01 §8.1: the theorem block and the table's process row.
- 01: its bases line (any process split from any type), thesis, claims paragraph and Open entry, and §8.6's not-shown line on processes.
- 01 §7's finite runs, for `«历»`.
- 08: its Open entry, and its counts read from the receipt.
- The overview's two sentences on faithful representation.
- L-21's weakness line in the logic dossier.
- The one page, both editions.
- The glossary line for the moves' relations.
- The study section.
- regions.json: the record and the module.

## Decisions

- **Records follow the modules.**
  - GrammarLaws' additions go to its record, master-laws-on-the-grammar, as OU3d's, OU3e's and OU3f's did.
  - GrammarTransport's additions go to the processes' record, whose terms they keep, as WRT2's went to the World's.
- **Re-pointing.** No landed statement changes. The records citing GrammarLaws or GrammarTransport drift by their bytes only; they are re-pointed and their proof bindings rebound. The records whose cited sections the texts write are re-pointed after reading.
- **The measure** is taken before and after on the measure_grammar and EC measures. WRP's own measure is retaken at the receipt.

## Commands

All commands run from the landing worktree's root (`.claude/worktrees/wrp2`, branch `wrp2`, merged with main). `K` is this folder's kit, `P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming`, and `RF=_process/research/2026-10-05-generative-foundation-review/root-foundation`.

1. `python3 -B $K/signatures_wrp2.py --json <this folder>/signatures.json`, at the latest receipt. Then the measures before: `measure_grammar.py`, EC's `measure.py` and this folder's `measure_wrp.py`.
2. `python3 -B $K/integrate_wrp2.py`.
3. `(cd $P && python3 -B check_becoming.py)`, giving `RECEIPT`.
4. `python3 -B $RF/THEOREM-CONNECTIVITY.py --check`. Any apart roots it reports are registered by `$K/register_wrp2.py` from the log; then the check runs again, and `--write`.
5. `python3 -B $K/texts_wrp2.py RECEIPT N`, where `N` is the last § plus one.
6. `python3 -B $K/make_records_wrp2.py RECEIPT N`.
7. `python3 -B $K/repoint_wrp2.py RECEIPT`, a dry run, then the same with `--apply`.
8. The measures after; then `tools/research/master_laws.py` (MV) on the new receipt.
9. `python3 -B $K/board_wrp2.py head TEXT` before step 2; `python3 -B $K/board_wrp2.py land RECEIPT N "QUEUE" "STATE"` here.
10. In the clean worktree: `make research-render`, then `research-check` with `--strict-fresh`, `research-links` and `research-test`. Commit the owned paths with `git commit -m … -- <paths>`, merge main if it moved, re-render, and fast-forward main.

## What the run showed

**The rehearsal.** The checker ran outside the repository first (`BECOMING_OUT` in the scratchpad, `BECOMING_JOBS=4`), on the branch at `29c3e4206` with the integration applied, so the landing run reuses its steps. It passed in 4 minutes 41 seconds:
- 342 modules in the closure; the core compiles from the prelude alone; the sources were unchanged during the check;
- GrammarLaws 136 theorems in 160 declarations, GrammarTransport 54 in 58, ProcessRepresentation 52 in 70, every axiom report empty, and no spine module with an axiom;
- 16,713 theorems, 22,797 declarations audited, and 231 generated `injEq` lemmas on `propext`.

**The landing run.** 29 October 2026, in `.claude/worktrees/wrp2`, branch `wrp2` merged with main at the head clause `e519da671` (RF round 1 landed at `cbb396723`).
- **The signature audit**, at RF's receipt `20261029T134236.345943Z` ([signatures.json](signatures.json)):
  - 192 landed statements and 26 bodies unchanged;
  - GrammarLaws 148 → 160 declarations, GrammarTransport 44 → 58, nothing removed;
  - the six proofs of «迭» the only changed sources.
- **The checker passed** in 1 minute 38 seconds, reusing the rehearsal's steps; the fresh compiles were RF's three leaves and the root. Core receipt `20261029T142634.455566Z`:
  - 345 modules in the closure; the core compiles from the prelude alone;
  - GrammarLaws 136 theorems in 160 declarations, GrammarTransport 54 in 58, ProcessRepresentation 52 in 70, every axiom report empty;
  - 16,756 theorems, 22,861 declarations audited, and 233 generated `injEq` lemmas on `propext`.
- **Connectivity.**
  - No new apart root: the renaming theorems connect every GrammarTransport addition to the base.
  - Three of WRT2's GrammarTransport roots, `«一之像»`, `«所闭之对应»` and `«静之像»`, now have consumers in the renaming theorems. Their register entries are retired (`kit/register_wrp2.py`).
- **Texts and records.**
  - The texts wrote study §447.
  - processes-represented-both-ways was written with 84 declarations in 11 laws.
  - master-laws-on-the-grammar gained its law, the ninth of nineteen, after the law of steps counted.
  - the-world-represented-both-ways had its item and next step on processes brought to the new record.
- **Re-pointing.**
  - Five records citing GrammarLaws or GrammarTransport re-pointed to the new bytes, with the proof bindings of the two files rebound to the receipt in three of them.
  - Eleven records whose cited sections the texts write, read first: eight cite 01 before its first heading, three the overview's §1 and §10.
  - Logged in `_process/architecture/rebinds.jsonl`.
- **The measures**, before at RF's receipt and after at WRP2's:
  - measure_grammar unchanged: 45 of 127 central declarations reach the grammar, and the distinct split 44 / 31 / 7 / 36 has no gap;
  - EC's measure unchanged: 39 rest on no master law;
  - WRP's measure grows by WRP2's own 76 theorems, all reading no field: 3,209 on processes, 1,336 binding.
  - The six files are `measure-*-before.json` and `measure-*-after.json`.
- **MV** was regenerated on the receipt (`tools/research/master_laws.py`).
