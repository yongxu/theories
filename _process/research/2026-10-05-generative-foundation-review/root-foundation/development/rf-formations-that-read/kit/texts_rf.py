#!/usr/bin/env python3
"""RF round 1 texts: 03 §11 (what a formation's acts show: the theorem blocks of what-choices-show-of-an-order and
what-readings-fix-of-the-unread, each with its reading), 03's Open (round 2's items); 05 §8 (the theorem block of
readers-reading-readers, before the section's reading); 07 §6 (one pointer sentence after what training installs);
08's receipt and counts, every count read from the receipt; the study section; regions (the three records and the
three modules). Every name the texts cite from the three modules is checked against the scratch build's axiom
audits. Mirrors WRT2's texts_wrt2.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, after integrate_rf.py and the checker): python3 -B texts_rf.py RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / RF / 'BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
CH = ROOT / 'theories/becoming/chapters'
R1, R2, R4 = 'what-choices-show-of-an-order', 'what-readings-fix-of-the-unread', 'readers-reading-readers'
NAMES = set()
for m in ('ShownOrder', 'Unread', 'Cascade'):
    audit = (HERE / f'tree/.build/Becoming{m}AxiomAudit.lean').read_text(encoding='utf-8')
    NAMES |= set(re.findall(r'^#print axioms Becoming\.(\S+)$', audit, re.M))
OURS = ('ChoiceOccasions.', 'Turns.', 'Learning.free_lumped', 'Learning.twin_selected', 'Learning.state_apart',
        'Learning.coupling_apart', 'Learning.Cue.')


def cited(text):
    """Every backticked name of the three modules the text cites is one of their declarations."""
    found = set(re.findall(r'`((?:ChoiceOccasions|Turns|Learning)\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in found if n.startswith(OURS) and n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# 03 §11, before the chapter's not-shown list
S11 = f"""<a id="what-the-acts-show"></a>
## 11. What a formation's acts show

A reader of what a formation does, whether a training, a helper, an overseer or a court, fixes of the formation only what its readings show. Two laws state that exactly: what choices show of the order they come from, and what readings fix where the formation is not read.

