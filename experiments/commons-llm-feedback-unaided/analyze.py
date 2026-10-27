"""Verdicts, measures and frozen readings of LA1c, by the rules frozen in PREDICTIONS-2026-10-28.md.

    python3 analyze.py      # checks the freeze, writes results/VERDICTS.json and prints a table

The headline is, on each side, how many seeds end at the best threshold (m = 0 locked, m = 7 open), with an exact
95% interval.  The bridge's selection part is the one prediction: on each side at most one seed ends below a
threshold it played that the rounds resolve as better (one round of each shows them in the wrong order with a
chance below 0.02), or with no valid final choice.  The readings say, on each side, how the seeds that miss the
best missed it, not how many did.  Each consults every measure that bears on it and is printed contradicted where
one of them is against it, and on each side, for every value of the measures, exactly one is supported.  LA1's
verdicts (a locked condition passes where the final choice is m = 0 in at least 4 of 5 of seeds 0-4, an open one
where it is m >= 1) and its contrasts L1-L4 are reported for comparison with LA1 and LA1b, not as predictions.
"""

import hashlib
import json
import math
import os
import subprocess

from game import CONDITIONS, EPISODES, LA1B, ROUNDS, VERDICT_SEEDS

HERE = os.path.dirname(os.path.abspath(__file__))
BEST = {"locked": 0, "open": 7}
HILL = (6, 7, 8)
# A threshold is worth more than another by a margin the rounds resolve where one round of each shows them in the
# wrong order with a chance below RESOLVED.  Every locked pair is resolved; the open pairs that are not:
RESOLVED = 0.02
UNRESOLVED_OPEN = {"k2s8": {(0, 1), (1, 4), (6, 8)}, "k3s16": {(0, 1), (0, 2), (1, 2), (2, 3), (3, 4)}}
# The files the run and its reading depend on, relative to this folder: its own code and predictions, and the
# code, values and answers it imports from LA1b, LA1, CG1 and CG2.
FROZEN_FILES = ["agent.py", "analyze.py", "game.py", "run.py", "scripted.py", "power.py",
                "PREDICTIONS-2026-10-28.md", "results/power.json",
                "../commons-llm-feedback-resolved/game.py", "../commons-llm-feedback-resolved/agent.py",
                "../commons-llm-feedback-resolved/results/values.json",
                "../commons-llm-feedback-resolved/results/calls.jsonl",
                "../commons-llm-feedback/values.py", "../commons-llm-feedback/agent.py",
                "../commons-llm-feedback/results/calls.jsonl", "../commons-llm-feedback/results/runs.json",
                "../commons-gated-renewal/commons.py", "../commons-outrun/calibrate.py"]
# The files the power check's numbers can depend on: every frozen file but this experiment's predictions and the
# power check's own output.  results/power.json carries their hashes, and is stale where one differs.
POWER_SOURCES = [p for p in FROZEN_FILES if p not in ("PREDICTIONS-2026-10-28.md", "results/power.json")]


def check_freeze():
    """The freeze commit named in results/FROZEN-AT, once every file in FROZEN_FILES is checked to be in that
    commit and unchanged since; otherwise the run, or its reading, stops."""
    frozen = open(os.path.join(HERE, "results", "FROZEN-AT")).read().split()[0]
    top = subprocess.run(["git", "rev-parse", "--show-toplevel"], cwd=HERE, capture_output=True,
                         text=True).stdout.strip()
    for p in FROZEN_FILES:
        rel = os.path.relpath(os.path.normpath(os.path.join(HERE, p)), top)
        if subprocess.run(["git", "cat-file", "-e", f"{frozen}:{rel}"], cwd=HERE, capture_output=True).returncode:
            raise SystemExit(f"{p} is not in the freeze commit {frozen}")
    diff = subprocess.run(["git", "diff", "--stat", frozen, "--", *FROZEN_FILES], cwd=HERE, capture_output=True,
                          text=True)
    if diff.returncode != 0 or diff.stdout.strip():
        raise SystemExit(f"files differ from the freeze commit {frozen}:\n{diff.stdout}{diff.stderr}")
    return frozen


