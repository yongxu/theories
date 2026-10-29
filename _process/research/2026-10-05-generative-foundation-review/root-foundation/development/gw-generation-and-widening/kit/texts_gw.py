#!/usr/bin/env python3
"""GW3-GW5's landing texts: 08's counts at the receipt, study section N in BECOMING-RENEWAL-READING.md, the note's
landing line, the board's landed clause and latest receipt, and GW's row moved from the board to the history file's
landed rows (its links made relative to that file). Each edit is asserted to apply exactly once.
usage (from the checkout root): python3 -B <kit>/texts_gw.py RECEIPT N"""
import re
import sys
from pathlib import Path

RECEIPT, N = sys.argv[1], sys.argv[2]
RF = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation')
G = RF / 'development/gw-generation-and-widening'
KIT = G / 'kit'
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (str(path), old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 08's counts
m08 = Path('theories/becoming/chapters/08-METHOD.md')
edit(m08, 'At core receipt [`20261029T142634.455566Z`](../../../' + PKG + '/becoming-checks/20261029T142634.455566Z/verification.json) (Lean 4.29.1), the closure held 345 modules (3 foundation, 329 core, 13 in the instance and application ring) and 16,756 theorems; the 329 core modules held 15,922 of them; 22,861 declarations were audited;',
     f'At core receipt [`{RECEIPT}`](../../../' + PKG + f'/becoming-checks/{RECEIPT}/verification.json) (Lean 4.29.1), the closure held 345 modules (3 foundation, 329 core, 13 in the instance and application ring) and 16,890 theorems; the 329 core modules held 16,056 of them; 23,025 declarations were audited;')

# the study section
study = (KIT / 'study_gw.txt').read_text(encoding='utf-8')
assert study.startswith('## 448.'), 'section number'
assert N == '448'
study = study.replace('`RECEIPT`', f'`{RECEIPT}`')
study = study.replace('COUNTS', 'Becoming.KeepingWidening (249 theorems in 307 declarations), Becoming.HeldPossible (89 in 118),\n       Becoming.MapInstances (28 in 28) and Becoming.PatternPassing (33 in 46)')
study = study.replace('MEASURE', 'the measures unchanged (measure-grammar-after.json, measure-ec-after.json: 45 of 127 central\n       declarations reach the grammar, 39 rest on no master law); one apart root registered, KindRelay.Fed.not_listed')
assert 'RECEIPT' not in study.replace(RECEIPT, '') and 'COUNTS' not in study and 'MEASURE' not in study
reading = RF / 'BECOMING-RENEWAL-READING.md'
text = reading.read_text(encoding='utf-8')
assert '\n## 447.' in text and '\n## 448.' not in text
reading.write_text(text.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')

# the note's landing line
note = G / 'NOTE.md'
edit(note, '''These are scratch builds, not a receipt; the core checker runs at landing.''',
     f'''These were scratch builds; the core checker passed at landing, at receipt `{RECEIPT}` on the branch merged with main after WRP2 (study §{N}), with the signature audit at WRP2's receipt in [signatures.json](signatures.json) (335 landed statements and 70 bodies unchanged, nothing removed, only the seven proofs above changed) and the measures unchanged.''')

# the board
board = Path('_process/BECOMING-WORKBOARD.md')
text = board.read_text(encoding='utf-8')
head = re.search(r'- \*\*Queue:\*\* GW3–GW5 at the head of the queue \(landing now: .*?\); WRP2 landed', text)
assert head, 'head clause'
landed = (f'- **Queue:** GW3–GW5 landed (§{N}, core receipt `{RECEIPT}`: generation and widening joined one way. In '
          'KeepingWidening, the law of beginnings: along any reading containing carrying on of the supported, what is '
          'supported descends from what was supported or from a beginning between, so keeping opening needs a '
          'beginning after every step, a carrying renewal along passing and within a kind a renewal one grain up, and '
          'not conversely; descends_along_passings and its three exclusions its cases, statements unchanged; where a '
          'list holding what is required is dissipated on, neither keeping widening nor 全生成; the kind relay, closed '
          'and fed, keeping widening within kinds with 全生成 at orders 0 and 1 and 生生 at the kind grain while what it '
          'can form by name only returns, the fed form dissipative with its requirements conserving. In HeldPossible, '
          'the held possible read on the map: 全生成 at (the one, what is held) wherever it keeps widening, not '
          'conversely. Rule-9 generalizations in MapInstances and PatternPassing, statements unchanged (the signature '
          'audit); 249 theorems in 307 declarations in KeepingWidening, every axiom report empty; four records, 07 §2, '
          "02's open item, 01 §6, D1, D65, the glossary and 08's counts; one apart root registered; the measures "
          'unchanged; one independent review and its re-check, every finding taken; row in the history file); WRP2 landed')
text = text.replace(head.group(0), landed)
old_latest = "the latest core receipt is WRP2's `20261029T142634.455566Z` (29 October 2026)"
assert text.count(old_latest) == 1
text = text.replace(old_latest, f"the latest core receipt is GW3–GW5's `{RECEIPT}` (29 October 2026)")
rows = [l for l in text.split('\n') if l.startswith('| **GW: generation and widening')]
assert len(rows) == 1
row = rows[0]
text = text.replace(row + '\n', '')
board.write_text(text, encoding='utf-8')

# the history file's landed rows: GW's row after WRP2's, links relative to the history file
hist = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
cells = row.split(' | ')
state = (f'landed 2026-10-29 at core receipt `{RECEIPT}`, study §{N}: GW3, GW3b, GW4 and GW5 (KeepingWidening 249 '
         'theorems in 307 declarations, HeldPossible 89 in 118, MapInstances 28 in 28, PatternPassing 33 in 46, every '
         'axiom report empty); the signature audit showing only additions and seven proofs derived by rule 9; '
         'REVIEW-GW-LEAN and RECHECK-GW-LEAN, every finding taken; GW1 and GW2, the coverage and the split on the '
         "root, studied and not claimed (`Becoming.GrammarMap`'s owner to be asked first); at the next full rebuild "
         '`total_eq_of_supports` moves beside `total_le_of_support` in `Becoming.Dissipation`')
assert len(cells) == 5, len(cells)
cells[2] = state
new_row = ' | '.join(cells)
new_row = re.sub(r'\]\((research/)', r'](../../\1', new_row)
new_row = re.sub(r'\]\(\.\./(theories|sources)/', r'](../../../\1/', new_row)
htext = hist.read_text(encoding='utf-8')
wrp2 = [l for l in htext.split('\n') if l.startswith('| **WRP2: processes represented')]
assert len(wrp2) == 1
htext = htext.replace(wrp2[0] + '\n', wrp2[0] + '\n' + new_row + '\n')
hist.write_text(htext, encoding='utf-8')
print('texts written')
