export const meta = {
  name: 'df1-sweep',
  description: 'DF1: sweep retired labels and the retired registration and "author" wording out of the live record fields, fix the remaining chapter lines, each with an adversarial review, a fix pass and a completeness check',
  phases: [{ title: 'Sweep', detail: 'four disjoint record groups and the chapter lines' }, { title: 'Review', detail: 'a skeptic per unit' }, { title: 'Fix', detail: 'apply confirmed findings' }, { title: 'Completeness', detail: 'what the sweep missed' }],
}
const W = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/wt-df'
const S = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad'
const LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean'
const BASE = `You work in a git worktree of a Lean-backed theory repository: ${W} (cd there in every Bash call). Do not commit and run no git command that changes state; other agents edit other files in this worktree at the same time, so touch ONLY the files your brief names. Lean lives under ${LEAN}/ (core: becoming/Becoming/*.lean; periphery elsewhere); chapters in theories/becoming/chapters/; records in theories/becoming/results/records/<id>.json (_process/RESULT-WORKFLOW.md gives the record rules).
Board item DF is correcting the defects listed in _process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md. Earlier passes corrected many records already (see \`git -C ${W} diff\`); this pass finishes what they left.`
const RULES = `The rules of this sweep:
- AGENTS.md: live text uses the current terms, each in the one sense GLOSSARY.md gives; retired labels are explained once, in theories/becoming/chapters/08-METHOD.md (the table after the anchor retired-labels): G0 → living significance (生生之意义); S0 → self-significance; N_rel, N_std → relational and standpoint neutrality; the one axiom → the continuation condition (stated, not asserted); Part I, Part II → the theory without the condition, its conditional section; the G0/J route → the conditional alignment route; J1–J4 → the practical commitments; the Universal Metaethical Core → significance, comparison and practical judgment; the registration vocabulary (registers, unregistered, 记下, 登记 in that sense) → coupling (couples into, takes in, 耦合入). Read GLOSSARY.md for the exact words.
- Change a use only where it is the retired LABEL or the retired SENSE. Keep: a Lean declaration name, in backticks or a declarations list or named as the periphery's definition (the periphery still defines \`GenerativeComparison.G0\`, \`N_rel\` and the like; you may write "living significance (the periphery's \`G0\`)" where the Lean name helps); ordinary words ("a blank register" of a quantum record, a cited paper's own term, an author of a cited work); and every word of Ren's in quotation marks, verbatim (AGENTS: Ren's words stay verbatim with their source). Where text is AI-written around a quotation, only the AI text changes.
- "the author's reading" / 作者的读法 in a record means the AI's reading: write "a reading (the AI's)" / "读法（AI 的）" or fold it into the sentence, so the reading keeps its AI label. If "the author" means someone else (a cited author, Ren), keep it.
- Change nothing else: no claim, law, hypothesis or boundary may become stronger or weaker; a term replaced must mean exactly what the label meant there. Never touch "history" (it keeps old words) or "references"/"proof_bindings".
- Keep the record layout (json.dumps(indent=2, ensure_ascii=False) + newline, keys in their order) and the field limits (laws 420/190 en/zh, statement 300/150, hypotheses 420/190, does_not_show 240/110, validation_scope 600/260, next_delta 400/180). Schema-1 records have a growth ratchet: their limitations, validation_scope and correspondence may grow by at most 40 English or 20 Chinese characters against the base commit 0e368fbf2, so where a term is longer than the label, tighten the same sentence.
- Each record you change carries exactly ONE history note beginning "25 October 2026, board item DF (study section DF_N):" (zh "2026年10月25日，工作板条目 DF（研究第 DF_N 节）："), literal DF_N: if the record already has one (an earlier pass), extend it by a clause; else append one, saying in a sentence which labels or words were replaced.
- Then run \`python3 -B tools/research/research.py check --changed-since 0e368fbf2 --ids <your changed ids>\` and \`python3 -B tools/research/research.py lint --ids <same>\`; fix every error for your records (ignore "generated view differs" and drift in files you did not touch).`
const GROUPS = `${S}/df1-sweep-groups.json`
const SPEC = `${S}/df1-sweep-spec.json`
const SWEEP = (i) => `${BASE}

Your records: the list at index ${i} of "groups" in ${GROUPS}. Edit ONLY those record JSON files. ${SPEC} gives specific instructions for some records (apply those of yours, verifying each against the record and the Lean). For every one of your records, search every field except history, references and proof_bindings for the retired labels, the registration sense and "the author's reading", in both languages (grep is not enough: also read each field once), and correct each use under the rules.

${RULES}

Return: per record, each change (field, old → new); the uses you kept and why (Lean name, Ren's words, ordinary word); the checker's last result.`
const CHAPTERS = `${BASE}

Your files: theories/becoming/chapters/01-ROOT.md, 04-LIFE.md, 05-COLLECTIVES.md and 07-SIGNIFICANCE.md, only the lines named here. The triaged rows are in ${S}/df-group-1.json ("rows" index 3 and 11 and 30) and ${S}/df-group-2.json ("rows" index 28); their editors applied the record parts and left these chapter parts:
1. 01-ROOT.md near line 358: the sentence citing \`projection_exact_iff\` for finite-trace-transport (row 3 of group 1): make the chapter's sentence say what the record's laws now say (read the record theories/becoming/results/records/finite-trace-transport.json and the Lean).
2. 07-SIGNIFICANCE.md near line 474: 'and an optimum's drain wherever that leaves room' (row 11 of group 1): check against the Lean of what-an-optimum-does-beyond-what-couples-in and correct it if the triage is right.
3. 05-COLLECTIVES.md §7(b) (row 30 of group 1, optional): decide whether the wording should change; the row says the source's term may stay.
4. 04-LIFE.md near line 50 (row 28 of group 2, a-pattern-lasts-through-passing): the chapter sentence the row names; bring it to the record's new law (read the record and the Lean, Becoming.PatternPassing and the grammar).
Each result is stated once, in its home section (anchor r-<record id>), and the chapter states exactly what the Lean proves; keep the chapter's voice and layout. Then run \`python3 -B tools/research/research.py links\` and report any broken link in your files.

Return: per item, the change (file:line, old → new) or why none; the links result.`
const REVIEW = (what) => `${BASE}

Read-only: do NOT edit any file. A previous agent applied ${what}; \`git -C ${W} diff -- <file>\` shows each file's changes against the last commit (earlier passes' changes are in the same diff: judge the whole diff of your files). Check, opening the Lean and the glossary: every replaced term means exactly what the label meant there; nothing became stronger or weaker; Ren's quoted words and Lean names are untouched; English and Chinese agree; ordinary uses were not changed; no use in your files was missed (search again, both languages); the record rules hold (limits, one DF note per record, the schema-1 ratchet: \`python3 -B tools/research/research.py check --changed-since 0e368fbf2 --ids <ids>\`). Report only real problems: target, exact text, what is wrong, evidence (path:line), exact fix, severity (error, imprecise, style). Empty list if none.

${RULES}`
const FIX = (scope, findings) => `${BASE}

Your files: ${scope}. Edit only those. A skeptical reviewer reported the findings below. For each, open its evidence and decide: apply it (with its fix or a better one) or reject it, saying why. Keep one DF note per record (amend it, do not add a second). Rerun the checks your brief's files need.

${RULES}

${JSON.stringify(findings, null, 1).slice(0, 30000)}`
const FIND = { type: 'object', properties: { findings: { type: 'array', items: { type: 'object', properties: {
  target: { type: 'string' }, quote: { type: 'string' }, problem: { type: 'string' }, evidence: { type: 'string' }, fix: { type: 'string' },
  severity: { type: 'string', enum: ['error', 'imprecise', 'style'] } }, required: ['target', 'quote', 'problem', 'fix', 'severity'] } } }, required: ['findings'] }
