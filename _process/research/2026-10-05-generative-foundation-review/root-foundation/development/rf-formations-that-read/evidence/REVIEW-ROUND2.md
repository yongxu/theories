# RF round 2: the review of the Lean, and what was taken

30 October 2026. AI-authored evidence for board item RF, round 2 ([plan](../PLAN.md), §4.6). The modules were reviewed in the kit, before they joined the package, by an independent cross-model reviewer (GPT astra, high effort, read-only, run through the `cx` command), with the brief kept beside round 1's ([BRIEF](BRIEF.md#round-2)). It read `Becoming.ReadingLoop` as first written (32 theorems), then re-checked the rewrite (51 theorems) and reviewed `Becoming.ReflexivePrediction` and `Becoming.OpenedCorrection`. The two passes are kept verbatim below, with the worktree's absolute links made repository-relative; line numbers refer to the versions read, and a link's `:line` is kept in its label. The table at the end says what was taken.

## The review of `Becoming.ReadingLoop`

**Verdict: revise before landing. I found no invalid proof among the 32 theorem bodies on source inspection, but RF3 remains incomplete against the plan, several summaries overstate their statements, and `worst` has an unstated bound. I did not build Lean or modify files.**

1. **[High] RF3 permits successful “keeping” by deadlock.**  
   Location: [ReadingLoop.lean:132](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean), definitions and theorems through line 181.

   **Quoted:** “An act good for a state's reading of a task `K`”; “A policy keeping the task exists exactly where each state has an act good for its reading”.

   **Problem:** `Good` universally constrains successors without requiring any successor. Take inhabited singleton types, `B := True`, `world := False`, and `K := False`: `KeptBy`, `Good`, and `Keeps` all hold. Thus `keeping_policy_iff` is correct for its definitions but does not supply the enabled-action requirement in [PLAN.md:145](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md).

   Also, `«及»` contains only positive-length reaches. `Keeps` does not require `K` at the starting configuration.

   **Replacement:** Retain the existing result as *successor safety*. For the planned regulation result, use:
   ```lean
   GoodEnabled world B K m a :=
     ∀ w, B m w →
       (∃ w', world w a w') ∧
       ∀ w', world w a w' → K w'
   ```
   Pair `Keeps` with enabledness at every sound configuration. Add `∀ m w, B m w → K w` when “keeps” includes the initial configuration. These are proposed statements, not checked additions.

2. **[High] `keeping_policy_iff` is a valid conditional feasibility criterion, but not the promised replacement for the false model sandwich.**  
   Location: [ReadingLoop.lean:172](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean).

   **Quoted:** “A policy keeping the task exists exactly where each state has an act good for its reading”.

   **Problem:** The theorem fixes arbitrary `M`, `B`, and `update`, assumes `KeptBy`, and selects an action for every `m`. It neither constructs an accessible reading nor connects accessible histories to task-relative futures. Those are explicitly promised in [PLAN.md:146](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md). Demonstrating `nothing_kept` does not exclude that vacuity from the existence theorem.

   The condition is therefore the right one for **a supplied invariant reading and the present safety definition**. It is not an existence condition for an informative, realizable model.

   **Replacement:** State:
   > Given a supplied reading preserved under every action, policy existence reduces to a common safe action for each reading. Accessibility, nonvacuity, and task-relative predictive adequacy remain separate obligations.

   Next, instantiate `GuardHorizon.uniform_policy_iff_fiber_feasible` on admissible histories with their actual accessible reading and enabled, acceptable actions. If exact future prediction is required, separately require the task’s future feature to agree on accessible-history classes. Do not restore the false sandwich. Nonempty sound starts should be explicit; a full reading should be rejected only where the task actually requires a distinction.

3. **[Medium] The faithfulness assumption prevents the general retention law from covering this module’s own two-world witness.**  
   Location: [ReadingLoop.lean:374](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean), also line 402.

   **Quoted:** “A candidate the world answers as is never dropped”.

   **Problem:** `faithful_kept` and `fitting_closed` require:
   ```lean
   ∀ s a e, L.answer s a e = L.predict h s a
   ```
   That makes one candidate correct at **every external state**. Neither `.up` nor `.down` satisfies it for `Untested.loop`: their predictions differ on `.untried`. The witnesses establish retention by separate calculations, not by this general result.

   This is a substantive integration gap: the natural meaning of “the true candidate in this world” is correctness on the actual invariant external region.

   **Replacement:** Add a region `Q : E → Prop`, initial membership in `Q`, preservation of `Q` by `move`, and faithfulness only when `Q e`. Prove retention and closure of:
   ```lean
   fun x => L.Fitting h x ∧ Q x.external
   ```
   Then instantiate with `Q e := e = .up` and `Q e := e = .down`. Also give the representation connecting this loop invariant to RF3’s joint carrier.

4. **[Medium] General self-confirmation and model/order ambiguity laws are still missing.**  
   Location: [ReadingLoop.lean:490](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean), and lines 634–645.

   **Quoted:** “A model its course never refutes”; “A model that does not separate and an order that does not rank act alike”.

   **Problem:** `rests` and `model_or_order` quantify over time, but fix the candidate lists, rankings, initial sensory/active values, and world. They establish a valid observational-ambiguity witness: this one action-and-sensory trace does not identify which of those two explanations produced it. They do not establish a universal equivalence between uncertainty and a different order.

   **Replacement:** Describe `model_or_order` as:
   > Two specified model/order pairs have the same observable course in world `up`.

   The next general laws should be:

   - A fixed-course retention result from `answer s a e = s`, `move s a e = e`, `choose hs s = a`, and agreement of every listed candidate with that answer.
   - A relation between two formations’ internal states that preserves equal selected acts and remains invariant after equal observations, implying equal observable courses.

   The first subsumes `rests`; the second makes `model_or_order` an instance. Compared with `LumpedSeeking.seek_tied`, the useful distinction here is **agreement on the selected course despite an available distinguishing action**, rather than agreement under every experiment.

5. **[Medium] RF-M has a working finite witness, but later cases need explicit state and intervention interfaces.**  
   Location: [ReadingLoop.lean:316](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean), and lines 73–78.

   **Quoted:** “The act chosen from the candidates kept and the value sensed”; “a formation's revising its own order” is left out.

   **Problem:** Prediction, selection, elimination, and action-dependent answers are connected. However, the only evolving internal data are a shrinking candidate list and one pending observation/action pair. Selection is the fixed function `choose hs s`. Consequently, a separate internal order cannot change the choice while `hs` and `s` remain unchanged. The concrete `move` is identity, so the witness changes observations but not the external world.

   **Replacement:** Mark RF-M’s core as partial, and prioritize these extensions after findings 1–4:

   **RF6.1:** Represent the reading rule as revisable state; prove an actual reachable revision, feasibility before/after, and executable correction under a fixed comparison.

   **Assistance and preference change:** Represent helper actions, the principal’s order, and the helper’s candidates about that order. Replace the singleton initialization with an intervention occurring inside the joint law. Show an action that changes an external or principal state.

   **RF6.3:** Represent publication, receipt, and response timing, then prove the supplied fixed-point-free counter-response result.

   **RF7:** Represent disclosure/concealment alternatives, retention consequences, and continuation values. Probabilities require the acknowledged extension.

   Arbitrary `S` and `E` can encode auxiliary machinery, so these are missing represented mechanisms, not impossibility claims about `Blanketed`.

