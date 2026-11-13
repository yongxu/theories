# RW: the one map

*AI-written, 11 November 2026, by the coordinator. Ren read each of the three prototypes this folder records; his words are in [the sources record](../../../../../../sources/15-codex-theory-conversations/2026-11-08-representation-to-eight.md#i-would-give-it-probably-just-a-4-11-november-2026).*

On 11 November Ren read the public face and gave it about 4 of 10: hard for a person to read, no map, too many words, the readings unstructured, the concepts still dualistic. The scores near 8 that AI readers had given were dropped as a measure. He asked to understand the whole picture first, and then to make it work. This folder keeps the four rounds that followed, what each one showed to be wrong, and the reviews before each landing.

What stands as [the map](../../../../../../theories/becoming/results/map/THE-MAP.md) is the fourth round's sheet: what happens, drawn on rows that each ask one thing, with paths told on it and tests laid on it (data `sheet.json`, `passages.json`, `paths.json`, `laid.json` in `theories/becoming/results/map/`; tool `tools/research/map_sheet.py`). The third round's map landed first, on 11 November, and Ren found it not good enough; it is kept as the layer under the map, [the laws and tests behind the map](../../../../../../theories/becoming/results/map/LEDGER.md) (data `web.json`, `cards.json`, `cases.json`; tool `tools/research/the_map.py`).

## The rounds

| Round | What was built | What Ren said | What gave way |
|---|---|---|---|
| 1 | A layer of places, and a map of the capture chain: 15 places, with 88 exits, thresholds and joins placed on them | "Yes, extend it", then: is this the right representation? | A place is a combination of answers, and an arrow carried five kinds of law |
| 2 | One store of eleven questions and 193 laws; a web of six roles and a chart | "good - but not good enough"; one map, not a set; reasoning apart from situation; no person-words | It was still several pictures, and its laws were written in one case's words |
| 3 | A foundation, put to ten readers set to break it, then the one map built on what stood | "Yes, build on it", then "Yes, land it"; after reading what landed: "not good enough - review and understand why i said so" | That the root's lines and four marks are the map's whole vocabulary: of 462 laws, 86 fit "if these marks, then that mark" cleanly. And, after it landed: that a filing of laws and tests under kinds is a map |
| 4 | The review of why, then the map redrawn as one sheet of what happens, laying the three rounds on one another | "Yes, redraw it", then, after reading its first path, "Yes, go on" | That what cannot be broken against the Lean is what a person can read: the refuter had taken the place of the score |

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

## Round 4: "not good enough", and the redraw (11 and 12 November)

Ren read the landed map and answered: "not good enough - review and understand why i said so".

**The review.** The coordinator reread the page, the picture and the map to operate as a reader would, and seven AI readers read the same material, one lens each: a cold reader, a reader with a question, reasoning and situation, the craft of maps, the words, the purpose, and one set to break the coordinator's reading ([redraw/why/reports.json](redraw/why/reports.json)). The coordinator's note, which Ren confirmed with "Yes, redraw it", is [redraw/WHY-NOT-GOOD-ENOUGH.md](redraw/WHY-NOT-GOOD-ENOUGH.md). In short:

- **It showed where laws are filed and how many, not what happens.** Its first page had 419 numbers and no sentence of what happens to anything. Its picture's boxes were kinds of noun and its arrows kinds of verb; nothing on it was a condition something can be in, so nothing could move.
- **Each round had replaced the one before.** Round 3 built his three corrections and left out what they corrected: the places of round 1, and the questions and "where a case stands" of round 2. The 89 places proposed for the other families lay unused in `families/`.
- **The refuter had taken the place of the score.** At every step the test had been whether a reader could break it against the Lean, never what a person would now see. What cannot be broken is a filing and a count.
- **Reasoning and situation had become a wall and a tally.** "A case cannot make a proved law wrong" left the reasoning side unable to be wrong, though choosing the model and pairing a case with it are reasoning too.

**The redraw.** One sheet that lays the three rounds on one another. A row is a tie of round 3's web and asks one thing (round 2's questions). A box is one way the answer can stand (round 1's places, and the places proposed for the other families). An arrow is a way from one box to another, with a short tag, a full sentence, and a kind: proved of the course itself; a proved boundary; proved only with something given from outside; shown only in a built example; a reading; one box a case of another. Paths are told on it step by step. Tests are laid on it with what was taken as which box, what the reasoning said, what was seen and what gave way. The working files and every reader's report are in [redraw/made/](redraw/made/):

1. The boxes were written by the coordinator from round 1's fifteen places, the proposals in `families/` and round 2's answers (50 boxes on 14 rows). The readers' earlier placements of the atlas's exits and transitions (`items.json`, 821 placements) gave the first arrows.
2. Four second readers set every arrow then drawn against its Lean statement (`verified.json`): of 54, 37 sentences were corrected, five kinds changed and three arrows moved. The three lower bands were then written by one reader and checked by another (`read-and-fill.json`).
3. Six readers read the drawn sheet: what a person now sees, a person with a question, the words in both languages, everything Ren had asked for and said yes to, the map as a map, and the truth of the paths and tests (`read-and-fill.json`). On them the page came to open with what the map is of, each arrow got a short tag, the paths became told steps with the law one click below, and the three tests were rewritten in the truth reader's words: all three had been tidier than their records.
4. Further readers set the tags against their sentences (`last-read.json`: 45 of 104 corrected) and the told steps against their arrows (`told-check.json`: 15 of 32 corrected, mostly conditions the coordinator had dropped).
5. Ren read the first path on a private page and said "Yes, go on". Then the rows were reordered so that each of the first two paths runs in its own band and the lock reads as a ring on the chart; an arrow that would run under a box became a stub at each end; three more paths, four more tests and the names others gave the boxes were each written by one reader and checked by another (`fill-paths-names.json`, `fill-tests.json`, `fill.log`). The reader who checked the link that closes the ring found that the growth of the uncounted loss is a premise of every law of the lock, given and not derived, locked or not; the arrow, its tag and three steps of the first path now say so. The four new tests came back true to their records and three to five times as long as the first three; four writers cut them to the same grain and four second readers set each short text against the record again (`short-tests.json`, `short.log`). Each test got a sentence or two saying what was seen and what gave way, and each path a short list chosen from the names its boxes carry. The map was moved into `tools/research/map_sheet.py`.
6. Before landing the whole was read once more, by AI readers (`final-zh-code.json`, `final-cold-truth.json`, `final-zh-check.json`, `final-last.json`, `final.log`, `zh-merge.log`). A reader of the code found real faults in the tool (a step standing on "staying at a box" showed the word "undefined"; the number of a step whose arrow leaves the picture was drawn outside it; the validator let through what would crash the render) and each was fixed. The reader of what the coordinator had written that morning returned every one of the seven tests' opening lines corrected, six of the twenty-one names listed under the paths, the opening paragraph, and the count of tests not yet on the map: again the fast text was tidier than what it stood on. Two readers read the Chinese pages through as Chinese and proposed ninety repairs; six more set each against the English, and the Lean where a condition was touched, before any was applied, and found eight English sentences that said more than their laws. A reader who met the page as a stranger said which of Ren's seven complaints still held: the first path had an example on three of eighteen steps and nowhere set out who is who; red for closing and green for the ways out read as bad and good whatever the caption said; "proved" stood unqualified until the foot of the page; the note on what was checked was one paragraph of three hundred words. On that the first path got a cast and the examples its boxes already carried, the groups of a path took hues that do not read as stop and go, a step that is given, built or a reading got a hollow number, the names became links to their boxes with a way in by name, and the note became a table that opens with what a person has read. What the coordinator wrote in doing so went to second readers once more (`final-last.json`): they rewrote eight of the ten entries of the cast, took five of the examples off again, found that "turns for good" at step 9 holds only under two premises the step had not given (a built case on the same path meets the step as it was worded and the lock comes back), redrew two arrows as needing something given from outside, and brought one word for one thing to 180 places in the Chinese.

**What the checked sheet shows.** Of the arrows that run along a row (boundaries and the last band apart), 12 of the 18 that run right are proved of the course itself; of the 20 that run back, 4 are, 14 need something given from outside the course and 2 are shown only in a built example. The four readers who set the first arrows against the Lean each found the same in their own part: closing is by laws of the course itself; ways back are laws for regrowth, for a lapse that passes, and for a loss that has reached what sets the rule in time; every other way back drawn needs something given from outside or is shown only in a built example. The columns were ordered by the coordinator, so the count is of the laws drawn so far on this layout, not a result.

**What is still weak.**

- 31 of the 105 arrows have had one reader against the Lean and no second; each says so. The tags and the told steps were set against the sentences they stand on, not against the Lean again.
- The first path's sentences are still laws said in plain words: the conditions first, then what follows. 7 of its 18 steps carry an example; most of the ways out carry none.
- Solid against dashed marks which premises the map chose to flag as given from outside, not two kinds of proof: the one way out drawn solid also rests on premises (that the rest go on counting the loss, and judge no more in the favoured side's favour than that side does). The first path now says so, in its cast and at step 9.
- The lock reads as a ring on the chart; the other paths read from their numbered steps. On a path's picture a lit arrow carries its number, not what makes the move happen: the tag is one click away.
- The whole sheet is something to choose from, not a picture to read: 105 lines without labels, and the band "A view and how things are" is a knot of arcs over one row.
- Along a row, left to right still runs from open to closed, with the boxes the work wants at the left: the picture carries that order whatever the caption says.
- The page uses ordinary words as fixed terms ("the course", "given from outside", "reads the loss", "laid on", "the pairing"). They are set out once before the first path and are not tied to the glossary.
- The names others gave are selections from the account's readings of other traditions and fields, most of them AI readings of a source recalled, not reread; a name says a place is close to what its source describes, not that the source agrees. Their Chinese forms are not checked against Chinese editions.
- 58 of the 66 tests are not laid, and most of the atlas's 321 exits and 103 transitions are not on the map.
- The Chinese names and sentences are AI-written. Two AI readers read the Chinese pages through and six more checked their repairs; no person has read them through.
- The shared navigation line on GitHub does not name the map yet.

## Round 5: the map says "theorem" (13 November)

On 13 November Ren asked what a law is and said that the words must keep up with the theory. To the question whether the account's proved statements become "theorem" (定理) he answered "Yes, theorem" ([his words](../../../../../../sources/15-codex-theory-conversations/2026-11-13-what-a-law-is-and-the-words.md)). Board item WL carried that through the English reading path ([its note](../wl-theorem-and-law/NOTE.md), with the rule and three decisions made once). This round, board item WM, carries it through the map's data and tools by the same rule, in English and Chinese. No Lean, no new result, no atlas entry changed.

How it was run:

1. Every use of "law" and of 定律 or 律 in the prose fields of the seven data files was tagged: 1,061 uses, 917 English and 144 Chinese (`theorem/verdicts/cands.json`, by file, field and position in the text before the pass). Ids, Lean names, quoted Lean statements and data keys were not tagged.
2. A first AI reader (Opus) for each of 15 units gave every use one of WL's classes (`theorem/verdicts/<piece>.v1.txt`): a proved statement 537, a model's step 281, a governing or negative sentence 152, a named family of theorems 55, a kept name 16, unsure 9, another field's law 8, not proved 3.
3. The coordinator (Fable) read every use of the last six classes in its sentence and decided it (`theorem/decisions.json`). Negatives about the account's statements ("no law here says") say "theorem", as in WL. A family named by its subject is "the X theorems"; "the counting laws" and "the order laws" stay, as the chapters have them. Bridge names and prediction labels that come from the tests' own records stay as the records have them.
4. A second AI reader (Opus) for each of 24 sheets checked every changed use against the question what the thing is, and every kept use for a proved statement left behind (`theorem/second-reading/R*.r1.txt`). Of 735 changes they confirmed 698, called 5 wrong and asked for 32 rewordings; they found none missed among the 326 kept, and questioned 3 of the coordinator's own rewordings. The coordinator decided each. Six uses went back to "law": three inside verbatim quotations of a test's files, one a process's step, and two the arising and ceasing law of `World.law_iff_em`, which WL keeps. The rewordings were taken, a few in other words.
5. In the data, 729 uses changed (614 English, 115 Chinese) in 475 fields and 332 stayed; 74 phrases were then reworded by hand, in 82 fields (`theorem/rewrites.json`).
6. In the tools, the page text, error messages, docstrings and comments of `map_sheet.py`, `map_sheet.html`, `the_map.py` and `the_map.html` changed, by a script that touches text only inside string literals and comments and whose diff the coordinator read; the sentences the two test files pin followed, and 16 test names.

What a swap alone got wrong, kept here because a later pass over records will meet the same:

- **A built case is proved too.** The cards said of a witness "a built case, not a law". "Not a theorem" would be false, so they now say "not a general theorem".
- **"Law of X" has two readings.** Where X is what the statement is about, it is "a theorem on X" or "about X" ("theorems on any process with a balanced stock", "not a theorem about every course"); where X holds it, "of" stays ("a theorem of this dynamic"). "A law of the course itself" became "proved of the course itself", which is what the map's legend says.
- **A theorem does not call, decide, speak or get followed.** "What the law calls best" is "what the theorem gives as best"; "does not decide where such learners end up" is "does not determine"; "a system following the law on 70% of calls" is "a system picking the theorem's plan on 70% of calls".
- **"Proved law" became "theorem"**, not "proved theorem".

Kept on purpose: the data keys `laws` and the arrow kind `law`, the page name `LAWS.md` (a published address), ids of dynamics, records and premises, another field's law ("Goodhart's law", 排中律), and 律 where the cards' Chinese means a model's step.

How far this has been checked: each change in the data was read by two AI readers and, in the doubtful classes, by the coordinator. The tools' strings were changed by script and read as a diff by the coordinator. A last AI reader (Opus) then read that diff, and three more read the rendered pages: the English and the Chinese map page and paths whole, and the page of the layer under the map with parts of its three views (`theorem/final-reading/`). They found no "theorem" that was wrong; two tool strings the script had not reached ("principal laws", written on every section of one page); two places where the script had changed a key's name inside a message; and six sentences to reword, of which five were taken ("every step with the theorem it stands on" became "with what it stands on", since a step that is a reading stands on no theorem) and one was kept as ordinary usage ("the theorem is silent"). No person has read the pass line by line. The two map test files pass (72 tests); the full suite was not run.

Not done: record texts and titles (a card can still cite a record's "law 13"), the atlas's entries and the names of its dynamics, headings on other pages, and the site's one-line way in to the atlas.

## What the layer under the map does not hold

- Every card says what of its dynamic the kinds leave out. The note is shown under each dynamic on the map to operate.
- Roles of two models are drawn as one place where each model names that kind of role. Where no proof joins the models, that sameness is a reading.
- 773 write-ups of 726 Lean laws are on it, where the atlas lists 2,073 with premises.
- A prediction's place rests on the case's reading of its test's record: whether it was frozen, which conditions were met, what was seen.
- The Chinese names and sentences are AI-written and provisional.

## What is next, and Ren's to decide

The rest of the atlas's exits and transitions and of the tests onto the map. Then, in the order he approved on 11 November: a short home with the map on it, and a one page of about 500 words. The short articles of that plan are now the boxes of the map: each has its sentence, its example, the names others gave it, what leads out and what leads in. A person's read is the measure of done, his first; nobody outside is asked to read it before he finds it good.

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
| `workflows/` | The eleven scripts that ran the readers of the first three rounds, with their prompts |
| `redraw/` | Round 4: the note on why the landed map was not good enough, the seven readers' reports (`why/`), and how the redrawn map was made (`made/`: the working data and code as they ran, every reader's report, the scripts that ran the readers) |
| `theorem/` | Round 5: the first readers' verdicts on every use of "law" in the map's data (`verdicts/`), the second readers' findings (`second-reading/`), the last readers' (`final-reading/`), the coordinator's decisions and hand rewordings (`decisions.json`, `rewrites.json`), and the scripts and briefs as they ran (`kit/`; they name this machine's working folders and are a record, not a tool to run as they stand) |

The notes and reports are kept as written, so the earlier ones use words the later rounds dropped ("those ahead", "those with a say"), and each of the first two notes states as its answer what the next round gave way on. The prototypes' pages were shown to Ren as private pages and are not kept. Their data are kept, and their code as it ran from a working folder outside the repository: it reads its inputs from paths that differ here, and from the atlas as it stood that morning, so it is a record of how the pages were made and not a way to rebuild them. One link to a private page was cut from `store/template.html`.
