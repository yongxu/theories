#!/usr/bin/env python3
"""UE11 texts: the home section of the new record (07 §2: a theorem paragraph and a labelled reading after what a
course keeps reachable); UE10's reading's last clause brought to the landing; 01's Open item on self-changing conditions
narrowed; a pointer in 02 after rules that change themselves, outside its record-bound paragraph; a bullet in 08 §8's
known results beyond the table and 08's receipt and counts read from the receipt; the study section; the UE plan's
item 7, its gap on self-changing conditions and its owners; the record's and the module's regions. Mirrors UE10's
texts_ue10.py; every edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue11.py RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / RF / 'BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
RID = 'where-the-possible-grows'
KIT = f'../../../{RF}/development/ue11-where-the-possible-grows/NOTE.md'
KIT10 = f'../../../{RF}/development/ue10-what-can-be-reached/NOTE.md'
D5 = (f'../../../{RF}/DELEGATED-CHOICES.md'
      '#d5-接续与生生不息的层次--succession-and-the-level-of-生生不息')


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 07 §2: UE10's reading, its last clause
edit(CH / '07-SIGNIFICANCE.md',
     "growth of the possible itself would need a process that changes, which no law here states "
     f"([study]({KIT10})).",
     "a process whose rules change, a tower of rules with no top included, adds nothing to its whole possible either, "
     "and the possible relative to what is held grows only where what is held changes "
     f"([below](#r-{RID}); [study]({KIT10})).")

# 07 §2: the theorem and the reading, after what a course keeps reachable
edit(CH / '07-SIGNIFICANCE.md', """
<a id="r-comparison-content-under-regrouping"></a>""", f"""
<a id="r-{RID}"></a>
**Theorem** (root; any process, and witnesses). *Where the possible grows.* For any process, what is possible under it from a configuration it reaches is possible from the first, so where something possible from `t` is not possible from `s`, a step from `s` to `t` is not one of its moves (`Reaching.not_reach_of_grows`, `Reaching.not_step_of_grows`). Along a course, where every step of a stretch is one of its moves, what is possible under it at the stretch's end is possible at its start (`Run.possible_of_stretch`), so where the possible under it keeps widening, in this section's form read from the course's first step, from every step some bounded stretch is not made of its moves throughout (`Run.departs_of_keepsWidening`, `Run.not_keepsWidening_of_within`); along a course that comes back to one configuration at arbitrarily late steps, nothing read off its configurations keeps widening (`Run.not_keepsWidening_of_returns`). What is held is read here by a relation on configurations, which a move holding it keeps between its two configurations, and the held possible is what is possible under the moves of the process holding it (`Reaching.heldMoves`, `Reaching.PossibleHeld`), included in the whole possible (`Reaching.PossibleHeld.possible`, `Reach.of_heldMoves`); the steps within a family and the steps after which a configuration can still be had are instances (`Onward.within_eq_heldMoves`, `Branching.keeping_eq_heldMoves`). On the root, a move holding a relation is a continuation under it, what the moves holding it reach is the start or the start's line under it, and the held possible is what the start or that line admits (`«续»`, `«相续»`; `Reaching.steps_heldMoves_iff`, `Reaching.reach_heldMoves_iff`, `Reaching.possibleHeld_iff_line`); holding a weaker relation is coarsening read on processes (`«粗化»`, `Reach.heldMoves_mono`). For a class, what the moves holding it reach is alike the start under it, and holding it move by move is holding it as it is at the start, both ways (`Reach.same_of_heldMoves`, `Reach.heldMoves_iff_sameAsStart`, `Trace.heldMoves_sameAsStart`, `Trace.sameAsStart_heldMoves`); not so for a relation that is not transitive, nor for one that is not symmetric (`AdjacentHeld.differs`, `OrderHeld.differs`). Along a course the held possible grows across a step only where the step changes what is held (`Run.changes_of_heldGrows`), and from the step at which what is held stays for good nothing is added to it (`Run.possibleHeld_of_stays`). It keeps widening only where what is held changes without end: from every step some bounded stretch does not hold it throughout (`Run.changes_of_heldKeepsWidening`, `Run.not_heldKeepsWidening_of_stays`); where whether each step holds it is decided, a step changing it lies within every stretch across which the held possible grows, and so, where the held possible keeps widening, one recurs from every step on (`Run.held_change_located`, `Run.held_change_recurs_of_keepsWidening`). Where it keeps widening, read on the course's moments, from no moment is the course's line under what is held unending, and where holding is also decided a line under it begins after every moment (`«不穷»`, `«生»`; `Run.not_unending_of_heldKeepsWidening`, `Run.begins_of_heldKeepsWidening`). It keeps widening only where no list holds the whole possible from the course's start (`Run.not_heldKeepsWidening_of_listed`), and endless change of what is held with an unlisted whole possible does not suffice (`Oscillating.converse_fails`); a course that only returns, along which the whole possible exceeds what is admitted at every step and the held possible widens across a step, does not keep it widening (`Oscillating.returns`, `Oscillating.comes_back`, `Oscillating.exceeds_now`, `Oscillating.held_widens`, `Oscillating.returning_has_both`). For a state going on under a rule that itself goes on, a step keeps the rule exactly where the change of rule, `G`, leaves it as it is (`adaptive_keeps_rule_iff`), so the possible with the rule held keeps widening only where the rule changes without end, located where rules are decided (`Run.adaptive_rule_changes_of_keepsWidening`, `Run.adaptive_rule_change_recurs_of_keepsWidening`), while nothing is added to the whole possible (`Run.possible_of_next` at `adaptive F G`). On the root, for every carrier and relation, on a sequence of relations growing coarser where every step is alike under some member, whatever the relation reaches lies on a line under some member (`«及在渐粗列之相续»`); so where every move of a process holds some member of such a sequence, every possibility is possible with some member held (`Reaching.reach_held_of_sequence`, `Reaching.possible_iff_held_of_sequence`). A tower of rules with no top, a state and a sequence of rules in which the move `0` changes the state as the rule at height `0` allows and the move `k + 1` changes the rule at height `k` as the rule at height `k + 1` allows, every rule changing only as the one above it allows and none the last, the scheme fixed (`RuleTower.process`), is such a process, the move `a` keeping the rules from height `a` up (`RuleTower.step_sameFrom`, `RuleTower.SameFrom`, `RuleTower.SameFrom.mono`, `RuleTower.sameFrom_class`): each of its possibilities is had by changing only the state and the rules below some height (`RuleTower.possible_iff_held`), while the same scheme changing every rule at once has a possibility needing the whole tower (`RuleTower.synchronous`, `Synchronous.tower_law_fails`). Along a course of the tower, where the possible with the rules from height `n` up held keeps widening, moves above `n`, the only moves that can change a rule from height `n` up, recur from every step on, located with no decision of the rules (`Run.ruleTower_move_above_recurs_of_keepsWidening`), and a trace ending where it holds started where it held or passes a move above `n` after which it holds (`RuleTower.reflected`, `RuleTower.held_origin`, from [every origin passes the gate](01-ROOT.md#r-every-origin-passes-the-gate)); a top, the rules from some height up, fixed for good stops the growth relative to it, and nothing is added to the whole possible (`Run.possible_of_next` at `RuleTower.process`). On witnesses the held possible keeps widening while every formation is possible from every configuration of the course: relative to a rule raised at every step (`RaisedRule.held_keeps_widening`, `RaisedRule.whole_every`), and relative to the rules from every height of a tower whose moves above `0` copy a rule down, each rule changing once as the change climbs (`CopyDown.held_keeps_widening`, `CopyDown.whole_every`, `CopyDown.changes_iff`); read on the course's moments under what is held, every moment of both ceases (`«息»`; `RaisedRule.ceases`, `CopyDown.ceases`). With the rule raised at every other step, the held possible keeps widening, every formation stays possible, and renewal without end holds at every even moment, so moment `0` does not cease (`«生生»`, `«生生不息»`; `RaisedEveryOther.both`). Each law is near-definitional or a witness ([record](../results/records/{RID}.md)).

