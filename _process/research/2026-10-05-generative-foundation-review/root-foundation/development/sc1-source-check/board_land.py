"""SC1 landing: the board row to the history file, closed, and a queue note (run from the repository root)."""
B = '_process/BECOMING-WORKBOARD.md'
H = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
t = open(B, encoding='utf-8').read().split('\n')
i = next(k for k, l in enumerate(t) if l.startswith('| **SC1'))
row = t.pop(i)
cells = row.split(' | ')
cells[2] = ('landed 23 October 2026: no author-specific deficit (detection interaction +0.017, 95% CI [−0.050, +0.083]); '
            'the coders differ as coders (GPT lists more excess in faithful texts, +0.158 [+0.083, +0.242], and detects fewer '
            'plants, −0.042 [−0.075, −0.008]); study §376, record fidelity-coders-on-own-and-other-texts; 8 Claude subagents, 14 cx runs')
row = ' | '.join(cells)
q = next(k for k, l in enumerate(t) if l.startswith('- **Queue:** '))
t[q] = t[q].replace('- **Queue:** ', '- **Queue:** SC1 landed (coders on their own and the other\'s texts: no author-specific deficit in English, '
                    'the fidelity coders differ by coder; no Lean; study §376, record fidelity-coders-on-own-and-other-texts; row in the '
                    'history file); ', 1)
open(B, 'w', encoding='utf-8').write('\n'.join(t))
h = open(H, encoding='utf-8').read()
if not h.endswith('\n'):
    h += '\n'
open(H, 'w', encoding='utf-8').write(h + row + '\n')
print('moved')
