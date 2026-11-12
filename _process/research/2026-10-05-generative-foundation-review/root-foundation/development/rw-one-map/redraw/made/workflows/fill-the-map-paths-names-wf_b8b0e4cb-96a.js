export const meta = {
  name: 'fill-the-map-paths-names',
  description: 'The link that closes the lock ring set against the Lean; three more paths written and checked (a view and how things are; between things that keep going; of anything that keeps going); names others gave the boxes, from the crosswalk, written and checked',
  phases: [
    { title: 'Write', detail: 'the ring link, three paths, the names' },
    { title: 'Check', detail: 'each path and the names set against what they stand on' },
  ],
}
const KIT = '/Users/ren/theories/tmp/r7/sheet/v2'
const LEAN = '/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming'
const BASE = `
Read only: change no file, run no test, build or render, and no git command that writes. Shell is for reading (grep, python3 -B to query JSON).
THE MAP. The repository /Users/ren/theories holds "the theory of becoming" (its AGENTS.md is in your context). Its map is one sheet: each ROW asks one thing of anything that keeps going; each BOX is one way the answer can stand; each ARROW is a way from one box to another, with a short tag, a full sentence set against the Lean statement of its law, and a kind: law (proved of the course itself, under its condition), line (a proved boundary: which side a thing is on; nothing shown to move), needs (proved only with something given from outside the course, or only a necessary condition), built (shown only in a built example), reading (not proved), same (one box is a case of the other). PATHS are told on it step by step in plain sentences; TESTS are laid on it.
Files (read these; ${KIT}/data is the source):
  ${KIT}/out/THE-MAP.md     the page, with the first path told (the model for register and length)
  ${KIT}/out/PLACES.md      every band, row and box, with what is known about staying there and every arrow out of it (tag, full sentence, kind, Lean names)
  ${KIT}/out/PATHS.md       the two paths told with what each step stands on, and three tests laid
  ${KIT}/data/sheet.json, passages.json, paths.json, laid.json   the data (boxes have ids like b2.uncounted; an arrow's key is "<from>><to>")
  ${KIT}/out/*.zh.md        the same pages in Chinese
Lean sources: ${LEAN}/ (find a theorem with grep -rn "theorem .*<name>"; read its statement and docstring).
WORDS. The person whose work this is rejected an earlier map as a filing of laws that did not show what happens, hard for a person to read, in the project's own vocabulary, with words that fit only persons used of things that are not persons. So: plain sentences a person outside the project follows; say what happens and under what; "can" where the law has can; a built example told as an example; a boundary told as what it turns on, not as a movement. In a told step, a tag or a box's sentence use no word that fits only a person (no people, someone, anyone, who; in Chinese no 人, 谁, 大家); examples ("Such as ...") may. Write the Chinese as thought in Chinese, plain and short, not as a rendering of the English. No Lean identifiers or formulas in a sentence.
Your final answer is data for the coordinator.`

