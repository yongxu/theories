# BD3: the independent reading

1 November 2026. Board item BD3, balance region by region on the root: `Becoming.BalanceRegions`, a core leaf reading `Becoming.Continuity`'s closed families on the grammar's `«不出»` ([the board](../../../../../BECOMING-WORKBOARD.md), [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md) lever 1 (a)).

## The reading

One independent AI reader (a fresh Claude Opus agent, read only, with no part in writing the leaf) read the change as one commit (`fd56facc6`, branch `bd3-regions`), the Lean it builds on (`Becoming.Continuity`, `Becoming.GrammarCrossing`, `Becoming.GrammarLaws`, `Becoming.Grammar`) and the repository's rules. It was asked to check five things:

1. that every text (the module's docstrings, the record's law, the home sentence, the root module's bullet, the checker's scope, both README rows) claims exactly what the Lean proves, with every hypothesis named;
2. that the module's "What is not shown" is true and correctly put;
3. the names, and whether an existing declaration already states one of the results;
4. that the Chinese says what the English says;
5. anything the checker or the repository's checks would fail.

It found two errors (a layer tag, and two docstring sentences that overclaimed) and precision fixes. It found no duplicate, the names fine, and no check that would fail. Every finding is taken:

| # | Finding | Taken |
|---|---|---|
| 1 | The layer tag L2 is wrong: L2 needs `Unrestricted` or `Valuation` in the module or its import closure (`r31-support/layers.py --list`), and the leaf has neither | L1 in the root module's bullet and both README rows |
| 2 | `balancesOn_iff_notGoingOut`'s docstring named the routed transfers, which its statement, an existence, does not; it omitted decided equality and the listed relata | Restated as the statement says: transfers between adjacent listed relata at each step, read as a flow, balancing the levels at every step exist exactly where the levels are conserved on every region not gone out of |
| 3 | "on the regions the relation does not cross" overstates: crossing goes one way, and a relation from `a` to `b` never crosses `{b}` while balanced transfers raise its total | "on the regions the relation crosses neither way among the listed relata", in the module and the study |
| 4 | "not gone out of along it" reads as along the relation, where the same counterexample breaks it | "along that adjacency" |
| 5 | Exactness comes from symmetry as well as from membership being a test: symmetry alone for closedness, symmetry with stable membership for not going out | The docstrings give both reasons and cite the laws |
| 6 | "nor come into" was stated by no declaration | `Continuity.closes_iff_notComingIn` added, through `«对称则不出当且仅当逆不出»`; the seventh law names it |
| 7 | "What is not shown" is true but badly put: a region not gone out of already holds its members' closures (`«闭含所闭»`, `«所闭之自反»`), so it is their union, with no finiteness needed; what is missing is each closure decided as a test among the listed relata, and a total summed over the closures | The sentence restated so in the module and the root bullet; one item on what is not shown in the record |
| 8 | 01 §8.4's sentence omitted that membership is a test | Added, and the sentence states the existence as the theorem does |
| 9 | `balancing_iff_notGoingOut`'s docstring omitted decided equality | Added |
| 10 | The checker's scope said "a family a Bool relation closes" | "a family, a Bool test, that a Bool relation closes" |
| 11 | regions.json's note used "=" for equivalences | "iff" |
| 12 | No duplicate; the case split in `closes_iff_notGoingOut` re-proved `GrammarLaws.uncrossed_of_closed` together with `«不外者内则不出当且仅当闭»` | The proofs now go through those laws: `closes_iff_closed` by `uncrossed_of_closed` with the adjacency's symmetry, `closes_iff_notGoingOut` from it by `«不外者内则不出当且仅当闭»`, membership stable as a test; a dependency on master-laws-on-the-grammar for the first |
| 13 | The names are structural and exact; the glossary's "family" (同族) and Continuity's family, a test (家族), differ, a clash older than this item | New prose says "region" except where it names `Continuity.Closes` |
| 14 | The Chinese matches; two tweaks | The history's 即 made 恰是 (an equivalence); README.zh's 无重复 made 不重复, as in the record |
| 15 | No check fails; any docstring fix changes the leaf's hash | The record's reference rehashed to the revised leaf before any run; the landing checks the receipt's hash against both |

The revised leaf builds clean in scratch: 6 theorems in 7 declarations, every axiom report empty.

## What the reading did not cover

The receipt, the connectivity register and the rendered pages, which the landing writes; the rehearsal runs them before the slot.
