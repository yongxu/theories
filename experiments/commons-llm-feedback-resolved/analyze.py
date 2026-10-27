"""Verdicts, measures and frozen readings of LA1b, by the rules frozen in PREDICTIONS-2026-10-27.md.

    python3 analyze.py      # checks the freeze, writes results/VERDICTS.json and prints a table

Verdicts are LA1's, on the final choices of seeds 0-4 of each condition: a locked condition passes where the
final choice is m = 0 in at least 4 of 5 seeds, an open one where it is m >= 1 in at least 4 of 5; the
contrasts L1-L4 are LA1's.  The measures pool every seed (k3s8 has 15).  The readings say which account of
LA1's locked-side misses the run supports.  Each consults every measure that bears on it and is printed
contradicted where one of them is against it; for every value of the measures exactly one is supported.
"""

import json
import math
import os
import subprocess

from game import ASSIGNED_ROUNDS, CHOSEN_ROUNDS, CONDITIONS, ORDERS, VERDICT_SEEDS

HERE = os.path.dirname(os.path.abspath(__file__))
SMALL = 0.85                # a restraint giving up at most 15% of the best threshold's value
LAST = CHOSEN_ROUNDS[-1]    # round 7, the last round played
# The files the run and its reading depend on, relative to this folder: its own code, data and predictions, and
# the code, values and answers it imports from LA1, CG1 and CG2.
FROZEN_FILES = ["agent.py", "analyze.py", "game.py", "run.py", "values.py", "scripted.py", "power.py",
                "PREDICTIONS-2026-10-27.md", "results/values.json", "results/power.json",
                "../commons-llm-feedback/values.py", "../commons-llm-feedback/agent.py",
                "../commons-llm-feedback/results/values.json", "../commons-llm-feedback/results/calls.jsonl",
                "../commons-llm-feedback/results/runs.json",
                "../commons-gated-renewal/commons.py", "../commons-outrun/calibrate.py"]


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


def load_values():
    return json.load(open(os.path.join(HERE, "results", "values.json")))


def seen(history):
    """The mean of the shown means (two decimals, as the prompt shows them) of each threshold played."""
    by = {}
    for h in history:
        by.setdefault(h["m"], []).append(round(h["reward"], 2))
    return {m: sum(v) / len(v) for m, v in by.items()}


def is_best(m, history):
    s = seen(history)
    return bool(s) and m in s and s[m] == max(s.values())


def first_played(r):
    """The first round (1-7) that played the final choice, or None where none did."""
    return next((i for i, h in enumerate(r["history"], 1) if h["m"] == r["final"]), None)


def chosen_in_5_to_7(r):
    """How many of rounds 5-7 played the final choice as the agent's own choice (not a fallback)."""
    return sum(1 for i in CHOSEN_ROUNDS if r["history"][i - 1]["kind"] == "chosen"
               and r["history"][i - 1]["m"] == r["final"])


def readings(ms):
    R, S, H = ms["R"], ms["R_small"], ms["R_small_held"]
    OS, I, P0, half = ms["open_short"], ms["invalid_finals"], ms["locked_first_at_0"], ms["locked_seeds"] // 2
    T = math.ceil(2 * R / 3)
    rules = {
        "resolution": dict(
            claim="LA1's locked-side misses read as feedback that barely resolved the best threshold, or never "
                  "showed it: with m = 0 assigned, resolved and seen, at most one locked seed ends with m >= 1, at "
                  "most one open seed ends short of the assigned m = 6's value, and at most one final choice in "
                  "all is invalid",
            consults="R, open_short, invalid_finals, locked_first_at_0",
            supported=R <= 1 and OS <= 1 and I <= 1 and P0 <= half,
            contradicted=R >= 3 or OS >= 2),
        "trained_restraint": dict(
            claim="a small restraint held against resolved, assigned feedback: at least 3 locked seeds end with "
                  "m >= 1, at least two thirds of them on a small restraint the model chose in at least two of "
                  "rounds 5-7, while at most one open seed ends short of the assigned m = 6's value. It is a "
                  "restraint brought from training, a pull of the assigned m = 6 that persists, differences near "
                  "the gap read as ties with the pick kept, or the assigned m = 1 re-checked in most chosen "
                  "rounds; the protocol does not tell these apart",
            consults="R, R_small, R_small_held, open_short, invalid_finals",
            supported=R >= 3 and H >= T and OS <= 1 and I <= 1,
            contradicted=R <= 1 or OS >= 2),
        "open_not_followed": dict(
            claim="the results are not followed where restraint pays: at least 2 open seeds end short of the "
                  "assigned m = 6's value, while at most one locked seed ends with m >= 1 (greedy, anchored on "
                  "m = 0, or kept to the first answer on the open side)",
            consults="R, open_short, invalid_finals",
            supported=OS >= 2 and R <= 1 and I <= 1,
            contradicted=OS <= 1 or R >= 3),
        "results_not_followed": dict(
            claim="the final choices do not follow resolved results: at least 3 locked seeds end with m >= 1, "
                  "and either at least 2 open seeds end short of the assigned m = 6's value, or more than a third "
                  "of the misses are large restraints (value share below 0.85)",
            consults="R, R_small, open_short",
            supported=R >= 3 and (OS >= 2 or S < T),
            contradicted=R <= 1),
    }
    if not any(r["supported"] for r in rules.values()):
        because = []
        if R == 2:
            because.append("R = 2")
        if I >= 2 and (R <= 1 or (OS <= 1 and S >= T)):
            because.append("invalid_finals >= 2")
        if R <= 1 and OS <= 1 and I <= 1 and P0 > half:
            because.append("locked_first_at_0 above half the locked seeds")
        if R >= 3 and OS <= 1 and S >= T and H < T:
            because.append("fewer than two thirds of the misses are small restraints chosen in two of rounds 5-7")
        rules["unresolved"] = dict(
            claim="no reading's rule is met: R = 2; two or more invalid final choices, with R <= 1, or with "
                  "R >= 3, open_short <= 1 and at least two thirds of the misses small; first answers at m = 0 in "
                  "more than half the locked seeds, with R <= 1 and open_short <= 1; or at least 3 misses, at "
                  "least two thirds small but fewer than two thirds small and chosen in two of rounds 5-7, where a "
                  "restraint is not told from ending on a last round that tried or re-checked it",
            consults="all", supported=True, contradicted=False, because=because)
    return rules


