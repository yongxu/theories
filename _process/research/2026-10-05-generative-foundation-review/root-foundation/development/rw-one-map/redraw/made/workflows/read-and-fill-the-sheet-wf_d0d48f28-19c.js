export const meta = {
  name: 'read-and-fill-the-sheet',
  description: 'Six readers say what a person now sees on the new sheet and check it against all of Ren\'s words; in parallel, three bands not yet drawn in full get their passages written and then set against the Lean',
  phases: [
    { title: 'Read', detail: 'six readers of the drawn sheet, one lens each' },
    { title: 'Write', detail: 'passages for the three lower bands, from the placed atlas items and the Lean' },
    { title: 'Check', detail: 'each written passage set against its Lean statement by a second reader' },
  ],
}

const SHEET = '/Users/ren/theories/tmp/r7/sheet'
const LEAN = '/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming'
const OLD = '/Users/ren/theories/theories/becoming/results/map'
const REC = '/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rw-one-map'

// ---------------------------------------------------------------- the readers
const COMMON = `
You are one of six independent readers of a new map. Each reads the same whole material through one lens. Read only: change no file, run no test, build or render, and no git command that writes.

THE SITUATION
The repository /Users/ren/theories holds "the theory of becoming" (its AGENTS.md is in your context: a map of how anything forms, persists, changes and ends; first a map for alignment, also a map of wisdom). On 11 November 2026 Ren, whose work this is, gave its public face "probably just a 4" of 10. Three rounds of prototypes followed and a map was landed (${OLD}/THE-MAP.md). He read it and said: "not good enough - review and understand why i said so". The coordinator's understanding, which he confirmed with "Yes, redraw it", is in /Users/ren/theories/tmp/r7/WHY-NOT-GOOD-ENOUGH.md: that map showed where laws are filed and how many, not what happens. Read that note, and Ren's words verbatim in /Users/ren/theories/sources/15-codex-theory-conversations/2026-11-08-representation-to-eight.md (the section "I would give it probably just a 4", about lines 102 to 160). His words are the measure.

THE NEW MAP (one page; not landed, not shown to him yet)
  ${SHEET}/shots/lock.png      the page as it opens: the chart on the left, the first path to read on the right
  ${SHEET}/shots/whole.png     the whole map with no path chosen, and its legend
  ${SHEET}/shots/stock.png     the second path chosen
  ${SHEET}/shots/b2-uncounted.png, b1-held.png   one box chosen: its card
  ${SHEET}/shots/lake.png, judge.png, stocks.png   three tests laid on the map
  ${SHEET}/sheet.txt           everything on the page as plain text (9,300 words; the page shows a little of it at a time): every row, box, arrow, both paths, the three tests
  ${SHEET}/data.py, settled.json, stories.py   its data (names and sentences in English and Chinese)
Open the pictures with the Read tool. Look at them before you read the text: a person meets the picture first.

RULES
- No scores, no grades. A grade from an AI reader is worth nothing here.
- Not a list of small defects. Say the few things that matter most, each with what a person can go and look at (the sentence, the box, the picture).
- The question is what a person now sees and can do, against what Ren asked for. Where the new map is good, say so plainly and briefly; where it repeats the old failure in a new form, say that first.
- Where you think Ren's words are wrong, or the map is right against them, say so and argue it.
- Give concrete changes: what to change, where, to what. A change must be something the coordinator can make on this page.
Your final answer is data for the coordinator.`

