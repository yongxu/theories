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
