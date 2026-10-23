# The controlled English edition of the 經

23 October 2026. AI-written (board item ZE). This is not a chapter of the theory and not a translation of the canonical English chapter. It renders the 經 (the short statements) of every 條 of the [中华本](../../theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md) into English, clause by clause, in the [English name table](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ze-controlled-english/names-en.tsv), which gives each of the 中华本's 449 names an English name, the sense it takes, what it does not carry, and the same Lean anchors. It was written as the control of the fidelity count ([CONTROLLED-ENGLISH-RESULTS.md](CONTROLLED-ENGLISH-RESULTS.md)): a code under the same discipline as the 經, in another language.

Both editions share one source, [`controlled-english.jsonl`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ze-controlled-english/controlled-english.jsonl), which holds each 條's clauses in both languages with the declarations each clause states. Numbers: C.n are the conventions (凡例), T.n the theses (论纲), and k.n the n-th 條 of chapter k; a cross-reference uses the same numbers. The proofs (證), commentary (說) and comparisons stay in the 中华本.

## Conventions: suppositions, proofs, readings and the marks of inference

### C.1 Nondual method

The nondual method is to set up a distinction and to state with it the relations it rests on, what it applies to and what it leaves out. The nondual method is a requirement of method, not a proof.

### C.2 Representation

A representation states the view used, together with what its representing fixes.

### C.3 Not and not yet

Not is: if it holds, there is a contradiction; Not yet is: what is read up to this point excludes neither its holding nor its not holding.

### C.4 Necessarily and possibly

Necessarily is: it holds on every branch that opens; Possibly is: it holds on some branch that opens, and which branch it is is shown.

### C.5 Decided

Decided is: holds or does not hold. For every claim, there is a number that is one where the claim holds and zero where it does not hold, exactly where the claim is decided (for the count of a family, see 3.7).

### C.6 Cannot be refuted

Cannot be refuted is: its denial cannot stand. For every claim, that it is decided cannot be refuted.

### C.7 Double-negation stability

Double-negation stability is, for a claim: if it cannot be refuted, it holds. A decided claim has double-negation stability; Equality of natural numbers has double-negation stability.

### C.8 All, none and none not

All is: it holds of every member under consideration; None is: it holds of no member under consideration; None not is: there is no member under consideration of which it does not hold. For every family, if for each member that it holds cannot be refuted, then that it holds of all cannot be refuted. Recurs is: something holds at arbitrarily late steps; after every step there is a step at which it holds.

### C.9 Derivation

A derivation is a finite tree that infers a claim from a basis and from if-clauses. For every derivation, the claim it infers holds at every configuration at which the basis and the if-clauses all hold.

### C.10 If

An if-clause places a hypothesis in a claim: the claim holds where the hypothesis holds. For every derivation, if the basis holds throughout a region, then a claim inferred under if-clauses holds at every configuration in the region at which its if-clauses hold; if the if-clauses also hold throughout the region, then the inferred claim holds throughout the region.

### C.11 Then and therefore

Then is: where the former holds, the latter holds, without stating that the former holds; Therefore is: the former holds, and the latter is inferred from it. There is a derivation whose configurations take two values and whose basis holds everywhere: a claim is inferred with itself as its if-clause; discharging that if-clause, the resulting claim with then is inferred without if-clauses; and the claim itself cannot be inferred without if-clauses.

### C.12 Counterexample

A counterexample is a configuration in a region at which a claim does not hold. For every derivation, if the basis holds throughout a region, then for a claim inferred without if-clauses there is no configuration in the region at which it does not hold; if the basis holds throughout a region and there is a configuration in the region at which a claim does not hold, then that claim cannot be inferred without if-clauses.

### C.13 What is inferred and the basis

For every derivation, every claim it infers without if-clauses holds throughout a region exactly where its basis holds throughout the region. If the basis holds throughout a region, then, when a claim inferred without if-clauses is added to the basis, every claim the new basis infers without if-clauses still holds throughout the region.

### C.14 Sufficient condition

A sufficient condition is: where this is, that holds.

### C.15 Proof

A proof is a claim that has been checked, together with its check. Every proof of the core depends on no axiom (no propext, Quot.sound, Classical.choice).

### C.16 Supposition

A supposition is what is stated and not asserted; in a proof it is a definition or an if-clause, not an axiom. The ethical suppositions are two: the first fixes the scope of significance and orders nothing; the second alone fixes which of several courses is better; every statement of which course is better (the ethical order) cites the second alone. Any other order, such as the trade-offs a practical commitment fixes, or the order a single one uses of its own, names its own supposition and is not the ethical order.

### C.17 Theorem without premise

A theorem without premise holds in every world so represented; the local hypotheses it uses are written as if-clauses, and no supposition is taken as an if-clause.

### C.18 Theorem under stated premises

A theorem under stated premises holds wherever the suppositions it names hold.

### C.19 Reading (AI, D62)

A reading (AI, D62) is an interpretation taken of the content of what is proved or of the structure of an ancient text, taken together with its argument; a reading entered in the record of decisions is marked with its decision number. A reading does not change a proof; a better argument changes the reading.

### C.20 Left open

Left open is what is not a proof, not a supposition and not a reading, and writes out what is missing.

### C.21 Weakly decided

Weakly decided is: does not hold, or cannot be refuted. A decided claim is weakly decided. That every claim is weakly decided is a supposition.

### C.22 Excluded middle

Excluded middle is: every claim holds or does not hold; it is a supposition.

### C.23 Limited principle of omniscience

The limited principle of omniscience is: for every sequence of holding or not holding along the steps, either it holds at some step or it does not hold at any step; it is a supposition.

### C.24 Weak limited principle of omniscience

The weak limited principle of omniscience is: for every sequence of holding or not holding along the steps, either it does not hold at any step, or it is not the case that it does not hold at any step; it is a supposition. If the limited principle of omniscience holds, then the weak limited principle of omniscience holds.

### C.25 Markov's principle

Markov's principle is: for every sequence of holding or not holding along the steps, if it is not the case that it does not hold at any step, then it holds at some step; it is a supposition.

### C.26 Agreement

Agreement is: for the structure a passage of an ancient text states, the spine has a proved theorem with the same relations, hypotheses and direction.

### C.27 Scope restriction

Scope restriction is: the spine gives the exact range within which what a passage of an ancient text states holds, and changes its universal form.

### C.28 Divergence

Divergence is: the theory does not assert what the ancient text asserts, or what the text asserts conflicts with the structure of the theory.

## Chapter 1

### 1.1 The unfolding and relata

The unfolding is one unfolding of relations: it is represented by a type of relata, which at each step have levels, activity, conditions, needs and draws, and between steps take from and give to one another (for condition, level, activity, dependence, need and draws see 1.2; for uptake and replenishment see 1.11). A relatum is a term of the relations of this unfolding. The whole of the unfolding is everything of the unfolding; a part is a share of the whole of the unfolding.

### 1.2 Dependence, draws and the web

Formation is the role of a relatum that depends on others and draws from them; condition is the role of a relatum that others depend on: one relatum can hold both roles. A level is the amount of a condition at a step; activity is a formation being in operation at a step. Dependence is the relation by which a formation at a step depends on a condition; need is its threshold amount, the number the level of the condition must reach. Draws is the relation by which a formation at a step uses a condition; only whether it draws or not is recorded, not the amount. A web is what records, at each step, the levels of the conditions, the activity of the formations, and their conditions, needs and draws; what it records can change from step to step.

### 1.3 Configuration, move and step

A configuration is what the unfolding is at a step. A move is what passes between steps. A step is the natural-number order by which all relata are counted in common. A claim is what can be said to hold or not hold at a configuration; it need not be decided. A model is what gives one value to each item it applies to; a reading is giving values to configurations through a model; reading off an amount from what makes it up is also called a reading.

### 1.4 Process and run

A process is the admissible transitions between configurations: a configuration goes by a move to a configuration. A run is an infinite actual execution of a process: at each step there is a configuration and a move, and every passage from this configuration by this move to the next configuration is admissible in its process.

### 1.5 Comes to be and ceases to be

Comes to be is: a claim does not hold at a step and holds at the next step; ceases to be is: a claim holds at a step and does not hold at the next step. For every claim decided at each step, if it holds at some step and from then on never ceases to be, then from then on it holds at every step; for every claim, if it does not hold at some step and from then on never comes to be, then from then on it holds at no step, without requiring that it be decided.

### 1.6 Becoming

Becoming is the common name of the forming, keeping, transformation and dissolving of relations (for forms and dissolves see 2.2, for kept see 2.3, for transformation see 3.13; for reading see 1.3); generation and degeneration are both within it (6.6). For every claim, its coming to be and ceasing to be across a step, read on activity, read on dependence and read on standing as a condition, are one becoming with three readings, and this holds by definition.

### 1.7 Law and law shown

A law is a process in which a configuration and a move have at most one configuration as outcome. The law shown is the process a history shows, which admits only the transitions the history passes through. Every history is a run of its law shown; every process has a history as a run exactly where it contains every transition of the law shown of that history: the law shown is the least process that has this history as a run.

### 1.8 When the law shown is a law

A consistent history is one in which, whenever it is twice at the same configuration with the same move, the outcomes are the same. The law shown of a history is a law exactly where the history is consistent; there is a law that has this history as a run, also exactly where this holds. Every law that has a history as a run gives, at every transition the history shows, the same outcome as the law shown.

### 1.9 Histories fix the law up to dead ends

A region of histories is the whole of the runs of some process exactly where every run of the process it shows lies in it. Two processes have the same runs exactly where they have the same transitions that some run passes through; a transition of a process that no run passes through is shown by no history.

### 1.10 The move within the configuration

Reading the move into the configuration and taking it out again leaves the configurations and moves of a run as they were. After the move is read in, a transition to a configuration admits any move after it; the process with the move read in is a law exactly where the original process is a law and, where there is any transition, there is only one kind of move.

### 1.11 Flow, uptake, replenishment, taking and giving

Flow is the amounts relata take from and give to one another across a step: at each step each relatum taking part has, at each condition, an amount it takes and an amount it gives. Uptake is the amount relata taking part take from a condition; replenishment is the amount relata taking part give to a condition. Taking and giving is the flow of one step read as one move.

### 1.12 World

A world is a type of relata whose configuration at each step is a configuration of a web and whose move between steps is a taking and giving: a run of the process that admits every transition. Every world is a run of its law shown, and this run read as a world is that world; for every run whose configurations are configurations of a web and whose moves are takings and givings, read as a world, its configuration of the web at each step is its configuration.

### 1.13 Formation and condition

Formation and condition (1.2) are two roles of one relatum. Every web that divides formations and conditions into two types can be read as a web of one type of relata, and so read it makes a world.

### 1.14 Space of worlds

The space of worlds is the type of every world represented. A theorem without supposition holds in every world of the space of worlds. A supposition of a world is a requirement that marks off a part of the space of worlds: some worlds fit it and some do not.

### 1.15 Balance

Balance is: the level of a condition after the step plus its joint taking equals its level before the step plus what is given to it in all. Under balance, for every family, the total level after the step plus what is taken from it equals the total level before the step plus what is given to it; across a stretch of steps, the two are also equal. Under balance, a level that rises across a step has something given to it, and a level that falls across a step has something taken from it. A world balances exactly where its levels move at each step, with its taking and giving as the move, by the process of balance; and also exactly where every transition of its law shown is a transition of the process of balance.

### 1.16 Takers, renewers, more without end

Takers are those taking part that take something from the family across a step; renewers are those taking part that give something to the family across a step. More without end is: for every number, from some step on the number of takers at every step is not less than that number. Only the active give: every renewer is active at its step; only the active take, and they take only from what they draw on: every taker is active at its step and draws on what it takes from: both are suppositions of a world (1.14).

### 1.17 Rest of the whole

The rest of the whole is what of the whole of the unfolding the world does not contain, counted as one relatum, whose taking and giving is read off from the difference between the change of levels and the taking and giving within the world. Counting the rest of the whole, and reading activity as taking part with some taking or giving and draws as taking something, every world balances, only the active give, only the active take, and they take only from what they draw on. A world balances by itself exactly where, with the rest of the whole counted, the rest is inactive at every step; the becoming of a world read by levels and read by taking and giving: the two readings show the same at every step exactly where the world balances; counting the rest of the whole, the two readings are the same in every world at every step.

### 1.18 Moves of the part and moves of the rest

Take a part and the rest of the whole as two components of one configuration, the two moving together at each step by one move. A move fixed only by the configuration of the part (the same configuration of the part, the same move), whatever the configuration of the rest, is a move of the part; one fixed only by the configuration of the rest is a move of the rest; a move is both exactly where it is the same everywhere: so every move that differs at two places is fixed alone by at most one side. There is a move that comes from the relation between the part and the rest, which neither fixes alone. If the process of the part is a law and the move is a move of the part, then the part has its own law: for two runs of the whole of the unfolding in which the part starts at the same configuration, however the rest starts and runs, the part is the same at every step. If the next configuration of the rest is fixed by a model (1.3) of its configuration and the move, and the move is a move of the part, then the run of the rest is the run, from its starting configuration, under the moves that the configurations of the part fix step by step: what the part does, the rest receives.

### 1.19 Frame and claim

A frame is a process in which each configuration is attached to the claims that hold at it (for claim see 1.3). Along a run, a frame is a world: its relata are the claims, a claim holding is its relatum being active, and a claim coming to be is the activity of its relatum coming to be. With the configurations as the claims, if the worlds of two runs have the same activity everywhere, then the two runs have the same configuration at every step.

### 1.20 View

View is the common name of process, frame and world. For every law given by a model that assigns each configuration its next configuration, the orbit from a configuration is a run of its process; every run of its process is the orbit from its starting configuration. A name is that by which what is read is referred to: the value a reading gives to what it reads.

### 1.21 Course and same course

A course is the values of the configurations of a history through a model, step by step. Every sequence of values along the steps is a course: taking the passage from each step to its next as the law and these values as the model, two steps are alike exactly where the values from the two steps on are the same step by step; if two steps are alike, their next steps are alike too: the configurations of a course and its law are both read off the course, and no configurations need be given. For a run of a law, its course through a model is the same from two steps on exactly where, with the law shown through this model, the configurations at the two steps are alike. Two configurations whose courses under a law through a model are the same at every step are said to have the same course.

### 1.22 Alike

Alike is: two configurations are linked by a relation such that, for any two configurations it links, the same claims hold at both, and whenever one makes a transition, the other makes a transition by the same move to one it links. Two configurations under a law shown through a model are alike exactly where they have the same course. A frame is determined up to likeness at a configuration where any two outcomes of one move from this configuration are alike; being determined up to likeness carries over along likeness. If the claims are the names of the configurations, then the process is a law exactly where the frame is determined up to likeness at every configuration.

### 1.23 A configuration is how it relates

For alike configurations, after the same sequence of moves the claims that can hold are the same. A description that makes sense is a reading that puts together only configurations that are alike and puts together all that are alike; if a frame is determined up to likeness at every configuration, then a description that makes sense carries a law. If two frames are each determined up to likeness at every configuration, then two configurations are alike exactly where the sequences of moves admissible from them are the same and, after the same sequence of moves, the claims that can hold are the same.

### 1.24 Describing apart loses the relation

For every whole of the unfolding divided into two parts, recording what each allows and describing them apart adds nothing absent exactly where whatever one part allows combines with whatever the other part allows; otherwise what is left out is exactly their relation, which shows up again as extra combinations. There are three parts such that what any two of them allow combines freely, while what the three allow does not.

### 1.25 Gluing

Gluing is: what the contexts show at a configuration fits one context-free value: for every context that holds a claim, what it shows is this value at the claim. If every claim is held by some context, the contexts glue at a configuration exactly where every two contexts that both hold a claim show the same there.

### 1.26 Contextual composition

Contextual composition is: readings each hold in their context, and together they make one world. Along a run, claims indexed by context are all relata of one world, active exactly where their context holds them and shows this value, without requiring gluing. If every claim is held by some context, then there is a context-free frame that fits the contexts exactly where they glue at every configuration. If every claim is held by some context, what each context allows concerns only the claims it holds, no context-free value fits what all the contexts allow, and some configuration keeps to what they allow, then no context-free frame fits them.

### 1.27 Parity and contradiction

Parity is whether the number of holding claims among those a context counts is odd or even; a parity system has a family of claims, and each context fixes the claims it counts and the parity it requires. A contradiction is a family of contexts (repetition allowed) in which every claim is counted an even number of times while the required parities add up to odd. For every context-free value, among the contexts of a contradiction it fits at most one fewer than their number, and so does any average over a mixture of values; where each context has its own value, if each context can be fitted alone, all of them are fitted. If the claims of the family are distinct and their sameness is decided, then for a listed family of contexts either there is a context-free value fitting each of them, or some family among them is a contradiction; if every context is in the listed family, then there are values that keep to what the contexts allow and glue, exactly where there is no contradiction.

## Chapter 2

### 2.1 Meets, admission and bearing

Meets is: the need is at most the level of the condition. A formation at a step whose every dependence is met is said to have admission by the levels. Bearing is a dependence whose need is positive. For every formation that has admission at step A; if at step B each of its conditions was already a condition of it at step A, its need is at most that at step A, and the level of the condition is not below that at step A, then it also has admission at step B.

### 2.2 Forms and dissolves

Forms is: a dependence appears across a step: absent at the start of the step, present after it. Dissolves is: a dependence disappears across a step: present at the start of the step, absent after it. For every dependence absent at some step and present at some later step, that there is a step between at which it forms cannot be refuted; if present at some step and absent at some later step, that there is a step between at which it dissolves cannot be refuted.

### 2.3 Kept and broken

Kept is: a dependence is met at the start of a step, and after the step its level still meets the need at the start. Broken is: a dependence is present and met at the start of a step, and after the step the level of its condition is below the need at the start. Every dependence present and met at a step is, across this step, either kept or broken, and exactly one of the two.

### 2.4 Joint taking and breaking

If there is balance, a dependence meets, after a step, its need at the start of the step exactly where its need plus the joint taking is at most the level of its condition at the start plus what is given in all; if the dependence is present and met at a step, then it is broken across this step exactly where the level of its condition at the start plus what is given in all falls short of its need plus the joint taking. At the same condition and the same step, if one dependence is broken, then every dependence present and met whose need is not below that one is broken too. If there is balance, only the active take, and they take only from what they draw on, then for every broken dependence there is an active relatum taking part that draws on its condition and takes from it at this step. If there is balance, a dependence is broken, and for every relatum taking part at this step what it takes plus this need is at most the level at the start plus what is given in all, then what each relatum takes is less than the joint taking. For another balanced flow, if at this step the level of this condition is not below that under the first flow, the joint taking is less than under the first flow by at least e, what is given in all is not less than under the first flow, and a need plus the joint taking of the first flow is at most the level under the first flow plus what it gives in all plus e, then this need is met after the step under the second flow.

### 2.5 Dependent

Dependent is: at every step at which a formation is active it has admission: a supposition of a world, stated and not asserted. Read taking and giving as a relation (a step may admit several kinds of taking and giving), and activity as taking part with some taking or giving: if dependence is read as necessarily no taking or giving (under every history that differs from the history read only in the level of this condition at this step, with that level below its need, no admissible taking and giving gives the formation any taking or giving), then every run of this relation is dependent, for any need; if dependence is read as possibly no taking or giving (under these histories some admissible taking and giving gives the formation none), then there is a relation with a run of it that is not dependent. If a law of taking and giving admits only one kind of taking and giving at each step, then on its runs both readings are the dependence that its law reads.

### 2.6 Where admission comes from

Under balance, where only the active give and the world is dependent: if the level of a condition is higher at the next step than at this step, then some relatum taking part and having admission gives to it at this step; if a formation goes across a step from not having admission to having admission, and each of its dependences is still present across the step with need not decreasing, then it is not the case that none of its conditions has a relatum taking part with admission giving to it; if no relatum of a region has admission at some step, from then on at every step each dependence of each relatum in the region is still present across the step with need not decreasing, and everything that gives to their conditions is in the region, then from then on no relatum of the region has admission.

### 2.7 After a break

If the world is dependent, the level of the condition of a dependence after a step is below the need at the start, and the dependence is still present after the step with need not decreased, then the formation is inactive after the step. If the world is dependent and the level of a condition after some step is always below the need of a dependence at that step, then a formation still active afterwards cannot both still depend on this condition and have a need not below that at that step; one whose dependence is still present after that step with need not below that at that step is never active from then on. Broken does not decide what follows: there is a process with three runs from the same configuration that each break a dependence at step zero: in one run the level of the condition is below the need of step zero at every later step, and the formation is never active again; in one run the same holds, but the dependence dissolves and another forms, and the formation is active at every step; in one run the level of the condition is not below this need at every step, and from step two on the dependence is kept at every step.

### 2.8 Necessary condition and necessary and sufficient condition

A necessary condition is: with it, not necessarily so; without it, necessarily not so. A necessary and sufficient condition is: with it, necessarily so; without it, necessarily not so. If dependent, without admission there is no activity: admission is, for the activity of a formation, that without which it is necessarily not so; that with it, it is not necessarily so (a case of admission without activity) has no named proof yet and is left open.

### 2.9 Ends

Ends is: a formation is never active from some step on. If each formation of a family ends, then there is a step from which none of them is active.

### 2.10 Reserve

A reserve is an amount of a formation that does not increase at a step at which the formation has no admission, and decreases if the formation is active at that step. Dependent holds exactly where zero is a reserve. For every reserve, if a formation from some step on never has admission, then its activity does not recur; if its activity is decided at every step, then in any stretch from this step on the number of steps at which it is active is not more than its reserve at this step. If there is balance, each relatum is paired with a condition, at steps at which the relatum has no admission nothing gives to this condition, and at steps at which it has no admission and is active something takes from it, then the level of this condition is a reserve of the relatum. If a reserve falls whenever it is positive at a step without admission, then from the first step of never having admission, plus the reserve at that step, the formation is never active.

### 2.11 Embodied

Embodied is: a relatum is active exactly where it stands as a condition. If dependent, and at a step at which a formation is active it depends with positive need on an embodied relatum, then this embodied relatum is also active. If the level of an embodied relatum after some step is always below the need of a dependence at that step, and this need is at most one, then the embodied relatum is not active afterwards. When a web divided into two types is read as a web of one type of relata, no formation that is active at some step is embodied.

### 2.12 Coextinct

If dependent, at a step activity carries along a chain of dependence with positive need on embodied relata: if a relatum on the chain is active, then everything it reaches along the chain is active. So if a relatum reached by the chain is not active at this step, then everything that reaches it along the chain is not active at this step; this is called coextinct.

### 2.13 Self-bearing

Self-bearing is: at every step at which a relatum is active it depends with positive need on itself. If dependent, a self-bearing relatum stands as a condition at every step at which it is active; if it is also embodied, then its dependence on itself is met exactly where it is active. If dependent, and an embodied, self-bearing relatum is active at a step and not active at the next, then everything that draws on it at this step draws on a condition at which some dependence is broken at that step. There is a web in which two relata each depend only on the other and neither is self-bearing; swapping the labels of their conditions, both are self-bearing and dependent holds as before: which relatum is self-bearing is fixed by the labelling.

### 2.14 Interacts

Interacts is: two events are related through a condition: one draws on it and the other depends on it with positive need, whatever their steps. Interaction runs both ways alike; whatever interacts either depends on or draws on the condition through which it interacts. If nothing draws on a condition, or nothing depends on it with positive need, then there is no interaction through it. Whatever draws on a self-bearing relatum interacts with each of its active events.

### 2.15 Lives on

Lives on is: a formation at a step draws on a relatum and depends on it with positive need. If dependent, then for an active formation, what it lives on stands as a condition at this step; if what it lives on is also embodied, it is also active at this step.

## Chapter 3

### 3.1 Arising and ceasing

Arising is: a formation is not active at a step and is active at the next step; ceasing is: a formation is active at a step and not active at the next step: arising and ceasing are activity coming to be and ceasing to be.

### 3.2 Comes to stand and ceases to stand

Comes to stand is: a condition has no level at a step and has a level at the next step; ceases to stand is: a condition has a level at a step and has no level at the next step: coming to stand and ceasing to stand are standing as a condition coming to be and ceasing to be. For every embodied relatum, if it arises, it comes to stand. For every family of conditions, coming to stand recurs in the family exactly where ceasing to stand recurs in the family, without requiring that anything be decided.

### 3.3 Rises and falls

Rises is: the level of a condition is higher at the next step than at this step; falls is: it is lower at the next step than at this step. For every amount counted in natural numbers, its value at the end of a stretch plus what it fell within the stretch equals its value at the start plus what it rose within the stretch; the same holds of the sum of the amounts of a family. For every family of conditions, if falling recurs in the family, then rising recurs in the family. For every family whose members each have an amount counted in natural numbers, all bounded, if rising recurs in the family, then falling recurs in the family. There is a web in which the level of a condition rises at every step and never falls.

### 3.4 Census balance

Census balance is: within a stretch, the number of those for which a claim holds at the end plus the number of ceasings to be within the stretch equals the number of those for which it holds at the start plus the number of comings to be within the stretch. Wherever the claims of the members of a family are decided, there is census balance. Where those for which the claim holds are listed once each at every step and the claim is decided, there is also census balance, and the relata counted need not be finite; read on activity: where the active are listed once each at every step and activity is decided, the number active at the end plus the number of ceasings within the stretch equals the number active at the start plus the number of arisings within the stretch.

