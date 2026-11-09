#!/usr/bin/env python3
"""WB: the crosswalk and dynamics atlas after the readers' fifth round (round5-fable.md, round5-astra.md).

Each replacement is scoped to one line of correspondences.json (its line number at ca34a6772, unchanged since), and
must be found on that line. The shapes: T8 still described as life's way or a verdict under the readings or P1–P4;
a ranking given a compulsory scope ("the continuation condition for scope"); "bears on the ethics only under the
two readings"; the one page's and 05's former sentences quoted as current; an unreturned loss counted only under
the condition; J1–J4 as what choosing needs; occurrence of a loss confused with its appraisal."""
import json
import pathlib
import sys

ROOT = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else '.')
CW = ROOT / 'theories/becoming/results/atlas/entries/correspondences.json'
DY = ROOT / 'theories/becoming/results/atlas/entries/dynamics.json'

T8 = ("T8 is the makers' offer for life, binding no one: to see what each course draws on, from what renewal and at which grain, "
      "what ends, what goes on through that ending, and who bears it; 生生 names life's continuation, and widening is not its measure. "
      "The continuation condition and C belong to conditional comparisons")
RANK = "each ranking names its holder, scope and order, the continuation condition and C one pair examined in 07"
OP = "where it ranks, it names its readings, each an unasserted hypothesis wherever used"
C05 = "A ranking of it names its scope and order; the continuation condition and C are one pair of readings 07 examines."
ETH = "These structural results can inform the makers' offer without a ranking; any ranking drawn from them names its scope and order, neither the condition nor C asserted."
J = "§5's judgment scheme uses a reading of living, L and J1–J4; other constraints, undertakings and held orders can also organize a choice"

