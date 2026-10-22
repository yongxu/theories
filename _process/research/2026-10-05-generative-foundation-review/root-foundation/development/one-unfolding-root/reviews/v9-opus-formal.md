# Review of PLAN.md v9: formal (Claude Opus 5.5 subagent, read-only)

23 October 2026. Brief: [BRIEF-v9.md](BRIEF-v9.md), formal angle (checks 1–4 and 7). Scratch Lean: [../review-checks/V9.lean](../review-checks/V9.lean) (copied from the reviewer's scratch; prelude only, every theorem with an empty axiom report, rechecked by the session). Text as returned.

---

**Formal review of plan version 9 (checks 1–4 and 7, monism throughout)**

## 1. Verdict

Version 9 is not yet fully monist, and its centre is not yet formally sound. Every sketched theorem in §4.3 is true, the equivalence in §4.4 holds, and the correction of "续之核" is right; all of these are machine-checked. But the reason behind that correction comes back one level up. A distinction that is 有常 never lets a continuation end. So "a continuation has its own 理 iff its E is 有常" excludes every pattern that ends, the plan's own flame and its 相须 repair included.

Three further problems:
- `续 := 缘 ⊓ E` over-generates on the plan's own two-candle example.
- Lean's identity of 事 still does work that the relations do not: it decides time and 生. So 事 stays partly atomic.
- The coarse net puts every fine continuation on a loop, which breaks the recursion. 验 and 有常 also read R as alternatives, while the 缘 net reads R as actual co-effects. That is a hidden second relation.

## 2. Findings

**F1 (formal error, the most serious).** §4.4: "续有自己的理，就是其分别有常、粗网闭合。" §4.5: "火之续有理，在“火”与“燃料”之合上".
- **What is wrong.** For any R and any E, symmetric or not, 有常 R E implies 有前 y → 有后 y (`steady_continues`). Apply 有常 to the pair (y, y), with the 续-predecessor as witness. So under an 有常 E, only an isolated occurrence (生 ∧ 亡) can ever be 亡. In the plan's flame f₀→f₁→f₂→灰, every 有常 distinction has an empty 续 (`flame_steady_empty`): fire alone, fire ⊓ fuel, any E at all. 相须 and 因于, defined through 有常 (合 E₁ E₂), fail the same way.
- **Fix.** Make the 理 of an E-continuation 核 R E. It always exists and is always 有常. What the theory then asks is how deep 核 R E is and how many classes it has; a flame's 理 is the split by remaining lifetime. E itself being 有常 becomes the special case of depth 0, and state as a theorem that such a continuation never ends. Restate 相须 and 因于 by comparing 核 R (合 E₁ E₂) with 核 R E₁ and 核 R E₂.

**F2 (formal error).** §4.3, correction 2: "“火传”与“一火灭、一火生”之分，在于前者的事是后者之缘（佛典称等无间缘）". Correction 4: "不以缘相连者，不得称续".
- **What is wrong.** §4.1 makes 缘 many-to-many ("缘可以是多对多的"). Then candle A's heat is among the 缘 of B's first flame, so A's flame continues into B under fire/non-fire, and B's first flame merges two 续-predecessors (`candle_splice`). More generally, any single 缘 edge becomes a 续 under some two-point equivalence (`any_edge`). "续含于缘" therefore rules out only edges that are not 缘; inside one net, E can splice freely. 等无间缘 is defined for moments of one stream, so it presupposes the 续 it is asked to ground.
- **Fix.** State "续 ⊆ 缘" as a necessary condition only. Let the grammar show the A/B case as a merge, the dual of fission (correction 3), and not decide it. If a sustaining sub-relation R′ ⊆ R is wanted, make it part of the stated criterion (R′, E).

**F3 (hidden layer: atomism of 事).** §4.1: "位的同一，就是关系上的不可分（有常之核，§4.4）".
- **What is wrong.** 核 looks only forward, while 生 looks at predecessors. Two occurrences can share a 位 while one arises and the other persists (`same_place_other_phase`). 亡 is invariant under 核 when E is an equivalence (`cease_invariant`). 生 is invariant only under a two-sided core, one that is 有常 for R and for 逆 R (`arise_invariant2`).
- **The deeper dilemma.** Under the two-sided core, two moments of a stationary process are one 位, yet time separates them (`stationary_one_place`). So 时 and the four phases individuate 事 by the carrier's `=`, not by relations. That answers check 2 in part: yes, an atomism of occurrences remains.
- **Fix.** Define 位 by the two-sided core. Declare carrier identity a model commitment, like discreteness. Mark each grammar predicate as either core-invariant or carrier-dependent; 时 is carrier-dependent.

**F4 (formal error).** §4.6: "一条细续在粗网中是一事；粗网之续是“续之续”。"
- **What is wrong.** Let L be reflexive and symmetric. Any 缘 inside an L-class puts both ends on a loop of L;R;L (`coarse_loop`). Then, under any reflexive coarse E′, that class can neither arise nor end (`coarse_no_arise_no_end`), and coarse time is cyclic. Making a fine continuation "一事" needs L to contain 相续 and be an equivalence. The equivalence closure merges the branches of a fission, which contradicts correction 3 (`fission_not_transitive`).
- **Fix.** Use the 缘 between classes, L;(R ⊓ ¬L);L. Name the coarse 事 a lineage (a connected component of 续). Require L;E′;L ⊆ E′, so that coarse predicates are predicates of classes.

**F5 (formal error).** §4.1: "时是缘的传递闭包所给的先后".
- **What is wrong.** The plan admits mutual 缘 (相须, 有无相生). A cycle x→y→x puts x before itself, so 时 is a preorder. Causal sets assume acyclicity.
- Whole states as cuts: down-closed sets are definable. Time-slices (maximal antichains) need acyclicity, and in infinite nets they need choice.
- **Fix.** Take 时 to be the strict part, and read cycles as 同时 clusters. Make acyclicity a 丙一 condition.

**F6 (hidden layer + formal error).** §4.4: "两种机制可分，当且仅当在那个更宽的关系下它们不互拟" and "不可识别，就是在一切可得的关系下互拟".
- **What is wrong (alternatives).** 有常, 核 and 验 read R's successors as alternatives (∀∃), but the 缘 net reads them as co-occurring actual effects. "开窗之后分开" is counterfactual. Event structures need a conflict relation (#) for this, and the plan has none, so possibility is a hidden second relation.
- **What is wrong (the iff).** Read constructively, 可分 should be positive: some finite stage separates the two. Then "可分 ⇒ 不互拟" holds (`within_stage`, Root.lean). "不互拟 ⇒ 可分" is Hennessy–Milner: it needs image-finiteness, and its limit form already implies LLPO (HM.lean). "可得" brings in an agent who obtains the relations.
- **Fix.** Make the 缘/alternative split explicit, as one relation with two readings or as a declared conflict relation. State the forward direction as a theorem and the converse as a calibration. Replace "可得" with "与之有缘".

**F7 (formal error).** §七: "二者是对同一缘网的两种读法，不重叠；“生成”不指任何新组织（只有为续之生之缘者）".
- **What is wrong.** 复生 depends on E. Under E = 一 it never holds (`rebirth_top_never`). Under E = identity and an irreflexive R, it holds iff x has any 缘-successor at all (`rebirth_eq_any`). So "any new organization" comes back. The two readings do not overlap only by definition (¬), and saying every case is one or the other is excluded middle. The scopes also differ: "在其亡之前或之时" ranges over every member of the continuation, "亡而不为任何生之缘者" over the last one, and under those scopes the two overlap.
- **Fix.** Require the begun continuation to 住 and to have 理 in F1's sense. Define 息 positively. Quantify both over the same 相续 component.

**F8 (hidden layer).** §4.6: "二阶是粗网之续，其缘决定细网中哪些续得生、得存（选择之被选择）". §七's 元吸引 repeats it.
- **What is wrong.** The coarse 缘 is E;R;E, which is derived from the fine R. "决定" reads it top-down, so the law-setting versus governed asymmetry returns.
- **Fix.** Make the second order 复生 relative to L;R: (L;R) x y ∧ 生 R E y. That is one relation read at two grains, with no "决定".

**F9 (formal error + overclaim).** §三 lists as class 乙: "四相俱时而有（四相是一条续的四个位置）".
- **What is wrong.** No statement is given.
  - 生, 住 and 亡 do not partition the occurrences, since an isolated one is both 生 and 亡.
  - 异 is binary, and its "较细之分别 F" lacks the hypothesis F ⊆ E.
  - Cyclic or two-way-infinite continuations have no 生 or 亡.
  - "不同区间" (the phases as different intervals) contradicts 俱時 (all at once).
  - The excluded-middle calibration itself is right (`phases_iff_em`).
- **Fix.** Prove ¬(生 ∧ 住) and ¬(住 ∧ 亡) constructively, and state the four-way split (生 only, 住, 亡 only, 生 ∧ 亡) only under decidability. Move "俱時" to the textual register.

**F10 (overclaim, the three minima).** §三: "一切系统所守之律 | 什么对一切系统成立？ | 乙".
- **What is wrong.**
  - Class 乙 holds in every relation model, so it is analytic and empirically empty. The source calls laws of every system the *strongest* claim.
  - The 立言 "可定义性" holds by fiat. The real test is adequacy, and F2 and F5 show the defined 续 and 时 fail it.
  - 立言 now uses 缘, which the source puts under 穷理. That is a disagreement with the source and should be stated as one.
  - 限 as a global Z cannot express constraints that arise and change.
  - MDL needs a fixed meta-language (for example Lean term size) and finite presentations; otherwise the invariance constant swamps the comparison of small grammars.
- **Fix.** Correct each point above.

**F11 (formal error).** §4.3: "某分别之亡即其补之生".
- **What is wrong.** A partition has no complement that is itself a partition. For a test p, x's p-continuation can end while its successor does not begin, because that successor has another ¬p 缘 (`end_not_beginning`).
- **Fix.** Restate it for tests: 亡 at x and R x y give only ¬p y.

**F12 (overclaim).**
- §4.4: "这是非确定情形下的 Kemeny–Snell 并类，也是 Rosas 等之“计算闭包”的关系形式". For an equivalence, E;R ⊆ R;E is exactly a bisimulation equivalence (Park, Milner). K–S lumpability is probabilistic, and Rosas's computational closure concerns ε-machines. Say "relational analogue, unverified".
- "形式审查 F2 的 (c)…去掉": F3 here and the earlier F2 (a) (ways given before the relation) remain.
- "都化入一个缘网", said of do(): see F6.

## 3. Already sound

Machine-checked, all with empty axiom reports:
- 续 ⊆ 缘; 相续 ⊆ 时.
- Coarsening, with 亡 and 生 carried down to finer E and 住 up to coarser E.
- 一's continuation is the whole 缘 net.
- Fission makes sameness non-transitive.
- "Every occurrence 生 or 有前, for every model" ⇔ excluded middle.
- For an equivalence E, 有常 iff E;R;E ⊆ R;E.
- The 核 counterexample for the flame.
- 相须 is symmetric and irreflexive.

Re-run with empty reports: `PF.carries_iff` and the Root.lean theorems. Also sound: depth as stage stabilization, the LLPO calibration, the absence of an outside intervener in 验 as wording, and 一 X 一 Y read as one relation.

**Machine-checked against hand-argued.** All 28 theorems named above compile with Lean 4.29.1 and print "does not depend on any axioms". I compiled Root.lean and PointFree.lean in place without changing them. Argued by hand: the cycle claim in F5, the Hennessy–Milner direction in F6 (resting on Root.lean and HM.lean), F8, the scope point in F7, F10 and F12.

**Scratch Lean file:** /private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/v9-formal-review/V9.lean (prelude only; every theorem in it has an empty axiom report). No repository file was edited, created, committed or deleted.