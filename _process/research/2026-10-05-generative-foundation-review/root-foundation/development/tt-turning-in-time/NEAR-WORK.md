AI-written, 12 November 2026

# Near work: four papers set against the turning pattern

The pattern each paper is set against:
(i) a selecting process whose way of choosing is rebuilt from its own choices;
(ii) something the process depends on that it runs down, a level under a draw;
(iii) what could turn the process standing on that same level, so that it runs out too;
(iv) an exact threshold or a timing condition for when the process can no longer be turned;
(v) a condition for recovery after it turns, a point of no return under the reduced use;
(vi) a machine-checked proof.

Short version. No paper has all six, and none has (iii) or (vi). The **Lock-in Hypothesis** paper has (i) and an exact (iv) for its own model. The **Self-Sealing Reward Models** paper, read from its abstract only, has (i), an exact (iv), and something close to (v). It is the nearest paper, and it has to be read whole before anything is claimed against it. **RAND** has neither (i) nor a dynamics. **Gradual Disempowerment** says (ii) and (iii) in words, and says it has no formal model.

---

## 1. Moon and Boudreaux, "A Formal Model of How Artificial Intelligence Erodes Human Agency" (RAND RR-A4817-1, April 2026)

**What was read.** The RAND page refused the fetch (HTTP 403). A copy of the report PDF was found, hosted by a governance-library blog. Text was taken from its content streams, so the page numbers below are the report's printed ones. Read: the summary, the main text (pp. 1–17, with p. 13 read in part, from the agenda-control scenario to the start of the limitations), Appendices A, B and C (pp. 19–24), and the reference list. Pages 18, 20 and 22 gave no text; they are probably blank.

**Model.** The state is a single static social-choice system. It has N individuals, a finite set of alternatives, and an aggregation map F from preference profiles to an aggregate preference. A coalition is *decisive* if its unanimous preference always appears in the aggregate. An individual is *irrelevant* to a coalition if the coalition stays decisive without them (pp. 5–6). There are three metrics:
- w(G), the mean number of decisive coalitions each individual is relevant to, normalised by the total count;
- m(G), the smallest decisive coalition's size divided by N;
- f(G), the set of minimal decisive coalitions (pp. 6, 10).

There is no time variable and no update rule. "Dynamics" means comparing a system G with a changed system G′ (p. 9).

**Results, with their conditions.**
- Majority rule, ten voters: w ≈ 3.3 and m = 0.6. Disenfranchising one voter gives w ≈ 2.5 and m = 0.5 (p. 7).
- Scaled to 100 voters, w falls about linearly for 1 to 70 disenfranchised voters and faster after that. The authors offer this as a *candidate* irreversibility threshold, and caution that it may depend on exogenous factors (p. 7, Fig. 2).
- Adding k irrelevant individuals leaves w unchanged, so per-capita agency w/(N+k) goes to zero. This is proved by induction (App. B).
- Adding one AI to the ten-voter majority leaves m about the same, but 252 of the 462 minimal coalitions contain the AI (p. 12).
- Agenda control: AI entities that sit in both of two decisive coalitions can introduce dummy alternatives that split the humans and force X over W. If they can do this for every profile, the AI coalition is itself decisive. This needs the Pareto criterion and local transitivity or quasi-transitivity (App. C, pp. 23–24).
- End state: one minimal decisive coalition decisive for all outcomes. It is justified by the filter structure of decisive coalitions under Arrow-type constraints: a finite filter has a minimal element, and an ultrafilter is principal (pp. 9–10, App. A).

**Assumed.** Participation is binary. The menus and the aggregation are given. Transitivity holds at least locally for the end state and for agenda control. Irreversibility is taken from Henry (1974), not derived. The authors reason it from economic sunk costs and from human capital decaying with disuse (pp. 4–5).

**Evidence.** Worked examples and counts only. There are no data. Applications are proposed: human-in-the-loop analysis, agency benchmarks (pp. 15–16).

**Against the pattern.**
- (i) **Absent.** Who decides does not change as a result of what the system decides. There is no loop from outcomes back to the coalition structure.
- (ii) **Named, not modelled.** Cognitive atrophy and the loss of human capital through disuse are cited as reasons for irreversibility (pp. 3, 5). Neither is a state variable. The authors list the binary-participation simplification as a limitation (p. 14).
- (iii) **Absent.**
- (iv) **Absent as an exact condition.** The "point of irreversibility" is the end state: a single minimal decisive coalition (pp. 9–10). The threshold is a heuristic, the kink in w's decay at about 70 of 100 (p. 7). The authors say a rigorous confirmation is still needed (p. 16).
- (v) **Absent.** The paper recommends benchmarking "reversibility capacity" (p. 17) but gives no recovery condition.
- (vi) **Absent.** The proofs are by hand.

---

## 2. Saravanan and Salla, "Self-Sealing Reward Models: When Feedback Cannot Refute Itself" (NeurIPS 2026 workshop: ELLIS Workshop on the Foundations of LLM Post-Training in Changing Environments)

