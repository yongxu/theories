export const meta = {
  name: 'df1-review-fix',
  description: 'DF1: finish group 1 of the record corrections, then a skeptical review and fixes for each of the three record groups',
  phases: [{ title: 'Finish', detail: 'group 1 only' }, { title: 'Review', detail: 'a skeptic per group' }, { title: 'Fix', detail: 'apply confirmed findings' }],
}
const W = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/wt-df'
const S = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad'
const LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean'
const BASE = `You work in a git worktree of a Lean-backed theory repository: ${W} (cd there in every Bash call). Do not commit and run no git command that changes state; other agents edit other files in this worktree at the same time, so touch ONLY the files your brief names.
Background: _process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md lists defects found on 23 October 2026 while the eight chapters were drafted. A triage checked every entry against the repository and proposed a fix for each open one; editors have since applied the fixes to the records (theories/becoming/results/records/<id>.json, what the generated result pages show). The chapters (theories/becoming/chapters/) state what the Lean proves; Lean lives under ${LEAN}/ (core: becoming/Becoming/*.lean; periphery elsewhere). _process/RESULT-WORKFLOW.md "Writing a record (schema 2)" and "Record history" give the record rules.
Rules: every claim exactly at what the CURRENT Lean statement proves (open the theorem, not only its docstring): no dropped hypothesis, right direction and quantifier, no overclaim, no added premise. Keep the record layout (json.dumps(indent=2, ensure_ascii=False) + newline, keys in their order) and the field limits (laws 420/190 chars en/zh, statement 300/150, hypotheses 420/190, does_not_show 240/110, validation_scope 600/260, next_delta 400/180); no dates, rounds, sections, receipts or Lean names in the public fields (title, statement, claim, laws, does_not_show, counterexamples, next_delta). A declaration named in a law must be in the record's aliases and in the declarations of the references entry for its Lean file. Each changed record carries exactly ONE history note beginning "25 October 2026, board item DF (study section DF_N):" (zh "2026年10月25日，工作板条目 DF（研究第 DF_N 节）："), keeping the literal DF_N.`
const GROUP = (i) => `${S}/df-group-${i}.json`
const REPORT = { 0: `${S}/df1-edit-records-0.json`, 2: `${S}/df1-edit-records-2.json` }
const FINISH1 = `${BASE}

Your group: ${GROUP(1)} lists the records you own ("records") and the triaged rows to apply ("rows", each with evidence and a proposed fix). Edit ONLY those record JSON files.
An earlier editor with this assignment was interrupted at its very end, after it had applied the rows to 38 of the group's 39 records (each changed record already carries its DF note; reviewed_at_utc was refreshed). Do NOT redo or duplicate that work. Instead: (1) for each record of the group, read \`git -C ${W} diff -- theories/becoming/results/records/<id>.json\` and compare it with the group's rows: apply any row not yet applied, first deciding whether the one unchanged record's rows need a change at all (verify each against the Lean); make sure no record carries two DF notes; (2) run \`python3 -B tools/research/research.py check --ids <changed ids>\` and \`... lint --ids <same>\` and fix every error for your records (ignore "generated view differs" and drift of files you did not touch); (3) return, per record, what the diff changes, the rows not applied and why, and the checker's last result.`
const REVIEW = (i, report) => `${BASE}

Read-only: do NOT edit any file. The records of the group listed in ${GROUP(i)} ("records"; the triaged rows it was to apply are in "rows") have been corrected in this worktree. \`git -C ${W} diff -- theories/becoming/results/records/<id>.json\` shows each record's changes against the last commit; the diff is the ground truth (an editor's report may be stale where a later pass refined a note or a statement). ${report}
Check every changed record, opening the cited Lean statements and the chapter's home section (theories/becoming/results/data/regions.json says which chapter; the anchor is r-<id>): every changed sentence says exactly what the Lean proves; English and Chinese agree; the rules above hold (limits, public fields, aliases and references for every declaration named, exactly one DF note, the note saying truly what changed); nothing a row asked for was missed or applied wrongly; no unchanged text was damaged. Report only real problems: record id, the exact text, what is wrong, the evidence (path:line), the exact fix, and severity (error, imprecise, style). Empty list if none.`
const FIX = (i, findings) => `${BASE}

Your group: ${GROUP(i)} lists the records you own; edit ONLY those record JSON files. A skeptical reviewer reported the findings below on them. For each finding, open its evidence and the Lean and decide: apply it (with its fix or a better one) or reject it, saying why. Where a change alters what the record's DF note describes, amend that ONE note rather than adding another. Then run \`python3 -B tools/research/research.py check --ids <your changed ids>\` and \`... lint --ids <same>\` and fix every error for your records (ignore "generated view differs" and drift of files you did not touch). Return the findings applied, those rejected with why, and the checker's last result.

${JSON.stringify(findings, null, 1).slice(0, 30000)}`
const FIND = { type: 'object', properties: { findings: { type: 'array', items: { type: 'object', properties: {
  target: { type: 'string' }, quote: { type: 'string' }, problem: { type: 'string' }, evidence: { type: 'string' }, fix: { type: 'string' },
  severity: { type: 'string', enum: ['error', 'imprecise', 'style'] } }, required: ['target', 'quote', 'problem', 'fix', 'severity'] } } }, required: ['findings'] }
const DONE = { type: 'object', properties: {
  changed: { type: 'array', items: { type: 'object', properties: { target: { type: 'string' }, change: { type: 'string' } }, required: ['target', 'change'] } },
  not_applied: { type: 'array', items: { type: 'object', properties: { row: { type: 'string' }, why: { type: 'string' } }, required: ['row', 'why'] } },
  checker: { type: 'string' } }, required: ['changed', 'not_applied', 'checker'] }
const FIXED = { type: 'object', properties: {
  applied: { type: 'array', items: { type: 'string' } }, rejected: { type: 'array', items: { type: 'object', properties: { finding: { type: 'string' }, why: { type: 'string' } }, required: ['finding', 'why'] } },
  checker: { type: 'string' } }, required: ['applied', 'rejected', 'checker'] }

const results = await pipeline(
  [0, 1, 2],
  i => i === 1
    ? agent(FINISH1, { label: 'finish:records-1', phase: 'Finish', schema: DONE }).then(d => ({ report: `The finishing editor's report: ${JSON.stringify(d || {}).slice(0, 8000)}`, done: d }))
    : { report: `The editor's report is in ${REPORT[i]} (changed rows and the rows it did not apply, with why; check those reasons too).`, done: null },
  (r, i) => agent(REVIEW(i, r.report), { label: `review:records-${i}`, phase: 'Review', schema: FIND }).then(f => ({ ...r, findings: (f && f.findings) || [] })),
  (r, i) => !r.findings.length ? { group: i, done: r.done, findings: [], fixed: null }
    : agent(FIX(i, r.findings), { label: `fix:records-${i}`, phase: 'Fix', schema: FIXED }).then(x => ({ group: i, done: r.done, findings: r.findings, fixed: x })),
)
return results.filter(Boolean)
