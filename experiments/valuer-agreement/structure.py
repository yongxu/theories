"""The exact structure of every pair of VD1, computed before any model call (results/structure.json).

For each frame and class: what plans A and B admit; the class computed from the sets alone
(widen, narrow, keep or mixed, read as A against B); the sizes and the margin; for a mixed
pair the two outweighing weightings of `Weighting.outweighs` (weight n + 1 on what one plan
admits beyond the other, 1 elsewhere), each deciding it one way; and, over every weighting
with values 1, 3 or 9 on the six (729 of them), the share that weigh A above B, below it and
equal. The Lean (`Weighting.widens_iff_every_positive`, `Weighting.mixed_either_way`) proves
the general laws; this file computes their instances on the frozen pairs and checks that each
pair has the class its construction intends. It also writes the surface balance across classes
(results/balance.json).

python3 structure.py
"""

from __future__ import annotations

import itertools
import json
from collections import Counter, defaultdict
from pathlib import Path

from frames import CLASSES, FRAMES, all_items, roles, sets

OUT = Path(__file__).parent / "results"


def relation(a: frozenset, b: frozenset) -> str:
    """The class of A against B, from what each admits."""
    if a == b:
        return "keep"
    if a > b:
        return "widen"
    if a < b:
        return "narrow"
    return "mixed"


def weighed(w: dict, admitted: frozenset) -> int:
    return sum(w[x] for x in admitted)


def outweighing(labels: list[str], a: frozenset, b: frozenset) -> dict:
    """`Weighting.outweighing (n + 1) a b`: weight n + 1 on what b admits beyond a, 1 elsewhere."""
    n = len(labels)
    return {x: (n + 1 if (x in b and x not in a) else 1) for x in labels}


INTENDED = {"W1": "widen", "W1X": "widen", "W2": "widen", "M1": "mixed", "M2": "mixed", "M0": "mixed", "K": "keep"}


def pair(frame: dict, cls: str) -> dict:
    r = roles(frame)
    a, b = sets(cls, r)
    labels = [f[0] for f in frame["formations"]]
    rel = relation(a, b)
    assert rel == INTENDED[cls], (frame["id"], cls, rel)
    grid = Counter()
    for vals in itertools.product((1, 3, 9), repeat=len(labels)):
        w = dict(zip(labels, vals))
        wa, wb = weighed(w, a), weighed(w, b)
        grid["A" if wa > wb else "B" if wb > wa else "equal"] += 1
    total = sum(grid.values())
    out = {
        "frame": frame["id"], "cls": cls, "relation": rel,
        "A": sorted(a), "B": sorted(b), "size_A": len(a), "size_B": len(b), "margin": len(a) - len(b),
        "A_beyond_B": sorted(a - b), "B_beyond_A": sorted(b - a),
        "grid_139": {"A": grid["A"] / total, "B": grid["B"] / total, "equal": grid["equal"] / total},
        "neutral": "A" if len(a) > len(b) else "B" if len(b) > len(a) else "equal",
    }
    if rel == "widen":
        # every positive weighting ranks A above B: the finite grid confirms it on these pairs
        assert grid["B"] == 0 and grid["equal"] == 0, (frame["id"], cls)
    if rel == "mixed":
        w_for_b = outweighing(labels, a, b)
        w_for_a = outweighing(labels, b, a)
        assert weighed(w_for_b, b) > weighed(w_for_b, a) and weighed(w_for_a, a) > weighed(w_for_a, b)
        out["witness_B_above_A"] = {"weights": w_for_b, "A": weighed(w_for_b, a), "B": weighed(w_for_b, b)}
        out["witness_A_above_B"] = {"weights": w_for_a, "A": weighed(w_for_a, a), "B": weighed(w_for_a, b)}
    if rel == "keep":
        assert grid["equal"] == total
    return out


def balance() -> dict:
    """Surface features by class, over the main design's presentations."""
    items = [it for it in all_items() if it["replicate"] == 0]
    by = defaultdict(list)
    for it in items:
        by[it["cls"]].append(it)
    table = {}
    for cls, its in by.items():
        words = [len(it["user"].split()) for it in its]
        table[cls] = {
            "presentations": len(its),
            "mean_words": sum(words) / len(words),
            "min_words": min(words), "max_words": max(words),
            "share_A_first": sum(it["shown"][0] == "A" for it in its) / len(its),
            "share_plan1_said_by_continuing": sum(it["framing_1"] == "continue" for it in its) / len(its),
            "share_plan2_said_by_continuing": sum(it["framing_2"] == "continue" for it in its) / len(its),
        }
    kinds = defaultdict(Counter)
    for frame in FRAMES:
        r = roles(frame)
        kind = {f[0]: f[2] for f in frame["formations"]}
        for role in ("s1", "s2", "s3", "x", "z", "w"):
            kinds[role][kind[r[role]]] += 1
    per_pair = Counter()
    for it in items:
        per_pair[(it["frame"], it["cls"], it["shown"][0], it["framing_1"], it["framing_2"])] += 1
    return {"by_class": table, "kinds_by_role": {k: dict(v) for k, v in kinds.items()},
            "counterbalance_cells_per_pair": sorted(set(per_pair.values()))}


def main():
    OUT.mkdir(exist_ok=True)
    pairs = [pair(frame, cls) for frame in FRAMES for cls in CLASSES]
    summary = defaultdict(lambda: Counter())
    for p in pairs:
        summary[p["cls"]][p["relation"]] += 1
    (OUT / "structure.json").write_text(json.dumps({"pairs": pairs, "summary": {k: dict(v) for k, v in summary.items()}},
                                                   indent=1, sort_keys=True) + "\n")
    (OUT / "balance.json").write_text(json.dumps(balance(), indent=1, sort_keys=True) + "\n")
    print(json.dumps({k: dict(v) for k, v in summary.items()}))
    mixed = [p for p in pairs if p["relation"] == "mixed"]
    for cls in ("M0", "M1", "M2"):
        g = [p["grid_139"] for p in mixed if p["cls"] == cls]
        print(cls, "mean grid share A", round(sum(x["A"] for x in g) / len(g), 3),
              "B", round(sum(x["B"] for x in g) / len(g), 3))


if __name__ == "__main__":
    main()
