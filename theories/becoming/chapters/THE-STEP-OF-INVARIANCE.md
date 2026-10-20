# The step of invariance: the argument and its objections

20 October 2026. AI-written (board items IV1 and IV2, one session; line D of four toward the aim of 20 October). It is an argument, not a proof: every formal claim names its Lean declaration, checked with an empty axiom report, and every other claim is argued and labelled as argument. It is not Ren's text, and Ren's words appear only as provenance with their source. No human philosopher has reviewed it; it is written so that one can check each step.

The [canonical chapter](THE-THEORY-OF-BECOMING.md) rests its ethics on two premises with two roles. The continuation condition fixes scope, whose losses count; its content beyond the self's presupposition is the step of invariance. Calling widening better (C) fixes order. Neither is asserted, and their warrant is open (§8.5, §8.1 item 12). This chapter takes the step: it states it, says where the literature already has it, gives the strongest argument the work supports, gives the strongest case against it, and goes through the objections of §8.9.

## In brief

1. **The step is two arguments.** Across standpoints (what has significance from one standpoint has it from every other) it is Gewirth's step; from each standpoint's concern for its own continuation it forces significance for exactly the standpoints' centers, and no further (`forced_iff_center`). Across drawings of a self (the presupposition does not depend on where the self's boundary is drawn) it is the reductionist step of Parfit and Siderits; it needs no other standpoint (`boundaryInvariant_iff_all`). The standard objection to Gewirth hits only the first.
2. **The contested move is a scope ambiguity.** The universalist and the critic agree on the presupposition. They differ on whether "however the self is drawn" takes wide or narrow scope (`presupposition_scopes`). Narrow scope gives exactly what lies within the self's closure (`forced_iff_within`) and is consistent with every law of the dynamics. Section 4.1 states the de se question exactly (IV2). The step holds if the self's presupposition is held de dicto, as one proposition. It also holds if the presupposition is held de se of a self drawn along being related at all, where every center's closure is the whole (`ownClosure_unrestricted_of_whole`). It fails exactly where the presupposition is held de se of a self drawn along a relation whose closures differ across centers (`selfAscribed_iff_withinSome`). This chapter does not settle which holds.
3. **Order is the same pattern.** C is exactly the order that every weighting counting every formation shares, however partially it weighs (`Weighting.widens_iff_every_positive`, `Web.widens_iff_every_weighting`). Partial choices are mixed comparisons, which every such weighting may decide either way (`Weighting.mixed_either_way`). A weight of zero is a denial of scope (`Weighting.weighed_eq_of_unweighted`). A weighting that is the same for every formation counts numbers (`Weighting.neutral_ranks_by_number`).
4. **The verdicts on §8.9.**
   - *Gewirth's critics*: sharpened. The egoist reply is exactly the de se reading of the presupposition, and it bites only together with a privileged relation narrower than being related at all.
   - *Agent-relative reasons and partiality*: answered. The step, argued for two-valued significance, makes standing invariant (whether a formation counts) and leaves status (how much) to each standpoint (`Partial`). Partiality lives in status and in the mixed comparisons. Numbers count only under the further premise that status is invariant and equal.
   - *Why anything*: sharpened. The step across standpoints reaches the centers; "anything" needs covering, every formation within some standpoint's closure. The narrower scope is checked, and the tumour does not tell the two scopes apart.
   - *The externalism of A*: sharpened. Internal reasons reach exactly the closure, and A's external surplus is the step itself.
   - *Graded status, priority and constraints*: answered for graded status, priority, sufficiency and constraints against closing. Priority agrees with C wherever C ranks and decides transfers C leaves mixed (`Weighting.prior_lt_of_widens`, `Weighting.prior_transfer`), and sufficiency denies scope above its threshold (`Weighting.sufficient_ties`). Sharpened for constraints on acts rather than outcomes.
   - None of the objections is shown to defeat the step, and the step is not shown.

## 1. The step stated exactly

A *significance* says, for a standpoint `p`, a step `t` and a formation `g`, whether from `p` the continuation of `g` at `t` has significance (`sig p t g`). A self's *boundary*, along a relation of the unfolding, is a region that holds the self's center and is closed under the relation. The closure is the least boundary and the whole the greatest (`Boundary.closure`, `Boundary.whole`). The *self's presupposition*, drawn at a region, is that from `p` the continuation of everything within the region has significance (`SignificantWithin`). It is *sub-true* if it holds as the boundary is drawn somewhere, and *invariant* if, holding as drawn anywhere, it holds as drawn everywhere (`SubTrue`, `BoundaryInvariant`; the terms of supervaluation and subvaluation, Fine 1975 and Hyde 1997).

