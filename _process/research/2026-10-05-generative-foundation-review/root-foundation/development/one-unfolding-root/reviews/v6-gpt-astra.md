# Review of PLAN.md v6: GPT astra (Codex, high effort, read-only, fresh session)

23 October 2026. Brief: [BRIEF.md](BRIEF.md), with the cross-model angle. Text as returned; the version reviewed is v6 (the link now points at the current plan).

---

**1. Verdict**

No. [Version 6](../PLAN.md) removes several explicit separations, but does not yet establish a fully relational foundation. Its central gap is between mathematical distinctions of the unfolding and relations that actually constitute parts, dependence, knowledge and reproduction. Several formal identifications also fail or lack necessary hypotheses. These are repairable; a carrier type and a relation are not intrinsically dualist. I read the entire plan and the relevant Lean definitions. This review is read-only; no new proof was machine-checked.

**2. Findings, most serious first**

1. **§4.4: “若各在对方的闭包中” — *formal error*.**  
   `Within E` relates **ways**, not readings; membership of one reading in another’s closure is undefined. Interpreting this as mutual inclusion, `E ⊆ Within F` and conversely, collapses the readings to the same stable relation rather than establishing reciprocal influence. `Frame.WithinClosure` instead closes a supplied relation by reachability. **Fix:** define a directed dependence relation between readings through admissible comparisons of the same unfolding, then define 相因 as reciprocal dependence or mutual reachability. State explicitly which. Symmetry of that predicate does not require equal causal contributions.

2. **§4.1: “关于世界，一条：有变。” — *dualism / overclaim*.**  
   The structure supplies distinguishable ways and a fixed binary possibility relation; it does not explain their constitutive connection. It also admits an empty carrier or no transitions, so does not assert “有变”. Additional commitments include identity of ways, endpoint sufficiency for admissibility, and omission of transition multiplicity, duration and probability. **Fix:** call this a representation of unfolding, identify ways as relational occurrences/descriptions, and disclose these omissions. Explain how changing effective laws occur within it. “零前提” cannot be obtained by moving premises into `Z`.

3. **§4.2: “部分就是读法” — *dualism*.**  
   An arbitrary partition is a mathematical distinction, not yet a constituted part or an actual act of knowing. “知其常：耦合扩到其闭包” subsequently treats that distinction as an embodied reader without constructing the connection. **Fix:** distinguish abstract descriptions from physically realized reading relations; derive reader/read as their ends. Preserve joint realizability rather than assuming independent value spaces. Keep equivalence relations primary; a function representation needs its own kernel correspondence. Likewise, “量子力学不满足” does not follow from using functions: context can be included in their domain.

4. **§4.3: “已有的 `GoAlike`、`goAlike_iff_lumped`、`Labelled.Bisimulation`、`Alike` 作为实例” — *formal error*.**  
   `GoAlikeUnder` universally compares **every pair** of successors but requires no matching successor to exist. `Carries` requires existence of a match but permits differently classified alternatives. Neither implies the other generally. Existing bisimulation also preserves claims and matches the **same label**. **Fix:** give separate adapters: total deterministic unlabelled laws support the lumping correspondence; general processes require explicit enabledness, determinacy and label-preservation conditions. Erasing labels is not an equivalence theorem.

5. **§§4.3–4.5: “唯一一个最粗的细化”; “某步一旦稳定即是闭包” — *formal error*.**  
   The intended conclusions are sound for equivalence readings, but the sketches do not carry that hypothesis explicitly. `one` also omits symmetry and equivalence of its result. For arbitrary asymmetric `E` on terminal ways, `Stage` stabilizes immediately at `E`, whereas `Within E` retains only its symmetric portion. **Fix:** bind `E` with equivalence laws, state symmetry, reflexivity, transitivity and idempotence, and express uniqueness/stabilization by pointwise logical equivalence. Literal equality of predicates would introduce additional extensionality obligations.

6. **§4.5: “有限分支、可判定时，极限即闭包”; “无穷之深对应…（WLPO）” — *formal error / hidden layer*.**  
   Per-stage decidability does not itself justify exchanging “at every depth some successor matches” with “one successor matches at every depth” constructively. `Sensitivity.lean` concerns coordinate-insensitive exchange laws differing across histories; it does not identify those laws with infinite bisimulation depth or establish the advertised equivalence. **Fix:** state the compactness principle required, or restrict to demonstrated finite stabilization. Separate temporal discrimination depth from component dependence. Define depth as the **least** stabilization index; do not identify “二深” with generative meta-attraction without a correspondence theorem.

