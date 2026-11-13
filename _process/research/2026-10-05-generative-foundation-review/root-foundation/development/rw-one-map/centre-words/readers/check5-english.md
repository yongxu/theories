*AI-written, 13 November 2026. Read only; nothing run.*

# Check 5: the final English front sentences against their homes

Read in the worktree /Users/ren/tmp/rw/wm2/wt: AGENTS.md "What we are doing"; ONE-PAGE.md lines 7, 19 to 22; README-FIRST-SCREEN.md line 10; USES.md line 15; MAP.md line 9; USES-EXAMPLES.md lines 28 to 76 and 104 to 111 (the line numbers the task gives are off by a few: the sentence called line 49 is line 46, and the table is lines 56 to 60); navigation.py START_PLAIN; the records selection-through-couplings, what-an-optimum-does-beyond-what-couples-in and closed-capture; 07 r-what-the-dynamics-leave-open and r-coupling-closures-of-training-pipelines; 02 r-readers-drawn-from-the-selected; Optimum.lean (Exceeds, Rising, Room, Least, least_iff, least_of_room); TurningInTime.lean (module note, net, AloneOutside, constant_iff_needs_nothing, core_apart_below_need); ClosedCapture.lean (Unread, join, joinRead, join_course, Accrues, lock_outlives_loss); RuleCapture.lean (Raises, ReadsShare, Locked, turn_locked, uniform_locks); ReadInTime.lean (module note, kept_iff, turned_iff). Also both first-round reports and fronts-final-old-new.md.

## Findings: what should still change

### 1. README centre: "so long as the loss makes no difference to it"

- **Where.** README-FIRST-SCREEN.md line 10, "Its centre: a selection can go on meeting its own criterion while something is used up, even what sustains it, so long as the loss makes no difference to it."
- **Class.** SAYS SOMETHING ELSE (read as a condition); SAYS LESS than the centre paragraph.
- **What is wrong.** In TurningInTime the selection's going on has a need: the net steps only where the level is at least `need`. Whether the need is met always makes a difference. The way's class is constant only where nothing is needed (`constant_iff_needs_nothing`). The core never relates a level that meets the need to one below it (`core_apart_below_need`). What makes no difference to the way is only how much is left above the need, at unmarked levels (`AloneOutside`). So no loss of what sustains the selection "makes no difference to it" all the way through. The use-up runs only while how much is left makes no difference *yet*. The centre paragraph says this with "while nothing in it yet differs" and "until what sustains it gives out". Read as "provided that", "so long as" claims a case the model never has. Read as "for as long as", it is right, but the sentence lets a reader take the first reading. "Is used up" also reads as done, when the model has it as still going on. This is the first round's F3 and (b)6, taken without its "yet".
- **Replacement:** `Its centre: a selection can go on meeting its own criterion while something is being used up, even what sustains it, for as long as how much is left makes no difference to it; of what sustains it, that can last until it gives out.`

### 2. The room parenthesis and the ONE-PAGE room row: "beaten" / "beats" is not Exceeds as said

- **Where.**
  - README-FIRST-SCREEN.md line 10 and USES.md line 15: "(wherever one allowed outcome leaves any of what makes none higher than another does, is the first beaten, on what makes a difference, by some allowed outcome?)"
  - MAP.md line 9: "(wherever one allowed outcome leaves any of what makes none higher than another does, the first is beaten, on what makes a difference, by some allowed outcome)"
  - ONE-PAGE.md line 21, with its copy in navigation.py START_PLAIN: "some eligible outcome beats the first on what does make a difference"
- **Class.** UNCLEAR; read loosely, it SAYS LESS than Room.
- **What is wrong.**
  - The antecedent is now exactly Room's: two allowed outcomes, one condition among what makes none, and the first above the second there.
  - The consequent is `∃ o'', eligible o'' ∧ Exceeds ds o'' o`. Exceeds means: no lower at every condition of the family, and higher at one. "Beaten on what makes a difference" also reads as "higher in total" or "higher on something". `least_of_room` does not follow from those, because a rising order need not rank a total-higher outcome above.
  - ONE-PAGE line 7 already says the consequent exactly: "some allowed outcome is no lower than that one on anything that makes a difference and higher on something". The fronts should say what the one page says.
  - Parse: "wherever …, is the first beaten …?" works on a second reading. The replacement below reads on the first.
