*AI-written (Claude Fable 5.2), by one reader set to refute, 18 November 2026; no person has checked it. Read whole: both diffs, the page's lines 1 to 30 and line 17, the note above and below its correction, `Dependence.lean`, `Horizon.lean`, `RelationalRenewal.lean`, `OWED-CORRECTIONS.md`. Read in part, at the statements named: `RenewalFlow.lean` (1-60, 255-470), `Renewal.lean` (20-140), `Labelled.lean` (545-570), `Retaining.lean` (28-48, 340-375, 488-546), `Continuation.lean` (225-255), `Flow.lean` (270-300), `Admission.lean` (372-395, 507-509, 625-640), `RegimeMargin.lean` (1-70, 249-265, 770-810, 2105-2125, 2420-2432, 2660-2730), `LineOnAStockCases.lean` (1-110, 150-215), `Joint.lean` (673-735), `LabelledRoles.lean` (171-178), `Space.lean` (10-30), `truth.md` (head and closing list), `page-claims.md` (head and the lines on the count), `dig-readers-2.json` (two passages); the pickle by script. Not read at all: any proof beyond what a statement's reading needed, `unending_iff_holds`, `breaks_beyond`, `not_arises_of_unchanged`, `level_kept`, `Pair.own_not_joint`, `Coupled.ends_together`, `Amounts.lean`, `LineageRegimes`, and the 71 counted theorems other than those named below. Nothing was built or run; no file but this one was written.*

# The correction of 18 November, read to refute

`B/` is the package folder, `RR` is `lean/deeper/RelationalRenewal.lean`. "Page" is `_process/DIRECTION.md` as changed; "note" is the dig's `NOTE.md`, its section from "## Correction, 18 November 2026".

**Count: 2 MUST, 14 LESSER.** One thing outside the count: the literal word `READERLINE` stands in both head notes (page line 3, note line 38) and has to be replaced before either lands.

How MUST and LESSER are used here: MORE or false is MUST; LESS is LESSER.

## MUST

### M1. "the two ways … are named … on October's web" is a reading told as a statement (MORE)

Quoted, four places:
- page line 9: "They are named and sorted on October's web"
- page line 73: "And on the web, where the two ways are named"
- page line 3: "found the two ways named on October's web"
- note: "**What the note left out: the two ways are named on October's web.**"

"The two ways" are the page's own, two lines above: "a way of selecting that uses up what it or others rest on and can no longer be turned, and a way that keeps remaking what it rests on". What the Lean names is `Web.RenewingIn` and `Web.ConsumingIn` (`B/Dependence.lean:166-170`). That these are the two ways is not stated by any Lean statement, and the definitions come apart from the page's two ways on built webs the Lean itself has:

- **Consuming has no selecting and no turning in it, and needs nothing used up.** `Unmet.consumed_without_loss` (`B/Dependence.lean:386`): the level is 0 at every step, a dormant formation needs 1 and never has it, nothing changes, no dependence is ever broken, and the drawer is consuming. So too `NewNeed.never_met_not_undermining` (:438), `FallingNeed.never_met_not_undermining` (:505), `Gap.lapse_starts_afresh` (:688): consuming over the run, undermining at no step. The module's account says it (:34-36): "Consumption, as inherited, does not require that the dependence it concerns was ever met."
- **Renewing does not say the formation remakes anything.** `RenewingIn f` asks only that needs on the conditions `f` takes part in stay met, by whatever keeps them so. A formation that requires and draws on nothing is renewing. A formation that draws a level down to nothing is renewing if no formation ever requires that condition (`Renewed` is then empty). And `Horizon.Renewable.whole_run_includes_overdraw` (`B/Horizon.lean:158`): for every `h` a run that draws two where one is renewed at every step before `h` is renewing.
- `B/Space.lean:14-23` records the identification as a choice made on delegation in October, of "generative" and "degenerative", "read … at the level of formations as renewing and consuming", inside "an AI reading". The page before this change kept the distance: "what they conclude, renewing and consuming".

