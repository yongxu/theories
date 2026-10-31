# HE2's item 1: «两端分则中有标» on transitivity, and Sampling's search read from it

*AI-written kit, 31 October 2026, by OU3f's owner, for whoever lands HE2's rebuild (the board's HE2 row, item 1; WHAT-REMAINS, "After OU3f", item 2). Checked outside the package; nothing here is package Lean yet. Base: main `2f4a5bd96`; the five modules it reads are unchanged on main through `18b8b014c`. Revised the same day for item 5's names: item 5 moves MapRegions' three reach laws into GrammarMap whole and adds no name, so edit 3 reads `Map.step_reaches_of_le`. Revised again the same day for HE2's review (four lenses, then a skeptic), adding three things: the texts part, PatternPassing's gloss of the law, and a correction. The texts part covers 01 §3, the home section of the record whose law 10 HE2's records step widens, and LOGIC.md's L-04, at its owner's word. The correction: this kit said no chapter states the law's hypothesis, but 01 §3 does. Revised a third time for the word of OU's owner, who also owns the review packet: L-04 is taken at HE2's landing, with three further steps rehearsed, and 01 §3 says "a transitive relation", as law 10 does as approved.*

«两端分则中有标» was stated with `K` a class, though its proof uses only transitivity. Asking only for transitivity admits a relation that is not a class: that a property does not arise from one end of a line to the other. On the successor line, that relation turns Sampling's search for the step where a decided property arises into an application of the law.

## The edits

1. **Grammar, «两端分则中有标».**
   - **Hypotheses:** `split`, then `trans : ∀ {a b c}, K a b → K b c → K a c`, in place of `hK : «类» K` before `split`. The proof changes in one place, `hK.trans k k'` → `trans k k'`.
   - **Docstring:** it now says "a transitive relation", and that `K` need only compose, as a class does and as a property's not arising does. It names no module, so it reads true with or without edit 3. "Compose" here is the word OU's owner replaced in the prose (below, "Two words held").
   - **Why `split` now comes first.** With `trans` first, a caller passing a projection such as `(carrierClass_class V).trans` gets `K` solved as a constant function. The projection's points are created inside the binder that the expected type's implicit `∀` opens, so the higher-order pattern takes the constant solution. `split`'s type fixes `K` from its bound variables. The first scratch build failed this way; the reordered law builds.
2. **PatternPassing.**
   - In `ByPassing.passes_within` and `ByPassing.ends_within`, statements unchanged:
     - before: `«两端分则中有标» (carrierClass_class V) split line apart`
     - after: `«两端分则中有标» split (carrierClass_class V).trans line apart`
   - **The module docstring's gloss of the law** said "a line whose ends a class tells apart, every step of which keeps the class or carries a mark". It now says "a transitive relation `K`" and "keeps `K`", still applied to the carrier class. Three lines are rewrapped, none over 100 characters.
3. **Sampling.** Statements unchanged.
   - **`arises_within`:** along the successor, `K x y := ¬ (¬ p x ∧ p y)`, the property's not arising from `x` to `y`.
     - It is transitive with no decision.
     - The split is excluded middle on whether the property arises across a step, the one use of the given decidability.
     - The line from `T` to `t` comes from `Map.step_reaches_of_le`, and the places the law returns go back to order by `Map.step_reached_le`, the two reach laws item 5 moves from MapRegions into GrammarMap.
   - **`ceases_within`:** `arises_within` at the property's negation (its failing arises), the given decidability turning `¬¬ p u` into `p u`.

## The texts

The prose that states the law changes with it. This happens in HE2's texts step, before the re-point (`--texts`).

- **01 §3**, the home section of continuation-relative-to-a-class. HE2's records step widens that record's law 10 (below). The record is OU's owner's, who reads both texts at HE2's landing.
  - before: "For a class `K`, where every step of continuation either keeps `K` or carries a mark `P`, a line whose ends `K` tells apart has a step carrying the mark, placed on the line between them (`«两端分则中有标»`); the proof uses only the transitivity of `K`."
  - after: "For a transitive relation `K` (a class is one), where every step of continuation either keeps `K` or carries a mark `P`, a line whose ends `K` tells apart (`K` fails from its start to its end) has a step carrying the mark, placed on the line between them (`«两端分则中有标»`)."
  - Why these words:
    - "a transitive relation (a class is one)" and "tells apart" are law 10's words as OU's owner approved them.
    - OU's owner changed "a relation that composes" to "a transitive relation" in law 10 and here. In the package "composes" names the composition of relations («而», «对之接»), and the hypothesis is transitivity.
    - The parenthesis gives "tells apart" its exact sense, `¬ K x y`, for a relation that need not be symmetric.
    - The closing clause goes, since transitivity is now the hypothesis.
    - 01 has no Chinese edition, so there is no 「传递之关系」 to write.
- **LOGIC.md, L-04** (`--texts --logic`). This is the review packet's page. The board's RP row names its owner: the one-unfolding root's session, OU's owner. Without this edit, L-04 still quotes `(hK : «类» K)` after HE2 lands, under the dossier's claim that every block was compared again with the current sources.
  - **Taken** by RP's owner on 31 October: L-04 changes at HE2's landing, so the dossier stays true at the head, with the Meaning as written.
  - **In the same step**, as RP's owner asked, rehearsed on the edited copy of main's LOGIC.md:
    1. Rebuild LOGIC's reader edition with RP2b's builder, `python3 tools/publishing/build_review_packet.py LOGIC.md`, from the repository root. It writes a draft to `tmp/` (untracked); `--release` is for the frozen version that is sent. Rehearsed: `LOGIC.pdf` builds, and its HTML carries the new signature line and Meaning, with no `hK` left.
    2. Run the dossier checker, `check_dossiers.py` in `development/review-packet/`. Rehearsed: 0 problems, as on main.
    3. Recount LOGIC's front with AJ4's measure, `kit/measure_layers.py` on `aj4-human`. Rehearsed: 1,094 words and 3 characters (8.4 to 11.0 minutes), unchanged, since L-04 lies after the front. The whole dossier gains 12 words, from the Meaning.
  - **The block:** its first two lines are re-copied from the law's new statement. That is the same text the Grammar edit writes, so the block is again the source's statement up to `:=`.
  - **Its Meaning:**
    - before: "if every step either keeps `K` or carries `P`, a line whose ends `K` separates has a step carrying `P`"
    - after: "for a transitive relation `K` (a class is one), if every step either keeps `K` or carries `P`, a line whose ends `K` separates (`¬ K x y`) has a step carrying `P`"

## Applying it

**Apply** with [kit/apply_he2_item1.py](kit/apply_he2_item1.py): `PACKAGE` for the Lean edits; `--texts REPOSITORY` for the texts, adding `--logic` for L-04.
- Each edit is found by the text it replaces and must occur as often as stated; nothing is written unless every edit applies, and an edit already applied is reported and left.
- `--check` writes nothing.
- Edit 3 reads item 5's two laws, so the script refuses it until GrammarMap has them. `--weakening-only` applies edits 1 and 2 alone.
- The whole change as two diffs, each applying to main's files and giving the rehearsed ones:
  - [kit/he2-item1.diff](kit/he2-item1.diff): the three modules;
  - [kit/he2-item1-texts.diff](kit/he2-item1-texts.diff): 01 §3 and L-04.

## The checks

Rerun with [checks/run_checks.sh](checks/run_checks.sh), from the worktree root, at the base. [checks/make_tree.py](checks/make_tree.py) makes the tree:
1. It copies the four modules, refusing unless they and MapRegions match [tree/BASE.sha256](tree/BASE.sha256).
2. It moves MapRegions' three reach laws (`Map.step_reached_le`, `Map.step_reaches`, `Map.step_reaches_of_le`) into GrammarMap whole, as item 5 does. That is a stand-in for this check only: item 5's script writes GrammarMap and deletes the three from MapRegions, which no module built here imports.
3. It applies item 1 with the kit's own script, so the tree is what the kit writes.

| Check | Result |
|---|---|
| Build ([scratch-build.log](scratch-build.log)) | 33 modules compiled, none unclean. Every axiom report empty: Sampling 117 declarations, PatternPassing 46, the check module 3. |
| Statements ([tree/Becoming/HE2Item1Check.lean](tree/Becoming/HE2Item1Check.lean)) | The law's earlier form, `K` a class, is the new law at the class's `trans` (`of_class`). Sampling's earlier statements, written out, are the new theorems (`arises_within_stated`, `ceases_within_stated`). |
| Genuine ([checks/HE2Item1Reach.lean.txt](checks/HE2Item1Reach.lean.txt); [main](checks/reach-main.txt), [tree](checks/reach-new.txt)) | On main, both proofs search by their own recursion (`Nat.le.brecOn`) and use no grammar law. In the tree, neither recurses: `arises_within` uses «两端分则中有标», `Map.step_reaches_of_le` and `Map.step_reached_le`; `ceases_within` uses `arises_within`. The law is applied once; nothing is applied and undone. Sampling's four coarse-step theorems (`Web.sample_arises`, `sample_ceases`, `sample_unceasing`, `sample_ceasing`) reach «两端分则中有标» in the tree, and none does on main. |
| The weakening alone ([checks/scratch-weakening.log](checks/scratch-weakening.log)) | Edits 1 and 2 with nothing of item 5: PatternPassing builds over the weakened law, with Sampling's earlier proofs untouched. Every axiom report empty. |
| Length ([checks/measure.py](checks/measure.py), [output](checks/measure.out)) | See the table below. |
| The gloss | PatternPassing's module docstring after the edit, parsed by Lean on its own: no error, 50 lines as before, no comment opened inside it. The rows above ran before the gloss was added. The gloss changes no declaration, and HE2's rehearsal builds it. |
| The texts | Applied to copies of main's 01-ROOT.md and LOGIC.md at `18b8b014c`: each edit applies once, and a second run reports each as applied and writes nothing. L-04's block is the source's statement up to `:=`, on main before the edits and in the tree after them. |
| The diffs | Each applies to main's files and gives the rehearsed files byte for byte. |

**Length**, the proofs after the statements, docstrings not counted:

| | lines | characters | symbols |
|---|---|---|---|
| `arises_within` | 5 → 7 | 257 → 348 | 90 → 144 |
| `ceases_within` | 5 → 2 | 249 → 141 | 90 → 53 |
| both | 10 → 9 | 506 → 489 | 180 → 197 |

So "no longer" holds for the pair in lines and characters, but not in symbols (9% more), and not for `arises_within` alone.
- **Where the length goes.** The old search was a five-line recursion that named nothing. The derivation names:
  - the transitive relation;
  - its transitivity;
  - the one decided split;

  and it turns order into the line and back with item 5's laws.
- **What it buys.** The search is stated once, in the grammar, for every carrier, and ceasing is the arising of the failure.

**Taken: edits 1 to 3 together** (OU's owner, 31 October). HE2's aim is each law stated once with its cases derived from it (board rule 9), not "shorter by every measure". `--weakening-only` stays in the script for a rehearsal before item 5's script is applied.

## What HE2's landing runs for item 1

- **Order.**
  - After item 5, since edit 3 reads `Map.step_reaches_of_le` and `Map.step_reached_le` in GrammarMap, where item 5 moves them with their names.
  - With item 7 in either order: item 7 renames near Grammar's lines 581–612, and item 1's texts lie at the law (about 664–690), disjoint.
  - Items 2, 3, 4 and 6 edit GrammarLaws, Response and SelectionPool, which item 1 does not touch.
  - **The texts part** runs in HE2's texts step, before the re-point, and `--logic` only on RP's owner's word.
    - Items 6 and 7 also edit 01, but in §4, §5 and §7, not §3.
    - Of the review pages they edit PHILOSOPHY and BUDDHIST-THOUGHT, not LOGIC.
- **Signatures.** One statement changes, «两端分则中有标»'s hypotheses as above. No declaration in the package is added, removed or renamed; the check module is scratch.
- **Records.**
  - **Rebound:** none.
  - **Drift:** the records citing the three modules drift with the rebuild and are re-pointed with the reason:
    - Grammar: continuation-relative-to-a-class, precedence-and-its-links, processes-represented-both-ways, tasks-and-what-performs-them, the-present-on-causal-set-growth, the-world-represented-both-ways, what-a-course-keeps-reachable, what-can-be-born-next, what-choices-show-of-an-order, where-the-possible-grows;
    - PatternPassing: a-pattern-lasts-through-passing, continuation-relative-to-a-class, master-laws-on-the-grammar;
    - Sampling: continuous-time-as-tower, laws-at-coarser-steps, only-the-order-of-change-shows, relata-counted-up-to-indiscernibility.

    These are the records that name the paths; the records check gives the exact drift.
  - **The chapter's pins.** Nine records pin 01-ROOT.md by hash (role `statement`):
    - a-regularity-kept-and-changed, master-laws-on-the-grammar, precedence-and-its-links, processes-represented-both-ways, reach-from-a-seed, reorderings-as-courses-of-growth, the-present-on-causal-set-growth, the-source-texts-test-systems, the-world-represented-both-ways.
    - None of the nine hashes matches main's chapter today, and items 6 and 7 edit the chapter too. So the texts part adds no new kind of drift.
  - **Reason, for the re-point:** "HE2's item 1: «两端分则中有标» asks only that the relation it keeps be transitive (split, then trans, in place of a class), PatternPassing's two uses pass the carrier class's trans, and Sampling's arises_within and ceases_within are read from the law along the successor; statements unchanged but the law's hypotheses". It said "compose" until OU's owner's word on 31 October, and records' notes are live text.
- **One claim widened.** continuation-relative-to-a-class, law 10 (`laws[9].en`, `laws[9].zh`), whose declarations include «两端分则中有标», still reads true, but it states the law only for a class. The record is OU's owner's; HE2's records step writes the texts they approved, in both languages:
  - en, from "and where every step keeps a class or carries a mark, a line whose ends the class tells apart has a marked step" to "and where every step keeps a transitive relation (a class is one) or carries a mark, a line whose ends the relation tells apart has a marked step" (this kit proposed "a relation that composes"; OU's owner wrote "a transitive relation");
  - zh, from「凡每一步或保一类或带一标者，其两端为此类所分之线，必有带标之一步」to「凡每一步或保一传递之关系（类即其一）或带一标者，其两端为此关系所分之线，必有带标之一步」.

  Its home section, 01 §3, states the law's hypothesis too and changes with it (the texts part, above). An earlier version of this kit said no chapter states it. That was wrong: 01 §3 does, and the search behind the sentence missed it.
- **Where the law's hypothesis is stated.**
  - **How it was searched:**
    - every live mention of «两端分则中有标» was read: chapters, records, review dossiers, generated indexes, Lean modules and studies, but not `history/`, `sources/` or check receipts;
    - theories/ and the top pages were searched for "carries a mark", "keeps a class", "keeps the class or", "带标", "此类所分", "中有标" and the old signature `hK : «类» K`.
  - **Stated, and changed by this kit:**
    - Grammar's docstring (edit 1);
    - PatternPassing's gloss (edit 2);
    - law 10 of continuation-relative-to-a-class (HE2's records step);
    - 01 §3 (`--texts`);
    - LOGIC.md's L-04 (`--texts --logic`).
  - **Applied to a class or only named, and true as they stand:**
    - 01 §4, GrammarRegularity's module docstring and the record a-regularity-kept-and-changed, all on where a line first leaves its start's class of the core;
    - PatternPassing's docstrings at the law's two uses (the carrier class);
    - a-pattern-lasts-through-passing's history note;
    - LOGIC.md's question 11 and its table of names;
    - the generated indexes (lean-index.json, master-laws.json, becoming-core.md);
    - the board's HE2 row and WHAT-REMAINS, which describe this item.
- **Two words held.** Two docstrings this kit writes still use "compose" for transitivity, the word OU's owner replaced in the prose:
  - Grammar's, at the law. Its title already says "a transitive relation", but its last sentence reads "`K` need only compose, as a class does (by its `trans`) and as a property's not arising from one end to the other does". The proposal is "`K` need only be transitive, as a class is (by its `trans`) and as a property's not arising from one end to the other is".
  - Sampling's, at `arises_within`: "the property's not arising composes". The proposal is "the property's not arising is transitive".

  Changing Grammar.lean's bytes reruns Grammar's whole cone, and HE2's rebuild restarted at `5f0672b31` without the change. So the proposal goes in only if that run restarts for another reason, at the lander's choice. Otherwise it is held for the next near-full rebuild and listed on that rebuild's row, not left to memory. Either way it changes no statement.
- **The master-laws view** (master_laws.py, rerun on the receipt as after every core landing).
  - Expected: laws-at-coarser-steps law 8 moves from "no master law" to the grammar. Its declarations `Web.sample_arises`, `Web.sample_ceases`, `Web.sample_unceasing` and `Web.sample_ceasing` now reach «两端分则中有标» through `arises_within` and `ceases_within` (the genuineness check reads each), and nothing outside Sampling uses those two or the coarse-step theorems.
  - The central measure (COVERAGE) does not move: none of these declarations is central.
