# UE10 second re-check: the fold-in

AI-written, 27 October 2026. One read-only pass over the fold-in of the [re-check](RECHECK-UE10.md), at its standard: a docstring, a live text or a record says exactly what the Lean states, with its hypotheses and quantifiers. This pass edits nothing but this file and its probe folder [`recheck2/tree/Becoming/`](recheck2/tree/Becoming/), and makes no commit. The same AI agent wrote RECHECK-UE10, so where a finding goes back to one of its suggestions, the finding says so.

**Checked.**
- The module [`tree/Becoming/ReachableRanges.lean`](tree/Becoming/ReachableRanges.lean): 1867 lines, sha256 `0c5db3a2926b512908c75f9cf21519fbe96898a25481fae46db9a84471e0f1f3`, as committed in `cabd2d1c3`. The copy in [`recheck2/tree/Becoming/ReachableRanges.lean`](recheck2/tree/Becoming/ReachableRanges.lean) is byte-identical. The pass also read its diff against the re-checked version (`c6d9b6da…9e79`, in `recheck/tree/`).
- [`NOTE.md`](NOTE.md) (sha256 `e4e82d7d…7bdd`, 177 lines), [`LANDING.md`](LANDING.md) (`02e52c7d…92a7`) and [`scratch.log`](scratch.log) (`38a4381f…a44c`).
- The kit: `texts_ue10.py` (`04a2f8d6…e66c`), `make_records_ue10.py` (`cf310dd4…7eb7`), `integrate_ue10.py` (`522cf62b…3ec4`), `board_ue10.py` (`82c436c7…7eb7`, NOW_NEW and STATEMENTS) and `study_ue10.txt` (`3b206f8e…02ca`). `repoint_ue10.py` was read only for its file list.
- Main. The fold-in was committed in `cabd2d1c3`. Main has since moved to `ee8b440b6`: DF1b landed as study §422, and the views were re-rendered. No file of the Lean package has changed since `b766aa81f`, the base of `scratch.log`.

## 1. Build, reports, names and layers

- **Build.** `scratch_build.py` on the tree reports 134 theorems in 195 declarations with `with_axioms` empty, over 68 modules, as `scratch.log` says. The module was also compiled by hand with the checker's Lean: exit 0 and no message, and the fresh `.olean` is byte-identical to the cached one. The audit file was run by hand too: 195 of 195 "does not depend on any axioms". The source has 134 `theorem`s, 58 `def`s and 3 `inductive`s. Outside comments it has no `by`, `simp`, `decide`, `omega`, `▸`, `propext`, `funext`, `Classical`, `Quot`, `sorry` or `axiom`.
- **Names.** The root `Becoming` and the folded module import together without a clash (probe `Recheck2Clash`: 334 modules, clean).
- **Layers** (check 3), on main:
  - `Becoming/EventualWideningInstances.lean` imports `Becoming.EventualWidening`, `Becoming.Verification` and `Becoming.Weightings`. `Weightings` is L2 in the package README.
  - `Becoming/ComparingCourses.lean` imports only `Becoming.EventualWideningInstances`.
  - So both labels were wrong at L1, and the kit's relabel is right. "L2, through `X`" in the root bullets and "(L2 through `X`; no ethical predicate)" in the README rows follow `KeepingWidening`'s row. Only `KeepingWidening` (L2) and `ComparingCourses` import either module, so the relabel creates no new L1 row above an L2 one.
  - The folded module's closure (67 modules besides itself; `Std` comes only through the foundation's `GenerativeCore`) holds no module the README marks L2, and no source in it names `Unrestricted` or `Valuation`. The module is L1.
  - After the relabel, three L1 rows still have L2 modules in their closures. They predate UE10 (note 7).
- **The kit on today's main.** The kit was run on a scratch copy of `ee8b440b6`, outside the repository:
  - `integrate_ue10.py` applies, every edit exactly once.
  - `texts_ue10.py` applies with `N = 423`, since DF1b took §422.
  - `make_records_ue10.py --caps` passes: caps, cover and the three records' next-step asserts.
  - The board's four STATEMENTS, NOW_OLD and UE_OLD are each found once in the board. The head-of-queue clause does not exist yet; it is set at claim time.
  - The full record run and the repoint need the landing receipt, so they were not run.

