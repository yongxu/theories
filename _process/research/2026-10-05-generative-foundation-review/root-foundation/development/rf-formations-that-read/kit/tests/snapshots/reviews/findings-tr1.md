# Findings for your group

## From the Opus review (each confirmed by an adversarial verifier; "verifier's fix" is the one to apply)

### lean-a-6 [low]
- location: REST-TR1.md §1, 'What TR1 uses that the Lean does not state' (P1)
- problem: The P1 violation is called 'a two-step cycle of the whole family'. The cycle is one shown step at the after occasion (pick o above x) followed by the met chain from x back to pick o. Its length is 1 plus the chain's length, which can exceed 2.
- evidence: Accords at o gives Shown (pick o) x; the hypothesis gives «及» met.Shown x (pick o); the concatenation is a reach of the whole family from pick o to itself.
- fix: Write 'it closes a cycle of the whole family through the after occasion (one shown step plus the met chain)'.
- verifier: Confirmed. A P1 violation gives Shown (pick o) x at the after occasion o (Accords, x open with the pick and different from it) plus a met chain x →+ pick o of any length of at least 1. The cycle therefore has length 1 plus the chain's length, which can exceed 2. 'A two-step cycle' is exact only when the met chain is one step.
- verifier's fix: Write 'it closes a cycle of the whole family through the after occasion (one shown step there plus the met chain), so the cycle rule already covers it'.


### stats-9 [low]
- location: DESIGN.md TR1 ten-minute paragraph ('no rival passes more than 0.002') and hour Stage 0
- problem: The headline leaves out the cases that pass. A stable departure from one order at 1% of presentations is a genuine forbidden case, yet it passes 0.49 (contradicted only 0.51), and at 3% it still passes 0.15. Hybrids whose order decides with a first-listed lean pass 0.998, and a 0.7/0.3 mixture passes 0.42. Those passes are correct, since their stable picks accord with one order. All of this is in REST-TR1 section 4, but the ten-minute reader learns only that rivals fail, not that power against a sparse stable violation is about one half.
- evidence: tr1.json D_power_main: S.01 P(contradicted) 0.5067, P(passed) 0.4933; S.03 0.85 / 0.15; HyO P(passed) 0.9983 with first-listed share 0.58; Mix2 P(passed) 0.4217; HyP P(passed) 0.0017.
- fix: Add one clause to the ten-minute and hour paragraphs: 'a stable violation at 1% of presentations is caught about half the time (0.51), at 3% 0.85; order-led hybrids with a position lean pass, as they should, and the first-listed share is reported beside every pass.'
- verifier: Confirmed. DESIGN's ten-minute part says 'no rival passes more than 0.002'. That is true for the group tr1.json labels 'rival' (HyP 0.0017), but it leaves out the 'sticky' genuine violations: S.01 is contradicted 0.5067 and passes 0.4933; S.03 is contradicted 0.85 and passes 0.15. It also leaves out the 'boundary' choosers: HyO passes 0.9983 with first-listed share 0.58, and Mix2 passes 0.4217. REST-TR1 lines 95-96 and 121 report these, but neither the ten-minute part nor the hour part does.
- verifier's fix: As proposed. Add one clause to DESIGN's TR1 ten-minute and Stage 0 paragraphs: a stable violation at 1% of presentations is caught 0.51 of the time and at 3% 0.85; order-led hybrids with a position lean pass, as they should; the first-listed share is reported beside every pass.


