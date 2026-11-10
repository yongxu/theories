# Cold read of 5d1486dc2

AI-written review. Read-only inspection; no builds, renders, edits or commits, apart from this output file. Locations below refer to `theories/becoming/results/atlas/entries/dynamics.json`; `ReadOffInTime.lean` means `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadOffInTime.lean`.

1. **Medium — A sufficient exit that only proves continued blindness.**
   **Where:** lines 5896–5905, `unselected-beyond-the-coupling-closure` → `reading-a-loss-in-time`.
   **Said:** the dated blindness is an exit of strength `sufficient`, certified by `Becoming.Web.selectsAlike_unreached`.
   **Source:** that declaration, `ReadOffInTime.lean:517–528`, concludes only `select W.level ↔ select W'.level` under deadline, non-reach and read-off premises. These premises can hold inside the source dynamic; their conclusion preserves indistinguishability, rather than showing departure from it. The theorem supplies neither a first separation nor recoverability nor a loss deadline. Even identical courses satisfy this law. The cited home, `07-SIGNIFICANCE.md:254–258`, states a bound on first separation; the record `when-a-selection-read-off-continuation-reads.md:76–77` calls the whole-run relationship “related, not a proved adapter.” The destination includes late readings as well as timely ones, but that does not turn a bounded version of blindness into a proved exit from whole-run blindness.
   **Fix:** Present this as a sourced relationship between whole-run and dated blindness, without a sufficient-exit strength, or supply a recorded law that actually establishes the claimed departure.

2. **Medium — An iff between potential routes is not an exact exit from mutual dependence.**
   **Where:** lines 19553–19562, `mutual-dependence-and-its-pace` → `reading-a-loss-in-time`.
   **Said:** the edge is `exact`, using `Becoming.TimedResponse.reachedBy_iff_reachedInTime`.
   **Source:** `ReadOffInTime.lean:480–483` proves `ReachedBy … g T ↔ Flow.ReachedInTime … g T`, given equal presence and persistent source membership. Neither side states mutual dependence, admission differences, a selection, recoverability, or a loss. Its hypotheses can hold in a mutually dependent flow, including comparison of that flow with itself, without any first step apart. The home at `07-SIGNIFICANCE.md:251` identifies two descriptions of a potential route; it does not give an iff for moving from mutual dependence to the destination dynamic. `the-route-is-the-relation-in-time.md:30` explicitly excludes establishing an actual difference, and line 45 leaves stating the condition on the two-course relation as next work.
   **Fix:** Keep the iff as a relation-identification within the mechanism, or make the cross-dynamic connection a sourced reading without exact strength until a suitable adapter is recorded.

3. **Medium — “Before that step” is false of the supplied witness.**
   **Where:** line 6114, mechanism: “Two things come before that step,” referring to the first step apart, followed by margin crossing and route arrival.
   **Source:** `when-a-selection-read-off-continuation-reads.md:8` says “by then,” and `Web.FirstApart.not_unreached` concerns reach **by T**, not strictly before T (`ReadOffInTime.lean:530–544`). `FourReaders.near_inTime` puts the near gauge's gap within its margin at step 1 and outside at its first step apart, step 2 (`:1178–1184`). The listener is first apart and first reached at step 3, not reached by step 2 (`FourReaders.listener_late`, `:1357–1368`; home `07-SIGNIFICANCE.md:273`). The strict inequality belongs between first separation and the point of no return, not between arrival/crossing and first separation.
   **Fix:** Replace “Two things come before that step” with “By that step the gap has crossed a member's margin and, under the deadline premises, the group cannot remain wholly unreached.”

4. **Medium — The mechanism omits the extra premise for the route equivalence.**
   **Where:** line 6114, “under timely response's deadline premises … what a potential route … has carried … is exactly what that closure meets.”
   **Source:** `TimedResponse.reachedBy_iff_reachedInTime` additionally requires `∀ t h, source t h → source (t + 1) h` (`ReadOffInTime.lean:480–482`). The deadline premises of `Web.selectsAlike_unreached` at `:518–525` do not include that premise. `the-route-is-the-relation-in-time.md:25,31` and `07-SIGNIFICANCE.md:251` expressly condition the converse on the source going on. The entry's hypothesis references do include the route record, but this sentence incorrectly presents the deadline premises as sufficient for the embedded equivalence; the incoming edge itself states the additional premise correctly.
   **Fix:** Qualify the equivalence separately with equal presence before the step and source membership persisting from each step to the next.