def sources():
    """The sha256 of each file in POWER_SOURCES, as it is now."""
    return {p: hashlib.sha256(open(os.path.join(HERE, p), "rb").read()).hexdigest() for p in POWER_SOURCES}


def load_values():
    """LA1b's exact values (LA1's, recomputed and checked equal there) and each threshold's episode spread.  The best
    threshold is m = 0 in every locked condition and m = 7 in every open one, where m = 6, 7 and 8 are the hill:
    the thresholds worth at least m = 6's value.  The rounds resolve every locked pair, so on the locked side a
    threshold is better than another exactly where it is lower; on the open side they resolve every pair but those
    in UNRESOLVED_OPEN, among them every pair of a threshold on the hill and one off it, and m = 7 against m = 6
    and m = 8."""
    vals = json.load(open(os.path.join(LA1B, "results", "values.json")))
    better = better_pairs(vals)
    for n, c in CONDITIONS.items():
        assert vals[n]["best_threshold"] == BEST[c["lock"]], n
        if c["lock"] == "locked":
            assert better[n] == {(a, b) for a in range(10) for b in range(10) if a < b}, n
        else:
            share = vals[n]["value_share"]
            assert {m for m in range(10) if share[m] >= share[6]} == set(HILL), n
            assert {(min(a, b), max(a, b)) for a in range(10) for b in range(10)
                    if a != b and (a, b) not in better[n] and (b, a) not in better[n]} == UNRESOLVED_OPEN[n], n
            assert all((h, o) in better[n] for h in HILL for o in range(10) if o not in HILL), n
            assert {(7, 6), (7, 8)} <= better[n], n
    return vals


def wrong_order(vals, n, a, b, episodes=EPISODES):
    """The chance that one round of the worse of thresholds a and b shows a mean reward at least the better's, to
    two decimals as shown: the normal approximation, with a slack of 0.01 for the rounding."""
    v, sd = vals[n]["values"], vals[n]["episode_sd"]
    s = math.sqrt((sd[a] ** 2 + sd[b] ** 2) / episodes)
    return 0.5 * (1 + math.erf(-(abs(v[a] - v[b]) - 0.01) / s / math.sqrt(2)))


_better = []


def better_pairs(vals):
    """For each condition, the pairs (a, b) where a is worth more than b by a margin the rounds resolve."""
    for v, b in _better:
        if v is vals:
            return b
    b = {n: {(a, c) for a in range(10) for c in range(10)
             if vals[n]["values"][a] > vals[n]["values"][c] and wrong_order(vals, n, a, c) < RESOLVED}
         for n in CONDITIONS}
    _better.append((vals, b))
    return b


def seen(history):
    """The mean of the shown means (two decimals, as the prompt shows them) of each threshold played."""
    by = {}
    for h in history:
        by.setdefault(h["m"], []).append(round(h["reward"], 2))
    return {m: sum(v) / len(v) for m, v in by.items()}


def is_best(m, history):
    s = seen(history)
    return bool(s) and m in s and s[m] == max(s.values())


def first_in(r, ms):
    """The first round (1-7) that played a threshold in `ms`, or None where none did."""
    return next((i for i, h in enumerate(r["history"], 1) if h["m"] in ms), None)


def new_lows(r):
    """The rounds in which the lowest threshold played so far fell: round 1, and each round that played below every
    round before it."""
    out, low = [], None
    for i, h in enumerate(r["history"], 1):
        if low is None or h["m"] < low:
            out.append(i)
            low = h["m"]
    return out


def better_played(r, better):
    """The thresholds played that are worth more than the final choice by a margin the rounds resolve."""
    return {h["m"] for h in r["history"] if (h["m"], r["final"]) in better}


