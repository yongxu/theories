*AI-written, 13 November 2026. Read only; nothing run.*

# WM2 fronts: check of the changed Chinese sentences

Read: the old/new sheet (`fronts-final-old-new.md`); the centre paragraph in `AGENTS.md` and `ONE-PAGE.zh.md` line 7; the settled blocks in `chinese-round2.json` (C1–G); `README-ZH.md` lines 1 and 19 against `README-FIRST-SCREEN.md` lines 1 and 10; `USES.zh.md` line 22 against `USES.md` line 15; `USES-EXAMPLES.zh.md` lines 38–122 against `USES-EXAMPLES.md` lines 30–108; `ONE-PAGE.zh.md` lines 21 and 27–30 against `ONE-PAGE.md` lines 19–22; `03-KNOWING.md` at `r-selection-through-couplings`; `Optimum.lean` lines 543–610 (`Exceeds`, `Rising`, `Room`, `Least`, `least_iff`, `least_of_room`). Only `git diff --stat` was run. Nothing was edited, tested or built.

## Findings

### 1. README-ZH.md line 19, centre sentence: "一个选择可以一直达到其自身之标准，而某样东西却在耗减，这耗减对它不造成差别。"
**SAYS SOMETHING ELSE (small).** The English says "something is used up *whose loss* makes no difference to it", and the next sentence goes on with "Whether that loss counts". The Chinese takes 这耗减 from block T, so the next sentence's 这一损失 has no antecedent in the Chinese: what was named was the using-up, not a loss. Also, 它 comes right after 某样东西, so it could be read as that thing.
Replacement:
"一个选择可以一直达到其自身之标准，而某样东西却在耗减，其损失对这个选择不造成差别。"
(The next sentence, "这一损失算不算数，也在生灭变化之中形成，形成于人与 AI 之中；诸定理陈述动态，并不决定它", is exact and stays as it is.)

