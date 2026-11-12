AI-written, 12 November 2026

# An alignment researcher's reading

**In short.** One thing here is wanted by the field and missing from it: a small exact model of a selection that wears away its own oversight. The work holds the pieces, has not closed it, and keeps it under 210,000 words about everything else. For alignment the direction is sound. The way it is carried out hides it.

Sources outside the repository are named from memory, not reopened today.

## 1. Ten minutes

On the one page I would stop near minute three and not write back. What stops me:

- A page called "one page" opens "*Twenty-nine to thirty-seven minutes to read.*"
- "A map of how anything comes to be, lasts, changes and ends within one relational unfolding". This marks a theory of everything, and those go unread.
- The first paragraph has 321 words; one sentence of the case has 121.
- "An AI review of prior work ... finds each central result near-definitional or a known result restated, none new mathematics." Honest; it tells me I may leave.
- "Made with AI, proofs included ... no independent human review is recorded yet."

What would hold me: "a rule read from the share of its own winners can lock on them while a loss it does not read grows". I know that worry from reward models retrained on their own winners.

The map is better. I would read the first path to its end. Two sentences make me stay. "No law drawn says what brings a loss to get back to the rule or to be counted" names the open problem. Step 16, where the rule had turned "but the lead, grown large, used up what the counters of the loss stood on", is something I had not seen stated. Then I would look for the model in notation I can check, and find none.

## 2. What is here for alignment

By the work's own review (08 §8) nothing is new mathematics. From the Lean I read, I agree.

**Restated from known work.**
- The drain (05 §7, `Optimum.least_iff`). Optimising a proxy, a measure standing in for what is wanted, pushes what it leaves out to the floor, exactly where a trade-off the work calls "room" holds. This is Zhuang and Hadfield-Menell's (2020) Theorem 1 in whole numbers; the "exactly where" is a small sharpening.
- The lock (02 §9, `RuleCapture.favouring_locks`, `perturbation_absorbed`). A rule refit from its own picks settles into a region it cannot leave. Where every refit favours the same side, a changed value is undone at the next refit; only changing how it is refit lasts. Closest: lock-in under increasing returns (Arthur 1989), runaway feedback loops (Ensign and others 2018), performative prediction (Perdomo and others 2020: a model that changes the data it is later trained on).
- Shaping the rule (02 §9, `RuleShaping.favours_iff`): influence over a rule spreads where its private return covers its cost. This is rent-seeking, told with Price's equation. Being corrected (07 §7) and what training leaves open (07 §6) are likewise known results in whole numbers.

**Formal versions of what the field has only argued.**
- "Alignment to a principal alone is ... not alignment of the joint selection" (07 §6; 05 §7, `Optimum.mutual_as_one`). An obedient assistant adds power to its principal's measure and no new sight. Critch (2021) and Kulveit and others (2025) argue this in words. Here it is a one-step toy.
- Judges drawn from those the rule picks: a loss seen only by the losing side turns the rule only while they still outweigh (02 §9, `Thinned.kept_iff`, `ReadInTime`). A closing window for oversight.
- The course removes its own judges (02 §10, `PoolFromCourse`). This is the heart of "gradual disempowerment" (Kulveit): people lose their hold on systems that stop needing them. I know of no small formal model of it; I have not searched today.

**A small finding.** LA2 (02 §9, T7): a language-model judge shown its own earlier picks locked in 5 of 5 runs, and one dissenting note in nine reversed all 50 picks. For that judge it refutes the work's own picture of a judge as a count of readers by kind.

One limit. In the field "instrumental convergence" mostly means that an agent that plans seeks power whatever its goal (Turner and others 2021). The work treats the selection version: what spreads under a rule. No one in these models looks ahead.

## 3. The one contribution

A model with one theorem and one experiment: a selection that wears away its own oversight, with a complete list of ways out. To be taken seriously:

- One model in ordinary notation, four quantities: the favoured share, the rule, a stock that renews, the judges who live on that stock.
- The loss growing and the judges going follow from the dynamics; neither is assumed.
- A threshold: which starts end captured and which corrected, and how the line moves with the renewal rate and the delay in judging.
- The ways out proved complete: judges whose standing does not hang on the course, a loss falling on the favoured side, judges admitted from outside.
- Two surprises as theorems, not built examples: a turn undone by the lead it left (`Drained.strong_undone`), and a loss on the disfavoured side strengthening the lock (`borne_by_others_favours_iff`).
- Ten to fifteen pages, one language, the dozen key Lean statements checked against the prose by a person.

