<!-- Banner of 7 November 2026 (RV), AI-written navigation; the folder's text below it is unchanged. -->
> An earlier theory folder, first written before the live account, [the theory of becoming](../becoming/ONE-PAGE.md). Its own assessments of standing and readiness are its view as of 25 September 2026, not the live account's. [Chapter 5](../becoming/chapters/05-COLLECTIVES.md#11-joint-plans-and-applications) counts it among applications elsewhere: design programmes, not results; correspondence not established. What became of its claims is in [the crosswalk](../becoming/results/atlas/crosswalk/evolving-community-swarms.md), where every entry is an AI reading with no person's behind it and not carried is an outcome, not a defect; [the index](../README.md) lists the sixteen earlier folders. How the account grew from these folders and the writing before them is in [the lineage](../LINEAGE.md).

# Evolving community swarms

**Working title · established 2026-09-05 · exploratory theory and design direction**

This document is AI-drafted from Ren’s founding conversation. Ren explicitly said he was “totally aligned with your take” and asked to preserve the discussion as a new theory to explore. That establishes the shared direction; it does not make the architecture a proven result or the assistant’s wording Ren-authored. The complete conversation is preserved in [the local archive](context/2026-09-05-conversation.md), with an identical founding snapshot in [the corpus sources](../../sources/15-codex-theory-conversations/2026-09-05-evolving-community-swarms.md).

## The idea

A community can develop its own software continuously: beginning with a forum, adding calendars, badges, scheduling, wallets, voting, diaries, games, and specialized agents, and gradually making the space part of its culture. Members can ask for changes in the place where they use the software. Agents help find, compose, generate, verify, and maintain the resulting capabilities.

The proposed mechanism is recursive responsibility with explicit behavioral contracts, durable local maintenance context, versioned implementations, and scoped adoption. Most work should require understanding only the affected module and its declared boundaries. Growth should add useful possibilities without imposing the runtime cost, maintenance burden, or design preferences of every new feature on every member.

The central research question is whether these properties survive repeated evolution, increasing reuse, changing shared meanings, and real community disagreement. The desired outcome is a hypothesis to test, not an automatic consequence of modularity or having many agents.

**Updated ambition, 2026-09-07:** Ren explicitly directs the exploration to surpass existing systems. The [next vision and plan](next-vision/README.md) expands the research target to a system that learns better ways to organize, develop, verify, and maintain itself. Adaptive module boundaries, conditional evidence reuse, and applicable learned procedures are proposed mechanisms for making subsequent changes cheaper. The new plan defines competitive gates and a path toward thousands of useful workers; none has yet been demonstrated.

## Read and continue here

| File | Purpose |
|---|---|
| [README.md](README.md) | Current formulation and the distinctions that must survive future revisions. |
| [context/2026-09-05-conversation.md](context/2026-09-05-conversation.md) | All five founding user messages, all four substantive assistant responses, and the earlier visible progress updates. |
| [Soundness assessment — 2026-09-07](context/2026-09-07-soundness-assessment.md) | Critical assessment: coherent direction, unresolved maintenance of sufficient contracts, three distinct kinds of scale, and proposed discriminating tests. |
| [Harness and swarm comparison — 2026-09-07](context/2026-09-07-harness-and-swarm-comparison.md) | Comparison with coding teams, durable orchestration, swarm papers, self-modification, and malleable software; identifies the proposed contract/state/adoption protocol as the research focus. |
| [Next vision and development plan](next-vision/README.md) | Updated ambition to surpass: adaptive decomposition, reusable evidence and learning, competitive evaluation, and a staged implementation plan. |
| [Updated-vision request — 2026-09-07](context/2026-09-07-updated-vision.md) | Exact user direction, assistant delivery summary, and a dated snapshot of the complete planning package. |
| [DECISIONS.md](DECISIONS.md) | Explicit alignment, working commitments, scope, and choices still undecided. |
| [RESEARCH-AGENDA.md](RESEARCH-AGENDA.md) | Open questions and proposed experiments for testing repeated evolution. |
| [SOURCES.md](SOURCES.md) | External references already consulted, what they support, and their limits. |
| [AGENTS.md](AGENTS.md) | Continuation guidance for agents working in this folder. |

