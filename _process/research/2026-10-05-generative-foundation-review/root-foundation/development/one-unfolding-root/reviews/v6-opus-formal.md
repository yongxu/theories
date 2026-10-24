# Review of PLAN.md v6: formal monism (Claude Opus 5.5 subagent, read-only)

23 October 2026. Brief: [BRIEF.md](BRIEF.md), with the formal-design angle. Scratch Lean checks: [../review-checks/Root.lean](../review-checks/Root.lean), [../review-checks/HM.lean](../review-checks/HM.lean) (rechecked by the session: `one`, `Within.trans`, `within_stage`, `stable_closure`, `stable_not_closure`, `back_of_symm` have empty axiom reports; `HM.limit_gives_llpo` uses `propext` and `Quot.sound` from `omega`/`simp`, which do not prove LLPO). Text as returned.

---

**1. Verdict**

The plan is not yet fully monist, and it is not yet formally safe. Some parts are sound. The reading in relation form, `Carries`/`Within`/`one`, and the lemmas about stages all hold. I checked them in scratch Lean and every axiom report is empty, provided the reading is symmetric and each statement is pointwise. The problems are these:

- The base still takes two splits that `Labelled.lean` already names: "configurations given before the relation among them" and "a law supplied before the history it governs". The plan does not disclose either.
- 相因 and 势 are never defined, and the obvious formal reading of 相因 is reflexive.
- In this base, possibility can only narrow, so 开 cannot be defined the way the plan assumes.
- The map is still a product of dimensions chosen in advance, and §5 keeps 层, 载体 and agent nouns.
- One stated boundary implies LLPO, so it cannot be a theorem of the pure core.

**2. Findings (most serious first)**

**F1 (formal error).** §4.5: "边界：有限分支、可判定时，极限即闭包；…成分形式中无穷之深对应依赖于整体而不依赖于任何有限部分（WLPO）。古文的“阴阳不测之谓神”在这里有精确对应".
- The Hennessy–Milner limit is a classical result. I built an unfolding with at most 3 successors per way and decidable steps, from any α with at most one `true`. Its two ways lie in every `Stage`, and `Within ⊤` relating them gives LLPO (`HM.limit_gives_llpo`; its only axioms are propext and Quot.sound, which come from omega/simp and do not prove LLPO). So the claim cannot be proved in the core.
- The WLPO sentence is unproved. `Tail.lean` is about exchange laws over conditions numbered by Nat, in rule form (`Nonempty (∀ s, Decidable …)`). It says nothing about depth.
- 神 is a third, separate notion. A two-way coin has depth 0, yet no prefix fixes its next value. A family of chains of every finite length plus one infinite chain has infinite depth, yet it is deterministic.
- Fix: "态有限（列出、可判定）时，有限步内稳定；仅有限分支时，'极限即闭包'蕴涵 LLPO，记为标定。神另立：无前缀能定下一读值；与深互不蕴涵。" Remove WLPO from §4.5.

**F2 (dualism / hidden commitment).** §4.1: "`Way : Type -- 态：整体可以所是的样子`", followed by one fixed `becomes`. Only 离散、模态、确定 are disclosed. Four commitments are hidden:
- (a) Ways are given before the relation, and their Lean identity is not grounded in becoming: two bisimilar ways stay distinct.
- (b) There is one time-invariant `becomes`, i.e. a law fixed before the history.
- (c) Every step is a step of the whole (a global cut). Independent local changes become interleavings, so true concurrency is lost, for example what the existing PlaceTransitionNets module expresses.
- (d) The current way fixes what can come next. This costs no generality only if `Way` carries history, and then nothing ever 复.

Fix: list (a)–(d) as commitments. Then prove two-presentation theorems, as `Labelled.lean` already does: `withMove` shows the step-first and way-first presentations have the same runs, and `Shown` makes `becomes` the least law its runs show.

**F3 (formal error).** D1 "关系：开闭需要可能"; §5.2 "开闭贯穿每一格"; 阖辟 as "一变之两端".
- If u→v, then reach(v) ⊆ reach(u) (`reach_narrows`). No step ever opens possibility, and the classes reachable under any reading also only shrink.
- So 辟, 日新 and 生成 cannot mean that reach widens.
- Fix, reading one step from its two ends: "辟：v 一步可及之类有 u 所无者；阖：u 有而 v 无者；一阖一辟：二者皆有". This is the adjacent possible, which is the Tria urn's real mechanism. Alternatively, compare alternatives (the old `Widens`/`Keeps`/`Mixed`). Either way, 生成 and 退化 become the two one-sided cases of one comparison.

