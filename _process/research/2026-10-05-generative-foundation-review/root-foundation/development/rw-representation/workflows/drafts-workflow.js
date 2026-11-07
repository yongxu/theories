export const meta = {
  name: 'rw-drafts',
  description: 'Draft the tests scoreboard data and the uses page by field, each checked against its homes',
  phases: [{ title: 'Draft' }, { title: 'Check' }],
}
const WT = '/Users/ren/tmp/rw/wt'
const COMMON = `You work read-only in the worktree ${WT} (a checkout of main of the theory repository). Edit nothing, run no tests, call no model, download nothing. Read files with your tools. Rules that bind every sentence you draft: restating a claim, copy its home's words first and shorten after (a gloss is where qualifiers and standings drop); name both premises of the ethics wherever it is summarized (the continuation condition fixes scope, whose losses count, ranking nothing; C, widening what can form is better, gives order), never write that the ethics derives from the condition; keep apart proved, proved under conditions, argued, empirical, a reading, conjecture; "AI reading" labels stay where a reading is an AI's; name no person and no AI system by name or brand in the page text (say "language models", "AI readers"); links are relative to the page's own folder. Searched is not read: say only what you read.`

const TESTS_SCHEMA = { type: 'object', required: ['rows', 'notes'], properties: {
  notes: { type: 'string' },
  rows: { type: 'array', items: { type: 'object', required: ['id', 'name', 'thesis', 'folder', 'frozen', 'run', 'outcome', 'quote', 'quote_path', 'gloss'], properties: {
    id: { type: 'string', description: 'the test code, e.g. IN1, LA2, CG2, UE31b, T1N; several rounds of one folder may be separate rows' },
    name: { type: 'string', description: 'a plain name of what was tested, at most 12 words' },
    thesis: { type: 'string', description: 'T1..T8 the test bears on, comma-separated, or empty' },
    folder: { type: 'string', description: 'experiments/<folder>/<file> the row links, repository-relative' },
    frozen: { type: 'string', description: 'YYYY-MM-DD the predictions or rule were frozen, or empty if none was frozen' },
    run: { type: 'string', description: 'YYYY-MM-DD the run that was scored, or empty if not run' },
    outcome: { type: 'string', enum: ['failed', 'mixed', 'refused', 'decided-nothing', 'partly-passed', 'not-rejected', 'passed', 'not-run', 'held', 'dropped', 'no-prediction'] },
    quote: { type: 'string', description: 'one verbatim sentence or clause (at most 70 words) from quote_path stating the outcome, copied character for character' },
    quote_path: { type: 'string', description: 'repository-relative file containing quote verbatim' },
    gloss: { type: 'string', description: 'at most 25 plain words for a reader new to the work, saying no more than the quote' },
  } } },
} }

const USES_SCHEMA = { type: 'object', required: ['rows', 'examples', 'restatements', 'open_doubts'], properties: {
  rows: { type: 'array', items: { type: 'object', required: ['field', 'today', 'standing', 'not_claimed'], properties: {
    field: { type: 'string' }, today: { type: 'string', description: 'what a reader can do with the account in this field today, concrete, at most 45 words, with links' },
    standing: { type: 'string', description: 'how it stands, in its homes words, at most 60 words, with links' },
    not_claimed: { type: 'string', description: 'what is not claimed, at most 45 words; "nothing claimed" where nothing is' } } } },
  examples: { type: 'array', items: { type: 'object', required: ['field', 'title', 'label', 'markdown'], properties: {
    field: { type: 'string' }, title: { type: 'string' },
    label: { type: 'string', description: 'its true standing: from a frozen test / constructed, not observed / an AI reading / a use of a proved law, etc.' },
    markdown: { type: 'string', description: '150 to 450 words of Markdown, links relative to theories/becoming/' } } } },
  restatements: { type: 'array', items: { type: 'object', required: ['sentence', 'home', 'home_words'], properties: {
    sentence: { type: 'string' }, home: { type: 'string', description: 'repository-relative path#anchor' }, home_words: { type: 'string', description: 'the home words it restates, verbatim' } } } },
  open_doubts: { type: 'string' },
} }

const CHECK_SCHEMA = { type: 'object', required: ['findings', 'verdict'], properties: {
  verdict: { type: 'string' },
  findings: { type: 'array', items: { type: 'object', required: ['severity', 'where', 'problem', 'fix'], properties: {
    severity: { type: 'string', enum: ['high', 'medium', 'low'] }, where: { type: 'string' }, problem: { type: 'string' }, fix: { type: 'string' } } } },
} }

