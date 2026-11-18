*AI-written (Claude Fable 5.2), by one reader who did not write the correction, 18 November 2026. Read whole: the dig's `NOTE.md` (the note above the heading and the section "Correction, 18 November 2026"), `NOTE.diff`, `deeper/RelationalRenewal.lean`, `B/LineOnAStockCases.lean`. Read in part, at the statements and the definitions they name: `B/Dependence.lean` 1-240; `B/RenewalFlow.lean` 60-130, 236-330, 395-468; `B/Horizon.lean` 1-130; `B/Joint.lean` 655-740; `B/Retaining.lean` 300-370, 486-500, 532-542; `B/Flow.lean` 225-330; `B/Admission.lean` 370-440, 478-530, 585-645; `B/Entropy.lean` 135-150; `B/DrawnBeyond.lean` 85-300; `B/LineOnAStock.lean` 120-240, 1120-1260; `B/RegimeMargin.lean` 243-270, 722-740, 2060-2230, 3355-3400; `B/Continuation.lean` 160-260, 600-670; `B/Exclusion.lean` 280-310; `B/LineageDrawdown.lean` 1-300, 470-492; `B/Amounts.lean` 60-78, 425-470; `truth-reader-2026-11-18.md` 1-30 and 178-217; of `dig-readers.json` and `dig-readers-2.json` only the passages named below. Not read at all: any proof beyond what shows which law it calls; `B/LineageRegimes.lean` except a search for its balance theorem; `Optimum`, `CoupledDrawers`, `Roles`, `Gain`, `KeepingWidening`, `OwnWidening`, `RuleShaping`; the program's output of 14 November; the page for Ren and its reader's report; `correction-readers.json`, `confirm-readers.json`, `FROZEN-DIG-DEEPER.md`. Nothing was built or run; only `grep`, `sed -n` and the Read tool were used. No person has checked this.*

`B/` is `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/` and `RR` is `experiments/integrated-correction/general-framework/generative-basis/lean/deeper/RelationalRenewal.lean`, both under the root of the repository.

# Reading of the correction of 18 November appended to the dig's note

**Count: 1 MUST, 12 LESSER.** Every numbered item 1 to 12 tells its Lean statement as the Lean has it, and each charge against the note above is fair. The one MUST is the heading of the first block. The lesser findings are omissions, three names with a file where a namespace should be, and two places where the truth reader's list is carried in part.

## Checks asked for besides the sentences

- **The change is an append only.** `NOTE.diff` has one hunk, 32 added lines and no removed line of the note; lines 1 to 34 of `NOTE.md` are `NOTE.before.md` to the letter.
- **The report is filed beside it.** `truth-reader-2026-11-18.md` exists in the same folder (216 lines). Its section "Where the records say more or less than the Lean read" is its last section (lines 181-216): items 1 to 13 on the dig's note, 14 to 26 on `DIRECTION.md`, 27 on the fixture.
- **Items 1 to 12 against that list.** They map one to one onto the list's items 1 to 12 (section 1 = list 3, 2 = 6, 3 = 7, 4 = 8, 5 = 11, 6 = 1, 7 = 2, 8 = 4, 9 = 5, 10 = 9, 11 = 10, 12 = 12). None states the opposite of its source. Two are carried in part (findings L9 and L10 below). The section adds things the list does not have (`Flow.level_kept`, "active at every step" in item 7, `LineageDrawdown.Drain.balances_P` by name); each was checked here and is as the Lean.
- **Names.** Every name resolves to a declaration. Three carry a file name where the namespace is another (finding L11). The rest, with where they are:

