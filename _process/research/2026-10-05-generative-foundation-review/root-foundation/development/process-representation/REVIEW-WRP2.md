# WRP2: the review of the Lean

29 October 2026. AI-written. One independent reviewer, Opus and read-only, read WRP2's three modules:
- `tree/Becoming/GrammarLaws.lean` and `GrammarTransport.lean`, against the landed ones;
- `tree/Becoming/ProcessRepresentation.lean`;
- the design, the design's review, the scratch logs and the signature audit, against the package.

It ran no build. It found one error, six should-fixes and five suggestions. Every one is taken, and the Lean was rebuilt after the changes ([build-4.log](build-4.log), [clash-3.log](clash-3.log), [signatures.json](signatures.json)).

**What it found sound.**
- Every statement of ProcessRepresentation proves what it says, on the landed definitions it uses.
- `withMove_renamed` and `renamed_withMove` (now `renaming_of_withMove` and `withMove_of_renaming`) together give exactly the claim, and their renamings invert correctly.
- The twist and the flip are correct and consistent with the converse.
- Decision (a) is met:
  - «迭»'s definition is untouched;
  - 192 statements and 26 bodies are unchanged;
  - exactly six proofs changed, each through the matching law of «历» with no induction of its own.
- The new proofs use no tactic that brings in an axiom.
- No duplicate was found for:
  - the product of correspondences;
  - the list lemmas;
  - the renamings;
  - the pullback of «延»;
  - the correspondence lemmas;
  - the composite along a word.

## Findings

1. **Error.** GrammarTransport's docstring said ProcessRepresentation reads «迭», «迭内», «闭», «定后», «定前» and «同行». In fact no declaration of ProcessRepresentation used the new correspondence lemmas: only `«一一对应».prod` and «保之像» had a consumer. The design's §1.4 made the same claim.

   **Taken, by the reviewer's option (a): the lemmas now have a consumer.** A renaming relating two processes carries each move's relation and the steps (`renaming_moveRel`, `renaming_steps`). Through the bridges and the correspondence lemmas, it keeps:
   - traces, the word renamed letter by letter (`renaming_trace`, through «历之对应»);
   - `n` steps and within `n` steps (`renaming_iterate`);
   - reach, returning and invariants (`renaming_reach`, `renaming_returns`, `renaming_invariant`);
   - determination and merging nothing (`renaming_determined`, `renaming_lossless`);
   - going alike (`renaming_goAlike`) and going on (`renaming_yan`).

   For the trace, «历之像» and «历之对应» now carry a renaming of the letters. The docstring and the design now say who reads each term.

2. **Should-fix.** `sameMove` and `sameConfiguration` were definitionally the landed `sameValue Prod.snd` and `sameValue Prod.fst`. **Taken:** both definitions are deleted and every use reads `sameValue`.

3. **Should-fix.** `factorsThrough_iff_image` reproved what Mechanism's `factors_image` and `Image.least` state. **Taken:** it is proved from them, and its docstring says so.

   The other option was to place «保之像» beside «像» in GrammarLaws, with Mechanism's two lemmas as its cases (rule 9). That is GrammarLaws' owner's call and changes Mechanism, so it is proposed to the owner, not done here. `run_iff_image`'s docstring now cites Labelled's `Shown` and `shown_le_iff`.

4. **Should-fix.** «迭之像» had its own induction beside «历之像». **Taken:** it is derived from «历之像» through «迭即历», with a list lemma, `GrammarTransport.map_replicate`, proved by induction.

5. **Should-fix.** «承之迭» kept its induction with no stated reason. And the design's reason for the «迭内» laws ("at most `n` has no composite form") was untrue: with «迭即历», «迭内即静或缘之迭» writes «迭内» as «历» of the constant «静或缘».

   **Taken:** GrammarLaws' docstring and the design's §4 now give each kept law its reason.
   - «承之迭» reads a course of regions round by round, and a word form would be a new law nothing reads. «存承之迭» is its corollary.
   - The «迭内» laws have no induction left to replace.

6. **Should-fix (documentation).**
   - ProcessRepresentation's "Not shown" lacked four items: the converse of `run_image` on the steps alone (countable choice), the counting remarks, morphisms with question 55's functor, and the case of no configuration.
   - The design still called the faithfulness with both classes, and the correspondence lemmas, "proposed", and used the scratch names.

   **Taken:**
   - The four items are in the "Not shown" list.
   - The design's lines say what WRP2 proved, and its new §8 maps the scratch names to the landed ones.
   - The landing's texts already cover master-laws-on-the-grammar and its home section, 01 §7.

7. **Should-fix.** ProcessRepresentation used "family" for relations indexed by moves, a second sense beside the glossary's (同族) and Onward's. **Taken:** ProcessRepresentation and the record now say "relations, one per move" and "relations indexed by moves".

   «历»'s docstring said "constant family", the phrase GrammarLaws' owner had adopted. Flagged to the owner, who changed it in «历»'s docstrings and the master-laws entry to "«迭» is its case for one relation repeated".

8. **Suggestion (wording).** **Taken:**
   - The two directions of the faithfulness say which is the converse of which, and the hypothesis that the renaming relates the processes is stated.
   - `moveRel_mk`'s docstring now reads the right way round.
   - `reading_next_move_not_withMove`'s docstring states its one witness.
   - The two theorems are renamed with `_of_`: `withMove_of_renaming` and `renaming_of_withMove`.

9. **Suggestion.** `forall_steps_iff`'s `keeps` restricts nothing in content: under propositional and function extensionality every property has it. **Taken:** the docstring says so.

10. **Suggestion.** `NoMoves.needs_a_point` is the right witness, but should be named in parallel with the twist and the flip, and the case of no configuration added. **Taken:**
    - It is split into `NoMoves.models_correspond` and `NoMoves.not_renamed`.
    - `NoConfigurations` is added.
    - "Where it stops" says the empty model forgets the configurations, or the moves.

11. **Suggestion.** One proof term served four steps lemmas. **Taken:** `steps_one_move` states it once, and the four use it.

12. **Suggestion (names and style).** **Taken:**
    - `Twist.P₂_key` is now `P₂_loops_by_one_move`.
    - `Flip.flip`, which shadowed core's `flip`, is now `flipMove`, and `Twist.twist` is now `flipConfiguration`.
    - The witness definitions have docstrings.
    - The list lemmas' `_right` names are now `replicate_add_append`, `replicate_succ_append`, `reverseAux_append` and `reverse_cons_append`.
    - «保» is glossed apart from 守 and 齐.
    - "with no arithmetic" is gone from «迭之分».

    Placing the list lemmas in the Prelude is the owner's call; GrammarLaws' own list section is the precedent kept.

## After the changes

| module | theorems | declarations | axiom reports |
|---|---|---|---|
| GrammarLaws | 136 | 160 | all empty |
| GrammarTransport | 54 | 58 | all empty |
| ProcessRepresentation | 52 | 70 | all empty |

- There is no warning, and the whole package (343 modules) compiles with no clash.
- The signature audit at the latest receipt is unchanged in outcome: only additions, and the same six proofs.
- The record cites the 84 new declarations of ProcessRepresentation and GrammarTransport once each, in eleven laws.
