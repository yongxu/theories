# Psychological grounding of the gradual interaction trial

AI-authored evidence assessment, 19 October 2026. Targeted primary-source search,
not a systematic review, replication audit or fitted psychological model.
The question is whether `GradualInteractionTrial.lean` has empirically justified
learning rules, thresholds and setback costs. Existing Lean files and receipts
retain their conditional mathematical scope. No numerical parameter has been
estimated for Alex and Maya, and no mathematical claim changes here.

## Finding

There is empirical support for history-sensitive updating, some positive/negative
asymmetries, and reciprocal conflict/repair mechanisms. The examined work does not
calibrate +1 for support, -2 for defense or thresholds 3 and 2 in our scenario.
Several findings challenge the tally's sufficiency and deterministic update rules.
Mechanism support and numerical calibration must remain separate.

## Trust-learning experiments

See [the primary-study evidence note](TRUST-LEARNING-EVIDENCE.md) for designs,
verified sample sizes, source links and limits for Chang et al. (2010), Siegel et al.
(2018) and Li et al. (2021). These studies motivate prediction-error updating,
individual/partner differences and uncertainty. Their observed-agent and monetary
trust tasks do not estimate the parameters of criticism or humility in live dyads.

## Primary evidence from interpersonal interaction

### 1. Expectations can participate in reciprocal negative patterns

