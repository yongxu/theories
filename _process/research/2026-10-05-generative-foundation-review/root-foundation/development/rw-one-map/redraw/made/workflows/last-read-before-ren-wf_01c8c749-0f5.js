export const meta = {
  name: 'last-read-before-ren',
  description: 'Three readers on what changed since the last read: every arrow tag against its sentence, the page\'s own texts in both languages, and one fresh cold read of the corrected page',
  phases: [{ title: 'Read', detail: 'tags, page texts, a fresh cold reader' }],
}
const SHEET = '/Users/ren/theories/tmp/r7/sheet'
const BASE = `
Read only: change no file, run no test, build or render, and no git command that writes.
A new map of "the theory of becoming" (repository /Users/ren/theories; its AGENTS.md is in your context) is about to be shown to Ren, whose work it is. He rejected the last map because it filed laws and counted them and did not show what happens ("not good enough"; the coordinator's note he confirmed: /Users/ren/theories/tmp/r7/WHY-NOT-GOOD-ENOUGH.md). Earlier he had asked for plain words, less of the project's own vocabulary, words that do not fit only persons ("you use 人 when it is not just about people"), and Chinese that reads as Chinese.
The new map is one page: rows that each ask one thing, boxes (ways the answer can stand), arrows between boxes drawn by how they are known. Its files: ${SHEET}/sheet.txt (everything on the page as text), ${SHEET}/shots/*.png (pictures of the page: lock.png is how it opens; whole.png; judge.png, lake.png, stocks.png are tests laid on it; b2-uncounted.png a box's card; zh.png the Chinese view; own.png), ${SHEET}/built.json (its data as built), ${SHEET}/template.html (the page's own texts are in its script).
Your final answer is data for the coordinator. No scores, no praise.`

const TAGS = BASE + `
YOUR WORK: the arrow tags. Each arrow now has a short tag in English and Chinese, written fast by the coordinator, shown before the arrow's full sentence (which a second reader had set against the Lean). The tags are what a person reads first, on the chart and in every list. ${SHEET}/tags-to-check.json has all 104: the tag, the kind of arrow, the two boxes, and the full sentence in both languages.
For each tag decide:
1. Does it say what carries a thing across this arrow, as its full sentence has it? A tag is short and may leave out conditions; it may not say something other than the sentence, reverse its direction, or claim more (for a "needs" arrow the tag should name what is needed; for a "line" it should name what the line turns on, not say that anything moves; for a "built" arrow it must not read as a general claim; for "same" it should say in what way one is a case of the other).
2. Is it plain to a person outside the project, in each language? Is the Chinese natural Chinese, short, not a rendering of the English?
3. Does it use a word that fits only a person where the law is about anything (no people, someone, anyone, who; no 人, 谁, 大家)?
Return every tag that should change, with the corrected tag in both languages (English at most nine words; Chinese short) and one line of why. Leave the good ones out. Also list at most ten full sentences (by key) whose English or Chinese was damaged by the coordinator's later word replacements ("rebuilt" to "updated", "the hold" to "the lock", "bending" to "shaping", "exactly where" to "if, and only if,", 进程 to 过程, “定住” to 定局) so that grammar or sense broke, with the repaired sentence.`

const TAG_SCHEMA = { type: 'object', properties: {
  tags: { type: 'array', items: { type: 'object', properties: { key: { type: 'string' }, tag_en: { type: 'string' }, tag_zh: { type: 'string' }, why: { type: 'string' } }, required: ['key', 'tag_en', 'tag_zh', 'why'] } },
  sentences: { type: 'array', maxItems: 10, items: { type: 'object', properties: { key: { type: 'string' }, en: { type: 'string' }, zh: { type: 'string' }, why: { type: 'string' } }, required: ['key', 'en', 'zh', 'why'] } },
  notes: { type: 'string' } }, required: ['tags', 'sentences', 'notes'] }

