# Method and the formal core

<a id="method-and-the-formal-core"></a>

**Thesis.** The theory is built from zero premises first and states each premise it uses where it uses it; the premise card lists them in one place ([§4](#premise-card)). Claimed and checked: the pure core imports only Lean's prelude, and every source declaration in it has an empty axiom report, the only exceptions being constants Lean generates that no source declaration uses ([§3](#pure-core-and-periphery)). The report concerns logic only: the real assumptions lie in the modelling (discrete steps, one index, natural-number amounts, propositions as activity, identity by naming), each stated where a law depends on it. Also claimed: theorems on what identifying propositions keeps and loses, where counts exist, which runs settle and what a law of the whole takes. Open: that every premise is named, which the completion checks support and cannot certify ([§12](#completion-criterion)); the lifting of model laws onto the grammar; and each item of the [ranked list](#open-items-ranked).

**Where this chapter sits.** It takes the results of [01](01-ROOT.md)–[07](07-SIGNIFICANCE.md) as its material and gives back the standing of each claim, the labels and words every chapter uses, the premise card, the theses with their homes and the open programme; it is home to the results about the method itself. Two kinds are stated elsewhere and linked: the losses of the sum over histories are in [01](01-ROOT.md#r-losses-of-the-sum-over-histories), and the bounds on a description made within what it describes are in [03](03-KNOWING.md#r-readings-within-what-they-read).

**Bases.** Its laws are on any type (derivation, counts, listing, propositions), any process (settling, summaries, covering, the run construction), the World (flows however listed, relata through relations, the tail) and the periphery, with Mathlib and Lean's standard axioms (what steps and whole amounts cost), labelled as [§2](#standings-and-bases) says. Labels name each law's hypotheses (decided, listed without repetition, finite, a list holding every configuration) and the principle a calibration needs. Where the chapter touches evaluation ([§2](#where-the-ethics-sits), [§4](#premise-card), [§12](#open-programme)), the ethics rests on two premises with two roles, neither asserted: the continuation condition fixes scope, C fixes order.

<a id="beginning-within-the-one-unfolding"></a>
## 1. Beginning within the one unfolding

**The start.** The account begins from one relational unfolding: activity forming and changing the conditions of further activity, some of whose effects persist and condition what follows. Relatively enduring organizations form within it, and some come to sense, remember, act and evaluate. Knowing, modelling and criticizing happen inside it too, so their adequacy is part of the inquiry, not a vantage outside it. The [root](01-ROOT.md) gives this start its formal side. Nonduality erases no difference in experience, history, access, control, consent or consequence. A shared process implies no cosmic subject, no aggregate interest and no administrator entitled to speak for everything. The central account and the branches articulate one unfolding: a finding in a branch can show a limit of the central account's current articulation and require its revision. A diagram with a root and descendants is an aid, not a finished foundation with applications attached.

**Distinctions state their basis.** Subject and object, actor and patient, observer and world, fact and value are each drawn within the unfolding, along relations, together with what they leave out. Before two terms are treated as independently given, the relation said to join them is reconstructed. A separate type, a local resource account or a separate question asserts no fundamental separation, and a shared notation establishes no constitutive connection. "Supplied" is local: a law supplied to a model need not be external to reality. Where an explanation stops, the work says whether the limit lies in the model, in a missing connection or in the foundation. A relation that a weaker representation omits is not an explanatory failure of the fuller account.

**An objection is answered on what it says.** That it presupposes separate entities, or follows a tradition or a thinker, is a claim to be shown in the case, not an answer to it. An account that read every objection as its objector's capture would take in no objection, and by the law of selection nothing an objector says could then reach it ([03](03-KNOWING.md#r-selection-through-couplings)).

<a id="five-step-test"></a>
**Testing a constitutive connection.** A claim that two things are constitutively joined is tested in five steps:

1. State the claim and its scope through features that can be assessed independently, without putting the conclusion into the description.
2. Reconstruct the strongest alternative account, saying what it keeps and where it differs.
3. Tell a change in the actual condition from a change in its report, label or proxy. A counterexample must meet the claim's stated conditions.
4. Say why a formal countermodel is relevant. Toggling a predicate in a weaker model shows non-entailment, not that the fuller structure allows the toggle, and declaring an identity does not make it true.
5. Say what would narrow, revise or defeat the claim, and do not widen "the full condition" after each objection.

<a id="an-investigation"></a>
**An investigation** proceeds in an order that can be revised:

- state the question and its scope;
- give the configurations represented, with their history or a justified summary;
- supply or derive the law, with its warrant;
- define the specification without reference to the verdict;
- prove the exact statement;
- check the abstraction and the countercases;
- check the correspondence, saying which link the result advances.

Proofs check relations under a representation, empirical work tests realization and correspondence, and philosophy examines constitutive identities. No cultural origin validates or disqualifies a method. A report states the configuration, the standing of its distinctions, the scope it preserves and a condition of revision. It classes each gap in one of three ways: a relation the formalization omitted, an explanation not yet given within the account, or evidence against a stated claim. A disproved property may show an inadequate intervention, a false law, an omitted relation or a limit of the theory.

**Process, theory, model, names.** The process unfolds; the theory seeks to explain it; a model represents selected relations, and a model formed within the unfolding can take part in it. Activity includes change and interaction without presupposing an agent, an intention or a purpose. Conditions are the relations that enable or constrain what follows. They are not necessarily quantities that can be stored or exchanged, and no condition is silently taken as owned, transferable, additive, scarce or commensurable; the World's natural-number amounts are a modelling choice ([§4](#modelling-commitments)). Formation covers generation and degeneration alike, and generation is the narrower term ([02](02-MAP.md)).

Wording names the relation it means: the formation and change of conditions, dependence, participation in decisions. It does not compress causal contribution, influence and responsibility into "authorship", and it keeps money, payment and ownership for actual economic relations. A description of participation confers no authority, permission or right. Responsibility needs its own argument: historical contribution alone does not prove it, and its absence does not prove that there is no reason to respond. Joint activity starts from actual relations, not from opposed interests or a fixed common utility ([05](05-COLLECTIVES.md)). Nonduality is a requirement of method; it proves neither the ontology nor an ethical necessity.

<a id="standings-and-bases"></a>
## 2. Standings and bases

**What a label tells.** Every result statement in the chapters opens with one bold label, and a proved result names its base. This table is the one list of labels; [06](06-CLASSICAL-TEXTS.md) writes the same labels in Chinese.

| Label | Means | Example |
|---|---|---|
| **Definition.** | a term is introduced; nothing is claimed | a type of configurations has no step relation ([§6](#expressible-is-not-derived)) |
| **Theorem** (root) | proved on `Becoming.Grammar` or a grammar module, for every carrier, relation and class | continuation relative to a class ([01](01-ROOT.md#r-continuation-relative-to-a-class)) |
| **Theorem** (the steps) | proved for every determination of the natural-number steps | what ceases to be is the coming to be of its negation ([01](01-ROOT.md#r-negation-change-and-stable-cases)) |
| **Theorem** (any process), (any type) | proved for every step relation or type; grammar-level in content, not yet in the grammar's vocabulary | derivation is sound ([below](#r-derivation-soundness)) |
| **Theorem** (World) | proved on the World model, with its premises and local hypotheses named | non-recurrence in an enumerated world ([§4](#flows-however-listed)) |
| **Theorem** (a named model) | proved on a named finite model, such as (the Changes) for `Becoming.Hexagrams` and its sibling modules (06: 卦之世界); "(the Changes, by computation)" where it is shown by computing over the finite model, which makes it an example and not a law of every world | the hexagram laws ([06](06-CLASSICAL-TEXTS.md)) |
| **Theorem** (periphery) | proved with Mathlib or with axioms, which are reported | what steps and whole amounts cost over the reals ([§4](#r-what-discrete-steps-and-whole-amounts-represent)) |
| **Theorem** (…; witness) | a constructed example, labelled as one | the two Boolean rows ([below](#r-finite-basis-common-interpretation)) |
| **Conditional.** | holds under the continuation condition, C or a practical commitment; every premise used is named | C extended to responses under L ([§6](#r-becoming-spine-instances)) |
| **Calibration.** | needs an omniscience principle, and says what the need says about the unfolding; a calibration of the logic alone is a lemma of the law that needs it, stated in that law's sentence | the last change of a run ([§5](#r-the-last-change-of-a-run)) |
| **Thesis.** (chapter opening) | a chapter's claim in one paragraph; its standing is that of the results it summarizes | every chapter's opening |
| **Thesis T*n*.** | an empirical claim, with its standing, what it forbids and the evidence so far | the table of [§9](#theses) |
| **Thesis** (philosophical) | an argued claim, with what it forbids and what would refute it; no Lean | [one relational unfolding](#one-relational-unfolding) |
| **Reading** [AI reading, D*n*] | an interpretation of checked content; it changes no theorem ([register](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md)); a reading not yet registered is written `[AI reading, new]` until the register gives it a number | the Chinese terms of [§10](#names) |
| **Assessment.** | a scoped evaluation with evidence and no Lean (a record of kind `assessment`, a published method read against the laws, an empirical test); it says what was evaluated and against what. An interpretation it involves is labelled separately | the coder test ([§11](#r-fidelity-coders-on-own-and-other-texts)) |
| **Open.** | not shown; says what would show it | the foundation of the theory ([§12](#r-theory-of-becoming-foundation)) |

A sentence states what the Lean proves, with its hypotheses, no stronger and no weaker. In particular:

- it keeps every hypothesis that changes what holds, under a short name where needed (finite, listed without repetition, decided, balanced at the steps used, a supplied bound, an initial condition, a positive amount);
- it keeps the quantifiers of the Lean, and writes "exactly where" only for an `↔`;
- it keeps a constructive negative negative ("not every", not "some fails");
- it cites the declaration whose strength matches the sentence;
- for a periphery result, it names the axioms the record reports.

<a id="four-layers"></a>
**The theory in four layers.** Sorted by standing, the whole comes in four layers.

- **I. With no premise.** What holds of every unfolding and every law of change:
  - the readings of one change;
  - the tally as the whole law of counting decided listings (`counting_laws`, for properties of counts that respect their values at each step);
  - within finitely many listed configurations, a law merges nothing exactly where every configuration returns (`Law.lossless_iff_returns`), and a run is a course into a return.
- **II. What each premise adds, on the World model.** The eight World premises are independent. Under each of the 256 choices of premises the laws of counting worlds with decided activity are fixed, for properties of counts that respect their values at each step (`World.counting_under`). This layer also holds rest, openness, joint excess and feeding from beyond.
- **III. Where the dynamics stop deciding.** Whether actual unfoldings meet the premises, the order of mixed parts, where models come from, and significance, which no represented dynamics entails (`Web.significance_undetermined`).
- **IV. Evaluation for any significance.** Living significance is characterized with no premise. The continuation condition fixes scope, and C alone orders. L, J1–J4 and the other commitments are the premises of the practical results.

<a id="where-the-ethics-sits"></a>
**Where the ethics sits.** The theory asserts no ethical axiom. Its two foundations have two roles, and neither is asserted:

- the continuation condition (`Unrestricted`: for anything, its continuation into the future has significance) fixes scope, that is, whose losses count;
- C fixes order: widening what can form is better.

The condition by itself orders nothing, and a theorem taking it as a hypothesis instantiates a universal statement. Reasons, the comparison of responses, responsibility and selection take further commitments, named in their own conditional results: L, lifted articulation and coherence ([§6](#r-becoming-spine-instances)), J1–J4, BC1 and the rest ([§4](#premise-card), [07](07-SIGNIFICANCE.md)). So every ethical result is **Conditional** and names what it uses, and wherever the ethics is summarized both foundations are named with their roles.

**A premise used is not a premise discharged.** This distinction is itself a theorem about proof trees built from a basis and a list of local premises (implication and conjunction rules, instantiation over the natural numbers).

<a id="r-derivation-soundness"></a>
**Theorem** (any type; witness). A claim derived from a basis under local premises holds wherever the whole basis and the premises hold. So the closure holds throughout a domain exactly where the basis does, and where the basis holds throughout a domain, a configuration of it where a claim fails excludes that claim from the closure. A local premise supports a conditional derivation, not its own discharge: in the witness, a claim derives under itself and not without it. Soundness supplies neither the truth of the basis nor any authority. `Derivation.Derives.sound`, `Derivation.closure_throughout_iff`, `Derivation.countermodel_excludes`, `Derivation.claim_under_itself`, `Derivation.claim_not_closed` ([Becoming.Derivation](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Derivation.lean); [record](../results/records/derivation-soundness.md)).

<a id="r-finite-basis-common-interpretation"></a>
**Theorem** (any type; witness). Suppose a finite list covers the basis and admissibility is given explicitly. If the closure is met claim by claim at admissible configurations, then one admissible configuration holds every derived claim, and also every claim derived under premises where those premises hold. Meeting each basis claim somewhere is not enough. In the witness, two Boolean rows ("it is false", "it is true") are each met but never together, so their derived conjunction is met nowhere and the closure is not met claim by claim. Admissibility is not the truth of the basis. `Derivation.pointwise_iff_common`, `Derivation.pointwise_common_relative`, `Derivation.rows_not_pointwise` ([record](../results/records/finite-basis-common-interpretation.md)).

<a id="five-words"></a>
**Words in one sense.** Every chapter uses these words in one sense each.

| Word | Sense | Not |
|---|---|---|
| 无明 (wúmíng) | seeking locked onto a target that cannot be met at rest; the position every formation selects from grounds it and is not it (D25, D26, D45); home [03](03-KNOWING.md) | what lies beyond what couples in (that is the reach of a selection) |
| 明 (míng) | coupling joined to a selection, so it reaches what support does not mark (D26, D45) | |
| generation | 02's 生成: a pattern going on through carrying renewal; in 07, 生生 as life in the whole and its continuing generation | arising (records titled with "generation" for arising are stated as laws of arising) |
| 生 (shēng) | the mark "begins" ([01](01-ROOT.md)) | what lives and arises |
| the core | 核, the greatest symmetric relation within a class that the relation never tells apart ([01](01-ROOT.md)) | the Lean package, which is "the pure core" |
| base | the base of a label (root, the steps, any process, any type, World, periphery, a named model) | "the old base", which is "the World model"; a drawn stock |
| view | process, frame and world are views of one unfolding | "readings": a reading is an interpretation, labelled |
| condition | a relatum's role, or the continuation condition | a law's local premises, which are *hypotheses* |
| selection | goes through couplings ([03](03-KNOWING.md)) | a subset of the World premises, which is a *choice of premises* |
| standing | the standing of a result (here); a level stands, comes to stand, ceases to stand ([02](02-MAP.md)) | graded significance, which is "a positive grade" |
| center | a formation as a standpoint ([07](07-SIGNIFICANCE.md)) | where a formation's acts return |
| widening | what can form is widened ([07](07-SIGNIFICANCE.md)) | "generative" |
| lifting | restating a model's law on the grammar ([§6](#expressible-is-not-derived)) | building a run along unbounded configurations (`Lasting.lifting`, a run construction); extending a comparison from outcomes to responses (`LiftBetter`) |
| law, theorem | a rule of change; a checked statement | |

<a id="pure-core-and-periphery"></a>
## 3. The pure core and the periphery

**What the checker enforces.** One [checker](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py) asserts the following on every run:

- the checked closure is the three foundation modules, the pure core, and the instance and application ring;
- the pure core imports only the foundation and itself, and compiles from Lean's prelude (`Init`) alone, with the foundation's `import Std` removed;
- every source declaration has an empty axiom report (no `propext`, `Quot.sound` or `Classical.choice`);
- of the constants Lean generates, only the injectivity lemmas of constructors with fields (`injEq`, each on `propext`) depend on an axiom, and no source declaration uses them;
- inherited modules match passed receipts by sha256;
- no superseded module is in the run.

Declarations that cannot be audited by name are covered by audits of the compiled environment.

**Stricter than constructive, and about logic only.** Constructivity needs only the absence of `Classical.choice`. The pure core also excludes propositional extensionality, quotient soundness, excluded middle and function extensionality. A law that needs a classical principle takes it as a hypothesis or is proved equivalent to it ([§5](#calibrations)). A law the pure core cannot yet prove is proved in the periphery, with its axioms reported. An empty report shows that no logical axiom is used. It says nothing about whether the modelling fits an actual unfolding ([§4](#modelling-commitments)).

<a id="minimality"></a>
**The earlier mathematical core's three minimality questions** are kept apart; they are not the three minima of [06](06-CLASSICAL-TEXTS.md#three-minimal) (立言, 穷理, 成文), which ask what must be sayable to state the four marks, why this development and not another, and how much the fewest composing operations reconstruct. The first is a sufficient interface: a supplied labelled relation with finite traces defined inductively. The second is the least endpoint continuation: reach is the closure of the steps (`reach_iff_withinClosure`), and a region is that closure exactly where it holds the start, is closed under the steps and lies within the closure (`closure_iff_certified`), so it is unique up to pointwise equivalence; the relational form is the pre-spine `GeneratedPaths.least_closure_unique`. The third is absolute minimality. That is not established, and it would need a fixed comparison of expressive resources, preserved content and explanatory dependencies. Changing notation, or moving information into another field, can change a count of primitives without reducing the commitments. An exact specification need not be a decision procedure.

**Why `propext` is excluded.** From the relational start, a proposition is read through its relations of derivation. `propext` (`a ↔ b` gives `a = b`) says that a proposition is nothing beyond them. Whether to assume it is therefore a question about lumping.

<a id="r-proposition-identity"></a>
**Theorem** (any type). Read a proposition through the two ends of an interderivation. Then `propext`, stated as a proposition and never as the axiom, holds exactly where every reading of propositions into propositions is lumped by interderivability. It also holds exactly where the reading by name is lumped, and then every reading into any type is lumped. A reading built from relations (atoms, constants, connectives, quantifiers over any type) respects interderivability with no axiom, with `↔`, not `=`.

Within Lean's proof-irrelevant `Prop`, the identification loses no distinction between witnesses: any two witnesses of `a ↔ b` are equal by definition. Identifying types would lose one, since `Bool` has two different self-inverse maps. This does not show that distinct proof histories or derivations as computations are kept. What the identification stops is the course. Transport with a constant motive keeps the value, and along `rfl` it computes, while transport along `propext` does not reduce. That last fact is a kernel observation with Lean 4.29.1 on one value, not a theorem. `PropositionIdentity.extensional_iff_lumped`, `PropositionIdentity.byName_lumped_iff`, `PropositionIdentity.Formula.eval_congr`, `PropositionIdentity.iff_witness_unique`, `PropositionIdentity.two_equivalences`, `PropositionIdentity.transport_const`, `PropositionIdentity.transport_refl` ([Becoming.PropositionIdentity](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PropositionIdentity.lean); [record](../results/records/proposition-identity.md)). That every reading of interest is such a formula is a matter of correspondence. Function extensionality and quotient soundness are not treated.

**Why losing the course matters.** The pure core's runs, censuses and witnesses are checked by computation (`rfl` and `decide` on them), and a value transported along `propext` defeats that. So the pure core states `↔` wherever a result about propositions would need `=`. The periphery's results concern outcomes, so the periphery may use `propext` as the exact lumping it is. Read again at its renewed receipts, no periphery use of `propext` computes a value through an identification of propositions. That every reading of a proposition is relational is `propext` itself, so the pure core holds it as a hypothesis (`Extensional`), never as a conclusion of the relational start.

<a id="rings"></a>
**Rings and receipts.** The pure core's modules, built on the three foundation modules, fall into the package's layers:

- L0, the foundation layer: `Becoming.World` with every module of the package it imports, that is `Becoming.Frame`, `Becoming.Prelude` and the grammar's `Becoming.Grammar`, `Becoming.GrammarMap` and `Becoming.GrammarLaws`, on which the frame rests;
- L2: the modules naming the condition or a valuation;
- L1: the rest.

No module imports a higher layer. The instance and application ring (the Changes and place/transition nets; six leaf applications) meets the pure core's requirements and lies outside it by direction. The periphery (Mathlib leaves, older modules, Python experiments) may use any tool, with dependence running toward the pure core. There has been no bridge since 19 October 2026: the pure core states the content of the superseded periphery modules, whose bytes are kept, and the bridge files are in `lean/history/becoming/`.

At core receipt [`20261029T210603.495422Z`](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks/20261029T210603.495422Z/verification.json) (Lean 4.29.1), the closure held 351 modules (3 foundation, 334 core, 14 in the instance and application ring) and 17,146 theorems; the 334 core modules held 16,300 of them; 23,393 declarations were audited; 237 generated `injEq` lemmas depend on `propext`; 75 superseded modules were kept out of the run. Periphery results keep their own receipts, with their axioms listed. New results extend the one spine, and an earlier module keeps its scope and connects by an instance or equivalence theorem ([package README](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.md)).

<a id="premise-card"></a>
## 4. Premise card

**Every premise in one place.** In Lean each premise is a definition or a hypothesis, never an axiom, each to be named in the sentence of every law that uses it (an obligation the completion checks support and cannot certify, [§12](#completion-criterion)). The first two tables are the commitments of the representation and the local hypotheses of particular laws; the World premises carve the World's parts; the last three tables bear on application, ethics and practice. In the central statements of the completion coverage, discrete steps occur in 112, natural-number amounts in 74, supplied observation in 10, a fixed type of formations in 9, decidedness in 8 and naming in 1 ([report, K4](../results/completion/COMPLETION.md)); the match is against source text, so a choice reached only through a definition is not counted.

<a id="modelling-commitments"></a>
**Commitments of the representation**, which the axiom report does not check.

| Commitment | Content | Lean | What depends on it |
|---|---|---|---|
| Discrete steps, one shared index | activity, levels and exchange indexed by one sequence of natural-number steps | `World`, `Web`, `Flow` | the order of change; for a local law with the relata listed, read off own courses exactly where every exchange touches a relatum and every two share one, otherwise a choice among interleavings ([01](01-ROOT.md#r-the-step-index-from-own-courses)) |
| Natural-number amounts | a positive amount is at least one unit | `Web.level`, `Flow.take`, `Flow.give` | the least loss of dissipation, loops doubling, novelty needing gain, the whole-number rest theorem ([02](02-MAP.md#r-continued-change-needs-openness)); dense forms in `Becoming.Amounts`, `Becoming.InAmounts` |
| Prop-valued activity | activity is a proposition | `Web.active` | every law that counts or names a step ([below](#r-counts-exist-where-decided)) |
| One kind of relatum | formations and conditions are two roles of one relatum | `World.ofRoles` | the readings of one exchange |
| The naming of relata | which condition is which relatum is given, not derived | `relabel` | identity across steps |
| Requirements as thresholds | support is `need ≤ level` | `Web.requires`, `Web.need`, `Web.Supported` | activity needing support ([01](01-ROOT.md#r-requirement-is-the-weakest-sound-reading)) |
| Identity by naming | which formation continues which is named | `Becoming.Identity` | fixed by conservation except where standings coincide ([01](01-ROOT.md#r-identity-across-steps)) |
| Pointwise statements | properties of counts respecting their values at each step | `Pointwise` | the decided counting laws (no function extensionality) |
| Context-free claims (frames) | what is shown of a claim is independent of what is shown with it | `Becoming.Context` | not met by Specker's three boxes or the Mermin–Peres square ([03](03-KNOWING.md#r-claims-shown-in-context)) |

**Local hypotheses of particular laws.**

| Hypothesis | Lean | Used by |
|---|---|---|
| Finite: finitely many relata, each listed once | `World.Finite` | finite-world laws |
| Enclosed: a step's exchange lies within a finite family without repetition | `Flow.Enclosed`, `Flow.Around` | rest, change bounds, drawing in |
| Listed: what holds at each step listed once | `Listed`, `Web.Census`, `Distinct` | census, counting and loop laws |
| Decided where a law counts or names | `Becoming.Decidedness`, `Becoming.Listing` | counting, recurrence, naming a step |

**The World premises** ([01](01-ROOT.md#world-premises)).

| Premise | Content | Lean |
|---|---|---|
| Activity needing support | active only where the levels meet everything it then requires | `World.Dependent` |
| Balance | every change of a level is exactly what is taken from it and given to it | `World.Balanced` |
| Only active relata give | whatever gives across a step is active there | `World.Acting` |
| Only active relata take | whatever takes is active and draws on what it takes from | `World.Taking` |
| Dissipation | on every family without repetition closed across a step, each taker gives it no more than it takes, and at least one unit less | `World.Dissipative` |
| Embodiment | a relatum stands as a condition exactly while active | `World.Embodied` |
| A census | the relata active at each step are listed, each once | `World.Counted` |
| Bounded transmission | descent transmits every dependence within one bound | `World.Transmitting` |

The eight are independent, each failed by a world meeting the other seven (`World.independent`), which measures the freedom of separately chosen fields, not contingency in becoming. Read off one exchange with the rest counted as one relatum (`World.withRest`), the four tying premises hold by the reading (`ExchangeLaw.readWorld_glue`); a census holds where a named family closes each step, and in every finite world, with participation listed without repetition; dissipation, embodiment and bounded transmission are states of the law (`ExchangeLaw.contingent`; [01](01-ROOT.md#read-off-the-exchange)).

**Dynamics and correspondence.** An application obligation is a premise of no theorem.

| Premise | Content | Lean | Standing |
|---|---|---|---|
| Process | admissible changes | `Generative.Process` | a view of the one unfolding |
| Observables | claims realized, levels, dependence and drawing correspond to actual histories | `Frame.realized`, `Conditions` | application obligation |
| Formation | the lives and relations evaluated form within the unfolding | — | application obligation |
| Connection | living claims are joined through formed relations | `Valuation.Connected` | application obligation ([07](07-SIGNIFICANCE.md#living-significance)) |
| Readings of `living` | whole-run, stepwise, relation level | `Conditions.valuation`, `Web.valuation`, `Web.relations` | a disclosed choice; none reads 生生 [AI reading, D1] |
| Held | every living claim lies in some standpoint's own region | `Valuation.Held` | reads what wants its continuation [AI reading, D11] |

**Ethics, none asserted** ([07](07-SIGNIFICANCE.md#condition)).

| Premise | Content | Lean | Standing |
|---|---|---|---|
| The continuation condition | for anything, its continuation into the future has significance | `Unrestricted` | stated, not asserted; fixes scope, orders nothing; C does not follow [AI reading, D16] |
| Living significance | every living claim has significance from every standpoint | `LivingSignificance` | characterized with no premise; not entailed by the dynamics (`Web.significance_undetermined`) |
| Self-significance | a standpoint's own living claims have significance from it | `SelfSignificance` | reads "wanting one's continuation" [AI reading, D11] |
| Relational and standpoint neutrality | significance passes along formed relations; what has it from one standpoint has it from every one | `transmits`, `shares` | follow from the condition |
| A (articulation) | access, with positive content secured, gives a contributory reason | `articulates` | read on living content [AI reading, D16] |

**Practice** ([07](07-SIGNIFICANCE.md#practical-judgment)).

| Premise | Content | Lean | Standing |
|---|---|---|---|
| C | an extension with no loss that realizes more is better; read as widening, exactly widening (`Web.paths_comparison_widens`) | `Comparison` | the only premise that ranks courses; warrant open |
| L | every outcome of one response better than every outcome of the other | `LiftBetter` | substantive ([§6](#r-becoming-spine-instances)) |
| J1–J4 | retained losses, basic priority, bounded responsibility, legitimate feasible choice | `Lexical.BasicPriority`, `Requirement.Frontier` | proposed by the AI; choosing at every step needs weak excluded middle |
| FR | finite responsiveness within restorable basic losses of one kind | `Becoming.LossMatching` | revisable; neither theorem nor axiom |

BC1, BC2, LC, LR, CP and NP are stated with their results in [07](07-SIGNIFICANCE.md).

<a id="supplied-parameters"></a>
**Parameters a central statement may leave supplied**, each a named hypothesis ([report, K5](../results/completion/COMPLETION.md)).

| Parameter | Named hypothesis | Lean |
|---|---|---|
| significance | the continuation condition, where a statement assumes it of `sig` | `Unrestricted` |
| standpoints and their own regions | every living claim held in some own region | `Valuation.Held` |
| observation | the claims realized, an application obligation | `Frame.realized` |
| the naming | which condition is which relatum | `relabel` |
| the rest relatum | the rest of the whole as one relatum | `World.withRest` |
| a valuation | a disclosed reading of `living` | `Conditions.valuation` |
| a law of exchange | its world's four tying premises hold by the reading | `ExchangeLaw.readWorld_glue` |

<a id="not-assumed"></a>
**Not assumed.**

| Not assumed | Instead |
|---|---|
| that becoming is good, or that every change is generation | one map of generation, keeping and degeneration ([02](02-MAP.md)) |
| inevitable improvement or universal growth; a fixed common utility; independent owners of value | actual relations ([05](05-COLLECTIVES.md)) |
| a definite global causal order at every interface | one shared index, of which the theorems use the order of change |

**What the commitments cost.**

<a id="r-what-discrete-steps-and-whole-amounts-represent"></a>
**Theorem** (periphery, Mathlib with Lean's standard axioms). What steps and whole amounts cost, measured over the reals:

- Take a course in real time whose levels change at the rate given less the rate taken, with summable rates. It balances over every stretch and across every step of any reading at instants, and a coarser reading sums the finer. But a balanced course can stand still at every whole instant and change between them.
- No reading into whole numbers keeps the falls of an amount falling at every step, in any amounts or in the reals. Amounts in multiples of a unit are read in whole numbers.
- A halving level is new at every step without gain. A finite family at or above zero that is new by a fixed separation from every earlier step exceeds every bound.
- Take a held loop of positive real strength `r` carrying a positive initial amount `D`. It carries `D(1 + r)` to the power of its count of coupling steps, and it is bounded by a polynomial exactly where two to that count is. With damping factor `a`, coupling at every step, it carries `D(a + r)^t`. With `D > 0` and `a + r ≥ 0`, it stays bounded exactly where `a + r ≤ 1`.
- A web coupled at every step vanishes below rate one and runs away above it. At rate one, the rate does not decide whether it stays bounded.

`Representation.Course.sample_balances`, `Representation.no_whole_reading`, `Representation.separated_exceeds`, `Representation.held_polynomial_iff`; the damped case is `Representation.every_bounded_iff`; the webs are `Representation.vanishes_iff`, `Representation.unbounded_of_one_lt`, `Representation.rate_one` and `Representation.shear_rate`, with the rate taken in any normed ring with a unit of norm one ([Representation](../../../experiments/integrated-correction/general-framework/generative-basis/lean/representation/Representation.lean); [record](../results/records/what-discrete-steps-and-whole-amounts-represent.md)). It does not show that actual rates are summable or that amounts are real. Nor does it show that the whole-number laws fail where they apply: their forms hold over any amounts with a least fall or a least separation (`Amounts.rests`, `separated_exceeds`). The dense rest theorem's home is the [map](02-MAP.md#r-rest-theorem-in-any-amounts).

<a id="what-a-summary-keeps"></a>
<a id="r-what-a-summary-keeps"></a>
**Theorem** (any process; the access model's two laws on standard axioms: `propext`, and `Quot.sound` in one). Map a detailed process onto a summary.

- The map gives an exact correspondence of finite histories exactly where two things hold: every detailed step projects, and every summary step lifts from each detailed configuration it describes (`projection_exact_iff`, the [root's](01-ROOT.md#r-finite-trace-transport) law; pointwise, `local_exact_iff_trace_exact`). The summary then keeps what is enabled and the feasibility of every finite word, and for a one-to-one map traces correspond end to end (`enabled_projection_iff`, `feasible_projection_iff`, `trace_faithful_iff`).
- An exact summary of feasibility cannot identify two configurations that differ on some finite word (`feasible_difference_implies_projection_difference`). In the access model, a summary from which some reader reads off every word's feasibility separates occupancy throughout the permitted access set (`exact_reader_separates`); with every support permitted and the route fixed, every such encoding of occupancy is one to one (`unrestricted_reader_injective`).
- The access model's exact behaviour with the current route fixed, and a newly admitted access that separates two states every old judgment identified, are [knowing's](03-KNOWING.md#r-access-yet-to-form): the access relations that can still form limit what a current abstraction may forget.
- A configuration can carry the relevant past: every prefix-closed language of finite words that contains the empty word is realized exactly by the process whose configuration is the word so far (`HistoryLanguages.feasible_iff`; pre-spine `history_feasible_iff`); every process's own language is one (`realizes_feasible`, `process_language_exact_history_realization`). Any smaller summary needs its own proof for the questions asked: no process on one configuration has as its language the courses of at most one move (`Bounded.no_one_point_law`).

These laws are stated here; their Lean is the foundation module [GenerativeCore](../../../experiments/integrated-correction/general-framework/generative-basis/lean/GenerativeCore.lean) and the pre-spine modules in `lean/deeper`, among them [HistoryRealization](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/HistoryRealization.lean) and [ReconfigurableSupportLogic](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/ReconfigurableSupportLogic.lean), and the core's [Becoming.HistoryLanguages](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HistoryLanguages.lean) ([record](../results/records/what-a-summary-keeps.md)).

The image through a projection along one run is [03](03-KNOWING.md#r-a-law-through-a-projection-along-one-run)'s.

<a id="covering"></a>
<a id="r-one-move-covering"></a>
**Theorem** (any process).

- The moves of one process at a configuration cover those of another at a configuration exactly where every goal that one move of the other ensures, one move of the covering process also ensures (`covers_iff`).
- Covering is a preorder. Revisions each covering the last cover the first at every stage (`covers_along`).
- A cover fails exactly where not every goal is carried (`not_covers_iff`). With double-negation elimination as a hypothesis, the lost goal can be named.
- Four processes on two configurations are witnesses: more possible outcomes need not cover, covering can remove a possibility, goals ensured separately need not be ensured jointly, and a summary can hide a loss.

These laws are stated here; their Lean is the pure core's [Becoming.MoveOutcomeProcesses](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MoveOutcomeProcesses.lean); [record](../results/records/one-move-covering.md).

The losses of reading a law as a sum over courses (truncation, cancellation, weightings that depend on how one came) are stated in the [root](01-ROOT.md#r-losses-of-the-sum-over-histories).

**Decidedness and listing are local.** Two commitments that looked global turn out to be hypotheses of particular laws.

<a id="r-counts-exist-where-decided"></a>
**Theorem** (any type). A proposition is decided where it holds or fails. The pure core does not assume this, though it can never be refuted. A count of a list's members satisfying a property exists exactly where the property is decided at each member. The count is one number, and where a procedure decides, its marks are the count. The census needs no decidedness: over a stretch, wherever the counts exist, those holding at the end together with those that ceased equal those at the start together with those that came to be, even when the inner steps are undecided. Discrete steps and finite lists are assumed. `counts_iff_decided`, `Counts.unique`, `Counts.over_stretch` ([Becoming.Decidedness](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Decidedness.lean); [record](../results/records/counts-exist-where-decided.md)). The census laws' home is the [root](01-ROOT.md#r-census-balance).

<a id="r-listing-once-is-decided-identity"></a>
**Theorem** (any type). A list can be listed once (by a list without repetition having the same members) exactly where identity among its members is decided, which is never refuted. The number of relata it holds exists exactly then, and is one number. A law that refutes something wherever a list is listed once refutes it of the list with no premise. `listsOnce_iff_decided`, `numbers_iff_decided`, `not_of_listsOnce` ([Becoming.Listing](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Listing.lean); [record](../results/records/listing-once-is-decided-identity.md)).

<a id="flows-however-listed"></a>
**Theorem** (World). So the flow laws whose conclusion is a refutation hold of every family however it is listed, with no decided identity. For example, under balance and dissipation, recurring taking from a family keeps the family from staying closed (`Flow.Dissipative.opens_listing`). A world is finite exactly where some list holds every relatum and identity among them is decided (`World.finite_iff`, no premise). Suppose a world is enumerated (some list, repetitions allowed, holds every relatum) and meets balance, dissipation and embodied arising. Then neither arising nor ceasing recurs; this is non-recurrence, not settling (`World.Enumerated.not_recurring`). Laws that sum or count need decided identity only locally, and a sum law fails over a family that lists a member twice (same module).

<a id="r-relata-counted-up-to-indiscernibility"></a>
**Calibration** (World). Identity read off relations is identity up to indiscernibility: alike at every step in activity, level and taking part, and alike in every relation to every relatum. Up to indiscernibility, a list's number exists exactly where the likeness is decided. Asked of every world, two things are each exactly excluded middle: that indiscernibility is decided, and that each list's number through relations is fixed. What the need says: names carry one decided identity more than relations do. In the probe world, two relata that are two by name are one through relations where a proposition holds. Read by occurrence, every flow lists what takes part once, with no decided identity and with its amounts and premises kept; that reading is a choice. `numbersBy_iff_decided`, `World.indiscernible_decided_iff_em`, `World.numbers_indiscernible_iff_em`, `World.probe_named_apart`, `Flow.byOccurrence_once` ([record](../results/records/relata-counted-up-to-indiscernibility.md)).

<a id="calibrations"></a>
## 5. Calibrations

**What a calibration is.** Where a law holds only under a classical principle, the pure core takes the principle as a hypothesis or proves the law equivalent to it, and asks what the need says about the unfolding. Only a calibration that says something of that kind is a result. One that concerns the logic alone is a lemma of its law.

| Principle | What needing it says | Where |
|---|---|---|
| Decidedness (local) | a count or a named step exists only where its object is decided | [counts](#r-counts-exist-where-decided); over every run it is LPO (`HistoryIdeals.cut_decided_iff_lpo`) |
| Markov | passing from what a finite stretch verifies to a complement that can be refuted | [03](03-KNOWING.md#r-what-a-finite-stretch-verifies) |
| LLPO | choosing a side of a fork that finite stages cannot settle | [the run construction](#r-lifting-where-branching-is-finite) |
| WLPO | a law of the whole and no part | [the tail](#r-what-a-law-of-the-whole-and-no-part-takes) |
| LPO | telling whether a history ends, which is deciding whether it changes again | [settling](#r-the-last-change-of-a-run); naming the step a finite world rests from |
| Weak excluded middle | where it is open whether one move betters another, no move need be known to be chosen | `exists_undominated_iff_weakly`; on frames `FrontierFrames.choice_exists_iff_weakly` ([07](07-SIGNIFICANCE.md#r-practical-judgment-under-living-significance)) |
| Double-negation elimination | a refutable reading holding where it is adhered to; reach without a path | `refutable_holds_iff` ([03](03-KNOWING.md#r-a-history-read-off-its-finite-stretches)), `fromSeed_of_not_separated_iff_dne` (`Becoming.SeedReach`) |
| Excluded middle | names carry one decided identity more than relations ([relata through relations](#r-relata-counted-up-to-indiscernibility)); deciding the four marks on every line, whose boundary is where going on is not decided ([01](01-ROOT.md)) | the arising–ceasing law over every finite world (`World.law_iff_em`) is a lemma of that law, not a calibration: the need comes from activity being an arbitrary proposition, not from change |
| Dependent choice | an infinite course choosing each next step | `runs_iff_dependentChoice`; none is needed within finitely many configurations |

LPO gives WLPO and LLPO (`WLPO.of_lpo`, `LLPO.of_lpo`). That WLPO does not give LPO is known (Akama, Berardi, Hayashi and Kohlenbach 2004) but not checked here. So the pure core states the weaker forms: rest that cannot be refuted, and the least coupling only for laws reading finitely many conditions.

<a id="r-when-the-runs-of-a-process-settle"></a>
**Theorem** (any process). A run that changes within a loop gives a run from the same start, possibly a different one, that goes round the loop and keeps changing, and so does not settle (`Settling.recurs_of_loop`). Conversely, along a run whose visited states all lie in a given list, a change that recurs is a change within a loop of that run (`Settling.loop_of_recurs`). So in a world that a list holds, some run from a configuration keeps changing exactly where a reachable change can be undone (`Settling.keeps_changing_iff`). That no run keeps changing does not give settling constructively: in a process of two configurations with no way back, no run keeps changing (`Settling.OneWay.never_keeps_changing`), and every run from the first settling gives LPO (below) ([record](../results/records/when-the-runs-of-a-process-settle.md); [Becoming.Settling](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Settling.lean)). Worlds that no list holds are outside these laws.

**Calibration** (any process). In that two-configuration process, every run from the first configuration settling gives LPO. A run changes once, at the first `true` of a sequence, so settling decides whether such a `true` comes. What the need says: settling is deciding whether the run changes again. `Settling.OneWay.lpo_of_settles`; the equivalence is `LastChange.lpo_iff_settles` ([below](#r-the-last-change-of-a-run)). The calibration is the canonical LPO instance of constructive reverse mathematics: finding the stage after which a sequence that changes at most once is constant (Bishop 1967; Bridges and Richman 1987; Ishihara). This is a known result, cited and not checked here. The premise ledger is new as an artefact, but each of its theorems uses a known technique.

<a id="r-the-last-change-of-a-run"></a>
**Calibration** (any process). Take a run of configurations with decidable equality whose visited states all lie in a list of `N` configurations and that has no change within a loop. Then:

- it makes fewer than `N` changes (no decidability needed);
- it settles exactly where it is decided at every step whether it changes again;
- that is decided within every finite stretch, and with no further premise the run is not not settled;
- with LPO it settles.

Conversely, the following is exactly LPO: in every world of decidable configurations that a list holds, every run from a configuration with no reachable change that can be undone settles. What the need says: the number of changes is bounded, but the step of the last change is not. `LastChange.changes_lt`, `LastChange.settles_iff_decided`, `LastChange.decided_within`, `LastChange.not_not_settles`, `LastChange.settles_of_lpo`, `LastChange.lpo_iff_settles` ([Becoming.LastChange](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/LastChange.lean); [record](../results/records/the-last-change-of-a-run.md)). For a law's run, a bounded mark of its changes decides it ([02](02-MAP.md#r-where-a-run-of-a-regime-comes-to-rest)).

<a id="r-what-a-law-of-the-whole-and-no-part-takes"></a>
**Calibration** (World, with conditions numbered by the natural numbers). Read the levels at a step as a sequence indexed by the conditions. A number read off such a sequence is changed by no condition where two sequences that differ at one coordinate only give the same number. Exactly then, sequences that agree from some coordinate on give the same number, so only the tail sets it.

The law exchanging such a number reads what has stood and is insensitive at every step to every condition. Where the number differs between two sequences, the law does not read through what it is sensitive to. Over a web in which its formation requires no condition, the couplings it reads through have no least one (`wholeLaw_no_least_coupling`).

Three things each exist exactly where a rule decides, of every Boolean sequence, whether it is false throughout (WLPO as a rule):

- such a number that differs;
- a law insensitive at a step to every condition that still differs there;
- a counterexample to the least coupling.

Deciding vanishing is exactly the LPO rule. Equality of numbers is decided where histories are compared, and the rules are hypotheses. `changedByNoCondition_iff_rule`, `insensitive_differs_iff_rule`, `not_through_sensitive_iff_rule`, `vanishDecision_iff_lpoRule` ([Becoming.Tail](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Tail.lean); [record](../results/records/what-a-law-of-the-whole-and-no-part-takes.md)). That the proposition WLPO gives a rule is not shown, since that step chooses a function from a relation. The least coupling's home is [knowing](03-KNOWING.md#r-sensitivity-is-the-least-coupling).

<a id="r-lifting-where-branching-is-finite"></a>
**Calibration** (any process; with a periphery instance). Call a configuration unbounded where courses of every length start at it. Where branching is finite (successors listed), the depth reached is decided, and an unbounded configuration cannot fail to have an unbounded successor; no principle is needed for that.

That it has one, asked of every finitely branching process, is exactly `EitherThroughout`, which is LLPO for decided families. Two decreasing decided families, one holding at each step, make a fork whose unbounded successor tells which family holds throughout. With that principle, finite branching and a choice of unbounded successors, every unbounded configuration starts a run along unbounded ones. Without finite branching this fails: a root stepping to an arm of every length has no unbounded successor.

`Lasting.step_iff_either`, `Lasting.lifting` ([Becoming.Lasting](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Lasting.lean)), `eitherThroughout_iff_llpoForDecided` ([Becoming.Likeness](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Likeness.lean)); periphery [FiniteBranchingCorrespondence](../../../experiments/integrated-correction/general-framework/generative-basis/mathematical-abstraction/completion/formal/FiniteBranchingCorrespondence.lean), with its own checker ([record](../results/records/lifting-where-branching-is-finite.md)). The run construction gives a run's existence, not an effective selection.

<a id="expressible-is-not-derived"></a>
## 6. Expressible is not derived

**What happens.** A law proved on a model can usually be written in the grammar's vocabulary, but writing it there does not prove it there. A translated theorem carries its premises, and removing one is a separate result. Lifting a law onto the root takes three things:

- a *dependency audit*: which fields and premises the statement and proof reach;
- a *lifting*: the law restated on the grammar with only those;
- a *representation theorem*: the model shown to be a model of the grammar both ways, or the failure written down.

At commit `0cc1aafb4` the audit read 13,828 spine theorems. Of these, 9,370 read no World field; 348 read only `active` (a two-valued distinction along a run, the material of continuation); and 313 (upper bound 605) read all eight ([audit](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/audit/REPORT.md)). Most modules are not yet on the grammar; the [theory graph](../results/THEORY-GRAPH.md) shows which are. Until a law is lifted, it is stated with its model.

**Pairing, power and Lean.** These are known results from the literature, not checked here. A pure relational calculus is as strong as three-variable first-order logic. With paired projections it writes set theory (Tarski and Givant 1987), and with a power it is higher-order intuitionistic logic (Freyd and Scedrov 1990).

**Open.** Whether the classical corpus supplies functional pairing and power. The candidate passages read on review as part and whole or as direction, so both remain conjectures ([06](06-CLASSICAL-TEXTS.md)). A passage read as a functional pairing with its projections would show it.

**Open.** Mutual interpretation with Lean. It would be shown for a named fragment of Lean by compiling that fragment into the grammar and the grammar into Lean, with provability kept both ways, so that neither grounds the other. All of Lean is further off.

**Definition.** A type of configurations says what can be told apart. It has no step relation, so every dynamics on the spine is a supplied step relation or a law read off a run.

<a id="type-formation"></a>
<a id="r-type-formation-gives-no-dynamics"></a>
**Theorem** (any type for the tower, any process for reachability). Iterating `T(n+1)(X) = T(n)(X) × T(n)(X)` keeps being empty, being inhabited and having at most one element, in both directions, and the diagonal keeps distinct elements of the seed distinct. So type formation alone yields no element from an empty seed and no distinction from a seed with at most one element. Reachability is the least reflexive-transitive extension of the supplied steps, and with no steps it is equality (`reach_without_steps_iff`). Composition follows from the history construction. But formal composition manufactures no dynamics and establishes no physical compatibility, and construction depth needs an interpretation before it stands for time. Stated here; the Lean is the pre-spine [ProductTower](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/ProductTower.lean) and [GeneratedPaths](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/GeneratedPaths.lean), with empty axiom reports ([record](../results/records/type-formation-gives-no-dynamics.md)).

<a id="contraction"></a>
<a id="r-contraction-where-duplication-is-reachable"></a>
**Theorem** (any process). Take an object calculus of configurations with identity, steps, cut and framing but no contraction. Suppose it is given a left unit and primitive steps compatible with each declared context. Then the contraction rule is admissible at `a` exactly where duplication `a ⇝ a ⊗ a` is reachable (`admissible_contraction_iff_duplicate`). The validity of a logical rule is here a condition of the process. Derivability is then reachability (`derivation_iff_reach`), and replacing `y` by `x` in every left context is exactly `x` reaching `y` (`replacement_iff_reach`). A companion module (some declarations on `propext` and `Quot.sound`) gives two further facts. A five-state example with a left unit and a context that blocks the step shows that the context hypothesis is needed. On one port, take–release rounds return it to free for any finite number of rounds, and from free two takes with no release between are infeasible. Soundness here means correspondence with finite endpoint reachability only. Binary duplication gives every finite multiplicity, not the exponential modality, and no novelty over linear, graded or Petri-net logics is claimed. Stated here; the Lean is the pre-spine [GeneratedContraction](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/GeneratedContraction.lean), with an empty axiom report and its own [receipt](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/generated-contraction-verification.json) ([record](../results/records/contraction-where-duplication-is-reachable.md)).

<a id="r-becoming-spine-instances"></a>
**Theorem** (any process; the identifications checked before 19 October 2026). Earlier interfaces are instances of the spine:

- seed–edge closures and evaluator chains are reachability on the edge process;
- a frame's reachable configurations form a joint-continuation space, and a map preserving steps and claims carries every jointly realizable bundle;
- a robust response is a common response, with completion as admissibility.

Comparison extends to every frame under L, the conservative rule that every outcome of one response is better than every outcome of the other. L is substantive: in a witness (`LiftModel`), a response with one better and one worse outcome is comparable neither way. Where every live response is extended under L by a live one, none survives. The identifications add no normative premise; several hold by definition, the others by short proofs. `withinClosure_iff_closure` ([Becoming.EdgeClosure](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EdgeClosure.lean)), `LiftModel.some_outcome_does_not_lift`, `lift_continual_improvement_has_no_survivor` ([Becoming.Lifting](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Lifting.lean)). The definitional identifications are in the bridge file kept in `lean/history/becoming/` ([record](../results/records/becoming-spine-instances.md)).

**Conditional** (C and L; lifted articulation or lifted coherence where named). Under L, C extends from outcomes to responses (`comparison_lifts`). With lifted articulation, the extended comparison supplies a reason to move between live responses (`lifted_comparison_supplies_reason`). With lifted coherence, a selected response survives (`lift_coherent_selection_survives`). All three are in the same module.

<a id="describing-from-within"></a>
**A description within what it describes.** How far a description made within what it describes can complete itself is bounded by two results in [03](03-KNOWING.md#r-readings-within-what-they-read): the diagonal over a family of readings indexed by what it reads, and [revision with an undecided value](03-KNOWING.md#r-revision-with-an-undecided-value).

<a id="self-reference"></a>
<a id="r-self-reference-does-not-certify-itself"></a>
**Theorem** (any type; the criteria, the fixed-point equivalence and the term language supplied).

- Carrying a ground over unchanged holds for all values exactly where the recognition set of the premise role is contained in that of the conclusion role (I ⊆ O). Sameness alone does not give inferential continuation, since the standard a conclusion reaches must suffice for it to serve as the next premise.
- Admitting `C ↔ (C → Q)` under implication and reuse of a hypothesis yields any `Q` (Curry).
- In the fragment with no source and one carrier at every atomic index, every closed term of type atom(i) → atom(i) evaluates to the identity.
- Two alternatives (return a surrounding ground, return a new one) show that the arrow type alone does not guarantee carry-over.

So self-reference does not certify itself, and the reference back of a bound use is stipulated rather than derived. A metalogic without presuppositions remains open ([03](03-KNOWING.md#r-constitutive-binding-assessment)). Stated here; the Lean is the pre-spine [ReflectiveIdentity](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/ReflectiveIdentity.lean) and [RecognitionalBinding](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/RecognitionalBinding.lean), with empty axiom reports and their own receipts ([one](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/reflective-identity-verification.json), [two](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/recognitional-binding-verification.json)) ([record](../results/records/self-reference-does-not-certify-itself.md)).

<a id="master-laws-and-connectivity"></a>
## 7. Master laws and connectivity

**One mechanism, stated once.** A master law states a mechanism that many central results share, at the lowest layer that holds it, so that those results are proved through it.

| Law | Statement | Anchor | On the grammar | Central declarations on it |
|---|---|---|---|---:|
| Closure | what a relation carries reaches exactly its closure | `WithinClosure` | `«所闭当且仅当同一或及»`; `WithinClosure` is `«所闭»` by definition | 16 |
| Balance | a level changes by what is given and taken, at each step and over every stretch | `Flow.Balances` | `«守数当且仅当可对»`, `«程守数当且仅当可对»`: represented both ways (`Flow.balances_iff_units`), not derived | 52 |
| Finite runs | where a list holds every configuration, a law merges nothing exactly where every configuration returns (`Law.lossless_iff_returns`); for every law, with no list, a configuration is drawn exactly where it does not return (`Law.drawn_iff_not_returns`); where every course of no rise then a least fall ends, falls along a line that does not rise do not recur, and within a finite budget a least loss makes those courses end (`Amounts.rests`); rest is not a case of being drawn | `Branching.Returns`, `Amounts.rests` | `«入当且仅当有不返»`, `«有限遍后定后则定前当且仅当皆返»`, `«尽则不或屡»`; the row's three laws are proved from them | 14 |
| Lumping | a part read alone carries a law exactly where the rest makes no difference to it | `GoAlikeUnder` | `«像定后当且仅当同行»`; `GoAlikeUnder` is `«同行»` at each move | 1 |
| Order | widening is retaining and adding; the ethics adds the condition for scope and C for order | `Web.Widens` | `«广不可逆»`, `«广之传递»`; `Web.Widens` and `Weighting.WidensOn` are `«广»` of what is admitted | 9 |

The column *On the grammar* names the law's statement in [`Becoming.GrammarLaws`](01-ROOT.md#r-master-laws-on-the-grammar) and how the anchor reads it: every model's law in a row is proved from it, except balance's, which the grammar represents and does not derive. The connectivity measure counts, at each landing, the master laws that a central declaration's compiled type or value reaches. Of 127 central declarations, 88 rest on at least one ([report](../results/completion/COMPLETION.md#master-laws)); the report lists the other 39 by row. Of the 127, 45 now reach the grammar ([measure](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/measure_grammar.py)), and none did before OU3b: all 41 on closure, all 14 on finite runs, 16 of 55 on balance, 1 of 9 on order, 1 of 2 on lumping, and 3 on no anchor, through the laws of steps counted. A law's statement on the grammar (this column) is among its anchors, so a declaration resting on it rests on the law; the finite-run rows rest on closure too, since the grammar proves finite runs' laws from closure's. Counted once each, the 118 distinct declarations fall four ways: 44 reach the grammar; 31 rest on balance, which the grammar represents both ways and cannot state without amounts, so they are no gap; 7 rest on another master law's anchor without reaching it, each with its reason ([audit](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3c-anchors-on-the-grammar/AUDIT.md); for `PartForms.goAlike`, the part carrying a law of its own, a law of its model ([design](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3d-step-indexed-reaching/DESIGN.md))); and 36 rest on no master law. Each of the 36 has its reason ([audit](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ec6-no-master-law/AUDIT.md)): 9 rest on a premise of the account (support, dissipation), 3 on a counting identity (Price's), 7 are laws of their models, 4 single applications of a premise or a closed region, and 13 definitional or representational. The measure has no gap: every central declaration follows from a master law or has its reason. Of the anchors, `WithinClosure` reaches it by definition and `Amounts.rests` by its proof. The others are equivalent to their grammar terms by representation theorems, not equal to them by definition, and the declarations resting on them reach the grammar where they are cases of a grammar law. The measure records dependence, not meaning, and it is no criterion of completion. Why lumping counts only one is not measured. The wider [measure](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.md) found, on the tree at `d652a7756` (core receipt `20261020T075104.511517Z`), 503 of 11,552 spine theorems apart from both families of foundational declarations, resting on 356 apart roots, each classified with a stated reason.

<a id="known-results"></a>
## 8. Known results

**The verdict.** None of the central results is new mathematics: each is near-definitional or a known result restated. The review ranks ten central results and two groups of laws in twelve rows; below, its rank 2 (scope and order) is folded into the significance row. The verdicts come from an AI review that read each Lean statement against the literature it knew ([prior-art review](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#ranked-table)), and the search was not exhaustive. The last two rows, the evolution line of [04](04-LIFE.md), which that review did not rank, carry the verdicts of the audit of the third parts ([below](#third-parts)).

| Central result | Closest prior result | Verdict |
|---|---|---|
| [Coming and ceasing keep pace](01-ROOT.md#r-coming-and-ceasing-keep-pace) | demographic balancing equation; trace theory (Mazurkiewicz 1977) | near-definitional |
| [Recurrence](01-ROOT.md#r-recurrence-without-premise) and [attraction](02-MAP.md#r-attraction-is-not-returning) | finite Poincaré recurrence; Landauer (1961); Bennett (1973) | restated, without decidable equality |
| [Premises carve parts](01-ROOT.md#r-map-of-premises) | independence by countermodels; constructive reverse mathematics | new as an artefact |
| [Rest needs a least loss](02-MAP.md#r-least-loss-rest) | ranking functions (Floyd 1967); Lyapunov; LaSalle; chip-firing | restated |
| [The order of what can form](07-SIGNIFICANCE.md#r-four-cases-of-a-part) | opportunity sets (Pattanaik and Xu 1990) | near-definitional |
| [Closures](01-ROOT.md#r-levels-of-closure) and [selection](03-KNOWING.md#r-selection-through-couplings) | Blackwell (1953); Pearl (2000); the proxy problem (Zhuang and Hadfield-Menell 2020) | restated, with the responsive closure and pools |
| [Joint excess](05-COLLECTIVES.md#r-own-count-misses-joint-excess), [position](05-COLLECTIVES.md#r-relative-position-is-zero-sum) | tragedy of the commons; positional goods (Hirsch 1976) | near-definitional |
| [Learning and identification](03-KNOWING.md#r-identification-where-bounded) | Hume; Fine and Wilf (1965); Moore (1956); Gold (1967) | restated constructively |
| [Significance not in the dynamics](07-SIGNIFICANCE.md#r-what-the-dynamics-leave-open) | is–ought; Gewirth (1978); Parfit (1984); Sen (1977) | near-definitional; scope apart from order a clarification |
| [Loops](02-MAP.md#r-how-loops-form) | nilpotent adjacency; Perron–Frobenius; Maruyama (1963) | restated over whole amounts |
| [Fed from beyond](02-MAP.md#r-continuing-self-fed-from-beyond), [entropy](02-MAP.md#r-least-loss-from-entropy-production), [nets](01-ROOT.md#r-place-transition-nets-on-the-spine) | Schrödinger (1944); Prigogine (1977); ranking functions; P-invariants of Petri nets (Lautenbach 1975) | restated; the nets agree with net theory and are not independent evidence |
| [Evolution on descent](04-LIFE.md#r-evolution-on-descent), [what bounds offspring numbers](04-LIFE.md#r-what-bounds-offspring-numbers), [Hamilton's rule](04-LIFE.md#r-selection-with-returns-to-groupmates), [groups on coupled conditions](04-LIFE.md#r-groups-whose-conditions-are-coupled) | Price (1970, 1972); Fisher (1930); Hamilton (1964, 1975); multilevel selection; Malthus (1798) | restated in counts; joined to the flow, a third part known as the Malthusian bound ([below](#third-parts)) |
| [Drift](04-LIFE.md#r-drift-offspring-sampled), [fixation](04-LIFE.md#r-fixation-by-drift), [mutation](04-LIFE.md#r-mutation-and-the-balance-it-sets) | Wright–Fisher; Moran (1958); Kimura; mutation–selection balance (Haldane); the error threshold (Eigen 1971) | restated as finite weighted bounds |

<a id="beyond-the-table"></a>
**Known results beyond the table** (from the same AI review, against the literature it knew; not exhaustive).

- Training through a learner's own courses is the on-policy point of imitation learning (Ross, Gordon and Bagnell 2011) and the formal kernel of goal misgeneralization (Langosco and others 2022).
- Balance along a relation is the network-flow fact that a divergence is a flow exactly where it sums to zero on each component. The local flux known for lattice automata (Hattori and Takesue 1991; Pivato 2002) is not reproduced.
- Regulation restates deadbeat control and requisite variety (Dahleh and Pearson 1987; Ashby 1956).
- The margin of a regime is harvesting under depensation and the fold (Clark 1976; May 1977), in whole numbers.
- Capture through the rule is observability with the reader inside the plant, the corrupted reward channel and closed-loop identifiability (Wakaiki, Tabuada and Hespanha 2019; Everitt and others 2017; Borkar and Varaiya 1979). A reading shaped by what it selects is neither harder than an exogenous attack on it nor bounded by one.
- Every least loss that physics supplies is a theorem of stochastic thermodynamics, with premises of its own.
- A rule read from the count of its choices ([02 §9](02-MAP.md#r-capture-by-counted-choices)) is the lock-in of increasing returns (Arthur 1989) and, counting the action taken, the value-free habit (Miller, Shenhav and Ludvig 2019); active inference's own simulation of devaluation shows the persistence (Friston and others 2016, §5.2). What the law adds is exactness for a simplified model and its edges, so as a containment of the free-energy principle it is a restatement; the containment's third parts are [05 §9's](05-COLLECTIVES.md#r-identical-cells-under-a-descent-treating-them-alike), [05 §1's](05-COLLECTIVES.md#r-risk-minimization-on-a-shared-renewal) and [03 §6's](03-KNOWING.md#r-what-seeking-cannot-separate). [The principle in the theory](../FREE-ENERGY-PRINCIPLE.md) places each of its quantities and claims.
- Restriction to a record on natural weightings is conditioning ([03](03-KNOWING.md#r-conditioning-by-restriction)): Bayes's theorem in counting form (Bayes 1763; Laplace 1774) holds as a ratio identity, near-definitional, and a prior weight is the prior share only where the likelihood totals agree.
- Variational free energy bounds surprisal ([03 §6](03-KNOWING.md#r-free-energy-bounds-surprisal)) restates Gibbs' inequality and the evidence bound of variational Bayes (Gibbs 1902; Kullback and Leibler 1951; Hinton and van Camp 1993; Neal and Hinton 1998), the free-energy principle's quantity (Friston 2005, 2010), in the periphery over the reals. What is new is the join: the core states the posterior by counting, and the periphery characterizes it as the one minimizer of free energy over the beliefs where it is finite. Gibbs' inequality is classical; the decompositions and the join are near-definitional. For beliefs with natural counts the bound has a counting form, Cauchy's arithmetic–geometric mean inequality in counts (1821), a count being a repetition, stated in the pure core with its case of equality ([03 §6](03-KNOWING.md#r-free-energy-bound-in-counts)).
- The exit from a margin ([02 §5](02-MAP.md#r-exit-from-a-margin)) rests on Kolmogorov's maximal inequality (1928), restated in counting form in `Typicality` with Chebyshev's bound its last step. The exit bound is the unregulated case, not the free-energy principle's quantity, and gives that principle's containment no third part.
- Eventual widening ([07 §2](07-SIGNIFICANCE.md#r-eventual-widening)) is the inclusion form of a tail criterion, and a criterion reading only tails is a dictatorship of the future (Chichilnisky 1996). That its verdicts are dense both ways is liveness in Alpern and Schneider's sense (1985). That, with finitely many admissions at each step, it entails overtaking (von Weizsäcker 1965; Gale 1967) and not conversely is an argument, not proved in Lean. Every law of the record is near-definitional; what it adds is its coherence with widening and its witnesses, the lag among them.
- Orders with a set point ([05 §7](05-COLLECTIVES.md#r-what-a-set-point-optimum-does-beyond)) have a plateau where the set point is reached, as an aspiration level has (satisficing; Simon 1955), and a term counted after either decides within the plateau; that what protects at the set point is the choice among equal optima is mild optimization's point (quantilizers; Taylor 2016), its bound a reading not proved here. The drive of homeostatic reinforcement learning, a norm of the deviations from set points (Keramati and Gutkin 2014), is a nearing order. Neighbours, not containments: the laws restate them for one step, exactly, with the drain below the set point and the draw at it.
- The pace of selection within what flows in ([04 §4](04-LIFE.md#r-pace-of-selection-within-what-flows-in)) is the Malthusian limit read on the lineages carrying an amount, joined to Price's and Fisher's identities, which admit every pace. Its per-parent form bounds the steps one substitution takes from p₀ under a cap on each parent, the form behind the reproductive-excess limit of Nei (1971) and Felsenstein (1971), and not the spacing of successive substitutions that limit states. It is not Haldane's cost (1957), which counts selective deaths the model does not have. The variance bound is density regulation of heritable variance in fitness, under exact transmission of offspring number, and the squared-response law (`response_sq_within_inflow`) is the bound of the selection differential by the opportunity for selection (Crow 1958; Arnold and Wade 1984), with the opportunity bounded by the inflow. Each law is the stock law of the carrying lineages under per-member bounds, and the response, selection, factor, stretch, next-step and offspring-number laws are equalities in its witnesses, so the third part against Price and Fisher is yes and weak, carried by its premises. The natural statement, a pace bounded by what flows into the whole, is false: a part of a closed whole rises by drawing on the rest.
- What keeping widening needs ([07 §2](07-SIGNIFICANCE.md#r-what-keeping-widening-needs)) restates open-systems thermodynamics and finite recurrence: a finite family whose kept widening goes on is fed from beyond, and a finite, closed, balanced world has none, as open-ended evolution measures unbounded evolution against an isolated system's recurrence (Bedau and others 2000; Adams and others 2017). The TAP equation and assembly theory leave conservation out as stated, and their own variants and remarks supply it (Cortês and others; Sharma and others 2023), so the law is no third part against them. Renewers multiplying under upkeep is maintenance scaling, as in break-even investment (Solow 1956) and the maintenance coefficient (Pirt 1965), which semi-endogenous growth (Jones 1995) leaves out as stated; autocatalytic sets are food-generated (Steel 2000; Hordijk and Steel 2004). The exclusion along passing of support is near-definitional, the theory's "every cell from a cell". None of the laws compares two courses, and none is a result no neighbouring field states.
- Comparing two courses on what they admit ([07 §2](07-SIGNIFICANCE.md#r-comparing-two-courses-on-what-they-admit)) has known shapes. On a web of formations on two sides, ranking a course that keeps widening by name above one admitting alike closes a cycle with their mirrors, as Pareto, transitivity and permutation invariance force incomparability between infinite worlds (Askell 2018); here one verdict only is forbidden, and the exchange is an instance of relative anonymity across formations (Asheim, d'Aspremont and Banerjee 2010). Eventual widening is decided by tails, like a dictatorship of the future (Chichilnisky 1996), while widening with a lag constrains every step [AI reading]; a lag for each admission is the analogue of delayed simulation (Etessami, Wilke and Schuller 2001), a uniform lag of delay games with bounded lookahead (Hosch and Landweber 1972). Each law is near-definitional; reading them on admitted ranges, where 07's question is posed, is the contribution.
- What a course keeps reachable ([07 §2](07-SIGNIFICANCE.md#r-what-a-course-keeps-reachable)) restates known orders. Covering is the lower (Hoare) preorder of the families of course ranges, exactly dominance for every criterion closed upward under inclusion, which reads as the unanimous ordinal form of a preference for flexibility (Kreps 1979) [AI reading]; with options unordered it is the inclusion that opportunity-set rankings share (Jones and Sugden 1982), while Pattanaik and Xu's ranking (1990) counts options. That nothing is added to the whole possible along a course is the irreversibility premise of Arrow and Fisher (1974) and Henry (1974); quasi-option value, which needs learning and deferral, is not captured, since covering is linear-time and cannot see when a commitment is made (van Glabbeek 1990). The possible within a horizon restates Kauffman's adjacent possible (2000) for a prestated space, not the one that cannot be prestated (Longo, Montévil and Kauffman 2012), and that no listed range keeps widening is the pigeonhole of finite recurrence. The lexical order is the two-tier order read on realized claims, then reachable ranges, near Sen's achievement and freedom (1985). Each law is near-definitional or a witness.
- Where the possible grows ([07 §2](07-SIGNIFICANCE.md#r-where-the-possible-grows)) restates known accounts as laws on any process. That the possible with what is held grows only across a change of what is held is open-ended novelty's innovation, novelty that changes the model and with it the possibilities of variation (Banzhaf and others 2016), which holds there by definition; continuing inheritable change at the highest levels, as McMullin proposed at the York workshop (Taylor and others 2016), is the informal neighbour of a top fixed for good stopping the growth relative to it, and innovation against fixed-rule systems, found with state-dependent rules (Adams, Zenil, Davies and Walker 2017), is a neighbour of the rule changing its own rule. The tower law's finite support is, in substance, the finite degree of introspection that lets an infinite tower of reflective processors be implemented (des Rivières and Smith 1984; Wand and Friedman 1988), restated with its premise shown needed; Bateson's levels of learning (1972) are the tower's scheme with no law of possibility. The adjacent possible that cannot be prestated (Longo, Montévil and Kauffman 2012) is outside. Each law is near-definitional or a witness.
- Tasks and what performs them ([07 §2](07-SIGNIFICANCE.md#r-tasks-and-what-performs-them)) reads constructor theory (Deutsch 2013) on any process. Its task, constructor and possible are read with delivery existential, exact and without halting, and its examples, catalysis, an impossible transpose, equal and opposite amounts, the additive pattern of a conservation law and the regress of pharaonic tasks, become theorems or witnesses. Its process-theoretic reading (Gogioso and others 2023) has the possible tasks form a sub-SMC of Rel with the attribute preserved in every outcome; here what performs is restored at the end of each delivery, not held, the parallel case holds on interleavings for pairs, and reuse of one constructor, which that reading leaves open, holds for one region in series and in turn. Locality in Deutsch and Marletto's form (2025) gives composition its holding premise for deliveries on their own performer and substrate, and within one interleaving on one substrate composition can fail. The composition principle, a conjectured law, is not contradicted: a delivery changing what its task does not list can break composition, and constructor theory's tasks list it. A delivery adds nothing to the whole possible, and widening follows deliveries in neither direction, ranking a delivered output above its input on one witness and below it on another: what possible tasks carry is the inclusion of the whole possible, not widening. Each law is near-definitional or a witness.
- Precedence and its links ([01 §1](01-ROOT.md#r-precedence-and-its-links)) restates order theory on the root: the links of causal set theory (Bombelli, Lee, Meyer and Sorkin 1987) are the covering pairs, a locally finite order is the transitive closure of its covering relation, and that can fail where an interval is infinite, as on ω + 1. The Lean proves it for naturally labelled orders with decided precedence, with no finiteness, and calibrates the decision as a lemma: reaching every pair of every such order by links is excluded middle. Each law is near-definitional, a witness or a calibration.
- What can be born next ([07 §2](07-SIGNIFICANCE.md#r-what-can-be-born-next)) reads Rideout and Sorkin's classical sequential growth (2000) as a process: internal temporality as holding the past, the timid and gregarious children as the chain's and the antichain's births. That stems reverse the inclusion of precedence is the order-reversing correspondence between orders on one set and their down-sets, the specialization order of an Alexandrov topology, with Birkhoff's representation of finite distributive lattices a neighbour; finding the pair a widening loses is excluded middle, a lemma, and most comparisons of two courses need the empty start. Kauffman's adjacent possible (2000) is read for a prestated space, as what can be born next, and his tentative law, as two reviews report it, leads on the pasts to the course in which nothing continues and on kinds of birth to extremes incomparable at offset 2, a count to five elements, a computation, finding configurations mixing precedence and unrelated elements with the most kinds. Discrete general covariance is read only as relabelling; transition probabilities, Bell causality and the continuum limit are not read. What is new is reading these against the theory's direction: what widening is read on decides what it ranks. Each law is near-definitional, a witness or a calibration.
- The present on causal-set growth ([01 §1](01-ROOT.md#r-the-present-on-causal-set-growth)) restates order theory on the growth. The natural labellings of a finite order are its linear extensions, connected by exchanging adjacent incomparable elements (Mazurkiewicz's traces, an instance of the core's theorem); a finite order is the intersection of its linear extensions (Szpilrajn 1930; Dushnik and Miller 1941); the prefixes of linear extensions are the down-sets, here the stems with decided membership, Brightwell, Dowker, García, Henson and Sorkin's (2003) characterization of their stem sets, here on finite causal sets; and every antichain is the set of maximal elements of its down-closure. The bounds on presence at a birth, a covering pair and the one upper cover, and on being present together, incomparable and the same future, are elementary consequences, not found stated in these sources, and the calibrations are lemmas. The past is the largest relation every course respects, the relation Stein's theorem (1968, 1991) singles out, here as a maximum and not by uniqueness; Wüthrich and Callender (2017), who find his theorem false for a single causal set, grant this local becoming, and on their four elements their relation is the past joined with being present together on every course, elsewhere not in general. Dowker (2014) reads each birth as the passage of time, births of unrelated elements unordered, as the laws on some course state; her present is a birth, not the maximal elements read here. What is new is reading these as the covariant content of presence: 01's open entry on presence in time has an answer in this model for one reading of presence. Each law is near-definitional, a lemma, a witness or a calibration.
- A world's reorderings as courses of growth ([01 §9.6](01-ROOT.md#r-reorderings-as-courses-of-growth)) composes two correspondences: the linear extensions of a trace's dependence order are its interleavings (Mazurkiewicz 1977; Diekert and Rozenberg 1995), here the World's own form of it, and the natural labellings of a causal set are its linear extensions, read as the paths of sequential growth (Rideout and Sorkin 2000; [01 §1](01-ROOT.md#r-the-present-on-causal-set-growth)); the prefixes of a trace correspond to the down-sets of its dependence order, the configurations of its event structure (Nielsen, Plotkin and Winskel 1981). That presence gives persistence of what an exchange touched is an elementary consequence of a footprint containing the exchanges. The composition follows at once from the two, and the review's light search found no paper connecting traces with causal-set growth. What is new is reading the World's interleavings as causal-set growth, so one law of presence across the two models, and what presence means on the World. Each law is near-definitional, a composition, a lemma or a witness.
- What choices show of an order ([03 §11](03-KNOWING.md#r-what-choices-show-of-an-order)) restates rationalizing strict choices by a strict partial order, close to Richter (1966) without completeness and not Afriat (1967); what readings fix of the unread ([03 §11](03-KNOWING.md#r-what-readings-fix-of-the-unread)) is indistinguishability, with the data-processing inequality the probabilistic form of its chain of acts, states and couplings; readers reading readers ([05 §8](05-COLLECTIVES.md#r-readers-reading-readers)) is the deterministic form of an information cascade (Bikhchandani, Hirshleifer and Welch 1992; Banerjee 1992). Each law is near-definitional or a witness; what they add is their place in one account.
- The reading loop ([03 §12](03-KNOWING.md#the-reading-loop)): a reading kept by its update is a safety composition related to possibilistic interpretations of regulation (Virgo, Biehl, Baltieri and Capucci 2025), not the good regulator theorem (Conant and Ashby 1970); what a course chosen through its model does not test is a deterministic case related to self-confirming equilibrium (Fudenberg and Levine 1993) and incomplete learning (Rothschild 1974), with a two-run obstruction beside safe exploration; acts alike from a model or an order illustrates the ambiguity between beliefs and preferences (Armstrong and Mindermann 2018; Reddy, Dragan and Levine 2018); for a prediction read by what it predicts, on the chain 0 to n under a response mapping it into itself and keeping its order, publication from zero reaches Tarski's least fixed point (1955) by step n, beside the existence of a correct public prediction (Grunberg and Modigliani 1954; Simon 1954). The laws are near-definitional, general laws of blanketed laws, or witnesses; what they add is their place in one account.
- A revision of a reading that opens a correction ([03 §8](03-KNOWING.md#r-a-revision-that-opens-a-correction)) composes GuardHorizon's choice from readings with Revising's stock and link along a trace of one process, the acceptability fixed; its relation to double-loop learning (Argyris and Schön 1978) depends on whether inquiry changes a governing norm, which it does not here. Near-definitional, with witnesses on Revising's process.
- Identical cells under a descent that treats them alike ([05 §9](05-COLLECTIVES.md#r-identical-cells-under-a-descent-treating-them-alike)) and risk minimization on a shared renewal ([05 §1](05-COLLECTIVES.md#r-risk-minimization-on-a-shared-renewal)) bring known results into the free-energy principle's terms: Curie's principle (1894), Turing's remark that morphogenesis from a symmetric state needs disturbances (1952) and symmetric choice in anonymous networks (Angluin 1980), and the commons (Lloyd 1833; Hardin 1968) with pivotality (Palfrey and Rosenthal 1984). Each law applies a landed law (the commuting law, the outrun law, the held pair of a set point) to an explicit model in the principle's terms, or is a witness; that alike cells stay alike needs only a descent reading no cell's number. They forbid three statements of the principle's literature read as guarantees, the second only in its wording, not the papers' simulations, which break the symmetry by random starts and have no shared draw. Each law is near-definitional, an application or a witness.
- The Markov blanket as a coupling structure ([03 §1](03-KNOWING.md#r-the-markov-blanket-as-a-coupling-structure)) is the deterministic case of the time-unrolled blanket (Virgo, Rosas and Biehl 2022), Pearl's blanket (1988) of the internal course in the law's unrolled graph; it adds the agent form, a policy a selection through its sensory course, and, on a blanketed agent, T6's invisible half for every model and policy, joined to the World's coupling for its witness. What the existence claim forbids ([03 §6](03-KNOWING.md#r-what-the-existence-claim-forbids)) states in counting form what the principle's proponents concede, that the claim is not falsifiable alone (Ramstead and others 2023). Each law is near-definitional, a composition or a witness; no sentence of the principle's literature is forbidden.
- Expected free energy and its terms ([03 §6](03-KNOWING.md#r-expected-free-energy-and-its-terms)) states the principle's two decompositions and its information-gain form in the periphery beside free energy, and that expected free energy reads beliefs only through the lumping its likelihood makes. What seeking cannot separate ([03 §6](03-KNOWING.md#r-what-seeking-cannot-separate)) is identification (Rothenberg 1971) in its Bayesian form (Poirier 1998), stated for seeking, each experiment chosen from the course: it forbids the unqualified wording of inherent self-correction (Wen 2025), not active inference's account. The decompositions are the principle's definitions and the other laws near-definitional or corollaries; new is the seeking form.

**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control). The market model is also a conventional dynamic system of resources and incentives. A conventional controller with identical equations predicts exactly the same results, so the theory's vocabulary adds no mathematical advantage there. Its contribution is a connected statement of which supports, rewards, rule dynamics, costs and affected centers must be composed, with explicit boundaries of sufficiency and failures ([source](../history/MARKET-DYNAMICS-MATH.md)).

**Where interpretation exceeds the theorem.** The review found prose saying more than four of these theorems prove, and the chapters keep their prose within the theorems:

- that the selection laws show why alignment is hard, or found it. In fact they restate the proxy problem more weakly than Zhuang and Hadfield-Menell ([03](03-KNOWING.md#r-selection-through-couplings), [07](07-SIGNIFICANCE.md#r-alignment-approaches-under-the-selection-laws));
- that there is no absolute self, which the dependence laws do not prove ([07](07-SIGNIFICANCE.md#r-self-concern-through-dependence));
- that nothing a part senses shows how near a break is. The theorem assumes the stock is not sensed, and the early-warning literature (Scheffer and others 2009) shows the general claim false ([03](03-KNOWING.md#break-seen-coming), [02](02-MAP.md#r-runaway-distance-uncoupled));
- that the census is a law of how anything comes to be in every universe ([01](01-ROOT.md#r-coming-and-ceasing-keep-pace)).

**What survives.** Three things survive, none of them a discovery:

- the premise ledger, with witnesses both ways and its calibrations;
- the ethics with scope and order apart (the universalization step is Gewirth's, and C is the monotonicity of opportunity sets);
- one vocabulary for conservation, selection limited by observation, and comparison of opportunity sets.

A theorem a specialist would not foresee, a prediction that could fail and does not, or a premise derived from something weaker would change these verdicts.

<a id="third-parts"></a>
**Third parts** (an AI audit of the rows above and of §9's unifications, against the literature it knew; [audit](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue0-third-parts/AUDIT.md)). A containment of a framework has a third part where the theory forbids something the framework leaves open. Of the 21 rows the audit read, four have one, three of them distinct:

- the order of what can form, weakly: under balance with requirements as thresholds, a part narrows what another can form only by a net draw beyond that formation's margin ([07](07-SIGNIFICANCE.md#r-closing-needs-net-draw));
- joint excess under the gate: steps of joint excess from below the renewal's reach end every dependent at that need, whatever each drawer's own draw ([05](05-COLLECTIVES.md#r-own-count-misses-joint-excess));
- the optimum laws, which carry the drain in §9's first and fourth unifications ([05](05-COLLECTIVES.md#r-what-an-optimum-does-beyond-what-couples-in)).

In the evolution line's rows, which the audit added to the table, Price's equation and Fisher's theorem joined to the flow have one as well ([04](04-LIFE.md#r-what-bounds-offspring-numbers)); drift, fixation and mutation have none. Each joins a framework that lacks conservation, renewal over time or a threshold to a premise or law of the theory, and forbids what the conjunction forbids. The free-energy principle's containment ([02 §9](02-MAP.md#r-capture-by-counted-choices)) has three, joining claims of its literature, read as guarantees, to a descent reading no cell's number, the held pair of a set point and the outrun law: identical cells under a descent that treats them alike stay alike ([05 §9](05-COLLECTIVES.md#r-identical-cells-under-a-descent-treating-them-alike)), and neither alike preferences for one's own nor risk minimization keeps a renewal the joint draw outruns ([05 §1](05-COLLECTIVES.md#r-risk-minimization-on-a-shared-renewal)); each is known (Curie 1894; the commons). Each forbidden statement is known in a neighbouring field (critical depensation, the Malthusian bound, bioeconomics, scheduling), and none is one a specialist there would not foresee. So the theory reaches farther than each contained framework alone, and not yet farther than the sciences taken together. A further search in three rounds, over the audit's candidates, the root's laws and the one candidate the audit left unlocated, found no result that no neighbouring field states ([search](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue6-beyond-the-sciences/VERDICT.md)).

<a id="theses"></a>
## 9. Theses

**Strength as content.** A theory of the world is judged by what it forbids. Strength is the observations a claim excludes; standing is how far it is established (proved under named premises, supported by frozen tests, conjectured, argued); the two are kept apart. A thesis adds no theorem, a refutation removes none, and a failure stays recorded beside the thesis. Each home chapter states the thesis in full, with what would refute it; the table copies its standing, what it forbids and its evidence.

| Thesis | Home | Standing | Forbids | Evidence |
|---|---|---|---|---|
| T1. Persistence certifies the joint draw | [02](02-MAP.md#t1) | in the model the point of no return is exact and, the draw positive, at least the draw above a need where giving stops below it | a condition below a need measured in advance returning with nothing given from beyond; a dependent active while its condition stood below its need | passed on held-out yeast regimes (MQ2), a simulated Allee yeast (MQ1), a gated commons (CG1); failed at the instrument's floor (MQ1), after a salt shock (MQ2 C1), in fish stocks under held catches (MQ3), in yeast at constant regimes and past the fold (MQ6: 3 of 10 frozen verdicts passed; the fate reading at the instrument's floor, the predicted need near the fold, the timing of both breaks and three of four level forecasts failed); no field test of a need measured in advance |
| T2. The state of a renewable condition under a draw is its level, its recent giving and one lag | [02](02-MAP.md#t2) | conjectured, on three frozen fish-stock tests; untested outside fisheries | a fourth variable removing a tenth of the residual variance in the median series; the level alone forecasting as well at five years; the lag's coefficients changing sign between series | MQ4 failed its whole-state verdict; MQ5 passed; MQ7 missed its frozen bound (0.39, lower bound 0.00); in MQ6's yeast, residuals at one constant dilution, never past the fold, carry nothing day to day, outside the settings that could refute T2, and the runs past the fold measured none of its forbidden items |
| T3. Optimization drains what lies beyond its couplings, where that gives room | [05](05-COLLECTIVES.md#t3) | the law for optima proved; the clause on trained systems conjectured, with partial support | with outcomes, couplings and reward fixed and the optimality gap measured: a system nearer its optimum leaving a room-giving condition beyond its couplings higher; a drive on a condition sharing no units with anything rewarded; where room exists, a side-effect term ranked after the reward protecting a condition, or a constraint at the need leaving a margin; an instruction not bringing a dependent into what learners couple into yet keeping it more often | CG1: the own-catch learner took the last apple in 118 of 118 decisions, the coupled one in 0 of 2,360, C2 failing; MQ1: side effects predicted 8 of 8 against 0 of 8; IN1: no untold dependent kept; CG2: two predicted keeps failed; LA1: both open settings passed, and the locked side failed in two of four settings, its misses worth 92.5% to 98.2% of the best; LA1b, with the feedback resolved and the best threshold assigned: every verdict passed, all 30 locked seeds ending at the best threshold, so LA1's failure reads as feedback that barely resolved it; LA1c, with no round assigned: its selection prediction passed on both sides, 29 of 30 locked seeds and 8 of 10 open ones ending at the best threshold, the two open misses never reaching the thresholds where restraint pays; the LA1 series tests the bridge to a stated reward's optimum, its stock left at the end inside the reward, not a drain beyond the reward's couplings; overoptimization in the literature; limits in SE1 and CG3 |
| T4. The scope can be installed, and it carries | [07](07-SIGNIFICANCE.md#theses) | IN1 partly passed (with talk, one model of two); transfer untested | the instruction raising the keeping of a dependent no member is told of; with all three couplings, a model whose joint account is right, checked apart from the outcome, with nothing added by the scope | IN1, frozen: with talk one model kept the seen dependent in 8 of 10 seasons with the scope, 3 of 10 with the community's goal, 0 of 10 unseen; the other failed even with talk; no condition kept an untold dependent |
| T5. The order is shared by every valuer who counts everything positively | [07](07-SIGNIFICANCE.md#theses) | reduction proved under net weightings (by one item; by several where every item counts above zero), not for orders neither additive nor transitive; the bound conjectured; valuing positively is C's premise relocated | narrowings ranked above their widenings beyond misreading, with no negative valuation measured apart | VD1: every frozen rule failed; VD2, sign measured apart: X1s and X2 passed, X1 and X3 failed; role-play judgments, human valuers untested |
| T6. A break is seen coming only through what couples into what breaks | [03](03-KNOWING.md#break-seen-coming) | the invisible half proved on the World model; the seen half proved in the periphery, in the linearized and logistic models; one law across domains, and "only where" beyond these models, conjectured | given the stock's own course, its early-warning statistics separating runs in which a dependent's need is crossed from runs in which it is not, the dependent taking no measurable share | EW1, the literature, consistent; three frozen seabird tests did not reject it at their thresholds: EW2 at low power, estimates in the refuting direction; EW3 near zero, not independent of EW2 (it reuses part of its rows); EW4 at moderate power; none establishes conditional independence |
| T7. A measure read from what it selects outlives its refutation | [02](02-MAP.md#t7) | in the model only invariance under what the loop does not read, and the lock outliving a growing unread coordinate, proved; that actual metrics are so formed conjectured | such a metric dropped by its selectors on evidence alone; a reform of the reading alone outlasting the next reading | LA2, a lock in a self-rewarding loop in one trained system: every frozen verdict passed and the bridge failed, one note of the loss among nine readers turning the judge, so 02's third forbidden case occurs at that reading, though the frozen rule for it, which reads the end, did not support it; read by nobody, the loss grew under a lock formed from the loop's own selections; read by every reader, it turned the course; read in time by the readers the selection thins, the counts alone turned it |
| T8. 生生 as the direction | [07](07-SIGNIFICANCE.md#theses) | argued; both warrants open | a mixed case argued better from every standpoint counting everything positively, with no further premise; a good that is a pure closing | the finite theorem `Weighting.widens_iff_every_of_class` beneath it |

<a id="what-the-unifications-claim"></a>
**What the unifications claim.** Four results known in substance are each claimed as one law across fields that state them apart. The literature here is from the AI's knowledge unless a linked check read it. Read as a correspondence, a unification adds no theorem and changes no verdict of [§8](#known-results). Read as a thesis, it forbids what the source fields leave open.

| Known in substance | Claimed beyond the source field | Standing |
|---|---|---|
| supervisory control (Ramadge and Wonham 1987), under partial observation (Lin and Wonham 1988; Cieslak, Desclaux, Fawaz and Varaiya 1988) | reward, training, natural selection, prices and votes as one selection through couplings; the drain lies wherever room lies (the commons in evolutionary biology, Rankin, Bargum and Kokko 2007) | the laws proved; one law across domains conjectured (T3) |
| Pareto unanimity; monotonicity of opportunity sets | C as the whole of the order: what every valuer who counts everything positively already holds | reduction proved for net weightings; the bound conjectured (T5) |
| Landauer's and Bennett's irreversibility | one merge across computation, heat, extinction and forgetting (`Law.lossless_iff_returns`, `Law.withHistory_never_returns`) | the law proved for determined maps on finitely many listed configurations; its reading across computation, heat, extinction and forgetting a correspondence; kept as a law, since as a thesis it forbids little |
| Zhuang and Hadfield-Menell's Theorem 1 | overshoot, externality and Goodhart's law as one law of the optimum under room | the optimum law proved; across domains conjectured (T3), supported in simulation (MQ1) |

<a id="one-relational-unfolding"></a>
**Thesis** (philosophical, argued; not one of T1–T8). *One relational unfolding:* there is one unfolding, and whatever is, is how it relates within it.

The representation needs nothing beyond relations:

- a configuration is how it relates (`identifiesAlike_iff`);
- a law is read off the history it governs (`shown_le_iff`);
- separation loses exactly the relation (`separation_faithful_iff`);
- read off one exchange, the eight World premises divide as [§4](#premise-card) says: four hold by the reading, the census where a named family closes each step and in every finite world, participation listed without repetition, and three are states of the law ([01](01-ROOT.md#r-premises-read-off-the-exchange), [census](01-ROOT.md#r-census-read-off-the-exchange)).

These show that configurations, laws and parts, as represented, need no determination beyond relations; that the theory as a whole needs no independent entity is argued, not proved. Neither shows that reality has none. The thesis forbids an explanation that needs a determination no relation carries, such as an intrinsic value, a self that goes on closed, or a law outside what it governs. It would be refuted, for example, by two configurations that no test or relation tells apart and that go on differently. Its neighbours are ontic structural realism (Ladyman and Ross 2007), process philosophy, dependent arising and the identity of indiscernibles.

<a id="internal-relations"></a>
**Reading** [AI reading, D65]: *the passage from inclusion to relation.* Read off one exchange, balance, only active giving and taking, and activity needing support hold by what their terms are, so the central laws that take them are laws of the exchange; the reading, its case for locality and what it does not reach are stated in the [root](01-ROOT.md#what-internal-means).

<a id="names"></a>
## 10. Names

**Criteria.** Names are structural and exact: formal, scientific and systems words, not dualist, limited-scope, social or financial ones. A name is adopted only where the statement means exactly that, and it is given at claim time. A renaming after landing needs a name that states a wrong meaning. "Couples into" replaced "registers", which presupposes a knower facing a world. The working names are a reading [AI reading, D36]. Five declaration names keep market words (`MergeClass.spent_consumed`, `Flow.Balances.rise_paid_from_beyond`, `OwnStores.second_store_spent`, `OwnStores.second_spent`, `Coverage.charge`), and each receipt lists them.

**Reading** [AI reading, D2, D36, D45]: *Chinese terms.* The Chinese editions write the one unfolding 展开 (zhǎnkāi), a formation and its forming 形成 (xíngchéng), and becoming 生成／变化. They keep bare 生成 (shēngchéng) for generation, the opposite of 退化 (tuìhuà, degeneration). Arising and ceasing, 生起／止息 (shēngqǐ/zhǐxī), are activity starting and stopping, kept apart from generation and degeneration.

<a id="retired-labels"></a>
**Retired labels and names, explained once.** Since the condition is not asserted, there is one theory with a conditional section. Two sweeps renamed Lean declarations and left statements and proofs unchanged. On 18 October 2026 the registration vocabulary was renamed ([table](../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/development/n1-migration/RENAME-TABLE.json)). On 20 October, 336 declarations whose names stated a wrong meaning or collided were renamed ([table](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/r30-names/RENAME-TABLE.json)). Older records and receipts are read through these tables. The cases met most often:

| Old | Current |
|---|---|
| G0 (the label; Lean `G0`) | living significance (`LivingSignificance`) |
| S0, N_rel, N_std | self-significance; relational and standpoint neutrality |
| the one axiom | the continuation condition, stated and not asserted |
| Part I, Part II | the theory without the condition; its conditional section |
| the G0/J route | the conditional alignment route |
| J1–J4 as `PracticalJudgment` | the practical commitments (`Lexical.BasicPriority`, `Requirement.Frontier`) |
| the Universal Metaethical Core | significance, comparison and practical judgment |
| folding | restating an axiom as a condition |
| 归于静止 (guīyú jìngzhǐ, coming to stillness) | 停息 (tíngxī, coming to rest) |
| `Web.Registers` | `Web.CoupledInto` |
| `Learning.learner` | `Learning.byElimination` |
| `Becoming.Generation` | `Becoming.Arising` |
| `Flow.Lossless` | `Flow.Conserving` |

<a id="reviews"></a>
## 11. Reviews

**Every review so far is by AI.** Twenty numbered reviews and three others checked existing results ([ledger](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/REVIEWS.md)); the nineteenth found five errors, eight overstatements and no false theorem. No human review is claimed. Since some evidence is coding by language models, it was tested whether a model misses what it planted in its own text.

<a id="r-fidelity-coders-on-own-and-other-texts"></a>
**Assessment** (the coding method, against referents planted knowingly; model-coded, provisional, reviewed at its scope). The test used 240 English statements, written and blind-coded by two model families, each coding its own texts and the other's. It detected no negative combined interaction between author and coder for referents planted in the coder's own text (interaction +0.02, interval −0.05 to +0.08). The interval is uncertainty, not evidence that neither family has a deficit. The two families identify only the sum of their self effects, so one family's deficit could be masked by the other's advantage. One family lists more excess in faithful texts (+0.16, interval +0.08 to +0.24).

Design and analysis were committed before any text was written; plants made knowingly were the ground truth; there was no human audit. The test does not show three things:

- that a model has no blind spot for its own classical code: the texts were English, and the classical case is untested;
- which coder is miscalibrated on excess that was not planted;
- each family's self effect apart.

[Record](../results/records/fidelity-coders-on-own-and-other-texts.md); the count it tests has its home in [06](06-CLASSICAL-TEXTS.md#r-fidelity-of-the-classical-statements).

<a id="open-programme"></a>
## 12. The open programme

**The target.** One unified, complete, enclosed theory with zero axioms, where "zero axiom" means no substantive axiom, not only no ethical one. The target does not require deriving the value of every contingent local law. It requires warranting whatever universal content the theory asserts, while keeping explicit the particular content an application uses. Calling an input immanent, or moving it into a definition, does not discharge it. Finding an input in a local model does not show that it is unexplained throughout the theory. And the target does not begin from an inert space of independent things to which relation must be added.

Explaining how evaluation forms is distinct from justifying what deserves favourable appraisal, though both happen within the same unfolding. A richer description can correct the factual grounds of a judgment without establishing its standard. "Good", "harmful" or "fitting" must not silently supply the conclusion they are meant to explain.

<a id="r-theory-of-becoming-foundation"></a>
**Open** (target). The deductive necessity of becoming as a whole, with no added substantive axiom. Formally, this means every central law over every law of exchange. Philosophically, it means the whole's determinations as moments of one unfolding, with generation, persistence, degeneration, dissolution, life, evolution and evaluation within it.

Reached in the formal part: each of the 33 central statements that takes a tying premise has a form over a world read off an exchange (K3), keeping its other hypotheses, and the premises divide as [§4](#premise-card) says ([01](01-ROOT.md#r-premises-read-off-the-exchange)). Not reached: that every becoming has such a law with finite courses, and the passage from inclusion to relational constitution, which is argued in the [root](01-ROOT.md#what-internal-means). The reused results do not supply the deduction. The necessity is the target, not an axiom, and no impossibility is claimed ([record](../results/records/theory-of-becoming-foundation.md)).

The ethical orientation is a second target. One derivation runs from the characterization of significance to the selection of grounded widening, its normative hypotheses named (K6). The ethics rests on the continuation condition for scope and C for order, and the practical results add the commitments named in them; what follows is checked, and the warrant is open. An absence of ethical axioms is not an absence of substantive premises.

<a id="completion-criterion"></a>
**The completion criterion.** K1–K7 were adopted on 20 October 2026 and run at each landing ([`completion.py`](../../../tools/research/completion.py), [report](../results/completion/COMPLETION.md)):

- K1, coverage;
- K2, unity of the base families;
- K3, premises named, with witnesses;
- K4, representation: every listed natural-number law has a dense form or a counterexample;
- K5, enclosure: every listed supplied parameter is a named hypothesis ([§4](#supplied-parameters));
- K6, one ethics chain;
- K7, an open register: each item [below](#open-items-ranked) has one class, a distinct title and an open part.

On the registered coverage, the configured checks have no finding. That is all they establish. They read statements from Lean source text, not from elaborated terms, so a premise named only through a definition that a statement unfolds is not found. K5 looks only for the parameter patterns the coverage file lists, and K4 only at the natural-number laws it lists. So the criterion is completion in a qualified sense, not a proof that every premise is named, and not a proof of necessity.

<a id="the-work-by-its-own-laws"></a>
**The work read by its own laws** [AI reading, D66]. The laws apply to the work that states them, and they say what the criterion cannot.

- *What the checks reach.* A selection reaches exactly what couples into its selector ([03](03-KNOWING.md#r-selection-through-couplings)). The work's selectors are the Lean checker, the completion and record checks, and the AI reviews ([§11](#reviews)). Human readers, coordination among people and trained systems couple into none of them. So no check run inside the work can show that the work serves what it is for: a truth anyone can check, and through it shared understanding and coordination ([OPENING](../OPENING.md)). A clean run of K1–K7 is completion in the qualified sense above and no more. Only coupling those in widens what the work's selection reaches: review by people ([review status](#review-status)), tests on trained systems ([T3](#theses)), models of the test systems ([01](01-ROOT.md#open)). For that reason an item is weighed by which of these it serves before it is claimed, and a refinement that serves none waits.
- *What the work draws on.* The work's selectors take in no reading of what renews the people who carry it, while its parallel lines each draw on their attention. The work is not a flow, and the law is used here only by analogy: takers each within what is renewed can together exceed it, and where they depend on it the excess ends what depends on it ([05](05-COLLECTIVES.md#r-own-count-misses-joint-excess)). So the work's pace is weighed against what renews its carriers, as its items are weighed against its purpose. Objections a reader raised in conversation, each with where the account stands, are read in [a study](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/hc-a-conversation-at-home/NOTE.md).
- *Completion is not closure.* Under balance and dissipation, a finite family without repetition in which embodied members arise at arbitrarily late steps is not closed from any step on ([04](04-LIFE.md#r-generation-is-replenishment)). The work is not a flow, and the law is used here only by analogy: an account of an unfolding that keeps generating is not finished by sealing it. Completion is read three ways instead:
  - the central laws stated once on one root, with the work's own making readable as a case of them (open item 1; this paragraph is one such case);
  - an exact statement of what cannot be shown, which is itself a finished result about the account's edge ([07](07-SIGNIFICANCE.md#r-what-the-dynamics-leave-open), [§4](#premise-card), open item 12);
  - an account small and plain enough to be read, checked and continued outside the work's own selectors.
- *Where the ethics turns.* That no statement reading only the represented dynamics entails the condition is a fact about the representation, in which significance is a parameter nothing else reads ([07](07-SIGNIFICANCE.md#r-what-the-dynamics-leave-open)). It does not show that the unfolding leaves the question undetermined. Where significance held de se is a center's own closure along a relation, the condition reads only that relation: it holds exactly where every center's closure is the whole (`ownClosure_unrestricted_iff`, [07](07-SIGNIFICANCE.md#r-what-the-step-across-standpoints-reaches)). What is open is which relation a center continues along, which is the step of invariance ([07](07-SIGNIFICANCE.md#step)). That is a question about the unfolding and the classes put over it, which the proofs make exact and do not settle. C alone orders. The work serves the question by stating it where readers can take it up.

**What would change the account.**

- A becoming not representable by discrete steps and a local law with finite courses would extend the spine.
- A refuted lifting or a World premise that cannot be derived would change the root.
- A frozen test failing where a thesis forbids would move the thesis.

<a id="open-items-ranked"></a>
### Open items, ranked

The items are ranked by how much settling each would change the theory as a whole. The ranking is the AI's, from §5 of the [twentieth review](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-TWENTIETH-REVIEW.md#5-what-complete-means), and a better argument changes it. Each item has one class: further proof, philosophical warrant or empirical. Finer next steps are in each record's `next_delta`.

1. **One base, and the laws over every law of exchange** (further proof; the formal part of the first target). Landed: the base is the grammar, with processes and the World as its models ([01](01-ROOT.md#instances)); every run is a world that fixes it, and every web and flow over one kind of relatum is a world's (`Frame.world_fixes_run`, `World.of_web`, `World.of_flow`); the central laws taking a tying premise hold over what is read off an exchange ([the target](#r-theory-of-becoming-foundation)); a law reading at one step relata no exchange there connects is read on a chosen interleaving (`Pair.apart_differs`). *Open:* lifting the World and process laws onto the grammar ([§6](#expressible-is-not-derived)), which law holds (item 7) and the representation (item 6).
2. **One evaluative chain** (further proof). Landed: on level paths the condition, living significance and C read one object (`Web.paths_one_object`); on a web whose valuation is connected, with something living, a standpoint and living decided, the condition is exactly the evaluation's grounds with significance for what does not live (`Web.unrestricted_iff_grounds_beyond`), and the direction's widening and pool selection follow from them (`Direction.grounded_widening_selected`, K6). *Open:* whether a component of further generation can enter a reading of `living`, with other readings of "more" ([07](07-SIGNIFICANCE.md#condition)).
3. **How evaluation forms within the unfolding** (further proof). Landed: with standpoints as formations and `own` a closure, `sig` is the only supplied evaluative parameter; dependence alone carries of a level exactly what rises with it, up to a bound (`carried_iff_rising`; [01](01-ROOT.md#one-relation-or-two)); where a formation's acts return, everything it acts on lies within its coupling closure, for every coupling by level, and with coupling by threshold only its acts return exactly where everything it acts on does (`Flow.ReachReturns.represented`, `Flow.reachReturns_iff_represented`; [03](03-KNOWING.md#r-where-a-formations-acts-return)). *Open:* whether a returning loop persists along a run; which responses to earlier levels, and to several levels at once, dependence alone carries.
4. **The alignment direction on the spine** (further proof). Landed: the direction on a world's moves read as a part's acts under one law of exchange (`Direction.exchange_direction`), with the handover case as a core instance (`Requirement.Handover.direction`; [07](07-SIGNIFICANCE.md#direction)). *Open:* no formal part; the premises the chain names (the rest reading through coupling, the acts agreeing within the closure, a comparison meeting J1/J2) are questions of warrant and correspondence.
5. **What widening compares** (further proof). Landed: widening along a supplied reading of one world's formations in another's (`Web.grow_widensAlong_iff`), and across a stretch along a continuation, where the reading is derived (`Web.WidensAcross`; [07](07-SIGNIFICANCE.md#order)). *Open:* a measure for mixed parts, a premise beyond the condition stated without hiding it in inclusion; comparing renewal capacity and richness of relations.
6. **Amounts that may be dense** (further proof). Landed: rest needs no least loss where the amount is read off finitely many configurations (`Amounts.rests_of_finite_reading`); the rest theorem holds over any amounts exactly where the census's total stops falling (`World.InAmounts.change_stops_iff`); each listed natural-number law has its dense form or a counterexample (K4). *Open:* a least loss in energy from the pure core, which needs a reading of count as energy and, since Landauer's count so read bounds heat exported rather than exergy destroyed, irreversibility as well; whether rest over every world in given amounts is, constructively, the absence of an endless fall; the other laws over any amounts; the gap between the damped laws where a coupled step's norm exceeds its rate.
7. **Which law holds, and how a member's law comes about** (further proof). Landed: a member reading another's couplings, coupled by level into everything the other couples into, is pooled with it (`Flow.withinCoupling_reads_iff`); knowing another's law adds anticipation exactly where a member couples as finely, never reach (`Web.anticipates_iff`); training installs a law only along its own courses, and off them, among laws reading through a lumping of histories, installed exactly where the lumping cannot tell a history from a course, and, with laws reading what has stood and the lumping decided, free elsewhere, responding or not (`Training.installed_where_lumped`, `Training.response_free_where_unlumped`; [07](07-SIGNIFICANCE.md#r-what-training-installs)). *Open:* the law of exchange itself; an actual system's lumping and neighbourhoods, read empirically; which law closes rather than widens a difference beyond a single loop; probabilistic learning and implicit bias.
8. **Identity from continuity, not naming** (further proof). Landed: conservation fixes identity except where standings coincide (`World.fixed_iff`), and there a balanced naming continues either relatum as the other (`World.continues_as_alike`); arising, the formation classes, tenure and undermining are read along a continuation (`Becoming.ContinuedClasses`; [01](01-ROOT.md#r-identity-across-steps)). *Open:* continuations derived from informational or organizational relations.
9. **Evolution's selection term** (further proof). Landed: Price's selection term in counting form, offspring number bounded by what is given and taken, selection within and among groups and by ending, Hamilton's rule for groups founded mixed, drift and fixation, mutation and its balance, breeding values, and where a dependence forms anew ([04](04-LIFE.md)). *Open:* why a descendant comes to depend on what its giver drew on; drift with selection, and two-way mutation with drift; mixing between groups, changing assortment, synergy and unequal sizes; wholes founded by several parts, and how parts first come to live as one; rational amounts; natural-coefficient solutions of the normal equations.
10. **What a rise draws from beyond** (further proof). Landed: the beyond falls by the rise and the loss (`Becoming.DrawnBeyond`); a joint draw breaks the highest needs first (`Becoming.JointDraw`); with room, every optimum of any order rising with what couples in stands at the least level beyond and breaks exactly the dependences there that some outcome breaks; several at a mutual best response leave the beyond where one of their joint capacity would (`Optimum.mutual_as_one`); laws over courses against a renewal, horizons, weightings and drawers in turn (`Becoming.Optimum`; [05](05-COLLECTIVES.md#optimum)). *Open:* a worth on what is left where the most a course can leave is not regrown in one step; the optimum where a level of greatest gain is out of reach; drawers ranking courses; perfect profiles where some portion returns more than one for one, or under capacities away from the last step; takes outside a mutual best response; replenishment from outside the whole.
11. **The practical premises under the condition** (further proof). Landed: restraint over any number of drawers extends an overdrawing course exactly when it includes an event the other withholds, under the whole-run reading (`Ranking.restraint_extends_iff`), and under the stepwise and relation-level readings with their named hypotheses (`Ranking.restraint_extends_iff_stepwise`, `Ranking.restraint_extends_iff_relational`); J1, with the sustaining formation's events as the basic tier, ranks absence above malignant growth where C alone leaves them unranked (`Ranking.basic_first_ranks`; [07](07-SIGNIFICANCE.md#practical-judgment)). *Open:* the form of L under the condition.
12. **Warrant** (philosophical warrant). Is widening better (C, which orders), and does significance stop at no boundary (the step of invariance, which fixes scope)? With them, the grounds of A and the neutralities, and the philosophical part of the first target. The step is reduced to whether the self's presupposition in acting is essentially de se and whether a relation privileges the self's drawing; C to monotonicity at each standpoint (`Weighting.widens_iff_every_of_class`). Held de se, self-concern is one from every standpoint exactly where every center lies within every center's closure, so the step keeps its work beyond that ([07](07-SIGNIFICANCE.md#r-self-concern-through-dependence)); need, read as reach (D64), reaches, except vacuously and over flows in which only active formations give, nothing active only after the stretch of the continuation it carries ([07](07-SIGNIFICANCE.md#r-need-and-feeding-read-with-time)), and held de se of a line under a class it reaches past one's own end ([07 §4.5](07-SIGNIFICANCE.md#r-reach-past-ones-own-end), [§4.6](07-SIGNIFICANCE.md#future-path)). *Open:* both warrants; no formal work settles them ([below](#philosophical-warrant)).

The goal records' targets map onto these items: the deductive necessity of the whole is items 1 and 12; a stronger practical warrant is item 12; the theory's central commitments as the root of wisdom have their formal part complete ([record](../results/records/wisdom-root-without-axiom.md)), leaving item 7; the relational foundation of inquiry has its formal side in [03](03-KNOWING.md#inquiry); the stronger direction is [empirical](#stronger-direction).

<a id="further-proofs"></a>
### Further proofs, by area

Further proofs that do not change the shape of the theory (rates, real or rational versions, more instances, tighter bounds) are in each record's `next_delta` and in each chapter's Open list: [01](01-ROOT.md#open), [02](02-MAP.md#open), [03](03-KNOWING.md#open), [04](04-LIFE.md#open), [05](05-COLLECTIVES.md#open), [06](06-CLASSICAL-TEXTS.md#open), [07](07-SIGNIFICANCE.md#open). This chapter's are in its [Open](#open) list.

<a id="readings-adopted"></a>
### Readings adopted

Each reading is an interpretation of checked content, adopted with its argument and numbered D1–D66 in the [decision register](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md), which says what would change it. The readings stand as one account; where two did not fit, the account decided between them ([D45](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md#d45-一个说明中的读法--the-readings-in-one-account)). They change no theorem and add no premise; who said a word is provenance and does not settle a reading. Each is stated where it applies, labelled `[AI reading, Dn]`; [D65](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md#d65-the-readings-of-the-eight-chapters) registers the readings of the eight chapters.

<a id="no-reading-open"></a>
### No reading open

With D65 the register again lists none open; a reading added later is decided the same way, by argument and fit. Two texts change only by proposal: the body of [OPENING](../OPENING.md), Ren's text, and the [generativity chain](../results/GENERATIVITY-CHAIN.md), his curated argument, through its [maintenance record](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/GENERATIVITY-CHAIN-INDEX-RECORD.md). His terms keep his wording where quoted, with their source, and are read like any reading.

<a id="philosophical-warrant"></a>
### Philosophical warrant

- **The deductive necessity of the whole.** Argued for the determinations the World premises name ([internal relations](01-ROOT.md#what-internal-means)); open: that every becoming has such a law of exchange. For requirement what remains is that requiring does not read whether it is met, since necessary response is the weakest sound reading that does not read the current level (`ExchangeRelation.respondsBelow_weakest`).
- **A stronger universal practical warrant**: grounding reasons without an externally supplied end.
- **The relational foundation of scientific inquiry**: the indispensability of the theory's central commitments, tested from independently stated achievements.
- **The grounds of living significance, A and the neutralities**, none independently reviewed; under the condition living significance is an instantiation, so its ground is the condition's.
- **Calling widening better and the step of invariance** (item 12; [07](07-SIGNIFICANCE.md#scope-and-order)): C's no-loss extension is widening by definition, so the definition carries no warrant.
- **The scope of representation**: whether every becoming has a local law with finite courses (items 1 and 6).

<a id="support-for-living-significance"></a>
The comparative support for living significance (unification, discriminating content, discrimination against rivals, fruitfulness for alignment) is an [assessment in 07](07-SIGNIFICANCE.md#theses), not a proof.

<a id="logical-commitment"></a>
### The logical commitment

The pure core assumes no principle of classical logic ([§3](#pure-core-and-periphery)). Where a law needs one, the principle is its own hypothesis or the law is proved equivalent to it, and [§5](#calibrations) says what each need means for the unfolding. The [decidability inventory](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DECIDABILITY-INVENTORY.md) lists every theorem still conditioned on decidedness. Open: whether WLPO as a proposition gives the rule; a check of the known separation of WLPO from LPO; settling and the tail beyond lists and numbered conditions.

<a id="empirical-correspondence"></a>
### Empirical correspondence

- Whether actual unfoldings meet the premises, with tests that discriminate between accounts; balance as thermodynamics' first law with locality is a correspondence ([01](01-ROOT.md#balance-from-physics)), and dissipation as stated is stronger than the statistical second law.
- The theses and their frozen tests ([§9](#theses)).
- Which systems are place/transition nets, with which weights ([01](01-ROOT.md#r-place-transition-nets-on-the-spine)).
- How wisdom forms in actual humans and AI; which lumping an actual network imposes.

<a id="stronger-direction"></a>
**Open** (empirical; neither a premise nor a thesis). The stronger direction hypothesis says that reality generally develops more shared and more responsive renewal. It is dropped as a thesis because, as stated, it forbids nothing measurable. A part can go on while closing what lies beyond its dependence (`Clearing.loses_beyond`, a witness), so persistence alone does not select widening, and nothing yet says over which runs, or how fast, the trend should hold.

<a id="review-status"></a>
### Review status

Every review so far is by AI ([§11](#reviews)) and checked existing results. Not yet reviewed: the joins of 17 October 2026 that put every spine theorem on the base and joined the periphery to it, everything landed after `b88c2d972` (19 October 2026), and these eight chapters. The [review packet](../review/README.md) asks for it: dossiers for scholars of classical Chinese texts and of Buddhist thought on the [classical readings](06-CLASSICAL-TEXTS.md), for logicians on the Lean statements against the prose, and for philosophers on the arguments of [significance](07-SIGNIFICANCE.md), and a sampled re-coding of the corpus classification.

<a id="does-not-show"></a>
## What this chapter does not show

- That the modelling commitments fit any actual unfolding: their costs are measured only over the reals.
- That laws proved on the World or on processes hold on the grammar before they are lifted.
- That the grammar is as strong as Lean, or that the corpus supplies pairing and power.
- That the method proves the ontology or an ethical necessity.
- That the completion checks find every premise: they read source text and the patterns listed.
- That the prior-art search was exhaustive, or that any result has had human review.

<a id="open"></a>
## Open

- The lifting; representation theorems for the other models (processes' is shown both ways by their moves' relations: [01 §8.1](01-ROOT.md#r-processes-represented-both-ways); the World's both ways for its relations, with its failure on amounts written down: [01 §8.6](01-ROOT.md#r-the-world-represented-both-ways)).
- Pairing and power in the corpus; mutual interpretation of a named fragment with Lean.
- Settling and the tail beyond lists and numbered conditions; whether WLPO as a proposition gives the rule.
- Absolute minimality, against a fixed comparison of expressive resources.
- Revision with an undecided value over infinitely many sentences ([03](03-KNOWING.md#r-revision-with-an-undecided-value)).
- Human review of statements, arguments and the corpus classification.
