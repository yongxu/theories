# WRT2: landing the World's representation

29 October 2026. AI-written landing note for board item WRT2. It says what lands, the decisions taken at landing, the exact command sequence and what the run showed. The scripts are in [kit/](kit/).

## What lands

**Lean.** Two new core modules, both leaves at L1, come from [tree/Becoming/](tree/Becoming/). No landed declaration changes. Imported with the whole package they clash with no name ([clash.log](clash.log)).
- `Becoming.GrammarTransport` imports `Becoming.GrammarLaws`. It is the grammar layer's lemma module, with no record of its own: the listed grammar terms kept by a one-to-one correspondence, and «尽» pulled back along a homomorphism.
- `Becoming.WorldRepresentation` imports `Becoming.ContinuedClasses`, `Becoming.Decidedness`, `Becoming.Diagonal` and `Becoming.GrammarTransport`. It holds the World's representation both ways and the failure on amounts with its witnesses.

Each module is added:
- to `CORE` in `check_becoming.py` (after GrammarLaws and after ContinuedClasses), and to the checker's scope text;
- to the root `Becoming.lean`, as an import and an L1 bullet;
- to the package README rows, EN and ZH. The Chinese table has no ContinuedClasses row, so WorldRepresentation's row goes after Persistence's there.

**One record**, recorded-checked: `the-world-represented-both-ways`, *The World represented in the grammar both ways, its amounts not*. It is in family F01, home 01 §8.6.
- It cites each of the two modules' 92 declarations once, in sixteen laws, and has ten formal-reuse dependencies.
- The failure on amounts is stated as plainly as the success, in the statement, laws, the does-not-show items and the counterexamples.
- The record reorderings-as-courses-of-growth has its does-not-show item on the representation theorem brought to the landed theorem, a related entry and a history note. No statement, next step or declaration of it changes.

**Texts.**
- 01 §8.6 gains the theorem block, and its sentence on what is no instance is corrected: the grammar counts by pairing and maps by «像»; what it lacks is amounts.
- 01's thesis, its paragraph on what is claimed, the clause of its not-shown line on the representation theorem, and its Open entry.
- 08's Open entry, and its counts read from the receipt.
- The overview's two sentences on faithful representation.
- L-21's weakness line in the logic dossier.
- The glossary's line for the occurrence model.
- The study section.
- regions.json: the record and the two module roots.

## Decisions

- **One record, one lemma module.** Invariance of definable terms under a correspondence is a fact of the definitional style, so GrammarTransport has no record of its own.
- **Two leaves.** Nothing below uses either module.
- **Names as implemented.** DESIGN.md §7 maps the design's names to the implemented ones.
- **The OU row stays its owner's.** OU's criterion 7 is reported to the coordinating session, not edited on the OU row.
- **Re-pointing.** No landed statement or proof changes. The drift expected is in the sections the texts write, and in the root and README lines the integration edits.

## Commands

All commands run from the landing worktree's root (`.claude/worktrees/wrt2-landing`, branch `wrt2-landing` from the head clause `7c3829c82`). `K` is the kit in the main checkout's study folder, `P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming`, and `RF=_process/research/2026-10-05-generative-foundation-review/root-foundation`. The study folder is copied into the worktree before step 4.

1. `python3 -B $K/integrate_wrt2.py`: copies the two modules, and edits CORE, the scope, the root module and the READMEs.
2. `(cd $P && python3 -B check_becoming.py)`, giving `RECEIPT`.
3. `python3 -B $RF/THEOREM-CONNECTIVITY.py --check`. Any apart roots it reports are registered by `$K/register_wrt2.py` from the log; then the check again, and `--write`.
4. `python3 -B $K/texts_wrt2.py RECEIPT N`, where `N` is the last § plus one (asserted).
5. `python3 -B $K/make_records_wrt2.py RECEIPT N`. It asserts the style caps and the record's lint, the receipt's hashes, empty axiom reports, and that every declaration is cited exactly once.
6. `python3 -B $K/repoint_wrt2.py RECEIPT` (a dry run), then the same with `--apply`: only the records drifting by the texts.
7. `python3 -B $K/board_wrt2.py land WRT2 RECEIPT N "QUEUE" "STATE"`.
8. In the clean worktree: `make research-render`, then `research-check` with `--strict-fresh`, `research-links` and `research-test`. Commit the owned paths with `git commit -m … -- <paths>`, merge main if it moved, re-render, and fast-forward main.

## What the run showed

29 October 2026, in the landing worktree from the head clause `7c3829c82` (main at `cafb743de`).

- **The checker passed.** Core receipt `20261029T081505.616437Z`:
  - 340 modules and 16,633 theorems, with 22,697 declarations audited;
  - every source declaration's axiom report empty;
  - `Becoming.GrammarTransport` 41 theorems in 44 declarations, and `Becoming.WorldRepresentation` 34 in 48, as in scratch;
  - two structures added (`«一一对应»`, `World.ExchangeSigns`), so the generated `injEq` lemmas on `propext` are 231.
- **Connectivity.**
  - `Becoming.WorldRepresentation` has 2 of 34 theorems apart: the counter-model `Steps.along_endless` (model witness) and `Web.sameStep_class` (support).
  - `Becoming.GrammarTransport` has 32 of 41 apart: laws of every relation, 17 of them roots, registered as general structure waiting for consumers. The other 9 are used by WorldRepresentation's theorems on the base.
  - `«尽则非不穷»` is no longer an apart root, since F3 uses it on the base, and its entry retired.
- **Texts and records.**
  - The texts wrote study §440.
  - The record was written with 92 declarations in 16 laws, each cited once, and one lint warning (a long item). reorderings-as-courses-of-growth was brought to the theorem.
  - Re-pointing rebound the ten records whose cited sections the texts write: seven cite 01 before its first heading (the thesis and the claims paragraph), and three cite the overview's §1 and §10. The change was read first, and it touches none of their claims.
- **Checks in the clean worktree.**
  - The generated pages re-rendered.
  - `research-check --strict-fresh` found no error, no source drift and no stale index.
  - `research-links` found no broken link.
  - `research-test` ran 213 tests, all passing (one skipped).

## After landing

Once no session uses them, remove the landing worktree and these build outputs, which are not data: `tree/.build`, `check/tree/.build` and the clash tree in the scratchpad.