// ---------------------------------------------------------------- the ring link
const RING = BASE + `
YOUR WORK: one arrow and one path section, against the Lean.
(1) The arrow b1.held > b2.uncounted ("Holds itself in place" to "Using up what is not counted") was added by the coordinator to close a ring the map draws: locked -> goes on using up what it does not count -> what would read the loss is gone -> judged only by its own picks (= locked). Its present sentence: "The laws take the growing loss as given: where each step adds to what is used up beyond the count, a lock once formed stays while that loss passes every bound." (kind needs; law ClosedCapture.lock_outlives_loss). Set it against the Lean: what do the laws say of what a lock does to what it does not count? Look at ClosedCapture (Accrues, Unread, lock_outlives_loss, join_course), PoolFromCourse (the drain's dependence on the share: window_order_kept and its premises; Drained), Optimum.least_of_room and Web.optimum_ends_beyond (a best outcome by the rule takes the uncounted thing to its lowest allowed level), RuleCapture. Is the growth of the loss a premise, a consequence of anything, or monotone in the lead under a stated premise? Give the arrow as it should stand: kind, tag (English at most nine words; Chinese short), full sentence in English and Chinese (two or three short sentences are fine), the laws that carry it (Becoming.X.y), and the Lean statement in a few plain words. If no arrow should be drawn there, say so and why.
(2) The first section of the path "A rule that holds itself in place" (id lock) now runs in the ring's order, steps 1 to 6 (see ${KIT}/out/PATHS.md and data/paths.json). Step 3 is new and was written by the coordinator. Set each of steps 1 to 6, as told, against the full sentences of the arrows and boxes it stands on (and for step 3 against what you found in (1)): does a step say more than they do, drop a condition, tell a premise as a consequence? Return the corrected say_en and say_zh for any step that should change (both, whole), with why. Check the five lines under "What this path shows" for the lock path against the kinds of the arrows their step numbers point to (count steps through the sections in order from 1), and return corrected lines (all five, both languages) if any is wrong.`
const RING_SCHEMA = { type: 'object', properties: {
  arrow: { type: 'object', properties: { draw: { type: 'boolean' }, kind: { type: 'string', enum: ['law', 'line', 'needs', 'built', 'reading', 'same'] }, tag_en: { type: 'string' }, tag_zh: { type: 'string' }, en: { type: 'string' }, zh: { type: 'string' }, laws: { type: 'array', items: { type: 'string' } }, statement: { type: 'string' }, why: { type: 'string' } }, required: ['draw', 'kind', 'tag_en', 'tag_zh', 'en', 'zh', 'laws', 'statement', 'why'] },
  steps: { type: 'array', items: { type: 'object', properties: { step: { type: 'integer' }, say_en: { type: 'string' }, say_zh: { type: 'string' }, why: { type: 'string' } }, required: ['step', 'say_en', 'say_zh', 'why'] } },
  shows_change: { type: 'boolean' }, shows_en: { type: 'array', items: { type: 'string' } }, shows_zh: { type: 'array', items: { type: 'string' } }, notes: { type: 'string' } },
  required: ['arrow', 'steps', 'shows_change', 'shows_en', 'shows_zh', 'notes'] }

// ---------------------------------------------------------------- paths
const PATH_SCHEMA = { type: 'object', properties: {
  id: { type: 'string', description: 'short ascii id, lower case, letters only' }, bands: { type: 'array', items: { type: 'string' } },
  en: { type: 'string' }, zh: { type: 'string' }, lead_en: { type: 'string' }, lead_zh: { type: 'string' },
  sections: { type: 'array', items: { type: 'object', properties: {
    en: { type: 'string' }, zh: { type: 'string' }, tone: { type: 'string', enum: ['close', 'turn', 'late', 'open'] },
    steps: { type: 'array', items: { type: 'object', properties: { say_en: { type: 'string' }, say_zh: { type: 'string' }, on: { type: 'array', items: { type: 'string' } }, eg: { type: 'string' } }, required: ['say_en', 'say_zh', 'on'] } } },
    required: ['en', 'zh', 'tone', 'steps'] } },
  shows_en: { type: 'array', items: { type: 'string' } }, shows_zh: { type: 'array', items: { type: 'string' } }, notes: { type: 'string' } },
  required: ['id', 'bands', 'en', 'zh', 'lead_en', 'lead_zh', 'sections', 'shows_en', 'shows_zh', 'notes'] }