| Name in the section | Declaration | Where |
|---|---|---|
| `Web.RenewingIn`, `Web.ConsumingIn` | `Becoming.Web.*` | `B/Dependence.lean:166`, `:169` |
| `Web.renewing_not_consuming`, `Web.renewing_keeps_support` | `Becoming.Web.*` | `B/Dependence.lean:222`, `:226` |
| `Web.static_renewingIn`, `Web.static_consumingIn` | `Becoming.Web.*` | `B/Dependence.lean:206`, `:211` |
| `fluctuating_neither` | `RelationalRenewal.fluctuating_neither` and `Becoming.SupportGatedWebs.fluctuating_neither` | `RR:217`; `B/RenewalFlow.lean:316` |
| `recovered_neither`, `recovered_web_neither` | `Becoming.SupportRecovery.*` | `B/RenewalFlow.lean:446`, `:458` |
| `SupportGatedWebs.jointly_consuming` | `Becoming.SupportGatedWebs.jointly_consuming` | `B/RenewalFlow.lean:285` |
| `Flow.Balances.includes_of_renewingIn` | `Becoming.Flow.Balances.includes_of_renewingIn` | `B/Retaining.lean:357` |
| `Flow.WithinJoint`, `Flow.joint_keeps` | `Becoming.Flow.*` | `B/Continuation.lean:234`, `:248` |
| `Flow.level_kept` | `Becoming.Flow.level_kept` (namespace `Flow`, not `Exclusion`) | `B/Exclusion.lean:300` |
| `Pair.own_not_joint`, `Pair.no_web` | `Becoming.Pair.*` | `B/Continuation.lean:653`, `:657` |
| `LineOnAStock.unending_iff_holds`, `Holds`, `LineOnAStock.Regime` | `Becoming.LineOnAStock.*` | `B/LineOnAStock.lean:1239`, `:188`, `:193` |
| `Flow.Balances.breaks_beyond`, `Flow.GainlessOn` | `Becoming.Flow.*` | `B/DrawnBeyond.lean:205`; `B/Entropy.lean:146` |
| `Flow.Balances.supported_iff_within_margin` | `Becoming.Flow.Balances.*` | `B/Admission.lean:633` |
| `Web.not_arises_of_unchanged` | `Becoming.Web.*` | `B/Admission.lean:424` |
| `RelationalRenewal.Law.unfolding`, `within_renewal_renewing`, `dependent_overdraw_ends_itself`, `independent_overdraw_persists` | `RelationalRenewal.Law.*` | `RR:313`, `:339`, `:438`, `:503` |
| `need_agrees` | `Becoming.LineOnAStock.DrainCase.need_agrees` | `B/LineOnAStockCases.lean:165` |
| `LineageDrawdown.Drain.balances_P` | `Becoming.LineageDrawdown.Drain.balances_P` | `B/LineageDrawdown.lean:485` |
| `Coupled.ends_together`; "the indexed law of the same name" | `Becoming.RegimeMargin.Coupled.ends_together`; `…Coupled.Indexed.ends_together` | `B/RegimeMargin.lean:3389`; `:2219` |
| `RegimeMargin.step`, `Short`, `Meets`, `Keeps` | `Becoming.RegimeMargin.*` | `B/RegimeMargin.lean:249`, `:255`, `:262`, `:265` |
| `Coupled.Indexed.rests_by`, `ends_after` | `Becoming.RegimeMargin.Coupled.Indexed.*` | `B/RegimeMargin.lean:2577`, `:2173` |

## MUST

### M1. The heading says the Lean names the two ways. MORE (a reading told as a statement)

> "**What the note left out: the two ways are named on October's web.** The note tells them only through the laws of a fixed pair (`RelationalRenewal`)."

The Lean has two classes of a formation on a web, `Web.RenewingIn` and `Web.ConsumingIn` (`B/Dependence.lean:166-170`). That these are the two ways the direction wants placed is the writer's reading. The note's own "What it bears on" says the two ways as "one that uses up what it or others rest on and can no longer be turned, and one that keeps remaking what it rests on". `RenewingIn f` is `∀ t c, W.Participates t f c → W.Renewed c`: what `f` requires or draws on stays met. Nothing in it says `f` remakes anything; on a web whose levels never move, every formation whose needs are met is renewing. `ConsumingIn` says a dependence is met at no later step and has no clause about turning. The bullets beneath tell both definitions rightly, so the heading alone says more than they do.

Replacement:

> "**What the note left out: two classes named renewing and consuming are defined on October's web.** The note tells them only through the laws of a fixed pair (`RelationalRenewal`). That they are the direction's two ways is a reading: renewing says that what a formation requires or draws on stays met, not that the formation remakes it."

## LESSER

### L1. The reach of the two "static" theorems. LESS

> "The fixed pair's two classes are the web's on the pair's static web, exactly (`Web.static_renewingIn`, `Web.static_consumingIn`)."

`B/Dependence.lean:206-214`: both are stated of any `U : Unfolding F C`, any formations and conditions, with `RelationalRenewal`'s classes (`RR:132-136`), not only of the pair's law family. Replacement: "The two classes of `RelationalRenewal`, which are defined of any course whose dependences do not change (the fixed pair's courses among them), are the web's on that course's static web, exactly."

### L2. Which step a dependence is read at, in the telling of renewing. AS THE LEAN, one word loose

> "A formation is renewing (`Web.RenewingIn`) where every condition it requires or draws on at any step has every dependence on it met at each step and at the next."

`Web.Renewed c` is `∀ t g, W.requires t g c → W.Kept t g c`, and `Kept` is the need of step `t` met at `t` and at `t + 1` (`B/Dependence.lean:142-151`). The sentence can be read as asking a dependence to be met at steps where it does not hold. Replacement: "…has every dependence on it, at each step where it holds and at its need of that step, met at that step and at the next."

### L3. `jointly_consuming`: who "the two together" and "both formations" are. LESS

> "each is renewing on its own web, the two together are consuming, and both formations of the joint web are active at no step from some step on"

`B/RenewalFlow.lean:285-292` with `RR:560-566`: the premises are all told (each draw within `renew`, the sum beyond it at every step, `0 < need`, `need ≤ start`). The joint web is the web of one law, `together`, whose single drawer draws the sum; its two formations are that drawer and the renewer. So "the two together" is one formation by definition, and "both formations" are the summed drawer and the renewer, not the two drawers. Also built into `alone` and `together` and not told: the drawers add nothing, and the drawers' need is the renewer's. Replacement: "…each is renewing on its own web; on the web of the law with their summed draw (the two told as one drawer, which adds nothing and needs what the renewer needs) that drawer is consuming, and it and the renewer are active at no step from some step on."

### L4. Item 1 leaves out what a premise does say about giving and take. LESS

> "No premise or conclusion says the take is within what is given at every step."

True as worded: `B/LineOnAStock.lean:1239-1249`, the right side is `∃ k, (∀ j, j < k → Goes …) ∧ Holds …`, and `Holds` (`:188`) is as item 1 tells it. But the premise `along` gives `Regime` at every way the course reaches, and its `Meets` (`B/RegimeMargin.lean:262`) says the giving is at least the way's take at every level left after the take from `y` of it up, within `hi`. With `Holds` that puts the configuration where the giving covers the take, which is how the proof gets the level never falling (`RegimeMargin.holds`). The item's "a reading" stands; the reader is not told how near the premises come. Add: "A premise (`Regime`, its `Meets`) says the giving covers the way's take at every level left after the take from `y` of it up, within `hi`; `Holds` puts the level there. Before the course reaches such a configuration nothing bounds the take by the giving."

### L5. Item 5: where "one" and the second course's balance come from. LESS

> "the needs are four on the line against one in the example, agreeing through that addition (`need_agrees`) … And there is a second such built course (`LineOnAStockCases.multiplying_takers`), whose level is the example's pool itself."

`need_agrees` is `∀ p, 4 ≤ p + gift p ↔ 1 ≤ p` and names no term of the example; its docstring says so. That the example's need is one is in its definition (`need _ _ _ := 1`, `B/LineageDrawdown.lean:281`). The second course is "such" a course, read also as a balanced record, only by `LineageRegimes.MultiplyingTakers.balances` (`B/LineageRegimes.lean:456`, found by search, statement `flow.Balances web`), a module item 11 says the writer did not open. Add both names.

### L6. Item 9: "depends on another". AS THE DOCSTRING, the premise is a little wider