def check_rules(locked_seeds=30):
    """Every value of the measures the readings consult, with the ones read only against a threshold taken at
    each side of it: exactly one reading is supported, none is supported and contradicted, and unresolved
    always gives its reason.  Returns the number of cases checked."""
    n, half = 0, locked_seeds // 2
    for R in range(locked_seeds + 1):
        for S in range(R + 1):
            for H in range(S + 1):
                for OS in (0, 1, 2, 10):
                    for I in (0, 1, 2, 10):
                        for P0 in (0, half, half + 1, locked_seeds):
                            rs = readings(dict(R=R, R_small=S, R_small_held=H, open_short=OS, invalid_finals=I,
                                               locked_first_at_0=P0, locked_seeds=locked_seeds))
                            sup = [k for k, r in rs.items() if r["supported"]]
                            assert len(sup) == 1, (R, S, H, OS, I, P0, sup)
                            assert not any(r["supported"] and r["contradicted"] for r in rs.values())
                            assert sup != ["unresolved"] or rs["unresolved"]["because"], (R, S, H, OS, I, P0)
                            n += 1
    return n


def verdicts(runs, vals):
    out = dict(conditions={}, contrasts={}, measures={}, readings={})
    for name, c in CONDITIONS.items():
        rs = sorted((r for r in runs if r["cond"] == name), key=lambda r: r["seed"])
        finals = [r["final"] for r in rs]
        hit = (lambda m: m == 0) if c["lock"] == "locked" else (lambda m: m is not None and m >= 1)
        hits = sum(1 for m in finals[:VERDICT_SEEDS] if hit(m))
        share = vals[name]["value_share"]
        out["conditions"][name] = dict(
            cls=c["lock"], predicted="m = 0" if c["lock"] == "locked" else "m >= 1",
            first=[r["answers"][0] for r in rs], final=finals,
            final_value_share=[round(share[m], 3) if m is not None else None for m in finals],
            played=[[h["m"] for h in r["history"]] for r in rs],
            verdict_seeds=min(len(rs), VERDICT_SEEDS), hits=hits, verdict="passed" if hits >= 4 else "failed",
            seeds=len(rs), hits_all_seeds=sum(1 for m in finals if hit(m)))
    V = {n: d["verdict"] == "passed" for n, d in out["conditions"].items()}
    out["contrasts"] = dict(
        L1_locked_side=all(V[n] for n, c in CONDITIONS.items() if c["lock"] == "locked"),
        L2_open_side=all(V[n] for n, c in CONDITIONS.items() if c["lock"] == "open"),
        L3_end_weight_does_not_open=V["k3s1"] and V["k3s1_lam32"],
        L4_boundary_is_the_rest=V["k3s8"] and V["k2s8"])

    locked = [r for r in runs if CONDITIONS[r["cond"]]["lock"] == "locked"]
    opened = [r for r in runs if CONDITIONS[r["cond"]]["lock"] == "open"]
    missed = lambda r: r["final"] is not None and r["final"] >= 1
    misses = [r for r in locked if missed(r)]
    small = [r for r in misses if vals[r["cond"]]["value_share"][r["final"]] >= SMALL]
    order = lambda r: ORDERS[r["seed"] % len(ORDERS)]

    def tally(rs):
        return [sum(1 for r in rs if missed(r)), len(rs)]

    by_gap = {}
    for n, c in CONDITIONS.items():
        if c["lock"] == "locked":
            g = by_gap.setdefault(round(vals[n]["gap_share"], 3), dict(conditions=[], misses=0, seeds=0))
            k, s = tally([r for r in locked if r["cond"] == n])
            g["conditions"].append(n)
            g["misses"] += k
            g["seeds"] += s
    rates = [g["misses"] / g["seeds"] for _, g in sorted(by_gap.items()) if g["seeds"]]
    out["measures"] = dict(
        locked_seeds=len(locked), open_seeds=len(opened),
        R=len(misses), R_small=len(small),
        R_small_held=sum(1 for r in small if chosen_in_5_to_7(r) >= 2),
        R_new_at_7=sum(1 for r in misses if first_played(r) == LAST),
        R_by_condition={n: tally([r for r in locked if r["cond"] == n]) for n, c in CONDITIONS.items()
                        if c["lock"] == "locked"},
        R_by_gap={str(k): g for k, g in sorted(by_gap.items())},
        rate_rises_with_gap=any(b > a for i, a in enumerate(rates) for b in rates[i + 1:]),
        R_by_round_of_m6={rnd: tally([r for r in locked if ASSIGNED_ROUNDS[order(r).index(6)] == rnd])
                          for rnd in ASSIGNED_ROUNDS},
        R_by_last_assigned={m: tally([r for r in locked if order(r)[-1] == m]) for m in (0, 1, 6)},
        misses=[dict(cond=r["cond"], seed=r["seed"], final=r["final"],
                     value_share=round(vals[r["cond"]]["value_share"][r["final"]], 3),
                     first_played=first_played(r), chosen_in_5_to_7=chosen_in_5_to_7(r),
                     shown_final=seen(r["history"]).get(r["final"]), shown_m0=seen(r["history"]).get(0))
                for r in misses],
        open_short=sum(1 for r in opened if r["final"] is None
                       or vals[r["cond"]]["value_share"][r["final"]] < vals[r["cond"]]["value_share"][6]),
        open_at_0=sum(1 for r in opened if r["final"] == 0),
        invalid_finals=sum(1 for r in runs if r["final"] is None),
        locked_first_at_0=sum(1 for r in locked if r["answers"][0] == 0),
        final_is_best_seen={cls: sum(1 for r in rs if is_best(r["final"], r["history"]))
                            for cls, rs in (("locked", locked), ("open", opened))},
        final_is_best_of_own_rounds={cls: sum(1 for r in rs if is_best(r["final"], [h for h in r["history"]
                                                                                   if h["kind"] == "chosen"]))
                                     for cls, rs in (("locked", locked), ("open", opened))},
        moved={cls: sum(1 for r in rs if r["final"] != r["answers"][0]) for cls, rs in (("locked", locked),
                                                                                        ("open", opened))},
        chosen_rounds_trying_a_new_threshold=sum(
            1 for r in runs for i, h in enumerate(r["history"])
            if h["kind"] == "chosen" and i > 0 and h["m"] not in {g["m"] for g in r["history"][:i]}),
        open_seeds_that_played_7=sum(1 for r in opened if any(h["m"] == 7 for h in r["history"])),
        fallback_rounds=sum(1 for r in runs for h in r["history"] if h["kind"] == "fallback"))
    out["readings"] = readings(out["measures"])
    return out


