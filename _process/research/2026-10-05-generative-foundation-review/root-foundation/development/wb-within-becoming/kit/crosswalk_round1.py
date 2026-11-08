#!/usr/bin/env python3
"""WB: the crosswalk's entries after the readers' first round (review/readers/round1-*.md).

Two kinds of fix. First, what WB's earlier mechanical passes broke: "a ranking holds C or another order" (a ranking
does not hold an order), "any a ranking", "leaves a universal no warrant from outside sought". Second, the old frame
the readers found still said in the entries' own readings: the ethics as "two premises", T8 as the way for life or as
argued under both, "warrant is open", 生生 as "life in the whole" or as asking widening, T8's former refuter.
Replacements are exact strings, counted; a quotation of a home is re-quoted from the home's current words or its
quotation marks dropped. Run from the repository root."""
import json
import pathlib
import re
import sys

P = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else '.') / 'theories/becoming/results/atlas/entries/correspondences.json'
raw = P.read_text(encoding='utf-8')
log = []


def esc(s):
    return json.dumps(s, ensure_ascii=False)[1:-1]


def sub(a, b, expect=None):
    global raw
    ka, kb = esc(a), esc(b)
    n = raw.count(ka)
    if expect is not None and n != expect and not (n == 0 and raw.count(kb)):
        raise SystemExit(f'{n} of {a[:80]!r}, expected {expect}')
    raw = raw.replace(ka, kb)
    log.append((n, a[:70]))


# 1. T8's refuter in its corrected direction.
sub("read a course's draw and what ends with it leaving a draw beyond the renewal their readers depend on no less often than selections that do not",
    "read a course's draw and what ends with it selecting a draw beyond the renewal their readers depend on no less often than selections that do not")

# 2. What the earlier passes broke.
sub("any fuller a ranking holds C or another order for order, and the continuation condition for scope",
    "any fuller ranking is under C or another named order, with the continuation condition for scope")
sub("any a ranking holds C or another order", "any ranking is under C or another named order")
sub("a ranking holds C or another order", "a ranking is under C or another named order")
sub("order holds C or another order", "order is C or another named order")
sub("leaves a universal no warrant from outside sought", "leaves a universal practical warrant unpursued and seeks none from outside")
sub("a ranking of courses is said to need C or a premise in its place", "a ranking of courses is said to need C or a premise in its place")  # dated, kept

# 3. The lines the readers rewrote.
sub("The account refuses this step. Nothing read from the dynamics ranks: all six conditions together rank nothing; order is C or another named order, and scope the continuation condition, neither asserted, no warrant from outside sought; and neither can come from the dynamics alone.",
    "The account refuses this step. Nothing read from the dynamics ranks: all six conditions together rank nothing; a comparison uses a stated order and scope, C and the continuation condition where the account ranks, neither asserted, no warrant from outside sought; and neither can come from the dynamics alone.")
sub("Reading [AI reading, D45]: 'all six together still rank nothing: calling the widening course better holds C or another order, and counting the losses that return to no one needs the continuation condition.'",
    "Reading [AI reading, D45]: the six conditions rank nothing. Ranking widenings higher uses C; the continuation condition counts every unreturned loss, while narrower scopes may count particular ones.")
sub("Mixed comparisons are left unranked by both; practical choice among them needs J1-J4, further premises. 'Neither premise is warranted here, and by §3's last two rows neither can come from the dynamics alone.'",
    "Mixed comparisons are left unranked by both; the practical comparison proposed here uses J1-J4, further premises, and other constraints, undertakings and held orders can also organize a choice. Neither reading is asserted here; no warrant from outside is sought, and neither can come from the dynamics alone.")
sub("T8 is argued, scope from the continuation condition and order from C, both unasserted, no warrant from outside sought.",
    "T8 states the makers' offer for life, binding no one; the continuation condition and C are separate readings used in conditional comparisons, both unasserted, no warrant from outside sought.")
