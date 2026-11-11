export const meta = {
  name: 'places-pilot-propose',
  description: 'Three independent proposals of the missing middle layer of the map (places and the changes between them) for the capture chain',
  phases: [{ title: 'Propose', detail: 'three angles on the same data; each names places and assigns every exit, transition and join' }],
}

const COMMON = `
You are one of three independent proposers. Work alone; do not look for the others' output.

THE WORK. /Users/ren/theories (branch main) holds a theory of how things form, persist, change and end, with an "atlas": theories/becoming/results/atlas/entries/dynamics.json lists 183 "dynamics" in 8 families. Each dynamic is one proved result's mechanism in the theorem's own wording, with "exits" (ways a course leaves, each with a law, a strength: exact / sufficient / necessary / witness, and the premise it drops) and "transitions" (kind, condition, declarations). 10 "compose" entries say where one dynamic's state is read as another's rule, reading or pool.

THE PROBLEM. The person who directs the work read the public face and found no map in it: only 8 family boxes with counts, and documents joined to documents. The cause: the atlas has no middle layer. Of 321 exits, 251 end in a sentence, not in a node; 110 of 183 dynamics touch no other. A dynamic is a LAW, not a PLACE. What is missing is a layer of PLACES: conditions something can be in, for a stretch or for good, that a person can recognise (for example: a rule rebuilt from its own results; the readers of a loss gone; past the point of no return), with ARROWS for how something changes from one to another. Read /Users/ren/theories/tmp/r7/WHOLE-PICTURE.md (the diagnosis) and /Users/ren/tmp/rw/r7/2026-11-11-ren-a-four.md (his words) first.

YOUR TASK. Propose that layer for the pilot region: the capture chain. The scope is the 24 dynamics whose ids are in /Users/ren/theories/tmp/r7/places/scope.json plus "what-an-optimum-does-beyond-what-couples-in" (family C, and the dynamics of B, E and H joined to it). For these, read every entry in dynamics.json in full (mechanism, exits, transitions, compose, forbids, beyond, open, standing_without_record), and read as needed: theories/becoming/results/atlas/families/c.md and b.md (the entries rendered), theories/becoming/chapters/02-MAP.md sections 9 "Capture" and 10 "Readers the course removes", theories/becoming/chapters/05-COLLECTIVES.md and 07-SIGNIFICANCE.md where an exit's source points, theories/becoming/results/atlas/TERRAIN.md section "How dynamics join", the records under theories/becoming/results/records/<id>.md, and the Lean statements where a sentence is unclear (experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/*.lean; grep the declaration name).

RULES FOR A PLACE.
- A condition a course can be in, said as a plain predicate. Label: at most five everyday words, English and Chinese (plain modern Chinese by ear, not a translation of the English; a 文言 word only where a chapter already gives one). No project vocabulary in the label or the gloss: not "selection", "reads", "couples", "share", "carrier", "formation", "course" in their technical senses unless you cannot say it otherwise; say measure, rule, winners, what it counts, what it does not count, those who would notice.
- Named by WHAT IS HAPPENING, not by how it comes out. The director's critique is that the atlas sorts by outcome (drains, capture, locks, stagnation against "kept regions"), which is dualistic. A language settling on one word, a habit, a currency and a monopoly are the same loop; a place name should fit all of them. Do not name a place as a failure or a success. Keep honest distinctions (ended / goes on; the rule counts something / does not).
- One sentence of gloss (under 30 words) and one everyday example. The example is an illustration: say "such as"; do not assert that an actual system meets a theorem's premises.
- held_by: the dynamics (and the Lean law) that say something STAYS in this place, with under what condition in plain words.
- how_far: one of "law on any process", "law on a named model", "a reading", "open". Take it from the entries (base, standing_without_record, strength); do not upgrade.
- About 10 to 14 places for this region. Fewer is better if nothing is lost. If the region honestly needs a place that is only a reading or open (the wider "meta-attractor" across carriers; capture reaching the routes of correction), include it and mark it.

RULES FOR AN ARROW.
- Every arrow comes from the data: one exit, one transition, or one compose entry. Cite it exactly: dynamic id, and exit index (1-based) or transition index or compose index, and the Lean law name if it has one. Invent no arrow.
- from and to are your place ids. A transition that is a threshold between two places gives arrows both ways if the data says "exactly where"; say so.
- condition: under 18 plain words saying what makes the change (for example "those outside begin to count the loss before it removes them").
- kind: the transition's kind, or "exit". strength: the exit's strength (exact / sufficient / necessary / witness), or for a transition "exact" where it is an iff, or standing "reading" / "open" where no law shows it.
- ASSIGN EVERYTHING IN SCOPE. For each exit, each transition and each compose entry of the scope's dynamics, either give an arrow (or say it is a law of staying in a place: held_by), or list it under unresolved with the reason (for example: a witness of a specific configuration that is not a change of place; a parameter condition inside one place; destination is outside this region: name where it seems to lead). Count them: your arrows + held_by + unresolved must cover all of them. Do not force a fit: an honest "unresolved" is worth more than a wrong arrow.

ALSO REPORT. (1) What the layer shows about the theory in this region: where the places connect, where they do not, what a person would see is missing (holes worth drawing as holes). (2) Whether a place of yours would also be a place in other families (for example "ended", "at rest", "cycling") so the layer can grow. (3) A layout: where each place sits on a page and why, with no "good at the top, bad at the bottom" reading; arrows should cross little.

READ ONLY. Change nothing in the repository; write no files there; run no tests, builds, renders or gates (the machine is shared); small read-only python3 -B scripts over the JSON are fine. Your structured output is the whole deliverable.
`

