export const meta = {
  name: 'one-map-type-tests',
  description: 'Write each of the 66 tests on record as a case in its own words, with its bridges to the laws\' roles and each frozen prediction\'s outcome and where it failed; a second reader checks each against the experiment\'s own record',
  phases: [{ title: 'Type', detail: 'one reader per batch of tests' }, { title: 'Refute', detail: 'a second reader checks each against the record' }],
}

const CONTEXT = `
THE WORK. /Users/ren/theories (branch main): a theory proved in Lean on models, with tests of its theses. The tests are in theories/becoming/results/data/tests.json (66: id, name, thesis, folder, frozen, run, outcome, quote, gloss) and TESTS.md; each has a folder under experiments/ with a README (and often a predictions file and results). The eight theses are in theories/becoming/chapters/08-METHOD.md section 9. The atlas (theories/becoming/results/atlas/entries/): dynamics.json (183 dynamics; some list their tests under "tests"), bindings.json (22 tests bound to the laws they bear on, with roles, each premise assessed, observed, result, what failed), situations.json (one actual case as a web).

WHAT IS BEING BUILT. ONE MAP of the whole account, on a foundation its director approved: /Users/ren/theories/tmp/r7/FOUNDATION.md (read it whole first). The ground is one web of a few kinds of role and tie (/Users/ren/theories/tmp/r7/map/web.json: read it whole). REASONING says statements in general (laws, proved on models, in role-words). A CASE says them in particular, in its own words. They meet in a BRIDGE (this case's thing is taken as that role) and a TEST (what was predicted against what was seen). The director's sentence: logic and situation are kept apart, "even when one is right, the other could be wrong", and the map should show how reasoning relates to actual data. On the record a proved law has never failed and cannot: a case falls under it or outside it. What fails is a bridge, an "if" in this case, the step from a law to a prediction, the measure, the frozen scoring rule, or the records; and many tests could not tell.

YOUR UNIT IS A TEST. For each test in your batch (/Users/ren/theories/tmp/r7/map/test-batches.json, the entry whose "id" is yours), read its row in tests.json, its folder's README in full (and its predictions and verdict files where they exist), its entry in bindings.json if it has one, and its thesis in 08 section 9. Then write:
- test: the id. kind: model (a built Lean or scripted case) | run (a system run for the test: learners, language models) | records (laboratory or field records made by others) | field. state: what tests.json says (passed, mixed, failed, not-run, held ...).
- case_en, case_zh: ONE sentence, at most 35 words, saying what the case is, IN THE CASE'S OWN WORDS (fish stocks, flour beetles, three language-model fishers, a judge picking between answers). Here people and things are named as they are.
- things: what in the case was taken as which role: [{thing_en: the case's own word for it, role: one of web.json's role ids, how: "built" (set up so by the test) | "found" (as it was)}].
- bridges: the claims that join the case to the reasoning, each one sentence: [{name: the test's own label for it where it has one (H1, H1-LA2, a thesis clause), claim_en: "X is taken as ..." or "things of this kind meet ...", state: held | failed | not checked | by construction, why_en}].
- predictions: each FROZEN prediction or contrast the test scored (at most six; the main ones): [{label, says_en: what was predicted, in the case's words, from_thesis: T1..T8 or "", from_laws: [Lean names the prediction rests on, from the README or the binding; [] if none is named], step: follows (it is the law's conclusion under the bridge) | beyond (it says more than any law) | identity | check (a check that the test could fail) | forecast, ifs: [{what_en, how: built | measured | argued | not checked, state: met | failed | not checked}], seen_en: what was observed, with the numbers the record gives, outcome: agreed | disagreed | not rejected | could not tell | no verdict, failed_at: none | bridge | if | law-to-prediction | measure | scoring rule | records | power, rival_en: what else would give the same, where the record says ("" if not said)}].
- afterwards_en: what gave way or followed, where the record says: a thesis narrowed or reworded (with the date), a law's scope restated, a new law, a successor test; "" if nothing.
- dynamics: the atlas dynamic ids this test bears on (from bindings.json's bears_on, from dynamics.json entries whose "tests" list this folder, or named in the README); [] if none.
- square: for the test as a whole, where it stands: "if met, then seen" | "if met, then not seen" | "if not met, then seen" | "if not met, then not seen" | "if not checked" | "not run".
- shows_en, shows_zh: ONE sentence, at most 30 words: what this test shows about how the reasoning stands to the data.
For a test that was not run, held, dropped or refused, fill what the record has (the case, the bridges it would need, why it did not run) and leave predictions' seen_en "" with outcome "no verdict".

RULES. Quote numbers exactly as the record gives them; never round a count into a claim. Do not grade the test or the theory. Where the record itself says a verdict passed by a tie, or that a control turned too, or that a rule did not read its construct, say that. A case uses its own words; a law's role is named by web.json's id only in the "role" field. Chinese: plain modern Chinese by ear, short.

READ ONLY: change nothing in the repository, write no files, run no tests, builds, renders or gates; small read-only python3 -B or grep is fine.
`