const BANDS = [
  { key: 'view', band: 'C', name: 'A view and how things are', hint: 'This band is where the map holds reasoning and what is observed themselves: a view, what it is of, how the view comes to meet it, stops meeting it, is checked, goes stale, or cannot act on what it sees. The person whose work this is asked that the map "guide us to understand the relationships between reasoning and the actual data". Follow a view from several accounts still open, to checked, to going by how it was; and the two pockets, keeping to the known road and looking the same from here, with what leaving each takes.' },
  { key: 'between', band: 'D', name: 'Between things that keep going', hint: 'This band holds what stands between things that keep going: leaning wholly on another or each depending on the others; giving that waits on giving (giving goes round, one link drops out, each waits for the other); lasting through what carries it (handed on, stopped for want of one thing); how many ways are in use. Choose the course most worth following for a first reader: probably giving that waits on giving with what breaks the wait, joined to lasting by being handed on. One path, not a tour of every row.' },
  { key: 'returns', band: 'E', name: 'Of anything that keeps going', hint: 'This band holds for anything that keeps going, whatever its ties: whether what it does comes back (a line, or a ring), and how much comes back each turn (at rest, made good again, coming round again, swinging past the mark, growing on itself, nowhere it could rest). Follow a difference sent out: nothing comes back; a ring closes; then by what each turn returns it is closed, kept, grows, swings or rests.' },
]
const WRITE = (b) => BASE + `
YOUR WORK: write one path to read through the band "${b.name}" (band id ${b.band}).
${b.hint}
A path is 8 to 14 steps in 2 to 4 sections. Each section has a tone: close (ways toward less being open), turn (ways back or out), late (where it is too late), open (where it starts, or what no law shows). Each step is one or two plain sentences told as what happens (say_en, say_zh) and stands on one or two things named in "on": "box:<id>" for a box, "<from>><to>" for an arrow exactly as keyed in data/passages.json (a line or a same may be named either way round), "stay:<id>" for what is known about staying at a box. A step may add "eg": the id of a box whose example ("Such as ...") should be shown under it.
Rules for a told step: it rests only on the full sentences of what it names; it keeps every condition they carry; it does not tell a built example as general, a boundary as a movement, or a necessary condition as enough. An unmarked step will be announced as proved, so if a step's first arrow is law or line, everything the step says must be proved by the arrows it names. Use only arrows and boxes that exist; prefer arrows inside the band, and name an arrow to another band only where the course really leads there.
Also write: id (short, ascii), title and lead in both languages (the lead: what everyday thing this is about, and what the path follows; two sentences), bands (the ids of the bands its boxes lie in), and three or four lines "What this path shows" in both languages, saying by step number which steps are proved of the course itself, which are proved only with something given from outside, which are shown only in built examples or are readings, and what no law drawn here shows. Read the first path on ${KIT}/out/THE-MAP.md for the register. In notes say what you left out and any arrow or box you found wrong while reading.`
const CHECK = (b, path) => BASE + `
YOUR WORK: a second reader for a path just written through the band "${b.name}". Set every told step against the full sentences of the arrows and boxes it names (data/passages.json and sheet.json; out/PLACES.md prints them; open the Lean where the truth of a step turns on the law itself): does it say anything they do not, or more (a condition dropped; "is" where the sentence has "can"; a built example or a reading told as general; a boundary told as a movement; a necessary condition told as enough)? Does every "on" name a box, an arrow key or a stay that exists (a line or same may be named either way round)? Is each sentence plain to a person outside the project, in each language; is the Chinese natural Chinese; is any word used that fits only a person? Do the lines under "What this path shows" cite the right step numbers (count steps through the sections in order from 1) for the kinds of the arrows those steps name? Is the order of steps one a reader can follow as a course?
Return the whole path as it should stand (every field, corrected where needed, unchanged where right), and in notes list what you changed and why, step by step.
THE PATH AS WRITTEN:
${JSON.stringify(path)}`

