export const meta = {
  name: 'integration-gap-scan',
  description: 'Scan the Theory of Becoming for frameworks cited but not contained, fields missing, and own results not unified; verify each finding; synthesize a gap map',
  phases: [
    { title: 'Find', detail: '9 readers, each a slice or a sweep' },
    { title: 'Verify', detail: 'one skeptic per finder, refuting against the whole repository' },
    { title: 'Synthesize', detail: 'one gap map, ordered by what moves the work' },
    { title: 'Critic', detail: 'what the scan missed' },
  ],
}

const ROOT = '/Users/ren/theories'
const COMMON = `
You are reading the repository at ${ROOT} (the Theory of Becoming: one relational account of how things form, persist, change and end, with a Lean core). READ ONLY. Use cat/sed/grep/git grep/ls. Do NOT run builds, lake, tools/research/research.py (render/check/links), tests or any heavy Python: another job is using the CPU. Do not edit, commit or write any file.

Background you need:
- The account's chapters are theories/becoming/chapters/01-ROOT.md … 08-METHOD.md; fronts are theories/becoming/ONE-PAGE.md, THE-THEORY-OF-BECOMING.md, ONE-ARGUMENT.md, OPENING (find it), README.md, GLOSSARY.md. Records (results) are in theories/becoming/results/records/*.md. Studies are under _process/research/2026-10-05-generative-foundation-review/root-foundation/development/.
- 08-METHOD.md §8 "Known results" (around line 478) lists central results with their closest prior results and verdicts ("restated", "near-definitional"), then "Known results beyond the table", then "Third parts". A CONTAINMENT (the UE programme, development/ue-unified-explanation/PLAN.md, and the third-parts audit development/ue0-third-parts/AUDIT.md) means an established framework is stated as a case of the account's laws under named premises, AND the account forbids something the framework leaves open (its "third part"). The free-energy principle was contained this way (UE16–UE25).
- THE PATTERN WE ARE HUNTING, by example: Zhuang and Hadfield-Menell (2020) "Consequences of Misaligned AI" is cited in four places as a known result the account "restates more weakly". Their stronger quantitative result and their remedy (updating the proxy over time) are not brought in, and the account's own analogues of that remedy (reading in time, pooled coupling, widening C) are never connected to them. So a framework that should be PART of the one picture sits outside it as a citation. (That case is already being handled by another session: do NOT report it again.)

Report findings of four kinds:
- "cited-not-contained": an external framework or result is cited/restated, but its stronger results, its remedies or dynamics, or its mapping onto the account's other parts are absent; it reads as outside the picture.
- "missing-field": an established framework that bears directly on a claim the account makes, but is not mentioned at all (check with git grep across the repo, excluding sources/ and history/, before reporting).
- "internal-split": two or more of the account's own results, laws, notions or names state the same thing, or one is a case of the other, but are not joined (no link, different names, separate sections, no stated relation), so the whole does not read as one.
- "unity-claimed-not-shown": text claiming unification or "one law" where the pieces are not actually joined.

For each finding give exact file paths with line numbers and short verbatim quotes as evidence. Prefer fewer, solid findings over many thin ones; at most 15. Rank priority by what moves the work: "high" if it would change what a reader believes about the account or what could fail; "medium" if it is a real hole in the one picture; "low" if cosmetic. Do not report polish.`

const FIND_SCHEMA = {
  type: 'object',
  properties: {
    findings: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          kind: { type: 'string', enum: ['cited-not-contained', 'missing-field', 'internal-split', 'unity-claimed-not-shown'] },
          title: { type: 'string' },
          external: { type: 'string', description: 'the outside framework or result, with authors and year, or empty for internal-split' },
          where: { type: 'array', items: { type: 'string' }, description: 'path:line entries' },
          evidence: { type: 'string', description: 'short verbatim quotes' },
          what_is_there: { type: 'string' },
          what_is_missing: { type: 'string' },
          why_it_matters: { type: 'string' },
          suggested_work: { type: 'string', description: 'what containment or unification would look like, concretely' },
          effort: { type: 'string', enum: ['S', 'M', 'L'] },
          priority: { type: 'string', enum: ['high', 'medium', 'low'] },
        },
        required: ['kind', 'title', 'where', 'evidence', 'what_is_there', 'what_is_missing', 'why_it_matters', 'suggested_work', 'effort', 'priority'],
      },
    },
    covered: { type: 'string', description: 'what you actually read, and what you could not' },
  },
  required: ['findings', 'covered'],
}

