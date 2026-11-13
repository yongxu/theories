*AI-written, 13 November 2026. Read only; nothing run.*

# WM2 fronts, English: the new sentences against their homes

I read these files in the worktree /Users/ren/tmp/rw/wm2/wt: the centre paragraph (AGENTS.md, ONE-PAGE.md line 18), README-FIRST-SCREEN.md line 10, USES.md line 15, MAP.md line 9, ONE-PAGE.md lines 30 to 33, USES-EXAMPLES.md lines 32 to 108, navigation.py lines 450 to 465, the_map.py around lines 59 to 80, 388 to 396, 756 and 862, web.json and cards.json (counted with a read-only script). I also read the homes: 03 r-selection-through-couplings, 05 r-what-an-optimum-does-beyond-what-couples-in, 02 r-closed-capture and r-readers-drawn-from-the-selected, 07 r-what-the-dynamics-leave-open, the three records, and Optimum.lean (Exceeds, Rising, Room, Least, least_iff, least_of_room), RuleCapture.lean (Raises, ReadsShare, Locked, locked_stays, uniform_locks), ClosedCapture.lean (Unread, join, joinRead, join_course, Accrues, lock_outlives_loss, turned_by_loss) and ReadInTime.lean (module note, kept_iff, turned_iff).

Each finding gives where, the class, what is wrong, and the exact replacement.

## Findings

### F1. The room question: "leaves more" than what, and beaten by what (README, USES, MAP)