// ---------------------------------------------------------------- names
const NAMES = BASE + `
YOUR WORK: the names others gave these places. The work is also "a map of wisdom: what traditions, sciences, philosophies and systems thinking have seen of these dynamics, read onto one account, where they meet it and where they do not". The account already holds those readings; your work is to bring them to the boxes, not to make new ones.
Sources, all in the repository:
  /Users/ren/theories/theories/becoming/results/atlas/entries/correspondences.json   1,183 readings of what others claimed, each with name, domain or group, quote, relation (agreement, scope, divergence and so on), reading, and targets (records and dynamics of the atlas)
  /Users/ren/theories/theories/becoming/results/atlas/CROSSWALK.md and crosswalk/      the same as pages
  /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/tm-traditions-onto-the-map/   sayings of traditions landed on dynamics (see its pilot JSON files and README)
  /Users/ren/theories/theories/becoming/ONE-PAGE.md ("The evidence": the closest known results), /Users/ren/theories/theories/becoming/chapters/06-CLASSICAL-TEXTS.md
How a name reaches a box: each box in data/sheet.json lists "dynamics" (ids of atlas dynamics placed there), and each arrow names Lean laws; a correspondence's targets name records or dynamics. A name belongs at a box only where the account's own reading puts it on a dynamic or law of that box, and the box's sentence is what that reading is about.
For each box where the account has such a reading, give up to three names, the ones a general reader is most likely to know or most worth meeting: a field's name (Goodhart's law, the tragedy of the commons, lock-in, regulatory capture, Ostrom's commons, the Matthew effect, overshoot, homeostasis, tit for tat, path dependence, the Red Queen, Kuhn and so on) or a saying with its source in its own language (《老子》, 《孟子》, 《國語》, 黄宗羲, a sutra, a Greek text and so on). For each: the box id; the name as it should be shown in English (with author or source; a saying in its own script followed by a short English gloss) and in Chinese; how it stands to the box in the account's own reading: "close" (the reading agrees), "within" (agrees within stated limits or scope), or "not" (the account reads it as not the same: worth showing where a reader would expect it to be the same); the id of the correspondence or the file it comes from; and one sentence, quoting, of what the account's reading says. Do not give a name the account has not read. Aim for 25 to 45 names over the 50 boxes; a box with no reading gets none.`
const NAMES_SCHEMA = { type: 'object', properties: {
  names: { type: 'array', items: { type: 'object', properties: { box: { type: 'string' }, en: { type: 'string' }, zh: { type: 'string' }, how: { type: 'string', enum: ['close', 'within', 'not'] }, source: { type: 'string' }, reading: { type: 'string' } }, required: ['box', 'en', 'zh', 'how', 'source', 'reading'] } },
  notes: { type: 'string' } }, required: ['names', 'notes'] }
const NAMES_CHECK = (w) => BASE + `
YOUR WORK: a second reader for names others gave the map's boxes. Each name below was taken from the account's own readings (correspondences.json at /Users/ren/theories/theories/becoming/results/atlas/entries/, the traditions pilot under /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/tm-traditions-onto-the-map/, ONE-PAGE.md "The evidence"). For each: open its source. Is the reading there, under that id? Does it put the name on a dynamic or law of this box (data/sheet.json boxes[].dynamics; the arrows' laws), and is the box's sentence what the reading is about? Is "how" right: close (the reading agrees), within (agrees within limits or scope), not (the account reads it as not the same)? Is a quoted saying exact, in its own script, with its source right? Is the name as shown one a reader would recognise, in each language? Return every name as it should stand, with verdict keep, fix or drop and why; drop any that the account has not read onto this box.
THE NAMES AS WRITTEN:
${JSON.stringify(w.names)}`
const NAMES_CHECK_SCHEMA = { type: 'object', properties: {
  names: { type: 'array', items: { type: 'object', properties: { box: { type: 'string' }, verdict: { type: 'string', enum: ['keep', 'fix', 'drop'] }, en: { type: 'string' }, zh: { type: 'string' }, how: { type: 'string', enum: ['close', 'within', 'not'] }, source: { type: 'string' }, why: { type: 'string' } }, required: ['box', 'verdict', 'en', 'zh', 'how', 'source', 'why'] } },
  notes: { type: 'string' } }, required: ['names', 'notes'] }

const [ring, paths, names] = await Promise.all([
  agent(RING, { label: 'lean:ring-link', phase: 'Write', schema: RING_SCHEMA }),
  pipeline(BANDS,
    b => agent(WRITE(b), { label: `write:path-${b.key}`, phase: 'Write', schema: PATH_SCHEMA }),
    (path, b) => path ? agent(CHECK(b, path), { label: `check:path-${b.key}`, phase: 'Check', schema: PATH_SCHEMA }).then(c => ({ band: b.band, written: path, checked: c })) : { band: b.band, written: null, checked: null }),
  agent(NAMES, { label: 'write:names', phase: 'Write', schema: NAMES_SCHEMA, model: 'opus' })
    .then(w => w ? agent(NAMES_CHECK(w), { label: 'check:names', phase: 'Check', schema: NAMES_CHECK_SCHEMA }).then(c => ({ written: w, checked: c })) : null),
])
log(`ring link: ${ring ? 'returned' : 'missing'}; paths checked: ${paths.filter(p => p && p.checked).length} of ${BANDS.length}; names: ${names && names.checked ? names.checked.names.length : 0}`)
return { ring, paths, names }
