#!/usr/bin/env python3
"""MA3 texts: the home section of the new record (02 §9: the section's lead, a theorem paragraph and a labelled reading
after the reading against the share, an item in the chapter's Open list), the meta-attractor page's status line, 08's
receipt and counts read from the receipt, the study section, and the record's and the module's regions.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ma3.py RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
META = ROOT / 'theories/meta-attractor/README.md'
RID = 'shaping-the-rule-selected-by-what-comes-back'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 02 §9: the lead
edit(CH / '02-MAP.md', """who reads decides whether, and when, a reading of the loss turns it.""",
     """who reads decides whether, and when, a reading of the loss turns it; and where the capacity to shape the rule is carried from parent to offspring, what selects it at a step is the part of what it gives that comes back to the shapers alone, net of its cost.""")

# 02 §9: the theorem, after the readers drawn from the selected
edit(CH / '02-MAP.md', """
<a id="r-rules-that-change-themselves-in-the-grammar"></a>""", f"""
<a id="r-{RID}"></a>
**Theorem** (counts). *The capacity to shape the rule, selected by what comes back to it.* On `RuleCapture`'s counts let the carriers be shapers: shaping gives `s` to the shapers alone and `p` to every member alike and costs each shaper `c`, so that each shaper leaves `a + s + p` offspring and each other `a + c + p`, `a` positive (`RuleShaping.shaped`). At a step the rule favours the shapers (weakly) exactly where `c ≤ s`, whatever `p` (`RuleShaping.favours_iff`, `RuleShaping.favours_alike`); a larger `p` pulls the rule toward even, not higher where `c ≤ s` and not lower where `s ≤ c` (`RuleShaping.shared_lowers`, `RuleShaping.shared_raises`), and a smaller cost raises it (`RuleShaping.lower_c_raises`). With nothing coming back and a cost, the shapers' share falls strictly at every step, the shapers present (`RuleShaping.nothing_back_falls`); with no cost to them alone and nothing coming back, selection leaves the share where it is (`RuleShaping.neutral_steady`). Selection by rules in turn is selection by their product (`RuleShaping.select_thenBy`, `RuleShaping.orbit_held`), so across `m` steps before anything comes back and `n` steps with it, the shapers present, their share does not fall exactly where `(a + c + p)^m (a + c + p)^n ≤ (a + p)^m (a + s + p)^n`, and rises exactly where the inequality is strict (`RuleShaping.stretch_iff`, `RuleShaping.stretch_lt_iff`); only how many steps of each kind matters. One more step before anything comes back never helps the shapers, and one more step with it never hurts them where it covers the cost (`RuleShaping.wait_not_more`, `RuleShaping.back_longer_not_less`). On the reading of what comes back from the shapers' share at each reading step (`RuleShaping.byBack`), the rule read reads the share exactly where what comes back is monotone in it (`RuleShaping.byBack_reads_iff`), so there `ReadsShare` is a statement about what comes back; monotone and covering the cost at every share, the loop locks (`RuleShaping.covering_locks`). At a threshold, what comes back `hi` where the shapers are at least as many as the others and `lo` where they are fewer, with `lo < c < hi`, the course tips: from a start above, the rule in force stays the one read above and the shapers' share rises strictly at every step; from a start below it falls strictly at every step (`RuleShaping.threshold_rises`, `RuleShaping.threshold_falls`); with `lo ≤ c ≤ hi` neither side is left (`RuleShaping.threshold_from_above`, `RuleShaping.threshold_from_below`). That offspring carry their parent's capacity, and that what comes back is read from the share, are premises; `s` and `p` are constants of the rule. **Witnesses**: with `s + p = 5` to each shaper and a cost of one, the rule favours the shapers where two of the five come back to them alone and disfavours them where none does (`RuleShaping.Split`); with `a = 1`, `c = 1`, `s = 2`, two steps before and three with what comes back lower the shapers' share with nothing shared and raise it with one to every member, so across a stretch the shared part can turn the verdict (`RuleShaping.SharedFlips`); with `a = 2`, `c = 1`, `s = 2`, one step before and two with it raise the share, two and two or one and one lower it, and after five steps before, seven with it lower it and eight raise it (`RuleShaping.Timing`) ([record](../results/records/{RID}.md)).

