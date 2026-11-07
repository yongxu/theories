export const meta = {
  name: 'rw-rescore',
  description: 'Fresh reviewers re-score how the repository presents itself on the seven questions; a checker verifies; a synthesis lists what keeps any score below 8',
  phases: [{ title: 'Review' }, { title: 'Check' }, { title: 'Synthesize' }],
}
// args: { wt: worktree path of the tree to score, site: path of the built site, date: 'YYYY-MM-DD', round: n }
const WT = args.wt
const SITE = args.site
const Q = `The seven questions, each scored 0 to 10:
Q1. How representable is the project (can a newcomer grasp what it is, how it stands and why it matters, from where they land)?
Q2. Is there a static website to visualize it (built, reachable, elegant, faithful to the repository)?
Q3. Are the unification and the connections shown elegantly (a picture or view a reader can follow, edge kinds kept apart, honest about how far unification goes)?
Q4. Is it clear how the whole grew into today's account (a narrative and picture of its growth, with evidence labels)?
Q5. Can people understand what value it provides (said plainly, early, with a concrete case, without overclaiming)?
Q6. Does it clearly show how it can be used in alignment, wisdom, coordination, human development and other fields (worked examples at their true standing, "nothing claimed" where nothing is)?
Q7. Are valuable things easy to see, and their connections clear (one click from the landing, pages that render, a navigation that leads)?`
const CONTEXT = `You review how the theory repository presents itself, not whether the theory is true. The tree to review is ${WT} (a checkout; read-only: edit nothing, run no tests, call no model, download nothing). The reader's site is built at ${SITE} (static HTML; open the files; its home is ${SITE}/index.html). Its publishing on GitHub Pages waits on the owner's switch: the job is .github/workflows/pages.yml (dispatch only); score Q2 on the site as built and say what the switch would add. GitHub renders the repository's Markdown and SVG files; a page over about 2 MB of Markdown does not render there (a check on 8 November found 1.0 MB renders and 3.7 MB does not). Front pages name no person and no AI by rule (the README's first screen is tested for it); "[AI reading]" labels mark readings. An earlier review (7 November, ${WT}/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv-representation/review/REVIEW.md) scored the seven questions 4, 2, 4, 3, 4, 4, 3; do not anchor on it: score what is there now, and for any score below 8 name exactly what would raise it, file by file. Searched is not read: say what you read.`
const REVIEW_SCHEMA = { type: 'object', required: ['scores', 'findings', 'read'], properties: {
  read: { type: 'string' },
  scores: { type: 'array', items: { type: 'object', required: ['q', 'score', 'why', 'to_reach_8'], properties: {
    q: { type: 'string' }, score: { type: 'number' }, why: { type: 'string' }, to_reach_8: { type: 'string' } } } },
  findings: { type: 'array', items: { type: 'object', required: ['severity', 'where', 'problem', 'fix'], properties: {
    severity: { type: 'string', enum: ['high', 'medium', 'low'] }, where: { type: 'string' }, problem: { type: 'string' }, fix: { type: 'string' } } } },
} }
const LENSES = [
  { key: 'first-contact', q: 'Q1, Q5', prompt: 'Arrive as a newcomer on GitHub: README.md (its first screen and navigation), then whatever it leads you to in the first ten minutes. Then arrive on the site home. Can you say what this is, how it stands and why it matters?' },
  { key: 'site', q: 'Q2, Q7', prompt: 'The site: read tools/publishing/build_site.py, site.css, _process/research-config.json\'s site key, .github/workflows/pages.yml, then browse the built site (home, nav, several pages, a chapter with its marks, the tests, the uses page, the graph, the map if present). Is it elegant, faithful, safe (no private paths), complete enough to be the way in?' },
  { key: 'unification', q: 'Q3', prompt: 'How the unification and connections are shown: the spine picture (find it: an SVG under theories/becoming/results/ or embedded in ONE-PAGE, the overview, THEORY-GRAPH.md), THEORY-GRAPH.md\'s tables, the connection map (theories/becoming/results/atlas/map.html or its site copy), 08-METHOD.md §7. Is it elegant, legible, honest (11 derived, 99 at a named distance; edge kinds apart)?' },
  { key: 'growth', q: 'Q4', prompt: 'How the whole grew: LINEAGE.md (find it) and its Chinese edition, MAP.md\'s "How it got here", _process/history/2026-09-consolidation/TIMELINE.md, _process/history/INDEX.md, theories/README.md and the earlier folders\' banners. Is the growth clear, pictured, evidence-labelled?' },
  { key: 'uses', q: 'Q5, Q6', prompt: 'Value and uses: theories/becoming/USES.md (and its Chinese edition if present), ONE-PAGE.md, theories/becoming/review/ALIGNMENT.md\'s ten minutes, COLLECTIVE-DIRECTION.md. Are the uses concrete, at their true standing, with "nothing claimed" where nothing is? Check a few restatements against their homes.' },
  { key: 'navigation', q: 'Q7, Q1', prompt: 'Navigation and visibility: the navigation line on generated pages, MAP.md, TESTS.md, RESULTS.md, OPEN-QUESTIONS.md, GLOSSARY.md, theories/README.md, the review packet README. Is each valuable thing one click from the landing, and do the pages render on GitHub (sizes)?' },
  { key: 'chinese', q: 'Q1, Q5, Q7 for a Chinese reader', prompt: 'A Chinese reader\'s way in: README and the site\'s 中文 links, ONE-PAGE.zh.md, THE-THEORY-OF-BECOMING.zh.md, theories/becoming/review/README.zh.md, chapter 06, USES.zh.md and LINEAGE.zh.md if present. Score the seven questions as they stand for a reader of Chinese.' },
]
phase('Review')
const reviews = await parallel(LENSES.map(l => () => agent(`${CONTEXT}

${Q}

Your lens (${l.key}; weigh ${l.q} most, but score all seven): ${l.prompt}

Return a score for each of Q1–Q7 with why and exactly what would raise it to 8 or more, and findings (high: a reader would be misled or blocked; medium: a real gap a reviewer would mark down; low: polish).`, { label: `review:${l.key}`, phase: 'Review', schema: REVIEW_SCHEMA, effort: 'high' }).then(r => r && ({ lens: l.key, ...r }))))
const got = reviews.filter(Boolean)
phase('Check')
const check = await agent(`${CONTEXT}

Seven reviewers scored the seven questions and reported findings (JSON):
${JSON.stringify(got)}

Check every high and medium finding against the files: does it hold, hold in part, or not hold? Check each score below 8 against what its reviewer says would raise it: is that the true blocker, and is it in reach without changing what the account claims? Return findings with a verdict each, and a short note per question on whether the reviewers' scores are fair.`, { label: 'check', phase: 'Check', schema: { type: 'object', required: ['verdicts', 'per_question'], properties: {
  verdicts: { type: 'array', items: { type: 'object', required: ['where', 'verdict', 'note'], properties: { where: { type: 'string' }, verdict: { type: 'string', enum: ['holds', 'partly', 'does not hold'] }, note: { type: 'string' } } } },
  per_question: { type: 'string' } } }, effort: 'xhigh' })
phase('Synthesize')
const synth = await agent(`Synthesize a scoring report (Markdown) from seven reviewers and a checker of how the theory repository presents itself. ${Q}

Reviews: ${JSON.stringify(got)}
Checker: ${JSON.stringify(check)}

Give: a table of the seven questions with each reviewer's score, the median, and the checker's view; then, for every question whose median is below 8, the blockers that hold after checking, each with the file and the fix; then the findings that hold, ranked. Say plainly that every reader here is an AI and no person has scored it. Do not soften a score.`, { label: 'synthesize', phase: 'Synthesize', effort: 'high' })
return { reviews: got, check, synth }
