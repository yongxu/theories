#!/usr/bin/env python3
"""RF, the tests' designs (31 October 2026): re-point the plan reference of the records that cite PLAN.md, after
reading the change against each record (an independent reader checked every record against the new plan).
Run from the checkout root: python3 -B repoint_plan.py SECTION [--apply]

For a record whose last history note is this item's amendment (study section SECTION), the re-pointing is added to
that note; for any other, a note of its own is appended."""
import hashlib, json, sys

PLAN = ('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
        'rf-formations-that-read/PLAN.md')
IDS = ['a-prediction-read-by-what-it-predicts', 'a-reading-informed-and-revalued', 'a-reading-kept-by-its-update',
       'a-revision-that-opens-a-correction', 'acts-alike-from-a-model-or-from-an-order', 'readers-reading-readers',
       'what-a-course-chosen-through-its-model-does-not-test', 'what-choices-show-of-an-order',
       'what-holding-for-a-reading-is-worth', 'what-readings-fix-of-the-unread', 'when-complying-when-read-is-best']

section, apply = sys.argv[1], '--apply' in sys.argv[2:]
h = hashlib.sha256(open(PLAN, 'rb').read()).hexdigest()
ADD_EN = (' PLAN.md re-pointed: since this record\'s reviewed hash the plan changed only where the tests\' readers found '
          'it misstating the Lean (§3, §4, §8, §11, §12) and in §10, the tests; read against this record before '
          're-pointing, nothing it says changed.')
ADD_ZH = '计划 PLAN.md 重新指向：自本记录所审哈希以来，计划只于检验之读者见其误述 Lean 之处（§3、§4、§8、§11、§12）及 §10 诸检验而变；重新指向前已对本记录读之，其所言无一改变。'
NOTE_EN = (f'31 October 2026, board item RF, the tests\' designs (study section {section}):' + ADD_EN)
NOTE_ZH = f'2026年10月31日，工作板条目 RF，诸检验之设计（研究第 {section} 节）：' + ADD_ZH
for i in IDS:
    f = f'theories/becoming/results/records/{i}.json'
    d = json.load(open(f))
    n = 0
    for r in d['references']:
        if r['path'] == PLAN and r['sha256'] != h:
            r['sha256'] = h
            n += 1
    assert n == 1, (i, n)
    last = d['history'][-1]
    if f'study section {section})' in last.get('en', '') and 'board item RF, the tests' in last.get('en', ''):
        assert 'PLAN.md re-pointed' not in last['en'], i
        last['en'] += ADD_EN
        last['zh'] += ADD_ZH
        how = 'note extended'
    else:
        d['history'].append({'en': NOTE_EN, 'zh': NOTE_ZH})
        how = 'note appended'
    if apply:
        open(f, 'w').write(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print(i, how)
print('applied' if apply else 'dry run')
