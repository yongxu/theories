export const meta = {
  name: 'why-not-good-enough',
  description: 'Seven independent readers of the landed map, one lens each, to find why Ren said it is not good enough; read only, no scores',
  phases: [
    { title: 'Read', detail: 'seven readers, the same whole material, one lens each' },
  ],
}

const LOOK = '/private/tmp/claude-501/-Users-ren-theories/d9ccfc76-7843-4b3c-ba5b-c950965917c6/scratchpad/look'
const MAP = '/Users/ren/theories/theories/becoming/results/map'
const REC = '/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rw-one-map'

const COMMON = `
You are one of seven independent readers. Each reads the same whole material through one lens. You are not told the others' lenses or findings.

THE SITUATION
The repository /Users/ren/theories holds "the theory of becoming". Its AGENTS.md (already in your context) says what the work is for: a map of how anything forms, persists, changes and ends; first a map for alignment, also a map of wisdom; so that humans and AI can see the way together.
On 11 November 2026 Ren, whose work this is, read the public face and gave it "probably just a 4" of 10. His words, verbatim, with what followed through three rounds of prototypes, are in
  /Users/ren/theories/sources/15-codex-theory-conversations/2026-11-08-representation-to-eight.md  (the section "I would give it probably just a 4", about lines 102 to 160). Read that section first, slowly. His words are the measure.
After those three rounds "the one map" was landed on main (not pushed). He has now read it and answered:
  "not good enough - review and understand why i said so"
Your work is to help understand why, from the thing itself and from his words.

THE THING, AS LANDED
  ${MAP}/THE-MAP.md      the page a reader lands on (about 3,800 words)
  ${MAP}/LAWS.md, DYNAMICS.md, CASES.md   three pages of detail (about 13,000, 15,000 and 19,000 words)
  ${MAP}/the-map.svg     the picture
  ${MAP}/interactive.html  "the same map to operate" (1.8 MB: do NOT read it whole). Screenshots of it, which you can open with the Read tool:
     ${LOOK}/1-the-picture.png
     ${LOOK}/2-first-screen-of-the-map-to-operate.jpg
     ${LOOK}/3-below-the-picture-reasoning-met-a-case.jpg
     ${LOOK}/4-after-choosing-the-tie-drawers-draw-on-a-stock.jpg
     ${LOOK}/5-the-same-tie-further-down.jpg
     ${LOOK}/6-after-choosing-the-dynamic-closed-capture.jpg
     ${LOOK}/7-closed-capture-its-panel.jpg
  ${MAP}/web.json, cards.json (1.3 MB), cases.json (0.7 MB)   its data (read parts, or query with python3 -B; do not print them whole)

AROUND IT
  ${REC}/README.md, WHOLE-PICTURE.md, DESIGN.md, FOUNDATION.md   how the map came about; the three notes Ren read
  ${REC}/places/ and ${REC}/store/   the data of the two earlier prototypes (round 1: places and arrows for one region; round 2: questions, answers, laws)
  /Users/ren/theories/theories/becoming/results/atlas/   the atlas the map is built on (ATLAS.md, JOINS.md, TERRAIN.md, entries/dynamics.json with each dynamic's mechanism, exits, transitions, compose)
  /Users/ren/theories/theories/becoming/ONE-PAGE.md, THE-THEORY-OF-BECOMING.md, chapters/   the account itself
  /Users/ren/theories/sources/15-codex-theory-conversations/2026-11-09-agents-the-map.md, 2026-11-10-dynamics-connected-mapped-unified.md, 2026-11-10-elegant-and-wise.md, 2026-11-10-traditions-onto-the-map.md   more of Ren's words on the direction
  /Users/ren/theories/GLOSSARY.md

RULES
- Read only. Do not edit, create or delete any file in the repository. Do not run tests, renders, builds, gates or any git command that writes. Shell is for reading (grep, wc, python3 -B to query JSON).
- No scores, no grades, no praise for its own sake. Earlier rounds were graded by AI readers near 8 while Ren gave a 4; a grade from you is worth nothing here.
- Not a list of small defects. Two reviews already produced 86 findings of detail and the result is still not good enough. Look for the deepest reasons: what kind of thing was built, against what kind of thing was asked for.
- Quote what you saw: the sentence, the file, the number. A finding without something a person can go and look at is not a finding.
- Where you think Ren's words are wrong or the map is right against them, say so and argue it.
- Write plainly and briefly. Your final answer is data for the coordinator, not a message to a person.
`

