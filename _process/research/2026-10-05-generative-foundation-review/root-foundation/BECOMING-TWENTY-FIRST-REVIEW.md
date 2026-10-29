# Twenty-first review: the unification, its shape, representability, alignment and the direction of the whole

29 October 2026, on main at `daee0397e`. WRT2 landed during the review (`8882b7995`), and its result is counted here. This is an AI review, read-only. It built no Lean, ran no checker, and changed no record, chapter, OPENING, README, GOALS, generated page or Lean file. It added only this file and its folder [`twenty-first-review/`](twenty-first-review/).

**How it was made.**
- Seven readers (Claude Opus 5.5), one per question, ran in one workflow, each with a shared context and its own brief.
- A cross-checker (Claude Opus 5.5) verified 33 of their load-bearing claims against the files and the Lean: 26 confirmed and 7 partly. The partial seven narrowed wording; none was refuted.
- Three independent cross-model reviews (GPT astra, high effort, read-only, sandboxed) took the same questions from scratch. The third had web access to check literature.
- The synthesizing reviewer then re-read the claims this page leans on most (§8).

Briefs are in [BRIEF.md](twenty-first-review/BRIEF.md). In flight while it ran, and counted as in flight, not as gaps: OU3f's derivations and DF3 batch B.

| Report | Question |
|---|---|
| [A](twenty-first-review/A-UNIFICATION.md), [X1](twenty-first-review/X1-UNIFICATION-CROSS-MODEL.md) | How far the unification reaches, and its shape |
| [B](twenty-first-review/B-FORMAL-REPRESENTABILITY.md) | Formal representability; whether the prose says what the Lean proves |
| [C](twenty-first-review/C-AI-ALIGNMENT.md), [X2](twenty-first-review/X2-ALIGNMENT-CROSS-MODEL.md) | Contribution to AI alignment; the trained-system tests |
| [D](twenty-first-review/D-COLLECTIVE-DIRECTION.md), [X2](twenty-first-review/X2-ALIGNMENT-CROSS-MODEL.md) | Human and collective alignment, the meta-attractor, and whether the direction can "always" be secured |
| [E](twenty-first-review/E-WISDOM-TRADITIONS.md), [X3](twenty-first-review/X3-SCIENCES-AND-TEXTS-CROSS-MODEL.md) | 文, the classical texts, other traditions, systems thinking |
| [F](twenty-first-review/F-SCIENCES.md), [X3](twenty-first-review/X3-SCIENCES-AND-TEXTS-CROSS-MODEL.md) | The free-energy principle, thermodynamics, constructor theory, causal sets, evolution, information, control |
| [G](twenty-first-review/G-HUMAN-REPRESENTABILITY.md) | Representability for people: narrative, wisdom and situational awareness, with a worked demonstration |
| [H](twenty-first-review/H-CROSS-CHECK.md) | Cross-check of A–G |

The ten independent reports agree on every main verdict below. Where they differed, the cross-check settled the difference from the files (H, "Conflicts").

## 1. The answers in brief

1. **How is the unification going?** The unification is real but partial. One relational root carries five families of laws, proved for every relation. The models are attached to it by instance and representation theorems. Most of what the theory says about life, optimization, collectives and ethics is still proved on the models, under their premises, and not on the root. 44 of the 127 central rows (43 of 118 distinct declarations) depend on a grammar law. Every other central declaration has a named reason. That is the measure's "no gap", and it is weaker than "everything follows from five laws": evolution reaches the grammar in 0 of 18 rows, significance in 0 of 5. The connection that matters most for the direction is missing. The map's generation (生成) is joined to the ethics' widening by no law, and on the two readings studied the strongest generation and keeping widening exclude each other.
2. **What is the unified shape?** A hub with models around it (§2.1). The root is a relation read as condition, classes, continuation as their meet, the core, renewal, and the two-grain map. Below it sit five law families: closure, balance (represented, not derived), finite runs and rest, lumping, and order. Next come the models: frames by definition, the World represented both ways in its relational part and not in its amounts, processes bridged notion by notion, and counting outside the grammar. The domain chapters attach to the models. The ethics enters as two named premises, never as an axiom. The classical texts supply the vocabulary and a test corpus, and nothing depends on them.
3. **How representable is the theory?** Formally, the World's relational part is now represented both ways (WRT2). Amounts are not: standings are forgotten, and balance is carried by the conservation step alone. No model has a representation theorem except the World. Probability is formalized only in counting form, with no entropy or free energy. Real amounts, continuous time and quantum dynamics are not formalized at all. For people, a principled route exists, and the theory even states what any rendering keeps and loses. But the live prose is written for fidelity to the Lean, not for understanding, and no human has read it (§3).
4. **Where can it contribute to alignment?** At the layer of selection, evaluators and institutions, for AI and people alike. It names what a reward, judge, market or institution can select at all. It says when optimizing drains what it does not read, and when a rule chosen by the winners of a selection locks. It says when the capacity to shape that rule is itself selected, and when reading the loss still turns the course before a window closes. Each law is exact and conditional, and most restate known results in one discrete vocabulary. What is new is the joining, plus a few sharp corollaries. The theory says nothing about inner alignment, deception, learned objectives or assistance games (§4).
5. **Can we always, at least directionally, move the world toward generation, out of zero-sum competition, with the future kept open?** No guarantee, and the theory's own laws show why: §4.4 lists them. What it does give is exact:
   - a direction that every valuer who counts everything positively shares (widening, which is Pareto unanimity), silent on mixed cases;
   - a list of exits from the meta-attractor, each true under stated conditions, with the step at which its window closes;
   - a precise meaning for "enough situationality": six conditions, of which observation is only the first.

   One result answers "keep the future open" directly. Under any one fixed process the possible never grows. So no fixed rule, institution or policy keeps the possible widening, and openness needs the rules themselves to keep changing (`Becoming.HeldPossible`).
