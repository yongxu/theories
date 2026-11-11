export const meta = {
  name: 'store-v2-retype',
  description: 'Re-type every law of the first region into the question store: one row per Lean law, read from its statement, then a skeptic tries to refute each row',
  phases: [{ title: 'Type', detail: 'one reader per dynamic writes the law rows from the Lean statements' }, { title: 'Refute', detail: 'a skeptic per dynamic checks each row against the statement' }],
}

const CONTEXT = `
THE WORK. /Users/ren/theories (branch main): a theory proved in Lean, with an atlas of 183 "dynamics" (theories/becoming/results/atlas/entries/dynamics.json: each one proved result's mechanism, with exits, transitions, compose entries, and a "premises" list giving for each Lean law the ledger premises it takes; the ledger is entries/premises.json). A first map of one region was drawn from a flat list of 15 "places" with arrows between them (/Users/ren/theories/tmp/r7/places/places-v1.json and decisions.json: 88 items each settled against its Lean statement). Six independent designers then showed that flat store is dominated: places overlap because they are combinations of a few independent distinctions, and "arrow between two places" was made to carry five different kinds of law (a border between two answers where nothing moves; a keeping; a change the course itself makes; a change that needs something the law takes as given to be altered; a single built example).

THE NEW STORE. /Users/ren/theories/tmp/r7/store/questions.json holds, for this region: a cast of six roles; ELEVEN QUESTIONS, each one distinction a law draws about a relation among the cast, with two to four ANSWERS (each with a "test" and its Lean predicates and ledger premise ids); and the places as named sets of answers. Read the whole file first. A LAW becomes one ROW on one question.

A ROW (one per Lean law):
- lean: the declaration's full name. items: the exits / transitions / compose entries of the dynamic that cite it ("exit 1", "transition 2", "compose 1"); empty for a mechanism law that no item cites.
- on: the ONE question whose answer the law's CONCLUSION speaks of. If the conclusion speaks of two, give the one the law is mainly about and put the other in "also" as {question, from, to}.
- shape: "keeps" (the conclusion is that an answer stays, from then on or for a stretch) | "moves" (a course goes from one answer to another in time; "from any start" counts, with from = "any") | "line" (an iff or threshold saying which side of a comparison holds, with no step at which anything crosses) | "same-as" (an identity that puts one model's quantity onto another's question: a compose entry with a joint law) | "none" (the law fits no question here; say why in unplaced_why and what would be needed in needs).
- from, to: answer ids of that question ("any" allowed for from). For a keeps, from = to. For a line, the two sides.
- fork: where one exact law decides between two outcomes, the OTHER outcome as {to, measure}; else null.
- given: {question: answer} for every OTHER question whose answer the law's HYPOTHESES fix. Read this from the Lean statement's hypotheses and from the law's "takes" premises in the dynamic's "premises" list (match them to the answers' premise ids where you can), not from the atlas's sentence. Leave a question out where the statement is silent on it.
- by: "itself" (the course does it, under the law's hypotheses) | "chance" (members replaced or drawn by chance; a bound on weight) | "outside" (the conclusion follows only where something the dynamic's other laws take as fixed is different: the exit DROPS a premise; a law of the form "if the rule comes to count it, then..." shows what follows, not that the rule comes to count it) | "none" (a line).
- measure {en, zh}: what the model compares, in at most 25 plain words, where the gate is a quantity of the model (who outnumbers whom at which round; cost against return; a bound on rounds). Everyday words: rule, those ahead, the others, those with a say, what is used up, rebuilding, round. Not: share, carrier, formation, course, reads, couples, selection in their technical senses. Chinese in plain modern Chinese by ear.
- within: when the conclusion holds, plainly ("from then on", "by the round after the second rebuilding", "at the next round", "while ... lasts").
- plain {en, zh}: one sentence, at most 28 words, saying what the law shows so that a person with no knowledge of the theory understands it.
- strength: for an item, the atlas's own word (exact | sufficient | necessary | witness), or "reading" / "open" where no law shows it; for a mechanism law, "exact" for an iff, else "sufficient", or "witness" for a constructed example. Never upgrade. A witness is one built example: it shows something can happen and gives no condition for it.
- reach: the dynamic's "base" (any type, any process, the World, a named model...). module: the Lean namespace the declaration sits in (for example Becoming.ClosedCapture.Thinned).
- drops: the ledger premise ids the exit drops (copy from the entry), else [].
- evidence: the key line of the Lean STATEMENT (not the proof), with the file. Find it by grepping the declaration's short name under experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ .
- unplaced_why, needs: for shape "none", or where you had to stretch a question.

WHICH LAWS. (1) Every law cited by an item of the dynamic: the earlier decision for each item is in decisions.json (fields dynamic, item, decision, from, to, place, condition_en, strength, law, evidence); use it as a starting point and re-type it. Where two items cite the same law, write ONE row and list both items. Where one iff was split into two arrows, write one row with a fork. (2) Up to five MECHANISM laws of the dynamic that no item cites but that say an answer is kept, arrived at, or absorbed (for example the law that says a held rule stays held, or that any start is held after two rebuildings): take them from the entry's "mechanism" sentence and "declarations". (3) Nothing else.

BE STRICT. given and on must be what the STATEMENT says. A wrong given makes every loop computed from this store wrong. Where the statement's hypotheses do not fix an answer, do not put it in given. Where a law is proved on a model that has no such thing as one of the cast (no one with a say; nothing used up), do not answer that question for it. If the question list lacks a distinction the law draws, use shape "none" or the nearest question with a note in needs; do not bend the law to the list.

READ ONLY: change nothing in the repository, write no files, run no tests, builds, renders or gates; small read-only python3 -B or grep is fine.
`

