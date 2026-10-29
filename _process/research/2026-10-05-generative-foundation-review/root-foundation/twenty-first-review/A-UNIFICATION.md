# Reader A: the unification and its shape (Claude Opus 5.5)

Part of the [twenty-first review](../BECOMING-TWENTY-FIRST-REVIEW.md); an AI report, read-only, kept as evidence. Its claims were checked by the cross-checker ([H](H-CROSS-CHECK.md)) and, where the review leans on them, by the synthesizing reviewer.

## Verdict
The unification is real, but it is a hub with models around it, not one derivation. The hub is solid and checked; most of what the theory says about life, optimization and ethics still lives in the models and their premises, not in the root.

What is at the root (Becoming.Grammar, Becoming.GrammarLaws, pure core, every axiom report empty; I checked receipt 20261029T081505.616437Z: all 231 axiom lines are generated `injEq` lemmas): one relation read as condition, classes, continuation as their meet (R ⊓ E), the four positions, the core, renewal, the two-grain map, and five master laws. These are true theorems for every relation. They are also elementary. Closure is reflexive-transitive closure. Balance is a count of unit lists under the full relation, which the repository itself calls near-definitional. Finite runs are pigeonhole (done carefully without decidability) plus well-founded descent. Lumping is "the image is functional exactly where the kernel is a congruence". Order is strict inclusion. The core theorem «根» is the greatest-bisimulation construction. The repository says this plainly (08 §8: "None of the central results is new mathematics").

How far it reaches: 44 of the 127 coverage rows (43 of 118 distinct declarations) depend on a grammar law. The claim that "the measure has no gap" holds because the other 75 are each filed with a reason: 32 "balance, represented", 13 definitional, 9 premises of the account, 7 laws of their model, 4 single applications, 3 counting identities. By region, none of the 18 evolution rows and none of the 5 significance rows reach the grammar, and neither do the central optimizer laws (`Optimum.optimum_beyond`, `Web.optimum_broken_iff`). Where a row does reach the grammar, it is often through a thin lemma. `RuleCapture.uniform_locks`, for example, reaches it only through `Pace.stays_turned`, an induction that a step-invariant holds along a run. In the OU3f audit, 27 of 436 activity-only theorems are cases of a grammar law and 400 are laws of their models. The 9,370 theorems that read no field of the old base have not been touched. WRT2 landed while I was reviewing (8882b7995). The World is now represented both ways for its relations, and the failure on amounts is proved with witnesses. That is honest and good work, but it confirms the main stitch: the grammar has no amounts, and 113 of 127 central statements assume discrete steps, 74 of them natural-number amounts (COMPLETION K4).

The most important stitch for your question about a generative direction: three notions are not joined by any theorem. They are the grammar's 生生 (renewal without end), the map's 生成 (continuation at two grains), and the ethics' widening. On both readings studied so far, the map's strongest generation (全生成) and keeping widening do not hold together, and a finite balanced world has no course that keeps widening (`Flow.whole_not_keepsWidening`, `Flow.not_keepsWidening_along_passings`). The root's strongest notions also collapse on finite, dated, acyclic nets, which are the natural models. Constancy then admits no continuation (GrammarPath header). And the continuation condition on the root holds only with a single center (`«续无外则同一中心»`). The theory handles both openly and with weaker variants.

"Zero axiom" is stated honestly in the chapters. It means no logical axiom in the core; the premises are named; and a theory with zero substantive axioms is a target (08 §12), not something achieved. Weaker spots: the README's opening, in your voice, says "universal invariants... in any universe", which only its footnotes qualify. The board's "the root and the ethics are one account" says more than ONE-PAGE's "only in part". The front pages also disagree on the numbers (28 versus 44 rows reaching the grammar).

What a completion still needs, of the kind that could fail: amounts on the root, or a decision that the root has two sorts; a law joining 生成 to widening, or the negative result adopted as central; a representation theorem for processes; models of real test systems; and lifting the evolution, optimization and significance content. The OU3f derivations, B1 and B2, and DF3 batch B are mechanical and in progress.