const PRED = { type: 'object', properties: {
  label: { type: 'string' }, says_en: { type: 'string' }, from_thesis: { type: 'string' }, from_laws: { type: 'array', items: { type: 'string' } },
  step: { type: 'string' },
  ifs: { type: 'array', items: { type: 'object', properties: { what_en: { type: 'string' }, how: { type: 'string' }, state: { type: 'string' } }, required: ['what_en', 'how', 'state'] } },
  seen_en: { type: 'string' }, outcome: { type: 'string' }, failed_at: { type: 'string' }, rival_en: { type: 'string' } },
  required: ['label', 'says_en', 'from_laws', 'step', 'ifs', 'seen_en', 'outcome', 'failed_at'] }
const TEST = { type: 'object', properties: {
  test: { type: 'string' }, kind: { type: 'string' }, state: { type: 'string' }, case_en: { type: 'string' }, case_zh: { type: 'string' },
  things: { type: 'array', items: { type: 'object', properties: { thing_en: { type: 'string' }, role: { type: 'string' }, how: { type: 'string' } }, required: ['thing_en', 'role', 'how'] } },
  bridges: { type: 'array', items: { type: 'object', properties: { name: { type: 'string' }, claim_en: { type: 'string' }, state: { type: 'string' }, why_en: { type: 'string' } }, required: ['claim_en', 'state'] } },
  predictions: { type: 'array', items: PRED },
  afterwards_en: { type: 'string' }, dynamics: { type: 'array', items: { type: 'string' } }, square: { type: 'string' },
  shows_en: { type: 'string' }, shows_zh: { type: 'string' } },
  required: ['test', 'kind', 'state', 'case_en', 'case_zh', 'things', 'bridges', 'predictions', 'afterwards_en', 'dynamics', 'square', 'shows_en', 'shows_zh'] }
const TYPED = { type: 'object', properties: { batch: { type: 'string' }, tests: { type: 'array', items: TEST }, notes: { type: 'string' } }, required: ['batch', 'tests'] }
const REFUTED = { type: 'object', properties: { batch: { type: 'string' },
  verdicts: { type: 'array', items: { type: 'object', properties: { test: { type: 'string' }, verdict: { type: 'string', enum: ['keep', 'fix'] }, why: { type: 'string' }, fixed: TEST }, required: ['test', 'verdict', 'why'] } } },
  required: ['batch', 'verdicts'] }

const results = await pipeline(
  args,
  b => agent(CONTEXT + `\nYOUR BATCH: "${b}". Write one record for each of its tests.`, { label: `type:${b}`, phase: 'Type', schema: TYPED }),
  (typed, b) => typed ? agent(CONTEXT + `\nYOU ARE THE SECOND READER for batch "${b}". Another reader wrote these records:\n\n${JSON.stringify(typed.tests, null, 1)}\n\nFor EACH record, open the test's README (and its predictions and verdicts files) yourself and try to refute it. Is every number as the record gives it? Is each thing's role the right kind, and "built" or "found" right? Is each bridge really a claim the test rests on, and its state what the record says (a bridge that failed marked failed, one never checked marked not checked)? For each prediction: is it one the test froze; does from_laws name only laws the record or the binding names; is "step" right (does the prediction follow from the law under the bridge, or say more than any law); are the ifs' states and how they were met right (built so, measured, argued); is seen_en what was observed; is the outcome right, and failed_at the place the record puts the failure (not a guess)? Does "square" follow from the ifs and the outcome? Do case_en and shows_en say what is there, no more, in plain words? Verdict "keep" where you could not break it; "fix" with the COMPLETE corrected record in "fixed". Default to "fix" when unsure.`,
    { label: `refute:${b}`, phase: 'Refute', schema: REFUTED }).then(r => ({ batch: b, typed, refuted: r })) : { batch: b, typed: null, refuted: null },
)
return { results: results.filter(Boolean) }
