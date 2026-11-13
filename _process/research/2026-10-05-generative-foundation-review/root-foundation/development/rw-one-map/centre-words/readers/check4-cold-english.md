*AI-written, 13 November 2026. Read only; nothing run.*

# Check 4: a cold English read of the front sentences on what to ask of a selection

Read in the worktree /Users/ren/tmp/rw/wm2/wt, in the order given: AGENTS.md (centre paragraph), theories/becoming/ONE-PAGE.md lines 1 to 23, _process/navigation/README-FIRST-SCREEN.md line 10, theories/becoming/USES.md line 15, MAP.md lines 5 to 12, theories/becoming/USES-EXAMPLES.md lines 30 to 62, 68 to 76 and 108. I wrote down the first-pass understanding in section (a) before opening anything else. Only after that did I open the old/new sheet (/Users/ren/theories/tmp/r7/sheet/wm2/fronts-final-old-new.md) and the home of the room theorem (theories/becoming/chapters/05-COLLECTIVES.md, the anchor r-what-an-optimum-does-beyond-what-couples-in, line 181). I read no Lean and no process notes.

Classes: SAYS MORE, SAYS LESS, SAYS SOMETHING ELSE, UNCLEAR, STILL LOOSE AS OLD.

## (a) What I took each question to mean, and how I would answer it

**1. What can make a difference to it.** I read this as: which inputs or conditions, if they were different, could change what the selection picks. These are its couplings.
- *Recommender:* the features and logs the ranker is computed from: clicks, dwell time, watch history, item metadata, and the model weights while they stay fixed. I would list the model's inputs and check whether anything outside the logged input reaches the ranker.
- *Grading rubric:* the rubric's criteria as the grader applies them to the submitted text, plus anything else the grader actually sees, such as the student's name or handwriting.

**2. What makes none.** I read this as: everything that, if it changed while the inputs above stayed the same, would leave the selection's picks unchanged.
- *Recommender:* the user's later wellbeing, whether the content was true, whether its creators can keep making it, and anything not in the logs.
- *Rubric:* whether the student understood the material, whether they can do it a month later, and how long the answer took to write.

To answer it, I would take the list from question 1 and name what is left outside it.

**3. Whether there is room.** My first-pass reading of the front version: when one allowed outcome keeps more of question 2's things than another, can the selection always do better on question 1's things by choosing an outcome that keeps less of them? With room, a selection at its best pushes question 2's things as low as any allowed outcome pushes them. The home confirmed this reading, condition by condition: wherever an eligible outcome stands above another at a condition beyond, some eligible outcome beats it on the family.
- *Recommender:* among the rankings the platform allows, I would check that whenever a ranking leaves users better off later, some allowed ranking draws more clicks. If engagement bait or outrage is always on offer, there is room, and a click-optimal ranker leaves later wellbeing as low as any allowed ranking does. To answer it, I would look at the eligible set (policies, filters) and measure wellbeing apart from the clicks.
- *Rubric:* I would ask whether, for every answer that shows more understanding than another, some answer exists that scores higher on the rubric, for example a formulaic answer that hits every criterion.

**4. Whether it can lock, where its rule is set again at each update from the share it already favours.** I read this as follows. The rule's next version is computed only from the proportion of the winners it already favours. Under the three conditions on the one page, the rule then stops changing direction, and nothing that is lost can turn it.
- *Recommender:* the ranker is retrained on clicks that its own top results drew. I would trace what each retraining is fitted on and check the three conditions:
  - selection does not lower the favoured share;
  - a higher share gives a rule that is no less favouring;
  - a rule no less favouring still favours.
- *Rubric:* the rubric is revised from exemplars taken from past top-scoring answers.

**5. (judge) Whose judgment can change with the loss, and when.** On first reading I guessed this meant: inside the judge, which readers (graders, panel members, prompts) would register the loss, how many of them there are compared with those who favour the current rule, and at which step they first register it. I confirmed this only later, at USES-EXAMPLES line 108. A recommender is not a judge.
- *Rubric with a panel of graders:* I would count how many graders would notice rote answers and mark them down, and how many favour the rubric as it stands. Then I would find at which revision the noticing ones first see such answers.

## (b) Where I stopped, reread or guessed

