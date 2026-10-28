# OU3c: the return, lumping and order anchors on the grammar

AI-written audit for board item OU3c, 28 October 2026, on main at `c2dd2c875` (OU3b's [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md) item 1, with item 3 and, by the decision of the owner of `ComparingCourses` and `ReachableRanges`, item 4). Each of the six anchors OU3b left beside the grammar is either redefined as its grammar term, with a body equal by `rfl`, or keeps its definition; in the second case its consumers are derived from the grammar's laws where they are cases of one, and a reason is written where they are not. No statement changes, except `strictJoin_trans` and `strictJoin_irrefl` generalised to any universe (*The relation laws*, below). Rerouting a proof only to raise the count is not done (OU plan §十三). The coordinating session agreed to this reading on 28 October, and one independent read-only review was taken (the last section).

## The bodies: none is its grammar term by `rfl`

| Anchor | Its body | Its grammar term | Why not `rfl` |
|---|---|---|---|
| `Branching.Returns P s` | `∃ a t, P.step s a t ∧ Reach P t s` | `«及» (Steps P) s s` | `«及»` is inductive; `Reach` is a trace; equivalent only through `«及当且仅当一步而所闭»` and `reach_iff_withinClosure` (`returns_iff_reaches`) |
| `Branching.Lossless P` | `∀ x y a b t, P.step x a t → P.step y b t → x = y` | `«定前» (Steps P)` | the grammar's form takes the composite `R;R˘` as one antecedent, `∃ t, (∃ a, …) ∧ (∃ b, …)`, where the body curries `a b t` (`lossless_iff_fixedBefore`) |
| `revisits_within` | a theorem (an alias of `GrammarLaws.revisits_within`) | none | pigeonhole on a list and numbers; OU3b's audit row 8 reads it as not a statement of the grammar |
| `GoAlikeUnder P π E` | `∀ s s' a u u', E (π s) (π s') → P.step s a u → P.step s' a u' → E (π u) (π u')` | `∀ a, «同行» (P.step · a ·) (E on π)` | the grammar's form is an inclusion of the composite `R˘;E;R`, whose antecedent is two nested existentials (`goAlikeUnder_iff_alike`) |
| `Web.Widens l l'` | `Includes l l' ∧ Exceeds l l'`, over steps and formations | `«广» (admitted l) (admitted l')` | the grammar's comparison is of coreflexive relations on `Nat × F`: each clause carries `p = q` and a pair (`widens_iff`, `includes_iff`, `exceeds_iff`) |
| `Weighting.WidensOn items a b` | `IncludesOn ∧ ExceedsOn` over listed items | `«广» (admittedOn items a) (admittedOn items b)` | as for `Web.Widens`, through `admittedOn`; `ExceedsOn` reads `b x = false` where the grammar reads `¬ (… = true)` (`widensOn_iff`) |

So every anchor keeps its definition. A redefinition that is not `rfl` would change what the anchor unfolds to while statements printed the same, and every consumer would reach the grammar by a definitional mention, not a derivation: the rerouting OU's §十三 rules out. It is not done; the coordinating session agreed.

## The ten central declarations

Each declaration's anchor dependencies were read from the checker cache (`ec.constants()`).

| # | Declaration | Anchor it rests on | Decision | Why |
|---|---|---|---|---|
| 1 | `Learning.goAlike_iff_lumped` | `GoAlikeUnder` (through `GoAlike`) | **derived** from `«像定后当且仅当同行»` | It is the grammar's law of the image (the image along a map has a fixed successor exactly where sameness under the map goes alike) on a determined law's one move: `Lumped π (π ∘ next)` says that `π ∘ next` factors through `π`, the image's fixed successor (`lumped_iff_fixed_image`, new), and going alike is the grammar's (`goAlikeUnder_iff_alike`). It stands as `image_determined_iff` does (OU3b). The direct proof goes (board rule 9). |
| 2 | `Branching.loss_passes_juncture` | `Branching.Returns`, through `step_back` | **derived**: the case split of `step_back` from `«所闭当且仅当同一或及»` and `«及当且仅当一步而所闭»` | `step_back` says that where `s` returns, what can have `s` has a step after which it still can. Its case split is the grammar's decomposition of reach on the steps of `P` (the closure is identity or reach, and reach is a step and then the closure); at `s` itself the step is the return, used as it is. So `loss_passes_juncture` reaches the grammar through the closure laws of that split, not through return: its type still names `Returns P s`. |
| 3 | `Learnable.learnable_iff` | `revisits_within`, through `Learning.lasso_of_held` | **derived**: the lasso's repetition from `«迭之接»` and `«迭之定»` | The lasso has two halves. Its bound (`i + q + 1 ≤ l.length`) is pigeonhole and stays so. Its repetition after the revisit is the grammar's law of steps, as OU3b proved `Law.orbit_mul` from `«迭之周»` and `«迭之定»`: a loop of `q + 1` steps then `d` steps is `d + q + 1` steps (`«迭之接»`), and with a fixed successor those lead where `d` steps lead (`«迭之定»`), read on the orbit by `Law.steps_orbit`. The learnability laws reach the grammar through that half. |
| 4 | `LearnableRuns.learnable_iff_tracks` | the same | **derived**, as row 3 | As row 3. |
| 5 | `Web.paths_extension_iff_widens` | `Web.Widens` | **reason** | It identifies C's extension on the paths of a web (every claim counted) with widening. Its content is a reindexing, a claim being a (formation, step) pair and admission being read at (step, formation), together with counting every claim. Widening's order laws already come from the grammar (OU3b). Reaching the grammar here would take a transport of `«广»` along the swap of a pair, which adds machinery and no content. |
| 6 | `Direction.extension_iff_widens` | `Web.Widens` | **reason** | It is row 5 on the moves' frame (`W.paths_extension_iff_widens`). |
| 7 | `Web.paths_comparison_widens` | `Web.Widens` | **reason** | It is one direction of row 5, for every reading of `living`. |
| 8 | `Web.widens_iff_retains_adds` | `Web.Widens` (its definition) | **reason** | Its content is the reduction of what has significance to what can form under the continuation condition (`retains_iff_includes`, `adds_iff_exceeds`). The grammar does not state it: the free significance is not lifted to the root (01 Open). Widening enters only by its definition. |
| 9 | `Web.paths_one_object` | `Web.Widens` | **reason** | The conjunction of rows 5 and 8 with `unrestricted_iff_paths_livingSignificance`. |
| 10 | `Weighting.widens_iff_every_positive` | `Weighting.WidensOn` | **reason** | Widening is what every positive weighting ranks higher. That is a law of weights, which the grammar has none of. Widening's order laws on the listed items already come from the grammar (`WidensOn.trans`, `WidensOn.not_reverse`). |

The reasons for rows 5 to 10 are written into the record (`master-laws-on-the-grammar`, does-not-show) and into the measure's output (`anchor_not_reached_reasons`). Their content (C's extension on paths, the condition's reduction of significance, weights) is input for EC6's audit. The two declarations that rest on balance and on an anchor (`Flow.Balances.widens_iff_others_within`, `Flow.new_beyond_every`) are read by the measure as *balance, represented* (item 3).

## The relation laws (item 4)

`strictJoin_trans` and `strictJoin_irrefl` are laws of any two relations on any carrier. They move from `ComparingCourses` into `Becoming.GrammarLaws`, after widening's laws, keeping their names and their statements. The one deliberate change is the universe. They were stated at `α : Type`, which is why `ReachableRanges` had proved its lagged order's transitivity again "at configurations of any universe". They are now stated at `α : Type u`, so the statement covers more and every earlier use is an instance. They stay typed `α → α → Prop` rather than `«际» α`. They are lemmas the orders use, not statements of the grammar, and restated over `«际»` every consumer would reach the grammar by a name.

`ComparingCourses`' uses resolve to the moved laws unchanged. `Reaching.WidensOrLater.trans` and `.irrefl` (`ReachableRanges`) are now derived from them, and its universe-general copy goes: widening what can be reached is transitive, covering with some lag is, and what widens covers with lag zero. The record of `ComparingCourses` (`comparing-two-courses-on-what-they-admit`) cites the two laws in its proof reference to `ComparingCourses`; at landing they move to a reference and binding to `GrammarLaws`, with a history note.

## The measure (item 3)

`measure_grammar.py` gives each central declaration one category: `grammar`, `balance, represented`, `anchor, not reached` or `no master law`. It reports the distinct declarations by category, counts the last two as the gap, and gives the reason for each declaration in `anchor, not reached`, flagging any without one. On main before OU3c the counts are 28, 30, 10 and 50 (118 distinct, a gap of 60). After OU3c they are expected to be 32, 30, 6 and 50 (a gap of 56). The landing reruns the measure.

## What changes in Lean

- `Becoming.GrammarLaws`: `strictJoin_trans`, `strictJoin_irrefl` (moved, universe-general); the header names them and the new consumers.
- `Becoming.ComparingCourses`: the two laws removed; the uses unchanged.
- `Becoming.ReachableRanges`: `Reaching.WidensOrLater.trans` and `.irrefl` from them.
- `Becoming.LearningRuns`: `lumped_iff_fixed_image` (new); `goAlike_iff_lumped` from `«像定后当且仅当同行»`.
- `Becoming.Junctures`: `Branching.step_back`'s case split from `«所闭当且仅当同一或及»` and `«及当且仅当一步而所闭»`.
- `Becoming.Learning`: `lasso_of_held`'s repetition from `«迭之接»` and `«迭之定»`.

Every other statement is unchanged. The landing's signature audit compares every declaration of these six modules with main's receipt.

## The review, and what was taken

One independent read-only review by a separate AI agent, 28 October 2026. Every finding was taken.
1. **`step_back`'s return branch was a round trip.** It went through `returns_iff_reaches` and back, which adds a grammar dependence and no content. Now the return is used as it is, and row 2 says that the juncture law reaches the grammar through the closure laws of the case split, not through return.
2. **The reason for rows 3 and 4 covered only half the lasso.** The repetition follows from the laws of steps, as OU3b's `Law.orbit_mul` does. Now derived, so two more declarations reach the grammar, with content.
3. **The record of `ComparingCourses` would fail the record check.** It bound the moved laws to `ComparingCourses`; the binding moves to `GrammarLaws` at landing.
4. **The new lemma's orientation and headings.** The lemma now takes the bridges' orientation, the model's side first (`lumped_iff_fixed_image`). The headings no longer call it moved or unchanged.
5. **A docstring said more than its proof.** It now reads "what widens covers with lag zero", which is what the proof shows.
6. **`GrammarLaws`' header** now names the two relation laws and the new consumers, and says why the laws stay typed on `α → α → Prop`.
7. **A wrong cross-reference** in this note's opening is corrected.

The review confirmed the `rfl` reading, the instance in row 1, the reasons for rows 5 to 10, the strict join's statements and uses, and that the modules were unchanged on main since `c2dd2c875`.