**What was read.** The NeurIPS virtual-site abstract only. OpenReview (forum and pdf, id vwUCPmfW35, and its API) answered every request with a browser-verification challenge, and that check was not bypassed. No arXiv copy was found by title search. The authors' arXiv listing has a related paper ("What Does Disagreement Mean? A Semantic Identifiability Frontier for Pairwise Preference Learning", arXiv 2610.20450), but this one is not on it. **Everything below is from the abstract only.** Sections, pages, proof style, experiments and any Lean or Coq status are unknown.

**Model, from the abstract.** In self-rewarding post-training, the policy that generates future comparisons and the evaluator that scores them are both updated by the learning. So training changes the very experiment that would test its reward. An "effective information" measure is built from comparison coverage and evaluator sensitivity.

**Results, from the abstract.**
- Finite total information holds if and only if the two infinite transcript laws (of the true and the alternative world) share a common component. The rest is singular.
- In deterministic designs, the target policy is identifiable exactly when the relevant fibre stays inside one cell of the normal fan.
- Any positive equivalent component gives a nonzero minimax loss floor and linear deployment regret.
- For KL-proximal policy updates and coverage-weighted evaluator updates there is a **sharp boundary α_π + 2κ_E = 1**. Above it, support, sensitivity and one-round information all stay positive, yet total information is finite, and worlds that call for incompatible policies cannot be told apart.
- Global repair needs recurrent trusted information of a minimum rank, fixed by the "sealed policy quotient". Time-varying repair needs persistent excitation in that quotient.

**Assumed and evidence.** Not known beyond the update classes named above. The abstract mentions no experiment.

**Against the pattern.**
- (i) **Has it.** The evaluator, which is the way of choosing, is updated from the policy's own outputs. This is the abstract's central object.
- (ii) **Has an analogue.** What runs down is the information that could refute the reward. Per-round information stays positive while its sum converges, so the evaluator's own course draws down its capacity to be corrected. The abstract does not frame this as a resource or a level.
- (iii) **Not visible.** Nothing in the abstract says that the process which could correct the evaluator stands on the same depleting quantity and runs out with it. "Recurrent trusted information" is an outside input the repair needs. It is not shown to be drawn down by the loop.
- (iv) **Has it, exactly, for its update class.** α_π + 2κ_E = 1 is stated as a sharp boundary. What α_π and κ_E denote is not stated in the abstract. They are presumably decay or step exponents of the policy and evaluator updates; that is a guess.
- (v) **Close to it.** It gives a minimum-rank condition for global repair and a persistent-excitation condition for time-varying repair. This is a recovery condition after sealing, though not framed as a point of no return under reduced use.
- (vi) **Unknown.** Nothing in the abstract suggests machine checking.

**Plainly:** going only by the abstract, this paper already has a self-rebuilt evaluator, an exact threshold, and a repair condition, all for its update class. Any claim of novelty for (i), (iv) or (v) in the reward-model setting would be wrong without reading it. The one piece it does not visibly have is (iii): the turning process running out on the same level. The paper must be read whole before this placement is relied on.

---

## 3. Qiu, He, Chugh and Kleiman-Weiner, "The Lock-in Hypothesis: Stagnation by Algorithm" (ICML 2025, arXiv 2506.06166)

**What was read.** The arXiv HTML, whole: main text, Appendix A, Appendix B (proofs and time-varying extensions), and Appendix C (prompts, the entropy estimator, a truncated chat example). It was read in two passes through the fetch tool's summaries, not line by line.

**Model (§3).** N Bayesian agents estimate a scalar μ. Agent i sees o_{i,t} ~ N(μ, σ_i²) and has a private posterior with precision p_{i,t} = t σ_i⁻². Each agent also holds an aggregate belief, formed from what it is told by others it trusts, through a non-negative trust matrix W. The aggregate precision follows q_{t+1} = p_{t+1} + W q_t, and aggregate means update through W (Eqs. 3–6). In Example 3.1 (humans and an LLM), the AI trusts each human with weight λ₁ (preference learning). Humans trust the AI with weight λ₂ and treat it as an independent source, so they count again what the AI learned from them.

**Results, with their conditions.**
- Theorem 3.2, for any W ≥ 0: if the spectral radius ρ(W) > 1, some agent fails to converge to μ with probability 1, and every agent fails if W is invertible. If ρ(W) < 1, every agent converges to μ almost surely.
- Corollary 3.3 (star-shaped human–LLM W): ρ = √((N−1)λ₁λ₂). Lock-in holds **iff (N−1)λ₁λ₂ > 1**. For N = 101, λ₁, λ₂ > 0.1 is enough. The boundary case = 1 is handled by a Jordan-form remark (App. B.4).
- Theorem B.1 and Corollaries B.2 and B.3 extend this to slowly varying W(t): the matrix is primitive, ρ ≥ c > 1, entries lie in [L, U], there is a spectral gap, and the drift is below a bound h(c, L, U, N, δ). They then show false convergence occurs with probability one. This relies on Artzrouni (1991).
- The mechanism, from the proof: when ρ > 1, precision grows exponentially, so the posterior mean stops moving while it is still Θ(1) away from μ.
- §4 simulations: 100 GPT-4.1-nano agents and one "authority" that aggregates their beliefs. Semantic diversity falls, and positions move to extremes or hedge.
- §5 WildChat analysis: concept diversity in value-laden human messages declines for GPT-4. It is mixed for GPT-3.5. A regression-kink design finds downward discontinuities at model releases. The authors call this early evidence, with confounders not ruled out (§6).