1. **README-FIRST-SCREEN line 10 and USES line 15, the room parenthesis.** The sentence starts "(is every allowed outcome that leaves more of what makes none beaten, on what makes a difference, by another?)".
   - **Class:** UNCLEAR, and SAYS SOMETHING ELSE.
   - **What is wrong:** I could not parse it on first reading. "Leaves more" has no comparison: more than what? "Beaten ... by another" has to be carried back across two commas. "More of what makes none" reads as one total, but the home's room is condition by condition: an outcome above another at any one condition beyond.
   - **Replacement:** "(whenever an allowed outcome leaves some of what makes no difference to it higher than another allowed outcome does, does some allowed outcome beat it on what makes a difference?)"
   - **Chinese (README-ZH and USES.zh):** the same fault is in "每一个把不造成差别者留得更多的容许结果，是否都在造成差别者上被另一个容许结果胜过？". Suggested replacement: "凡一个容许结果把某样不造成差别者留得比另一个容许结果高，是否总有某个容许结果在造成差别者上胜过它？"

2. **ONE-PAGE line 17, the table row "With *room* (every eligible outcome that leaves any of what makes no difference higher than another does is beaten on what makes a difference), every optimum...".**
   - **Class:** UNCLEAR.
   - **What is wrong:** I could not parse it on first reading. I stopped four times:
     - "higher than another does is beaten" is a garden path, because "does is" collides.
     - "whatever it counts after" is opaque. Only the home's line about lexicographic orders told me it means "whatever the order ranks by once what makes a difference is tied".
     - "the rest" names a new referent with no antecedent. "The rest" of what?
     - "as low as any eligible outcome does" can mean "as low as some" or "no higher than every". The home means the least level, condition by condition.
   - **Replacement, saying the same:** "With *room* (whenever an eligible outcome leaves some of what makes no difference higher than another eligible outcome does, some eligible outcome beats it on what makes a difference), every optimum of an order rising with what makes a difference, whatever the order counts once that is tied, leaves each part of what makes no difference as low as the lowest that any eligible outcome leaves it"
   - **Also:** the same edit belongs in tools/research/navigation.py's copy.

3. **MAP.md line 9, "it asks what can make a difference to it, what makes none, whether there is room (every allowed outcome that leaves more of what makes none being beaten on what makes a difference), and, where its rule is set again...".**
   - **Class:** UNCLEAR.
   - **What is wrong:**
     - "It asks ... to it": the first "it" is the map, the second is the selection, and "its rule" could be either.
     - "Being beaten" is a dangling absolute, with no "by".
     - "More" has no comparison.
   - **Replacement:** "it asks of that selection what can make a difference to it, what makes none, whether there is room (whenever an allowed outcome leaves some of what makes none higher than another allowed outcome does, some allowed outcome beats it on what makes a difference), and, where its rule is set again only from the share of what it already favours, whether it can lock;"

4. **USES-EXAMPLES line 32, "theorems answer the second, third and fourth on their premises; the first is a reading, and the fifth is an empirical question."**
   - **Class:** SAYS MORE, made worse by the change.
   - **What is wrong:** The third question is now "whether there is room", and room is a premise of the theorem, not something the theorem answers. The same page says "Room here is an empirical question" (line 70) and "three things only the pipeline can settle: whether there is room, whether a lock can form, and whether the judge is a pool of readers" (line 49). The old third question, "can it do better on what it reads by lowering what lies beyond", sat closer to what a theorem says. So does "whether it can lock": the theorem gives conditions, and the pipeline settles whether they hold.
   - **Replacement:** "theorems answer the second, and say what follows for the third and fourth where their premises hold, which only the pipeline can settle; the first is a reading, and the fifth is an empirical question."

5. **README line 10 and USES line 15, "and, where its rule is set again at each update from the share it already favours, whether it can lock".**
   - **Class:** SAYS SOMETHING ELSE, and UNCLEAR.
   - **What is wrong:**
     - The clause "where its rule is set again ... " turns the premise into a given. USES-EXAMPLES question 4 asks that premise as the question itself ("Are the reference examples or rubric drawn from the loop's own past picks?").
     - "Only" is missing, though the one page has it ("set again only from the share"), and the lock theorem needs the rule set from the share and the rule alone.
     - "The share it already favours" reads as if the rule favours a share. I took it to mean the share of the selected that are of the kind it favours.
   - **Replacement:** "and whether its rule is set again at each update only from the share of what it already favours, so that it can lock."

6. **README line 10, "Its centre: a selection can go on meeting its own criterion while something is used up whose loss makes no difference to it."**
   - **Class:** SAYS LESS than the centre paragraph.
   - **What is wrong:** The centre says that what is used up can be what sustains the selection, and that its running down makes no difference to it *yet*, until it gives out. The README sentence drops both, so a reader takes the loss to fall only on others.
   - **Replacement:** "Its centre: a selection can go on meeting its own criterion while it uses up something, even what sustains it, whose running down makes no difference to it yet."

