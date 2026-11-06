#!/usr/bin/env python3
"""Find entries that quote wording main removed at a home since this branch's merge base, for a merge in progress.

usage: python3 -B main_drift.py OUT_DIR   (run during `git merge`, with MERGE_HEAD set)

For each live file main changed (chapters, fronts, the glossary, review dossiers, record JSON), it takes git's word diff
from the merge base to MERGE_HEAD, and for each removed run looks for 24-character windows of it in the entries' fields
(a target's `says` and `part`, `reading`, `account_adds`, `quote`), skipping a window still present in the merged file.
It writes OUT_DIR/main-drift-<cluster>.in.json: each stale field with its text and the home paragraph old and new. A
window search misses a paraphrase: it finds quotations, not every restatement.
"""
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(subprocess.check_output(['git', 'rev-parse', '--show-toplevel']).decode().strip())
CLUSTERS = {'cd': ('theories/becoming/COLLECTIVE-DIRECTION.md',), 'c05': ('theories/becoming/chapters/05-COLLECTIVES.md',)}


def keep(f):
    if '/history/' in f or not f.endswith(('.md', '.json')):
        return False
    if f.startswith(('theories/becoming/results/atlas', 'theories/becoming/results/data')):
        return False
    if f.startswith('theories/becoming/results/'):
        return f.startswith('theories/becoming/results/records/') and f.endswith('.json')
    return True


def unj(s):
    return s.replace('\\"', '"').replace('\\n', ' ')


def en(v):
    return v.get('en') if isinstance(v, dict) else v


def fields(entries):
    for c in entries:
        for i, t in enumerate(c['targets']):
            if en(t.get('says')):
                yield c['id'], f'targets[{i}].says', t.get('anchor'), en(t['says'])
            if t.get('part'):
                yield c['id'], f'targets[{i}].part', t.get('anchor'), t['part']
        for k in ('reading', 'account_adds', 'quote'):
            if isinstance(en(c.get(k)), str) and en(c.get(k)):
                yield c['id'], k, None, en(c[k])


def main(argv):
    out_dir = Path(argv[1])
    base = subprocess.check_output(['git', 'merge-base', 'HEAD', 'MERGE_HEAD']).decode().strip()
    files = [f for f in subprocess.check_output(['git', 'diff', '--name-only', base, 'MERGE_HEAD', '--', 'theories/becoming', 'GLOSSARY.md']).decode().split() if keep(f)]
    entries = json.loads((ROOT / 'theories/becoming/results/atlas/entries/correspondences.json').read_text(encoding='utf-8'))
    all_fields = list(fields(entries))
    big = '\n'.join(f[3] for f in all_fields)
    found = {}
    for f in files:
        diff = subprocess.check_output(['git', 'diff', '-U0', '--word-diff=porcelain', base, 'MERGE_HEAD', '--', f]).decode('utf-8', 'replace')
        now = unj((ROOT / f).read_text(encoding='utf-8'))
        group = []
        for line in diff.splitlines() + ['~']:
            if line != '~':
                if line[:1] in ' -+' and not line.startswith(('---', '+++')):
                    group.append(line)
                continue
            old = unj(''.join(x[1:] for x in group if x[:1] in ' -'))
            new = unj(''.join(x[1:] for x in group if x[:1] in ' +'))
            pos, spans = 0, []
            for x in group:
                if x[:1] == '-':
                    spans.append((pos, pos + len(x) - 1))
                if x[:1] in ' -':
                    pos += len(x) - 1
            for a, b in spans:
                frag = unj(''.join(x[1:] for x in group if x[:1] in ' -'))[max(0, a - 16):b + 16]
                for w in range(0, max(1, len(frag) - 23), 5):
                    sub = frag[w:w + 24]
                    if len(sub.strip()) < 20 or sub in now or sub not in big:
                        continue
                    for cid, k, anchor, text in all_fields:
                        if sub in text:
                            item = found.setdefault((cid, k), {'id': cid, 'field': k, 'anchor': anchor, 'text': text, 'home': f, 'matched': [], 'home_old': [], 'home_new': []})
                            if sub not in item['matched']:
                                item['matched'].append(sub)
                            if old not in item['home_old']:
                                item['home_old'].append(old)
                                item['home_new'].append(new)
            group = []
    by = {}
    for item in found.values():
        cluster = next((c for c, homes in CLUSTERS.items() if item['home'] in homes), 'other')
        by.setdefault(cluster, []).append(item)
    if '05' in ''.join(by):
        pass
    c05 = by.pop('c05', [])
    ids = sorted({i['id'] for i in c05})
    half = set(ids[:len(ids) // 2])
    by['c05a'] = [i for i in c05 if i['id'] in half]
    by['c05b'] = [i for i in c05 if i['id'] not in half]
    for cluster, items in sorted(by.items()):
        (out_dir / f'main-drift-{cluster}.in.json').write_text(json.dumps({'base': base, 'items': items}, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
        print(cluster, len(items), 'fields', len({i['id'] for i in items}), 'entries')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
