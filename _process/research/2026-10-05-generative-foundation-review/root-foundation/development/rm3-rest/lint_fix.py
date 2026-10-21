#!/usr/bin/env python3
"""RM3 lint fixes after make_record.py (python3 -B lint_fix.py from the checkout root): the new record's statement leads
with what the result does, and the last-change record's shortened Chinese boundary. make_record.py carries the same
text for a rerun."""
import json
from pathlib import Path

RECORDS = Path.cwd() / 'theories/becoming/results/records'
STATEMENT = {
    'en': 'Every run of an adjustment of giving rising with what is left and with the recent giving, within a band up to '
          'hi, comes to rest within 3 hi + 3 steps, at the regime\'s point or below the draw; whether it changes again is '
          'decided at each step.',
    'zh': '所给之调整随所剩与近来所给而升时，至 hi 的带内每个运行至多 3 hi + 3 步后静止，静于体制之点或汲取之下；是否再变每步可判定。'}
L1_ZH = '过程之运行在没有有限全知原理时的安定：变化次数有界，最后变化之步不是；定律的运行由其变化的有界标记判定（LastChange.still_within）。'
p = RECORDS / 'where-a-run-of-a-regime-comes-to-rest.json'
d = json.loads(p.read_text())
d['statement'] = STATEMENT
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
p = RECORDS / 'the-last-change-of-a-run.json'
d = json.loads(p.read_text())
hits = [x for x in d['does_not_show'] if x['en'].startswith('Settling without LPO for a process')]
assert len(hits) == 1
hits[0]['zh'] = L1_ZH
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('fixed')
