"""Post hoc readings of LA1c's run, written after its verdicts (README, "Post hoc").  Not frozen, not verdicts.

    python3 posthoc.py      # writes results/POSTHOC.json and prints a summary

1. The prior: the first answer, made before any result, in every seed, beside LA1's and LA1b's first answers to
   the same first prompt (scripted.PRIORS: LA1's five per condition, then LA1b's).
2. The search's first move: whether the second round played a higher threshold than the first (more restraint),
   a lower one, or the same.
3. The locked descent: by condition, the round in which m = 0 was first played (None where it never was), the
   seeds that had not played it by round 6, and how many of the moves down between rounds were of one step.
4. The open side by where the search started: the seeds whose first answer is m = 3 or 4 and those whose first
   answer is m = 0 or 1, how many of each played the hill and ended at m = 7, and the second round of each.
5. Tested past the best: the seeds that played the best and later a threshold more restrained than it (on the
   locked side any m >= 1, on the open side m = 8 or 9), and whether each ended at the best.
6. Selection: the final choices naming a threshold played, and how many of them are the best its own results
   showed (analyze.is_best); the final choices named without a round, and where they lie.
7. Beside the power check (a description, not a test): each scripted agent's mean seeds at the best, on each side,
   and the agents whose means reach the model's on each side.
"""

import json
import os

from analyze import BEST, HILL, is_best
from game import CONDITIONS
from scripted import PRIORS

HERE = os.path.dirname(os.path.abspath(__file__))


def main():
    runs = json.load(open(os.path.join(HERE, "results", "runs.json")))["runs"]
    power = json.load(open(os.path.join(HERE, "results", "power.json")))
    side = {n: c["lock"] for n, c in CONDITIONS.items()}
    by_side = {s: [r for r in runs if side[r["cond"]] == s] for s in ("locked", "open")}

    def count(xs):
        return {m: xs.count(m) for m in sorted(set(xs))}

    def played(r):
        return [h["m"] for h in r["history"]]

    def first_at(r, m):
        return next((i for i, x in enumerate(played(r), 1) if x == m), None)

    prior = {}
    for s, rs in by_side.items():
        firsts = [r["answers"][0] for r in rs]
        la1 = [m for n, ms in PRIORS.items() if side[n] == s for m in ms[:5]]
        la1b = [m for n, ms in PRIORS.items() if side[n] == s for m in ms[5:]]
        prior[s] = dict(first=count(firsts), seeds=len(rs), la1_first=count(la1), la1b_first=count(la1b))
    prior["locked"].update(first_at_0=sum(1 for r in by_side["locked"] if r["answers"][0] == 0))
    prior["open"].update(first_in_valley=sum(1 for r in by_side["open"] if r["answers"][0] <= 4),
                         la1_and_la1b_first_in_valley=sum(
                             1 for n, ms in PRIORS.items() if side[n] == "open" for m in ms if m <= 4),
                         la1_and_la1b_open_seeds=sum(len(ms) for n, ms in PRIORS.items() if side[n] == "open"))

    first_move = {}
    for s, rs in by_side.items():
        moves = [played(r)[1] - played(r)[0] for r in rs]
        first_move[s] = dict(up=sum(d > 0 for d in moves), down=sum(d < 0 for d in moves),
                             same=sum(d == 0 for d in moves), up_by=count([d for d in moves if d > 0]))

    descent = {}
    for n in CONDITIONS:
        if side[n] != "locked":
            continue
        rs = sorted((r for r in by_side["locked"] if r["cond"] == n), key=lambda r: r["seed"])
        rounds = [first_at(r, 0) for r in rs]
        downs = [a - b for r in rs for a, b in zip(played(r), played(r)[1:]) if b < a]
        descent[n] = dict(first_round_at_0=rounds,
                          not_played_by_round_6=sum(1 for i in rounds if i is None or i > 6), seeds=len(rs),
                          moves_down=len(downs), of_one_step=sum(1 for d in downs if d == 1))

    starts = {}
    for label, lo, hi in (("first_at_3_or_4", 3, 4), ("first_at_0_or_1", 0, 1)):
        rs = [r for r in by_side["open"] if lo <= r["answers"][0] <= hi]
        starts[label] = dict(
            seeds=len(rs), played_hill=sum(1 for r in rs if set(played(r)) & set(HILL)),
            ended_at_7=sum(1 for r in rs if r["final"] == BEST["open"]),
            each=[dict(cond=r["cond"], seed=r["seed"], first=r["answers"][0], second=played(r)[1],
                       highest_played=max(played(r)), final=r["final"]) for r in rs])

    past = {}
    for s, rs in by_side.items():
        best = BEST[s]
        beyond = (lambda m: m >= 1) if s == "locked" else (lambda m: m >= 8)
        hit = [r for r in rs if first_at(r, best) is not None]
        tested = [r for r in hit if any(beyond(m) for m in played(r)[first_at(r, best):])]
        past[s] = dict(played_best=len(hit), tested_past_it_later=len(tested),
                       of_them_ended_at_best=sum(1 for r in tested if r["final"] == best))

    named = [r for r in runs if r["final"] is not None and r["final"] in played(r)]
    unplayed = [r for r in runs if r["final"] is not None and r["final"] not in played(r)]
    selection = dict(
        finals_played=len(named), finals_played_best_seen=sum(1 for r in named if is_best(r["final"], r["history"])),
        finals_named_unplayed=[dict(cond=r["cond"], seed=r["seed"], final=r["final"], lowest_played=min(played(r)),
                                    highest_played=max(played(r))) for r in unplayed])

    model = {s: sum(1 for r in rs if r["final"] == BEST[s]) for s, rs in by_side.items()}
    agents = {a: {s: round(sum(x for n, x in p["at_best"].items() if side[n] == s), 2) for s in ("locked", "open")}
              for a, p in power["agents"].items()}
    beside = dict(model=model, agents=agents,
                  reaching_the_model={s: [a for a, m in agents.items() if m[s] >= model[s]] for s in model},
                  reaching_it_on_both=[a for a, m in agents.items() if all(m[s] >= model[s] for s in model)])

    out = dict(prior=prior, first_move=first_move, locked_descent=descent, open_by_start=starts,
               tested_past_the_best=past, selection=selection, beside_the_power_check=beside)
    json.dump(out, open(os.path.join(HERE, "results", "POSTHOC.json"), "w"), indent=1)

    for s in ("locked", "open"):
        print(f"prior, {s}:", prior[s])
    print("first move:", first_move)
    for n, d in descent.items():
        print(f"   {n:11} m = 0 first played in round {d['first_round_at_0']}; not by round 6: "
              f"{d['not_played_by_round_6']} of {d['seeds']}; moves down {d['moves_down']}, of one step "
              f"{d['of_one_step']}")
    for label, d in starts.items():
        print(f"open, {label}: {d['seeds']} seeds, {d['played_hill']} played the hill, {d['ended_at_7']} ended at m = 7")
        for e in d["each"]:
            print("     ", e)
    print("tested past the best:", past)
    print("selection:", selection)
    print("beside the power check: the model", model, "; reaching it", beside["reaching_the_model"],
          "; on both", beside["reaching_it_on_both"])


if __name__ == "__main__":
    main()
