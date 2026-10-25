# OU3b: the master laws on the grammar

Board item OU3b, a sub-item of OU ([plan](../one-unfolding-root/PLAN.md) §八 step 4, «五条主律……与 EC 之主商定之后再提»), taken with EC's measure ([EC plan](../ec-elegant-completion/PLAN.md)). AI-written design, 25 October 2026.

## What done means

[08 §6](../../../../../../theories/becoming/chapters/08-METHOD.md#expressible-is-not-derived) says a law passes to the root by three things: a dependency audit, a lifting (the law restated on the grammar with only what it uses), and a representation theorem (the model shown to be a model of the grammar both ways, or the failure written down). For each of the five master laws of [08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity), OU3b is done when:

1. **Lifting.** The law is a theorem of the grammar: for every carrier and every relation, in `Becoming.Grammar`'s vocabulary, pure core, every axiom report empty.
2. **Representation.** The master law's Lean anchor is shown pointwise equivalent to the grammar's term at the model's relation, with the hypotheses the equivalence needs stated, or a counterexample where it fails.
3. **Rule 9, where honest.** Where the model's law can be proved from the grammar's (the general below proving the special), it is; where that would only route a proof through the grammar to raise the measure, it is not, and the reason is written down.
4. **Measure.** The connectivity measure reports, for each of the 127 central declarations, whether it reaches the grammar, before and after.

## The five laws on the grammar (first design; the drafter may revise with reasons)

| Law | Anchor | On the grammar | Representation |
|---|---|---|---|
| Closure | `WithinClosure` (`Frame`) | `«所及» R «一»`: reached on a line under the one, i.e. equal or `«及» R` | `withinClosure_iff_reached` exists (`GrammarScope`), but above the models; move it below `Frame` |
| Balance | `Flow.Balances` | a one-to-one pairing between finite lists conserves their count: what comes in (before, given) is paired one to one with what goes on (after, taken) | every balanced flow is a census whose units are paired one-to-one, and every such census balances |
| Finite runs | `Law.lossless_iff_returns`, `Law.drawn_iff_not_returns` | for a functional total relation on a listed carrier: merging nothing (`R;R˘ ⊆ 静`) exactly where every occurrence reaches itself (`«及» R x x`); for every relation, an occurrence with a successor is drawn into a region closed under it exactly where it does not reach itself | `Law.process next` as the relation `next x = y` |
| Lumping | `GoAlikeUnder` (`Laws`) | `E` goes alike under `R`: `R˘;E;R ⊆ E`, with its links to `«有常»` (determined, total) and the lines it keeps alike | `GoAlikeUnder P π E` is that at each move with `E` pulled back along `π`, with no hypothesis |
| Order | `Web.Widens` (`Regions`) | widening of relations: `S ⊆ R` and not `R ⊆ S`; strict, transitive, retaining and adding; mixed and kept | `Web.Widens l l'` is widening of what the two level paths admit |

## What this does not do

- It adds no premise. Counting enters only through finite lists, as it does in the models; the grammar's own statements stay pointwise, with no `propext` or `funext`.
- Balance on the grammar is near-definitional: a level changes by what is given and taken exactly where what comes in (before, given) is paired one to one with what goes on (after, taken), the pairing supplied, not derived from the unfolding. The record says so. *(Revised 26 October 2026 after review: the first wording read the pairing as continuation, which in the grammar is «续»; the landed design is in [OU3b2-NOTES](OU3b2-NOTES.md) and [AUDIT](AUDIT.md).)*
- The rule-9 refactors of shared modules (`Frame`, `Attraction`, `Recurrence`, `Laws`, `Regions`, `Flow`) are a second step, OU3b-2, decided module by module, since each has dependents.