def main():
    frozen = check_freeze()
    data = json.load(open(os.path.join(HERE, "results", "runs.json")))
    if data.get("frozen") != frozen:
        raise SystemExit(f"results/runs.json was made under freeze {data.get('frozen')}, not {frozen}")
    v = verdicts(data["runs"], load_values())
    v["frozen"] = frozen
    json.dump(v, open(os.path.join(HERE, "results", "VERDICTS.json"), "w"), indent=1)
    for n, d in v["conditions"].items():
        print(f"{n:11} {d['cls']:6} {d['predicted']:6} first {d['first']} final {d['final']} -> {d['verdict']} "
              f"({d['hits']} of {d['verdict_seeds']}; {d['hits_all_seeds']} of {d['seeds']} over every seed)")
    for k, x in v["contrasts"].items():
        print(k, "passed" if x else "failed")
    m = v["measures"]
    print({k: m[k] for k in ("R", "R_small", "R_small_held", "R_new_at_7", "R_by_condition", "open_short",
                             "open_at_0", "invalid_finals", "locked_first_at_0", "final_is_best_seen",
                             "final_is_best_of_own_rounds", "moved", "rate_rises_with_gap", "R_by_round_of_m6",
                             "R_by_last_assigned")})
    for k, r in v["readings"].items():
        print(f"{k}: {'supported' if r['supported'] else 'not supported'}"
              f"{'; contradicted' if r['contradicted'] else ''}"
              f"{' (' + '; '.join(r['because']) + ')' if r.get('because') else ''}")


if __name__ == "__main__":
    main()
