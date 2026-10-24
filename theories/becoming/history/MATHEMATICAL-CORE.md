# A mathematical core for systems predicates and proofs

8 October 2026, Asia/Bangkok. Research direction: Yongxu Ren. Exposition and the accompanying pedagogical formalization: AI-authored. [Ren's request](../../../sources/15-codex-theory-conversations/2026-10-08-mathematical-core-document.md) asks for the full context needed to derive the mathematical core discussed in this conversation.

**A small working core represents possible transformations, composes them into finite histories, and supports precise statements and proofs about those histories.** Its process-specific data are a configuration type, an event type, and a relation describing admitted transformations. Predicates and proofs use an explicit mathematical foundation, presently Lean's dependent type theory. From that starting point, composition, finite reachability, preservation of properties, and certain exact changes of representation have checked derivations.

**数学核心：在明确的逻辑基础中，以关系表示可能的变化，由变化构造有限历史，再对配置、历史与整个过程作出可检验的陈述并证明其推论。** 配置、事件及其变化规律是所声明的模型内容；组合与后续性质是需要分别证明的结论。这个核心已能支持系统证明，但没有因此从无前提推出所有现实规律、全部数学或伦理判断。

The central distinction is between **constructing a representation**, **proving consequences within it**, and **establishing its correspondence to an actual process**. These are different explanatory tasks within the same generative account. A proof assistant can verify the second without completing the first or third. A useful foundation makes their relationships visible.

The account below starts with the philosophical and methodological context, constructs the formal interface, develops its principal consequences, explains predication and prediction, and identifies the exact boundary of the resulting foundation. The [proof and correspondence record](../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/MATHEMATICAL-CORE-DOCUMENT-RECORD.md) links the claims to executable sources. The accompanying check passes six modules and 61 printed axiom audits, including 12 new pedagogical theorems. These counts are verification records, not a measure of foundational completeness.

> **Status:** live: an exposition of the foundation module `GenerativeCore`, unchanged since 6 October 2026. Its dated round note of October 2026 is kept verbatim in [its rounds history](../history/MATHEMATICAL-CORE-rounds-2026-10-20.md).
## The question this core answers

The broader research asks for a common generative foundation from which organization, significance, regulation, learning, concern and wisdom can be explained. The [working root](../history/GENERATIVE-GROUNDING.md#minimal-grounding-and-universal-scope) is:

> Activity forms and changes the conditions of further activity. Its effects can persist or change, becoming conditions of what follows.

> 活动形成并改变后续活动的条件。其后果可以持续或转化，成为接下来发生之事的条件。

These are the repository's AI-authored working formulations, developed under Ren's direction. They do not yet specify a mathematical law. To reason precisely, we must identify which differences matter, how a change depends on existing conditions, and how its consequences enter subsequent changes.

The mathematical core answers a bounded but substantial question: **once the relevant conditions and admissible transformations are stated, what follows about their possible continuations, and what must a representation preserve for those conclusions to remain valid?**

This is a general interface for system reasoning. It is not a definition of every system as a self-maintaining organism. The same interface can represent formation, ordinary recurrence, destruction, failure, interruption, and stable configurations. Whether a represented arrangement counts as living, learning, intelligent, or good requires the corresponding explanatory content.

## Relational context and the meaning of a system

The [nondual method](NONDUAL-METHOD.md) begins with one unfolding in which organizations, perspectives, observations and evaluations differentiate. It does not begin with an independently constituted agent confronting an independently constituted environment.

A configuration in the mathematical account describes selected relations in that unfolding. It might include a material arrangement, an active coupling, a retained difference, or a rule currently governing responses. A configuration boundary is a modeling choice whose adequacy depends on the question. Calling a collection of coordinates a “system” does not establish that those coordinates form an autonomous entity.

When the explanation distinguishes an observer, an acting position, or something undergoing an effect, it must identify the relations that support that distinction. A map from configurations to observations is a mathematical description of access. A real observation additionally requires a mechanism that produces, retains and makes use of the relevant differences. The map alone does not explain that mechanism.

Analytical separation has a legitimate role. We can study configurations separately from event labels, or a process separately from a predicate about it, while remaining accountable for how those distinctions represent the same activity. Conversely, putting everything in one tuple does not prove causal connection or nonduality. The method concerns the explanatory relationships, not the number of mathematical types used.

**配置与事件是同一展开的分析性表达；它们不是两个独立的本体领域。系统边界、观察位置、行动能力及其条件，都须按具体关系说明其形成与适用范围。**

## The mathematical background we explicitly use

The process core is written within Lean's dependent type theory. We use types for represented configurations and event labels, functions and relations, equality, propositions, quantification, finite lists, and induction. A statement `p : Prop` is a proposition; a term of type `p` is a proof that Lean checks. This is the propositions-as-types account described in the [official Lean reference](https://lean-lang.org/theorem_proving_in_lean4/Propositions-and-Proofs/).

Inductive definitions specify constructors and support reasoning by their cases. This supplies the formal method used to define finite histories and prove their properties; see Lean's [inductive types chapter](https://lean-lang.org/theorem_proving_in_lean4/Inductive-Types/). We are using these logical resources, not deriving type theory or induction from a physical transformation law.

The relevant commitments therefore have distinct roles:

| Role | Content | Status |
|---|---|---|
| Explanatory orientation | Formations and their consequences belong within one generative unfolding | Foundational proposal and method |
| Mathematical foundation | Types, equality, propositions, functions, lists and induction | Explicit background of this formalization |
| Model content | Configuration domain, event domain, and transformation relation | Supplied or separately derived for an application |
| Specification | The properties and questions being investigated | Explicit predicates with an interpretation |
| Mathematical consequences | Composition, closure, preservation and representation results | Proved under their stated hypotheses |
| Actual correspondence | Why the domains, law and predicates describe the intended case | Explanatory and empirical obligation |

This ledger matters when reading `#print axioms`. An empty report means the checked declaration does not depend on additional axiom constants. It does not erase theorem parameters, definitions, inductive machinery, the chosen logic, or the interpretation of the model. For example, a theorem proved for every relation still takes that relation as input when applied to a particular process.

## Constructing the transformation interface

The construction is motivated by three requirements: represent consequential differences, specify admitted change, and retain the conditions produced by a change when considering what follows. These requirements guide a formalization; they do not prove that one notation is the uniquely necessary mathematical description of reality.

Let \(S\) be a type of configurations and \(A\) a type of event labels. Declare

\[
R:S\to A\to S\to\mathrm{Prop}.
\]

The proposition \(R(s,a,t)\) means that the model admits event \(a\) from configuration \(s\) to configuration \(t\). The existing Lean declaration is:

```lean
structure Process (State : Type u) (Action : Type v) where
  step : State → Action → State → Prop
```

`Action` is the existing source identifier. In this exposition it is read as an event label. No actor, intention, ownership or permission is implied by that name. The type parameters allow different applications to provide different domains.

A relation is useful because it does not impose one successor, require an event to be available everywhere, or assign probabilities to alternatives. Several endpoints may be admitted, or none. A function describing a deterministic update is a more specific law that can be presented relationally. Which law is appropriate is an application question.

The configurations must retain enough information for the declared question. If a currently effective rule changes, the configuration can include that rule or its operative realization, and the relation can describe its change. This represents revision under a declared broader dynamics. It does not explain that broader dynamics merely by moving a rule into a state field.

The interface supplies no universal clock, metric, probability, resource budget, observation channel, or reward. Such structures can be added when needed, with their correspondence stated. In particular, discrete event descriptions do not by themselves establish an exact representation of continuous physical dynamics.

**Why is the relation supplied?** A type tells us what distinctions are available in a representation. It does not tell us what changes occur. The earlier product construction makes this limitation precise: starting with \(T_0(X)=X\) and repeatedly forming \(T_{n+1}(X)=T_n(X)\times T_n(X)\) preserves both nonemptiness and the property of having at most one element, in both directions. Its checked results show that an empty seed stays empty and a seed with no distinction does not acquire one through this product operation alone. Construction depth also needs an additional interpretation before it can stand for physical time. [Product source](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/ProductTower.lean)

The positive conclusion is to make the dynamical content explicit. A locally supplied law is still a relationship within the intended generative reality. Explaining its formation or deriving it from a finer description is further work, exemplified by the repository's [process-law derivation](../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/PROCESS-LAW-DERIVATION.md).

## Deriving finite histories

An event relation describes one step. To investigate continuation, define a finite history by two constructors:

1. An empty event word relates a configuration to itself.
2. If \(R(s,a,m)\) and a history with word \(w\) proceeds from \(m\) to \(t\), then the word \(a::w\) proceeds from \(s\) to \(t\).

Write the resulting proposition as \(\operatorname{Trace}_R(s,w,t)\). The empty constructor is an identity for formal continuation; it asserts no physical waiting interval or spontaneous occurrence. The second constructor uses the intermediate configuration actually shared by the two represented stages.

The central composition theorem is

\[
\operatorname{Trace}_R(s,u{+\!+}v,t)
\iff
\exists m,\;
\operatorname{Trace}_R(s,u,m)
\land
\operatorname{Trace}_R(m,v,t).
\]

Here \(u{+\!+}v\) means concatenation of event lists. The proof proceeds by induction on \(u\). For the empty word, the intermediate configuration is the starting configuration. For a nonempty word, expose its first step and apply the inductive result to the remaining prefix. In the reverse direction, use the same constructors to assemble the histories. The checked declaration is `Generative.trace_append_iff`.

This yields more than saying “events happen in sequence.” It identifies exactly the compatibility requirement: the suffix begins where the prefix ends. A proposed mechanism that separately demonstrates an early phase and a later phase must still establish that their boundary conditions match. Supplying fresh resources or silently resetting learned state at the join changes the history being proved possible.

The formal `Trace` lives in `Prop`. Its constructors support proofs involving intermediate configurations, but it is not an exported data structure recording every execution or distinguishing every path witness. If an application needs an executable history, timestamps, or identifiable paths, it must supply the corresponding data representation and prove its relationship to `Trace`.

## Reachability and the precise minimality result

Define endpoint reachability by forgetting the particular finite word:

\[
\operatorname{Reach}_R(s,t)
\;:\!\iff\;
\exists w,\;\operatorname{Trace}_R(s,w,t).
\]

The [generated-paths module](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/GeneratedPaths.lean) proves that this relation is reflexive, contains every primitive step, and is transitive. It also proves the exact minimality statement:

> Every reflexive and transitive relation containing all the declared steps contains every reachable endpoint pair.

Thus reachability is the **least reflexive-transitive extension of the supplied steps**, unique up to pointwise logical equivalence. This is a genuine derivation with a precise universal property. It does not identify a least physical law, establish a free category of distinguishable paths, or prove that a physical future actually occurs.

The boundary case is informative. If there are no primitive steps, then \(\operatorname{Reach}_R(s,t)\) holds exactly when \(s=t\). Formal composition does not manufacture nontrivial dynamics. The theorem `reach_without_steps_iff` checks this case.

This explains which part of “composition” is derived. Once the finite-history construction is admitted, the composition theorem and least endpoint closure follow. Whether two proposed physical operations can be performed together or one after another is encoded in the law and actual intermediate conditions; logical concatenation does not independently establish physical compatibility.

## Predicates and what it means to prove a system property

A state predicate has the form

\[
I:S\to\mathrm{Prop}.
\]

It states a property of a configuration. A history specification may instead depend on a starting configuration, an event word, and an endpoint. A process property may quantify over every step or every admitted history. For example, determinism for a fixed event is the explicit property

\[
\forall s,a,t,r,\quad R(s,a,t)\land R(s,a,r)\Rightarrow t=r.
\]

These predicates are mathematically meaningful before we have proved or refuted them. Writing `Safe`, `Alive`, or `Learns` as a predicate name provides no explanation of safety, life, or learning. The interpretation must specify which actual relationships the predicate represents, and the proof must show that the declared law satisfies it under the stated conditions.

To “prove a system” is therefore shorthand. We prove a proposition about a specified process: an invariant, a possible construction, an obstruction, a sufficient condition, or a relationship between representations. The proposition and its quantifiers determine the result's strength.

For a fundamental example, suppose:

\[
I(s_0),\qquad
\forall s,a,t,\;I(s)\land R(s,a,t)\Rightarrow I(t).
\]

Then every finite history beginning at \(s_0\) ends in a configuration satisfying \(I\):

\[
\forall w,t,\quad
\operatorname{Trace}_R(s_0,w,t)\Rightarrow I(t).
\]

The initial fact handles the empty history. Step preservation carries it through each constructor. The new companion proves this as `trace_invariant`, and derives preservation under endpoint reachability as `reach_invariant`. If a proposed endpoint violates \(I\), it cannot be reached under these hypotheses; `invariant_excludes_endpoint` checks that consequence. [Companion source](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/CorePredication.lean)

This is how finite induction supports a theorem about arbitrarily long finite histories without enumerating them. It does not construct an infinite history, promise progress, or explain why \(I\) is an ethically justified objective. Those are different propositions.

**谓词使问题明确，证明使推论可靠；命名本身不产生相应的现实性质。保持某性质的定理，也不独自证明该性质的伦理地位。**

## Possibility and conditional prediction

Predication means stating properties; prediction concerns what follows from given conditions. The relational core supports a precise connection between them.

For an endpoint property \(Q\) and a fixed finite event word \(w\), define

\[
\begin{aligned}
\operatorname{May}_R(w,Q,s)
&\;:\!\iff\;\exists t,\;
\operatorname{Trace}_R(s,w,t)\land Q(t),\\
\operatorname{Must}_R(w,Q,s)
&\;:\!\iff\;\forall t,\;
\operatorname{Trace}_R(s,w,t)\Rightarrow Q(t).
\end{aligned}
\]

`May` says that a satisfactory endpoint is possible. `Must` says that every endpoint of an execution of this whole word satisfies the property. The event word is fixed in both statements; no choice policy or actual control over its events has been supplied.

Composition of histories gives composition of these predicates:

\[
\begin{aligned}
\operatorname{May}_R(uv,Q,s)
&\iff \operatorname{May}_R(u,\operatorname{May}_R(v,Q,-),s),\\
\operatorname{Must}_R(uv,Q,s)
&\iff \operatorname{Must}_R(u,\operatorname{Must}_R(v,Q,-),s).
\end{aligned}
\]

The dash denotes the intermediate-configuration argument. Both equivalences are checked in `CorePredication.lean`. They express the same shared-boundary requirement as the trace theorem, now as reasoning about properties.

Two checked examples keep the quantifiers honest. In a process whose one event can end at either Boolean configuration, reaching `true` is possible but is not guaranteed: reaching `false` is also admitted. In a process with no steps, the statement that every endpoint of a one-event execution satisfies even `False` is vacuously true, because there are no such executions. The word is not feasible and no successful endpoint is possible.

Accordingly, endpoint prediction often needs both feasibility and `Must`. The companion proves that their conjunction implies `May`. Even this conjunction does not say every attempted execution completes: some partial executions may get stuck before the full word ends. A claim of inevitable completion requires an additional progress argument.

Under the explicit determinism hypothesis, the companion proves that two traces with the same start and event word have equal endpoints. It then proves that `May` implies `Must` for that word and property. Determinism provides uniqueness when a trace exists; existence still has to be established.

An empirical forecast requires further work. The starting conditions must be identified with appropriate uncertainty; the law and specification must correspond to the phenomenon; the relevant event sequence, control arrangement, or scheduling assumptions must be justified. A probability forecast needs probabilistic structure, and a claim about what information an organized observer can obtain needs an access mechanism. The relational core alone supplies neither.

## History without a hidden memorylessness assumption

Using configurations does not require a small finite memory. A configuration can include the relevant past. A smaller summary requires a separate adequacy argument.

The [history realization module](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/HistoryRealization.lean) starts with an admitted language \(L\) of finite event words. Its hypotheses are that the empty word is admitted and that every prefix of an admitted word is admitted. Define the current configuration to be the complete word accumulated so far, and admit an event exactly when appending it yields another admitted word.

The module proves that a word is feasible from the empty history in this constructed process exactly when it belongs to \(L\). It also proves that the finite feasible-word language of any supplied process from a fixed initial configuration has such an exact realization.

This is an exact representation result for **finite word feasibility**. It does not recover original hidden configurations, distinguish every branching realization, preserve probabilities, or identify available interventions. A language records the words that can occur; two distinct mechanisms can agree on that information. Its correspondence contract must not silently expand beyond the theorem.

The relevance to the foundation is positive: the use of a state relation need not discard historical dependence. The price of retaining full history is explicit, while any compression needs a proof appropriate to the intended questions.

## Composing descriptions of one process

One declared mode of composition uses two configuration descriptions and a common event label:

\[
R_{P\otimes Q}((s,q),a,(t,r))
\;:\!\iff\;
R_P(s,a,t)\land R_Q(q,a,r).
\]

The product is a synchronized composition: a shared event must satisfy both component constraints. The core proves

\[
\operatorname{Trace}_{P\otimes Q}((s,q),w,(t,r))
\iff
\operatorname{Trace}_P(s,w,t)\land
\operatorname{Trace}_Q(q,w,r).
\]

This theorem applies to the stated product law. Physical interaction may require shared coordinates, compatibility conditions, additional coupling, or a different composition rule. The product theorem does not derive those relationships from independently chosen models.

The distinction matters for whole generativity. Individual possibility is not automatically joint possibility. The checked `SharedResource` example has one indivisible allocation and two positions: either can be served separately, but no allocation serves both. It verifies the failure of exchanging the quantifiers in

\[
\forall i\,\exists x\,P(i,x)
\quad\text{and}\quad
\exists x\,\forall i\,P(i,x).
\]

That example has a stipulated allocation law; it is not a universal scarcity principle. Its lesson is to retain actual common conditions when claiming joint realization. [Boundary models](../../../experiments/integrated-correction/general-framework/generative-basis/lean/BoundaryModels.lean)

## Exact abstraction and consequential distinctions

A useful mathematical core must also say when a simpler description is faithful. Let \(q:S\to B\) map detailed configurations to summaries, and let \(\bar R\) be a declared relation on summaries. The core supplies two local obligations:

**Preservation:** every detailed step projects to a summary step:

\[
R(s,a,t)\Rightarrow\bar R(q(s),a,q(t)).
\]

**Lifting:** every summary step can be realized from each detailed starting configuration it describes:

\[
\bar R(q(s),a,b)
\Rightarrow
\exists t,\;R(s,a,t)\land q(t)=b.
\]

Together they are equivalent to the exact finite-history contract

\[
\operatorname{Trace}_{\bar R}(q(s),w,b)
\iff
\exists t,\;
\operatorname{Trace}_R(s,w,t)\land q(t)=b.
\]

The checked declarations `projection_exact_iff` and `local_exact_iff_trace_exact` give both directions. This allows a universal finite-history correspondence to be established through local obligations. Lifting must hold from the specified detailed state, not merely from some representative with the same summary.

Preservation alone supports one-way projection. Lifting supplies the additional connection needed to rule out summary paths without a corresponding detailed path from the given start. Even exact finite-history correspondence does not automatically preserve probabilities, observation abilities, or every property of the detailed endpoint. A claimed property must have its own correspondence to the summary.

The core also proves a relative necessity result: if two configurations differ in whether some finite word is feasible, an exact summary of finite-word feasibility cannot identify them. An independently checked observation example makes the issue concrete: the same coarse observation is assigned to a ready and a spent condition, even though only the ready condition enables operation. No classifier depending solely on that observation can correctly distinguish operability in both cases.

Consequential distinction is therefore answerable to a question and its continuation contract. The theorem does not demand that every representation preserve every microscopic difference. It demands preservation of the differences relevant to the exact claim being made.

## What minimal means here

The shortest process declaration in the present implementation has two type parameters and one relation field. Predicates and proofs are available in the background logic. The earlier conversational formula “transformations plus composition plus predicates within a logic” describes the working architecture; it is not a certified count of independent primitives.

Three minimality questions need separate answers:

| Question | Current answer |
|---|---|
| What small interface is sufficient for the displayed system theorems? | A supplied labelled relation in the stated mathematical foundation, with finite traces defined inductively |
| What is the least endpoint continuation generated by those steps? | The unique least reflexive-transitive extension, proved pointwise |
| Is this the absolutely smallest or uniquely necessary foundation for all systems and mathematics? | Not established; it requires a fixed comparison of expressive resources, preserved content and explanatory dependencies |

Changing the notation or moving information into another field can alter a primitive count without reducing the substantive commitments. Likewise, a relation can be an exact formal specification without offering an executable decision procedure. This interface asks for no decidability procedure for arbitrary steps or predicates, and provides no algorithm that answers every possible question about a process.

The expressiveness of `State → Prop` uses Lean's admitted function and proposition structure. It does not show that the process itself forms every mathematical predicate, or that every predicate has a computable classifier. The wider [mathematical reconstruction](../history/MATHEMATICAL-ROOT-FRONTIER.md) has checked conditional results about higher-order languages, whole-family admission and future-stage interpretations. Their domains and semantic commitments remain distinct from this finite process core.

## The connection to organization learning and ethics

The core supports the governing derivation by making several obligations precise. To explain an organization, specify how relevant arrangements form and recur. To explain regulation, show how activity depends on conditions and changes the continuation. To explain learning, identify retained consequences and demonstrate how they alter subsequent response. To explain revision of learning, include the operative updating arrangements and show their transformation in the continuing history.

These are mechanisms to establish under actual laws and correspondences. They do not follow merely because the process has multiple steps. The checked fixed-selector example is recurrent and changes configuration while its causally effective selector remains unchanged. It limits an unconditional inference from recurrence to selector revision; it does not refute learning in a richer process. Existing [developmental constructions](../history/GENERATIVE-DEVELOPMENT.md) supply conditional mechanisms further along this path.

For the ethical programme, the core's contribution is to preserve the actual dependencies, common histories, realizations and losses on which appraisal depends. A model that separately counts possible outcomes while losing their compatibility may misdescribe the whole being evaluated. A preservation theorem can show that an explicitly specified requirement survives an update; it cannot establish the requirement's normative warrant merely by proving its invariance.

The conditional alignment route starts from **living significance: every living claim has significance from every standpoint** (`Valuation.Significant`). It gives significance, not a positive valence, and the `living` readings do not include further generation; the direction of 生生, toward whole 生 and its further generation, is read separately, by widening what can form ([D1](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md#d1-生生的读法--how-生生-is-read)). The theory does not assume living significance; it follows under [the continuation condition](THE-THEORY-OF-BECOMING.md#64-the-continuation-condition). [Ren's grounding correction](../../../sources/15-codex-theory-conversations/2026-10-08-alignment-grounding-axiom-correction.md) is provenance for deriving comparisons and practical requirements from that starting point, not its warrant. Proving living significance without normative premises is not a completion gate for that route. Additional comparison commitments, duties, permissions and authority remain explicit. [Earlier ethical formulation, which stated it as an axiom](../history/UNIFIED-ETHICAL-GROUNDING.md#current-alignment-task-an-explicit-normative-axiom).

The logical distinction between explaining consequences and justifying their appraisal does not posit two realities. It records which relationships the present formalization represents and which further argument the ethical conclusion needs. A weak representation with a freely assigned value label would not by itself refute a richer constitutive account of ethical quality.

## Using the core for a concrete investigation

An application can be developed in the following order. Earlier choices remain revisable when later evidence exposes a missing relationship.

1. **State the question and scope.** Identify whether the target is possible formation, an invariant, a deadline, successful response, joint realization, or another property. Specify whether the horizon is finite or infinite and what information must be retained.
2. **Explain the represented configurations.** Identify the actual arrangements and relations behind the coordinates. Include relevant history or justify its summary. Account for any boundary or differentiated role used in the explanation.
3. **Supply or derive the transformation law.** State admissibility and failure conditions. Identify the laws, observations or finer mechanisms that warrant it, including uncertainty and any background conditions.
4. **Define the specification independently of the desired verdict.** Explain what the predicate means and how its truth relates to actual outcomes. Do not define successful learning or ethical adequacy simply as satisfying the result being sought.
5. **Prove the exact statement.** Give the initial conditions and quantifiers. Keep feasibility, universal endpoint properties, termination, recurrence and actual control distinct. Use the actual reached configuration when joining phases.
6. **Check representation and countercases.** Establish the preservation contract for any abstraction. Retain failed preparations, competing possible outcomes and cases outside the stated hypotheses.
7. **Validate correspondence and integrate the result.** Explain what the proof establishes about the intended phenomenon, what remains supplied, and which link in the broader generative derivation it advances.

This procedure permits both positive construction and genuine failure. A disproved property may identify an inadequate intervention, a false law, an omitted relation, or a limitation of the proposed theory. The interpretation must distinguish those possibilities rather than treating every formal countermodel as a complete account of the actual case.

## Formal evidence and reproduction

The following sources support the mathematical claims made here. All six are compiled from copied source bytes in an isolated temporary build. The saved receipt binds the source hashes, compiler version, logs and printed axiom audits. No preexisting project object files are used.

| Source | Role in this account | Printed audits |
|---|---|---:|
| [GenerativeCore](../../../experiments/integrated-correction/general-framework/generative-basis/lean/GenerativeCore.lean) | Traces, sequential and synchronized composition, exact abstraction, consequential differences | 18 |
| [GeneratedPaths](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/GeneratedPaths.lean) | Least endpoint closure and the no-step boundary | 9 |
| [HistoryRealization](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/HistoryRealization.lean) | Exact finite-word realization from a prefix-closed language | 7 |
| [ProductTower](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/ProductTower.lean) | Limits of deriving distinctions from product iteration | 7 |
| [BoundaryModels](../../../experiments/integrated-correction/general-framework/generative-basis/lean/BoundaryModels.lean) | Observation loss, separate versus joint feasibility, recurrence without selector revision | 8 |
| [CorePredication](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/CorePredication.lean) | Twelve new pedagogical theorems on invariants, modal composition, determinism and vacuity | 12 |

From the repository root, reproduce with:

```sh
python3 experiments/integrated-correction/general-framework/generative-basis/lean/deeper/check_core_document.py
```

The checker uses the declared Lean 4.29.1 toolchain. Its [verification pointer](../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/core-document-verification.json) names the immutable run receipt. In the document's checked run, all 61 printed declarations have empty axiom-dependency reports. Forty-nine are existing audited declarations; twelve are new expository results. The successful check validates this scope, not all repository proofs or all mathematical consequences one might formulate.

The 12 additions are elementary consequences and examples, not claims of novel mathematics. The larger historical programme, its stronger claims and its counterexamples remain preserved in [the deeper-root study](../history/DEEPER-GENERATIVE-ROOT.md), [the mathematical frontier](../history/MATHEMATICAL-ROOT-FRONTIER.md), and [the research index](../../../RESEARCH.md).

The resulting foundation is substantive and bounded: **given a declared transformation law, we can construct its finite continuations, state precise questions about them, and check proofs of composition, preservation and faithful representation.** Deriving an application's law and establishing its real correspondence remain connected explanatory work. Universal mathematical constitution and ethical grounding retain their own premises and completion conditions.
