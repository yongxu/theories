# The spine of the eight chapters

Board item RA, step 3 ([architecture plan](../ARCHITECTURE-PLAN.md)). 23 October 2026. This is the brief every chapter is drafted from: the thesis of the whole, each chapter's thesis and sections, the results each chapter states, the shared vocabulary, the labels of standing and the rules of style. A drafter reads it before the chapter's [dossier](dossiers/) and its rows in [chapter-records.tsv](chapter-records.tsv).

## 1. What the restructure produces

Four layers, each finishable on its own:

| Layer | Path | Length |
|---|---|---|
| One page | `theories/becoming/ONE-PAGE.md`, `ONE-PAGE.zh.md` | ≤ 1,000 words |
| Overview | `theories/becoming/OVERVIEW.md`, `OVERVIEW.zh.md` | ≤ 10,000 words |
| Eight chapters | `theories/becoming/chapters/01-ROOT.md` … `08-METHOD.md` | 4,000–12,000 words each, never above 15,000 |
| Evidence | records, Lean, receipts, studies | not for reading through |

The chapters replace the canonical chapter and the chapters that overlap it; those move to `history/` byte for byte once the new text states what they carry. Records keep citing the reviewed text they cite now. The [theory graph](../../../../theories/becoming/results/THEORY-GRAPH.md) joins each chapter section to the results it states.

**Completeness, checkably.** Every record of [regions.json](../../../../theories/becoming/results/data/regions.json) outside the region `retire` is stated in exactly one chapter section, its *home*, which carries the anchor `<a id="r-<record id>"></a>` immediately before the paragraph, list item or table that states it. Anywhere else the result is linked, never restated: `[the rest theorem](02-MAP.md#r-least-loss-rest)`. The graph page marks every result without a home with `·`; when the chapters land, no mark remains. A drafter who finds a result belongs to another chapter says so in its report; the integrator moves it in `regions.json`.

## 2. The thesis of the whole

**In one sentence.** The Theory of Becoming explains how relations form, persist, transform, degenerate and dissolve within one relational unfolding, and how life, evolution, knowing and evaluation differentiate within it, without first assuming that becoming is good.

**The root.** One kind of symbol suffices: a relation, read as condition (缘, *yuán*): `R x y` says `x` is a condition of `y`. Sameness is relative to a class (类, *lèi*). Continuation (续, *xù*) is a condition joined with sameness under a class. Beginning, abiding, altering and ending (生住异亡) are positions in a line of continuation, and none stands alone. Where the class is constant under the relation (有常), continuation does not end, and what continues of its own is the core (核). Renewal (复生, 生生) is continuation of a pattern at a coarser grain carried by beginnings at a finer one. Every later chapter reads its subject as continuation relative to some class: which relation, which class, at which grain, constant or not. The grammar's theorems hold of every relation and class; that this reading explains how things go on is the theory's claim, argued from the laws on the models, and that every becoming has a faithful representation in the grammar is open.

**The models.** The older bases are models of the root, not rivals to it. A process (a step relation with its runs) is a relation; the World (a web of dependence with natural-number amounts and discrete steps) is a richer model with eight premises that some worlds meet and others fail. Their continuation families, arising and ceasing, and identity across steps are instances of the grammar's terms. Most laws of the theory are proved on these models; lifting each onto the grammar is the formal work the restructure leaves (§6), and until it is done a chapter says on which model a law is proved.

**The chain of chapters.**