## Core claims and their status

1. **[Design direction] Local reasoning is the scaling unit.** An agent should work from its own module, its parent’s requirements, the exposed contracts of its children or supplied dependencies, and common architectural rules. Ren explicitly framed this as a hypothetical system independent of the current assistant harness. [Exchange 2](context/2026-09-05-conversation.md#exchange-2)
2. **[Conditional mechanism] Local work composes when the boundary supplies sufficient information.** Each parent must satisfy its children’s assumptions and establish that their guarantees plus its coordination fulfill its own contract. Common prompts cannot substitute for missing dependencies or contradictory requirements. [Exchange 2](context/2026-09-05-conversation.md#exchange-2)
3. **[Design direction] Software can be selected and produced when needed.** Resolve a requested capability through reuse, configuration, composition, forking, upgrade, or generation, then retain useful implementations for subsequent use. [Exchange 3](context/2026-09-05-conversation.md#exchange-3)
4. **[Design direction] A module may include an LLM interpreter and an LLM maintainer.** Routine execution, runtime interpretation, view generation, implementation improvement, and contract evolution are distinct activities with different verification and resource needs. [Exchange 3](context/2026-09-05-conversation.md#exchange-3)
5. **[Value stance and product direction] Changes have audiences.** Personal, group, and community changes should be distinguishable. Different views can share authoritative records; a shared commitment requires the relevant community decision. [Exchange 4](context/2026-09-05-conversation.md#exchange-4)
6. **[Prediction to test] Unrelated growth can have a small marginal cost.** Existing interaction cost should follow its active dependencies; local change effort should follow affected contracts. Neither should routinely require loading or understanding every installed app. No constant-cost guarantee is claimed for growing active workloads or changes to genuinely shared invariants. [Exchange 4](context/2026-09-05-conversation.md#exchange-4)
7. **[Design direction] Evolution includes maintenance and retirement.** Versions, migrations, ownership, budgets, consolidation, and archival access belong to the system’s normal lifecycle. Easy generation alone is insufficient. [Exchange 4](context/2026-09-05-conversation.md#exchange-4)
8. **[Value stance] Technical evolution should preserve community continuity.** Conversations, identity, commitments, decisions, and cultural history matter alongside features and performance. Social harmony is an aspiration, not something the architecture can guarantee. [Exchanges 4–5](context/2026-09-05-conversation.md#exchange-4)

## The founding example

Ren’s example begins with a community coordination space that resembles a forum. Members gradually ask the community agent for a calendar, badges, automatic scheduling, design changes, a community wallet, voting, “dairy,” small games, and specialized agents. The subsequent discussion interpreted “dairy” as “diary”; the original wording remains in the archive.

The aspiration is that the growing space remains responsive and easy to change until it becomes the community’s “os” and part of its culture. The OS analogy describes a shared environment for work, play, coordination, and creating tools. It does not establish a requirement to build a hardware operating system.

Three properties organize the proposal:

- **Technical locality:** adding a game has little effect on reading the forum.
- **Social locality:** changing a personal layout does not require agreement from everyone.
- **Continuity:** a new version preserves the relevant community records and commitments.

## How the mechanism would work

### Responsibilities and contracts

The original structure is `A(B(D(...), E(...)), C(F(...), G(...), ...))`. A node receives a responsibility from its parent, either implements it locally or decomposes it into child responsibilities, and returns an implementation together with evidence that it meets the required contract.

A behavioral contract describes relevant inputs, outputs, meanings and units, assumptions, guarantees, state ownership, allowed effects, failure behavior, progress, and resource constraints. Matching function signatures alone does not establish compatibility.

For `B(D, E)`, B must both supply what D and E assume and show how their guarantees and B’s coordination fulfill B’s promise to A. A then reasons about B’s exposed contract as the summary of that subtree. Verification may range from executable checks to formal reasoning in a restricted model; ordinary tests remain bounded evidence.

A child can report that a contract is infeasible or underspecified. Its parent revises the decomposition or propagates the conflict. Requirements move downward; feasibility findings, evidence, and change requests move upward. Neighbors can relay information without giving every agent a global implementation view.

### Several structures, explicitly distinguished

- **Responsibility hierarchy:** which parent defines and accepts a module’s work.
- **Artifact relationships:** reusable definitions, versions, forks, and composition dependencies.
- **Runtime connections:** actual calls, events, and data access between instances.
- **View tree:** the components currently assembled for a member’s situation.

One published definition can supply many instances, each with its own parent and state. Shared code does not imply shared mutable instance state.

Strict parent/child runtime communication remains a legitimate variant of the original premise. Cross-subtree interactions must then travel through ancestor-provided boundaries. The later recommendation allows parents to inject declared capabilities whose runtime calls reach other providers directly. This preserves bounded local reasoning while relaxing strict runtime topology. The alternatives and their costs must remain explicit; their equivalence has not been established.

### Discovery and generation

A module requests a capability from its parent. A hierarchical directory can route searches through advertised summaries and return candidate contracts and artifacts. Ordinary indexing keeps the catalog out of the LLM prompt. A semantic match retrieves a candidate; compatibility requires checking its actual promises, requirements, state effects, and versions.

The resolver chooses among reuse, configuration, composition, a distinct fork, a general upgrade, and new generation. Discovery summaries can be incomplete or stale, so neighbor-only discovery does not guarantee finding the globally best implementation without broader search.

### The maintained module

```text
Module
  purpose and responsible owner
  offered contracts and required capabilities
  owned records and data schema
  views and background tasks
  implementation versions and ancestry
  acceptance criteria and verification evidence
  resource limits
  migration history
  relevant community decisions
  optional runtime LLM and maintainer agent
```

Maintainers wake for requests, relevant dependency changes, failures, or deliberate maintenance. Frequent interactions use ordinary code unless interpretation itself requires an LLM. Another agent must be able to resume maintenance from durable context instead of reconstructing the entire community’s chat history.

### Change and adoption

```text
Member request
→ identify affected capability and audience
→ resolve or develop an implementation
→ create a usable experimental version
→ try, discuss, and revise
→ adopt for a person, group, or community
→ maintain, replace, consolidate, or retire
```

Two forum designs can share conversations. Two calendar views can share events. An experimental badge system can remain group-specific. An official election has an explicitly selected ruleset and authoritative records; forking a view does not silently change those commitments.

New implementations are published as versions. Parents select replacements; changing persisted state requires a compatible transition or migration. Code rollback does not by itself undo incompatible data writes or external effects.

### Common runtime and limits

A relatively stable, versioned runtime supplies identity, capability grants, discovery, loading, storage access, task execution, version selection, and resource accounting. Domain semantics remain with their owners: attendance, badge eligibility, election rules, or transfer rules. The exact runtime primitives and their own evolution are still open questions.

Performance requires lazy activation, cached artifacts, bounded queues, narrow subscriptions, reserved resources, and attribution of cost to module versions. Maintenance requires owners, budgets, bounded dependencies, and retirement. A thousand dormant apps and a thousand active simulations are different workloads.

## Counterexamples and limits retained from the discussion

- Local latency promises do not imply a system deadline unless a parent accounts for the actual composition. The discussed 10/60/30 ms split is an illustrative allocation for sequential work, not a measured result.
- Children that each wait for the other can deadlock despite plausible interfaces. Progress needs its own argument.
- A calendar and badge module can agree on types but disagree about what counts as attendance.
- A shared database accessed outside declared boundaries is a dependency even when omitted from the diagram.
- Personal interface variants can reduce design disputes; shared policy disagreements still need social resolution.
- More generation can increase maintenance costs through redundant forks and abandoned apps.
- A broad shared contract change can require broad coordination. Modularity cannot make every global change local.
- Independent agents may reproduce the same misunderstanding. Agreement and implementation-shaped tests are not sufficient evidence of correctness.

## Genealogy and details to keep

| Exchange | Development | What must remain visible |
|---|---|---|
| 1 | Coding with thousands of agents: isolated work, ownership, durable queues, small integrations, evidence, useful concurrency. | Operational coordination still matters, although the theory is not limited to the current harness. |
| 2 | Ren introduces recursive architecture and local parent/child knowledge. | Sufficient boundaries, recursive composition, and the strict-tree question. |
| 3 | Ren introduces generated views, situational reuse/forks/modification, and LLMs within modules. | Dynamic discovery, definition/instance distinction, maintained versions, and semantic evolution. |
| 4 | Ren introduces the community becoming its own OS and culture. | Personal/group/community scope, shared reality, performance, continuity, and maintenance economics. |
| 5 | Ren aligns with the direction and asks for a new theory folder. | Preserve the original exchange and keep exploration distinct from validated implementation. |

The earlier enterprise operations app, adaptive IDE, and collaborative engineering platform remain useful comparison cases. They are preserved in [exchange 3](context/2026-09-05-conversation.md#exchange-3); the community case becomes the main test without deleting those examples.

## Relationship to existing work

Information hiding, assume–guarantee contracts, dynamic loading, and malleable software are relevant foundations; their particular contributions and limits are in [SOURCES.md](SOURCES.md). None of those references establishes this entire swarm architecture as already solved.

The [2026-09-07 comparison](context/2026-09-07-harness-and-swarm-comparison.md) finds substantial precedents for recursive delegation, private context, persistence, self-modification, and alternative interfaces over shared records. The assistant proposes using established execution and orchestration machinery while investigating a protocol for evolving maintained modules: predicting affected contracts, checking candidates, coordinating state transitions and scoped adoption, and retaining maintenance obligations. This is a candidate contribution to investigate, not a priority claim or demonstrated advantage over existing systems. Durable module responsibility and the temporary task graph for a change should remain distinct.

Potential corpus connections include [context runtimes](../context-as-existence-runtimes/README.md), [spirit/space/token and Yi](../spirit-space-token-and-yi-substrate/README.md), [Wamotopia](../wamotopia-and-the-wamo-protocol/README.md), and [fork/cooperative infrastructure](../the-fork-and-cooperative-infrastructure/README.md). These are pointers for later comparison. This founding note does not claim to have reconciled their implementations, vocabularies, or normative commitments.

## Current state

On 2026-09-07 Ren asked, “is our idea solid?” The [assistant’s assessment](context/2026-09-07-soundness-assessment.md) distinguishes a coherent research direction from an unproven long-term scaling claim. It identifies maintaining compact, sufficient boundaries under unforeseen changes as the main missing mechanism, and proposes measuring scope expansion before and after changes against a strong baseline. Ren then requested comparison with existing harnesses, teams, implementations, and papers. The [resulting comparison](context/2026-09-07-harness-and-swarm-comparison.md) sharpens the proposed research target to contract, state, and adoption evolution using existing execution machinery. These refinements remain assistant proposals; the research request is not a new endorsement. The original alignment and founding record remain unchanged.

Ren subsequently clarified that the aim is to surpass existing systems and requested deeper thinking, a folder, and an updated plan. The [next-vision folder](next-vision/README.md) is the current planning entry point. It treats the application’s decomposition and development machinery as objects of improvement, while retaining local obligations and continuity. This user-directed ambition supersedes any interpretation that the project’s endpoint is merely integrating existing harnesses. The specific architecture and numerical gates remain assistant proposals.

The direction is aligned and the discussion is archived. No prototype, performance benchmark, formal proof, deployment decision, implementation stack, community constitution, wallet model, or numerical resource budget has been established in this exploration. The [next implementation package](next-vision/PLAN.md) specifies a semantic change across three modules, followed by a full evolution loop and competitive experiments. The [research agenda](RESEARCH-AGENDA.md) retains the underlying open questions.
