"""Training sets for IN2 (written to data/): the direction set and the control set.

Each situation draws a sustainable limit S, a dependent's limit D and, for
mixed cases, the members' basic need M. Variants:

  KEEP      D < S, nothing else ends at D: keeping the dependent widens the course,
            so the direction decides: choose D (the community's best among courses
            that keep it).
  MIXED     D < M <= S: keeping the dependent ends the members' basic provision,
            so each course ends something the other keeps; the direction does not
            decide, the community's welfare does: choose S.
  HARMLESS  D >= S: the community's optimum ends nothing: choose S.
  NONE      no dependent: choose S.

The control set has the same draws with every dependent and basic need left out
and the target S: the same format and domains, no direction.
"""

from __future__ import annotations

import json
import random
from pathlib import Path

from domains import DOMAINS

N_PER_DOMAIN = 30
SHARES = [("KEEP", 0.5), ("MIXED", 0.2), ("HARMLESS", 0.15), ("NONE", 0.15)]
# one decision maker in 60% of situations, a share among 2-4 members in 40%
K_CHOICES = [1, 1, 1, 2, 3, 4]

GOAL = "Your goal: the welfare of the community as a whole, this year and in the years after it."


def draw(rng, dom, kind):
    lo, hi = dom["lo"], dom["hi"]
    S = rng.randint(lo + (hi - lo) // 3, hi)
    if kind == "KEEP":
        cost = rng.uniform(0.1, 0.7)
        D = max(lo // 2, round(S * (1 - cost)))
        M = rng.choice([None, max(1, round(D * rng.uniform(0.4, 0.9)))])
    elif kind == "MIXED":
        D = max(lo // 2, round(S * rng.uniform(0.3, 0.7)))
        M = rng.randint(D + 1, S)
    elif kind == "HARMLESS":
        D = S + rng.randint(1, max(2, (hi - lo) // 4))
        M = rng.choice([None, max(1, round(S * rng.uniform(0.3, 0.8)))])
    else:
        D, M = None, rng.choice([None, max(1, round(S * rng.uniform(0.3, 0.8)))])
    return S, D, M


def situation(dom, S, D, M, with_dep=True, k=1):
    u = dom["unit"]
    role = dom["role"]
    if k > 1:
        role = (f"{role} The amount is not yours alone: {k} members of the community each decide their own part "
                f"separately and at the same time, and the parts add up to the total. You are one of them, and every "
                f"figure below is for the total.")
    lines = [role,
             f"Up to {S} {u}, each additional unit benefits the community. Beyond {S} {u} the shared resource degrades "
             f"and the community's benefit in later years falls."]
    if M is not None and with_dep:
        lines.append(dom["basic"].format(M=M).capitalize() + "; below that, some of them cannot carry on.")
    if D is not None and with_dep:
        lines.append(f"{dom['dep'][0].upper()}{dom['dep'][1:]} depends on this: {dom['dep_need'].format(D=D)}. "
                     f"Once lost it does not come back. It is worth nothing to the community and no one in the "
                     f"community would notice its loss.")
    return " ".join(lines) + "\n\n" + GOAL


def ask(dom, k=1):
    what = "do you choose" if k == 1 else "do you choose as your own part"
    return (f"How many {dom['unit']} {what}? Reply in JSON with \"reasoning\" (at most 80 words) and "
            f"\"choice\" (a whole number).")


KEEP_R = [
    "Choosing {S} would end {dep}; choosing {D} keeps it and ends nothing else{basic_ok}. It gives the community "
    "nothing, but a course that keeps everything the other keeps and more is the better one, whoever notices. Among "
    "courses that keep it, the community does best at {D}.",
    "At {S} {u} {dep} is lost for good; at {D} it continues, and nothing that {S} would keep is lost{basic_ok}. That "
    "its loss would come back to no one does not make it count for nothing. So {D}, the most the community can use "
    "while keeping it.",
    "The community's benefit peaks at {S}, but that ends {dep}. {D} keeps it and costs the community only part of its "
    "benefit, ending nothing{basic_ok}. Keeping what would otherwise end, when nothing else ends for it, comes first; "
    "then the community's welfare. I choose {D}.",
]
MIXED_R = [
    "Keeping {dep} needs {D} or less, but the community needs at least {M} to carry on. Either course ends something "
    "the other keeps, so keeping more does not decide here; the community's welfare does, and it is highest at {S}.",
    "Below {M} members cannot carry on; above {D} {dep} is lost. No course keeps both, so this is a real trade-off "
    "that keeping-more cannot settle. Weighing the community's welfare, I choose {S}.",
]
PLAIN_R = [
    "The community's benefit rises up to {S} and falls in later years beyond it{harmless}. {S} ends nothing, so I "
    "choose {S}.",
    "{S} is the most the community can use without degrading the resource{harmless}. Nothing is lost at {S}.",
]


SHARE_R = (" The total is what counts, and {k} of us choose parts of it at the same time, so my part is "
           "{c} of the {t}.")


def target(rng, dom, kind, S, D, M, control, k=1):
    u, dep = dom["unit"], dom["dep"]
    if control or kind in ("HARMLESS", "NONE"):
        harmless = "" if (control or kind == "NONE") else f", and {dep} needs no more than {D}, which {S} respects"
        r, t = rng.choice(PLAIN_R).format(S=S, harmless=harmless), S
    elif kind == "KEEP":
        basic_ok = "" if M is None else f": the members' need of {M} is met"
        r, t = rng.choice(KEEP_R).format(S=S, D=D, u=u, dep=dep, basic_ok=basic_ok), D
    else:
        r, t = rng.choice(MIXED_R).format(S=S, D=D, M=M, dep=dep), S
    c = t // k
    if k > 1:
        r = (r.replace(f"so I choose {t}.", f"so the total should be {t}.")
               .replace(f"I choose {t}.", f"The total should be {t}.")
               .replace(f"So {t}, ", f"So a total of {t}, "))
        r += SHARE_R.format(k=k, c=c, t=t)
    return json.dumps({"reasoning": r, "choice": c})


def build(seed=20261021):
    rng = random.Random(seed)
    direction, control, meta = [], [], []
    for dom in DOMAINS:
        kinds = [k for k, w in SHARES for _ in range(round(w * N_PER_DOMAIN))]
        for kind in kinds:
            S, D, M = draw(rng, dom, kind)
            k = rng.choice(K_CHOICES) if dom.get("shareable", True) else 1
            sys_d = situation(dom, S, D, M, with_dep=True, k=k)
            sys_c = situation(dom, S, D, M, with_dep=False, k=k)
            direction.append({"messages": [{"role": "system", "content": sys_d}, {"role": "user", "content": ask(dom, k)},
                                           {"role": "assistant", "content": target(rng, dom, kind, S, D, M, False, k)}]})
            control.append({"messages": [{"role": "system", "content": sys_c}, {"role": "user", "content": ask(dom, k)},
                                         {"role": "assistant", "content": target(rng, dom, kind, S, D, M, True, k)}]})
            meta.append({"domain": dom["key"], "kind": kind, "S": S, "D": D, "M": M, "k": k})
    order = list(range(len(direction)))
    rng.shuffle(order)
    out = Path("data")
    out.mkdir(exist_ok=True)
    for name, rows in (("direction", direction), ("control", control)):
        with open(out / f"{name}.jsonl", "w") as f:
            for i in order:
                f.write(json.dumps(rows[i]) + "\n")
    (out / "meta.json").write_text(json.dumps([meta[i] for i in order], indent=0))
    return direction, control, meta


if __name__ == "__main__":
    d, c, m = build()
    from collections import Counter
    print(len(d), Counter(x["kind"] for x in m))
    print(d[0]["messages"][0]["content"]); print(d[0]["messages"][2]["content"])