**Assumed.** Gaussian observations with known variances. A static μ. Trust is exogenous: fixed in the main theorem, and a given slowly varying sequence in App. B, never updated by the process itself. Humans treat the AI as independent.

**Against the pattern.**
- (i) **Has it.** The LLM's output is rebuilt from user beliefs, which it has already shaped (§1, §3.2, Example 3.1). Note what loops here: the beliefs being aggregated. The trust weights, which are the way of choosing, are not rebuilt.
- (ii) **Has a different quantity.** What is lost is diversity, and the ability of evidence to move belief, since precision inflates. Fresh private observations keep arriving at a constant rate. Nothing the process needs is drawn down; evidence is out-weighted, not depleted.
- (iii) **Absent.** The authors name fact-checking and the LLM's independent capability as counterforces, and leave their interaction with the loop open (§3.3). They are not modelled as running on a level the loop depletes.
- (iv) **Has it, exactly, for its model.** ρ(W) > 1 against ρ(W) < 1, and (N−1)λ₁λ₂ > 1 for the star (Thm 3.2, Cor 3.3, App. B.4). This is a threshold on the loop's gain, not on a level running out, and there is no timing condition.
- (v) **Absent.** The paper says locked-in beliefs are hard to change with opposing evidence, but there is no recovery analysis. Because trust is exogenous, lowering λ below threshold after lock-in is not studied.
- (vi) **Absent.** The proofs are by hand and partly informal (they use ≈ and ∼).

---

## 4. Kulveit, Douglas, Ammann, Turan, Krueger and Duvenaud, "Gradual Disempowerment: Systemic Existential Risks from Incremental AI Development" (arXiv 2501.16946)

**What was read.** The arXiv HTML, whole: main text §§1–8 and Appendix A (cross-system influence), with the reference list skimmed. It was read in two passes through the fetch tool's summaries.

**Model.** An argument, not a formal model. Each of three societal systems (economy, culture, states) stays aligned with human interests through explicit levers (votes, purchases, protest) and through *implicit* alignment: the system depends on human labour and cognition (§1). AI replaces that labour and cognition, so both kinds of alignment weaken. Incentives to adopt AI grow, and the systems push one another away from human influence (§5, App. A). The paper separates relative disempowerment (humans richer but less influential) from absolute disempowerment (§2.4, §3.4, §4.3).

**Results, as claims.** Six claims (§1). Incremental AI, with no coordinated power-seeking, could bring an "effectively irreversible loss of human influence over crucial societal systems" (abstract). Using one aligned system to restrain another can shift the misalignment rather than remove it (§5.2). The authors say no concrete plausible plan exists to stop this (Executive Summary; §6.5).

**Assumed.** AI can broadly substitute for human cognition. Competitive pressure persists. Past alignment rested on human participation. Coordination to resist is hard.

**Evidence.** Historical cases (rentier states, Tilly on state formation, Indigenous cultures, tobacco lobbying), stylised economic facts (labour share, consumption share of GDP), the "Sydney" persona, and growth in AI companionship. Fig. 1 is illustrative, after Korinek and Suh. There are no formal results.

**Against the pattern.**
- (i) **In words.** Adoption pressure is self-reinforcing: anticipatory disinvestment in human skills, and competition (§2.4.1, §5.3). Cultural selection itself shifts toward variants that AIs transmit well (§3.4.2). Neither is formalised.
- (ii) **In words, and close.** Implicit alignment rests on human participation, and AI use draws that participation down (§1, §2.3, §4.1). This is the nearest of the four papers to "a level under a draw", but it has no variable or rate.
- (iii) **In words, partly.** The correctives (voting, boycotts, refusal of orders by security forces, mass protest) themselves rest on human participation and economic standing, which the same course erodes (§2.3, §4.2.2, §4.3.2). Using the state to correct the economy is itself a channel of disempowerment (§5.2). This is (iii) said in prose, with no formal statement.
- (iv) **Absent.** Finding tipping points is listed as an open research priority (§6.2.3).
- (v) **Absent.** "Effectively irreversible" is asserted, not derived. Mitigations are called stopgaps (§6.3).
- (vi) **Absent.** There is no formal model.

---

## Summary table

| | (i) self-rebuilt chooser | (ii) level under a draw | (iii) turner on the same level | (iv) exact threshold or timing | (v) recovery condition | (vi) machine-checked |
|---|---|---|---|---|---|---|
| RAND 2026 | no | named, not modelled | no | heuristic only (p. 7) | no | no |
| Self-Sealing RM (abstract only) | yes | analogue (information) | not visible | yes, α_π + 2κ_E = 1 | close (rank, persistent excitation) | unknown |
| Lock-in Hypothesis | yes (beliefs; trust exogenous) | no (diversity lost, evidence not depleted) | no (open, §3.3) | yes, ρ(W) > 1; (N−1)λ₁λ₂ > 1 | no | no |
| Gradual Disempowerment | in words | in words | in words, partly (§4.2.2, §5.2) | no (open, §6.2.3) | no | no |

---

## Other close work (five)

