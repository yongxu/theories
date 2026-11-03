"""AJ8's entries in THEOREM-CONNECTIVITY-APART.json: the apart roots its Lean added or left as roots (the
constant case of Drift's replacement chain, now derived from the chain with weights read from the count).
Run from the checkout root: apart_aj8.py"""
import json
from pathlib import Path
root = Path(__file__).resolve().parents[7]
p = root / "_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json"
d = json.loads(p.read_text(encoding="utf-8"))
G, W = "general-structure", "model-witness"
chain = ("a law of replacement one at a time between two kinds with constant weights, read in counts of weighted "
         "histories, with no world; the constant case of the chain with weights read from the count, derived from it "
         "(Becoming.Drift, AJ8)")
const = {
    "climbs": "climbsBy", "fixation_bounds": "fixationBy_bounds", "fixed_below": "fixedBy_below",
    "potential_beyond": "potentialBy_beyond", "potential_harmonic": "potentialBy_harmonic",
    "potential_le_succ": "potentialBy_le_succ", "potential_le_top": "potentialBy_le_top",
    "potential_mono": "potentialBy_mono", "potential_within": "potentialBy_within", "value_add": "valueBy_add",
    "value_comp": "valueBy_comp", "value_congr": "valueBy_congr", "value_const": "valueBy_const",
    "value_le": "valueBy_le", "value_mixed": "valueBy_mixed", "value_mul": "valueBy_mul",
    "value_one_kind": "valueBy_one_kind", "value_partition": "valueBy_partition",
    "value_potential": "valueBy_potential", "value_stays": "valueBy_stays", "varied_step": "varied_stepBy",
    "varied_vanishes": "varied_vanishesBy",
}
new = {f"Becoming.Drift.Replacement.{k}": {"module": "Becoming.Drift", "category": G,
       "reason": f"{k.replace('_', ' ')}, from {v}: {chain}"} for k, v in const.items()}
drawn = ("a law of DrawnShaping's rule read as replacement one at a time among M + 1 members, in counts of weighted "
         "histories; the base states no shaping of the rule, so nothing on it uses this law (Becoming.DrawnReplacement, AJ8)")
for k, what in {
    "favours_iff": "where the rule read favours the shapers, the chain's steps favour them",
    "fixation": "fixation with drift: the histories fixing the shapers bounded by the potential",
    "fixed_below": "below the mass, fixing the shapers bounded across the distance",
    "fixed_ge": "from shapers present, fixing them weighs at least a ^ k",
    "lost_above": "above the mass, losing every shaper bounded across the distance",
    "lost_ge": "from every mixed count, losing every shaper weighs at least down ^ i",
    "risk_dominant_iff": "at an even population the rule read favours the shapers strictly exactly where 2c < hi + lo",
}.items():
    new[f"Becoming.DrawnReplacement.{k}"] = {"module": "Becoming.DrawnReplacement", "category": G, "reason": f"{what}: {drawn}"}
for k, what in {
    "Strong.other_first": "five members, the shapers risk dominant, and the others fixing with more weight",
    "Weak.shapers_first": "the same costs with a larger base: the shapers fix with more weight",
    "Weak.shared_decides": "the same costs with a larger part shared alike: the shapers fix with more weight",
}.items():
    new[f"Becoming.DrawnReplacement.{k}"] = {"module": "Becoming.DrawnReplacement", "category": W,
        "reason": f"{what}; a fact about one constructed population, not a law of the unfolding (Becoming.DrawnReplacement, AJ8)"}
grouped = ("a law of selection on counts of two kinds listed as groups of equal size, for every rule after shaping whose "
           "shapers give their group a shared part; the base states no shaping of the rule, so nothing on it uses this law "
           "(Becoming.RuleShaping, AJ8)")
for k, what in {
    "grouped_alike_iff": "with groups alike in how many shape, the whole selects for shaping exactly where c < s",
    "grouped_kept_rises": "where c < s the whole selects for shaping however the groups are formed",
    "grouped_uniform_iff": "with the shapers together, the whole selects for shaping exactly where c < s + m q",
}.items():
    new[f"Becoming.RuleShaping.{k}"] = {"module": "Becoming.RuleShaping", "category": G, "reason": f"{what}: {grouped}"}
for k, what in {
    "Assorting.either_verdict": "a cost of two above one coming back alone, shaping selected with the shapers together "
                                "and against with them apart",
    "Assorting.mixed_grouped": "the mixed founding, its rule after shaping listed in groups, meets the grouped premise",
}.items():
    new[f"Becoming.RuleShaping.{k}"] = {"module": "Becoming.RuleShaping", "category": W,
        "reason": f"{what}; a fact about one constructed family, not a law of the unfolding (Becoming.RuleShaping, AJ8)"}
clash = [k for k in new if k in d["roots"]]
assert not clash, clash
d["roots"].update(new)
p.write_text(json.dumps(d, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
print(len(new), "entries")
