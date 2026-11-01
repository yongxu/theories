"""ND part 2: the live texts naming the core's renamed declarations, in a tree (argv[1]).

Names are renamed wherever written qualified or bare (Good, GoodEnabled, good and obey only qualified, as
ReadingLoop.Good or CountsHold.obey); a record's history and text versions are kept as they are, and each record
changed gets one history note in both languages, its date and study section left as {DAY}, {DAY_ZH} and {N} for the
landing to fill. A few prose phrases that state a harm or an obeying go with the names."""
import json, re, sys
from pathlib import Path

T = Path(sys.argv[1])
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
BARE = {
    'ListingObeys': 'ListingMarksHold', 'listingObeys_of_obeys': 'listingMarksHold_of_marksHold',
    'table_obeys': 'table_marks_hold', 'table_obeys_free': 'table_marks_hold_free',
    'census_table_obeys': 'census_table_marks_hold', 'census_table_obeys_free': 'census_table_marks_hold_free',
    'census_table_obeys₂': 'census_table_marks_hold₂', 'census_table_obeys₃': 'census_table_marks_hold₃',
    'CountsObey': 'CensusMarksHold', 'countsHold_of_obey': 'countsHold_of_marks',
    'StandsObey': 'StandingMarksHold', 'standsObey_iff': 'standingMarksHold_iff', 'DependsObey': 'DependenceMarksHold',
    'harms_superadditive': 'rises_superadditive', 'difference_belongs_to_the_joint': 'difference_only_together',
    'keeps_of_good': 'keeps_of_leadsInto', 'good_of_keeps': 'leadsInto_of_keeps', 'keeps_iff_good': 'keeps_iff_leadsInto',
    'everything_good_iff': 'everything_leadsInto_iff', 'nothing_good': 'nothing_leadsInto',
    'GoodEnabled': 'LeadsIntoEnabled',
}
QUALIFIED = {'ReadingLoop.Good': 'ReadingLoop.LeadsInto', 'ReadingLoop.good': 'ReadingLoop.avoids',
             'CountsHold.obey': 'CountsHold.marks'}
ID = r"[A-Za-z0-9_'₀-₉!?]"


def rename(text):
    for old in sorted(QUALIFIED, key=len, reverse=True):
        text = re.sub(rf"(?<!{ID}){re.escape(old)}(?!{ID})", QUALIFIED[old], text)
    for old in sorted(BARE, key=len, reverse=True):
        text = re.sub(rf"(?<!{ID}){re.escape(old)}(?!{ID})", BARE[old], text)
    return text


PROSE = {
    LEAN + 'README.md': [('the counts of the two censuses obey the same properties',
                          'the counts of the two censuses satisfy the same properties'),
                         ('harms super-additive up to one unit where', 'the rises at the point super-additive up to one unit where')],
    LEAN + 'README.zh.md': [('损害在一单位之内超可加', '点上之升在一单位之内超可加')],
}
DOCS = ['theories/becoming/chapters/02-MAP.md', 'theories/becoming/chapters/03-KNOWING.md',
        'theories/becoming/chapters/05-COLLECTIVES.md', 'theories/becoming/chapters/06-CLASSICAL-TEXTS.md',
        'theories/becoming/COLLECTIVE-DIRECTION.md', 'theories/becoming/review/CLASSICAL-TEXTS.md',
        RF + 'development/ue8-sciences-dossier/SCIENCES.md', LEAN + 'README.md', LEAN + 'README.zh.md',
        RF + 'DECIDABILITY-INVENTORY.md', RF + 'DECIDABILITY-INVENTORY.zh.md', RF + 'DECIDABILITY-INVENTORY.py',
        RF + 'THEOREM-CONNECTIVITY-APART.json']
RECORDS = ['a-reading-kept-by-its-update', 'counting-standing-and-dependence', 'counting-under-enclosure',
           'counting-where-the-counts-exist', 'joint-difference-making', 'margin-of-a-regime', 'whole-law-of-counting']

changed = []
for rel in DOCS:
    p = T / rel
    text = p.read_text(encoding='utf-8')
    new = rename(text)
    for a, b in PROSE.get(rel, []):
        if b in new and a not in new:
            continue
        assert new.count(a) == 1, (rel, a)
        new = new.replace(a, b)
    if new != text:
        if rel.endswith('.json'):
            json.loads(new)
        p.write_text(new, encoding='utf-8')
        changed.append(rel)


def note(names):
    listed = ', '.join(f'{o} → {n}' for o, n in names)
    return {'en': '{DAY}, board item ND (study section {N}): declarations renamed so that each name states what it '
                  'means, not a command, a value or an ownership: ' + listed + '. The statements are kept but for '
                  'the names; the claim is unchanged.',
            'zh': '{DAY_ZH}，工作板条目 ND（研究第 {N} 节）：声明更名，使名言其所指，不言命令、价值或所有：' + listed
                  + '。陈述除名外不变；论断不变。'}


for rid in RECORDS:
    p = T / f'theories/becoming/results/records/{rid}.json'
    text = p.read_text(encoding='utf-8')
    d = json.loads(text)
    start = text.index('\n  "history": [')
    end = text.index('\n  ]', start)
    head, hist, tail = text[:start], text[start:end], text[end:]
    new_head, new_tail = rename(head), rename(tail)
    olds = sorted({m for m in re.findall(r'[\w.₀-₉]+', head) if rename(m) != m})
    names = sorted({(m.split('.')[-2] + '.' if m.count('.') and m.split('.')[-1] in ('Good', 'good', 'obey') else '')
                    + m.split('.')[-1] for m in olds})
    names = [(o, rename(o)) for o in names]
    entry = json.dumps(note(names), ensure_ascii=False, indent=2)
    entry = '\n'.join('    ' + line for line in entry.split('\n'))
    new = new_head + hist + ',\n' + entry + new_tail
    e = json.loads(new)
    assert e['history'][:-1] == d['history'] and e.get('text_versions') == d.get('text_versions'), rid
    p.write_text(new, encoding='utf-8')
    changed.append(rid + ' (' + ', '.join(o for o, _ in names) + ')')
print('\n'.join(changed))