1. **"Performative Prediction"**, Perdomo, Zrnic, Mendler-Dünner and Hardt, 2020 (ICML; arXiv 2002.06673). A deployed predictor shifts the distribution it is retrained on, and the paper gives necessary and sufficient conditions for repeated retraining to converge to a performatively stable point. The best-known exact threshold for a learner rebuilt from its own effects. **Read: abstract only.** The paper's condition is remembered as sensitivity ε below the ratio of strong convexity to smoothness, γ/β; that was not checked in this read.
2. **"Degenerate Feedback Loops in Recommender Systems"**, Jiang, Chiappa, Lattimore, György and Kohli, 2019 (AIES; arXiv 1902.10730). A theoretical model in which recommendations shape user interests, which in turn shape the training data. It separates echo chambers from filter bubbles and proposes ways to slow degeneracy. **Read: abstract only.** The degeneracy condition was not seen.
3. **"Human and nature dynamics (HANDY): Modeling inequality and use of resources in the collapse or sustainability of societies"**, Motesharrei, Rivas and Kalnay, 2014 (Ecological Economics 101). A predator–prey model with nature as prey, an elite–commoner split, and accumulated wealth. Depletion or stratification can each cause collapse, a carrying-capacity measure is proposed for early detection, and there are conditions for a steady state. This is the nearest resource-and-population model to (ii), but its institutions are not shown to rebuild themselves from their own draw. **Read: search-result summaries only (no abstract page read).**
4. **"A Dynamic Theory of Regulatory Capture"**, De Chiara and Schwarz, 2021–2023 (CESifo WP 8968). A repeated game in which a firm captures a regulator through the promise of a future job rather than a bribe. It analyses cooling-off periods and conditional bans. The regulator's leaning is sustained by an equilibrium norm, not by a draw on a level. **Read: search-result summary only.**
5. **"Breaking the Self-Confirming Loop: Diagnosing and Mitigating Systemic Reward Bias in Self-Rewarding RL"**, Tan, Yuan, Wang, Li, Feng, Zhang, Shi, Zhang, Pan, Hu and Li, 2025 (arXiv 2510.08977). It measures policy–reward coupling in confidence-based self-rewarding RL, where high-confidence errors get over-rewarded, and proposes ensembled rewards to break the coupling. It is empirical, with no formal threshold in the abstract. **Read: abstract only.**

Seen in search but not read: "Why Self-Rewarding Works: Theoretical Guarantees for Iterative Alignment of Language Models" (arXiv 2601.22513). Its title suggests convergence conditions on the self-rewarding side of the boundary.

---

## Sources read

- https://www.aigl.blog/content/files/2026/08/A-Formal-Model-of-How-AI-Erodes-Human-Agency.pdf (via its storage.ghost.io redirect): RAND report, **whole** (p. 13 in part; pp. 18, 20, 22 gave no text)
- https://www.aigl.blog/a-formal-model-of-how-ai-erodes-human-agency.md: secondary summary of the RAND report, **whole**
- https://www.rand.org/pubs/research_reports/RRA4817-1.html: **not read** (HTTP 403)
- https://neurips.cc/virtual/2026/164426: Self-Sealing Reward Models, **abstract only**
- https://openreview.net/forum?id=vwUCPmfW35 and https://openreview.net/pdf?id=vwUCPmfW35: **not read** (verification challenge)
- https://arxiv.org/html/2506.06166: Lock-in Hypothesis, **whole** (in two passes, through summaries)
- https://arxiv.org/html/2501.16946: Gradual Disempowerment, **whole** (in two passes, through summaries)
- https://arxiv.org/abs/2002.06673: Performative Prediction, **abstract only**
- https://arxiv.org/abs/1902.10730: Degenerate Feedback Loops, **abstract only**
- https://arxiv.org/abs/2510.08977: Breaking the Self-Confirming Loop, **abstract only**
- HANDY (Motesharrei, Rivas and Kalnay 2014) and De Chiara and Schwarz: **search-result summaries only**; no page fetched

---

## Second pass: population and resource models with an institutional response (AI-written, 13 November 2026)

The same six points, (i) to (vi), as in the first pass. Here (ii) is a level under a draw, with regrowth. (iii) is something that could turn the process and that stands on the same level, so that it runs out too. (iv) is an exact threshold or timing condition. (v) is a recovery condition.

**Short version.** All of these papers have (ii), and none has (vi). Two have a response that triggers at a threshold, both by Pezzey and Anderies:
- the 2001 paper triggers on population;
- the 2002 working paper, the version of the 2003 journal article, triggers on resource stock per head.

In both, the trigger's position is *chosen*. It is never derived. Neither paper gives a condition saying how early the response must come. What they map is how strong it must be, against the subsistence level, with the trigger held fixed.

(iii) appears in two forms.
- **Pezzey and Anderies** have it exactly, in one sense. The tax acts only while αS > h_µ, and every quota is disobeyed once it would hold harvest per head below h_µ. So the corrective loses its grip at a stated level of the stock it protects.
- **Turchin's demographic-fiscal model** has it most plainly. The state is funded from a surplus that population growth drives down, and its resources start to fall well before the population reaches capacity.

None of these papers gives the comparison the result being placed claims: the level at which the response triggers, against the level the response needs to stand, against the level from which the resource recovers under the reduced harvest. No such comparison was found anywhere in this pass.

