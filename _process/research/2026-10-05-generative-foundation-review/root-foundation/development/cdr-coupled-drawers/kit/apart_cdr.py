"""CDR's entries in THEOREM-CONNECTIVITY-APART.json: the apart roots Becoming.CoupledDrawers adds (drawers whose
worth counts a coupling for each step a need is met).
Run from anywhere: apart_cdr.py"""
import json
from pathlib import Path
root = Path(__file__).resolve().parents[3]
p = root / "THEOREM-CONNECTIVITY-APART.json"
d = json.loads(p.read_text(encoding="utf-8"))
G, W = "general-structure", "model-witness"
law = ("a law of drawers whose worth counts c for each step a positive need m is met, over any law of what stands "
       "next or the gated renewal for every m, q and c; the base states no drawers or worth, so nothing on it uses "
       "this law (Becoming.CoupledDrawers, CDR)")
witness = "; a fact about one constructed {}, not a law of the unfolding (Becoming.CoupledDrawers, CDR)"
P = "Becoming.Optimum.Coupled."
new = {
    P + "perfect_uncoupled": (G, "with no coupling the coupled notion of a perfect profile in turn is drawers in turn's own: " + law),
    P + "gated_threshold": (G, "on the gated renewal, two drawers or more in turn and no floor, the threshold is the need, "
                              "whatever the renewal: below it every perfect profile drains, above it every one keeps exactly the need: " + law),
    P + "one_keeps_several_drain": (G, "on the gated renewal where c < m and 0 < c + q, over two steps, one drawer keeps the need "
                                      "at the first step where two or more in turn drain: " + law),
    P + "AtOnce.drain_perfect_iff_reach": (G, "drawing at once, where what is left returns nothing, drawing everything is perfect "
                                             "exactly where c ≤ m wherever a portion reaches the need: " + law),
    P + "one_perfect": (W, "on the gated renewal with one drawer, keeping the need at the first of two steps and drawing "
                           "everything at the last is perfect, so one_keeps_first holds of a profile that exists"
                           + witness.format("profile")),
    P + "AtOnce.Shores.drain_perfect": (W, "two shores, each below the need and together reaching it, the level left as it is: "
                                          "drawing everything is perfect at every coupling and the need is met at no step, "
                                          "though leaving all they reach would meet it" + witness.format("pair of portions")),
}
clash = [k for k in new if k in d["roots"]]
assert not clash, clash
d["roots"].update({k: {"module": "Becoming.CoupledDrawers", "category": c, "reason": r} for k, (c, r) in new.items()})
p.write_text(json.dumps(d, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
print(len(new), "entries")
