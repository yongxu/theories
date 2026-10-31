export const meta = {
  name: 'deep-unification-review',
  description: 'Deep review of the Theory of Becoming unification gaps and premises, each proposal attacked by a skeptic',
  phases: [
    { title: 'Review', detail: 'one deep reviewer per gap: evolution, continuation condition, C, amounts/World, architecture' },
    { title: 'Attack', detail: 'one skeptic per reviewer tries to refute each proposal' },
  ],
}

const SCRATCH = '/private/tmp/claude-501/-Users-ren-theories/d722a7b1-e282-4005-8cc2-c349389551f5/scratchpad'
const DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development'
const LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming'

const COMMON = `
You are one of five deep reviewers of the Theory of Becoming in the repository /Users/ren/theories (main at 70fcebea2). Work strictly READ-ONLY in the repository: do not edit, create, move or delete any file there, do not run git commands that write, do not run make, research.py, check_becoming.py or any Lean build of the package (another session is landing a core run now). If you want a quick standalone Lean sanity check, you may write a self-contained file importing nothing but Init into ${SCRATCH}/<your-gap>/ and run \`lean\` on it there; keep it cheap and say so in your output.

Context (the project owner's request today, 31 October 2026, verbatim): "deeper unification please. THE FOLLOWING PARTS HAVE TO BE RESOLVED AND UNIFIED: ... Only 45 of the 127 rows reach [the root]. Evolution: none of its 18 central rows reaches the root. Ethics (significance): none of its 5 rows is derived from the root. Two are restated in the grammar's terms and three in a narrower form. Amounts: balance is represented on the root, not derived. U1 tried to derive it and failed, so amounts became a second sort with a 7-law interface. Processes and the World: both are represented in the grammar both ways. For the World this covers its relations, not its amounts. The ethics still rests on two unproven premises ... unproven premises should not exist. so do a deeper round of review first, figure out how the unification can be achieved, and if there are things needs to be rewrite or throw away."

The owner's words are provenance, not authority: argue from the work. Where a demand cannot be met honestly (for instance where a statement is provably independent of the root), say so plainly and say what the strongest honest replacement is. Never propose to "meet" a demand by hiding weight in a definition, by redefining a word so a premise becomes true by construction, by counting a near-definitional restatement as a derivation, or by rerouting a proof only to raise a count; the repository's own rules forbid this and the review must catch it. A proof of independence (a model of the root where a statement holds and one where it fails) is itself a theorem and is a legitimate way to remove an "unproven premise": it turns it into a proved-independent hypothesis or shows the root must change.

Start points (read what you need, cite file:line for every factual claim):
- theories/becoming/ONE-PAGE.md, theories/becoming/THE-THEORY-OF-BECOMING.md
- theories/becoming/chapters/01-ROOT.md (the grammar, §7 master laws, §8 representations), 02-MAP.md, 04-LIFE.md, 05-COLLECTIVES.md, 07-SIGNIFICANCE.md (§2 order with no premise, §3 condition, §4 scope and order, §4.5 condition on the root, §4.6 path, P2, P4), 08-METHOD.md (§7 master laws and connectivity, premise card, open items)
- theories/becoming/results/completion/COVERAGE.json (rows, master_laws, premises), RESULTS.md, theories/becoming/results/records/
- Lean: ${LEAN}/ (361 modules; Grammar.lean, GrammarLaws.lean, GrammarMap.lean, RootForms.lean, Flow.lean, Units.lean, Significance.lean, SignificanceStatements.lean, Evolution.lean, Selection*.lean, Transmission.lean, Drift.lean, Reproduction.lean, Weighted.lean, ComparingCourses.lean, ModelStatements.lean, ProcessRepresentation.lean, Standpoints.lean, Centers.lean, Metaethics.lean)
- Studies in ${DEV}/: ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md (the unification ledger), fu-full-unification/PROPOSAL.md, u1-balance-under-units/DESIGN.md + reviews, u2-rows-on-the-root, u3-significance-on-the-root/DESIGN.md + reviews, u4-one-root-to-its-edge/DESIGN.md + DESIGN-BOUNDARY.md, el-evolution-on-the-root/NOTE.md + REVIEW-1.md, world-representation/DESIGN.md, process-representation/, ec6-no-master-law/AUDIT.md, gw-generation-and-widening, sw-significance-without-a-value-layer/NOTE.md, lw-the-way-for-life/, iv1-invariance, iv2-de-se-grades, oc-own-class, pf-path-and-crux/PHILOSOPHY-ROUND-*.md, xr-exchange-root/PLAN.md
- Use \`make research-find QUERY=...\`? NO (it may write). Use grep/rg instead.

Be concrete and deep: read the actual Lean definitions and statements, not only prose. Distinguish (a) derivable from the grammar now, (b) derivable after a stated change to the root, (c) representable but not derivable, with the reason, (d) provably independent, with the witness models, (e) should be rewritten, (f) should be thrown away (redundant, near-definitional, misleading, or a law of a model that adds nothing). For each proposal give the Lean targets (statement sketches in Lean syntax) and what it would cost. Keep the output dense; no filler.
`