const R_SCHEMA = {
  type: 'object',
  properties: {
    say_back: { type: 'string', description: 'At most 150 words, in plain words: what a reader comes away with from this map, through your lens.' },
    stands: { type: 'array', maxItems: 5, items: { type: 'string' }, description: 'What is good and should stay, each in one sentence with where it is.' },
    fails: {
      type: 'array', maxItems: 6,
      items: { type: 'object', properties: {
        what: { type: 'string' }, evidence: { type: 'string' }, which_of_rens_words: { type: 'string' },
        change: { type: 'string', description: 'The concrete change: where, and to what.' } },
        required: ['what', 'evidence', 'which_of_rens_words', 'change'] },
    },
    is_it_the_old_failure_again: { type: 'string', description: 'At most 120 words: does this map show what happens, or is it again a filing in another form? Argue from what is on it.' },
    against_ren: { type: 'string', description: 'Where you think Ren is wrong or the map is right against his words; "nothing" if nothing.' },
    detail: { type: 'string', description: 'Whatever your lens asks for beyond the fields above, at most 500 words.' },
  },
  required: ['say_back', 'stands', 'fails', 'is_it_the_old_failure_again', 'against_ren', 'detail'],
}

const READERS = [
  { key: 'cold-reader', model: 'opus', prompt: `
YOUR LENS: a thoughtful person from outside, in the first ten minutes. You know nothing of this project; someone you respect sent you the page.
1. Open lock.png (the page as it opens) and look for a minute. Then whole.png. Then read, in sheet.txt, only what the opening page shows: the lead, the rows and box names, and the first path ("A rule that comes to hold itself"). Do not read more yet.
2. Write your say-back at once: what does it say happens to things? What can you now see or do that you could not before? What would you tell a friend it is?
3. Note where you first stopped following (the exact words), each word you had to learn before going on, and where you would have closed the tab.
4. Does it feel like serious work? Quote what gives or takes away that feeling.
5. Then read the rest of sheet.txt and open the other pictures. In "detail": what a person still cannot get from this map that the account's own one page holds (/Users/ren/theories/theories/becoming/ONE-PAGE.md), and what the first screen should say or show that it does not.` },

  { key: 'with-a-question', model: 'opus', prompt: `
YOUR LENS: a person who comes with a real question and uses the map to answer it. One at a time, as someone who has that problem:
  (a) "Several boats fish one bay. What decides whether the fishery lasts or collapses, and what can keep it?"
  (b) "We train a model against a learned reward (or: my team is paid on a metric) and the number goes up while the thing we wanted gets worse. What is going on, where does it lead, and what would get us out?"
  (c) "What is the meta-attractor, how would humans and AI together fall into it, and what would keep them out?"
For each: start from lock.png / whole.png and use only this map (the pictures and sheet.txt; choosing a box shows its card, which sheet.txt gives under PASSAGES and under each box). Record the path you took, roughly how many words you read, and the answer you could give at the end in your own plain words. Say where the path died, if it did. Did the map let you find where you are, and what comes next from there?
The same three questions were put to the old map; its reader's report is in /Users/ren/theories/tmp/r7/why/reports.json (lens "with-a-question"). In "detail", set the two side by side: for each question, what the old map gave and what this one gives.` },

  { key: 'words-in-both-languages', prompt: `
YOUR LENS: the words, in English and in Chinese, and the concepts they carry.
Ren's words: "don't mention AI so much, don't mention our vocabulary so much"; "a lot of the concepts are still heavily dualistic"; "the words you choose isn't really great, like you use 人 when it is not just about people". The old map answered with names like "what it is of" and 所读者, which no reader took as meant.
1. Read all 14 row names and all 50 box names in both languages (data.py). For each language separately: which names does a native reader take as meant at first meeting, and which not? Read the Chinese as Chinese, not as a rendering of the English: which read as thought in Chinese, which as translated? Give better words where you have them, at most ten per language, each with why.
2. Read thirty passage sentences in both languages (settled.json), the two paths and one test (stories.py). The passage sentences were corrected by second readers against the Lean and some grew heavy. Which can a person outside the project not follow? Give the five worst in each language with a plainer sentence that says no more and no less.
3. Count the words a reader must learn that are the map's own (not ordinary words used ordinarily), on the opening page and in the legend. Name them.
4. Words that fit only a person: the laws hold of anything that goes on, so the names and passage sentences should not use them; an example ("Such as ...") or a test may, since those are cases in their own words. List every breach in names and passage sentences, both languages (人, 谁, 大家, people, someone, anyone, who, members where it means persons).
5. Which splits into two does this map build into its structure, and are they the account's own? Left against right; solid against dashed; "the course itself" against "from beyond the course"; said against seen. Is anything set above the map?
6. How does the page speak about itself and about AI (the note at the bottom, the legend)? Too much, too little, in the right place?` },

  { key: 'rens-whole-list', prompt: `
YOUR LENS: everything Ren has asked for and everything he has said yes to, not only his last message. The last map failed partly because each round answered his latest remark and dropped what he had approved before.
Compile the list yourself from his words, then check the new map against each item. Sources:
- /Users/ren/theories/sources/15-codex-theory-conversations/2026-11-08-representation-to-eight.md, the section from "I would give it probably just a 4" to its end: every sentence of his, and what each yes was a yes to.
- The three notes he read and answered: ${REC}/WHOLE-PICTURE.md ("Yes, start there"; the first prototype, then "Yes, extend it"), ${REC}/DESIGN.md (the second prototype: "good - but not good enough ... on the right direction, definitely better than the first one"), ${REC}/FOUNDATION.md ("Yes, build on it"). Note what each note promised him would stay or would be possible (for example DESIGN.md: the first map's picture can stay; the fifteen names stay; where a case stands; FOUNDATION.md: its six points and "The reading is on the map too").
- /Users/ren/theories/tmp/r7/WHY-NOT-GOOD-ENOUGH.md, which he confirmed, including "Where I would argue with Ren" and "What a good one does".
- AGENTS.md, and /Users/ren/theories/sources/15-codex-theory-conversations/2026-11-09-agents-the-map.md, 2026-11-10-dynamics-connected-mapped-unified.md, 2026-11-10-elegant-and-wise.md, 2026-11-10-traditions-onto-the-map.md.
For each item of your list say: met, met in part, not met, or contradicted, with what on the new map shows it (a box, a sentence, a picture). Put the full table in "detail" (compactly: item, verdict, evidence in a few words). In "fails" put the six that matter most, each with the concrete change.
Also: the first prototype's data is in ${REC}/places/ (15 places, 38 arrows) and the second's in ${REC}/store/. Is everything of them that he said yes to on the new map, under the same or a better name? What was lost?` },

  { key: 'map-and-meeting', prompt: `
YOUR LENS: is it a map, and does it show how reasoning and what is observed stand to each other.
Ren: "I asked you to show the map but you showed some connections between different components"; "something that can show its topology can show the relationship between different things"; "we also want \\"a map\\" not \\"a set of maps\\""; "the map can separate logic and situation, even when one is right, the other could be wrong. and this map can guide us to understand the relationships between reasoning and the actual data(situation/observation), is a very clear goal i want".
1. What kind of diagram is this, in the terms of the craft (a state chart in lanes; a transit map; a table)? What does a node mean, an edge, a position, a row, left against right? Can a person see the whole shape at once, find where they are, see what is next to what, see ways on, ways back, dead ends and blanks? Where is a loop that closes? Where is the meta-attractor? Look at whole.png and lock.png for what the drawing itself shows without the panel.
2. What does the picture show about the account that prose did not? The coordinator counts, among arrows that are not lines: rightward 17 laws, 5 needing something from beyond, 2 built cases; leftward 4 laws, 14 needing something from beyond, 2 built cases. Is that asymmetry visible in the drawing, is it said well, and is it true to the data (settled.json; a passage's direction comes from the columns in data.py)? Is left against right carrying a judgment of better and worse that the account does not make?
3. The drawing's faults: where is it cluttered or misleading (lines behind boxes, arcs, step numbers, the rows with no arrows yet)? What single change would most improve the first sight?
4. The three tests laid on it (lake.png, judge.png, stocks.png and their text in sheet.txt, written from the records in ${OLD}/cases.json and the experiments' own folders): for each, can a reader see the reasoning, the situation, where they were brought together, and which gave way? Compare with how the old map showed the same test (${OLD}/CASES.md). What is still missing for Ren's goal: for example what the account learned, a rival, or a way to bring a situation of one's own?
5. "One map": the old map was called one map and was eleven boxes; this is fourteen rows. Is this one map? The rows are meant to be the ties of one web (${OLD}/web.json; the round's FOUNDATION.md). Does the page let a reader see that, and should it?` },

  { key: 'truth-of-the-stories', prompt: `
YOUR LENS: the truth of what has not yet been checked. The passages were set against the Lean by second readers (their verdicts: ${SHEET}/verified.json). These were not:
1. THE THREE TESTS (${SHEET}/stories.py, CASES): each was written by the coordinator from ${OLD}/cases.json. Set each against the test's own record: find the experiment folders through /Users/ren/theories/TESTS.md (IN1: experiments/direction-installation; LA2; MQ3) and read their READMEs, frozen predictions and results. For every sentence of each test (the situation, each pin with its "seen", what the reasoning said, what was seen, what gave way, what followed, what else would give the same): is it true to the record? Is each pin on the right box, given the box's meaning in data.py? Is "seen as the reasoning said / not / in part" right for each pin? Give the corrected sentence, English and Chinese, where one is wrong.
2. THE TWO PATHS (stories.py, PATHS): the leads, the order of steps, and above all the two statements under "What this path shows" and the statement of what the work wants. Are they supported by settled.json and verified.json (the second readers' notes on closing against opening are in verified.json under "notes")? Do they say more than was found, or less?
3. THE PAGE'S NOTE ON ITSELF (the "about" text in ${SHEET}/template.html, both languages) and the lead under the title: is each number and each claim true? (For example: that every passage drawn was set against its Lean statement; how many conditions are tied to the Lean; 321 exits and 103 transitions; 66 tests.)
4. THE FAMILIAR NAMES ("Also known as" in data.py): each is meant to be a reading the account or its crosswalk already makes (/Users/ren/theories/theories/becoming/results/atlas/entries/correspondences.json; ONE-PAGE.md "The evidence"). Is each one there, and on the right box?
5. Whether the picture's main claim can mislead: a solid arrow says "a law shows the course itself doing this". Take the five solid arrows a reader is most likely to take as a claim about the world, and say for each what a person will take it to mean and what the law, on its model and under its conditions, supports.
Put corrected texts in "detail" where they do not fit in "fails".` },
]

