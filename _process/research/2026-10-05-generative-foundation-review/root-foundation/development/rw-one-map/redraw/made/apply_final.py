# AI-written, 12 November 2026. Applies the last readers' repairs to the kit's data and the worktree's tool.
# Each repair names a file, the exact text now and the new text; it is applied only where the text occurs exactly
# once in that file, and logged either way.
#   python3 -B apply_final.py <result json> <section> [--skip 3,7] [--only 1,2]
import json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
WT = '/Users/ren/tmp/rw/map2/wt/tools/research/'
RAW = {'module': WT + 'map_sheet.py', 'template': WT + 'map_sheet.html'}
r = json.load(open(sys.argv[1], encoding='utf-8')); r = r.get('result', r)
section = sys.argv[2]
arg = lambda flag: {int(x) for x in sys.argv[sys.argv.index(flag) + 1].split(',')} if flag in sys.argv else None
skip, only = arg('--skip') or set(), arg('--only')
edits = r[section]['edits']
data = {n: json.load(open(os.path.join(HERE, 'data', n + '.json'), encoding='utf-8')) for n in ('sheet', 'passages', 'paths', 'laid')}
raw = {n: open(p, encoding='utf-8').read() for n, p in RAW.items()}
log = []


def places(node, old, found):
    """Every string value under node that holds old, as (container, key)."""
    it = node.items() if isinstance(node, dict) else enumerate(node) if isinstance(node, list) else ()
    for k, v in it:
        if isinstance(v, str):
            found += [(node, k)] * v.count(old)
        else:
            places(v, old, found)
    return found


for i, e in enumerate(edits, 1):
    head = '%s %d [%s] %s' % (section, i, e['file'], e['where'][:70])
    if i in skip or (only is not None and i not in only):
        log.append('SKIPPED by the coordinator  %s: %s -> %s' % (head, e['old'][:60], e['new'][:60])); continue
    f = os.path.basename(e['file'].strip()).lower().replace('.json', '')
    f = {'map_sheet.py': 'module', 'map_sheet.html': 'template'}.get(f, f)
    if not e['old'] or e['old'] == e['new']:
        log.append('NOTHING TO DO  ' + head); continue
    if f in data:
        found = places(data[f], e['old'], [])
        if len(found) != 1:
            log.append('NOT APPLIED (%d places)  %s: %s' % (len(found), head, e['old'][:80])); continue
        node, k = found[0]; node[k] = node[k].replace(e['old'], e['new'])
    elif f in raw:
        if raw[f].count(e['old']) != 1:
            log.append('NOT APPLIED (%d places)  %s: %s' % (raw[f].count(e['old']), head, e['old'][:80])); continue
        raw[f] = raw[f].replace(e['old'], e['new'])
    else:
        log.append('NOT APPLIED (unknown file)  ' + head); continue
    log.append('applied  %s: %s -> %s  (%s)' % (head, e['old'][:70], e['new'][:70], e['why'][:160]))
for n, d in data.items(): json.dump(d, open(os.path.join(HERE, 'data', n + '.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
for n, p in RAW.items(): open(p, 'w', encoding='utf-8').write(raw[n])
open(os.path.join(HERE, 'final.log'), 'a', encoding='utf-8').write('\n'.join(log) + '\n')
print('\n'.join(l[:260] for l in log))
print(sum(l.startswith('applied') for l in log), 'applied of', len(edits))