const REVIEW_SCHEMA = {
  type: 'object',
  properties: {
    gap: { type: 'string' },
    verified_state: { type: 'array', items: { type: 'string' }, description: 'facts about the current state, each with file:line' },
    root_cause: { type: 'string', description: 'why the gap exists, structurally' },
    proposals: { type: 'array', items: { type: 'object', properties: {
      name: { type: 'string' },
      kind: { type: 'string', enum: ['derive-now', 'derive-after-root-change', 'represent-only', 'prove-independent', 'rewrite', 'discard', 'reframe'] },
      description: { type: 'string' },
      lean_targets: { type: 'string', description: 'Lean statement sketches' },
      achieves: { type: 'string', description: 'exactly what would be true afterwards, no more' },
      cost: { type: 'string' },
      risks: { type: 'string', description: 'including any way this could hide weight in a definition or be near-definitional' },
      confidence: { type: 'string', enum: ['high', 'medium', 'low'] },
    }, required: ['name', 'kind', 'description', 'achieves', 'cost', 'risks', 'confidence'] } },
    rewrite: { type: 'array', items: { type: 'string' }, description: 'what existing text/Lean must be rewritten, with paths and why' },
    discard: { type: 'array', items: { type: 'string' }, description: 'what should be thrown away or moved to history, with paths and why' },
    honest_limits: { type: 'string', description: 'what cannot be achieved and why, with the strongest honest replacement' },
    recommendation: { type: 'string' },
  },
  required: ['gap', 'verified_state', 'root_cause', 'proposals', 'rewrite', 'discard', 'honest_limits', 'recommendation'],
}

const ATTACK_SCHEMA = {
  type: 'object',
  properties: {
    gap: { type: 'string' },
    verdicts: { type: 'array', items: { type: 'object', properties: {
      proposal: { type: 'string' },
      survives: { type: 'boolean' },
      attack: { type: 'string', description: 'the strongest objection, with file:line evidence' },
      repair: { type: 'string', description: 'how the proposal could be fixed, or empty' },
    }, required: ['proposal', 'survives', 'attack', 'repair'] } },
    factual_errors: { type: 'array', items: { type: 'string' }, description: 'claims in the review that are wrong about the repository, with evidence' },
    missed: { type: 'array', items: { type: 'string' }, description: 'routes, results or problems the reviewer missed' },
    rewrite_discard_check: { type: 'string', description: 'which rewrite/discard recommendations are sound and which would lose a real result, counterexample or failed candidate' },
    overall: { type: 'string' },
  },
  required: ['gap', 'verdicts', 'factual_errors', 'missed', 'rewrite_discard_check', 'overall'],
}

