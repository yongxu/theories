# The root: continuation relative to a class

**Thesis.** Whatever goes on is conditioned by what came before it and stays alike to it in some respect. The chapter takes one relation, read as condition (缘, *yuán*), and one class, read as sameness (类, *lèi*), and shows what their meet, continuation (续, *xù*), carries: beginning, abiding, altering and ending are positions relative to a class, none standing alone; under a class constant for the relation no continuation ends; the core (核, *hé*) of a class, the greatest symmetric relation within it that the relation never tells apart, always exists; renewal is a line started by another, and at a coarser grain a pattern continues while its parts begin and end. Processes and the World model are models of this grammar. Claimed: these laws, for every carrier, relation and class or on a named model; that the reading explains how things go on is argued from them, not proved. Open: that every becoming has a faithful representation in the grammar.

**Where this chapter sits.** It takes nothing from the others and hands its grammar, classes and models to all of them: first to [the map](02-MAP.md), which reads renewal at two grains as generation, keeping and degeneration, and to [knowing](03-KNOWING.md), which takes the core and likeness into testing within the net. Every later chapter reads its subject as continuation relative to some class: which relation, which class, at which grain, constant or not.

**Bases.** **Theorem** (root): every carrier, relation and class, in [`Becoming.Grammar`][Grammar] or a grammar module; (any process), (any type): every step relation or type, not yet in the grammar's vocabulary; (the steps): every determination of the natural-number steps; (World): the World model, its premises named; (periphery): with Mathlib, its axioms reported; a witness is one constructed example, labelled as one. A **Calibration** needs an omniscience principle and says what the need says about the unfolding; a **Reading** changes no theorem ([08](08-METHOD.md)). Every pure-core declaration named here has an empty axiom report, which concerns logic only; the real assumptions lie in the modelling commitments ([§10](#modelling-commitments)). Where the chapter touches evaluation (§8.3, §9, §9.9), the ethics' two premises keep their roles: the continuation condition fixes scope and C (calling widening better) fixes order, neither asserted ([07](07-SIGNIFICANCE.md)).

