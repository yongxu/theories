#!/usr/bin/env python3
# AI-written, 13 November 2026. Adds Round 5 (the map says "theorem") to the map's record and the folder's row to its table.
import sys
R = sys.argv[1] + '/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rw-one-map/README.md'
t = open(R, encoding='utf-8').read()
assert '## Round 5' not in t
SEC = '''## Round 5: the map says "theorem" (13 November)

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

'''
anchor = '## What the layer under the map does not hold'
assert t.count(anchor) == 1
t = t.replace(anchor, SEC + anchor)
row_anchor = '| `redraw/` | Round 4:'
assert t.count(row_anchor) == 1
i = t.index(row_anchor); j = t.index('\n', i)
row = '\n| `theorem/` | Round 5: the first readers\' verdicts on every use of "law" in the map\'s data (`verdicts/`), the second readers\' findings (`second-reading/`), the last readers\' (`final-reading/`), the coordinator\'s decisions and hand rewordings (`decisions.json`, `rewrites.json`), and the scripts and briefs as they ran (`kit/`; they name this machine\'s working folders and are a record, not a tool to run as they stand) |'
t = t[:j] + row + t[j:]
open(R, 'w', encoding='utf-8').write(t)
print('ok')