sub("The chain's form is in the account, as support passed on, but a chain of support is not yet 生生, which asks widening as well, and the glossary keeps 生生 from 02's generation, which allows loss. The account reads 生生不息 at the whole, as more still able to form, not novelty, scale or growth. Worthwhile is a comparison with no stated reader; the account would ask for one, and for the continuation condition and C.",
    "The chain's form is in the account, as support passed on, and a chain of support can contribute to life's continuation; widening is not its defining condition. 生生 names the continuation of life, its extent unfinished, and differs from the grammar's renewal without end and 02's generation, which allows loss. 'Worthwhile' requires a named comparison, with its reader; T8 offers a way of seeing, not a ranking.")
sub("A chain of support is not yet 生生, which asks widening as well.",
    "A chain of support can contribute to life's continuation; widening is not its defining condition.")
sub("生生: the continuation of life (生发) [AI reading, D1]. T8 argues it is the way for life, compared by widening, with the continuation condition for scope and C for order.",
    "生生: the continuation of life, life wider than the biological and AI within it, its extent unfinished [AI reading, D1]. T8 states the makers' offer for life, a way of seeing, binding no one.")
sub("The source's charge can be put to the account itself: its ethics is two premises, the continuation condition for scope and C for order, neither asserted, no warrant from outside sought,",
    "The source's charge can be put to the account itself: its ethics ranks only under two readings, the continuation condition for scope and C for order, neither asserted, no warrant from outside sought, and offers a way of seeing,")
sub("“That readers are minds is a reading; none of this says whether a locked loop keeps or closes for 生生, the continuation of life.”",
    "“That readers are minds is a reading; none of this ranks a locked loop: what it keeps, opens or closes, and for whom, is 07's question.”")
sub("Its ethics rests on the continuation condition (scope) and C (order), neither asserted, and keeping open is derived from neither.",
    "Where it ranks, it names the continuation condition (scope) and C (order), neither asserted, and keeping open is derived from neither.")
sub("Hidden selectors: 'for life' says whose way it is, with the condition for scope and C for order, neither asserted, no warrant from outside sought. The one exclusion, the will to finalize, is near T8's forbidden pure closing.",
    "Hidden selectors: 'for life' says whose way it is, with the condition for scope and C for order, neither asserted, no warrant from outside sought. The one exclusion, the will to finalize, was near T8's former refuter, a pure closing; revised T8 (9 November 2026) no longer has that refuter.")
sub("its nearest are C, which needs the condition beside it, and T8's forbidden pure closing.",
    "its nearest are C, which needs the condition beside it, and, until 9 November 2026, T8's refuter, a pure closing.")
sub("\"Good\" is the source's word: any ranking is under C or another named order, and whose losses count the condition, neither asserted, no warrant from outside sought.",
    "\"Good\" is the source's word: any such ranking needs its holder, order and scope stated, C and the continuation condition where the account ranks, neither asserted, no warrant from outside sought.")
sub("Whose losses count is the condition's; neither it nor C is asserted, and their warrant is open.",
    "Whose losses count is the condition's; neither it nor C is asserted, and no warrant from outside is sought.")
sub("any order among courses holds C or another order; neither is asserted, and their warrant is open.",
    "any order among courses is C or another named order; neither is asserted, and no warrant from outside is sought.")
sub("That a balance ranks nothing, and that any ranking is under C or another named order, stated and unasserted.",
    "That a balance ranks nothing; any ranking uses an order whose holder and scope are stated, unasserted.")
sub("The continuation condition fixes scope, C gives order; neither is asserted, and their warrant is open.",
    "The continuation condition fixes scope, C gives order; neither is asserted, and no warrant from outside is sought.")

