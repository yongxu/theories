# Digging under the second way: guesses frozen before any reader runs

AI-written (Claude Fable 5.2, session ea01aaba, board row DJ). Frozen 17 November 2026, 15:58 WIB,
after I had read the opening accounts (not the proofs) of `Interdependence`, `MutualDependence`,
`RuleShaping`, `PairFlow`, `Flow`, `Dissipation`, `Population`, `Arising`, and the definitions of
`RegimeMargin.step` and `Coupled.step`. Nothing below has been checked against a proof yet.
Corrections are appended with the clock time, never written over.

Ren's word that started it (17 November, in the app, after the report of the second way's first
try): "I think this is the time maybe you need to dig a little bit deeper."

## What I think I am looking at (mine, held loosely)

The morning's try ended at: where what a going-on rests on is one amount standing apart, a unit can
take from it or add to it from nowhere, and nothing else. Under that:

The root says whatever lasts is made again out of other things that are going on too. An amount
that stays when nobody touches it, or grows by a rule of its own, is not made by anything going on.
October's Lean does not allow that: on its web a change of a level is what the goings-on present
take and give (`Flow.Balances`), "a sun or a river is then one of the formations, not an outside".
November's line on a level was built without that.

## The guesses, each with what would count against it

**D1. November's line is not on October's balance.** `LineOnAStock`, `TurningInTime`, `WayOfUnits`,
`RegimeMargin` and `RuleShaping` state no law under `Flow.Balances`; the level's own giving
(`RegimeMargin.step g H x = (x - H) + g (x - H)`) and the tried `give` add to a level with nothing
giving.
*Against:* a theorem already in the package that reads the line's course, or `RegimeMargin`'s step,
as a balanced flow on a web.