Downey, Freitas, Michaelis and Khouri (1998), *The self-fulfilling prophecy in close
relationships: Rejection sensitivity and rejection by romantic partners*.
[Author-hosted full text](https://psychology.psy.sunysb.edu/afreitas-/publications/downey_freitas_michaelis_khouri1998.pdf),
DOI 10.1037/0022-3514.75.2.545.

Diary and observational conflict studies linked rejection sensitivity, negative
responses and partner rejection. The proposed conflict pathway was supported for
women, not men, in these samples. This supports investigating an expectation →
response → partner-response loop. It does not justify universal, sex-invariant,
deterministic reproduction of the same response or an absorbing defensive state.
This is process evidence with sample and context limits, not randomized evidence
that one expectation necessarily causes another person's rejection.

### 2. Partner communication can moderate defensiveness

Overall, Simpson and Struthers (2013), *Buffering attachment-related avoidance:
Softening emotional and behavioral defenses during conflict discussions*.
[Researcher-hosted full text](https://socialinteractionlab.psych.umn.edu/sites/socialinteractionlab.psych.umn.edu/files/files/2013/2013/Overall%252C%2520Simpson%252C%2520%2526%2520Struthers%2520%2528JPSP%252C%25202013%2529.pdf),
DOI 10.1037/a0031798.

In recorded discussions involving 180 heterosexual couples, partner softening was
associated with reduced anger and withdrawal among more avoidant targets.
Softening included regard and attention to autonomy. This is closer to our dyadic
mechanism than a trust game. It motivates making receptivity depend on the
particular exchange, rather than fixing it as one Boolean. Naturally occurring
communication was observed; the result does not establish that one clarifying
sentence guarantees change or diagnose either fictional person's attachment.

### 3. Developmental history and a partner's recovery both matter

Salvatore, Kuo, Steele, Simpson and Collins (2011), *Recovering from conflict in
romantic relationships: A developmental perspective*.
[Researcher-hosted full text](https://socialinteractionlab.psych.umn.edu/sites/socialinteractionlab.psych.umn.edu/files/files/2011/2011/Salvatore%2520et%2520al.%2520%2528PS%252C%25202011%2529.pdf),
[PubMed](https://pubmed.ncbi.nlm.nih.gov/21245491/), DOI 10.1177/0956797610397055.

The observational study followed 73 target participants and their partners.
Earlier attachment and recovery after a conflict discussion related to later
functioning; partner recovery buffered insecure histories in the prediction of
relationship stability over two years. This supports including both histories and
a partner's contribution to recovery. It supplies neither an additive buffer size
nor a fixed count of experiences. Recovery meant appropriate disengagement from
conflict into a cool-down task, not simply continuing clarification.

### 4. The kind of breach changes the recovery process

Schweitzer, Hershey and Bradlow (2006), *Promises and lies: Restoring violated trust*.
[Author-hosted full text](https://faculty.wharton.upenn.edu/wp-content/uploads/2014/06/Promises-and-Lies.pdf),
DOI 10.1016/j.obhdp.2006.05.005.

A laboratory experiment with 262 participants found recovery through consistent
trustworthy behavior, but lower recovery when the breach also involved deception.
Trust did not fully recover in the deception condition during the observed task.
This supports repeated behavioral evidence while challenging the idea that enough
uniform positive increments necessarily erase every breach. A deceit dimension or
credibility-dependent learning could be needed. It does not show that trust can
never recover from deception in life, nor calibrate a setback for defensiveness.

### 5. A behavior's significance depends on the problem context

McNulty and Russell (2010), *When “negative” behaviors are positive: A contextual
analysis of the long-term effects of problem-solving behaviors on changes in
relationship satisfaction*.
[Primary article](https://pmc.ncbi.nlm.nih.gov/articles/PMC2845983/),
DOI 10.1037/a0017479.

Two longitudinal studies found that associations between direct negative
problem-solving behavior and later satisfaction depended on problem severity.
This challenges a universal mapping from unpleasant behavior to a negative
learning event. It calls for distinguishing personal attack, firm task disagreement,
boundary-setting and avoidance. The observational findings do not establish that
aggression or humiliation is beneficial, or that denying an actual error is the
same behavior as appropriately resisting an unfair demand.

### 6. Communication quality is not a deterministic causal forecast

Johnson et al. (2022; online 2021), *Within-couple associations between communication
and relationship satisfaction over time*.
[Publisher full text](https://journals.sagepub.com/doi/pdf/10.1177/01461672211016920),
DOI 10.1177/01461672211016920.

Across three longitudinal datasets, concurrent within-couple associations between
negative communication and satisfaction were more consistent than lagged
prediction of change. This challenges treating our recurrence as an empirically
established pathway to future relationship outcomes. The four-month/annual lags
also cannot settle moment-to-moment effects. Immediate conversational response,
expected cooperation and long-term relationship satisfaction must be different
outcomes in the model and its validation.

## Assumption-by-assumption map

These verdicts are our synthesis of the cited evidence, not further findings from
a single paper. “Not calibrated” is not a claim that the number is mathematically
wrong; it means it has no empirical estimate in this application.

| Current code/assumption | Evidence assessment | Modeling consequence |
|---|---|---|
| `revise`: every supporting record adds 1 | Gradual updating is supported; identical increments are not | Test an expectation-dependent update and person-specific rates |
| `revise`: every defense subtracts 2 | No transferable ratio established | Estimate outcome- and context-dependent effects; do not prescribe a universal negative multiplier |
| Thresholds 3/2 | Not calibrated | Compare a fitted threshold with a probabilistic response policy |
| Two different histories matter | Supported in broad form | Represent priors and relationship-specific learning; do not infer them from a label |
| One tally is sufficient for each person | Challenged by uncertainty, credibility and context effects | Separate expected cooperation, confidence, and relevant breach/context distinctions |
| More cooperation supplies a buffer | Partial, context-bound support | Test whether the buffer reflects prior certainty, current conduct or partner regulation |
| Enough positive records always restore the earlier tally | True of our rule, not established psychologically | Allow incomplete recovery, changes in credibility or context-dependent persistence |
| Fixed `conditions.receptive` | Too coarse for the interaction evidence | Make partner responsiveness partly state/context dependent |
| `DefensiveBasin` cannot be left habitually | Formal consequence of the stipulated policy only | Include alternative responses/exploration/external events and test transition probabilities |
| No forgetting/saturation/context shifts | Not established by this review | Treat as an open modeling choice, not a research-backed assumption |
| An established error rules out attack | Unsupported and not in our formal model | Keep task correctness separate from interpersonal treatment |
| Lower distress or more cooperation means greater maturity | Not established | Keep empirical outcomes separate from ethical appraisal |

## Research-informed candidate revision, not yet fitted or implemented

A simple comparison model is a bounded expectation of a constructive response:

q[i,t+1] = q[i,t] + alpha[i,t,sign] * (y[i,t] - q[i,t]).

Here q is a person's expectation about a specific partner, y is that person's
interpreted evidence about the exchange, and alpha is a fitted learning rate.
It is not a moral worth score. Distinguish the observed behavior, the person's
interpretation and the latent belief; y is not automatically the other person's
true intention. Separate task competence/correctness from benevolence/integrity.

With alpha between zero and one, the update stays bounded and its magnitude
depends on the gap between expectation and evidence. Separate positive/negative
rates can be tested, rather than presuming which is larger in every context.
An uncertainty-sensitive alternative can also vary alpha with confidence and
perceived volatility. The exact architecture is a hypothesis to compare, not a
validated unified account of humility or a prescription to update toward trust.

Action selection should be separate from belief updating. Consider a probabilistic
choice among clarification, acceptance of a specific correction, disagreement,
pause, boundary-setting and withdrawal, conditional on belief and context. A hard
threshold is one candidate; it should compete with alternatives. Partner behavior
is coupled to this choice but not controlled by it.

Our old “buffer” can arise in more than one way: stronger prior confidence can
reduce updating; a partner's response can help regulate the interaction. Conversely,
a surprising betrayal can be highly informative. The confidence and appraisal
assumptions decide which effect dominates. No fixed positive-minus-negative tally
should be accepted solely because it produces an appealing repair trajectory.

## What calibration would require

Define a target such as the next response or the reported expectation of
cooperation, not an unobserved universal maturity score. Collect longitudinal,
consented, event-level observations from both partners, including their separate
appraisals and expectations, context and independently coded response types.
Record uncertainty in coding and distinguish absence of feedback from negative
feedback. The target population and interval must match the intended application.

Compare the present tally, a symmetric prediction-error model, asymmetric rates
and an uncertainty-sensitive model. Use person/relationship-specific parameters
with partial pooling, parameter/model recovery checks, and held-out later
exchanges or held-out dyads. Otherwise different priors and rates may fit the same
short trajectory. Report uncertainty, not a single universal repair ratio.
Observational fit alone does not identify a causal effect of a humble response;
causal claims need an appropriate design and measured alternative explanations.

Trial-wise parameters from programmed trust games can motivate candidate priors
or sensitivity ranges with their task boundaries stated. They cannot be directly
relabelled as effects of interpersonal defensiveness. No participant-level fitting,
causal intervention, or replacement Lean proof was performed in this review.

## Consequence for the checked mathematics

The old Lean theorems remain valid for the rule they state. Their results are not
promoted to empirical predictions. Revising the rule requires revising its state
and abstraction map, then checking new conditional properties (for example bounds,
evidence sensitivity and context-specific responses). The core composition
components remain reusable; empirical correspondence is still a separate burden.
