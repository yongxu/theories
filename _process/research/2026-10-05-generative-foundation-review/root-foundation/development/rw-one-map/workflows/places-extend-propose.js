export const meta = {
  name: 'places-extend-propose',
  description: 'Two independent proposers per remaining family name the places that family needs, reusing the fifteen that exist',
  phases: [{ title: 'Propose', detail: 'seven families, two angles each' }],
}

const COMMON = `
You are one of two independent proposers for one family of an atlas. Work alone.

THE WORK. /Users/ren/theories (branch main) holds a theory of how things form, persist, change and end, with an atlas: theories/becoming/results/atlas/entries/dynamics.json lists 183 "dynamics" in 8 families (A to H). A dynamic is one proved result's mechanism in the theorem's wording, with "exits" (each with a law, a strength: exact / sufficient / necessary / witness), "transitions" (kind, condition, declarations) and sometimes "compose" entries. The atlas had no layer a person can read: a dynamic is a LAW, not a PLACE. We are adding the missing layer: PLACES, conditions something can be in, named in plain words by what is happening, with ARROWS for the changes between them, each arrow traced to one item of the data. A map is drawn from them.

WHAT EXISTS. One region is done (the chain from a rule rebuilt from its own results to a loss nobody counts). Its 15 places are in /Users/ren/theories/tmp/r7/places/places-v1.json: read all of them, with their "test" (when an item belongs there). The checked decisions for that region are in /Users/ren/theories/tmp/r7/places/decisions.json (see how conditions are worded), and the items that region could not place for want of a place are in /Users/ren/theories/tmp/r7/places/pilot-hanging.json. The readers of that region said these places were missing and belong to other families: "made good again" (what was taken is given back and the outcome is as if nothing was taken); "living past what renews it" (using up what it lives on faster than it comes back, no rule or judge involved); "rebuilt each round but nothing held yet" (swinging, alternating); "what a shared way can no longer tell apart". The rendered prototype's picture is described in /Users/ren/theories/tmp/r7/WHOLE-PICTURE.md (the diagnosis that led here; read its first two sections).

YOUR TASK. Propose the places your family needs. Your family's dynamics not yet placed are listed (id, name, number of items) in /Users/ren/theories/tmp/r7/places/families-remaining.json under your family's letter. Read every one of those entries in dynamics.json in full (mechanism, exits, transitions, compose, forbids, beyond, open, standing_without_record), the family's rendered page theories/becoming/results/atlas/families/<letter>.md where it helps, the chapter sections the entries' sources point to, and a Lean statement where a sentence is unclear (experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/*.lean; grep the declaration's short name; read the statement and docstring, not the proof).

RULES FOR A PLACE.
- REUSE FIRST. Where an existing place's test fits, use it; do not make a near-duplicate. The whole atlas should end with about 35 to 40 places, so a family should add only what it needs: typically 3 to 8.
- A condition something can be in, for a stretch or for good, said as a plain predicate. Label: at most five everyday words, in English and in plain modern Chinese by ear (not a translation; a 文言 word only where a chapter already gives one). No project vocabulary in label or gloss ("selection", "reads", "couples", "share", "carrier", "formation", "course", "regime", "web" in their technical senses): say rule, measure, stock, what renews it, those who depend on it, giving, taking, waiting, and so on.
- NAMED BY WHAT IS HAPPENING, NOT BY HOW IT COMES OUT. The atlas's family names sort by outcome (absorption, drains, capture, locks, stagnation against "kept regions"), which the director of the work finds dualistic: a map of bad places and one good place. A forest, a habit and a monopoly can be in the same place. Do not name a place as a failure or a success. Keep honest distinctions (goes on / ended; above / below the point it can recover from; at rest / still changing).
- GENERAL. Prefer a place other families would also use (ended, at rest, returning in a cycle, renewing within what is given, drawing faster than it renews, past the point of no return, waiting on each other) over one fitted to a single theorem. Say which other families you expect to use each place.
- gloss: one or two plain sentences (under 40 words). example: one everyday illustration beginning "Such as"; never assert that an actual system meets a theorem's premises. test: the criterion for when an item belongs here, precise enough that a second reader applying it to a Lean statement would agree with you.
- how_far only where no law states the place at all ("a reading" or "open").

SHOW THE NEED. For every item (each exit, transition and compose entry) of your family's dynamics give a ROUGH assignment so that each proposed place is seen to be needed: arrow from one place to another (existing ids or your new ids), or "stays" in a place, or "inside" one place (a threshold, pace or flip within it), or "leads-out" / "unresolved" with a few words. This is a first pass; a later reader will settle each item against the Lean statement, so do not agonise, but do not force a fit either. A new place that no item needs should not be proposed.

ALSO SAY. (1) Which existing places' gloss or test should change so that your family's items fit without a new place. (2) What the layer shows about this family: where its places join each other and the existing 15, and what is conspicuously not joined. (3) Where on a page this family's places sit relative to each other (no "good at the top, bad at the bottom").

READ ONLY: change nothing in the repository, write no files, run no tests, builds, renders or gates (the machine is shared); small read-only python3 -B or grep is fine. Your structured output is the whole deliverable.
`

