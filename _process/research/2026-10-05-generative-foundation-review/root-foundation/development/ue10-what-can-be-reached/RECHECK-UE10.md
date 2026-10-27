# UE10 re-check: the fix round against the review

AI-written, 26–27 October 2026. An independent re-check of board item UE10 after its fix round, by a reader who had no part in the design, the module, the review or the fix round. The standard is AGENTS.md's "Proof and naming": pure core, every axiom report empty, names structural and exact, and a name or docstring stating exactly what the Lean states. The re-check edits nothing but this file and its own probe folder [`recheck/tree/Becoming/`](recheck/tree/Becoming/); it makes no commit. Sections 1 to 5 are complete; an addendum on the landing texts may follow.

**Checked.**
- The module [`tree/Becoming/ReachableRanges.lean`](tree/Becoming/ReachableRanges.lean): 1578 lines, sha256 `c6d9b6da53dab174664fa94c1610e4a01b4fc662eedc2958af3b5d6b603b9e79`. The copy in [`recheck/tree/Becoming/ReachableRanges.lean`](recheck/tree/Becoming/ReachableRanges.lean) is byte-identical (same hash, re-checked after each interruption, last on 27 October).
- **Version.** Every finding and line number below refers to that reviewed version, `c6d9b6da…9e79`, kept byte-identical in the probe tree. The module changed in place at 10:58 on 27 October, while this file was being finished: sha256 `3098c2a1…041e`, 1830 lines, without the `ComparingCourses` import; the scratch log beside it ([`scratch.log`](scratch.log), from the session editing it) reports 131 theorems in 189 declarations, `with_axioms` empty, 68 modules. That version is not re-checked here. NOTE.md is unchanged (same hash as above).
- The review [`REVIEW-UE10.md`](REVIEW-UE10.md) (sha256 `bf160f7d…2e57`) and its probes, including the reviewed draft `probes/tree/Becoming/ReachableRanges.lean` (sha256 `60d1f4e9…a6a1`, 645 lines).
- The study note [`NOTE.md`](NOTE.md), sections 1 to 7 (sha256 `2ce8ef508e16f16fb2adc7bd72b8176783a94bdfcb5f78355b2f0d73e92cb252`, 147 lines).
- [`DESIGN.md`](DESIGN.md) (sha256 `41f67180…53d7`, unchanged since the review), for context only.
- The landed modules the statements use, on main `04c7f93ae` (main is now `dbfba53d0`; no file of the Lean package changed between them): `ComparingCourses` (`strictJoin_trans`, `strictJoin_irrefl`, `Web.IncludesLater`, `Web.WidensWithLag`, `Web.WidensOrWithLag`, `Delayed.widens_not_withLag`), `Labelled` (`WithinMoves`, `withinMoves_iff_reach`, `together_after_reach`, `WithinMoves.before`, `lost_together_not_returns`), `Onward`, `Frame`, `Extension` (`Extension`, `Comparison`, `Comparison.separates`), `Lexical` (`Included`, `Above`), `Bundles` (`CarriesProfiles`, `PreservesBundles`, `carries_iff_preserves`, `Regimes`), `EventualWidening` (`Web.KeepsWidening`, `.gathers`, `.not_listed`), `ContinuedClasses` (`Web.itself`, the across-stretch lemmas), `Admission` (`Web.Admits`, `Web.Includes`, `Web.Exceeds`), `LawAlongRun` (`Dependence.AdmitsAt`), `Recurrence` (`Law.process`, `Law.orbit`), `Branching` (`law_run_state`), `Horizon` (`Markov`), the package README's layer column and 08 §3's layers.

## 1. Build and axiom reports