## 2. The re-check's findings, as folded

| Item | As meant? | Where it stands |
|---|---|---|
| N1 inclusion now | yes | "implies inclusion now" in the header (lines 22, 34), `Reaching.Covers.now`'s docstring, NOTE law 1, §1, §3 and §7, and every kit text; `WiderNow.inclusion_now_not_covering` is exact. |
| N2 the start premise | partly | Kept in the module, NOTE law 1, 07's theorem paragraph, the record's statement and hypotheses, the README rows and the study. It is dropped in 07's pointer from eventual widening and in three record sentences (M1). |
| N3 the strict part of inclusion | partly | Exact in the header (line 48), `widens_iff_of_unique`, the record's laws, the root bullet and the README rows. In 07's Open item, the UE plan, the board and NOTE §1, §3 and §7, "is the strict part" has covering as its subject (M2). |
| N4 the witness read as a law | partly | The `WiderNow` sentences are scoped to the witness, and `TwoSided` and `Full` were added. `Full` is cited for "not every such pair", which it does not show (M3). `Reaching.WidensOrLater`'s own docstring cites `TwoSided` alone, rightly. |
| N5 UE9's order and the standing | partly | "Built as UE9's lagged order is, on families of courses", `coversLater_iff_of_unique` and `widensOrLater_iff_of_unique` are in, and so are `comparison_widens`, `comparison_widensOrLater` and `comparison_undecided`, all exact. Two phrases are left: "the join of UE9's order" (M7) and NOTE's "the converse needing exceeding decided" (M8). |
| N6 the layer | yes | §1 above. |
| N7 `S : Type` | yes | The lag section takes `S : Type u`, `A : Type v`. |
| N8 the bundles law | yes | Header lines 156–159 and the docstring at line 1440. |
| N9 the start in the determined case | yes | Header lines 126–128, `KeptAlternative.no_order_contains_both`'s docstring and NOTE law 5. |
| N10 `Law.runs_agree` | yes | Derived from `Branching.law_run_state` (lines 975–980), and NOTE §5 corrected. |
| N11 `Delayed` | yes | NOTE law 3. |
| N12 the lag along a course | yes | `Reaching.WidensWithLag`, `Run.not_widensWithLag_next`, `Run.widensOrLater_next_iff` and `Reaching.WidensOrLater.not_covered`, each exact. |
| N13 NOTE §6 row 3 | yes | |
| N14 the chain iff | yes | `Web.KeepsWidening.of_chain` and `Web.keepsWidening_iff_chain`. |
| N15 `Web.not_listed_of_chain` | taken, wrongly advised | Removed, as the first option of N15 suggested, so the derivation it proved is now claimed in prose with no Lean behind it (M4). That option was RECHECK-UE10's error. |
| N16 the adjacent possible | yes | `PossibleWithin`'s docstring now says "read in a prestated space". |
| N17 `covers_of_no_course` | yes | |
| N18 NOTE §3 | yes | The rule of precedence is labelled. |
| N19 the Kreps label | yes | The 08 bullet carries "[AI reading]". |
| N20 `DeferredChoice` | yes | Renamed `DeferredBranching`, and the header says "no choice principle enters". |
| R21 | yes | `Reaching.lexical_of_above_decided` is exact. `lexical_above`'s docstring still says "needs" (note 3). |
| R23 | yes | `EndsNow` is exact, and the module, NOTE, 07's theorem paragraph, the record (its own law group), the root bullet and the study cite it. |

The new docstrings match their statements, apart from notes 1 to 3. Each new name says what its statement means.

## 3. Findings

### M1. The start premise is dropped where 07 and the records point to UE10 (required before landing)

*Location.*
- `texts_ue10.py` lines 35–36, 07 §2, eventual widening's reading: "What a course keeps reachable ranks a range that keeps widening above one wider now only read with a lag, and then not every such pair".
- `make_records_ue10.py` lines 502–504, the new record's related entry for eventual-widening: "covering implies inclusion now, so what a course keeps reachable ranks such a pair only with a lag".
- Lines 577–579, the related entry added to eventual-widening and what-keeping-widening-needs: "so it ranks a range that keeps widening above one wider now only with a lag" (both languages).
- `EW_ND`, lines 399–403, eventual widening's next step: "what a course keeps reachable ranks such a pair only with a lag". The only pair before it there is the one UE9's two lag orders rank oppositely, which UE10 does not treat.