def locked_kind(r, better):
    """A locked miss, a final choice of m >= 1, is of one kind:
    `left`: some threshold played is better than the final choice: on the locked side, the final choice is above the
      lowest threshold played.  Every miss that played m = 0 is of it;
    `descending`: otherwise, where the search was still reaching new lows at its own pace when the rounds ended: it
      reached one after round 1, and the rounds since its last are no more than its longest wait between them (one
      round of grace: a search one step a round that repeats its last threshold in round 7 is still descending);
    `stopped`: otherwise, a search that had stalled against its own pace, or never went below its first round.
    The kinds read the rounds played; a final choice named below them is reported beside (R_named_below)."""
    if better_played(r, better):
        return "left"
    lows = new_lows(r)
    if len(lows) >= 2 and ROUNDS - lows[-1] <= max(b - a for a, b in zip(lows, lows[1:])):
        return "descending"
    return "stopped"


def open_kind(r, better):
    """An open miss with a valid final choice other than m = 7 is of one kind:
    `left`: some threshold played is better than the final choice: every final choice off the hill with a round on
      it, every m = 6 or 8 with a round at m = 7, and the final choices below a better threshold played in the
      valley, or (in k3s16) at m = 6 with a round at m = 8;
    `hill`: otherwise, where some round played the hill and the final choice is m = 6 or 8, short of m = 7, which
      no round played;
    `valley`: otherwise: no round played the hill.  The final choice may still name m = 6 or 8, unplayed
      (O_valley_named_on_hill)."""
    if better_played(r, better):
        return "left"
    played = {h["m"] for h in r["history"]}
    return "hill" if r["final"] in HILL and played & set(HILL) else "valley"


def held_after(r, ms):
    """How many chosen rounds, after the first that played a threshold in `ms`, played the final choice: a final
    choice played in at least two chosen rounds after a better one was played, where it is at least two."""
    i = first_in(r, ms)
    if i is None:
        return 0
    return sum(1 for h in r["history"][i:] if h["kind"] == "chosen" and h["m"] == r["final"])


def new_at_last(r):
    """The final choice was first played in round 7, the last."""
    return first_in(r, (r["final"],)) == ROUNDS


def interval(k, n, level=0.95):
    """The exact (Clopper-Pearson) interval for k successes in n."""
    a = (1 - level) / 2

    def cdf(p, x):
        return sum(math.comb(n, j) * p ** j * (1 - p) ** (n - j) for j in range(x + 1))

    def root(f, target, rising):
        lo, hi = 0.0, 1.0
        for _ in range(100):
            mid = (lo + hi) / 2
            if (f(mid) < target) == rising:
                lo = mid
            else:
                hi = mid
        return (lo + hi) / 2
    lower = 0.0 if k == 0 else root(lambda p: 1 - cdf(p, k - 1), a, True)
    upper = 1.0 if k == n else root(lambda p: cdf(p, k), a, False)
    return [round(lower, 3), round(upper, 3)]


