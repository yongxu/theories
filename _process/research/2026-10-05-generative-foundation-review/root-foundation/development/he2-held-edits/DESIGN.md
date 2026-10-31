# HE2: the held edits in one near-full rebuild

*AI-written design, 31 October 2026, by HE2's lander (the owner of items 6 and 7), on HE's pattern ([HE's design](../he-held-edits/DESIGN.md)). The board's HE2 row lists the items. OU's owner decides the grammar's additions and names. The coordinator sets the slot: after RF-M.3, by readiness with RR2. The lander asks OU's owner before claiming the head.*

## The items and their kits

Each item's owner wrote its kit. Each kit applies its edits by text, checks every edit before it writes, and has `--check`.

| item | kit | branch or commit | parts |
|---|---|---|---|
| 1 | `ou3f-activity-laws/he2-item1/kit/apply_he2_item1.py PACKAGE`, and `--texts REPOSITORY --logic` | `ou3f-laws` at `5f0672b31` | Grammar (`«两端分则中有标»`: split, then trans), PatternPassing (two calls and the law's gloss), Sampling (`arises_within`, `ceases_within` read from the law through `Map.step_reaches_of_le` and `Map.step_reached_le`). The Sampling part needs item 5's move. `--texts`: 01 §3, the home section of continuation-relative-to-a-class; `--logic`: LOGIC.md's L-04, which its owner asked for. |
| 2–4 | `u4-one-root-to-its-edge/he2-items-2-to-4/he2_u4.py` | `he2-item2` at `80ccb2e7c` | `--apply lean`: GrammarLaws gets 37 declarations, Response and SelectionPool get three proofs, and the package's catalogues (Becoming.lean, both READMEs, the checker's scope) their clauses. Its records part (law 3's census, law 18's three derivations with Response's and SelectionPool's references, bound to the run) and its register part run inside the lander's kits. |
| 5 | `ou3b-master-laws-on-the-grammar/he2-item5/he2_item5.py`, run from the checkout root | `he2-item5` at `d54f52264` | GrammarMap: `Map.step_reached_le`, `Map.step_reaches` and `Map.step_reaches_of_le` moved whole from MapRegions, nothing added; WideningOnTheMap's and HeldPossible's copies re-proved as one application each; GrammarMap's sentence on the strong forms; the catalogues, with MapRegions' entry in the root module moved out of GrammarMap's. The one record citing the three, generation-and-degeneration-at-two-grains, is moved by the lander's records kit. |
| 6–7 | `rv21-one-sense/kit/he2_core_li.py` | on main (`ea7a9f4e1`); `HELD`, the «核为类» drop and one more wording on `he2-land` | `--apply lean`, `texts`, `register LOG` (NOTE §8); its records part runs inside `kit/he2_records.py` |

The landing worktree is on `he2-land`, which holds the three item branches and this kit.

## Order

1. **Gather**, before the head. Commit on `he2-land`, with `-- <paths>`: this folder (the design, the kit, and `review/REVIEW-HE2.md` with every finding and what was done), items 6–7's kit as the lander's kits load it, and the combined log. The records kit references the design and the review by their bytes, so both are final before step 6.
2. **The head, then main.** Only after OU's owner says yes, claim the head by the commit-tree method: `kit/he2_board.py head TEXT OWNER WORKSPACE` on a copy of main's board claims the queue's head and HE2's row (owner and workspace), and the fast-forward of that one commit fails if main has moved. Then merge main into the landing worktree. After the merge, scan for what main brought: `he2_core_li.py --scan` (no new use of an old name), and the records kit's own checks (no record but generation-and-degeneration-at-two-grains cites the three moved laws; the study's next section).
3. **Lean, all parts, before the checker.**
   - Items 2–4, then 6–7 (`--apply lean`), then item 5 (`--apply lean`), then item 1 (its Sampling part after item 5).
   - Every kit's `--check` is run again after all have applied.
   - Names landed since are checked by the run itself: the root module imports every module, so a name declared twice
     fails its build. (Items 2–4's `--names` check imports the whole package beside its names, so it can only run on an
     unapplied tree; the run covers the same clash.)
4. **The checker's run** (`check_becoming.py`) in the landing worktree, writing the receipt and `becoming-verification.json` in place. Every axiom report must be empty. It reuses the rehearsal's steps; only what main brought since runs.
5. **The signature audit**, before any commit that carries the new `becoming-verification.json` (it reads the old receipt from `HEAD`): `python3 -B kit/he2_signatures.py RECEIPT > $SIGLOG`. Each item's expectations are read from its own kit:
   - every changed module's source the one checked, no other Lean file changed, the root module's code unchanged but for the renames;
   - 7 names gone and 7 added, each new statement the old one renamed (6 theorems, 1 definition);
   - 41 declarations added to GrammarLaws (37 theorems, 4 definitions), and nothing to GrammarMap but the three moved;
   - the three reach laws moved from MapRegions to GrammarMap;
   - only `«两端分则中有标»` changed;
   - kept-name statements and definitions differ only by the renames; no command removed, none added outside GrammarLaws.
6. **Records**, all in `kit/he2_records.py RECEIPT N` (`--check` first; it checks every record before it writes one, snapshots every record and restores them if anything fails):
   - items 2–4's records part, then items 6–7's, each without its notes;
   - item 1's widening of continuation-relative-to-a-class `laws[9]`, en and zh, as its owner gave it, and that record's Grammar counts (stale since OU6);
   - item 5's move in generation-and-degeneration-at-two-grains: the three reach laws cited from the GrammarMap reference, not the MapRegions one, and the validation scope's counts; the hashes are the re-point's;
   - laws-at-coarser-steps: its scope's Sampling binding names the receipt (item 1);
   - the master-laws record's `validation_scope`, en and zh, with the receipt, GrammarLaws' counts (every declaration cited) and the reviews; its does-not-show item on a pairing under continuation narrowed as GrammarLaws' module doc is; a hypothesis on what counting reads; HE2's design, review and receipt referenced;
   - one HE2 history note per record, eight in all, dated by the local day: the item's own where one item changes it, else each item's clause in item order, the lander's last.
7. **The apart register.** `THEOREM-CONNECTIVITY.py --check` gives the log. Then each kit's register part runs (items 2–4's, then 6–7's), each printing roots that are not its own. Items 6–7's part also drops «核为类»'s entry: «定后则类之核同行» uses it, so it is no longer a root. Then `--write`, and `--check` again into `$CONNLOG`, which must report nothing.
8. **Texts**, before the re-point, so that one re-point covers the sections they change: items 6–7's texts part (01 §4, §5 and §7, 06 §四, 07 §2, §4 and §8, the glossary, the two review pages), and item 1's (`--texts . --logic`: 01 §3 and LOGIC.md's L-04, its owner agreeing). Then, for the two dossiers these change (LOGIC by L-04, PHILOSOPHY by P-26): their reader editions rebuilt with `tools/publishing/build_review_packet.py LOGIC.md PHILOSOPHY.md` (drafts, untracked); `check_dossiers.py` at 0 problems; LOGIC's front recounted with AJ4's `measure_layers.py` (from `aj4-human`, run from a copy that is never committed), unchanged at 1,094 words since L-04 lies after it.
9. **The re-point.** `research.py check` gives the drift. `tools/research/repoint.py --drift-json … --receipt … --lean <the 13 changed modules> --reason … --apply > $REPOINTLOG` then sets each drifted reference to the current bytes and rebinds each changed module's proof binding to the receipt. Every drifted record is read first, with its changed source; the review covers them. The reason names each item; item 1's owner gave its own in its kit.
10. **08 and the study:** `kit/he2_texts.py RECEIPT N $REPOINTLOG $SIGLOG $CONNLOG` (`--check` first): 08's core counts and the study section, every count read from the receipt, the checker's summary and the three logs. It changes no section a record cites.
11. **MV's generator** (`master_laws.py`) on the receipt. In the dry run, two record laws moved from "no master law" to the grammar: laws-at-coarser-steps law 8 through item 1, and master-laws law 3 (the list lemmas) through items 2–4. Items 3–4's three model lemmas now reach the grammar's closure laws directly, but the four record laws citing them already reached the grammar. `central_reach` was unchanged at 44/16/7/51; the landing measures it again on the main it lands on.
12. **Render, then the checks:** strict check, links, tests and the dossier check.
13. **Board and commit.** `kit/he2_board.py land RECEIPT N QUEUE STATE` puts the landed clause at the head, names the receipt as the latest (dated by its own day) and moves HE2's row to the history file's landed rows, every link rebased. Commit only owned paths with `-- <paths>`, the receipt directory among them.
14. **The fast-forward.** Before it, the shared checkout must hold no copy of what the branch adds. The lander's kit files there, and items 6–7's kit with its uncommitted change, are first compared byte for byte with the branch's, then cleared. The Queue line is read again inside the command that fast-forwards (`git merge --ff-only`).

## Checks before the head

- **The pre-rehearsals** outside the repository, with all seven items applied. Their steps stay in the shared cache.
- **The rehearsal** on the main that holds RF-M.3. It reuses all but what landed since.
- **One independent review** of the gathered tree and this kit before the head is claimed ([review](review/REVIEW-HE2.md)).
- **Already checked.** Items 2–4, item 1's weakening, and 6–7 together compile their changed closure, 120 modules, with every axiom report empty ([log](../rv21-one-sense/kit/he2_combined_2to7.log)).
- **The runs so far**, outside the repository (module steps; the toolchain's version step is not counted):
  - 31 October, on main `c05f4eab8`, items 2–7 with item 1's weakening, from the items' earlier tips: the checker passed (1,378 steps run, 61 reused), and the signature audit found the 13 changed modules as the items then said.
  - The same with item 1's Sampling part: the checker passed again (54 run, 1,385 reused), with the same audit result. The records kit applied to that tree wrote six records, one HE2 note each.
  - From the items' final tips on `he2-land` (items 2–4 at `01ca4779f`, without `count_append`; item 1 at `884753120`): the checker passed (1,350 run, 93 reused). The audit: theorem statements go from 747 to 784; seven names renamed, 6 theorems and 1 definition; 41 declarations added to GrammarLaws, 37 theorems and 4 definitions; three moved, one changed (`«两端分则中有标»`); three statements and two definitions changed by the renames only; nothing else. The records kit in check mode: seven records, one HE2 note each (eight since the GrammarPath record's Chinese title joined items 6–7's wording).
  - The audit's first run counted definitions as missing, since the signature logs list theorems only. It now reads definitions from the sources, and compares every command of the 13 modules.
