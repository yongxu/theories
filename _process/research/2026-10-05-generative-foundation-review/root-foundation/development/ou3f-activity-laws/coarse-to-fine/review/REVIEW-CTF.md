# Review: OU3f's coarse-to-fine pair, the scanner fix, and OU3f's closing

AI-written independent read-only review, 30 October 2026, of [the tree](../tree/Becoming/Persistence.lean), [DESIGN.md](../DESIGN.md), [the kit](../kit/) and OU3b's helper change (`c9d47a06f`, `blank_comments` in [signatures_ou3b.py](../../../ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py)). It was made on branch `ou3f-laws` at `377418ef7`, whose Persistence is main's (`tree/BASE.sha256`). Main has since moved to `53208baa9` (RF round 2's first landing, study §456). That move leaves Persistence unchanged, so the tree and `integrate_ctf.py` still apply. The study section will be §457, and no item holds the head. The checks are in [checks/](checks/), and [run_checks.sh](checks/run_checks.sh) reruns them. The Lean check files end in `.lean.txt` so that the Lean catalogue does not index them; `lean` runs them as they are.

**Verdict: ready to land after findings 1–3.** The Lean is right:
- every statement of Persistence prints as on main;
- no other declaration of the module changed;
- the two derivations are genuine by OU3d's second review's test, and as small as the audit says;
- every axiom report is empty;
- Persistence's 13 dependents besides the root build with the tree.

The scanner fix does what it claims on this package and on its history. Every (a) and (b) row of OU3f's audit is derived, so OU3f is complete as its audit defines it. Findings 1–3 are text that should be right before the row closes. Findings 4–8 need a word to other owners or harden the kit and the helper; they need not hold the landing. Findings 9–11 are nits.

## Findings

1. **should fix: Persistence's header still lists `Web.steady_held` as "Not connected".**
   - Where: the tree's grammar section, line 1184. The landing edits this section anyway (line 1171).
   - Why it is wrong: since the closure part (§445), `steady_held` is proved by `kept_onward`, the grammar's closure at the successor. On main its proof reaches `kept_onward` directly (`checks/reach-main.txt`).
   - The closure part fixed the same line in PatternPassing: a *By closure* bullet took `trace`, `line_back` and `present_earlier`, and *Not connected* kept only `begins_within` and `present_back` (closure DESIGN.md, *Other details*). Persistence did not get the same edit.
   - Fix: give Persistence's section a *By closure* bullet like PatternPassing's. It would say that `Web.steady_held` keeps a region along a held stretch, so it is a case of `kept_onward`, while what it keeps, one name, is a naming of the carrier. *Not connected* then keeps `renewingIn_held`, the classes fixed under conservation and the census laws.
   - Checked by reading the section and the reach check.

2. **should fix: two statements in the study draft (and the design) say more than the work did.**
   - **"replace the projection"** ([ctf_study.txt](../kit/ctf_study.txt):10; DESIGN.md:11–12 and :18, "The law replaces the old proofs' one projection").
     - The projection stays. It is now the proof that the state class is finer than activity (`fun _ _ same => same.1`), which the design itself names at :16.
     - What the law replaces is the projection's use on the continuation witness: the destructuring `⟨alike, _⟩`, that is, «粗化» applied by hand.
     - `edit_tree.py`'s docstring has it right ("replace the destructuring of the state class's pair").
     - Suggested wording: "take the projection as the class inclusion and replace its use on the witness".
     - DESIGN.md:18's "the argument that activity does not change" is also loose. The argument that remains shows that no successor along the names is alike in activity, since activity changes.
   - **"the 398 laws of their models keep their proofs"** (ctf_study.txt:15; DESIGN.md:26).
     - The audit's later notes say otherwise. Three of the 398, all (c) representations, are now proved through grammar laws: `ByPassing.line_back` by closure, and `Lineage.line` and `line_lineage` through the bridge. `Lineage.cons` is retired.
     - "keep their standing, with their reasons written down" is exact.

3. **should fix: the review paragraph is still a placeholder, and nothing stops it from landing.**
   - `texts_ctf.py` appends `ctf_study.txt` as it stands, with "(to be written from the review)" in it. Its guard catches only `{UPPER}` tokens; `checks/kit_dryrun.out` shows the placeholder reaching the study.
   - DESIGN.md:55 ("One independent review comes next") needs the same update.
   - Fix: fill both from this review, and have `texts_ctf.py` refuse a section that still contains "(to be written".

4. **minor: closing the row leaves three texts by other owners saying OU3f is open.**
   - **OU's row** (main's board, line 50) says "**OU3f** in progress (… 400 laws of their models …, 27 cases of grammar laws, 9 waiting on three laws of steps; those laws and the derivations next)" and "Left of criterion 7: the derivations OU3f names".
   - **The way now, item 4** (line 35) says "OU3f's audit … found 400 of the 436". The reviews made it 398.
   - **The record the-world-represented-both-ways**: its `next_delta` lists "the laws that read only activity at the occurrence model (OU3f)". OU3f did them at the web's carrier, which the audit showed needs no occurrence model (AUDIT.md, *(a)*).
   - By rule 4 the lander edits none of these, and the design says no record changes. The design and the landing message should ask the owners: OU's owner, which ordered this fork; the coordinator; and WRT2's owner, for the record.
   - Checked by grepping main's board and the records.

