*AI-written, 13 November 2026. Read only; nothing run.*

# Check 6: the third text of the WM2 fronts, confirmed against the second round and the Lean

Read in the worktree /Users/ren/tmp/rw/wm2/wt: README-FIRST-SCREEN.md lines 4 and 10; USES.md lines 7 and 15; MAP.md line 9; ONE-PAGE.md lines 5, 7 and 19 to 22; review/README.md line 11; navigation.py START_PLAIN (the three pins, compared with ONE-PAGE by a read-only string match: each is in ONE-PAGE once, word for word); README-ZH.md lines 1 and 19; USES.zh.md lines 9 and 22; USES-EXAMPLES.zh.md line 40; ONE-PAGE.zh.md lines 5, 11, 21 and 27 to 30. Lean: TurningInTime.lean (module note, net, AloneOutside, constant_iff_needs_nothing, core_apart_below_need); Optimum.lean (Exceeds, Rising, Room, Least, least_iff, least_of_room, lines 545 to 609); ReadInTime.lean (module note, kept_iff, turned_iff). Also fronts-final-old-new.md, fronts-v2-old-new.md, check5-english.md and check5-chinese.md.

## What should still change

### 1. README-ZH.md line 19, the link text has no 每一样

- **Where.** README-ZH.md line 19, "[一个选择在对它造成差别者上达到最好之处，只要有余地，对它不造成差别者，任何容许的结果把它留到多低，它就有多低]".
- **Class.** SAYS LESS (small).
- **What is wrong.** The English link text took check5-english finding 3 and now says "leaves each thing that makes none as low as any allowed outcome leaves it", which is `Least` condition by condition. The Chinese was not carried along: it is still the second text's wording, which a reader can take as one amount. The page it links to says it condition by condition (ONE-PAGE.zh.md row 29, "对外部的每一个缘"), and the room parenthesis just before uses 某一样, so 每一样 matches both.
- **Replacement (the link text):** `[一个选择在对它造成差别者上达到最好之处，只要有余地，每一样对它不造成差别者，任何容许的结果把它留到多低，它就有多低]`

### 2. README-ZH.md line 1, the comment leaves out the third read

- **Where.** README-ZH.md line 1, the dated comment's last sentence, "……重写稿又经一位 AI 核对者核对，并依其所见再改。AI 写成。"
- **Class.** SAYS LESS.
- **What is wrong.** What it says of the first two rounds is accurate: the first text was read by one checker and one cold reader and rewritten from what they found; the second was read by one Chinese checker (check5-chinese.md) and changed from what it found. But the third text has been read too, by this check, and the comment does not say so. Once this report's findings are applied, "再改" will also hold for a third time.
- **Replacement, if this report's findings are applied:** `……重写稿又经一位 AI 核对者核对，并依其所见再改；三稿又经一位 AI 读者对照英文与 Lean 核对，并依其所见再改。AI 写成。`
- **Replacement, if nothing from this report is applied:** `……重写稿又经一位 AI 核对者核对，并依其所见再改；三稿又经一位 AI 读者对照英文与 Lean 核对。AI 写成。`

## Confirmed

English
- README line 10, centre sentence: true of the model. Only the level above `need` at unmarked levels makes no difference (`AloneOutside`). Whether the need is met always does (`constant_iff_needs_nothing`, `core_apart_below_need`). "For as long as how much is left makes no difference to it" says exactly that, and "is being used up" says it is still going on. The dropped clause "of what sustains it, that can last until it gives out" is said on line 4 of the same page ("go on the same way until that gives out"), so the reason for leaving it holds.
- README line 10, "Whether that loss counts": its antecedent is the using-up just said. The fifth's "as the loss grows" points back to the same thing.
- README line 10 and USES line 15, the room parenthesis: the antecedent is Room's (two allowed outcomes, a condition among what makes none, the first higher there). The consequent is `Exceeds ds o'' o` as ONE-PAGE line 7 says it. The question now reads on the first pass.
- MAP line 9: the same as a statement, exact; "from the map we [want to design]" leaves no misreading.
- ONE-PAGE line 21: the parenthesis is `Room`, the order is `Rising`, and "leaves each thing that makes none as low as any eligible outcome leaves it" is `Least`. It is a true case of `least_of_room`. The navigation.py pin is word for word the same.
- ONE-PAGE line 19 row head, line 20 row, line 22 row and their pins: as found exact in check5; the pins match.
- README line 10, the link text: `least_of_room` with "where there is room" as sufficient, condition by condition.
- README line 10, the lock clause: "named there" points to the one page just linked, and ONE-PAGE line 7 names three conditions ("under three conditions: selection does not lower the favoured share; a share not lower sets again a rule not lower; and a rule not lower than a favouring one still favours"), the premises of `lock_outlives_loss`. "Once locked", "without noise" and "however large a loss grows that makes no difference either to what is selected next or to the rule" are as in check5.
- README and USES, the fifth ("as the loss grows" / "as a loss grows"): it matches `kept_iff` and `turned_iff`. The others read with `lo` before the bound and with `lo'` from it, and nothing requires `lo ≠ lo'`, so "can change" is the right modal; "when" is the bound and the reading step. USES's "a loss" no longer needs an antecedent.
- Stated times: ONE-PAGE line 5, USES line 7 and review/README line 11 read as sentences.

