# Review of PLAN.md v9: general (GPT astra, high effort, read-only)

23 October 2026. Brief: [BRIEF-v9.md](BRIEF-v9.md). Run with `cx --fresh --sandboxed -m astra -e high` (session 01a16534-eca6-7a63-9a3f-ce4f480ca890, 219 s, 824.8k tokens). Text as returned, footer removed.

---

**1. Verdict**

Version 9 is neither fully monist nor formally sound as stated. Its relational algebra is a credible foundation for further work, but universal quantification does not establish relational individuation, and several proposed interpretations exceed their definitions: temporal order, whole states, higher-order continuation, empirical discrimination, and 生生. The classical passages support more qualified readings than the plan gives them. I compiled the three cited review checks without creating files; the countermodels below are analytical review tests, not newly certified Lean results.

**2. Findings, most serious first**

1. **§§2, 4.1 — *dualism / overclaim*.** “先有载体，再有关系” is called intrinsically dualist, while “位是什么，完全由它的全部关系决定” supposedly resolves this through 核. Quantifying over every carrier still uses carriers; it does not derive their elements. Moreover, 核 tests forward behaviour relative to supplied E, not “全部关系”: terminal occurrences with different incoming relations can be bisimilar. It is the **largest** admissible bisimulation, not the finest distinction.  
   **Fix:** distinguish representational parameters from ontological commitments; specify which relations individuate occurrences and what quotienting forgets. Present 事 as relational positions at a stated resolution. An asymmetric relation need not imply independent cause/effect substances.

2. **§4.3 — *overclaim*.** “判据不能任意” is not secured by requiring an equivalence E and `续 ⊆ R`. With R universal, every equivalence E satisfies 有常, including contrived partitions; continuity and closure therefore cannot exclude arbitrary grouping.  
   **Fix:** retain `R ∩ E` as **continuation relative to E**, explicitly allow formally admissible but explanatorily poor E, and assess criteria through relational provenance, predictive performance and robustness. 有常 establishes compatibility with dynamics, not the warrant for a distinction.

3. **§§4.1, 4.3, 6 — *formal error*.** “时是缘的传递闭包所给的先后” and “整体之态与整体之步是缘网的切面” overstate what an arbitrary relation provides. A two-cycle gives precedence both ways and self-reachability. Incomparability does not establish simultaneity. Causal precedence alone also does not distinguish concurrent events from incompatible alternatives.  
   **Fix:** call the general construction reachability. Derive temporal order under explicit acyclicity assumptions, or describe the information lost by collapsing strongly connected components. Define configurations, compatibility and cuts before claiming state reconstruction.

4. **§§4.6, 7 — *hidden layer*.** “一条细续在粗网中是一事” does not follow from `L;R;L`. This is a saturated relation on the original carrier; even its quotient has L-classes as nodes, not continuations. Branching continuations can overlap, so an equivalence cannot automatically collect them into separate events. “其缘决定细网中哪些续得生、得存” consequently risks restoring a governing upper level.  
   **Fix:** define the relational representation of a continuation, its coarse incidence and the abstraction correspondence. Demonstrate how coarse descriptions and fine histories constrain each other; retain any directional dependence as a property within that correspondence.

5. **§4.3 — *formal error*.** “生、存、变、亡……四个位置” is not what the definitions encode. 生、亡、住 are node predicates; 异 is an edge predicate with an additional F. An isolated occurrence is both born and dead; change can coexist with persistence. The excluded-middle equivalence concerns `¬有前 ∨ 有前`, not four-way classification or simultaneity.  
   **Fix:** describe overlapping boundary, interior and change predicates, type them explicitly, and require `F ⊆ E` when F is called finer. Keep the EM calibration separate from “四相俱时”.

6. **§§4.2–4.3 — *formal error*.** “无穷迭代（传递闭包；不尽之进程）” conflates finite reachability with endless continuation. The inductive 相续 has finite witnesses. Separately, “某分别之亡即其补之生……无前提” overstates the cited old result: `Change.CeasesToBe.not_comes` supplies one implication; the converse explicitly needs double-negation stability. Node termination is also different from a predicate changing across a step.  
   **Fix:** separate finite closure, absence of terminal nodes and infinite runs; report any choice principle needed between them. Preserve the old theorem’s direction and hypotheses, and prove a new correspondence before transferring it.