7. **§5.1: “一变之开与闭” — *formal error*.**  
   Possibility remains undefined. If it means unrestricted reachability under `becomes`, reachable possibilities can only shrink along a path: any continuation after the step was already reachable before it. `Labelled.together_after_reach` records this obstruction. **Fix:** specify present realizability, bounded-horizon capacity, or another justified comparison with common claim identities. Derive gain and loss from that **one comparison**. Generation and degeneration should remain distinct outcomes; they are not necessarily simultaneous sides of every change.

8. **§5.3: “相因、固，且其中闭”; “相因、自续（通），且其中开” — *hidden layer / overclaim*.**  
   Degenerative meta-attractors omit renewed activity and carrier succession, although the stated old definition requires both. “较粗读法（器、层）” can also confuse repeated classification with actual organizational survival. Mutual dependence alone proves neither generation nor feedback reproducing selection. **Fix:** define one common meta-attractor predicate requiring actual recurrence, consequential feedback and traceable succession. Then classify its changes as opening, closing, preserving or mixed; make fixation optional. Preserve symmetry under exchanging the readings throughout.

9. **§§5.2–5.5: “成势；无势（开放、日新）”; “完整地图” — *overclaim*.**  
   Renaming dimensions “questions” does not establish their dependence or exhaustive coverage. Novelty can coexist with recurrence under another reading; “耗 / 和” and “积化 / 守” are not demonstrated complements. Cells and adjacency are undefined. **Fix:** define every predicate over the same relational history, establish compatibility and exclusions, then construct inhabited combinations and transitions. Claim completeness only relative to that declared classification.

10. **§§4.6, 5.1: “进程已定、读法未显之最早一步”; “入盆之最早一步” — *formal error*.**  
    These are different notions of 几. For a deterministic basin defined by eventual attraction, an orbit eventually attracted already begins in that basin; “entry” need not identify a later tipping event. Nondeterminism additionally requires choosing existential or universal continuation semantics. **Fix:** define the outcome, a commitment boundary, the actual record and the earliest distinction relative to that record. Separate irreversible commitment from delayed recognition.

11. **§5.1: “N 个值以内，2N−1 步之文定其理”; “有常之读法于有穷值中复” — *overclaim*.**  
    The existing bound compares observed courses generated by fixed deterministic laws with bounded **state counts**; it does not identify an entire law from an alphabet of N values. Finite values also do not ensure that every starting value returns, or that a branching process continues indefinitely. **Fix:** restore the exact hypotheses and distinguish repeated values, eventual periodicity, return to the start and law identification. Likewise, “每步皆新需开放” needs the old counting/balance assumptions.

12. **§§2.2–2.3, 4.6: “对称的相因”; “正是‘部分是读法’”; “古文自己把它们读作…一变之两端” — *textual error*.**  
    These are proposed reconstructions, not consequences of the quoted syntax. Reciprocal wording does not establish the formal dependence relation; alternation does not establish two endpoints; ranked hexagram distinctions do not establish partition semantics. The corpus also contains hierarchical and differentiated formulations involving 乾坤、刚柔、天尊地卑 and 形而上/形而下. **Fix:** retain their full contexts and competing readings as tests. Do not neutralize difficult passages through “慎用”, or stipulate 体用不二 as textual evidence.

13. **§§2.3, 4.5–4.6: “精确对应”; “只取‘结局之先显’这一结构义” — *textual error / overclaim*.**  
    神 as finite-record unpredictability, 化 as continuous change discretized by cutting, 静 as non-stopping, and 吉 as neutral outcome each add or remove meaning. **Fix:** label each as an AI reconstruction and record semantic losses alongside polysemy. Similarly, §三 must distinguish external results from proposed translations: Rosas describes informational/computational closure and hierarchy, not a proof that every part is a reading or that this is the unique root. [Rosas et al.](https://arxiv.org/abs/2402.09090)

**3. What is already sound**

`Carries` plus symmetry does give unlabelled bisimulation; `Within` is its greatest symmetric carrying subrelation inside `E`. For equivalence `E`, the intended refinement and finite-stabilization results are sound design targets. Descriptive depth, coarse/fine readings and directional dependence need not imply ontological layers. Preserve the fixed-corpus test, explicit counterexamples, polysemy register, provisional status and refusal to claim mathematical novelty. Words such as 他者、内外 or 被驱 are diagnostic prompts, not proofs of dualism.
