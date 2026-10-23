#!/usr/bin/env python3
"""IV3c: which feeders can feed a family alone, read off a web, in the texts. THE-STEP-OF-INVARIANCE (a bullet in
§4.4, rows in §8); the study section; D64 item 7; the package README row (EN, ZH). The root module's doc changes with
the Lean, before the checker runs (integrate_c.py).
usage (from the checkout root): python3 -B apply_text_c.py STUDY_SECTION RECEIPT"""
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
assert '**Which feeders can feed alone, read off a web.**' not in text(STEP)
insert_after(STEP, '- **Need on the base.** Read the possible courses of a family of conditions', [
    '- **Which feeders can feed alone, read off a web.** Fix the web and read the possible flows off it '
    '(`Flow.FedOnlyOn`): the family\'s levels and who is active when are given, and a flow only says who gives what. '
    'A step calls for giving where some condition of the family rises or none falls (`Web.CallsForGiving`); '
    'elsewhere a consumer can take the falls with nothing given. Every member active at every step calling for '
    'giving can feed the family alone (`Flow.partAlone_on`), so the copies law holds with nothing supplied '
    '(`Flow.needs_giver_iff_only_on`), and exactly: a consumer drawing past the stock needs a member\'s giving where, '
    'at some step calling for giving, that member is the only one active (`Flow.needs_giver_iff_alone`). Two copies '
    'active throughout are not needed (`Feeders.two_feeders_on`); two active in turn are both needed '
    '(`Shifts.needs_both`). What has no second copy at a step that calls for giving is needed.',
])
insert_after(STEP, '| The coupled ending ranked below by self-concern, in one theorem |', [
    '| Over the flows read off a web, drawing past a family\'s stock needs some feeder\'s giving; where giving is '
    'called for, it is forced | `Flow.FedOnlyOn`, `Flow.needsSome_on`, `Web.CallsForGiving`, '
    '`Flow.given_pos_of_calls` | `Becoming.Weightings` | landed |',
    '| A member active at every step calling for giving can feed the family alone; the copies law over a web | '
    '`Flow.drawnAcross`, `Flow.partAlone_on`, `Flow.needs_giver_iff_only_on`, `Feeders.two_feeders_on` | '
    '`Becoming.Weightings` | landed |',
    '| A feeder is needed exactly where, at some step calling for giving, it is the only one active | '
    '`Flow.needs_giver_iff_alone`, `Flow.firstActiveOther`, `Shifts.needs_both` | `Becoming.Weightings` | landed |',
])

# ---- the study ----------------------------------------------------------------------------------------------
st = text(STUDY)
assert '(IV3c)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert N == last + 1, ('section number', N, last)
R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
sec = (HERE / 'study_iv3c.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', RECEIPT)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
assert '{N}' not in sec and 'THEOREMS' not in sec and 'DECLS' not in sec
PENDING[STUDY] = st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n'

# ---- D64 ---------------------------------------------------------------------------------------------------
insert_after(CHOICES, '6. **Need on the base.**', [
    '7. **The flows read off a web.** With the web fixed, the possible flows are read as those that balance on the '
    'family within the stretch, in which only active formations give and only the class gives to the family '
    '(`Flow.FedOnlyOn`); a step that calls for giving as one where some condition of the family rises or none falls '
    '(`Web.CallsForGiving`); being able to feed the family alone as being active at every step calling for giving '
    f'(`Flow.partAlone_on`); and copies as a matter of the steps, a feeder needed where it alone is active at a step '
    f'calling for giving (`Flow.needs_giver_iff_alone`; study section {N}, IV3c).',
])

# ---- the package README row (EN, ZH) ------------------------------------------------------------------------
replace_once(PKG / 'README.md', "; the readings are the AI's (D59, D60, D64) |",
             '; read off a web, a feeder can feed a family alone where it is active at every step calling for giving, '
             'and a consumer needs a feeder\'s giving exactly where, at some step calling for giving, it is the only one '
             'active (`Web.CallsForGiving`, `Flow.partAlone_on`, `Flow.needs_giver_iff_alone`, `Shifts.needs_both`); '
             'the readings are the AI\'s (D59, D60, D64) |')
replace_once(PKG / 'README.zh.md', '；读法是 AI 的（D59、D60、D64） |',
             '；从依存网读出，供给者在每个需要给予的步上都活跃时能单独供给该族，而消耗者恰在某个需要给予的步上某供给者是唯一活跃者时'
             '需要它的给予（`Web.CallsForGiving`、`Flow.partAlone_on`、`Flow.needs_giver_iff_alone`、`Shifts.needs_both`）；'
             '读法是 AI 的（D59、D60、D64） |')

for path, s in PENDING.items():
    path.write_text(s, encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