6. **[Medium] `worst` is capped at 3, so its claimed general maxmin meaning is false.**  
   Location: [ReadingLoop.lean:468](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean).

   **Quoted:** “The worst rank the candidates kept predict for an act; with none kept, above every value.”

   **Problem:** The type accepts arbitrary `r : Value → Nat`, but the empty-list value `3` participates in every minimum. With `r .mid = 4`, `r .high = 5`, and candidates `[.up]`, both scores become `3`; `byWorst` chooses `.known` although `.untried` has the strictly higher worst rank. The existing `rank` and `rank'` witnesses remain unaffected.

   **Replacement:** Use a genuine minimum on nonempty lists, with an explicitly separate empty-list convention; alternatively restrict ranks to `Fin 3` or require `∀ v, r v < 3`. Prove the selected action maximizes the actual minimum.

7. **[Medium] The header counts an answer as incorporated one step too early.**  
   Location: [ReadingLoop.lean:33](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean), also lines 350–356.

   **Quoted:** “After `n + 1` steps a candidate is kept exactly where it was listed and fits every answer the course received”.

   **Problem:** `kept_iff` tests transitions `k < n`. At configuration `n + 1`, the sensory answer from transition `n` has arrived but has not yet been incorporated into `internal.1`. For example, the explorer has sensed the distinguishing answer at step 1 while its internal list still contains both candidates.

   **Replacement:**
   > At configuration `n + 1`, the internal candidate list contains exactly the initially listed candidates fitting transitions `0` through `n − 1`. The latest sensory answer is incorporated on the next synchronous step.

   Use the same qualification in the theorem’s bold introductory sentence.

8. **[Medium] The closed region is membership plus pending-answer consistency, not membership alone.**  
   Location: [ReadingLoop.lean:400](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean), also header lines 36–37.

   **Quoted:** “The reading that `h` is kept is a closed region”.

   **Problem:** The actual predicate is `Fitting h`: membership **and** agreement with the pending answer. Membership alone is not closed on arbitrary configurations, even under global faithfulness: an inconsistent stored previous observation/action can cause the next filter to remove `h`.

   **Replacement:**
   > The region where `h` is listed and agrees with the pending answer is closed when every world answer agrees with `h`.

   Keep `Fitting`; correct its description.

9. **[Medium] `kept_alike` loses its initial-membership hypothesis in both summaries.**  
   Location: [ReadingLoop.lean:381](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean), also lines 37–39.

   **Quoted:** “Candidates predicting alike along the course are kept alike”.

   **Problem:** The theorem additionally requires:
   ```lean
   listed : h₁ ∈ hs ↔ h₂ ∈ hs
   ```
   Equal predictions cannot make an initially absent candidate appear.

   **Replacement:**
   > Candidates with the same initial membership status, predicting alike on transitions before `n`, have the same membership status at configuration `n + 1`.

   This is a conditional corollary of `kept_iff`, not an unconditional property of observational equivalence.

10. **[Medium] The universal floor summary drops the initial non-high assumption.**  
    Location: [ReadingLoop.lean:47](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean).

    **Quoted:** “Every formation keeping the floor … never senses high in the first (`Untested.floor_forgoes`…)”.

    **Problem:** `floor_forgoes` proves sensory agreement and the known action in the `down` course. The separate `floor_never_high` requires `start : s ≠ .high`. A common initial sensory value `.high`, followed by known actions and `.mid` forever, satisfies the floor premise while falsifying the quoted “never”.

    **Replacement:**
    > Such formations have equal sensory courses and take the known action in both worlds. They sense the middle value after the start; if the common initial value is not high, they never sense high (`floor_never_high`).

    Equality of the two active courses follows through `agent_through_sensory`.

