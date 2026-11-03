# T1's standing beyond the model

*AI-written, 3 November 2026 (board item T1S, the coordinator's word after [TS](THESES-STANDINGS.md#not-done-here)). No person has reviewed it. About 15 minutes to read, the last two sections' 6 included; [the check's report](T1-STANDING-CHECK.txt), about an hour and a quarter more.*

TS's reader found two gaps in T1 that no front could fix until the home did. T1's home, [02 §5](../../../../../../theories/becoming/chapters/02-MAP.md#t1), had *In the model*, *Forbids*, *Refuted by* and *Evidence*, but no *Standing*, while T2, T3 and T6 each say how far they are established. And [08 §9](../../../../../../theories/becoming/chapters/08-METHOD.md#theses)'s row copied only the first in-the-model clause, so the joint draw, what the thesis is about, was missing from the table. 08 §9 defines standing as "how far it is established (proved under named premises, supported by frozen tests, conjectured, argued)" and says the table copies it from the home. This item gave T1 its standing in the home and copied it to 08's row. Documents only: no Lean, no record and no core run.

## What changed

**02, T1's *In the model*.** The joint-excess clause said "joint excess over a gated renewal ends it whatever each drawer's own draw". The Lean is narrower: `Flow.joint_excess_ends` ends dependents after `n` consecutive steps of joint excess from a level below `n + m`, not after any excess. Labelled proved, the clause had to say what is proved, so it now takes 05's words with their premises ([05](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-own-count-misses-joint-excess)): "in a balanced flow where activity needs support and only active formations give, under the gate at need `m`, `n` consecutive steps of joint excess from a level below `n + m` end every formation depending on the condition at a need of at least `m`, whatever each drawer's own draw".

**02, T1's new *Standing*.** In the model proved, on the regime and on the World model (*In the model*); beyond them conjectured, on the frozen tests. The thesis in the model is the contrapositive of `Flow.joint_excess_ends`, as [§284](../../BECOMING-RENEWAL-READING.md#284-theses-and-conjectures-the-theorys-strongest-claims-with-their-standing-th1) first stated it, so its content as a thesis lies in actual conditions meeting the premises. The standing then says what the frozen tests establish of that:
- **The one real-data pass.** Of the three settings passed, one is real data: the need separated fates on regimes of one yeast experiment, whose only draw is the dilution (MQ2, §266). The regimes were held out from the fit but not from the analyst, who had read them in MQ1 and seen there, post hoc, a need separate their fates when read by the floor MQ2 then pre-registered (§253; MQ2's frozen predictions and the tests' README say so).
- **Yeast data not read before.** On these, no frozen test of the need or of the fates it separates has passed: at the instrument's floor twice (MQ1's D2, MQ6's A1), next to the fold (MQ6's A2), and after the salt shock (MQ2's C1 and C2). The *Evidence* already listed each failure. The standing says what they show together.
- **The salt shock.** On the first reading every population stood above the predicted need, so the need called fates as the null did (0.78). That meets the letter of T1's *Refuted by*, "fates across a predicted point separated no better than by a null". With none below the need, the test could not reach what T1 forbids, and each error was a death above the need. Needs placed post hoc by that experiment's own levels before the shock are right at DF 825 and wrong at 750, 0.81 in all. Four days after the shock is too short, the study says, to settle fates near the need.
- **The simulations.** The other two passes are simulations, the only tests whose design has more than one drawer. In the simulated yeast, two harvesters each within the largest sustained draw and together beyond it collapsed the population, as follows in the deterministic limit once their draws add; what could have failed there is that their harms together exceeded the sum of their separate harms, in every cell. The other passes bearing on T1 hold by the mathematics in the deterministic limit (§253). In the commons, joint excess is an identity of its accounting, and the scope prediction, with one harvester, could have failed and held (§240).

**08 §9, T1's row.** Its Standing cell copies the home's *In the model* in full, the joint-excess clause and its premises included, and then the standing beyond the model, shortened, keeping each qualifier: the analyst, the first reading, and what the simulations' passes test.

## How it was read

T1's five studies were read in full: §240 (CG1), §253 (MQ1), §266 (MQ2), §272 (MQ3) and §314 (MQ6). So was §284, where T1 was first given its standing, and so were the sciences dossier's S-14 and S-03. T2's, T3's and T6's standings were read for their form. The study's count, three settings passed and four failed, is the *Evidence*'s and stays.

## The check

An independent check read the first draft. It had three lenses (the evidence, the standing in 08 §9's sense, and consistency with everything that copies T1), and an adversarial verifier read each finding. All the agents were AI and read-only. The workflow ran 26 agents, one verifier per finding, more than the nine estimated. Their report, findings and verdicts, is [T1-STANDING-CHECK.txt](T1-STANDING-CHECK.txt). None of its 23 findings was refuted outright: three were confirmed and twenty partly, each verifier correcting the finder's fix.

**Taken**, into the home first and then 08's row:
1. "Held-out" without its qualifier read as unseen data. The regimes were held out from the fit, not from the analyst.
2. The standing named one real-data failure, the salt shock. Every frozen test of the need or its fates on yeast data not read before failed, and the standing now says so.
3. The salt-shock sentence left out which side failed, and it read a post hoc reading as a rescue. The deaths were above the need, the converse T1 does not claim. The post hoc reading places the needs by the separate experiment's own levels, not by a change the shock made, and does little better than the frozen rule.
4. "The only tests with more than one drawer" was not exact. The fish stocks' catch is read as one draw. After the re-check: "the only tests whose design has more than one drawer".
5. The simulated passes were counted without what their own records say they test. Each is now said.
6. The joint-excess clause, now labelled proved, said more than the Lean. It now takes 05's words, in the home and in the row.
7. In 08, "T1's *Refuted by*", as T2's row names its own, and "on frozen tests", as T2's row has.

**The re-check.** A fresh reader, also AI and read-only, re-read the combined text against the same sources and the Lean. It confirmed that no frozen test of the need or its fates on yeast data not read before passed, listing each one. It also confirmed the first reading's 32 of 32 populations above the need, and the post hoc 8, 8, 3 and 7 correct at the four dilutions. It found eight more points, all taken:
1. The joint-excess clause dropped 05's premises: balance, activity needing support and only active giving. The Lean has them too. They are now named.
2. The analyst had seen more than the floor in MQ1: per-regime needs, and fates separated by them at five of six regimes (MQ2's frozen predictions say so).
3. *Refuted by* names no side. The salt shock meets its letter. With every population above the need, the test could not reach what T1 forbids.
4. 08 dropped "on the first reading". On the next day's reading the need did one population better than the null.
5. "Read more than one drawer apart" is false for the commons, whose count pools every take. Now: "whose design has more than one drawer".
6. The simulated yeast's collapse follows in the deterministic limit once the two harvesters' draws add. What could have failed was super-additive harm.
7. 08 left out the home's qualifiers on the two simulations.
8. "Proved on the regime and on the World model" could be read as T1 itself proved. Now: "in the model proved", as 08's row says.

**Not taken.**
- *Narrowing T1's* Refuted by *to the side the thesis claims.* Two readers noted that the thesis and *Forbids* are one-sided, while *Refuted by*'s second form, fates across a predicted point separated no better than by a null, is two-sided, so deaths above the need can meet it. The form stays. Narrowing a refutation clause just after a result met its words would choose the scope afterwards, which the home's *Evidence* rules out ("the need is measured apart from the fate it predicts, so the scope is not chosen afterwards"). The two-sided form also tests what *In the model* claims, that the point is exact. The standing now says on which side the one such result fell.
- *Rewording the* Evidence *parenthesis on the salt shock* ("the converse, not claimed: a shock changes the regime and its need"). It says why the converse is not claimed, not what the post hoc analysis showed. The sciences dossier quotes it word for word (S-14), so it stays.

## What follows, with their owners

**The sciences dossier** (its owner, "Names and identity discussion"), now that the home has landed:
- the front's T1 Standing cell (SCIENCES.md:18) copies 08's new cell;
- the front's tests cell, "the simulated one", becomes the two simulations;
- S-03's known weakness (:112), "T1's home gives its standing only in the model", is no longer true, and could read "Their standings say so.";
- "How this dossier was made" (:694) says the same in the present tense;
- S-14's "Standing and use" (:404) says "Thesis", and could say "Thesis, proved in the model and beyond it conjectured";
- S-14's list of the simulation's passes (:407) names A2 and A3 only, and the home now names the two harvesters (A4).

The ecology hour (the front with S-11 to S-16) is at its 6,000-word budget exactly, so whatever the front or S-14 gains needs the hour's stated time restated, or the same words cut there. The check's measure-based estimate is 48 words on the front. The front's ten-minute excess is recorded in READING-BUDGETS and grows with it.

**The fronts** (their owner):
- *The one page and the overview.* ONE-PAGE.md:17 and THE-THEORY-OF-BECOMING.md:49, with their Chinese editions, say "T1: three settings passed, four failed". That is true, but next to "Proved on models" it can read as the standing. It could read "T1, conjectured: three settings passed, four failed".
- *The overview's T1 cell.* THE-THEORY-OF-BECOMING.md:166, and its Chinese edition, could open "in the model proved, the point exact; beyond the model conjectured".
- *OPENING's note on conditions.* OPENING.md:65, rendered into README.md:85, says T1 is "supported on held-out regimes of real yeast, untested in the field". That is "supported" where the home now says "conjectured", it leaves out the four failed settings, and a frozen field test on fish stocks did run and failed. The home's exact claim is that no field test of a need measured in advance has run.
- *The collective page.* COLLECTIVE-DIRECTION.md:85 cites T1 for a fish-stock result about the withheld-levels margin, which T1 excludes. T1's own timing result is the regime margin timing neither break in yeast driven past its fold. This predates T1S.

The check gives an exact wording for each, with its sources, in [T1-STANDING-CHECK.txt](T1-STANDING-CHECK.txt).

## After TS2's reader

*Added 3 November 2026 (T1P, a correction with no board row). About 3 minutes to read.*

The sciences dossier's reader for TS2 found that T1's exactness clause, "that point is exact" in the home and "the point of no return is exact" in 08's row, named none of the premises it is proved under, as the joint-excess clause had named none before T1S. `RegimeMargin.ends_iff_below` takes `0 < H + y`, `Short g H y`, `FromNothing g`, `Meets g H y hi`, `Keeps g H hi` and a level up to `hi`. Labelled proved, the clause had to say them, so the home's *In the model* and 08's row now copy the home theorem's words ([02 §5](../../../../../../theories/becoming/chapters/02-MAP.md#r-margin-of-a-regime)).

A reader other than the author, one AI agent, read-only, checked the draft against the Lean, and a second, also one, re-checked the revision. It confirmed the joint-excess clause and every premise but `Meets`, and found five points, all taken:
1. Read under the new premises, "the point" is `H + y`, and the clause that it lies at least the draw above the need needs giving to meet the draw at `y` (`RegimeMargin.root_above_need` takes `H ≤ g y`). The exactness premises give that only where `y + H ≤ hi`. A counterexample meets every stated premise and fails the clause: `g` zero below 10 and 5 from 10, `H = 1`, `y = 3`, `hi = 2`, the need 10. The clause now says "the draw positive and met at `y`", and the home theorem says the same.
2. "Meets it from `y` up to a top `hi`" asked more than `Meets`, which needs the draw met only at each `z` from `y` with `z + H` at most `hi`. The home theorem, T1 and 08's row now say "meets it at every `z` from `y` with `z + H` at most a top `hi` the step keeps", and the laws of two records say the same of the top (margin-of-a-regime's law 2; threshold-in-the-state-plane's law 5 and its hypotheses, of the band's top), each with a history note. The re-check found that law 2 had also never named `0 < H + y`, without which it fails where the draw and `y` are both zero; it now names it, with the premises it had left to law 1.
3. 08's row had lost the clause's verb; it has "lies" again.
4. Exactness is proved in whole numbers, and the any-amounts row shows runs over the reals need not rest. Both now say "in whole numbers".
5. "That point" stood about forty words from what it names, and the leading "where" seemed to cover the World clause. The home now reads "on the regime, …, the point of no return is exact, …; on the World, …", and 08's row, whose semicolon separates the two standings, "on the regime, …, and on the World, …". After the re-check, "the point lies" replaces an "it" that could be read as the level.

Not done here:
- The module docstring of `RegimeMargin` and the docstring of `threshold_regime` use the same loose gloss of `Meets`. A docstring changes Lean bytes, so they go with the next edition's docstring pass and its core run.
- The sciences dossier's S-12 and its front cell copy the old words; they go to their owner.
- The fronts' short forms ("the point exact", COLLECTIVE-DIRECTION's "the point of no return is exact" with its home linked) go to theirs.

## The regime's home

*Added 4 November 2026 (RGP, a correction with no board row). About 3 minutes to read.*

TS3's reader and the Names session, following T1P into the sciences dossier, found two more places where the regime's home and its record say more than the Lean. Each came with a counterexample, and I computed both. Under the coordinator's rule after T1FP2, a finding lands now only where it would make a reader believe something false. One that only makes a correct statement more exact goes to the board's batched pass for the next edition.

**Landed now.**
1. **The record's statement** said the condition holds exactly from a least level up, with no top. That is false: law 2's exactness reaches only the levels up to a top the step keeps, and above the top a level can end. Take giving 5 at 5, 6 and 7 and nothing elsewhere, a draw of 5, `y = 5` and a top of 12. Every premise of law 2 holds and giving meets the draw at `y`. Within the top, levels end exactly below 10, yet 13, 14, 18 and 19 end. From 14, the draw leaves 9, which gives nothing, and 9 lies below the point. The statement now names the point of no return, the draw above the least level whose giving meets it, as exact up to a top the step keeps, under each law's premises. It also drops "harms", the evaluative word law 5 dropped on 1 November (ND). The record has a history note, and its laws are unchanged.
2. **02 §5's "giving lowered by the regime raises it further"** claimed a strict rise. The Lean gives one only where the lowered giving falls short of the draw at the old least level (`RegimeMargin.lowered_raises_strictly`); otherwise the least level is no lower (`RegimeMargin.lowered_raises`). Example: giving 0 below 10 and 5 from 10, lowered to 3 above 10, a draw of 3. The least level is 10 under both laws. The sentence now says both, under the same draw.

**For the batched pass** (each true where "the point" has its sense, the draw above the least level meeting it):
- 02 §5's theorem on the rises names the giving's premises but not the three least levels `rises_superadditive` takes. Read after the theorem before it, where the point is `H + y` under that theorem's premises, it fails. Take giving 0 below 10 and `z − 9` from 10, need 10, two draws of 3. Each draw's point is 15, so the sentence promises the joint draw's point at least 9 above the need. But `y = 10` with `hi = 5` meets every premise of the exactness theorem for the joint draw 6, and that point, 16, lies only 6 above the need; the joint draw's least meeting level gives 21. A reader checked this wording against the Lean: "with joint giving subadditive above the need and no greater than under either draw, where the least levels meeting the two draws and the joint draw lie `a`, `b` and `c` above the need, `a + b ≤ c + 1`, so the joint draw's point, the draw above the least level meeting it, rises above the need by at least the sum of the two draws' rises less one".
- The same paragraph's "The time to break lies in a band" names no premise and cites no declaration (`RegimeMargin.not_before`, `RegimeMargin.falls_within`, the latter with giving at most `Y` and `Y ≤ H ≤ b`).
- The record's law 3 leaves "the point of no return" undefined. Its hypotheses field omits FromNothing, Root, Lowered and the positivity premises, and its correspondence still says "joint harm".

The same two examples meet the hypotheses that COLLECTIVE-DIRECTION's regime row states. The first fails its rises clause; the second fails only a reading of its exactness as holding from a least level up. That row's owner has them.
