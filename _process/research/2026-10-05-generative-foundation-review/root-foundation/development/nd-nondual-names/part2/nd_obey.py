"""ND part 2: records' live fields saying a case obeys a law now say it satisfies it, as their home sections do since
part 1 (01 §9, 02 §5); the zh of the same field, 服从 → 满足. Quotations, and dominance obeyed by choosers (a
description of people's choices), are kept. One history note per record changed."""
import json, re, glob, sys
EN = [(r'\bobeys\b', 'satisfies'), (r'\bobeying\b', 'satisfying'), (r'\bobeyed\b', 'satisfied'), (r'\bobey\b', 'satisfy')]
KEEP = ('everything obeys', 'dominance is obeyed')
out = []
for p in sorted(glob.glob('theories/becoming/results/records/*.json')):
    text = open(p, encoding='utf-8').read()
    d = json.loads(text)
    hits = []
    def walk(x, path):
        if isinstance(x, dict):
            if isinstance(x.get('en'), str) and re.search(r'\bobey', x['en']) and not any(k in x['en'] for k in KEEP):
                hits.append((path, x['en'], x.get('zh', '')))
            for k, v in x.items():
                if k not in ('history', 'text_versions'):
                    walk(v, path + '.' + k)
        elif isinstance(x, list):
            for i, v in enumerate(x):
                walk(v, path + f'[{i}]')
    walk(d, '')
    if not hits:
        continue
    start = text.index('\n  "history": [')
    head, rest = text[:start], text[start:]
    for path, en, zh in hits:
        new_en = en
        for a, b in EN:
            new_en = re.sub(a, b, new_en)
        new_zh = zh.replace('服从', '满足')
        for old, new in ((en, new_en), (zh, new_zh)):
            if old != new:
                o, n = json.dumps(old, ensure_ascii=False)[1:-1], json.dumps(new, ensure_ascii=False)[1:-1]
                assert head.count(o) >= 1, (p, path)
                head = head.replace(o, n)
        out.append((p.split('/')[-1], path, zh != new_zh))
    end = rest.index('\n  ]')
    entry = json.dumps({'en': '{DAY}, board item ND (study section {N}): a case of a law is said to satisfy it, not to '
                              'obey it, as the home section now reads: a law states what holds of its cases and '
                              'commands nothing (08 §10). What the record states is unchanged.',
                        'zh': '{DAY_ZH}，工作板条目 ND（研究第 {N} 节）：律之例称“满足”其律，不称“服从”，如本节今文：律言其例所成立者，'
                              '不命令什么（08 §10）。记录所言不变。'}, ensure_ascii=False, indent=2)
    entry = '\n'.join('    ' + line for line in entry.split('\n'))
    new = head + rest[:end] + ',\n' + entry + rest[end:]
    e = json.loads(new)
    assert e['history'][:-1] == d['history'], p
    open(p, 'w', encoding='utf-8').write(new)
for o in out:
    print(*o)
