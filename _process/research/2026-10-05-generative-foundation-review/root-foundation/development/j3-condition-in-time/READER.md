# J3: the cold read

AI-written, 9 November 2026. One AI reader of another model, Claude Fable, read the material cold, for overclaim and underclaim, read-only. The material was `Becoming/ConditionInTime.lean`, the three records (`the-condition-in-time`, `what-the-one-center-bound-counts`, `a-line-alive-after-a-window`), 07 §4.11 and this folder's NOTE §3–§5. The reader did not build: the author's scratch builds are the evidence. No person's review is recorded.

## Round 1: findings, and what was done

| # | Severity | Finding (the reader's, summarized) | Done |
|---|---|---|---|
| 1 | high | 07's closing paragraph said "read over what comes after its step, the condition is mutual dependence in time". In the section, "the condition over what comes after" names `«续无外于后»` = `UnrestrictedAfter`, and `RingOfThree.apart` shows that form fails where mutual dependence in time holds. | Reworded: "the condition read *from some step on* is mutual dependence in time …; read *over every later step* it is coupling at every next step, which is stronger". |
| 2 | medium | "Both conditions hold … the condition holds in time" (07, module docstring) for `Recurring.inTime`. The condition over every step fails there. | "Both restricted forms hold … the condition over every step does not", in 07 and the docstring. The record's law 4 now reads the same. |
| 3 | medium | The record's does_not_show and NOTE §3 said the all-steps condition fails "wherever there are two formations". That is understated, and was argued, not proved. | New theorem `Flow.not_unrestricted_inTime`: held de se in time at every occurrence, the condition over every step fails wherever there is a formation (`(1, f)` does not reach `(0, f)`). It is cited in 07, in the record (law 2 and the does_not_show witness) and in the NOTE. |
| 4 | medium | "The one-center bound rests on the second part" was argued, not proved. Also, `«续无外则同一中心»` needs only no cycle, while the split needs a step grading. | New theorem `«独则同一中心»`: the second part alone gives one center, with no net. 07, the record's law 2 and NOTE §4 now say: the second part alone gives one center, and the first does not (`TwoSources.apart`); `«续无外则同一中心»` holds on every net without cycles, and the split is stated for nets whose conditions come at earlier steps. |
| 5 | medium | Descent was missing from the law lists of `Flow.member_after_never_overdrew` (record law, docstring, 07). | Added "descent" to all three. |
| 6 | medium | 07's closing list of readings left out the restriction to what comes after. | Added: "which restriction to what comes after is the condition in time". |
| 7 | low | "It has no cycle, so no occurrence returns". No cycle gives returning = sink; it is the going on that leaves no sink. | "It has no cycle and every occurrence goes on, so none returns", in 07, the record and the docstring. |
| 8 | low | `MutuallyDependentFrom` is `∃ u`, and `u = t` serves for `g = f`. | "reached at that step or a later one". |
| 9 | low | Drawing: the taking, not the requiring, is at the first step only. | Reworded. |
| 10 | low | `admits_unreached_before` shows a part's acts show nowhere without the link. It does not show that every link has effect. | "the link without which a part's acts show nowhere at a later step". |
| 11 | low | Docstring: "time gives nothing" at the returning occurrences. | "the condition in time is vacuous". |
| 12 | low | The record's statement lacked "exactly" for the every-later-step form. | Added. |

The reader's answers to the brief's questions:

- The dated counterpart of `Flow.mutuallyDependent_iff_unrestricted` is fair, provided two differences are shown at the sentence. The relation adds the going on, and the condition is a restriction. Both are now said in 07 at the theorem.
- Nothing reads as a claim about actual systems or about ethics.
- The hypotheses match the Lean, apart from finding 5.

After the corrections the module has 50 theorems and 72 declarations, every axiom report empty (scratch build).
