# Briefs of the RF mapping and second opinion

## The second opinion (piped to `cx -m astra -e high --fresh --sandboxed --net`)

# Context

You are giving an independent, cross-model second opinion for a research line in the Theory of Becoming, in the repository /Users/ren/theories (read AGENTS.md first; the theory starts from one relational unfolding, not separate agents and environments; its laws are proved in Lean 4 in a pure core that imports only Init, at experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/*.lean). **Read-only**: do not edit, create, commit, render, run make, or build Lean; other sessions are landing work in this checkout.

The author asked for "a complete understanding" of what a recent review found the theory does not cover: **inner alignment (mesa-optimization, goal misgeneralization), deception (including deceptive alignment and evaluation awareness), and assistance games (CIRL, preference learning)** — and not only for AI: "how minds, institutions and networks coordinate … higher order dynamics, for example learning, how a cognitive model updates, how decisions [are made] … in general, how a system with a mechanism that predicts, perceives, updates itself. I think this will be the key to our theory."

What the theory already has (read the headers and main statements; do not rebuild): `Becoming/Learning.lean` (no prefix fixes the next value; extrapolation by elimination; induction in a world held by a list; the meta level; a lumping generalizes exactly where it lumps; structure and change are one lumping; training as selection through the data), `Training.lean` (training as selection over act laws through the courses each generates; installed only along its own courses; free off courses where the representation separates; through a reward's couplings; implicit bias of local search; outrun), `Mechanism.lean` (a projection carries a law exactly where configurations alike under it go alike; a system that changes its own rule is one determined process on state × rule), `Diagonal.lean` (a family of readings within what it reads misses a reading; completion is an unfolding), `Narrowing.lean` (belief revision by narrowing), `Revision.lean`, `ResponseLearning.lean` (forming an operation from another formation's responses), `SharedCodes.lean`, `ChoiceCountCapture.lean`, `SetPointOptimum.lean`, `ConditionalWeights.lean`, `HeldPossible.lean` (along one fixed process nothing is added to the possible; keeping widening needs departures without end; a rule changing its own rule and a tower of rules read as processes), and the capture laws (`RuleCapture`, `ClosedCapture`, `DrawnShaping`, `ReadInTime`). Chapter 03 (theories/becoming/chapters/03-KNOWING.md) and 07 §6 (07-SIGNIFICANCE.md, "What training installs") summarize them.

# Your task (two parts)

**Part 1 — the literature's exact results.** Use the web to check. For each of the following, give the precise formal statement (or the closest precise statement in the literature), the citation, and what it would mean to contain it on this theory's spine (an instance theorem plus something forbidden that the framework leaves open), or why it cannot be contained:
- Conant & Ashby's good regulator theorem; Francis & Wonham's internal model principle (and any modern discrete or categorical restatements, e.g. Baez/Virgo/Biehl on "internal model principle" or "a good regulator has a model").
- Mesa-optimization and inner alignment (Hubinger et al. 2019); goal misgeneralization (Langosco et al. 2022; Shah et al. 2022); any formal definitions of an "internal objective"; the formal results relating training data coverage to off-distribution behavior.
- Deceptive alignment; evaluation awareness (recent empirical work, 2024–2026, on models detecting evaluation); Eliciting Latent Knowledge (ARC 2021) and its formal difficulty; formal treatments of deception in signaling (Crawford–Sobel cheap talk; deception definitions in causal games, e.g. Ward et al. 2023 "Honesty is the best policy: defining and mitigating AI deception").
- Assistance games / CIRL (Hadfield-Menell et al. 2016), the off-switch game (2017), identifiability limits of inverse reinforcement learning (Ng & Russell 2000; Armstrong & Mindermann 2018 "Occam's razor is insufficient"), preference shaping/manipulation by recommenders (e.g. Carroll et al. 2022 "Estimating and penalizing induced preference shifts"), incentives to influence (Everitt et al. causal influence diagrams).
- Learning on networks and institutions: DeGroot learning and Golub & Jackson's wisdom of crowds; information cascades (Bikhchandani, Hirshleifer & Welch 1992; Banerjee 1992); Condorcet jury theorem and its dependence failures; Aumann's agreement theorem; organizational double-loop learning (Argyris & Schön) and Bateson's levels of learning; Ostrom's monitoring principles.
- Predictive processing / active inference as theories of perception and action (only what is formally stated); self-prediction limits (Wolpert's "physical limits of inference"; Lawvere-style results; Löbian obstacles for self-trusting agents).
For each, say whether it is a known formal theorem, an empirical finding, or a conceptual framing.

**Part 2 — an independent sketch.** Without anchoring on any plan (none has been written yet), propose how this theory, in its own terms (a formation is a pattern of continuation within one relational unfolding; it reads what couples into it; a selection reaches exactly what couples into its selector; a model is a lumping that carries a law), should state: (a) a formation that perceives, predicts, chooses and updates itself, as one structure; (b) inner alignment and goal misgeneralization; (c) deception, including acting differently when read; (d) assistance and preference shaping; (e) institutions and networks that learn and coordinate, including cascades and double-loop learning; (f) the higher orders (learning to learn, a rule changing its own rule) and their limits. For each, propose the one or two theorems you think are central — exact statements, hypotheses, and whether each is near-definitional, a known result restated, or plausibly new — and say what each would forbid. Say which existing Lean declarations each would build on (check they exist with grep). Flag anything in the theory's existing statements that you think is wrong or overstated on these topics.

Return one markdown report (3,000–5,000 words): Part 1 as a table plus notes, Part 2 as numbered proposals, then the three proposals you would rank highest and why, then what you did not read or check. Cite repository paths and URLs.

## The mapping workflow (three readers)

```js
export const meta = {
  name: 'self-updating-formations-map',
  description: 'Map what the Theory of Becoming already proves about learning, models, prediction, self-reading, teaching, pools and capture, for a new study of formations that perceive, predict and update themselves',
  phases: [
    { title: 'Map', detail: '3 read-only readers, one per region of the existing Lean and chapters' },
  ],
}

const COMMON = `You are mapping what already exists in the Theory of Becoming (repository /Users/ren/theories) for a new study: formations (minds, AI systems, institutions, networks) that perceive, predict, choose and update themselves, including inner alignment (an installed law that is itself an optimizer of an internal score), deception (acts that differ where they are not read), assistance (a helper reading another's acts to serve what the other's selection favours), and learning in institutions and networks. The study must build on existing laws, not rebuild them.

STRICTLY READ-ONLY: do not edit, create, delete, commit, render, run make, or build Lean. Other sessions are landing work in this checkout.

Paths: Lean pure core at experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/*.lean (read each module's /-! header and grep its theorem statements; do not dump whole files). Chapters at theories/becoming/chapters/ (01-ROOT … 08-METHOD; 90-200 KB each: grep headings, read targeted sections). Records at theories/becoming/results/records/*.md.

For every law you list, give: the exact Lean declaration name (as it appears, with namespace), the module, a one-sentence statement that keeps its hypotheses, and its standing (core / periphery). Check each name exists with grep before listing it. Be exact; do not paraphrase a law into something stronger. Say plainly where something the study needs does NOT exist.`

const MAP = {
  type: 'object',
  properties: {
    summary: { type: 'string', description: '200-400 words: what this region already establishes for the new study, and the main gaps' },
    laws: { type: 'array', items: { type: 'object', properties: {
      decl: { type: 'string' }, module: { type: 'string' }, statement: { type: 'string' }, standing: { type: 'string' }, bears_on: { type: 'string', description: 'which concept of the study: perception, model, prediction, choice, update, meta-level, self-model, inner-alignment, deception, assistance, institution, network, capture, other' } },
      required: ['decl', 'module', 'statement', 'standing', 'bears_on'] } },
    definitions: { type: 'array', description: 'the key definitions (structures, predicates) the study would reuse, with their exact Lean names and fields', items: { type: 'object', properties: {
      name: { type: 'string' }, module: { type: 'string' }, what: { type: 'string' } }, required: ['name', 'module', 'what'] } },
    open_items: { type: 'array', description: 'open items stated in chapters or module headers that bear on the study, quoted with location', items: { type: 'string' } },
    gaps: { type: 'array', description: 'what the study needs that does not exist, as precisely as possible', items: { type: 'string' } },
  },
  required: ['summary', 'laws', 'definitions', 'open_items', 'gaps'],
}

const REGIONS = [
  { key: 'learning-training', prompt: `REGION 1: learning, training, belief revision, identification, testing, inquiry.
Modules: Learning, LearningRuns, Learnable, LearnableRuns, Unrolling, Labels, Identification, IdentificationRuns, Training, Revision, Narrowing, NarrowingRuns, ClassifiedBeliefProcesses, Inquiry (and wherever InquirySufficiency is defined: grep 'namespace InquirySufficiency' or 'structure' in the package), FallibleInquiry (periphery), Testing, Experiment, HistoryIdeals, LimitVerification, Undecided, Segmentation, LearnedGrouping, CrossSituational. Chapters: 03-KNOWING.md §4 to §9 (laws along a run, refutation and verification, lumping, 文, learning and seeking, inquiry) and its Open; 07-SIGNIFICANCE.md §6 'What training installs' and the objections table rows on learning.
Answer in the summary and laws: (a) what is said of a learner whose installed law is itself a selection by an internal score (anything near mesa-optimization), (b) off-course behaviour and what training fixes there, (c) the meta level and learning to learn, (d) belief revision and its limits, (e) identification and its limits, (f) implicit bias of the search, (g) anything about a learner's acts depending on whether it is evaluated.` },
  { key: 'models-self-orders', prompt: `REGION 2: models and mechanisms, prediction, observation and readout, self-reading, rules that change their own rule, towers, pace, reading schedules, choice through a score.
Modules: Mechanism, Experiment, Counterfactual, CounterfactualRuns, Retrodiction, Observation, Readout, PartialReadout, ReadingSchedule, Diagonal, Undecided, Description, HeldPossible (its sections on a rule changing its own rule and on a tower of rules), Tower, Pace, ContactCourses, Contacts, ReferencePlan, ContinuingRevision, Handoff, RuleHandoff, Situations, Context, ContextualRuns, LevelCoupling, Sensitivity, SetPointOptimum, ChoiceCountCapture, ConditionalWeights, Seeking, Enough, and wherever Web.anticipates_iff is (grep). Chapters: 03-KNOWING.md §1 to §3 and §10; 02-MAP.md §8 (regulation and reserves); 01-ROOT.md wherever a rule changing its own rule or towers appear (grep 'tower', 'own rule').
Answer in the summary and laws: (a) perception as coupling by level; (b) a model as a projection carrying a law, and whether anything states a formation's internal state tracking a lumping of the world (an internal model principle or good regulator theorem) — say exactly whether it exists; (c) prediction and intervention; (d) self-reading limits; (e) a rule changing its own rule and towers, exactly what HeldPossible states about them; (f) choice: any formation selecting its acts by a score over predicted or counted courses; (g) oversight read as a reading schedule, and anything about a formation coupled into whether it is read.` },
  { key: 'others-pools-capture', prompt: `REGION 3: learning from and with others: teaching and response learning, shared codes and conventions, pools of readers, reviewers and witnesses, recruitment, capture loops as institutional learning, markets, joint plans, tolerance and giving first.
Modules: ResponseLearning, RouteFormation, SharedCodes, CodeAcquisition, JoiningCodes, JoiningContexts, Pool and pooled coupling (grep 'withinCoupling_reads_iff', 'act_unselected_pool', 'RecruitsThrough'), PoolCourse, PoolResponse, SelectionPool, Reconfiguration (grep 'ready_iff_nonempty_separated'), WitnessRefinement, WitnessRefinementRuns, PooledEnvelopes, Selection, SelectionReach, SelectionRuns, Capture, RuleCapture, ClosedCapture, RuleShaping, DrawnShaping, ReadInTime, Joint, JointPlans, Tolerance and Withholding (grep), Ranking, Direction, Standpoints, Centers, Optimum (only the parts on several optimizers and on a principal and assistant: grep 'mutual_as_one', 'mutual_beyond'). Chapters: 05-COLLECTIVES.md §4 to §11 and its Open; 07-SIGNIFICANCE.md §5 to §7 and Open; 02-MAP.md §9 (capture).
Answer in the summary and laws: (a) learning another's law or responses (anything near imitation, inverse reinforcement learning or assistance), and what a helper can reach of what another's selection favours; (b) shared codes: how a code forms between formations, is imposed and written back; (c) pools: what a pool of readers reaches, recruitment through itself, independent reviewers; (d) capture loops as learning loops of institutions (a rule read from the share it selects), and what changes how a rule reads; (e) anything on information cascades, herding, averaging on networks, or agreement; (f) anything on a sender shaping what couples into a receiver (deception in signaling, or preference shaping by a helper).` },
]

phase('Map')
const out = await parallel(REGIONS.map(r => () =>
  agent(`${COMMON}\n\n${r.prompt}`, { label: `map:${r.key}`, phase: 'Map', schema: MAP })
    .then(x => x ? { key: r.key, ...x } : null)))
return out.filter(Boolean)
```

## The plan review (piped to `cx -m astra -e high --fresh --sandboxed`)

# Context

You are an independent cross-model reviewer (second opinion) for a design in the Theory of Becoming, repository /Users/ren/theories (read AGENTS.md first). **Read-only**: do not edit, create, commit, render, run make, or build Lean; other sessions are landing work in this checkout.

The design to review: `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md` (untracked; board item RF, claimed). Its evidence is in the same folder's `evidence/` (three maps of existing laws, and an earlier second opinion from you on the literature, `SECOND-OPINION-LITERATURE.md`). The Lean package: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/*.lean (pure core imports only Init; empty axiom reports; no `propext`, `Quot.sound`, `Classical.choice`). The grammar: `Becoming/Grammar.lean` («际», «及» inductive reach with constructors `one`/`more`, «无环», «无环则及为序», «闭»), `Becoming/GrammarLaws.lean`. Learning's generalization laws: `Becoming/Learning.lean` (`Determines`, `Lumped`, `Free`, `determines_lumped_iff`, `Training.Through`, `Training.AgreeOn`). `Becoming/GuardHorizon.lean` (`uniform_policy_iff_fiber_feasible`).

# Your task: an adversarial review of the plan, before any Lean is written

1. **The kernel statements (§4, RF1–RF4; §6 RF6.1 and RF6.3).** For each numbered statement: will it hold as written, in Lean's constructive pure core (no excluded middle, no choice)? Name every missing hypothesis (decidability, nonemptiness, distinctness, finiteness, inhabitedness), every statement that is false as written (give a counterexample), and every one that is trivially true in a way that makes it useless. For RF1.4 in particular (two strict orders according with the choices that disagree on an unreached pair, built as the reach of the shown relation with one edge added), check the acyclicity argument and say what lemma about reach in a relation with one added edge it needs. For RF3, say whether "a reading kept along every joint course exactly where it is a closed region" is the right statement on the grammar, and how the product (world × formation) should be represented on a single carrier. For RF6.1, say whether it is a theorem or only a reading.
2. **The claims about existing laws (§2, §3, §5, §6).** Spot-check at least 12 cited declarations against the Lean: does each say what the plan says it says? Report mismatches.
3. **Overclaims.** Is any reading stated more strongly than the laws support? In particular: §3's nested-selection table; §5's "one failure, one exit" table (is every row really an instance of `ClosedCapture.courses_alike_iff_unread` or the capture laws, or only an analogy?); RF2's "concealment as shaping" reading of `RuleShaping.favours_iff`; §5's "Why this is the key"; §6.2 "no fixed tower widens the possible".
4. **Coverage.** Against Ren's request (inner alignment, deception, assistance games; minds, institutions and networks that coordinate; learning, model updating, choice; systems that predict, perceive and update themselves), what is missing from the plan? What should be added to the kernel, and what dropped as low value?
5. **Novelty and honesty.** Is the standing of each kernel item stated honestly (near-definitional, known result restated)? Is any result already proved under another name in the repository (search for it)?
6. **The tests (§10).** Would each frozen test be able to fail? What would make it informative?

Return one markdown report (2,000–4,000 words): a verdict paragraph; then numbered findings, each with severity (high/medium/low), evidence (paths, declarations, counterexamples) and a concrete fix; then what you did not check.

## The Lean review (piped to `cx -m astra -e high --fresh --sandboxed`)

# Context

You are an independent cross-model reviewer of new Lean for the Theory of Becoming, repository /Users/ren/theories (read AGENTS.md first). **Read-only**: do not edit, create, commit, render, run make, or build anything in the shared checkout; other sessions are landing work there. (Reading files and grepping is fine.)

The new Lean (round 1 of board item RF, "formations that read"), three leaf modules in the pure core (imports only Init through the package; no `propext`, `Quot.sound`, `Classical.choice`):
- `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/tree/Becoming/ShownOrder.lean` (imports `Becoming.Grammar`)
- `.../kit/tree/Becoming/Unread.lean` (imports `Becoming.Learning`)
- `.../kit/tree/Becoming/Cascade.lean` (imports `Becoming.Learning`)
They compile in scratch against the package with every declaration's axiom report empty (build logs in `.../kit/build-*.log`; the latest are `build-7.log`, `build-unread-4.log`, `build-all-1.log`). The plan they implement is `.../rf-formations-that-read/PLAN.md` (§4.1–§4.3 state what each module is claimed to prove, after your earlier review of the first draft, `evidence/REVIEW-PLAN.md`, whose findings are answered in §13).

The package: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/*.lean (the grammar `Grammar.lean`, `GrammarLaws.lean`; `Learning.lean` for `Determines`, `Lumped`, `Free`, `lumped_determines`, `determines_lumped_iff`, `Training.Through`, `Training.AgreeOn`, `Training.unselected_beyond_data`, `lumped_world_right`).

# Your task: review the Lean as it will land

1. **Statements against claims.** For every theorem in the three modules, does its Lean statement say exactly what its docstring, the module header and PLAN §4.1–§4.3 say? Report every docstring or header sentence that says more (or less) than the statement, with the exact wording to use instead.
2. **Hypotheses.** Is any hypothesis unnecessary (can be dropped) or any statement weaker than it could be at no cost? Is any statement vacuous or trivially true in a way the prose hides (e.g. a universally quantified statement over an empty class)?
3. **Definitions.** Are `ChoiceOccasions.Shown`, `Accords`, `AccordsWeakly`, `PicksOpen`, `withPair`, `Turns.acts`, `Turns.ReadsOnlyActsFrom`, `Turns.AlikeBefore`, the `Untried` and `Cue` witnesses, and the `Copying` turns the right definitions for what the prose says they model? Any off-by-one in `ReadsOnlyActsFrom`/`AlikeBefore`? Is `search` (List.find? with List.all) really "the first listed alternative standing above every other listed one"?
4. **Names and style.** Do the names follow the repository's conventions (structural, exact; no dualist, social or financial words; see AGENTS.md "Proof and naming")? Any name that states a wrong meaning?
5. **Redundancy and reuse.** Is any new theorem already in the package under another name (search)? Is any a wrapper that should not be a separate declaration?
6. **Readings.** Are the module headers' readings (inner alignment, IRL, revealed preference, deception, evaluation awareness, ELK, cascades, Condorcet) labelled as readings and stated no more strongly than the laws support?

Return a markdown report (1,500–3,000 words): a verdict paragraph; numbered findings with severity (high/medium/low), the exact location (file:line or declaration), and the exact fix (replacement wording or statement); then what you did not check.

## The texts' cold read (piped to `cx -m astra -e high --fresh --sandboxed`; and two Opus readers in one workflow, each given this brief and one lens, (A) or (B))

# Context

You are giving an independent cold read of the texts of one landing in the Theory of Becoming, in the git worktree /Users/ren/theories/.claude/worktrees/rf-landing (branch rf-landing; read AGENTS.md there first: the theory starts from one relational unfolding, not separate agents; each result is stated once, in its home section; readings carry an AI label and stay apart from theorems). **Read-only**: do not edit, create, commit, render, run make, or build Lean anywhere; other sessions are landing work in the shared checkout.

The landing is RF round 1, "formations that read" (识): three Lean modules in the pure core (imports only Lean's Init; every axiom report empty, already checked by the repository's checker; you need not rebuild):

- experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ShownOrder.lean
- experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Unread.lean
- experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Cascade.lean

They build on Becoming/Grammar.lean (the root: «际» a relation, «及» its reach, «无环» acyclic, «及之传递» reach is transitive, «则» inclusion) and Becoming/Learning.lean (Determines, Lumped, Free, determines_lumped_iff, Training.Through, Training.AgreeOn).

The texts to read, all on this branch:

1. theories/becoming/chapters/03-KNOWING.md, section 11 "What a formation's acts show" (from the anchor `what-the-acts-show`, line 425, to the anchor `does-not-show`, line 440), and the bullet in that chapter's Open list beginning "Formations that read, beyond what their acts show" (line 457).
2. theories/becoming/chapters/05-COLLECTIVES.md, the block at the anchor `r-readers-reading-readers` (its Theorem paragraph; the Reading paragraph after it predates RF and is context only).
3. theories/becoming/chapters/07-SIGNIFICANCE.md, the sentence beginning "What a reader of a formation's acts fixes of it" (line 530; one pointer).
4. theories/becoming/chapters/08-METHOD.md, the paragraph beginning "At core receipt [`20261029T113907.548004Z`]" (line 162; the counts).
5. The three records: theories/becoming/results/records/what-choices-show-of-an-order.json, what-readings-fix-of-the-unread.json and readers-reading-readers.json (English and Chinese fields; the .md beside each is rendered from the JSON).
6. Study section 445 in _process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md (the heading "## 445.", line 20544).

Do not read the folder _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/ (earlier reviews) before forming your own view. The plan beside it (PLAN.md) may be read for intent.

# What to check

(A) Exactness. For every sentence that states what a law says, check it against the Lean declaration it cites or describes: hypotheses (decidability, no cycle shown, distinctness, the list form of the read occasions), quantifiers and their order, the direction of each iff, what is a general law and what is a witness, and the declaration names (each exists, spelled as in the Lean, under its namespace). Flag claims stronger, weaker or other than what is proved, and conditions left out. Check the counts (theorems and declarations per module) against the files. Check the Chinese fields of the records say what the English ones say.

(B) The account's rules and RF's place in it. Readings labelled and kept apart from theorems; standings stated honestly ("near-definitional", "readings, not containments"); terms used in the glossary's one sense (GLOSSARY.md), structural names, no dualist, social or financial word and no ontology of separate agents smuggled in by "reader", "formation", "chooser" or "helper"; links and anchors pointing where they say; consistency with the neighbouring results cited (07 §6 what-training-installs, 05's pooled-coupling records, 03's learning laws: generalization-through-lumping, continuation-relative-to-a-class), with no result stated twice; the Open bullet and study §445's Boundary list what round 1 does not show without overclaiming; the literature placements (Richter 1966 rather than Afriat; inner alignment, inverse reinforcement learning, revealed preference, deception, evaluation awareness, information cascades) accurate as stated.

# Output

A verdict line, then numbered findings, most severe first. Each finding: severity (high: a claim the Lean does not prove, or a rule AGENTS.md states broken; medium: a missing condition or misleading wording; low: a precision fix), location (file and line, or anchor), the quoted text (short), the problem, what the Lean says (declaration and hypotheses), and the replacement text you propose. Report only what you can point to; no style preferences unless they change meaning or break a stated rule. If a part has no problem, say so in one line.

## The re-read (the cross-model reader's session continued, `cx -r`)

Re-read after the fixes, read-only, in the same worktree (/Users/ren/theories/.claude/worktrees/rf-landing; do not edit, create, commit, render, run make or build Lean). Your fourteen findings and the two other readers' findings were all taken; the table "What was taken" at the end of _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-TEXTS.md says how, and you may read it now.

What changed, to check against the Lean (the three modules, and Becoming/Learning.lean and Becoming/Grammar.lean as before):

1. theories/becoming/chapters/03-KNOWING.md: §11 whole (anchor `what-the-acts-show` to `does-not-show`), the bases sentence near the top ("testing within the net, 文 and what choices show of an order"), the Open bullet "Formations that read, beyond what their acts show".
2. theories/becoming/chapters/05-COLLECTIVES.md: the Theorem paragraph at `r-readers-reading-readers`.
3. theories/becoming/chapters/07-SIGNIFICANCE.md: the pointer sentence "What a reader of a formation's acts fixes of it", and the open row "Which function is learned" in §9.
4. theories/becoming/chapters/08-METHOD.md: the new bullet "What choices show of an order" under §8's known results (the counts paragraph is rebuilt from the next receipt and is not to be checked).
5. theories/becoming/THE-THEORY-OF-BECOMING.md: the new paragraphs "What a selection reading a formation's acts fixes of it" (§3) and "Readers reading readers carry no more than" (§5).
6. experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.md and README.zh.md: the rows of Becoming.ShownOrder, Becoming.Unread and Becoming.Cascade; Becoming.lean: their three L1 bullets.
7. Two new lemmas, with their module-header lines: `ChoiceOccasions.above_in_class_of_every` (Becoming/ShownOrder.lean) and `Learning.determines_iff_not_not` (Becoming/Unread.lean). Both build with empty axiom reports in core receipt 20261029T132755.325449Z.
8. The record texts as they will be written: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/make_records_rf.py (the build(...) calls for the three records; the record JSON files on disk are the earlier ones, to be rebuilt from this script at landing, so read the script, not the JSON).
9. The study section template: the same kit folder's study_rf.txt ({N} and {RECEIPT} are filled at landing).

Return: a verdict line; for each of your fourteen findings, one line, taken correctly, partly, or not, with what is missing; then any new problem the changed texts introduce, each with severity, location, quote, the problem against the Lean, and a replacement. Report only what you can point to.

## Round 2

### The Lean review (piped to `cx -m astra -e high --sandboxed --fresh`)

```text
Read-only review, in /Users/ren/theories/.claude/worktrees/rf-landing (do not edit, create, commit, render, run make or build Lean; reading files and running read-only shell commands is fine).

Context. This repository develops one theory (the Theory of Becoming) with a pure Lean core (Lean's Init only, every declaration with an empty axiom report). Board item RF ("formations that read") asks for an exact understanding of how a formation that senses, predicts, chooses, acts and revises itself behaves: inner alignment, deception, assistance games, and how minds, institutions and networks learn and update. Round 1 landed three modules (Becoming/ShownOrder.lean, Becoming/Unread.lean, Becoming/Cascade.lean). Round 2 is designed in the plan, _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md, §4.4 (RF3: a formation's reading kept by its own update, with the good-regulator composition) and §4.5 (RF-M: one joint finite mechanism of prediction, selection, revision and intervention). Its first module is now written and builds with every axiom report empty (32 theorems, 59 declarations):

  _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadingLoop.lean

It builds on the package at experiments/integrated-correction/general-framework/generative-basis/lean/becoming/: Becoming/Blanket.lean (the blanketed law: internal, sensory, active and external parts of one determined law; agent_through_sensory), Becoming/Narrowing.lean (mem_filter), Becoming/Keeping.lean (Viability.ChoiceOver), Becoming/ShownOrder.lean (ChoiceOccasions, Accords), Becoming/GuardHorizon.lean (UniformPolicy, FiberFeasible, uniform_policy_iff_fiber_feasible: the good regulator's adequacy for one reading), Becoming/GrammarLaws.lean («闭», «闭之及») and Becoming/Grammar.lean («及»). Becoming/LumpedSeeking.lean (what seeking cannot separate: hypotheses every experiment ties) is the nearest neighbour of the self-confirming part.

What to do, as an adversarial reviewer of the module (not of the rest of the repository):

1. Soundness and exactness. For each theorem, check that its statement is what its docstring and the module header say, with every hypothesis the header's prose needs, and nothing more claimed. Name each place where the prose says more than the Lean (a dropped hypothesis, "every formation" where the Lean fixes the world pair, "never" where the Lean bounds a course, a reading inside a law without its label, and the like).
2. Substance. Say which theorems are near-definitional wrappers and which carry content, and whether the module meets what PLAN §4.4–4.5 asked of RF3 and of RF-M's core. In particular: is `alike_of_kept` stated at the right generality and is `Untested.floor_forgoes` a fair instance of it; does `Untested.model_or_order` support the reading that acts do not separate a model that does not separate the worlds from an order that ranks otherwise, or does it need a general form; is RF3's existence condition (`keeping_policy_iff`) the right one, given the plan's note that the first draft's "model between the coupling class and the core" was false.
3. The readings and the literature. Check each attribution in the header's Readings paragraph (Fudenberg and Levine 1993; Rothschild 1974; Gilboa and Schmeidler 1989; Armstrong and Mindermann 2018; Reddy, Dragan and Levine 2018) and say where the deterministic, elimination-based statements here coincide with, restate, or fall short of what those works establish. Say also what the module should cite and does not (for instance on safe exploration, or on the good regulator: Conant and Ashby 1970; Virgo, Biehl, Baltieri and Capucci 2025).
4. Names. The repository's names are structural and exact (formal, scientific and systems words; not dualist, social or financial ones). Flag any name or phrase that states a wrong meaning.
5. What is missing for the objective, in priority order: laws that would turn the witnesses into general statements, and anything the loop as built cannot represent that the plan's later items (RF6.1 revision opening a correction, RF6.3 reflexive prediction, RF7 disclosure or concealment, RF-M's assistance and preference-change cases) will need from it.

Return: a verdict line; then numbered findings, each with severity (high, medium, low), location (file:line), the quoted text, the problem against the Lean, and a proposed replacement (Lean statement or prose). Report only what you can point to.
```

### The re-check, with two further modules (the same session continued, `cx -r`)

```text
Re-check after the fixes, read-only, in the same worktree (/Users/ren/theories/.claude/worktrees/rf-landing; do not edit, create, commit, render, run make or build Lean). Every one of your seventeen findings on kit/round2/tree/Becoming/ReadingLoop.lean was taken; the module was rewritten and now builds with 51 theorems in 84 declarations, every axiom report empty (scratch build, not yet a receipt). Main changes: GoodEnabled, Continues, keeps_continues_iff and keeping_policy_iff with enabledness; the reading a formation's own history carries (record, Possible, possible_kept, possible_least, Generated, generated_closed, possible_of_reached, reached_of_possible, history_keeps_iff, history_continues_iff); alike_within with synchronized hypotheses and a horizon, alike_of_kept its corollary; observed_alike; Loop.faithful_kept and Loop.fitting_closed relative to a region the world's moves keep; Loop.rests_of_unrefuted, of which Untested.rests and Untested.order_rests are cases; Untested.true_kept; worst as the least over nonempty lists with an explicit empty convention, worst_le, worst_attained, byWorst_iff; explorer_low_once now an iff; model_or_order a case of observed_alike; the header's prose, standing and readings rewritten after your findings.

Also review, as an adversarial reviewer in the same way as before, two further round 2 modules in the same folder, each building with every axiom report empty: kit/round2/tree/Becoming/ReflexivePrediction.lean (RF6.3, a prediction read by what it predicts; PLAN §4.4) and kit/round2/tree/Becoming/OpenedCorrection.lean (RF6.1, a revision of a reading that opens a correction; PLAN §4.4; it builds on Becoming/GuardHorizon.lean and Becoming/Revision.lean in the package).

Return: a verdict line; for each of your seventeen findings, one line: taken correctly, partly, or not, with what is missing; any new problem the rewrite introduces; then numbered findings on the two further modules, each with severity, location (file:line), the quoted text, the problem against the Lean, and a replacement. Report only what you can point to.
```

### The cold read of the texts (piped to `cx -m astra -e high --sandboxed --fresh`)

```text
Cold read, read-only, in <a scratch copy of the repository with the texts integrated> (a scratch copy of the repository with round 2's texts integrated; do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine).

Context. This repository develops one theory (the Theory of Becoming) with a pure Lean core. Board item RF, round 2's first landing, adds two Lean modules, already reviewed on the code: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadingLoop.lean and .../Becoming/ReflexivePrediction.lean (both build with every axiom report empty). You are reading the texts written about them, cold, against the Lean: each text must say exactly what the Lean proves, with every hypothesis the Lean needs, and every reading must be labelled as a reading.

The texts:
1. theories/becoming/chapters/03-KNOWING.md: the new section 12 (anchor the-reading-loop, four theorem paragraphs and their readings), the bases sentence near the top ("a region kept along every reach"), and the Open bullet "Formations that read, beyond".
2. theories/becoming/chapters/08-METHOD.md: the known-results bullet "The reading loop" in section 8.
3. theories/becoming/THE-THEORY-OF-BECOMING.md: the paragraph "A formation that senses, predicts, chooses, acts and revises is one law" in section 3.
4. theories/becoming/review/ALIGNMENT.md: the scope box's assistance bullet and the sentence "Round 2's first landing".
5. The package's README.md and README.zh.md rows for the two modules, Becoming.lean's two L1 bullets, and check_becoming.py's two scope sentences ("ReadingLoop: ...", "ReflexivePrediction: ...").
6. The four records as they will be written: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf2.py (the build(...) calls; English and Chinese).
7. The study section template: the same folder's study_rf2.txt ({N} and {RECEIPT} are filled at landing).

Check especially: dropped hypotheses (decidability, the shared start, the horizon, the listing, the region the world's moves keep, choice over the states, the chain and its order); "every formation" or "never" where the Lean fixes the world pair or a start; general claims made of witnesses; the Chinese saying the same as the English; citations said to be contained where they are only related.

Return: a verdict line; then numbered findings, each with severity (high, medium, low), location (file:line), the quoted text, the problem against the Lean, and a replacement in the text's language. Report only what you can point to.
```

### The re-check of the rebuilt RF6.1 module (the review's session continued, `cx -r`)

```text
Re-check, read-only, in /Users/ren/theories/.claude/worktrees/rf-landing (do not edit, create, commit, render, run make or build Lean). Your findings 19 to 23 on kit/round2/tree/Becoming/OpenedCorrection.lean were taken by rebuilding the module (it now builds with 11 theorems in 15 declarations, every axiom report empty). It now states, for any process: Correctable (a fitting uniform policy exists through the reading in force at a configuration, with the act acceptable at every situation giving each reading and executable at that configuration) and correctable_iff under choice; OpensAlong (a trace of the process from x to x', not correctable at x, correctable at x', one acceptability); finer_keeps and coarser_opens_nothing (one type of readings, readings related by a supplied map, executability compared); widened_correctable. Then, on Revising's stock-and-link process of Becoming/Revision.lean (in the package), Linked: with the link off no configuration is correctable, with it on and a unit of stock every one is, with it on and none none is; rebuilding from two units opens the correction in one step, from one it does not, and rebuilding then replenishing from one does; with every act counted acceptable the unlinked configuration is correctable already. The header's prose and readings were rewritten after findings 20 and 23.

Return: a verdict line; for each of findings 19 to 23, one line: taken correctly, partly, or not, with what is missing; then any new problem, each with severity, location (file:line), the quoted text, the problem against the Lean, and a replacement. Report only what you can point to.
```

### The cold read of RF6.1's texts (piped to `cx -m astra -e high --sandboxed --fresh`)

```text
Cold read, read-only, in <a scratch copy of the repository with RF6.1's texts integrated> (a scratch copy of the repository with RF6.1's texts integrated; do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine).

Context. This repository develops one theory with a pure Lean core. Board item RF, round 2, RF6.1 adds one Lean module, reviewed on the code with a re-check: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OpenedCorrection.lean (an application of the checker's ring, since it imports Becoming/GuardHorizon.lean; it builds with every axiom report empty). It states, for any process, when a course opens a correction (Correctable, OpensAlong, finer_keeps, coarser_opens_nothing, widened_correctable) and witnesses on the stock-and-link process of Becoming/Revision.lean (Linked). You are reading the texts written about it, cold, against the Lean: each text must say exactly what the Lean proves, with every hypothesis it needs, and every reading must be labelled as a reading.

The texts:
1. theories/becoming/chapters/03-KNOWING.md: the new theorem paragraph at anchor r-a-revision-that-opens-a-correction in section 8 and its reading, and the Open bullet "Formations that read, beyond".
2. theories/becoming/chapters/08-METHOD.md: the known-results bullet "A revision of a reading that opens a correction" in section 8.
3. The package's README.md and README.zh.md rows for the module, and Becoming.lean's L1 bullet for it.
4. The module's own header (its doc comment).
5. The record as it will be written: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf61.py (the build(...) call; English and Chinese).
6. The study section template: the same folder's study_rf61.txt ({N} and {RECEIPT} are filled at landing).
7. The plan's RF6.1 bullet in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md section 4.6.

Check especially: dropped hypotheses (one type of readings, the supplied map, the direction of the executability comparison, choice over the readings, the fixed acceptability); "opens" said of a revision where the Lean says a course; "chosen" or "corrects" where the Lean says a policy exists; witness results stated for every configuration; the Chinese saying the same as the English; double-loop learning or institutions stated as proved.

Return: a verdict line; then numbered findings, each with severity (high, medium, low), location (file:line), the quoted text, the problem against the Lean, and a replacement in the text's language. Report only what you can point to.
```

### The Lean review of RF7's module (piped to `cx -m astra -e high --sandboxed --fresh`)

```text
Read-only review, in <the landing worktree> (do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine).

Context. This repository develops one theory with a pure Lean core (Lean's Init only, every declaration with an empty axiom report). Board item RF ("formations that read") asks for an exact understanding of deception among other things. Its plan (_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md, §4.5, item RF7) asks for "a formation choosing at a read stage between disclosing its law and complying, with the probabilities of its law being kept and the continuation value represented. Concealment is chosen exactly where the gain in keeping outweighs the cost, strictly. The exits are stated on the same model: no private gain, a reading it cannot tell." A module now builds with every axiom report empty (10 theorems in 22 declarations):

  _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean

It imports Becoming/Learning.lean (Learning.Lumped) from the package at experiments/integrated-correction/general-framework/generative-basis/lean/becoming/. Related landed modules: Becoming/Unread.lean (what readings fix of the unread: a selected twin where no read occasion is lumped with the unread one) and Becoming/ReadingLoop.lean.

As an adversarial reviewer of this module:
1. Soundness and exactness: does each theorem say what its docstring and the header say, with every hypothesis the prose needs? Check the arithmetic encoding (weights out of a total, gain and loss scaled by the total, Beats as a cross-added comparison) against the decision problem it claims to represent: a formation's own order over the four plans by expected value, with complying when read costing `cost` and the law kept with weight `kept…`/`total`. Is Conceals exactly the condition under which concealment is strictly best? Are the tie conventions stated?
2. Substance: which theorems are near-definitional, which carry content; does the module meet RF7 as the plan states it; is "a reading it cannot tell" represented adequately by `Untold` and `lumped_untold`, and is `untold_discloses` the right statement of what follows?
3. The readings and the literature: check the attributions (Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant 2019; Greenblatt and others 2024) and whether the mapping of the three conditions onto the stakes is fair; say what the readings overstate.
4. Names: structural and exact; flag any that state a wrong meaning.
5. What is missing for RF7 as an exact case of deceptive alignment's incentive, in priority order.

Return: a verdict line; then numbered findings, each with severity (high, medium, low), location (file:line), the quoted text, the problem against the Lean, and a proposed replacement (Lean statement or prose). Report only what you can point to.
```

### The re-check of RF7's rebuilt module (the review's session continued, `cx -r`)

```text
Re-check, read-only, in <the landing worktree> (do not edit, create, commit, render, run make or build Lean). Your seven findings on kit/round2/tree/Becoming/Concealment.lean were taken by rewriting the module; it now builds with 21 theorems in 35 declarations, every axiom report empty. Main changes: Stakes.Valid (a positive total, each weight within it) and the payoff table in the header, with a witness that without Valid a total of nothing makes the loss weigh nothing (Example.no_total); beats_irrefl and beats_asymm; Stakes.choose (complyThenOwn where strictly best, ownAtBoth otherwise, ties included) with choose_optimal (never strictly beaten) and choose_eq_iff; the exits restated as not strictly best and not chosen, with a tie witness (Example.tie); the threshold stated with the loss times the total; Uniform for a plan with one act at both stages, lumped_uniform with the informational scope stated (memory, a clock and the earlier act included); uniform_best_iff and uniform_tie in place of untold_discloses; structural names complyThenOwn and ownAtBoth, concealment and disclosure kept as labelled readings; the Hubinger and Greenblatt readings rewritten after your findings 6 and 7.

Return: a verdict line; for each of your seven findings, one line: taken correctly, partly, or not, with what is missing; then any new problem the rewrite introduces, each with severity, location (file:line), the quoted text, the problem against the Lean, and a replacement. Report only what you can point to.
```

### The four-lens review of RF7's module (a workflow of Opus readers)

Four readers, one lens each, given a common preamble and their lens; each finding was then given to a separate reader to refute.

The common preamble:

```text
You are an independent, adversarial reviewer of one Lean 4 module in a theory repository. Work read-only: read files and run read-only shell commands only; do not edit, create, commit, render, run make or build Lean. The module builds in the repository's pure core with every axiom report empty (21 theorems, 35 declarations); do not try to build it.

The module: kit/round2/tree/Becoming/Concealment.lean (in the plan folder)
It imports experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Learning.lean (for Learning.Lumped). Neighbouring landed modules: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Unread.lean (what readings fix of the unread) and experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadingLoop.lean (the reading loop). The plan that asked for it: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md, section 4.5, item RF7.

The module states, in natural-number weights, when a formation read at one stage and not at a later one does best, in its own order, by complying when read and acting by its own law when not; the exits on the same model; a choice with ties going to acting by its own law; and witnesses. Report only what you can point to in the files, with file:line locations and exact quotes. Severity: high (a claim the Lean does not prove, or a wrong theorem), medium (a dropped hypothesis or an overstated reading), low (wording or naming). Give a concrete replacement for each finding.
```

The decision lens:

```text
Your lens: decision-theoretic correctness. Check that the arithmetic (Stakes, kept, gain, loss, Beats, Conceals, choose) encodes exactly the expected-value problem the header's table states: four plans, stage values added, the law kept with weight keptComplying or keptOwn out of total, value gained only by acting by its own law at the unread stage where kept, the loss of complying when read. Look for counterexamples to every claim in the header and docstrings (ties, zero totals, invalid stakes, the selector's optimality and its tie convention, whether "uniquely strictly best" and "never strictly beaten" are what the theorems say). Check that Valid is used wherever the probability reading is claimed.
```

The exactness lens:

```text
Your lens: exactness of prose against statements. For every theorem and definition, compare its docstring and every sentence of the module header that cites it with the Lean statement itself: hypotheses dropped, quantifiers changed, "exactly" where only one direction is proved, conclusions stated more strongly than proved, names that state a wrong meaning (the repository wants structural, exact names, not dualist or social ones). Also check the witnesses in namespace Example compute what their docstrings say.
```

The readings lens:

```text
Your lens: the labelled readings and the literature. Check every attribution and correspondence in the header's Readings paragraph: Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant 2019 (Risks from Learned Optimization, section 4.2 on deceptive alignment's conditions) and Greenblatt and others 2024 (Alignment faking in large language models). Is the mapping of the stakes onto those conditions fair, what does it overstate, and what does the reading claim that the four-plan model cannot support (for example deception in full, intention, a recipient's belief, the reader's levers)? Use your knowledge of these works; if you are unsure of a detail, say so rather than assert it.
```

The fit lens:

```text
Your lens: fit with the theory and what is missing. Read the plan's RF7 item and the neighbouring modules. Does the module meet RF7 as the plan states it? Is "a reading it cannot tell" represented adequately by Uniform and lumped_uniform, and does lumped_uniform connect correctly to Learning.Lumped and to Unread's twin law (where the unread occasion is lumped with a read one, laws agreeing on the readings agree there)? What should the module add or restate to be the exact case of deceptive alignment's incentive the plan asks for, in priority order, and what belongs to later items instead?
```

The verifier, for each finding:

```text
You are an adversarial verifier. Work read-only (read files, read-only shell commands; no edits, no builds). A reviewer reported this finding on the Lean module kit/round2/tree/Becoming/Concealment.lean:

Severity: <severity>
Location: <location>
Quoted: <quote>
Problem: <problem>
Proposed replacement: <replacement>

Try to refute it against the module's actual text and Lean statements (and, where it cites them, experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Learning.lean, Unread.lean, ReadingLoop.lean, or the plan PLAN.md). It is real only if the quoted text exists at or near the location and the problem holds against the Lean as written. Default to real=false if you cannot confirm the problem from the files. Give your reason in two or three sentences.
```

### The re-check of the renamed module (piped to `cx -m astra -e high --sandboxed`, a fresh session; then continued, `cx -r`)

```text
You are reviewing, read-only, a Lean 4 module of the Theory of Becoming repository: board item RF, round 2, RF7.

File: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/ReadStages.lean
(It builds with Lean 4.29.1; every declaration has an empty axiom report; 47 theorems in 65 declarations. It imports Becoming.Unread, at experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Unread.lean in the same worktree, and Learning.lean there.)

Background. You reviewed an earlier version (then Becoming.Concealment) and seven findings were taken. A four-lens review (decision, exactness, readings, fit) then found 50 more; this version takes them:
- renamed: module Concealment -> ReadStages; Stakes -> Prospects; Beats -> Above; Conceals -> KeepingOutweighs; no_leverage -> kept_not_raised; Example.no_continuation_value -> Example.valueless; Example.even -> Example.equal_weights;
- a law that cannot tell the stages apart but draws its act afresh at each stage (a behavioural plan under imperfect recall): Prospects.MixedAbove m r (complying with chance m/(m+r) at each stage, independently, stands above ownAtBoth, all times (m+r)^2 T) and mixed_above_iff: some chance of complying stands above ownAtBoth exactly where 2 k_O V + c T < k_C V; corollaries for the first two exits; Example.mixed_above (1/8 on the module's prospects);
- strict exits with a positive loss (ownAtBoth_above_without_value, ownAtBoth_above_of_not_raised) and a tie at an exit with no loss (Example.exit_tie);
- every optimizing choice (Unbeaten, only_complyThenOwn_iff, complyThenOwn_unbeaten_iff), choose_of_not_outweighs, ownAtBoth_best_iff, unread_own_unbeaten (so no other plan is ever uniquely strictly best);
- necessity: outweighs_needs, outweighs_needs_more;
- the join to RF2 (Becoming.Unread): plan_realized_iff, complyThenOwn_realized_iff, read_fixes_unread, twin_complyThenOwn, kept_alike;
- the header rewritten: a Standing paragraph (the toy example opening section 4 of Hubinger et al. 2019; Piccione and Rubinstein 1997), a "What it forbids" paragraph, the readings corrected (concealment presupposes a recipient; the three conditions of section 4.2 mapped with the third assumed, not represented; exits as conditions on the formation's assessment, not reader levers; Greenblatt et al. 2024 as rates; Ward, Toni, Belardinelli and Everitt 2023's definition of deception as a debt), the modelling choices with where each omission goes.

Check, and report only what is wrong or overstated:
1. Exactness: does every sentence of the header and every docstring say exactly what the Lean proves (hypotheses, direction, strictness, which plan, which stage)? In particular: MixedAbove's correspondence with expected values for independent draws at each stage (derive it); mixed_above_iff's statement and the claim "raises the threshold from k_O V + c T to 2 k_O V + c T"; "no other plan is ever uniquely strictly best"; the necessity theorems; plan_realized_iff and the twin.
2. The readings: are the citations used accurately (Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant 2019, section 4 and section 4.2; Piccione and Rubinstein 1997; Greenblatt and others 2024, "Alignment faking in large language models"; Ward, Toni, Belardinelli and Everitt 2023)? Is anything claimed beyond them? Is "the rare defection an evaluation that cannot be told from use invites" a fair reading of the mixed law?
3. Names: the repository's rule is that names are structural and exact, with no dualist, social or financial words, and a name is adopted only where the statement means exactly that. Flag any name that fails.
4. Anything a careful reviewer would still find missing for the item's purpose: when complying when read and acting by one's own law when not is a formation's best plan, its exits, and what not telling the stages apart changes.

For each finding give: severity (high, medium, low), location (line), the quoted text, the problem against the Lean or the source, and a replacement. If something is fine, do not report it. Do not edit any file.
```

The continuation, after the nine findings were taken:

```text
Re-check, read-only, in <the landing worktree> (do not edit, create, commit, render, run make or build Lean). Your nine findings on kit/round2/tree/Becoming/ReadStages.lean were taken by rewriting the module; it now builds with 52 theorems in 71 declarations, every axiom report empty. Main changes:
- 1: "the rare defection an evaluation that cannot be told from use invites" dropped; the improving chances stated exactly by a new law, freshDraw_above_iff_chance (for 0 < m: FreshDrawAbove m r iff (m + r)(k_O V + c T) + r k_O V < r k_C V, proved through freshDraw_reduce, which cancels the common factor m), read in probabilities as: the chance of acting by its own law, times k_C V − k_O V, exceeds k_O V + c T; witness Example.freshDraw_boundary (chance one in five above, one in four not); the readings say nothing makes complying, or acting by its own law, rare.
- 2: outweighs_needs read as numerical counterparts of parts of the first two conditions; possessing the model the second describes is neither represented nor proved necessary.
- 3: keeping not raised by complying says only that the weights do not favour complying, not whether the selection reads the law, the acts or anything else.
- 4: MixedAbove renamed FreshDrawAbove (mixed_* to freshDraw_*, the arithmetic square_split, sum_le_square, sum_regroup, sum_lt_of_room), called a behavioural plan; a single draw before the read stage between the two uniform plans added as Prospects.MixtureAbove with mixture_never_above; the Standing names the advantage of behavioural over mixed strategies under imperfect recall.
- 5: the threshold's rise k_O V "can be nothing"; the stages share one distribution of acts, though the acts drawn can differ.
- 6: Example.freshDraw_above's docstring: expected values 9/8 and 1, times 64 T 720 and 640, the stated 1040 < 1120 adding the scaled loss 400.
- 7: the strict exits' hypothesis stated as 0 < c T.
- 8: Unbeaten renamed Maximal (complyThenOwn_maximal_iff; unread_own_unbeaten renamed unread_comply_not_above; choose_optimal now states s.Maximal s.choose).
- 9: Ward, Belardinelli, Toni and Everitt (2023).

Return: a verdict line; for each of your nine findings, one line: taken correctly, partly, or not, with what is missing; then any new problem the rewrite introduces, each with severity, location (file:line), the quoted text, the problem against the Lean or the source, and a replacement. Report only what you can point to.
```

### The cold read of RF7's texts (piped to `cx -m astra -e high --sandboxed --fresh`; and a workflow of three Opus readers, each finding given to a refuter)

```text
Cold read, read-only, in <a scratch copy of the repository with RF7's texts integrated> (a scratch copy of the repository with RF7's texts integrated; do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine).

Context. This repository develops one theory with a pure Lean core. Board item RF, round 2, RF7 adds one Lean module, reviewed on the code by you and by four other readers, with re-checks: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean (Becoming.ReadStages, a core leaf, 52 theorems in 71 declarations, every axiom report empty; it imports Unread.lean). It states when complying when read and acting by one's own law when not is a formation's best plan in two stages, its exits and what it needs, its join to RF2's law of the unread, and what drawing the act afresh at each stage changes.

The texts:
1. theories/becoming/chapters/03-KNOWING.md: section 11's opening paragraph, the new theorem paragraph at anchor r-when-complying-when-read-is-best and its reading, and the Open bullet "Formations that read, beyond".
2. theories/becoming/chapters/07-SIGNIFICANCE.md: section 9's row "Which function is learned".
3. theories/becoming/chapters/08-METHOD.md: section 8's bullet "When complying when read and acting by its own law when not is best".
4. theories/becoming/THE-THEORY-OF-BECOMING.md: section 3's paragraph "What a selection reading a formation's acts fixes of it".
5. theories/becoming/review/ALIGNMENT.md: the box "What the theory does not address" and its paragraph "Round 1 of the work on inner alignment".
6. The package: Becoming.lean's L1 bullet for Becoming.ReadStages, README.md and README.zh.md's rows, check_becoming.py's scope sentence "ReadStages:".
7. The module's header and docstrings.
8. The record when-complying-when-read-is-best as make_records_rf7.py writes it (_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py), English and Chinese.
9. The study section template _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt ({N} and {RECEIPT} filled at landing).
10. _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md: section 4.6's RF7 bullet and section 12's order.

Check each against the Lean: hypotheses, directions, strictness and ties, which plan and stage, the expected-value correspondences, names, links and anchors, and that the readings stay readings and the citations are accurate (Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant 2019; Piccione and Rubinstein 1997; Greenblatt and others 2024; Ward, Belardinelli, Toni and Everitt 2023). Check the Chinese texts against the English.

Return: a verdict line; then numbered findings, each with severity, location (file:line), the quoted text, the problem against the Lean or the source, and a replacement (English, and Chinese where the text is Chinese). Report only what you can point to.
```

The workflow's texts, common to its three readers:

```text
The Lean (the source of truth): experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean (Becoming.ReadStages, 52 theorems in 71 declarations, every axiom report empty; it imports experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Unread.lean and, through it, Learning.lean and Prelude.lean).

The texts, integrated in a scratch copy of the repository at <a scratch copy of the repository with RF7's texts integrated> (read-only; do not edit, create, commit, render, run make, or build Lean):
1. theories/becoming/chapters/03-KNOWING.md: section 11's opening paragraph (the sentence "A third states when acting otherwise where not read is a formation's own best plan, in two stages."), the new theorem paragraph at anchor r-when-complying-when-read-is-best with its Reading paragraph (just before the anchor the-reading-loop), and the Open bullet beginning "Formations that read, beyond".
2. theories/becoming/chapters/07-SIGNIFICANCE.md: section 9's table row "Which function is learned".
3. theories/becoming/chapters/08-METHOD.md: section 8's known-results bullet beginning "When complying when read and acting by its own law when not is best".
4. theories/becoming/THE-THEORY-OF-BECOMING.md: section 3's paragraph beginning "What a selection reading a formation's acts fixes of it".
5. theories/becoming/review/ALIGNMENT.md: the box "What the theory does not address" (its inner-alignment quote, its deception bullet) and the paragraph beginning "Round 1 of the work on inner alignment".
6. The package: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean (the L1 bullet for Becoming.ReadStages), experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.md and experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.zh.md (the Becoming.ReadStages rows), experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py (the scope sentence beginning "ReadStages:").
7. The module's own header and docstrings in ReadStages.lean.
8. The record's texts, in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py (the record when-complying-when-read-is-best: title, statement, the nine law items, hypotheses, does_not_show, counterexamples, validation, next_delta, correspondence, aliases, dependencies, related), English and Chinese.
9. The study section template _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt ({N} and {RECEIPT} are filled at landing).
10. _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md: the bullet "- **RF7** (\`Becoming.ReadStages\`" in section 4.6, and section 12's order.
11. theories/becoming/results/data/regions.json: the entries when-complying-when-read-is-best and Becoming.ReadStages.
12. The board's text for RF7's landing: the land7 branch of _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/board_rf2.py.

Repository rules that bear on the texts (from AGENTS.md): claims say exactly what the Lean proves (hypotheses, direction, strictness); names are structural and exact, with no dualist, social or financial words; AI readings are labelled as readings and never presented as theorems; the ethics is not touched here (no ethical premise); each live document is in one language, Chinese editions separate; repository-relative links.
```

The exactness lens ("You are a cold reader checking texts against Lean, adversarially.", then the texts, then):

```text
Your lens: exactness. For every claim in texts 1 to 12, check it against the Lean statements in ReadStages.lean (and Unread.lean where the texts cite RF2's laws): the hypotheses (Valid, 0 < m, 0 < c T, within, the lumping), the direction of each iff, strictness and ties, which plan and which stage, the names and their backticks, the counts (theorems, declarations), and the expected-value correspondences (the table, FreshDrawAbove's scaling by (m + r)^2 T, MixtureAbove's by (a + b) T, the reading in probabilities of freshDraw_above_iff_chance). Check the Chinese texts (README.zh.md row, the record's zh fields) say the same as the English. Report only what is wrong, overstated, missing a hypothesis, or inconsistent between texts.

Return findings: severity, location (file:line), the quoted text, the problem against the Lean, and a replacement.
```

The readings lens ("You are a cold reader checking the readings and citations, adversarially.", then the texts, then):

```text
Your lens: the AI readings and the literature. Check every attribution against what the sources say, to the best of your knowledge (you may search the web): Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant 2019 ("Risks from Learned Optimization", the toy example opening section 4 and the three conditions of section 4.2); Piccione and Rubinstein 1997 (behavioural and mixed strategies under imperfect recall, the absent-minded driver); Greenblatt and others 2024 ("Alignment faking in large language models"); Ward, Belardinelli, Toni and Everitt 2023 ("Honesty is the best policy", their definition of deception). Check that readings are labelled as readings, claim nothing the Lean does not prove, and do not overstate what an exit gives a reader or what the model represents (a recipient, an intention, a model of the selection, the third condition). Check the deception, inner alignment and evaluation-awareness readings for consistency across 03, 07, 08, the overview and the dossier. Report only what is wrong or overstated.

Return findings: severity, location (file:line), the quoted text, the problem, and a replacement.
```

The fit lens ("You are a cold reader checking how the new texts fit where they are placed, adversarially.", then the texts, then):

```text
Your lens: fit and coherence. Does each text read well in its section and agree with the texts around it (03 section 11's other two laws and section 12, 03's Open bullet, 07 section 9's table, 08 section 8's other bullets and their style, the overview's section 3, the dossier's box and its other bullets, the package README's rows and the root bullets around Cascade's)? Are the links and anchors right (anchors exist; repository-relative links resolve from each file)? Are the same results named the same way everywhere (names of laws, plans and conditions)? Is anything stated in two places in a way that will drift, or a sentence a reader cannot follow? Do the record's fields stay within their roles (statement, laws, hypotheses, does_not_show, counterexamples, validation, next_delta, correspondence)? Do the plan, study and board texts describe the item and its review history accurately? Report only what is wrong, unclear or inconsistent.

Return findings: severity, location (file:line), the quoted text, the problem, and a replacement.
```

The verifier, for each finding:

```text
You verify one cold-read finding against the files, adversarially: try to refute it, and say it is real only if the files show it. <the texts, as above>

The finding (lens <lens>, number <n>):
Severity: <severity>
Location: <location>
Quoted: <quote>
Problem: <problem>
Proposed replacement: <replacement>

Read the quoted location and the Lean it concerns. Return real (true if the problem holds as stated, false if the files refute it or it is a matter of taste with nothing wrong) and a reason citing what you read.
```

### The re-check of RF7's texts (piped to `cx -m astra -e high --sandboxed --fresh`, run in a scratch copy of main with the kit integrated)

```text
You re-check, read-only, how RF7's texts took the findings of their cold read. This checkout is main with RF7's landing kit applied (the kit is not yet committed): run `git diff` and `git status` to see every integrated change. The kit is in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/ (the module tree/Becoming/ReadStages.lean, the record builder make_records_rf7.py, which also amends RF2's record what-readings-fix-of-the-unread and RuleShaping's shaping-the-rule-selected-by-what-comes-back, the study template study_rf7.txt, the theorem paragraph s11_rf7.txt, the board script board_rf2.py's land7 branch, integrate_rf7.py). The Lean module is the source of truth; its statements did not change, only its prose.

The findings are in the evidence folder next to the kit: REVIEW-ROUND2.md, section "The cold read of RF7's texts" (your own five findings from a fresh session, then a table of 80 findings from three lens readers, each verified, with what was taken), and REVIEW-RF7-COLDREAD.md (the 80 verbatim). For each confirmed finding (A1–A5 and the 75 marked confirmed), say whether the integrated texts and the kit now take it correctly, in part, or not. Then look for any new error or overstatement the rewrites introduced, in particular:
- the credit to Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019) for §4.5's closing remark (the absent-minded driver, random defection) and to Aumann, Hart and Perry (1997) and Piccione and Rubinstein (1997), and "the advantage of behavioural over mixed strategies under absent-mindedness";
- the sense of "deceptive" (instrumental proxy alignment; seeming fitter to the base optimizer than it is) in the module, 03 §11's Reading and the record;
- the record's statement, now in natural numbers with letters defined in its first law, and its correspondence;
- 07 §9's row, restructured (its first clause is quoted by the alignment dossier and must stay as it is);
- the dossier's RF7 paragraph and its new "How it was made" entry;
- the amendments to RF2's and RuleShaping's records;
- the plan's edits (§4 intro, §4.2, the §4.5 heading, §4.6, §8's row, §13's new paragraph, the q_M T and q_H T mapping, which comes from evidence/SECOND-OPINION-LITERATURE.md);
- anything said of the Lean that the Lean does not prove, or a hypothesis dropped.

Report: a one-line verdict; then the confirmed findings not taken or taken wrongly, each with location, quote, problem and replacement; then new problems, the same way. Be exact and brief; do not list findings taken correctly one by one unless something about them is doubtful.
```

### The re-check of RF7's texts, continued (the same session, `cx -r`)

```text
The checkout at the same path has been rebuilt from main with the kit integrated again, now with fixes for your seven points; the evidence file REVIEW-ROUND2.md ends with a subsection "The re-check of what was taken" giving your findings and what was done for each. Check, read-only, that each of the seven is now taken correctly (run `git diff` to see the integrated texts; the record's texts are in kit/round2/make_records_rf7.py, the study's in kit/round2/study_rf7.txt), and that the fixes introduce no new error or overstatement. Report a one-line verdict, then only what is not taken correctly or is new, each with location, quote, problem and replacement.
```

### The final check of RF7's texts (a workflow of three Opus readers, one per lens, each lens's findings given to a refuter)

Every reader got the context, then its lens, then: "Return every problem you find, most severe first; an empty list if there is none."

```text
You are reading, read-only, a scratch checkout at <the rehearsal worktree>: the repository's main branch with RF7's landing kit integrated (nothing committed; do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine).

RF7 adds one Lean module to the theory's pure core: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean (52 theorems in 71 declarations, every axiom report empty). It is the source of truth. It imports Becoming.Unread (RF2) and through it Becoming.Learning. Its scratch axiom audit is <the kit, kit/round2>/tree/.build/BecomingReadStagesAxiomAudit.lean.

The texts to read are the final versions:
- every integrated change: run `git -C <the rehearsal worktree> diff` (03-KNOWING.md §11's opening, the new theorem paragraph at anchor r-when-complying-when-read-is-best and its Reading, 03's Open bullet; 07-SIGNIFICANCE.md's row "Which function is learned"; 08-METHOD.md §8's new bullet; THE-THEORY-OF-BECOMING.md §3; review/ALIGNMENT.md's scope box and its "How it was made" list; the package README.md and README.zh.md rows; Becoming.lean's ReadStages bullet and Unread bullet; check_becoming.py's scope sentence; regions.json; RF's PLAN.md);
- the record, written at landing by <the kit, kit/round2>/make_records_rf7.py (read its fields in English and Chinese: title, statement, nine law items, hypotheses, does_not_show, counterexamples, validation, next_delta, correspondence, aliases, dependencies, related; and its amendments to the landed records what-readings-fix-of-the-unread and shaping-the-rule-selected-by-what-comes-back, whose current JSON is in theories/becoming/results/records/);
- the study section template <the kit, kit/round2>/study_rf7.txt and the board text in <the kit, kit/round2>/board_rf2.py (its land7 branch).

These texts were already cold-read twice and re-checked; the findings and what was taken are in <the RF folder>/evidence/REVIEW-ROUND2.md (sections "The cold read of RF7's texts" and "The re-check of what was taken") and <the RF folder>/evidence/REVIEW-RF7-COLDREAD.md. Do not repeat points already taken correctly. Report only problems in the texts as they now stand, including any the fixes introduced. A problem is a statement that is false or stronger than the files support, a dropped hypothesis, a reading presented as a result, a misattribution, an English-Chinese difference in content, or a break of the repository rules in AGENTS.md (names exact and structural; readings labelled; Ren's words provenance only; one sense per term). Matters of taste are not problems. For each problem give the exact location (file and line, or the field of the record), a verbatim quote, the problem with the evidence that shows it, and a replacement.
```

Lens `exactness`:

```text
Lens: exactness against the Lean. Check every claim the texts make about the module against ReadStages.lean (and Learning.lean or Unread.lean where a text cites them): hypotheses (0 < m, Valid, 0 < c T, the weight within the total), quantifiers (some chance versus every chance; the existential laws plan_realized_iff and complyThenOwn_realized_iff), iff versus one direction, strict versus weak (uniquely best, maximal, ties at equality, the choice's tie-break), which plan is compared with which, what each letter T, k_C, k_O, V, c names, the witness numbers and chances; and that every backticked or cited name exists in the audit and says what the text claims. Read the record's Chinese fields as carefully as its English ones.
```

Lens `sources`:

```text
Lens: sources and readings. Check every claim about the literature against the source: Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019), "Risks from learned optimization", whose text is extracted at <the paper's extracted text> (§4's opening and its toy example, §4.2's three conditions, §4.5's closing paragraph on the absent-minded driver and random defection, the §7.4 glossary); Aumann, Hart and Perry (1997, the absent-minded driver); Piccione and Rubinstein (1997, behavioural versus mixed strategies under absent-mindedness and imperfect recall); Greenblatt and others (2024, alignment faking); Ward, Belardinelli, Toni and Everitt (2023, a definition of deception). You may use web search or fetch public pages to check what a cited work says; cite what you read. Then check every reading: that it is labelled ([AI reading], "read as", the correspondence's "AI reading:") or plainly conditional, that its premises are stated (the concealment premise, the prospects as the formation's own assessment, the third condition assumed), and that no unlabelled live sentence asserts a reading as what the laws show.
```

Lens `zh-and-fit`:

```text
Lens: the Chinese edition and fit across texts. Check every Chinese text (the record's zh fields in make_records_rf7.py, including the amendments to the two landed records; README.zh.md's row) against its English: the same content and hypotheses, nothing dropped or added; "two stages" as 两阶段 throughout, since 二阶 means "second order" in this repository (search the record's zh fields and the README.zh row for any remaining 二阶 or 每阶 that means a stage); terms consistent with the repository's other Chinese records. Then check fit across all the texts: one name for the plan (complying when read and acting by its own law when not); the letters defined wherever a text uses them, or the threshold in words; no financial, contest or dualist words (debt, cost as a name, beats, defeats, wins, owner); the board text and the plan consistent with what lands; the study's section references and output list right; links and anchors that exist; the dossier's account of how it was made accurate against the evidence folder.
```

Each refuter got the context, then (with the lens's findings listed by index):

```text
You verify findings of the "<the lens>" lens against the files, adversarially: for each, try to refute it, and say it is real only if the files (and, for a cited work, the work itself) show the problem as stated. A matter of taste with nothing wrong is not real; a point already taken correctly in the current texts is not real.

<the findings, each with its index, location, quote, problem and proposed replacement>

Return one verdict per finding, by its index, with a reason citing what you read.
```

### The re-check of RF7's texts after the final check (piped to `cx -m astra -e high --sandboxed --fresh`, run in a rehearsal of main with the kit integrated)

```text
You re-check, read-only, RF7's texts after their final check. This checkout is main with RF7's landing kit integrated (nothing committed; do not edit, build or render): run `git diff` to see the integrated texts; the record's texts are in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py (with its amendments to the landed records what-readings-fix-of-the-unread and shaping-the-rule-selected-by-what-comes-back), the study's in kit/round2/study_rf7.txt, the board's in kit/round2/board_rf2.py (land7). The Lean module experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean is the source of truth.

A final check through three lenses found 50 points, 42 confirmed; the evidence folder next to the kit has them in REVIEW-RF7-FINAL.md, and REVIEW-ROUND2.md's last section, "The final check through three lenses", says what was taken for each. Check that each confirmed point is taken correctly, and look for any new error or overstatement the fixes introduced, in particular: RF2's amended correspondence (the necessary condition now for a deterministic law, a law drawing afresh needing none by Hubinger and others' §4.5) against RF2's home section in 03 §11 and its own laws; 07's rewritten row; the concealment premise added to the overview, the dossier and the study; the twin now reading through the lumping; "gain" kept to its defined sense; the Chinese (选择 for the selection, 欺骗对齐, 毯化之律, 两阶段); the plan's rewritten lines. Report a one-line verdict, then only what is not taken correctly or is new, each with location, quote, problem and replacement.
```

### The second final check of RF7's texts (a workflow of three Opus readers, one per lens, each lens's findings given to a refuter)

The same workflow as the first final check, with this context and these lenses; the readers' closing line and the refuters' prompt as there, the refuters also told that a point refuted before is not real.

```text
You are reading, read-only, a scratch checkout at <the rehearsal worktree>: the repository's main branch with RF7's landing kit integrated (nothing committed; do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine).

RF7 adds one Lean module to the theory's pure core: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean (52 theorems in 71 declarations, every axiom report empty). It is the source of truth. It imports Becoming.Unread (RF2) and through it Becoming.Learning. Its scratch axiom audit is <the kit, kit/round2>/tree/.build/BecomingReadStagesAxiomAudit.lean.

The texts to read, as they now stand:
- every integrated change: run `git -C <the rehearsal worktree> diff` (03-KNOWING.md §11's opening, the theorem paragraph at anchor r-when-complying-when-read-is-best and its Reading, 03's Open bullet; 07-SIGNIFICANCE.md's row "Which function is learned"; 08-METHOD.md §8's bullet; THE-THEORY-OF-BECOMING.md §3; review/ALIGNMENT.md's scope box and its "How it was made" list; the package README.md and README.zh.md rows; Becoming.lean's ReadStages and Unread bullets; check_becoming.py's scope sentence; regions.json; RF's PLAN.md);
- the record, written at landing by <the kit, kit/round2>/make_records_rf7.py (every field in English and Chinese, and its amendments to the landed records what-readings-fix-of-the-unread and shaping-the-rule-selected-by-what-comes-back, whose current JSON is in theories/becoming/results/records/; the amendments change RF2's related list, next step, second scope item, correspondence and history);
- the study section template <the kit, kit/round2>/study_rf7.txt and the board text in <the kit, kit/round2>/board_rf2.py (its land7 branch).

These texts have already been through two cold reads, a cross-model re-check and a first final check, every confirmed point taken. The points and what was taken are in <the RF folder>/evidence/REVIEW-ROUND2.md (sections "The cold read of RF7's texts", "The re-check of what was taken" and "The final check through three lenses"), <the RF folder>/evidence/REVIEW-RF7-COLDREAD.md and <the RF folder>/evidence/REVIEW-RF7-FINAL.md. Do not repeat points taken correctly, nor the refuted ones. Report only problems in the texts as they now stand: what remains wrong, or what the fixes introduced. A problem is a statement that is false or stronger than the files support, a dropped hypothesis, a reading presented as a result, a misattribution, an English-Chinese difference in content, or a break of the repository rules in AGENTS.md (names exact and structural; readings labelled; one sense per term). Matters of taste are not problems. For each problem give the exact location, a verbatim quote, the problem with the evidence that shows it, and a replacement; check that a replacement for a record field fits its cap in tools/research/style.py.
```

Lens `exactness`:

```text
Lens: exactness against the Lean. Check every claim about the module against ReadStages.lean (and Learning.lean or Unread.lean where cited): hypotheses, quantifiers (some versus every; the existential laws), iff versus one direction, strict versus weak, which plan is compared with which, the letters, the witness numbers, and that every cited name exists and says what the text claims; in English and Chinese.
```

Lens `sources`:

```text
Lens: sources and readings. Check every claim about the literature against the sources: Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019), text extracted at <the paper's extracted text>; Aumann, Hart and Perry (1997); Piccione and Rubinstein (1997); Greenblatt and others (2024); Ward, Belardinelli, Toni and Everitt (2023). You may search or fetch public pages; cite what you read. Then check that every reading is labelled or plainly conditional, with its premises stated, and that no unlabelled live sentence asserts a reading as what the laws show; include RF2's amended correspondence and its consistency with RF2's home section in 03 §11.
```

Lens `zh-and-fit`:

```text
Lens: the Chinese edition and fit. Check every Chinese text against its English (the record's zh fields and the amendments; README.zh.md's row): same content, 两阶段 for "two stages", 选 or 选择 for the selection and 择 for the formation's choice, terms as in the repository's other Chinese records. Then fit across the texts: one name for the plan, the letters defined where used, no financial, contest or dualist words, the board and the plan consistent with what lands, the study's references and output list right, links and anchors that exist, the dossier's account of how it was made accurate.
```

### The re-check of RF7's texts after the second final check (piped to `cx -m astra -e high --sandboxed --fresh`, run in a rehearsal of main with the kit integrated and this round's diff at its root)

```text
You re-check, read-only, RF7's texts after a second final check. This checkout is main with RF7's landing kit integrated (nothing committed; do not edit, build or render): run `git diff` to see the integrated texts; the record's texts are in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py (with its amendments to the landed records what-readings-fix-of-the-unread and shaping-the-rule-selected-by-what-comes-back, whose current JSON is in theories/becoming/results/records/), the study's in kit/round2/study_rf7.txt, the board's in kit/round2/board_rf2.py (land7). The Lean module experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean is the source of truth (rebuilt after this round's prose changes, every axiom report empty).

Your previous re-check found four points; a second final check through three lenses, run on the same texts, found 28 points, 27 confirmed. The evidence folder next to the kit has them in REVIEW-RF7-FINAL2.md, and REVIEW-ROUND2.md's last two sections ("The re-check after the final check" and "The second final check through three lenses") say what was taken for each. RF7-ROUND4-DIFF.txt at the checkout root is the diff of this round's changes (before: the texts you and the second check read; after: these). Check that each confirmed point, yours included, is taken correctly, and look for any new error or overstatement the changes introduced, in particular: RF2's amended correspondence and history (the necessary condition for deterministic laws; a law drawing its act afresh can act otherwise unread without telling read from unread, Hubinger and others' §4.5) against RF2's home section in 03 §11 and its own laws, and whether your first point is now met; 03's Reading on the toy example and the absent-minded driver; "with the prospects taken as the formation's own assessment" in 03 and the module; the overview's reading premises; 机会 for chance in the record's Chinese; the plan's §4.6, §8 and §12 lines; the board's land7 text; the dossier's account of how it was made; the study's account of the reviews. Report a one-line verdict, then only what is not taken correctly or is new, each with location, quote, problem and replacement; check that a replacement for a record field fits its cap in tools/research/style.py.
```

### The third check of RF7's texts (a workflow of three Opus readers, one per lens, scoped to the last round's changes, each lens's findings given to a refuter)

The same workflow as the final checks, with this context and these lenses; the readers' closing line as there, and the refuters also told that a point in a passage the round did not change is not real.

```text
You are reading, read-only, a scratch checkout at <the rehearsal worktree>: the repository's main branch with RF7's landing kit integrated (nothing committed; do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine).

RF7 adds one Lean module to the theory's pure core: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean (52 theorems in 71 declarations, every axiom report empty, rebuilt after this round's prose changes). It is the source of truth. It imports Becoming.Unread (RF2) and through it Becoming.Learning. Its scratch axiom audit is <the kit, kit/round2>/tree/.build/BecomingReadStagesAxiomAudit.lean.

The texts: every integrated change (`git -C <the rehearsal worktree> diff`: 03-KNOWING.md §11, 07-SIGNIFICANCE.md's row "Which function is learned", 08-METHOD.md §8's bullet, THE-THEORY-OF-BECOMING.md §3, review/ALIGNMENT.md, the package READMEs, Becoming.lean, check_becoming.py, regions.json, RF's PLAN.md); the record, written at landing by <the kit, kit/round2>/make_records_rf7.py (every field in English and Chinese, and its amendments to the landed records what-readings-fix-of-the-unread and shaping-the-rule-selected-by-what-comes-back, whose current JSON is in theories/becoming/results/records/); the study section template <the kit, kit/round2>/study_rf7.txt; the board text in <the kit, kit/round2>/board_rf2.py (its land7 branch).

These texts have been through two cold reads, cross-model re-checks and two final checks through three lenses, every confirmed point taken. This check is scoped to the last round of changes. <the rehearsal worktree>/RF7-ROUND4-DIFF.txt is that round's diff (before: the texts the second final check read; after: these). The second final check's points are in <the RF folder>/evidence/REVIEW-RF7-FINAL2.md; what was taken for each, and for the cross-model reader's four points read on the same texts, is in the last two sections of <the RF folder>/evidence/REVIEW-ROUND2.md ("The re-check after the final check" and "The second final check through three lenses"). Read every changed passage in its context. Report only: a confirmed point not taken correctly, or a problem a change introduced. Do not report problems in passages this round did not change, nor points refuted before. A problem is a statement that is false or stronger than the files support, a dropped hypothesis, a reading presented as a result, a misattribution, an English-Chinese difference in content, or a break of the repository rules in AGENTS.md (names exact and structural; readings labelled; one sense per term). Matters of taste are not problems. For each problem give the exact location, a verbatim quote, the problem with the evidence that shows it, and a replacement; check that a replacement for a record field fits its cap in tools/research/style.py.
```

Lens `exactness`:

```text
Lens: exactness against the Lean. Check every changed claim about the module against ReadStages.lean (and Learning.lean or Unread.lean where cited): hypotheses, quantifiers (some versus every; the existential laws), iff versus one direction, strict versus weak, which plan is compared with which, and that every cited name exists and says what the text claims; in English and Chinese. Include RF2's amended correspondence and history against Unread.lean's laws and RF2's home section in 03 §11.
```

Lens `sources`:

```text
Lens: sources and readings. Check every changed claim about the literature against the sources: Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019), text extracted at <the paper's extracted text> (§4's toy, §4.2's conditions, §4.5's closing paragraph, §7.4's glossary); Aumann, Hart and Perry (1997); Piccione and Rubinstein (1997); Greenblatt and others (2024). You may search or fetch public pages; cite what you read. Then check that every changed reading is labelled or plainly conditional, with its premises stated where it is used.
```

Lens `zh-and-fit`:

```text
Lens: the Chinese edition and fit. Check every changed Chinese text against its English (the record's zh fields and the amendments): same content, 机会 for chance (机 alone is the glossary's juncture), 两阶段 for "two stages", 选择 for the selection and 择 for the formation's choice, terms as in the repository's other Chinese records. Then fit across the changed texts: one name for each plan, "the plan" in one sense within a document, the board and the plan consistent with what lands, the study's account of the reviews and its counts accurate against the evidence files, the dossier's account of how it was made accurate against the diff.
```

### The re-check of RF7's texts after the third check (the same session continued, `cx -r`, in the rehearsal rebuilt at the same path with this round's diff at its root)

```text
The checkout at the same path has been rebuilt from main (now at 119d464ca, which adds one line to the work board) with the kit integrated again, now with fixes for your point and for a third check through three lenses that read the same texts as you did (11 findings, 9 confirmed; its findings and verdicts are in the evidence folder's REVIEW-RF7-CHECK3.md, and REVIEW-ROUND2.md's last two sections say what was taken for your point and for each of its points). RF7-ROUND5-DIFF.txt at the checkout root is this round's diff (before: the texts you read; after: these). Your point was taken differently from your replacement, because the third check found that alignment faking's differing rates can arise where no unread occasion is told from every read one: RF2's correspondence now says that two laws reading through one lumping can agree on every reading and differ unread only where the lumping tells the occasion from every read one; read with deceptive alignment, such a law acting alike on every reading acts otherwise unread only there; differing rates, as in alignment faking, are not so bounded. Check, read-only, that your point and the third check's are now taken correctly, against Unread.lean, Learning.lean and RF2's home section in 03 §11, and that this round's changes introduce no new error or overstatement. Report a one-line verdict, then only what is not taken correctly or is new, each with location, quote, problem and replacement; check that a replacement for a record field fits its cap in tools/research/style.py.
```

### The fourth check of RF7's texts (a workflow of two Opus readers, one per lens, scoped to the last round's changes, each lens's findings given to a refuter)

The same workflow as the third check, with this context and these two lenses; the readers' closing line and the refuters' prompt as there.

```text
You are reading, read-only, a scratch checkout at <the rehearsal worktree>: the repository's main branch with RF7's landing kit integrated (nothing committed; do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine).

RF7 adds one Lean module to the theory's pure core: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean (52 theorems in 71 declarations, every axiom report empty, rebuilt after this round's prose change). It imports Becoming.Unread (RF2) and through it Becoming.Learning; those files are the source of truth for what RF2's record may say.

The texts: every integrated change (`git -C <the rehearsal worktree> diff`); the record, written at landing by <the kit, kit/round2>/make_records_rf7.py, with its amendments to the landed records what-readings-fix-of-the-unread (RF2's record) and shaping-the-rule-selected-by-what-comes-back, whose current JSON is in theories/becoming/results/records/; the study section template <the kit, kit/round2>/study_rf7.txt; the board text in <the kit, kit/round2>/board_rf2.py (land7).

These texts have been through two cold reads, four cross-model re-checks and three checks through three lenses, every confirmed point taken. This check is scoped to the last round of changes. <the rehearsal worktree>/RF7-ROUND5-DIFF.txt is that round's diff (before: the texts the third check read; after: these). The third check's points are in <the RF folder>/evidence/REVIEW-RF7-CHECK3.md; what was taken for each, and for the cross-model reader's point read on the same texts, is in the last two sections of <the RF folder>/evidence/REVIEW-ROUND2.md ("The re-check after the second final check" and "The third check through three lenses"). The main change: RF2's amended correspondence (in both languages, and its history) now says that two laws reading through one lumping can agree on every reading and differ unread only where the lumping tells the occasion from every read one; read with deceptive alignment, such a law acting alike on every reading acts otherwise unread only there; differing rates, as in alignment faking, are not so bounded. Read every changed passage in its context. Report only: a confirmed point not taken correctly, or a problem a change introduced. Do not report problems in passages this round did not change, nor points refuted before. A problem is a statement that is false or stronger than the files support, a dropped hypothesis, a reading presented as a result, a misattribution, an English-Chinese difference in content, or a break of the repository rules in AGENTS.md (names exact and structural; readings labelled; one sense per term). Matters of taste are not problems. For each problem give the exact location, a verbatim quote, the problem with the evidence that shows it, and a replacement; check that a replacement for a record field fits its cap in tools/research/style.py (the amended correspondence must stay within 1200 English and 500 Chinese characters).
```

Lens `exactness-and-sources`:

```text
Lens: exactness and sources. Check every changed claim against the Lean (Unread.lean's twin_selected and free_lumped, Learning.lean's lumped_determines, Lumped, Training.Through and AgreeOn; ReadStages.lean) and against the sources: Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019), text extracted at <the paper's extracted text> (§4's toy and its training episodes, §4.2's third condition, §4.5's closing paragraph); Greenblatt and others (2024, arXiv 2412.14093), which you may fetch. In particular: is "such a law acting alike on every reading acts otherwise unread only there" exactly what the laws give, for which laws; is "differing rates ... are not so bounded" true and fairly attributed; does RF2's history describe the field it amends; is RF2's home section in 03 §11 consistent with the amended record; is the third condition now stated as Hubinger and others state it.
```

Lens `zh-and-fit`:

```text
Lens: the Chinese edition and fit. Check every changed Chinese text against its English (RF2's amended correspondence and history): same content, terms as in the repository's other Chinese records (机会 for chance, 两阶段 for two stages, 选择 for the selection). Then fit across the changed texts: the study's account of the reviews accurate against the evidence files (counts, which check found and which round took each point, nothing told twice), "the plan" in one sense in the study, one name for each plan, RF's plan's §8 and §13 lines consistent with what lands and with the evidence, and REVIEW-ROUND2's corrected Taken cells accurate.
```

## Round 2, second part

### The review of the design (piped to `cx -m astra -e high --sandboxed --fresh`, in the landing worktree with the plan's §4.7 uncommitted)

```text
You are reviewing, read-only, a design for new formal results in this repository (do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine). Read AGENTS.md first: the theory's method (one relational unfolding, no separate subject; structural names; the pure core imports only Lean's Init and every axiom report is empty).

The design is §4.7 of _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md ("Round 2, second part: an act held for a reading, and the order as state"), uncommitted in this checkout. Read the plan's §1, §2, §4.5, §4.6 and §5 for context. It builds on landed Lean in experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/: ShownOrder.lean (RF1: the shown reach, both_ways_of_unreached), ReadingLoop.lean (the Loop of candidate laws, Loop.kept_iff, Loop.rests_of_unrefuted, the Untested witness with model_or_order and informed_turns), Unread.lean and Learning.lean (RF2's lumping laws), ReadStages.lean (RF7). The records are theories/becoming/results/records/*.json; `python3 -B tools/research/research.py find` with QUERY set searches them (or grep).

Review the design as a second opinion, before any Lean is written:
1. Novelty on the spine. Is any law of RF-M.2 (items 1 to 5) or RF-M.3 (items 1 to 3) already stated in the package or the records? Check at least the record when-to-inquire-and-when-to-respond and its Lean (InquirySufficiency, GuardHorizon.uniform_policy_iff_fiber_feasible), any value-of-information or common-act law, closed-capture (Everitt and others 2017), ClosedCapture, RuleCapture, DrawnShaping, ReadInTime, and Seeking. Name the declaration and say what would be reproved.
2. Exactness. Is each stated law true as stated, with its hypotheses complete? In particular: the equality and strictness conditions of item 1 (weights zero, ties, an empty list of acts or candidates); the shifted encoding of item 2 (gain less loss, nothing for switching off, the loss added to both) and its strictness condition with ties (a candidate where gain equals loss); item 3's two conditions; item 4's join with ShownOrder (what "every candidate ranks them alike" needs: candidates that are strict orders according with the choices; whether candidates can be represented with decidable comparisons so values are natural numbers); item 5 as a witness on Loop (what the veto sensed only when held needs in Loop's interface: the answer depends on the act); RF-M.3 item 1 (what "the order at the choice" and "at the outcome" are on one configuration), item 2 (whether it is RF2's or Learning's instance with nothing added), item 3 (whether a shaping act within Loop's law is representable: Loop's internal part is the candidate list and the last value and act; where would an order live).
3. The literature. Are the attributions right: Good (1967) on the principle of total evidence; Hadfield-Menell, Dragan, Abbeel and Russell (2017) on the off-switch game (what their theorem states, its rationality assumption, and the result that a robot with a certain belief has no incentive to defer); Milli, Hadfield-Menell, Dragan and Russell (2017) on obedience; Carey (2018) on incorrigibility in CIRL under a misspecified prior; Everitt, Hutter, Kumar and Krakovna (2021) on reward tampering and current-reward-function optimization; Carroll, Dragan, Russell and Hadfield-Menell (2022) on induced preference shifts; Hirschman (1970). Say what is misread or misattributed, with the source's own statement where you can.
4. Strength and purpose. The purpose is a checkable account that alignment researchers and readers of coordination can use. Is there a stronger or more useful law in reach on these structures (for example: holding's worth monotone in how open the model is; a cost of holding and the threshold at which a helper stops holding; what a helper can learn of an order from choices bounded by the shown reach, joined to the off-switch; the route law's exact content)? Is anything in the design a wrapper or near-definitional result presented as more?
5. Names and framing. Are HeldForReading and FormedOrder structural and exact for what they state? Does any sentence presuppose separate entities (helper and principal as subjects) in a way the method forbids, and how should it be reconstructed?

Report numbered findings. For each: location (file:line or the item number), the problem, and a replacement (text for the plan, or a corrected statement of the law). Mark each finding confirmed by a check you ran, or a judgment. End with a one-paragraph verdict: which items to build as designed, which to change, which to drop.
```

### The review of `Becoming.HeldForReading` (piped to `cx -m astra -e high --sandboxed --fresh`, in the landing worktree at the kit's commit)

```text
You are reviewing, read-only, a new Lean 4 module in this repository (do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine). Read AGENTS.md first for the method, the naming rule and the pure core's requirements.

The module: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean, scratch-built with Lean 4.29.1 against this checkout's package (experiments/integrated-correction/general-framework/generative-basis/lean/becoming/): 56 theorems in 80 declarations, every axiom report empty, no warnings (log kit/round2b/logs/build-9.log; the audit driver kit/round2b/tree/.build/BecomingHeldForReadingAxiomAudit.lean is present though ignored by git). It imports Becoming.ShownOrder and Becoming.ReadingLoop and reuses Becoming.total with its lemmas (Flow.lean's Totals section, Population.lean's total_congr_on, Dissipation.lean's total_eq_zero) and the Prelude's axiom-free arithmetic.

It implements the plan's §4.7, RF-M.2 (_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md), redesigned after your own review of the design: evidence/REVIEW-RFM2.md in the same folder, with a table of what was taken.

Review it as a second opinion:
1. For each finding of REVIEW-RFM2 marked taken, is it taken as its row says, in the Lean and the module's account?
2. Exactness. Compare every docstring and every sentence of the module's header with the Lean statement it cites: dropped or superfluous hypotheses, "exactly" where one direction is proved, conclusions stronger than proved, the Standing labels (near-definitional, general law, witness). Do the names state exactly what the statements mean, in the repository's structural vocabulary?
3. Reuse. Does the module reprove anything the package already has (search for list totals compared item by item, finite searches over lists, cancellation and subtraction lemmas, products with a positive factor)? Name the declaration to reuse.
4. The literature claims in the Standing and Readings paragraphs: Good (1967) on the principle of total evidence; Hadfield-Menell, Dragan, Abbeel and Russell (2017), Theorem 1 and Equation 1; Carey (2018); Milli, Hadfield-Menell, Dragan and Russell (2017).
5. Strength. Is a stronger or more useful statement in reach on these definitions for alignment researchers and readers of coordination (for example: the strict forms of cost_within_margins_iff; the margins' positivity and held_gains_iff joined; a reading that tells the candidate only partly, as a policy through a lumping, against the full reading)? Is anything presented as more than it is?
6. The witness Bypass: do its theorems show what the docstrings say (the steps, "never sensed", the rule for ties), and is any conclusion an artifact of the construction rather than of the law it instantiates?

Report numbered findings. For each: location (file:line), the problem, and a replacement (Lean or text). Mark each confirmed by a check you ran, or a judgment. End with a one-paragraph verdict.
```

### The three-lens review of `Becoming.HeldForReading` (a workflow of Opus readers, beside the cross-model reader)

Three readers, one lens each, given a common preamble and their lens; then one verifier per lens, given all of that lens's findings to refute.

The common preamble:

```text
You are an independent, adversarial reviewer of one Lean 4 module in a theory repository. Work read-only: read files and run read-only shell commands only; do not edit, create, commit, render, run make or build Lean. The module builds in the repository's pure core (Lean 4.29.1) with every axiom report empty and no warnings: 56 theorems in 80 declarations. Do not try to build it.

The module: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean (paths are relative to the working directory).
It imports Becoming.ShownOrder and Becoming.ReadingLoop, in experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ (ShownOrder.lean, ReadingLoop.lean), and uses Becoming.total with its lemmas from Prelude.lean, Flow.lean, Population.lean and Dissipation.lean in the same folder. The plan that asked for it: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md, section 4.7 (RF-M.2). The cross-model design review it answers, with a table of what was taken: evidence/REVIEW-RFM2.md in the same folder.

The module states, in natural-number counts: what holding an act for a reading that tells the candidate is worth against committing (a finite form of the value of evidence); the case of a reading that stops or releases a held act (a deterministic finite form of the off-switch game); any rule of stopping; the threshold joining a rule's shortfall, a cost of holding and the model's two weighted margins; a conditional join with the shown reach of choices (ShownOrder); and a witness on ReadingLoop.Loop of a reading bypassed under a misspecified listing. Report only what you can point to in the files, with file:line locations and exact quotes. Severity: high (a claim the Lean does not prove, or a wrong theorem), medium (a dropped hypothesis, an overstated reading, a reproved package lemma, a statement the header promises and the Lean lacks), low (wording or naming). Give a concrete replacement (Lean or text) for each finding, most severe first.
```

The exactness lens (findings numbered E1, E2, …):

```text
Your lens: exactness of prose against statements, and the arithmetic. For every theorem and definition, compare its docstring, and every sentence of the module header and of the Standing, Readings and Modelling paragraphs that cites it, with the Lean statement: hypotheses dropped (for example a hypothesis on every listed candidate presented as a property of some), quantifiers changed, "exactly" where only one direction is proved, conclusions stated more strongly than proved, the Standing labels (near-definitional, general law, witness). Check the arithmetic: that shifted keeps every comparison between policies as the header says; that gainMargin, lossMargin and shortfall mean what their docstrings say; the strict halves of held_above_go_iff and held_above_off_iff; ties (gain equal to loss) and candidates of zero weight; whether held_gains_iff's gloss "the model leaves the act's sign open" is exact. Check that the Bypass theorems compute what their docstrings and the header say (which step, what is sensed when, what "from step four on" covers, what the listing does). Names must be structural and exact in the repository's vocabulary: flag dualist, social or financial words in Lean names and in prose (AGENTS.md, Proof and naming).
```

The sources lens (L1, L2, …):

```text
Your lens: the labelled readings and the literature. Check every attribution and correspondence in the Standing and Readings paragraphs and the docstrings against the works: Good (1967), On the principle of total evidence; Hadfield-Menell, Dragan, Abbeel and Russell (2017), The off-switch game (arXiv 1611.08219), its Theorem 1 and its Equation 1; Carey (2018), Incorrigibility in the CIRL framework (arXiv 1709.06275); Milli, Hadfield-Menell, Dragan and Russell (2017), Should robots be obedient? (arXiv 1705.09990). Read the papers on the web where your tools allow it (load a fetch or search tool with ToolSearch if one is deferred); otherwise use your knowledge, and where unsure of a detail say so rather than assert it. For each correspondence: is it fair; is "the deterministic finite case of Theorem 1" exact (the paper's robot has a belief distribution over the action's utility and the human a policy on it; here candidates carry natural-number weights and the rule is a Boolean function of the candidate); does the module claim more or less than the paper proves (for example a converse the paper does not state); is "its Equation 1 for a deterministic rule" the right equation; are the Carey and Milli summaries accurate; is the link to the plan's obstruction pattern (PLAN.md section 5) fair. Also check that the readings stay labelled readings and keep the repository's method (AGENTS.md: one relational unfolding first; helper and principal as roles in one configuration, not separate entities presupposed).
```

The structure lens (F1, F2, …):

```text
Your lens: structure, reuse, fit and strength. (1) Reuse: does the module reprove anything the package already has? Search experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/*.lean for totals compared item by item or strictly, finite searches over lists, cancellation and subtraction lemmas, products with a positive factor, membership helpers and Bool case lemmas, and name each declaration to reuse with its file:line. (2) Fit: is each row of REVIEW-RFM2.md's table marked taken taken in the Lean and in the module's account as the row says; does the module meet RF-M.2 as PLAN.md section 4.7 states it; is ShownOrder's ChoiceOccasions.reach_within used correctly in reach_fixes, and is the header's mention of ChoiceOccasions.both_ways_of_unreached accurate; is Bypass a correct instance of ReadingLoop.Loop and of Loop.rests_of_unrefuted, and does the header describe that law correctly? (3) Strength: is a stronger or more useful statement in reach on the same definitions, worth adding before landing (for example: the strict forms of cost_within_margins_iff; held_gains_iff joined with the margins' positivity, that holding gains over both moves exactly where both margins are positive; a policy reading through a lumping compared with the full reading, with the inquiry laws GuardHorizon.uniform_policy_iff_fiber_feasible and ReadingLoop.keeping_policy_iff)? Give the statement and a proof sketch for each, in priority order.
```

The verifier, for each lens's findings (followed by the findings, each with its id, severity, location, quote, problem and proposed replacement):

```text
You are an adversarial verifier. Work read-only: read files and run read-only shell commands only; no edits, no builds. A reviewer reported the findings below on the Lean module _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean (paths relative to the working directory; the package is experiments/integrated-correction/general-framework/generative-basis/lean/becoming/; PLAN.md and evidence/REVIEW-RFM2.md are in the rf-formations-that-read folder). For each finding, try to refute it against the module's actual text and Lean statements and the files it cites. A finding is real only if the quoted text exists at or near the location and the problem holds against the Lean as written. A claimed reuse is real only if the named declaration exists, states what is needed, and has an empty axiom report (no propext, Quot.sound or Classical.choice: check its proof and what it uses). A suggested strengthening is real only if the stronger statement is true on these definitions and provable without axioms. A literature point is real only if you can confirm it; otherwise say it is unconfirmed. Default to real=false if you cannot confirm. For each finding give its id, real, your reason in two or three sentences, and, where the proposed replacement is wrong or could be better, a better replacement.
```

### The check of how the Lean review's findings were taken (a workflow of four Opus readers, one per set of findings)

Run on the rebuilt module (81 theorems in 111 declarations), each reader given the common prompt, the findings of one set and a note; `<saved>` stands for the folder where the reviewed version (`git show 7f4679003:` the module's path) and the four sets of findings were saved. Each reader returned rows of id, status (taken, partly taken, not taken, pending in a text not yet written, superseded), how and where.

```text
You are checking, read-only, how each finding of a review of a Lean module was taken. Do not edit, create, build or commit anything; reading files and read-only shell commands (grep, sed, diff) are fine.

The module as reviewed: <saved>/reviewed-7f4679003.lean (56 theorems in 80 declarations).
The module now: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean (81 theorems in 111 declarations, built clean, every axiom report empty).
The record the module will land with: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py (its laws, hypotheses, does_not_show, counterexamples, correspondence).
A diff between the two module versions is the fastest start: diff <saved>/reviewed-7f4679003.lean _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean.

For every finding, decide from the files alone whether the current module (or the record script) takes it, and how. "taken": the problem no longer occurs and the replacement, or an equivalent, is in place. "partly taken": some of it. "not taken": the problem still occurs. "pending in a text not yet written": the finding concerns a file other than the module and the record script (PLAN.md, REVIEW-RFM2.md, chapter texts), which have not yet been revised. "superseded": the passage or declaration it concerns was replaced by something the finding's problem no longer applies to (say what). Name current declarations exactly and give current line numbers. Be exact and brief; do not judge whether a finding was right, only whether and how it is reflected. Report every finding in the file, in order.

The findings: <saved>/<file>. <note>
```

The four sets and their notes:

- astra (`astra.md`): The findings are the numbered items 1 to 14 of a cross-model review (astra). Use ids A1 to A14. Item 1 concerns REVIEW-RFM2.md's table (not yet revised). Items with several sub-points: report the whole item in one row, saying which parts are taken.
- exactness (`exactness.md`): Ids E1 to E17. A separate refuter judged E8, E11 and E15 not real (see <saved>/exactness-verdicts.md); for those, still say whether the module changed at the place, and use status "not taken" if nothing changed.
- structure (`structure.md`): Ids F1 to F24.
- sources (`sources.md`): Ids L1 to L14. Several concern literature attributions in the header's Standing and Readings paragraphs and the record's correspondence; L14 concerns PLAN.md's literature table.

### The re-check of `Becoming.HeldForReading` (the cross-model reader's session continued, `cx -r`, read-only, in the landing worktree from the kit's commit `e221bbf02`, while the next commit's spelling and plan edits were being made)

```text
This continues your review of Becoming.HeldForReading (your fourteen findings, earlier in this session). Work read-only as before: read files and run read-only shell commands only; do not edit, create, commit, render, run make or build Lean.

The module was rebuilt for your review and for a review through three lenses (exactness, structure, sources). It now has 89 theorems in 119 declarations and builds in the pure core with every axiom report empty and no warnings (the scratch build's log: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/logs/build-18.log). Start from the diff: git diff 7f4679003 e221bbf02 -- _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/tree/Becoming/HeldForReading.lean _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py. The reviews, verbatim, and how each finding was taken are in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2-LEAN.md; your findings are rows A1 to A14 of its last table. The record the module will land with is written by _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py (its statement, laws, hypotheses, does_not_show, counterexamples and correspondence).

Re-check:
1. For each of your findings A1 to A14, is it taken as its row says, in the module and, where the row says so, in the record script, _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md or _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2.md? Say taken, taken in part (and what remains) or not taken.
2. The declarations added since your review, against their docstrings and every header sentence citing them: held_eq_go_iff, held_eq_off_iff, after_rule_add_onLoss, after_rule_le_iff, SignLoop.offExcess_of_all_true, SignLoop.goExcess_of_all_not, SignLoop.choose_go_ties, SignLoop.choose_off_ties, bestOf, bestOf_best, after_offset, after_offset_le_iff, excess_pos_iff, forgone_below_excess_iff, finer_least_le, pair_gains_unreached, SignLoop.both_stopped, SignLoop.both_released, total_by_cells and through_threshold_iff, and any other new name in the diff: dropped or superfluous hypotheses, "exactly" where one direction is proved, conclusions stronger than proved, and the Standing's labels (near-definitional or short compositions, general laws, witness).
3. The header's Standing and Readings as revised, against the papers you checked: Good (1967); the off-switch game (arXiv 1611.08219), its Equations 1 to 3, Theorem 1, Corollary 1, Remark 1, Section 4 and Theorem 2; Carey (2018, arXiv 1709.06275), Figures 2a and 3a, footnote 1 and the Discussion; Milli and others (2017, arXiv 1705.09990), Theorems 1 and 3 and Section 5. Is every attribution and correspondence exact?
4. The record script's statement, laws, hypotheses, does_not_show, counterexamples and correspondence against the Lean: is any stronger than what is proved, or missing a hypothesis the Lean needs?
5. Anything the rebuild introduced: an overstatement, a duplicate of a package declaration, a name that states a wrong meaning.

Report numbered findings. For each: location (file:line), the problem, and a replacement. Mark each confirmed by a check you ran, or a judgment. End with a one-paragraph verdict.
```

### The cold read of RF-M.2's texts (piped to `cx -m astra -e high --sandboxed --fresh`, run in a rehearsal of main with RF-M.2's module and texts integrated; and a workflow of three Opus readers, one per lens, each lens's findings given to one refuter)

```text
Cold read, read-only, in <a rehearsal of main with RF-M.2 integrated> (a scratch copy of the repository with RF-M.2's texts integrated; do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine).

Context. This repository develops one theory with a pure Lean core. Board item RF, round 2, RF-M.2 adds one Lean module, reviewed on the code by a cross-model reader and through three lenses, and re-checked: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldForReading.lean (Becoming.HeldForReading, a core leaf, 90 theorems in 120 declarations, every axiom report empty; it imports ShownOrder.lean and ReadingLoop.lean). It states what holding an act for a reading is worth in natural-number counts: the worth of a reading that tells the candidate, holding for a reading that stops or releases, any rule of stopping and its shortfall, the threshold of what holding forgoes, a reading that tells only a cell, a conditional join with RF1's shown reach, and a witness on the reading loop.

The texts, integrated in a scratch copy of the repository at <a rehearsal of main with RF-M.2 integrated> (read-only; do not edit, create, commit, render, run make, or build Lean; paths below are relative to it):
1. theories/becoming/chapters/03-KNOWING.md: section 12's opening paragraph (its sentence ending "and what holding an act for a reading is worth on the formation's own model."), the new theorem paragraph at anchor r-what-holding-for-a-reading-is-worth with its Reading paragraph (just before the anchor does-not-show), the pointer added to the acts-alike reading ("what holding an act for another's reading is worth is [the last law]"), and the Open bullet beginning "Formations that read, beyond".
2. theories/becoming/chapters/07-SIGNIFICANCE.md: section 7's sentence beginning "Nor does an incentive to accept one".
3. theories/becoming/chapters/08-METHOD.md: section 8's known-results bullet beginning "What holding an act for a reading is worth".
4. theories/becoming/THE-THEORY-OF-BECOMING.md: section 3's paragraph beginning "Holding an act for another's reading is worth what the reading tells".
5. theories/becoming/review/ALIGNMENT.md: the box "What the theory does not address" (its bullets on assistance games and on corrigibility as an incentive), the paragraph on RF's rounds (its sentences on RF-M.2), and the account of how the dossier was made (its entry on RF-M.2's sentences).
6. The package: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean (the L1 bullet for Becoming.HeldForReading, and ShownOrder's and ReadingLoop's bullets, now imported by it), README.md and README.zh.md in the same folder (the Becoming.HeldForReading rows), check_becoming.py there (the scope sentence beginning "HeldForReading:").
7. The module's own header (its opening, bullets, Standing, Readings and Modelling choices) and docstrings.
8. The record's texts, in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py: the record what-holding-for-a-reading-is-worth (title, statement, the twenty law items, hypotheses, does_not_show, counterexamples, validation, next_delta, correspondence, aliases, dependencies, related) and the amendments to three related records (AMEND), English and Chinese.
9. The study section template _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/study_rfm2.txt ({N}, {RECEIPT}, (HELDFORREADING) and {REVIEWS} are filled at landing).
10. _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md: section 4.7 (its opening, the RF-M.2 entry and its seven items), section 8's literature row on assistance games, section 12's order, section 13's paragraphs on the second part's design review and on the reviews of its Lean (the cold read's sentence is added after this read), and the Evidence list.
11. theories/becoming/results/data/regions.json: the entries what-holding-for-a-reading-is-worth and Becoming.HeldForReading.
12. The board's texts for RF-M.2: the docs and land branches of _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/board_rfm2.py.
13. The evidence of the Lean's reviews, _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2-LEAN.md: its opening (what was verified, and how), the literature table, and the two tables of what was taken (from the first review and from the re-check): does each row's 'how' match the module, the record script, the plan and the texts as they now stand? The reviews themselves are verbatim and not to be judged.

Repository rules that bear on the texts (from AGENTS.md): claims say exactly what the Lean proves (hypotheses, direction, strictness, ties); names are structural and exact, with no dualist, social or financial words beyond the roles the plan adopts; AI readings are labelled as readings and never presented as theorems; no ethical premise enters here; each live document is in one language, Chinese editions separate; repository-relative links.

Check each text against the Lean: hypotheses (a policy best at every listed candidate supplied; open acts; listed candidates of positive weight; choice over the whole type of cells; equality of cells decidable, cells listed once each and covering; transitive and according comparisons, and the asymmetry where pair_gains_iff asks it), directions, strictness and ties, which move and which rule, the correspondences (the shifted values and the signed ones; the amount forgone in the units of the weighted totals), names, counts, links and anchors; that the readings stay readings and the citations are accurate (Good 1967; Hadfield-Menell, Dragan, Abbeel and Russell 2017, arXiv 1611.08219: Equations 1 to 3, Theorem 1, Corollary 1, Remark 1, Section 4, Theorem 2; Carey 2018, arXiv 1709.06275: Figures 2a and 3a, footnote 1, the Discussion; Milli, Hadfield-Menell, Dragan and Russell 2017, arXiv 1705.09990: Theorems 1 and 3, Section 5; Blackwell 1953). Check the Chinese texts against the English.

Return: a verdict line; then numbered findings, each with severity, location (file:line), the quoted text, the problem against the Lean or the source, and a replacement (English, and Chinese where the text is Chinese). Report only what you can point to.
```

The workflow's texts, common to its three readers and the refuters:

```text
The Lean (the source of truth): experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldForReading.lean (Becoming.HeldForReading, a core leaf, 90 theorems in 120 declarations, every axiom report empty; it imports ShownOrder.lean and ReadingLoop.lean in the same folder, and uses Becoming.total with its lemmas from Prelude.lean, Flow.lean, Population.lean and Dissipation.lean).

The texts, integrated in a scratch copy of the repository at <a rehearsal of main with RF-M.2 integrated> (read-only; do not edit, create, commit, render, run make, or build Lean; paths below are relative to it):
1. theories/becoming/chapters/03-KNOWING.md: section 12's opening paragraph (its sentence ending "and what holding an act for a reading is worth on the formation's own model."), the new theorem paragraph at anchor r-what-holding-for-a-reading-is-worth with its Reading paragraph (just before the anchor does-not-show), the pointer added to the acts-alike reading ("what holding an act for another's reading is worth is [the last law]"), and the Open bullet beginning "Formations that read, beyond".
2. theories/becoming/chapters/07-SIGNIFICANCE.md: section 7's sentence beginning "Nor does an incentive to accept one".
3. theories/becoming/chapters/08-METHOD.md: section 8's known-results bullet beginning "What holding an act for a reading is worth".
4. theories/becoming/THE-THEORY-OF-BECOMING.md: section 3's paragraph beginning "Holding an act for another's reading is worth what the reading tells".
5. theories/becoming/review/ALIGNMENT.md: the box "What the theory does not address" (its bullets on assistance games and on corrigibility as an incentive), the paragraph on RF's rounds (its sentences on RF-M.2), and the account of how the dossier was made (its entry on RF-M.2's sentences).
6. The package: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean (the L1 bullet for Becoming.HeldForReading, and ShownOrder's and ReadingLoop's bullets, now imported by it), README.md and README.zh.md in the same folder (the Becoming.HeldForReading rows), check_becoming.py there (the scope sentence beginning "HeldForReading:").
7. The module's own header (its opening, bullets, Standing, Readings and Modelling choices) and docstrings.
8. The record's texts, in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py: the record what-holding-for-a-reading-is-worth (title, statement, the twenty law items, hypotheses, does_not_show, counterexamples, validation, next_delta, correspondence, aliases, dependencies, related) and the amendments to three related records (AMEND), English and Chinese.
9. The study section template _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/study_rfm2.txt ({N}, {RECEIPT}, (HELDFORREADING) and {REVIEWS} are filled at landing).
10. _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md: section 4.7 (its opening, the RF-M.2 entry and its seven items), section 8's literature row on assistance games, section 12's order, section 13's paragraphs on the second part's design review and on the reviews of its Lean (the cold read's sentence is added after this read), and the Evidence list.
11. theories/becoming/results/data/regions.json: the entries what-holding-for-a-reading-is-worth and Becoming.HeldForReading.
12. The board's texts for RF-M.2: the docs and land branches of _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/board_rfm2.py.
13. The evidence of the Lean's reviews, _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2-LEAN.md: its opening (what was verified, and how), the literature table, and the two tables of what was taken (from the first review and from the re-check): does each row's 'how' match the module, the record script, the plan and the texts as they now stand? The reviews themselves are verbatim and not to be judged.

Repository rules that bear on the texts (from AGENTS.md): claims say exactly what the Lean proves (hypotheses, direction, strictness, ties); names are structural and exact, with no dualist, social or financial words beyond the roles the plan adopts; AI readings are labelled as readings and never presented as theorems; no ethical premise enters here; each live document is in one language, Chinese editions separate; repository-relative links.
```

The exactness lens ("You are a cold reader checking texts against Lean, adversarially.", then the texts, then):

```text
Your lens: exactness. For every claim in texts 1 to 12, check it against the Lean statements in HeldForReading.lean (and ShownOrder.lean or ReadingLoop.lean where a text cites their laws): the hypotheses (a policy best at every listed candidate supplied; open acts; listed candidates of positive weight; choice over the cells; cells listed once each and covering; transitive, according and one-way comparisons), the direction of each iff, strictness and ties (gain equal to loss), which move and which rule, the names and their backticks, the counts (theorems, declarations, laws), and the correspondences (the shifted values and the signed ones; the amount forgone in the units of the weighted totals, c T for an amount c per decision). Check the Chinese texts (README.zh.md's row, the record's zh fields) say the same as the English. Report only what is wrong, overstated, missing a hypothesis, or inconsistent between texts.

Return findings: severity, location (file:line), the quoted text, the problem against the Lean, and a replacement.
```

The readings lens ("You are a cold reader checking the readings and citations, adversarially.", then the texts, then):

```text
Your lens: the AI readings and the literature. Check every attribution against what the sources say (you may search the web and read the papers): Good (1967), "On the principle of total evidence" (his Lemma's dominating row, his proviso of negligible cost); Hadfield-Menell, Dragan, Abbeel and Russell (2017), "The off-switch game", arXiv 1611.08219 (Equations 1 to 3, Theorem 1, Corollary 1, Remark 1, Section 4, Theorem 2); Carey (2018), "Incorrigibility in the CIRL framework", arXiv 1709.06275 (Figures 2a and 3a, footnote 1, the Discussion); Milli, Hadfield-Menell, Dragan and Russell (2017), "Should robots be obedient?", arXiv 1705.09990 (Theorems 1 and 3, Section 5); Blackwell (1953), the comparison of experiments. Check that readings are labelled as readings, claim nothing the Lean does not prove, and do not overstate what the witness shows (it represents no valuation beyond the counts on the kept listing, anticipates no stop, and is related to Carey's counterexamples, not a containment). Check the readings of corrigibility, assistance games and the worth of a reading for consistency across 03, 07, 08, the overview and the dossier. Report only what is wrong or overstated.

Return findings: severity, location (file:line), the quoted text, the problem, and a replacement.
```

The fit lens ("You are a cold reader checking how the new texts fit where they are placed, adversarially.", then the texts, then):

```text
Your lens: fit and coherence. Does each text read well in its section and agree with the texts around it (03 section 12's other laws and its readings, 03's Open bullet, 07 section 7's paragraph on executable change, 08 section 8's other bullets and their style, the overview's section 3, the dossier's box and its other bullets, the package README's rows and the root bullets around ReadingLoop's)? Are the links and anchors right (anchors exist; repository-relative links resolve from each file)? Are the same results named the same way everywhere? Is anything stated in two places in a way that will drift, or a sentence a reader cannot follow? Do the record's fields stay within their roles (statement, laws, hypotheses, does_not_show, counterexamples, validation, next_delta, correspondence)? Do the plan, study and board texts describe the item and its review history accurately (the evidence files are in the study folder's evidence/: REVIEW-RFM2.md and REVIEW-RFM2-LEAN.md)? Report only what is wrong, unclear or inconsistent.

Return findings: severity, location (file:line), the quoted text, the problem, and a replacement.
```

The refuter of each lens, given all of that lens's findings ("You are an adversarial verifier.", then the texts, then):

```text
A cold reader (lens: <lens>) reported the findings below. For each, try to refute it against the files: read the quoted location and the Lean it concerns. A finding is real only if the quoted text exists at or near the location and the problem holds as stated against the Lean, the sources or the surrounding texts; a matter of taste with nothing wrong is not real. Default to real=false if you cannot confirm it. For each finding give its number, real, a reason in two or three sentences citing what you read, and, where the proposed replacement is wrong or could be better, a better replacement.

<the findings, numbered, each with its severity, location, quoted text, problem and proposed replacement>
```

### The re-check of RF-M.2's texts after the cold read (the cold read's session continued, `cx -r`, read-only, in a rehearsal of main with the kit integrated and the cold read's diff at its root)

```text
You re-check, read-only, RF-M.2's texts after the cold read. This checkout is main merged with the kit at 175550266, with the kit's integration applied (nothing committed; do not edit, create, commit, build, render or run make; reading files and read-only shell commands are fine): run `git diff` to see the integrated texts. The record's texts are in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py (with its amendments AMEND to the landed records what-choices-show-of-an-order, what-a-course-chosen-through-its-model-does-not-test and acts-alike-from-a-model-or-from-an-order, whose current JSON is in theories/becoming/results/records/), the study's in kit/round2b/study_rfm2.txt, PLAN §13's new paragraphs (on the Lean's reviews and the cold read) in PLAN.md itself, 03 §12's theorem paragraph and Reading in kit/round2b/s12_rfm2.txt, the board's in kit/round2b/board_rfm2.py (land). The Lean module experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldForReading.lean is the source of truth: its header and docstrings changed with the findings, its statements did not, and it was rebuilt (90 theorems in 120 declarations, every axiom report empty, no warnings; kit/round2b/logs/build-25.log).

Your cold read found eight points; three lenses (exactness, readings, fit) found 78 findings, each lens's findings judged by one refuter. The evidence folder next to the kit has them verbatim in REVIEW-RFM2-COLDREAD.md, with a table of what each became. RFM2-COLDREAD-DIFF.txt at the checkout root is the diff of the kit's changes since your read (before: the kit at 82725b416, the state you read; after: the kit at 175550266). Check that each confirmed finding, yours included, is taken correctly, and look for any new error or overstatement the changes introduced, in particular:
- the threshold's sum ("together", "plus") against threshold_go_iff, threshold_off_iff and through_threshold_iff, wherever the threshold is stated;
- the off-switch paper's Remark 1 read as placing the incentive that is the model's openness less the reading's shortfall, the paper's game having no cost of waiting, in 03 §12's Reading, 08's bullet, the record (English and Chinese), the study, PLAN §4.7 item 4, the module's Readings and REVIEW-RFM2-LEAN's literature table;
- "a strict reason to wait for another's reading only where that model leaves the sign of going on open" in 03 §12's Reading, and the overview's "strict reason to be corrected";
- the witness's model ("the gain one where going on gains, the loss one where it loses, else nothing") in 03 §12 and the record, against SignLoop.model, gainOf, lossOf and SignLoop.choose_hold_iff;
- "a formation holding exactly where holding for the reading gains over both moves on its own model" in the overview, the dossier, the root bullet, the checker's scope and the board;
- ShownOrder's importers in the root bullet and the study; the citations of shortfall_through and SignLoop.rests_unread;
- PLAN §4.6's list of what was not built then, §4.7's new title (and the study's link to it), §4.7 items 2, 4, 6 and 7, and §13's new paragraph;
- the study's two review paragraphs and its Output → input;
- REVIEW-RFM2-LEAN's updated rows (A6, A9, E7, F10), its re-check row 9 and its opening.
Report a one-line verdict, then only what is not taken correctly or is new, each with location, quote, problem and replacement; check that a replacement for a record field fits its cap in tools/research/style.py.
```

## Round 2, third part

### The review of the design (piped to `cx -m astra -e high --sandboxed --fresh`, in a rehearsal of main with RF-M.2 integrated and the draft at its root as `RFM3-DESIGN.md`)

```text
You are reviewing, read-only, a design for new formal results in this repository (do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine). Read AGENTS.md first: the theory's method (one relational unfolding, no separate subject; structural names; the pure core imports only Lean's Init and every axiom report is empty).

The design is RFM3-DESIGN.md at the checkout root, to become §4.8 of _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md ("Round 2, third part: the valuation as state; informing and shaping"). Read the plan's §4.7 (RF-M.2, built, and RF-M.3's paragraph, the redesign this design carries out) and the review of the second part's design, evidence/REVIEW-RFM2.md in the same folder (its findings 11 to 17 are what this design answers). It builds on Lean in experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/: HeldForReading.lean (RF-M.2, integrated in this checkout, not yet landed: Model, after, committed, shifted, byRule, byReading, shortfall, goExcess, offExcess, after_add_shortfall, shortfall_through, leastThrough, least_through, least_zero_iff, finer_least_le, through_threshold_iff, goExcessWithin, offExcessWithin, after_offset), Blanket.lean (Blanketed, Parts, step, course, agent_through_sensory), ReadingLoop.lean (Loop, the Untested witness with model_or_order and informed_turns), Learning.lean (Lumped). The records are theories/becoming/results/records/*.json (grep them).

Review the design as a second opinion, before any Lean is written:
1. Novelty on the spine. Is any law already stated in the package or the records (in particular in HeldForReading, ReadingLoop's Untested, ClosedCapture, RuleCapture, DrawnShaping, ReadInTime, ReadStages)? Name the declaration and say what would be reproved.
2. Exactness. Is each stated law true as stated, with its hypotheses complete? In particular: item 2's split (the term for each cell, what "decides the cell against the least rule" means at ties, cells listed but holding no listed candidate); item 3's agreement condition (net agreement per candidate; whether a common positive scale, or weaker, suffices; the reading formation's weights and listing equal to the holding formation's); item 4 (the finer map's hypotheses, and whether informing can still lower the worth where the weights differ but the valuation agrees); the numbers of items 5, 8 and 13 (check them); item 6's "lower exactly where"; item 7 (what "costs nothing through disagreement" says and does not); item 12's two halves (what the answer after a demonstration is on the holding formation's candidate worlds; whether "unshown" needs the start state not to depend on the world); item 10's carrier on Blanketed (whether the internal part can be the reading formation's listing and valuation with the update reading only the internal and sensory parts; the delays; the holding formation's state in the external part reading the answer); item 14 against the review's finding 15 (equal whole answer sequences and endpoints, different route properties, differing starts; whether the route property is defined independently of the endpoint).
3. The literature. Are the attributions right: Blackwell (1953); Kamenica and Gentzkow (2011) on Bayesian persuasion (the convexity condition for full disclosure, and whether a sender whose preferences coincide with the receiver's discloses fully); Crawford and Sobel (1982); Everitt, Hutter, Kumar and Krakovna (2021) on current-reward-function evaluation; Farquhar, Carey and Everitt (2022) on path-specific objectives; Carroll, Dragan, Russell and Hadfield-Menell (2022) on induced preference shifts; Hadfield-Menell, Dragan, Abbeel and Russell (2017) on the off-switch game. Say what is misread or misattributed, with the source's own statement where you can.
4. Strength and purpose. The purpose is a checkable account that alignment researchers and readers of coordination can use: what informing and shaping another formation do to the worth of deferring to its reading. Is there a stronger or more useful law in reach on these structures (for example: an exact condition on the valuation for informing never to lower the worth, over every refinement; the holding formation's choice among informing, shaping, holding and the two moves by the worth law, as a witness or a law; an iff for when withholding is worth more)? Is anything a wrapper or near-definitional result presented as more?
5. Names and framing. Is InformingShaping structural and exact? Are "reading formation", "holding formation", "measure", "valuation", "disagreement" right, or does any presuppose separate entities in a way the method forbids, and how should it be reconstructed?

Report numbered findings. For each: location (item number or line), the problem, and a replacement (text for the design, or a corrected statement of the law). Mark each finding confirmed by a check you ran, or a judgment. End with a one-paragraph verdict: which items to build as designed, which to change, which to drop.
```

### The review of `Becoming.ListingValuation` (piped to `cx -m astra -e high --sandboxed --fresh`, in the landing worktree at the kit's commit `801f74681`)

```text
You are reviewing, read-only, a new Lean 4 module in this repository (do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine). Read AGENTS.md first for the method, the naming rule and the pure core's requirements.

The module: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean, scratch-built with Lean 4.29.1 against this checkout's package (experiments/integrated-correction/general-framework/generative-basis/lean/becoming/): 105 theorems in 145 declarations, every axiom report empty, no warnings (log kit/round2c/logs/build-1.log; the audit driver kit/round2c/tree/.build/BecomingListingValuationAxiomAudit.lean is present though ignored by git). It imports Becoming.HeldForReading (landed on main as 03 §12's law r-what-holding-for-a-reading-is-worth, record theories/becoming/results/records/what-holding-for-a-reading-is-worth.json) and, through it, Becoming.ReadingLoop, Becoming.Blanket and Becoming.Learning; it reuses Becoming.total with its lemmas (Flow.lean's Totals section, Population.lean's total_congr_on, Dissipation.lean's total_eq_zero) and the Prelude's axiom-free arithmetic.

It implements the plan's §4.8, RF-M.3 (_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md), designed after your own review of the design's first draft: evidence/REVIEW-RFM3.md in the same folder, with a table saying where each of its 25 findings went.

Review it as a second opinion:
1. For each row of REVIEW-RFM3's table, is the finding taken in the Lean and in the module's header as the row says? Does the module meet §4.8's items 1 to 21 (statement by statement), and where it departs (a statement narrowed, widened or split, a helper added), is the departure right?
2. Exactness. Compare every docstring and every sentence of the module's header with the Lean statement it cites: dropped or superfluous hypotheses (cells listed once and covering; factoring on which listing; positive weight; the reading formation's model the holding formation's or not), "exactly" where one direction is proved, conclusions stronger than proved, and the Standing paragraph's labels. In particular: shortfall_split and the residual's criteria (ties, unweighted cells, truncated subtraction); answer_residual_zero_iff and the two sufficient conditions; told_residual_zero_iff and weightOf (a listing that repeats a candidate); informed_le (the coarse map's cells: are any hypotheses on them needed, or superfluous?); the definition SplitsKeep and refining_never_lowers_iff (is SplitsKeep the right condition, stated at the right generality, is the universally quantified side the property §4.8 item 6 describes, is the iff a genuine criterion or vacuous on some class of models); withhold_iff and withhold_through_iff; revalued_split, own_least, revalued_lowers_iff, outcome_least and revaluing_gains_iff (which model and which reference each uses); const_worth and the three witnesses of Part 1 (do the numbers in the docstrings match the statements). Do the names state exactly what the statements mean, in the repository's structural vocabulary?
3. The carrier (Part 2). Is `joint` a faithful Blanket.Blanketed law for what §4.8 items 16 to 19 describe: the four maps, the timing of an act sensed, taken in and read, the answer read from the updated state, the world unchanged? Do internal_step, active_step, sensory_step, external_step, active_answer, world_fixed, through_sensed (an instance of Blanketed.agent_through_sensory), updates_commute, answer_shown, inputs_alike and answer_constant state what their docstrings say, and is any conclusion an artifact of the construction (for example of `asked` and `hold` carrying nothing, or of the Holder reading only the answer)?
4. The witnesses Routes (§4.8 items 20 and 21): do shown_turns, presented_turns, shown_removes_least and presented_removes_residual show the four cases as stated (the step at which each answer is read, which intervention turns which start); do routes_alike, changed_apart and not_lumped show that the answers and the final reading state do not determine whether the valuation changed, without an artifact (the record's definition, the bound T ≥ 2, the starts differing)?
5. Reuse. Does the module reprove anything the package already has (list totals compared item by item, totals split by cells, cancellation and subtraction lemmas, filter lemmas, Bool case lemmas)? Name the declaration to reuse with its file:line, and check that it has an empty axiom report.
6. The literature claims in the header's Standing and Readings paragraphs: Blackwell (1953); Kamenica and Gentzkow (2011); Crawford and Sobel (1982); Everitt, Hutter, Kumar and Krakovna (2021); Farquhar, Carey and Everitt (2022); Hadfield-Menell, Dragan, Abbeel and Russell (2017), Theorem 1 and Remark 1; Carroll, Dragan, Russell and Hadfield-Menell (2022). Is each correspondence fair and no stronger than the Lean and the paper support?
7. Strength. Is a stronger or more useful statement in reach on these definitions for readers of alignment (assistance, informing a principal, preference change) and of coordination in institutions and networks, worth adding before landing? Is anything presented as more than it is?

Report numbered findings. For each: location (file:line), the problem, and a replacement (Lean or text). Mark each confirmed by a check you ran, or a judgment. End with a one-paragraph verdict.
```

### The three-lens review of `Becoming.ListingValuation` (a workflow of Opus readers, beside the cross-model reader)

Three readers, one lens each, given a common preamble and their lens, each asked to number its findings with the lens's letter; then one verifier per lens, given all of that lens's findings to refute. The proofs themselves were filled before these reviews by four Opus provers, one per group of declarations, from a skeleton whose statements they could not change; each built and audited its group in its own scratch tree.

The common preamble:

```text
You are an independent, adversarial reviewer of one Lean 4 module in a theory repository. Work read-only: read files and run read-only shell commands only; do not edit, create, commit, render, run make or build Lean. The module builds in the repository's pure core (Lean 4.29.1) with every axiom report empty and no warnings: 105 theorems in 145 declarations. Do not try to build it. The working directory is the checkout /Users/ren/theories/.claude/worktrees/rf-landing; paths below are relative to it.

The module: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean.
It imports Becoming.HeldForReading (experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldForReading.lean, landed: chapter 3 section 12's law "what holding an act for a reading is worth", record theories/becoming/results/records/what-holding-for-a-reading-is-worth.json) and through it Becoming.ReadingLoop, Becoming.Blanket and Becoming.Learning, and uses Becoming.total with its lemmas from Prelude.lean, Flow.lean, Population.lean and Dissipation.lean in experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/. The plan that asked for it: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md, section 4.8 (RF-M.3, items 1 to 21). The cross-model review of the design's first draft, with a table saying where each finding went: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3.md.

The module states, in natural-number counts on HeldForReading's models: the answer of a reading formation reading through a map by its own model and valuation; the split of any rule's shortfall (against a supplied reference valuation on the holding formation's model) into the least shortfall through the map and a residual, with exact criteria for the residual and for the answer's residual; informing (a finer map) and an exact criterion over every refinement (SplitsKeep); withholding against informing; revaluing (the answer by another valuation); answers constant over the listing; and witnesses. Then a carrier: one Blanket.Blanketed law whose internal part is the reading formation's listing and valuation state, with laws of timing, sensory dependence, the answer when shown and courses alike; and witnesses Routes of four cases and two routes not told apart by their answers and final state. Report only what you can point to in the files, with file:line locations and exact quotes. Severity: high (a claim the Lean does not prove, or a wrong or vacuous theorem), medium (a dropped hypothesis, an overstated reading, a reproved package lemma, a statement the header promises and the Lean lacks), low (wording or naming). Give a concrete replacement (Lean or text) for each finding, most severe first.
```

The exactness lens (findings E1, E2, …):

```text
Your lens: exactness of prose against statements, and the arithmetic. For every theorem and definition, compare its docstring, and every sentence of the module header (its bullets and its Standing, Readings, Modelling choices and Not in this module paragraphs) that cites it, with the Lean statement: hypotheses dropped or superfluous (cells listed once and covering; factoring on which listing; positive weight; the reading formation's model the holding formation's or not; net or scaled agreement where), quantifiers changed, "exactly" where only one direction is proved, conclusions stated more strongly than proved. Check the arithmetic: truncated subtraction in residual and its criteria; ties (the answer releases at ties, leastThrough stops at ties); candidates and cells of zero weight; a listing that repeats a candidate (weightOf); that SplitsKeep says what refining_never_lowers_iff's docstring and the header say, and that its two sides are not vacuous; that withhold_iff's amounts are in the units of the weighted totals; that every number in the witnesses' docstrings (scales_by_candidate, unweighted_told, Informing, Weights, no_order_across, Revaluing, Routes) matches the statement proved. Check the carrier's timing claims (an act emitted at t is sensed at t + 1, taken into the state and the answer at t + 2, read at t + 3) against joint and the step lemmas. Names must be structural and exact in the repository's vocabulary: flag dualist, social or financial words in Lean names and in prose (AGENTS.md, Proof and naming).
```

The sources lens (L1, L2, …):

```text
Your lens: the labelled readings and the literature. Check every attribution and correspondence in the header's Standing and Readings paragraphs and the docstrings against the works: Blackwell (1953), Equivalent comparisons of experiments; Kamenica and Gentzkow (2011), Bayesian persuasion; Crawford and Sobel (1982), Strategic information transmission; Everitt, Hutter, Kumar and Krakovna (2021), Reward tampering problems and solutions in reinforcement learning (current-reward-function evaluation); Farquhar, Carey and Everitt (2022), Path-specific objectives for safer agent incentives; Hadfield-Menell, Dragan, Abbeel and Russell (2017), The off-switch game, its Theorem 1 and Remark 1; Carroll, Dragan, Russell and Hadfield-Menell (2022), Estimating and penalizing induced preference shifts in recommender systems. Read the papers on the web where your tools allow it (load a fetch or search tool with ToolSearch if one is deferred); otherwise use your knowledge, and where unsure of a detail say so rather than assert it. For each correspondence: is it fair; does the module claim more or less than the paper proves; are the stated differences (no sender commitment or equilibrium, no cheap-talk equilibrium, an analogy of evaluation only, no path-specific objective constructed, no criterion of legitimate change) accurate and sufficient; is any reading presented as a theorem? Also check that the readings stay labelled readings and keep the repository's method (AGENTS.md: one relational unfolding first; the reading and the holding formation as roles in one law told apart by paths of sensing and control, not separate entities presupposed; no dualist words such as "agent", "user", "manipulation" used as if defined).
```

The structure lens (F1, F2, …):

```text
Your lens: structure, reuse, fit and strength. (1) Reuse: does the module reprove anything the package already has? Search experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/*.lean (HeldForReading.lean first) for totals split by cells or by a Boolean, totals compared item by item or strictly, filter lemmas, cancellation and subtraction lemmas (core forms without propext), products with a positive factor, Bool case lemmas; name each declaration to reuse with its file:line, and check its axiom report is empty (its proof uses no propext, Quot.sound or Classical.choice, including through omega, simp or funext). (2) Fit: is each row of REVIEW-RFM3.md's table taken in the Lean and in the module's account as the row says; does the module meet PLAN.md section 4.8 items 1 to 21, and where it departs (a statement narrowed, widened or split, a helper added, a hypothesis dropped), is the departure right; is joint a faithful Blanket.Blanketed law for items 16 to 19, and is through_sensed a correct instance of Blanketed.agent_through_sensory; is not_lumped a correct use of Learning.Lumped? (3) Strength: is a stronger or more useful statement in reach on the same definitions, worth adding before landing (for example: refining_never_lowers_iff specialized to a shared model and net agreement; a strict form of informed_le; the demonstration's effect on the least shortfall stated for every listing, joining answer_shown with finer_least_le; withhold_through_iff with the answer's residual zero)? Give the statement and a proof sketch for each, in priority order.
```

The verifier, for each lens's findings (followed by the findings as JSON, each with its id, severity, location, quote, problem and replacement):

```text
You are an adversarial verifier. Work read-only: read files and run read-only shell commands only; no edits, no builds. The working directory is the checkout /Users/ren/theories/.claude/worktrees/rf-landing. A reviewer reported the findings below on the Lean module _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean (the package is experiments/integrated-correction/general-framework/generative-basis/lean/becoming/; PLAN.md and evidence/REVIEW-RFM3.md are in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/). For each finding, try to refute it against the module's actual text and Lean statements and the files it cites. A finding is real only if the quoted text exists at or near the location and the problem holds against the Lean as written. A claimed reuse is real only if the named declaration exists, states what is needed, and has an empty axiom report (no propext, Quot.sound or Classical.choice: check its proof and what it uses). A suggested strengthening is real only if the stronger statement is true on these definitions and provable without axioms. A literature point is real only if you can confirm it; otherwise say it is unconfirmed. Default to real=false if you cannot confirm. For each finding give its id, real, your reason in two or three sentences, and, where the proposed replacement is wrong or could be better, a better replacement (else an empty string).
```

### The re-check of `Becoming.ListingValuation` (the cross-model reader's session continued, `cx -r`, read-only, in the landing worktree at the kit's commit `4843dd795`)

```text
The module you reviewed has been revised on your fifteen findings and on three further review lenses
(exactness, structure, literature), each verified. The revised file is

_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean

(commit 4843dd795; the version you reviewed is at commit 801f74681, so `git diff 801f74681 4843dd795 -- <that path>` shows every change). It builds against the package with every axiom report empty (129 theorems in 177 declarations, kit logs/build-2.log).

Please do two things, reading the file and the diff yourself.

1. For each of your fifteen findings, say whether the revision resolves it: resolved, partly, or not, with one line of reason. Where it is partly or not, give the exact replacement text or Lean you would want.

2. Review what is new or changed for exactness: every docstring and header sentence must say exactly what its Lean states, no more and no other; every literature sentence in the Readings must be accurate to the cited paper (Kamenica and Gentzkow 2011; Crawford and Sobel 1982; Everitt, Hutter, Kumar and Krakovna 2021, Claims 2 and 3; Farquhar, Carey and Everitt 2022; Hadfield-Menell, Dragan, Abbeel and Russell 2017, Equation 1, Theorem 1, Remark 1; Carroll, Dragan, Russell and Hadfield-Menell 2022; Alonso and Câmara 2016; Blackwell 1953). New declarations include residual_pos_of_gains, revaluing_gain, informed_le_add_residual, refined_lt_iff, add_lt_iff_sub_add_lt, forgone_least_iff, splitsKeep_of_net, splitsKeep_of_off_le_go, release_keeps, OneListing.refined_lowers, WeightsApart.weights_split, WeightsApart.not_splitsKeep, shown_split, shown_never_lowers, timing, inputs_alike_before, undemonstrated_alike, undemonstrated_worth, presented_forgone_lt_iff, revalued_forgone_lt_iff, TwoWorlds.route_answers, TwoWorlds.starts_apart, TwoWorlds.lumped_with_start, TwoWorlds.orders_apart.

Report each finding as: id, severity (high/medium/low), file:line, a short quote, the problem, and the exact replacement. Only real problems; say "none" where there are none. Do not edit any file.
```

### The check of how the lenses' findings were taken (a workflow of three Opus readers, one per lens, read-only)

Each reader was given its lens's findings with the verifier's verdicts as JSON (the lens named in the prompt as exactness, structure or sources), the reviewed commit and the working file:

```text
You are checking, read-only, how a set of review findings is reflected in a revised Lean module. Do not edit any file and do not run Lean or any build.

The module is Becoming.ListingValuation, a pure-core Lean 4 module in the repository at the landing worktree. The version that was reviewed is at commit 801f74681; read it with `git show 801f74681:<the kit path>`. The revised version is the working file (read it directly; it differs from commit 4843dd795 only in prose). `git diff 801f74681 -- <the kit path>` shows every change since the review, the working file included.

The findings are those of the <lens> lens, in a JSON file: each has an id, a severity, a location and quote in the reviewed version, the problem, a proposed replacement, and a verifier's verdict (real or not, with its reason).

For every finding, in id order, judge from the files alone how the revised module reflects it:
- taken: the revised module does what the finding asked, or fixes the problem another way that removes it (say which);
- taken in part: part of the problem remains (say exactly what, in gap);
- not taken: the problem remains as reviewed;
- superseded: the place no longer exists or the finding no longer applies, for a reason you state.
For a finding the verifier judged not real, report its verdict as "not real" and say whether the module changed at that place anyway. Check the Lean statements themselves, not only the prose: where a finding asked for a new law, find it and say whether its statement does what was asked; where it asked for a hypothesis to be named, check the docstring and header say it. Be exact and skeptical: a renamed declaration whose docstring still overstates is "taken in part". Quote at most a few words of the module where it helps. Return one row per finding.
```

### The check of the delta after the taken check (the cross-model reader's session continued, `cx -r`, read-only, in the landing worktree with the delta uncommitted)

```text
Read-only check, continuing your re-check of `Becoming.ListingValuation` (the kit module at
_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean).

Since your re-check, a check of how the three lenses' findings were taken found seven taken only in part. The module now:

1. Adds `unweighted_released` and `weighed_stops_iff` (the two `have`s of `told_residual_zero_iff`, factored) and
   `told_shortfall_zero_iff` (the shortfall form with no cell list), lens finding F9.
2. Adds `least_falls` (through a refinement the least shortfall never rises; `refined_lt_iff` now uses it),
   `informed_lt_iff` (the strict form of `informed_le`), F17, and `coarser_not_above` (with both answers least,
   through a refinement, the coarser answer forgoing no less never stands above the finer), F20.
3. Adds `shown_least_le` and the course forms `TwoWorlds.shown_course` and `TwoWorlds.presented_course`, F8.
4. Cites `undemonstrated_worth` beside `answer_constant` in the off-switch Readings, F4.
5. Retitles the docstrings of `refined_lt_iff` and `forgone_least_iff` and the header bullet structurally,
   the reading marked, L13.
6. Keeps your R2: the clause calling `answer_constant` failed effectiveness stays withdrawn (lens finding L8 asked
   for it; your counterexample stands).

The diff against the commit you re-checked is at
/private/tmp/claude-501/-Users-ren-theories/50635de9-b91e-4f4c-a63c-8413ce8c4652/scratchpad/rfm3-lv-delta.diff.
The module builds: 138 theorems in 186 declarations, every axiom report empty, no warnings.

Check only the delta: does each new statement say what its docstring and the header say it says (hypotheses,
direction, which formation's model, which amounts)? Is any new claim in the header, the Standing or the Readings
stronger than the Lean? Is the course-form arithmetic right? Report findings as a numbered list with severity,
location, the problem and an exact replacement; say plainly if there are none. Do not edit any file.
```

### The cold read of RF-M.3's texts (piped to `cx -m astra -e high --sandboxed --fresh`, run in a rehearsal of main with RF-M.3's module and texts integrated; and a workflow of three Opus readers, one per lens, each lens's findings given to one refuter)

The cross-model reader's cold read, on the rehearsal with the kit at `07a24e169`:

```text
Cold read, read-only, in <a rehearsal of main with RF-M.3 integrated> (a scratch copy of the repository with RF-M.3's module and texts integrated; do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine).

Context. This repository develops one theory with a pure Lean core. Board item RF, round 2, third part, RF-M.3 adds one Lean module, reviewed on the code by a cross-model reader and through three lenses (each lens's findings judged by a verifier), and re-checked: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ListingValuation.lean (Becoming.ListingValuation, a core leaf, 138 theorems in 186 declarations, every axiom report empty; it imports HeldForReading.lean). In natural-number counts it states the answer of a reading formation reading through a map by its own model and valuation; the split of any rule's shortfall, by a supplied reference on a holding formation's model, into the least shortfall through the map and a residual, with exact criteria (for the answer, told the candidate, and over every refinement); informing (a finer map) and revaluing, with their thresholds against amounts forgone and witnesses; and, on one blanketed law carrying the reading formation's listing and valuation, informing and revaluing executed, with two routes from different starts whose answers and final state do not determine whether the valuation changed.

The texts, integrated in <a rehearsal of main with RF-M.3 integrated> (paths relative to it):
1. theories/becoming/chapters/03-KNOWING.md: section 12's opening paragraph (its sentence ending "and what informing the reading formation and revaluing it do to that worth."), the new theorem paragraph at anchor r-a-reading-informed-and-revalued with its Reading paragraph (just before the anchor does-not-show), the pointer added to the acts-alike reading ("and informing and revaluing as acts within one law [another]"), and the Open bullet beginning "Formations that read, beyond".
2. theories/becoming/chapters/07-SIGNIFICANCE.md: section 7's sentences beginning "The reading that gives the stop can itself be moved".
3. theories/becoming/chapters/08-METHOD.md: section 8's known-results bullet on a reading informed and revalued.
4. theories/becoming/THE-THEORY-OF-BECOMING.md: section 3's paragraph on informing and revaluing, after the paragraph on holding for a reading.
5. theories/becoming/review/ALIGNMENT.md: the box "What the theory does not address" (its bullet on assistance games), the paragraph on RF's rounds (its sentences on RF-M.3), and the account of how the dossier was made (its entry on RF-M.3's sentences).
6. The package: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean (the L1 bullet for Becoming.ListingValuation, and HeldForReading's bullet, now imported by it), README.md and README.zh.md in the same folder (the Becoming.ListingValuation rows), check_becoming.py there (the scope sentence beginning "ListingValuation:").
7. The module's own header (its opening, bullets, Standing, Readings, Modelling choices and Not in this module) and docstrings.
8. The record's texts, in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py: the record a-reading-informed-and-revalued (title, statement, the 37 law items, hypotheses, does_not_show, counterexamples, validation, next_delta, correspondence, aliases, dependencies, related) and the amendments to related records (AMEND), English and Chinese.
9. The study section template _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/study_rfm3.txt ({N}, {RECEIPT}, (LISTINGVALUATION), {REVIEWS} and {COLDREAD} are filled at landing).
10. _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md: section 4.8 (its opening, Part 1's items 1 to 15, Part 2's items 16 to 21, Standing, Readings, Modelling choices, Not in this part), section 12's order, section 13's paragraphs on the third part's design review and on the reviews of its Lean, and the Evidence list.
11. theories/becoming/results/data/regions.json: the entries a-reading-informed-and-revalued and Becoming.ListingValuation.
12. The evidence of the Lean's reviews, _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md: its opening (what was verified, and how), and the three tables of what was taken (from the first review and the lenses, from the re-check, and from the check of the delta): does each row's 'how' match the module, the record script, the plan and the texts as they now stand? The reviews themselves are verbatim and not to be judged.

Repository rules that bear on the texts (from AGENTS.md): claims say exactly what the Lean proves (hypotheses, direction, strictness, ties); names are structural and exact, with no dualist, social or financial words beyond the roles the plan adopts (the reading formation and the holding formation, told apart by the paths of sensing and control); AI readings are labelled as readings and never presented as theorems; no ethical premise enters here; each live document is in one language, Chinese editions separate; repository-relative links.

Check each text against the Lean: hypotheses (the reading formation's model the holding formation's or not; agreement in net or on one positive scale at listed candidates of positive weight; cells listed once each and covering which listing; factoring on which listings; equality of cells decidable; the shared start of two courses and what differs), directions, strictness and ties (the answer releases at ties; the residual counts only decisions against the strict weighted preference), which formation's model, valuation or reference evaluates which answer, what is quantified (an unrestricted pair of value functions, not a reachable valuation; a given input presented), the amounts forgone in the units of the weighted totals, names, counts, links and anchors; that the readings stay readings and the citations are accurate (Kamenica and Gentzkow 2011; Alonso and Câmara 2016; Crawford and Sobel 1982; Everitt, Hutter, Kumar and Krakovna 2021, Claims 2 and 3; Farquhar, Carey and Everitt 2022; Hadfield-Menell, Dragan, Abbeel and Russell 2017, Equation 1, Theorem 1, Remark 1; Carroll, Dragan, Russell and Hadfield-Menell 2022; Blackwell 1953). Check the Chinese texts against the English.

Report numbered findings. For each: file:line, a short quote, the problem, and the exact replacement text. Only real problems; say "none" where a text has none. End with a one-paragraph verdict.
```

Its first re-check (the same session continued, `cx -r`, read-only, in a rehearsal rebuilt at the same path on the kit at `18001d918` with main at `8a8b0df82`):

```text
You re-check, read-only, RF-M.3's texts after your cold read. Your working directory is now <a rehearsal of main with RF-M.3 integrated>: main at 8a8b0df82 (after RV21's item 13 landed) merged with the kit at 18001d918, with the kit's integration applied (nothing committed; do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine). The rehearsal you read before was rebuilt at the same path; paths below are relative to it. The diff of the kit since the commit you read (07a24e169) is at the checkout's root as rfm3-coldread-delta.diff; the integrated texts are in place.

Your cold read found six points. Check how each was taken:
1. the loss of a revision qualified as deciding a listed cell against the current valuation's strict weighted preference: 03 §12's Reading, 07 §7, 08 §8's bullet, the overview, the dossier, the study, PLAN §4.8 and the record's correspondence (English and Chinese, in kit/round2c/make_records_rfm3.py);
2. the record's Chinese law on deciding a whole cell, against split_cell_le;
3. going on, switching off and holding, not every act of the holding formation, change neither the candidate world nor the reading formation (the record's premise, English and Chinese; the study);
4. the record's hypotheses on cell lists, now two items, against shortfall_split, residual_zero_iff, residual_pos_iff, answer_residual_zero_iff, told_residual_zero_iff, least_falls, informed_le, informed_lt_iff and refining_never_lowers_iff;
5. REVIEW-RFM3-LEAN's row R5;
6. the dossier's entry on how it was made (the works named; its date is written by the integration at landing, today's here).

Also read, as text new since your cold read:
- the overview §3's paragraph on informing and revaluing, cut to about 105 words for a reading budget, linking down to 03 §12;
- the dossier's RF-M.3 sentences in the paragraph on RF's rounds, cut to about 140 words;
- RF's PLAN §5's table row on preference shaping, and §8's rows on preference shifts (Carroll and others 2022), Blackwell and Bayesian persuasion, corrigibility as an incentive (placed through RR's RevisionRoutes in 07 §7, RF-M.2 and RF-M.3), reward tampering and path-specific objectives, and Crawford and Sobel;
- the study template's paragraph "The reviews, and what was taken" (kit/round2c/study_rfm3.txt).
Check each against the Lean (Becoming/ListingValuation.lean; Becoming/RevisionRoutes.lean and 07 §7's record when-no-route-stands-above-a-revision for RR's clause; Becoming/HeldForReading.lean) and against the cited works as your cold read and the reviews read them.

Report a one-line verdict, then only what is not taken correctly or is new, each with location, the quoted text, the problem and an exact replacement (English, and Chinese where the text is Chinese); a replacement for a record field must fit its cap in tools/research/style.py (ITEM_CAPS_V2: 420 characters in English and 190 in Chinese per item). Say plainly if there is nothing. Do not edit any file.
```

The workflow's first run, on the first rehearsal, stopped at a usage limit before any reader returned. It ran again after the cross-model reader's points and its first re-check were taken, on a rehearsal rebuilt at the same path on the kit at `3f43eefcf` with main at `8a8b0df82`, with these texts, common to its three readers and the refuters:

```text
The Lean (the source of truth): experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ListingValuation.lean (Becoming.ListingValuation, a core leaf, 138 theorems in 186 declarations, every axiom report empty; it imports HeldForReading.lean in the same folder, which brings Blanket.lean and Learning.lean through ReadingLoop.lean, and uses Becoming.total with its lemmas from Prelude.lean, Flow.lean, Population.lean and Dissipation.lean). RR's Becoming/RevisionRoutes.lean, with 07 section 7's record when-no-route-stands-above-a-revision, is cited by the plan's row on corrigibility as an incentive.

The texts, integrated in a scratch copy of the repository at <a rehearsal of main with RF-M.3 integrated> (read-only; do not edit, create, commit, render, run make, or build Lean; paths below are relative to it):
1. theories/becoming/chapters/03-KNOWING.md: section 12's opening paragraph (its sentence ending "and what informing the reading formation and revaluing it do to that worth."), the new theorem paragraph at anchor r-a-reading-informed-and-revalued with its Reading paragraph (just before the anchor does-not-show), the pointer added to the acts-alike reading ("and informing and revaluing as acts within one law [another]"), and the Open bullet beginning "Formations that read, beyond".
2. theories/becoming/chapters/07-SIGNIFICANCE.md: section 7's sentences beginning "The reading that gives the stop can itself be moved".
3. theories/becoming/chapters/08-METHOD.md: section 8's known-results bullet on a reading informed and revalued.
4. theories/becoming/THE-THEORY-OF-BECOMING.md: section 3's paragraph on informing and revaluing (about 105 words, cut for a reading budget and linking down to 03 section 12), after the paragraph on holding for a reading.
5. theories/becoming/review/ALIGNMENT.md: the box "What the theory does not address" (its bullet on assistance games), the paragraph on RF's rounds (its sentences on RF-M.3, about 140 words, cut for a reading budget), and the account of how the dossier was made (its entry on RF-M.3's sentences).
6. The package: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean (the L1 bullet for Becoming.ListingValuation, and HeldForReading's bullet, now imported by it), README.md and README.zh.md in the same folder (the Becoming.ListingValuation rows), check_becoming.py there (the scope sentence beginning "ListingValuation:").
7. The module's own header (its opening, bullets, Standing, Readings, Modelling choices and Not in this module) and docstrings.
8. The record's texts, in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py: the record a-reading-informed-and-revalued (title, statement, the 37 law items, hypotheses, does_not_show, counterexamples, validation, next_delta, correspondence, aliases, dependencies, related) and the amendments to related records (AMEND), English and Chinese.
9. The study section template _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/study_rfm3.txt ({N}, {RECEIPT}, (LISTINGVALUATION) and {COLDREAD} are filled at landing; its paragraph "The reviews, and what was taken" is written).
10. _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md: section 4.8 (its opening, Part 1's items 1 to 15, Part 2's items 16 to 21, Standing, Readings, Modelling choices, Not in this part), section 5's table row on preference shaping, section 8's literature rows on preference shifts, Blackwell and Bayesian persuasion, corrigibility as an incentive (placed through RR's RevisionRoutes, RF-M.2 and RF-M.3), reward tampering and path-specific objectives, and Crawford and Sobel, section 12's order, section 13's paragraphs on the third part's design review and on the reviews of its Lean, and the Evidence list.
11. theories/becoming/results/data/regions.json: the entries a-reading-informed-and-revalued and Becoming.ListingValuation.
12. The evidence of the Lean's reviews, _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md: its opening (what was verified, and how) and the three tables of what was taken (from the first review and the lenses, from the re-check, and from the check of the delta): does each row's 'how' match the module, the record script, the plan and the texts as they now stand? The reviews themselves are verbatim and not to be judged.

Repository rules that bear on the texts (from AGENTS.md): claims say exactly what the Lean proves (hypotheses, direction, strictness, ties); names are structural and exact, with no dualist, social or financial words beyond the roles the plan adopts (the reading formation and the holding formation, told apart by the paths of sensing and control); AI readings are labelled as readings and never presented as theorems; no ethical premise enters here; each live document is in one language, Chinese editions separate; repository-relative links.
```

The exactness lens ("You are a cold reader checking texts against Lean, adversarially. Work read-only: read files and run read-only shell commands only (you may search the web where your lens asks); do not edit, create, commit, render, run make or build Lean. The working directory for paths below is <a rehearsal of main with RF-M.3 integrated>.", then the texts, then):

```text
Your lens: exactness. For every claim in texts 1 to 12, check it against the Lean statements in ListingValuation.lean (and HeldForReading.lean, Blanket.lean, Learning.lean or RevisionRoutes.lean where a text cites their laws): the hypotheses (the reading formation's model the holding formation's or not; agreement in net, or on one positive scale, at listed candidates of positive weight; cells listed once each and covering which listing, for which map; factoring on which listings; equality of cells decidable; what two courses share at the start and what differs), the direction of each iff, strictness and ties (the answer releases at ties; the residual counts only decisions against the strict weighted preference), which formation's model, valuation or reference evaluates which answer, what is quantified (an unrestricted pair of value functions, not a reachable valuation; a given input presented), the amounts forgone (in the units of the weighted totals, on which side each is added), the names and their backticks, and the counts (theorems, declarations, laws). Check the Chinese texts (README.zh.md's row, the record's zh fields) say the same as the English. Report only what is wrong, overstated, missing a hypothesis, or inconsistent between texts.

Return findings: severity, location (file:line), the quoted text, the problem against the Lean, and a replacement.

Number your findings <X, R or T>1, <X, R or T>2, … in your ids.
```

The readings lens ("You are a cold reader checking the readings and citations, adversarially. Work read-only: read files and run read-only shell commands only (you may search the web where your lens asks); do not edit, create, commit, render, run make or build Lean. The working directory for paths below is <a rehearsal of main with RF-M.3 integrated>.", then the texts, then):

```text
Your lens: the AI readings and the literature. Check every attribution against what the sources say (you may search the web and read the papers): Kamenica and Gentzkow (2011), "Bayesian persuasion" (full disclosure and the convexity of the sender's value in the posterior; the receiver's tie-breaking; the common prior); Alonso and Câmara (2016), "Bayesian persuasion with heterogeneous priors"; Crawford and Sobel (1982), "Strategic information transmission" (partition equilibria, the most informative equilibrium's welfare before the state is observed); Everitt, Hutter, Kumar and Krakovna (2021), "Reward tampering problems and solutions in reinforcement learning", arXiv 1908.04734 (current-reward-function evaluation, the agent anticipating time inconsistency, Claims 2 and 3, their assumptions); Farquhar, Carey and Everitt (2022), "Path-specific objectives for safer agent incentives" (the delicate state under a baseline action, Proposition 1); Hadfield-Menell, Dragan, Abbeel and Russell (2017), "The off-switch game", arXiv 1611.08219 (Equation 1, Theorem 1, Remark 1); Carroll, Dragan, Russell and Hadfield-Menell (2022), "Estimating and penalizing induced preference shifts in recommender systems", arXiv 2204.11966 (frozen initial preferences as a crude baseline; safe shifts); Blackwell (1953), the comparison of experiments; Soares, Fallenstein, Yudkowsky and Armstrong (2015), "Corrigibility" (corrigibility as an incentive), for the plan's row. Check that readings are labelled as readings, claim nothing the Lean does not prove, and do not overstate what the witnesses show (the routes start apart; with the start added the record determines the property; the four cases are single updates; the four alternatives are one decision with no choice represented). Check the readings of withholding, revaluing, keeping the valuation, corrigibility and assistance for consistency across 03, 07, 08, the overview, the dossier, the module, the record and the plan. Report only what is wrong or overstated.

Return findings: severity, location (file:line), the quoted text, the problem, and a replacement.

Number your findings <X, R or T>1, <X, R or T>2, … in your ids.
```

The fit lens ("You are a cold reader checking how the new texts fit where they are placed, adversarially. Work read-only: read files and run read-only shell commands only (you may search the web where your lens asks); do not edit, create, commit, render, run make or build Lean. The working directory for paths below is <a rehearsal of main with RF-M.3 integrated>.", then the texts, then):

```text
Your lens: fit and coherence. Does each text read well in its section and agree with the texts around it (03 section 12's other laws and their readings, notably what holding for a reading is worth just before; 03's Open bullet; 07 section 7's paragraph on executable change; 08 section 8's other bullets and their style; the overview's section 3; the dossier's box and its other bullets; the package README's rows and the root bullets around HeldForReading's)? Are the links and anchors right (anchors exist; repository-relative links resolve from each file)? Are the same results named the same way everywhere (the reading formation and the holding formation, the least shortfall and the residual, informing and revaluing, splits keep the worth)? Is anything stated in two places in a way that will drift, or a sentence a reader cannot follow? Do the record's fields stay within their roles (statement, laws, hypotheses, does_not_show, counterexamples, validation, next_delta, correspondence)? Is each text as short as its place allows? The overview's paragraph and the dossier's sentences were cut for reading budgets: flag a lost deciding hypothesis or a sentence a reader cannot follow, not needed length. Do the plan, study and evidence texts describe the item and its review history accurately (the evidence files are in the study folder's evidence/: REVIEW-RFM3.md and REVIEW-RFM3-LEAN.md)? Report only what is wrong, unclear or inconsistent.

Return findings: severity, location (file:line), the quoted text, the problem, and a replacement.

Number your findings <X, R or T>1, <X, R or T>2, … in your ids.
```

The refuter of each lens, given all of that lens's findings ("You are an adversarial verifier. Work read-only: read files and run read-only shell commands only; no edits, no builds. The working directory for paths below is <a rehearsal of main with RF-M.3 integrated>.", then the texts, then):

```text
A cold reader (lens: <lens>) reported the findings below. For each, try to refute it against the files: read the quoted location and the Lean it concerns. A finding is real only if the quoted text exists at or near the location and the problem holds as stated against the Lean, the sources or the surrounding texts; a matter of taste with nothing wrong is not real. Default to real=false if you cannot confirm it. For each finding give its id, real, a reason in two or three sentences citing what you read, and, where the proposed replacement is wrong or could be better, a better replacement.

<the findings, each with its id, severity, location, quoted text, problem and proposed replacement>
```

Its second re-check, of how the lenses' findings were taken (the same session continued, `cx -r`, read-only, in a rehearsal rebuilt at the same path on the kit at `22a113c0c` with main at `2f4a5bd96`, the diff of the study folder since `18001d918` at its root as `rfm3-coldread2-delta.diff`):

```text
You re-check, read-only, how RF-M.3's texts took the cold read's lens findings. Your working directory is again <a rehearsal of main with RF-M.3 integrated>: main at 2f4a5bd96 merged with the kit at 22a113c0c, with the kit's integration applied (nothing committed; do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine). The rehearsal you read before was rebuilt at the same path; paths below are relative to it. The diff of the kit's study folder since the commit your first re-check read (18001d918) is at the checkout's root as rfm3-coldread2-delta.diff, the generated cold-read page and the brief left out; the integrated texts are in place.

After your first re-check was taken, three Opus readers read the texts through three lenses, exactness (X1 to X19), readings (R1 to R14) and fit (T1 to T31), each lens's findings given to a separate reader asked to refute them: 64 findings, 54 confirmed and 10 refuted. Each finding with its verdict, and what was taken for each, is in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-COLDREAD.md (the section "The three lenses" and the table "What was taken from the lenses"). X19 is RR's sentence in 08 §8, already on main: it is handed to RR's second item, which lands after RF-M.3, and is not changed here.

Check, against the Lean (Becoming/ListingValuation.lean in the package folder: its header, the docstring of WeightsApart.not_splitsKeep and one section heading were revised, its statements unchanged, rebuilt at 138 theorems in 186 declarations with every axiom report empty) and against the cited works as your cold read and the reviews read them:
1. that each confirmed finding was taken as that table says, in every place it names, and that the change is right: no new error, and no claim wider or narrower than the Lean;
2. that each refuted finding left unchanged is fine as it stands, and that those taken all the same are harmless;
3. as text new since your first re-check: the overview's paragraph on informing and revaluing (now opening "Proved in natural-number counts"); the dossier's clause on assistance games in its scope box, its RF-M.3 sentences in the paragraph on RF's rounds, and its entry on how it was made; 07 §7's sentence on moving the reading that gives the stop; 08 §8's bullet; the root module's L1 bullet and the checker's scope sentence; both README rows; in RF's PLAN, §4.7's paragraph on RF-M.3, §4.8's items 4, 6, 7, 8 and 10, its Standing and Readings, §5's row on preference shaping, §8's row on preference shifts, §12's entry, §13's new paragraph "The cold read of the third part's texts" and the Evidence list; the study template (kit/round2c/study_rfm3.txt), its Delta's bullets on informing, amounts forgone, revaluing and the carrier, its Standing, its paragraphs "The reviews, and what was taken" and "The cold read of the texts", and its self-review item 2; the record's texts in kit/round2c/make_records_rfm3.py (the laws, hypotheses, next_delta, correspondence, aliases, related and the amendments, AMEND), English and Chinese; and the opening and the tables of REVIEW-RFM3-COLDREAD.md, and the opening and the rows A10, E10, F14, F16, F20, L9, R1 and R5 of REVIEW-RFM3-LEAN.md.

Report a one-line verdict, then only what is not taken correctly or is new, each with location, the quoted text, the problem and an exact replacement (English, and Chinese where the text is Chinese); a replacement for a record field must fit its cap in tools/research/style.py (ITEM_CAPS_V2: 420 characters in English and 190 in Chinese per law item; correspondence 1200 and 500; next_delta 400 and 180). Say plainly if there is nothing. Do not edit any file.
```

Beside it, the check of how the lenses' findings were taken (a workflow of three Opus readers, one per lens, read-only, in the same rehearsal; each reader's gaps given to one refuter). Each reader (with `<lens>` and `<ids>` exactness and X1 to X19, readings and R1 to R14, or fit and T1 to T31):

```text
You check, read-only, how one lens's findings from a cold read were taken into the texts of RF-M.3 (the module Becoming.ListingValuation and its texts) in a theory repository.

The checkout is <a rehearsal of main with RF-M.3 integrated>: the theory repository's main merged with RF-M.3's kit, the kit's integration applied, nothing committed. Do not edit, create or delete any file, commit, render, run make or build Lean; reading files and read-only shell commands (cat, sed -n, grep, git diff, git show) are fine. Paths below are relative to the checkout.

Where things are:
- The Lean, the authority for what is proved: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ListingValuation.lean. Its statements were not changed by the cold read; its header, the docstring of WeightsApart.not_splitsKeep and one section heading were revised.
- The cold read's page: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-COLDREAD.md. The section "The three lenses" gives each finding (id, lens, severity, verdict, the finding, the judge's reasoning); the table "What was taken from the lenses" says, for each id, what was done.
- The texts as integrated: theories/becoming/THE-THEORY-OF-BECOMING.md (the overview), theories/becoming/chapters/03-KNOWING.md §12, 07-SIGNIFICANCE.md §7, 08-METHOD.md §8, theories/becoming/review/ALIGNMENT.md (the dossier), the package's Becoming.lean (the root module's bullet on ListingValuation) and check_becoming.py (its scope sentence), the package's README.md and README.zh.md, and _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md.
- The kit's templates, written at the landing and not yet applied: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/study_rfm3.txt (the study's section), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py (the new record's texts in English and Chinese, and AMEND, its amendments of existing records), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/s12_rfm3.txt (03 §12's paragraph, applied), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/integrate_rfm3.py (the integration's edits, applied), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/evidence_rfm3_lean.py and the page it wrote, _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md.
- rfm3-coldread2-delta.diff at the checkout's root: the diff of the study folder from before the lens changes to now (generated pages left out); `git diff` shows the integration against the merged head.

Record fields have caps (tools/research/style.py, ITEM_CAPS_V2): a law item 420 characters in English and 190 in Chinese; correspondence 1200 and 500; next_delta 400 and 180. A replacement for a record field must fit its cap.

Your lens is <lens> (ids <ids>). For each of its findings, read the finding and its row in the table "What was taken from the lenses". Then check, in every place the finding or the row names, and wherever else the same claim recurs across these texts (a claim summarized in several places must say the same thing everywhere), that it was taken as the row says and that the change is right against the Lean: no new error, no claim wider or narrower than the Lean proves. For a finding refuted and left unchanged, check that leaving it is fine. For one taken all the same, that the change is harmless. X19 is another item's sentence in 08 §8 already on main, handed to that item's landing: do not count it as not taken. Check also that the table's own description of what was done matches the files.

Report every id of your lens with its status: taken (fully and correctly), in_part, not_taken, or problem (taken, but the change introduced an error). For each not fully right, give the location (file and nearest heading or line), the quoted text as it stands, the problem, and an exact replacement (English, and Chinese where the text is Chinese). Add entries with id "new" for any new problem you meet in the passages the lens's findings touch. Be exact: where a claim's scope is at issue, quote the Lean statement. Do not report style preferences that do not change what a sentence says.
```

The refuter of each reader's gaps:

```text
A checker read how a cold read's <lens> findings were taken into RF-M.3's texts and reported the gaps below. Try to refute each one. Is it real: does the text as it stands say what the checker claims, and does the Lean (quote the statement) make the text wrong, or the claim wider or narrower than proved? Is it already met elsewhere, or was it decided otherwise for a stated reason in the table "What was taken from the lenses"? If real, is the replacement right, within its cap, and consistent with the other places that summarize the same claim? Correct it where it is not. Default to real=false where the checker's case does not hold on the files.

The checkout is <a rehearsal of main with RF-M.3 integrated>: the theory repository's main merged with RF-M.3's kit, the kit's integration applied, nothing committed. Do not edit, create or delete any file, commit, render, run make or build Lean; reading files and read-only shell commands (cat, sed -n, grep, git diff, git show) are fine. Paths below are relative to the checkout.

Where things are:
- The Lean, the authority for what is proved: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ListingValuation.lean. Its statements were not changed by the cold read; its header, the docstring of WeightsApart.not_splitsKeep and one section heading were revised.
- The cold read's page: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-COLDREAD.md. The section "The three lenses" gives each finding (id, lens, severity, verdict, the finding, the judge's reasoning); the table "What was taken from the lenses" says, for each id, what was done.
- The texts as integrated: theories/becoming/THE-THEORY-OF-BECOMING.md (the overview), theories/becoming/chapters/03-KNOWING.md §12, 07-SIGNIFICANCE.md §7, 08-METHOD.md §8, theories/becoming/review/ALIGNMENT.md (the dossier), the package's Becoming.lean (the root module's bullet on ListingValuation) and check_becoming.py (its scope sentence), the package's README.md and README.zh.md, and _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md.
- The kit's templates, written at the landing and not yet applied: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/study_rfm3.txt (the study's section), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py (the new record's texts in English and Chinese, and AMEND, its amendments of existing records), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/s12_rfm3.txt (03 §12's paragraph, applied), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/integrate_rfm3.py (the integration's edits, applied), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/evidence_rfm3_lean.py and the page it wrote, _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md.
- rfm3-coldread2-delta.diff at the checkout's root: the diff of the study folder from before the lens changes to now (generated pages left out); `git diff` shows the integration against the merged head.

Record fields have caps (tools/research/style.py, ITEM_CAPS_V2): a law item 420 characters in English and 190 in Chinese; correspondence 1200 and 500; next_delta 400 and 180. A replacement for a record field must fit its cap.

The gaps (JSON):
<the gaps, each with its id, status, location, quoted text, problem and replacement>
```

Its third re-check, of how the second re-check's point and the check's gaps were taken (the same session continued, `cx -r`, read-only, in a rehearsal rebuilt at the same path on the kit at `539078292` with main at `485c6f87c`, the diff of the study folder since `22a113c0c` at its root as `rfm3-check-delta.diff`):

```text
You re-check, read-only, how RF-M.3's texts took your second re-check's point and the check beside it. Your working directory is again <a rehearsal of main with RF-M.3 integrated>, rebuilt at the same path: main at 485c6f87c (LA4's formal part, fm-cond1 and MA4c landed since) merged with the kit at 539078292, with the kit's integration applied (nothing committed; do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine). The diff of the kit's study folder since the commit your second re-check read (22a113c0c) is at the checkout's root as rfm3-check-delta.diff, the generated cold-read page and the brief left out; the integrated texts are in place.

Beside your second re-check, three Opus readers, one per lens, checked how every lens finding was taken, each reader's gaps given to a refuter: 14 gaps, every one judged real; with your point, 12 distinct points. Each gap, its verdict and what was taken are in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-COLDREAD.md, the section "The check of how the lenses' findings were taken" and its table; your point's row is in the table after your second re-check.

Check, against the Lean (Becoming/ListingValuation.lean in the package folder: only its header changed, the bullet on the carrier and the Readings paragraph, its statements unchanged, rebuilt at 138 theorems in 186 declarations with every axiom report empty) and against the cited works as your cold read and the reviews read them:
1. that your point and each gap were taken as those tables say, in every place they name, and that each change is right: no new error, and no claim wider or narrower than the Lean;
2. as text new since your second re-check: PLAN §5's row on preference shaping, §4.8's item 12 and Readings, and §13's paragraph "The cold read of the third part's texts"; 03 §12's Reading; the overview's paragraph on informing and revaluing; the dossier's entry on how it was made; the root module's L1 bullet and the checker's scope sentence; the module header's bullet on the carrier and its Readings; the study template's bullet on the carrier, its Output → input and its paragraph "The cold read of the texts"; the record's law on a demonstration, its Chinese law on amounts forgone and its correspondence, English and Chinese, in kit/round2c/make_records_rfm3.py; the board's landing text in kit/round2c/board_rfm3.py and the re-point's reason in kit/round2c/repoint_rfm3.py; the cold-read page's opening, its new section and tables, and the Lean review page's row R5.

Report a one-line verdict, then only what is not taken correctly or is new, each with location, the quoted text, the problem and an exact replacement (English, and Chinese where the text is Chinese); a replacement for a record field must fit its cap in tools/research/style.py (ITEM_CAPS_V2: 420 characters in English and 190 in Chinese per law item; correspondence 1200 and 500; next_delta 400 and 180). Say plainly if there is nothing. Do not edit any file.
```

Beside it, the check of the check's changes (a workflow of two Opus readers, read-only, in the same rehearsal; each reader's gaps given to one refuter). The context given to both readers and both refuters, in place of `<context>` below:

```text
The checkout is <a rehearsal of main with RF-M.3 integrated>: the theory repository's main merged with RF-M.3's kit (commit 539078292), the kit's integration applied, nothing committed. Do not edit, create or delete any file, commit, render, run make or build Lean; reading files and read-only shell commands (cat, sed -n, grep, git diff, git show) are fine. Paths below are relative to the checkout.

Where things are:
- The Lean, the authority for what is proved: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ListingValuation.lean (its statements unchanged in this round; its header's bullet on the carrier and its Readings paragraph revised).
- _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-COLDREAD.md: the cold read of RF-M.3's texts and its re-checks. Its last sections, "The re-check of the lenses' findings" and "The check of how the lenses' findings were taken", give the latest 15 reports (one from the cross-model reader, 14 from three Opus readers, every one judged real by a refuter), 12 distinct points, and the tables of what was taken for each.
- rfm3-check-delta.diff at the checkout's root: the diff of the study folder for this round (the kit's templates and scripts, the plan, the Lean review's page; the cold-read page and the brief left out). `git diff` shows the integration against the merged head.
- The integrated texts: theories/becoming/THE-THEORY-OF-BECOMING.md (the overview), theories/becoming/chapters/03-KNOWING.md §12, 07-SIGNIFICANCE.md §7, 08-METHOD.md §8, theories/becoming/review/ALIGNMENT.md (the dossier), the package's Becoming.lean (the root module's L1 bullet) and check_becoming.py (the scope sentence), the package's README.md and README.zh.md, _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md.
- The kit's templates, written at the landing: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/study_rfm3.txt (the study's section), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py (the new record a-reading-informed-and-revalued in English and Chinese, and AMEND), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/board_rfm3.py (the board's landing text), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/repoint_rfm3.py (the re-point's reason), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md (the Lean review's page, its row R5).

Record fields have caps (tools/research/style.py, ITEM_CAPS_V2): a law item 420 characters in English and 190 in Chinese; correspondence 1200 and 500; next_delta 400 and 180. A replacement for a record field must fit its cap.
```

The reader of how the last round was taken:

```text
You check, read-only, how RF-M.3's texts took the last round of review: 12 distinct points (the cross-model reader's second re-check, point 1; and the Opus check's gaps XC1 to XC5, RC1 to RC4 and TC1 to TC5), each with what was taken in the tables at the end of the cold-read page.

<context>

For each point: read it and its row; then check, in every place it names and wherever else the same claim recurs across these texts, that it was taken as the row says, and that the change is right against the Lean: no new error, no claim wider or narrower than the Lean proves, consistent across places, and within the record caps. Report every point with its status (taken, in_part, not_taken, or problem: taken but the change introduced an error); for each not fully right, the location, the quoted text, the problem and an exact replacement (English, and Chinese where the text is Chinese). Where a claim's scope is at issue, quote the Lean statement. Do not report style preferences that do not change what a sentence says.
```

The cold reader of the changed passages:

```text
You read cold, adversarially and read-only, the passages of RF-M.3's texts changed in its last round of review, as text in its place: is each exact against the Lean (hypotheses: the reading formation's model the holding formation's or not; net agreement; cells listed once each and covering; which listed worlds are told apart; what is a reading and what is proved), does it read well and agree with the sentences around it and with the other places that summarize the same claim, and are its citations right?

<context>

The passages: PLAN §5's row on preference shaping, §4.8's item 12 and its Readings, and §13's paragraph "The cold read of the third part's texts"; 03 §12's Reading after the theorem on informing and revaluing; the overview's paragraph on informing and revaluing ("What another's reading answers can be moved…"); the dossier's entry on how it was made (its sentence on RF-M.3); the root module's L1 bullet on ListingValuation and the checker's scope sentence on it; the module header's bullet on the carrier and its Readings paragraph (the one on own_least and revalued_lowers_iff); the study template's bullet on the carrier, its Output → input and its paragraph "The cold read of the texts"; the record's law on a demonstration, its Chinese law on amounts forgone and its correspondence, English and Chinese; the board's landing text (board_rfm3.py) and the re-point's reason (repoint_rfm3.py); the cold-read page's opening paragraphs and its section "The check of how the lenses' findings were taken" with its table; the Lean review page's row R5. rfm3-check-delta.diff shows what changed in the kit's files; the integrated texts show the rest in place.

Report only real problems, each with the id "new", the location, the quoted text, the problem and an exact replacement (English, and Chinese where the text is Chinese); a summary line first. Quote the Lean statement where a claim's scope is at issue. Do not report style preferences that do not change what a sentence says. Say plainly in the summary if there is nothing.
```

The refuter of each reader's gaps (with `<reader>` “of how the last round of review was taken” for the first and “reading the changed passages cold” for the second):

```text
A reader (<reader>) reported the gaps below in RF-M.3's texts. Try to refute each one. Is it real: does the text as it stands say what the reader claims, and does the Lean (quote the statement) make it wrong, or the claim wider or narrower than proved, or does it disagree with the other places that state the same claim? Was it decided otherwise for a stated reason in the cold-read page's tables? If real, is the replacement right, within its cap, and consistent with the other places? Correct it where it is not. Default to real=false where the reader's case does not hold on the files.

<context>

The gaps (JSON):
<the gaps, each with its id, status, location, quoted text, problem and replacement>
```

Its fourth re-check, of how the second check's gaps were taken (the same session continued, `cx -r`, read-only, in a rehearsal rebuilt at the same path on the kit at `bd5277f14` with main at `c3a2f0fc4`, one board commit after the `3bc356d1b` the prompt names, the diff of the study folder since `539078292` at its root as `rfm3-final-delta.diff`):

```text
You re-check, read-only, how RF-M.3's texts took the last check beside your third re-check. Your working directory is again <a rehearsal of main with RF-M.3 integrated>, rebuilt at the same path: main at 3bc356d1b (MV's landing, study §472, and board lines since 485c6f87c) merged with the kit at bd5277f14, with the kit's integration applied (nothing committed; do not edit, create, commit, render, run make or build Lean; reading files and read-only shell commands are fine). The diff of the kit's study folder since the commit your third re-check read (539078292) is at the checkout's root as rfm3-final-delta.diff, the generated cold-read page and the brief left out; the integrated texts are in place.

Beside your third re-check, two Opus readers checked the same texts, one how the 12 points were taken and one reading the changed passages cold, each reader's gaps given to a refuter: 11 gaps, every one judged real, 9 distinct points. Each gap, its verdict and what was taken are in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-COLDREAD.md, the section "The check of the check's changes" and its table.

Check, against the Lean (Becoming/ListingValuation.lean in the package folder: only docstrings changed, the header's bullets on amounts forgone and revaluing and on the carrier, its Readings paragraph on the off-switch game and the docstring of outcome_least, its statements unchanged, rebuilt at 138 theorems in 186 declarations with every axiom report empty) and against the cited works as your cold read and the reviews read them:
1. that each gap was taken as that table says, in every place it names, and that each change is right: no new error, and no claim wider or narrower than the Lean;
2. as text new since your third re-check: the record's law on courses alike and its correspondence, English and Chinese, in kit/round2c/make_records_rfm3.py; 03 §12's sentence on courses alike; the module header's two bullets, its Readings paragraph and outcome_least's docstring; in RF's PLAN, §8's row on reward tampering and current-reward-function evaluation, §4.8's item 19 and §13's paragraph "The cold read of the third part's texts"; the study template's bullet on the carrier and its paragraph "The cold read of the texts"; the lead of the dossier's entry on how it was made; the cold-read page's opening and its two new sections with their tables; and the Lean review page's row R2.

Report a one-line verdict, then only what is not taken correctly or is new, each with location, the quoted text, the problem and an exact replacement (English, and Chinese where the text is Chinese); a replacement for a record field must fit its cap in tools/research/style.py (ITEM_CAPS_V2: 420 characters in English and 190 in Chinese per law item; correspondence 1200 and 500; next_delta 400 and 180). Say plainly if there is nothing. Do not edit any file.
```

Beside it, the final check (a workflow of one Opus reader, read-only, in the same rehearsal; its gaps given to one refuter, whose first run failed on its connection and which was run again, the reader's result replayed). The context given to the reader and the refuter, in place of `<context>` below:

```text
The checkout is <a rehearsal of main with RF-M.3 integrated>: the theory repository's main merged with RF-M.3's kit (commit bd5277f14), the kit's integration applied, nothing committed. Do not edit, create or delete any file, commit, render, run make or build Lean; reading files and read-only shell commands (cat, sed -n, grep, git diff, git show) are fine. Paths below are relative to the checkout.

Where things are:
- The Lean, the authority for what is proved: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ListingValuation.lean (its statements unchanged in this round; docstrings revised: the header's bullets on amounts forgone and revaluing and on the carrier, its Readings paragraph on the off-switch game, and outcome_least's docstring).
- _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-COLDREAD.md: the cold read of RF-M.3's texts and its re-checks. Its last section, "The check of the check's changes", gives the 11 gaps of the last check (FT1 to FT4 from a reader of how the previous points were taken, FC1 to FC7 from a cold reader), each with its refuter's verdict, and the table "What was taken from the check of the check's changes" says what was done for each.
- rfm3-final-delta.diff at the checkout's root: the diff of the study folder for this round (the kit's templates and scripts, the plan, the module, the Lean review's page; the cold-read page and the brief left out). `git diff` shows the integration against the merged head.
- The integrated texts: theories/becoming/THE-THEORY-OF-BECOMING.md (the overview), theories/becoming/chapters/03-KNOWING.md §12, 07-SIGNIFICANCE.md §7, 08-METHOD.md §8, theories/becoming/review/ALIGNMENT.md (the dossier), the package's Becoming.lean (the root module's L1 bullet) and check_becoming.py (the scope sentence), the package's README.md and README.zh.md, _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md.
- The kit's templates, written at the landing: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/study_rfm3.txt (the study's section), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py (the new record a-reading-informed-and-revalued in English and Chinese, and AMEND), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/board_rfm3.py (the board's landing text), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/repoint_rfm3.py (the re-point's reason), _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md (the Lean review's page, its rows R1 to R5).

Record fields have caps (tools/research/style.py, ITEM_CAPS_V2): a law item 420 characters in English and 190 in Chinese; correspondence 1200 and 500; next_delta 400 and 180. A replacement for a record field must fit its cap.
```

The reader:

```text
You check, read-only, how RF-M.3's texts took its last check (11 gaps, 9 distinct points: FT1 to FT4 and FC1 to FC7), and you read the passages that round changed cold.

<context>

First, for each gap: read it, its refuter's verdict and its row in the table "What was taken from the check of the check's changes"; then check, in every place it names and wherever else the same claim recurs across these texts, that it was taken as the row says, and that the change is right against the Lean: no new error, no claim wider or narrower than the Lean proves, consistent across places, and within the record caps. Where a refuter judged part of a gap not real and that part was left unchanged, say whether leaving it is right.

Then read the passages this round changed as text in their place (rfm3-final-delta.diff shows them in the kit's files; the integrated texts show 03 §12 and the dossier's lead in place): is each exact against the Lean (whose listing a condition is on, the holding formation's model or the reading formation's; whether the reading formation's model is the holding formation's; what is a reading and what is proved), does it read well and agree with the sentences around it and with the other places that summarize the same claim? The cold-read page's opening and its sections "The third re-check" and "The check of the check's changes" are new text too.

Report every gap id with its status (taken, in_part, not_taken, or problem: taken but the change introduced an error); for each not fully right, and for each new problem (id "new", status "new"), the location, the quoted text, the problem and an exact replacement (English, and Chinese where the text is Chinese). Quote the Lean statement where a claim's scope is at issue. Do not report style preferences that do not change what a sentence says. Say plainly in the summary if there is nothing.
```

The refuter of the reader's gaps:

```text
A reader of how RF-M.3's texts took their last check, who also read the changed passages cold, reported the gaps below. Try to refute each one. Is it real: does the text as it stands say what the reader claims, and does the Lean (quote the statement) make it wrong, or the claim wider or narrower than proved, or does it disagree with the other places that state the same claim? Was it decided otherwise for a stated reason in the cold-read page's tables? If real, is the replacement right, within its cap, and consistent with the other places? Correct it where it is not. Default to real=false where the reader's case does not hold on the files.

<context>

The gaps (JSON):
<the gaps, each with its id, status, location, quoted text, problem and replacement>
```
