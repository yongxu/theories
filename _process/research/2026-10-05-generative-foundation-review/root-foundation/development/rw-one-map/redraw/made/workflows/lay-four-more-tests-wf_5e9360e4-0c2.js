export const meta = {
  name: 'lay-four-more-tests',
  description: 'Four more tests laid on the map, each written from the test\'s own record by one reader and set against that record by another: a training run, learners on a shared patch, a built lock that held, and a two-stage game',
  phases: [
    { title: 'Lay', detail: 'one reader per test writes it onto the map from the record' },
    { title: 'Check', detail: 'a second reader sets every sentence against the record' },
  ],
}
const KIT = '/Users/ren/theories/tmp/r7/sheet/v2'
const BASE = `
Read only: change no file, run no test, build or render, and no git command that writes. Shell is for reading.
THE MAP. The repository /Users/ren/theories holds "the theory of becoming" (its AGENTS.md is in your context). Its map is one sheet: each ROW asks one thing of anything that keeps going; each BOX is one way the answer can stand; each ARROW is a way from one box to another, with a kind (proved of the course itself; a proved boundary; proved only with something given from outside; a built example; a reading; one box a case of another). Tests are LAID on the map: what in the test was taken as which box, what the reasoning said, what was seen, and what gave way. The person whose work this is asked that the map "separate logic and situation, even when one is right, the other could be wrong", and "guide us to understand the relationships between reasoning and the actual data".
Files:
  ${KIT}/out/PLACES.md      every band, row and box (what each box means), with every arrow out of it
  ${KIT}/out/PATHS.md       the paths, and at its end the three tests already laid, in full: read them as the model
  ${KIT}/data/sheet.json (boxes, ids like b2.uncounted), passages.json (arrows; an arrow's key is "<from>><to>"), laid.json (the three laid tests as data: the form you return)
  /Users/ren/theories/theories/becoming/results/map/cases.json   an earlier summary of every test (things, bridges, predictions, what followed). A summary: the record is the measure.
  /Users/ren/theories/TESTS.md                                    where each test's folder is; read its README, its frozen predictions and its results.
A WARNING FROM THE LAST ROUND. The three tests already laid were first written from the summary alone, and a second reader found each one tidier than its record: one gave the first round's set-up with the second round's numbers, one credited to the loss a turn that also came without it, one reported "99.5% held" where 40% fell. Write from the record, and say what the record says, including what goes against the reasoning and what the test could not tell.
THE FORM (as in data/laid.json): id (short ascii), test (the test's id exactly as in cases.json), en and zh (a short name a stranger understands), what (the situation, three or four sentences), said (what the reasoning said before the run, in plain words), seen (what was seen, with the numbers), pins (two to five; each: at = the box id the thing was taken as; how = "built" if it was set up so, "found" if it was found so; agree = "yes" if what was seen there is what the reasoning said, "no" if not, "mixed"; en and zh = what in the test was taken as this box; short_en and short_zh = at most five words for the chart, such as "locked, 5 of 5"; seen_en and seen_zh = what was seen there, one sentence with its numbers; found_at = a box id, only where the thing was set up as one box and found at another), used (the keys of the arrows the reasoning went by, taken from passages.json; none if no arrow on the map is the law the test names), gave (where it gave way: {"pin": n} for a pairing or a condition at pin n, or {"passage": "<from>><to>"} for an arrow; empty if nothing gave way), broke (what gave way, in words: the pairing of the test's things with the boxes; a condition of the reasoning; the measure or the scoring rule; or nothing), after (what followed in the account), rival (what else would give the same, if the record says), view (at = the id of a box in the row "How a view meets how things are" (ids c1.*) saying where this test left the account's own view, with one sentence in en and zh; a reading). All texts in English and Chinese; the Chinese written as Chinese. A test and its things are a case in its own words, so words for persons are fine here.`
const SCHEMA = { type: 'object', properties: {
  fits: { type: 'boolean', description: 'false if nothing in the test is a box on this map' }, why_not: { type: 'string' },
  id: { type: 'string' }, test: { type: 'string' }, en: { type: 'string' }, zh: { type: 'string' },
  what_en: { type: 'string' }, what_zh: { type: 'string' }, said_en: { type: 'string' }, said_zh: { type: 'string' }, seen_en: { type: 'string' }, seen_zh: { type: 'string' },
  broke_en: { type: 'string' }, broke_zh: { type: 'string' }, after_en: { type: 'string' }, after_zh: { type: 'string' }, rival_en: { type: 'string' }, rival_zh: { type: 'string' },
  pins: { type: 'array', items: { type: 'object', properties: { at: { type: 'string' }, how: { type: 'string', enum: ['built', 'found'] }, agree: { type: 'string', enum: ['yes', 'no', 'mixed'] }, en: { type: 'string' }, zh: { type: 'string' }, short_en: { type: 'string' }, short_zh: { type: 'string' }, seen_en: { type: 'string' }, seen_zh: { type: 'string' }, found_at: { type: 'string' } }, required: ['at', 'how', 'agree', 'en', 'zh', 'short_en', 'short_zh', 'seen_en', 'seen_zh'] } },
  used: { type: 'array', items: { type: 'string' } },
  gave: { type: 'array', items: { type: 'object', properties: { pin: { type: 'integer' }, passage: { type: 'string' } } } },
  view: { type: 'object', properties: { at: { type: 'string' }, en: { type: 'string' }, zh: { type: 'string' } }, required: ['at', 'en', 'zh'] },
  notes: { type: 'string' } },
  required: ['fits', 'why_not', 'id', 'test', 'en', 'zh', 'what_en', 'what_zh', 'said_en', 'said_zh', 'seen_en', 'seen_zh', 'broke_en', 'broke_zh', 'after_en', 'after_zh', 'rival_en', 'rival_zh', 'pins', 'used', 'gave', 'view', 'notes'] }