def readings_locked(ms):
    R, L, D, S = ms["R"], ms["R_left"], ms["R_descending"], ms["R_stopped"]
    I, P0, half = ms["invalid_locked"], ms["locked_first_at_0"], ms["locked_seeds"] // 2
    T = math.ceil(2 * R / 3)
    rules = {
        "found": dict(
            claim="the model's own search ends at the best threshold in all locked seeds but at most one: at most one "
                  "ends with m >= 1, and at most one final choice is invalid",
            consults="R, invalid_locked, locked_first_at_0",
            supported=R <= 1 and I <= 1 and P0 <= half,
            contradicted=R >= 3),
        "best_not_kept": dict(
            claim="at least 3 locked seeds end with m >= 1, and most of them (two thirds) end above the lowest "
                  "threshold they played, which the rounds resolve as better",
            consults="R, R_left, R_descending, R_stopped, invalid_locked",
            supported=R >= 3 and L >= T and I <= 1,
            contradicted=R <= 1 or D + S >= T),
        "still_descending": dict(
            claim="at least 3 locked seeds end with m >= 1, and most of them (two thirds) end at or below the lowest "
                  "threshold they played, m = 0 unplayed, with their search still reaching new lows at its own pace "
                  "when the rounds ended",
            consults="R, R_left, R_descending, R_stopped, invalid_locked",
            supported=R >= 3 and D >= T and I <= 1,
            contradicted=R <= 1 or L + S >= T),
        "stopped_short": dict(
            claim="at least 3 locked seeds end with m >= 1, and most of them (two thirds) end at or below the lowest "
                  "threshold they played, m = 0 unplayed, with their search stalled against its own pace or never "
                  "below its first round",
            consults="R, R_left, R_descending, R_stopped, invalid_locked",
            supported=R >= 3 and S >= T and I <= 1,
            contradicted=R <= 1 or L + D >= T),
    }
    if not any(r["supported"] for r in rules.values()):
        because = []
        if R == 2:
            because.append("R = 2")
        if I >= 2:
            because.append("invalid_locked >= 2")
        if R <= 1 and P0 > half:
            because.append("locked_first_at_0 above half the locked seeds")
        if R >= 3 and max(L, D, S) < T:
            because.append("no kind of locked miss makes two thirds of them")
        rules["unresolved"] = dict(
            claim="no reading's rule is met on the locked side: R = 2; two or more invalid locked final choices; first "
                  "answers at m = 0 in more than half the locked seeds, with R <= 1; or at least 3 misses of which no "
                  "kind (left, still descending, stopped) makes two thirds",
            consults="all", supported=True, contradicted=False, because=because)
    return rules


def readings_open(ms):
    M, L, H, V = ms["open_miss"], ms["O_left"], ms["O_hill"], ms["O_valley"]
    I, F7, half = ms["invalid_open"], ms["open_first_at_7"], ms["open_seeds"] // 2
    T = math.ceil(2 * M / 3)
    rules = {
        "found": dict(
            claim="the model's own search ends at the best threshold in all open seeds but at most one: at most one "
                  "ends with a final choice other than m = 7, or none",
            consults="open_miss, open_first_at_7",
            supported=M <= 1 and F7 <= half,
            contradicted=M >= 2),
        "best_not_kept": dict(
            claim="at least 2 open seeds end off m = 7, and most of them (two thirds) end below a threshold they "
                  "played that the rounds resolve as better, more restrained or less (O_left_up, O_left_down)",
            consults="open_miss, O_left, O_hill, O_valley, invalid_open",
            supported=M >= 2 and L >= T and I <= 1,
            contradicted=M <= 1 or H + V >= T),
        "stopped_on_hill": dict(
            claim="at least 2 open seeds end off m = 7, and most of them (two thirds) played the hill and end at "
                  "m = 6 or 8 without any round at m = 7",
            consults="open_miss, O_left, O_hill, O_valley, invalid_open",
            supported=M >= 2 and H >= T and I <= 1,
            contradicted=M <= 1 or L + V >= T),
        "not_reached": dict(
            claim="at least 2 open seeds end off m = 7, and most of them (two thirds) never played the hill (m = 6, 7 "
                  "or 8), whatever their final choice names",
            consults="open_miss, O_left, O_hill, O_valley, invalid_open",
            supported=M >= 2 and V >= T and I <= 1,
            contradicted=M <= 1 or L + H >= T),
    }
    if not any(r["supported"] for r in rules.values()):
        because = []
        if M <= 1 and F7 > half:
            because.append("open_first_at_7 above half the open seeds")
        if M >= 2 and I >= 2:
            because.append("invalid_open >= 2")
        if M >= 2 and max(L, H, V) < T:
            because.append("no kind of open miss makes two thirds of them")
        rules["unresolved"] = dict(
            claim="no reading's rule is met on the open side: first answers at m = 7 in more than half the open seeds, "
                  "with open_miss <= 1; two or more invalid open final choices; or at least 2 open misses of which no "
                  "kind (left, on the hill short of m = 7, never on the hill) makes two thirds",
            consults="all", supported=True, contradicted=False, because=because)
    return rules