- **Replacement, README and USES (the parenthesis):** `(wherever one allowed outcome leaves any of what makes none higher than another does, is some allowed outcome no lower than the first on anything that makes a difference and higher on something?)`
- **Replacement, MAP.md (the parenthesis):** `(wherever one allowed outcome leaves any of what makes none higher than another does, some allowed outcome is no lower than the first on anything that makes a difference and higher on something)`
- **Replacement, ONE-PAGE.md line 21 and the navigation.py pin, both, the parenthesis only:** `(wherever an eligible outcome leaves any of what makes no difference to the selector higher than another does, some eligible outcome is no lower than the first on anything that does make a difference and higher on something)`

### 3. "As low as any allowed outcome does": condition by condition is not said

- **Where.**
  - README-FIRST-SCREEN.md line 10, "[that a selection at its best on what makes a difference to it, where there is room, leaves what makes none as low as any allowed outcome does]".
  - ONE-PAGE.md line 21 and its navigation.py pin, "leaves what makes none as low as any eligible outcome does".
- **Class.** SAYS LESS (small).
- **What is wrong.** `Least` holds condition by condition: at each condition of `rest`, no eligible outcome stands lower. The record says "condition by condition". "What makes none as low as" reads naturally as one amount. That reading follows from `Least` and is weaker than it. The cold reader's (b)2 raised this. It was not taken, and no reason is listed.
- **Replacement, README:** `[that a selection at its best on what makes a difference to it, where there is room, leaves each of what makes none as low as any allowed outcome leaves it]`
- **Replacement, ONE-PAGE row and pin (the end of the row):** `leaves each of what makes none as low as any eligible outcome leaves it`

### 4. README: "the theorem's three conditions" with no theorem and no conditions on the page

- **Where.** README-FIRST-SCREEN.md line 10, "and that a rule set again only from the share it already favours, once locked, stays locked on the theorem's three conditions, without noise, …".
- **Class.** UNCLEAR.
- **What is wrong.** On the first screen no theorem has been named, and the three conditions are not named. On ONE-PAGE line 22 the same words work, because line 7 names the conditions (`Raises`, `ReadsShare`, and favouring kept upward, the premises of `lock_outlives_loss`). The README sentence links only its first half to the one page.
- **Replacement:** `and that a rule set again only from the share it already favours, once locked, stays locked on three conditions [the one page names](../../theories/becoming/ONE-PAGE.md), without noise, however large a loss grows that makes no difference either to what is selected next or to the rule.`

### 5. USES: "the loss" has no antecedent

- **Where.** USES.md line 15, "Of a judge, a fifth: whose judgment, among those its verdict is made from, can change with the loss, and when."
- **Class.** UNCLEAR.
- **What is wrong.** Nothing earlier in the USES paragraph names a loss. The README has its centre sentence before the question, but USES does not. This is the cold reader's (b)8. It was not taken, and no reason is listed. In the model the loss grows by at least one a step (`Accrues`), and the others' reading changes from `lo` to `lo'` once it reaches a bound.
- **Replacement:** `Of a judge, a fifth: whose judgment, among those its verdict is made from, can change with a loss that grows along its course, and when.`

### 6. MAP: "from it" now points to the selection

- **Where.** MAP.md line 9, "…, and, where its rule is set again only from the share it already favours, whether it can lock; from it we [want to design]…".
- **Class.** UNCLEAR.
- **What is wrong.** The last "it" before "from it" is the selection ("whether it can lock"). So "from it we want to design" reads as designing from the selection, not from the map. The new clause put four references to the selection in front of it.
- **Replacement:** `; from the map we [want to design](GOALS.md#generative-alignment) an alignment`

