#!/usr/bin/env python3
"""EL6: Becoming.LineDegeneration, whose laws now sit in GrammarMap, MapInstances and KeepingWidening, goes to the
Lean history folder with its bytes as on main, by `research.py move` (plan el6-history.tsv, batch EL6-history), as
HE's history move did (he_history_move.py): the pin on the package's Lean files is lifted for this move only and
restored byte for byte after it, also on a dry run. After an applied move, `research.py move --check` verifies the
receipt: the new path holds the recorded bytes and no live reference names the old one.
usage (from the checkout root): python3 -B <kit>/el6_history_move.py [--apply]"""
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
HIST = 'experiments/integrated-correction/general-framework/generative-basis/lean/history/becoming/Becoming'
PLAN = HERE / 'el6-history.tsv'
path = f'{PKG}/Becoming/LineDegeneration.lean'
main_bytes = subprocess.run(['git', 'show', f'main:{path}'], capture_output=True, check=True, cwd=ROOT).stdout
assert (ROOT / path).read_bytes() == main_bytes, 'LineDegeneration.lean is not as on main'
assert not (ROOT / HIST / 'LineDegeneration.lean').exists()
PLAN.write_text(f'{path}\t{HIST}/LineDegeneration.lean\tEL6 (1 November 2026): its laws placed in their owners\' '
                'modules, each on its owner\'s yes (the grammar part in Becoming.GrammarMap, the kind instance in '
                'Becoming.KeepingWidening, the rest in Becoming.MapInstances, Web.Restated dropped), so the leaf is '
                'retired; bytes as on main\n', encoding='utf-8')
config = ROOT / '_process/research-config.json'
pinned = config.read_bytes()
pattern = f'    "{PKG}/Becoming/**",\n'
assert pinned.decode().count(pattern) == 1
config.write_text(pinned.decode().replace(pattern, '', 1), encoding='utf-8')
try:
    subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'move', '--plan', str(PLAN), *sys.argv[1:],
                    '--batch', 'EL6-history', '--summary'], check=True, cwd=ROOT)
finally:
    config.write_bytes(pinned)
print('pin restored')
if '--apply' in sys.argv[1:]:
    subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'move', '--check',
                    '_process/architecture/moves/EL6-history.json'], check=True, cwd=ROOT)
    print('move receipt checked')
