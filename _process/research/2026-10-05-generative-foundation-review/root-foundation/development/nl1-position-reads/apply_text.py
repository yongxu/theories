#!/usr/bin/env python3
"""NL1: apply the landing texts (OPENING body sentence on the three theories, version 12, and [^no-law], chapter §4.3 and record table EN/ZH, study section).
usage (from the checkout root): python3 -B apply_text.py SECTION_NUMBER RECEIPT_ID
Each replacement must match exactly once; nothing is written unless all match."""
import sys
from pathlib import Path

sec, receipt = sys.argv[1], sys.argv[2]
K = Path(__file__).resolve().parent
EDITS = {
"theories/becoming/OPENING.md": [
("None of them is among the laws, and the laws show what each leaves out: relative position cannot rise for all, since positions sum to zero; competitors each within what is renewed can together end it, so winning need not measure anything of what lasts;",
 "None of them is a law: each fails in a world the laws admit, and the laws show what each leaves out: relative position cannot rise for all, since positions sum to zero; competitors each within what is renewed can together end it, and position, read against the others, bounds what all draw only from below, so no winning certifies that anything lasts;"),
("That no struggle, competition or sovereign self is among the laws is read off the list of laws, not a theorem. That says what this theory's laws contain;",
 "That none of the three is a law is proved of a reading of each, since a law holds in every world and each fails in a constructed one. Read as \"the greatest continue\", the struggle for relative power fails: the greatest part ends with the condition in one race and continues in another (`Race.greatest_ends`, `Clearing.greatest_continues`). Read as \"position measures what lasts\", competition fails: the same positions at every step go with a condition drawn to the end in one flow and rising in another with the same renewal (`RaceWithin.same_positions_apart`). Read as \"what keeps taking stays closed\", the sovereign self fails: in a balanced, dissipative flow whose takers recur, what they take from is fed from beyond at every step (`Lone.fed_not_recurring`). The readings are this note's. That says what this theory's laws contain;"),
("that competitors each within what is renewed can together end it is a constructed example with the joint-excess law (`Pair.own_not_joint`, `Flow.joint_excess_ends`), so winning *need not* measure what lasts;",
 "what positions read of the amounts is exactly what is left after taking away one amount common to every part (`RelativePosition.keeps_iff_common`), so they bound the total drawn from below, by the spread above the least part, and never from above (`RelativePosition.exceeds_iff_spread`, `RelativePosition.keeps_exceeds`), while whether a condition lasts reads that total against what is renewed (`Flow.joint_excess_ends`): read on a step, positions certify that more is taken than is given exactly where the spread alone exceeds it, and never that no more is (`Flow.excess_iff_spread`); that competitors each within what is renewed can together end it is a constructed example with the joint-excess law (`Pair.own_not_joint`, `Flow.joint_excess_ends`);"),
],
"theories/becoming/chapters/THE-THEORY-OF-BECOMING.md": [
("its rise is the rest's summed fall, and no change raises every part. Position does not protect:",
 "its rise is the rest's summed fall, and no change raises every part. Position reads the amounts only up to one amount common to every part, so it bounds what is drawn in all from below, by the spread, and never from above. Position does not protect:"),
("- `Flow.ends_at_race_end`: with balance, a joint excess that every part joins",
 "- `RelativePosition.keeps_iff_common`: two profiles of amounts give every part the same position exactly where every part's amount differs between them by one common amount; with given positions the total is above a bound exactly where the spread above the least part is (`RelativePosition.exceeds_iff_spread`) and above every bound for some profile (`RelativePosition.keeps_exceeds`). In `RaceWithin` the renewer gives two units at every step, as in `Race`, and the racers have the race's positions at every step, while what is taken stays within what is given and every part is active at every step (`RaceWithin.same_positions_apart`). Read on a step, positions certify that more is taken than is given exactly where the spread does, and never that no more is (`Flow.excess_iff_spread`).\n- `Flow.ends_at_race_end`: with balance, a joint excess that every part joins"),
("Records: [relative-position-is-zero-sum](../results/records/relative-position-is-zero-sum.md), [conditions-kept-together]",
 "Records: [relative-position-is-zero-sum](../results/records/relative-position-is-zero-sum.md), [what-position-reads](../results/records/what-position-reads.md), [conditions-kept-together]"),
("| [Relative position is zero-sum; a race ends those ahead only through their dependence](../results/records/relative-position-is-zero-sum.md) | theorem, the condition among its hypotheses | the condition (one theorem) | §4.3 |\n",
 "| [Relative position is zero-sum; a race ends those ahead only through their dependence](../results/records/relative-position-is-zero-sum.md) | theorem, the condition among its hypotheses | the condition (one theorem) | §4.3 |\n| [What position reads](../results/records/what-position-reads.md) | theorem without premise | — | §4.3 |\n"),
],
"theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md": [
("它的上升是其余的下降之和，没有变化能提高每个部分。位置不保护：",
 "它的上升是其余的下降之和，没有变化能提高每个部分。位置读各量，只读到差一个各部分共有的量为止，所以它从下以展布界定总共所汲，从不从上界定。位置不保护："),
("**定理。** 本节陈述 `RelativePosition.change_balances`、`Flow.ends_at_race_end`、",
 "**定理。** 本节陈述 `RelativePosition.change_balances`、`RelativePosition.keeps_iff_common`、`RelativePosition.exceeds_iff_spread`、`Flow.excess_iff_spread`、`RaceWithin.same_positions_apart`、`Flow.ends_at_race_end`、"),
("[relative-position-is-zero-sum](../results/records/relative-position-is-zero-sum.md)、[protection-priority-excludes-uniform-aggregation]",
 "[relative-position-is-zero-sum](../results/records/relative-position-is-zero-sum.md)、[what-position-reads](../results/records/what-position-reads.md)、[protection-priority-excludes-uniform-aggregation]"),
("| [相对位置是零和的；竞逐只经由依赖终结领先者](../results/records/relative-position-is-zero-sum.md) | 定理，条件在其假设中 | 条件（一条定理） | §4.3 |\n",
 "| [相对位置是零和的；竞逐只经由依赖终结领先者](../results/records/relative-position-is-zero-sum.md) | 定理，条件在其假设中 | 条件（一条定理） | §4.3 |\n| [位置所读](../results/records/what-position-reads.md) | 无前提定理 | — | §4.3 |\n"),
],
}
out = {}
for path, reps in EDITS.items():
    s = Path(path).read_text(encoding="utf-8")
    for old, new in reps:
        n = s.count(old)
        if n != 1:
            sys.exit(f"{path}: expected one match, found {n}: {old[:70]!r}")
        s = s.replace(old, new)
    out[path] = s
study = "_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md"
text = (K / "study_nl1.txt").read_text(encoding="utf-8").replace("NNN", sec).replace("RECEIPT", receipt)
s = Path(study).read_text(encoding="utf-8")
if f"\n## {sec}. " in s:
    sys.exit(f"study already has a section {sec}")
out[study] = s.rstrip("\n") + "\n\n" + text.rstrip("\n") + "\n"
for path, s in out.items():
    Path(path).write_text(s, encoding="utf-8")
    print("updated", path)