Chinese
- README-ZH line 19, centre sentence: "只要那东西还剩多少对它还不造成差别" matches the English "for as long as how much is left makes no difference to it". 还不 carries the centre paragraph's "yet" (ONE-PAGE.zh line 11, 还没有一处不同). 那东西 resolves to the thing being used up. 这一损失 has its antecedent in 耗减, and "只关于动态的定理并不决定它" is exact.
- README-ZH line 19 and USES.zh line 22, the room parenthesis: it matches the English and `Room`/`Exceeds`. 在对它造成差别者上 scopes both 处处不低于 and 至少一处更高.
- README-ZH line 19 and USES.zh line 22, the fifth: "它的裁决由一些判断合成，其中谁的判断能随损失增长而变，何时变" matches the English.
- README-ZH line 19, the lock clause: exact against the English. ONE-PAGE.zh line 11 names the three conditions ("三个条件是：……"), and 《一页》 is the page's own name.
- README-ZH line 19, "有为这五件事所设的[一张表单]": reads.
- USES.zh line 22: the four things and the fifth as README-ZH. "这几件事所依的定理，在模型上已证明。" points back correctly.
- USES.zh line 9: the stated time reads.
- USES-EXAMPLES.zh line 40: it matches the English line 32 and reads.
- ONE-PAGE.zh line 27, row head: matches "to what does its loss make a difference?" and reads.
- ONE-PAGE.zh line 21, glossary 锁定: now has 只 and agrees with lines 11 and 30.
- ONE-PAGE.zh line 30, the example: now has 只 and 重新, as its cell does.
- ONE-PAGE.zh line 29 keeps 胜过. It is glossed under 余地 in the glossary (每一样都不低于它，至少有一样高于它), and check5-chinese found it exact, so it is not reopened.
- ONE-PAGE.zh line 5: the stated times read.

## The second round's findings, one line each

check5-english.md
1. Centre: taken exactly up to "to it". The last clause was left for the stated reason (line 4 says it), and that reason holds.
2. Room parenthesis (README, USES, MAP, ONE-PAGE row and pin): taken exactly.
3. "As low as any": taken in other words ("each thing that makes none … leaves it"), exact. The Chinese README link was not carried along: finding 1 above.
4. "The theorem's three conditions" on the README: taken in other words ("three conditions named there"), exact; the one page names three.
5. USES "the loss": taken in other words ("as a loss grows"; README "as the loss grows"), exact.
6. MAP "from it": taken exactly ("from the map").
7. ONE-PAGE line 7 parenthesis: left. It is outside this change set and was passed to the session that holds that line; the line is unchanged here.

check5-chinese.md
1. Comment "两轮": taken exactly, with the "并依其所见再改" addition. The third read is not yet said: finding 2 above.
2. "这些问题下面的定理": taken exactly ("这几件事所依的定理").
3. Lock clause word order: taken in other words (若只由……，一旦锁定，便在《一页》列出的三个条件下), exact, and it follows English finding 4.
4. The fifth's parse: taken in other words (随损失增长而变, which follows English finding 5), exact.
5. Glossary 锁定 只: taken exactly.
6. Row head: taken exactly.
7. Row 30 example: taken exactly.
- Stiffness, room parenthesis: taken in other words, with English finding 2's consequent (处处不低于前者、且至少一处更高), exact.
- Stiffness, the sheet: taken exactly.
- Stiffness, USES-EXAMPLES.zh 40: taken exactly.
- Stiffness, "对下一步所选出的与规则都不造成差别": left everywhere alike, as the note allowed ("change all of them or none").
- Stiffness, the comma in "只关于动态的定理并不决定它": taken exactly.
