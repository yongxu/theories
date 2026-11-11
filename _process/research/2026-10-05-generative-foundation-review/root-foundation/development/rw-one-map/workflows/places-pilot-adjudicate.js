export const meta = {
  name: 'places-pilot-adjudicate',
  description: 'For each dynamic of the capture chain: settle every exit, transition and join onto the place list against the Lean law, then a skeptic tries to refute each arrow',
  phases: [{ title: 'Settle', detail: 'one reader per dynamic decides each item against the law' }, { title: 'Refute', detail: 'a skeptic per dynamic tries to break each arrow' }],
}

const CONTEXT = `
THE WORK. /Users/ren/theories (branch main) holds a theory with an "atlas" of 183 dynamics (theories/becoming/results/atlas/entries/dynamics.json). Each dynamic is one proved result's mechanism, with exits (a law, a strength: exact / sufficient / necessary / witness), transitions (kind, condition, declarations) and sometimes compose entries (one dynamic's state read as another's rule, reading or pool). The atlas has no layer of PLACES (conditions something can be in, that a person recognises) and so no map. We are building that layer for one region, the capture chain, so a map can be drawn: places as nodes, changes as arrows, each arrow traced to one item of the data and marked with how far it has been seen.

THE PLACE LIST is fixed for this pass: the "places" array in /Users/ren/theories/tmp/r7/places/adjudicate-args.json (15 places; each has id, label, gloss, example, and "test": the criterion for when an item belongs there). Read all 15 before deciding anything.

THREE EARLIER READERS each assigned every item independently, with their own place names, mapped onto this list. Their votes for your dynamic are in the same file under "dynamics" (find the entry whose "dynamic" is yours). Where they agree it is evidence, not proof; where they split, the law decides.

HOW TO DECIDE AN ITEM. Read the dynamic's entry in dynamics.json in full, the item's own sentence, the record page theories/becoming/results/records/<record id>.md where there is one, and the STATEMENT of the cited Lean declaration (grep the short name under experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ ; read the theorem's statement and its docstring, not the proof). Then give one decision:
- "arrow": the law shows a change FROM one listed place TO another. Give from, to, both_ways (true only where the data says "exactly where" for both directions and both ends are listed places), a condition of at most 18 plain words saying what makes the change, in the places' vocabulary (rule, winners, what is counted, those who would notice, a say; never "share", "carrier", "formation", "course", "reads", "couples" in their technical senses), and the same condition in plain modern Chinese.
- "inside": the law is a threshold, pace or flip WITHIN one listed place (for example which side of a tipping count holds; how fast something settles). Give the place and a plain sentence.
- "stays": the law says something STAYS in one listed place under a condition. Give the place and the condition in plain words.
- "leads-out": the destination is real but lies outside this region's 15 places (for example into another family's dynamics). Give from (a listed place) and say in plain words where it leads.
- "unresolved": none of the above honestly fits. Say why.
STRENGTH: copy the exit's strength (exact / sufficient / necessary / witness); for a transition use "exact" only where its laws are iff statements, else "sufficient"; where no law shows it (a compose entry with law null, an entry whose standing is "reading" or "open") use "reading" or "open". Never upgrade. A "witness" is one constructed example: it shows a change can happen, with no condition for it.
BE STRICT. An arrow on a map reads as "things go there". If the law's statement does not relate two of these places, do not draw it: choose inside, stays, leads-out or unresolved. A wrong arrow costs more than a missing one.
EVIDENCE: for every decision quote the words that carry it (the Lean statement's key line, or the record's sentence), with the file.

READ ONLY: change nothing in the repository, write no files, run no tests, builds, renders or gates; small read-only python3 -B or grep is fine.
`

const DECISION = {
  type: 'object',
  properties: {
    item: { type: 'string' },
    decision: { type: 'string', enum: ['arrow', 'inside', 'stays', 'leads-out', 'unresolved'] },
    from: { type: 'string' }, to: { type: 'string' }, place: { type: 'string' }, both_ways: { type: 'boolean' },
    condition_en: { type: 'string' }, condition_zh: { type: 'string' },
    kind: { type: 'string' }, strength: { type: 'string' }, law: { type: 'string' },
    evidence: { type: 'string' }, note: { type: 'string' },
  },
  required: ['item', 'decision', 'strength', 'evidence'],
}
const SETTLED = { type: 'object', properties: { dynamic: { type: 'string' }, decisions: { type: 'array', items: DECISION }, about_the_places: { type: 'string', description: 'anything this dynamic shows is wrong or missing in the place list' } }, required: ['dynamic', 'decisions'] }
const REFUTED = { type: 'object', properties: {
  dynamic: { type: 'string' },
  verdicts: { type: 'array', items: { type: 'object', properties: {
    item: { type: 'string' }, verdict: { type: 'string', enum: ['keep', 'fix', 'drop'] }, why: { type: 'string' }, fixed: DECISION },
    required: ['item', 'verdict', 'why'] } },
  about_the_places: { type: 'string' } }, required: ['dynamic', 'verdicts'] }

const dynamics = args
const results = await pipeline(
  dynamics,
  d => agent(CONTEXT + `\nYOUR DYNAMIC: "${d}". Decide every one of its items (each exit, transition and compose entry listed for it in the args file). Return one decision per item, in order.`,
    { label: `settle:${d}`, phase: 'Settle', schema: SETTLED }),
  (settled, d) => settled ? agent(CONTEXT + `\nYOU ARE THE SKEPTIC for dynamic "${d}". Another reader has decided its items as follows:\n\n${JSON.stringify(settled.decisions, null, 1)}\n\nFor EACH decision, try to refute it by reading the entry and the Lean statement yourself, without trusting the quoted evidence. For an arrow ask: does the law's statement really relate these two places (check both against their "test")? Is the direction right? Is the strength copied correctly, with a witness not passed off as a condition and a reading not passed off as a law? Does the plain condition say what the law's premise says, no more and no less, and would a person with no knowledge of the theory understand it? Is both_ways justified by an iff? For inside / stays / leads-out / unresolved ask whether an arrow was wrongly withheld or the place is wrong. Verdict "keep" where you could not break it; "fix" with the corrected decision in "fixed" (complete, same fields); "drop" where it should become unresolved (say why). Default to "fix" or "drop" when you are not sure an arrow is supported. Return one verdict per item, in order.`,
    { label: `refute:${d}`, phase: 'Refute', schema: REFUTED }).then(r => ({ dynamic: d, settled, refuted: r })) : { dynamic: d, settled: null, refuted: null },
)
const ok = results.filter(Boolean)
log(`${ok.filter(r => r.settled).length} settled, ${ok.filter(r => r.refuted).length} refuted, of ${dynamics.length}`)
return { results: ok }