// ---------------------------------------------------------------- write and check the lower bands
const W_BRIEF = (g) => `
You write passages for part of a new map of "the theory of becoming", from the account's own laws. Read only: change no file, run no test or build, no git command that writes.

THE MAP
An earlier map filed the account's theorems and counted them; a reader could not see what happens. The new map shows what happens: each ROW asks one thing of anything that goes on; each CONDITION is one way the answer can stand; each PASSAGE is a way from one condition to another, drawn by how far it has been seen. The whole vocabulary (14 rows, 50 conditions) is in ${SHEET}/vocabulary.json. The passages already written and checked for the upper rows are in ${SHEET}/settled.json: read twenty of them to get the register.

YOUR PART
${SHEET}/settle-${g}.json holds the rows and conditions of your part, the passages already settled there, and "items": every exit and transition of the atlas that two earlier readers placed on or near these conditions, each with its Lean law, its strength, the atlas's sentence, and where each reader put it (they used their own names for places; the ids were mapped to this map's conditions and may be wrong).
The Lean sources are in ${LEAN}/ (find a theorem with grep -rn "theorem .*<name>"; read its statement and docstring). The atlas: /Users/ren/theories/theories/becoming/results/atlas/entries/dynamics.json. For many laws ${OLD}/cards.json has a plain sentence already checked against the Lean, with the statement as "evidence".

WHAT TO WRITE
For each pair of conditions (within your rows, or from one of your conditions to any condition of the map) that the laws speak of, one passage, or two where the laws show two different ways:
- kind:
   "law": a general theorem shows the course itself making this passage (sufficient, or exact one way), from premises that belong to the from-condition or to the model.
   "line": a theorem says exactly on which side of the two conditions a course stands; not by itself a statement that anything moves across.
   "needs": the laws give only what the passage needs: a necessary condition, or a theorem whose premise is that something the model holds fixed is changed from outside the course (another rule, a giver from beyond, something told or shown from outside).
   "built": only a constructed example or witness shows it can happen.
   "reading": no theorem states it; write one only where the account itself makes that reading, and say so.
   "same": the two conditions are the same thing seen from two rows.
- a sentence in English of at most 40 words and its Chinese: what happens and under what, in plain words a person outside the project understands; no Lean identifiers, symbols or formulas. The laws hold of anything that goes on, so use no word that fits only a person (not people, someone, anyone, who; in Chinese no 人, 谁, 大家). Use the map's words: a view, what it is of, what takes, what gives back, what lives on it, what carries it, the rest. Write the Chinese as thought in Chinese, plain and short.
- the laws that carry it (full names, as Becoming.X.y), and the Lean statement in a few plain words.
Do not write a passage for every item: several items often carry one passage, and some items belong to no passage (they say what holds a condition in place: give those under "stays", one sentence per condition). Do not repeat a passage already settled unless you add a different way.
Also say, for each condition of your part, whether its one-sentence gloss is true to the laws (correct it only where wrong) and which Lean predicates or definitions state it. And say what is NOT there: which passages a reader would expect between your conditions for which the laws give nothing (at most six, one line each). Ways back and ways out matter as much as ways on; write what the laws show, not what would look balanced.`

