#!/usr/bin/env python3
"""UE10 texts: the home section of the new record (07 §2: a theorem paragraph and a labelled reading after comparing two
courses on what they admit); eventual widening's reading and UE9's reading pointed to it; 07's Open item on the
second-order direction narrowed; a bullet in 08 §8's known results beyond the table and 08's receipt and counts read
from the receipt; the study section; the UE plan's item 7 and owners; the record's and the module's regions. Mirrors
UE9's texts_ue9.py.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue10.py RECEIPT N"""
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
RID = 'what-a-course-keeps-reachable'
RID9 = 'comparing-two-courses-on-what-they-admit'
KIT = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue10-what-can-be-reached/NOTE.md'
KIT9 = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue9-comparing-courses/NOTE.md'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 07 §2: eventual widening's reading, what a course keeps reachable now read
edit(CH / '07-SIGNIFICANCE.md',
     "What a course keeps reachable, and what carries its openings, are where the second order would be read;",
     "What a course keeps reachable ranks a range that keeps widening above one wider now that starts a course only "
     f"read with a lag, and then not every such pair ([below](#r-{RID})), and what carries its openings is where the "
     "second order would still be read;")

# 07 §2: UE9's reading, its last sentence
edit(CH / '07-SIGNIFICANCE.md',
     f"what a course keeps reachable and what carries its openings remain the candidates ([study]({KIT9})).",
     f"what a course keeps reachable is read below ([§2](#r-{RID})), and what carries its openings remains "
     f"([study]({KIT9})).")

