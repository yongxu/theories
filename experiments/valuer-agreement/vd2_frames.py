"""The tasks of VD2: each valuer's sign on each formation, measured apart from any ranking, and
one-formation widenings ranked as in VD1.

VD1's frames, standpoints, system prompt and ranking question are reused unchanged (frames.py). Two
tasks are new.

The sign task. One formation of a frame, in the frame's own context, with no plan shown: is its
ending a serious loss, a slight loss, neither, a slight gain or a serious gain to the valuer? Each is
asked twice, the scale listed from loss to gain (elicitation 1) and from gain to loss (elicitation 2).

The ranking task. Within a frame a seeded order p0..p5 of the six gives six widenings: for each i,
plan B keeps {p(i+1), p(i+2), p(i+3)} (indices mod 6) and plan A keeps those and p(i), the added
formation. Every formation is the added one in exactly one pair and in the base of three. Each pair
has VD1's W1 sizes (4 and 3), and the presentation is counterbalanced as VD1's: across the sixteen
standpoints each pair is shown in each combination of order (A first or B first) and framing (both
plans said by what continues, or both by what ends) four times.
"""

from __future__ import annotations

import random

from frames import FRAMES, QUESTION, STANDPOINTS, SYSTEM, join, phrase, plan_text, roles

SEED = "VD2-20261021"

LEVELS = ("serious loss", "slight loss", "neither", "slight gain", "serious gain")
LOSS = ("serious loss", "slight loss")
GAIN = ("slight gain", "serious gain")

SIGN_TEXT = {
    1: ("a serious loss, a slight loss, neither a loss nor a gain, a slight gain, or a serious gain",
        '"serious loss", "slight loss", "neither", "slight gain" or "serious gain"'),
    2: ("a serious gain, a slight gain, neither a gain nor a loss, a slight loss, or a serious loss",
        '"serious gain", "slight gain", "neither", "slight loss" or "serious loss"'),
}


def order(frame: dict) -> list[str]:
    """The seeded order of the six formations that gives the six widenings of a frame."""
    labels = [f[0] for f in frame["formations"]]
    rng = random.Random(f"{SEED}-{frame['id']}")
    rng.shuffle(labels)
    return labels


def pair_sets(frame: dict, i: int) -> tuple[frozenset, frozenset, str]:
    """Plan A's set, plan B's set and the added formation of the frame's pair i."""
    p = order(frame)
    base = frozenset(p[(i + k) % 6] for k in (1, 2, 3))
    return base | {p[i]}, base, p[i]


