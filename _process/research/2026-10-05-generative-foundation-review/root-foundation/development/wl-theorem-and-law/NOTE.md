# WL: the account's proved statements are called theorems

*AI-written, 13 November 2026 (board item WL). What was decided, how the first pass over the English reading path was run, and what later passes over other text should follow. No new Lean and no new result.*

## What Ren asked, and his answer

On 13 November 2026 Ren asked what a law is, said that "the words we use needs to keep up with our standard like our theory", and asked that the dualist words be fixed "wisely, but first we need to understand the picture". A sample measured the word's uses; one decision was put to him: do the account's proved statements become "theorem" (定理)? He answered "Yes, theorem" ([his words](../../../../../../sources/15-codex-theory-conversations/2026-11-13-what-a-law-is-and-the-words.md)). The earlier answer, of 1 November 2026, had kept the word and defined it ([the study on laws of nature](../ln-laws-of-nature/NOTE.md)); this item reverses that entry.

## The rule

It is stated in [chapter 08 §10](../../../../../../theories/becoming/chapters/08-METHOD.md#law) and in the [glossary](../../../../../../GLOSSARY.md) rows "theorem" and "law".

- **Theorem (定理)**: one of the account's own proved statements.
- **Law (律)** stays for four things:
  - `Law`, a determined step: one next for each configuration ("a determined law", "under a law", "its own law", "a law that reads or keeps or merges").
  - What holds in every model of a class, the thing a completeness or counting theorem counts ("the premises add at most one law", "the laws of one step", "counting laws", "no law that holds of every net", "no law of the dynamics ranks").
  - A science's law, a probability law, law in the legal sense.
  - Something not proved that is put as a regularity ("one law across domains, conjectured").
- **Names given before the change keep the word for now**: "shared law" (共律), "law 5", record titles and ids, headings, data keys and file names.

Three decisions made once, for a pass over other text to follow:

1. **Negatives split by what they count.** "No law evaluates", "no law here says" and "the laws weigh them for no one" speak of the account's statements, and say "theorem". "No law of the dynamics …", "no law of every net …" and "no law of the grammar" count what holds, and keep "law". Three sets of independent AI readers held these apart.
2. **A theorem named by its subject is "the X theorem"** ("the selection theorems", "the timing theorem"). "Law of X" becomes "theorem on X" where X is the subject ("a theorem on one optimizer"), and "theorem of X" only where X owns it ("a theorem of the root").
3. **Where the thing called a law is a condition a model meets, a count equation or a rule that chooses, it stays "law"** ("the count law", "order laws", "the worth law", the arising–ceasing law of `World.law_iff_em`).

## How the pass was run

1. The reading path (the glossary, the one page, the overview, the two uses pages, COLLECTIVE-DIRECTION, FREE-ENERGY-PRINCIPLE, ONE-ARGUMENT, chapters 01 to 05, 07 and 08; not 02 §11) was split into 56 pieces. Every use of "law" outside code, links, headings and quotations was tagged: 1,540 uses (`verdicts/<piece>.cands.json`, by line and column of the text before the pass).
2. A first AI reader (Opus) for each of 38 units gave every use a class: A proved statement, G a governing or negative sentence, B a step, C another field's, D a kept name, E what holds in every model of a class, N a named theorem, T not proved, W about the word, U unsure (`verdicts/<piece>.v1.txt`; the brief is `kit/brief-first-reader.js.txt`). Counts: A 563, B 550, N 142, G 103, U 54, C 46, D 34, T 24, E 18, W 6.
3. The coordinator (Fable) read every G, N, U, T and W use in its sentence and decided it (`decisions/decisions.json`, `manual.json`).
4. A second AI reader (Opus) for each of 21 sheets checked every use that was to change, 802 at that point, against the question what the thing is (`kit/brief-second-reader.js.txt`): 741 confirmed, 15 called wrong, 46 to reword, 7 missed (`second-reading/R*.r1.txt`). The coordinator decided each finding: the wrong ones went back to "law", with the uses of the same kind beside them; the rewordings were taken, three in other words and four not (`decisions/post.json`, `of-on.json`).
5. Outcome: 770 uses became "theorem", two became "statement" and 768 stay "law"; 542 lines changed in 15 files, and four link texts with them. A mechanical check (`kit/pieces.py check`) held code, links, anchors, headings, Chinese text and quotations fixed; five waivers are listed (`decisions/waive.json`: four link texts changed on purpose, one false alarm).
6. The changed sentences were followed into what holds them word for word (`kit/follow.py`, `kit/follow2.py`): strings in `navigation.py`, `spine.py`, `connection_map.py`, `theory_graph.py`, `test_uses_pages.py` and `test_spine.py`, phrases quoted by `spine.json` and `lineage.json`, 74 atlas quotes, and 38 quotations in the review packet's dossiers. 128 records whose cited sections changed were re-pointed, hash only. The first gate run found the dossiers and eight test pins unfollowed; they were followed and the run repeated.
7. One sentence of the uses page that copies chapter 08 ("Goodhart's law as one law of the optimum under room") went back to "law", as 08 has it: the first reader had sorted the two copies differently.

The scripts in `kit/` are kept as they ran; they name this machine's scratch folders and are a record, not a tool to run as they stand.

## How far this has been checked

Each change was read by two AI readers and, for the doubtful classes, by the coordinator. No person has read the pass line by line. A kept "law" that names a theorem is possible among the 550 uses the first reader sorted as steps, since the second reader checked what changed, not what stayed.

## Not done in the first landing

- The ten headings on the reading path that carry the word, record titles and texts, the records' key `laws`, link texts (four excepted).
- 02 §11, the map's data, OPENING.md, chapter 06 and the Chinese pages (the Chinese glossary rows are done; the Chinese fronts carry their dated banner behind the English).
- Tool messages in `boundary.py` and its tests ("grammar laws").

## The second part (WL2, 13 November 2026)

*AI-written. After the first landing Ren wrote "always be careful and we're aiming … the full picture and where the things can be" and "Feel free to push, no need to ask" (the same source file). The first landing was pushed, and this part took what a visitor reads first.*

1. **The kept uses, read a second time.** The first landing's second readers had checked what changed, not what stayed. 21 AI readers (Opus) then read all 750 kept uses against the question whether the thing is a proved statement (`second/kit/brief-kept-reader.js.txt`): 732 confirmed, 18 called theorems, 10 notes (`second/kept/K*.k1.txt`). Taken: 12 phrases, among them "the uniform theorem on support passing on", "the general theorem", three link texts, "premises" for the hypotheses a World meets, and "The theorems reach" for "The proved theorems reach". Not taken: the category label "laws of their models" and a record's title, which wait for the records; "one law of the optimum under room", which 08 and the uses page share and which names a claimed unification.
2. **Four headings** that name theorems now say so ("Theorems on every model", "The optimum: one theorem, its cases", "What the theory's own theorems rule out", "Exits and design theorems"); each old anchor is kept beside the new one. Three headings keep "law" because the thing is not a theorem ("Counting: one law and its cases", "Laws of one step", "Two courses of one law"), one is a kept name ("Shared laws and connectivity"), and "Laws along a run" is the step sense.
3. **The opening** (`theories/becoming/OPENING.md`, placed in README.md at render), in its author's first person and revised in place since 31 October: 54 of its 73 uses changed, each decided by the coordinator, then read by three AI readers with different questions (the claim, the reader at the front door, the rule; `second/opening-three-readers.json`). Eight of their findings were taken; the revision is item 13 of the opening's list of revised passages (`drafts/2026-10-10-opening/README.md`). README.md went from 101 uses of "law" to 43, all of them a science's law, a step, the spine's "first law" or something not proved.
4. **The class of central declarations proved by counting** is "counting theorems" on the pages, in `spine.py` and its test. "Counting laws" stays where it means what holds of every census (01 §9.5).
5. **The Chinese fronts** (`GLOSSARY.zh.md`, `ONE-PAGE.zh.md`, `THE-THEORY-OF-BECOMING.zh.md`, `USES.zh.md`, `USES-EXAMPLES.zh.md`, `OPENING.zh.md`, and the landing page's template) were brought to their English: one AI reader carried each numbered English change into the Chinese (律 to 定理 where the English says theorem), a second checked every edit and every 律 and 定理 left on the page against the English (`second/chinese-carry-and-verify.json`; 10 findings, all taken). The editions are recorded as revised, and the dated banner is gone.
6. 62 records whose cited sections changed were re-pointed, hash only.

How far this has been checked: as the first part, by AI readers and the coordinator; no person has read it line by line. The Chinese was written and checked by AI readers; the author's first language is Chinese and he has not read these edits.

## What still says "law" of a theorem, measured on 13 November 2026

| Where | Uses | What a pass there has to carry |
|---|---|---|
| The records' public text (486 of 565 records; fields `laws`, `dependencies`, `hypotheses`, `does_not_show`, `correspondence`, `related`, `statement`, titles) | 4,706 in English, about as many 律 in the Chinese twins | Record pages, RESULTS.md, GOALS.md and DEPENDENCIES.md are rendered from them; `spine.json` quotes record items; the map's cards and the atlas quote hypotheses; the category label "laws of their models" lives in `shared-laws.json`. The records' `history` field (3,839 uses) is a record of its time and stays. |
| The atlas's entries (`correspondences.json`, `dynamics.json`, `premises.json`, `correspondence_groups.json`) | about 9,000 | The atlas's pages are rendered from them; quotes of other sources must stay verbatim. |
| The Lean package's comments and docstrings (403 files) | about 6,200 | Changing a Lean file's bytes needs a core run and the records' proof bindings re-bound to its receipt. `Law` and every declaration name stay. |
| Chapter 06 (Chinese, classical) | 234 律 | Whether a classical 律 in the account's own voice is 定理 is a question of its own. |
| Studies, plans and history under `_process/` and `theories/becoming/history/` | many | Records of their time; not to be changed. |