# 07 §2: the theorem and the reading, after comparing two courses on what they admit
edit(CH / '07-SIGNIFICANCE.md', """
<a id="r-comparison-content-under-regrouping"></a>""", f"""
<a id="r-{RID}"></a>
**Theorem** (any process, and witnesses). *What a course keeps reachable.* Read on any process through what each configuration admits, a configuration *covers* another where every course from the other is included, offset for offset, by a course from it (`Reaching.Covers`), and *widens what can be reached* over it where it covers it and some course from it is included by no course from the other (`Reaching.Widens`). Covering is a preorder, and widening what can be reached is irreflexive, transitive and not covered back, with no premise (`Reaching.Covers.trans`, `Reaching.Widens.trans`, `Reaching.widens_not_covered`). Covering implies inclusion now: a configuration covering one that starts a course admits now all that one admits now (`Reaching.Covers.now`), though inclusion now does not give covering (`WiderNow.inclusion_now_not_covering`). So where a configuration that starts a course admits now what another does not, widening what can be reached does not rank the other above it (`Reaching.not_widens_of_wider_now`), nor, with the courses read as realized starting at their configurations, does the lexical order below (`Reaching.not_above_wider_now`); the premise is needed (`EndsNow.keeps_widening_above_wider_now`). On a determined process widening what can be reached is the strict part of range inclusion of the two courses (`Reaching.widens_iff_of_unique`), and where each configuration has a course including every course from it, of those courses (`Reaching.widens_iff_of_greatest`). Covering with lag `d`, every course from the other included `d` offsets later by a course from it (`Reaching.CoversLater`), gives widening what can be reached with a lag, covering with some lag and covered back with none (`Reaching.WidensWithLag`). Joined to widening what can be reached as the lag is joined to widening above (`Reaching.WidensOrLater`), it is a strict partial order containing widening what can be reached that never ranks a configuration above one covering it (`Reaching.WidensOrLater.irrefl`, `Reaching.WidensOrLater.trans`, `Reaching.WidensOrLater.not_covered`), and along a course it ranks a successor above its predecessor exactly where same-offset widening does (`Run.widensOrLater_next_iff`). On one determined witness, where what a climb admits keeps widening and another configuration admits now what the climb does not, it ranks the climb above the other while same-offset widening and the lexical order are silent (`WiderNow.silent`, `WiderNow.decided`); with other admissions on the same process, each course still exceeding the other, it is silent both ways (`WiderNow.TwoSided.silent`), and where the other also widens what can be reached over the climb it ranks the other above, as it must (`WiderNow.Full.not_silent`). Both orders satisfy C on the frame of reachable ranges, and on the witness they differ (`Reaching.comparison_widens`, `Reaching.comparison_widensOrLater`, `WiderNow.comparison_undecided`). The whole possible from a configuration, what some configuration reachable from it admits, is realizability within some bound (`Reaching.possible_iff_withinMoves`). Along every course nothing is added to it, and a lost possibility has no way back (`Run.possible_of_next`, `Run.not_possible_returns`); where every configuration reachable from a configuration starts a course, a configuration covering it has all that is possible from it (`Reaching.Covers.possible`), and a configuration that starts no course is covered by every configuration (`Reaching.covers_of_no_course`; the premise needed, `NoCourse.widens_reversed`). Same-offset widening of what can be reached can rise along a course while the whole possible stays the same (`Rise.rises`, `Rise.possible_same`): with a lag of one step every configuration of a course covers its successor (`Run.coversLater_next`), and on a determined process a rise is the course one step on strictly including the course (`Reaching.widens_next_iff_rising`). A chain keeping widening, in this section's form read from its first step, is held by no list (`Reaching.KeepsWidening.not_listed`), and keeping widening by name is exactly such a chain (`Web.keepsWidening_iff_chain`); so along a course the possible within a horizon keeps widening only where no list holds the whole possible (`Reaching.not_keepsWidening_of_listed`), which does not suffice (`AllAtOnce.converse_fails`). On a branching witness one configuration's realized course widens another's while the other widens what can be reached over it through a course not realized, so there no strict partial order contains both, nor satisfies C both on the realized courses and on the reachable ranges (`KeptAlternative.disagree`, `KeptAlternative.no_order_contains_both`, `KeptAlternative.no_comparison_both`); on a determined process, with the realized courses starting at their configurations, realized widening gives widening what can be reached (`Reaching.widens_of_rangeWidens`). Realized widening, or the same realized range and widening what can be reached (`Reaching.Lexical`), is a strict partial order lying inside the two-tier lexical order, which gives it back where the inclusions are decided (`Reaching.Lexical.trans`, `Reaching.lexical_above`, `Reaching.lexical_of_above_decided`). Covering is inclusion of the ranges some course includes, the lower preorder of the families of course ranges (`Reaching.covers_iff_included`), and dominance for every criterion closed upward under inclusion (`Reaching.covers_iff_criteria`); widening what can be reached is extension on the frame of reachable ranges (`Reaching.widens_iff_extension`), so C read there is `Comparison (Reaching.reachFrame P adm) (fun _ => True)`. Covering cannot see when a commitment is made (`DeferredBranching.cover_both`, `DeferredBranching.early_not_simulating_late`), and on a witness the bundles realizable from a configuration within every bound do not determine what can be reached together (`KeptTogether.no_comparison_through_bundles`). Each law is near-definitional or a witness, and no order here is adopted by C ([record](../results/records/{RID}.md)).

**Reading** [AI reading, D45]. What a course keeps reachable does not by itself give the second-order direction 07 asks for: compared at the same offsets, covering implies inclusion of what each configuration admits now, so a range that keeps widening is never ranked above one wider now that starts a course, and on a determined process it is a first-order comparison. Read with a lag, built as comparing two courses builds its lagged order, it ranks some such pairs and not every one, and where same-offset widening is silent C does not choose between the two, so the lag's verdict is a premise beyond C, as the choice between counting early steps and reading only tails is there. What it adds is alternatives: on a branching witness the realized course and the courses kept reachable rank a pair oppositely, so an account holding both needs a rule of precedence, a premise, and covering cannot see when a commitment is made. Within one fixed process nothing is added to the whole possible, and the possible within a horizon only moves with the actual; growth of the possible itself would need a process that changes, which no law here states ([study]({KIT})).

<a id="r-comparison-content-under-regrouping"></a>""")

