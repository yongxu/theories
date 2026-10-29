# Reader B: formal representability and fidelity to the Lean (Claude Opus 5.5)

Part of the [twenty-first review](../BECOMING-TWENTY-FIRST-REVIEW.md); an AI report, read-only, kept as evidence. Its claims were checked by the cross-checker ([H](H-CROSS-CHECK.md)) and, where the review leans on them, by the synthesizing reviewer.

## Verdict
Formally, the theory is in good shape, and the prose follows the Lean closely. I picked thirteen central results, the one page's bolded laws and the ethics' four statements, and found each in its chapter's home section and its Lean declaration. In every chapter statement the hypotheses, quantifiers and scope match the Lean. The near-definitional cases are labelled honestly, both in the prose and in the Lean docstrings: selection through couplings "states what the definition builds in", and C on level paths "holds by definition". None of the mismatches I found is in a chapter's home statement. They are in the hand-written front pages (ONE-PAGE.md in English and Chinese, and the overview's §10), which have fallen behind the work, and in one stale periphery receipt.

The pure-core discipline is real. I stripped comments from every file in Becoming/*.lean and scanned the code: no sorry, admit, axiom, Classical, native_decide, unsafe, opaque, propext, funext or Quot.sound. "axiom" and "Classical" appear only in docstrings. Excluded middle appears only as a named hypothesis. check_becoming.py enforces this four ways: an import-closure assertion, `#print axioms` on every declaration, an audit of every compiled constant with `collectAxioms`, and a recompile from the prelude alone. At receipt 20261029T081505.616437Z: 340 modules, 16,633 theorems and 22,697 declarations audited, no axiom in any module record, and every source hash matching the current bytes. Two limits:
- The receipt depends on reuse: 1,349 of 1,360 Lean steps were reused from ~/.cache/becoming-lean, outside the repository, so an outsider has to rerun the check fresh to confirm it.
- The periphery module FallibleInquiry, which 03 cites as a theorem, has a receipt from 20 October. 19 of the 38 files it depends on have changed since.

What the grammar can represent:
- **WRT2 landed while I was reviewing (8882b7995).** The World's relational part is now represented both ways. Its amounts are not: two worlds at different positive standings give the same model (`World.standingAt_alike`). Balance is carried only by the conservation step, which is defined from the balance equation (`World.balance_needs_conservation`). That a line of falls ends is a condition of the World's image, not a law of the grammar.
- **Processes and the other models** have no representation theorem of their own yet.
- **Most model laws are not grammar laws.** OU3f found that 27 of the 436 theorems that read only activity are cases of a grammar law today. 400 are laws of their models; 141 of those are witnesses.

Not representable yet:
- amounts of any kind in the grammar;
- real amounts and continuous time (periphery only);
- probability beyond natural weights: conditioning, Bayes and surprisal order have counting forms, but entropy and free energy have none;
- quantum states beyond integer-matrix witnesses of contextuality;
- conditions that change themselves with no fixed scheme, and presence in time.

The grammar is less spare than "one kind of symbol" suggests. In Lean it quantifies over predicates (`«所闭»`, `«入»`, `«生成»`) and uses lists (`«对»`), natural-number iteration (`«迭»`) and maps (`«像»`). Without excluded middle it has no union. So the comparison with a pure relational calculus (as strong as three-variable first-order logic) does not bound it, and mutual interpretation with Lean is open (08 §6).

Stale or overstated on the front pages:
- **Grammar count.** "28 of the 127 … reach the grammar", against 08 §7's 44.
- **Record count.** "419 recorded results", against 481 JSON records, 450 of them recorded-checked.
- **Test systems.** "have no models yet", though 01 §8.7 gives small witnesses, decay among them.
- **"In a finite world a law that merges nothing brings every state back."** The Lean needs a deterministic law and finitely many configurations, which is not the World's `World.Finite`.
- **"A knower is part of what it knows."** This is the model's framing, bolded as a law.
- **"Evolution's classical laws hold."** The chapter claims several laws in counting form, under exact transmission and equal group sizes.

Modelling commitments are mostly stated where laws depend on them. Two are missing: finite presence at each step (`Flow.present : Nat → List F`) is in neither commitments table, and some laws, joint excess among them, get their force from the least unit without saying so.

## Shape
| Layer | Represented how | Both ways? | Fails or missing |
|---|---|---|---|
| Grammar (root) | relations on any carrier, in Lean's HOL (predicates, List, Nat, maps) | n/a | no amounts; no union constructively; no presence in time; no self-changing conditions without a scheme |
| World, relational part | occurrence model: same-step class, conservation step, partial identities, 5 within-step relations | yes (WRT2, landed 8882b7995) | forward is a schema, not one theorem |
| World, amounts | only via relations they induce | no | standings forgotten (standingAt_alike); balance only through the conservation step; falls end is an image condition |
| Balance | unit pairing «对» | per notion, near-definitional | not derived |
| Widening / closure / return / lumping | grammar terms | per notion | — |
| Passing, split/merge, 火传, dormancy | grammar reading | one way | — |
| Processes and other models | per-notion instances | no per-model theorem | open |
| Activity-only theorems (436) | 27 grammar cases, 9 after B1/B2 | — | 400 model laws (OU3f; in flight) |
| Probability | natural weights: Bayes, LLN, Chebyshev/Chernoff, surprisal order | core counting form | entropy and free energy: none in core; FE periphery draft, no receipt |
| Real amounts, continuous time | periphery over reals (Representation, Drawn.converges) | — | not in core |
| Quantum | integer-matrix KS square; supplied two-qubit fragment | — | no Hilbert space, Born rule or dynamics |
| Ethics | sig a free parameter; own-closure reading on root (`ownClosure_unrestricted_iff_noOutside`) | the reading only | free sig not lifted |

Fidelity of the 13 chapter statements checked: 13 of 13 exact. One-page: 3 bolded laws overstated, 3 stale facts. Pure core: 0 axioms, 0 sorry; receipt current; 1 periphery receipt stale.

## Answers
### What can be represented in the grammar, and how? Which models both ways, which one way, and what does the World's representation state and fail on?
Two senses of 'both ways' are in use (WRT DESIGN §1.1).

Per notion (sense i), notions read as equivalent to their grammar terms:
- the continuation family's instance theorems (arising/ceasing as «生»/«亡», lineage, holding, carrying renewal);
- closure, by definition;
- a process's return (`Branching.returns_iff_reaches`);
- widening (`Web.widens_iff`);
- going alike (`goAlikeUnder_iff_alike`);
- balance, near-definitionally (`Flow.balances_iff_units`).

One way only: passing/alteration (`passesAt_of_alters`, `alters_of_passes`), the split and merge shapes, 火传, dormancy (WRT DESIGN §2 table).

Per model (sense ii), only the World. WRT2 landed during this review (commit 8882b7995; record the-world-represented-both-ways; 01 §8.6 r-the-world-represented-both-ways):
- Forward: a schema discharged notion by notion; re-identifications are one-to-one correspondences of the name-free part (`World.reidentify_carries`); recurrence is stated through the names' step (`World.arisingRecurs_iff`).
- Converse: any activity, requiring, drawing and presence is some world's (`World.ofModel_model`); conservation is exactly a relation of its form, half by definition (`World.conserves_form`, `World.ofConservationForm_conserves`).

Where it fails, all on amounts:
- standings are not determined (`World.standingAt_alike`);
- balance is carried only by the conservation step, which is defined from the balance equation (`World.balance_needs_conservation`);
- conservation is never identity on predicates of Nat (`World.not_conserves_identity`);
- a line of falls ends (`World.falls_exhaust`), a condition of the image and no law of the grammar (`Steps.along_endless`).

Not yet: a per-model representation of processes and the other models (01 §8.6 'What is not shown'). Most modules are still on their models: of the 436 theorems that read only activity, 27 are grammar cases today, 9 more once B1/B2 land, and 400 are laws of their models (OU3f AUDIT.md Summary). OU3f's derivations are in flight. The free significance parameter is not lifted onto the root; only the own-closure reading is (07 §4.5).

Evidence: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/world-representation/DESIGN.md §1.1, §1.5, §2, §3 (F1, F1′, F2, F3); theories/becoming/chapters/01-ROOT.md#r-the-world-represented-both-ways (Forward / Converse / Where it fails / What is not shown); experiments/.../lean/becoming/Becoming/WorldRepresentation.lean: standingAt_alike (l.437), balance_needs_conservation (l.482), not_conserves_identity (l.517), falls_exhaust (l.526), Steps.along_endless (l.561), ofModel_model (l.342); git log: 8882b7995 'WRT2 landed …', core receipt 20261029T081505.616437Z; _process/.../development/ou3f-activity-laws/AUDIT.md ## Summary and ## (c) Laws of their models

### What can the theory not represent at all yet (continuous time, probability/surprisal, real amounts, quantum states)?
Amounts: the grammar has none (01 §8.6 reading; WRT F1). The core has dense forms of the rest theorem over any ordered amounts (`Becoming.Amounts`, `Becoming.InAmounts`). Real amounts appear only in the periphery: `Representation`, `Drawn.converges`, EntropyProduction.

Continuous time: discrete Nat steps only. A real-time course and its sampling exist only in the periphery (`Representation.Course.sample_balances`, 08 §4 'What the commitments cost'). The UE1 note §3 lists it as a debt.

Probability: natural weights over listed courses. These cover Chebyshev, Chernoff and the counting law of large numbers (Typicality), plus conditioning by restriction and Bayes as a ratio identity (`ConditionalWeights.restrict_two_ways`). Surprisal is represented only as an order, by the reciprocal share (`ConditionalWeights.Share.le_iff_reciprocal`). 03 says entropy and free energy, being averages of logarithms, 'have no counting form here'. Free energy and its variational bound are drafted for the periphery with no receipt (UE PLAN item 3; UE1 NOTE-CORRECTIONS §1).

Quantum: Kochen–Specker for two qubits as explicit integer 4×4 matrices checked by evaluation (Quantum.lean), and a supplied two-qubit fragment (01 r-joint-correlation-reduced-dynamics). There is no Hilbert space, Born rule or general unitary dynamics; 'Quantum probability … comes last' (UE PLAN item 8).

Thermodynamics enters only by stated correspondence in the periphery over the reals (01 r-balance-from-the-first-law; 02 r-least-loss-from-entropy-production). In the core, 'entropy' names a record, which is a reading.

Two things the grammar cannot state at all: self-changing conditions with no fixed scheme, and presence in time (overview §10; UE PLAN §5). On causal-set growth and on reorderings, presence is a choice of course. The grammar also has no union of partial identities and no counting (OU3f (c)).

Evidence: _process/.../development/ue1-fep-bridge/NOTE.md §3 table (rows 1 and 4) and §6; _process/.../development/ue1-fep-bridge/NOTE-CORRECTIONS.md §1; _process/.../development/ue-unified-explanation/PLAN.md items 3, 8 and §5; theories/becoming/chapters/03-KNOWING.md#r-conditioning-by-restriction and the following Reading [D45]; theories/becoming/chapters/08-METHOD.md#r-what-discrete-steps-and-whole-amounts-represent; experiments/.../Becoming/Quantum.lean header; theories/becoming/THE-THEORY-OF-BECOMING.md §10 'Particular laws'

### Fidelity spot-check: do the central results' prose statements match their Lean declarations?
Chapter statements: exact in all 13 cases checked.

(1) Coming and ceasing keep pace. 01 r-coming-and-ceasing-keep-pace ↔ `coming_recurs_iff` (Change.lean:482): a list, `p` with decidable instances, recurrence as `∀ N, ∃ t a, N ≤ t ∧ a ∈ as ∧ e a t`.

(2) Recurrence. 01 r-recurrence-without-premise ↔ `Law.lossless_iff_returns`, `Law.returns_iff_keeps`, `Law.withHistory_unlisted`, `Law.present_forgets` (Recurrence.lean:689/697/798/806). The hypotheses are a deterministic `next : S → S` and a list holding every configuration.

(3) Joint excess. 05 r-own-count-misses-joint-excess ↔ `Flow.joint_excess_ends` (Continuation.lean:542) with the gate as a hypothesis, plus the `Exceeding` witness (`own_not_joint`, `all_end`): each taker within what is given, the renewer and both takers end.

(4) Point of no return. 02 r-margin-of-a-regime ↔ `RegimeMargin.ends_iff_below` (RegimeMargin.lean:739); the hypotheses pos, Short, FromNothing, Meets, Keeps and x ≤ hi all appear in the prose.

(5) Selection. 03 r-selection-through-couplings ↔ `Web.selects_alike_iff` (Selection.lean:191); both say it holds by construction.

(6) Optimum. 05 r-what-an-optimum-does-beyond-what-couples-in ↔ `Optimum.least_iff` (Optimum.lean:561, including the ¬¬), `least_of_room`, `Web.optimum_broken_iff` (l.634).

(7) Price. 04 §3 ↔ `Becoming.price` (Evolution.lean:117), an identity in truncated differences.

(8) Widening. 07 r-four-cases-of-a-part and r-comparison-by-widening ↔ `Web.Includes`/`Exceeds` (Admission.lean:388/392) and `Web.paths_comparison_widens` (Extension.lean:151), declared definitional.

(9) Seed equivalence. 07 r-metaethical-core-characterization ↔ `Valuation.significant_iff` (ValuationFrames.lean:92): Connected, a standpoint and a living claim, Significant ↔ Seed ∧ Neutral transmits ∧ Neutral shares.

(10) The condition on the root. 07 r-the-continuation-condition-on-the-root ↔ `ownClosure_unrestricted_iff_noOutside` and `premises_of_noOutside` (GrammarScope.lean:263/275), scoped to the own-closure reading as stated.

(11) Alignment with no premise. 07 §6 ↔ `DrawnShaping.critical_mass_iff` (l.306) and `drawn_locked_either` (l.374).

(12) Generation and degeneration. 02 r-generation-and-degeneration-at-two-grains ↔ `«生成退化不并»`, `«单行则生守不并»` (GrammarMap.lean:262/283).

(13) Significance undetermined. `Web.significance_undetermined` (Significance.lean:393), stated 'by construction'.

One-page overstatements:
- (a) 'in a finite world a law that merges nothing brings every state back'. 'Finite world' is not World.Finite, and the law must be deterministic.
- (b) 'A knower is part of what it knows' is bolded as a law but is the model's framing.
- (c) 'Evolution's classical laws hold' overstates. The chapter claims several laws in counting form, under exact transmission and equal sizes; Fisher's regression identity and Wright–Fisher with selection are not stated.
- (d) The bold 'renewal drawn past its point of no return by takers none of whom overdraws' joins two results on different models: the gated flow, and the regime with `harms_superadditive`. The joining is faithful.

Premise card: the C row cites `paths_comparison_widens` for 'exactly widening'. The iff is `paths_extension_iff_widens` (with every claim living) or `Weighting.widens_iff_every_of_class`.

Evidence: theories/becoming/ONE-PAGE.md lines 13-19; experiments/.../Becoming/Change.lean:482; Recurrence.lean:689-806; Continuation.lean:542, 642-733; RegimeMargin.lean:739; Selection.lean:191; Optimum.lean:561-634; Evolution.lean:117; Admission.lean:388-392; Extension.lean:151; ValuationFrames.lean:92; GrammarScope.lean:263-275; DrawnShaping.lean:306-374; GrammarMap.lean:262-283; Significance.lean:393; theories/becoming/chapters/04-LIFE.md:3 (Thesis), :154 ('Fisher's identity itself … is not stated'), :284; theories/becoming/chapters/08-METHOD.md#premise-card, Practice table row C

### Are modelling assumptions (discrete steps, natural-number amounts, Prop-valued activity, finiteness) stated where laws depend on them?
Mostly yes.

The statements are systematic:
- Every theorem header names its base: (World), (any process), (root), (periphery; axioms).
- 08 §4 has a commitments table and a local-hypotheses table, and 01 §10 says where each commitment binds.
- K4 counts textual occurrences: discrete steps in 112 central statements, Nat amounts in 74. 08 §4 itself warns this undercounts choices reached through a definition.
- The Lean structures confirm the commitments: `Web := Dependence Nat F C` with `level : … → Nat` and `active : … → Prop`, and `Flow` with `take`/`give : … → Nat` (World.lean:44-63).
- The cost of whole amounts is measured in the periphery (08 r-what-discrete-steps-and-whole-amounts-represent).
- Dense forms of the rest theorem exist (`Becoming.InAmounts`).

Gaps:
- Finite presence at each step (`Flow.present : Nat → List F`) is a representation commitment. It is listed in neither 08 §4's commitments table nor 01 §10; it appears in WRT's 'What the World adds to the grammar'.
- Some World laws get their force from the least unit and do not flag it. Example: joint excess ends after n steps from a level below n + m (05 r-own-count-misses-joint-excess, 'lowers the level by at least one'). With real amounts, a strictly positive but shrinking excess need not end anything. The premise card's natural-number row lists other laws.
- Prop-valued activity and decidedness are handled well: calibrations say what each need means (08 §5; counts-exist-where-decided).

Evidence: theories/becoming/chapters/08-METHOD.md#modelling-commitments and local hypotheses table; §4 opening paragraph (K4 counts); theories/becoming/chapters/01-ROOT.md#modelling-commitments; experiments/.../Becoming/World.lean:44-63 (Dependence, Web, Flow); _process/.../world-representation/DESIGN.md §1.5 'What the World adds to the grammar'; theories/becoming/chapters/05-COLLECTIVES.md#r-own-count-misses-joint-excess

### Pure-core discipline: how is it enforced and receipted, and what does a grep of Becoming/*.lean find?
Enforcement is in check_becoming.py main() (l.3754 on):
- `assert sorted(core_closure) == sorted(PURE)`: an import outside the indexed package fails closure().
- `#print axioms` on every scanned declaration, with `assert name not in SPINE + PURE or not axioms`.
- An environment audit (ENVIRONMENT_AUDIT, l.3315) that runs `Lean.collectAxioms` over every constant of each core module, allowing only `.injEq` lemmas on `propext` that no source declaration names.
- Every Lean run must show no `error:`/`warning:` (this catches 'declaration uses sorry').
- A recompile of the core closure with `import Std` stripped (prelude only).
- Ring direction, superseded modules out of the run, inherited modules matched by sha256, and sources unchanged during the check.

The receipt is 20261029T081505.616437Z, status passed:
- 340 modules (3 foundation, 324 core, 13 ring), 16,633 theorems, 22,697 declarations;
- 231 generated injEq lemmas on propext;
- the union of axiom dependencies over all module records is empty;
- every source_sha256 matches the current bytes (I verified this).

The grep, with comments stripped, over all 337 Becoming/*.lean found 0 each of: sorry, admit, axiom, Classical, native_decide, unsafe, implemented_by, @[extern], opaque, partial def, propext, funext, Quot.sound, Quotient. 'axiom' occurs only in docstrings (e.g. Commuting.lean:54, Tail.lean:76) and 'Classical.' only in a docstring (RuleHandoff.lean:39). Excluded middle appears only as a named hypothesis (e.g. BranchingCorrespondence.lean:40, `em : ∀ p : Prop, Decided p`). The only set_options are resource limits (Coverage.lean, HexagramSequences.lean).

One file in Becoming/ is periphery, not core: FallibleInquiry.lean imports `ScientificInquiryNecessity`. Its own receipt allows propext and Quot.sound and dates from 20261020. 19 of its 38 pinned dependency hashes no longer match.

The receipt is not self-contained: 1,349 of 1,360 Lean steps were reused from ~/.cache/becoming-lean, some first run in scratch trees ('not retained'). Raw logs for reused steps are not in the retained run folder; the parsed per-declaration axiom lists are in the receipt.

Evidence: experiments/.../lean/becoming/check_becoming.py:3315-3332, 3370-3396, 3754-4026; experiments/.../lean/becoming/becoming-verification.json (utc, modules[*].axiom_dependencies, lean_steps.ran=11, reused=1349); experiments/.../lean/becoming/becoming-checks/20261029T081505.616437Z/ (22 files; no GrammarTransport compile or AxiomAudit log); experiments/.../lean/becoming/fallible-inquiry-verification.json (utc 20261020T161546.707477Z; 19 of 38 source_sha256 stale); theories/becoming/chapters/03-KNOWING.md:65 and :334 (periphery theorems citing FallibleInquiry); theories/becoming/chapters/08-METHOD.md#rings (counts match the receipt)

## Strengths
- [proved-core] The pure core has no logical axiom. Every source declaration and every generated constant except 231 injEq lemmas has an empty axiom report, the closure compiles from Lean's prelude alone, and the receipt's hashes match the current sources. — experiments/.../lean/becoming/becoming-verification.json (20261029T081505.616437Z); check_becoming.py environment audit and per-declaration #print axioms assertions; comment-stripped scan of Becoming/*.lean: 0 sorry/admit/axiom/Classical/native_decide/propext/funext/Quot.sound in code
- [proved-core] The chapters' home statements match their Lean in hypotheses, quantifiers and scope in all 13 central results checked, including the double negation in `Optimum.least_iff` and the gate in `joint_excess_ends`. — Change.lean:482 coming_recurs_iff; Recurrence.lean:689 Law.lossless_iff_returns; Continuation.lean:542 Flow.joint_excess_ends; Optimum.lean:561 Optimum.least_iff; ValuationFrames.lean:92 Valuation.significant_iff; GrammarScope.lean:263 ownClosure_unrestricted_iff_noOutside; DrawnShaping.lean:306 critical_mass_iff
- [proved-core] Near-definitional results are labelled as such in both prose and Lean docstrings. Examples: selection 'states what the definition builds in'; C on paths 'holds by definition'; significance undetermined 'by construction'; balance 'represented, not derived'. — Selection.lean:187-190 docstring; Extension.lean:27-31, 147-150; Significance.lean:115-125; theories/becoming/chapters/01-ROOT.md#r-master-laws-on-the-grammar (Balance bullet)
- [proved-core] The World's relational part is represented in the grammar both ways, and the failure on amounts is written down with Lean witnesses rather than glossed. — Becoming/WorldRepresentation.lean (standingAt_alike, balance_needs_conservation, not_conserves_identity, falls_exhaust, ofModel_model); theories/becoming/chapters/01-ROOT.md#r-the-world-represented-both-ways; commit 8882b7995
- [proved-core] Classical principles are calibrated: each one a law needs is taken as a hypothesis or proved equivalent to the law, and the record says what the need means for the unfolding (LPO as deciding whether a run changes again, DNE as reach without a path, and so on). — theories/becoming/chapters/08-METHOD.md#calibrations table; LastChange.lpo_iff_settles; fromSeed_of_not_separated_iff_dne
- [argued] Expressive limits are stated in the theory's own open lists rather than hidden: no amounts in the grammar; no counting form for entropy or free energy; presence in time and self-changing conditions not statable; mutual interpretation with Lean open. — theories/becoming/THE-THEORY-OF-BECOMING.md §10; theories/becoming/chapters/03-KNOWING.md Reading after r-conditioning-by-restriction; theories/becoming/chapters/08-METHOD.md#expressible-is-not-derived 'Open. Mutual interpretation with Lean'

## Gaps
- [medium/overclaim] The grammar is presented as 'one kind of symbol … builds everything else from relations by a few operations' (01 §1; ONE-PAGE 'One kind of symbol is enough to begin'). In Lean it quantifies over predicates (`«所闭»`: ∀ P : α → Prop; `«入»`; `«生成»`/`«守»`: ∃ S : α → Prop), and uses List (`«对»`), Nat-indexed iteration and sequences (`«迭»`, `«屡»`) and maps (`«像»`). Without excluded middle it has no union. So 'representable in the grammar' means 'definable in Lean with the grammar's vocabulary'. 08 §6's relational-calculus strength comparison does not bound it, and the classical corpus is not shown to supply these resources. — experiments/.../Becoming/GrammarLaws.lean:146-149 («闭», «所闭»), :374 («对»), :653 («迭»), :789 («入»), :1050 («屡»), :1208 («像»); experiments/.../Becoming/GrammarMap.lean:240-246 («生成», «守»); theories/becoming/chapters/01-ROOT.md#one-kind-of-symbol; theories/becoming/chapters/08-METHOD.md#expressible-is-not-derived ('Pairing, power and Lean'; 'Open. Mutual interpretation with Lean'); _process/.../ou3f-activity-laws/AUDIT.md (c) 'The grammar has no union of partial identities and no count of them'
- [medium/mechanical] The grammar-reach count on the front pages is stale. ONE-PAGE.md (and .zh.md) and the overview §10 say '28 of the 127 declarations the master laws rest on reach the grammar'. 08 §7 says 'Of the 127, 44 now reach the grammar'. The phrase also miscounts: the 127 are central declarations, of which 88 rest on a master law. — theories/becoming/ONE-PAGE.md:27; theories/becoming/ONE-PAGE.zh.md:27; theories/becoming/THE-THEORY-OF-BECOMING.md:225; theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity (paragraph after table)
- [medium/missing-test] The periphery receipt for Becoming.FallibleInquiry (20261020T161546.707477Z) is stale. 19 of its 38 pinned dependency hashes (Prelude, Frame, Flow, Admission and others) no longer match the current bytes, so the 03 theorems citing it are certified only against an older core. Whether it still compiles is unknown (not built here). — experiments/.../lean/becoming/fallible-inquiry-verification.json source_sha256 vs current files; theories/becoming/chapters/03-KNOWING.md:65, :334; theories/becoming/results/records/finite-fallible-inquiry-necessity.md
- [low/overclaim] Several bolded one-page laws say more than their Lean:
- 'in a finite world a law that merges nothing brings every state back': the Lean needs a deterministic law and a list holding every configuration, while 'finite world' in the World model means finitely many relata (`World.Finite`), whose configurations with Nat levels are not finitely many.
- 'A knower is part of what it knows' is the model's framing, bolded as a law.
- 'Evolution's classical laws hold': the chapter claims several laws in counting form under exact transmission and equal sizes, and does not state Fisher's regression identity or Wright–Fisher with selection. — theories/becoming/ONE-PAGE.md:13,15,16; experiments/.../Becoming/Recurrence.lean:689 (next : S → S, every : ∀ s, s ∈ all); theories/becoming/chapters/03-KNOWING.md §1 opening paragraph; theories/becoming/chapters/04-LIFE.md:3, :154, :284
- [low/mechanical] Other stale front-page facts:
- 'The evidence. 419 recorded results', against 481 JSON records (450 recorded-checked, 457 theorems).
- 'test systems … have no models yet' (ONE-PAGE; overview §10 'have no models'), against 01 §8.7's five small witnesses, decay and no clear boundary among them; the UE plan says 'modelled since GS3'. — theories/becoming/ONE-PAGE.md:23, :30; theories/becoming/THE-THEORY-OF-BECOMING.md §10 'Fit to actual systems'; theories/becoming/chapters/01-ROOT.md#r-the-source-texts-test-systems; theories/becoming/results/records/*.json (481; status counts)
- [low/mechanical] The master-law counts disagree. 08 §7's table column 'Central declarations on it' (16/52/14/1/9) disagrees with the same section's prose ('all 27 on closure, all 13 on finite runs, 15 of 55 on balance, 1 of 9 on order, 1 of 2 on lumping'; '88 rest on at least one'). Both disagree with COMPLETION.md (27/53/13/2; '86 of 127'). — theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity table and following paragraph; theories/becoming/results/completion/COMPLETION.md#master-laws
- [low/other] The core receipt is not reproducible from the repository alone. 1,349 of 1,360 Lean steps were reused from ~/.cache/becoming-lean, some originally run in scratch trees marked 'not retained'. The raw compile and axiom-audit logs of reused steps (e.g. GrammarTransport's) are not in the retained run folder, so an outside verifier must rerun with BECOMING_FRESH=1. — experiments/.../lean/becoming/becoming-verification.json lean_steps (ran 11, reused 1349; reused['BecomingGrammarTransportAxiomAudit.log'].retained = 'scratch build, not retained'); experiments/.../lean/becoming/becoming-checks/20261029T081505.616437Z/ (22 files); check_becoming.py reuse() l.~3422
- [low/missing-model] Two modelling commitments are not named where they bind. Finite presence at each step (`Flow.present : Nat → List F`) is in neither commitments table. Some World laws get their force from the least unit, e.g. n steps of joint excess ending gated renewal from a level below n + m; with real amounts a shrinking positive excess need not end it. These are not flagged as natural-number laws. — experiments/.../Becoming/World.lean:60-63 (Flow.present : Nat → List F); theories/becoming/chapters/08-METHOD.md#modelling-commitments; theories/becoming/chapters/01-ROOT.md#modelling-commitments; theories/becoming/chapters/05-COLLECTIVES.md#r-own-count-misses-joint-excess
- [medium/structural/in-flight] Most model laws are not yet grammar laws, and processes and other models have no per-model representation theorem. Of the 436 theorems reading only activity, 27 are grammar cases today and 400 are laws of their models. OU3f's derivations and B1/B2 are in progress and will raise the count. — _process/.../ou3f-activity-laws/AUDIT.md ## Summary; theories/becoming/chapters/01-ROOT.md#open 'Faithful representation', 'Lifting'; theories/becoming/chapters/01-ROOT.md#r-the-world-represented-both-ways 'What is not shown' (a representation of processes)
- [medium/missing-model] The probability and continuous-quantity layer is partial. There is no counting form of entropy or free energy; free energy and its variational bound are drafted for the periphery with no receipt. Real amounts and continuous time exist only in the periphery. Quantum is limited to integer-matrix contextuality witnesses. These bound how far the FEP and thermodynamics correspondences can be more than restatements or readings. — _process/.../ue-unified-explanation/PLAN.md items 3, 8 and §5; _process/.../ue1-fep-bridge/NOTE-CORRECTIONS.md §1; theories/becoming/chapters/03-KNOWING.md Reading after r-conditioning-by-restriction; experiments/.../Becoming/Quantum.lean header

## Load-bearing claims
- At core receipt 20261029T081505.616437Z, every module record's axiom_dependencies is empty, 340 modules / 16,633 theorems / 22,697 declarations were audited, and every source hash matches the current bytes. (check: Load experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json. Union modules[*].axiom_dependencies values and compare source_sha256 to sha256 of each source_paths file (relative to lean/). For independence, run BECOMING_FRESH=1 python3 check_becoming.py in a clean worktree.)
- The front pages say 28 of 127 declarations reach the grammar while 08 §7 says 44 of 127. (check: grep '127' theories/becoming/ONE-PAGE.md ONE-PAGE.zh.md THE-THEORY-OF-BECOMING.md chapters/08-METHOD.md; run _process/.../ou3b-master-laws-on-the-grammar/measure_grammar.py.)
- FallibleInquiry's periphery receipt is stale: 19 of its 38 pinned dependency hashes differ from the current sources. (check: Compare fallible-inquiry-verification.json source_sha256 entries against sha256 of the files at source_paths (relative to lean/), or rerun check_fallible_inquiry.py.)
- The Lean grammar quantifies over predicates and uses List, Nat iteration and maps, so it is not a pure relational calculus. (check: Read Becoming/GrammarLaws.lean definitions «所闭» (l.149), «对» (l.374), «迭» (l.653), «入» (l.789), «像» (l.1208), and GrammarMap.lean «生成» (l.240).)
- The World representation fails on amounts: two worlds at different positive standings agree on every field the occurrence model selects. (check: Read World.standingAt_alike and World.balance_needs_conservation in Becoming/WorldRepresentation.lean (l.430-495) and the receipt's audit for that module.)
- The 13 chapter statements checked match their Lean exactly (e.g. Valuation.significant_iff: Connected → Pos → living c₀ → Significant ↔ Grounds). (check: Open the cited declarations (ValuationFrames.lean:92, Optimum.lean:561, Continuation.lean:542, GrammarScope.lean:263, DrawnShaping.lean:306, RegimeMargin.lean:739) beside the anchors r-metaethical-core-characterization, r-what-an-optimum-does-beyond-what-couples-in, r-own-count-misses-joint-excess, r-the-continuation-condition-on-the-root, r-margin-of-a-regime.)

## Recommendations
- P1 Bring ONE-PAGE.md, ONE-PAGE.zh.md and the overview §10 up to date: 44/127 reaching the grammar, the current record count, and the small test-system witnesses. Better still, have the render step write these numbers from the measure and the registry, so the front page cannot drift. — serves fidelity of public claims; human representability; The front page is what a human reader and the review packet read first, and three of its numbers or facts are stale against the chapters.
- P2 Tighten three bolded one-page laws:
- 'within finitely many configurations, a deterministic law that merges nothing brings every state back';
- mark 'a knower is part of what it knows' as the model's framing, keeping 'nothing reaches it except along its relations' as the law;
- 'several of evolution's classical laws hold in counting form'. — serves fidelity of claims to the Lean; These are the only places where a bolded law says more than its Lean declaration does.
- P2 Add to 01 §1 (and a clause on the one page) that the grammar is a vocabulary inside Lean's higher-order type theory. Its definitions quantify over predicates and use lists, naturals and maps, and constructively it has no union. Say which fragment the 'one kind of symbol' claim concerns. — serves formal representability; 'Representable in the grammar' currently means 'definable in Lean with the grammar's vocabulary'. The relational-calculus strength comparison and the classical-corpus reconstruction do not cover that.
- P2 Rerun check_fallible_inquiry.py against the current core, or mark the 03 theorems that cite it as resting on a receipt older than their dependencies. — serves receipt currency; 19 of its 38 dependencies changed after its 20 October receipt.
- P2 After OU3f, state a per-model representation theorem for processes, or its failure, as WRT2 did for the World. — serves formal representability, unification; Processes are the second main model, and 01 §8.6 lists their representation as not shown.
- P3 Reconcile the master-law counts in 08 §7's table, its prose and COMPLETION.md, or label which commit or measure each set comes from. — serves readability, internal consistency; Three different sets of numbers for the same quantity weaken trust in the connectivity measure.
- P3 Add finite presence at each step to the commitments tables (08 §4, 01 §10), and list the least-unit dependence of the joint-excess laws under K4 with a dense form or counterexample. — serves modelling-assumption disclosure; Both are representation commitments that shape laws without being named where they bind.
- P3 Now and then publish a fresh (BECOMING_FRESH=1) core receipt that keeps every compile and axiom-audit log in the repository. — serves independent verifiability of the pure-core claim; The current receipt rests mostly on a user-local cache, so an outside verifier cannot audit it from the repository alone.

## Not read
I did not build Lean or run any checker; all receipt claims rest on reading the JSON and hashing the files.

Chapters: read in targeted sections only:
- 01 §1, §7, §8.6-8.7, §9.1-9.5, §10, not-shown, Open;
- 02 §1, §5, §7 in part;
- 03 §1, §5, part of §6;
- 04 Thesis and a grep;
- 05 §1, §7;
- 07 §2, §3, §4 in part (4.1, 4.4, 4.5), §6;
- 08 §3-§7.

Not read: 06 (Chinese), 07 §4.2-4.3 and §4.6-§9, and 08 §8-§12. The zh one-page was read only for the one line compared.

Lean: I read declarations in Grammar, GrammarLaws (definitions list), GrammarMap, Change, Recurrence, Continuation, Selection, Optimum, Evolution, Admission, Extension, Metaethics, ValuationFrames, Significance, GrammarScope, DrawnShaping, RuleShaping (favours_iff), RegimeMargin, World and Quantum (header). I only skimmed or listed Frame, Flow, DrawnBeyond, SelectionReach, ReadInTime and GrammarPath, and did not read most other modules or any periphery module (Representation.lean, EntropyProduction.lean, FallibleInquiry.lean body).

Studies and records: I did not open REVIEW-WRT2.md or the kit scripts in the world-representation folder, and read only one record. I did not run the grammar-reach measure or the theory-graph tools.
