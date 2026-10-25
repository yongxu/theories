#!/usr/bin/env python3
"""OC3: "goes on past" an end read as "continues past", the sense of `«过亡而续»`. The glossary keeps "goes on" for 延,
going on along some branch without end; the theorem shows only that, under a coarser class, a line continues past a
member's end. In the IV3 line: D64's reading in 07 §4.3, P-15's quote of it, the record need-and-feeding-read-with-time
(what it does not show, its related entry, a history line) and D64 in DELEGATED-CHOICES. With `--pf`, on the PF line
owner's answer: the title of 07 §4.6's step 2 and P-20's step 2. With `--lean`, the first sentence of
`Becoming.GrammarPath`'s module doc, a Lean comment (a checker run follows). Each edit is asserted to apply once; the
study section N is appended.
usage (from the checkout root): python3 -B <kit>/texts_oc3.py N [--pf] [--lean]"""
import json
import sys
import textwrap
from pathlib import Path

ROOT = Path.cwd()
N = int(sys.argv[1])
PF = '--pf' in sys.argv[2:]
LEAN = '--lean' in sys.argv[2:]
RF = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation'
CH7 = ROOT / 'theories/becoming/chapters/07-SIGNIFICANCE.md'
PHIL = ROOT / 'theories/becoming/review/PHILOSOPHY.md'
DC = RF / 'DELEGATED-CHOICES.md'
STUDY = RF / 'BECOMING-RENEWAL-READING.md'
REC = ROOT / 'theories/becoming/results/records/need-and-feeding-read-with-time.json'
GP = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarPath.lean'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, text.count(old), old[:80])
    path.write_text(text.replace(old, new), encoding='utf-8')


# (a) D64's reading in 07 §4.3, and (b) P-15's quote of it
edit(CH7, "is reached by a line under a class that goes on past one's end ([§4.5](#r-reach-past-ones-own-end), [§4.6](#future-path))",
     "is reached by a line under a class that continues past one's end ([§4.5](#r-reach-past-ones-own-end), [§4.6](#future-path))")
edit(PHIL, """"What comes after every present center is reached by a line under a class that goes on past one's end" (P-18)""",
     """"What comes after every present center is reached by a line under a class that continues past one's end" (P-18)""")

# (c) the record need-and-feeding-read-with-time: the English only, the Chinese already reads 过其终而续
text = REC.read_text(encoding='utf-8')
record = json.loads(text)
OLD, NEW = 'a line under a class that goes on past it', 'a line under a class that continues past it'
fields = [record['does_not_show'][0], record['related'][1]['detail']]
for field in fields:
    assert field['en'].count(OLD) == 1, field['en']
    field['en'] = field['en'].replace(OLD, NEW)
assert record['related'][1]['id'] == 'reach-past-ones-own-end'
assert OLD not in json.dumps(record, ensure_ascii=False)
record['history'].append({
    'en': f'26 October 2026: "goes on past" (延 in the glossary, going on without end) replaced by "continues past", the '
          f'sense of «过亡而续», in what it does not show and its related entry (OC3); content unchanged; study section {N}.',
    'zh': f'2026年10月26日：其所不示与相关项之英文 goes on past（词表中为延，无尽而行）改为 continues past，即«过亡而续»之义'
          f'（OC3）；内容未变；研究第 {N} 节。'})
indent = 2 if text.startswith('{\n  "') else 1
REC.write_text(json.dumps(record, ensure_ascii=False, indent=indent) + '\n', encoding='utf-8')

# (d) D64 in DELEGATED-CHOICES
edit(DC, "is reached by a line under a class that goes on past it (07 §4.5)",
     "is reached by a line under a class that continues past it (07 §4.5)")

if PF:
    # (e) the title of 07 §4.6's step 2, and (f) P-20's step 2
    edit(CH7, "2. *A line goes on past a member's end.* Under a coarser class",
         "2. *A line continues past a member's end.* Under a coarser class")
    edit(PHIL, "2. A line goes on past a member's end under a coarser class (`«过亡而续»`, a root theorem).",
         "2. A line continues past a member's end under a coarser class (`«过亡而续»`, a root theorem).")
if LEAN:
    # (g) the first sentence of GrammarPath's module doc
    edit(GP, "Chapter 7 §4.6 joins two routes into one path to the future: a line goes on past a member's end",
         "Chapter 7 §4.6 joins two routes into one path to the future: a line continues past a member's end")

# the study section
pf_places = ("; the title of 07 §4.6's step 2 and P-20's step 2, on the PF line owner's answer" if PF else "")
lean_place = ("; the first sentence of `Becoming.GrammarPath`'s module doc" if LEAN else "")
delta = textwrap.fill('Delta: "goes on past" an end replaced by "continues past": D64\'s reading in 07 §4.3 and P-15\'s quote of '
                      'it; the record need-and-feeding-read-with-time (what it does not show, its related entry, a history '
                      f'line); D64 in DELEGATED-CHOICES{pf_places}{lean_place}. No statement changes.',
                      width=118, subsequent_indent=' ' * 7, break_on_hyphens=False)
output = textwrap.fill(f'Output → input: 07 §4.3{" and §4.6" if PF else ""}; PHILOSOPHY.md P-15{" and P-20" if PF else ""}; '
                       f'the record need-and-feeding-read-with-time; D64{"; the module doc of Becoming.GrammarPath" if LEAN else ""}.',
                       width=118, subsequent_indent=' ' * 7, break_on_hyphens=False)
left_sentence = ("\nStill to change, in the PF line: the title of 07 §4.6's step 2 and P-20's step 2; they wait for its "
                 "owner's answer on the board." if not PF else "")
if not LEAN:
    left_sentence += ("\nThe first sentence of `Becoming.GrammarPath`'s module doc keeps the phrase until the next landing that "
                      "rebuilds the module, which applies the same change: the PF line's owner chose this, since a comment "
                      "alone is not worth a checker run and the re-binding of the records bound to the module.")
study = f"""## {N}. "Goes on past" an end read as "continues past" (OC3)

The glossary gives "goes on" one sense, 延: going on along some branch, without end ([02 §1](../../../../theories/becoming/chapters/02-MAP.md#branches)). `«过亡而续»` shows less. Under a coarser class, what continues an occurrence at which a finer line ends is reached, so the line continues past that end; in a finite net it still ends, later. Read with the glossary, "goes on past one's end" claims an endless continuation the theorem does not give. OC2 found the phrase in the live texts (§411) and left it for this pass.

```text
Result(s): none new; wording only.
{delta}
Supplied premises / correspondence: none.
Evidence: the glossary's "goes on" (02 §1) and the statement of «过亡而续».
Boundary: frozen texts keep the phrase (earlier sections of this study, PW's note, PF's philosophy rounds, the kits and
       history). "Goes on" stays where it means 延: "goes on without end", and "can go on through new members" (07 §4.5).
{output}
```
{left_sentence}
""".replace('\n\n\n', '\n\n')
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t and '(OC3)' not in t
STUDY.write_text(t.rstrip('\n') + '\n\n' + study.strip('\n') + '\n', encoding='utf-8')
print('OC3 texts: (a)–(d)' + (', (e)–(f)' if PF else '') + (', (g)' if LEAN else '') + f'; study {N}')