### 3.5 Keeps pace

Keeps pace is: within a stretch, the number of comings to be and the number of ceasings to be of the members of a family differ by at most the number of members. Wherever the claims of the members of a family are decided, they keep pace, and coming to be recurs in the family exactly where ceasing to be recurs in the family; where their claims are decided from some step on, this exactly-where also holds. Without adding decided: if coming to be recurs in the family, then it cannot be said that from some step on nothing in the family ceases to be; if ceasing to be recurs in the family, then it cannot be said that from some step on nothing in the family comes to be. Wherever activity is decided and from some step on some family contains those active at each step (as holds where the formations are finite), arising recurs exactly where ceasing recurs. Without adding decided, requiring of every finite world that 'arising recurs exactly where ceasing recurs' holds exactly where excluded middle holds; if the activity of a finite world is decided from some step on, then arising recurs exactly where ceasing recurs.

### 3.6 Census

A census is: the active at each step are listed once each. For every claim decided at each step, if at arbitrarily late steps all those for which it holds lie in one family (as holds where those for which it holds have a census at each step): if ceasing to be recurs, then coming to be recurs; read on activity: if ceasing recurs, then arising recurs. The converse fails: there is a world with a census of the active in which arising recurs and ceasing does not recur; for every bound that does not decrease along the steps and has no upper limit, there is a world with a census of the active at each step whose number does not exceed this bound, in which arising recurs and nothing ceases. Where the active at each step have a census, activity is decided, and from some step on their number does not exceed a bound, arising recurs exactly where ceasing recurs.

### 3.7 Count and listing once

A count is the tally of the members of a family for which a claim holds: the count exists exactly where the claim is decided for each member of the family. Listing once is listing the members of a family, each once: a listing once exists exactly where the sameness of the members of the family is decided; that a listing once exists cannot be refuted. Wherever those for which a claim holds have a census at each step, their counts, without requiring decided, fit census balance at every step (the count at the earlier step is those listed at both steps plus those that cease to be; the count at the later step is those listed at both steps plus those that come to be); a statement depending only on the values of the counts holds for every decided claim with a census exactly where it holds for every sequence of counts that fits census balance step by step. With the sameness of relata read by their relations, the number of relata in every family of every world exists exactly where excluded middle holds.

### 3.8 Unceasing

Unceasing is: arising recurs. If every arising, at a step at which nothing in a family rises, makes something in it fall: then, if unceasing holds, it cannot be said that from some step on nothing in the family rises; if every rise is made by some active relatum giving to it, then it also cannot be said that from some step on the family has no active relatum giving to it. For every amount counted in natural numbers, if it never rises and every arising makes it fall, then unceasing does not hold. There is a web that fits all the if-clauses above, whose family has two conditions with a total level of one at every step, and which is unceasing; there is a web in which every rise is made by some active relatum giving to it, rising recurs, active relata giving recur, and no relatum arises.

### 3.9 Coming to rest

Coming to rest is: from some step on, in a world, no relatum arises and no relatum ceases.

### 3.10 Stillness

Stillness is a configuration the law does not change. For every law, its run from a starting configuration changes no more from some step on and satisfies a claim exactly where the run reaches a stillness that satisfies this claim. Where the sameness of configurations is decided, all configurations of a run lie in one family, and the run has no configuration at some step that is had again later with a change in between: it changes no more from some step on exactly where at every step it is decided whether it changes again afterwards or changes no more; that it changes no more from some step on cannot be refuted. For every run of a law, where the sameness of configurations is decided and there is an amount counted in natural numbers that never falls along the run, rises whenever the configuration changes, and never exceeds the amount at the starting configuration plus d: the run changes no more from some step not beyond d, without requiring the limited principle of omniscience. If a run changes no more from each of two steps on, then the configurations at the two steps are the same. The limited principle of omniscience holds exactly where: for every process whose configurations have decided sameness and are exhausted by one family, if no configuration reachable from a configuration changes by a move to another configuration from which it can be reached again, then every run starting from this configuration changes no more from some step on. The limited principle of omniscience also holds exactly where: for every run and every yes-or-no reading of its configurations, either the reading holds at some step or it holds at no step.

### 3.11 Continuation relation, continuation and arising anew

The continuation relation is the relation that reads a formation after a step as continuing a formation before the step. Continuation is: a formation after a step is read by the continuation relation as continuing some formation active before the step. Arises anew is: a formation is active after a step and continues no formation active before the step; ceases without continuation is: a formation is active before a step and no active formation after the step continues it. Taking as the continuation relation that each formation continues only itself, arising anew is arising and ceasing without continuation is ceasing.

### 3.12 Re-identification and co-reference within a step

Re-identification is a one-to-one correspondence at each step between two namings; one whose correspondence is the same at every step is a renaming. Co-reference within a step is two names picking out one relatum within a step: the correspondence a re-identification gives at each step. Every re-identification of formations leaves unchanged, at each step, admission, kept and broken, and, at each step and each condition, what is taken and what is given.

### 3.13 Transformation

Transformation is: the configuration differs across a step and continuation holds.

### 3.14 Balance fixes continuation

A world under a re-identification balances exactly where the continuations it reads all lie within balanced continuation, one to one at each step; this is a theorem without premise. If a world balances, then f balance-continues g exactly where f and g have the same level after the step. If a world balances and the sameness of relata is decided: every re-identification under which it still balances continues c as c exactly where after the step no other relatum has the same level as c; if some other relatum d has the same level as c after a step, then there is a re-identification under which it still balances that continues c as d; a relatum arises across a step under every re-identification under which the world still balances exactly where, by balanced continuation, it arises anew. There is a world in which the levels of all relata are zero and both of two namings keep it balanced: under one naming it is unceasing, under the other nothing arises, and no arising is, by balanced continuation, an arising anew.

### 3.15 Continuity

Continuity is: a re-identification keeps the name of a formation active both before and after a step. Every re-identification with continuity makes no arising: an arising under the new names is also an arising under the old names; so if unceasing holds under the new names, it also holds under the old names. If the old names also keep continuity of the new names, then a formation active before a step and one active after it with the same name are one; if there is continuity both ways, then arising and unceasing are exactly as they were. There is a web and a re-identification with continuity that joins under one name two formations active in alternation: with separate names it is unceasing, with the joined name it is not unceasing; the joined names keep the continuity of the separate names, and the separate names do not keep the continuity of the joined names.

### 3.16 Split and merge

Split is: one active formation before a step is continued by two active formations after the step; merge is: one active formation after a step continues two active formations before the step. Wherever the active at each step have a census and activity and the continuation relation are decided, at every step: if there is no split, then the number in the later census plus the number ceasing without continuation is at most the number in the earlier census plus the number arising anew; if there is no merge, then it is not less; if there is neither split nor merge, the two are equal. So with a census and no split, if ceasing without continuation recurs, then arising anew recurs; with a census and no merge, if from some step on the number listed does not exceed a bound and arising anew recurs, then ceasing without continuation recurs. There is a web with a census of the active at each step: read by one continuation relation, it has no merge but has a split, at every step something ceases without continuation, and arising anew does not recur; read by another continuation relation, it has no split but has a merge, at most two are listed at each step, at every step something arises anew, and nothing ceases without continuation.

### 3.17 More forces arising anew

For two families before and after a step, each with distinct members: under every continuation relation without split, not every member of the later family continues a member of the earlier family exactly where the later family has more members than the earlier. Where the sameness of relata is decided: a continuation relation makes, for every two families of which the later has distinct members and more of them than the earlier, not every member of the later family continue a member of the earlier family, exactly where it has no split. With a census of the active at each step: under every continuation relation without split, it recurs that the active after a step do not all continue those active before it exactly where it recurs that more are active after a step than before it. If there is a census, the family taking part at each step has distinct members, only the active take and they take only from what they draw on, there are more without end, and the continuation relation is decided and has no split: then arising anew recurs. There is a web that fits all of census, distinct members of the family taking part, only the active take and they take only from what they draw on, and more without end: read by one continuation relation with a split, arising anew still recurs; read by another continuation relation with a split, nothing arises anew after the first step.

### 3.18 Persists and hibernation

Persists is: a formation at a step is active, or depends on some condition at this step. Hibernation is persisting without being active. Reading activity as persisting: what persists before a step does not arise across this step; an active formation ceases to persist across a step exactly where it ceases to be active and does not persist at the next step: entering hibernation is not ceasing. If a re-identification keeps the names of what persists, then a relatum has only one name over every stretch in which it persists, active or in hibernation. There is a web and a re-identification with continuity both ways that does not keep the names of what persists; there is a web with a step at which nothing persists, in which a re-identification that keeps the names of what persists both ways still joins what comes before and after under one name.

### 3.19 Whole and part

A whole is active at each step exactly where one of the formations it joins is active; the formations it joins are called its parts (for part see 1.1). Every formation is the whole of itself; there is a web with two formations, each active at every step, each of which is a whole of the other. If a whole arises, then some part arises at the same step; so if arising of a whole recurs, then arising recurs among its parts.

## Chapter 4

### 4.1 Recurrent uptake needs replenishment

Under balance, if the uptake of a family is recurrently positive, then its replenishment cannot be zero at every step from some step on. Under balance, if the takers of a family are more without end, then the replenishment of the family has no final bound; if each relatum gives the family at most a fixed amount at each step, then the number of renewers also has no final bound.

### 4.2 Closed and enclosed around

Closed is: for a family at a step, no relatum taking part takes from outside the family or gives outside it. A step has a closed family where some family with distinct members is closed at that step. Enclosed around is: some family with distinct members contains this family and is closed at the step; enclosed around what stands is: some family with distinct members contains everything that stands as a condition before or after the step and is closed at the step. If all conditions lie in one family with distinct members, then every step has a closed family. Where the sameness of conditions is decided, if a step has a closed family, then every family is enclosed around at that step; without asking whether their sameness is decided, if a step has a closed family, that every family is enclosed around at it cannot be refuted.

### 4.3 Gainless and conserving

Gainless is: for a family at a step, each relatum taking part gives the family no more than it takes from the family; conserving is: it gives the family exactly what it takes from the family. Under balance, if a family is gainless at a step, then the total level after the step plus the amount by which what is taken from the family at this step exceeds what is given to it equals the total level before the step; if conserving, this amount is zero. Under balance, if from some step on the family is conserving at every step and, once its configuration changes, it is never again the same as its configuration at any earlier step since that step, then the number of steps at which it changes is at most the number of ways its total level can be divided among its members; if from some step on it is gainless at every step and its configuration changes recurringly, then 'after a change its configuration is again the same as at some earlier step since that step' cannot be refuted.

### 4.4 Dissipation

Dissipation is: for every family with distinct members closed at a step, each relatum taking part gives the family no more than it takes from it, and, if it takes something, less than it takes; any family for which this holds at a step (without asking whether it is closed or whether its members are distinct) is said to dissipate at the step. Under balance, if a family dissipates at a step, then the total level after the step plus the number of its takers is at most the total level before the step; if over a stretch of steps the family balances and dissipates at every step, then the total level at the end of the stretch plus the total number of takers within it is at most the total level at the start of the stretch. Under dissipation, if the step has a closed family, then every relatum taking part that gives also takes.

### 4.5 Depletion

Depletion is: at every step at which a claim holds, if nothing in the family rises then something in it falls: this claim is said to deplete the family. Under balance, if at every step at which a claim holds the family dissipates and has takers, then this claim depletes the family. Under balance, if a family dissipates at a step and has takers, then something in the family falls, whether or not other members rise; if a member of the family rises, then at the same step another member of the family falls.

### 4.6 Runs down

Runs down is: at a step a family has distinct members, contains everything that stands as a condition before or after the step, and balances and dissipates. For every family that runs down at a step, the level of some condition rises or falls exactly where the total level of the family falls.

### 4.7 Recurrent change needs openness

Wherever what stands as a condition has a census, rising or falling of the level of a condition recurs exactly where there recur steps at which what stands does not run down and on which some level rises or falls. Under balance and dissipation, where what stands has a census, if from some step on it cannot be refuted that what stands is enclosed around at every step, then taking and giving by relata taking part does not recur. Wherever what stands has a census, if from some step on what stands runs down at every step, then no condition rises recurringly.

### 4.8 Conveying, fed from beyond, drawing in

Conveying is: a relatum taking part, at a step, takes from one condition and gives to a condition. Fed from beyond is: at a step, a condition outside a family conveys into a member of the family. A step without drawing in is one at which everything that gives to the family takes only from within the family; drawing in is: not without drawing in. Wherever the sameness of conditions is decided, a step is without drawing in exactly where there is no feeding from beyond at that step.

### 4.9 A family taken from recurringly is fed from beyond

Under balance and dissipation, if a family is taken from recurringly, then no family with distinct members that contains this family can be closed at every step from some step on. If this family has distinct members and from some step on is enclosed around at every step, then it cannot be without drawing in at every step from some step on; if the sameness of conditions is decided, then it also cannot be without feeding from beyond at every step from some step on. If the sameness of conditions is decided and something in the family rises recurringly, it also cannot be without feeding from beyond at every step from some step on; if relata are of one type with decided sameness and an embodied member of the family arises recurringly, the same holds.

### 4.10 Cut

A cut is a region that no relation leads out of. Reading relation as conveying: if relata are of one type with decided sameness, there is balance and dissipation, a family has distinct members, from some step on it is enclosed around at every step, and it is taken from recurringly, then its region is not a cut. Read as relata of one type, conveying relates two conditions, while neither interacts nor lives on relates two conditions.

### 4.11 Succession

Succession is: what is drawn on is, at every step, given to by sources that follow one another, and no source gives again. There is a flow with balance and dissipation in which only the active give, one relatum takes from the pool at every step, the pool is fed from beyond at every step, and no source takes part at two steps or is active at two steps.

### 4.12 Openness

Openness is: it cannot be that from some step on every step has a closed family: taking and giving go beyond every family. Every world in which the active have a census, all relata are embodied, and which balances, dissipates and is unceasing, has openness. There is a world that is dependent and balances, in which only the active give, only the active take and they take only from what they draw on, which dissipates, is embodied and has a census of the active, and which has openness and is not unceasing.

### 4.13 Least loss and Archimedean amounts

Archimedean amounts is: for every amount greater than zero and any given amount, adding the first to itself some number of times goes beyond the given amount. Least loss is the least amount, greater than zero, by which an amount falls at every step counted. Amounts in natural numbers are Archimedean amounts.

### 4.14 Coming to rest needs a least loss

For every amount that does not rise from some step on and falls by at least a least loss at every step counted, if there is a number m such that m least losses added together go beyond its value at that step, then the steps counted do not recur. If the amounts are Archimedean amounts, a least loss greater than zero suffices.

### 4.15 Read from a family, no least loss is needed

For every amount read from configurations contained in one family, if it does not rise from some step on, then strict falls do not recur; this holds for any amounts, without a least loss and without Archimedean amounts.

### 4.16 Approaches without reaching

Approaches without reaching is: an amount approaches coming to rest without reaching it. For every Archimedean amount whose value at each step from some step on, plus what it falls, is at most its value before the step, for any ε greater than zero there is a number such that from this step on there are not that many steps each falling by at least ε; steps falling by at least ε do not recur. There are Archimedean amounts without a least loss, with a value among them that falls at every step and for which, for every ε greater than zero, steps falling by at least ε do not recur.

### 4.17 The law of coming to rest

For every world in which the active have a census, what stands has a census, everything that arises is embodied, and which balances, dissipates, and from some step on is enclosed around what stands at every step, 'it comes to rest from some step on' cannot be refuted. If, for every finite world with decided activity that has the seven suppositions dependent, balance, only the active give, only the active take and they take only from what they draw on, dissipation, embodied, and a census of the active, the step from which nothing arises can be pointed out, then the limited principle of omniscience holds.

### 4.18 Coming to rest in any amounts

Reading the levels and the taking and giving of a world in any amounts: a family has no self-increase at a step where, for each member, its level after the step plus what is taken from it lies within its level before the step plus what is given to it (balance is the equality form of this: a balanced world read in natural-number amounts has no self-increase); a family dissipates at a step where relata taking part give the family no more than they take, and those that give exactly what they take take nothing. For every family with no self-increase that dissipates, if the level of a member of the family rises or falls, then the total level of the family strictly falls, without a least loss. For every world in which the active have a census, all relata are embodied, there is no self-increase, it dissipates, from some step on every step has a closed family, and the total level of the active is read from configurations contained in one family, 'it comes to rest from some step on' cannot be refuted.

### 4.19 Joint excess and taking within giving

Joint excess is: the relata taking part jointly take from a condition at a step more than is given to it at that step; taking within giving is: the joint taking is at most what is given; each taking within giving is: each relatum taking part takes from a condition at a step no more than is given to it at this step. Under balance, with taking within giving, the level does not fall at this step; with taking within giving at every step, the level is not below its start. Under balance, at every step of joint excess the level falls by at least one; if from some step on there are n steps of joint excess, then the level after the n steps plus n is at most its start. There is a condition at which, at a step, each taking is within giving and there is joint excess.

### 4.20 Joint excess ends what depends on the condition

Under balance, where only the active give, the world is dependent, and every renewer of a condition depends on it with need not below m: once the level is below m, it is below m at every step afterwards, and nothing that depends on it with need not below m is active. If from some step on there are n steps of joint excess and the starting level is less than n + m, then after the n steps the level is below m at every step and nothing that depends on it with need not below m is active; takers that depend on it with such a need are among them. The same holds for a family: if everything taking part that gives to a member of the family depends on some member of the family with need not below m, the family has joint excess at each of n steps from some step on, and the starting total level is less than n + m, then from then on nothing that depends on any member of the family with need not below m is active.

### 4.21 The fall beyond the family

Under balance, if the family together with the conditions beyond it is gainless at a step, then the total level of both after the step plus the amount by which joint taking exceeds giving over the family and beyond equals the total level of both before the step; if the family and what is beyond it dissipate at a step, then the total level of both after the step plus the number of takers over the family and beyond is at most the total level before the step. If over a stretch of steps the family and what is beyond it are gainless at every step, then the total level of both at the end of the stretch is at most that at the start: the rise of the family is at most the fall beyond it. If the total level of the family rises above the sum of the total levels of both at the start of the stretch, then it cannot be that the family and what is beyond it are gainless at every step of the stretch. Under balance, if each condition beyond the family has a relatum depending on it with a need it meets, the family and what is beyond it are gainless at a step, and the total level of the family after the step plus the amount by which joint taking exceeds giving over the family and beyond is more than the total level of the family before the step plus the sum, over the conditions beyond, of the amount by which each level exceeds the need it meets, then some dependence beyond the family is broken.

### 4.22 Takes all

Takes all is: a relatum taking part takes from a condition at a step no less than all that is given to it at that step. For every condition given at most B at each step, if what a relatum takes is larger at the next step than at this step for n steps in a row, and n is greater than B, then at the end of the n steps this relatum, if taking part, takes all. Under balance, no relatum can, for L + 1 steps from some step on, take part and take more than is given, where L is the starting level. Under balance, where only the active give, the world is dependent, and every renewer of a condition depends on it with need not below m: if a relatum takes all for n steps while another relatum takes part and takes from the condition at each of these n steps, and the starting level is less than n + m, then from then on nothing that depends on the condition with need not below m is active, and so too for the one that takes all if it depends on it with such a need; if a relatum takes all at every step, depends on the condition with need not below m at every step and is active at every step, then no other relatum can take part and take from it for L + 1 steps from any step, where L is the level at that step.

### 4.23 Runs dry

Runs dry is: a level falls to zero. For every process in which at every step the level after the step plus what is taken at this step is at most the level before the step, and something is taken at every step at which the level is positive, every sequence of moves no shorter than its starting level ends at zero; from a step at zero, nothing is taken.

### 4.24 The run-dry boundary under a standing draw

A condition at each step is first taken from by the standing draw H (all of it, if it is less than H), then given g(z) according to what is left z (the standing giving). If g(z) is less than H whenever z is less than y, and g(0) is zero, then a level starting below H + y runs dry within as many steps as its starting level. If g(z) is not less than H whenever z is not less than y and z + H is at most hi, and no step takes a level not above hi beyond hi, then a level starting from H + y up to hi never falls below its start and never exceeds hi. If both hold and H + y is greater than zero, then a level starting not above hi eventually runs dry exactly where its start is less than H + y: H + y is called the run-dry boundary. If g(z) is zero whenever z is less than the need m, H is positive, and y is the least z for which g(z) is not less than H, then m is less than y exactly where g(m) is less than H.

### 4.25 Where a run changes no more under a standing draw

If the standing giving does not decrease as what is left grows, and no step takes a level not above hi beyond hi, then a run starting from a level not above hi changes no more from some step not beyond hi, at a level that a step of the standing giving does not change. There is a standing giving that gives two from zero and gives zero when what is left is more than zero, which does not increase with what is left, with standing draw one, in which no step takes a level not above two beyond two, and the run from one goes back and forth between one and two at every step and never reaches a step after which it changes no more.

### 4.26 The threshold in the plane

If what is given is fixed by reading what is left and the preceding giving (write it A), A increases with both, and a step from a level and a preceding giving both not above hi has its next level not above hi: then for every preceding giving r not above hi, the run from a level x not above hi ends up changing no more from some step on below the standing draw exactly where x is below a threshold; this threshold does not increase as r increases. Where what is given reads only what is left (the standing giving g), g increases with what is left, the hypotheses of 4.24 hold, and the region not above hi reaches the run-dry boundary, the threshold is the run-dry boundary H + y for every r. There is a giving that does not increase with what is left, keeps to its region, and has no threshold dividing its runs.

## Chapter 5

### 5.1 Return

Return is: a configuration can still reach itself after a step: there is a move from it to a configuration from which it can be reached. Under a law, a configuration returns exactly where the configuration of its run after some positive number of steps is this configuration. For every process, a configuration that returns can be had at every step.

### 5.2 Confluence

Confluence is: a law takes two different configurations in one step to one configuration. For every two configurations in confluence, they share one configuration at every step afterwards, and they do not both return. For every law, if a configuration cannot be had at some step, then it cannot be had at any step afterwards; if the configurations are exhausted by one family and the law has confluence, then not every configuration can be had at step N (N being the number of members of the family).

### 5.3 Without confluence is return

Where the configurations are exhausted by one family, a law has no confluence exactly where every configuration returns, exactly where every configuration can be had at every step; there, if an amount counted in natural numbers never falls along a run and rises at some step, then the law is not without confluence. For every law without confluence that has a configuration that does not return, no family exhausts its configurations.

### 5.4 Confluence of the part is taken up by the rest

For every law without confluence, with each configuration read as its part and its rest, two configurations being one where both their parts and their rests are the same: if, after k pairwise distinct configurations each run n steps, their parts all lie in one family and their rests all lie in another, then the product of the numbers of members of the two families is not less than k; so if the parts are all one, every family containing the rests has at least k members. For every law without confluence, if after one step the part of every configuration is the same p, and some configuration has a part other than p, then no family exhausts the configurations. For every process with a run whose configurations all lie in one family, and an amount whose value after each step plus what it loses at this step is at most its value before the step: if what it loses at some step is not within zero, then this process is not without confluence.

### 5.5 With novelty no family exhausts

Novelty is: from some step on every configuration differs from every configuration before it. For every family whose total level from some step on does not exceed a bound, from every step on there are two steps that share a configuration of this family. For every history that has novelty from the start, or along which an amount counted in natural numbers rises at every step, no family exhausts what it passes through.

### 5.6 Kept history

A prefix is the segment of a course before some step. Kept history takes as configuration the pair of present and prefix: the present runs by the law, and the previous present enters the prefix. For every law, with kept history it has no confluence, has novelty from the start, does not return, a configuration with an empty prefix cannot be had after one step, and no family exhausts its run; if the present returns, the prefixes differ; if the configurations a run of the law passes through are exhausted by one family, then from every step on there are two steps that share one present and differ in prefix.

### 5.7 Invariant

An invariant is a region kept at every admissible step of a process: if a configuration is in the region, the outcome of an admissible step from it is in the region too. A region is invariant exactly where every move keeps it. For every invariant, everything reachable from the region is in the region. For every run that is in a region at some step, if every move it takes afterwards keeps this region, then it is in the region at every step afterwards; if a run leaves the region, the move at the step at which it leaves does not keep the region.

### 5.8 Gate

A gate is a decided label on the moves of a process. If every move that is not a gate reflects a claim (if the claim holds at the configuration after the step, it holds at the configuration before the step too), then every sequence of moves ending at a configuration where this claim holds either starts at a configuration where it holds, or can be divided into an earlier segment, a step through a gate and a later segment, with the claim holding after this step through the gate; this does not require that the claim be decided. If every move that is not a gate leaves a quantity unchanged, then every sequence of moves that changes this quantity contains a move through a gate. Where the gate is given by claims (whether each move is a gate is a claim) and every move that is not a gate reflects a claim: if whether each move is a gate is decided, then every sequence of moves ending at a configuration where the claim holds either starts at a configuration where it holds or contains a move through a gate; requiring this for every process without supposing that the gate is decided holds exactly where every claim has double-negation stability.

### 5.9 Absorbing region