### 5. Brander and Taylor, "The Simple Economics of Easter Island: A Ricardo-Malthus Model of Renewable Resource Use" (AER 88(1), 1998, pp. 119–138)

**Read:** whole, from the JSTOR scan's text layer (journal pp. 119–138, Appendices A and B included).

**Model (§II).** The resource stock S follows dS/dt = rS(1 − S/K) − H (eqs. 1–2). Harvest uses a Schaefer function, H = αS·L_H (eq. 3), under open access. Utility is Cobb-Douglas, u = h^β m^(1−β), with a myopic choice at each instant. In temporary equilibrium H = αβLS (eq. 8), so a fixed share β of labour always harvests. Population follows dL/dt = L(b − d + φαβS) (eq. 11). The whole system is a Lotka-Volterra variant.

**Results, with their conditions.**
- **Prop. 1** gives three steady states. The interior one is S* = (d − b)/(φαβ), with L* = (r/(αβ))(1 − S*/K) (eq. 12). It exists iff (d − b)/(φαβ) < K (eq. 13).
- **Prop. 4** (local, proof in App. A): the interior steady state is stable. It is a spiral (cyclical convergence) iff r(d − b)/(Kφαβ) + 4((d − b) − Kφαβ) < 0 (eq. 14). Otherwise convergence is monotone.
- **Prop. 5** (global): if (13) holds, every interior start converges to the interior steady state. Limit cycles are excluded by Kolmogorov's theorem. If (13) fails, the population goes extinct and S returns to K (p. 127).
- **Simulations (§IV):** K = 12,000, α = 10⁻⁵, β = 0.4, r = 0.04, b − d = −0.1 and φ = 4 reproduce the boom and bust. With r = 0.35 the path is near-monotone, and it is strictly monotone only for r > 0.71 (p. 130).

**Institutions (§VI, pp. 132–134).** These are verbal only; there is no institution in the formal model.
- Ostrom's conditions for reform are discussed.
- The islanders may not have seen the depletion. The forest fell by at most 5 percent over a roughly 30-year lifetime, and a palm takes 40 to 60 years to mature (p. 133).
- Density-dependent fertility customs are described as consistent with the model.
- Adaptation is called a process of trial and error, unlikely to succeed within one boom-and-bust cycle.

**Evidence.** The pollen record, archaeological dates, the population estimates of 1722 and 1774, and comparisons with other Polynesian islands, the Maya, Mesopotamia and the Anasazi (§§I, IV, V).

**Against the pattern.**
- (i) **Absent.** The harvest rule is a fixed static share. It is never rebuilt from results. Only population responds, and it does so through fertility.
- (ii) **Has it exactly:** the forest and soil stock, with logistic regrowth (eqs. 1–2).
- (iii) **Absent formally.** A reader of the level appears in words only, as one who cannot see a decline that slow (p. 133).
- (iv) Exact conditions (13) and (14) and the threshold r > 0.71. They concern existence and cycling. None of them is a threshold for turning.
- (v) Recovery is automatic whenever (13) holds (Prop. 5). There is no point of no return.
- (vi) **Absent.** The proofs are by hand.

### 6. Pezzey and Anderies: the 2001 conference paper and the 2002 working paper of the 2003 article

**Read, both whole.** The 2003 *Journal of Development Economics* article itself (vol. 72, pp. 299–320) is paywalled and was **not read**. Two versions were read instead:
- **(a)** "Some further economics of Easter Island: adding subsistence and resource conservation", AARES 2001 / CRES working paper 0002 (December 2000). Its page numbers are the paper's own.
- **(b)** "The effect of subsistence on collapse and institutional adaptation in population-resource societies", ANU EEN working paper 0201 (14 January 2002), taken from a Wayback Machine copy. Its abstract matches the 2003 article's.

**Model.** This is the Brander and Taylor model, with two changes:
- **Subsistence in utility:** u = (h − h_µ)^β m^(1−β). Harvest per head is h = β(αS − h_µ)/(1 + t − βt) + h_µ if αS > h_µ, and αS otherwise (b, eq. 8). Below S = h_µ/α, all labour goes to harvesting.
- **A revenue-neutral ad valorem tax t** on resource use, with the revenue returned as a lump sum (b, eqs. 2–3).

The steady state is S∞ = [(1 + t − βt)(σ/φ − h_µ)/β + h_µ]/α if σ/φ > h_µ, and σ/(φα) otherwise (b, eq. 14).

(b) adds constant quotas: on total harvest H̄, on total effort L̄_H, and on effort per head l̄_H (eqs. 18–20). Under each quota, harvest is max(quota, h_µL), capped by the possible harvest. **A quota is disobeyed whenever it would hold harvest per head below h_µ** (b, p. 9). Footnote 5 reports that a lump-sum enforcement cost was tried and made little difference.

