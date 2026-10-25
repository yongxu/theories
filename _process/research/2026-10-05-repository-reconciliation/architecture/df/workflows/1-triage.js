export const meta = {
  name: 'df-triage',
  description: 'Triage every DEFECTS-FOUND entry against the current records, chapters and Lean (read-only), four slices by chapter',
  phases: [{ title: 'Triage', detail: 'four readers, two chapters each' }],
}
const W = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/wt-df'
const D = '_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md'
const SLICES = [
  { key: '01-02', chapters: '01-ROOT.md and 02-MAP.md', sections: '"## 01-ROOT.md", "## 02-MAP.md", "### From chapter 01" and "### From chapter 02"' },
  { key: '03-04', chapters: '03-KNOWING.md and 04-LIFE.md', sections: '"## 03-KNOWING.md", "## 04-LIFE.md", "### From chapter 03" and "### From chapter 04"' },
  { key: '05-06', chapters: '05-COLLECTIVES.md and 06-CLASSICAL-TEXTS.md', sections: '"## 05-COLLECTIVES.md", "## 06-CLASSICAL-TEXTS.md", "### From chapter 05", "### From chapter 06" and "## Found while re-syncing the review packet"' },
  { key: '07-08', chapters: '07-SIGNIFICANCE.md and 08-METHOD.md', sections: '"## 07-SIGNIFICANCE.md", "## 08-METHOD.md", "### From chapter 07" and "### From chapter 08"' },
]
const ITEMS = { type: 'object', properties: { entries: { type: 'array', items: { type: 'object', properties: {
  section: { type: 'string' }, entry: { type: 'string', description: 'the first 100 characters of the bullet, verbatim' },
  part: { type: 'string', description: 'when one bullet holds several defects, which one this row is' },
  status: { type: 'string', enum: ['open', 'partly-open', 'already-fixed', 'not-a-defect', 'not-ours'] },
  kind: { type: 'string', enum: ['record-wording', 'record-declarations', 'regions', 'missing-record', 'lean-docstring', 'chapter-text', 'other'] },
  target: { type: 'string', description: 'record id(s) or file path(s) to change' },
  evidence: { type: 'string', description: 'what you checked: path:line of the record, the Lean statement, the chapter sentence' },
  fix: { type: 'string', description: 'the exact replacement text or change, ready to apply; for a missing record, its id, title, home section, laws with declarations' },
}, required: ['section', 'entry', 'status', 'kind', 'target', 'evidence', 'fix'] } } }, required: ['entries'] }

const results = await parallel(SLICES.map(s => () => agent(
`Read-only: do NOT edit, create or delete any file, and run no git command that changes state. Worktree: ${W} (cd there in every Bash call).

${D} lists defects found on 23 October 2026 while the eight chapters were drafted (and a few later): records whose wording is stale or says more than the Lean, records bound to retired declarations, wrong bases in theories/becoming/results/data/regions.json, results a chapter states that have no record, Lean docstrings that say more than the theorem. Much has changed since (the board item OU6 corrected the grammar's records and docstrings; GS1–GS6, PF, IV3l, MA2, MA3 and others landed). The chapters state what the Lean proves; the records are what the generated result pages show.

Your slice: the bullets under ${s.sections} (chapters ${s.chapters}). For EVERY bullet (and every separate defect inside a bullet), check it against the repository as it is now:
- open the record (theories/becoming/results/records/<id>.json), the Lean declarations it names (experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/*.lean, and the periphery under experiments/integrated-correction/general-framework/generative-basis/lean/ where named; read the STATEMENT), the chapter section, and regions.json;
- decide its status: open, partly-open, already-fixed (say by what), not-a-defect (say why), or not-ours (belongs to another live board item: check _process/BECOMING-WORKBOARD.md's open claims);
- for open ones, give the exact fix, ready to apply: the replacement law text in English AND Chinese when a record law changes (records carry laws [{en, zh, declarations}]), the corrected declaration list, the regions.json change (base, home chapter, anchor), or for a result with no record: an id, title, its home section (chapter + anchor) and its laws with declarations, all checked against the Lean. Keep claims exactly at what the Lean proves; never add a premise or weaken a law beyond what the Lean shows.
Return one row per defect.`,
  { label: `triage:${s.key}`, phase: 'Triage', schema: ITEMS })))
return results.filter(Boolean).flatMap((r, i) => r.entries.map(e => ({ slice: SLICES[i].key, ...e })))