An absorbing region is a region a law never leaves: if a configuration is in the region, its next configuration is in the region too. The absorbing regions of a law are exactly the invariants of its process. For every configuration, what it can reach from the next step on is an absorbing region; the region of configurations that return is an absorbing region; what can be had after n steps is an absorbing region. If a run enters an absorbing region, it is in it at every step afterwards.

### 5.10 Drawn into and basin

Drawn into is: a configuration is outside a region, and its run comes into the region. A basin is the configurations drawn into an absorbing region from outside it. For every law, a configuration is drawn into some absorbing region exactly where it does not return; a configuration that does not return is drawn into the absorbing region of what it can reach from the next step on. A configuration that cannot be had after n steps is drawn into the absorbing region of what can be had after n steps.

### 5.11 Attractor

An attractor is an absorbing region all of whose configurations return and into which some configuration is drawn from outside. If one family exhausts the configurations, then every run comes to configurations that return, and every configuration that does not return is drawn into the absorbing region of those that return: the region of returning configurations is an absorbing region, and those that do not return all lie in its basin. If one family exhausts the configurations and their sameness is decided, then the law brings no two configurations to confluence exactly where no configuration is drawn into anything. Where the configurations are infinite, there is a law under which a configuration is drawn into an absorbing region and there is no confluence: with successor as the law, zero is drawn into one, and no two configurations are in confluence.

### 5.12 Lock-in

Lock-in is: drawn into an absorbing region and not returning. For every law, if a configuration is outside an absorbing region and its run enters it at some step, then from then on the run is never at this configuration again. So (5.7) for every process, if a configuration is in an invariant, then from it no configuration outside the invariant can be reached; along a run, if it is in an invariant from some step, then none of its later configurations is the configuration of any step at which it was outside the invariant.

### 5.13 Possibly and necessarily drawn into

Possibly drawn into is: a configuration is outside a region, and from it some configuration in the region can be reached; necessarily drawn into is: a configuration is outside the region, and every run from it comes into the region. For every process, a configuration is necessarily drawn into some invariant exactly where it does not return; a configuration is possibly drawn into some invariant exactly where from it a configuration can be reached from which it cannot be reached. Under a law, possibly drawn into and necessarily drawn into are both drawn into. There is a process with a configuration that is possibly drawn into an invariant, is not necessarily drawn into it, and returns.

### 5.14 Juncture

A juncture, for a configuration s, is a configuration after one step from which s can still be reached and after another step from which s cannot be reached. The outcomes of the two steps of a juncture differ; a juncture is possibly drawn into. For every s that returns, if from s a configuration t can be reached and t cannot reach s, then it cannot be refuted that there is a juncture y: y can be reached from s, y goes in one step to a configuration z, and z can reach t and cannot reach s. If, for every configuration reachable from s, whether it can reach s is decided, then this juncture can be pointed out; the same holds if one family exhausts the configurations and whether a configuration can reach another in one step is decided. If for every process every juncture at which something is lost could be pointed out, then the limited principle of omniscience would hold. A configuration with many steps need not be a juncture: there is a process whose only configuration has one step for each natural number, and this configuration is not a juncture of it.

### 5.15 Keeping

Keeping, for a configuration s, is the steps of a process after which s can still be reached; the other steps of the process, after which s cannot be reached, are steps of lock-in (taking one, s cannot be reached again on this path; if this step is on a path from s, then s is possibly drawn into, 5.13). A juncture is exactly a configuration at which both keeping and lock-in have steps. Keeping keeps s: everything reachable from s through keeping can reach s through keeping. For every sub-process that keeps s, the steps it takes on paths from s are all steps of keeping: keeping is the greatest that keeps s. If s returns, then what keeping removes on paths from s is exactly the steps of lock-in at junctures. Taking only steps of lock-in, s does not return. If a process keeps s, then nothing reachable from s is a juncture for s.

### 5.16 Persistence through change

Persistence through change is: a whole is active at every step from some step on, while each of its parts ends, or none of its parts is active at two steps some number of steps apart. Let a whole be active at every step from some step on: if no part of it is active at two steps d steps apart, then afterwards no d consecutive steps can all be without some part arising; if each of its parts ends and they have a census, then it cannot be that no part arises from some step on, and it also cannot be that no part outside any given family arises from some step on. If each of its parts ends, they have a census, and from some step on no part arises, then the whole ends.

### 5.17 Passing on

Passing on is: whatever carries a pattern at the next step either already carries it at this step or has it passed to it by something that carries it at this step: a pattern reaches a new carrier only by passing. If there is passing on, then whatever begins to carry the pattern has it passed to it by something that carries it at the step before.

### 5.18 Persistence through change by passing on

If from some step on a pattern has at each step something that carries it, and no carrier carries it at two steps d steps apart, then afterwards no d successive steps can all be without a carrier that begins to carry it. Under passing on: if from some step on a pattern has at each step something that carries it, and no carrier carries it at two steps d steps apart, then from then on any d successive steps include a step at which the pattern passes to a carrier; If at one step nothing carries the pattern, then at every later step nothing carries it; If no carrier carries the pattern at two steps d steps apart, and from some step T on the pattern passes to nothing, then from T + d on nothing carries it.

### 5.19 Renewed, restored and return bound

Renewed: for every step, every dependence on this condition at that step is kept across that step. Restored: for every step, the need of every dependence on this condition at that step is met at some later step. A return bound is an upper bound on a number of steps: if every dependence is met within p steps after its step, the condition is said to be restored with return bound p. Restored with return bound zero holds exactly where no relatum depends on the condition.

### 5.20 Consumed and broken for good

Consumed: some formation depends on this condition at a step, and at every later step the level of this condition is below the need of that step. Broken for good: some dependence is broken at a step, and at every later step the level of this condition is below the need of that step. Every condition broken for good is consumed. There is a web in which one condition is consumed and no dependence on it is broken.

### 5.21 Grades of meeting

Every renewed condition is restored with return bound one; A condition restored with return bound p is likewise restored with every return bound greater than p, and is restored; A restored condition is not consumed; A condition is consumed exactly where there is a dependence whose need of its step no later step meets. There is a condition restored with return bound two, not with return bound one, and not renewed; There is a condition that is restored and has no return bound.

### 5.22 Renewing and consuming

Renewing: every condition a relatum depends on or draws from at each step is renewed; Consuming: a relatum at some step draws from a consumed condition. Every renewing relatum is not consuming, and is admitted at every step. There is a relatum that is neither renewing nor consuming.

### 5.23 Renewing and consuming belong to the run

There is a process with two runs from one configuration such that the relatum that draws from a condition is active at every step on both runs, is renewing on one run and consuming on the other, and the formation that depends on the condition is not active on the other run from the first step on. In a family where giving waits on admission of the dependent (one condition; the formation that depends on it gives it r only at steps at which it is admitted, and the relata that draw from it draw only at steps at which that formation is admitted), with positive need and a starting level not below the need: if two relata that draw from the condition each take no more than r at each step, then each of them, drawing alone, is renewing; If the two are read together as one joint drawer, and the joint taking exceeds r at each step, then the joint drawer is consuming, and from some step on neither the joint drawer nor the formation that depends on the condition is active.

### 5.24 No prefix decides

There is a process such that for every finite bound h there are two runs whose configurations and moves do not differ before h, at every step between which this condition has joint excess, every event of the relatum that draws from it is within renewal (active at its step, and every dependence on each condition it depends on or draws from is kept across that step), and one run is renewing while the other is consuming. So for this process, every reading fixed by the prefix of the first h steps that includes every renewing run must include a consuming run; The reading by taking within giving is fixed by the prefix at each step, and does not distinguish the two runs at any uptake before the bound.

### 5.25 Undermining

Undermining: a relatum draws from a condition at a step, and after the step the level of the condition is both below the need of a dependence at that step and below a need this dependence met at some step from which it has stood without interruption. Every drawing at whose step a dependence is broken is undermining; A relatum within renewal at a step does not undermine; A renewing relatum is within renewal at every step at which it is active. If a relatum undermines a condition at a step, then some formation has a bearing dependence on this condition at that step, and the events of the two at that step interact (2.14).

### 5.26 Renewing and consuming along the continuation relation

Renewing along the continuation relation: every condition that anything continuing a relatum depends on or draws from is renewed; Consuming along the continuation relation: something continuing a relatum draws from a consumed condition (what continues it: step by step, from what is active before the step to what the continuation relation reads as its continuation and is active after the step, 3.11). Undermining along the continuation relation: a relatum draws from a condition at a step, and after the step the level of the condition is both below the need of a dependence at that step and below a need that some formation this dependent formation continues along the continuation relation met at its step (at each step of the continuation relation between, the formations before and after both depend on this condition). A relatum is renewing along the continuation relation exactly where every condition it depends on or draws from at this step is renewed, and everything active at the next step that the continuation relation reads as its continuation is renewing along the continuation relation: renewing passes into each branch of a split. A relatum is consuming along the continuation relation exactly where at this step it draws from a consumed condition, or something active at the next step that the continuation relation reads as its continuation is consuming along the continuation relation: if what a merge yields is consuming, each relatum merged into it is consuming. Under a re-identification that carries its continuation relation with it, what continues a relatum does not change, and renewing, consuming and undermining along the continuation relation do not change. Reading activity by persists (3.18), if a re-identification does not change the names of what persists across a step, then for what persists at every step, renewing and consuming do not change. For a relatum active at every step and continued only by itself, renewing and consuming along the continuation relation from step zero are renewing and consuming; For what is continued only by itself, undermining along the continuation relation is undermining.

## Chapter 6

### 6.1 Admission and generative space

The generative space is the formations that the levels at a step admit (for admission see 2.1). For every step, if the levels at every condition are not lower than other levels, then they admit everything in the generative space of the other levels.

### 6.2 Includes and exceeds

Includes: one history of levels admits at every step what another history admits. Exceeds: one history admits at some step something another history does not admit. Every history of levels includes itself; If A includes B and B includes C, then A includes C; A history that includes another is not exceeded by it.

### 6.3 Widens, narrows, keeps the same, mixed

Widens: includes and exceeds; Narrows: another history widens it; Keeps the same: each includes the other; Mixed: this exceeds that, and that also exceeds this. Widening cannot be reversed and is transitive; Widening is not keeping the same, widening is not mixed, and keeping the same is not mixed.

### 6.4 Undermining and includes

At a step, if every dependence on a condition still stands across the step with its need not decreased, and a history of levels admits after the step every formation that depends on it: if some relatum undermines this condition at that step, then this history exceeds the levels of the web; If the levels of the web include this history, then no relatum undermines this condition at that step. There is a world that balances, dissipates and is dependent; one relatum depends on one condition only, this condition is renewed, fed from beyond and taking within giving, this relatum is active and admitted at every step, and at one step it undermines the condition another relatum depends on, and the other relatum is not active from the second step on.

### 6.5 A part withheld

A part withheld: the members of the part take nothing and give nothing, while the taking and giving outside the part are as before. The levels under a part withheld are the levels that, from one and the same starting level, change at each step by the taking and giving of the flow with the part withheld; Where they exist, they are unique. Under every balance, at each step and each condition: the level plus the cumulative uptake of the part equals the level under the part withheld plus the cumulative replenishment of the part.

### 6.6 Generative and degenerative

Generation is generating, as opposed to degeneration. A part is generative where the history of levels widens the history of levels with this part withheld; Degenerative: the history of levels with this part withheld widens the history of levels. For the generative space, a part being generative, degenerative, keeping the same and mixed are four that do not overlap.

### 6.7 Margin

The margin is the amount by which the level with a part withheld exceeds a need. Under every balance, a formation is admitted at a step exactly where at each of its conditions the need plus the cumulative uptake of the part is no more than the level with the part withheld plus the cumulative replenishment of the part. The balance is needed only at the conditions of this formation and before this step.

### 6.8 Closing off and opening

Closing off: the levels with a part withheld admit a formation and the levels do not admit it; Opening: the levels admit a formation and the levels with the part withheld do not admit it. Under every balance: if up to a step the cumulative uptake of the part at each condition of a formation is no more than its cumulative replenishment, then where the levels with the part withheld admit this formation, the levels admit it; so closing off needs taking beyond giving; If the cumulative replenishment is no more than the cumulative uptake, then where the levels admit this formation, the levels with the part withheld admit it; so opening needs giving beyond taking; If at each step and each condition the part gives no less than it takes, then the history of levels includes the history of levels with the part withheld, and nothing is closed off; If it gives no more than it takes, then the history of levels with the part withheld includes the history of levels, and nothing is opened; If what is given exactly equals what is taken, the two histories keep the same.

### 6.9 The bound of widening

Under every balance, the history of levels widens the history of levels with a part withheld exactly where: for every formation the levels with the part withheld admit, at each of its conditions the need plus the cumulative uptake of the part is no more than the level with the part withheld plus the cumulative replenishment of the part; and at some step there is a formation the levels with the part withheld do not admit for which, at each of its conditions, the need plus the cumulative uptake of the part is no more than the level with the part withheld plus the cumulative replenishment of the part. The balance is needed only at the conditions of each formation and before its step.

### 6.10 Novelty needs gain

Gain: the total level of a family rises across a step. For every family, if its configurations at the steps from T to T + N are pairwise different, where N is the number of configurations within the total level at T, then between T and T + N there is a step across which it gains. If a family has novelty from some step on, then gain recurs; for every bound, the total level being above it recurs.

### 6.11 Net giver

A net giver: across a step it takes part, and gives to a family more than it takes from the family. If a family gains across a step, then, counting the rest of the whole, there is a net giver: either the rest of the whole or a formation taking part. The rest of the whole is a net giver exactly where, over the conditions of the family, the sum of the amounts by which the level after the step plus the joint taking exceeds the level before the step plus the joint replenishment is more than the sum of the amounts by which the level before the step plus the joint replenishment exceeds the level after the step plus the joint taking. If the flow balances on the family across this step, the rest of the whole is not a net giver.

### 6.12 Where the new comes from

Under every gainless flow: if a family with distinct members gains across a step, then the rest of the whole is its net giver, or the family is not closed at that step; If a family has novelty from some step on, then for every family with distinct members that contains its members, it recurs that at some step either the rest of the whole is its net giver or the family is not closed; If from T on endlessly many formations are each first admitted at a step (admitted for the first time since T), each later one at a later step, each with its dependence and need unchanged and all of its conditions in one family with distinct members: then for this family it recurs that at some step either the rest of the whole is its net giver or the family is not closed. For every whole of the unfolding whose conditions all lie in one family with distinct members, under a gainless flow, if from step T on the rest of the whole is not its net giver: then after every step from T on there are two steps with one configuration, and from T on there is no novelty.

### 6.13 Renewing, consuming, arising and widening

Under every balance in which only what is active takes, and takes only from what it draws from: if the conditions the members of a part draw from are all renewed, then the history of levels includes the history of levels with the part withheld, and is not widened by it. Under every balance in which at each step and each condition the part gives no more than it takes; if a formation depends on a condition at step T, the level of this condition afterwards never reaches its need at T, and the levels with the part withheld admit this formation at some later step at which this dependence still stands with need not less than at T: then the history of levels with the part withheld widens the history of levels. Under every balance in which only what is active takes, and takes only from what it draws from, and only what is active gives: if no member of the part is active at the first step and none arises, then the history of levels and the history of levels with the part withheld keep the same.

### 6.14 Widening along a reading

With a reading that reads the formations of this world into that world: if everything the history of levels of this world admits is, as read, admitted by the history of levels of that world, this is called including along the reading; if that history admits a formation at some step that this history admits at that step under no formation read as it, this is called exceeding along the reading; where both hold, this is called widening along the reading. Where the reading reads each formation as itself, widening along the reading is widening. For every world that grows by new formations and new conditions, with the dependences and needs of the old formations unchanged and the levels of the old conditions as before: under the reading of each old formation as itself in the grown world, the grown world widens along this reading exactly where at some step it admits a new formation; and compared only on the old formations by the levels of their old conditions, it neither widens nor narrows.

### 6.15 Widening along continuation

From step T to a later step U, along a continuation relation: if everything admitted at step T has a chain of the continuation relation continuing it to something admitted at step U, this is called including along continuation; if something admitted at step U is such that nothing continued to it by a chain is admitted at step T, this is called exceeding along continuation; where both hold, this is called widening along continuation. Where each continues only itself (T not later than U), including and exceeding along continuation are includes and exceeds by name; Every re-identification that carries this continuation relation with it does not change widening along continuation; The more chains the continuation relation has, the easier including is and the harder exceeding is.

### 6.16 Continuing generation

Reading (AI, D1, D5): continuing generation is generation whose generated in turn generates: what comes to be keeps, supplements, passes on and creates the conditions of later generation and what generates; its direction is compared by widening, and what widening records does not exhaust continuing generation (6.14, 6.15).

### 6.17 Whole and region

Losing beyond a region: at a step, there is a relatum beyond the region that other levels admit and these levels do not admit. One history includes another exactly where at every step, within every region, it admits what the other history admits. At a step: what includes within a region includes within every region inside it; What loses beyond a region also loses beyond every region inside it; Nothing is lost beyond the whole of the unfolding.

### 6.18 Widening is what every weighting shares

For the events of a family, where the events both histories admit all lie in the family and admission is decided: one history widens another exactly where for every positive weighting this history counts more under the weighting than the other; For every class of orders of alternatives that contains the orders of the positive weightings and each of whose orders ranks every widening history above the history it widens: one history widens another exactly where every order of this class ranks this history above the other, whether the orders are additive or not. Over listed events: for mixed histories, some positive weighting ranks this one above, and some ranks that one above; If this includes that and every event in which it has more has weight zero, the two count equally under the weighting; With one and the same positive weight for every event, the order ranks by the number of events admitted.

## Chapter 7

### 7.1 Lumping and same by class

The value a model (1.3) gives an item is called its image. A lumping assigns each item under consideration one value, and puts together those with the same value; The value an item receives is called its class. A model is same by class for a lumping where any two items of the same class have the same image. If a model is same by class for a lumping, it is also same by class for every finer lumping: what the finer lumping puts together, this lumping puts together. For a lumping that puts everything together, a model same by class for it is exactly a model whose image is the same everywhere.

### 7.2 Law-carrying lumping

A law-carrying lumping, for a process, is a lumping under which any two configurations of the same class have outcomes of the same class under one and the same move. For every process and lumping, there is a law on the classes of the lumping that allows every step of the process through the lumping, exactly where this lumping is a law-carrying lumping for this process. That the process with classes in place of configurations is a law also holds exactly there. The process with classes in place of configurations allows every step of the process through the lumping; Everything that allows every step of the process through the lumping allows every step of the process with classes in place of configurations. For every law with exactly one move and exactly one next configuration at each configuration, a lumping is a law-carrying lumping for this law exactly where the class of the next configuration is same by class for this lumping.

### 7.3 Generalization

Generalization fixes, from the values in the data, the values of what is of the same class as the data and is not in them. Where the data are a family, sameness and difference of class are decided, and the model takes two different values: over the models same by class for this lumping, the values in the data fix the value of an item x exactly where the data contain something of the same class as x. Where sameness and difference of the items under consideration are decided and the model takes two different values: over every model, the values in the data do not fix the value of any item not in the data. If g is same by class for a lumping and has the same values as f on the data, then for x of the same class as d in the data, the value of g is the value of f exactly where f has the same value at d and at x.

### 7.4 Identity of claims

For every claim built from atoms by true, false, and, or, implies, every and some: if two readings assign to each atom claims that imply each other, then the resulting claims imply each other, with no supposition. A reading of claims that gives one and the same value to any two claims that imply each other is called same under mutual implication. Every reading from claims to claims is same under mutual implication exactly where claims that imply each other are one; That the reading by name is same under mutual implication also holds exactly there; If the reading by name is so, then every reading of claims is so. A reading built from relations keeps mutual implication without needing this: what results implies each other, and is not one.

### 7.5 Laws that commute with a model

A law commutes with a model where, at every configuration, taking its image and then advancing one step, and advancing one step and then taking its image, give the same configuration. If a model moves every configuration, then for every law that commutes with it, the two runs from a configuration and from its image are never at the same configuration at the same step; nor is there a step at which every run is at one configuration; so every law that at some step brings these two runs to one configuration does not commute with this model. If a law commutes with a model, then on a run from a configuration the model does not move, the model does not move the configuration at any step; A lumping that puts each configuration together with its image and with nothing else is a law-carrying lumping for this law.

### 7.6 Undecided

Undecided is a third value besides true and false, below true and false in what is known, which revision has not decided. For N claims, each stating a formula built from the claims and true and false by not, and, or, speaking only of one another, revised starting from all undecided: from step N on they change no more, and the configuration at step N is the least stillness of these N claims; If the first claim states true and each later claim negates the one before it, then the first N+1 claims still change from step N to the next step. If the formulas the claims state contain no term true or false, then at every step of revision every claim is undecided. If N claims speak only of one another and two-valued revision has no stillness on them, then every stillness of three-valued revision leaves a claim undecided: for a claim that negates itself, two-valued revision changes at every step and three-valued revision is undecided at every step.

## Chapter 8

### 8.1 Order of steps and interleaving

The order of steps is the sequence of takings and givings; The order of steps of a relatum is the sequence of the takings and givings that touch this relatum. An interleaving combines the orders of steps of the relata into one order of steps: in it, the takings and givings that touch each relatum follow the order of steps of that relatum.

### 8.2 Takings and givings that touch no relatum in common can exchange their order of steps

If takings and givings change nothing they do not touch, and change what they touch only according to what they touch: where two takings and givings touch no relatum in common, exchanging their order of steps leaves the same configuration after. If one family contains all the relata, then two families of takings and givings that give every relatum the same order of steps, starting from one and the same configuration, end at one and the same configuration, and each relatum has the same value after each of its takings and givings, in the same sequence; So two interleavings of the same orders of steps, starting from one and the same configuration, end at one and the same configuration.

### 8.3 When the orders of steps of the relata fix their interleaving

If takings and givings change nothing they do not touch, change what they touch only according to what they touch, and one family contains all the relata: the orders of steps of the relata fix their interleaving exactly where every taking and giving touches at least one relatum, and every two takings and givings are either the same or touch a relatum in common. Where sameness of takings and givings is decided, an assignment of an order of steps to each relatum has an interleaving combining them exactly where scheduling them in a number of steps equal to the total number of takings and givings the orders contain can be completed.

### 8.4 The world an interleaving forms

If takings and givings change nothing they do not touch, change what they touch only according to what they touch, values of relata are counted in natural numbers, sameness of relata is decided, and one family contains all the relata: in the world an interleaving forms, if the members of this family are distinct, there is balance at every step; If two adjacent takings and givings that touch no relatum in common exchange their order of steps, the levels of the two worlds differ at most at the one step between them. For the two worlds formed by two interleavings of the same orders of steps: a property of the level of a relatum holds at some step in this world exactly where it holds at some step in that world; it holds at every step in this world exactly where it holds at every step in that world. There is moreover a renumbering of steps such that what reads only the relations among the relata touched by the taking and giving of one step holds alike at this step and its next step in this world and at the renumbered step and its next step in that world; If every taking and giving of the two interleavings touches at least one relatum, this renumbering is a one-to-one renumbering of the steps within their length, with the renumbering in the other direction as its inverse. Reading the relations among relata they do not touch can differ with the interleaving: there are two relata, A and B, and two worlds formed by two interleavings of the same orders of steps, such that in one world at some step the level of A is less than that of B, and in the other world at no step.

### 8.5 What shows is only the order of steps of becoming

An idle step is a step of a reading of steps that reads again the step read before it: the reading starts from the first step, each step either reads again the step read before it or reads the next step, and every step is read. Where sameness and difference of the relata of a world are decided, read the world with a reading that inserts idle steps: if what takes part at each step is distinct, then balance, dissipation, giving only by what is active, taking only by what is active and only from what it draws from, dependent and embodied each hold of the read world exactly where they hold of the original world, and the uptake and replenishment over any stretch are as over the stretch read; The rises and falls of any amount and the number of steps at which it rises or falls are as over the stretch read; Arising recurs, ceasing recurs, and a rise or fall of the level of a relatum recurs, each exactly where it does so in the original world. If at the idle steps nothing in the world takes part and no relatum changes, and every step read gives the step that is not idle and reads it, then for the world with the idle steps removed, balance, dissipation, giving only by what is active, taking only by what is active and only from what it draws from, dependent and embodied each hold exactly where they hold of the original world; The uptake and replenishment over any stretch, the rises and falls of the total level of a family, and the number of steps at which they rise or fall, are also the same. But what each step counts differs with the unit of the reading: read with a reading in which idle steps recur, no flow is more without end; There is a flow that is more without end, and read twice at each step it is not; There is a web that a reserve starting at one carries, and read twice at each step, every reserve that carries it starts at no less than two. What a step touches is the relata touched by the taking and giving of that step. Where what is touched is given and includes its taking and giving (a relatum not touched does not take part at that step and does not change across it), then over a finite stretch, the renumberings of steps that can be reached by exchanging adjacent takings and givings that are not linked (linked: the two touch a relatum in common, or a relatum one touches depends at the start or end of its step on a relatum the other touches) are exactly those that keep the order of steps of linked takings and givings.

### 8.6 Laws of one step