7. **README line 10, "The work proves, on its models, [when a selection at its best on what makes a difference to it, with room, leaves what makes none as low as any allowed outcome does]".**
   - **Class:** UNCLEAR, and SAYS LESS.
   - **What is wrong:** "When ... with room" made me look for a condition beyond room. The home proves "exactly where" room holds (`Optimum.least_iff`).
   - **Replacement:** "[that a selection at its best on what makes a difference to it leaves what makes none as low as any allowed outcome does exactly where there is room]"

8. **USES line 15, "Of a judge, a fifth: whose judgment can change with the loss, and when."**
   - **Class:** UNCLEAR.
   - **What is wrong:** In this paragraph "the loss" has no antecedent. Question 2 only names "what makes none".
   - **Replacement:** "Of a judge, a fifth: whose judgment can change as what makes no difference to the selection is used up, and when."

9. **ONE-PAGE line 18, "can lock and, on its conditions, stay locked".**
   - **Class:** UNCLEAR (minor).
   - **What is wrong:** "Its" could be the rule's or the theorem's.
   - **Replacement:** "can lock and, on the theorem's three conditions, stay locked". The same edit belongs in navigation.py's copy.

10. **ONE-PAGE line 7, the centre: "given room (wherever an allowed outcome leaves it higher than another does, some allowed outcome does better than that one on what makes a difference)".** This is outside this change set.
    - **Class:** UNCLEAR.
    - **What is wrong:** In one sentence, "it" stands for both the selection and what makes no difference to it. "That one" could be either outcome.
    - **Replacement:** "given room (wherever an allowed outcome leaves some of what makes no difference higher than another does, some allowed outcome does better than the first on what makes a difference)".

11. **ONE-PAGE line 7, "Its closed form, in which what is selected next and the rule ... both follow from the share and the rule alone, how the rule is set again being formed from the share too, so that a loss makes a difference to neither, can lock".**
    - **Class:** UNCLEAR. This is outside this change set, so I give no replacement here.
    - **What is wrong:** I reread it three times. The subject and verb ("Its closed form ... can lock") are about fifty words apart.

12. **ONE-PAGE line 9, "untold, the bed lay outside what their selection read".**
    - **Class:** STILL LOOSE AS OLD.
    - **What is wrong:** This sentence is not in the change set, but it keeps the subject-reads-object wording two paragraphs after the centre drops it.
    - **Replacement:** "untold, the bed was among what made no difference to their selection".

## (c) The four questions for a sentence, on the changed sentences

**README "Its centre: a selection can go on meeting..."** The respect is said ("to it"). The pair, a selection and what it uses up, is one relation with two ends. Separateness is shown, not assumed. Nothing is ranked. The fault is the omission in (b)6.

**README and USES, the four things.**
- Q1 and Q2: exact.
- Q3: "better" is now "beaten, on what makes a difference": the respect is said. But "more" is not said with what it is compared to, which fails the fourth question for a sentence. See (b)1.
- Q4: the respect of "share" is not said: share of what? See (b)5.
- Q5: exact, apart from (b)8 on USES.

**README, the sentence beginning "The work proves... at its best on what makes a difference to it".** "Best" is said with its respect and with what it is compared to (allowed outcomes). The "when" is loose. See (b)7.

**README, the sentence beginning "and when a rule set again from the share it already favours stays locked...".** Exact. "Makes no difference either to what is selected next or to the rule" says the two ends.

**README, the sentence beginning "A ranking whose next rule is refit to the clicks its top results draw, its success measured by those same clicks".** Exact.

**ONE-PAGE row header "What sustains it, and to what does its loss make a difference?"** Exact. The pair is said as one relation: the loss and what it makes a difference to.

**ONE-PAGE row beginning "The selections through a selector's couplings (what can make a difference to it)".** The gloss is exact. "Reach exactly what couples into it" is STILL LOOSE AS OLD: "reach" is never defined for a cold reader. I give no replacement, because the wording is from the theorem's home.

**ONE-PAGE row beginning "With *room*".**
- The respect is said, on both sides.
- "Higher than another does": the comparison is said.
- "Optimum" is said against eligible outcomes.
- The faults are the parse problems in (b)2.

**ONE-PAGE row beginning "A rule set again only from the share it already favours can lock...".** Exact, apart from (b)9.

**MAP.md, the sentence beginning "it asks what can make a difference to it".** See (b)3. It also SAYS LESS: unlike the README, MAP never says what room leads to, so a reader does not learn why to ask about it. Add after the parenthesis: "(with room, a selection at its best leaves what makes none as low as any allowed outcome does)".

