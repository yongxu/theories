# The review of the design of RF's round 2, second part

RF round 2, second part: RF-M's assistance case and the order as state (plan §4.7). Before any Lean was written, the design was read by the cross-model reader (GPT astra, high effort, read-only, a fresh session `01a18bec-f4e4-74d2-a604-9290d768c8ba`, 30 October 2026), with the prompt in [the brief](BRIEF.md#round-2-second-part). Its review follows verbatim, its paths made relative to the checkout and its links to this folder, since this folder is link-checked as live: a line number kept in a link's text and dropped from its target, and a link that does not resolve here shown as its text with its target as code. What was taken follows it.

## The review

I reviewed [§4.7 of PLAN.md](../PLAN.md) against the named landed modules, records and primary literature. I made no file changes and ran no builds. “Confirmed” below means checked against source text, declarations or finite arithmetic; it does not certify an unwritten Lean theorem.

1. **RF-M.2.1 — The weighted result adds something; the common-act condition already exists. [Confirmed: record and declaration inspection; package search.]**

   I found no existing theorem giving this weighted maximum/equality characterization. However, its common-act component is already represented by `GuardHorizon.uniform_policy_iff_fiber_feasible`, `ReadingLoop.keeping_policy_iff`, `Becoming.commonResponse_judge_iff`, and `Generative.InquirySufficiency.sufficiency_iff_bounded_policy`. The latter includes inquiry transitions and bounded branching plans, not expected-value maximization. RF7’s `ReadStages.Prospects.Above` already supplies the gain/loss cross-addition convention, but not the proposed information theorem.

   **Replacement:** “The addition is the weighted comparison and its equality boundary. Common-act feasibility is reused from the inquiry laws; the present result concerns a costless, fully revealing reading with unchanged available acts and values.”

2. **RF-M.2.1 — Require an inhabited act list; characterize ties through common maximizers. [Confirmed: arithmetic inspection and exhaustive checks.]**

   Let \(A\) be a **nonempty** finite list of admissible acts, and define
   \[
   F=\sum_h w_h\max_{a\in A}u(h,a),\qquad V(a)=\sum_h w_hu(h,a).
   \]
   Then, for \(a\in A\),
   \[
   V(a)=F\iff
   \forall h,\;w_h>0\Rightarrow u(h,a)=\max_{b\in A}u(h,b).
   \]
   Consequently, every fixed act falls strictly below \(F\) exactly when there is no common maximizer on the positive-weight support.

   Zero-weight candidates impose no condition. Tied maximizers are allowed: different tie-breaking choices do not establish strict value. Empty candidates or all-zero weights give \(F=V(a)=0\); they are algebraically harmless but are not a probability model. An empty act list supplies no maximizing act or policy.

   **Replacement:** Add nonempty acts explicitly; require positive total weight only for the probabilistic interpretation. I checked these equivalences on 20,440 small tables, including empty candidate lists, zero weights and ties.

