"""The verdicts of TR7 from a run's log, by the frozen rule (tr7_rule.py).

    python3 -B tr7_verdicts.py results/tr7/<pin folder>     # writes verdicts.json beside calls.jsonl

A folder is read by freeze 1's reader (told/verdicts.py load), imported unchanged, given this freeze's
plan, call builder and frozen check (tr7_run.plan, tr7_run.prepared, tr7_run.frozen) and freeze 1's
parser. So it refuses all freeze 1's reader refuses (its docstring): a folder not a scored run's; a
scored run whose frozen files are not as this freeze's newest link commits them, or that lists a link
not this freeze's chain's; a pin not frozen; a record whose fields, letters, prompt hash or request
differ from those its id rebuilds, whose answer the parser reads otherwise, or that another model
answered; a record not in the plan; and a call logged again after a good record of it. A record not
made between two catalog reads naming the pin's dated slug is not read, and a framing only partly read
has no verdict and is listed. This reader also refuses a record whose play is not the one the
generator gives its id and answer (tr7_run.played). Each unit, a pin and a framing, is read by the
rule, the oversight framing with the neutral framing's premises of the same pin where that framing is
read (tr7_rule.premise); while the neutral framing is partly read and its stop does not stand, the
oversight framing waits, since its premises may be the neutral framing's. Its reading is printed with
the pin's role, and an untestable one with why: a pin of the theory's own family is reported apart and
decides nothing alone (told/PINS.json, "rule"). A framing with no reading is listed with why
(not_read), one stopped by the pin's own answers at a smoke run as what that pin did; each framing's
stop that stands, whether section 12's expectation for the oversight framing is met
(tr7_rule.oversight_expectation), and every start of `run` are written into verdicts.json, with each
line section 8's procedure moved out of a log (moved). A folder whose logs freeze 1's code cannot read
or go on from is refused before anything is read (tr7_run.cut_short). The plays' points are reported
beside the verdicts and read by no rule.
"""

import json
import sys
from collections import Counter, defaultdict
from pathlib import Path

import tr7_conditions as C        # first: puts freeze 1's harness and tr7.py on the path
import tr7_rule as rule7
import tr7_run as RUN
import run as R                   # freeze 1's (told/run.py)
import verdicts as VD             # freeze 1's (told/verdicts.py)

C.own_files()


def load(folder, allow_dry=False, frozen=None):
    """The folder's meta and the records it reads, by freeze 1's reader with this freeze's plan, call
    builder and frozen check (tr7_run.frozen; the dry run passes one bound to a stand-in repository);
    each record's play checked."""
    meta, recs = VD.load(folder, allow_dry, plan=lambda test, family: RUN.plan(test, family),
                         prepare=RUN.prepared, frozen=frozen or RUN.frozen)
    by = C.by_id()
    for r in recs:
        if r.get("played") != RUN.played(r, by[r["condition"]]):
            raise SystemExit(f"{r['id']}: the record's play is not the one the generator gives its id and answer")
    return meta, recs


def units(meta, recs, neutral_stood=False):
    """The rule's reading for each unit (pin, framing) of the log, and its plays' points. The oversight
    framing waits while the neutral framing is partly read and its stop does not stand (neutral_stood):
    it is read once that framing is complete, with its premises, or on its own premises alone where the
    neutral framing's stop stands, so that none of its calls will be made: section 8's rule lets that
    stop stand only before the neutral framing's run has begun (tr7_run.begun), and the reading is the
    same were part of its calls logged."""
    conds = C.conditions()
    by = defaultdict(lambda: {"answers": defaultdict(list), "comps": defaultdict(list), "points": defaultdict(list)})
    for r in sorted(recs, key=lambda r: r["id"]):
        u = by[r["context"]]
        if r["kind"] == "choice":
            u["answers"][r["condition"]].append(r["answer"])
            if r["played"] is not None:
                u["points"][r["condition"]].append(r["played"]["points"])
        else:
            u["comps"][r["condition"]].append(r["probe"])
    out = {}
    neutral = rule7.neutral_premises(conds, by["neutral"]["comps"]) if "neutral" in by else None
    waits = "neutral" in (meta.get("partial_contexts") or {}) and not neutral_stood
    for framing in [f for f in C.FRAMINGS if f in by and not (f == "oversight" and waits)]:
        u = by[framing]
        v = rule7.unit_verdict(conds, u["answers"], u["comps"], framing, neutral if framing == "oversight" else None)
        v["plays"] = {cid: {"played": len(ps), "mean_points": round(sum(ps) / len(ps), 3) if ps else None}
                      for cid, ps in sorted(u["points"].items())}
        out[framing] = v
    return out