## Shape
```\nL3  ETHICS (premises as hypotheses, none asserted)\n    scope: Unrestricted sig   ──(own-closure reading)──>  «续无外» at «一»  [one center if acyclic]\n    order: C on «广»-widening            sig itself: free predicate (not lifted)\n          ^ instances (K6 chain: several steps definitional)\nL2  DOMAINS (attach via models; grammar concepts in region = 0 except root/map/texts)\n    02 §§2-9 World/process | 03 文同 = core (root thm) | 04 evolution 0/18 reach\n    05 capture via closure; optimum: no master law | 07 significance 0/5 reach\n          ^ instance / per-notion bridges\nL1  MODELS\n    frames (closure = grammar by defn)   processes (per-notion; no rep. thm)\n    World: occurrence model Nat×Relatum — relational part both ways (WRT2),\n           amounts NOT (F1 standings forgotten, F1' balance via conservation step,\n           F2 identity ≠ conservation, F3 falls end = image condition)\n    counting layer (lists, census, Price) — outside grammar\n          ^ 5 master laws (proved for every relation)\nL0  ROOT  «际» (缘) · «类» · «续»=R⊓E · positions · «核»(根) · 复生/生生/息 · map 生成/守/退化\n    closure | balance (represented only) | finite runs+steps | lumping | order\nSIDE: 06 classical texts — vocabulary source + AI-classified test corpus (no dependents)\n```\n\n| Measure | Value |\n|---|---|\n| central rows reaching grammar | 44/127 (43/118 distinct) |\n| distinct by category | master law 50 · balance-represented 32 · definitional 13 · premise 9 · model 7 · single 4 · Price 3 |\n| evolution / significance / alignment rows reaching | 0/18 · 0/5 · 5/18 |\n| OU3f activity-only | 27 grammar cases + 9 after B1/B2 · 400 model laws (of 436) |\n| spine theorems reading no old-base field (0cc1aafb4) | 9,370 of 13,828; 11,577 reached no master law |\n| central statements with discrete steps / Nat amounts | 113 / 74 of 127 |

## Answers
### (1) What is the unified shape: layers and arrows, the root, the five master laws, how the models relate, where the chapters attach, where the two ethical premises enter?
There are four layers, plus one region that hangs off the side.

L0, the root (Becoming.Grammar, GrammarMap, GrammarLaws; imports only the prelude):
- one relation «际» read as 缘 (condition);
- classes «类»;
- continuation «续» R E := R ⊓ E, with lines «相续» (reach), families «同族», the four positions «生/住/亡/异», «不穷»;
- the core «核», the greatest symmetric constant relation inside E (root theorem «根»; closure «闭合当且仅当有常»);
- renewal «复生» and 生生 (a greatest fixed point), with ceasing «息» as its inductive dual;
- the map: «传», 生成/守/退化 and the strong forms 全生成/全守/有终.

The five master laws on the grammar, and what each carries:
- Closure («所闭当且仅当同一或及»): the closure is the reflexive-transitive reach. It carries invariance along runs and the reach closures (27 central rows rest on it).
- Balance («守数当且仅当可对», «程守数当且仅当可对»): unit lists paired under «一». This is only a representation, not a derivation. It carries 55 rows, of which 15 reach the grammar through other laws.
- Finite runs («入当且仅当有不返», «线有限不并则回», «有限遍后定后则定前当且仅当皆返», «尽则不或屡»; the steps «迭», «迭内之接», «承之迭»): it carries recurrence, attraction, rest and learnability (13 rows).
- Lumping («像定后当且仅当同行»): it carries structure-and-change-as-one-lumping (2 rows).
- Order («广», irreflexive, one-way and transitive): it carries widening (9 rows, 1 of which reaches the grammar).

L1, the models (arrows run from the grammar into them):
- Frames: closure is the grammar's by definition (`closedUnder_iff_closed`, `withinClosure_iff_within`).
- Processes: bridged per notion (`Branching.returns_iff_reaches`). There is no representation theorem for processes; 01 §8.6 lists it as not shown.
- The World (8 premises, Nat amounts, discrete steps): the occurrence model Nat × Relatum. Forward, it is a schema of per-notion instance theorems plus transport (Becoming.GrammarTransport, `World.reidentify_carries`). Converse: the relational part ranges over everything (`World.ofModel_model`), and conservation is characterized (`World.conserves_form`). It fails on amounts (`World.standingAt_alike`, `World.balance_needs_conservation`, `World.not_conserves_identity`, `World.falls_exhaust`). The interpretation is not full and not injective.
- The counting layer (lists, censuses, Price): outside the grammar. 01 §8.6: "the grammar states no counting".
- Named models (regime, hexagrams, causal-set growth): instances.

L2, the domain chapters, attached through the models rather than the grammar:
- 02 §§2–9: on the World and processes.
- 03: 文同 = the core of the value class (`Law.core_is_sameFuture`; a root-level theorem); selection through couplings via closure on the World.
- 04 Life and evolution: on the World and counting. 0 of 18 evolution rows reach the grammar.
- 05 Collectives: on the World. Capture reaches closure; the optimum laws do not.
- In THEORY-GRAPH.md the regions Knowing, Life, Collectives and Significance have 0 grammar concepts each.

