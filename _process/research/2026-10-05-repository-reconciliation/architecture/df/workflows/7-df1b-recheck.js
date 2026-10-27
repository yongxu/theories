export const meta = {
  name: 'df1b-recheck',
  description: 'Re-check DF1b after its second round of fixes: each new sentence against Lean and sources, and a cold read of the whole diff',
  phases: [{ title: 'Recheck' }],
}
const W = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/wt-df'
const KIT = '_process/research/2026-10-05-repository-reconciliation/architecture/df'
const CONTEXT = `You are re-checking board item DF1b in the theory repository, git worktree ${W} (branch df1b, based on main 04c7f93ae). Work read-only: do not edit, stage or commit; report findings only. Use absolute paths or cd into ${W} within each command.

DF1b corrects ten weak points UE8's drafting found (last two sections of _process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md say what was done). Round 1 is ${KIT}/df1b_edits.py; a first review returned 45 findings (${KIT}/reports/review-df1b.json, each with its disposition), and round 2, ${KIT}/df1b_edits2.py, applied them, including renaming the hypothesis \`landauer\` to \`floor\` in experiments/integrated-correction/general-framework/generative-basis/lean/physics/EntropyProduction.lean (the periphery checker passed again, receipt 20261025T223932.505689Z, entropy-production-verification.json). All changes: git -C ${W} diff main (generated pages such as README.md, RESULTS.md and record .md pages are not yet rendered; ignore their staleness). The DF_N placeholder in history notes is filled at landing; ignore it. Sources: study §314 (MQ6) in _process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md, experiments/margin-measured/README.md and PREDICTIONS-2026-10-21-MQ6.md, the Lean under experiments/integrated-correction/general-framework/generative-basis/lean/ (becoming/Becoming/Drift.lean, Closing.lean, RegimeMargin.lean, Ranking.lean; physics/EntropyProduction.lean), experiments/valuation-development/lean/ValuationBridges.lean. Lint: cd ${W} && python3 -B tools/research/research.py lint --ids <ids> (statement 300 EN / 150 ZH, laws 420/190, next_delta 400/180 are errors). Claims must say exactly what the Lean proves; Chinese must say what the English says; the spine's first law is Flow.Gainless (第一律 in Chinese), thermodynamics' first law is named in full (热力学第一定律). Default to reporting when unsure, with evidence and an exact fix.`

const FINDING = {
  type: 'object',
  properties: {
    findings: { type: 'array', items: { type: 'object', properties: {
      file: { type: 'string' }, where: { type: 'string' },
      severity: { type: 'string', enum: ['error', 'overclaim', 'imprecise', 'missed-instance', 'style'] },
      problem: { type: 'string' }, evidence: { type: 'string' }, fix: { type: 'string' },
    }, required: ['file', 'where', 'severity', 'problem', 'evidence', 'fix'] } },
    checked: { type: 'string' },
  },
  required: ['findings', 'checked'],
}

phase('Recheck')
const [verify, cold] = await parallel([
  () => agent(`${CONTEXT}

Your task: try to refute every round-2 change. Read ${KIT}/df1b_edits2.py and check each replacement it makes against the Lean or source it rests on: the MQ6 verdict counts and wording in 02's T1 and T2 evidence and 08's T1 and T2 rows (which verdicts are level forecasts, which are timing, which passed; was the constant group ever past its fold; did the deteriorating runs measure any of T2's forbidden items); the fixation-by-drift and fixation-with-selection statements and laws against Drift.fixation, Drift.varied_vanishes, Drift.Replacement.fixation and Drift.Replacement.varied_vanishes (check the algebra of "(1 − (a/(a + b))^(M + 1))^m" and "((N^N − 2)/N^N)^k", and whether "for positive a" is the right condition); how-loops-form and 02 §7 against Closing.Onset.unforeseen and carried_le_polynomial_before; RegimeMargin.Notch.no_threshold and Crossing.crosses as cited in 02; Ranking.Immediate.stepwise_ranks_absence as cited in two records; the valuation-development lock-in bound; the glossary and 02 wording on EntropyProduction.gainless_of_secondLaw; the Landauer sentences and Bennett 2003 (Stud. Hist. Phil. Mod. Phys. 34:501-510) and Steel 2000 (Applied Mathematics Letters 13:91-95) as credited; EntropyProduction.lean's renamed hypothesis (does anything refer to it by name?) and its comments; the OPENING footnote edits (only AI-written footnotes may change; the body is in Ren's voice). Check EN/ZH agreement and lint for every record df1b_edits2.py touches.`, { label: 'verify-round-2', phase: 'Recheck', schema: FINDING }),
  () => agent(`${CONTEXT}

Your task: a cold read of the whole DF1b change (git diff main, excluding the physics receipt JSON and the run folder) as a reader of the account would meet it. For every changed sentence ask: is it true to its source, is it clear and grammatical, does it say the same in both editions, does it fit the sentence and paragraph around it (parentheses balanced, no dangling clause, no repeated words), does it keep the account's terms in the glossary's one sense, and does any changed passage now contradict an unchanged passage elsewhere in the live account (theories/becoming/ chapters, overview, ONE-PAGE, OPENING footnotes, GLOSSARY.md, records, experiments/*/README.md; frozen history/ and PREDICTIONS files excepted). Also check that DEFECTS-FOUND's two last sections describe accurately what the diff does. Report only real problems, with exact fixes.`, { label: 'cold-read', phase: 'Recheck', schema: FINDING }),
])
return { verify, cold }
