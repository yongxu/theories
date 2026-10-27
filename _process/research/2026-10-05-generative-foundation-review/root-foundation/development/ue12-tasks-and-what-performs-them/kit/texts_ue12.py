#!/usr/bin/env python3
"""UE12 texts: the home section of the new record (07 §2: a theorem paragraph and a labelled reading after where the
possible grows); a bullet in 08 §8's known results beyond the table and 08's receipt and counts read from the receipt;
the study section; the UE plan's item 5 and its owners; the record's and the module's regions. Mirrors UE11's
texts_ue11.py; every edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue12.py RECEIPT N"""
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
RID = 'tasks-and-what-performs-them'
RID11 = 'where-the-possible-grows'
KIT = f'../../../{RF}/development/ue12-tasks-and-what-performs-them/NOTE.md'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 07 §2: the theorem and the reading, after where the possible grows
edit(CH / '07-SIGNIFICANCE.md', """
<a id="r-comparison-content-under-regrouping"></a>""", f"""
<a id="r-{RID}"></a>
**Theorem** (any process, and witnesses). *Tasks and what performs them.* Constructor theory's task, what performs it and the possible are read on any process divided by two readings, the performing part and the substrate, with a task a relation on the substrate (`Tasks.Input`). A region of the performing part's states performs a task where each of its states is had with every legitimate input and, from each configuration with the part in the region and the substrate an input, the process reaches an output with the part in the region again (`Tasks.Presented`, `Tasks.Delivers`, `Tasks.Performs`, `Tasks.Possible`), which is having an output possible with the part in the region (`Tasks.delivers_iff_possible`); a task is possible from natural configurations where, besides, the performer can be made from one of them (`Tasks.PossibleFrom`), which a possible task need not be (`Unmade.possible_not_possibleFrom`). Where the successor is fixed at what the presented configuration reaches, the delivered configuration lies on every course from the presented one (`Tasks.Delivers.invariably`), with no halting: on UE10's climbing process every task each of whose inputs has an output at or ahead of it is performed invariably (`ClimbTask.invariably`). What is delivered with the part held at every move is delivered (`Tasks.Delivers.of_heldMoves`), and not conversely: on a catalytic cycle the enzyme performs only by leaving its free form and returning to it, and the task's transpose, the grammar's `«逆»`, is performed by no region of any reading of a performing part (`Catalysis.not_held`, `Catalysis.not_held_unchanged`, `Catalysis.transpose_not_possible`). One region delivering both tasks of a regular pair delivers the first then the second, the grammar's `«而»` (`Tasks.Delivers.serial`, `Tasks.Performs.serial`), and with no performing part the pair must still be regular (`Unregular.composite_not_possible`); two regions together deliver in series and in parallel where each delivers by the moves holding what the other uses (`Tasks.Delivers.serial_holding`, `Tasks.Delivers.parallel_holding`), a premise that is sufficient and not needed (`CatalysedSeries.performs_pair`) and that interleaving two processes gives, possibility read in each (`Tasks.Possible.serial_interleaveOn`, `Tasks.Possible.parallel_interleave`, `Tasks.Possible.parallel_within`). Within one interleaving on one substrate, and on a process whose deliveries change what their tasks do not list, a regular pair of possible tasks can have a composite performed by no region of any reading (`ResettingInterleaved.composition_fails_within`, `Resetting.composition_fails`); with what the deliveries change listed, the pair is not regular (`Resetting.listed_not_regular`). On two substrates passing a unit, raising either and lowering either are impossible for readings of the other substrate, and each transpose in parallel with the other raising is possible (`Conserved.additive_pattern`), while with an invariant of the process read as the performer each single task is performed (`Conserved.performs_with_one`). On a tower of performers with no top, what is reached is reached with the performers from some level up held (`Tasks.tower_reach_held`), so every delivery, and every making of a performer from a natural configuration, is had with them held (`Tasks.tower_delivers_iff_held`, `Tasks.tower_made_held`); on the tower changing every level at once no delivery is (`FlipTower.not_held`). What can be done with the part held grows only across steps changing the part (`Tasks.changes_of_partHeldGrows`). A delivery adds nothing to the whole possible (`Tasks.Delivers.adds_nothing`), and on the catalytic cycle narrows it strictly (`Catalysis.narrows`), while widening what can be reached follows deliveries in neither direction: on what a configuration reaches, UE10's lagged order is same-offset widening (`Reaching.widensOrLater_iff_of_reach`), which ranks a delivered output above its input on one process (`RiseTask.widens`) and below it on another (`FallTask.widens_back`), and on the catalytic cycle, where no configuration starts a course, it ranks nothing (`Catalysis.not_widensOrLater`). So deliveries carry the inclusion of the whole possible, not widening. Each law is near-definitional or a witness ([record](../results/records/{RID}.md)).

**Reading** [AI reading, D45]. Constructor theory says what can be done and what cannot, and why. Read on processes, what performs a task is what each delivery restores, not what it holds, so its possible is not the possible relative to a held part ([above](#r-{RID11})), which is sufficient for performing and gives composition its premise. The possible tasks carry reach, along which the whole possible never grows, and on the catalytic cycle it narrows for good; widening follows deliveries in neither direction, so it is not the order they carry. What grows is what can be done with the performer held, and only across changes of the performer. Composition is had where deliveries hold, or restore, what the others use, which locality gives for deliveries on their own performer and substrate; where a delivery changes what its task does not list, a regular pair of possible tasks can be impossible by any means, and constructor theory's demand that a task list its unavoidable outputs is what excludes it ([study]({KIT})).

<a id="r-comparison-content-under-regrouping"></a>""")