const VERIFY_SCHEMA = {
  type: 'object',
  properties: {
    verdicts: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          title: { type: 'string' },
          verdict: { type: 'string', enum: ['confirmed', 'partly', 'refuted'] },
          reason: { type: 'string' },
          already_at: { type: 'string', description: 'path:line where it is already integrated, if refuted or partly' },
          corrected: { type: 'string', description: 'the finding restated accurately, if partly' },
          priority: { type: 'string', enum: ['high', 'medium', 'low'] },
        },
        required: ['title', 'verdict', 'reason', 'priority'],
      },
    },
  },
  required: ['verdicts'],
}

const SLICES = [
  { key: 'root-map', prompt: `Your slice: theories/becoming/chapters/01-ROOT.md and 02-MAP.md (the root, precedence, recurrence, loops, rest and least loss, entropy, nets, causal sets, capture and shaping the rule, read in time) and their records. Check every external framework they cite (dynamical systems, Lyapunov, Petri nets, causal sets, Poincaré, Prigogine, Arthur, control) for the pattern, and check whether 01's and 02's own laws are joined to each other and to later chapters.` },
  { key: 'knowing', prompt: `Your slice: theories/becoming/chapters/03-KNOWING.md (selection through couplings, learning and identification, conditioning, free energy, Markov blankets, readings, the reading loop, value of evidence, what choices show) and its records. Check Bayes/Blackwell/Good/Gold/Pearl/FEP/active inference/learning theory citations for the pattern, and whether 03's notions (reading, lumping, closure, coupling) are joined to 02's and 05's.` },
  { key: 'life', prompt: `Your slice: theories/becoming/chapters/04-LIFE.md and the evolution-on-the-root line (development/el-evolution-on-the-root, development/ev*), Price, Fisher, Hamilton, drift, fixation, mutation, Eigen, multilevel selection, Malthus. Check for the pattern, and especially whether evolution's laws are joined to the optimum/selection laws of 03 and 05 and to the meta-attractor / joint selection (AJ) so that "selection in evolution" and "selection in training an AI" read as one law.` },
  { key: 'collectives', prompt: `Your slice: theories/becoming/chapters/05-COLLECTIVES.md (joint excess, commons, position, optima and what lies beyond, set points, pools, institutions, markets, T3) and its records. Check commons/Ostrom/Hardin/externalities/Coase/positional goods/mechanism design/game theory/satisficing citations for the pattern, and whether 05's laws are joined to 04's evolution and 07's ethics. Skip Zhuang and Hadfield-Menell.` },
  { key: 'significance', prompt: `Your slice: theories/becoming/chapters/06-CLASSICAL-TEXTS.md and 07-SIGNIFICANCE.md (the continuation condition, C, widening, opportunity sets, scope and order, the crux, corrigibility, alignment approaches, routes of 明, what a course keeps reachable, constructor theory) and their records. Check ethics/social-choice/capabilities approach (Sen, Nussbaum)/Gewirth/Parfit/Pattanaik-Xu/Chichilnisky/corrigibility/off-switch/CIRL citations for the pattern, and whether 06's classical texts are joined to the laws they are said to read, rather than sitting beside them.` },
  { key: 'method-meta', prompt: `Your slice: 08-METHOD.md whole (premise card §4, known results §8 incl. beyond-the-table and third parts, theses §9, open programme §12), development/ue0-third-parts/AUDIT.md, development/ue-unified-explanation/PLAN.md, development/ue8-sciences-dossier/SCIENCES.md and development/lk1-known-results. Go row by row through the known-results table and the beyond-the-table list: for each prior framework, is it CONTAINED (mapped, with a third part, with the framework's stronger results and remedies brought in) or only acknowledged? List the ones only acknowledged whose content clearly belongs in the one picture. Also check whether §9's theses and unifications actually join the pieces they name.` },
  { key: 'alignment', prompt: `Your slice: the AI-alignment line: theories/becoming/review/ALIGNMENT.md, theories/becoming/ONE-ARGUMENT.md, COLLECTIVE-DIRECTION.md (find it), development/aj-joint-selection/PLAN.md, development/aj4-alignment-readers/ (FAILURE-MODE-MAP.md, README, PLAN), _process/research/2026-10-05-generative-foundation-review/foundation-assessment/ALIGNMENT-LITERATURE.md, and experiments/README.md. Compare against the alignment field: reward hacking and Goodhart variants (Manheim-Garrabrant), Skalse et al. reward hacking, Gao overoptimization, Pan et al., power-seeking (Turner et al. 2021), side-effect/impact measures (Krakovna, AUP), CIRL, off-switch, debate, ELK, scalable oversight, goal misgeneralization, mesa-optimization (Hubinger), emergent misalignment, RLHF/KL regularization, cooperative AI (Dafoe et al.). Which are cited but not contained, which are missing, and where the account's own alignment laws are not joined to each other. Skip Zhuang and Hadfield-Menell.` },
  { key: 'fronts', prompt: `Your slice: the fronts a reader sees first: README.md, theories/becoming/ONE-PAGE.md, THE-THEORY-OF-BECOMING.md, ONE-ARGUMENT.md, the OPENING document (find it), GLOSSARY.md, theories/becoming/chapters/README.md and CLAIMS.md. Ask: does a reader see ONE whole? Which major parts of the chapters (whole lines of results) never appear on the fronts, so the whole looks smaller or more scattered than it is; which notions appear under different names in different places (internal-split); where the fronts claim unity that the chapters do not show; and which external frameworks the fronts say the account contains or exceeds without that being shown.` },
  { key: 'fields-sweep', prompt: `Your sweep is from the FIELDS' side, not the chapters'. Make a list of about 40 established frameworks that bear on an account of how things form, persist, change and end, of selection, of knowing, of collectives, of ethics and of AI alignment. For example: cybernetics and requisite variety, good regulator, autopoiesis (Maturana-Varela), Deacon's teleodynamics, Kauffman's adjacent possible and autocatalytic sets, niche construction, resilience and panarchy (Holling), Ostrom's commons design principles, Coase, mechanism design, social choice (Arrow, Sen), evolutionary game theory and replicator dynamics, the major transitions (Maynard Smith-Szathmáry), multilevel selection, cultural evolution (Boyd-Richerson), constructal law, maximum entropy production, information theory (Shannon), algorithmic information, assembly theory, integrated information, predictive processing, enactivism, process philosophy (Whitehead), Daoist and Buddhist dependent origination (缘起), Confucian 生生 sources, Goodhart variants, power-seeking theorems, impact measures, cooperative AI. For EACH, git grep the repository (excluding sources/ and history/) and classify: contained (mapped with a third part), cited only, or absent. Report as findings only those that are cited-only or absent AND clearly bear on a central claim; say which claim.` },
]

