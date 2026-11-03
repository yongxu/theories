"""US's entries in THEOREM-CONNECTIVITY-APART.json: the apart roots its Lean added (facts about the two
constructed listings of four members in groups of unequal size, not laws of the unfolding).
Run from the checkout root: apart_us.py"""
import json
from pathlib import Path
root = Path(__file__).resolve().parents[7]
p = root / "_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json"
d = json.loads(p.read_text(encoding="utf-8"))
W = "model-witness"
new = {}
for k, what in {
    "Sized.apart_returns": "with each keeper alone and the others as a pair, the offspring meet the returns, each unit kept "
                           "giving two to every other member of its group at a cost of one to its keeper",
    "Sized.divided_one_verdict": "where what a unit gives its group is divided among the members, the two listings give "
                                 "one verdict for any returns the same in both",
}.items():
    new[f"Becoming.SelectionLevels.{k}"] = {"module": "Becoming.SelectionLevels", "category": W,
        "reason": f"{what}; a fact about two constructed listings, not a law of the unfolding (Becoming.SelectionLevels, US)"}
for k, what in {
    "Sized.apart_grouped": "with each shaper alone and the others as a pair, the rule after shaping meets the grouped "
                           "premise in groups of unequal size",
    "Sized.either_verdict": "the same spreads in groups of unequal size, shaping selected with the shapers as a pair and "
                            "against with each alone",
}.items():
    new[f"Becoming.RuleShaping.{k}"] = {"module": "Becoming.RuleShaping", "category": W,
        "reason": f"{what}; a fact about two constructed listings, not a law of the unfolding (Becoming.RuleShaping, US)"}
clash = [k for k in new if k in d["roots"]]
assert not clash, clash
d["roots"].update(new)
p.write_text(json.dumps(d, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
print(len(new), "entries")
