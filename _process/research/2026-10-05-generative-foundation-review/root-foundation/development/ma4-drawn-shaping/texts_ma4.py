#!/usr/bin/env python3
"""MA4 texts: the home section of the new record (02 §9: the section's lead, a theorem paragraph after MA3's, the last
clause of MA3's reading, a labelled reading after it, the Open item), one sentence in the overview's capture paragraph
(EN, ZH), the meta-attractor page's status line, 08's receipt and counts read from the receipt, the study section, and
the record's and the module's regions (texts_ma3.py).
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ma4.py RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
OVERVIEW = ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.md'
OVERVIEW_ZH = ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.zh.md'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
META = ROOT / 'theories/meta-attractor/README.md'
RID = 'shaping-read-by-readers-drawn-from-the-selected'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 02 §9: the lead
edit(CH / '02-MAP.md', """what selects it at a step is the part of what it gives that comes back to the shapers alone, net of its cost.""",
     """what selects it at a step is the part of what it gives that comes back to the shapers alone, net of its cost; and where what comes back is read by readers drawn from the selected, that selection and the rule's lock are one loop on either side of a critical mass.""")

# 02 §9: the theorem, after the capacity to shape the rule
edit(CH / '02-MAP.md', """
<a id="r-capture-by-counted-choices"></a>""", f"""
<a id="r-{RID}"></a>
**Theorem** (counts). *What comes back to the shapers, read by readers drawn from the selected.* Read the rule after shaping as the pool of its readers' readings, each shaper among the readers reading it with `hi` coming back to the shapers alone and each other with `lo`, both with the same `a`, `p` and `c`, the readers counted as the population counts them (`DrawnShaping.drawn`). The rule read reads the share monotonically exactly where `lo ≤ hi` (`DrawnShaping.drawn_reads_iff`), and against it where `hi ≤ lo` (`DrawnShaping.drawn_against`): the premise of the loop above is moved to who reads, not removed. At a share it favours the shapers (weakly) exactly where `x.carrier · c + x.other · c ≤ x.carrier · hi + x.other · lo`, whatever `a` and `p` (`DrawnShaping.drawn_favours_iff`, `DrawnShaping.drawn_favours_alike`), and with `lo ≤ c ≤ hi` exactly where the shapers stand to the others at least as `c − lo` to `hi − c` (`DrawnShaping.critical_iff`). With no hypothesis on the readers it favours the shapers at every share exactly where `c ≤ lo` and `c ≤ hi`, and the others strictly at every share exactly where `lo < c` and `hi ≤ c` (`DrawnShaping.favours_everywhere_iff`, `DrawnShaping.disfavours_strictly_everywhere_iff`); with `lo ≤ hi` a share decides exactly where `lo < c < hi` (`DrawnShaping.critical_mass_iff`). With `lo ≤ hi`, under every schedule of reading, from a start under the rule read there: where that rule favours the shapers, every configuration of the course is locked and neither the share nor the rule in force is ever below the start (`DrawnShaping.drawn_locks`); where it favours the others, every configuration is locked the other way and neither is ever above it (`DrawnShaping.drawn_from_below`); so every such course is locked one way at every step (`DrawnShaping.drawn_locked_either`). Strictly favoured at the start, the shapers' share rises strictly at every step; strictly disfavoured, it falls strictly at every step, the shapers present (`DrawnShaping.drawn_rises`, `DrawnShaping.drawn_falls`). That the readers are drawn from those the rule selects and read with `lo ≤ hi`, and that offspring carry the capacity, are premises; `hi`, `lo`, `p` and `c` are constants, and the courses are without noise. **Witnesses**: with `a = 1`, nothing shared, a cost of one, three coming back where a shaper reads and none where another does, one shaper to one other leaves five offspring to four, the course locked from the start and the share rising at every step; one to three leaves seven to eight, the course locked the other way and the share falling; at one to two each kind leaves six and the share stays (`DrawnShaping.CriticalMass`). Read against the share, with `hi = 0` and `lo = 3`, a start favouring the shapers five to four is not locked at the next step (`DrawnShaping.Against.not_locked`) ([record](../results/records/{RID}.md)).

<a id="r-capture-by-counted-choices"></a>""")

# 02 §9: MA3's reading, whose last clause the join makes stale
edit(CH / '02-MAP.md', """such as who holds the places from which the rule is read (`ClosedCapture.Drawn.pool_through`); no theorem joins the two models yet.""",
     """such as who holds the places from which the rule is read (`ClosedCapture.Drawn.pool_through`). The join of the two models ([above](#r-{RID})) takes the readers' premise as `lo ≤ hi` and does not select it.""".replace('{RID}', RID))

# 02 §9: the reading of the join, after MA3's reading
edit(CH / '02-MAP.md', """
**Reading** [AI reading, D45]. Active inference counts the policy it selects""", """
**Reading** [AI reading, D45]. Joined, the meta-attractor's lock and its second order, the selection of control over the selection, are one loop where the rule's readers are drawn from those it selects and the shapers among them read at least as much coming back to the shapers as the others among them do: above the critical mass one start condition gives both, the capacity's share rising at every step and every configuration locked (`DrawnShaping.drawn_rises`, `DrawnShaping.drawn_locks`). Below it control is not selected, yet the course is locked the other way, the rule in force favouring those without the capacity. That is no capture by the shapers but the same closed reading: every course read from the share alone is locked one way or the other (`DrawnShaping.drawn_locked_either`). So control not selected does not by itself give a lock left in time; leaving needs a reading of what lies beyond the share, and the readers' timing (`Thinned`) is not joined to the critical mass. A capacity for which the shapers among the readers read more coming back than it costs is not thereby selected: below the mass it falls (`DrawnShaping.CriticalMass.few_falls`). Where `lo < c < hi` the model is the stag hunt, its critical mass the mixed equilibrium; without noise the start decides, while under rare mutation the long-run state is the risk-dominant one (Kandori, Mailath and Rob 1993; Young 1993), the shapers' wherever `2c < hi + lo`, as in the witness. Whether actual rules are read so is not established, and nothing here ranks a course: that needs C.

**Reading** [AI reading, D45]. Active inference counts the policy it selects""")