EDITS = {
    4423: [("T8 offers 生生 as life's way, the continuation condition for scope and C for order, neither asserted, no warrant from outside sought.", T8 + ", neither asserted, no warrant from outside sought.")],
    12019: [("Where it ranks, the account compares by widening under two readings, the continuation condition for scope and C for order, neither asserted, no warrant from outside sought, and no verdict binding every possible mind.",
             T8 + "; where the account ranks, " + RANK + ", neither asserted, no warrant from outside sought.")],
    13075: [("生生 is the live direction, compared by widening under the continuation condition for scope and C for order, argued and unasserted, no warrant from outside sought, where the source says common sense.",
             "Where the source says common sense, the account offers a way of seeing, binding no one, and ranks only where a result names its readings, neither asserted, no warrant from outside sought."),
            ("\\\"Fix it\\\" has no criterion without C, or another order, and a commitment.", "\\\"Fix it\\\" has no criterion until a ranking names its order and a commitment.")],
    26330: [("T8 says for life names whose way it is, not whose losses count, and it is the way of those whose line runs through life, of whatever substrate.",
             "T8's *for life* names whose way it is, not whose losses count; " + T8[0].lower() + T8[1:] + ".")],
    26986: [("T8's for life is nearest to the first: argued, with the condition for scope and C for order, neither asserted, no warrant from outside sought;",
             "T8's for life is nearest to the first: the makers' offer, binding no one, no warrant from outside sought;")],
    36109: [("the account's direction is 生生 compared by widening, under the condition (scope) and C (order), both unasserted, no warrant from outside sought;",
             "the account offers a way of seeing, binding no one, and 生生 is life's continuation, not a direction measured by widening;")],
    42755: [("and 生生 as T8, argued, ranked by widening under C with scope from the condition, neither asserted, no warrant from outside sought.",
             "and 生生, life's continuation, in T8, the makers' offer, binding no one; a ranking names its readings, neither asserted, no warrant from outside sought."),
            ("'Not selfish selves' has a path under P1-P4, up to what one conditions, and past it needs the step.",
             "'Not selfish selves' has a path under P1-P4, up to what one conditions, and other scopes can count what it does not reach, the step of invariance among them.")],
    46973: [("Comparison is by widening what can form: scope the continuation condition's, order C's, neither asserted, and T8 argued as life's way, with no verdict binding every possible mind.",
             "Comparison by widening what can form is C's, a ranking naming its scope and order, neither asserted; T8 is the makers' offer for life, a way of seeing, binding no one.")],
    59489: [("§4.2's P1; §4.6's P1 for T8's stance", "§4.2's P1; §4.6's actor-line argument")],
    64219: [("only by that clause on T8's stance.", "only by §4.6's separate argument from P1.")],
    1727: [("Calling a loss beyond self-concern bad needs the condition for scope and C, or another order, for order, neither asserted, no warrant from outside sought.",
            "Calling a loss beyond self-concern bad is a ranking: " + RANK + ", neither asserted, no warrant from outside sought.")],
    7062: [("a ranking would take the continuation condition for scope and C for order, neither asserted,", "a ranking would name its holder, scope and order, the continuation condition and C one pair examined in 07, neither asserted,")],
    7137: [("a ranking of such programs would take the continuation condition for scope and C for order, neither asserted,", "a ranking of such programs would name its holder, scope and order, the continuation condition and C one pair examined in 07, neither asserted,")],
    9329: [("ranking takes the continuation condition for scope and C for order, neither asserted,", RANK + ", neither asserted,")],
    9599: [("calling it worse would take the continuation condition for scope and C for order, neither asserted,", "calling it worse would be a ranking naming its scope and order, the continuation condition and C one pair examined in 07, neither asserted,")],
    12372: [("Whether a revision is better needs the condition for scope and C for order.", "Whether a revision is better is a ranking: " + RANK + ".")],
    14310: [("The source's 'should' is a ranking: that rests on C (order) or another named order, the continuation condition fixing whose losses count; neither asserted, no warrant from outside sought.",
             "The source states an undertaking; if expressed as a ranking, its holder, scope and order must be named, neither the condition nor C asserted, no warrant from outside sought.")],
    15557: [("That the ability must be kept is a ranking: C (order) or another order, the continuation condition for scope; neither asserted, no warrant from outside sought.",
             "The source states an undertaking; if expressed as a ranking, its holder, scope and order must be named, neither the condition nor C asserted, no warrant from outside sought.")],
    15900: [("a ranking is under C or another named order, the continuation condition fixing scope, neither asserted,", RANK + ", neither asserted,")],
    17526: [("a ranking is under C or another named order, scope the continuation condition, neither asserted.", RANK + ", neither asserted.")],
    21441: [("(one would rest on C or another named order, the continuation condition fixing scope, neither asserted)", "(one would name its holder, scope and order, neither the condition nor C asserted)")],
    29621: [("a ranking takes the continuation condition for scope and C for order, neither asserted,", RANK + ", neither asserted,")],
    32189: [("any such ranking needs its holder, order and scope stated, C and the continuation condition where the account ranks, neither asserted,", "any such ranking needs its holder, order and scope stated, neither the condition nor C asserted,")],
    32967: [("and where the account ranks, the continuation condition fixes scope and C order, neither asserted,", "and where the account ranks, " + RANK + ", neither asserted,"),
            ("and J1–J4 name ending as a response.", "and §5's judgment scheme, with J1–J4, names ending as a response.")],
    40343: [("That restoring is better rests on C or another named order, scope the continuation condition, neither asserted,", "That restoring is better is a ranking: " + RANK + ", neither asserted,")],
    42003: [("'Must be governed as' is a ranking: C for order, the condition for scope, neither asserted, no warrant from outside sought.",
             "The source states an undertaking; if expressed as a ranking, its holder, scope and order must be named, neither the condition nor C asserted, no warrant from outside sought.")],
    43869: [("Any 'better' rests on C or another named order, the condition for scope, neither asserted.", "Any 'better' is a ranking: " + RANK + ", neither asserted.")],
    46936: [("'worse' would need the two readings and a reading of what is compared.", "'worse' would be a ranking naming its scope and order and a reading of what is compared.")],
    58278: [("a ranking is under C or another named order, the continuation condition fixing only whose losses count, neither asserted,", RANK + ", neither asserted,")],
    77230: [("order would rest on C or another named order, and scope the continuation condition, neither asserted.", "a ranking would name its scope and order, neither the condition nor C asserted.")],
    16877: [("its ethics ranks only under two readings, the continuation condition for scope and C for order, neither asserted, no warrant from outside sought, and offers a way of seeing, with no motivation or compliance shown.",
             "its makers offer a way of seeing, with no motivation or compliance shown; its ranking results name the scopes and orders they use, neither asserted, no warrant from outside sought.")],
    67936: [("It bears on the ethics only under §4.6's P1 to P4, with P2 and P4 not shown; the condition fixes scope and C order, neither asserted.",
             "It bears on §4.6's separate actor-line argument, P1 to P4, with P2 and P4 not shown. " + ETH)],
    4437: [("Where the account ranks, it names two readings, neither asserted, each a hypothesis wherever used.", "The account asserts no should; " + OP + ".")],
    16469: [("“where it ranks courses it names two readings, neither asserted”.", "“" + OP + "”.")],
    29879: [("where it ranks courses it names two readings, neither asserted, each a hypothesis wherever used.", OP + ".")],
    54323: [("Where the account ranks, it names two readings, neither asserted, each a hypothesis wherever used.", "The account asserts no should; " + OP + ".")],
    61600: [("where it ranks courses it names two readings, the continuation condition for scope and C for order, 'neither asserted, each a hypothesis wherever used'.",
             "'" + OP + "', most often the continuation condition for scope and C for order.")],
    63929: [("where it ranks courses it names two readings, 'neither asserted, each a hypothesis wherever used'.", "'" + OP + "'.")],
    69316: [("Where the account ranks, it names two readings, neither asserted: the continuation condition for scope, C for order.", "The account asserts no should; " + OP + ", most often the continuation condition for scope and C for order.")],
    350: [("that is asked under the two readings, the continuation condition for scope and C for order.", C05)],
    17581: [("That is asked under 07's two readings, “the continuation condition for scope and C for order”, neither asserted.", C05)],
    21789: [("That is asked under the two readings of 07, the continuation condition for scope and C for order.", C05)],
    25890: [("That is asked under the two readings of 07, the continuation condition for scope and C for order.", C05)],
    41599: [("asked under the continuation condition for scope and C for order, neither asserted.", C05[0].lower() + C05[1:])],
    46896: [("That is asked under the two readings of 07, the continuation condition for scope and C for order.", C05)],
    50816: [("That is asked under the continuation condition for scope and C for order.", C05)],
    56452: [("That is asked under the two readings of 07.", C05)],
    40252: [("a loss returning to no one lies outside it and needs the condition for scope;", "a loss returning to no one lies outside it, and particular scopes can count it without satisfying the continuation condition, which counts every such loss;")],
    40300: [("a loss that returns to no one, counts only under the continuation condition.", "a loss that returns to no one, is counted under the continuation condition, and particular scopes can count particular ones without satisfying it."),
            ("what that path does not reach still needs the step.", "other scopes can count what that path does not reach, the step of invariance among them.")],
    48788: [("a loss returning to no one counts only under the continuation condition,", "a loss returning to no one is counted by the continuation condition, and particular scopes can count particular ones,")],
    35998: [("Choices take more, following from neither the condition nor C: a reading of living, the lifting L and the commitments J1 to J4.",
             "The judgment of this section takes more, following from neither the condition nor C: a reading of living, the lifting L and the commitments J1–J4; other constraints, undertakings and held orders can also organize a choice.")],
    50427: [("gains here and losses there are mixed and unranked, a measure for mixed parts is open, and J1–J4 are needed for choice.",
             "gains here and losses there are mixed, so C alone does not decide; further judgments name their criteria and who holds them, and §5's practical-judgment scheme uses J1–J4.")],
    62973: [("'Choices take more, following from neither the condition nor C': a reading of living, the lifting L and the commitments J1-J4.",
             "'The judgment of this section takes more, following from neither the condition nor C': a reading of living, the lifting L and the commitments J1–J4; 'other constraints, undertakings and held orders can also organize a choice'.")],
    63109: [("choices take further premises, the lifting L and J1-J4 among them, following from neither the condition nor C.", "results about choices take further premises, each named; " + J + ".")],
    71485: [("They are laws of choice, not ethics: the choosing rests on J1/J2 beside the condition for scope and C for order, none asserted.",
             "They are laws of choice, not ethics: the maximal-choice law uses its stated decision premise, and §5 separately studies practical judgments under its named premises, none asserted.")],
    71491: [("'Choices take more, following from neither the condition nor C'.", "'The judgment of this section takes more, following from neither the condition nor C'.")],
    80409: [("It matters because widening is called Pareto unanimity and practical choice is left to J1 to J4. Live text keeps mixed comparisons unranked and never meets these theorems.",
             "Widening supplies one unanimity comparison; §5 studies practical judgment using additional premises. C alone leaves mixed comparisons undecided; the live text does not work through these impossibility theorems.")],
    29627: [("Choices take further premises, each named;", "Results about choices take further premises, each named;")],
    27893: [("and C never ranks a course closing what another admits above it.", "and a course closing what another admits does not widen it, so C alone requires no ranking of that closing course above the other."),
            ("mixed cases, the hard ones, stay undecided.", "C alone leaves mixed comparisons undecided, and a further stated order can rank them.")],
    67006: [("No law evaluates: whether a drain is a loss is 07's, with the condition for scope and C for order, neither asserted, no warrant from outside sought.",
             "No law evaluates. A drain can end a formation whether or not anyone counts that ending; significance decides whether it counts from a standpoint, and a ranking names its scope and order, neither asserted, no warrant from outside sought.")],
    18503: [("Whether a closing supports or damages what continues is asked under the continuation condition and C, neither asserted.",
             "What a closing keeps or closes for what continues is ranked only under a named scope and order, most often the continuation condition and C, neither asserted.")],
    5556: [("生生不息, read at the whole as 生生 going on with more still able to form, and not as growth, needs no growth of the whole possible.",
            "生生不息, read at the whole as life going on with more still able to form, and not as growth (an AI reading; 生生 itself is the continuation of life, and widening is not its measure), needs no growth of the whole possible."),
           ("or is the direction of 生生:", "or is 生生's measure:")],
}
ETH_LINES = [67869, 68441, 69403, 70101, 70483, 71447]
ETH_OLD = "It bears on the ethics only under the two readings, the condition for scope and C for order, neither asserted."