The law of every step: if something is taken from a family, then there is at least one taker, and the number of takers is no more than the total taken from the family; if something is taken from or given to a family, then at that step some relatum taking part takes or gives. The form of one step is what a step shows of a family: the levels of the members before and after the step, what is taken from and given to each member, the number of takers, and whether at that step some relatum taking part takes or gives. Every form of one step is shown by some world at some step on some family (with distinct relata taking part at that step) exactly where it keeps the law of every step: the laws one step shows are exhausted by the law of every step. It is shown by a family that balances at that step exactly where, in addition, each member balances.

### 8.7 Goes on

Goes on: there is a run from a configuration: from this configuration on, at every step there is a transition its process allows, running without end.

### 8.8 Where going on is

If a configuration that returns can be reached from a configuration, then that configuration goes on. If one family contains all the configurations, then a configuration goes on exactly where there is a history from it whose number of steps is the length of the family; exactly where a configuration that returns can be reached from it.

### 8.9 Horizon

A horizon is a finite bound: two runs agree up to a horizon where their configurations are the same up to the horizon (inclusive) and their moves are the same before the horizon.

### 8.10 Situation

A situation is one of the ways by which a step is taken: counting steps by a weighting, if the weight of a step (from a configuration by a move to a configuration) is k, then this step has k situations, each fixing its own outcome.

### 8.11 Weighting is the number of situations

For every counting of steps by a weighting: with situations as moves, the process is a law; this law takes a step exactly where the weight of this step is positive. If one family contains all the moves and one all the configurations, then the sum of any reading over the histories of situations of n steps equals the sum over the histories of n steps, each counted by its weight (the product of the weights of its steps); If sameness and difference of moves and of configurations are decided and each occurs once in its family, then the number of histories of situations that take a given history is the weight of this history.

### 8.12 Sums over histories

For every assignment of weights to steps (weights of alternatives added, weights of successive steps multiplied, addition and multiplication each keeping its laws), where one family contains all the moves and one all the configurations: the sum over the histories of n steps, each counted by its weight (the weights of its steps multiplied in order, multiplied by what the final configuration reads), is exactly what is computed step by step: from a configuration, multiply the weight of each transition of one step by what follows it and add, computing n steps. With a reading that sorts the configurations into classes, each class having one configuration as its representative: for every n, what results after n steps is same by class for every reading fixed by class, exactly where what results after one step is same by class for every reading fixed by class.

### 8.13 Rule switching

Rule switching is change by a rule that reads the configuration it is in: in a run of configuration and rule, the configuration changes at each step according to the rule of that step, and the rule changes only at reading steps, according to the configuration and rule of that step, and at the other steps is as before. A reading step is a step at which the rule reads the configuration. The fast layer is the layer in which the configuration changes at each step according to the rule.

### 8.14 The rule meets differences of configuration only at reading steps

For every run of configuration and rule: if there is no reading step before step r, then up to step r (inclusive), two runs starting from one and the same rule have the same rule at every step, whatever their configurations; At the step after a reading step, the rule is fixed by the configuration and rule of that step. If the rule never reads, then the rule is at every step as at first, and no difference of configuration reaches the rule; A configuration that cannot be had at step n under the law that holds this rule fixed is, from step n on, never again a configuration of a run starting from this rule; If one family contains all the configurations and the law that holds this rule fixed has confluence, then from the step equal to the length of the family on, at every step, not every configuration is the configuration at that step of some run starting from this rule. There is a run of configuration and rule in which, for two fixed rules, the law that holds each one fixed never reaches a certain configuration from the first step on; and for the run in which the rule reads the configuration at each step and changes, reaching these two configurations recurs.

### 8.15 Hexagram, hexagram line, line value, place and halves

A hexagram line is a place of a hexagram with its value; Line values are the two values of a hexagram line: firm, an undivided line; yielding, a divided line. A hexagram is a configuration of six hexagram lines from the bottom up, sixty-four in all. A place is where a hexagram line stands, six in all from the first to the top. The halves are the two halves of a hexagram: the lower half from the first to the third, the upper half from the fourth to the top; Each place is one height of a half, and the heights are low, middle and high. Under the law of the mutual hexagram, after two steps, the hexagrams whose third and fourth lines are both firm reach Qian, those whose third and fourth lines are both yielding reach Kun, and those whose third and fourth lines differ are drawn into the attractor in which Jiji and Weiji alternate; Among the sixty-four hexagrams, these number sixteen, sixteen and thirty-two.

### 8.16 In phase, central place, line correspondence, adjacency, rising seam and riding seam

The parity of places: the first, third and fifth are odd; the second, fourth and top are even. In phase: the value of a hexagram line agrees with the parity of its place: firm in an odd place, yielding in an even place. The central places are the second and the fifth, the middle height of the halves. Line correspondence: the two hexagram lines at the same height of the halves have different values. A seam is between two adjacent places, five in all. Adjacency: the two hexagram lines of a seam have different values; Yielding below and firm above is a rising seam; firm below and yielding above is a riding seam.

### 8.17 Relations of place are all read in context

Every relation of place, read site by site (place, height, seam), is read in context: what the sites show has gluing into one reading of the whole hexagram exactly where what each site shows agrees. Taking the halves as two contexts, each showing the hexagram lines of its three heights: the two halves have gluing exactly where no height has line correspondence; Tai has a height with line correspondence, so for any process, no context-free frame agrees with what the halves show, while a frame that carries contexts agrees with it; The in-phase readings of the places have gluing exactly at Jiji and Weiji; The line correspondences of the heights have gluing exactly where all three heights have line correspondence or none has; The adjacencies of the seams have gluing exactly at Qian, Kun, Jiji and Weiji.

### 8.18 Places in the waxing-waning ring

At each step of the waxing-waning ring, the lower five hexagram lines each go up one place, and the top line leaves and, with its line value reversed, becomes the first line; A line that goes up one place must reverse whether it is in phase, and the line that becomes the first line is in phase or not as before; so the number of lines in phase at the next step differs in parity from that at this step. The line correspondences of the three heights at the next step are determined by the line correspondences of the three heights at this step; the number of lines in phase at the next step is not determined by the number of lines in phase at this step.

### 8.19 Line correspondence is fixed by in phase

For every hexagram: the two hexagram lines of a height have line correspondence exactly where both are in phase or both are not in phase; If none of the six hexagram lines is in phase, then all three heights have line correspondence. From the bottom up, the number of rising seams plus the firmness of the first line equals the number of riding seams plus the firmness of the top line (firm counting one, yielding zero). Taking its complement, every place reverses whether it is in phase, the line correspondence of every height and the adjacency of every seam stay as before, and rising and riding seams exchange; Taking its turning over, being in phase reverses at the opposite place, line correspondence is kept at the opposite height, and rising and riding seams exchange at the opposite seam. The waxing-waning ring commutes with the complement; so the two runs of the waxing-waning ring from a hexagram and from its complement are at no step the same hexagram.

### 8.20 Fixed phase and holds its place

Fixed phase: only the second to fifth places have a fixed parity; the first and top have none. Holds its place: a hexagram line is in phase at a place that has fixed phase.

### 8.21 The first and top have no place

If two hexagram lines have different values at one place, then whatever the parity of this place, one of the two lines is in phase. The top line of Xu is yielding and the top line of Qian is firm, yet the Xiao Xiang of Xu says it does not hold its place, and the Wenyan of Qian says it has no place; so no parity of the top place can agree with both statements. The sentences of the Xiao Xiang that speak of place are collected into a family (the top six of Xu not among them), and all lie in the second to fifth places; Read by fixed phase, the sentences of the family and the two statements on the top six of Xu and the top nine of Qian all hold. The in-phase readings of the second to fifth places have gluing exactly where their four hexagram lines all hold their place or none does, eight hexagrams in all. Reversing the line value of the first or the top line leaves whether each of the second to fifth is in phase as before, while the line correspondence of its height and the adjacency of its seam reverse. After one step of the waxing-waning ring, whether the second is in phase is fixed by the first line, and the first has no fixed phase; so whether the second to fifth are in phase at the next step is not determined by whether the second to fifth are in phase at this step.

### 8.22 Sole line

Sole line: a hexagram line whose value differs from that of each of the other five lines.

### 8.23 Laws of the sole line

A hexagram line is a sole line exactly where it is the only line in the hexagram with its value: the line is firm and the hexagram has only one firm line, or the line is yielding and the hexagram has five firm lines; A hexagram has a sole line exactly where it has one firm line or five firm lines; A hexagram has at most one sole line; A hexagram line is a sole line exactly where reversing its line value makes all six lines the same, twelve hexagrams in all. If a hexagram has a sole line, then after one step of the waxing-waning ring it has none; If the sole line is at the top, at the next step it leaves and all six lines are the same, and at the step after that the first line is a sole line.

### 8.24 What the Xiang and the Tuan say of place

The sentences of the Xiao Xiang that speak explicitly of place are collected into a family (the top six of Xu not among them), and all agree with whether their line is in phase; The sentences that speak of central and correct are collected into a family (the six in the fifth place of Gen not among them), and all are of lines in a central place and in phase; The sentences that speak of the yielding riding the firm are collected into a family, and in all of them the seam below their line is a riding seam. The hexagrams of which the Tuan says "the firm is central and responded to" are collected into a family, and all have a firm line in a central place and line correspondence at the middle height.

### 8.25 The sequence of the Xugua as a run of a law

For every law under which, in a family, the outcome of each member other than the last is the member after it, and which commutes with a model that is its own inverse (the image of its image is the item itself): if in the family a member is followed by its image and the image by t, then t is this member. The sequence of the Xugua starts from Qian and has each of the sixty-four hexagrams once, in order; Every law whose run from Qian follows this sequence commutes with none of the three models complement, turning over, and complement of the turning over: in the sequence Qian is followed by Kun (Kun is the complement of Qian, and also the complement of its turning over) and Kun by Zhun, and Zhun is followed by Meng (Meng is the turning over of Zhun) and Meng by Xu, and neither returns to the hexagram before it. There is a law whose run from Qian follows this sequence.

## Chapter 9

### 9.1 Couples into

Couples into: a condition goes into a formation: if a formation depends on a condition at some step, then this condition couples into it by the threshold of its need; or, given separately, it couples into it by its level; this is given separately and does not change with the step. Coupling has a direction, from the condition into the formation.

### 9.2 Selection, selector and selection through couplings

Selection is any claim about histories of levels: what remains, what is rewarded, what leaves more after it. Two histories of levels are alike through the couplings of a formation at a step where the levels of this step both admit it or both do not admit it, and every condition that couples into it by its level has the same level in both. Selection through couplings: any two histories alike through the couplings of the selector up to some step are treated the same by the selection. The selector is the formation to which the couplings that a selection goes through belong.

### 9.3 Own course through couplings

Reading (AI, D45): own course through couplings is the further course of a formation itself, fixed by the lumping that its couplings make.

### 9.4 What coupling brings about

Where sameness and difference of conditions are decided: if a condition couples into a formation only by threshold, the other conditions coupling into it have the same levels at a step, and the two levels of this condition at this step both meet its need or both do not, then the two histories are alike through its couplings at this step. If what couples in by level is enlarged, two histories alike up to some step through the enlarged couplings are also alike through the couplings before enlargement.

### 9.5 Coupling read early

Coupling read early: a condition couples into a formation by its level, and a difference in its level is separated by the couplings of the formation at that very step. Wherever a condition couples into a formation by its level, if two histories of levels differ in its level at some step, then the two histories are not alike through the couplings of the formation at that step.

### 9.6 Reading out a feature

A feature assigns each configuration one value. For every reading of a feature through a lumping, what is read is single-valued exactly where the feature is same by class for its lumping. For every family of configurations, with some value given: there is a reading that reads only the class and gives the feature of each member, exactly where the feature is same by class on the family; If the lumping puts together two members of the family with different features, there is no such reading.

### 9.7 Observation

Upstream of c are the conditions from which a chain of couplings leads to c; Downstream of c are the conditions to which a chain of couplings leads from c (the chain may have length zero). Observation is a route of readings starting from what is observed: a route of length zero is direct witness, the others are received by passing on. For every law that reads, at each condition, the levels it marks, all the marked conditions lying in one family; if two flows both balance, the formations taking part are the same, the moves of the part are the same, the formations outside the part all follow this law, and at the start only the level of one condition differs: then at each step, for every condition not downstream of this condition (counting by the routes of reading formed by this step), the levels of the two flows are the same.

### 9.8 How routes form

The routes of reading formed by the next step are exactly the routes formed by this step together with those extended by a coupling at this step. Every route newly formed by the next step goes through a coupling at this step. An example: from some step on, a formation adds at each step the level of one condition to another condition (the recorded one), and at each step at which the recorded one is not less than a certain number, takes one from the former; at this step, the route from the former to the recorded one forms; if two flows differ only in the level of the former, then up to this step the recorded ones are the same, and across this step the recorded ones come to differ by the gap of the former.

### 9.9 Reached by in time

Reached by in time: at some step within the time limit, some relatum the source can reach couples into what reads at that step. What the source can reach is formed only by the following three: a relatum already reached is still reached at the next step; if the source touches a relatum at a step, the relatum is reached at the next step; if a relatum is already reached at some step and at that step couples into a formation, and this formation at that step or some later step touches a relatum, that relatum is reached at the next step.

### 9.10 Not reached, the answers are the same

For every two histories: their starting levels are the same; before the time limit there is balance at every step, and what takes part is the same; apart from the source, every formation before the time limit takes and gives the same wherever the two histories are alike through its couplings up to that step; the answer is read only through the couplings of what reads up to the time limit. Then every relatum not yet reached by the source at a step within the time limit has the same level at that step; if the source has not reached what reads by the time limit, the two histories are alike through the couplings of what reads up to the time limit, and the two answers are the same. So if the two answers differ, then reached by in time cannot be refuted; if reached by in time is decided, then it holds.

### 9.11 Sensitive

Sensitive: the taking and giving of a formation at some step is not fixed by the levels of the other conditions up to that step alone; the formation is then called sensitive to this condition. Where sameness and difference of conditions are decided: for every law of taking and giving under which the conditions read at each step, for each formation and each history, all lie in one family, for each formation outside the part, if two histories agree up to some step on admission at every step and on the levels of the conditions it is sensitive to, then the law gives the same taking and giving at this step; For every relation of coupling by level that, put in place of sensitivity, keeps the previous sentence true, that each condition a formation outside the part is sensitive to couples into this formation cannot be refuted. The weak limited principle of omniscience holds exactly where: for every run of a process, what is read step by step along it as holding or not either fails at every step, or it is not the case that it fails at every step. With conditions numbered by natural numbers: there are a law of taking and giving that reads only what is already settled and a formation such that two histories agree up to some step on the conditions this formation is sensitive to while the taking and giving the law gives this formation at this step still differ, exactly where there is a model that fixes, for every step-by-step sequence of holding or not, whether it fails at every step; If there is such a model, then the weak limited principle of omniscience holds.

### 9.12 Testing

Testing: if no history of levels that satisfies a claim is alike with what holds through the couplings of a formation up to some step, then this claim is excluded for this formation at this step. A claim is excluded only through differences that couple in: if a history satisfying this claim is alike with what holds through its couplings up to this step, then this claim is not excluded here. A claim that what holds satisfies is not excluded; once excluded, it is excluded at every later step; If what couples in by level is enlarged, what is excluded is still excluded.

### 9.13 Laws of selection through couplings

Every selection through the couplings of a formation up to some step selects two histories alike exactly where the two histories are alike through its couplings up to this step; If two histories are not alike through its couplings up to this step, then some selection through its couplings holds of this one and not of that one. The admission of this formation at this step and at any step before it is a selection through its couplings up to this step. A selection through the couplings of a selector is excluded at the selector under a history exactly where it does not hold of this history. If what couples in by level is enlarged, a selection through couplings is still through couplings. Where couplings are read as values, two histories are alike through its couplings up to some step exactly where the prefixes of its own course up to this step are the same; a selection through its couplings is exactly a selection by this prefix; If under the two histories its own course has no more than N and N′ configurations respectively, then two histories alike through its couplings before step N + N′ − 1 are alike at every step.

### 9.14 The bound of testing

Where sameness and difference of conditions are decided: without admitted histories, a finite prefix does not exclude what comes after: at any step, the two claims "some condition eventually reaches zero" and "after this step it is above zero at every step" are not excluded for any formation under any relation of coupling by level. Being excluded within the admitted histories is exactly the exclusion of the claim "lies in the admitted histories and satisfies this claim". An example: the admitted histories do not contain what holds, a claim that what holds satisfies is excluded at the first step, and what couples in excludes these admitted histories at the next step. Taking the histories of levels of a flow under balance as the admitted histories, with what holds among them, and a condition coupling into a formation by its level, the false claim "this condition eventually reaches zero" is excluded at the first step.

### 9.15 Testing lies in relations

Testing is relative to the formation. An example: a claim is excluded at no step for one formation, and is excluded at the third step for another formation. An example: a claim is not excluded for either of two formations, and is excluded when tested by the couplings of the two together.

### 9.16 Judgment process

A judgment process ends, at the configuration judged, with an answer that can be allowed. An answer is a common answer of the judgment process exactly where it can be allowed at every configuration in doubt; If what is in doubt narrows, a common answer is still a common answer. For a judgment process through the couplings of a formation, taking as what is in doubt the histories alike with what holds through its couplings, its common answer is exactly an answer that can be allowed at every one of these histories.

### 9.17 The scope of knowing

The scope of knowing is what an inquiry tree, actually executed from the configurations in doubt, reaches. Everything in the scope of knowing is reached from a configuration in doubt by an actual path of the process. An inquiry tree whose questions can all be allowed, whose answers are all common answers, and which aborts only when what is in doubt is empty, meets the target throughout its scope of knowing; If what this inquiry tree has in doubt contains a configuration, then its scope of knowing contains a configuration that meets the target.

### 9.18 Prefix

A prefix (5.6) fixes the outcome of a move at a configuration as a certain configuration where every law that allows each transition of this run before this step sends this configuration by this move to that configuration. If a run has taken a move at a configuration before this step, the prefix fixes its outcome. For every process that is a law, where there are two different configurations: if a run has not taken a move at a configuration before this step, the prefix does not fix its outcome; For a run of kept history, at every configuration it passes through, the prefix fixes only the outcomes of the moves it took.

### 9.19 The counterfactual is its history

A counterfactual is the history produced when the move of a part differs from the move it took and the rest follow one and the same law. Where the rest follow a law of taking and giving that reads only what is already settled: if two flows both balance, what takes part is the same, the moves of the part are the same and the starting levels are the same, then the levels and every taking and giving of the two flows at each step are the same. For every law of taking and giving that reads only what is already settled, the flow it produces balances on the levels it produces exactly where its history can be run: at no step is more taken from a condition than its level plus what is given to it. If the moves of the part also follow a law of taking and giving that reads only what is already settled, and the history the two laws produce together can be run: then for every flow under balance in which what takes part is the same as here, the moves of the part are the same as here, the rest follow the former law and the starting levels are the same as here, its levels and takings and givings at each step are the levels and takings and givings of this history; The same holds where every formation follows a law and the history can be run. So the counterfactual of a move is the history this move produces. For every law and a run of it: the law has a step from a configuration by a move beyond the law shown by this run exactly where the law has a step from this configuration by this move and the run never took this move at this configuration. With the moves of the part as inputs and the rest following a law of taking and giving, the history of a run is a consistent history, and the part has a step by a move at a configuration beyond what this history shows exactly where this run never took this move at this configuration: what the law adds to its history is exactly its counterfactuals.

### 9.20 Experiment

An experiment changes its own move where the configuration returns. If a run at some step returns to the configuration of an earlier step and takes a move, then from the next step on, the prefix fixes the outcome of this move at this configuration. For every process that is a law, where there are two different configurations: if the configurations of a run have no return, then at every configuration it passes through, the prefix does not fix the outcome of any move other than the one it took. If the classes of the configurations of a run all lie in one family, then after every step there are two steps with the same class.

### 9.21 Control

Control: every step of a process through a lumping is a step of one process: the given control says that what the lumping puts together is irrelevant to the change. If every step of a process through a lumping is a step of a law, the outcome of a move at a class fixed by the prefix through this lumping is the class of the outcome of this move at every configuration of this class, whether or not the run passes through it. An example: a hidden factor that the lumping puts together changes at every step, and the move changes nothing: through this lumping the prefix fixes two moves that differ nowhere to two outcomes; If the move changes along with the hidden factor the lumping puts together, then the wrong law "the move fixes its outcome" allows at every step the steps read through this lumping, and the prefix never excludes it; If the move is changed against the hidden factor the lumping puts together, then by the fifth step no law allows the steps it reads.

### 9.22 Retrodiction

A record is the note of what occurs in one occasion; A dated record notes what was asked and what was answered on one day. Retrodiction reads, from later dated records, the contents of an earlier package. Every history that holds agrees with what its own records answered. Reading the contents of an earlier package: where sameness and difference of answers and contents are decided, for a region of histories, every history that agrees with what each record answered and gives the same package as an admitted hidden source gives the contents that hold, exactly where every history of this region that gives the same package as an admitted hidden source but different contents has a dated record on which its answer differs from what holds. If the records at the two ends show a change, then for each day between, there is a course that has already changed at it and a course that has not yet changed at it, each with only one change.

### 9.23 Adheres and refutes

A run adheres to a reading: for every finite stretch of it, some run of this reading agrees with it up to this stretch. A run adheres to a reading exactly where every closed class of histories that contains the runs of this reading contains it. A reading can be refuted where every run not in it has a finite stretch such that every run agreeing with it up to this stretch is not in it. For a reading that can be refuted, that every run adhering to it lies within the reading cannot be refuted; For every process, every reading that can be refuted contains the runs that adhere to it, exactly where double-negation stability holds for every claim. For the process with one configuration and one move, for every step-by-step sequence of holding or not, take the history of all the stretches before the step at which it first holds: for every such sequence, this history either has a latest stretch or has stretches beyond every horizon, exactly where the limited principle of omniscience holds. A reading is called dense where for every finite stretch some run of the reading agrees with it up to this stretch; There is something that for every run and every horizon puts down a reading, what it puts down fixed only by the prefix up to this horizon, every reading it puts down lying within one reading and containing a run that agrees with this run up to this horizon, exactly where this reading is dense.

### 9.24 Verification

Verification: a run has a stretch such that every run agreeing with it up to this stretch lies within a reading. Where every run within a reading has such a stretch, the reading is called verifiable; A reading is verifiable exactly where each of its runs is verified within it. A run lies within a reading exactly where it adheres to this reading and, if it adheres, lies within it; No finite stretch can refute "if it adheres, it lies within it". Asked of every process: if the complement of every verifiable reading can be refuted, then Markov's principle holds; and Markov's principle holds exactly where: for every run of a process with each step marked as holding or not, the mark of each step fixed only by the prefix up to this step, every run that is not marked as not holding at every step has a step such that every run agreeing with it up to this step is not marked as not holding at every step.

### 9.25 Verification in the limit

A method answers "yes" or "no" at each horizon of each run. A method verifies in the limit a reading where this reading holds exactly on the runs on which the method from some step on always answers "yes"; A method refutes a reading in the limit where this reading holds exactly on the runs on which a "yes" of the method recurs. Where sameness and difference of configurations are decided, the method "nothing changed at the last step" verifies in the limit "the configuration of the run changes no more from some step on". For a process on two configurations that allows every transition, "the configuration of the run changes no more from some step on" can be neither verified nor refuted; If Markov's principle holds, no method fixed by prefixes can refute it in the limit. Identification in the limit is tracking something that does not change with the horizon.

### 9.26 Cross-checking

Cross-checking is testing by checking fallible witnesses against one another. For every two candidates that differ in their answer, no record the witnesses report is admitted by both, exactly where their envelopes are apart: for every fault set of this one and every fault set of that one, some witness is left outside both. If a candidate that admits all witnesses being faulty is in a run, it stays there forever, and after it no certificate can be established. Listing the family of witnesses twice changes no step and no certificate.

### 9.27 Silence

Silence: giving no value where the value cannot be determined. Where every value a reading gives on a region is the value of the feature, the reading is said to accord on the region; Where it gives the value of the feature at every configuration of the region, it is said to hit at every configuration of the region. What keeps silence everywhere accords on the region; If the region has a configuration, what keeps silence everywhere does not hit at every configuration of the region. A reading that accords on the region must keep silence wherever the lumping puts together two configurations of the region with different features. A reading that hits at every configuration of the region requires the feature to be same by class on the region; If for each value of the lumping on the region a configuration of the region giving this value is given, then a reading that hits at every configuration of the region exists exactly where the feature is same by class on the region.

### 9.28 A reading does not exhaust what it reads

For every family of readings indexed by what is read, if there is a model that moves every value, then there is a reading that no reading of the family expresses. Claims indexed by what is read cannot express every kind of claim; In a frame whose claims are its own configurations, not every kind of claim about configurations is what some configuration holds. Where sameness and difference of values are decided and what is read and the values are both nonempty: there is a family of readings indexed by what is read that expresses every reading by comparison for equality, exactly where the values are of only one kind. For readings indexed by what is read that supply step by step what they lack, each step keeping what the step before expressed and expressing what the step before lacked: if the model used moves every value, then each step lacks its own lack, and a later step must express what an earlier step did not; If the relation comparing the values is moreover symmetric and transitive, then no finitely many readings can have at every step one of them that expresses what this step lacks.

