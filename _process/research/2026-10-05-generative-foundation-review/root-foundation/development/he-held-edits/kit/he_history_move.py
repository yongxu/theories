#!/usr/bin/env python3
"""HE (item 3): Becoming.KeptOnward, whose one declaration kept_onward now sits beside «线则所闭» in GrammarLaws
under its name, goes to the Lean history folder with its bytes as on main, by `research.py move` (plan
he-history.tsv; batch HE-history), as R32's and R33's history moves did: the pin on the package's Lean files is
lifted for this move only and restored byte for byte after it. Run after he_lean.py, before the checker.
usage (from the checkout root): python3 -B <kit>/he_history_move.py [--apply]"""
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
HIST = 'experiments/integrated-correction/general-framework/generative-basis/lean/history/becoming/Becoming'
PLAN = HERE / 'he-history.tsv'
path = f'{PKG}/Becoming/KeptOnward.lean'
main_bytes = subprocess.run(['git', 'show', f'main:{path}'], capture_output=True, check=True, cwd=ROOT).stdout
assert (ROOT / path).read_bytes() == main_bytes, 'KeptOnward.lean is not as on main'
assert not (ROOT / HIST / 'KeptOnward.lean').exists()
row = PLAN.read_text(encoding='utf-8').strip().split('\t')
assert row[:2] == [path, f'{HIST}/KeptOnward.lean'], row[:2]
config = ROOT / '_process/research-config.json'
pinned = config.read_bytes()
pattern = f'    "{PKG}/Becoming/**",\n'
assert pinned.decode().count(pattern) == 1
config.write_text(pinned.decode().replace(pattern, '', 1))
try:
    subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'move', '--plan', str(PLAN), *sys.argv[1:],
                    '--batch', 'HE-history', '--summary'], check=True, cwd=ROOT)
finally:
    config.write_bytes(pinned)
print('pin restored')