const W_SCHEMA = {
  type: 'object',
  properties: {
    passages: { type: 'array', items: { type: 'object', properties: {
      from: { type: 'string' }, to: { type: 'string' }, kind: { type: 'string', enum: ['law', 'line', 'needs', 'built', 'reading', 'same'] },
      en: { type: 'string' }, zh: { type: 'string' }, laws: { type: 'array', items: { type: 'string' } }, statement: { type: 'string' } },
      required: ['from', 'to', 'kind', 'en', 'zh', 'laws', 'statement'] } },
    stays: { type: 'array', items: { type: 'object', properties: {
      at: { type: 'string' }, en: { type: 'string' }, zh: { type: 'string' }, laws: { type: 'array', items: { type: 'string' } } },
      required: ['at', 'en', 'zh', 'laws'] } },
    conditions: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string' }, verdict: { type: 'string', enum: ['keep', 'fix'] }, says_en: { type: 'string' }, says_zh: { type: 'string' },
      anchors: { type: 'array', items: { type: 'string' } }, why: { type: 'string' } },
      required: ['id', 'verdict', 'says_en', 'says_zh', 'anchors', 'why'] } },
    not_there: { type: 'array', maxItems: 6, items: { type: 'string' } },
    notes: { type: 'string' },
  },
  required: ['passages', 'stays', 'conditions', 'not_there', 'notes'],
}

