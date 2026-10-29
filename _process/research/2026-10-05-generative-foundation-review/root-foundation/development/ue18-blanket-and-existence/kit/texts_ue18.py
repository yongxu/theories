#!/usr/bin/env python3
"""UE18 texts: the homes of the two new records, the-markov-blanket-as-a-coupling-structure at 03 §1 after the reading
on the free-energy principle's agent, with a labelled reading, and what-the-existence-claim-forbids at 03 §6 after
UE17's free energy (before the split that makes sense); a bullet in 08 §8's known results beyond the table, and 08's
receipt and counts read from the receipt; the study section; the UE plan's owners and the plan for the principle
(FEP-INTEGRATION); the records' and the module's regions. Every Blanket name the texts cite is checked against the
scratch build's axiom audit. Mirrors UE16's texts_ue16.py; every edit is asserted to apply exactly once. Runs after UE16
and UE17 have landed.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue18.py RECEIPT N"""
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
RIDA = 'the-markov-blanket-as-a-coupling-structure'
RIDB = 'what-the-existence-claim-forbids'
KIT = f'../../../{RF}/development/ue18-blanket-and-existence/NOTE.md'
AUDIT = HERE.parent / 'tree/.build/BecomingBlanketAxiomAudit.lean'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))


def cited(text):
    """Every backticked name of the module the text cites is a declaration of it."""
    found = set(re.findall(r'`(Blanket\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in found if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


C03 = CH / '03-KNOWING.md'
# 03 §1: the blanket, after the reading on the principle's agent
A_BEFORE = '<a id="observation"></a>'
edit(C03, A_BEFORE, f"""<a id="r-{RIDA}"></a>
**Theorem** (any type; a determined law of four parts; for the witness's join, the World). *The Markov blanket as a coupling structure.* Take four parts of one law, told apart only by which part's next state reads which: the internal and active parts read the internal, sensory and active parts, the sensory and external parts read the sensory, active and external parts, as the free-energy principle's partition has it (Friston 2013). Then the agent is driven by its sensory course: from one internal and one active state, courses alike on the sensory part have one internal and one active course (`Blanket.Blanketed.agent_through_sensory`), and the world is driven by the active course (`Blanket.Blanketed.world_through_active`); so a determined policy is a selection through the sensory course, with no action listed among what couples in, and each side's course is fixed by its start and the blanket's (`Blanket.Blanketed.internal_through_blanket`), the deterministic case of the time-unrolled blanket (Virgo, Rosas and Biehl 2022). Where the sensory part reads the world only through a map, courses alike through it are alike for the agent (`Blanket.Blanketed.through_reading`, the lumping of [§6](#r-generalization-through-lumping)). With any model and policy, an agent reading its supply only by threshold, no action changing the supply, has every reading of its internal course alike up to step four from a supply of three and from every supply of four or more, a free energy of its belief at any step before four among them, the sensory parts differing first at step four, when the break registers (`Blanket.ThresholdDrain.any_model`, `Blanket.ThresholdDrain.sensory_apart_at_four`); the witness's blanket is the World's coupling by threshold (`Blanket.ThresholdDrain.blanket_iff_through`), so this is the invisible half of [§10](#break-seen-coming) and the [runaway](02-MAP.md#r-runaway-distance-uncoupled) on a blanketed agent. Near-definitional; a World formation in general as the agent of a blanketed law is not shown ([record](../results/records/{RIDA}.md)).

**Reading** [AI reading, D45]. The principle's blanket names the couplings: a formation's support and observed levels are its sensory states, what it keeps of them its internal states, and the blanket condition is that the selections through its couplings together separate exactly what they tell apart, any one of them, the internal course among them, at most that (`Blanket.Deaf.lumps`). What the theory adds is which couplings carry what: a supply coupled in by threshold only carries no distance to the break, so self-evidencing does not see its break coming, and what the principle calls acting ahead of actuality can come, for such a supply, only from priors, a coupling by level or another formation, never from the blanket's course ([study]({KIT})).

""" + A_BEFORE)

# 03 §6: what the existence claim forbids, after UE17's free energy and its reading
B_BEFORE = '<a id="r-the-split-that-makes-sense"></a>'
edit(C03, B_BEFORE, f"""<a id="r-{RIDB}"></a>
**Theorem** (any type; natural weightings of listed outcomes; near-definitional). *What the existence claim forbids.* The free-energy principle holds that whatever persists will appear to minimize free energy (Friston 2013, 2019), its model the density of the persisting thing. Read so off a course of a determined law, that model is conditioning on the course itself: the weighting placing all weight on an outcome is the counting weighting restricted to the record of being it (`Blanket.point_is_restrict`). Under it a listed outcome weighs something, its share is the whole and no event's is greater, so it is of least surprisal, and every event not holding at it weighs nothing (`Blanket.least_surprisal`, `Blanket.point_forbids_rest`); the occupation weighting read off a run gives every visited, listed state a positive share, ending included (`Blanket.read_off_admits`), the ended witness of [§1](#r-{RIDA}) resting at a fixed point of its law (`Blanket.ThresholdDrain.short_rests`), read as a steady state with a trivial blanket. A listed outcome has the share nothing exactly where its weight is nothing (`Blanket.forbids_iff`): forbidding a course needs a weighting fixed apart from it, such as the density of another law, or a law of the courses themselves, holding whatever weighting is put on them. Known and conceded: the principle's proponents class it with principles of stationary action, not falsifiable strictly speaking (Ramstead and others 2023) ([record](../results/records/{RIDB}.md)).

""" + B_BEFORE)

C08 = CH / '08-METHOD.md'
ASSESS = "\n\n**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control)."
edit(C08, ASSESS, f"""
- The Markov blanket as a coupling structure ([03 §1](03-KNOWING.md#r-{RIDA})) is the deterministic case of the time-unrolled blanket (Virgo, Rosas and Biehl 2022), Pearl's blanket (1988) of the internal course in the law's unrolled graph; it adds the agent form, a policy a selection through its sensory course, and, on a blanketed agent, T6's invisible half for every model and policy, joined to the World's coupling for its witness. What the existence claim forbids ([03 §6](03-KNOWING.md#r-{RIDB})) states in counting form what the principle's proponents concede, that the claim is not falsifiable alone (Ramstead and others 2023). Each law is near-definitional, a composition or a witness; no sentence of the principle's literature is forbidden.""" + ASSESS)

# 08: receipt and counts, every count read from the receipt
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
s = C08.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
C08.write_text(s, encoding='utf-8')

# the study section
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Blanket')
section = (HERE / 'study_ue18.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(COUNTS)', f"({mod['theorems']} theorems in {len(mod['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and 'PARAGRAPH' not in section, 'a placeholder left'
assert not re.search(r'RECHECK(?!-UE18)', section), 'the re-check placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan and the plan for the principle
UE = ROOT / RF / 'development/ue-unified-explanation'
REC = '../../../../../../theories/becoming/results/records/'
plan = (UE / 'PLAN.md').read_text(encoding='utf-8')
owners = re.search(r'UE16(?:, UE17| and UE17)?, and holds UE8\.', plan)
assert owners, 'the owners line'
new_owners = owners.group(0).replace(' and UE17, and', ', UE17 and UE18, and').replace('UE16, and', 'UE16 and UE18, and')
assert new_owners != owners.group(0)
(UE / 'PLAN.md').write_text(plan.replace(owners.group(0), new_owners), encoding='utf-8')
edit(UE / 'FEP-INTEGRATION.md', "3. **UE18. The Markov blanket, and the existence claim.**",
     f"3. **UE18. The Markov blanket, and the existence claim** (landed as `Becoming.Blanket` with two records, "
     f"[the blanket]({REC}{RIDA}.md) at 03 §1 and [the existence claim]({REC}{RIDB}.md) at 03 §6, study section {N}).")
edit(UE / 'FEP-INTEGRATION.md', "the Markov blanket, the existence claim.",
     f"the Markov blanket and the existence claim (until UE18, [the blanket]({REC}{RIDA}.md) and [the existence "
     f"claim]({REC}{RIDB}.md)).")

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RIDA not in reg['records'] and RIDB not in reg['records'] and 'Becoming.Blanket' not in reg['modules']
reg['records'][RIDA] = {'region': 'knowing', 'base': 'general',
                        'note': 'Blanket UE18: the agent driven by its sensory course on a blanketed law, through what the '
                                'sensory part reads (lumping); with any model and policy a threshold-read supply unseen '
                                'before the break, joined to the World for the witness'}
reg['records'][RIDB] = {'region': 'knowing', 'base': 'general',
                        'note': 'Blanket UE18: the point weighting is conditioning on the outcome; every course of least '
                                'surprisal under it; a listed outcome forbidden exactly where its weight is nothing'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.Blanket'] = {'region': 'knowing', 'base': 'general',
                                      'note': 'UE18 the Markov blanket and the existence claim (03 §1, §6)'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 03 §1 theorem and reading, §6 theorem; 08 bullet and counts:', counts[:90], '...; study section', N,
      '; UE plan and FEP-INTEGRATION; regions')
