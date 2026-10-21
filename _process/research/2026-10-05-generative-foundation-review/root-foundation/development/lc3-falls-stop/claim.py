import re
ROW = ("| **LC3: one rest theorem over any amounts, exactly where the total stops falling** (§8.1 item 6, closing it: LC1 and LC2 left two "
       "sufficient premises, a least loss and a finite reading, each proved apart). The premise both give, named once: an amount's strict falls stop "
       "(`Amounts.FallsStop`, unrefuted). A family balanced and dissipated on stops changing exactly where its total stops falling (an iff); the "
       "enclosed and covering rest theorems over any amounts take that one premise, and LC2's read forms become corollaries. Amounts with no endless "
       "fall: a least fall with the Archimedean property gives it (whole numbers); dyadic amounts (Archimedean, no least fall) and layered amounts "
       "(a least fall, not Archimedean) each fall without end. The converse: a standing passing between two relata along any amount falling at every "
       "step meets every other premise and never rests (`HalvingPass` generalized, rule 9). Whole-number worlds read as the instance with their own "
       "premises, no reading. In `Becoming.LeastLoss` and `Becoming.InAmounts` (leaves). Literature check first (well-founded orders, Hölder). "
       "| Claude Code session of 20 October (the LC2 session) | claimed 2026-10-21 on `{base}` | worktree `.claude/worktrees/xenodochial-saha-749c76`, "
       "kit `development/lc3-falls-stop/` | LC1, LC2 → §1.3, §8.1 item 6, §9 |")
def edit(text):
    import subprocess
    base = subprocess.run(['git', '-C', '/Users/ren/theories', 'rev-parse', '--short=9', 'main'], capture_output=True, text=True).stdout.strip()
    lines = text.split('\n')
    i = next(k for k, l in enumerate(lines) if l.startswith('| Item | Owner |'))
    j = i + 2
    while lines[j].startswith('| '):
        j += 1
    lines.insert(j, ROW.replace('{base}', base))
    return '\n'.join(lines)
