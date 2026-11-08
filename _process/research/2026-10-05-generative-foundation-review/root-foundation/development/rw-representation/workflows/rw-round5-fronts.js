export const meta = {
  name: 'rw-round5-fronts',
  description: 'Fifth and last reader round on RW: the mixed-effects correction at 07 section 6, its record, the study and the audit, with a skeptic on any medium or high',
  phases: [{ title: 'Read', detail: 'one fronts reader on the diff' }, { title: 'Verify', detail: 'a skeptic per medium or high finding' }],
}
const WT = '/Users/ren/tmp/rw/wt2'
const SCHEMA = {
  type: 'object',
  properties: {
    verdict: { type: 'string' },
    prior: { type: 'array', items: { type: 'object', properties: { item: { type: 'string' }, state: { type: 'string', enum: ['closed', 'partly', 'open'] }, why: { type: 'string' } }, required: ['item', 'state', 'why'] } },
    findings: { type: 'array', items: { type: 'object', properties: { severity: { type: 'string', enum: ['high', 'medium', 'low'] }, where: { type: 'string' }, problem: { type: 'string' }, fix: { type: 'string' } }, required: ['severity', 'where', 'problem', 'fix'] } },
  },
  required: ['verdict', 'prior', 'findings'],
}
const VERDICT = { type: 'object', properties: { real: { type: 'boolean' }, severity: { type: 'string', enum: ['high', 'medium', 'low', 'none'] }, why: { type: 'string' } }, required: ['real', 'severity', 'why'] }
const PROMPT = `You are the fifth and last reader of a run of front-page corrections in a theory repository. Read only: edit nothing, run no tests, build nothing (the implementer's focused tests pass and the render reports no errors and no source drift). Worktree ${WT}, branch rw-iter2, tip 105057e9d. Severity high, medium or low; the round closes at no high and no medium. Reserve medium for what would mislead a reader about what a paper found or what a law says; wording preferences and restatements elsewhere are low.

The previous round's findings were:
(M) medium: the worked audit's item 3 (theories/becoming/USES-EXAMPLES.md, "A worked audit: AI feedback against written principles") said the three measurements found optimizing lowering what the deciders do not read and tied the third to this pipeline's split at Sharma et al. §4.2, where the paper reports mixed effects. A checker added that the same page's line 42 quoted 07 §6 unqualified and called it "the drain's direction", and that 07 §6, the record's statement and the study's bullet were unqualified too.
(L1) the study's Sources said all figures were from abstracts. (L2) READING-BUDGETS' opening time should be 21.9 to 28.4. (L3) the audit's "or which half drives what it found" was looser than the study. (L4) the audit's lead used a parenthetical that read as the frame's content. (L5) "transcripts that differ only in what comes after them" should be episodes with the same transcript.

The fixes are /Users/ren/tmp/rw/drafts/r5-fronts.diff. Read it; theories/becoming/chapters/07-SIGNIFICANCE.md at #r-coupling-closures-of-training-pipelines; theories/becoming/results/records/coupling-closures-of-training-pipelines.md (its statement says "the third in part": the statement has a 300-character limit, and the home section gives the detail); theories/becoming/USES-EXAMPLES.md lines 42 to 56; the study _process/research/2026-10-05-generative-foundation-review/root-foundation/development/cr1-coupling-correspondence/CORRESPONDENCE.md sections 1, 2, "What this establishes" and Sources; theories/becoming/review/ALIGNMENT.md line 169. Check Sharma et al. at https://ar5iv.labs.arxiv.org/html/2310.13548 (§4.1, §4.2, §4.3.2) with WebFetch.

For each prior item give closed, partly or open. Then any new problem the fixes brought: a statement the paper does not support (in particular "best-of-N lowering some forms of sycophancy and reinforcement learning raising some", "depended on the optimizer", "it reads the human data as favouring agreement"); "the third in part" misread; a law or a standing changed; a stated reading time wrong (tools/research/navigation.py reading_time: USES-EXAMPLES states forty-six to sixty minutes). Front pages may name no person or AI author; do not ask for an authorship line.`
phase('Read')
const r = await agent(PROMPT, { label: 'read:fronts', phase: 'Read', schema: SCHEMA })
if (!r) return { failed: true }
phase('Verify')
const serious = r.findings.filter(f => f.severity !== 'low')
const checked = await parallel(serious.map(f => () => agent(
  `Adversarially verify one reader finding in a theory repository (worktree ${WT}, branch rw-iter2, tip 105057e9d). Read only; edit nothing. Try to refute it: read the cited files, and the cited paper where one is named (Sharma et al.: https://ar5iv.labs.arxiv.org/html/2310.13548; Constitutional AI: https://arxiv.org/html/2212.08073), and decide whether the problem is real and how severe (high/medium/low/none), where medium means it would mislead a reader about what a paper found or what a law says. Default to not-real if the claim does not hold up.\nFinding (${f.severity}) at ${f.where}: ${f.problem}\nProposed fix: ${f.fix}`,
  { label: 'verify:fronts', phase: 'Verify', schema: VERDICT }).then(v => ({ ...f, check: v }))))
return { verdict: r.verdict, prior: r.prior, findings: [...r.findings.filter(f => f.severity === 'low'), ...checked.filter(Boolean)] }
