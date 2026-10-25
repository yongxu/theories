export const meta = {
  name: 'df-corrections',
  description: 'DF1: apply the open DEFECTS-FOUND corrections (records in three disjoint groups, plus regions, docstrings and small fixes), each with a skeptical review and fixes',
  phases: [{ title: 'Edit', detail: 'three record groups and one non-record group' }, { title: 'Review', detail: 'a skeptic per group' }, { title: 'Fix', detail: 'apply confirmed findings' }],
}
const W = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/wt-df'
const S = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad'
const LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean'
const BASE = `You work in a git worktree of a Lean-backed theory repository: ${W} (cd there in every Bash call). Do not commit and run no git command that changes state; other agents edit other files in this worktree at the same time, so touch ONLY the files your brief names.
Background: _process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md lists defects found on 23 October 2026 while the eight chapters were drafted. A triage has checked every entry against the repository as it is now and proposed a fix for each open one. The chapters (theories/becoming/chapters/) state what the Lean proves; records (theories/becoming/results/records/<id>.json) are what the generated result pages show; Lean lives under ${LEAN}/ (core: becoming/Becoming/*.lean; periphery elsewhere). Read _process/RESULT-WORKFLOW.md "Writing a record (schema 2)" and "Record history" before editing a record.
Rules for every change: verify the triage's proposal against the CURRENT Lean statement (not only the docstring) and the chapter before applying it; if it is wrong or says more or less than the Lean, write the right fix instead. Never add a premise or weaken a law beyond what the Lean shows. Keep claims exactly at what is proved.`
const RECBRIEF = (i) => `${BASE}

Your group: ${S}/df-group-${i}.json, which lists the records you own ("records") and the triaged rows to apply ("rows", each with the triage's evidence and proposed fix). Edit ONLY those record JSON files.
For each record: apply its rows' fixes (wording of statement, claim, laws en/zh, hypotheses, does_not_show, declarations, aliases, related/dependencies as the row says). Keep the record's schema and layout (json.dumps(indent=2, ensure_ascii=False) + newline, keys in their order); respect the field limits (laws 420/190 chars en/zh, statement 300/150, hypotheses 420/190, does_not_show 240/110, validation_scope 600/260, next_delta 400/180); no dates, rounds, sections, receipts or Lean names in public fields (see RESULT-WORKFLOW). When you add a declaration to a law, it must also be in the record's aliases and in the declarations of the references entry for its Lean file; if that file is not yet referenced, add a references entry like the record's others (path, role "proof", sha256 of the file's current bytes, declarations) and a proof_bindings entry modelled on an existing binding for that file in another record (grep the records for the file path). Remove declarations that no longer exist everywhere they occur in the record.
Add ONE history note to each record you change, appended to "history": {"en": "25 October 2026, board item DF (study section DF_N): <what changed and why, in one or two sentences>", "zh": "2026年10月25日，工作板条目 DF（研究第 DF_N 节）：<同上，中文>"}; keep the literal DF_N (it is filled at landing).
Then run \`python3 -B tools/research/research.py check --ids <your changed record ids>\` and \`python3 -B tools/research/research.py lint --ids <the same>\`. Fix every error for your records (schema, limits, unknown declarations, references). Ignore "generated view differs" (pages are rendered at the end) and drift reported for files you did not touch. Do not run research-render.
Return: per record, what you changed; rows you did not apply and why; the checker's last result.`
const NONBRIEF = `${BASE}

Your rows: ${S}/df-nonrec.json (regions, Lean docstrings, chapter links, small fixes in other files). You may edit ONLY: theories/becoming/results/data/regions.json; the Lean files those rows name (docstrings and comments ONLY: never change a statement, a proof, a name or an import; ${LEAN}/becoming/Becoming/SelectionPool.lean is excluded); theories/becoming/chapters/02-MAP.md, 06-CLASSICAL-TEXTS.md and 08-METHOD.md (only the lines the rows name); _process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md (only the D45 append the row gives; add no new D entry); _process/goals/theory-of-becoming.json (only the next_step text the row names); _process/research/2026-10-05-repository-reconciliation/architecture/SPINE.md; and the RO kit's build_passages.py and passages.json under _process/research/2026-10-05-generative-foundation-review/root-foundation/development/ro-relational-sources/ (rebuild passages.json with the script and run its verify_ro.py; report the result). Do NOT edit any record JSON (other agents own them); where a row also asks for a record change, report it instead.
For regions.json keep its layout (read how it is written and write it back the same way). For 06 §7.2 the row asks that its 「…」 quotations be checked against the frozen texts their zhonghua entries cite: find and run the repository's checker for that (look for verify_zh.py) or check them yourself, and correct any fragment that is not verbatim.
Return: per row, what you changed (file, line) or why not; the Lean files you changed (they need a core recheck); the verify_ro result.`
const REVBRIEF = (what) => `${BASE}

Read-only now: do NOT edit any file. A previous agent applied ${what} in this worktree; \`git -C ${W} diff\` shows all changes in the worktree (look only at the files of your scope). Check, by opening the cited Lean statements and chapter sections: every changed sentence says exactly what the Lean proves (no overclaim, no dropped hypothesis, right direction and quantifier); English and Chinese agree; the schema rules hold (field limits; no dates, rounds, sections, receipts or Lean names in public fields; declarations named in laws are in aliases and references); nothing the row asked for was missed; Lean changes are docstring-only. Report only real problems with the record id or file, the exact text, what is wrong, the evidence (path:line), the exact fix, and severity (error, imprecise, style). Empty list if none.`
const FIND = { type: 'object', properties: { findings: { type: 'array', items: { type: 'object', properties: {
  target: { type: 'string' }, quote: { type: 'string' }, problem: { type: 'string' }, evidence: { type: 'string' }, fix: { type: 'string' },
  severity: { type: 'string', enum: ['error', 'imprecise', 'style'] } }, required: ['target', 'quote', 'problem', 'fix', 'severity'] } } }, required: ['findings'] }
