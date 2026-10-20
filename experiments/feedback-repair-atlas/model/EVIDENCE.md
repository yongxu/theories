# Evidence behind the update laws

This note assesses the evidence for the update laws in [FeedbackAtlas.lean](FeedbackAtlas.lean). It comes from a targeted search of primary sources. It is not a systematic review, a replication audit or a fitted model, and no parameter is estimated for the two fictional positions. The earlier, longer assessments of the superseded models are kept in [history](../history/2026-10-20-consolidation/model/PSYCHOLOGICAL-GROUNDING.md).

## What each law takes from the studies

| Law in §2 | Supported by | Not supported, and supplied by the model |
|-|-|-|
| Expectation moves toward each observation by 1/(c+1) of the gap: a prior revised by experience | Chang et al. (2010) found that trust behaves as a belief revised trial by trial from a prior | The step size, the starting prior 1/2 and the starting weight 2 |
| A defensive move lowers confidence (c′ = ⌊c/2⌋ + 1), so a reading built from defense stays revisable | Siegel et al. (2018) found that beliefs about harmful agents are more uncertain and more readily revised | Halving as the size of that loss; the studies observed agents, not repair within a relationship |
| Confidence grows with constructive moves, so a long constructive history absorbs one lapse | Li et al. (2021) found investment persisting for formerly cooperative partners after their reciprocation fell | The rate; the same study found loss learning faster, which this law does not separately encode |
| A fresh explanation counts with weight r; explanations that check out raise r and misleading ones lower it, each with its own evidence weight k | Schweitzer et al. (2006) found that trust recovered through consistent behavior, but recovered less when the breach involved deception | That credibility is one number per position; the two-step check histories in the examples |
| The reply depends on both ends' readings, and each end learns from the other's actual reply | Downey et al. (1998) linked rejection expectations, negative responses and partner rejection; Overall et al. (2013) found that partner softening reduced defensive responses | A deterministic threshold reply; the 2/3 probe; that a pause is the only alternative to defense |

## Primary studies

- **Chang, Doll, van 't Wout, Frank and Sanfey (2010)**, "Seeing is believing: Trustworthiness as a dynamic belief", *Cognitive Psychology* 61, 87–105, [doi:10.1016/j.cogpsych.2010.03.001](https://doi.org/10.1016/j.cogpsych.2010.03.001). The study had 61 participants playing a repeated monetary trust game with programmed partners. Their parameter estimates rest on eight trials.
- **Siegel, Mathys, Rutledge and Crockett (2018)**, "Beliefs about bad people are volatile", *Nature Human Behaviour* 2, 750–756, [doi:10.1038/s41562-018-0425-1](https://doi.org/10.1038/s41562-018-0425-1). The first experiment had 38 participants, with replications of 163 and 135. Observers predicted agents' choices between money and shocks to another person.
- **Li, Hao, Mei, Cheng, Sun and Qu (2021)**, "How adolescents and adults learn about changes in the trustworthiness of others through dynamic interaction", *Frontiers in Psychology* 12:690494, [doi:10.3389/fpsyg.2021.690494](https://doi.org/10.3389/fpsyg.2021.690494). The study had 72 participants, and the programmed partners did not respond to them.
- **Schweitzer, Hershey and Bradlow (2006)**, "Promises and lies: Restoring violated trust", *Organizational Behavior and Human Decision Processes* 101, 1–19, [doi:10.1016/j.obhdp.2006.05.005](https://doi.org/10.1016/j.obhdp.2006.05.005). This was a laboratory experiment with 262 participants.
- **Downey, Freitas, Michaelis and Khouri (1998)**, "The self-fulfilling prophecy in close relationships", *Journal of Personality and Social Psychology* 75, 545–560, [doi:10.1037/0022-3514.75.2.545](https://doi.org/10.1037/0022-3514.75.2.545). These were diary and observational studies, and the conflict pathway was supported for women only.
- **Overall, Simpson and Struthers (2013)**, "Buffering attachment-related avoidance", *Journal of Personality and Social Psychology* 104, 854–871, [doi:10.1037/a0031798](https://doi.org/10.1037/a0031798). The study recorded conflict discussions of 180 couples.
- **McNulty and Russell (2010)**, "When 'negative' behaviors are positive", *Journal of Personality and Social Psychology* 98, 587–604, [doi:10.1037/a0017479](https://doi.org/10.1037/a0017479). The association between a behavior and later outcomes depended on problem severity. This is why §1 keeps the task error and the personal delivery as separate facts, rather than treating every unpleasant remark as one negative event.

## Limits

None of the studies calibrates the laws for criticism and repair in a working exchange. Monetary trust games and observed agents do not measure how a person replies to a terse remark. The laws have no forgetting, no inferred volatility beyond the halving after defense, no severity weighting and no correction for dependent reports. Calibrating the laws would require consented, event-level observations from both ends of real exchanges, coded independently. The laws would then need to be compared against alternatives on held-out exchanges. Until that is done, the numbers on the page show what the laws imply. They are not predictions.