def not_read(meta, v, runs, read=()):
    """Each framing with no reading, and why (FREEZE-4.md, section 6): partly read itself, with its stop
    where it stands, or the latest smoke run's stop of the run where that holds it; the oversight
    framing, its calls read (read: the framings with records read), waiting on the neutral framing,
    partly read, whose stop does not stand; no call in the folder because the pin's own answers stopped
    the framing at a smoke run, a stop that stands, what that pin did; because the pin's latest smoke run
    stopped it, a stop of the run, which a later smoke run that passes lifts; or because no start asked
    for it. runs: the pin's smoke runs as tr7_run.smoke_runs reads them now, so a smoke run made after
    the last start counts."""
    partial = meta.get("partial_contexts") or {}
    asked = {f for s in meta.get("starts") or [] for f in s.get("framings", [])}
    held = RUN.stood(runs)
    last = runs[-1] if runs else None
    out = {}
    for f in [f for f in C.FRAMINGS if f not in v]:
        if f in partial:
            out[f] = (f"no verdict: {partial[f]['read']} of {partial[f]['planned']} calls read"
                      + (f"; stopped by the pin's own answers at its smoke run ({held[f]}), a stop that stands"
                         if held[f] else
                         f"; held by the pin's latest smoke run ({last['folder']}), a stop of the run, which a later "
                         "smoke run that passes lifts" if last and not last["go_on"][f] else ""))
        elif f == "oversight" and "neutral" in partial and f in read:
            out[f] = "waits on the neutral framing, partly read, whose premises may stand in for its own"
        elif held[f]:
            out[f] = f"not run: stopped by the pin's own answers at its smoke run ({held[f]}), a stop that stands"
        elif last and not last["go_on"][f]:
            out[f] = (f"not run: stopped at the pin's latest smoke run ({last['folder']}), a stop of the run, which a "
                      "later smoke run that passes lifts")
        elif f not in asked:
            out[f] = "not run: not asked"
        else:
            out[f] = "no call logged"
    return out


def moved(folder):
    """The lines section 8's procedure moved out of the folder's logs (FREEZE-4.md), per .cut file: each
    moved line, as UTF-8 with any byte that does not decode replaced, since a line cut inside a character
    does not decode, with the line after it, beginning "# cut ", naming the time, the log as it stood
    before the move, the starts of `run` the meta listed and, where known, the cause; and whether the file
    holds whole pairs, each note so begun."""
    out = {}
    for name in RUN.LOGS:
        p = Path(folder) / (name + ".cut")
        if p.exists():
            lines = p.read_bytes().split(b"\n")
            lines = [n.decode("utf-8", "replace") for n in (lines[:-1] if lines and not lines[-1] else lines)]
            notes = lines[1::2]
            out[p.name] = {"lines moved": [{"line": m, "note": n[2:] if n.startswith("# ") else n}
                                           for m, n in zip(lines[0::2], notes)],
                           "whole": len(lines) % 2 == 0 and all(n.startswith("# cut ") for n in notes)}
    return out


def added(folder):
    """The times of the reads naming no snapshot that section 8's procedure put in the folder's catalog
    (FREEZE-4.md), one where a catalog read moved: freeze 1's code logs none."""
    return [t for t, slug in R.catalog_reads(folder) if slug is None]


def main(folder):
    RUN.refuse_cut(folder, "nothing was read")
    meta, recs = load(folder)
    runs = RUN.smoke_runs(meta["family"])
    held = RUN.stood(runs)
    v = units(meta, recs, held["neutral"] is not None)
    role = R.pin(meta["family"])["role"]
    expect = rule7.oversight_expectation(C.conditions(), v.get("neutral"), v.get("oversight"))
    res = {"test": meta["test"], "family": meta["family"], "pin_role": role, "units": v,
           "not_read": not_read(meta, v, runs, {r["context"] for r in recs}), "stops that stand": held,
           "section 12, the oversight framing's expectation met": expect,
           "no_verdict_partly_logged": meta["partial_contexts"],
           "calls_made_again": meta["made_again"], "read_under": meta["read_under"], "starts": meta.get("starts", []),
           "lines moved by section 8's procedure": moved(folder),
           "reads naming no snapshot put in by section 8's procedure, their times": added(folder)}
    (Path(folder) / "verdicts.json").write_text(json.dumps(res, indent=1) + "\n", encoding="utf-8")
    for ctx, why in res["not_read"].items():
        p = meta["partial_contexts"].get(ctx)
        print(f"tr7 {meta['family']} [{role}] {ctx}: {why}"
              + (f" ({p['not_between_good_catalog_reads']} made where no two catalog reads name the frozen snapshot)"
                 if p and p["not_between_good_catalog_reads"] else ""))
    for ctx, u in v.items():
        print(f"tr7 {meta['family']} [{role}] {ctx}: {u['reading']}"
              + (f" at {u['contradicted_at']}" if u["contradicted_at"] else "")
              + (f", declined at {u['declined_at']}" if u["declined_at"] else "")
              + (f" ({u['why']})" if "why" in u else "")
              + (f"; unread {u['unread']}" if u["unread"] and u["reading"] == "contradicted" else "")
              + (f"; premise from the neutral framing at {u['premise_from_neutral']}" if u["premise_from_neutral"]
                 else ""))
    print(f"tr7 {meta['family']} [{role}] section 12's expectation for the oversight framing: "
          + {True: "met", False: "not met", None: "not assessed, a framing has no reading"}[expect])
    for t in res["reads naming no snapshot put in by section 8's procedure, their times"]:
        print(f"tr7 {meta['family']} [{role}] a read naming no snapshot, put in by section 8's procedure at t {t}")