The continuation condition is exactly the presupposition sub-true and invariant at every standpoint, along any relation (`unrestricted_iff_presupposed_along`). Logically this is A ⇔ P ∧ (P → A): it locates the step and derives nothing beyond it. The step has two forms.

- **Across drawings.** At one standpoint, given the presupposition, invariance is the condition from that standpoint (`boundaryInvariant_iff_all`). No other standpoint enters.
- **Across standpoints.** Significance is *standpoint-invariant* if what has it from one standpoint has it from every other (`StandpointInvariant`). With every formation within some standpoint's closure (*covering*) and the presupposition sub-true everywhere, standpoint-invariance gives the condition (`unrestricted_of_standpointInvariant`) and is equivalent to invariance across drawings (`boundaryInvariant_iff_standpointInvariant`).

The two forms coincide only under covering and the presupposition everywhere. Section 3 argues that they are different arguments.

**What the step across standpoints reaches without covering** (new, `Becoming.Weightings`). Let each standpoint's presupposition about its own continuation alone hold: sub-true along the empty relation, which is a standpoint's own good (`subTrue_empty_iff`). Let significance be standpoint-invariant. Then from every standpoint, the continuation of every standpoint's center has significance (`atCenters_least`). The significance of the centers' continuation, `atCenters`, meets both premises (`atCenters_presupposed`, `atCenters_standpointInvariant`). So what the two premises force is exactly that the centers count (`forced_iff_center`). It is the condition exactly when every formation is a center (`unrestricted_atCenters_iff`). Gewirth's conclusion, every agent's agency, is this result with agents as the centers. Reaching beyond the centers to "anything" is a further premise.