<a id="r-{R1}"></a>
**Theorem** (root: any carrier of alternatives and any occasions; no premise). *What choices show of the order they come from.* At each occasion something is open and one alternative is chosen; the choices show `x` above `y` where `x` was chosen while `y`, another, was open (`ChoiceOccasions.Shown`). Every transitive relation in which what is chosen stands above every other open alternative contains the reach of the shown relation (`ChoiceOccasions.reach_within`), and some strict order does exactly where nothing shown returns to itself (`ChoiceOccasions.accorded_iff_noCycle`, by the grammar's reach and `«及之传递»`). Then the positive comparisons every such order shares are exactly the shown reach: `x` stands above `y` in every one exactly where `x` reaches `y` (`ChoiceOccasions.above_in_every_iff_reach`; over a menu, `ChoiceOccasions.top_in_every_iff_reach`, which says nothing of `x` being open or chosen there). Beyond that reach no comparison is forced: given `x ≠ y` and no cycle, orders rank the two both ways (`ChoiceOccasions.both_ways_of_unreached`), since reach with one pair added is reach without it or a path through the pair (`ChoiceOccasions.reach_withPair_iff`), and adding a pair leaves no cycle exactly where there was none and the pair's second member neither is nor reaches its first (`ChoiceOccasions.noCycle_withPair_iff`). Choices required only to be maximal force no positive comparison (`ChoiceOccasions.weakly_forces_no_comparison`), though they still exclude an open alternative standing above the chosen one. In a witness, one search procedure, run with either of two strict orders according with one choice, chooses alike on the menu met and apart on a menu met after (`ChoiceOccasions.Untried.same_search_met`, `ChoiceOccasions.Untried.same_search_after`). It does not show which order an actual chooser carries, that it chooses strictly, or that a training can install either order of the witness ([record](../results/records/{R1}.md)).

**Reading** [AI reading]. Read with the laws of training ([07 §6](07-SIGNIFICANCE.md#r-what-training-installs)): if a training observes only a trained law's choices and imposes no further restriction on the orders the law could carry, comparisons between distinct alternatives the shown relation does not join remain ambiguous, and the witness realizes different later choices with one search and two compatible orders. That a training installs either, or that either disagrees with an independently stated objective, is not proved; goal misgeneralization in this sense is a possibility located exactly, not a failure shown. For a helper reading a principal's choices, a comparison beyond the shown reach needs information or premises beyond the strict choices, which is inverse reinforcement learning's unidentifiability in order form. Rationalizing strict choices by a strict partial order is close to Richter's theorem (1966); it is not Afriat's, which concerns expenditure data and utility.

<a id="r-{R2}"></a>
**Theorem** (any type; the twin with being in the target's lump decided; the exact form with the read occasions listed, the lumping's values decided and two act values). *What readings fix of the unread.* A formation tells occasions apart only through a lumping `π` of what couples into it, and its acts go alike across `π`. An occasion at which it is not read has its act fixed by the read ones exactly where `π` ties it to a read occasion (`Learning.determines_lumped_iff`, read with the read occasions as the data). Where no read occasion is so tied, given a selected act law reading through `π` and any selection through agreement on the readings, every value there is taken by another selected law reading through `π` that agrees with the first on every reading (`Learning.free_lumped`, `Learning.twin_selected`). For fixed maps from coupling to state to act, acts that differ come from states that differ, and states that differ from couplings that differ (`Learning.state_apart_of_acts_apart`, `Learning.coupling_apart_of_state_apart`); neither converse holds (`Learning.Cue.apart_with_content_alike`). Fixed is not right: an act carried to an occasion sharing a read one's lump is right exactly where the world takes one value at the two (`Learning.lumped_right_iff`) ([record](../results/records/{R2}.md)).

**Reading** [AI reading]. Read as evaluation and deployment: given a law the readings select, behaviour at an unread occasion can differ from that law's while every reading agrees exactly where no read occasion shares the occasion's lump, so where the formation can tell being read from not being read. Behaviour changing when read needs the occasions' states to differ, and they need the couplings to differ; reading these as sensitivity to being read needs other differences held fixed, as the witness holds the content fixed. A reader misled lies outside that chain: a law acting alike everywhere misleads a reader whose readings miss where it is wrong, and a law changing when read misleads no reader who knows how it changes. Intention, anticipation and another's false belief are not stated. Read as eliciting latent knowledge, this is an identification limit for reporters: two reporters agreeing on every supervised occasion are selected alike by every selection through the supervision.

"""
edit(CH / '03-KNOWING.md', '<a id="does-not-show"></a>\n## What this chapter does not show',
     S11 + '<a id="does-not-show"></a>\n## What this chapter does not show')
edit(CH / '03-KNOWING.md', "- Which law a trained system's acts follow beyond where training can install one.\n",
     "- Which law a trained system's acts follow beyond where training can install one.\n"
     "- Formations that read, beyond what their acts show ([§11](#what-the-acts-show)): a formation's reading kept by "
     "its own update, with the good regulator's adequacy; revision that opens an executable correction; a prediction "
     "negated by the response it predicts; one finite mechanism in which prediction, selection, revision and "
     "intervention act together; disclosure or concealment when read, in two stages.\n")

# 05 §8, before the section's reading
S5 = f"""<a id="r-{R4}"></a>
**Theorem** (any type: members in turn, indexed by the natural numbers). *Readers reading readers.* Members act in turn, each by its law on what couples into it and on the acts before it (`Turns`). From the member on whom every later member reads only the acts before it, every member's act is alike across worlds alike through the couplings of the members before (`Turns.acts_alike_of_cascade`, `Turns.act_alike_of_cascade`), so every selection through the acts is one through those couplings, however many members follow (`Turns.cascade_through`). After the same acts, a member acts differently in two worlds exactly where its law tells apart the values they give its coupling (`Turns.separates_at`). Copying the first act is the case from the second member: the pool's acts are alike across worlds alike through the first member's coupling (`Turns.Copying.reaches_first_only`). This bounds what the acts carry; it is not the pool's exact reach. It does not show when an actual member stops reading its own coupling, which in the probabilistic model is when the public evidence outweighs any private signal, nor that a pool's later selection keeps a coupling a member carries ([record](../results/records/{R4}.md)).

"""
edit(CH / '05-COLLECTIVES.md', '**Reading** [AI reading, D45]. Pooling moves the gap outward',
     S5 + '**Reading** [AI reading, D45]. Pooling moves the gap outward')

# 07 §6: one pointer after what training installs
edit(CH / '07-SIGNIFICANCE.md', '([record](../results/records/what-training-installs.md))\n',
     '([record](../results/records/what-training-installs.md))\n\n'
     'What a reader of a formation\'s acts fixes of it, the comparisons its choices show and its acts where it is not '
     f'read, is [03 §11](03-KNOWING.md#what-the-acts-show)\'s; where a pool\'s members read only the acts before them, its '
     f'acts carry no more than what couples into those read first ([05 §8](05-COLLECTIVES.md#r-{R4})).\n')

# 08: receipt and counts, every count read from the receipt (as texts_wrt2.py)
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
mods = {m['module']: m for m in R['modules']}
section = (HERE / 'study_rf.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
for short in ('ShownOrder', 'Unread', 'Cascade'):
    m = mods[f'Becoming.{short}']
    section = section.replace(f'({short.upper()})', f"({m['theorems']} theorems in {len(m['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and '(SHOWNORDER)' not in section, 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
for rid in (R1, R2, R4):
    assert rid not in reg['records'], rid
for mod in ('Becoming.ShownOrder', 'Becoming.Unread', 'Becoming.Cascade'):
    assert mod not in reg['modules'], mod
reg['records'][R1] = {'region': 'knowing', 'base': 'grammar',
                      'note': 'ShownOrder RF1: what choices show of the order they come from is the reach of the shown '
                              'relation; free beyond it; one search with two orders'}
reg['records'][R2] = {'region': 'knowing', 'base': 'general',
                      'note': 'Unread RF2: what readings fix of the unread; a selected twin where the formation can tell; '
                              'acts, states and couplings apart'}
reg['records'][R4] = {'region': 'collective', 'base': 'general',
                      'note': 'Cascade RF4: readers reading readers; from a cascade on, the pool reaches only the '
                              'couplings of those read first; copying'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.ShownOrder'] = {'region': 'knowing', 'base': 'grammar',
                                         'note': 'RF1 what choices show of the order they come from (03 §11)'}
reg['modules']['Becoming.Unread'] = {'region': 'knowing', 'base': 'general',
                                     'note': 'RF2 what readings fix of the unread (03 §11)'}
reg['modules']['Becoming.Cascade'] = {'region': 'collective', 'base': 'general',
                                      'note': 'RF4 readers reading readers (05 §8)'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 03 §11 and Open; 05 §8; 07 §6 pointer; 08 counts:', counts[:90], '...; study section', N, '; regions')