const results = await pipeline(
  SLICES,
  s => agent(`${COMMON}\n\n${s.prompt}`, { label: `find:${s.key}`, phase: 'Find', schema: FIND_SCHEMA }),
  (found, s) => {
    if (!found || !found.findings || !found.findings.length) return { key: s.key, found, verdicts: [] }
    const list = found.findings.map((f, i) => `${i + 1}. [${f.kind}, ${f.priority}] ${f.title}\n   where: ${(f.where || []).join('; ')}\n   external: ${f.external || '-'}\n   evidence: ${f.evidence}\n   missing: ${f.what_is_missing}`).join('\n')
    return agent(`${COMMON}\n\nYou are a SKEPTIC. Another reader reported the findings below for the slice "${s.key}". For EACH, try to REFUTE it against the WHOLE repository: search (git grep, excluding sources/ and history/) for places where the framework IS already contained or mapped, where the two internal results ARE already joined, or where the claim of unity IS shown; check the quotes and line numbers are real; check that a "missing-field" is truly absent. Verdict "refuted" if it is already integrated or the evidence is wrong; "partly" if it is real but overstated (then restate it accurately in "corrected"); "confirmed" only if it survives your search. Re-rank priority by the same rule. Default to refuted when the evidence does not hold.\n\nFindings:\n${list}`,
      { label: `verify:${s.key}`, phase: 'Verify', schema: VERIFY_SCHEMA })
      .then(v => ({ key: s.key, found, verdicts: v ? v.verdicts : [] }))
  },
)