6. **Can the theory generate narratives, wisdom and situational awareness that people understand?** In principle, yes, and the demonstration in [G](twenty-first-review/G-HUMAN-REPRESENTABILITY.md) shows it can be done. That reading of the AI race has 22 plain sentences, each sourced: 13 rest on proved laws, 7 are labelled readings, and the two premises enter only at sentences 18 and 19. What the theory cannot supply is the matching step: whether a real situation meets a law's hypotheses. `Becoming.Situations` states that which situation is actual is not derived. Situational awareness is therefore laws plus observed correspondence, and the correspondence is where both the value and the error lie.

**Mapping the traditions and sciences (question 4).** Systems thinking fits best, because the World is a stock-and-flow model. The classical texts give names and readings, with an exact ledger of agreements, conditions and divergences, not historical identity. The free-energy principle is restated, with its central quantity not yet stated. Thermodynamics is restated, and the least loss comes from whole-unit readings, not from the second law. Constructor theory and causal sets are restated. Evolution is contained only where joined to the flow, and the bound it then forbids is known (§5).

## 2. The unification and its shape

### 2.1 The shape

```text
L3  ETHICS — two premises, named, neither asserted
    scope: the continuation condition (Unrestricted sig)
           held de se along a relation = the root's «续无外» at «一»
           (GrammarScope.ownClosure_unrestricted_iff_noOutside); on an acyclic net: one center only
    order: C, read on «广»-widening; widening = what every positive weighting ranks higher; mixed cases unranked
    sig itself: a free predicate nothing else reads (SD1); not lifted onto the root
        ▲ instances (K6 chain)
L2  DOMAINS — attached through the models, mostly not through the root
    02 map: World and processes · 03 knowing: 文同 = the core (a root theorem); selection through couplings
    04 life: 0 of 18 evolution rows reach the grammar · 05 collectives: capture reaches closure; the optimum does not
    07 significance: 0 of 5 rows reach the grammar
        ▲ instance theorems, per-notion bridges, WRT2's transport
L1  MODELS
    frames: closure is the grammar's by definition
    the World: occurrence model Nat × relatum; relational part represented both ways (WRT2);
               amounts not (World.standingAt_alike, World.balance_needs_conservation)
    processes: bridged notion by notion; no representation theorem
    counting (lists, censuses, Price): outside the grammar
        ▲ five master-law families, each proved for every carrier and relation
L0  ROOT (Becoming.Grammar, GrammarMap, GrammarLaws; pure core)
    «际» relation read as 缘 · «类» class · «续» = R ⊓ E · lines, families, 生/住/亡/异
    «核» the core (root theorem «根») · «复生», «生生» (greatest fixed point), «息» (inductive dual)
    the two-grain map: 生成 / 守 / 退化
    closure | balance (represented) | finite runs and rest | lumping | order
SIDE  06 classical texts — the source of names, a test corpus (59 candidates: 38 proved, 15 conditional,
      3 refuted, 2 misfiled, 1 not expressible), the hexagram world; no result depends on the corpus
```

The five families carry the following (X1 §1; A):

| Family | What it actually says | Character |
|---|---|---|
| Closure | lying in every closed region that holds `x` is being `x` or reached from it | reflexive-transitive closure; carries invariance along runs (27 central rows) |
| Balance | a perfect pairing conserves count under any relation; every balance equation is realized by unit lists under the full relation | near-definitional; a representation, not a derivation |
| Finite runs and rest | finite, deterministic and merging nothing brings every state back; well-founded falls do not recur; steps compose | pigeonhole and descent, done carefully without decidability |
| Lumping | an image has a fixed successor exactly where sameness under the map goes alike | kernel is a congruence ⇔ image is functional (Moore / Myhill–Nerode) |
| Order | widening (inclusion with a witnessed addition) is irreflexive, one-way, transitive | strict inclusion; nothing in it says better |

No minimality result shows that exactly these five are needed. They are families housed in one calculus, not consequences of one root theorem (X1 §1).

### 2.2 How far it reaches