const SCHEMA = {
  type: 'object',
  properties: {
    family: { type: 'string' }, angle: { type: 'string' },
    new_places: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string' }, label_en: { type: 'string' }, label_zh: { type: 'string' }, gloss: { type: 'string' }, example: { type: 'string' },
      test: { type: 'string' }, how_far: { type: 'string' }, also_in_families: { type: 'string' }, needed_by: { type: 'string', description: 'how many items need it, and the two or three clearest' } },
      required: ['id', 'label_en', 'label_zh', 'gloss', 'example', 'test', 'needed_by'] } },
    existing_places_used: { type: 'array', items: { type: 'string' } },
    existing_places_to_reword: { type: 'array', items: { type: 'object', properties: { id: { type: 'string' }, change: { type: 'string' }, why: { type: 'string' } }, required: ['id', 'change'] } },
    rough: { type: 'array', items: { type: 'object', properties: {
      dynamic: { type: 'string' }, item: { type: 'string' }, kind: { type: 'string', enum: ['arrow', 'stays', 'inside', 'leads-out', 'unresolved'] },
      from: { type: 'string' }, to: { type: 'string' }, place: { type: 'string' }, words: { type: 'string' } }, required: ['dynamic', 'item', 'kind'] } },
    what_the_layer_shows: { type: 'string' }, layout: { type: 'string' }, doubts: { type: 'string' },
  },
  required: ['family', 'angle', 'new_places', 'existing_places_used', 'rough', 'what_the_layer_shows', 'doubts'],
}

const FAMILIES = [
  ['A', 'Absorption and ending'], ['B', 'Drains beyond what couples in'], ['D', 'Locks of knowing'], ['E', 'Waiting and reciprocity'],
  ['F', 'Cycles and alternation'], ['G', 'Closure and stagnation'], ['H', 'Kept regions, renewal, generation'],
]
const ANGLES = [
  ['sentences', `YOUR ANGLE: bottom up. Collect every exit destination, transition condition and law-of-staying sentence of the family and cluster the ones that describe the same condition in different theorem wording. The places are the clusters that recur. Name them last.`],
  ['process', `YOUR ANGLE: one process and what a person would recognise in it. Ask what this family is one process OF (something drawing on what renews it; something that returns; giving that waits on giving; a view kept by how it is revised; and so on), what distinct conditions that process has and what moves it between them, then check each against the data: keep a place only where items say something about staying in it or changing from or to it.`],
]

phase('Propose')
const jobs = FAMILIES.flatMap(([f, name]) => ANGLES.map(([a, text]) => ({ f, name, a, text })))
const out = await parallel(jobs.map(j => () =>
  agent(COMMON + `\nYOUR FAMILY: ${j.f} ("${j.name}", the atlas's present name for it).\n\n${j.text}`, { label: `propose:${j.f}:${j.a}`, phase: 'Propose', schema: SCHEMA })
    .then(r => r ? { key: `${j.f}-${j.a}`, ...r } : null)))
return { proposals: out.filter(Boolean), missing: jobs.filter((j, i) => !out[i]).map(j => `${j.f}-${j.a}`) }
