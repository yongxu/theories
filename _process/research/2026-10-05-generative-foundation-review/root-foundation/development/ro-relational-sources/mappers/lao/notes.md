# 老子 slice: notes on the mapping (AI readings)

Slice: the 老子 (81 chapters, 王弼本 as base text DS01), with the 王弼, 河上公 and 苏辙 commentaries and the 郭店 and 帛书甲乙 witnesses from 易道体系图 v1.3, and the 老子 and 王弼 senses and relations of atlas v9.1. Output: `entries.json`, 50 entries: 40 on the classic text (经) and 10 on the commentaries (注: 王弼 5, 河上公 2, 苏辙 3). By kind there are 20 agreements, 21 scopes and 9 divergences. Three entries carry a gap. Every reading is the AI's. Ren's thesis, that this text continues a relational ontology, was tested rather than assumed. The result is mixed, and the parts can be stated exactly.

All fragments were checked by exact substring against the atlas `.txt` files, the variant fragments included. All 157 distinct declarations were checked three ways: against an index of the Lean sources, against their declaration lines, and as verbatim names in at least one result record. All record ids exist. The witnesses are web transcriptions (the atlas's own caveat), so variant claims are claims about those transcriptions.

## 1. The slice's relational structure

The 经 has a large relational core and three strands that are not relational.

**The relational core.** In the paired-term chapters, each term is stated through its opposite and none is given first. Examples are 2 有无相生, 22 曲则全, 40 反者道之动, 42 损之而益, 58 祸福相倚 and 77 天之道/人之道. The 自然 and 不宰 lines give an unfolding with no law-giver outside it and a generation that does not steer what it generates: 25 道法自然, 37 无为而无不为, 51 莫之命而常自然 and 生而不有，为而不恃，长而不宰. The knowledge lines make knowing a relation to the course one acts in: 1 名可名, 16 知常曰明, 32 知止, 48 为道日损 and 71 知不知. The spine has a checked law with the same structure for most of these. Where it does, it usually also gives the range: the passage holds in a bounded or lossless or enclosed case and fails outside it. This explains why scope (21) outnumbers agreement (20). The 老子 states relations as universal maxims ("则", "必", "常"), and the spine's typical answer is "exactly where …".

**The non-relational strands.**

- (a) A prior ground. The clearest case is 25 "有物混成，先天地生 … 独立而不改", a thing complete before heaven and earth, standing alone and unchanging. 4 "象帝之先" leans the same way.
- (b) One center governing the many. Examples are 3 "常使民无知无欲", 36 "将欲歙之，必固张之 … 国之利器不可以示人", 37 "吾将镇之", 65 "非以明民，将以愚之" and 80 小国寡民.
- (c) Decline from an original fullness. 38 sets out the ladder 失道而后德 … 失义而后礼, 18 says 大道废有仁义, and 80 tells people to return to knotted cords.

These strands are where the thesis fails for the 经. They are not marginal: (b) runs through about a dozen governance chapters, and only 36 and 65 are mapped here.

**The commentaries intensify both sides.** 王弼 gives the most relational sentences in the slice: 5 "万物自相治理", 25 "在方而法方，在圆而法圆", 2 "喜怒同根 … 不可偏举" and 57 "崇本以息末". He also makes the ground explicit and prior: "有之所始，以无为本" and "不能舍无以为体". 河上公 adds an individual deathlessness (6 "养神则不死", 16 "复还性命，使不死"), and he also writes the slice's best statement against endless more (39 "不可但欲长生无已时"). 苏辙, writing within a 儒释道 synthesis that the 四库 editors call 佛老同源, brings a fixed nature (16 "惟復于性而後湛然常存") and a 明 that is the end of distinction (33 "蔽盡則無分别"). He also gives the clearest accumulation-relational line (51 "物則不能自成 … 積而為勢").

## 2. Strongest correspondences

1. **生而不有，为而不恃，长而不宰** (51; `lao-51-sheng-er-bu-you`). Three checked structures fit:
   - A move is the part's own policy (`partForms_iff`), and a rest whose course takes another's policy as input is driven by it (`Run.rest_driven_by_part`). This is the structure of 宰.
   - The difference a part makes belongs to the joint activity (`Pool.difference_belongs_to_the_joint`, `Dependence.differenceOnlyTogether_iff`), which matches 不恃.
   - The spine has no relation of possession at all, which matches 不有.

   The normative step (one ought not to steer) needs the continuation condition and the comparison commitment. The text does not give it, and the spine does not give it by itself.
2. **知不知上，不知知病** (71). With two values the liar's revision never rests; with three it rests undecided (`Undecided.liar_both_sides`). Wherever two-valued revision has no fixed point, revision rests only with something left undecided (`Undecided.rest_undecided`). "知不知" is keeping the undecided value, and "不知知" is forcing two values where none is fixed.
3. **道可道，非常道；名可名，非常名** (1), with 王弼 42 "已谓之一，岂得无言乎". The diagonal law says that no family of claims made from within realizes every pattern. Completeness from within holds exactly where nothing can be told apart (`Diagonal.complete_iff_alike`). Every completion adds a new gap (`Diagonal.Unfolds.gap_new`). The same law corrects 王弼's "数尽乎斯", because the regress does not stop at three.
4. **人之道，损不足以奉有馀** (77). Every rise is given (`Flow.rise_netGiver`). A family's rise in a balanced flow is given from beyond (`Flow.Balances.rise_paid_from_beyond`). One member rises only as another falls (`Flow.rise_with_fall`), and a carrier's share rises (`share_rises`). The text names the direction of a collective attractor; the spine supplies the mechanism.
5. **崇本以息末 versus 立辟以攻末** (王弼 57/38). Perturbing the state alone is re-absorbed (`Law.perturbation_reabsorbed`), and a fast difference does not reach a rule before a reading step (`Pace.rule_alike_until_reading`). §7's "a lasting change has to reach the rule" is the same structure. Reading 本 as the rule is the AI's reading.
6. **其安易持，其未兆易谋，为之于未有** (64). Every loss passes a juncture where keeping and losing both have a step (`Branching.loss_passes_juncture`). The spine adds a limit the text does not have: finding the juncture of every loss is the limited principle of omniscience (`lpo_of_junctures_found`), and before a loop forms its amounts show nothing (`Closing.Onset.amount_before`). What is easy to change is hard to find except by reading the couplings.
7. **为学日益，为道日损** (48). Learning is refinement, and each strict refinement adds a class. Removing distinctions loses nothing exactly down to the coarsest lumping that carries the law (`Law.identifiesAlike_of_law`, `Readout.futures_through_iff`). So "损之又损" has a floor at that lumping, not at zero distinctions.
8. **河上公 39**: "谷当有盈缩虚实 … 万物当随时生死，不可但欲长生无已时". More-than-now never rests (`Law.more_never_rests`), and a lasting whole needs parts that keep arising (`Web.Whole.needs_arising`).

## 3. Divergences and non-relational strands (with passages)

- **25 有物混成，先天地生 … 独立而不改** (`lao-25-you-wu-hun-cheng`). This is a prior, independent and unchanging ground. The nearest spine structure is a rule that never reads the fast level: it is kept, and nothing reaches it (`Pace.rule_kept`, `rule_unreached`). That rule is a reading within the run, however, and it loses what it merges. It is not prior to the run. 郭店 and 帛书乙 keep 独立不改.
- **王弼 40/38 以无为本、不能舍无以为体** (`wb-40-38-yi-wu-wei-ben`). Here the ground is made explicit. The spine's nearest structure, a law of the whole that no part changes, exists exactly where a WLPO rule does (`changedByNoCondition_iff_rule`), and the core does not assume that rule. Arising from nothing holds only locally, as being given by others.
- **苏辙 16 惟復于性而後湛然常存** (`sz-16-fu-xing`). This is a fixed nature, and 明 is the recovery of it. It differs from 明 as seeing the coupling one acts through.
- **苏辙 33 蔽盡則無分别故能自知** (`sz-33-bi-jin-wei-ming`). The spine proves the equivalence 苏辙 relies on: complete self-saying holds exactly where nothing can be told apart. It reads the equivalence the other way, though. In any world where something can be told apart, self-knowing from within is incomplete, and 明 widens coupling rather than ending distinction.
- **河上公 6/16 养神则不死、复还性命使不死** (`hs-06-16-bu-si`). This is individual deathlessness. A reserve defers the end and does not escape it. What lasts is a pattern that is passed on, which fits his lineage reading in chapter 54 ("长生不死，世世以久") but not these lines.
- **36 将欲歙之，必固张之 … 利器不可以示人** (`lao-36-jiang-yu-xi-zhi`). Read as natural law, it agrees with the spine: a rising take ends. Its structure, however, is one will steering another through the other's own course while hiding its means. That diverges from 明 through pooled coupling, because hiding the coupling places others outside the closure.
- **65 非以明民，将以愚之** (`lao-65-fei-yi-ming-min`). One center narrows what the many can know. 王弼 glosses 明 as 巧诈, but in the same note he says "当务塞兑闭门，令无知无欲", so the divergence is structural, not verbal. Counter-evidence inside the text is 49 "圣人无常心，以百姓心为心", mapped as an agreement with pooled coupling.
- **80 小国寡民 … 不相往来** (`lao-80-xiao-guo-gua-min`). The enclosed community diverges from the spine. An unlinked formation reaches only itself, a bounded whole that keeps exchanging returns and forgets, and novelty needs exchange beyond every finite family. 帛书甲 and 乙 both lack the 不 of "不远徙".
- **38 失道而后德 … 失义而后礼** (`lao-38-shi-dao-er-hou-de`). Every differentiation is read as a loss from an original fullness. On the spine, loss is merging, while refinement adds classes and novelty is given from beyond. Generation and degeneration both occur, and neither is the default direction.
- **Softer cases kept as scope rather than divergence.** In 5 天地不仁, the unfolding has no ethical predicate, which agrees with the spine; but 圣人不仁 as a stance toward people diverges from the conditional ethics. In 77 天之道, the leveling is the property of a regulating coupling, not of heaven; the attribution to 天 is not adopted.

## 4. Variants that change the structural reading

These are checked against the atlas transcriptions:

| Ch. | Received text (DS01) | Variant | Effect on the reading |
|---|---|---|---|
| 16 | 归根曰静 … 知常曰明 | 郭店 stops at "天道员员，各复其堇", with 守中 | Return within a bound, not rest under enclosure; no 明 here |
| 55 | 知和曰常，知常曰明 | 郭店 "和曰常，知和曰明", 帛书甲 the same; 帛书乙 as received | The object of 明 is 和, not the constancy of return |
| 25 | 周行而不殆 | Absent in 郭店 and 帛书乙 | The claim of endless circulation belongs to the received text only |
| 40 | 有生于无 (chain) | 郭店 "生于又（有），生于亡" (parallel); 帛书乙 with a repetition mark | 郭店 fits the local reading (given by others), not cosmogony |
| 37 | 道常无为而无不为 | 郭店 "亘（恒）亡为也"; 帛书 "道恆無名" | No "leaving nothing undone" in chapter 37 (郭店 has it in 48) |
| 30 | 其事好还 | 郭店 "其…事好", with no 还 | The claim of return is absent |
| 55 | 物壮则老 … 不道早已 | 郭店 stops at 不道 | No claim of an early end |
| 19 | 绝圣弃智 … 绝仁弃义 | 郭店 绝知弃辩 … 绝伪弃○，民复孝慈 | Not aimed at 仁义; the withdrawn element is artifice |
| 8 | 利万物而不争 | 帛书甲 而有靜, 帛书乙 而有爭 | No 不争 in that clause |
| 80 | 不远徙 | 帛书 而遠徙 / 遠送 | The reading of enclosure rests on the received negation |
| 2/10 | 生而不有，为而不恃 | 郭店 2 lacks 生而不有; 帛书乙 10 lacks 为而不恃 | The triad is not fixed in every witness |

An observation about the sample (the AI's; not a dating claim, and 郭店 covers only part of the text): several of the strongest universalizing clauses are missing from the earliest witness. These are 周行而不殆, 归根曰静…知常曰明, 不道早已, 其事好还 and 无为而无不为 in 37. Several 郭店 forms are closer to the scoped readings the spine gives (40 parallel, 16 return, 55 知和).

## 5. How the earlier repository studies stand

- **`theories/becoming/history/DAO-AND-GENERATIVITY-2026-10-23.md`** (6 October; older vocabulary).
  - *Kept:* its central caution that classical propositions are not ready-made theorems, and its choice of chapter 51 as the strongest connection. Chapter 51 is now three checked structures plus an explicit condition.
  - *Kept and sharpened:* its counter-pressures. Chapter 5 is now a scope entry. Chapter 38 is now a divergence with a stated reason (decline from fullness versus loss as merging). Chapter 48 is now a scope with a floor.
  - *Superseded:* the older bridges it reports, which mapped 自然, 无为 and 齐物 to automatic evolution, symmetric relations and model invariants. Each is replaced by a named law with its range. For example, 无为而无不为 is now `TwoClocks.one_course_two_laws`, with the explicit note that the practical claim is not a theorem.
  - *Superseded in vocabulary:* its framing in terms of 共同生成 and the earlier labels. This map uses 生生, the continuation condition, 明 and 理.
- **`DAO-GENEALOGY.md`** (history). Its finding is that the old formal bridge between 道 and 生生不息 defined both sides by one witness and so established only a correspondence between given definitions. That finding stands. This map avoids the problem by using laws already landed on the spine, and it never identifies 道 with a spine term.
- **`DAO-CLASSICAL-SOURCES.md`** (history). Its selective chapter comparison (1, 5, 18, 25, 34, 38, 40, 42, 48, 51, 57) is extended here in three ways: the 郭店 and 帛书 witnesses, the three commentaries kept as separate layers, and roughly thirty further chapters. Chapters 18 and 34 are not mapped here.
- **The Yi line** (`YI-ZHUAN-AND-BECOMING.md`, `y1-changes/passages.json`) is not redone. Entries use the same core fields as that `passages.json`, plus `layer`, `variants` and `gap`. The two maps meet at 42 (负阴抱阳), at the 中和 question (gap 1 below) and at 反/复 (Hexagrams' return laws).

## 6. Candidate gaps, ranked

Absence was checked by searching both digests and grepping the Lean sources. No two-sided regulation law exists: `Flow.restores` is one-sided, and `stays_below`, `excess_lowers` and RenewalBound do not regulate. No theorem compares tolerances across laws: monotonicity exists only in the start, through `KeepsInclusion`.

1. **Two-sided regulation of a level** (`lao-77-tian-zhi-dao`; the same gap is pointed to from `lao-42-chong-qi-yi-wei-he`).
   - *Statement.* Under balance at `c`, suppose three things hold:
     - (i) above `m`, the exchange is a joint excess bounded by the overshoot;
     - (ii) below `m`, it is a joint net giving bounded by the shortfall;
     - (iii) at `m`, it keeps.

     Then the distance `(level − m) + (m − level)` never rises and falls at every step at which it is positive, so the level is `m` from `T + d` on.
   - *Exactness.* Without the bounds, overcorrection oscillates. Without (i), the level can stay above `m` (`Flow.restores` alone is not regulation).
   - *Why it matters.* It gives 损有馀而补不足, 张弓 and 冲气以为和 a checked form as a property of a coupling, not of the whole. It connects Widening's loop law to levels, and it is likely shared with the Ru slice's 中和.
2. **Tolerance compared across laws** (`lao-76-rou-ruo-sheng-zhi-tu`).
   - *Statement.* Raising tolerances pointwise, from an included start, keeps every giving at every step. Strictness is witnessed in `Triad`. From total withholding, no raise restores anything unless some formation spares all it waits on.
   - *Why it matters.* It states 柔弱者生之徒 and 柔之胜刚 as a comparison of laws together with their exact limit: softness absorbs, and it does not restore. Today the spine has only a three-formation example.
3. **(Weaker; a reading record, not new Lean.)** A record should join 王弼's 以无为本 to `Becoming.Tail`. It would say that a ground on which all parts depend and which no part changes is exactly a law of the whole and no part, and that such a law is given only with a WLPO rule. The Lean exists. What is missing is the reading record that turns this into the calibration "a ground is an omniscience principle, not a start". I list it only because the brief asks for three; it is not a missing structure.

Considered and found covered, so not proposed:

- the use of the empty (11): admission within the margin, `supported_iff_within_margin`;
- acting before signs (64): junctures plus the LPO bound;
- 周行而不殆 (25): `change_recurs_iff` and `fed_from_beyond`;
- 既以与人己愈多 (81): pooled coupling adds (`Web.pool_adds`), while conserved amounts fall under balance. This discriminates two readings exactly; it is not mapped as an entry and is noted here.

## 7. Counter-review (where this map may be matching words)

- **76 柔弱 as tolerance.** This is one structural reading among several. 76 itself speaks of physical pliancy (草木之生也柔脆), and tolerance is a law of giving that waits on others. The agreement holds for "absorbing local failure", not for softness in general.
- **40 弱者道之用 as a link giving back less, and 42 二生三 as a relation of three that no pair gives.** Both are flagged in their entries as weak readings. Number and word resemblance could be doing the work.
- **37 无为而无不为 to `one_course_two_laws`.** The law shows only that a course does not fix whose move it is. The chapter's claim concerns rulers and transformation. I kept it as scope for that reason, and it might better be counted as a partial agreement on one clause only.
- **16 知常曰明 to the model route of 明.** In 16, 常 is the constancy of return (复命). The spine's 理 is any lumping that carries a law. The agreement is partial, and the 郭店 and 帛书甲 variants (知和曰明) move the object again.
- **8 水 and 22 不争.** "Benefit" is not a flow give, and reading 争 as seeking to stand above all narrows the text. The 帛书 variants remove 不争 from the 8 clause.
- **王弼 以无为本 as divergence.** Read as "not any particular thing" (无形无名), 王弼's 无 is close to the whole that no part changes, and the entry could be a scope. I kept divergence because he makes it 本 and 体 and calls for a return to it (必反于无), which is a priority of ground.
- **77 天之道 as scope.** "The way of heaven" may be meant as a model to follow, not as a description. If so, my objection to the attribution to 天 reads the line too literally.
- **苏辙 33 to `complete_iff_alike`.** This is a formal analogy between "self-knowing without distinction" and "a family within says every reading". His 自知 is a practice, not a family of readings.
- **Selection bias.** I chose the brief's passages and then the strongest counterexamples. The governance chapters (3, 57, 60, 72–75) carry more of the one-center strand than the two entries show. An "agreement" here means the spine has a law with that structure, not that the passage is true as stated. Many agreements also hold only under conditions that the reading names.
