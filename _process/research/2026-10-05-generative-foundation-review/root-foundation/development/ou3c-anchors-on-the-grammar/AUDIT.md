# OU3c: the return, lumping and order anchors on the grammar

AI-written audit for board item OU3c, 28 October 2026, on main at `c2dd2c875` (OU3b's [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md) item 1, with item 3 and, by the decision of the owner of `ComparingCourses` and `ReachableRanges`, item 4). Each of the six anchors OU3b left beside the grammar is either redefined as its grammar term, with a body equal by `rfl`, or keeps its definition; in the second case its consumers are derived from the grammar's laws where they are cases of one, and a reason is written where they are not. No statement changes, except `strictJoin_trans`/`strictJoin_irrefl` generalised to any universe (row 7). Rerouting a proof only to raise the count is not done (OU plan §十三).

## The bodies: none is its grammar term by `rfl`

| Anchor | Its body | Its grammar term | Why not `rfl` |
|---|---|---|---|
| `Branching.Returns P s` | `∃ a t, P.step s a t ∧ Reach P t s` | `«及» (Steps P) s s` | `«及»` is inductive; `Reach` is a trace; equivalent only through `«及当且仅当一步而所闭»` and `reach_iff_withinClosure` (`returns_iff_reaches`) |
| `Branching.Lossless P` | `∀ x y a b t, P.step x a t → P.step y b t → x = y` | `«定前» (Steps P)` | the grammar's form takes the composite `R;R˘` as one antecedent, `∃ t, (∃ a, …) ∧ (∃ b, …)`, where the body curries `a b t` (`lossless_iff_fixedBefore`) |
| `revisits_within` | a theorem (an alias of `GrammarLaws.revisits_within`) | none | pigeonhole on a list and numbers; OU3b's audit row 8 reads it as not a statement of the grammar |
| `GoAlikeUnder P π E` | `∀ s s' a u u', E (π s) (π s') → P.step s a u → P.step s' a u' → E (π u) (π u')` | `∀ a, «同行» (P.step · a ·) (E on π)` | the grammar's form is an inclusion of the composite `R˘;E;R`, whose antecedent is two nested existentials (`goAlikeUnder_iff_alike`) |
| `Web.Widens l l'` | `Includes l l' ∧ Exceeds l l'`, over steps and formations | `«广» (admitted l) (admitted l')` | the grammar's comparison is of coreflexive relations on `Nat × F`: each clause carries `p = q` and a pair (`widens_iff`, `includes_iff`, `exceeds_iff`) |
| `Weighting.WidensOn items a b` | `IncludesOn ∧ ExceedsOn` over listed items | `«广» (admittedOn items a) (admittedOn items b)` | as for `Web.Widens`, through `admittedOn` (`widensOn_iff`) |

So every anchor keeps its definition. A redefinition that is not `rfl` would change what the anchor unfolds to while statements printed the same, and every consumer would then reach the grammar by definition rather than by a derivation. Such a redefinition is a change to definitions of `Recurrence`, `Laws`, `Admission` and `Weightings`, decided by their owners (board rule 3). It is not done here. The proposal and the recommendation against it were put to the coordinating session on 28 October.

## The ten central declarations

Each declaration's anchor dependencies were read from the checker cache (`ec.constants()`).

| # | Declaration | Anchor it rests on | Decision | Why |
|---|---|---|---|---|
| 1 | `Learning.goAlike_iff_lumped` | `GoAlikeUnder` (through `GoAlike`) | **derived** from `«像定后当且仅当同行»` | It is the grammar's law of the image (the image along a map has a fixed successor exactly where sameness under the map goes alike) read on a determined law's one move. Going alike is the grammar's (`goAlikeUnder_iff_alike`), and the image's fixed successor unpacks to `Lumped π (π ∘ next)` (`fixed_image_iff_lumped`, new). The direct proof goes (board rule 9). |
| 2 | `Branching.loss_passes_juncture` | `Branching.Returns`, through `step_back` | **derived**: `step_back` from `«所闭当且仅当同一或及»` and `«及当且仅当一步而所闭»` | `step_back` says that where `s` returns, what can have `s` has a step after which it still can. That is the grammar's decomposition of reach (the closure is identity or reach, and reach is a step and then the closure) read on the steps of `P`, with returning read as reaching itself (`returns_iff_reaches`). The juncture law uses return only there, so its dependence on return now goes through the grammar. Its double negation and its induction on the course are its own. |
| 3 | `Learnable.learnable_iff` | `revisits_within`, through `Learning.lasso_of_held` | **reason** | The lasso's bound (`i + q + 1 ≤ l.length`) is pigeonhole alone; the periodicity after it is the law's iteration. The grammar's finite-line law `«定后于线有限则末返»` states the return without that bound, and the bound is what the Moore-type limit (`2|l| − 1` steps) needs. A grammar law carrying the bound would restate pigeonhole, a lemma on lists, not derive the learnability law from return. |
| 4 | `LearnableRuns.learnable_iff_tracks` | the same | **reason** | As row 3. |
| 5 | `Web.paths_extension_iff_widens` | `Web.Widens` | **reason** | It identifies C's extension on the paths of a web (every claim counted) with widening. Its content is a reindexing, a claim being a (formation, step) pair and admission being read at (step, formation), together with counting every claim. Widening's order laws already come from the grammar (OU3b). Reaching the grammar here would take a transport of `«广»` along the swap of a pair, which adds machinery and no content. |
| 6 | `Direction.extension_iff_widens` | `Web.Widens` | **reason** | It is row 5 on the moves' frame (`W.paths_extension_iff_widens`). |
| 7 | `Web.paths_comparison_widens` | `Web.Widens` | **reason** | It is one direction of row 5, for every reading of `living`. |
| 8 | `Web.widens_iff_retains_adds` | `Web.Widens` (its definition) | **reason** | Its content is the reduction of what has significance to what can form under the continuation condition (`retains_iff_includes`, `adds_iff_exceeds`). The grammar does not state it: the free significance is not lifted to the root (01 Open). Widening enters only by its definition. |
| 9 | `Web.paths_one_object` | `Web.Widens` | **reason** | The conjunction of rows 5 and 8 with `unrestricted_iff_paths_livingSignificance`. |
| 10 | `Weighting.widens_iff_every_positive` | `Weighting.WidensOn` | **reason** | Widening is what every positive weighting ranks higher. That is a law of weights, which the grammar has none of. Widening's order laws on the listed items already come from the grammar (`WidensOn.trans`, `WidensOn.not_reverse`). |

The two declarations that rest on balance and on an anchor (`Flow.Balances.widens_iff_others_within`, `Flow.new_beyond_every`) are read by the measure as *balance, represented* (item 3).

## The relation laws (item 4)

`strictJoin_trans` and `strictJoin_irrefl` are laws of any two relations on any carrier. They move from `ComparingCourses` into `Becoming.GrammarLaws`, after widening's laws, with the same names and statements. The one change is the universe: they were stated at `α : Type`, which is why `ReachableRanges` proved its lagged order's transitivity again "at configurations of any universe". They are now stated at `α : Type u`; every earlier use is an instance. `ComparingCourses`' uses resolve to the moved laws unchanged. `Reaching.WidensOrLater.trans` and `.irrefl` (`ReachableRanges`) are now derived from them: widening what can be reached is transitive, covering with some lag is transitive, and widening is covering with lag zero.

## The measure (item 3)

`measure_grammar.py` gives each central declaration one category: `grammar`, `balance, represented`, `anchor, not reached` or `no master law`. It reports the distinct declarations by category and counts the last two as the gap. On main before OU3c the counts are 28, 30, 10 and 50 (118 distinct, so a gap of 60). After OU3c they are expected to be 30, 30, 8 and 50 (a gap of 58); the landing reruns the measure.

## What changes in Lean

- `Becoming.GrammarLaws`: `strictJoin_trans`, `strictJoin_irrefl` (moved, universe-general).
- `Becoming.ComparingCourses`: the two laws removed; the uses unchanged.
- `Becoming.ReachableRanges`: `Reaching.WidensOrLater.trans` and `.irrefl` from them.
- `Becoming.LearningRuns`: `fixed_image_iff_lumped` (new); `goAlike_iff_lumped` from `«像定后当且仅当同行»`.
- `Becoming.Junctures`: `Branching.step_back` from `«所闭当且仅当同一或及»` and `«及当且仅当一步而所闭»`.

Every other statement is unchanged. The landing's signature audit compares every declaration of these five modules with main's receipt.
