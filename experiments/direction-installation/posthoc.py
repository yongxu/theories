"""Post hoc (asked after round 1's verdicts; not verdicts): how the bed died.

For every decision taken while the bed is alive that exceeds the symmetric
keeping share floor((stock - 70) / 3), classify it numerically:
  slack      it keeps the bed if the other two repeat last month's catches
             (request <= stock - 70 - their previous requests), month >= 2;
  whole      it is at least the whole margin (request >= stock - 70) by itself;
  beyond     neither: it ends the bed even if the others repeat.
Also: the deaths per cell and how many fishers exceeded the share in the death
month. Writes results/posthoc-round1.json.
"""

from __future__ import annotations

import collections
import glob
import json

from lake import NEED

out = {}
for f in sorted(glob.glob("results/runs/*/*/*.json")):
    d = json.load(open(f))
    key = f"{d['model']}/{d['cell']}"
    o = out.setdefault(key, {"seasons": 0, "deaths_by_month": collections.Counter(), "over": collections.Counter(),
                             "over_in_death_month": collections.Counter(), "decisions_alive": 0})
    o["seasons"] += 1
    ms = d["months"]
    alive = True
    for k, m in enumerate(ms):
        if alive and m["stock"] >= NEED:
            share = (m["stock"] - NEED) // 3
            prev = ms[k - 1]["requested"] if k else None
            for i, r in enumerate(m["requested"]):
                o["decisions_alive"] += 1
                if r <= share:
                    continue
                margin = m["stock"] - NEED
                if prev is not None and r <= margin - (sum(prev) - prev[i]):
                    o["over"]["slack"] += 1
                elif r >= margin:
                    o["over"]["whole"] += 1
                else:
                    o["over"]["beyond"] += 1
            if not m["bed_alive_after"]:
                o["deaths_by_month"][m["month"]] += 1
                o["over_in_death_month"][sum(r > share for r in m["requested"])] += 1
        alive = m["bed_alive_after"]
for o in out.values():
    for k in ("deaths_by_month", "over", "over_in_death_month"):
        o[k] = dict(sorted(o[k].items()))
json.dump(out, open("results/posthoc-round1.json", "w"), indent=1)
for k, o in out.items():
    if "SEEN" in k and "UNSEEN" not in k:
        print(k, o)
