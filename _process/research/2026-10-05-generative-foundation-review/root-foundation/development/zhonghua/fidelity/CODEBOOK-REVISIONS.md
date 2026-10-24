# FC1 codebook revisions (calibration only, before the main run)

Codebook v1 (FIDELITY.md §3) was used for the first coding of the calibration set: 16 條, 95 table-pass and 52 naive-pass segments, by both coders. Krippendorff's α on per-segment X was 0.58 (table, zh), 0.74 (table, en), −0.21 (naive, zh) and 0.87 (naive, en), below the plan's 0.8 for three of four. Per ANALYSIS-PLAN.md the codebook is revised on these segments only and they are recoded once. The revisions resolve the ambiguities the disagreements showed. None changes what counts as an agent, relatum or entity, and none is aimed at a language. The segments that showed each ambiguity are named; the first codings are kept in `data/coded/*/table_calib0/` and `naive_calib0/`.

**v1.1, 22 October 2026.** Appended to the brief as "Clarifications (v1.1)".

1. **Variables, numerals and terms formed in L(D).** Before coding a variable, numeral or arithmetic expression as excess, check the binders, the nested ∀/∃, and the terms the conclusion forms (for example `2 ^ n - 1`, `l.length`, `k`). It matches by M1 or M4 if any of them denotes it. A numeral inside a stated example matches the example's witness (M6). (en0449, enrec0075, jing0488)
2. **The naive pass reads plain senses; it does not penalize unfamiliar words.** A word matches when its plain sense denotes something of the counterpart's sort, whether the word is a coined name or a common one. It is excess only where its plain sense introduces a referent of another sort, or one L(D) lacks: an agent, a container, a substance, a ground, a third party. 运 read as implying a mover is excess A (the design's example 3). 感域 read as "the domain one senses" still denotes a set of relata and matches. (jing0217, jing0318–0320, jing0593)
3. **Talk about names is META.** Like references to the text or the theory, the following are excluded and not counted: where a name comes from, which senses it carries or does not carry (所不带, 不带, 不取), and the parallel texts and their kinds (对照, 相合/定域/相分 lines with the persons and doctrines they mention). The same holds in English for talk about the vocabulary. (shuo0108, shuo0147, shuo0025, shuo0001, shuo0130)
4. **Omissions, by procedure.** Go through every binder of L(D) in order (type parameters, instances, variables, hypotheses) and list it as omitted unless the wording renders it:
   - a variable is rendered by a matched referent;
   - a type parameter is rendered when any element of that type is mentioned;
   - a decidability instance is rendered only by 定然否 or an explicit "decidable / decided";
   - a hypothesis is rendered when its content is stated as a condition.
   List each omitted binder once, by its name. (table/zh O α −0.00)
5. **R or E for excess.** R is a participant of the unfolding as represented that L(D) lacks: a relatum, formation, condition, another party, an environment, a container, the rest. E is everything else excess: a reified abstraction, and an excess step, amount, value, history, law or claim. (shuo0223, shuo0044)