### 7. ONE-PAGE line 7, the room parenthesis in the centre (outside this change set; it is the fronts' home)

- **Where.** ONE-PAGE.md line 7, "given room (wherever an allowed outcome leaves it higher than another does, some allowed outcome is no lower than that one on anything that makes a difference and higher on something)".
- **Class.** UNCLEAR. The cold reader's (b)10, left.
- **What is wrong.** "It" stands for what makes no difference, while the sentence's other "it"s are the selection. "That one" could be either outcome; Room needs the first.
- **Replacement (the parenthesis):** `(wherever an allowed outcome leaves any of what makes no difference to the selection higher than another does, some allowed outcome is no lower than the first on anything that makes a difference and higher on something)`

## Found exact

- README "Whether that loss counts forms within becoming too, in people and AI; the theorems about the dynamics alone do not settle it". Its second half is `ReadsOnlyDynamics.not_entails` / `admits_rival`: a statement whose truth does not change with the significance entails nothing about it either way. Its first half is the direction AGENTS.md states, and the second half keeps a reader from taking it as proved.
- README, USES and MAP, "what can make a difference to it; what makes none" (`Web.selects_alike_iff`, `separates`).
- README, USES and MAP, the lock question "and, where its rule is set again only from the share it already favours, whether it can lock". It matches `ReadsShare` (monotone in the share, whatever the rule), `uniform_locks` and `favouring_locks`, which give when it locks, and the centre's third sentence, whose words it takes.
- README and USES, the fifth "whose judgment, among those its verdict is made from, can change with the loss, and when". The pool is the verdict, the others' reading changes from `lo` to `lo'`, and "when" is the bound and the reading step (`kept_iff`, `turned_iff`, `Thinned.kept_iff`). Finding 5 is about USES's antecedent only.
- README, the room theorem's "where there is room": sufficient, as `least_of_room` gives. "At its best on what makes a difference to it" is a Frontier point of an order rising with the family.
- README, the lock sentence apart from finding 4. "Once locked" is the locked start; "makes no difference either to what is selected next or to the rule" is `Unread`, built in by `join` and `joinRead`; "however large" is `loss_grows` under `Accrues`.
- README, "its success measured by those same clicks".
- ONE-PAGE row 2 "The selections through a selector's couplings (what can make a difference to it), together, reach exactly what couples into it", and its pin.
- ONE-PAGE row 3, apart from findings 2 and 3, is now a true case of the theorem with the respect said. `ds` is what makes a difference to the selector, its couplings by row 2, and `rest` is what makes none. Dropping "whatever it counts after" leaves a case of `least_of_room`, which holds for any rising order and any `rest`. "Eligible" is the record's word.
- ONE-PAGE row 4 "A rule set again only from the share it already favours can lock and, on the theorem's three conditions, stay locked however large a loss grows that makes no difference either to what is selected next or to the rule", and its pin (`lock_outlives_loss`; the conditions named on line 7; "can lock" by `uniform_locks`).
- ONE-PAGE row head "What sustains it, and to what does its loss make a difference?".
- USES-EXAMPLES line 30, "07 §6 reads the first question, what can make a difference to the signal, for six published pipelines". 07 §6 finds the signal "a function of what its deciders read", so only that can make a difference to it.
- USES-EXAMPLES line 32, "a theorem answers the second; for the third and fourth, theorems say what follows where their premises hold; the first is a reading, and the fifth is an empirical question". It agrees with line 46 ("three things only the pipeline can settle: whether there is room, whether a lock can form, and whether the judge is a pool of readers counted by kind"), with line 70 ("Room here is an empirical question") and with the table's premise column.
- USES-EXAMPLES labels "What can make a difference to the judge" (lines 34 and 68, table row 1), "What makes no difference to it" (lines 35 and 69, table row 2) and "Whose judgment can change with the loss, and when" (lines 38 and 72, table row 5, line 108).
- MAP.md line 9 from "First a map for alignment", apart from findings 2 and 6: the lock clause, the design aim in the centre's words, and "a correspondence and not a theorem".

## The first round's findings, one line each

### check4-english-homes.md

- **F1 (room question).** Taken in other words. The comparison and the condition-by-condition reading are now exact, and "by some allowed outcome" is said. "Beaten" is still loose: finding 2.
- **F2 (ONE-PAGE row 3).** Taken in other words: "whatever it counts after" is dropped, "to the selector" is said, and "by an eligible outcome" is said. The row is now a true case; "beats" and "as low as any" are findings 2 and 3.
- **F3 (centre drops what sustains it and "yet").** Taken in part: "even what sustains it" is in, "yet" is not, and "so long as" says something else: finding 1.
- **F4 (theorems state the dynamics).** Taken in other words, "the theorems about the dynamics alone", which is exact. "(argued)" was left, and the reason holds: the second half already tells the reader the first is not a theorem.
- **F5 (lock conditions not named).** Taken in other words ("only", "once locked", "on the theorem's three conditions"). It is exact on ONE-PAGE. On the README "the theorem's" has no antecedent: finding 4.
- **F6 (note).** No change was needed, and none was made; the new "that … where there is room" is exact.
- **F7 ("at each update").** Taken in other words ("set again only from the share"), which is exact.
- **F8 (how much it weighs).** Left. The reason holds for the fronts: the old question had the same gap, and table row 5 ("how votes are counted") and line 108 give the counts. It holds only in part for "the audit's own paragraphs": lines 38 and 72 say only "counted by kind", but they belong to the other piece of work.
- **F9 ("the five questions").** Left. The reason holds.
- **F10 (the_map.py line 862).** Left. The reason holds (as old; only the word changed).
- **F11 (the_map.py line 756 and docstring).** Left. The reason holds.

### check4-cold-english.md

- **(b)1 (room parenthesis, README and USES).** Taken in other words. It now parses and is condition by condition; finding 2 remains.
- **(b)2 (ONE-PAGE row 3).** Taken in other words: the garden path, "whatever it counts after" and "the rest" are gone. "As low as any" was left, with no reason listed: finding 3.
- **(b)3 (MAP).** Taken in other words ("to the selection", "by some allowed outcome", no "more"). A new ambiguity, "from it", is finding 6. Its "MAP never says what room leads to" was left with no reason listed. MAP lists the questions as USES does, so it may stay.
- **(b)4 (USES-EXAMPLES line 32).** Taken in other words, which is exact.
- **(b)5 (lock question as a given; "only"; "share of what").** "Only" was taken. The "where" form and "the share it already favours" were left, with no reason listed. Both are the centre paragraph's own words, and line 32 says theorems answer "where their premises hold", so leaving them holds.
- **(b)6 (centre drops what sustains it and "yet").** Taken in part: finding 1.
- **(b)7 ("when … with room").** Taken in other words, "that … where there is room", which is exact.
- **(b)8 ("the loss" with no antecedent in USES).** Left, with no reason listed: finding 5.
- **(b)9 ("on its conditions").** Taken exactly, "on the theorem's three conditions", in ONE-PAGE and the pin.
- **(b)10 (ONE-PAGE line 7, "it" and "that one").** Left. It is outside the change set and still unclear: finding 7.
- **(b)11 (ONE-PAGE line 7, the long closed-form sentence).** Left, outside the change set.
- **(b)12 (ONE-PAGE line 9, "the bed lay outside what their selection read").** Left, outside the change set. It is still the old shape and still loose as old.
- **(d) (line 38's counts).** Left. The reason holds ("another piece of work re-says them").
- **(e) ("allowed" against "eligible").** Left. The reason holds (the rows keep their records' word).
- **(e) (label "Where a lock can form" against "whether it can lock").** Left, with no reason listed. It is not in the change set, and the difference does not mislead.
- **(e) (USES-EXAMPLES label 1 without "can").** Taken: the label is now "What can make a difference to the judge".
- **The not-taken item "such a loop".** As old. The reason holds.