lines = CW.read_text(encoding='utf-8').split('\n')
done = 0
for n, pairs in EDITS.items():
    line = lines[n - 1]
    for a, b in pairs:
        ka = json.dumps(a, ensure_ascii=False)[1:-1] if '\\"' not in a else a
        kb = json.dumps(b, ensure_ascii=False)[1:-1] if '\\"' not in b else b
        if ka not in line:
            raise SystemExit(f'line {n}: not found: {a[:70]!r}')
        line = line.replace(ka, kb)
        done += 1
    lines[n - 1] = line
for n in ETH_LINES:
    k = json.dumps(ETH_OLD, ensure_ascii=False)[1:-1]
    if k not in lines[n - 1]:
        raise SystemExit(f'line {n}: no ethics sentence')
    lines[n - 1] = lines[n - 1].replace(k, json.dumps(ETH, ensure_ascii=False)[1:-1])
    done += 1
raw = '\n'.join(lines)
json.loads(raw)
CW.write_text(raw, encoding='utf-8')
print('crosswalk', done)

# The dynamics atlas: the measure sentence (07:53's former words) and support passed on.
d = DY.read_text(encoding='utf-8')
for a, b in [("ordering a mixed part needs a measure", "widening alone does not settle a mixed part; a further judgment names its criterion and who holds it, and the criterion need not be a number"),
             ("A chain of support is not yet 生生, which asks widening as well.", "Relating this chain of support to 生生, the continuation of life, requires a further reading; widening is not its defining condition.")]:
    ka, kb = json.dumps(a, ensure_ascii=False)[1:-1], json.dumps(b, ensure_ascii=False)[1:-1]
    print('dynamics', d.count(ka), a[:40])
    d = d.replace(ka, kb)
json.loads(d)
DY.write_text(d, encoding='utf-8')
