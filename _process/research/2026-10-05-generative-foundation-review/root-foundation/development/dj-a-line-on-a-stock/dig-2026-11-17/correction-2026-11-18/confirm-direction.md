*AI-written (Claude Fable 5.2), by one reader who did not write the correction or its repairs, 18 November 2026; no person has checked it. Read whole: `DIRECTION.v2.diff` (lines 3, 9, 63 and 73 of the page as changed, which match the page file to the byte), the three readers' reports, `renewing-consuming-71.txt`, and a sentence-by-sentence comparison of the added lines of `v1/DIRECTION.diff` with those of `DIRECTION.v2.diff`. Read in part, at the statements and the definitions they name, no proof unfolded beyond what shows a premise: `Dependence.lean` 1-60, 120-235, 280-360, 380-392, 800-880; `Space.lean` 1-32; `Admission.lean` 1-24, 82-92, 380-392, 484-512, 618-640; `Regions.lean` 30-42, 153-162; `Horizon.lean` 1-30, 60-130, 150-180; `Labelled.lean` 520-575; `Renewal.lean` 66-88; `RenewalFlow.lean` 296-322, 408-462; `deeper/RelationalRenewal.lean` 100-140, 196-265, 300-345, 415-445, 495-512; `RegimeMargin.lean` 196-215, 243-270, 752-800, 2085-2128, 2418-2432, 2676-2695; `TurningInTime.lean` 940-970; `Flow.lean` 286-300; `Retaining.lean` 300-545; `LineOnAStock.lean` 120-200, 1290-1315; `LineOnAStockCases.lean` 36-111, 180-210; `LineageDrawdown.lean` 478-490; `LineageRegimes.lean` 448-460; `World.lean` 45-57; the first three to ten lines of each of the 71 counted statements; the dig's `NOTE.md` 36-40; `truth-reader-2026-11-18.md` 1-3 and 181-216; one line of `round17/OWED-CORRECTIONS.md`. Not read at all: the rest of the page, `DIRECTION.before.md` and the word-level diff (the change was read from the line diff), the note's correction below its first heading, the program's output, any proof through. Nothing was built or run; `grep`, `sed -n`, the Read tool, and one read-only `git log` for first-commit dates.*

# Confirming read of the direction page's correction of 18 November, after repairs

`B/` is the package folder, `RR` is `lean/deeper/RelationalRenewal.lean`.

**Counts: 1 MUST, 7 LESSER.** Every MUST finding of the three reports is repaired. The one MUST here is in a sentence the repairs brought in (the sort of the 21).

## (a) The repairs

### MUST findings of the three reports

| Finding | Verdict | The new sentence |
|---|---|---|
| read-direction M1 = read-refute M1 = read-note M1: the web's classes told as the two ways (page 9, 73, 3; note heading) | MADE, all four places | 9: "They are not named in the Lean. The nearest it has is on October's web … two classes of a formation in a course, called renewing and consuming there. That they are the two ways is our reading, first taken in October. The web has no selecting in it and no turning, and it records that a formation draws on a condition, not how much." 73: "And on the web, where renewing and consuming are defined, …". 3: "found renewing and consuming, which we read as the nearest the Lean has to the two ways, defined on October's web". Note heading: "**What the note left out: two classes named renewing and consuming are defined on October's web.** … That they are the direction's two ways is a reading". See L1 for what is still told flat. |
| read-direction M2 (= read-refute L12): the band told as a premise on the start only | MADE | 73: "where each one's giving rises with what is left of each, the step keeps every state with every level up to one bound within that bound, and every start lies within it, each ends exactly where it starts below a threshold set by where the others start." As `Coupled.Indexed.ends_iff_below` (`B/RegimeMargin.lean:2687`: `rises`, `band`, `covers`, `high`, `highs`), `Band` (:2425), `step` (:2113), `Rises` (:2120). |
| read-refute M2: "gives each change with its source" | MADE | 3: "The correction appended to the dig's record tells what that record left out and where it said more or less; the list for this page is at the end of the reader's report filed beside it", with "another AI session's partial read gave the change to the sentence on `rises_by_draw`". 73: "tells where it said more or less than the Lean; the list for this page is in the reader's report beside it". The files bear this out: the note's section has "What the note left out", "Where the note says more", "Where the note says less"; the report's last section (lines 181-216) has items 14 to 26 on this page. See L6. |

