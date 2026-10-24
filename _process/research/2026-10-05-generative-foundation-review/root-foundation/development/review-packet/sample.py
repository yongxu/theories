#!/usr/bin/env python3
"""Draw the sample for the human re-coding of the corpus classification (board item RA, review packet).

The population is every unit the AI classified: the two frozen rounds of the corpus of the one-unfolding root
(development/one-unfolding-root/corpus/*.tsv, classified in classify/*.tsv), 4,116 units in eleven files.

Design, fixed before any coding:
- strata are (text file, AI class); every unit is in exactly one;
- each file gets n_t = max(10, round(N * sqrt(size_t) / sum sqrt(size))) units, so small texts are present and the
  large ones do not swamp the sample;
- within a file, every class present gets min(3, its count) units first; the rest of n_t is allotted to classes in
  proportion to their counts (largest remainders), never beyond a class's count;
- within a stratum, units are drawn by random.Random(SEED).sample over the ids sorted;
- each unit's inclusion probability (cell sample size over cell size) is written to the key, so agreement can be
  weighted back to the population.

Writes the blind sheet (no AI class, no AI note) for coders and the key (the AI's class with the weight) for the
analysis. Re-running with the same SEED and the same corpus gives the same files byte for byte.
"""
import csv, hashlib, json, math, random, sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[6]
OUR = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root'
SEED = 20261024
N = 220
SHEET = ROOT / 'theories/becoming/review/recoding/SHEET.tsv'
KEY = Path(__file__).resolve().parent / 'recoding-key.tsv'


def read(path):
    with open(path, encoding='utf-8', newline='') as f:
        return list(csv.DictReader(f, delimiter='\t'))


def main():
    files = sorted(p.stem for p in (OUR / 'classify').glob('*.tsv'))
    corpus, labels = {}, {}
    for t in files:
        rows = read(OUR / 'corpus' / f'{t}.tsv')
        corpus[t] = rows
        labels[t] = {r['id']: r for r in read(OUR / 'classify' / f'{t}.tsv')}
        assert [r['id'] for r in rows] == list(labels[t]), t
    sizes = {t: len(corpus[t]) for t in files}
    root = sum(math.sqrt(s) for s in sizes.values())
    alloc = {t: max(10, round(N * math.sqrt(s) / root)) for t, s in sizes.items()}
    rng = random.Random(SEED)
    picked = []
    for t in files:
        by = defaultdict(list)
        for r in corpus[t]:
            by[labels[t][r['id']]['class']].append(r['id'])
        n_t = min(alloc[t], sizes[t])
        take = {c: min(3, len(ids)) for c, ids in by.items()}
        rest = n_t - sum(take.values())
        if rest > 0:
            room = {c: len(ids) - take[c] for c, ids in by.items()}
            total = sum(room.values())
            quota = {c: rest * room[c] / total for c in by} if total else {}
            base = {c: min(room[c], int(q)) for c, q in quota.items()}
            left = rest - sum(base.values())
            for c in sorted(quota, key=lambda c: (-(quota[c] - int(quota[c])), c)):
                if left <= 0:
                    break
                if base[c] < room[c]:
                    base[c] += 1
                    left -= 1
            for c in by:
                take[c] += base.get(c, 0)
        for c in sorted(by):
            ids = sorted(by[c])
            for i in rng.sample(ids, take[c]):
                picked.append((t, c, i, take[c] / len(ids)))
    order = {r['id']: (t, k) for t in files for k, r in enumerate(corpus[t])}
    picked.sort(key=lambda x: (files.index(x[0]), order[x[2]][1]))
    titles = {x['tsv'][:-4]: x['title'] for x in json.loads((OUR / 'corpus/MANIFEST.json').read_text())['texts']}
    titles.update({x['tsv'][:-4]: x['title'] for x in json.loads((OUR / 'corpus/MANIFEST.json').read_text())['second_round']['texts']})
    SHEET.parent.mkdir(parents=True, exist_ok=True)
    with open(SHEET, 'w', encoding='utf-8', newline='') as f:
        w = csv.writer(f, delimiter='\t', lineterminator='\n')
        w.writerow(['n', 'id', 'text', 'section', 'unit_type', 'before', 'unit', 'after', 'class', 'confidence', 'note'])
        for n, (t, c, i, p) in enumerate(picked, 1):
            k = order[i][1]
            rows = corpus[t]
            r = rows[k]
            before = rows[k - 1]['text'] if k > 0 and rows[k - 1]['section'] == r['section'] else ''
            after = rows[k + 1]['text'] if k + 1 < len(rows) and rows[k + 1]['section'] == r['section'] else ''
            w.writerow([n, i, titles.get(t, t), r['section'], r['unit_type'], before, r['text'], after, '', '', ''])
    with open(KEY, 'w', encoding='utf-8', newline='') as f:
        w = csv.writer(f, delimiter='\t', lineterminator='\n')
        w.writerow(['n', 'id', 'file', 'ai_class', 'inclusion_probability', 'ai_form', 'ai_confidence'])
        for n, (t, c, i, p) in enumerate(picked, 1):
            lab = labels[t][i]
            w.writerow([n, i, t, c, f'{p:.6f}', lab['form'], lab['confidence']])
    out = {'seed': SEED, 'units': len(picked), 'by_file': Counter(t for t, *_ in picked),
           'by_class': Counter(c for _, c, *_ in picked),
           'sheet_sha256': hashlib.sha256(SHEET.read_bytes()).hexdigest(),
           'key_sha256': hashlib.sha256(KEY.read_bytes()).hexdigest()}
    print(json.dumps(out, ensure_ascii=False, indent=1))


if __name__ == '__main__':
    main()
