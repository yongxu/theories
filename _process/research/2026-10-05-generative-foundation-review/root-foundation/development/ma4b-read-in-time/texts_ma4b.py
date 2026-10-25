#!/usr/bin/env python3
"""MA4b texts: the home section of the new record (02 §9: the section's lead, a theorem paragraph after MA4's, the
clause of MA4's reading that the join makes stale, a labelled reading after it, the Open item), one sentence in the
overview's capture paragraph (EN, ZH), the meta-attractor page's status line, 08's receipt and counts read from the
receipt, the study section, and the record's and the module's regions (texts_ma4.py).
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ma4b.py RECEIPT N"""
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
RID = 'loss-read-in-time-by-the-others'
MA4 = 'shaping-read-by-readers-drawn-from-the-selected'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 02 §9: the lead
edit(CH / '02-MAP.md', """and where what comes back is read by readers drawn from the selected, that selection and the rule's lock are one loop on either side of a critical mass.""",
     """and where what comes back is read by readers drawn from the selected, that selection and the rule's lock are one loop on either side of a critical mass; where the others among those readers read a loss late, a reading leaves that lock only before the first step at which their late reading would favour the shapers, ties aside, and a deadline bounds that window.""")

# 02 §9: the theorem, after MA4's
edit(CH / '02-MAP.md', """
<a id="r-capture-by-counted-choices"></a>""", f"""
<a id="r-{RID}"></a>
**Theorem** (counts). *The loss read in time by the others, joined to the critical mass.* Let the others among the readers above read a loss once it reaches a bound `N` (`ClosedCapture.Thinned.lossPool`): the shapers among the readers read the rule after shaping with `hi` coming back to the shapers, whatever the loss, and the others with `lo` while the loss is below `N` and with `lo'` from then on, all with the same `a`, `p` and `c` (`ReadInTime.shapedLossPool`). Where every step adds at least one to the loss and `lo' ≤ hi`, at a reading step at which the loss has reached `N` and the rule in force favours the shapers, the course is locked in their favour for good from the next step exactly where `x.carrier · c + x.other · c ≤ x.carrier · hi + x.other · lo'` at the share there (`ReadInTime.kept_iff`); at one at which the late reading favours the others (ties included), the next step reading too, the course is locked the other way for good from two steps after the reading exactly where the late reading favours the others at the share of the next step, a share selected under the rule in force at the reading (`ReadInTime.turned_iff`). With the loss starting at zero and growing by one a step, the joined course up to step `N` is the course above (`ReadInTime.early`, `ReadInTime.next_share`). From a start under the rule read there that favours the shapers, with `lo ≤ hi` and `lo' ≤ hi`, the late reading never falls along that course (`ReadInTime.late_never_falls`); read from a reading step `N`, the course is kept locked for good from step `N + 1` exactly where the late reading favours the shapers at the share of step `N`, and, step `N + 1` reading too, turned for good from step `N + 2` exactly where it favours the others at the share of step `N + 1` (`ReadInTime.kept_early_iff`, `ReadInTime.turned_early_iff`). So, with the rule read at steps `N` and `N + 1`, the steps from which a reading turns the course come first and those from which it keeps the lock come last, ties aside (`ReadInTime.in_time_earlier`, `ReadInTime.kept_once_favoured`), and at most one step lies between, with `lo ≤ hi` alone (`ReadInTime.at_most_one_between`): from it neither law decides, and the course starts a new round, to which the two laws apply again from step `N + 2` (`ReadInTime.kept_next_round_iff`). `favours` and `disfavours` are weak: where every rule read ties, a reading both keeps and turns in the sense of these laws (`ReadInTime.Tie.both`). Where the late reading with nothing read as coming back favours the shapers, every late reading of this form does, with `c ≤ hi` exactly where `x.other · c ≤ x.carrier · (hi − c)`, and from such a step of the course every reading of this form with `lo' ≤ hi` keeps the lock (`ReadInTime.least`, `ReadInTime.least_iff`, `ReadInTime.kept_past_least`). From a start with a shaper present whose rule `g` read there favours the shapers strictly, with `lo ≤ hi` and `lo' ≤ hi`, a reading of this form from any reading step from `g.other · c · x.other` on keeps the lock, under every schedule of reading steps (`ReadInTime.deadline`, by Bernoulli's inequality); the deadline is a bound, quadratic in the start's counts, not the step from which the window is closed. That the others read the loss at all, and that their late reading has this form, the same `a`, `p` and `c` with a natural number read as coming back, are premises: a late reading of another form has another window, and one whose weight against the shapers is chosen after the share is seen could turn the course from any share, which is not stated. **Witnesses**: with `a = 1`, nothing shared, a cost of three, five read as coming back where a shaper reads, two where another does and nothing once the others read the loss, from one shaper to one other, the rule read at every step: read from step 2, the course is locked the other way for good from step 4; step 3 is the one step between, and read from there, though the late reading still favours the others at the share of step 3 and the rule in force at step 4 favours them, the course is not turned for good, and from step 6 it is locked in the shapers' favour for good; read from step 4 or later, by any reading of this form with `lo' ≤ 5`, the lock stays; the deadline is 24, and 96 from two to two with the same window (`ReadInTime.Window`). With a cost of one, three, two and nothing, from one shaper to three others, step 0 is the step between and the course read from there is turned for good from step 4 (`ReadInTime.Between.turned`) ([record](../results/records/{RID}.md)).

<a id="r-capture-by-counted-choices"></a>""")