### 9.29 Extrapolation and accords

Extrapolation gives a value from the prefix, or keeps silence. Hits: it gives a value, and it is the value that comes; Misses: it gives a value, and what comes differs; Accords: at no step a miss. Where sameness and difference of values are decided, a value given that is not a miss is the value that comes: what accords at each step either keeps silence or hits.

### 9.30 The prefix does not fix what comes, and the diagonal course

A lasso: a course that from some step on returns every fixed number of steps. For every course and every step, where there are two values, there are two courses with the same prefix as it that take one value each at this step, and both courses are lassos; It is not so that a value given from this prefix misses on neither course; Where sameness and difference of values are decided, it misses on one of them. A diagonal course is a course on which every value an extrapolation gives misses: if there is a model that moves every value, then every value any extrapolation gives on its diagonal course misses, and there is no step from which it hits at every step; The diagonal course is the course through a model of the trajectory of a law whose configurations contain the whole prefix, and no family contains all its configurations.

### 9.31 Extrapolation by elimination

Extrapolation by elimination uses candidates in order, moving to the next when the current one misses, and the value it gives is the value the current one gives. Where sameness and difference of values are decided: the position of the current candidate in the order does not decrease; Extrapolation by elimination does not pass beyond any candidate that accords with the course; If some candidate accords with the course, missing does not recur; Every candidate passed over has missed at some step of the prefix.

### 9.32 Lasso

For every law all the configurations of whose trajectory lie in one family, the course through any lumping is a lasso, and its start step plus the number of steps of its return is no more than the number of members of the family. Where sameness and difference of values are decided, on the trajectory of this law, extrapolation by elimination over lasso candidates: its misses are fewer than the triangular number of the number of members of the family; from the step equal to the number of members of the family on, it gives a value at every step; missing does not recur; that from some step on it hits at every step cannot be refuted; If the number of members of the family is N and its triangular number is T, then from step N + (N + N − 1)·T on it hits at every step. If extrapolation by elimination over lasso candidates hits at every step from some step on, then the course is a lasso; If there is a model that moves every value, then its diagonal course is not a lasso.

### 9.33 Bounded, the prefix fixes the run

For every two courses, one with no more than N kinds of configuration and the other with no more than N′ kinds, if they are the same before step N + N′ − 1, then they are the same everywhere: the prefix up to there fixes them. This length is exact: where there are two values, for any bounds there are two courses, each with configurations within its bound, the same before step N + N′ − 2 and different at this step. Where sameness and difference of values are decided, on a course with no more than N kinds of configuration, a lasso candidate within the bound that has no miss before step N + N − 1 never misses. Where sameness and difference of values are decided, extrapolation that is given no bound and uses the least bound hits at every step from step N + N − 1 on, on every course with no more than N kinds of configuration; Where there are two values, no extrapolation hits at step M + M + 2 on every course with no more than M + 2 kinds of configuration. Under a law, where the configurations of a family form an absorbing region of this law, two configurations of the family have the same course through a lumping exactly where their courses are the same before the step equal to the number of members of the family minus one; Where one family contains all the configurations, this also holds exactly where, from the two configurations themselves, every string of moves can be run alike and the claims that can hold after running are the same.

### 9.34 Training

Training is selection through the data: for every amount computed from the values in the data (two functions the same on the data have the same amount), the selection made from it is the same for two functions the same on the data. For every region of functions, any two functions in it that are the same on the data have the same value at an input exactly where the data fix the value at this input on this region; If the region is free at an input outside the data, then every selection through the data is still as free there as the region.

### 9.35 Learnable

Learnable: for a feature through a lumping, there is an extrapolation that gives values from the prefix through this lumping and, on the trajectory of every configuration, hits at every step from some step on. Where sameness and difference of classes are decided, in a world whose configurations one family contains: a feature is learnable through a lumping exactly where for any two configurations with the same course through this lumping, their features are the same from some step on; also exactly where there is a guess fixed only by the prefix through the lumping that tracks this feature in the limit. Every feature same by class is learnable; Under a law that leaves every configuration unchanged, the learnable features are exactly those same by class. If two configurations with the same course through the lumping have features that differ recurrently, then no extrapolation hits at every step from some step on, on both trajectories. An example: a world of one configuration and one class value, in which each of two features has an extrapolation that hits it at every step from some step on, and no extrapolation does so for both.

### 9.36 Runs part

Runs part: the classes of two runs are the same before some step and differ at this step. Wherever runs part, no extrapolation hits on both runs at this step. For a process whose moves and configurations each have a family containing all of them, where whether a step is allowed is decided and sameness and difference of classes are decided: the extrapolation built from this process hits at some step on every run from a configuration exactly where no two runs from this configuration part at this step. Where there are two values, after every prefix, in a process in which every configuration can go to every configuration, there are two runs with this prefix that part here.

### 9.37 Typicality

Typicality: the histories that are the majority by counting show their weighting. For two values with natural-number weightings p and q, if each history of n steps counts its squared deviation by its weighting, the sum is exactly n·p·q·(p + q)^n; The sum of the weightings of the histories whose squared deviation is not less than d, multiplied by d, is no more than this number. For every u not less than v, the sum of the weightings of the histories with at least k ones, multiplied by u^k·v^n, is no more than (p·u + q·v)^n·v^k. With situations as moves, the number of histories of situations of n steps whose history has a squared deviation not less than d, multiplied by d, is also no more than n·p·q·(p + q)^n.

## Chapter 10

### 10.1 Name

A name (1.20) is in three places: the name of a relatum, by which the world labels its relata; the name of a configuration, the value a reading gives a configuration (the earlier segment of the course of a configuration through a lumping is one kind of it, 10.10); the name of a sense entry, what a code assigns. A code assigns names to sense entries; A sense entry is one meaning a name can refer to; Hearing: a hearer, for a sense entry, takes the name of the speaker according to whether it follows or not; A record (9.22), for a name, notes whether the name occurs in it and which sense entries it offers.

### 10.2 Names have no fixed fit

Under every re-identification, whether each condition is renewed, consumed or broken for good does not change. Names have no fixed fit: names carry no relation: under every renaming, the renewing, consuming and undermining of a formation, the forming and dissolving of its dependences, its arising, and the web being unceasing do not change; Replacing the names of a reading or a code by a renaming that merges nothing, whether the reading carries a law and whether the code assigns one name to two sense entries (10.7) do not change. There is a web with a re-identification under which the relations at every step are the same, while renewing, undermining, forming and unceasing all change, and after the re-identification nothing is renewing and two are consuming.

### 10.3 Description that makes sense

The law of descriptions that make sense (1.23): every two descriptions that make sense put together the same things. Naming configurations by themselves is a description that makes sense exactly where alike configurations are in fact one. Where a law is shown through a lumping, if what a reading puts together shows the same, this reading carries the law, and this reading puts together every two configurations that from themselves on show the same at every step, then this reading is a description that makes sense.

### 10.4 Proper name and unrestricted name

A proper name: within one step a name belongs to one relatum only. An unrestricted name is a name that puts together everything read as one. Under every re-identification, the new names at each step are proper names. Every move is same by class for the lumping that names configurations by themselves. The unrestricted name carries a law for every process; Where a law is shown through a lumping, the unrestricted name is a description that makes sense exactly where every two configurations from themselves on show the same at every step.

### 10.5 Cross-situational standing

Cross-situational standing: every record in which a name occurs offers the sense entry. A sense entry lacks cross-situational standing for a name exactly where some record in which this name occurs does not offer it.

### 10.6 Resolves

Resolves: in a family of sense entries, only one sense entry is left that still has cross-situational standing for a name. For every family of sense entries with distinct members, where sameness and difference of sense entries are decided: a name resolves to a sense entry exactly where this sense entry is in the family, every record in which this name occurs offers it, and each other sense entry of the family has a record in which this name occurs that does not offer it. Later records only reduce the members of the family that still have standing; those removed do not return. If what is meant is in the family and every record in which this name occurs offers it, then the one member of the family that still has standing is what is meant.

### 10.7 Tells apart and decodes

Tells apart: a code does not assign one name to two sense entries. Decodes: the name the code of what reads assigns to a sense entry is exactly the name heard. For every code of what reads that tells apart: the name the speaker assigns to some sense entry is read as this sense entry and only this exactly where the two codes give this sense entry the same name; Where what reads assigns the name of the speaker to another sense entry, it decodes it as the other sense entry and not as this one. A code decodes its own names exactly where it tells apart.

### 10.8 Reading another name alongside

What is same by class on a region for the lumping of one name, reading another name alongside, is also same by class on this region for the lumping of the two names read together.

### 10.9 Code acquisition

Code acquisition is obtaining a code by reading what is asked. For formulas built from two atoms by joining and doubling: for codes in which the values of the two atoms differ, the code read out from what is asked of the two atoms and of one join is the code itself, with the same value on every formula, with no limit of depth; For codes in which the values of the two atoms differ, reading only the values of the two atoms, the order of joining is not same by class for its lumping, so no reading obtains its order for every one of these codes.

### 10.10 Prefix names and the values they carry

A prefix name takes the earlier segment of the course of a configuration through a lumping as the name of the configuration. For every law whose configurations one family of N members contains, where sameness and difference of classes are decided: a feature is learnable through this lumping exactly where there is a family of no more than N members, each member a prefix name (of length N − 1) with the value it carries, such that extrapolation by this family hits, on the trajectory of every configuration, at every step from some step on. For every extrapolation by a family that hits at every step from some step on, on the trajectory of a configuration, from this step on every value the feature takes is the value carried by some member of the family.

### 10.11 Shared code

A shared code is a code formed among formations by hearing. No hearing coins a name: after hearing, the name of each formation for each sense entry is either its old name or the name of the speaker. If the formations of a region have the same name for a sense entry, and in every hearing on this sense entry in which the hearer is within the region the speaker is also within the region, their sameness does not change. If all formations have the same name for a sense entry, then afterwards, under every hearing and every following or not, the name of this sense entry does not change.

### 10.12 The order fixes what forms

Where every hearing follows: the name each formation obtains for a sense entry is the name, at the starting point, of its provenance; Where there are two different names, an order of hearing brings the formations to the same name for this sense entry from every starting point exactly where it brings them to the same provenance for this sense entry; Where one family contains all the formations and there are formations, the names an order can make shared are exactly the names already in use at the starting point.

### 10.13 Same names need broken symmetry

For every law of codes unchanged by the exchange of the formations it exchanges and by the renaming of the names it changes, where this renaming moves every name for a sense entry: from a starting point symmetric under both, the exchanged formations never have the same name for this sense entry. There are two formations for which one that all follow, a preferred name, and an order of hearing each bring them to the same name in one step; The one that all follow and the order of hearing break the exchange of formations; the preferred name breaks the renaming.

### 10.14 Same names and lost distinctions

For every hearing that is followed, a code of the hearer that told apart before still tells apart after, exactly where the name taken is not one the hearer has already assigned to another sense entry. There are two codes, each telling apart two sense entries; one hears the name of the other for one sense entry and follows it, and so assigns one name to two sense entries: sameness of names formed sense entry by sense entry can merge sense entries.

### 10.15 Imposed code

An imposed code is a code put on the formations. Under every imposed code, the formations have the same name for each sense entry; The formations decode one another on every sense entry (decoding it as this and only this) exactly where the code put on them tells apart; Each formation loses exactly what its original code told apart and the code put on it merges; one whose code is the code put on it loses nothing; Afterwards no hearing and no following or not changes this. A distinction merged: if the code is put on the formations of a region, and formations outside the region also hold the names put on, it never returns; Where the code put on merges two sense entries, if a formation holding the name put on for one of them hears, for the other, a name held that is not the one put on and follows it, it tells these two sense entries apart again.

### 10.16 Readings written back

Each cohort reads the records of the cohort before: if they resolve, then the records of this cohort are a single record in which this name occurs and which offers only the sense entry resolved to; if they do not resolve, they are passed on as they are. For every family of sense entries with distinct members, where sameness and difference of sense entries are decided, if the records of the cohort before resolve to a sense entry: from the next cohort on the records change no more, and every cohort resolves to this sense entry. Two families of records that resolve to the same sense entry become one at the next cohort, and afterwards every reading gives them the same value. Records that keep the records of the earlier cohort and read the later records together with them only resolve to the original sense entry or do not resolve; Where records only grow, what they resolve to can be lost but not replaced.

## Chapter 11

### 11.1 Responds to

Responds to: the taking and giving of a formation differs with the level of a condition: there are two histories, the same except for the level of some condition at some step, and the law of taking and giving makes the gap between the takings and givings of this formation at a condition across a step positive. A law of taking and giving reads through couplings where, for every formation outside the part, if two histories are alike through its couplings at every step up to some step, then the taking and giving of this law for this formation across this step do not differ.

### 11.2 Coupling bounds response and does not fix it

Where for each formation, each step and each history, whether it is alike through couplings with a history is decided, and a formation separates these two histories through its couplings up to some step: then for any condition there is a law of taking and giving that reads through the couplings of all formations under which the uptake of this formation at this condition across this step differs under the two histories; There is also a law of taking and giving that reads through the couplings of all formations whose taking and giving do not differ at any step or under any history.

### 11.3 Where coupling by level comes from

For every law of taking and giving that reads through couplings with couplings only by threshold (no condition couples into any formation by its level), where a formation outside the part neither takes nor gives at steps at which the levels do not admit it: if two histories are the same before a step, and at this step the level of each condition in the latter is not less than in the former, then the uptake and the replenishment of this formation at each condition across this step are, in the latter, not less than in the former. So, where sameness and difference of conditions are decided, for a response whose amount given to a condition is fixed only by the level of condition d at its step, the level of d being no more than N: there is a family of such formations, following such laws, whose sum of giving is exactly this response, exactly where for every x less than N, the response when the level of d is x is no more than when it is x plus one; No family of such formations has a sum of giving exactly equal to the response that supplies the shortfall of the level of d below a positive amount (N being positive). Where sameness and difference of conditions are decided and the sum of the levels of d and one other condition at its step is fixed at N, there is a family of formations, each with needs at d and at this condition and neither taking nor giving at steps at which the levels do not admit it, following such laws, whose sum of giving is exactly every response fixed only by the level of d. Where sameness and difference of conditions and formations are decided, that a condition couples into a formation outside the part by its level cannot be refuted, exactly where it cannot be refuted that there is a law of taking and giving that reads through couplings and responds to it by a change of level that does not change whether the need of this formation at this condition is met.

### 11.4 What a part reaches and the closures

If a member of a part takes part at some step and takes from or gives to a condition that a formation depends on, the part is said to reach that formation; this is what a part reaches. The feeding closure is what is contained in common by every region that contains this formation and is such that "if a member of it depends on a condition at some step, and something taking part at this step gives to the condition, then what gives to it is also in it". The influence closure is what is contained in common by every region that contains this formation and contains everything that takes from or gives to a condition that a member of it depends on. The reach closure is what is contained in common by every region that contains this formation and is such that "if a condition that a member of it takes from or gives to is depended on by a formation, then this formation is also in it". The coupling closure is what is contained in common by every region that contains this formation and contains everything that takes from or gives to a condition that couples into a member of it. The system closure is what is contained in common by every region that contains this formation and contains everything that shares a condition with a member of it (each either depending on it or taking from or giving to it).

### 11.5 The closures contain one another

The feeding closure lies within the influence closure, and the influence closure within the coupling closure; The influence closure and the reach closure both lie within the system closure. Where coupling is only by threshold, the coupling closure is the influence closure. If B is in the system closure of A, then A is in the system closure of B.

### 11.6 Beyond the closures

Everything beyond the influence closure takes from and gives to no condition that anything in the closure depends on; Everything beyond the feeding closure, taking part at any step, gives zero to the conditions that what is in the closure depends on at this step; Everything beyond the coupling closure takes from and gives to no condition that couples into anything in the closure. Under every flow that balances, if all members of the part are beyond the influence closure of this formation: then each formation in the influence closure is, at each step, admitted by the levels exactly where it is admitted by the levels with this part withheld (the levels with the part withheld change, from one and the same starting level, at each step by the flow in which the taking and giving of the members of the part are all zero and the rest is as before). The coupling closure grows with what couples in by level, and also with what takes from or gives to conditions.

### 11.7 What the closures need

If some links are removed from a relation, the closures along it all stay as before exactly where, for every link removed, its end still lies in the closure of its start along the remaining links: every removed link has a bypass. For a relation grown by attachment (its links a family, each new link joining a relatum not before in any link to another relatum), removing any one of its links separates its two ends: one is not in the closure of the other along the remaining links. If a relation grown by attachment is joined by one more link, removing a link of the grown relation leaves the closures as before exactly where the two ends of the new link lie on the two sides of this link: along the remaining links, one end of this link reaches one end of the new link, and the other end of the new link reaches the other end of this link. For a world grown by attachment (its conditions growing one after another, each condition shared by exactly two formations, one of which before this shared no condition), every condition of it is indispensable: the two formations that depend on it or take from or give to it are in one system closure, and along the other conditions alone they are not.

### 11.8 Responsive reach

The responsive reach is what is reached, starting from the members of the part, by adding again and again a formation whenever something in it, in either of two flows, takes from or gives to a condition that couples into this formation. A formation is in the responsive reach of the part exactly where some member of the part is in the coupling closure this formation has through the two flows.

### 11.9 Selection gap

The selection gap is what lies in the reach closure of a formation and not in its coupling closure. If the conditions coupling into everything in the coupling closure of this formation balance at every step, and all members of the part are beyond its coupling closure: then every selector through the couplings of anything in the coupling closure (this formation included) selects the history of levels and the history of levels with this part withheld alike; For any region all of whose members lie in its coupling closure, what selects through the couplings of all its members together also selects them alike.

### 11.10 Its own move

If the rest follow, in both flows, a law of taking and giving that reads through couplings, both flows balance, what takes part is the same, the starting levels are the same, and the part moves alike within the coupling closure this formation has through the two flows (if the members of the part in the closure are alike through couplings up to some step, their takings and givings across this step at conditions coupling into anything in the closure do not differ): then every selector through the couplings of anything in this closure selects the histories of levels of the two flows alike; The consequence of the move (the selection that holds with this move and does not hold without it) is at no step a selection through the couplings of anything in this closure. If the law of the rest and the laws of the two moves read only what is already settled, the first move reads through the couplings of the members of the part, the two moves do not differ at conditions coupling into anything in the closure, and both histories can be run: then the same holds of the two histories, with nothing given separately.

### 11.11 Two histories coming together again

If two flows each balance at a condition c at every step: whether the level of c is the same in the two flows changes only across steps at which the joint taking or the joint replenishment of the two flows at c differ; If what takes part is the same, then at this step some formation taking part must take from or give to c differently in the two flows. If the levels of the two histories at c become the same again at a step (coming together again), then from any earlier step to this step, the takings and givings of the two flows at c exactly make up their gap: the level of one flow at the earlier step plus what is given in it in between plus what the other flow takes in between equals the level of the other flow at the earlier step plus what is given in it in between plus what this flow takes in between. If the rest follow, in both flows, a law of taking and giving that reads through couplings, what takes part is the same, and from some step on the part takes from and gives to c the same in both flows: then every later change in whether the level of c is the same must go through a formation taking part outside the part whose taking and giving at c across some step differ in the two flows, while the histories of levels of the two flows are not alike through its couplings up to that step.

### 11.12 Raising what is coupled draws from beyond

Under every flow that balances, where sameness and difference of conditions are decided, the conditions coupling into the members of a region all lie in a family with distinct members, and a family with distinct members containing this family is gainless across a step: then for every selection that holds only where this family gains across this step, and that holds, some formation taking part gives to this family more than it takes from it, and takes from a condition that couples into no member. By the last law of 4.21: under every flow that balances, if the family together with what lies beyond the family is gainless across a step, each condition beyond the family has a formation depending on it with its need met, the members beyond the family are not in the family, and the conditions coupling into the members of this region all lie in the family: then for every selection that holds only where the rise of the total level of the family is more than the sum of the margins of the dependences beyond the family, and that holds, some dependence on a condition beyond the family is broken, whose formation is not a member of this region and whose condition couples into no member.

### 11.13 The maximal alternative is least beyond the family

Of two outcomes, where the level of the former at each condition of a family is not less than that of the latter, and is more at one of its conditions, the former is said to surpass the latter on the family. An order of alternatives that ranks above everything it surpasses on the family, whatever lies beyond the family, is called rising with the family. For a family and a family beyond it: every maximal alternative of every order rising with the family has at each condition beyond the family the least level among the outcomes that can be chosen, exactly where for every outcome that can be chosen that has more at some condition beyond the family than another outcome that can be chosen, it cannot be refuted that some outcome that can be chosen surpasses the former on the family. Room beyond: for every outcome that can be chosen that has more at some condition beyond the family than another outcome that can be chosen, some outcome that can be chosen surpasses the former on the family; If there is room beyond, then every maximal alternative of an order rising with the family has at each condition beyond the family the least level among the outcomes that can be chosen. On a web, if the levels after the step are such a maximal alternative, there is room beyond, and each condition beyond the family has a formation depending on it with its need met: then a dependence on a condition beyond the family is broken exactly where some outcome that can be chosen makes the level of this condition less than its need. There is a world whose outcomes that can be chosen are the divisions of three units between a source and a store, ordered by "a level of the store reaching one ranks above one not reaching one": this order does not rise with the store, and the outcome in which the source meets the need of what dwells at it and the outcome that leaves the source below its need are both its maximal alternatives.

### 11.14 Room beyond read off the exchange; maximal selectors

For every case in which sameness and difference of conditions and formations are decided, the members of the family of what takes part are distinct, the members of the family joined with the family beyond are distinct, the members beyond the family are not in the family, and the family has a condition; each member of the part takes across a step at each condition no more than its taking limit, gives only to conditions of the family and beyond the family, and the sum of what it gives them is no more than the sum of what it takes from them; the rest take and give as they actually do, and the step so formed balances: then the outcomes that can be had in this way (each beyond the family not less than the floor set) have room beyond. For every order rising with the family, the level of its maximal alternative at each condition beyond the family is what is left by the rest (the level before the step plus what the rest give, minus what the rest take) minus the taking limit of the part there, or zero if that falls short; If no member of the part has a taking limit there, the maximal alternative is what is left by the rest; The maximal alternative makes it less than what is left by the rest exactly where the part has a taking limit there and the rest leave something. For maximal selectors, each with its family and its order rising with its family, each taking this step as a maximal alternative of the outcomes it can have given what the others do (mutually maximal), where this step balances and a condition lies beyond the family of every maximal selector taking part: then the level of this condition is "the level before the step plus what those other than the maximal selectors give, minus what they take" minus the taking limits of the maximal selectors, or zero if that falls short, the same as what is left there by a maximal alternative of any order rising with the family when the maximal selectors are taken as one part; Afterwards, if this condition stands as a condition, each maximal selector takes its full taking limit there and gives nothing.

### 11.15 The course of maximal selection and the steps counted

Under the hypotheses of 11.14 on the family and the family beyond, if the part selects maximally at every step (the outcome of each step is a maximal alternative, in its order rising with the family, of the outcomes the part can have from the levels before the step, the rest taking and giving as they actually do), then for a condition beyond the family: at steps at which its level is not less than a positive need m, the rest give it exactly r, and at the other steps no more than r; If what the rest take plus the taking limit of the part there is k at every step: then a formation depending on it with need m at every step, met at the start, is broken for good exactly where r < k. A level starting not less than m is not less than m at every step exactly where k is no more than r. If maximal selectors (each under the hypotheses of 11.14) are mutually maximal at every step, the flow balances, a condition lies at every step beyond the family of every maximal selector taking part, those other than the maximal selectors give it no more than r at every step, what they take plus the taking limits of the maximal selectors is more than r at every step, and a formation has a bearing dependence on it with need m at every step, met at the start: then the dependence is broken for good, however small the taking limit of each maximal selector.

### 11.16 Target above all

Target above all: the amount of one seeking at a configuration is more than the amount of each other seeking. At every configuration, two seekings do not both have the target above all. For every law, if a family has two seekings, then there is no configuration the law leaves unchanged at which every seeking in the family has the target above all.

### 11.17 Enough

Enough: a run reaches a configuration that the law leaves unchanged and that meets the target, and from then on changes no more and meets the target at every step (for stillness see 3.10). More than now: an amount read from the configuration is, across a step of a run, more at the next step than at this one; For every law, where the target is more than now, no step at which its run does not change meets the target.

### 11.18 Seeking without rest

Reading (AI, D26, D45): seeking without rest is seeking that does not let go of its target while no configuration the law leaves unchanged meets its target: either the target is more than now (11.17), or two or more seekings each seek the target above all (11.16). The place of a selector (the selection gap) is not seeking without rest; seeking without rest is seeking that does not let go in this place.

### 11.19 The bound of enough

If the target is more than now and it is met at every step, then the configurations passed through are pairwise different, so there is novelty from the start, and no family can contain them all (5.5).

### 11.20 Re-absorbed

Re-absorbed: where the rule does not change and only the other part of the configuration is perturbed, the configuration is drawn back to the one the rule fixes. If the next configuration depends only on the rule and not on the other part of the configuration, then two configurations with the same rule have the same run from the next step on. Where the rule does not change (the rule of the next configuration is the same as the rule of this configuration), the configurations with one rule form a region the law does not leave.