Attacked first: "the premises are the conclusion"; "show one real pipeline that meets them, since your own judge did not"; "how is this not Arthur plus performative prediction?"

## 4. The central loop

The brief is right in substance. None of the three modules uses `Flow` or a `World` field.

- Held by its own picks: proved (`RuleCapture.locked_stays`), given a rule that rises with the share.
- The loss grows: assumed. `ClosedCapture.Accrues` is the hypothesis `p.2 + 1 ≤ fB p g`. `lock_outlives_loss` then says that a part which does not read a counter keeps its course while the counter counts. True by construction.
- The judges are removed: defined. `PoolFromCourse.Stands K p := p.2 < K`.
- Judged only by its own picks from then on: proved (`window_locked_after_removal`).

More exactly: `PoolFromCourse` does hold share, rule, loss and judges in one state. But the loss is a counter, not a stock that renews; the judges go by definition, not from need; and that a larger share draws more is a hypothesis (`drains`, in `window_order_kept`). The general law compares two courses. The loop itself appears only in numeric examples.

One model needs five parts, four already written apart: a stock with renewal and a point of no return (05 §7, `Web.course_lost_iff`); a draw that rises with the share (new); judges whose standing is their need of that stock (nearest: 05 §12, `RuleRebuilding`); the rule as a weighted pool of both kinds of judge (02 §9); who bears the loss (`PoolFromCourse.bear`).

Is proving it a contribution? That a captured state exists and holds is foregone: it is built in. Not foregone: where the line lies, that the list of ways out is complete, and the two surprises. The mathematics will be easy. That is no objection: Zhuang and Hadfield-Menell's theorem is easy, and is cited because it pinned one argument down. This would pin down one the field is having now.

## 5. The frame

Defensible, and part of the field holds it: Christiano's "What failure looks like" (2019), Critch's processes that fail whoever runs them, Kulveit, and "embedded agency", the field's phrase for an agent that is part of the world it models.

It will be heard as evasion twice.
- Inner alignment: what a trained network comes to pursue, apart from its reward. The frame is silent on it. Say so in the first paragraph.
- "No should beyond becoming" will be heard as "what lasts is right", or as declining to name a target. Yet the work has a stated premise: count the losses that never come back to you (07 §4.2). Call it a design requirement, like "low impact". The field accepts requirements. It does not read metaethics.

Words needing no translation: selection → objective; reads → observes; beyond → unobserved; drain → Goodhart's law; rule read from its own picks → feedback loop; readers → overseers; readers removed → erosion of oversight; shaping the rule → influence-seeking; widening → keeping options open; formation → agent.

## 6. The evidence

Fixing predictions first and keeping the failures is rare and will be respected. But the tests miss what is distinctive.

- The front-page case tests no law; the map says "no law was tested". That fishers not told of a bed do not keep it is no finding. Eight of ten against three of ten gives about 0.07 on an exact test, short of the usual 0.05.
- "A thesis adds no theorem and a refutation removes none." A reader hears that the laws cannot lose. Say instead: the one judge tested locked, but is not a pool of readers counted by kind, so the timing law does not describe it.
- No test updates a language model's weights.

The one experiment: a closed evaluator loop with real training. A model is tuned against a learned judge. The judge is refit each round on ratings from a pool whose make-up follows which outputs won. A hidden quality is measured; only raters whose weight falls as it falls can see it. Fix beforehand, from measured shares, the round after which bringing those raters back no longer turns the judge. If that round exists near the forecast, the model describes trained systems. If one late dissent turns the judge, as in LA2, counting readers by kind is wrong for learned judges.

## 7. Readiness

Not ready. In order:

1. Choose the one claim and make it the door. A scholar should meet the loop, not "how anything forms".
2. Close the loop in one model, in the field's notation, its statements checked by a person. A visitor cannot weigh 20,000 theorems, but can weigh twelve.
3. Run the one experiment, frozen, with a number that could be wrong.

The direction is sound for alignment: what a joint process can correct, and what keeps correction alive. It is carried out in a way that hides it: breadth multiplied, the one deep point not reached.

On whether the parts are separate: 07 §4.12 found that lasting selects only on what comes back, with "no mechanism by which a reading wider than what returns forms". That is the loop's result again: wide concern stays only where those who see the loss do not depend on the course. Here the ethics question and the alignment question are one. The map has not shown it.