7. **§§4.6, 7 — *overclaim*.** “为他续之生之缘者，属生生” does not distinguish life-supporting generation from destructive turnover. With E universal, 复生 is impossible: its R-edge already gives its target a predecessor. With E equality on an irreflexive graph, every node is born, and every node with an outgoing edge is reproductive.  
   **Fix:** index source and target continuations and their criteria explicitly. Define disjoint reproductive/non-reproductive termination predicates over the same history and quantifier domain. Call this causal renewal until additional content warrants 生生; non-overlap alone supplies no ethical distinction.

8. **§§3, 4.4 — *overclaim*.** “两种机制可分，当且仅当……它们不互拟” identifies empirical distinguishability with a stronger structural comparison. Non-bisimilar systems can have identical accessible observations; adding arbitrary edges can also erase distinctions. A “更宽的关系” does not specify which conditions are admissible, observable or causally changed.  
   **Fix:** represent observations, admissible contexts and evidence-producing interactions within the same unfolding; define testing equivalence there, then establish its relationship to bisimulation under stated assumptions. Likewise, describe closure as relational quotient compatibility; probabilities are absent, so the Kemeny–Snell and computational-closure identifications still require correspondence arguments.

9. **§§1, 5.2 — *textual error*.** “古文已经这样说” treats textual affinities as the proposed temporal construction. In `FO2-QX.txt`, “以四相俱時而有皆無自立” belongs to the discussion of awakening and “本來平等同一覺”, not four successive positions. The lion’s 成/壞 concerns aggregation and constituents retaining their positions. The selected *中论* chapters challenge independently established movement, production and destruction; they do not establish the proposed positive calculus.  
   **Fix:** label these as qualified AI reconstructions and record the differences. The fire-transmission quotation matches `ZH1-S03.txt`; Xunzi matches with script conversion; all six cited Mohist definitions occur. However, `M.html` is **經上**, not also 經說上, so the corpus registration is incomplete.

10. **§5.4 — *textual error*.** “理事两层” and “一个在上的根据” prejudge contested readings. The annotated lion text also says “理事鎔融”; the *起信论* says “是二門不相離” and “非一非異”. The quoted gold/nature explanation is commentary and must be attributed accordingly. Conversely, merely registering two truths as domains omits their epistemic and liberative asymmetry. Momentariness is not equivalent to discrete time.  
    **Fix:** register both nonseparation and grounding claims, distinguishing commentary from base text. Include the relevant chapter-24 two-truths passage explicitly beyond the selected four chapters. Treat momentariness and temporal discreteness as separate commitments. Remove the candle example’s unsupported identification with 等无间缘; the cited *中论* discusses mental succession under 次第緣.

11. **§§3, 11, 13 — *overclaim*.** “甲、乙之分由 Lean 来定……不凭判断” exceeds proof checking. Lean can check a supplied derivation; it cannot decide historical definitional intent or generally settle definability. Definitions do not establish indispensability, and conditional laws do not automatically establish explanatory minimality.  
    **Fix:** separate philological judgments, encoding choices and checked implications. Specify competing languages, deletion criteria, coding costs and reconstruction fidelity. MDL plus Pareto reporting is useful evaluation, not a proof of a universal minimum.

12. **§4.6 — *overclaim*.** “只有有限分支时‘极限即核’蕴涵 LLPO” leaves the cited check’s dependencies unstated. Compilation reports `propext` and `Quot.sound` for both `HM.limit_gives_llpo` and `HM.every_stage`.  
    **Fix:** report these as constructive peripheral results that currently fail the stricter empty-axiom requirement. State the semantic boundary: matching every finite depth need not construct one coherent unbounded matching.

**3. What is already sound**

`Root.lean` and `PointFree.lean` compile with empty reported axiom dependencies. By inspection, continuation inclusion, coarsening, `续 R 一 = R`, the proposed EM equivalence, and equivalence-E closure characterization are sound candidates. The finite-fire correction is right: successive flame occurrences can fail bisimilarity. Forking can make symmetrized ancestry non-transitive, although genuine equality remains transitive. Distinguishing continuation from bisimilarity, retaining failed readings, and declining mathematical novelty are substantial improvements.

