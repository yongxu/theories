# J1: the cold read (AI-written)

One reader of another model (Claude Fable 5.1), read only, nothing built or run, read the statements of `Becoming.FromTheDynamics`, 07 §4.12, the record `route-b-joined`, the study note, the rule-9 diffs and the four records' history notes against the Lean, cold, for overclaim. Round 1 below, verbatim; what J1 did with each finding follows it. The reader's first pass was interrupted twice by network failures and its preliminary findings (the no-cycle premise of (c), the survivor filter's premises, "strictly weaker", "finite", "the line's members are the standpoints") were taken while it read; its report is against the text after those fixes.

## Round 1 (9 November 2026)

## Cold read 1: J1, route (b) joined

AI-written, Fable 5.1 (claude-fable-5-1), 9 November 2026. Read only; nothing built, run or edited. Read against the worktree as it stood at the end of the read; the home section, module docstring and record changed under me during the read (the no-cycle premise of (c), the survivor filter's premises, "strictly weaker", "finite" and "the line's members are the standpoints" were all tightened while I was reading), so findings a first pass had on those are dropped and the list below is against the current text. Line numbers are the current file's.

Abbreviations: LB = `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`; 07 = `theories/becoming/chapters/07-SIGNIFICANCE.md`; REC = `theories/becoming/results/records/route-b-joined.json`; NOTE = `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/j1-route-b-joined/NOTE.md`.

### Counts

- High: 0. I found no sentence that would make a reader believe something false about what is proved.
- Medium: 2.
- Low: 10.

### What I checked and found to match the Lean (no finding)

- `Flow.returning_downstream_iff_mutuallyDependent` (LB/FromTheDynamics.lean:100–109). Its only hypothesis is `some : ∃ c, L.ReachReturns W c`. The equivalence is the chain `«各后类续无外即一之续无外»` (LB/OwnClass.lean:261, no premise) → `ownClosure_unrestricted_iff_noOutside` (LB/GrammarScope.lean:276, no premise) → `returning_unrestricted_iff_mutuallyDependent some` (LB/FlowCenters.lean:147). P2 (`«本类至终有常»`) enters only the first conjunct through `«返则后类本类常闭»`. "P2 does no work in the equivalence" and "given one returning formation" are exact.
- `Flow.returning_beyond_coupling` (LB/FromTheDynamics.lean:117–122) is `Flow.reachReturns_ownClosure_rival` (LB/BeyondCoupling.lean:395) at `center := Subtype.val`, as said.
- `Flow.returning_pool_covers` (LB/BeyondCoupling.lean:329): premises a listing of every formation and decided reach, conclusion `WithinClosureOf (CoupledFrom obs) (ReachReturns) g` for every `g` and every `obs`. The prose's "finite flow with reach decided" matches.
- The C bridge. `selfConcerned_above_iff_reach` takes `none : «无环» (ch.withPairs (ch.OwnWidensMet items own)).Shown`; 07, the docstring and REC law 3 now state it. `P x y` reads "x above y" consistently with `IncreasingInOwnOn … (fun b a => P a b)` (LB/Weightings.lean:6033, "`R b a` reads `a` above `b`") and with `Web.extension_ranked_of_increasingInOwnOn`'s conclusion `O (admitted l') (admitted l)` (LB/PremiseWitnesses.lean:508–517). `Web.extension_reached_of_met` concludes `«及» … (admitted l) (admitted l')`, one `.one` step: "one step of that relation" is exact. `increasingInOwnOn_of_keeping` (LB/PersistingChoices.lean:484) derives `IncreasingInOwnOn` from `∀ x y, Met x y → ¬ends x → ends y → P x y` under `stake`: "a corollary of keeping above ending" is exact.
- `Alternating.joined` (LB/FromTheDynamics.lean:393–409): every conjunct the 07 bullet and REC law 6 name is a conjunct of the theorem, except as noted in L5 and L6 below. "Both are listed, so the flow is finite" is `both`/`mem_both` (lines 289–293).
- `Flow.persisting_keeping_above_ending` (LB/PersistingChoices.lean:454): the "survivor filter" sentence now carries both its premises (choices from a strict order; ending realized as an overdraw) and its scope (pairs met).
- Rule-9 moves. `ReturnsAlong` and its three laws (LB/Frame.lean:158–178) are the former FlowCenters text verbatim at `Type u`; `Flow.ReachReturns` (LB/Centers.lean:70) is now `ReturnsAlong (L.Affects W) f`, definitionally the old `∀ g, WithinReach f g → WithinReach g f` since `WithinReach f g := WithinClosure (Affects) f g` (LB/Feedback.lean:199); `reachReturns_iff_returnsAlong` is `Iff.rfl`. `«各续无外则同一中心»` (LB/GrammarScope.lean:221) takes `E : Pos → «际» α` with no `«类»`, P2 or P4 premise; its docstring says so. `coupled_generation_childless` (LB/GroupEnding.lean:239) concludes `¬ y ∈ G.family (T + n + k + 1)`; the docstring matches. `«及之首步»` (LB/Grammar.lean:101) is the removed OwnClass/PersistingChoices lemma verbatim. The four records' history notes name the moves correctly and the statements they say are unchanged are unchanged (checked in the diff).
- `ReadsOnlyDynamics.not_entails` (LB/Significance.lean:297–300): given a standpoint and a formation, a dynamics-only law entailing `Unrestricted` for every significance holds of no dynamics with any significance. 07's gloss "no statement reading only the dynamics entails the condition" is the record `what-the-dynamics-leave-open`'s existing wording and is a fair reading of the theorem. The step from it to "so route (b) can only read significance off the flow … its content is in those readings" is an argument, and 07 presents it as one (see L10).

### Medium

#### M1. Bullet (e) and REC law 5: "none ends" is the empty predicate, so the World constrains nothing about the chooser

- Where: 07:665 ("On a World meeting every law §4.9 uses, with two occasions whose four courses are each open somewhere and none ends, every premise of `Flow.persisting_consistent_with_selfConcern` holds."); REC law 5 ("On a World meeting every law the persistence laws use, with every course met and none ending, their premises hold"); NOTE:15 ("G3 had landed the chooser … without a World; this adds the World."); LB/FromTheDynamics.lean:53–56 ("with the choices of `PersistingChoices.Crossed` (every course met, no choice ends)").
- What the Lean says: `crossed_joined` (LB/FromTheDynamics.lean:459–472) applies `Flow.persisting_consistent_with_selfConcern` with `(ends := fun _ => False)`, `realized := fun _ no => no.elim` and `crossed_stake`, whose conclusion is `¬ False ∧ False` reached by refuting the hypothesis. So the realization premise and the stake hold vacuously, and "none ends" means the ending predicate is empty, not `¬ EndsOwn items own (pick o)` (which `Crossed.not_selfConcerned.2.1`, LB/PersistingChoices.lean:805, proves separately and `crossed_joined` does not use). The chooser's type `Item → Bool` shares nothing with the flow's formations `Bool`; the World laws `balances … persists` are passed but no fact about `Crossed.choices` depends on them. Any World meeting the persistence laws would do; the Alternating World adds a satisfiable instance of those laws and nothing about the choices.
- Why it misleads: a reader of 07 takes "on a World meeting every law §4.9 uses … none ends" to mean the counterexample is realized in a dynamics where ending is the web's ending and the persistence laws bear on the choices. The docstring of `crossed_joined` itself (lines 453–458) says "the realization premise and the stake vacuously"; 07 and the record do not.
- Fix: in 07:665 and REC law 5, say "with ending read as the empty predicate, so the realization premise and the stake hold vacuously; the World adds a model of the persistence laws, not a tie to the choices", or drop "on a World meeting every law §4.9 uses" and state the result as: the chooser `Crossed` meets every premise of `Flow.persisting_consistent_with_selfConcern` on any World meeting the persistence laws, Alternating being one. NOTE:15 "this adds the World" could say what the World adds.

#### M2. The record's statement omits the scope's one premise and the relation

- Where: REC `statement.en` (297 chars): "At the formations whose acts return, each under its least class, the condition read de se holds exactly where the flow is mutually dependent; …".
- What the Lean says: `Flow.returning_downstream_iff_mutuallyDependent` needs `some : ∃ c, L.ReachReturns W c`, and reads along affecting (`L.Affects W`). With no returning formation the left side holds vacuously (no standpoint) while mutual dependence can fail, so the "exactly" is false without the premise. The laws field and 07 carry it; the statement, which the atlas, crosswalk and mirror restate, does not.
- Fix: "At the formations whose acts return, along affecting, given one, each under its least class, …" (fits under 300 if "read de se" becomes "de se" or "nothing beyond their coupling closures counts from them" is shortened).

### Low

#### L1. "a pool that leaves some formation out" should be "some returning formation out"

- Where: 07:660 ("has content only for a pool that leaves some formation out"); LB/FromTheDynamics.lean:38 ("bites only for a pool that leaves some formation out"); REC law 2 (same words).
- What the Lean says: `returning_pool_covers` puts every formation within the coupling closure of some returning formation. A pool containing every returning formation makes the bound's closure the whole whatever non-returning formations it omits, so the bound has content only where some returning formation is left out. The sentence as written is true but weaker; 07 §3.5 (07:231) already has the exact form, "leaves some returning formation out".
- Fix: insert "returning" in the three places.

#### L2. Bullet (b) does not say the coupling closure is relative to a supplied coupling

- Where: 07:660, LB/FromTheDynamics.lean:34–36 and :113–116, REC law 2.
- What the Lean says: `returning_beyond_coupling` takes `obs : F → C → Prop` and `WithinCoupling W obs` (LB/Testing.lean:420); the law holds for every coupling by level. 07 §3.5 says "for every coupling by level"; §4.12 and the docstring do not.
- Fix: "beyond a returning standpoint's coupling closure, for any coupling by level".

#### L3. Dangling anchor `#r-c-from-extension`

- Where: 07:661, "every such order gives [C](#r-c-from-extension) between them".
- Fact: no `id="r-c-from-extension"` exists in `theories/` or `_process/`. The C theorem between listed level paths is at `#r-self-concern-and-c-under-the-condition` (07:258).
- Fix: point the link there.

#### L4. Section number and the NOTE's references

- Where: 07:652 is "### 4.12 Route (b) joined" and follows "### 4.10" (07:622); there is no 4.11. NOTE:3, :24, :48 cite "07 §4.11".
- Fix: renumber the heading 4.11, or cite 4.12 in the NOTE, whichever the render expects.

#### L5. "each coming to stand again and again" is not a conjunct of `joined`

- Where: 07:666 ("A line of descent persists through the two, each coming to stand again and again, and every member of every cohort is the formation standing then, a returning formation"); LB/FromTheDynamics.lean:59–60; NOTE:16 ("the pigeonhole the base check argued").
- What the Lean says: `persists` (LB/FromTheDynamics.lean:284) gives for every `N` some member of cohort `N`, namely `stands N`; `family_eq` gives the cohort is `[stands t]`; `returns` gives every formation returns. No theorem states that each of the two formations recurs (`∀ b N, ∃ t ≥ N, stands t = b`). The conclusion "the line's members are standpoints" follows from `family_eq` and `returns`, and is argued, not a conjunct.
- Fix: either add the recurrence as a lemma and cite it, or write "and every member of every cohort is the formation standing then (`family_eq`), a returning formation (`returns`)" without "again and again", which the theorem does not state.

#### L6. "putting keeping above ending" is derivable from `joined`, not stated by it

- Where: 07:666 ("consistent with a strict order putting keeping above ending and increasing in its own continuation on the occasion met (`FromTheDynamics.Alternating.joined`)"); REC law 6; LB/FromTheDynamics.lean:60–62 and :390–392.
- What the Lean says: `joined`'s last conjunct is `∃ P, irrefl ∧ trans ∧ choices.Accords P ∧ IncreasingInOwnOn …`. `Accords P` (LB/ShownOrder.lean:98) with `pick = keep` and `drain` on the menu gives `P keep drain`, so keeping above ending follows in one step, but is not a conjunct.
- Fix: "according with the choice (so keeping above ending) and increasing …", or add the conjunct.

#### L7. "the course a persisting line takes … its actual levels" names the web's levels as the line's

- Where: REC law 5 ("never ranks the course a persisting line takes: no finite listing holds its actual levels"); REC law 6 ("its levels are never listed"); 07:664 is careful ("what the web's actual levels admit").
- What the Lean says: `Flow.persists_not_listsAdmitted` (LB/PersistingChoices.lean:834) concludes `¬ W.ListsAdmitted items W.level`: the web's level path, not a course of the line.
- Fix: "the web's actual levels" in the record.

#### L8. "Facts of connection" summary drops the premise the Theorem bullet carries

- Where: 07:672 ("At the standpoints a flow gives, every center's closure is the whole exactly where the flow is mutually dependent.").
- What the Lean says: `returning_unrestricted_iff_mutuallyDependent some` and `ownClosure_unrestricted_atReturning_iff some` both need one returning element; with none the left side is vacuous. The bullet at 07:659 has "given one returning formation"; the summary does not.
- Fix: "given one".

#### L9. "The coupling bound … under a named premise on how the act reads" cites a premise §4.12 does not use

- Where: 07:673.
- Fact: the named premise is `ActReadsWithin`, hypothesis of `significance_courses_unselected` (LB/BeyondCoupling.lean, §3.5). §4.12's bound bullet cites `returning_beyond_coupling` (own-closure rival, no act premise) and `returning_pool_covers` (listing, decided reach). The summary line describes §3.5's selection law, not what §4.12 states.
- Fix: either cite `significance_courses_unselected` in the bullet or make the summary "the coupling bound, near-definitional: a listing and decided reach for the covering".

#### L10. "Near-definitional by necessity" and "cannot fail on any model once its readings are taken" are arguments presented as consequences

- Where: 07:654 ("It is near-definitional by necessity: … So route (b) can only read significance off the flow …"); LB/FromTheDynamics.lean:17–22 ("Every law here is a short composition and cannot fail on any model once its readings are taken"); NOTE:9; REC `validation_scope`.
- What the Lean says: `not_entails` is as glossed. That the join therefore "can only" proceed by readings, and that its content "is in those readings", is a reading of the theorem's bearing; it is a fair one. "Cannot fail on any model" is true of every theorem and says nothing specific.
- Fix: "So, on our reading, route (b) can only …"; drop "cannot fail on any model once its readings are taken" or replace with "each is an equivalence or composition of imported laws".

### Checked and not a finding, noted for the record

- The docstring's "Mutual dependence counts taking as well as giving, so it includes mutual drain": `Exchanges` (LB/Feedback.lean:167) is `0 < take ∨ 0 < give`; exact. `Drawing` (LB/MutualDependence.lean:169–) is a pair each taking from the other's condition with nothing given; "the scope's condition holds in Drawing" is one application of `returning_downstream_iff_mutuallyDependent` to `Drawing.mutuallyDependent`, not stated in Lean in the `«所及»` form, but derivable in a line.
- "Keeping above ending asks more … which self-concern on the pairs met does not ask" (07:661, docstring (c), REC law 4): true by the shapes of the two definitions (`IncreasingInOwnOn` constrains only widening-and-adding pairs); no Lean witness of an order that is `IncreasingInOwnOn` and not keeping-above-ending, and none is claimed.
- NOTE:36 "`Becoming.FromTheDynamics` 31 theorems": the file now has 32 `theorem` lines; the count is of the scratch build at that time, not a claim about the Lean's content.
- The `Which "center"` table and the Reading paragraph: readings are labelled as readings; nothing in them is stated as a theorem.
- `ownClosure_unrestricted_iff_of_returning`, `ownClosure_unrestricted_iff_of_onto` (LB/Weightings.lean:1557, 1569): docstrings match statements.

## What was done with round 1

- **M1** taken: 07 §4.12, the record's fifth law, the module docstring and the note now say that ending is read as the empty predicate, so the realization premise and the stake hold vacuously, and that the World is a model of the persistence laws on which nothing about the choices depends.
- **M2** taken: the record's statement now reads "at the formations whose acts return along affecting, given one".
- **L1, L2** taken: "some returning formation out" and "for any coupling by level" in 07, the docstring and the record.
- **L3** taken: the link points to `#r-self-concern-and-c-under-the-condition`.
- **L4**: J3 holds 07 §4.11 and J2 §4.12, both landed first; J1's section is §4.13 after them, and the note cites §4.13.
- **L5** taken in Lean: `Alternating.recurs` proves that each formation stands at some step past every step, and it is a conjunct of `Alternating.joined`; 07 says "each formation standing again and again".
- **L6** taken in Lean: `P keep drain` is a conjunct of `Alternating.joined`; 07 says "according with the choice, so putting keeping above ending".
- **L7** taken: "the web's actual levels" in the record.
- **L8** taken: "given one" in the summary.
- **L9** taken: the summary's bound line now describes §4.12's bound (near-definitional; with a listing and decided reach, nothing beyond the returning formations pooled).
- **L10** taken: "on this reading" in 07 and the docstring; "cannot fail on any model" replaced by "an equivalence or a short composition of imported laws".

## Round 2 (9 November 2026), the same reader on the diff

## Cold read 2: J1, route (b) joined, the fixes to round 1

AI-written, Fable 5.1 (claude-fable-5-1), 9 November 2026. Read only; nothing built or run. Scope: `git diff f671d08bf` in the worktree (f671d08bf is HEAD, so this is the uncommitted working tree) over LB/FromTheDynamics.lean, 07 §4.12, the record, the NOTE and the kit's records.py, plus READER.md's disposition list. Same abbreviations as round 1.

### Counts

- High: 0.
- Medium: 0.
- Low: 4 (three residuals of round-1 fixes not carried into every file, one wording).

### Round-1 findings, one by one

- **M1 (ends := False, the World adds nothing)**: fixed as stated in 07:665, REC law 5 (en and zh), the module docstring (e) and NOTE:15. The new wording ("ending read as the empty predicate, so that the realization premise and the stake hold vacuously … The World is a model of those laws; nothing about the choices depends on it") says exactly what `crossed_joined` (LB/FromTheDynamics.lean) instantiates. No new overclaim.
- **M2 (record statement's premises)**: fixed. `statement.en` now "At the formations whose acts return along affecting, given one, each under its least class, the de se condition is exactly mutual dependence; …" (297 chars). "is exactly mutual dependence" is the `↔ L.MutuallyDependent W` of `returning_downstream_iff_mutuallyDependent`. zh "（有其一时）" carries the premise.
- **L1 ("some returning formation out")**: fixed in 07:660, docstring (b), REC law 2 en and zh, records.py. Not carried into NOTE:12, which still reads "has content only for a pool that leaves some formation out" (see R1 below).
- **L2 ("for any coupling by level")**: fixed in 07:660, docstring (b), REC law 2. The theorem's own docstring (`returning_beyond_coupling`, LB/FromTheDynamics.lean:119–122) still omits it; the statement carries `obs`, so this is wording only (R4).
- **L3 (dangling anchor)**: fixed; the link is `#r-self-concern-and-c-under-the-condition`, which exists at 07:258.
- **L4 (4.10 → 4.12 numbering)**: not changed; READER.md says J3 holds §4.11 and lands first. That is a landing-order dependency, not a text error: if J1 lands before J3 the gap shows. NOTE:3 and :24 now cite §4.12, consistent with the heading.
- **L5 (recurrence argued, not proved)**: fixed in Lean. `Alternating.recurs (b : Bool) (N : Nat) : ∃ t, N ≤ t ∧ stands t = b` (LB/FromTheDynamics.lean:296–302) is now a conjunct of `joined` (`∀ b N, ∃ t, N ≤ t ∧ stands t = b`). The proof matches on `stands N` and `b`, returning `N` or `N + 1`; the `N + 1` cases rest on `stands (N + 1)` unfolding to `!stands N` definitionally, which the structural definition gives. I did not type-check it; NOTE §4 reports a whole-package scratch build. 07:666 "each formation standing again and again" and the docstring's "(`Alternating.recurs`)" now state what is proved.
- **L6 ("putting keeping above ending" not a conjunct)**: fixed in Lean. `P keep drain` is a conjunct, derived as `accords () drain (.inr rfl) drain_ne_keep`: `Accords P := ∀ o y, menu o y → y ≠ pick o → P (pick o) y` with `menu () drain` by `.inr rfl` and `drain ≠ keep`; correct. 07:666 now "according with the choice, so putting keeping above ending"; the docstring "so putting keeping above draining". Exact.
- **L7 (the web's levels, not the line's)**: fixed in REC law 5 en and zh and law 6 en ("the web's levels are never listed"). Law 6 zh still "其水平从不被列" (R2).
- **L8 ("given one" in the summary)**: fixed, 07:672.
- **L9 (bound summary cited `ActReadsWithin`)**: fixed, 07:673 now describes §4.12's bound ("with a listing and decided reach, nothing lies beyond the returning formations pooled"), which is `returning_pool_covers`.
- **L10 ("by necessity" as a consequence; "cannot fail on any model")**: fixed in 07:654 ("So, on this reading, …") and the module docstring ("Every law here is an equivalence or a short composition of imported laws, so its content is in those readings"). Not carried into NOTE:9, which still has "So the join cannot fail on any model once its readings are taken" (R1).

### New text checked for overclaim (none found)

- `joined`'s two earlier new conjuncts from f671d08bf, `(∀ g : Bool, g ∈ both)` and `(∀ t y, y ∈ generations.family t → y = stands t ∧ flow.ReachReturns web y)` (`mem_both`, `member_stands`, `returns`), match 07:666 "Both are listed, so the flow is finite" and "every member of every cohort is the formation standing then, a returning formation: the line's members are standpoints".
- 07:665 "Take two occasions whose four courses are each open somewhere" is `Crossed.not_selfConcerned.1`; "no strict order … on every pair" is `.2.2`.
- REC law 5 "C between listed level paths never ranks the course taken where a line persists: no finite listing holds the web's actual levels" is `Flow.persists_not_listsAdmitted` exactly.
- NOTE witness paragraph now cites `Alternating.recurs` for the recurrence and says "the web's actual levels".

### Low

#### R1. Two round-1 fixes not carried into the NOTE

- Where: NOTE:12 "the bound on selection has content only for a pool that leaves some formation out"; NOTE:9 "So the join cannot fail on any model once its readings are taken".
- Fix: "some returning formation out" (as 07, the docstring and the record now say); replace the second with the docstring's "every law is an equivalence or a short composition of imported laws, so its content is in the readings". NOTE §4's "all taken" is then true of the NOTE too.

#### R2. Record law 6's Chinese still says the line's levels

- Where: REC laws[5].zh "其水平从不被列" where the en now reads "the web's levels are never listed".
- Fix: "网之水平从不被列".

#### R3. "its chooser keeps" in record law 6

- Where: REC laws[5].en "a line of descent persists through the two and never overdraws; the web's levels are never listed; its chooser keeps, …".
- Why: "its" reads as the flow's or the line's chooser, while `does_not_show` and 07 say the chooser is supplied and tied to the flow only by `realized`.
- Fix: "a supplied chooser keeps".

#### R4. `returning_beyond_coupling`'s own docstring lacks "for any coupling by level"

- Where: LB/FromTheDynamics.lean:119–122.
- Fact: the statement quantifies `obs : F → C → Prop`; the module docstring (b), 07 and the record now say so; the theorem's docstring does not.
- Fix: "For any coupling by level, what lies beyond …".

### Noted, not a finding

- NOTE §4 now records this cold read ("no high finding, two medium and ten low, all taken") and a whole-package scratch build (396 modules). I cannot verify the build; the counts are round 1's.
- L4's disposition (J3 takes §4.11) is a landing-order fact outside this diff; worth a check at landing that §4.11 exists in 07 when J1's section is rendered as 4.12.

## What was done with round 2

All four low residuals taken: R1 (the note's two sentences), R2 (the record's Chinese, the web's levels), R3 ("a supplied chooser"), R4 ("for any coupling by level" in `returning_beyond_coupling`'s docstring). Round 2 had no high or medium finding, so the rounds stop here.
