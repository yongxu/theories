# HE2: the held edits in one near-full rebuild

*AI-written design, 31 October 2026, by HE2's lander (the owner of items 6 and 7), on HE's pattern ([HE's design](../he-held-edits/DESIGN.md)). The board's HE2 row lists the items. OU's owner decides the grammar's additions and names. The coordinator sets the slot: after RF-M.3, by readiness with RR2. The lander asks OU's owner before claiming the head.*

## The items and their kits

Each item's owner wrote its kit. Each kit applies its edits by text, checks every edit before it writes, and has `--check`.

| item | kit | branch or commit | parts |
|---|---|---|---|
| 1 | `ou3f-activity-laws/he2-item1/kit/apply_he2_item1.py PACKAGE` | `ou3f-laws` at `884753120` | Grammar (`«两端分则中有标»`: split, then trans), PatternPassing (two calls), Sampling (`arises_within`, `ceases_within` read from the law through `Map.step_reaches_of_le` and `Map.step_reached_le`). The Sampling part needs item 5's move. |
| 2–4 | `u4-one-root-to-its-edge/he2-items-2-to-4/he2_u4.py` | `he2-item2` at `4ca8098e2` | `--apply lean`: GrammarLaws gets 38 declarations, and Response and SelectionPool get three proofs. `--apply records N` and `--apply register LOG` after the run. |
| 5 | `ou3b-master-laws-on-the-grammar/he2-item5/he2_item5.py`, run from the checkout root | `he2-item5` at `621fe1534` | GrammarMap: `Map.step_reached_le`, `Map.step_reaches` and `Map.step_reaches_of_le` moved whole from MapRegions, nothing added; WideningOnTheMap's and HeldPossible's copies re-proved as one application each; one docstring sentence. The one record citing the three, generation-and-degeneration-at-two-grains, is moved by the lander's records kit. |
| 6–7 | `rv21-one-sense/kit/he2_core_li.py` | on main (`ea7a9f4e1`), and `HELD` since, for the lander's records kit | `--apply lean`, `texts`, `register LOG` (NOTE §8); its records part runs inside `kit/he2_records.py` |

## Order

1. **Gather.** In the landing worktree, merge `he2-item2`, `ou3f-laws` and `he2-item5`. They hold study files only, and they bring their kits and the render into one commit.
2. **Lean, all parts, before the checker.**
   - Items 2–4, then 6–7 (`--apply lean`), then item 5 (`--apply lean`), then item 1 (its Sampling part after item 5).
   - Every kit's `--check` is run again after all have applied.
   - Items 2–4 re-run `--names` against the head, so that names landed since are checked too.
3. **The checker's run** (`check_becoming.py`), the one near-full rebuild. Every axiom report must be empty. A rehearsal runs it with `BECOMING_OUT` outside the repository, and the landing run reuses its steps.
4. **The signature audit** (`kit/he2_signatures.py`). Each item's expectations are read from its own kit:
   - 7 names gone and 7 added, each new statement the old one renamed;
   - 42 laws added to GrammarLaws, and item 5's added to GrammarMap;
   - `Map.step_reached_le` moved;
   - only `«两端分则中有标»` changed;
   - kept-name statements and definitions differ only by the renames.
5. **Records, after the run**, all in `kit/he2_records.py RECEIPT N` (`--check` first; it checks every record before it writes one):
   - items 2–4's records part, then items 6–7's, each without its notes;
   - item 1's widening of continuation-relative-to-a-class `laws[9]`, en and zh, as its owner gave it;
   - item 5's move in generation-and-degeneration-at-two-grains: the three reach laws cited from the GrammarMap reference, not the MapRegions one, both hashes and the validation scope's counts following;
   - the master-laws record's `validation_scope`, en and zh, with the receipt, GrammarLaws' counts (every declaration cited) and the reviews; HE2's design, review and receipt referenced;
   - one HE2 history note per record: the item's own where one item changes it, else each item's clause in item order.
6. **The apart register.** `THEOREM-CONNECTIVITY.py --check` gives the log. Then each kit's register part runs (items 2–4's, then 6–7's), each printing roots that are not its own. Items 6–7's part also drops «核为类»'s entry: «定后则类之核同行» uses it, so it is no longer a root. Then `--write`, and `--check` again.
7. **Texts**, before the re-point, so that one re-point covers the sections they change:
   - items 6–7's texts part (01, 07, the glossary, the review pages);
   - `kit/he2_texts.py RECEIPT N REPOINTED`: 08's core counts and the study section, run after the re-point once its count is known (it changes no section a record cites).
8. **The re-point.** `research.py check` gives the drift. `tools/research/repoint.py --drift-json … --receipt … --lean <the 13 changed modules> --reason …` then sets each drifted reference to the current bytes and rebinds each changed module's proof binding to the receipt. Every drifted record is read first, with its changed source; the review covers them. The reason names each item; item 1's owner gave its own in its kit.
9. **MV's generator** (`master_laws.py`) on the receipt. In the dry run, two record laws moved from "no master law" to the grammar: laws-at-coarser-steps law 8 through item 1, and master-laws law 3 (the list lemmas) through items 2–4. Items 3–4's three model lemmas now reach the grammar's closure laws directly, but the four record laws citing them already reached the grammar. `central_reach` is unchanged at 44/16/7/51.
10. **Render, then the checks:** strict check, links, tests and the dossier check, in a clean worktree.
11. **Board.** The head is claimed by the commit-tree method, and only after OU's owner says yes. The landed clause follows. HE2's row moves to the history file's landed rows with the kit links.

## Checks before the head

- **The pre-rehearsal** outside the repository, with all seven items applied, as soon as item 5's script is there. Its steps stay in the shared cache.
- **The rehearsal** on the main that holds RF-M.3. It reuses all but what landed since.
- **One independent review** of the gathered tree and this kit before the head is claimed.
- **Already checked.** Items 2–4, item 1's weakening, and 6–7 together compile their changed closure, 120 modules, with every axiom report empty ([log](../rv21-one-sense/kit/he2_combined_2to7.log)).
- **The pre-rehearsals** (31 October, on main `c05f4eab8`, outside the repository):
  - Items 2–7 with item 1's weakening: the checker passed (1379 Lean steps run, 61 reused), and the signature audit found every statement and definition of the 13 changed modules as the items say.
  - Item 1's Sampling part, from its revised tip: the checker passed again (55 steps run, 1385 reused), with the same audit result. The theorems' statements go from 747 to 785. Seven names are renamed, 6 theorems and 1 definition. Forty-two declarations are added to GrammarLaws, 38 theorems and 4 definitions. Three are moved, and one is changed (`«两端分则中有标»`). Three statements and two definitions change by the renames only.
  - The records kit applied to that tree: six records, one HE2 note each.
  - The audit's first run counted definitions as missing, since the signature logs list theorems only. It now reads definitions from the sources.