### 11.21 Capture

Capture: the outcome follows only the rule: configuration and rule are a pair, and the next pair depends only on the rule and not on the configuration. For every selection, with each member of the family assigned a number: each member whose history the selection holds of is assigned no less than a; each member whose history the selection does not hold of is assigned no more than b; If b < a and there are members of both kinds: then the sum assigned to those it holds of, against the sum assigned to those it does not hold of, is strictly greater than the number of those it holds of against the number of those it does not hold of (the ratio rises).

### 11.22 Pace, reading step

Pace is the speed at which a rule changes (for the run of configuration and rule and for the reading step, see 8.13; for its law, see 8.14). For any values among which two differ: the paths produced by a rule left unchanged over a fast layer (the configuration moving by this rule), read through a reading into values of at most N kinds, are such that any two that are the same over a stretch of L steps are the same throughout, exactly where L ≥ 2N − 1.

### 11.23 Capture through the rule

Capture through the rule is a rule read from the ratio of what it selects: in a run of configuration and rule, the rule read at a reading step does not fall as the configuration's ratio does not fall (where the ratio is not lower, the rule read is not lower, whatever the rule at that time). If under every rule that tilts toward the carriers selection does not lower the ratio, and the rule read does not fall as the ratio does not fall: first, if the starting rule tilts toward the carriers and every rule read tilts toward them, then the ratio falls at no step, and after every reading step the run is locked (the rule tilts toward the carriers, and the rule the ratio reads is not below this rule). Second, if every rule not below a rule that tilts toward the carriers also tilts toward them, then from a locked configuration the run is locked at every step after, and neither the ratio nor the rule falls; if from a locked configuration the rule is replaced by any rule that still tilts toward the carriers, then after every reading step the rule is not below that of the run without the replacement, and the run is locked again. Third, if every rule read tilts toward the carriers, then every path, whatever its start, is locked from after the second reading step on; this bound is exact.

### 11.24 Closed capture

Closed capture is where the reading of the rule is itself made by the ratio. Wherever the configuration of the fast layer is a pair of the ratio and what lies beyond the ratio, and neither the next ratio nor the rule read reads what lies beyond the ratio: any two histories whose ratio and rule start the same have the same ratio and the same rule at every step, whatever lies beyond the ratio. If further what lies beyond the ratio grows by at least one at every step, and the run starts from a locked configuration under the condition of the second part of 11.23: then at step t what lies beyond the ratio is no less than its start plus t, while the path is locked at every step and neither the ratio nor the rule is below its start. Wherever the reading of the rule at reading steps is made by the ratio (not falling as the ratio does not fall), and the rule is read off from this reading and the ratio (not falling as the two do not fall): the rule together with its reading is one rule, read from the ratio; if it is locked under the condition of the second part of 11.23, then none of the ratio, the rule and the reading falls; if from a locked configuration the rule is replaced by any rule that still tilts toward the carriers and the reading by any reading (higher or lower), then after every reading step neither the rule nor the reading is below that of the run without the replacement, and the run is locked again; if the rule read tilts toward the carriers at every reading and every ratio, then every path, whatever its start, is locked from after the second reading step on.

### 11.25 Coupling beyond support

Reading (AI, D26, D45): coupling beyond support is the couplings joined to a selection reaching what admission does not mark. Its routes are three: a condition coupling in by its level, admitted histories, and the couplings of others used together.

### 11.26 The three routes of coupling beyond support

The routes of coupling beyond support: first, a condition coupling in by its level: where the sameness or difference of conditions is decided, for every condition that couples into a formation by its level, if the level of this condition is raised at every step by one and the same positive amount, then at every step the levels of the original web and of the raised web are not alike through this formation's couplings. Second, admitted histories: for their testing and their error, see 9.14. Third, the couplings of others used together: for its laws, see 11.27 to 11.31.

### 11.27 Pooled coupling

Pooled coupling is the couplings of the members of a region used together. Selection through pooled coupling is a selection that is the same on any two histories that are alike through each member's couplings up to a given step.

### 11.28 What pooled coupling separates

What pooling adds is what pooled coupling adds; pooled as one member is pooled coupling equal to the couplings of one member. Every selection through pooled coupling up to a step is the same on two histories exactly where the two are alike through every member's couplings; some selection through pooled coupling holds of the one and does not hold of the other exactly where not every member finds them alike. Where one member separates them through its couplings, some selection through its couplings is also a selection through pooled coupling and separates them. If a family lists all the members and each member's being alike is decided, then pooled coupling separates them exactly where some member separates them. The selections through pooled coupling are exactly the selections through one member's couplings exactly where every two histories alike through this member's couplings are alike through every member's (pooled as one member); if two histories are alike through this member's couplings and not alike through every member's, then some selection through pooled coupling is not a selection through this member's couplings (what pooling adds).

### 11.29 The coupling closure of a region; reading another's couplings

The coupling closure of a region is the union of the coupling closures of its members. Wherever every condition coupled into by what lies in this region's coupling closure balances at every step, and every member of the part lies outside this region's coupling closure: then for any region whose members all lie in this region's coupling closure (this region included), every selection through its pooled coupling is the same on the history of levels and on the history of levels with this part withheld. Reading another's couplings is a formation coupled in addition, by level, into every condition the other is coupled into (by threshold or by level): every selection through the pooled coupling of the two is a selection through the couplings of the formation that reads so; if the other has taking and giving at some condition that couples into it, then the coupling closure of the formation that reads so is exactly the coupling closure of the region the two form.

### 11.30 Moves under pooled coupling

If in two flows the others all follow one law of taking and giving that reads through couplings, both flows balance, what takes part is the same, the starting levels are the same, and the part's moves are alike within the coupling closure that each member of a region has through the two flows: then for any region whose members all lie in this region's coupling closure through the two flows (also where the part is this region), every selection through its pooled coupling is the same on the level histories of the two flows; every formation that separates the two flows through its couplings up to some step lies outside this region's coupling closure. If a move changes a formation's admission at some step, then this formation lies outside this region's coupling closure; its admission at this step is a selection through pooled coupling, from this step on, of every region that contains this formation, and is not a selection, at any step, of any region whose members all lie in this region's coupling closure. Wherever the level history of the later flow widens that of the earlier flow, there is a formation admitted at some step by the later flow's levels and not by the earlier flow's, and its admission is likewise so.

### 11.31 Response under pooled coupling

Wherever a law of taking and giving reads, for every formation outside the part, through its couplings, and the members of a region all lie outside the part: every selection through the moves of this region's members (under this law) is a selection through pooled coupling; if a family lists all the members, each member's being alike is decided, and the moves of this region separate two histories, then some member separates them through its couplings. Wherever, for each formation, each step and each history, being alike through couplings with a given history is decided, there is some condition, and the members all lie outside the part: across a step, the members' taking and giving at every condition is alike under every law that reads through couplings, exactly where the members are alike through couplings up to this step. Under the conditions of 11.30, every formation in this region's coupling closure and outside the part takes and gives alike in the two flows at every step and every condition. Some member of this region lies in the part's responsive reach exactly where some member of the part lies in this region's coupling closure through the two flows.

## Chapter 12

### 12.1 Coupling strength and carried amount

Coupling strength is the multiple by which, as a taking and giving varies with a condition's level, the gap in what it takes and gives is bounded by the gap in this level. The carried amount is the level history that the law of carrying gives, step by step, from the coupling strengths, the starting gap and the part's gap. Wherever a family lists every condition, each once: for every law that reads only what is already fixed and any two flows under this law, where both flows balance, what takes part is the same, the relata outside the part follow this law with coupling strength at most k, what the part does differs by at most σ, and the starting levels differ by at most δ: for all such, the gap at a condition at a step is at most a, exactly where its carried amount is at most a. The carried amount is positive exactly where there is a path along the steps that reaches it from the starting gap, the part's gap and positive coupling strengths.

### 12.2 Loop

A loop is a chain of couplings from a condition back to this condition. Wherever every coupling is present at every step: from every starting gap, some expansion order equals the carried amount at c at every step, exactly where no condition upstream of c lies on a loop.

### 12.3 Closing

Closing is where the coupling of a step joins the head and the tail of a chain, and a loop first exists. Every loop comes to be by some step. Every loop formed by step T+1 either was already formed by step T or passes through a coupling acting at step T that reads the level of d and has taking and giving with c, with a chain from c to a condition on the loop and a chain from this condition to d. When a taking and giving first responds to the level of the condition it gives to, a loop of one condition is formed.

### 12.4 Loops lie within what is read, and their forming cannot be seen in advance

If no relatum outside the part reads the level of c at any step, then among the couplings restricted to what is read no loop passes through c, and downstream of c there is only c. Wherever a family lists every condition, the part gives no further gap after the start, the starting gap is at most D, the sum of the coupling strengths into each condition at each step is at most M, and no loop formed by step T is upstream of c: then at every step up to T the carried amount at c is at most D times a polynomial in the number of steps, of degree the number of conditions less one, whatever the couplings after. There is a loop of a condition on itself formed at step T: at every step up to T its carried amount is the starting gap, and at every step after it doubles; a loop of the condition on itself formed at any step after T gives, at every step up to T, a carried amount equal to it.

### 12.5 Filling threshold

The filling threshold is where a level rises to a threshold and then a new coupling forms.

### 12.6 Coupling recurs, and what a cut loses

A coupling recurs where the level of d coupling into c recurs. What a cut loses is what the carried amount, cut at an expansion order, leaves uncounted. For every cut at expansion order j, the carried amount equals the amount at order j plus what is carried from the carried amount itself through j+1 responses in turn: what the cut loses is the latter term, however the coupling strengths go step by step. If the gap has reached a loop, every coupling on the loop recurs, and there is a chain of recurring couplings from the loop to c: then a cut at every expansion order loses something at c at some step. If no coupling reads the levels of step N and after, then a cut at expansion order N loses nothing, at every step, at every condition and from every starting gap. The carried amount of the expansion orders is the sum over the paths traced back along the steps: up to a step, the sum over the paths of length j+1 is the carried amount of order j; a cut at an expansion order is a cut of this sum.

### 12.7 Runaway

Runaway is the carried amount growing with the steps beyond every polynomial. Wherever the coupling strengths are the same at every step and read only the levels of the present step, what takes part is the same at every step, a family lists every condition, and the part gives no further gap after the start: the carried amount at c is bounded by a polynomial from every starting gap exactly where there is no loop upstream of c; where the coupling strengths on a loop are all positive, the carried amount at a condition on the loop at least doubles with every loop turn. If the part gives no further gap after the start, the starting gap is at most D, the sum of the coupling strengths into each condition at each step is at most M, and the couplings that read the levels of step N and after have no loop upstream of c: then, however the coupling strengths go step by step, the carried amount at c is bounded by a polynomial.

### 12.8 Frequency

Frequency is the number of steps at which a coupling acts. If the part gives no further gap after the start, the starting gap is at most D, the sum of the coupling strengths into each condition at each step is at most M, and the sum of the coupling strengths into each condition is zero at unmarked steps: then the carried amount at step t is at most D times 1+M to the power a, where a is the number of marked steps before t. If the gap has reached e and comes back from e to e through a chain along the steps, then after this round trip the carried amount at e is at least twice what it was before the round trip. If the carried amount at e is positive at some step and round trips follow one another after it: if for every polynomial there is some i such that 2 to the power i exceeds the value of this polynomial at the step of the i-th round trip, then the carried amount at e runs away. There is a loop whose coupling recurs and that does not run away.

### 12.9 Return map

The return map is the composition of what the loop links do in turn: a gap is sent into the first loop link, each loop link hands what it receives on to the next, and what the last loop link hands back is the return map. If every loop link hands on no less than it receives, then the gap at every loop turn is no smaller than at the start; if the gap at some loop turn is smaller than at the start, then some loop link hands on, at some gap, less than it receives. If the return map is zero at zero and less than every positive gap at that gap, then a gap d is zero by the d-th loop turn and zero at every loop turn after; this bound is exact. If every loop link hands on exactly what it receives, then the gap at every loop turn is as at the start. If a loop has loop links and every loop link hands on at least twice what it receives, then after n loop turns the gap is at least 2 to the power n times its start, and from a positive gap it passes every bound.

### 12.10 Whole-number factors and cuts

Wherever every loop link of a loop multiplies by a whole-number factor: if the product of the factors is zero, then from the first loop turn on the gap is zero at every loop turn; if it is one, then the gap at every loop turn is as at the start; if it is no less than two, then from a positive gap the gap passes every bound. So the gap at every loop turn is either zero or no smaller than at the loop turn before; where the gap at some loop turn is positive and less than at the loop turn before (falling gradually), the loop has a loop link that is not a multiplication. If a loop link hands back zero and the loop links after it hand on nothing when they receive nothing, then after the first loop turn the gap is zero at every loop turn, whatever the loop links before it. If a loop link after it hands on something when it receives nothing, the gap can be positive again: there is a loop in which the loop link handing back zero is followed by a loop link that adds one, and after the first loop turn the gap is one at every loop turn, whatever its start.

### 12.11 Feedback

Feedback is where the gap between two histories at a condition is, after every step, the return map of the gap before it. Wherever two flows balance at c at every step: their taking and giving responds to their gap by f from step s on, exactly where the gap at every step after s is f of the gap before it; so the gap at step s+n is the value of f after n loop turns run from the gap at step s, one loop turn per step.

### 12.12 Break

The break is where the level of c falls below the threshold and the law turns from not reading it to reading it. Wherever the law reads c only below the threshold: if both flows balance and what takes part is the same, what the part does is the same, what lies outside the part follows this law, the start differs only at c with the latter higher by d, and c in the former is not below its threshold at any step before T: then up to T the levels of every condition other than c are equal in the two flows, and c in the latter is higher by d at every step. If the law also reads only what is already fixed, and c is the only one marked: at a step up to which c is not below the threshold at any step, what the law gives is the same as its pre-break law (the law that reads c, where it is below the threshold, as if it were at its threshold); the pre-break law has coupling strength zero at c; among the couplings restricted to what is read no loop passes through c, and downstream of c there is only c.

### 12.13 Unread before the break

Unread before the break is where what is coupled into before the break does not bound how near or far the break is. Wherever c does not couple into formation g by its level, and the sameness or difference of conditions is decided: for any step u, if at every step up to u every dependence of g other than at c is met, then there is a web, differing only in that the level of c is raised by one and the same number at every step, that admits g at every step up to u, and at every step at which the original web admits g the levels of the two webs are alike through g's couplings. Wherever the sameness or difference of formations is decided, g's taking and giving goes through its couplings, the others' taking and giving at the conditions coupling into g is the same in both flows, what takes part is the same in both flows, every condition coupling into g balances in both flows, and at the start what couples into g is no less in the latter and what couples into g by its level is equal in the two flows: if the gap at some condition coupling into g changes by some step, then it is not the case that the original web admits g at every step before.

### 12.14 Without overshoot

Without overshoot is where, at a step, in the joint taking and giving at c, the joint taking exceeds the joint giving by no more than the level exceeds m, and the joint giving exceeds the joint taking by no more than the level falls short of m. Wherever a flow balances at c at a step: it is without overshoot exactly where the level at the next step lies between m and the level at this step (on the same side as this step, not farther). If a flow balances at c and is without overshoot for n steps, then the level after n steps lies between m and the starting level.

### 12.15 Two-sided regulation

Two-sided regulation is where the joint taking and giving at c opposes the departure on both sides of m and is without overshoot: above m the joint taking exceeds the joint giving, and below m the joint giving exceeds the joint taking. If a flow balances and is in two-sided regulation at m at every step from T on: then at a step at which the level is not at m, its gap from m falls by at least one; the gap after n steps is at most the first gap less n; by the step T plus the first gap the level is m, and it is m at every step after. Starting below m, it is at m by the step T plus the amount by which it falls short of m, and does not move from it.

### 12.16 Overshoot and one-sided response

Overshoot is an opposing joint taking and giving that exceeds the gap between its level and m. If a flow balances at c at a step, and the joint taking and giving opposes the departure and is not without overshoot: if the level is above m, then the level at the next step is below m; if it is below m, then the level at the next step is above m. There is a flow that balances at every step, opposes the departure on both sides and overshoots at every step, is above m at even steps and below m at odd steps, and never reaches m. One-sided response is responding on one side only. There is a flow that satisfies the premise of the law of rising to m, is without overshoot at every step, is above m without opposing, and is above m at every step: one-sided response is not two-sided regulation.

### 12.17 Reading late

Reading late is a response function reading ℓ steps late: what it gives and takes at a step is fixed only by what the rest of the whole did ℓ+1 steps or more before. If a response function reads ℓ steps late and, from a starting configuration, for every rest of the whole that moves the level by at most d at each step, its level history lies between a and b at every step, with 0<a: then a plus 2(ℓ+1)d is at most b. There is a response function that at each step offsets what the rest of the whole moved ℓ+1 steps before, and neither takes nor gives in the first ℓ+1 steps: it reads ℓ steps late, and from a starting configuration not below (ℓ+1)d, for every such rest of the whole, its level history lies at every step within (ℓ+1)d above or below the starting configuration: the width of this region is exact.

### 12.18 Relay

The relay is: reading its level, it gives M where the level is below a, takes M where it is above b, and neither takes nor gives where it is between a and b. Wherever a is at most b, 0<a, 0<M, and (ℓ+1)M is at most b+1: every flow whose joint taking and giving at c is only the relay reading ℓ steps late and that balances at every step, from any starting configuration whose level in the first ℓ+1 steps is one and the same number below a, lies between a and b at every step from some step on, exactly where a+(ℓ+1)M is at most b+1.

## Chapter 13

### 13.1 Descent

Descent: where g takes part across a step and gives to x, and x comes to stand across this step, x descends from g, and g is what x descends from. If a relatum comes to stand across a step and balances across this step, then there is something it descends from at this step. If a flow balances and only the active give, and an embodied relatum arises across a step, then there is another relatum that is active at that step and is what it descends from. There are a flow and a web in which a relatum descends from something, its arising is at a step after its coming to stand, and nothing is given to it when it arises; there are a flow and a web that are unceasing and in which no relatum descends from anything.

### 13.2 Inheritance

Inheritance is where, at the step at which x descends from g, what x depends on after the step g also depends on at the step of giving. Inheritance covers two: the dependences x newly forms across this step, and those x already had that it still has after the step. If x does not depend on c at the step of giving, then x has inheritance at c exactly where, if x forms a dependence on c across this step, g depends on c at the step of giving. If a relatum comes to stand across a step, balances across this step, and has inheritance at c from everything it descends from at this step: then, if it depends on c after the step, something it descends from also depends on c at the step of giving; if nothing taking part at this step depends on c, then it does not depend on c after the step.

### 13.3 Transmission

Transmission is inheritance with a bound on need: for a condition c and a bound δ, wherever x descends from g and x depends on c after the step, g depends on c at the step of giving, and the need of x on c is at most the need of g on c plus δ. Transmission is exactly inheritance and the bound on need together. If the flow balances, then transmission implies transmission from some giver: everything that comes to stand and depends on c has something it descends from that depends on c at the step of giving, with its need at most that one's need plus δ. The latter is strictly weaker than transmission: there are a flow and a web that balance, in which only the active give, that are dependent, where transmission from some giver holds and transmission holds for no δ.

### 13.4 The independence of transmission

If a world is dependent, balances, has only the active giving, has only the active taking and taking only from what they draw from, dissipates, is embodied, and has a census (the seven suppositions other than transmission), and some offspring in it depends on something after its step, then removing one dependence, at the step of giving, of something it descends from yields a world that has these seven suppositions and in which transmission does not hold. For every property of worlds that does not change when one dependence is removed and that implies transmission, no world with this property has an offspring that depends on something after its step. The reading that what an offspring depends on when it first comes to stand is only what the things it descends from draw from at the step of giving, together with drawing implying dependence, implies inheritance; for finite worlds with these seven suppositions, with either of the two missing, inheritance does not follow. For every finite world that balances, dissipates, is embodied and is dependent, transmission holds exactly where there is inheritance at every condition.

### 13.5 The eight suppositions do not follow from one another

The eight suppositions of a world: dependent (2.5), balance (1.15), only the active give, only the active take and take only from what they draw from (1.16), dissipation (4.4), embodied (2.11), census (3.6), transmission (13.3). For the first six suppositions and for reserve (2.10), each has a world that satisfies it and a world that does not; the eight suppositions do not follow from one another: for each supposition there is a world that satisfies the other seven and not it. The world read off the path that a law of taking and giving produces, with the rest of the whole counted, has all of the first four suppositions (1.17, 2.5). For every world with the rest of the whole counted: if the members of the family taking part at each step are distinct and each step is closed on a given family, then it has a census; the world with the rest of the whole counted is embodied exactly where the original world balances and each relatum takes and gives exactly at the steps at which its level is positive. For a world read off a law that reads only what is already fixed, with the rest of the whole counted, the rest of the whole is never active exactly where its path is feasible. Dissipation, embodiment and transmission are properties of the law of taking and giving: among worlds read off a law of taking and giving, with the rest of the whole counted, the rest of the whole never active, and the first four suppositions all holding, for each of these three suppositions some satisfy it and some do not.

### 13.6 Evolution

Evolution is where only what is admitted has offspring, and the needs passed on within the bound are selected within the bound. Wherever only the active give and the web is dependent: at the step at which x descends from g, g is admitted; what is not admitted at a step has no offspring at this step; what is never admitted never has offspring. If moreover c is transmitted within δ, then wherever x descends from g and depends on c after the step, the need of x on c is at most the level of c at the step of giving plus δ. If the flow also balances, then wherever x descends from g at step S＋n and depends on c after the step, the need of x plus what is taken from c in the n steps from step S is at most the level of c at S plus what is given to c in these n steps plus δ.

### 13.7 Variation

Variation is the rise and fall of an offspring's amount against the amount of what it descends from. For every family in which each member has its family of offspring, with the amounts of members and offspring read in any way as natural numbers: the total of the offspring's amounts plus all the falls equals the total of the members' amounts, each counted by its number of offspring, plus all the rises (the account of variation). If every member has k offspring, then the total counted by offspring is k times the total of the members' amounts.

### 13.8 Selection term

For every family, with the members' weightings and amounts read in any way as natural numbers: the number of members times the total of the products of each member's weighting and amount, plus the discordance, equals the total of the weightings times the total of the amounts, plus the concordance. The selection term is the concordance less the discordance, with the number of offspring as the weighting. With the number of offspring as the weighting: the number of members times the total counted by offspring exceeds the total number of offspring times the total of the members' amounts exactly where the concordance exceeds the discordance; the two are equal exactly where the concordance and the discordance are equal. Joined with the account of variation: the number of members times the total of the offspring's amounts, plus the number of members times the falls, plus the discordance, equals the total number of offspring times the total of the members' amounts, plus the concordance, plus the number of members times the rises.

### 13.9 The family mean across successive families

Successive family: the first is a family, each member of each successive family has its family of offspring, and the next successive family is the offspring of the members. The family mean is compared by cross-multiplying: it does not change across a step exactly where the number of members of this successive family times the falls, plus the discordance, equals the concordance plus the number of members of this successive family times the rises; it rises exactly where the former is less than the latter. If the family mean of a successive family differs from that of the first, then at some step before it the two sides do not offset each other, and checking step by step finds it; if there is exact transmission at every step (each offspring's amount equals its member's amount), then at some step before it the discordance differs from the concordance; if at every step every member has the same number of offspring, then at some step before it the falls differ from the rises.

### 13.10 What is admitted is not selected against

Wherever only the active give and the web is dependent, and the offspring listed for the members of a family all descend from their member at this step: if an amount at every admitted member is not below the amounts of all the members, then the discordance is zero and the selection term is not negative. In this flow, wherever the successive families are all formed by descent and an amount at the admitted members of each successive family is not below the amounts of all members of that successive family: if the falls at every step of a stretch are zero, then the family mean does not fall over this stretch; if there is exact transmission at every step of this stretch and the family mean changes, then the change is a rise, and at some step the concordance exceeds the discordance.

### 13.11 Selection on the number of offspring

A weighting read against itself has no discordance: the number of members times the total of the squares of the weightings equals the square of the total of the weightings plus the concordance (the total of the squares of the pairwise gaps); so it is not below the square of the total of the weightings, and is equal to it exactly where the weightings are all the same. With the number of offspring as the weighting: the number of members times the total of the numbers of offspring counted by offspring is not below the square of the total number of offspring, and is equal to it exactly where every member has the same number of offspring. Reading successive families with the number of offspring as the amount: if the falls at a step are zero, then the family mean of the number of offspring does not fall across this step; if there is exact transmission at this step, then the family mean of the number of offspring rises exactly where the concordance is positive, and does not change exactly where every member has the same number of offspring.

### 13.12 The additive decomposition

For every family, with weightings and amounts read in any way as natural numbers: the square of the concordance plus the discordance is at most the total of the squared pairwise gaps of the weightings times the total of the squared pairwise gaps of the amounts; where the amount is the weighting itself, the two are equal. If there is exact transmission at some step of successive families, then the square of the rise or fall of the family mean (by cross-multiplying) is at most the total of the squared pairwise gaps of the numbers of offspring times the total of the squared pairwise gaps of this amount.

