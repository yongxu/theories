# KS: one independent reading

*AI-written (3 November 2026), board item KS. Reading time: about 5 minutes.*

KS corrects places where the text said less than the Lean proves, which KD's refuters and readers found in passing ([KD's study](../kd-known-results-debts/DEBTS.md)). The change is made by [kit/apply_ks.py](kit/apply_ks.py). One AI reader that did not write the change checked it against the Lean, the records and the literature it knew, in two passes. Every finding was taken: [kit/revise_r1.py](kit/revise_r1.py) and [kit/revise_r2.py](kit/revise_r2.py) revise the script, which was then rerun on clean files.

## First pass

- **04 §4.** `Breeding.one_amount` proves the identity of covariance and spread and its bound, not the mean's rise. The citation now names `breeding_balance` for the identity and `response` for the rise under exact transmission, with `one_amount` the single-pair case.
- **04 §5 (Hamilton's rule).** `rises_iff_reading` holds on any list. With a member's group total as the reading and *k* = *b* + *c*, it gives the whole's verdict through that covariation for groups of any sizes, but not the verdict through the spread among groups, which needs equal sizes. The first draft's "the whole's verdict holds for groups of any sizes" invited that reading, and it dropped "where the amount varies". Both are now qualified.
- **04 §5's limit.** The first narrowing, "nor the split within and among groups of unequal size", still said less than is proved. The split weighted by size is `levels_sized` and `rises_iff_sized` (04's selection within and among groups of any sizes). Within groups, the returns need no equal sizes (`within_returns`, `within_kept`). Only the among-group laws and the laws in spread form take `equal`. The home, the record's does-not-show, its next delta and 04's open list now say so.
- **03.** "A method for every such union" over-claimed. Every reading of runs is a union of closed readings, and recurrence, which 03's own witness shows no method verifies, is one of them. The classical converse holds for countable unions (the Σ⁰₂ readings). 03 and the record now say "countable" and credit "Kelly 1996, after Putnam 1965 and Gold 1965". The record's does-not-show item 3 follows, with a history note.
- **zh.** The history lines now quote the section names (“未表明”, “下一步”).

## Second pass

Every fix now says what the Lean proves. Two qualifiers were added. `one_amount` covers a rising line, and that every reading of runs is a union of closed ones holds classically.

## Out of scope, passed on

shaping-selected-among-groups lists "Groups of unequal size" as not stated, although `rises_iff_reading`, read with *o* = *s*·*a* + *q*·(group total), would give that whole's verdict too. That is a reading, not a stated instance, so it is left to the record's owner.