const C_BRIEF = (g, written) => `
You are a second reader. Set each passage below against the Lean statements it cites and correct it. Read only: change no file, run no test or build, no git command that writes.

The passages are for a new map of "the theory of becoming": each ROW asks one thing of anything that goes on; each CONDITION is one way the answer can stand (the whole vocabulary: ${SHEET}/vocabulary.json, read it first); each PASSAGE is a way from one condition to another, drawn by how far it has been seen. A first reader wrote these for part "${g}" from the atlas items in ${SHEET}/settle-${g}.json and the Lean.
Lean sources: ${LEAN}/ (grep -rn "theorem .*<name>", read the statement and docstring). ${OLD}/cards.json has, for many laws, a plain sentence already checked against the Lean with the statement as "evidence".

FOR EACH PASSAGE AND EACH "STAY"
1. Is each named law real and the right one? Name the laws that carry it (Becoming.X.y).
2. Does the sentence say what the Lean statement says: direction, quantifiers (every course or some; from any start or a given one; a bound or an exact line), every condition the theorem needs? It may leave out a formula; it may not say more than was proved, nor less in a way that changes the sense.
3. Is the kind right? "law": a general theorem shows the course itself making the passage. "line": a theorem says exactly on which side a course stands, with nothing shown to move across. "needs": only a necessary condition, or a premise that something the model holds fixed is changed from outside the course. "built": only a constructed case. "reading": no theorem. "same": one thing seen from two rows.
4. Do "from" and "to" fit the conditions' meanings? If not, where does it belong, or nowhere.
Then give each as it should stand: verdict keep, fix, move or drop; kind; the sentence in English (at most 40 words) and Chinese, plain, with no word that fits only a person (no people, someone, anyone, who; no 人, 谁, 大家), no Lean identifiers; the laws. If the first reader's sentence is right, keep it word for word.
Also check each corrected gloss of a condition, and add at most four passages the laws clearly show among these conditions that the first reader missed.

THE FIRST READER'S WORK
${JSON.stringify(written)}`

