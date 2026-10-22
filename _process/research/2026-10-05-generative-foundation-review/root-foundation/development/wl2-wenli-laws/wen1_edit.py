"""WL2: the one edit to 一·二十一 (book id WEN-1), whose 條 is added after the rounds by work/moves-after-rounds.json, so
the edit is made in that file's body, textually (the rest of the file byte for byte).
usage (from the checkout root): python3 -B wen1_edit.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/work/moves-after-rounds.json')
t = F.read_text(encoding='utf-8')
old = '衢是二行之文于某步分开（⟦九·二十八⟧）。'
new = '衢是二行之文于某步分开（⟦九·二十八⟧）；缘感无异，感读作值时是待者自身之文之往同（⟦十一·九⟧）。'
if new not in t:
    assert t.count(old) == 1
    t = t.replace(old, new)
    add = [m for m in json.loads(t) if m.get('op') == 'add' and m['id'] == 'WEN-1']
    assert len(add) == 1 and new in add[0]['body']
    F.write_text(t, encoding='utf-8')
print('WEN-1 edited')