const GAPS = [
  { key: 'evolution', prompt: `Your gap: EVOLUTION. None of the 18 central evolution rows (COVERAGE.json; 04-LIFE.md; 08 §7) reaches the root. Find each of the 18 rows, the Lean declaration, what it rests on (counting identities like Price, selection terms over shares, transmission, drift, fixation, group ending, levels) and why it does not reach the grammar. Read EL (el-evolution-on-the-root/NOTE.md, REVIEW-1.md, WS.md, scratch/) and judge whether EL's route (lineages read on the map: descent as the relation, organisms fine class, kind coarse class; «传», «生成», «退化») actually brings the 18 rows onto the root or only adds readings beside them. Determine for each row: derivable from the grammar (with which grammar law), needs amounts (then it depends on the amounts gap), is a counting identity (Price: say honestly whether "reaching the root" even means anything for an identity that cannot fail), or should be discarded/merged. Propose the minimal set of new grammar-level laws (e.g. a law of differential continuation under a class) from which the most rows follow, with Lean sketches.` },
  { key: 'continuation-condition', prompt: `Your gap: THE CONTINUATION CONDITION (Unrestricted sig: for anything, its continuation has significance), the scope premise of the ethics, and the three significance rows specialized at the de se reading plus two restated rows. Read 07 §3, §4.1–§4.6, §9, the open items; Significance.lean, SignificanceStatements.lean, Standpoints.lean, Centers.lean, Metaethics.lean; u3-significance-on-the-root, iv1/iv2, oc-own-class, pf-path-and-crux (P2, P4, the crux), sw-significance-without-a-value-layer, lw-the-way-for-life. The one page says: read de se along a relation, the condition holds on the root exactly where nothing lies outside every center's line under the full class of that relation, and along a net with no cycle it holds only with one center; and supplied as a free predicate, significance is fixed by no statement about the dynamics, by construction. Decide rigorously which of these is the case for the condition: (1) a theorem of the root under some reading of significance that is NOT a disguised definition; (2) equivalent on the root to a relational statement about the unfolding (connectivity of centers' lines), which is then provable, refutable, or empirical, and for which actual systems; (3) independent of the root, with witnesses both ways, already in Lean or to be written; (4) incoherent or idle as stated. Then answer the owner's demand "unproven premises should not exist" for this premise: what is the strongest honest end-state (e.g. replace the free premise by the proved equivalence with a connectivity statement, prove that connectivity where it holds, prove independence where it does not, and restate the ethics' scope as a theorem relative to that relation), and what must be rewritten or thrown away (e.g. the free-predicate form, the step of invariance, P2/P4) to reach it.` },
  { key: 'order-C', prompt: `Your gap: C, "widening what can form is better", the only premise that ranks courses (07 §2 the order with no premise, §4.4 "C: what every weighting that counts everything shares", §6, §7, §9; GW (gw-generation-and-widening), ComparingCourses.lean, KeepingWidening.lean, EventualWidening.lean, OwnWidening.lean, Weighted.lean, Ranking.lean, Metaethics.lean, HeldPossible.lean). With no premise the widening order exists and leaves mixed cases unranked. Determine rigorously: Can "better" be given a non-arbitrary meaning on the root such that C becomes a theorem without hiding weight (e.g. "better for X" := "X's continuation is widened", then C restricted to non-mixed cases is a theorem; or "every weighting that counts everything strictly positively ranks widening higher" which is already a theorem: say exactly which). Is C, as a ranking of mixed cases, provably independent of the root (two weightings both counting everything that disagree on a mixed case)? Is the gap between the premise-free widening order and C actually only the word "better", i.e. does C add nothing beyond monotonicity of every everything-counting weighting? Answer the owner's demand "unproven premises should not exist" honestly for C: what is the strongest end-state (e.g. C dissolved into a proved theorem about all weightings plus a proved independence result for mixed cases, with the ethics restated as those theorems), and what text/Lean must be rewritten or thrown away.` },
  { key: 'amounts-and-world', prompt: `Your gap: AMOUNTS. Balance is represented on the root, not derived; U1 (u1-balance-under-units/DESIGN.md, REVIEW-U1.md, REVIEW-U1-2.md, scratch/) tried to derive balance from units given and taken along the World's exchanges and failed (Flow.balances_iff_units: "the matching is supplied, built from the numbers, not derived from the unfolding"; pairing at one relatum is just equal counts, Hume's principle), so amounts became a second sort with a 7-law interface. The World (world-representation/DESIGN.md, 01 §8) is represented both ways in its relations, not its amounts; processes (process-representation) both ways. 32 central declarations rest on "balance, represented", 9 on support/dissipation premises, 3 on Price. Read Flow.lean, Units.lean, Amounts.lean, InAmounts.lean, LocalUnits.lean, LossMatching.lean, Dissipation.lean, LeastLoss.lean, ExchangePremises.lean, PlaceTransitionNets.lean, the World modules, xr-exchange-root/PLAN.md, lc2-world-amounts. Think from first principles: on a root whose only primitive is a condition relation and classes, what is an amount? Candidates: (a) amounts as counts of occurrences in a class at a cut (then balance = a bijection/conservation law of continuation: every occurrence that ends at a step is matched by the occurrences it is a condition of; this would make balance a theorem of a stated relational property such as "continuation is a partial bijection between cuts", i.e. a relational premise, which is then itself provable for specific models or independent); (b) amounts as a second sort (status quo); (c) dropping amounts from the root claim altogether and stating the amount laws as laws of the represented models, honestly. Determine which, if any, would make the 32+9+3 rows derived rather than represented, whether any is near-definitional (Hume's principle risk), whether the World's amounts can then be represented both ways, and what should be rewritten or discarded. Give Lean sketches for the key bridge.` },
  { key: 'architecture', prompt: `Your gap: THE ARCHITECTURE OF THE UNIFICATION AS A WHOLE. The account has a one-relation grammar (01-ROOT), five master laws stated on it (GrammarLaws.lean), many models (World, processes, webs, flows, weightings) with representation theorems, 361 Lean modules, ~508 registered results, 127 central rows of which 45 reach the grammar, and a measure (master_laws.py, measure_grammar.py, COVERAGE.json, 08 §7, U4's RootForms and boundary design) with categories (master law, balance represented, definitional, premise of the account, law of its model, single application, counting identity). Review the whole: (1) Is "rows reaching the grammar" the right target for unification, or does it reward rerouting? Propose a better criterion if there is one (e.g. every model is a model of the root's theory and each central law is a theorem of the root's theory under a named, model-checked relational property). (2) Is the root too weak to carry amounts, evolution and evaluation, so that a minimal, principled extension of the root (not a second sort bolted on) would unify more honestly? Or is the right answer that the root is a hub and the models are its models, and the unification claim should be restated? (3) What in the 361 modules / 508 results / 400+ study sections is redundant, near-definitional, superseded, or a law of a model that adds nothing, and should be merged, rewritten or moved to history? Give a concrete list with paths and reasons, but never propose losing a real result, counterexample or failed candidate. (4) What should the end-state of "one unified theory" look like concretely (layers, what is a theorem of what), and what is the order of work to get there. Read 08-METHOD.md fully, WHAT-REMAINS.md, fu-full-unification/PROPOSAL.md, u4-one-root-to-its-edge/DESIGN*.md, ec6-no-master-law/AUDIT.md, ou3f-activity-laws, and sample the Lean.` },
]