const TESTS = [
  { key: 'LA4 (Stage A)', hint: 'small policies trained by policy gradient on a toy fishing season with a bay a colony needs: a training run, set beside the law that a best outcome by the rule takes what it does not count to its lowest allowed level' },
  { key: 'EM1', hint: 'learners that generalise across states harvesting one shared patch: set beside the laws of taking more than comes back and of what sparing returns' },
  { key: 'LA1b', hint: 'a language model choosing a harvesting threshold against others who always harvest: a test whose frozen predictions all agreed; say exactly what it does and does not check' },
  { key: 'TR7A', hint: 'tabular learners in a two-stage game checked at the first stage and not at the second, trained only on the points it pays: a test whose verdicts agreed; say exactly what was proved, what derived, and what this reads' },
]
const LAY = (t) => BASE + `
YOUR WORK: lay the test "${t.key}" on the map (${t.hint}). Find its folder through TESTS.md and cases.json, read the record, read out/PLACES.md to know what each box means, and write the test in the form above. Choose the boxes by what the record says the test's things were taken as; if a thing fits no box on the map, leave it out and say so in notes; if nothing fits, return fits=false with why. In notes give the paths of the record files you read.`
const CHECK = (t, w) => BASE + `
YOUR WORK: a second reader for the test "${t.key}" as just laid on the map. Find the test's own record (TESTS.md; cases.json for its folder), and set every sentence against it: the situation, what the reasoning said (is it what was frozen before the run?), what was seen (every number), each pin (is the thing on the right box, given the box's meaning in out/PLACES.md; is built or found right; is agree right; is the short label true), the arrows named in "used" (do they exist in data/passages.json, and are they the laws the test's predictions name or rest on?), where it gave way, what followed, the rival, and the view. Is anything that goes against the reasoning, or that the test could not tell, left out or softened? Return the whole test as it should stand (every field, corrected where needed), and in notes list each change with the record file and line it rests on.
THE TEST AS LAID:
${JSON.stringify(w)}`
const out = await pipeline(TESTS,
  t => agent(LAY(t), { label: `lay:${t.key}`, phase: 'Lay', schema: SCHEMA, model: 'opus' }),
  (w, t) => (w && w.fits) ? agent(CHECK(t, w), { label: `check:${t.key}`, phase: 'Check', schema: SCHEMA }).then(c => ({ test: t.key, written: w, checked: c })) : { test: t.key, written: w, checked: null })
log(`${out.filter(x => x && x.checked).length} of ${TESTS.length} tests laid and checked`)
return { tests: out }
