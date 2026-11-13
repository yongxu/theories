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