*Evidence.* The module's own `EndsNow.keeps_widening_above_wider_now` refutes each sentence as written. In that witness, same-offset widening of what can be reached, with no lag, ranks a climb that keeps widening above a configuration that admits now what the climb does not, because that configuration starts no course. "Only with a lag" holds only for a configuration wider now that starts a course (`Reaching.not_widens_of_wider_now`). The record sentences also read the lag as ranking every such pair, though it ranks one witness's pair (`WiderNow.decided`, `WiderNow.TwoSided.silent`).

*Fix.*
- 07: "…above one wider now that starts a course only read with a lag, and then not every such pair…".
- The two related entries: "…ranks a range that keeps widening above one wider now that starts a course only with a lag, and not every such pair" (Chinese: "…排在起进程且当下更宽者之上，且非每一此种对").
- `EW_ND` is at its caps (390/400, 178/180), so it can take no longer clause. One version that fits (398/400, 180/180) replaces the clause with "what a course keeps reachable is read: a lag decides one witness's pair ({RID})" (Chinese: "进程保持可达者已读：滞后定一见证之对（{RID}）").

### M2. "On a determined process it is the strict part of range inclusion", with covering as its subject (required before landing)

*Location.*
- 07's Open item, `texts_ue10.py` lines 59–63.
- The UE plan, lines 120–125.
- `board_ue10.py` NOW_NEW, lines 19–23.
- NOTE §1 (line 11), §3 (line 72) and §7 (line 174).

Each reads: "covering, … implies inclusion of what each configuration admits now, so it never ranks …, and on a determined process it is the strict part of range inclusion of the two courses".

*Evidence.* Covering is reflexive (`Reaching.Covers.refl`), so it is the strict part of nothing. Probe Q3 (`covering_not_strict`) shows it on `WiderNow`: `none` covers itself, while the strict part of range inclusion does not relate `none`'s course to itself. On a determined process covering is range inclusion of the two courses (`Reaching.coversLater_iff_of_unique` at lag `0`). Widening what can be reached is the strict part (`Reaching.widens_iff_of_unique`). The README rows and the root bullet get this right, because their subject is widening what can be reached. "So it never ranks" is true of covering read as a ranking (`Reaching.Covers.now`), and of its strict part too.

*Fix.* In each place, make widening what can be reached the subject: "…implies inclusion of what each configuration admits now, so widening what can be reached never ranks a configuration above one that starts a course and admits now what it does not, and on a determined process it is the strict part of range inclusion of the two courses; read with a lag it decides one witness's pair…". In NOTE §3, change the second "it" to "widening what can be reached".

### M3. `WiderNow.Full` is cited for "not every such pair" (required before landing)

*Location.*
- The module header, lines 68–70: "It does not decide every such pair: with other admissions on the same process it is silent both ways (`WiderNow.TwoSided.silent`), or ranks the configuration wider now above the climb, as same-offset widening does (`WiderNow.Full.not_silent`)".
- NOTE law 2, where `Full` is listed under "*Where it does not*" [decide] (line 31), and §3 (line 73): "though not every such pair (`WiderNow.TwoSided`, `WiderNow.Full`)".
- The root bullet in `integrate_ue10.py`, lines 84–86: "It decides one witness's pair where same-offset covering is silent …, not every such pair (`WiderNow.TwoSided.silent`, `WiderNow.Full.not_silent`)".