11. **[Medium] `alike_of_kept` is appropriately general for its stated setting, but its prose omits decidability and its scope needs naming.**  
    Location: [ReadingLoop.lean:280](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean), and header lines 25–30, 64–66.

    **Quoted:** “Where every answer telling two worlds apart breaks a task in the second, keeping the task there is never telling them apart.”

    **Problem:** The theorem requires `[DecidableEq S]`, common internal/sensory/active starts, a sensory predicate `K : S → Prop`, and the separation condition for every `k s a` at the two actual external trajectories. These are stronger and more specific than a general safe-learning claim. Its conclusion is genuinely unbounded: it quantifies over every `n`, so “never” itself is justified.

    `floor_forgoes` is a fair instance: its `reply` and constant-world hypotheses establish precisely the required separation condition.

    **Replacement:** Include those hypotheses in the summary. For reuse, add a finite-horizon version and a version imposing separation only on synchronized reachable pairs. State whole-configuration safety separately if needed.

    Cite safe exploration as related work, not as a theorem contained here. [Sui et al. 2015](https://proceedings.mlr.press/v37/sui15.pdf) and [Turchetta, Berkenkamp and Krause 2016](https://papers.nips.cc/paper_files/paper/2016/file/9a49a25d845a483fae4be7e341368e36-Paper.pdf) provide positive exploration guarantees under regularity, uncertainty, and reachability assumptions. This module supplies a deterministic two-run obstruction when distinguishing answers are unsafe.

12. **[Low] “Once” is stronger than `explorer_low_once`’s statement.**  
    Location: [ReadingLoop.lean:544](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean).

    **Quoted:** “Trying costs the floor once”.

    **Problem:** The theorem proves only that the sensory value at time 1 is low. `explorer_down` covers times from 3 onward; neither statement covers time 2 when establishing uniqueness. The stronger assertion agrees with the definitions, but is not this theorem’s statement.

    **Replacement:** Either say “The first answer is low” and rename accordingly, or prove:
    ```lean
    ∀ n, (course ... n).sensory = .low ↔ n = 1
    ```

13. **[Low] Two phrases misstate the order result.**  
    Location: [ReadingLoop.lean:51](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean), repeated at lines 595 and 634; also lines 56–57.

    **Quoted:** “an order that does not rank”; “that occasion fixes only what it shows”.

    **Problem:** `rank'` does rank all three values; it ranks `.mid` above `.high`. The name suggests absent or incomplete ranking where the formal difference is reversed ranking.

    The cited `above_in_every_iff_reach` concerns **positive comparisons shared by all strict according orders**, assuming acyclicity, and uses transitive reach. It does not characterize everything a training fixes, nor only its directly displayed comparisons.

    **Replacement:**
    > An unresolved candidate set and a reversed ranking can produce the same observable course.

    And:
    > Both rankings fit the displayed middle-over-low comparison while reversing high versus middle. Generally, under acyclicity, the positive comparisons shared by all strict according orders are exactly the shown relation’s transitive reach.

14. **[Medium] The self-confirmation and maxmin citations need separate correspondence statements.**  
    Location: [ReadingLoop.lean:61](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean).

    **Quoted:** “Self-confirming equilibrium and incomplete learning, in deterministic form … under maxmin choice”.

    **Problem:** The three works support different parts of this reading.

    [Fudenberg and Levine 1993](https://economics.mit.edu/sites/default/files/inline-files/sce.pdf) require best responses to beliefs and correctness along the equilibrium path in a game. The witness captures persistent on-course agreement and off-course disagreement, but contains neither their game equilibrium structure nor their equilibrium comparisons.

    [Rothschild 1974](https://paperzz.com/doc/7247026/a-two-armed-bandit-theory-of-market-pricing) studies Bayesian experimentation with discounted future returns and proves that optimal behavior can persistently select an inferior alternative. Here persistence follows from a fixed one-step worst-case selector. No value-of-information or optimal experimentation result is proved.

    [Gilboa and Schmeidler 1989](https://itzhakgilboa.weebly.com/uploads/8/3/6/3/8363317/gilboa_schmeidler_mmeu.pdf) establish a representation theorem for preferences using minimum expected utility over a set of priors. With nonempty candidates and correct minima, the witness’s criterion corresponds numerically to the special case allowing every probability distribution supported on those candidates. Their axiomatization and updating theory are not represented.

    **Replacement:**
    > A deterministic witness of persistent on-course agreement, related to self-confirming equilibrium and incomplete learning. Choice uses a specified one-step worst-case criterion. The cited equilibrium, experimentation, and preference-representation theorems are not reproduced.

15. **[Medium] The IRL attribution and universal assistance conclusion exceed the witness.**  
    Location: [ReadingLoop.lean:66](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean).

    **Quoted:** “is the identification limit of inverse reinforcement learning with the beliefs free”; “coupling turns only a formation whose model was what held it”.

    **Problem:** [Armstrong and Mindermann 2018](https://arxiv.org/abs/1712.05812) establish ambiguity in decomposing a policy into a planner and reward, including limitations of simplicity priors. This is broader than two model/order pairs agreeing on one course.

    [Reddy, Dragan and Levine 2018](https://proceedings.neurips.cc/paper_files/paper/2018/file/6f2268bd1d3d3ebaabb04d6b5d099425-Paper.pdf) develop inference of internal dynamics from behavior on tasks with known rewards, then use it for intent inference and assistance. They are relevant to model misspecification; they are not interchangeable evidence for the stated unrestricted identification theorem.

    Moreover, `informed_turns` changes the initial candidate list. No helper, added observation channel, or in-law informing intervention exists. The modelling paragraph acknowledges this, but the preceding universal conclusion remains too strong.

    **Replacement:**
    > This witness shows that one observed course can leave uncertainty and a different ranking indistinguishable. Initializing with the true candidate changes the first specified formation’s course and leaves the second’s course unchanged. It illustrates model/preference ambiguity and model-sensitive assistance; no general assistance theorem is established.

16. **[Medium] The good-regulator label needs the missing citations and narrower correspondence.**  
    Location: [ReadingLoop.lean:15](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean), and line 143.

    **Quoted:** “requisite variety and the good regulator's adequacy along the loop”.

    **Problem:** [Conant and Ashby 1970](https://pespmc1.vub.ac.be/books/Conant_Ashby.pdf) concern simplest optimal regulation, with an entropy criterion and a mapping between system and regulator events. None of that optimization or model-necessity conclusion is proved here.

    [Virgo, Biehl, Baltieri and Capucci 2025](https://arxiv.org/html/2508.06326v1) are the closer source: their Lemma 3.2 connects forward closure with consistent possibilistic belief updating under the selected policy; their regulation definition requires a nonempty invariant region contained in the good set. Here `KeptBy` instead requires preservation under **every action**, while nonemptiness and initial task satisfaction are absent.

    **Replacement:**
    > An invariant-reading safety composition, related to possibilistic belief interpretations of regulation. Policy existence uses common-action feasibility and explicit choice. It does not establish optimal-regulator model necessity.

    Cite both works and distinguish policy-relative closure from the stronger all-action `KeptBy`.

17. **[Low — substance assessment] Separate inherited structure, general content, and witnesses.**  
    Location: [ReadingLoop.lean:11](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean).

    **Quoted:** “RF3 and the core of RF-M”.

    **Problem:** This label needs a standing paragraph explaining both the partial completion and the substance of the 32 theorems.

    **Replacement standing assessment:**

    **Near-definitional or short inherited compositions:** `kept_iff_closed`, `closed_of_keptBy`, `good_of_keeps`, `keeps_iff_good`, `keeping_policy_iff`; `everything_kept`, `everything_good_iff`, `nothing_kept`, `nothing_good`, `nothing_sound`; and the retention corollaries `faithful_kept`, `kept_alike`. `keeping_policy_iff` is useful composition, but its choice/fiber argument is already present in `GuardHorizon`.

    **General mathematical content:** `keeps_of_good` supplies the invariant-to-reach induction; `sensed_alike_iff` accounts for feedback between sensing and action; `alike_of_kept` gives the safety/identification obstruction; `Loop.kept_iff` connects elimination to the endogenous course; `fitting_closed` supplies a configuration invariant. These are the module’s general laws, without implying mathematical novelty.

    **Witnesses and their consequences:** `PairwiseShared.two_share` and `none_for_all` correctly exhibit the common-intersection obstruction. `rests`, `alike_in_both`, `never_high`, `explorer_up`, `explorer_down`, `explorer_low_once`, `both_accord`, `apart_beyond`, `order_rests`, `model_or_order`, and `informed_turns` establish the finite examples. `floor_forgoes` is stronger than a fixed-controller witness because it quantifies over arbitrary internal mechanisms; it specializes `alike_of_kept`. `floor_never_high` is its consequence with the additional initial-value hypothesis.

    RF3 therefore has its closure and conditional safety composition, with enabledness and accessibility unfinished. RF-M has a concrete coupled learning-and-choice example; its planned assistance, preference-change, and institutional-revision cases remain unrepresented.


## The re-check, with the review of two further modules

**Verdict: ReadingLoop is substantially corrected; ReflexivePrediction meets RF6.3’s mathematical target; OpenedCorrection still falls short of RF6.1’s executable revision requirement. No proof error found on source inspection. I did not modify files or run Lean.**

Original findings, with numbering preserved; locations below refer to [ReadingLoop.lean](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean).

1. **Taken correctly** — lines 177–249 add enabledness and continuation; lines 183–184 explicitly exclude initial task satisfaction.
2. **Partly** — lines 318–422 construct the canonical history reading and prove fixed-policy adequacy; the plan’s policy-existence/future-equivalence result and explicit nonvacuity requirement remain outstanding.
3. **Partly** — lines 606–660 and 814–818 correctly add regional faithfulness and instantiate it; an explicit representation connecting `Loop.law` to the earlier `joint` carrier is still absent.
4. **Taken correctly** — `rests_of_unrefuted` and `observed_alike` supply general statements, and the witnesses use them.
5. **Taken correctly as a scope correction** — lines 90–92 and 113–118 explicitly defer assistance, mutable preferences, institutional revision, and disclosure mechanisms.
6. **Taken correctly** — lines 752–792 implement an actual nonempty minimum, prove its bounds and attainment, and separate the empty-list convention.
7. **Taken correctly** — lines 49–50 and 579–586 state the incorporation delay accurately.
8. **Taken correctly** — lines 631–640 identify membership, pending-answer consistency, and the external invariant region.
9. **Taken correctly** — lines 54–55 and 616–625 retain the initial-membership condition.
10. **Taken correctly** — lines 70–71 retain the non-high start condition and cite `floor_never_high`.
11. **Taken correctly** — `alike_within` supplies the horizon and restricted response comparisons; decidability, shared starts, and sensory safety are explicit.
12. **Taken correctly** — lines 865–877 prove that low occurs exactly at step one.
13. **Taken correctly** — the reversed-ranking wording and the acyclic, positive-comparison, transitive-reach qualification are accurate.
14. **Taken correctly** — lines 98–102 distinguish the deterministic example from the cited equilibrium, experimentation, and representation theorems.
15. **Taken correctly** — lines 106–111 distinguish planner/reward ambiguity from dynamics inference and disclaim a general assistance theorem.
16. **Taken correctly** — lines 94–98 cite both regulator sources and distinguish policy-relative closure, all-action closure, and model necessity.
17. **Taken correctly** — lines 83–92 distinguish short compositions, general laws, witnesses, and unfinished RF-M cases.

18. **[Medium — new ReadingLoop problem] Exact history compatibility is overstated as a uniquely necessary reading.**  
    Location: [ReadingLoop.lean:35](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean).

    **Quoted:** “the reading the formation must be adequate to is the one its own history carries, no finer and no coarser.”

    **Problem:** `possible_least` establishes minimality among readings preserved by recording and containing the starts. `history_keeps_iff` and `history_continues_iff` characterize a fixed policy using actual history-compatible worlds. Neither establishes that a controller must represent exactly `Possible`, nor that a coarser reading cannot suffice for the task.

    For example, with a nonempty start set, total dynamics, and `K := True`, a constant policy can satisfy both requirements without distinguishing any histories. More generally, additional worlds admitted by a coarser reading may require the same action.

    **Replacement:**
    > `Possible` gives exactly the worlds compatible with the recorded history and supplied starts. The policy must be safe and enabled at each of them. A coarser reading can suffice when its additional worlds impose compatible action requirements.

    Keep the new history laws; remove the uniqueness claim. The distinction between fixed-policy verification and policy synthesis should also remain explicit.

19. **[High — OpenedCorrection] `Opens` omits the reachable revision required by RF6.1.**  
    Location: [OpenedCorrection.lean:18](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/OpenedCorrection.lean), definition at line 60.

    **Quoted:** “A revision opens a correction”; “Whether the revision and the correction are executable is a further question”.

    **Problem:** `Opens` contains two static policy-existence propositions. It contains no revision state, transition, trace, cost, or connection between `fit` and a process. The `Reports` example likewise supplies two observation maps but no transition between them.

    Importing `Revision` and citing its examples does not perform the composition expressly required by [PLAN.md:148](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md). `Revising.opens_with_correction` concerns a distinguishing link and an enabled `.correct`; it does not establish this module’s `UniformPolicy` condition.

    **Replacement:** Call the current predicate **static policy opening**. Add a result on one revision process containing:

    - a reachable transition or trace from the old apparatus state to the new;
    - absence of an admissible uniform policy before it;
    - existence afterward for `acceptable ∧ executable`;
    - unchanged acceptability, with executability evaluated at the appropriate apparatus/resource state.

    Instantiate that result on the stock-and-link process. Until then, report RF6.1 as partial. The present eight theorems are short compositions and a renamed two-configuration feasibility witness; the missing result is the dynamic composition.

20. **[Medium — OpenedCorrection] Policy existence is repeatedly described as selection or enactment.**  
    Location: [OpenedCorrection.lean:52](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/OpenedCorrection.lean), also lines 18–19, 58–64, 119–138.

    **Quoted:** “a correction is chosen”; “none is chosen through the old reading, one is through the new”.

    **Problem:** `UniformPolicy read fit` means that a fitting policy **exists**. Its negation says no policy fits every configuration. Neither proposition describes what a formation actually chooses. In particular, `count_chooses_none` does not prevent choosing a repair; it prevents choosing one that fits both faults through the count.

    **Replacement:**
    > A fitting policy exists through a reading exactly where its fibers satisfy the common-action condition, given choice.

    Use “no fitting uniform policy exists” and “a fitting uniform policy exists” throughout. Suitable names are `policy_iff`, `count_has_no_policy`, and `line_has_policy`. Actual selection needs a supplied controller and a statement about its action or run.

21. **[Medium — OpenedCorrection] Non-factorization does not establish a distinguishing pair.**  
    Location: [OpenedCorrection.lean:78](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/OpenedCorrection.lean), also lines 20–21.

    **Quoted:** “an opening needs the new reading to tell apart what the old read alike.”

    **Problem:** `coarser_opens_nothing` assumes a supplied function `forget : O → O'`. Its contrapositive excludes such a factorization. It does not construct:
    ```lean
    ∃ s t, old s = old t ∧ new s ≠ new t
    ```

    The unrestricted types even admit a direct boundary counterexample: take `S = Empty`, `A = Empty`, `O = Unit`, and `O' = Empty`. A policy through `new` exists vacuously; one through `old` cannot exist. Thus `Opens` holds despite there being no configurations to distinguish. This exposes the total-policy codomain requirement, not an informational gain.

    **Replacement:**
    > If the new reading factors through the old by the supplied `forget` map, it cannot create a fitting uniform policy for the same predicate.

    If a distinguishing-pair conclusion is wanted, formulate it separately with appropriate nonvacuity, factorization, and constructive extraction assumptions. Using inhabited finite configuration types and observation images would remove the displayed empty-domain artifact.

22. **[Medium — OpenedCorrection] `widened_opens` neither proves an opening nor preserves executability.**  
    Location: [OpenedCorrection.lean:84](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/OpenedCorrection.lean).

    **Quoted:** “Widening what counts as acceptable to everything opens a correction through every reading”.

    **Problem:** The conclusion is only `UniformPolicy read True`. There is no failed prior policy condition and no `Opens` conclusion. Moreover, the module says `fit` combines acceptability and executability. Replacing it by `True` discards **both** constraints. Making every action acceptable does not make a physically unavailable action executable.

    **Replacement:** Rename the theorem `uniform_true` and say:
    > With an available action value, the unrestricted fitting predicate admits a constant policy through every reading.

    To discuss acceptability alone, keep executability separate and assume a supplied action executable at every configuration. To establish an opening, additionally supply failure under the old fitting predicate.

23. **[Medium — OpenedCorrection] The double-loop attribution and “exactly” claim are too strong.**  
    Location: [OpenedCorrection.lean:34](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/OpenedCorrection.lean).

    **Quoted:** “correcting through a fixed reading is the single loop, revising the reading the double”; “the double loop is needed exactly where a reading lumps configurations needing different acts”.

    **Problem:** Argyris and Schön distinguish inquiry that preserves governing norms from inquiry that changes norms, priorities, and objectives. Changing an observation map while holding the fitting criterion fixed does not by itself establish their double-loop category. Their account also distinguishes inquiry from a mere change. [Organizational Learning, 1978, chapter 1](https://studylib.es/doc/9549184/argyris-and-schon-1978).

    Against the Lean, no theorem characterizes when double-loop learning is necessary. Even unrestricted discrimination may fail to help when a configuration has no fitting action. Nor does failure of a common action necessarily reduce to a conflicting pair: `ReadingLoop.PairwiseShared` already illustrates that distinction.

    **Replacement:**
    > Revising an observation map is one formal mechanism that may participate in organizational learning. Its relation to double-loop learning depends on whether inquiry changes a governing norm or assumption. Here the fitting predicate remains fixed, and the theorem concerns uniform-policy feasibility only.

24. **[Medium — ReflexivePrediction] Order reversal is incorrectly generalized to absence of fixed points.**  
    Location: [ReflexivePrediction.lean:34](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReflexivePrediction.lean), also section title at line 197.

    **Quoted:** “and not where it reverses the order”; “A response reversing the order leaves no value”.

    **Problem:** `Reversing` proves the result for Boolean negation. An order-reversing response can have a fixed point: on `{0,1,2}`, `r(v) = 2 − v` fixes `1`. The opening bullet at line 27 correctly says “need not”; the later formulations lose that qualification.

    **Replacement:**
    > Order reversal alone does not ensure a right prediction. Boolean negation has none, and its repeated publication alternates.

    Rename the section “Boolean negation leaves no value fixed.” Keep the general impossibility condition as `∀ v, r v ≠ v`.

25. **[Medium — ReflexivePrediction] Performative stability is not generally exact outcome equality.**  
    Location: [ReflexivePrediction.lean:35](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReflexivePrediction.lean).

    **Quoted:** “Performative prediction calls a prediction that is right about the response to itself performatively stable”; “`bottom_rests` is that question answered”.

    **Problem:** Perdomo et al.’s definition is minimization of expected loss on the distribution induced by deployment:
    \[
    \theta \in \arg\min_{\theta'}\mathbb E_{Z\sim D(\theta)}[\ell(Z;\theta')].
    \]
    It does not require every realized outcome to equal the prediction. Their repeated update is risk minimization, whereas this module iterates the **outcome response** directly. [Perdomo et al. 2020, Definition 2.3](https://proceedings.mlr.press/v119/perdomo20a/perdomo20a.pdf).

    **Replacement:**
    > The fixed-point structure is related to performative stability. In a deterministic scalar specialization where deployment produces `r p` and retraining uniquely returns that outcome—for example, unrestricted constant prediction under squared loss—retraining reduces to this orbit. No general risk-minimization correspondence is proved here.

    The finite-chain theorem is sound and useful. Its correspondence needs the additional specialization.

26. **[Medium — ReflexivePrediction] The continuity attribution omits the domain/self-map conditions.**  
    Location: [ReflexivePrediction.lean:31](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReflexivePrediction.lean).

    **Quoted:** “a correct public prediction exists where the response is continuous, by a fixed-point theorem”.

    **Problem:** Continuity alone is insufficient: `r(x) = x + 1` on the reals has no fixed point. The bounded prediction/outcome domain is essential to the cited argument; it is explicit in the presentation of the Grunberg–Modigliani–Simon setup in [Hardt’s account](https://epubs.siam.org/doi/10.1137/25M1806405).

    The Lean correctly supplies the analogous missing condition through `within`, alongside monotonicity.

    **Replacement:**
    > In the bounded scalar setup, a continuous response mapping a nonempty closed interval into itself has a correct public prediction. Here, a response preserving a finite chain and its order reaches the least fixed point from the bottom by round `n`.

    Do not suggest that the historical existence argument itself establishes convergence of repeated publication.

27. **[Low — ReflexivePrediction] `Coordination` is an interpretation used as a structural name.**  
    Location: [ReflexivePrediction.lean:171](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReflexivePrediction.lean), theorem descriptions at lines 188–193.

    **Quoted:** `namespace Coordination`; “Nothing and everything are both right”.

    **Problem:** The formal object is a scalar threshold response with fixed points `0` and `2`. No coordinated components, participation counts, or collective response mechanism are represented. “Everything” means the upper endpoint of this chosen three-value example, not a quantified whole.

    **Replacement:** Use `ThresholdResponse` and:
    > Zero and two are fixed points. Publication from zero stays zero; publication from one reaches two after one round and stays there.

    Keep coordination and the Diamond–Dybvig connection in the explicitly labelled readings paragraph. The mathematics here is a two-fixed-point illustration, not a coordination model.


## What was taken

Every finding was taken. Findings 19 to 23, on `Becoming.OpenedCorrection` (RF6.1), are taken by holding that module out of this landing: its opening is a static feasibility statement, and RF6.1 asks for a revision that is a reachable step of one process, so the module stays in the kit and is rebuilt before its own landing, with the institution revising its rule of reading.

| # | Finding | Taken |
|---|---|---|
| 1 | Keeping can succeed by deadlock: `Good` is successor safety only | `GoodEnabled` and `Continues` added; `keeps_continues_iff` and `keeping_policy_iff` ask the act enabled at every world the reading admits; `Good` named successor safety; `Keeps` says the start is not asked to hold the task |
| 2 | `keeping_policy_iff` is for a supplied reading, not one the formation can have | the reading the formation's own history carries added (`Possible`, `possible_kept`, `possible_least`), with `history_keeps_iff` and `history_continues_iff` for a given policy; the existence condition tying histories to the task's futures, and nonvacuity, named as not proved (re-check: partly) |
| 3 | Faithfulness everywhere does not cover the module's own witness | `Loop.faithful_kept` and `Loop.fitting_closed` relative to a region the world's moves keep, `Untested.true_kept` the instance; `Loop.law`'s relation to `joint` named as prose only (re-check: partly) |
| 4 | General self-confirmation and model/order laws missing | `Loop.rests_of_unrefuted` (`Untested.rests`, `Untested.order_rests` its cases) and `observed_alike` (`Untested.model_or_order` its case) |
| 5 | RF-M's core is partial | the Standing says so and names the later items |
| 6 | `worst` capped at three | the least over nonempty lists, with the empty convention explicit; `worst_le`, `worst_attained`, `byWorst_iff` |
| 7 | An answer counted one step early | `Loop.kept_iff`'s prose: the answer sensed at `n + 1` is taken in at the next step |
| 8 | The closed region is more than membership | described as kept, agreeing with the answer pending, and the world in its region |
| 9 | `kept_alike`'s listing hypothesis dropped | kept in every summary |
| 10 | The floor summary drops the start not sensing high | `floor_never_high` named with its hypothesis |
| 11 | `alike_of_kept`'s hypotheses and scope | `alike_within` with the course's own acts and values and a horizon, `alike_of_kept` its corollary; decidability and the shared start stated; safe-exploration methods cited as related, not contained |
| 12 | "Once" stronger than the theorem | `explorer_low_once` an iff: low at step one and at no other step |
| 13 | "An order that does not rank"; "fixes only what it shows" | "a reversed ranking"; the shown-reach law cited with no cycle and positive comparisons |
| 14 | The citations need separate correspondence | the readings say related to, name the criterion used, and say the cited theorems are not reproduced |
| 15 | The inverse reinforcement learning attribution and the assistance conclusion | rewritten as an illustration; no general assistance theorem; informing represented by its outcome |
| 16 | The good-regulator label | Conant and Ashby and Virgo and others cited, policy-relative closure, all-act `KeptBy` and model necessity kept apart |
| 17 | A standing paragraph | added: compositions, general laws, witnesses, what is partial |
| 18 | The history reading said to be the one needed, no finer and no coarser | removed: `Possible` gives exactly the compatible worlds, a coarser reading can suffice, and verifying a given policy is not finding one |
| 19 | `Opens` has no reachable revision | held, with the module, for RF6.1's own landing (above) |
| 20 | Policy existence described as choosing | held with 19: the rebuilt module says a fitting policy exists |
| 21 | Non-factorization gives no distinguishing pair; the empty domain | held with 19 |
| 22 | `widened_opens` proves no opening and drops executability | held with 19 |
| 23 | The double-loop attribution and its "exactly" | held with 19 |
| 24 | Order reversal generalized to no fixed point | "Boolean negation leaves no value fixed" (`Negating`); a reversing response with a fixed point added (`Reflecting.reverses`, `Reflecting.middle_right`, with `Reflecting.sub_antitone` proved without the core lemma that reports `propext`) |
| 25 | Performative stability is not outcome equality | related to, defined there by risk minimization; this orbit only where retraining returns the outcome exactly; no general correspondence |
| 26 | The continuity attribution omits the domain | the bounded scalar setup stated; an existence, not its reaching by repeated publication |
| 27 | `Coordination` an interpretation as a name | renamed `ThresholdResponse`, zero and two the fixed points; coordination kept in the labelled reading |

## The cold read of the texts

After the review, the texts (03 §12, 03's bases and Open, 08's bullet, the overview's paragraph, the dossier's sentence, the package's rows and bullets, the checker's scope sentences, the four records and the study template) were cold-read against the Lean by a fresh session of the same reviewer, in a scratch copy with the texts integrated ([BRIEF](BRIEF.md#round-2)). Line numbers refer to that copy.

Verdict: **Needs revision.** The detailed theorem paragraphs are mostly careful, but several summaries drop necessary hypotheses or strengthen witness results.

1. **High — A preserved relation alone does not imply matching observations.**

   **Locations:** [Becoming.lean:2730](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean); [check_becoming.py:2891](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py).

   **Quoted:** “formations related by a relation their steps keep act alike”; “formations related by a relation their steps keep act and sense alike.”

   **Problem:** `ReadingLoop.observed_alike` additionally requires that related configurations have equal sensory and active parts, and that the starts are related. An arbitrary preserved relation—for example, the universal relation—does not supply observational equality.

   **Replacement:** “From related starts, two blanketed laws sense and act alike at every step where their paired steps preserve the relation and related configurations have equal sensed values and acts.”

2. **High — The least-reading claim loses its boundary condition.**

   **Locations:** [Becoming.lean:2723](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean); [check_becoming.py:2887](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py).

   **Quoted:** “the least reading kept by recording”.

   **Problem:** `possible_least` requires `∀ w, start w → B [] w`. Without requiring the reading to hold at the starts, the empty reading is also kept; `nothing_kept` expressly proves that.

   **Replacement:** “the least reading kept by recording that holds at every specified start with empty history”.

3. **Medium — Acting from history does not uniquely determine the reading.**

   **Location:** [make_records_rf2.py:151](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf2.py).

   **Quoted:** “acting from its history, that reading is the worlds possible after it”; “依己历而行者，此读即其历后可能之诸世。”

   **Problem:** `Possible` is a particular construction, least among readings preserved by recording and containing the starts. Neither `possible_least` nor the history-policy equivalences require a history-based formation’s supplied reading to equal it. Coarser preserved readings remain possible.

   **Replacement, English:** “With history as state, the worlds possible after it form the least reading kept by recording that holds at the specified starts.”

   **Replacement, Chinese:** “以历为态时，历后可能之诸世构成为记录所守、且于指定起点成立之最小之读。”

4. **High — The general indistinguishability summaries drop the shared start and decision hypothesis.**

   **Locations:** [THE-THEORY-OF-BECOMING.md:98](../../../../../../../theories/becoming/THE-THEORY-OF-BECOMING.md); [Becoming.lean:2725](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean); [check_becoming.py:2888](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py); [study_rf2.txt:20](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf2.txt); [make_records_rf2.py:264](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf2.py); [ALIGNMENT.md:28](../../../../../../../theories/becoming/review/ALIGNMENT.md).

   **Quoted:** “two worlds give one formation one course exactly as long as they answer alike what it does”; “where only answers breaking a task tell two worlds apart, no formation keeping the task learns which holds”.

   **Problem:** `sensed_alike_iff`, `alike_within`, and `alike_of_kept` compare runs of **one blanketed law from equal internal, sensory and active starts**. The latter two require `DecidableEq S`. The finite result concerns steps through `N`; “never” requires the hypotheses at every step. “One course” also overstates equality: the external parts can differ.

   **Replacement, English:** “For one blanketed law from equal internal, sensory and active starts, the sensed courses agree through `N` exactly when the worlds answer alike the first course’s act and sensed value at every step before `N`. With decidable equality of sensed values, if each differing second-world answer would violate `K`, and `K` holds in the second run at steps 1 through `N`, the sensed courses agree through `N`. If these hypotheses hold at every step, they agree forever.”

   **Replacement, Chinese:** “于同一毯化之律，自内部、感官与主动部分皆相同之起点，二所感历程至 N 相同，恰当 N 前每步二世对第一历程之行与所感之值答之相同。所感之值之相等可判定时，若第二世之异答皆违 K，且第二历程于第一至第 N 步皆守 K，则二所感历程至 N 相同；诸条件每步皆成立，则每步皆同。”

   For the dossier’s interpretive sentence, prefix this scoped conclusion with **“[AI reading]”** before describing it as failure to learn which world holds.

5. **High — “Every formation on those worlds” needs the fixed response, stationary worlds and shared start.**

   **Locations:** [03-KNOWING.md:472](../../../../../../../theories/becoming/chapters/03-KNOWING.md); [make_records_rf2.py:320](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf2.py), also line 344; [study_rf2.txt:28](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf2.txt).

   **Quoted:** “every formation on those worlds, whatever its internal part, update and choice of act, that never senses the low value in the second senses alike in both”.

   **Problem:** `floor_forgoes` fixes `nextSensory = reply`, requires `nextExternal s a w = w`, and compares `⟨i,s,a,.up⟩` with `⟨i,s,a,.down⟩`. Merely using the two-world carrier does not suffice. The initial sensory equality is especially necessary for equality at step zero.

   **Replacement, English:** “For every blanketed law with the witness’s response `reply` and stationary worlds, from the same internal, sensory and active start in both worlds, never sensing low in `down` entails equal sensed courses and the known act at every step in `down`. If the shared initial sensed value is not high, the `up` course never senses high.”

   **Replacement, Chinese:** “于感官响应为例中 reply、且世不移之每一毯化之律，自二世中内部、感官与主动部分皆相同之起点，若于 down 终不感低，则二所感历程皆同，且于 down 每步皆取已知之行；若共同之初始所感值非高，则于 up 终不感高。”

6. **Medium — The concrete witness conclusions omit their concrete starts.**

   **Locations:** [03-KNOWING.md:472](../../../../../../../theories/becoming/chapters/03-KNOWING.md), also line 477; [make_records_rf2.py:308](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf2.py), also lines 314 and 403; [study_rf2.txt:27](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf2.txt).

   **Quoted:** “Keeping both candidates, the formation rests at once”; “sensing the low value at step one and at no other step”; “have the same acts and values sensed at every step”.

   **Problem:** These are theorems about specified starts, not all starts with those candidate lists. `rests` starts at `.mid, .known`; the exploration results start at `.mid, .untried`; `model_or_order` and `informed_turns` start at `.mid, .known` in `.up`. All use `Loop.start`, with no pending answer. Starting low already invalidates “low at step one and at no other step”.

   **Replacement, English:** “In this witness, start with no pending answer and the middle sensed value. With both candidates listed, the initial known act gives the resting course; changing only the initial act to untried gives the exploration course. The model/order comparison uses the specified two listings and rankings, with the initial known act in `up`; the informed variant changes the first listing to `[up]`.”

   **Replacement, Chinese:** “此例皆以无待纳之答及中值为起点。列二候选而初取已知之行，得所述之静止历程；唯将初始行改为未试之行，得所述之探索历程。模型与序之比较用所定之二列与二排序，于 up 初取已知之行；告之之变体唯将前者之列改为 [up]。”

7. **High — An unrefuted model does not by itself force rest.**

   **Locations:** [Becoming.lean:2729](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean); [study_rf2.txt:25](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf2.txt).

   **Quoted:** “rests on a model its course never refutes”; “it rests … where the world answers its act with what it sensed”.

   **Problem:** `rests_of_unrefuted` requires four equations/conditions: `answer s a e = s`, `move s a e = e`, `choose hs s = a`, and every listed candidate predicting `s` at `(s,a)`. The study supplies only the first explicitly. Accurate candidates can remain unrefuted along a changing course.

   **Replacement:** “From `Loop.start hs s a e`, if the world answers `a` with `s` and remains at `e`, the formation chooses `a` from `hs` at `s`, and every listed candidate predicts that answer, the configuration is constant from step one onward.”

8. **Medium — Candidate retention summaries lose the listing and processing delay.**

   **Locations:** [THE-THEORY-OF-BECOMING.md:98](../../../../../../../theories/becoming/THE-THEORY-OF-BECOMING.md); [Becoming.lean:2728](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean); [check_becoming.py:2890](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py); [study_rf2.txt:24](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf2.txt); [make_records_rf2.py:265](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf2.py).

   **Quoted:** “its candidates are kept exactly where they fit the answers its own course received”.

   **Problem:** `Loop.kept_iff` requires initial membership in `hs`, starts with no pending answer, and at configuration `n+1` tests only acts at steps `k<n`. The answer just received at `n+1` is not yet incorporated. The loop also requires decidable equality of sensed values.

   **Replacement, English:** “With decidable equality of sensed values, from a listed-candidate start with no pending answer, the candidates retained at configuration `n+1` are exactly those initially listed that fit the answers to acts before step `n`; the latest sensed answer is incorporated at the next step.”

   **Replacement, Chinese:** “所感之值之相等可判定时，自列候选且无待纳之答之起点，第 n+1 形态所守者恰为初列且合第 n 步前诸行之答之候选；最近所感之答于下一步方纳之。”

   In [03-KNOWING.md:472](../../../../../../../theories/becoming/chapters/03-KNOWING.md), replace the ambiguous header qualification “decided where stated” with “decided for the task-breaking laws and the candidate loop”; the paragraph never otherwise identifies those uses.

9. **High — Candidate membership alone is not the closed region.**

   **Location:** [make_records_rf2.py:254](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf2.py).

   **Quoted:** “the reading that a candidate is kept is a closed region”; “其中「某候选被守」之读为闭域。”

   **Problem:** `Loop.fitting_closed` proves closure of `Fitting h x ∧ Q x.external`. `Fitting` includes both membership and agreement with the pending answer. It also requires `Q` to be preserved by every world move and the candidate to predict the world’s answers throughout `Q`. Membership alone can disappear at the next filtering step.

   **Replacement, English:** “For a candidate faithful throughout a world-region preserved by every move, the configurations where it is retained, agrees with the pending answer, and the world lies in that region form a closed region of the loop.”

   **Replacement, Chinese:** “候选于世之每移所守之域内皆如世之答而预言时，其被守、合待纳之答、且世在此域之形态，构成环之闭域。”

10. **Medium — The study’s retention claim omits initial membership and the invariant region.**

    **Location:** [study_rf2.txt:24](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf2.txt).

    **Quoted:** “a faithful one is never dropped”.

    **Problem:** `faithful_kept` requires the candidate to be listed, the initial world to lie in `Q`, every move to preserve `Q`, and answer/prediction agreement throughout `Q` for every sensed value and act.

    **Replacement:** “A listed candidate is never dropped from a start in `Q` when every world move preserves `Q` and the candidate predicts the world’s answer for every sensed value and act throughout `Q`.”

11. **High — The finite-chain summaries omit conditions needed for convergence.**

    **Locations:** [08-METHOD.md:483](../../../../../../../theories/becoming/chapters/08-METHOD.md); [README.md:287](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.md); [README.zh.md:126](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.zh.md); [THE-THEORY-OF-BECOMING.md:98](../../../../../../../theories/becoming/THE-THEORY-OF-BECOMING.md).

    **Quoted:** “reaches Tarski’s least fixed point … on a finite chain within its length”; “from the bottom of a chain under a response keeping the order”; “守序之应下自链之底达最小之是者”.

    **Problem:** `bottom_rests` concerns the natural-number interval `0,…,n`, a response preserving **both the interval and its order**, and iteration **from zero**. The method bullet omits order preservation and the initial value; the README rows omit finiteness and interval preservation; the overview omits interval preservation. Order preservation alone permits `r(v)=v+1`.

    **Replacement, English:** “On the natural-number chain `0,…,n`, a response mapping the chain into itself and preserving its order reaches its least fixed point by step `n` when each publication repeats the preceding outcome, starting from zero.”

    **Replacement, Chinese:** “于自然数链 0,…,n，应映此链入其自身且守其序；自零起、每步公布前步之果，则至第 n 步达其最小不动点。”

12. **Medium — “No premise” conflates empty axiom reports with conditional theorems.**

    **Locations:** [README.md:218](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.md), also line 287; [README.zh.md:125](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.zh.md), also line 126; [study_rf2.txt:41](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf2.txt).

    **Quoted:** “no premise”; “不加前提”; “Supplied premises / correspondence: none added.”

    **Problem:** The declarations have empty axiom reports but explicitly supplied hypotheses: `KeptBy`, shared starts, decidable equality, invariant regions, chain preservation, and `ChoiceOver` for the existence equivalences. The study’s following modelling-choice list does not supply these omissions.

    **Replacement, English:** “Every axiom report is empty; the results are conditional on the hypotheses stated for each theorem.”

    **Replacement, Chinese:** “每项公理报告皆空；各结果以各定理所列条件为前提。”

    For the study, add: “Choice over states is required for `keeping_policy_iff`; choice over admitted responses is required for `predictor_iff`.”

13. **Medium — “Informing” enters a theorem statement without its reading label.**

    **Location:** [make_records_rf2.py:388](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf2.py).

    **Quoted:** “while informing turns only the first”; “而告之唯转其前者。”

    **Problem:** `informed_turns` compares a separately initialized run whose candidate list is `[up]`; no informing act occurs within the law. The correspondence field labels this reading, but the theorem’s headline statement presents the intervention as proved.

    **Replacement, English:** “In the specified witness, starting the first formation with the true candidate alone changes its course; the second already starts with that candidate alone. [AI reading] This change of initial listing represents the outcome of informing.”

    **Replacement, Chinese:** “于指定之例，以真候选独起前一形成则变其历程；后一形成原已以真候选独起。[AI 解读] 此初始候选列之改变表告之之果。”

14. **Medium — The study says `Keeps` now includes enabledness, but it still does not.**

    **Location:** [study_rf2.txt:63](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf2.txt).

    **Quoted:** “keeping now asks the act enabled at every world the reading admits”.

    **Problem:** `Keeps` remains successor safety along positive reach and can hold under deadlock. Enabledness is supplied separately by `Continues`; `keeps_continues_iff` characterizes their conjunction.

    **Replacement:** “Keeping remains successor safety; the added continuation requirement asks that the act be enabled at every world the reading admits.”

15. **Low — The reading says the response, rather than its fixed point, is reached.**

    **Location:** [03-KNOWING.md:484](../../../../../../../theories/becoming/chapters/03-KNOWING.md).

    **Quoted:** “a response keeping a finite chain and its order is reached from the bottom”.

    **Problem:** The iterates are prediction values. `bottom_rests` reaches a fixed point of the response, not the response function.

    **Replacement:** “under a response keeping the finite chain `0,…,n` and its order, the least right prediction is reached from the bottom by step `n`”.

16. **Low — There are two witness theorems quantified over formations.**

    **Location:** [study_rf2.txt:67](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf2.txt).

    **Quoted:** “`floor_forgoes` … is the one statement there quantified over formations”.

    **Problem:** `floor_never_high` also quantifies over arbitrary `I` and `b : Blanketed I Value Act World`, with the specified response and stationary-world hypotheses.

    **Replacement:** “`floor_forgoes` and its corollary `floor_never_high` quantify over formations with the witness’s response and stationary worlds.”

| # | Finding | Taken |
|---|---|---|
| 1 | A kept relation alone does not give matching observations | the summaries add related starts and the relation's giving equal values sensed and acts |
| 2 | The least reading loses its condition at the starts | "that holds at the starts" in the bullet and the scope sentence |
| 3 | Acting from a history does not fix the reading | record A's statement no longer says so; the history laws stay in its laws |
| 4 | The indistinguishability summaries drop the shared start and the decision | one blanketed law from one start, equality of values decided, through `N` and at every step; the dossier's conclusion labelled a reading |
| 5 | "Every formation on those worlds" needs the answer, the stationary worlds and the start | stated in 03 §12, the record's law and counterexample, and the study |
| 6 | The witnesses' conclusions omit their starts | the starts named: no answer pending, the middle value, the known or the untried act |
| 7 | An unrefuted model does not by itself force rest | the study gives `rests_of_unrefuted`'s four conditions |
| 8 | Keeping candidates loses the listing and the delay | the listing, no answer pending, the steps before `n` and the delay stated; 03's header names where equality is decided |
| 9 | Membership alone is not the closed region | record A's related detail names the region, the pending answer and faithfulness |
| 10 | The study's "a faithful one is never dropped" omits the region | the region every move keeps stated |
| 11 | The chain summaries omit the chain mapped into itself and the start at zero | stated in 08, the READMEs, the overview, the bullet, the scope sentence and record D |
| 12 | "No premise" conflates empty axiom reports with conditional theorems | the rows say every axiom report is empty and each result is under its theorem's hypotheses; the study lists the hypotheses and the choice each iff needs |
| 13 | "Informing" stated as proved | record C says starting with the true candidate alone changes the course; informing stays in the labelled reading |
| 14 | The study says keeping asks enabledness | keeping stays successor safety; going on asks enabledness |
| 15 | The reading says the response is reached | the least right prediction is reached |
| 16 | Two witness theorems quantify over formations | both named |

## The re-check of the rebuilt RF6.1 module

`Becoming.OpenedCorrection` was rebuilt after findings 19 to 23 (an opening along a trace of one process, on Revising's stock-and-link process) and re-checked in the review's session. It stays held for its own landing, with findings 24 to 26 taken there and its texts cold-read first.

**Verdict: the executable composition is now present, and the proofs appear sound on source inspection. Findings 19–22 are resolved; 23 is partly resolved. One false summary and two scope qualifications remain. No files were changed or Lean builds run.**

19. **Taken correctly** — `OpensAlong` includes a trace, and `Linked` connects policy feasibility to `Enabled Revising.P`, including rebuilding, starvation, and replenishment.
20. **Taken correctly** — the text consistently states policy existence and explicitly distinguishes it from a controller’s actual choices.
21. **Taken correctly** — refinement uses supplied maps and the appropriate executability inclusions; the unsupported distinguishing-pair conclusion is gone.
22. **Taken correctly** — `widened_correctable` preserves executability, requires an executable action, and claims correctability rather than a before/after opening.
23. **Partly** — the double-loop attribution is correctly qualified, but the final coarsening sentence reverses the required executability condition; see finding 24.

24. **[Medium] The readings paragraph reverses “no gain” into “no loss.”**  
    Location: [OpenedCorrection.lean:41](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/OpenedCorrection.lean).

    **Quoted:** “Replacing a finer reading by a coarser one, as by a summary measure, losing no executability, opens no correction.”

    **Problem against the Lean:** `coarser_opens_nothing` requires:
    ```lean
    no_gain : ∀ a, executable x' a → executable x a
    ```
    The quoted condition has the opposite direction.

    The module’s own definitions supply a counterexample. Replenishment takes `(0, true, v)` to `(1, true, v)` with an unchanged reading. It loses no executable action, but the former configuration is uncorrectable by `starved_uncorrectable` and the latter correctable by `linked_correctable`. The newly enabled correction creates the opening.

    **Replacement:**
    > Replacing a reading by one obtained from it through the supplied map, while gaining no executability and keeping acceptability fixed, opens no correction.

25. **[Medium] `OpensAlong` records a reachable gain in correctability, not necessarily a revision of the reading.**  
    Location: [OpenedCorrection.lean:77](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/OpenedCorrection.lean), also header lines 19–21.

    **Quoted:** “A revision opens a correction along a course of the process”.

    **Problem against the Lean:** The definition requires a trace and a change from uncorrectable to correctable. It requires neither a changed reading nor a designated revision action. The replenishment example in finding 24 satisfies it while leaving the reading unchanged.

    Consequently, the general predicate does not identify whether the opening comes from information, executability, or both. The concrete `Linked.opens` witness does explicitly supply a rebuilding step, so the new RF6.1 instance remains valid.

    **Replacement:**
    > A course opens correctability when it reaches a configuration with a fitting uniform policy from one without such a policy, under fixed acceptability. The gain may come from the reading, executability, or both. `Linked.opens` exhibits an opening along a rebuilding step.

    If the general predicate is intended specifically to certify reading revision, add an explicit revision condition to the trace.

26. **[Low] Executability is required only on occupied reading fibers.**  
    Location: [OpenedCorrection.lean:69](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/OpenedCorrection.lean), also lines 15–18 and 63–64.

    **Quoted:** “each reading has one act acceptable at every situation giving it and executable at the configuration”.

    **Problem against the Lean:** In `correctable_iff`, both acceptability and executability occur inside:
    ```lean
    ∀ s, reading x s = o → ...
    ```
    An empty fiber imposes neither condition. The prose can instead be read as requiring executability independently for every `o`.

    This matters at the allowed empty-domain boundary: with `S = Empty`, `A = O = Unit`, and `executable := False`, `Correctable` holds vacuously although no action is executable. The `Linked` instances are unaffected because their situation type is `Bool`.

    **Replacement:**
    > For every reading value, there is an action that is acceptable and executable at the configuration for every situation producing that value. Empty fibers impose no such requirement.

    If correctability should additionally guarantee an executable action exists, require an inhabited situation domain or an explicit witness.

