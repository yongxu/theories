# Executed by build_tree.py on `op`, the module text: SG13's part of the step-coupling bullet, its reading and the
# section header.
BULLET_ANCHOR = '''  of the whole keeping must exceed `n + 3`; one of two a step keeps it to the horizon's last step;
  one of at most one a step breaks it.
'''
BULLET = '''  Counted at every step met, wherever those steps fall, the coupling meets a fall met again: each
  step met forgoes at least `r - q` wherever it lies (`Optimum.shortfall_count_ge`, of which the
  count from the start, `Optimum.shortfall_ge`, is the case; `Optimum.met_count_drawn_le`), so a
  course below the need at some step is worth at most a course keeping it where `r ≤ q + c`,
  `r + e ≤ q + c + m` and `e ≤ c` (`Optimum.falls_met_le`), every optimum keeps the need through the
  horizon where `r + e < q + c + m` and `e < c` (`Optimum.frontier_keeps_met`,
  `Web.frontier_met_kept`), and the keeping course is an optimum where `r ≤ q + c` and `m ≤ c`
  (`Optimum.continued_met_frontier`). Against the count from the start, `r ≤ q + c`, the threshold
  rises by the end's excess over the need and becomes strict: a fall met again forgoes the coupling
  only at the steps below. `Holding.burst_met` is the instance: under a burst renewing four at one,
  from the level a dweller needs, a coupling of four a step keeps the dweller under every optimum
  counting from the start, while counting every step met, the course falling once and met again
  is an optimum beside the course keeping it; five a step keeps it under every optimum.
'''
op = once(op, BULLET_ANCHOR, BULLET_ANCHOR + BULLET)
READ_ANCHOR = '''breaks it, at the last step alone where the coupling exceeds the renewal forgone a step.
'''
READ = '''Counted at every step the need is met rather than from the start, the same coupling can be had by a
course that falls and recovers: what the fall forgoes is the coupling at the steps below, what it
gains is the renewal forgone there and what the end leaves above the need, so the coupling must
exceed the renewal forgone a step outright. A constraint rewarded step by step without memory of a
breach is gamed exactly at that threshold.
'''
op = once(op, READ_ANCHOR, READ_ANCHOR + READ)
op = once(op, '''and a long horizon outweighs it. Optima exist on both sides. -/''',
          '''and a long horizon outweighs it. Optima exist on both sides. Where the worth adds `c` for every step
the need is met, wherever, each met step still forgoes at least `r - q`, but a fall met again loses
the coupling only at the steps below, so every optimum keeps the need where `r + e < q + c + m` and
`e < c`, a strict threshold above the count from the start. -/''')