5. **minor: what the audit set aside needs a home when the row closes.**
   - The audit names three things outside OU3f:
     - the law of alternation of a two-valued class over a listing (the seven *(b), not proposed* rows of Decidedness: "a separate item");
     - `arises_within` as a candidate case of «两端分则中有标» (it reads no field);
     - the theorems that read `active` with other fields, "the next groups of the dependency audit". The other single-field groups (level 149, requires 55, …) also belong to the OU plan's later steps.
   - The design's *OU3f is then done* names none of them, and the closed row's history entry is where they would be lost.
   - Fix: one sentence in the State text, and in OU's row or WHAT-REMAINS by its owner, saying where each goes.

6. **minor: `board_ctf.py land` replaces OU3f's State cell with a string from the command line.**
   - The design promises the row moves "with its whole account": the audit, the laws of steps, the twins, the closure, the lineage laws, HE's moves and this pair. That account then depends on what the lander pastes.
   - Safer: build the new state from the current cell, replacing its last clause "next: the coarse-to-fine pair" with the landed clause. Or assert that STATE_TEXT contains §442, §443, §445, §451 and the new section.

7. **minor: `blank_comments` is right for this package but has general Lean 4 gaps; make them fail loudly.**
   - **Right on the package.**
     - On every module of HEAD's receipt (347) its output equals the Lean catalogue's `scrub` once string delimiters are blanked: `blank_comments` keeps the delimiters, `scrub` blanks them.
     - Length and line breaks are kept everywhere (`checks/blank_vs_scrub.out`).
     - It handles char literals better than `scrub`, which reads `'"'` as opening a string.
   - **Lexical cases** (`checks/blank_cases.out`, 26 cases).
     - Right: nested block comments, docstrings and module docs (nesting included), `--` after code, `-/` inside a line comment, `--` and `/-` inside strings, `\"` and `\\` escapes, a backslash-newline gap, quotes inside comments, `'"'`, `'\''`, `'\\'`, `'\x22'`, primed identifiers (`h'`, `h''`, `a'b'`, whose `'b'` it copies as a char literal, harmlessly), and «» names without special characters.
     - Gaps:
       - raw strings (`r"a\"`, `r#"a"b"#`);
       - «» names holding `--`, `/-` or `"`;
       - `/--/` (a docstring whose text begins with `/`).
   - **None of the gaps occurs in the package.** The census found no raw string, no such «» name and no `/--/`. The only code strings are two `local notation` lines in LimitVerification. The five places in code where a primed identifier looks like a char literal (`ha'b'`, all in Description) scan harmlessly.
   - **The worst gap would be silent.** A `/-` inside a «» name blanks the rest of the file, and every later definition is missed without error.
   - Fix: after the loop, assert `depth == 0 and not in_string`, raising with the module's name. Optionally, copy `«…»` spans unread in code mode.

