# RW: the one map

*AI-written, 11 November 2026, by the coordinator. Ren read each of the three prototypes this folder records; his words are in [the sources record](../../../../../../sources/15-codex-theory-conversations/2026-11-08-representation-to-eight.md#i-would-give-it-probably-just-a-4-11-november-2026).*

On 11 November Ren read the public face and gave it about 4 of 10: hard for a person to read, no map, too many words, the readings unstructured, the concepts still dualistic. The scores near 8 that AI readers had given were dropped as a measure. He asked to understand the whole picture first, and then to make it work. This folder keeps the three rounds that followed, what each one showed to be wrong, and the two reviews before landing.

What landed is [the map](../../../../../../theories/becoming/results/map/THE-MAP.md): its data in `theories/becoming/results/map/`, its tool `tools/research/the_map.py`, and six views written at each render (the page, three pages of detail, the picture, and the same map to operate).

## The three rounds

| Round | What was built | What Ren said | What gave way |
|---|---|---|---|
| 1 | A layer of places, and a map of the capture chain: 15 places, with 88 exits, thresholds and joins placed on them | "Yes, extend it", then: is this the right representation? | A place is a combination of answers, and an arrow carried five kinds of law |
| 2 | One store of eleven questions and 193 laws; a web of six roles and a chart | "good - but not good enough"; one map, not a set; reasoning apart from situation; no person-words | It was still several pictures, and its laws were written in one case's words |
| 3 | A foundation, put to ten readers set to break it, then the one map built on what stood | "Yes, build on it", then "Yes, land it" | That the root's lines and four marks are the map's whole vocabulary: of 462 laws, 86 fit "if these marks, then that mark" cleanly |

### Round 1: the whole picture, and places

- Eight AI readers went through the public face, one angle each, with quotes and no scores ([readers/](readers/)). The coordinator's reading of them is [WHOLE-PICTURE.md](WHOLE-PICTURE.md): the atlas had 8 families and 183 dynamics and no layer between them that a person reads.
- Three proposers named places for the capture chain independently ([places/](places/): the three `proposal-*.json`, with their `scope.json`) and came to nearly the same ones. Each of the 88 exits, thresholds and joins was then settled against its law's Lean statement and put to a second reader to refute (`places-v1.json`, `decisions.json`, `compare.json`, the drawing's `layout.json`, `draw.py` and `template.html`).
- The same proposal was made for the other seven families, two readers each, one from the process and one from the sentences ([families/](families/)). These were not built on: round 2 changed the structure first.

### Round 2: is this the right structure?

- Six designers answered Ren's question, each from one discipline, one of them set to break the coordinator's view ([designs/](designs/)). The decision is [DESIGN.md](DESIGN.md): the flat store of places and arrows is dominated by a store of questions, answers and laws.
- The store and its page are in [store/](store/): `questions.json` (a cast of six, eleven questions, thirty answers), `rows.json` (193 laws typed from their Lean statements, each by a typer and a skeptic), `build.py` and `template.html`.

### Round 3: the foundation, then the map

- The coordinator's draft ([FOUNDATION-DRAFT.md](FOUNDATION-DRAFT.md)) was put to ten readers: one for each of seven families, one on the tests, one on the words, one against the whole ([round3/](round3/)).
- What stood and what gave way is [FOUNDATION.md](FOUNDATION.md), which the map is built on:
  1. The ground is one web of a few kinds of role and tie. A role is a place in a tie, not a thing.
  2. The unit is a statement about a role or a tie, under a named sameness.
  3. A law says statements in general, in its model's roles, with a frame that says what a case must supply.
  4. A case says statements in particular, in its own words.
  5. They meet in a bridge and a test. A proved law does not fail: a case falls under it or outside it. What fails is a bridge, a measure, a scoring rule or a thesis.
  6. A law's sentence uses role-words only; a case uses its own.
