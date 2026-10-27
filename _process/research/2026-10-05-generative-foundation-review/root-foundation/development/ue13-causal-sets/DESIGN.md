# UE13: causal sets, and what can be born next against what continues (design)

28 October 2026. AI-written design for board item UE13 (UE plan item 6). It states the question, the reading, the laws planned and what they would forbid. The [working notes](NOTES.md) list the sources read and the candidates set aside.

## 1. The question

Causal set theory takes spacetime to be a locally finite partial order (Bombelli, Lee, Meyer and Sorkin 1987; Surya 2019 reviews the programme). The order stands for causal precedence and local finiteness for discreteness. Its classical sequential growth dynamics (Rideout and Sorkin 2000) grows a causal set one element at a time. Each new element is born maximal, with a past that is a down-set of the existing set, so a birth never puts the new element below an existing one. Rideout and Sorkin call this internal temporality, and they take birth order to carry no physical meaning (discrete general covariance).

The root's precedence is the reach of the condition relation, `«及» R`, and it is an order exactly where the net has no cycle (`«无环则及为序»`, `«缘先果后当且仅当无环»`). The plan's item 6 asks:
- whether the root's laws hold on causal sets, so that a causal set is a case of the grammar;
- what continuation relative to a class adds to an order: patterns that last, on spacetime read as order.

A third question joins plan item 7. What can be born next is the adjacent possible read on causal sets. Kauffman's tentative fourth law has a biosphere enter its adjacent possible, on average, as fast as it can sustain (*Investigations*, 2000, pp. 22 and 209, read through two reviews). Can widening what can be born next be the direction a reading of 生生 takes?

## 2. The reading

- **A causal set read through the root.** A labelled causal set of `n` elements is a precedence on `0, …, n - 1`. It is irreflexive and transitive, and each element is preceded only by smaller labels (natural labelling). Its links are the pairs with nothing between, and the root's net is the links, so precedence is their reach.
- **Sequential growth as a process.** A configuration is a finite labelled causal set. A move chooses a down-set `D` of the elements (a stem) and adds the element `n` with past `D`, so `n` is preceded exactly by `D`. What can be born next from a configuration is its stems: UE10's `adm`, one child for each stem.
- **No probabilities.** Transition probabilities, Bell causality and discrete general covariance are not read. The laws hold on every course of the growth, so every dynamics on it inherits them.

## 3. Laws planned

**A. Precedence is the reach of links where the order is discrete.**
1. For any relation `R`, a link of `«及» R` is a step of `R`.
2. On a finite labelled causal set with decidable precedence, precedence is the reach of its links. The proof is induction on the gap between labels, with a bounded search for an element between.
3. Witness: on `ω + 1` (`Option Nat`, every number below `none`), `some 0` precedes `none`, but no link ends at `none` and the reach of the links never reaches it. An order that is not locally finite need not be the reach of its links: reading precedence as the reach of conditioning needs the discreteness causal set theory assumes.

**B. Growth holds the past.**
1. Every move keeps the precedence among existing elements and makes the new element maximal. Internal temporality is a holding premise in UE11's sense: the possible with the past held is the whole possible.
2. Every stem stays a stem, and the stem of all elements is new after each birth, so on every course what can be born next keeps widening (UE10's `KeepsWidening`).

**C. What can be born next is the converse of precedence.**
1. For two configurations of one size, every stem of the first is a stem of the second exactly where the second's precedence is included in the first's. One direction takes the principal down-set; the other is closure under the larger precedence.
2. So of two courses from the empty set, one includes the other's stems at every offset exactly where its precedence is included in the other's at every offset. It exceeds the other where the other has a precedence pair it lacks, and only where some offset's precedence is not included.
3. Continuation within the one class is precedence (`«相续» R «一»` is `«及» R`, the links' reach by A2). So widening what can be born next never adds continuation within the one class. It adds no continuation of any class read on precedence either, where continuation is precedence within the class. Read on links, a finer class can gain continuation by widening: dropping an element of another class from between two of one class makes them linked. A witness shows it, so for finer classes read on links the two are independent.
4. The course in which every birth has the empty past includes the stems of every course, and widens those of every course with a precedence pair. In it nothing continues in any class, on either reading: every element begins and ends (`«生»`, `«亡»`), and none abides (`«住»`). The course in which every birth is above all has stems included in every course's, and in it every element after the first abides in the one class.
5. Hence no course widens what can be born next while continuing more within the one class. Two courses compared by both have the same precedence at every offset.

## 4. What it would forbid

- A reading of 生生 as widening the adjacent possible alone. On causal-set growth it ranks highest the course in which nothing continues, and every widening is a loss of precedence.
- A reading as continuation alone. It ranks highest the single chain, in which nothing can be born beside anything.
- So on spacetime read as growth of order, 生生 is a maximum of neither. Any order on courses that ranks a widening above the precedence it loses is a premise beyond the continuation condition, and calling widening better (C) would sit there. This is a witness for the second-order direction 07 leaves open, not a law of every process.

Causal set theory leaves the ranking of courses open, so none of this corrects it. It is what its growth carries for the theory's direction, and it meets Kauffman's fourth law on a model where that law can be stated exactly.

## 5. Modelling choices

Configurations are finite and labelled. Precedence is Prop-valued, and A2 asks for it to be decidable. Comparisons are pointwise: function extensionality would bring `Quot.sound` into the axiom report. Infinite causal sets are read only as courses. Counting stems (a chain of `n` has `n + 1`, an antichain `2^n`) is not needed, since inclusion carries the laws.

## 6. Shape and standing expected

A module `Becoming.CausalGrowth` (namespace `CausalGrowth`), a leaf at L1 importing `Becoming.ReachableRanges` and `Becoming.HeldPossible`, pure core. Near-definitional laws and witnesses: C1 is the order-reversing correspondence between finite orders and their down-sets, known in order theory. What is new is reading it on the growth dynamics against the theory's direction.

## References

- L. Bombelli, J. Lee, D. Meyer and R. D. Sorkin, Space-time as a causal set, *Physical Review Letters* 59 (1987) 521–524.
- D. P. Rideout and R. D. Sorkin, A classical sequential growth dynamics for causal sets, *Physical Review D* 61 (2000) 024002, arXiv:gr-qc/9904062.
- S. Surya, The causal set approach to quantum gravity, *Living Reviews in Relativity* 22 (2019) 5, arXiv:1903.11544.
- S. A. Kauffman, *Investigations*, Oxford University Press, 2000; the fourth law's wording as two reviews report it (the *Zygon* review and the *Times Higher Education* review), not read in the book itself.
