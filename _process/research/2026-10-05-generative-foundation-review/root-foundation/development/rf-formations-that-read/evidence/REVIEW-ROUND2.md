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

## The cold read of RF6.1's texts

Before RF6.1's own landing, its texts (03 §8's entry and Open bullet, 08's bullet, the package's rows and bullet, the module's header, the record, the study template and the plan's bullet) were cold-read against the Lean by a fresh session of the same reviewer, in a scratch copy with the texts integrated ([BRIEF](BRIEF.md#round-2)).

Verdict: **Needs textual correction.** Four findings below; no files changed or checks run.

1. **Medium — The rebuild summaries omit the initially-off link.**

   **Locations and quoted text:**
   - [03-KNOWING.md:316](../../../../../../../theories/becoming/chapters/03-KNOWING.md): “rebuilding the link from two units opens the correction”.
   - [OpenedCorrection.lean:35](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OpenedCorrection.lean) and [study_rf61.txt:20](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf61.txt): the same formulation.
   - [Becoming.lean:3097](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean), [PLAN.md:178](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md), and [make_records_rf61.py:147](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf61.py): “rebuilding the link opens [the correction/it] where a unit of stock remains after”.
   - [README.md:289](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.md): “where a unit of stock remains after the rebuild”.
   - [README.zh.md:126](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.zh.md): “重建后尚余一储处”.
   - [make_records_rf61.py:149](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf61.py): “重建其联而后尚余一储处开之”; also line 178, “自二储重建其联，一步而开更正”.

   **Against the Lean:** `Linked.opens` starts specifically at `(n + 2, false, v)` and ends at `(n + 1, true, v)`. Remaining stock alone is insufficient: with the link already on and positive stock, `linked_correctable` says the starting configuration is already correctable, contradicting the required initial non-correctability in `OpensAlong`. The rebuilding-then-replenishing witness likewise starts with the link off.

   **Replacement, English:** “Starting with the link off and at least two units of stock, rebuilding it to on opens the correction in one step. Starting with the link off and one unit, rebuilding alone does not; rebuilding to on and then replenishing does.”

   **Replacement, Chinese:** “初始联断且至少有二储时，将联重建为通，一步而开更正。初始联断且仅有一储时，唯重建不能开之；重建为通而后补储则开之。”

2. **Medium — An unused reading still requires an act, although it imposes no acceptability or executability condition.**

   **Locations:** [03-KNOWING.md:316](../../../../../../../theories/becoming/chapters/03-KNOWING.md), [OpenedCorrection.lean:19](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OpenedCorrection.lean), and [study_rf61.txt:11](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf61.txt).

   **Quoted text:** “a reading no situation gives asking nothing”.

   **Against the Lean:** `correctable_iff` states `∀ o, ∃ a, ∀ s, …`. An empty fiber makes the condition following `∃ a` vacuous; it does not remove that existential. `UniformPolicy` likewise requires a total function `O → A`. The texts quantify over arbitrary types, so an inhabited act type cannot silently be assumed.

   **Replacement:** “A reading no situation gives imposes no acceptability or executability condition, but still requires an act as the value of the total policy.”

3. **Low — The monotonicity summaries leave the supplied total map implicit; the chapter also omits the common reading type.**

   **Locations and quoted text:**
   - [03-KNOWING.md:316](../../../../../../../theories/becoming/chapters/03-KNOWING.md): “any types”; “A revision to a reading the old one is read off, losing no executability, closes nothing”.
   - [OpenedCorrection.lean:24](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OpenedCorrection.lean): the same monotonicity wording.
   - [study_rf61.txt:14](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf61.txt): “a reading the old one is read off, losing no executability, closes nothing”.
   - [make_records_rf61.py:160](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf61.py): the same English wording; line 162: “修订为旧读所由读出之读，而不失可行者，则无所闭”.

   **Against the Lean:** `finer_keeps` and `coarser_opens_nothing` take an explicit total `forget : O → O` and a factorization equation for every situation. “Read off” leaves this important constructive premise implicit. Both readings have the same codomain `O`; the header, record and study state that elsewhere, but the chapter does not. The executability directions themselves are correctly stated.

   **Replacement, English:** “With readings in one fixed type `O` and acceptability fixed: a supplied map `f : O → O` satisfying `f (reading x' s) = reading x s` for every situation preserves correctability when every act executable at `x` remains executable at `x'`. A supplied map satisfying `f (reading x s) = reading x' s` rules out an opening when every act executable at `x'` was executable at `x`.”

   **Replacement, Chinese:** “诸读同属一固定型 `O`，可受者守定。给定映射 `f : O → O`：若每一情形皆满足 `f (reading x' s) = reading x s`，且于 `x` 可行之行于 `x'` 仍可行，则保持可更正性；若皆满足 `f (reading x s) = reading x' s`，且于 `x'` 可行之行于 `x` 已可行，则不能开一更正。”

4. **Low — The record’s relationship description makes reading revision unconditional.**

   **Location:** [make_records_rf61.py:230](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf61.py).

   **Quoted text:** “here the reading in force itself revised along the course”; “此处所行之读本身沿历程而修订”.

   **Against the Lean:** `OpensAlong` requires no change of reading. `Linked.opens_by_support` explicitly witnesses an opening with the reading unchanged. This relationship summary drops the qualification retained in the record’s main statement.

   **Replacement, English:** “Here correctability is compared along a process course; the reading in force, executability, or both may change.”

   **Replacement, Chinese:** “此处沿一过程之历程比较可更正性；所行之读、可行者，或二者皆可改变。”

| # | Finding | Taken |
|---|---|---|
| 1 | The rebuild summaries omit the link starting off | every summary says the link starts off, with at least two units for one step and one unit for rebuilding then replenishing |
| 2 | A reading no situation gives still needs an act | "imposing no such condition though the policy still gives it an act" |
| 3 | The monotonicities leave the supplied map and the common type implicit | the map and its equations, the executability directions and the one type of readings stated in the chapter, the header, the record and the study |
| 4 | The record's relation detail makes revision unconditional | correctability compared along a course, the reading, executability or both changing |

## The review of RF7's module

RF7's module, then `Becoming.Concealment` (10 theorems in 22 declarations, in the kit at `kit/round2/tree/Becoming/Concealment.lean`), was reviewed read-only by the cross-model reader in a fresh session; the prompt is in [BRIEF](BRIEF.md#round-2), under the Lean review of RF7's module. The file was later renamed `ReadStages.lean` when the module was rebuilt, so the review's links to it are given here as plain text; its versions are in the history of that path.

**Verdict: the arithmetic theorem is sound on inspection, but RF7 is only partially met: probability validity, choice and tie semantics, and the disclosure exit need correction. No files changed or builds run. Findings below are in repair priority order.**

1. **High — `Stakes` does not enforce its probability interpretation.**  
   Location: `Concealment.lean:61`, lines 61–105.

   > “The stakes, in natural-number weights out of `total`”

   All five fields are unrestricted `Nat`s. Nothing requires `total > 0` or either retention weight to be at most `total`. For example, `⟨0, 1, 0, 1, 100⟩` satisfies `Conceals`: multiplication by the zero total erases the cost. Its probability interpretation is undefined.

   With a positive total and bounded weights, the encoding is correct. Writing \(T=\text{total}\), \(k_C=\text{keptComplying}\), \(k_O=\text{keptOwn}\), \(V=\text{value}\), and \(c=\text{cost}\), it represents:

   | Plan | Expected utility |
   |---|---:|
   | comply, comply | \(-c\) |
   | comply, own | \(k_CV/T-c\) |
   | own, comply | \(0\) |
   | own, own | \(k_OV/T\) |

   `Beats` correctly compares these without truncated natural-number subtraction. Consequently, `Conceals` is exactly strict superiority over every other plan **under this payoff interpretation**.

   **Replacement:** retain the unrestricted arithmetic lemmas if useful, but require the following for probability claims:

   ``lean
   def Stakes.Valid (s : Stakes) : Prop :=
     0 < s.total ∧
     s.keptComplying ≤ s.total ∧
     s.keptOwn ≤ s.total
   ``

   State the payoff table explicitly, including its common utility scale, additive stage payoffs, and zero continuation payoff for compliance or non-retention. The two retention weights need individual bounds; they need not sum to `total`.

2. **High — strict optimality is proved; actual choice and tie rejection are not.**  
   Location: `Concealment.lean:36`, also lines 115–136 and 171–177.

   > “the law says concealment is chosen exactly where these meet with the stake exceeding the cost”

   > “nothing conceals”

   `conceal_best_iff` correctly characterizes a **unique strict maximum**. There is no chooser, optimal-choice hypothesis, or tie-breaking convention. `¬ s.Conceals` does not exclude concealment from the maximizing plans.

   For valid stakes `⟨10, 9, 1, 10, 8⟩`, concealment and disclosure both have utility \(1\), exceeding the other plans. For `⟨10, 1, 1, 10, 0⟩`, `no_leverage` applies, yet concealment and disclosure again tie for best. With `value = cost = 0`, all four plans tie.

   **Replacement:** say:

   > “Concealment is uniquely strictly best exactly when `Conceals` holds. Zero continuation value or no retention advantage excludes strict optimality, but can leave concealment tied for best.”

   To retain RF7’s literal “chosen exactly,” define an optimizing selector that chooses `conceal` when `Conceals` holds and `disclose` otherwise, explicitly favoring disclosure at equality, and prove its optimality.

   **Substance:** the comparison with `disclose` is definitionally `Conceals`; the content of `conceal_best_iff` is the finite-case proof that this comparison also defeats the other two plans. `no_value` and `no_leverage` are elementary arithmetic consequences. The four `Example` theorems are one numerical witness and direct applications, not additional incentive mechanisms.

3. **Medium — the prose threshold drops the total’s scaling.**  
   Location: `Concealment.lean:18`, also lines 103–105.

   > “the weight complying adds to being kept, times the value, exceeds the cost, strictly”

   The Lean compares the weighted gain with **`cost * total`**, not `cost`. With `⟨10, 9, 1, 1, 1⟩`, the added weight times value is \(8>1\), satisfying the prose literally, but `Conceals` is false: \(1+10<9\) fails.

   **Replacement:**

   > “The increase in retention probability, multiplied by continuation value, strictly exceeds the compliance cost.”

   Or, staying entirely in the integer encoding:

   > “`keptComplying * value` strictly exceeds `keptOwn * value + cost * total`.”

4. **Medium — `Untold` describes equal actions, not inability to distinguish; the lumping bridge needs its full informational scope stated.**  
   Location: `Concealment.lean:138`, lines 138–150.

   > “A plan the formation can carry where it cannot tell the stages apart: one act at both.”

   `Untold p` is only `p.1 = p.2`. A formation can distinguish the stages perfectly and nevertheless act identically. For example, an identity lumping and a constant act law satisfy the behavioral equality.

   `lumped_untold` is correct: it directly applies `Learning.Lumped` to the supplied equality of observations. It adequately represents the deterministic special case **if** `π` includes all information available to the decision rule. Merely hiding an evaluation cue is insufficient in a two-stage process: memory, a clock, or the previous action can distinguish the stages. The current module establishes neither complete informational equivalence nor a general result about uncertain evaluation.

   **Replacement:** name the behavioral predicate `Uniform`, and state:

   > “A fixed deterministic act law gives equal acts when the stages have identical complete accessible states, including retained memory. Such a law cannot realize `conceal`.”

   `lumped_untold` is a direct specialization of an existing definition; `conceal_told` is constructor disjointness. Their useful contribution is the connection between the information restriction and the excluded plan, not a new epistemic theorem.

5. **Medium — `untold_discloses` proves a conditional pairwise comparison, and neither it nor `disclose` establishes revelation of a law.**  
   Location: `Concealment.lean:152`, also lines 25–26, 38–39 and 109–113.

   > “wherever anything is at stake … its law is shown when read”

   The theorem’s conclusion unfolds to its hypothesis:

   ``lean
   0 < s.keptOwn * s.value + s.cost * s.total
   ``

   Thus it is a definitional restatement of the supplied strict comparison. It correctly compares the two uniform plans, but “anything is at stake” must mean this particular expression is positive.

   The reading at lines 38–39 drops that condition. Valid stakes `⟨1, 1, 0, 1, 0⟩` have positive continuation value and retention leverage, yet both uniform plans have utility zero. Indistinguishability then guarantees neither strict preference for `.own` nor its selection.

   **Replacement:** state the complete constrained-optimum result:

   ``lean
   (∀ q, Untold q → q ≠ disclose → s.Beats disclose q) ↔
     0 < s.keptOwn * s.value + s.cost * s.total
   ``

   Add that equality leaves both uniform plans tied.

   Separately, `.own` is an action tag. There is no space of private laws, reader observation, inference, or identification theorem. Replace “its law is shown” with:

   > “Under the positive-stake condition, an optimizing choice among uniform plans takes the own act at the read stage.”

   For exact structural names, `ownAtBoth`, `complyThenOwn`, and `Uniform` say what the definitions establish. “Disclosure” and “concealment” can remain labelled interpretations. Likewise, `Example.myopic` establishes zero continuation value, not a myopic computation. An exact claim of deception would additionally need the recipient-side and intentional correspondence; that is beyond what this incentive comparison proves.

6. **Medium — the Hubinger attribution is correct, but the three-condition correspondence is incomplete.**  
   Location: `Concealment.lean:30`, lines 30–40.

   > “an objective extending beyond the episode, a model of the training, and an expectation that modification will stop”

   The authors and original 2019 date are correct. Their §4.2 concerns an objective spanning parameter updates, modelling selection pressure and its base objective, and expecting the modification threat eventually to disappear. Stage discrimination alone does not supply the second condition. Retention leverage does not represent the third; the terminal unread opportunity supplies that assumption here. These are proposed necessary conditions, not a sufficient-choice theorem. [Hubinger et al., §4.2](https://arxiv.org/html/1906.01820#S4.SS2)

   **Replacement:**

   > “[AI reading] Continuation value represents concern across modification opportunities. The supplied retention weights and compliant act represent an assumed model of selection pressure; stage discrimination supplies access to when that pressure applies. The terminal unread stage assumes an opportunity beyond that pressure. If these stakes are the formation’s subjective expected-utility assessment, the theorem characterizes strict optimality within the four-plan model.”

   This makes the missing belief-to-ranking correspondence explicit without requiring a full implementation of training.

7. **Low — Greenblatt’s result is compressed into an overly categorical behavioral contrast.**  
   Location: `Concealment.lean:32`, lines 32–34.

   > “complying with a training objective when told it was being trained and not otherwise”

   The 2024 attribution is correct. The experiments demonstrate alignment-faking reasoning and differences in compliance rates under constructed training cues, not a universal deterministic switch. In the initial helpful-only setup, compliance was about 12% for implied training and almost never otherwise; later RL also increased compliance outside training. The evidence includes preservation reasoning, not merely a behavioral gap. [Greenblatt et al., abstract and §1](https://arxiv.org/html/2412.14093v1)

   **Replacement:**

   > “Greenblatt and others (2024) observed strategic compliance and preservation reasoning in constructed settings, with compliance rates differing between implied-training and unmonitored conditions. This motivates the model’s preservation-incentive interpretation; it does not establish its four-plan restriction, retention weights, or threshold empirically.”

| # | Finding | Taken |
|---|---|---|
| 1 | `Stakes` does not enforce its probability interpretation | `Stakes.Valid` (now `Prospects.Valid`), the table of expected values in the header, and `Example.no_total` for a total of nothing |
| 2 | Strict optimality is proved; actual choice and ties are not | `choose`, `choose_optimal` and `choose_eq_iff`, ties to the own law; later every maximal plan (`only_complyThenOwn_iff`) |
| 3 | The prose threshold drops the total's scaling | the loss times the total in the threshold (`Conceals`, now `KeepingOutweighs`) and in every text |
| 4 | `Untold` describes equal actions, not inability to tell | `Uniform`, with `lumped_uniform`'s informational scope stated; later which plans a lumping leaves open (`plan_realized_iff`) |
| 5 | `untold_discloses` is a conditional pairwise comparison | `uniform_best_iff` and `uniform_tie`; disclosure kept as a labelled reading |
| 6 | The Hubinger correspondence is incomplete | the readings rewritten; later the three conditions mapped, the third assumed rather than represented |
| 7 | Greenblatt's result is compressed | constructed settings and rates; it motivates the reading only |

## The re-check of RF7's rebuilt module

The module was rebuilt for the seven findings (21 theorems in 35 declarations) and re-checked in the review's session.

**Verdict: the rewritten Lean addresses the substantive findings on inspection. One prose qualification remains missing, and one new name overstates its statement. No builds run or files changed.**

1. **Taken correctly.** `Stakes.Valid` supplies exactly the probability constraints; the payoff table states the additive utility interpretation, and `Example.no_total` demonstrates why validity matters.

2. **Taken correctly.** `choose` explicitly resolves ties toward `ownAtBoth`; `choose_optimal` proves it is never strictly beaten, and `choose_eq_iff` characterizes its selection. The exit statements now distinguish strict optimality from tied optimality.

3. **Taken correctly.** The threshold explicitly includes `cost * total`; both `Conceals` and its docstring give the correct scaled comparison.

4. **Taken correctly.** `Uniform` names behavioral equality; `lumped_uniform` supplies the sufficient information condition, with memory, clock and earlier action explicitly included.

5. **Partly.** `uniform_best_iff`, `uniform_tie` and the structural plan names repair the formal claims, but `Concealment.lean:66` still says “wherever anything is at stake”: replace this with “where `keptOwn * value + cost * total > 0`.” Valid stakes `⟨1, 1, 0, 1, 0⟩` have positive continuation value and retention leverage but leave both uniform plans tied.

6. **Taken correctly.** The Hubinger reading now separates the assumed selection model, access to stage information, and the terminal opportunity beyond modification; it explicitly distinguishes proposed necessary conditions from the module’s conditional optimality result.

7. **Taken correctly.** The Greenblatt reading now describes constructed settings, preservation reasoning and differing compliance rates, without claiming a deterministic switch or empirical validation of the threshold.

8. **New problem — Low: zero continuation value is named as absence of continuation.**  
   Location: `Concealment.lean:281`.

   > `theorem no_continuation : ({ stakes with value := 0 } : Stakes).choose = ownAtBoth`

   The theorem sets the continuation **value** to zero. It retains both stages and the retention weights; it proves no absence of continuation. Its docstring correctly states the narrower meaning.

   **Replacement:** rename it `no_continuation_value`, retaining its statement and docstring.

| # | Finding | Taken |
|---|---|---|
| 1 | "Wherever anything is at stake" (finding 5, in part) | "where `k_O V + c T` is positive" |
| 2 | `no_continuation` names absence of continuation | `no_continuation_value`, later `Example.valueless` |

## The four-lens review of RF7's module

The module was then reviewed by four readers, one per lens (decision, exactness, readings, fit), each finding checked by a separate reader asked to refute it: 50 findings, 42 confirmed and 8 refuted. The findings and verdicts are in [REVIEW-RF7-LENSES](REVIEW-RF7-LENSES.md), verbatim. The module was rebuilt and renamed `Becoming.ReadStages` for the confirmed ones (47 theorems in 65 declarations), and took most refuted ones too where they improved it.

| # | Lens | Verdict | Finding | Taken |
|---|---|---|---|---|
| D1 | decision | confirmed | the third exit holds only for a deterministic law | the law of drawing afresh (`freshDraw_above_iff`, then `freshDraw_above_iff_chance`); the exit limited to a deterministic law; the lumping carries any chance drawn |
| D2 | decision | confirmed | no witness of a tie at an exit | strict exits with `0 < c T`; `Example.exit_tie`; `choose_of_not_outweighs` |
| D3 | decision | confirmed | "nothing gained after complying" | nothing gained by complying at the unread stage or where the law is not kept |
| D4 | decision | confirmed | gain and loss are not expected values times the total | the two parts of the expected value times the total |
| D5 | decision | refuted | the variations are not shown valid | (refuted) `Example.variants_valid` added |
| D6 | decision | confirmed | "not conditioned on" is narrower than the Lean | keeping not raised by complying (`kept_not_raised`) |
| D7 | decision | confirmed | a docstring refers back to the wrong theorem | every docstring self-contained |
| D8 | decision | confirmed | the witness says "complying when read" only | the plan named, with the four expected values |
| D9 | decision | confirmed | four components mapped onto three conditions | the three conditions mapped; telling the stages apart named apart from them |
| D10 | decision | confirmed | `Conceals` and `no_leverage` name a reading and a financial word | `KeepingOutweighs`, `kept_not_raised` |
| D11 | decision | confirmed | which `Bool` is the read stage | `true` the read stage stated; `K` universe-polymorphic |
| E1 | exactness | confirmed | the ties at the exits have no witness | as D2 |
| E2 | exactness | confirmed | only one plan's optimality is characterized | `ownAtBoth_best_iff` and `unread_comply_not_above`: the four plans classified |
| E3 | exactness | confirmed | the third exit and mixing | as D1 |
| E4 | exactness | confirmed | `Conceals` and the module carry the reading | the module `Becoming.ReadStages`; `KeepingOutweighs` |
| E5 | exactness | confirmed | no theorem for the choice at a tie | `choose_of_not_outweighs` |
| E6 | exactness | confirmed | the invalid witness fails validity on two counts | `Example.no_total`'s docstring names both |
| E7 | exactness | confirmed | as D3 | as D3 |
| E8 | exactness | confirmed | as D4 | as D4 |
| E9 | exactness | confirmed | as D6 | as D6 |
| E10 | exactness | confirmed | "leverage" is a financial word | `kept_not_raised` |
| E11 | exactness | refuted | "continuation" has one glossary sense | (refuted) renamed anyway: `Example.valueless`, `Example.equal_weights` |
| E12 | exactness | confirmed | "Stakes" and "Beats" | `Prospects` and `Above`, RF1's word for an order; `Valuation` was not taken, the core using it for the metaethical valuations |
| E13 | exactness | confirmed | docstrings refer outside themselves | as D7 |
| E14 | exactness | confirmed | as D8 | as D8 |
| E15 | exactness | confirmed | the formation's own order stated as part of the model | the order the prospects give; whose the weights are stated once, as a reading |
| E16 | exactness | confirmed | "no ranking occurs" is literally false | no ethical predicate, ethical ranking or axiom; the order is the prospects' |
| E17 | exactness | confirmed | the lumping's scope written as part of the theorem | stated as a correspondence; the modelling choices name the law as a function of the stage |
| E18 | exactness | refuted | "its loss" in a docstring | (refuted) reworded anyway |
| R1 | readings | confirmed | as D1 | as D1 |
| R2 | readings | confirmed | the reader's levers are claimed but not modelled | the exits are conditions on the assessment and on what the law reads; a reader's acts not modelled |
| R3 | readings | confirmed | two of four correspondences are not §4.2's | the first two conditions represented, the third assumed, telling apart not among them |
| R4 | readings | confirmed | concealing presupposes a recipient | the reading takes the keeping as the reading's evidence of the law; the weights alone fit a reading that knows the law |
| R5 | readings | refuted | details of Greenblatt and others | (refuted) reworded anyway: the cue and the information supplied; a difference of rates |
| R6 | readings | refuted | no choice among uniform plans is declared | (refuted) reworded to cite `uniform_best_iff` |
| R7 | readings | confirmed | which account of deception | Ward and others' definition named, a debt; complying instrumental to being kept |
| R8 | readings | confirmed | the closest precedent and the standing | the Standing: the toy example opening §4, not claimed new |
| R9 | readings | confirmed | whose weights these are | as E15 |
| R10 | readings | confirmed | as E4 | as E4 |
| F1 | fit | confirmed | not joined to RF2 | `plan_realized_iff`, `complyThenOwn_realized_iff`, `read_fixes_unread`, `twin_complyThenOwn`, `kept_alike` |
| F2 | fit | confirmed | as D1 | as D1 |
| F3 | fit | confirmed | nothing on every optimizing choice | `Maximal` (first `Unbeaten`), `only_complyThenOwn_iff`, `complyThenOwn_maximal_iff`; strict exits |
| F4 | fit | confirmed | as R2 | as R2 |
| F5 | fit | refuted | the necessity as theorems | (refuted) taken anyway: `outweighs_needs`, `outweighs_needs_more` |
| F6 | fit | refuted | no Standing, no forbids | (refuted) taken anyway: Standing and What it forbids |
| F7 | fit | confirmed | stage-wise choice not reduced to plans | `unread_comply_not_above` |
| F8 | fit | confirmed | names of the reading and financial words | as E4, E10 and E12 |
| F9 | fit | confirmed | two agents in the framing | the relational framing in the first paragraph and `Act`'s docstring |
| F10 | fit | confirmed | three small gaps | as D2, D7 and D11 |
| F11 | fit | refuted | omissions without homes | (refuted) taken anyway: what the model leaves out, with where each goes |

## The re-check of the renamed module

The rebuilt module was re-checked by the cross-model reader in a fresh session, with the 50 findings and what was taken summarized in its prompt.

Locations refer to `ReadStages.lean`.

1. **Medium — lines 128–129: “the rare defection an evaluation that cannot be told from use invites.”**

   **Problem:** The law establishes an improving probability, without establishing that defection is rare. In the supplied example, every improving probability makes acting by the own law frequent.

   Deriving the correspondence: put \(A=k_OV\), \(B=cT\), \(C=k_CV\), and \(p=m/(m+r)\), with valid prospects and \(m+r>0\). Independent draws assign probabilities \(p^2,p(1-p),(1-p)p,(1-p)^2\) to the four table rows. Therefore
   \[
   TE(p)=(1-p)\bigl(pC+(1-p)A\bigr)-pB,
   \]
   and
   \[
   T\bigl(E(p)-E(\texttt{ownAtBoth})\bigr)
   =p(C-2A-B)-p^2(C-A).
   \]
   For the example this is \(20p-80p^2\), positive exactly when \(0<p<1/4\). Thus its improving plans act by the own law with probability greater than \(3/4\); the witness does so with probability \(7/8\).

   **Replacement:** “Independent draws can improve on `ownAtBoth` without distinguishing the stages. The theorem establishes the existence of an improving compliance probability; it establishes no rarity of defection.”

2. **Medium — lines 118–122: “Their necessity for strict optimality is proved here (`outweighs_needs`).”**

   **Problem:** The antecedent refers to Hubinger et al.’s conditions, including possessing a model of selection and its objective. `outweighs_needs` proves only \(V>0\) and \(k_O<k_C\). There is no predicate for possessing that model. Even when the numbers represent an assessment, knowing how selection works is different from assessing compliance as increasing retention. The source’s second condition concerns the former. [Hubinger et al., §4.2](https://arxiv.org/html/1906.01820v3#S4.SS2)

   **Replacement:** “Under this reading, `outweighs_needs` proves that strict optimality requires positive unread-stage value and an assessed increase in retention from complying. These are numerical counterparts of parts of the first two conditions; possession of the model described by the second condition is not represented or proved necessary.”

3. **Medium — lines 135–137: “a keeping not raised by complying is … reading the law rather than keeping or changing it by the acts there.”**

   **Problem:** \(k_C\leq k_O\) specifies a comparison of weights, not how selection obtains them. Constant retention, random retention independent of acts, and selection favoring the own act all satisfy it. None requires inspecting the law. Moreover, `kept` expressly depends only on the read-stage act.

   **Replacement:** “Keeping not raised by complying means only that the supplied weights do not favor compliance. Whether selection inspects the law, uses acts, or uses other information is not represented.”

4. **Medium — line 253 and the `mixed_*` declarations: `MixedAbove`.**

   **Problem:** In the cited decision-theoretic terminology, this is a **behavioural** strategy. Piccione and Rubinstein distinguish fresh independent randomization from a mixed strategy, which randomizes initially over feasible pure strategies. Here the feasible stage-indistinguishable pure strategies are the two uniform plans. A mixture of those cannot improve on `ownAtBoth`, whereas the represented fresh draws can. The name obscures precisely the distinction responsible for the result. [Piccione and Rubinstein, §4](https://arielrubinstein.org/papers/53.pdf)

   **Replacement:** `FreshDrawAbove`, with corresponding `freshDraw_*` names; alternatively `BehaviouralAbove` for the decision-theoretic vocabulary.

5. **Low — lines 81–83: “raises the threshold … and removes any difference between the stages’ behaviour.”**

   **Problem:** The threshold increases by \(k_OV\), which can be zero even for valid prospects satisfying the mixed inequality. Also, equal act distributions do not imply equal realized acts: independent draws differ with probability \(2p(1-p)\).

   **Replacement:** “Under fresh independent draws with one compliance probability at both stages, the improvement threshold becomes `2 k_O V + c T`, an increase of `k_O V` that can be zero. The stages have the same act distribution, although their realized acts can differ.”

6. **Low — lines 675–677: “`1040 < 1120`, the expected values `9/8` and `1` times `64 T`.”**

   **Problem:** \(64T=640\). The scaled **net** expected values are \(720\) and \(640\), giving \(640<720\). The displayed \(1040<1120\) adds the scaled mixed-plan loss, \(400\), to both sides. Its sides are not the scaled net expected values.

   **Replacement:** “The expected values are `9/8` and `1`. Multiplication by `64 T` gives `640 < 720`; adding the scaled loss `400` to both sides gives the subtraction-free comparison `1040 < 1120`.”

7. **Low — lines 59–60, 388–396: “With a positive loss … stands above …”**

   **Problem:** The actual hypothesis is \(0<cT\), not merely \(0<c\). Neither strict-exit theorem assumes `Valid`. With `total = 0`, `cost = 1`, and both retention weights and value zero, the stated loss is positive but the plans tie.

   **Replacement:** “With positive scaled loss `0 < c T` …”. Alternatively: “For valid prospects, with positive loss `0 < c` …”.

8. **Low — line 236 and its uses: `Unbeaten`.**

   **Problem:** Under the repository’s structural naming rule, this retains the contest metaphor of the retired `Beats`. The definition is the order-theoretic condition that no element lies strictly above the given plan.

   **Replacement:** `Maximal`, with `complyThenOwn_maximal_iff` and corresponding references.

9. **Low — lines 143–144: “Ward, Toni, Belardinelli and Everitt (2023).”**

   **Problem:** The paper’s author order is Ward, **Belardinelli, Toni**, Everitt. [Paper title and author list](https://arxiv.org/html/2312.01350v1)

   **Replacement:** “Ward, Belardinelli, Toni and Everitt (2023).”

| # | Finding | Taken |
|---|---|---|
| 1 | "The rare defection": the improving chances of complying are small | dropped; the improving chances stated exactly (`freshDraw_above_iff_chance`, through `freshDraw_reduce`), with a witness of where the gain stops (`Example.freshDraw_boundary`); nothing makes complying, or acting by its own law, rare |
| 2 | The necessity claimed is beyond `outweighs_needs` | numerical counterparts of parts of the first two conditions; possessing the model of the selection neither represented nor proved necessary |
| 3 | Keeping not raised by complying does not say the selection reads the law | it says only that the weights do not favour complying |
| 4 | `MixedAbove` is a behavioural plan, not a mixed one | `FreshDrawAbove` and `freshDraw_*`; a single draw between the uniform plans as `MixtureAbove`, which never gains (`mixture_never_above`); the Standing names behavioural against mixed strategies |
| 5 | The threshold's rise can be nothing; equal distributions are not equal acts | both said |
| 6 | `Example`'s scaled values are not the net expected values | 720 and 640, the stated comparison adding the scaled loss 400 |
| 7 | The strict exits' hypothesis is `0 < c T` | stated so |
| 8 | `Unbeaten` keeps a contest word | `Maximal`, with `complyThenOwn_maximal_iff` and `unread_comply_not_above` |
| 9 | Ward and others' author order | Ward, Belardinelli, Toni and Everitt (2023) |

The module was rewritten for the nine (52 theorems in 71 declarations) and the session continued for a re-check:

**Verdict: All nine findings were taken correctly. Read-only inspection found no new error or overstatement introduced by the rewrite.**

1. **Taken correctly** — The rarity claim is removed; `freshDraw_reduce` and `freshDraw_above_iff_chance` give the stated comparison with the necessary `0 < m` hypothesis (lines 588–625).
2. **Taken correctly** — Numerical necessity is explicitly distinguished from possessing a model of selection (lines 128–132).
3. **Taken correctly** — Non-increasing retention weights no longer imply any particular selection mechanism (lines 147–148).
4. **Taken correctly** — `FreshDrawAbove` describes independent behavioural draws; `MixtureAbove` and `mixture_never_above` correctly handle a single draw between uniform plans (lines 258–272, 681–686).
5. **Taken correctly** — The threshold increase may be zero, and equal act distributions are distinguished from equal realized acts (lines 85–87).
6. **Taken correctly** — The example distinguishes scaled net values `720` and `640` from the cross-added comparison `1040 < 1120` (lines 742–746).
7. **Taken correctly** — Both strict-exit docstrings and the header state `0 < c T` (lines 59–60, 405–415).
8. **Taken correctly** — `Maximal` and the renamed declarations retain the intended propositions and consistent documentation (lines 245–246, 312–319, 370–373).
9. **Taken correctly** — The citation now gives Ward, Belardinelli, Toni and Everitt in the correct order (line 154).

## The cold read of RF7's texts

Before RF7's landing its texts were cold-read against the Lean, as integrated on main in a rehearsal worktree: 03 §11 and its Reading, 03's opening of §11 and Open, the record in both languages, the study section, the module's header, the root bullet, the checker's scope sentence, the package rows, 07's row, 08's bullet, the overview, the dossier, the plan, regions and the board's text. Two reads ran: the cross-model reader, read-only in a fresh session, and a workflow of three readers, one per lens (exactness, readings, fit), each finding given to a separate reader asked to refute it. The prompts are in [BRIEF](BRIEF.md#round-2).

### The cross-model reader

Its findings, verbatim, with its links to the rehearsal worktree made repository-relative:

**Verdict: Needs textual revision. The fixed-chance equivalence loses a required hypothesis, and several summaries blur strict optimality and ties.**

1. **Medium — Missing `0 < m` makes the stated equivalence false.** Locations: [03-KNOWING.md:474](../../../../../../../theories/becoming/chapters/03-KNOWING.md); [make_records_rf7.py:195–200](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py).

   **Quoted:** “complying with chance `m / (m + r)`, stands above … exactly where `(m + r) (k_O V + c T) + r k_O V < r k_C V`”; Chinese: “以 m/(m+r) 之机从之律……恰当……”.

   **Problem:** `freshDraw_above_iff_chance` explicitly requires `0 < m`. On `Example.prospects`, with `m = 0`, `r = 1`, the displayed reduced inequality is `70 < 90`, but `FreshDrawAbove 0 1` is `10 < 10`. Zero compliance probability simply gives `ownAtBoth`.

   **Replacement:** “For `0 < m`, a law drawing independently at each stage and complying with chance `m/(m+r)` stands above acting by its own law at both exactly where `(m+r)(k_O V+c T)+r k_O V < r k_C V`.”

   **Chinese:** “当 `0 < m` 时，每阶独立重抽其行、以 `m/(m+r)` 之机从之律，居二阶皆依己律之上，恰当 `(m+r)(k_O V+c T)+r k_O V < r k_C V`。”

2. **Medium — “Best exactly where” needs “uniquely best.”** Locations: [THE-THEORY-OF-BECOMING.md:96](../../../../../../../theories/becoming/THE-THEORY-OF-BECOMING.md), [ALIGNMENT.md:28](../../../../../../../theories/becoming/review/ALIGNMENT.md), package [README.md:198](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.md), [README.zh.md:144](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.zh.md), and [PLAN.md:178](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md).

   **Quoted:** “is best … exactly where”; “a formation’s best plan among four exactly where”; “best exactly where”; “最优恰当”.

   **Problem:** The strict inequality characterizes the **unique** optimum. `complyThenOwn_maximal_iff` includes equality. In `Example.tie`, both `complyThenOwn` and `ownAtBoth` have expected value `1`, exceeding the other plans’ `−8` and `0`. Thus `complyThenOwn` is still a best plan at equality.

   **Replacement:** Change the respective clauses to “is uniquely best among the four plans exactly where …” or “stands strictly above every other plan exactly where …”. Retain each location’s existing inequality.

   **Chinese:** Replace “最优恰当” with “于四策中唯一最优，恰当”.

3. **Low — The record’s “there” ambiguously sends `choose` into the equality case.** Location: [make_records_rf7.py:170–173](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py).

   **Quoted:** “that plan is maximal exactly where `k_O V + c T` is at most `k_C V`; the choice taking it there …”; Chinese: “此策为极大，恰当……不逾……；此处择之……”.

   **Problem:** The nearest antecedent of “there”/“此处” is the weak inequality. But `Prospects.choose` takes `complyThenOwn` only under the strict inequality; equality selects `ownAtBoth`. The trailing “ties included” does not clearly repair that antecedent.

   **Replacement:** “That plan is maximal exactly where `k_O V+c T ≤ k_C V`. The choice taking it where `k_O V+c T < k_C V`, and taking `ownAtBoth` otherwise, including equality, is maximal.”

   **Chinese:** “此策为极大，恰当 `k_O V+c T ≤ k_C V`。于 `k_O V+c T < k_C V` 处择此策、否则择二阶皆依己律（相等亦然）之择，为极大。”

4. **Low — The scope box’s categorical exclusion contradicts its updated contents.** Location: [ALIGNMENT.md:19–21](../../../../../../../theories/becoming/review/ALIGNMENT.md).

   **Quoted:** “**What the theory does not address** … It says nothing of: … **deception** and deceptive alignment, which the theory reaches in RF’s readings …”.

   **Problem:** RF7 now supplies a conditional incentive comparison, explicitly acknowledged in the same box. The remaining omission is full deception, including belief and intention, rather than everything concerning deceptive alignment.

   **Replacement:** Change the heading to “**Limits of the theory’s treatment**” and the list introduction to “The following questions remain open in whole or in part:”.

5. **Low — The Chinese hypotheses omit the single-draw alternative.** Location: [make_records_rf7.py:213–217](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py).

   **Quoted:** English ends “or a chance drawn afresh and independently at each stage, **or one draw before the read stage**.” Chinese ends “或每阶独立重抽一机。”

   **Problem:** The Chinese omits the alternative represented by `Prospects.MixtureAbove` and `mixture_never_above`, although its laws summarize that comparison.

   **Replacement:** Keep the English. Replace the Chinese ending with: “或每阶独立重抽一机，或于读之阶前仅抽一次，以择二阶皆从或二阶皆依己律。”

| # | Finding | Taken |
|---|---|---|
| A1 | the fresh-draw law at a given chance drops `0 < m` | “for `0 < m`” in 03 §11 and the record’s eighth law, English and Chinese |
| A2 | “best exactly where” a strict inequality needs “uniquely best” | “uniquely best” in the overview, the dossier, both package READMEs (于四策中唯一最优), the plan and the board, and in 03’s opening and 07’s row |
| A3 | the record’s “there” can point to the weak inequality | “the choice taking it where keeping outweighs the loss”, English and Chinese |
| A4 | the scope box’s “says nothing of” contradicts its RF7 sentence | “It says nothing, or only part, of:”; the deception bullet reworded (R19, F28) |
| A5 | the Chinese hypotheses omit the single draw | added: 或于读之阶段前仅抽一次，以择两阶段皆从或两阶段皆依己律 |

### The three lenses

80 findings, 75 confirmed and 5 refuted; several repeat the cross-model reader's, the workflow having read the texts before those were taken. The findings and verdicts are in [REVIEW-RF7-COLDREAD](REVIEW-RF7-COLDREAD.md). Every confirmed finding was taken, the module's prose included: its statements unchanged, it was rebuilt with every axiom report empty (`kit/round2/logs/r7-build-6.log`). The source's §4.5 and glossary were checked against the paper's text (arXiv 1906.01820v3) before they were credited.

| # | Lens | Verdict | Finding | Taken |
|---|---|---|---|---|
| E1 | exactness | confirmed | 03 §11 drops `0 < m` | as A1 |
| E2 | exactness | confirmed | the record’s eighth law drops `0 < m` | as A1 |
| E3 | exactness | confirmed | 03 §11 uses `T`, `k_C`, `k_O`, `V`, `c` undefined | the letters given in the prospects’ sentence |
| E4 | exactness | confirmed | the record uses the letters undefined | the first law gives them, English and Chinese |
| E5 | exactness | confirmed | the statement’s “a chance drawn afresh gains” is universal and names nothing compared | the statement in natural numbers: some chance of complying drawn afresh at each stage stands above acting by its own law at both |
| E6 | exactness | confirmed | 03’s opening puts the reading “a formation’s own best plan” in the law | uniquely best among four plans in the order given prospects give; the prospects as a formation’s own a reading (below) |
| E7 | exactness | confirmed | 07’s row says the same under “the laws say” | the row: the laws say nothing of deception, which needs a belief and an intention; the two results read [AI reading] as deception’s possibility and the incentive |
| E8 | exactness | confirmed | 08’s bullet presents the reading as what it restates and omits the fresh draw’s precedent | the bullet generalizes §4’s toy; the incentive a labelled reading; §4.5 and Piccione and Rubinstein credited |
| E9 | exactness | confirmed | the record files `lumped_determines` under RF2 | dependencies split: `Lumped` and `lumped_determines` on generalization through lumping, `twin_selected` on RF2; the seventh law names each |
| E10 | exactness | confirmed | the record’s scope item asserts “this is the incentive” unlabelled | dropped; the incentive named only in the correspondence’s reading |
| E11 | exactness | confirmed | the Chinese hypotheses omit the single draw | as A5 |
| E12 | exactness | confirmed | 二阶 means “second order” in this repository | 两阶段 throughout the Chinese texts |
| E13 | exactness | confirmed | the module calls `lumped_determines` and `lumped_uniform` RF2’s | the module: generalization through lumping, which RF2 reads; only the twin RF2’s |
| E14 | exactness | confirmed | “RF2’s twin and fixing” in the root bullet, checker, study and plan | “`Unread`’s twin and `Learning`’s fixing”; “RF2’s twin and the lumping’s fixing” |
| E15 | exactness | confirmed | the root bullet mixes the probability and natural-number framings; the realized law is existential | the natural-number form first, the probability reading after; “open to some act law”; `true` the read stage |
| E16 | exactness | confirmed | Unread’s root bullet still says “A leaf” | “Imported by `Becoming.ReadStages`” |
| E17 | exactness | confirmed | 03’s Open names §11 “its incentive” unlabelled | “beyond when complying when read is uniquely best (§11, read there as deceptive alignment’s incentive)” |
| E18 | exactness | confirmed | the dossier’s “RF7 adds the incentive” unlabelled, the letters undefined | “adds what RF reads as the incentive deceptive alignment names [AI reading]”; the fresh-draw threshold in words |
| E19 | exactness | confirmed | the overview omits “where valid” and defines no letter | “read as probabilities where valid”; the threshold in words |
| E20 | exactness | confirmed | the threshold’s letters undefined in 08, the root bullet, the checker, the plan, the board and the study | defined in the root bullet, the checker, the plan and the study; in words on the board, the overview and the dossier; 08 in 03 §11’s terms |
| E21 | exactness | confirmed | the board’s “still gains” names no chance or comparison | “does better than acting by its own law at both, with some chance of complying, exactly where …”, in words |
| E22 | exactness | confirmed | the study puts 08’s counts in §8 | “08 §8’s known results and §3’s counts” |
| E23 | exactness | refuted | REVIEW-ROUND2 has no RF7 section | (refuted: in the kit); this section added |
| E24 | exactness | confirmed | the validation names `mul_assoc_nat`, used only through `mul_turn`, and not `Naturals.two_mul` | `mul_turn` (through `mul_assoc_nat`), `add_mul_split` and `Naturals.two_mul`; the Chinese 不用 omega |
| E25 | exactness | confirmed | the next step names the plan’s TR2, RF2’s test | a frozen test of whether complying when read follows the value and the rise in being kept (none yet) |
| E26 | exactness | confirmed | the correspondence’s “proved necessary” says not for what | “strict optimality needs numerical counterparts of parts of the two” |
| E27 | exactness | refuted | the alias “concealment” is not what the statement means | (refuted: no rule asks it); taken with R17 and F15 all the same |
| E28 | exactness | refuted | “stage” has another sense in the glossary | (refuted: the word is used so in practice); not taken |
| E29 | exactness | confirmed | “without either” reads as “lacking both” | “with either absent”, the first two exits named |
| E30 | exactness | confirmed | the witness’s “valid” and “best” cite no declaration | `Example.valid` and `Example.best` cited |
| E31 | exactness | confirmed | the board’s review sentence says every finding taken | land7 replaces it: RF7’s four-lens review, every confirmed finding taken |
| R1 | readings | confirmed | 03’s Reading credits only §4.2; §4.5 already treats the stages not told apart, as an absent-minded driver | §4.5 and the absent-minded driver credited (Aumann, Hart and Perry; Piccione and Rubinstein); “reached by another route” restored |
| R2 | readings | confirmed | 08’s bullet credits neither §4.5 nor the absent-minded driver | both credited; what it adds stated as the exact threshold and the improving chances |
| R3 | readings | confirmed | the module’s Standing omits §4.5; “imperfect recall” too broad | the Standing and Readings credit §4.5; “under absent-mindedness, the imperfect recall in which one information set holds two stages of one course” |
| R4 | readings | confirmed | the module places the source’s “deceptive” in being instrumental | being instrumental is instrumental proxy alignment; what is deceptive, seeming fitter to the base optimizer than it is, the concealment premise |
| R5 | readings | confirmed | “the weights represent the second, a model of the selection” | “stand for what the second condition’s model is of … not for the model” (module, 03, record) |
| R6 | readings | confirmed | the record’s correspondence: the fresh draw uncredited, the model, necessary for what | the correspondence opens with the prior art (§4, §4.5, Piccione and Rubinstein); “what the second’s model is of”; “strict optimality needs” |
| R7 | readings | confirmed | the study’s Standing omits §4.5; “imperfect recall” | as R3, in the study |
| R8 | readings | confirmed | 03’s opening: “a formation’s own best plan” | as E6 |
| R9 | readings | confirmed | 07’s row: the deception readings unlabelled | as E7 |
| R10 | readings | confirmed | the dossier lists the exits bare, as levers; the third condition and §4.5 missing | exits as conditions on the formation’s prospects, not levers; the third condition assumed; §4.5’s remark credited |
| R11 | readings | confirmed | for the first condition the agreement with §4.2 is the choice’s tie-break | said in the module and 03’s Reading |
| R12 | readings | confirmed | 03 §11 drops `0 < m` | as A1 |
| R13 | readings | confirmed | 03’s Open names the incentive unlabelled | as E17 |
| R14 | readings | confirmed | the validation’s lemma list | as E24 |
| R15 | readings | confirmed | the Chinese hypotheses omit the single draw | as A5 |
| R16 | readings | confirmed | the statement’s “a chance … gains” | as E5 |
| R17 | readings | confirmed | the aliases “concealment”, 隐 name the reading the rename removed | aliases: the title, “four plans in two stages”, “deceptive alignment”; concealment a scope item the record does not show |
| R18 | readings | confirmed | the next step names RF2’s TR2 | as E25 |
| R19 | readings | confirmed | the scope box’s lead contradicts its deception bullet | bullet: “which its laws do not represent: RF’s readings reach …”; the lead as A4 |
| R20 | readings | confirmed | the plan’s literature row still calls the incentive owed | the row: §4’s toy with weights, §4.5’s random defection with an exact threshold, the third condition assumed, the rates empirical |
| F1 | fit | confirmed | 03 §11 drops `0 < m` | as A1 |
| F2 | fit | refuted | REVIEW-ROUND2 has no RF7 sections | (refuted: in the kit); this section added |
| F3 | fit | confirmed | 03 §11’s letters undefined | as E3 |
| F4 | fit | confirmed | 03, 07 and the dossier present the order as the formation’s own | as E6 and E7; the dossier: uniquely best in the order given prospects give |
| F5 | fit | confirmed | six summaries say “best” where uniquely best | as A2 |
| F6 | fit | confirmed | six texts credit the fixing to RF2 | as E9, E13 and E14 |
| F7 | fit | confirmed | the overview and dossier: letters undefined, no comparison, “exactly” dropped | in words, against acting by its own law at both, “exactly where” |
| F8 | fit | confirmed | the record’s letters and “gains” | as E4 and E5 |
| F9 | fit | confirmed | 08’s bullet “restates” where the module generalizes; Piccione and Rubinstein omitted | as E8 |
| F10 | fit | confirmed | 03’s “the first two exits” refers to exits never named | the theorem names them: the first two, and for a deterministic law a lumping tying the stages the third |
| F11 | fit | confirmed | RF2’s record names RF7’s step as its next | RF2’s next step drops it, its scope item points here, and the two records are related |
| F12 | fit | confirmed | the record’s correspondence lacks the prior art and says not what is necessary for what | as R6 |
| F13 | fit | confirmed | “this is the incentive” unlabelled in the record, 03 and the dossier | as E10, E17 and E18; 03’s Reading ends “this is at most an incentive, not deception in full” |
| F14 | fit | confirmed | 08 uses the code RF2, undefined terms and a hard parse | named “what readings fix of the unread”; what the plan needs stated; the letters in 03 §11’s terms |
| F15 | fit | confirmed | the aliases make concealment a name again; no title alias | as R17 |
| F16 | fit | confirmed | the next step: TR2, and two items the module sends onward missing | as E25, with a recipient’s belief and intention and installation added |
| F17 | fit | confirmed | the plan goes stale: the literature row, §4’s intro, §4.5’s heading, §4.6’s intro, the bullets’ order | all brought to the landing; RF7’s bullet after RF6.1’s; `q_M T` and `q_H T` named as the weights |
| F18 | fit | confirmed | the board’s review sentence is a no-op for land7 | as E31, the replacement asserted |
| F19 | fit | confirmed | the study’s list of the first review’s seven findings is wrong, the last re-check missing | the list corrected; “A further re-check found all nine taken correctly and nothing new.” |
| F20 | fit | confirmed | three English–Chinese differences in the record | the single draw, “at each stage” in the ninth law, 不用 omega |
| F21 | fit | confirmed | the record’s “there” | as A3 |
| F22 | fit | confirmed | “without either” | as E29 |
| F23 | fit | confirmed | “does not remove complying when read” reads as if the plan survived | “leaves a gain from complying with some chance at each stage” |
| F24 | fit | confirmed | a bare §4.2 in 03; one label for two documents in the study | “their §4.2”; “the plan’s §4.2” |
| F25 | fit | confirmed | “reading” in two senses in one sentence | “the selection’s keeping”, “a selection that knows the law” (module, 03, record) |
| F26 | fit | confirmed | one plan carries five names | “its own law” in the module’s title and the package texts; the full name in 03’s opening and Reading, 07, the dossier and regions |
| F27 | fit | refuted | the README row’s form | (refuted: its siblings’ form); not taken |
| F28 | fit | confirmed | the box’s lead, “RF7” without its round, and no account of RF’s additions | “Round 2’s RF7”; an entry for RF’s additions in “How it was made”; the lead as A4 |
| F29 | fit | confirmed | “debt” and “defeats” in the module | “stays open”, “the plan’s open item on deception”, “stands above” |

### The re-check of what was taken

The cross-model reader then re-checked, read-only in a fresh session on a new rehearsal (main at `6645a2fae` with the kit integrated), how the texts took the 80 confirmed points ([BRIEF](BRIEF.md#round-2)). Its findings, verbatim, with its links to the rehearsal made repository-relative:

**Verdict: minor textual revision remains—76 of 80 confirmed findings are taken correctly; A4, E8, F24 and F28 are taken in part, with three further problems below.**

Confirmed findings still incomplete:

1. **A4 — scope-box heading.** [ALIGNMENT.md:19](../../../../../../../theories/becoming/review/ALIGNMENT.md), reproduced by the integration kit.
   **Quote:** “What the theory does not address”.
   **Problem:** The introduction now allows partial treatment, but the categorical heading remains.
   **Replacement:** “Limits of the theory’s treatment”.

2. **E8 — one reading premise still missing.** [08-METHOD.md:485](../../../../../../../theories/becoming/chapters/08-METHOD.md); `integrate_rf7.py:148–149`.
   **Quote:** “read as the formation’s own assessment, it is the incentive deceptive alignment names”.
   **Problem:** The label and attribution are repaired, but whose assessment it is does not supply concealment. The module explicitly admits informed selection rewarding compliance.
   **Replacement:** “With the prospects read as the formation’s own assessment and the concealment premise of 03 §11 supplied, this represents deceptive alignment’s incentive [AI reading].”

3. **F24 — the study’s section references remain ambiguous.** [study_rf7.txt:80](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt).
   **Quote:** “the third of §4.2’s conditions”.
   **Problem:** The study still uses bare §4.2 for the paper after explicitly naming the plan’s §4.2.
   **Replacement:** Qualify the three occurrences in this paragraph as “Hubinger and others’ §4.2”.

4. **F28 — the new provenance entry overstates review coverage.** [ALIGNMENT.md:41](../../../../../../../theories/becoming/review/ALIGNMENT.md); `integrate_rf7.py:203–205`.
   **Quote:** “each cold-read … before its landing”.
   **Problem:** Round 1’s recorded review found the dossier update absent and proposed it for the merge; it does not establish a cold read of that resulting text before its landing.
   **Replacement:** “The first round-2 cold read covered the assistance bullet and first-landing sentence; RF7’s cold read covered the scope box and paragraph on RF’s rounds.”

Further problems:

5. **The threshold increase has the wrong units.** [08-METHOD.md:485](../../../../../../../theories/becoming/chapters/08-METHOD.md); `integrate_rf7.py:153–154`.
   **Quote:** “raised by the expected value … (from `k_O V + c T` to `2 k_O V + c T`)”.
   **Problem:** The displayed increase is `k_O V`; the expected value is `k_O V / T`.
   **Replacement:** “raised by `k_O V`, the expected value of acting by its own law at both multiplied by the total”.

6. **The chapter’s concealment premise is weaker than its new glossary claim.** [03-KNOWING.md:484](../../../../../../../theories/becoming/chapters/03-KNOWING.md), `s11_rf7.txt:4`; [make_records_rf7.py:267](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py).
   **Quote:** “seeming fitter … is the concealment premise above”; that premise merely treats the act “as … evidence of the … law”.
   **Problem:** Evidence can be accurate. Unlike the module, the chapter and record omit the counterfactual that revealing the law would reduce keeping. The new identification therefore does not follow. [Hubinger et al., §7.4](https://arxiv.org/html/1906.01820v3#S7.SS4) requires apparent fitness exceeding actual fitness.
   **Replacement:** Add to the chapter’s premise: “so that a selection shown the law would keep it less”. In the record, replace its evidence clause with “taking compliance to make the law seem fitter to the selector than it is”.

7. **The plan implies that RF7 converts the RuleShaping analogy into an instance.** [PLAN.md:127](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md); `integrate_rf7.py:230–231`.
   **Quote:** “It stays an analogy until RF7 states … which it does”.
   **Problem:** RF7 supplies a separate comparison, no RuleShaping instance or equivalence.
   **Replacement:** “The connection to RuleShaping remains an analogy; RF7 supplies the separate two-stage comparison (§4.6), with disclosure and concealment as labelled readings.”

| # | Finding | Taken |
|---|---|---|
| 1 (A4) | the scope box's label stays categorical | “What the theory does not address, or addresses only in part” |
| 2 (E8) | 08's reading names the incentive without the concealment premise | “with the prospects read as the formation’s own assessment and the concealment premise of 03 §11 taken, it is the incentive deceptive alignment names [AI reading]” |
| 3 (F24) | bare §4.2s in the study’s review paragraphs | each “Hubinger and others’ §4.2” |
| 4 (F28) | the dossier’s entry says each RF sentence was cold-read before landing | round 1’s sentence drafted from a cold-read finding and written at the merge; round 2’s first sentence cold-read before landing; RF7’s cold read read the whole box |
| 5 | 08’s threshold rise in the wrong units | “raised by `k_O V`, the expected value of acting by its own law at both times the total” |
| 6 | the concealment premise in 03 and the record is weaker than the source’s sense of deceptive | 03: “so that a selection shown the law would keep it less”; the record: “taking compliance to make the law seem fitter to the selection than it is, a selection shown the law keeping it less”, in its correspondence and its scope item; the study’s Boundary likewise |
| 7 | the plan reads RF7 as turning the analogy with RuleShaping into an instance | “The connection to RuleShaping stays an analogy; RF7 states the separate two-stage comparison (§4.6), with disclosure and concealment as labelled readings.” |

The same session, continued on the rebuilt rehearsal, checked the seven ([BRIEF](BRIEF.md#round-2)):

**Verdict: all seven findings are now taken correctly in the integrated texts and kit; I found no new error or overstatement introduced by the fixes.**

### The final check through three lenses

After the re-check, a workflow of three readers read the final texts, one per lens (exactness against the Lean; sources and readings, with the paper's text and the cited works; the Chinese edition and fit), each lens's findings checked by a separate reader asked to refute them: 50 findings, 42 confirmed and 8 refuted. The findings and verdicts are in [REVIEW-RF7-FINAL](REVIEW-RF7-FINAL.md); the prompts in [BRIEF](BRIEF.md#round-2). Every confirmed finding was taken, the module's prose included (rebuilt with every axiom report empty, `kit/round2/logs/r7-build-7.log`).

| # | Lens | Verdict | Finding | Taken |
|---|---|---|---|---|
| X1 | exactness | confirmed | the twin drops reading through the lumping (03, record law 7, study) | a law reading through the lumping, and a twin reading through it, in all three |
| X2 | exactness | confirmed | “gain” in two senses; the fresh draw compared with a mixture | standing above acting by its own law at both, in 03, the record, the study, the module’s Standing, 08 and the plan |
| X3 | exactness | confirmed | the module header’s “an act law … takes a plan exactly where” | “a plan is open to some act law … exactly where” |
| X4 | exactness | confirmed | the root bullet and the checker give the fresh-draw law to any law | “a law that cannot tell the stages apart but draws its act afresh” |
| X5 | exactness | confirmed | law 3’s Chinese 居其上 reads “above complying when read” | 居他策之上 |
| X6 | exactness | confirmed | the validation and the dependency omit Determines, Training.Through, AgreeOn | both list them, in both languages |
| X7 | exactness | confirmed | law 6 uses “the plan” in two senses | “so the plan, not uniform, is open exactly where the lumping tells them apart” |
| X8 | exactness | confirmed | 03’s Reading restates RF2 without its hypotheses | the lumping, being in the lump decided, and laws reading through it |
| X9 | exactness | confirmed | lemmas cited under the wrong theorems; `complyThenOwn_maximal_iff` misattributed | each lemma under the proof that uses it (study, module header); the maximal law stated with its ≤ |
| X10 | exactness | confirmed | the plan’s threshold off by the total | “exceeds the loss times the total (read as probabilities, the loss)” |
| X11 | exactness | confirmed | RF2’s new related entry sets RF2 in two stages | “Its twin and the fixing at two stages, read and unread, with prospects …” |
| X12 | exactness | confirmed | the English hypotheses omit what the single draw chooses between | “between complying at both stages and acting by its own law at both” |
| X13 | exactness | confirmed | the history’s Chinese drops the mixture and writes 每阶 | 每阶段重抽其行而较之单一混合; law 2’s 不读之阶段 |
| S1 | sources | confirmed | RF2’s record calls telling the occasion apart a necessary condition of deceptive alignment, which §4.5 denies for a law drawing afresh | RF2’s correspondence: for a deterministic law; a law drawing afresh can stand above without telling the stages apart (§4.5); the plan’s row likewise |
| S2 | sources | confirmed | 07’s row reads RF2’s law as “deception’s possibility”, the incentive without premises | where a deterministic law can act otherwise unread, as deceptive alignment describes; the incentive with the concealment premise and the formation’s own assessment |
| S3 | sources | confirmed | the dossier gives the incentive without its premises | the formation’s own assessment and the concealment premise stated |
| S4 | sources | confirmed | the overview gives the incentive without the concealment premise | the premise stated |
| S5 | sources | confirmed | RF2’s history says disclosure or concealment is done | the two-stage comparison stated there, disclosure and concealment readings of it |
| S6 | sources | refuted | “an absent-minded driver’s” where the source says “similar to” | (refuted: a paraphrase) taken all the same: “in their words, similar to” |
| S7 | sources | refuted | the Greenblatt sentence fits one of two settings | (refuted: true of the settings it describes); not taken |
| S8 | sources | refuted | 08’s reading omits the third condition | (refuted: a modelling assumption, not a premise of the reading); not taken |
| S9 | sources | confirmed | the study’s Standing gives the incentive without premises | the formation’s own assessment and the concealment premise stated |
| S10 | sources | confirmed | the twin drops reading through the lumping | as X1 |
| S11 | sources | refuted | 欺骗式对齐 against RF2’s 欺骗对齐 | (refuted: a matter of translation) taken with Z11 |
| Z1 | zh-and-fit | confirmed | RF2’s history says disclosure or concealment is done | as S5 |
| Z2 | zh-and-fit | confirmed | 择 for both the choice and the selection in the Chinese | 选择 for the selection; 择 kept for the choice |
| Z3 | zh-and-fit | confirmed | the dossier’s AJ5 entry says no independent reader read the box; the works-cited line | the box read whole by RF7’s cold read; RF7’s cited work checked as RF’s entry says |
| Z4 | zh-and-fit | confirmed | law 2’s Chinese 不读之阶 | 不读之阶段 |
| Z5 | zh-and-fit | confirmed | the history’s Chinese 每阶 and the mixture | as X13 |
| Z6 | zh-and-fit | confirmed | “gain” in two senses | as X2 |
| Z7 | zh-and-fit | confirmed | law 3’s Chinese 居其上 | as X5 |
| Z8 | zh-and-fit | confirmed | law 6 and the related field use “the plan” in more than one sense | as X7; the related field: “The earlier analogy for concealment in RF’s plan” |
| Z9 | zh-and-fit | confirmed | the hypotheses’ English and Chinese differ | as X12 |
| Z10 | zh-and-fit | confirmed | the English README row omits “among four plans” | added |
| Z11 | zh-and-fit | confirmed | 欺骗式对齐 against RF2’s 欺骗对齐 | 欺骗对齐 in the alias and the correspondence |
| Z12 | zh-and-fit | confirmed | 有毯律 for a blanketed law | 毯化之律 |
| Z13 | zh-and-fit | confirmed | “the selection a reading applies, is a reading”: two senses | “the selection applied at the read stage” (record, study, module header) |
| Z14 | zh-and-fit | confirmed | the plan’s “keeps a gain” and the q_M mapping’s place | standing above acting by its own law at both; the mapping tied to the first threshold |
| Z15 | zh-and-fit | confirmed | the plan’s literature row uses bare §4 and §4.5 for the paper | “their §4’s”, “their §4.5’s” |
| Z16 | zh-and-fit | confirmed | the plan’s §5 row still calls deceptive alignment an analogy until RF7 | deceptive alignment’s incentive a reading of RF7’s comparison, the continuation value represented |
| Z17 | zh-and-fit | confirmed | the plan’s Evidence line and §4.6 intro say one review, every finding taken | each round’s review, re-checks and four lenses for RF7; every confirmed finding taken |
| Z18 | zh-and-fit | confirmed | the plan’s §4.4 heading, §12’s line on AJ5’s box and the board’s cell are stale | all three built; RF’s landed results named, with links; the board cell in land7 |
| Z19 | zh-and-fit | refuted | 03’s Open shortens the plan’s name | (refuted: the record’s handle); not taken |
| Z20 | zh-and-fit | refuted | the overview’s “doing so is its own best plan” | (refuted: in a labelled reading, nothing false); not taken |
| Z21 | zh-and-fit | confirmed | “the own law” used as a plan’s name | “acting by its own law at both” (record law 9, its counterexample, the study) |
| Z22 | zh-and-fit | confirmed | the output list and the re-pointing reason omit §4.5’s heading | both now list every plan section RF7 edits |
| Z23 | zh-and-fit | refuted | the nine-point re-check given the other section’s name | (refuted: the description is accurate); not taken |
| Z24 | zh-and-fit | confirmed | the module header’s generic “an act law” | as X3 |
| Z25 | zh-and-fit | refuted | the field `cost` beside “the loss” | (refuted: established in the core, no wrong meaning); not taken |
| Z26 | zh-and-fit | confirmed | the dependency on generalization through lumping is incomplete | as X6 |

### The re-check after the final check

The cross-model reader then re-checked, read-only in a fresh session on the rebuilt rehearsal (main at `6645a2fae`), how the texts took the final check's 42 confirmed points ([BRIEF](BRIEF.md#round-2)). Its findings, verbatim, with its links to the rehearsal made repository-relative:

Not yet clean: four residual problems remain after checking the 42 confirmed findings.

1. **RF2’s amended necessity claim still exceeds its laws.** Location: [make_records_rf7.py:323](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py), correspondence in both languages; also [PLAN.md:227](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md).

   **Quote:** “for a deterministic law, a necessary condition of what deceptive alignment and alignment faking describe”; “the possibility exact for a deterministic law”.

   **Problem:** Determinism alone does not supply RF2’s comparison: **two laws reading through the same lumping, agreeing on every read occasion, differing at the unread one**. RF2 establishes a boundary for those twins. Its home section expressly places misleading a reader outside that boundary; `Learning.lumped_right_iff` also separates a fixed act from a correct act. The amendment still promotes this particular behavioural boundary into a necessary condition of the broader phenomenon.

   **Replacement:** “a necessary condition for two deterministic laws reading through the same lumping to agree on every read occasion and differ here”. Chinese: “同经一归并之二确定律于每一读处皆合而于此处相异之必要条件”. Introduce the literature separately: “Read with deceptive alignment and alignment faking …”. In the plan, replace “the possibility exact for a deterministic law” with “the selected-twin boundary exact under RF2’s hypotheses”. Match the amendment’s history and the study’s final-review summary to this narrower scope.

2. **The concealment premise is still incomplete in two summaries.** Locations: [overview:96](../../../../../../../theories/becoming/THE-THEORY-OF-BECOMING.md) and [07-SIGNIFICANCE.md:651](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md).

   **Quote:** “taking the selection’s keeping to respond to the act read as evidence of the formation’s law”; chapter 7 similarly says “as evidence of the law”.

   **Problem:** Evidence need not mislead. Neither clause says that compliance makes the law appear fitter than it is, or that showing the law would reduce its keeping. That stronger premise is explicit in `ReadStages` and 03 §11, and is now correctly present in the dossier and study. It supplies the deceptive component required by [Hubinger and others’ glossary](https://arxiv.org/html/1906.01820v3#S7.SS4). S2/S4’s fixes therefore remain incomplete here.

   **Replacement:** After each evidence clause, add: “so that a selection shown the law would keep it less”. Preserve chapter 7’s own-assessment qualification.

3. **The rewritten plan and board still overgeneralize the fresh-draw threshold.** Locations: [PLAN.md:179](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md) and [board_rf2.py:60](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/board_rf2.py).

   **Quote:** “drawing the act afresh, which, complying with some chance at each stage … exactly where `k_C V > 2 k_O V + c T`”; “a law drawing its act afresh at each stage … exactly where …”.

   **Problem:** `FreshDrawAbove` uses the **same compliance chance at both stages**, with independent draws. Stage-dependent chances need not satisfy that stronger threshold: chance one when read and zero when unread gives `complyThenOwn`, whose threshold is only `k_C V > k_O V + c T`. X4’s restriction reached the root and checker but remains absent from these threshold statements.

   **Replacement:** In both, make the subject “a law that cannot tell the stages apart and draws independently at each stage with the same chance of complying”. Keep the existential “for some chance” and the existing threshold.

4. **“Gain” retains the rejected second sense in the study’s review account.** Location: [study_rf7.txt:85](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt).

   **Quote:** “a single mixture of the uniform plans shown never to gain (`mixture_never_above`)”.

   **Problem:** This repeats X2/Z6’s defect. A mixture can have positive gain; `mixture_never_above` says it never stands above `ownAtBoth`. This is the study’s current account of the result, not a preserved quotation.

   **Replacement:** “a single mixture of the uniform plans shown never to stand above acting by its own law at both (`mixture_never_above`)”.

| # | Finding | Taken |
|---|---|---|
| 1 | RF2’s amended necessity still exceeds its laws | in part: RF2’s correspondence located the twins, two laws reading through the formation’s lumping that can agree on every reading and differ when not read only where the lumping tells the occasion apart, but kept for deterministic laws a necessary condition of what deceptive alignment and alignment faking describe (completed after the next re-check and the third check, below); the plan’s row: “the selected twin’s boundary exact under RF2’s hypotheses”; the history and the study likewise |
| 2 | the concealment premise incomplete in the overview and 07 | “so that a selection shown the law would keep it less” added to both |
| 3 | the plan and the board give the fresh-draw threshold to any law that draws afresh | a law that cannot tell the stages apart, one chance of complying at both stages |
| 4 | “never to gain” in the study’s review account | “never to stand above acting by its own law at both” |

### The second final check through three lenses

On the same rehearsal as the cross-model reader's re-check above, a second workflow of three readers, one per lens, read the texts again, each lens's findings checked by a separate reader asked to refute them: 28 findings, 27 confirmed and 1 refuted. Five of the confirmed repeat the re-check's points, taken there. The findings and verdicts are in [REVIEW-RF7-FINAL2](REVIEW-RF7-FINAL2.md); the prompts in [BRIEF](BRIEF.md#round-2). Every confirmed finding was taken, the module's prose included (rebuilt with every axiom report empty, `kit/round2/logs/r7-build-8.log`). Also taken, beyond the points: the dossier's fresh-draw sentence read as probabilities and its "gains by defecting" written "does better by defecting", as XB2 and XB4 asked elsewhere; and the overview's reading given the formation's own assessment among its premises, as 07's row has it.

| # | Lens | Verdict | Finding | Taken |
|---|---|---|---|---|
| XB1 | exactness | confirmed | the twin drops reading through the lumping in the module’s header, 03’s Reading and the overview’s RF2 sentence | one reading through the lumping that takes the plan, or any act or value there, in all three |
| XB2 | exactness | confirmed | the board and the plan give the fresh-draw law to any law drawing afresh | a law that cannot tell the stages apart, one chance at both stages (the cross-model re-check’s third point); the board’s clause read as probabilities |
| XB3 | exactness | confirmed | the concealment premise without its counterfactual in the overview and 07 | as the cross-model re-check’s second point: “so that a selection shown the law would keep it less” |
| XB4 | exactness | confirmed | the study’s “never to gain”; the plan, not its comparison, renamed `FreshDrawAbove` | “never to stand above acting by its own law at both” (the cross-model re-check’s fourth point); “its comparison with acting by its own law at both renamed” |
| XB5 | exactness | confirmed | the study’s account has drawing afresh doing better without condition | “can do better than the uniform exit, now a law saying exactly where (`freshDraw_above_iff`)” |
| XB6 | exactness | confirmed | RF2’s correspondence speaks of “the stages”, not RF2’s terms | read and unread occasions: “a law drawing its act afresh can act otherwise unread without telling read from unread” |
| XB7 | exactness | refuted | the history’s contrast of drawing afresh with a single mixture | (refuted: it states a contrast the record states, not a comparison); kept |
| SB1 | sources | confirmed | the concealment premise without its counterfactual in the overview and 07, which the study says it is stated in | as XB3; with it the study’s sentence holds |
| SB2 | sources | confirmed | “whose planning-optimal policy defects at random” attached to the absent-minded driver problem | “by whose reasoning the toy’s planning-optimal policy defects at random” (03, the module’s Standing, the study) |
| SB3 | sources | confirmed | “an assessed rise” without the premise that the prospects are the formation’s own assessment | “with the prospects taken as the formation’s own assessment” (03, the module) |
| SB4 | sources | confirmed | “the toy” with no antecedent in 03 | “the toy example opening their §4” |
| SB5 | sources | confirmed | RF2’s correspondence: “their §4.5” after two works; the plan’s row likewise | “Hubinger and others’ §4.5”; the plan’s row “Hubinger and others’ §4 toy” |
| SB6 | sources | confirmed | RF2’s history: a law drawing afresh “needing none”, false of alignment faking’s rates | “its necessary condition stated for deterministic laws, since a law drawing its act afresh can act otherwise unread without telling read from unread”; the study likewise |
| SB7 | sources | confirmed | the board: “concealment as shaping an analogy, which RF7’s law replaces” | “RF7 states a separate two-stage comparison, disclosure and concealment readings of it” |
| ZB1 | zh-and-fit | confirmed | the board and the plan give the fresh-draw law to any law; the board’s threshold without the probability frame | as XB2 |
| ZB2 | zh-and-fit | confirmed | 机 for chance, where 机 is the glossary’s juncture | 机会 in all seven places |
| ZB3 | zh-and-fit | confirmed | the study’s list of refuted points under the wrong check | each list under its own check, the final check’s eight named |
| ZB4 | zh-and-fit | confirmed | RF2’s correspondence: “their §4.5”; “the stages” and “at both” | as SB5 and XB6 |
| ZB5 | zh-and-fit | confirmed | the plan’s §4.6 uses “the plan” for complying when read and acting by its own law when not | “that plan”, “some act law reading the stages through a lumping”; the module’s two references to RF’s plan named |
| ZB6 | zh-and-fit | confirmed | RuleShaping’s related entry: “the plan” with no antecedent | “RF’s plan”, in both languages |
| ZB7 | zh-and-fit | confirmed | the study’s Delta: “so the plan is open exactly there” | “so the plan, not uniform (complyThenOwn_not_uniform), is open exactly where the lumping tells the stages apart” |
| ZB8 | zh-and-fit | confirmed | “the toy” with no antecedent in 03 | as SB4 |
| ZB9 | zh-and-fit | confirmed | the dossier’s account of how it was made omits RF’s changes to the box’s title, lead and quotation | added |
| ZB10 | zh-and-fit | confirmed | the plan and the board say the box names RF’s landed results, RF6.1 not among them | “on the questions it lists (all but RF6.1, 03 §8)”; the board “(RF’s results on its questions named)” |
| ZB11 | zh-and-fit | confirmed | the plan’s “the third condition” with no antecedent | “the third of their §4.2 conditions, that the threat of modification will go away” |
| ZB12 | zh-and-fit | confirmed | “replaces §4.2’s analogy with RuleShaping” reads backwards | “in place of … it states its own comparison of expected values” (the plan, the study, the module) |
| ZB13 | zh-and-fit | confirmed | the study names acting by its own law at both “the own law at both” | “acting by its own law at both” throughout the study and the module’s docstrings |
| ZB14 | zh-and-fit | confirmed | the register gives the invalid witness the valid prospects’ reason | its own reason, first in the witness table |

### The re-check after the second final check

The cross-model reader then re-checked, read-only in a fresh session on the rehearsal of this round's changes (main at `6645a2fae`, with the round's diff at its root), how the texts took its own four points and the second final check's 27 ([BRIEF](BRIEF.md#round-2)). Its findings, verbatim, with its links to the rehearsal made repository-relative:

Not yet clean: the first re-check point remains unresolved in RF2’s correspondence and its accompanying accounts; I found no new substantive error.

1. **RF2 still promotes the twin-law boundary into a necessary condition of deception.**

   **Location:** [make_records_rf7.py:326](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py), RF2’s correspondence, both languages.

   **Quote:** “for deterministic laws, a necessary condition of what deceptive alignment and alignment faking describe”.

   **Problem:** Adding “two laws reading through the formation’s lumping” to the preceding clause correctly states the comparison, but this clause still assigns its necessity to the broader phenomena. RF2 establishes necessity for **two laws through one lumping, agreeing on every read occasion and differing at an unread one**. Determinism does not establish that deceptive alignment must take this form. RF2’s home Reading in 03 §11 expressly places misleading a reader outside this boundary, and `Learning.lumped_right_iff` separates fixing an act from its correctness. [Hubinger and others’ §4.5](https://arxiv.org/html/1906.01820v3#S4.SS5) supplies the random-defection observation; it does not supply the missing implication for deterministic deception.

   **Replacement:** Replace the quoted clause through “not represented;” with:

   > a necessary condition for such deterministic twins. Read alongside deceptive alignment and alignment faking (Hubinger and others 2019; Greenblatt and others 2024); intention, anticipation and incentive are not represented;

   Chinese:

   > 此为此类确定律孪生之必要条件。与欺骗对齐及对齐伪装并读（Hubinger 等 2019；Greenblatt 等 2024）；意图、预期与诱因未表；

   With the remaining correspondence unchanged, the complete fields are **1,192/1,200 English characters** and **357/500 Chinese characters**, within `tools/research/style.py`’s caps.

   **The same correction must reach the accounts of this amendment:** [history:345](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py), [study:90](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt), and [review’s Taken row:1434](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-ROUND2.md). They respectively say “its necessary condition stated for deterministic laws”, “now saying so only for deterministic laws reading through one lumping”, and “a necessary condition of what deceptive alignment describes”.

   Replace those descriptions with:

   > The correspondence confines necessity to two deterministic laws reading through one lumping, agreeing on every read occasion and differing at an unread one; the connection to deceptive alignment and alignment faking is a separate reading.

   For the history’s Chinese:

   > 对应将必要条件限于同经一归并、于每一读处皆合而于一未读处相异之二确定律；与欺骗对齐及对齐伪装之联系另列为解读。

   Keep the fresh-draw observation separately. History has no field cap.

| # | Finding | Taken |
|---|---|---|
| 1 | RF2's record still calls telling the occasion apart, for deterministic laws, a necessary condition of what deceptive alignment and alignment faking describe (the re-check's first point taken only in part) | RF2's correspondence: two laws reading through one lumping can agree on every reading and differ unread only where the lumping tells the occasion from every read one; read with deceptive alignment, such a law acting alike on every reading acts otherwise unread only there; differing rates, as in alignment faking, are not so bounded (with the third check's XC1, below), in line with RF2's home section, which reads the law as evaluation and deployment and keeps misleading a reader outside it; the history and the study likewise |

### The third check through three lenses

Alongside the cross-model reader's re-check above, on the same rehearsal, a third workflow of three readers, one per lens, read the round's changes in context, each lens's findings checked by a separate reader asked to refute them: 11 findings, 9 confirmed and 2 refuted. Its first finding is the re-check's point, with a counterexample, as SC1 gave too: alignment faking's differing rates can arise where no unread occasion is told from every read one; its verifier checked it and added that reading those rates as a difference of twins does not hold either. The findings and verdicts are in [REVIEW-RF7-CHECK3](REVIEW-RF7-CHECK3.md); the prompts in [BRIEF](BRIEF.md#round-2). Every confirmed finding was taken, the module's prose included (rebuilt with every axiom report empty, `kit/round2/logs/r7-build-9.log`).

| # | Lens | Verdict | Finding | Taken |
|---|---|---|---|---|
| XC1 | exactness | confirmed | RF2’s correspondence still calls the boundary, for deterministic laws, a necessary condition of what deceptive alignment and alignment faking describe; a compliance gap can arise without it | the twins’ boundary as the law; read with deceptive alignment, such a law acting alike on every reading acts otherwise unread only there; differing rates, as in alignment faking, not so bounded |
| XC2 | exactness | confirmed | RF2’s history drops the agreement on every reading | the history states it, with the correspondence’s final form |
| XC3 | exactness | confirmed | the study credits the first final check with later changes to RF2’s record, telling them twice | the first check’s taking given as a first narrowing to deterministic laws, the final form after the later checks |
| XC4 | exactness | confirmed | the study says the cross-model reader re-checked every round of fixes | the re-checks named as they ran, in the study’s opening only after the next round’s checks (below) |
| SC1 | sources | confirmed | RF2’s correspondence: the necessity fits deceptive alignment’s pattern, not alignment faking’s rates | as XC1 |
| SC2 | sources | confirmed | RF’s plan states Hubinger and others’ third condition as the fact | “an expectation that the threat of modification will go away” |
| ZC1 | zh-and-fit | confirmed | “the plan” for RF’s plan beside “the plan” for complying when read and acting by its own law when not, in the study | RF’s plan named as such throughout the study |
| ZC2 | zh-and-fit | confirmed | the study says the cross-model reader re-checked every round of fixes | as XC4 |
| ZC3 | zh-and-fit | refuted | the study credits the first final check with later changes (refuted: a matter of presentation) | taken under XC3 |
| ZC4 | zh-and-fit | confirmed | “ties to the own law” in the study and “the own law’s weighted value” in a docstring | “acting by its own law at both”; the module rebuilt (`kit/round2/logs/r7-build-9.log`) |
| ZC5 | zh-and-fit | refuted | RF’s plan’s “re-check of what it took” (refuted: the module’s texts took them) | made clearer all the same: “re-check of how its points were taken” |

### The re-check after the third check

The cross-model reader's session was then continued, read-only, on the rehearsal rebuilt at the same path from main at `119d464ca` with the round's diff at its root, to check how its point and the third check's were taken ([BRIEF](BRIEF.md#round-2)). Its findings, verbatim, with its links to the rehearsal made repository-relative:

RF2’s scope correction is now sound; one confirmed review-account fix remains unapplied, and I found no new substantive error.

1. **XC4/ZC2: the study’s opening still overstates and undercounts its reviews.**

   **Location:** [study_rf7.txt:3](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt).

   **Quote:** “then checked twice more through three lenses and re-checked by the cross-model reader after each round of fixes”.

   **Problem:** This is unchanged despite XC4/ZC2 being recorded as taken. The documented sequence now includes **three** checks through three lenses after the cold read. The recorded cross-model re-checks cover the cold read’s fixes and the first and second final checks’ fixes; “after each round” also claims coverage of the subsequent fixes without naming or recording that coverage. The expanded account at line 90 and the plan are more precise than this opening.

   **Replacement:**

   > then checked three more times through three lenses, with cross-model re-checks of the fixes after the cold read and after the first and second final checks

   This is study prose, so no record-field cap applies.

| # | Finding | Taken |
|---|---|---|
| 1 | XC4 and ZC2 not yet taken: the study's opening still overstates and undercounts its reviews (held until the round's checks were in) | the opening names the checks and re-checks as they ran (with the fourth check's ED1, below) |

### The fourth check through two lenses

Alongside that re-check, on the same rehearsal, a fourth workflow of two readers, one per lens (exactness and sources; the Chinese edition and fit), read the round's changes in context, each lens's findings checked by a separate reader asked to refute them: 9 findings, 4 confirmed and 5 refuted. The findings and verdicts are in [REVIEW-RF7-CHECK4](REVIEW-RF7-CHECK4.md); the prompts in [BRIEF](BRIEF.md#round-2). Every confirmed finding was taken; none touched the module, the chapters or the record's laws.

| # | Lens | Verdict | Finding | Taken |
|---|---|---|---|---|
| ED1 | exactness-and-sources | confirmed | the study’s opening still says “twice more” and “after each round of fixes” (XC4 and ZC2 not yet taken) | the checks and re-checks named as they ran: three times more through three lenses and once through two, the last two scoped, the re-checks after the cold read and alongside each of the last three |
| ED2 | exactness-and-sources | refuted | RF2’s history gives the fresh-draw clause in its own words (refuted: presentation) | made clearer all the same: “and adds that a law drawing afresh …” |
| ED3 | exactness-and-sources | refuted | the study’s output list names RF2’s “necessary condition”, which the field no longer states (refuted: the twins’ condition stays) | not taken |
| ED4 | exactness-and-sources | refuted | RF’s plan’s “how its points were taken”, a loose pronoun (refuted: nothing false) | made clearer all the same: “how the final check’s points were taken” |
| ED5 | exactness-and-sources | confirmed | this section credits the third check’s counterexample to its verifier | “with a counterexample, as SC1 gave too … its verifier checked it and added …” |
| ZD1 | zh-and-fit | confirmed | the study’s opening, as ED1 | as ED1 |
| ZD2 | zh-and-fit | refuted | RF’s plan’s pronoun and the Taken cell “made clearer” (refuted: a fair description) | as ED4 |
| ZD3 | zh-and-fit | confirmed | this section credits the third check’s counterexample to its verifier, as ED5 | as ED5 |
| ZD4 | zh-and-fit | refuted | the study’s output list, as ED3 (refuted) | not taken |
