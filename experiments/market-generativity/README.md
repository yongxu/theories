# Market renewal selection and capture

6 October 2026. Executable counterpart of [the mathematical market study](../../theories/becoming/history/MARKET-DYNAMICS-MATH.md). The named connection is shared-support consequences → implemented charges → selection of practices → paid changes to the effective selection rule. These are supplied local economic and physical laws, not empirical market data or a completed derivation of institutions from the generative foundation.

The model tracks renewing share, effective accountability, accumulated paid influence, liquid correction funds and separate support stocks. Actual receipts pay a levy, maintenance, political organization, liability and private returns. A funded installed policy restores accountability; influence erodes it. An essential support failure stops all subsequent production and payment. A nonessential recipient can be harmed without disabling the market.

## Results and verification scope

The mathematical study proves a robust invariant region, a zero-disturbance attracting set, a recovery region, explicit intermediate reserve requirements and a destructive region ending in finite support failure. The same primary parameters permit both favorable and destructive histories.

| Verification | Scope and result |
|---|---|
| [Lean source and guide](formal/README.md) | 39 checked theorems, including the generic rational invariant at every time for arbitrary admitted disturbance histories, accounting, essential-support guard, exact certificate and interval recovery |
| [Exact executable checks](results/verification.json) | 2,187 rational one-step rectangle checks, cash identities, seven named finite examples and five violated-boundary counterexamples |
| [Independent reconstruction](results/independent-verification.json) | 2,187 rectangle points, 21,600 broader domain/accounting points, 48 exact short-history steps and three independently derived exact witnesses |
| Long continuations | Twelve 800-round runs at 80-digit precision, independently recomputed at 120 digits; 48,861 scalar comparisons pass the declared absolute tolerance of 10⁻⁶⁸ |

The observed maximum numerical discrepancy is approximately 2.979 × 10⁻⁷⁸. It reflects finite precision, not empirical uncertainty. The Lean module does not prove the real-valued convergence arguments or a simulator-refinement theorem; the independent reconstruction checks the implementation separately. The full details and critiques are in [the mathematical review](../../_process/research/2026-10-05-generative-foundation-review/foundation-assessment/MARKET-FORMAL-REVIEW.md).

## Primary certificate

The unit-period parameters are receipts `P=10`, levy and restoration cost `tau=k=1`, fund cap `3`, maintenance cost `c=2`, maximum liability `f=4`, political cost `ell=1/2`, selection rate `eta=1/5`, restoration rate `alpha=1/4`, capture rate `beta=1/2`, influence turnover `mu=1/4`, and paid influence target `lambda=1`. The productive stock has renewal `r=2`, extraction depletion `d=1`, depreciation `delta=1/10`, no additional burden, and floor `5`.

The payoff difference favors renewal exactly when `q>3/8`. A robust sufficient region is

- renewing share `x>=3/4`;
- accountability `q>=1/2`;
- accumulated influence `w<=1/4`;
- liquid beginning funds `1<=B<=3`;
- productive support `C>=5`.

It remains invariant with adverse accountability disturbances at most `1/20` and additional support losses at most `1/2` each round. These bounds describe this parameterization, not universal policy thresholds. At zero disturbance, operational coordinates converge to `x=q=1,w=0,C=20`, with the initial funded reserve retained because levy equals intervention cost. This is an equilibrium family indexed by `B`.

The same parameters have a destructive region `x<=1/10,q<=9/25,w>=9/10` that necessarily crosses the positive support floor despite continued funding of restoration. A separate one-step collar outside the safe accountability/influence bounds enters the protected region. An exact example even reverses an initially negative private return difference before support failure.

## Saved comparisons

| Scenario | First economic failure | Interpretation |
|---|---:|---|
| Renewal region | None through 800 | Consistent with the invariant and attraction proofs |
| Bounded adverse shocks | None through 800 | Supports remain above admitted floors |
| Capture region | 21 | Actual stopped history, not continued receipts after failure |
| Same initial state with capture coefficient zero | None through 800 | Isolates the rule-erosion channel at unchanged initial resources and payments |
| Rule frozen at its initial low value | 21 | Fixed bad selection also fails; endogenous capture is not the only failure mechanism |
| Ideal fixed accountability | None through 800 | Disclosed ideal comparator; initialization and maintenance are supplied |
| Initially unaffordable correction | 5 | Receipt timing matters |
| Permanent authorization veto | 28 | Available funds alone do not supply authority |
| Levy one half of the intervention cost | None through 800 | Intermittent correction can suffice; 400 interventions are paid |
| No renewing variant initially | 19 | The switching law creates no absent variant |
| Initially negative payoff difference with recovery | None through 800 | Exact first-round transition enters the protected region |
| Excluded nonessential recipient | None through 800 | Recipient support violates its floor in round 1 despite stable production |

The half-levy result rules out an unnecessarily strong interpretation: `tau>=k` is sufficient for the proved every-round funding rectangle, not necessary for all surviving histories. Its 800-round survival is numerical evidence within the synthetic law; a separate intermittent-funding invariant has not been proved.

## Reproduce

The computations require only Python's standard library. From the repository root:

```sh
python3 -B experiments/market-generativity/run.py
python3 -B experiments/market-generativity/independent_check.py
python3 -B experiments/market-generativity/formal/check.py
```

The Lean checker uses a specified installed Lean 4.29.1 binary, freezes its source, builds in a temporary directory and audits all theorem dependencies. It does not install dependencies. [The formal guide](formal/README.md) records an alternative compiler path setting and the exact checked scope.

`model.py` is the transition and ledger implementation; `run.py` produces rational checks and [saved trajectories](results/trajectories.csv). `independent_check.py` reconstructs the equations without importing either implementation. Verification files hash their inputs and code. Rerun their dependent checks after substantive changes; editing this guide does not add scientific evidence.

## Supplied premises and next connection

The fixed demand, payoff-driven switching, truthful classification of liable practices, protected floors, installed authority, influence conversion, physical renewal law and external support inputs remain premises. Entry, individual bargaining and exit, endogenous price formation and learning which liabilities are warranted need further mechanisms. The all-renewing limit concerns one practice classification; it does not establish ownership concentration, uniform people or the loss of all other forms of diversity.

[The identification note](../../_process/research/2026-10-05-generative-foundation-review/foundation-assessment/MARKET-IDENTIFICATION.md) specifies observations and a conventional equation-identical comparator. The generative account of 6 October named as its next foundational bridge the formation and consequence-sensitive revision of the calibrated liability and correction mechanisms, with costs, actual authority and previously unrepresented recipients retained; that account's [generative grounding](../../theories/becoming/history/GENERATIVE-GROUNDING.md) is kept in history.
