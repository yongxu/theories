"""The 中华本 as a structure of parts and 條, with symbolic cross-references (board item ZH).

    python3 -I book.py parse BOOK.md OUT.json       # parts and 條; every 條 reference becomes ⟦id⟧
    python3 -I book.py apply IN.json PLAN.json OUT.json
    python3 -I book.py render IN.json BOOK.md        # number the 條 in order, write the references back

A 條 keeps the id it had when parsed (三·七) as its key for the whole restructuring; references in any text are
written ⟦三·七⟧ and rendered with the 條's number after the plan. A plan is a list of operations, each with its
reason: move a 條 to a part after a given 條 (or to the start); delete a 條, sending references to the 條 that
keeps its content; add a 條 (title and text) after a given 條; retitle a part. Nothing else changes a text: the
edits inside a 條 are applied separately as exact replacements (assemble.py's rule).
"""
import json, re, sys

NUM = '零一二三四五六七八九十'
PREFIX = {'C16': '凡', 'TH': '纲'}
ORDER = ['C16', 'C01', 'C02', 'C03', 'C04', 'C05', 'C06', 'C07', 'C17', 'C08', 'C09', 'C10', 'C11', 'C12', 'C13',
         'C14', 'C15', 'TH']
PIAN_NO = {'C01': '一', 'C02': '二', 'C03': '三', 'C04': '四', 'C05': '五', 'C06': '六', 'C07': '七', 'C17': '八',
           'C08': '九', 'C09': '十', 'C10': '十一', 'C11': '十二', 'C12': '十三', 'C13': '十四', 'C14': '十五',
           'C15': '十六'}
REF = re.compile(r'(?<![一二三四五六七八九十凡纲·])((?:凡|纲|[一二三四五六七八九十]{1,3})·[一二三四五六七八九十]{1,3})(?![一二三四五六七八九十])')


def cn(n):
    """1..99 in Chinese numerals as the book writes them (十, 十一, 二十, 二十一)."""
    t, u = divmod(n, 10)
    return (('' if t == 1 else NUM[t]) + '十' if t else '') + (NUM[u] if u else '')


def prefix(key):
    return PREFIX.get(key) or PIAN_NO[key]


def parse(md):
    head, rest = md.split('\n## 凡例', 1)
    rest = '## 凡例' + rest
    body, tail = rest.split('\n## 附录一', 1)
    tail = '## 附录一' + tail
    parts = []
    for chunk in re.split(r'\n(?=## )', body.strip()):
        heading = chunk.split('\n', 1)[0][3:]
        key = 'C16' if heading.startswith('凡例') else 'TH' if heading.startswith('论纲') else \
            next(k for k, v in PIAN_NO.items() if heading.split('　')[0] == '篇' + v)
        text = chunk.split('\n', 1)[1] if '\n' in chunk else ''
        dz = ''
        if '\n#### 对照' in text:
            text, dz = text.split('\n#### 对照', 1)
            dz = '#### 对照' + dz
        pieces = re.split(r'\n(?=### )', '\n' + text)
        intro = pieces[0].strip()
        tiao = []
        for p in pieces[1:]:
            h, b = (p.strip().split('\n', 1) + [''])[:2]
            m = re.match(r'### (\S+?)　(.*)$', h)
            tiao.append({'id': m.group(1), 'title': m.group(2), 'body': b.strip()})
        parts.append({'key': key, 'heading': heading, 'intro': intro, 'tiao': tiao, 'duizhao': dz.strip()})
    ids = {t['id'] for p in parts for t in p['tiao']}

    def sym(s):
        return REF.sub(lambda m: '⟦%s⟧' % m.group(1) if m.group(1) in ids else m.group(1), s)
    head, tail = sym(head), sym(tail)
    for p in parts:
        p['intro'], p['duizhao'] = sym(p['intro']), sym(p['duizhao'])
        for t in p['tiao']:
            t['title'], t['body'] = sym(t['title']), sym(t['body'])
    return {'head': head, 'parts': parts, 'tail': tail, 'redirect': {}}


def find(book, tid):
    for p in book['parts']:
        for i, t in enumerate(p['tiao']):
            if t['id'] == tid:
                return p, i
    raise KeyError(tid)


def apply(book, plan):
    parts = {p['key']: p for p in book['parts']}
    for op in plan:
        if op['op'] == 'move':
            p, i = find(book, op['id'])
            t = p['tiao'].pop(i)
            q = parts[op['to']]
            j = 0 if op.get('after') in (None, '', 'start') else find(book, op['after'])[1] + 1
            if op.get('after') not in (None, '', 'start') and find(book, op['after'])[0] is not q:
                raise ValueError('after %s is not in %s' % (op['after'], op['to']))
            q['tiao'].insert(j, t)
        elif op['op'] == 'delete':
            p, i = find(book, op['id'])
            p['tiao'].pop(i)
            book['redirect'][op['id']] = op['keep']
        elif op['op'] == 'add':
            q = parts[op['to']]
            j = 0 if op.get('after') in (None, '', 'start') else find(book, op['after'])[1] + 1
            q['tiao'].insert(j, {'id': op['id'], 'title': op['title'], 'body': op['body'], 'added': True})
        elif op['op'] == 'retitle':
            parts[op['part']]['heading'] = op['heading']
        else:
            raise ValueError(op)
    return book


def numbering(book):
    num = {}
    for p in book['parts']:
        for i, t in enumerate(p['tiao'], 1):
            num[t['id']] = '%s·%s' % (prefix(p['key']), cn(i))
    for old, new in book['redirect'].items():
        while new in book['redirect']:
            new = book['redirect'][new]
        num[old] = num[new]
    return num


def render(book):
    num = numbering(book)
    missing = set()

    def out(s):
        def r(m):
            if m.group(1) not in num:
                missing.add(m.group(1))
                return m.group(1)
            return num[m.group(1)]
        return re.sub(r'⟦([^⟧]+)⟧', r, s)
    lines = [out(book['head']).rstrip(), '']
    for p in book['parts']:
        lines += ['## ' + out(p['heading']), '']
        if p['intro']:
            lines += [out(p['intro']), '']
        for t in p['tiao']:
            lines += ['### %s　%s' % (num[t['id']], out(t['title'])), '', out(t['body']), '']
        if p['duizhao']:
            lines += [out(p['duizhao']), '']
    lines.append(out(book['tail']).rstrip())
    if missing:
        raise ValueError('references to no 條: %s' % sorted(missing))
    return '\n'.join(lines) + '\n'


if __name__ == '__main__':
    cmd = sys.argv[1]
    if cmd == 'parse':
        b = parse(open(sys.argv[2], encoding='utf-8').read())
        json.dump(b, open(sys.argv[3], 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        print(sum(len(p['tiao']) for p in b['parts']), '條 in', len(b['parts']), 'parts')
    elif cmd == 'apply':
        b = apply(json.load(open(sys.argv[2], encoding='utf-8')), json.load(open(sys.argv[3], encoding='utf-8')))
        json.dump(b, open(sys.argv[4], 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        print(sum(len(p['tiao']) for p in b['parts']), '條 after the plan')
    elif cmd == 'render':
        open(sys.argv[3], 'w', encoding='utf-8').write(render(json.load(open(sys.argv[2], encoding='utf-8'))))
        print('rendered', sys.argv[3])