# 02 §9: MA4's reading, whose clause on the readers' timing the join makes stale
edit(CH / '02-MAP.md', """So control not selected does not by itself give a lock left in time; leaving needs a reading of what lies beyond the share, and the readers' timing (`Thinned`) is not joined to the critical mass.""",
     f"""So control not selected does not by itself give a lock left in time; leaving needs a reading of what lies beyond the share, made in time ([below](#r-{RID})).""")

# 02 §9: the reading of the join, after MA4's reading
edit(CH / '02-MAP.md', """
**Reading** [AI reading, D45]. Active inference counts the policy it selects""", f"""
**Reading** [AI reading, D45]. Joined to the critical mass, the others' late reading of the loss gives one horn of Collingridge's dilemma (1980) as a theorem and the other as a premise: from the first step at which the late reading would favour the shapers a reading keeps the lock, and past the least reading's threshold every reading of this form does; that the need is read too late is the premise that the loss is read only from `N`. Biggs, Carpenter and Brock (2009) give the continuous analogue of the window. Read from a step, the course is turned for good from two steps on exactly where the late reading at the share a step on still favours the others, since the rule in force lags the rule read by a step, a lag of the representation (compare replicator selection with a delay, Alboszta and Miękisz 2004); from the one step that may lie between, the course starts a new round, which can go either way. So a lock left in time, the joint selection's second condition, is in this model a reading of what lies beyond the share made before the share passes the step from which the late reading would favour the shapers: the point of no return belongs to the share's course, and the loss only times the reading. A reading of the share alone never leaves the lock (`DrawnShaping.drawn_locked_either`), while above the critical mass, where control is selected, a reading of the loss in time still leaves it: in this model the second condition can hold where the first fails. From a start favouring the shapers strictly the window closes by a deadline (`ReadInTime.deadline`), a loose bound, quadratic in the start's counts. What would widen the window, the loss read before it reaches `N` or a late reading of another form, is not stated. Whether actual rules are read so, and who such readers are, is not established: the one frozen test of the timing law on a trained judge found that judge's reading not a pool counted by kind, one note in nine turning it, so the law did not apply there ([LA2](../../../experiments/self-rewarding-lock/README.md)). Nothing here ranks a course: that needs C.

**Reading** [AI reading, D45]. Active inference counts the policy it selects""")