This also bears on point (7): told as it is, the page says the goal's two things have Lean definitions with 71 theorems on them.

Replacement, page line 9: "The nearest the Lean has to them is on October's web, a model of formations (goings-on) that require and draw on shared conditions, each condition with a level: two classes of a formation in a course, called renewing and consuming there. That they are the two ways is our reading, first taken in October. The web has no selecting and no turning; its renewing says that needs stay met, not that the formation remakes anything; its consuming does not ask that the need was ever met."
Page line 73: "And on the web, where renewing and consuming are defined, …"
Page line 3: "… found renewing and consuming, which we read as near the two ways, defined on October's web, which this page had not told."
Note heading: "**What the note left out: renewing and consuming are defined on October's web.**"

### M2. "The correction appended to the dig's record gives each change with its source" is not so (false as far as the files show)

Quoted, page line 3: "The correction appended to the dig's record gives each change with its source." And page line 73: "a correction appended to it on 18 November tells where it and this page said more or less than the Lean".

The appended section's lists are of the note only ("What the note left out", "Where the note says more", "Where the note says less"). For the page it points to the truth reader's report. Two of the page's changes have no entry in the section:
- the sentence on `RegimeMargin.rises_by_draw`: the section does not name it. Its source is the coordinating session's partial read (`round17/OWED-CORRECTIONS.md`, first list, item 2: "its own such point"), not the truth reader's list (`truth.md` items 14 to 26 do not have it).
- the premises added to the second of the four things (whole numbers, finitely many, constant draws, rising, a band): source `truth.md` item 21; the section has nothing on it, since the note already told those premises.

The head note also names two sources where the note's opening names four.

Replacement, page line 3: "The correction appended to the dig's record tells what the note left out and where it said more or less; the list for this page is at the end of the reader's report filed beside it (`truth-reader-2026-11-18.md`), and the change to the sentence on `RegimeMargin.rises_by_draw` comes from a third AI session's partial read of statements."
Page line 73: "(… and a correction appended to it on 18 November tells where it said more or less than the Lean; the list for this page is in the reader's report beside it)".

## The seven points

### (1) The two definitions in plain words

Lean (`B/Dependence.lean:141-170`): `Kept t g c` is `need t g c ≤ level t c ∧ need t g c ≤ level (t+1) c`. `Renewed c` is: for every step `t` and formation `g` with `requires t g c`, `Kept t g c`. `RenewingIn f`: for every `t`, `c` with `requires t f c ∨ draws t f c`, `Renewed c`. `Consumed c`: some `g`, `T` with `requires T g c` and `level t c < need T g c` at every `t > T`. `ConsumingIn f`: some `t`, `c` with `draws t f c` and `Consumed c`.

**L1 (LESSER, LESS).** "every dependence on it met at each step and at the next". Two places where a careful reader and the Lean come apart:
- *The next step is held to this step's need.* Web: one formation requires `c` at every step, need 2 at step 0 and 1 from step 1; level 2 at step 0 and 1 from step 1. At each step the dependence then holding is met. `Kept 0` fails (2 ≤ 1 is false), so nothing that takes part in `c` is renewing. The module says so (:17-19): "the reading counts the fall against the dependence as it stood when the step began". The consuming sentence has "as it stands at one step"; the renewing sentence has no such words.
- *Only steps at which the dependence holds.* "met at each step" can be read as every step of the course. The Lean asks nothing at a step where `requires` does not hold.
Replacement: "There a formation is renewing where, on every condition it requires or draws on at any step, every dependence of any formation, at each step at which it holds, is met at that step and, as it then stands, by the level at the next".

