"""LC3 module docs in the kit tree (after edit_leastloss.py and edit_inamounts.py)."""
from pathlib import Path
HERE = Path(__file__).resolve().parent
def edit(path, pairs):
    t = path.read_text()
    for old, new in pairs:
        assert t.count(old) == 1, (path.name, old[:80], t.count(old))
        t = t.replace(old, new)
    path.write_text(t)
    print('edited', path.name, len(pairs))

LL = HERE / 'tree/Becoming/LeastLoss.lean'
edit(LL, [
('''* **A part's merge, kept by the rest.**''',
'''* **One premise: the strict falls stop.** Both rest laws conclude the same thing, that an amount's
  strict falls stop from a step on, as far as can be refuted (`Amounts.FallsStop`), and it is the one
  premise rest needs over any amounts (`World.InAmounts.change_stops_iff`). Amounts in which every
  amount not rising stops falling have no endless fall (`Amounts.NoEndlessFall`); a least fall
  (`Amounts.FallsAtLeast`: every strict fall is by at least `ε`) in Archimedean amounts gives it
  (`Amounts.noEndlessFall_of_fallsAtLeast`), and whole numbers are the instance
  (`Amounts.whole_noEndlessFall`). Each premise is needed: dyadic amounts are Archimedean with no
  least fall (`Halving.no_least_fall`) and fall without end (`Halving.endless`); layered amounts have
  a least fall (`Layered.fallsAtLeast`), are not Archimedean, and fall without end
  (`Layered.endless`).
* **A part's merge, kept by the rest.**'''),
('''`Becoming.InAmounts` reads a world's standings and exchanges in any amounts and states the rest
theorem there from a finite reading (`World.InAmounts.rests_unrefuted_enclosed`).''',
'''`Becoming.InAmounts` reads a world's standings and exchanges in any amounts and states the rest
theorem there with the one premise that the census's total stops falling
(`World.InAmounts.rests_unrefuted_enclosed_of_stops`), which a finite reading or amounts with no
endless fall supply.'''),
])