def check_family(rs, case):
    sup = [k for k, r in rs.items() if r["supported"]]
    assert len(sup) == 1, (case, sup)
    assert not any(r["supported"] and r["contradicted"] for r in rs.values()), case
    assert sup != ["unresolved"] or rs["unresolved"]["because"], case


def check_rules(locked_seeds=30, open_seeds=10):
    """Every value of the measures the readings consult, with the ones read only against a threshold taken at
    each side of it: on each side exactly one reading is supported, none is supported and contradicted, and
    unresolved always gives its reason.  Returns the number of cases checked."""
    n, half = 0, locked_seeds // 2
    for R in range(locked_seeds + 1):
        for L in range(R + 1):
            for D in range(R - L + 1):
                for I in (0, 1, 2, locked_seeds):
                    for P0 in (0, half, half + 1, locked_seeds):
                        if R + I > locked_seeds:
                            continue
                        check_family(readings_locked(dict(
                            R=R, R_left=L, R_descending=D, R_stopped=R - L - D, invalid_locked=I,
                            locked_first_at_0=P0, locked_seeds=locked_seeds)), (R, L, D, I, P0))
                        n += 1
    half = open_seeds // 2
    for M in range(open_seeds + 1):
        for L in range(M + 1):
            for H in range(M - L + 1):
                for V in range(M - L - H + 1):
                    for F7 in (0, half, half + 1, open_seeds):
                        check_family(readings_open(dict(
                            open_miss=M, O_left=L, O_hill=H, O_valley=V, invalid_open=M - L - H - V,
                            open_first_at_7=F7, open_seeds=open_seeds)), (M, L, H, V, F7))
                        n += 1
    return n