const C_SCHEMA = {
  type: 'object',
  properties: {
    passages: { type: 'array', items: { type: 'object', properties: {
      from: { type: 'string' }, to: { type: 'string' }, verdict: { type: 'string', enum: ['keep', 'fix', 'move', 'drop'] },
      new_from: { type: 'string' }, new_to: { type: 'string' },
      kind: { type: 'string', enum: ['law', 'line', 'needs', 'built', 'reading', 'same'] },
      en: { type: 'string' }, zh: { type: 'string' }, laws: { type: 'array', items: { type: 'string' } }, why: { type: 'string' } },
      required: ['from', 'to', 'verdict', 'kind', 'en', 'zh', 'laws', 'why'] } },
    stays: { type: 'array', items: { type: 'object', properties: {
      at: { type: 'string' }, verdict: { type: 'string', enum: ['keep', 'fix', 'drop'] }, en: { type: 'string' }, zh: { type: 'string' }, laws: { type: 'array', items: { type: 'string' } }, why: { type: 'string' } },
      required: ['at', 'verdict', 'en', 'zh', 'laws', 'why'] } },
    conditions: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string' }, verdict: { type: 'string', enum: ['keep', 'fix'] }, says_en: { type: 'string' }, says_zh: { type: 'string' },
      anchors: { type: 'array', items: { type: 'string' } }, why: { type: 'string' } },
      required: ['id', 'verdict', 'says_en', 'says_zh', 'anchors', 'why'] } },
    missing: { type: 'array', maxItems: 4, items: { type: 'object', properties: {
      from: { type: 'string' }, to: { type: 'string' }, kind: { type: 'string', enum: ['law', 'line', 'needs', 'built', 'reading', 'same'] },
      en: { type: 'string' }, zh: { type: 'string' }, laws: { type: 'array', items: { type: 'string' } }, why: { type: 'string' } },
      required: ['from', 'to', 'kind', 'en', 'zh', 'laws', 'why'] } },
    notes: { type: 'string' },
  },
  required: ['passages', 'stays', 'conditions', 'missing', 'notes'],
}

const GROUPS = ['view', 'between', 'ways-general']

const [reads, filled] = await Promise.all([
  parallel(READERS.map(r => () =>
    agent(COMMON + r.prompt, { label: `read:${r.key}`, phase: 'Read', schema: R_SCHEMA, ...(r.model ? { model: r.model } : {}) })
      .then(x => x ? { lens: r.key, ...x } : null))),
  pipeline(GROUPS,
    g => agent(W_BRIEF(g), { label: `write:${g}`, phase: 'Write', schema: W_SCHEMA, model: 'opus' }),
    (written, g) => written
      ? agent(C_BRIEF(g, written), { label: `check:${g}`, phase: 'Check', schema: C_SCHEMA }).then(c => ({ group: g, written, checked: c }))
      : { group: g, written: null, checked: null }),
])
const rd = reads.filter(Boolean)
log(`${rd.length} of ${READERS.length} readers returned; ${filled.filter(x => x && x.checked).length} of ${GROUPS.length} bands written and checked`)
return { reads: rd, filled }
