*AI-written, 13 November 2026. Read only; nothing run.*

# WM2 fronts, second round: check of the final Chinese sentences

What I read, all in `/Users/ren/tmp/rw/wm2/wt`:
- the centre paragraph in `AGENTS.md`, and in `ONE-PAGE.zh.md`, where it now stands at line 11, not line 7;
- the settled blocks in `chinese-round2.json`;
- `README-ZH.md` lines 1 and 19 against `README-FIRST-SCREEN.md` line 10;
- `USES.zh.md` line 22 against `USES.md` line 15;
- `USES-EXAMPLES.zh.md` lines 38–122 against `USES-EXAMPLES.md` lines 30–108;
- `ONE-PAGE.zh.md` lines 5, 11, 21 and 27–30 against `ONE-PAGE.md` lines 5 and 19–22;
- `08-METHOD.md` §1 and `07-SIGNIFICANCE.md` at `r-what-the-dynamics-leave-open`;
- the sheet `fronts-final-old-new.md`, and the two round-one reports `check4-chinese-check.md` and `check4-cold-chinese.md`.

Only read commands were run.

## Findings (should still change)

### 1. README-ZH.md line 1, the comment's last sentence: "由一个 AI 会话写出，再经一位 AI 核对者对照英文与中心一段核对、一位 AI 中文冷读者读过，两轮。"
**SAYS MORE.** "两轮" reads as if both a checker and a cold reader read the text in each of two rounds. What happened is different. In round one, one checker and one cold reader read the first version, and the text was rewritten from their findings. In round two, only this checker read it. The rest of the sentence is accurate:
- line 19 no longer contains 读 or 之外;
- "四个问题" now names the four questions for a sentence or a picture in 08 §1 ("Four questions for a sentence or a picture").

Replacement:
"由一个 AI 会话写出；第一稿经一位 AI 核对者对照英文与中心一段核对、一位 AI 中文冷读者读过，再依其所见重写；重写稿又经一位 AI 核对者核对。AI 写成。"
If this round's findings are applied before landing, add before AI 写成: "并依其所见再改。"

### 2. USES.zh.md line 22, third sentence: "这些问题下面的定理，在模型上已证明。"
**UNCLEAR.** The sentence just before now says 四件事 … 第五件. So 这些问题 points back with 这 to things the page never called 问题. The front page changed 这五个问题 to 这五件事 for exactly this reason, and the reason given for that change ("the Chinese README says 这五件事 because 这 points back") applies here too, so leaving this sentence does not hold up. The cold reader's other point (F9) also still stands: 下面 can be read as "further down this page". The English "beneath these questions" has the article-free seam, but Chinese marks it with 这.
Replacement:
"这几件事所依的定理，在模型上已证明。"

### 3. README-ZH.md line 19, the lock clause: "以及，在无噪声时，一条只由它已偏向的份额重新定出的规则一旦锁定，在定理的三个条件下便一直保持锁定，……"
**UNCLEAR (small).** The 它 inside the long modifier points forward to a 规则 that has not been named yet, so the reader has to hold the modifier until the head noun arrives. The one page's row 30 puts it the readable way round: 一条规则，只由它已偏向的份额重新定出. The meaning is exact against the English.
Replacement:
"以及，在无噪声时，一条规则若只由它已偏向的份额重新定出，一旦锁定，便在定理的三个条件下一直保持锁定，不论损失增长到多大，只要这损失对下一步所选出的与规则都不造成差别。"

### 4. README-ZH.md line 19 and USES.zh.md line 22, the fifth: "合成它裁决的那些判断里，谁的判断能随损失而变，何时变。"
**UNCLEAR (small).** 合成它裁决的 can be parsed with 它裁决 as subject and verb ("the judgments that compose what it rules on"), not as "its verdict". The content is exact against "whose judgment, among those its verdict is made from".
Replacements:
- README-ZH: "对评判者还要问第五件：它的裁决由一些判断合成，其中谁的判断能随损失而变，何时变。"
- USES.zh: "对评判者，还有第五件：它的裁决由一些判断合成，其中谁的判断能随损失而变，何时变。"

### 5. ONE-PAGE.zh.md line 21, glossary 锁定: "*锁定*：一条规则偏向它已选出者，每一步又由已选出者所占的份额重新定出；"
**SAYS LESS.** Line 11 says 只由它已偏向的份额重新定出, and so does row 30. The glossary on the same page leaves out 只, so a rule that also takes other inputs would seem to be covered. The page does not agree with itself here. The cold reader's F6 made this point for the front pages, and it was taken there.
Replacement:
"*锁定*：一条规则偏向它已选出者，每一步又只由已选出者所占的份额重新定出；"