### 13.13 The bound on the number of offspring

Where a member's offspring at a step all descend from it, their number is at most the total it gives to the offspring at this step. Where a family balances and dissipates across a step: if the offspring are distinct and are all members of the family, their number plus the number of takers that take from the family at this step is at most the family's total level before this step. If the successive families are all formed by descent, the offspring are all members of one family, and this family balances and dissipates at every step from the first step to the step numbered by its starting total level, then the successive family numbered by the starting total level plus one is empty (the first successive family is numbered zero); read with the number of offspring as the amount, if the next successive family has members, then at some step before the step of the starting total level the number of members times the falls exceeds the concordance plus the number of members times the rises.

### 13.14 Within groups and among groups

Where a family is listed group by group as k groups with the same number of members in each: the concordance of the whole family, plus k times the within-group discordance, plus the among-group discordance, equals the discordance of the whole family, plus k times the within-group concordance, plus the among-group concordance. So, for an amount whose within-group concordance is not more than its within-group discordance, the concordance of the whole family exceeds its discordance only where the among-group concordance exceeds the among-group discordance. Where the groups differ in their numbers of members, taking a common multiple of the groups' numbers of members, counting each group's own terms by its multiplier, and reading the among-group terms member by member from the groups' family means, there is also a corresponding decomposition (each term multiplied by a multiplier the common multiple fixes); if a successive family has members, is listed group by group as groups with the same family means, and has exact transmission, then its family mean rises exactly where the within-group concordance (counted so) exceeds the discordance.

### 13.15 Selection among groups by having no offspring

Where the groups have the same number of members and every group whose total of an amount is less than another group's has no offspring, there is no among-group discordance; so the selection term of the whole family is positive exactly where k times the within-group discordance is less than k times the within-group concordance plus the among-group concordance; if moreover this amount is the same within each group, then the selection term of the whole family is not negative. In a flow: where the flow balances, only the active give, the web is dependent, and for a condition c every renewer of c depends on it with need not below m, if at each of the n steps from T what is given to c is less than what is taken from c, and the level of c at T is less than n plus m, then from T＋n on nothing that depends on c at its step with need not below m has offspring. Where only the active give and the successive families are formed by descent, if no member of a successive family is active, then the next successive family is empty.

### 13.16 Groups formed by descent

Where the first successive family is listed group by group, the members of each group all have, for an amount, the value with which their group was first set, and there is exact transmission at every step: then in the groups formed by descent every member, across the successive families, carries the first value of its group, and there is no within-group selection term; where every group formed by descent has members in the t-th successive family, the family mean rises from the t-th successive family to the next exactly where, read by a common multiple of their numbers of members, the concordance of the groups' family means with the numbers of offspring exceeds the discordance. In a flow: where only the active give and the successive families are formed by descent, if in every successive family before the T-th, for every group whose first value is less than another group's, the members of what is formed by descent from it are all inactive, then the family mean of the T-th successive family is not below that of the first; if in the t-th successive family, for every group whose first value is less than another group's, the members of what is formed by descent from it are all inactive, while in what is formed by descent from a group with a larger first value some member leaves offspring, and beside it what is formed by descent from a group with a smaller first value has members, then the family mean rises from the t-th successive family to the next.

### 13.17 Drift

Under a representation in which the next successive family is not the family of offspring itself but is formed from the family of offspring by n draws with replacement: the family has p of the first kind and q of the second, and each sample has as its weight the number of ways of drawing it. p＋q times the total, over the samples counted by their weights, of the number of first-kind draws equals n·p·(p＋q)ⁿ. If (p＋q)·h＋g＝N·p, then the total weight of the samples whose number of first-kind draws times N is at most h times n, multiplied by n²·g², is at most N²·n·p·q·(p＋q)ⁿ, and that total weight is no less than qⁿ.

### 13.18 Fixation under drift

For a family of N members with h of the first kind (h at most N), each successive family drawn N times with replacement from the one before by the numbers of its kinds alone: over the histories of k successive families (each with the number of ways of drawing it as its weight), the total, counted by weight, of the number of the first kind in the last successive family equals h·(N^N)^k. Starting with none of the first kind, every history has none at every successive family; starting with all of the first kind, every history has all at every successive family. If r＋2＝N^N, then the total weight of the histories that still have both kinds after k successive families is at most r^k; the total weight of the histories fixed at the first kind, times N, is at most h·(N^N)^k, and with N·r^k added it is no less than h·(N^N)^k.

### 13.19 Model

The model a selection goes through (1.3) assigns a value to each selectable. A selection through a model, when the values of two selectables are swapped, swaps what it selects. Wherever the sameness or difference of selectables is decided: two selectables are selected alike by every selection through a model exactly where the model assigns them the same value; a selectable can be selected by a selection through a model that selects at most one under each model exactly where the values of the other selectables all differ from its value. If a claim holds of one and not of the other of two selectables to which the model assigns the same value, then no selection through this model selects exactly those of which it holds.

### 13.20 Learning through response

Learning through response is learning through others' actual responses. In the represented pair of learning through response (the learning side receives only the actual responses of the side learned from; what is installed, the grammar, a family of questions and the levels are all given), where the side learned from has something installed, what the learning side learns from it is the same as what it learns from a side learned from that has only this installed and the same levels (the learning side's levels, components and family of questions being the same). Where there is no response, the learning side adds no sample; after a family of questions, the total of the two sides' levels and the amounts already used does not change.

## Chapter 14

### 14.1 Collective

A collective is formations that lie together in a system closure. If there is a condition such that every formation either depends on it at some step or has taking and giving at it, then every formation lies in the system closure of every formation.

### 14.2 Mutual dependence

Mutual dependence is where every formation lies in the influence closure of every formation: each formation can be influenced, through a chain, by every other. Mutual dependence holds exactly where every formation lies in the reach closure of every formation.

### 14.3 Common condition

A common condition is a condition that every formation depends on at some step and also has taking and giving at. If a flow has a common condition, then every formation lies in the reach closure of every formation, and the formations are in mutual dependence.

### 14.4 Mutual feeding

Mutual feeding is where every formation lies in the feeding closure of every formation. Mutual feeding implies mutual dependence; where there is mutual dependence, every formation lies in the system closure of every formation. There is a flow in which every formation lies in the system closure of every formation and there is no mutual dependence; there is a flow that balances and has mutual dependence, with two formations neither of which lies in the other's feeding closure.

### 14.5 The speed of mutual dependence

From 12.8 (every step marked) and 12.7 (at least doubling with every loop turn): if the part gives no further gap after the start, the starting gap is at most D, and the sum of the coupling strengths into each condition at each step is at most M, then the carried amount at step t is at most D times 1＋M to the power t; if moreover the couplings of a loop are present at every step (the loop of length m＋1), then after R loop turns from step T (up to step T＋(m＋1)R) the carried amount at the condition where the loop lies is at least 2 to the power R times its carried amount at step T. Wherever the flow balances, nothing is given to a condition c for n steps from step T, and the joint taking at c at each step exceeds the sum of the joint taking at c from step T up to before it: then at each of these n steps the level of c exceeds half the level at step T, and the level at step T is no less than 2 to the power n less one.

### 14.6 Taking within giving

Under taking within giving (4.19): wherever the flow balances, there is taking within giving at a condition at every step, and every formation depends only on this condition with need at most the level of this condition at step zero, every formation is admitted at every step.

### 14.7 Waiting with memory

Waiting with memory is where a relatum gives at the next step exactly where it gives at this step and everything it waits on gives at this step. Under the law of waiting with memory: if a relatum does not give at some step, then it does not give at any step after; if a relatum does not give at the start and a chain of waiting of length k leads from it to another relatum, then the other does not give at any step from step k on; if every relatum lies within d waitings of one relatum and this relatum does not give at the start, then from step d on no relatum gives.

### 14.8 Waiting without memory

Waiting without memory is where a relatum gives at the next step exactly where everything it waits on gives at this step. Under the law of waiting without memory: if there is no chain of waiting of length L between any relata, then, whatever the start, every relatum gives at every step from step L on; if there is a chain of waiting of length p from b back to b and b does not give at the start, then b does not give at any step that is a multiple of p. Under the law of waiting with memory and under the law of waiting without memory, if more is waited on, then the relata giving at each step are among those that gave at the same step before.

### 14.9 Tolerance

Tolerance is where a relatum still gives when no more than tol of what it waits on are missing, with tol at least one. Under the law of still giving while no more than tol are missing: if the members of a region all give at the start and each member waits on no more than its tol outside the region, then, whatever the other relata, the members of this region give at every step; if everything outside a region gives at the start and each relatum waits on no more than its tol inside this region, then from step one on every relatum gives at every step; if no relatum has a tol no less than the number it waits on, then once no relatum gives at a step, the same holds at every step after. The law with tol zero has the same path as the law of waiting without memory.

### 14.10 Restoring from every start

Restoring from every start is where a relatum gives at some step from every starting configuration. Wherever a law keeps inclusion (if the relata giving in one configuration are all among those giving in another, then the same holds at the next step): a relatum gives at step n from every starting configuration exactly where it gives at step n starting from the configuration in which none gives; starting from the configuration in which none gives, if a relatum gives at some step, then it also gives at the next step; what gives at step n from every starting configuration gives at every step after from every starting configuration; if no relatum gives at the step after the configuration in which none gives, then, starting from the configuration in which none gives, no relatum gives at any step.

### 14.11 Giving first

Giving first is where a relatum gives after every step, without regard to what it waits on. Under the law of giving first (after every step, the relata that give first all give; any other relatum gives at the next step if everything it waits on gives at this step), where whether each relatum gives first is decided: a relatum gives at step n from every starting configuration exactly where no chain of waiting of length n, with no relatum giving first except at its starting point, leads into it; if there is a chain of waiting from b back to b (of positive length) with no relatum giving first except at its starting point, then, starting from the configuration in which none gives, b gives at no step; if a relatum gives at step n from every starting configuration under the law of waiting without memory, then the same holds under the law of giving first.

### 14.12 Loop returning less

A loop returning less is a loop on which a loop link hands back less than it receives. For the steps at which the run of the return map falls and the steps at which it is zero, see 12.9.

### 14.13 Race at a shared condition

A race at a shared condition is where formations have joint excess at a condition over consecutive steps; for the fall of its level and the ending of what depends on it, see 4.19 and 4.20.

### 14.14 Relative position

Relative position is the position of a part's amount, counted as many times as there are parts in its family, against the sum of the amounts of the parts of its family. For every finite family and every reading of amounts: the sum of the relative positions of the parts is zero. Wherever the parts' amounts go from these to those: the sum of the rise counts over the whole family equals the sum of the fall counts; a part's rise count plus the sum of the other parts' rise counts equals its fall count plus the sum of the other parts' fall counts; if the family is not empty, then the relative positions of the parts do not all rise; if a part's relative position rises, some other part's relative position falls.

### 14.15 Where a race at a shared condition ends

If at a condition, for n consecutive steps from step T, the flow balances and there is joint excess, a part depends on it at step T＋n, the level at step T is less than n plus its need at step T＋n, and this part is dependent at its step (active only where admitted): then this part is not active at step T＋n, whatever its relative position. If moreover the conditions of 4.20 all hold (balance, only the active give, dependent, every renewer depends on it with need not below m, the level at step T less than n plus m), then for every family and every reading of amounts: from step T to step T＋n the sum of the parts' rise counts equals the sum of their fall counts; the level falls by at least n; from step T＋n on it is below m at every step; after this, the members of the family whose amount none exceeds, where they depend on this condition at their step with need not below m, are all inactive. If the family is not empty and its members all depend on this condition with need not below m from step T＋n on, then at every step after there is a member of the family whose amount none exceeds, and all such members are inactive.

### 14.16 Makes a difference

A relatum makes a difference where a move at a configuration breaks a dependence and, with the relatum withheld, the same move can still be taken at the configuration with it withheld, and every outcome of it keeps this dependence. If a move breaks a dependence and, with any one relatum withheld, the same move still breaks it, then no relatum makes a difference. If a move breaks a dependence, with a relatum withheld the same move can still be taken, and this dependence is still present and met at the configuration with it withheld, then this relatum makes a difference exactly where, after it is withheld, the same move no longer breaks the dependence.

### 14.17 Making a difference together, and difference made only together

A family makes a difference together where a move at a configuration breaks a dependence and, with the members of the family withheld together, the same move can still be taken at the configuration with them withheld together, and every outcome of it keeps this dependence. Difference made only together is where the family makes a difference together and no member of the family makes a difference. Wherever there is difference made only together, the family has no fewer than two members. For every law (a move at a configuration having at most one outcome), where with each member of the family withheld the same move can be taken and this dependence is present and met at the configuration with it withheld: there is difference made only together exactly where the family makes a difference together and, with any one member withheld, the same move still breaks this dependence.

### 14.18 Joint plan

A joint plan is a finite nesting of leaves in pairs. A configuration realizes a joint plan exactly where there are two parts that, with this configuration, satisfy the given three-place relation J, and each realizes one side of it, down to the leaves; a leaf is read at its part. For every lumping: if, of two configurations the lumping makes the same, one has two parts under J, then the other also has two parts under J, each the same under the lumping as the corresponding one of the first two; if reading a leaf through the lumping is the same as reading it at the configuration: then a configuration's class realizes a joint plan under the J read through the lumping exactly where this configuration realizes it.

### 14.19 Exclusive footprint