**What is claimed.** The grammar is a relational calculus: its general theorems hold of every carrier, relation and class, and its witnesses are single constructed models. That reading a subject as continuation relative to a class *explains* how it goes on is the theory's claim, argued from the laws on the models (here and in 02–05), not a theorem of the grammar. Three things are kept apart: one kind of relational expression, which the grammar gives; the World model's continuation family read in the grammar, which instance theorems connect (§8.6); and a faithful representation of every becoming, and of the whole theory, in the grammar, which is open ([Open](#open)).

**Not assumed.** That becoming is good; inevitable improvement or universal growth; a fixed common utility; independent owners of value; that every change is generation; a definite global causal order at every interface (the laws of one step, totals, counts and recurrence use only the order of change, rates being relative to the reading's unit, §9.6). Degeneration, ending and mixed change belong to the same unfolding and are not renamed generation.

<a id="one-kind-of-symbol"></a>
## 1. One kind of symbol

The grammar has one kind of symbol, a relation between occurrences, and builds everything else from relations by a few operations; every theorem is stated for every carrier and relation, so no frame or kind of thing is chosen before the relations. Nor is a time: its order is the reach of the condition relation, a strict order where that relation has no cycle (below). Time and the four positions (§3), whose statements use no equality, tell two occurrences alike in every relation apart only by equality on the carrier, a commitment of the model: a stationary process has two moments alike in every relation, which nothing but that equality tells apart.

**Definition.** A relation (际, *jì*) on a carrier `α` is a two-place predicate, `«际» α := α → α → Prop`, with these operations:

| Name | Reading |
|---|---|
| 而 | composition: first `R`, then `S` (`R;S`) |
| 逆, 合, 非 | converse (`R˘`), meet, complement |
| 则, 谓 | inclusion; pointwise equivalence, the form of a definition |
| 一, 静 | the full relation ("the one"); identity, the change that stays in place |
| 及 | reach: the transitive closure, each witness a finite chain |
| 无环 | without cycles: nothing reaches itself; a condition a net may meet, not a claim that it does (below) |

The carrier is a parameter of the statements, not a claim that its elements exist apart from their relations: a theorem says nothing of an element beyond how it relates. Equality on the carrier is a commitment of the model, and the statements that use it (identity as a class, the two-block class of a single condition, fission, the flame) say so; the merge uses none. Every result is pointwise, so no extensionality enters, and the grammar imports only Lean's prelude.

**Definition** (the main reading). `R x y` is read as 缘: `x` is a condition of `y`, among what `y`'s coming about comes from. Conditions may be many-to-many, mutual and simultaneous. Each model declares how its net is read: in one history an occurrence's successors are its co-occurring effects; in a net of possibilities they are alternatives, with a conflict relation beside the net. Constancy and the core (§4) are the same formulas under both; a test by what would happen "after the window opens" has sense only in a net of possibilities ([03](03-KNOWING.md#r-testing-within-the-net)).

**Theorem** (root). Without cycles, reach is a strict order: irreflexive, transitive and asymmetric (`«无环则及为序»`). Where two occurrences condition each other, they are co-present and reach is no longer a strict order (`«相由则俱有»`); co-presence (俱有, mutual reach) is symmetric, transitive and reflexive on what it relates, one cluster inside which precedence is not defined (`«俱有为一念»`, [GrammarCandidates][GrammarCandidates]). That every condition strictly precedes what it conditions holds exactly where the net has no cycle (`«缘先果后当且仅当无环»`, [06](06-CLASSICAL-TEXTS.md#r-candidate-theorems-of-the-corpus)).

Without cycles is a condition a net may meet, not a claim that the unfolding meets it: the laws that use it take it as a hypothesis. Whether a net with feedback meets it depends on what the model takes as an occurrence. Where each occurrence is dated, one per step, feedback makes no cycle: in a heated room the temperature at one step is a condition of the thermostat's reading at the next, the reading of the heating, and the heating of the temperature later, each another occurrence. What comes round is the class: the later temperature continues the earlier under the class of this room's temperature, so a feedback loop is a line returning to a class, not an occurrence reaching itself. The loops of [the map](02-MAP.md#r-how-a-carried-difference-grows), where a loop upstream and only a loop makes a difference run away, are of this kind: couplings between conditions across steps, on the World model. Where a model takes states as its occurrences, as the warm room that goes on as it is in [knowing](03-KNOWING.md#r-testing-within-the-net) does, or two occurrences condition each other with no step between them, the net has a cycle, and the laws above read it as co-presence: one cluster within which precedence is not defined, not something reaching back into its own past.

The corpus's own definitions (化, 成坏, 同, 复, 通) are written in this grammar in [the classical chapter](06-CLASSICAL-TEXTS.md#r-classical-definitions-in-the-grammar).

<a id="class-and-continuation"></a>
## 2. Class and continuation

Whether two moments of fire are "the same" depends on the sameness asked: the same burning, wood or shape of flame. The grammar does not choose: it names the class and says everything relative to it.

**Definition.** A class (类) is a reflexive, symmetric and transitive relation (`«类»`); the full relation is one (`«一为类»`). **Reading** [AI reading, D45]. The class is plural. The 墨经 names four samenesses (重, 體, 合, 類), each a class once the whole, place or respect it relies on is fixed; 類同, 「有以同，類同也」 ([《墨经·经说上》][Mojing]), is not transitive until its respect is fixed (`«同于不必传递»`; [06, §二](06-CLASSICAL-TEXTS.md#corpus)).

**Definition.** Continuation (续): `y` continues `x` under the class `E` where `x` is a condition of `y` and the two are alike under `E`, `«续» R E := R ⊓ E`; the criterion is `E` and no other choice enters. A line (相续) is the reach of continuation, and a family (同族) its equivalence closure, every occurrence joined to another by continuation read either way. The line from `x` never ends (不穷) where every occurrence it reaches has a successor; that an endless chain then exists is a further step, which takes dependent choice.

<a id="r-continuation-relative-to-a-class"></a>
**Theorem** (root). For every carrier and relation, continuation is contained in 缘 and every line runs along the reach of 缘 (`«续含于缘»`, `«相续含于及»`). Under the full class continuation is 缘 itself (`«一之续»`), and under a coarser class every continuation remains one (`«粗化»`). A line under a class stays within it, its ends alike (`«线内同类»`), and the family is a class (`«同族为类»`). These are the first laws of [continuation relative to a class](../results/records/continuation-relative-to-a-class.md); its further laws follow in §§3–6 and its instances on the World model in [§8.6](#instances). Its only hypotheses: each class an equivalence, and equality on the carrier where identity serves as a class.

Continuation is a relation, not an identity. Three theorems (root) show what that leaves open:

- *Every single condition is a continuation under some class*, the class with two blocks, its two ends and the rest (`«任一缘可为续»`): containment in 缘 is necessary only, and to keep the conditions that maintain something a sub-relation of 缘 is named.
- *A merge*: two conditions of one occurrence, each alike to that occurrence under the class, are both continued by it (`«蜡烛之合»`), as one candle's heat is among the conditions of another's first flame.
- *Fission* (a witness): where one occurrence is continued by two that go no further, sameness read along lines either way is not transitive (`«分叉»`). The family gathers the branches; it is coarser than identity.

Continuation is not defined through the core (§5): its criterion is the class, and the core is asked of a line.

<a id="four-marks"></a>
## 3. The four marks

An occurrence in a line either continues something or not, and is either continued or not. Those two questions fix its position, and the answers depend on the class.

**Definition.** Under a class `E`, an occurrence begins (生) where it continues nothing, ends (亡) where nothing continues it, and abides (住) where something precedes and something follows it. `y` alters (异) from `x` where it continues `x` under `E` while another class `F` (in use, a finer one) tells the two apart. An occurrence with neither predecessor nor successor is a flash: it begins and ends.

**Theorem** (root). Beginning and abiding exclude each other, and so do abiding and ending (`«生住不并»`, `«住亡不并»`). Under the full class an occurrence begins exactly where nothing conditions it (`«一之生»`).

**Theorem** (root). *No mark stands by itself.* In a net where nothing conditions itself, an occurrence with a condition and a consequence abides under the one and, under identity, both begins and ends (`«四相无自立»`): one occurrence holds different positions at once, each relative to a class. **Theorem** (World). A formation arising across one step and ceasing across the next is, at the step between, abiding under the one and beginning and ending under identity and under activity (`Web.flash_positions`).

**Theorem** (root). *Coarsening.* What ends under a coarser class ends under the finer, and what abides under the finer abides under the coarser (`«亡于粗则亡于细»`, `«住于细则住于粗»`); what begins under the coarser begins under the finer (`«生于粗则生于细»`), and a beginning under the finer continued under the coarser is an alteration (`«生于细而续于粗则异»`). The converse fails (a witness): an occurrence can end under the finer class and not end under the coarser (`«亡于细者不必亡于粗»`). This is the shape of a fire passed on: the wood ends, the fire goes on.

**Theorem** (root). *A change between the ends has a place.* For a class `K`, where every step of continuation either keeps `K` or carries a mark `P`, a line whose ends `K` tells apart has a step carrying the mark, placed on the line between them (`«两端分则中有标»`); the proof uses only the transitivity of `K`.

**Calibration** (root). That every occurrence, in every model, either begins or has a predecessor is exactly excluded middle (`«四相之定当且仅当排中»`): whether an occurrence has a predecessor under a class, and so begins, is decided only where going on is. The marks are not a partition even where this is decided: a flash begins and ends, and alteration relates two occurrences under two classes. On the steps, what holds and ceases at no later step holds on wherever each later step's position is decided (`persists_of_positions`).

<a id="r-negation-change-and-stable-cases"></a>
**Theorem** (the steps). For every determination `p`, what ceases to be is the coming to be of its negation, and what comes to be is the ceasing of its negation, with no premise (`CeasesToBe.not_comes`); read back, from the negation's change to the determination's, it holds wherever the determination is stable (double negation eliminable) where it is read (`ComesToBe.of_not`). **Theorem** (any type). A conclusion following both from a proposition and from its failure holds wherever the conclusion is stable, the proposition left undecided (`Decided.cases_stable`); that negations and equations of numbers are stable is a fact of the logic, not a theorem here. **Theorem** (World). A formation ceasing is the beginning, at the next step, of a line of inactivity (`Web.ceases_iff_inactive_sheng`; [record](../results/records/negation-change-and-stable-cases.md)).

<a id="constancy-and-core"></a>
## 4. Constancy and the core

Some classes are carried by the relation: whatever one member becomes, a member alike to it becomes something alike. Others are not: occurrences alike now go to unlike futures, and the line has a regularity finer than its class.

**Definition.** `E` is constant under `R` (有常) where `E˘;R ⊆ R;E˘`: where `u` is alike to `u'` and `u` conditions `v`, `u'` conditions some `v'` alike to `v` (`«有常之逐点»`).

**Theorem** (root). *Constancy never lets a continuation end.* Under a relation `E` constant for `R`, symmetric or not, whatever continues something is itself continued (`«有常则续不尽»`). So under a constant class a line never ends after its first step (`«有常则相续不尽»`), and a class under which some line ends is not constant (`«有亡之续则不有常»`). Whether a line that ends has its own regularity cannot be asked as whether its class is constant: it never is.

**Definition.** The core (核) of `E` under `R` relates two occurrences where some symmetric relation inside `E` that is constant under `R` relates them.

**Theorem** (root). *The root theorem.* The core lies inside `E`, is constant and symmetric, and contains every symmetric constant relation inside `E`: it is the greatest one (`«根»`). The core of a class is a class (`«核为类»`), and a finer class has a finer core (`«核之单调»`). A class is constant exactly where it lies inside its own core (`«类有常当且仅当含于核»`). So the core is the greatest matching relation within the class, and it always exists.

**Reading** [AI reading, D65]. The core is what continues of its own, the regularity a line carries by itself. The reading interprets indistinguishability under matched conditioning; it asserts no causal independence of an occurrence and no mechanism of self-maintenance.

**Theorem** (root). *Closure.* For a class `E`, constancy is exactly that `R` read through the class adds nothing, `E;R;E ⊆ R;E`: what an occurrence's class conditions is fixed by the occurrence's own conditions, without looking at the rest of its class (`«闭合当且仅当有常»`). The relation `E;R;E` keeps the conditions inside a class; the coarse net of §6 drops them. For a class this is bisimulation equivalence, with the lumpability of Markov chains and computational closure as analogues not proved here.

**Definition.** The core read both ways (位核) relates two occurrences where some symmetric relation inside `E`, constant under `R` and under its converse, relates them: nothing that conditions them, and nothing they condition, tells them apart.

**Theorem** (root). *Beginning, abiding and ending are read off the two-way core.* The two-way core is the greatest symmetric relation inside `E` constant both ways (`«位根»`) and lies inside the core (`«位核含于核»`). For a class, ending is not told apart by the core (`«亡于核下不变»`) and beginning not by the two-way core (`«生于位核下不变»`), so what shares a position under the two-way core shares beginning and ending (`«位同则生亡同»`), and abiding too (`«位同则住同»`). Altering is a relation between two occurrences with a finer class, not a mark of one occurrence, and is not read off the core. A position is fixed by all its relations, before as well as after.

<a id="r-a-regularity-kept-and-changed"></a>
**Theorem** (root). *A kept regularity can always be kept, and a line ends only by a step that leaves it.* From a step continuing under the core of `E`, every occurrence its line under the core reaches has a successor under the core (`«守理则不穷»`), and a line along which the core is kept leaves its last occurrence continued under `E` (`«守理之线不亡»`). A step into an end under `E` leaves the core, for every relation `E` (`«亡前理变»`), and so does the last step of every line under `E` that ends (`«有亡之线末步离核»`); where `E` is a class, the two ends of such a line lie in different classes of the core (`«有亡之线两端理异»`). These are corollaries of the root theorem and of constancy never letting a continuation end; what they add is where the core is left, at the last step, found with no decision. So what goes on for a while and then ends is a class that does not hold by itself, whose line passes from one class of the core to another before it ends, while the core always admits continuation ([`Becoming.GrammarRegularity`][GrammarRegularity]; [record](../results/records/a-regularity-kept-and-changed.md)). In a branching net a successor under `E` can leave the core where another keeps it; along a determined law the next step keeps it. Where a longer line first leaves its start's class of the core is placed by `«两端分则中有标»` only where the core is decided at each step.

**Theorem** (root; a determined law). Along a determined law's step a line under any relation never ends exactly where every step of the orbit continues under it (`Law.unending_iff_steps`), and under a class such a line keeps every configuration of the orbit alike with its start (`Law.unending_alike`).

On the models the core is the familiar invariant. Along the steps, the core of "alike in `p`" relates two steps exactly where `p` agrees at every pair of steps equally far after them (`core_iff_same_course`). For a determined law read through a map, likeness by bisimulation is the core of the value class (`Law.alike_iff_core`), the course through the map that is [knowing's 文](03-KNOWING.md#r-wen-in-the-grammar); the coarsest relation keeping the values that the law keeps is the root theorem read on a law ([knowing](03-KNOWING.md#r-the-split-that-makes-sense)). Finite stages approximate the core from above, and what a stage tells apart is not in it ([03](03-KNOWING.md#r-testing-within-the-net)).

<a id="fire-and-fuel"></a>
## 5. Fire and fuel

A flame of three moments ends in ash. Under "burning or not" each moment continues the one before, but constancy asks alike moments to have alike futures, and these do not: the first has two moments of burning left, the second one, the third none. A finer description fixes the course. Which description carries a flame's regularity one flame does not decide; two flames side by side decide it against one alternative.

**Theorem** (root; witness). In the flame `f₀ → f₁ → f₂ → ash`, four elements whose equality is the model's, the moments continue one another under "burning or not", and under that class's core no occurrence continues another, so read through the core the flame would not continue at all (`«以核为判据则火无续»`).

**Definition.** Holding by itself (自持) is a constant class; mutual need (相须): the joint class of `E₁` and `E₂` is constant and neither alone is; leaning-on (因于): the joint class and `E₂` are constant and `E₁` is not. By §4 these apply only to lines that never end. For lines that end the comparison goes through the core: `E₂` suffices for the regularity of `E₁` (足以定理) where what is alike under both is alike under `E₁`'s core, and leaning-on (因于核) and mutual need (相须核) through the core are defined from it, the classes not constant.

**Theorem** (root). Where `E₁` and `E₂` are classes and their joint class is constant, either suffices for the other's regularity, so the constancy forms imply the core forms (`«合有常则足以定理»`, `«因于则因于核»`, `«相须则相须核»`). Mutual need is symmetric (`«相须之对称»`), and nothing needs itself (`«无自相须»`).

**Theorem** (root; witness). *Two descriptions of the model flame.* In the model flame neither "burning or not" nor "the same fuel left" is constant, a line under each ending; together they tell every occurrence apart, the joint class being identity on the four moments (`Flame.joint_eq`), and identity is constant, so each suffices for the other's regularity: the two need each other through the core (相须核, `«火薪相须»`). For the same reason every class that tells the four moments apart together with "burning or not" suffices for its regularity (`«火之见证不择类»`): in one flame the witness singles out neither the fuel nor a direction.

**Theorem** (root; witness). *Two flames.* Take two flames burning side by side, each through the four moments, a step going from a moment of one flame to the next moment of the same flame. "The same fuel left" still suffices for the regularity of "burning or not", while the joint class now relates two distinct occurrences, the two flames at one moment (`«两火以薪定理»`). "The same flame" does not suffice: with "burning or not" it relates a flame's first two moments, whose futures differ (`«两火同火不足以定理»`).

So in two flames, where the joint class is not identity, the fuel is singled out against sameness of flame. What the witnesses show besides is that under the core of "burning or not" no moment continues another while a finer description fixes the course, so the core alone is not the criterion of continuation, and that self-maintenance read as a constant class belongs only to lines that never end. They decide a description against one named alternative, not in general; they derive no combustion, and that every flame continues only through its fuel is not proved.

<a id="renewal-and-grains"></a>
## 6. Renewal and grains

Renewal is a line started by another: an occurrence conditions the beginning of a line that goes on. Read at a coarser grain, the same relation lets a pattern continue while its parts begin and end, with no second relation for the pattern.

**Definition.** `x` renews under `E` (复生) where `x` is a condition of an occurrence that begins a line under `E` and has a successor, so the new line is not a flash. Renewal is said with its class or not at all. The coarse net (粗) of `R` at the grain of a class `L` is `L;(R ⊓ ¬L);L`: something in one class conditions something in a different class. Renewal at the grain of `L` (粗复生): something in `x`'s class conditions a beginning whose line goes on.

**Theorem** (root). For a class `L`, read at its grain without taking classes apart (`L;R;L`), every condition inside a class becomes a loop at both its ends (`«类内之缘成环»`), so a class could neither begin nor end there; the coarse net therefore takes 缘 between classes, and joins only different classes (`«粗只连异类»`). Every renewal is a renewal at the grain of every class (`«复生则粗复生»`). Under the full class nothing new begins from a condition, and there is no renewal (`«一之下无复生»`).

**Definition.** Renewal without end (生生) holds of `x` where `x` lies in some family each member of which conditions a beginning whose line goes on and reaches a member of the family again. `x` renews into `w` (复生至) where `x` conditions a beginning whose line reaches `w`. Ceasing (息) is defined positively, by induction: `x` ceases where everything `x` renews into ceases, the least property so closed. Renewal without end is the greatest family that keeps renewing; ceasing is its inductive dual.

**Theorem** (root). Renewal without end contains every family that keeps renewing (`«生生最大»`) and unfolds into renewal without end again (`«生生之展»`); it renews (`«生生则复生»`) and does not cease (`«生生不息»`). An occurrence that does not itself renew ceases (`«自不复生则息»`): ceasing, like renewal without end, concerns what an occurrence renews into, not its line, so it ceases even where its line goes on into renewal without end; in particular, where nothing on the line from `x` renews, `x` ceases (`«不复生则息»`). So, by that theorem at each occurrence it renews into and then the definition of ceasing (a hand step, not stated in Lean), an occurrence that renews ceases where nothing renews again on the lines its renewals begin: the definitions do not make renewing and ceasing exclude each other, though no model of both is given in Lean. That what does not renew without end ceases is not proved. Under the one there is no renewal without end, and everything ceases (`«一之下无生生»`, `«一之下皆息»`). Read along renewing into under the one, renewal without end is going on along some branch, and ceasing is ending on every branch (`«生生即延»`, `«息即尽»`, [the map](02-MAP.md#r-generation-and-degeneration-at-two-grains)). **Theorem** (World). The occurrence before an active step renews under activity exactly where the formation arises across the step and is still active a step later (`Web.renews_iff`).

Renewal does not tell renewal sustaining a pattern from turnover ending it: a short-lived pattern can renew and still end. Telling them apart takes two grains at once, parts and the pattern, read along the branches of the coarse line: carrying renewal (传), generation, keeping, degeneration and higher orders are [the map](02-MAP.md#r-generation-and-degeneration-at-two-grains).

**Reading** [AI reading, D1]. In the grammar 生生 names only renewal without end. The theory reads 生生 as life in the whole and its continuing generation, generation generating generation: what forms preserves, restores, transmits or creates the conditions and generators of further forming. That asks more than renewal of lines ([07](07-SIGNIFICANCE.md)); generation never means any new organization.

<a id="expressible-and-derived"></a>
## 7. What the grammar can say and what it derives

A law written in the grammar's terms is not thereby a theorem of the grammar: a law proved on a model passes to the grammar only by a dependency audit stripping what it does not use, a lifting theorem stating it in the grammar's terms and a representation theorem showing the model's terms to be the grammar's instances; until then it is stated with its model ([08](08-METHOD.md)).

<a id="models"></a>
## 8. The models

A model gives the grammar a carrier, a relation read as 缘 and the classes it uses, and carries what one relation and one class do not fix: amounts, activity and exchange. The World's arising, ceasing, lineages and identity across steps are the grammar's terms read on it (§8.6); most laws are proved on the models, so each names its model until lifted (§7).

<a id="models-table"></a>
### 8.1 Processes, steps, occurrences

| Model | Carrier | 缘 | Classes used |
|---|---|---|---|
| A process (`Generative.Process`) | configurations | one step | likeness; descriptions a law goes alike across |
| The steps (`Steps.next`) | steps | `t` conditions `t + 1` | alike in a determination `p` |
| A web's occurrences (`Steps.along`) | a step with a relatum | the same relatum one step on | alike in activity; in holding |
| A continuation (`Web.continuationStep R`) | a step with a formation | `(t, g)` to `(t + 1, f)` where `R t g f` | activity; activity with one formation |

A frame adds to a process claims realized at configurations. The World is richer: relata of one kind with a flow (who takes part, what each takes and gives) and a web (levels, activity, requirements, needs, drawing), natural-number amounts and one shared index of discrete steps; formations and conditions are two roles of one relatum.

<a id="r-place-transition-nets-on-the-spine"></a>
**Theorem** (World). Place/transition nets, defined by their own firing rule, are a model of the World: a net is a law of exchange reading nothing, and with every weight positive its flow balances the markings exactly on firing sequences (`Net.balances_iff`). With finitely many places listed once and their equality decided, dissipation is exactly every fired transition losing weighted tokens (`Net.dissipative_iff`); so rising with falling, bounded taking, rest and the siphon law hold along firing sequences whose fired transitions lose (`Net.rise_with_fall`, `Net.siphon_empty` and companions). Which system is which net is a correspondence outside the Lean ([record](../results/records/place-transition-nets-on-the-spine.md)).

<a id="r-laws-with-noise"></a>
**Theorem** (World; periphery for expectations). A law of exchange with noise is a relation of exchange, along every realization of which the course is a run, so the laws over every relation of exchange (§8.3) hold path by path (`NoisyLaw.readOffExchange`). In the periphery (`propext`, `Classical.choice`, `Quot.sound`), with integrable amounts, balance along every realization passes to the expectation (`Representation.expected_balance`) and rest does not: a condition ending at a random step rests along every realization while its expected level falls at every step (`Representation.RandomEnd.rest_not_in_expectation`, a witness; [record](../results/records/laws-with-noise.md)).

<a id="world-premises"></a>
### 8.2 The World and its eight premises

In a World, relata take from and give to one another's levels across each step, and each is active or not. Eight premises, each a property a world may have or lack, say how activity, levels and exchange hang together; none is built in.

| Premise | Content |
|---|---|
| Activity needing support | a relatum is active only where the levels meet what it then requires |
| Balance | every change of a level is what is taken from it and given to it |
| Only active relata give | whatever gives across a step is active there |
| Only active relata take, and only what they draw on | whatever takes is active and draws on what it takes from |
| Dissipation | on every family without repetition closed across a step, a formation that takes gives back at least one unit less |
| Embodiment | every relatum stands as a condition exactly while active |
| A census | the relata active at each step are listed, each once |
| Bounded transmission | descent transmits every dependence within one bound |

<a id="r-map-of-premises"></a>
**Theorem** (World). *The map of premises.* The eight are independent, each failed by a world meeting the other seven (`World.independent`); in `hatch` all eight hold and each binds, binding meaning only that its antecedent has an instance, and for the census that the world is not finite (`World.hatch_binds`), so no finite world binds every premise (`World.Finite.not_binds`). The independence measures the freedom of the World's separately chosen fields, not contingency in becoming ([record](../results/records/map-of-premises.md)). What follows from which:

| From | Follows |
|---|---|
| activity needing support | exactly the zero reserve carrying activity |
| embodiment | whatever arises is embodied |
| a finite world with decided activity | a census |
| only active taking, dissipation | only active relata give across an enclosed step |
| a finite world meeting the eight | that it rests from some step on cannot be refuted |

<a id="r-space-and-its-parts"></a>
**Theorem** (World). *The whole and its parts.* Premise-free laws hold of every world; premises carve parts: activity needing support, balance, only active giving, only active taking, dissipation, embodiment and a reserve carrying activity are each met by some worlds and failed by others (`World.contingent`). In a finite, balanced, dissipative world whose arising is embodied, that it comes to rest cannot be refuted, each premise needed; the rest theorem is [the map's](02-MAP.md#r-continued-change-needs-openness) ([record](../results/records/space-and-its-parts.md)).

**Theorem** (World). *Recurrence of the parts.* In a finite world with decided activity arising recurs exactly when ceasing does (`World.arising_iff_ceasing`); in some world with infinitely many relata arising recurs and ceasing does not, and in another the reverse (`World.separate`, two witnesses). Each recurrence pattern occurs among finite worlds both with every event living, on the stepwise reading, and with some event not living (`World.living_crosses`, four witnesses). Decidedness is this law's own hypothesis: asked of every finite world without it, the law is exactly excluded middle (`World.law_iff_em`), and exactly the decidedness of the grammar's positions over every carrier and relation (`World.law_iff_grammar_positions`), a lemma of the law and not a calibration, since the need comes from activity being a proposition, not from change: keeping pace needs it settled, step by step, whether each relatum is active.

<a id="r-transmission-independent-where-it-binds"></a>
**Theorem** (World). Wherever bounded transmission binds, dropping one dependence of the giver keeps every other premise and finiteness and breaks transmission (`World.drop_holds`, `World.drop_untransmitting`), so no law kept by dropping a dependence derives it; in a finite world meeting balance, dissipation, embodiment and activity needing support, the reading in which each relatum depends only on what its givers drew on, together with drawing being depending, derives it (`World.transmitting_of_drawn`); the reading and that link are each needed (`World.drawn_and_link_needed`; [record](../results/records/transmission-independent-where-it-binds.md)).

<a id="read-off-the-exchange"></a>
### 8.3 The premises read off one exchange

Rather than choose the World's fields separately, read them off one exchange: activity as taking part, drawing as taking, requirement as response, and the rest of the whole counted as one more relatum, the difference between what the levels did and what the exchanges carried. Four tying premises then hold by the reading; a census holds where a named family closes each step, and in every finite world, with participation listed without repetition; dissipation, embodiment and bounded transmission are states of the law of exchange.

<a id="r-premises-read-off-the-exchange"></a>
**Theorem** (World). *By the reading.* With the rest counted, every world balances and only active relata give and take (`World.withRest_balanced`, `World.withRest_acting`, `World.withRest_taking`), and a world's own flow balances exactly where the rest is never active (`World.withRest_closed_iff`). Under a law of exchange, with requirement read as response, activity needs support, so the four tying premises hold with no premise; where the law reads only what has stood, the rest is idle exactly where the course is feasible (`ExchangeLaw.rest_idle_iff_feasible`). Balance is not removed: nothing comes from nothing becomes feasibility, a premise located in the law. Requirement is not in the course, since two laws generating one course can require their condition at need one and at none (`ExchangeLaw.requirement_beyond_course`, a witness; [record](../results/records/premises-read-off-the-exchange.md)).

<a id="r-census-read-off-the-exchange"></a>
**Theorem** (World). With the relata taking part at each step listed without repetition: where a named family closes each step's exchange, the relata that exchange are listed with no decision procedure, and with its rest counted the world has a census (`World.withRest_counted`); so has every finite world (`World.Finite.withRest_counted`). Without enclosure, that a world read off an exchange fails a census at a step is refuted (`Flow.not_not_listed_at`; [record](../results/records/census-read-off-the-exchange.md)). **Calibration.** A census at every step of every such flow over `Nat` is exactly LPO (`Flow.listed_iff_lpo`): listing what exchanges, with no family named, is deciding whether any of infinitely many candidates exchanges at all.

<a id="r-premises-that-are-states-of-the-law"></a>
**Theorem** (World). *States of the law.* Read off laws of exchange, with the rest counted and idle and the four tying premises holding, dissipation, embodiment and bounded transmission are each met by one world and failed by another (`ExchangeLaw.contingent`). Dissipation is loss: a law giving back what it takes does not dissipate. Embodiment is no dormancy: with the rest counted it is exactly balance with each relatum exchanging exactly while it stands (`World.withRest_embodied_iff`). Bounded transmission is heredity of response. Which law an actual unfolding has is empirical ([record](../results/records/premises-that-are-states-of-the-law.md)).

<a id="r-requirement-over-open-exchanges"></a>
**Theorem** (World). Where a relation of exchange leaves several exchanges open, requirement read as necessary response gives activity needing support on every run, and with the rest counted the four tying premises (`ExchangeRelation.reading_glue`); read as possible response it does not on every run (`ExchangeRelation.free_unsupported`, a witness). A law of exchange is the relation leaving one exchange open, where both readings are the law's response ([record](../results/records/requirement-over-open-exchanges.md)).

<a id="r-requirement-is-the-weakest-sound-reading"></a>
**Theorem** (World). Over every relation of exchange, necessary response is a sound reading of requirement that does not read the current level of what is required (`ExchangeRelation.respondsBelow_supports`, `ExchangeRelation.respondsBelow_local`), and every such sound reading implies it (`ExchangeRelation.respondsBelow_weakest`); possible response is not sound over every relation: over the free relation it is not (`ExchangeRelation.mayRespond_not_supports`, a witness). That requirement does not read the current level is argued, not proved ([record](../results/records/requirement-is-the-weakest-sound-reading.md)).

**Reading** [AI reading, D65]. *The case for locality.* Activity needing support holds by the reading only under necessary response, so its warrant is locality: read off the current level of what is required, being required would depend on being met, and any activity could be counted as supported; read as necessary response, requirement is fixed by what the exchange does under other levels, a counterfactual of the law no course fixes (`ExchangeLaw.requirement_beyond_course`). An argument, not a proof.

<a id="r-central-laws-over-every-exchange"></a>
**Theorem** (World). Each of 33 central laws taking balance, only active giving or taking, or activity needing support holds over what is read off an exchange, those premises discharged ([`Becoming.OverExchange`][OverExchange]); what stays a hypothesis is a state of the law (dissipation, embodiment, bounded transmission, enclosure, feasibility, a census of what stands) or the law's own ([record](../results/records/central-laws-over-every-exchange.md)).

<a id="what-internal-means"></a>
**Reading** [AI reading, D65]. *What internal means here.* A relation is internal where it holds by what its terms are: no pair of terms of that kind lacks it. Read off one exchange, balance, only active giving and taking, and activity needing support are internal so (`World.ReadOffExchange.dependent`, `World.takingUnsupported_not_readOff`), and the moments stay distinct: requirement is beyond the course, and activity and standing come apart wherever a relatum is dormant (`ExchangeLaw.still_not_embodied`). This reaches no necessity beyond the World model read off one exchange, and none of the determinations no World premise names (evaluation, significance, direction), where the continuation condition (scope) and C (order) enter as premises, neither asserted ([07](07-SIGNIFICANCE.md)).

<a id="r-imbalance-as-relatum"></a>
**Theorem** (World). For any flow and web, with the imbalance counted as an added relatum never active and requiring nothing, every flow balances; balance is exactly that relatum idle, and the two representations agree step by step (`Flow.balances_iff_idle`; [record](../results/records/imbalance-as-relatum.md)).

<a id="r-unity-of-readings"></a>
**Theorem** (World). Along a run, what a contextual system shows, each claim with its context, are the relata of one world, with no gluing used, quantum measurements included (`Contextual.world`, `Contextual.world_active`). A condition's change read by its standing and by the exchange agree at a step exactly where the flow balances there (`Flow.changeReadings_agree_iff`), and with the rest counted they glue at every step (`World.unity`). Not shown: that an unfolding's readings glue; quantum measurements' do not (`Square.no_context_free_values`, a witness; [record](../results/records/unity-of-readings.md)).

<a id="balance-from-physics"></a>
### 8.4 Balance from physics

Physics gives balance where the quantity read is conserved locally: carried only by the exchanges, produced nowhere.

<a id="r-balance-from-the-first-law"></a>
**Theorem** (periphery; `propext`, `Classical.choice` and `Quot.sound`, through Mathlib's reals). A quantity carried only by the exchanges taking part, read at a unit `u > 0` on the levels and the exchanges, balances the levels exactly where no condition produces it (`balances_iff_unproduced`), so a locally conserved quantity such as energy balances (`balances_of_conserved`); conservation of the total alone does not, as a unit moving between two conditions with no exchange shows. Read in available work relative to a reservoir at `T0 > 0`, a unit being `u > 0` of it, with the first law and the entropy balance at each store and exchange, one reading gives three things (`balance_and_least_loss`): the levels balance exactly where no store generates entropy; with each participating exchange's entropy production nonnegative, the flow gains nothing; and where that production is moreover strictly positive whenever a participating exchange takes from a family without repetition closed across the step, the flow dissipates, the least loss. Energies and entropies are reals, levels whole units of available work, and the step from physics is a stated correspondence ([EntropyProduction.lean][EntropyProduction]; [record](../results/records/balance-from-the-first-law.md)). Least loss from entropy production is [the map's](02-MAP.md#r-least-loss-from-entropy-production).

<a id="r-balance-from-conservation-along-a-relation"></a>
**Theorem** (World). Over finitely many relata listed without repetition, with equality decided and the relation a computable test, transfers along the relation that balance a step exist exactly where the total is conserved on every family the relation closes (`Continuity.balancing_iff`); a law reading at each relatum only it and its neighbours, conserving its total from every configuration, conserves it on every such family (`Continuity.conservedOn_of_law`). A swap of two unrelated relata conserves the total and is balanced by no transfers along the empty relation. Not shown: local fluxes in the lattice sense, or infinitely many relata ([record](../results/records/balance-from-conservation-along-a-relation.md)).

<a id="one-relation-or-two"></a>
### 8.5 One relation or two: coupling by level

The World supplies dependence: what a formation requires, at what need. Some laws read a second relation, a level coupling into a formation by level, which bears on the one-symbol start.

<a id="r-where-a-level-couples"></a>
**Theorem** (World). An exchange's response to one level is a coupling of every strength array of the law (`ExchangeLaw.RespondsTo.couples`), strength zero being exactly no response (`ExchangeLaw.respondsWithin_zero_iff`). With equality of conditions decided, under a law reading through the couplings, a formation outside the part responds by level to no level that does not couple into it by level (`ExchangeLaw.Through.not_respondsByLevel`); with equality of formations decided too, a condition coupled by threshold passes only a crossing of its need, the formation's admission at the step decided (`crossing_passes`), and that a condition couples in by level is unrefuted exactly where some such law's response by level is (`not_not_obs_iff_respondsByLevel`; [record](../results/records/where-a-level-couples.md)).

<a id="r-what-dependence-alone-carries-of-a-level"></a>
**Theorem** (World). At the step of the exchange, with equality of conditions decided and activity needing support read off the law, dependence alone carries of a level exactly the responses rising with it up to a bound (`carried_iff_rising`), and with a complement, a different condition at a fixed total, every response (`supply_carried_by_complement`); supplying what a level lacks of a positive amount, over levels up to a positive bound, is carried by no family through dependence alone (`supply_not_carried`). So the second relation is genuinely second only for a falling response with no complement ([record](../results/records/what-dependence-alone-carries-of-a-level.md)).

<a id="instances"></a>
### 8.6 The World model in the grammar

The instance sections of the World modules state the World's continuation family in the grammar's terms, with empty axiom reports; they are laws of [continuation relative to a class](#r-continuation-relative-to-a-class). Occurrences are pairs of a step and a relatum, and 缘 is the module's own relation. Most rows are equivalences:

| World model | Grammar | Lean |
|---|---|---|
| a formation arises; ceases | the occurrence after the step active and beginning; the occurrence before it active and ending, under "alike in activity" | `Web.arises_iff_sheng`, `Web.ceases_iff_wang` |
| a determination comes to be; ceases | `p` holding after the step and the occurrence beginning; `p` holding before it and ending, along the steps, under "alike in `p`" | `comesToBe_iff_sheng`, `ceasesToBe_iff_wang` |
| arising without end | active beginnings, after the first step, at arbitrarily late steps | `Web.unceasing_iff_late_beginnings` |
| arising and ceasing under a continuation | an active occurrence beginning; an active occurrence ending, along the continuation | `Web.arisesFrom_iff_sheng`, `Web.ceasesFrom_iff_wang` |
| a split; a merge | fission; the candles' merge, the formations active at both ends | `Web.split_fission`, `Web.merge_candles` |
| a lineage; links; holding | a line under activity from an active formation; the occurrence itself or a line under the one; from a formation requiring the condition, itself or a line under the dependence's class | `Web.lineage_iff_line`, `Web.linked_iff_line`, `Web.held_iff_line` |
| reach along continuation steps; re-identification | a strict order; lines unchanged | `Web.reach_strict_order`, `Web.line_reidentify` |
| the pattern passed on while the carrier ceases (火传) | ending under the carrier class, not the pattern's: an alteration | `Web.passing_fire` |
| falling dormant | an alteration under holding | `Web.fallsDormant_alters` |
| the arising–ceasing law, asked of every finite world | every position along the steps decided | `World.law_iff_positions` |

**Reading** [AI reading, D45]. The fire passed on reads 「指窮於爲薪，火傳也」 ([《庄子·养生主》][Yangshengzhu]; [06, §一](06-CLASSICAL-TEXTS.md#why-classical)), the wood used up and the fire passed on. Not instances: the World model's counting, amounts, recurrence and renaming laws, since the grammar states no counting and no map of carriers; only their premises are connected.

<a id="test-systems"></a>
### 8.7 Test systems of the source texts

The two texts the root was built from proposed test systems a grammar of becoming must express ([the first text, §7](../../../sources/15-codex-theory-conversations/2026-10-23-continuity-as-root/minimum-grammar-of-becoming.md)). Small witnesses are given for two of them as stated, decay and a system with no clear boundary, and for two narrower stand-ins; in each, the behaviour in question is supplied in its net. The flame is §5's.

<a id="r-the-source-texts-test-systems"></a>
**Theorem** (root; witnesses). *Five small witnesses.*

- *Decay.* A nucleus intact or decayed, step by step. The decay is an alteration: the nucleus continues under the one while "intact or not" tells the two ends apart (`Decay.decay_alters`), in a net where no occurrence reaches itself (`Decay.possible_acyclic`); the steps only rise (`Decay.reach_rises`), so the absence of a cycle lies in the indexing, and that the nucleus has no inner interaction is an omission of the model. In the net of possibilities, where an intact nucleus may stay intact or decay at every step (`Decay.both_open`, the net's definition), "intact or not" is constant (`Decay.possible_constant`), and every two intact moments, at any two steps, are alike in its core (`Decay.time_not_in_core`): the step is not in the regularity of "intact or not", memorylessness without probabilities. A history within that net (`Decay.history_within`) that decays at its second step has the time left before the decay in that core: its two intact moments lie apart (`Decay.history_apart`), as the flame's time left does (§5). Which net a model declares decides this; which an actual decay is, the model does not say.
- *No clear boundary.* Three occurrences `a → b → c` and two identities, one holding `a` with `b`, the other `b` with `c`, each a class (`Overlap.continues_each`); `b` ends under the first and begins under the second (`Overlap.b_positions`). Their union is not a class: it relates `a` to `b` and `b` to `c` but not `a` to `c`, and its line from `a` reaches `c` with its ends apart (`Overlap.tolerance_line_apart`), where under a class a line's ends are alike (`«线内同类»`); the class the union generates holds all three and keeps neither identity. Overlapping identities are several classes, observer-dependence is the choice of class, and a vague boundary appears only as a relation that is not a class, whose line drifts out of it.
- *A line of descent generates at two grains.* On the endless line of descent of [07](07-SIGNIFICANCE.md#r-reach-past-ones-own-end), the line under the one never ends and ahead of every point a member begins (`LineOfDescent.Endless.generates`). This is not an organism that renews its parts and dies, which lies in `«新而有终»` ([02](02-MAP.md#r-generation-and-degeneration-at-two-grains)), and no self-maintenance or regulation is modelled.
- *Two family lines.* Two lines of descent with no condition between them, and the class of one family line, strictly between a member's class and the one (`TwoLines.between`). The family line is constant (`TwoLines.family_constant`), so its core goes on through each birth while the member's line ends (`TwoLines.core_through_birth`); and from one family's first birth, even under the one, no member of the other family is reached (`TwoLines.other_line_outside`). So reaching one's successors along 缘 is not reaching everything, and a class narrower than the one can have a core that carries a line past a member's end ([07](07-SIGNIFICANCE.md#r-reach-past-ones-own-end)). The families here share no condition; where they do, the class and its core are a further question.
- *A belief whose rate of spread grows with its number.* The number holding a belief goes up by the rate, and the rate by the number, by supplied laws, a process [changing its own rule](02-MAP.md#r-rules-that-change-themselves-in-the-grammar). On the step the rate changes with the number (`Belief.rate_changes_on_step`), and one holder at rates `0` and `1` lie apart in the core of "same number" (`Belief.rate_read_in_regularity`, an instance of `adaptive_core_apart`). The laws of spread and of the rate's change are fixed, and nothing here is specific to belief; [closed capture](02-MAP.md#r-closed-capture) is the nearer model of a selection changing its own rule.

What the witnesses do not show: that any actual nucleus, lineage or belief is so; probabilities of decay, which are the periphery's ([`Becoming.GrammarCases`](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarCases.lean); [record](../results/records/the-source-texts-test-systems.md)).

**Reading** [AI reading, new]. An institution kept by its members' consent and one held by penalties, the source's pair of observationally equivalent mechanisms, are [the thermostat witness](03-KNOWING.md#r-testing-within-the-net) read socially: in one core class of "in being or not" while the penalties stand, told apart once their removal is in the net. That is the witness's net with its occurrences renamed, not a new law; the warning that interventions can fail to identify mechanisms is not touched.

<a id="laws-on-every-model"></a>
## 9. Laws on every model, each with its hypotheses

These general laws of change hold of every model of their kind, process, type or world, before any premise about a particular world. A World premise a law names (balance, dissipation, a census) is a hypothesis of that law at the steps and relata used, not of the space. The laws fall in layers: what holds with no premise excludes no unfolding beyond what the model's own form excludes; what a premise adds holds of the part it carves (§8.2); and the dynamics stop deciding at whether actual unfoldings meet the premises, the step after which nothing arises (§9.5), the order of mixed parts, and significance, which no represented dynamics entails ([07](07-SIGNIFICANCE.md), where the continuation condition fixes scope and C order, neither asserted).

<a id="one-change"></a>
### 9.1 One change, three readings

Arising and ceasing are beginning and ending under the class of activity (§8.6). A determination comes to be across a step where it fails before and holds after, and ceases where it holds before and fails after. Arising and ceasing, a dependence forming and dissolving, and a condition coming to stand and ceasing to stand are this one change read of activity, dependence and standing, by definition (`Web.change_readings`).

<a id="r-coming-and-ceasing-keep-pace"></a>
**Theorem** (World). *Coming and ceasing keep pace.* Over any stretch an amount at the end with all it fell is the amount at the start with all it rose, and so for a finite family's total. No amount falls below zero, so levels of finitely many conditions that keep falling keep rising (`rising_recurs`); with amounts bounded, recurring rises need recurring falls. For a decided determination over a finite family, coming to be recurs exactly when ceasing does (`coming_recurs_iff`); read of standing no decision is needed, and read of activity, with activity decided, one list covering the active formations from some step on is enough, and finitely many formations in all is not needed (`Web.unceasing_iff_covering`). Finiteness does the work, as *accretion* (ever new formations arise, none cease) and *attrition* (they cease, none arise) show ([record](../results/records/coming-and-ceasing-keep-pace.md)).

<a id="r-recurrence-without-decidedness"></a>
**Theorem** (World). In a family a list covers, with no decision, recurring coming to be refutes any end to ceasing, and conversely (`Recurs.ceasing_not_stopping`, `Recurs.coming_not_stopping`); where the states of the stretch searched are decided, the step is found (`Recurs.ceasing_found`); decided from some step on, the two recur together (`coming_recurs_iff_decided`; [record](../results/records/recurrence-without-decidedness.md)).

<a id="r-rising-and-falling-in-one-exchange"></a>
**Theorem** (World). *A rise comes with a fall.* Across a step at which a flow balances on a family and the family is dissipated on, its members fall by at least as much as they rise, and by one more for each formation taking from it (`Flow.BalancesOn.falls_cover`); so a member rising comes with another falling across the same step (`Flow.BalancesOn.rise_with_fall`). Balance and dissipation are used at that step on that family only; without dissipation the law fails. In a balanced, dissipative flow, a family without repetition in which a member rises while none falls is not closed across that step (`Flow.rise_alone_opens`). A fall is not a ceasing or an undermining, and the law does not say which member falls ([record](../results/records/rising-and-falling-in-one-exchange.md)).

<a id="how-it-relates"></a>
### 9.2 A configuration is how it relates

For the laws a configuration is how it relates to its continuations: two that match each other step for step are alike, and on a determined law this likeness is the core of §4.

<a id="r-configurations-alike-by-relation"></a>
**Theorem** (any process). Configurations related by a bisimulation are alike: they realize the same claims, match each other's steps by the same move into alike configurations, and pass the same tests, a test being a claim after a finite course of moves (`Alike.tests`). Likeness is an equivalence, stated as a relation since a quotient needs quotient soundness. A description makes sense where it identifies exactly the alike configurations; such descriptions identify the same configurations, and where the frame is determined up to likeness at every configuration they carry a law (`IdentifiesAlike.carries`). Naming the configurations makes sense exactly where alike configurations are one, which fails for twin successors of one move (`identifiesAlike_id_iff`). When passing the same tests makes configurations alike is [knowing's](03-KNOWING.md#r-tests-fix-likeness-where-determined) ([record](../results/records/configurations-alike-by-relation.md)).

<a id="r-determinacy-up-to-likeness"></a>
**Theorem** (any process). Determinacy is the named case of determinacy up to likeness, the claims naming the configurations (`determined_iff_named`), so the laws on how configurations relate hold up to likeness (`carries_law_alike_iff`). Equality, not likeness, is needed for an intervention on one of two alike configurations, which breaks determinacy up to likeness (`Twins.retarget_breaks`, a witness), for a past no claim tells apart, and for a description no claim tells apart ([record](../results/records/determinacy-up-to-likeness.md)).

That a projection carries a determined law exactly where configurations alike under it go by the same move to configurations alike under it is [knowing's](03-KNOWING.md#r-projection-carrying-a-law), and so is [the split that makes sense](03-KNOWING.md#r-the-split-that-makes-sense).

<a id="r-joint-correlation-reduced-dynamics"></a>
**Theorem** (any process; the quantum case a witness). For every law of change with moves and every reduction, some determined law on the reduced values carries every step exactly where configurations the reduction merges are taken by each move to configurations it merges (`Readout.law_through_iff`). In a stated two-qubit fragment, a phase operation keeps both local densities while a later controlled-X responds differently, so the local densities carry no law and a four-integer summary keeping the joint cross term carries one: a relation can change while every local state stays. The quantum framework is supplied ([record](../results/records/joint-correlation-reduced-dynamics.md)).

<a id="r-separation-loses-the-relation"></a>
**Theorem** (any type). *Separation loses exactly the relation.* Describing two parts separately gives back the whole exactly where the whole is rectangular; where it is not, not every separately described combination occurs (`separation_faithful_iff`); in a witness, two parts always equal, described separately, admit (true, false) (`separation_admits_extra`). Three parts can be related while every two are free: parity is a whole its pairs do not give back (`whole_not_in_pairs`, a witness). A relation forms only by joint action, lasts under separate laws that merge nothing that occurs, and ends only by loss or joint action ([record](../results/records/separation-loses-the-relation.md)). **Reading** [AI reading, D33]. Two are a pair by relation, the members read off the pair; a pair is the least split, not the least relation.

<a id="readings-and-runs"></a>
### 9.3 Process and frame as views; worlds as runs

A process, a frame and a world are views of one unfolding, each a model of the grammar; these laws say how each returns to the others.

<a id="r-process-and-frame-as-readings"></a>
**Theorem** (any process; World for a frame read as a world). Reading the move within the configuration changes no run; the law then leaves the next move open (`withMove_open`), and it is determined exactly where it was determined with moves as labels and, if it takes any step at all, any two moves are equal (`withMove_determined_iff`): storing an unrestricted next move in the configuration is branching. A world's move is its relata's exchange. A history is a run of the least law it is a run of, the law it shows (`shown_le_iff`), and a law given before it adds only moves not taken, which no record fixes: law and history correspond without being identical, the gap being memory. A claim is a relatum: a run of a process whose configurations are not webs is a world through its claims, with loss (`Frame.world`; [record](../results/records/process-and-frame-as-readings.md)).

**Reading** [AI reading, D23, D32]. Law and history are one unfolding read two ways, the law read off the unfolding rather than set over it, and the splice is memory's absence. A part's choice is not a second kind of cause beside the unfolding, and the names of configurations carry nothing.

<a id="r-worlds-are-runs"></a>
**Theorem** (World). *A world is a run by its type.* A world is a run of the process admitting every step, its configurations its webs and its moves its relata's exchanges; each view returns the other, largely by `rfl` (`World.run_world`). A world balances exactly where its run is a run of the law of exchange on webs (`World.balanced_iff_exists_run`), and with the rest counted every world's whole web is such a run. The course a law of exchange generates is a world, balanced under a law of what has stood exactly where the course is feasible (`ExchangeLaw.courseWorld_balanced_iff`). Not shown: that every process is some world's law ([record](../results/records/worlds-are-runs.md)). **Reading** [AI reading, D43]. The run is the World package's formal root, not a ground beneath the world, its index being a reading of the relata's own courses (§9.6); a run is one model of the grammar.

<a id="r-histories-fix-law-up-to-dead-ends"></a>
**Theorem** (any process). A family of histories is some law's family exactly where it holds its splices, and histories fix a law up to its dead ends, which occur only for unending sequences (`family_iff`, `same_histories_iff`); families are compared at every history, without function extensionality ([record](../results/records/histories-fix-law-up-to-dead-ends.md)).

<a id="r-where-a-move-is-formed"></a>
**Theorem** (any process). *Where a move is formed.* One move formed in a whole couples a part and the rest: what the part does is what the rest undergoes, by definition. With the laws functions and a configuration of the other side given, the move is the part's own exactly where it is a policy of the part's configuration (`partForms_iff`), the rest's likewise (`restForms_iff`), and both exactly where it is the same everywhere (`partForms_and_restForms_iff`). On a finite stretch with equality of configurations and of moves decided, no policy gives the moves exactly where a configuration recurs with the move varied (`no_policy_upto_iff`): one course does not fix whose move it is ([record](../results/records/where-a-move-is-formed.md)). **Reading** [AI reading, D24]. Which cut into part and rest is apt is not shown.

| Result | Standing and statement |
|---|---|
| <a id="r-trace-law-equivalence"></a>[Step laws and endpoint traces](../results/records/trace-law-equivalence.md) | Theorem (any process). Two processes on the same configurations and moves agree on every step exactly where they agree on every finite course with both endpoints kept (`same_steps_iff_traces`); feasible words alone lose the law, as a still and a toggling process show. |
| <a id="r-finite-trace-transport"></a>[Step-preserving maps transport finite traces](../results/records/finite-trace-transport.md) | Theorem (any process). A map preserving each step sends every finite course to one with the same moves (`Generative.trace_map`); the converse needs a lifting hypothesis at every starting fiber. |
| <a id="r-derived-history-law-exactness"></a>[A local law from history summaries](../results/records/derived-history-law-exactness.md) | Theorem (any process). For a prefix-closed family of histories and a total summary, the law built from the admitted one-step extensions keeps every finite continuation as a feasible word of moves, not its endpoint, at every admitted history exactly where histories sharing a code have the same continuations (`futures_through_iff` read with histories as configurations, [Readout.lean][Readout]); no finiteness or decision is needed, and an empty family meets it vacuously. |
| <a id="r-becoming-context-coherence"></a>[Coherent histories across contexts](../results/records/becoming-context-coherence.md) | Theorem (any process). For a nonempty family of processes on common configurations, pooling their steps keeps exactly the union of their finite endpoint histories exactly where that union is closed under joining at the shared boundary (`pooledLaw_exact_iff_joinClosed`); otherwise pooling invents histories, and retaining the context realizes the union. |

How a process's histories are read off their finite stretches is [knowing's](03-KNOWING.md#r-a-history-read-off-its-finite-stretches).

<a id="return-and-going-on"></a>
### 9.4 Return and where a run goes on

These laws ask of runs the question §4 asks of lines, whether continuation ends, and where along a course a change can enter.

<a id="r-recurrence-without-premise"></a>
**Theorem** (any type). *Recurrence under every law of change.* Within finitely many configurations, a list holding every one, a determined law merges nothing exactly where every configuration returns, exactly where it keeps every possibility (`Law.lossless_iff_returns`, `Law.returns_iff_keeps`); a quantity that never falls rises only under a law that merges (`Law.rise_not_lossless`), and for every process what is lost stays lost. Becoming that keeps its whole history loses nothing and never returns, so it needs a carrier no list holds, and a present a list holds forgets (`Law.present_forgets`). The list is the hypothesis each law writes in; no unfolding is assumed to have one, and no decidability is used ([record](../results/records/recurrence-without-premise.md)).

Returning where the course branches is [the map's](02-MAP.md#r-returning-where-the-course-branches), beside [attraction, which is not returning](02-MAP.md#r-attraction-is-not-returning).

<a id="r-where-a-run-goes-on"></a>
**Theorem** (any process). Within finitely many configurations, a list holding every one, a run starts exactly where a course as long as the list starts, exactly where a course leading to a return starts, with no decision and no selection (`Onward.run_iff_continues`, `Onward.run_iff_returning`). Where branching is infinite, courses of every length need not give a run (the fan, a witness, `Onward.fan_no_run`); where a test recognizes a step staying in a family, search builds a run as data ([record](../results/records/where-a-run-goes-on.md)). **Calibration.** A run staying in every family that keeps moving, asked of every process, is exactly dependent choice (`Onward.runs_iff_dependentChoice`): going on for ever is choosing, at each step, one way on.

<a id="r-what-a-commuting-law-keeps-apart"></a>
**Theorem** (any type). Where a law commutes with a map moving every configuration, its runs from `x` and from the image of `x` are never at one configuration at the same step (`Law.Commutes.apart`): to merge what a symmetry tells apart, a law must break the symmetry (`Law.Commutes.breaks`). Every map commutes with itself, so a map moving every value never rests along its run (`Law.Commutes.self_apart`). The case of the hexagrams and their complements is stated in [06](06-CLASSICAL-TEXTS.md) [AI reading, D52] ([record](../results/records/what-a-commuting-law-keeps-apart.md)).

<a id="r-every-origin-passes-the-gate"></a>
**Definition.** A gate is a decided mark on moves, a map to Booleans; the ungated steps preserve a property `p` where its holding before a step gives it after, and reflect `p` where its holding after gives it before.

**Theorem** (any process). *Every origin passes the gate.* For every process and gate: where the ungated steps preserve `p`, a course from where `p` holds to where it fails contains a gated move (`Gated.leaving_passes_gate`); where they reflect `p`, a course ending where `p` holds started where it held, or splits at a gated step after which `p` holds (`Gated.origin`). Nothing about `p` is decided; the gate is. A gate locates where change can enter a line; it shows neither that a gated move changes anything nor, without `p` decided, the first gated step at which `p` comes to hold ([record](../results/records/every-origin-passes-the-gate.md)). **Calibration.** With the gate a proposition, the origin law in its weaker form (a course ending where `p` holds started where it held or contains a gated move), asked of every process, is exactly double-negation elimination (`Gated.origin_of_propositions_iff`): locating where a property entered needs it decided, move by move, whether the move is an entry.

<a id="counting"></a>
### 9.5 Counting: one law and its cases

Counting tallies the beginnings and endings of §3, read of activity, along a listing. The census balance (first row), with the list's length, is all counting gives: the counts of every listing are exactly the tallies; the World's premises add at most one law, and where the chosen premises bind at most three more (fifth row). The cases, all **Theorem** (World):

| Result | Statement, with its hypotheses |
|---|---|
| <a id="r-census-balance"></a>[The census balance](../results/records/census-balance.md) | The list at the end with what ceased is the list at the start with what came (`Listed.over_stretch`); read of recurrence it is exact, ceasing recurring exactly where from each step some later list falls short of the start with what came. Listed at each step, each member once; holding decided, automatically so for standing. |
| <a id="r-ceasing-needs-arising"></a>[Ceasing needs arising](../results/records/ceasing-needs-arising.md) | Where what holds is listed at each step, each member once, and holding is decided, ceasing recurring needs coming to be recurring (`Listed.coming_of_ceasing`); not conversely, as accretion shows. With no decision, where a list covers one step and nothing comes after it, ceasing does not recur. |
| <a id="r-bounded-census-keeps-pace"></a>[Keeping pace under a bounded census](../results/records/bounded-census-keeps-pace.md) | Under a listing, each member once and holding decided, whose list returns to at most some `K` members at arbitrarily late steps, coming to be recurring needs ceasing recurring (`Listed.ceasing_of_returning`), so the two keep pace even among infinitely many members; on a World with activity decided and its census so bounded, arising recurs exactly where ceasing does (`World.CountedBy.arising_iff_ceasing`). Under a bound growing without end, however slowly, arising can go on without ceasing. |
| <a id="r-census-balance-under-continuation"></a>[The census balance under a continuation](../results/records/census-balance-under-continuation.md) | Under a census, read along a continuation, with activity and the continuation decided: without splits ceasing recurring needs arising recurring; without merges, at most `B` formations active from some step on, conversely; with neither the balance is exact (`Web.Census.balanceFrom_eq`), each hypothesis needed. |
| <a id="r-whole-law-of-counting"></a>[The tally is the whole law of counting](../results/records/whole-law-of-counting.md) | Listings count exactly the tallies, for properties respecting the counts' values (`counting_laws`). Under each of the 256 choices of the eight premises, the one law added is that nothing arises across a step at which nothing is active (`World.counting_under`), added exactly where the choice binds counting: it chooses balance and embodiment, and only active giving or both only active taking and dissipation (`World.counting_binds_iff`). Where each chosen premise binds, the laws added are at most that something is active, that something arises, and that something arises across a step at which something is active, each under named choices (`World.binding_counting_under`). Decided activity. |
| <a id="r-counting-where-the-counts-exist"></a>[Counting where the counts exist](../results/records/counting-where-the-counts-exist.md) | Every decided counting law holds of every counted census, the counts taken as relations, with decision asked only where a count exists. A count of a list exists exactly where each member is decided (`counts_iff_decided`); under a census, a count of ceasing across a step exists exactly where, for each relatum listed before it, being listed after it is weakly decided, and so for coming (`World.ceasings_exist_iff_listed`, `World.comings_exist_iff_listed`). |
| <a id="r-counting-under-enclosure"></a>[Enclosure bounds change](../results/records/counting-under-enclosure.md) | In a balanced, dissipative world of embodied relata with a census, activity decided and every step from `T` on enclosed, the total standing at `T` bounds the relata active together with the steps of change (`World.enclosure_bounds_change`); finite and enclosed worlds share their counting laws under a choice of premises exactly where it bounds change and binds counting. |
| <a id="r-counting-standing-and-dependence"></a>[Counting what stands and what depends](../results/records/counting-standing-and-dependence.md) | Under each choice of premises what stands obeys the counting laws of what is active (`World.standing_counting_under`); under enclosure balance and dissipation alone bound the change of what stands, with no embodiment (`World.enclosure_bounds_standing`); the premises add no law to counting dependences (`World.dependence_counting`). |

**Calibration.** That arising does not recur in a finite world meeting the eight cannot be strengthened to an end step: a step after which nothing arises, asked of every finite world meeting the eight with decided activity, gives LPO (`World.lpo_of_finite_ends`): naming the end is deciding whether anything changes again. The calibrations of counting itself are [the method chapter's](08-METHOD.md#r-counts-exist-where-decided).

<a id="order-of-change"></a>
### 9.6 The order of change and the step index

A line runs along the models' shared index of steps. Exchanges whose footprints are disjoint commute, so what shows of the index is the partial order of joined exchanges; for exchanges acting locally it is read off the relata's own courses. All **Theorem** (World) unless marked:

| Result | Statement, with its hypotheses |
|---|---|
| <a id="r-only-the-order-of-change-shows"></a>[Only the order of change shows](../results/records/only-the-order-of-change-shows.md) | With equality of relata decided and each relatum listed once at each step, a world read through a supplied stuttering, idle steps inserted, meets each premise exactly where the world does (`World.stutter_premises_iff`); the laws of one step, the totals over a stretch, the counts of arising and ceasing (activity decided) and recurrence are unchanged, and so under removing idle steps, the moving steps supplied. What is counted per step, rates and how long a reserve carries, is relative to the reading's unit. |
| <a id="r-exchanges-commute-unless-joined"></a>[Independent exchanges commute](../results/records/exchanges-commute-unless-joined.md) | Where supplied sides split two consecutive steps, swapping the exchanges keeps balance, dissipation and embodiment (`Reorders.laws`) and, on a stretch holding every commuted pair, the totals and counts (`Reorders.totals`), under any number of commutations; the order shows through a shared relatum or a dependence. |
| <a id="r-order-of-exchanges-is-the-invariant"></a>[The order of exchanges as the invariant](../results/records/order-of-exchanges-is-the-invariant.md) | With a given footprint containing the exchanges, commuting unjoined exchanges keeps the partial order of joined ones and reaches every renumbering keeping it (`Footprinted.sorts_iff`); conversely, on a finite stretch, the renumbering and its inverse given, a world so ordered agrees with a reordering at every step. |
| <a id="r-least-footprint-where-idleness-decided"></a>[The least footprint](../results/records/least-footprint-where-idleness-decided.md) | Given idleness decided at every step and relatum, the least footprint touches exactly what is not idle and lies in every containing footprint; with equality of relata decided, one exists exactly where idleness is decided (`Footprinted.least_exists_iff`). |
| <a id="r-normal-forms-need-decided-apartness"></a>[Normal forms need decided apartness](../results/records/normal-forms-need-decided-apartness.md) | Theorem (any type). With joining symmetric, two arrangements of a finite stretch are connected by commuting unjoined neighbours exactly where they order joined pairs alike, with no decision (`rearranges_iff`); a normal form, and a complete invariant on the stretch, exist exactly where apartness of distinct exchanges is decided (`complete_iff`). |
| <a id="r-order-of-exchanges-sharing-a-relatum"></a>[Exchanges sharing a relatum need not commute](../results/records/order-of-exchanges-sharing-a-relatum.md) | Theorem (a local law; witness). On one relatum, adding one then doubling gives two and doubling then adding gives one (`Interleavings.Shared.order_matters`): the hypothesis of local commutation cannot be dropped. |
| <a id="r-the-step-index-from-own-courses"></a>[The step index from own courses](../results/records/the-step-index-from-own-courses.md) | For a local law with the relata listed, two lists giving every relatum the same own course reach the same configuration (`LocalLaw.run_of_courses`); with exchanges told apart, a scheduler completes exactly where some interleaving exists; the own courses fix the interleaving exactly where every exchange touches a relatum and every two exchanges are the same or share one (`LocalLaw.unique_iff`). |
| <a id="r-the-world-an-interleaving-builds"></a>[The world an interleaving builds](../results/records/the-world-an-interleaving-builds.md) | A local law and a list of exchanges build a World whose steps balance, the relata listed once (`LocalLaw.world_balances`); where every exchange touches a relatum, one renumbering carries one interleaving's world to another's, every relation read at a step on what its exchange touches agreeing (`world_renumber_reads`); a relation on relata no exchange there touches is the interleaving's choice. |

**Reading** [AI reading, D30, D43]. The shared index of steps is a reading of the relations, not their ground: derived where every exchange touches a relatum and every two share one, elsewhere a choice among interleavings that the relata's own courses, and so the configuration reached, leave open. The choice moves where on the index a standing falls, not which standings a relatum passes through or in what order.

<a id="one-step"></a>
### 9.7 Laws of one step, resolution and sums over histories

A line advances one step at a time; these laws say what one step of exchange can do to what stands, at every resolution, and that sums over many steps compose from it. All **Theorem** (World) unless marked:

| Result | Statement, with its hypotheses |
|---|---|
| <a id="r-laws-of-one-step"></a>[The laws of one step](../results/records/laws-of-one-step.md) | With balance at a condition across a step, it comes to stand exactly when it stood at nothing and was given more than was taken (`Flow.BalancesOn.comesToStand_iff`), and ceases to stand exactly when it stood before the step and what was taken is all it had with all it was given (`Flow.BalancesOn.ceasesToStand_iff`); under a census of what stands, the conditions standing at a stretch's end with the steps of falling total number at most the total at its start with all it rose (`Flow.standing_bounds_change`), and, where what stands is not refuted to run down across those steps, at most the total at its start (`Flow.runsDown_bounds_change`); a list covering what holds ties ceasing to arising. |
| <a id="r-laws-of-one-step-complete"></a>[Completeness of the laws of one step](../results/records/laws-of-one-step-complete.md) | A pattern of one step on a family (levels before and after, what is taken and given, takers, givers) is shown by some world, each relatum taking part listed once, exactly where it obeys the law of every step (something taken has between one and that many takers; something taken or given, an exchange) and, on a family balanced on, running down, closed or both, that hypothesis's law (`OneStep.every_iff` and companions); across runs on one fixed family the passages also chain. Capacity adds one law, what is given at most capacity times givers; only active giving and taking add none. |
| <a id="r-one-step-missing-laws"></a>[What the stated laws of one step miss](../results/records/one-step-missing-laws.md) | Two further laws of one step: something taken has a taker, and, with balance at the condition, nothing is taken beyond what stood with what was given (`Flow.sign_uptake_le_takers`, `Flow.BalancesOn.taken_le`). |
| <a id="r-runs-on-families-chosen-step-by-step"></a>[Families chosen step by step](../results/records/runs-on-families-chosen-step-by-step.md) | Only a hypothesis whose family holds what stands before and after joins one step to the next, and continuity up to order replaces following position by position (`OneStep.step_runsDown_iff`). |
| <a id="r-laws-at-coarser-steps"></a>[Laws at coarser steps](../results/records/laws-at-coarser-steps.md) | At strictly increasing sample times, balance (each relatum listed once at the fine steps inside), dissipation and running down compose over a coarse step, closure exactly; only active giving and taking are relative to the step (`Flow.BalancesOn.sample`). |
| <a id="r-laws-at-finer-units"></a>[Laws at a finer unit](../results/records/laws-at-finer-units.md) | With change read in the unit, the exact laws of coming and ceasing to stand and arising needing an active giver hold at every resolution (`Flow.BalancesAtOn.comesToStand_iff`); the recurrence law and the bound need the refinement counted as a giving. |
| <a id="r-continuous-time-as-tower"></a>[Time as a tower of discrete readings](../results/records/continuous-time-as-tower.md) | Each level reads the next finer at strictly increasing times; with each relatum listed once at the finer level balance passes to the coarser (`Tower.balances_coarser`), and dissipation passes too. Under a census of what stands at a level, with what stands not refuted to run down at each fine step of a stretch, the fine steps at which the total standing falls are at most the coarsest level's total standing at the stretch's start, at every level (`Tower.changes_within`). |
| <a id="r-sum-over-histories-exact"></a>[The exact sum over histories](../results/records/sum-over-histories-exact.md) | Theorem (any process). For every weighting, moves and configurations listed finitely, the weighted sum over courses of `n` steps is `n` steps of the transfer (`Weights.sum_courses`). With the lists holding every move and configuration, a Boolean weight reading the process's steps gives possibility, the existence of an `n`-move trace, and counting refines it without loss. For a description with a representative of each value, integrating out is exact at every horizon exactly where it is at one step (`Weights.lumped_iff`). |
| <a id="r-losses-of-the-sum-over-histories"></a>[Losses of the sum over histories](../results/records/losses-of-the-sum-over-histories.md) | Theorem (any process; witnesses on one configuration). For every weighting a truncation misses exactly what it drops, and where alternatives only add it bounds the whole from below (`Weights.sum_append`). Witnesses: with two moves back to one configuration, one adding and one subtracting, each is possible and so is their join while the signed count balances, and possibility cannot see it (`Interference.unseen`); a weighting needing the move before is no step weighting on one configuration, and is one where that move is kept (`Memory.not_of_steps`); loops double the courses, `2^n` of `n` steps. Signed counts are pairs of natural numbers compared by balance, the pure core taking no quotient; unbounded horizons are not stated. |
| <a id="r-weights-count-situations"></a>[Weights count situations](../results/records/weights-count-situations.md) | Theorem (any type). Where each step is taken in as many situations as its natural weight, the law with the situation as the move is determined, a course weighs the number of situations taking it; and for two values weighted `p` and `q`, the finer courses of `n` steps deviating by at least `d` number, times `d`, at most `n·p·q·(p + q)^n`, the law of large numbers counting situations (`Situations.situations_typical`); which situation happens is not a count. |
| <a id="r-the-move-alone-underdetermines"></a>[The move alone does not fix the outcome](../results/records/the-move-alone-underdetermines.md) | Theorem (any type). Where a step by a move has situations reaching two configurations, no law giving the next configuration from the configuration and the move alone is right on both (`Situations.move_underdetermines`). |

<a id="identity"></a>
### 9.8 Identity across steps and classes along a continuation

Which formation at one step is which at the next is, on the World model, stipulated by names. The grammar reads it as continuation under a class: identity across steps is one reading of continuation, not a fact beneath it.

<a id="r-identity-across-steps"></a>
**Theorem** (World). *Labels carry nothing.* A renaming, one to one at each step, preserves each of the five readings checked that follow a formation: renewing and consuming in the run, the tenure of a dependence, undermining, and unceasing arising (`Web.rename_renewingIn`, `Web.rename_consumingIn`, `Web.rename_tenure`, `Web.rename_undermining`, `Web.rename_unceasing`), while the pattern of names across steps carries identity: changing only who continues whom can turn a renewing and a consuming formation into two consuming ones. Two-way continuity of activity still leaves succession possible across a dormant step. Continuity is a reading of identity, not its definition ([record](../results/records/identity-across-steps.md)).

**Theorem** (World). *Where identity is forced.* Under a census at a step and the next: under every continuation in which no formation continues as two, not every formation active after the step continues one active before it, exactly where more are active after than before (`forced_iff_more`); under a census at every step, the same at arbitrarily late steps exactly where more are active after a step than before at arbitrarily late steps (`ListedWebs.forcedAlong_iff_more`). The conclusion is negative and names no arising formation. In a balanced world with equality of relata decided, every balance-keeping renaming continues a relatum as itself across a step exactly where no other relatum stands after the step as it does (`World.fixed_iff`); where two stand alike, some balance-keeping renaming continues the one as the other (`World.continues_as_alike`), so no record that renamings keep decides between them.

<a id="r-classes-along-a-continuation"></a>
**Theorem** (World). Read along a supplied continuation rather than by names, renewing passes into every branch of a split and consuming back into every formation merged (`Web.renewingAlong_iff`, `Web.consumingAlong_iff`). These classes are fixed by the continuation under every re-identification and are the named classes where each formation continues itself and is active at every step. A merge decides a class: a formation renewing as named consumes along a merge with one drawing on a spent condition (`MergeClass.readings`, a witness). Which continuation holds is supplied ([record](../results/records/classes-along-a-continuation.md)).

<a id="wholes-and-closures"></a>
### 9.9 Wholes, parts and closures

A line's reach and a formation's closures are one construction: the least region holding a starting point that is closed under a relation. Wholes of some part, of every part and graded are [the map's](02-MAP.md#r-a-whole-of-every-part).

<a id="r-levels-of-closure"></a>
**Theorem** (any type; any process for reach). *One closure.* A region is closed under a relation where whatever a member bears it to is a member, and `g` lies within `f`'s closure where every closed region holding `f` holds `g`. The closure is reflexive, transitive and itself closed, so it is the least closed region holding `f` (`closedUnder_withinClosure`); a process's reach is the same closure under its steps (`reach_iff_withinClosure`).

**Theorem** (World; no premise). *The levels of closure.* From a formation's own events outward, the levels are this closure under different relations: being fed at some step (the feeding closure); being affected, another exchanging with a condition the formation depends on (the influence closure); affecting (the reach closure); and sharing a condition (the system, a class). The feeding closure lies within the influence closure, and the influence and reach closures within the system (`Flow.withinInfluence_of_withinFeeding`, `Flow.withinSystem_of_withinInfluence`, `Flow.withinSystem_of_withinReach`); in two witnesses each inclusion is strict, and influence and reach point opposite ways. Where every formation takes part in one condition every system is the whole (`Flow.system_whole_of_common`), and significance bounded by a system that is the whole meets the continuation condition (`Flow.bounded_system_whole`), the step [07](07-SIGNIFICANCE.md) uses for route (b). Not ordered in time, the closures are upper bounds, not present relations ([record](../results/records/levels-of-closure.md)).

**Theorem** (any process). *Reach from a seed.* A configuration is reached from a seed exactly where every property holding at the seed and invariant under the process holds there (`SeedReachProcesses.fromSeed_iff_invariant`), and some such invariant separates it exactly where it is not reached (`separated_iff_not_fromSeed`); a configuration no invariant separates is only not unreached (`not_not_fromSeed_of_not_separated`); with no moves only the seed is reached. **Calibration.** That every process reaches every configuration no invariant separates from the seed is exactly double-negation elimination (`fromSeed_of_not_separated_iff_dne`): reaching a configuration needs a path.

<a id="r-which-links-a-closure-needs"></a>
**Theorem** (any type; World). Removing links leaves every closure as it was exactly where each removed link has its second end within its first end's closure under what remains (`Cuts.closure_unchanged_iff_bypassed`), and joining a link adds exactly what passes through it, with no symmetry and no decision. In a world grown by attachment, every condition that attached a formation is needed: its two takers lie in one system and apart without it (`Flow.GrownBy.condition_needed`); growth by attachment is a hypothesis, and the need is a closure's, not a valuation's ([record](../results/records/which-links-a-closure-needs.md)).

Where a formation's acts return to it, whatever it can affect being able to affect it, is [knowing's](03-KNOWING.md#r-where-a-formations-acts-return).

A configuration can hold parts together: `J s l r` says that `s` realizes `l` and `r` together, whole and parts being configurations of one unfolding, with no associativity, order or free repetition assumed. These laws say when a description of the whole keeps the parts' joint plans. All **Theorem** (any process):

| Result | Statement, with its hypotheses |
|---|---|
| <a id="r-exclusive-footprint-support"></a>[Exclusive footprints support all leaves](../results/records/exclusive-footprint-support.md) | Where the parts' footprints lie within the whole's and exclude each other, every realized nested plan's requests are free of repetition and covered by the root's footprint (`JointPlan.supports_of_realizes`). |
| <a id="r-joint-decomposition-lifting"></a>[Lifting a joint decomposition](../results/records/joint-decomposition-lifting.md) | The parts read through a description lift from every configuration it describes exactly where configurations it identifies match parts into configurations it identifies (`liftsFromEach_iff`), with no premise; a description by the joint tests meets this where pairs of parts are compact and tests stable. |
| <a id="r-joint-code-plan-lifting"></a>[Lifting finite nested joint plans](../results/records/joint-code-plan-lifting.md) | Where configurations a description identifies match parts and the leaves are read correctly through it, a finite plan is realized at a description exactly where it is realized at each configuration so described (`JointPlan.realizes_image_iff`). |
| <a id="r-code-plan-global-support"></a>[Global support of coded joint plans](../results/records/code-plan-global-support.md) | Under those lifting hypotheses with footprints within and apart, a plan realized through a description has its leaf requests covered by the whole's footprint without repetition (`JointPlan.supports_of_image`). |
| <a id="r-finite-joining-tree-lifting"></a>[Finite joining trees lift](../results/records/finite-joining-tree-lifting.md) | A description lifts a joining exactly where having one code is a bisimulation of the partner frame (`Joining.lifts_iff`); where it lifts, every finite tree of joinings lifts with its own leaves (`Joining.tree_lifts`). No shared nodes, cycles or copying of resources. |

<a id="two-courses"></a>
### 9.10 Two courses of one law

What two courses of one law carry between them, a counterfactual being the course the same law generates from a different act, is [the map's](02-MAP.md#r-counterfactual-is-the-course): how much difference [two acts' worlds carry](02-MAP.md#r-two-act-worlds-carry-the-difference) and [where two courses rejoin](02-MAP.md#r-where-two-courses-rejoin).

<a id="modelling-commitments"></a>
## 10. The modelling commitments

Each is stated where a law depends on it ([08](08-METHOD.md)).

| Commitment | Where it binds |
|---|---|
| Equality on the carrier | identity as a class; the two-block class of a single condition; fission; the flame (§§2–5) |
| Discrete steps, one shared index | every World and process law; the index derived where exchanges share relata (§9.6) |
| Natural-number amounts | least loss, unrecurring falls, loop doubling; in any amounts rest needs the census's total to stop falling ([02](02-MAP.md#r-rest-theorem-in-any-amounts)) |
| Prop-valued activity | counting and naming a step need it decided (§8.2) |
| One kind of relatum, two roles | formations and conditions (§8.1) |
| Requirements as thresholds | support is meeting every requirement; off an exchange, necessary response (§8.3) |
| Identity by naming | names or a supplied continuation (§9.8) |
| Pointwise properties | the decided counting laws, with no function extensionality (§9.5) |

<a id="does-not-show"></a>
## What this chapter does not show

- That reading a subject as continuation relative to a class explains how it goes on: the theory's claim, argued.
- That any class is warranted: constancy says only that a class agrees with 缘, and identity is constant under every relation (`«静有常»`).
- That containment in 缘 tells a fire passed on from one fire ending and another starting: every single condition is a continuation under some class.
- That renewal without end tells renewal sustaining life from turnover destroying it; the map takes the first step, at two grains.
- That every becoming has a law of exchange, a local law or a discrete index whose readings these are.
- That no independent entity exists: the statements of the World model need no independent entity, and no representation theorem for the World is claimed; the ontological claim is argued, not proved ([08](08-METHOD.md#one-relational-unfolding)).

<a id="open"></a>
## Open

- **Faithful representation.** That every becoming, and the whole theory, has a faithful representation in the grammar; a representation theorem for each model, with the liftings, would show it.
- **Lifting.** Most modules do not yet state their laws on the grammar ([the theory graph](../results/THEORY-GRAPH.md)); each is to be restated by a lifting theorem, as the continuation family was, the counting of lines first.
- **Identity from continuity, not naming.** For continuations read off conservation the formal part is settled; continuations read from informational or organizational relations are not derived.
- **The deductive necessity of the whole.** That the determinations are internally related moments of one unfolding is argued, as a reading, for the World premises read off one exchange (§8.3); that every becoming has such an exchange is open.
- **Presence in time.** Whether a condition must still be there when what it conditions arises is not expressible: the grammar has no relation of presence in time, and adding one is a choice of model; 俱有 is mutual reach, not this ([06](06-CLASSICAL-TEXTS.md#r-classical-definitions-in-the-grammar)).
- **Pairing and power.** That the corpus gives the functional projections pairing would need is a conjecture with no corpus witness.
- **Self-changing conditions.** A rule that changes by a fixed law is stated in the grammar by taking the rule into the occurrence, the carrier being a parameter: for a process changing its own rule the state's class is constant under every move exactly where the rule makes no difference to it, and in closed capture the locked line goes on while every step alters the loss ([02](02-MAP.md#r-rules-that-change-themselves-in-the-grammar), [`Becoming.GrammarRegularity`][GrammarRegularity]). The law of change stays fixed, and the levels come from the carrier's product, not from the grammar. Not yet stated: a change of the law of change with no fixed law above it, or a space of rules not given with the carrier; a pattern reshaping its own limits (限 is not defined, below); the lock and absorption laws of [`Becoming.ClosedCapture`][ClosedCapture] and readers formed from the selected, in the grammar's terms; and selection of selection (which [元吸引子](02-MAP.md#r-closed-capture) needs) as a law relating two grains.
- **Test systems.** Small witnesses, the behaviour in question supplied in each net ([§8.7](#r-the-source-texts-test-systems)): decay, overlapping identities, a line of descent generating at two grains, two family lines whose class has a core going on through births, a belief whose rate grows with its number; an institution kept by consent or by penalty is the thermostat witness read socially. Open: a vortex; an institution's identity through replaced people, rules and purposes; self-maintenance and adaptive regulation, and an organism that ends; a belief system whose content or law of spread changes; a graded boundary; decay with its probabilities; models read off actual data.
- **限 and conflict.** Limit (限) is not defined, nor the conflict relation of a net of possibilities, which §1 only mentions.
- **The root and the ethics.** Held de se along a relation, the continuation condition is the root's at the one of that relation ([07](07-SIGNIFICANCE.md#r-the-continuation-condition-on-the-root)); along a net with no cycle it holds only with one center. The free significance of 07 §1 is not lifted, and the ethics' other laws are instances not yet stated on the root; which class a center's own line runs under ([07](07-SIGNIFICANCE.md#r-reach-past-ones-own-end)), and the warrant of the condition and of C, are open.

[Grammar]: ../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Grammar.lean
[GrammarCandidates]: ../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarCandidates.lean
[Mojing]: ../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/corpus/mojing.tsv
[Yangshengzhu]: ../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/corpus/zhuangzi-yangshengzhu.tsv
[OverExchange]: ../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OverExchange.lean
[ClosedCapture]: ../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ClosedCapture.lean
[GrammarRegularity]: ../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarRegularity.lean
[Readout]: ../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Readout.lean
[EntropyProduction]: ../../../experiments/integrated-correction/general-framework/generative-basis/lean/physics/EntropyProduction.lean
