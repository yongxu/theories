export const meta = {
  name: 'kd-column-read',
  description: 'Three independent readers check the final debts column of 08 §8 against the repository and the literature they know',
  phases: [{ title: 'Read', detail: 'three readers, a third of the rows each, plus the paragraph' }],
}
const W = '/Users/ren/tmp/prefreeze-fix/wt-kd'
const FIND = { type: 'object', properties: { findings: { type: 'array', items: { type: 'object', properties: {
  row: { type: 'string' }, claim: { type: 'string', description: 'the exact words of the cell at issue' },
  problem: { type: 'string', enum: ['already-in-account', 'misstated-framework', 'misstated-account', 'unsupported', 'link-or-name-wrong', 'unclear'] },
  evidence: { type: 'string', description: 'file:line or Lean name, or the literature fact' }, fix: { type: 'string' } },
  required: ['row', 'claim', 'problem', 'evidence', 'fix'] } }, rows_read: { type: 'array', items: { type: 'string' } } },
  required: ['findings', 'rows_read'] }
const COMMON = `Worktree ${W} (read-only: no edits, builds or tests). In theories/becoming/chapters/08-METHOD.md, section "## 8. Known results", the table has a new fourth column, "What it states that the account does not yet": for each row, results of the closest prior frameworks the account does not yet state. The paragraph above the table says how it was made. Its evidence is in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/kd-known-results-debts/DEBTS.md. You are an independent reader who did not write it. For each cell in your rows: (1) is each item really absent from the account? Search chapters (theories/becoming/chapters/), records (theories/becoming/results/records/) and the Lean (experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/) for the result, its standard name and close variants; (2) is the framework result stated correctly, with a correct attribution and year as far as you know; (3) is what the cell says the account has instead correct; (4) do links and Lean names resolve (anchors exist in the target file, records exist, the Lean names exist)? Report only real problems with evidence; no style comments. A debt that over-claims what the account lacks misleads a reader as much as one that under-claims.`
const PARTS = [
  'rows 1 to 4 (Coming and ceasing keep pace; Recurrence and attraction; Premises carve parts; Rest needs a least loss), and also the paragraph sentence beginning "The last column lists"',
  'rows 5 to 9 (How two courses differ; Closures and selection; Joint excess and position; Learning and identification; Significance not in the dynamics)',
  'rows 10 to 13 (Loops; Fed from beyond, entropy, nets; Evolution on descent and the rest; Drift, fixation, mutation)',
]
phase('Read')
const res = await parallel(PARTS.map((p, i) => () => agent(`${COMMON}\n\nYour rows: ${p}.`, { label: `read:${i + 1}`, phase: 'Read', schema: FIND })))
return res