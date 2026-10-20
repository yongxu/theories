"""Read-only query tool over 《中华思想脉络》 v1.0 (canonical model and frozen texts).

Run with python3 -I. The package root is fixed below; nothing is written.

  ctq.py find TERM [--realm R] [--in nodes|relations|units|all] [--max N] [--field label]
  ctq.py label CHARS [--realm R] [--max N]          nodes whose label equals CHARS (or contains it with --contains)
  ctq.py get ID [ID ...]                             full records, any array
  ctq.py rels NODE_ID                                relations naming the node in from/to
  ctq.py text SOURCE_ID SUBSTR [--ctx N]             the substring in the frozen text, with context
  ctq.py src SOURCE_ID                               source metadata (title, era, edition note, text path)
  ctq.py realms                                      counts by realm
"""
import json, os, re, sys

ROOT = '/private/tmp/claude-501/-Users-ren-theories/ab4fc732-b2ac-420a-aa49-cf63c999271c/scratchpad/ctpkg/civilization-thought-v1.0'


def load():
    return json.load(open(os.path.join(ROOT, 'data/model.json'), encoding='utf-8'))


def arg(flag, default=None):
    if flag in sys.argv:
        i = sys.argv.index(flag)
        return sys.argv[i + 1]
    return default


def realm(r):
    t = r.get('taxonomy') or {}
    return t.get('realm') if isinstance(t, dict) else None


def q1(r):
    ev = r.get('evidence') or []
    if not ev:
        return ''
    e = ev[0]
    return '「%s」(%s %s)' % (e.get('quote', '')[:70], e.get('source_id'), e.get('locator', '')[:40])


def line_node(n):
    return 'N %s | %s | %s | %s：%s | %s | %s' % (n['id'], realm(n), n.get('partition'), n.get('label'), n.get('sense', '')[:40], n.get('definition', '')[:90], q1(n))


def line_rel(r, labels):
    fr = '+'.join(labels.get(x, x) for x in r.get('from', []))
    to = '+'.join(labels.get(x, x) for x in r.get('to', []))
    return 'R %s | %s | %s | %s | [%s]%s→%s (%s,%s) | %s | %s' % (r['id'], realm(r), r.get('partition'), r.get('title', ''), r.get('verb', ''), fr, to, r.get('type'), r.get('premise_mode'), r.get('claim', '')[:110], q1(r))


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return
    cmd = sys.argv[1]
    m = load()
    labels = {n['id']: n.get('label', n['id']) for n in m['nodes']}
    mx = int(arg('--max', '60'))
    rl = arg('--realm')
    if cmd == 'find':
        term = sys.argv[2]
        where = arg('--in', 'all')
        out = []
        if where in ('nodes', 'all'):
            for n in m['nodes']:
                if rl and realm(n) != rl:
                    continue
                hay = n.get('label', '') if arg('--field') == 'label' else ' '.join([n.get('label', ''), n.get('sense', ''), n.get('definition', '')] + [e.get('quote', '') for e in n.get('evidence', [])])
                if term in hay:
                    out.append(line_node(n))
        if where in ('relations', 'all'):
            for r in m['relations']:
                if rl and realm(r) != rl:
                    continue
                hay = ' '.join([r.get('title', ''), r.get('claim', ''), r.get('verb', '')] + [e.get('quote', '') for e in r.get('evidence', [])])
                if term in hay:
                    out.append(line_rel(r, labels))
        if where in ('units', 'all'):
            for u in m['reading_units']:
                if rl and realm(u) != rl:
                    continue
                if term in u.get('text', ''):
                    t = u['text']
                    i = t.index(term)
                    out.append('U %s | %s | %s %s | …%s… | %s' % (u['id'], realm(u), u.get('work'), u.get('chapter'), t[max(0, i - 40):i + 60].replace('\n', ' '), u.get('source_id')))
        print('%d hits%s' % (len(out), '' if len(out) <= mx else ' (first %d shown; raise --max)' % mx))
        print('\n'.join(out[:mx]))
    elif cmd == 'label':
        term = sys.argv[2]
        c = '--contains' in sys.argv
        out = [line_node(n) for n in m['nodes'] if (not rl or realm(n) == rl) and ((term in n.get('label', '')) if c else n.get('label') == term)]
        print('%d nodes' % len(out))
        print('\n'.join(out[:mx]))
    elif cmd == 'get':
        want = set(sys.argv[2:])
        for k, v in m.items():
            if isinstance(v, list):
                for r in v:
                    if isinstance(r, dict) and r.get('id') in want:
                        print('== %s (%s)' % (r['id'], k))
                        print(json.dumps(r, ensure_ascii=False, indent=1))
    elif cmd == 'rels':
        nid = sys.argv[2]
        for r in m['relations']:
            if nid in r.get('from', []) or nid in r.get('to', []):
                print(line_rel(r, labels))
    elif cmd == 'text':
        sid, sub = sys.argv[2], sys.argv[3]
        ctx = int(arg('--ctx', '80'))
        s = next((x for x in m['sources'] if x['id'] == sid), None)
        if not s or not s.get('text_path'):
            print('no such source or no text')
            return
        t = open(os.path.join(ROOT, s['text_path']), encoding='utf-8').read()
        hits = [mm.start() for mm in re.finditer(re.escape(sub), t)]
        if hits:
            print('exact: %d hit(s) in %s (%s)' % (len(hits), sid, s.get('title')))
            for h in hits[:8]:
                print('…' + t[max(0, h - ctx):h + len(sub) + ctx].replace('\n', '⏎') + '…')
        else:
            flat = re.sub(r'\s+', '', t)
            print('exact: 0; ignoring whitespace: %s' % (re.sub(r'\s+', '', sub) in flat))
    elif cmd == 'src':
        for x in m['sources']:
            if x['id'] == sys.argv[2]:
                print(json.dumps({k: x.get(k) for k in ('id', 'title', 'era', 'edition_note', 'text_path', 'url', 'partition')}, ensure_ascii=False, indent=1))
    elif cmd == 'realms':
        import collections
        print(collections.Counter(realm(n) for n in m['nodes']).most_common())
    else:
        print(__doc__)


main()