const SCHEMA = {
  type: 'object',
  properties: {
    say_back: { type: 'string', description: 'In plain words, at most 150 words: what a reader comes away with from this map, through your lens.' },
    why_not_good_enough: { type: 'string', description: 'The deepest reason through your lens, at most 200 words, stated as what was built against what was asked for.' },
    findings: {
      type: 'array', maxItems: 5,
      items: {
        type: 'object',
        properties: {
          what: { type: 'string', description: 'One sentence.' },
          evidence: { type: 'string', description: 'Quotes, numbers, file paths: what a person can go and look at.' },
          which_of_rens_words: { type: 'string', description: 'The words of Ren this bears on, quoted, or "none".' },
        },
        required: ['what', 'evidence', 'which_of_rens_words'],
      },
    },
    keep: { type: 'array', maxItems: 5, items: { type: 'string' }, description: 'What in the landed map or its data is good and should be kept, each in one sentence with where it is.' },
    a_good_one_would: { type: 'string', description: 'At most 150 words: concretely, what a good map would let this reader see or do that this one does not. Describe the experience, not an implementation.' },
    against_ren: { type: 'string', description: 'Where, if anywhere, you think Ren is wrong or the map is right against his words; "nothing" if nothing.' },
  },
  required: ['say_back', 'why_not_good_enough', 'findings', 'keep', 'a_good_one_would', 'against_ren'],
}