- **One rule of FOUNDATION.md the built map does not keep.** Its point 3 says two models' roles are one place only where a proof joins them, "otherwise two places with a seam between". The map draws roles of two models as one place wherever each model names that kind of role, and says on its page that where no proof joins them the sameness is a reading. Drawing every seam would have needed each pair of models compared; the map instead says, for each tie, how many dynamics its laws come from. The map's page states this as a limit. FOUNDATION.md's role-words ("carriers, share, lock") were also settled differently, in `web.json`.
- The data were then written in two passes, each with a second reader set to refute ([workflows/](workflows/), [map/](map/)):
  - Each of the atlas's 183 dynamics was placed on the web from its Lean statements, in 43 batches. The second readers corrected 148 cards and kept 35.
  - Each of the 66 tests was written as a case from its folder's own record, in 18 batches. The second readers corrected 55 and kept 11.
  - `map/checks.json` keeps every second reader's verdict and its reason. `map/about-the-kinds.json` keeps what the readers said the kinds do not hold.

## Two reviews before landing

Five AI readers reviewed the branch, one angle each: the tool, the truth of the page, the reader, the integration, the record ([review/landing-review.json](review/landing-review.json), 49 findings). After the rework three more read the reworked branch: the code, the truth of the pages, the reader and the record ([review/second-review.json](review/second-review.json), 37 findings). None of them ran tests. What was changed on them:

- **A frozen prediction is placed, not a test.** Each test had been given one square (the "if" met or not, the "then" seen or not). A test's predictions spread over several, so tests whose own records are mixed stood under "they agree". The views now place each frozen prediction that rests on a law or a thesis by its own conditions and outcome, 154 of them, and the field `square` was dropped from `cases.json`. Counted apart: 26 identity checks and checks of a test, 115 entries that name no law or thesis, and 18 entries their records state without a freeze, which now carry `frozen: false`.
- **The sentence beside each corner says what the records hold.** The first rework said of the predictions with the "if" not met and the "then" not seen that the case "marks where the law stops". The records place half of those failures at the bridge. Each corner now gives where its records place the failure.
- **A law keeps its conditions.** The page quoted a law's conclusion without its premises, and the tool dropped the conditions of 16 laws, most of them laws whose premises the atlas keeps under another dynamic. Every quoted law now carries its main conditions, by the name the atlas's ledger gives each. A first attempt to say the ledger's statements without their formulas changed the sense of some ("at least 2 (k + 1)" became "at least 2") and was dropped. Six laws the atlas lists by name alone say that their conditions are in their Lean statements.
- **A law counts once in a place.** 45 Lean laws are written up on more than one card, 28 of them with a different question, strength or "given changed" from card to card, and one stood both as a general law and as a law that needs a given changed in the same section. In a tie or a role a law now counts once, by the write-up of the course itself; 34 write-ups are folded so.
- **A square is filled by a general law only.** A square shown by one built case alone is drawn apart, and a law that says what would follow if something its model takes as given were changed is counted apart. On no drawn tie does a general law show what makes it change.
- **"Lean modules" was wrong.** The count was of name prefixes, not of modules. The page now says how many dynamics a tie's laws come from.
- **Every form of law is shown,** under one list of headings that all the views share, and the laws about one role and on the thinner ties have their sections.
- **The page is one page to read.** The first page went from about 15,300 words to about 3,800: the laws tie by tie, the index of dynamics and the cases moved to three pages it links, and it gained ways in and a short first screen.
- **A dynamic is listed where more of its laws are.** The index had listed 32 dynamics under a tie none of their written-up laws is about; those are now under their role, and each tie's section accounts for every dynamic that speaks of it.
- **A card's note is whole.** It had been cut at 320 characters, which in one case reversed its sense.
- **Wording and filing in the data.** Fifty-one law sentences began in lower case. Two plain sentences said "a promise" and "false confidence" and one dropped a condition; one law's sentence left out that two drawers have no floor. Five Chinese sentences were wrong or garbled, and 偏好 stood eleven times for a rule's favouring, now 偏向. Three laws were re-filed under "where the line falls" (`Tolerance.certified_available_iff`, `Tolerance.worst_start`, `MachineInstances.round_iff`). The mark "changes" was given its sense, "swinging without end" moved to it from "lasts", and the form "more of one gives no less" became "an order that is kept". In `cases.json`, three notes that nothing in a test is taken as a role were moved out of the bridges, and MQ3's F0 was given the condition it tests.