IA = HERE / 'tree/Becoming/InAmounts.lean'
t = IA.read_text()
a = t.index('/-!\n# A world in amounts')
b = t.index('-/\n', a) + 3
DOC = '''/-!
# A world in amounts: the rest theorem over any amounts

The rest theorem (`World.rests_unrefuted_enclosed`, its forms `World.rests_unrefuted_covering` and
`World.rests_unrefuted`) reads a world's standings and exchanges in whole numbers and takes its force
from them: every change of a standing lowers the total standing by at least one, and no total lies
beyond its own count of ones. This module reads a world in any amounts and states the theorem with
one premise, that the census's total stops falling (`Amounts.FallsStop`), shows that the premise is
exactly a family's rest, and locates where amounts supply it.

* **Totals over any amounts.** `Amounts.totalOf` adds amounts over a list. It keeps the order
  (`Amounts.totalOf_le`; member by member as far as can be refuted, `Amounts.not_not_totalOf_le`),
  splits over addition (`Amounts.totalOf_add`), exchanges two lists (`Amounts.totalOf_swap`), holds
  each member's amount (`Amounts.le_totalOf`), and, where every member's amount is at least another's
  and the totals are the other way, holds each member's the other way too
  (`Amounts.le_of_totalOf_le`): no member can be strictly larger while the total is not. Over a family
  and a part of it holding every member not within nothing, the two totals are each within the other,
  as far as can be refuted (`Amounts.totalOf_support`). In whole numbers it is `total`
  (`Amounts.totalOf_whole`).
* **A world in amounts.** `World.InAmounts w A` reads a world's standings, takes and gives in
  amounts `A`; what takes part, what is active and what arises or ceases are the world's own
  records. A family balances across a step where each member's level after the step, with what is
  taken from it, is within its level before, with what is given to it (`BalancesOn`, one way: no
  amount is made); the flow dissipates on it where every relatum taking part gives the family no
  more than it takes from it, and whatever gives it back all it takes takes nothing (`DissipatesOn`:
  strictness with no least loss). A relatum stands where its level is not within nothing.
* **The law of one step.** Balanced and dissipated on, the family's total does not rise
  (`InAmounts.stock_still`), and where it does not fall strictly no member's level changes either
  way (`InAmounts.steady_of_stock_le`): a rise needs something given, and a relatum that took and
  gave back no less took nothing. So every change of a member's level lowers the total strictly
  (`InAmounts.change_lowers`), with no least loss.
* **A family's rest is one amount's.** Balanced and dissipated on from some step on, a family stops
  changing, as far as can be refuted, exactly where its total stops falling
  (`InAmounts.change_stops_iff`). No premise on the amounts enters.
* **The rest theorem over any amounts.** A world whose active relata lie in one family, balanced and
  dissipated on, whose arising is embodied and whose family total stops falling rests from some step
  on, unrefuted (`InAmounts.rests_unrefuted_of_stops`); so does a world with a census of its active
  relata, all embodied, a balanced and dissipative flow and every step from some step on enclosed,
  whose census's total stops falling (`InAmounts.rests_unrefuted_enclosed_of_stops`): each enclosing
  family is widened, as far as can be refuted, to hold what is active before and after the step
  (`InAmounts.Enclosed.around_census`), its total is the census's each way
  (`InAmounts.stock_census`), so the census's total does not rise (`InAmounts.census_still`) and
  falls strictly at each arising or ceasing (`InAmounts.census_falls`). A finite reading gives the
  premise (`InAmounts.stops_of_reading`, from `Amounts.rests_unrefuted_of_finite_reading`):
  `InAmounts.change_stops_unrefuted`, `InAmounts.rests_unrefuted_covering`,
  `InAmounts.rests_unrefuted_reading`, `InAmounts.rests_unrefuted` and
  `InAmounts.rests_unrefuted_enclosed` are its forms. Amounts with no endless fall give it to every
  such world (`InAmounts.rests_unrefuted_enclosed_of_noEndlessFall`).
* **Whole numbers are the instance.** Every world is a world in whole-number amounts
  (`World.wholeAmounts`), whose balance, dissipation, embodiment and enclosure are the world's own
  (`World.balanced_whole`, `World.dissipative_whole`, `World.embodied_whole`,
  `World.arisingEmbodied_whole`, `World.enclosed_whole`). No whole number falls without end
  (`Amounts.whole_noEndlessFall`), so a world meeting the premises of `World.rests_unrefuted` or
  `World.rests_unrefuted_enclosed`, and nothing more, rests by the law over any amounts
  (`World.rests_unrefuted_whole`, `World.rests_unrefuted_enclosed_whole`). The whole-number theorems
  keep their own proofs below this module, which reads `World` and so lies above them.
* **An endless fall keeps a world from rest.** In `Pass` one standing passes between two relata
  along any amount `d` falling strictly at every step, in any amounts: the holder stands at `d t`,
  takes it all from itself and gives `d (t + 1)` to the other. The world has a census of its active
  relata, every relatum embodied, a balanced and dissipative flow and every step enclosed, and still
  at every step one relatum arises and the other ceases (`Pass.endless_keeps_from_rest`); no list
  holds its levels (`Pass.levels_unlisted`). The halving stock in dyadic amounts is one such `d`.
* **Rest over every world in given amounts.** `Amounts.WorldsRest M` says every world in `M` with
  those premises rests, unrefuted. No endless fall gives it (`Amounts.worldsRest_of_noEndlessFall`;
  whole numbers, `Amounts.whole_worldsRest`), and it leaves no amount falling at every step
  (`Amounts.not_endlessFall_of_worldsRest`). So dyadic amounts, Archimedean with no least fall, and
  layered amounts, with a least fall but not Archimedean, each carry a world that never rests
  (`Halving.worlds_need_not_rest`, `Layered.worlds_need_not_rest`). Rest over every world lies
  between no endless fall and no fall at every step; the two coincide where the steps at which an
  amount falls can be chosen (classically, with dependent choice).

The representation commits to discrete steps and to Prop-valued activity; amounts are any
`Amounts`. Every premise is named where it is used. Every declaration has an empty axiom report. No
ethical predicate, ranking or axiom occurs.
-/
'''
t = t[:a] + DOC + t[b:]
IA.write_text(t)
print('edited', IA.name, 'doc')