**F4 (dualism + formal error).** §4.4: "两个读法 **相因**，若各在对方的闭包中…单向的因是**被驱**…个体三谓词：自持、共持、被驱".
- "闭包" is undefined, and the plan uses it for two opposite things: `Within E` is the largest bisimulation inside E, a greatest fixed point; `Frame.WithinClosure` (behind 明 and 察几's "耦合进闭包") is the least reach.
- If "E₁ lies in E₂'s closure" means `Within E₂ ⊆ E₁`, then 相因 is reflexive and amounts to "same closure" (`literal_xiangyin_refl`). Every carried reading would then be a 元吸引 with itself.
- 共持 and 个体 need a complement ("the rest"), but complements in the lattice of partitions are not unique.
- Fix, so each pair is one relation read from two ends: `自持 E := Carries E`; `相因 E₁ E₂ := Carries (E₁ ⊓ E₂) ∧ ¬Carries E₁ ∧ ¬Carries E₂` (symmetric and irreflexive); `被驱 E₁ E₂ := Carries (E₁ ⊓ E₂) ∧ Carries E₂ ∧ ¬Carries E₁`. Rename `Within`/闭包 to 有常之核. Use 共持 only as 相因.

**F5 (hidden layer).** §5.2's five binary questions with "开闭贯穿每一格", and §5.5(1) "每一格要么有见证，要么被证明为空". The cells form a 2⁵×4 product of dimensions fixed before the root exists. Fix: generate the cells from the root predicates (F3, F4, 势). Prove the implications among them first (for example 固 ⇒ 成势), and count only the combinations that can occur.

**F6 (hidden layer / dualist words).** §5.3: "势属于一个有常的较粗读法（器、层）；细读法改变，势仍存续" uses 层 and 载体 (carrier versus form), and readings do not change; their values do. Agent nouns: "迁（被驱之势随驱者而移）", "其所成者复为他者所因", "耗者与所依者同终", "相争而耗". Fix wording: "跨细分：势在较粗有常读法上成立，与较细读法之取值无关"; "迁：随联合读法另一端之值而移"; "其所成复为相因之另一端所因"; "耗：同一余地上联合超出".

**F7 (formal error).** "某步一旦稳定即是闭包" and "一个分别有常，恰好在它就是自己的闭包时" both need E to be symmetric. Counterexample: two ways, no steps, E one-directional; Stage 1 ↔ Stage 0 and E is carried, yet `¬Within E` (`stable_not_closure`). "最粗的细化" is a reading only once you prove that `Within E` is an equivalence whenever E is (proved: `Within.refl`, `Within.trans`). State every result as a pointwise ↔; `E = Within E` as an equality needs propext and funext.

**F8 (formal error).** §4.2: "等价关系…，或函数 `π : Way → V` 的核". Function to relation is free; relation to function needs a quotient, and `Quotient.exact` depends on propext. V brings a second sort with its own identity. Fix: make the relation form primary. 读法 implies a reader and 象 "读法之所显" implies a viewer, so use 分别 instead.

**F9 (overclaim).** "已有的 `GoAlike`、`goAlike_iff_lumped`、`Labelled.Bisimulation`、`Alike` 作为实例". `GoAlikeUnder` is labelled and requires every pair of successors to match; when steps branch or are missing, neither it nor `Carries` implies the other. They agree only for determined total laws. `Bisimulation` relates two different frames and carries labels and claims; it is an instance only via Way = S ⊕ S', with the label in the target way and the claims as E.

**F10 (formal: one name, several objects).** 深 has three meanings (stage depth §4.5; "愈固愈深" §5.2; "一深、二深、k 深的生生" §六.8, a hidden hierarchy of orders). 常, 理 and 器 all name one formal notion. 文 is both a cross-section and a trace, and overlaps 象. Fix: 常 = `Carries E`; 理 = `Within E`; 器 = an invariant region saturated by E; 文 = the trace of the joint reading E₁⊓… along a course; 深 = stage depth only; name the orders of 生生 as 阶, defined by one recursion.

**F11 (formal gap).** 势 ("有常之读法所趋") carries all of §5.2–5.3 but is never defined. "趋" can mean "some run" or "every run"; "every run enters" differs constructively from inductive inevitability (for finite branching their equivalence is the fan theorem). Fix: define 势 inductively and record the every-run form as a calibration.

**F12 (overclaim).** "N 个值以内，2N−1 步之文定其理": the record `how-fast-a-rule-may-change` says N *states*, and it fixes the *course*, not the rule. `no_record_fixes_next` is now `Learning.no_prefix_fixes_next`, over the free space of all courses. "旧的工作定义…在根上即是…" asserts an identity before any definition exists; the old definition runs one way and keeps "carriers".

**F13 (textual error).** 化而裁之謂之變 sits inside "形而上者謂之道，形而下者謂之器，化而裁之謂之變"; the 道/器 pair of that sentence is omitted. The text defines 道 as 一陰一陽之謂道, yet §4.6 imposes "道（若采只作“大化之常”）". 势 comes from 孙子 although the frozen corpus has 老子 51 "勢成之"; 理 (韩非) and 同异 (墨经) come from outside the corpus. "天尊地卑，乾坤定矣" opens the 系辞 but sits on the not-adopted list, against §5.5(5). "有等第" adds an order; the reviewer recalls 韩康伯 glossing 等 as 类 (verify at step 0).

**3. Already sound (keep as is)**

The bodies of `Carries`, `Within` and `one`, and the disclosure that the root theorem uses impredicativity; "闭包在每一步之内" with no hypothesis; `Carries` plus symmetry gives the back clause; `Within E` is an equivalence whenever E is; 消长相当 as the monist form of 取与; 一X一Y read as one relation's alternating ends; the refinement order as a description, not layers; deferring ethics; "不把古文的贴切当作证明".