**L2 (LESSER, LESS).** "it is consuming where it draws on a condition some dependence on which, as it stands at one step, is met at no later step". As the Lean word for word. Left out, and a reader is misled without it: (a) the dependence need not have been met at that step or ever (`Unmet.consumed_without_loss`, :386; the definition's own docstring, :153-154, says so and names `Lost` for the stronger thing); (b) the step of the drawing and the step of the dependence are unrelated: one draw at step 0 and a loss made by others from step 100 make the drawer consuming, as does drawing only after the loss; (c) `draws` records that a formation draws, not how much, and no premise ties the levels to it (:21-23), so consuming does not say the drawing lowered anything (`Pinned`, account :70-74). Since the page's first way is "uses up", (a) and (c) are what a reader would not guess.
Replacement, added after the sentence: "The dependence need not have been met at that step or ever, the drawing may come at any step before or after, and the web does not say how much is drawn."

*Vacuous cases.* A formation that requires and draws on nothing is renewing; so is one never active; so is one drawing on a condition no formation ever requires. The page's sentence gives the same answer as the Lean on each. It does not mislead about the definition; what misleads is calling the class one of the two ways (M1).

**L3 (LESSER, LESS).** "Each is said of a whole course." Right: `Web F C` is the course over all steps; `RenewingIn` quantifies over every step and `ConsumingIn` over every step after one. Left out: the same file has the classes of a single step, `RenewingAt` (:294), `BreakingAt` (:304), `UnderminingAt` (:323), with laws that tie and separate the two grains: whole-run renewal includes every active step (`renewing_at_active`, :348); an event within renewal is not undermining (:338); within renewal at each of its own steps and not renewing in the run (`Dip.renewing_at_each_step_not_in_run`, :865). The page's aim says "at which grain". Telling only the whole-course class says less than the Lean has on that.
Replacement: "Each is said of a whole course; the same file has readings of a single step (within renewal, breaking, undermining), and the two grains differ both ways."

### (2) "On any web the two exclude each other, and two built courses are neither"

- `Web.renewing_not_consuming` (`B/Dependence.lean:222`): `RenewingIn f → ¬ ConsumingIn f`, any web, the same formation. AS THE LEAN. **L4 (LESSER).** It is of one formation: one web can hold a renewing formation and a consuming one. "of one formation" would close that.
- "one on a level that alternates": `SupportGatedWebs.fluctuating_neither` (`B/RenewalFlow.lean:316`; `RR:217`). Level 1, 0, 1, 0, …; the one formation requires and draws on it, need 1. AS THE LEAN.
- "one whose loss is made good and stays so": `SupportRecovery.recovered_web_neither` (`B/RenewalFlow.lean:458`), with `supported_pulse_recovers` (:426): level 2, 1, then at least 2 from step 2. The statement is of the drawer (`.focal`); the second formation is not in it. AS THE LEAN, "courses" standing for a formation in each.
- "Each is said of a whole course": right of both theorems; see L3.

### (3) `prefix_does_not_decide` and the idea's sentence

Statement (`B/Horizon.lean:108-113`): for every `h` there are two runs of `Renewable.process` (`B/Labelled.lean:552`: the state is the one level, the action the amount drawn, one unit renewed a step) with (i) `AgreeUpTo h` (:100): the same states at every step up to and including `h`, the same actions at every step before `h`; (ii) the amount drawn is 2 at every step before `h` (stated of the consuming run, so of both by (i)); (iii) at every step before `h` the drawer's event is `RenewingAt` in both runs; (iv) the drawer is `RenewingIn` on the first run's web; (v) `ConsumingIn` on the second's.

"the same up to it" is fair: in this process the level and the draw are the whole of a run, so every reading of the web agrees through `h`.

**L5 (LESSER, LESS; the nearest of the lesser ones to a MUST).** "for every horizon there are two runs the same up to it, of which one is renewing and the other consuming … We take that to show part of the idea's sentence that the two can look alike until late; it does not have that sentence's 'because'."
Conjunct (ii) is left out, and without it a reader takes the renewing run to stay within what is renewed. It does not: before the horizon both runs draw one more than is renewed, from a start high enough to bear it, and differ only in what is drawn after. The module says "The work is done by including every renewing run: the renewing run itself draws beyond renewal before `h`, from a stock that absorbs it" (:20-22), and `amount_reading` (:170) shows that a reading of amounts tells every one of those draws in both runs. So what is shown is that no finite stretch settles the whole-course class, with the level in full view in both runs. The page's source said more than the page kept: `OWED-CORRECTIONS.md` has the page's reader finding that the theorem "has neither the idea's 'from inside' nor its 'because'". The page kept only "because".
Replacement: "In one process built as an example, for every horizon there are two runs the same up to it, both drawing one more than is renewed at every step before it, of which one is renewing and the other consuming; they differ only in what is drawn after (`Horizon.Renewable.prefix_does_not_decide`). We take that to show part of the idea's sentence that the two can look alike until late: no stretch of a course settles which it is. It has neither that sentence's 'from inside', the level being in full view in both, nor its 'because'."

### (4) The counts

Recount on `constants2.pickle` (58,833 constants, 22,796 theorems, 406 modules): theorems whose conclusion heads (`hc`) include `Becoming.Web.RenewingIn` or `Becoming.Web.ConsumingIn`: **71, in 17 modules**. `RenewingIn` 37 in 12, `ConsumingIn` 50 in 15. The figure stands.

What the count counts: a theorem is in it if either name heads any part of its conclusion, a conjunct of a built example's theorem included. By the dump's codes: 41 have a class concluded somewhere in the conclusion, 19 have it only inside an equivalence, 10 only denied, and 1 is none of the three.

**L6 (LESSER; strictly the sentence is false of one theorem).** "71 theorems in 17 modules conclude one or the other, deny it, or say exactly where it holds, at least 21 of them of every web or world."
- `LabelledRoles.Renewable.no_exact_finite_reading` (`B/LabelledRoles.lean:173`) concludes that no reading settled by the first `h` steps holds exactly where renewing does. It does not conclude, deny or say where the class holds.
- "at least 21 … of every web or world": 21 by name (`Web.`, `World.`, `ModelStatements.`); I opened only those in `Dependence.lean`. Of the 21, 18 are equivalences that carry a class across another reading (static, renaming, roles, re-identification, along itself, kept, survives), 2 are denials (`renewing_not_consuming`, `RenewingInWithin.not_consuming`), and 1 concludes a class (`Web.ConsumingThrough.consumingIn`). By this count no theorem stated of every web concludes renewing. The other 50 are of built courses or of the one family. The page's source had the rest ("about a dozen hold of every law of a family or every run of one built process, and the rest of single built courses"); the page dropped it. Standing alone, "71 theorems in 17 modules" reads as ground covered (point 7).
- The laws of the fixed pair told just before are not among the 71: they conclude `RelationalRenewal.RenewingIn` and `ConsumingIn`, which 16 theorems in 7 modules conclude; either pair of names, 84 theorems in 19 modules.
Replacement: "By a count on a program's output of 14 November, 71 theorems in 17 modules name one or the other in what they conclude: concluded, denied, or as a side of an equivalence (one says that no finite reading is exact). At least 21 are stated of every web or world, 18 of them equivalences that carry a class across another reading, two denials, and one that concludes consuming; the rest are of one family or of single built courses. It is a count of where the names stand, not of what is joined."

What 14 November limits: the count is of the checked run of that day. Against today's tree, three module files are not in the pickle (`LineOnAStock`, `LineOnAStockCases`, `FallibleInquiry`) and by grep none names either class; by the worktree's log only `TurningInTime`, `LineOnAStock`, `WayOfUnits` and `LineOnAStockCases` changed after the dump, and none names either class; all 71 names are still found in today's files. So as far as grep and the log go the count holds today. Nothing was recompiled, so a statement changed under the same name would not show.

### (5) Sentences removed that said something true and are now told nowhere on the page

Nothing of weight. Four small things:
- **L7 (LESSER).** Old line 73: "the sizes, takes and levels". New: "in the size of the family and in the level". `drain` (`B/LineOnAStockCases.lean:196`) also equates the total of the example's draws with what the way takes, and the renewer's giving with `gift` of the pool; `multiplying_takers` (:92) also has that some member is active exactly where some need is met on the line. Replacement: "in the size of the family and in the level (for `drain` also in what is taken; for `multiplying_takers` also in whether anything is active)".
- Old line 9: "of a single going-on" on the alternating course; dropped. Harmless.
- Old line 63: "each take with a least level at which giving meets it" stated the premise that both takes have such a level (`Root g H y`, `Root g' H' y'`, `B/RegimeMargin.lean:258, 793`). The new sentence presupposes it ("that point"). The new sentence is otherwise AS THE LEAN; "larger" covers equal (`H ≤ H'`).
- Old line 9: "The readers found none joining that to the line or to the lock" is kept as "No statement that was found joins any of these to the line or to the lock". By grep, none of `LineOnAStock`, `LineOnAStockCases`, `TurningInTime`, `WayOfUnits`, `RuleCapture`, `ClosedCapture`, `RuleShaping` names `RelationalRenewal`, either class, `Renewed`, `Consumed`, `RenewingAt` or `UnderminingAt`.

### (6) The head note (line 3) and the section's italic opening

True as far as the files show:
- "corrected in three places": the diff has three places besides the head note (lines 9, 63, 73).
- "a reader who set 22 statements against the Lean for another purpose listed where this page said more or less": `round17/truth.md`, items 14 to 26.
- The four reads of the note's opening are each a file: `truth.md`; `OWED-CORRECTIONS.md` (first list, the coordinating session's read); the pickle; `page-claims.md`.
- "paths in it are made relative to the repository, nothing else is changed": the copy differs from `truth.md` in three lines, all paths.
- "Nothing above this line is changed": `NOTE.diff` has added lines only.
- "02:24 WIB": the file's time.

