export const meta = {
  name: 'one-map-place-dynamics',
  description: 'Place each of the 183 dynamics on the one web (its roles, ties and principal laws in role-words, read from the Lean), then a second reader tries to refute each card',
  phases: [{ title: 'Place', detail: 'one reader per batch of dynamics writes their cards from the Lean statements' }, { title: 'Refute', detail: 'a second reader checks each card against the statements and the wording rules' }],
}

const CONTEXT = `
THE WORK. /Users/ren/theories (branch main): a theory of how anything begins, lasts, changes and ends, proved in Lean on models. Its atlas (theories/becoming/results/atlas/entries/) holds dynamics.json (183 "dynamics" in families A to H: each one proved result's mechanism, with exits, transitions, compose entries and a "premises" list giving each Lean law's ledger premises as "takes") and premises.json (the ledger: every premise's name and plain statement). The Lean is under experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/. Record pages are theories/becoming/results/records/<id>.md.

WHAT IS BEING BUILT. ONE MAP of the whole account, on a foundation its director approved: /Users/ren/theories/tmp/r7/FOUNDATION.md (read it whole first). In short: the ground is ONE WEB of a few kinds of role and tie; the unit is a STATEMENT about a role or a tie under a named sameness (that it begins, lasts, changes or ends, or that one amount is at least another; when; on which courses); a LAW says statements in general, in its model's own roles; a case says them in particular, in its own words; they meet in a bridge. The kinds are in /Users/ren/theories/tmp/r7/map/web.json: 12 roles (a role is a place in a tie, not a thing), 12 ties (each a kind with two ends, which can hold between whatever roles the law speaks of), the marks, the forms of a law and the frames. Read that file whole.

YOUR UNIT IS A DYNAMIC'S CARD. For each dynamic in your batch (/Users/ren/theories/tmp/r7/map/batches.json, the entry whose "id" is yours), read its entry in dynamics.json in full (mechanism, exits, transitions, compose, premises, open, beyond), its record page, and the STATEMENT and docstring (not the proof) of each law you write up (grep the declaration's short name under the Lean directory). Then write:
- plain_en, plain_zh: ONE sentence, at most 30 words, saying what the dynamic shows, so that a person with no knowledge of the theory understands it.
- legend: true where the dynamic's laws hold of every course, every process or every relation and name no roles (what staying in a region or leaving it means; a calibration; a counting identity). Such a dynamic belongs to the map's legend; give it cast [{role: "any", ...}] and no ties.
- cast: which of the 12 role kinds its laws speak of, each with "as": the model's own word for what fills it (carriers, the share, a formation, a condition's level, the pool ...) and the Lean type or predicate where there is one.
- ties: which tie kinds its laws are about, each with the two role kinds it holds between here ("from", "to"; a tie may hold between other roles than web.json's default ends) and "as": the model's own words for it.
- laws: the dynamic's PRINCIPAL laws, at most six: (a) the one to three laws its mechanism sentence states as its main result; (b) then the laws its exits and transitions cite whose strength is exact, sufficient or necessary. For each:
  lean (full name); items (the exits / transitions / compose entries that cite it, as "exit 1"; empty for a mechanism law);
  about: the index (0-based) in YOUR ties list of the tie its CONCLUSION speaks of, or -1 with about_role set to a role kind where it speaks of a role itself (a stock's level; a dependent going on);
  sameness: the respect it speaks under, in a few plain words ("locked or not", "level at or above the need", "active or not");
  form: tie | border | alike | order | same-as | shows | cannot (web.json's forms). A threshold or an iff in amounts or times is a border; a law that two courses differing only somewhere go alike is alike;
  mark: for form tie, which of begins | lasts | changes | ends | absent the conclusion states; else "";
  frame: one-course | two-courses | best-open | every-course | built-case;
  then_en, then_zh: the CONCLUSION in at most 24 words, with its extent (at the next step, from then on, for good, on every course), in role-words;
  compare_en: for a border or a threshold, what is compared with what, in plain words; else "";
  main_ifs: up to four ledger premise ids from this law's "takes" that carry its condition (leave out the model's standing premises such as natural-number amounts or decidedness);
  by_outside: true where the law is an exit that DROPS a premise: it says what follows IF something the dynamic's other laws take as given were different, not that it comes to be different;
  strength: exact | sufficient | necessary for a general law (the atlas's word for an item; for a mechanism law "exact" for an iff, else "sufficient");
  evidence: the key line of the Lean statement, with the file.
- built_cases: up to three witnesses worth showing (a constructed example: it shows something can happen and gives no condition), each with lean and shows_en (at most 20 words).
- misfit: what in this dynamic the kinds cannot hold, briefly; "" if nothing.

WORDS (the director's correction; these rules are strict).
- A law's sentence uses ROLE-WORDS ONLY: web.json's role and tie names and the model's own terms (carriers, the others, the share, the lock, readers, the pool, a stock, its level, a need, the margin, the loss beyond). The laws are proved for any type. Never write them in the words of one situation: no people, no "those ahead", "those with a say", "everyone", "someone", "judges", "voters", "winners"; in Chinese never 人 or 谁 for a role.
- One verb for one relation: reads (what couples into a rule or a reading; never "registers", "counts", "notices", "can tell", "feels"); draws on; gives back; needs; depends on; selects; favours; is set from. The lock is "the lock" (锁定), not "the hold". Steps are steps (步), not rounds.
- The four are begins, lasts, changes, ends (生 住 异 亡); say the extent each time, and for "ends" which end (stops here; from some step on; for good; on every course). "Changes" means it goes on under one sameness and differs under a finer one: say both.
- Say no more than the statement: write "exactly where" only for an iff; a witness is "in one built case"; keep "some course" and "every course" apart.
- Chinese: plain modern Chinese by ear, short; a short noun for a role (依者, 取用者, 读取者, 其余), not a clause copied from English; the account's own short words where it has them (生 住 异 亡, 延, 尽, 缘, 及, 不及, 取, 给, 传, 守, 锁定, 份额).

BE STRICT WITH THE LEAN. Read each statement; do not type from the atlas sentence alone. Where a law fits no form or no kind, say so in misfit and choose the nearest honestly; do not bend the law.

READ ONLY: change nothing in the repository, write no files, run no tests, builds, renders or gates; small read-only python3 -B or grep is fine.
`

