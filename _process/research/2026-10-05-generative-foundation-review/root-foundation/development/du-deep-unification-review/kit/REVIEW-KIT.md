# The kit review: findings and what was done

AI-written, 1 November 2026. This page covers the review of DU's landing kit (this folder) and of the package join on `du-claim`. Thirteen findings were raised. Twelve were taken in full. The thirteenth was taken in part: its label was changed and the placement it proposes was left for the owner. Nothing was committed. The core checker and `research-render` were not run.

## Findings

1. **Blocking. 04's Bases lie before its first level-2 heading. Taken.**
   - `registry.sections()` tracks `##` headings only, so the Bases edit shows as `(before the first heading)` for every record that cites 04. `# Life and evolution` is level 1 and can never appear.
   - `EXPECTED` for 04 is now `{(before the first heading), Open}`. For 01 it is `8. The models`, since `8.6 …` is level 3 and DU's home section goes into §8. The 08 and 07 entries now list headings only. Anchors and slugs never appear there.
   - The eight records that cite 04 on main `3e6bc3538` are named in `READ_FIRST`, and the dry run lists them under "read before --apply". `land_du.sh post` now stops after the dry run (see 2).
   - A simulation against main's files shows that the old set fails and the new one holds.

2. **Blocking. premises-met-and-failed hashes 08 before the texts stage rewrites 08 §7. Taken (the first fix).**
   - `post` reruns `integrate_du.py record $V $N` after the texts stage and before `mv2`. Every other edit of that stage is idempotent: 08 §3's sentence is matched again, the homes are skipped, and regions and COVERAGE stay unchanged. That rerun was exercised twice on a snapshot of main.
   - `post` now stops after the repoint dry run. The new stage `finish [N]` writes the re-points (`--apply`), then runs the study, render, strict check, links, lint and tests. This puts the reading that findings 1 and 7 ask for between the dry run and `--apply`.

3. **Major. The id `standings-not-read-off-the-root` gave a wrong meaning. Taken.**
   - The id is now `standings-not-read-off-the-occurrence-model`, with anchor `r-standings-not-read-off-the-occurrence-model`. It is changed in records-text.json, make_record_du.py (RIDS, DEPENDENCY_ZH, RELATED_ZH, ALIASES, REVIEWS, HISTORY, STANDARD), the 01 home, integrate_du.py (HOMES, regions, study), WHAT-REMAINS-SECTION.md, BOARD.md and land_du.sh.
   - `--validate` gives 0 findings.
   - One mention outside the kit remains, in `texts/TEXTS.md` line 86. That is a design text this task does not edit, and no script reads the id from it.

4. **Major. The third record's statement left out `k ≠ 1` and positive standing. Taken.**
   - New statement, 299 characters: "For k > 1, a world counted in a unit k times finer balances where it does and agrees on the occurrence model's selected relations, so no reading of them returns a positive standing in both. In still worlds relabellings keeping sign and order keep them: none gives all worlds' standings up to a unit." The zh is 113 characters.
   - The same omission was found in, and fixed in:
     - the package join: README.md's row ("for `k ≠ 1` … a positive standing"), README.zh.md's row, Becoming.lean's note and check_becoming.py's SCOPE sentence;
     - the regions note;
     - the study's Delta line;
     - the board's clauses.

5. **Major. "No statement reading no order entails C" says more than `ReadsNoOrder.not_entails` proves. Taken.**
   - The 08 home's heading now reads "A statement reading no order entails C only where it fails."
   - The alias, the regions note and the boundary record's history note (en and zh) now read "C entailed by no statement reading no order where it holds". So do both board clauses that carried the loose form.

6. **Major. WHAT-REMAINS' "Item 3" bullet said more than the leaf proves. Taken.**
   - The bullet now uses the reviewer's wording. The study's sentence "what the root's World model leaves free" now reads "what the World's occurrence model, through its selected relations, leaves free". Its Delta line now carries "for k ≠ 1 … a positive standing".

7. **Minor. Front-page drift was re-pointed without a section guard. Taken.**
   - `EXPECTED` now covers the overview (§7 and §10) and its zh edition (§7 and §10, headings in Chinese). It also covers both one-page editions (`(before the first heading)`; they have no level-2 heading) and READING-BUDGETS (`The budgets`).
   - The three records that cite the overview are named in `READ_FIRST`.

