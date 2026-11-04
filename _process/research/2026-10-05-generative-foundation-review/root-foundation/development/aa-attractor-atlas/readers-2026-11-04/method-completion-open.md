<!-- AI-written: one of seven read-only readers, 4 November 2026, for the atlas plan. Kept as evidence for PLAN.md; not checked line by line. -->

# 08-METHOD, completion criterion and next_delta: a reader's report for the attractor atlas

## Coverage: what I did

| Source | How covered |
|---|---|
| `theories/becoming/chapters/08-METHOD.md` (804 lines) | Read in full, in chunks (1–170, 170–380, 380–480, 480–580, 580–805) |
| `theories/becoming/results/completion/COMPLETION.md` | Read in full |
| `COVERAGE.json` | Parsed its shape with python: every top-level key, its `about` text, rows, premises, enclosure, ethics_chain, unity |
| `tools/research/completion.py` | Read `validate`, `k1`–`k7`, `exchange_forms`, `reaches` (lines 234–548) |
| `OPEN-QUESTIONS.md` | Skimmed: headings, the four open targets, the programme links |
| AGENTS.md "What moves it" and "Method" | Read (they were already in context) |
| Records (533 JSON) | Counted `next_delta` with python; grouped by `status`, `kind`, `family` and home chapter (matched each record to the chapter holding its `id="r-<id>"` anchor) |
| Spot checks | ONE-PAGE (standings column), 05 T3 home, DELEGATED-CHOICES table, REVIEWS.md ledger |

What I did not cover: the chapters other than 08, apart from the spot checks above; the record pages' text; the Lean itself. Nothing was run except read-only python and grep.

---

## Flags (false, stale or contradictory), most belief-changing first

| # | Where | What | Other location |
|---|---|---|---|
| F1 | 08 §9 T3 row, line 570, "Forbids" | The 08 copy drops qualifiers from the home's wording. 08 says "a system nearer its optimum leaving a room-giving condition beyond its couplings higher" and "a drive on a choice…". The home says "a system nearer its reward's optimum leaving a room-giving condition … higher, **on average**, than one further from it" and "a **systematic** drive", with "**eligible** outcomes". The gloss makes the forbidden case stronger. | Home: 05-COLLECTIVES.md line 228 (`#t3`). ONE-PAGE line 19 keeps "on average". |
| F2 | 08 §7, lines 429–437 | The shared-law counts are stale against COMPLETION.md, which was generated at the same core receipt `20261103T211917.845905Z`. 08 gives closure 41 and balance 55 in its table, and "86 rest on at least one … the other 40". 08 contradicts itself: the table says balance 55, but its text says "16 of 54 on balance". | COMPLETION.md `#shared-laws`: closure 42, balance 54, "87 of 126", "Resting on no shared law (39)" |
| F3 | 08 §4, line 167 | The K4 counts are stale: 08 has "natural-number amounts in 74 … a fixed type of formations in 9". | COMPLETION.md K4: "natural-number amounts (73) … a fixed type of formations (8)" |
| F4 | 08 §11, line 660 | "Twenty numbered reviews and three others" is stale. The ledger lists the Twenty-first review (29 Oct, an AI review), and 08 §8 (line 559) cites it. | `_process/…/root-foundation/REVIEWS.md` line 17 |
| F5 | 08 §12 "Readings adopted", line 745 | "numbered D1–D66" is stale. The register has D67 and D68, which are used at 02-MAP line 440 and 07 lines 671–677. The register's own summary table skips D66, though D66 exists as a section (line 936, `#d66-the-work-read-by-its-own-laws`). | `DELEGATED-CHOICES.md` lines 105–107 |
| F6 | 08 §12, open item 4, line 725 | The item is classed "further proof", but its text says "*Open:* no formal part; the premises the chain names … are questions of warrant and correspondence". K7 passes it, because K7 only checks that "*Open:*" is present. | `completion.py` k7 |
| F7 | 08's own label rule, §2 line 66 | The rule requires `[AI reading, Dn]`, or `[AI reading, new]` until the register numbers it. 08 uses a bare `[AI reading]` 7 times (lines 515, 516, 526, 528, 529, 730, among others). | Bare labels elsewhere: 05 (4), 06 (3), 07 (7), ONE-PAGE (5) |
| F8 | COMPLETION.md K7 | The report prints "Section 8.1 has 12 items". COVERAGE.json `about` texts say "chapter section 0" and "chapter 8.1". The live locations are 08 §4 (the premise card) and §12 (the open items). The reader-facing generated text is stale. | `completion.py` line 48 comment; line 643 |
| F9 | COVERAGE rows `open_items` | No K1 row maps to open item 1. The rows map items 2–12 only. | COMPLETION.md K1 table |
| F10 | Records | All 7 `superseded` records still carry a non-empty `next_delta`, and 6 of them ask for a review. An atlas must not show these as live next steps. | records with `superseded_by` |
| F11 | 08 §8 third parts, lines 553–559 | "Of the 21 rows the audit read, four have one, three of them distinct", followed by three bullets and then "Price's equation and Fisher's theorem … have one as well". It is unclear whether the evolution row is among the four. | — |
| F12 | 08 §4, line 167 | "the last three tables bear on application, ethics and practice", but two more tables follow (Parameters, Not assumed). This is trivial. | — |

