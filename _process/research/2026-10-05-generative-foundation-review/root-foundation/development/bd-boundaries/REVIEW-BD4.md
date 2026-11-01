# BD4: the independent reading

1 November 2026. Board item BD4, balance on each closure, the `«所闭»` form: `Becoming.BalanceRegions`, BD3's core leaf, extended ([the board](../../../../../BECOMING-WORKBOARD.md), [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md) lever 1 (a), [the design](DESIGN-BD4.md)). Reading time: about eight minutes.

## The reading

One independent AI reader (a fresh Claude Opus agent, read only, with no part in writing the change) read the branch `bd4-design` against its claim base (`git diff main...bd4-design`, at `fde25514b`), the Lean it builds on (`Becoming.Continuity`, `Becoming.GrammarCrossing`, `Becoming.GrammarLaws`, `Becoming.Grammar`) and the repository's rules. It ran no build. It was asked to check eight things:

1. that every text claims exactly what the Lean proves, with every hypothesis named;
2. the Lean: each proof's correctness and simplicity, shorter routes, duplicates, and exact names;
3. the pure core: no classical principle, and no axiom through decided equality;
4. that what is not shown is true and correctly put, and the path witness proves its item;
5. the literature: Gale (1957) and Hoffman (1960);
6. OU's condition on lever 1's test, invariance under re-pairing;
7. that the Chinese says what the English says;
8. the record: a refinement, not a new result, and its caps.

It found no error in the Lean. Every proof is correct, nothing in the package duplicates a declaration, and the pure core holds. Re-pairing is rightly scoped, and the eighth law is a refinement. It found three medium findings and seven low ones, all in the texts or the names but one, the join of the two grains, which is new Lean. Every finding is taken.