const PAGE = `The page is theories/becoming/USES.md, "What the account is for, and how far": a front for readers new to the work. Its ten-minute part is one table with a row per field and columns: what you can do with it today; how it stands (its homes' words); what is not claimed. Its hour's path is one worked example per field at its true standing. Fields: alignment of AI systems; coordination among people; people and AI together; wisdom traditions; human development (生生, life in the whole and its continuing generation, not any new organization); the sciences. Where the account claims nothing in a field, the row says "nothing claimed", never an invented use. A reviewer found: for wisdom and human development the account claims almost nothing (wisdom-root open; 07 shows no well-being, duty or rights). Start from theories/becoming/ONE-PAGE.md, THE-THEORY-OF-BECOMING.md, GLOSSARY.md, then the homes named below.`

const FIELDS = [
  { key: 'alignment', fields: 'alignment of AI systems; people and AI together', homes: `ONE-PAGE's case (the fishers, experiments/direction-installation/README.md, IN1); theories/becoming/review/ALIGNMENT.md, its "The dossier in ten minutes" and "What is not claimed"; 03-KNOWING.md#r-selection-through-couplings; 05-COLLECTIVES.md#r-what-an-optimum-does-beyond-what-couples-in and #t3; 02-MAP.md#r-closed-capture and #t7; experiments/self-rewarding-lock/README.md (LA2), experiments/commons-outrun/README.md (CG2), experiments/commons-llm-feedback*/README.md; 07-SIGNIFICANCE.md#alignment-without-premise and its J1–J4 (search "J1"); the AJ goal (GOALS.md, _process/goals/generative-alignment.json, and its plan under _process/research/2026-10-05-generative-foundation-review/root-foundation/development/ whose folder names start "aj"; find "what the goal is not" and its three questions); the handover case in history (search theories/becoming/history and _process/history for "handover" or "hand-over" and read the one that is a constructed case; restate it against J1–J4 in current vocabulary, do not copy its old words). Examples wanted: (1) the fisher case told plainly; (2) a coupling-closure audit of an LLM-as-judge pipeline, step by step (what the judge reads, what the selection can reach, what lies beyond, whether there is room, where a lock can form), set beside what LA2 actually showed, labelled a use of a near-definitional law; (3) the IN1, LA2 and CG2 environments as reusable instruments, each with its limits; (4) AJ's "what the goal is not" and its three questions as a checklist with each item's standing; (5) for people and AI, the handover case against J1–J4, kept "constructed, not an observed deployment".` },
  { key: 'collective', fields: 'coordination among people; human development (生生)', homes: `05-COLLECTIVES.md (own-count misses joint excess; the critical mass; a rule rebuilt from the members it limits), 02-MAP.md's DrawnShaping (search "critical mass" and "DrawnShaping", #r-drawn-shaping-drawn-one-at-a-time), experiments/critical-mass-located/DESIGN.md (CMT, frozen 5 Nov 2026, not run), COLLECTIVE-DIRECTION.md wherever it is (find it; it says no test has human participants), the opening's sentence on coordination and its note (theories/becoming/OPENING.md, "This is a foundation"), 07-SIGNIFICANCE.md (#theses, T8; #scope-and-order; #practical-judgment; what it does not show: well-being, duty, rights), the earlier design programmes' standing in 05-COLLECTIVES.md (search "design programmes"), theories/README.md. Examples wanted: (1) a constructed standards body with illustrative numbers for the drawn-shaping model's parameters (read the model to use its own symbols, e.g. s, p, c, lo, hi, and its critical mass formula exactly as stated) showing where the critical mass falls and what it predicts, labelled constructed, saying CMT is frozen and not run and no test has had people in it; (2) for human development, T8 argued under the two unasserted premises and what 07 does not show, with the design programmes' standing.` },
  { key: 'wisdom', fields: 'wisdom traditions; the sciences', homes: `06-CLASSICAL-TEXTS.md (Chinese; its 未示 / what is not shown, "相合不是印证", its counts of passages), theories/becoming/review/CLASSICAL-TEXTS.md and BUDDHIST-THOUGHT.md (Chinese dossiers; the concession that the theory "站在《中论》所破的那一边"), the record whose id or title concerns two-sided regulation in theories/becoming/results/records/ (find it; it reads 天之道损有余而补不足; find its concession B-02 or the review item it names), the wisdom-root item wherever it is (search "wisdom-root" and "wisdom root"), the sciences dossier theories/becoming/review/SCIENCES.md, 02-MAP.md#t2 and #t1, 03-KNOWING.md#break-seen-coming (T6), 04-LIFE.md#r-evolution-on-descent, 08-METHOD.md#known-results, #what-would-defeat-the-reading and #theses. Examples wanted: (1) for wisdom traditions, what a scholar can use (a structural concordance of passages and the grammar's terms, AI-classified and unreviewed; agreement confirms nothing; nothing claimed for practice; wisdom-root open), with one English passage worked from the two-sided-regulation record, quoting the classical line and its English, with the concession; (2) for the sciences, one worked prediction that could fail and what happened (T2 on fish stocks and the beetle failure, or T6's seabird tests), and what the explanatory reading adds and does not (the tie).` },
]