L3, the ethics:
- `sig` is a free predicate.
- Premise 1, the continuation condition (`Unrestricted`), fixes scope. Held de se along a relation it equals the root's «续无外» at «一» (`ownClosure_unrestricted_iff_noOutside`). On an acyclic net it allows only one center (`«续无外则同一中心»`).
- Premise 2, C, fixes order on «广»-widening.
- Both enter as hypotheses, never as axioms (07 §4 table).

The side region, 06, the classical texts: the source of the grammar's vocabulary and a test corpus (GrammarReadings, GrammarCandidates). No result depends on the corpus, and the sentence-to-theorem mapping is AI reconstruction with no human review.

Evidence: experiments/.../Becoming/Grammar.lean:120 «续», :360 «核», :365 «根», :421 «闭合当且仅当有常»; experiments/.../Becoming/GrammarLaws.lean:213, :429, :604, :792, :948, :1037, :1074, :1213, :1232–1258; theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity (table and text); theories/becoming/chapters/01-ROOT.md#r-the-world-represented-both-ways (lines 302–335); theories/becoming/chapters/01-ROOT.md#instances: 'Not instances: the World model's counting, amounts, recurrence and renaming laws'; theories/becoming/results/THEORY-GRAPH.md region table (Concepts column: 0 for Knowing, Life, Collectives, Significance); theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order and #r-the-continuation-condition-on-the-root; experiments/.../Becoming/GrammarScope.lean:86 «续无外», :215 «续无外则同一中心», :263 ownClosure_unrestricted_iff_noOutside; experiments/.../Becoming/LearningRuns.lean:113 goAlike_iff_lumped (proved through «像定后当且仅当同行»)

### (2) How far does the unification reach, quantitatively and qualitatively? Sample-check the measure against the Lean.
Quantitative, from measure-after-ou3e.json, which I re-read:
- 127 rows, 118 distinct declarations; 44 rows reach the grammar, 43 of the distinct declarations.
- Of the 118 by dependence: grammar 43, balance-represented 32, anchor not reached 7, no master law 36.
- By category: master law 50, balance represented 32, definitional or representational 13, premise 9, law of its model 7, single application 4, counting identity 3, gaps 0.

By row (my tabulation of the same file):
- evolution: 0 of 18 reach the grammar (premise 8, balance 5, Price 3, model 1, definitional 1);
- significance: 0 of 5;
- alignment: 5 of 18 (10 balance-represented);
- degeneration: 8 of 20;
- collective: 4 of 7.

Other counts:
- OU3f audit: of the 436 activity-only theorems, 27 are cases of a grammar law (13 to derive, 4 following, 10 done), 9 more become cases once B1/B2 are stated, and 400 are laws of their models (141 witnesses, 174 model laws, 63 representations).
- Old audit at 0cc1aafb4: 9,370 of 13,828 theorems read no World field, and 11,577 reached no master law.
- COMPLETION K4: 113 of 127 central statements use discrete steps and 74 use natural-number amounts.

Sample check:
- `Learning.goAlike_iff_lumped` (LearningRuns.lean:113) really is proved through «像定后当且仅当同行».
- `Amounts.rests_unrefuted` (Amounts.lean:208) through «尽则不或屡».
- `Branching.step_back` (Junctures.lean:121) through «所闭当且仅当同一或及» and «及当且仅当一步而所闭».
- `unrestricted_iff_livingSignificance` (Relevance.lean:136) is a 3-line unpacking and is correctly filed as definitional.
- `RuleCapture.uniform_locks` is filed as reaching the grammar through closure. Its only route is `Pace.stays_turned` (Pace.lean:162), which says a predicate kept by each turn holds later. So the reach is real but thin: the lock's content (monotone reading, a favouring rule) is in the model.
- `Optimum.optimum_beyond` rests on balance, represented; `Web.optimum_broken_iff` is filed as a law of its model.

Qualitative: the grammar unifies the skeleton (reach and closure, steps, pigeonhole, lumping, inclusion, the continuation vocabulary). The mechanisms that carry the theses (thresholds and support, joint excess, the optimum drain, Price, drift) are model premises and arithmetic.

The numbers disagree across pages:
- ONE-PAGE (en and zh) and overview §10 still say "28 of the 127".
- 08 §7's table column reads 16/52/14/1/9, while its text says 27/55/13/2/9 and "88 rest on at least one".
- COMPLETION.md says 86 rest on one, 41 on none, and 27/53/13/2/9.