> "where every condition that depends on another has a positive draw"

`B/RegimeMargin.lean:2219-2223`: `pos : ∀ i j, DependsOn Drawn.whole G i j → 0 < H i`, with `i = j` not excluded, so a condition that gives nothing where nothing is left of itself must also have a positive draw. The Lean's own docstring says "depends on another". "In whole numbers" is in the note's sentence and carries over. Replacement: "where every condition that gives nothing wherever nothing is left of some condition, itself included, has a positive draw".

### L7. Item 12 can be read as saying the note's search was wrong. LESS

> "*"by a search for their names no other module uses these laws."* `Amounts.lean` names `Coupled.Indexed.rests_by` and `ends_after` as cases of a law of its own"

The note's "these laws" are `Indexed.ends_iff_below`, `fates` and `ends_together`. A search of `B/` and `deeper/` here for those three, and for the pair's laws of the same names, finds them in no file but `RegimeMargin.lean`. `Amounts.lean:71` and `:445-446` name two other laws of the same web, in doc comments; `Amounts.lean` imports only `Prelude` and `GrammarLaws`, so it uses none of them. The truth reader's item 12 says the first half; the section drops it. Replacement: "For the three laws the note names the search holds (none is named outside `RegimeMargin.lean`). Not said: `Amounts.lean` names two other laws of the same web, `Coupled.Indexed.rests_by` and `ends_after`, in its comments, as cases of a law of its own (comments seen, not read through)."

### L8. "The dig's own readers had reported part of this": the quoted words are about other places. LESS

> "one wrote that the first sense "is in far more places than the guess names", and quoted `Horizon.Renewable.prefix_does_not_decide`"

`dig-readers-2.json:2564-2569` and `:2827-2833`, one reader (the seventh report). The reader did quote `prefix_does_not_decide`, and also `renewing_not_consuming` and `fluctuating_neither`. But the places it names after "far more places" are not the web's two classes: `Optimum.lean:2722 Web.course_lost_iff`, `RuleRebuilding.lean:897` and `:1368`, `Copying.lean:1170`, `ContinuingRevision.lean:576 repeats_iff`, `JointDraw.lean:104 broken_iff`, `Admission.lean:633`, `Counterfactual.lean:377 course_balances_iff`. Neither the note nor this section carries them, and none was opened on this read or on mine. Replacement: "…one reader quoted `prefix_does_not_decide`, `renewing_not_consuming` and `fluctuating_neither`. The same reader wrote that the first sense "is in far more places than the guess names" and named laws in `Optimum`, `RuleRebuilding`, `Copying`, `ContinuingRevision`, `JointDraw`, `Admission` and `Counterfactual`; those are not the web's two classes, and they are not opened here either."

### L9. "Not checked on this read" does not list everything the section leaves unchecked. LESS

