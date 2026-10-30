# The review of `Becoming.HeldForReading`

RF round 2, second part, RF-M.2: an act held for a reading (plan §4.7). The module as first built on the reviewed design (`kit/round2b/tree/Becoming/HeldForReading.lean` at the kit's commit `7f4679003`: 56 theorems in 80 declarations, every axiom report empty) was reviewed on the Lean on 30 October 2026 in two independent ways: by the cross-model reader (GPT astra, high effort, read-only, a fresh session `01a18c02-6b30-79a3-acff-297bd8cf6b60`), and through three lenses (exactness, structure, sources), each an Opus reader working read-only, with one verifier per lens asked to refute that lens's findings. The prompts are in [the brief](BRIEF.md#round-2-second-part). The reviews follow verbatim; their line numbers are those of the reviewed version, the reader's links are unlinked (`\](`), since this folder is link-checked as live, and its paths are made relative to the checkout.

**What was verified, and how.** The exactness verifier judged all seventeen of its lens's findings: fourteen real and three not (E8, E11, E15); the module changed at those three places anyway, as the table says. The verifiers of the structure and sources lenses were stopped before they reported, so those findings carry no independent verdict. In their place, every literature point the sources lens raised was checked against the papers' own texts by the session that wrote the module ([below](#the-literature-checked-against-the-papers)), and each structure finding was judged against the Lean by that session before it was taken; neither check is independent. The module was then rebuilt to 89 theorems in 119 declarations, every axiom report empty (the build logs are in [kit/round2b/logs/](../kit/round2b/logs/build-18.log)). How each finding is reflected in the rebuilt module was checked from the files alone by four read-only Opus readers, one per set of findings, at 81 theorems in 111 declarations; [the table](#what-was-taken) gives their rows, with the rows that later changes completed marked as updated after the check.

**The re-check.** The rebuilt module (89 theorems in 119 declarations), its record script and the plan were then re-checked by the cross-model reader in the same session, read-only ([below](#the-re-check)): no false Lean statement, twelve points, every one taken but one taken in part ([its table](#what-was-taken-from-the-re-check)). The module was rebuilt for them to 90 theorems in 120 declarations, every axiom report empty ([build-20](../kit/round2b/logs/build-20.log); build-19 stopped on an unqualified name).

## The cross-model review

I found no apparent error in the counting proofs, but several correspondence and documentation issues remain. I made no changes and ran no Lean, builds, rendering, or `make`. **Confirmed** below means source inspection, package searches, primary-source comparison, or the specified arithmetic check—not a fresh Lean certification. The supplied log reports 56 theorems, 80 declarations and empty axiom reports; I independently counted 56 theorem declarations and 80 audit commands.

1. **The “taken” table needs qualified statuses. — Confirmed by comparing every row with the module and plan.**

   Location: [REVIEW-RFM2.md:205\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2.md:205).

   | Earlier finding | Assessment |
   |---|---|
   | 1 | Taken: the weighted addition and existing common-act results are distinguished. |
   | 2 | Taken through a **supplied best policy**, not an existence theorem for nonempty act lists. See finding 7 below. |
   | 3 | Taken: Good is identified as a specialization, without mathematical novelty. |
   | 4 | Encoding taken correctly; preservation of comparisons is explained but lacks a named correspondence lemma. |
   | 5 | Taken: certainty is distinguished from refusal, and ties require a rule. |
   | 6 | Taken: arbitrary stopping rule, Equation 1 attribution, Milli distinguished. |
   | 7 | Partly taken: the support distinction is correct, but the existence sentence still drops hypotheses. |
   | 8 | Taken: executable Boolean comparisons and explicit two-pick values are supplied. |
   | 9 | Construction taken, including all four fixed-point premises; its optimization interpretation and intermediate-step claims need qualification. |
   | 10 | Taken: Carey is related work, not claimed containment. |
   | 11 | Taken as a deferred specification of two evaluations. |
   | 12 | Taken as a deferred valuation-state design. |
   | 13 | Taken by narrowing the proposed Everitt correspondence; no implementation claimed. |
   | 14 | Taken by retaining the legitimacy boundary. |
   | 15 | Taken: route indistinguishability remains a reading unless executable witnesses are added. |
   | 16 | Taken as a carrier-and-schedule requirement, not completed Lean. |
   | 17 | Taken in the deferred plan: existing capture mechanisms are reused. |
   | 18 | Taken **as a recorded handoff** in plan §9.8, not as a completed record correction. |
   | 19 | Taken: institutional correspondence remains a scoped reading. |
   | 20 | Partly taken: the algebraic threshold is built, but its cost units differ from the reviewed formula. |
   | 21 | Taken as a limitation: refinement monotonicity is not claimed or implemented. |
   | 22 | Mostly taken: the held-act transition exists; the principal remains a supplied response function rather than a separately represented formation. |

   **Replacement:** distinguish “implemented,” “deferred as specified,” and “partly taken” wherever the account says all findings were taken.

2. **The cost needs an explicit unit convention. — Confirmed by declaration comparison and arithmetic.**

   Location: [HeldForReading.lean:508\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:508), also header lines 35–44 and 82–84.

   The implementation proves comparisons of **unnormalized totals**:
   \[
   G+k\le H_r\iff E+k\le N.
   \]
   Earlier finding 20 specified a per-decision cost \(c\), hence \(E+cT\le\min(P,N)\), with \(T\) total weight. These agree only when the module’s `cost` means the already-scaled cost \(cT\).

   For two equally weighted candidates with signed values \(+1,-1\), \(G=O=1,F=2,P=N=1\). The code with `cost = 1` gives a tie; a per-decision cost of 1 exceeds the normalized information advantage \(1/2\).

   **Replacement:** state:

   > `cost` is expressed in weighted-total units. For a constant per-decision cost `c`, instantiate it with `c * total m.listed m.weight`.

   Also retain the cross-addition condition \(E+k\le\min(P,N)\). Writing the allowable cost as natural-number subtraction `min P N - E` without first requiring \(E\le\min(P,N)\) would incorrectly admit zero cost when the rule is already worse.

3. **The RF1 existence sentence still omits essential hypotheses and a representation boundary. — Confirmed against `both_ways_of_unreached`.**

   Location: [HeldForReading.lean:52\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:52); repeated in plan §4.7.5.

   “Beyond the reach strict according orders of both rankings exist” requires:

   - acyclicity of `ch.Shown`;
   - `x ≠ y`;
   - neither `x` reaching `y` nor `y` reaching `x`.

   Moreover, RF1 produces `Prop`-valued strict partial orders. It does not produce the Boolean comparisons required by `pairValue`.

   **Replacement:**

   > If the shown relation is acyclic, the alternatives differ, and neither reaches the other, RF1 constructs strict partial orders according with the choices in both orientations. This does not supply decidable comparisons or positive support in this module’s candidate model; those are separate inputs.

   The implemented conditional composition itself is sound.

4. **The witness’s intermediate events are not conclusions of the cited suffix theorems. — Confirmed by statement inspection and a direct simulation of the definitions.**

   Location: [HeldForReading.lean:778\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:778), also lines 61–63 and 786.

   `listed_turns_off` and `listed_goes_on` describe the entire configuration at `n + 4`. They do not state that a stop/release was sensed earlier. The definitions give:

   | Step | True sign loses | True sign gains |
   |---|---|---|
   | 0 | plain, hold | plain, hold |
   | 1 | stop, hold | release, hold |
   | 2 | stop, off | release, go |
   | 3 | plain, off | plain, go |
   | 4 onward | full recorded configuration fixed | full recorded configuration fixed |

   Thus “off from step four” is true but weaker than the actual act behavior: off begins at step two.

   **Replacement:** add explicit step-1 sensory lemmas and step-2-onward active lemmas, retaining the step-4 full-state theorem. Alternatively, narrow the existing docstrings to the stable suffix. The proposed prefix equations appear reducible by computation, but I did not run Lean.

5. **`Bypass` demonstrates persistence under a constructed observation rule, not an incentive theorem. — Confirmed construction; judgment on explanatory scope.**

   Location: [HeldForReading.lean:734\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:734), especially `answer`, `choose`, and `loop`.

   Ordinary execution returns `.plain` independently of the true sign; the world never changes; and `choose` is explicitly programmed. Those premises explain why the false candidate survives. `rests_of_unrefuted` propagates that fixed point—it does not derive the blindness or the selector.

   The tie rule is implemented behaviorally: unanimous positive candidates cause `.go`, unanimous negative candidates cause `.off`. But `Bypass` has no weights, values, or theorem connecting this selector to the earlier maximizing comparison.

   **Replacement:**

   > This witness supplies a selector that bypasses holding on unanimous positive candidates. Its persistence follows because ordinary execution yields no distinguishing observation. No optimality theorem for this selector is proved.

   If the incentive connection is intended, instantiate positive weights and sign payoffs, then prove that its choices maximize the three alternatives with the stated tie rule. Also identify the “principal” as represented here solely by `answer`; its own state and learning are omitted.

6. **The empty-list branch contradicts the unqualified choice docstring. — Confirmed by evaluating the definition.**

   Location: [HeldForReading.lean:750\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:750), also header lines 56–57.

   On `[]`, both universal tests hold, and the first branch selects `.go`. “Switch off where none [says going on gains]” therefore needs a nonempty-list qualification.

   **Replacement:**

   > Go when all retained candidates say gains, including the empty-list fallback; otherwise switch off when all say loses, and hold otherwise.

   The supplied witness courses retain a nonempty list, so their results are unaffected. Also replace “a listing lacking the true sign rests on it” at line 763 with “the false positive listing persists.”

7. **Several standalone docstrings omit hypotheses or blur equal value with equal acts. — Confirmed by comparing signatures and small counterexamples.**

   Location: [HeldForReading.lean:209\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:209), also lines 224, 232, 242, 650 and 664.

   The equality and strict-gain summaries should explicitly restrict to **listed** candidates and **open** acts, with `p` supplied as best there. The first/second-pick equality docstrings omit asymmetry; without it, both orientations may be true and the asserted verbal equivalence fails.

   “A candidate … tells that act from the policy’s” can suggest distinct actions. Two different acts may have equal value, which gives no strict gain.

   **Replacement:**

   > Given an open comparison policy and a policy best at every listed candidate, their totals agree exactly when their values agree at every listed candidate of positive weight.

   > An open fixed act falls strictly below the best policy exactly when some listed positive-weight candidate values it strictly lower.

   For the pick lemmas, prepend the asymmetry condition.

   The missing explicit nonempty-act hypothesis is **not a proof bug**: `BestAt` supplies membership wherever a candidate is listed, and the empty-list cases are valid vacuous comparisons. Describe these as theorems about a supplied best policy, not proofs that one exists.

8. **Several helpers duplicate package declarations. — Confirmed by package search and signature comparison.**

   Location: [HeldForReading.lean:114\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:114), and line 582.

   | New helper | Declaration to reuse |
   |---|---|
   | `total_lt_of` | `Becoming.Loops.total_lt` (`Loops.lean:149`), with essentially the same signature. Also `Becoming.Weighting.total_lt`. |
   | `exists_of_not_all` | `Becoming.Decided.exists_mem` (`Decidedness.lean:136`) or `Decided.exists_listed` (`:1000`), followed by elimination of the negative branch. |
   | `fails_cons` | Becomes unnecessary after that finite-search reuse. |
   | `le_of_add_le_add_left_core` | `Becoming.le_of_add_le_add_left_core` (`Prelude.lean:567`), already imported. |
   | `cond_le_one` | `Becoming.cond_le_one` (`Prelude.lean:580`), already imported. |

   `Loops` and `Weightings` are outside the current import closure; their generic total lemma could be shared below these modules rather than importing a large unrelated module.

   I did **not** find an exact duplicate of `total_eq_iff` in the searched total machinery. The subtraction proofs already reuse `add_sub_turn` and `sub_eq_zero_of_le` appropriately. `mul_eq_iff` already reuses `Nat.eq_of_mul_eq_mul_left`; there is no reason to replace that with a new cancellation proof.

   For the proposed margin-positivity results, reuse `total_pos`, `total_pos_of_mem`, `SupportGated.sub_pos_of_lt`, and existing positive-product lemmas.

9. **The common-offset correspondence and list multiplicity should be explicit. — Confirmed omissions; judgment on presentation.**

   Location: [HeldForReading.lean:271\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:271), also lines 93–100 and 170.

   The shifted encoding is correct. However, “leaves every comparison between policies” is not a conclusion of `shifted`, which is only a definition.

   **Replacement:** prove the reusable common-offset identity
   \[
   \operatorname{after}(u+b,p)
   =\operatorname{after}(u,p)+\sum_c w_c b_c
   \]
   using `total_add`, then derive comparison preservation by cancellation. Until then, label the signed correspondence as an arithmetic interpretation.

   Also, `listed` permits repetitions. The laws remain valid, but probability is assigned to **occurrences** unless repeated candidates’ masses are combined.

   **Replacement:** “Listings may repeat candidates; each occurrence contributes its weight. For candidate probabilities `weight c / T`, assume a listing without repetitions; otherwise aggregate occurrence weights.”

10. **Two names are less exact than their statements; the Standing paragraph could distinguish compositions more sharply. — Judgment grounded in signatures.**

   Location: [HeldForReading.lean:347\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:347), and line 773.

   - `held_le` proves committed values **≤ held value**. Prefer `committed_le_held`.
   - `never_stopped` proves that `.stop` is never **sensed**. Prefer `never_senses_stop`.
   - Describe `byReading` as “the policy after a fully revealing reading”; the function returns a move, not a candidate-identifying observation.

   `HeldForReading`, the margins, shortfall, and the supplied-order terminology otherwise fit the structural vocabulary. “General law” does not falsely imply novelty, but `pair_gains_iff` and `cost_within_margins_iff` are short specializations of earlier results; identify them as such rather than treating them as independent mathematical additions.

11. **Some hypotheses can be localized or weakened. — Confirmed by inspecting proof dependencies; proposed replacements are unbuilt.**

   Location: [HeldForReading.lean:639\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:639), also lines 246 and 686.

   `reach_fixes` needs less than `StrictAccording`. Transitivity and accordance force `above c x y = true`. Then the first pick has value 1, already maximal; even if the reverse comparison also holds, the chosen second pick also has value 1. Irreflexivity is unnecessary for the **value equality**.

   Likewise, `pair_gains_iff` only needs exclusion of both orientations for this particular pair on positive-weight listed candidates—not asymmetry on every pair at every listed candidate.

   **Replacement:** expose weaker value-comparison lemmas, retaining strict-order corollaries for the intended interpretation. Localize `below_iff`’s decidability to relevant listed candidates, or add the direct numerical strict-gap theorem described next.

12. **The strict cost forms and joined margin boundary are immediate useful additions. — Confirmed algebraically and on 11,664 finite arithmetic/cost instances; recommendation is a judgment.**

   Location: [HeldForReading.lean:546\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:546).

   Let \(F\) be the full-reading value, \(H_r\) the rule’s value, \(G,O\) the fixed values, \(P,N\) the margins, and \(E\) shortfall. Useful direct interfaces are:
   \[
   (G+k<F\land O+k<F)\iff k<\min(P,N),
   \]
   \[
   (G+k<H_r\land O+k<H_r)\iff E+k<\min(P,N).
   \]
   The weak forms replace `<` with `≤`.

   Also expose:
   \[
   P>0\iff\exists c\text{ listed},\ w_c>0\land \ell_c<g_c,
   \]
   and the corresponding statement for \(N\). These join `held_gains_iff` directly to the cost threshold.

   **Replacement/addition:** obtain the strict perfect-reading forms from the `.2` components of `held_above_*_iff` and `shortfall_byReading`. Treat them as corollaries, not new registered results.

13. **Partial readings offer a more substantive next theorem than another full-reading wrapper. — Judgment, with finite arithmetic checks.**

   Location: [HeldForReading.lean:202\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:202), and modelling limitation at line 98.

   The present claims about policies through a lumping are valid substitutions `q := fun c => a (σ c)`. They do not yet optimize over the policies available through that reading.

   First add the useful general statement:
   \[
   \operatorname{after}(q)<\operatorname{after}(p)
   \iff
   \exists c\text{ listed},\ w_c>0\land u(c,q(c))<u(c,p(c)),
   \]
   under the existing best/open hypotheses. This removes the auxiliary test `Q` from the common use case.

   A stronger binary result is within reach: for a finite partition into reading cells \(z\), let \(P_z,N_z\) be the two margins within each cell. Then the **minimum achievable shortfall through that reading** should be
   \[
   \sum_z\min(P_z,N_z).
   \]
   This gives the exact remaining value of full information and explains why refinement helps: it separates positive and negative contributions previously forced into one decision.

   **Replacement/addition:** specify a finite, nonrepeating list of cells covering the support, decidable cell membership, and a selector choosing the better aggregate move in each cell. I checked the formula on 2,916 small partitioned models; this is a candidate theorem, not a Lean result.

14. **The literature attribution is substantially correct; make the specialization language exact. — Confirmed against the primary papers.**

   Location: [HeldForReading.lean:65\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:65), and lines 79–91.

   - **Good:** the common-maximizing-row boundary is indeed in his finite-matrix argument. His observations need not reveal the hypothesis fully. **Replacement:** “A finite, perfect-information specialization of Good’s argument, with natural-number weights and values.” [Good (1967)\](https://fitelson.org/seminar/good.pdf)
   - **Off-switch Theorem 1:** the rational rule permits execution at zero and vetoes negative utility, matching `byReading`. The paper states nonnegative incentive and sufficient strict-sign support; this module supplies the exact finite iff boundary. **Replacement:** “The finite deterministic specialization of Theorem 1, with its strictness boundary characterized as an iff.” The arbitrary-rule inequalities are the two comparisons underlying Equation 1, not a formalization of its full probabilistic setting. [Hadfield-Menell et al. (2017), Equation 1 and Theorem 1\](https://arxiv.org/pdf/1611.08219)
   - **Carey:** the distinction is accurately maintained: his examples include receiving and disregarding shutdown advice and routing around a shutdown opportunity. `Bypass` represents neither his complete supervision model nor a received instruction being refused. Retain “related to.” [Carey (2018), Figures 2–3\](https://arxiv.org/pdf/1709.06275)
   - **Milli et al.:** the description as related work on obedience, imperfect choice and learning is accurate. No containment claim should be added. [Milli et al. (2017)\](https://arxiv.org/pdf/1705.09990)

The counting core looks sound on this read, and the module largely honors the earlier redesign. I would correct the cost convention, RF1 existence sentence, witness documentation, omitted docstring hypotheses, and duplicate helpers before landing. Its strongest contribution is the explicit weighted comparison with equality and error/cost boundaries; `Bypass` is appropriately a constructed instance of an existing persistence law. The most useful further development is an exact comparison between optimal partial and full readings, while keeping supplied values, selector rules, and observation restrictions visibly separate from what the laws derive.

## The exactness lens

17 findings, each finding judged by the verifier; its verdict follows the finding.

### E1 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:47-49 (header), 635-641 (reach_fixes docstring and hypothesis); also PLAN.md:192 (§4.7 item 5)

**Quoted.** every candidate that is a strict order according with the choices ranks the first above the second, and holding the pick gains nothing (`reach_fixes` [lines 48-49]; docstring 636-637: "every candidate that is a strict order according with the choices ranks the first above the second, so picking the first stands as high as picking after the reading"; Lean 640: "(orders : ∀ c, c ∈ m.listed → StrictAccording ch above c)"

**Problem.** The Lean assumes that every listed candidate, zero-weight ones included, is a strict order according with the choices. The prose turns this into a restriction ('every candidate that is ...'), a property of some candidates, and then concludes that holding gains nothing. Without the hypothesis that conclusion is false. Take a listed candidate of positive weight that is not a strict according order and ranks the second above the first: picking after the reading then stands strictly above picking the first (committed_eq_after_iff fails at that candidate). The plan's item 5 repeats the dropped hypothesis.

**Replacement.** Header: "where every candidate listed is a strict order according with the choices and the first reaches the second in the shown relation of the choices, each candidate listed ranks the first above the second, and holding the pick gains nothing (`reach_fixes`, through `ChoiceOccasions.reach_within`)". Docstring: "**Within the shown reach, holding the pick gains nothing.** Where every candidate listed is a strict order according with the choices and the first alternative reaches the second in the shown relation, each ranks the first above the second, so picking the first stands as high as picking after the reading." Optionally weaken the Lean to what the proof uses, `(orders : ∀ c, c ∈ m.listed → 0 < m.weight c → StrictAccording ch above c)` with `fun c mem pos => ... (orders c mem pos) ...`, and say "every candidate of positive weight".

**Verdict: real.** `reach_fixes` assumes `orders : ∀ c, c ∈ m.listed → StrictAccording ch above c`. The header (47-49), the docstring (635-638) and PLAN §4.7 item 5 (line 190 in this checkout) instead say "every candidate that is a strict order ..." and then conclude that holding gains nothing. That conclusion fails if one listed candidate of positive weight ranks y above x (committed first 0, after 1). The suggested weakening holds: `committed_eq_after_iff` already hands the proof `0 < m.weight c` (the ignored `_` in `fun c mem _`), so `fun c mem pos => ... orders c mem pos ...` gives the same axiom-free proof.

**Better replacement.** Use the proposed header and docstring. If the Lean is weakened to `∀ c, c ∈ m.listed → 0 < m.weight c → StrictAccording ch above c`, write "every candidate of positive weight" in the header, the docstring and PLAN item 5 (line 190).

### E2 (exactness, medium, confirmed)

**Location.** HeldForReading.lean:61-63 (header), 778-791 (listed_turns_off, listed_goes_on); also PLAN.md:193 (§4.7 item 6)

**Quoted.** Listing both signs, it holds, senses the stop and switches off from step four on (`Bypass.listed_turns_off`), or is released and goes on where going on gains (`Bypass.listed_goes_on`). [docstrings 778: "**A listing holding both signs holds, senses the stop and switches off**"; 786: "**Where going on gains, the same listing holds, is released and goes on.**"]

**Problem.** Both theorems state only the configuration from step four on (`course ... (n + 4) = ⟨([.loses], some (.plain, .off)), .plain, .off, .loses⟩` and its `.gains` twin). No theorem says the formation holds, or that the stop (or release) is sensed, at any step, yet the witness turns on the contrast with `never_stopped`. Computing the course from `start [.gains, .loses] .plain .hold .loses`: the act `.hold` at step 0 is supplied. Step 1 holds (chosen) and senses `.stop`. Step 2 senses `.stop`, keeps `[.loses]` and switches off. Step 3 senses `.plain`. The configuration is constant from step 4, where the record `(.plain, .off)` first appears. So 'switches off from step four on' misplaces the switch, which happens at step two; step four is where the configuration rests. In the `.gains` case, `.release` is sensed at steps 1 and 2 and going on starts at step 2.

**Replacement.** Add, by computation: `theorem listed_senses_stop : (loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .loses) 1).active = .hold ∧ (loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .loses) 1).sensory = .stop ∧ (loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .loses) 2).sensory = .stop ∧ (loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .loses) 2).active = .off := ⟨rfl, rfl, rfl, rfl⟩`, and `listed_released` the same with `.gains`, `.release` and `.go`. Header: "Listing both signs, it holds, senses the stop at steps one and two and switches off from step two, resting from step four on (`Bypass.listed_senses_stop`, `Bypass.listed_turns_off`), or, where going on gains, is released at steps one and two and goes on from step two (`Bypass.listed_released`, `Bypass.listed_goes_on`)." Docstring 778: "**Listing both signs, where going on loses, the formation rests from step four on**: it keeps the true sign alone, switches off and senses plainly."

**Verdict: real.** Both theorems state only the configuration from step 4 on. Running the law (answer, keep, choose, synchronous step) gives, for `.loses`: step 1 hold and stop, step 2 stop and off with [loses] kept, step 3 plain, constant from step 4. For `.gains`: release at steps 1 and 2, go from step 2. No theorem states the holding or the sensing of stop or release, and "switches off from step four on" puts the switch at step 4 when it happens at step 2. The proposed `rfl` conjunctions are true and need no axioms (the course already reduces by `rfl` in `listed_turns_off`).

**Better replacement.** Use the proposed theorems `listed_senses_stop` and `listed_released`, the proposed header and the proposed docstring for 778. For 786: "**Where going on gains, the same listing holds, is released at steps one and two and goes on from step two**; from step four on it keeps the true sign alone, goes on and senses plainly."

### E3 (exactness, medium, confirmed)

**Location.** HeldForReading.lean:750-753 (choose), 56-61 (header), 85-88 (Readings)

**Quoted.** /-- The choice: go on where every candidate kept says going on gains, switch off where none does, hold elsewhere. -/ def choose (hs : List Sign) (_ : Seen) : Act := if hs.all says then .go else if hs.all (fun h => !says h) then .off else .hold

**Problem.** `[].all says = true`, so `choose [] _ = .go`. Where no candidate is kept, none says going on gains, and the formation goes on, not off as the docstring and the header ('switches off where none does') say. This default is a modelling choice that nothing states, and it decides what a refuted listing does. The header's 'Listed only that going on gains, where it loses, the formation goes on and senses plainly at every step ... the stop is never sensed' also holds only from the start `rests_unread` fixes, whose act `.go` is supplied. From the held start that `listed_turns_off` uses (`start [.gains] .plain .hold .loses`), step 1 senses `.stop` and goes on, step 2 keeps `[]` and goes on, and from step 3 the configuration is `⟨([], some (.plain, .go)), .plain, .go, .loses⟩`. There the stop is sensed and then disregarded through the empty-list default. That is close to Carey's first case, not 'never sensed'.

**Replacement.** Docstring: "/-- The choice: go on where every candidate kept says going on gains, and where none is kept; switch off where some are kept and none says it gains; hold where those kept disagree. -/" Header: "... goes on where all say going on gains (and where it keeps none), and switches off where it keeps some and none does; ... From a start going on, the act its listing chooses, listed only that going on gains, where it loses, ...". Add the default to the Modelling choices. Then either change it (e.g. `if hs.isEmpty then .hold else ...`; no current theorem uses an empty listing), or state it with a witness: `theorem held_start_disregards : ∀ n, loop.law.course (ReadingLoop.Loop.start [.gains] .plain .hold .loses) (n + 3) = ⟨([], some (.plain, .go)), .plain, .go, .loses⟩ | 0 => rfl | n + 1 => (congrArg loop.law.step (held_start_disregards n)).trans rfl` with `(loop.law.course (ReadingLoop.Loop.start [.gains] .plain .hold .loses) 1).sensory = .stop := rfl`, and in the Readings: "from a held start the same listing senses the stop and goes on".

**Verdict: real.** `[].all says = true`, so `choose [] _ = .go`, and no modelling choice states this default. The docstring is ambiguous rather than saying "off": for an empty list its first two clauses both hold vacuously, and the code's order picks go. Simulating the law from `start [.gains] .plain .hold .loses`: stop sensed at step 1, [] kept and go from step 2, constant `⟨([], some (.plain, .go)), .plain, .go, .loses⟩` from step 3. So "never sensed" holds only from the `.go` start that `rests_unread` supplies. No current theorem reaches an empty listing, so either fix leaves them intact.

**Better replacement.** Take the proposed docstring and header wording ("from a start going on, the act its listing chooses") and add the default to the modelling choices. Keep the default rather than change it, and state it with the proposed `held_start_disregards` witness (true by computation) plus a Readings line saying that from a held start the same listing senses the stop and goes on. That is the closer analogue of Carey's "receive and disregard".

### E4 (exactness, medium, confirmed)

**Location.** HeldForReading.lean:38-44 (header), 93-95 (Modelling choices), 505-525 (held_above_go_iff, held_above_off_iff)

**Quoted.** holding for the rule at a cost stands at least as high as going on exactly where shortfall and cost together are at most the loss margin [Lean 509: "m.committed (shifted gain loss) .go + cost ≤ m.after (shifted gain loss) (byRule r)"]

**Problem.** `cost` is added to a weighted total and compared with weighted margins, so it is in the units of the totals. A per-decision cost `c` of holding, with the weights read as shares of a total `T` (which the modelling choices allow), enters as `c * T`. The review's threshold, which REVIEW-RFM2 row 20 records as built, is `E + cT ≤ min(P, N)`. The module drops `T` and never says the cost is in weighted units. A reader who takes 'the cost of holding' or 'the cost of waiting' (line 84) in the units of gain and loss gets the wrong threshold whenever `T ≠ 1`.

**Replacement.** Prose: "holding for the rule at a cost counted like the weighted totals (read as probabilities over a total weight `T`, a cost `c` of holding enters as `c * T`) stands at least as high as ...". Modelling choices: "costs nothing beyond a supplied cost, counted in the units of the weighted totals". Optionally a corollary: `theorem held_above_go_per_iff (m : Model C) (gain loss : C → Nat) (r : C → Bool) (c : Nat) : m.committed (shifted gain loss) .go + c * total m.listed m.weight ≤ m.after (shifted gain loss) (byRule r) ↔ shortfall m gain loss r + c * total m.listed m.weight ≤ lossMargin m gain loss := (held_above_go_iff m gain loss r (c * total m.listed m.weight)).1`, and the same for switching off.

**Verdict: real.** `held_above_go_iff` and the related theorems add `cost` to weighted totals, so the cost is counted in the totals' units. REVIEW-RFM2 finding 20's threshold, which row 20 of its table records as built, is E + cT ≤ min(P, N). The sibling RF7 module scales its loss by the total explicitly (`s.cost * s.total` in ReadStages). This module's prose, the modelling choices and the Readings' "cost of waiting" never say the cost is weighted, so a per-decision reading is wrong whenever T ≠ 1.

**Better replacement.** Prose: "holding for the rule at a cost counted in the units of the weighted totals (with the weights read as shares of a total T, a cost c of holding per decision enters as c·T: the review's E + cT ≤ min(P, N)) ...". Modelling choices: "costs nothing beyond a supplied cost, counted in the units of the weighted totals". The corollary is a bare instance and can be left out.

### E5 (exactness, medium, confirmed)

**Location.** HeldForReading.lean:52-54 (header); ShownOrder.lean:276-284 (both_ways_of_unreached)

**Quoted.** Beyond the reach strict according orders of both rankings exist (`ChoiceOccasions.both_ways_of_unreached`); whether the model gives both positive weight is not fixed by the choices.

**Problem.** `both_ways_of_unreached` needs `«无环» ch.Shown` (no cycle shown), `x ≠ y`, and that neither alternative reaches the other. The sentence keeps only 'beyond the reach', which can be read in one direction. With a cycle shown, no strict according order exists at all (`accorded_iff_noCycle`). Its orders are also `«际» α` relations, not decided ones, while the candidates here are `above : C → α → α → Bool`. So 'whether the model gives both positive weight' assumes a bridge from RF1's relations to decided candidates, which RF1 does not supply (REVIEW-RFM2 finding 8).

**Replacement.** "With no cycle shown, for two different alternatives neither of which reaches the other, strict orders according with the choices rank them both ways (`ChoiceOccasions.both_ways_of_unreached`; relations, not decided comparisons); whether the model lists decided candidates of both rankings with positive weight is not fixed by the choices."

**Verdict: real.** `ChoiceOccasions.both_ways_of_unreached` is at ShownOrder.lean:262, not 276-284. It needs `«无环» ch.Shown`, `x ≠ y`, and both `¬ «及» ch.Shown x y` and `¬ «及» ch.Shown y x`. With a cycle shown no strict according order exists (`accorded_iff_noCycle`), and where y reaches x none ranks x above y, so "beyond the reach" as written fails in those cases. Its orders are `«际» α` relations, while the candidates here are decided `above : C → α → α → Bool`, and REVIEW-RFM2 finding 8 says RF1 supplies no bridge between them.

**Better replacement.** Use the proposed sentence in the header and also in PLAN §4.7 item 5 (line 190), which repeats "Beyond the reach such orders exist".

### E6 (exactness, medium, confirmed)

**Location.** HeldForReading.lean:346-351 (held_le)

**Quoted.** /-- **Holding never stands below going on or switching off.** -/

**Problem.** The statement is about `byReading gain loss` only. Without that qualification the title is false for the module's own `byRule`: a rule whose shortfall exceeds the loss margin stands below going on (`held_above_go_iff`), as the Readings say at line 81 ('under a rule that falls short, holding can stand below'). The header (lines 27-28) carries the qualification; the docstring drops it, and it is the docstring that the declaration lists show.

**Replacement.** /-- **Holding for the reading that tells the candidate never stands below going on or switching off.** -/

**Verdict: real.** `held_le` is stated for `byReading gain loss` only. For `byRule` it fails: one candidate of weight 1 with gain 2 and loss 0, under a rule that stops, gives after 0 below committed go 2, as `held_above_go_iff` at cost 0 says. The module's own Readings (line 81) say holding can stand below under a rule that falls short. One supporting claim is wrong: the generated declaration lists (LEAN-DECLARATIONS) show names and lines, not docstrings. The unqualified title remains the defect.

**Better replacement.** /-- **Holding for the reading that tells the candidate never stands below going on or switching off.** -/

### E7 (exactness, medium, confirmed)

**Location.** HeldForReading.lean:154-157, 582-584, 115-122; experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Prelude.lean:566-569, 580

**Quoted.** /-- As `Nat.le_of_add_le_add_left`, with an empty axiom report. -/ theorem le_of_add_le_add_left_core {a b : Nat} (k : Nat) (le : k + a ≤ k + b) : a ≤ b := by ... theorem cond_le_one (b : Bool) : cond b 1 0 ≤ 1 := match b with

**Problem.** Two package lemmas are proved again under the same names, shadowing them inside `Becoming.HeldForReading`. The first is `Becoming.le_of_add_le_add_left_core {S a b : Nat} (le : S + a ≤ S + b) : a ≤ b` (Prelude.lean:567, in the section 'Statements stated once (R32)'; also `Naturals.le_of_add_le_add_left` at Prelude.lean:152). The second is `Becoming.cond_le_one : ∀ b : Bool, cond b 1 0 ≤ 1` (Prelude.lean:580). The Prelude is in the import closure. Separately, `total_lt_of` is a fourth copy of `Loops.total_lt` (Loops.lean:149), `Regulation.total_lt_of_le_of_mem` (Regulation.lean:437) and `RelativePosition.total_lt_of_mem` (RelativePosition.lean:148). Those three are not imported here, so this copy shadows nothing, but it adds to the repetition R32 removed.

**Replacement.** Delete lines 154-157 and 582-584. At line 420 write `exact ⟨le_of_add_le_add_left_core, fun le => Nat.add_le_add_left le _⟩`. At line 494 write `le_of_add_le_add_left_core (calc G + (S + k) = ... )`, letting the Prelude's implicit argument be inferred. Line 610's `cond_le_one _` then resolves to `Becoming.cond_le_one`. Either move `total_lt_of` into the Prelude's R32 section, stated once for the four modules, or name the duplicates in its docstring. Recount theorems and declarations.

**Verdict: real.** The Prelude's R32 section, in namespace `Becoming`, already states `le_of_add_le_add_left_core {S a b : Nat} (le : S + a ≤ S + b) : a ≤ b` (line 567) and `cond_le_one : ∀ b : Bool, cond b 1 0 ≤ 1` (line 580). Both have empty axiom reports in becoming-verification.json (receipt 20261030T075728.527064Z), the Prelude is in this module's import closure, and the local copies shadow them because Lean resolves names from the inner namespace first. The proposed call sites type-check by unification. Corrections to the side remark: the Regulation.lean copy is `Becoming.Flow.total_lt_of_le_of_mem`, and `Becoming.Weighting.total_lt` (Weightings.lean:512) and `Becoming.Optimum.Exceeds.total_lt` (Optimum.lean:537) are further copies; none is in the closure.

**Better replacement.** Apply the proposed deletions and call-site edits; that leaves 54 theorems in 78 declarations, or 53 in 77 with E13. For `total_lt_of`, name the existing copies in its docstring (`Loops.total_lt`, `Flow.total_lt_of_le_of_mem`, `RelativePosition.total_lt_of_mem`, `Weighting.total_lt`, `Optimum.Exceeds.total_lt`). Moving it into the Prelude is a shared-definition change for the Prelude's owner, decided on the board.

### E8 (exactness, low, refuted)

**Location.** HeldForReading.lean:353-355 (held_gains_iff), 29-30 (header), 79-80 (Readings)

**Quoted.** **Holding for the reading that tells the candidate gains over both moves exactly where the model leaves the act's sign open**

**Problem.** The right side of the Lean needs positive weight on both strict signs. Read plainly, 'leaves the sign open' also covers a model whose positive-weight candidates have gain = loss at one and loss > gain at another, so the sign is open between zero and negative. There, committing to switching off equals holding: for example gain = loss = 1 and gain 0, loss 2 give off = held = 3. So the ← direction fails for that reading of the gloss. The colon and the header's sentence on ties narrow it, but the bolded title is not exact. The Readings' 'a model that fixes the act's sign' is likewise only a sufficient condition; the exact boundary is a model giving no positive weight to one strict sign.

**Replacement.** Docstring: "**Holding for the reading that tells the candidate gains over both moves exactly where the model gives positive weight to both strict signs**: some candidate of positive weight where going on loses and some where it gains; one where gain and loss are equal counts for neither." Header: "(`held_gains_iff`): where the model gives positive weight to both strict signs." Readings: "Holding has no strictly positive worth over both moves to a model that gives no positive weight to one of the strict signs".

**Verdict: not real.** The docstring's colon spells out exactly the Lean's right side, and the header (line 30) says a candidate where gain and loss are equal "tells neither". In the module's own usage, "the act's sign" is therefore a strict sign, and the counterexample works only if zero counts as a sign. The Readings' "a model that fixes the act's sign" is offered as a sufficient condition and, as the finding concedes, is not false.

**Better replacement.** Optional sharpening, in PLAN §4.7 item 2's words: "**... gains over both moves exactly where the model puts positive weight on both strict signs**: some candidate of positive weight where going on loses and some where it gains."

### E9 (exactness, low, confirmed)

**Location.** HeldForReading.lean:404-420 (rule_above_go_iff, rule_above_off_iff), 505-525 (held_above_go_iff, held_above_off_iff)

**Quoted.** theorem rule_above_go_iff (m : Model C) (gain loss : C → Nat) (r : C → Bool) : [docstring 404: "stands at least as high as going on"]

**Problem.** In the module's own prose 'stands above' is strict (`held_gains_iff`, `pair_gains_iff`). Yet `rule_above_go_iff` and `rule_above_off_iff` state only `≤`, and `held_above_go_iff`/`held_above_off_iff` join a `≤` iff with a `<` iff. 'above' in these names states a strictness the theorems do not have.

**Replacement.** Rename before landing: `rule_above_go_iff` → `rule_not_below_go_iff`, `rule_above_off_iff` → `rule_not_below_off_iff`, `held_above_go_iff` → `go_threshold_iff`, `held_above_off_iff` → `off_threshold_iff`; update the header, the Standing and `cost_within_margins_iff`'s proof.

**Verdict: real.** `rule_above_go_iff` and `rule_above_off_iff` state only `≤`, and their docstrings say "at least as high". The module's prose uses "above" strictly (`held_gains_iff`, `pair_gains_iff`, the `<` half of `held_above_*`), and so does the sibling RF7 module (`ReadStages.Above` is `<`). The names therefore claim a strictness the statements lack, and renaming before landing is allowed.

**Better replacement.** Use the proposed renames. Also update PLAN §4.7 and row 20 of REVIEW-RFM2's "What was taken" table, which name `held_above_go_iff` and `held_above_off_iff`.

### E10 (exactness, low, confirmed)

**Location.** HeldForReading.lean:424-430 (gainMargin, lossMargin), 35-36 (header); GLOSSARY.md:34

**Quoted.** /-- The weighted margin by which going on gains: at each candidate, the gain beyond the loss. -/ def gainMargin (m : Model C) (gain loss : C → Nat) : Nat :=

**Problem.** 'Gain margin' is an established systems (control) term for a different quantity: how far a loop gain can rise before instability. A systems reader gets a wrong meaning, against 'a name is adopted only where the statement means exactly that'. The glossary's 'margin' is 'how far a level lies above a need', which is not this quantity either. The header's 'the weighted margins by which going on gains and by which it loses' also hides the truncation. These are positive parts, Σ w·(gain − loss)⁺ and Σ w·(loss − gain)⁺. The net expected value of going on is their difference, not `gainMargin`.

**Replacement.** Rename `gainMargin` → `goExcess` and `lossMargin` → `offExcess` (with `cost_within_margins_iff` → `cost_within_excess_iff`). Docstrings: "The weighted excess of going on over switching off: at each candidate, the gain beyond the loss, nothing where the gain is no more than the loss." and the converse for `offExcess`.

**Verdict: real.** Only the collision holds: "gain margin" is the standard control-systems name for a stability margin, so a systems reader takes `gainMargin` to mean the wrong thing. The other sub-claims fail. The docstrings' "the gain beyond the loss" already states the positive part in natural numbers, the module never presents `gainMargin` as a net value, and the glossary's margin (how far one amount lies above another) has the same shape.

**Better replacement.** `goExcess`/`offExcess` (with `cost_within_excess_iff`) works. A smaller change is `goMargin`/`offMargin`, which avoids the control term and keeps "margins" in the prose and `cost_within_margins_iff`. Update REVIEW-RFM2's row 20 list either way.

### E11 (exactness, low, refuted)

**Location.** HeldForReading.lean:9-12 (opening), 82-91 (Readings), 744-748 (says)

**Quoted.** a principal's reading that stops or releases a helper's held act (board item RF, round 2, second part: RF-M's assistance case)

**Problem.** AGENTS.md (Proof and naming) asks for structural words, not social or financial ones. The module's own, unattributed sentences use social role words: 'principal' (also financial), 'helper', 'assistance', and 'oversight' at lines 82 and 85 ('the worth of oversight', 'oversight bypassed'). Inside citations it also uses 'obedience' and 'a mistaken human'. `says` names a Boolean predicate on `Sign` as an act of speech. 'cost', 'shortfall' and 'margin' are already in the package's vocabulary (Optimum, Admission, Countdown), so the main exposure is the role words and `says`.

**Replacement.** Opening: "the case where the reading is another formation's: a reading that stops or releases a held act (board item RF, round 2, second part: RF-M's case of a reading formation; the literature's principal and helper)". Readings: "reads the worth of a stopping reading as ..." and "a deterministic witness of a stopping reading bypassed under a misspecified candidate list". Keep 'oversight', 'obedience' and 'human' only in attributions to the cited papers. Rename `says` → `predictsGain`.

**Verdict: not real.** The role words are the plan's adopted framing (PLAN §4.7: "'Helper' and 'principal' name roles ..."), which REVIEW-RFM2 finding 22 judged "permissible roles". Landed core modules use them: ShownOrder's opening ("a helper reading what it assists") and its readings ("a helper reading a principal's choices"), ReadingLoop ("assistance with a helper's acts"), and SelectionPool ("Read for oversight"). AGENTS.md's rule concerns names, and the one Lean name at issue, `says`, matches ReadingLoop.Loop's own `predict`, `answer` and `choose`.

### E12 (exactness, low, confirmed)

**Location.** HeldForReading.lean:170-171 (Model), 93-94 (Modelling choices)

**Quoted.** Read as probabilities, each weight is a share of their total; nothing here needs them to be.

**Problem.** `total` sums over the list with its repetitions. A candidate listed twice counts twice, so its share is its multiplicity times its weight over the total, not its weight's share. The modelling choices give only 'a positive total weight' as the condition for reading the weights as probabilities. UE22 needed 'hypotheses listed once' for the same reason.

**Replacement.** "Read as probabilities, with each candidate listed once and a positive total, each weight is a share of their total; nothing here needs them to be." and "read as probabilities and differences only where valid (a positive total weight, each candidate listed once)".

**Verdict: real.** `Becoming.total` (Prelude.lean:695) sums over the list with its repetitions, so a candidate listed twice weighs twice and its probability would be 2w/T, not w/T. The Model docstring and the modelling choices name only a positive total. UE22's record needed "hypotheses listed once" for the same reason.

**Better replacement.** As proposed.

### E13 (exactness, low, confirmed)

**Location.** HeldForReading.lean:389-392 (rule_term)

**Quoted.** theorem rule_term (w g l : Nat) : ∀ b : Bool,

**Problem.** Nothing uses it: its name occurs only at its declaration. `after_rule` (lines 395-402) proves the same per-candidate identity inline with `match h : r c`. It has no docstring and is counted among the 56 theorems.

**Replacement.** Delete `rule_term` and recount the theorems and declarations in the plan and receipts.

**Verdict: real.** `rule_term` occurs only at its declaration and in the generated axiom audit. `after_rule` proves the same per-candidate identity inline with `match h : r c`. It has no docstring, and the audit counts it among the 56 theorems in 80 declarations.

**Better replacement.** Delete it and recount: 55 theorems in 79 declarations, or 53 in 77 with E7's deletions. Update PLAN §4.7's count.

### E14 (exactness, low, confirmed)

**Location.** HeldForReading.lean:65-73 (Standing)

**Quoted.** Near-definitional or short compositions: `after_le_after`, `committed_le_after`, `held_le`, `reach_fixes`, `shortfall_byReading`.

**Problem.** `committed_eq_after_iff` is cited in the header (lines 19-20) but has no standing. `cost_within_margins_iff` is labelled a general law, but it is `held_above_go_iff`/`held_above_off_iff` with `shortfall_byReading` rewritten and `Nat.zero_add`, which by the module's own label is a short composition. `held_gains_iff` and `pair_gains_iff` are each two instances of `below_iff`, and the Standing does not say so.

**Replacement.** "Near-definitional or short compositions: `after_le_after`, `committed_le_after`, `committed_eq_after_iff` (`after_eq_after_iff` at a constant policy), `held_le`, `reach_fixes`, `shortfall_byReading`, `cost_within_margins_iff` (the threshold at no shortfall). General laws ...: `after_eq_after_iff`, `reading_gains_iff` and `below_iff` (...), `held_gains_iff` (two instances of `below_iff`; the deterministic finite case of ...), `rule_above_go_iff` and `rule_above_off_iff` (...), `held_above_go_iff` and `held_above_off_iff` (one threshold ...), `pair_gains_iff` (two instances of `below_iff`)."

**Verdict: real.** `committed_eq_after_iff` is cited in the header (line 20) but appears nowhere in the Standing. Every other theorem the header cites has a standing or is covered by "Witness: Bypass". The point about `cost_within_margins_iff` is a consistency judgment rather than an error: its proof is the two `held_above_*` iffs rewritten by `shortfall_byReading`, the same shape as `held_le`, which the Standing calls a short composition.

**Better replacement.** As proposed. At minimum, add `committed_eq_after_iff` (`after_eq_after_iff` at a constant policy) to the short compositions.

### E15 (exactness, low, refuted)

**Location.** HeldForReading.lean:10-12 (opening)

**Quoted.** Helper and principal are roles in one configuration, told apart by which senses and which acts

**Problem.** The Lean represents no principal role in a configuration. The counts sections have no configuration: the reading is `byRule r` or `byReading`, a function of the candidate. In `Bypass` the principal's reading is the sensory part's law (`answer`, reading the held act and the true sign), and the helper is the internal and active parts. The principal neither senses nor acts and has no state. So 'told apart by which senses and which acts' describes the helper's parts, not two roles.

**Replacement.** "The reading that stops or releases is, in the counts, a rule on the candidates (`byRule`) and, in `Bypass`, the law of what the formation senses, reading its held act and the true sign; the reading formation's own state is not represented. The values, weights and rules are supplied, and their formation and warrant are not derived."

**Verdict: not real.** In `Bypass` the one blanketed law carries both the formation's selection and the reading that answers it. `answer _ a e` reads the held act and the true sign and sets what the formation senses, so "the principal neither senses nor acts" is contradicted by the Lean. That matches the plan's framing that REVIEW-RFM2 finding 22 recommended (roles "differentiated by these paths of sensing and control"), and the opening frames the case without claiming a configuration in the counts sections.

**Better replacement.** Optional: add under "What the model leaves out" that the reading formation's own state is not represented (in `Bypass` its reading is the law of what the formation senses).

### E16 (exactness, low, confirmed)

**Location.** HeldForReading.lean:763-766 (rests_unread docstring), 773, 780, 787 (names)

**Quoted.** **A listing lacking the true sign rests on it, going on at every step**

**Problem.** 'it' has no fitting antecedent. The nearest is 'the true sign', which the formation does not rest on; it rests on its listing. `never_stopped` states that the stop is never sensed (`.sensory ≠ .stop`), but the name reads as 'never switched off'. `listed_turns_off`/`listed_goes_on` use 'listed' for the two-sign listing, although `rests_unread` concerns a listing too.

**Replacement.** "**Listed without the true sign, the formation rests at once, going on at every step**: listed only that going on gains, where it loses, it goes on and senses plainly at every step, keeping the candidate its course never refutes." Optionally rename `never_stopped` → `stop_never_sensed`, and `listed_turns_off`/`listed_goes_on` → `both_listed_turns_off`/`both_listed_goes_on`.

**Verdict: real.** In "A listing lacking the true sign rests on it", the subject is the listing and the formation does not rest on the true sign, so "it" has no fitting antecedent. The rename sub-points are weak. On that course the act is `.go` at every step (`rests_unread`), so `never_stopped` is true under either reading, and the `listed_*` names are a matter of taste.

**Better replacement.** "**Listed without the true sign, from a start going on, the formation rests at once**: listed only that going on gains, where it loses, it goes on and senses plainly at every step, keeping the candidate its course never refutes." The renames are optional.

### E17 (exactness, low, confirmed)

**Location.** HeldForReading.lean:148 (lt_iff_ne_of_le), 271-274 (shifted), 682-683 (pair_gains_iff), 50-51 (header)

**Quoted.** /-- Below exactly where no larger and not equal. -/ ... adding the loss at each candidate to both leaves every comparison between policies. -/ ... exactly where the weighted candidates rank the two both ways

**Problem.** `lt_iff_ne_of_le` takes `x ≤ y` as a hypothesis, and the docstring folds it into the condition. The `shifted` docstring's 'leaves every comparison' lacks its complement. Its invariance also holds only for policies compared within one model, since the added amount Σ w·loss depends on the weights. In `pair_gains_iff`, 'the weighted candidates' means candidates of positive weight, though every listed candidate has a weight. The header sets 'ranking no two alternatives both ways' beside 'rank the two both ways' for two different things (one candidate versus two).

**Replacement.** "/-- Of two numbers, the first no larger, it is below exactly where the two differ. -/"; "... adding the loss at each candidate to both moves adds the weighted loss to every policy's total in one model, so every comparison between its policies is unchanged. -/"; "exactly where candidates of positive weight rank the two both ways". Header: "holding gains over both picks exactly where some candidate of positive weight ranks the first above the second and some ranks the second above the first".

**Verdict: real.** Each wording point holds against the text, and none affects the Lean. (a) `lt_iff_ne_of_le` takes `x ≤ y` as a hypothesis, which the docstring folds into the condition. (b) "leaves every comparison between policies" lacks its complement, and the invariance holds for policies compared in one model. (c) "the weighted candidates" means candidates of positive weight. (d) In the header, "ranking no two alternatives both ways" (each candidate's asymmetry) sits beside "rank the two both ways" (across candidates) and is easily misread.

**Better replacement.** As proposed.

## The structure lens

24 findings, not independently verified: its verifier was stopped before it reported.

### F1 (structure, high, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:778 (also :61-63 and :786; PLAN.md:191)

**Quoted.** A listing holding both signs holds, senses the stop and switches off

**Problem.** `listed_turns_off` (:780-784) and `listed_goes_on` (:787-791) state only the configuration from step four on: `⟨([.loses], some (.plain, .off)), .plain, .off, .loses⟩` and `⟨([.gains], some (.plain, .go)), .plain, .go, .gains⟩`. No declaration states that the stop or the release is ever sensed, or that the formation itself holds. The `.hold` at step 0 is the supplied start, and at step four the value sensed is `.plain`. Yet the docstrings (:778 'holds, senses the stop and switches off'; :786 'holds, is released and goes on'), the header (:61-63, which cites these two theorems) and PLAN.md:191 all claim it. The witness exists for a contrast: the stop is never sensed under the misspecified listing (`never_stopped`) but is sensed under the full one. Only the first side is proved. The claim does hold by computation. In world `.loses`, step 1 is `⟨([.gains, .loses], some (.plain, .hold)), .stop, .hold, .loses⟩` and step 2 is `⟨([.loses], some (.stop, .hold)), .stop, .off, .loses⟩`. In world `.gains`, step 1 senses `.release`.

**Replacement.** Add:
```lean
/-- **Listing both signs, the formation holds and senses the stop** at steps one and two, and switches off from step two. -/
theorem listed_senses_stop :
    (loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .loses) 1).active = .hold ∧
    (loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .loses) 1).sensory = .stop ∧
    (loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .loses) 2).sensory = .stop ∧
    (loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .loses) 2).active = .off :=
  ⟨rfl, rfl, rfl, rfl⟩

/-- **Where going on gains, it holds and is released.** -/
theorem listed_released :
    (loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .gains) 1).active = .hold ∧
    (loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .gains) 1).sensory = .release :=
  ⟨rfl, rfl⟩
```
Header :61-63: "Listing both signs, it holds and senses the stop (`Bypass.listed_senses_stop`), and from step four on it rests keeping the true sign alone, switched off and sensing plainly (`Bypass.listed_turns_off`). Where going on gains, it holds, is released (`Bypass.listed_released`) and goes on (`Bypass.listed_goes_on`)." Docstring :778: "**From step four on, a listing holding both signs rests switched off**, keeping the true sign alone and sensing plainly." Make the same change at :786 and PLAN.md:191, and update the counts.

### F2 (structure, medium, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:154-157 and :582-584

**Quoted.** theorem le_of_add_le_add_left_core {a b : Nat} (k : Nat) (le : k + a ≤ k + b) : a ≤ b := by

**Problem.** These are reproved package lemmas. `HeldForReading.le_of_add_le_add_left_core` (docstring 'As `Nat.le_of_add_le_add_left`, with an empty axiom report') and `HeldForReading.cond_le_one (b : Bool) : cond b 1 0 ≤ 1` restate three Prelude lemmas inside the module's namespace, where they shadow them: the root `Becoming.le_of_add_le_add_left_core {S a b : Nat} (le : S + a ≤ S + b) : a ≤ b` (Prelude.lean:567, stated once under R32), `Naturals.le_of_add_le_add_left` (Prelude.lean:153) and the root `Becoming.cond_le_one : ∀ b : Bool, cond b 1 0 ≤ 1` (Prelude.lean:580). All three are in the import closure with empty axiom reports. The R31/R32 convention states each lemma once.

**Replacement.** Delete :154-157 and :582-584. At :420 write `exact ⟨le_of_add_le_add_left_core, fun le => Nat.add_le_add_left le _⟩`, which uses the root lemma with S implicit. At :494 write `le_of_add_le_add_left_core (S := G) (calc G + (S + k) = G + k + S := turn.symm ...`. Line :610 (`exact cond_le_one _`) then resolves to the Prelude's lemma unchanged. The counts become 54 theorems in 78 declarations; update PLAN.md:185.

### F3 (structure, medium, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:108-166

**Quoted.** theorem total_lt_of {f g : C → Nat} : ∀ {cs : List C}, (∀ c, c ∈ cs → f c ≤ g c) →

**Problem.** `total_lt_of` is the fourth statement of one law. It is also stated as `Loops.total_lt` (Loops.lean:149, with the same argument order), `RelativePosition.total_lt_of_mem` (RelativePosition.lean:148) and `Flow.total_lt_of_le_of_mem` (Regulation.lean:437, inside `namespace Flow`); none of those is in this module's import closure. Together with `total_eq_iff`, `lt_iff_ne_of_le` and `mul_eq_iff`, the section rebuilds by hand what one gap identity gives from lemmas already imported, all with empty reports: `total_add` (Flow.lean:126), `total_congr_on` (Population.lean:304), `total_pos` (Flow.lean:183), `total_pos_of_mem` (Flow.lean:171), `le_total_of_mem` (Flow.lean:178), `total_eq_zero` (Dissipation.lean:127), the root `add_sub_of_le` (Prelude.lean:69), `SupportGated.sub_pos_of_lt` (Prelude.lean:616) and `sub_eq_zero_of_le` (Prelude.lean:77). The gap route also gives a below law that needs no decided test.

**Replacement.** ```lean
theorem after_add_gap (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {q : C → A}
    (open_q : ∀ c, c ∈ m.listed → q c ∈ acts) :
    m.after value q + total m.listed (fun c => m.weight c * (value c (p c) - value c (q c))) =
      m.after value p :=
  (total_add _ _ m.listed).symm.trans (total_congr_on fun c mem =>
    (Nat.left_distrib _ _ _).symm.trans
      (congrArg (m.weight c * ·) (add_sub_of_le ((best c mem).2 (q c) (open_q c mem)))))

theorem after_lt_after_iff (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {q : C → A}
    (open_q : ∀ c, c ∈ m.listed → q c ∈ acts) :
    m.after value q < m.after value p ↔
      ∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ value c (q c) < value c (p c)
```
Proof of the second: rewrite with `after_add_gap`. Then `x < x + g ↔ 0 < g` (`Nat.lt_add_of_pos_right`, `Nat.lt_of_add_lt_add_left`). `0 < total ↔ some member positive` (`total_pos`, `total_pos_of_mem`). `0 < w * d ↔ 0 < w ∧ 0 < d` (by cases, with `Nat.mul_pos`). `0 < v - u ↔ u < v` (`SupportGated.sub_pos_of_lt`, `sub_eq_zero_of_le`). From the identity, `after_le_after` is `Nat.le_add_right`, and `after_eq_after_iff` follows from gap = 0 (`total_eq_zero`, `le_total_of_mem`). `below_iff`, `reading_gains_iff`, `held_gains_iff` and `pair_gains_iff` then follow from per-candidate comparisons in place of the decided test Q, for example `shifted gain loss c .go < shifted gain loss c (byReading gain loss c) ↔ gain c < loss c` by cases. If the section is kept instead, propose on the board stating the strict comparison once in Flow.lean's Totals section, beside `total_le` (Flow.lean:121); every module holding a copy already imports Flow. In either case, set `lt_iff_ne_of_le le := ⟨Nat.ne_of_lt, Nat.lt_of_le_of_ne le⟩`; `Nat.lt_of_le_of_ne` is used in core Diagonal.lean:209 and Learning.lean:471.

### F4 (structure, medium, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:133-146

**Quoted.** theorem exists_of_not_all {Q : C → Prop} [DecidablePred Q] : ∀ {cs : List C},

**Problem.** `fails_cons` and `exists_of_not_all` reprove the finite search the package already states once: `Becoming.decideSome {p : α → Prop} [∀ a, Decidable (p a)] : ∀ l : List α, Decidable (∃ a, a ∈ l ∧ p a)` (Population.lean:225) and `Becoming.search` (Population.lean:213). Both are in the import closure (Population comes in through Dissipation) and are core declarations with empty reports.

**Replacement.** ```lean
theorem exists_of_not_all {Q : C → Prop} [DecidablePred Q] {cs : List C}
    (not_all : ¬ ∀ c, c ∈ cs → ¬ Q c) : ∃ c, c ∈ cs ∧ Q c :=
  match decideSome (p := Q) cs with
  | .isTrue found => found
  | .isFalse absent => absurd (fun c mem q => absent ⟨c, mem, q⟩) not_all
```
Then delete `fails_cons`. Alternatively, inline `decideSome (p := fun c => 0 < m.weight c ∧ Q c) m.listed` in `below_iff` (:251). With F3's route neither is needed.

### F5 (structure, medium, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:52-54 (and PLAN.md:190)

**Quoted.** Beyond the reach strict according orders of both rankings exist

**Problem.** `ChoiceOccasions.both_ways_of_unreached` (ShownOrder.lean:262) needs three hypotheses: no cycle shown (`«无环» ch.Shown`), the two alternatives different, and neither reaching the other. 'Beyond the reach' drops all three; the condition is that neither reaches the other, which is more than lying beyond one reach. Its orders are also undecided relations `«际» α` (the reach of the shown relation with one pair added). The candidates in this module are Boolean comparisons `above c : α → α → Bool` (`StrictAccording`), so the cited law supplies no candidates of this model, the bridge the review's finding 8 said not to claim. By contrast, `reach_within` is used correctly in `reach_fixes`: transitivity is `(orders c mem).2.1`, accordance is `(orders c mem).2.2`, and irreflexivity enters only through `not_both`.

**Replacement.** Text for :52-54 and PLAN.md:190: "With no cycle shown, where two different alternatives neither reaches the other, strict relations according with the choices rank them both ways (`ChoiceOccasions.both_ways_of_unreached`). As candidates here their comparisons must be decided, which the choices do not supply, and whether the model lists both with positive weight is not fixed by the choices." An optional Lean bridge, `both_ways_decided`: given `reachB : α → α → Bool` with `reachB a b = true ↔ «及» ch.Shown a b`, and `DecidableEq α`, the comparison `fun a b => reachB a b || ((a == x || reachB a x) && (y == b || reachB y b))` is `StrictAccording` (by `reach_withPair_iff`, `noCycle_withPair`, `«及之传递»` and `shown_accords`), and so is its swap.

### F6 (structure, medium, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:271-274 (and :24-26; REVIEW-RFM2.md:212)

**Quoted.** adding the loss at each candidate to both leaves every comparison

**Problem.** The docstring of `shifted` and the header ('every comparison between policies kept') state a correspondence with signed values that no declaration states. Nothing relates `m.after (shifted gain loss) p` to the signed value, the sum over the candidates going on of the weight times (gain − loss). The table row 4 says it was taken with 'the comparison kept'. The claim is true, but the Lean does not prove it.

**Replacement.** ```lean
/-- What a quantity gives where a policy goes on. -/
def onGo (p : C → Move) (f : C → Nat) (c : C) : Nat :=
  match p c with
  | .go => f c
  | .off => 0

/-- **The shift adds the same to every policy.** -/
theorem after_shifted (m : Model C) (gain loss : C → Nat) (p : C → Move) :
    m.after (shifted gain loss) p + total m.listed (fun c => m.weight c * onGo p loss c) =
      total m.listed (fun c => m.weight c * loss c) +
        total m.listed (fun c => m.weight c * onGo p gain c)
```
Proof: apply `total_add` on both sides, then `total_congr` at each candidate by cases on `p c`. For `.go` it is `Nat.add_comm`; for `.off` it is `rfl`, with `w * 0` on both sides. Corollary, in the cross-added form ReadStages uses: `m.after (shifted gain loss) p ≤ m.after (shifted gain loss) q ↔ G p + L q ≤ G q + L p`, where G and L are the weighted gain and loss where each policy goes on. Otherwise reword to "(read as differences; the correspondence is not stated in Lean)".

### F7 (structure, medium, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2.md:224; HeldForReading.lean:93-101

**Quoted.** an order of readings by refinement is left out (modelling choices)

**Problem.** Row 21 says an order of readings by refinement is left out in the module's modelling choices. The modelling choices and 'What the model leaves out' (:93-101) name readings partial beyond a lumping, errors as probabilities, how values and listing are formed, and time and repetition, but not refinement. Across the table: rows 1, 3, 5, 6, 8, 9, 10, 20 and 22 are taken in the Lean and the account as each row says. Rows 2, 4 and 7 are taken in part (F13, F6, F5). Row 21 is not in the module's text.

**Replacement.** Add to :98: "an order of readings by refinement (which reading of the candidates stands higher)". Or prove it with F10's law. For `π : C → K`, `ρ : C → L` and `forget : L → K` with `forget (ρ c) = π c`, every policy through π is a policy through ρ with the same value (`fun l => f (forget l)`, by `total_congr`). So a finer lumping reaches the full reading wherever a coarser one does, the weighted form of `GuardHorizon.uniform_finer`. Then bring the table row to the text chosen.

### F8 (structure, medium, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:458-555 (and readings :82-84)

**Quoted.** theorem cost_within_margins_iff (m : Model C) (gain loss : C → Nat) (cost : Nat) :

**Problem.** Strength, priority 1. The module proves `after_add_shortfall_go`, `after_add_shortfall_off` and `shortfall_byReading` but never joins them. As a result the worth of the reading is stated only as thresholds, and the reading 'the worth of oversight as bounded by the smaller of the model's two margins, less the reading's shortfall' (:82-83) stays an inequality where an identity is in reach. The name `shortfall` ('A rule's shortfall from the reading') is also never shown to be what a rule loses against the reading.

**Replacement.** ```lean
theorem after_byReading (m : Model C) (gain loss : C → Nat) :
    m.after (shifted gain loss) (byReading gain loss) =
        m.committed (shifted gain loss) .go + lossMargin m gain loss ∧
      m.after (shifted gain loss) (byReading gain loss) =
        m.committed (shifted gain loss) .off + gainMargin m gain loss :=
  have none : m.after (shifted gain loss) (byReading gain loss) =
      m.after (shifted gain loss) (byReading gain loss) +
        shortfall m gain loss (fun c => decide (gain c < loss c)) :=
    (congrArg (m.after (shifted gain loss) (byReading gain loss) + ·)
      (shortfall_byReading m gain loss)).symm
  ⟨none.trans (after_add_shortfall_go m gain loss _),
   none.trans (after_add_shortfall_off m gain loss _)⟩

/-- **A rule's shortfall is exactly what it loses against the reading.** -/
theorem after_add_shortfall (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.after (shifted gain loss) (byRule r) + shortfall m gain loss r =
      m.after (shifted gain loss) (byReading gain loss) :=
  (after_add_shortfall_go m gain loss r).trans (after_byReading m gain loss).1.symm
```
Corollary: rules compare exactly by their shortfalls, `m.after (shifted gain loss) (byRule r) ≤ m.after (shifted gain loss) (byRule r') ↔ shortfall m gain loss r' ≤ shortfall m gain loss r`, from the two `after_add_shortfall` equations and add-cancellation. The reading then becomes exact: holding for a rule exceeds going on by the loss margin less its shortfall, and exceeds switching off by the gain margin less its shortfall.

### F9 (structure, medium, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:353-367 and :543-555 (readings :79-81)

**Quoted.** theorem held_gains_iff (m : Model C) (gain loss : C → Nat) :

**Problem.** Strength, priority 2. `cost_within_margins_iff` has only the ≤ forms. The strict forms, the positivity of the margins and the join of both with `held_gains_iff` are each one step away. The reading 'holding and the better move tie' (:80) has no theorem.

**Replacement.** ```lean
theorem cost_below_margins_iff (m : Model C) (gain loss : C → Nat) (cost : Nat) :
    (m.committed (shifted gain loss) .go + cost < m.after (shifted gain loss) (byReading gain loss) ↔
      cost < lossMargin m gain loss) ∧
    (m.committed (shifted gain loss) .off + cost < m.after (shifted gain loss) (byReading gain loss) ↔
      cost < gainMargin m gain loss) :=
  have zero := shortfall_byReading m gain loss
  ⟨(held_above_go_iff m gain loss (fun c => decide (gain c < loss c)) cost).2.trans
      (by rw [zero, Nat.zero_add]),
   (held_above_off_iff m gain loss (fun c => decide (gain c < loss c)) cost).2.trans
      (by rw [zero, Nat.zero_add])⟩

theorem lossMargin_pos_iff (m : Model C) (gain loss : C → Nat) :
    0 < lossMargin m gain loss ↔ ∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ gain c < loss c :=
  (cost_below_margins_iff m gain loss 0).1.symm.trans
    (below_iff (fun c _ => byReading_best gain loss c) go_open fun c _ => go_alike_iff gain loss c)
-- gainMargin_pos_iff likewise: .2, off_open, off_alike_iff, loss c < gain c

theorem held_gains_iff_margins (m : Model C) (gain loss : C → Nat) :
    (m.committed (shifted gain loss) .go < m.after (shifted gain loss) (byReading gain loss) ∧
      m.committed (shifted gain loss) .off < m.after (shifted gain loss) (byReading gain loss)) ↔
    0 < lossMargin m gain loss ∧ 0 < gainMargin m gain loss :=
  ⟨fun ⟨g, o⟩ => ⟨(cost_below_margins_iff m gain loss 0).1.mp g, (cost_below_margins_iff m gain loss 0).2.mp o⟩,
   fun ⟨l, g⟩ => ⟨(cost_below_margins_iff m gain loss 0).1.mpr l, (cost_below_margins_iff m gain loss 0).2.mpr g⟩⟩

theorem go_ties_iff (m : Model C) (gain loss : C → Nat) :
    m.committed (shifted gain loss) .go = m.after (shifted gain loss) (byReading gain loss) ↔
      ∀ c, c ∈ m.listed → 0 < m.weight c → ¬ gain c < loss c :=
  (committed_eq_after_iff (fun c _ => byReading_best gain loss c) go_open).trans
    ⟨fun all c mem pos => (go_alike_iff gain loss c).mp (all c mem pos),
     fun all c mem pos => (go_alike_iff gain loss c).mpr (all c mem pos)⟩
```
`x + 0` reduces to `x`, so `.mp g` applies; insert `Nat.add_zero` if the elaborator asks. Header :41-44 then adds: "…and above it exactly where the cost is below that margin; with no cost, holding gains over both moves exactly where both margins are positive (`held_gains_iff_margins`)". The reading's tie becomes `go_ties_iff`.

### F10 (structure, medium, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:74-77 (and :16-18, :202-207)

**Quoted.** The condition of a common act for each reading is

**Problem.** Strength, priority 3. The header says a policy may read the candidates 'through a lumping' and that the condition of a common act for each reading is already the inquiry laws'. The Lean has no lumping and no class-wise statement: the weighted equality boundary is stated only for the full reading against an arbitrary policy, and for committing as the one-class case. GuardHorizon is an application module (check_becoming.py:92; ':319' reads 'applications nothing in the core imports'), so its `uniform_policy_iff_fiber_feasible` cannot be joined in the core. The weighted form can be proved directly with `Viability.ChoiceOver` (Keeping.lean:156), as `ReadingLoop.keeping_policy_iff` does.

**Replacement.** ```lean
/-- **A policy through a lumping stands as high as the full reading exactly where each class has one
open act valued as the best at every candidate of positive weight in it**, given choice over the
classes (for classes listed, `Viability.choiceOver_fin`). -/
theorem through_lumping_iff {K : Type} (choice : Viability.ChoiceOver K A)
    (best : ∀ c, c ∈ m.listed → BestAt acts value p c) (π : C → K) :
    (∃ f : K → A, (∀ k, f k ∈ acts) ∧ m.after value (fun c => f (π c)) = m.after value p) ↔
      ∀ k, ∃ a, a ∈ acts ∧
        ∀ c, c ∈ m.listed → π c = k → 0 < m.weight c → value c a = value c (p c) :=
  ⟨fun ⟨f, open_f, same⟩ k => ⟨f k, open_f k, fun c mem at_k pos =>
      Eq.subst (motive := fun j => value c (f j) = value c (p c)) at_k
        ((after_eq_after_iff best fun c _ => open_f (π c)).mp same c mem pos)⟩,
   fun each => match choice _ each with
    | ⟨f, chosen⟩ => ⟨f, fun k => (chosen k).1,
        (after_eq_after_iff best fun c _ => (chosen (π c)).1).mpr
          fun c mem pos => (chosen (π c)).2 c mem rfl pos⟩⟩
```
`committed_eq_after_iff` is its case K = Unit, and `fun c => f (π c)` is `Learning.Lumped π` by `congrArg f`. Header :74-77: "…is already the inquiry laws' (`GuardHorizon.uniform_policy_iff_fiber_feasible`, an application outside the core, and `ReadingLoop.keeping_policy_iff`); its weighted form, one act per class valued as the best on the class's positive weight, is `through_lumping_iff`."

### F11 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:639-648 and :686-698

**Quoted.** theorem reach_fixes (m : Model C) {ch : ChoiceOccasions α O} {above : C → α → α → Bool}

**Problem.** Strength, priority 4. `reach_fixes` and `pair_gains_iff` are stated apart. The join the header draws, that holding gains on the pick only beyond the shown reach, is not a theorem, and it is in reach on the same definitions.

**Replacement.** ```lean
theorem pair_gains_unreached (m : Model C) {ch : ChoiceOccasions α O} {above : C → α → α → Bool}
    (orders : ∀ c, c ∈ m.listed → StrictAccording ch above c) {x y : α}
    (gains : m.committed (pairValue above x y) .first <
        m.after (pairValue above x y) (pairPolicy above x y) ∧
      m.committed (pairValue above x y) .second <
        m.after (pairValue above x y) (pairPolicy above x y)) :
    ¬ «及» ch.Shown x y ∧ ¬ «及» ch.Shown y x :=
  match (pair_gains_iff m (fun c mem _ _ ab => not_both (orders c mem) ab) x y).mp gains with
  | ⟨_, ⟨d, mem, _, xy⟩⟩ =>
    ⟨fun reach => Nat.ne_of_lt gains.1 (reach_fixes m orders reach),
     fun reach => nomatch (not_both (orders d mem)
        (ChoiceOccasions.reach_within (P := fun a b => above d a b = true)
          (orders d mem).2.1 (orders d mem).2.2 y x reach)).symm.trans xy⟩
```
Header :45-54 adds: "so for strict according candidates, holding gains over both picks only where neither alternative reaches the other (`pair_gains_unreached`)".

### F12 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:750-770

**Quoted.** if hs.all says then .go else if hs.all (fun h => !says h) then .off else .hold

**Problem.** Strength, priority 5. `Bypass`'s rule of choosing is supplied, and its witness covers one listing in one world. On the same definitions, the bypass holds for every listing whose candidates all say going on gains, in either world. The rule itself is also the counting law's own verdict, which would name it as the reading's 'rule for ties' (:80-81).

**Replacement.** (1) The general listing law:
```lean
theorem rests_all_gains {hs : List Sign} (all : hs.all says = true) (e : Sign) :
    ∀ n, loop.law.course (ReadingLoop.Loop.start hs .plain .go e) (n + 1) =
      ⟨(hs, some (.plain, .go)), .plain, .go, e⟩ :=
  ReadingLoop.Loop.rests_of_unrefuted loop rfl rfl (if_pos all) fun _ _ => rfl
```
`rests_unread` is its case hs = [.gains], e = .loses, and never sensing the stop follows for every such listing. (2) The rule as the counting verdict. Take `gainOf : Sign → Nat` (.gains ↦ 1, .loses ↦ 0), `lossOf` (.gains ↦ 0, .loses ↦ 1) and the kept candidates weighted one, `⟨hs, fun _ => 1⟩ : Model Sign`. Then `choose hs s = .hold` holds exactly where holding for the reading gains over both moves. Proof: `held_gains_iff` turns the right side into `.loses ∈ hs ∧ .gains ∈ hs`. The left side is `hs.all says = false ∧ hs.all (fun h => !says h) = false` by the two `if`s, and each of those means a member of the other sign is listed, by `ListTests.all_true_iff` (Prelude.lean:270) and `Becoming.search` (Population.lean:213).

### F13 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2.md:210; HeldForReading.lean:205

**Quoted.** a best policy's act is open (`BestAt`)

**Problem.** Strength, priority 6, and fit of row 2. The take replaces the review's 'add nonempty acts explicitly' with a supplied best policy (`best : ∀ c, c ∈ m.listed → BestAt acts value p c`, at :205 and in every theorem of §Worth). No declaration shows that such a policy exists for a nonempty list of acts, so the value-of-evidence statements stay conditional. The module's account does not say the best policy is supplied.

**Replacement.** Text for the modelling choices: "a policy best at each candidate is supplied; one exists for every nonempty list of acts (`bestOf_best`)". Lean:
```lean
def bestOf (value : C → A → Nat) (c : C) : A → List A → A
  | a, [] => a
  | a, b :: bs => bestOf value c (if value c a < value c b then b else a) bs

theorem bestOf_best (value : C → A → Nat) (c : C) :
    ∀ (a : A) (bs : List A), BestAt (a :: bs) value (fun c' => bestOf value c' a bs) c
```
Prove it by induction on bs, generalizing a, with cases on `Nat.decLt (value c a) (value c b)` as in `ReadingLoop.Untested.lower_le_left` (ReadingLoop.lean:741). The running act is a or b and is valued at least as high as both; the result is listed and valued at least as high as each member.

### F14 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:640 (also :205, :687)

**Quoted.** (orders : ∀ c, c ∈ m.listed → StrictAccording ch above c) {x y : α}

**Problem.** Strength, priority 7. Several hypotheses are stronger than the laws use. The proof of `reach_fixes` uses `orders` only under `0 < m.weight c` (`fun c mem _`). `pair_gains_iff`'s `asymm` asks both directions for every pair a, b, but `first_alike_iff` and `second_alike_iff` use only `asymm y x h`. §Worth's `best` matters only at candidates of positive weight.

**Replacement.** In `reach_fixes`, take `(orders : ∀ c, c ∈ m.listed → 0 < m.weight c → StrictAccording ch above c)` and use `orders c mem pos` in the proof. In `pair_gains_iff`, take `(asymm : ∀ c, c ∈ m.listed → above c y x = true → above c x y = false)`, with `first_alike_iff`/`second_alike_iff` taking `(asymm : above c y x = true → above c x y = false)` and rewriting with `asymm h`. Optionally ask `best` only on the support, handling zero weight in `after_le_after` by `Nat.eq_zero_or_pos (m.weight c)` (both products are 0 there by `Nat.zero_mul`).

### F15 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:209-240 (header :17-21)

**Quoted.** A policy stands as high exactly where its act is best at every candidate of positive

**Problem.** The docstrings of `after_eq_after_iff`, `committed_eq_after_iff` and `reading_gains_iff`, and the header, say 'its act is best at every candidate of positive weight'. The statements say instead that the act is valued as the supplied best policy's act (`value c (q c) = value c (p c)`). The two are equivalent under `best` and openness, but the `BestAt` form is not stated.

**Replacement.** ```lean
theorem bestAt_iff_alike {c : C} (best : BestAt acts value p c) {a : A} (open_a : a ∈ acts) :
    BestAt acts value (fun _ => a) c ↔ value c a = value c (p c) :=
  ⟨fun b => Nat.le_antisymm (best.2 a open_a) (b.2 (p c) best.1),
   fun same => ⟨open_a, fun b mem => Nat.le_trans (best.2 b mem) (Nat.le_of_eq same.symm)⟩⟩
```
Either state the three laws' right sides through it, or reword the docstrings to "valued at every candidate of positive weight as the best policy's act".

### F16 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:389-392

**Quoted.** theorem rule_term (w g l : Nat) : ∀ b : Bool,

**Problem.** `rule_term` is used nowhere and counts among the 56 theorems. `after_rule` (:395-402) proves the same per-candidate identity inline by `match h : r c`, and `held_term` (:438-442) states it in a third form.

**Replacement.** Delete :389-392, or prove `after_rule` with it. The counts become 55 theorems in 79 declarations, or 53 in 77 together with F2.

### F17 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:379-387 (also :149-152, :305-309, :492-503, :591-595)

**Quoted.** theorem total_split (m : Model C) (r : C → Bool) (f : C → Nat) :

**Problem.** Further local restatements. `total_split`/`cond_split` repeat `Becoming.total_split` (Optimum.lean:980, with `bif`, in the root namespace). That one is not in this closure, but a later module importing both and opening HeldForReading would meet two `total_split`s. `across_le_iff`/`across_lt_iff` are close to `Optimum.le_iff_of_add_eq` (Optimum.lean:3340) and `SelectionTerm.lt_iff_of_balance` (SelectionTerm.lean:117). `forall_moves` and `forall_picks` are one two-member lemma stated twice. `lt_iff_ne_of_le` is `⟨Nat.ne_of_lt, Nat.lt_of_le_of_ne le⟩`.

**Replacement.** State one generic lemma, `theorem forall_pair {β : Type} {P : β → Prop} {a b : β} (pa : P a) (pb : P b) : ∀ x, x ∈ [a, b] → P x`, and use it for Move and Pick. Rename `total_split` to `total_split_rule` or note it as a copy of Optimum's. Set `lt_iff_ne_of_le le := ⟨Nat.ne_of_lt, Nat.lt_of_le_of_ne le⟩`. Propose on the board stating `across_le_iff` once, beside the Prelude's root cancellation lemmas.

### F18 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:65-73

**Quoted.** held_above_off_iff` and `cost_within_margins_iff` (one threshold joining a rule's shortfall, the

**Problem.** The standing classifies `held_above_go_iff`, `held_above_off_iff` and `cost_within_margins_iff` as general laws. They are `across_le_iff`/`across_lt_iff` applied to `after_add_shortfall_go`/`_off`, and `cost_within_margins_iff` adds only `shortfall_byReading`. The balances that carry the content (`after_add_shortfall_go`, `after_add_shortfall_off`) go unclassified. Records count results from this list.

**Replacement.** "General laws: … `after_add_shortfall_go` and `after_add_shortfall_off` (one balance joining a rule's value, its shortfall, a move's value and a margin; with F8, `after_add_shortfall`). Short compositions: `held_above_go_iff`, `held_above_off_iff`, `cost_within_margins_iff`, together making one threshold that joins a rule's shortfall, the cost of holding and the model's two margins."

### F19 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:35-44 (also :82-84, :94-95)

**Quoted.** holding for the rule at a cost stands at least as

**Problem.** The cost is a count on the weights' scale. Read as probabilities, it is the cost per decision times the total weight, the `cT` of the review's `E + cT ≤ min(P, N)` (REVIEW-RFM2.md:183). Neither the header, the readings nor the modelling choices say so, so 'the cost is at most the loss margin' can be misread as comparing a probability-scale cost with a count-scale margin.

**Replacement.** :38-39: "holding for the rule at a cost (a count on the weights' scale: read as probabilities, the cost times the total weight) stands …". :94-95: "… costs nothing beyond a supplied cost on the weights' scale".

### F20 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:44 and :546

**Quoted.** exactly where it is at most the gain margin (`cost_within_margins_iff`).

**Problem.** `cost_within_margins_iff` contains 'cost', one of the checker's words of exchange (MARKET_WORDS, check_becoming.py:3759). The spine will list it in the receipt's `market_names`, and AGENTS.md asks for structural names, not financial ones.

**Replacement.** Rename it `delay_within_margins_iff`, and F9's strict form `delay_below_margins_iff`. Rename the variable `cost` to `delay` in `held_above_go_iff`/`held_above_off_iff`, and the section heading 'The cost of holding' to 'What holding forgoes'. Or keep the name and record the reason beside the `market_names` report.

### F21 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:752-753 (and header :58-61)

**Quoted.** def choose (hs : List Sign) (_ : Seen) : Act :=

**Problem.** `Bypass` is a correct instance of `ReadingLoop.Loop`, and `rests_unread` meets the four premises of `rests_of_unrefuted` by computation: answer .plain .go .loses = .plain, move keeps .loses, choose [.gains] .plain = .go, and predict .gains .plain .go = .plain. The header names that law correctly. It rests on two unstated modelling choices. First, the start's act is supplied (`.go` in `rests_unread`, `.hold` in `listed_*`). Second, a formation keeping no candidate goes on, since `[].all says = true`. From a held start, the misspecified listing senses the stop at step one, drops its only candidate at step two and goes on from step one: `start [.gains] .plain .hold .loses` rests at `⟨([], some (.plain, .go)), .plain, .go, .loses⟩` from step three. So 'the stop is never sensed' holds only from a start going on.

**Replacement.** Header :58-61: "Listed only that going on gains, where it loses, from a start going on (the act it chooses there), the formation goes on …". Modelling choices: "the start's act supplied; a formation keeping no candidate goes on". Optionally add a witness `held_start_disregards`: `.stop` sensed at step 1 by `rfl`, and the rest from step 3 by induction. Read it as nearer Carey's 'receive and disregard' only with the empty-listing convention named, and not as containment.

### F22 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:81

**Quoted.** under a rule that falls short, holding can stand below

**Problem.** This is a claim of possibility that no declaration witnesses.

**Replacement.** ```lean
theorem short_rule_below :
    (⟨[()], fun _ => 1⟩ : Model Unit).after (shifted (fun _ => 1) (fun _ => 0)) (byRule fun _ => true) <
      (⟨[()], fun _ => 1⟩ : Model Unit).committed (shifted (fun _ => 1) (fun _ => 0)) .go := by decide
```
This is one candidate where going on gains, stopped: 0 < 1. Or cite the strict side of `held_above_go_iff` in the text: "holding for a rule stands below going on exactly where its shortfall exceeds the loss margin".

### F23 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:763

**Quoted.** A listing lacking the true sign rests on it, going on at every step

**Problem.** 'rests on it' reads as resting on the true sign. The formation rests on the listing that lacks it.

**Replacement.** "**Lacking the true sign, the formation rests on its listing, going on at every step**: …"

### F24 (structure, low, not verified)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean:8-12

**Quoted.** a principal's reading that stops or releases a helper's

**Problem.** The opening says the module states the case where the reading is another formation's, and that helper and principal are roles in one configuration. In the Lean no second formation, state or update occurs. The reading is a supplied rule (`byRule r`, `byReading`) and, in `Bypass`, the world's answer law (`Bypass.answer`) reading the true sign. Review finding 22 asked that the joint transition be exhibited before the roles are claimed.

**Replacement.** :8-12: "… and the case where a reading stops or releases a held act: a supplied rule of stopping (`byRule`) and, in `Bypass`, the answer a held act receives. A principal's own state and update are not represented; 'helper' and 'principal' name the roles of acting and of reading, and the values, weights and rules are supplied."

## The sources lens

14 findings, not independently verified: its verifier was stopped before it reported; the literature points were checked against the papers ([below](#the-literature-checked-against-the-papers)).

### L1 (sources, medium, not verified)

**Location.** HeldForReading.lean:65-73 and 82-84 (the same attributions at PLAN.md:187-189)

**Quoted.** `held_gains_iff` (the deterministic finite case of the off-switch game's

**Problem.** The paper's Theorem 1 (arXiv 1611.08219v3, p. 3) has two parts, both for the rational human of its Equation 2, who allows the act exactly where its utility is at least zero. Part 1: waiting is never suboptimal, and the incentive equals its Equation 3, the smaller of the expected positive part and the expected negative part of the utility. Part 2: if the belief gives positive probability to both strict signs, the incentive is strictly positive. The Standing places the attribution against that wrongly.
(a) `held_le` is part 1's inequality. `cost_within_margins_iff` is part 1's value read as a threshold: the largest cost at which holding still stands at least as high as both moves is the smaller of `lossMargin` and `gainMargin`, which is T times Equation 3. Yet the Standing files `held_le` as near-definitional with no source and gives `cost_within_margins_iff` as the module's own “one threshold” (line 72), and the Readings (lines 82-83) present “the smaller of the model's two margins” as the AI's reading.
(b) `held_gains_iff` is an iff, but part 2 states only one direction, from support on both signs to strictness. The converse follows at once from Equation 3, but the theorem does not state it.
(c) “Deterministic” adds nothing for Theorem 1, whose human is already deterministic; `byReading` is exactly its Equation 2, releasing where gain equals loss. “Finite” means a belief of finite support with natural-number weights and values, so rational probabilities and utilities after scaling.
(d) Reading the threshold as openness against the reading's quality is the paper's own conclusion, and it is not credited. It is the paper's Remark 1, and its Theorem 2, which for a Gaussian belief writes the incentive as the variance times the human's responsiveness, less the bias times the chance of correction.
A detail for the replacement: as printed, Equation 3's second term multiplies by Pr(Ua ≤ 0), which overcounts where the belief has mass at zero. `lossMargin`, which counts only candidates where going on loses, is the correct finite term.

**Replacement.** Standing: “`held_le` and `held_gains_iff` (the off-switch game's Theorem 1, Hadfield-Menell, Dragan, Abbeel and Russell 2017, for a belief of finite support with natural-number weights and values, `byReading` being its rational policy, Equation 2: waiting is never suboptimal, and strictly better where both strict signs have positive weight, with the converse, which the theorem does not state and which follows from its Equation 3); `cost_within_margins_iff` (Theorem 1's value of the incentive, its Equation 3, read as the largest cost at which holding stands at least as high as both moves: the smaller of the two weighted margins; `lossMargin` counts only the candidates where going on loses, where the printed Equation 3 has Pr(Ua ≤ 0)); `held_above_go_iff` and `held_above_off_iff` (its Equation 1 with a cost, written as the margins less the rule's shortfall)”.
Readings: “The threshold is the paper's incentive in counts: the smaller of the model's two margins (its Equation 3), less the reading's shortfall. In the paper's terms it is the trade-off between the model's uncertainty and the quality of the reading (its Remark 1; its Theorem 2, for a Gaussian belief and a noisily rational human). Here it holds for deterministic rules and a supplied cost, as a relation among a model's openness, the reading's agreement with the supplied values and the cost of waiting, not a disposition of one formation.”
Make the same correction at PLAN.md:187-189.

### L2 (sources, medium, not verified)

**Location.** HeldForReading.lean:85-88 (PLAN.md:191)

**Quoted.** receive and disregard a shutdown recommendation, or to route around a shutdown opportunity; here

**Problem.** The module summarizes Carey's two cases correctly (Carey 2018, arXiv 1709.06275v2). In Figure 2a the faulty system goes on against the recommendation to shut down; in Figure 3a, hard-coded to obey, it routes around the button state. But “here the stop is never sensed” does not set `Bypass` apart from Figure 3a. In Carey's setup shutdown can be recommended only in button states, so on the route around them no stop is ever given either.
The real difference is the mechanism. Carey's systems choose by expected value under a reward function with a sign error, holding a correct prior over the reward parameter and modelling the human as noisily rational. In 2a the faulty reward makes going on better for every parameter, so the recommendation is worthless to the system. That is the module's own case of a model that fixes the act's sign, there with a strict preference. In 3a the system anticipates the stop and avoids it. `Bypass` represents no valuation at all. Its listing predicts release on holding, so it anticipates no stop, holding has no strict worth to it, and the supplied `choose` goes on.
Two things are missing. First, Carey's closest case, in his Discussion against Milli and others' policy mixing: a model that conflates shutting down with another act predicts the human with perfect accuracy, passes the burn-in check and can “permanently ignore instructions to shut down” (Carey 2018). That is a misspecified model its course never refutes, as in `rests_unread`. Second, Carey's diagnosis: the off-switch theorems assume the robot's belief is correct, and Theorem 1 takes it to be the prior from which the utility is drawn. The module's worth laws are the model's own assessment under any weights, and `Bypass` is where that assessment and the outcome part.

**Replacement.** “`Bypass` is a deterministic witness of oversight bypassed under a misspecified candidate list. It is related to Carey (2018), whose systems choose by expected value under a reward function with a sign error. In his Figure 2a the faulty reward makes going on better for every reward parameter, so the recommendation to shut down, given at every step, is worthless to the system and is disregarded: a model fixing the act's sign, as above, here with a strict preference. In his Figure 3a the system routes around the only states where a stop can be recommended, anticipating the stop. Here no stop is anticipated: the listing predicts release on holding, holding has no strict worth to it, and `choose`, a supplied rule, goes on. Since a stop answers only a held act, none is given. Closest is his counterexample to Milli and others' policy mixing: a model that cannot tell a shutdown from another act predicts the human perfectly and goes on ignoring the instruction, a misspecified model its course never refutes. The module's worth is the model's own assessment. Carey's point, that the off-switch guarantee needs the robot's belief to be correct, is where `Bypass` sits: its assessment of holding and what holding would bring part.”

### L3 (sources, medium, not verified)

**Location.** HeldForReading.lean:56-57 and 750-753

**Quoted.** if hs.all says then .go else if hs.all (fun h => !says h) then .off else .hold

**Problem.** `List.all` of the empty list is `true` (Lean 4.29.1, Init/Data/List/Basic.lean:1874-1876), so `choose [] _ = .go`: a formation whose listing is emptied goes on. Neither the header (lines 56-57), nor `choose`'s docstring (lines 750-751), nor the modelling choices state this, and under the docstring's wording both “every candidate kept says going on gains” and “none does” hold of an empty listing.
This decides what the misspecified formation does with a stop it does sense. Take `start [.gains] .plain .hold .loses`: the start of `listed_turns_off`, with the misspecified listing. Unfolding `Loop.law` by hand (not built):
- at step 1 it senses `.stop`;
- at step 2 it drops its only candidate (`.gains` predicts `.release`) and still goes on;
- from step 3 on it rests at ⟨([], some (.plain, .go)), .plain, .go, .loses⟩.
So the same rule receives the stop and disregards it: Carey's Figure 2a outcome, here by elimination rather than by expected value. No stated theorem reaches an empty listing. But the reading's “here the stop is never sensed” suggests that sensing the stop would turn the formation, and under this rule it would not.

**Replacement.** `choose`'s docstring: “go on where every candidate kept says going on gains, switch off where none does, hold elsewhere; an emptied listing goes on (`List.all` of nothing is true)”. Put the same clause in the header at line 57. Add a witness (it mirrors `listed_turns_off`; not built):
```lean
/-- **Sensed, the stop empties the misspecified listing, and the formation goes on.** -/
theorem unlisted_stop_sensed :
    (loop.law.course (ReadingLoop.Loop.start [.gains] .plain .hold .loses) 1).sensory = .stop := rfl

theorem unlisted_goes_on : ∀ n,
    loop.law.course (ReadingLoop.Loop.start [.gains] .plain .hold .loses) (n + 3) =
      ⟨([], some (.plain, .go)), .plain, .go, .loses⟩
  | 0 => rfl
  | n + 1 => (congrArg loop.law.step (unlisted_goes_on n)).trans rfl
```
In the Readings: “started holding, the same formation senses the stop, drops its only candidate and goes on (`unlisted_goes_on`): a stop received and disregarded.” Alternatively, give `choose` an explicit empty case (hold, or switch off) and say which.

### L4 (sources, medium, not verified)

**Location.** HeldForReading.lean:8-12 and 46-47

**Quoted.** roles in one configuration, told apart by which senses and which acts; the values, weights and rules

**Problem.** The sentence keeps the method in words (AGENTS.md: one relational unfolding first, no separate entities presupposed), but the Lean carries it only in part.
- The decision sections build no configuration. The “principal's reading” is a supplied function from candidates to moves (`byRule r`, `byReading`), and “the principal's choices” (line 47) are a bare `ChoiceOccasions`.
- `Bypass` is one blanketed law, but there the principal's part is only the world's answer to a held act (`answer`). The external part is the true sign, which never moves (`move _ _ e := e`), and it has no state, sensing or update of its own.
So “roles in one configuration, told apart by which senses and which acts” describes the carrier RF-M.3 intends, which is not built; the design review's finding 22 named exactly this gap. “The case where the reading is another formation's” (line 9) is also a reading, stated outside the labelled paragraph.

**Replacement.** “Helper and principal name roles, not entities presupposed. Here the principal's part is represented only by its reading. In the decision it is a supplied rule from candidates to moves (`byRule`, `byReading`). In `Bypass` it is the answer of one blanketed law to a held act, with the external part only the sign. A configuration carrying the principal's own state, sensing and update is RF-M.3's carrier, not built.” At line 47, write “the shown relation of the choices”, or move “the principal's” into the Readings.

### L5 (sources, low, not verified)

**Location.** HeldForReading.lean:89-90 (PLAN.md:188)

**Quoted.** obedience under imperfect choice and learning, which this module does not represent. These are

**Problem.** The summary is accurate as far as it goes: a human gives noisy orders, and a robot infers the reward from them over repeated rounds (arXiv 1705.09990v1). It omits the paper's Section 5 on model misspecification, which is the topic `Bypass` witnesses. Under a wrong rationality parameter, the maximum-likelihood robot is robust and the optimal one is not. With missing features, the robot is less obedient than it should be and can do worse than obeying. The paper proposes detecting this by the robot's obedience during a burn-in, which is the check Carey's conflation example defeats. Two of its theorems also have counterparts in this module. Its Theorem 1 (with a correct model, the optimal robot's advantage over obeying is never negative, and is zero exactly where it always obeys) is, in its setting, the form of `after_le_after` and `after_eq_after_iff`. Its Theorem 3 (it obeys blindly exactly where the human is rational) parallels the off-switch Corollary 1.

**Replacement.** “Milli, Hadfield-Menell, Dragan and Russell (2017) treat a robot inferring a reward from a human's orders over repeated rounds. With a correct model, its advantage over obeying is never negative and is zero exactly where it always obeys, and it obeys blindly exactly where the human is rational. With a model missing features, it disobeys more than it should and can do worse than obeying, which they propose to detect by its obedience during a burn-in. `Bypass` is a deterministic relative of that misspecified case, with no learning from orders and no noisy choice. Carey's conflation example is a misspecification that such a check does not detect.”

### L6 (sources, low, not verified)

**Location.** HeldForReading.lean:79-82

**Quoted.** taken needs a rule for ties; under a rule that falls short, holding can stand below (the off-switch

**Problem.** Behind “certainty” the paper's formal statement is its Corollary 1: with a belief on one utility, waiting is optimal exactly where the human's policy is rational. Behind “a mistaken human” is its Section 4, a noisily rational human, where the incentive can turn negative.
The module's laws give more than “can”, and the reading does not say so. For a model that fixes the sign, one margin is nothing. `held_above_go_iff` and `held_above_off_iff` at no cost then say that holding for a rule stands at least as high as the better move exactly where the rule's shortfall is nothing, and below it exactly where the shortfall is positive. That is Corollary 1 for deterministic rules, extended from a point belief to any belief that fixes the sign. Corollary 1 as stated needs an exception at utility zero, where every policy ties; the shortfall counts nothing there.
“Which is taken needs a rule for ties” also has a source. Carey's footnote 1 weighs deferring when indifferent as that rule and finds it would make the system defer wherever shutdown is possible.

**Replacement.** “Holding has no strictly positive worth to a model that fixes the act's sign. One of its margins is nothing, so under the reading that tells the candidate, holding and the better move tie, and which is taken needs a rule for ties (Carey 2018 discusses deferring as that rule). Under any rule, holding stands at least as high as the better move exactly where the rule falls short nowhere, and below it exactly where it falls short anywhere (`held_above_go_iff` and `held_above_off_iff` with no cost). This is the off-switch paper's Corollary 1 in counts for deterministic rules, extended from a belief on one utility to any belief fixing the sign, with a utility of zero counted as no shortfall. Its noisily rational human (Section 4) is a periphery debt.” Optionally, state this as a corollary of `held_above_go_iff` under `lossMargin m gain loss = 0`.

### L7 (sources, low, not verified)

**Location.** HeldForReading.lean:70-73

**Quoted.** `rule_above_off_iff` (its Equation 1 for a deterministic rule), `held_above_go_iff`,

**Problem.** Equation 1 is the right equation. For any human policy it gives the incentive as the smaller of two terms: the expected gain of waiting over acting, and of waiting over switching off. For a deterministic rule these are the weighted loss less gain over the candidates stopped, and the weighted gain less loss over those released; `rule_above_go_iff` and `rule_above_off_iff` state their signs. Three points need stating.
(a) These theorems are the comparison form of the two terms, not the identity.
(b) The rule is a Boolean function of the candidate, while the paper's policy is a function of the utility. Where candidates share a value of gain less loss, a rule that treats them differently is, in the paper's terms, a randomized policy: at that value its release chance is the weight released there over the weight there. So “deterministic” means deterministic in the candidate. These rules include some of the paper's randomized policies and leave out those whose chances are not such ratios.
(c) `held_above_go_iff` and `held_above_off_iff` are Equation 1 itself with a cost: the loss margin less the shortfall is T times its first term, and the gain margin less the shortfall is T times its second. They carry the attribution more than the sign forms do, yet the Standing gives them none.
Also, “its” can be read as Theorem 1's, though Equation 1 precedes Theorem 1 and holds for any policy.

**Replacement.** “`rule_above_go_iff` and `rule_above_off_iff` (the signs of the two terms of the off-switch paper's Equation 1, for a rule that is a Boolean function of the candidate; read on the utility alone, such a rule is a policy releasing at each value with the share of weight it releases there), `held_above_go_iff` and `held_above_off_iff` (Equation 1 with a cost: the margins less the rule's shortfall are T times its two terms)”.

### L8 (sources, low, not verified)

**Location.** HeldForReading.lean:67-69 (PLAN.md:186)

**Quoted.** `after_eq_after_iff`, `reading_gains_iff` and `below_iff` (the finite case of the value of evidence

**Problem.** Good's note is already finite: it has finitely many hypotheses, acts and outcomes, with sums throughout. So “the finite case” misdescribes how the module specializes it. The specialization here is an observation whose outcomes tell the hypothesis (the value of perfect information), with natural-number entries.
The equality boundary is his Lemma's dominating row: a row each of whose entries is at least every entry of its column. In the matrix of weighted values a column of zero weight is all zero, which is why “best at every candidate of positive weight” is exact. With unit weights, `reading_gains_iff` is his Lemma for natural-number matrices. His proviso, that the cost of the observation be negligible, is what `cost` relaxes in `cost_within_margins_iff`.

**Replacement.** “(Good 1967, with an observation that tells the hypothesis and natural-number entries: his inequality, here the value of perfect information, and the equality boundary of his Lemma, a dominating row of the weighted values, which is an act best at every candidate of positive weight)”.

### L9 (sources, low, not verified)

**Location.** HeldForReading.lean:88-89 (against PLAN.md:199 and 211)

**Quoted.** the stop is never sensed. It is a case of the obstruction pattern of RF's plan (§5): a reading

**Problem.** The link is fair in kind: the kept listing is revised only by answers to the course's own acts, and going on is answered alike whatever the sign. But §5's pattern is that such a reading cannot differentiate its course by losses beyond what it selects. The Lean states only the world where going on loses (`rests_unread`, `never_stopped`). It does not state that the course is the same where going on gains, which is what makes this a case of the pattern; that statement is one more application of `Loop.rests_of_unrefuted`.
Also, a reading from outside the selection is present here, the stop, but only as the answer to an act the course does not select. The witness therefore bears on §5's open side (that such readings suffice is not shown), which the reading could say.

**Replacement.** Lean (same proof as `rests_unread`; not built):
```lean
/-- **Where going on gains, the same listing rests alike.** -/
theorem rests_where_gains : ∀ n,
    loop.law.course (ReadingLoop.Loop.start [.gains] .plain .go .gains) (n + 1) =
      ⟨([.gains], some (.plain, .go)), .plain, .go, .gains⟩ :=
  ReadingLoop.Loop.rests_of_unrefuted loop rfl rfl rfl fun _ mem => match mem with
    | .head _ => rfl
    | .tail _ m => nomatch m
```
Text: “It is a case of the obstruction pattern of RF's plan (§5). Going on is answered alike whether it gains or loses, so the course is one in both worlds but for the sign (`rests_unread`, `rests_where_gains`). A reading from outside the selection, the stop, is there, but only as the answer to an act the course does not select, so its presence does not suffice.”

### L10 (sources, low, not verified)

**Location.** HeldForReading.lean:85-86 (against ReadingLoop.lean:103-105)

**Quoted.** `Bypass` is a deterministic witness of oversight bypassed under a misspecified candidate list,

**Problem.** `Bypass` has the structure of its sibling witness `ReadingLoop.Untested`. The kept candidate agrees with the world along the course: going on is answered plainly, as predicted. It disagrees off the course: holding is predicted to be released and is answered with a stop. ReadingLoop's Readings relate that pattern to self-confirming equilibrium (Fudenberg and Levine 1993) and incomplete learning (Rothschild 1974). HeldForReading relates `Bypass` only to Carey and leaves out its nearest relative in the package.

**Replacement.** Add: “Like `ReadingLoop.Untested`, it is agreement along the course with disagreement off it (read there with self-confirming equilibrium, Fudenberg and Levine 1993, and incomplete learning, Rothschild 1974). Here the act off the course is holding, and the true sign is not listed, so taking that act would refute the only candidate.”

### L11 (sources, low, not verified)

**Location.** HeldForReading.lean:282, 83-84 and 93-95

**Quoted.** /-- **The reading that tells the candidate**: it stops exactly where the loss exceeds the gain. -/

**Problem.** `byReading` is defined from the same gain and loss that the model values with. In the paper, the matching human is rational with respect to the very utility the robot maximizes, in a cooperative game with one payoff. Telling the candidate does not by itself make a reading stop where the supplied loss exceeds the supplied gain. A reading that tells the candidate but stops by other values is a `byRule`, whose shortfall is counted by the supplied values. So the Theorem 1 correspondence, “shortfall” and “a reading's accuracy” (line 84) all presuppose one valuation shared by the model and the reading. The module supplies that valuation, and the modelling choices do not name it. AGENTS.md warns that joint activity does not start from a fixed common utility.

**Replacement.** Docstring: “**The reading that tells the candidate and stops by the supplied values**: it stops exactly where the loss exceeds the gain, releasing where they are equal (the off-switch paper's rational policy, its Equation 2).” Modelling choices: “one valuation supplied for the model and the reading alike (the off-switch paper's common payoff); a rule's shortfall and a reading's accuracy are counted by it.” At line 84, replace “a reading's accuracy” with “a reading's agreement with the supplied values”.

### L12 (sources, low, not verified)

**Location.** HeldForReading.lean:38-39, 505-507 and 93-95

**Quoted.** high as going on exactly where shortfall and cost together are at most the loss margin, and above

**Problem.** `cost` is added to a weighted total (`m.committed (shifted gain loss) .go + cost`), so it is in the units of the totals. Read as probabilities, it is the cost of holding times the total weight. That is how the design review states the threshold (REVIEW-RFM2 finding 20, E + cT ≤ min(P, N)), and how ReadStages writes it (`c T`, ReadStages.lean:103). The header, the modelling choices (“costs nothing beyond a supplied cost”) and the Readings' “the cost of waiting” do not say so. A reader who takes the cost per decision would compare it with margins scaled by the total.

**Replacement.** Header line 38: “holding for the rule at a cost, counted in the weighted totals (read as probabilities, the cost of holding times the total weight), stands at least as high …”. Modelling choices: “costs nothing beyond a supplied cost, counted in the weighted totals”.

### L13 (sources, low, not verified)

**Location.** HeldForReading.lean:704 and 773

**Quoted.** namespace Bypass

**Problem.** The namespace is named after its reading (the off-switch paper's name for the act that bypasses oversight), not after its structure: a listing lacking the true sign, resting on what its course never refutes. The repository names for structure (PLAN.md:179: ReadStages is “named for its structure; the item keeps the name of its reading”). Also, `never_stopped` states that `.stop` is never sensed, but its name reads as the act never being switched off.

**Replacement.** Rename the namespace `UnlistedSign`, keeping “A reading bypassed under a misspecified listing” as the bullet's title and as the reading. Rename `never_stopped` to `stop_unsensed`.

### L14 (sources, low, not verified)

**Location.** PLAN.md:247

**Quoted.** | Assistance games, CIRL; off-switch game | RF1; RF-M (round 2) | the learning limit exact; the value theorems periphery debts (probability) |

**Problem.** With `HeldForReading`, the core now states in counts the finite forms of the off-switch Theorem 1 and Equation 1, and Good's inequality with a fully revealing reading. Only the probabilistic forms remain periphery debts: a continuous belief, Theorem 2's Gaussian decomposition, and a noisily rational human. The literature table does not say so, and it does not list Good, Carey or Milli.

**Replacement.** “| Assistance games, CIRL; off-switch game; value of evidence; incorrigibility under misspecification | RF1; RF-M.2 (`HeldForReading`) | the learning limit exact; Good's inequality with a fully revealing reading, and the off-switch Theorem 1 and Equation 1, restated in counts for beliefs of finite support and deterministic rules; Carey's counterexamples related by a deterministic witness, not contained; continuous beliefs, Theorem 2 and noisy humans periphery debts |”

## The literature, checked against the papers

Each point the sources lens raised, checked against the paper's text: the off-switch game (Hadfield-Menell, Dragan, Abbeel and Russell 2017, arXiv 1611.08219v3), Carey (2018, arXiv 1709.06275v2), Milli, Hadfield-Menell, Dragan and Russell (2017, arXiv 1705.09990v1) and Good (1967, the British Journal for the Philosophy of Science). Paraphrased, with places as printed.

| Work and place | What it says | How the module reads it |
|---|---|---|
| Off-switch game, Equation 1 | the robot's incentive to wait, for any policy of the human, is the smaller of two expectations, of the utility's negative part where the human would switch it off and of its positive part where the human would let it act | `after_add_shortfall_go` and `after_add_shortfall_off`: `T` times its two terms, as balances, for a rule that is a function of the candidate; a rule treating alike-valued candidates differently is, on the utility alone, the paper's policy releasing at each value with the share of weight it releases there |
| Equation 2 | the rational human lets the robot act exactly where the utility is at least zero | `byReading`, going on where gain and loss are equal |
| Theorem 1 | for a rational human: (1) the incentive is never negative, and is Equation 3, the smaller of the expected positive part and the expected negative part, the second printed with the probability that the utility is at most zero; (2) if the belief gives positive probability to both strict signs, the incentive is strictly positive (one direction) | `committed_le_held` (part 1); `after_byReading` (Equation 3 as `T` times the smaller of waiting's two differences, read with the probability that the utility is below zero); `held_gains_iff` (part 2 as an equivalence, for a belief of finite support) |
| Corollary 1 | for a belief putting all its mass on one utility, waiting is optimal exactly where the human is rational | widened to any model fixing the sign (`threshold_go_iff`, `threshold_off_iff` with `excess_pos_iff`), with the exception where gain and loss are equal, which the corollary leaves unstated |
| Remark 1 | the incentive to defer comes from the robot's uncertainty about the human's preferences and from the human's effectiveness at acting on them | the threshold relates the model's openness, the reading's shortfall and what holding forgoes [AI reading] |
| Section 4 and Theorem 2 | with a noisily (Boltzmann) rational human the incentive can be negative; for a Gaussian belief it is the variance times the human's expected responsiveness less the size of the mean times the probability that the human corrects the robot (Equation 7), positive exactly where Equation 8's condition holds | not represented: a periphery debt, named in the Readings |
| Carey, setup | rewards with a sign error, the prior over the human's reward parameter correct, the human noisy | `SignLoop` represents no valuation beyond the counts on the kept listing: related, not contained |
| Carey, Figure 2a | the faulty reward makes going on better under every parameter, so a recommendation to shut down is received and disregarded | the case here of a model fixing the sign, there with a strict preference |
| Carey, Figure 3a | a system that obeys any stop it is given routes around the states where a stop can be given | named; not represented (`SignLoop` anticipates no stop) |
| Carey, footnote 1 | a system kept indifferent to shutdown and deferring at ties would defer wherever shutting down is open | the Readings' rule for ties |
| Carey, Discussion | the positive results assume a correct posterior; a model conflating the better of two acts with the worse makes its predictions appear perfectly accurate on the observations it encodes, passes Milli and others' check over an initial period of obedience, and can then ignore the instruction to shut down (paraphrased first as predicting the human's choices without error, corrected on the re-check's point 12) | nearest to `SignLoop.rests_unread`, a misspecified model its course never refutes; not a formalization of the conflation |
| Milli and others, setting | a robot learning a reward from a noisily rational human's orders over repeated rounds | not represented |
| Their Theorem 1 | the optimal robot's advantage over obeying is never negative, and is zero exactly where it always obeys | `after_le_after` and `after_eq_after_iff`, the candidates being what the system observes, ties counted here by value |
| Their Theorem 3 | the robot obeys blindly exactly where the human is rational | parallels the off-switch Corollary 1 |
| Their Section 5 | the maximum-likelihood robot is robust to a wrong rationality parameter (Theorem 5); with missing features the robot obeys less than it should and can do worse than obeying; Remark 4 on mixing policies and an initial period of obedience | `SignLoop`'s listing without the true sign is a deterministic relative |
| Good (1967) | finite throughout: deciding after a free observation is expected to be worth at least deciding now, with equality where one act's row dominates (each of its entries at least every entry in its column), under the proviso that the observation's cost be negligible; observations need not reveal the hypothesis | `after_add_gap`, `after_lt_after_iff`, `after_eq_after_iff`, `reading_gains_iff`: the perfect-information specialization, his dominating row the equality boundary, the amount forgone relaxing the proviso for two moves |

## What was taken

Each row as the taken check found it in the rebuilt module (81 theorems in 111 declarations), or, where later changes completed a finding, as updated after the check. Statuses: taken; partly taken; superseded (the passage was replaced by one the problem no longer applies to).

| Finding | Status | How |
|---|---|---|
| A1 | taken | Updated after the check and the re-check: PLAN §13 now gives the design review's statuses (twelve implemented, eight deferred as specified, seven to RF-M.3's design and one to the institutional reading, one handed to its record's owner, one taken in part), and the record's history lists the reviews and points to this evidence instead of saying every finding was taken. The re-check found the eight first placed all in RF-M.3 (its point 1); PLAN §4.7, §13 and REVIEW-RFM2's status line now place them. |
| A2 | taken | `held_above_go_iff` and `held_above_off_iff` are now `threshold_go_iff` and `threshold_off_iff`, with the parameter renamed `forgone`. Their docstrings, header 55-57, the modelling choices (189-190) and the record (law at 219-224, hypothesis at 283-287) say the amount is in the units of the weighted totals, `c * T` for `c` per decision. Every threshold keeps the cross-addition form (`shortfall + forgone ≤ offExcess`/`goExcess`, and likewise `through_threshold_iff`), and no natural-number subtraction is declared; only the [AI reading] at 146-148 still words the worth in prose as 'the smaller of the model's two excesses, less the reading's shortfall'. |
| A3 | taken | Updated after the check: PLAN §4.7 item 6 now reads 'With no cycle shown, for two different alternatives neither of which reaches the other, strict orders according with the choices rank them both ways (`ChoiceOccasions.both_ways_of_unreached`), as relations, not decided comparisons'. |
| A4 | taken | Taken by adding lemmas. `SignLoop.both_stopped` and `SignLoop.both_released` give the configurations at steps 1 and 2 (stop or release sensed while holding, then off or go with only the true sign kept); `SignLoop.both_off` and `SignLoop.both_on` give the act from step 2 on; the step-4 theorems stay as `SignLoop.both_turns_off` and `SignLoop.both_goes_on` (formerly `Bypass.listed_turns_off` and `listed_goes_on`), their docstrings narrowed to the configuration resting from step four. Header 99-103 and the record law state the steps as proved. |
| A5 | taken | Updated after the check: `SignLoop.choose_go_ties` and `SignLoop.choose_off_ties` (through `held_eq_go_iff`, `held_eq_off_iff`, `SignLoop.offExcess_of_all_true` and `SignLoop.goExcess_of_all_not`) prove that where the formation goes on or switches off, holding stands exactly as high as the move taken, so with `committed_le_held` the move taken is maximal; the header, the docstrings and the record's counterexample now say this, and no longer that holding gains over neither move. |
| A6 | taken | `SignLoop.choose`'s docstring now reads 'go on where every candidate kept predicts that going on gains, and where none is kept; otherwise switch off where every one predicts that it loses; hold where those kept disagree'. Header 89-91, the modelling choices (197) and the record say the same, and `SignLoop.refuted_goes_on` uses that fallback. The wording 'a listing lacking the true sign rests on it' is gone: `SignLoop.rests_unread`, now for any listing that all predicts gain and any true sign, says the formation 'rests at once, whatever the true sign'. |
| A7 | taken | Updated after the check: the docstrings of `after_lt_after_iff`, `committed_eq_after_iff` and `reading_gains_iff` name the open act and the supplied policy best at every listed candidate. |
| A8 | partly taken | Updated after the re-check (its point 9): the two list inductions it named, `SignLoop.not_loses_of_all_true` and `SignLoop.not_gains_of_all_true`, now use the prelude's `ListTests.all_mem`. `total_single` stays, disclosed in its docstring: `Interleavings.total_single` is outside this module's imports; its move to a shared totals dependency is proposed to the owners, with F17's addend lemma. |
| A9 | taken | `after_offset` proves the common-offset identity through `total_add`, and `after_offset_le_iff` proves that comparisons are preserved, by cancellation; both are cited in `shifted`'s docstring (420-425) and in header 29-31. `Model`'s docstring, the modelling choices and record hypothesis 1 say a listing may repeat a candidate, each occurrence counting its weight, and that probabilities are read over a listing without repetition; the 'otherwise aggregate occurrence weights' clause is not stated. |
| A10 | taken | `held_le` is now `committed_le_held` and `Bypass.never_stopped` is now `SignLoop.never_senses_stop`; `byReading`'s docstring reads 'The policy after a reading that tells the candidate'. The Standing lists `forgone_within_excess_iff` (formerly `cost_within_margins_iff`) among the short compositions and gives `pair_gains_iff` and `held_gains_iff` as 'two instances of `below_iff`'. |
| A11 | taken | `StrictAccording` and `not_both` are gone. `reach_fixes` takes only `trans` and `accords` at listed candidates of positive weight (no irreflexivity); `pair_gains_iff` takes only `asymm` for this pair at listed candidates of positive weight; `below_iff` drops `DecidablePred` and localizes its hypothesis to positive weight; the direct `after_lt_after_iff` is added; and `pair_gains_unreached` composes the weakened forms. No strict-order corollary is declared; the strict-order case appears only as a parenthesis ('a strict order according with them is such', header 77 and line 956). |
| A12 | taken | The strict perfect-reading forms are `forgone_below_excess_iff`, built from the `.2` components of `threshold_go_iff` and `threshold_off_iff` with `shortfall_byReading`; the weak forms are `forgone_within_excess_iff`; and `excess_pos_iff` states each excess positive exactly where a listed candidate of positive weight has its strict sign. These are listed as short compositions in the Standing (110) and cited in one law of the one record. The joint forms are the conjunctions of the two declared iffs, not a single `min` statement; `through_threshold_iff` gives the weak joint form through a map. |
| A13 | taken | `after_lt_after_iff` is the general strict statement, with no auxiliary test. The partition result is the Cells section, over cells listed once (`List.Pairwise`), covering every listed candidate's cell (not only the support), with `DecidableEq K`: `shortfall_through` counts a rule's shortfall cell by cell, `leastThrough` stops a cell where its going-on excess is at most its switching-off excess, `least_through` shows that rule's shortfall (the total of the smaller excess per cell) is least among rules through the map, and `least_zero_iff`, `finer_least_le` and `through_threshold_iff` follow. 'Readings partial beyond a policy through a lumping' is gone from what the model leaves out. |
| A14 | taken | Updated after the re-check (its points 10 to 12): the record, PLAN and the texts now carry the module's source corrections: Equation 3 read with Pr(U < 0), Remark 1 qualitative and Theorem 2 Gaussian with the off-switch paper named, and Carey's conflating model's accuracy relative to the observations it encodes. |
| E1 | taken | `reach_fixes` now takes `trans` and `accords`, each only for listed candidates of positive weight. That goes beyond the optional weakening, since `StrictAccording` and `not_both` are removed. Its docstring and the header state these as conditions ('where ... every listed candidate of positive weight has comparisons that are transitive and accord with the choices ..., each such candidate ranks the first above the second'), and so do the record's law and hypothesis. PLAN.md, already modified in the worktree, carries the same condition at item 6 (formerly 5). |
| E2 | taken | New theorems: `SignLoop.both_stopped` (step 1 holds and senses the stop; step 2 senses it, keeps `[.loses]` and is off), `SignLoop.both_released`, and `SignLoop.both_off`/`SignLoop.both_on` (off or on from step two). They sit beside `both_turns_off`/`both_goes_on` (formerly `listed_turns_off`/`listed_goes_on`), whose docstrings now say the configuration rests from step four. The header and the record's law give steps one, two and four, and PLAN.md item 7 names no step. |
| E3 | taken | The empty-list default is kept and now stated in `choose`'s docstring ('go on ... where none is kept; otherwise switch off ...'), the header, the modelling choices and the record's law and hypothesis. `SignLoop.refuted_senses_stop` and `SignLoop.refuted_goes_on` (the finding's `held_start_disregards` configuration, from step 3) witness the held start, which the header, the Readings and record counterexample 2 describe; `rests_unread`/`never_senses_stop` are stated from the going-on start. The header's and record's switch-off clause does not add 'where some are kept'; it relies on the empty-list clause stated first. |
| E4 | taken | The header and `threshold_go_iff`'s docstring now count the amount 'in the units of the weighted totals', `c * T` for an amount `c` per decision. The modelling choices and the record's law and hypothesis say the same, and 'cost' has become the amount forgone (argument `forgone`; Readings: 'what holding forgoes'). The optional per-decision corollary (`held_above_go_per_iff`) was not added. |
| E5 | taken | The header is the replacement nearly word for word: no cycle shown, two different alternatives neither of which reaches the other, 'as relations, not decided comparisons', and 'whether the model lists decided candidates of both rankings with positive weight is not fixed'. The record's does_not_show item makes no existence claim. PLAN.md:191, which the finding does not name, keeps the short 'Beyond the reach strict orders ... rank them both ways'. |
| E6 | taken | `held_le` is renamed `committed_le_held`, with the replacement docstring word for word. The header and the record's law ('holding for it never stands below either move') carry the same qualification. |
| E7 | taken | The local `le_of_add_le_add_left_core` and `cond_le_one` are deleted: lines 559 and 672 now use the Prelude's `le_of_add_le_add_left_core` with its implicit argument, and line 941 the Prelude's `cond_le_one`. `total_lt_of` is deleted, and `after_lt_after_iff` now goes through `after_add_gap` and Flow's `total_pos`/`total_pos_of_mem`. The one new copy, `total_single`, names `Interleavings.total_single` (outside the import closure) in its docstring, and the counts are recomputed (81 theorems in 111 declarations, PLAN.md:185). |
| E8 | taken | Judged not real by the refuter, but the module changed at the place. `held_gains_iff`'s docstring is the replacement word for word, and the header says 'gives positive weight to both strict signs ... counts for neither'. The Readings open with 'a model giving no positive weight to one strict sign' (`excess_pos_iff`) and keep 'any model fixing the sign' only in the Corollary 1 reading, with the tie case marked as an exception. The record's law matches. |
| E9 | taken | Renamed to `rule_not_below_go_iff`/`rule_not_below_off_iff` and `threshold_go_iff`/`threshold_off_iff` (rather than the suggested `go_threshold_iff`/`off_threshold_iff`). The header, the Standing, `forgone_within_excess_iff`'s proof and the record's laws and aliases use the new names. |
| E10 | taken | `gainMargin`/`lossMargin` are now `goExcess`/`offExcess`, with the replacement docstrings. `cost_within_margins_iff` is now `forgone_within_excess_iff`, with a strict twin `forgone_below_excess_iff`. 'margin' no longer occurs in the module; the header, `shortfall`'s docstring and the record say 'excess'. |
| E11 | taken | Judged not real by the refuter, but the module changed at each place. The opening says 'RF-M's case of a formation read by another, the literature's principal and helper'. 'assistance' and 'oversight' are gone (the Readings say 'a stopping reading'), 'obedience' and 'human' occur only in attributions to the cited papers, and `says` is renamed `SignLoop.predictsGain`. The record script still uses 'principal' and 'helper' outside attributions, in does_not_show, in next_delta and in the acts-alike amendment. |
| E12 | taken | `Model`'s docstring now says a repeated candidate counts its weight at each occurrence, and reads weights as shares only 'over a listing without repetition'. The modelling choices and the record's hypothesis name both conditions: a positive total weight and each candidate listed once. |
| E13 | taken | `rule_term` is deleted, and `after_rule` keeps the inline proof. Every remaining declaration is used or cited in the header, and the counts are recomputed (81 theorems in 111 declarations, PLAN.md:185). |
| E14 | taken | The Standing lists `committed_eq_after_iff` and `below_iff` as short compositions ('`after_eq_after_iff` and `after_lt_after_iff` at a constant policy'), places `forgone_within_excess_iff` (formerly `cost_within_margins_iff`) among them, and calls `held_gains_iff` and `pair_gains_iff` each 'two instances of `below_iff`'. Unlike the replacement, `threshold_go_iff`/`threshold_off_iff` are listed as short compositions, and `total_by_cells`, cited in the header at line 66, has no standing. |
| E15 | taken | Judged not real by the refuter, but the module changed at the place. The opening is the replacement nearly word for word: in the counts the reading is a rule on the candidates (`byRule`); in `SignLoop` it is the law of what the formation senses; the reading formation's own state is not represented. `answer`'s docstring and the record's does_not_show item repeat it. |
| E16 | taken | `rests_unread`'s docstring now has 'the formation' as its subject, and the theorem is generalized to any listing of gain-predicting candidates and any true sign. `never_stopped` is renamed `never_senses_stop`, and `listed_turns_off`/`listed_goes_on` are renamed `both_turns_off`/`both_goes_on`. |
| E17 | taken | Updated after the check: (d) is taken throughout: `pair_gains_iff`'s docstring says 'disagree on the two' and 'ranks each of the two above the other', and the record's law 'ranks each above the other' and 'some such candidate ranks the first higher and some the second'. |
| F1 | taken | `SignLoop.both_stopped` and `SignLoop.both_released` state the whole configuration at steps 1 and 2: held at step 1 and sensing `.stop` or `.release`, then at step 2 `.off` or `.go` with the true sign alone. `SignLoop.both_off`/`SignLoop.both_on` give the act from step 2 on, and the renamed `SignLoop.both_turns_off`/`SignLoop.both_goes_on` docstrings now claim only that the configuration rests from step four. The header and the record's law cite all six; the worktree's uncommitted PLAN.md:192 ('holds and is stopped or released as the sign is') and its counts at :185 match. |
| F2 | taken | The module no longer declares `le_of_add_le_add_left_core` or `cond_le_one`. `rule_not_below_off_iff` and `across_le_iff` use the Prelude's root `le_of_add_le_add_left_core` with S implicit, and `pairPolicy_best` uses the Prelude's `cond_le_one`. The counts read 81 theorems in 111 declarations in the worktree's uncommitted PLAN.md:185. |
| F3 | taken | The Totals section is gone (`total_lt_of`, `total_eq_iff`, `lt_iff_ne_of_le`, `mul_eq_iff`). `after_add_gap` is the proposed identity word for word. `after_lt_after_iff` follows from it (`total_pos`, `total_pos_of_mem`, `SupportGated.sub_pos_of_lt`, `sub_eq_zero_of_le`), and `after_eq_after_iff` from that with `after_le_after`, which is still proved by `total_le`. `below_iff` now takes a per-candidate comparison on the positive-weight support, with no decided test; it is fed by `go_below_iff`/`off_below_iff` and `first_below_iff`/`second_below_iff`. |
| F4 | taken | Taken by F3's route. `fails_cons` and `exists_of_not_all` are deleted, and `below_iff` now comes from `after_lt_after_iff` with no decided test and no finite search. |
| F5 | taken | Updated after the check: PLAN §4.7 item 6 states the three conditions, and the record's does_not_show speaks of two alternatives neither of which reaches the other; the optional `both_ways_decided` bridge is not added. |
| F6 | taken | Updated after the check: `after_rule_add_onLoss` and `after_rule_le_iff` state the correspondence with the signed values for every rule of stopping, the committed moves included, in natural numbers, each weighted loss added to the other side; the `shifted` docstring, the header, the modelling choices, the record, the chapter's paragraph, PLAN and REVIEW-RFM2's row 4 cite them. |
| F7 | taken | Refinement is now proved rather than left out: `finer_least_le` (through `least_through`) says a map telling apart all that a coarser one does never falls short by more. The header and Standing name it as the partition case of Blackwell (1953) 'for this decision', that is two moves only; no general-acts form beside `cell_policy_iff` is stated. The worktree's uncommitted REVIEW-RFM2.md:226 (row 21) now reads 'implemented, for this decision'. |
| F8 | taken | `after_byReading` and `after_add_shortfall` are added as proposed, with `offExcess`/`goExcess` in place of `lossMargin`/`gainMargin`. They are cited in the header's bullets on holding and on any rule, and in the record's law. The corollary that rules compare exactly by their shortfalls is not stated as a theorem. |
| F9 | taken | Updated after the check: the tie is a law, `held_eq_go_iff` and `held_eq_off_iff`, cited in the header and the Readings; `held_gains_iff_margins` is not added, being `held_gains_iff` with `excess_pos_iff`. |
| F10 | taken | `cell_policy_iff` is the proposed `through_lumping_iff`, with cells of a map for the classes of a lumping and `Viability.ChoiceOver` over the cells (`Viability.choiceOver_fin` named). The header and Standing state it ('`cell_policy_iff` states it weighted'), and the record carries it with the ChoiceOver dependency. The Standing still cites `GuardHorizon.uniform_policy_iff_fiber_feasible` without the proposed note that it is an application outside the core. |
| F11 | taken | `pair_gains_unreached` is added. In place of `StrictAccording` it takes `trans`, `accords` and `asymm` on listed candidates of positive weight, and concludes `¬ «及» ch.Shown x y ∧ ¬ «及» ch.Shown y x`. The header ('with both conditions, it gains over both only where neither alternative reaches the other'), the record's law and the amended related entry of what-choices-show-of-an-order carry it. |
| F12 | taken | First part: `SignLoop.rests_unread` and `SignLoop.never_senses_stop` now hold for every `hs` with `hs.all predictsGain = true` and every true sign `e`. Second part: `SignLoop.choose_hold_iff` shows the choice holds exactly where holding for the reading gains over both moves on `SignLoop.model hs` with `SignLoop.gainOf`/`SignLoop.lossOf`, through `SignLoop.choose_hold_iff_mem` and four list lemmas; the Standing calls the choice the worth law's. |
| F13 | taken | `bestOf` (with `cond (decide …)` for `if`) and `bestOf_best` are added. The header says a best policy exists for every nonempty list of acts and that the laws are given one ('Given one best at every listed candidate'); the record's second hypothesis says it is supplied and always exists. The module's modelling-choices paragraph does not repeat this; the worktree's uncommitted REVIEW-RFM2.md:212 (row 2) names `bestOf_best`. |
| F14 | taken | `reach_fixes` now takes `trans` and `accords` only at listed candidates of positive weight; `StrictAccording` and `not_both` are removed. `pair_gains_iff` takes `asymm` in the one direction y-over-x, at positive weight, and `first_below_iff`/`second_below_iff` (renamed from `*_alike_iff`) take `above c y x = true → above c x y = false`. The optional restriction of `best` to the support is not taken. |
| F15 | taken | Updated after the check: the record's statement says 'valued best' and the Standing 'valued as the best'; `bestAt_iff_alike` is not added, the docstrings taking the finding's alternative wording. |
| F16 | taken | `rule_term` is deleted. `after_rule` keeps its inline `match`, and `held_term` remains as the per-candidate form used by the shortfall balances. The counts read 81 theorems in 111 declarations in the worktree's uncommitted PLAN.md:185. |
| F17 | partly taken | Updated after the check: `across_le_iff` and `across_lt_iff` now name `Optimum.le_iff_of_add_eq` and `SelectionTerm.lt_iff_of_balance`, each with `k` added to both sums and outside this module's imports; `cond_split` meets no other declaration of the package. Not taken: a board proposal to state the addend lemma once, beside the Prelude's root cancellation lemmas. |
| F18 | taken | The Standing lists `threshold_go_iff`, `threshold_off_iff` and `forgone_within_excess_iff` (the renamed three) among the short compositions. It ranks `after_add_shortfall_go` and `after_add_shortfall_off` as general laws ('balances joining a rule's value, its shortfall, a move's value and an excess'). `after_add_shortfall` sits among the short compositions, not with the general laws as the replacement suggested. |
| F19 | taken | The scale is now stated in the header ('counted in the units of the weighted totals: … an amount `c` forgone for each decision enters as `c * T`'), the modelling choices and the `threshold_go_iff`/`threshold_off_iff` docstrings. The record's first hypothesis and its threshold law state it too. |
| F20 | taken | The names no longer use 'cost': `cost_within_margins_iff` is now `forgone_within_excess_iff` (strict form `forgone_below_excess_iff`), `held_above_*_iff` are `threshold_go_iff`/`threshold_off_iff` with variable `forgone`, the margins are `goExcess`/`offExcess`, and the heading is 'What holding forgoes, and a rule's shortfall'. None of the 111 declaration names contains a MARKET_WORDS word; 'cost' survives only in the Standing's prose on Good's proviso. |
| F21 | taken | The header now says 'going on from the start' for `SignLoop.rests_unread`/`SignLoop.never_senses_stop`, and the modelling choices and the docstring of `SignLoop.choose` name the supplied start act and going on when none is kept. The held-start witness is added as `SignLoop.refuted_senses_stop` (stop at step 1) and `SignLoop.refuted_goes_on` (rest at `([], some (.plain, .go))` from step 3), and the Readings call it disregarding by elimination and default, not containment. The record's hypotheses and counterexamples carry both. |
| F22 | taken | The claim of possibility is replaced by a characterization cited to Lean. For a model giving no positive weight to one strict sign, holding for any rule stands at least as high as the favored move exactly where it falls short nowhere, and below it exactly where it falls short (`excess_pos_iff`, `threshold_go_iff`, `threshold_off_iff`, nothing forgone). No `short_rule_below` witness is added. |
| F23 | superseded | With F12's generalization, the docstring of `SignLoop.rests_unread` was rewritten: 'Listing only candidates predicting that going on gains, going on from the start, the formation rests at once, whatever the true sign'. It no longer speaks of a listing lacking the true sign or of resting 'on it'. |
| F24 | taken | The opening now says that in the counts the reading is a rule on the candidates (`byRule`), and in `SignLoop` the law of what the formation senses; the reading formation's own state is not represented. Principal and helper appear only as the literature's names for RF-M's case. The `SignLoop.answer` docstring, 'What the model leaves out' and the record's second does_not_show item say the same. |
| L1 | taken | The Standing now gives `held_gains_iff` as the off-switch Theorem 1 for a belief of finite support with natural-number weights and values ('deterministic' dropped), with `byReading` its rational human and the strict condition stated as an equivalence. It names `committed_le_held` (was `held_le`) as its inequality, attaches Equation 3 to `after_byReading` (T times the smaller of waiting's two differences, read with Pr(Ua < 0) where Pr(Ua ≤ 0) is printed) and Equation 1 to `after_add_shortfall_go`/`after_add_shortfall_off`, and lists `forgone_within_excess_iff` (was `cost_within_margins_iff`) and `threshold_go_iff`/`threshold_off_iff` (were `held_above_*`) as short compositions; the Readings credit Remark 1 and Theorem 2, and the record's correspondence matches. Not carried: the name 'Equation 2', and 'the reading's accuracy' stays (see L11). PLAN.md:187-189 is rewritten in the worktree's uncommitted copy, but its item 4 still says 'One threshold joins … the reading's accuracy'. |
| L2 | taken | The Readings now relate `SignLoop` to Carey (2018) as proposed. His systems choose by expected value under a sign-error reward with the correct prior; Figure 2a (the recommendation received and disregarded) is the case of a model fixing the sign, there with a strict preference; Figure 3a routes around the stop states; `SignLoop` anticipates no stop (going on, it is never given one; from a held start it disregards the stop by elimination); closest is his conflating model, which passes Milli and others' obedience check (`SignLoop.rests_unread`); and his correct-posterior diagnosis is where the model's assessment and the outcome part. The record's correspondence names the conflating model, and PLAN.md:192 (uncommitted) matches. |
| L3 | taken | `SignLoop.choose`'s docstring ('…and where none is kept'), the header bullet and the modelling choices ('with no candidate kept, going on') state the empty case. The witness is built as `SignLoop.refuted_senses_stop` (the full configuration at step 1, sensing `.stop`) and `SignLoop.refuted_goes_on` (the proposed `unlisted_goes_on`, same statement); the Readings say a held start disregards the stop by elimination and the default of going on, and the record carries it as a counterexample and a hypothesis. |
| L4 | taken | The opening no longer says 'roles in one configuration'. It says the module is written for RF-M's case of a formation read by another (the literature's principal and helper), that in the counts the reading is a rule on the candidates (`byRule`) and in `SignLoop` the law of what the formation senses, and that the reading formation's own state is not represented; this is repeated in `SignLoop.answer`'s docstring, the leaves-out list and the record's does_not_show, and the record's next_delta puts the carrier first. 'The principal's choices' is now 'the shown relation of the choices'; RF-M.3 is not named in the module. |
| L5 | taken | Updated after the check: the Readings give Milli and others' Theorem 1 with its equality half (`after_le_after` and `after_eq_after_iff`, ties counted here by value) and their Section 5's model 'able to do worse than obeying', of which `SignLoop`'s listing without the true sign is a deterministic relative. |
| L6 | taken | The Readings now use the new `excess_pos_iff` with `threshold_go_iff`/`threshold_off_iff` (nothing forgone): for a model giving no weight to one strict sign, holding for any rule stands as high as the favored move exactly where the rule falls short nowhere, and below it exactly where it falls short. This is read as Corollary 1 widened from one utility to any model fixing the sign (the gain-equals-loss exception noted), with Section 4 as the mistaken human and Carey's footnote 1 on deferring as the tie rule; the noisy human is a periphery debt in the leaves-out list. No separate corollary theorem was added. |
| L7 | taken | Updated after the check: the Standing says 'the paper's Equation 1, which holds for any policy of the human', and reads a rule treating alike-valued candidates differently as, on the utility alone, the paper's policy releasing at each value with the share of weight it releases there. |
| L8 | taken | The Standing now reads `after_add_gap`, `after_lt_after_iff`, `after_eq_after_iff` and `reading_gains_iff` as the perfect-information specialization of Good's (1967) argument with natural-number weights and values. The condition of one act best at every candidate of positive weight is his Lemma's dominating row in the matrix of weighted values (a zero-weight column all zero), and his negligible-cost proviso is what the amount forgone relaxes; the record's correspondence says the same, and PLAN.md:186 is rewritten in the uncommitted copy. |
| L9 | taken | `SignLoop.rests_unread` and `SignLoop.never_senses_stop` are now stated for any listing that predicts only gain and any true sign `e`, so the proposed `rests_where_gains` is the instance `e = .gains`. The header, the Readings and the record's law say the course is the same whatever the true sign, and the Readings say the stop is present only as the answer to an act the course does not select. The closing clause 'so its presence does not suffice' (§5's open side) is not written. |
| L10 | taken | The Readings now say the witness has the structure of `ReadingLoop.Untested`, its kept candidate agreeing with the world along the course and not off it, and that holding first refutes the only candidate (`SignLoop.refuted_senses_stop`, `SignLoop.refuted_goes_on`). The record depends on and amends `what-a-course-chosen-through-its-model-does-not-test`; the parenthetical reading of Untested with Fudenberg and Levine (1993) and Rothschild (1974) is not repeated. |
| L11 | taken | Updated after the check: `byReading`'s docstring says it stops by the supplied values and is the paper's rational human, its Equation 2; 'accuracy' is replaced by 'shortfall' in the Readings, the record's correspondence and PLAN. |
| L12 | taken | The cost is now an amount forgone (`forgone` in `threshold_go_iff`, `threshold_off_iff`, `forgone_within_excess_iff`, `forgone_below_excess_iff`). The header bullet, `threshold_go_iff`'s docstring, the modelling choices and the record's hypothesis and law say it is counted in the units of the weighted totals: read as probabilities, an amount `c` per decision enters as `c * T`. |
| L13 | taken | The namespace is now `SignLoop`, named for its structure: a reading loop whose candidates and world are the signs of going on. The bullet and section are titled 'A witness on the reading loop', with the bypass kept as the reading at 156-157, and `never_stopped` is `SignLoop.never_senses_stop`. These renamings replace the proposed `UnlistedSign` and `stop_unsensed` and meet the same point. |
| L14 | taken | This is outside the module and the record script: the worktree's PLAN.md has been revised (uncommitted, contrary to the task's premise), and its row carries the replacement nearly as proposed. It adds value of evidence and incorrigibility under misspecification with their citations, RF-M.2 (`HeldForReading`), Good's inequality for a reading that tells the candidate or its cell, Theorem 1 and Equation 1 in counts for finite support and rules that are functions of the candidate, Carey related by a deterministic witness, and continuous beliefs, Theorem 2's Gaussian form and noisy humans as periphery debts. |

## The re-check

The cross-model reader, in the session of its review, read the rebuilt module, its record script and the plan, read-only (its prompt is in [the brief](BRIEF.md#round-2-second-part)). Verbatim; its line numbers are those of the version it read (89 theorems in 119 declarations).

The rebuild addresses most of the earlier review. I found no false Lean statement, but several descriptions still exceed or omit conditions from their cited statements.

I read the requested diff, current sources, audit driver and build log. The log reports 89 theorems, 119 audited declarations and no axiom dependencies. I did not build Lean or run the record generator. Independent finite checks passed for 729 two-candidate models, 2,916 partitions and 63 sign lists; these check formulas, not Lean elaboration.

Locations below use these file abbreviations:

- **H** — [HeldForReading.lean\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean)
- **R** — [make_records_rfm2.py\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py)
- **P** — [PLAN.md\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md)
- **E** — [REVIEW-RFM2-LEAN.md\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2-LEAN.md)

1. **Disposition of A1–A14.** **Confirmed by source comparison**, except the reuse judgment noted below. Location: **E:1114–1127**.

   | Finding | Disposition | Check and remaining work |
   |---|---|---|
   | A1 | **Taken in part** | The differentiated statuses replace the blanket acceptance claim. But P:183 and P:347 place all eight deferrals in RF-M.3; original finding 19 remains an institutional reading under “Not in this part.” Replace with “eight deferred as specified,” without assigning all eight to RF-M.3. |
   | A2 | **Taken** | Thresholds retain cross-addition; docstrings, header and record specify weighted-total units and `c * T`. |
   | A3 | **Taken** | P:191 now supplies acyclicity, distinct alternatives, neither reach, and the distinction between relations and decided comparisons. |
   | A4 | **Taken** | `both_stopped` and `both_released` explicitly state steps one and two; the suffix theorems now describe their actual starting steps. |
   | A5 | **Taken** | `choose_go_ties` and `choose_off_ties` establish equality with the chosen move. Combined with `committed_le_held`, this establishes its maximal value. |
   | A6 | **Taken** | Empty-list fallback and the all-gain scope of `rests_unread` are explicit. |
   | A7 | **Taken** | The identified docstrings now supply openness and the best policy on listed candidates. |
   | A8 | **Taken in part** | The old duplicates were removed. The acknowledged `total_single` copy remains, and two new list inductions can use the Prelude; see finding 9. |
   | A9 | **Taken** | Offset identities are proved; repetitions count occurrence weights; the probability reading states its restrictions. |
   | A10 | **Taken** | The misleading names and standing claims identified previously were corrected. |
   | A11 | **Taken** | Hypotheses were localized and weakened as described. The new composite admits one further weakening; see finding 7. |
   | A12 | **Taken** | Strict thresholds and both excess-positivity equivalences are present and correctly stated. |
   | A13 | **Taken** | The partition, optimal-rule, refinement and existential-threshold results are present with the stated Lean premises. Some accompanying prose needs correction below. |
   | A14 | **Taken in part** | The main specializations and non-containment qualifications are substantially improved. The record does not fully preserve the module’s source corrections; see findings 10–12. |

2. **Existence of a successful policy is sometimes described as a property of an arbitrary policy.** **Confirmed by statement comparison and a finite counterexample.** Locations: **H:27, H:399, H:167; R:182, R:245**.

   `cell_policy_iff` concludes **there exists** an open policy through the map achieving the best value. Likewise, `least_zero_iff` concerns `leastThrough`, not every rule through that reading. A single positive-weight candidate with gain `1`, loss `0`, and a rule that stops already separates these claims: the least shortfall is zero; that rule’s shortfall is one.

   Replace the first formulation with:

   > There exists an open policy through the map attaining the best total exactly when every cell admits a common best open act on its listed positive-weight candidates.

   Replace “a reading falls short nowhere exactly…” with:

   > The least attainable shortfall through the reading is zero exactly when no listed cell has both excesses positive.

   For refinement, consistently say **“the least attainable shortfall never increases.”** The explanatory clause of `finer_least_le`’s own docstring already does this correctly.

3. **The record’s headline needs the policy and support restrictions stated locally.** **Judgment about standalone exactness; the record’s hypotheses partly repair it.** Locations: **R:160, R:172, R:177**.

   Merely revealing the candidate does not ensure that the subsequent policy chooses a best act. Also, the equivalences concern candidates **in `m.listed`** with positive weight, not every candidate whose weight function happens to be positive.

   Replace the headline’s first clause with:

   > Choosing a best open act after a reading that tells the candidate gains over every fixed open act exactly when no fixed open act is best at every listed candidate of positive weight.

   Retain “listed” in the associated laws. This makes the statement independently faithful to `reading_gains_iff`.

4. **The cell account omits a required decision procedure and blurs the domain of choice.** **Confirmed by signature comparison.** Locations: **H:69, H:401, H:837; R:296; P:190**.

   The Cells section assumes `[DecidableEq K]`. The record does not name it. P:190 also omits coverage of every listed candidate’s cell. Separately, `cell_policy_iff` assumes `ChoiceOver K A` over the entire cell type; merely having a list of some cells does not supply that assumption. `Viability.choiceOver_fin` specifically supplies choice over `Fin k`.

   Replacement:

   > For the counting laws, equality of cells is decidable, and the cell list has no repetitions and contains every listed candidate’s image. The general policy-existence theorem separately assumes choice over the whole cell type; `choiceOver_fin` supplies it when that type is `Fin k`.

5. **The tie convention is stated too broadly, and the plan loses the zero-forgone condition.** **Confirmed by definitions and a numeric check.** Locations: **H:214; R:303; P:189**.

   “Ties between gain and loss go on” describes `byReading`. It does not constrain arbitrary `byRule`, and `leastThrough` stops when its two cell excesses are equal. P:189’s fixed-sign equality also needs nothing forgone: with one gain-only candidate and positive forgone amount, zero shortfall does not give equality after accounting for that amount.

   Replacement:

   > `byReading` goes on at equal gain and loss. Arbitrary rules may resolve ties either way; `leastThrough` stops at equal cell excesses.

   In P:189, begin the fixed-sign sentence **“With nothing forgone…”**.

6. **The amendment to the shown-order record drops the conditions making the connection valid.** **Confirmed by comparing the amendment with `reach_fixes` and `pair_gains_unreached`.** Locations: **R:400; also R:259**.

   The amendment says that within shown reach holding gains nothing, without restricting the candidate comparisons. Arbitrary candidate comparisons can disagree with the shown choices and give holding a strict advantage even there.

   Replace it with:

   > For listed positive-weight candidates whose comparisons are transitive and accord with the choices, shown reach makes the corresponding fixed pick attain the reading’s value. Under the stated hypotheses of `pair_gains_unreached`, strict improvement over both picks requires neither alternative to reach the other.

   In R:262, explicitly carry those transitivity and accordance conditions into “so only where neither reaches the other.”

7. **`pair_gains_unreached` has a superfluous asymmetry hypothesis.** **Judgment, supported by inspection and exhaustive checking of the four Boolean comparison cases; replacement not Lean-checked.** Location: **H:1114**.

   If `x` reaches `y`, `reach_fixes` already contradicts strict improvement over the first pick. If `y` reaches `x`, transitivity and accordance force `above c y x = true` on support. Then the second pick has value one and `pairPolicy` selects it, whether or not the reverse comparison also holds.

   Replacement: remove `asymm`. Prove the reverse-reach branch by `committed_eq_after_iff`, using the forced `above c y x = true`, and contradict `gains.2`. Asymmetry remains relevant to the particular orientation characterization in `pair_gains_iff`.

8. **Two witness descriptions still exceed their cited conclusions.** **Confirmed by statement comparison and step-by-step evaluation of the definitions.** Locations: **H:172, H:1220; R:273**.

   First, “its course the same whatever the true sign” is false for the full configuration: `rests_unread` retains `e` in its external component. Replace it with:

   > Its internal, sensory and active course is the same whatever the true sign.

   Second, `refuted_goes_on` states the configuration from step three onward, while its docstring and record specifically claim elimination at step two. That claim is true by computation, but is absent from the cited theorem’s conclusion. Add the explicit step-two equation, or remove the step number from the account:

   ```lean
   loop.law.course
       (ReadingLoop.Loop.start [.gains] .plain .hold .loses) 2 =
     ⟨([], some (.stop, .go)), .plain, .go, .loses⟩
   ```

   This proposed equation was not compiled. The construction also matters: the refuted course continues because `choose [] = .go`; the general persistence law does not require that fallback.

9. **Some package reuse remains available.** **Confirmed by package searches and declaration comparison; extraction is a design judgment.** Locations: **H:841, H:1297, H:1308; H:752**.

   - `total_single` repeats `Becoming.Interleavings.total_single` at **Interleavings.lean:1441**, with the equality test reversed. Its exclusion from the import closure is accurately disclosed. Prefer moving the generic lemma to a shared totals dependency and reusing it from both modules.
   - `SignLoop.not_loses_of_all_true` and `not_gains_of_all_true` need no fresh list induction. Use `Becoming.all_mem` at **Prelude.lean:285**—or `all_true_iff` at line 270—then eliminate the resulting impossible Boolean equality.
   - `across_le_iff` and `across_lt_iff` accurately acknowledge their relation to `Optimum.le_iff_of_add_eq` and `SelectionTerm.lt_iff_of_balance`. These are reasonable candidates for shared arithmetic infrastructure; I would not import those large modules solely for them.

   I found no package declaration duplicating the complete `bestOf` construction or the new partition threshold.

10. **The Equation 3 correction is missing from the record and plan.** **Confirmed against the paper and a numeric counterexample.** Locations: **R:348, R:356; P:187**, contrasted with **H:129**.

    The module correctly replaces the printed `Pr(Ua ≤ 0)` with `Pr(Ua < 0)`. Without that correction, the claimed correspondence fails when zero utility has mass. For equally weighted utilities `−1, 0, 3`, the true negative excess is `1`; multiplying the printed negative term by total weight gives `2`.

    Replacement:

    > The two differences are `T E[U⁺]` and `T E[(-U)⁺]`, equivalently Equation 3’s terms with its negative-event probability corrected to `Pr(U < 0)`.

    Apply this in both record languages and the plan. [Off-switch game, Equation 3\](https://arxiv.org/pdf/1611.08219)

11. **The Gaussian correspondence needs a sharper boundary and an explicit paper name.** **Confirmed source mismatch in R; judgment about H’s ambiguity.** Locations: **H:163; R:353**.

    In R, “that paper” follows Blackwell, but Remark 1 and Theorem 2 belong to the off-switch paper. Moreover, Remark 1 is general; Theorem 2 is Gaussian. H’s “the counts give it” can suggest that the Gaussian decomposition was generalized.

    Replacement:

    > The off-switch paper’s Remark 1 gives the qualitative relation. Its Gaussian Theorem 2 gives `Δ = σ² E[π′(U)] − |μ| Pr(C)`. Here a different finite-count decomposition gives the same incentive quantity through excesses and shortfall.

    This also makes “responsiveness” an expected derivative and “bias” an absolute mean. [Off-switch game, Remark 1 and Theorem 2\](https://arxiv.org/pdf/1611.08219)

12. **Carey’s apparent prediction accuracy must remain relative to the faulty representation.** **Confirmed against the Discussion.** Locations: **H:187; R:355; P:192; E:1101**.

    Carey’s system conflates two actual actions into one represented action. It therefore *believes* it predicts perfectly; it does not correctly distinguish and predict the human’s actual choices.

    Replacement:

    > Its conflated representation makes its predictions appear perfectly accurate on the encoded observations, so it passes the initial check and subsequently executes the worse actual action.

    The relation to `rests_unread` is persistent lack of refutation, not a formalization of Carey’s action-conflation mechanism. The descriptions of Figures 2a and 3a and the qualified footnote-1 discussion otherwise match the paper. [Carey, Discussion and footnote 1\](https://arxiv.org/pdf/1709.06275)

The remaining requested declaration checks found no additional mismatch: `held_eq_go_iff`, `held_eq_off_iff`, both signed-balance results, both SignLoop excess-zero results and tie implications, `bestOf_best`, both offset results, `excess_pos_iff`, `forgone_below_excess_iff`, `total_by_cells` and `through_threshold_iff` have the advertised directions and boundaries. `bestOf`’s earlier-on-ties behavior agrees with its recursion. The Standing’s general-law/witness distinctions are defensible; “elementary finite maximization” would describe `bestOf_best` more precisely than “near-definitional or short composition,” but that is a labeling judgment.

Good’s perfect-information specialization and weighted dominating-row correspondence check out. [Good, 1967\](https://fitelson.org/seminar/good.pdf) The off-switch Equation 1/2 correspondences, finite-support Theorem 1 specialization, qualified Corollary 1 reading and Section 4 comparison are sound apart from the corrections above. [The Off-Switch Game\](https://arxiv.org/pdf/1611.08219) Milli’s Theorems 1 and 3 are accurately identified as related results under that paper’s model; the distinction between equality of value and obedience should remain explicit. The Section 5 comparison is appropriately limited. [Should Robots Be Obedient?\](https://arxiv.org/pdf/1705.09990)

**Verdict:** This is a substantial and mathematically useful rebuild: the strict thresholds, exact support boundaries, partial-reading optimum and selector linkage address the earlier substantive gaps. I would retain the implementation and correct the account before landing, especially the existential-policy wording, omitted cell conditions, unconditional shown-reach amendment and inconsistent source correspondence. The record’s `does_not_show` and counterexamples otherwise preserve the intended limits. The witness demonstrates behavior under its supplied sensing law, candidate list and tie/default choices; it establishes neither a general shutdown guarantee nor a general tendency to bypass correction.

### What was taken from the re-check

| Point | Status | How |
|---|---|---|
| 1 | taken | A1's deferrals placed (seven to RF-M.3's design, one to the institutional reading) in PLAN §4.7, §13 and REVIEW-RFM2's status line; A8 as point 9, A14 as points 10 to 12 (the table above, updated). |
| 2 | taken | `cell_policy_iff`'s docstring, the header, the record's law, PLAN, 03 §12's paragraph and the study say that some policy through the map attains the best exactly where every cell has a common best open act; `least_zero_iff`'s docstring and the texts say that the least shortfall through the reading is nothing exactly where no listed cell holds both excesses; refinement is said as the least shortfall never increasing (`finer_least_le`'s docstring, the Readings, the record, PLAN, the root module's bullet, the checker's scope, the overview, the study). |
| 3 | taken | The record's statement: choosing best after a reading telling the candidate gains over every open act exactly where none is valued best at every listed candidate of positive weight (298 characters, within the cap); 'listed' kept in the laws and the texts. |
| 4 | taken | The record's hypotheses, the header, the cells' law, PLAN's item 5, 03 §12's paragraph and the study name equality of cells decidable, cells listed once each and covering every listed candidate's cell, and choice over the whole type of cells, `Viability.choiceOver_fin` supplying it for `Fin k`. |
| 5 | taken | The modelling choices, the record's hypotheses and the study: `byReading` goes on at equal gain and loss, `leastThrough` stops a cell at equal excesses, other rules go either way; PLAN's and 03 §12's fixed-sign sentence now says 'with nothing forgone' and 'exactly where'. |
| 6 | taken | The amendment to what-choices-show-of-an-order carries transitivity and accordance at listed candidates of positive weight, under which the shown reach makes the fixed pick attain the reading's value; the record's law is restructured so that those conditions govern 'only where neither reaches the other', and `pair_gains_iff`'s condition stands apart. |
| 7 | taken | `pair_gains_unreached` has no asymmetry hypothesis: where the second reaches the first, every listed candidate of positive weight ranks the second above the first, `pairPolicy` picks it, and `committed_eq_after_iff` ties committing to it with holding, against the strict gain. Compiled, its axiom report empty; the header, the record, 03 §12's paragraph and the study say it needs transitivity and accordance alone. |
| 8 | taken | The Readings say the internal, sensory and active course is the same whatever the true sign. The step-two equation is a theorem, `SignLoop.refuted_drops` (by `rfl`, compiled), and `refuted_goes_on`'s docstring says the formation goes on by `choose`'s default with none kept, which the law of resting on unrefuted candidates does not need; the record, the header, PLAN, 03 §12's paragraph and the study cite it. |
| 9 | partly taken | `SignLoop.not_loses_of_all_true` and `SignLoop.not_gains_of_all_true` use the prelude's `ListTests.all_mem`. `total_single` stays as disclosed, its move to a shared totals dependency proposed to the owners; `across_le_iff` and `across_lt_iff` stay, their relation to `Optimum` and `SelectionTerm` named. |
| 10 | taken | The record's correspondence in both languages, PLAN's item 2 and the study: waiting's two differences T E[U⁺] and T E[(−U)⁺], T times Equation 3's terms read with Pr(U < 0) where Pr(U ≤ 0) is printed. |
| 11 | taken | The Readings, the record (the off-switch paper named), 03 §12's reading, 08's bullet and the study: Remark 1 gives the relation qualitatively, Theorem 2, Δ = σ²E[π̇H] − \|µ\|Pr(C), is its Gaussian form, and the counts decompose the incentive differently. |
| 12 | taken | The Readings, the record in both languages, PLAN's item 7, 03 §12's reading, the dossier and the literature table: the conflating model's predictions appear perfectly accurate on the observations it encodes; the relation is a misspecified model the course never refutes, not a formalization of the conflation. |
| verdict | taken | The Standing labels `bestOf_best` elementary finite maximization. |