<a id="r-rules-that-change-themselves-in-the-grammar"></a>""")

# 02 §9: the reading, after the reading of the readers (D67)
edit(CH / '02-MAP.md', """
**Reading** [AI reading, D65]. The corpus's meta-attractor is wider:""", """
**Reading** [AI reading, D45]. The corpus's second order, that recursive selection favours mechanisms which increase control over future selection ([meta-attractor](../../meta-attractor/README.md#selection-for-control-over-selection-2026-10-02-after-review)), is the law of the capacity to shape the rule with its conditions: two kinds carried from parent to offspring (a premise), a rule the shapers change, the part of what they give that comes back to them alone, and how many steps carry the cost before and with it. Its lever is exact at a step: where rule-making gives nothing back to the rule-makers alone and costs them, the capacity falls; where it costs them nothing either, it is selected neither way; help that lowers the cost moves the rule toward the shapers. Across a stretch the base and the shared part enter too, and can turn the verdict. A shaping that sets only the rule's value is read again from the share at the next reading step, but the share it moved stays, and carried across a threshold it holds the course there (`RuleCapture.Reversed.not_absorbed`, `RuleShaping.threshold_rises`). Read with the readers drawn from the selected, a reader whose reading favours its own kind gives a gain that comes to every member of that kind alike: among them the reading is a shaping with nothing coming back to the reader alone, not selected on its own gain and falling with any cost (`RuleShaping.nothing_back_falls`, read within the kind), so what keeps the readers' premise is something other than selection on the reading, such as who holds the places from which the rule is read (`ClosedCapture.Drawn.pool_through`); no theorem joins the two models yet. Whether actual institutions or trained systems meet these premises is not established, and nothing here ranks open rule-making above capture: that needs C.

**Reading** [AI reading, D65]. The corpus's meta-attractor is wider:""")

# 02: Open list
edit(CH / '02-MAP.md', """- Whether a capture loop (§9) is 生成 at some pair of classes, and a law relating the map's 生成 to widening what can form.""",
     """- Whether a capture loop (§9) is 生成 at some pair of classes, and a law relating the map's 生成 to widening what can form.
- Graded capacities to shape the rule, a gain made by the shapers and divided among all, a gain growing with the number of domains captured, gains passing between domains, and a theorem joining what comes back to the shapers with the readers drawn from the selected; a frozen test of whether what comes back decides the direction (§9).""")

# the meta-attractor page's status line, newest first
edit(META, """# The Meta-Attractor (元吸引子 / 总体化吸引子)

**主干上的回路 / The loop on the spine，2026-10-20。**""", f"""# The Meta-Attractor (元吸引子 / 总体化吸引子)

**主干上的第二阶 / The second order on the spine，2026-10-25。** 一步之内，塑规之能以其所予中独返于塑规者之部分、扣除其成本而被选；众人同得之部分不定其向，惟使规则趋平，跨一段则可改其结论；所返随份额单调且覆盖成本时，回路锁定；门槛两侧，份额两向而转（`Becoming.RuleShaping`，[记录](../becoming/results/records/{RID}.md)）。/ At a step, the capacity to shape the rule is selected by the part of what it gives that comes back to the shapers alone, net of its cost; the part every member receives does not decide the direction, though it pulls the rule toward even and across a stretch can turn the verdict; where what comes back is monotone in the shapers' share and covers the cost, the loop locks, and at a threshold the share tips both ways ([chapter 2 §9](../becoming/chapters/02-MAP.md#r-{RID})). That offspring carry the capacity and that what comes back is read from the share are premises; the calibration to the present world is not established.

**主干上的回路 / The loop on the spine，2026-10-20。**""")

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
path = CH / '08-METHOD.md'
s = path.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
path.write_text(s, encoding='utf-8')

# the study section
section = (HERE / 'study_ma3.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records'] and 'Becoming.RuleShaping' not in reg['modules']
reg['records'][RID] = {'region': 'map', 'base': 'general',
                       'note': 'RuleShaping MA3: capacity to shape the rule selected by what comes back'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.RuleShaping'] = {'region': 'map', 'base': 'general',
                                          'note': 'MA3 capacity to shape the rule, selected by what comes back'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 02 §9 lead, paragraph, reading and Open item; meta-attractor status; 08 counts:', counts[:90], '...;',
      'study section', N, '; regions')