const SCHEMA = {
  type: 'object',
  properties: {
    angle: { type: 'string' },
    places: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string' }, label_en: { type: 'string' }, label_zh: { type: 'string' },
      gloss: { type: 'string' }, example: { type: 'string' },
      held_by: { type: 'array', items: { type: 'object', properties: { dynamic: { type: 'string' }, law: { type: 'string' }, under: { type: 'string' } }, required: ['dynamic', 'under'] } },
      how_far: { type: 'string' }, also_elsewhere: { type: 'string' } },
      required: ['id', 'label_en', 'label_zh', 'gloss', 'example', 'how_far'] } },
    arrows: { type: 'array', items: { type: 'object', properties: {
      from: { type: 'string' }, to: { type: 'string' }, condition: { type: 'string' }, kind: { type: 'string' },
      strength: { type: 'string' }, law: { type: 'string' }, dynamic: { type: 'string' },
      item: { type: 'string', description: 'exit N / transition N / compose N of that dynamic' }, both_ways: { type: 'boolean' } },
      required: ['from', 'to', 'condition', 'strength', 'dynamic', 'item'] } },
    unresolved: { type: 'array', items: { type: 'object', properties: { dynamic: { type: 'string' }, item: { type: 'string' }, why: { type: 'string' }, seems_to_lead: { type: 'string' } }, required: ['dynamic', 'item', 'why'] } },
    coverage: { type: 'string', description: 'counts: items in scope, arrows, held_by, unresolved' },
    what_the_layer_shows: { type: 'string' },
    layout: { type: 'string' },
    doubts: { type: 'string', description: 'where you are least sure, and which of your own choices you would argue against' },
  },
  required: ['angle', 'places', 'arrows', 'unresolved', 'coverage', 'what_the_layer_shows', 'layout', 'doubts'],
}

const ANGLES = [
  { key: 'from-the-sentences', prompt: `YOUR ANGLE: bottom up. Start from the data's own sentences. Collect every exit destination, every transition condition and every law-of-staying sentence in scope, and cluster them: which describe the same condition in different theorem wording? Let the places be the clusters that recur. Name them last.` },
  { key: 'from-what-people-know', prompt: `YOUR ANGLE: from what a person already knows. Start from situations an educated reader would recognise without the theory (a metric that keeps being optimised while something uncounted wears down; a standard everyone uses because everyone uses it; a ranking refit to its own clicks; an auditor paid by the audited; a habit that outlasts its reason; a warning that comes while there is still time, or too late; the people who would have objected having left). Name the places a person would mark on such a map, then check each against the data: keep a place only if dynamics in scope say something about staying in it or changing from or to it, and add the places the data has that your list missed.` },
  { key: 'one-loop-its-regimes', prompt: `YOUR ANGLE: one process and its regimes, said without poles. Treat the region as ONE loop (something is chosen by a rule; what is chosen takes part in setting the rule and in who looks at how the rule is doing) and ask what distinct regimes that loop has and what moves it between them: the rule set from outside its results or from them; who is among those the rule is read through; whether what the loop draws on outside what it counts is noticed by anyone, in time or not; whether there is one settled state, two, or none. Name each regime so that it fits a shared language and a monopoly alike, and so that no regime is the bad one or the good one: each is then asked what it draws on, what it opens and closes, and who bears that (give those as one clause in the gloss where the data supports it).` },
]

phase('Propose')
const out = await parallel(ANGLES.map(a => () =>
  agent(COMMON + '\n' + a.prompt, { label: `propose:${a.key}`, phase: 'Propose', schema: SCHEMA })
    .then(r => r ? { key: a.key, ...r } : null)))
return { proposals: out.filter(Boolean) }
