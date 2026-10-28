# OU3d: step-indexed reaching on the grammar

AI-written design for board item OU3d, 28 October 2026, on main at `c509211df`. Sources: EC6's proposal 7 ([audit](../ec6-no-master-law/AUDIT.md), *Step-indexed reaching*) and the coordinating session's decision ([WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), *After EC6's audit*). The decision: this is a real law, it sits beside `«迭»` in `GrammarLaws`' finite-runs section, and it is reviewed before any consumer bridges to it. The bridges are a second step, done with the owners of the consumers' modules. Only `Becoming.GrammarLaws` changes ([tree](tree/Becoming/GrammarLaws.lean)). The landing also gives the measure's one pending lumping row, `PartForms.goAlike`, its reason (the section *And the part's own law*).

## What is stated

As taken after the review (last section). The new block goes right after `«迭之周»`. The header gets three table rows and one bullet, *Finite runs: steps counted*, and its *What is not shown* gets one clause.

| Declaration | Statement | Use |
|---|---|---|
| `«迭之末步»` | `«迭» R (n + 1) x z ↔ ∃ y, «迭» R n x y ∧ R y z` | `«迭»` takes the first step first; this reads its last step last, as `«相续之末步»` (GrammarRegularity) does for lines. The iterate law needs it, and so does a consumer's bridge from a chain that is built last step last. |
| `«迭内»` (def) | `«迭内» R n x y := ∃ k, k ≤ n ∧ «迭» R k x y` | Within `n` steps. It has the shape of `Withholding.Within`. |
| `«迭内之接»` | `«迭内» R m x y → «迭内» R n y z → «迭内» R (m + n) x z` | Composition, from `«迭之接»` and the addition of bounds, in the brief's and the consumers' order (`Chain.append`'s `i + j`, `after_course`'s `xs.length + n`). |
| `«静或缘»` (def) | `«静或缘» R x y := x = y ∨ R x y` | Staying, or a step. |
| `«迭内即静或缘之迭»` | `«迭内» R n x y ↔ «迭» («静或缘» R) n x y` | Within `n` steps is `n` steps each of which stays or steps. |
| `«承»` (def) | `«承» R P a := ∀ b, R b a → P b` | What every condition held. In the main reading (`R b a`: `b` is a condition of `a`), `a` takes `P` on from all its conditions. |
| `«承之迭»` | `(∀ n a, S (n + 1) a ↔ «承» R (S n) a) → ∀ n a, S n a ↔ «承» («迭» R n) (S 0) a` | The iterate law, exactly `n` steps, no memory. |
| `«存承之迭»` | `(∀ n a, S (n + 1) a ↔ S n a ∧ «承» R (S n) a) → ∀ n a, S n a ↔ «承» («迭内» R n) (S 0) a` | With memory, within `n` steps. Proved as `«承之迭»` at `«静或缘» R`, read back by `«迭内即静或缘之迭»`. |

The scratch build compiles 120 theorems in 143 declarations, every axiom report empty, with no warnings ([log](scratch-3.log)). Before OU3d the module had 115 in 135.

## Choices, with reasons

1. **The iterate law is stated for a course, not for an iterate.** The grammar has no iterate of a map on regions, and `Law.run` and `Law.orbit` sit above it in `Recurrence`. Defining one here would add a second iterate beside `Law.orbit`, and a bridge between the two. So the law is stated for any course of regions `S : Nat → α → Prop` whose rounds follow the rule, each given pointwise by `↔`. A law's run satisfies such a round by `Iff.rfl`: `(Law.run (answers up) s).state (n + 1) a` unfolds to `answers up (state n) a`, which is `«承» up (state n) a`. So `Withholding.answers_closed` is `«承之迭»` with `fun _ _ => Iff.rfl`, and no orbit bridge is needed. The same holds for `waitsAll` and `«存承之迭»`. This is the same pattern as the grammar's lines (`Nat → α`) in `«屡»` and `«线不并»`.
2. **Within `n` steps is `∃ k ≤ n`, not `n` steps each of which stays or steps.** The audit's wording and `Withholding.Within` both have that shape, so a consumer's bridge is closer. Both forms are stated, related by `«迭内即静或缘之迭»`.
3. **The memory law is derived from the law without memory**, by board rule 9: the general law below proves the special one. Keeping what it held is counting oneself among one's conditions. The memory round `S n a ∧ «承» R (S n) a` is `«承» («静或缘» R) (S n) a` pointwise, so `«存承之迭»` is `«承之迭»` at `«静或缘» R`. Its proof has no second induction.
4. **`«迭之末步»` is a law of its own.** It is the decomposition that `«承之迭»`'s step uses. The audit names the consumers' bridges as needing "their own induction" because `Chain` composes last step last, and with `«迭之末步»` that induction is one line per constructor (see the check below). No last-step law for `«迭»` exists in the core: `«迭»` is used only in `GrammarLaws`, `Recurrence` and `Learning`, and none states one. `«相续之末步»` in `GrammarRegularity` is the same decomposition for lines (reach, not `n` steps), and the precedent of the name.
5. **Names.**
   - `«迭内»` means within (`内`) `n` steps (`迭`).
   - `«静或缘»` means staying or a step. It puts 或 between the two terms, as `«所闭当且仅当同一或及»` does, and uses 缘 for a step, as `«缘在所闭»` does. A leading 或 would read "as far as can be refuted", as in `«或屡»`. There is no join in the grammar.
   - `«承»` means to receive from what comes before (承前).
   - `«迭之末步»` means the last step (末步), as in `«相续之末步»` and `«有亡之线末步离核»`; 末 alone is the last place.
   - `«承之迭»` and `«存承之迭»` follow `«同行之迭»` (going alike, over `n` steps). `存` (retaining) marks memory. `«守»` is a defined term in `GrammarMap` (keeping, along some branch), so it is not used here.
   - No exchange word appears, and nothing dualist.
6. **What stays typed as it was.** Regions stay `α → Prop`, as in `«闭»` and `«入»`. No equality of regions is used: rounds are pointwise.

## The consumers, checked but not bridged

A throwaway module ([check-tree](check-tree/Becoming/OU3dBridgeCheck.lean), not for landing) restates `Withholding`'s definitions (`waitsAll`, `answers`, `Chain`, `Within`) and an orbit like `Law.orbit` on top of the new `GrammarLaws`. It then proves:
- `answers_closed` from `«承之迭»`, and `waitsAll_closed` from `«存承之迭»`, each with rounds by `Iff.rfl`;
- `chain_iff : Chain up k b a ↔ «迭» up k b a`, by `«迭之末步»`, using `Withholding`'s own `Chain.zero_eq` and `Chain.last_of_eq` (a direct dependent match on `Chain` brings in `propext` through `Nat.succ.injEq`);
- `WithinMoves.after_course`'s shape (`k` steps, then within `n`, is within `n + k`) from `«迭内之接»`.

All 12 declarations have empty axiom reports ([log](scratch-check-3.log)). The review's stronger check imports the real `Withholding`, `Tolerance` and `Labelled` and re-proves their statements; it is kept, adapted to the final names, in [consumers-check](consumers-check/Becoming/OU3dConsumers.lean), to build once the landing's rehearsal has filled the step cache. So the three consumers named by the audit can reach the grammar:
- `Withholding.withholding_spreads` through `waitsAll_closed`;
- `Tolerance.answers_restores_iff` through `answers_closed`;
- `WithinMoves.after_course` through `«迭内之接»` and a bridge from `Trace` to `«迭»` of the process's steps.

That work is the second step, for those modules' owners. The bridges this check proves are its evidence, not landed code.

## And the part's own law (`PartForms.goAlike`): a reason, not a derivation

EC6's measure found one lumping row pending: `PartForms.goAlike` (`MoveFormation`), which rests on lumping's anchor (`GoAlike` is `GoAlikeUnder` at `Eq`) without reaching the grammar. COVERAGE's actor row has cited it since EC6d. EC6's owner and the coordinating session offered it to this item, reading its proof as constancy with a fixed successor (`«有常定后则同行»`).

**Not constancy.** At the coupled step, with "same part" as `E`, both premises fail:
- constancy needs a coupled step from every joint configuration over a stepping one's part, so the rest must step there;
- the fixed successor, even the local form `«有常局定后则同行»`, needs two coupled steps from one configuration to agree, so the rest must be determined.

The theorem assumes neither, so this route would change its statement.

**Not the image law either.** A re-proof through `«像定后当且仅当同行»` (`image_determined_iff.mp`, applied to the determinacy of the coupled step's image along the part) compiled axiom-free ([tree-mf](tree-mf/Becoming/MoveFormation.lean), [log](scratch-mf-2.log)). The review's second pass found it a rerouting ([REVIEW-OU3d](REVIEW-OU3d.md), *Second pass*): proving the image determined takes the going-alike argument itself, so the term is `image_determined_iff.mp (image_determined_iff.mpr …)` around the old proof, unchanged. It replaces no part of the proof by the law, which is EC6's own test. This differs from `goAlike_iff_lumped`, whose statement is the image law read through two lemmas stated apart.

**The reason.** Its content is the model's premise: the part's law is determined at a move the part alone forms. The image law only reads the conclusion as carrying a law of its own, through `carries_law_iff`, as the module's header already says. So `MoveFormation` is not changed. The measure gives the row its reason in place of the pending entry (`measure_reason_ou3d.py`), the record states it as a does-not-show item, and 08 §7 counts one gap fewer. Lumping stays one of its two central rows reaching the grammar, with no gap.

## What OU3d does not do

- It bridges no step-indexed consumer: the three step-indexed rows stay the measure's pending derivations until bridged.
- It does not decide whether `Withholding.Within` or `Chain` should be defined from `«迭»`/`«迭内»`; that is for `Withholding`'s owner.
- It states nothing about step counts on courses with choices (`Trace` over a process with actions); the bridge for `after_course` reads a trace's moves as `«迭»` of the steps that forget the action.

## Landing

On OU3b's and OU3c's pattern. One module changes, `GrammarLaws`, which sits low in the import graph, so every module above it re-checks. To keep the landing receipt to its changed files, a rehearsal run (`BECOMING_OUT` outside the repository) fills the shared step cache first, as OU3b did, and the landing run then reuses those steps. The landing also includes:
- the signature audit: every old declaration of `GrammarLaws` prints its old statement, and the eight new ones are listed;
- the connectivity register: the new laws without consumers are apart roots, awaiting their bridges;
- 01 §7's finite-runs bullet;
- 08 §7's measure sentence where it changes, and 08's counts;
- the measure's reason for `PartForms.goAlike` in place of its pending entry;
- a study section;
- the record master-laws-on-the-grammar extended (a group of steps counted, two does-not-show items).

## The review, and what was taken

One independent read-only review by a separate AI agent ([REVIEW-OU3d](REVIEW-OU3d.md)). Every finding was taken.
1. **`«或静»` read against `«或屡»`.** A leading 或 means "as far as can be refuted" there. Renamed `«静或缘»`, and so `«迭内即静或缘之迭»`.
2. **The composition's bound order.** It now concludes within `m + n`, the brief's and the consumers' order, by the review's axiom-free proof, so `after_course` needs no commutation.
3. **`守` is a defined term** (`GrammarMap`'s keeping). Renamed `«存承之迭»`, and this note's claim about `«守»` is corrected.
4. **`«迭之末»` renamed `«迭之末步»`**, the grammar's word for the last step, with `«相续之末步»` cited as precedent.
5. **The header.**
   - "a law's run to a course of regions" is dropped from the pending bridges, since a run already is such a course.
   - The closed-forms sentence now says only that `Withholding`'s closed forms have these shapes for its chains, the bridges not shown.
   - The intro names steps counted among the finite runs.
6. **Nits.** All taken: `«承»`'s and `«承之迭»`'s docstrings, the rewrapped line, and the check's docstring.

7. **Second pass: `PartForms.goAlike`.** The re-proof through the image law is a rerouting (the law applied and undone around the old proof), and constancy does not apply. So it is not landed; the row has its reason (*And the part's own law*).

The optional additions (monotonicity of `«迭内»`; `«所闭»` as some number of steps, with its memory corollary) are not taken: no consumer needs them, and they can come with a bridge that does. The review's check against the real consumers is kept as the second step's evidence.