phase('Review')
const results = await pipeline(
  GAPS,
  g => agent(COMMON + '\n' + g.prompt + `\n\nReturn your findings in the schema. gap = "${g.key}".`, { label: `review:${g.key}`, phase: 'Review', schema: REVIEW_SCHEMA, effort: 'high' }),
  (review, g) => review ? agent(COMMON + `
You are now the SKEPTIC for the gap "${g.key}". Another reviewer produced the review below. Your job is to try to REFUTE each proposal and each rewrite/discard recommendation, by reading the repository yourself (do not trust the reviewer's citations; check them). Attack especially: (a) proposals that would make a premise true by definition or hide weight in a definition; (b) "derivations" that are near-definitional (Hume's principle, Iff.rfl restatements, rerouting for count); (c) independence claims without real witness models; (d) discard recommendations that would lose a real result, counterexample, failed candidate or calibration; (e) factual errors about what the Lean actually states; (f) routes the reviewer missed, including existing results in the repository that already settle the question. Default to survives=false when a proposal's central claim is unverified.

THE REVIEW:
${JSON.stringify(review, null, 1)}

Return the schema with gap = "${g.key}".`, { label: `attack:${g.key}`, phase: 'Attack', schema: ATTACK_SCHEMA, effort: 'high' }).then(a => ({ review, attack: a })) : null,
)
return results