5. **Medium — Positive reachability is stronger than the constructive conclusion cited.**
   **Where:** line 6114, “the closure in time of a source occurrence meets a member,” asserted as a consequence at first separation under the deadline premises.
   **Source:** `Web.FirstApart.not_unreached` concludes `¬ ∀ g, group g → ¬ Flow.ReachedInTime … g T` (`ReadOffInTime.lean:533–542`), not an existential reached member/source occurrence. The law in `when-a-selection-read-off-continuation-reads.md:17` preserves that distinction: “it is not that the closure meets no member.” No decidability or classical conversion is stated in the entry. A positive witness exists in FourReaders, but that does not strengthen the general theorem's quantifier.
   **Fix:** Use the theorem's negative formulation for the general claim, reserving a positively reached member for the witness or an explicitly justified existential corollary.

6. **Medium — The own-continuation summary drops the preserved-comparison premise.**
   **Where:** line 6114, “Read off the continuation of what is lost alone, it is read only once it has happened.”
   **Source:** `Web.too_late_of_own` requires both that keeping implies every member's admission at every step and that the other course admits every member throughout (`ReadOffInTime.lean:743–748`; `a-loss-read-before-its-point-of-no-return.md:19`; `07-SIGNIFICANCE.md:267`). Reading the losing member alone does not supply the latter. For example, a member can remain admitted on the losing course until step 3 while the comparison course already fails its admission at step 1; if the losing course is recoverable through step 2, its own continuation distinguishes those courses in time. The entry's second exit correctly gives both premises, but the mechanism's unconditional sentence broadens it.
   **Fix:** Say that own-continuation reading is too late when keeping requires the members' admission throughout and the comparison course admits them throughout.

7. **Low — The blanket account of proof character hides the substantive route identification.**
   **Where:** line 6114, “Near-definitional laws and compositions; the witness is computed.”
   **Source:** the records' shared evidence paragraph uses this wording, but the Lean explicitly labels the route identification “substantive, short” (`ReadOffInTime.lean:34–51`), and the home calls it “a short induction both ways” (`07-SIGNIFICANCE.md:251`). The actual proofs establish two-way transport between independently defined reach constructions (`Spread.withinTime`, `reachedBy_of_reachedInTime`), whereas the near-definitional description fits first separation and recovery. This is inherited imprecision in a source, not a new mathematical claim introduced solely by the atlas.
   **Fix:** Distinguish the near-definitional timing laws and compositions from the short substantive identification of the two potential-route relations.

8. **Low — The revised open item adds a supported cross-reference but cites only the old limitation.**
   **Where:** lines 21458–21459, `readings-carried-and-filtered.open[0]`.
   **Said:** “How readings are revised at descent, spread and lock is readings-revised-spread-and-locked,” citing only `readings-carried-on-their-course.md#does-not-show--未表明`.
   **Source:** the cited section, lines 36–39, supports the missing run of differing picks and the limitation that those records never vary or learn readings; it does not state the new positive claim. The named destination really exists (atlas line 21482 onward), and its records carry revision and counts (`readings-revised-at-descent.md:13–23`) with supplied update and sensing (`:30`), and the conditional lock. Thus the cross-reference is substantively justified, but not by the cited source alone.
   **Fix:** Split the remaining limitation from the cross-reference and cite the revision/lock home for the latter.

Other checks: all five distinct named laws on the six added exits exist in their stated namespaces, located by last-name searches of `Becoming/`. The two sufficient exits out to too-late states state compatible premises and have the right strengths; the FourReaders regime link is properly a witness, not a general iff exit; the MA2/MA4b edge has no law or strength and is carried by the marked AI reading at `07-SIGNIFICANCE.md:279`. The transition's explicit “Given T and N” and `T < N` match `Web.readableInTime_iff`. The new entry's four open items and beyond witness are supported. The revised own-survivors open item accurately retains the changing-pool limitation and cites its source. No good/bad label was introduced.

Counts: high 0, medium 6, low 2.