const ROW = {
  type: 'object',
  properties: {
    lean: { type: 'string' }, items: { type: 'array', items: { type: 'string' } },
    on: { type: 'string' }, shape: { type: 'string', enum: ['keeps', 'moves', 'line', 'same-as', 'none'] },
    from: { type: 'string' }, to: { type: 'string' },
    fork: { type: ['object', 'null'], properties: { to: { type: 'string' }, measure: { type: 'string' } } },
    also: { type: 'array', items: { type: 'object', properties: { question: { type: 'string' }, from: { type: 'string' }, to: { type: 'string' } }, required: ['question', 'to'] } },
    given: { type: 'object', additionalProperties: { type: 'string' } },
    by: { type: 'string', enum: ['itself', 'chance', 'outside', 'none'] },
    measure_en: { type: 'string' }, measure_zh: { type: 'string' }, within: { type: 'string' },
    plain_en: { type: 'string' }, plain_zh: { type: 'string' },
    strength: { type: 'string' }, reach: { type: 'string' }, module: { type: 'string' },
    drops: { type: 'array', items: { type: 'string' } },
    evidence: { type: 'string' }, unplaced_why: { type: 'string' }, needs: { type: 'string' },
  },
  required: ['lean', 'items', 'on', 'shape', 'given', 'by', 'plain_en', 'plain_zh', 'strength', 'module', 'evidence'],
}
const TYPED = { type: 'object', properties: { dynamic: { type: 'string' }, rows: { type: 'array', items: ROW }, about_the_questions: { type: 'string', description: 'what this dynamic shows is wrong or missing in the question list, briefly' } }, required: ['dynamic', 'rows'] }
const REFUTED = { type: 'object', properties: {
  dynamic: { type: 'string' },
  verdicts: { type: 'array', items: { type: 'object', properties: { lean: { type: 'string' }, verdict: { type: 'string', enum: ['keep', 'fix', 'drop'] }, why: { type: 'string' }, fixed: ROW }, required: ['lean', 'verdict', 'why'] } },
  missing_rows: { type: 'array', items: ROW }, about_the_questions: { type: 'string' } }, required: ['dynamic', 'verdicts'] }

const results = await pipeline(
  args,
  d => agent(CONTEXT + `\nYOUR DYNAMIC: "${d}". Write its rows.`, { label: `type:${d}`, phase: 'Type', schema: TYPED }),
  (typed, d) => typed ? agent(CONTEXT + `\nYOU ARE THE SKEPTIC for dynamic "${d}". Another reader wrote these rows:\n\n${JSON.stringify(typed.rows, null, 1)}\n\nFor EACH row, read the Lean statement yourself and try to refute the row: Is "on" the question the CONCLUSION speaks of? Is the shape right (a line drawn as a move? a keeping drawn as a move? "by itself" where the law only says what follows IF something outside its course is changed?) Does every entry of "given" correspond to a hypothesis of the statement, and is any hypothesis that fixes an answer missing from it? Are from / to / fork the statement's two sides? Is the strength copied, a witness kept a witness? Do measure and plain say what the statement says, no more, in words a stranger understands? Is the module right? Verdict "keep" where you could not break it, "fix" with the complete corrected row in "fixed", "drop" where it should not be in the store (say why). Then check coverage: every item of the dynamic (each exit, transition, compose entry in dynamics.json) must be cited by some row or be the subject of a row with shape "none"; add any missing row in missing_rows. Default to "fix" when unsure.`,
    { label: `refute:${d}`, phase: 'Refute', schema: REFUTED }).then(r => ({ dynamic: d, typed, refuted: r })) : { dynamic: d, typed: null, refuted: null },
)
return { results: results.filter(Boolean) }