ONE-PAGE and 08 otherwise agreed where I checked: T1's evidence ("failed in four settings" matches 08's list of MQ1, MQ2 C1, MQ3 and MQ6) and the "what survives" verdict. ONE-PAGE's shortening drops 08's third survivor, "one vocabulary".

---

## (a) The standings and bases vocabulary (08 §2, `#standings-and-bases`)

**Labels.** Every result statement opens with exactly one of these (lines 51–68).

| Label | Means (08's words, shortened) |
|---|---|
| **Definition.** | a term is introduced; nothing is claimed |
| **Theorem** (root) | proved on `Becoming.Grammar` or a grammar module, for every carrier, relation and class |
| **Theorem** (the steps) | for every determination of the natural-number steps |
| **Theorem** (any process), (any type) | for every step relation or type; "grammar-level in content, not yet in the grammar's vocabulary" |
| **Theorem** (World) | on the World model, premises and local hypotheses named |
| **Theorem** (a named model) | e.g. (the Changes) for `Becoming.Hexagrams`; "(the Changes, by computation)" = an example, not a law of every world |
| **Theorem** (periphery) | with Mathlib or axioms, which are reported |
| **Theorem** (…; witness) | a constructed example, labelled as one |
| **Conditional.** | holds under the continuation condition, C or a practical commitment; every premise named |
| **Calibration.** | needs an omniscience principle and says what the need says about the unfolding; one about the logic alone is a lemma |
| **Thesis.** (chapter opening) | its standing is that of the results it summarizes |
| **Thesis T*n*.** | an empirical claim, with its standing, what it forbids and the evidence so far |
| **Thesis** (philosophical) | argued, with what it forbids and what would refute it; no Lean |
| **Reading** [AI reading, D*n*] / [AI reading, new] | an interpretation of checked content; changes no theorem |
| **Assessment.** | a scoped evaluation with evidence and no Lean |
| **Open.** | not shown; says what would show it |

**Bases** (08 §2 "base" row, line 115): root, the steps, any process, any type, World, periphery, a named model. "The old base" means the World model.

**Other standing vocabularies the atlas must keep distinct:**
- **Thesis standings** (§9, line 564): "proved under named premises, supported by frozen tests, conjectured, argued". Strength (what a claim forbids) is kept apart from standing.
- **COVERAGE statuses:** `proved` / `prose` / `open`.
- **Record status:** recorded-checked 502, reviewed-scoped 20, superseded 7, open 4.
- **Record kind:** theorem 509, assessment 15, argument 5, target 4.
- **Edge standings** (§7 `#r-one-root-to-its-edge`): derived (11); under a stated hypothesis (1); counting (6); named distance (99), which divides into connected 22, balance in the statement 32, on amounts 18, at a represented model 16, own carrier 6, laws of their models 2, keeping significance free 3. "None is a premise."
- **§8 verdicts:** near-definitional, restated, restated constructively, restated over whole amounts, restated in counts, "new as an artefact", "a clarification".
- **Third parts:** yes, weak, none.
- **Premise card standings:** "application obligation", "a disclosed choice", "stated, not asserted", "characterized with no premise", "substantive", "revisable; neither theorem nor axiom", "proposed by the AI".
- **Limits** (AGENTS "Method"): "either proved, standing within its hypotheses, or holds so far, dated, with its reason, and lapses when its reason does".

**Four layers** (`#four-layers`):
- I. With no premise.
- II. What each premise adds, on the World: 8 independent premises and 256 choices (`World.counting_under`).
- III. Where the dynamics stop deciding (`Web.significance_undetermined`).
- IV. Evaluation: the condition fixes scope and ranks nothing; C gives order, "in general alone".

---

## (b) Premise card (08 §4, `#premise-card`) and where each holds and fails

**Commitments of the representation.** The axiom report does not check these. Their costs are measured only in the periphery (`Representation.*`).

| Commitment | Lean | Note |
|---|---|---|
| Discrete steps, one shared index | `World`, `Web`, `Flow` | read off own courses only where every exchange touches a relatum and every two share one, otherwise a choice of interleaving |
| Natural-number amounts | `Web.level`, `Flow.take`, `Flow.give` | the joint-excess laws rest on the unit bound `Flow.excess_bounded_at`; over any amounts only `Amounts.losses_within`; `Halving.no_least_loss` |
| Finite presence at each step | `Flow.present` | — |
| Prop-valued activity | `Web.active` | — |
| One kind of relatum | `World.ofRoles` | — |
| Naming of relata | `relabel` | — |
| Requirements as thresholds | `Web.requires`, `Web.need`, `Web.Supported` | — |
| Identity by naming | `Becoming.Identity` | — |
| Pointwise statements | `Pointwise` | — |
| Context-free claims | `Becoming.Context` | not met by Specker's boxes or the Mermin–Peres square |

**Local hypotheses:** Finite (`World.Finite`); Enclosed (`Flow.Enclosed`, `Flow.Around`); Listed (`Listed`, `Web.Census`, `Distinct`); Decided (`Becoming.Decidedness`, `Becoming.Listing`).

**World premises.** "The eight are independent, each failed by a world meeting the other seven" (`World.independent`). Read off one exchange (`World.withRest`), the four tying premises hold by the reading (`ExchangeLaw.readWorld_glue`). The census holds where a named family closes each step, and in every finite world. Dissipation, embodiment and bounded transmission are "states of the law" (`ExchangeLaw.contingent`).

| Premise | Lean | K3 witnesses (COVERAGE) |
|---|---|---|
| Activity needing support | `World.Dependent` | `World.contingent`, `World.independent` |
| Balance | `World.Balanced` | same |
| Only active give | `World.Acting` | same |
| Only active take | `World.Taking` | same |
| Dissipation | `World.Dissipative` | same |
| Embodiment | `World.Embodied` | same |
| A census | `World.Counted` | same |
| Bounded transmission | `World.Transmitting` | `World.independent` |
| (a reserve) | — | `World.contingent` |
| (finite) | — | meets `World.strained_finite`; fails `World.throughput_world` |
| (enclosed) | — | `World.exposed_world`, `Flow.enclosed_of_finite` |
| (decided, logical) | — | meets `Decided.exists_below`; unrefuted `not_not_decided`; calibration `HistoryIdeals.cut_decided_iff_lpo` |
| (a supplied law of exchange) | — | `ExchangeLaw.contingent` |

**Dynamics and correspondence.** "An application obligation is a premise of no theorem."
- Process (`Generative.Process`): a view.
- Observables (`Frame.realized`, `Conditions`), Formation (no Lean) and Connection (`Valuation.Connected`): application obligations.
- Readings of `living`: a disclosed choice; "none reads 生生 [AI reading, D1]".
- Held (`Valuation.Held`): [AI reading, D11].

**Ethics, none asserted.**

| Premise | Lean | Standing | Met / failed |
|---|---|---|---|
| Continuation condition | `Unrestricted` | "stated, not asserted; fixes scope, orders nothing; C does not follow" | K3: `Flow.feeding_unrestricted_of_common`, `bounded_rival`. Its root form varies with the net (`«续无外随网»`, `«族无外随网»`, `«逆缘续无外随网»`). Free form not entailed by the dynamics: `ReadsOnlyDynamics.not_entails` |
| Living significance | `LivingSignificance` | characterized with no premise | `Web.significance_undetermined`, `Apart.not_enough` |
| Self-significance | `SelfSignificance` | [AI reading, D11] | — |
| Relational and standpoint neutrality | `transmits`, `shares` | follow from the condition | — |
| A (articulation) | `articulates` | [AI reading, D16] | — |

**Practice.**

| Premise | Lean | Standing | Met / failed |
|---|---|---|---|
| C | `Comparison` | "gives order, in general alone … warrant open" | meets `Web.paths_comparison_widens` (consistency only); `Regimes.no_comparison_through_marginals`; `ReadsNoOrder.not_entails` |
| L | `LiftBetter` | substantive | `LiftModel.met_and_failed`, `LiftModel.some_outcome_does_not_lift` |
| J1–J4 | `Lexical.BasicPriority`, `Requirement.Frontier` | proposed by the AI; choosing at every step needs weak excluded middle | J2 not from C: `ScoreRepresentation.comparison_does_not_yield_priority` (§7 table). No K3 witness pair |
| FR | `Becoming.LossMatching` | revisable | none listed |

BC1, BC2, LC, LR, CP and NP have their home in 07. None has a K3 witness.

**Supplied parameters** (K5): significance (`Unrestricted`); standpoints and own regions (`Valuation.Held`); observation (`Frame.realized`); the naming (`relabel`); the rest relatum (`World.withRest`); a valuation (`Conditions.valuation`); a law of exchange (`ExchangeLaw.readWorld_glue`).

---

## (c) Calibrations (08 §5, table at lines 321–331)

| Principle | What needing it says | Where |
|---|---|---|
| Decidedness (local) | a count or named step exists only where its object is decided | counts; over every run it is LPO (`HistoryIdeals.cut_decided_iff_lpo`) |
| Markov | passing from what a finite stretch verifies to a refutable complement | 03 `#r-what-a-finite-stretch-verifies` |
| LLPO | choosing a side of a fork finite stages cannot settle | run construction (`Lasting.step_iff_either`, `eitherThroughout_iff_llpoForDecided`) |
| WLPO | a law of the whole and no part | the tail (`changedByNoCondition_iff_rule` etc.; rule form only) |
| LPO | telling whether a history ends = deciding whether it changes again | `LastChange.lpo_iff_settles`, `Settling.OneWay.lpo_of_settles` |
| Weak excluded middle | no move need be known to be chosen where betterness is open | `exists_undominated_iff_weakly`, `FrontierFrames.choice_exists_iff_weakly` |
| Double-negation elimination | a refutable reading holding where adhered to; reach without a path | `refutable_holds_iff`, `fromSeed_of_not_separated_iff_dne` |
| Excluded middle | names carry one decided identity more than relations; the four marks on every line | `World.indiscernible_decided_iff_em`; `World.law_iff_em` is a lemma, not a calibration |
| Dependent choice | an infinite course choosing each next step | `runs_iff_dependentChoice` |

Not checked here: that WLPO does not give LPO (cited from Akama et al. 2004); whether WLPO as a proposition gives the rule.

---

## (d) Known results verdict table (08 §8, `#known-results`, "as of 3 November 2026")

The review's 12 ranked rows less the folded rank 2, plus 2 evolution rows, make 13. "None of the central results is new mathematics." Each gap is "a limit that holds so far and lapses when the account states the result".

| Central result | Verdict | What the prior result states that the account does not yet |
|---|---|---|
| Coming and ceasing keep pace | near-definitional | vital rates, Lotka renewal/stable age; Little's law (finite form only proposed); Foata normal form, infinite traces; Zielonka's theorem |
| Recurrence / attraction | restated, without decidable equality | measure-theoretic Poincaré recurrence, Kac; Landauer in energy kT ln 2 (count only); Bennett's uncomputation |
| Premises carve parts | new as an artefact | realizability/Kripke separations (WLPO⊬LPO cited, not checked; LLPO⊬WLPO; Markov ⟂ LLPO); complete independence (Moore 1910): only one-left-out |
| Rest needs a least loss | restated | converse ranking (classical, open); converse Lyapunov; continuous-time stability, rates, LaSalle; chip-firing order-independence and thresholds |
| How two courses differ | near-definitional | Pattanaik–Xu axioms forcing ranking by number; diversity rankings (Weitzman; Nehring–Puppe) |
| Closures and selection | restated (ZH-M Thm 1 on ℕ amounts, discrete analogue of Thm 2 at optima) | Blackwell over noisy experiments; do-calculus, identification; ZH-M continuous setting and the gain from a re-read proxy |
| Joint excess, position | near-definitional | interior commons equilibrium (Gordon; Dasgupta–Heal), only the corner here; folk theorems (every horizon finite here); Frank's positional race |
| Learning and identification | restated constructively | Gold's theorem; Angluin's tell-tales; Kelly's converse (credited, not shown); Moore's initial-state limit |
| Significance not in the dynamics | near-definitional; scope apart from order a clarification | Schurz's Hume's law, Prior's counterexamples; Parfit's mere addition, Repugnant Conclusion, non-identity |
| Loops | restated over whole amounts | Perron–Frobenius rate and proportions (not shown to be the Perron root); Maruyama loop signs; Thomas's rules |
| Fed from beyond, entropy, nets | restated; nets not independent evidence | Prigogine's minimum entropy production, bifurcation; free-choice liveness by siphons and traps (only one-place siphons here); structural boundedness; coverability and reachability decided |
| Evolution on descent, offspring bound, Hamilton, groups | restated in counts; third part = the Malthusian bound | Fisher under inexact transmission with environment; normal-equation solution; Hamilton with synergy and changing assortment; group reproduction with migration |
| Drift, fixation, mutation, critical mass | restated as finite weighted bounds | Kimura's fixation with selection, neutral substitution rate; drift time scales (1−1/N, order N); Eigen's threshold, quasispecies; stochastic stability, one-third rule |

**What survives** (lines 544–548): the premise ledger with witnesses and calibrations; the ethics with scope and order apart; one vocabulary. "None of them a discovery."

**Third parts.** These are weak or yes:
- closing needs a net draw;
- joint excess under the gate;
- the optimum laws;
- Price and Fisher joined to the flow.

Drift, fixation and mutation have none. The FEP has five third parts, two of them weak. "Does not yet reach farther than the sciences taken together."

**"Beyond the table"** (lines 501–533): 33 bullets, each a near-definitional, restated or witness verdict. This is a rich source of atlas edges to the sciences.

---

## (e) Theses (§9) and unifications

| T | Standing (08 table, compressed) | Forbids (08 copy) |
|---|---|---|
| T1 persistence certifies the joint draw | in the model proved (regime point of no return; World joint excess under the gate); beyond the model conjectured; passed MQ2 held-out yeast, MQ1, CG1; failed MQ1 floor, MQ2 C1, MQ3, MQ6 (3 of 10) | a condition below a need measured in advance returning with nothing given from beyond; a dependent active while its condition stands below its need |
| T2 state = level, recent giving, one lag | conjectured on four frozen fish tests; untested outside fisheries; UE31 decided nothing; UE32 T2 better 42/65, p = 0.025 | fourth variable removing a tenth of the residual variance; the level alone as good at five steps; the lag changing sign |
| T3 optimization drains beyond couplings, with room | the law for optima proved; trained-system clause conjectured, partial support | see F1 |
| T4 scope installable, carries | IN1 partly passed; transfer untested | — |
| T5 order shared by positive valuers | reduction proved under net weightings; bound conjectured | — |
| T6 a break seen only through couplings | invisible half proved (World); seen half proved in the periphery; "only where" conjectured | — |
| T7 a measure read from what it selects outlives its refutation | in the model proved (no noise); actual metrics conjectured; LA2 | — |
| T8 生生 as the direction | argued; open: P2, P4 of 07 §4.6, the step beyond, a reason for C | — |

**Philosophical theses** (not T1–T8):
- *One relational unfolding* (`#one-relational-unfolding`): "argued, not proved"; "by this section's measure the thesis has no strength".
- *The explanatory reading* (`#what-would-defeat-the-reading`): as a language it forbids nothing; against its strongest rival, "a tie".

**Unifications** (`#what-the-unifications-claim`, lines 580–585). Each is claimed as one law across fields that state it apart.

| Known in substance | Claimed beyond the source field | Standing |
|---|---|---|
| supervisory control | reward, training, natural selection, prices and votes as one selection through couplings | laws proved; one law across domains conjectured (T3) |
| Pareto unanimity, opportunity sets | C as the whole of the order | reduction proved for net weightings; bound conjectured (T5) |
| Landauer, Bennett | one merge across computation, heat, extinction and forgetting | law proved on finitely many listed configurations; the cross-domain reading a correspondence |
| Zhuang and Hadfield-Menell Thm 1 | overshoot, externality and Goodhart as one law | optimum law proved; across domains conjectured (T3), supported in simulation (MQ1) |

---

## (f) Open items, ranked (08 §12, `#open-items-ranked`)

| # | Item (class) | Landed | Open |
|---|---|---|---|
| 1 | One base, laws over every law of exchange (further proof) | grammar as base; `Frame.world_fixes_run`, `World.of_web`, `World.of_flow`; tying-premise laws over the exchange; `Pair.apart_differs` | lifting World and process laws onto the grammar; item 7; item 6 |
| 2 | One evaluative chain | `Web.paths_one_object`, `Web.unrestricted_iff_grounds_beyond`, `Direction.grounded_widening_selected` (K6) | further generation in a reading of `living`; other readings of "more" |
| 3 | How evaluation forms | `carried_iff_rising`; `Flow.ReachReturns.represented`, `Flow.reachReturns_iff_represented` | returning loop persisting; responses to earlier or several levels |
| 4 | Alignment direction on the spine | `Direction.exchange_direction`, `Requirement.Handover.direction` | "no formal part" (F6) |
| 5 | What widening compares | `Web.grow_widensAlong_iff`, `Web.WidensAcross` | measure for mixed parts; renewal capacity, richness |
| 6 | Amounts that may be dense | `Amounts.rests_of_finite_reading`, `World.InAmounts.change_stops_iff`; K4 | least loss in energy from the pure core (needs count as energy plus irreversibility); constructive rest; other laws over any amounts; damped-law gap |
| 7 | Which law holds | `Flow.withinCoupling_reads_iff`, `Web.anticipates_iff`, `Training.installed_where_lumped`, `Training.response_free_where_unlumped` | the law of exchange itself; actual lumping, read empirically; closing vs widening beyond one loop; probabilistic learning |
| 8 | Identity from continuity | `World.fixed_iff`, `World.continues_as_alike`, `Becoming.ContinuedClasses` | continuations from informational or organizational relations |
| 9 | Evolution's selection term | Price, Hamilton for groups founded mixed, drift, fixation, mutation, breeding values, fate laws, relay vs run-down | dependence on what the giver drew; drift with selection; two-way mutation with drift; migration, assortment, synergy, unequal sizes; multi-founder wholes; rational amounts; normal equations |
| 10 | What a rise draws from beyond | `Becoming.DrawnBeyond`, `Becoming.JointDraw`, `Optimum.mutual_as_one`, `Becoming.Optimum` | worth of what is left; unreachable greatest gain; drawers ranking courses; perfect profiles; takes outside mutual best response; outside replenishment |
| 11 | Practical premises under the condition | `Ranking.restraint_extends_iff` (+ stepwise, relational); `Ranking.basic_first_ranks` | the form of L under the condition |
| 12 | Warrant (philosophical warrant) | step reduced to de se; C to monotonicity (`Weighting.widens_iff_every_of_class`); 07 §4.5–4.6 | P2, P4; the step beyond; a reason for C; a stronger practical warrant |

The goal targets map onto items 1, 12 and 7 (line 735). OPEN-QUESTIONS lists the same 4 targets as the 4 `open` records.

---

## (g) The completion criterion: how K1–K7 work, and K8/K9 in the same style

**The pattern.** Each K has three parts:
- a data block in `COVERAGE.json` with an `about` text;
- a function `kN` in `completion.py` returning findings;
- "met" means no finding.

`validate()` checks the data's structure first:
- every declaration is in the core receipt;
- every record exists;
- the axis counts are exactly 5 phase, 6 differentiation and 6 domain rows.

Every check reads Lean source text, not elaborated terms. 08 says so (line 698): "completion in a qualified sense".

| K | Checks | How |
|---|---|---|
| K1 Coverage | 17 rows (126 entries, 117 distinct; 9 in two rows); each declaration in the core or foundation ring, not "apart", and the row `proved` | layer and connectivity class |
| K2 Unity | every central declaration in the main component and on a base family, or with a listed instance reaching it; family-reach directions met by definition (World→Process) or by construction (`Frame.world_fixes_run`, `World.of_web`, `World.of_flow`) | connectivity JSON, `reaches()` through proof references |
| K3 Premises | each premise found by regex in a central statement has witnesses that meet and fail it (logical: meets, unrefuted, calibration); each of the 33 statements taking a tying premise has an `exchange_forms` entry whose binders take none and whose proof reaches it | regex on binders, `reaches()` |
| K4 Representation | tags modelling choices by regex; each listed natural-number law (7) has a `form` or a `counterexample` | presence only |
| K5 Enclosure | each listed parameter's Lean name appears in the "Premise card" section | substring in 08 |
| K6 Ethics chain | the last of 9 steps (`Direction.grounded_widening_selected`) reaches every earlier one; the normative hypotheses used are named | `reaches()` |
| K7 Open register | items under "Open items, ranked" numbered 1..n, one class from {further proof, philosophical warrant, empirical}, distinct titles, "*Open:*" present (except warrant); coverage's open_items exist | regex on 08 |

**Proposed K8, atlas coverage.** Add an `atlas` block in COVERAGE.json, or an `atlas.json` that completion.py reads. Its findings:
1. a central declaration (117), thesis (T1–T8 plus the two philosophical theses), premise-card entry, open item (1–12), §8 row (13), §9 unification (4) or the shared laws (5) with no atlas node;
2. an atlas node whose standing differs from its home's §2 label, or from the record's `status` and `kind`;
3. an atlas node with a base not among the 7 bases;
4. a correspondence edge with no §8 row, beyond-the-table bullet or record behind it;
5. an open item mapped by no node. Item 1 would be a finding today (F9);
6. a superseded record shown as live (F10).

**Proposed K9, every limit dated or proved.** Each limit is one of:
- a `does_not_show` item;
- a cell in §8's last column;
- a "not yet" or "Open" line.

Each must carry either (a) `proved_by`, a declaration with its hypotheses (an impossibility, a countermodel or a not-entails theorem), or (b) `since` (a date), `reason` and `lapses_when`. Findings: a limit with neither. Baseline: 531 records have `does_not_show`, and only 35 mention a year. So K9 needs a schema field, not a regex, or it will start with about 500 findings. 08 itself has 11 "not yet", 7 "so far", 7 "not shown" and 29 "cannot".

---

## (h) next_delta counts

`next_delta` is a dict `{en, zh}` in all 533 records.

| Measure | Count |
|---|---|
| Non-empty `en` | **533 / 533** (all `zh` too) |
| Exactly "An independent review." | 38 |
| Mentioning review or "by a person" | 264 |
| Proof-type keywords (prove, lift, periphery, dense, real, rational, continuous, stochastic, Lean, theorem, derive…) | 127 |
| Empirical keywords (test, frozen, data, experiment, measur, field) | 97 |
| Length in characters (min / median / max) | 22 / 175 / 400 |

The keyword classes overlap and are regex-based. They are a rough guide, not a classification.

**By home chapter** (`id="r-<id>"` anchor):

| Home | n | review | review-only | proof-type | empirical |
|---|---|---|---|---|---|
| 01 | 86 | 32 | 4 | 30 | 8 |
| 02 | 94 | 61 | 13 | 30 | 23 |
| 03 | 110 | 42 | 1 | 27 | 34 |
| 04 | 46 | 23 | 4 | 9 | 4 |
| 05 | 72 | 49 | 9 | 11 | 8 |
| 06 | 16 | 10 | 3 | 4 | 5 |
| 07 | 81 | 34 | 3 | 11 | 14 |
| 08 | 21 | 7 | 1 | 5 | 1 |
| no anchor (the 7 superseded) | 7 | 6 | 0 | 0 | 0 |

**By `family`:** F01 329, F07 54, F04 49, F11 26, F09 14, F22 14, F02 11, F10 10, F05 7, F06 7, F08 5, F03 4, F29 2, F13 1. Per RESULT-WORKFLOW line 69, this field is the "session-map family", not the law families. There are 5 law families, in `results/data/law-families.json`. I found no labels for the F-codes.

Non-recorded-checked by home:
- reviewed-scoped: 03 (6), 07 (5), 06 (5), 05 (2), 04 (1), 08 (1);
- open: 03 (2), 07 (1), 08 (1).