# 07: the Open item on the second-order direction, narrowed
edit(CH / '07-SIGNIFICANCE.md',
     "so the lag does not choose between counting early steps and reading only tails. The candidates left are what a "
     "course keeps reachable and what carries its openings.",
     "so the lag does not choose between counting early steps and reading only tails. On reachable ranges "
     f"([§2](#r-{RID})), covering, the comparison of what courses keep reachable at the same offsets, implies inclusion "
     "of what each configuration admits now, so widening what can be reached never ranks a configuration above one "
     "that starts a course and admits now what it does not, and on a determined process it is the strict part of range inclusion of the two "
     "courses; read with a lag it decides one witness's pair, though not every such pair, and C leaves that pair "
     "unranked, so the lag's verdict is a premise beyond C; on a branching witness realized and reachable widening rank "
     "a pair oppositely, so no strict partial order there contains both. The candidate left is what carries a course's "
     "openings.")

# 08 §8: known results beyond the table, after UE9's bullet
edit(CH / '08-METHOD.md', """ Each law is near-definitional; reading them on admitted ranges, where 07's question is posed, is the contribution.

**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control).""",
     f""" Each law is near-definitional; reading them on admitted ranges, where 07's question is posed, is the contribution.
- What a course keeps reachable ([07 §2](07-SIGNIFICANCE.md#r-{RID})) restates known orders. Covering is the lower (Hoare) preorder of the families of course ranges, exactly dominance for every criterion closed upward under inclusion, which reads as the unanimous ordinal form of a preference for flexibility (Kreps 1979) [AI reading]; with options unordered it is the inclusion that opportunity-set rankings share (Jones and Sugden 1982), while Pattanaik and Xu's ranking (1990) counts options. That nothing is added to the whole possible along a course is the irreversibility premise of Arrow and Fisher (1974) and Henry (1974); quasi-option value, which needs learning and deferral, is not captured, since covering is linear-time and cannot see when a commitment is made (van Glabbeek 1990). The possible within a horizon restates Kauffman's adjacent possible (2000) for a prestated space, not the one that cannot be prestated (Longo, Montévil and Kauffman 2012), and that no listed range keeps widening is the pigeonhole of finite recurrence. The lexical order is the two-tier order read on realized claims, then reachable ranges, near Sen's achievement and freedom (1985). Each law is near-definitional or a witness.

**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control).""")

# 08: receipt and counts, every count read from the receipt (as texts_ue9.py)
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
section = (HERE / 'study_ue10.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
assert '{' not in section and 'TODO' not in section, 'a placeholder left in the study text'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan: item 7 and the owners brought to the landing
PLAN = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue-unified-explanation/PLAN.md'
edit(PLAN,
     "What a course keeps reachable and what carries its openings remain the candidates for the second order; UE10 "
     "takes up the first.",
     "UE10, what a course keeps reachable, landed on 27 October: covering, the comparison at the same offsets, implies "
     "inclusion of what each configuration admits now, so widening what can be reached never ranks a configuration "
     "above one that starts a course and admits now what it does not, and on a determined process it is the strict part of range inclusion of "
     "the two courses; read with a lag it decides one witness's pair, though not every such pair, and C leaves that "
     "pair unranked; on a branching witness realized and reachable widening rank a pair oppositely "
     f"([record](../../../../../../theories/becoming/results/records/{RID}.md)). What carries a course's openings "
     "remains the candidate for the second order.")
edit(PLAN, "UE0, UE1, UE2, UE1b, UE4, UE5, UE7 and UE9, and holds UE8 and UE10.",
     "UE0, UE1, UE2, UE1b, UE4, UE5, UE7, UE9 and UE10, and holds UE8.")

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records']
assert 'Becoming.ReachableRanges' not in reg['modules']
reg['records'][RID] = {'region': 'significance', 'base': 'old-base',
                       'note': 'ReachableRanges UE10: what a course keeps reachable (covering implies inclusion now, '
                               'the lagged order on families of courses, nothing added to the whole possible, realized '
                               'and reachable widening opposed, covering as the lower preorder)'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.ReachableRanges'] = {'region': 'significance', 'base': 'old-base',
                                              'note': 'UE10 what a course keeps reachable'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 07 §2 paragraph and reading, eventual widening and UE9 readings pointed, 07 Open narrowed; 08 bullet and '
      'counts:', counts[:90], '...; study section', N, '; UE plan; regions')