const DONE = { type: 'object', properties: {
  changed: { type: 'array', items: { type: 'object', properties: { target: { type: 'string' }, change: { type: 'string' } }, required: ['target', 'change'] } },
  kept: { type: 'array', items: { type: 'object', properties: { target: { type: 'string' }, why: { type: 'string' } }, required: ['target', 'why'] } },
  checker: { type: 'string' } }, required: ['changed', 'kept', 'checker'] }
const FIXED = { type: 'object', properties: {
  applied: { type: 'array', items: { type: 'string' } }, rejected: { type: 'array', items: { type: 'object', properties: { finding: { type: 'string' }, why: { type: 'string' } }, required: ['finding', 'why'] } },
  checker: { type: 'string' } }, required: ['applied', 'rejected', 'checker'] }

const UNITS = [0, 1, 2, 3].map(i => ({ key: `sweep-${i}`, brief: SWEEP(i), what: `the retired-label sweep to the records at index ${i} of "groups" in ${GROUPS}`, scope: `the record JSON files listed at index ${i} of "groups" in ${GROUPS}` }))
  .concat([{ key: 'chapters', brief: CHAPTERS, what: 'the chapter-line corrections in 01-ROOT.md, 04-LIFE.md, 05-COLLECTIVES.md and 07-SIGNIFICANCE.md described in the brief (rows 3, 11 and 30 of df-group-1.json and 28 of df-group-2.json in the scratchpad)', scope: 'theories/becoming/chapters/01-ROOT.md, 04-LIFE.md, 05-COLLECTIVES.md and 07-SIGNIFICANCE.md (only the lines of the four items)' }])

