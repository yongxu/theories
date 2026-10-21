# Module docstring edits for SG10, run by build_tree.py on the assembled text `s` with `once`.
BULLET_END = '  faster, every optimum ends it.\n'
s = once(s, BULLET_END, BULLET_END + """* **Over every law of what stands.** Each law above on an order weighting later draws less, and on
  rebuilding from below, uses only what stands to be drawn at each step, so each holds over any law
  `G` of what stands: at the step from `t`, a level `z` gives `G t z` (`Optimum.Next`, `Web.Next`);
  the law may change with the step and give less than the level or more. The renewal law,
  `G t z = z + R z`, is the case: the laws above are stated from those over every law, their
  statements unchanged; lemmas no law reads in the renewal form any more stand in their general
  form only. Holding or rising to a level `y` needs only that what stands at `y` be at least `y`.
  Where others first draw from the level an optimizer leaves, and what remains renews, what stands
  for it is what remains with its renewal (`Optimum.Next.leftBy`): where they draw at least what the
  remainder renews, every optimum of every order whose weighting falls at every
  step, however slightly, stands at nothing from the first step on
  (`Optimum.Next.frontier_ends_of_le`, `Optimum.Next.frontier_ends_drawn_first`), and where they
  draw more, so does every optimum of every order with positive weights rising at no step
  (`Optimum.Next.frontier_ends_of_lt`, `Optimum.Next.frontier_ends_drawn_more`), breaking every
  dependence on the base with a positive need (`Web.Next.frontier_ends_drawn_first`,
  `Web.Next.frontier_ends_drawn_more`). The instance `Holding.doubling_drawn_first`: from two, a
  source doubling up to eight is rebuilt to four and eight by every optimum alone under weights
  falling by less than half a step; with others first drawing all but a quarter of what is left,
  every optimum under the same weights ends it at once; with others drawing all but half, every
  optimum under weights falling at every step ends it, and under equal weights ending it and holding
  it at two are both optima, so the strict fall cannot be dropped. Under weights falling by one a
  step from `n + 4` the same order rebuilds the source alone and ends it with others drawing all but
  half (`Holding.doubling_drawn_first_linear`).
""")
READING_END = 'ending at once, a weighting falling faster than the base renews ending it rather than rebuilding it.\n'
s = once(s, READING_END, READING_END.rstrip('\n') + """ Over
every law of what stands the laws cover a base that decays and one renewing differently from step
to step; where others draw first, they are the optimizer's side of the dissipation of a common pool:
what an optimizer leaves the others draw, so it stands no higher when the next step comes, and where
they draw at least what the remainder renews any weighting falling at every step makes drawing it
now better (Gordon 1954; Levhari and Mirman 1980, where the stock at equilibrium falls as players
are added). What the spine's form adds: the threshold moves exactly from what the base renews to what the others' leaving
renews, for every order rising with the weighted draw, and the same order that rebuilds the base
alone ends it with others drawing first. The others' draws are supplied as a rule reading the level,
not derived as a best response: this is one optimizer's side of the dynamic commons, not its
equilibrium.
""")
NOT = 'several optimizers\nranking courses, and how optimizers come to a\nmutual best response; for several optimizers,'
s = once(s, NOT, "whether others' draws,\nsupplied as a rule reading the level, are themselves a best response, so several optimizers each\n"
         "ranking courses at a mutual best response, and how optimizers come to one; for several optimizers,")