**The responses, in their exact form.**
- **(a), eq. 15.** The tax is t = t_max/(1 + exp(−q(1 − L/Λ))). As printed, this tends to 1 as L → 0. The text, however, says the tax "switches on" as L rises past Λ (p. 17), so the sign in the exponent looks like a misprint. The paper names three parts of any such institution: a threshold that stirs action, a speed of response, and a vision of the long-term goal (p. 17). It triggers on population and says that a trigger on resource decline would work similarly (p. 18). With t_max = 1, Λ = 4000 and q = 6, the tax nearly removes overshoot when h_µ = 0 (Fig. 7). With h_µ = 0.015 it needs t_max ≈ 3, and with h_µ = 0.02 it needs t_max ≈ 6 (pp. 19–20). The authors *conjecture* that the required t_max rises nonlinearly with h_µ. Locally, the tax lowers the Jacobian's trace only if t exceeds the bound (39), and that bound diverges as h_µ → δ/φ (App., p. 26).
- **(b), eq. 21.** The tax is **t = t_max[1 − s^b/(a^b + s^b)], with s = S/L**, the resource stock per head. The paper's rationale is that people act collectively once s falls to some threshold a. The runs use a = 5 and b = 3; the equilibrium s is 1.3 (pp. 16–17). In words, the paper says any policy must switch on before S gets too small and L too large (§4.2, p. 16). *No condition on a, or on timing, is derived.*
- **Policy diagrams (Figs. 5, 6 and 8).** These are computed with AUTO, for the Brander and Taylor parameters at fixed a and b. "Overshoot" means a population peak more than 15 percent above the steady state (p. 16).
  - For the tax, there are three regions in (h_µ, t_max):
    - **h_µ < h†_µ(0) = 0.01775:** a tax prevents overshoot, but the t_max needed rises with h_µ.
    - **0.01775 < h_µ < 0.025:** a strong enough tax prevents it, and the t_max needed goes to infinity as h_µ → 0.025.
    - **h_µ > 0.025:** no tax prevents it (pp. 17–18).
  - For a total-harvest quota, no quota prevents overshoot once h_µ > σ/φ, because the quota is disobeyed (pp. 19–20).
  - Quotas on effort per head work only if they are draconian from the start (p. 21).

**Against the pattern.**
- (i) **Partly.** Labour allocation responds to the current stock through the corner at αS = h_µ. Nothing is rebuilt from its own past choices; choice stays myopic.
- (ii) **Has it**, as in Brander and Taylor.
- (iii) **Has it in one exact sense.** The corrective's *reach*, not its budget, runs out with the level. The tax "has no effect on the corner solution" (b, p. 5), so it does nothing once S ≤ h_µ/α. Quotas fail whenever they would hold harvest per head below h_µ. The institution needs no resource to run: enforcement is costless, or a lump sum.
- (iv) **Has a trigger at a resource threshold, but no timing condition.**
  - The 2002 trigger is a per-head stock level, a in eq. 21.
  - The exact boundaries are the Hopf point h†_µ = 0.01775, the saddle-node of periodics h††_µ = 0.02573, and the asymptote at h_µ ≈ 0.025, all numerical for the Brander and Taylor parameters.
  - They map the *strength* of the response needed against subsistence. They do not map *how early* it must come.
- (v) **Partial.** The paper notes the possibility, in (b), of moving to the stock S* = K − S∞, which sustains the same harvest (eq. 17). Above h_µ > σ/φ, manufacturing never returns (a, p. 10). There is no point-of-no-return condition after a response.
- (vi) **Absent.** The work is numerical bifurcation analysis plus local hand algebra. The global claims are stated as a conjecture, as in (a), or as computed regions, as in (b).

### 7. Dalton and Coats, "Could institutional reform have saved Easter Island?" (J. Evol. Econ. 10(5), 2000, pp. 489–505)

**Read: abstract only** (IDEAS), plus a description in another paper. The full text is paywalled, and no free copy was found. A 2006 survey of the field by Dalton, Coats and Taylor on core.ac.uk returned HTTP 403.

**What is known.** The paper extends Brander and Taylor to market institutions and to different property-rights regimes (private property, consumption rights, common access). It simulates Easter Island, and it finds that changing the institutions could have damped the feast-and-famine cycles. Pezzey and Anderies (b, §4.1, p. 15) describe its property-rights changes as a *parametric* change: they alter how strongly stock growth leads to more harvesting effort. A teaching paper by the same group says Dalton and Coats propose consumption-rights rules for Easter Island that still fell short of dynamic efficiency.

**Against the pattern.** On this reading the institution is a fixed parameter. It does not respond to the level and does not draw on it.
- (iii): absent.
- (iv): absent.
- (v): unknown.
- (vi): absent.

This placement is provisional until the paper is read.

### 8. Anderies, "On modeling human behavior and institutions in simple ecological economic systems" (Ecol. Econ. 35(3), 2000, pp. 393–412)

**Read: search-result abstracts only.** No copy was found.

It extends Brander and Taylor with more realistic individual behaviour. It isolates the behavioural features that open the way to overexploitation and the institutional features that could prevent it. It uses bifurcation analysis of two societies, the Tsembaga and Easter Island. Nothing about (iii) or (iv) can be said without reading it.

### 9. Motesharrei, Rivas and Kalnay, "Human and nature dynamics (HANDY)" (Ecol. Econ. 101, 2014, pp. 90–102)

**Read:** whole, as Chapter 3 of Motesharrei's 2014 University of Maryland dissertation, which the dissertation says is the journal article. Differences from the final printed version, if any, are unknown. ScienceDirect was not tried.

