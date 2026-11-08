export const meta = {
  name: 'rw-round4-fronts',
  description: 'Fourth reader round on RW: the Sharma correction and third-round lows, with an adversarial check of any medium or high',
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
const PROMPT = `You are the fourth-round reader of front-page fixes in a theory repository. Read only: edit nothing, run no tests, build nothing (the implementer's focused tests pass and the render reports no errors and no source drift). Worktree ${WT}, branch rw-iter2, tip 1b2b57c8a. Severity high, medium or low; the round closes at no high and no medium, so reserve medium for what would mislead a reader, and be exact.

The previous round's findings were:
(M) medium: theories/becoming/USES-EXAMPLES.md, "A worked audit: AI feedback against written principles", item 3 said none of 07 §6's three measurements was made on this pipeline, though Sharma et al. 2023 §4.2 optimizes against the Claude 2 preference model, trained on human judgments for helpfulness and AI judgments for harmlessness; the paper does not say those AI judgments read written principles.
(L1) low: the study's Laws paragraph and audit item 2 said "through the principles alone" without "as the paper frames it"; the chain-of-thought feedback model went unnamed; a parenthetical in the study's note and the record's history read as the frame's content.
(L2) low: audit item 1 said the preference model's reward is a function of "the transcript pair"; "Against it" spoke of picks separating pairs.
(L3) low: the record said figures came from abstracts read 22 October, though section 2 now has figures from the paper's body.
(L4) low: READING-BUDGETS' first-screen row gave the opening as 21.2 to 27.5 minutes; it measures 21.9 to 28.5.

The fixes are /Users/ren/tmp/rw/drafts/r4-fronts.diff. Read it; the audit in full in theories/becoming/USES-EXAMPLES.md; the study _process/research/2026-10-05-generative-foundation-review/root-foundation/development/cr1-coupling-correspondence/CORRESPONDENCE.md sections 1, 2 and "What this establishes"; theories/becoming/results/records/coupling-closures-of-training-pipelines.md; chapter 07 §6 at #r-coupling-closures-of-training-pipelines. Check the papers yourself with WebFetch: Sharma et al. at https://ar5iv.labs.arxiv.org/html/2310.13548 (§3, §4.1, §4.2, §4.3.2) and Constitutional AI at https://arxiv.org/html/2212.08073 (§3.1, §3.2, §4.1, §4.2); Wen et al. arXiv:2409.12822 and Gao et al. arXiv:2210.10760 by their abstract pages.

For each prior item give closed, partly or open. Then new problems the fixes brought: anything false or misleading to a reader; a statement about a paper it does not support; "by analogy" or "a reading" missing where the bearing is not shown; "figures read from the papers' abstracts" now wrong for any figure stated in the sentence it governs; a qualifier dropped against its home; a stated reading time wrong (tools/research/navigation.py reading_time: USES-EXAMPLES states 46 to 59 minutes). Front pages may name no person or AI author; do not ask for an authorship line.`
phase('Read')
const r = await agent(PROMPT, { label: 'read:fronts', phase: 'Read', schema: SCHEMA })
if (!r) return { failed: true }
phase('Verify')
const serious = r.findings.filter(f => f.severity !== 'low')
const checked = await parallel(serious.map(f => () => agent(
  `Adversarially verify one reader finding in a theory repository (worktree ${WT}, branch rw-iter2, tip 1b2b57c8a). Read only; edit nothing. Try to refute it: read the cited files, and the cited paper where one is named (Sharma et al.: https://ar5iv.labs.arxiv.org/html/2310.13548; Constitutional AI: https://arxiv.org/html/2212.08073), and decide whether the problem is real and how severe (high/medium/low/none), where medium means it would mislead a reader. Default to not-real if the claim does not hold up.\nFinding (${f.severity}) at ${f.where}: ${f.problem}\nProposed fix: ${f.fix}`,
  { label: 'verify:fronts', phase: 'Verify', schema: VERDICT }).then(v => ({ ...f, check: v }))))
return { verdict: r.verdict, prior: r.prior, findings: [...r.findings.filter(f => f.severity === 'low'), ...checked.filter(Boolean)] }