Not true, or less than true:
- M2 above.
- **L8 (LESSER).** Three of the four reads are in `tmp/`, which git ignores; only the truth reader's report is filed beside the record. "by the page's reader, at least 21 … and about a dozen" cannot be rechecked from the repository. Either file `page-claims.md` beside the record or say that it is scratch.
- **L9 (LESSER).** Note: "one wrote that the first sense 'is in far more places than the guess names', and quoted `Horizon.Renewable.prefix_does_not_decide`". It is one reader (the sweep, the seventh report of `dig-readers-2.json`) and it did quote the statement. But its "far more places" lists seven other laws (`Optimum … course_lost_iff`, two in `RuleRebuilding`, `Copying`, `ContinuingRevision … repeats_iff`, `JointDraw … broken_iff`, `Admission.lean:633`, `Counterfactual … course_balances_iff`), none a theorem on the web's two classes. So the phrase does not show that the readers had reported "part of this"; the quoted Horizon law does. And those seven are still told nowhere in the correction. Replacement: "The dig's own sweep had quoted `Horizon.Renewable.prefix_does_not_decide`, and had listed seven other two-way laws for the first sense in modules neither round read; the note dropped both, and the seven are not checked here."
- `READERLINE` stands in both.

### (7) A count taken for the goal, or more joined than the Lean shows