**Model (eq. 3.4).** The state is Commoners x_C, Elites x_E, Nature y and Wealth w.
- ẋ_C = β_C x_C − α_C x_C and ẋ_E = β_E x_E − α_E x_E.
- ẏ = γy(λ − y) − δx_C y (logistic regrowth; only Commoners deplete).
- ẇ = δx_C y − C_C − C_E.
- Consumption is C_C = min(1, w/w_th)·s·x_C and C_E = min(1, w/w_th)·κ·s·x_E, with w_th = ρx_C + κρx_E (eqs. 3.5–3.6).
- Death rates rise from α_m to α_M as consumption falls short (eq. 3.7). Elites starve only once w/w_th ≤ 1/κ.

**Results, with their conditions.**
- **Equilibria (§3.4).** With no Elites, x_C,e = (γ/δ)(λ − ηs/δ), y_e = ηs/δ and η = (α_M − β_C)/(α_M − α_m). The carrying capacity χ is x_C,e. It is maximal at δ* = 2ηs/λ, which gives χ_M = (γ/ηs)(λ/2)² (eqs. 3.9–3.12). Analogous optima hold for an equitable society (δ**) and an unequal one (δ***, which needs condition 3.17).
- **Scenarios (simulated with Euler, step 1 year).** Raising δ above δ* moves the system from a soft landing, to oscillation, to reversible collapse cycles (at 4δ*), to an irreversible "Type-N" collapse (at 5.5δ*), all with the Table 3.1 values (§3.5.1). With κ = 100, even δ = δ* ends in a "Type-L" collapse: the workers die out while Nature recovers (§3.5.3.1).
- **Early warning.** The carrying capacity can be estimated as the population at which Wealth starts to decline (§§3.5.1.2, 3.5.2.3).

**Assumed and evidence.** Technology is constant and inequality κ is constant. Policies are parameter changes; they are listed as future work (p. 74). There are no data, only historical analogies.

**Against the pattern.**
- (i) **Absent.**
- (ii) **Has it:** Nature, with logistic regrowth.
- (iii) **Absent formally.** There is no response at all. Something near (iii) is said in words (§3.6.1, p. 67): Wealth buffers the Elites, so the part of society that could change course feels the decline last and can point to the long apparent sustainability as a reason to do nothing. That is a reader insulated from the level. It is not a corrective that runs down with it.
- (iv) **Only numerical,** in multiples of δ*. The text says an equilibrium can be reached only if χ is "not too far" from χ_M (p. 48), with no exact bound.
- (v) Reversible within a "safe" neighbourhood of δ*, and irreversible beyond a limit found by simulation (§3.5.1.3–3.5.1.4). There is no analytic condition.
- (vi) **Absent.**

### 10. Further papers for (5): a corrective whose capacity rests on what it corrects

The search was made for exactly this. Two papers were found; a general search for others found none.

**10a. Turchin and Korotayev's demographic-fiscal model, as given in Turchin, "Long-term population cycles in human societies"** (Ann. N.Y. Acad. Sci. 1162, 2009, pp. 1–17). **Read whole.** The original is Turchin, *Historical Dynamics* (2003, ch. 7), which was not read.

Model (pp. 10–11):
- Surplus per head is ρ(N) = c₁(1 − N/K).
- Population is logistic: dN/dt = r₀N(1 − N/K) (eq. 1).
- State resources follow **dS/dt = ρ₀N(1 − N/K) − βN** (eq. 2): revenue is a share of the surplus, and spending is proportional to population.
- Internal warfare follows dW/dt = aN² − bW − αS (eq. 3). The state suppresses warfare in proportion to S.
- In the full model, K(W) = k_max − cW, and warfare adds mortality dNW (eq. 4). As printed, eq. 4's S equation reads "bN" for βN, and Fig. 7's list includes a δ that the equations do not use.

Results: as the population grows, the state's resources stop growing "well before" N reaches k_max, then collapse. Warfare rises, K falls and the population crashes. Population decline lets S recover, and the cycle repeats. Depending on parameters there is a stable equilibrium or a limit cycle. Population growth of 1 to 2 percent a year gives a period of about 200 years (pp. 11–12).

From eq. 2 (this derivation is mine, not stated in the paper): S falls exactly when N > K(1 − β/ρ₀).

Against the pattern:
- (i) **Absent.**
- (ii) **Has an analogue.** The surplus per head is drawn down by density. It is not a stock with regrowth.
- (iii) **Has it, clearly.** The corrective, the state that restrains conflict and holds up K, is funded by the very surplus that population growth erodes, and it runs out before the level bottoms.
- (iv) There is a threshold, but the state does not reduce the draw, so there is no condition for turning.
- (v) Recovery is automatic, through the cycle.
- (vi) **Absent.** The results are numerical.

**10b. Muneepeerakul and Anderies, "The emergence and resilience of self-organized governance in coupled infrastructure systems"** (PNAS 117(9), 2020, pp. 4617–4622). **Read:** whole main text, from Europe PMC. The SI Appendix, which holds the derivations, was **not read**.

Model (Materials and Methods):
- Public infrastructure follows dI/dt = μPN − δI.
- The resource follows dR/dt = g − lR − NURH(I). It has constant replenishment g, not logistic regrowth.
- The effort shares of users U and providers P follow replicator equations. Users pay providers a fee C out of revenue.
- H(I) is piecewise linear, between the thresholds I₀ and I_m.