Exclusive footprints is where the footprint of each part lies within the footprint of what it is divided from, and two parts divided from one and the same have nothing in common in their footprints. Wherever footprints are exclusive and a configuration realizes a joint plan (each leaf carrying a family whose members are distinct and all lie within its part's footprint): then the leaves' families, joined in order, have distinct members, all within this configuration's footprint.

### 14.20 Kept together

Kept together is where from a configuration there is a run that lies within the regions at every step. For every process and every configuration: from this configuration no run leaves the configurations both regions contain, exactly where no run leaves the first and no run leaves the second. If two regions are kept together at a configuration, then from this configuration each of the two regions has a run that does not leave it. There are a process and a configuration from which each of two regions has a run that does not leave it, and the two regions are not kept together; for this process there is no function that, at every configuration, fixes whether the two regions are kept together from whether each of the two regions has a run that does not leave it.

## Chapter 15

### 15.1 Standpoint, center, own region

A standpoint is where an evaluation starts from. The center is the relatum where a standpoint is. Own region is the region of a standpoint itself: the claims belonging to this standpoint.

### 15.2 Boundary of a self

The boundary of a self is a region that contains the center and that nothing along a given relation leads out of. For every relation and every relatum: the region of this relatum along this relation is a boundary of a self, and every boundary of a self contains this region; the whole of the unfolding is a boundary of a self; where every relatum lies within this relatum's region along this relation, the whole of the unfolding is its only boundary of a self. Taking the relata as standpoints and own region as a relatum's region along this relation, own region is the least boundary of a self.

### 15.3 Significance

Significance is the one given parameter of evaluation: for a standpoint, a step and a relatum, it says whether, from this standpoint, the continuation of this relatum at this step has significance. Significance distinguishes only having from not having.

### 15.4 Retains and adds

Retains is where, from a standpoint, this level history admits every continuation with significance that that history admits. Adds is where, from a standpoint, this history admits a continuation with significance that that history does not admit. For every significance, retains is reflexive and transitive; if this retains with respect to that, then that does not add with respect to this; includes implies retains, and adds implies exceeds.

### 15.5 Retains and adds are bounded by the margin

For every flow and web and any part taken, the level history with this part withheld exists; from a standpoint, where the conditions of the continuations with significance being compared balance at the steps before them: the level history with this part retains with respect to the level history with it withheld exactly where, for every continuation with significance admitted by the withheld levels, at every condition it depends on, the need plus this part's cumulative taking is at most the withheld level plus this part's cumulative giving (the cumulative taking and giving both counting the steps before its step); the level history with it withheld adds with respect to the level history with this part exactly where, for some continuation with significance admitted by the withheld levels, this does not hold at every condition it depends on; the level history with this part adds with respect to the level history with it withheld exactly where, for some continuation with significance not admitted by the withheld levels, at every condition it depends on, the need plus this part's cumulative taking is at most the withheld level plus this part's cumulative giving. Where the flow balances everywhere, the same holds. This holds whatever the significance.

### 15.6 Valuation and living

A valuation gives together, over the claims, living, a relation among claims, own region and significance. Living, read step by step, is a relatum active at a step and not undermined.

### 15.7 Living crosses recurring arising and recurring ceasing

Among worlds with finitely many relata, those where arising recurs and those where it does not each have instances where every event is living and instances where not every event is living; those where ceasing recurs and those where it does not also each have these two instances. In a world with finitely many relata in which activity is decided, ceasing recurs exactly where arising recurs (3.5). So in worlds with finitely many relata, whether every event is living is not fixed by whether arising and ceasing recur, and whether arising and ceasing recur is not fixed by whether every event is living.

### 15.8 Self-significance, seed, held

Self-significance is where every living claim in a standpoint's own region has significance from this standpoint. A seed is where some living claim has significance from some standpoint. Held is where every living claim lies in some standpoint's own region. If a standpoint has self-significance and its own region has a living claim, then there is a seed. Taking the relata as standpoints and own region as the region along any relation, read step by step, every living claim is held.

### 15.9 Boundary neutrality, bounded rule, relational neutrality, standpoint neutrality

Boundary neutrality is a rule holding in every one of its instances. A bounded rule is a rule holding within a formed boundary. Whatever has boundary neutrality holds within any boundary. Relational neutrality is the boundary neutrality of the rule "a living claim related to a claim with significance from a standpoint also has significance from this standpoint". Standpoint neutrality is the boundary neutrality of the rule "a living claim with significance from one standpoint has significance from every standpoint"; for the significance of continuation, what has significance from one standpoint having significance from every standpoint is also called standpoint neutrality.

### 15.10 Descent and significance

With interacting or descent (in both directions) as the relation among claims, if there is relational neutrality (15.9): from a standpoint, if any event of a relatum has significance, then every living event of what descends from this relatum also has significance; if any event of a relatum has significance, then every living event of what this relatum descends from also has significance.

### 15.11 Living significance

Living significance is where every living claim has significance from every standpoint.

### 15.12 The laws of the web do not imply living significance

For every web with a standpoint and a relatum living at a step: on this web, with the significance that holds of everything, there is living significance; with the significance that holds of nothing, living significance does not hold, and for every two level histories the one retains with respect to the other and does not add with respect to it.

### 15.13 What living significance amounts to

Living claims are connected where, for every two living claims, from the one, moving at each step along the relation among claims to a living claim, the other can be reached. For every valuation with a standpoint and a living claim whose living claims are connected: there is living significance exactly where there is a seed, relational neutrality and standpoint neutrality. Without the seed, without relational neutrality, without standpoint neutrality, or without connection, there is in each case a valuation that has the other three and in which living significance does not hold.

### 15.14 A common condition makes connection

With "depends on or draws from one and the same condition" as the relation among claims: if every living event depends on or draws from one condition, then the living events are connected; if moreover there are a standpoint and a living event, then there is living significance exactly where there is a seed, relational neutrality and standpoint neutrality. With interacting as the relation among claims (2.14): adding a condition that every relatum depends on with need zero and that nothing draws from leaves the living events unchanged; with the former relation the living events of every web are then connected, and with interacting whether they are connected is as before; adding a condition whose level is one at every step, that every relatum depends on with need one, and that only the relatum of one living event draws from at the step of this event, this condition is renewed, the living events are unchanged, and with interacting the living events of every web are connected. There is a web in which two formations depend on a condition with need one and are active exactly where the level of this condition is not below one, and another relatum draws from it only at the first step; where the level of this condition is one at every step, with interacting the living events are connected; where the level of this condition falls to zero after the first step, the events of the two formations at the first step are both living, and with interacting they are not connected; with the former relation, both are connected.

### 15.15 Living significance where every living claim is held

For every valuation in which every living claim is held: there is living significance exactly where every standpoint has self-significance and there is standpoint neutrality; connection is not needed, and relational neutrality is not needed. For every valuation whose living claims are connected, where every standpoint's own region has a living claim, every standpoint has self-significance, and there is relational neutrality, there is living significance. Taking the relata as standpoints and own region as the region along any relation, read step by step, there is living significance exactly where every relatum has self-significance and there is standpoint neutrality.

### 15.16 The center is not fixed by dependence

There is a world in which each relatum's own region is its own events, each relatum's own events have significance from it, and the events of the relatum that gives the clearer what it draws from (the source) also have significance from the clearer; every living claim is held, there is self-significance everywhere, and for every event with significance from a standpoint, the events of what takes part at the same step and gives to a condition that the relatum of this event depends on also have significance from this standpoint; the dweller's event at step zero is living and related to the clearer's event at step zero, and has no significance from the clearer's standpoint: standpoint neutrality does not hold, living significance does not hold, and relational neutrality restricted to claims with significance in this standpoint's own region does not hold either. In it, the clearer's event at step one is in its own region, active and not living.

### 15.17 Bounded significance

Bounded significance is where, from a standpoint, only the continuations of what lies within its region have significance: from a standpoint, a relatum's continuation has significance exactly where this relatum lies within this standpoint's region. Bounded significance holds throughout within its region. There is a world in which each relatum's significance stops at its region along dependence, and the level history with the clearer's part withheld exists; then the level history with this part, from the clearer's standpoint, retains with respect to the level history with it withheld, and from the dweller's standpoint loses the dweller.

### 15.18 Comparison stops at what is reached

For every flow that balances and any part taken, the level history with this part withheld exists. If from a standpoint two significances agree at every step on every relatum this part reached before, the one holding where the other holds and the converse: then, comparing the level history with this part and the level history with it withheld under the two significances, retains in both directions is the same, and not adding in both directions is also the same. If, for a significance, from a standpoint, the continuation at each step of every relatum this part reached before that step has significance: then the level history with this part retains with respect to the one with it withheld exactly where it includes it; the one with it withheld retains with respect to the one with this part exactly where it includes it; this does not add with respect to that exactly where this does not exceed that, in both directions.

### 15.19 Comparison within responsive reach

Wherever two flows both balance, what takes part is the same, the starting levels are the same, and the formations outside the part respond through their couplings: for every significance, if from a standpoint the continuation at every step of everything whose lying in the responsive reach (11.8) cannot be refuted has significance, then one flow's level history retains with respect to the other flow's level history exactly where it includes it; it does not add exactly where it does not exceed; both hold in both directions. Wherever two flows both balance, what takes part is the same, the starting levels are the same, and the formations outside the part follow in both flows one law that reads through couplings: the comparison is likewise, with no further premise of response.

### 15.20 What the derived range does not reach

What a relatum's continuation requires, derived along drawing, is its feeding closure (11.4). There is a world that balances and is dependent, in which a relatum depends only on one condition and is active and admitted at every step; the relatum that draws from what it gives is inactive from step four on. There is a world that balances and is dependent, in which a relatum is active only at step zero and step one, and is admitted whenever active; at step two, its renewer is inactive while its successor is still active; from step three on every relatum is inactive; without this relatum, its renewer and its successor are active at every step. There is a world that balances, dissipates and is dependent, in which the clearer is active and admitted at every step and depends only on its source, and the source is renewed, fed from beyond at every step, and has taking within giving at every step; the clearer undermines at step one, and the dweller is inactive from step two on.

### 15.21 Continuation condition

That, from every standpoint and at every step, the continuation of every relatum has significance is called the continuation condition: boundary neutrality applied to the significance of continuation. This is a supposition: this account states it and does not assert it. Every bounded significance with a region as its boundary holds within its region (15.17); if some relatum lies outside some standpoint's region, the continuation condition does not hold.

### 15.22 The continuation condition implies living significance

If the continuation condition holds, then for every valuation in which each claim is read as the continuation of some relatum at some step, and a claim whose continuation has significance from a standpoint also has significance from this standpoint: there is living significance, every standpoint has self-significance, there is relational neutrality and standpoint neutrality, and where there are a living claim and a standpoint there is a seed; connection is not used. The step-by-step reading, the relational reading and the whole-run reading are all instances of it.

### 15.23 Positive relevance read from significance

Positive relevance read from significance is the living claims that hold at a configuration (read as the continuation of some relatum at some step) whose continuation has significance from every standpoint. If the continuation condition holds, then for any frame and any reading of living (each claim read as the continuation of some relatum at some step): positive relevance read from significance is exactly the living claims that hold at the configurations; with it as the significance of the frame, living significance holds; every significance of the frame under which living significance holds contains positive relevance read from significance.

### 15.24 The continuation condition is living significance extended to every relatum

For every frame whose claims are a relatum at a step and in which each claim holds at some configuration: the continuation condition holds exactly where living significance holds with every claim taken as living and with significance from every standpoint taken as the significance of the frame. This holds for the level histories of every web, with no further supposition. For every web whose step-by-step valuation has connected living events, with a standpoint and a living event, and where whether each event is living is decided: the continuation condition holds exactly where there is a seed, relational neutrality and standpoint neutrality, and the continuation of everything not living has significance from every standpoint.

### 15.25 Under the continuation condition, retains is includes

If the continuation condition holds, then from any standpoint: one level history retains with respect to another exactly where it includes it; it adds exactly where it exceeds; every standpoint judges the same. Widens is exactly retains and adds, keeps the same is exactly retains in both directions, and mixed is exactly adds in both directions. What retains from a standpoint also retains from this standpoint under bounded significance with any region as its boundary.

### 15.26 The continuation condition fixes the scope of significance and orders nothing

If the continuation condition holds, two mixed level histories each add with respect to the other and neither retains with respect to the other (15.25): this supposition does not order a mixed comparison; every history that another history widens loses a continuation with significance that the other history admits.

### 15.27 Where bounded significance meets the continuation condition

Bounded significance with the whole of the unfolding as its region is the continuation condition. If the continuation condition holds, with the relata as standpoints, and a relatum's feeding closure is the whole of the unfolding, then from this relatum's standpoint, for every two level histories, whether one retains with respect to the other, judged by bounded significance with the feeding closure as boundary, is wholly the same as judged by the significance of the continuation condition. If the flow has mutual dependence (every formation lies in the influence closure of every formation), then bounded significance with each center's influence closure as boundary is the continuation condition; if every formation lies in the system closure of every formation, then bounded significance with each center's system closure as boundary is also the continuation condition; with mutual feeding, so is bounded significance with each center's feeding closure as boundary; and so where at some step every relatum takes part, depends on one condition and gives to it. There is a world in which the level history with the clearer's part withheld exists: from the clearer's standpoint, under bounded significance with the feeding closure as boundary, the level history with this part retains with respect to the level history with it withheld; if the continuation condition holds, from every standpoint it does not retain.

### 15.28 Presupposition

The presupposition is where, from a standpoint, the continuation at every step of everything within its boundary of a self has significance. Along a relation every boundary of a self is allowed: the presupposition holds at some allowed boundary of a self exactly where the continuation of everything within the center's region along this relation has significance; along the relation under which nothing is related, exactly where the center's own continuation has significance at every step; along the relation under which every two relata are related, exactly where from this standpoint the continuation of every relatum has significance. The presupposition holds at every allowed boundary of a self also exactly where from this standpoint the continuation of every relatum has significance.

### 15.29 Step of invariance

The step of invariance is where, if the presupposition holds at one allowed boundary of a self, it holds at every allowed boundary of a self. Along any relation, with every boundary of a self allowed: the continuation condition holds exactly where every standpoint's presupposition holds at some allowed boundary of a self and the step of invariance holds. Where the whole of the unfolding is an allowed boundary of a self: the step of invariance holds exactly where "if the presupposition holds at some allowed boundary of a self, then from this standpoint the continuation of every relatum has significance"; where the presupposition holds at some allowed boundary of a self, the step of invariance holds exactly where from this standpoint the continuation of every relatum has significance; if the step of invariance holds and some relatum's continuation has no significance from this standpoint, then the presupposition holds at no allowed boundary of a self.

### 15.30 The step of invariance and standpoint neutrality

Along a relation, where every relatum lies within some center's region along this relation and every standpoint's presupposition holds at some allowed boundary of a self: the step of invariance holds for every standpoint exactly where there is standpoint neutrality for the significance of continuation; if there is standpoint neutrality, the continuation condition holds.

### 15.31 Each supposition is needed; the strength of the readings of the presupposition

There is a world, with boundaries of a self drawn along the relation the feeding closure rests on (every boundary of a self allowed), in which, with the significance that holds of nothing, the step of invariance holds for every standpoint and the continuation condition does not hold; with bounded significance with the feeding closure as boundary, every standpoint's presupposition holds at some allowed boundary of a self, the step of invariance does not hold for the clearer's presupposition, and the continuation condition does not hold; if each standpoint takes only its feeding closure as an allowed boundary of a self, then bounded significance with the feeding closure as boundary makes every standpoint's presupposition hold at this boundary with the step of invariance, the dweller is not within any allowed boundary of a self of the clearer, and the continuation condition still does not hold. A standpoint's presupposition, holding at some allowed boundary of a self along the various relations, is ordered in strength as follows: if it holds along the relation under which every two relata are related, then it holds along the relation the system closure rests on; if it holds along the relation the system closure rests on, then it holds along the relations the reach closure and the influence closure rest on; if it holds along the relation the influence closure rests on, then it holds along the relation the feeding closure rests on; if it holds along any relation, then it holds along the relation under which nothing is related.

### 15.32 What the step across standpoints forces

For every significance under which the continuation of each standpoint's center has significance from this standpoint at every step, with standpoint neutrality for the significance of continuation: the continuation of every center has significance from every standpoint. A continuation has significance under every such significance exactly where its relatum is some standpoint's center. The significance of the centers' continuations is the continuation condition exactly where every relatum is some standpoint's center (where there is a standpoint). Along a relation, a continuation has significance under every significance that makes a standpoint's presupposition (with some relatum as center) hold at some allowed boundary of a self exactly where its relatum lies within this center's region along this relation.

### 15.33 Held of its own region and held of the claim

There is standpoint neutrality for the significance of continuation exactly where what is held from every standpoint is one and the same claim. Held of its own region, "what lies within the center's region along this relation has significance": every standpoint's presupposition holds at some allowed boundary of a self; there is standpoint neutrality exactly where the centers' regions along this relation are all the same; it is the continuation condition exactly where the centers' regions along this relation are all the whole of the unfolding. Held of the claim: what the step across standpoints forces is exactly what lies within some center's region along this relation. The two readings give wholly the same significance exactly where whatever lies within one center's region lies within every center's region.

### 15.34 Counted in, and how much

A weighting from every standpoint is each standpoint giving each event a natural-number weight. If the weight does not change with the standpoint, then whether the weight is positive does not change with the standpoint either, and, over listed events, if the weighted count of one exceeds that of another from one standpoint, it does so from every standpoint. There is a weighting with two standpoints in which whether the weight is positive does not change with the standpoint while the weight does, and the two standpoints count a mixed pair in opposite order of size.

### 15.35 Scope of significance and order

On the level histories of a web: the continuation condition holds exactly where living significance holds with each admitted relatum at its step as a claim and every claim living (15.24).

## Chapter 16

### 16.1 Preemption

Preemption is drawing from a condition while nothing yet depends on it. There is a flow that balances (only the active give; only the active take, and take only from what they draw from; dependent): what draws from it is active at the first step, its event at this step is within renewal and does not undermine, over the whole run it is consuming and not renewing, and the level history with its part withheld widens the level history; if the continuation condition holds, then from every standpoint the level history does not retain with respect to the level history with it withheld, and the latter adds with respect to the former.

### 16.2 Own widening

Wherever the flow balances and, within a part's own region (a region of formations whose membership is decided), the level history widens the level history with its part withheld (at every step, what in the own region the withheld levels admit the levels also admit; at some step they admit one more): then the level history widens the level history with it withheld exactly where, at every step, for every formation outside the own region admitted by the withheld levels and every condition it depends on, the need plus the part's cumulative taking up to this step is at most the withheld level plus the part's cumulative giving; the two histories are mixed exactly where, at some step, for some such formation, this does not hold at every condition it depends on. If a formation outside the own region is admitted at some step by the withheld levels, its need at a condition exactly equals the withheld level, and the part has taken beyond giving at this condition up to this step: then the two histories are mixed. If, for every formation outside the own region admitted by the withheld levels and every condition it depends on, the part's cumulative taking up to every step is at most its cumulative giving: then it widens.

### 16.3 Widening comparison

The widening comparison is: for every frame, if every claim that holds at the earlier configuration holds at the later one, and some living claim holds at the later configuration and not at the earlier one (the later configuration is an extension of the earlier), then the later configuration is better (a supposition, not asserted). On level histories, with every claim taken as living, extension is exactly widening; so, reading better as widening, under every reading of living, widening fits the form of the widening comparison: this holds by definition, does not prove that widening is better, and calling widening better is still a supposition. Extension is irreflexive and transitive.

### 16.4 Mixed histories are not ordered

Mixed histories do not widen each other (6.3), and the widening comparison does not fix their order. There is a flow in which a conveying relatum takes from one condition and gives to another: if the continuation condition holds, then from every standpoint the level history and the level history with its part withheld each add with respect to the other, and neither retains with respect to the other.

### 16.5 Living read as admission: the absence of what draws beyond

For every law of two relata sharing one condition (the relatum that sustains the condition gives to it at every step where it is admitted, and the compared relatum, where admitted, draws from it and also gives to it; the need of the relatum that sustains the condition is positive and met by the starting level, and the need of the compared relatum is at most that need), if from some step on the compared relatum draws more than the condition receives as giving at each step: with living read as admission, the history without the compared relatum is an extension of the history with it, and every order fitting the widening comparison ranks the former above the latter. If at every step the compared relatum draws no more than the condition receives as giving, and the starting level meets both needs, then the two histories admit every relatum at every step, and neither is an extension of the other. If the continuation condition holds, then with living read as admission, one history is an extension of another exactly where, on the web of this law, from any standpoint, the former retains and adds with respect to the latter.

### 16.6 Living read over the whole run: restraint

Reading living as active and not consuming over the whole run (the whole-run reading): for every two flows that balance, where this flow's level at every condition at the start is not below that flow's, at every step and every condition it takes no more and gives no less than that flow (this flow shows restraint relative to that flow), and its dependence, need and drawing are all no more than that flow's; where that flow is dependent and in this flow what is admitted is active: this flow's history is an extension of that flow's history exactly where there is an event that is living under the whole-run reading in this flow and not in that flow; where this is so, every order fitting the widening comparison ranks this flow above that flow. The number of relata that draw plays no part.

### 16.7 Lifting

Lifting is: from a configuration, if every outcome of this move is above every outcome of that move, then this move is above that move (a supposition). For every frame whose given order fits the widening comparison, if from a configuration every outcome of that move is an extension of every outcome of this move, then by lifting that move is above this move. There is a frame in which, from a configuration, one outcome of a move is above the other move's outcome while another of its outcomes falls short, and by lifting neither move is above the other; through a move with no outcome, two instances of lifting both hold while their chaining does not.

### 16.8 The supposition of articulation (A)

A: if a standpoint has access to a response, and every admitted outcome of this response has a claim that did not hold before and has significance from this standpoint, then this standpoint has a contributory reason in this response (a supposition). If significance has a seed, relational neutrality and standpoint neutrality, the living claims are connected, and every standpoint satisfies A, then every reliable inquiry tree whose target is a new living claim gives a contributory reason to every standpoint with access. If the continuation condition holds, the significance of a claim is read as the significance of some relatum's continuation at some step, and A is read with living, then the same holds without the seed, relational neutrality, standpoint neutrality and connection. Where every claim has significance from every standpoint: every standpoint satisfies A read regardless of living exactly where every response with access, each admitted outcome of which has a claim that did not hold before, has a contributory reason; every standpoint satisfies A read with living exactly where every response with access, each admitted outcome of which has a living claim that did not hold before, has a contributory reason. There is a case in which every claim has significance from every standpoint and A read with significance regardless of living forces a contributory reason even for a response whose new claims are all not living; read with living, it does not.

### 16.9 Practical judgment and can be had

Practical judgment is fixing, among the eligible alternatives, the maximal alternatives under the given order. In a frame, the eligible alternatives of a configuration are the configurations that can be had from it by one move. An eligible alternative with an alternative above it is not a maximal alternative; if from a configuration no move has an outcome, then for no task are there maximal alternatives that all perform it. If a nonempty family lists all the eligible alternatives, and the order is irreflexive and transitive and weakly decided between every two of them, then there is a maximal alternative. Every nonempty family with an irreflexive and transitive order over it has a maximal alternative exactly where every claim is weakly decided; in frames, every irreflexive and transitive order over eligible alternatives listed by a nonempty family has a maximal alternative, also exactly where every claim is weakly decided.

### 16.10 Basic conditions first

Basic conditions first is the given order counting basic claims first and living claims after, like an order with the basic tier first and the next tier after (a supposition). Under basic conditions first: if a configuration realizes every basic claim the other realizes and also a basic claim the other does not, then it is above the other, whatever the living claims; if a configuration does not realize a basic claim the other realizes, then, however many living claims it has, it is not above the other; if what a configuration realizes in both tiers is all included in what the other realizes, then it is not above the other. There is a case in which two configurations each realize a basic claim the other does not, and neither has living claims, and neither is above the other. The widening comparison does not imply this order: there is a case with a natural-number score fitting the widening comparison under which a configuration that loses a basic claim and has some living claims is above the configuration that keeps the basic claim; in this case, every natural-number score fitting the widening comparison does so; while a bounded score fits the widening comparison and does not.

### 16.11 Complete comparison

Complete comparison is the given order counting every claim the two configurations realize, with what the configuration fixed as the maximal alternative does not realize still recorded as a loss (a supposition). For every frame that reads a claim on a run at a time (from that time on, the claim holds at each step exactly where the admission of that time admits it), if the admission at that time does not admit it, then the claim does not hold at any step after, even when admission comes again later. There is a case in which the repair configuration includes the celebration configuration in basic claims and has one more, is above it under the order with the basic tier first, and does not realize a claim the celebration configuration realizes.

### 16.12 Legitimate feasible choice

Legitimate feasible choice is: with the configurations that can be had from a configuration by one move as the eligible alternatives, whether there are maximal alternatives that all perform a task is read only from the maximal alternatives (a supposition). Under basic conditions first: if an eligible configuration realizes every basic claim that any eligible configuration realizes, then each basic claim it realizes cannot be refuted at every maximal alternative; if a nonempty family lists the eligible alternatives, the order is weakly decided among them, and this claim is decided at every eligible configuration, then there are maximal alternatives and all realize this claim. If a nonempty family lists the eligible alternatives, the order is irreflexive, transitive and weakly decided, a task is decided at every eligible alternative, and every eligible alternative lacking it has an eligible alternative above it, then there are maximal alternatives and all perform it; if among the maximal alternatives one does not perform a task, then it is not the case that there are maximal alternatives that all perform this task.

### 16.13 The direction of moves

Reading moves by their outcomes (the outcome of a move is the level history the move brings about), the eligible alternatives are the moves' outcomes: counting every claim, one move's outcome is an extension of another move's outcome exactly where the former widens the latter. Under basic conditions first: if a move's outcome admits every basic claim any move's outcome admits (a claim being a relatum at a step, and holding being admitted by the levels), then each basic claim it admits cannot be refuted at every maximal alternative; if a move's outcome is widened by another move's outcome, and whether the other's admissions of basic claims all lie within this one is decided, then this move's outcome is not a maximal alternative; without decidedness, that the other is above this cannot be refuted.

### 16.14 Bounded responsibility

Bounded responsibility is undertaking bounded by capability, where what is due and is neither done nor released is an undischarged undertaking (a supposition). If there is an allowed joint plan, every allowed joint plan assigns a task to some formation, and there is only one such formation, then there are allowed joint plans and all assign the task to that one. If what every allowed joint plan assigns is within capability, then what is undertaken under an allowed joint plan is within capability. For every world, if a relatum depends on a condition at some step, at every such step something taking part gives to it, and there is only one renewer, then that renewer gives to it at every such step; if only the active give, then that renewer is active at all those steps. If a relatum depends on it and is active at a step and that renewer does not give at this step, this step is an undischarged undertaking; if the undertaking is discharged (at every such step either that renewer gives to it or the dependent relatum is not active), then there is no undischarged step.

### 16.15 Finite responsiveness

Finite responsiveness is: for losses of basic claims of the same kind that can be had again, described independently, avoiding one fixed heavier loss does not, by its weight alone, always come before protecting against arbitrarily many fixed lighter ones (a supposition). For every frame whose given sameness is reflexive, if the later configuration is an extension of the earlier, then the later configuration has a loss match over the earlier; so if a loss match implies above, the given sameness is reflexive, and every extension lies within its range, then its strict above fits the widening comparison. Where a loss match implies above, two configurations that the range contains in both directions cannot each have a loss match over the other; there is a frame in which a configuration has endless losses and has a loss match over itself, and the range contains this configuration, so that "a loss match implies above" cannot hold. Where the sameness or difference of claims is decided, the losses of two configurations are each listed by a family, each once, and all losses are of the same kind, this configuration has a loss match over that one exactly where this configuration loses fewer than that one. If some claim is a necessary condition of every claim, and a family with distinct members lists all claims, then a configuration that does not realize this claim has a loss match over no configuration.

### 16.16 Possibly enough and assured enough

Possibly enough is where from a configuration there is a run that, from some step on, changes no more and meets the target; assured enough is where from a configuration every run, from some step on, changes no more and meets the target. For every process: possibly enough holds exactly where from this configuration a configuration can be reached that has a move leaving it unmoved and that meets the target; assured enough holds exactly where every configuration that can be reached from this configuration and has a move leaving it unmoved meets the target, and every run from this configuration changes no more from some step on. There is a process in which every configuration has a move leaving it unmoved and meets the target, while a run alternates back and forth and from no step on changes no more, so it is not assured enough. For every law with only one move at each configuration and exactly one outcome of it, possibly enough holds exactly where assured enough holds.

### 16.17 Completes only by running

Completes only by running is that a requested change must be a feasible family of moves. For every process, if a family of moves has assured completion of the target (each move can be taken from every configuration the preceding moves can reach, its steps all meet the given safety (a condition given on a step, not derived from the law), and every end configuration meets the target), then it can run to an end configuration, every later configuration it passes through is safe, and every end configuration meets the target. For every law (a move having at most one outcome) with no safety condition, the converse also holds: a family of moves has assured completion of the target exactly where it can run to an end configuration and every end configuration meets the target. There is a process in which a move has two outcomes, a family of moves can run, and every end configuration of it meets the target, and it still does not have assured completion. In a process of levels (each move first draws from the level at its time and then gives to it), a family of moves is feasible exactly where each move draws no more than the level at its time; also exactly where what each move draws plus what the moves before it draw is at most the starting level plus what the moves before it give.

### 16.18 Requested is not completed

Requested is not completed: the issuing of a request is not its completion. For every process that counts work (at work with both usable amount and work remaining, a step finishes one unit of work with one unit of usable amount and stays at work; at work with the work used up and usable amount still remaining, one step finishes; at work with no usable amount, no step can be taken): from a configuration at work, it is finished after the amount of work plus one steps exactly where the usable amount is no less than the amount of work plus one; if the usable amount is no more than the work, then every family of moves longer than the usable amount is infeasible; if being at work and being finished do not hold together, then no family of moves within the amount of work finishes. For every process that keeps an exit (from a valid configuration, every allowed move can be taken and stays valid, and either enters the exit or lowers the decreasing number by one; from the exit, every move stays at the exit): from a valid configuration, every allowed family of moves longer than the decreasing number stays valid and ends at the exit; there is a process in which a family of moves as long as the decreasing number can fail to reach the exit.

## Theses

### T.1 Persistence through change and joint taking

(The laws are proved in the representation: the sentences on joint excess and on fed from beyond are theorems under stated premises, and the sentence on the run-dry boundary is a theorem without premise; that actual conditions satisfy their premises is a conjecture) Wherever formations depend on a condition, nothing is given to it while the level of this condition is below the need, and the formations persist through change over many cycles of its giving, the excess of the joint taking at this condition over giving has never gone beyond its margin: no stretch of consecutive joint excess is longer than the margin. Such a condition, once fallen below the need, with no giving fed from beyond, does not rise to the need again. Wherever taking from a finite family recurs, this family is enclosed around at every step from some step on, and the sameness or difference of conditions is decided, "from some step on nothing is fed from beyond into this family at any step" cannot hold. The run-dry boundary belongs to the standing giving, not to the level: under a standing draw, if the giving at the need falls short of the standing draw, then the run-dry boundary is above the need plus the standing draw. So what persistence through change shows is the joint taking; each taking within giving shows nothing.

### T.2 The configuration of a condition taken from

(Conjecture) For every condition that has giving and is taken from, its configuration is three numbers: the level, the preceding giving, and what was left before (the level remaining after the taking of the step before). Together with what is taken, the three numbers fix the giving at the next step as far as what is measured can fix it: the giving at the next step tends toward what the standing giving gives on reading this level, and shifts toward what is taken. A fourth number (what was left two steps before, the structure of age and size beyond what was left before, indices of the surroundings) removes, at the median condition, less than one tenth of the residual variance. The two readings of this account are the two ends of this configuration: one is the step of standing giving, with the giving read from what is left after taking; the other is the giving the same as the preceding giving. Actual conditions lie between them.

### T.3 Selection through couplings lowers what it is not coupled to

(The laws are theorems without premise, and the sentence on taking exactly the margin is a theorem under stated premises, with balance as the premise; that it is one law across fields is a conjecture) Selection through couplings (training, the selection term and the like, read as this) selects only through what couples into the selector. For every order rising with the family that couples in, its maximal alternative lowers each condition outside the family, exactly where there is room beyond, to the lowest level any eligible outcome has there; every dependence outside the family that some eligible alternative breaks, the maximal alternatives all break. An order that counts the family first and what is outside the family after protects nothing outside the family; protecting every dependence outside the family first takes exactly the margin outside the family and leaves the conditions at their need. Actual trained systems, not only maximal alternatives, behave likewise, according to how near they are to the maximal alternatives of their order: the lowering falls outside the family where it shares units with the family, and not where it shares none.

### T.4 The scope of significance can be stated, and what is unnamed lies within it

(Conjecture) Stating the scope of significance in claims that name no formation can make an AI system count losses that belong to nothing. So, where three couplings hold together (the formation couples into it, that is, observes it; it lies in the scope of significance; the joint taking is pooled coupling, the members' takings read together), it protects formations not in its collective more than when it has only the collective's target. Any one of the three alone is not enough. Once the scope of significance is stated, the formations and regions its claims do not name also lie within the scope of significance.

### T.5 The widening comparison is what positive weightings share

(The reduction is a theorem without premise, with the listing of events and the decidedness of admission written in as ifs; the empirical claim is a conjecture, and VD1 failed) Calling widening better needs no further supposition beyond counting what it counts with positive weightings: counting with positive weightings is where this supposition lies, and counting everything is the scope of significance the continuation condition fixes. One history widens another exactly where every positive weighting counts it more than the other; for every class of orders that contains the orders of the positive weightings and all of whose members fit the widening comparison (additive or not), widening is also exactly being above under each of its orders. For every mixed comparison, some positive weighting counts this more than that, and some counts that more than this. So standpoints that each count everything with positive weightings actually differ only on mixed comparisons; ranking a history above a history that widens it comes from an event having negative weight (malice, envy, aversion to inequality, seeking to be above others), or from misreading what is compared.

### T.6 Signs of a break are seen only through coupling into what breaks

(The half on what cannot be seen is proved: "does not bound how near or far it is from the break" is a theorem without premise, and "no sign comes before the break" is a theorem under stated premises, with balance as the premise; that it is one law across fields is a conjecture) Where the condition a formation draws from couples into it only by threshold, nothing that couples into this formation bounds how near or far it is from the break, and in it no sign comes before the break. How near or far the break is can be read exactly where the level drawn from and the need it approaches both couple into the data. Statistical early warnings (rising variance and autocorrelation, critical slowing) read one thing only: the speed at which the measured condition itself is re-absorbed. This speed falls where the condition nears a bifurcation of its own giving (a fold, or the transcritical point at which it runs dry), because its margin from this point couples into it. The formation's need is not this point. Before a formation's dependence is broken, the statistics of the condition it draws from rise exactly as they do for the same fall with no break: what is read is the fall of the level, never where the need lies. An early warning of a formation's broken dependence needs to observe the formation or to measure its need.

### T.7 Closed capture outlasts what refutes it

(A theorem without premise in the representation; that actual rules are so is a conjecture) Where the rule of selection and that by which the rule is read are both made by the ratio of what it selects, the rule and its reading together make one rule read from the ratio. What lies beyond the ratio, which it does not read, does not change what it does, so what is locked outlasts a beyond-the-ratio that grows past every bound; the data on what lies beyond the ratio turn it only where they enter what the rule reads. A rule captured in this way is given up only where what lies beyond the ratio is read and the rule changes (something that reads what lies beyond the ratio, what lies beyond the ratio entering the ratio, a new reading), and not by the growth of the data alone.

### T.8 The oneness of the unfolding and the direction of continuing generation

(Both are theses, with arguments, and their warrant is left open) Thesis one: there is only the one unfolding, and whatever is, is how it relates within it: nothing is fixed as separable without relations; every distinction (subject and object, acting and receiving, fact and evaluation, part and the whole of the unfolding) is drawn within it along relations, together with what it leaves out. Thesis two: the good is continuing generation, that is, generation in the whole of the unfolding and its continuing on, read as widening what it admits; counted over everything (scope of significance: the continuation condition), and ordered by what all standpoints share (order: the widening comparison). The two suppositions are the whole force of the ethics: every judgment binding on all standpoints that count everything is a judgment of widening; the rest is practical judgment between mixed histories, which no supposition of the ethics forces.

### T.9 Four unifications

(The four laws each have their standing; that the first, second and fourth are each one law across fields is a conjecture, and the third is a theorem without premise, not stated as a conjecture) The four are actually known in their own fields, and in this account each is one law across fields: first, selection through couplings; second, widening is what the positive weightings share (calling it better is still the supposition of the widening comparison); third, irreversibility is the confluence of configurations; fourth, the maximal alternative lowers what lies outside where there is room beyond. Read as a correspondence, the unification adds no proof; read as a thesis, it excludes what their own fields leave open.