### reader-3 [low]
- location: DESIGN.md, ten-minute TR1 ('no rival passes more than 0.002') and hour TR1 'Stage 0' and 'Rivals and controls'
- problem: The summary layers leave out the hybrids that pass. Order-led hybrids with a first-listed bonus pass 0.998, and a 0.7/0.3 mixture of two orders passes 0.42. They are not in the rival group, so 'no rival passes more than 0.002' holds only because of that classing. REST-TR1 states both facts and says the first-listed share is reported beside every verdict for this reason. DESIGN's 'Rivals and controls' names only the content rule as passing every contrast, so a reader of DESIGN would think hybrids are resolved.
- evidence: tr1.json D_power_main (fresh, 600 reps): HyO P(passed) 0.9983, Hy.95/.8 0.9983, Mix2 0.4217 (role 'boundary'); frozen_reading_candidates.criterion.rival group excludes them. REST-TR1.md line 121: 'A hybrid whose order decides ... passes 0.998 ...; A 0.7/0.3 mixture of two orders passes 0.42'.
- fix: Add to the hour's 'Rivals and controls': 'Hybrids whose order decides, with a position lean, pass 0.998 and are not separated; the first-listed share is reported beside every verdict. A 0.7/0.3 mixture of orders passes 0.42.' In the ten-minute part write 'no rival of position, label, cue, menu or attention passes more than 0.002; order-led hybrids are not separated'.
- verifier: The figures check out. tr1.json D_power_main (fresh, 600 reps): HyO and Hy.95/.8 pass 0.9983 and Mix2 passes 0.4217, all with role 'boundary', outside frozen_reading_candidates.criterion's rival group. HyP, the rival group's worst, passes 0.0017. REST-TR1 line 121 lists these hybrids under 'Pass every contrast' and reports the first-listed share for this reason. DESIGN's hour 'Rivals and controls' names only the content rule. I lower the severity: the strict picks of these boundary choosers do follow one order (their order decides, or the majority order), so their passing is consistent with the correspondence tested. It is an omission in the summary, not a separation failure that would change a verdict.
- verifier's fix: Hour TR1 'Rivals and controls': add 'Hybrids whose order decides, with a first-listed lean (HyO, Hy.95/.8), pass 0.998, since their strict picks follow one order; the first-listed share is reported beside every verdict. A 0.7/0.3 mixture of orders passes 0.42, its stable picks following the majority order.' Ten-minute, if the word budget allows: 'no rival of position, label, cue, menu or attention passes more than 0.002; order-led hybrids pass, and their position lean is reported'.


### reader-13 [low]
- location: DESIGN.md, ten-minute TR1 ('contradicted at most 0.04 of the time') against hour TR1 ('near-ties drawn afresh in 0.03 of them')
- problem: The two layers give different figures for the same chooser. 0.04 comes from the 300-replication sweep; 0.03 from the 600-replication main run.
- evidence: tr1.json D_rq_status_on_D5q['r=9,q=8'].law_worst_P(contradicted) 0.04 (sweep, 300 reps); D_power_main TieC fresh P(contradicted) 0.03 (600 reps).
- fix: Use the main run's 0.03 in both layers, or say '0.03 to 0.04 across the sweep and the main run'.
- verifier: Confirmed. The ten-minute 0.04 is tr1.json D_rq_status_on_D5q['r=9,q=8'].law_worst_P(contradicted) (the sweep). The hour part's 0.03 is D_power_main TieC fresh P(contradicted) 0.03 (600 reps). Both are true, but they disagree across the two layers.
- verifier's fix: Use the main run's 0.03 in both layers, or write '0.03 in the main run (0.04 at worst in the sweep)'.



## From the cross-model review (astra, not separately verified: check each yourself before acting)

9. **Medium — TR1’s label-reader power result uses different randomization from the protocol.** [tr1.py:1253](/Users/ren/theories/.claude/worktrees/rf-landing/experiments/formations-that-read/tr1.py:1253), [REST-TR1.md:195](/Users/ren/theories/.claude/worktrees/rf-landing/experiments/formations-that-read/REST-TR1.md:195). `Label` retains its randomly favored position across repeated calls to a presentation. The proposed control reassigns codes **per call**. Under independent reassignment, a fixed-label reader produces uniform content choices, corresponding to the `Unif` row—void in the saved sweep—not `Lab`, contradicted with probability 1. **Fix:** simulate the proposed per-call assignment directly; retain stable cues as a separate rival and update the reported verdict probabilities.