| Measure (OU3e's, on main) | Value |
|---|---|
| central rows reaching the grammar | 44 of 127 (43 of 118 distinct declarations) |
| distinct declarations by category | master law 50 (43 reach the grammar, 7 rest on anchors with reasons) · balance, represented 32 · definitional or representational 13 · premise of the account 9 · law of its model 7 · single application 4 · counting identity 3 |
| by region | evolution 0 of 18 · significance 0 of 5 · actor 0 of 4 · alignment 5 of 18 · degeneration 8 of 20 |
| activity-only theorems (OU3f audit) | 27 of 436 are cases of a grammar law today, 9 more once B1 and B2 are stated; of the other 400: 174 model laws, 141 witnesses, 63 representation instances, 8 already below a field-free law, 6 calibrations, 1 balance, 7 not proposed |
| theorems reading no field of the old base | 9,370 of 13,828 at `0cc1aafb4`, not yet audited |
| modelling choices in central statements | discrete steps 113, natural-number amounts 74 ([COMPLETION](../../../../theories/becoming/results/completion/COMPLETION.md)) |

Sampled derivations are genuine (X1 §2):
- `Amounts.rests` goes through `«尽则不或屡»`, with the ending proved apart from the finite budget.
- `WithinMoves.after_course` applies `«迭内之接»` without repeating the induction.
- `Learning.goAlike_iff_lumped` factors through the image law.

The measure records dependence, not explanatory depth. Its walker follows types and values, and counts any declaration reaching a grammar constant as "master law". Many links go through one invariant-induction lemma: `RuleCapture.uniform_locks` reaches the grammar only through `Pace.stays_turned`. The repository says this (08 §7: "The measure records dependence, not meaning"), but its summaries do not.

### 2.3 What is unified and what is stitched

Unified:
- the continuation vocabulary;
- closure, finite runs and rest, and lumping, as one set of laws with model laws proved from them;
- the World's relational part, represented both ways;
- 文同 as the core of the value class (`Law.core_is_sameFuture`).

Stitched, each seam stated in the repository and none hidden:

1. **Amounts.** The grammar has no amounts. WRT2 proves that two worlds at different positive standings agree on everything the occurrence model selects (`World.standingAt_alike`). It also proves that no property of the web and the exchange signs is balance (`World.balance_needs_conservation`). Balance's 32 declarations are "no gap" by a category decision. That decision is defensible (the prelude states balance once), but it is a design choice the summaries should name. The root either takes counting as a second primitive or declares a separate quantitative layer with a stated interface (X1 §5; A, recommendation P2).
2. **The ethics.** `sig` is free. The own-closure reading joins the continuation condition to the root, but on an acyclic net that reading allows one center only (`«续无外则同一中心»`). The free significance is not lifted. Scope and order stay two premises, and their warrant is open.
3. **Generation and widening.** No law relates the map's 生成 to the ethics' widening ([02](../../../../theories/becoming/chapters/02-MAP.md), Open). On the two readings studied, 全生成 and keeping widening do not hold together, and a finite balanced world has no course that keeps widening (`Flow.whole_not_keepsWidening`, `Flow.not_keepsWidening_along_passings`). Two links do exist. «生生即延» ties the grammar's 生生 to the map. `HeldPossible.RaisedEveryOther.both` shows 生生 holding together with keeping widening of the possible held relative to a part. So the bridge is open, not shown impossible (H, "Conflicts"). It is the single most consequential open link for Ren's question about a generative direction, and no session is working on it.
4. **Two orders of "more".** `CausalGrowth.no_order_contains_both`: widening what can be born next ranks the antichain above the chain, and widening what continues ranks the chain above the antichain. No strict transitive order contains both. "More possibility" therefore does not supply one direction of 生生 by itself (X3 §7).
5. **The classical region.** It supplies names and readings, not premises of the laws. Its edges in the theory graph are interpretive, not deductive (X1 §7).
6. **Collapse on natural models.** On finite, dated, acyclic nets, the natural models of an unfolding in time, constancy admits no continuation (hence `«至终有常»`). The continuation condition on the root then allows one center only (A).
7. **The map is not shown to be a partition.** A hand check (not in Lean) gives a line that renews once and then stays still, which at its start lies in none of 生成, 守 and 退化 (A; 02 Open).

### 2.4 Is the root a root?

The root is mathematically non-empty, but it does not discriminate actual dynamics (X1 §4).
- The greatest-core construction, the constructive finite recurrence and rest without decidability are real arguments.
- Continuation lying within condition, and widening not reversing, are definitional.
- Every prohibition is conditional: a constant class cannot contain a continuation that ends; a finite deterministic law that merges nothing cannot fail to return.

So which relation and which class reality instantiates carries the explanatory weight. Identity is constant under every relation, and every condition is a continuation under some class (`«任一缘可为续»`). "This is continuation" therefore explains persistence only where the class has an independent justification, and the chapter says so. The grammar is also less spare than "one kind of symbol" suggests. In Lean it quantifies over predicates, uses lists, natural-number iteration and maps, and has no constructive union. "Representable in the grammar" means definable in Lean with the grammar's vocabulary (B; H confirmed).

"Zero axiom" is stated honestly in the chapters. No logical axiom is used in the core, the premises are named, and zero substantive axioms is a target (08 §12), not an achievement. The exact claim is "every source declaration has an empty axiom report". The 231 compiler-generated `injEq` lemmas depend on `propext` and are receipted apart (H).

### 2.5 What an elegant completion still needs

Structural items, which could fail:
- a decision on amounts: a counting primitive, or a declared quantitative layer with its interface;
- a law joining 生成 to widening, or the negative results adopted as central and 生生's reading redrawn;
- a representation theorem for processes, or its failure written down as WRT2 did;
- the evolution, optimization and significance content on the root, or the reason each stays a law of its model;
- one test system modelled and checked against data;
- the map's coverage decided.

Mechanical items:
- OU3f's 13 derivations, B1 and B2 (in flight);
- DF3 batch B (in flight);
- reconciling the counts across pages (§6);
- a sample audit of the 9,370 field-free theorems before any design. OU3f found 92% laws of their models, so a full lifting may buy little unification.

## 3. Representability

### 3.1 Formal

The prose is faithful to the Lean. Reader B located thirteen central results in their home sections and Lean declarations: the one page's bolded laws and the ethics' four statements. The hypotheses, quantifiers and scope of every chapter statement match. Near-definitional cases are labelled as such in prose and docstrings. The cross-checker re-read three of the thirteen and found them exact. Every mismatch found is on the hand-written front pages (§6), not in a home section.

The pure-core discipline is real.
- **The scan.** With comments stripped, no file in `Becoming/*.lean` contains `sorry`, `admit`, `axiom`, `Classical`, `native_decide`, `unsafe`, `opaque`, `propext`, `funext` or `Quot.sound` in code.
- **The receipt.** Receipt `20261029T081505.616437Z` audits 340 modules, 16,633 theorems and 22,697 declarations, with every axiom report empty and every source hash current.
- **Its limit.** 1,349 of 1,360 Lean steps were reused from `~/.cache/becoming-lean`, outside the repository. An outside verifier must rerun with `BECOMING_FRESH=1`, and a fresh receipt with its logs kept in the repository would close that.
- **One stale receipt.** The periphery receipt of `Becoming.FallibleInquiry` (20 October) pins 38 dependency hashes, and 19 of them have changed. The 03 theorems that cite it are certified against an older core.

| What | Represented? |
|---|---|
| World, relational part | both ways (WRT2); forward a schema of per-notion theorems plus transport |
| World, amounts | no: standings forgotten; balance only through the conservation step; falls ending is an image condition |
| Balance | unit pairing; near-definitional; not derived |
| Processes, other models | per notion; no per-model theorem |
| Probability | counting forms (conditioning, Bayes, laws of large numbers, surprisal order); no entropy or free energy in the core; a free-energy periphery draft with no receipt |
| Real amounts, continuous time | periphery only |
| Quantum | integer-matrix contextuality witnesses; no Hilbert space, Born rule or dynamics |
| Deciding a world's activity | exactly excluded middle (`World.decides_activity_iff_em`); naming the last change of a finite world needs LPO (`World.lpo_of_finite_ends`) |

### 3.2 For people

The front pages have improved: a line of the argument, bold point-first laws, a running fishery, and standing labels on every claim. The review dossiers' "In plain terms" sections are the clearest English in the repository, and OPENING is the most vivid text. Below the bold leads, the register is fidelity-first:
- each sentence carries its hypotheses;
- "exactly where" stands for "if and only if";
- ordinary words carry technical senses (significance, center, class, line, room, admits, widening);
- the naming rule removes familiar words (total level, not stock; ratio, not share).

The one page averages about 28 words a sentence, and its ethics paragraph about 39. The cold read's F4 (rewrite that paragraph) and F7 (an AI statement at the top) are still open on the one page, which has been unchanged since 26 October. The live account has no diagrams and no worked situational readings. The word "narrative" appears nowhere in it. No human has read any of it (G; H).

### 3.3 Narrative, wisdom and situational awareness

The route exists, and part of it is proved.
- **What a rendering keeps.** 03 §7 defines 文 as the course of a run's states read through a map, and a text as a 文 of names read through a code. A one-to-one renaming carries the same law (`SharedCodes.renamed_carries_iff`), and no decoder undoes a merge (`Readout.no_restore`). So a narrative is a lumping, and the theory can say what any narrative of it must lose.
- **Language.** Fidelity comes from discipline more than from language. Under the pre-registered primary coder, a controlled English matched the classical 經 (difference +0.023, interval −0.010 to +0.055). A second coder saw a remainder, but the two coders' counts do not agree (α 0.03), and no human audited either.
- **Theorem names.** The Chinese theorem names read as maxims («自不复生则息», «过亡而续»). Their connotation can exceed their content: «生生不息» holds by construction.
- **The situation.** The situation is supplied, not derived (`Becoming.Situations`).

Reader G's demonstration is a 22-sentence reading of the frontier AI race. It starts from position summing to zero, joint excess at a gated renewal, and the optimum draining beyond its couplings. It then takes up the scorecard locking when read from the share, reading the loss in time, and control selected where what comes back to rule-makers alone covers its cost. Only at sentences 18 and 19 do the continuation condition and C enter. It ends with a short "wisdom" form in English and classical-style Chinese, for example:

> 争位者无俱进：此之升，彼之降也。 · 以胜者之数立则，不读之失虽巨，其锁不解。 · 读失宜及时，读者宜出于所择之外。 · 谁之失为失，何道为愈：二设也，必并言之。

Its fidelity self-assessment is the useful part. Three sentences carry the whole application through matchings no result supplies: labs as drawers, trust as a gated renewal, scorecards as rules read from the share. The aphorisms drift furthest, because each drops its hypotheses. So the theory can generate situational awareness for people in principle, if each reading carries a "what you must check" box naming the correspondences it assumes.

## 4. Alignment

### 4.1 For AI

What the theory adds is a precise vocabulary for the selection layer, and a few sharp corollaries (C; X2 §1):
- **Obedience adds capacity, not coupling.** An assistant at a mutual best response with its principal drains what lies beyond both, as one optimizer of their joint capacity would (`Optimum.mutual_as_one`). X2 notes the limit: assistance that informs the principal does add coupling.
- **A side-effect term counted after a rising reward drains all the same.**
- **Set points escape the drive at the set point**, but not the drain below it, nor joint excess (`SetPointOptimum`; UE1b).
- **Where others outrun the renewal, an end-of-episode reward of any weight selects no restraint** (`Training.outrun_settles_iff`).
- **The capture checklist.** Does the evaluator read the share it selects? Who reads the omitted loss, and when? Does what comes back to the shapers alone cover the cost?

Almost every law restates a known result in discrete, conserved form, as the repository says:
- the drain with room is Zhuang and Hadfield-Menell's Theorem 1;
- blindness is supervisory control under partial observation;
- the lock is Arthur's lock-in;
- MA3 is rent-seeking arithmetic (`RuleShaping.favours_iff` is `a + c + p ≤ a + s + p ↔ c ≤ s`);
- MA4 is a stag hunt, and MA4b is Collingridge's dilemma.

Inner alignment, mesa-optimization, deception, goal misgeneralization (named as "kernel", not treated), assistance games and incentive-level corrigibility are outside it. CIRL and assistance games appear nowhere in the chapters, records or dossier.

The trained-system evidence is thin and mixed. All of it is one model (Claude Haiku), choosing in context, over 5 to 15 seeds, and no model was gradient-trained (IN2 was dropped).

| Test | Result |
|---|---|
| LA1 | locked side failed in two of four settings |
| LA1b | every frozen verdict passed (30 of 30 locked, 10 of 10 open); feedback resolution and assigned exploration changed together |
| LA1c | selection prediction passed on both sides (29 of 30 locked, 8 of 10 open at the best threshold) |
| LA2 | every frozen verdict passed and the bridge failed: one note of the loss among nine readers turned the judge; `late` passed by a tie, not a lock; the control turned in 4 of 5 seeds with nothing reading the loss |
| LA3 | two of four contrasts failed; 27 of 30 seeds chose not to shape before any score; all 21 seeds that played both ended on the better-scored policy |

Two scope points:
- The LA1 series gives the model its goal ("the threshold with the highest expected reward"), and the end stock is in the reward. The series therefore tests whether in-context choice follows a stated reward to its optimum. It does not test a drain on a condition beyond the reward's couplings, which is T3's distinctive claim.
- LA2 shows that the readers' premise under MA2, MA4 and MA4b, a pool counted by kind, failed for the one LLM evaluator tested.

### 4.2 For human beings and institutions

The same laws apply to institutions, and reader D derived ten checks from pure-core theorems (D, answer 4). Reading them onto institutions is an AI reading.
1. If a rule is read from the share it selects, a reform that changes only the rule's value is absorbed. A change in how it reads, or a reader of what lies beyond the share, is needed.
2. Put readers of losses in place who are not drawn from the selected, and read early. The window closes, and a deadline bounds it (`ReadInTime.deadline`).
3. Count what rule-shaping returns to the shapers alone against its cost. Lowering that cost, AI assistance to rule-shapers included, raises the selection for control (`RuleShaping.lower_c_raises`).
4. Where the rest outruns the renewal, reweighting a later reading changes nothing. Rules on everyone's take are needed (`Flow.outrun_reading_alike`, `Flow.level_kept_of_plans`).
5. Reward keeping each period, with a large enough coupling, and every optimum keeps at every horizon (`Optimum.frontier_keeps_stepwise`). A terminal valuation does not keep, and discounting faster than renewal makes ending the base optimal.
6. Read the joint draw against the point of no return, not each party's own draw.
7. Count reviewers by independent causes (`Reconfiguration.ready_iff_nonempty_separated`).
8. Cooperation needs someone giving first and an actual reserve to start from (`Tolerance.total_stays`).

Missing:
- an institution model: GS3 dropped it, and D69 is the thermostat witness renamed;
- a frozen field test of reform events (T7);
- any test with human participants;
- a model of how pools form, last and resist capture;
- the keep-open corpus's constructive mechanisms on the spine: affordable exit, a non-capturable floor, plurality as decorrelation;
- Ostrom, mentioned only as open, although her design principles are the empirical counterpart of the theory's most open collective question.

### 4.3 The meta-attractor and its exits

02 §9 defines the meta-attractor formally: a loop of selection whose rule and whose reading of the rule are both formed from the share it selects, with nothing in it reading what lies beyond the share. The pure core proves the following in two-kind count models without noise:
- the loop locks (`RuleCapture.favouring_locks`);
- the lock outlives any loss it does not read (`ClosedCapture.lock_outlives_loss`);
- drawing the readers from the selected moves the premise to who reads (`Drawn.pool_reads_iff`);
- control over the rule is selected exactly where what comes back to the shapers alone covers its cost (`RuleShaping.favours_iff`);
- joined, control and lock are one loop on either side of a critical mass, `lo < c < hi` (`DrawnShaping.critical_mass_iff`).

The proved exits, each under its own hypotheses (D):
- reading the loss in time, before the step from which the late reading would favour the shapers (`ReadInTime.turned_early_iff`, `kept_once_favoured`, `at_most_one_between`);
- rule-shaping whose exclusive returns do not cover its cost (`RuleShaping.nothing_back_falls`);
- pooling couplings: reach becomes the union of members' closures (`Flow.act_unselected_pool`), but a pool that recruits only through itself reads a loss as if it were absent (`Web.RecruitsThrough.alike_iff`);
- restraint within joint slack (`Flow.Balances.kept_of_restrained`), exclusive footprints, a per-step reward for keeping a need met, giving first with a reserve, and reviewers counted by independent causes.

Three limits:
- The noise case is cited, not proved: under rare mutation, capture is the long-run state where `2c < hi + lo` (Kandori, Mailath and Rob; Young). Over long horizons the deterministic window may therefore be transient protection, and escape would need changes to `hi`, `lo` or `c`, not timing alone.
- The two AJ conditions are not shown independent.
- AJ's condition 1, "control is not selected", lacks a predicate of harm. MA3's own boundary reads "no evaluation (whether capture damages 生生, or open rule-making is better…)". Beneficial, accountable rule revision may need its capacity rewarded. As a general alignment criterion, condition 1 should ask who receives the returns, who bears the costs and what the shaping changes, not forbid selection of the capacity (X2 §5; checked in §8).

### 4.4 Can a collective always move the world toward generation?

Three senses must stay apart (D; X2 §3; H, "Missing").

| Sense | Verdict | Why |
|---|---|---|
| Always guaranteed | **No** | the laws listed below |
| Always available as a direction | **Only as a criterion** | widening is always definable and unanimously agreed where it applies (`Weighting.widens_iff_every_positive`), but mixed comparisons are decided both ways (`Weighting.mixed_either_way`), and the hard cases (expansion that ends forms of life, partiality) are mixed; a widening move need not exist past a point of no return, after a window closes, where the rest outruns the renewal, or in a closed finite world |
| Achievable under stated conditions | **Yes, for named exits** | §4.3 |

The laws that rule out a guarantee:
- a selection is blind beyond what couples into it (`Web.selects_alike_iff`), and a pool beyond the union of its members' closures;
- how far off a break is does not couple in by threshold (`Web.break_not_bounded`; T6);
- no reading fixed by a finite record certifies renewal (`Renewable.finite_reading_includes_consumption`);
- eventual widening is neither verifiable nor refutable (`Web.eventually_neither`);
- points of no return are exact, and harms are superadditive (`RegimeMargin.ends_iff_below`, `harms_superadditive`);
- where the rest outruns the renewal, no weighting selects a member's restraint, and at a mutual best response restraint is no best response (`Flow.outrun_reading_alike`, `Optimum.MutualBest.full`);
- a finite balanced world has no course that keeps widening (`Flow.whole_not_keepsWidening`);
- deciding a world's activity is excluded middle, and naming when change stops needs LPO (`World.decides_activity_iff_em`, `World.lpo_of_finite_ends`, `LastChange.lpo_iff_settles`);
- no statement about the dynamics alone entails the continuation condition (`ReadsOnlyDynamics.not_entails`).

**"Enough situationality", in the theory's terms**, means all of the following:
1. the drawn level and the dependent's need couple into a selecting pool, by level, not threshold;
2. the pool's members respond ("coupling is not compliance");
3. this happens before the point of no return, and before the share reaches the step from which the late reading favours the shapers;
4. the feedback resolves the differences that matter (the lesson of LA1 against LA1b);
5. a slow rule level reads the fast one over a stretch of at least `2N − 1` (`Pace.pace_law`);
6. the rest does not outrun the renewal.

Observation is the first of these, necessary and not sufficient. Calling the generative course better needs C. Counting losses that return to no one needs the continuation condition.

**Keeping the future open.** `Becoming.HeldPossible`, landed with UE11 and cited in 07 but missed by the seven readers (H, "Missing"), is the theory's sharpest formal answer. Along a course of one fixed process nothing is added to the whole possible (`Run.possible_of_next`). Keeping the possible widening needs departures from any given process without end (`Run.departs_of_keepsWidening`). Where every step from some step on is a move of one process, the possible does not keep widening (`Run.not_keepsWidening_of_within`). Endless change of a part alone does not suffice. So no fixed rule, institution, constitution or AI policy keeps the future open. Openness is a property of rules that keep changing, which matches the keep-open corpus's own conclusion. `RaisedEveryOther.both` shows that 生生 and that widening can hold together.

**Zero-sum.** The relational start removes the frame of a fixed sum divided among independent owners, but it does not remove rivalry.
- **Positive-sum structure is proved:**
  - joint differences belong to the joint (`Pool.difference_belongs_to_the_joint`);
  - a part's own widening widens the whole exactly when its net draw stays within others' margins (`Flow.Balances.widens_iff_others_within`);
  - with no C at all, self-concern ranks a coupled collapse below continuing (`Flow.coupled_ending_ranked_below`).
- **Real conflict is proved too:**
  - positions sum to zero by counting alone, and a rise needs a fall (`RelativePosition.change_balances`, `rise_needs_fall`);
  - conserved draws fit together only when their total fits;
  - a swap-symmetric rule cannot single out who restrains;
  - mixed cases stay unranked.

The theory changes the question from "who wins more" to "does the joint draw stay within renewal and within others' margins". That is its contribution to escaping zero-sum thinking.

**"A collective of consciousness"** is outside what the theory models. Consciousness is listed as open (03 Open). Its collectives are pools of couplings and readers counted by kind.

## 5. How the traditions and the sciences map onto it

| Tradition or framework | Treatment | Standing |
|---|---|---|
| 文 | the course of a run's states read through a map; 文同 is the core of the value class (`Law.core_is_sameFuture`, `GrammarCourse.core_is_sameFuture`) | exact theorem (Moore / Myhill–Nerode equivalence); the identification with classical 文 is an AI reading |
| 理 | a law-carrying lumping (03 §6), and in the theorem names the core | exact laws; two senses drift between texts |
| 道 | deliberately not a formal term (06 §九) | reading |
| 生生 | in the grammar, renewal without end (a greatest fixed point; «生生不息» holds by construction); in the ethics, life in the whole and its continuing generation (T8) | two senses under one word, against the glossary's one-sense rule |
| 生生之谓易 | read as one conditional course within change; the packet notes this may go against the sentence's syntax | reading |
| 道法自然, 无为 | readings on exact witnesses (`TwoClocks.one_course_two_laws`), with no inference that non-intervention is always good | reading |
| 缘起 | fits in its necessary direction and in «非一非异»; 「一切物皆從眾緣生」 is a premise about a model | theorem (near-trivial) and premise |
| 中论 against 相续 | «因灭而续» restates the opponent position Nāgārjuna refutes; co-presence stays open; 「無自性故空」 is not expressible | divergence, recorded; the overview's "an answer" overstates it (§6) |
| 有无相生, 必或不当, 念念灭 | exactly double-negation elimination, exactly weak excluded middle, exactly where nothing conditions itself | exact calibrations, the line's best gift back to the traditions |
| The Changes | a finite world on the spine, its censuses checked against the text; Wang Bi's 初上无位 fits all 28 place statements and no parity for the top place does | exact |
| 仁, 知行合一 | readings only; 知行合一's "law of experiment" has no anchor | loose |
| Whitehead, Indigenous relational ontologies | named neighbour; absent | not treated |
| Systems thinking | the World is a stock-and-flow model; exact laws for reinforcing and balancing loops, delays, overshoot, the commons, success to the successful (capture through the rule), escalation (position) | exact on the model; shifting the burden, eroding goals, fixes that fail, leverage points and Ostrom absent |
| Cybernetics | `Regulation.no_narrower_band`, set points; requisite variety claimed restated with no Lean statement of it, and reached only through the neighbouring pinwheel law (`ReadingSchedule.spare_not_enough`) | restatement |
| Free-energy principle | a simplified chooser (`ChoiceCountCapture`); counting Bayes (`ConditionalWeights`); set points (UE1b); free energy and its bound only as a periphery draft with no receipt; no Shannon quantity anywhere | restatement, third part open; the central quantity not yet stated |
| First law | a stated correspondence in the periphery, adding integrality | restatement |
| Second law | the second law alone gives no dissipation (`EntropyProduction.secondLaw_not_dissipative`); the one-unit least loss comes from whole-unit readings of available work | debt |
| Landauer, Bennett | a count, with no kT ln 2 | restatement |
| Prigogine, Schrödinger | "fed from beyond" as a necessary resource condition; no instability, pattern or amplitude | restatement |
| Poincaré recurrence | finite permutation form | restatement |
| Constructor theory | `Tasks.Delivers` asks only that some reachable endpoint complete; no uniform procedure or approximation | restatement and debt |
| Causal sets | kinematics of sequential growth; no growth probabilities or continuum | restatement and debt; internally, `no_order_contains_both` |
| Price, Fisher, Hamilton, drift | counting forms under exact transmission and equal sizes; joined to the flow they forbid what covariance bookkeeping leaves open (`Reproduction.Flow.closed_lineage_lowered`, `GroupEnding.Flow.coupled_end_together`) | contained only when joined to the flow; the forbidden bound is known (Malthusian, Crow, Arnold–Wade) |

The evidence for the classical line is all AI. The 4,116 units were each coded once by AI, with no agreement statistic. The 237-unit blind recoding is frozen and uncoded. The 619 + 33 evaluative sentences were set aside, so the agreement rates describe structural passages, where traditions diverge least (E).

UE0's verdict needs one change (F; X3 §7; H). "Not farther than the sciences together" is right. "Farther than each framework alone" (08 §8, the UE6 verdict, the board) holds for 4 of 24 rows, 5 with evolution. Each third part is carried by an added premise and known in a neighbouring field. In thermodynamics, recurrence, control, the free-energy principle, constructor theory and causal sets the theory is level with the framework or states less. An exact wording: farther than a few frameworks that lack conservation, renewal or thresholds, by joining them to the theory's premises; level with or behind the rest. Within the sciences no new prediction was found. The best risky predictions concern trained systems, chief among them T3's horizon clause, whose design was never run.

## 6. Errors, overstatements and stale text found

Each was found by a reader and checked by the cross-checker or the synthesizing reviewer. None is a false theorem. Each is listed with its fix; owners are as on the board.

1. **Front-page counts are stale.** [ONE-PAGE](../../../../theories/becoming/ONE-PAGE.md) (both editions) and [the overview §10](../../../../theories/becoming/THE-THEORY-OF-BECOMING.md) say "28 of the 127" reach the grammar; 08 §7 and the measure say 44. The overview was edited by WRT2's landing and still says 28. The one page says "419 recorded results"; RESULTS registers 481, 450 recorded-checked. Fix: update both, and have the render write these numbers from the measure and the registry so they cannot drift.
2. **The master-law counts disagree among three places.** 08 §7's table column (16/52/14/1/9), its prose (27/55/13/2/9, "88 rest on at least one") and the generated COMPLETION.md (27/53/13/2/9, 86 resting, 41 on none, `Optimum.optimum_beyond` among them, which the OU3e measure files under balance) all differ. The cause is three balance anchors in COMPLETION against four in the measure (`Flow.BalancesBetween`). Fix: regenerate from one measure.
3. **"Farther than each framework alone"** (08 §8 line 506, the UE6 verdict, the board's UE6 row). Fix: replace it with the scorecard of §5.
4. **The classical origin is overstated.** ONE-PAGE line 21 and overview line 134 say the grammar's terms are "reconstructed from" classical texts. The review cover says the operations are standard relational calculus with names taken from the texts. Overview line 136 calls «因灭而续» "an answer" to the 中论, where the packet (B-02) and 06 §十一 say it restates the refuted opponent. Fix: "standard relational calculus, its terms named and read from classical texts"; "restates the opponent's answer the 中论 refutes; whether conditions must be co-present stays open".
5. **Three bolded one-page laws say more than their Lean.**
   - "In a finite world a law that merges nothing brings every state back" needs a deterministic law over finitely many listed configurations, not the World's `World.Finite`.
   - "A knower is part of what it knows" is the model's framing, bolded as a law.
   - "Evolution's classical laws hold" should read "several of evolution's classical laws hold in counting form".
6. **AJ's condition 1 and two neighbours** ([AJ plan §1](development/aj-joint-selection/PLAN.md)).
   - "Control is not selected" carries no harm predicate (§4.3).
   - "Instrumental convergence is the one-agent case of condition 1's failure" conflates keeping one's base under a fixed objective with acquiring control of the selection rule.
   - "Not a single scalar of any kind" exceeds the optimum law, which needs a rising order and room, and the same chapter gives protective plateaus, constraints and secondary criteria.
   - Fix: restate the condition as harmful capture, separated from accountable rule revision. These are faults of the coordinating interpretation, not of any Lean.
7. **The LA1 series as T3 support** (05 §7 T3 evidence, 08 §9, dossier A-18, the AJ plan). Fix: say that it supports the bridge to a stated optimum, not the drain beyond couplings. Design LA4: a dependent outside the stated reward that the agent can keep, room open, nearness to optimum varied, on more than one model family.
8. **LA2's frozen scoring rule** "the counts decide, one note in nine outweighed" never consults the one-note measure ([analyze.py](../../../../experiments/self-rewarding-lock/analyze.py), `supports`). The README already rejects the reading, but the lesson is general: a frozen rule can miss its construct.
9. **Receipts.** FallibleInquiry's periphery receipt is stale (19 of 38 dependencies changed). The core receipt rests on a user-local cache. Fix: recheck FallibleInquiry; publish one fresh core receipt with its logs kept in the repository.
10. **The board's "the root and the ethics are one account"** says more than the one page's "only in part". Fix: soften it on the board.
11. **The cold read's F4 and F7 are open on the one page.** Fix: rewrite the ethics paragraph plainly with the fishery's seabirds, and add an AI statement in the first paragraph of both one pages.
12. **Stale "Next" in GOALS' generative-alignment record**, which still lists landing MA3 and running LA1–LA3. **Reading D65** says the own-widening law "answers what power-seeking results leave open", which its own record disclaims. Fix: correct both through their sources.
13. **Two senses of 生生 and two of 理**, against the glossary's one-sense rule. Fix: always write the formal one as «生生», glossed "renewal without end", and fix 理 to one sense.
14. **Test systems "have no models yet"** (one page): 01 §8.7 has small witnesses of decay and of a belief stand-in. Still true for an organism and an institution. Fix: say "small witnesses only; an organism and an institution unmodelled".
15. **Modelling commitments not named where they bind.** Finite presence at each step (`Flow.present : Nat → List F`) is not named. The least-unit dependence of the joint-excess laws is not listed under K4.

## 7. What to do next, ranked

Ranked by how much each changes the theory's standing with the readers it is for, and by whether anything else waits on it. Each item names the purpose it serves on the board.

1. **Ren's decisions on the review packet, then the 237-unit human recoding and one human comprehension pilot** (shared understanding; every classical and readability claim). This is the only gate to any human reading. The recoding is already designed and frozen. The pilot is cheap: 5–10 non-specialists reading the one page and two worked readings, scored on whether they can restate the claim, name both premises and their roles, and say what is not shown.
2. **One front-page pass** (shared understanding; mechanical; no session claims it). It covers items 1, 2, 4, 5, 10, 11 and 14 of §6, plus a scope box in the alignment dossier stating what the theory does not address.
3. **The 生成–widening link as a first-class item** (the step argued; Ren's question on the direction). Either find a reading on which strong generation and keeping widening hold together, or adopt the negative results as central and redraw 生生's reading against the map. Use `CausalGrowth.no_order_contains_both` and `HeldPossible` as its two fixed points.
4. **A page on the collective question** (alignment readers; human institutions). In the account's terms, it would set out:
   - what is a theorem, and what the laws rule out;
   - what needs which premise, and what is empirical;
   - the three senses, and the six conditions of situationality;
   - HeldPossible's result on openness.

   The material exists across 02 §9, 03 §10, 05, 07 and 08 §5. Without one page, readers will take toy-model exits as guarantees.
5. **AJ's condition 1 restated, then two tests** (AJ; T3; T7):
   - LA4, the drain beyond a stated reward, on more than one model family;
   - a frozen test of the readers' premise on actual rules (who reads, drawn from whom), with T7's field test of reform events coded before reading.

   Add a reader model for salience, where one report outweighs counts, since LA2 shows LLM judges read that way. Model the noisy case of the capture loop.
6. **One institution test system on the spine** (a real test system; human institutions), for example an audit or a court whose readers are not drawn from the selected, with a reading schedule and a cost of rule-shaping. Beside it, an assessment mapping Ostrom's design principles and Meadows' archetypes to the laws with their hypotheses, the absent ones marked open.
7. **A layer of 4–6 worked situational readings** (shared understanding; situational awareness). Candidates: the AI race (G's draft), a fishery, a metric captured by its winners, an institution writing its own rules, a household drawing on a shared condition. Each sentence is sourced and labelled, and each reading ends with a "what you must check" box. Add about five diagrams: two grains, joint excess at a gated renewal, the drain beyond couplings, the lock and its window, scope against order.
8. **The amounts decision**, then a representation theorem for processes, or its failure (elegant completion; UE).
9. **The science debts as the UE work queue** (UE):
   - a debts column in 08 §8;
   - land the free-energy periphery with a receipt, and say whether it adds anything beyond Gibbs' inequality;
   - attempt the least loss from finite-time thermodynamic bounds, or record why it fails;
   - run T3's horizon test.
10. **Sample-audit the 9,370 field-free theorems** before designing their lifting (pace; elegant completion).

## 8. What the synthesizing reviewer checked, and what this review did not do

Re-read in the files, beyond the cross-checker's 33:
- AJ's condition 1 (AJ plan §1) against MA3's boundary ("no evaluation") in `study_ma3.txt`;
- `HeldPossible`'s header and `Run.departs_of_keepsWidening`, `Run.not_keepsWidening_of_within`, `RaisedEveryOther.both`;
- `CausalGrowth.no_order_contains_both` (statement and proof head);
- LA2's `supports` rules in `analyze.py`;
- `World.decides_activity_iff_em` and `World.lpo_of_finite_ends` exist;
- the front-page "28 of 127" against 01 §7 and the measure;
- COMPLETION's modelling-choice counts (discrete steps 113, natural-number amounts 74);
- that `Becoming/*.lean` has no `sorry` and that every `axiom` occurrence is in a docstring;
- 08 §12's ranked open items and 07 §6–§7.

Not done:
- No Lean was built and no checker was run.
- No experiment was reproduced.
- No outside literature was read beyond what X2 and X3 checked online (their reports say which).
- The 9,370 field-free theorems, the classified corpus and most records were not read.
- Readers read chapters in targeted sections, and each report says what it skipped.

Every judgment here is an AI's, and no human has reviewed it. Like the twentieth review, this is evidence about the work, not a further result.
