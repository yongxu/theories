#!/usr/bin/env python3
"""FV's edits, by script on the landing tree (every file is shared): where the free-energy principle stands in 08 §8's
verdict, in the principle's page's words, S-02's quotation of the verdict following it, and READING-BUDGETS' sciences
whole (measured on T2S's main with these edits: 18,958 words, 145.9 to 189.7 minutes).

The verdict split contained frameworks into those the theory reaches farther than and those with which it is level or
states less; read after the principle's five third parts it placed the principle wholly on the farther side, though the
page says the theory states nothing yet of densities, continuous time or deep models. Each old text must occur exactly
once; nothing already applied is applied again.
usage (from the checkout root): python3 -B edit_fv.py"""
import sys
from pathlib import Path

M08 = Path('theories/becoming/chapters/08-METHOD.md')
SCI = Path('theories/becoming/review/SCIENCES.md')
FEPP = Path('theories/becoming/FREE-ENERGY-PRINCIPLE.md')
RB = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/READING-BUDGETS.md')

FEW = ("So the theory reaches farther than the few contained frameworks that lack conservation, renewal over time or a "
       "threshold, by joining them to its own premises and laws")
REST = ("with the rest (thermodynamics, recurrence, control, constructor theory, causal sets among them) it is level or "
        "states less, and it does not yet reach farther than the sciences taken together")
FEP_TAIL = ("the theory states the central quantities on its own models; it reaches farther than the principle alone in "
            "what it forbids, the five statements above, and states less than it where it states nothing yet, in "
            "densities, continuous time and deep models among others")
FEP = ("Of the free-energy principle, whose third parts join it to a shared renewal and to laws of symmetry and "
       f"identification, {FEP_TAIL}")
REST_CAP = 'W' + REST[1:]

EDITS = {
    M08: [
        (f"{FEW}; {REST} (",
         f"{FEW}. {FEP} ([the page](../FREE-ENERGY-PRINCIPLE.md)). {REST_CAP} ("),
    ],
    SCI: [
        (f'The verdict: Quote [theories/becoming/chapters/08-METHOD.md]: "{FEW}; {REST}"',
         f'The verdict: Quote [theories/becoming/chapters/08-METHOD.md]: "{FEW}." Of the principle, Quote '
         f'[theories/becoming/chapters/08-METHOD.md]: "{FEP_TAIL}" ([S-17](#s-17)). Quote '
         f'[theories/becoming/chapters/08-METHOD.md]: "{REST_CAP}"'),
    ],
    FEPP: [
        ("generalized coordinates, the precision of beliefs, the softmax over policies, hierarchical",
         "generalized coordinates, the precision of beliefs, the softmax over policies beyond the tied order it keeps "
         "(§3), hierarchical"),
        ("precision and its dynamics; the softmax over policies; hierarchical",
         "precision and its dynamics; the softmax over policies, beyond the tied order it keeps (§3); hierarchical"),
    ],
    RB: [
        ("sciences 146 to 189 since T2S of 4 November.", "sciences 146 to 190 since FV of 4 November."),
    ],
}


def main():
    for path, pairs in EDITS.items():
        s = path.read_text(encoding='utf-8')
        for old, new in pairs:
            assert s.count(old) == 1, (str(path), s.count(old), old[:100])
            assert new not in s, (str(path), 'already applied', new[:100])
            s = s.replace(old, new, 1)
        path.write_text(s, encoding='utf-8')
        print('edit:', path)


if __name__ == '__main__':
    if len(sys.argv) != 1:
        sys.exit(__doc__)
    main()
