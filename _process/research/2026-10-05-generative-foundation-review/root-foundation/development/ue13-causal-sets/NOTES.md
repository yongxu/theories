# UE13 working notes: sources and candidates

27–28 October 2026. AI-written working notes kept before the [design](DESIGN.md). Sources are paraphrased.

## Sources checked

- **Rideout and Sorkin 2000** (arXiv:gr-qc/9904062, *Physical Review D* 61, 024002). A transition adds one new maximal element. Its past is a finite down-set of the parent, which they call the precursor set. The new element is linked to the maximal elements of its past, so a child corresponds to an antichain of the parent. They name two extreme children: the timid child, above every element, and the gregarious child, related to none. The conditions on the dynamics are:
  - internal temporality: each element is born to the future of, or unrelated to, every existing one, never to its past;
  - discrete general covariance: the probability of a causal set does not depend on birth order;
  - Bell causality and the Markov sum rule.

  The general solution is given by couplings `q_n` with `t_n ≥ 0` (their equations 10 and 11). Transitive percolation is the case `q_n = q^n`, `t_n = t^n`; originary percolation is in a footnote.
- **Surya 2019** (arXiv:1903.11544, *Living Reviews in Relativity* 22, 5). A causal set is a locally finite partial order. The order is read as proto-causality and local finiteness as discreteness.
- **Varadarajan and Rideout** (arXiv:gr-qc/0504066). The general solution, including vanishing probabilities.
- **Kauffman 2000** (*Investigations*), as two reviews report it. Self-constructing systems may tend to increase the kinds of events that can happen next (p. 22), and a biosphere enlarges its workspace, the actual and the adjacent possible, on average as fast as it can (p. 209; on p. 22, as fast as it can sustain). A report of a 2002 talk says the law was not mathematized, since the possibilities cannot be listed in advance.

## The root

`«及» R` is the reach of the condition relation; `«无环则及为序»`; `«缘先果后当且仅当无环»`; `«相续» R E := «及» («续» R E)`; `«相续含于及»`; `«及之单调»`; `«有常则相续不尽»`.

## Candidates, and what was kept

1. **Precedence as the reach of links.** Kept (design A). A strict order is the reach of its links where it is locally finite. On `ω + 1` the links never reach the top. On the rationals the link relation is empty, but the pure core has no rationals and `ω + 1` suffices.
2. **Sequential growth as a process.** Kept (design B). Every down-set of the parent stays one in the child, since the new element is maximal. The child also has new down-sets, those containing the new element. So what can be born next widens at every birth on every course, while the whole possible narrows (UE11).
3. **The increment.** Not kept. The number of stems grows at a birth with past `D` by the number of stems containing `D`: by one for the timid child, and doubling for the gregarious one. From the empty set a chain of `n` has `n + 1` stems and an antichain `2^n`, and every causal set of `n` elements lies between. This needs counting in the pure core, and inclusion already gives design C.
4. **Widening against continuation.** Kept (design C) and sharpened. On labelled causal sets of one size, the stems are the converse of the precedence, so the order on courses by what can be born next is the converse of their precedence. On the gregarious course nothing conditions anything: every element begins and ends at once and none abides. On the timid course every element but the first abides. Read on links, continuation of a finer class is not monotone in precedence: an element of another class between two of one class takes their link away.
5. **Patterns that last.** Not kept for now. Posts, elements comparable to every other, occur infinitely often in transitive percolation (Alon and others 1994; Bollobás and Brightwell 1997). A probability-free form, that every element is below every element born after a later post, is near-definitional; it would join a later item on cosmological renewal.