# 02: Open list
edit(CH / '02-MAP.md', """readers who learn what comes back, noise, and a loss read once the shapers pass the critical mass (the readers' timing joined to it); a frozen test of whether what comes back decides the direction (§9).""",
     """readers who learn what comes back, noise, a late reading of another form than the shapers' (its own weight or cost), a general law for the round that starts at the one step between, and the step from which the window is closed rather than a bound on it; a frozen test of whether what comes back decides the direction (§9).""")

# the overview's capture paragraph, EN and ZH
edit(OVERVIEW, f"""read from the share alone either way ([what comes back, read by readers drawn from the selected](chapters/02-MAP.md#r-{MA4})).""",
     f"""read from the share alone either way ([what comes back, read by readers drawn from the selected](chapters/02-MAP.md#r-{MA4})). Where the others among those readers read a loss once it reaches a bound, a reading while their late reading, at the share one step on, still favours them turns the course for good, and a reading once it would favour the shapers leaves the lock in place; with the rule read at both steps at most one step lies between, from which the course starts a new round, and from a start favouring the shapers strictly a deadline, quadratic in the start's counts, bounds the window ([the loss read in time](chapters/02-MAP.md#r-{RID})).""")
edit(OVERVIEW_ZH, f"""两侧都只从份额读出（[返于塑规者者，由取自被选者的读者读取](chapters/02-MAP.md#r-{MA4})）。""",
     f"""两侧都只从份额读出（[返于塑规者者，由取自被选者的读者读取](chapters/02-MAP.md#r-{MA4})）。在这些读者中的他者于损失达到一界之后才读它之处：读时，若他们在下一步份额处的迟读仍偏向他们，则永转其进程；若迟读已偏向塑规者，则锁定留存；两步皆读时，两者之间至多一步，自该步进程另起一轮；起点严格偏向塑规者时，一个期限（起点计数的二次式）界定此窗口（[及时读损失](chapters/02-MAP.md#r-{RID})）。""")

# the meta-attractor page's status line, newest first
edit(META, """# The Meta-Attractor (元吸引子 / 总体化吸引子)

**主干上的一个回路 / One loop on the spine，2026-10-26。**""", f"""# The Meta-Attractor (元吸引子 / 总体化吸引子)

**主干上的及时之读 / A reading in time on the spine，2026-10-26。** 读者中之他者于损失达一界后方读之时：读时下一步份额处之迟读仍偏向他者，则永转其进程；迟读一旦偏向塑规者，则锁定留存；两步皆读时其间至多一步，自该步另起一轮；起点严格偏向塑规者时，一期限界此窗口（`Becoming.ReadInTime`，[记录](../becoming/results/records/{RID}.md)）。/ Where the others among the readers read a loss only once it reaches a bound, a reading while their late reading at the share one step on still favours them turns the course for good, and once it would favour the shapers the lock stays; with the rule read at both steps at most one step lies between, from which the course starts a new round, and from a start favouring the shapers strictly a deadline bounds the window ([chapter 2 §9](../becoming/chapters/02-MAP.md#r-{RID})). In the model the second horn of Collingridge's dilemma is a theorem and the first a premise. A reading of the share alone never leaves the lock; what would widen the window, an earlier reading of the loss or a late reading of another form, is not stated, and the calibration to the present world is not established.

**主干上的一个回路 / One loop on the spine，2026-10-26。**""")

# 08: receipt and counts, every count read from the receipt
R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.ReadInTime')
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
section = (HERE / 'study_ma4b.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
assert '{' not in section and '}' not in section, 'a placeholder in the study section is unfilled'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, ('study section number', N)
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records'] and 'Becoming.ReadInTime' not in reg['modules']
reg['records'][RID] = {'region': 'map', 'base': 'general',
                       'note': 'ReadInTime MA4b: the loss read in time by the others, joined to the critical mass'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.ReadInTime'] = {'region': 'map', 'base': 'general',
                                         'note': 'MA4b the readers\' timing joined to the critical mass'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 02 §9 lead, paragraph, MA4 reading clause, reading and Open item; the overview EN and ZH; meta-attractor '
      'status; 08 counts:', counts[:90], '...;', 'study section', N, '; regions')