**Reading** [AI reading, D45]. If the one unfolding were one stated process, nothing would be added to its whole possible along its course: what a course adds is the actual. The possible within a horizon moves with the actual, and the possible relative to what is held grows only where what is held changes; keeping it growing needs what is held to change without end. A tower of rules with no top adds nothing to its whole possible either, each of its possibilities being had with a top, the rules from some height up, held, and a top fixed for good stops the growth relative to it. So 生生不息, read at the whole as 生生 going on with more still able to form, and not as growth ([D5]({D5})), needs no growth of the whole possible. More still able to form, which D5 reads as not a return, is not the whole possible exceeding the actual, nor the held possible widening across a step, since a course that only returns has both; it can be the held possible keeping widening, as on the witnesses, which no course coming back to one configuration without end has. Renewal without end and growth relative to what is held are different relations: on the first two witnesses every moment ceases under what is held, and with the rule raised at every other step both hold with every formation possible throughout ([study]({KIT})).

<a id="r-comparison-content-under-regrouping"></a>""")

# 01: the Open item on self-changing conditions, narrowed
edit(CH / '01-ROOT.md',
     "Not yet stated: a change of the law of change with no fixed law above it, or a space of rules not given with the "
     "carrier;",
     "A tower of rules with no top, each rule changing only as the one above it allows, is stated on processes as one "
     f"process with a fixed scheme ([07 §2](07-SIGNIFICANCE.md#r-{RID})): every possibility of it is had with the rules "
     "from some "
     "height up held, nothing is added to its whole possible along a course, and the possible with the rules from any "
     "height up held keeps widening only where those rules change without end, which on a witness they do, each rule "
     "changing once, while every formation stays possible. Not yet stated: a change of the law of change with no fixed "
     "scheme, or a space of rules not given with the carrier;")

# 02: a pointer after rules that change themselves, outside the record-bound paragraph
edit(CH / '02-MAP.md',
     "not restated in the grammar ([record](../results/records/rules-that-change-themselves-in-the-grammar.md)).\n\n"
     "<a id=\"t7\"></a>",
     "not restated in the grammar ([record](../results/records/rules-that-change-themselves-in-the-grammar.md)).\n\n"
     "Read on what each configuration admits, a rule changing its own rule adds nothing to its whole possible, and the "
     "possible with the rule held grows only where the rule changes; a tower of rules with no top is one process too "
     f"([07 §2](07-SIGNIFICANCE.md#r-{RID})).\n\n"
     "<a id=\"t7\"></a>")

# 08 §8: known results beyond the table, after UE10's bullet
edit(CH / '08-METHOD.md', """ The lexical order is the two-tier order read on realized claims, then reachable ranges, near Sen's achievement and freedom (1985). Each law is near-definitional or a witness.