8. **Minor. The prepare dry check did not cover every kit edit. Taken.**
   - `integrate_du.py anchors` (a new subcommand) does the whole dry check, and prepare's heredoc is replaced by a call to it. It checks:
     - the six patterns of `connectivity()`, `old_u3`, the five table rows, the receipt sentence, the homes' places, and that no other home lies between those places;
     - the ZH_ROWS and the rows they follow, WHAT-REMAINS' anchor and the two READING-BUDGETS row patterns;
     - the APART anchor, the U4 strings, 04's two texts, the six front-page sentences and the boundary record's history list;
     - COVERAGE's prior state (`coverage_state`) and the boundary data `life()` reads (`life_state`);
     - that the scripts the texts stage runs exist.
   - Each pattern and string is now one module-level constant, used both by the edit and by the check.
   - On a snapshot of main `3e6bc3538` the check passes. With three texts moved, it stops on all three.

9. **Minor. The zh README rows were outside the package join. Taken.** README.zh.md now carries both rows on the branch, in U1b's pattern. `readme_zh()` finds them in place. Prepare checks each leaf's zh row after the merge, and `anchors` checks each row and the row it follows.

10. **Minor. A rerun of `what_remains()` on another day would insert a second section. Taken.**
    - The landed section is found by the prefix `## DU landed: premises met and failed`, and its body, which names no day, must match. A rerun dated 2 November found the section in place: one section, not two.
    - For the same reason, the boundary record's history note is now dated on the landing day and found again by its text after the date.

11. **Minor. The helper lemmas kept the scratch's namespace `Becoming.UnitsApart`. Taken.**
    - The namespace is now `Becoming.UnreadStandings`, as `UnitMatchings` names its helpers after its module. The leaf doc states what the lemmas are and why they are proved there.
    - Updated: the declarations in records-text.json and REASONS, and the history note ("its helper lemmas' namespace renamed to the module's at the kit review and every other declaration unchanged"). BOARD.md §1 is updated the same way.
    - Rebuilt with `scratch_build.py` on the kit tree: `unclean []`; `with_axioms {}` for both leaves; 40 declarations and 32 theorems, and 37 and 35, unchanged. The result is in `kit-build.json`. The kit copies are byte-identical to the package copies.
    - The reviewed scratch file `scratch/units/Becoming/UnitsApart.lean` keeps its old namespace, as reviewed. This task does not edit it.

12. **Minor. The second record's correspondence implied both directions; does_not_show [4] said "both". Taken.**
    - The correspondence now reads "a Pareto-style monotonicity that gives what C asks between listed level paths (one way)".
    - does_not_show [4] now reads "the condition and C stay the ethics' premises and self-concern a hypothesis; C's warrant is open". The zh is changed in both places.

13. **Minor. 01's label and 07's placement. The label was taken; the placement was not.**
    - 01's label now reads "(World; the grammar's transport for the keeping theorems)".
    - The 07 home stays before 4.1. TEXTS (`texts/TEXTS.md`, line 85) records the owners' word as "at scope and order", and the finding itself makes the move conditional on their agreement, which has not been asked for.
    - For the owner: end of §4.5 is still within scope and order, and its links would point back, not forward. The move is one HOMES entry: after `<a id="r-the-class-of-being-joined"></a>\n`, before `\n<a id="future-path"></a>\n### 4.6 The future without the step: one path\n`. The home's "§4.4" and "§4.5" links would then point back.

## Checks run

- `make_record_du.py --validate`: 0 findings on DU's records and 0 elsewhere. One lint warning remains, the negation-lead in the third statement; it is not an error.
- `integrate_du.py anchors` on a snapshot of main `3e6bc3538` with the join's zh rows passes. On the unmerged branch it reports the READING-BUDGETS rows, which have moved on main since the branch point, as it should.
- On that snapshot, homes, regions, COVERAGE, 04, the front pages, WHAT-REMAINS and register ran twice. The second run changed nothing.
- A simulation of the changed sections, comparing main's files with the edited snapshot, falls inside `EXPECTED` for 04, 01, 07, 08, both overview editions and both one-page editions.
