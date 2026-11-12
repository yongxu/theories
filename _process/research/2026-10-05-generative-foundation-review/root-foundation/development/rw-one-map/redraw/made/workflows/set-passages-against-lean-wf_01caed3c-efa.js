export const meta = {
  name: 'set-passages-against-lean',
  description: 'Four second readers set every passage drawn on the new sheet against its Lean statement: is the law real, is the sentence true to it, is the kind of arrow right',
  phases: [
    { title: 'Check', detail: 'four readers, one set of passages each, against the Lean' },
  ],
}

const SHEET = '/Users/ren/theories/tmp/r7/sheet'
const LEAN = '/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming'

const BRIEF = (g) => `
You are a second reader. Your work is to set a set of passages, drawn on a new map of "the theory of becoming", against the Lean statements they cite, and correct them. Read only: change no file, run no test, build or render, and no git command that writes. Shell is for reading (grep, python3 -B to query JSON).

WHAT THE MAP IS
The account's laws are theorems checked in Lean. An earlier map filed those theorems and counted them; its reader could not see what happens. The new map shows what happens: each ROW asks one thing of anything that goes on; each CONDITION is one way the answer can stand; each PASSAGE is a way from one condition to another, drawn by how far it has been seen. The whole vocabulary (14 rows, 50 conditions) is in ${SHEET}/vocabulary.json: read it first, so you know what each condition means.

YOUR SET
${SHEET}/verify-${g}.json holds your passages and the conditions they join. A passage has: from, to, kind, a sentence in English and Chinese, the Lean laws it names, and sometimes "items" (the atlas exits and transitions two earlier readers placed on it, with their law, strength and atlas sentence). The hand-written sentences were written by the coordinator from those items and may be wrong. Some law names may be wrong or missing.

WHERE TO LOOK
- The Lean sources: ${LEAN}/ (401 files). Find a theorem with grep -rn "theorem .*<name>" and read its full statement and docstring. A name like Becoming.Web.readableInTime_iff is theorem readableInTime_iff in namespace Web. Chinese theorem names are in guillemets.
- The atlas: /Users/ren/theories/theories/becoming/results/atlas/entries/dynamics.json (each dynamic's mechanism, declarations, exits with law and strength, transitions) and premises.json.
- /Users/ren/theories/theories/becoming/results/map/cards.json: for many laws, a plain sentence already checked against the Lean by a second reader, with the statement as "evidence". Search it by the law's name.
- The chapters, where a law's home section explains it: /Users/ren/theories/theories/becoming/chapters/.

FOR EACH PASSAGE, DECIDE
1. Is each named law real, and is it the right law for this passage? Name the laws that actually carry it (full names, as Becoming.X.y).
2. Does the sentence say what the Lean statement says? Check the direction, the quantifiers (every course or some; from any start or from a given one; a bound or an exact line), and every condition the theorem needs. A sentence may leave out a formula; it may not say more than was proved, nor less in a way that changes the sense.
3. Is the kind right?
   - "law": a general theorem shows the course itself making this passage (sufficient, or exact one way), from premises that belong to the from-condition or to the model.
   - "line": one theorem (an iff, or a pair of theorems) says exactly on which side of the two conditions a course stands. It is not by itself a statement that anything moves across.
   - "needs": the laws give only what the passage needs. Either a necessary condition, or a theorem whose premise is that something the model holds fixed is changed from outside the course (another rule, a judging that comes to read the loss, a giver from beyond).
   - "built": only a constructed example or witness shows it can happen.
   - "reading": no theorem states it.
   - "same": the two conditions are the same thing seen from two rows (a definition, or one is a case of the other), with no movement.
4. Is the placement right: do "from" and "to" fit what the theorem is about, given the conditions' meanings in vocabulary.json? If not, say where it belongs (condition ids), or that it belongs nowhere on the map as drawn.

THEN WRITE EACH PASSAGE AS IT SHOULD STAND
- A sentence in English of at most 40 words and its Chinese. Say what happens and under what, in plain words a person outside the project understands.
- The laws hold of anything that goes on (a stock, a rule, a market, a trained system, an organism), so use no word that fits only a person: not people, someone, anyone, who, winners, members' "views" of persons. Use the map's words: what it favours, the rest, what sets the rule, what lives on it, what takes, what gives back, a view, what it is of. In Chinese no 人, 谁, 大家; write Chinese as thought in Chinese, plain and short, not as translated English.
- No Lean identifiers, symbols or formulas in the sentence.
- Do not soften a correct sentence or add hedges. If the hand-written sentence is right, keep it word for word and say "keep".

ALSO
- For each condition in your set: does at least one Lean predicate, definition or premise state it (name them), and is its one-sentence gloss true to them? Correct the gloss only where it is wrong.
- Name at most six passages the laws clearly show among the conditions of your set (or from them to another condition in vocabulary.json) that the set lacks, each with its law, kind and sentence. Prefer ways back and ways out: the earlier readers found far more laws for closing than for opening, and the map should show honestly whether that is so.
Your final answer is data for the coordinator. Be exact and brief in "why".`

