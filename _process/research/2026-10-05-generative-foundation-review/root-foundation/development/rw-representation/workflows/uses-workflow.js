export const meta = {
  name: 'rw-uses',
  description: 'Assemble the uses page from three checked drafts, then a fresh reader checks it against its homes',
  phases: [{ title: 'Assemble' }, { title: 'Read' }],
}
const WT = '/Users/ren/tmp/rw/wt'
const D = '/Users/ren/tmp/rw/drafts'
const RULES = `Rules that bind every sentence: restating a claim, copy its home's words first and shorten after (a gloss is where qualifiers and standings drop); name both premises of the ethics wherever it is summarized (the continuation condition fixes scope, whose losses count, ranking nothing; C, widening what can form is better, gives order), never write that the ethics derives from the condition; keep apart proved, proved under conditions, argued, empirical, a reading, conjecture; "AI reading" labels stay where a reading is an AI's; name no person and no AI system by name or brand (say "language models", "AI readers"); use each term in GLOSSARY.md's one sense; links relative to theories/becoming/ (the page's folder), anchors that exist. Searched is not read: say only what you read.`

const READ_SCHEMA = { type: 'object', required: ['findings', 'verdict', 'read'], properties: {
  verdict: { type: 'string' }, read: { type: 'string', description: 'what you read in full, what in part, what not' },
  findings: { type: 'array', items: { type: 'object', required: ['severity', 'where', 'problem', 'fix'], properties: {
    severity: { type: 'string', enum: ['high', 'medium', 'low'] }, where: { type: 'string' }, problem: { type: 'string' }, fix: { type: 'string' } } } },
} }

phase('Assemble')
const page = await agent(`You assemble one front page of the theory repository in the worktree ${WT}, from drafts already written and checked. Write it to ${D}/USES.md (that file only; edit nothing in the worktree, run no tests, call no model).

Inputs (read each in full): ${D}/draft-uses-alignment.json, ${D}/draft-uses-collective.json, ${D}/draft-uses-wisdom.json (each: rows, worked examples, restatements with their homes' words, doubts) and ${D}/check-uses-alignment.json, ${D}/check-uses-collective.json, ${D}/check-uses-wisdom.json (adversarial checks: findings with fixes). Apply every high and medium fix, and every low fix that costs a clause; where a fix and the draft disagree, open the home and follow it. Read theories/becoming/ONE-PAGE.md and GLOSSARY.md first for the register and terms.

${RULES}

The page, theories/becoming/USES.md, "What the account is for, and how far":
- First line an HTML comment: "<!-- A front page (RW, 8 November 2026): what the account is for, field by field, and how far. AI-written from the homes it links, each restatement checked against its home by AI readers; no person has read it. Where it and a home differ, the home governs. -->"
- Title "# What the account is for, and how far", then a line of links: [One page](ONE-PAGE.md) · [The overview](THE-THEORY-OF-BECOMING.md) · [The tests](../../TESTS.md) · [Glossary](../../GLOSSARY.md)
- A reading-time line: "*Ten minutes for the table; about an hour with the worked examples.*" (the render measures it; keep the table and lead within about 1,300 words, and the whole page within about 6,000).
- A lead of at most 120 words: what the page is; that the account's laws are theorems about models under named premises, and that using them on an actual system needs a correspondence, stated where it is shown and otherwise an AI reading or open; that ranking anything needs the ethics' two unasserted premises (name both with their roles); that where the account claims nothing, the row says "Nothing claimed".
- "## In ten minutes": one table, a row per field in this order: Alignment of AI systems; People and AI together; Coordination among people; Human development (生生); Wisdom traditions; The sciences. Columns: Field | What you can do with it today | How it stands | What is not claimed. Each cell short (at most about 60 words), links to homes.
- "## Worked examples": one "###" per field in the same order, each example a "####" with its label in italics on its first line (its true standing: from a frozen test; constructed, not observed; an AI reading; a use of a proved law), then the example. Keep each example's numbers exactly as checked.
- "## What this page does not do": three to five bullets (it adds no result; it is not advice; a field's use waits on a correspondence; what no person has yet checked).
Return a short note of what you changed from the drafts and any fix you did not apply, with why.`, { label: 'assemble:uses', phase: 'Assemble', effort: 'high' })

phase('Read')
const reading = await agent(`You are an independent reader of a new front page of the theory repository (worktree ${WT}, read-only; edit nothing, run no tests). The page is ${D}/USES.md, to be placed at theories/becoming/USES.md (its links are relative to theories/becoming/). Read it in full, then open every home it links and check each sentence that restates a claim against its home: a standing raised, a qualifier or hypothesis dropped, a premise left out, proved said of what is argued, a use invented where the home claims nothing, a number or formula that does not match the model, a quotation not verbatim, a label missing ("AI reading", "constructed"), a link or anchor that does not resolve, a term outside GLOSSARY.md's sense. Also judge it as a reader new to the work: is each row's "what you can do today" concrete and true, and is the page clear? ${RULES}
Severity: high if a reader would believe something false about what is proved, tested or claimed; medium if a qualifier or standing a reader needs is missing, a link is wrong, or a passage is unclear enough to mislead; low for precision and style.`, { label: 'read:uses-1', phase: 'Read', schema: READ_SCHEMA, effort: 'high' })
return { page, reading }
