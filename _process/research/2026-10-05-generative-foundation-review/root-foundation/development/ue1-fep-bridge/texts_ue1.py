#!/usr/bin/env python3
"""UE1 texts: the home section of the new record (02 §9: a theorem paragraph after the capacity to shape the rule, a
labelled reading after the corpus's second order, an item in the chapter's Open list), a pointer paragraph in 03 §1,
a bullet in 08 §8's known results beyond the table and 08's receipt and counts read from the receipt, the study
section, and the record's and the module's regions. Mirrors MA3's texts_ma3.py; revised after UE1's review.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue1.py RECEIPT N"""
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
RID = 'capture-by-counted-choices'
KIT = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue1-fep-bridge/NOTE.md'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 02 §9: the theorem, after the capacity to shape the rule
edit(CH / '02-MAP.md', """
<a id="r-rules-that-change-themselves-in-the-grammar"></a>""", f"""
<a id="r-{RID}"></a>
**Theorem** (World for the selection laws; counts for the count laws). *A chooser reading what couples in, its rule read from the count of its choices.* The choice made from a fold of the prefix of what couples into a formation, whatever the fold and whatever the choice, is a selection through the formation's couplings up to each step (`ChoiceCountCapture.selectsThrough`), so a part acting only beyond the coupling closure does not change it, under the hypotheses of the blindness law (`ChoiceCountCapture.unchosen_beyond_coupling`); choosers sharing their folds select through the pooled couplings (`ChoiceCountCapture.pooled_selectsThrough`, `ChoiceCountCapture.pooled_unchosen_beyond`). This part is near-definitional. On `RuleCapture`'s counts let a chooser over two policies take the first where its rule weighs it at least as much as the second, that policy's count rising by one (`ChoiceCountCapture.choose`), the rule read from the counts weighted by a standing score, `κc` for the first policy and `κo` for the second (`ChoiceCountCapture.weighted`): choosing by a favouring rule raises the share it reads, and the reading is monotone in the share (`ChoiceCountCapture.choose_raises`, `ChoiceCountCapture.weighted_reads`). Under a standing score, with the rule in force read from the counts at the start, along every schedule of reading the threshold `κo · other ≤ κc · carrier` divides the counts into two regions the course never leaves: at or above it the first policy is taken at every step and neither the share nor the rule falls, also where the score favours the second policy (`κc < κo`); below it the second policy is taken at every step (`ChoiceCountCapture.counted_locks`, `ChoiceCountCapture.counted_chooses`, `ChoiceCountCapture.counted_locks_down`, `ChoiceCountCapture.counted_chooses_down`). Joined to a coordinate the loop does not read and that rises at every step, the locked course outlives every bound on it (`ChoiceCountCapture.counted_outlives_loss`). Counted instead from the posterior at the time of choosing, the counts scaled with the posterior's weights added, a score favouring the second policy lowers the first policy's share strictly at every step (`ChoiceCountCapture.posterior_count_falls`, `ChoiceCountCapture.posterior_course_falls`, from `RuleShaping.falls_strictly`). **Theorem** (witnesses): three choices to one keep the first policy against a score weighing the second twice as much, and from one to one the score decides for good; one count moved, three to two, locks the other way; a rule an older score left in force carries counts above the threshold the other way, and a change of score read one step late leaves the old lock in place where read at once it would turn; counted from the posterior, three to one falls at the first step while the weighted rule still favours the first policy, by a tie, and favours the second from the second step (`ChoiceCountCapture.Witness`; [record](../results/records/{RID}.md)).

<a id="r-rules-that-change-themselves-in-the-grammar"></a>""")

# 02 §9: the reading, after the reading of the corpus's second order
edit(CH / '02-MAP.md', """
**Reading** [AI reading, D65]. The corpus's meta-attractor is wider:""", f"""
**Reading** [AI reading, D45]. Active inference counts the policy it selects into its prior over policies: at the end of each trial it adds the posterior over policies, which the trial's outcomes concentrate on the policy pursued, so its count is close to the count of the executed policy, split among policies that explain the trial equally (Friston and others 2016, §2.4). Its simulation of devaluation shows the persistence: devalued after the habit has formed, the habit persists and strengthens with use, while devalued earlier the agent switches at once (§5.2). The lock is the lock-in of increasing returns (Arthur 1989), and counting the action taken is the value-free habit (Miller, Shenhav and Ludvig 2019). What the law above adds is exactness for a simplified model, the counts themselves as the prior with no free-energy term, sampling or split, and its edges: a moved count, a stale rule or a change of score read late carries the course across. It is capture through the rule, closed in the sense of the unread loss; its score stands, so it is not the meta-attractor, whose reading too is formed from the share. The free-energy principle's sparse coupling is read here as the couplings ([the bridge]({KIT})). In rats, extended training makes responding insensitive to devaluation (Adams 1982; Dickinson 1985); five attempts to induce it in humans failed (de Wit and others 2018).

**Reading** [AI reading, D65]. The corpus's meta-attractor is wider:""")

# 02: Open list
edit(CH / '02-MAP.md', """- A field test of T1 with a need measured in advance;""",
     """- For a rule read from the count of its choices: more than two policies, intermediate precision, a score that changes with the outcomes, the split among policies that explain a trial equally, a law with a bound for additive counting, and a frozen test of whether a count of choices reverses under a standing score (§9).
- A field test of T1 with a need measured in advance;""")

# 03 §1: a pointer after the reading of selection
edit(CH / '03-KNOWING.md', """
<a id="observation"></a>""", f"""
A chooser that folds what couples in and chooses from the fold, the free-energy principle's agent so represented among them, selects through its couplings whatever its update and choice, and choosers sharing their folds select through their pooled couplings ([02 §9](02-MAP.md#r-{RID})).

<a id="observation"></a>""")

# 08 §8: known results beyond the table
edit(CH / '08-METHOD.md', """- Every least loss that physics supplies is a theorem of stochastic thermodynamics, with premises of its own.""",
     f"""- Every least loss that physics supplies is a theorem of stochastic thermodynamics, with premises of its own.
- A rule read from the count of its choices ([02 §9](02-MAP.md#r-{RID})) is the lock-in of increasing returns (Arthur 1989) and, counting the action taken, the value-free habit (Miller, Shenhav and Ludvig 2019); active inference's own simulation of devaluation shows the persistence (Friston and others 2016, §5.2). What the law adds is exactness for a simplified model and its edges, so as a containment of the free-energy principle it is a restatement with its third part open.""")

# 08: receipt and counts, every count read from the receipt (as texts_ma3.py)
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
section = (HERE / 'study_ue1.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records'] and 'Becoming.ChoiceCountCapture' not in reg['modules']
reg['records'][RID] = {'region': 'map', 'base': 'general',
                       'note': 'ChoiceCountCapture UE1: a chooser reading what couples in, its rule read from the count of its choices'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.ChoiceCountCapture'] = {'region': 'map', 'base': 'general',
                                                 'note': 'UE1 capture by counted choices: the free-energy principle as a case'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 02 §9 paragraph, reading and Open item; 03 pointer; 08 bullet and counts:', counts[:90], '...;',
      'study section', N, '; regions')
