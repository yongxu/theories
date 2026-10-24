# Market renewal selection and capture

6 October 2026. AI-authored mathematical development requested in [Ren's market conversation](../../../sources/15-codex-theory-conversations/2026-10-06-markets-and-generative-basins.md). This supplies a conditional formalization of [the market guidance](MARKETS-AND-GENERATIVE-REGIMES.md). It defines an operating market, proves sufficient conditions for continued shared renewal, gives certified subsets of attraction and recovery, and preserves destructive alternatives under the same laws. The [executable model](../../../experiments/market-generativity/README.md), [independent review](../../../_process/research/2026-10-05-generative-foundation-review/foundation-assessment/MARKET-FORMAL-REVIEW.md) and [identification contract](../../../_process/research/2026-10-05-generative-foundation-review/foundation-assessment/MARKET-IDENTIFICATION.md) distinguish mathematical results, numerical checks and empirical obligations.

The named foundational connection is **supporting consequences → monetary consequences → selection of practices → changes in the effective rule of selection**. The model establishes that connection under a supplied liability institution. It does not derive the institution's legitimacy, the initial formation of its machinery, or inclusive concern from private profit.

## State and operating boundary

The state at the beginning of round \(t\) is

\[
s_t=(x_t,q_t,w_t,B_t,C^1_t,\ldots,C^m_t,o_t).
\]

Here \(x\in[0,1]\) is the share of renewing practices in a fixed mass of service provision; \(q\in[0,1]\) is effective exposure of a liable practice to a collectible charge; \(w\in[0,1]\) is accumulated organizational influence used to erode that exposure; \(B\in[0,\bar B]\) is liquid, authorized correction money; and \(C^j\ge0\) are separate supports. They can represent a productive resource and particular affected groups' capabilities, with independently specified units and floors \(L_j>0\). They are never added into a universal welfare stock.

The Boolean \(o\) records whether production is operating. Fix an essential subset \(E\subseteq\{1,\ldots,m\}\). Operating initial states satisfy \(C^j\ge L_j\) for every \(j\in E\). After an operating round, crossing an essential floor makes \(o'=0\). Failure is absorbing in this model: no further services, taxes, fines, restoration or state changes occur. Recovery from physical shutdown would need a separately supplied restart mechanism. A nonessential recipient can fall below their floor while the market continues; this distinction exposes exclusion rather than treating it as acceptable.

Production supplies one normalized unit of service, with receipts \(P\) paid by buyers outside the modeled money account. Demand and price are fixed while essential supports suffice. Renewable support flows rely on supplied physical conversion laws and environmental inputs. Fixed demand, fixed population, divisible practices and the absence of entry are local assumptions, not general economic facts.

## Actual payments and selection

A renewing practice spends \(c>0\) on its maintenance process. An extracting practice spends \(\ell\ge0\) on political organization and faces expected collectible liability \(fq\), with \(f>0\). Each pays the same levy \(\tau\). Private net returns are

\[
\pi_R=P-\tau-c,
\qquad
\pi_D=P-\tau-fq-\ell.
\tag{1}
\]

Assume \(0\le\ell<c<\ell+f\) and \(P\ge\tau+\max(c,f+\ell)\), so the stipulated payments are affordable in every operating state. The liable practice is identified through a supplied calibrated observation/enforcement channel. Its charge is an actual transfer, not the analyst's valuation of generativity. Fines enter an external restitution account; they neither refill the correction fund nor automatically repair a physical support. A policy that made restitution effective would need its own conversion mechanism.

The payoff-driven adjustment law is

\[
x'=x+\eta x(1-x)(fq+\ell-c), \qquad \eta>0.
\tag{2}
\]

It represents reallocation or imitation in a fixed population, not a cash-conserving capital-growth equation. Define

\[
\theta=\frac{c-\ell}{f}\in(0,1),\qquad
\eta\max(c-\ell,f+\ell-c)\le1.
\tag{3}
\]

**Proposition 1.** Equation (2) preserves \([0,1]\). For \(0<x<1\), renewal increases exactly when \(q>\theta\), decreases exactly when \(q<\theta\), and is unchanged at equality. Both \(x=0\) and \(x=1\) are absorbing for the share law. Selection cannot create an absent practice.

**Proof.** The payoff difference in (1) is \(fq+\ell-c\). Write \(x'=x[1+\eta(1-x)(fq+\ell-c)]\) and \(1-x'=(1-x)[1-\eta x(fq+\ell-c)]\). Bound the difference between \(-(c-\ell)\) and \(f+\ell-c\); both brackets are nonnegative under (3). The sign and boundary claims follow directly. ∎

The operating cash identity is

\[
P=\tau+xc+(1-x)fq+(1-x)\ell+x\pi_R+(1-x)\pi_D.
\tag{4}
\]

Political expenditure is costly now. Any subsequent advantage from it must pass through the influence and accountability states; it is not assumed to be profitable merely because it is called capture.

## Paid correction and endogenous rule erosion

Let \(a_t\in\{0,1\}\) denote whether the installed institution authorizes restoration. The main results concern the explicit installed policy \(a_t=1\) in every operating round. With cost \(k>0\),

\[
u_t=a_t\mathbf1\{B_t\ge k\},\qquad
B'=\min(\bar B,B-ku+\tau).
\tag{5}
\]

The bill is paid before this round's levy is received. Overflow
\(D_B=\max(0,B-ku+\tau-\bar B)\) is disbursed outside the modeled fund. Thus

\[
B+\tau=B'+ku+D_B.
\tag{6}
\]

Paid influence persists according to

\[
w'=(1-\mu)w+\mu\lambda(1-x),\qquad
0<\mu\le1,\quad0\le\lambda\le1.
\tag{7}
\]

Here \(\lambda=A\ell\) is the supplied conversion from political expenditure into influence; \(\ell=0\) requires \(\lambda=0\). The spending flow is \(\ell(1-x)\). Equation (7) is a memory of paid organizational activity, not a claim that influence equals total wealth.

Accountability changes through paid restoration, accumulated influence and an adverse disturbance \(e_t\):

\[
q'=\left[(1-\alpha u-\beta w)q+\alpha u-e_t\right]_0^1,
\quad 0<\alpha,\quad0\le\beta,\quad\alpha+\beta\le1,
\quad0\le e_t\le\varepsilon.
\tag{8}
\]

Brackets clip to \([0,1]\). The effective selection rule is \(fq+\ell-c\), so (2), (7) and (8) form a closed loop: selected practices alter paid influence, influence changes collectible exposure, and exposure changes selection. The legal maximum \(f\), target of liability and restoration recipe stay fixed. This formalizes endogenous erosion and repair of an effective rule; it does not yet model deliberation that discovers a new legal objective or invents a new institution.

**Proposition 2.** If \(B\in[k,\bar B]\), \(\tau\ge k\), \(\bar B\ge k\) and authorization continues, the fund remains in that interval and restoration is paid every round. If \(B<k\), an arbitrarily large end-of-round receipt cannot pay the current bill. With \(\tau=k\), funded reserves remain constant. With \(\tau>k\), they reach \(\bar B\) in finitely many operating rounds.

These are consequences of payment order and (5). The inequality \(\tau\ge k\) guarantees the specified every-round schedule. It is not necessary for every possible surviving schedule: intermittent correction can suffice.

## Separate support renewal

For each support, use the supplied physical law

\[
C^{j\prime}=\max\left(0,(1-\delta_j)C^j
+(r_j+d_j)x-d_j-h_j-v^j_t\right),
\tag{9}
\]

where \(r_j,d_j,h_j\ge0\), \(0<\delta_j\le1\), and \(0\le v^j_t\le\nu_j\). Renewing activity produces net input \(r_j\), extracting activity incurs loss \(d_j\), \(h_j\) is an additional burden shared by the practices, and \(\delta_j\) is depreciation. These are different support units from the monetary costs in (1). Their connection to an actual technology requires identification.

The generative target is componentwise: **every specified support remains above its justified floor, renewal has a feasible continuing route, and accountability and its funding remain effective**. These floors and their ethical significance are explicit commitments. An equilibrium of prices or private returns cannot supply them by itself.

## A robust invariant region

Choose \(0<\underline x<1\), \(\theta<\underline q<1\), and \(0\le\bar w\le1\). Define

\[
K=\{s:o=1,\ \underline x\le x\le1,\
\underline q\le q\le1,\ 0\le w\le\bar w,\
k\le B\le\bar B,\ C^j\ge L_j\ \forall j\}.
\tag{10}
\]

**Theorem 3, continued generativity under bounded disturbances.** Assume the preceding parameter conditions and the installed authorized policy. If

\[
\begin{aligned}
\tau&\ge k,\qquad \bar B\ge k,\\
\bar w&\ge\lambda(1-\underline x),\\
\alpha(1-\underline q)&\ge\beta\bar w\underline q+\varepsilon,\\
(r_j+d_j)\underline x-d_j-h_j-\nu_j&\ge\delta_j L_j
\quad\text{for every }j,
\end{aligned}
\tag{11}
\]

then every operating step from \(K\), for every admitted disturbance, remains in \(K\). Consequently every finite prefix and the entire resulting infinite sequence satisfy the constraints. No failure guard is reached. The renewing share is nondecreasing and, away from \(x=1\), strictly increases.

**Proof.** Funding gives \(u=1\). The payoff difference is at least \(\gamma=f\underline q+\ell-c>0\), so Proposition 1 preserves the share bounds. Equation (7) is a convex combination of quantities at most \(\bar w\). Before clipping, the smallest right-hand side of (8) on the box occurs at \(q=\underline q,w=\bar w,e=\varepsilon\), because \(1-\alpha-\beta w\ge0\); (11) places it above \(\underline q\). Clipping cannot remove that bound. For each support, the minimum occurs at its floor, the lower share and the largest disturbance; its inequality in (11) gives the next floor. All essential supports are among these supports, so the next state is operating. Induction yields the history result. ∎

For the independent faces of this product region, the non-strict boundaries have direct meaning. At \(x=\underline x\), \(q<\theta\) makes the share leave its lower face. At \(w=\bar w,x=\underline x\), failure of the influence inequality makes influence leave its upper face. The accountability, fund and support lower corners similarly witness failure of their respective inequalities. Positive floors ensure clipping cannot hide support failure. **These are sharp conditions for this rectangular certificate. They are not necessary conditions for every viable trajectory or every differently shaped viable region.** Strict \(\underline q>\theta\) is used for uniform growth; non-strict equality can suffice for share invariance alone.

## An actual attracting set

**Theorem 4, zero-disturbance attraction.** Under Theorem 3 with \(e=v=0\), every initial state in \(K\) converges in its operational coordinates to

\[
x_*=1,\quad w_*=0,\quad q_*=1,\quad
C^j_*=(r_j-h_j)/\delta_j.
\tag{12}
\]

If \(\tau>k\), \(B_*=\bar B\). If \(\tau=k\), \(B_t=B_0\in[k,\bar B]\): the attractor is a set of equilibria parameterized by the inherited reserve, not a single point. The set \(K\) is a certified subset of its basin under the installed law, not a characterization of the whole basin.

**Proof.** With \(\gamma=f\underline q+\ell-c>0\),

\[
0\le1-x_{t+1}\le(1-\eta\underline x\gamma)(1-x_t).
\]

The coefficient lies in \([0,1)\), hence \(x_t\to1\). Equation (7) is a stable linear recursion with input tending to zero, so \(w_t\to0\). Put \(z_t=1-q_t\). At zero disturbance and with paid restoration,
\(z_{t+1}=(1-\alpha)z_t+\beta w_tq_t\); its decaying input gives \(q_t\to1\). Invariance keeps supports positive, so clipping in (9) is inactive; their stable linear recursions converge to (12). The fund claims follow from Proposition 2. ∎

The stable-recursion fact used here is elementary: split its geometric convolution into a finite old prefix, which decays, and a recent tail bounded by the supremum of its vanishing input divided by the fixed contraction gap. Bounded persistent disturbances preserve \(K\) under Theorem 3 but need not produce the same equilibrium or convergence. A real-valued convergence proof and a rational invariant proof have different scopes.

## Recovery before support failure

The update in (2) is nondecreasing in \(q\) and in \(x\) on the unit square. Its derivative in \(x\) is \(1+\eta(1-2x)(fq+\ell-c)\ge0\) by (3). The other coordinate maps have the corresponding monotonicity used above.

**Theorem 5, recovery from an external starting box.** Assume all parameter, funding and authorization hypotheses of Theorem 3, including \(\tau\ge k\), and that its target region \(K\) satisfies (11). Suppose initial operating states satisfy \(x\ge x_L\), \(q\ge q_L\), \(w\le W\), \(B\ge k\) and \(C^j\ge L'_j\), with the usual upper bounds and initial essential floors. A sufficient condition for their next state to enter \(K\) is

\[
\begin{aligned}
x_L+\eta x_L(1-x_L)(fq_L+\ell-c)&\ge\underline x,\\
\alpha+(1-\alpha-\beta W)q_L-\varepsilon&\ge\underline q,\\
(1-\mu)W+\mu\lambda(1-x_L)&\le\bar w,\\
(1-\delta_j)L'_j+(r_j+d_j)x_L-d_j-h_j-\nu_j&\ge L_j.
\end{aligned}
\tag{13}
\]

**Proof.** Apply the monotone extrema in each coordinate and the funded transition. Every resulting support meets its target, so failure is avoided and Theorem 3 applies from the next state. ∎

This is a genuine recovery result from outside the certified invariant region. It does not assume that the market continues paying taxes after collapse. More generally, for a planned pre-failure history with \(0<\delta_j<1\), write \(a_j=1-\delta_j\) and \(b^j_s=(r_j+d_j)x_s-d_j-h_j-v^j_s\). Maintaining a positive floor through time \(H\) is equivalent to the exact prefix condition

\[
C^j_0\ge\max_{0\le t\le H}
a_j^{-t}\left[L_j-\sum_{s=0}^{t-1}a_j^{t-1-s}b^j_s\right].
\tag{14}
\]

The equivalence follows by unwinding (9) while the floor holds. At the first failure, clipping cannot rescue a positive floor. When \(\delta_j=1\), each next-round condition is simply \(b^j_t\ge L_j\). Equation (14) is a feasibility test for a proposed recovery path, not permission to ignore intermediate failure. If the required reserve exceeds actual storage or available provision, that path is unavailable.

## A destructive region under the same laws

At zero disturbances, assume the authorized installed policy and Proposition 2's funding hypotheses, so correction is paid every operating round. Assume also that at least one support is essential, \(E\ne\varnothing\). Choose \(0<x_D<1\), \(0\le q_D<\theta\), and \(0\le w_D\le1\) satisfying

\[
w_D\le\lambda(1-x_D),\qquad
\alpha(1-q_D)\le\beta w_Dq_D.
\tag{15}
\]

**Theorem 6.** Until economic failure, the region \(x\le x_D,q\le q_D,w\ge w_D,B\ge k\) is invariant in these coordinates. With \(\gamma_D=c-\ell-fq_D>0\),

\[
x_{t+1}\le[1-\eta(1-x_D)\gamma_D]x_t.
\tag{16}
\]

If production could continue indefinitely, \(x\to0\) and every support with \(d_j+h_j\ge0\) and \(\delta_j>0\) would tend to zero under (9). Any positive essential floor must therefore be crossed in finite time. The actual killed process enters its absorbing failure state; the fictitious continuation after failure is not an economic trajectory.

**Proof.** Negative payoff difference lowers \(x\). Equation (7) preserves the influence lower bound. The maximum possible next accountability occurs at \(q_D,w_D\), where (15) makes it no greater than \(q_D\); the coefficient is nonnegative. Equation (16) gives decay. For supports, the forcing term tends to \(-d_j-h_j\le0\); clipping at zero and depreciation imply convergence to zero in the hypothetical nonfailed continuation. Infinite operation would contradict a positive essential floor. ∎

Thus spending on correction can be continuously affordable yet too weak relative to accumulated influence to reverse selection. Failure is conditional on the region and parameters; it is not an inevitable property of markets or regulation.

## One fully specified instance

The exact rational instance uses

\[
\begin{gathered}
P=10,\quad \tau=k=1,\quad\bar B=3,\quad c=2,\quad
f=4,\quad\ell=\tfrac12,\quad\eta=\tfrac15,\\
\alpha=\tfrac14,\quad\beta=\tfrac12,\quad\mu=\tfrac14,
\quad\lambda=1,\\
r=2,\quad d=1,\quad\delta=\tfrac1{10},\quad h=0,\quad L=5.
\end{gathered}
\tag{17}
\]

The profit threshold is \(\theta=3/8\). The box
\(x\ge3/4,q\ge1/2,w\le1/4,B\in[1,3],C\ge5\)
is invariant for \(e\le1/20\), \(v\le1/2\). Its selection margin is \(1/2\), accountability margin is \(1/80\), and support margin is \(1/4\). The zero-disturbance attracting support is \(C_*=20\).

A starting collar \(x\ge4/5,q\ge49/100,w\le13/50,C\ge5,B\in[1,3]\) enters that box under the same disturbance bounds. Its worst next accountability is \(2519/5000\) and worst influence is \(49/200\). A stronger illustrative reversal starts at \((x,q,w,B,C)=(4/5,7/20,1/20,1,5)\) without disturbance. The initial profit difference is \(-1/10\), so renewal first shrinks, but the next state is

\[
(x',q',w',B',C')=(0.7968,0.50375,0.0875,1,5.9),
\]

which lies in the protected box. Correction can therefore reverse an initially destructive selection direction before physical failure.

The same parameters admit the destructive region
\(x\le1/10,q\le9/25,w\ge9/10\). Its pre-failure support obeys
\(C_{t+1}\le0.9C_t-0.7\), hence
\(C_t\le(C_0+7)0.9^t-7\) while it continues. This supplies a finite failure bound without inventing post-failure revenue.

## Counterexamples and interpretation of the guidance

| Proposed guidance | Formal content | Failure of an overstrong reading |
|---|---|---|
| Renew indispensable supports | Separate inequalities in (11) and the prefix condition (14) | Positive profits or a favorable selection gap can coexist with next-round support failure |
| Make contribution consequential | The actual payoff threshold in Proposition 1 | The charge's target and calibration are supplied; an analyst's favorable evaluation pays no bill |
| Preserve alternatives | Positive initial share is required for selection to amplify a practice | At \(x=0\), no price or accountability change creates the missing variant; entry needs another law |
| Fund timely correction | Pre-payment guard and fund identity | Later receipts, a vetoed budget or one successful repair do not guarantee continuing effective correction |
| Keep rule changes answerable | Coupled influence/accountability inequalities | Continuously funded restoration can lose to capture; independent authority and correct observation are assumptions |
| Protect differentiated people | All specified support floors enter the certificate | A nonessential person can be depleted while the productive market converges and private returns remain positive |

For the last counterexample, add a nonessential recipient with \(r=d=0,h=1,\delta=1/10,L=5\). At the productive fixed state \(x=q=1,w=0,C^{\mathrm{productive}}=20\), their support falls from 5 to 3.5 in one round while production continues unchanged. This extended system fails the generative certificate. Its economic stability does not justify its treatment of the recipient.

Correct calibration is equally substantive. If the same liability were instead imposed on renewing practices, the payoff difference would become \(\ell-c-fq<0\) everywhere. Stronger enforcement would then strengthen adverse selection. This alternative-law calculation is a counterexample to enforcement as sufficient guidance, not a result that the main correctly targeted law discovers its own calibration.

Finite computation also preserves a useful positive exception: under the specified high initial state, reducing the levy to \(1/2\) produces intermittent paid correction and survives the tested horizon. This refutes treating \(\tau\ge k\) as a necessary condition for every generative history. It does not weaken its role in the every-round invariant theorem.

## Verification and limits

The paper gives real-valued proofs of invariance, attraction, recovery and finite failure. The [Lean development](../../../experiments/market-generativity/formal/README.md) checks the rational transition, boundary inequalities, arbitrary-history invariant, accounting, operating guard and stated concrete cases; its exact theorem inventory and dependency audit are recorded there. It does not prove the real-valued limit arguments. The executable checks use exact fractions for finite boundary and accounting tests and explicitly finite-precision decimals for longer trajectories. Numerical trajectories do not prove a complete basin boundary or universal behavior.

The model is also a conventional dynamic resource-and-incentive system. An equation-identical conventional controller predicts exactly the same results; the word generative adds no mathematical advantage. The proposed contribution is a connected statement of which supports, rewards, rule dynamics, costs and affected centers must be composed, together with explicit sufficiency boundaries and failures. [The empirical identification note](../../../_process/research/2026-10-05-generative-foundation-review/foundation-assessment/MARKET-IDENTIFICATION.md) specifies how to test its interpretations and compare alternatives. The limit \(x=1\) means every surviving practice falls within the renewing classification; it says nothing by itself about the number of firms, ownership concentration or diversity within that class.

This completes a conditional mathematical model of the requested market mechanisms. It leaves the actual market parameters, richer entry and bargaining, price formation, false or strategic observation, legitimate rule revision, formation of the institution, and the justification and acquisition of concern as explicit further work. The [governing foundation](../history/GENERATIVE-GROUNDING.md) still requires those broader derivations; neither this model nor its verification completes them.