# 02: Open list
edit(CH / '02-MAP.md', """- Graded capacities to shape the rule, a gain made by the shapers and divided among all, a gain growing with the number of domains captured, gains passing between domains, and a theorem joining what comes back to the shapers with the readers drawn from the selected; a frozen test of whether what comes back decides the direction (§9).""",
     """- Graded capacities to shape the rule, a gain made by the shapers and divided among all, a gain growing with the number of domains captured, gains passing between domains; readers who learn what comes back, noise, and a loss read once the shapers pass the critical mass (the readers' timing joined to it); a frozen test of whether what comes back decides the direction (§9).""")

# the overview's capture paragraph, EN and ZH
edit(OVERVIEW, """leaves it in place once the selection has left those readers no more than its carriers ([readers drawn from the selected](chapters/02-MAP.md#r-readers-drawn-from-the-selected)).""",
     f"""leaves it in place once the selection has left those readers no more than its carriers ([readers drawn from the selected](chapters/02-MAP.md#r-readers-drawn-from-the-selected)). Where the capacity to shape the rule is carried from parent to offspring and the rule after shaping is read by readers so drawn, the shapers among them reading at least as much coming back to the shapers as the others do, the capacity's selection and the rule's lock are one loop on either side of a critical mass that who reads and the cost locate exactly: above it the capacity rises and the rule stays locked in its favour, below it the capacity falls and the rule stays locked against it, read from the share alone either way ([what comes back, read by readers drawn from the selected](chapters/02-MAP.md#r-{RID})).""")
edit(OVERVIEW_ZH, """待选择使这些读者不多于携带者之后则留下锁定（[从所选者中抽出的读者](chapters/02-MAP.md#r-readers-drawn-from-the-selected)）。""",
     f"""待选择使这些读者不多于携带者之后则留下锁定（[从所选者中抽出的读者](chapters/02-MAP.md#r-readers-drawn-from-the-selected)）。在塑造规则的能力由亲代传给后代、且塑造后的规则由这样抽出的读者读取之处（其中塑规者读到的返于塑规者者不少于他者），能力的被选与规则的锁定是同一个环，临界量两侧皆然，其临界量由谁读与成本恰好确定：其上，能力上升，规则锁定于对它有利的一侧；其下，能力下降，规则锁定于对它不利的一侧；两侧都只从份额读出（[返于塑规者者，由取自被选者的读者读取](chapters/02-MAP.md#r-{RID})）。""")

# the meta-attractor page's status line, newest first
edit(META, """# The Meta-Attractor (元吸引子 / 总体化吸引子)

**主干上的第二阶 / The second order on the spine，2026-10-25。**""", f"""# The Meta-Attractor (元吸引子 / 总体化吸引子)

**主干上的一个回路 / One loop on the spine，2026-10-26。** 规则之读者取自其所选者、其中塑规者读返于塑规者者不少于他者时，塑规之能之被选与规则之锁定为一回路：临界量之上，其能每步皆升而规则锁定于其利；其下，其能每步皆降而规则锁定于其不利；临界量由谁读与成本恰定（`Becoming.DrawnShaping`，[记录](../becoming/results/records/{RID}.md)）。/ Where the rule's readers are drawn from those it selects and the shapers among them read at least as much coming back to the shapers as the others do, the selection of the capacity to shape the rule and the rule's lock are one loop: above a critical mass the capacity rises at every step and the rule stays locked in its favour, below it the capacity falls and the rule stays locked against it, and who reads and the cost locate the mass exactly ([chapter 2 §9](../becoming/chapters/02-MAP.md#r-{RID})). Below the mass control is not selected, yet the rule is still read from the share alone: leaving needs a reading of what lies beyond it. Without noise the start decides; under rare mutation the long-run state is the risk-dominant one. The calibration to the present world is not established.

**主干上的第二阶 / The second order on the spine，2026-10-25。**""")

# 08: receipt and counts, every count read from the receipt
R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.DrawnShaping')
assert not any(mod['axiom_dependencies'].values())
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
section = (HERE / 'study_ma4.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, ('study section number', N)
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records'] and 'Becoming.DrawnShaping' not in reg['modules']
reg['records'][RID] = {'region': 'map', 'base': 'general',
                       'note': 'DrawnShaping MA4: what comes back to the shapers, read by readers drawn from the selected'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.DrawnShaping'] = {'region': 'map', 'base': 'general',
                                           'note': 'MA4 the join of the capacity to shape the rule with the readers drawn from the selected'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 02 §9 lead, paragraph, MA3 reading clause, reading and Open item; the overview EN and ZH; meta-attractor '
      'status; 08 counts:', counts[:90], '...;', 'study section', N, '; regions')