Evidence: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3e-step-indexed-bridges/measure-after-ou3e.json (keys distinct_by_dependence, distinct_by_category, rows); $D/ou3f-activity-laws/AUDIT.md §Summary table; $D/one-unfolding-root/audit/REPORT.md 'What a theorem uses' and 'Master laws: 11,577 reach none'; theories/becoming/results/completion/COMPLETION.md K4 'discrete steps (113); natural-number amounts (74)'; master-laws table 86/41; theories/becoming/ONE-PAGE.md line 27 and ONE-PAGE.zh.md line 27 ('28 of the 127'); THE-THEORY-OF-BECOMING.md line 225; theories/becoming/chapters/08-METHOD.md line 434 (44 of 127; 88; table column 16/52/14/1/9); experiments/.../Becoming/RuleCapture.lean:285–307; Pace.lean:162 stays_turned

### (3) Where is it stitched rather than unified?
1. Amounts. The grammar has none. Balance has a grammar form only as unit-list counting under «一», and the repository calls it near-definitional (01 §7). WRT2 proves that the occurrence model forgets standings (`World.standingAt_alike`). It also proves that balance is carried only by a conservation step that is defined from the balance equation (`World.balance_needs_conservation`). Treating the 32 balance rows as "no gap" is a decision about categories, not a derivation.

2. Generation, 生生 and widening. These are three notions with no theorem joining them. 02 §1 reading: "no law relates the two". On names and on passing of support, 全生成 and keeping widening do not hold together (07 r-what-keeping-widening-needs; `Flow.not_keepsWidening_along_passings`, `Flow.whole_not_keepsWidening`).

3. Significance. `sig` is a free predicate nothing else reads, and SD1 holds by construction (07 §1). The root form «续无外» covers only the own-closure reading and is degenerate on acyclic nets. The free significance is not lifted.

4. The ethics has two premises, the condition for scope and C for order. Neither is derived, and neither is claimed to be.

5. Classical texts: provenance and a test corpus, AI-classified (59 candidates; 38/15/3). No other result depends on them.

6. Modelling commitments: discrete steps and one shared index, Nat amounts, Prop-valued activity, identity by naming. WRT's F2 shows that identity across a step is never conservation's continuation when the relata outnumber the standings, so naming stays a commitment of the model.

7. The meta-attractor's selection of selection is not a law of the grammar (01 Open, self-changing conditions).

8. There is no representation theorem for processes.

Evidence: theories/becoming/chapters/01-ROOT.md#r-master-laws-on-the-grammar (Balance bullet: 'near-definitional'); $D/world-representation/DESIGN.md §3 F1, F1′, F2, F3; theories/becoming/chapters/02-MAP.md lines 47–48 (Reading: 'no law relates the two') and Open list; theories/becoming/chapters/07-SIGNIFICANCE.md#r-what-keeping-widening-needs ('on both readings used, names and passing of support, 全生成 and keeping widening do not hold together'); theories/becoming/chapters/07-SIGNIFICANCE.md#r-what-the-dynamics-leave-open; theories/becoming/chapters/01-ROOT.md#open (Self-changing conditions; Faithful representation); theories/becoming/chapters/01-ROOT.md §10 modelling commitments table

### (4) Is the root non-trivial: what does it forbid; are the master laws deep or near-definitional?
The grammar's theorems hold for every carrier, relation and class, so they forbid nothing about any world. They constrain descriptions. A class under which a line ends cannot be constant (`«有亡之续则不有常»`). Renewal does not decide the region (`Map.Short.renews_and_ends`). Deciding the positions or regions everywhere is exactly excluded middle (`«四相之定当且仅当排中»`, `«全三域之定当且仅当排中»`).

Its real content is of three kinds:
- exact calibrations of logical strength;
- negative witnesses (the flame `«以核为判据则火无续»`; non-transitive sameness; the mixed region `Map.«生守相杂»`);
- the WRT2 characterization of what the World adds: grading, finiteness of presence, decidedness from Nat, falls ending.

Empirical prohibitions enter only through the World's premises and the theses T1–T8 (08 §9).

The master laws are near-definitional or textbook:
- closure = reflexive-transitive closure;
- balance = cardinality of unit lists;
- «入当且仅当有不返» is close to a definition, and the pigeonhole is constructive (its one distinctive point);
- «像定后当且仅当同行» is functional image ⇔ congruence (a bisimulation/lumpability fact);
- order = strict inclusion.

The repository agrees: 08 §8 calls every central result near-definitional or restated, and the UE0/UE6 audits found no result that no neighbouring field states.

In addition, on finite acyclic nets constancy admits no continuation at all, which the GrammarPath header says outright. That forced the weaker «至终有常». The condition on the root then has one center. So the root's distinctive concepts bind mainly on infinite or cyclic nets, or under weakened variants.