const LAW = { type: 'object', properties: {
  lean: { type: 'string' }, items: { type: 'array', items: { type: 'string' } },
  about: { type: 'integer' }, about_role: { type: 'string' }, sameness: { type: 'string' },
  form: { type: 'string', enum: ['tie', 'border', 'alike', 'order', 'same-as', 'shows', 'cannot'] },
  mark: { type: 'string' }, frame: { type: 'string', enum: ['one-course', 'two-courses', 'best-open', 'every-course', 'built-case'] },
  then_en: { type: 'string' }, then_zh: { type: 'string' }, compare_en: { type: 'string' },
  main_ifs: { type: 'array', items: { type: 'string' } }, by_outside: { type: 'boolean' },
  strength: { type: 'string' }, evidence: { type: 'string' } },
  required: ['lean', 'items', 'about', 'form', 'mark', 'frame', 'then_en', 'then_zh', 'main_ifs', 'by_outside', 'strength', 'evidence'] }
const CARD = { type: 'object', properties: {
  dynamic: { type: 'string' }, plain_en: { type: 'string' }, plain_zh: { type: 'string' }, legend: { type: 'boolean' },
  cast: { type: 'array', items: { type: 'object', properties: { role: { type: 'string' }, as: { type: 'string' }, lean: { type: 'string' } }, required: ['role', 'as'] } },
  ties: { type: 'array', items: { type: 'object', properties: { tie: { type: 'string' }, from: { type: 'string' }, to: { type: 'string' }, as: { type: 'string' } }, required: ['tie', 'from', 'to', 'as'] } },
  laws: { type: 'array', items: LAW },
  built_cases: { type: 'array', items: { type: 'object', properties: { lean: { type: 'string' }, shows_en: { type: 'string' } }, required: ['lean', 'shows_en'] } },
  misfit: { type: 'string' } },
  required: ['dynamic', 'plain_en', 'plain_zh', 'legend', 'cast', 'ties', 'laws', 'built_cases', 'misfit'] }
const PLACED = { type: 'object', properties: { batch: { type: 'string' }, cards: { type: 'array', items: CARD }, about_the_kinds: { type: 'string' } }, required: ['batch', 'cards'] }
const REFUTED = { type: 'object', properties: { batch: { type: 'string' },
  verdicts: { type: 'array', items: { type: 'object', properties: { dynamic: { type: 'string' }, verdict: { type: 'string', enum: ['keep', 'fix'] }, why: { type: 'string' }, fixed: CARD }, required: ['dynamic', 'verdict', 'why'] } },
  about_the_kinds: { type: 'string' } }, required: ['batch', 'verdicts'] }

const results = await pipeline(
  args,
  b => agent(CONTEXT + `\nYOUR BATCH: "${b}". Write one card for each of its dynamics.`, { label: `place:${b}`, phase: 'Place', schema: PLACED }),
  (placed, b) => placed ? agent(CONTEXT + `\nYOU ARE THE SECOND READER for batch "${b}". Another reader wrote these cards:\n\n${JSON.stringify(placed.cards, null, 1)}\n\nFor EACH card, read the dynamic's entry and the Lean statements yourself and try to refute it. Cast and ties: is each role and tie kind the right one for what the model has, and are the two ends of each tie right? Is a dynamic of every course wrongly given roles, or the reverse? Laws: are these the principal ones (the mechanism's main result first)? Is "about" the tie or role the CONCLUSION speaks of? Is the form right (a border typed as a tie? an alike-law typed as "lasts"?), the mark, the frame (does the law compare two courses? speak of the best of what is open?), by_outside? Does then_en say what the statement concludes, with its extent, no more and no less? Are main_ifs really among the law's takes and the ones that carry its condition? Is the strength copied, never raised? WORDS: is any sentence written in one situation's words (people, "those ahead", "someone", 人, 谁), with a verb the rules forbid (registers, counts, notices, feels), or "hold" for the lock, "round" for a step? Is the Chinese short and native? Is plain_en true to the dynamic and plain to a stranger? Verdict "keep" where you could not break the card; "fix" with the COMPLETE corrected card in "fixed". Default to "fix" when unsure.`,
    { label: `refute:${b}`, phase: 'Refute', schema: REFUTED }).then(r => ({ batch: b, placed, refuted: r })) : { batch: b, placed: null, refuted: null },
)
return { results: results.filter(Boolean) }