The paragraph lists "the modules not opened". Left neither corrected nor listed: what the note says of `favours_breaking_beyond` (the truth reader's item 13 has it as "statement seen … not read through"; it is in `B/DrawnBeyond.lean:293`, a module the section did open), of `closes_nothing`, of `Indexed.ends_iff_below` and `fates`, of `Wholes`, and of the paragraph on `Flow.Dissipative`. The truth reader's item 13 says that last paragraph was checked and is as the Lean, with one thing left out by the note: `fed_from_beyond` asks a family without repetition and decided equality (`B/Continuation.lean:180-185`, seen here: `[DecidableEq C]`, `distinct : Distinct ds`). Those two premises are of the listing and mislead no one, but the section drops the line. Also, of the names in the paragraph, `drain_perfect_iff` is in `B/CoupledDrawers.lean:895`, not in `Optimum`. Add a sentence: "Also not checked by the writer: `favours_breaking_beyond`, `closes_nothing`, `Indexed.ends_iff_below`, `fates`, `Wholes`. The truth reader found the paragraph on dissipation as the Lean, `fed_from_beyond` asking besides a family listed without repetition."

### L10. Bullet on the count. NOT CHECKED, with one thing seen

> "71 theorems in 17 modules conclude one or the other, deny it, or say exactly where it holds; by the page's reader, at least 21 of them … and about a dozen …"

The program's output and the page reader's report were not read, and I was not to run a program. Seen by search: 23 files of `B/` have `RenewingIn` or `ConsumingIn` on some line (statements, definitions and comments together), so 17 modules with such theorems is possible and not confirmed. The next sentence, "no statement names both `Web.RenewingIn` and `Flow.WithinJoint`", agrees with a search of the files: only `B/RenewalFlow.lean` has both names, and `WithinJoint` is there in a comment (`:29`) alone. "One statement names renewing with a record that balances" also agrees with a search: no other statement found has `RenewingIn` and `Balances` together. Beside it, in the same file and not told, two built examples name consuming with such a record (`Untaken.consuming_keeps`, `B/Retaining.lean:538`; `Preemption.renewingAt_consuming_narrows`, `:494`).

### L11. Three names carry a file where the namespace is another

- `Horizon.Renewable.prefix_does_not_decide` is `Becoming.Renewable.prefix_does_not_decide`, in `B/Horizon.lean:108`. There is no namespace `Horizon`.
- `Joint.Renewable.depletion_is_joint` is `Becoming.Renewable.depletion_is_joint`, in `B/Joint.lean:721`.
- `LineOnAStockCases.drain` and `LineOnAStockCases.multiplying_takers` are `Becoming.LineOnAStock.DrainCase.drain` (`B/LineOnAStockCases.lean:196`) and `Becoming.LineOnAStock.MultiplyingTakersCase.multiplying_takers` (`:92`). The first is the note's own spelling, quoted.

Write each as the declaration's name with the file after it, as the section does for `SupportGatedWebs.jointly_consuming` in `RenewalFlow.lean`.

### L12. The first block's lead says "On the web (`Dependence.lean`)" over bullets from four other files

`fluctuating_neither`, `recovered_neither` and `recovered_web_neither` are given with no file (`B/RenewalFlow.lean`; the first also `RR:217`). Name the file at the bullet.

## Each sentence, with the Lean

### "What the note left out"

| Sentence | Lean | Verdict |
|---|---|---|
| Heading and lead | `B/Dependence.lean:166-170` | MORE, M1 |
| Renewing; consuming; "each is said of a whole course" | `:142-170` | As the Lean; L2 on one phrase. Consuming: `∃ t c, W.draws t f c ∧ W.Consumed c`, `Consumed c` is `∃ g T, W.requires T g c ∧ ∀ t, T < t → W.level t c < W.need T g c`, as told |
| Renewing is not consuming; supported at every step | `:222`, `:226`, any `W : Web F C` | As the Lean |
| The static theorems | `:206-214` | LESS in reach, L1 |
| Two built courses are neither | `B/RenewalFlow.lean:316`, `:446`, `:458` (`pulse 2`: level 2, 1, then at least 2) | As the Lean; said of the one formation `()` and of `.focal` |
| For every horizon two runs the same up to it, one renewing, one consuming | `B/Horizon.lean:108-113`: `AgreeUpTo h`, then `RenewingIn .focal` on one and `ConsumingIn .focal` on the other | As the Lean |
| Two drawers each within the renewal alone | `B/RenewalFlow.lean:285-292` | Premises all told; L3 on the conclusion |
| A built run that consumes; any single step's draw withheld | `B/Joint.lean:721-724`: third conjunct `∀ n, (… (withheld n)).Consumed ()` | As the Lean |
| Renewing with a record that balances | `B/Retaining.lean:357-359`: `L.Balances W`, `L.Taking W` (`B/Flow.lean:296`), `L.WithheldLevels part W l` (`B/Admission.lean:507`), every member `RenewingIn`; concludes `W.Includes W.level l` (`B/Admission.lean:388`: whatever `l` admits at a step, `W.level` admits) | As the Lean |
| The count; "no statement names both" | program output not read | NOT CHECKED; L10 |
| The dig's own readers had reported part of this | `dig-readers-2.json` | L8 |

### Items 1 to 12

| Item | Lean | The item's own telling | The charge against the note |
|---|---|---|---|
| 1 | `B/LineOnAStock.lean:1239-1249`, `Holds` `:188`; seven premises (`even`, `some`, `down`, `needs`, `nothing`, `high`, `along`) | As the Lean; L4 | Fair: "more". The right side is reaching a holding configuration, not a bound of take by giving at every step |
| 2 | `B/DrawnBeyond.lean:205-208`; `B/Entropy.lean:146`: `∀ f, f ∈ L.present t → total cs (L.give t f) ≤ total cs (L.take t f)` on `ds ++ rest` | As the Lean | Fair: the note's "together gain nothing" is the weaker, summed premise |
| 3 | `B/Admission.lean:633-637`; `part : F → Bool` (`:489`), `f : F` free | As the Lean | Fair: "others" is not in the statement |
| 4 | `B/Admission.lean:424-428`, `reads : ∀ s, (s = t ∨ s = t + 1) → (W.active s g ↔ W.Supported s g)`; `RR:313-318`, `active t p := L.need p ≤ L.level t`; `RR:339-343` concludes `∀ t, L.unfolding.active t .focal` | As the Lean | Fair. The reader whose finding the note's sentence carries read six modules whole (`Interdependence`, `MutualDependence`, `Feeding`, `Feedback`, `Clearing`, `Continuation`; `dig-readers.json:3-11`, `:329`), and neither `Admission` nor `RR` is among them |
| 5 | `B/LineOnAStockCases.lean:196-207` (level: pool with `gift` of the pool on it), `:165`, `:92-102` (level: `web.level t 0` itself); `B/LineageDrawdown.lean:485` | As the Lean; L5 | Fair: more on the level and the need, less on the second course |
| 6 | `B/Dependence.lean:1`, `import RelationalRenewal`; its laws are used in `B/RenewalFlow.lean` | As the Lean | Fair: "less" |
| 7 | `RR:339-343`: `within : ∀ t, L.draw t ≤ L.renew + L.contrib t`, the two starts; concludes `RenewingIn`, active at every step, `∀ t, L.formed t = t` | As the Lean. It does not repeat "both needs met at the start", which the note's sentence has | Fair: "less" |
| 8 | `B/Continuation.lean:234` (a definition, of `L`, `t`, `c`), `:248-250`; `B/Exclusion.lean:300-301` (`L.Balances W`, `∀ t, L.WithinJoint t c`, concludes `∀ t, W.level 0 c ≤ W.level t c`); `B/Continuation.lean:653`, `:657` | As the Lean | Fair: "less" |
| 9 | `B/RegimeMargin.lean:3389-3391` (the pair: both dependences, both draws positive); `:2219-2223` (indexed: `Downstream` both ways, `Downstream` being a chain of any length, the empty one included) | As the Lean; L6 | Fair: the note's words are the pair's law |
| 10 | `RR:438-441`, `:503-507`: `over : ∀ t, T0 ≤ t → L.renew + L.contrib t < L.draw t` | As the Lean | Fair: "less" |
| 11 | `B/LineOnAStock.lean:146-147` (`left` is `RegimeMargin.step giving (taken use w) x`), `:193-196`; `B/LineageDrawdown.lean:74`, `:124`, `:177`, `:190` (under `L.Balances W`, a `SelectionTerm.Generations` whose `kids` are supplied) | As the Lean, with its own limits said ("statements seen", "not opened by the writer") | Fair: "less" |
| 12 | `B/Amounts.lean:71`, `:445-446` | As the Lean | Fair as an addition; L7 on how it reads |

### The head note and "Not checked"

- "fixed answers to nine questions from 22 Lean statements": the report has "The nine questions" and "The 22 statements". As its source.
- "paths in it are made relative to the repository, nothing else is changed": NOT CHECKED, the report before that change was not given to me.
- "The writer then opened each statement named below at its statement": not checkable from the files.
- "Not checked on this read": L9.
