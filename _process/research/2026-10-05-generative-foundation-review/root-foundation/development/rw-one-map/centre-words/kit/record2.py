#!/usr/bin/env python3
# AI-written, 13 November 2026. WM2's second part in the map's record: the front pages' paragraph under Round 6, the
# record's table row, and the readers' reports, the scripts and the old-and-new sheets copied into centre-words/.
#   record2.py <root>
import json, os, shutil, sys
root = sys.argv[1]
D = root + '/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rw-one-map'
R = D + '/README.md'
K = '/Users/ren/tmp/rw/wm2'
S = '/Users/ren/theories/tmp/r7/sheet/wm2'
W = '/Users/ren/.claude/projects/-Users-ren-theories/d9ccfc76-7843-4b3c-ba5b-c950965917c6/workflows/scripts'
N = json.load(open(K + '/counts-fronts-n.json'))
t = open(R, encoding='utf-8').read()
assert '### The front pages (WM2' not in t

old_bullet = ("- The front pages' questions of a selection are drafted and not applied (`centre-words/fronts-drafts-not-applied.md`); they are the second part of WM2.\n")
new_bullet = ("- The front pages' questions of a selection were drafted in this part and not applied (`centre-words/fronts-drafts-not-applied.md`); the second part, below, applied them.\n")
assert t.count(old_bullet) == 1
SEC = new_bullet + '''
### The front pages (WM2's second part, the same day)

The front pages asked of any selection "what does it read or need; what lies beyond that; can it do better on what it reads by lowering what lies beyond; can its rule lock on what it already selected", and of a judge "who reads the loss, and when". They now ask it in the centre paragraph's words, in English and Chinese. Words only: no link, anchor, record or Lean changed.

- **Where.** The README's first screen (its sentence of the centre, the things to ask, the two clauses on what is proved); `USES.md` (the things to ask); `USES-EXAMPLES.md` (the sentence that introduces them, the labels of the first, second and fifth in both audits and in the sheet, one phrase in the page's header); `MAP.md` (one clause); the one page's table (the head of its second group of rows and the plain lines of three results, which `tools/research/navigation.py` holds word for word for the register's way in); and their Chinese in the README's Chinese template, `USES.zh.md`, `USES-EXAMPLES.zh.md` and `ONE-PAGE.zh.md`, whose table and lake glossary keep their own structure. %(en_edits)d English edits at %(en_places)d places in %(en_files)d files and %(zh_edits)d Chinese edits at %(zh_places)d places in %(zh_files)d files (`centre-words/fronts-old-new.md`). Seven stated reading times follow the pages' new lengths (`kit/times.py`).
- **The name.** "The four questions" now names AGENTS.md's four questions for a sentence or a picture (08 §1). The pages say "four things to ask" and "a fifth"; `tools/research/the_map.py` says "four marks" for begins, lasts, changes, ends.
- **How it was run.** Drafts during the first part. A first applied version, by the coordinator (`kit/fronts-v1.py`, `fronts_zh-v1.py`), was read by four AI readers: one against the Lean and the records, one checking the Chinese against the English and the Chinese of the centre, and one cold reader in each language (`readers/check4-*.md`). A second version (`fronts-v2.py`, `fronts_zh-v2.py`) was read by two (`check5-*.md`), and the last (`fronts.py`, `fronts_zh.py`) by one (`check6-confirm.md`).
- **What the readers found wrong in those versions.**
  - Room was asked as "every allowed outcome that leaves more of what makes none". "More" had no second end, and it read as a total where `Optimum.Room` compares two outcomes at one condition. The next version said "beaten", which also reads as "higher in total", from which the theorem does not follow. The pages now ask it as the Lean's `Exceeds` has it: "wherever one allowed outcome leaves any of what makes none higher than another does, is some allowed outcome no lower than the first on anything that makes a difference and higher on something?"
  - The one page's row said "an order rising with what makes a difference, whatever it counts after". What an order counts after does make a difference to it. The clause is gone, and the row says "to the selector" once.
  - The first screen's sentence of the centre said only that "something is used up", less than the centre it names. The next version's "so long as the loss makes no difference" could be read as a condition that the model with a need never meets, since whether the need is met always makes a difference (`TurningInTime`). It now reads "while something is being used up, even what sustains it, for as long as how much is left makes no difference to it".
  - The lock clauses lacked "only" and the locked start, and "at each update" could be read as every step, where the rule is set again only at the steps of a schedule.
  - A cold Chinese reader took "whose judgment" for the stakeholders'. The first screen and the uses page now say "among those its verdict is made from"; the audit labels stay short.
  - `USES-EXAMPLES.md` said theorems answer the third thing. Whether there is room is a premise only the pipeline settles, as the same page says further down; the sentence now says what the theorems give "where their premises hold".
- **Left as it was, with the reason.** "How much it weighs in the verdict" for the fifth thing (the old question had the same gap; the sheet's row and the second audit state the counts). "(Argued)" after "forms within becoming too" (the sentence states the direction the work holds; its second half now says "the theorems about the dynamics alone"). "The five questions as a sheet" (the things asked are questions; only the name of four was freed). What `the_map.py` counts under a mark (loose before; only the word changed). "Allowed" on the first screen against "eligible" in the one page's rows (the rows keep their records' word). "Such a loop" in the ranking sentence (as old). The one page's line 7, where "it" and "that one" can be taken two ways, belongs to board item DW and was passed to its session.
- **What is still weak.** The sentences are longer: the one page's row on room has 65 words where it had 35, its row on the lock 40 where it had 19, and room's question stands in full on three pages. AI readers have read them; no person has. Under the new audit labels the paragraphs still say "reads", "lies beyond" and "drains" (DW's count of "read" takes them). In the audit labels "the loss" has no antecedent of its own.

'''
t = t.replace(old_bullet + '\n', SEC % N)
old_row_end = ('the first path as it stood before (`first-path-before.txt`) and the front drafts not yet applied. '
               'The scripts name this machine\'s working folders and are a record, not a tool to run as they stand |')
