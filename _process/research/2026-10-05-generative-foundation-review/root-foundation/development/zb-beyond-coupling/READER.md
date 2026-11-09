# ZB: the cold reader's reports

*AI-written, 9 November 2026. One reader of another model (Claude Fable, through the Agent tool) read the statements cold against the Lean, the three records, 07 §3.5, this folder's note and the module's entry in `Becoming.lean`, for overclaim. It ran no build. Its reports are summarized below with what was done about each. The reader's words are condensed, not quoted in full.*

## Round 1 (the first draft)

Verdict, condensed: the Lean and the prose agree on every named theorem; the overclaims are in compressions, not in the laws.

| # | Severity | Finding | Done |
|---|---|---|---|
| 1 | high | The blindness-lifts record's statement said a selection "is turned … exactly where" a member's couplings change; the Lean gives that *some* selection is (a constant one is turned by nothing). | Statement now begins "Some selection read off …", in both languages. |
| 2 | medium | "The dweller coupled in" labelled both witnesses, but in the gauge witness the dweller stays beyond the closure and only the habitat couples in. | "The loss coupled in, through the dweller's continuation read as a member's or a condition it depends on gauged by a member" everywhere; the alias changed. |
| 3 | medium | "A loss coupling into no member is selected for by none" hid the premises (balance, same formations present, like start, members' agreeing exchange). | Every such sentence now names the premises, or points to them ("under the premises of the first law"). |
| 4 | medium | The Clearing witness reads as an instance of the significance law; it is a comparison of two flows, and the significance premise has no witness. | Said in the module, 07 and the record: the witnesses compare two conducts, reading them as counting is a reading, and no act here that reads significance meets the premise. |
| 5 | medium | 07 §3.5's opening said significance enters only as a conduct's index; route (b)'s laws take the own-closure significance. | The opening names both ways. |
| 6 | medium | The alignment reading cited Lean names for a one-level-up instance that is supplied. | The reading says that keeping the reader gives the sparing act is supplied, not proved, and cites "the shape of" each witness. |
| 7 | medium | "Theorem forms of D18, D19" changed the closure (§3.3's feedback is the influence closure) without saying so. | "With feedback read as being affected through what couples in and selection as read off the centers' continuations or couplings." |
| 8 | low | 07 omitted balance. | The restructured law gets balance from the laws (courses and levels generated); 07 says so. |
| 9 | low | `separates_continuations` covers continuations only. | Said so; the coupling form now follows from `selects_alike_all_iff`. |
| 10 | low | "Returns to the center" used in 07 before it is defined; "affecting does not return" is a consequence, not a conjunct. | Defined at first use in 07 and in the record; "so affecting does not return". |
| 11 | low | Two "beyond the closure" facts hold for one flow only. | "In the diverting flow", "in the clearing flow". |
| 12 | low | The index entry omitted premises. | The entry was rewritten with the restructure and names the laws' premises. |
| 13 | low | The note cited a theorem on G1's unlanded branch; its last section dropped premises. | Marked as G1's report, unlanded; the section names (2)'s premises. |
| 14 | low | "Selects against" rests on the convention that a selection selects for what it holds at. | The convention is stated once in the module, 07 and the note. |
| 15 | low (zh) | 根上该关系之一处的续无外 hard to parse. | 根上在该关系与「一」之下的续无外. |

**Found while answering the round, by the author, not the reader.** The repository already had result (1)'s law at a finite horizon with the rest's response derived from a law: `SelectionGap` (the gap for one's own act) and `act_courses_unselected_pool` (its pool form). The first draft re-instantiated `alike_within_closed` with the rest's response supplied. Its premises were weaker than those, and it stood beside them. Board rule 9 asks for the general below, the special derived. So result (1) was rebuilt on `act_courses_unselected_pool`, read over the whole run through `selects_alike_all_iff`. The significance premise is now on the part's act law (`ActReadsWithin`), and result (3)'s coupling form is derived from `selects_alike_all_iff`. The names `ReadsCouplings`/`ReadsContinuations` became `ReadOffCouplings`/`ReadOffContinuations`, since `SelectionPool` already uses `Web.ReadsCouplings` for another relation. The first draft is kept at `refs/salvage/zb/draft-1`.

## Round 2 (the restructured text)

Verdict, condensed: no high finding; result (1) now says exactly what `act_courses_unselected_throughout` and `significance_courses_unselected` prove, premises named; all fifteen round-1 findings fixed.

| # | Severity | Finding | Done |
|---|---|---|---|
| 1 | medium | The two ways the loss is coupled in (the dweller's continuation, a gauged condition) read as exhaustive; the Lean gives any member's admission or any gauged condition's level. | "Some member's admission, or the level of a condition some member gauges"; the two named ways are the witnesses. |
| 2 | low | The records cited a stale hash of the note. | Recomputed after the edits (and again at landing). |
| 3 | low | Hypothesis 1 of the first record named a supplied flow; the courses come from laws. | "A web, laws of exchange, the formations present and the starting levels supplied." |
| 4 | low | The prose used "pool" and "group" the other way round from the Lean. | The closure is a group's; the selection is read off a pool within it. |
| 5 | low | A relative clause attached "beyond the coupling closure" to the act, not the dweller. | Restructured. |
| 6 | low | Diversion's flows are not law-generated courses, so "the premise fails" is by inspection. | "The two acts differ on a condition that couples in, so the premise would fail." |
| 7 | low | A does-not-show line said the witnesses show the shapers' selection; they are base-level. | "Have the shape under which their own selection would not supply it." |
| 8 | low | The note's header kept the first draft's words. | Fixed. |
| 9 | low | "Has to keep" read as design beside a sentence disclaiming design. | "A coupling to keep, on this reading." |
| 10 | low | The scope sentence and index entry omitted that the first act reads through its members' coupling. | Added. |

Also found by the record check (not the reader): the route (b) record lacked a counterexamples list; it now keeps Clearing's dweller as the counterexample to reaching the whole along a returning relation.

## Round 3 (the round-2 fixes)

Verdict, condensed: no high finding; the hashes current; one medium, four low.

| # | Severity | Finding | Done |
|---|---|---|---|
| 1 | medium | "Where the two acts differ on a condition that couples in, … the difference is selected" read as a law; the Lean gives the Diversion instance, and in general only that *some* selection separates where a member's admission or a gauged level differs (two acts can differ on a coupled condition and leave every level alike). | "The difference can be selected, as in `Diversion`", in the module and 07; the record already had "can". |
| 2 | low | The first record's zh statement kept group and pool the wrong way round. | 读自一池……在含该池之某组耦合闭包内. |
| 3 | low | The note's header kept "the pool's coupling closure". | "A group's coupling closure holding the pool." |
| 4 | low | The note kept an ambiguous "which" in the Diversion sentence. | Restructured as in 07. |
| 5 | low | The route (b) record's counterexample omitted "in the clearing flow". | Added, in both languages. |

## Round 4 (the round-3 fixes)

The five changed sentences read as described, each saying what the Lean gives, and the records' hashes matched the files. No high or medium finding remained, so the rounds stop here, by the rule of stopping at the first round with none.

## The readings of route (b)'s join (astra, Opus, Fable)

*Three independent AI readings of the joined pieces, read-only, kept by the session joining them (`/Users/ren/tmp/za-how-far/route-b/join/`), relayed with their items on this piece. Each was checked against the Lean.*

| Item | Reader | Done |
|---|---|---|
| "Some selection is turned exactly where some member differs at some step" extracts a member and step the constructive laws do not give. | astra | Worded as proved: every selection alike exactly when alike through every member at every step; a differing continuation at a given step separates; which member and step is not extracted. |
| Diversion is no counterexample to `ActReadsWithin`: no act indexed by significance is built. | astra | Called a witness of the agreement pattern failing, outside the law's setting. |
| "Reaches" is a bound; cost selects against a reader only in the witness; independent readers are a design proposal. | astra | "Reaches at most"; "can select against, as one does in the shape of `Diversion`"; the proposal labelled. |
| Pooled over every returning formation of a finite flow with reach decided, nothing lies beyond. | astra | Proved: `Flow.returning_pool_covers` (and `_either`), from G1's `Flow.covered_by_returning` and `Flow.withinCoupling_of_withinInfluence`; 07, the record and the notes say the bound bites only for a pool leaving a returning formation out. |
| The third law's premise fails along affecting, where G1's standpoints are; state the per-center form once. | Opus, Fable | `Flow.ownClosure_rival_of_within`, with its two cases `Flow.returning_ownClosure_rival` (by `mono`) and `Flow.reachReturns_ownClosure_rival` (by `Flow.ReachReturns.represented`); `routeB_universal_closed`'s third conjunct takes the per-center form. |
| `Flow.ownClosure_within_coupling` is `WithinClosure.mono` restated; `Becoming.Standpoints` is imported and unused. | Opus, Fable | Both removed. |
| `ownClosure_not_unrestricted_of_acyclic` uses only GrammarScope; move it there. | Opus | Kept in this leaf so that GrammarScope's bytes and the records bound to them do not move for a two-line corollary; said in the note, for the join to decide. |
| The note's wording: the pool's closure, "selected against", the separating selection for couplings, "one of two ways". | Opus, Fable | The group's closure with the pool inside; "that one selection, read with counting"; separation stated for continuations only; the two ways are witnesses. |
| The group is fixed across two courses while G1's standpoints depend on the flow; `Affects` is time-blind, so the acyclic law bites on a dated net. | Opus, Fable | Both stated in the note, the hand-over and, for the second, in 07 and the route (b) record. |