**Assessment**""", f""" The lexical order is the two-tier order read on realized claims, then reachable ranges, near Sen's achievement and freedom (1985). Each law is near-definitional or a witness.
- Where the possible grows ([07 §2](07-SIGNIFICANCE.md#r-{RID})) restates known accounts as laws on any process. That the possible with what is held grows only across a change of what is held is open-ended novelty's innovation, novelty that changes the model and with it the possibilities of variation (Banzhaf and others 2016), which holds there by definition; continuing inheritable change at the highest levels, as McMullin proposed at the York workshop (Taylor and others 2016), is the informal neighbour of a top fixed for good stopping the growth relative to it, and innovation against fixed-rule systems, found with state-dependent rules (Adams, Zenil, Davies and Walker 2017), is a neighbour of the rule changing its own rule. The tower law's finite support is, in substance, the finite degree of introspection that lets an infinite tower of reflective processors be implemented (des Rivières and Smith 1984; Wand and Friedman 1988), restated with its premise shown needed; Bateson's levels of learning (1972) are the tower's scheme with no law of possibility. The adjacent possible that cannot be prestated (Longo, Montévil and Kauffman 2012) is outside. Each law is near-definitional or a witness.

**Assessment**""")

# 08: receipt and counts, every count read from the receipt (as texts_ue10.py)
R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
layers = {}
for module in R['modules']:
    count = layers.setdefault(module['layer'], [0, 0])
    count[0] += 1
    count[1] += module['theorems']
assert set(layers) <= {'foundation', 'core', 'instance', 'application'}, set(layers)
modules = sum(v[0] for v in layers.values())
theorems = sum(v[1] for v in layers.values())
assert modules == len(R['core_closure']), (modules, len(R['core_closure']))
ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
declarations = sum(len(m['declarations']) for m in R['modules'])
injeq = sum(1 for name, axioms in R['generated_axiom_dependencies'].items()
            if name.endswith('.injEq') and axioms == ['propext'])
assert injeq == len(R['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
superseded = len(R['superseded_modules'])
link = f'../../../{PKG}/becoming-checks/{RECEIPT}/verification.json'
counts = (f"At core receipt [`{RECEIPT}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
          f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application ring) "
          f"and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
          f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
          f"{superseded} superseded modules were kept out of the run.")
path = CH / '08-METHOD.md'
s = path.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
path.write_text(s, encoding='utf-8')

# the study section
section = (HERE / 'study_ue11.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
assert '{' not in section and 'TODO' not in section, 'a placeholder left in the study text'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan: item 7, the gap on self-changing conditions and the owners brought to the landing
PLAN = ROOT / RF / 'development/ue-unified-explanation/PLAN.md'
edit(PLAN,
     "UE11, where the possible grows, claimed on 27 October, takes up how the possible grows: relative to a held part, "
     "across steps changing it, and for a tower of rules with no top level "
     "([design](../ue11-where-the-possible-grows/DESIGN.md)).",
     "UE11, where the possible grows, landed on 27 October: along a course of a stated process nothing is added to the "
     "whole possible, a rule changing its own rule and a tower of rules with no top included; the possible relative to "
     "what is held grows only across steps changing what is held, and keeps widening only where what is held changes "
     "without end, which does not suffice and which a course that only returns never has; every possibility of the "
     "tower is had with the rules from some height up held; and growth relative to what is held and renewal without "
     "end are different relations, both holding on a witness with every formation possible "
     f"([record](../../../../../../theories/becoming/results/records/{RID}.md)).")
edit(PLAN,
     "This is the deepest gap: a full explanation of reality has to state conditions that change themselves, and the "
     "present.",
     "This is the deepest gap: a full explanation of reality has to state conditions that change themselves, and the "
     "present. UE11 states a tower of rules with no top, each rule changing only as the one above it allows, as one "
     "process with a fixed scheme, and reads it on the root; a change with no fixed scheme, a space of rules not given "
     "with the carrier, and the present remain.")
edit(PLAN, "UE0, UE1, UE2, UE1b, UE4, UE5, UE7, UE9 and UE10, and holds UE8 and UE11.",
     "UE0, UE1, UE2, UE1b, UE4, UE5, UE7, UE9, UE10 and UE11, and holds UE8.")

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records']
assert 'Becoming.HeldPossible' not in reg['modules']
reg['records'][RID] = {'region': 'significance', 'base': 'frame',
                       'note': 'HeldPossible UE11: where the possible grows (relative to what is held, across steps '
                               'changing it; a rule changing its own rule; a tower of rules with no top, every '
                               'possibility had below some height, on the root as reach over a sequence growing '
                               'coarser; witnesses with the whole possible fixed)'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.HeldPossible'] = {'region': 'significance', 'base': 'frame',
                                           'note': 'UE11 where the possible grows'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 07 §2 paragraph and reading, UE10 reading brought to the landing, 01 Open narrowed, 02 pointer; 08 bullet '
      'and counts:', counts[:90], '...; study section', N, '; UE plan; regions')
