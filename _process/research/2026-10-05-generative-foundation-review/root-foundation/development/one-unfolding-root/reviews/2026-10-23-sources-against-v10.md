# The two source texts against plan version 10 and the landed grammar

23 October 2026, evening. AI-authored (a Claude Code session and four read-only Claude Opus 5.5 subagents: three verifying a draft mapping against the Lean, the plan and the chapters, one reading the two texts without the mapping). Asked by Ren, who pasted the two texts again: "is this the current direction we are moving forward to?" Nothing was edited, built or committed besides this note. Line numbers are those of the files at about 17:00; the RA chapter drafts (`theories/becoming/chapters/01-ROOT.md` … `08-METHOD.md`) were being edited during the check.

Sources: [minimum-grammar-of-becoming.md](../../../../../../../sources/15-codex-theory-conversations/2026-10-23-continuity-as-root/minimum-grammar-of-becoming.md) (MG), [three-minima.md](../../../../../../../sources/15-codex-theory-conversations/2026-10-23-continuity-as-root/three-minima.md) (TM). Lean paths are under `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.

## 1. Answer in short

The texts are the root's source, not its programme. Plan v9 moved the root's centre to 续 on them, v10 corrected that after three reviews, and OU1–OU5 and WL3 landed it as continuation relative to a class (`Grammar`, `GrammarReadings`, `GrammarCandidates`, `GrammarMap`, `GrammarTesting`, `GrammarCourse`). RA presents it as the root of the eight chapters. The independent reader classified 94 distinct proposals of the texts: 17 adopted, 44 adopted with a correction, 1 rejected (the scaffold W ∈ Φ(W, C)), 19 planned and not done, 13 absent.

## 2. Taken, and now in Lean

- 生存变亡 as positions of one continuation: `«续» R E := «合» R E` (Grammar.lean:119); `«生»`, `«住»`, `«亡»` by one-step predecessor and successor (:131–137); `«异»` a step continuing under `E` that `F` tells apart (:140; `F` is not required to be finer). `«四相无自立»` (:293; hypotheses: `R` irreflexive, a condition and a consequence of `y`).
- The criterion κ as the class `E`, plural and named: `«任一缘可为续»`, `«蜡烛之合»`, `«分叉»`.
- 理 as the core: `«根»` (:363, no hypothesis on `E`), `«闭合当且仅当有常»` (:419, `E` a class). Beyond the texts: `«有常则续不尽»` (:339), so a regularity that holds only for a while is never a constant class, and an ending line's regularity is its core (`«足以定理»`, `«因于核»`, `«相须核»`).
- 续而复生: `«复生»`, `«生生最大»`, `«生生不息»`; generation, keeping and degeneration at two grains in `GrammarMap`.
- 验 inside the net: `«可分则不在核»` (GrammarTesting.lean:53); the thermostat witness `«恒温与平衡»`.
- 文: `GrammarCourse` makes 文同 the core of the value class, for a determined law and a map only.
- The texts' cautions: minima as hypotheses; 穷则变 conditional (shown on the old spine, `Hexagram.allBroken_absorbing`, not in the grammar); classical aptness not evidence (FC1, then ZE: the advantage does not survive a controlled English, provisional and LLM-coded); the grammar yields no ethics (`ReadsOnlyDynamics.not_entails`).

## 3. Changed

- **The centre.** The texts name 文 the foundation and 续 one of six functions (MG:9, MG:41–46; TM:455). The root's centre is 续. 文 keeps D63's sense, a course (values of a run read through a map), not the texts' configuration; 物相杂故曰文 is classified 甲 in `classify/xici.tsv:332` and 定域 in WENLI. Three senses of 文 stand unreconciled.
- **Primitives.** Six functions and three primitive triads become one kind of non-logical symbol (`«际»`). The "three uses of 际" (辨, 相, 化) is plan prose only (PLAN:97); no Lean declaration is named 辨 or 相, and the one `«化»` (GrammarReadings.lean:46) is alteration, equal to `«异»`. 时 and 限 are defined in no grammar module.
- **The minima.** Mapped to classes of corpus sentences (PLAN §三). 缘 is moved from 穷理 into 立言. The reason given (two candles' fires are alike under "fire"; only 缘 separates them) holds where one fire does not light the other; the source's own ⇝κ is already a binary relation, so the real difference is that the plan decomposes 续 into 缘 and 类.
- **The scaffold** `W_{t+Δ} ∈ Φ_t(W_{≤t}, C_{≤t})` is rejected as a root (choosing configuration and conditions first is a split); history dependence and a time-varying Φ have no grammar form.
- **Order of work.** The texts map validated operations to 文言 last (TM:434–438); the plan reads operations off classical sentence forms first (rule 1). The landed operations are Tarski's relation algebra with Chinese names.

## 4. Not done, or absent

- **Test systems** (MG:238–245; PLAN §六, criterion 9): only toy witnesses exist (a four-moment flame, the thermostat room, the candle merge, fission). Radioactive decay, a vortex, an organism, an institution, a belief system and a system with no clear boundary have no model. The stationary process is only in `review-checks/V9.lean`.
- **Self-modifying conditions** (MG:100; TM:254–256): 势 reshaping its own 位 and 限, selection of selection, configurations encoding their own rules. The grammar's relation is fixed; this exists only on processes (`adaptive_state_law_iff`, `ClosedCapture`). It is what the meta-attractor needs.
- 势, 穷, 几, 定, 机, 度, 界, 制 and 限 are not in the grammar (势 and 机 exist on the old spine: `Law.Absorbing`, `Law.Drawn`, `Juncture`; not joined). The conflict relation of a net of possibilities is asserted (Grammar.lean:31–32) and defined nowhere.
- MDL and the Pareto report: not started. The formal reduction the texts name as the next decisive task (TM:459): not attempted. The deletion test (TM:88–92) was in v9 (PLAN-v9:135, 381–382) and dropped in v10 with no reason that bears on necessity.
- Lifting: 14 of 312 core modules count as on the grammar, eight of them only through instance sections; OU3b waits on agreement with EC's owner, which the board does not record; no representation theorem for the old World.
- No human review. Only plan versions had AI reviews; the landed Lean has machine checks.
- **Root and ethics are not joined.** `Unrestricted` is stated on the significance formalism, not on `«续»`; 07-SIGNIFICANCE ties to the World and to any process, not to the grammar. IV3–IV3g grew today entirely off the grammar.

## 5. Defects found in landed text (for the owner of OU)

- `«火因于薪»` (Grammar.lean:755) holds because the joint class is identity on the four moments (`Flame.joint_eq`). By hand, not checked: `«因于核» step alike «静»` holds too, and so does the reverse, `«因于核» step sameFuel alike`; the constancy form `«因于» step alike sameFuel` fails and `«相须» step alike sameFuel` holds. The witness does not single out fuel or a direction.
- `«位同则四相同»` (Grammar.lean:518) proves only that 生 and 亡 carry over.
- `«阶全生成»` (GrammarMap.lean:159–161): the docstring's "each finer than the next" is not a hypothesis. The GrammarMap header (:32–33) cites the coarse net, which the module never uses; `«粗»` appears only in `«粗只连异类»`.
- `«全生有终之定当且仅当排中»` (GrammarMap.lean:108–112) is about `«不穷»` versus `«有终»`, not about `«全生成»`.
- PLAN:219 ("在静之类下，凡有后继者皆复生") is false by the definitions: under `«静»`, 生 needs `¬R y y` and 有后 needs `R y y`, so `«复生» R «静» x` never holds.
- PLAN:105 and :433 concede that time and positions separate occurrences only by carrier equality (the stationary process); PLAN:84 still says 时由缘定义 and 01-ROOT:16 says no time is chosen before the relations. 01-ROOT:23 lists the merge among statements using equality; `«蜡烛之合»` uses none.
- `«通»` = `«不穷»` (GrammarReadings.lean:108) drops the 往来 of its defining sentence, so constancy alone gives 通 and the order 穷 → 变 → 通 is lost.
- `«息»` is defined by negation over the line, where the plan asked for a positive definition (PLAN:225, :329–330).
- Stale plan text: PLAN:198 (`within_stage` → `«可分则不在核»`), :189 (`«核».«类»` → `«核为类»`), :222 (`«生生».greatest` → `«生生最大»`), :193–194 (reviewer names), :210, :331 and :432 (call OU2/OU4 items open that have landed), :429 (lists only OU1, OU2, OU3a). The converse of 验 is not only peripheral: the core refutes the unconditional converse (`«致诘不尽»`) and proves a conditional one (`«不可致诘而有常则混而为一»`), over a stage notion `«诘»` not related to `«层»`.
- Two "three minima" coexist: 08-METHOD:134 keeps the older triad of MATHEMATICAL-CORE; 06-CLASSICAL-TEXTS:36–46 and PLAN §三 use 立言/穷理/成文. PLAN:88 adopts MDL, while WENLI:385 says the spine measures compression by what is merged, not by length.
- Vocabulary: 窮, 勢, 通, 復, 度 and 位 have one sense in the 中华本 name table and another in the grammar's «» names; 化 has three senses in the plan and Lean, against rule 5.

## 6. Worth carrying from the texts

The decisive test systems, starting with the three that press on the root (decay: an event with no evident 缘 for its timing; no clear boundary: overlapping identities where every class is an equivalence; a belief system changing the conditions of its own propagation); the deletion test with its falsifier column; the institution pair (reproduction by consent against by penalty), the social counterpart of the thermostat witness; a formal 限 and a defined conflict relation; and the formal reduction report.