const TEXTS = BASE + `
YOUR WORK: the page's own texts, for truth and for words, in both languages. These were written or rewritten by the coordinator after the last readers and have had no second reader:
- the lead and the line under it (template.html, function labels: #lead, #how), the group labels and chips;
- the legend: the six kinds of arrow and the paragraph "Proved means ..." (template.html: T.en, T.zh, function allPanel);
- "The whole map" panel: what left and right mean, the note on ways right and ways back, and "The one web" (the nine lines of WEB in template.html: is each row under the right tie, and is each tie said rightly?). Check the note on ways right and ways back against built.json: counts.dirs_within_rows gives, for arrows within one row, how many run right or left by kind.
- the two paths (${SHEET}/stories.py PATHS): each lead, the four lines under "What this path shows" with their step numbers (count the steps: a step is one entry in "steps", numbered through the sections in order), and "What the work wants". Each claim must be borne out by the arrows the steps point to in built.json (kind of each arrow; sentences).
- the note at the foot (template.html, function labels: #about): every number is computed from built.json counts (passages, two, one, nolean, anchored, conds); is each sentence true of how the map was made as the files show (${SHEET}/settled.json src fields; verified.json; read-and-fill.json)?
- the renamed boxes and rows (${SHEET}/edits.py: ROW_NAMES, BAND_NAMES, COND_NAMES) and the familiar names (KNOWN, KNOWN_ZH: each should be a reading the account's one page or its crosswalk already makes; /Users/ren/theories/theories/becoming/ONE-PAGE.md "The evidence"; /Users/ren/theories/theories/becoming/results/atlas/entries/correspondences.json).
For each text that is wrong, says more than is so, uses a word that fits only a person where it should not, or reads badly in English or as translated in Chinese: give the corrected text in both languages and one line of why. Give at most twenty corrections, the ones that matter most first.`

const TEXT_SCHEMA = { type: 'object', properties: {
  corrections: { type: 'array', maxItems: 20, items: { type: 'object', properties: { where: { type: 'string' }, now: { type: 'string' }, en: { type: 'string' }, zh: { type: 'string' }, why: { type: 'string' } }, required: ['where', 'now', 'en', 'zh', 'why'] } },
  notes: { type: 'string' } }, required: ['corrections', 'notes'] }

const COLD = BASE + `
YOUR WORK: a fresh cold read. You are a thoughtful person from outside who knows nothing of this project; someone you respect sent you the page.
1. Open lock.png (the page as it opens) and look for a minute. Read what that first screen shows, in the order a person would: the title and lead, the chart, the panel beside it. Use sheet.txt only for the words too small to read in the picture. Do not read the rest yet.
2. Write your say-back at once: what does it say happens to things, and why would it matter to anyone? What can you now see or do that you could not before?
3. Then use the page for five more minutes as you would: open whole.png, one test (judge.png or lake.png), one card (b2-uncounted.png). Note where you first stopped following (the exact words), each word you had to learn, and whether you would keep reading.
4. Say in what respect, if any, this is still a filing of laws and not a map of what happens.
Give at most five changes, each concrete (where, to what), the ones that would most help that person.`

const COLD_SCHEMA = { type: 'object', properties: {
  say_back: { type: 'string' }, stopped_at: { type: 'string' }, words_to_learn: { type: 'array', items: { type: 'string' } },
  still_a_filing: { type: 'string' },
  changes: { type: 'array', maxItems: 5, items: { type: 'object', properties: { what: { type: 'string' }, change: { type: 'string' } }, required: ['what', 'change'] } } },
  required: ['say_back', 'stopped_at', 'words_to_learn', 'still_a_filing', 'changes'] }

phase('Read')
const [tags, texts, cold] = await parallel([
  () => agent(TAGS, { label: 'check:tags', phase: 'Read', schema: TAG_SCHEMA }),
  () => agent(TEXTS, { label: 'check:page-texts', phase: 'Read', schema: TEXT_SCHEMA }),
  () => agent(COLD, { label: 'read:fresh-cold', phase: 'Read', schema: COLD_SCHEMA, model: 'opus' }),
])
return { tags, texts, cold }