1. **The root** states the grammar and its theorems, shows the World and processes as models, and states the laws that hold on every model with no premise.
2. **The map** reads every branch as generation, keeping or degeneration, and gives, on the models, the laws of renewal and consumption, rest, margin, loops and capture: what makes continuation end or go on.
3. **Knowing** is a relation inside the unfolding: a selection reaches exactly what couples into it; testing tells apart within the net; 理 is a lumping and 文 the course of states through a map.
4. **Life** is continuation that renews its own conditions; evolution is descent with selection, and its classical laws hold in counting form.
5. **Collectives** begin from actual relations: joint consumption, mutual dependence, relative position, giving that waits on giving, one master law of optimization beyond its couplings, pools and shared codes.
6. **The classical texts** (in Chinese) carry a relational grammar; the corpus is read sentence by sentence into definitions, theorems, conditional laws, splits and counter-readings, and the divergences are kept.
7. **Significance**: dynamics do not entail significance; with no premise widening is an order; the ethics rests on two premises with two roles (the continuation condition for scope, C for order), neither asserted; alignment is first what a selection reaches, then a conditional direction.
8. **Method**: zero premises first, the pure core and the periphery, standings, calibrations, what is expressible versus derived, known results, theses and the open programme.

## 3. Labels of standing

Every result statement opens with one bold label and, for proved results, its base in parentheses. A reader can tell from the label alone what the sentence claims.

| Label | Means |
|---|---|
| **Definition.** | a term is introduced; nothing is claimed |
| **Theorem** (root) | proved on `Becoming.Grammar` or a grammar module: holds for every carrier, relation and class |
| **Theorem** (any process) / (any type) | proved for every step relation, or for every type, on the frame or a general module: grammar-level in content, not yet written in the grammar's vocabulary |
| **Theorem** (World) | proved on the World model; the World premises it uses are named (balance, dissipation, embodiment, support, transmission, and the rest of the eight), and so are local hypotheses (finite, listed, decided) |
| **Theorem** (periphery) | proved with Mathlib or with axioms; the axioms are reported |
| **Conditional.** | holds under the continuation condition, C, or a practical commitment (J1–J4, BC1, …); every premise used is named |
| **Calibration.** | a law needs an omniscience principle (LPO, WLPO, LLPO, excluded middle); the sentence says what the need says about the unfolding (for example, that settling is deciding whether a run changes again) |
| **Thesis T*n*.** | an empirical claim: what it forbids, what would refute it, the evidence so far |
| **Reading** [AI reading, D*n*] | an interpretation of checked content, with its argument; it changes no theorem |
| **Open.** | not shown; says what would show it |
| **Assessment.** | a scoped evaluation with evidence and no Lean (records of kind `assessment`, published methods read against the laws, empirical tests); says what was evaluated and against what |

Bases may also name a model, such as (the Changes) for the hexagram modules. Write what the Lean proves, with its hypotheses: no stronger, no weaker ([decisions of the second round](DECISIONS-ROUND-2.md) §1). A finite example is an example, not a law. A theorem stated "for every" carries its local hypotheses in the sentence.

## 4. The eight chapters

Section lists are the intended order; a drafter may merge, split or reorder sections where the argument reads better, and must say why in its report. Record ids name the home of the central results; every other record of the region gets its home in the section that fits it. Where this spine and `regions.json` once disagreed, the homes were settled on 23 October after the first drafts (content decides; `regions.json` follows the anchors). "(T*n*)" marks where a thesis lives.

### 4.1 `01-ROOT.md`: The root: continuation relative to a class

**Thesis.** One relation read as condition, one class read as sameness, and continuation as their meet are enough to state how anything goes on, alters and ends; constancy makes continuation unending and the core is what continues of its own; the older bases are models, and on every model some laws hold with no premise.

