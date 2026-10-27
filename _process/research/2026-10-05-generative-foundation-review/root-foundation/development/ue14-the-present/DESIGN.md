# UE14: the present on causal-set growth, and what of presence is the same on every course (design)

28 October 2026. AI-written design for board item UE14 (the UE plan's structural gap of presence in time, §5). It states the question, the reading, the laws planned and what they would forbid.

## 1. The question

The root leaves one question open ([01, Open](../../../../../../theories/becoming/chapters/01-ROOT.md#open)): whether a condition must still be there when what it conditions arises is not expressible, since the grammar has no relation of presence in time, and adding one is a choice of model. The UE plan names presence in time, with self-changing conditions, as the deepest structural gap ([PLAN §5](../ue-unified-explanation/PLAN.md#5-the-structural-gaps)); UE11 took the self-changing half.

Causal-set growth ([07 §2](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-what-can-be-born-next), `Becoming.CausalGrowth`) is a model in which the question can be asked exactly. Each birth is an event of becoming, the past is held, and causal set theory's discrete general covariance takes the labels, the order of births, to carry no physical meaning (Rideout and Sorkin 2000). So the question becomes: which relations of presence are the same on every course growing a configuration, and which are a choice of course?

Two answers stand in the literature. Stein's theorem says that in Minkowski spacetime the only reflexive, transitive, nontrivial and nonuniversal relation of becoming kept by every automorphism is causal precedence. Wüthrich and Callender (2017) show that its analogue fails for a single causal set: on four elements with two unrelated elements of one profile, a relation adding that pair to precedence is kept by every automorphism. They read the kinematic present as a maximal antichain, which is not invariant, and propose a global becoming in which only the number of elements is determinate. Dowker (2014) and Sorkin read the partially ordered birth process as passage, with an asynchronous multiplicity of nows.

## 2. The reading

A course of the growth from the empty set gives its configuration a natural labelling: each element is born after everything it is preceded by. Read the other way, a renumbering of a causal set's elements that keeps precedence is the order of births of another course growing a configuration of its kind. The covariant content of a course is what every such renumbering keeps.

The core already proves the order-theoretic part. `Becoming.OrderNormal` states, for the exchanges of a stretch and any symmetric joining, that the renumberings reached by commuting consecutive exchanges not joined are exactly those keeping the order joining gives (`sorts_by_iff`), and that two arrangements are reached from each other exactly where they orient every joined pair alike, Mazurkiewicz's theorem with no decision (`rearranges_iff`). Read on growth with joining as precedence either way, this says that births of unrelated elements commute and only they. UE14 instantiates these laws; it does not reprove them.

## 3. Laws planned

A leaf at L1 importing `Becoming.CausalGrowth` and `Becoming.OrderNormal`, namespace `Presence`, pure core.

1. **Natural labellings.** A renumbering of a causal set (`Reindexes 0 n π σ`) that keeps precedence (`KeepsOrder`) gives a causal set of its kind (`Kinds.Relabels`), and every causal set is the configuration of a course from the empty set (`grown`, each element's past as given).
2. **Births of unrelated elements commute, and only they.** Any two natural labellings are reached from each other by exchanging consecutive births of unrelated elements (`rearranges_iff`, `sorts_by_iff`).
3. **A down-set first.** For a decidable predicate on the first `n` numbers, the stable partition (its elements first, each part in label order) is a renumbering; where the predicate is closed downward under a naturally labelled order it keeps the order. This is the one new construction: counting, its discrete intermediate values, and the inverse found by `firstWhere`.
4. **What a stage can have born.** With precedence decided, the elements a course has born after `t` births are exactly a down-set of `t` elements, a stem in Brightwell and others' sense, and every such down-set is what some course has born after `t` births.
5. **Precedence is the order of birth every course agrees on.** With precedence decided, `i` precedes `j` exactly where `i` is born before `j` in every natural labelling: Szpilrajn's theorem read on growth, the counterpart there of Stein's theorem.
6. **Presence of a condition when what it conditions is born.** Say `i` is present at `j`'s birth in a labelling where `i` precedes `j` and nothing `i` conditions is born before `j`, so that `i` is on the frontier when `j` is born. With precedence decided, `i` is present at `j`'s birth in some natural labelling exactly where it conditions `j` directly (a link), and in every natural labelling exactly where everything it conditions is `j` or above `j`.
7. **Witnesses.** On three elements, `0` below `1` and `2`, `0` is present at `2`'s birth in one labelling and not in the other. On Wüthrich and Callender's four elements (`0` below `1` and `2`, both below `3`), precedence with the pair `{1, 2}` and the diagonal is reflexive, transitive, neither trivial nor universal, kept by every automorphism, and not the reflexive closure of precedence: invariance under automorphisms does not single out precedence, while agreement across the growth's labellings does (law 5).

Calibrations only where a need says something about the unfolding: for example, whether law 5 or law 6 without decided precedence is excluded middle, which would say that telling the present's bounds is settling which conditions are direct.

## 4. What it would forbid

- **No relation of presence beyond precedence is a relation of the unfolding on a covariant growth.** Presence on the frontier at a birth is a choice of course; what every course keeps is precedence, with the two bounds of law 6, both relations of the condition relation the grammar already states. The grammar's lack of a relation of presence in time is then what covariance asks of it, not an expressive failure, in this model.
- **Rankings of courses read on a present are gauge.** UE13's order on courses is labelled (`Kinds.wide_swapped_mixed`). Calling widening better (C) read on courses ranks the same thing on every course only where it is read through precedence or the two bounds; any reading of 生生 on a present is a choice of course.
- To check honestly: whether causal set theory states law 6's bounds. If it does, the containment restates and the record says so.

## 5. Modelling choices

Finite labelled causal sets with decided precedence, discrete births, natural-number labels; covariance read only as relabelling. Transition probabilities, Bell causality, the continuum limit and infinite causal sets are not read. Presence is read as being on the frontier at a birth; presence of a center, and continuous time, are not reached.

## 6. Shape and standing expected

Laws 1, 2 and 5 restate order theory (Szpilrajn 1930; Mazurkiewicz 1977) on the growth, with law 2 an instance of a core theorem. Law 3 is a lemma. Laws 4 and 6 are near-definitional consequences of law 3, and law 7 is witnesses. The standing expected is near-definitional: the gain is reading 01's open entry exactly in one model.

## References

- Rideout, D. P., and Sorkin, R. D. (2000). A classical sequential growth dynamics for causal sets. Physical Review D 61, 024002.
- Brightwell, G., Dowker, H. F., García, R. S., Henson, J., and Sorkin, R. D. (2003). "Observables" in causal set cosmology. Physical Review D 67, 084031 (arXiv:gr-qc/0210061): covariant measurable sets are generated by stem sets, proved for generalized percolation.
- Dowker, F. (2014). The birth of spacetime atoms as the passage of time. arXiv:1405.3492.
- Wüthrich, C., and Callender, C. (2017). What becomes of a causal set? British Journal for the Philosophy of Science 68(3), 907–925 (arXiv:1502.00018).
- Stein, H. (1968). On Einstein–Minkowski space-time. Journal of Philosophy 65, 5–23; Stein, H. (1991). On relativity theory and openness of the future. Philosophy of Science 58, 147–167. Read here through Wüthrich and Callender.
- Szpilrajn, E. (1930). Sur l'extension de l'ordre partiel. Fundamenta Mathematicae 16, 386–389.
- Mazurkiewicz, A. (1977). Concurrent program schemes and their interpretations. DAIMI Report PB-78, Aarhus University.