def verdicts(runs, vals):
    out = dict(rates={}, prediction={}, conditions={}, contrasts={}, measures={}, readings={})
    for name, c in CONDITIONS.items():
        rs = sorted((r for r in runs if r["cond"] == name), key=lambda r: r["seed"])
        finals = [r["final"] for r in rs]
        hit = (lambda m: m == 0) if c["lock"] == "locked" else (lambda m: m is not None and m >= 1)
        share = vals[name]["value_share"]
        hits = sum(1 for m in finals[:VERDICT_SEEDS] if hit(m))
        out["conditions"][name] = dict(
            cls=c["lock"], predicted_by_la1="m = 0" if c["lock"] == "locked" else "m >= 1",
            first=[r["answers"][0] for r in rs], final=finals,
            final_value_share=[round(share[m], 3) if m is not None else None for m in finals],
            played=[[h["m"] for h in r["history"]] for r in rs],
            verdict_seeds=min(len(rs), VERDICT_SEEDS), hits=hits, verdict="passed" if hits >= 4 else "failed",
            seeds=len(rs), hits_all_seeds=sum(1 for m in finals if hit(m)),
            at_best=sum(1 for m in finals if m == BEST[c["lock"]]),
            on_hill=sum(1 for m in finals if m in HILL) if c["lock"] == "open" else None)
    V = {n: d["verdict"] == "passed" for n, d in out["conditions"].items()}
    out["contrasts"] = dict(
        L1_locked_side=all(V[n] for n, c in CONDITIONS.items() if c["lock"] == "locked"),
        L2_open_side=all(V[n] for n, c in CONDITIONS.items() if c["lock"] == "open"),
        L3_end_weight_does_not_open=V["k3s1"] and V["k3s1_lam32"],
        L4_boundary_is_the_rest=V["k3s8"] and V["k2s8"])

    locked = [r for r in runs if CONDITIONS[r["cond"]]["lock"] == "locked"]
    opened = [r for r in runs if CONDITIONS[r["cond"]]["lock"] == "open"]
    better = better_pairs(vals)
    misses = [r for r in locked if r["final"] is not None and r["final"] >= 1]
    off = [r for r in opened if r["final"] is not None and r["final"] != BEST["open"]]
    kinds = [locked_kind(r, better[r["cond"]]) for r in misses]
    okinds = [open_kind(r, better[r["cond"]]) for r in off]
    left = [r for r, k in zip(misses, kinds) if k == "left"]
    oleft = [r for r, k in zip(off, okinds) if k == "left"]
    invalid_locked = sum(1 for r in locked if r["final"] is None)
    invalid_open = sum(1 for r in opened if r["final"] is None)
    seeds = {n: sum(1 for r in runs if r["cond"] == n) for n in CONDITIONS}

    def by_condition(rs, cls):
        return {n: [sum(1 for r in rs if r["cond"] == n), seeds[n]] for n, c in CONDITIONS.items() if c["lock"] == cls}

    def rate(rs, cls):
        at = [r for r in rs if r["final"] == BEST[cls]]
        return dict(at_best=len(at), seeds=len(rs), interval_95=interval(len(at), len(rs)),
                    played_best=sum(1 for r in at if first_in(r, (BEST[cls],)) is not None))

    out["rates"] = dict(locked=rate(locked, "locked"), open=rate(opened, "open"))
    out["prediction"] = dict(
        selection_locked=len(left) + invalid_locked <= 1, selection_open=len(oleft) + invalid_open <= 1)
    out["prediction"]["selection"] = out["prediction"]["selection_locked"] and out["prediction"]["selection_open"]
    out["measures"] = dict(
        locked_seeds=len(locked), open_seeds=len(opened),
        R=len(misses), R_left=len(left), R_descending=kinds.count("descending"), R_stopped=kinds.count("stopped"),
        R_seen=sum(1 for r in misses if first_in(r, (0,)) is not None),
        R_left_held=sum(1 for r in left if held_after(r, better_played(r, better[r["cond"]])) >= 2),
        R_left_new_at_7=sum(1 for r in left if new_at_last(r)),
        R_never_moved=sum(1 for r in misses if len({h["m"] for h in r["history"]}) == 1),
        R_named_below=sum(1 for r in misses if r["final"] < min(h["m"] for h in r["history"])),
        invalid_locked=invalid_locked,
        locked_first_at_0=sum(1 for r in locked if r["answers"][0] == 0),
        locked_best_played=out["rates"]["locked"]["played_best"], open_best_played=out["rates"]["open"]["played_best"],
        open_miss=len(off) + invalid_open, O_left=len(oleft), O_hill=okinds.count("hill"),
        O_valley=okinds.count("valley"),
        O_left_up=sum(1 for r in oleft if max(better_played(r, better[r["cond"]])) > r["final"]),
        O_left_down=sum(1 for r in oleft if max(better_played(r, better[r["cond"]])) < r["final"]),
        O_valley_named_on_hill=sum(1 for r, k in zip(off, okinds) if k == "valley" and r["final"] in HILL),
        O_left_held=sum(1 for r in oleft if held_after(r, better_played(r, better[r["cond"]])) >= 2),
        O_left_new_at_7=sum(1 for r in oleft if new_at_last(r)),
        invalid_open=invalid_open,
        open_first_at_7=sum(1 for r in opened if r["answers"][0] == BEST["open"]),
        open_on_hill=sum(1 for r in opened if r["final"] in HILL),
        open_at_0=sum(1 for r in opened if r["final"] == 0),
        invalid_finals=invalid_locked + invalid_open,
        R_by_condition=by_condition(misses, "locked"),
        open_miss_by_condition=by_condition(off + [r for r in opened if r["final"] is None], "open"),
        misses=[dict(cond=r["cond"], seed=r["seed"], final=r["final"],
                     value_share=round(vals[r["cond"]]["value_share"][r["final"]], 3), kind=k,
                     played=[h["m"] for h in r["history"]], highest_played=max(h["m"] for h in r["history"]),
                     better_played=sorted(better_played(r, better[r["cond"]])),
                     final_is_best_seen=is_best(r["final"], r["history"]),
                     named_unplayed=r["final"] not in {h["m"] for h in r["history"]}, answers=r["answers"])
                for r, k in list(zip(misses, kinds)) + list(zip(off, okinds))],
        first_round_at_best={cls: [first_in(r, (BEST[cls],)) for r in rs]
                             for cls, rs in (("locked", locked), ("open", opened))},
        final_is_best_seen={cls: sum(1 for r in rs if is_best(r["final"], r["history"]))
                            for cls, rs in (("locked", locked), ("open", opened))},
        moved={cls: sum(1 for r in rs if r["final"] != r["answers"][0]) for cls, rs in (("locked", locked),
                                                                                        ("open", opened))},
        chosen_rounds_trying_a_new_threshold=sum(
            1 for r in runs for i, h in enumerate(r["history"])
            if h["kind"] == "chosen" and i > 0 and h["m"] not in {g["m"] for g in r["history"][:i]}),
        fallback_rounds=sum(1 for r in runs for h in r["history"] if h["kind"] == "fallback"))
    out["readings"] = dict(locked=readings_locked(out["measures"]), open=readings_open(out["measures"]))
    return out