**USES-EXAMPLES headings and table cells 1, 2 and 5, and line 108.** These are short labels, and the four questions for a sentence pass. See (d) for how they fit the paragraphs under them.

## (d) The USES-EXAMPLES labels and the paragraphs under them

**"What makes a difference to the judge" (line 34; line 68; table line 58).**
- The paragraph lists the prompt, and the label fits.
- No reader would be misled.

**"What makes no difference to it" (line 35; line 69; table line 59).**
- The paragraph says "lies beyond: no pick separates histories differing only there". A reader can map "beyond" to the label without being misled.

**"Whose judgment can change with the loss, and when" (line 40; line 72; table line 62).**
- Under this label, the paragraphs at lines 40 and 72 speak only of "a pool of readers counted by kind". A reader of "whose judgment" thinks of identifying persons or parts. They do not learn that the answer the theorem needs is a count: how many readers register the loss, against how many favour the rule, and at which step they first do. Line 108 says this, but line 40 does not.
- **Class:** SAYS LESS, and it would mislead a pipeline owner about what to record.
- **Replacement for the first sentence at line 40:** "The timing theorem holds for a judge that is a pool of readers counted by kind: then what decides is how many register the loss against how many favour the rule in force, and at which step they first register it ([02 §9](chapters/02-MAP.md#r-readers-drawn-from-the-selected)); whether a judge is such a pool is an empirical question."

**Question 4's label "Where a lock can form" (line 39; table line 61).** This label is not in the change set, but it now differs from the fronts' "whether it can lock". See (e).

## (e) Do the five pages say the four things the same way?

**Q1.** "What can make a difference to it" on README, USES and MAP. USES-EXAMPLES has "What makes a difference to the judge", without "can". This is a small drift, and it does not mislead.

**Q2.** Said the same way on all five pages.

**Q3, room.** Said five ways, and this drifts in substance:
- "allowed outcome that leaves more of what makes none beaten ... by another" (README, USES);
- "being beaten", with no "by" (MAP);
- "any of what makes no difference higher than another does" (ONE-PAGE table);
- "wherever an allowed outcome leaves it higher than another does, some allowed outcome does better" (ONE-PAGE centre);
- "leaving more of what the judge does not read beaten ... by some eligible output" (USES-EXAMPLES, older words).

"Allowed" and "eligible" alternate even within the one page, and a reader may take them to differ. Only the ONE-PAGE table carries the home's condition-by-condition reading. One wording is suggested in (b)1, (b)2 and (b)3. Use one word, "allowed" or "eligible", throughout.

**Q4, lock.** The wording differs across the pages:

| Page | Wording |
|---|---|
| README, USES | "set again at each update from the share it already favours" |
| MAP | "set again from the share it already favours" |
| ONE-PAGE | "set again only from the share it already favours" |
| USES-EXAMPLES | "Where a lock can form", asking whether the rubric is drawn from past picks |

"Only" belongs on all of them. The fronts state the premise as a given, while USES-EXAMPLES asks it as the question. See (b)5. If the fronts adopt (b)5, matching USES-EXAMPLES needs these labels:
- line 39 and line 71: "**Whether its rule is set again only from the share of what it already favours, so that it can lock.**"
- table line 61: "| 4. Whether its rule is set again only from the share of what it already favours, so that it can lock |"

**Q5.** Said the same way on README, USES and USES-EXAMPLES (lines 40, 62, 72 and 108).

## Checked and found exact

- README, the sentence beginning "Whether that loss counts forms within becoming too, in people and AI; the theorems state the dynamics and do not settle it": exact.
- README, the sentence beginning "and when a rule set again from the share it already favours stays locked, without noise, however large a loss grows...": exact.
- README, the sentence beginning "A ranking whose next rule is refit to the clicks its top results draw, its success measured by those same clicks": exact.
- README, the sentence "Of a judge ask a fifth: whose judgment can change with the loss, and when.": exact.
- ONE-PAGE row header "What sustains it, and to what does its loss make a difference?": exact.
- ONE-PAGE, the gloss "(what can make a difference to it)" on couplings: exact.
- USES-EXAMPLES line 32, "The four things to ask of any selection, then a fifth for a judge": the changed words are exact. The rest of that sentence is (b)4.
- USES-EXAMPLES, labels 1 and 2 at lines 34, 35, 68 and 69 and in the table at lines 58 and 59: exact for their paragraphs.
- USES-EXAMPLES line 108, "*Whose judgment can change with the loss, and when?*": exact. Its paragraph answers it.