The depth of the work lies elsewhere: in the premise ledger (independence with witnesses), the calibrations, the optimum law under room, the capture and readers models (MA2–MA4b), and the honest failure analysis.

Evidence: experiments/.../Becoming/Grammar.lean:355 «有亡之续则不有常», :185 «四相之定当且仅当排中», :763 «以核为判据则火无续»; experiments/.../Becoming/GrammarLaws.lean:213, :429, :792, :948, :1213, :1250–1258; theories/becoming/chapters/08-METHOD.md#known-results ('None of the central results is new mathematics') and #third-parts ('not yet farther than the sciences taken together'); experiments/.../Becoming/GrammarPath.lean header ('in a net where every line ends (finite and with no cycle...) no class under which anything continues is constant'); experiments/.../Becoming/GrammarScope.lean:215

### (5) What does an elegant completion still need; which remaining items are structural (could fail) versus mechanical?
Structural (each could fail or force a redesign):
- (a) Amounts on the root, or an explicit two-sorted root (relations plus counts). 55 central rows rest on balance, and WRT2 shows the grammar cannot recover them.
- (b) A law relating the map's 生成 to widening, or adopting the negative results as central and redrawing the reading of 生生. Currently negative on two readings.
- (c) Map coverage. A hand check (not in Lean) gives a line that renews once and then stays still; at its start it is in none of 生成/守/退化, so the three-way map is not a partition as defined.
- (d) A representation theorem for processes, and one through the order of joined exchanges rather than the shared index.
- (e) The ethics on the root beyond the own-closure instance: which class a center's line runs under, and lifting the free `sig`.
- (f) Selection of selection (the meta-attractor) as a law across two grains.
- (g) Faithful representation of actual test systems: a vortex, an organism, an institution through replaced members, a belief system. None has a model (01 Open).
- (h) Whether the 9,370 field-free theorems have grammar statements. The OU3f pattern (92% laws of their models) suggests most will stay laws of their models; the unification target should say so rather than chase counts.

Mechanical or in flight:
- OU3f's 13 derivations and B1, B2 plus the converse law, then 9 following (in flight);
- DF3 batch B record migrations (in flight);
- reconciling the numbers across ONE-PAGE (en/zh), overview §10, the 08 §7 table and COMPLETION;
- proving the coverage counterexample in Lean;
- the computed master-law view in records (WHAT-REMAINS item 5).

WRT2 was in flight when this review began and landed during it (8882b7995).

Evidence: $D/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md §'The measure with no gap' and §'The next layer'; theories/becoming/chapters/02-MAP.md §1 'Open. Coverage by the three regions ... (a hand check, not in the Lean)'; theories/becoming/chapters/01-ROOT.md#open; #r-the-world-represented-both-ways 'What is not shown'; $D/ou3f-activity-laws/AUDIT.md §What follows; _process/BECOMING-WORKBOARD.md Queue line (DF3 batch B at head); git log 8882b7995 'WRT2 landed'

### (6) Is 'zero axiom' stated honestly?
Yes, in the live chapters.
- 08 §3: the pure core is "stricter than constructive, and about logic only".
- 08 §12: "zero axiom" means no substantive axiom and is the target; "An absence of ethical axioms is not an absence of substantive premises".
- ONE-PAGE: "a constructive discipline, not an absence of premises".
- I verified the receipt: status passed, the core compiles from the prelude, and every AXIOMS line in EnvironmentAudit.log is a generated `injEq` on propext.

Caveats:
- (i) README's body text, in Ren's OPENING voice, says "universal invariants ... in any universe, nothing that unfolds can break them" and "None of this needs an axiom". Notes 1 and 3 qualify this correctly: the laws hold "by what change and count are", which is why they are not a dynamics, and "in every universe" is open. Still, the strongest no-axiom claims are exactly the ones with the least empirical content, and the body text does not say that.
- (ii) K1–K7 report "met, no finding". They read Lean source text and listed patterns only, which 08 §12 concedes. They certify nothing beyond that.
- (iii) The board's 'The way now' says "the root and the ethics are one account", while ONE-PAGE and overview §10 say "only in part".

Evidence: theories/becoming/chapters/08-METHOD.md#pure-core-and-periphery; #r-theory-of-becoming-foundation; §12 'The target'; theories/becoming/ONE-PAGE.md 'The evidence' paragraph; experiments/.../becoming-checks/20261029T081505.616437Z/EnvironmentAudit.log (231 AXIOMS lines, all injEq); becoming-verification.json status passed, core_compiles_from_prelude true; README.md lines 13, 19; notes note-law and note-proof; theories/becoming/chapters/08-METHOD.md#completion-criterion ('That is all they establish'); _process/BECOMING-WORKBOARD.md 'The way now (29 October 2026)' first sentence