**D2. The morning's negative result is October's, found again.** "A way that grows and goes on must
add without bound from nowhere" is, in content, `Flow.More.replenishment_unbounded` (more takers
without end need replenishment without bound) with `Dissipation`'s laws.
*Against:* the hypotheses differ so that neither statement gives the other even after the line is
read as a flow (for instance `More` counts takers and the line's units need not each take).

**D3. October has the second way as witnesses and one-sided laws, and no units that multiply under
selection on it.** Witnesses: `Flow.Cycle.closed_more`, `Interdependence.Overshoot.steady_continues`,
`Recycle`, `Oscillation`, `PairFlow.FailedRenewal.lines_gain`; general laws run one way
(`unfed_consumption_ends`, `uptake_needs_replenishment`, `Dissipative.opens`). No module has
formations that multiply and are selected among, on a balanced web, with a law that says which line
goes on.
*Against:* such a module (candidates to read: `LineageRegimes`, `LineageDrawdown`, `ReadingsSpread`,
`PairSelection`, `PairFlow`, `Reproduction`, `Founding`, `SelectionLevels`, `CoupledDrawers`,
`RenewalFlow`, `RelationalRenewal`).

**D4. The line's course can be carried onto October's web without changing either.** One condition
(the level), the units of each generation as the formations present, and one more formation named,
which gives what `giving` gives. Then the line's laws are laws of a case of the web, and the web's
general laws hold of the line.
*Against:* `Web` and `Flow` as defined cannot carry it (formations present each once while a way
lists a unit several times; `step` gives after the take; a cut-off course; `need` as a threshold on
the level, not on a unit's own standing), so that the join would need a definition changed.

**D5. Under balance, on one condition, giving back is taking less.** A unit that takes `h` from a
condition and gives `b ≤ h` back to the same condition across the same step leaves the level as a
unit taking `h - b` does. So on one condition "remaking what it rests on" is no more than
restraint, and the second way needs at least two conditions: what one going-on gives is another
condition, which a different going-on takes from.
*Against:* a law or witness in the package where giving back to the one condition taken from does
something a smaller take does not (through timing within the step, through `need`, through who is
counted as renewing).

**D6. What places the two ways with respect to each other is where a line's giving lands.** If it
lands on conditions that the line's own later units require and others do not, its fall comes back
to that line alone, and a line that stops giving ends by its own doing. If it lands on a condition
all require alike, it comes back to all alike, selection does not favour giving
(`RuleShaping.favours_alike`, `nothing_back_falls`), and the takers' line and the givers' line fall
together. Pooling several lines' conditions into one is then a move from the second arrangement to
the first.
*Against:* (a) a countermodel on a balanced web where giving lands only on the giver line's own
condition and the non-giving line still does at least as well for ever; (b) one where giving lands
on a condition all require alike and is still strictly favoured with no assortment; (c) the claim
turning out to be `RuleShaping.grouped_rises_iff` said again with nothing joined.

## Tests for the dig as a whole

1. If D1 is false (the join to the web is already there), I was wrong about what this month's
   models lack, and the morning's sentence on the direction page is wrong again.
2. If D4 fails, the two months' models are not one model without rebuilding one of them; that is
   said plainly and not papered over with a correspondence in words.
3. If D4 holds but no older proof becomes a case or loses lines by it, it is a re-saying and is
   not landed as a join.
4. If D6 comes out as only `RuleShaping`'s law in other words, it is told as that law, once, and no
   new result is claimed.
5. Nothing here is told to Ren as the map's words. Line, stock, need, giving stay working names;
   formation, condition, web, flow are October's working names and are no more settled.
6. No package module is changed in this dig. Scratch Lean only, each read by an agent who did not
   write it.

## Scale

A first run of six readers on Fable (five reading clusters of modules whole against D1 to D6, one
trying to refute them, with small countermodels in Python where a guess is about numbers). No Lean
build in that run. A second run, only if D4 survives: one or two Opus writers in scratch Lean and
as many Fable readers.

## Appended 17 November 2026, 16:15 WIB: what the seven readers returned (run wf_54fb622a-ca4; reports in dig-readers.json)

Every guess came back "holds in part"; the picture above them is wrong at its centre.

**The picture.** "October's Lean does not allow that" is false. Five readers, independently:
`Flow.Balances` says only that each change of a level is the takes and gives of formations listed
as present. A formation may give at every step while taking and requiring nothing, and the flow
balances (`Growing.growing`, Flow.lean:784; the renewers of `PairFlow`, `LineageRegimes`,
`ReadOffInTime.FourReaders`). An untouched amount stays, by the definition. What forbids giving
from nothing is a further premise, `Dissipative` (Dissipation.lean:248), which six of October's own
going-on witnesses are proved to fail (`witnesses_not_dissipative`, :1369); under it, with finitely
many conditions, nothing that takes goes on at all (`finite_taking_not_recurring`, :461), and what
keeps being taken from is fed from beyond (`Flow.fed_from_beyond`, Continuation.lean:180). So
October has three layers (the record alone; balance, which names the giver; balance with
dissipation), and the difference from the line is that the giver is named, not that nothing comes
from nowhere. The split by month is also wrong: `RegimeMargin` is of 20 October, `RuleShaping` of
25 October, and `CoupledDrawers` (26 October) is off the web.

**What I had not seen at all.**
- On the web `active` is a free field, tied only by `Dependent` (active gives supported). So every
  general law there concludes an ending or a fact about a level, and every "continues" is a built
  example whose web stipulates it. The web is a record; the line is a law. (feeding-and-return 1;
  web-base 4.)
- Requiring and taking are apart on the web (a threshold on a level; a take). D5 and D6 were worded
  as if they were one. (feeding-and-return 4; refute 3.)
- `RegimeMargin` already has steps over several conditions, each giving by a law of what is left
  of all (`Coupled.step` :2081, `Indexed.step` :2113, `Recent.step` :3024), with general laws and
  a pair that hold each other up though each alone ends (`Relay.cycles` :3582). No other module
  uses them; the line sits on the one-condition step. Nothing passes between conditions there and
  there are no units. (the-november-line 3; read by one reader.)
- `Becoming.Stock` has the line's level recursion and its account already (`Stock.along` :492,
  `trace_balance` :78, `stockFlow_balances_iff` :475); the line does not use it. (web-base 3; not
  measured.)
- `ReadOffInTime.FourReaders` already carries `RegimeMargin.step` on a balanced web, as one built
  example nobody uses. (three readers.)

**D1** holds in part: the five modules state no law under `Flow.Balances` (by grep, not by a whole
read), but FourReaders is a built join and `TurningInTime` imports it.
**D2** holds in part and is worded wrong: `More` counts takers and a growing line can have one
taker; the law that applies is `Amounts.replenishment_unbounded`. The morning's `covered` is a
sufficiency, October's law the necessity: neither gives the other. "Must add from nowhere without
bound" was the reader's reading of a premise, not a theorem.
**D3** holds in part: no module read joins multiplying under selection, levels that run down, and
giving with a receiver. The pieces: returns kept or shared (`SelectionLevels`, numbers only);
factors derived from where a gift goes (`PairFlow.Routes`, standings constant by definition);
descent on a web that runs down (`GroupEnding`, `Founding`, every law an ending);
`SelectionPace`, whose account says the pace of a selection is bounded by inflow into the
carriers' lineages (unread). Named and unread: `GroupEnding`, `SelectionPace`, `DrawnBeyond`,
`Wholes`, `OverExchange`, `PersistingChoices`, `Descent`, `Evolution`, `Entropy`.
**D4** holds in part: each course of the line has a balanced record with no definition changed,
exactly where the way's take is within the level at every step; but `Taking` and `Dependent`
cannot both hold where an unmet unit takes, the line's laws stay laws of its step, and the web's
ending laws are not the line's. Test 2 of this file is tripped in its spirit: the two are not one
model by a carrying.
**D5** first sentence is the definition with a term cancelled (a remark); it fails of the web's
counts (`Cycle.closed_more` is a one-condition witness where the takers are the renewers) and of
`RegimeMargin.step` (the level's giving is read after the take). "The second way needs two
conditions" is proved nowhere.
**D6** fails as worded. From 193,536 exact runs (search/refute/): where "requires" is a threshold
the non-giving line goes on for ever in 6,432 of 16,128 runs; with one first condition shared the
non-giver ends the giver in 971 of 1,680; with one second condition shared and the giver served
first the giver alone goes on (1,462 runs). What decides is who gets back what was given and who
is short of what (order of access, shortage on each level), not which condition the giving lands
on. Its selection half is `RuleShaping.favours_iff` and nothing more; its ending half is in no
module read; in the line's model giving costs the giver nothing, so the cost has to enter before
any of it can be said there. Its last sentence had first and second the wrong way round.

Tests of the dig: 1 not tripped as worded, but the morning's sentence on the direction page ("That
is not tried") is still wrong for another reason: October tried it in several places. 2 tripped in
spirit. 3 and 4: no join claimed. 5, 6 kept.

## Appended 17 November 2026, 16:17 WIB: second round, guesses frozen before its readers run

The first round named modules nobody read whole and left one thing unsaid: what "the second way"
is. I have been using three different senses without telling them apart, and each has its own
place in the package:

(a) **staying within what is made again**: a going-on whose take is within what the thing it rests
    on is given. October calls this the renewing relation (`RelationalRenewal`,
    `within_renewal_renewing`), with consuming its opposite; the line has it exactly
    (`LineOnAStock.unending_iff_holds`). So "the second is in no law of this month's models", on
    the direction page since 16 November, was already too wide in this sense.
(b) **adding to what it rests on**: tried this morning; needs a cost to the giver and a said
    source, which the line lacks.
(c) **arising as something others can rest on**: what comes to be is itself a condition of further
    goings-on (`Roles`: "parents are of their young, a forest of its understory, a flower of the
    bee"), so that more can go on without more being taken from what the first rests on.

**E1.** `RegimeMargin`'s steps over several conditions carry a general two-way law (an "exactly
where", or a threshold law) for conditions that give by what is left of each other, so sense (b)
between conditions is already a law there. *Against:* only order lemmas and built examples
(`Relay.cycles` one built pair).
**E2.** `SelectionPace` proves a general law, on a balanced flow with lineages, tying the pace of a
selection to what flows into the carriers' lineages and not into the whole. *Against:* built
examples only, or the bound is of something else, or its account says more than its Lean.
**E3.** `GroupEnding`'s `gated` premise and `Continuation`'s `Conveys` and `fed_from_beyond` are
the package's general way of saying that what gives to a family rests on it, and every general law
under them is an ending; none places a giver that rests on what it gives to against one that does
not, by which goes on. *Against:* such a law.
**E4.** `LineOnAStock.account`, `taken_below` and their neighbours are `Stock` laws under another
name, and putting the line on `Stock` would take at least 30 lines of proof out of
`LineOnAStock`. *Against:* premises differ, or fewer lines fall than would come in.
**E5.** No module of the 406 has together: units that multiply by a law of the step, a cost of
giving borne by the giver (in offspring or in what it must take), a level that can run down, and a
said receiver of what is given. *Against:* one that does.
**E6.** Sense (c) has laws on the web (`Roles`, `Succession`, `Novelty`, `Openness`, `Growth`, the
widening modules) and none of them has a level that the newcomer's arising leaves unlowered while
another newcomer's arising lowers it: the difference between arising on what others pass on and
arising on what others need is stated nowhere. *Against:* a statement of that difference, as a
law or as a pair of built examples set side by side.

Scale: seven readers on Fable, reading only, no builds: six clusters read whole, one sweep over the
opening accounts of all the modules for what both rounds missed.

## Appended 17 November 2026, 16:34 WIB: what the second round returned (run wf_2966c296-6aa; reports in dig-readers-2.json)

**E1** holds in part. `RegimeMargin`'s steps over several conditions do carry general two-way laws
(`Indexed.ends_iff_below` :2687, `Indexed.fates` :2716, `ends_iff_below_within` :2984,
`ends_together` :2219): under constant draws, each condition giving to its own level by a law that
rises with what is left of every condition, a condition ends exactly below a threshold found by
running the step. But nothing passes between conditions, giving costs nothing, there are no units,
and within a band the laws are of running down to a rest. It is a condition's own regrowth read off
the others' levels, not sense (b). `Relay.cycles` is one built pair from one start.
**E2** holds in part. `SelectionPace` has general one-way bounds across one step, no two-way law. A
"lineage" there is a one-step list of a parent and the newcomers assigned to it; no premise says
the parent gives to them. "Not into the whole" is one built example (`Displacement.natural_fails`),
and a general law in the same file bounds the carriers' total by the whole's inflow with the fall
of the rest (`share_within_rest` :565).
**E3** holds in part. The gate is a premise (whatever gives to a family requires a member of it at
a need). Every general law read under it concludes no giving, a level held below the need, an
ending, or that something cannot go alongside; none concludes that anything goes on. One pair of
general laws does set what rests on the level against what does not, by which goes on, outside
`Becoming/`: `RelationalRenewal.dependent_overdraw_ends_itself` (:438) against
`independent_overdraw_persists` (:503), of a drawer under overdraw, not of a giver.
**E4** fails. `taken_below` is not a `Stock` law (it needs nothing given from nothing and positive
needs, and concludes strictly); `account` and `Stock.after_balance` are separate tellings of one
Prelude lemma. Putting the line on `Stock` would take out at most 18 proof lines and bring in
about 27. No join there.
**E5** holds as far as read (the sweep opened candidates among all 406 accounts): no module has the
four together. Nearest: `Optimum` (drawers who leave at a cost to themselves on a level that can
be drained, the receiver said, two-way: `drain_perfect_iff` :9027, `kept_returns` :8208; a fixed
number of drawers); `RuleShaping`'s line through `DrawnShaping`, `PoolFromCourse`, `ReadInTime`
(multiplying by the step's rule with a cost and a said return; no level that runs out);
`DrawnBeyond` (what raises a family takes from beyond, the beyond falls, above the slack a
dependence there breaks for a formation the raisers do not couple into: `breaks_beyond` :205,
`favours_breaking_beyond` :293); `KindRelay.Fed` in `KeepingWidening` (one built table).
Offspring everywhere on the web are a supplied list, not the outcome of a step.
**E6** fails: the difference is stated. `Admission.supported_iff_within_margin` (:633), two-way,
on a balanced flow against the levels with a part's exchange withheld: another formation stays
supported exactly where, for every condition it requires, its need with what the part has taken is
at most the withheld level with what the part has given. `closes_nothing` (:642),
`opens_nothing` (:650); `OwnWidening.widens_iff_others_within` (:146) is the same for what can
form; `DrawnBeyond` has the built pair (`rise_ends_dweller` :516 against `within_slack` :568). It
is stated of a part's net exchange on a record, not of an arising and not as a law of a step.

**The three senses, against the Lean.**
(a) is a property of the joint take on a thing, not of one going-on's take (`WithinJoint` against
`WithinOwn`, `Pair.own_not_joint`, Continuation.lean:653); one taking all that is given and going
on forces another to stop (`Exclusion.continuing_excludes` :246). The line has it exactly only
where each unit's kids take what it takes. `within_renewal_renewing` is one-way, and renewing and
consuming exclude each other without exhausting the cases (`fluctuating_neither`).
(b) has a cost and a said source on the web as flow-wide premises (`Gainless`, `Dissipative`) with
general laws under them, and as leaving at a cost in `Optimum`. Not for units that multiply.
(c): the last clause, "more can go on without more being taken", is no law. Under balance and
dissipation every embodied arising lowers the stock of a family dissipated on that holds it
(`Embodied.arising_lowers_on`, Roles.lean:650); new formation without end in a finite family needs
gain from beyond it (`Gain.rises_late_of_newly_supported` :205, `rise_from_rest_or_open` :279;
`KeepsWidening.passes_every_bound`, KeepingWidening.lean:287). It holds only in built examples that
give from nothing or stipulate constant levels.

**What this comes to.** Three times today I said something was not in the Lean (the second way in
no law; goings-on resting on each other not tried; the difference between sparing and needing
stated nowhere) and each time it was there. What is not there, after two rounds and a sweep of all
the accounts, is narrower: the pieces in one model. On the web (a record) they are two-way laws of
margins and one-way laws of endings; as laws of a step they are told for fixed casts (conditions
in `RegimeMargin`, a drawer and a renewer in `RelationalRenewal`, drawers in `Optimum`, two counts
in `RuleShaping`) and for units that multiply on one level (the line). No statement joins a line
that multiplies to any of them.

**A thing noticed, not checked.** The two-way laws the second round found share one shape: a
going-on that rests on something at a need is left as it was exactly while others' net take stays
within how far that thing stands above the need (`supported_iff_within_margin`,
`widens_iff_others_within`, `breaks_beyond`; in law form `RegimeMargin`'s point of no return; on
the line `Goes` and `ways_alike`). Whether that shape is one law with these as cases is not
tried and is a guess of 16:34, the fourth picture of the day.
