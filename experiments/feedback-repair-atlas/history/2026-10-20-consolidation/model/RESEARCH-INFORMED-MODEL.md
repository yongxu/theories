# Separate expectation, confidence and credibility

`ResearchInteractionTrial.lean` is a checked candidate model motivated by the
[psychological evidence review](PSYCHOLOGICAL-GROUNDING.md). Its numbers are synthetic,
not fitted psychological parameters. It imports the earlier examples and reuses
`Becoming.Coupling.wholeNext`, `Becoming.Readout.foldl_semiconj` and constructive
arithmetic from `Becoming.Copying`. No core source or result registration changes.

## Three different questions

| State | Meaning in this model | What it does not establish |
| --- | --- | --- |
| Expectation q, between 0 and 1 | Expected constructive behavior from this partner | Their motives, moral worth, or a calibrated probability |
| Confidence c, positive evidence weight | How resistant that expectation is to one new observation | Measured subjective certainty or statistically justified precision |
| Credibility r, between 0 and 1 | Weight assigned to fresh favorable explanations from this partner | Reliability in every domain, or permission to discount observed misconduct |

Each person retains their own interpreted event history and their own state about
the other person. These are partner-specific learning states, not personality types.
The retained history is not a complete autobiography.

For a direct constructive observation y = 1 or defensive observation y = 0:

    q' = (c q + y) / (c + 1)
    c' = c + 1
    r' = r

This is a bounded weighted-evidence baseline. Its prediction-error learning rate is
1/(c+1), so the same new event changes an expectation less when its prior evidence
weight is larger. A fixed defensive penalty such as -2 is no longer necessary.
Direct positive and negative observations have equal weight here: the research does
not establish a universal negative-to-positive ratio.

For a fresh favorable explanation:

    q' = (c q + r) / (c + r)
    c' = c
    r' = r

An explanation can affect expectation without certifying its own credibility or
adding independent behavioral evidence. An externally marked stale explanation
adds nothing. Freshness is supplied by the input; duplicate detection is not proved.
Repeated distinct favorable reports can still accumulate influence, a limitation
that would need an evidence ledger or dependence model in a stronger version.

Independent verification changes credibility separately: reliable reports move r
halfway toward 1, misleading reports halfway toward 0. This half-step is an
illustrative rule, not a measured effect size. Verification does not itself change
behavioral expectation in this version. Real incidents could supply both kinds of
evidence, which would require both updates or a richer event type.

## Same expectation, different histories, same lapse

Both histories begin with q = 1/2 and c = 2. One receives two constructive
observations; the other receives eleven constructive and then three defensive
observations. The resulting expectations are equal, but their evidence weights differ.

| History | Before lapse q | Before lapse c | After identical defensive observation |
| --- | --- | --- | --- |
| Short | 3/4 | 4 | 3/5 = 0.600 |
| Longer | 3/4 | 16 | 12/17 ≈ 0.706 |

These are proved by `same_expectation_different_confidence` and
`same_lapse_different_updates`. Longer history is not automatically better history;
it supplies more weight under this rule. Three recent defensive observations do
not receive extra recency weight. That is a substantive limitation.

## The two people change each other's next experience

Alex makes the same forced defensive lapse in every comparison. Maya first learns
from it, then responds; Alex learns from her actual response. His own lapse does
not automatically lower his expectation of Maya.

To make the comparison determinate, the demonstration holds both response probes
at 2/3. The policy chooses constructive engagement when q reaches the supplied
probe; otherwise an explicit input selects defense or pause. This is an illustrative
choice rule. No human threshold or random sampling law has been measured or proved.

- With short histories for both people, Maya's q falls to 3/5; she responds
  defensively under that policy. Alex then falls to 3/5 too.
- Holding Alex's short history fixed but giving Maya the longer history, her q
  remains 12/17. She replies constructively, and Alex's q rises to 4/5.
- Giving Alex the longer history and Maya the short history, Maya returns defense.
  Alex's q remains 12/17; on the next habitual exchange he acts constructively.
  Maya then reaches 2/3 and replies constructively. Alex reaches 13/18.
- Maya can instead pause after the lapse. Her lower expectation then does not
  supply Alex with another defensive observation; his q stays 3/4.

These are checked by `maya_history_changes_reply`,
`maya_history_changes_alex_next_expectation`,
`alex_history_can_interrupt_returned_defense` and `pause_alternative`.
`lower_expectation_can_still_clarify` also checks that a different supplied probe
allows constructive engagement at q = 3/5. Belief does not determine action alone.

## Same explanation, different credibility

Two further histories have equal q = 3/4 and c = 4, but independently verified
report histories give r = 7/8 versus r = 1/8. The same observed lapse reduces both
to q = 3/5: credibility does not excuse the observed behavior. The identical fresh
favorable explanation then yields:

| Prior credibility | Expectation after lapse | After explanation |
| --- | --- | --- |
| 7/8 | 3/5 | 31/47 ≈ 0.660 |
| 1/8 | 3/5 | 25/41 ≈ 0.610 |

`direct_lapse_equal_despite_different_credibility` and
`same_explanation_different_effect` prove these values exactly. Neither explanation
restores 3/4, independently proves honesty, or establishes absence of personal attack.

## What research supports, and what remains assumed

The [evidence map](PSYCHOLOGICAL-GROUNDING.md) and
[trust-learning notes](TRUST-LEARNING-EVIDENCE.md) give primary sources and study limits.
Chang et al. motivate prior-plus-experience learning; Siegel et al. motivate keeping
impression and uncertainty distinct; Schweitzer et al. motivate separating claims
from demonstrated reliability. Work on rejection expectations and partner responses
motivates reciprocal dynamics. These support the architecture as a candidate,
not every formula or causal arrow.

The model assumes observations have already been interpreted, behavior has been
coded into coarse categories, evidence units are comparable, and the partner is
stable enough for accumulated evidence to remain relevant. It has no forgetting,
volatility inference, context generalization, severity model, correlated-evidence
correction, or fitted subjective confidence. In particular, evidence that negative
impressions can be more volatile challenges unconditional growth of c. A changing
partner may justify faster updating rather than greater inertia.

The full event histories project exactly to the three-part summaries for every
finite supplied interaction plan (`histories_and_summary_agree`). This is true
because the supplied policies only consult those summaries. It does not prove
that these three variables suffice for actual humans. The earlier interpretation
trial's epistemic limits still apply: this extension does not infer true motives,
assign blame, prove safety, or impose an obligation to remain engaged.

## Verification

Run with Lean 4.29.1:

    LEAN=/absolute/path/to/lean python3 -B verify_research.py

`research-verification.json` binds the result to source hashes and the checker;
`research-verification.log` contains the build and declaration audit. The checks
include a general weighted-average bound, all finite-plan summary agreement,
separation properties and concrete reciprocal trajectories. This local imported
application check does not replace the full package environment/purity audit.

Checked on Lean 4.29.1: 22 theorems, 52 audited source declarations and a
51-module transitive closure; no warnings or reported axiom dependencies. Source
and verifier hashes were checked against the receipt after the successful build.