- **Where.** README-FIRST-SCREEN.md line 10, "Of any selection, a reward, a judge, ..."; USES.md line 15, "Of any selection, whether a reward, ..."; MAP.md line 9, "it asks what can make a difference to it, ...".
- **Class.** UNCLEAR. Read the wrong way, it SAYS LESS.
- **What is wrong.** `Room ds rest eligible` says this: for eligible o and o', and a condition c in `rest` with `o' c < o c`, some eligible o'' exceeds o on `ds`. The premise compares two allowed outcomes, condition by condition. "Leaves more of what makes none" names neither the second outcome nor "at some condition". A reader can take it as "more in total than some other outcome". That premise is weaker than Room, and `least_of_room` does not follow from it, because Least is condition by condition. MAP.md also drops "by another", and the theorem needs o'' to be eligible. ONE-PAGE line 18 ("wherever an allowed outcome leaves it higher than another does, some allowed outcome does better than that one on what makes a difference") and ONE-PAGE row 3 ("leaves any of what makes no difference higher than another does") already say it exactly.
- **Replacement, README and USES** (the parenthesis only): `(is every allowed outcome that leaves any of what makes none higher than another allowed outcome does beaten, on what makes a difference, by an allowed outcome?)`
- **Replacement, MAP.md** (the parenthesis only): `(every allowed outcome that leaves any of what makes none higher than another allowed outcome does being beaten, on what makes a difference, by an allowed outcome)`

### F2. ONE-PAGE row 3 and its pin: "what makes a difference" and "whatever it counts after" clash

- **Where.** ONE-PAGE.md line 32, "With *room* (every eligible outcome that leaves any of what makes no difference ...". The same string is pinned in navigation.py line 460 (START_PLAIN, what-an-optimum-does-beyond-what-couples-in).
- **Class.** SAYS SOMETHING ELSE (UNCLEAR at least).
- **What is wrong.**
  - In the record, `ds` is "what couples in", a family fixed by the selector's couplings. "Whatever it counts after" (record law 3, `Rising.mono`) lets the order also count the beyond, as a tie-breaker. That stays consistent because the family is not defined by the order.
  - The new words leave "what makes a difference" without a "to what". The nearest reading is "to the order". On that reading "whatever it counts after" contradicts the sentence: what a lexicographic order counts after does make a difference to it, so it is not "the rest".
  - Row 2, one line above, glosses couplings as "what can make a difference to it [the selector]". Saying "to the selector" makes the sentence agree with its record and with row 2.
  - "Is beaten" also drops "by an eligible outcome", which Room needs.
- **Replacement, in both ONE-PAGE.md and navigation.py:** `With *room* (every eligible outcome that leaves any of what makes no difference to the selector higher than another does is beaten, on what makes a difference to it, by an eligible outcome), every optimum of an order rising with what makes a difference to the selector, whatever the order counts after, leaves the rest as low as any eligible outcome does`

### F3. README centre sentence drops "what sustains it" and "yet"

- **Where.** README-FIRST-SCREEN.md line 10, "Its centre: a selection can go on meeting its own criterion while something is used up whose loss makes no difference to it."
- **Class.** SAYS LESS.
- **What is wrong.**
  - The centre paragraph says that what is used up is what sustains the selection: "How much is left of what sustains the selection can be among what makes no difference to it; then the selection can use that up while nothing in it yet differs". It also says this goes on until what sustains it gives out.
  - The README says only "something", and says flatly that its loss "makes no difference to it". It drops "yet", which carries the running down to the point where the loss makes all the difference.
  - The sentence no longer says that the selection draws on its own support. That is the centre's force.
- **Replacement:** `Its centre: a selection can go on meeting its own criterion while it uses up what sustains it, how much of that is left making no difference to it yet.`

### F4. "The theorems state the dynamics and do not settle it": the restriction is lost

- **Where.** README-FIRST-SCREEN.md line 10, "Whether that loss counts forms within becoming too, in people and AI; the theorems state the dynamics and do not settle it".
- **Class.** UNCLEAR. STILL LOOSE AS OLD in part: the old non-restrictive clause "which read only the dynamics" had the same reach.
- **What is wrong.**
  - 07 §1 (`ReadsOnlyDynamics.admits_rival`, `not_entails`) is about statements that read only the dynamics: their truth does not change with the significance. Those statements do not settle whether the loss counts.
  - The work also has theorems that take a significance or an order as a hypothesis (07 §4, §7). "The theorems state the dynamics" says of all of them what 07 proves only of that class.
  - 07 also warns that the result "shows non-entailment by the represented dynamics, not that becoming leaves significance undetermined". "Forms within becoming too" is the argued thesis (08), not that theorem. The link to 07 §1 supports only the second half of the sentence, and the sentence does not say how far its first half has been seen.
- **Replacement:** `Whether that loss counts forms within becoming too, in people and AI (argued); what reads only the dynamics does not settle it`

### F5. README "The work proves, on its models, ... when a rule ... stays locked": the conditions are not named

- **Where.** README-FIRST-SCREEN.md line 10, "and when a rule set again from the share it already favours stays locked, without noise, however large a loss grows that makes no difference either to what is selected next or to the rule."
- **Class.** SAYS LESS. It is UNCLEAR whether the named condition is enough.
- **What is wrong.**
  - "Proves when" promises the conditions. `lock_outlives_loss` takes these:
    - `Raises`: selection under a favouring rule does not lower the share;
    - `ReadsShare`: monotone, a share not lower sets again a rule not lower;
    - `upper`: a rule not lower than a favouring one favours;
    - `Accrues`: the loss grows by at least one a step;
    - a start that is already `Locked`.
  - The sentence names only "set again from the share it already favours". Read as the condition, that is not enough: a rule set against the share (`RuleCapture.against_not_rising`) does not ratchet.
  - "Stays locked" carries the locked start only by implication.
  - Nothing is named that the theorem does not need. "Makes no difference either to what is selected next or to the rule" is built in through `join` and `joinRead`, and `join_course` uses it. "Without noise" describes the model and is not a premise.
  - ONE-PAGE line 18 names the three conditions, and the ONE-PAGE row says "on its conditions". The README sentence should say "on its conditions" or name them.
- **Replacement:** `and when a rule set again only from the share it already favours, once locked, stays locked on three conditions, without noise, however large a loss grows that makes no difference either to what is selected next or to the rule.`

### F6. README room clause: "when" holds for any rest, not only what makes none

- **Where.** README-FIRST-SCREEN.md line 10, "[when a selection at its best on what makes a difference to it, with room, leaves what makes none as low as any allowed outcome does]".
- **Class.** Exact as a sufficient condition (`least_of_room`: Rising plus Room gives Least for every Frontier point).
- **Note, not a fault.** `rest` in Optimum.lean is any list of conditions. The sentence applies it to what makes none, and that is a case of the theorem. Nothing is named that the theorem does not need: "at its best on what makes a difference to it" is Rising plus Frontier, and "with room" is Room.

### F7. "Where its rule is set again at each update": "update" can be read as every step

- **Where.** README line 10 and USES.md line 15, "and, where its rule is set again at each update from the share it already favours, whether it can lock".
- **Class.** UNCLEAR.
- **What is wrong.** In Pace and RuleCapture the rule is set again only at the steps of a schedule (`reads : Nat → Bool`). At other steps it is kept. `uniform_locks` needs two such steps. "At each update" can be taken as each selection step. MAP.md's form, "where its rule is set again from the share it already favours", has no such problem.
- **Replacement, README and USES:** `and, where its rule, whenever it is set again, is set from the share it already favours, whether it can lock`

### F8. The fifth question: who and when, but not how much it weighs

- **Where.** README line 10 and USES.md line 15, "whose judgment can change with the loss, and when". The same words are in the USES-EXAMPLES labels and in USES-EXAMPLES line 108.
- **Class.** SAYS LESS. STILL LOOSE AS OLD: "who reads the loss, and when" had the same gap.
- **What is wrong.** `ReadInTime.kept_iff` and `turned_iff`, and `Thinned.kept_iff` and `turned_iff` in 02 §9, decide whether the lock is kept or turned by counts at the step of the reading. The test is `x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo'`, or "the carriers at least as many as the others when the loss is read". The question names who and when, not how many or how much. "Whose judgment can change" fits the others among the readers, whose reading changes from `lo` to `lo'`.
- **Replacement (optional, all places):** `whose judgment can change with the loss, how much it weighs in the verdict, and when`

### F9. "The five questions as a sheet"

- **Where.** README line 10 link text "the five questions as a sheet". USES-EXAMPLES.md line 50, "A form for the five questions above".
- **Class.** UNCLEAR. These lines are not in the change set but sit next to it.
- **What is wrong.** The change set says "four things to ask ... a fifth" so that "the four questions" stays free for the questions of a sentence. "The five questions" stays as a name for the same items, and it sits close to the word that was moved away.
- **Replacement, README:** `the five things to ask as a sheet`. **Replacement, USES-EXAMPLES:** `A form for the five things to ask above`.

### F10. the_map.py line 862: "It concludes none of the four marks of the course itself"

- **Class.** UNCLEAR. STILL LOOSE AS OLD.
- **What is wrong.** In cards.json, 50 theorems with `by_outside` true have form `tie` and carry a mark: 19 lasts sufficient, 3 lasts exact, 1 lasts necessary, 17 ends, 7 begins, 2 changes, 1 absent. So they do conclude a mark, of a course with the given changed. The tool leaves them out of every square (`summary`: `general` excludes `outside`). "Of the course itself" saves the sentence only on a careful reading.
- **Replacement:** `It may conclude one of the marks, but of a course with that given changed, not of the course itself, and fills no square.`

### F11. the_map.py line 756: "the number of general theorems that conclude it"

- **Class.** STILL LOOSE AS OLD. It is small.
- **What is wrong.**
  - "General" in `summary` is every theorem not `outside` whose strength is not `witness`. That includes strength `necessary` ("needed for it", `HOW`), and one such `lasts` theorem is not `outside`. A theorem stating a condition needed for lasting does not conclude that something lasts.
  - "The four marks (begins, lasts, changes, ends)" matches `MARKS` and the four columns. web.json's `marks` holds five, with `absent` ("does not begin"). The 35 `absent` theorems go to "Other forms". The parenthesis makes the page line exact, but the module docstring (line 6, not changed) says web.json names "the four marks".
- **Replacement, line 756 (optional):** `Under each of the four marks (begins, lasts, changes, ends) stands the number of general theorems that conclude it or state a condition needed for it;`
- **Replacement, docstring line 6:** `the four marks and the mark of not beginning`

## Checked and found exact

- **03 selection (question a, "what can make a difference to it; what makes none").** The question matches `Web.selects_alike_iff` and `Web.separates`. What can make a difference to some selection through the couplings is exactly what couples in. Nothing beyond the couplings makes a difference to any of them. "Can" carries 03's remark that a particular selection may ignore what its couplings carry. A minor ambiguity remains: "what makes none" is the complement of "what can make a difference", not of "what makes a difference". `what cannot` would be tighter, but this is not a fault.
- **ONE-PAGE row 2**, "The selections through a selector's couplings (what can make a difference to it), together, reach exactly what couples into it". It agrees with record law 2 and with its pin, navigation.py line 459.
- **ONE-PAGE row 4**, "A rule set again only from the share it already favours can lock and, on its conditions, stay locked ...". It agrees with record laws 3 and 6, with the record headline ("a loss the loop does not read leaves it locked however large it grows") and with `lock_outlives_loss` (Unread built in by `join`/`joinRead`; "however large" by `loss_grows`). The pin, navigation.py line 461, matches.
- **ONE-PAGE row head**, "What sustains it, and to what does its loss make a difference?". It fits its four rows: row 1 (05) to what depends on the renewal; row 2 to the selector only through what couples in; row 3 not to the order (the drain); row 4 not to the rule. "Its loss" is short for "the loss of what sustains it". That is clear from the first half.
- **README room clause** (F6): exact as sufficient.
- **USES-EXAMPLES labels.**
  - "What makes a difference to the judge" (both audits, table row 1): fits the paragraphs on the prompt or transcript as the function's input.
  - "What makes no difference to it" (both audits, table row 2): fits "whatever never enters the prompt ... no pick separates histories differing only there" and the second audit's 03 theorem.
  - "Whose judgment can change with the loss, and when" (both audits, table row 5): fits. The paragraphs name the timing theorem for a pool of readers, and the table column asks how a verdict is formed and when a note of the loss enters. At line 108 it fits too: the others' late reading, and step 3 in the witness. No label says something its paragraph does not answer.
  - "The four things to ask of any selection, then a fifth": fits the sentence after it.
- **README line 10**, "its success measured by those same clicks": no fault.
- **Old shape.** None of the changed English sentences keeps "reads", "lies beyond", "outside" or "cannot see" for a selection. In the_map.py, "changed from outside" is about a model's givens, not a selection. The old shape stays in the USES-EXAMPLES paragraphs left on purpose ("what the judge does not read", "lies beyond", "drains what lies beyond") and in the label "Where a lock can form", which was not changed.
- **The four questions for a sentence.**
  - F1 fails "is 'better' said with what it is compared to": "more" has no second term.
  - F2 fails "is the respect said": "makes a difference" has no "to what", which F2 supplies.
  - F3 leaves out what the loss is of, so the pair (selection and what sustains it) is not said as one relation.
  - The other changed sentences pass.