| # | Finding | Taken |
|---|---|---|
| 1 | "The least region not gone out of" is said without membership a test, and so stated it is classical: for a region given as a proposition, not going out gives only a double negation on the closure | "the least family the relation closes that holds it" in the module, the docstrings, the law, the design, the study and the board's clause; 01 keeps "the least such region", where "such" carries membership a test |
| 2 | The home section states leastness, which the record does not; the leaf's reference lists 21 of its declarations | Leastness is in the eighth law, with `closureListed_self` and `closureListed_inside` among its declarations; the reference lists every declaration of the leaf, read from its source |
| 3 | The two grains are never joined: nothing proves that balancing transfers exist exactly where the levels read as units pair under the closure; and the unit law needs symmetry, which is said only through the symmetric adjacency | Proved: `unitsOn`, `count_unitsOn`, `closures_iff_unit_counts`, `conservedOn_iff_units_paired`, `balancing_iff_units_paired`, `balancesOn_iff_units_paired`, with `count_append`, the two counts of a repeated entry and `closureListed_unlisted`; the law, 01, the root bullet, the scope, the READMEs and regions.json state the join. Symmetry's need, `«对而单闭域不守数之例»`, is in the module, the design and the study |
| 4 | The checker's scope reads as if the relation is decided | "a symmetric relation whose closure a test decides" |
| 5 | At the unit grain, "each closure" must cover every relatum, listed or not, or it is false (`us = []`, `[5]`, `[6]`) | "the closure of each relatum, listed or not" in the module, the root bullet, the scope and both READMEs; an unlisted relatum's closure holds nothing but itself (`closureListed_unlisted`). The law states the join, whose units stand only on listed relata |
| 6 | The literature is right with two qualifications: undirected only, and Hoffman through the reduction to a circulation | "the uncapacitated, undirected case" in the item on capacities, the module, the root bullet, 01, the correspondence, the design and the study; Hoffman named through the usual reduction |
| 7 | Docstring precision: the counting bound's stalling step can be the `(k + 1)`-th, and only `k + count₀ ≤ count_k` is stated; `reachedListed_stays` not cited; the bullet without decided equality; the web form's sentence without a main verb | Each docstring restated to its statement; the citation, the hypothesis and the verb added |
| 8 | The test is exponential: each step re-reads the step before at every listed relatum | Kept, and said: the test is built to decide, not to be evaluated (the definition's docstring, the design, the study). A version carrying the relata reached so far would evaluate in polynomial time with the same proof shape; nothing here evaluates the test |
| 9 | Placement and names: the counting lemmas and `paired_single` are laws of `«计»` and `«对»`, candidates for GrammarLaws; `conserved_peel` is a metaphor | Named as candidates for GrammarLaws at its next planned near-full rebuild, OU's owner's call (the design, the study); `conserved_peel` renamed `conserved_of_fewer` |
| 10 | Wording: the study's supplied premises ignored the general unit law's hypotheses; "each case split" too narrow; the hypothesis sentence belongs in `hypotheses`, and an instance supplied at use carries its own report; the Chinese law had no subject | The supplied premises name symmetry and the decision; the self-review says no proof splits on an undecided proposition; the first hypothesis names decided equality a modelling hypothesis, and the scope says only what the reports cover; the Chinese law restated with the join, its subject the transfers |

## The re-check

The same reader read the branch again once the findings were taken (at `1544a9864`), with the same rules and no build. It found no error. The new statements are exact, the counts check, and all ten findings were taken correctly, with nothing overcorrected. Six further points, all low, are each taken.

| # | Finding | Taken |
|---|---|---|
| 11 | "The units before" is not defined in the law, the root bullet, the checker's scope or the READMEs, and elsewhere in the package a level's units carry no relatum | "the levels read as units on their relata" in each, citing `Continuity.unitsOn` where declarations are cited; the law's "by «类之对当且仅当类类等数»" left to the dependency on master-laws-on-the-grammar, which names that law for the eighth law |
| 12 | The root bullet attaches "listed or not" to both unit laws, and `pairing_iff_closure_counts` has no list | "the count kept on each closure" for it, "listed or not" for `pairing_iff_closures` alone |
| 13 | Two docstrings of the join leave out hypotheses | decided equality in `conservedOn_iff_units_paired`'s; no repetition and decided equality in `balancesOn_iff_units_paired`'s |
| 14 | `unitsOn` re-does the grammar's gather `«聚»`, and `Weightings.unitsOf`, in a module the leaf does not import, is the same reading | `unitsOn q := «聚» fun x => List.replicate (q x) x`, its count law's proof unchanged; `Weightings.unitsOf` named in its docstring, a merge for a rebuild that touches both |
| 15 | "Computed" sits against a test built to decide, not to be evaluated; and `closureListed_unlisted` proves only that the closure holds nothing else | "computable" in the first hypothesis; "holds nothing but itself" in the module, the docstrings, the design, the study and this record |
| 16 | The comparison with `Flow.balances_iff_units` is loose: that law's units carry no relatum and hold what is given and taken, while here no transfer is among the units | the join named, as OU's owner asked, the closure-local reading of `Flow.balances_iff_units`, the difference said: the closure takes the place of the transfers (the module, the docstring, the design, the study and the correspondence); that it reads only the counts on each closure, in the correspondence and in a link to amounts-by-unit-matchings |

The eighth law at 458 characters was judged acceptable: its cap only warns, and every clause carries a declaration the home section cites.

## The sentence in the reading of boundaries

One sentence was then added to 01 §9.9's reading of boundaries, and the same reader read it alone. Both points are taken.

| # | Finding | Taken |
|---|---|---|
| 17 | Medium: the sentence takes the paragraph's boundaries, regions closed under the relation one way, where the law takes regions closed under adjacency among the listed relata, the relation read both ways. On one-way regions the claim is false: with the relation holding only from 0 to 1, a move from 1 to 0 is along adjacency, and the region {1}, closed under the relation, loses its amount. "It" in "not gone out of along it" was unclear, and "among the listed relata" was dropped | The sentence now says which boundaries amounts keep to, those the relation crosses neither way: transfers move between listed relata it relates one way or the other, and balance is kept on each listed relatum's closure under the relation and its converse among the listed relata, the least region holding it that the relation crosses neither way among them, membership a test |
| 18 | Low: the relation as a computable test is not named, and "an amount leaves a region only where…" holds of the transfers, not of amounts in general | The hypothesis named; the clause on leaving dropped, the sentence stating what the law states |

## After the findings

The scratch build of the leaf with every Lean change passed after the review and again after the re-check: 43 theorems in 48 declarations, every axiom report empty, no warning (`Becoming.BalanceRegions`, built alone on the shared cache). The eighth law runs to 466 characters, over the soft cap of 420 that warns and within the record's own laws, which run to 475; it states the join. The correspondence is within its cap. The texts were applied again from the claim base by the kit (`kit/apply_bd4.py`), the record's caps checked by it. The research check on the branch reports only the expected failures of a receipt not yet run, and the lint only lengths that warn.