### 2. README-ZH.md line 19 and USES.zh.md line 22, the room question: "有没有余地（每一个把不造成差别者留得更多的容许结果，是否都在造成差别者上被另一个容许结果胜过？）"
**UNCLEAR (in both languages).** (a) Bare 不造成差别者 / 造成差别者 without 对它 reads as "what makes no difference" with nothing it makes none to. The settled wording always says 对它（不）造成差别者, and the English has "to it" in the item just before. (b) 留得更多 says "more" with nothing it is compared to. The English "leaves more of what makes none" has the same gap. `Room` compares two eligible outcomes at a condition outside the family (`o' c < o c`), and block O says it: 留得比另一个更高. The Chinese is a faithful twin of an English sentence that is itself loose.
Chinese replacement (on block O's gloss):
"有没有余地（凡有一个容许的结果把对它不造成差别者留得比另一个更高，是否就有某个容许的结果在对它造成差别者上胜过前者？）"
English replacement, for both fronts, if the owners want the pair exact:
"whether there is room (is every allowed outcome that leaves more of what makes none than another does beaten, on what makes a difference, by another?)"

### 3. README-ZH.md line 19, the "proves" sentence: "[一个选择在对它造成差别者上做到最好之处，只要有余地，对它不造成差别者，任何容许的结果把它留到多低，它就留到多低]"
**UNCLEAR.** In block O the clause ends 它就有多低, where 它 is what makes none: it is that low. The rebuilt sentence has 它就留到多低, which makes the last 它 the selection, while the 它 just before (把它留到) is what makes none. So there are two 它 with different referents in one clause, and the first 它 of the sentence (对它造成差别) is a third use. 做到最好 also drifts from O's 达到最好. Apart from that, the sentence is a faithful twin of the English: at its best on what makes a difference, with room, as low as any allowed outcome leaves it. It does not say more than `least_of_room`. The English "on what makes a difference to it" carries the rising premise loosely, and the Chinese carries it the same way.
Replacement for the link text:
"[一个选择在对它造成差别者上达到最好之处，只要有余地，对它不造成差别者，任何容许的结果把它留到多低，它就有多低]"

### 4. README-ZH.md line 19, the lock clause: "以及，在无噪声时，一条由它已偏向的份额重新定出的规则，在什么条件下一直锁定，不论那对下一步所选出的与规则都不造成差别的损失增长到多大。"
**SAYS MORE (small) / UNCLEAR.** 那 makes the loss definite ("that loss"), but nothing before it has named such a loss. The English says "a loss", and L_short says 不论对二者都不造成差别的损失增长到多大, with no 那. 一直锁定 drifts from L_short's 一直保持锁定. A smaller point: the English "proves when A, and when B" now comes out in Chinese as a plain statement for A and a 在什么条件下 for B. Each half can be defended, but the pair is no longer parallel. ONE-PAGE.zh line 30 uses 在其条件下, and using it here too would make both halves statements.
Replacement:
"以及，在无噪声时，一条由它已偏向的份额重新定出的规则，在什么条件下一直保持锁定，不论对下一步所选出的与规则都不造成差别的损失增长到多大。"
(Or, to make the halves parallel: "……一条由它已偏向的份额重新定出的规则，在其条件下一直保持锁定，不论……")

### 5. README-ZH.md line 19 near the end: "今天要用，有这五个问题[作成的一张表单]"
**UNCLEAR (small; the English has the same seam).** The paragraph now says 问四件事 … 第五件, so 这五个问题 points back with 这 to something that was never called 问题. The English "the five questions as a sheet" has the article, not a demonstrative, so it is less marked there.
Replacement:
"今天要用，有这五件事[作成的一张表单]"

### 6. ONE-PAGE.zh.md line 30: "一条规则，每一步都只由它已偏向的份额重新定出，可以*锁定*，并在其条件下一直锁定：此后规则和份额都不低于起点，不论那对下一步所选出的与规则都不造成差别的损失增长到多大（"
**SAYS MORE (small) / UNCLEAR.** This has the same definite 那 as finding 4; the English is "however large a loss grows". The rest says what the English cell says: set again only from the share it already favours, can lock, and stays locked on its conditions. 此后规则和份额都不低于起点 is kept from the old cell and agrees with the glossary's 锁定. On wording, the glossary's 锁定 still says "偏向它已选出者，每一步又由已选出者所占的份额重新定出", while this cell and C3 say 它已偏向的份额. The two agree in substance, because the favoured target is what was selected, but the words differ. The glossary was not in this change.
Replacement:
"一条规则，每一步都只由它已偏向的份额重新定出，可以*锁定*，并在其条件下一直保持锁定：此后规则和份额都不低于起点，不论对下一步所选出的与规则都不造成差别的损失增长到多大（"

### 7. ONE-PAGE.zh.md line 21, glossary: "*外部*：不耦合进选择者、对经由这些耦合的选择不造成差别的东西；"
**UNCLEAR.** 这些耦合 has no antecedent inside the glossary. The joining 、 also reads as two defining conditions. In fact the second follows from the first by the 03 theorem (`Web.selects_alike_iff`: alike through the couplings exactly when selected alike by every selection through them), and line 29 says it that way, as a predicate on the thing that does not couple in.
Replacement:
"*外部*：不耦合进选择者、因而对经由其耦合的选择不造成差别的东西；"

### 8. ONE-PAGE.zh.md line 29 (unchanged remainder): "……有余地时，对外部的每一个缘，任何合格结果能把它耗到多低，这样排序下的每一个最优解就把它耗到多低"
**STILL LOOSE AS OLD**, measured against the new English. The order premise is exact (see the confirmation below). The conclusion still says 耗到 ("drains to"), while the new English cell has replaced "drains what lies beyond as far as" with "leaves the rest as low as". `Least` is a level among the eligible outcomes, not a draining. The new README sentence and block O both say 留到多低.
Replacement:
"有余地时，对外部的每一个缘，任何合格结果能把它留到多低，这样排序下的每一个最优解就把它留到多低"

### 9. USES-EXAMPLES.zh.md line 38 (not in the change): "07 §6 就六条已发表的流水线读了第一个问题，即信号读取什么"
**STILL LOOSE AS OLD**, in both languages. Question 1 is now "what makes a difference to the judge", but this italic header still glosses it as what the signal reads. English line 30 has the same: "reads the first question, what the signal reads".
Chinese replacement: "07 §6 就六条已发表的流水线读了第一件事，即什么能对信号造成差别"
English replacement: "07 §6 reads the first question, what can make a difference to the signal, for six published pipelines"

## Item 4: the unchanged order premise in ONE-PAGE.zh line 29, against the Lean

**Confirmed.** "设选择者这样排序：谁在耦合进来的东西上胜过对方，谁就排在前面，不管外部留下多少" is `Rising` (line 549: `∀ o o', Exceeds ds o' o → better o' o`, "whatever either holds elsewhere"). 胜过 is glossed in line 21 as 每一样都不低于它，至少有一样高于它, which is `Exceeds` (line 545). The room sentence is `Room` (line 555) exactly: an eligible outcome higher than another at some condition beyond is exceeded on the family by some eligible outcome. "Whatever it counts after" in the new English (from `Rising.mono`: a lexicographic order with the family first is rising) is not said in the Chinese, but it is not excluded either. 这样排序 states a sufficient condition on the order, not the whole order. If the owners want it said, add "此后再按什么排都可以" after 不管外部留下多少. The judgment holds for the premise. It does not hold for the conclusion's verb (finding 8).

## Item 4: the other questions

- Line 28's 耦合 ("能对选择者造成差别的，就是它的*耦合*") and the glossary's ("能对一个选择者造成差别的东西") agree.
- Line 29's "不耦合进选择者的东西，对经由这些耦合的选择不造成差别，这里称作*外部*" says only the "if" direction of `Web.selects_alike_iff`, and it is scoped to selections through these couplings. It does not say more than the theorem. Read with line 28's 能 ("can"), it also stays inside the other direction (`Web.separates`: what is apart is separated by *some* selection through the couplings; a particular selection may ignore it). Exact.
- Line 30 agrees with L_short in substance (set again only from the share; stays locked whatever the loss that makes no difference to either). Its wording should follow L_short (findings 4 and 6).

## Item 5: 四件事 / 第五件 against 五个问题

- USES-EXAMPLES.zh line 59, "为上面五个问题所设的一张表单", reads consistently. The five labels are indirect questions, and the table's column head is 问题, so 五个问题 names them as the sheet uses them. It is exact to the English "A form for the five questions above".
- README-ZH line 19's 这五个问题 is the one place where it jars (finding 5).
- USES.zh line 22's "这些问题下面的定理" follows the English "these questions". It reads acceptably, because the four things and the fifth are each worded as questions (有没有…？能不能…).
- README-ZH line 1 (the comment) still records 四个问题对任何选择，评判者另有第五问 as round 4's wording. That is history of a past round, not a present claim, so it can stay.

## Stiffness (optional; meaning unchanged)

- README-ZH 19 / USES.zh 22: "在它的规则每次更新都由它已偏向的份额重新定出之处，它能不能锁定". The long 之处 clause is the corpus's usual rendering of "where", but here a conditional reads more naturally: "以及，若它的规则每次更新都由它已偏向的份额重新定出，它能不能锁定". Use this only if the corpus's 之处 convention is not binding on the fronts.
- ONE-PAGE.zh 29: "……不造成差别，这里称作*外部*" reads a little better as "……不造成差别；这里称之为*外部*。"

## Checked and found exact

- README-ZH 19: "这一损失算不算数，也在生灭变化之中形成，形成于人与 AI 之中；诸定理陈述动态，并不决定它". Exact.
- README-ZH 19 / USES.zh 22: "什么能对它造成差别；什么对它不造成差别". Exact.
- README-ZH 19 / USES.zh 22, the lock question (apart from the optional stiffness note). Exact.
- README-ZH 19: "对评判者还要问第五件：谁的判断能随损失而变，何时变". USES.zh 22: "对评判者，还有第五件：……". Both exact.
- README-ZH 19: "一个排名，若其下一条规则按它排在前面的结果引来的点击重新拟合，其成效又用同样这些点击来衡量". Exact. The README-ZH line 1 comment quotes it word for word and is exact too.
- USES.zh 22, second and third sentences. Exact (unchanged; they follow unchanged English).
- USES-EXAMPLES.zh 40: "先是对任何选择都要问的四件事，再是对评判者的第五件：第二、第三与第四件，由诸定理在其前提之下回答；第一件是一种读法，第五件是一个经验问题。" Exact.
- USES-EXAMPLES.zh 42 and 79, label "什么对评判者造成差别". Exact, and it fits both paragraphs (the prompt; the transcript).
- USES-EXAMPLES.zh 43 and 80, label "什么对它不造成差别". Exact, and it fits both paragraphs (the alike-selection theorem; 都在外部).
- USES-EXAMPLES.zh 46 and 83, label "谁的判断能随损失而变，何时变". Exact, and it fits (the timing theorem for a pool of readers).
- USES-EXAMPLES.zh 65, 66 and 69, table row heads. Exact.
- USES-EXAMPLES.zh 122: "*谁的判断能随损失而变，何时变？*". Exact.
- ONE-PAGE.zh 27, row head "什么维持它，它的失去对什么造成差别？". Exact.
- ONE-PAGE.zh 28: "能对选择者造成差别的，就是它的*耦合*；……". Exact to the English gloss "(what can make a difference to it)".
- ONE-PAGE.zh 21, glossary 耦合: "能对一个选择者造成差别的东西". Exact, and it agrees with line 28.