3. **RF-M.2.1 — Good is correctly connected, but the proposed theorem is a specialization. [Confirmed: primary source.]**

   Good considers observations that need not reveal the hypothesis completely. His finite-matrix lemma includes the common-maximizer equality boundary. Thus neither that boundary nor the weighted inequality is new mathematics. His qualification is that “the cost of doing so is negligible.” [Good, *On the Principle of Total Evidence*](https://fitelson.org/seminar/good.pdf)

   **Replacement:** “A finite, perfect-information specialization of Good’s value-of-evidence argument, with natural-number weights and scores; the equality boundary is his common maximizing row condition.”

4. **RF-M.2.2 — The shifted encoding works, provided subtraction is not performed in `Nat`. [Confirmed: algebra and finite checks.]**

   Starting with the signed values \(g_h-\ell_h\) and \(0\), add \(\ell_h\) to **every option at candidate \(h\)**. The encoded values are
   \[
   \text{act}=g_h,\quad \text{off}=\ell_h,\quad
   \text{rational hold}=\max(g_h,\ell_h).
   \]
   Every policy’s weighted value receives the same addition \(\sum_h w_h\ell_h\). This preserves comparisons.

   Writing `(gain - loss : Nat)` first would truncate losses and invalidate the correspondence. Likewise, leaving the encoded off-value at zero would be wrong.

   **Replacement:** State the three encoded values directly and explain their common-offset interpretation. Strict superiority over both alternatives requires a **positive-weight** candidate with \(g_h>\ell_h\) and another with \(g_h<\ell_h\). A tie contributes neither: signed values \(1,0\) give hold = act, not strict superiority.

5. **RF-M.2.2 — The off-switch attribution is right; certainty means no strict incentive, not necessarily refusal. [Confirmed: primary source.]**

   Hadfield-Menell et al.’s Theorem 1 assumes the human permits execution when \(U_a\ge0\) and vetoes when \(U_a<0\). It states that waiting is “never suboptimal,” and is uniquely optimal with positive probability on both strict signs. Their certainty discussion distinguishes indifference under rational oversight from loss under mistaken oversight. At \(U_a=0\), every veto policy ties. [*The Off-Switch Game*, Theorem 1 and Corollary 1](https://arxiv.org/pdf/1611.08219)

   **Replacement:** “This reproduces the finite deterministic-veto case. A certain model has no strictly positive incentive to defer; choosing to defer or bypass at equality needs a tie-breaking rule. With possible veto mistakes, deferral can be strictly worse.”

6. **RF-M.2.3 — Both equivalences are correct, but the heading and attribution need changing. [Confirmed: arithmetic checks and primary-source comparison.]**

   For a deterministic veto predicate \(v(h)\), let
   \[
   H_v=\sum_h w_h\bigl(\text{if }v(h)\text{ then }\ell_h\text{ else }g_h\bigr).
   \]
   The two stated conditions are exactly correct: compare vetoed losses with vetoed gains for \(H_v\ge\text{act}\), and permitted gains with permitted losses for \(H_v\ge\text{off}\).

   However, “not reading the candidate” suggests independence. An arbitrary candidate-dependent veto can read it incorrectly or partially. A genuinely independent randomized veto merely mixes acting and switching off and cannot strictly beat their best fixed choice.

   These inequalities are the deterministic finite form of **Equation 1 of the off-switch paper**, rather than Milli et al.’s obedience theorem. Milli studies preference inference and obedience in a supervision model, simplified to a repeated game; its results depend on its learning assumptions. [Milli et al., *Should Robots be Obedient?*, §§2–3](https://arxiv.org/pdf/1705.09990)

   **Replacement:** Rename this “An arbitrary veto rule”; attribute the comparison to the off-switch equation and describe Milli as related work on obedience under imperfect choice.

7. **RF-M.2.4 — “Exactly beyond what its choices have shown” is too strong. [Confirmed: ShownOrder declarations and counterexample.]**

   `ChoiceOccasions.reach_within` already proves the forced comparison. `ChoiceOccasions.both_ways_of_unreached` already constructs opposing strict according orders when the choices are acyclic, the alternatives differ, and neither reaches the other. Reproving either would duplicate RF1.

   Neither theorem ensures that the **current weighted candidate list** contains both orientations. A singleton candidate model has zero perfect-information advantage even on an unshown pair.

   **Replacement:** “Shown reach forces agreement among transitive according candidates. Outside both reaches, opposing according orders exist; holding has strictly positive value precisely when the supplied positive-weight candidates contain opposing strict value comparisons.”

   The declaration’s namespace is `Becoming.ChoiceOccasions`, not `ShownOrder`.

8. **RF-M.2.4 — Strict orders do not automatically supply executable natural-number values. [Confirmed: declaration signatures; judgment on the required bridge.]**

   RF1 constructs arbitrary `Prop`-valued **strict partial orders**. It supplies neither decidability nor numerical representation. Decidable comparisons alone do not solve representation: an infinite order need not embed in `Nat`, and even a finite partial order need not be represented *exactly* by scalar comparison. For example, \(a>b\), with \(c\) incomparable to both, cannot be represented by scores whose strict comparisons are exactly that relation.

   **Replacement:** Supply candidate scores `u : H → Alt → Nat`, with induced strict comparisons according with the choices. Separately establish any required existence of opposing scored candidates—for example using a finite, decidable choice graph and an explicit ordering construction. Alternatively, restrict to the two alternatives and supply decidable orientations plus explicit two-act payoffs. Do not claim that RF1 already provides this bridge or cardinal calibration.

9. **RF-M.2.5 — The witness fits `Loop`, but misspecification and sign agreement are insufficient hypotheses. [Confirmed: `Loop` interface and fixed-point theorem.]**

   [`Loop.answer`](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadingLoop.lean) already has type `S → A → E → S`; act-dependent access needs no interface change. But omission of the truth does not imply that ordinary acting never produces refuting evidence. Also, unanimously negative candidates may cause switching off rather than acting.

   **Replacement:** Construct a nonempty listing predicting positive value, a true negative case, and a selector that executes on unanimous positive predictions, including its tie-breaking against costless holding. Let ordinary execution return a common neutral observation, while holding returns a distinguishing veto. For direct use of `rests_of_unrefuted`, verify all four premises: unchanged answer, unchanged external state, the selected act, and every listed prediction fitting that answer. Otherwise use `kept_iff` along a changing course.

   This is a new witness of an existing law, not a new persistence theorem.

10. **RF-M.2.5 — Carey’s result is stronger and different from never sensing the veto. [Confirmed: primary source.]**

    Carey’s 2018 version explicitly exhibits a misspecified reward family causing a system to **receive and disregard** a shutdown recommendation; another example routes around a shutdown opportunity. The paper describes an agent that may “ignore corrective feedback.” Your proposed witness instead suppresses access to potentially refuting feedback. [Carey, *Incorrigibility in the CIRL Framework*, Figures 2–3](https://arxiv.org/pdf/1709.06275)

    **Replacement:** “A deterministic witness of oversight bypass under a misspecified candidate list, related to Carey’s counterexamples.” Claim containment of Carey only after representing a received shutdown instruction and its refusal, or an explicit correspondence to his bypass case.

11. **RF-M.3.1 — Define two evaluations from the same start; “gain in rank exceeds” is incomplete. [Confirmed: statement inspection; judgment on corrected specification.]**

    Write one configuration \(x=(w,r,\ldots)\), transition \(T(x,a)=(w_a,r_a,\ldots)\), and supplied scoring map \(u(r,w)\). Define
    \[
    E_{\mathrm{choice}}(x,a)=u(r,w_a),\qquad
    E_{\mathrm{outcome}}(x,a)=u(r_a,w_a).
    \]
    An order-only act with \(w_a=w\) leaves the first equal to \(u(r,w)\); the second changes iff \(u(r_a,w)\ne u(r,w)\).

    For an order-only act \(s\) and world-only act \(b\), strict preference under outcome evaluation is exactly
    \[
    u(r_s,w)>u(r,w_b).
    \]
    With costs, compare \(u(r_s,w)+c_b>u(r,w_b)+c_s\).

    **Replacement:** Use these equations and identify the comparison baseline. Call the first statements projection/evaluation lemmas. They do not establish absence of a multistep shaping incentive: changing the order may change later acts and therefore later world outcomes.

12. **RF-M.3.1 — An ordinal order and a cardinal evaluator must remain distinct. [Confirmed: mathematical counterexample.]**

    Replacing every score \(u(r,w)\) by \(u(r,w)+1\) changes outcome evaluation while preserving every ordinal comparison. Conversely, changing an order elsewhere need not change the score of the realized outcome.

    **Replacement:** Either represent a **valuation** as state, with its scale explicitly supplied, or choose and justify a canonical rank representation on a fixed finite domain. Replace “ranks the outcome otherwise” with “assigns the same world outcome a different score.” The quantitative incentive cannot be inferred from an ordinal order alone.

13. **RF-M.3.1 — Everitt’s current-reward result is not a general immunity theorem. [Confirmed: primary source.]**

    Everitt et al. distinguish agents that anticipate future changes of objective from agents that plan as though their present objective controlled future actions. Under their assumptions, the former may have an incentive to **preserve** the reward function. The latter lack an instrumental goal to influence it when it is private and state-based. The preservation result additionally assumes that reward-function changes carry no information about state transitions. [Everitt et al., *Reward Tampering Problems and Solutions*, §3.2, Claims 2–3](https://arxiv.org/pdf/1908.04734)

    **Replacement:** “A one-step illustration of holding the evaluation map fixed while comparing outcomes. It does not reproduce the paper’s multistep causal claims, time-inconsistency analysis, or protection against reward-input tampering.”

14. **RF-M.3.1–2 — Carroll supports modelling induced preference change, not identifying its legitimacy from an endpoint. [Confirmed: primary source.]**

    Carroll et al. estimate preference trajectories under different recommender policies and compare them with explicitly chosen “safe shifts.” They call frozen initial preferences a “very crude” baseline and also consider a random-recommender baseline. Their account does not equate every induced change with manipulation, nor establish that current-order evaluation resolves the problem. [Carroll et al., *Estimating and Penalizing Induced Preference Shifts*, §5](https://arxiv.org/pdf/2204.11966)

    **Replacement:** “Related to induced preference shifts; the present witness represents interventions on valuation, but supplies no criterion of legitimate, desired or autonomous change.”

15. **RF-M.3.2 — The route law is already lumping, and its causal conclusion is not yet represented. [Confirmed: `Learning.Lumped` inspection.]**

    With \(\pi(\tau)\) the retained outcomes and final order, the statement
    \[
    \pi(\tau)=\pi(\tau')\Rightarrow e(\tau)=e(\tau')
    \]
    is precisely [`Learning.Lumped π e`](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Learning.lean), or congruence when \(e=f\circ\pi\). RF2 already illustrates this pattern. Registering it again would add a wrapper.

    **Replacement:** Keep it as a reading. The useful addition would be **two executable routes** with equal \(\pi\) but different, explicitly defined route properties \(q\). Then no classifier through \(\pi\) can recover \(q\). Specify whether “outcomes” means the entire outcome sequence or only its endpoint. “The principal’s own” requires an independently defined causal property; an endpoint cannot supply it.

16. **RF-M.3.3 — The ranking must become state, and the intervention claims need scoped traces. [Confirmed: `Untested` and `Loop.law` inspection.]**

    `Untested.loop r` takes `r` as a fixed parameter. Its internal state is only the candidate list and previous sensory/action pair. `model_or_order` compares **two laws**, and `informed_turns` changes the initial listing; neither executes a helper intervention.

    **Replacement:** Specify the carrier before claiming the witness. One valid construction keeps `Loop` as the helper and puts the principal’s model, ranking and phase in its external state `E`; `move` executes demonstrations and order changes. Another uses the more general `Blanketed` structure with an enlarged internal state. Putting the order in `S` is legitimate only if the specified sensing actually exposes it.

    State the four cases separately: informing turns the unresolved-model case but not the reversed-order case; shaping turns the latter but leaves the former’s conservative choice unchanged. “After either” must mean the appropriate intervention in its corresponding case. Specify update delays and whether indistinguishability concerns post-intervention principal acts or complete observed histories.

17. **§4.7 and §5 — Existing capture laws cover much of the proposed explanatory framing. [Confirmed: named modules inspected.]**

    `ClosedCapture.courses_alike_iff_unread` already gives the closed-reading indistinguishability equivalence. `RuleCapture.favouring_locks` adds the monotonicity and favouring premises needed for locking. `DrawnShaping.critical_mass_iff` already joins shaping to reader composition. `ReadInTime.turned_early_iff`, `kept_once_favoured` and `deadline` already give timing boundaries. Recasting these as general laws of an order changing within a configuration would not add those mechanisms anew.

    Conversely, `Seeking` explicitly leaves target formation and revision unstated; its `Law.rests_iff` concerns reaching a fixed configuration meeting a supplied target. It does not duplicate a genuine dynamic preference intervention.

    **Replacement:** “The new contribution is the explicit informing/shaping transition and its connection to candidate revision and observed acts. Closed-reading independence, capture and late correction are reused under their existing premises.”

18. **`closed-capture.json:157` — The Everitt 2017 comparison needs its positive theorem’s assumptions. [Confirmed: record and primary source.]**

    The record’s indistinguishability comparison is appropriate. Its suggestion that a reading outside the loop is “the way out” is too loose as an attribution to Theorem 19. That theorem requires limited corruption and, for each target state, either a safe observation source or more than \(2q\) observation sources, within its communicating model class. An extra channel alone does not suffice. The full author list also includes **Marcus Hutter**. [Everitt et al., *Reinforcement Learning with a Corrupted Reward Channel*, Theorems 11 and 19](https://arxiv.org/pdf/1705.08417)

    **Replacement:** “Unrestricted corruption prevents identification; decoupled feedback permits learning under the paper’s explicit coverage, corruption and reachability assumptions.” This is a correction to the comparison, not grounds to reopen the landed capture proofs.

19. **§4.7’s institutional deferral — Hirschman is appropriately a reading, with a scope distinction. [Confirmed: author’s retrospective account; judgment on correspondence.]**

    Hirschman treats exit and voice as distinct responses to deterioration that can interact, complement or undermine one another. Voice attempts change from within; exit alters participation. Neither is simply another name for receiving an outside reading. His own later account explicitly discusses voice complementing or superseding exit as a recovery mechanism. [Hirschman, *Further Reflections and a Survey of Recent Contributions*](https://www.milbank.org/wp-content/uploads/mq/volume-58/issue-03/58-3-Exit-Voice-and-Loyality.pdf)

    **Replacement:** Keep the deferral. Label the correspondence: voice may change the reading or rule; exit may change membership, reader composition and available support. No theorem about loyalty or the efficacy of either follows from `ReadInTime` alone.

20. **RF-M.2.2–3 — A stronger, useful result is the exact error-and-cost threshold. [Confirmed: algebra and finite checks; judgment: recommended addition.]**

    Define weighted positive and negative margins
    \[
    P=\sum_h w_h(g_h-\ell_h)_+,\qquad
    N=\sum_h w_h(\ell_h-g_h)_+.
    \]
    Let \(E\) be the weighted regret from vetoing positive acts and permitting negative acts. With \(T=\sum_h w_h>0\) and holding cost \(c\), the exact condition for holding to be at least as valuable as the best fixed choice is
    \[
    \boxed{E+cT\le\min(P,N)}.
    \]
    Strict preference uses \(<\); equality leaves a tie.

    This joins rational vetoes, arbitrary vetoes, sign uncertainty and the cost of waiting. It remains expressible through natural-number sums and comparisons. I checked the identities on 2,916 two-candidate tables with three costs each. Treat real delay effects separately: this formula assumes waiting changes the payoff only through the stated cost and veto.

21. **RF-M.2.1/4 — “More open model ⇒ more valuable holding” needs a specified ordering of models. [Confirmed: counterexample; judgment: replacement theorem.]**

    Increasing support is insufficient. Equal-weight signed values \(+1,-1\) give normalized holding advantage \(1/2\). Adding a distinct candidate with value \(+1\) lowers it to \(1/3\). More candidates therefore need not mean greater expected worth of holding.

    **Replacement:** Hold the prior, values and acts fixed, and order **readings by refinement**. The best attainable value is monotone under refinement because a finer-reading policy can ignore the additional distinction. The remaining value of perfect information correspondingly decreases. For the RF1 join, distinguish the existence of opposing compatible orders from their positive support in the actual model; choices alone supply neither their weights nor the magnitudes needed for a cost threshold.

22. **§4.7:183–195 — The framing is largely compatible with the method, but the carrier should establish the relationship. [Judgment, grounded in the method chapter and interfaces.]**

    “Helper” and “principal” are permissible roles; separate types do not by themselves assert separate subjects. The weak point is claiming both are internal parts without yet exhibiting their joint transition, then treating “the principal’s own” change as self-explanatory.

    **Replacement opening:** “One joint configuration carries the coupled processes of selecting an act, exposing it to a reading, revising candidate laws and changing the valuation used in later selection. ‘Helper’ and ‘principal’ name roles differentiated by these paths of sensing and control. Scores, weights and update laws are supplied local commitments; their formation and normative warrant are not derived.”

    `HeldForReading` is suitable once an actual held-act transition is represented. `FormedOrder` overstates a construction that merely supplies and changes an order; `OrderInState`, or `ValuationState` for cardinal scores, is more exact.

**Verdict:** Build RF-M.2.1–3 with the explicit nonempty-act, support, score and tie conditions above; their mathematical core is sound, and the error-and-cost threshold would make the package substantially more useful. Change RF-M.2.4 to a conditional composition with an explicit executable score bridge, and build RF-M.2.5 as a narrowly labelled witness reusing `Loop`’s existing laws. Keep RF-M.3.1 as precise evaluation lemmas, without implying general resistance to shaping; drop RF-M.3.2 as a separately registered result, retaining its reading or replacing it with executable route witnesses. Redesign RF-M.3.3’s carrier and transition schedule before writing Lean: that explicit mechanism is the strongest genuinely missing part of this design.

## What was taken

Statuses as the module was built and then revised on the review of its Lean ([REVIEW-RFM2-LEAN](REVIEW-RFM2-LEAN.md), whose first finding asked for them): *implemented* in the Lean and its account, *deferred as specified* to RF-M.3's design (11 to 17) or to the institutional reading (19), *handed over* to a record's owner, or *taken in part*. Names are the module's as revised.

| # | Finding | Status | Taken |
|---|---|---|---|
| 1 | the weighted result adds; the condition of a common act is already the inquiry laws' | implemented | the Standing names `GuardHorizon.uniform_policy_iff_fiber_feasible` and `ReadingLoop.keeping_policy_iff`; `cell_policy_iff` states the condition weighted; what is added is the weighted comparison, its identities, boundaries and thresholds |
| 2 | a nonempty list of acts; ties through common best acts; a positive total only for the probabilistic reading | implemented | a policy best at every candidate exists for every nonempty list of acts (`bestOf_best`); equality where the act is valued as the best at every candidate of positive weight, ties allowed (`after_eq_after_iff`, `committed_eq_after_iff`); a best policy's act is open (`BestAt`); the positive total among the modelling choices |
| 3 | Good's argument specialized; his common maximizing row is the equality boundary | implemented | the Standing: the perfect-information specialization of Good's (1967) argument, his Lemma's dominating row the equality boundary, with the gap identity `after_add_gap`; nothing claimed new as mathematics |
| 4 | the shifted encoding: state the encoded values; a tie tells neither | implemented | `shifted` values going on at the gain and switching off at the loss; every two rules comparing on these values as on the signed ones (`after_rule_add_onLoss`, `after_rule_le_iff`, added on the Lean's review, finding F6), and a common offset of natural-number values ordering every two policies alike (`after_offset`, `after_offset_le_iff`); `held_gains_iff` on strict signs; a candidate where gain and loss are equal counts for neither |
| 5 | certainty gives no strict incentive, not refusal; a tie needs a rule; a mistaken reading can stand below | implemented | the Readings: to a model fixing the sign, holding for a rule stands as high as the favored move exactly where the rule falls short nowhere, below exactly where it falls short, and ties under the reading that tells the candidate; the off-switch paper's Corollary 1 and Section 4, and Carey's footnote 1 on deferring at ties |
| 6 | "any rule", the off-switch paper's Equation 1; Milli and others related work | implemented | `byRule` and the section "Any rule of stopping"; Equation 1's two terms as balances (`after_add_shortfall_go`, `after_add_shortfall_off`), their signs `rule_not_below_go_iff` and `rule_not_below_off_iff`; Milli and others read as related work |
| 7 | the join with RF1 too strong; the namespace is `ChoiceOccasions` | implemented | a conditional composition: `reach_fixes`, `pair_gains_iff`, `pair_gains_unreached`; `ChoiceOccasions.both_ways_of_unreached` for the orders beyond the reach, as relations and not decided comparisons, whether the model lists them with positive weight not fixed by the choices; the plan's namespace corrected |
| 8 | strict orders supply no values | implemented | `pairValue`: decided comparisons for two alternatives, picks valued one or nothing, a cardinal choice the choices do not supply |
| 9 | the witness's construction, its rule for ties and the four premises | implemented | `SignLoop` (first named `Bypass`): the rule holding where the kept candidates disagree, shown to be the worth law's on the model (`SignLoop.choose_hold_iff`); `rests_unread` through `Loop.rests_of_unrefuted`, each premise by computation; the steps of the held starts stated as they are proved |
| 10 | Carey's counterexamples receive and disregard a recommendation, or route around an opportunity | implemented | the Readings relate `SignLoop` to Carey (2018) by mechanism: his Figure 2a the case of a model fixing the sign, Figure 3a a route around the states where a stop can be given, the nearest his conflating model never refuted by its course; related, not contained |
| 11–16 | the order as state: two evaluations from one start, a valuation and not an order, Everitt and others and Carroll and others read narrowly, the route law a lumping, the carrier unspecified | deferred as specified | RF-M.3 not built; plan §4.7 records the redesign before any Lean: a valuation as state with its scale supplied, the evaluations at the choice and at the outcome as projection lemmas, the route law a reading of `Learning.Lumped` unless executable route witnesses are built, the carrier and its schedule specified, the four cases apart |
| 17 | the capture laws already cover much of the framing | deferred as specified | plan §4.7: the new contribution is an explicit transition; independence, capture and late correction are reused under their premises |
| 18 | closed-capture's comparison with Everitt and others (2017) needs Theorem 19's assumptions and Hutter's name | handed over | plan §9, item 8, proposed to the record's owner; the record is not changed by this item |
| 19 | Hirschman a reading, with a scope distinction | deferred as specified | plan §4.7's institutional case kept a reading, as given |
| 20 | the exact threshold of error and cost | implemented | `goExcess`, `offExcess`, `shortfall`, `threshold_go_iff`, `threshold_off_iff`, `forgone_within_excess_iff`, `forgone_below_excess_iff`, `excess_pos_iff`; the amount forgone counted in the units of the weighted totals, `c T` for `c` per decision, as in the review's `E + cT` |
| 21 | "more open, more worth" needs readings ordered by refinement | implemented, for this decision | readings that tell only a cell: the least shortfall through a map (`least_through`, `least_zero_iff`) and a finer map never falling short by more (`finer_least_le`, the partition case of Blackwell 1953); no order of readings for every decision, and no noisy reading, is claimed |
| 22 | the framing and the names | taken in part | the plan's opening as given; `HeldForReading` kept, the held act represented in `SignLoop`; there the reading is the law of what the formation senses, so the principal is a role of that law and not a represented formation with its own state, which RF-M.3's carrier is to add |