- `python3 -B scratch_build.py <recheck/tree> Becoming.ReachableRanges` on main `04c7f93ae` (Lean 4.29.1): 89 modules in the closure, every step restored from the shared cache (the fix round's passed steps), no unclean step. Report: **116 theorems in 171 declarations, `with_axioms` empty.**
- Because every step was restored, the module was then compiled again by hand with the checker's Lean (`lean -o … Becoming/ReachableRanges.lean` in `recheck/tree/.build`, `LEAN_PATH` set to it): exit 0, no message. The builder's audit file (`#print axioms` for each of the 171 declarations) was run again by hand: **171 of 171 "does not depend on any axioms"**, nothing else printed.
- No tactic block occurs in the module (no `by`, `simp`, `decide`, `omega`); no `▸`, `propext`, `funext`, `Classical` or `Quot`. Runs are built with `Run.cons` or written out, never chosen.
- Every direct import is on `check_becoming.py`'s `CORE` list (Horizon, Labelled, Onward, Population, Admission, LawAlongRun, Extension, Lexical, Bundles, EventualWidening, ComparingCourses). The closure, though, holds nine modules the package README lists as L2, all through `ComparingCourses` (finding N6).
- Names: the whole package (the root `Becoming`'s closure, 332 modules, UE9's `ComparingCourses` among them) and the module import together with no clash (probe `RecheckClash`: 334 modules with the module and the probe, clean).

## 2. The review's findings and verdict items

Status: **resolved** (the module states what the review asked, and the statement says what the Lean shows), **partly** (the Lean is there, a sentence still says more or less than it), **not taken** (optional, declined, and said so in the note).

| Review item | Status | Why |
|---|---|---|
| F1 (a) inclusion now | partly | `Reaching.Covers.now` and `Reaching.not_above_wider_now` are in, exact and with their premises. The sentences built on them are not: "contains inclusion now" states the wrong direction in the texts' own idiom (N1); NOTE §3 and §7 drop the premise that the configuration wider now starts a course (N2); "widening of the two courses" for the strict part of inclusion (N3). |
| F1 (b) the lagged order | partly | `Reaching.CoversLater`, `.zero`, `.trans`, `Reaching.WidensOrLater`, `.irrefl`, `.trans`, `.not_reversed`, `WiderNow.silent`, `WiderNow.decided` are in and correct, after UE9 landed. The header and the note read the witness as a law ("on a determined process where…", "decides such a pair"), which is false in general (N4); "it is UE9's lagged order" and its standing say more than the Lean (N5); `S : Type` is not needed (N7). |
| F2 `Rise.rises` | resolved | `Rise.rises` is the widening alone; `Rise.possible_same`, `Rise.possibleWithin_same` (for `k + 1`) show what the docstring says; `Reaching.Covers.possible` names its premise; `NoCourse.widens_reversed` shows the premise needed. |
| F3 the rise is the delay | resolved | `Run.coversLater_next`, `Reaching.widens_next_iff_rising` (for step `0` of any run; every tail of a run is a run), `Rise.process_eq_law`, `Climb.process_eq_law`, `Law.runs_agree`. The fix round's claim about the review's sentence is right for the joined order and needs a qualification (N13; probes R1–R3). |
| F4 keeping widening | resolved | `Reaching.KeepsWidening` is 07's form for a chain (by name, from the chain's first step); `.gathers`, `.not_listed`; the along-a-course laws; `Climb.keeps` in chain form; the per-step property is gone. `Web.KeepsWidening.chain` is proved one way only though its title says "is" (N14; the converse holds, R16). |
| F5 option value | resolved | Header: the lower (Hoare) preorder (`covers_iff_included`, `covers_iff_criteria`), the irreversibility premise of Arrow and Fisher and of Henry restated, quasi-option value not captured (`DeferredChoice`). The module names no Kreps link; the note gives it as an AI reading (§4), and its planned 08 line in §7 drops the label (N19). |
| F6 duplicates | resolved | `possibleWithin_iff_withinMoves`, `possible_iff_withinMoves`; `Possible.of_reach` from `together_after_reach`; `Run.not_possible_returns` from `lost_together_not_returns`; `Run.possibleWithin_moves` from `WithinMoves.before`; `Run.possible_of_later`, `Run.possible_from_start` one-line instances; `Run.tail_of_trace` cited as the strong form of `Onward.run_of_trace`; law 3 from the chain law. Two small residues: `Law.runs_agree` re-proves the two-run form of `Branching.law_run_state`, which the closure holds (N10), and `Web.not_listed_of_chain` restates a landed statement (N15). |
| F7 instances | resolved | `covers_iff_carries`, `covers_iff_preserves`, `covers_iff_included`, `widens_iff_extension` (both ways, no premise), `lexical_above` (one way; the converse holds with the inclusions decided, R21), `KeptAlternative.no_comparison_both`, `KeptTogether.no_comparison_through_bundles` (stronger than the review's I4: a description the bundles determine), the four B8 forms by `Iff.rfl`. The header's sentence on `no_comparison_through_bundles` drops its irreflexivity (N8). |
| F8 `Joint` | resolved | Renamed `KeptTogether`; `same_bundles`, `split_courses`; "together at every offset of one course"; no claim of `same_marginals_lose_bundle`. The docstring's "the bundles at a configuration" should be "from" (N8). |
| F9 determined witnesses | resolved | `process_eq_law` for `Rise` and `Climb`, docstrings and header say they witness nothing about alternatives. The optional branching witness was not built, and NOTE §3 says so. |
| F10 generality | resolved / not taken | (a) `widens_iff_of_greatest`, `widens_of_rangeWidens_greatest`, `greatest_of_unique`, `KeptAlternative.greatest_not_unique`; (d) `widens_not_covered`. (b) `X : Type w` and (c) the order on two chosen courses not taken, said in NOTE §5 and §6. |
| F11 Kauffman | resolved | Header and NOTE §4: restated only for a prestated space; Longo, Montévil and Kauffman 2012 outside. The definition's docstring still identifies the adjacent possible flatly (N16). |
| F12 finite recurrence | resolved | Credited as the pigeonhole, as `Web.KeepsWidening.not_listed` is; `AllAtOnce.converse_fails`. |
| F13 opportunity sets | resolved | NOTE §4: dominance of the families of ranges, set inclusion only with options unordered; Pattanaik and Xu count. |
| F14 lexical order | resolved | The package's two-tier order (`lexical_above`), near-definitional; Sen a neighbour (NOTE §4). |
| F15 linear time | resolved | `DeferredChoice` (cover both ways; one step on, widening; simulation one way only); the infinite-course caveat in the modelling list. |
| F16 assembly theory | resolved | An analogy (NOTE §4); the open-ended evolution papers neighbours. |
| F17 docstrings | resolved, one residue | (a)–(f), (h) done. (g): "on this witness" is in; the added determined-case clause omits the realized courses' start (N9). |
| F18 modelling list | resolved | All four items in the header and NOTE §5. |
| F19 names | resolved / not taken | (a) "narrows" gone everywhere; (c) `Reaching.Covers` in prose; (d) `KeptAlternative`; (e) `KeptTogether`. (b) `Reaching` kept, argued in NOTE §6. |
| F20 the AdmitsAt bridge | resolved | Removed; B8's `Iff.rfl` forms in. |
| F21 the design | not taken | DESIGN.md unchanged; NOTE §3 and §6 say the note supersedes it. Acceptable for a planning record. |
| Verdict 1 | partly | Lean in; the narrowing sentences need N1–N4 before they go into 07. |
| Verdict 2 | resolved | |
| Verdict 3 | resolved | |
| Verdict 4 | resolved | |
| Verdict 5 | resolved | (N19 is about the planned 08 line, not the module.) |
| Verdict 6 | resolved | |
| Verdict 7 | resolved | |
| Verdict 8 | resolved, one residue | N9. |

## 3. New findings

Classes: **error** (a statement that is false), **overclaim** (says more than the Lean shows), **imprecision** (true on one reading, wrong or vague on another, or missing a hypothesis without changing the truth of the intended reading), **suggestion**. Line numbers are the module's unless marked NOTE.

### N1. "Covering contains inclusion now" states the wrong direction (imprecision, major)

*Location.* Header line 23 (bullet title "Same-offset covering is an order that contains inclusion now") and line 35; `Reaching.Covers.now`'s docstring, line 323. NOTE §1 (line 11, "what a course keeps reachable contains what it admits now"), law 1's title (line 17), §3 (line 69), §6 row 1, §7's Open item (line 144, "contains what each configuration admits now").

*Evidence.* `Reaching.Covers.now` proves `Covers P adm s s' → r'.state 0 = s' → adm s' x → adm s x`: as relations on configurations, covering lies inside inclusion now (for configurations that start a course). The same texts use "contain" relationally the other way: "a strict partial order containing widening what can be reached" (header line 52, and the `WidensOrLater` docstring, line 700) means widening ⊆ the order, and so do "no strict partial order contains both" (line 105) and "containing realized widening" (line 110). Read in that idiom, "covering contains inclusion now" says that inclusion now gives covering, which is false: on `WiderNow`, what the climb admits now `none` admits now, yet `none` does not cover the climb (probe R15 `inclusion_now_not_covering`).

*Fix.* Say what `Covers.now` says, in the direction it says it: "**Same-offset covering is an order that needs inclusion now**" (or "lies within inclusion now", or "entails it"), and "Covering needs inclusion now: a configuration covering one that starts a course admits now all that one admits now". The name `Covers.now` is fine. In NOTE §1 and §7: "compared at the same offsets, covering needs inclusion now: a configuration covering one that starts a course admits now all that it admits now".

### N2. NOTE §3 and §7 drop the premise that the configuration wider now starts a course (overclaim)

*Location.* NOTE §3 line 69 ("wherever one configuration admits now what another does not, it ranks the other no higher, whatever the other's widening does later"); NOTE §7 line 144 ("so it never ranks a range that keeps widening above one wider now"). The header (lines 35–40) and NOTE law 1 (line 21) state the premise and are exact.

*Evidence.* Probe R14 `widens_without_course`, from the module's own `NoCourse.widens_reversed`: `false` admits now every formation and `true` admits none, yet `true` widens what can be reached over `false`, because `false` starts no course. So the §3 sentence is false as written. The §7 sentence fails the same way, with a range that keeps widening: R23 `EndsNow.keeps_widening_above_wider_now` gives a process where what the climb from `some 0` admits keeps widening in 07's form, `none` admits now what `some 0` does not and starts no course, and `some 0` widens what can be reached over `none`. What the Lean needs: for widening what can be reached, only that the configuration admitting more now starts a course (R11 `not_widens_of_wider_now`, a one-line consequence of `Covers.now`); for the lexical order, both chosen courses starting at their configurations — without either, the lexical order ranks a configuration above one admitting now what it does not (R12 `Three.start_needed`, R13 `Three.start'_needed`). So `not_above_wider_now`'s two premises are both needed for its lexical half, and only "`s'` starts a course" for its first half.

*Fix.* §3: "wherever one configuration starts a course and admits now what another does not, it ranks the other no higher, whatever the other's widening does later". §7 (07's Open item): "so it never ranks a configuration above one that starts a course and admits now what it does not, whatever its widening does later". Optionally add R11 to the module and cite it beside `Covers.now`.

### N3. "On a determined process it is widening of the two courses" (imprecision)

*Location.* Header lines 43–46; `Reaching.widens_iff_of_unique`'s bold title, line 379; NOTE §1 (line 11), §3 (line 69, "first-order widening of the two courses"), §7 (line 144). NOTE law 1 (line 23) is exact.

*Evidence.* `widens_iff_of_unique` gives `Widens P adm s s' ↔ r.RangeIncludes adm r' ∧ ¬ r'.RangeIncludes adm r`, the strict part of range inclusion. The module's own range widening (`Run.RangeWidens`) and 07's widening (`Web.Widens`) are inclusion and exceeding, with a witness. They agree only classically: the review's probe W3 (`Calibration.markov_of_designForm`) shows that even the forward half with exceeding (on every determined process, widening what can be reached gives exceeding of the two courses) gives Markov's principle. The docstring's second sentence says the right thing; its bold title and the header do not.

*Fix.* "On a determined process, widening what can be reached is the strict part of range inclusion of the two courses, which range widening gives (`widens_of_rangeWidens`)": in the title at line 379, the header and NOTE §1, §3, §7.

### N4. The witness read as a law: "on a determined process where…", "decides such a pair" (overclaim)

*Location.* Header lines 54–57 ("On a determined process where what a climb admits keeps widening and another configuration admits now what the climb does not, same-offset widening … are silent both ways (`WiderNow.silent`), and the lagged order ranks the climb above the other and not conversely (`WiderNow.decided`)"); the `WidensOrLater` docstring, lines 701–702 ("It decides the pair where same-offset covering is silent"); NOTE §1 ("With a lag it decides such a pair"), law 2's title (line 25), §7 (line 144, "read with a lag it decides such a pair").

*Evidence.* Both general readings are false.
- R8 `AllNow.not_silent`: on `WiderNow`'s determined process, with `none` admitting every formation, the climb keeps widening and `none` admits now what the climb does not, yet `none` widens what can be reached over the climb, and the lagged order ranks `none` above the climb and not conversely. Same-offset widening is not silent there, and the lag does not favour the climb.
- R7 `TwoSided.silent`: on the same determined process, with `none` admitting the first left formation and every right formation and the climb admitting the left formations up to `n`, the climb keeps widening in 07's form, `none` admits now what the climb does not, and the lagged order ranks neither above the other (its proof shows that neither covers the other at any lag). This is UE9's `Sides.silent` read on courses.

*Fix.* Header: "On one determined witness (`WiderNow`), where what the climb admits keeps widening, `none` admits now what the climb does not and each course exceeds the other, same-offset … are silent both ways, and the lagged order ranks the climb above `none` and not conversely". Docstring: "It decides `WiderNow`'s pair". NOTE law 2's title: "With a lag, the lagged order decides `WiderNow`'s pair"; §1 and §7: "read with a lag it decides the witness's pair, though not every such pair". If R7 is added to the module, §7 can say so with a citation.

### N5. "It is UE9's lagged order", and its standing (imprecision)

*Location.* Header line 47 (bullet title "With a lag it is UE9's lagged order, lifted to families of courses"); the `WidensOrLater` docstring, lines 699–700; NOTE law 2 "Its standing" (line 30), §1, §3 (line 70, "its standing stays UE9's"), §7.

*Evidence.* No theorem connects `Reaching.WidensOrLater` to UE9's `Web.WidensOrWithLag`. What holds is narrower:
- On a determined process the lagged order is the strict part of range inclusion of the two courses joined to the strict part of their inclusion with some lag (R17 `widensOrLater_iff_of_unique`).
- With fixed conditions the lag part is UE9's `Web.WidensWithLag` of the two courses' levels, by `Iff.rfl` (R17 `lagPart_conditions_iff`). The first part is the strict part of inclusion, not UE9's widening; UE9's order lies inside the lagged order (R17 `widensOrLater_of_widensOrWithLag`), and the converse needs exceeding decided (as in N3). R17 needs fixed conditions: with dependences that change along the run, the web along one course reads the other course's levels through its own requirements, so the identification is not available as stated (not probed).
- So "on a determined process … it compares the two courses as UE9's order does" (NOTE law 2) holds only with fixed conditions and only up to the first part's constructive form.
- "Whether calling it better is a premise beyond C is UE9's question, unchanged" says less than the Lean can show, and contradicts NOTE §3, which lists the choice of a lag as a further premise. R10 `lag_beyond_C` settles it here: on `WiderNow`'s frame of reachable ranges two strict partial orders satisfy C, widening what can be reached and the lagged order, and they disagree on the climb against `none`. C leaves the pair unranked; ranking it is a premise beyond C.

*Fix.* Header and docstring: "built as UE9's lagged order is, on families of courses" (or "UE9's join of widening and the strict part of lagged inclusion, read on families of courses"). NOTE law 2: "**[AI reading]** Its definition follows UE9's widening or widening with a lag, read on families of courses: on a determined process with fixed conditions its lag part is UE9's widening with a lag of the two courses' levels, and its first part the strict part of their inclusion, which contains UE9's widening. Calling it better is a premise beyond C: C on the frame of reachable ranges ranks only widening what can be reached (`Reaching.widens_iff_extension`), and on `WiderNow` it leaves the climb and `none` unranked." Add R17 and R10 to the module if the note cites them as laws.

### N6. The layer: L1 is claimed, while the import of `ComparingCourses` puts nine L2 modules in the closure (error)

*Location.* NOTE §5 line 100 ("none stating `Unrestricted` or `Valuation`, so it is L1"); the README row the landing would add; the import at line 11.

*Evidence.* 08 §3 defines L2 as "the modules naming the condition or a valuation", L1 as the rest, and states "No module imports a higher layer"; the package README marks a module importing an L2 module as "L2 through" it (`Becoming.KeepingWidening`, "L2 through `Becoming.MapInstances`"). The closure of `ReachableRanges` (89 modules) holds `Weightings`, `Boundaries`, `BoundedSignificance`, `Significance`, `Metaethics`, `ValuationFrames`, `Correspondence`, `Descent` and `Standpoints`, all marked L2 in the README, through one path: `ReachableRanges → ComparingCourses → EventualWideningInstances → Weightings → Boundaries → BoundedSignificance → Significance → Metaethics`. The other ten direct imports bring none (their joint closure has 67 modules, counted as the builder counts them, and no L2 module). The module uses `ComparingCourses` only for `strictJoin_trans` and `strictJoin_irrefl`. A copy of the module without that import, with the three lag laws proved directly at `S : Type u` (the proofs of R9), compiles cleanly against main (scratch compile in the re-checker's scratchpad, exit 0, no message; the copy is not part of the probes). The note's L1 follows the README's current rows for the module's direct imports, which list `ComparingCourses` as L1; but those rows are themselves inconsistent. `EventualWideningInstances` is listed L1 although it imports `Weightings` (L2) directly, which contradicts 08 §3's "No module imports a higher layer" on any reading of "imports" and departs from the README's own practice (`KeepingWidening` imports `MapInstances` directly and is marked "L2 through" it). Applied consistently, that practice makes `EventualWideningInstances` L2 through `Weightings`, `ComparingCourses` L2 through it, and this module L2 through `ComparingCourses`. The note's reason, that no direct import states `Unrestricted` or `Valuation`, looks at direct imports only. Pre-existing, for their owners: the README rows of `EventualWideningInstances` and `ComparingCourses`.

*Fix.* Preferred: drop `import Becoming.ComparingCourses`, prove `WidensOrLater.irrefl` and `.trans` directly (12 lines, R9), keep the references to UE9's order in prose; the module is then L1 on every reading, its closure shrinks from 89 to 68 modules, and N7 goes away. Alternatively ask ComparingCourses' owner to move `strictJoin_trans` and `strictJoin_irrefl` to a lower module (they are logic lemmas, liftable to `Sort u`). Otherwise NOTE §5 and the README row must say "L2 through `Becoming.ComparingCourses` (no ethical predicate)". Report the README's `EventualWideningInstances` and `ComparingCourses` rows to their owners either way.

### N7. `S : Type` in the lag section is not needed (imprecision)

*Location.* Line 696 (`variable {S : Type}` for the whole section); NOTE §5 line 101 ("the lagged order takes `S : Type`, since UE9's `strictJoin_trans` is stated at `Type`. Lifting either is for the owners of … ComparingCourses").

*Evidence.* The definition is accepted at `S : Type u`; the module's proof of transitivity through `strictJoin_trans` (`{α : Type}`) is refused there (scratch file: a type mismatch at the `strictJoin_trans` application; not part of the probes), and `strictJoin_irrefl` is stated at the same `{α : Type}`, so the proof of irreflexivity through it has the same limit (not compiled separately). R9 proves `WidensOrLaterAt.irrefl`, `.trans` and `.not_reversed` at `S : Type u` by pattern matching, and `widensOrLaterAt_iff` shows it is the module's order at `Type` by `Iff.rfl`. `not_reversed` never used `strictJoin_*`.

*Fix.* With N6's preferred fix the section takes `S : Type u`. Otherwise NOTE §5: "irreflexivity and transitivity of the lagged order are taken from UE9's `strictJoin_*`, stated at `Type`, so that section takes `S : Type`; the definition and `not_reversed` would not need it".

### N8. The header drops the hypotheses of `no_comparison_through_bundles` (overclaim)

*Location.* Header lines 136–138 ("So no comparison read off a description that the bundles realizable within every bound determine satisfies C on the reachable ranges"); the theorem's docstring, line 1248 ("the bundles at a configuration"); NOTE §3 line 75 ("realizable at a configuration"). NOTE law 7 (line 64) names the irreflexivity.

*Evidence.* The theorem takes `irreflexive : ∀ d, ¬ compare d d` and is stated on `KeptTogether.process`. Without irreflexivity the sentence is false: a constant description, which the bundles determine, with the comparison holding everywhere, satisfies C on `KeptTogether`'s reachable ranges (R20a `bundles_need_irreflexive`). And it is the witness's law, not every process's: on a process of one configuration every comparison satisfies C on the reachable ranges, since no configuration extends another (R20b `one_configuration_comparison`). The landed precedent names both: Bundles' header says "so no comparison read off a summary that marginals determine, comparing no summary with itself, satisfies C", inside the `Regimes` witness's bullet.

*Fix.* Header: "So on this witness no comparison read off a description that the bundles realizable within every bound determine, comparing no description with itself, satisfies C on the reachable ranges". Docstring line 1248 and NOTE §3: "the bundles realizable from a configuration".

### N9. The determined-case clause omits the realized courses' start (imprecision)

*Location.* Header lines 107–108 ("on a determined process realized widening gives widening what can be reached"); `KeptAlternative.no_order_contains_both`'s docstring, lines 1120–1122 ("A determined process gives no such conflict"); NOTE law 5 line 51 ("so the conflict needs branching").

*Evidence.* `widens_of_rangeWidens` takes `start : r.state 0 = s` and `start' : r'.state 0 = s'`. On a determined process (the identity law on three configurations) with realized courses not starting at their configurations, realized widening ranks `mid` above `hi` while `hi` widens what can be reached over `mid`, so no strict partial order contains both (R22 `Three.conflict_without_start`). The intended reading, a course "from" each configuration, starts there, and then the clause holds; the Lean's `course : S → Run P` does not say so, as `Reaching.Lexical`'s docstring already notes.

*Fix.* Add "with the realized courses starting at their configurations" in the three places.

### N10. NOTE §5: `Law.runs_agree` is "proved here … rather than importing Branching" (error)

*Location.* NOTE §5 line 102. (The brief's "which the module does not import" holds of direct imports only.)

*Evidence.* `Becoming.Branching` is in the module's import closure, through `Onward → Parting → Distinguishing → Likeness → Branching`, with or without `ComparingCourses`; the module already uses `Branching.units_length` (line 923). R19 `runs_agree_of_orbit` derives the two-run form from `Branching.law_run_state` in a probe importing only `Becoming.ReachableRanges`.

*Fix.* Derive `Law.runs_agree` from `Branching.law_run_state` (three lines, as R19) and say so, or keep the proof and write "the two-run form of Branching's `law_run_state`, which the closure holds".

### N11. NOTE law 3 attaches `Delayed.widens_not_withLag` to the wrong law (imprecision)

*Location.* NOTE law 3, "The rise" (line 38): "(`Reaching.widens_next_iff_rising`), UE9's `Delayed.widens_not_withLag` read on courses".

*Evidence.* UE9's `Delayed.widens_not_withLag` is a witness: the rising course widens its one-step-late copy and does not widen it with a lag. Its reading on courses is `Rise.rises` with `Run.coversLater_next`: the rising step is same-offset widening and the lag part does not rank it (R4 `rise_widens_not_lagPart`). `widens_next_iff_rising` is a different statement, an iff for determined processes.

*Fix.* Move the reference: "On `Rise` the rising step widens what can be reached and the lag part does not rank it, UE9's `Delayed.widens_not_withLag` read on courses."

### N12. NOTE law 3's last two sentences hold; the exact law is stronger (suggestion)

*Location.* NOTE law 3, line 38: "Where the later configuration also covers the earlier, the two cover each other with some lag, so the lag part of the lagged order ranks neither; the lagged order contains same-offset widening, so it ranks the rising step too." Header lines 85–86.

*Evidence.* Both clauses hold: R2b `lagPart_neither_of_covers` and R1 `rise_ranked`. More holds with no premise: the lag part never ranks a configuration of a course above its predecessor (R2 `lagPart_not_next`), so along a course the lagged order ranks a successor above its predecessor exactly where same-offset widening does (R3 `widensOrLater_next_iff`).

*Fix.* Optional: add R2 and R3 to the module and say "along a course the lagged order ranks a successor above its predecessor exactly where same-offset widening does", which is what the lag does there.

### N13. NOTE §6 row 3 calls the review's sentence false without its qualification (imprecision)

*Location.* NOTE §6, row 3: "The finding's sentence that with a lag nothing rises is false for the lagged order its own fix (1b) proposes".

*Evidence.* The fix round's claim, checked as asked: for the joined order `WidensOrLater`, whose first disjunct is same-offset widening, the rising step is ranked (R1 `rise_ranked`; R3 shows it is ranked exactly where same-offset widening ranks it). But the review's sentence ("Read with a lag, then, nothing rises along a course") followed `coversLater_next` and is true of covering with a lag: its strict part never ranks a successor above its predecessor (R2 `lagPart_not_next`). The row's own qualifier ("for the lagged order its own fix proposes") makes it correct; the word "false" alone does not.

*Fix.* "The finding's sentence holds for covering with a lag, whose strict part ranks no successor above its predecessor, and not for the joined order of 1(b), whose first disjunct is same-offset widening; law 3 says what the lag does instead."

### N14. `Web.KeepsWidening.chain` is titled "is" and proved one way (suggestion)

*Location.* Section title line 662 and docstring line 668 ("Keeping widening by name is keeping widening of a chain"); NOTE law 4 (line 44).

*Evidence.* Only by-name keeping widening ⇒ chain keeping widening is proved. The converse holds (R16 `keepsWidening_of_chain`), so the iff does (R16 `keepsWidening_iff_chain`).

*Fix.* Add the converse and state the iff, which makes "is" exact; or write "gives".

### N15. Declarations in other modules' namespaces (suggestion)

*Location.* `Web.KeepsWidening.chain` (line 670), `Web.not_listed_of_chain` (line 686), `Law.runs_agree` (line 823); NOTE §5 line 102.

*Evidence and judgement.* `Web.KeepsWidening.chain` gives dot notation on `W.KeepsWidening …`; `KeepingWidening` already adds `Web.KeepsWidening.*` lemmas from another module, so this follows package practice and is not misleading. `Becoming.Law` is a namespace many modules declare into (fifteen open it, Prelude, Recurrence and Branching among them, and Description, Pace and Unfolding add dotted names; nine of these eighteen are in the module's closure), so `Law.runs_agree` follows practice too, but it re-proves `Branching.law_run_state`'s two-run form (N10). `Web.not_listed_of_chain` restates the landed `Web.KeepsWidening.not_listed` word for word with a second proof; as a name in `Web` it reads like a new law of webs.

*Fix.* Keep `chain`. Derive `Law.runs_agree` from `law_run_state`. Turn `Web.not_listed_of_chain` into a sentence of `chain`'s docstring ("`Web.KeepsWidening.not_listed` follows from this and `Reaching.KeepsWidening.not_listed`"), or keep it under a name that says it is a re-derivation.

### N16. `PossibleWithin`'s docstring identifies the adjacent possible flatly (imprecision)

*Location.* Lines 267–268: "With `k = 1` it is the adjacent possible with the present."

*Evidence.* The header (lines 141–144) and NOTE §4 credit Kauffman's adjacent possible only for a prestated space, as the review allowed (F11); the definition's docstring drops the restriction.

*Fix.* "With `k = 1` it is the adjacent possible with the present, read in a prestated space: one fixed process and one reading."

### N17. "A configuration that starts no course is covered by every configuration" is stated generally, with a witness (suggestion)

*Location.* Header lines 75–77 and 150; NOTE §4 and §5.

*Evidence.* True by definition (R18 `covers_of_no_course`, one line), but the module cites only `NoCourse`.

*Fix.* Add R18 and cite it, or write "(as on `NoCourse`)".

### N18. NOTE §3's wording (imprecision)

*Location.* NOTE §3 lines 71, 73 and 75.

*Evidence.*
- "A rise of same-offset widening along a course is the course's own delay": the iff (`widens_next_iff_rising`) is for determined processes; on any process only `Run.coversLater_next` holds, the predecessor covering its successor with lag one, the delay of the family of courses.
- "so an account that holds both needs a rule of precedence, a premise": the Lean shows that on the witness no strict partial order contains both (`no_order_contains_both`); "needs a rule of precedence" is a reading in a list headed "Shows".
- "The bundles realizable at a configuration": from (N8).

*Fix.* "On a determined process a rise … is exactly the course strictly including its own delay (`widens_next_iff_rising`); on any process the predecessor covers its successor with lag one"; "so on that witness no strict partial order contains both; holding both needs a rule of precedence, a premise **[AI reading]**"; "from a configuration".

### N19. The planned 08 §8 line drops the Kreps label (overclaim, minor)

*Location.* NOTE §7, line 146: "covering as the lower preorder and unanimous flexibility (Kreps)".

*Evidence.* NOTE §4 labels the Kreps link an AI reading, "argued, not proved here"; the review marked it "needs a check".

*Fix.* "covering as the lower (Hoare) preorder, a neighbour of Kreps's preference for flexibility **[AI reading]**".

### N20. `DeferredChoice` (suggestion)

*Location.* Line 1333 and the header.

*Evidence.* The header also says "no choice enters", meaning `Classical.choice`, while `DeferredChoice` uses "choice" for branching. The package's word for branching is `Branching`.

*Fix.* Optional: `DeferredBranching`. The other new names (`Reaching`, `KeptAlternative`, `KeptTogether`, `WiderNow`, `NoCourse`, `AllAtOnce`, `Rise`, `Climb`) are structural, carry no financial or social word, and clash with no declaration (R-clash; `Becoming.Founding.Flow.Rise` is a different namespace; `DeadEnd` and `Static` were rightly avoided).

### What holds (checked, no finding)

- Every docstring not named above states what its theorem states, with its hypotheses: the order laws, `covers_iff_criteria`, the greatest-course forms, the possible and its bridges, `Covers.possible` and `possible_same_of_covers_next` with their premise, the chain law and its instances, the lexical order's laws and `lexical_above` (its converse with the inclusions decided is R21), the instance theorems, and every witness (`Rise`, `Climb`, `NoCourse`, `AllAtOnce`, `KeptAlternative`, `KeptTogether`, `WiderNow`, `DeferredChoice`), each scoped to its witness.
- `KeptAlternative.no_comparison_both` matches its hypotheses: irreflexive and transitive `Better` (a strict partial order), C on `realizedFrame` with this witness's `course`, and C on `reachFrame`; the header's "on this witness" is right.
- `WidensOrLater` never ranks a configuration above one covering it (R5 `widensOrLater_not_covered`), which is stronger than `not_reversed`. It contains widening what can be reached, the constructive form of the strict part of covering; containing the strict part itself on every process would give Markov's principle (R6 `markov_of_strict_in_lagged`). The module does not claim it, and should not.
- The credits in the header are within what the review allowed: Kauffman 2000 restated only for a prestated space, Longo, Montévil and Kauffman 2012 outside; the irreversibility premise of Arrow and Fisher 1974 and Henry 1974 restated, quasi-option value not captured; the pigeonhole of finite recurrence, as `Web.KeepsWidening.not_listed` is, with its converse failing. The bibliographic details NOTE §4 gives match the publications: Arrow and Fisher 1974, *QJE* 88(2); Henry 1974, *AER* 64(6); Kreps 1979, *Econometrica* 47(3); Jones and Sugden 1982, *International Review of Law and Economics* 2:47–65; Pattanaik and Xu 1990, *Recherches Économiques de Louvain* 56:383–390; Bossert, Pattanaik and Xu 1994, *JET* 63:326–345; Sen 1985; van Glabbeek 1990, CONCUR '90, LNCS 458:278–297; Longo, Montévil and Kauffman, arXiv:1201.2069.
- NOTE §5's counts, "term proofs only" and the modelling list are right; §6's counts of the review (21 findings: 1 error, 8 imprecisions, 7 credit, 5 style; 7 major; 8 required) are right, and so are its rows except 3 (N13) and 17 (N9). `Becoming.DeadEnd` (Labelled) and `Becoming.Static` (Feedback) exist, as rows 2 and 12 say.

## 4. Probes

All in [`recheck/tree/Becoming/`](recheck/tree/Becoming/), namespace `Becoming.RecheckUE10`, built with `scratch_build.py` against main together with the byte-identical module copy. None is proposed for landing as written.

| File | sha256 | Theorems / declarations | Axiom report |
|---|---|---|---|
| [`RecheckLag.lean`](recheck/tree/Becoming/RecheckLag.lean) | `f33aae0d…1202` | 25 / 35 | empty |
| [`RecheckLaws.lean`](recheck/tree/Becoming/RecheckLaws.lean) | `81cbab81…f549` | 19 / 26 | empty |
| [`RecheckClash.lean`](recheck/tree/Becoming/RecheckClash.lean) | `97e9848e…c966` | 1 / 1 | empty (334 modules) |
| [`RecheckEnds.lean`](recheck/tree/Becoming/RecheckEnds.lean) | `0a5de0bc…da66` | 3 / 6 | empty |

Rebuilt together with the module on 27 October (`scratch_build.py` with the four modules named): 336 modules, every step restored from the passed steps, none unclean; reports `ReachableRanges` 116 / 171, `RecheckLag` 25 / 35, `RecheckLaws` 19 / 26, `RecheckClash` 1 / 1, each `with_axioms` empty. `RecheckEnds`, added last, was built on its own the same day: 90 modules, its compile and audit run fresh, the rest restored, none unclean, `with_axioms` empty. No probe uses `propext`, `Quot.sound` or `Classical.choice`. The two scratch files outside the tree (the module's `strictJoin_trans` proof at `S : Type u`, refused; the module without `ComparingCourses`, compiled) are evidence for N6 and N7 only and are not kept.

- **R1** `rise_ranked`: the lagged order ranks `Rise`'s rising step, and not conversely.
- **R2** `LagPart`, `lagPart_not_next`: the lag part never ranks a configuration of a course above its predecessor. **R2b** `lagPart_neither_of_covers`: where the successor also covers, the lag part ranks neither.
- **R3** `widensOrLater_next_iff`: along a course the lagged order ranks a successor above its predecessor exactly where same-offset widening does.
- **R4** `rise_widens_not_lagPart`: UE9's `Delayed.widens_not_withLag` read on courses.
- **R5** `widensOrLater_not_covered`: the lagged order never ranks a configuration above one covering it.
- **R6** `StrictCovering.markov_of_strict_in_lagged` (with `covers`, `not_back`, `lagged_back`, `widens_gives`): containing the strict part of covering on every process gives Markov's principle (`Markov`, Horizon).
- **R7** `TwoSided.silent`: a range keeping widening and one wider now on which the lagged order is silent both ways.
- **R8** `AllNow.not_silent`: a determined process where the configuration wider now widens what can be reached over the climb, and the lagged order ranks it above the climb.
- **R9** `WidensOrLaterAt`, `.irrefl`, `.trans`, `.not_reversed`, `widensOrLaterAt_iff`: the lagged order and its laws at `S : Type u`.
- **R10** `StrictOrder`, `lag_beyond_C`: on `WiderNow` two strict partial orders satisfy C on the frame of reachable ranges and disagree on the climb against `none`.
- **R11** `not_widens_of_wider_now`: for widening what can be reached it suffices that the configuration wider now starts a course.
- **R12** `Three.start_needed`, **R13** `Three.start'_needed`: each chosen course's start is needed for the lexical half of `not_above_wider_now`.
- **R14** `widens_without_course`: without a course from the configuration wider now, widening what can be reached ranks the other above it.
- **R15** `inclusion_now_not_covering`: inclusion now does not give covering.
- **R16** `keepsWidening_of_chain`, `keepsWidening_iff_chain`: keeping widening by name is exactly keeping widening of the chain.
- **R17** `coversLater_iff_of_unique`, `widensOrLater_iff_of_unique`, `lagPart_conditions_iff` (`Iff.rfl`), `widensOrLater_conditions_iff_of_unique`, `widensOrLater_of_widensOrWithLag`: the lagged order on a determined process, and with fixed conditions against UE9's.
- **R18** `covers_of_no_course`.
- **R19** `runs_agree_of_orbit`: `Law.runs_agree` from `Branching.law_run_state`, importing only the module.
- **R20a** `bundles_need_irreflexive`, **R20b** `one_configuration_comparison`: the scope of `no_comparison_through_bundles`.
- **R21** `lexical_of_above_decided`: the converse of `lexical_above` with the inclusions decided.
- **R22** `Three.conflict_without_start`: a determined process with a conflict when realized courses do not start at their configurations.
- **R23** `EndsNow.keeps_widening_above_wider_now` (with `process`, `adm`, `climb`, `no_course`, `climb_keeps`): without a course from the configuration wider now, widening what can be reached ranks a climb that keeps widening above it.
- **R-clash** `clash_free`: the root `Becoming` and the module import together.

## 5. Verdict

The Lean is sound: 116 theorems in 171 declarations, every axiom report empty, core imports only, term proofs, no name clash, and every required review item is in the Lean. What remains is wording, mostly in the sentences that would narrow 07's Open item, plus the layer.

**Must change before landing.**
1. **The narrowing sentences** (header lines 23, 35, 43–46, 54–57; docstrings at 323, 379, 701–702; NOTE §1, law 1 and 2 titles, §3, §7's Open item): "needs inclusion now", not "contains" (N1); keep the premise that the configuration wider now starts a course (N2); "the strict part of range inclusion of the two courses", not "widening" (N3); the lag decides `WiderNow`'s pair, not every such pair, and the `WiderNow` sentence is a witness, not a law of determined processes (N4). Each sentence as written has a Lean counterexample (R15; R14 and R23; the review's W3; R7 and R8), and these are the sentences meant for 07's live text.
2. **NOTE law 2 "Its standing" and "it is UE9's lagged order"** (N5): no theorem identifies the two orders; say what R17 shows (fixed conditions, the lag part by definition, the first part as the strict part of inclusion), and that calling the lagged order better is a premise beyond C (R10), not "UE9's question, unchanged".
3. **The header's `no_comparison_through_bundles` sentence** (N8): add "comparing no description with itself" and "on this witness" (R20a, R20b).
4. **The layer** (N6, with N7): either drop the `ComparingCourses` import and prove the join at `S : Type u` (R9; compiles), which keeps the module L1 and lifts `S : Type`, or state "L2 through `Becoming.ComparingCourses`" in NOTE §5 and the README row. A README row saying L1 would contradict 08 §3.
5. **NOTE §5 on `Law.runs_agree`** (N10): Branching is in the closure; derive it from `law_run_state` or correct the sentence.

**Recommended, not required.** N9 (the realized courses' start in the determined-case clause), N11 (move the `Delayed` reference), N12 (R2 and R3 as laws), N13 (§6 row 3), N14 (the chain iff), N15 (`Web.not_listed_of_chain`), N16 (the adjacent possible's docstring), N17 (`covers_of_no_course`), N18 (NOTE §3), N19 (the Kreps label in the 08 line), N20 (`DeferredBranching`). For their owners, outside UE10: the README's L1 rows for `EventualWideningInstances` and `ComparingCourses` against 08 §3's rule (N6).

**Counts.** 20 new findings: 2 errors (N6, N10), 4 overclaims (N2, N4, N8, N19), 9 imprecisions (N1 major, N3, N5, N7, N9, N11, N13, N16, N18), 5 suggestions (N12, N14, N15, N17, N20). Of the review's 21 findings and 8 verdict items: F1 and verdict item 1 partly; F17 and verdict item 8 resolved with one residue; F10 and F19 resolved where taken, the rest declined as optional; F21 not taken (acceptable); all others resolved.