8. **minor: "no comment edit as a rewrite" (`definitions()`'s docstring) and "it can only remove spurious differences" (DESIGN.md:32) say more than the code does.**
   - **What changed.** Blanking does more than drop lines:
     - (a) A comment inside a definition (field docstrings, a trailing `--`) becomes spaces of the same length. So an edit that changes its length still reads as a rewrite. `checks/comment_edit_check.out` shows it on `Blanket.Parts`: same length, no rewrite; longer, rewrite. Eight definitions carry such comments today (`checks/scanner_bodies.out`).
     - (b) String contents are blanked, so an edit inside a string literal in a definition's body is no longer seen. No definition in the package has one.
     - (c) A column-0 comment line no longer ends a body, so text after it is now compared.
   - **The design's conclusion holds on the record.** `checks/scanner_history.out` replays both scanners on every module pair changed by the 318 first-parent commits on main since 15 October 2026 (1,407 pairs). The new scanner flags nothing the old one did not. It drops 17 spurious flags, all words read from comment lines.
   - **The landed kits.** They use `definitions()` only for before-and-after comparisons. Their expected sets (OU3d's and the lineage part's `ADDED_DEFS`) are real names, HE's kit filtered scanner false positives, and UE7's kit has its own copy. So no landed kit's verdict would change.
   - Fix: compare bodies with whitespace collapsed (`' '.join(body.split())`), which makes (a) true. Word the docstring and the design as what is shown.

9. **nit: three counts and facts in the design.**
   - "six by closure and two more" (DESIGN.md:23) double-counts: with "the twins and `ends_within`" it sums to 16. The (a) rows by closure are seven, the audit's six and `trace`. The closure part's eighth proof, `line_back`, is a (c) representation.
   - "Persistence was last changed by this item's closure part (§445)" (:40): HE (§455, `6eb479810`) changed it last, dropping `import Becoming.KeptOnward`. The ownership conclusion stands, since HE's edit was mechanical, made for OU3f's closure.
   - "Persistence's cone is 13 modules" (:36, and :44): 14 modules of the run depend on it, 13 and the root `Becoming`. CorrectionInquiry, outside the run, also does.

10. **nit: two places where the board script relies on the board's current state.**
    - The history row goes "after HE's" row. That is right today: HE's is the last landed row on main at `53208baa9`, since RF's landing moved no row. It would be wrong if any row lands first. Inserting at the end of *Landed after the board was rewritten*, before *Lapsed claims*, keeps landing order either way.
    - The head guard recognizes only "at the head of the queue (". An earlier claim phrased otherwise, such as OU3d's "next after UE15 (", would be jumped. Read the Queue line before claiming.

11. **nit: the usage lines name other kits' scripts.** `signatures_ctf.py` says `signatures_lineage.py`, `texts_ctf.py` says `he_texts.py`, and `board_ctf.py` says `he_board.py`. Running the named script by mistake would act on the lineage part's or HE's state.

## Checked and found right

1. **Statements and the rest of the module** (`checks/statements.out`).
   - **Builds.** Both builds came from `scratch_build.py`: main's Persistence from the checkout, and the tree's. Both steps were restored from the shared cache, with no step failed or unclean.
   - **Independent recompile.** The tree's Persistence was recompiled with `lean -o` against the restored imports. It gave no messages and a byte-identical `.olean`.
   - **`#check @` of all 106 declarations.** Every one prints identically in both builds, and so do the two theorems under `pp.all`.
   - **The checker's signature driver.** It prints byte-identically in both builds. Main's output equals the cached `BecomingPersistenceSignatures.log` of receipt `20261029T184601.050950Z`.
   - **Every constant Lean put in the module (293).** Types and values agree except the two theorems' proofs and their matchers (`wang_state_of_change.match_1_1`, `sheng_state_of_change.match_1_1`), whose pattern changed. The two theorems' type hashes are equal.
   - **Axioms.** None of the 293 constants depends on an axiom, in either build, generated ones included.
   - **The cone.** Persistence's 13 dependents besides the root were compiled with the tree's Persistence (`checks/scratch-cone.log`). All are clean, with every axiom report empty, and their theorem and declaration counts equal the receipt's. These steps are now in the shared cache for the landing run.
2. **The derivations are genuine, and small** (`checks/reach-pair-*.txt`).
   - **Reach.** In the tree each proof reaches its law directly, and «粗化» through it. On main they reach neither.
   - **The test.** Each law is applied once, to the class inclusion and to a proof of ending (or beginning) under activity, and nothing is undone. The inner function now receives an activity-alike witness. The part replaced is the destructuring of the state-class pair. The rest of the old proof is unchanged.
   - **Not a reroute, and minimal.** By inspection, unfolding the law gives back the old term, since the law's body is the coarsening the old proof did by hand. That is what the audit means by small. The gain is that the reason is named, as in the siblings `ceases_of_persisting_ceases` and `arises_of_persisting_arises`.
   - **Style.** The style (`E'` named, the inclusion as a lambda) matches `ceasesFrom_of_unconditioned`. Every changed line is at most 100 characters.
3. **The scanner fix.** Run on every module of HEAD's receipt (`checks/scanner_check.out`):
   - it drops 26 names, from 26 comment lines, none of them a declaration of the receipt;
   - it adds none;
   - all 6,122 declarations of the kinds it scans (def, abbrev, structure, inductive; the receipt has no class) are found before and after.

   GrammarPath's nine dropped names are HE's one and OC5's owner's eight.
4. **OU3f is complete as its audit defines it** (`checks/reach-main.txt`, `checks/reach-pair-new.txt`).
   - **(a) rows.** On main, 13 of the 15 reach the named law: the seven by closure reach `kept_onward` directly, and the twins and `ends_within`, `unique` and `origin` reach theirs directly. The pair reaches its laws in the tree.
   - **(b) rows.** All four reach theirs: `split` («迭之分»), `through` (through it), `onward` («或有后则或迭»), and `back` («或有后则或迭» and «迭之逆»).
   - **The rows that follow.** The four (a)-follows rows and the five (b)-follows rows reach theirs transitively, the latter through `reaches_onward` and «不穷则迭». The ten (a)-done rows reach theirs.
   - **Retired names.** The three twins and `Lineage.cons` are gone.
   - The counts match TABLE.md and `data/classification.tsv`: 15, 4, 10, 4, 5, 7, and 398 of 436 (the seven (b)-not-proposed rows among them).
5. **The kit** (`checks/kit_dryrun.out`, run on scratch copies outside the repository).
   - **`edit_tree.py`** reproduces the tree byte for byte from main's Persistence and refuses a second run.
   - **`integrate_ctf.py`'s base** still matches main at `53208baa9`.
   - **`signatures_ctf.py`**:
     - it runs end to end on HEAD's receipt (OK);
     - its comparison, emulated on the review's builds, finds nothing changed, gone, added or rewritten (`checks/emulate_signatures.out`).
   - **`texts_ctf.py`**:
     - its 08 pattern matches once, on the branch and on current main;
     - it appends the section with its placeholders filled;
     - it refuses a repeated section number.
   - **`board_ctf.py`**:
     - `head` claims, refuses a second claim, and refuses while another item holds the head (tried on the board at `b85ec0f89`, where RF held it);
     - `land` drops the claim, puts the landed clause first, and names the receipt as the latest with today's date;
     - it moves OU3f's row into the history file's landed rows, after HE's;
     - it rebases `research/` to `../../research/` and `../sources/` to `../../../sources/`, which is right from `_process/history/workboard/`. OU3f's row has no other link.
   - Moving the landed row in the landing commit is what rule 4 asks.
6. **Texts.**
   - **The two new docstrings** say what the proofs do.
   - **The header's new sentence** is accurate: these two also follow from the laws, read from ending and beginning under activity.
   - **The study draft's anchors** for §451 and §455 match the slugs of the study's headings.
   - **Findings 1, 2 and 9** are the exceptions.

## What this review did not do

- It ran no core checker and wrote no receipt. The root module was not rebuilt, since on this branch it lacks RF's modules.
- It edited nothing outside this folder, and made no commit. `scratch_build.py` stored its passed steps in the checker's shared cache outside the repository, as it always does.
- The scratch trees and their build folders, which held a copy of the tree's Persistence, were deleted after the run. `run_checks.sh` recreates them.