const results = await pipeline(
  UNITS,
  u => agent(u.brief, { label: `sweep:${u.key}`, phase: 'Sweep', schema: DONE }),
  (done, u) => agent(`${REVIEW(u.what)}\n\nThe editor's report: ${JSON.stringify(done || {}).slice(0, 10000)}`, { label: `review:${u.key}`, phase: 'Review', schema: FIND })
    .then(f => ({ done, findings: (f && f.findings) || [] })),
  (r, u) => !r.findings.length ? { unit: u.key, done: r.done, findings: [], fixed: null }
    : agent(FIX(u.scope, r.findings), { label: `fix:${u.key}`, phase: 'Fix', schema: FIXED }).then(x => ({ unit: u.key, done: r.done, findings: r.findings, fixed: x })),
)
phase('Completeness')
const critic = await agent(`${BASE}

Read-only: do NOT edit any file. A sweep has just replaced retired labels (G0, S0, N_rel, N_std, the one axiom, Part I/II, the G0/J route, J1–J4 as PracticalJudgment, the Universal Metaethical Core), the retired registration sense (registers, unregistered, 记下/登记 in that sense) and "the author's reading" in the live fields of the records (every field except history, references and proof_bindings), keeping Lean names, Ren's quoted words and ordinary uses. Search ALL records under theories/becoming/results/records/ (skip redirect stubs) and the eight chapters for every remaining use, in both languages, and classify each: kept rightly (Lean name, Ren's words, ordinary word, a frozen or history context) or still a retired label/sense in live text (give record id or file:line, the field, the exact text, and the exact replacement). Also check the chapters' retired-labels table itself is unchanged. Return the list of uses still to fix (empty if none) and a count of the kept ones by reason.`, { label: 'completeness', phase: 'Completeness', schema: { type: 'object', properties: { to_fix: { type: 'array', items: { type: 'object', properties: { target: { type: 'string' }, field: { type: 'string' }, quote: { type: 'string' }, fix: { type: 'string' } }, required: ['target', 'quote', 'fix'] } }, kept: { type: 'string' } }, required: ['to_fix', 'kept'] } })
return { units: results.filter(Boolean), critic }
