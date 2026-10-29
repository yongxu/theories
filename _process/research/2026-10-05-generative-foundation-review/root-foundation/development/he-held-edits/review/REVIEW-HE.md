# Review of HE: the held edits, in one near-full rebuild

AI-written: one independent, read-only review by a separate AI agent, 30 October 2026, at the coordinating session's request. Reviewed:
- the [design](../DESIGN.md) and the [kit](../kit/) on branch `ou3f-laws`, first as sent (`6dc48d002`, `ca50cc67d`), then with `25744ff6f` (the rehearsal's logs) and `db4f978ae` (the history move), which arrived during the review and are included. The branch has since merged main (`1e1b5d10a`, after UE20 landed); the kit is unchanged by that merge;
- the scratch worktree `he-pre`: main `a15457b2e` with item 1 and `he_lean.py` applied, uncommitted;
- its pre-rehearsal receipt `20261029T165328.855758Z` (345 modules, 1,297 Lean steps run, 83 reused, every axiom report empty).

Nothing was edited outside this folder and nothing was committed. Every script ran on copies or read-only. The compiled checks and their logs are in [checks/](checks/); large dumps are kept as hashes only.

## Summary

The Lean is right:
- Every statement prints as before. Only the three moves happen, and only `Becoming.KeptOnward` disappears.
- Mechanism's two lemmas are genuine cases of «保之像».
- Item 1 is applied exactly as its owner's script writes it.
- On main `fdd5e8c23`, the current kit produces the same twelve changed modules byte for byte, so these results carry to the landing base.

The open points are in the texts and the kit's later scripts:
- One error, already fixed at `db4f978ae` and re-verified.
- Ten findings to fix.
- Five nits.

Three of them (8, 12 and 16) touch Lean files, GrammarLaws among them. Doing them before the landing run keeps HE to one rebuild, at the cost of that run being near-full again.

## Findings

**1. Error, fixed at `db4f978ae`: the records script stopped halfway.** As sent (`ca50cc67d`), `he_records.py` stopped with `KeyError: 'declarations'` at processes-represented-both-ways, whose GrammarLaws reference has no declaration list. By then it had already written master-laws-on-the-grammar.
- How checked: a dry run on a copy of main after item 1 and `he_lean.py`, with the pre-rehearsal receipt in place ([records-dry-run.txt](checks/records-dry-run.txt), §1). The run exits with status 1 and one record written.
- `db4f978ae` reads the list with `.get` and writes the three records only at the end. Re-run with the KeptOnward reference at its package path and at its history path: both complete, the three records come out identical, and no KeptOnward path is left (§2, §3).

**2. Should fix: two records' validation scopes do not follow HE.**
- *master-laws-on-the-grammar.* After the script, the scope (572 of 600 characters) still reads "40 representation and bridge declarations in fourteen model modules, and the derivations of OU3c, OU3e and OU3f in fourteen more". But the Mechanism reference now also cites `factors_image` and `Image.least`, which HE derives.
  - Its review list ("three of OU3b, one each of OU3c to OU3e, three of OU3f") has no HE review.
  - The record gets no `review` reference for this file.
- *what-keeping-widening-needs.* The scope still says "Becoming.KeepingWidening, 307 declarations, and Population's length_le_count …, all cited here" under GW's receipt. After HE, KeepingWidening has 306 declarations, and `total_eq_of_supports` is cited from Dissipation under HE's receipt. The Chinese scope says the same ("307 项声明").
- How checked: the records after the dry run (§6), and the texts of each record outside its references, bindings and history.
- Fix: `he_records.py` rewrites both scopes in en and zh, within the cap, and adds the review reference.

**3. Should fix: two new bindings' receipt is not referenced.** `he_records.py` binds the GrammarLaws source in processes-represented-both-ways, and the Dissipation source in what-keeping-widening-needs, to HE's receipt. It adds that receipt as a reference only in master-laws-on-the-grammar.
- The repository's validator (`registry.validate`, run on an overlay of the copy) rejects both bindings: "invalid proof receipt binding: '…/20261029T165328.855758Z/verification.json'" (§4).
- They pass only after the landing's usual re-point with `--receipt` and `--lean`. Its rebind of GrammarTransport's and KeepingWidening's bindings appends the reference as a side effect: 6 errors before, 0 after (§5).
- A re-point by `--drift-json` alone, or a check run before the re-point, fails.
- Fix: append the receipt reference in both records where it is absent.

**4. Should fix: dates written by hand.**
- The kit writes "29 October 2026" in three places: `he_records.py`'s three history lines, `he_board.py`'s latest-receipt sentence, and the move's reason in `he-history.tsv`, which goes into the move receipt.
- The owner's `deferred_grammarpath.py` dates its history line by the day it runs. On a copy today it wrote "30 October 2026" ([kit-reproduction.txt](checks/kit-reproduction.txt)).
- UE20 landed before HE (study §454, merged into the branch at `1e1b5d10a`), so HE lands on 30 October or later. One landing would then carry two dates.
- `he_board.py`'s pattern accepts only "(2\d October 2026)".
- Fix: take one date for every line, for example `date.today()`, as the owner's script does.

**5. Should fix: the land step leaves HE's row open.** Board rule 4: "Landed rows move to the history file in the landing commit; the open-claims table holds only open items." `he_board.py land` sets the state cell and leaves the row in the table. The dry run shows one HE row left after land, on both `a15457b2e`'s and `24397d633`'s board ([board-dry-run.txt](checks/board-dry-run.txt)). GW's `texts_gw.py` shows the move, with links rebased for the history file.

**6. Should fix: the head step can jump the queue.** Rule 5 says a lander claims the head "behind every earlier claim". `he_board.py head` puts HE's clause at the front of the Queue line, and asserts only that HE has not already claimed.
- On `24397d633` it lands in front of "UE20 at the head of the queue (…)".
- On `a15457b2e` it lands in front of UE19's and UE18's clauses (board-dry-run.txt).
- On the merged branch's board no head claim is open now, so the step is harmless today. It is not guarded for the day it is run.
- Fix: assert that no other "at the head of the queue (" clause is present, or place HE's behind it.

**7. Should fix: board texts the kit leaves stale.**
- OU3f's row keeps "`Becoming.KeptOnward` holds `kept_onward`, the grammar's closure at the successor, its home beside «线则所闭» in `GrammarLaws`". `he_board.py` changes only the clause about the module doc.
- "The way now", item 3 (line 34): "Before that freeze, the PF line's wording its owner has approved, held in `deferred_grammarpath.py` for the next rebuild of `Becoming.GrammarPath` …, lands with that rebuild or with a run of its own." HE is that rebuild.
- How checked: both texts are still there after `land` in the dry run (board-dry-run.txt).
- The second is the coordinator's text, so a note to the coordinator suffices. The first is a line in `he_board.py`.

**8. Should fix: GrammarLaws' module doc claims more than the Lean.**
- *Steps counted.* "Three of the models' step-indexed laws are proved from the laws of steps counted" became "The models' step-indexed laws are proved from the laws of steps counted: …", which reads as all of them.
  - Not all are. `Reidentify.old_still` (Persistence) is step-indexed and keeps its own induction.
  - The eight inductions that `kept_onward` replaces come from closure, not from the laws of steps counted.
  - Fix: "Of the models' step-indexed laws, these are proved …", or a count.
- *Closure.* The new sentence "the models' inductions over steps that keep a region are its cases" is too wide. `Reidentify.old_still` keeps a region by its own induction; study §445's Boundary says so ("keeps a region the same way but reads no activity"). `Pace.stays` goes through `Law.run`.
  - 01 §7 states it exactly: "the activity laws that keep a region along the steps by their own induction, … are its cases".
  - The root module's new GrammarLaws bullet carries the same overreach from the retired KeptOnward bullet: "the inductions over steps that keep a region in … `Becoming.Persistence` being its cases". Persistence holds `old_still` as well.
  - Fix: use 01 §7's wording in both places.
- How checked: the theorems that use `kept_onward` and the lineage laws were listed from the new environment ([central-and-users.txt](checks/central-and-users.txt), [lineage-uses.txt](checks/lineage-uses.txt)); `old_still` read at Persistence l.805.
- The lineage part of the sentence is right: each lineage law reaches the law it names (lineage-uses.txt).
- Fixing the doc changes GrammarLaws' bytes, so all of its dependents rebuild. See the verdict.

**9. Should fix: the README rows.** In both READMEs, GrammarTransport's row still lists «保之像» ("preserving an image lying within (`«保之像»`)", "保即像之所含（`«保之像»`）"). GrammarLaws' row names neither «保之像» nor `kept_onward`. `he_lean.py` only deletes KeptOnward's row. The root module and the checker's scope now put both in GrammarLaws, and the rows should agree. How checked: the rows read in `he-pre`, and in the kit's output on `fdd5e8c23`, which leaves them the same.

**10. Should fix: the checker's scope files «保之像» under closure.** The GrammarLaws sentence now reads: "closure is being the occurrence itself or reached, a map preserves a relation exactly where its image lies within the other, and a region of the steps of time every step keeps holds from where it holds on; …".
- The sentence goes law by law. «保之像» belongs in its lumping clause, beside "a map's image has a fixed successor exactly where sameness under the map goes alike".
- The module doc, the root bullet and `he_texts.py`'s 01 §7 all put it there.
- How checked: the sentence read in `he-pre`'s checker, which the pre-rehearsal receipt binds.
- The scope is copied into every receipt. Editing the checker does not change the Lean steps' keys, so this costs no rebuild.

**11. Should fix: the study section.** In `he_study.txt`, delta (3) still says only that "the leaf is retired, with its imports, …". It does not say that the file goes to the Lean history folder by `research.py move` (batch HE-history, `db4f978ae`).
- The section has no paragraph on the review and what was taken, which §445 and §451 have.
- Its Evidence names only the core receipt and the signature audit. It should add the rehearsal on `fdd5e8c23` and the move receipt.
- The record history line in `he_records.py` could also say where the file went.
- How checked: the section filled by `he_texts.py` on a copy. It has no placeholder left, and no mention of the move or of a review (texts-dry-run.txt).

**12. Nit: a stale section heading.** GrammarTransport's heading "## Along maps: pulled back, and preserving" (l.98 in `he-pre`) now heads only the two pull-backs (and «谓之自反»).

**13. Nit: `he_texts.py` writes before it checks.** It writes 01-ROOT.md before it checks 08's pattern (texts-dry-run.txt lists the order), so a miss at 08 leaves 01 edited, and a second run then stops at 01. The design says every script checks its edits before it writes. The fix is the one `db4f978ae` gave `he_records.py`.

**14. Nit: the history move step.**
- The kit runs no `research.py move --check` on the batch's receipt after the move. AGENTS.md asks to verify links and preservation hashes after a move, and the check reports any live reference left naming the old path.
- `he_history_move.py` edits `_process/research-config.json` even for a dry run, and restores it in `finally`. Its usage should say so, and the write should pass `encoding='utf-8'`.
- `git mv` stages the rename, but `git commit -m … -- <paths>` takes only the paths it names. The landing's list must name the old and the new path, `lean/history/MANIFEST.json`, `lean/history/INDEX.md` and the move receipt.
- How checked: read `he_history_move.py`, `moves.Plan.apply` and `moves.check_receipt`, which reports live references to old paths as errors and prose mentions as warnings; and the planner's dry run (question 8).

**15. Nit: a caveat on the scanner filter, for reuse.** `he_signatures.py` files a scanned definition that no receipt declares as a scanner false positive. A private definition is never in the receipt's registry, so its change would be filed the same way. The twelve modules have no private declaration (`not_audited_by_name` is empty in both receipts), and the environment comparison of question 1 covers private constants. So nothing is hidden here.

**16. Nit: line wrapping.** Four lines are left unwrapped:
- GrammarTransport l.44 (148 characters);
- Mechanism l.17 (153);
- the root module's GrammarLaws bullet (145);
- two of the checker's scope lines (114 and 161).

KeepingWidening keeps two blank lines after the kind relay's heading. How checked: the kit's added lines measured in `he-pre`'s diff. The files already hold longer lines; GrammarLaws has 101 over 110 characters. Worth doing only together with findings 8 and 12.

## The questions

**1. Statements unchanged: yes.** Checked independently of the kit, by compiling against both builds.
- *Olean trees.* Rebuilt from the checker's shared cache, keyed by each receipt's step keys:
  - old: main `a15457b2e`, receipt `20261029T162632.074811Z`, 346 modules;
  - new: the pre-rehearsal, 345 modules;
  - every blob's digest checked against its cache entry ([assemble.py](checks/assemble.py));
  - each receipt binds exactly the reviewed bytes: 346 of 346 sources as at `a15457b2e`, 345 of 345 as in `he-pre`.
- *Whole environment.* A Lean driver imported every module and dumped every constant of the package ([gen_dump.py](checks/gen_dump.py), [compare.py](checks/compare.py), [env-compare.txt](checks/env-compare.txt)):
  - for each constant, its module, kind, universe parameters, a full structural rendering of its type (full names, levels, binder names and binder info) and the structural hash of its value;
  - result: 49,972 constants before and 49,971 after;
  - none changed type, kind or universe parameters;
  - moved: `kept_onward` (KeptOnward → GrammarLaws), `total_eq_of_supports` (KeepingWidening → Dissipation), «保之像» (GrammarTransport → GrammarLaws), each with an unchanged value hash;
  - gone: one constant, `Image.least.match_1_1`, the matcher of the old proof;
  - changed value: only `factors_image` and `Image.least`;
  - the two moved matchers differ only in hygienic binder names that embed the module name ([hyg.py](checks/hyg.py)).
- *`#check @`.* Every source declaration of the thirteen modules, 1,366 theorems and definitions, printed with `pp.fullNames` and `pp.universes` in both builds. The outputs are byte-identical, sha256 `222db5e6…` ([gen_checks.py](checks/gen_checks.py), [check-signatures.txt](checks/check-signatures.txt)).
- *Axioms.* `#print axioms` of the five declarations: none ([axioms-new.txt](checks/axioms-new.txt)). The receipt's 345 modules all have empty reports.
- *Landing base.* On `fdd5e8c23`, deferred_grammarpath.py and the current `he_lean.py` give the twelve changed modules byte for byte as in `he-pre`. The root module, the checker and the READMEs differ from `he-pre` by exactly UE18's and UE19's lines (kit-reproduction.txt). UE18 and UE19 add only two leaves, and nothing after them up to the merge `1e1b5d10a` changes a Lean file of the package (UE20 is documents only), so the results stand on the landing base. The kit's own rehearsal log on `fdd5e8c23` agrees.

**2. Mechanism's two re-proofs: genuine cases, not reroutings.** OU3d's second review asks that the law replace part of the old proof, and that it not be applied and then undone. The elaborated terms are in [proofs-new.txt](checks/proofs-new.txt) and [proofs-old.txt](checks/proofs-old.txt).
- *`factors_image`.*
  - Old proof: the witness `⟨s, u, rfl, step, rfl⟩`.
  - New proof: `Iff.mp` of «保之像» at the move, whose body is that same witness.
  - The one premise left, `fun _ _ h => h`, is the image of the move lying within the image's move, which holds by definition (`image_step_iff` is `Iff.rfl`).
  - The law takes the whole old proof. It is near-definitional, since the statement is the law's forward half at that inclusion, but nothing is undone.
- *`Image.least`.*
  - Old proof: the matcher on the witness, two transports, then `factors`.
  - New proof: `Iff.mpr` of «保之像», whose body is the same destructuring and two transports. It is applied to `factors` at the move.
  - The law again takes the whole proof, and is not undone.
- *Why this is a case.* Together the two are «保之像» per move, with the image's move and then `Q`'s move as the target relation. The image is the least process the step factors through *because* preserving is the image lying within. That is their content, not a reading of it. With `PartForms.goAlike`, by contrast, the model's premise carried the content.
- The old matcher is gone from the environment, and «保之像» is a dependency of both.

**3. Item 1: exact.** The owner's script ran as written on a copy of main `a15457b2e`.
- It changed seven files, 47 changed lines in all.
- GrammarPath, 07, regions.json and the apart register come out byte-identical to `he-pre`.
- The record differs only in its history line's date, which is the day the script runs (finding 4).
- `he_lean.py` run after it reproduces every other touched file of `he-pre`. Nothing else changed in item 1's files: in the root module and the checker, `he_lean.py`'s edits are elsewhere.
- No live text keeps the old wordings. They survive only in studies, reviews, development scripts and past runs.

**4. Completeness.** Searched the board, the study, the development notes, the Lean sources, the chapters, the glossary, the front pages, the records, `regions.json`, the research config, `tools/` (with its tests) and the measure's scripts.
- *Still naming a moved declaration's old home:*
  - the READMEs (finding 9);
  - OU3f's board row (finding 7).
- *Conditional, for OU's owner:* WHAT-REMAINS item 2's "Until HE lands, «保之像» stays in GrammarTransport".
- *Evidence, no action:*
  - U2's scratch `U2Preserving.lean` (its docstring speaks of «保之像» "where it now is");
  - receipts and logs, which are frozen;
  - study history;
  - the free-energy receipt (its checker derives its closure from imports);
  - the generated pages, which the render rewrites.
- No record but the three the kit edits cites KeptOnward's file, «保之像» from GrammarTransport, or `total_eq_of_supports` from KeepingWidening.
- No other edit held for a rebuild was found. The only other rebuild mentions are the six items' sources and the board's item 3 of "The way now" (finding 7).
- The measure does not move: no central declaration depends on `factors_image` or `Image.least`, and the set reaching a grammar constant is the same in both builds ([gen_central.py](checks/gen_central.py), central-and-users.txt). The kit's rehearsal measure agrees: 45 of 127.

**5. Texts.** The docstrings of `kept_onward`, «保之像», `factors_image` and `Image.least`, Mechanism's header sentence, GrammarTransport's "Along maps" bullet, and 01 §7's new lumping sentence are accurate. The rest are findings 8 to 12 and 16.

**6. The kit's later scripts.**
- *Records:* findings 1 to 4. The references, bindings and history are otherwise right. Every scope stays within its cap (master-laws-on-the-grammar: 572 characters).
- *Board:* findings 4 to 7. On `24397d633` and on the merged branch's board, the anchors still match: the Queue line, the latest-receipt sentence, HE's five cells, and OU3f's clause about the module doc.
- *Texts:* `he_texts.py` fills every placeholder. 08's counts come out as 345 modules (3, 329, 13), 16,959 theorems and 23,126 declarations ([texts-dry-run.txt](checks/texts-dry-run.txt)); see findings 11 and 13.

**7. The audit scanner: the handling is sound; no other tool is misled.** Checked with [scanner_check.py](checks/scanner_check.py) ([scanner-check.txt](checks/scanner-check.txt)).
- OU3b's `definitions()` already reads eight docstring lines of GrammarPath as definitions on main (`from`, `holds,`, `only`, `` `E`, `` …). The reflow adds `Becoming.constant`. Filing a name no receipt declares as the scanner's is right, since the checker's own registry is comment-aware and lists every real declaration (caveat: finding 15).
- *Research check:* `registry.DECLARATION` has no `class` keyword. It matches the same 107 lines of GrammarPath before and after, and none on a docstring line.
- *Lean index and catalogue:* `lean_catalogue.parse_lean` blanks comments and strings before it scans. Its `constant` is the real theorem `Unclosed.constant`, and there is no top-level `Becoming.constant`.
- *The checker's registry* in the receipt does not list `Becoming.constant`. Were it there, `#print axioms` would have failed the run.

**8. The new step, `he_history_move.py`: sound, with finding 14's nits.**
- *What it does.* It asserts that the leaf's file is as on main, then moves it with `research.py move`, by `git mv`, so the bytes are unchanged.
- *The history copy stays out of the run.* The checker's `module_index` skips any directory named `history` (its `ARCHIVE` pattern), and the free-energy checker uses the same index.
- *The pin.* The script removes the package's line from `move_pinned` in the config for the move only and restores the file's bytes in `finally`, as R32 (`1bb0dbb7b`) and R33 (`ada4b87f1`) did.
- *The planner's dry run* ([move_dry_run.py](checks/move_dry_run.py), [move-dry-run.txt](checks/move-dry-run.txt)) was run read-only on the branch checkout: the pin dropped in memory, `git status` replaced by a byte comparison.
  - One file, no conflict, six generated pages to re-render.
  - On the branch, before `he_lean.py`, the README rows' links make three live files to rewrite. On the landing tree `he_lean.py` has deleted those rows first, so only the record's two path strings remain, as the design says.
- *The records step.* `he_records.py` then drops the re-pointed reference and binding at either path (finding 1's re-run, §3).

## Checked and found sound

- `he_lean.py` checks every edit before it writes. Each edit applies once, on `a15457b2e` and on `fdd5e8c23`.
- `total_eq_of_supports` takes Dissipation's section variable and prints the same statement, binder names and implicitness included. «保之像» keeps its universe parameters `[u, v]`.
- The import paths hold: KeepingWidening reaches Dissipation, Mechanism reaches GrammarLaws, ProcessRepresentation still sees «保之像», and the six modules compile without KeptOnward.
- The pre-rehearsal receipt passed, with `core_compiles_from_prelude` true, every axiom report empty, and the only generated axiom dependencies the `injEq` lemmas on `propext`. The sources were unchanged during the check, and the checker's sha256 is that of `he-pre`'s checker.
- The branch's own change is only its development folder. NOTES.md became DESIGN.md, and nothing links the old name; the board row links the folder.

## Verdict

**Not ready to land as is, but close.** The Lean is right as it stands: statements unchanged, two genuine derivations, item 1 exact, and the history move sound.

**Before the head is claimed:**
- Fix findings 2 to 7 and 9 to 11 in the kit, the records, the board and the texts. None of them needs a new proof idea or costs a rebuild; for finding 7's second item, a note to the coordinator suffices.
- Finding 1 is fixed.

**Finding 8, with 12 and 16,** changes GrammarLaws' bytes and so rebuilds nearly every module. HE is the item that exists so that such edits ride one deliberate rebuild, so the owner has two choices:
- *Recommended:* fold them in now. The landing run is then near-full instead of reusing the rehearsal.
- *Or:* hold them openly on a successor list. Not left to memory.

The nits 13 to 15 can follow at any time.