### 6. ONE-PAGE.zh.md line 27, row head: "什么维持它？它所赖的失去了，对什么造成差别？"
**UNCLEAR (small).** The second question has no subject for 造成差别. Also, 它所赖的失去了 can be read actively ("what it relies on has lost [something]"). Its reading of the English "its loss" as the loss of what sustains it is right for the rows under it (the renewal ends) and for line 11 (这损失, 所赖的耗尽), so the meaning holds. The fault is only in the grammar.
Replacement:
"什么维持它？它所赖的一旦失去，对什么造成差别？"

### 7. ONE-PAGE.zh.md line 30, the example (unchanged): "假如它的规则又是由被它选中的内容所占的份额定出的，才可能是这里说的情形（不是检验过的应用）。"
**STILL LOOSE AS OLD.** The same cell now says 只由它已偏向的份额重新定出, but its example still leaves out 只 and 重新. The English cell has no example, so this point is Chinese only.
Replacement:
"假如它的规则又只由被它选中的内容所占的份额重新定出，才可能是这里说的情形（不是检验过的应用）。"

## Only stiff (meaning unchanged; optional)

- **README-ZH 19 / USES.zh 22, room.** The original "（凡有一个容许的结果……，前者是否就在对它造成差别者上被某个容许的结果胜过？）" mixes a universal 凡…就 with the question word 是否 in the middle. Clearer: "有没有余地（是否凡有一个容许的结果把某一样对它不造成差别者留得比另一个更高，就有某个容许的结果在对它造成差别者上胜过前者？）".
- **README-ZH 19, sheet.** "有这五件事[作成的一张表单]": a form is not made out of things. To match USES-EXAMPLES.zh 59: "有为这五件事所设的[一张表单]".
- **USES-EXAMPLES.zh 40.** "第三与第四件，诸定理说的是其前提成立之处随之而来的" has a dangling 的. Clearer: "第三与第四件，诸定理说的是：在其前提成立之处，随之而来的是什么".
- **README-ZH 19 / ONE-PAGE.zh 21, 30.** "对下一步所选出的与规则都不造成差别" takes a second parse. It is used the same way in all three places and in block L, so change all of them or none. Possible wording: "既不对下一步所选出的、也不对规则造成差别".
- **README-ZH 19.** "只关于动态的定理，并不决定它": the comma between subject and predicate can go.

## Found exact

- **README-ZH 19, centre sentence.** "一个选择可以一直达到它自己的标准，而某样东西却在耗减，哪怕是它赖以延续的，只要这损失对它不造成差别。" Both 它 resolve to the selection: the other reading, 某样东西, gives nonsense in both places. 这损失 gives the next sentence's 这一损失 its antecedent.
- **README-ZH 19.** "这一损失算不算数，也在生灭变化之中形成，形成于人与 AI 之中；只关于动态的定理，并不决定它". 只关于动态的定理 matches "the theorems about the dynamics alone" in the sense of 07 §1 (statements that read only the dynamics).
- **README-ZH 19 / USES.zh 22.** "什么能对它造成差别；什么对它不造成差别". Matches the settled words.
- **README-ZH 19 / USES.zh 22, room content.** "某一样" (any one of), "比另一个更高", "前者" and "某个容许的结果" match the English and `Room`; only the stiffness above remains.
- **README-ZH 19 / USES.zh 22.** "以及，若它的规则只由它已偏向的份额重新定出，它能不能锁定".
- **README-ZH 19, link text.** "[一个选择在对它造成差别者上达到最好之处，只要有余地，对它不造成差别者，任何容许的结果把它留到多低，它就有多低]". It matches block O's ending and the English.
- **README-ZH 19, ranking.** "一个排名，若其下一条规则按它排在前面的结果引来的点击重新拟合，其成效又用同样这些点击来衡量，就可能是这样的回路". 这样的回路 is as old, and was deliberately left.
- **README-ZH 19.** "这五件事".
- **USES.zh 22, the four things.** Apart from findings 2 and 4, as README-ZH.
- **USES-EXAMPLES.zh 38.** "07 §6 就六条已发表的流水线读了第一个问题，即什么能对信号造成差别". 问题 follows the English "first question" and comes before line 40, so it can stand.
- **USES-EXAMPLES.zh 40.** Apart from the stiffness above, it matches the English: "第二件由一条定理回答；……第一件是一种读法，第五件是一个经验问题".
- **USES-EXAMPLES.zh 42, 79, and table row 65.** "什么能对评判者造成差别".
- **USES-EXAMPLES.zh 43, 80, and table row 66.** "什么对它不造成差别".
- **USES-EXAMPLES.zh 46, 83, table row 69 and line 122.** "谁的判断能随损失而变，何时变（？）".
- **ONE-PAGE.zh 5.** The stated times read clearly.
- **ONE-PAGE.zh 21, glossary 耦合.** "能对一个选择者造成差别的东西；……他们也需要湖里的鱼，鱼够不够他们所需，也对他们造成差别". It agrees with line 11 (还剩多少 can make no difference, while whether the need is met does) and with 03 §1 (support couples in by threshold).
- **ONE-PAGE.zh 21, glossary 外部.** "不耦合进选择者、因而对经由其耦合的选择不造成差别的东西".
- **ONE-PAGE.zh 28.** "能对选择者造成差别的，就是它的*耦合*；……".
- **ONE-PAGE.zh 29.** "不耦合进选择者的东西，对经由这些耦合的选择不造成差别；这里称之为*外部*。……每一个最优解就把它留到多低".
  - Against the new English room row it says the same thing. Room has the same parts, one outcome higher at one condition beyond and some eligible outcome beating it. 耦合进来的东西 equals "what makes a difference" through line 28's definition, and 外部 equals "what makes none" through this cell's first sentence. "谁胜过对方，谁就排在前面，不管外部留下多少" is the rising order.
  - With 留到, the conclusion is the English "leaves what makes none as low as any eligible outcome does", given condition by condition, which is the Lean form. The glossary's 余地, with 胜过 glossed as 每一样都不低于它，至少有一样高于它, and line 11's 处处不低于…且至少一处更高 agree with it.
