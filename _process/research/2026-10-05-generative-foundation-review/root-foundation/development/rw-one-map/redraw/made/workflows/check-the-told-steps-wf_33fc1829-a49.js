export const meta = {
  name: 'check-the-told-steps',
  description: 'One second reader sets the told steps of the two paths, and the page lead, against the arrows they stand on',
  phases: [{ title: 'Check', detail: 'the told steps against their arrows' }],
}
const SHEET = '/Users/ren/theories/tmp/r7/sheet'
phase('Check')
const r = await agent(`
Read only: change no file, run no test, build or render, and no git command that writes.
A new map of "the theory of becoming" (repository /Users/ren/theories) is about to be shown to Ren, whose work it is. Its arrows each have a full sentence that a reader set against the Lean statement of the law behind it. On top of those, the coordinator has just written, by hand and fast, the STEPS of two paths to read: each step is one or two plain sentences ("say_en", "say_zh") told as what happens, standing on one or two arrows or on a box. These told steps are the first thing Ren will read, and no second reader has seen them.

Files:
- ${SHEET}/stories.py : PATHS. Each step has say_en, say_zh, and names what it stands on: 'c' (a box id), 'p' (an arrow, [from, to]), 'also' (a second arrow; [x, x] means the box's staying law). Steps are numbered through the sections of a path in order, from 1. Each path also has lead_en/lead_zh, the lines under shows_en/shows_zh (which cite step numbers) and want_en/want_zh.
- ${SHEET}/built.json : "passages" (each with from, to, key "from>to", kind, tag_en, tag_zh, en, zh, more), "stays" (staying laws by box), "conds" (boxes with their names and sentences). The kind of an arrow is one of: law (proved of the course itself, under its condition), line (proved: a boundary saying which side a thing is on; nothing shown to move), needs (proved only with something given from outside the course, or only a necessary condition), built (shown only in a built example), reading (not proved), same (one box is a case of the other).
- ${SHEET}/template.html : in its script, function labels sets the page lead (#lead) in both languages; T.en/T.zh hold the small markers shown on a step ("needs something given from outside", "built example only", "a reading, not proved"). A step shows a marker when its first arrow is needs, built or reading; unmarked steps are announced as "proved, each under its condition".
- ${SHEET}/sheet.txt : everything on the page as text, if useful.
Where a sentence's truth turns on the law itself, open the Lean: /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ (grep -rn "theorem .*<name>").

For every step of both paths (17 and 15), set the told step against the full sentences of the arrows or box it stands on:
1. Does it say anything the arrows' sentences do not, or more than they do (a condition dropped so that it reads as always so; "is" where the sentence has "can"; a built example or a reading told as a general fact; a boundary told as a movement)? A told step may be shorter and plainer and may leave out a formula; it may not change the sense.
2. Given that an unmarked step is announced as proved: is any unmarked step standing, in whole or in part, on an arrow that is needs, built or reading, or on a single-reader arrow, in a way that makes the announcement false for what the step says? Say which sentence of the step.
3. Is it plain to a person outside the project, in each language? Is the Chinese natural Chinese? Does it use a word that fits only a person where the law is about anything (no people, someone, anyone, who; no 人, 谁, 大家)? Examples ("Such as ...") and tests are exempt.
Also check the page lead in both languages the same way against the path it summarises, and the step numbers cited in the "shows" lines.
Return only what should change: the corrected say_en and say_zh for a step (give both, whole), or the corrected lead, each with one line of why. Then say in two or three sentences what a reader who reads only the told steps of the first path, and nothing else, would come away believing, and whether that is true to the account.`,
  { label: 'check:told-steps', phase: 'Check', schema: { type: 'object', properties: {
      steps: { type: 'array', items: { type: 'object', properties: { path: { type: 'string' }, step: { type: 'integer' }, say_en: { type: 'string' }, say_zh: { type: 'string' }, why: { type: 'string' } }, required: ['path', 'step', 'say_en', 'say_zh', 'why'] } },
      lead: { type: 'object', properties: { change: { type: 'boolean' }, en: { type: 'string' }, zh: { type: 'string' }, why: { type: 'string' } }, required: ['change', 'en', 'zh', 'why'] },
      other: { type: 'array', maxItems: 6, items: { type: 'string' } },
      comes_away_believing: { type: 'string' } },
    required: ['steps', 'lead', 'other', 'comes_away_believing'] } })
return r