phase('Draft')
const testsP = agent(`${COMMON}

Task: the data for a scoreboard of the frozen tests, failures first, for readers new to the work. Read experiments/README.md (its table of 36 folders) and, for every folder it lists, that folder's README (or the file the table links) to its result or verdict section; read 08-METHOD.md#theses (theories/becoming/chapters/08-METHOD.md) for which thesis each bears on. One row per scored test or round where a folder holds several distinct frozen tests (e.g. CG3–CG3c, MQ1–MQ7, LA1/LA1b/LA1c, UE31/UE31b, VD1/VD2, IN1 rounds); one row for a folder with no frozen prediction, outcome no-prediction or dropped. The quote must occur verbatim in quote_path (copy it exactly; prefer the folder's own README; the experiments index is acceptable when the folder's README has no outcome sentence). outcome classes: failed (the frozen verdicts failed), mixed (some frozen verdicts passed and some failed, or the verdicts passed and the bridge failed), refused (the run stopped at a check before scoring), decided-nothing, partly-passed, not-rejected, passed, not-run (frozen, not run), held (designed, not frozen), dropped, no-prediction. Choose the class the quote supports, never a kinder one. In notes, list every folder you could not class and why.`, { label: 'draft:tests', phase: 'Draft', schema: TESTS_SCHEMA, effort: 'high' })

const usesP = pipeline(FIELDS,
  f => agent(`${COMMON}

${PAGE}

Your part: the rows and worked examples for ${f.fields}. Homes to read (read each named section, not only search it): ${f.homes}

Return the rows, the examples and, for every sentence that restates a claim, the sentence, its home (path#anchor) and the home's words verbatim. In open_doubts say what you could not find or read, and any place where the homes disagree.`, { label: `draft:uses-${f.key}`, phase: 'Draft', schema: USES_SCHEMA, effort: 'high' }),
  (d, f) => agent(`${COMMON}

You are an adversarial checker of a draft for a front page. ${PAGE}

The draft (JSON) for ${f.fields}:
${JSON.stringify(d)}

Try to refute it. For every row cell, example sentence and listed restatement: open the home it cites and read it; report where a sentence says more than its home (a standing raised, a qualifier dropped, a premise left out, proved said of what is argued, a use invented where the home claims nothing), says less in a way that misleads, misquotes, cites the wrong place, or uses a term outside its GLOSSARY.md sense. Check every number and formula in a constructed example against the model it uses. Check that "nothing claimed" appears where the homes claim nothing. Severity: high if a reader would believe something false about what is proved, tested or claimed; medium if a qualifier or standing a reader needs is missing or a link is wrong; low for precision. Give a fix in the home's words for each.`, { label: `check:uses-${f.key}`, phase: 'Check', schema: CHECK_SCHEMA, effort: 'high' }).then(c => ({ field: f.key, draft: d, check: c })))

const tests = await testsP
const testsCheck = await agent(`${COMMON}

You are an adversarial checker of data for a scoreboard of frozen tests, failures first. The rows (JSON):
${JSON.stringify(tests)}

For every row: open quote_path and confirm the quote occurs there character for character (report any that do not); confirm the outcome class is the one the folder's own result supports and not a kinder one (classes: failed, mixed, refused, decided-nothing, partly-passed, not-rejected, passed, not-run, held, dropped, no-prediction); confirm frozen and run dates against the folder's README; confirm the thesis against theories/becoming/chapters/08-METHOD.md#theses; confirm the gloss says no more than the quote. Then read experiments/README.md's table and report any folder or distinct frozen test missing from the rows. Severity: high if a reader would believe a test passed that did not, or a failure is missing; medium for a wrong date, thesis or a quote not verbatim; low otherwise.`, { label: 'check:tests', phase: 'Check', schema: CHECK_SCHEMA, effort: 'high' })
const uses = await usesP
return { tests, testsCheck, uses }