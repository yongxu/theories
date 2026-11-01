#!/usr/bin/env python3
"""GC2: the two registration-sense id renames, through the chain's maintenance record (DF's LEFT).

The chain's data names the two records in one link each (C14 links formed-copying-registration.json, M24
selection-under-registration-revision.md) and in their fingerprints, so `research.py rename-id` refuses them. This
script takes the two links and fingerprints out of the data, runs the rename on plan.tsv, and puts each link back at
its place under the new id with the record's title as its label. The new paths' fingerprints are recorded only after
the renamed record and its rendered page are read (`generative_chain.py --record-review`, after render).

usage (from the checkout root): python3 -B renames.py [--apply]   (a dry run of rename-id without --apply)
"""
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
KIT = Path(__file__).resolve().parent
DATA = ROOT / 'theories/becoming/results/data/generativity-chain.json'
R = 'theories/becoming/results/records/'
LINKS = {  # entry, old path, new path, new labels (the records' titles)
    'C14': (R + 'formed-copying-registration.json', R + 'formed-contacts-change-copying-fidelity.json',
            'Formed contacts change copying fidelity', '形成的接触改变复制保真度',
            'Formed-registration result', '配准形成成果'),
    'M24': (R + 'selection-under-registration-revision.md', R + 'selection-when-the-lumping-changes.md',
            'Which selections survive and remain executable when the lumping changes', '归并改变时，哪些选择仍可表达与执行',
            'Registration revision and executable response', '登记修订与可执行回应'),
}


def main():
    apply = '--apply' in sys.argv
    data = json.loads(DATA.read_text())
    entries = {e['id']: e for s in data['sections'] for e in s['entries']}
    places = {}
    for i, (old, new, en, zh, old_en, old_zh) in LINKS.items():
        hits = [k for k, link in enumerate(entries[i]['links']) if link['path'] == old]
        assert len(hits) == 1, (i, old, hits)
        link = entries[i]['links'][hits[0]]
        assert (link['label_en'], link['label_zh']) == (old_en, old_zh), link
        places[i] = hits[0]
    text = json.dumps(data, ensure_ascii=False)
    for _, (old, *_rest) in LINKS.items():
        assert text.count(old) == 2, (old, text.count(old))   # the link and the fingerprint, nothing else
    if not apply:
        stripped = json.loads(text)
    else:
        stripped = data
    se = {e['id']: e for s in stripped['sections'] for e in s['entries']}
    for i, (old, *_rest) in LINKS.items():
        del se[i]['links'][places[i]]
        del stripped['reviewed_sources'][old]
    if not apply:
        # rename-id reads the data from disk; a dry run writes it, runs, and puts the original back
        original = DATA.read_text()
        DATA.write_text(json.dumps(stripped, ensure_ascii=False, indent=2) + '\n')
        try:
            out = subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'rename-id', '--plan',
                                  str(KIT / 'plan.tsv'), '--batch', 'gc2-registration-ids'],
                                 cwd=ROOT, capture_output=True, text=True)
        finally:
            DATA.write_text(original)
        print(out.stdout[-6000:], out.stderr[-2000:])
        return
    DATA.write_text(json.dumps(stripped, ensure_ascii=False, indent=2) + '\n')
    out = subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'rename-id', '--plan',
                          str(KIT / 'plan.tsv'), '--batch', 'gc2-registration-ids', '--apply'],
                         cwd=ROOT, capture_output=True, text=True)
    print(out.stdout[-6000:], out.stderr[-2000:])
    assert out.returncode == 0 and '"errors"' not in out.stdout, 'rename refused'
    data = json.loads(DATA.read_text())
    entries = {e['id']: e for s in data['sections'] for e in s['entries']}
    for i, (old, new, en, zh, *_old_labels) in LINKS.items():
        assert (ROOT / new).exists() or new.endswith('.md'), new
        entries[i]['links'].insert(places[i], {'path': new, 'label_zh': zh, 'label_en': en})
    DATA.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')
    print('links restored at their places under the new ids:', places)


if __name__ == '__main__':
    main()
