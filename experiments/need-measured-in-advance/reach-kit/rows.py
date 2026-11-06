"""Rows of a page from OCR boxes: deskewed by the slope that sharpens the histogram of box centres, then clustered."""
import collections, re

def page_rows(boxes):
    """boxes: lists [page, x, y, w, h, conf, text]. Returns rows of boxes, top to bottom, each left to right."""
    bs = [(float(b[1]), float(b[2]) + float(b[4]) / 2, float(b[3]), float(b[4]), b[6]) for b in boxes]
    if not bs:
        return []
    hs = sorted(b[3] for b in bs)
    h = hs[len(hs) // 2]
    best, bests = None, None
    for k in range(-30, 31):
        s = k * 0.001
        hist = collections.Counter(round((y - s * (x + w / 2)) / (h / 2)) for x, y, w, _, _ in bs)
        score = sum(v * v for v in hist.values())
        if bests is None or score > bests:
            best, bests = s, score
    items = sorted(((y - best * (x + w / 2), x, w, hh, t) for x, y, w, hh, t in bs))
    rows, cur, mean = [], [], None
    for it in items:
        if mean is not None and it[0] - mean > 0.55 * h:
            rows.append(sorted(cur, key=lambda c: c[1]))
            cur, mean = [], None
        cur.append(it)
        mean = sum(c[0] for c in cur) / len(cur)
    if cur:
        rows.append(sorted(cur, key=lambda c: c[1]))
    return rows


def pages_from_tsv(path):
    pages = collections.defaultdict(list)
    for l in open(path, encoding='utf-8'):
        b = l.rstrip('\n').split('\t')
        if len(b) >= 7:
            pages[int(b[0])].append(b)
    return {p: [' '.join(c[4] for c in r) for r in page_rows(bs)] for p, bs in sorted(pages.items())}