new_row_end = ('the first path as it stood before (`first-path-before.txt`); for the front pages (the second part), the drafts of the first part (`fronts-drafts-not-applied.md`), '
               'every changed string old and new in its three versions (`fronts-v1-old-new.md`, `fronts-v2-old-new.md`, `fronts-old-new.md` as landed), the three versions as scripts with the stated times '
               'and the readers\' briefs (`kit/fronts*.py`, `kit/times.py`, `kit/brief-fronts-*.js.txt`) and the readers\' reports (`readers/check4-*.md`, `check5-*.md`, `check6-confirm.md`). '
               'The scripts name this machine\'s working folders and are a record, not a tool to run as they stand |')
assert t.count(old_row_end) == 1
t = t.replace(old_row_end, new_row_end)
open(R, 'w', encoding='utf-8').write(t)

C = D + '/centre-words'
copies = [(S + '/check4-english-homes.md', C + '/readers/check4-english-homes.md'), (S + '/check4-cold-english.md', C + '/readers/check4-cold-english.md'),
          (S + '/check4-chinese-check.md', C + '/readers/check4-chinese-check.md'), (S + '/check4-cold-chinese.md', C + '/readers/check4-cold-chinese.md'),
          (S + '/check5-english.md', C + '/readers/check5-english.md'), (S + '/check5-chinese.md', C + '/readers/check5-chinese.md'),
          (S + '/check6-confirm.md', C + '/readers/check6-confirm.md'),
          (S + '/fronts-v1-old-new.md', C + '/fronts-v1-old-new.md'), (S + '/fronts-v2-old-new.md', C + '/fronts-v2-old-new.md'), (S + '/fronts-final-old-new.md', C + '/fronts-old-new.md'),
          (K + '/fronts-v1.py', C + '/kit/fronts-v1.py'), (K + '/fronts-v2.py', C + '/kit/fronts-v2.py'), (K + '/fronts.py', C + '/kit/fronts.py'),
          (K + '/fronts_zh-v1.py', C + '/kit/fronts_zh-v1.py'), (K + '/fronts_zh-v2.py', C + '/kit/fronts_zh-v2.py'), (K + '/fronts_zh.py', C + '/kit/fronts_zh.py'),
          (K + '/times.py', C + '/kit/times.py'), (K + '/record2.py', C + '/kit/record2.py'),
          (W + '/wm2-fronts-check-wf_4df8861e-105.js', C + '/kit/brief-fronts-first-round.js.txt'),
          (W + '/wm2-fronts-final-check-wf_c5b0aade-b81.js', C + '/kit/brief-fronts-second-round.js.txt'),
          (W + '/wm2-fronts-confirm-wf_f58a0408-5ac.js', C + '/kit/brief-fronts-confirmation.js.txt')]
for a, b in copies:
    assert os.path.exists(a), a
    assert not os.path.exists(b), b
    shutil.copyfile(a, b)
print('record updated;', len(copies), 'files copied')