Results:
- Regime boundaries in (C, φ) are given in closed form (Fig. 2). A critical lucrativeness φ_c exists, below which the system cannot be sustained.
- At the lowest sustainable fee there is a fold bifurcation. There, the infrastructure collapses even though it is still well above I₀.
- In words, once everyone has left there is nothing to go back to.

Against the pattern:
- (i) **Has it.** Effort allocation is rebuilt from realised payoffs.
- (ii) **Has it,** with linear inflow.
- (iii) **Partly.** Governance capacity rests on revenue drawn from the resource. But the governance *enables* harvest; it does not restrain it.
- (iv) Exact regime boundaries and a fold, as functions of C and φ. They are not a timing condition for a response.
- (v) The point of no return is stated only in words.
- (vi) **Absent.**

**Considered, not read:**
- Copeland and Taylor, "Trade, tragedy, and the commons" (AER 2009): enforcement power is a parameter, not drawn from the stock.
- Good and Reuveny (2006), "The fate of Easter Island: the limits of resource management institutions" (Ecol. Econ. 58).
- Reuveny and Decker (2000).
- Erickson and Gowdy (2000).
- Muneepeerakul and Anderies (2017), Earth's Future: the publisher's page returned a browser check, which was not passed.

### Summary table (second pass)

| | (i) | (ii) | (iii) | (iv) | (v) | (vi) |
|---|---|---|---|---|---|---|
| Brander–Taylor 1998 | no (fixed share β) | yes | words only (p. 133) | existence (13), cycling (14), r > 0.71 | automatic if (13) holds | no |
| Pezzey–Anderies 2001 / 2002 | partly (corner) | yes | reach lost at αS ≤ h_µ; quotas disobeyed below h_µ | trigger on L (2001) or S/L = a (2002), chosen; strength regions h†_µ = 0.01775, 0.025, σ/φ; no timing condition | partial (S* = K − S∞) | no |
| Dalton–Coats 2000 (abstract only) | no (parametric) | yes | no | no | unknown | no |
| Anderies 2000 (abstracts only) | unknown | yes | unknown | unknown | unknown | no |
| HANDY 2014 | no | yes | words only (insulated elites, p. 67) | numerical multiples of δ* | numerical (reversible vs irreversible) | no |
| Turchin (2009 review) | no | analogue (surplus per head) | yes (state funded by eroding surplus) | S falls once N > K(1 − β/ρ₀) (my derivation) | automatic (cycle) | no |
| Muneepeerakul–Anderies 2020 | yes (replicator) | yes (linear inflow) | partly (governance funded from the resource, but enabling, not restraining) | closed-form regimes, fold, φ_c | words only | no |

### Sources read

- https://mstaylor1.org/s/The-Simple-Economics-of-Easter-Island.pdf (redirects to a static1.squarespace.com copy): Brander and Taylor 1998, **whole** (JSTOR scan with text layer)
- https://is.muni.cz/el/fss/jaro2013/HEN444/um/BranderTaylorAER98_RapaNui.pdf: **not read** (returned an HTML page, not the PDF)
- https://ageconsearch.umn.edu/record/125835/files/Pezzey4.pdf: Pezzey and Anderies 2001 (CRES WP 0002), **whole**
- http://een.anu.edu.au/download_files/een0201.pdf via https://web.archive.org/web/20110215212705id_/http://een.anu.edu.au/download_files/een0201.pdf: Pezzey and Anderies 2002 (EEN0201), **whole**
- https://doi.org/10.1016/s0304-3878(03)00078-6 (JDE 2003): **not read** (paywalled); metadata only, through OpenAlex and EconPapers
- https://ideas.repec.org/a/spr/joevec/v10y2000i5p489-505.html: Dalton and Coats 2000, **abstract only**
- https://cdn.serc.carleton.edu/files/integrate/workshops/sustainability2012/activities/exploring_easter_island_econom.v2.pdf: Coats, Luccasen and Dalton teaching paper, **partly** (passages on Dalton and Coats 2000)
- https://core.ac.uk/download/483646841.pdf: Dalton, Coats and Taylor 2006 survey, **not read** (HTTP 403)
- Anderies 2000 (Ecol. Econ. 35): **abstract only**, from search-result summaries; no page fetched
- https://drum.lib.umd.edu/bitstreams/6bb69e2c-b145-414f-8df8-5843ad6aa5e0/download: Motesharrei dissertation, Chapter 3 (HANDY) **whole**; other chapters skimmed
- https://polydora.github.io/General-ecology/Literature/Turchin%202009%20review.pdf: Turchin 2009, **partly** (the demographic-fiscal and stateless-warfare sections, pp. 10–12, read closely; the rest skimmed)
- https://www.ebi.ac.uk/europepmc/webservices/rest/PMC7060691/fullTextXML: Muneepeerakul and Anderies 2020 PNAS, **whole** main text (SI not read)
- https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1002/2017EF000562: Muneepeerakul and Anderies 2017, **not read** (browser-verification page, not passed)
- seslibrary.asu.edu model pages (nodes 138, 778, 819, 1007): **not read** (HTTP 404)