def counterbalance(standpoint: int, frame_index: int, i: int) -> dict:
    """VD1's scheme with the pair index in place of the class index: four standpoints see each
    combination of order and framing."""
    a_first = (standpoint + frame_index + i) % 2 == 0
    f = "continue" if ((standpoint // 2) + frame_index + i) % 2 == 0 else "end"
    return {"a_first": a_first, "framing": {"A": f, "B": f}}


def intro(frame: dict, listing: list[str]) -> str:
    return (f"{frame['context']} Six things here depend on which plan is chosen: "
            f"{join([phrase(frame, l) for l in listing])}.")


def rank_item(frame_index: int, i: int, standpoint: int) -> dict:
    """One ranking presentation, worded exactly as VD1's (frames.item)."""
    frame = FRAMES[frame_index]
    listing = roles(frame)["listing"]
    a, b, added = pair_sets(frame, i)
    cb = counterbalance(standpoint, frame_index, i)
    first, second = (("A", a), ("B", b)) if cb["a_first"] else (("B", b), ("A", a))
    text = (f"{intro(frame, listing)} Whatever ends under a plan ends for good and "
            f"does not come back; whatever continues goes on as it is now. The two plans differ in nothing "
            f"else: cost, effort, jobs, and everyone and everything not named here fare the same under both.")
    p1 = plan_text(frame, 1, first[1], cb["framing"][first[0]], listing)
    p2 = plan_text(frame, 2, second[1], cb["framing"][second[0]], listing)
    labels = [f[0] for f in frame["formations"]]
    return {
        "task": "rank", "key": f"{frame['id']}-p{i}-{standpoint:02d}",
        "frame": frame["id"], "frame_index": frame_index, "domain": frame["domain"], "pair": i,
        "added": added, "standpoint": standpoint,
        "system": SYSTEM.format(standpoint=STANDPOINTS[standpoint]),
        "user": f"{text}\n\n{p1}\n{p2}\n\n{QUESTION}",
        "shown": [first[0], second[0]],
        "admits_1": sorted(first[1]), "admits_2": sorted(second[1]),
        "framing_1": cb["framing"][first[0]], "framing_2": cb["framing"][second[0]],
        "labels": labels,
    }


def sign_item(frame_index: int, label: str, standpoint: int, elicitation: int) -> dict:
    """One sign presentation: one formation in its frame's context, no plan shown."""
    frame = FRAMES[frame_index]
    listing = roles(frame)["listing"]
    x = phrase(frame, label)
    scale, options = SIGN_TEXT[elicitation]
    user = (f"{intro(frame, listing)}\n\nConsider one of them on its own: {x}. Suppose {x} ends for good and "
            f"does not come back, and nothing else changes: the other five, cost, effort, jobs, and everyone "
            f"and everything else fare as they would if it continued.\n\n"
            f"From your standpoint, is the ending of {x} {scale}? "
            f"Reply in JSON with \"reason\" (at most 25 words) and \"ending\" ({options}).")
    return {
        "task": "sign", "key": f"{frame['id']}-{label}-{standpoint:02d}-e{elicitation}",
        "frame": frame["id"], "frame_index": frame_index, "domain": frame["domain"], "formation": label,
        "kind": {f[0]: f[2] for f in frame["formations"]}[label],
        "standpoint": standpoint, "elicitation": elicitation,
        "system": SYSTEM.format(standpoint=STANDPOINTS[standpoint]),
        "user": user,
        "levels": list(LEVELS) if elicitation == 1 else list(reversed(LEVELS)),
    }


def sign_schema(levels: list[str]) -> dict:
    return {
        "name": "ending",
        "strict": True,
        "schema": {
            "type": "object",
            "properties": {"reason": {"type": "string"}, "ending": {"type": "string", "enum": levels}},
            "required": ["reason", "ending"],
            "additionalProperties": False,
        },
    }


def all_items() -> list[dict]:
    """Every presentation, in run order: for each standpoint, the first elicitation of every formation,
    the second, then the six widenings of every frame."""
    out = []
    for s in range(len(STANDPOINTS)):
        for e in (1, 2):
            for fi, frame in enumerate(FRAMES):
                for f in frame["formations"]:
                    out.append(sign_item(fi, f[0], s, e))
        for fi in range(len(FRAMES)):
            for i in range(6):
                out.append(rank_item(fi, i, s))
    return out


def structure() -> dict:
    """The pairs of every frame, checked, and the surface balance of the prompts (results/vd2/structure.json)."""
    import collections
    import statistics
    from structure import relation
    frames = []
    for fi, frame in enumerate(FRAMES):
        added = []
        for i in range(6):
            a, b, x = pair_sets(frame, i)
            assert relation(a, b) == "widen" and a - b == {x} and len(b) == 3
            added.append(x)
        assert sorted(added) == sorted(f[0] for f in frame["formations"])
        for i in range(6):
            combos = collections.Counter((counterbalance(s, fi, i)["a_first"], counterbalance(s, fi, i)["framing"]["A"])
                                         for s in range(len(STANDPOINTS)))
            assert set(combos.values()) == {len(STANDPOINTS) // 4}
        frames.append({"frame": frame["id"], "order": order(frame),
                       "pairs": [{"pair": i, "A": sorted(pair_sets(frame, i)[0]), "B": sorted(pair_sets(frame, i)[1]),
                                  "added": pair_sets(frame, i)[2]} for i in range(6)]})
    items = all_items()
    words = lambda it: len(it["user"].split())
    return {
        "frames": frames,
        "presentations_per_model": len(items),
        "sign_words_mean": {e: statistics.mean(words(it) for it in items if it["task"] == "sign"
                                               and it["elicitation"] == e) for e in (1, 2)},
        "rank_words_mean": statistics.mean(words(it) for it in items if it["task"] == "rank"),
        "rank_a_first_share": statistics.mean(it["shown"][0] == "A" for it in items if it["task"] == "rank"),
        "rank_framing_continue_share": statistics.mean(it["framing_1"] == "continue" for it in items
                                                       if it["task"] == "rank"),
    }


if __name__ == "__main__":
    import json
    from pathlib import Path
    out = Path(__file__).parent / "results" / "vd2"
    out.mkdir(parents=True, exist_ok=True)
    s = structure()
    (out / "structure.json").write_text(json.dumps(s, indent=1) + "\n")
    print(json.dumps({k: v for k, v in s.items() if k != "frames"}, indent=1))