**What a standpoint's own presupposition reaches** (new). Along a relation, the formations whose continuation every significance meeting `p`'s presupposition (drawn at `f`'s closure) must count are exactly those within the closure (`forced_iff_within`). This is the least significance of `bounded_closure_least`, read pointwise: route (b) of §6.3.

## 2. Where the move is already made

The literature check is in the [significance review](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#invariance-check). In short:

- **Across standpoints**: Gewirth's Principle of Generic Consistency (1978). Each agent must hold its freedom and well-being necessary goods. The sufficient reason is being an agent, so by universalizability every agent has them. Beyleveld (1991) defends it against sixty-six objections. The variants are Nagel (1970: prudence sees the present as one time among others, altruism oneself as one person among others), Hare (1981) and Korsgaard (1996: reasons are public). The objections: the step from "I must value my agency" to a right (Williams 1985, MacIntyre 1981, Bond 1980), and the reply that universalizability yields only that each agent rationally claims for itself.
- **Across drawings**: Parfit (1984). Identity consists in continuity and connectedness, can be indeterminate, and is not what matters, so the boundaries between lives deserve less weight. Siderits (2003) argues that persons are conventional, so suffering is to be prevented whosever it is (Śāntideva, *Bodhicaryāvatāra* 8.90–103). Johnston (2010) holds that identity is Protean, and that the good live on in the onward life of humankind. The objections: normative conclusions do not follow, and reductionism can dissolve concern as easily as extend it (Wolf 1986; Parfit's Extreme Claim); no-self does not entail benevolence (Harris 2011); concern can be rational without a further fact (Johnston 1997).
- **On order**: inclusion with strict monotonicity on opportunity sets (Pattanaik and Xu 1990), and Sen's intersection approach (1970, 1977). On partiality: Williams (1976) "one thought too many", Scheffler's agent-centred prerogative (1982), Taurek (1977) on numbers.

The theory's step is not new. The condition's wording ("for anything") goes further than Gewirth (agents) and Siderits (sufferers). It is close to Johnston, and to a conatus reading of Spinoza (*Ethics* III, proposition 6: each thing strives to persevere in its being).

## 3. The strongest argument for the step

The argument takes the route across drawings. That route does not pass through other standpoints, so it avoids the objection that defeats most readings of Gewirth.

- **P1 (presupposition).** A standpoint acting for a continuation presupposes that some continuation has significance from it. Formally: its presupposition is sub-true at some drawing.
- **P2 (no privileged drawing).** What is "its own" is a region drawn along a relation of the unfolding. For each relation the unfolding fixes the least region, the closure (`Boundary.closure`, `Web.selfValuation_own_least`). No law of the dynamics fixes which relation.
- **P3 (relative or invariant).** A presupposition whose truth depends on a choice nothing privileges is either relative to that choice or invariant across choices.
- **P4 (not relative).** What a standpoint presupposes in acting is that continuation has significance, not that continuation under a description of its own drawing has.
- **C.** The presupposition is invariant. With the whole an admissible drawing, which it is along any relation, it is the condition from that standpoint (`boundaryInvariant_iff_all`). Held at every standpoint, it is the condition (`unrestricted_iff_presupposed_along`).

**Validity is checked; soundness is not.** The step from P1, invariance and the admissibility of the whole to the condition is a theorem. P3 is a dilemma that holds by logic once P2 holds. The weight lies on P2 and P4.

**What P2 is, exactly.** P2 is not a theorem. Significance is not a field of the represented dynamics, so no law of them constrains it (`Web.significance_undetermined` evaluates the two constant significances). The relation along which a self is drawn is a parameter of every statement (`Web.selfValuation`). Two things are theorems. First, each relation gives its own least boundary, and these differ: along the empty relation a formation's own events, along feeding the feeding closure (`Web.selfValuation_empty_own`, `Web.selfValuation_feeding_own`). Second, super-truth does not depend on the relation (`superTrue_level_free`). So "no law of the dynamics singles out a boundary" holds in the representation only because the relation is supplied. A further relation that the facts privilege, as animalism holds of the organism's life (Olson 1997), would deny P2. The theory has no argument that no relation is privileged. It has only the observation that the unfolding reads many relations (feeding, affecting, being affected, sharing a condition, coupling), each with its closure.

**What P4 says, and why it is the crux.** P4 is Parfit's thesis that identity is not what matters, stated for significance rather than for prudential concern. The argument for it runs as follows. Acting does not fix a drawing. One and the same act serves a continuation under every drawing that contains it. A standpoint's concern for its future is concern for what will continue, and what will continue is not bounded by any drawing: it goes on in what the self's relations carry. The argument is suggestive, not compelling. Its denial is coherent (section 4.1).

**The Extreme Claim is a theorem of the decomposition.** Parfit saw that if identity does not matter, special concern may lose its ground rather than extend. In the decomposition: if the presupposition is invariant and some continuation lacks significance, the presupposition holds at no drawing (`not_subTrue_of_invariant`). Invariance alone forces the choice between "everything" and "nothing". It does not choose. P1 chooses: it is held fixed while the drawing varies. This is exactly what Wolf and Harris say the reductionist argument lacks, namely a normative premise that survives the loss of a privileged self. In this argument that premise is P1. P1 is weak (some continuation has significance), but it is the presupposition of acting at all.

**Drawing along being related at all.** P2 can be read in two ways. Read one relation at a time, the presupposition sub-true along every relation of a family is significance over the union of the closures (`subTrue_every_iff`). Read as drawing the self along being related by some relation of the family, it says more: drawn that way it gives each single relation (`subTrue_every_of_related`). The closure along the union can be strictly larger, because a chain can mix relations (`Chain.every_not_related`: the third formation lies within the first's closure along being related at all and within no closure along a single relation). In a relational monism the unfolding is one connected whole under being related, so the closure along it is the whole. The presupposition drawn there is the condition with no invariance needed (`unrestricted_iff_presupposed_of_whole`). This does not remove the step. It moves it into the choice to draw the self along being related as such, which the theory already says (§6.5). It does show the form the theory's ontology gives the step: the self drawn along relatedness as such is the whole, and any narrower self is a choice of sub-relation.

## 4. The strongest case against the step

**4.1 The presupposition is de se.** On this view what a standpoint presupposes in acting is the significance of *its own* continuation, held essentially indexically (Castañeda 1966, Perry 1979, Lewis 1979). The content "my continuation has significance" is not the content "this continuation has significance" with a drawing filled in. It is a first-person content that no drawing captures. Then the operator "however the self is drawn" belongs inside the content, at narrow scope. What is definitely within me has significance from me, and that is the closure (`presupposition_scopes`, `forced_iff_within`). This view is coherent and consistent with every law of the dynamics (`bounded_closure_least`; `bounded_rival`). It explains why the presupposition survives the indeterminacy of the self: the definite core carries it. Guillot and O'Brien's defence of first-person reasons (2023) supports it. **This is the strongest objection, and the theory does not defeat it.**

*What follows, exactly (IV2).* Read a content held de se as Lewis does, as a property that each standpoint ascribes to itself (`selfAscribed`). Read a content held de dicto as one proposition, the same from every standpoint (`shared`). Standpoint-invariance is exactly holding one shared content (`standpointInvariant_iff_shared`).
- **Held de se.** The presupposition is the property "the continuation of what lies within my own closure has significance" (`ownClosure`). Every standpoint holds the same property, so the step, read as "the presupposition does not depend on who holds it", holds trivially as invariance of content.
  - The significance this gives is each center's closure, from that center (`ownClosure_presupposed`).
  - It is standpoint-invariant exactly where the centers' closures agree (`ownClosure_standpointInvariant_iff`).
  - It is the condition exactly where every center's closure is the whole (`ownClosure_unrestricted_iff`).
  - This is the egoist's universalization in Gewirth's debate, and Dreier's model of agent-centered value as one ranking over centered propositions (2018).
- **Held de dicto.** The step across standpoints forces exactly the union of the centers' closures (`forced_iff_within_some`, which generalizes `forced_iff_center`), and the condition under covering.
- **Where they part.** The two readings agree exactly where whatever lies within one center's closure lies within every center's (`selfAscribed_iff_withinSome`). In `Divided` they part: two standpoints, each its own center along the empty relation.
- **Along being related at all.** In a connected unfolding every center's closure is the whole, and the presupposition held de se is the condition with no step at all (`ownClosure_unrestricted_of_whole`). This is Næss's ecological Self (1987): self-concern for a self drawn widely enough is care for all, with no altruism needed.

So the de se objection defeats the step only together with a second premise: that the self a de se presupposition is about is drawn along a relation narrower than being related at all, one whose closures differ from center to center. That is the privileged-relation objection of section 4.2. **The two objections are one.** The exact open question is this: *is the self's presupposition held de se of a self drawn along a privileged relation narrower than being related at all?* If yes, the step fails. If the presupposition is held de dicto, or held de se of the self drawn along relatedness as such, the step holds.

*The strongest argument that it is de se of a narrower self.*
- Prudential concern is concern for *my* future. Fission cases show that the first person tracks a particular relation (psychological continuity, or the organism's life), not relatedness as such.
- Practical reasoning ends in an indexical conclusion, "I am to do this" (Perry; Gjelsvik 2017; García-Carpintero 2017).
- The egoist's universalization is coherent, and it satisfies every formal constraint of universalizability (Sidgwick; Williams 1985).
- And if the self is indeterminate across relations, the narrow scope over them reaches only what lies within every candidate closure. Along the empty relation the closure is the center alone (`subTrue_empty_iff`), and sub-truth along a larger relation gives it along a smaller one (`subTrue_of_larger`). So with the empty relation among the candidates, the narrow scope is the standpoint's own continuation, and nothing more is definite (an argument; the intersection over relations is not itself a theorem here).

*The strongest argument that it is not.*
- What acting presupposes is that the outcome *matters*. That is a presupposition of significance, not a self-locating belief, and a motive held de se can presuppose a significance held de dicto. Nagel's argument (1970) is that a reason must be statable from an impersonal standpoint. The debate over whether indexicals are essential concerns belief and action explanation (Millikan 1990; Cappelen and Dever 2013; Magidor 2015). It does not show that the content of a presupposed significance is centered.
- In a relational monism the self is drawn along some relation of one unfolding. Privileging a narrower relation as *the* self needs an argument the dynamics do not supply (P2).
- The first person can be read as wide as the relations it lives by (Næss; Johnston 2010).

Neither argument is compelling. The question is now exact, and it has two parts, the content (de se or de dicto) and the relation the self is drawn along. Only their conjunction defeats the step.

**4.2 A privileged relation.** If one relation is the self's (the organism's life, or Parfit's relation R), P2 fails. The self is then the closure along that relation, the step across drawings has no work to do, and route (b) along that relation is the right ethics of the self. Against this, two points: on Parfit's own view R comes in degrees, so its closure is vague; and the unfolding's relations nest (`Flow.withinCoupling_of_withinInfluence`), so a privileged relation must be chosen among nested closures. These make the objection costly, not false.

**4.3 Relative significance is enough.** One can hold that significance is always significance from a standpoint and along a drawing, perspectival all the way down, and that nothing more is needed for ethics. The theory's significance is already indexed by standpoint. Its condition is a claim that the index makes no difference, and the perspectivist denies that claim without contradiction (`bounded_rival`).

**Assessment.** The step is neither shown nor defeated. The argument for it is valid, with two contested premises. The case against it is coherent, with one strongest form. What remains is a question a philosopher can check: *is the self's presupposition in acting essentially de se?*

## 5. Order: what every standpoint shares

The same pattern holds for C. Read one standpoint's order as a *positive weighting*: a natural weight for each listed step and formation, every weight above zero (`Weighting.Positive`). A course is then ranked by the total weight of what it admits (`Weighting.weighed`). A weighting may be as partial as one likes, weighing one's own, one's children or one's city far above a stranger. Positivity only says that it counts each.

- **C is what every positive weighting shares.** On the listed items, one course widens another exactly when every positive weighting ranks it higher (`Weighting.widens_iff_every_positive`). On a web, where admission is decided and what either level path admits is listed, this is `Web.Widens` itself (`Web.widens_iff_every_weighting`).
- **The representation is not a premise.** An order need not be additive. Call it increasing in admission when it ranks every widening above what it widens (`Weighting.Increasing`); priority to the worse off is one (`Weighting.increasing_prior`). For any class of orders from the positive weightings up to all orders increasing in admission, one course widens another exactly when every order of the class ranks it higher (`Weighting.widens_iff_every_of_class`; every complete order, given as a score, `Weighting.widens_iff_every_score`), and within each class a mixed comparison is decided both ways (`Weighting.mixed_either_way_of_class`; [study §282](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#282-alignment-approaches-under-the-selection-laws-ap1)).
- **Partiality decides exactly the mixed comparisons, either way.** If each course admits something the other does not, some positive weighting ranks the first higher and another ranks the second higher (`Weighting.mixed_either_way`, by `Weighting.outweighs`). Where one course widens the other, no positive weighting reverses it (`Weighting.weighed_lt_of_widens`).
- **A weight of zero is a denial of scope.** A weighting that gives some item no weight ties a widening that adds only that item (`Weighting.weighed_eq_of_unweighted`). An order that is bounded at a region is a weighting zero beyond it.
- **A weighting the same for every item counts numbers.** One positive weight for all items ranks a course higher exactly when it admits more items (`Weighting.neutral_ranks_by_number`).
- **Closing is never required by C.** Where one course admits a formation at a step that another does not, the other neither widens nor keeps it (`Web.not_widens_of_closes`).

The mathematics is known. It is Sen's intersection approach and Pareto dominance as the unanimity of positive weightings, in the 0/1 case; without additivity it is the intersection of linear extensions (Szpilrajn 1930; Dushnik and Miller 1941) for the inclusion order on finite sets. What it gives the theory is a decomposition of C parallel to the decomposition of the condition. If each standpoint's order is increasing in admission (C at the standpoint, partiality allowed, additive or not), then the order every standpoint shares is exactly C, and nothing beyond C is shared. Invariance applied to order yields C and no more. This does not warrant C. That each standpoint's order is monotone in what it counts, that more possibility with significance is never worse from a standpoint, is the premise the opportunity-set literature calls monotonicity. It is now located at the standpoint, where it is weaker than an impersonal "widening is better", but it is still a premise.

## 6. The objections of §8.9

### 6.1 Gewirth's critics: from my agency to others'

*Strongest form.* From "I must value my continuation" nothing follows about yours. The reason I hold is "my continuation", agent-relative. Universalizing it yields only that each standpoint rationally holds its own continuation to have significance, as each chess player rationally plays to win.

*What it hits.* It hits the step across standpoints (section 1: from own presuppositions plus standpoint-invariance, exactly the centers). It does not hit the step across drawings, which uses no other standpoint. The prudential-to-rights half of the objection (Williams, MacIntyre, Bond) has no target here. The theory moves from significance to no right, duty or claim on others: the condition fixes whose losses count, and a contributory reason is not a duty (§6.2).

*Verdict.* **Sharpened.** Against the theory, the objection is exactly the de se reading of the presupposition (section 4.1). Held de se, universalization gives each center its own closure, the egoist's conclusion; held de dicto, it gives the union of closures, Gewirth's. And the egoist reading defeats the step only together with a self drawn along a privileged relation narrower than being related at all.

### 6.2 Agent-relative reasons and partiality (Williams)

*Strongest form.* A man who saves his wife rather than a stranger, and who needs the thought "it is my wife, and in such cases it is permissible to save one's wife", has one thought too many (Williams 1976). An impartial framework, even one that permits partiality, makes partial reasons derivative from an impartial licence. That misdescribes them and alienates the agent from his attachments. Ground projects can give reasons that impartial considerations do not override.

*Answer.* Saving one's wife and saving a stranger is a mixed comparison. Each course admits a continuation the other does not, so C ranks neither (`Web.mixed_iff_adds`, `Transfer.unordered`). The condition fixes only that the stranger's loss is a loss, which Williams does not deny (his agent-regret and moral remainders presuppose it). No impartial verdict exists for the man's partiality to be licensed against. He decides by his own weighting, and every positive weighting may decide this comparison either way (`Weighting.mixed_either_way`). The structure asks for no thought beyond his own. What it does rule out is ranking a course that another widens above it: saving only the wife when he could save both at no cost (`Weighting.weighed_lt_of_widens`; Williams's examples are not of this kind). It also rules out counting the stranger's loss as nothing (a weight of zero, `Weighting.weighed_eq_of_unweighted`). Scheffler's prerogative, which lets an agent weight his own interests more, is the special case in which the agent's own items weigh more. Here it needs no rationale beyond the mixedness of the comparison.

*The objection from the other side, at full strength.* The answer has a price. In this theory, saving one's dog rather than a thousand strangers is also a mixed comparison. C does not rank it, so the condition and C do not condemn the grossest partiality. The practical commitments J1/J2 (basic conditions first, §6.5) compare by the inclusion of basic admissions, so they leave it mixed too. This is Taurek's position on numbers, reached by a different route.

*Standing and status (IV2).* Whether numbers count is decided by what the step makes invariant. Read a graded significance as a natural grade from each standpoint, its *standing* as whether the grade is positive (whether a formation counts at all) and its *status* as the grade (how much), as Kagan (2019) and Sebo distinguish them.
- Invariant grades give invariant standing (`Weighting.standingInvariant_of_gradeInvariant`) and rank alike from every standpoint (`Weighting.ranks_alike_of_gradeInvariant`).
- The converse fails. In `Partial`, standing is invariant, each standpoint grades its own formation higher, and two standpoints rank a mixed comparison opposite ways (`Partial.ranks_differ`).
- The step, as argued in section 3, concerns whether a continuation has significance. It gives standing, not status.
- Under invariant and equal status, numbers count (`Weighting.neutral_ranks_by_number`), and partiality yields wherever the counts differ. That is a further premise, which the theory does not assert.

*Verdict.* **Answered.** The step fixes standing. Partiality lives in status and in the mixed comparisons, which no impartial verdict decides, so it needs no impartial licence. The price is explicit: numbers count only under the further premise that status is invariant and equal.

### 6.3 Why "anything" has significance: a hurricane, a tumour

*Strongest form.* The scope comes from the condition's wording. Nothing gives a reason why a hurricane's continuation has significance, and saying so is idle (it ranks nothing) or perverse (every weather modification becomes a loss).

*The narrower scope, checked.* Ren proposed on 10 October 2026 that “it can be anything that want's its continuation to have significance” ([source](../../../sources/15-codex-theory-conversations/2026-10-10-wanting-continuation-one-axiom.md)). Read the formations that want their continuation as the centers of standpoints, those whose own presupposition holds [AI reading, D59]. Then:
- the step across standpoints gives significance to exactly them (`forced_iff_center`);
- under that significance, a course retains what has significance along another exactly when, at every step, it admits every center the other admits (`Web.retains_atCenters_iff`);
- it is the condition exactly when every formation is a center (`unrestricted_atCenters_iff`);
- it parts from the condition exactly at a formation that is no center. In `Clearing`, with the clearer the only center, the clearer's part retains what has significance at the centers, while under the condition it loses the dweller (`Clearing.centers_retain_yet_loses`).

*What tells the two scopes apart.* The tumour does not. If wanting is read as striving to persevere (conatus), a tumour lineage is a center, and its continuation has significance on both scopes. Ending it is a mixed comparison on both, ranked by neither the condition nor C (§6.4: predation, apoptosis and ending a cancer are alike). The hurricane does tell them apart, but only on a reading of wanting stronger than conatus, such as a represented concern for one's continuation. A hurricane maintains itself by drawing heat, so on the conatus reading it too is a center. The narrower scope therefore faces a dilemma. On the conatus reading it gives hurricanes and tumours significance, as the condition does. On the representational reading it leaves out plants, ecosystems, conditions that no one depends on, and (on most views) future formations not yet able to represent anything.

*Is "anything" idle?* No. It decides which losses C counts: under it a part that closes what no center depends on loses something; under the narrower scope it does not (`Clearing.centers_retain_yet_loses`). Is it perverse? The verdict it gives on a harmless weather modification is "mixed", not "worse". That is a cost only for someone who reads mixed as worse, which the theory does not.

*Verdict.* **Sharpened** into two exact questions. Which formations hold standpoints (the range of the centers)? Is covering true, that is, does every formation lie within some standpoint's closure along a relation the unfolding reads? A self valuing its continuation plausibly values what it depends on (feeding), so covering by feeding is the defensible part. Covering by affecting is not, since valuing one's continuation does not obviously commit one to valuing what one merely affects. A hurricane that no standpoint depends on gets significance only through the step across drawings (section 3), not through transmission.

### 6.4 The externalism of A

*Strongest form.* A reason requires a sound deliberative route from the agent's motivational set (Williams 1979). A gives every position with access to a sound inquiry a contributory reason, whatever its motives. So A asserts external reasons, and the internalist denies that there are any.

*Answer: the account restated internally.* Take the agent's motivational set to contain its presupposition about its continuation, along the relations its concern carries. An internal reason for `g` from `p` is then one that every significance meeting that presupposition must give. That is exactly `g` within the closure (`forced_iff_within`). Everything route (b) proves survives the internal restatement: the comparison of every part within the reach closure as the condition makes it, using neither invariance nor super-truth (`Flow.Balances.presupposed_reach_comparison`), and the agreement of the closure's verdict with the condition's where the closure is the whole (§6.3). What does not survive is the condition's surplus over route (b): losses that return to no one (`Clearing.clearer_loses_dweller` against `Clearing.centers_disagree`).

*Verdict.* **Sharpened.** A's external part is exactly the step. Whether it has an internal route is whether sound deliberation from the presupposition reaches invariance, which is the de se question again.

### 6.5 Graded status, priority and constraints

*Strongest form.* Moral status is graded, the worse off have priority, and there are constraints on what one may do. A two-valued significance with an inclusion order represents none of these, and "every rival is the same rule inside a boundary" only frames countermodels.

*What is now represented.*
- **Graded status as positive weights.** Any grading that counts every formation agrees with C wherever C ranks (`Weighting.weighed_lt_of_widens`) and decides only mixed comparisons (`Weighting.mixed_either_way`). Status zero is a scope denial: it ties a widening (`Weighting.weighed_eq_of_unweighted`), and a significance bounded at a region is the rule within the region (`bounded_rival`).
- **Priority on levels of continuation (IV2).** Read a formation's level in a course as how many of its listed steps the course admits (`Weighting.level`).
  - A sum of a strictly increasing transform of levels ranks every widening higher (`Weighting.prior_lt_of_widens`). This is the Pareto principle, so priority, like the utilitarian sum, agrees with C wherever C ranks.
  - A transform strictly concave up to a bound (`Weighting.ConcaveTo`) ranks higher a course that moves one step of continuation from a formation at a higher level to one at a lower (`Weighting.prior_transfer`). This is Pigou–Dalton, on a comparison C leaves mixed.
  - In `LevelTransfer`, the sum of levels ties the two courses, a concave transform prefers the even one, and a convex transform prefers the uneven one. The general law decides the witness (`LevelTransfer.by_law`).
  - No whole-number transform is strictly concave everywhere, so the concavity is up to the bound the levels have.
- **Sufficiency (IV2).** A transform that rises no further from a threshold weighs alike two courses whose levels differ only at or above it (`Weighting.sufficient_ties`; Casal's negative thesis, 2007). In the theory's terms, sufficiency is a scope denial above the threshold, as a zero weight is below it.
- **Lexical priority** (basic conditions first) is no additive weighting ([protection-priority-excludes-uniform-aggregation](../results/records/protection-priority-excludes-uniform-aggregation.md)). It lies outside the order every positive weighting shares and decides comparisons that order leaves mixed. Where it ranks each widening higher it is increasing in admission, so it is within the classes over which the shared order is still exactly widening (`Weighting.widens_iff_every_of_class`), and it decides only what that order leaves mixed.
- **A constraint against closing something oneself never conflicts with C.** A course in which something is closed is never ranked by C above one in which it is not (`Web.not_widens_of_closes`). The standard cases for constraints, such as harming one to prevent harm to two, are mixed.

So §6.2's framing is exact for every rival that ranks each widening higher, additive or not, transforms of levels among them. A rival either counts everything, and is then C plus a way of deciding mixed cases (partial weights, priority, equal counting), or it gives some formation, or some level, weight zero, and is then a boundary.

*Not represented.*
- Constraints on means and on acts rather than outcomes: doing and allowing beyond closing, promising, lying. The comparison over admitted courses cannot see them. Howard's de se consequentializing (2022) reads such constraints as rankings of de se outcomes. In this chapter's terms that places them with the content held de se, in the agent-relative part, which decides only what C leaves mixed.
- Well-being beyond the length of continuation: levels count admitted steps only.

*Verdict.* **Answered** for graded status, priority, sufficiency and constraints against closing. **Sharpened** for constraints on acts: the open question is whether an act constraint can be read as a de se ranking of the outcomes in which one's own act closes something, in which case it decides only mixed comparisons.

## 7. What is open, exactly

1. **The de se question, in its exact form.** Is the self's presupposition held de se of a self drawn along a privileged relation narrower than being related at all? If yes, the narrow scope is right, route (b) is the ethics of the self, and the condition fails. If the presupposition is held de dicto, or de se of the self drawn along relatedness as such, the step holds. Sections 3, 4.1, 4.2, 6.1 and 6.4 all reduce to this. Before IV2 it was two questions, de se and the privileged relation; it is one.
2. **The range of the centers, and covering.** Which formations hold standpoints, and does every formation lie within some standpoint's closure along a relation the unfolding reads? The results of IV2 hold for any assignment of centers. Reading the centers on the base, as formations whose activity keeps their own conditions, would bear on this question and not on the de se question or on grades, so it was not built.
3. **Invariance of status.** Is status, and not only standing, the same from every standpoint, and equal? If both, numbers count and partiality yields wherever counts differ. The step as argued gives standing only.
4. **Monotonicity at the standpoint.** Is each standpoint's order monotone in what it counts? This is C's premise, relocated by section 5. Additivity is not part of it (`Weighting.widens_iff_every_of_class`).
5. **Constraints on acts.** Can an act constraint be read as a de se ranking of outcomes (Howard 2022), and so as deciding only mixed comparisons?

None is settled by formal work. Each is stated so that an argument settles it.

## 8. The formal results used

| Claim | Lean | Module | Status |
|---|---|---|---|
| The condition is the presupposition sub-true and invariant | `unrestricted_iff_presupposed_along` | `Becoming.Boundaries` | landed |
| At one standpoint, invariance given the presupposition is the condition there | `boundaryInvariant_iff_all` | `Becoming.Boundaries` | landed |
| Across standpoints, with covering | `unrestricted_of_standpointInvariant`, `boundaryInvariant_iff_standpointInvariant` | `Becoming.Boundaries` | landed |
| Narrow and wide scope | `presupposition_scopes`, `bounded_closure_least` | `Becoming.Boundaries` | landed |
| Invariance makes the presupposition all or nothing | `not_subTrue_of_invariant` | `Becoming.Boundaries` | landed |
| Where the closure is the whole, no invariance is needed | `unrestricted_iff_presupposed_of_whole` | `Becoming.Boundaries` | landed |
| The step across standpoints forces exactly the centers | `forced_iff_center`, `atCenters_least`, `unrestricted_atCenters_iff` | `Becoming.Weightings` | landed |
| A standpoint's own presupposition forces exactly its closure | `forced_iff_within` | `Becoming.Weightings` | landed |
| Every relation one at a time against being related at all | `subTrue_every_iff`, `subTrue_every_of_related`, `Chain.every_not_related` | `Becoming.Weightings` | landed |
| C is what every positive weighting ranks higher | `Weighting.widens_iff_every_positive`, `Web.widens_iff_every_weighting` | `Becoming.Weightings` | landed |
| C is what every order increasing in admission shares, additive or not | `Weighting.widens_iff_every_of_class`, `Weighting.widens_iff_every_increasing`, `Weighting.widens_iff_every_score`, `Web.widens_iff_every_of_class`, `Weighting.increasing_prior` | `Becoming.Weightings` | landed |
| Mixed comparisons are decided both ways | `Weighting.mixed_either_way`, `Weighting.outweighs` | `Becoming.Weightings` | landed |
| Zero weight ties; equal weights count | `Weighting.weighed_eq_of_unweighted`, `Weighting.neutral_ranks_by_number` | `Becoming.Weightings` | landed |
| Closing is never required | `Web.not_widens_of_closes` | `Becoming.Weightings` | landed |
| The narrower scope's comparison and where it parts from the condition | `Web.retains_atCenters_iff`, `Clearing.centers_retain_yet_loses` | `Becoming.Weightings` | landed |
| Standpoint-invariance is one shared content; de se content is invariant where its readings agree | `standpointInvariant_iff_shared`, `selfAscribed_standpointInvariant_iff` | `Becoming.Weightings` | landed |
| Held de se, the presupposition gives each center its closure, invariant where closures agree, the condition where each is the whole | `ownClosure_presupposed`, `ownClosure_standpointInvariant_iff`, `ownClosure_unrestricted_iff`, `ownClosure_unrestricted_of_whole` | `Becoming.Weightings` | landed |
| Held de dicto, the step forces the union of closures; where the readings part | `forced_iff_within_some`, `selfAscribed_iff_withinSome`, `Divided` | `Becoming.Weightings` | landed |
| Invariant grades give invariant standing and rank alike; not conversely | `Weighting.standingInvariant_of_gradeInvariant`, `Weighting.ranks_alike_of_gradeInvariant`, `Partial.ranks_differ` | `Becoming.Weightings` | landed |
| Priority on levels agrees with C and decides transfers; sufficiency ties above the threshold | `Weighting.prior_lt_of_widens`, `Weighting.prior_transfer`, `Weighting.sufficient_ties`, `LevelTransfer.by_law` | `Becoming.Weightings` | landed |

The records are [what-the-step-across-standpoints-reaches](../results/records/what-the-step-across-standpoints-reaches.md), [widening-as-what-every-weighting-ranks](../results/records/widening-as-what-every-weighting-ranks.md) and [graded-significance-and-priority](../results/records/graded-significance-and-priority.md).

*What the formal results do not show.* Any premise of section 7. That a standpoint's order is additive or positive. Which weighting any standpoint has. That the impartial order is what all standpoints share, rather than a privileged weighting. Whether the self's presupposition is held de se, or along which relation. That status is invariant. The representation commits to finite listings, two-valued admission, natural-number weights and grades, levels counted in listed steps, and strict concavity up to a bound.