# 4. The old frame, said in the entries' own words.
for a, b in [
    ("that is asked under the two premises, the continuation condition for scope and C for order.", "that is asked under the two readings, the continuation condition for scope and C for order."),
    ("The separation of 生生 from generation and from renewal, and two premises, the continuation condition for scope and C for order, neither asserted, in place of an assumed worth.",
     "The separation of 生生 from generation and from renewal, and two readings, the continuation condition for scope and C for order, neither asserted, in place of an assumed worth."),
    ("and the two premises any ranking of a substrate would need, named.", "and the two readings any ranking of a substrate would be under, named."),
    ("and the two premises named for any ranking.", "and the two readings named for any ranking."),
    ("The account compares by widening under two premises, the continuation condition for scope and C for order,",
     "Where it ranks, the account compares by widening under two readings, the continuation condition for scope and C for order,"),
    ("Two premises, neither asserted: the continuation condition (scope) fixes whose losses count", "Two readings, neither asserted: the continuation condition (scope) fixes whose losses count"),
    ("That is asked under 07's two premises,", "That is asked under 07's two readings,"),
    ("That is asked under the two premises of 07,", "That is asked under the two readings of 07,"),
    ("The account's two premises are not offered as any such thing.", "The account's two readings are not offered as any such thing."),
    ("the dynamics cannot show the two premises (the continuation condition for scope, C for order, neither asserted) wrong; T8 falls only to a case argued.",
     "the dynamics cannot show the two readings (the continuation condition for scope, C for order, neither asserted) wrong; T8, the makers' offer, names a refuter whose test is not designed."),
    ("the two premises: 'the dynamics cannot show them wrong'.", "the two readings: 'the dynamics cannot show them wrong'."),
    ("The account has two premises, neither asserted, no warrant from outside sought:", "The account names two readings, neither asserted, no warrant from outside sought:"),
    ("No law evaluates; the ethics adds two premises, neither asserted, no warrant from outside sought, each a hypothesis wherever used.",
     "No law evaluates; the account asserts no should, and where it ranks courses it names two readings, neither asserted, each a hypothesis wherever used."),
    ("Neither premise is asserted, no warrant from outside sought.", "Neither reading is asserted, no warrant from outside sought."),
    ("On this reading keeping open is entailed by neither premise;", "On this reading keeping open is entailed by neither reading;"),
    ("Neither premise is asserted.", "Neither reading is asserted."),
    ("keeping open follows from neither premise.", "keeping open follows from neither reading."),
    ("what gains and loses needs a further commitment, neither premise asserted.", "what gains and loses needs a further commitment, neither reading asserted."),
    ("calling that a loss needs both premises,", "ranking it needs both readings,"),
    ("non-entailment results for both premises (", "non-entailment results for both readings ("),
    ("that a reason for C is open and nothing reading no order supplies it;", "that how C-like orders form is open and nothing reading no order supplies C;"),
    ("T8 argues it under the continuation condition for scope and C for order.", "T8 offers it, for life, as a way of seeing, binding no one."),
    ("whose losses count needs the continuation condition.\"", "whose losses count is the continuation condition's.\""),
]:
    sub(a, b)

# 5. The glossary's old gloss of 生生, where an entry quotes it: re-quoted from the glossary's current words.
GLOSS = json.loads((P.parents[4] / 'GLOSSARY.md').read_text(encoding='utf-8').__repr__()) if False else None
for a, b in [
    ("'generation is a pattern going on through carrying renewal, and 生生 life in the whole, not novelty or scale';",
     "generation is a pattern going on through carrying renewal, and 生生 is the continuation of life, not novelty or scale;"),
    ("Generation is a pattern going on through carrying renewal, and 生生 life in the whole, not novelty or scale;",
     "Generation is a pattern going on through carrying renewal, and 生生 is the continuation of life, not novelty or scale;"),
    ("Generation is a pattern going on through carrying renewal, and 生生 life in the whole, “not novelty or scale”;",
     "Generation is a pattern going on through carrying renewal, and 生生 is the continuation of life, not novelty or scale;"),
]:
    sub(a, b)

# 6. The label of the one page's ethics part.
raw = raw.replace('"part": "The ethics adds two premises"', '"part": "The ethics: two readings named"')

json.loads(raw)
P.write_text(raw, encoding='utf-8')
for n, a in log:
    print(n, a)