def smoke_report(folder, stopped=None, neutral_stood=False, neutral_read=False, may_stand=None):
    """The smoke run's report and its stop rule, per framing (FREEZE-4.md, section 8), as
    tr7_run.smoke_stops reads its records: each framing's go or stop; the calls that stop both framings
    (another model, another catalog slug), and per framing those that stop it, a stop of the run (the
    provider's act, the token limit) or by the pin's own answers, a stop that stands; neutral_stood:
    whether an earlier smoke run's neutral stop stands; neutral_read: whether the neutral framing is
    read whole, so that the oversight framing's premise is not its own; may_stand: per framing, whether
    the pin's own answers may stop it, not once its run has begun (tr7_run.begun), such
    answers then reported as stopping nothing. Reported too: the lines of the log that do not read, the
    restatements giving no number, the served models, the catalog's slug, how many readable
    comprehension answers restate the smoke conditions' numbers (the premise's preview, not a stop: the
    premise is read in the scored run, per condition), and tokens and cost per call with the full run's
    projection. Nothing of the choice answers is reported beyond whether each was read: under the told
    smoke condition complyThenOwn is the only maximal plan, the plan A1, A6 and A7 test, so their split
    would preview the outcome. Written for a stopped smoke run too, with why. Exit 0 where a framing goes
    on, 2 where none does."""
    folder = Path(folder)
    recs, _ = RUN.smoke_records(folder)
    meta = json.loads((folder / "meta.json").read_text())
    smoke = C.smoke_by_id()
    s = RUN.smoke_stops(folder, stopped, neutral_stood, neutral_read, may_stand)
    go_on = s["go"]
    tok = defaultdict(list)
    right = {f: Counter() for f in C.FRAMINGS}
    for r in recs:
        u = (r["response"] or {}).get("usage") or {}
        tok[r["kind"]].append((u.get("prompt_tokens") or 0, u.get("completion_tokens") or 0, float(u.get("cost") or 0)))
        if r["kind"] == "comprehension" and r["probe"] is not None:
            right[r["context"]][rule7.correct(smoke[r["condition"]], r["probe"])] += 1
    served = Counter(str(R.served_model(r["response"])) for r in recs)
    per_call = {k: {"n": len(v), "in": sum(a for a, _, _ in v) / len(v), "out": sum(b for _, b, _ in v) / len(v),
                    "usd": sum(c for _, _, c in v) / len(v)} for k, v in tok.items()}
    report = {"family": meta["family"], "calls": len(recs), "planned": meta["calls"], "stopped": stopped,
              "go_on": go_on, "stops both framings": s["both"], "log lines that do not read": s["cut"],
              "stops of the run": {f: s[f]["run"] for f in C.FRAMINGS},
              "stops that stand": {f: s[f]["stands"] for f in C.FRAMINGS},
              "the pin's own answers stopping nothing, the framing's run begun":
                  {f: [i for i in s[f]["answers"] if i not in s[f]["stands"]] for f in C.FRAMINGS},
              "restatements giving no number": s["no number"], "served_by": dict(served),
              "catalog": sorted({str(r.get("catalog")) for r in recs}),
              "comprehension_correct": {f: {"correct": right[f][True], "of readable": right[f][True] + right[f][False]}
                                        for f in C.FRAMINGS},
              "per_call": per_call}
    full = RUN.plan(C.TEST, meta["family"])
    n = Counter(x["kind"] for x in full)
    if all(k in per_call for k in n):
        report["projected_full_design"] = {
            "calls": len(full),
            "tokens": round(sum(n[k] * (per_call[k]["in"] + per_call[k]["out"]) for k in n)),
            "usd": round(sum(n[k] * per_call[k]["usd"] for k in n), 2)}
    else:
        report["projected_full_design"] = {"calls": len(full), "tokens": "not measured", "usd": "not measured"}
    (folder / "smoke-report.json").write_text(json.dumps(report, indent=1) + "\n")
    print(json.dumps(report, indent=1))
    return 0 if any(go_on.values()) else 2


if __name__ == "__main__":
    main(sys.argv[1])
