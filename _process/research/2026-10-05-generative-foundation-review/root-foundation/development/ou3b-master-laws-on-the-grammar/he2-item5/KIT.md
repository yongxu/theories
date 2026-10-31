# HE2's item 5: GrammarMap's two edits from GW

*AI-written kit, 31 October 2026, by GrammarMap's owner (OU's), for whoever lands HE2's rebuild (the board's HE2 row, item 5). Checked outside the package; nothing here is package Lean yet.*

GW's history row (study §467) left two edits for GrammarMap's next rebuild. This kit states both exactly, so the lander can apply them by name in the same pass as HE2's other items.

## 1. The reach laws of the successor, stated once

The successor relation on `Nat` is defined twice, `Map.step` (GrammarMap) and `Steps.next` (Arising), each `fun m n => n = m + 1`. Three copies of the same two laws stand on them:
- `Map.step_reached_le` and `Map.step_reaches_of_le` (MapRegions);
- `Steps.reached_le` (WideningOnTheMap);
- HeldPossible's local `reached_le` and `reach_to` inside `Steps.generation_iff_begins`.

GrammarMap imports only `Becoming.Grammar`, and every module using the copies imports GrammarMap (GrammarLaws does too), so GrammarMap is the place below all of them.

**The edits** (corrected 31 October 2026, before any landing: the first version of this kit added `Map.step_reach_of_le` and `Map.step_reach_succ`, but MapRegions already proves the first as `Map.step_reaches_of_le`, so a new name would have stated the same law twice; the kit now moves the existing laws and adds none):
- **GrammarMap**, in `namespace Map`, after `step_irrefl`: MapRegions' three reach laws of `step` moved whole, with their names, statements and proofs unchanged:
  - `Map.step_reached_le`: what a line along the successor reaches is later;
  - `Map.step_reaches`: under the one, the line from 0 reaches every number;
  - `Map.step_reaches_of_le`: under the one, the line reaches every later number.
  
  Their proofs use only the grammar, `Init` and GrammarMap's `«所及之传递»`, which stands above them in the same module.
- **MapRegions:** the three are deleted, being now in GrammarMap under the same names; its uses read them there unchanged.
- **WideningOnTheMap:** `Steps.reached_le`'s proof becomes `Map.step_reached_le reached`, and its docstring says so. Its name and statement stay.
- **HeldPossible** (its owner): the local `reach_to` and `reached_le` inside `Steps.generation_iff_begins` become `Map.step_reaches_of_le` and `Map.step_reached_le`, with a comment and a docstring clause saying so.

`Steps.next` (Arising) and `Map.step` are the same definition, `fun m n => n = m + 1`, so the laws at `Map.step` read at `Steps.next` with no conversion.

**The script.** [he2_item5.py](he2_item5.py) applies both edits by text, with asserts: `--check` finds every edit's text once, or finds it applied; `--list` prints each; `--apply lean` writes the four files in the package, and `--apply lean --to DIR` writes them under `DIR/Becoming/` for a scratch build. The moved block is read from MapRegions itself, so what lands is the proof that was built.

**The check.** `--apply lean --to` a scratch tree, then the package's `scratch_build.py` on GrammarMap, MapRegions, WideningOnTheMap and HeldPossible ([log](scratch-build-script.log)). The first check, [tree/Becoming/HE2Item5Check.lean](tree/Becoming/HE2Item5Check.lean) ([log](scratch-build.log)), stays as evidence of the reading at `Steps.next`; its `reach_of_le` is the law `Map.step_reaches_of_le` already states.

**Records.** No name changes, so no name is rebound. One record cites the moved laws, by module: generation-and-degeneration-at-two-grains (law 6's declarations, and its MapRegions.lean reference, which lists `Map.step_reached_le`, `Map.step_reaches` and `Map.step_reaches_of_le`). At HE2's records step the three move from that reference to its GrammarMap.lean reference, where item 5 states them, the receipt rebinds both references' hashes as for every changed module, and the record's HE2 note says the successor's reach laws are now cited from GrammarMap (HE2's lander scripts it; the record is GrammarMap's owner's, who agreed it on 31 October 2026). `Map.step_*` change module, so the indexes regenerate at render and the theorem graph at THEOREM-CONNECTIVITY.py; no register entry names them.

## 2. GrammarMap's "is not stated" sentence

GrammarMap's docstring at "Some branch and every branch" ends: "How they stand to the regions below (`«生成»`, `«守»`, `«退化»`) is not stated: `«全守»` allows a carrying renewal before its point, which `«守»` forbids."

Modules that import GrammarMap now state it for two of the three strong forms, so the sentence becomes:

> How `«全生成»` and `«全守»` stand to `«生成»` and `«守»` is stated in modules that import this one: strong generation gives generation (`«全生成则生成»`, `Becoming.KeepingWidening`), and strong keeping gives keeping from some point on (`«全守则后守»`, `Becoming.MapRegions`) but not strict keeping, since `«全守»` allows a carrying renewal before its point, which `«守»` forbids (`Map.Once.keeping`, `Map.Once.not_keeps`); how `«有终»` stands to `«退化»` is not stated.

It is a docstring only, and changes no declaration. (Corrected after HE2's review, 31 October 2026: the first wording said "they", which takes in `«有终»`, whose relation to `«退化»` no theorem states, and called KeepingWidening a leaf, which it is not.)

## 3. The catalogues

The package's catalogues say where the reach laws are stated. The receipt pins `Becoming.lean` and `check_becoming.py`, so these edits go in before the landing run, in the same `--apply lean`; the SCOPE string changes no compiled step.
- `Becoming.lean`, GrammarMap's bullet: "Along the successor (`Map.step`) a line reaches exactly the later numbers (`Map.step_reached_le`, `Map.step_reaches_of_le`), stated here below every module that reads such a line." **And a repair:** GW's landing inserted MapRegions' bullet inside GrammarMap's, after "ending on every", so GrammarMap's last line ("branch of renewing into (`«生生即延»`, `«息即尽»`). Imported by …") stood under MapRegions'. The script moves MapRegions' bullet, unchanged, to after GrammarMap's end.
- `README.md` and `README.zh.md`, GrammarMap's row: "along the successor a line reaches exactly the later numbers" / "沿后继之线所及恰为其后之数", with the two names.
- `check_becoming.py`, SCOPE's GrammarMap string: "along the successor a line reaches exactly the later numbers".

## The review's other findings, taken

- HeldPossible's docstring of `Steps.generation_iff_begins` cited `Steps.reached_of_buqiong`, which the proof no longer uses. It now cites `Map.step_reaches_of_le` and `Map.step_reached_le`, in the sentence that cited it.
- The note above the moved laws names `Sampling`'s `arises_within` among their readers, after HE2's item 1.

## Composition with HE2's other items

Every edit is found by name or text. None touches Grammar.lean (items 1 and 7), GrammarLaws' sites (items 2, 3, 4 and 6), Response or SelectionPool. GrammarMap is edited by no other item. The catalogue edits are found by text in GrammarMap's entries only, which no other item edits. Grammar.lean, which items 1 and 7 edit, lies below GrammarMap, so HE2's rebuild recompiles GrammarMap and everything above it anyway; item 5 adds no rebuild of its own.
