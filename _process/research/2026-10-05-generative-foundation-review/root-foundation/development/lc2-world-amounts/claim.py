ROW = ('| **LC2: the rest theorem over any amounts, levels read finitely** (§8.1 item 6, the other half LC1 left open). '
       'A world read in amounts: levels, takes and gives in any `Amounts`, activity as in `World`; balance, dissipation '
       '(whatever gives back all it takes takes nothing), embodiment and covering stated there; the rest theorem '
       '(`World.rests_unrefuted_covering`, finite case `World.rests_unrefuted`, the enclosed form where the census is '
       'read finitely) over any amounts, from the total standing read off configurations a list holds, as an instance '
       'of `Amounts.rests_of_finite_reading` generalized to its unrefuted form; whole-number worlds as the instance; a '
       'dyadic witness that arising and ceasing recur without a least loss or a finite reading. New core module after '
       '`Becoming.LeastLoss`, no change to `World` (260 dependents). Literature check first. '
       '| Claude Code session of 20 October (started from the LC1 session) | claimed 2026-10-20 on `47fe3ee1f` '
       '| worktree `.claude/worktrees/xenodochial-saha-749c76`, kit `development/lc2-world-amounts/` '
       '| LC1 (`Amounts.rests_of_finite_reading`) → §1.3, §8.1 item 6, §9 |')
def edit(text):
    anchor = text.index('| **R49: formation classes')
    end = text.index('\n', anchor)
    return text[:end + 1] + ROW + '\n' + text[end + 1:]
