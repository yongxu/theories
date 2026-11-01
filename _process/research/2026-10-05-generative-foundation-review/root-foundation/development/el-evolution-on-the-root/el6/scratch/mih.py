p='experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MapInstances.lean'
s=open(p).read()
def rep(a,b,n=1):
    global s
    assert s.count(a)==n,(s.count(a),a[:90])
    s=s.replace(a,b)
rep("""`Becoming.GrammarMap` reads generation and keeping in the strong form (`«全生成»`, `«全守»`) and
reaching an end (`«有终»`, not degeneration, `«退化»`) at a fine class `E` and a coarse class `L`. This module reads the old base in it, with one reading""",
"""`Becoming.GrammarMap` reads generation and keeping in the strong form (`«全生成»`, `«全守»`),
reaching an end (`«有终»`) and degeneration (`«退化»`, ending on every branch) at a fine class `E`
and a coarse class `L`. This module reads the old base in it, with one reading""")
old_i=s.index("* **Not going on, and reaching an end.**")
old_j=s.index("* **Witnesses on the base.**")
s=s[:old_i]+"""* **Degeneration, constructively.** Along any class, where everything the line from `x` reaches at
  a step `N` not before `x` ends on every branch, `x` ends on every branch (`Web.ends_of_ends_at`,
  by induction on the steps left: a continuation lies one step later). No excluded middle enters,
  and no premise that the line does not branch. So, at every class `E` within activity
  (`«则» E W.activityClass`), a line from an active occurrence along which nothing reached at some
  step `N` not before it is active ends on every branch: the pattern read at `E` degenerates
  (`Web.every_branch_ends_of_gone`). What the line under `E` reaches lies on the line under
  activity (`Web.reached_coarser`), so it is active (`Web.active_along_finer`), and nothing is
  reached at `N`. What carries the law is the uniform horizon, which it states through activity.
  Its instance at activity itself is `Web.activity_every_branch_ends_of_gone`; the kind grain's is
  in `Becoming.KeepingWidening`.
* **Not going on, and reaching an end.** Read coarser, the same line does not go on
  (`Web.not_endless_of_gone`, by `«尽则非不穷»`), so it lies outside generation and keeping
  (`Map.outside_of_not_endless`); where going on is decided at the points of the line, it reaches
  an end (有终, `Web.end_of_gone`, by `«尽而续可定则有终»`). With no decision, that every line meeting
  the law's premise reaches an end is exactly excluded middle (`Map.end_of_gone_iff_excluded_middle`):
  in `Map.Undecided`, a web with one occurrence active at step `0`, one at step `1` and none from
  step `2`, continued exactly where a proposition `P` holds, the premise holds and the pattern
  degenerates (`Map.Undecided.degenerates`) while an end decides `P` (`Map.Undecided.end_decides`;
  the start is continued exactly where `P` holds, `Map.Undecided.first_has_next_iff`). Nothing
  infinite is undecided there, only whether one step is taken. This is where the map's boundary
  (`«不穷有终之定当且仅当排中»`) enters the instances: on the base, constructively, degeneration is
  the region a known horizon gives, and reaching an end is the further step that decided going on
  supplies. Three regimes of the base fall there, each making an occurrence at its step inactive,
  stated once, pointwise, and degenerating the line through that step:
  - consumption of a condition whose dependence the line still holds at a later step at no lower
    need, where activity needs support (`Web.consumed_held_gone`, `Web.consumed_held_degenerates`,
    so `Web.consumed_held_not_endless`);
  - a whole drawing beyond renewal: a family of conditions whose gated renewal ran into excess, as
    in `Flow.family_excess_ends`, ending every line that depends on the family at the step the
    excess reaches (`Web.family_excess_gone`, `Web.family_excess_degenerates`, so
    `Web.family_excess_not_endless`);
  - passing that stops, with brief carriers, as in `Web.ByPassing.ends_within`
    (`Web.stopped_gone`, `Web.stopped_degenerates`, so `Web.stopped_not_endless`).
"""+s[old_j:]
rep("""  continuation vacuously; renewal of relations does not decide the region
  (`Map.renewal_undecided`).
""","""  continuation vacuously; renewal of relations does not decide the region
  (`Map.renewal_undecided`). The hypotheses of each regime's degeneration law hold together from
  an active start, and the line takes a step before it degenerates: consumption, in a web of one
  formation depending at need one on a condition whose level falls to zero after step `1`
  (`Map.Depleted.degenerates`, `Map.Depleted.continues`); a whole drawing, in `Coupled` of
  `Becoming.Continuation`, the taker and the renewer of a patch read as one family
  (`Map.coupled_degenerates`, `Map.coupled_continues`); passing that stops, in the stopped relay of
  `Becoming.PatternPassing`, at every stopping step (`Map.stopped_relay_degenerates`,
  `Map.stopped_relay_continues`). In the first two the dependence premise is shown at every
  occurrence, reached or not; the stopped relay has none. In all three the web's activity is given,
  not derived from the regime: the premise sets can hold together on an active start, which does
  not show that a regime is what ends the line.
""")
rep("""Modelling choices: discrete steps, formations a fixed index type, activity Prop-valued, natural
number levels and needs. Every declaration has an empty axiom report.""",
"""Modelling choices: discrete steps (a continuation advances the step by one), formations a fixed
index type, activity Prop-valued, continuations Prop-valued relations, natural-number levels and
needs, natural-number amounts of a family's stock, uptake and replenishment (the second regime), and
in the degeneration laws a uniform horizon: one step `N` at which every branch is gone. Every
declaration has an empty axiom report.""")
open(p,'w').write(s)
print('ok')