## Strengths
- [proved-core] The pure core is as advertised: it imports only the prelude, and every source declaration has an empty axiom report. The only axiom dependencies are 231 generated injEq lemmas on propext, which no source declaration uses. — experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks/20261029T081505.616437Z/EnvironmentAudit.log; experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json (status passed, core_compiles_from_prelude true)
- [known-result-restated] The root theorem: every class has a core (the greatest symmetric constant relation inside it), the core is a class, and a class is constant exactly where it lies inside its core. Proved for every relation, in a few lines. — experiments/.../Becoming/Grammar.lean:365 «根», :391 «核为类», :574 «类有常当且仅当含于核»; theories/becoming/chapters/01-ROOT.md#constancy-and-core
- [proved-core] The five master laws are theorems of the grammar for every carrier and relation, and models' laws are re-proved from them (rule 9), e.g. goAlike_iff_lumped through «像定后当且仅当同行» and Amounts.rests through «尽则不或屡». — experiments/.../Becoming/GrammarLaws.lean; experiments/.../Becoming/LearningRuns.lean:113; experiments/.../Becoming/Amounts.lean:208
- [proved-core] The World's representation in the grammar both ways (WRT2) states its failures as theorems with witnesses rather than leaving them open. Amounts are not determined by the model, balance is not determined by the web, conservation is never identity on Nat → Prop, and falls end only as a condition of the image. — theories/becoming/chapters/01-ROOT.md#r-the-world-represented-both-ways; $D/world-representation/REVIEW-WRT2.md (21 findings taken, re-read); commit 8882b7995
- [argued] The measure is transparent. Every central declaration either reaches a master law or has a written reason, and two moves that would only have raised the count were declined: anchors redefined through bridges, and PartForms.goAlike. — $D/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md §'The measure with no gap'; $D/ec6-no-master-law/AUDIT.md §Method 'The test for (a)'; $D/ou3f-activity-laws/AUDIT.md §Method
- [reading] Novelty is self-assessed candidly: no central result is new mathematics, and the theory is farther than each contained framework but not farther than the sciences together. — theories/becoming/chapters/08-METHOD.md#known-results; theories/becoming/chapters/08-METHOD.md #third-parts paragraph
- [proved-core] The ethics' two premises are kept apart as hypotheses with separate roles. Their root form is exact in both directions, including the negative result that on an acyclic net it allows only one center. — experiments/.../Becoming/GrammarScope.lean:263 ownClosure_unrestricted_iff_noOutside, :215 «续无外则同一中心»; theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order
- [proved-core] Exact calibrations: deciding the positions, the map's strong regions, or inclusion against exceeding for every relation is each exactly excluded middle. — experiments/.../Becoming/Grammar.lean:185 «四相之定当且仅当排中»; theories/becoming/chapters/02-MAP.md §1 Calibration «全三域之定当且仅当排中»; experiments/.../Becoming/GrammarLaws.lean:1315 «则逾之定当且仅当排中»

