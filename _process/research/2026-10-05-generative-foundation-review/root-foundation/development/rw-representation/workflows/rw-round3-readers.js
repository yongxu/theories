export const meta = {
  name: 'rw-round3-readers',
  description: 'Third reader round on RW round-3 low fixes: fronts and code lenses, adversarial check of any medium/high',
  phases: [{ title: 'Read', detail: 'fronts and code readers on the diff' }, { title: 'Verify', detail: 'a skeptic per medium or high finding' }],
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
const COMMON = `Read only: edit nothing, run no tests, build nothing (the implementer ran the focused tests: 6 modules pass; the render reports no errors and no source drift). Worktree ${WT}, branch rw-iter2, tip 2cb4b4964. Severity high, medium or low; the round closes at no high and no medium, so reserve medium for what would mislead a reader or break a build or page, and be exact.`
const LENSES = [
  { key: 'fronts', prompt: `You are the third-round reader of front-page fixes in a theory repository. ${COMMON}
The previous round's findings (all low) were: (1) READING-BUDGETS' first-screen row gave 517 words where the rendered screen (title to "## Truth exists", counted by tools/research/navigation.py prose_counts) had 547; (2) the screen said "four questions" but linked a worked page listing five; (3) the Constitutional AI study (_process/research/2026-10-05-generative-foundation-review/root-foundation/development/cr1-coupling-correspondence/CORRESPONDENCE.md §2) and the worked audit in theories/becoming/USES-EXAMPLES.md ("A worked audit: AI feedback against written principles") left out other human inputs on the harmlessness side (human-written red-team prompts; a critic trained on human helpfulness feedback); (4) the audit's item 1 named the feedback model's judgment as the function where the RL signal is the preference model's reward; (5) item 3 called Gao, Schulman and Hilton's synthetic setup a human-preference measurement; (6) the plain lead on the first screen was one 95-word sentence.
The fixes are /Users/ren/tmp/rw/drafts/r3c-fronts.diff. Read it, the rendered README.md up to "## Truth exists", READING-BUDGETS' row 27 (_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/READING-BUDGETS.md), the study's §1–2, the audit, and the record theories/becoming/results/records/coupling-closures-of-training-pipelines.md. Check the paper's figures yourself at https://arxiv.org/html/2212.08073 (WebFetch; §3.1–3.2 and §4.1–4.2). Recount the screen with prose_counts if you can reason it from the text; otherwise check the row's arithmetic (words/130 and words/100, screen 150 words).
For each prior item give closed, partly or open. Then new problems: anything false or misleading to a reader, a qualifier or standing dropped against its home, an AI reading unlabelled, a figure that does not match the paper, a premise of the ethics missing where it is summarized (the continuation condition fixes scope; C gives order; both unasserted). Front pages may name no person or AI author; do not ask for an authorship line.` },
  { key: 'code', prompt: `You are the third-round code reader of a static-site builder change. ${COMMON}
The previous round's findings (all low) were: (1) section_text ignored fences, comments, GitHub's numbering of repeated headings and <a id> anchors; (2) with site.map off, nav_zh, a ways_in zh field and anchored targets like connections.html#x were not filtered, and Links.resolve's SPECIAL branch wrote a map link regardless; (3) an alias to a SPECIAL page (README.md -> index.html) skipped the lines check (a ?plain=1 or #L5 link lost GitHub) and the anchor check; (4) the asset-mode test could not fail; (5) Page._list swallowed an ATX heading directly after a list item as a lazy continuation (seen on theories/LINEAGE.zh.md's "## 改名"); (6) a CSS comment gave a wrong reason.
The fixes are /Users/ren/tmp/rw/drafts/r3c-code.diff (tools/publishing/build_site.py, site.css, tools/research/tests/test_site.py). Read them in full context. A site built from the tree just before this commit's render is at /Users/ren/tmp/rw/site4; you may read it, but it predates the _list change.
For each prior item give closed, partly or open. Then new problems: a bug; a regression in pages that rendered correctly before (in particular, does the new break in _list end a list where GitHub would continue it: an indented heading, a line starting with '>' inside an item, a '---' after an item that GitHub reads otherwise, '#hashtag' text; scan a few real site pages' Markdown under ${WT}/theories for list items followed directly by such lines); a link resolving wrong; a path where a private file or key could be published (pattern in tools/research/push_screen.sh); a test that does not test what it names; section_text disagreeing with the ids the builder writes.` },
]
phase('Read')
const results = await pipeline(
  LENSES,
  l => agent(l.prompt, { label: `read:${l.key}`, phase: 'Read', schema: SCHEMA }),
  (r, l) => {
    if (!r) return null
    const serious = r.findings.filter(f => f.severity !== 'low')
    return parallel(serious.map(f => () => agent(
      `Adversarially verify one reader finding in a theory repository (worktree ${WT}, branch rw-iter2, tip 2cb4b4964). Read only; edit nothing, run nothing heavy. Try to refute it: read the cited files yourself and decide whether the problem is real and how severe (high/medium/low/none), where medium means it would mislead a reader or break a build or page. Default to not-real if the claim does not hold up in the files.\nFinding (${f.severity}) at ${f.where}: ${f.problem}\nProposed fix: ${f.fix}`,
      { label: `verify:${l.key}`, phase: 'Verify', schema: VERDICT }).then(v => ({ ...f, check: v }))))
      .then(checked => ({ key: l.key, verdict: r.verdict, prior: r.prior, findings: [...r.findings.filter(f => f.severity === 'low'), ...checked.filter(Boolean)] }))
  },
)
return results.filter(Boolean)
