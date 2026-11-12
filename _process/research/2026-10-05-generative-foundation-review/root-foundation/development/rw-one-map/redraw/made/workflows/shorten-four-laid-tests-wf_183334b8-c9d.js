export const meta = {
  name: 'shorten-four-laid-tests',
  description: 'Shorten the four newly laid tests to the grain of the first three; a second reader sets each short version against the checked long one and the record',
  phases: [
    { title: 'Shorten', detail: 'one writer per test', model: 'opus' },
    { title: 'Check', detail: 'one second reader per test, against the long version and the record' },
  ],
}
const KIT = '/Users/ren/theories/tmp/r7/sheet/v2'
const TESTS = args
const LIM = { what: 70, said: 60, seen: 90, broke: 100, after: 60, rival: 50, pin: 20, pin_seen: 30 }
const FIELDS = ['what', 'said', 'seen', 'broke', 'after', 'rival']
const props = {}
for (const f of FIELDS) { props[f + '_en'] = { type: 'string' }; props[f + '_zh'] = { type: 'string' } }
const SCHEMA = {
  type: 'object',
  properties: Object.assign({
    id: { type: 'string' },
    pins: { type: 'array', items: { type: 'object', properties: {
      en: { type: 'string' }, zh: { type: 'string' }, short_en: { type: 'string' }, short_zh: { type: 'string' }, seen_en: { type: 'string' }, seen_zh: { type: 'string' } },
      required: ['en', 'zh', 'short_en', 'short_zh', 'seen_en', 'seen_zh'] } },
    notes: { type: 'string' },
  }, props),
  required: ['id', 'pins', 'notes'].concat(FIELDS.flatMap(f => [f + '_en', f + '_zh'])),
}
const COMMON = `
This is reading and writing only. Do not run tests, builds, renders or anything heavy; do not change any file. Small read-only scripts that print from JSON are fine.

The map. ${KIT}/data/sheet.json holds rows and boxes (a box is one way a row's question can stand), ${KIT}/data/passages.json the arrows, ${KIT}/data/laid.json the tests laid on the map. A laid test says: the situation (what_*), what the reasoning said beforehand (said_*), what was seen (seen_*), then its pins (each pin: something in the situation taken as one box; "en"/"zh" say what was taken as that box, "seen_en"/"seen_zh" what was seen there, "short_en"/"short_zh" a label of a few words drawn beside the box), then what gave way (broke_*: where the reasoning and the situation came apart, and whether it was the law or the pairing of the situation with the boxes that gave), what was done after (after_*), and the other account that fits (rival_*).

The reader is a person who has never seen this work. Ren, who directs it, read the earlier pages and said: too many words, too much of our own vocabulary, hard for a human to read. The first three tests in laid.json (ids lake, judge, stocks) have the grain he read and accepted: look at them as the model for length and plainness.

The four newer tests (ids season, patch, harvest, checkedonce) are true to their records but three to five times too long. They must come down to the same grain.

Limits, in English words (Chinese: the same content, plain modern Chinese, not word for word, about as short): the situation ${LIM.what}; what the reasoning said ${LIM.said}; what was seen ${LIM.seen}; what gave way ${LIM.broke}; after ${LIM.after}; the other account ${LIM.rival}; a pin's "en" ${LIM.pin}; a pin's "seen_en" ${LIM.pin_seen}; a pin's short label at most 5 words. Keep the pins in the same order and the same number; do not change which box a pin is at.

What to keep, in this order of importance:
1. How far each thing was seen. "Not contradicted" is never "confirmed"; "untestable", "unresolved", "post hoc", "a conjecture, not a proved law", "one seed", "an AI reading" stay where the record has them. A short text that reads stronger than the record is wrong.
2. What was taken as which box, and what gave way: the law, or the pairing of the situation with the boxes. Say it plainly.
3. The one or two numbers that carry the finding. Drop the rest: a reader who wants every number opens the record.
Drop: prediction codes (P1, P6), arm and family names where a plain phrase does, parameter lists, anything said twice.
Plain words: no symbols, no jargon where an ordinary word does, no dashes used as punctuation, no "robust", "significant", "crucial". Sentences a person can read once. Do not address the reader.`

phase('Shorten')
const out = await pipeline(
  TESTS,
  (t) => agent(`You are shortening one test laid on a map, for a human reader.
${COMMON}

Your test: id "${t.id}" (${t.test}) in ${KIT}/data/laid.json. Read it whole, with its pins. Read the three model tests. Then read the record itself so that you shorten from what happened and not only from the long text; the second reader's notes for this test name the record's files: they are in ${KIT}/fill-tests.json under tests[${t.index}].checked.notes.

Write the short version: every field in English and Chinese, and every pin. Return it, with "id" set to "${t.id}" and in "notes" one line per field saying what you left out.`, { label: 'shorten:' + t.id, phase: 'Shorten', schema: SCHEMA, model: 'opus' }),
  (short, t) => short && agent(`You are the second reader of a shortened test laid on a map. A first writer cut a long, checked text down to about a quarter. Cutting is where a text comes to say more than was seen, or to leave out the one condition that made it true. Your work is to find where that happened and repair it.
${COMMON}

The test: id "${t.id}" (${t.test}). The long checked version is in ${KIT}/data/laid.json; its checker's notes, naming the record's files and line numbers, are in ${KIT}/fill-tests.json under tests[${t.index}].checked.notes. Open the record itself for every number and every "how far" you check.

The short version to check:
${JSON.stringify(short, null, 1)}

For each field and each pin, in both languages:
- Is every statement true to the record? Is each number right and attached to the right thing?
- Does it read stronger than the record (a conjecture told as a law, "not contradicted" told as support, an untestable or unresolved prediction dropped so that the rest reads as a clean pass)?
- Does it say plainly what gave way, the law or the pairing?
- Does the Chinese say the same as the English?
- Is it within the limits, and can a person who has never seen this work read it once and follow it?
Repair what is wrong, within the limits (a limit may be passed by a few words where the truth needs them; say so). Return the whole final version, "id" "${t.id}", and in "notes" what you changed and why, and what you checked against which file.`, { label: 'check:' + t.id, phase: 'Check', schema: SCHEMA }).then(c => ({ id: t.id, test: t.test, short, checked: c }))
)
const wc = s => (s || '').trim().split(/\s+/).filter(Boolean).length
for (const r of out.filter(Boolean)) {
  const c = r.checked; if (!c) { log(r.id + ': not checked'); continue }
  const over = FIELDS.filter(f => wc(c[f + '_en']) > LIM[f] * 1.25).map(f => f + '=' + wc(c[f + '_en']))
  log(r.id + ': ' + FIELDS.map(f => wc(c[f + '_en'])).join('/') + (over.length ? ' over: ' + over.join(', ') : ''))
}
return { tests: out }
