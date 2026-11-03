export const meta = {
  name: 'known-results-debts',
  description: 'For each row of 08 §8 known-results table, draft what the closest prior framework states that the account cannot yet (its debt), then have a skeptic check each draft against the repository',
  phases: [{ title: 'Draft', detail: 'four readers, three rows each' }, { title: 'Check', detail: 'one skeptic per reader' }],
}
const REPO = '/Users/ren/theories'
const ROWS = [
  ['Coming and ceasing keep pace (01-ROOT.md#r-coming-and-ceasing-keep-pace) | demographic balancing equation; trace theory (Mazurkiewicz 1977) | near-definitional',
   'Recurrence (01-ROOT.md#r-recurrence-without-premise) and attraction (02-MAP.md#r-attraction-is-not-returning) | finite Poincaré recurrence; Landauer (1961); Bennett (1973) | restated, without decidable equality',
   'Premises carve parts (01-ROOT.md#r-map-of-premises) | independence by countermodels; constructive reverse mathematics | new as an artefact'],
  ['Rest needs a least loss (02-MAP.md#r-least-loss-rest) | ranking functions (Floyd 1967); Lyapunov; LaSalle; chip-firing | restated',
   'How two courses differ in what can form (07-SIGNIFICANCE.md#r-four-cases-of-a-part) | opportunity sets (Pattanaik and Xu 1990) | near-definitional',
   'Closures (01-ROOT.md#r-levels-of-closure) and selection (03-KNOWING.md#r-selection-through-couplings) | Blackwell (1953); Pearl (2000); the proxy problem (Zhuang and Hadfield-Menell 2020) | restated'],
  ['Joint excess (05-COLLECTIVES.md#r-own-count-misses-joint-excess), position (05-COLLECTIVES.md#r-relative-position-is-zero-sum) | tragedy of the commons; positional goods (Hirsch 1976) | near-definitional',
   'Learning and identification (03-KNOWING.md#r-identification-where-bounded) | Hume; Fine and Wilf (1965); Moore (1956); Gold (1967) | restated constructively',
   'Significance not in the dynamics (07-SIGNIFICANCE.md#r-what-the-dynamics-leave-open) | is–ought; Gewirth (1978); Parfit (1984); Sen (1977) | near-definitional; scope apart from order a clarification'],
  ['Loops (02-MAP.md#r-how-loops-form) | nilpotent adjacency; Perron–Frobenius; Maruyama (1963) | restated over whole amounts',
   'Fed from beyond (02-MAP.md#r-continuing-self-fed-from-beyond), entropy (02-MAP.md#r-least-loss-from-entropy-production), nets (01-ROOT.md#r-place-transition-nets-on-the-spine) | Schrödinger (1944); Prigogine (1977); ranking functions; P-invariants of Petri nets (Lautenbach 1975) | restated',
   'Evolution on descent, offspring bounds, Hamilton\'s rule, groups on coupled conditions (04-LIFE.md) | Price; Fisher; Hamilton; multilevel selection; Malthus | restated in counts; joined to the flow. AND: Drift, fixation, mutation (04-LIFE.md) | Wright–Fisher; Moran; Kimura; Haldane; Eigen | restated as finite weighted bounds'],
]
const DRAFT = { type: 'object', properties: { rows: { type: 'array', items: { type: 'object', properties: {
  row: { type: 'string' },
  debts: { type: 'array', items: { type: 'object', properties: {
    framework_states: { type: 'string', description: 'one exact sentence: a result or capacity the prior framework has' },
    account_status: { type: 'string', description: 'what the account has instead, with repo file:line or Lean name; or none found after searching' },
    source_depth: { type: 'string', description: 'how you know the framework states it: prior knowledge, a reference read in the repo, etc.' },
  }, required: ['framework_states', 'account_status', 'source_depth'] } },
  cell: { type: 'string', description: 'a proposed debt cell for the table, at most about 40 words, naming the two or three most consequential debts' },
}, required: ['row', 'debts', 'cell'] } } }, required: ['rows'] }
const VERDICT = { type: 'object', properties: { rows: { type: 'array', items: { type: 'object', properties: {
  row: { type: 'string' },
  checks: { type: 'array', items: { type: 'object', properties: { debt: { type: 'string' }, verdict: { type: 'string', enum: ['stands', 'already-in-account', 'misstated', 'unsupported'] }, evidence: { type: 'string' } }, required: ['debt', 'verdict', 'evidence'] } },
  revised_cell: { type: 'string' },
}, required: ['row', 'checks', 'revised_cell'] } } }, required: ['rows'] }
const COMMON = `Repository ${REPO} (a theory of how things form, persist, change and end, with a Lean package Becoming). Read-only: no edits, no builds, no tests. Chapter 08 §8 (theories/becoming/chapters/08-METHOD.md, section "## 8. Known results") has a table of the account's central results, the closest prior result, and a verdict (near-definitional, restated...). The integration scan (_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ig-integration-gaps/GAP-MAP.md, item 8.2 and the general cause 1) found the table records what the account owes a framework but not what the framework holds that the account lacks: its debts. The model for a debt list is the free-energy containment (theories/becoming/FREE-ENERGY-PRINCIPLE.md and _process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue1-fep-bridge/NOTE.md §3: surprisal, belief, continuous time).`
phase('Draft')
const results = await pipeline(ROWS,
  (rows, _, i) => agent(`${COMMON}

For each of these three rows, read the account's home section (the anchor given, under theories/becoming/chapters/) and its result records (theories/becoming/results/records/, found by the record link in the home), then list what the named prior frameworks state that the account cannot yet: stronger theorems, quantitative results, continuous or stochastic forms, scope the account lacks. Search the repository (chapters, records, Lean names via grep in experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/) before saying the account lacks something; if the account has it, say where. Mark how you know each framework result (prior knowledge vs a source read). Be exact and do not inflate: two or three consequential debts per row beat a long list.

Rows:
${rows.map((r, k) => `${k + 1}. ${r}`).join('\n')}`, { label: `draft:${i + 1}`, phase: 'Draft', schema: DRAFT }),
  (draft, rows, i) => agent(`${COMMON}

A reader drafted debts for three rows of the table. Try to refute each debt: is it already in the account (search chapters, records and the Lean under experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ for the result, its standard name and close variants), is it misstated (does the framework really state it, as stated), or is it unsupported? Default to a refutation only with evidence. Then give a revised table cell per row, at most about 40 words, keeping only debts that stand, with the depth of knowledge marked where it is prior knowledge.

Draft:
${JSON.stringify(draft, null, 1)}`, { label: `check:${i + 1}`, phase: 'Check', schema: VERDICT }).then(v => ({ draft, verdict: v })),
)
return results