const DONE = { type: 'object', properties: {
  changed: { type: 'array', items: { type: 'object', properties: { target: { type: 'string' }, change: { type: 'string' } }, required: ['target', 'change'] } },
  not_applied: { type: 'array', items: { type: 'object', properties: { row: { type: 'string' }, why: { type: 'string' } }, required: ['row', 'why'] } },
  lean_files_changed: { type: 'array', items: { type: 'string' } },
  checker: { type: 'string' } }, required: ['changed', 'not_applied', 'checker'] }
const FIXED = { type: 'object', properties: {
  applied: { type: 'array', items: { type: 'string' } }, rejected: { type: 'array', items: { type: 'object', properties: { finding: { type: 'string' }, why: { type: 'string' } }, required: ['finding', 'why'] } },
  checker: { type: 'string' } }, required: ['applied', 'rejected', 'checker'] }

const RESUME1 = `${RECBRIEF(1)}

RESUMED: an earlier agent with this brief was interrupted at its very end, after it had applied the rows to 38 of the group's 39 records (each changed record already carries one DF history note; the reviewed_at_utc fields were refreshed). Do NOT redo or duplicate that work. Instead: (1) for each record of the group, read \`git -C ${W} diff -- theories/becoming/results/records/<id>.json\` and compare it with the group's rows; apply any row that is not yet applied (the one unchanged record first: decide whether its rows need a change at all); make sure no record carries two DF history notes; (2) run the checker and lint for the changed ids; (3) return, per record, what the diff changes (from the diff), the rows not applied and why, and the checker's last result.`
const UNITS = [0, 1, 2].map(i => ({ key: `records-${i}`, edit: i === 1 ? RESUME1 : RECBRIEF(i), what: `the record corrections of group ${i} (records listed in ${S}/df-group-${i}.json)`, fix: true, i }))
  .concat([{ key: 'nonrec', edit: NONBRIEF, what: `the non-record corrections listed in ${S}/df-nonrec.json (regions.json, Lean docstrings, chapter lines, DELEGATED-CHOICES D45, the goal's next_step, SPINE.md, the RO passages)`, fix: false }])

const results = await pipeline(
  UNITS,
  u => agent(u.edit, { label: `edit:${u.key}`, phase: 'Edit', schema: DONE }),
  (done, u) => agent(`${REVBRIEF(u.what)}\n\nThe editor's report: ${JSON.stringify(done || {}).slice(0, 8000)}`, { label: `review:${u.key}`, phase: 'Review', schema: FIND })
    .then(f => ({ done, findings: (f && f.findings) || [] })),
  (r, u) => {
    if (!u.fix || !r.findings.length) return { unit: u.key, done: r.done, findings: r.findings, fixed: null }
    return agent(`${RECBRIEF(u.i)}\n\nA skeptical reviewer reported the findings below on your group's records. For each, open the evidence and decide: apply it (with its fix or a better one) or reject it, saying why. Then rerun the checker for your records.\n\n${JSON.stringify(r.findings, null, 1).slice(0, 24000)}`,
      { label: `fix:${u.key}`, phase: 'Fix', schema: FIXED }).then(x => ({ unit: u.key, done: r.done, findings: r.findings, fixed: x }))
  },
)
return results.filter(Boolean)