const merged = []
for (const r of results.filter(Boolean)) {
  const fs = (r.found && r.found.findings) || []
  fs.forEach((f, i) => {
    const v = (r.verdicts || []).find(x => x.title === f.title) || (r.verdicts || [])[i]
    merged.push({ slice: r.key, ...f, verdict: v ? v.verdict : 'unverified', verify_reason: v ? v.reason : '', already_at: v ? v.already_at : '', corrected: v ? v.corrected : '', vpriority: v ? v.priority : f.priority })
  })
}
const kept = merged.filter(f => f.verdict !== 'refuted')
const dropped = merged.filter(f => f.verdict === 'refuted')
log(`${merged.length} findings, ${kept.length} kept after verification, ${dropped.length} refuted`)

phase('Synthesize')
const synth = await agent(`${COMMON}\n\nYou are writing the gap map from verified findings of nine readers. Merge duplicates across slices (the same framework or split seen from two chapters is one item). Group into themes (for example: selection as one law across evolution, training and institutions; knowing and inference; thermodynamics and persistence; collectives and institutions; ethics and social choice; alignment). Within each theme order items by what moves the work: first what would change what a reader believes, then what lets the account be wrong (a test or a refuter), then holes in the one picture. For each item: one line on what is missing, the files, the kind of work (containment with a third part, a mapping note, a new Lean law, a text revision, a link), effort S/M/L. Then: (a) the five items that would most move the work, each with a one-paragraph brief a separate session could start from; (b) the general cause, if one shows: why the work kept leaving frameworks outside (for example the known-results habit of acknowledging rather than containing). Use "corrected" wording where a verifier gave it. Be exact; quote paths with lines. Output Markdown.\n\nVerified findings (JSON):\n${JSON.stringify(kept, null, 1)}`,
  { label: 'synthesize', phase: 'Synthesize' })

phase('Critic')
const critic = await agent(`${COMMON}\n\nYou are the completeness critic of a scan for integration gaps. Below are what each reader says it covered, and the synthesized gap map. Say what the scan MISSED: chapters, records or study areas no reader read; fields the sweep did not check; kinds of gap not looked for (for example Lean modules that prove the same law twice under different names, records that should cite each other, the Chinese editions (*.zh.md) diverging from the English). Spot-check two or three of your suspicions yourself with git grep so you report evidence, not guesses. Output Markdown: a short list of gaps in coverage with evidence, and up to 8 additional findings you verified yourself.\n\nCoverage:\n${results.filter(Boolean).map(r => `- ${r.key}: ${r.found ? r.found.covered : '(reader failed)'}`).join('\n')}\n\nGap map:\n${synth}`,
  { label: 'critic', phase: 'Critic' })

return { synth, critic, kept, dropped: dropped.map(d => ({ slice: d.slice, title: d.title, reason: d.verify_reason, already_at: d.already_at })), counts: { all: merged.length, kept: kept.length, refuted: dropped.length } }