const SCHEMA = {
  type: 'object',
  properties: {
    passages: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          from: { type: 'string' }, to: { type: 'string' },
          verdict: { type: 'string', enum: ['keep', 'fix', 'move', 'drop'] },
          new_from: { type: 'string', description: 'condition id, only for verdict move' },
          new_to: { type: 'string', description: 'condition id, only for verdict move' },
          kind: { type: 'string', enum: ['law', 'line', 'needs', 'built', 'reading', 'same'] },
          en: { type: 'string' }, zh: { type: 'string' },
          laws: { type: 'array', items: { type: 'string' } },
          statement: { type: 'string', description: 'The Lean statement in a few plain words: its premises and its conclusion, as you read them.' },
          why: { type: 'string', description: 'For fix, move or drop: what was wrong. One or two sentences.' },
        },
        required: ['from', 'to', 'verdict', 'kind', 'en', 'zh', 'laws', 'statement', 'why'],
      },
    },
    conditions: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          id: { type: 'string' }, verdict: { type: 'string', enum: ['keep', 'fix'] },
          says_en: { type: 'string' }, says_zh: { type: 'string' },
          anchors: { type: 'array', items: { type: 'string' }, description: 'Lean predicates, definitions or premise ids that state this condition; empty if none.' },
          why: { type: 'string' },
        },
        required: ['id', 'verdict', 'says_en', 'says_zh', 'anchors', 'why'],
      },
    },
    missing: {
      type: 'array', maxItems: 6,
      items: {
        type: 'object',
        properties: {
          from: { type: 'string' }, to: { type: 'string' }, kind: { type: 'string', enum: ['law', 'line', 'needs', 'built', 'reading', 'same'] },
          en: { type: 'string' }, zh: { type: 'string' }, laws: { type: 'array', items: { type: 'string' } }, why: { type: 'string' },
        },
        required: ['from', 'to', 'kind', 'en', 'zh', 'laws', 'why'],
      },
    },
    notes: { type: 'string', description: 'Anything about the rows or conditions of your set that the coordinator should know, at most 150 words.' },
  },
  required: ['passages', 'conditions', 'missing', 'notes'],
}

phase('Check')
const GROUPS = ['stock', 'lock-closing', 'lock-turning', 'auto']
const out = await parallel(GROUPS.map(g => () =>
  agent(BRIEF(g), { label: `check:${g}`, phase: 'Check', schema: SCHEMA }).then(r => r ? { group: g, ...r } : null)))
const got = out.filter(Boolean)
log(`${got.length} of ${GROUPS.length} readers returned`)
return { groups: got, missing_groups: GROUPS.filter(g => !got.some(r => r.group === g)) }