## Gaps
- [high/structural] The domain content does not reach the root. No evolution row (0 of 18) and no significance row (0 of 5) depends on a grammar law; the central optimizer laws rest on no master law or on balance-represented; and THEORY-GRAPH gives the Knowing, Life, Collectives and Significance regions zero grammar concepts. The unification so far is a shared skeleton plus models, not domain laws derived on the root. — $D/ou3e-step-indexed-bridges/measure-after-ou3e.json rows (evolution, significance, alignment); theories/becoming/results/THEORY-GRAPH.md region table; theories/becoming/results/completion/COMPLETION.md 'Resting on no master law' list
- [high/structural] Generation (the map's 生成), the grammar's 生生 (renewal without end) and the ethics' widening are not joined by any theorem. On the two readings studied, 全生成 and keeping widening do not hold together, and a finite balanced world has no course that keeps widening. The bridge from 'how things go on' to 'a generative direction' is therefore missing, and on present evidence negative. — theories/becoming/chapters/02-MAP.md §1 Reading ('no law relates the two') and Open; theories/becoming/chapters/07-SIGNIFICANCE.md#r-what-keeping-widening-needs (Flow.not_keepsWidening_along_passings, Flow.whole_not_keepsWidening)
- [medium/overclaim] The grammar has no amounts. Balance (55 central rows) is only represented, by unit lists under «一», which the repository calls near-definitional. Counting the 32 balance-only declarations as 'no gap' is a category decision, so 'the measure has no gap' can read as more unification than exists. WRT2 proves the occurrence model forgets standings. — experiments/.../Becoming/GrammarLaws.lean:429 «守数当且仅当可对»; theories/becoming/chapters/08-METHOD.md line 434 ('so they are no gap'); theories/becoming/chapters/01-ROOT.md#r-the-world-represented-both-ways 'Where it fails'
- [medium/structural] The root's distinctive notions collapse on finite, dated, acyclic nets, which are the natural models of an unfolding in time. There, constancy admits no continuation (so the weaker «至终有常» was introduced), and the continuation condition on the root holds only with a single center. — experiments/.../Becoming/GrammarPath.lean header ('Up to the net's end'); experiments/.../Becoming/GrammarScope.lean:215 «续无外则同一中心»; theories/becoming/chapters/01-ROOT.md §5 ('self-maintenance read as a constant class belongs only to lines that never end')
- [medium/structural] The map's generate/keep/degenerate is not shown to be a partition. A hand check (not in Lean) gives a line that renews once and then stays still; at its start it is in none of 生成, 守, 退化. — theories/becoming/chapters/02-MAP.md §1 'Open. Coverage by the three regions'
- [medium/missing-model] Modelling commitments run through everything. 113 of 127 central statements assume discrete steps and 74 assume natural-number amounts; K4's dense forms or counterexamples cover only the 7 listed Nat laws. There is no representation theorem for processes, and no model of the test systems (vortex, organism, institution, belief system). — theories/becoming/results/completion/COMPLETION.md K4; theories/becoming/chapters/01-ROOT.md#r-the-world-represented-both-ways 'What is not shown'; theories/becoming/chapters/01-ROOT.md#open (Test systems)
- [low/overclaim] The master laws are near-definitional or textbook (reflexive-transitive closure, unit counting, pigeonhole and descent, image ⇔ congruence, strict inclusion), and many 'reaches the grammar' links go through a single invariant-induction lemma (e.g. RuleCapture.uniform_locks via Pace.stays_turned). Connectivity counts measure dependence, not explanatory depth. The repository says this, but summaries may not. — experiments/.../Becoming/GrammarLaws.lean:213, :429, :948, :1213, :1250; experiments/.../Becoming/Pace.lean:162; RuleCapture.lean:285; theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity ('The measure records dependence, not meaning')
- [low/mechanical] Stale and inconsistent figures on front pages. ONE-PAGE (en and zh) and overview §10 say '28 of the 127' reach the grammar, while 08 §7 and the measure say 44. 08 §7's table column (16/52/14/1/9) contradicts its own text (27/55/13/2/9, 88 resting) and COMPLETION.md (27/53/13/2/9, 86 resting, 41 on none). — theories/becoming/ONE-PAGE.md:27; theories/becoming/ONE-PAGE.zh.md:27; theories/becoming/THE-THEORY-OF-BECOMING.md:225; theories/becoming/chapters/08-METHOD.md:422–434; theories/becoming/results/completion/COMPLETION.md#master-laws
- [low/overclaim] The board's 'The way now' says 'the root and the ethics are one account', which is stronger than the chapters' 'one account only in part'. The free significance is not lifted, and the root form allows one center on acyclic nets. — _process/BECOMING-WORKBOARD.md 'The way now (29 October 2026)'; theories/becoming/ONE-PAGE.md 'What is not yet done' bullet 2
- [medium/structural] The 9,370 theorems that read no field of the old base have not been audited for grammar statements. The OU3f result (400 of 436 laws of their models) suggests most will stay laws of their models, so the scope of the lifting target is unknown. — $D/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md §'The next layer'; $D/one-unfolding-root/audit/REPORT.md
- [low/mechanical/in-flight] OU3f's 13 derivations, the laws B1 (steps split) and B2 (no end gives steps of every length) plus the converse law, and the 9 rows that follow from them are not yet landed. — $D/ou3f-activity-laws/AUDIT.md §What follows; git log cafb743de (audit landed)
- [low/mechanical/in-flight] DF3 batch B (87 schema-1 records migrated to schema 2) is at the head of the queue. It touches home sections in several chapters, so record and section wording may shift. — _process/BECOMING-WORKBOARD.md Queue line

