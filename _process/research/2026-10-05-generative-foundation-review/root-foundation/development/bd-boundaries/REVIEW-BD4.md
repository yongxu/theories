# BD4: the independent reading

1 November 2026. Board item BD4, balance on each closure, the `«所闭»` form: `Becoming.BalanceRegions`, BD3's core leaf, extended ([the board](../../../../../BECOMING-WORKBOARD.md), [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md) lever 1 (a), [the design](DESIGN-BD4.md)). Reading time: about five minutes.

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
| 5 | At the unit grain, "each closure" must cover every relatum, listed or not, or it is false (`us = []`, `[5]`, `[6]`) | "the closure of each relatum, listed or not" in the module, the root bullet, the scope and both READMEs; an unlisted relatum's closure is itself alone (`closureListed_unlisted`). The law states the join, whose units stand only on listed relata |
| 6 | The literature is right with two qualifications: undirected only, and Hoffman through the reduction to a circulation | "the uncapacitated, undirected case" in the item on capacities, the module, the root bullet, 01, the correspondence, the design and the study; Hoffman named through the usual reduction |
| 7 | Docstring precision: the counting bound's stalling step can be the `(k + 1)`-th, and only `k + count₀ ≤ count_k` is stated; `reachedListed_stays` not cited; the bullet without decided equality; the web form's sentence without a main verb | Each docstring restated to its statement; the citation, the hypothesis and the verb added |
| 8 | The test is exponential: each step re-reads the step before at every listed relatum | Kept, and said: the test is built to decide, not to be evaluated (the definition's docstring, the design, the study). A version carrying the relata reached so far would evaluate in polynomial time with the same proof shape; nothing here evaluates the test |
| 9 | Placement and names: the counting lemmas and `paired_single` are laws of `«计»` and `«对»`, candidates for GrammarLaws; `conserved_peel` is a metaphor | Named as candidates for GrammarLaws at its next planned near-full rebuild, OU's owner's call (the design, the study); `conserved_peel` renamed `conserved_of_fewer` |
| 10 | Wording: the study's supplied premises ignored the general unit law's hypotheses; "each case split" too narrow; the hypothesis sentence belongs in `hypotheses`, and an instance supplied at use carries its own report; the Chinese law had no subject | The supplied premises name symmetry and the decision; the self-review says no proof splits on an undecided proposition; the first hypothesis names decided equality a modelling hypothesis, and the scope says only what the reports cover; the Chinese law restated with the join, its subject the transfers |

## After the findings

The scratch build of the leaf with every Lean change passed: 43 theorems in 48 declarations, every axiom report empty, no warning (`Becoming.BalanceRegions`, built alone on the shared cache). The eighth law runs to 458 characters, over the soft cap of 420 that warns and within the record's own laws, which run to 475; it states the join. The texts were applied again from the claim base by the kit (`kit/apply_bd4.py`), the record's caps checked by it. The research check on the branch reports only the expected failures of a receipt not yet run.