- M1, and the count sentence as it stands (L6).
- **L10 (LESSER, LESS).** Page line 73: "one statement was found that ties renewing to a record that balances … (`Flow.Balances.includes_of_renewingIn`)". The sentence is AS THE LEAN (`B/Retaining.lean:357`: balance, `Taking`, levels with the part's exchange withheld from the same start, every member `RenewingIn`; conclusion `Includes W.level l`). By the pickle it is the only theorem that names `RenewingIn` with `Balances`. But the same module has the other side, and the page tells one half of a pair that places the two classes with respect to each other on a balanced record: `Flow.Balances.narrows_of_consumed` (:368), stated with the loss written out and not by the class's name; `Untaken.consuming_keeps` (:538), a built course that is consuming over the run and leaves what can form the same; `Preemption.renewingAt_consuming_narrows` (:494), within renewal at its step, consuming over the run, and narrowing. (`Widens` and `Keeps` were not unfolded by me.) Here the page says less joined than the Lean shows.
Replacement, added: "Its other side is stated with the loss written out, not by the class's name (`Flow.Balances.narrows_of_consumed`), and two built courses mark its edges: one consuming that leaves what can form the same (`Untaken.consuming_keeps`), one within renewal at its step, consuming over the course, and narrowing (`Preemption.renewingAt_consuming_narrows`). These were read at their statements only."
- "No statement that was found joins any of these to the line or to the lock" and "That join is not tried in Lean" keep the page from claiming a join. Nothing else in either change reads as the map being more joined.

## Other sentences read on the way

**L11 (LESSER).** Page line 9: "One that from some step on takes more than that at every step … If such a drawer itself needs something, it too is active at no step from some step on". As the Lean in premises and conclusions (`overdraw_consuming`, `RR:421`; `dependent_overdraw_ends_itself`, :438; `independent_overdraw_persists`, :503). But `draw t` is taken only at steps where the drawer's need is met (`Law.level`, `RR:246-254`), so a drawer active at no step takes nothing; "takes more … at every step" beside "active at no step" contradicts itself in plain words. Replacement: "One whose draw, set for every step from some step on, is more than that (it draws and adds only while its own need is met) …".

**L12 (LESSER).** Page line 73, second thing: "every start lies within a band". The Lean's `Band` (`B/RegimeMargin.lean:2425`) is a premise on the step: it keeps every state with every level up to `hi` within `hi`; the starts being within `hi` is a further premise (`ends_iff_below`, :2687). Replacement: "every start lies within a top that the step keeps".

**L13 (LESSER).** Note: "Two drawers each within the renewal alone, together beyond it at every step … each is renewing on its own web, the two together are consuming, and both formations of the joint web are active at no step from some step on" (`SupportGatedWebs.jointly_consuming`, `B/RenewalFlow.lean:285`). In the joint law the two drawers are one formation with the summed draw (`together`, `RR:565`), and every need is the same one number. "both formations of the joint web" are that one drawer and the second, not the two drawers. The module says the family "cannot represent each drawer's own share" (`B/RenewalFlow.lean:28-30`). Replacement: "… each is renewing on its own web; read as one drawer with the summed draw they are consuming, and that drawer and the second are active at no step from some step on".

**L14 (LESSER).** Page line 9 tells the pair's laws under "renewing" and "consuming" without saying these are the beside-file's own classes, equal to the web's on the static web (`Web.static_renewingIn`, `static_consumingIn`, `B/Dependence.lean:206-214`, stated of every unfolding with fixed dependences). The note says it; the page does not. One clause would do: "(classes of the beside-file, the same as the web's on its static web)".

AS THE LEAN, opened at the statement: page line 9 on `within_renewal_renewing` (`RR:339`); line 63 on `rises_by_draw`; line 73 first thing (`WithinJoint`, `B/Continuation.lean:234`; `joint_keeps`, :248), third thing (`supported_iff_within_margin`, `B/Admission.lean:633`), fourth thing, `RegimeMargin.step` in the line's step and `Short`, `Meets`, `Keeps` in `LineOnAStock.Regime` (`B/LineOnAStock.lean:147, 193-196`; `RegimeMargin` was first committed 20 October), `drain` equating the pool with the gift added, `balances_P` being another theorem (`B/LineageDrawdown.lean:485`); the note on `renewing_keeps_support` (:226), the static equivalences, `depletion_is_joint` (`B/Joint.lean:721`), and "no statement names both `Web.RenewingIn` and `Flow.WithinJoint`" (pickle: none).

NOT CHECKED: the note's items 1, 2, 4, 8 (beyond `WithinJoint` and `joint_keeps`), 9, 11 (beyond `Regime`) and 12, their modules not opened by me; "the writer then opened each statement named below"; "at least 21" beyond the names; the seven laws of L9.
