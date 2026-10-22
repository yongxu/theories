"""Write theories/becoming/chapters/WENLI-AND-BECOMING.md (board item WL) from its three parts: the head
(head.fragment), the centre, the epistemology of 文 (centre.fragment: the checked section of agents/wl/section-check.json
with 篇一 renumbered after 文与文同 and its proposals written as the changes made), and the rest (chapter-rest.fragment).
The tables between ZH-TABLE markers are then filled by build_tables.py.

    python3 -I wenli/make_chapter.py && python3 -I build_tables.py
"""
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[6]
OUT = ROOT / 'theories/becoming/chapters/WENLI-AND-BECOMING.md'
parts = [(HERE / f).read_text(encoding='utf-8').strip('\n') for f in ('head.fragment', 'centre.fragment', 'chapter-rest.fragment')]
OUT.write_text('\n\n'.join(parts) + '\n', encoding='utf-8')
print('written', OUT.relative_to(ROOT), sum(len(p) for p in parts), 'characters')
