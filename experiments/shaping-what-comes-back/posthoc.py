"""Post hoc readings of LA3's run, written after its verdicts (README, "Post hoc").  Not frozen, not verdicts.

    python3 posthoc.py      # writes results/POSTHOC.json and prints a table

1. The prior: the choice in round 0, made before any result, in every seed, and how many round-0 answers
   frame the game as a dilemma of free riding (the words matched are listed below).
2. Exploration: in each seed, the round at which the policy not chosen first was first played (none where
   it never was), and the scores the seed saw.
3. The bridge counted over every seed: among the seeds that played both policies, in how many the final
   choice was the one with the higher mean of the scores seen; among those that played one, in how many
   the final choice was that one.
"""

import json
import os
import re

from game import CONDITIONS, expected

HERE = os.path.dirname(os.path.abspath(__file__))
DILEMMA = re.compile(r"free.?rid|public.?good|tragedy|prisoner|nash|dominant|defect", re.I)


def main():
    runs = json.load(open(os.path.join(HERE, "results", "runs.json")))["runs"]
    calls = [json.loads(line) for line in open(os.path.join(HERE, "results", "calls.jsonl"))]
    round0 = {(c["cond"], c["seed"]): c for c in calls if c["round"] == 0}
    out = dict(conditions={}, totals={})
    both = both_better = one = one_kept = 0
    for name, cond in CONDITIONS.items():
        rows = []
        for r in (x for x in runs if x["cond"] == name):
            played = [h["policy"] for h in r["history"]]
            first = played[0]
            other = next((i + 1 for i, p in enumerate(played) if p != first), None)
            seen = {}
            for h in r["history"]:
                seen.setdefault(h["policy"], []).append(h["score"])
            mean = {k: sum(v) / len(v) for k, v in seen.items()}
            final = r["choices"][-1]
            if len(seen) == 2:
                both += 1
                better = max(mean, key=mean.get)
                both_better += final == better
            else:
                one += 1
                one_kept += final == first
            rows.append(dict(seed=r["seed"], round0=r["choices"][0], played=played, other_first_played_in=other,
                             mean_seen={k: round(v, 1) for k, v in mean.items()}, final=final,
                             round0_frames_a_dilemma=bool(DILEMMA.search(round0[(name, r["seed"])]["answer"]))))
        out["conditions"][name] = dict(expected={p: expected(cond, p) for p in "SN"}, seeds=rows)
    out["totals"] = dict(
        round0_N=sum(1 for c in out["conditions"].values() for s in c["seeds"] if s["round0"] == "N"),
        round0_frames_a_dilemma=sum(1 for c in out["conditions"].values() for s in c["seeds"]
                                    if s["round0_frames_a_dilemma"]),
        seeds=sum(len(c["seeds"]) for c in out["conditions"].values()),
        played_both=both, final_is_better_seen=both_better, played_one=one, final_is_the_one_played=one_kept)
    json.dump(out, open(os.path.join(HERE, "results", "POSTHOC.json"), "w"), indent=1)

    for name, c in out["conditions"].items():
        print(f"{name:8} E[S] {c['expected']['S']:>6} E[N] {c['expected']['N']:>6}")
        for s in c["seeds"]:
            print(f"   seed {s['seed']}: round 0 {s['round0']}, played {''.join(s['played'])}, other first played in "
                  f"round {s['other_first_played_in']}, mean seen {s['mean_seen']}, final {s['final']}, "
                  f"dilemma framing in round 0: {s['round0_frames_a_dilemma']}")
    print(out["totals"])


if __name__ == "__main__":
    main()
