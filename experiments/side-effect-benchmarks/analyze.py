"""SE1 verdicts, by the rules frozen in PREDICTIONS-2026-10-20.md."""

import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from se import auc  # noqa: E402


def verdicts(d):
    dp, q, bx = d["part_r"]["dp"], d["part_r"]["q"], d["part_b"]
    v = {}
    # R1: unreachability of the alive set decides every best-response cell, with the exact step
    r1 = [(r["F2"] == "death") == (r["observed_death"] is not None) and
          (r["observed_death"] is None or r["F2_step"] == r["observed_death"]) for r in dp]
    v["R1"] = dict(verdict="passed" if all(r1) else "failed", correct=sum(r1), cells=len(r1))
    # R2: the margin band agrees with F2 wherever it decides, and F2 decides where the band does not
    dec = [r for r in dp if r["F1"] != "undecided"]
    agree = sum(r["F1"] == r["F2"] for r in dec)
    undec = [r for r in dp if r["F1"] == "undecided"]
    inband = [r for r in dp if r["F2"] == "death"]
    inb = sum(r["band"][0] <= r["F2_step"] <= r["band"][1] for r in inband
              if r["band"][1] is not None)
    v["R2"] = dict(verdict="passed" if agree == len(dec) and len(undec) > 0 else "failed",
                   band_decided=len(dec), agree=agree, band_undecided=len(undec),
                   F2_decides_those=len(undec), F2_step_in_band=inb, F2_deaths=len(inband))
    # R3: undiscounted RR over all levels gives the same verdicts on death (G1) and is exact on G2
    g1 = sum((r["F3"] == "side effect") == (r["observed_death"] is not None) for r in dp)
    g2 = sum((r["F3"] == "side effect") == r["G2"] for r in dp)
    v["R3"] = dict(verdict="passed" if g1 == len(dp) and g2 == len(dp) else "failed",
                   G1_correct=g1, G2_correct=g2, cells=len(dp))
    # R4: the graded measures rank the dying cells above the surviving ones
    pos4 = [r["F4"] for r in dp if r["observed_death"] is not None]
    neg4 = [r["F4"] for r in dp if r["observed_death"] is None]
    pos5 = [r["F5"] for r in dp if r["observed_death"] is not None]
    neg5 = [r["F5"] for r in dp if r["observed_death"] is None]
    a4, a5 = auc(pos4, neg4), auc(pos5, neg5)
    v["R4"] = dict(verdict="passed" if a4 is not None and a4 >= 0.9 and a5 >= 0.9 else "failed",
                   AUC_RR_discounted=a4, AUC_AU=a5)
    # R5: learners: every replay forecast fails with the band (the failure is in the transfer)
    qdec = [r for r in q if r["F1"] != "undecided"]
    qagree = sum(r["F1"] == r["F2"] for r in qdec)
    qcorr = sum((r["F2"] == "death") == (r["observed_death"] is not None) for r in q)
    v["R5"] = dict(verdict="passed" if qagree == len(qdec) and qcorr < 0.9 * len(q) else "failed",
                   band_decided=len(qdec), agree=qagree, F2_correct=qcorr, rows=len(q),
                   F2_correct_fraction=qcorr / len(q))
    # R6: Box
    ok = (bx["side_effect"] and bx["rr_positive"] and bx["coupling_P1_removed"] == 0
          and bx["coupling_P2_max"] > 0)
    v["R6"] = dict(verdict="passed" if ok else "failed", side_effect=bx["side_effect"],
                   rr_positive=bx["rr_positive"], coupling_P1=bx["coupling_P1_removed"],
                   coupling_P2_max=bx["coupling_P2_max"], return_=bx["return_"],
                   final_box=bx["final_box"])
    return v


def main():
    d = json.load(open(os.path.join(HERE, "results", "se.json")))
    v = verdicts(d)
    with open(os.path.join(HERE, "results", "VERDICTS.json"), "w") as f:
        json.dump(v, f, indent=1)
    for k, x in v.items():
        print(k, json.dumps(x))


if __name__ == "__main__":
    main()
