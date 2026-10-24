#!/usr/bin/env python3
"""IV3b: need on the base and the joined ending in the texts. THE-STEP-OF-INVARIANCE (a bullet in §4.4, the ending
bullet of §5 restated, rows in §8); the study section; D64 item 6; the package README row (EN, ZH). The root module's
doc changes with the Lean, before the checker runs (integrate_b.py).
usage (from the checkout root): python3 -B apply_text_b.py STUDY_SECTION RECEIPT"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
N, RECEIPT = int(sys.argv[1]), sys.argv[2]
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = ROOT / (RF + 'BECOMING-RENEWAL-READING.md')
CHOICES = ROOT / (RF + 'DELEGATED-CHOICES.md')
STEP = ROOT / 'theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
PENDING = {}


def text(path):
    return PENDING.get(path, path.read_text(encoding='utf-8'))


def insert_after(path, prefix, block):
    lines = text(path).split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith(prefix)]
    assert len(at) == 1, (path.name, prefix[:60], len(at))
    PENDING[path] = '\n'.join(lines[:at[0] + 1] + block + lines[at[0] + 1:])


def replace_once(path, old, new):
    s = text(path)
    assert s.count(old) == 1, (path.name, old[:60], s.count(old))
    PENDING[path] = s.replace(old, new)


# ---- THE-STEP-OF-INVARIANCE ------------------------------------------------------------------------------
assert '**Need on the base.**' not in text(STEP)
insert_after(STEP, '- **Copies.** Drawn along need, the presupposition reaches exactly what the continuation needs', [
    '- **Need on the base.** Read the possible courses of a family of conditions as the flows with their webs that '
    'balance, in which only active formations give and only a class gives to the family (`Flow.FedOnlyBy`). A '
    'formation drawing past the family\'s stock across a stretch has some member of the class giving to the family '
    'within it (`Flow.needsSome_of_drawsPast`), and it needs a given feeder\'s giving exactly where that feeder is the '
    'only one able to feed the family alone (`Flow.needs_giver_iff_only`; on `Feeders`, two flows of one condition '
    'each fed by one copy, the user needs some feeder\'s giving and neither feeder\'s, `Feeders.two_feeders`). What a '
    'consumer needs of a feeder is its giving, not its continuation, so need here has two readings, the consumer\'s '
    'continuation and the feeder\'s part (`NeedsPart`, `needsPart_iff_only`); IV3\'s need is the case of one reading '
    'for both.',
])
replace_once(STEP,
             'The two are joined by argument, not by one theorem: where every formation depends on one coupled family of '
             'conditions, its ending is ranked below by every standpoint\'s self-concern, with no C.',
             'Joined in one theorem: where every member of every generation from the excess on depends on the coupled '
             'family, no later generation has a member, and the generations\' course is ranked below, by every '
             'standpoint\'s self-concern, every course that agrees with it up to the ending and adds to that '
             'standpoint\'s continuation, with no C (`Flow.coupled_ending_ranked_below`).')
insert_after(STEP, '| The whole-world case, and coupled groups ending together |', [
    '| Need over any courses with two readings; a member needed exactly where it is the only one | `NeedsPart`, '
    '`NeedsSomePart`, `PartAlone`, `needsPart_iff_only` | `Becoming.Weightings` | landed |',
    '| On the base, drawing past a family\'s stock needs some feeder\'s giving, and a feeder\'s exactly where it is the '
    'only one | `Flow.FedOnlyBy`, `Flow.DrawsPast`, `Flow.GivesWithin`, `Flow.needsSome_of_drawsPast`, '
    '`Flow.needs_giver_iff_only`, `Feeders.two_feeders` | `Becoming.Weightings` | landed |',
    '| The coupled ending ranked below by self-concern, in one theorem | `Flow.coupled_ending_ranked_below` | '
    '`Becoming.Weightings` | landed |',
])

# ---- the study ----------------------------------------------------------------------------------------------
st = text(STUDY)
assert '(IV3b)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert N == last + 1, ('section number', N, last)
R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
sec = (HERE / 'study_iv3b.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', RECEIPT)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
assert '{N}' not in sec and 'THEOREMS' not in sec and 'DECLS' not in sec
PENDING[STUDY] = st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n'

# ---- D64 ---------------------------------------------------------------------------------------------------
insert_after(CHOICES, '5. **The planetary case.**', [
    '6. **Need on the base.** The possible courses of a family of conditions are read as the flows with their webs that '
    'balance, in which only active formations give and only a class gives to the family (`Flow.FedOnlyBy`); a '
    'consumer\'s continuation as drawing past the family\'s stock across a stretch (`Flow.DrawsPast`); a feeder\'s part '
    'as giving to the family within the stretch (`Flow.GivesWithin`). That each feeder can feed the family alone '
    f'(`PartAlone`) is supplied, not derived from a web (study section {N}, IV3b).',
])

# ---- the package README row (EN, ZH) ------------------------------------------------------------------------
replace_once(PKG / 'README.md', "; the readings are the AI's (D59, D60, D64) |",
             '; need over any courses with two readings, a member needed exactly where it is the only one '
             '(`needsPart_iff_only`); on the base a formation drawing past its family\'s stock needs some feeder\'s '
             'giving, and a feeder\'s exactly where it is the only one (`Flow.needsSome_of_drawsPast`, '
             '`Flow.needs_giver_iff_only`, `Feeders.two_feeders`); the coupled ending ranked below by self-concern in '
             'one theorem (`Flow.coupled_ending_ranked_below`); the readings are the AI\'s (D59, D60, D64) |')
replace_once(PKG / 'README.zh.md', '；读法是 AI 的（D59、D60、D64） |',
             '；对任意进程与两种读法的“所需”，某成员恰在其为唯一者时被需要（`needsPart_iff_only`）；在基底上，汲取超出其条件族'
             '存量的构成需要某个供给者的给予，恰在某供给者为唯一者时需要它的给予（`Flow.needsSome_of_drawsPast`、'
             '`Flow.needs_giver_iff_only`、`Feeders.two_feeders`）；耦合的终结由自我关切排在下面，合为一个定理'
             '（`Flow.coupled_ending_ranked_below`）；读法是 AI 的（D59、D60、D64） |')

for path, s in PENDING.items():
    path.write_text(s, encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