*Evidence.* The pair of the witness's kind has three properties: the climb keeps widening, `none` admits now what the climb does not, and each course exceeds the other, so that same-offset widening is silent. `Full`'s pair lacks the third.
- In `Full` the climb's course does not exceed `none`'s (Q4a, `full_climb_not_exceeding`). Same-offset widening is not silent there: `none` widens what can be reached over the climb (`Full.not_silent`'s own conjunct).
- In `Full` the lagged order does decide the pair, the other way round, so `Full` is no instance of "does not decide".
- On `WiderNow`'s process, `Full`'s outcome is impossible for any pair of the witness's kind. Wherever the climb's course exceeds `none`'s, under any admissions, the lagged order never ranks `none` above the climb (Q5, `not_ranked_above_exceeding_climb`).
- `TwoSided` alone supports "not every such pair". Its two courses do exceed each other (Q4b, `twoSided_exceeds_both`), although `TwoSided.silent` does not state it. `Reaching.WidensOrLater`'s docstring already cites `TwoSided` alone.

*Fix.*
- Cite `WiderNow.TwoSided.silent` alone for "not every such pair".
- State `Full` apart, for example: "Where the configuration wider now also widens what can be reached over the climb, the lagged order ranks it above the climb, as it must (`WiderNow.Full.not_silent`, `Reaching.WidensOrLater.not_reversed`)".
- In NOTE law 2, give `Full` its own bullet rather than "*Where it does not*".
- Optionally, add Q4b's two conjuncts to `TwoSided.silent`, each a one-line term, so that "such" covers exceeding in the Lean. If so, add 0 declarations and update no counts.
- The study's sentence (`study_ue10.txt` lines 35–36) is exact about each witness. Its "so it does not decide every such pair" rests on `TwoSided` alone. "…silent both ways (TwoSided: adm, silent), so it does not decide every such pair, or, where none also widens what can be reached over the climb, ranks none above it (Full: adm, not_silent)" would say so.

### M4. A derivation of `Web.KeepsWidening.not_listed` is claimed, and the Lean no longer has it (required before landing)

*Location.*
- The header, lines 112–114: "so the web's law over a listed type, `Web.KeepsWidening.not_listed`, follows from the chain's".
- `Web.KeepsWidening.chain`'s docstring, lines 702–704: "With `Reaching.KeepsWidening.not_listed` it gives `Web.KeepsWidening.not_listed`".
- NOTE law 4 (line 47), "follows from the law for chains", and §6's N15 row, which says the docstring "says how `Web.KeepsWidening.not_listed` follows".
- The record's dependency on eventual-widening (`make_records_ue10.py` lines 461–464): "Web.KeepsWidening and Web.KeepsWidening.not_listed, of which the chain law gives an instance and a derivation".

*Evidence.* `Web.not_listed_of_chain` was removed. No declaration in the module derives `Web.KeepsWidening.not_listed`, and the module's code does not use it, so it is not formally reused either. The derivation holds in one line (Q1, `not_listed_via_chain`: `fun keeps => keeps.chain.not_listed ⟨fs, fun _ f _ => every f⟩`). But that is a probe, and the repository's rule asks Lean of every new proof claim. The removal followed the first option of RECHECK-UE10's N15. That option was the error, and its second option, keeping the theorem under a name saying it re-derives the landed law, was the right one.

*Fix.* Choose one.
- (a) Restore Q1 as a theorem, under a name saying it re-derives the landed law. Then update the counts (135 theorems in 196 declarations) in NOTE §5 and §6, the study's evidence, the record, LANDING.md and the commit and board texts.
- (b) Claim no derivation:
  - Header: "…is exactly keeping widening of its chain (…), and the web's law over a listed type, `Web.KeepsWidening.not_listed`, is the same pigeonhole."
  - Drop the docstring's second sentence.
  - NOTE law 4: "is the same pigeonhole read by name".
  - N15 row: "removed; the texts claim no derivation".
  - Record: "Web.KeepsWidening, which the chain law reads both ways (Web.keepsWidening_iff_chain); Web.KeepsWidening.not_listed is the same pigeonhole, not used here."

(b) changes no count.

### M5. The root bullet drops the lexical order's start premise (required before landing)

*Location.* `integrate_ue10.py` lines 76–78, the root module's bullet: "…nor does the lexical order (`Reaching.not_above_wider_now`), the premise being needed (`EndsNow.keeps_widening_above_wider_now`)".

*Evidence.* The lexical half of `Reaching.not_above_wider_now` takes each chosen course to start at its configuration (`start`, `start'`). Without either, it fails where the configuration wider now starts a course.
- Q2a (`Three.start_needed`): `lo`'s chosen course starts at `hi`. The lexical order ranks `lo` above `mid`, which starts a course and admits now `0`, which `lo` does not admit.
- Q2b (`Three.start'_needed`): `hi`'s chosen course starts at `lo`, and the lexical order ranks `mid` above `hi`.

"The premise" in the bullet is the other premise, that the configuration wider now starts a course. The header, NOTE law 1, 07's theorem paragraph, the checker scope text and the study all keep the chosen courses' start.

*Fix.* "…nor, with the chosen courses starting at their configurations, does the lexical order (`Reaching.not_above_wider_now`); the premise that the configuration wider now starts a course is needed (`EndsNow.keeps_widening_above_wider_now`)".

### M6. "A rise … is its own delay" (recommended)

*Location.*
- The root bullet, lines 90–92: "a rise of same-offset widening along a course is its own delay".
- The README rows: English line 141, "a rise along a course is its own delay"; Chinese line 159, "沿进程之上升即其自身之延迟".
- Board STATEMENTS (2), line 46: "as the course's own delay".
- The header bullet's title, line 74: "and the rise is the course's delay".

*Evidence.* `Reaching.widens_next_iff_rising` says this: on a determined process, the next configuration widens what can be reached over the present one exactly when the course one step on strictly includes the course, offset for offset. A rise is that strict inclusion, not the delay, which is a course. 07's paragraph ("the course compared with itself one step late"), the theorem's title ("the course against its own delay") and NOTE law 3 are acceptable.

*Fix.* "On a determined process a rise is the course one step on strictly including the course (`Reaching.widens_next_iff_rising`)". In Chinese: "决定性过程上，上升即进程后移一步严格包含进程本身".

### M7. "The join of UE9's order read on families of courses" (recommended)

*Location.* The header, line 57.

*Evidence.* UE9's order (`Web.WidensOrWithLag`) is already a join. With fixed conditions on a determined process, the lagged order contains UE9's order of the two courses' levels (Q6b). The converse holds where exceeding back is decided (Q6c), since here the first part reads the negation of inclusion where UE9's reads exceeding (Q6a). So "UE9's order read on families of courses" reads as identity. The bullet's title already says it exactly: "built as UE9's lagged order is".

*Fix.* "…the lagged order (`Reaching.WidensOrLater`), joined as UE9 joins widening and widening with a lag".

### M8. NOTE law 2, "Its standing": "the converse needing exceeding decided" (recommended)

*Location.* NOTE line 33.

*Evidence.* R17 proved that UE9's order lies inside the lagged order (`widensOrLater_of_widensOrWithLag`), not the converse. The converse where exceeding back is decided is proved now, as Q6c (`ue9_of_widensOrLater_decided`). That it *needs* the decision, without which it fails, is proved by neither, and could not be shown by a Lean witness at all. `Reaching.lexical_above`'s docstring has the same "needs" (note 3).

*Fix.* "…and UE9's order lies inside it (R17); the converse holds where exceeding back is decided (RECHECK2 Q6c)".

### Notes

1. `WiderNow.comparison_undecided`'s docstring says both orders "are strict partial orders". The statement does not include that, and the parenthetical cites only `comparison_*`. Cite `Reaching.Widens.irrefl`, `.trans`, `Reaching.WidensOrLater.irrefl` and `.trans`, or drop the phrase.
2. `WiderNow.TwoSided.silent`'s docstring says "since neither covers the other at any lag". That is true, and the proof shows it, but the statement does not export it. It is fine as a remark on the proof.
3. `Reaching.lexical_above`'s docstring (line 938) says "The converse needs the inclusions decided". Sufficiency is proved (`Reaching.lexical_of_above_decided`), necessity is not, as in M8. "The converse holds where the inclusions are decided (`Reaching.lexical_of_above_decided`)".
4. NOTE §6 (line 143) gives R1 as following from `Rise.rises` with `Run.not_widensWithLag_next`. R1, the lagged order ranking the rising step and not conversely, follows from `Rise.rises` through the first disjunct and `Reaching.WidensOrLater.not_reversed`. `Run.not_widensWithLag_next` gives R4.
5. Board STATEMENTS:
   - (1) The "so it never ranks…" clause follows the determined-process clause, though never-ranking holds on every process, from inclusion now. Moving it before "on a determined process" fixes that.
   - (3) "Holding both needs a rule of precedence" is unlabelled, where NOTE labels it [AI reading].
6. LANDING.md line 52 should add `recheck2/tree/.build`, this pass's build output, to the build output removed after landing. The untracked `probes/tree/Becoming/ComparingCourses.lean` is byte-identical to the landed module (`e5d2cb98…`): a redundant copy, removable once no session uses it.
7. Layers elsewhere, older than UE10 and for their owners:
   - `Becoming.OverExchange` (L1) imports `Becoming.Direction` (L2).
   - `Becoming.GrammarScope` (L1) imports `Becoming.Weightings` (L2).
   - `Becoming.GrammarCases` (L1) imports `GrammarScope`.
   - `Becoming.Growth`, `Becoming.JointDraw` and `Becoming.ContinuedClasses` have root bullets but no package README row.

   The study's "found two landed modules labelled L1 that import an L2 module" is right for this leaf's line, but it is not the whole package. "Two in this line; three more elsewhere are for their owners" would say so.

## 4. Probes

Built with `scratch_build.py` in [`recheck2/tree/`](recheck2/tree/), against main's package (unchanged since `b766aa81f`):

| File | sha256 | Theorems / declarations | Axiom report |
|---|---|---|---|
| [`Recheck2UE10.lean`](recheck2/tree/Becoming/Recheck2UE10.lean) | `cbd6e7ca…f8d7` | 11 / 17 (90 modules) | empty |
| [`Recheck2Clash.lean`](recheck2/tree/Becoming/Recheck2Clash.lean) | `2060cc7b…c805` | 1 / 1 (334 modules) | empty |

- **Q1** `not_listed_via_chain`: `Web.KeepsWidening.not_listed` follows from the chain law in one line (M4).
- **Q2** `Three.start_needed`, `Three.start'_needed` (with `Three.hi_widens_mid_range`): each chosen course's start is needed for the lexical half of `Reaching.not_above_wider_now`, the configuration wider now starting a course (M5).
- **Q3** `covering_not_strict`: covering is reflexive, so it is not the strict part of range inclusion (M2).
- **Q4** `full_climb_not_exceeding`, `twoSided_exceeds_both`: `Full`'s climb does not exceed `none`'s course, while `TwoSided`'s courses exceed each other (M3).
- **Q5** `not_ranked_above_exceeding_climb`: on `WiderNow`'s process, under any admissions, wherever the climb's course exceeds `none`'s, the lagged order does not rank `none` above the climb (M3).
- **Q6** `widensOrLater_conditions_iff`, `widensOrLater_of_ue9`, `ue9_of_widensOrLater_decided`: with fixed conditions on a determined process, the lagged order against UE9's. Its first part is the strict part of inclusion, UE9's order lies inside it, and the converse holds where exceeding back is decided (M7, M8). `Recheck2UE10` imports `ComparingCourses` for Q6 only.
- **Clash** `clash_free`: the root `Becoming` and the folded module import together.

None is proposed for landing as written. Q1 is option (a) of M4, and Q4b fits `TwoSided.silent` if M3's optional conjuncts are wanted.

## 5. Verdict

The Lean is sound and needs no change: 134 theorems in 195 declarations, every axiom report empty, core imports only, term proofs and no name clash. Every finding of RECHECK-UE10 is in the module, and R21 and R23 are in exactly. The layer correction is right and complete for this line. The kit applies on today's main, with `N = 423`.

**Required before landing.** Five items, all wording or citation:
1. **M1.** Keep "that starts a course" where 07 §2 and the records point to UE10: 07's eventual-widening reading, the two related entries and `EW_ND`. `EW_ND` must stay within its caps.
2. **M2.** Make widening what can be reached, not covering, the subject of "the strict part of range inclusion of the two courses": 07's Open item, the UE plan, the board's NOW_NEW and NOTE §1, §3 and §7.
3. **M3.** Cite `WiderNow.TwoSided.silent` alone for "not every such pair", and state `WiderNow.Full` apart: the header, NOTE law 2 and §3, and the root bullet.
4. **M4.** Either restore the one-line derivation of `Web.KeepsWidening.not_listed` (Q1) or stop claiming it: the header, `chain`'s docstring, NOTE law 4 and §6, and the record's dependency.
5. **M5.** Add the chosen courses' start to the root bullet's lexical clause.

Recommended: M6 to M8. The notes need nothing before landing, except that note 6's removal list belongs in LANDING.md.