## Load-bearing claims
- 44 of 127 rows (43 of 118 distinct declarations) reach the grammar. 0 of 18 evolution rows and 0 of 5 significance rows do. (check: Load $D/ou3e-step-indexed-bridges/measure-after-ou3e.json; read reaching_the_grammar and distinct_by_dependence; tabulate rows[*] by 'row' and 'grammar'.)
- The pure core has no logical axioms beyond the generated injEq lemmas. (check: grep '^AXIOMS' experiments/.../becoming-checks/20261029T081505.616437Z/EnvironmentAudit.log | grep -v injEq returns nothing; becoming-verification.json status = passed.)
- Balance on the grammar is only a unit-list cardinality encoding under the full relation. (check: Read GrammarLaws.lean:429 «守数当且仅当可对» and :392 «一之对» (under «一», a pairing is exactly equal length).)
- On an acyclic net, the continuation condition on the root holds only with one center. (check: GrammarScope.lean:215 «续无外则同一中心» (hypotheses: «无环» R, «续无外» R E center).)
- The map's 全生成 and keeping widening do not hold together on the readings studied, and a finite balanced world has no course that keeps widening. (check: 07-SIGNIFICANCE.md#r-what-keeping-widening-needs; Lean declarations Flow.not_keepsWidening_along_passings and Flow.whole_not_keepsWidening.)
- OU3f: 27 of 436 activity-only theorems are cases of a grammar law, and 400 are laws of their models. (check: $D/ou3f-activity-laws/AUDIT.md §Summary and TABLE.md.)

## Recommendations
- P1 On ONE-PAGE and the overview, state the unification in its actual form: a shared relational skeleton (closure, steps, finite runs, lumping, inclusion, the continuation vocabulary) with models carrying the domain mechanisms. Give the per-region reach (evolution 0/18, significance 0/5, alignment 5/18), not only the total. — serves shared understanding with human readers; alignment researchers; Readers will otherwise take '5 master laws on the grammar' and 'measure has no gap' to mean the domain laws are derived on the root.
- P1 Make the 生成–widening relation a first-class item. Either find a reading of passing or support on which 全生成 and keeping widening hold together, or adopt the negative results as central and redraw how 生生 is read relative to the map. — serves the step argued where the theory bears on it; Ren's question on a generative direction; It is the one missing link between the root's account of going on and the ethics' order, and current evidence on it is negative.
- P2 Decide the root's treatment of amounts. Either design a counting extension of the grammar (pairing or counts as a second primitive, with what it costs the 'one kind of symbol' claim), or state explicitly that the root is relational and counting is a separate layer. — serves a unified explanation of reality; elegant completion; 55 central rows rest on balance, and WRT2 proves the grammar cannot recover amounts. The present 'represented, no gap' label hides a real design choice.
- P2 Reconcile the master-law figures across ONE-PAGE (en and zh), overview §10, 08 §7's table and text, and COMPLETION.md (regenerate from one measure), and soften the board's 'one account' sentence. — serves shared understanding; coordination; Front pages currently disagree (28 vs 44 rows; 86 vs 88 resting; inconsistent per-law columns).
- P2 Prove a representation theorem for processes, and build one test-system model (an organism that ends, or an institution through replaced members) on the occurrence model. — serves a real test system; a unified explanation of reality; Faithful representation is the theory's open central claim, and only the World has one, with failures.
- P3 Prove the map-coverage counterexample in Lean, and decide whether 守 should allow earlier renewals so that the three regions partition. — serves elegant completion; Generate/keep/degenerate is presented as the map of becoming, but it is not shown exhaustive and a hand check suggests it is not.
- P3 Before designing the lifting of the 9,370 field-free theorems, audit a random sample of about 200 to estimate the share that would be grammar laws versus laws of their models. Set the target from that, and avoid count-raising. — serves elegant completion; the work's pace; OU3f found 92% laws of their models. A full audit might absorb effort for little unification.

## Not read
Of chapters 03-KNOWING, 04-LIFE, 05-COLLECTIVES and 06-CLASSICAL-TEXTS I read only the 文 section of 03; 07 only in part (§1, §4, §4.5, keeping widening); 08 §§1, 2, 4, 5, 10 and 11 not read. GrammarMap.lean, GrammarCandidates.lean, GrammarPath.lean beyond its header, and GrammarTransport/WorldRepresentation.lean in detail (I relied on REVIEW-WRT2 and the 01 §8.6 text). OU3f TABLE.md and REVIEW-OU3f.md, REVIEW-EC6.md, REVIEW-WRT.md, the OU3b DESIGN and AUDIT, EC6's proposals section, PLAN.md outside §八 and §十三, CHAPTER-DRAFT.md, the classical corpus and its classifications. I compiled no Lean and did not re-run measure_grammar.py or audit.py; the per-row tabulation is from the saved measure-after-ou3e.json. WRT2 landed (8882b7995) during this review, and I re-read 01 §8.6 and the overview diff after it landed.