### LESSER findings that bear on the page

All were taken, in the reader's wording or near it. None is NOT MADE.

- read-direction L1, read-refute L2 (consuming: never met, any step, no amount): MADE. "the dependence need not have been met at that step or ever, and the drawing may come at any step", with "not how much" two sentences before.
- read-refute L1, read-note L2 (renewing: this step's need at the next step; only steps where the dependence holds): MADE. "every dependence of any formation, at each step at which it holds, is met at that step and, as it then stands, at the next".
- read-refute L3 (classes of a single step): MADE. "The same file has classes of a single step, and a formation can be within renewal at each of its own steps and not renewing over the course."
- read-refute L4 (of one formation): MADE. "On any web no formation is both".
- read-direction L2, read-refute L11 ("takes" beside "active at no step"): MADE. "One whose draw, from some step on, is at every step more than that … (a drawer draws and adds only while its own need is met)". "Draw" is the amount set and "draws" what is taken; the parenthesis carries it.
- read-direction L3, read-refute L5, read-note L11 (the horizon: both runs overdraw; "from inside"; the name): MADE. Quoted under (b).
- read-direction L4, read-refute L6 (the count): MADE IN PART. The sentence now says what is counted and what is not. The sort of the 21 it brought in is off by one: M1 below.
- read-direction L5 (`rises_by_draw`: the two `Root` premises; "a point of its own"): MADE. The clause on the module's comments calling both "the point of no return" was not taken; leaving it misleads no one.
- read-direction L6 (the levels without the part are a premise): MADE. "for a part … and levels that from the same start change by the exchange of the rest alone"; "there are such levels without a part".
- read-direction L7, read-refute L10, read-note L10 (the other side on a balanced record): MADE. See L3 and L4 below for two words in it.
- read-direction L8 (the draw is not standing in the line): MADE. "with what the way takes at that step in the draw's place".
- read-direction L9, read-refute L7, read-note L5 (names; what else the two cases equate; both examples balance): MADE.
- read-direction L10 (`account`): MADE.
- read-refute L14, read-note L1 (the beside-file's classes are the web's on the static web): MADE. "its two classes are the web's on its static web".
- read-refute L8 (three of the four reads are in scratch): MADE in the note; on the page see L6.
- "Until 18 November this page told the two ways through the one family only": MADE IN PART, see L7.

## (b) Each sentence new since the first draft, against the Lean

### MUST

**M1. Line 9: "At least 21 are stated of every web or world: 18 equivalences that carry a class across another reading, two denials, and one that concludes consuming. The rest are of one family, of one built process, or of single built courses."** MORE, by one.

The list has 71 lines in 17 modules (counted). 21 names begin `Becoming.Web.`, `Becoming.World.` or `Becoming.ModelStatements.`; their heads are coded `Iff` (16), `And|Iff` (2: `World.classes_still`, `World.classes_fixed`, each two class equivalences and one of arising), `Not` (2) and the class itself (1). The coding is fair for the six opened whole (`Web.consumingIn_kept_iff`, `Web.consuming_survives_iff`, `Web.ConsumingThrough.consumingIn`, `Web.RenewingInWithin.not_consuming`, `World.classes_fixed`, `Web.renewingAlong_itself_iff`) and for the rest by their first lines. But one of the 18 is not of every web or world:

- `ModelStatements.renewing_iff_along` (`B/ModelStatements.lean:1058`): `(r : Run Renewable.process) : (Renewable.conditions.dependence.along r).RenewingIn .focal ↔ renewingAlong r`. It is of every run of the one built process of `Horizon.lean`. (`ModelStatements.renewingIn_iff`, :240, is of every `V : Web X X`.)

And one of "the rest" is not of a family, a built process or a built course:

- `ActiveReading.livingSignificance_wholeRun_iff` (`B/ActiveReading.lean:54`): `(U : W → Web F C) (relevance : W → F × Nat → Prop) : LivingSignificance … ↔ ∀ w f t, (U w).active t f → ¬ (U w).ConsumingIn f → relevance w (f, t)`. It is of every family of webs; the class stands negated, as a condition inside the right side. Statement read only; `LivingSignificance` and `Ranking` not opened.

So "at least 21" stands as a number (20 by name and this one), and the sort does not: 17 equivalences carry a class across another reading, not 18. By their first lines the other 49 are of the fixed pair's family or a family of numbers (`absent_not_consuming`, `consuming_through_sustaining`, `persists_consuming`, `jointly_consuming`), of `Renewable.process` (ten, `renewing_iff_along` among them), or of single built webs.

**Replacement.** "At least 21 are stated of every web or world: 17 equivalences that carry a class across another reading, one equivalence that says where another reading holds by which formations are not consuming, two denials, and one that concludes consuming. The rest are of one family, of one built process (one equivalence among them), or of single built courses."

### LESSER

**L1. Line 9: "The nearest it has is on October's web … That they are the two ways is our reading, first taken in October."** AS THE FILE for October; LESS in two things. (i) `B/Space.lean:14-16`: on the delegation of 15 October, Ren's "generative" and "degenerative" are read "as widening and narrowing what can form, and at the level of formations as renewing and consuming". The October reading is of those two words, and it has two pairs: of a part, widening and narrowing what can form (`B/Admission.lean:84-87`, `B/Regions.lean:37-38`, `Web.Widens` at `Regions.lean:157`); of a formation, renewing and consuming. The page tells the second pair only, and line 73 then uses "narrowing what can form" untold. (ii) "The nearest it has" is told flat here, where the head note has "which we read as the nearest". "First" was not checked beyond `Space.lean`. Leaving it does not mislead about what is proved. **Replacement:** "The nearest it has to the pair, as we read it, is on October's web, … called renewing and consuming there. That they are the two ways is our reading. In October the Lean's opening accounts read 'generative' and 'degenerative' as these two classes of a formation and, of a part, as widening and narrowing what can form (`Space.lean`, `Admission.lean`)."

**L2. Line 9: "We take that to show part of the idea's sentence that the two can look alike until late: no stretch of a course settles which it is."** The clause after the colon can be read as a general law. The Lean: in one built process, for every `h`, the stretch from the start up to `h` does not settle the drawer's class (`B/Horizon.lean:108-113`). **Replacement:** "… until late: in that process no stretch from the start, however long, settles which it is."

**L3. Line 73: "a law that takes consuming's condition, written out, as a premise on such a record (`Flow.Balances.narrows_of_consumed`)".** `B/Retaining.lean:368-374`: the premise is `below : ∀ t, T < t → W.level t c < W.need T g c`, the loss in `Web.Consumed`. Not asked: that any member of the part draws on the condition (which `ConsumingIn` asks), or that the dependence held at `T` (it is asked at a later step, at no smaller need). Further premises: the part gives each condition no more than it takes at every step, and the levels without the part admit that formation at the later step. The conclusion, that the levels without the part widen those with it, is not told. **Replacement:** "a law that takes the loss in consuming's definition, written out (a need as it stood at one step met at no later step), as a premise on such a record, with others, and concludes that the part narrows what can form (`Flow.Balances.narrows_of_consumed`); it does not ask that a member of the part draws on the condition".

**L4. Line 73: "two built courses that are consuming on one: … one within renewal at its first step, consuming over the course, and narrowing what can form (`Preemption.renewingAt_consuming_narrows`). These three were read at their statements only."** The statement (`B/Retaining.lean:494-496`) concludes `RenewingAt 0`, `ConsumingIn`, `¬ RenewingIn` and `Widens l web.level`: as told. That its flow balances is a step inside the proof (`have balances`, :497-499), not a conjunct, so "on one" does not come from a read of statements. It is so in the Lean. `Untaken.consuming_keeps` (:538-540) concludes `Balances`, `Taking`, `ConsumingIn` and `Keeps`: as told; "whose part takes nothing" is the flow's definition. **Replacement** for the last sentence: "These three were read at their statements only; that the second course's record balances is in its proof, not its statement."

**L5. Line 3: "They found five places where it said more than the Lean or was not so, … and some thirty lesser ones".** Five is the sum of the three reports' MUST marks (2, 1, 2). The findings are three: the classes told as the two ways (four places), the band (one), and "gives each change with its source" (two). The lesser marks sum to 36, several of them shared. **Replacement:** "Between them they marked five findings as more than the Lean or not so, three of them one finding, that the web's two classes were told as being the two ways, which is our reading, and some thirty lesser ones".

**L6. Line 3, the record.** "another AI session's partial read gave the change to the sentence on `rises_by_draw`": so, by `round17/OWED-CORRECTIONS.md:9`, which is in scratch and not in the repository; the note says this and the page does not. Add "(in scratch, not filed)". The three reports are in `correction-2026-11-18/` with the list; they differ from the scratch copies in two paths only, and in `read-note.md` line 3 one path was cut to nothing ("both under ``").

**L7. Line 9: "Until 18 November this page told these classes through the one family and their exclusion only."** The page before also told one built course that is neither ("one built course, of a single going-on on a level that alternates, is neither"). **Replacement:** "… through the one family, their exclusion and one built course only."

### As the Lean

| Sentence (new since the first draft) | Statement | Evidence |
|---|---|---|
| 9: "They are not named in the Lean." | negative | no declaration in `B/` or `deeper/` is named for the pair (searched: generative, degenerative); the words stand in the opening accounts of `Space`, `Admission`, `Regions` only. See L1. |
| 9: "two classes of a formation in a course, called renewing and consuming there" | `Web.RenewingIn`, `Web.ConsumingIn` (`B/Dependence.lean:166-170`) | `Web F C := Dependence Nat F C` (`B/World.lean:48-57`) |
| 9: "no selecting in it and no turning, and it records that a formation draws on a condition, not how much" | fields `level`, `active`, `requires`, `need`, `draws` | `draws : S → F → C → Prop`; `Dependence.lean:21-23` |
| 9: renewing, with "at each step at which it holds … as it then stands, at the next" | `Kept` :142, `Renewed` :150, `Participates` :163, `RenewingIn` :166 | `need t g c ≤ level t c ∧ need t g c ≤ level (t+1) c` for every `t`, `g` with `requires t g c` |
| 9: "needs stay met, not that the formation remakes anything" | same | no clause of the definition is about what `f` does |
| 9: consuming; "need not have been met at that step or ever, and the drawing may come at any step" | `Consumed` :155, `ConsumingIn` :169; `Unmet.consumed_without_loss` :386 | the steps `t` of the drawing and `T` of the dependence are bound apart |
| 9: "classes of a single step … within renewal at each of its own steps and not renewing over the course" | `RenewingAt` :294, `BreakingAt`, `UnderminingAt`; `renewing_at_active` :348; `Dip.renewing_at_each_step_not_in_run` :865 | `(∀ t, web.active t .dependent → web.RenewingAt t .dependent) ∧ ¬ web.RenewingIn .dependent`, one built web |
| 9: "On any web no formation is both … in two built courses the drawer is neither" | `Web.renewing_not_consuming` :222; `SupportGatedWebs.fluctuating_neither` (`B/RenewalFlow.lean:316`), `SupportRecovery.recovered_web_neither` (:458) | `fluctuating`'s one formation requires and draws (`RR:206-211`); `pulse 2` draws 2 at step 0 |
| 9: "its two classes are the web's on its static web" | `Web.static_renewingIn`, `static_consumingIn` (`Dependence.lean:206-214`) | of any `U : Unfolding F C` |
| 9: "a drawer whose draw at every step is no more than the renewal with what it adds itself, both needs met at the start, is renewing and active at every step" | `within_renewal_renewing` (`RR:339-343`) | `within`, `gStart`, `fStart` |
| 9: "One whose draw, from some step on, is at every step more than that … (a drawer draws and adds only while its own need is met)" | `overdraw_consuming` (`RR:421-425`); `Law.level` (`RR:246-254`) | `contrib t` and `draw t` enter only under `needF ≤ level t`; `active t .focal` is that (`RR:315`) |
| 9: "it too is active at no step …; one that needs nothing of the level is active at every step" | `dependent_overdraw_ends_itself` (`RR:438`), `independent_overdraw_persists` (`RR:503`) | `0 < needF`; `needF = 0`, `0 < needG` |
| 9: "two runs the same up to it, both drawing one more than is renewed at every step before it, the drawer renewing along one and consuming along the other (`Renewable.prefix_does_not_decide`, in `Horizon.lean`)" | `B/Horizon.lean:108-113`; `process` (`B/Labelled.lean:552`); `conditions` (`B/Renewal.lean:74-87`) | `t = s + 1 - d`: one renewed a step; `consuming.act t = 2` before `h`, and the acts agree before `h`; `.focal` draws and requires nothing |
| 9: "the two runs being the same in everything up to the horizon, the level included" | `Run.AgreeUpTo` (`Horizon.lean:100-101`) | same states at every `t ≤ h`, same actions at every `t < h`; the state is the level |
| 9: "71 theorems in 17 modules name one of the web's two classes in what they conclude: concluded, denied, or as a side of an equivalence (one says that no finite reading is exact)" | the list | 71 lines, 17 modules; `LabelledRoles.Renewable.no_exact_finite_reading` (`B/LabelledRoles.lean:173`) |
| 9: "Statements that take a class only as a premise are not counted, nor are the fixed pair's own laws." | the list's heading; `RR:339-343` | the pair's laws conclude `RelationalRenewal.RenewingIn`, another name |
| 63: "a take added to the least level at which giving meets it, where each of two takes has such a level: under a take at least as large that is given no more at any level, that point lies higher by at least the difference of the takes" | `rises_by_draw` (`B/RegimeMargin.lean:793-794`), `Root` :258, `Lowered` :780 | `Root g H y`, `Root g' H' y'`, `H ≤ H'`, `∀ z, g' z ≤ g z` give `H + y + (H' - H) ≤ H' + y'` |
| 63: "The level of the law before is written the same way, a take added to a level below which giving falls short of it" | `TurningInTime.unending_iff_above` (`B/TurningInTime.lean:958-966`) | `H₂ + y₂` with `Short giving H₂ y₂` and `Meets giving H₂ y₂ hi` |
| 63: "no other theorem in the package uses this law" | search | in `B/` and `deeper/` the name stands at `RegimeMargin.lean:210` (a comment) and :793 only; `Root` is in no other module |
| 73: "Third …" | `Flow.Balances.supported_iff_within_margin` (`B/Admission.lean:633-637`), `WithheldLevels` :507-509 | `part : F → Bool`; sums over the steps before `t` |
| 73: "there are such levels without a part, and every member of the part is renewing, the levels with the part admit at every step every formation that the levels without it admit" | `Flow.Balances.includes_of_renewingIn` (`B/Retaining.lean:357-361`), `Taking` (`B/Flow.lean:296`), `Includes` (`B/Admission.lean:388`) | concludes `W.Includes W.level l` |
| 73: "with what the way takes at that step in the draw's place" | `LineOnAStock.left` (`B/LineOnAStock.lean:146-147`) | `RegimeMargin.step giving (taken use w) x`; `Regime` :193-196 |
| 73: the two cases, their names, "for `drain` also in what is taken; for `multiplying_takers` also in whether anything is active" | `LineOnAStock.DrainCase.drain` (`B/LineOnAStockCases.lean:196`), `LineOnAStock.MultiplyingTakersCase.multiplying_takers` (:92) | `drain`: lengths, pool with `gift` of the pool, `generations.sum t = taken …`; `multiplying_takers`: lengths, `web.level t 0`, some member active exactly where some need is met |
| 73: "That each example balances is another theorem." | `LineageDrawdown.Drain.balances_P` (`B/LineageDrawdown.lean:485`), `LineageRegimes.MultiplyingTakers.balances` (`B/LineageRegimes.lean:456`) | each `flow.Balances web` |
| 73: "the line's module has the balance as plain numbers, `LineOnAStock.account`, not as a record on the web" | `B/LineOnAStock.lean:1305-1311`; the module's opening, :122-123 | it holds where the take is at most the level at every step before `N`, the premise the on-paper clause after it also names |

NOT CHECKED: "by one reader's account, sharpened by a second" (the reports were not opened); "These three were read at their statements only" (not checkable from the files); "first" in "first taken in October".

## (c) Plain reading

- Read two ways about what is proved: L2 ("no stretch of a course settles which it is") and L3 ("consuming's condition").
- A count taken for a goal: no. "It is a count of where the names stand, not of what is joined" guards it, and with M1's repair the sort says what kind the 21 are.
- More joined than the Lean shows: no. "No statement that was found joins any of these to the line or to the lock" and "That join is not tried in Lean" stand, and nothing new says otherwise. Less joined in one respect: L1, the second October pair is not told.
- The head note says truly what was done as far as the files show, but for L5 and L6.