1. *One kind of symbol.* 际 and its operations (而 逆 合 非 则 谓 一 静 及 无环). The carrier is a parameter, not a claim that elements exist apart from their relations; equality on it is a commitment of the model. The main reading 缘, and the two readings of a net (one history; alternatives with a conflict relation), under which constancy and the core are the same formulas. The classical definitions written in the grammar live in 06 (`classical-definitions-in-the-grammar`).
2. *Class and continuation.* 类, 续, 相续 (a line), 同族 (a family). Why continuation is not defined through the core. Record `continuation-relative-to-a-class`.
3. *The four marks.* 生 住 异 亡; no mark stands alone (`«四相无自立»`); deciding the marks on every line is excluded middle (`«四相之定当且仅当排中»`, a calibration: the boundary is where going on is not decided).
4. *Constancy and the core.* 有常 (`E˘;R ⊆ R;E˘`), `«有常则续不尽»`, `«闭合当且仅当有常»`, the core 核 as the greatest symmetric constant relation within the class (`«根»`), 位核.
5. *Fire and fuel.* `«以核为判据则火无续»`: the core alone is not the criterion of continuation. In one flame fire and fuel need each other through the core (`«火薪相须»`) and the witness picks no class (`«火之见证不择类»`); in two flames the fuel is singled out against sameness of flame (`«两火以薪定理»`, `«两火同火不足以定理»`); that every flame continues only through its fuel is not proved (corrected by OU6). Self-maintenance, mutual need and dependence (自持, 相须, 因于).
6. *Renewal and grains.* 复生, 生生, the coarse net 粗, renewal at a grain, `«生生不息»`; higher orders as a chain of classes. Hand over to the map (02) for generation, keeping and degeneration.
7. *What the grammar can say and what it derives.* Two sentences and a link to 08: expressible is not derived; a law proved on a model is lifted only by a dependency audit, a lifting and a representation theorem.
8. *The models.* Processes and the World as models; the eight World premises, each met by some worlds and failed by others, four holding by construction, a census under a stated condition, and three as states of the law when read off one exchange (`map-of-premises`, `premises-read-off-the-exchange`, `premises-that-are-states-of-the-law`, `requirement-over-open-exchanges`); balance from the first law and from continuity (`balance-from-the-first-law`, `balance-from-conservation-along-a-relation`); the instance theorems that make the World's arising, ceasing and identity instances of 生, 亡 and 续 (in `Becoming.Arising`, `Change`, `Identity`, `ContinuedClasses`, `Persistence`, `PatternPassing`, `Space`).
9. *Laws on every model, with no premise.* One change, three readings, and coming and ceasing keep pace (`coming-and-ceasing-keep-pace`); a configuration is how it relates (`configurations-alike-by-relation`, `tests-fix-likeness-where-determined` if knowing does not take it); separation loses the relation; process and frame as readings, worlds as runs; a history fixes the law it shows; recurrence without premise; counting, census and the whole law of counting; the order of change (disjoint exchanges commute, normal forms need decided apartness); the step index from own courses and interleavings (`the-step-index-from-own-courses`); laws of one step and sums over histories; identity across steps and classes along a continuation; levels of closure as one closure (`levels-of-closure`) and which links a closure needs (`which-links-a-closure-needs`); every origin passes the gate (a calibration); the losses of the sum over histories. Wholes of some part and of every part live in 02 beside the other wholes.
10. *The modelling commitments.* Discrete steps, one shared index, natural-number amounts, Prop-valued activity, one kind of relatum: where the real assumptions lie and which laws depend on them (short; details in 08).
11. *What the root does not show; open.* Which laws are not yet on the grammar (the graph's count), identity from continuity rather than naming, the deductive necessity of the whole.

### 4.2 `02-MAP.md`: Generation, keeping and degeneration

**Thesis.** On every branch a pattern generates, keeps, or degenerates, or mixes these; the grammar fixes the regions and their boundary, and the models give exact laws of what makes a pattern end or go on: renewal and consumption, rest, the margin of a regime, carried differences and loops, regulation, and capture through the rule that outlives its loss.

1. *The map on branches* (root). 传 (carrying renewal, 火传), 延 (goes on along some branch, coinductive), 尽 (ends on every branch, inductive), 生成, 守, 退化 and the strong forms 全生成, 全守, 有终 (有终 an end, not degeneration); the regions exclude each other and are inhabited; a constant coarse class has no end from a continued point; renewal does not decide the region; deciding the regions is excluded middle; on a single line generation and keeping do not hold together; higher orders. Record `generation-and-degeneration-at-two-grains`; the instances on the World (`Becoming.MapInstances`).
2. *Return and attraction.* Attraction is not returning; returning where the course branches; necessarily drawn is not returning; every loss passes a juncture (机).
3. *Renewal and consumption.* Renewal and consumption belong to runs; continued generation needs renewal; no finite part bears taking under dissipation; continued change needs openness; a continuing self is fed from beyond; more needs renewers (04 links it); no finite history decides the renewal class (if knowing does not take it).
4. *Rest.* The rest theorem (`least-loss-rest`); rest needs a least loss or a finite reading; rest in any amounts; rest exactly where falls stop; least loss from entropy production (periphery).
5. *Draw and margin.* The margin of a regime (`margin-of-a-regime`), adjusted giving, where a run of a regime comes to rest, the threshold in the state plane, regimes in any amounts and over the reals, coupled regimes and coupled webs, thresholds beyond a band; one law of exact thresholds stated once, its cases in one table. (T1, T2, with MQ1–MQ7.)
6. *Closures within the map.* Feeding closure: consumption ends with its feeders; keeping a part is not renewal; wholes of some part, of every part, and graded. (Derived extent limits live in 07 with route (b).)
7. *Carried differences and loops.* The counterfactual is the course; where two courses rejoin; how much difference arrives; what a cut loses; orders as sums over routes, finite order iff no loop; how loops form; whether a loop closes a difference; exponential pace around always-coupled loops; how often couplings act; saturation; runaway (the distance to the break does not couple in); settling and LPO (calibration).
8. *Regulation and tolerance.* Two-sided regulation and late reading; how fast a rule may change; tolerance monotone across laws; repeated disturbance; dormancy and reserves.
9. *Capture.* Target capture (more-than-now needs an open world, "above all" never rests for two, the share rises); capture through the rule; closed capture: the lock outlives the loss (the meta-attractor, 元吸引子). (T7.)
10. *What the map does not show; open.*

Markets go to 05; the map's capture section links there.

### 4.3 `03-KNOWING.md`: Knowing, learning and testing

**Thesis.** Knowing is a relation within the unfolding, not a mirror beside it: a selection reaches exactly what couples into the selector, and what lies beyond is 无明; 明 widens what couples in. Testing tells apart within the net; laws are read along runs; what a finite stretch refutes is closed and what it verifies is open; 理 is a lumping that models structure and change at once; 文 is the course of states through a map.

1. *A selection reaches what couples in.* `selection-through-couplings`; training as selection through data, right only where what matters is lumped alike (what training installs lives in 07 §6).
2. *Observation is a route.* `observation-is-a-route`; feedback carries only the influence closure; history sums; coupling by level; what dependence alone carries.
3. *Testing within the net* (root). 层, `«核在每层之内»`, `«可分则不在核»` (its converse, that what no finite stage tells apart lies in the core, is the Hennessy–Milner direction, a calibration not stated for 层; stated with stages of inquiry 诘, which no theorem yet relates to 层, it fails without a premise, `«致诘不尽»`, and holds where the class is symmetric and being told apart at no stage of inquiry is constant under the step, `«不可致诘而有常则混而为一»`), `«恒温与平衡»` (a wider net tells apart what a narrower one does not); testing within couplings; experiment needs return and a model of the irrelevant; tests fix likeness where determined; two counterfactuals. Record `testing-within-the-net`.
4. *Laws along a run.* A projection carrying a law (mechanism); laws through a projection, through coupling, along one run; causal models.
5. *Refutation and verification.* A history read off its finite stretches; refutable is closed, verifiable is open; safety and liveness split constructively; insulated practices need dense readings; what a method comes to say in the limit; learning by refutation (no prefix fixes the next value).
6. *理: lumping.* Generalization through lumping; identification where bounded; learnable through a map; identification where runs part, typicality; the split that makes sense (the coarsest value-keeping law); readings within what they read; contextuality, gluing and parity; claims shown in context.
7. *文.* The course of a run's states through a map (`wen-in-the-grammar`; 01 links it where the core meets likeness, 06 gives the classical reading); the least reading and its failure; composition of names. Classical readings of 文 live in 06.
8. *Learning and seeking.* Laws of learning without axiom; acquired composition, binding, segmentation, enacted access and encounter selection; seeking rests only at a fixed state (settling and LPO); selection revises its lumping; learning within capture.
9. *Inquiry.* Finite fallible inquiry; sustained inquiry needs provision; scientific standing (inspectable grounds and operative correction routes); propositional knowledge; when to inquire and when to respond; what a center can come to know of its region, and how a center forms; wisdom: success changes the next response.
10. *A break seen coming* (T6): only through what couples into what breaks; evidence EW1–EW4 and slowing down (CS1).
11. *What knowing does not show; open.*

### 4.4 `04-LIFE.md`: Life and evolution

**Thesis.** Life is continuation that renews its own conditions: generation is replenishment and life a condition of life. Evolution is descent with selection; on the spine its classical laws hold in counting form; selection is blind beyond its couplings and a rise draws from beyond.

1. *Life as a condition of life.* Generation is replenishment (`generation-is-replenishment`, `life-as-condition-of-life`); arising is given; more needs renewers (linked from 02); living crosses arising and ceasing; forming anew is necessary and sufficient; the law of forming.
2. *Passing and transmission.* A pattern lasts only through passing (`a-pattern-lasts-through-passing`); transmission is inheritance and need; copying and its correction; inherited structural copying (periphery).
3. *Descent.* Price's equation in counting form (`evolution-on-descent`); the selection term proper over generations.
4. *Reproduction.* Fisher's theorem with exact transmission; what bounds offspring numbers; the additive part of offspring variance and the breeding value.
5. *Groups.* Selection within and among groups of any sizes; groups formed by descent; selection among groups by ending, coupled groups ending together; Hamilton's rule from returns to groupmates; a confined rise within a whole (the germ line and cancer).
6. *Drift and fixation.* Offspring sampled rather than listed; neutral fixation; fixation with selection (Moran); mutation–selection balance.
7. *Selection blind beyond its couplings* (link to 03 and 05): what the spine adds to known population genetics, and what it does not.
8. *Organization within organisms.* Part–whole organization; consequences select the organization that learns; development and the four linked questions of developmental and evolutionary psychology.
9. *Empirical correspondences*, briefly (yeast retention, packing, settling, aggregation; bacterial lineages), each with its standing.
10. *What life does not show; open.*

### 4.5 `05-COLLECTIVES.md`: Joint activity and selection

**Thesis.** Joint activity begins from actual relations, not from opposed interests or a fixed common utility: what the whole relation's change supports, enriches or damages. Joint consumption has no single consumer; mutual dependence brings exponential pace; relative position sums to zero; giving that waits on giving absorbs or returns; one master law governs optimization, which drains what lies beyond its couplings exactly where that gives room; pools widen what couples in, and shared codes form between formations.

1. *Joint consumption and joint excess.* Joint difference-making; takers each within what is given can together exceed it (`own-count-misses-joint-excess`); a whole drawing its parts' arising beyond its renewal ends; what taking all excludes; the rest outruns the renewal.
2. *Mutual dependence.* `mutual-dependence-and-its-pace`; sharing, dependence and the feeding hierarchy.
3. *Position.* Relative position is zero-sum (`relative-position-is-zero-sum`); position does not protect; a race for position draws everything.
4. *Conditions kept together.* The invariance kernel and choice points; the social-viability constraints as laws, in one table.
5. *Giving that waits on giving.* Withholding absorbs or returns; restoring from the worst start; tolerance absorbs without restoring.
6. *What a rise draws from beyond.* Raising what couples in draws from beyond, graded by inflow; what a rise breaks beyond; the joint draw.
7. *The optimum: one law, its cases.* State the master law once (the optimum lowers what lies beyond as far as any outcome does; `Optimum.Next`, `kept_returns`), then one table of its cases: room read off the exchange, several optimizers, courses over a horizon, keeping forgoes, step couplings, met steps, weighted draws, rebuilding, valuing what is left, drawers in turn, at once, floors and capacities, whom restraint pays. The superseded records are named in the table as cases subsumed, not restated. (T3, with CG1, CG2, CG3, MQ1, IN1, SE1.)
8. *Pools.* What pooled coupling reaches; what a pool's acts respond to; a pool that recruits through itself; a pool read by its majority.
9. *Shared codes.* A code formed between formations (约定俗成); copied witnesses change nothing; joint practice forms continuation.
10. *Markets.* Selection within a market regime and the rules winners reproduce; the margin M; two local attractors; supported and partial transitions (β ≤ 5/12); the finite-support obstruction; enshittification as an institutional form of degeneration; each stated with its model's standing (frame or periphery).
11. *Joint plans and applications.* Joint continuation plans (periphery); commons with gated renewal; organizational formation; software continuation.
12. *What collectives do not show; open.*

### 4.6 `06-CLASSICAL-TEXTS.md`: 古文：读出、检验与分歧 (in Chinese)

**论题。** 古文自有一套关系之文法；根之文法即从中读出。语料逐句归类：甲（定义）、乙（文法之定理）、丙一（有条件之律）、丙二、丁、戊（相分）、己（反读），各类有其去处；易传之世界是纯核之世界；九家二百四十八句之对应、脉络五千六百七十三判断与文理生生，皆有检验；分歧照录。

1. 为何从古文读文法：墨经、荀子正名、系辞、中文佛典之所以入语料；三最简与各类之对应。
2. 语料与归类：两轮语料之数，归类之法与统计，候选定理之结果（`candidate-theorems-of-the-corpus`）。
3. 定义：古文之定义写入文法（`classical-definitions-in-the-grammar`，01 链至此）。
4. 文法之定理：已证者，逐条附 Lean 名与原文。
5. 有条件之律：其条件何在。
6. 易：易之世界为纯核之世界（Y1）、爻位之关系（Y2）、卦之律（Y3）、王弼之读（Y4）、传之次序（Y5）。
7. 九家之对应（RO，二百四十八句）与其所揭之缺口。
8. 脉络与中华本：五千六百七十三判断、名表；中华本以古名重述全论（其地位）。
9. 文理生生：文为值之所历；与名表之比较。
10. 道、德、无为、汉字、先秦、王阳明：各章所独有者，合为短节。
11. 闭之类型（闭、成闭、护闭、元闭、伪开）与开之四标（未、可、应、转）。
12. 相分与反读：分歧之处，照录。
13. 尚未做到：人审（古文学者、佛学学者、逻辑学者）。

### 4.7 `07-SIGNIFICANCE.md`: Significance, ethics and alignment

**Thesis.** Dynamics do not entail significance. With no premise, widening what can form is an order. The ethics rests on two premises with two roles, neither asserted: the continuation condition fixes scope (whose losses count) and C fixes order (that widening is better); the step of invariance is the condition's content beyond the self. Under them living significance and the practical results are conditional theorems. Alignment is first a question of what a selection reaches, with no premise, then of direction, under the premises named.

1. *How evaluation forms within the unfolding.* Centers and regions; the four questions of a standard; dynamics do not entail significance; what the dynamics leave open: excluding rivals.
2. *The order with no premise.* Four cases of a part (`four-cases-of-a-part`); closing needs a net draw beyond the margin, opening a net give; support from the supported; retained within the margin; loss beyond a region; comparison within reach; what widening counts (along readings, by growth, across a stretch).
3. *The continuation condition.* Its statement and its instantiation note; living significance characterized and its premises minimal (`metaethical-core-characterization`, `continuation-condition-yields-living-significance`); route (b) without the condition; what the condition does not settle; the condition orders nothing.
4. *Scope and order.* The two premises and their roles (state the ethics this way wherever it is summarized); the decomposition (`continuation-condition-decomposition`) and presupposition scopes; the step of invariance and what it forces (`what-the-step-across-standpoints-reaches`); the de se question reduced to one exact question; self-concern through dependence; C as what every positive or increasing weighting shares (`widening-as-what-every-weighting-ranks`); weights within a ratio; what self-concern alone ranks; graded significance and priority.
5. *Practical judgment* (conditional). Ranking under readings; the laws of easing (stepwise, relational); basic priority; the commitments J1–J4 and their lifting; the four responses, responsibilities and the conflict procedure; the disclosed comparison commitments (BC1, BC2, LC, FR, NP) in one table.
6. *What a selection reaches: alignment with no premise.* The laws of what a selection cannot reach; the reward process is the selector; own widening within the margin against power-seeking and impact measures; six known approaches as selections through couplings; coupling closures of deployed pipelines; oversight as a reading schedule; pooled coupling across intelligences (link to 05).
7. *The conditional direction.* The alignment route under the premises named; a requested change must be an executable sequence (correction protocols: quorum, mediated control, reserved stop), each with its scope.
8. *Theses.* T4 (the scope can be installed, and it carries), T5 (the order is shared by every valuer who counts everything positively), with IN1, VT1, VD1, VD2; T8 as the direction of 生生, scope by the condition and order by C.
9. *Objections and verdicts.* The step across standpoints; agent-relative reasons and partiality; why anything has significance; externalism; graded status, priority, sufficiency.
10. *What the ethics does not do; open.* The warrant of the condition, of C and of the step; seeing is not valuing; coupling is not compliance.

### 4.8 `08-METHOD.md`: Method and the formal core

**Thesis.** The theory is built from zero premises first and names every premise it uses; its formal core imports only Lean's prelude and every declaration has an empty axiom report, which concerns logic only; the real assumptions lie in the modelling, and each is stated where a law depends on it.

1. *Beginning within the one unfolding.* Analytic distinctions state their relational basis, scope and omissions; "supplied" is local; the five-step test of constitutive connections; process, theory and model kept apart; name relations, not authorship, payment or ownership.
2. *Standings and bases.* The labels of §3 of this spine, with examples; the five words held to one sense.
3. *The pure core and the periphery.* What the checker enforces; why the core excludes propext (an exact lumping that loses the course: `proposition-identity`); the rings; receipts and periphery receipts; extend the spine, do not rebuild.
4. *Modelling commitments.* Discrete steps, one index, natural-number amounts, Prop-valued activity, thresholds, identity, pointwise statements; which laws depend on each; amounts that may be dense.
5. *Calibrations.* Decidedness, excluded middle, WEM, DNE, LPO, WLPO, Markov, LLPO, choice; each with what its need says about the unfolding; a law of the whole and no part.
6. *Expressible is not derived.* Premise stripping by dependency audit, lifting and representation theorem; pairing and power; mutual interpretation with Lean; type construction alone yields no dynamics.
7. *Master laws and connectivity.* Closure, balance, finite runs, lumping, order: each stated once, and the measure of how many central results rest on them.
8. *Known results.* The central results with their nearest prior results and verdicts; what survives the prior-art review.
9. *Theses.* Strength as content; the table of T1–T8 with their homes, refutation conditions and evidence.
10. *Names.* Naming criteria; the retired labels (G0, Part I/II, the one axiom) explained once; the retired Lean names.
11. *Reviews.* Every review so far is by AI; the plan of human review (the review packet, after the restructure).
12. *The open programme.* The target (one unified, enclosed, zero-axiom theory) against what is reached; the completion criterion; what would change the account.

## 5. Shared vocabulary

Each term has one home; elsewhere link to it. English chapters introduce a Chinese term once, with pinyin and gloss, then use the English word.

| Term | English | Home |
|---|---|---|
| 际 | relation | 01 |
| 缘 | condition (`R x y`: `x` is a condition of `y`) | 01 |
| 类 | class (an equivalence relation) | 01 |
| 续 | continuation (relative to a class) | 01 |
| 相续, 同族 | line, family | 01 |
| 生 住 异 亡 | begins, abides, alters, ends (the four marks) | 01 |
| 有常 | constancy (the class is constant under the relation) | 01 |
| 核, 位核 | the core; the core read both ways | 01 |
| 复生, 生生 | renews; renewal without end. 生生 also names life in the whole and its continuing generation | 01, 07 |
| 粗 | the coarse net | 01 |
| 及 | reach | 01 |
| 传 | carrying renewal | 02 |
| 延, 尽 | goes on (along some branch), ends (on every branch) | 02 |
| 生成, 守, 退化 | generation, keeping, degeneration | 02 |
| 机 | juncture | 02 |
| 元吸引子 | meta-attractor (closed capture) | 02 |
| couples into | what reaches a selector through its couplings (never "registers") | 03 |
| 无明, 明 | seeking locked onto a target that cannot be met at rest (the position every formation selects from grounds it and is not it); coupling joined to a selection, so it reaches what support does not mark | 03 |
| 验, 层 | testing within the net; stages of the core | 03 |
| 理 | a lumping that models structure and change | 03 |
| 文 | the course of a run's states through a map | 03 |
| margin, draw, giving, renewal, consumption | as defined in 02 | 02 |
| optimum, drawer, pool, shared code | as defined in 05 | 05 |
| significance (`sig`), living significance | 07 | 07 |
| the continuation condition (`Unrestricted`) | for anything, its continuation into the future has significance | 07 |
| C | the widening comparison: widening what can form is better | 07 |
| the step of invariance | the condition's content beyond the self's presupposition | 07 |
| standing, base, core, periphery, calibration | 08 | 08 |

"Generative" never means any new organization: generation is a pattern going on through carrying renewal, and 生生 is life in the whole and its continuing generation. Generation and degeneration do not overlap.

## 6. Style

- **Mechanism first.** A section opens with what happens, in words a reader without Lean can follow, then the precise statement, then the Lean name. No aphorism first; a term only where ordinary language fails.
- **One claim, one place.** A paragraph states one result. No sentences that chain record ids ("SG1–SG13, UM, UM2 …"): a family of cases is one law and one table. At most three Lean names in a paragraph; full lists live in records and the graph.
- **Monist wording.** No independent agent, environment, owner, stakeholder or utility as ontology; formations, conditions, relations, occurrences, couplings. A distinction (subject and object, fact and value) states its relational basis where it is introduced. No social or financial words for formal notions; markets appear as markets only in 05.
- **The ethics.** Wherever it is summarized, name both premises with their roles: the continuation condition for scope, C for order. Never write that the ethics derives from the condition.
- **Names.** No person and no AI is named as author anywhere in a chapter. Readings keep their label `[AI reading, Dn]`. A quotation of a source appears only where its wording is what is studied (for example, a classical sentence, or a coined term such as 生生), with its source linked; a quotation is never the warrant for a claim.
- **Endings.** Every chapter ends with "What this chapter does not show" and "Open", each a short list.
- **Links.** Repository-relative. Records: `../results/records/<id>.md`. Lean modules: the package path `../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/<Module>.lean`. Other chapters: `0N-NAME.md#anchor`. Sections carry English anchors (`<a id="continuation"></a>`) besides the record anchors.
- **Language.** 01–05, 07 and 08 in English; 06 in Chinese. Chinese editions of the overview and one page come later.

## 7. What a drafter does, and returns

1. Read this spine, the chapter's dossier (`dossiers/<region>.json`: items with summaries, sources, status and records), its rows of `chapter-records.tsv`, and the source text the dossier cites (the canonical chapter, the overlapping chapters, the records' `.md` pages, the Lean modules).
2. For every claim, check the record's statement, hypotheses and `does_not_show`, and the Lean declaration it names: the name exists in that module, the hypotheses in the sentence are the declaration's. Never change what a result says; where a record and the Lean disagree, report it.
3. Write the chapter at its path. No new results, no new Lean.
4. Return a report: records given a home (ids), records proposed for another chapter (id, chapter, why), defects found (record vs Lean, stale wording, a claim stronger than its proof), and what the chapter could not state well.

## 8. What the restructure leaves for later

- **Lifting.** Each law proved on the World or on processes is restated on the grammar by a lifting theorem (the continuation family's instances are the pattern). The graph lists the modules not yet on the root.
- **The Lean path** moves to a short path in one separate step.
- **The review packet** (one page, three reader dossiers, a sampled re-coding of the classification) is generated from the structure.
