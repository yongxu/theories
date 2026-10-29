# HE: the held edits, in one near-full rebuild

AI-written design for board item HE, claimed 29 October 2026 at the coordinating session's request (`981a93316`, row corrected at `ffdbeea47`, sixth edit added at `d9a6615e6`). OU3f's lineage part has landed (§451), and HE is queued after UE18 and UE19, rehearsed on main once they land, so its one rebuild includes them. Edits held "for the next full rebuild" slip when a rebuild comes without them: OC5's wording missed WRP2's rebuild of GrammarPath. So one landing rebuilds the package once, on purpose, after a rehearsal outside the repository.

## The six held edits

1. **`development/oc-own-class/deferred_grammarpath.py`, as written.** OC5's review, findings 8 and 18; the PF line's owner approved the wording word for word on 27 October.
   - From `e5a9b32ea`, the script checks every edit before it writes any file, so a stop leaves the tree as it was.
   - Its owner dry-ran it on main at `981a93316`: every edit applies once, across seven files.
     - `Becoming.GrammarPath`, 24 changed lines
     - the root module, 6
     - `check_becoming.py`, 3
     - 07 §4.6, 2
     - the apart register, 2
     - `regions.json`, 2
     - the record what-a-line-holds-and-a-regularity-takes-in, 8: its two law lines, and a history line dated by the day the script runs
   - The glossary is not edited. Finding 18 only cites its term "alike occurrence".
   - If an edit stops, it goes to the script's owner (session "Project progress and significance") before anything is changed.
2. **GrammarLaws' module doc on the lineage laws, two places.**
   - Its *What is not shown* clause names the lineage laws as OU3f's next part, and goes.
   - Its sentence "Three of the models' step-indexed laws are proved from the laws of steps counted: …" (the *Finite runs: steps counted* bullet) gains the lineage laws of `Becoming.Identity`: `Web.Lineage.unique`, `origin`, `split`, `through`, `onward` and `back`, from «迭之定», «迭之定前», «迭之分» and «或有后则或迭» with «迭之逆», read through the steps of the continuation within activity (`Web.steps_iff_lineage`). The lineage review asked for this. Until HE lands, OU3f's board row says GrammarLaws' doc lags.
3. **`kept_onward` moves into GrammarLaws.** It goes from `Becoming.KeptOnward` to its home beside `«线则所闭»` (OU3f's closure design, condition 3), and the leaf is retired. That retirement touches several places:
   - the six modules' imports;
   - the checker's core list and scope;
   - the root module's import and bullet;
   - the README rows (EN, ZH);
   - the record master-laws-on-the-grammar: its KeptOnward reference and binding move to GrammarLaws.
4. **The clock run beside `Run.reach` in `Frame`: nothing to move.** It existed only in the closure's first draft. The review found that `Law.run` already exists and that the law needs no run on the grammar.
5. **`total_eq_of_supports` moves into Dissipation.** It goes from `Becoming.KeepingWidening` to beside `total_le_of_support` in `Becoming.Dissipation`, as GW3–GW5's note records.
6. **«保之像» moves beside «像» in GrammarLaws.** It goes from `Becoming.GrammarTransport`, statement and name unchanged, no copy left. Mechanism's `factors_image` and `Image.least` are then proved as its cases, statements and names unchanged, by the proofs of U2's scratch (`development/u2-rows-on-the-root/check/tree/Becoming/U2Preserving.lean`, branch `u2`).
   - Source: U2's design §6. OU's owner sent it on 29 October.
   - Agreement: OU's owner decides for Mechanism under rule 3's fallback, and GrammarTransport's owner agrees to the removal.
   - Its proof uses only «则», «像» and `Eq.subst`, so it moves unchanged. The row was added at `d9a6615e6`.

An edit held for a rebuild is added to this list, not left to memory.

## After the checker run

- **Re-point, reading each change first.**
  - what-a-line-holds-and-a-regularity-takes-in, which pins GrammarPath;
  - constancy-read-at-a-members-class, which pins 07;
  - the records research-check names for the moved declarations, KeptOnward's and Dissipation's included.

  Re-pointing writes no history note, and the script adds that record's own history line.
- **Signatures.** Every statement prints as before. `kept_onward` and `total_eq_of_supports` move modules with their statements unchanged, and `Becoming.KeptOnward` is gone.
- **Then the usual steps:** the connectivity register, the measure and MV's generator, a study section, and rendering in a clean worktree.

## The kit

`kit/` applies the edits to a checkout, in order, and every script checks its edits before it writes:
1. `oc-own-class/deferred_grammarpath.py`, the owner's script, as written (item 1).
2. `he_lean.py`, items 2, 3, 5 and 6. It edits 15 files: GrammarLaws, GrammarTransport, Mechanism, KeepingWidening, Dissipation, the six modules that imported KeptOnward, the root module, the checker, and the two READMEs. It does not delete `Becoming/KeptOnward.lean`.
   - `kept_onward` and «保之像» are pasted unchanged beside «线则所闭» and «像».
   - `total_eq_of_supports` goes after `total_le_of_support` in Dissipation's `section Totals`. It takes that section's `{α : Type}`, so its printed statement is unchanged.
   - Mechanism's two lemmas use U2's scratch proofs, with `moveRel P a` written out as `fun s t => P.step s a t`, since Mechanism does not import GrammarRegularity. The two are equal by definition, and Mechanism's `image_step_iff` already writes it so.
3. `he_history_move.py`, before the checker: `Becoming/KeptOnward.lean` goes to the Lean history folder (`lean/history/becoming/Becoming/`) with its bytes as on main, by `research.py move` (plan `he-history.tsv`, batch HE-history), as R32 and R33 did, at the coordinating session's word. The pin on the package's Lean files is lifted for the move only and restored byte for byte. The move writes its manifest and receipt. It re-points master-laws-on-the-grammar's KeptOnward reference and binding to the history copy, and `he_records.py` then drops both, since `kept_onward`'s proof is GrammarLaws'. A dry run on main: one file moved, two references re-pointed in one live file, six generated pages to re-render, no conflict.
4. After the checker:
   - `he_signatures.py`, the signature audit. Every statement of the twelve changed modules is unchanged, three declarations move module, and KeptOnward is gone from the run.
   - `he_records.py`, the three records the moves touch.
   - `he_texts.py`: 01 §7's lumping bullet, 08's counts and the study section (`he_study.txt`).
   - `he_board.py`, the head claim and the land step. The land step closes HE's row and stops OU3f's row saying that GrammarLaws' doc lags.

Every import path was checked. KeepingWidening reaches Dissipation, Mechanism reaches GrammarLaws, and each of the six modules reaches GrammarLaws without KeptOnward. GrammarTransport imports GrammarLaws, so «保之像»'s consumer (`ProcessRepresentation`) still sees it.

## Checks

- **A pre-rehearsal** on main at `a15457b2e`, outside the repository, with both scripts applied. It is the near-full rebuild, and its steps stay in the shared cache.
- **The rehearsal** on main after UE18 and UE19 land. It reuses all but the new leaves.
- **The signature audit.** Mechanism's two lemmas keep their statements and are proved as cases of «保之像»; the test of OU3d's second review applies to them.
- **One independent review** of the kit and the tree before the head is claimed.
- **After the run:**
  - the connectivity check, for any register entry the moves affect;
  - the measure and MV's generator;
  - re-pointing: what-a-line-holds-and-a-regularity-takes-in and constancy-read-at-a-members-class (the GrammarPath script's owner names both), and every record research-check names, each read first;
  - rendering in a clean worktree.