const LENSES = [
  { key: 'cold-reader', model: 'opus', prompt: `
YOUR LENS: a thoughtful person from outside, in the first ten minutes.
You know nothing of this project. Someone you respect sent you the link and said it maps how things form, last, change and end, and that it matters for AI alignment.
1. BEFORE reading anything else in the repository beyond Ren's words: read ${MAP}/THE-MAP.md from the top as that person would, and open the screenshots 1 to 7 in order. Follow at most two links from the page, the ones such a person would follow, and read where they land for a few minutes each.
2. Then write your say-back at once: what does it say about how things form, last, change and end? What can you now see or do that you could not before? What would you tell a friend this is?
3. Note the exact sentence where you first stopped following, each word you had to learn before you could go on, and where you would have closed the tab.
4. Does it feel like serious work? Say what on the page gives or takes away that feeling, quoting it.
5. Only after all that, read the account's own pages (ONE-PAGE.md, a chapter) for a few minutes, and say what is there, of value to that person, that the map did not carry to you.` },

  { key: 'with-a-question', model: 'opus', prompt: `
YOUR LENS: a person who comes with a real question and uses the map to answer it.
Take these three questions, one at a time, each as a person who has that problem:
  (a) "Several boats fish one bay. What decides whether the fishery lasts or collapses, and what can keep it?"
  (b) "We train a model against a learned reward (or: my team is paid on a metric) and the number goes up while the thing we wanted gets worse. What is going on, where does it lead, and what would get us out?"
  (c) "What is the meta-attractor, how would humans and AI together fall into it, and what would keep them out?"
For each: start at ${MAP}/THE-MAP.md and use only the map (its page, the picture and screenshots, the three detail pages, and its data where the interactive page would show it). Record the path you took (each step, each click), how many words you had to read, and the answer you could give at the end, in your own plain words. Say where the path died.
Then, for each question, look at what the account itself holds (ONE-PAGE.md, the chapters, the atlas's dynamics, the tests) and say what the answer could have been, and so what the map failed to bring to the person.
A map is for finding your way from where you are. Did it let you find where you are?` },

  { key: 'reasoning-and-situation', model: 'opus', prompt: `
YOUR LENS: Ren's goal, in his words: "i think the map can separate logic and situation, even when one is right, the other could be wrong. and this map can guide us to understand the relationships between reasoning and the actual data(situation/observation), is a very clear goal i want".
1. Pick three tests with rich records, for example LA4 (Stage A), CG3 (round 1) and MQ3 (find their folders through /Users/ren/theories/TESTS.md), and read each test's own record: what was reasoned, what was set up or found, what was seen, what was concluded.
2. Then look at what the map shows of each: in THE-MAP.md ("Where reasoning has met a case"), in CASES.md, in cases.json, on the picture (the green dots and rings), and in the screenshots. For each test, can a reader SEE on the map: the reasoning; the situation; where the two were brought together; and which of them was wrong, or that neither was? How many words must they read to get there?
3. What does a reader conclude from the page's table of counts and its four corners (26, 0, 11, 32)? Is that conclusion what the records support? Does the framing "a case cannot make a proved law wrong" help a reader understand the relationship, or put a wall where he asked for a relationship?
4. Could a person bring a NEW situation of their own to this map and find which reasoning applies to it and how far? Try it with one situation of your choice and report what happened.
Say what kind of thing was built for this goal, against what the goal asks.` },

  { key: 'map-craft', prompt: `
YOUR LENS: what makes a map a map, and a map of dynamics in particular.
Ren said of the earlier public face: "I asked you to show the map but you showed some connections between different components and I don't think we have something like a map", and "when I said to have a map, to use graph to represent it, I was also thinking about maybe something that can show its topology can show the relationship between different things". Of the second prototype: "we also want \\"a map\\" not \\"a set of maps\\"".
1. Say what a map lets a person do that a catalogue or a schema does not (see the whole shape at once; find where they are; see what is next to what; see routes, barriers and dead ends; go from the whole to a detail and back). Think of the maps of dynamics people already read well: a phase portrait or landscape of attractors and basins, a state-transition diagram, a stock-and-flow or causal-loop diagram with named loops, a metabolic pathway chart, a transit map, a geological map, a periodic table.
2. Look at the picture (the SVG and screenshot 1) and the page. What kind of diagram is it, in the terms of that craft? What are its nodes and its edges? What does a node's position mean? What can a person do with it? The page itself says "an arrow is not a route": weigh that.
3. The theory is of becoming: forming, lasting, changing, ending. Where on the picture is time, a state, a movement from one state to another, an attractor, a point of no return, a loop that closes? The page reports "Drawn ties where no general law shows a change: 19 (of 19)". Check that against what the atlas holds (entries/dynamics.json: exits, transitions, compose; JOINS.md) and say what that sentence is a fact about.
4. Read the record's WHOLE-PICTURE.md (its "one cause": no layer of places between 8 families and 183 dynamics) and DESIGN.md, and the data of the two earlier prototypes (places/places-v1.json, places/decisions.json; store/questions.json, store/rows.json). What did each earlier prototype have, as a map, that the landed one does not, and the reverse? Ren said of round 1 "Yes, extend it" and of round 2 "definitely better than the first one" and "on the right direction".
5. Where are the 183 dynamics themselves (look at their names in DYNAMICS.md) on the picture?
Say what kind of thing was built, against what kind of thing a map is.` },

  { key: 'words-and-splits', prompt: `
YOUR LENS: the words and the concepts, in English and in Chinese.
Ren's words: "we said that don't mention AI so much, don't mention our vocabulary so much"; "I feel a lot of words that we use, a lot of the concepts are still heavily dualistic"; "the words you choose isn't really great, like you use 人 when it is not just about people"; and from the sources of 9 and 10 November: principles are within the map, not above it; no dualistic good or evil; make the dynamics connected, mapped, unified; elegant and wise. Read those source files.
1. List every term a reader of THE-MAP.md must learn that is the map's own (not ordinary English used ordinarily): role, tie, mark, form, frame, card, case, bridge, thesis, square, built case, given changed, and so on. Count them. For each of the eleven role names in English and in Chinese, say whether a native reader understands it on first meeting, and what they would take it to mean. Read some full tie names aloud, for example "what it is of · reaches, or lies beyond · its readers". Read ten law sentences in Chinese from LAWS.md or cards.json as a native reader would and say how they read.
2. Which splits into two does the map build into its structure (not only its words)? For each: is it a distinction the account itself makes and needs, or one the map added? Consider at least: law against case; "if" met against not met; "then" seen against not seen; filled against empty; general against built; drawn against thinner; begins, lasts, changes, ends as four separate boxes; each role against its counterpart (a rule and what it selects among; a reading and what it is of; the drawers and a stock). The account's method begins with "one relational unfolding" (chapters/08-METHOD.md): does the map show an unfolding, or things with properties?
3. How often and where does the landing page speak about AI, about how it was made, about what it does not hold, about being provisional? What does that do to a reader?
4. Where the map avoided person-words, what did it put in their place, and is that better?
Say what the words and the concepts show about what was built.` },

  { key: 'purpose', prompt: `
YOUR LENS: what the work is for, and whether the map shows it.
1. From AGENTS.md ("What we are doing"), ONE-PAGE.md and the main text, write down the eight to twelve things the account most wants a person to see. Expect among them: what a selection reaches; what it drains beyond what it reads; how it locks on what it already chose; the chain of capture and the meta-attractor; instrumental convergence; what keeps a joint selection of humans and AI out of them; renewal and 生生; what the traditions and sciences have seen of the same dynamics; the ethics as seeing what a course draws on, what it opens and closes, and who bears it.
2. For each: where is it on the landed map? Can a person see it on the picture, or on the first page, without choosing anything? If it is reachable only through a list or a search, say how deep.
3. Read the page's section "What the map shows today" and the first paragraph of its ending "What it does not hold". With those numbers in mind ("a change: 19", "a frozen prediction with a verdict names a law on 4", "36 of 183"), what impression of the account does a reader take away? Is that impression true to what the account holds (the atlas, the chapters, the tests)? On 9 November Ren said of an earlier defence of hedges: "你说的好像我们做的工作没有什么价值一样". Does this page do that again?
4. What is the map's subject, as built: the dynamics of the world, or the account's own stock of laws and tests? Give the evidence from its tables, its counts, its headings.
5. A map of wisdom: where on it are the traditions and the fields (the crosswalk, the Chinese sentences put to the proof checker)?
Say what the map is a map of, against what it was asked to be a map of.` },

  { key: 'the-defence', prompt: `
YOUR LENS: the defence, and the test of the coordinator's diagnosis.
The coordinator (an AI) who built the map has reread it and reached this diagnosis. You are to break it where it is wrong, and to argue the strongest honest case for what was built.

THE COORDINATOR'S DIAGNOSIS
 1. The map shows where laws exist, not what they say. It is a census of the account's own laws and tests filed under a schema of kinds (role, tie, mark, form, frame). Its tables are counts of entries. The 183 dynamics, whose names say what happens ("A whole drawing beyond renewal ends", "The lock draws its readers out", "Closed capture"), are in a drop-down list in alphabetical order.
 2. The layer a person reads is missing again. The first diagnosis of 11 November named one cause: nothing between 8 families and 183 dynamics, no places (regimes something can be in, and what leads from one to another). The landed map has 11 kinds of role and 19 ties above, 726 law sentences below, and nothing between. Round 1 had places for one region; they were dropped.
 3. It has no states, so it cannot show change. Its sentence "on no drawn tie does a general law show what makes it change" is a fact about its filing, while the atlas holds 324 exits and 103 transitions. A reader takes it as a fact about the theory.
 4. Reasoning and situation are kept apart by a wall and a tally (a table of counts, four corners, green dots). The relationship between one piece of reasoning and one situation cannot be seen on the map, and a person cannot bring a situation of their own to it. Round 2 had "where a case stands"; it was dropped.
 5. The purpose is not on it. On its first page the words drain, capture, meta-attractor, alignment and attractor do not occur. Choosing "Closed capture" lights four boxes.
 6. It added vocabulary and replaced person-words with placeholders ("what it is of", "what it selects among", 所读者), and every structure in it is a split into two.
 7. How it came about: no synthesis was written because "the map adds no result and changes no entry"; two reviews by AI readers (86 findings) made it more exact as an audit and less of a map; a rule of the foundation Ren approved (two models' roles are one place only where a proof joins them) was dropped and listed as a limit; and it was landed and offered for a push with its failings listed.

DO THIS
 a. Check each of the seven points against the files. For each say: holds, holds in part (what part), or does not hold, with the evidence. The coordinator built this and may be wrong in either direction, too harsh as well as too kind.
 b. Ren answered "Yes, land it" when shown the first build of this map and asked "Is this the one map you meant?", and of round 2 said "on the right direction". So something here is what he meant. Argue what that is: what in the web of roles and ties, the keeping apart of laws and cases, the data in cards.json and cases.json, is right and must be kept.
 c. Say what the diagnosis misses: a reason Ren would say "not good enough" that is not among the seven.
 d. Say which of the seven is the root and which are consequences.` },
]

phase('Read')
const reports = await parallel(LENSES.map(l => () =>
  agent(COMMON + l.prompt, { label: `reader:${l.key}`, phase: 'Read', schema: SCHEMA, ...(l.model ? { model: l.model } : {}) })
    .then(r => r ? { lens: l.key, ...r } : null)))

const got = reports.filter(Boolean)
log(`${got.length} of ${LENSES.length} readers returned`)
return { reports: got, missing: LENSES.map(l => l.key).filter(k => !got.some(r => r.lens === k)) }
