#!/usr/bin/env python3
"""UE20 texts: the reviewed draft becomes the live page theories/becoming/FREE-ENERGY-PRINCIPLE.md (moved, so no copy
stays beside it; the draft was never committed); a line in 03 §6 after the free-energy laws and a sentence in 08 §8's bullet on UE1's record point to
it; FEP-INTEGRATION's item 5 marked landed and its "done when" stated met; the UE plan's owners; the study section.
No record and no Lean: the page adds no result. Every link the page carries is checked to resolve. Every edit is
asserted to apply exactly once. Runs after UE16 to UE19 have landed.
usage (from the checkout root of the landing worktree, the study folder copied in): python3 -B <kit>/texts_ue20.py N"""
import datetime
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
N = int(sys.argv[1])
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
DRAFT = f'{RF}/development/ue20-fep-in-the-theory/FREE-ENERGY-PRINCIPLE.draft.txt'
PAGE = 'theories/becoming/FREE-ENERGY-PRINCIPLE.md'
CH = ROOT / 'theories/becoming/chapters'
STUDY = ROOT / RF / 'BECOMING-RENEWAL-READING.md'
TODAY = datetime.date.today()
DATE = f'{TODAY.day} {TODAY:%B} {TODAY.year}'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# the page: the reviewed draft, moved into place
assert (ROOT / DRAFT).exists() and not (ROOT / PAGE).exists()
(ROOT / DRAFT).rename(ROOT / PAGE)
page = (ROOT / PAGE).read_text(encoding='utf-8')
for target in re.findall(r'\]\(([^)#\s]+)(?:#[^)\s]*)?\)', page):
    assert (ROOT / 'theories/becoming' / target).resolve().exists(), target
for target, anchor in re.findall(r'\]\((chapters/[^)#\s]+)#([^)\s]+)\)', page):
    assert f'id="{anchor}"' in (ROOT / 'theories/becoming' / target).read_text(encoding='utf-8'), (target, anchor)

# 03 §6: after the free-energy laws, before the split that makes sense
C03 = CH / '03-KNOWING.md'
SPLIT = '<a id="r-the-split-that-makes-sense"></a>'
edit(C03, SPLIT, "**The free-energy principle, claim by claim.** The laws above, [§1's blanket]"
     "(#r-the-markov-blanket-as-a-coupling-structure) and the third parts in [05](05-COLLECTIVES.md) are gathered, for "
     "readers from the principle's literature, on [one page](../FREE-ENERGY-PRINCIPLE.md), with what the principle "
     "states that the theory cannot yet.\n\n" + SPLIT)

# 08 §8: the bullet on UE1's record
C08 = CH / '08-METHOD.md'
OLD08 = ("[05 §1's](05-COLLECTIVES.md#r-risk-minimization-on-a-shared-renewal) and "
         "[03 §6's](03-KNOWING.md#r-what-seeking-cannot-separate).")
edit(C08, OLD08, OLD08 + " [The principle in the theory](../FREE-ENERGY-PRINCIPLE.md) places each of its quantities "
     "and claims.")

# FEP-INTEGRATION: item 5 landed, and "done when" met
UE = ROOT / RF / 'development/ue-unified-explanation'
LIVE = '../../../../../../theories/becoming/FREE-ENERGY-PRINCIPLE.md'
edit(UE / 'FEP-INTEGRATION.md', "5. **UE20. The principle in the theory, on one page.**",
     f"5. **UE20. The principle in the theory, on one page** (landed {TODAY.day} {TODAY:%B} as [the page]({LIVE}), "
     f"study section {N}).")
DONE = ("- UE1's record reads as a containment with third parts, each third part a landed theorem forbidding a statement "
        "in the principle's literature, and the page of UE20 says, claim by claim, where the theory explains more, where "
        "the two agree, and where the principle says more.\n")
edit(UE / 'FEP-INTEGRATION.md', DONE, DONE + f"\nAll three hold since UE20 landed ({DATE}, study section {N}): UE16 "
     f"to UE20 each landed after an independent review and a re-check; every quantity and claim in §1 has a record "
     f"(conditioning-by-restriction, free-energy-bounds-surprisal, expected-free-energy-and-its-terms, "
     f"the-markov-blanket-as-a-coupling-structure, what-the-existence-claim-forbids); and [the page]({LIVE}) places "
     f"each claim, with the four third parts and what the principle states that the theory cannot yet.\n")

# the UE plan's owners
plan = (UE / 'PLAN.md').read_text(encoding='utf-8')
owners = re.search(r'(UE16[^.]*?) and (UE19), and holds UE8\.', plan)
assert owners and 'UE20' not in owners.group(0), 'the owners line'
(UE / 'PLAN.md').write_text(plan.replace(owners.group(0), f'{owners.group(1)}, {owners.group(2)} and UE20, and holds UE8.'),
                            encoding='utf-8')

# the study section
section = (HERE / 'study_ue20.txt').read_text(encoding='utf-8').replace('{N}', str(N))
assert '{' not in section and 'TODO' not in section, 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')
print('texts: the page in place; 03 §6 line; 08 §8 sentence; FEP-INTEGRATION item 5 and done-when; UE plan owners; '
      'study section', N)
