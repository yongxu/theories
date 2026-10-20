# Empirical evidence on gradual interpersonal learning

AI research note, 19 October 2026. This is an evidence assessment of the illustrative rules in `GradualInteractionTrial.lean`, not a new formal result. No participant-level parameters have been estimated for Alex and Maya.

## Primary studies

**Chang, Doll, van ’t Wout, Frank and Sanfey (2010), “Seeing is believing: Trustworthiness as a dynamic belief,” Cognitive Psychology 61, 87–105.** [DOI](https://doi.org/10.1016/j.cogpsych.2010.03.001); [author-hosted full text](https://www.cosanlab.com/static/papers/Changetal2010CogPsy.pdf). N=61 undergraduates after three exclusions; repeated monetary trust game with programmed reciprocation. Initial facial impressions interacted with experience. A dynamic-belief model supported trial-wise updating. This supports revisable priors and gradual learning, not fixed event increments. The paper cautions that parameter estimation used only eight trials. Monetary investment and facial cues do not calibrate humility, criticism or autobiographical histories.

**Siegel, Mathys, Rutledge and Crockett (2018), “Beliefs about bad people are volatile,” Nature Human Behaviour 2, 750–756.** [DOI](https://doi.org/10.1038/s41562-018-0425-1); [institution-hosted full text](https://www.tnu.ethz.ch/fileadmin/user_upload/documents/Publications/2018/2018_Mathy_s41562-018-0425-1.pdf). Initial laboratory N=38; replications included N=163 and N=135. Observers predicted agents’ choices trading money against shocks to another person. Beliefs about less moral agents were more uncertain and revised more readily. This challenges invariably resistant negative expectations and motivates tracking confidence separately from expectation. Participants observed programmed decisions, rather than repairing their own relationship; the findings do not establish a universal setback weight.

**Li, Hao, Mei, Cheng, Sun and Qu (2021), “How Adolescents and Adults Learn About Changes in the Trustworthiness of Others Through Dynamic Interaction,” Frontiers in Psychology 12:690494.** [DOI and full text](https://doi.org/10.3389/fpsyg.2021.690494); [publisher full text](https://www.frontiersin.org/articles/10.3389/fpsyg.2021.690494/full). N=72: 36 adults and 36 adolescents. Programmed partners changed from 70% or 30% reciprocation to 50%. Fitted learning differed by partner history, feedback valence and age. Loss learning was faster, yet investment persisted for formerly cooperative partners. This supports context-dependent asymmetry and a possible history buffer, not a fixed negative-event ratio. Programmed partners did not adapt reciprocally to participants.

## Consequences for this trial

The +1, -2, and thresholds 3/2 remain demonstrative choices. None of these studies estimates them for a criticism-and-repair interaction. Individual differences do not identify these two fictional people's parameters. The existing abstraction agreement proves consequences of its supplied learning rule; it does not establish that the tally contains all psychologically relevant history.

Candidate replacement, proposed here rather than validated by these studies:

`next expectation = current expectation + learning rate × (interpreted outcome − current expectation)`

Use a bounded expectation, person/partner-specific priors, and candidate learning rates conditional on outcome and context. Keep uncertainty, attribution, and action selection distinct. Compare this against an uncertainty-sensitive model and the existing tally model with held-out observations; do not select a model only because its trajectories appear plausible. A lapse can affect both expected cooperation and confidence, and must not automatically have identical effects on both people. Empirical work must establish how observable exchanges are coded as interpreted outcomes and whether they predict subsequent responses.

Boundary: these studies concern social inference and monetary trust, not a validated measure of humility. They motivate mechanisms and challenge simplifications; they do not establish the efficacy of a humble reply or the obligation to continue engagement.