# 08 §8: known results beyond the table, after UE11's bullet
edit(CH / '08-METHOD.md', """ The adjacent possible that cannot be prestated (Longo, Montévil and Kauffman 2012) is outside. Each law is near-definitional or a witness.

**Assessment**""", f""" The adjacent possible that cannot be prestated (Longo, Montévil and Kauffman 2012) is outside. Each law is near-definitional or a witness.
- Tasks and what performs them ([07 §2](07-SIGNIFICANCE.md#r-{RID})) reads constructor theory (Deutsch 2013) on any process. Its task, constructor and possible are read with delivery existential, exact and without halting, and its examples, catalysis, an impossible transpose, equal and opposite amounts, the additive pattern of a conservation law and the regress of pharaonic tasks, become theorems or witnesses. Its process-theoretic reading (Gogioso and others 2023) has the possible tasks form a sub-SMC of Rel with the attribute preserved in every outcome; here what performs is restored at the end of each delivery, not held, the parallel case holds on interleavings for pairs, and reuse of one constructor, which that reading leaves open, holds for one region in series and in turn. Locality in Deutsch and Marletto's form (2025) gives composition its holding premise for deliveries on their own performer and substrate, and within one interleaving on one substrate composition can fail. The composition principle, a conjectured law, is not contradicted: a delivery changing what its task does not list can break composition, and constructor theory's tasks list it. A delivery adds nothing to the whole possible, and widening follows deliveries in neither direction, ranking a delivered output above its input on one witness and below it on another: what possible tasks carry is the inclusion of the whole possible, not widening. Each law is near-definitional or a witness.

**Assessment**""")

# 08: receipt and counts, every count read from the receipt (as texts_ue11.py)
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
section = (HERE / 'study_ue12.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
assert '{' not in section and 'TODO' not in section and 'RECHECK-PARAGRAPH' not in section, 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan: item 5 and the owners brought to the landing
PLAN = ROOT / RF / 'development/ue-unified-explanation/PLAN.md'
edit(PLAN,
     "The containment would read tasks as admissions and test whether widening is the order constructor theory's "
     "possible tasks carry.",
     "The containment would read tasks as admissions and test whether widening is the order constructor theory's "
     "possible tasks carry. UE12, tasks and what performs them, landed on 27 October: read on any process divided "
     "into a performing part and a substrate, what performs a task is a region of the part's states restored at the "
     "end of each delivery, so the possible relative to a held part is sufficient for performing and not needed, and "
     "gives composition its premise; composition holds for one region, for two under holding, and on interleavings "
     "with possibility read in each process, and fails within one interleaving on one substrate and where a delivery "
     "changes what its task does not list; catalysis, an impossible transpose, the additive pattern and the "
     "pharaonic regress are theorems or witnesses; and a delivery adds nothing to the whole possible, while widening "
     "what can be reached follows deliveries in neither direction (UE10's lagged order, on what a configuration "
     "reaches, is same-offset widening, which ranks a delivered output above its input on one witness and below it "
     "on another): what possible tasks carry is the inclusion of the whole possible, not widening "
     f"([record](../../../../../../theories/becoming/results/records/{RID}.md)).")
edit(PLAN, "UE0, UE1, UE2, UE1b, UE4, UE5, UE7, UE9, UE10 and UE11, and holds UE8.",
     "UE0, UE1, UE2, UE1b, UE4, UE5, UE7, UE9, UE10, UE11 and UE12, and holds UE8.")
edit(PLAN, "Items 5, 6 and 8 are unclaimed; claim them on the board.",
     "Items 6 and 8 are unclaimed; claim them on the board.")

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records']
assert 'Becoming.Tasks' not in reg['modules']
reg['records'][RID] = {'region': 'significance', 'base': 'frame',
                       'note': 'Tasks UE12: constructor theory read on processes (a region of the performing part '
                               'restored at the end of each delivery, holding sufficient and not needed; composition '
                               'by one region, by two under holding and on interleavings, failing within one '
                               'interleaving and where a delivery changes what its task does not list; the additive '
                               'pattern and the division; the regress; a delivery adds nothing to the whole possible, and '
                               'widening follows deliveries in neither direction)'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.Tasks'] = {'region': 'significance', 'base': 'frame',
                                    'note': 'UE12 tasks and what performs them'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 07 §2 paragraph and reading; 08 bullet and counts:', counts[:90], '...; study section', N,
      '; UE plan; regions')
