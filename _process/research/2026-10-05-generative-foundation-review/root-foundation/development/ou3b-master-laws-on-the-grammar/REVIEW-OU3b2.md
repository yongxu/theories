# OU3b / OU3b-2 review: the master laws on the grammar

AI review, 26 October 2026. Independent and adversarial, read-only except for this file. It covers `tree/Becoming/GrammarLaws.lean` and the diffs of the eleven changed modules against the checkout (`experiments/…/lean/becoming/Becoming/`), read against [DESIGN](DESIGN.md), [DRAFT-NOTES](history/DRAFT-NOTES.md), [OU3b2-NOTES](OU3b2-NOTES.md), [REVIEW-ASTRA-A](REVIEW-ASTRA-A.md), 08 §6–§7, `Becoming.Grammar`, AGENTS.md and board rule 9. Paths are relative to this folder unless given in full. A is `tree/Becoming/GrammarLaws.lean`.

## What I checked myself

- **Statements unchanged (1).** I built the checkout's modules (scratch tree `t0`) and a copy of this tree (`t1`) with `scratch_build.py`. Every step was restored from the shared cache, meaning identical inputs had passed before. `t1` has 111 modules and A has 98 declarations, all with empty axiom reports. I then printed 29 declarations with `pp.all` against each build: 19 originals with changed proofs, plus `carries_law_iff`, `Flow.Balances`, `Flow.Balances.over` and `RecurrenceRuns.lossless_iff_returns`. The two outputs are identical (`diff` empty, 121 lines). This agrees with `OU3b2-statements.txt`.
- **Definitions mean the same (3).** `OU3b2Check` prints only types (`#check`), so it does not compare the bodies of `ClosedUnder`, `WithinClosure` or `skipAt`. Against the tree, I checked the checkout's own bodies by `rfl`:
  - `@ClosedUnder = fun rel region => ∀ g h, region g → rel g h → region h`;
  - `@WithinClosure = fun rel f g => ∀ region, ClosedUnder rel region → region f → region g`;
  - the three equations of `skipAt`.

  All pass. Downstream uses that depend on unfolding (`Likeness.skip_side`, `skip_succ`, `Description`) compile in the drafter's full build. No name in A collides with any declaration in the checkout or in any `development/*/tree`. I checked all 83 «» names.
- **Two witnesses (4, 5),** each compiled against `t1` with an empty axiom report. The scratch files are in `/private/tmp/claude-501/-Users-ren-theories/568486ee-fafd-4bf5-b667-a3da885f62a8/scratchpad/chk/`.
  ```lean
  theorem no_match_under_nothing : ¬ «对» (fun (_ _ : Unit) => False) [()] [()]
  theorem local_fixed_enough : ∃ (R : «际» (Option Bool)), ¬ «定后» R ∧ «及» R none none ∧ ¬ «入» R none
  ```
  The second uses `R a b := (a = none ∧ b = none) ∨ a = some true`.
- **Bases (8).** For each of the eleven modules, the checkout's last commit (`9d718f04e`, `e71cb8993`, `c05d509af`, `866370911`, `826434dc4`, `bd4e80ee7`, `f41c7069e`, `4686bcdf6`, `df26acbc8`, `395bfa9e5`) predates the tree copy. None of them has an uncommitted change. Each diff contains only OU3b hunks. Nothing in the Lean has changed on main since then (HEAD `8f3fa364c`; UE4 `71d4e1203` landed at 23:41 and was inside the drafter's full build). So no tree file is stale as of now.

## Findings

