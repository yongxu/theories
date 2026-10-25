export const meta = {
  name: 'df1-status',
  description: 'DF1: mark every bullet of DEFECTS-FOUND with its status after DF1 (fixed, already fixed, not a defect, left for DF2 or an owner), checked by a skeptic against the diff',
  phases: [{ title: 'Write' }, { title: 'Check' }, { title: 'Fix' }],
}
const W = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/wt-df'
const S = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad'
const F = '_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md'
const SOURCES = `Sources (all in ${S} unless said):
- df-triage.json: 288 triage rows; each has "section" (the heading it sits under), "entry" (the first 100 characters of its bullet), optional "part", "status" (open, partly-open, already-fixed, not-a-defect, not-ours), "kind", "target", "evidence", "fix". Every bullet of the file matches one or more rows by section and entry prefix.
- df-group-0.json, df-group-1.json, df-group-2.json (record rows given to three editors) and df-nonrec.json (non-record rows).
- What was done: df1-edit-records-0.json, df1-edit-records-2.json, df1-edit-nonrec.json (editors' reports: changed and not_applied with why), df1-reviewfix.json (group 1's finishing report and the three groups' reviews, fixes and rejections), df1-edit-review-nonrec.json (the non-record review), df1-sweep-result.json (a later sweep of retired labels and wording, and the chapter lines), df1-lander-notes.md (how the lander settled the deferred items and two reviews), df1-left.md (what goes to DF2 or to owners).
- The ground truth: \`git -C ${W} diff\` (every change against the last commit), and the files themselves.`
const STATUS = `The status sentence, appended at the end of each bullet (same line, after a space), in italics, beginning "*DF:*". One of:
- *DF: fixed* — say where in a few words (record ids, file or chapter section; e.g. "*DF: fixed in the record and regions.json.*"). Partly fixed: say what is fixed and what is left and where it goes.
- *DF: already fixed* — by what (an item or a landing named in the triage evidence, e.g. "by RA's landing", "by OU6").
- *DF: not a defect* — why, in a clause (from the triage evidence, checked).
- *DF: left for DF2* — what (new record, schema-2 migration, rename, D69).
- *DF: for <owner>* — the board note (as in df1-left.md).
A bullet with several rows (parts) gets one sentence covering them, as short as it can be while true. Write in the file's plain English; no Lean names beyond what the bullet itself uses; no dates but none needed; no session or person names.`
const WRITE = `You work in a git worktree: ${W} (cd there in every Bash call). Do not commit; touch ONLY ${F}.

Board item DF has corrected the defects that ${F} lists (written on 23 October while the chapters were drafted, plus a section of 25 October). Mark every bullet (each line starting "- ") with its status after DF1. Add also, right after the file's opening paragraph, one paragraph: "Status after board item DF (25 October 2026): each entry ends with what became of it: fixed in DF1, already fixed before DF, not a defect, left for DF2 (records still to be made, schema-2 migrations, two renames, a decision entry) or for an owner named on the board." Change nothing else in the file.

${SOURCES}

${STATUS}

Verify each "fixed" against the diff (look at the record or file the row targets: is the change there?). Where the diff shows a row was not applied and no source says where it went, say so in the status ("not yet fixed: …") rather than guessing. Write the file with a script that keeps every other byte; check afterwards that only the bullets' line ends and the one new paragraph changed (\`git -C ${W} diff -- ${F}\`).

Return: counts by status; the bullets whose status you could not settle and why.`
const CHECK = `Read-only: do NOT edit any file. Worktree ${W}. A writer appended a status sentence ("*DF: …*") to every bullet of ${F} (see \`git -C ${W} diff -- ${F}\`). Check every status against the evidence: a "fixed" whose change is not in the diff (open the target record or file and compare with the triage row's fix), an "already fixed" or "not a defect" the triage evidence does not support or that is false of the files now, a "left for DF2" or "for <owner>" that names the wrong place, a bullet whose several parts the status does not cover, a status that says more than was done. Also check nothing else in the file changed.

${SOURCES}

${STATUS}

Report only real problems: the bullet (its first words), the status text, what is wrong, the evidence, the exact corrected status. Empty list if none.`
const FIND = { type: 'object', properties: { findings: { type: 'array', items: { type: 'object', properties: {
  bullet: { type: 'string' }, status: { type: 'string' }, problem: { type: 'string' }, evidence: { type: 'string' }, fix: { type: 'string' } }, required: ['bullet', 'problem', 'fix'] } } }, required: ['findings'] }
phase('Write')
const wrote = await agent(WRITE, { label: 'write:status', phase: 'Write', schema: { type: 'object', properties: { counts: { type: 'string' }, unsettled: { type: 'array', items: { type: 'string' } } }, required: ['counts', 'unsettled'] } })
phase('Check')
const checks = await parallel([0, 1].map(k => () => agent(`${CHECK}\n\nYou take the ${k === 0 ? 'first' : 'second'} half of the file's bullets (split at the heading "## Second round"; the half before it is ${k === 0 ? 'yours' : 'the other checker\'s'}${k === 1 ? '; yours is that section and everything after it' : ''}).`, { label: `check:${k}`, phase: 'Check', schema: FIND })))
const findings = checks.filter(Boolean).flatMap(c => c.findings)
phase('Fix')
const fixed = findings.length ? await agent(`You work in a git worktree: ${W} (cd there). Do not commit; touch ONLY ${F}. Checkers reported the problems below with the status sentences ("*DF: …*") a writer appended to the bullets of ${F}. For each, open the evidence and decide: apply the corrected status (or a better one) or reject it, saying why. Change only status sentences.\n\n${SOURCES}\n\n${STATUS}\n\n${JSON.stringify(findings, null, 1).slice(0, 30000)}`, { label: 'fix:status', phase: 'Fix', schema: { type: 'object', properties: { applied: { type: 'array', items: { type: 'string' } }, rejected: { type: 'array', items: { type: 'object', properties: { finding: { type: 'string' }, why: { type: 'string' } }, required: ['finding', 'why'] } } }, required: ['applied', 'rejected'] } }) : null
return { wrote, findings, fixed }
