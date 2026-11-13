*AI-written, 13 November 2026. Read only; nothing run.*

# Check 4: a cold Chinese read of the WM2 front-page sentences

Read in /Users/ren/tmp/rw/wm2/wt, in the order given: ONE-PAGE.zh.md lines 1-31; _process/navigation/README-ZH.md line 19; USES.zh.md line 22; USES-EXAMPLES.zh.md lines 38-70 and 77-84. The centre paragraph in AGENTS.md was read first, as instructed (it is English). Section 1 was written before the sheet, the English pages or the Lean were opened.

## 1. First pass: what I understood (written before opening the sheet)

### (a) The four questions for a selection and the fifth for a judge, said back

1. **什么能对它造成差别.** The things along which two courses must differ for this selection to treat them differently: its inputs, what it can register. I took "能" to mean "could make a difference", not "made a difference in this case". On the one page this is its *耦合*.
   - Recommender: list every input the ranking model and its retraining receive (clicks, dwell time, logged user history, item metadata, the features of the model). Read the feature schema and the training-data pipeline.
   - Grading rubric: list what the grader sees and what the rubric scores (the submitted text, its structure, keywords, length, the rubric's criteria).
2. **什么对它不造成差别.** Everything that is not among those. Two courses that differ only there get the same treatment. The one page calls this *外部*.
   - Recommender: a reader's time and wellbeing outside logged sessions; an author's income; anything never written into a feature.
   - Rubric: whether the student understood; what the student can do a year later; the effort or harm behind the essay.
3. **有没有余地.** Given two allowed outcomes, if one leaves more of some non-difference thing than the other, is there always an allowed outcome that does at least as well on every difference-making thing and better on one? If yes, the selection's best outcome drives every non-difference thing down as far as any allowed outcome can.
   - Recommender: take the allowed slates. For any slate that keeps more reader time, is there an allowed slate with more clicks and no less of anything else the ranker counts? Answering this needs a measurement of reader time that is taken apart from the ranker.
   - Rubric: for any allowed essay that builds more understanding, is there an allowed essay (formulaic, padded) that scores at least as high on every criterion and higher on one?
4. **它能不能锁定.** This applies where the rule is set again, each time, only from the share it already favours. Under three conditions, once the rule is locked it stays locked however large the loss grows.
   - Recommender: is the next model fitted only on clicks from items the current model ranked high, and is its success measured on the same clicks?
   - Rubric: are the exemplar essays or the revised criteria taken from essays the rubric already graded highest?
5. **谁的判断能随损失而变，何时变.** On the first pass I read "谁" as people. I took the question to be: which people (users, staff, a review board) could change the judge's verdict once the loss shows, and does that come before what is lost has run out? Only the body of question 5 in USES-EXAMPLES told me that "谁" means the readers that make up the judge (is it a pool of readers counted by kind?) and that "何时" means when a note about the loss first enters what they read.
   - Recommender: who can override the ranking (an editorial team, a complaints channel), and when do reports of authors' lost income reach them?
   - Rubric: graders or a moderation panel; does a note on lost understanding reach them before marks are fixed?

### (b) Where I stopped, reread or guessed

1. ONE-PAGE.zh l.7, "两个进程，只要在一切对这个选择造成差别之处都没有不同，选起来也就相同。" "选起来" reads at first as if the two courses do the choosing. I reread it to see that they are what is chosen.
2. ONE-PAGE.zh l.7, "这时，这个选择可以把它所赖的耗减下去，而它之中还没有一处不同。" The sentence does not say what "不同" is compared with. I guessed: compared with a course in which what sustains it is not used up.
3. ONE-PAGE.zh l.7, "对它不造成差别者，任何容许的结果把它留到多低，它就有多低". I could not tell at once whether the second "它" is the selection or the thing. README-ZH has the same clause ending "它就留到多低", where the last "它" is the selection, so the two pages say it differently.
4. ONE-PAGE.zh l.7, the parenthesis "(凡有一个容许的结果……比前者做得更好)". "前者" has to be found again, and "做得更好" does not say in what sense. The lake glossary (l.21) explains it as "每一样都不低于它，至少有一样高于它", but only later.
5. README-ZH l.19 and USES.zh l.22, "每一个把不造成差别者留得更多的容许结果". "留得更多": more than what? The one page says "比另一个更高", and here the other end of the comparison is missing. I also could not tell whether "更多" means the total of everything that makes no difference, or one thing (ONE-PAGE's table says "在外部某个缘上").
6. README-ZH l.19, "不论那对下一步所选出的与规则都不造成差别的损失增长到多大". A long attributive before "损失" that I had to parse twice.
7. README-ZH l.19, "就可能是这样的回路". README has named no loop before this sentence.
8. USES.zh l.22, "这些问题下面的定理". "下面" could mean "below on this page" or "underlying".
9. USES.zh l.22, "一条定理在那里是否成立，有待一个对应". I could not tell an "对应" of what to what.
10. ONE-PAGE.zh l.21, "*耦合*：能对一个选择者造成差别的东西；渔民读得到湖中的存量……也需要湖里的鱼。" "需要" is offered as part of the example of a coupling. The centre paragraph has just said that what sustains a selection may make no difference to it, so citing a need as a coupling confused me.
11. USES-EXAMPLES.zh l.43, "两个历史恰在经由一个形成的诸耦合而相同之时，被经由这些耦合的每一个选择同样地选择". "恰在……之时" (iff), "一个形成" and "诸耦合" all had to be decoded.
12. USES-EXAMPLES.zh l.45, "进程从其第一个读取步之后的那一步起锁定". "读取步" is not defined anywhere I read. Then "一个阈值读法，从一个与之相反的起点晚一步读取，便来回交替" I could not follow at all.
13. USES-EXAMPLES.zh l.46 and l.84, the body of question 5. Nothing links the label's "谁" to "读者池", and "时机之定理" is not said.
14. USES-EXAMPLES.zh l.81, "一个对同样诸缘更细的决策者，在其内分开得更多，却不能更远". "更远" in what? I guessed: it cannot reach anything beyond those same 缘.

### (c) Stiff or translated sentences (first pass; replacements in section 3)

Flagged: "塑造他们怎样选择，也不成为他们为之而选的"; "达到其自身之标准"; "这些问题下面的定理"; "随耦合进来者而上升之序"; "恰在……之时"; "评判者所不读之物 / 它所读者"; "什么维持它，它的失去对什么造成差别？".

### (e) Labels against their bodies (first pass)

- Labels 1 and 2 fit their bodies.
- Label 5 does not tell the reader what the body is about (see b13).
- Label 4 changes the question's form, from "能不能锁定" to "锁定可在何处形成".

## 2. After the first pass: the sheet, then the English and the homes

I read the sheet's Chinese half, then its English half, the English ONE-PAGE rows, 03 §1 (the definition "couples into"), 05 §7 (`Optimum.Room`) and 02 §9 ("Readers drawn from the selected"). No Lean file was opened; the Lean names below are the ones the chapters cite.

What I had understood against what was meant:

- **Questions 1-4.** My reading matches what was meant, with one exception. 05 §7 defines room "at a condition beyond", that is, one thing at a time. The front pages' parenthesis "留得更多" left me unsure whether it meant one thing or the total (b5). The model means one thing.
- **The tension in b10 is resolved by the home.** 03 §1: "Into a formation couple its support, by threshold, and the levels of the conditions it observes". So a need does couple in, by threshold. "还剩多少" (how much is left above the need) can still make no difference. A Chinese reader is not told this.
- **Question 5 is where I went wrong on the first pass.** 02 §9 reads the rule as a pool of readers. "Who" is the readers who are not carriers and read the loss. "When" is the step at which they first read it. The course turns exactly where they are then at least as many as the carriers. My people-reading is what the front pages, read alone, invite.

## 3. Findings

Each finding gives where, the class, what is wrong, and the exact replacement string.

### Serious

**F1. README-ZH l.19 and USES.zh l.22, "有没有余地（每一个把不造成差别者留得更多的容许结果，是否都在造成差别者上被另一个容许结果胜过？）"** — UNCLEAR, bordering on SAYS SOMETHING ELSE.
- "留得更多" has no second end ("more than what?").
- It does not say "at one thing": a reader takes it as the total of what makes no difference, while `Optimum.Room` asks this of each condition beyond.
- "胜过" is not defined on these pages.
- In everyday Chinese "余地" means leeway to spare something. A reader can take "有余地" as good news for what makes no difference, when it is the condition under which the optimum drains it.
- The English strings have the same missing end ("leaves more of what makes none").
- Replacement (both pages): `有没有余地（一个容许结果只要在某一样不造成差别者上比另一个留得多，是否总有某个容许结果在造成差别者上胜过它，即每一样都不低于它、至少有一样高于它？）`

**F2. README-ZH l.19, USES.zh l.22 and USES-EXAMPLES.zh l.46, l.84 and l.122, "谁的判断能随损失而变，何时变"** — SAYS LESS.
- On the front pages nothing tells the reader that "谁" means the readers that make up the judge (02 §9: the rule read as a pool of readers' readings). A reader takes "谁" as stakeholders or people, as I did on the first pass.
- Under the label at l.46 the body speaks only of "按种类计数的读者池" and "时机之定理", and nothing links them to "谁" and "何时".
- Replacement for the front pages: `对评判者还要问第五件：它的裁决若由一组读者的判断合成，其中谁的判断能随损失而变，何时变。`
- Replacement for the USES.zh form: `对评判者，还有第五件：它的裁决若由一组读者的判断合成，其中谁的判断能随损失而变，何时变。`
- The labels can stay short if the body of question 5 (l.46) begins: `这里的“谁”，是合成评判者裁决的读者中读到损失的那些；“何时”，是损失第一次进入他们所读之时。`

**F3. README-ZH l.19, "本论的中心：一个选择可以一直达到其自身之标准，而某样东西却在耗减，这耗减对它不造成差别。"** — SAYS LESS than the centre it names.
- The centre paragraph says that what is used up can be what sustains the selection ("这个选择赖以延续的还剩多少……这个选择可以把它所赖的耗减下去"). "某样东西" drops that.
- "达到其自身之标准" is stiff.
- The English (README-FIRST-SCREEN) has the same "something".
- Replacement: `本论的中心：一个选择可以一直合乎它自己的标准，而它赖以延续的东西却在耗减，这耗减对它不造成差别。`

### Smaller

**F4. README-ZH l.19, "这项工作在它的模型上证明了[一个选择在对它造成差别者上做到最好之处，只要有余地，对它不造成差别者，任何容许的结果把它留到多低，它就留到多低]"** — UNCLEAR.
- The two "它" in one clause point to different things.
- "做到最好" does not say best compared with what (in the home: not exceeded on the family by any eligible outcome).
- "condition by condition" is missing.
- The link's target, ONE-PAGE.zh l.7, ends "它就有多低", so the two pages differ.
- Replacement for the link text: `一个选择所选出的，若在对它造成差别者上没有任何容许结果胜过它，那么只要有余地，凡对它不造成差别的，每一样都被留到任何容许结果所能留到的最低`

**F5. README-ZH l.19, "不论那对下一步所选出的与规则都不造成差别的损失增长到多大"; the same clause in ONE-PAGE.zh, table row 5, "一条规则，每一步都只由它已偏向的份额重新定出"** — UNCLEAR (stiff). The long attributive before "损失" has to be parsed twice.
- Replacement (both places): `不论损失增长到多大（这损失对下一步选出什么、对规则怎样定出，都不造成差别）`

**F6. README-ZH l.19 and USES.zh l.22, "在它的规则每次更新都由它已偏向的份额重新定出之处"** — SAYS LESS.
- ONE-PAGE.zh l.7 and row 5 say "只由". The lock's closed form has rule and selection given by share and rule alone.
- Without "只", a reader may take a rule that also takes other inputs as covered.
- The English has the same gap ("from the share it already favours").
- Replacement: `在它的规则每次更新都只由它已偏向的份额重新定出之处`

**F7. ONE-PAGE.zh l.21, "*耦合*：能对一个选择者造成差别的东西；渔民读得到湖中的存量、各自的渔获与彼此的捕捞，也需要湖里的鱼。"** — UNCLEAR.
- The new definition drops "需要" (the old one was "读取或需要"), but the example still gives a need. The centre has just said that what sustains a selection can make no difference to it.
- The home (03 §1) reconciles the two: support couples in by threshold. The page does not say so.
- Replacement for the second clause: `渔民读得到湖中的存量、各自的渔获与彼此的捕捞；他们也需要湖里的鱼，鱼够不够他们所需，也对他们造成差别。`

**F8. USES-EXAMPLES.zh l.42 and table row 1, "什么对评判者造成差别"** — SAYS LESS than the front-page question "什么能对它造成差别". Without "能", the reader can take it as what did make a difference to one verdict. The body ("它挑选什么是这一输入的函数") means "can". The English label has the same drop.
- Replacement for the label (both places): `什么能对评判者造成差别`

**F9. USES.zh l.22, sentence 3, "这些问题下面的定理，在模型上已证明。"** — UNCLEAR. "下面" can mean "further down this page". It also reads as if each of the five rests on a theorem, while USES-EXAMPLES says question 1 is a reading and question 5's premise is empirical.
- Replacement: `这些问题所依的定理，在模型上已证明；第一问的回答是一种读法，第五问中的评判者是否满足其前提，是经验问题。`

**F10. ONE-PAGE.zh, table row 2 head, "什么维持它，它的失去对什么造成差别？"** — UNCLEAR (stiff); the respect is said.
- Replacement: `什么维持它？失去它，对什么造成差别？`

**F11. ONE-PAGE.zh l.7, "这时，这个选择可以把它所赖的耗减下去，而它之中还没有一处不同"** — STILL LOOSE AS OLD. "不同" has no second end. Not in this change set.
- Replacement: `这时，这个选择可以把它所赖的耗减下去，而在一切对它造成差别之处，都还没有任何不同`

**F12. ONE-PAGE.zh l.7, "两个进程，只要在一切对这个选择造成差别之处都没有不同，选起来也就相同。"** — UNCLEAR. "选起来" reads as if the processes choose. Not in this change set.
- Replacement: `两个进程，只要在一切对这个选择造成差别之处都没有不同，这个选择对它们也就选得相同。`

**F13. ONE-PAGE.zh l.7, "塑造他们怎样选择，也不成为他们为之而选的"** — UNCLEAR (stiff). Not in this change set.
- Replacement: `塑造他们怎样选择，本身也不成为他们选择所追求的`

**F14. USES-EXAMPLES.zh l.43, "两个历史恰在经由一个形成的诸耦合而相同之时，被经由这些耦合的每一个选择同样地选择"** — STILL LOOSE AS OLD (stiff). This body is unchanged; it is the first thing a reader meets under the new label 2.
- Replacement: `两个历史，当且仅当经由一个形成的诸耦合看来相同时，经由这些耦合的每一个选择都对它们选得相同`

**F15. USES-EXAMPLES.zh l.79, "3. **是否有余地：**"** — UNCLEAR (form). This label ends with "：", where the other four labels end with "。".
- Replacement: `3. **是否有余地。**`

### Labels in USES-EXAMPLES.zh against the paragraphs under them (e)

- **Label 1, "什么对评判者造成差别" (l.42, l.80).** The bodies fit. The intro at l.38 calls question 1 "信号读取什么". The two match closely enough not to mislead. See F8 for the missing "能".
- **Label 2, "什么对它不造成差别" (l.43, l.81).** The bodies fit once "外部" is met. At l.81, "一个对同样诸缘更细的决策者……却不能更远" leaves "更远" without its respect. Suggested: `却不能把选择伸到这些缘之外`.
- **Label 5 (l.46, l.84, table row 5, l.122).** This is where the mismatch would mislead; see F2. The table's column 3 ("一条批注扭转了裁决") and l.122 ("其他者……携带者") do say "谁". l.46 and l.84 do not.
- **Label 4, "锁定可在何处形成".** It differs from the front-page form "它能不能锁定". The body asks the front page's condition (are the exemplars taken from the loop's own past picks), so it does not mislead. In the body, "第一个读取步" is used before it is defined. That is outside this change set.

### The four questions for a sentence, on each changed Chinese string (d)

- **README-ZH 1 (centre).**
  - Respect: said (对它不造成差别).
  - Pair: the selection and what is used up are said as one relation.
  - Separateness: not assumed.
  - No "better". See F3 for what it leaves out.
- **README-ZH 2 and USES.zh 1 (the four things and the fifth).**
  - Respect: said for questions 1-4.
  - "Better": "胜过" has its respect (在造成差别者上), but "留得更多" lacks its second end and its sense (F1).
  - The fifth does not say whose (F2).
- **README-ZH 3 (the two theorems).**
  - "最好" lacks what it is compared with (F4).
  - The lock clause is exact against 02 §9 (lock kept, loss making no difference to the next selection or the rule).
- **README-ZH 4 (按它排在前面的结果).** Exact.
- **USES-EXAMPLES.zh 1 (intro: four things, then the fifth).** Exact.
- **USES-EXAMPLES.zh 2-8 (labels).** See (e) and F2, F8.
- **ONE-PAGE.zh 1 (row 2 head).**
  - Respect: said.
  - The pair is one relation (its loss, to what).
  - Stiff (F10).
- **ONE-PAGE.zh 2 (耦合 in row 3).** Exact against 03 §1 as a gloss. "选择者" is kept as a word, but it is not used as a subject facing an object.
- **ONE-PAGE.zh 3 (外部 in row 4).** Exact (03: selections through couplings select alike what differs only beyond).
- **ONE-PAGE.zh 4 (锁定 in row 5).** Exact on content against 02 §9 ("不低于起点" and "其条件"). Stiff (F5).
- **ONE-PAGE.zh 5 (glossary 耦合).** The definition is exact; the example pulls against it (F7).
- **ONE-PAGE.zh 6 (glossary 外部).** Exact.

### Checked and found exact

- README-ZH, "这一损失算不算数，也在生灭变化之中形成，形成于人与 AI 之中；诸定理陈述动态，并不决定它".
- README-ZH, "一个排名，若其下一条规则按它排在前面的结果引来的点击重新拟合，其成效又用同样这些点击来衡量".
- USES-EXAMPLES.zh l.40, the intro: four things, then the fifth; questions 2-4 answered by theorems, question 1 a reading, question 5 empirical.
- ONE-PAGE.zh row 4, "不耦合进选择者的东西，对经由这些耦合的选择不造成差别，这里称作*外部*。"
- ONE-PAGE.zh l.21, "*外部*：不耦合进选择者、对经由这些耦合的选择不造成差别的东西".
- ONE-PAGE.zh row 3, "能对选择者造成差别的，就是它的*耦合*" (as a gloss of 03 §1).
- ONE-PAGE.zh row 5, the lock content: "此后规则和份额都不低于起点" and "并在其条件下一直锁定".
- The Chinese strings match the English strings item for item on the sheet. The differences are the gaps both languages share (F1, F3, F6, F8), which are noted above.