What was left, and why:

- **The Chinese names and sentences** are for Ren. The reader's list of the doubtful ones is in the first review (reader, finding 10): 读法, 所选者, 延续者, 补给者, 读取者 beside 读者, 承载者 beside 携带者, 相与, 住到, 亡 said of stocks.
- **A model's own terms** (worker, reviewer, roster; agents; hearer; taught, tenure, entrants) stay in the sentences of the laws proved on those models. The tool's list of words that fit only a person is short, and the page says so.
- **The question a law is filed under is a reading.** Where two cards read one law under different questions both stand, each with its dynamic; `Diagonal.complete_iff_alike` and `Web.observed_raise_couples` stand as filed.
- **Whether a recorded condition bears on what was scored** is not judged: in LA3 and MQ2 a condition the record marks as failed is one the record also says does not touch the scored quantity, and those predictions stand under "not met, seen anyway".
- **The cards' notes** on what the kinds do not hold keep the atlas's own codes (D48, D65) and say where an entry is an AI reading.
- **The shared navigation line** on GitHub does not name the map yet; the site's does. It touches every front and goes with the short home.
- **The name "map"** still names chapter 02, the repository's `MAP.md` and this map.
- **A familiar name leads to the map only through its ways in**, the find box and the crosswalk. Short articles, one per place, are the next step.

## What the map does not hold

- Every card says what of its dynamic the kinds leave out. The note is shown under each dynamic on the map to operate.
- Roles of two models are drawn as one place where each model names that kind of role. Where no proof joins the models, that sameness is a reading.
- 773 write-ups of 726 Lean laws are on it, where the atlas lists 2,073 with premises.
- A prediction's place rests on the case's reading of its test's record: whether it was frozen, which conditions were met, what was seen.
- The Chinese names and sentences are AI-written and provisional.

## What is next, and Ren's to decide

In the order he approved on 11 November: short articles hung from the map, a short home with the map on it, and a one page of about 500 words. A person's read is the measure of done, his first; nobody outside is asked to read it before he finds it good.

Four decisions are his: where his opening of 10 October sits, a name on an About page, word caps on the entry pages, and the Chinese home and role names in his own words.

## The files

| Path | What it is |
|---|---|
| `WHOLE-PICTURE.md`, `DESIGN.md`, `FOUNDATION.md` | The coordinator's three notes to Ren, as he read them |
| `FOUNDATION-DRAFT.md` | The draft the ten readers were given |
| `readers/` | Eight readers' reports on the public face (round 1) |
| `places/` | The first prototype: the three proposals, the decisions, the drawing's data and code |
| `families/` | Place proposals for seven families, two readers each; not built on |
| `designs/` | Six designers' reports (round 2) |
| `store/` | The second prototype's data and page code |
| `round3/` | Ten readers' reports on the draft foundation |
| `map/` | The batches, the second readers' verdicts, and the readers' notes on the kinds |
| `review/` | The two reviews of the branch before it landed: five readers' reports, then three |
| `workflows/` | The eleven scripts that ran the readers, with their prompts |

The notes and reports are kept as written, so the earlier ones use words the later rounds dropped ("those ahead", "those with a say"), and each of the first two notes states as its answer what the next round gave way on. The prototypes' pages were shown to Ren as private pages and are not kept. Their data are kept, and their code as it ran from a working folder outside the repository: it reads its inputs from paths that differ here, and from the atlas as it stood that morning, so it is a record of how the pages were made and not a way to rebuild them. One link to a private page was cut from `store/template.html`.