- **ONE-PAGE.zh 30, main sentence.** "一条规则，只由它已偏向的份额重新定出，可以*锁定*，并在定理的三个条件下一直保持锁定：此后规则和份额都不低于起点，不论损失增长到多大，只要这损失对下一步所选出的与规则都不造成差别". 此后规则和份额都不低于起点 is more than the English row says. It is kept from the old cell and is what line 11's 照旧延续 gloss says.

Note: `README.zh.md` (generated) still shows the old sentence. It is rendered from `README-ZH.md`, so this is not a finding against the text.

## Round-one findings: what became of them

`check4-chinese-check.md`:
1. Centre sentence: taken in other words, merged with the cold reader's F3 (哪怕是它赖以延续的, 这损失). Exact.
2. Room: taken in other words (某一样, 比另一个更高, 前者). Exact; only stiff.
3. Link text, 它就有多低 and 达到最好: taken exactly.
4. Lock clause: taken in other words. 那 is gone and 保持锁定 is used. The halves no longer differ, because both are now statements. Exact in meaning; see finding 3 for the forward 它.
5. 这五件事: taken exactly.
6. Row 30: taken in other words (那 gone, 保持锁定, 在定理的三个条件下). Exact. The glossary wording it noted was left, and the glossary now lacks 只 (finding 5).
7. Glossary 外部: taken exactly.
8. Row 29, 耗到 to 留到: taken exactly.
9. USES-EXAMPLES 38: taken in other words (第一个问题 kept, following the English). Defensible.
- Stiffness notes: 之处 to 若 taken; "；这里称之为" taken.

`check4-cold-chinese.md`:
- F1, room: taken in part (the second end and one condition at a time). Leaving 胜过 undefined and 余地 unglossed on the fronts is defensible: the English is the same, the settled word is 余地, and the linked one page defines both.
- F2, the fifth: taken in other words on the fronts (合成它裁决的那些判断里). Exact in meaning; see finding 4. Leaving the labels and the line-46 body short is defensible, because the English is the same and the fronts now say whose.
- F3, centre sentence: taken in other words. Exact.
- F4, link text: taken as checker 3. Not adding "没有任何容许结果胜过它" or condition by condition is defensible, because the English is the same.
- F5, long attributive: taken in other words (不论损失增长到多大，只要这损失……). Exact.
- F6, 只: taken exactly on the fronts. It was not carried to the glossary's 锁定 (finding 5) or to row 30's example (finding 7).
- F7, glossary 耦合 example: taken exactly.
- F8, 能 in label 1: taken exactly.
- F9, 这些问题下面的定理: left, with no reason given. Leaving it is not defensible (finding 2). Its proposed addition about a reading and an empirical question would say more than the English, so leaving that part out is right.
- F10, row head: taken in other words. The grammar remains (finding 6).
- F11, F12, F13, centre paragraph: left. Defensible: the settled centre is not part of this change.
- F14, USES-EXAMPLES 43 body: left. Defensible: another piece of work re-says those paragraphs.
- F15, the colon at 81: left. Defensible: the English at 70 has the colon too.
- The "更远" point at 81: left. Defensible, for the same reason as F14.

## Deliberately not taken: do the reasons hold?

- "how much it weighs in the verdict", "(argued)", the_map.py, and "such a loop" (这样的回路): the reasons hold for the Chinese too.
- "the five questions as a sheet" and 这五件事: the reason holds for README-ZH. It does not hold for USES.zh 22's 这些问题 (finding 2), which points back in the same way.
- "allowed" (容许) on the fronts and line 11 against "eligible" (合格) in the rows: the reason holds. Row 29 glosses 合格 as 可选.
- The audit paragraphs in USES-EXAMPLES: the reason holds. A Chinese reader does meet 评判者所不读之物 / 它所读者 (44, 81) right under the new labels 1 and 2, until that other work lands.