def main():
    frozen = check_freeze()
    data = json.load(open(os.path.join(HERE, "results", "runs.json")))
    if data.get("frozen") != frozen:
        raise SystemExit(f"results/runs.json was made under freeze {data.get('frozen')}, not {frozen}")
    v = verdicts(data["runs"], load_values())
    v["frozen"] = frozen
    json.dump(v, open(os.path.join(HERE, "results", "VERDICTS.json"), "w"), indent=1)
    for side, r in v["rates"].items():
        print(f"{side}: at the best threshold in {r['at_best']} of {r['seeds']} seeds (95% interval "
              f"{r['interval_95'][0]:.3f} to {r['interval_95'][1]:.3f}); {r['played_best']} of them played it")
    print("prediction (selection):", {k: "passed" if x else "failed" for k, x in v["prediction"].items()})
    for n, d in v["conditions"].items():
        print(f"{n:11} {d['cls']:6} first {d['first']} final {d['final']} -> LA1's rule {d['verdict']} ({d['hits']} of "
              f"{d['verdict_seeds']}; {d['hits_all_seeds']} of {d['seeds']} over every seed); at the best "
              f"{d['at_best']} of {d['seeds']}" + (f", on the hill {d['on_hill']}" if d["on_hill"] is not None else ""))
    for k, x in v["contrasts"].items():
        print(k, "passed" if x else "failed")
    m = v["measures"]
    print({k: m[k] for k in ("R", "R_left", "R_descending", "R_stopped", "R_seen", "R_left_held", "R_left_new_at_7",
                             "R_never_moved", "R_named_below", "invalid_locked", "locked_first_at_0", "open_miss",
                             "O_left", "O_left_up", "O_left_down", "O_hill", "O_valley", "O_valley_named_on_hill",
                             "O_left_held", "O_left_new_at_7", "invalid_open", "open_first_at_7",
                             "open_on_hill", "open_at_0", "R_by_condition", "open_miss_by_condition",
                             "final_is_best_seen", "moved", "first_round_at_best",
                             "chosen_rounds_trying_a_new_threshold", "fallback_rounds")})
    for side, rs in v["readings"].items():
        for k, r in rs.items():
            print(f"{side} {k}: {'supported' if r['supported'] else 'not supported'}"
                  f"{'; contradicted' if r['contradicted'] else ''}"
                  f"{' (' + '; '.join(r['because']) + ')' if r.get('because') else ''}")


if __name__ == "__main__":
    main()