1. **Overclaim: A:8–9.** The header says "Each is stated with what it uses; where a convenient global form uses more…, it is a corollary of a local one." That holds for lumping and for the line law's list and totality. It does not hold for:
   - `«定后则返者不入»` (A:477) and `«入当且仅当不返»` (A:486). They assume a fixed successor everywhere, but the proof (`«环则所及皆返»`, A:464) uses it only at what `x` reaches. `local_fixed_enough` shows a relation whose successor is not fixed yet whose looping occurrence is not drawn.
   - `«线有限定前则返»` (A:549), which assumes `«定前»` globally where only the line's places are used.
   - `«皆返定后则定前»` (A:575), which assumes every occurrence loops where only two occurrences sharing a successor are used.

   **Fix:** add the local forms (fixed along `«所闭» R x`; merging nothing at the line's places) and keep the global forms as corollaries. Otherwise, restrict the sentence to the laws it is true of.

2. **Overclaim: A:74–77, against 08-METHOD.md:426.** A asserts "a course already at rest need not be drawn, so rest is not drawn in (`«入»`)" with no Lean behind it. The 08 §7 row it will sit under says the opposite ("rest is a case of being drawn", anchor `Amounts.rests`). After landing, the chapter would state a clause of a master law that the module beneath it rejects.

   **Fix:** prove the witness. A fixed point is at rest in `Amounts.rests`'s sense (`P` never holds), yet under a fixed successor it reaches itself, so it is not drawn (`«定后则返者不入»`). Then revise the 08 §7 row and its anchors through the record. Otherwise, soften A to "is not shown to be".

3. **Imprecision (naming): A:20, 34, 312–319, 354, 360; Flow `balances_of_continued` (tree Flow.lean:334) and Flow.lean:21.** `«对»` is glossed and documented as "continued one to one" and "a one-to-one continuation". In this grammar, continuation is `«续»` (`«合» R E`), and `«对» R` is a matching under any relation. This reintroduces the reading REVIEW-ASTRA-A F2 asked to remove ("conservation as continuation").

   **Fix:** gloss `«对»` as "matched one to one" or "a perfect pairing of places under `R`", and rename `balances_of_continued` to `balances_of_matched`. If continuation is meant, state the case `«对» («续» R E)` and prove what it adds.

4. **Imprecision: A:39–40 and tree Flow.lean:333.** "For an arbitrary relation only matching gives balance, not the converse" and "only this direction holds" are claims without Lean. They are true: `no_match_under_nothing` gives equal counts with no matching.

   **Fix:** add that witness to A, under `«一之对»`.

5. **Imprecision: A:500–503.** The second clause of `«入而返之例»`'s docstring, "a relation with no fixed successor need not draw what reaches itself", is not shown by this witness, which draws what reaches itself.

   **Fix:** add the converse witness (`local_fixed_enough` serves) or drop the clause.

6. **Imprecision (names state a wrong meaning): A:464, 486, 566, 593.** Four names omit a load-bearing hypothesis. Read without it, each states something false, in two cases by the module's own counterexample:
   - `«入当且仅当不返»` is refuted unconditionally by `«入而返之例»`.
   - `«环则所及皆返»` fails without `«定后»`: in the same witness, `false` loops and reaches `true`, which does not reach back.
   - `«有限定前则皆返»` and `«有限定前当且仅当皆返»` fail without a successor everywhere: the empty relation on `[()]` merges nothing and nothing returns.

   Elsewhere A names its hypotheses (`«有常定后则同行»`, `«同行遍后则有常»`, `«定前则线可退»`). Because these names state a wrong meaning, the rule against renaming sweeps after landing permits fixing them later, but it is cheaper now.

   **Fix:** names such as `«定后有后则入当且仅当不返»`, `«定后环则所及皆返»`, `«有限遍后定前则皆返»` and `«有限遍后定后则定前当且仅当皆返»`.

7. **Imprecision (rule 9 residue): tree Recurrence.lean:408, 421, 619, 649, 286.** Several declarations keep direct proofs of mechanisms A now states:
   - `Branching.Lossless.cancel` is A's `«定前则线可退»` on a run.
   - `Branching.Lossless.comes_back` (with `recurs`, `no_rise` and `unlisted`, which use it) is pigeonhole plus cancel, the body of `«线有限定前则返»`.
   - `Law.Lossless.cancel` is cancel at a determined law.
   - `Law.returns_of_reachable` is pigeonhole-return by orbit arithmetic.
   - `Law.orbit_mul` is `«迭之周»` at the orbit.

   So the line law now has two proofs, A's and `comes_back`'s.

   **Fix:** derive `Branching.Lossless.cancel` from `«定前则线可退»` (take `N := i + d`) and `comes_back` from A's pigeonhole and cancel. Otherwise, write in the notes and the record why they stay.

8. **Imprecision: tree Recurrence.lean:87 and 152, A:193 and 205.** "Pigeonhole is the grammar's" and "stated once, on the grammar, and restated here" are inaccurate:
   - Pigeonhole is a lemma about `Nat` and `List`, not a statement in the grammar's vocabulary. EC's `measure_grammar.py` (`is_grammar`: «» names) rightly does not count it.
   - It is proved once, in A, and Recurrence holds nine aliases, with `skipAt` as a `def` alias.
   - A's `GrammarLaws.le_dest` and `GrammarLaws.length_append` are second proofs of `Prelude.le_dest` (Prelude.lean:38) and `Prelude.length_append` (Prelude.lean:357).

   **Fix:** say "proved once in `Becoming.GrammarLaws`, where the law of finite runs needs it below the frame; the declarations here are its aliases". Derive one pair of `le_dest` and `length_append` from the other where the imports allow it, or note why not.

9. **Imprecision: A:11–14.** "Proved from them in … `Laws`": `Laws` holds only the bridges (`determined_iff_fixed`, `goAlikeUnder_iff_alike`), and nothing in it is proved from A.

   **Fix:** "bridged in `Laws`, proved from them in `Mechanism`, …".

10. **Overclaim: A:4–7, the commit message of `8f3fa364c` and the board title ("the five master laws on the grammar").** Balance is read on the grammar, not lifted in 08 §6's sense:
    - The "law on the grammar" is a cardinality encoding of `Nat` by lists of `Unit`, and lists are not grammar vocabulary.
    - Under `«一»` it reduces to equal length (`«一之对»`).
    - No consumer of `Flow.Balances` is derived; the 52 central declarations on balance are untouched.
    - The "over every stretch" clause stays arithmetic.
    - The measure's other balance anchors (`Flow.BalancesOn`, `balance_over_stretch_on`) are not represented.

    A's body says most of this honestly, but its title and the board/commit summary do not.

    **Fix:** title A "four master laws on the grammar; balance read at one step". Have the record and 08 §7 say that balance is represented, not lifted.

11. **Imprecision: incomplete coverage of the measured anchors.** EC's `measure.py` `LAWS` also lists `Weighting.WidensOn` (Weightings.lean:428, order), `Amounts.FallsStop` and `Amounts.rests` (finite runs), and `Flow.BalancesOn` (balance). OU3b represents none of them, so the central declarations resting on them will not reach the grammar.

    **Fix:** represent `WidensOn`. It is `«广»` on a partial identity over the listed items, as straightforward as `Web.admitted`. Alternatively, list each anchor as not represented, with its reason, in the record.

12. **Imprecision: DESIGN "What done means" item 4, and 08 §6's first requirement.** The measure after the change is not taken; `baseline.json` (0 of 127 reach the grammar) has no counterpart. No per-anchor dependency audit is written either, that is, which fields and premises each anchor's statement and proof reach. The notes give hypotheses, which is not the same thing.

    **Fix:** run `measure_grammar.py` once A is in the checker cache (at landing), record before and after, and add a short audit table, one row per anchor.

13. **Suggestion (judgment to write down): Admission.lean:389–395, Regions.lean:204–211.** `Includes.refl`, `Includes.trans`, `Keeps.symm` and `Mixed.symm` were one-liners and now pass through the `admitted` encoding. DESIGN item 3 forbids routing only to raise the measure, and balance was kept off the grammar for exactly that reason. Routing order is defensible: the grammar's inclusion and widening are the general law and Web's are their instance, whereas balance's grammar form is an encoding of numbers. That reason is not written anywhere.

    **Fix:** state it in the notes and the record. Also name `admitted` as the standard representation of a set by a partial identity (a coreflexive relation).

14. **Suggestion: tree Mechanism.lean:106 and :21.** `image_step_iff` is used by no proof (definitional unfolding does the work); say that it documents the representation. Line 21 is 128 characters; rewrap it.

15. **Suggestion: `OU3b2Check.lean.txt`.** Add the three `rfl` checks of the definitions' bodies (above), since `#check` does not compare values.

16. **Suggestion (for the lander):**
    - **Integration.**
      - Add `Becoming.GrammarLaws` to `CORE` in `check_becoming.py:72`. Otherwise the assertion `core_closure == PURE` at :3573 fails, because Frame imports it.
      - Add it to the root `Becoming.lean`.
      - Add a `regions.json` entry (region root, base grammar).
      - Reconsider Frame's base in `regions.json` now that its closure is the grammar's.
    - **Records and pages.**
      - Write a record, covering the new consequence `Branching.Lossless.returns_of_total`.
      - Revise the 08 §7 table and its connectivity counts.
      - Regenerate the theory graph and COMPLETION.
      - Update the board row.
    - **Files.**
      - Do not copy `tree/.build`, and remove it once the landing is done.
      - DRAFT-NOTES.md, OU3bCheck.lean.txt and DESIGN.md line 27 ("conservation as a fact about continuation") describe the superseded draft (module B, the `_by_grammar` copies, the old names). Move them with `research.py move` to `history/`, or mark them superseded.
      - Import order is fine: A imports only Grammar, and Frame imports A, so there is no cycle.

## Law by law against 08 §6 (audit, lifting, representation both ways)

| Law | Lifting | Representation | Rule 9 | Discharged? |
|---|---|---|---|---|
| Closure | yes; Frame's definitions are now A's | both ways, by definition; `«所闭当且仅当同一或及»` | yes, all eleven Frame laws and two in GrammarScope | **yes**, except the written audit |
| Balance | encoding only, at one step | `balances_iff_units`, both ways; trivial under `«一»` | none, deliberately | **no**: read, not lifted; stretch, family, `BalancesOn` arithmetic |
| Finite runs | yes for `lossless_iff_returns`, `drawn_iff_not_returns`; some hypotheses global (F1) | `returns_iff_reaches`, `drawn_iff_drawnIn`, `lossless_iff_fixedBefore`, both ways | yes, with residue (F7) | **partly**: the rest clause and `Amounts.rests`/`FallsStop` unrepresented; the chapter's rest clause is contradicted (F2) |
| Lumping | yes, with local forms and the image law | `goAlikeUnder_iff_alike`, `determined_iff_fixed`, `image_step_iff` | yes (`image_determined_iff`, `carries_law_iff`, GrammarRegularity, `sameFuture_of_goAlike`) | **yes**, except the written audit |
| Order | yes, on relations, positive witness | via `admitted` (partial identity), both ways | yes, with the reason to write (F13) | **for `Web.Widens` yes**; `Weighting.WidensOn` unrepresented (F11) |

## Count

0 errors, 2 overclaims (F1, F2) plus one in the summaries (F10), so 3 overclaims, 9 imprecisions (F3–F9, F11, F12), 4 suggestions (F13–F16).

## Verdict

**Land after fixes.** The Lean is sound: every axiom report is empty, the 43 originals (29 rechecked here) keep their exact statements, and the redefinitions of `ClosedUnder` and `WithinClosure` are the old bodies up to `rfl`. Each changed original is now proved from A's law in its own module, not by a wrapper beside it, apart from the pigeonhole aliases and the residues of F7. Closure, lumping and order on `Web.Widens` discharge 08 §6. Balance does not, and finite runs only in part. The summaries (A's title, the commit, the board) must say so (F10). The rest clause needs either a witness or a revision of 08 §7 (F2).

Before landing, fix the names that state a wrong meaning (F6), the claim that every law is stated with what it uses (F1), the "continuation" wording of `«对»` (F3), the unproved claims (F4, F5) and the header wording (F8, F9). The local forms (F1), the F7 derivations and `WidensOn` (F11) may follow as a separate item if the record says so. The measure and audit (F12) belong to the landing.
