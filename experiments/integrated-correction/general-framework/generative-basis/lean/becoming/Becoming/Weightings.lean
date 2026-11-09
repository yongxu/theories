import Becoming.Boundaries
import Becoming.GroupEnding

/-!
# Weightings: what every standpoint's weighting ranks, and what the step across standpoints reaches

The ethics of the chapter rests on two premises: the continuation condition fixes scope (whose
losses count) and calling widening better (C) fixes order. `Becoming.Boundaries` decomposed the
condition into the self's presupposition and the step of invariance. This module states what the
step reaches when it is taken across standpoints rather than across drawings of a self, and what
order every standpoint shares when each weighs what can form in its own way.

* **Weighted counts.** Over a finite list of items (steps and formations), a course is the items it
  admits (a Bool-valued family), and a weighting gives each item a natural weight; the weighted
  count adds the weights of the admitted items (`Weighting.weighed`). A weighting is positive when
  it counts every listed item (`Weighting.Positive`).
* **Widening is what every positive weighting ranks higher.** Inclusion never lowers a weighted
  count (`Weighting.weighed_le_of_includes`); every positive weighting ranks a widening strictly
  higher (`Weighting.weighed_lt_of_widens`, the case of net weightings below with nothing against);
  where one course admits an item the other does not, some positive weighting ranks it higher
  (`Weighting.outweighs`, a case of weights within a ratio below), so a mixed comparison is decided
  both ways by positive weightings (`Weighting.mixed_either_way`); hence on the listed items one
  course widens another exactly when every positive weighting ranks it higher
  (`Weighting.widens_iff_every_positive`). On a web, where what either level path admits is listed
  and admission is decided, this is `Web.Widens` itself (`Web.widens_iff_every_weighting`).
* **Any order increasing in admission.** An order need not be additive: call it increasing in
  admission when it ranks every widening higher (`Weighting.Increasing`; a positive weighting's
  order is one, `Weighting.increasing_ranks`, and so is priority to the worse off,
  `Weighting.increasing_prior`). For any class of orders from the positive weightings up to all
  orders increasing in admission, one course widens another exactly when every order of the class
  ranks it higher (`Weighting.widens_iff_every_of_class`; all of them,
  `Weighting.widens_iff_every_increasing`; every complete one, as a score,
  `Weighting.widens_iff_every_score`; on a web, `Web.widens_iff_every_of_class`), and within each
  such class a mixed comparison is decided both ways (`Weighting.mixed_either_way_of_class`). The
  shared order does not depend on the representation. Lexical priority, the basic items first, is
  increasing in admission (`Weighting.lexical`, `Weighting.increasing_lexical`), so it lies within
  such a class and decides only what the shared order leaves mixed.
* **A weight of zero ties.** Where every item a course admits beyond another weighs nothing, the
  two weigh the same (`Weighting.weighed_eq_of_unweighted`): a weighting that leaves an item out
  does not rank a widening that adds only that item.
* **The same weight for every item ranks by number.** Under one positive weight for all items, a
  course weighs more exactly when it admits more items (`Weighting.weighed_const`,
  `Weighting.neutral_ranks_by_number`): the ratio one of weights within a ratio below.
* **What each course admits beyond the other.** Under any weights two courses compare as what each
  admits beyond the other (`Weighting.beyond`, `Weighting.weighed_split`,
  `Weighting.weighed_lt_iff_beyond`): what they share weighs the same in both.
* **Net weightings: an item can weigh below zero.** A net weighting counts each listed item for a
  course that admits it (`pos`) and against it (`neg`) (`Weighting.ranksNet`). It ranks two courses
  by what each admits beyond the other (`Weighting.ranksNet_iff_beyond`) and a widening higher where
  every item the widening adds weighs above zero (`Weighting.ranksNet_lt_of_widens`). A widening by
  one item alone (`Weighting.WidensBy`) it ranks as that item weighs, whatever else either course
  keeps: above where the item weighs above zero, below where it weighs below zero, and neither where
  it weighs zero (`Weighting.ranksNet_widensBy`, `Weighting.ranksNet_ties`); so the sign of its
  increment at an item (`Weighting.IncrementIs`) is the same in every context
  (`Weighting.ranksNet_increment_alike`), and it increases at every item weighing above zero
  (`Weighting.IncreasingAt`, `Weighting.ranksNet_increasingAt`).
* **Rankings of presentations: the exception.** A presentation is a plan with its wording and the
  order in which it is told; a ranking of presentations reads the sets on a pair where it ranks the
  two, each way, as an order on courses ranks what they keep (`Weighting.ReadsSetsOn`; on every
  pair, `Weighting.ReadsSets`). Read right, an order increasing at the item a wider plan alone adds
  ranks the wider above and never the narrower (`Weighting.reads_increasingAt`). Under a net
  weighting a narrowing ranked above its widening by one item is a pair not read right or an item
  weighing at zero or below (`Weighting.narrower_above_net`); read right, the narrowing is ranked
  above exactly where the item weighs below zero (`Weighting.reads_ranksNet`); read right on every
  pair with every item above zero, no widening by any number of items is ranked below
  (`Weighting.reads_ranksNet_widens`). A framing alone, the item weighing above zero, ranks a
  narrowing above its widening (`Framed.framing_alone`).
* **A sign measured apart.** Read right, the sign of the order's increment from the narrower course
  to the wider fixes the verdict exactly (`Weighting.reads_increment`): a sign measured with no
  plan shown predicts the ranking of a pair exactly where it is that increment's sign in the pair's
  context. Under a net weighting that holds in every context once it holds in one; in `Interacting`
  adding an item raises a course keeping nothing and lowers one keeping the other item, and no net
  weighting gives that order (`Interacting.increment_differs`, `Interacting.not_net`).
* **Weights within a ratio.** Where every two listed weights stand within `n / d` of each other
  (`Weighting.RatioWithin`), what each course alone admits bounds what it weighs
  (`Weighting.beyond_within`). Every positive weighting within `n / d` ranks `a` above `b` exactly
  where `n` times the number of items `b` alone admits is less than `d` times the number `a` alone
  admits (`Weighting.ranks_past_ratio`, `Weighting.every_within_iff`); the weighting tilted toward
  `b` (`Weighting.tilted`) decides the boundary and ties on it (`Weighting.tilted_lt_iff`,
  `Weighting.tilted_ties`). Some weighting within the ratio ranks `b` higher exactly short of it
  (`Weighting.some_within_reverses_iff`), so two rank a pair opposite ways exactly where `n / d`
  exceeds both what each side alone admits over what the other alone admits
  (`Weighting.opposite_within_iff`). Equal weights are the ratio one
  (`Weighting.const_lt_iff_beyond`).
* **Closing is never required.** Where the levels `l'` admit a formation at a step and `l` do not,
  `l` neither widens nor keeps `l'` (`Web.not_widens_of_closes`).
* **What the step across standpoints reaches.** Let each standpoint's presupposition about its own
  continuation hold (sub-true along the empty relation) and let significance be
  standpoint-invariant. Then the continuation of every standpoint's center has significance from
  every standpoint (`atCenters_least`), and the significance of the centers' continuation
  (`atCenters`) meets both premises (`atCenters_presupposed`, `atCenters_standpointInvariant`):
  what the two premises force is exactly that the centers count (`forced_iff_center`). It is the
  continuation condition exactly when every formation is some standpoint's center
  (`unrestricted_atCenters_iff`). Retaining under it is admitting every center the other path
  admits (`Web.retains_atCenters_iff`).
* **What a standpoint's own presupposition reaches.** Along a relation, what every significance
  making `p`'s presupposition sub-true at `f`'s closure gives significance to is exactly what lies
  within the closure (`forced_iff_within`).
* **Every relation one at a time, and being related at all.** The presupposition sub-true along
  every relation of a family is significance over the union of the closures
  (`subTrue_every_iff`); drawn along being related by some relation of the family (`Related`) it
  gives each of them (`subTrue_every_of_related`), and can say more: in `Chain` the third formation
  lies within the first's closure along being related at all and within no closure along a single
  relation (`Chain.third_related`, `Chain.third_not_within`, `Chain.every_not_related`).
* **Contents held de se and de dicto.** A content held de se is a property of a self, which each
  standpoint holds of its own center (`selfAscribed`); one held de dicto is one proposition from
  every standpoint (`shared`). Standpoint-invariance is exactly holding one shared content
  (`standpointInvariant_iff_shared`); a content held de se is invariant exactly where its readings
  at the centers agree (`selfAscribed_standpointInvariant_iff`). Held de se, the presupposition
  about the own closure along a relation (`ownClosure`) meets every standpoint's presupposition
  (`ownClosure_presupposed`), is invariant exactly where the centers' closures agree
  (`ownClosure_standpointInvariant_iff`) and is the condition exactly where each is the whole
  (`ownClosure_unrestricted_iff`, `ownClosure_unrestricted_of_whole`). Held de dicto, the step
  across standpoints forces exactly the union of the closures (`withinSome`,
  `forced_iff_within_some`; `forced_iff_center` along the empty relation; on a web, admitting what
  either forces is admitting the centers or the union, `Web.admitsWithin_forced_iff`,
  `Web.admitsWithin_forced_within_some_iff`). The two readings agree
  exactly where whatever lies within one center's closure lies within every center's
  (`selfAscribed_iff_withinSome`); in `Divided` they part.
* **Self-concern through dependence.** Held de se, the presupposition is standpoint-invariant,
  and the de se and de dicto readings agree, exactly where the centers lie within one another's
  closures (`CentersWithin`, `ownClosure_standpointInvariant_iff_centersWithin`,
  `selfAscribed_iff_withinSome_iff_centersWithin`); the whole need not lie within them. Centers
  that depend on one condition and exchange with it lie within one another's influence closures,
  and centers that at one step require one condition and give to it lie within one another's
  feeding closures (`Flow.centersWithin_influence_of_common`, `Flow.centersWithin_feeding_of_common`),
  so self-concern held de se along either relation is one from all of them
  (`Flow.ownClosure_influence_invariant_of_common`, `Flow.ownClosure_feeding_invariant_of_common`).
* **What a continuation needs, and copies.** Over possible courses of any type, `f`'s continuation
  needs `g`'s part where `g` takes its part on every possible course on which `f` continues, each
  read off the course (`NeedsPart`); where `f` needs the part of some member of a class and each
  member can take it alone (`NeedsSomePart`, `PartAlone`), it needs the part of a member exactly
  where that member is the only one (`needsPart_iff_only`). With courses marking the formations
  that continue and one reading for both (`Marked`), `f` needs `g` where `g` continues on every
  course on which `f` does (`Needs`, `NeedsSome`, `CarriesAlone`, `needs_iff_only`). Need is then
  its own closure (`withinClosure_needs_iff`), so drawn along need a standpoint's presupposition
  reaches exactly what its continuation needs (`forced_needs_iff`) and a member of a class of
  alternatives exactly where it is the only one (`forced_member_iff_only`): in `Copies` the user
  needs some copy and neither of the two (`Copies.two_copies`).
* **Need on the base.** Read the possible courses of a family of conditions fed only from a class
  as the flows with their webs that balance, in which only active formations give and only members
  of the class give to the family (`Flow.FedOnlyBy`). A formation that draws past the family's
  stock across a stretch (`Flow.DrawsPast`) has some member of the class giving to the family
  within the stretch (`Flow.GivesWithin`, `Flow.needsSome_of_drawsPast`): what was taken beyond
  the stock was given. Where each member can feed the family alone, it needs a given feeder's
  giving exactly where that feeder is the only member (`Flow.needs_giver_iff_only`); on `Feeders`,
  two flows of one condition each fed by one copy, the user needs some feeder's giving and neither
  feeder's (`Feeders.two_feeders`).
* **Which feeders can feed alone, read off a web.** Fix the web and read the possible flows off
  it: each balances on the family within the stretch, only active formations give and only members
  of the class give to the family (`Flow.FedOnlyOn`); the base law holds over them
  (`Flow.needsSome_on`), the law above being its case. A step calls for giving where some
  condition of the family rises or none falls (`Web.CallsForGiving`); there a consumer drawing on
  the family forces giving (`Flow.given_pos_of_calls`), elsewhere it can take the falls with nothing
  given. The flow drawn across the stretch with a picked giver (`Flow.drawnAcross`) shows that every
  member active at every step calling for giving can feed the family alone
  (`Flow.partAlone_on`), so the copies law holds over the web with nothing supplied
  (`Flow.needs_giver_iff_only_on`). Exactly: with activity and identity of formations decided, a
  consumer drawing past the stock needs a member's giving exactly where, at some step of the
  stretch calling for giving, no member other than it is active (`Flow.needs_giver_iff_alone`);
  this includes, vacuously, a step at which no member is active.
  On `Feeders`' web neither copy is needed (`Feeders.two_feeders_on`); in `FeedersInTurn`, two
  copies active in turn, both are (`FeedersInTurn.needs_both`).
* **Capacities of giving.** Supply with the web what each formation can give the family at each
  step (a capacity; the base web has none), and read the possible flows off the two: those read off
  the web in which the formations taking part at each step of the stretch are distinct and each
  gives the family at most its capacity (`Flow.FedOnlyWithin`). A step's demand is what its
  conditions rise, and one more where none falls (`Web.demand`); it is positive exactly where the
  step calls for giving (`Web.callsForGiving_iff_demand_pos`), every balanced flow in which a
  consumer takes from the family gives the family at least that much
  (`Flow.demand_le_replenishment`), and the least flow, with one giver, gives exactly that
  (`Flow.leastDrawn`, `Flow.leastDrawn_given_total`). So a member can feed the family alone exactly
  where, at every step calling for giving, it is active and its capacity covers the demand
  (`Web.CanFeedAlone`, `Flow.feedsAlone_iff`, `Flow.partAlone_within_iff`), and where every member
  can, the copies law holds (`Flow.needs_giver_iff_only_within`). A feeder is needed where, at some
  step, the capacities of the other members active there total less than the demand
  (`Flow.needs_giver_of_short`). In `Capacities` two copies are active throughout and each step
  demands two units: with capacities one and two the second can feed alone and is needed, the first
  cannot and is not (`Capacities.second_alone_first_not`, `Capacities.needs_second`,
  `Capacities.not_needs_first`); with one each, neither can feed alone, both giving feed the
  condition, and the user needs both (`Capacities.neither_alone`, `Capacities.jointly_feeds`,
  `Capacities.needs_both`).
* **Need with capacities, exactly.** Where the members other than a feeder `g` that are active at
  a step can together give its demand (`Web.capacityWithout`), the shares pair the units each
  condition of the family is to be given (`Web.demandAt`) with the units those members can give
  (`Web.otherCapacity`), in order (`Web.shares`, by `unitsOn` and `pairUp`). The flow in which each
  member gives as many units as the shares pair it with (`Flow.sharedDrawn`) balances on the
  family, gives each member at most its capacity, and has the consumer drawing past the stock with
  `g` never giving (`Flow.sharedDrawn_fedOnlyWithin`, `Flow.sharedDrawn_drawsPast`,
  `Flow.sharedDrawn_not_gives`). So, with activity and identity decided and the family and the
  class listed without repetition, a consumer outside the class needs `g`'s giving exactly where,
  at some step of the stretch, what the other active members can give together falls short of the
  demand (`Flow.needs_giver_iff_short`; `Flow.needs_giver_of_short` is one way). In
  `SharedCopies` three copies of one unit each meet a demand of two: none can feed alone, the user
  needs some copy's giving, and no copy's (`SharedCopies.none_alone`, `SharedCopies.needs_some`,
  `SharedCopies.none_needed`).
* **What a feeder can give, read off its own supply.** Where what the formations taking part give a
  family is passed on from a supply, each giving at most what it takes from it (`Flow.PassesOn`),
  the family is given at a step at most what is taken from the supply
  (`Flow.replenishment_le_uptake`); the supply after the step, with what it passed on, holds at
  most what it held and was given (`Flow.passed_le_supply`), so a supply that nothing feeds passes
  on at most what it loses (`Flow.passed_le_drop`), and an exhausted one nothing
  (`Flow.passed_zero_of_exhausted`). Where each feeder gives what it takes from its own store, which
  nothing feeds (`Flow.FedFromStores`), what it takes is at most what the store falls
  (`Flow.take_le_storeFall`), so the flows are read off the web with capacities, each feeder's
  capacity at a step being its store's fall (`Web.storeFall`, `Flow.fedFromStores_within`): the
  capacity is read off the web. Where the stores are the feeders' own, lie outside the family and
  do not rise within the stretch, the exact law of need holds with these capacities
  (`Flow.needs_giver_iff_store_short`, by `Flow.storeDrawn`, the shared flow in which each feeder
  also takes its store's fall). In `OwnStores` the second feeder's store runs out after one step,
  from then on it gives nothing (`OwnStores.second_spent`), and the user needs the first feeder and
  not the second (`OwnStores.needs_first`, `OwnStores.not_needs_second`).
* **Need up a hierarchy.** A hierarchy is a family with families above it, in order (`topTier`,
  `Web.stockTiers`). Over a stretch in which every family balances and is given only what is passed
  on from the family above it (`Flow.BalancesTiers`, `Flow.PassesTiers`), what is drawn from the
  bottom is at most what the whole hierarchy held and what was given to its top
  (`Flow.uptake_le_tiers`). So, where only active formations give and only a class gives to the top
  (`Flow.FedThroughTiers`), a formation drawing past what the whole hierarchy holds
  (`Flow.DrawsPastTiers`) needs some member of that class (`Flow.needsSome_tiers`); with no family
  above the bottom it is `Flow.needsSome_on`. In `TwoTiers` a user draws on a condition a feeder
  gives to, passing on what it takes from its supply, which a source gives to: the user needs the
  source's giving to the supply (`TwoTiers.needs_source`, `TwoTiers.possible`).
* **Need in degree.** A feeder's shortfall at a step is what the step demands beyond what the
  other active members can give together (`Web.shortfall`). In every flow read off a web with
  capacities in which a consumer draws past the stock, the family is given what the others give
  and what the feeder gives (`Flow.givenFrom`, `Flow.replenishment_split`), the others give at
  most what they can together (`Flow.others_le_capacityWithout`), so the feeder gives at each step
  at least its shortfall (`Flow.shortfall_le_givenFrom`, `Flow.shortfalls_le_given`). Where it can
  give each of its shortfalls, the flow in which its capacity is its shortfall
  (`Web.shortCapacity`, `Flow.gradedDrawn`) has it give exactly that (`Flow.least_giving`). So,
  wherever some flow lets the consumer draw past the stock, the least a feeder gives is the sum of
  its shortfalls, its degree of need (`Flow.least_giving_of_possible`), and a feeder is needed
  exactly where that degree is positive (`Flow.needs_giver_iff_shortfalls_pos`). In `Capacities`
  the user needs the second copy in degree one and the first in degree zero
  (`Capacities.second_in_degree`).
* **When a consumer can draw past the stock at all.** Some flow read off a web with capacities
  lets the consumer draw past the stock exactly where, at every step of the stretch, the class can
  give the step's demand (`Flow.possible_iff_covers`, with `Flow.covers_of_drawsPast`); elsewhere
  every need holds vacuously (`Flow.needs_of_class_short`, by `needsPart_of_none`). Wherever a flow is possible, each member can
  give its shortfall (`Flow.capacityWithout_split`, `Flow.able_of_covers`), so its degree of need is
  attained (`Flow.least_giving_of_possible`). Drawing without end needs giving without end: a
  consumer drawing at every step from `T` has, after every step `N`, some member giving within the
  next `stock N + 1` steps (`Flow.needsSome_without_end`). In `FeedersInTurn` a flow is possible,
  so the user's need of both copies is not vacuous (`FeedersInTurn.possible`).
* **Need in degree from the stores.** With capacities read off the feeders' own stores the degree
  law's bound holds as well: every flow from the stores in which the consumer draws past the stock
  has each member give at least the sum of its shortfalls under the stores' falls, and where a
  member can give each of them, the graded flow from the stores (`Flow.gradedStoreDrawn`), in which
  each member also takes its store's fall, has it give exactly that (`Flow.least_giving_from_stores`). In `OwnStores` the
  user needs the first feeder in degree two and the second in degree zero
  (`OwnStores.first_in_degree`).
* **Need across two tiers.** Where a family, balancing across the stretch, is fed only from lower
  members, each giving at most what it takes from its own store, only active formations giving and
  each taking part at most once a step, and the stores balance and are given only by upper members,
  each within its capacity however it divides its giving among them (`Flow.FedThroughStores`), what is taken from
  a store that balances is what it falls and what it is given beyond what it rises
  (`Flow.taken_store`), and the stores together are given at least what they rise
  (`Flow.storesRisen_le_given`). So where `e`, if it takes part, gives nothing into the hierarchy
  (`Flow.GivesInto`), what the stores rise is within what the other upper members can give
  (`Flow.storesRisen_le_capacity`), and the family is given at most what the others could give it
  through the hierarchy: the falls of the other active lower members' stores and, while one of
  them is active to route it, what the other upper members can give beyond what the stores rise
  (`Web.othersThrough`, `Flow.replenishment_le_othersThrough`). Where at every step the others can
  do both, the routed flow (`Flow.routedDrawn`), in which the upper members give each store what it
  rises and the router's store also what is routed (`Web.storeNeed`, `Flow.routedGive_store`,
  `Flow.routedGive_le`), is a flow of the hierarchy in which `e` gives nothing
  (`Flow.routedDrawn_fedThroughStores`, `Flow.routedDrawn_not_gives`). So `f` drawing past the
  stock needs `e`'s giving into the hierarchy exactly where, at some step, the other upper members
  cannot give what the stores rise or the others cannot give the demand through the hierarchy
  (`Flow.needs_iff_through_short`). In `Routing` the user needs a lone upper member
  (`Routing.top_needed`) and a lone lower member that holds nothing, through which everything must
  pass (`Routing.lone_router_needed`), but neither of two lower members
  (`Routing.router_not_needed`); it needs neither of two upper members
  (`Routing.tops_not_needed`) until a lower store rises and takes what the other could have routed,
  and then each (`Routing.rise_needs_top`). Where a store rises that only one upper member can
  give, the user needs that member though the others could feed it through the hierarchy
  (`Routing.fill_needs_top`): need is read off the whole web as given. In each of these settings a
  flow is possible, so none of these needs is vacuous (`Routing.possible`; for the first,
  `Routing.router_not_needed`).
* **Need and feeding, read with time.** Over any flows read off a web in which only active
  formations give, a formation active at no step of the stretch is needed exactly where no such flow
  lets the consumer draw past the stock (`Flow.needs_iff_none_of_inactive`; across two tiers
  `Flow.needs_into_iff_none_of_inactive`): need reaches only what is active within the stretch it is
  read across. Read with time, each link no later than the one it feeds (`Flow.FedUpTo`,
  `Flow.WithinFeedingUpTo`), a formation's feeding closure up to a step holds, besides it, only what
  takes part and gives at some step up to that one (`Flow.gives_of_withinFeedingUpTo`), so where only
  active formations give, only what is active by then (`Flow.active_of_withinFeedingUpTo`); it lies
  within the feeding closure read across every step (`Flow.withinFeeding_of_upTo`), which can run
  past the end of what it carries: of three formations overlapping in turn, the last lies within the
  first's feeding closure but not within that closure read with time up to the first's last step, and
  the first does not need its giving (`Overlapping.closure_overreaches`).
* **What self-concern alone ranks.** An order is increasing in its own continuation when it ranks
  higher every widening that adds to the items its own continuation marks (`Weighting.AddsOwn`,
  `Weighting.IncreasingInOwn`). Every order increasing in admission is one, and where its own
  continuation marks every listed item the two coincide (`Weighting.increasingInOwn_of_increasing`,
  `Weighting.increasingInOwn_iff_increasing`). Every such order ranks `a` above `b` exactly where
  `a` widens `b` and adds to its own continuation (`Weighting.widensOwn_iff_every_increasingInOwn`);
  where `a` adds to it, exactly where `b` keeps nothing beyond `a`
  (`Weighting.every_increasingInOwn_iff_includes`), and where `b` keeps an item beyond, some such
  order ranks `b` higher (`Weighting.some_increasingInOwn_reverses`). So a course that admits
  nothing from an ending on, and agrees with `a` before it, is ranked below `a` from every
  standpoint whose own continuation `a` adds to (`Weighting.ended_below`). Joined with coupled
  ending in one theorem: under the premises of `GroupEnding.Flow.family_childless`, with every
  member of every generation from the excess on depending on the coupled family, no later
  generation has a member, and a course admitting only members of their generation is ranked below,
  by every order increasing in a standpoint's own continuation, every course agreeing with it up to
  the ending and adding to that continuation (`Flow.coupled_ending_ranked_below`).
* **Standing and grades.** A graded significance gives each item a natural grade from each
  standpoint; its standing is whether the grade is positive. Invariant grades have invariant
  standing (`Weighting.standingInvariant_of_gradeInvariant`) and rank alike from every standpoint
  (`Weighting.ranks_alike_of_gradeInvariant`); in `Partial` standing is invariant and the grades
  are not, and two standpoints rank a mixed comparison opposite ways.
* **Levels of continuation, priority and sufficiency.** A formation's level in a course is how
  many of its listed items the course admits (`Weighting.level`). A sum of a strictly increasing
  transform of levels ranks every widening higher (`Weighting.prior_lt_of_widens`). A transform
  strictly concave up to a bound (`Weighting.ConcaveTo`; none is strictly concave on all whole
  numbers) ranks higher a course that moves one step of continuation from a formation to one at
  least two levels below it, the higher within the bound, a comparison C leaves mixed (`Weighting.prior_transfer`; in
  `LevelTransfer` the sum of levels ties the two courses and a convex transform ranks them the
  other way). A transform that rises no further from a threshold weighs alike two courses whose
  levels differ only at or above it (`Weighting.sufficient_ties`).
* **Where the narrower scope and the condition part.** In `Clearing`, with the clearer the only
  standpoint's center, the clearer's part retains what has significance at the centers, while
  under the continuation condition it loses the dweller (`Clearing.centers_retain_yet_loses`).

**Reading (the AI's; the argument is in the chapter
`theories/becoming/history/THE-STEP-OF-INVARIANCE.md`).** Read a
positive weighting, or any order increasing in admission, as one standpoint's order, partial in how much it weighs each formation's
possibility but counting all of them, and the order every such standpoint shares as the impartial
order. Then the impartial order is exactly C, the comparisons partiality may decide are exactly the
mixed ones, a weight of zero is a denial of scope, and a weighting the same for every formation
counts numbers. Read the centers as the formations that hold their own continuation significant
(what "wants its continuation"); then the step across standpoints, Gewirth's step, gives
significance to exactly them, and "anything" needs a further premise, that every formation is a
center or lies within some center's closure.

Read a content held de se as Lewis's self-ascribed property and one held de dicto as a
proposition. Then the step across standpoints is exactly the de dicto reading of the self's
presupposition, the de se reading gives each center its own closure, and the two part exactly
where centers' closures differ: drawn along being related at all in a connected unfolding they
agree, so the de se question has force only together with a drawing along a narrower relation.

Read the relation a self is drawn along as one its continuation is carried along: what feeds it,
or what it needs. Then where the centers depend on one another along it, the de se question
decides nothing within their common closure, since each center's own closure is that closure,
and the step of invariance has work only beyond it. Drawn along need, self-concern reaches a copy
of what it needs only where the copy is the only one, when each copy could carry the need alone,
so with many such copies the presupposition reaches the class and none of them, and with one it
reaches that one. With capacities a copy counts by what it can give: a consumer needs a feeder
exactly where the others together could not give what a step demands, so two copies that can each
give only part of it are both needed, three of one unit each against a demand of two leave none
needed, and redundancy is a matter of capacity, not of number. Read a feeder's capacity as what its
own supply passes on: a feeder whose store runs out is no copy from then on, and drawing past what
a hierarchy fed only at its top holds needs giving into that top. Read the need of these laws on
flows as what self-concern drawn along need reaches: the presupposition reaches exactly what is
needed where need is its own closure (the marked case), and need with two readings is not, so the
reading carries the reach over without a theorem; on it, self-concern's reach is not bounded by the
families a center draws on directly. Read a feeder's degree of need as the grade with which
self-concern so drawn reaches it: need itself is its standing, a positive degree, and the degree is
how much the center's continuation draws on it beyond what the others could give. Read an order
increasing in
its own continuation as self-concern's monotonicity, weaker than C's premise: it already ranks the
ending of a condition everything needs below every course that keeps the standpoint and agrees
before the ending, from every standpoint, and it ranks no comparison in which the other course
keeps something beyond, as a copy that continues independently of the ended condition does.
Drawn so that its own continuation is everything listed, it is C's premise.

Read a presentation as a plan as it is told and a ranking of presentations as a valuer's
judgment. Then T5's exception is `narrower_above_net` and `reads_increasingAt`: a valuer that reads
the case right ranks a narrowing above its widening only where the added formation weighs at zero
or below for it, zero giving a tie; otherwise the case was misread or framed. A sign measured apart
predicts the judgment exactly where it is the sign of the joint increment (`reads_increment`), which
an additive valuation carries from one context to every other and an interacting one need not:
where the two part, separate and joint evaluation part (Hsee). Read the ratio within which a
valuer's weights stand as how nearly alike it weighs everything at stake: valuers whose weights
stand within `r` of each other all rank the larger side of a mixed comparison higher where what it
alone keeps exceeds `r` times what the other alone keeps. Their disagreement needs weights
dispersed past that ratio, and it is easiest where the two sides alone keep alike in number.

Read a grade's positivity as standing (whether a formation counts) and the grade as status (how
much): the step, applied to two-valued significance, makes standing invariant and leaves status
to each standpoint; status invariant is a further premise. Read a formation's level as how long
its continuation is admitted: priority to the worse off agrees with C wherever C ranks and
decides transfers C leaves mixed; a threshold of sufficiency is read as a denial of scope above it.

What is not derived: whether the self's presupposition is held de se; that a standpoint's order
is increasing in admission (monotonicity, and that it counts every item, are supplied; additivity
is not needed for the shared order); which weighting a standpoint has; whether a valuer reads the
sets of a case, whether its sign measured apart is the sign of the joint increment, and how
dispersed its weights are, each measurable and none derived; that the impartial order is what
every standpoint shares rather than one privileged weighting; which formations are centers; the
step of invariance itself; which relation a continuation is carried along, whether actual centers
depend on one another, which webs actual families have and what each formation can give at a step
(the capacities are supplied with the web, or read off stores the web is given with), which
families form a hierarchy and that nothing enters one below its top, the decision of activity and
identity the exact law of need uses, and that a standpoint's order is increasing in its own
continuation.
Read as coreflexive relations on the listed items (`Weighting.admittedOn`), including, exceeding,
widening and being mixed are the grammar's (`Weighting.includesOn_iff`, `Weighting.exceedsOn_iff`,
`Weighting.widensOn_iff`, `Weighting.mixedOn_iff`, of `Becoming.GrammarLaws`), and widening's
order laws are the grammar's (`Weighting.WidensOn.not_reverse`, `Weighting.WidensOn.trans`).
The representation commits to finite listings of steps and formations, two-valued admission and
natural-number weights. No ethical predicate or axiom occurs.
-/

namespace Becoming

/-! ## Weighted counts of what a course admits -/

namespace Weighting

variable {X : Type}

/-- The weighted count of the listed items a course admits: each admitted item counts its
weight. -/
def weighed (items : List X) (w : X → Nat) (a : X → Bool) : Nat :=
  total items fun x => cond (a x) (w x) 0

/-- A weighting is positive on the listed items: it counts every one of them. -/
def Positive (items : List X) (w : X → Nat) : Prop :=
  ∀ x, x ∈ items → 0 < w x

/-- On the listed items, `a` admits every item `b` admits. -/
def IncludesOn (items : List X) (a b : X → Bool) : Prop :=
  ∀ x, x ∈ items → b x = true → a x = true

/-- On the listed items, `a` admits an item `b` does not. -/
def ExceedsOn (items : List X) (a b : X → Bool) : Prop :=
  ∃ x, x ∈ items ∧ a x = true ∧ b x = false

/-- On the listed items, `a` widens `b`: it admits every item `b` admits, and one more. -/
def WidensOn (items : List X) (a b : X → Bool) : Prop :=
  IncludesOn items a b ∧ ExceedsOn items a b

/-- On the listed items, `a` and `b` are mixed: each admits an item the other does not. -/
def MixedOn (items : List X) (a b : X → Bool) : Prop :=
  ExceedsOn items a b ∧ ExceedsOn items b a

/-! ### The comparisons on the grammar

What a course admits among the listed items is a coreflexive relation (a partial identity, the
standard representation of a set by a relation): each listed item it admits is related to itself
and nothing else is related (`admittedOn`). Read so, including, exceeding, widening and being
mixed are the grammar's `«则»`, `«逾»`, `«广»` and `«杂»`, both ways and with no hypothesis, and
the order laws of widening are the grammar's (`«广不可逆»`, `«广之传递»`), as for the paths of a
web (`Web.admitted`). -/

/-- What `a` admits among the listed items, as a coreflexive relation. -/
def admittedOn (items : List X) (a : X → Bool) : «际» X :=
  fun x y => x = y ∧ x ∈ items ∧ a x = true

/-- **Including on the listed items is the grammar's inclusion** (`«则»`), both ways. -/
theorem includesOn_iff {items : List X} {a b : X → Bool} :
    IncludesOn items a b ↔ «则» (admittedOn items b) (admittedOn items a) :=
  ⟨fun includes _ _ ⟨e, listed, admits⟩ => ⟨e, listed, includes _ listed admits⟩,
   fun inside x listed admits => (inside x x ⟨rfl, listed, admits⟩).2.2⟩

/-- **Exceeding on the listed items is the grammar's** (`«逾»`), both ways. -/
theorem exceedsOn_iff {items : List X} {a b : X → Bool} :
    ExceedsOn items a b ↔ «逾» (admittedOn items a) (admittedOn items b) :=
  ⟨fun ⟨x, listed, admits, not⟩ => ⟨x, x, ⟨rfl, listed, admits⟩,
      fun ⟨_, _, other⟩ => Bool.noConfusion (not.symm.trans other)⟩,
   fun ⟨x, _, ⟨e, listed, admits⟩, not⟩ => ⟨x, listed, admits, match h : b x with
      | true => absurd ⟨e, listed, h⟩ not
      | false => rfl⟩⟩

/-- **Widening on the listed items is the grammar's** (`«广»`), both ways. -/
theorem widensOn_iff {items : List X} {a b : X → Bool} :
    WidensOn items a b ↔ «广» (admittedOn items a) (admittedOn items b) :=
  ⟨fun ⟨includes, exceeds⟩ => ⟨includesOn_iff.mp includes, exceedsOn_iff.mp exceeds⟩,
   fun ⟨inside, exceeds⟩ => ⟨includesOn_iff.mpr inside, exceedsOn_iff.mpr exceeds⟩⟩

/-- **Being mixed on the listed items is the grammar's** (`«杂»`), both ways. -/
theorem mixedOn_iff {items : List X} {a b : X → Bool} :
    MixedOn items a b ↔ «杂» (admittedOn items a) (admittedOn items b) :=
  ⟨fun ⟨one, other⟩ => ⟨exceedsOn_iff.mp one, exceedsOn_iff.mp other⟩,
   fun ⟨one, other⟩ => ⟨exceedsOn_iff.mpr one, exceedsOn_iff.mpr other⟩⟩

/-- Widening on the listed items goes one way (`«广不可逆»`). -/
theorem WidensOn.not_reverse {items : List X} {a b : X → Bool} (widens : WidensOn items a b) :
    ¬ WidensOn items b a :=
  fun back => «广不可逆» (widensOn_iff.mp widens) (widensOn_iff.mp back)

/-- Widening on the listed items is transitive (`«广之传递»`). -/
theorem WidensOn.trans {items : List X} {a b c : X → Bool} (first : WidensOn items a b)
    (second : WidensOn items b c) : WidensOn items a c :=
  widensOn_iff.mpr («广之传递» (widensOn_iff.mp first) (widensOn_iff.mp second))

theorem term_le {w : Nat} : ∀ {a b : Bool}, (b = true → a = true) → cond b w 0 ≤ cond a w 0
  | _, false, _ => Nat.zero_le _
  | true, true, _ => Nat.le_refl w
  | false, true, kept => Bool.noConfusion (kept rfl)

theorem term_lt {w : Nat} (positive : 0 < w) :
    ∀ {a b : Bool}, a = true → b = false → cond b w 0 < cond a w 0
  | _, _, rfl, rfl => positive

theorem term_lt_of {m n : Nat} : ∀ {v : Bool}, v = true → m < n → cond v m 0 < cond v n 0
  | _, rfl, lt => lt

theorem term_eq_at {m n : Nat} : ∀ {v : Bool}, (v = true → m = n) → cond v m 0 = cond v n 0
  | true, same => same rfl
  | false, _ => rfl

theorem cond_one_pos : ∀ {v : Bool}, v = true → 0 < cond v 1 0
  | _, rfl => Nat.succ_pos 0

theorem total_lt {p q : X → Nat} :
    ∀ {as : List X}, (∀ a, a ∈ as → p a ≤ q a) → (∃ a, a ∈ as ∧ p a < q a) →
      total as p < total as q
  | [], _, ⟨_, mem, _⟩ => nomatch mem
  | a :: as, le, ⟨b, mem, lt⟩ => match mem_cons_cases mem with
    | .inl same =>
      Nat.add_lt_add_of_lt_of_le (Eq.subst (motive := fun y => p y < q y) same lt)
        (total_le as fun c listed => le c (.tail a listed))
    | .inr rest =>
      Nat.add_lt_add_of_le_of_lt (le a (.head as))
        (total_lt (fun c listed => le c (.tail a listed)) ⟨b, rest, lt⟩)

/-- **Inclusion never lowers a weighted count**, whatever the weights. -/
theorem weighed_le_of_includes {items : List X} {a b : X → Bool} (w : X → Nat)
    (includes : IncludesOn items a b) : weighed items w b ≤ weighed items w a :=
  total_le items fun x listed => term_le (includes x listed)

/-! ### What each course admits beyond the other -/

/-- What `a` admits beyond `b`: the items `a` admits and `b` does not. -/
def beyond (a b : X → Bool) : X → Bool :=
  fun x => a x && !b x

/-- The number of listed items a course admits. -/
def size (items : List X) (a : X → Bool) : Nat :=
  weighed items (fun _ => 1) a

theorem term_split (v : Nat) : ∀ p q : Bool, cond p v 0 = cond (p && q) v 0 + cond (p && !q) v 0
  | true, true => rfl
  | true, false => (Nat.zero_add v).symm
  | false, _ => rfl

theorem and_swap : ∀ p q : Bool, (p && q) = (q && p)
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

/-- **A weighted count is what a course shares with another and what it admits beyond it.** -/
theorem weighed_split (items : List X) (w : X → Nat) (a b : X → Bool) :
    weighed items w a = weighed items w (fun x => a x && b x) + weighed items w (beyond a b) :=
  (total_congr (fun x => term_split (w x) (a x) (b x)) items).trans (total_add _ _ items)

theorem weighed_shared (items : List X) (w : X → Nat) (a b : X → Bool) :
    weighed items w (fun x => a x && b x) = weighed items w (fun x => b x && a x) :=
  total_congr (fun x => congrArg (fun v => cond v (w x) 0) (and_swap (a x) (b x))) items

theorem weighed_split_right (items : List X) (w : X → Nat) (a b : X → Bool) :
    weighed items w b = weighed items w (fun x => a x && b x) + weighed items w (beyond b a) :=
  (weighed_split items w b a).trans
    (congrArg (· + weighed items w (beyond b a)) (weighed_shared items w b a))

theorem add_le_add_iff {k m n : Nat} : k + m ≤ k + n ↔ m ≤ n :=
  ⟨fun le => Nat.le_of_lt_succ (Nat.lt_of_add_lt_add_left (Nat.lt_succ_of_le le)),
   fun le => Nat.add_le_add_left le k⟩

/-- **Two courses compare as what each admits beyond the other**, whatever the weights: what they
share weighs the same in both. -/
theorem weighed_lt_iff_beyond (items : List X) (w : X → Nat) (a b : X → Bool) :
    weighed items w b < weighed items w a ↔
      weighed items w (beyond b a) < weighed items w (beyond a b) := by
  rw [weighed_split_right items w a b, weighed_split items w a b]
  exact Naturals.add_lt_add_left_iff

theorem weighed_le_iff_beyond (items : List X) (w : X → Nat) (a b : X → Bool) :
    weighed items w b ≤ weighed items w a ↔
      weighed items w (beyond b a) ≤ weighed items w (beyond a b) := by
  rw [weighed_split_right items w a b, weighed_split items w a b]
  exact add_le_add_iff

theorem beyond_term_zero (v : Nat) : ∀ {p q : Bool}, (q = true → p = true) → cond (q && !p) v 0 = 0
  | _, false, _ => rfl
  | true, true, _ => rfl
  | false, true, kept => Bool.noConfusion (kept rfl)

/-- Nothing a course admits beyond one that includes it weighs anything. -/
theorem weighed_beyond_of_includes {items : List X} {a b : X → Bool} (w : X → Nat)
    (includes : IncludesOn items a b) : weighed items w (beyond b a) = 0 :=
  (total_congr_on fun x listed => beyond_term_zero (w x) (includes x listed)).trans (total_zero items)

theorem cond_mul (k : Nat) : ∀ v : Bool, cond v k 0 = k * cond v 1 0
  | true => (Nat.mul_one k).symm
  | false => (Nat.mul_zero k).symm

/-- Under one weight `k` for every item, the weighted count is `k` times the number of listed
items admitted. -/
theorem weighed_const (k : Nat) (items : List X) (a : X → Bool) :
    weighed items (fun _ => k) a = k * weighed items (fun _ => 1) a :=
  (total_congr (fun x => cond_mul k (a x)) items).trans
    (total_mul k (fun x => cond (a x) 1 0) items)

theorem mul_lt_mul_iff {k m n : Nat} (positive : 0 < k) : m * k < n * k ↔ m < n :=
  ⟨fun lt => Naturals.lt_of_mul_lt_mul_left (m := k)
      (Eq.subst (motive := fun x => x < k * n) (Nat.mul_comm m k)
        (Eq.subst (motive := fun y => m * k < y) (Nat.mul_comm n k) lt)),
   fun lt => Eq.subst (motive := fun x => x < n * k) (Nat.mul_comm k m)
      (Eq.subst (motive := fun y => k * m < y) (Nat.mul_comm k n) (Naturals.mul_lt_mul_of_pos positive lt))⟩

/-! ### Net weightings: items that weigh below zero -/

/-- The order of a net weighting: each listed item counts `pos` for a course that admits it and
`neg` against it, so it weighs above zero where `neg x < pos x`, at zero where they are equal and
below zero where `pos x < neg x`. `a` is ranked above `b` where what `a` gains less what it loses
exceeds `b`'s, compared without subtraction. A weighting is the net weighting with nothing
against. -/
def ranksNet (items : List X) (pos neg : X → Nat) : (X → Bool) → (X → Bool) → Prop :=
  fun b a => weighed items pos b + weighed items neg a < weighed items pos a + weighed items neg b

/-- **A net weighting ranks two courses by what each admits beyond the other**: what they share
gains and loses the same in both. -/
theorem ranksNet_iff_beyond (items : List X) (pos neg : X → Nat) (a b : X → Bool) :
    ranksNet items pos neg b a ↔
      weighed items pos (beyond b a) + weighed items neg (beyond a b) <
        weighed items pos (beyond a b) + weighed items neg (beyond b a) := by
  show weighed items pos b + weighed items neg a < weighed items pos a + weighed items neg b ↔ _
  rw [weighed_split_right items pos a b, weighed_split items neg a b, weighed_split items pos a b,
    weighed_split_right items neg a b,
    Nat.add_add_add_comm (weighed items pos fun x => a x && b x) (weighed items pos (beyond b a)),
    Nat.add_add_add_comm (weighed items pos fun x => a x && b x) (weighed items pos (beyond a b))]
  exact Naturals.add_lt_add_left_iff

theorem beyond_lt {items : List X} {pos neg : X → Nat} {a b : X → Bool}
    (above : ∀ x, x ∈ items → a x = true → b x = false → neg x < pos x)
    (exceeds : ExceedsOn items a b) :
    weighed items neg (beyond a b) < weighed items pos (beyond a b) :=
  match exceeds with
  | ⟨x, listed, admits, not⟩ =>
    total_lt (fun y member => ListTests.cond_zero_le fun held => match bool_of_and_true held with
        | ⟨admits', not'⟩ => Nat.le_of_lt (above y member admits' (ListTests.false_of_not not')))
      ⟨x, listed, term_lt_of (bool_and_true admits (congrArg (!·) not)) (above x listed admits not)⟩

/-- **Every net weighting under which each item a widening adds weighs above zero ranks the
widening higher.** -/
theorem ranksNet_lt_of_widens {items : List X} {pos neg : X → Nat} {a b : X → Bool}
    (above : ∀ x, x ∈ items → a x = true → b x = false → neg x < pos x)
    (widens : WidensOn items a b) : ranksNet items pos neg b a := by
  apply (ranksNet_iff_beyond items pos neg a b).mpr
  rw [weighed_beyond_of_includes pos widens.1, weighed_beyond_of_includes neg widens.1,
    Nat.zero_add, Nat.add_zero]
  exact beyond_lt above widens.2

theorem cond_zero : ∀ v : Bool, cond v 0 0 = 0
  | true => rfl
  | false => rfl

theorem weighed_zero (items : List X) (a : X → Bool) : weighed items (fun _ => 0) a = 0 :=
  (total_congr (fun x => cond_zero (a x)) items).trans (total_zero items)

/-- **Every positive weighting ranks a widening higher**: the net weighting with nothing
against. -/
theorem weighed_lt_of_widens {items : List X} {a b : X → Bool} {w : X → Nat}
    (positive : Positive items w) (widens : WidensOn items a b) :
    weighed items w b < weighed items w a := by
  have net := ranksNet_lt_of_widens (neg := fun _ => 0) (fun x listed _ _ => positive x listed) widens
  rw [ranksNet, weighed_zero, weighed_zero] at net
  exact net

/-- **A weight of zero on what a course adds ties it with the course it includes**: where every
item `a` admits beyond `b` weighs nothing, the weighted counts agree, so a widening that adds
only such items is not ranked. -/
theorem weighed_eq_of_unweighted {items : List X} {a b : X → Bool} {w : X → Nat}
    (includes : IncludesOn items a b)
    (unweighted : ∀ x, x ∈ items → a x = true → b x = false → w x = 0) :
    weighed items w a = weighed items w b :=
  total_congr_on fun x listed => match ha : a x, hb : b x with
    | true, true => rfl
    | true, false => unweighted x listed ha hb
    | false, false => rfl
    | false, true => Bool.noConfusion (ha.symm.trans (includes x listed hb))

/-- On the listed items `a` widens `b` by `x` alone: it admits every item `b` admits and `x`,
which is listed and which `b` does not admit, and nothing else beyond `b`. -/
def WidensBy (items : List X) (x : X) (a b : X → Bool) : Prop :=
  IncludesOn items a b ∧ x ∈ items ∧ a x = true ∧ b x = false ∧
    ∀ y, y ∈ items → a y = true → b y = false → y = x

theorem widensOn_of_widensBy {items : List X} {x : X} {a b : X → Bool}
    (by_ : WidensBy items x a b) : WidensOn items a b :=
  ⟨by_.1, x, by_.2.1, by_.2.2.1, by_.2.2.2.1⟩

/-- Under a widening by one item, what is admitted beyond weighs that item's weight once for
each time it is listed. -/
theorem weighed_widensBy {items : List X} {x : X} {a b : X → Bool} (w : X → Nat)
    (by_ : WidensBy items x a b) :
    weighed items w (beyond a b) = w x * size items (beyond a b) :=
  (total_congr_on fun y listed => term_eq_at fun held => match bool_of_and_true held with
    | ⟨admits, not⟩ => congrArg w (by_.2.2.2.2 y listed admits (ListTests.false_of_not not))).trans
    (weighed_const (w x) items (beyond a b))

theorem size_widensBy_pos {items : List X} {x : X} {a b : X → Bool}
    (by_ : WidensBy items x a b) : 0 < size items (beyond a b) :=
  total_pos_of_mem by_.2.1 (cond_one_pos (bool_and_true by_.2.2.1 (congrArg (!·) by_.2.2.2.1)))

/-- **A net weighting ranks a widening by one item as that item weighs**, whatever else either
course keeps: the widening above exactly where the item weighs above zero, below exactly where it
weighs below zero. -/
theorem ranksNet_widensBy {items : List X} {pos neg : X → Nat} {x : X} {a b : X → Bool}
    (by_ : WidensBy items x a b) :
    (ranksNet items pos neg b a ↔ neg x < pos x) ∧ (ranksNet items pos neg a b ↔ pos x < neg x) := by
  have m := size_widensBy_pos by_
  have up : weighed items pos (beyond b a) + weighed items neg (beyond a b) <
      weighed items pos (beyond a b) + weighed items neg (beyond b a) ↔ neg x < pos x := by
    rw [weighed_beyond_of_includes pos by_.1, weighed_beyond_of_includes neg by_.1, Nat.zero_add,
      Nat.add_zero, weighed_widensBy pos by_, weighed_widensBy neg by_]
    exact mul_lt_mul_iff m
  have down : weighed items pos (beyond a b) + weighed items neg (beyond b a) <
      weighed items pos (beyond b a) + weighed items neg (beyond a b) ↔ pos x < neg x := by
    rw [weighed_beyond_of_includes pos by_.1, weighed_beyond_of_includes neg by_.1, Nat.zero_add,
      Nat.add_zero, weighed_widensBy pos by_, weighed_widensBy neg by_]
    exact mul_lt_mul_iff m
  exact ⟨(ranksNet_iff_beyond items pos neg a b).trans up,
    (ranksNet_iff_beyond items pos neg b a).trans down⟩

/-- **An item weighing zero ties.** Under a net weighting, a widening by one item weighing zero is
ranked neither above nor below what it widens. -/
theorem ranksNet_ties {items : List X} {pos neg : X → Nat} {x : X} {a b : X → Bool}
    (by_ : WidensBy items x a b) (zero : pos x = neg x) :
    ¬ ranksNet items pos neg b a ∧ ¬ ranksNet items pos neg a b :=
  ⟨fun ranked => Nat.lt_irrefl (neg x)
      (Eq.subst (motive := fun n => neg x < n) zero ((ranksNet_widensBy by_).1.mp ranked)),
   fun ranked => Nat.lt_irrefl (neg x)
      (Eq.subst (motive := fun n => n < neg x) zero ((ranksNet_widensBy by_).2.mp ranked))⟩

/-- An order on courses increases at `x`: it ranks every course that `x` alone widens strictly
above what it widens, and never below it. -/
def IncreasingAt (items : List X) (O : (X → Bool) → (X → Bool) → Prop) (x : X) : Prop :=
  ∀ a b, WidensBy items x a b → O b a ∧ ¬ O a b

/-- A net weighting increases at every listed item that weighs above zero. -/
theorem ranksNet_increasingAt {items : List X} {pos neg : X → Nat} {x : X}
    (above : neg x < pos x) : IncreasingAt items (ranksNet items pos neg) x :=
  fun _ _ by_ => ⟨(ranksNet_widensBy by_).1.mpr above,
    fun ranked => Nat.lt_asymm above ((ranksNet_widensBy by_).2.mp ranked)⟩

/-- The sign of an order's increment from `b` to `a`: `.gt` where it ranks `a` strictly above
`b`, `.lt` where strictly below, `.eq` where neither above the other. -/
def IncrementIs (O : (X → Bool) → (X → Bool) → Prop) (b a : X → Bool) : Ordering → Prop
  | .gt => O b a ∧ ¬ O a b
  | .eq => ¬ O b a ∧ ¬ O a b
  | .lt => O a b ∧ ¬ O b a

/-- Two orders that rank two pairs alike, each way, give their increments the same sign. -/
theorem increment_transfer {O O' : (X → Bool) → (X → Bool) → Prop} {a b a' b' : X → Bool}
    (up : O b a ↔ O' b' a') (down : O a b ↔ O' a' b') :
    ∀ {o : Ordering}, IncrementIs O b a o → IncrementIs O' b' a' o
  | .gt, ⟨above, not⟩ => ⟨up.mp above, fun r => not (down.mpr r)⟩
  | .eq, ⟨not, not'⟩ => ⟨fun r => not (up.mpr r), fun r => not' (down.mpr r)⟩
  | .lt, ⟨below, not⟩ => ⟨down.mp below, fun r => not (up.mpr r)⟩

/-- **A net weighting's increment at an item is the same in every context**: whatever else two
pairs of courses keep, where each widens by the same item alone, the sign of the increment is
the same. -/
theorem ranksNet_increment_alike {items : List X} {pos neg : X → Nat} {x : X}
    {a b a' b' : X → Bool} (by_ : WidensBy items x a b) (by' : WidensBy items x a' b')
    {o : Ordering} (increment : IncrementIs (ranksNet items pos neg) b a o) :
    IncrementIs (ranksNet items pos neg) b' a' o :=
  increment_transfer ((ranksNet_widensBy by_).1.trans (ranksNet_widensBy by').1.symm)
    ((ranksNet_widensBy by_).2.trans (ranksNet_widensBy by').2.symm) increment

/-! ### Rankings of presentations -/

variable {P : Type}

/-- A ranking of presentations reads the sets on the pair `a`, `b`: it ranks them, each way, as
the order `O` ranks the courses they keep. A presentation is a plan with its wording and the
order in which it is told; `kept` gives the course it keeps; `R b a` reads "`a` is ranked above
`b`". -/
def ReadsSetsOn (kept : P → X → Bool) (R : P → P → Prop) (O : (X → Bool) → (X → Bool) → Prop)
    (a b : P) : Prop :=
  (R b a ↔ O (kept b) (kept a)) ∧ (R a b ↔ O (kept a) (kept b))

/-- A ranking of presentations reads the sets: on every pair it ranks as `O` ranks the courses
kept, so it depends on the courses alone, not on how they are told. -/
def ReadsSets (kept : P → X → Bool) (R : P → P → Prop) (O : (X → Bool) → (X → Bool) → Prop) :
    Prop :=
  ∀ a b, R b a ↔ O (kept b) (kept a)

/-- **Read right, an order increasing at the added item never ranks the narrowing above.** Where a
ranking of presentations reads the sets on a pair that one item alone separates, and its order on
courses increases at that item, it ranks the wider plan above the narrower and never the narrower
above. So a ranking that puts a narrowing above its widening by one item either ranks that pair
otherwise than its order ranks the courses (a misread or a framing), or has an order that does not
increase at the added item. -/
theorem reads_increasingAt {kept : P → X → Bool} {R : P → P → Prop}
    {O : (X → Bool) → (X → Bool) → Prop} {items : List X} {x : X} {n w : P}
    (by_ : WidensBy items x (kept w) (kept n)) (reads : ReadsSetsOn kept R O w n)
    (increasing : IncreasingAt items O x) : R n w ∧ ¬ R w n :=
  match increasing _ _ by_ with
  | ⟨above, not⟩ => ⟨reads.1.mpr above, fun r => not (reads.2.mp r)⟩

/-- **A narrowing above its widening, under a net weighting.** Where a ranking of presentations
puts the narrower of two plans that one item alone separates above the wider, it does not read
the sets on that pair as the net weighting ranks them, or the added item weighs at zero or
below. -/
theorem narrower_above_net {kept : P → X → Bool} {R : P → P → Prop} {items : List X}
    {pos neg : X → Nat} {x : X} {n w : P} (by_ : WidensBy items x (kept w) (kept n))
    (violates : R w n) :
    ¬ ReadsSetsOn kept R (ranksNet items pos neg) w n ∨ pos x ≤ neg x :=
  match Nat.lt_or_ge (neg x) (pos x) with
  | .inl above => .inl fun reads =>
      (reads_increasingAt by_ reads (ranksNet_increasingAt above)).2 violates
  | .inr below => .inr below

/-- **Read right, a net weighting's verdict is the added item's sign.** Where a ranking reads the
sets on a pair that one item alone separates as a net weighting ranks them, it puts the narrower
plan above exactly where that item weighs below zero and the wider above exactly where it weighs
above zero; at zero it puts neither above (`ranksNet_ties`). -/
theorem reads_ranksNet {kept : P → X → Bool} {R : P → P → Prop} {items : List X}
    {pos neg : X → Nat} {x : X} {n w : P} (by_ : WidensBy items x (kept w) (kept n))
    (reads : ReadsSetsOn kept R (ranksNet items pos neg) w n) :
    (R w n ↔ pos x < neg x) ∧ (R n w ↔ neg x < pos x) :=
  ⟨reads.2.trans (ranksNet_widensBy by_).2, reads.1.trans (ranksNet_widensBy by_).1⟩

/-- **A ranking that reads the sets, under a net weighting in which every listed item weighs above
zero, never puts a narrowing above its widening**, by one item or by many. -/
theorem reads_ranksNet_widens {kept : P → X → Bool} {R : P → P → Prop} {items : List X}
    {pos neg : X → Nat} {n w : P} (reads : ReadsSets kept R (ranksNet items pos neg))
    (above : ∀ x, x ∈ items → neg x < pos x) (widens : WidensOn items (kept w) (kept n)) :
    R n w ∧ ¬ R w n :=
  have ranked := ranksNet_lt_of_widens (fun x listed _ _ => above x listed) widens
  ⟨(reads w n).mpr ranked, fun v => Nat.lt_asymm ranked ((reads n w).mp v)⟩

theorem reads_increment_of {kept : P → X → Bool} {R : P → P → Prop}
    {O : (X → Bool) → (X → Bool) → Prop} {n w : P} (reads : ReadsSetsOn kept R O w n) :
    ∀ {o : Ordering}, IncrementIs O (kept n) (kept w) o →
      (R w n ↔ o = .lt) ∧ (R n w ↔ o = .gt) ∧ ((¬ R w n ∧ ¬ R n w) ↔ o = .eq)
  | .gt, ⟨above, not⟩ =>
    ⟨⟨fun r => absurd (reads.2.mp r) not, fun e => Ordering.noConfusion e⟩,
     ⟨fun _ => rfl, fun _ => reads.1.mpr above⟩,
     ⟨fun ⟨_, nw⟩ => absurd (reads.1.mpr above) nw, fun e => Ordering.noConfusion e⟩⟩
  | .eq, ⟨not, not'⟩ =>
    ⟨⟨fun r => absurd (reads.2.mp r) not', fun e => Ordering.noConfusion e⟩,
     ⟨fun r => absurd (reads.1.mp r) not, fun e => Ordering.noConfusion e⟩,
     ⟨fun _ => rfl, fun _ => ⟨fun r => not' (reads.2.mp r), fun r => not (reads.1.mp r)⟩⟩⟩
  | .lt, ⟨below, not⟩ =>
    ⟨⟨fun _ => rfl, fun _ => reads.2.mpr below⟩,
     ⟨fun r => absurd (reads.1.mp r) not, fun e => Ordering.noConfusion e⟩,
     ⟨fun ⟨wn, _⟩ => absurd (reads.2.mpr below) wn, fun e => Ordering.noConfusion e⟩⟩

/-- **A sign measured apart fixes the verdict exactly where it is the sign of the increment in the
pair's context.** Let `apart x` be a valuer's sign for `x` measured with no plan shown: `.gt` where
the ending of `x` is a loss to it, `.eq` where nothing, `.lt` where a gain. Where a ranking reads
the sets on a pair that `x` separates, and that sign is the sign of the order's increment from the
narrower course to the wider (the premise that links the separate evaluation to the joint one), the
narrower plan is ranked above exactly where the sign is a gain, the wider exactly where it is a
loss, and neither exactly where it is nothing. Under a net weighting the premise holds in every
context once it holds in one (`ranksNet_increment_alike`); in `Interacting` it holds alone and
fails jointly. -/
theorem reads_increment {kept : P → X → Bool} {R : P → P → Prop}
    {O : (X → Bool) → (X → Bool) → Prop} {apart : X → Ordering} {x : X} {n w : P}
    (reads : ReadsSetsOn kept R O w n) (link : IncrementIs O (kept n) (kept w) (apart x)) :
    (R w n ↔ apart x = .lt) ∧ (R n w ↔ apart x = .gt) ∧
      ((¬ R w n ∧ ¬ R n w) ↔ apart x = .eq) :=
  reads_increment_of reads link

/-! ### Weights within a ratio: where valuers who weigh nearly alike agree -/

/-- Every two listed weights stand within the ratio `n / d`: `d` times either is at most `n`
times the other. Equal weights stand within `1 / 1`. -/
def RatioWithin (items : List X) (n d : Nat) (w : X → Nat) : Prop :=
  ∀ x y, x ∈ items → y ∈ items → d * w x ≤ n * w y

theorem cond_scale (k : Nat) : ∀ (v : Bool) (u : Nat), cond v (k * u) 0 = k * cond v u 0
  | true, _ => rfl
  | false, _ => (Nat.mul_zero k).symm

theorem weighed_scale (k : Nat) (items : List X) (w : X → Nat) (a : X → Bool) :
    weighed items (fun x => k * w x) a = k * weighed items w a :=
  (total_congr (fun x => cond_scale k (a x) (w x)) items).trans (total_mul k _ items)

/-- **Weights within a ratio bound what each side weighs beyond the other.** Where every two
listed weights stand within `n / d`, `d` times what `b` alone admits weighs, taken once for each
item `a` alone admits, is at most `n` times the number of items `b` alone admits, times what `a`
alone admits weighs. -/
theorem beyond_within {items : List X} {n d : Nat} {w : X → Nat} {a b : X → Bool}
    (within : RatioWithin items n d w) :
    d * weighed items w (beyond b a) * size items (beyond a b) ≤
      n * size items (beyond b a) * weighed items w (beyond a b) :=
  have each : ∀ x, x ∈ items →
      d * weighed items w (beyond b a) ≤ n * w x * size items (beyond b a) := fun x listed =>
    Nat.le_trans (Nat.le_of_eq (weighed_scale d items w (beyond b a)).symm)
      (Nat.le_trans (total_le items fun y member => ListTests.cond_zero_le fun _ => within y x member listed)
        (Nat.le_of_eq (weighed_const (n * w x) items (beyond b a))))
  Nat.le_trans (Nat.le_of_eq (weighed_const _ items (beyond a b)).symm)
    (Nat.le_trans (total_le items fun x listed => ListTests.cond_zero_le fun _ => each x listed)
      (Nat.le_of_eq ((total_congr (fun x => congrArg (fun m => cond (beyond a b x) m 0)
          (Naturals.mul_right_comm n (w x) (size items (beyond b a)))) items).trans
        (weighed_scale _ items w (beyond a b)))))

theorem pos_of_lt_mul {m d p : Nat} (lt : m < d * p) : 0 < p :=
  match p, lt with
  | _ + 1, _ => Nat.succ_pos _

theorem cond_pos_of {m : Nat} (positive : 0 < m) : ∀ {v : Bool}, 0 < cond v 1 0 → 0 < cond v m 0
  | true, _ => positive
  | false, zero => absurd zero (Nat.lt_irrefl 0)

/-- A course admitting some listed item weighs something under a positive weighting. -/
theorem weighed_pos_of_size {items : List X} {w : X → Nat} {a : X → Bool}
    (positive : Positive items w) (some : 0 < size items a) : 0 < weighed items w a :=
  match total_pos items some with
  | ⟨x, listed, one⟩ => total_pos_of_mem listed (cond_pos_of (positive x listed) one)

/-- A course admitting no listed item weighs nothing. -/
theorem weighed_zero_of_size {w : X → Nat} {a : X → Bool} :
    ∀ {items : List X}, size items a = 0 → weighed items w a = 0
  | [], _ => rfl
  | x :: rest, empty => match h : a x with
    | false =>
      have rest_none : size rest a = 0 := (Nat.zero_add _).symm.trans
        ((congrArg (fun v => cond v 1 0 + size rest a) h).symm.trans empty)
      (congrArg (fun v => cond v (w x) 0 + weighed rest w a) h).trans
        ((Nat.zero_add _).trans (weighed_zero_of_size rest_none))
    | true => Nat.noConfusion ((Nat.succ_add 0 (size rest a)).symm.trans
        ((congrArg (fun v => cond v 1 0 + size rest a) h).symm.trans empty))

/-- **Weights within a ratio rank by number past it.** Every positive weighting whose weights
stand within `n / d` of each other ranks `a` above `b` where `n` times the number of items `b`
alone admits is less than `d` times the number `a` alone admits. -/
theorem ranks_past_ratio {items : List X} {n d : Nat} {w : X → Nat} {a b : X → Bool}
    (positive : Positive items w) (within : RatioWithin items n d w)
    (gap : n * size items (beyond b a) < d * size items (beyond a b)) :
    weighed items w b < weighed items w a :=
  (weighed_lt_iff_beyond items w a b).mpr
    (match Nat.lt_or_ge (weighed items w (beyond b a)) (weighed items w (beyond a b)) with
    | .inl lt => lt
    | .inr ge =>
      have weighs := weighed_pos_of_size positive (pos_of_lt_mul gap)
      absurd (Nat.lt_of_le_of_lt
        (Nat.le_trans (Nat.mul_le_mul_left (d * size items (beyond a b)) ge)
          (Nat.le_trans (Nat.le_of_eq (Naturals.mul_right_comm d _ _)) (beyond_within within)))
        (mul_lt_mul_iff weighs |>.mpr gap)) (Nat.lt_irrefl _))

/-- Where `n` times the number of items `b` alone admits is at most `d` times the number `a` alone
admits, every positive weighting within `n / d` weighs `a` at least as much as `b`. -/
theorem ranks_le_past_ratio {items : List X} {n d : Nat} {w : X → Nat} {a b : X → Bool}
    (positive_n : 0 < n) (within : RatioWithin items n d w)
    (gap : n * size items (beyond b a) ≤ d * size items (beyond a b)) :
    weighed items w b ≤ weighed items w a :=
  (weighed_le_iff_beyond items w a b).mpr
    (match Nat.lt_or_ge (weighed items w (beyond a b)) (weighed items w (beyond b a)) with
    | .inr ge => ge
    | .inl lt => match h : size items (beyond b a) with
      | 0 => absurd (Eq.subst (motive := fun v => weighed items w (beyond a b) < v)
          (weighed_zero_of_size h) lt) (Nat.not_lt_zero _)
      | q + 1 =>
        have dp : 0 < d * size items (beyond a b) :=
          Nat.lt_of_lt_of_le (Nat.mul_pos positive_n (Nat.succ_pos q))
            (Eq.subst (motive := fun v => n * v ≤ d * size items (beyond a b)) h gap)
        absurd (Nat.lt_of_lt_of_le (Naturals.mul_lt_mul_of_pos dp lt)
          (Nat.le_trans (Nat.le_of_eq (Naturals.mul_right_comm d _ _))
            (Nat.le_trans (beyond_within within) (Nat.mul_le_mul_right _ gap))))
          (Nat.lt_irrefl _))

/-- The weighting tilted toward `b`: weight `n` on what `b` admits beyond `a`, `d` on every
other item. -/
def tilted (n d : Nat) (a b : X → Bool) : X → Nat :=
  fun x => cond (beyond b a x) n d

theorem cond_between {n d : Nat} (le : d ≤ n) : ∀ v : Bool, d ≤ cond v n d ∧ cond v n d ≤ n
  | true => ⟨le, Nat.le_refl n⟩
  | false => ⟨Nat.le_refl d, le⟩

theorem tilted_positive {n d : Nat} (positive : 0 < d) (le : d ≤ n) (items : List X)
    (a b : X → Bool) : Positive items (tilted n d a b) :=
  fun x _ => Nat.lt_of_lt_of_le positive (cond_between le (beyond b a x)).1

theorem tilted_within {n d : Nat} (le : d ≤ n) (items : List X) (a b : X → Bool) :
    RatioWithin items n d (tilted n d a b) :=
  fun x y _ _ => Nat.le_trans (Nat.mul_le_mul_left d (cond_between le (beyond b a x)).2)
    (Nat.le_trans (Nat.le_of_eq (Nat.mul_comm d n))
      (Nat.mul_le_mul_left n (cond_between le (beyond b a y)).1))

theorem tilt_beyond (n d : Nat) : ∀ p q : Bool, cond (p && !q) (cond (q && !p) n d) 0 = cond (p && !q) d 0
  | true, true => rfl
  | true, false => rfl
  | false, _ => rfl

theorem tilt_toward (n d : Nat) : ∀ v : Bool, cond v (cond v n d) 0 = cond v n 0
  | true => rfl
  | false => rfl

theorem weighed_tilted_beyond (n d : Nat) (items : List X) (a b : X → Bool) :
    weighed items (tilted n d a b) (beyond a b) = d * size items (beyond a b) :=
  (total_congr (fun x => tilt_beyond n d (a x) (b x)) items).trans (weighed_const d items (beyond a b))

theorem weighed_tilted_toward (n d : Nat) (items : List X) (a b : X → Bool) :
    weighed items (tilted n d a b) (beyond b a) = n * size items (beyond b a) :=
  (total_congr (fun x => tilt_toward n d (beyond b a x)) items).trans
    (weighed_const n items (beyond b a))

/-- The tilted weighting ranks `a` above `b` exactly where `n` times what `b` alone admits is
less than `d` times what `a` alone admits. -/
theorem tilted_lt_iff (n d : Nat) (items : List X) (a b : X → Bool) :
    weighed items (tilted n d a b) b < weighed items (tilted n d a b) a ↔
      n * size items (beyond b a) < d * size items (beyond a b) :=
  (weighed_lt_iff_beyond items _ a b).trans (by rw [weighed_tilted_beyond, weighed_tilted_toward])

theorem tilted_gt_iff (n d : Nat) (items : List X) (a b : X → Bool) :
    weighed items (tilted n d a b) a < weighed items (tilted n d a b) b ↔
      d * size items (beyond a b) < n * size items (beyond b a) :=
  (weighed_lt_iff_beyond items _ b a).trans (by rw [weighed_tilted_beyond, weighed_tilted_toward])

/-- **At the boundary the tilted weighting ties.** Where `n` times what `b` alone admits is `d`
times what `a` alone admits, the tilted weighting weighs the two courses alike. -/
theorem tilted_ties {n d : Nat} {items : List X} {a b : X → Bool}
    (boundary : n * size items (beyond b a) = d * size items (beyond a b)) :
    weighed items (tilted n d a b) a = weighed items (tilted n d a b) b := by
  rw [weighed_split items _ a b, weighed_split_right items _ a b, weighed_tilted_beyond,
    weighed_tilted_toward, boundary]

/-- **Where weights stand within a ratio, the side admitting more wins exactly past it.** Every
positive weighting whose weights stand within `n / d` of each other (`0 < d ≤ n`) ranks `a` above
`b` exactly where `n` times the number of items `b` alone admits is less than `d` times the number
`a` alone admits; the tilted weighting decides the boundary. -/
theorem every_within_iff {items : List X} {n d : Nat} {a b : X → Bool} (positive : 0 < d)
    (le : d ≤ n) :
    (∀ w, Positive items w → RatioWithin items n d w → weighed items w b < weighed items w a) ↔
      n * size items (beyond b a) < d * size items (beyond a b) :=
  ⟨fun every => (tilted_lt_iff n d items a b).mp
      (every _ (tilted_positive positive le items a b) (tilted_within le items a b)),
   fun gap _ positive' within => ranks_past_ratio positive' within gap⟩

/-- **Some weighting within the ratio ranks the other side higher exactly short of it.** -/
theorem some_within_reverses_iff {items : List X} {n d : Nat} {a b : X → Bool}
    (positive : 0 < d) (le : d ≤ n) :
    (∃ w, Positive items w ∧ RatioWithin items n d w ∧ weighed items w a < weighed items w b) ↔
      d * size items (beyond a b) < n * size items (beyond b a) :=
  ⟨fun ⟨_, _, within, lt⟩ =>
    match Nat.lt_or_ge (d * size items (beyond a b)) (n * size items (beyond b a)) with
    | .inl short => short
    | .inr past => absurd lt (Nat.not_lt_of_le
        (ranks_le_past_ratio (Nat.lt_of_lt_of_le positive le) within past)),
   fun short => ⟨tilted n d a b, tilted_positive positive le items a b, tilted_within le items a b,
     (tilted_gt_iff n d items a b).mpr short⟩⟩

/-- **Valuers whose weights stand within a ratio rank a pair opposite ways exactly where the ratio
exceeds what each side alone admits over what the other alone admits.** Two positive weightings
within `n / d` rank `a` and `b` opposite ways exactly where `d` times the number of items each
alone admits is less than `n` times the number the other alone admits. Equal weights (`n = d`)
never do; a widening, where `b` admits nothing beyond `a`, never is. -/
theorem opposite_within_iff {items : List X} {n d : Nat} {a b : X → Bool} (positive : 0 < d)
    (le : d ≤ n) :
    ((∃ w, Positive items w ∧ RatioWithin items n d w ∧ weighed items w b < weighed items w a) ∧
      ∃ w, Positive items w ∧ RatioWithin items n d w ∧ weighed items w a < weighed items w b) ↔
      d * size items (beyond b a) < n * size items (beyond a b) ∧
        d * size items (beyond a b) < n * size items (beyond b a) :=
  ⟨fun ⟨up, down⟩ => ⟨(some_within_reverses_iff (a := b) (b := a) positive le).mp up,
      (some_within_reverses_iff positive le).mp down⟩,
   fun ⟨up, down⟩ => ⟨(some_within_reverses_iff (a := b) (b := a) positive le).mpr up,
      (some_within_reverses_iff positive le).mpr down⟩⟩

/-- Under one positive weight for every item, a course weighs more exactly where it admits more
beyond the other than the other admits beyond it: weights within `1 / 1`. -/
theorem const_lt_iff_beyond {k : Nat} (positive : 0 < k) (items : List X) (a b : X → Bool) :
    weighed items (fun _ => k) b < weighed items (fun _ => k) a ↔
      size items (beyond b a) < size items (beyond a b) :=
  have within : RatioWithin items 1 1 (fun _ => k) := fun _ _ _ _ => Nat.le_refl _
  have positive' : Positive items (fun _ => k) := fun _ _ => positive
  ⟨fun lt => match Nat.lt_or_ge (size items (beyond b a)) (size items (beyond a b)) with
    | .inl less => less
    | .inr ge => absurd lt (Nat.not_lt_of_le (ranks_le_past_ratio (a := b) (b := a)
        (Nat.succ_pos 0) within (Eq.subst (motive := fun v => v ≤ 1 * size items (beyond b a))
          (Nat.one_mul _).symm (Eq.subst (motive := fun v => size items (beyond a b) ≤ v)
            (Nat.one_mul _).symm ge)))),
   fun less => ranks_past_ratio positive' within
     (Eq.subst (motive := fun v => v < 1 * size items (beyond a b)) (Nat.one_mul _).symm
       (Eq.subst (motive := fun v => size items (beyond b a) < v) (Nat.one_mul _).symm less))⟩

/-- Comparing what two courses admit item by item: either `a` admits an item `b` does not, or
`b` admits every item `a` admits. -/
theorem exceeds_or_includes (a b : X → Bool) :
    ∀ items : List X, ExceedsOn items a b ∨ IncludesOn items b a
  | [] => .inr fun _ member => nomatch member
  | x :: rest => match exceeds_or_includes a b rest with
    | .inl ⟨y, listed, admits, not⟩ => .inl ⟨y, .tail x listed, admits, not⟩
    | .inr includes => match ha : a x, hb : b x with
      | true, false => .inl ⟨x, .head rest, ha, hb⟩
      | true, true => .inr fun y member admits => match mem_cons_cases member with
        | .inl same => Eq.subst (motive := fun z => b z = true) same.symm hb
        | .inr listed => includes y listed admits
      | false, _ => .inr fun y member admits => match mem_cons_cases member with
        | .inl same => Bool.noConfusion
            (ha.symm.trans (Eq.subst (motive := fun z => a z = true) same admits))
        | .inr listed => includes y listed admits

theorem size_le_length (items : List X) (a : X → Bool) : size items a ≤ items.length :=
  Nat.le_trans (total_le items fun x _ => cond_le_one (a x)) (Nat.le_of_eq (total_ones items))

theorem size_pos_of_exceeds {items : List X} {a b : X → Bool} (exceeds : ExceedsOn items a b) :
    0 < size items (beyond a b) :=
  match exceeds with
  | ⟨_, listed, admits, not⟩ => total_pos_of_mem listed (cond_one_pos (bool_and_true admits (congrArg (!·) not)))

/-- **A course admitting an item the other does not is ranked higher by some positive
weighting**: the weighting tilted toward it, with weight one more than the number of listed items
on what it alone admits and one elsewhere, stands past the ratio. -/
theorem outweighs {items : List X} {a b : X → Bool} (exceeds : ExceedsOn items b a) :
    ∃ w, Positive items w ∧ weighed items w a < weighed items w b :=
  match (some_within_reverses_iff (items := items) (n := items.length + 1) (d := 1) (a := a) (b := b)
      (Nat.succ_pos 0) (Nat.succ_le_succ (Nat.zero_le _))).mpr
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.one_mul _)) (Nat.lt_of_lt_of_le
        (Nat.lt_succ_of_le (size_le_length items (beyond a b)))
        (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm)
          (Nat.mul_le_mul_left _ (size_pos_of_exceeds exceeds))))) with
  | ⟨w, positive, _, lt⟩ => ⟨w, positive, lt⟩

/-- **A mixed comparison is decided both ways by positive weightings**: some positive weighting
ranks the one higher, and some the other. -/
theorem mixed_either_way {items : List X} {a b : X → Bool} (mixed : MixedOn items a b) :
    (∃ w, Positive items w ∧ weighed items w b < weighed items w a) ∧
      ∃ w, Positive items w ∧ weighed items w a < weighed items w b :=
  ⟨outweighs mixed.1, outweighs mixed.2⟩

/-- **Widening is what every positive weighting ranks higher.** On the listed items, `a` widens
`b` exactly when every weighting positive on them weighs `a` above `b`. -/
theorem widens_iff_every_positive {items : List X} {a b : X → Bool} :
    WidensOn items a b ↔ ∀ w, Positive items w → weighed items w b < weighed items w a :=
  ⟨fun widens _ positive => weighed_lt_of_widens positive widens,
   fun every =>
    ⟨fun x listed admits => match h : a x with
      | true => rfl
      | false => match outweighs ⟨x, listed, admits, h⟩ with
        | ⟨w, positive, lt⟩ => absurd (every w positive) (Nat.lt_asymm lt),
     match exceeds_or_includes a b items with
     | .inl exceeds => exceeds
     | .inr includes =>
       absurd (every (fun _ => 1) fun _ _ => Nat.succ_pos 0)
         (Nat.not_lt_of_le (weighed_le_of_includes _ includes))⟩⟩

/-- **Widening on the root is what every positive weighting ranks higher** (row 10 as an interface law
of amounts assigned to what is admitted): on the listed items, with Boolean admission and additive
natural-number weights positive on every listed item, the grammar's `«广»` of what `a` admits over what
`b` admits holds exactly when every such weighting weighs `a` above `b`. The left side is the root's
order (`widensOn_iff`); the weights are a second sort the grammar has none of, and nothing here derives
them. Mixed comparisons have no unanimous ranking: some positive weighting ranks each direction
(`mixed_either_way`). -/
theorem grammar_widens_iff_every_positive {items : List X} {a b : X → Bool} :
    «广» (admittedOn items a) (admittedOn items b) ↔
      ∀ w, Positive items w → weighed items w b < weighed items w a :=
  widensOn_iff.symm.trans widens_iff_every_positive

/-- **A weighting the same for every item ranks by number.** Under one positive weight for every
item, one course is weighed above another exactly when it admits more of the listed items: the
case `1 / 1` of weights within a ratio. -/
theorem neutral_ranks_by_number {k : Nat} (positive : 0 < k) (items : List X) (a b : X → Bool) :
    weighed items (fun _ => k) b < weighed items (fun _ => k) a ↔
      weighed items (fun _ => 1) b < weighed items (fun _ => 1) a :=
  (const_lt_iff_beyond positive items a b).trans (weighed_lt_iff_beyond items _ a b).symm

/-! ### Any order increasing in admission -/

/-- An order on courses is increasing in admission on the listed items when it ranks every
widening above what it widens; `R b a` reads "`a` is ranked above `b`". It need not be additive,
complete or transitive. -/
def Increasing (items : List X) (R : (X → Bool) → (X → Bool) → Prop) : Prop :=
  ∀ a b, WidensOn items a b → R b a

/-- The order a weighting gives: `a` is ranked above `b` when it weighs more. -/
def ranks (items : List X) (w : X → Nat) : (X → Bool) → (X → Bool) → Prop :=
  fun b a => weighed items w b < weighed items w a

/-- A positive weighting's order is increasing in admission. -/
theorem increasing_ranks {items : List X} {w : X → Nat} (positive : Positive items w) :
    Increasing items (ranks items w) :=
  fun _ _ widens => weighed_lt_of_widens positive widens

/-- **Widening is what every order of a class shares, for any class from the positive weightings
to the orders increasing in admission.** Where a class of orders contains every positive
weighting's order and holds only orders increasing in admission, `a` widens `b` on the listed
items exactly when every order of the class ranks `a` above `b`. The additive representation is
not needed: the shared order is the same for every such class. -/
theorem widens_iff_every_of_class {items : List X} {a b : X → Bool}
    {K : ((X → Bool) → (X → Bool) → Prop) → Prop}
    (weightings : ∀ w, Positive items w → K (ranks items w))
    (increasing : ∀ R, K R → Increasing items R) :
    WidensOn items a b ↔ ∀ R, K R → R b a :=
  ⟨fun widens R member => increasing R member a b widens,
   fun every => widens_iff_every_positive.mpr fun w positive => every _ (weightings w positive)⟩

/-- **Widening is what every order increasing in admission shares.** -/
theorem widens_iff_every_increasing {items : List X} {a b : X → Bool} :
    WidensOn items a b ↔ ∀ R, Increasing items R → R b a :=
  widens_iff_every_of_class (fun _ positive => increasing_ranks positive) fun _ increasing =>
    increasing

/-- **Widening is what every complete order increasing in admission shares.** A score ranks every
two courses; `a` widens `b` exactly when every score ranking each widening higher ranks `a` above
`b`. -/
theorem widens_iff_every_score {items : List X} {a b : X → Bool} :
    WidensOn items a b ↔
      ∀ s : (X → Bool) → Nat, Increasing items (fun c d => s c < s d) → s b < s a :=
  ⟨fun widens _ increasing => increasing a b widens,
   fun every => widens_iff_every_positive.mpr fun w positive =>
     every (weighed items w) (increasing_ranks positive)⟩

/-- **Within every such class a mixed comparison is decided both ways.** -/
theorem mixed_either_way_of_class {items : List X} {a b : X → Bool}
    {K : ((X → Bool) → (X → Bool) → Prop) → Prop}
    (weightings : ∀ w, Positive items w → K (ranks items w)) (mixed : MixedOn items a b) :
    (∃ R, K R ∧ R b a) ∧ ∃ R, K R ∧ R a b :=
  match mixed_either_way mixed with
  | ⟨⟨w, positive, lt⟩, ⟨w', positive', lt'⟩⟩ =>
    ⟨⟨ranks items w, weightings w positive, lt⟩, ⟨ranks items w', weightings w' positive', lt'⟩⟩

/-! ### Lexical priority -/

/-- A course restricted to the items `p` marks. -/
def restrict (p a : X → Bool) : X → Bool :=
  fun x => p x && a x

/-- Inclusion passes to the items `p` marks. -/
theorem includes_restrict (p : X → Bool) {items : List X} {a b : X → Bool}
    (includes : IncludesOn items a b) : IncludesOn items (restrict p a) (restrict p b) :=
  fun x listed held => match bool_of_and_true held with
    | ⟨marked, admits⟩ => bool_and_true marked (includes x listed admits)

/-- Lexical priority on the listed items, the basic ones (`basic`) first: `a` is ranked above `b`
when it widens `b` on the basic items, or admits exactly `b`'s basic items and widens `b` on the
others. -/
def lexical (items : List X) (basic : X → Bool) : (X → Bool) → (X → Bool) → Prop :=
  fun b a => WidensOn items (restrict basic a) (restrict basic b) ∨
    (IncludesOn items (restrict basic a) (restrict basic b) ∧
      IncludesOn items (restrict basic b) (restrict basic a) ∧
      WidensOn items (restrict (fun x => !basic x) a) (restrict (fun x => !basic x) b))

theorem gain_at : ∀ {bx ax bbx : Bool}, ax = true → bbx = false →
    ((bx && ax) = true → (bx && bbx) = true) → (!bx && ax) = true ∧ (!bx && bbx) = false
  | false, _, _, rfl, rfl, _ => ⟨rfl, rfl⟩
  | true, _, _, rfl, rfl, back => Bool.noConfusion (back rfl)

/-- **Lexical priority is increasing in admission.** It ranks every widening higher, so it lies
within the classes whose shared order is exactly widening (`widens_iff_every_of_class`), and it
decides only comparisons that order leaves mixed. -/
theorem increasing_lexical (items : List X) (basic : X → Bool) :
    Increasing items (lexical items basic) :=
  fun a b widens => match widens.2 with
  | ⟨x, listed, admits, not⟩ =>
    match exceeds_or_includes (restrict basic a) (restrict basic b) items with
    | .inl exceeds => .inl ⟨includes_restrict basic widens.1, exceeds⟩
    | .inr back => .inr ⟨includes_restrict basic widens.1, back,
        includes_restrict (fun y => !basic y) widens.1,
        ⟨x, listed, (gain_at admits not (back x listed)).1, (gain_at admits not (back x listed)).2⟩⟩

end Weighting

/-! ## Weightings of what a web's levels admit -/

namespace Web

variable {F C : Type} {W : Web F C}

/-- A decision of admission at listed steps and formations: `admitted l (t, f)` is true exactly
when the levels `l` admit `f` at `t`. -/
def DecidesAdmission (W : Web F C) (admitted : (Nat → C → Nat) → Nat × F → Bool) : Prop :=
  ∀ l i, admitted l i = true ↔ W.Admits (l i.1) i.1 i.2

/-- Every step and formation the level path admits is listed. -/
def ListsAdmitted (W : Web F C) (items : List (Nat × F)) (l : Nat → C → Nat) : Prop :=
  ∀ t f, W.Admits (l t) t f → (t, f) ∈ items

/-- **Widening is what every positive weighting ranks higher.** Where what either level path
admits is listed, `l` widens `l'` exactly when every weighting positive on the listed steps and
formations weighs what `l` admits above what `l'` admits. -/
theorem widens_iff_every_weighting {admitted : (Nat → C → Nat) → Nat × F → Bool}
    (decides : DecidesAdmission W admitted) {items : List (Nat × F)} {l l' : Nat → C → Nat}
    (listed : ListsAdmitted W items l) (listed' : ListsAdmitted W items l') :
    W.Widens l l' ↔ ∀ w, Weighting.Positive items w →
      Weighting.weighed items w (admitted l') < Weighting.weighed items w (admitted l) :=
  Iff.trans
    ⟨fun widens =>
      ⟨fun x _ admits => (decides l x).mpr (widens.1 x.1 x.2 ((decides l' x).mp admits)),
       match widens.2 with
       | ⟨t, f, admits, not⟩ => ⟨(t, f), listed t f admits, (decides l (t, f)).mpr admits,
           match h : admitted l' (t, f) with
           | true => absurd ((decides l' (t, f)).mp h) not
           | false => rfl⟩⟩,
     fun widens =>
      ⟨fun t f admits => (decides l (t, f)).mp
         (widens.1 (t, f) (listed' t f admits) ((decides l' (t, f)).mpr admits)),
       match widens.2 with
       | ⟨x, _, admits, not⟩ => ⟨x.1, x.2, (decides l x).mp admits,
           fun admits' => Bool.noConfusion (not.symm.trans ((decides l' x).mpr admits'))⟩⟩⟩
    Weighting.widens_iff_every_positive

/-- **Widening is what every order increasing in admission shares, on a web.** Where what either
level path admits is listed and admission is decided, `l` widens `l'` exactly when every order of
a class ranks what `l` admits above what `l'` admits, for any class from the positive weightings
to the orders increasing in admission. -/
theorem widens_iff_every_of_class {admitted : (Nat → C → Nat) → Nat × F → Bool}
    (decides : DecidesAdmission W admitted) {items : List (Nat × F)} {l l' : Nat → C → Nat}
    (listed : ListsAdmitted W items l) (listed' : ListsAdmitted W items l')
    {K : ((Nat × F → Bool) → (Nat × F → Bool) → Prop) → Prop}
    (weightings : ∀ w, Weighting.Positive items w → K (Weighting.ranks items w))
    (increasing : ∀ R, K R → Weighting.Increasing items R) :
    W.Widens l l' ↔ ∀ R, K R → R (admitted l') (admitted l) :=
  (widens_iff_every_weighting decides listed listed').trans
    (Weighting.widens_iff_every_positive.symm.trans
      (Weighting.widens_iff_every_of_class weightings increasing))

/-- **Closing is never required.** Where the levels `l'` admit a formation at a step and the
levels `l` do not, `l` neither widens `l'` nor keeps it the same: a comparison by widening never
ranks the course in which something is closed above the course in which it is not. -/
theorem not_widens_of_closes {l l' : Nat → C → Nat} {t : Nat} {f : F}
    (admits : W.Admits (l' t) t f) (closed : ¬ W.Admits (l t) t f) :
    ¬ W.Widens l l' ∧ ¬ W.Keeps l l' :=
  ⟨fun widens => closed (widens.1 t f admits), fun keeps => closed (keeps.1 t f admits)⟩

end Web

/-! ## What the step across standpoints reaches -/

variable {F Pos : Type}

/-- The significance of the continuation of what is some standpoint's center, from every
standpoint. -/
def atCenters (center : Pos → F) : Pos → Nat → F → Prop :=
  fun _ _ g => ∃ q, center q = g

/-- It is standpoint-invariant. -/
theorem atCenters_standpointInvariant (center : Pos → F) :
    StandpointInvariant (atCenters center) :=
  fun _ _ _ _ held => held

/-- It makes each standpoint's presupposition about its own continuation, along the empty
relation, sub-true. -/
theorem atCenters_presupposed (center : Pos → F) (p : Pos) :
    SubTrue (Boundary (fun _ _ => False) (center p)) (SignificantWithin (atCenters center) p) :=
  subTrue_empty_iff.mpr fun _ => ⟨p, rfl⟩

/-- **The least significance the step across standpoints gives.** Every significance under which
each standpoint's own continuation has significance from it, and which is standpoint-invariant,
gives significance from every standpoint to the continuation of every center. -/
theorem atCenters_least {center : Pos → F} {sig : Pos → Nat → F → Prop}
    (own : ∀ p, SubTrue (Boundary (fun _ _ => False) (center p)) (SignificantWithin sig p))
    (invariant : StandpointInvariant sig) : ∀ p t g, atCenters center p t g → sig p t g :=
  fun p t _ ⟨q, same⟩ =>
    Eq.subst (motive := fun g => sig p t g) same
      (invariant q p t (center q) (subTrue_empty_iff.mp (own q) t))

/-- **The step across standpoints reaches exactly the centers.** The continuation of `g` has
significance from `p` under every significance that gives each standpoint's own continuation
significance from it and is standpoint-invariant exactly when `g` is some standpoint's center. -/
theorem forced_iff_center (center : Pos → F) (p : Pos) (t : Nat) (g : F) :
    (∀ sig : Pos → Nat → F → Prop,
        (∀ q, SubTrue (Boundary (fun _ _ => False) (center q)) (SignificantWithin sig q)) →
          StandpointInvariant sig → sig p t g) ↔
      ∃ q, center q = g :=
  ⟨fun forced => forced (atCenters center) (atCenters_presupposed center)
      (atCenters_standpointInvariant center),
   fun centered _ own invariant => atCenters_least own invariant p t g centered⟩

/-- **The step across standpoints gives the continuation condition only where everything is a
center.** With some standpoint, the significance of the centers' continuation is unrestricted
exactly when every formation is some standpoint's center. -/
theorem unrestricted_atCenters_iff {center : Pos → F} (some : Pos) :
    Unrestricted (atCenters center) ↔ ∀ g, ∃ q, center q = g :=
  ⟨fun unrestricted g => unrestricted (some, 0, g), fun every i => every i.2.2⟩

/-- **What a standpoint's own presupposition reaches.** Along a relation, the continuation of `g`
has significance from `p` under every significance that makes `p`'s presupposition sub-true,
drawn at the closure of `f`, exactly when `g` lies within that closure. -/
theorem forced_iff_within (rel : F → F → Prop) (f : F) (p : Pos) (t : Nat) (g : F) :
    (∀ sig : Pos → Nat → F → Prop, SubTrue (Boundary rel f) (SignificantWithin sig p) →
        sig p t g) ↔ WithinClosure rel f g :=
  ⟨fun forced => forced (fun _ _ h => WithinClosure rel f h)
      (subTrue_significantWithin_iff.mpr fun _ _ within => within),
   fun within _ sub => subTrue_significantWithin_iff.mp sub t g within⟩

/-- Retaining what has significance at the centers is admitting, at every step, every center
the other path admits. -/
theorem Web.retains_atCenters_iff {C : Type} {W : Web F C} {center : Pos → F} {p : Pos}
    {l l' : Nat → C → Nat} :
    W.Retains (atCenters center) p l l' ↔
      ∀ t, W.AdmitsWithin (fun g => ∃ q, center q = g) (l t) (l' t) t :=
  Web.retains_bounded_iff

/-- **On a web, admitting what the step across standpoints forces is admitting every center.**
At a step, levels admit every formation the other levels admit whose continuation has
significance from `p` under every significance that meets each standpoint's presupposition
about its own continuation and is standpoint-invariant, exactly when they admit every center the
other levels admit (`forced_iff_center` read on a web). -/
theorem Web.admitsWithin_forced_iff {C : Type} {W : Web F C} {center : Pos → F} {p : Pos}
    {s t : Nat} {l l' : C → Nat} :
    W.AdmitsWithin (fun g => ∀ sig : Pos → Nat → F → Prop,
        (∀ q, SubTrue (Boundary (fun _ _ => False) (center q)) (SignificantWithin sig q)) →
          StandpointInvariant sig → sig p s g) l l' t ↔
      W.AdmitsWithin (fun g => ∃ q, center q = g) l l' t :=
  ⟨fun within g centered admits => within g ((forced_iff_center center p s g).mpr centered) admits,
   fun within g forced admits => within g ((forced_iff_center center p s g).mp forced) admits⟩

/-! ## The self drawn along every relation, and along being related at all -/

section Relations

variable {ι : Type}

/-- Being related by some relation of a family. -/
def Related (rel : ι → F → F → Prop) : F → F → Prop :=
  fun g h => ∃ i, rel i g h

/-- **The presupposition along every relation of a family** is significance over the union of
the closures: from `p`, the continuation of whatever lies within `f`'s closure along some
relation of the family has significance. -/
theorem subTrue_every_iff {rel : ι → F → F → Prop} {f : F} {sig : Pos → Nat → F → Prop}
    {p : Pos} :
    (∀ i, SubTrue (Boundary (rel i) f) (SignificantWithin sig p)) ↔
      ∀ t g, (∃ i, WithinClosure (rel i) f g) → sig p t g :=
  ⟨fun every t g ⟨i, within⟩ => subTrue_significantWithin_iff.mp (every i) t g within,
   fun union i => subTrue_significantWithin_iff.mpr fun t g within => union t g ⟨i, within⟩⟩

/-- Drawn along being related at all, the presupposition gives it along every relation of the
family. -/
theorem subTrue_every_of_related {rel : ι → F → F → Prop} {f : F} {sig : Pos → Nat → F → Prop}
    {p : Pos} (related : SubTrue (Boundary (Related rel) f) (SignificantWithin sig p)) :
    ∀ i, SubTrue (Boundary (rel i) f) (SignificantWithin sig p) :=
  fun i => subTrue_of_larger (fun _ _ holds => ⟨i, holds⟩) related

end Relations

/-! ## Witnesses -/

namespace Chain

/-- Three formations: the first bears one relation to the second, the second another to the
third. -/
inductive Formation where
  | first
  | second
  | third

/-- Relation `false` takes the first to the second, relation `true` the second to the third. -/
inductive rel : Bool → Formation → Formation → Prop where
  | one : rel false .first .second
  | two : rel true .second .third

/-- Along being related at all, the third lies within the first's closure. -/
theorem third_related : WithinClosure (Related rel) .first .third :=
  (WithinClosure.of_rel (rel := Related rel) ⟨false, .one⟩).trans
    (WithinClosure.of_rel (rel := Related rel) ⟨true, .two⟩)

/-- The first alone is closed under relation `true`. -/
def onlyFirst : Formation → Prop
  | .first => True
  | .second => False
  | .third => False

/-- The first and the second are closed under relation `false`. -/
def notThird : Formation → Prop
  | .first => True
  | .second => True
  | .third => False

/-- Along each relation alone, the third does not lie within the first's closure. -/
theorem third_not_within : ∀ i, ¬ WithinClosure (rel i) .first .third
  | false, within => within notThird (fun _ _ _ related => match related with
      | .one => trivial) trivial
  | true, within => within onlyFirst (fun _ _ inside related => match related, inside with
      | .two, no => no) trivial

/-- **Along every relation one at a time the self is smaller than along being related at all.**
Significance over the union of the first's closures makes its presupposition sub-true along
each relation, and not along being related at all. -/
theorem every_not_related :
    (∀ i, SubTrue (Boundary (rel i) .first)
        (SignificantWithin (fun (_ : Unit) _ g => ∃ i, WithinClosure (rel i) .first g) ())) ∧
      ¬ SubTrue (Boundary (Related rel) .first)
        (SignificantWithin (fun (_ : Unit) _ g => ∃ i, WithinClosure (rel i) .first g) ()) :=
  ⟨subTrue_every_iff.mpr fun _ _ union => union,
   fun related => match subTrue_significantWithin_iff.mp related 0 .third third_related with
     | ⟨i, within⟩ => third_not_within i within⟩

end Chain

namespace Clearing

/-- **Where only the clearer holds a standpoint, its part retains what has significance at the
centers, and under the continuation condition it loses the dweller.** The narrower scope and the
condition part exactly at a formation that is no standpoint's center. -/
theorem centers_retain_yet_loses {l : Nat → Place → Nat}
    (without : flow.WithheldLevels clearerPart web l)
    {sig : Unit → Nat → Formation → Prop} (unrestricted : Unrestricted sig) :
    web.Retains (atCenters fun (_ : Unit) => Formation.clearer) () web.level l ∧
      ¬ web.Retains sig () web.level l :=
  ⟨Web.retains_atCenters_iff.mpr fun t => ((loses_beyond without).1 t).2.2.narrow
      fun g ⟨_, same⟩ => match g, same with
        | .clearer, _ => trivial,
   (clearer_loses_dweller without unrestricted ()).2.1⟩

end Clearing

/-! ## Contents held de se and de dicto -/

/-- A content held *de se*: a property of a self, which each standpoint holds of its own center.
From `p` it gives significance to what the property says at `p`'s center. -/
def selfAscribed (content : F → Nat → F → Prop) (center : Pos → F) : Pos → Nat → F → Prop :=
  fun p t g => content (center p) t g

/-- A content held *de dicto*: one proposition, the same from every standpoint. -/
def shared (content : Nat → F → Prop) : Pos → Nat → F → Prop :=
  fun _ t g => content t g

/-- A shared content is standpoint-invariant. -/
theorem shared_standpointInvariant (content : Nat → F → Prop) :
    StandpointInvariant (shared (Pos := Pos) content) :=
  fun _ _ _ _ holds => holds

/-- **Standpoint-invariance is holding one shared content.** A significance is
standpoint-invariant exactly when it is, from every standpoint, one proposition held de dicto. -/
theorem standpointInvariant_iff_shared {sig : Pos → Nat → F → Prop} :
    StandpointInvariant sig ↔ ∃ content : Nat → F → Prop, ∀ p t g, sig p t g ↔ content t g :=
  ⟨fun invariant => ⟨fun t g => ∃ q, sig q t g, fun p t g =>
      ⟨fun holds => ⟨p, holds⟩, fun ⟨q, holds⟩ => invariant q p t g holds⟩⟩,
   fun ⟨_, same⟩ p q t g holds => (same q t g).mpr ((same p t g).mp holds)⟩

/-- **A content held de se is standpoint-invariant exactly where its readings at the centers
agree.** Every standpoint holds the same property; what it gives significance to changes with
the center it is read at. -/
theorem selfAscribed_standpointInvariant_iff {content : F → Nat → F → Prop} {center : Pos → F} :
    StandpointInvariant (selfAscribed content center) ↔
      ∀ p q t g, content (center p) t g → content (center q) t g :=
  Iff.rfl

/-- The self's presupposition as a property of a self: the continuation of what lies within the
self's own closure along a relation. -/
def ownClosure (rel : F → F → Prop) : F → Nat → F → Prop :=
  fun c _ g => WithinClosure rel c g

/-- Held de se, the own-closure content meets each standpoint's presupposition. -/
theorem ownClosure_presupposed (rel : F → F → Prop) (center : Pos → F) (p : Pos) :
    SubTrue (Boundary rel (center p)) (SignificantWithin (selfAscribed (ownClosure rel) center) p) :=
  subTrue_significantWithin_iff.mpr fun _ _ within => within

/-- **Held de se, the presupposition is standpoint-invariant exactly where the centers' closures
agree.** -/
theorem ownClosure_standpointInvariant_iff {rel : F → F → Prop} {center : Pos → F} :
    StandpointInvariant (selfAscribed (ownClosure rel) center) ↔
      ∀ p q g, WithinClosure rel (center p) g → WithinClosure rel (center q) g :=
  ⟨fun invariant p q g within => invariant p q 0 g within,
   fun agree p q _ g within => agree p q g within⟩

/-- **Held de se, the presupposition is the continuation condition exactly where every center's
closure is the whole.** -/
theorem ownClosure_unrestricted_iff {rel : F → F → Prop} {center : Pos → F} :
    Unrestricted (selfAscribed (ownClosure rel) center) ↔ ∀ p g, WithinClosure rel (center p) g :=
  ⟨fun unrestricted p g => unrestricted (p, 0, g), fun whole i => whole i.1 i.2.2⟩

/-- **Where every element is some standpoint's center, held de se the presupposition is the
continuation condition exactly where every closure is the whole.** -/
theorem ownClosure_unrestricted_iff_of_onto {rel : F → F → Prop} {center : Pos → F}
    (onto : ∀ f, ∃ p, center p = f) :
    Unrestricted (selfAscribed (ownClosure rel) center) ↔ ∀ f g, WithinClosure rel f g :=
  ⟨fun unrestricted f g => match onto f with
     | ⟨p, at_⟩ => Eq.subst (motive := fun x => WithinClosure rel x g) at_
         (ownClosure_unrestricted_iff.mp unrestricted p g),
   fun whole => ownClosure_unrestricted_iff.mpr fun p g => whole (center p) g⟩

/-- **Where some standpoint's center returns, held de se the presupposition is the continuation
condition exactly where every closure is the whole**: that center's closure is then the whole, and
one returning element whose closure is the whole makes every closure the whole
(`ReturnsAlong.whole`). -/
theorem ownClosure_unrestricted_iff_of_returning {rel : F → F → Prop} {center : Pos → F} (p : Pos)
    (returns : ReturnsAlong rel (center p)) :
    Unrestricted (selfAscribed (ownClosure rel) center) ↔ ∀ f g, WithinClosure rel f g :=
  ⟨fun unrestricted => returns.whole (ownClosure_unrestricted_iff.mp unrestricted p),
   fun whole => ownClosure_unrestricted_iff.mpr fun q g => whole (center q) g⟩

/-- The de dicto reading of the presupposition: from every standpoint, the continuation of what
lies within some center's closure. -/
def withinSome (rel : F → F → Prop) (center : Pos → F) : Pos → Nat → F → Prop :=
  shared fun _ g => ∃ q, WithinClosure rel (center q) g

/-- **What the step across standpoints forces along a relation.** Under every significance that
makes each standpoint's presupposition sub-true at its center's closure and is
standpoint-invariant, the continuation of `g` has significance from `p` exactly when `g` lies
within some center's closure: the union of the closures, held de dicto. Along the empty relation
this is `forced_iff_center`. -/
theorem forced_iff_within_some (rel : F → F → Prop) (center : Pos → F) (p : Pos) (t : Nat)
    (g : F) :
    (∀ sig : Pos → Nat → F → Prop,
        (∀ q, SubTrue (Boundary rel (center q)) (SignificantWithin sig q)) →
          StandpointInvariant sig → sig p t g) ↔
      ∃ q, WithinClosure rel (center q) g :=
  ⟨fun forced => forced (withinSome rel center)
      (fun q => subTrue_significantWithin_iff.mpr fun _ _ within => ⟨q, within⟩)
      (shared_standpointInvariant _),
   fun ⟨q, within⟩ _ own invariant =>
     invariant q p t g (subTrue_significantWithin_iff.mp (own q) t g within)⟩

/-- **On a web, admitting what the step forces along a relation is admitting whatever lies
within some center's closure** (`forced_iff_within_some` read on a web). -/
theorem Web.admitsWithin_forced_within_some_iff {C : Type} {W : Web F C} {rel : F → F → Prop}
    {center : Pos → F} {p : Pos} {s t : Nat} {l l' : C → Nat} :
    W.AdmitsWithin (fun g => ∀ sig : Pos → Nat → F → Prop,
        (∀ q, SubTrue (Boundary rel (center q)) (SignificantWithin sig q)) →
          StandpointInvariant sig → sig p s g) l l' t ↔
      W.AdmitsWithin (fun g => ∃ q, WithinClosure rel (center q) g) l l' t :=
  ⟨fun within g some admits =>
     within g ((forced_iff_within_some rel center p s g).mpr some) admits,
   fun within g forced admits =>
     within g ((forced_iff_within_some rel center p s g).mp forced) admits⟩

/-- **Where the de se and the de dicto readings part.** The own closure held de se and the union
of closures held de dicto give significance alike from every standpoint exactly where whatever
lies within one center's closure lies within every center's. -/
theorem selfAscribed_iff_withinSome {rel : F → F → Prop} {center : Pos → F} :
    (∀ p t g, selfAscribed (ownClosure rel) center p t g ↔ withinSome rel center p t g) ↔
      ∀ p q g, WithinClosure rel (center q) g → WithinClosure rel (center p) g :=
  ⟨fun same p q g within => (same p 0 g).mpr ⟨q, within⟩,
   fun agree p _ g => ⟨fun within => ⟨p, within⟩, fun ⟨q, within⟩ => agree p q g within⟩⟩

/-- **Drawn along a relation under which every center's closure is the whole, the presupposition
held de se is the continuation condition**, with no step of invariance: along being related at
all in a connected unfolding, the de se question decides nothing. -/
theorem ownClosure_unrestricted_of_whole {rel : F → F → Prop} {center : Pos → F}
    (whole : ∀ p g, WithinClosure rel (center p) g) :
    Unrestricted (selfAscribed (ownClosure rel) center) :=
  ownClosure_unrestricted_iff.mpr whole

/-! ## Self-concern through dependence -/

/-- The centers lie within one another's closures along a relation: every center lies within
every center's closure. -/
def CentersWithin (rel : F → F → Prop) (center : Pos → F) : Prop :=
  ∀ p q, WithinClosure rel (center p) (center q)

/-- Centers within one another's closures have one closure. -/
theorem withinClosure_iff_of_centersWithin {rel : F → F → Prop} {center : Pos → F}
    (within : CentersWithin rel center) (p q : Pos) (g : F) :
    WithinClosure rel (center p) g ↔ WithinClosure rel (center q) g :=
  ⟨fun held => (within q p).trans held, fun held => (within p q).trans held⟩

/-- **Held de se, the presupposition is standpoint-invariant exactly where the centers lie within
one another's closures.** Each standpoint's own closure is then one closure, and nothing more is
needed: the whole need not lie within it. -/
theorem ownClosure_standpointInvariant_iff_centersWithin {rel : F → F → Prop}
    {center : Pos → F} :
    StandpointInvariant (selfAscribed (ownClosure rel) center) ↔ CentersWithin rel center :=
  ⟨fun invariant p q => ownClosure_standpointInvariant_iff.mp invariant q p (center q)
      (WithinClosure.refl (center q)),
   fun within => ownClosure_standpointInvariant_iff.mpr fun p q _ held => (within q p).trans held⟩

/-- **The de se and the de dicto readings agree exactly where the centers lie within one
another's closures.** -/
theorem selfAscribed_iff_withinSome_iff_centersWithin {rel : F → F → Prop} {center : Pos → F} :
    (∀ p t g, selfAscribed (ownClosure rel) center p t g ↔ withinSome rel center p t g) ↔
      CentersWithin rel center :=
  selfAscribed_iff_withinSome.trans
    ⟨fun agree p q => agree p q (center q) (WithinClosure.refl (center q)),
     fun within p q _ held => (within p q).trans held⟩

/-- **Centers that depend on one condition and exchange with it lie within one another's
influence closures.** -/
theorem Flow.centersWithin_influence_of_common {C : Type} {L : Flow F C} {W : Web F C}
    {center : Pos → F} {c : C}
    (common : ∀ p, W.DependsOn (center p) c ∧ L.Exchanges (center p) c) :
    CentersWithin (L.AffectedBy W) center :=
  fun p q => WithinClosure.of_rel ⟨c, (common p).1, (common q).2⟩

/-- **Centers that at one step take part, require one condition and give to it lie within one
another's feeding closures.** -/
theorem Flow.centersWithin_feeding_of_common {C : Type} {L : Flow F C} {W : Web F C}
    {center : Pos → F} {t : Nat} {c : C}
    (common : ∀ p, center p ∈ L.present t ∧ W.requires t (center p) c ∧
      0 < L.give t (center p) c) :
    CentersWithin (L.FedFrom W) center :=
  fun p q => WithinClosure.of_rel ⟨t, rfl, c, (common p).2.1, (common q).1, (common q).2.2⟩

/-- **Held de se along being affected, self-concern is one from the standpoint of every center
that depends on one condition and exchanges with it**, whatever lies beyond their closure. -/
theorem Flow.ownClosure_influence_invariant_of_common {C : Type} {L : Flow F C} {W : Web F C}
    {center : Pos → F} {c : C}
    (common : ∀ p, W.DependsOn (center p) c ∧ L.Exchanges (center p) c) :
    StandpointInvariant (selfAscribed (ownClosure (L.AffectedBy W)) center) :=
  ownClosure_standpointInvariant_iff_centersWithin.mpr (Flow.centersWithin_influence_of_common common)

/-- **Held de se along feeding, self-concern is one from the standpoint of every center that at
one step requires one condition and gives to it.** -/
theorem Flow.ownClosure_feeding_invariant_of_common {C : Type} {L : Flow F C} {W : Web F C}
    {center : Pos → F} {t : Nat} {c : C}
    (common : ∀ p, center p ∈ L.present t ∧ W.requires t (center p) c ∧
      0 < L.give t (center p) c) :
    StandpointInvariant (selfAscribed (ownClosure (L.FedFrom W)) center) :=
  ownClosure_standpointInvariant_iff_centersWithin.mpr (Flow.centersWithin_feeding_of_common common)

namespace Divided

/-- Two standpoints, each its own center, along the empty relation. -/
theorem not_within : ¬ WithinClosure (fun (_ _ : Bool) => False) false true :=
  fun within => Bool.noConfusion (within (fun g => g = false) (fun _ _ _ no => no.elim) rfl)

/-- Held de se, each standpoint's own continuation alone has significance from it, and the
significance is not standpoint-invariant. -/
theorem selfAscribed_not_invariant :
    ¬ StandpointInvariant (selfAscribed (ownClosure (fun (_ _ : Bool) => False)) (fun p : Bool => p)) :=
  fun invariant => not_within (ownClosure_standpointInvariant_iff.mp invariant true false true
    (WithinClosure.refl true))

/-- Held de dicto, both continuations have significance from both standpoints. -/
theorem withinSome_both (p : Bool) (t : Nat) (g : Bool) :
    withinSome (fun (_ _ : Bool) => False) (fun p : Bool => p) p t g :=
  ⟨g, WithinClosure.refl g⟩

end Divided

/-! ## What a continuation needs, and copies -/

/-- Over the possible courses of any type, `f`'s continuation needs `g`'s part: on every possible
course on which `f` continues, `g` takes its part, each read off the course (`continues`,
`part`). Read with one reading for both, need composes (`Needs`). -/
def NeedsPart {Ω : Type} (possible : Ω → Prop) (continues part : Ω → F → Prop) (f g : F) :
    Prop :=
  ∀ ω, possible ω → continues ω f → part ω g

/-- `f`'s continuation needs the part of some member of `K`. -/
def NeedsSomePart {Ω : Type} (possible : Ω → Prop) (continues part : Ω → F → Prop) (f : F)
    (K : F → Prop) : Prop :=
  ∀ ω, possible ω → continues ω f → ∃ g, K g ∧ part ω g

/-- Each member of `K` takes its part alone: for each member, on some possible course `f`
continues with that member taking its part and no other member of `K`. -/
def PartAlone {Ω : Type} (possible : Ω → Prop) (continues part : Ω → F → Prop) (f : F)
    (K : F → Prop) : Prop :=
  ∀ g, K g → ∃ ω, possible ω ∧ continues ω f ∧ part ω g ∧ ∀ h, K h → part ω h → h = g

/-- **A member of a class of alternatives is needed exactly where it is the only member**, over
any courses and readings: where `f`'s continuation needs the part of some member of `K` and each
member can take it alone, it needs the part of `g` exactly when every member of `K` is `g`. -/
theorem needsPart_iff_only {Ω : Type} {possible : Ω → Prop} {continues part : Ω → F → Prop}
    {f g : F} {K : F → Prop} (needed : NeedsSomePart possible continues part f K)
    (alone : PartAlone possible continues part f K) (member : K g) :
    NeedsPart possible continues part f g ↔ ∀ h, K h → h = g :=
  ⟨fun needs h other => match alone h other with
    | ⟨ω, here, going, _, only⟩ => (only g member (needs ω here going)).symm,
   fun only ω here going => match needed ω here going with
    | ⟨h, other, held⟩ => Eq.subst (motive := fun x => part ω x) (only h other) held⟩

/-- The marking reading: a course marks the formations that continue on it. -/
def Marked (a : F → Bool) (x : F) : Prop :=
  a x = true

/-- Over the possible courses, each marking the formations that continue on it, `f` needs `g`:
on every possible course on which `f` continues, `g` continues. The marking case of
`NeedsPart`. -/
def Needs (possible : (F → Bool) → Prop) (f g : F) : Prop :=
  NeedsPart possible Marked Marked f g

/-- `f` needs some member of `K`: on every possible course on which `f` continues, some member of
`K` continues. -/
def NeedsSome (possible : (F → Bool) → Prop) (f : F) (K : F → Prop) : Prop :=
  NeedsSomePart possible Marked Marked f K

/-- Each member of `K` carries `f` alone: for each member, on some possible course `f` continues
with that member and with no other member of `K`. -/
def CarriesAlone (possible : (F → Bool) → Prop) (f : F) (K : F → Prop) : Prop :=
  PartAlone possible Marked Marked f K

/-- A continuation needs itself. -/
theorem Needs.refl (possible : (F → Bool) → Prop) (f : F) : Needs possible f f :=
  fun _ _ continues => continues

/-- What a continuation needs, it needs with whatever that needs. -/
theorem Needs.trans {possible : (F → Bool) → Prop} {f g h : F} (first : Needs possible f g)
    (second : Needs possible g h) : Needs possible f h :=
  fun a here continues => second a here (first a here continues)

/-- Need is its own closure: what lies within `f`'s closure under need is what `f` needs. -/
theorem withinClosure_needs_iff {possible : (F → Bool) → Prop} {f g : F} :
    WithinClosure (Needs possible) f g ↔ Needs possible f g :=
  ⟨fun within => within (Needs possible f) (fun _ _ held next => held.trans next)
      (Needs.refl possible f),
   WithinClosure.of_rel⟩

/-- **Drawn along need, a standpoint's own presupposition reaches exactly what its continuation
needs.** -/
theorem forced_needs_iff (possible : (F → Bool) → Prop) (f : F) (p : Pos) (t : Nat) (g : F) :
    (∀ sig : Pos → Nat → F → Prop,
        SubTrue (Boundary (Needs possible) f) (SignificantWithin sig p) → sig p t g) ↔
      Needs possible f g :=
  (forced_iff_within (Needs possible) f p t g).trans withinClosure_needs_iff

/-- **A member of a class of alternatives is needed exactly where it is the only member.** Where
`f` needs some member of `K` and each member carries `f` alone, `f` needs the member `g` exactly
when every member of `K` is `g`. -/
theorem needs_iff_only {possible : (F → Bool) → Prop} {f g : F} {K : F → Prop}
    (needed : NeedsSome possible f K) (alone : CarriesAlone possible f K) (member : K g) :
    Needs possible f g ↔ ∀ h, K h → h = g :=
  needsPart_iff_only needed alone member

/-- **Drawn along need, self-concern reaches a member of a class of alternatives exactly where it
is the only member.** With copies each able to carry the continuation alone, the presupposition
reaches none of them; with one, it reaches it. -/
theorem forced_member_iff_only {possible : (F → Bool) → Prop} {f g : F} {K : F → Prop}
    (needed : NeedsSome possible f K) (alone : CarriesAlone possible f K) (member : K g)
    (p : Pos) (t : Nat) :
    (∀ sig : Pos → Nat → F → Prop,
        SubTrue (Boundary (Needs possible) f) (SignificantWithin sig p) → sig p t g) ↔
      ∀ h, K h → h = g :=
  (forced_needs_iff possible f p t g).trans (needs_iff_only needed alone member)

namespace Copies

/-- A formation and two that can each carry its continuation. -/
inductive Part where
  | user
  | first
  | second

/-- The two copies. -/
def copies : Part → Prop :=
  fun h => h = .first ∨ h = .second

/-- The possible courses: the user continues with the first copy alone, or with the second alone. -/
def possible : (Part → Bool) → Prop :=
  fun a => a .user = true ∧
    ((a .first = true ∧ a .second = false) ∨ (a .first = false ∧ a .second = true))

/-- The course with the first copy. -/
def withFirst : Part → Bool
  | .user => true
  | .first => true
  | .second => false

/-- The course with the second copy. -/
def withSecond : Part → Bool
  | .user => true
  | .first => false
  | .second => true

theorem needsSome : NeedsSome possible .user copies :=
  fun _ ⟨_, which⟩ _ => match which with
    | .inl ⟨first, _⟩ => ⟨.first, .inl rfl, first⟩
    | .inr ⟨_, second⟩ => ⟨.second, .inr rfl, second⟩

/-- The user is no copy. -/
theorem user_not_copy : ¬ copies .user
  | .inl same => Part.noConfusion same
  | .inr same => Part.noConfusion same

theorem carriesAlone : CarriesAlone possible .user copies :=
  fun g member => match g, member with
    | .user, member => absurd member user_not_copy
    | .first, _ => ⟨withFirst, ⟨rfl, .inl ⟨rfl, rfl⟩⟩, rfl, rfl, fun h other admits =>
        match h, other, admits with
        | .user, other, _ => absurd other user_not_copy
        | .first, _, _ => rfl
        | .second, _, admits => Bool.noConfusion admits⟩
    | .second, _ => ⟨withSecond, ⟨rfl, .inr ⟨rfl, rfl⟩⟩, rfl, rfl, fun h other admits =>
        match h, other, admits with
        | .user, other, _ => absurd other user_not_copy
        | .first, _, admits => Bool.noConfusion admits
        | .second, _, _ => rfl⟩

/-- **With two copies the user needs some copy and neither copy.** -/
theorem two_copies :
    NeedsSome possible .user copies ∧ ¬ Needs possible .user .first ∧
      ¬ Needs possible .user .second :=
  ⟨needsSome,
   fun needs => Part.noConfusion
     ((needs_iff_only needsSome carriesAlone (.inl rfl)).mp needs .second (.inr rfl)),
   fun needs => Part.noConfusion
     ((needs_iff_only needsSome carriesAlone (.inr rfl)).mp needs .first (.inl rfl))⟩

end Copies

/-! ## Need on the base: a family of conditions and what feeds it -/

namespace Flow

variable {C : Type}

/-- The courses of a family fed only from `K`: a flow with its web that balances, in which only
active formations give and only members of `K` give to a condition of the family. -/
def FedOnlyBy (cs : List C) (K : F → Prop) (ω : Flow F C × Web F C) : Prop :=
  ω.1.Balances ω.2 ∧ ω.1.Acting ω.2 ∧
    ∀ t g c, c ∈ cs → g ∈ ω.1.present t → 0 < ω.1.give t g c → K g

/-- `f` draws past the family's stock: across a stretch of `n` steps from `T`, longer than the
family's stock at `T`, at every step `f` is active, takes part and takes from the family. -/
def DrawsPast (cs : List C) (T n : Nat) (ω : Flow F C × Web F C) (f : F) : Prop :=
  ω.2.stock cs T < n ∧ ∀ t, T ≤ t → t < T + n →
    ω.2.active t f ∧ f ∈ ω.1.present t ∧ 0 < total cs (ω.1.take t f)

/-- `g` gives to the family within the stretch: at some step of it `g` takes part and gives to
the family. -/
def GivesWithin (cs : List C) (T n : Nat) (ω : Flow F C × Web F C) (g : F) : Prop :=
  ∃ t, T ≤ t ∧ t < T + n ∧ g ∈ ω.1.present t ∧ 0 < total cs (ω.1.give t g)

/-- The flows read off a web for a family fed only from `K` across a stretch: with the web fixed, a
flow balances on the family at every step of the stretch, only active formations give, and only
members of `K` give to the family. -/
def FedOnlyOn (W : Web F C) (cs : List C) (K : F → Prop) (T n : Nat) (L : Flow F C) : Prop :=
  (∀ t, T ≤ t → t < T + n → L.BalancesOn W cs t) ∧ L.Acting W ∧
    ∀ t g c, c ∈ cs → g ∈ L.present t → 0 < L.give t g c → K g

/-- **Over the flows read off a web, a formation drawing past its family's stock needs some
member of what feeds it.** What was taken beyond the stock across the stretch was given, and the
giver is found by finite search over the stretch, the family and the formations taking part. -/
theorem needsSome_on (W : Web F C) (cs : List C) (K : F → Prop) (T n : Nat) (f : F) :
    NeedsSomePart (FedOnlyOn W cs K T n) (fun L => DrawsPast cs T n (L, W))
      (fun L => GivesWithin cs T n (L, W)) f K :=
  fun L ⟨balances, _, only⟩ ⟨below, draws⟩ =>
    have taken : n ≤ total (steps T n) (L.uptake cs) :=
      Nat.le_trans (Nat.le_trans (Nat.le_of_eq (Nat.one_mul n).symm)
          (steps_ge (q := fun _ => 1) T n fun _ _ => Nat.le_refl 1))
        (total_le (steps T n) fun t mem => match between_of_mem_steps mem with
          | ⟨from_, to⟩ => uptake_pos (draws t from_ to).2.1 (draws t from_ to).2.2)
    have given : 0 < total (steps T n) (L.replenishment cs) :=
      Nat.pos_of_ne_zero fun zero => Nat.lt_irrefl (W.stock cs T)
        (Nat.lt_of_lt_of_le below (Nat.le_trans taken (Nat.le_trans (Nat.le_add_left _ _)
          (Nat.le_of_eq ((accumulates_on T n balances).trans
            ((congrArg (W.stock cs T + ·) zero).trans (Nat.add_zero _)))))))
    match total_pos (steps T n) given with
    | ⟨t, mem, replenished⟩ => match between_of_mem_steps mem with
      | ⟨from_, to⟩ => match total_pos cs replenished with
        | ⟨c, inside, positive⟩ => match total_pos (L.present t) positive with
          | ⟨g, present, gives⟩ =>
            ⟨g, only t g c inside present gives, t, from_, to, present,
             total_pos_of_mem inside gives⟩

/-- **A formation drawing past its family's stock needs some member of what feeds it.** On every
course of a family fed only from `K`, a formation that draws past the family's stock across a
stretch has some member of `K` giving to the family within the stretch: the case of
`needsSome_on` for a flow with its own web, which balances at every step. -/
theorem needsSome_of_drawsPast (cs : List C) (K : F → Prop) (T n : Nat) (f : F) :
    NeedsSomePart (FedOnlyBy cs K) (DrawsPast cs T n) (GivesWithin cs T n) f K :=
  fun ω ⟨balances, acting, only⟩ draws =>
    needsSome_on ω.2 cs K T n f ω.1 ⟨fun t _ _ => balances.on cs t, acting, only⟩ draws

/-- **On the base, a feeder is needed exactly where it is the only one.** Where each member of
`K` can feed the family alone while `f` draws past its stock, `f` needs the giving of the member
`g` exactly when every member of `K` is `g`. -/
theorem needs_giver_iff_only {cs : List C} {K : F → Prop} {T n : Nat} {f g : F}
    (alone : PartAlone (FedOnlyBy cs K) (DrawsPast cs T n) (GivesWithin cs T n) f K)
    (member : K g) :
    NeedsPart (FedOnlyBy cs K) (DrawsPast cs T n) (GivesWithin cs T n) f g ↔ ∀ h, K h → h = g :=
  needsPart_iff_only (needsSome_of_drawsPast cs K T n f) alone member

end Flow


/-! ## Which feeders can feed a family alone, read off a web -/

namespace Web

variable {C : Type} (W : Web F C)

/-- The step from `t` calls for giving to the family: some condition of it rises, or none falls.
Where it does not, no condition rises and some falls, so a consumer can take the falls with
nothing given. -/
def CallsForGiving (cs : List C) (t : Nat) : Prop :=
  (∃ c, c ∈ cs ∧ W.Rises t c) ∨ ¬ ∃ c, c ∈ cs ∧ W.Falls t c

instance decCallsForGiving (cs : List C) (t : Nat) : Decidable (W.CallsForGiving cs t) :=
  @instDecidableOr _ _
    (decideSome (p := fun c => W.Rises t c)
      (decide := fun c => Nat.decLt (W.level t c) (W.level (t + 1) c)) cs)
    (@instDecidableNot _ (decideSome (p := fun c => W.Falls t c)
      (decide := fun c => Nat.decLt (W.level (t + 1) c) (W.level t c)) cs))

end Web

/-- A total over two members is their sum. -/
theorem total_two {α : Type} (q : α → Nat) (a b : α) : total [a, b] q = q a + q b :=
  congrArg (q a + ·) (Nat.add_zero (q b))

namespace Flow

variable {C : Type}

/-- **A step calling for giving forces giving.** Where the flow balances on the family across
the step from `t` and `f`, taking part, takes from the family, a step calling for giving has some
condition of the family given to. -/
theorem given_pos_of_calls {L : Flow F C} {W : Web F C} {cs : List C} {t : Nat} {f : F}
    (balances : L.BalancesOn W cs t) (present : f ∈ L.present t)
    (takes : 0 < total cs (L.take t f)) (calls : W.CallsForGiving cs t) :
    ∃ c, c ∈ cs ∧ 0 < L.given t c :=
  match calls with
  | .inl ⟨c, inside, rises⟩ => ⟨c, inside, Nat.pos_of_ne_zero fun zero =>
      Nat.lt_irrefl (W.level t c) (Nat.lt_of_lt_of_le rises
        (Nat.le_trans (Nat.le_add_right _ (L.taken t c))
          (Nat.le_of_eq ((balances c inside).trans
            ((congrArg (W.level t c + ·) zero).trans (Nat.add_zero _))))))⟩
  | .inr steady => match total_pos cs takes with
    | ⟨c, inside, taking⟩ => ⟨c, inside, Nat.pos_of_ne_zero fun zero =>
        have flat : W.level t c ≤ W.level (t + 1) c :=
          match Nat.lt_or_ge (W.level (t + 1) c) (W.level t c) with
          | .inl falls => absurd ⟨c, inside, falls⟩ steady
          | .inr ge => ge
        have taken : 0 < L.taken t c :=
          Nat.lt_of_lt_of_le taking (le_total_of_mem (q := fun x => L.take t x c) present)
        have back : L.taken t c + W.level (t + 1) c ≤ 0 + W.level (t + 1) c :=
          Nat.le_trans (Nat.le_of_eq ((Nat.add_comm _ _).trans ((balances c inside).trans
            ((congrArg (W.level t c + ·) zero).trans (Nat.add_zero _)))))
            (Nat.le_trans flat (Nat.le_of_eq (Nat.zero_add _).symm))
        Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le taken (le_of_add_le_add_right _ back))⟩

/-- Across a stretch, the flow read off a web in which `f` draws and `pick t` gives. At a step
calling for giving, `f` takes one more than each condition's level and the giver gives one more
than the condition's next level; at another step `f` takes each condition's fall and nothing is
given. Outside the stretch nothing takes part. -/
def drawnAcross [DecidableEq F] (W : Web F C) (cs : List C) (T n : Nat) (f : F)
    (pick : Nat → F) : Flow F C where
  present t := if T ≤ t ∧ t < T + n then [f, pick t] else []
  take t x c := if x = f then
      (if W.CallsForGiving cs t then W.level t c + 1 else W.level t c - W.level (t + 1) c)
    else 0
  give t x c := if x = pick t ∧ W.CallsForGiving cs t then W.level (t + 1) c + 1 else 0

section Drawn

variable [DecidableEq F] {W : Web F C} {cs : List C} {T n : Nat} {f : F} {pick : Nat → F}

/-- What gives in the flow drawn across a stretch is the formation picked at a step calling for
giving. -/
theorem drawnAcross_gives {t : Nat} {x : F} {c : C}
    (gives : 0 < (drawnAcross W cs T n f pick).give t x c) :
    x = pick t ∧ W.CallsForGiving cs t :=
  match (instDecidableAnd : Decidable (x = pick t ∧ W.CallsForGiving cs t)) with
  | isTrue both => both
  | isFalse no => absurd (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (if_neg no))) (Nat.lt_irrefl 0)

/-- The flow drawn across a stretch balances on the family at every step of it, where the picked
formation is never `f`. -/
theorem drawnAcross_balancesOn (apart : ∀ t, pick t ≠ f) :
    ∀ t, T ≤ t → t < T + n → (drawnAcross W cs T n f pick).BalancesOn W cs t := by
  intro t from_ to c inside
  have present : (drawnAcross W cs T n f pick).present t = [f, pick t] := if_pos ⟨from_, to⟩
  have takeOther : (drawnAcross W cs T n f pick).take t (pick t) c = 0 := if_neg (apart t)
  have giveSelf : (drawnAcross W cs T n f pick).give t f c = 0 :=
    if_neg fun both => apart t both.1.symm
  show W.level (t + 1) c + total ((drawnAcross W cs T n f pick).present t)
      (fun x => (drawnAcross W cs T n f pick).take t x c) =
    W.level t c + total ((drawnAcross W cs T n f pick).present t)
      (fun x => (drawnAcross W cs T n f pick).give t x c)
  rw [present, total_two, total_two]
  show W.level (t + 1) c + ((drawnAcross W cs T n f pick).take t f c +
      (drawnAcross W cs T n f pick).take t (pick t) c) =
    W.level t c + ((drawnAcross W cs T n f pick).give t f c +
      (drawnAcross W cs T n f pick).give t (pick t) c)
  rw [takeOther, giveSelf, Nat.add_zero, Nat.zero_add]
  exact match Web.decCallsForGiving W cs t with
  | isTrue calls =>
    have takeSelf : (drawnAcross W cs T n f pick).take t f c = W.level t c + 1 :=
      (if_pos rfl).trans (if_pos calls)
    have giveOther : (drawnAcross W cs T n f pick).give t (pick t) c = W.level (t + 1) c + 1 :=
      if_pos ⟨rfl, calls⟩
    (congrArg (W.level (t + 1) c + ·) takeSelf).trans
      ((Nat.add_left_comm (W.level (t + 1) c) (W.level t c) 1).trans
        (congrArg (W.level t c + ·) giveOther.symm))
  | isFalse quiet =>
    have takeSelf : (drawnAcross W cs T n f pick).take t f c = W.level t c - W.level (t + 1) c :=
      (if_pos rfl).trans (if_neg quiet)
    have giveOther : (drawnAcross W cs T n f pick).give t (pick t) c = 0 :=
      if_neg fun both => quiet both.2
    have below : W.level (t + 1) c ≤ W.level t c :=
      match Nat.lt_or_ge (W.level t c) (W.level (t + 1) c) with
      | .inl rises => absurd (.inl ⟨c, inside, rises⟩) quiet
      | .inr ge => ge
    (congrArg (W.level (t + 1) c + ·) takeSelf).trans ((add_sub_of_le below).trans
      ((Nat.add_zero _).symm.trans (congrArg (W.level t c + ·) giveOther.symm)))

/-- In the flow drawn across a stretch only active formations give, where the picked formation is
active at every step of the stretch calling for giving. -/
theorem drawnAcross_acting
    (active : ∀ t, T ≤ t → t < T + n → W.CallsForGiving cs t → W.active t (pick t)) :
    (drawnAcross W cs T n f pick).Acting W :=
  fun t x _ present gives => match drawnAcross_gives gives with
  | ⟨same, calls⟩ => match Nat.decLe T t, Nat.decLt t (T + n) with
    | isTrue from_, isTrue to => same ▸ active t from_ to calls
    | isFalse early, _ => absurd (Eq.subst (motive := fun l => x ∈ l)
        (if_neg fun both => early both.1) present) (fun none => nomatch none)
    | _, isFalse late => absurd (Eq.subst (motive := fun l => x ∈ l)
        (if_neg fun both => late both.2) present) (fun none => nomatch none)

/-- The flow drawn across a stretch is read off the web for a family fed only from `K`, where the
picked formation is never `f`, always in `K`, and active at every step calling for giving. -/
theorem drawnAcross_fedOnlyOn {K : F → Prop} (apart : ∀ t, pick t ≠ f)
    (active : ∀ t, T ≤ t → t < T + n → W.CallsForGiving cs t → W.active t (pick t))
    (members : ∀ t, K (pick t)) : FedOnlyOn W cs K T n (drawnAcross W cs T n f pick) :=
  ⟨drawnAcross_balancesOn apart, drawnAcross_acting active,
   fun t _ _ _ _ gives => (drawnAcross_gives gives).1 ▸ members t⟩

/-- In the flow drawn across a stretch, `f` draws past the family's stock, where it is active
across the stretch, the stretch is longer than the stock and the family has a condition. -/
theorem drawnAcross_drawsPast {c₀ : C} (inside : c₀ ∈ cs)
    (alive : ∀ t, T ≤ t → t < T + n → W.active t f) (below : W.stock cs T < n) :
    DrawsPast cs T n (drawnAcross W cs T n f pick, W) f :=
  ⟨below, fun t from_ to =>
    have present : (drawnAcross W cs T n f pick).present t = [f, pick t] := if_pos ⟨from_, to⟩
    ⟨alive t from_ to, Eq.subst (motive := fun l => f ∈ l) present.symm (.head _),
     match Web.decCallsForGiving W cs t with
     | isTrue calls => total_pos_of_mem (q := (drawnAcross W cs T n f pick).take t f) inside
        (Nat.lt_of_lt_of_le (Nat.succ_pos _)
          (Nat.le_of_eq ((if_pos rfl).trans (if_pos calls)).symm))
     | isFalse quiet => match decideSome (p := fun c => W.Falls t c)
          (decide := fun c => Nat.decLt (W.level (t + 1) c) (W.level t c)) cs with
       | isTrue ⟨_, mem, falls⟩ => total_pos_of_mem (q := (drawnAcross W cs T n f pick).take t f) mem
          (Nat.lt_of_lt_of_le (SupportGated.sub_pos_of_lt falls)
            (Nat.le_of_eq ((if_pos rfl).trans (if_neg quiet)).symm))
       | isFalse steady => absurd (.inr steady) quiet⟩⟩

end Drawn

/-- **Which feeders can feed a family alone, read off a web.** Where `f`, outside `K`, is active
across a stretch longer than its family's stock and every member of `K` is active at every step
of the stretch calling for giving, each member can feed the family alone while `f` draws past the
stock: the flow drawn across the stretch with that member giving. -/
theorem partAlone_on [DecidableEq F] {W : Web F C} {cs : List C} {c₀ : C} (inside : c₀ ∈ cs)
    {K : F → Prop} {T n : Nat} {f : F} (outside : ¬ K f)
    (alive : ∀ t, T ≤ t → t < T + n → W.active t f) (below : W.stock cs T < n)
    (able : ∀ g, K g → ∀ t, T ≤ t → t < T + n → W.CallsForGiving cs t → W.active t g) :
    PartAlone (FedOnlyOn W cs K T n) (fun L => DrawsPast cs T n (L, W))
      (fun L => GivesWithin cs T n (L, W)) f K :=
  fun g member =>
    have apart : ∀ _ : Nat, g ≠ f := fun _ same => outside (same ▸ member)
    have possible : FedOnlyOn W cs K T n (drawnAcross W cs T n f fun _ => g) :=
      drawnAcross_fedOnlyOn apart (fun t from_ to calls => able g member t from_ to calls)
        fun _ => member
    have draws : DrawsPast cs T n (drawnAcross W cs T n f (fun _ => g), W) f :=
      drawnAcross_drawsPast inside alive below
    ⟨drawnAcross W cs T n f fun _ => g, possible, draws,
     match needsSome_on W cs K T n f _ possible draws with
     | ⟨_, _, t, from_, to, present, gives⟩ => match total_pos cs gives with
       | ⟨_, _, positive⟩ => match drawnAcross_gives positive with
         | ⟨same, _⟩ => ⟨t, from_, to, same ▸ present, same ▸ gives⟩,
     fun _ _ ⟨_, _, _, _, gives⟩ => match total_pos cs gives with
       | ⟨_, _, positive⟩ => (drawnAcross_gives positive).1⟩

/-- **The copies law over a web.** Where every member of `K` is active at every step of the
stretch calling for giving, `f` drawing past its family's stock needs a member's giving exactly
where that member is the only one: `needsPart_iff_only` with `PartAlone` read off the web. -/
theorem needs_giver_iff_only_on [DecidableEq F] {W : Web F C} {cs : List C} {c₀ : C}
    (inside : c₀ ∈ cs) {K : F → Prop} {T n : Nat} {f g : F} (outside : ¬ K f)
    (alive : ∀ t, T ≤ t → t < T + n → W.active t f) (below : W.stock cs T < n)
    (able : ∀ g, K g → ∀ t, T ≤ t → t < T + n → W.CallsForGiving cs t → W.active t g)
    (member : K g) :
    NeedsPart (FedOnlyOn W cs K T n) (fun L => DrawsPast cs T n (L, W))
        (fun L => GivesWithin cs T n (L, W)) f g ↔ ∀ h, K h → h = g :=
  needsPart_iff_only (needsSome_on W cs K T n f) (partAlone_on inside outside alive below able) member

/-- The first member of a list active at `t` other than `g`, and `g` where there is none. -/
def firstActiveOther [DecidableEq F] (W : Web F C) [∀ t x, Decidable (W.active t x)] (g : F)
    (t : Nat) : List F → F
  | [] => g
  | h :: hs => if W.active t h ∧ h ≠ g then h else firstActiveOther W g t hs

section Other

variable [DecidableEq F] {W : Web F C} [∀ t x, Decidable (W.active t x)] {g : F} {t : Nat}

/-- What `firstActiveOther` gives is a member of the list or `g`. -/
theorem firstActiveOther_mem : ∀ ks : List F,
    firstActiveOther W g t ks ∈ ks ∨ firstActiveOther W g t ks = g
  | [] => .inr rfl
  | h :: hs => match (instDecidableAnd : Decidable (W.active t h ∧ h ≠ g)) with
    | isTrue yes => .inl (Eq.subst (motive := fun x => x ∈ h :: hs) (if_pos yes).symm (.head hs))
    | isFalse no => match firstActiveOther_mem hs with
      | .inl mem => .inl (Eq.subst (motive := fun x => x ∈ h :: hs) (if_neg no).symm
          (.tail h mem))
      | .inr same => .inr ((if_neg no).trans same)

/-- Where some member of the list is active at `t` and other than `g`, `firstActiveOther` gives
one. -/
theorem firstActiveOther_active : ∀ ks : List F, (∃ h, h ∈ ks ∧ W.active t h ∧ h ≠ g) →
    W.active t (firstActiveOther W g t ks) ∧ firstActiveOther W g t ks ≠ g
  | [], ⟨_, mem, _⟩ => nomatch mem
  | h :: hs, ⟨k, mem, other⟩ => match (instDecidableAnd : Decidable (W.active t h ∧ h ≠ g)) with
    | isTrue yes => Eq.subst (motive := fun x => W.active t x ∧ x ≠ g) (if_pos yes).symm yes
    | isFalse no => Eq.subst (motive := fun x => W.active t x ∧ x ≠ g) (if_neg no).symm
        (firstActiveOther_active hs (match mem_cons_cases mem with
          | .inl same => absurd (Eq.subst (motive := fun x => W.active t x ∧ x ≠ g) same other) no
          | .inr inside => ⟨k, inside, other⟩))

end Other

/-- **A feeder is needed exactly where it is alone when giving is called for.** Over the flows
read off a web for a family fed only from the members of a list, let `f`, not a member, be active
across a stretch longer than the family's stock. Then `f` drawing past the stock needs the giving
of the member `g` exactly where, at some step of the stretch calling for giving, `g` is the only
member active. -/
theorem needs_giver_iff_alone [DecidableEq F] {W : Web F C} [∀ t x, Decidable (W.active t x)]
    {cs : List C} {c₀ : C} (inside : c₀ ∈ cs) {ks : List F} {T n : Nat} {f g : F}
    (outside : ¬ f ∈ ks) (member : g ∈ ks)
    (alive : ∀ t, T ≤ t → t < T + n → W.active t f) (below : W.stock cs T < n) :
    NeedsPart (FedOnlyOn W cs (· ∈ ks) T n) (fun L => DrawsPast cs T n (L, W))
        (fun L => GivesWithin cs T n (L, W)) f g ↔
      ∃ t, T ≤ t ∧ t < T + n ∧ W.CallsForGiving cs t ∧ ∀ h, h ∈ ks → W.active t h → h = g :=
  ⟨fun needs =>
    match decideSome (p := fun t => W.CallsForGiving cs t ∧ ¬ ∃ h, h ∈ ks ∧ W.active t h ∧ h ≠ g)
      (decide := fun t => @instDecidableAnd _ _ (Web.decCallsForGiving W cs t)
        (@instDecidableNot _ (decideSome (p := fun h => W.active t h ∧ h ≠ g) ks)))
      (steps T n) with
    | isTrue ⟨t, mem, calls, lone⟩ => match between_of_mem_steps mem with
      | ⟨from_, to⟩ => ⟨t, from_, to, calls, fun h inks active => match decEq h g with
          | isTrue same => same
          | isFalse other => absurd ⟨h, inks, active, other⟩ lone⟩
    | isFalse absent =>
      have other : ∀ t, T ≤ t → t < T + n → W.CallsForGiving cs t →
          W.active t (firstActiveOther W g t ks) ∧ firstActiveOther W g t ks ≠ g :=
        fun t from_ to calls => firstActiveOther_active ks
          (match decideSome (p := fun h => W.active t h ∧ h ≠ g) ks with
           | isTrue found => found
           | isFalse lone => absurd ⟨t, steps_of_within from_ to, calls, lone⟩ absent)
      have members : ∀ t, firstActiveOther W g t ks ∈ ks := fun t =>
        match firstActiveOther_mem (W := W) (g := g) (t := t) ks with
        | .inl mem => mem
        | .inr same => Eq.subst (motive := fun x => x ∈ ks) same.symm member
      have apart : ∀ t, firstActiveOther W g t ks ≠ f := fun t same =>
        outside (same ▸ members t)
      have possible : FedOnlyOn W cs (· ∈ ks) T n
          (drawnAcross W cs T n f fun t => firstActiveOther W g t ks) :=
        drawnAcross_fedOnlyOn apart (fun t from_ to calls => (other t from_ to calls).1) members
      match needs _ possible (drawnAcross_drawsPast inside alive below) with
      | ⟨t, from_, to, _, gives⟩ => match total_pos cs gives with
        | ⟨_, _, positive⟩ => match drawnAcross_gives positive with
          | ⟨same, calls⟩ => ((other t from_ to calls).2 same.symm).elim,
   fun ⟨t, from_, to, calls, alone⟩ L ⟨balances, acting, only⟩ ⟨_, draws⟩ =>
     match given_pos_of_calls (balances t from_ to) (draws t from_ to).2.1 (draws t from_ to).2.2
       calls with
     | ⟨c, inside', given⟩ => match total_pos (L.present t) given with
       | ⟨x, present, gives⟩ =>
         have same : x = g := alone x (only t x c inside' present gives) (acting t x c present gives)
         ⟨t, from_, to, same ▸ present, same ▸ total_pos_of_mem inside' gives⟩⟩

end Flow


/-! ## Capacities of giving, and which feeders can feed a family alone -/

/-- Whether some member of a list is a given element is decidable, with decided identity. -/
instance decSomeEq {α : Type} [DecidableEq α] (l : List α) (a : α) :
    Decidable (∃ y, y ∈ l ∧ y = a) :=
  decideSome (p := fun y => y = a) l

namespace Web

variable {C : Type} (W : Web F C)

instance decSomeFalls (cs : List C) (t : Nat) : Decidable (∃ c, c ∈ cs ∧ W.Falls t c) :=
  decideSome (p := fun c => W.Falls t c)
    (decide := fun c => Nat.decLt (W.level (t + 1) c) (W.level t c)) cs

/-- What the step from `t` calls to be given to the family while a consumer draws on it: what
its conditions rise, and one more where none falls. -/
def demand (cs : List C) (t : Nat) : Nat :=
  risen cs (fun c s => W.level s c) t + if ¬ ∃ c, c ∈ cs ∧ W.Falls t c then 1 else 0

/-- The unit a consumer takes from `c₀` beyond the falls, where no condition of the family
falls. -/
def drawnUnit [DecidableEq C] (cs : List C) (c₀ : C) (t : Nat) (c : C) : Nat :=
  if c = c₀ ∧ ¬ ∃ d, d ∈ cs ∧ W.Falls t d then 1 else 0

/-- `g` can feed the family alone across a stretch, with the capacities `cap`: at every step of
it calling for giving, `g` is active and its capacity covers the step's demand. -/
def CanFeedAlone (cap : Nat → F → Nat) (cs : List C) (T n : Nat) (g : F) : Prop :=
  ∀ t, T ≤ t → t < T + n → W.CallsForGiving cs t → W.active t g ∧ W.demand cs t ≤ cap t g

variable {W}

/-- **A step calls for giving exactly where its demand is positive.** -/
theorem callsForGiving_iff_demand_pos {cs : List C} {t : Nat} :
    W.CallsForGiving cs t ↔ 0 < W.demand cs t :=
  ⟨fun calls => match calls with
    | .inl ⟨c, inside, rises⟩ => Nat.lt_of_lt_of_le
        (total_pos_of_mem (q := fun c => rise (fun s => W.level s c) t) inside (excess_pos.mpr rises))
        (Nat.le_add_right _ _)
    | .inr steady => Nat.lt_of_lt_of_le (Nat.succ_pos 0)
        (Nat.le_trans (Nat.le_of_eq (if_pos steady).symm) (Nat.le_add_left _ _)),
   fun pos => match Nat.decEq (risen cs (fun c s => W.level s c) t) 0 with
    | isFalse moved => match total_pos cs (Nat.pos_of_ne_zero moved) with
      | ⟨c, inside, up⟩ => .inl ⟨c, inside, excess_pos.mp up⟩
    | isTrue still => match W.decSomeFalls cs t with
      | isFalse steady => .inr steady
      | isTrue falls => absurd pos (by
          show ¬ 0 < risen cs (fun c s => W.level s c) t +
            (if ¬ ∃ c, c ∈ cs ∧ W.Falls t c then 1 else 0)
          rw [still, if_neg (fun steady => steady falls)]
          exact Nat.lt_irrefl 0)⟩

/-- Over a family without repetition holding `c₀`, the units drawn beyond the falls total one
where no condition falls and nothing otherwise. -/
theorem total_drawnUnit [DecidableEq C] {cs : List C} (distinct : Distinct cs) {c₀ : C}
    (inside : c₀ ∈ cs) (t : Nat) :
    total cs (W.drawnUnit cs c₀ t) = if ¬ ∃ c, c ∈ cs ∧ W.Falls t c then 1 else 0 :=
  match W.decSomeFalls cs t with
  | isTrue falls => (total_eq_zero fun _ _ => if_neg fun both => both.2 falls).trans
      (if_neg fun steady => steady falls).symm
  | isFalse steady => (Nat.le_antisymm
      (Nat.le_trans (total_le_at (a := c₀) (fun b pos => match decEq b c₀ with
          | isTrue same => same
          | isFalse other => absurd pos (Nat.lt_irrefl 0 ∘ fun p =>
              Nat.lt_of_lt_of_le p (Nat.le_of_eq (if_neg fun both => other both.1)))) distinct)
        (Nat.le_of_eq (if_pos ⟨rfl, steady⟩)))
      (Nat.le_trans (Nat.le_of_eq (if_pos ⟨rfl, steady⟩).symm)
        (le_total_of_mem (q := W.drawnUnit cs c₀ t) inside))).trans (if_pos steady).symm

end Web

namespace Flow

variable {C : Type}

/-- **What is given to a condition that does not fall is its rise and what is taken.** -/
theorem given_of_steady {L : Flow F C} {W : Web F C} {cs : List C} {t : Nat} {c : C}
    (balances : L.BalancesOn W cs t) (inside : c ∈ cs) (steady : ¬ W.Falls t c) :
    L.given t c = rise (fun s => W.level s c) t + L.taken t c :=
  have flat : fall (fun s => W.level s c) t = 0 :=
    eq_zero_of_not_pos fun pos => steady (excess_pos.mp pos)
  have up : W.level (t + 1) c = W.level t c + rise (fun s => W.level s c) t :=
    (Nat.add_zero _).symm.trans ((congrArg (W.level (t + 1) c + ·) flat.symm).trans
      (across (fun s => W.level s c) t))
  add_right_cancel (W.level t c) ((Nat.add_comm _ _).trans ((balances c inside).symm.trans
    ((congrArg (· + L.taken t c) up).trans ((Nat.add_assoc _ _ _).trans (Nat.add_comm _ _)))))

/-- What is given to a condition is at least what it rises. -/
theorem rise_le_given {L : Flow F C} {W : Web F C} {cs : List C} {t : Nat} {c : C}
    (balances : L.BalancesOn W cs t) (inside : c ∈ cs) :
    rise (fun s => W.level s c) t ≤ L.given t c :=
  match Nat.decEq (rise (fun s => W.level s c) t) 0 with
  | isTrue zero => Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le _)
  | isFalse moved =>
    have steady : ¬ W.Falls t c := fun falls =>
      Nat.lt_asymm (excess_pos.mp (Nat.pos_of_ne_zero moved)) falls
    Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (given_of_steady balances inside steady).symm)

/-- **A drawing consumer is given at least the step's demand.** Where the flow balances on the
family across the step from `t` and `f`, taking part, takes from the family, what is given to the
family is at least the step's demand. -/
theorem demand_le_replenishment {L : Flow F C} {W : Web F C} {cs : List C} {t : Nat} {f : F}
    (balances : L.BalancesOn W cs t) (present : f ∈ L.present t)
    (takes : 0 < total cs (L.take t f)) : W.demand cs t ≤ L.replenishment cs t := by
  show risen cs (fun c s => W.level s c) t + (if ¬ ∃ c, c ∈ cs ∧ W.Falls t c then 1 else 0) ≤
    L.replenishment cs t
  match W.decSomeFalls cs t with
  | isTrue falls =>
    rw [if_neg (fun steady : ¬ ∃ c, c ∈ cs ∧ W.Falls t c => steady falls), Nat.add_zero]
    exact total_le cs fun c inside => rise_le_given balances inside
  | isFalse steady =>
    have parts : L.replenishment cs t = risen cs (fun c s => W.level s c) t + L.uptake cs t :=
      (total_congr_on fun c inside =>
        given_of_steady balances inside fun falls => steady ⟨c, inside, falls⟩).trans
        (total_add _ _ cs)
    rw [if_pos steady, parts]
    exact Nat.add_le_add_left (uptake_pos present takes) _

/-- The flows read off a web with capacities: those read off the web for a family fed only from
`K`, in which at each step of the stretch the formations taking part are distinct and each gives
the family at most its capacity. -/
def FedOnlyWithin (W : Web F C) (cap : Nat → F → Nat) (cs : List C) (K : F → Prop) (T n : Nat)
    (L : Flow F C) : Prop :=
  FedOnlyOn W cs K T n L ∧ ∀ t, T ≤ t → t < T + n →
    Distinct (L.present t) ∧ ∀ x, x ∈ L.present t → total cs (L.give t x) ≤ cap t x

/-- Over the flows read off a web with capacities, a formation drawing past its family's stock
needs some member of what feeds it: the case of `needsSome_on`. -/
theorem needsSome_within (W : Web F C) (cap : Nat → F → Nat) (cs : List C) (K : F → Prop)
    (T n : Nat) (f : F) :
    NeedsSomePart (FedOnlyWithin W cap cs K T n) (fun L => DrawsPast cs T n (L, W))
      (fun L => GivesWithin cs T n (L, W)) f K :=
  fun L ⟨fed, _⟩ draws => needsSome_on W cs K T n f L fed draws

/-- Across a stretch, the least flow read off a web in which `f` draws and `pick t` gives: the
giver gives each condition of the family what it rises and `f` takes what it falls, with one more
unit given to and taken from `c₀` where no condition of the family falls; the giver gives exactly
the step's demand. Outside the stretch nothing takes part. -/
def leastDrawn [DecidableEq F] [DecidableEq C] (W : Web F C) (cs : List C) (c₀ : C) (T n : Nat)
    (f : F) (pick : Nat → F) : Flow F C where
  present t := if T ≤ t ∧ t < T + n then [f, pick t] else []
  take t x c := if x = f ∧ (∃ d, d ∈ cs ∧ d = c) then
      fall (fun s => W.level s c) t + W.drawnUnit cs c₀ t c else 0
  give t x c := if x = pick t ∧ (∃ d, d ∈ cs ∧ d = c) then
      rise (fun s => W.level s c) t + W.drawnUnit cs c₀ t c else 0

section Least

variable [DecidableEq F] [DecidableEq C] {W : Web F C} {cs : List C} {c₀ : C} {T n : Nat} {f : F}
  {pick : Nat → F}

/-- What gives in the least flow is the picked formation, at a step calling for giving. -/
theorem leastDrawn_gives {t : Nat} {x : F} {c : C}
    (gives : 0 < (leastDrawn W cs c₀ T n f pick).give t x c) :
    x = pick t ∧ W.CallsForGiving cs t :=
  match (instDecidableAnd : Decidable (x = pick t ∧ ∃ d, d ∈ cs ∧ d = c)) with
  | isFalse no => absurd (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (if_neg no))) (Nat.lt_irrefl 0)
  | isTrue ⟨same, ⟨d, inside, at_⟩⟩ =>
    have positive : 0 < rise (fun s => W.level s c) t + W.drawnUnit cs c₀ t c :=
      Nat.lt_of_lt_of_le gives (Nat.le_of_eq (if_pos ⟨same, ⟨d, inside, at_⟩⟩))
    ⟨same, match Nat.decEq (rise (fun s => W.level s c) t) 0 with
      | isFalse moved => .inl ⟨c, at_ ▸ inside, excess_pos.mp (Nat.pos_of_ne_zero moved)⟩
      | isTrue zero => match W.decSomeFalls cs t with
        | isFalse steady => .inr steady
        | isTrue falls => absurd positive (by
            rw [zero, Nat.zero_add]
            show ¬ 0 < (if c = c₀ ∧ ¬ ∃ d, d ∈ cs ∧ W.Falls t d then 1 else 0)
            rw [if_neg fun both => both.2 falls]
            exact Nat.lt_irrefl 0)⟩

/-- The least flow balances on the family at every step of the stretch, where the picked
formation is never `f`. -/
theorem leastDrawn_balancesOn (apart : ∀ t, pick t ≠ f) :
    ∀ t, T ≤ t → t < T + n → (leastDrawn W cs c₀ T n f pick).BalancesOn W cs t := by
  intro t from_ to c inside
  have present : (leastDrawn W cs c₀ T n f pick).present t = [f, pick t] := if_pos ⟨from_, to⟩
  have takeSelf : (leastDrawn W cs c₀ T n f pick).take t f c =
      fall (fun s => W.level s c) t + W.drawnUnit cs c₀ t c := if_pos ⟨rfl, ⟨c, inside, rfl⟩⟩
  have takeOther : (leastDrawn W cs c₀ T n f pick).take t (pick t) c = 0 :=
    if_neg fun both => apart t both.1
  have giveSelf : (leastDrawn W cs c₀ T n f pick).give t f c = 0 :=
    if_neg fun both => apart t both.1.symm
  have giveOther : (leastDrawn W cs c₀ T n f pick).give t (pick t) c =
      rise (fun s => W.level s c) t + W.drawnUnit cs c₀ t c := if_pos ⟨rfl, ⟨c, inside, rfl⟩⟩
  show W.level (t + 1) c + total ((leastDrawn W cs c₀ T n f pick).present t)
      (fun x => (leastDrawn W cs c₀ T n f pick).take t x c) =
    W.level t c + total ((leastDrawn W cs c₀ T n f pick).present t)
      (fun x => (leastDrawn W cs c₀ T n f pick).give t x c)
  rw [present, total_two, total_two]
  show W.level (t + 1) c + ((leastDrawn W cs c₀ T n f pick).take t f c +
      (leastDrawn W cs c₀ T n f pick).take t (pick t) c) =
    W.level t c + ((leastDrawn W cs c₀ T n f pick).give t f c +
      (leastDrawn W cs c₀ T n f pick).give t (pick t) c)
  rw [takeSelf, takeOther, giveSelf, giveOther]
  show W.level (t + 1) c + ((fall (fun s => W.level s c) t + W.drawnUnit cs c₀ t c) + 0) =
    W.level t c + (0 + (rise (fun s => W.level s c) t + W.drawnUnit cs c₀ t c))
  exact (congrArg (W.level (t + 1) c + ·) (Nat.add_zero _)).trans ((Nat.add_assoc _ _ _).symm.trans
    ((congrArg (· + W.drawnUnit cs c₀ t c) (across (fun s => W.level s c) t)).trans
      ((Nat.add_assoc _ _ _).trans (congrArg (W.level t c + ·) (Nat.zero_add _).symm))))

/-- In the least flow only active formations give, where the picked formation is active at every
step of the stretch calling for giving. -/
theorem leastDrawn_acting
    (active : ∀ t, T ≤ t → t < T + n → W.CallsForGiving cs t → W.active t (pick t)) :
    (leastDrawn W cs c₀ T n f pick).Acting W :=
  fun t x _ present gives => match leastDrawn_gives gives with
  | ⟨same, calls⟩ => match Nat.decLe T t, Nat.decLt t (T + n) with
    | isTrue from_, isTrue to => same ▸ active t from_ to calls
    | isFalse early, _ => absurd (Eq.subst (motive := fun l => x ∈ l)
        (if_neg fun both => early both.1) present) (fun empty => nomatch empty)
    | _, isFalse late => absurd (Eq.subst (motive := fun l => x ∈ l)
        (if_neg fun both => late both.2) present) (fun empty => nomatch empty)

/-- **The giver of the least flow gives exactly the step's demand**, over a family without
repetition holding `c₀`. -/
theorem leastDrawn_given_total (distinct : Distinct cs) (inside : c₀ ∈ cs) (t : Nat) :
    total cs ((leastDrawn W cs c₀ T n f pick).give t (pick t)) = W.demand cs t :=
  (total_congr_on (g := fun c => rise (fun s => W.level s c) t + W.drawnUnit cs c₀ t c)
    fun c member => if_pos ⟨rfl, ⟨c, member, rfl⟩⟩).trans
    ((total_add _ _ cs).trans (congrArg (risen cs (fun c s => W.level s c) t + ·)
      (Web.total_drawnUnit distinct inside t)))

/-- In the least flow `f` draws past the family's stock, where it is active across a stretch
longer than the stock and the family holds `c₀`. -/
theorem leastDrawn_drawsPast (inside : c₀ ∈ cs)
    (alive : ∀ t, T ≤ t → t < T + n → W.active t f) (below : W.stock cs T < n) :
    DrawsPast cs T n (leastDrawn W cs c₀ T n f pick, W) f :=
  ⟨below, fun t from_ to =>
    have present : (leastDrawn W cs c₀ T n f pick).present t = [f, pick t] := if_pos ⟨from_, to⟩
    ⟨alive t from_ to, Eq.subst (motive := fun l => f ∈ l) present.symm (.head _),
     match W.decSomeFalls cs t with
     | isTrue ⟨c, mem, falls⟩ => total_pos_of_mem (q := (leastDrawn W cs c₀ T n f pick).take t f) mem
        (Nat.lt_of_lt_of_le (excess_pos.mpr falls) (Nat.le_trans (Nat.le_add_right _ _)
          (Nat.le_of_eq (if_pos ⟨rfl, ⟨c, mem, rfl⟩⟩).symm)))
     | isFalse steady => total_pos_of_mem (q := (leastDrawn W cs c₀ T n f pick).take t f) inside
        (Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_trans (Nat.le_add_left _ _)
          (Nat.le_trans (Nat.le_of_eq (congrArg (fall (fun s => W.level s c₀) t + ·)
            (if_pos ⟨rfl, steady⟩)).symm)
            (Nat.le_of_eq (if_pos ⟨rfl, ⟨c₀, inside, rfl⟩⟩).symm))))⟩⟩

/-- The least flow is read off the web with capacities for a family fed only from `K`, where the
picked formation is never `f`, always in `K`, and at every step calling for giving active with a
capacity covering the demand. -/
theorem leastDrawn_fedOnlyWithin {cap : Nat → F → Nat} {K : F → Prop} (distinct : Distinct cs)
    (inside : c₀ ∈ cs) (apart : ∀ t, pick t ≠ f)
    (able : ∀ t, T ≤ t → t < T + n → W.CallsForGiving cs t →
      W.active t (pick t) ∧ W.demand cs t ≤ cap t (pick t))
    (members : ∀ t, K (pick t)) :
    FedOnlyWithin W cap cs K T n (leastDrawn W cs c₀ T n f pick) :=
  ⟨⟨leastDrawn_balancesOn apart, leastDrawn_acting fun t from_ to calls =>
      (able t from_ to calls).1,
    fun t _ _ _ _ gives => (leastDrawn_gives gives).1 ▸ members t⟩,
   fun t from_ to =>
    have present : (leastDrawn W cs c₀ T n f pick).present t = [f, pick t] := if_pos ⟨from_, to⟩
    ⟨Eq.subst (motive := fun l => Distinct l) present.symm
      ⟨(fun mem => match mem_cons_cases mem with
        | .inl same => apart t same.symm
        | .inr empty => nomatch empty), (fun empty => nomatch empty), trivial⟩,
     fun x mem => match mem_cons_cases (Eq.subst (motive := fun l => x ∈ l) present mem) with
     | .inl same => Nat.le_trans (Nat.le_of_eq (total_eq_zero fun _ _ =>
          if_neg fun both => apart t (same.symm.trans both.1).symm)) (Nat.zero_le _)
     | .inr rest => match mem_cons_cases rest with
       | .inl same => Eq.subst (motive := fun y => total cs ((leastDrawn W cs c₀ T n f pick).give t y)
            ≤ cap t y) same.symm (Nat.le_trans (Nat.le_of_eq (leastDrawn_given_total distinct inside t))
            (match Web.decCallsForGiving W cs t with
             | isTrue calls => (able t from_ to calls).2
             | isFalse quiet => Nat.le_trans (Nat.le_of_eq (eq_zero_of_not_pos fun pos =>
                  quiet (Web.callsForGiving_iff_demand_pos.mpr pos))) (Nat.zero_le _)))
       | .inr empty => nomatch empty⟩⟩

end Least

/-- **Which feeders can feed a family alone depends on how much each can give.** Over the flows
read off a web with capacities, for a family without repetition holding `c₀`, let `f`, outside
`K`, be active across a stretch longer than the family's stock. Then a member `g` of `K` is the
only member giving in some such flow in which `f` draws past the stock exactly where, at every step
of the stretch calling for giving, `g` is active and its capacity covers the step's demand. -/
theorem feedsAlone_iff [DecidableEq F] [DecidableEq C] {W : Web F C} {cap : Nat → F → Nat}
    {cs : List C} (distinct : Distinct cs) {c₀ : C} (inside : c₀ ∈ cs) {K : F → Prop} {T n : Nat}
    {f g : F} (outside : ¬ K f) (member : K g)
    (alive : ∀ t, T ≤ t → t < T + n → W.active t f) (below : W.stock cs T < n) :
    (∃ L, FedOnlyWithin W cap cs K T n L ∧ DrawsPast cs T n (L, W) f ∧
        GivesWithin cs T n (L, W) g ∧ ∀ h, K h → GivesWithin cs T n (L, W) h → h = g) ↔
      W.CanFeedAlone cap cs T n g :=
  ⟨fun ⟨L, ⟨⟨on, acting, only⟩, within⟩, ⟨_, draws⟩, _, alone⟩ t from_ to calls =>
    have lower : W.demand cs t ≤ L.replenishment cs t :=
      demand_le_replenishment (on t from_ to) (draws t from_ to).2.1 (draws t from_ to).2.2
    have gives : ∀ x, x ∈ L.present t → 0 < total cs (L.give t x) → x = g := fun x present pos =>
      match total_pos cs pos with
      | ⟨c, inside', positive⟩ => alone x (only t x c inside' present positive)
          ⟨t, from_, to, present, pos⟩
    match total_pos cs (Nat.lt_of_lt_of_le (Web.callsForGiving_iff_demand_pos.mp calls) lower) with
    | ⟨c, inside', given⟩ => match total_pos (L.present t) given with
      | ⟨x, present, positive⟩ =>
        have same : x = g := gives x present (total_pos_of_mem inside' positive)
        ⟨same ▸ acting t x c present positive,
         Nat.le_trans lower (Nat.le_trans (Nat.le_of_eq (total_swap (fun y c => L.give t y c) cs
           (L.present t)).symm) (Nat.le_trans (total_le (L.present t) (q := fun y =>
             if y = g then total cs (L.give t g) else 0) fun y mem =>
               match Nat.decEq (total cs (L.give t y)) 0 with
               | isTrue zero => Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le _)
               | isFalse pos => have yg : y = g := gives y mem (Nat.pos_of_ne_zero pos)
                   Nat.le_of_eq ((congrArg (fun z => total cs (L.give t z)) yg).trans
                     (if_pos yg).symm))
             (Nat.le_trans (total_le_at (a := g) (fun b pos => match decEq b g with
                 | isTrue same' => same'
                 | isFalse other => absurd pos (fun p => Nat.lt_irrefl 0
                     (Nat.lt_of_lt_of_le p (Nat.le_of_eq (if_neg other)))))
               (within t from_ to).1)
               (Nat.le_trans (Nat.le_of_eq (if_pos rfl))
                 ((within t from_ to).2 g (same ▸ present))))))⟩,
   fun able =>
    have apart : ∀ _ : Nat, g ≠ f := fun _ same => outside (same ▸ member)
    have possible : FedOnlyWithin W cap cs K T n (leastDrawn W cs c₀ T n f fun _ => g) :=
      leastDrawn_fedOnlyWithin distinct inside apart (fun t from_ to calls => able t from_ to calls)
        fun _ => member
    have draws : DrawsPast cs T n (leastDrawn W cs c₀ T n f (fun _ => g), W) f :=
      leastDrawn_drawsPast inside alive below
    ⟨leastDrawn W cs c₀ T n f fun _ => g, possible, draws,
     match needsSome_within W cap cs K T n f _ possible draws with
     | ⟨_, _, t, from_, to, present, gives⟩ => match total_pos cs gives with
       | ⟨_, _, positive⟩ => match leastDrawn_gives positive with
         | ⟨same, _⟩ => ⟨t, from_, to, same ▸ present, same ▸ gives⟩,
     fun _ _ ⟨_, _, _, _, gives⟩ => match total_pos cs gives with
       | ⟨_, _, positive⟩ => (leastDrawn_gives positive).1⟩⟩

/-- **Every member of a class can feed the family alone exactly where each, at every step calling
for giving, is active with a capacity covering the step's demand.** -/
theorem partAlone_within_iff [DecidableEq F] [DecidableEq C] {W : Web F C} {cap : Nat → F → Nat}
    {cs : List C} (distinct : Distinct cs) {c₀ : C} (inside : c₀ ∈ cs) {K : F → Prop} {T n : Nat}
    {f : F} (outside : ¬ K f) (alive : ∀ t, T ≤ t → t < T + n → W.active t f)
    (below : W.stock cs T < n) :
    PartAlone (FedOnlyWithin W cap cs K T n) (fun L => DrawsPast cs T n (L, W))
        (fun L => GivesWithin cs T n (L, W)) f K ↔ ∀ g, K g → W.CanFeedAlone cap cs T n g :=
  ⟨fun alone g member => (feedsAlone_iff distinct inside outside member alive below).mp
      (alone g member),
   fun able g member => (feedsAlone_iff distinct inside outside member alive below).mpr
      (able g member)⟩

/-- **The copies law with capacities.** Where every member of `K` can feed the family alone (active
with a capacity covering the demand at every step calling for giving), `f` drawing past its
family's stock needs a member's giving exactly where that member is the only one. -/
theorem needs_giver_iff_only_within [DecidableEq F] [DecidableEq C] {W : Web F C}
    {cap : Nat → F → Nat} {cs : List C} (distinct : Distinct cs) {c₀ : C} (inside : c₀ ∈ cs)
    {K : F → Prop} {T n : Nat} {f g : F} (outside : ¬ K f)
    (alive : ∀ t, T ≤ t → t < T + n → W.active t f) (below : W.stock cs T < n)
    (able : ∀ g, K g → W.CanFeedAlone cap cs T n g) (member : K g) :
    NeedsPart (FedOnlyWithin W cap cs K T n) (fun L => DrawsPast cs T n (L, W))
        (fun L => GivesWithin cs T n (L, W)) f g ↔ ∀ h, K h → h = g :=
  needsPart_iff_only (needsSome_within W cap cs K T n f)
    ((partAlone_within_iff distinct inside outside alive below).mpr able) member

/-- **A feeder is needed where the others' joint capacity falls short.** Over the flows read off a
web with capacities for a family fed only from the members of a list, where at some step of the
stretch the capacities of the other members active there total less than the step's demand, `f`
drawing past the stock needs `g`'s giving. -/
theorem needs_giver_of_short [DecidableEq F] {W : Web F C} [∀ t x, Decidable (W.active t x)]
    {cap : Nat → F → Nat} {cs : List C} {ks : List F} {T n : Nat} {f g : F}
    (short : ∃ t, T ≤ t ∧ t < T + n ∧
      total ks (fun h => if W.active t h ∧ h ≠ g then cap t h else 0) < W.demand cs t) :
    NeedsPart (FedOnlyWithin W cap cs (· ∈ ks) T n) (fun L => DrawsPast cs T n (L, W))
      (fun L => GivesWithin cs T n (L, W)) f g :=
  fun L ⟨⟨on, acting, only⟩, within⟩ ⟨_, draws⟩ => match short with
  | ⟨t, from_, to, below⟩ =>
    have lower : W.demand cs t ≤ total (L.present t) (fun x => total cs (L.give t x)) :=
      Nat.le_trans (demand_le_replenishment (on t from_ to) (draws t from_ to).2.1
        (draws t from_ to).2.2) (Nat.le_of_eq (total_swap (fun y c => L.give t y c) cs
          (L.present t)).symm)
    match decideSome (p := fun x => x = g ∧ 0 < total cs (L.give t x)) (L.present t) with
    | isTrue ⟨_, present, same, gives⟩ => ⟨t, from_, to, same ▸ present, same ▸ gives⟩
    | isFalse quiet =>
      have each : ∀ x, x ∈ L.present t → total cs (L.give t x) ≤
          total ks (fun h => if h = x then (if W.active t h ∧ h ≠ g then cap t h else 0) else 0) :=
        fun x present => match Nat.decEq (total cs (L.give t x)) 0 with
        | isTrue zero => Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le _)
        | isFalse pos => match total_pos cs (Nat.pos_of_ne_zero pos) with
          | ⟨c, inside, positive⟩ =>
            have other : x ≠ g := fun same => quiet ⟨x, present, same, Nat.pos_of_ne_zero pos⟩
            Nat.le_trans ((within t from_ to).2 x present) (Nat.le_trans
              (Nat.le_of_eq ((if_pos ⟨acting t x c present positive, other⟩).symm.trans
                (if_pos rfl).symm))
              (le_total_of_mem (q := fun h => if h = x then
                (if W.active t h ∧ h ≠ g then cap t h else 0) else 0) (only t x c inside present positive)))
      absurd (Nat.lt_of_le_of_lt lower (Nat.lt_of_le_of_lt (Nat.le_trans (total_le _ each)
        (Nat.le_trans (Nat.le_of_eq (total_swap (fun x h => if h = x then
            (if W.active t h ∧ h ≠ g then cap t h else 0) else 0) ks (L.present t)))
          (total_le ks fun h _ => Nat.le_trans (total_le_at (a := h) (fun b pos => match decEq h b with
              | isTrue same => same.symm
              | isFalse other => absurd pos (fun p => Nat.lt_irrefl 0
                  (Nat.lt_of_lt_of_le p (Nat.le_of_eq (if_neg other))))) (within t from_ to).1)
            (Nat.le_of_eq (if_pos rfl))))) below)) (Nat.lt_irrefl _)

end Flow

/-! ## Giving shared within capacities, and exactly when a feeder is needed -/

section Sharing

variable {α β : Type}

/-- Two lists paired in order, as far as the shorter goes. -/
def pairUp : List α → List β → List (α × β)
  | [], [] => []
  | [], _ :: _ => []
  | _ :: _, [] => []
  | a :: as, b :: bs => (a, b) :: pairUp as bs

/-- Over the units of `r`, a total weighs each listed item by its count. -/
theorem total_unitsOn (q r : α → Nat) :
    ∀ as : List α, total (unitsOn r as) q = total as fun a => r a * q a
  | [] => rfl
  | a :: as => (total_append q (unitsOn r as) (List.replicate (r a) a)).trans
      (Naturals.add_congr (total_replicate q a (r a)) (total_unitsOn q r as))

/-- A member of an item repeated is the item, repeated at least once. -/
theorem mem_replicate_pos {a x : α} : ∀ {k : Nat}, x ∈ List.replicate k a → x = a ∧ 0 < k
  | 0, mem => nomatch mem
  | k + 1, mem => match mem_cons_cases mem with
    | .inl same => ⟨same, Nat.succ_pos k⟩
    | .inr later => ⟨(mem_replicate_pos later).1, Nat.succ_pos k⟩

/-- A unit of `r` over a list is a listed item with a positive count. -/
theorem mem_unitsOn {r : α → Nat} {x : α} :
    ∀ {as : List α}, x ∈ unitsOn r as → x ∈ as ∧ 0 < r x
  | [], mem => nomatch mem
  | a :: as, mem => match mem_append_cases (l := List.replicate (r a) a) (m := unitsOn r as) mem with
    | .inl here => match mem_replicate_pos here with
      | ⟨same, pos⟩ => ⟨Eq.subst (motive := fun y => y ∈ a :: as) same.symm (.head as),
          Eq.subst (motive := fun y => 0 < r y) same.symm pos⟩
    | .inr later => match mem_unitsOn later with
      | ⟨inside, pos⟩ => ⟨.tail a inside, pos⟩

/-- Paired with a list at least as long, every item of a list is paired: a total over the first
members of the pairs is the list's total. -/
theorem total_pairUp_fst (q : α → Nat) :
    ∀ (as : List α) (bs : List β), total as (fun _ => 1) ≤ total bs (fun _ => 1) →
      total (pairUp as bs) (fun z => q z.1) = total as q
  | [], [], _ => rfl
  | [], _ :: _, _ => rfl
  | _ :: rest, [], long =>
    absurd (Nat.le_trans (Nat.le_add_right 1 (total rest fun _ => 1)) long) (Nat.not_succ_le_zero 0)
  | a :: as, _ :: bs, long =>
    congrArg (q a + ·) (total_pairUp_fst q as bs (Naturals.le_of_add_le_add_left long))

/-- A total over the second members of the pairs is at most the second list's total. -/
theorem total_pairUp_snd_le (q : β → Nat) :
    ∀ (as : List α) (bs : List β), total (pairUp as bs) (fun z => q z.2) ≤ total bs q
  | [], [] => Nat.le_refl 0
  | [], _ :: _ => Nat.zero_le _
  | _ :: _, [] => Nat.le_refl 0
  | _ :: as, b :: bs => Nat.add_le_add_left (total_pairUp_snd_le q as bs) (q b)

/-- A pair of two lists paired in order pairs a member of the first with a member of the
second. -/
theorem mem_pairUp {z : α × β} :
    ∀ {as : List α} {bs : List β}, z ∈ pairUp as bs → z.1 ∈ as ∧ z.2 ∈ bs
  | [], [], mem => nomatch mem
  | [], _ :: _, mem => nomatch mem
  | _ :: _, [], mem => nomatch mem
  | a :: as, b :: bs, mem => match mem_cons_cases mem with
    | .inl same =>
      ⟨Eq.subst (motive := fun y => y ∈ a :: as) (congrArg Prod.fst same).symm (.head as),
       Eq.subst (motive := fun y => y ∈ b :: bs) (congrArg Prod.snd same).symm (.head bs)⟩
    | .inr later => match mem_pairUp later with
      | ⟨first, second⟩ => ⟨.tail a first, .tail b second⟩

/-- **A total over a list without repetition of what is positive at one member alone is its value
there.** -/
theorem total_eq_at {q : α → Nat} {a : α} {as : List α} (only : ∀ b, 0 < q b → b = a)
    (distinct : Distinct as) (inside : a ∈ as) : total as q = q a :=
  Nat.le_antisymm (total_le_at only distinct) (le_total_of_mem inside)

end Sharing

namespace Web

variable {C : Type} (W : Web F C)

/-- What the step from `t` calls to be given to `c` while a consumer draws on the family: what
`c` rises, and the unit drawn at `c₀` where no condition of the family falls. -/
def demandAt [DecidableEq C] (cs : List C) (c₀ : C) (t : Nat) (c : C) : Nat :=
  rise (fun s => W.level s c) t + W.drawnUnit cs c₀ t c

/-- What `h` can give at the step from `t`, counted apart from `g`: its capacity where it is
active and is not `g`, and nothing otherwise. -/
def otherCapacity [∀ t x, Decidable (W.active t x)] [DecidableEq F] (cap : Nat → F → Nat) (g : F)
    (t : Nat) (h : F) : Nat :=
  if W.active t h ∧ h ≠ g then cap t h else 0

/-- What the members of `ks` other than `g`, active at the step from `t`, can give together. -/
def capacityWithout [∀ t x, Decidable (W.active t x)] [DecidableEq F] (cap : Nat → F → Nat)
    (ks : List F) (g : F) (t : Nat) : Nat :=
  total ks (W.otherCapacity cap g t)

/-- The shares of the step from `t`: the units each condition of the family is to be given, in
order, paired with the units the members other than `g` can give, in order. -/
def shares [DecidableEq C] [∀ t x, Decidable (W.active t x)] [DecidableEq F]
    (cap : Nat → F → Nat) (cs : List C) (c₀ : C) (ks : List F) (g : F) (t : Nat) : List (C × F) :=
  pairUp (unitsOn (W.demandAt cs c₀ t) cs) (unitsOn (W.otherCapacity cap g t) ks)

variable {W}

/-- Over a family without repetition holding `c₀`, the demands at its conditions total the step's
demand. -/
theorem total_demandAt [DecidableEq C] {cs : List C} (distinct : Distinct cs) {c₀ : C}
    (inside : c₀ ∈ cs) (t : Nat) : total cs (W.demandAt cs c₀ t) = W.demand cs t :=
  (total_add _ _ cs).trans
    (congrArg (risen cs (fun c s => W.level s c) t + ·) (total_drawnUnit distinct inside t))

/-- What a formation can give apart from `g` is at most its capacity. -/
theorem otherCapacity_le [∀ t x, Decidable (W.active t x)] [DecidableEq F] (cap : Nat → F → Nat)
    (g : F) (t : Nat) (h : F) : W.otherCapacity cap g t h ≤ cap t h :=
  match (instDecidableAnd : Decidable (W.active t h ∧ h ≠ g)) with
  | isTrue both => Nat.le_of_eq (if_pos both)
  | isFalse no => Nat.le_trans (Nat.le_of_eq (if_neg no)) (Nat.zero_le _)

/-- A share pairs a condition of the family with a positive demand and a member, active and not
`g`, with a positive capacity. -/
theorem mem_shares [DecidableEq C] [∀ t x, Decidable (W.active t x)] [DecidableEq F]
    {cap : Nat → F → Nat} {cs : List C} {c₀ : C} {ks : List F} {g : F} {t : Nat} {z : C × F}
    (mem : z ∈ W.shares cap cs c₀ ks g t) :
    z.1 ∈ cs ∧ 0 < W.demandAt cs c₀ t z.1 ∧ z.2 ∈ ks ∧ W.active t z.2 ∧ z.2 ≠ g :=
  match mem_pairUp mem with
  | ⟨first, second⟩ => match mem_unitsOn first, mem_unitsOn second with
    | ⟨inside, owed⟩, ⟨member, spare⟩ =>
      ⟨inside, owed, member, match (instDecidableAnd : Decidable (W.active t z.2 ∧ z.2 ≠ g)) with
        | isTrue both => both
        | isFalse no =>
          absurd (Nat.lt_of_lt_of_le spare (Nat.le_of_eq (if_neg no))) (Nat.lt_irrefl 0)⟩

end Web

namespace Flow

variable {C : Type}

/-- Across a stretch, the flow read off a web in which `f` draws as in the least flow and the
members of `ks` other than `g`, active at the step, share the giving within their capacities:
each member gives each condition as many units as the shares pair them. Outside the stretch
nothing takes part. -/
def sharedDrawn [DecidableEq F] [DecidableEq C] (W : Web F C) [∀ t x, Decidable (W.active t x)]
    (cap : Nat → F → Nat) (cs : List C) (c₀ : C) (ks : List F) (T n : Nat) (f g : F) :
    Flow F C where
  present t := if T ≤ t ∧ t < T + n then f :: ks else []
  take t x c := if x = f ∧ (∃ d, d ∈ cs ∧ d = c) then
      fall (fun s => W.level s c) t + W.drawnUnit cs c₀ t c else 0
  give t x c := total (W.shares cap cs c₀ ks g t) fun z => if z.1 = c ∧ z.2 = x then 1 else 0

section Shared

variable [DecidableEq F] [DecidableEq C] {W : Web F C} [∀ t x, Decidable (W.active t x)]
  {cap : Nat → F → Nat} {cs : List C} {c₀ : C} {ks : List F} {T n : Nat} {f g : F}

/-- What gives in the shared flow is a member of `ks` other than `g`, active at the step, and it
gives to a condition of the family. -/
theorem sharedDrawn_gives {t : Nat} {x : F} {c : C}
    (gives : 0 < (sharedDrawn W cap cs c₀ ks T n f g).give t x c) :
    c ∈ cs ∧ x ∈ ks ∧ W.active t x ∧ x ≠ g :=
  match total_pos (W.shares cap cs c₀ ks g t) gives with
  | ⟨z, mem, positive⟩ =>
    match (instDecidableAnd : Decidable (z.1 = c ∧ z.2 = x)) with
    | isFalse no =>
      absurd (Nat.lt_of_lt_of_le positive (Nat.le_of_eq (if_neg no))) (Nat.lt_irrefl 0)
    | isTrue ⟨first, second⟩ => match Web.mem_shares mem with
      | ⟨inside, _, member, active, other⟩ =>
        ⟨Eq.subst (motive := fun y => y ∈ cs) first inside,
         Eq.subst (motive := fun y => y ∈ ks) second member,
         Eq.subst (motive := fun y => W.active t y) second active,
         Eq.subst (motive := fun y => y ≠ g) second other⟩

/-- **The members give each condition of the family what the step demands of it**, where their
capacity covers the step's demand. -/
theorem sharedDrawn_given_members (distinct : Distinct cs) (inside : c₀ ∈ cs) (apart : Distinct ks)
    {t : Nat} (covers : W.demand cs t ≤ W.capacityWithout cap ks g t) {c : C} (member : c ∈ cs) :
    total ks (fun x => (sharedDrawn W cap cs c₀ ks T n f g).give t x c) = W.demandAt cs c₀ t c :=
  have long : total (unitsOn (W.demandAt cs c₀ t) cs) (fun _ => 1) ≤
      total (unitsOn (W.otherCapacity cap g t) ks) (fun _ => 1) :=
    Nat.le_trans (Nat.le_of_eq ((total_unitsOn (fun _ => 1) _ cs).trans
      ((total_congr_on fun _ _ => Nat.mul_one _).trans (Web.total_demandAt distinct inside t))))
      (Nat.le_trans covers (Nat.le_of_eq ((total_unitsOn (fun _ => 1) _ ks).trans
        (total_congr_on fun _ _ => Nat.mul_one _)).symm))
  show total ks (fun x => total (W.shares cap cs c₀ ks g t) fun z => if z.1 = c ∧ z.2 = x then 1 else 0)
      = W.demandAt cs c₀ t c from
  (total_swap (fun (x : F) (z : C × F) => if z.1 = c ∧ z.2 = x then 1 else 0)
    (W.shares cap cs c₀ ks g t) ks).trans
    ((total_congr_on (g := fun (z : C × F) => if z.1 = c then 1 else 0) fun z mem =>
      match Web.mem_shares mem with
      | ⟨_, _, inks, _, _⟩ => match decEq z.1 c with
        | isTrue same => (total_eq_at (a := z.2) (fun (x : F) pos =>
              match (instDecidableAnd : Decidable (z.1 = c ∧ z.2 = x)) with
              | isTrue both => both.2.symm
              | isFalse no =>
                absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (if_neg no))) (Nat.lt_irrefl 0))
            apart inks).trans ((if_pos ⟨same, rfl⟩).trans (if_pos same).symm)
        | isFalse other =>
          (total_eq_zero fun _ _ => if_neg fun both => other both.1).trans (if_neg other).symm).trans
      ((total_pairUp_fst (fun d => if d = c then 1 else 0) _ _ long).trans
        ((total_unitsOn (fun d => if d = c then 1 else 0) _ cs).trans
          ((total_eq_at (a := c) (fun (d : C) pos => match decEq d c with
              | isTrue same => same
              | isFalse other => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
                  ((congrArg (W.demandAt cs c₀ t d * ·) (if_neg other)).trans (Nat.mul_zero _))))
                  (Nat.lt_irrefl 0)) distinct member).trans
            ((congrArg (W.demandAt cs c₀ t c * ·) (if_pos rfl)).trans (Nat.mul_one _))))))

/-- The shared flow balances on the family at every step of the stretch, where the members'
capacity covers the demand there and `f` is not a member. -/
theorem sharedDrawn_balancesOn (distinct : Distinct cs) (inside : c₀ ∈ cs) (apart : Distinct ks)
    (outside : ¬ f ∈ ks)
    (covers : ∀ t, T ≤ t → t < T + n → W.demand cs t ≤ W.capacityWithout cap ks g t) :
    ∀ t, T ≤ t → t < T + n → (sharedDrawn W cap cs c₀ ks T n f g).BalancesOn W cs t := by
  intro t from_ to c member
  have present : (sharedDrawn W cap cs c₀ ks T n f g).present t = f :: ks := if_pos ⟨from_, to⟩
  have takeSelf : (sharedDrawn W cap cs c₀ ks T n f g).take t f c =
      fall (fun s => W.level s c) t + W.drawnUnit cs c₀ t c := if_pos ⟨rfl, ⟨c, member, rfl⟩⟩
  have takeOthers : total ks (fun x => (sharedDrawn W cap cs c₀ ks T n f g).take t x c) = 0 :=
    total_eq_zero fun x inks =>
      if_neg fun both => outside (Eq.subst (motive := fun y => y ∈ ks) both.1 inks)
  have giveSelf : (sharedDrawn W cap cs c₀ ks T n f g).give t f c = 0 :=
    eq_zero_of_not_pos fun pos => outside (sharedDrawn_gives pos).2.1
  have giveOthers : total ks (fun x => (sharedDrawn W cap cs c₀ ks T n f g).give t x c) =
      rise (fun s => W.level s c) t + W.drawnUnit cs c₀ t c :=
    sharedDrawn_given_members distinct inside apart (covers t from_ to) member
  show W.level (t + 1) c + total ((sharedDrawn W cap cs c₀ ks T n f g).present t)
      (fun x => (sharedDrawn W cap cs c₀ ks T n f g).take t x c) =
    W.level t c + total ((sharedDrawn W cap cs c₀ ks T n f g).present t)
      (fun x => (sharedDrawn W cap cs c₀ ks T n f g).give t x c)
  rw [present]
  show W.level (t + 1) c + ((sharedDrawn W cap cs c₀ ks T n f g).take t f c +
      total ks (fun x => (sharedDrawn W cap cs c₀ ks T n f g).take t x c)) =
    W.level t c + ((sharedDrawn W cap cs c₀ ks T n f g).give t f c +
      total ks (fun x => (sharedDrawn W cap cs c₀ ks T n f g).give t x c))
  rw [takeSelf, takeOthers, giveSelf, giveOthers]
  exact (congrArg (W.level (t + 1) c + ·) (Nat.add_zero _)).trans ((Nat.add_assoc _ _ _).symm.trans
    ((congrArg (· + W.drawnUnit cs c₀ t c) (across (fun s => W.level s c) t)).trans
      ((Nat.add_assoc _ _ _).trans (congrArg (W.level t c + ·) (Nat.zero_add _).symm))))

/-- In the shared flow only active formations give. -/
theorem sharedDrawn_acting : (sharedDrawn W cap cs c₀ ks T n f g).Acting W :=
  fun _ _ _ _ gives => (sharedDrawn_gives gives).2.2.1

/-- **In the shared flow each formation gives the family at most what it can give apart from
`g`.** -/
theorem sharedDrawn_given_le (distinct : Distinct cs) (apart : Distinct ks) (t : Nat) (x : F) :
    total cs ((sharedDrawn W cap cs c₀ ks T n f g).give t x) ≤ W.otherCapacity cap g t x :=
  show total cs (fun c => total (W.shares cap cs c₀ ks g t) fun z => if z.1 = c ∧ z.2 = x then 1 else 0)
      ≤ W.otherCapacity cap g t x from
  Nat.le_trans (Nat.le_of_eq (total_swap (fun (c : C) (z : C × F) => if z.1 = c ∧ z.2 = x then 1 else 0)
      (W.shares cap cs c₀ ks g t) cs))
    (Nat.le_trans (total_le (q := fun (z : C × F) => if z.2 = x then 1 else 0) _ fun z _ => Nat.le_trans
        (total_le_at (a := z.1) (fun (c : C) pos =>
          match (instDecidableAnd : Decidable (z.1 = c ∧ z.2 = x)) with
          | isTrue both => both.1.symm
          | isFalse no =>
            absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (if_neg no))) (Nat.lt_irrefl 0))
          distinct)
        (match decEq z.2 x with
          | isTrue same => Nat.le_of_eq ((if_pos ⟨rfl, same⟩).trans (if_pos same).symm)
          | isFalse other =>
            Nat.le_trans (Nat.le_of_eq (if_neg fun both => other both.2)) (Nat.zero_le _)))
      (Nat.le_trans (total_pairUp_snd_le (fun h => if h = x then 1 else 0) _ _)
        (Nat.le_trans (Nat.le_of_eq (total_unitsOn (fun h => if h = x then 1 else 0) _ ks))
          (Nat.le_trans (total_le_at (a := x) (fun (h : F) pos => match decEq h x with
              | isTrue same => same
              | isFalse other => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
                  ((congrArg (W.otherCapacity cap g t h * ·) (if_neg other)).trans
                    (Nat.mul_zero _)))) (Nat.lt_irrefl 0)) apart)
            (Nat.le_of_eq ((congrArg (W.otherCapacity cap g t x * ·) (if_pos rfl)).trans
              (Nat.mul_one _)))))))

/-- In the shared flow `g` gives the family nothing. -/
theorem sharedDrawn_quiet (distinct : Distinct cs) (apart : Distinct ks) (t : Nat) :
    total cs ((sharedDrawn W cap cs c₀ ks T n f g).give t g) = 0 :=
  Nat.le_antisymm (Nat.le_trans (sharedDrawn_given_le distinct apart t g)
    (Nat.le_of_eq (if_neg fun both => both.2 rfl))) (Nat.zero_le _)

/-- The shared flow is read off the web with capacities for a family fed only from `ks`, where the
members' capacity covers the demand at every step of the stretch and `f` is not a member. -/
theorem sharedDrawn_fedOnlyWithin (distinct : Distinct cs) (inside : c₀ ∈ cs) (apart : Distinct ks)
    (outside : ¬ f ∈ ks)
    (covers : ∀ t, T ≤ t → t < T + n → W.demand cs t ≤ W.capacityWithout cap ks g t) :
    FedOnlyWithin W cap cs (· ∈ ks) T n (sharedDrawn W cap cs c₀ ks T n f g) :=
  ⟨⟨sharedDrawn_balancesOn distinct inside apart outside covers, sharedDrawn_acting,
    fun _ _ _ _ _ gives => (sharedDrawn_gives gives).2.1⟩,
   fun t from_ to =>
    have present : (sharedDrawn W cap cs c₀ ks T n f g).present t = f :: ks := if_pos ⟨from_, to⟩
    ⟨Eq.subst (motive := fun l => Distinct l) present.symm ⟨outside, apart⟩,
     fun x _ => Nat.le_trans (sharedDrawn_given_le distinct apart t x)
       (Web.otherCapacity_le cap g t x)⟩⟩

/-- In the shared flow `f` draws past the family's stock, where it is active across a stretch
longer than the stock and the family holds `c₀`. -/
theorem sharedDrawn_drawsPast (inside : c₀ ∈ cs)
    (alive : ∀ t, T ≤ t → t < T + n → W.active t f) (below : W.stock cs T < n) :
    DrawsPast cs T n (sharedDrawn W cap cs c₀ ks T n f g, W) f :=
  ⟨below, fun t from_ to =>
    have present : (sharedDrawn W cap cs c₀ ks T n f g).present t = f :: ks := if_pos ⟨from_, to⟩
    ⟨alive t from_ to, Eq.subst (motive := fun l => f ∈ l) present.symm (.head _),
     match W.decSomeFalls cs t with
     | isTrue ⟨c, mem, falls⟩ =>
       total_pos_of_mem (q := (sharedDrawn W cap cs c₀ ks T n f g).take t f) mem
        (Nat.lt_of_lt_of_le (excess_pos.mpr falls) (Nat.le_trans (Nat.le_add_right _ _)
          (Nat.le_of_eq (if_pos ⟨rfl, ⟨c, mem, rfl⟩⟩).symm)))
     | isFalse steady =>
       total_pos_of_mem (q := (sharedDrawn W cap cs c₀ ks T n f g).take t f) inside
        (Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_trans (Nat.le_add_left _ _)
          (Nat.le_trans (Nat.le_of_eq (congrArg (fall (fun s => W.level s c₀) t + ·)
            (if_pos ⟨rfl, steady⟩)).symm)
            (Nat.le_of_eq (if_pos ⟨rfl, ⟨c₀, inside, rfl⟩⟩).symm))))⟩⟩

/-- In the shared flow `g` never gives to the family. -/
theorem sharedDrawn_not_gives (distinct : Distinct cs) (apart : Distinct ks) :
    ¬ GivesWithin cs T n (sharedDrawn W cap cs c₀ ks T n f g, W) g :=
  fun ⟨t, _, _, _, gives⟩ => Nat.lt_irrefl 0
    (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (sharedDrawn_quiet distinct apart t)))

end Shared

/-- **A feeder is needed exactly where the others could not together give the demand.** Over the
flows read off a web with capacities, for a family without repetition holding `c₀`, fed only from
the members of a list without repetition, with activity and identity decided, let `f`, not a
member, be active across a stretch longer than the family's stock. Then `f` drawing past the
stock needs `g`'s giving exactly where, at some step of the stretch, what the active members other
than `g` can give together falls short of the step's demand. -/
theorem needs_giver_iff_short [DecidableEq F] [DecidableEq C] {W : Web F C}
    [∀ t x, Decidable (W.active t x)] {cap : Nat → F → Nat} {cs : List C} (distinct : Distinct cs)
    {c₀ : C} (inside : c₀ ∈ cs) {ks : List F} (apart : Distinct ks) {T n : Nat} {f g : F}
    (outside : ¬ f ∈ ks) (alive : ∀ t, T ≤ t → t < T + n → W.active t f)
    (below : W.stock cs T < n) :
    NeedsPart (FedOnlyWithin W cap cs (· ∈ ks) T n) (fun L => DrawsPast cs T n (L, W))
        (fun L => GivesWithin cs T n (L, W)) f g ↔
      ∃ t, T ≤ t ∧ t < T + n ∧ W.capacityWithout cap ks g t < W.demand cs t :=
  ⟨fun needs => match decideSome (p := fun t => W.capacityWithout cap ks g t < W.demand cs t)
      (steps T n) with
    | isTrue ⟨t, mem, short⟩ => match between_of_mem_steps mem with
      | ⟨from_, to⟩ => ⟨t, from_, to, short⟩
    | isFalse covered =>
      absurd (needs _ (sharedDrawn_fedOnlyWithin (c₀ := c₀) distinct inside apart outside
          fun t from_ to => Nat.ge_of_not_lt fun short =>
            covered ⟨t, steps_of_within from_ to, short⟩)
        (sharedDrawn_drawsPast inside alive below))
        (sharedDrawn_not_gives distinct apart),
   fun short => needs_giver_of_short short⟩

end Flow

/-! ## What a feeder can give, read off its own supply, and need up a hierarchy -/

namespace Flow

variable {C : Type}

/-- What the formations taking part give `cs` across the step from `t` is passed on from `ds`:
each gives `cs` at most what it takes from `ds`. -/
def PassesOn (L : Flow F C) (cs ds : List C) (t : Nat) : Prop :=
  ∀ x, x ∈ L.present t → total cs (L.give t x) ≤ total ds (L.take t x)

/-- **What a family is given, passed on from a supply, is at most what is taken from the
supply.** -/
theorem replenishment_le_uptake {L : Flow F C} {cs ds : List C} {t : Nat}
    (passes : L.PassesOn cs ds t) : L.replenishment cs t ≤ L.uptake ds t :=
  Nat.le_trans (Nat.le_of_eq (total_swap (fun x c => L.give t x c) cs (L.present t)).symm)
    (Nat.le_trans (total_le (L.present t) passes)
      (Nat.le_of_eq (total_swap (fun x d => L.take t x d) ds (L.present t))))

/-- **A supply keeps, with what it passed on, at most what it held and was given.** Where `ds`
balances across the step from `t` and what `cs` is given there is passed on from `ds`, the stock
of `ds` after the step with what `cs` was given is at most its stock before with what `ds` was
given. -/
theorem passed_le_supply {L : Flow F C} {W : Web F C} {cs ds : List C} {t : Nat}
    (balances : L.BalancesOn W ds t) (passes : L.PassesOn cs ds t) :
    W.stock ds (t + 1) + L.replenishment cs t ≤ W.stock ds t + L.replenishment ds t :=
  Nat.le_trans (Nat.add_le_add_left (replenishment_le_uptake passes) _) (Nat.le_of_eq balances.over)

/-- **A supply that nothing feeds passes on at most what it loses.** -/
theorem passed_le_drop {L : Flow F C} {W : Web F C} {cs ds : List C} {t : Nat}
    (balances : L.BalancesOn W ds t) (passes : L.PassesOn cs ds t)
    (unfed : L.replenishment ds t = 0) : W.stock ds (t + 1) + L.replenishment cs t ≤ W.stock ds t :=
  Nat.le_trans (passed_le_supply balances passes)
    (Nat.le_of_eq ((congrArg (W.stock ds t + ·) unfed).trans (Nat.add_zero _)))

/-- **An exhausted supply that nothing feeds passes on nothing.** -/
theorem passed_zero_of_exhausted {L : Flow F C} {W : Web F C} {cs ds : List C} {t : Nat}
    (balances : L.BalancesOn W ds t) (passes : L.PassesOn cs ds t)
    (unfed : L.replenishment ds t = 0) (exhausted : W.stock ds t = 0) : L.replenishment cs t = 0 :=
  Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_left _ _)
    (Nat.le_trans (passed_le_drop balances passes unfed) (Nat.le_of_eq exhausted)))

end Flow

/-- The top of a hierarchy of families: `cs` where nothing lies above it, and otherwise the top
of what lies above. -/
def topTier {C : Type} : List C → List (List C) → List C
  | cs, [] => cs
  | _, ds :: ups => topTier ds ups

namespace Web

variable {C : Type}

/-- What a hierarchy of families holds at `t`: the stocks of its families. -/
def stockTiers (W : Web F C) (t : Nat) : List C → List (List C) → Nat
  | cs, [] => W.stock cs t
  | cs, ds :: ups => W.stock cs t + stockTiers W t ds ups

/-- What `h`'s own store falls across the step from `t`. -/
def storeFall (W : Web F C) (store : F → C) (t : Nat) (h : F) : Nat :=
  fall (fun s => W.level s (store h)) t

end Web

namespace Flow

variable {C : Type}

/-- Every family of a hierarchy balances across the step from `t`. -/
def BalancesTiers (L : Flow F C) (W : Web F C) (t : Nat) : List C → List (List C) → Prop
  | cs, [] => L.BalancesOn W cs t
  | cs, ds :: ups => L.BalancesOn W cs t ∧ BalancesTiers L W t ds ups

/-- Each family of a hierarchy is given, across the step from `t`, only what is passed on from
the family above it. -/
def PassesTiers (L : Flow F C) (t : Nat) : List C → List (List C) → Prop
  | _, [] => True
  | cs, ds :: ups => L.PassesOn cs ds t ∧ PassesTiers L t ds ups

/-- **What is drawn from the bottom of a hierarchy across a stretch is at most what the hierarchy
held at its start and what was given to its top.** -/
theorem uptake_le_tiers {L : Flow F C} {W : Web F C} (T N : Nat) :
    ∀ (cs : List C) (ups : List (List C)),
      (∀ t, T ≤ t → t < T + N → L.BalancesTiers W t cs ups) →
      (∀ t, T ≤ t → t < T + N → L.PassesTiers t cs ups) →
      total (steps T N) (L.uptake cs) ≤
        W.stockTiers T cs ups + total (steps T N) (L.replenishment (topTier cs ups))
  | cs, [], balances, _ =>
    Nat.le_trans (Nat.le_add_left _ (W.stock cs (T + N))) (Nat.le_of_eq (accumulates_on T N balances))
  | cs, ds :: ups, balances, passes =>
    have here : total (steps T N) (L.uptake cs) ≤
        W.stock cs T + total (steps T N) (L.replenishment cs) :=
      Nat.le_trans (Nat.le_add_left _ (W.stock cs (T + N)))
        (Nat.le_of_eq (accumulates_on T N fun t from_ to => (balances t from_ to).1))
    have passed : total (steps T N) (L.replenishment cs) ≤ total (steps T N) (L.uptake ds) :=
      Amounts.total_steps_le T N fun t from_ to => replenishment_le_uptake (passes t from_ to).1
    have above := uptake_le_tiers T N ds ups (fun t from_ to => (balances t from_ to).2)
      (fun t from_ to => (passes t from_ to).2)
    Nat.le_trans here (Nat.le_trans (Nat.add_le_add_left (Nat.le_trans passed above) _)
      (Nat.le_of_eq (Nat.add_assoc _ _ _).symm))

/-- The flows read off a web for a hierarchy fed at its top only from `K`: within the stretch
every family of the hierarchy balances and is given only what is passed on from the family above
it, only active formations give, and only members of `K` give to the top. -/
def FedThroughTiers (W : Web F C) (cs : List C) (ups : List (List C)) (K : F → Prop) (T n : Nat)
    (L : Flow F C) : Prop :=
  (∀ t, T ≤ t → t < T + n → L.BalancesTiers W t cs ups) ∧ L.Acting W ∧
    (∀ t, T ≤ t → t < T + n → L.PassesTiers t cs ups) ∧
    ∀ t g c, c ∈ topTier cs ups → g ∈ L.present t → 0 < L.give t g c → K g

/-- `f` draws past what a hierarchy holds: across a stretch longer than the stocks of all its
families together, `f` is active, takes part and takes from the bottom family at every step. -/
def DrawsPastTiers (cs : List C) (ups : List (List C)) (T n : Nat) (ω : Flow F C × Web F C)
    (f : F) : Prop :=
  ω.2.stockTiers T cs ups < n ∧ ∀ t, T ≤ t → t < T + n →
    ω.2.active t f ∧ f ∈ ω.1.present t ∧ 0 < total cs (ω.1.take t f)

/-- **Need climbs a hierarchy.** Over the flows of a hierarchy fed at its top only from `K`, a
formation drawing past what the whole hierarchy holds needs some member of `K`: what is taken from
the bottom beyond the stocks of all its families was given to its top. With no family above the
bottom it is `needsSome_on`. -/
theorem needsSome_tiers (W : Web F C) (cs : List C) (ups : List (List C)) (K : F → Prop)
    (T n : Nat) (f : F) :
    NeedsSomePart (FedThroughTiers W cs ups K T n) (fun L => DrawsPastTiers cs ups T n (L, W))
      (fun L => GivesWithin (topTier cs ups) T n (L, W)) f K :=
  fun L ⟨balances, _, passes, only⟩ ⟨below, draws⟩ =>
    have taken : n ≤ total (steps T n) (L.uptake cs) :=
      Nat.le_trans (Nat.le_trans (Nat.le_of_eq (Nat.one_mul n).symm)
          (steps_ge (q := fun _ => 1) T n fun _ _ => Nat.le_refl 1))
        (total_le (steps T n) fun t mem => match between_of_mem_steps mem with
          | ⟨from_, to⟩ => uptake_pos (draws t from_ to).2.1 (draws t from_ to).2.2)
    have given : 0 < total (steps T n) (L.replenishment (topTier cs ups)) :=
      Nat.pos_of_ne_zero fun zero => Nat.lt_irrefl (W.stockTiers T cs ups)
        (Nat.lt_of_lt_of_le below (Nat.le_trans taken (Nat.le_trans
          (uptake_le_tiers T n cs ups balances passes)
          (Nat.le_of_eq ((congrArg (W.stockTiers T cs ups + ·) zero).trans (Nat.add_zero _))))))
    match total_pos (steps T n) given with
    | ⟨t, mem, replenished⟩ => match between_of_mem_steps mem with
      | ⟨from_, to⟩ => match total_pos (topTier cs ups) replenished with
        | ⟨c, inside, positive⟩ => match total_pos (L.present t) positive with
          | ⟨g, present, gives⟩ =>
            ⟨g, only t g c inside present gives, t, from_, to, present,
             total_pos_of_mem inside gives⟩

/-- The flows read off a web for a family fed only from the members of `ks`, each giving what it
takes from its own store, which nothing feeds: read off the web for the family, with the
formations taking part distinct at each step of the stretch, each member's store balancing and
given nothing, and each member giving the family at most what it takes from its own store. -/
def FedFromStores (W : Web F C) (store : F → C) (cs : List C) (ks : List F) (T n : Nat)
    (L : Flow F C) : Prop :=
  FedOnlyOn W cs (· ∈ ks) T n L ∧ ∀ t, T ≤ t → t < T + n →
    Distinct (L.present t) ∧ ∀ h, h ∈ ks →
      L.BalancesOn W [store h] t ∧ L.given t (store h) = 0 ∧
        (h ∈ L.present t → total cs (L.give t h) ≤ L.take t h (store h))

/-- **What a feeder takes from its own store, which nothing feeds, is at most what the store
falls.** -/
theorem take_le_storeFall {L : Flow F C} {W : Web F C} {store : F → C} {t : Nat} {h : F}
    (balances : L.BalancesOn W [store h] t) (unfed : L.given t (store h) = 0)
    (present : h ∈ L.present t) : L.take t h (store h) ≤ W.storeFall store t h :=
  have taken : W.level (t + 1) (store h) + L.taken t (store h) = W.level t (store h) :=
    (balances (store h) (.head [])).trans
      ((congrArg (W.level t (store h) + ·) unfed).trans (Nat.add_zero _))
  Nat.le_trans (le_total_of_mem (q := fun x => L.take t x (store h)) present)
    (Naturals.le_of_add_le_add_left (k := W.level (t + 1) (store h))
      (Nat.le_trans (Nat.le_of_eq taken) (Nat.le_trans (Nat.le_add_right _ _)
        (Nat.le_of_eq (across (fun s => W.level s (store h)) t).symm))))

/-- **The flows of a family fed from its feeders' own stores are flows read off the web with
capacities, each feeder's capacity at a step being what its store falls there.** -/
theorem fedFromStores_within {W : Web F C} {store : F → C} {cs : List C} {ks : List F}
    {T n : Nat} {L : Flow F C} (fed : FedFromStores W store cs ks T n L) :
    FedOnlyWithin W (W.storeFall store) cs (· ∈ ks) T n L :=
  ⟨fed.1, fun t from_ to => match fed.2 t from_ to with
    | ⟨distinct, own⟩ => ⟨distinct, fun x present =>
      match Nat.decEq (total cs (L.give t x)) 0 with
      | isTrue zero => Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le _)
      | isFalse pos => match total_pos cs (Nat.pos_of_ne_zero pos) with
        | ⟨c, inside, gives⟩ => match own x (fed.1.2.2 t x c inside present gives) with
          | ⟨balances, unfed, passes⟩ =>
            Nat.le_trans (passes present) (take_le_storeFall balances unfed present)⟩⟩

/-- Across a stretch, the shared flow with capacities read off the members' own stores, in which
each member also takes from its own store what the store falls. -/
def storeDrawn [DecidableEq F] [DecidableEq C] (W : Web F C) [∀ t x, Decidable (W.active t x)]
    (store : F → C) (cs : List C) (c₀ : C) (ks : List F) (T n : Nat) (f g : F) : Flow F C :=
  { sharedDrawn W (W.storeFall store) cs c₀ ks T n f g with
    take := fun t x c => if x = f ∧ (∃ d, d ∈ cs ∧ d = c) then
        fall (fun s => W.level s c) t + W.drawnUnit cs c₀ t c
      else if (∃ h, h ∈ ks ∧ h = x) ∧ c = store x then W.storeFall store t x else 0 }

section Stored

variable [DecidableEq F] [DecidableEq C] {W : Web F C} [∀ t x, Decidable (W.active t x)]
  {store : F → C} {cs : List C} {c₀ : C} {ks : List F} {T n : Nat} {f g : F}

/-- The shared flow from the stores balances on the family at every step of the stretch, where
the members' capacity covers the demand there, `f` is not a member and no store is in the
family. -/
theorem storeDrawn_balancesOn (distinct : Distinct cs) (inside : c₀ ∈ cs) (apart : Distinct ks)
    (outside : ¬ f ∈ ks) (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs)
    (covers : ∀ t, T ≤ t → t < T + n →
      W.demand cs t ≤ W.capacityWithout (W.storeFall store) ks g t) :
    ∀ t, T ≤ t → t < T + n → (storeDrawn W store cs c₀ ks T n f g).BalancesOn W cs t := by
  intro t from_ to c member
  have present : (storeDrawn W store cs c₀ ks T n f g).present t = f :: ks := if_pos ⟨from_, to⟩
  have takeSelf : (storeDrawn W store cs c₀ ks T n f g).take t f c =
      fall (fun s => W.level s c) t + W.drawnUnit cs c₀ t c := if_pos ⟨rfl, ⟨c, member, rfl⟩⟩
  have takeOthers : total ks (fun x => (storeDrawn W store cs c₀ ks T n f g).take t x c) = 0 :=
    total_eq_zero fun x inks =>
      (if_neg fun both => outside (Eq.subst (motive := fun y => y ∈ ks) both.1 inks)).trans
        (if_neg fun both => separate x inks (Eq.subst (motive := fun y => y ∈ cs) both.2 member))
  have giveSelf : (storeDrawn W store cs c₀ ks T n f g).give t f c = 0 :=
    eq_zero_of_not_pos fun pos => outside (sharedDrawn_gives (W := W) (cap := W.storeFall store)
      (cs := cs) (c₀ := c₀) (ks := ks) (T := T) (n := n) (f := f) (g := g) pos).2.1
  have giveOthers : total ks (fun x => (storeDrawn W store cs c₀ ks T n f g).give t x c) =
      rise (fun s => W.level s c) t + W.drawnUnit cs c₀ t c :=
    sharedDrawn_given_members (W := W) (cap := W.storeFall store) (T := T) (n := n) (f := f)
      distinct inside apart (covers t from_ to) member
  show W.level (t + 1) c + total ((storeDrawn W store cs c₀ ks T n f g).present t)
      (fun x => (storeDrawn W store cs c₀ ks T n f g).take t x c) =
    W.level t c + total ((storeDrawn W store cs c₀ ks T n f g).present t)
      (fun x => (storeDrawn W store cs c₀ ks T n f g).give t x c)
  rw [present]
  show W.level (t + 1) c + ((storeDrawn W store cs c₀ ks T n f g).take t f c +
      total ks (fun x => (storeDrawn W store cs c₀ ks T n f g).take t x c)) =
    W.level t c + ((storeDrawn W store cs c₀ ks T n f g).give t f c +
      total ks (fun x => (storeDrawn W store cs c₀ ks T n f g).give t x c))
  rw [takeSelf, takeOthers, giveSelf, giveOthers]
  exact (congrArg (W.level (t + 1) c + ·) (Nat.add_zero _)).trans ((Nat.add_assoc _ _ _).symm.trans
    ((congrArg (· + W.drawnUnit cs c₀ t c) (across (fun s => W.level s c) t)).trans
      ((Nat.add_assoc _ _ _).trans (congrArg (W.level t c + ·) (Nat.zero_add _).symm))))

/-- In the shared flow from the stores nothing is given to a member's store, which is not in the
family. -/
theorem storeDrawn_given_store (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} {h : F}
    (member : h ∈ ks) : (storeDrawn W store cs c₀ ks T n f g).given t (store h) = 0 :=
  total_eq_zero fun _ _ => eq_zero_of_not_pos fun pos => separate h member
    (sharedDrawn_gives (W := W) (cap := W.storeFall store) (cs := cs) (c₀ := c₀) (ks := ks) (T := T)
      (n := n) (f := f) (g := g) pos).1

/-- **What each member takes from its own store in the shared flow from the stores is what the
store falls**, and nothing else takes from it, where the stores are the members' own and not in
the family. -/
theorem storeDrawn_taken_store (apart : Distinct ks) (outside : ¬ f ∈ ks)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} {h : F} (member : h ∈ ks) :
    total ks (fun x => (storeDrawn W store cs c₀ ks T n f g).take t x (store h)) =
      W.storeFall store t h :=
  have inFamily : ¬ ∃ d, d ∈ cs ∧ d = store h := fun ⟨_, dIn, same⟩ =>
    separate h member (Eq.subst (motive := fun y => y ∈ cs) same dIn)
  (total_eq_at (a := h) (fun x pos =>
      match (instDecidableAnd : Decidable (x = f ∧ ∃ d, d ∈ cs ∧ d = store h)) with
      | isTrue both => absurd both.2 inFamily
      | isFalse first =>
        match (instDecidableAnd : Decidable ((∃ h', h' ∈ ks ∧ h' = x) ∧ store h = store x)) with
        | isTrue ⟨⟨_, mem, same⟩, stores⟩ =>
          (own h x member (Eq.subst (motive := fun y => y ∈ ks) same mem) stores).symm
        | isFalse second => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
            ((if_neg first).trans (if_neg second)))) (Nat.lt_irrefl 0))
    apart member).trans
    ((if_neg fun both => outside (Eq.subst (motive := fun y => y ∈ ks) both.1 member)).trans
      (if_pos ⟨⟨h, member, rfl⟩, rfl⟩))

/-- Each member's store balances in the shared flow from the stores, where the store does not
rise across the step. -/
theorem storeDrawn_balances_store (apart : Distinct ks) (outside : ¬ f ∈ ks)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    {h : F} (member : h ∈ ks) (steady : ¬ W.Rises t (store h)) :
    (storeDrawn W store cs c₀ ks T n f g).BalancesOn W [store h] t := by
  intro c mem
  have same : c = store h := match mem_cons_cases mem with
    | .inl same => same
    | .inr empty => nomatch empty
  subst same
  have present : (storeDrawn W store cs c₀ ks T n f g).present t = f :: ks := if_pos ⟨from_, to⟩
  have takeSelf : (storeDrawn W store cs c₀ ks T n f g).take t f (store h) = 0 :=
    (if_neg fun both => match both.2 with
      | ⟨_, dIn, same⟩ => separate h member (Eq.subst (motive := fun y => y ∈ cs) same dIn)).trans
      (if_neg fun both => match both.1 with
        | ⟨_, mem', same⟩ => outside (Eq.subst (motive := fun y => y ∈ ks) same mem'))
  have flat : rise (fun s => W.level s (store h)) t = 0 :=
    eq_zero_of_not_pos fun pos => steady (excess_pos.mp pos)
  show W.level (t + 1) (store h) + total ((storeDrawn W store cs c₀ ks T n f g).present t)
      (fun x => (storeDrawn W store cs c₀ ks T n f g).take t x (store h)) =
    W.level t (store h) + (storeDrawn W store cs c₀ ks T n f g).given t (store h)
  rw [present, storeDrawn_given_store separate member]
  show W.level (t + 1) (store h) + ((storeDrawn W store cs c₀ ks T n f g).take t f (store h) +
      total ks (fun x => (storeDrawn W store cs c₀ ks T n f g).take t x (store h))) =
    W.level t (store h) + 0
  rw [takeSelf, storeDrawn_taken_store apart outside own separate member]
  exact (congrArg (W.level (t + 1) (store h) + ·) (Nat.zero_add _)).trans
    ((across (fun s => W.level s (store h)) t).trans (congrArg (W.level t (store h) + ·) flat))

/-- The shared flow from the stores is a flow of the family fed from its feeders' own stores,
where the members' capacity covers the demand at every step of the stretch, `f` is not a member,
the stores are the members' own and not in the family, and no store rises within the stretch. -/
theorem storeDrawn_fedFromStores (distinct : Distinct cs) (inside : c₀ ∈ cs) (apart : Distinct ks)
    (outside : ¬ f ∈ ks) (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs)
    (steady : ∀ t, T ≤ t → t < T + n → ∀ h, h ∈ ks → ¬ W.Rises t (store h))
    (covers : ∀ t, T ≤ t → t < T + n →
      W.demand cs t ≤ W.capacityWithout (W.storeFall store) ks g t) :
    FedFromStores W store cs ks T n (storeDrawn W store cs c₀ ks T n f g) :=
  ⟨⟨storeDrawn_balancesOn distinct inside apart outside separate covers,
    fun _ _ _ _ gives => (sharedDrawn_gives (W := W) (cap := W.storeFall store) (cs := cs)
      (c₀ := c₀) (ks := ks) (T := T) (n := n) (f := f) (g := g) gives).2.2.1,
    fun _ _ _ _ _ gives => (sharedDrawn_gives (W := W) (cap := W.storeFall store) (cs := cs)
      (c₀ := c₀) (ks := ks) (T := T) (n := n) (f := f) (g := g) gives).2.1⟩,
   fun t from_ to =>
    have present : (storeDrawn W store cs c₀ ks T n f g).present t = f :: ks := if_pos ⟨from_, to⟩
    ⟨Eq.subst (motive := fun l => Distinct l) present.symm ⟨outside, apart⟩, fun h member =>
      ⟨storeDrawn_balances_store apart outside own separate from_ to member (steady t from_ to h member),
       storeDrawn_given_store separate member,
       fun _ => Nat.le_trans (sharedDrawn_given_le (W := W) (cap := W.storeFall store) (c₀ := c₀)
           (T := T) (n := n) (f := f) distinct apart t h)
         (Nat.le_trans (Web.otherCapacity_le (W.storeFall store) g t h)
           (Nat.le_of_eq ((if_pos ⟨⟨h, member, rfl⟩, rfl⟩).symm.trans
             (if_neg fun both => outside (Eq.subst (motive := fun y => y ∈ ks) both.1 member)).symm)))⟩⟩⟩

/-- In the shared flow from the stores `f` draws past the family's stock, where it is active
across a stretch longer than the stock and the family holds `c₀`. -/
theorem storeDrawn_drawsPast (inside : c₀ ∈ cs)
    (alive : ∀ t, T ≤ t → t < T + n → W.active t f) (below : W.stock cs T < n) :
    DrawsPast cs T n (storeDrawn W store cs c₀ ks T n f g, W) f :=
  ⟨below, fun t from_ to =>
    have present : (storeDrawn W store cs c₀ ks T n f g).present t = f :: ks := if_pos ⟨from_, to⟩
    ⟨alive t from_ to, Eq.subst (motive := fun l => f ∈ l) present.symm (.head _),
     match W.decSomeFalls cs t with
     | isTrue ⟨c, mem, falls⟩ =>
       total_pos_of_mem (q := (storeDrawn W store cs c₀ ks T n f g).take t f) mem
        (Nat.lt_of_lt_of_le (excess_pos.mpr falls) (Nat.le_trans (Nat.le_add_right _ _)
          (Nat.le_of_eq (if_pos ⟨rfl, ⟨c, mem, rfl⟩⟩).symm)))
     | isFalse steady =>
       total_pos_of_mem (q := (storeDrawn W store cs c₀ ks T n f g).take t f) inside
        (Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_trans (Nat.le_add_left _ _)
          (Nat.le_trans (Nat.le_of_eq (congrArg (fall (fun s => W.level s c₀) t + ·)
            (if_pos ⟨rfl, steady⟩)).symm)
            (Nat.le_of_eq (if_pos ⟨rfl, ⟨c₀, inside, rfl⟩⟩).symm))))⟩⟩

/-- In the shared flow from the stores `g` never gives to the family. -/
theorem storeDrawn_not_gives (distinct : Distinct cs) (apart : Distinct ks) :
    ¬ GivesWithin cs T n (storeDrawn W store cs c₀ ks T n f g, W) g :=
  fun gives => sharedDrawn_not_gives (W := W) (cap := W.storeFall store) (c₀ := c₀) (T := T)
    (n := n) (f := f) distinct apart gives

end Stored

/-- **A feeder is needed exactly where what the others' own stores fall falls short of the
demand.** Over the flows of a family fed from its feeders' own stores, which nothing feeds, which
are not in the family and which do not rise within the stretch, with activity and identity
decided and the family and the class listed without repetition, let `f`, not a member, be active
across a stretch longer than the family's stock. Then `f` drawing past the stock needs `g`'s
giving exactly where, at some step of the stretch, what the stores of the other active members
fall together falls short of the step's demand: the capacities of the exact law, read off the web. -/
theorem needs_giver_iff_store_short [DecidableEq F] [DecidableEq C] {W : Web F C}
    [∀ t x, Decidable (W.active t x)] {store : F → C} {cs : List C} (distinct : Distinct cs)
    {c₀ : C} (inside : c₀ ∈ cs) {ks : List F} (apart : Distinct ks) {T n : Nat} {f g : F}
    (outside : ¬ f ∈ ks) (alive : ∀ t, T ≤ t → t < T + n → W.active t f)
    (below : W.stock cs T < n) (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs)
    (steady : ∀ t, T ≤ t → t < T + n → ∀ h, h ∈ ks → ¬ W.Rises t (store h)) :
    NeedsPart (FedFromStores W store cs ks T n) (fun L => DrawsPast cs T n (L, W))
        (fun L => GivesWithin cs T n (L, W)) f g ↔
      ∃ t, T ≤ t ∧ t < T + n ∧ W.capacityWithout (W.storeFall store) ks g t < W.demand cs t :=
  ⟨fun needs => match decideSome
      (p := fun t => W.capacityWithout (W.storeFall store) ks g t < W.demand cs t) (steps T n) with
    | isTrue ⟨t, mem, short⟩ => match between_of_mem_steps mem with
      | ⟨from_, to⟩ => ⟨t, from_, to, short⟩
    | isFalse covered =>
      absurd (needs _ (storeDrawn_fedFromStores (c₀ := c₀) distinct inside apart outside own separate
          steady fun t from_ to => Nat.ge_of_not_lt fun short =>
            covered ⟨t, steps_of_within from_ to, short⟩)
        (storeDrawn_drawsPast inside alive below))
        (storeDrawn_not_gives distinct apart),
   fun short L fed draws =>
    needs_giver_of_short (cap := W.storeFall store) short L (fedFromStores_within fed) draws⟩

end Flow

/-! ## Need in degree -/

/-- An amount is the part a test removes and the part it keeps. -/
theorem split_by {p : Prop} [d : Decidable p] (v : Nat) :
    v = (if p then 0 else v) + (if p then v else 0) :=
  match d with
  | isTrue _ => (Nat.zero_add v).symm
  | isFalse _ => (Nat.add_zero v).symm

namespace Web

variable {C : Type} (W : Web F C)

/-- What the step from `t` demands beyond what the members of `ks` other than `g`, active there,
can give together: the part of the demand only `g` can give. -/
def shortfall [∀ t x, Decidable (W.active t x)] [DecidableEq F] (cap : Nat → F → Nat)
    (cs : List C) (ks : List F) (g : F) (t : Nat) : Nat :=
  excess (W.demand cs t) (W.capacityWithout cap ks g t)

/-- The capacities under which `g` can give only what the others cannot: `g`'s at a step is the
step's shortfall without it, every other formation's is its own. -/
def shortCapacity [∀ t x, Decidable (W.active t x)] [DecidableEq F] (cap : Nat → F → Nat)
    (cs : List C) (ks : List F) (g : F) (t : Nat) (h : F) : Nat :=
  if h = g then W.shortfall cap cs ks g t else cap t h

end Web

namespace Flow

variable {C : Type}

/-- What `g` gives the family across the step from `t`, counted where it takes part. -/
def givenFrom [DecidableEq F] (L : Flow F C) (cs : List C) (t : Nat) (g : F) : Nat :=
  total (L.present t) fun x => if x = g then total cs (L.give t x) else 0

/-- Across a stretch, the shared flow in which every active member gives within its capacity but
`g`, whose capacity is its shortfall: `g` gives only what the others cannot. -/
def gradedDrawn [DecidableEq F] [DecidableEq C] (W : Web F C) [∀ t x, Decidable (W.active t x)]
    (cap : Nat → F → Nat) (cs : List C) (c₀ : C) (ks : List F) (T n : Nat) (f g : F) : Flow F C :=
  sharedDrawn W (W.shortCapacity cap cs ks g) cs c₀ ks T n f f

section Degree

variable [DecidableEq F] {W : Web F C} [∀ t x, Decidable (W.active t x)] {cap : Nat → F → Nat}
  {cs : List C} {ks : List F} {T n : Nat} {f g : F}

/-- What the family is given is what the formations other than `g` give it and what `g` gives
it. -/
theorem replenishment_split (L : Flow F C) (t : Nat) :
    L.replenishment cs t =
      total (L.present t) (fun x => if x = g then 0 else total cs (L.give t x)) +
        L.givenFrom cs t g :=
  (total_swap (fun x c => L.give t x c) cs (L.present t)).symm.trans
    ((total_congr_on fun x _ => split_by (p := x = g) (total cs (L.give t x))).trans
      (total_add _ _ (L.present t)))

/-- **What the others give is at most what they can give together.** In a flow read off a web
with capacities, at a step of the stretch, what the formations taking part other than `g` give
the family is at most what the active members other than `g` can give. -/
theorem others_le_capacityWithout {L : Flow F C} (fed : FedOnlyWithin W cap cs (· ∈ ks) T n L)
    {t : Nat} (from_ : T ≤ t) (to : t < T + n) :
    total (L.present t) (fun x => if x = g then 0 else total cs (L.give t x)) ≤
      W.capacityWithout cap ks g t :=
  have each : ∀ x, x ∈ L.present t → (if x = g then 0 else total cs (L.give t x)) ≤
      total ks (fun h => if h = x then W.otherCapacity cap g t h else 0) := fun x present =>
    match decEq x g with
    | isTrue same => Nat.le_trans (Nat.le_of_eq (if_pos same)) (Nat.zero_le _)
    | isFalse other => Nat.le_trans (Nat.le_of_eq (if_neg other))
      (match Nat.decEq (total cs (L.give t x)) 0 with
      | isTrue zero => Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le _)
      | isFalse pos => match total_pos cs (Nat.pos_of_ne_zero pos) with
        | ⟨c, inside, positive⟩ =>
          Nat.le_trans ((fed.2 t from_ to).2 x present) (Nat.le_trans
            (Nat.le_of_eq ((if_pos ⟨fed.1.2.1 t x c present positive, other⟩).symm.trans
              (if_pos rfl).symm))
            (le_total_of_mem (q := fun h => if h = x then W.otherCapacity cap g t h else 0)
              (fed.1.2.2 t x c inside present positive))))
  Nat.le_trans (total_le _ each) (Nat.le_trans
    (Nat.le_of_eq (total_swap (fun x h => if h = x then W.otherCapacity cap g t h else 0) ks
      (L.present t)))
    (total_le ks fun h _ => Nat.le_trans (total_le_at (a := h) (fun b pos => match decEq h b with
        | isTrue same => same.symm
        | isFalse other => absurd pos (fun p => Nat.lt_irrefl 0
            (Nat.lt_of_lt_of_le p (Nat.le_of_eq (if_neg other))))) (fed.2 t from_ to).1)
      (Nat.le_of_eq (if_pos rfl))))

/-- **A feeder gives at least what the others cannot.** In a flow read off a web with capacities
in which `f`, taking part, takes from the family at a step of the stretch, `g` gives the family
there at least the step's shortfall without it. -/
theorem shortfall_le_givenFrom {L : Flow F C} (fed : FedOnlyWithin W cap cs (· ∈ ks) T n L)
    {t : Nat} (from_ : T ≤ t) (to : t < T + n) (present : f ∈ L.present t)
    (takes : 0 < total cs (L.take t f)) : W.shortfall cap cs ks g t ≤ L.givenFrom cs t g :=
  excess_le_of_le_add (Nat.le_trans (demand_le_replenishment (fed.1.1 t from_ to) present takes)
    (Nat.le_trans (Nat.le_of_eq (replenishment_split (g := g) L t))
      (Nat.add_le_add_right (others_le_capacityWithout fed from_ to) _)))

/-- **Across a stretch in which `f` draws past the stock, `g` gives at least its shortfalls.** -/
theorem shortfalls_le_given {L : Flow F C} (fed : FedOnlyWithin W cap cs (· ∈ ks) T n L)
    (draws : DrawsPast cs T n (L, W) f) :
    total (steps T n) (W.shortfall cap cs ks g) ≤ total (steps T n) fun t => L.givenFrom cs t g :=
  Amounts.total_steps_le T n fun t from_ to =>
    shortfall_le_givenFrom fed from_ to (draws.2 t from_ to).2.1 (draws.2 t from_ to).2.2

/-- With its shortfall as its capacity, `g` can give at a step what it can give apart from `f`,
and every other member what it could. -/
theorem otherCapacity_short (outside : ¬ f ∈ ks) {t : Nat}
    (able : W.shortfall cap cs ks g t ≤ W.otherCapacity cap f t g) {h : F} (member : h ∈ ks) :
    W.otherCapacity (W.shortCapacity cap cs ks g) f t h =
      W.otherCapacity cap g t h + if h = g then W.shortfall cap cs ks g t else 0 :=
  have apartF : h ≠ f := fun same => outside (Eq.subst (motive := fun y => y ∈ ks) same member)
  match decEq h g with
  | isTrue same => match (inferInstance : Decidable (W.active t h)) with
    | isTrue active =>
      (if_pos ⟨active, apartF⟩).trans ((if_pos same).trans ((Nat.zero_add _).symm.trans
        ((congrArg (· + W.shortfall cap cs ks g t)
          (if_neg fun both : W.active t h ∧ h ≠ g => both.2 same).symm).trans
          (congrArg (W.otherCapacity cap g t h + ·) (if_pos same).symm))))
    | isFalse idle =>
      have zero : W.shortfall cap cs ks g t = 0 := Nat.eq_zero_of_le_zero (Nat.le_trans able
        (Nat.le_of_eq (if_neg fun both : W.active t g ∧ g ≠ f =>
          idle (Eq.subst (motive := fun y => W.active t y) same.symm both.1))))
      (if_neg fun both : W.active t h ∧ h ≠ f => idle both.1).trans ((Nat.add_zero 0).symm.trans
        ((congrArg (· + 0) (if_neg fun both : W.active t h ∧ h ≠ g => idle both.1).symm).trans
          (congrArg (W.otherCapacity cap g t h + ·) ((if_pos same).trans zero).symm)))
  | isFalse other => match (inferInstance : Decidable (W.active t h)) with
    | isTrue active =>
      (if_pos ⟨active, apartF⟩).trans ((if_neg other).trans ((Nat.add_zero _).symm.trans
        ((congrArg (· + 0) (if_pos ⟨active, other⟩).symm).trans
          (congrArg (W.otherCapacity cap g t h + ·) (if_neg other).symm))))
    | isFalse idle =>
      (if_neg fun both : W.active t h ∧ h ≠ f => idle both.1).trans ((Nat.add_zero 0).symm.trans
        ((congrArg (· + 0) (if_neg fun both : W.active t h ∧ h ≠ g => idle both.1).symm).trans
          (congrArg (W.otherCapacity cap g t h + ·) (if_neg other).symm)))

/-- With its shortfall as its capacity, `g` together with the other members can give the step's
demand where `g`, a member, can give its shortfall. -/
theorem capacityWithout_short (apart : Distinct ks) (outside : ¬ f ∈ ks) (member : g ∈ ks)
    {t : Nat} (able : W.shortfall cap cs ks g t ≤ W.otherCapacity cap f t g) :
    W.capacityWithout (W.shortCapacity cap cs ks g) ks f t =
      W.capacityWithout cap ks g t + W.shortfall cap cs ks g t :=
  (total_congr_on fun _ inks => otherCapacity_short outside able inks).trans
    ((total_add _ _ ks).trans (congrArg (W.capacityWithout cap ks g t + ·)
      ((total_eq_at (a := g) (fun h pos => match decEq h g with
          | isTrue same => same
          | isFalse other => absurd pos (fun p => Nat.lt_irrefl 0
              (Nat.lt_of_lt_of_le p (Nat.le_of_eq (if_neg other))))) apart member).trans
        (if_pos rfl))))

/-- A formation's capacity with `g`'s set to its shortfall is at most its own, where `g` can give
its shortfall. -/
theorem shortCapacity_le {t : Nat} (able : W.shortfall cap cs ks g t ≤ W.otherCapacity cap f t g)
    (x : F) : W.shortCapacity cap cs ks g t x ≤ cap t x :=
  match decEq x g with
  | isTrue same => Nat.le_trans (Nat.le_of_eq (if_pos same)) (Nat.le_trans able
      (Nat.le_trans (Web.otherCapacity_le cap f t g)
        (Nat.le_of_eq (congrArg (cap t) same.symm))))
  | isFalse other => Nat.le_of_eq (if_neg other)

variable [DecidableEq C] {c₀ : C}

/-- **The graded flow is a flow read off the web with capacities**, where `g`, a member, can give
its shortfall at every step of the stretch. -/
theorem gradedDrawn_fedOnlyWithin (distinct : Distinct cs) (inside : c₀ ∈ cs) (apart : Distinct ks)
    (outside : ¬ f ∈ ks) (member : g ∈ ks)
    (able : ∀ t, T ≤ t → t < T + n → W.shortfall cap cs ks g t ≤ W.otherCapacity cap f t g) :
    FedOnlyWithin W cap cs (· ∈ ks) T n (gradedDrawn W cap cs c₀ ks T n f g) :=
  have fed : FedOnlyWithin W (W.shortCapacity cap cs ks g) cs (· ∈ ks) T n
      (sharedDrawn W (W.shortCapacity cap cs ks g) cs c₀ ks T n f f) :=
    sharedDrawn_fedOnlyWithin distinct inside apart outside fun t from_ to =>
      Nat.le_trans (le_add_excess (W.demand cs t) (W.capacityWithout cap ks g t))
        (Nat.le_of_eq (capacityWithout_short apart outside member (able t from_ to)).symm)
  ⟨fed.1, fun t from_ to => ⟨(fed.2 t from_ to).1, fun x present =>
    Nat.le_trans ((fed.2 t from_ to).2 x present) (shortCapacity_le (able t from_ to) x)⟩⟩

/-- In the graded flow `g` gives at each step of the stretch at most its shortfall. -/
theorem gradedDrawn_givenFrom_le (distinct : Distinct cs) (apart : Distinct ks)
    (outside : ¬ f ∈ ks) (member : g ∈ ks) {t : Nat} (from_ : T ≤ t) (to : t < T + n) :
    (gradedDrawn W cap cs c₀ ks T n f g).givenFrom cs t g ≤ W.shortfall cap cs ks g t :=
  have present : (gradedDrawn W cap cs c₀ ks T n f g).present t = f :: ks := if_pos ⟨from_, to⟩
  have inPresent : g ∈ (gradedDrawn W cap cs c₀ ks T n f g).present t :=
    Eq.subst (motive := fun l => g ∈ l) present.symm (.tail _ member)
  have unique : Distinct ((gradedDrawn W cap cs c₀ ks T n f g).present t) :=
    Eq.subst (motive := fun l => Distinct l) present.symm ⟨outside, apart⟩
  Nat.le_trans (Nat.le_of_eq ((total_eq_at (a := g) (fun x pos => match decEq x g with
      | isTrue same => same
      | isFalse other => absurd pos (fun p => Nat.lt_irrefl 0
          (Nat.lt_of_lt_of_le p (Nat.le_of_eq (if_neg other))))) unique inPresent).trans
      (if_pos rfl)))
    (Nat.le_trans (sharedDrawn_given_le (W := W) (cap := W.shortCapacity cap cs ks g) (c₀ := c₀)
        (T := T) (n := n) (f := f) (g := f) distinct apart t g)
      (Nat.le_trans (Web.otherCapacity_le (W.shortCapacity cap cs ks g) f t g)
        (Nat.le_of_eq (if_pos rfl))))

end Degree

/-- **The least `g` gives while `f` draws past the stock is the sum of its shortfalls.** Over the
flows read off a web with capacities, for a family without repetition holding `c₀`, fed only from
the members of a list without repetition, with activity and identity decided, let `f`, not a
member, be active across a stretch longer than the family's stock, and `g` a member. Every such
flow in which `f` draws past the stock has `g` giving across the stretch at least the sum of its
shortfalls, what each step demands beyond what the others can give; where `g` can give its
shortfall at every step, some such flow has it give exactly that. -/
theorem least_giving [DecidableEq F] [DecidableEq C] {W : Web F C}
    [∀ t x, Decidable (W.active t x)] {cap : Nat → F → Nat} {cs : List C} (distinct : Distinct cs)
    {c₀ : C} (inside : c₀ ∈ cs) {ks : List F} (apart : Distinct ks) {T n : Nat} {f g : F}
    (outside : ¬ f ∈ ks) (member : g ∈ ks) (alive : ∀ t, T ≤ t → t < T + n → W.active t f)
    (below : W.stock cs T < n) :
    (∀ L, FedOnlyWithin W cap cs (· ∈ ks) T n L → DrawsPast cs T n (L, W) f →
      total (steps T n) (W.shortfall cap cs ks g) ≤ total (steps T n) fun t => L.givenFrom cs t g) ∧
    ((∀ t, T ≤ t → t < T + n → W.shortfall cap cs ks g t ≤ W.otherCapacity cap f t g) →
      ∃ L, FedOnlyWithin W cap cs (· ∈ ks) T n L ∧ DrawsPast cs T n (L, W) f ∧
        total (steps T n) (fun t => L.givenFrom cs t g) = total (steps T n) (W.shortfall cap cs ks g)) :=
  ⟨fun _ fed draws => shortfalls_le_given fed draws,
   fun able =>
    have fed := gradedDrawn_fedOnlyWithin (c₀ := c₀) distinct inside apart outside member able
    have draws : DrawsPast cs T n (gradedDrawn W cap cs c₀ ks T n f g, W) f :=
      sharedDrawn_drawsPast inside alive below
    ⟨gradedDrawn W cap cs c₀ ks T n f g, fed, draws, Nat.le_antisymm
      (Amounts.total_steps_le T n fun _ from_ to =>
        gradedDrawn_givenFrom_le distinct apart outside member from_ to)
      (shortfalls_le_given fed draws)⟩⟩

/-- **A feeder is needed exactly where its degree of need is positive**: where the sum of its
shortfalls across the stretch is positive. -/
theorem needs_giver_iff_shortfalls_pos [DecidableEq F] [DecidableEq C] {W : Web F C}
    [∀ t x, Decidable (W.active t x)] {cap : Nat → F → Nat} {cs : List C} (distinct : Distinct cs)
    {c₀ : C} (inside : c₀ ∈ cs) {ks : List F} (apart : Distinct ks) {T n : Nat} {f g : F}
    (outside : ¬ f ∈ ks) (alive : ∀ t, T ≤ t → t < T + n → W.active t f)
    (below : W.stock cs T < n) :
    NeedsPart (FedOnlyWithin W cap cs (· ∈ ks) T n) (fun L => DrawsPast cs T n (L, W))
        (fun L => GivesWithin cs T n (L, W)) f g ↔
      0 < total (steps T n) (W.shortfall cap cs ks g) :=
  (needs_giver_iff_short distinct inside apart outside alive below).trans
    ⟨fun ⟨_, from_, to, short⟩ =>
      total_pos_of_mem (steps_of_within from_ to) (excess_pos.mpr short),
     fun pos => match total_pos (steps T n) pos with
      | ⟨t, mem, positive⟩ => match between_of_mem_steps mem with
        | ⟨from_, to⟩ => ⟨t, from_, to, excess_pos.mp positive⟩⟩

end Flow

/-! ## When a consumer can draw past the stock at all -/

/-- Where no possible course lets `f` continue, `f` needs every part, vacuously. -/
theorem needsPart_of_none {Ω : Type} {possible : Ω → Prop} {continues part : Ω → F → Prop}
    {f g : F} (none : ∀ ω, possible ω → ¬ continues ω f) : NeedsPart possible continues part f g :=
  fun ω here going => absurd going (none ω here)

namespace Flow

variable {C : Type}

section Possible

variable [DecidableEq F] {W : Web F C} [∀ t x, Decidable (W.active t x)] {cap : Nat → F → Nat}
  {cs : List C} {ks : List F} {T n : Nat} {f g : F}

omit [∀ t x, Decidable (W.active t x)] in
/-- In a flow read off a web with capacities for a family fed only from `ks`, a formation that is
not a member gives the family nothing. -/
theorem givenFrom_outside {L : Flow F C} (fed : FedOnlyWithin W cap cs (· ∈ ks) T n L)
    (outside : ¬ f ∈ ks) (t : Nat) : L.givenFrom cs t f = 0 :=
  total_eq_zero fun x present => match decEq x f with
  | isTrue same => (if_pos same).trans (total_eq_zero fun c inside => eq_zero_of_not_pos fun pos =>
      outside (Eq.subst (motive := fun y => y ∈ ks) same (fed.1.2.2 t x c inside present pos)))
  | isFalse other => if_neg other

/-- A member's capacity apart from `f`, not a member, is its capacity apart from a member `g`, and
`g`'s apart from `f` where it is `g`. -/
theorem otherCapacity_split (outside : ¬ f ∈ ks) (t : Nat) {h : F} (member : h ∈ ks) :
    W.otherCapacity cap f t h =
      W.otherCapacity cap g t h + if h = g then W.otherCapacity cap f t g else 0 :=
  have apartF : h ≠ f := fun same => outside (Eq.subst (motive := fun y => y ∈ ks) same member)
  match decEq h g with
  | isTrue same => (Nat.zero_add _).symm.trans
      ((congrArg (· + W.otherCapacity cap f t h)
        (if_neg fun both : W.active t h ∧ h ≠ g => both.2 same).symm).trans
        (congrArg (W.otherCapacity cap g t h + ·)
          ((congrArg (W.otherCapacity cap f t) same).trans (if_pos same).symm)))
  | isFalse other => match (inferInstance : Decidable (W.active t h)) with
    | isTrue active => (if_pos ⟨active, apartF⟩).trans ((if_pos ⟨active, other⟩).symm.trans
        ((Nat.add_zero _).symm.trans (congrArg (W.otherCapacity cap g t h + ·) (if_neg other).symm)))
    | isFalse idle => (if_neg fun both : W.active t h ∧ h ≠ f => idle both.1).trans
        ((if_neg fun both : W.active t h ∧ h ≠ g => idle both.1).symm.trans
          ((Nat.add_zero _).symm.trans (congrArg (W.otherCapacity cap g t h + ·) (if_neg other).symm)))

/-- What the members can give together apart from `f`, not a member, is what those other than a
member `g` can give and what `g` can give. -/
theorem capacityWithout_split (apart : Distinct ks) (outside : ¬ f ∈ ks) (member : g ∈ ks)
    (t : Nat) :
    W.capacityWithout cap ks f t = W.capacityWithout cap ks g t + W.otherCapacity cap f t g :=
  (total_congr_on fun _ inks => otherCapacity_split (g := g) outside t inks).trans
    ((total_add _ _ ks).trans (congrArg (W.capacityWithout cap ks g t + ·)
      ((total_eq_at (a := g) (fun h pos => match decEq h g with
          | isTrue same => same
          | isFalse other => absurd pos (fun p => Nat.lt_irrefl 0
              (Nat.lt_of_lt_of_le p (Nat.le_of_eq (if_neg other))))) apart member).trans
        (if_pos rfl))))

/-- Where the class can give a step's demand, each member can give its shortfall there. -/
theorem able_of_covers (apart : Distinct ks) (outside : ¬ f ∈ ks) (member : g ∈ ks) {t : Nat}
    (covers : W.demand cs t ≤ W.capacityWithout cap ks f t) :
    W.shortfall cap cs ks g t ≤ W.otherCapacity cap f t g :=
  excess_le_of_le_add (Nat.le_trans covers (Nat.le_of_eq (capacityWithout_split apart outside member t)))

/-- In a flow read off a web with capacities in which `f`, not a member, takes part and takes from
the family at a step of the stretch, the class can give that step's demand. -/
theorem covers_of_drawsPast {L : Flow F C} (fed : FedOnlyWithin W cap cs (· ∈ ks) T n L)
    (outside : ¬ f ∈ ks) {t : Nat} (from_ : T ≤ t) (to : t < T + n) (present : f ∈ L.present t)
    (takes : 0 < total cs (L.take t f)) : W.demand cs t ≤ W.capacityWithout cap ks f t :=
  Nat.le_trans (demand_le_replenishment (fed.1.1 t from_ to) present takes)
    (Nat.le_trans (Nat.le_of_eq ((replenishment_split (g := f) L t).trans
        ((congrArg (total (L.present t) (fun x => if x = f then 0 else total cs (L.give t x)) + ·)
          (givenFrom_outside fed outside t)).trans (Nat.add_zero _))))
      (others_le_capacityWithout fed from_ to))

/-- **Where the class cannot give some step's demand, every need is vacuous**: no flow read off
the web with capacities lets `f`, not a member, draw past the stock, so `f` needs every
formation's giving. -/
theorem needs_of_class_short (outside : ¬ f ∈ ks) {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    (short : W.capacityWithout cap ks f t < W.demand cs t) (h : F) :
    NeedsPart (FedOnlyWithin W cap cs (· ∈ ks) T n) (fun L => DrawsPast cs T n (L, W))
      (fun L => GivesWithin cs T n (L, W)) f h :=
  needsPart_of_none fun _ fed draws => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le short
    (covers_of_drawsPast fed outside from_ to (draws.2 t from_ to).2.1 (draws.2 t from_ to).2.2))

end Possible

/-- **Some flow lets `f` draw past the stock exactly where the class can give each step's
demand.** Over the flows read off a web with capacities, for a family without repetition holding
`c₀`, fed only from the members of a list without repetition, with activity and identity decided,
let `f`, not a member, be active across a stretch longer than the family's stock. Some such flow has
`f` drawing past the stock exactly where, at every step of the stretch, what the active members
can give together covers the step's demand. Elsewhere `f` needs every member, vacuously
(`needs_of_class_short`). -/
theorem possible_iff_covers [DecidableEq F] [DecidableEq C] {W : Web F C}
    [∀ t x, Decidable (W.active t x)] {cap : Nat → F → Nat} {cs : List C} (distinct : Distinct cs)
    {c₀ : C} (inside : c₀ ∈ cs) {ks : List F} (apart : Distinct ks) {T n : Nat} {f : F}
    (outside : ¬ f ∈ ks) (alive : ∀ t, T ≤ t → t < T + n → W.active t f)
    (below : W.stock cs T < n) :
    (∃ L, FedOnlyWithin W cap cs (· ∈ ks) T n L ∧ DrawsPast cs T n (L, W) f) ↔
      ∀ t, T ≤ t → t < T + n → W.demand cs t ≤ W.capacityWithout cap ks f t :=
  ⟨fun ⟨_, fed, draws⟩ t from_ to =>
    covers_of_drawsPast fed outside from_ to (draws.2 t from_ to).2.1 (draws.2 t from_ to).2.2,
   fun covers => ⟨sharedDrawn W cap cs c₀ ks T n f f,
     sharedDrawn_fedOnlyWithin distinct inside apart outside covers,
     sharedDrawn_drawsPast inside alive below⟩⟩

/-- **Wherever some flow lets `f` draw past the stock, the least a member gives is the sum of its
shortfalls**: the degree of need is attained wherever any flow is possible. -/
theorem least_giving_of_possible [DecidableEq F] [DecidableEq C] {W : Web F C}
    [∀ t x, Decidable (W.active t x)] {cap : Nat → F → Nat} {cs : List C} (distinct : Distinct cs)
    {c₀ : C} (inside : c₀ ∈ cs) {ks : List F} (apart : Distinct ks) {T n : Nat} {f g : F}
    (outside : ¬ f ∈ ks) (member : g ∈ ks) (alive : ∀ t, T ≤ t → t < T + n → W.active t f)
    (below : W.stock cs T < n)
    (possible : ∃ L, FedOnlyWithin W cap cs (· ∈ ks) T n L ∧ DrawsPast cs T n (L, W) f) :
    ∃ L, FedOnlyWithin W cap cs (· ∈ ks) T n L ∧ DrawsPast cs T n (L, W) f ∧
      total (steps T n) (fun t => L.givenFrom cs t g) = total (steps T n) (W.shortfall cap cs ks g) :=
  (least_giving (c₀ := c₀) distinct inside apart outside member alive below).2 fun t from_ to =>
    able_of_covers apart outside member
      ((possible_iff_covers distinct inside apart outside alive below).mp possible t from_ to)

/-- **Drawing without end needs giving without end.** On a flow balancing on a family at every
step from `T`, in which only active formations give and only members of `K` give to the family, a
formation taking part and taking from the family at every step from `T` has, after every step `N`
from `T`, some member of `K` giving to the family within the next `stock N + 1` steps. -/
theorem needsSome_without_end (W : Web F C) (cs : List C) (K : F → Prop) (T : Nat) (f : F)
    (L : Flow F C) (balances : ∀ t, T ≤ t → L.BalancesOn W cs t) (acting : L.Acting W)
    (only : ∀ t g c, c ∈ cs → g ∈ L.present t → 0 < L.give t g c → K g)
    (draws : ∀ t, T ≤ t → W.active t f ∧ f ∈ L.present t ∧ 0 < total cs (L.take t f)) :
    ∀ N, T ≤ N → ∃ g, K g ∧ GivesWithin cs N (W.stock cs N + 1) (L, W) g :=
  fun N after => needsSome_on W cs K N (W.stock cs N + 1) f L
    ⟨fun t from_ _ => balances t (Nat.le_trans after from_), acting, only⟩
    ⟨Nat.lt_succ_self _, fun t from_ _ => draws t (Nat.le_trans after from_)⟩

end Flow

/-! ## Need in degree with capacities read off the stores -/

namespace Flow

variable {C : Type}

/-- Across a stretch, the graded flow from the stores: the shared flow under the capacities read
off the stores with `g`'s set to its shortfall, in which each member also takes from its own store
what the store falls. -/
def gradedStoreDrawn [DecidableEq F] [DecidableEq C] (W : Web F C)
    [∀ t x, Decidable (W.active t x)] (store : F → C) (cs : List C) (c₀ : C) (ks : List F)
    (T n : Nat) (f g : F) : Flow F C :=
  { gradedDrawn W (W.storeFall store) cs c₀ ks T n f g with
    take := (storeDrawn W store cs c₀ ks T n f g).take }

section GradedStored

variable [DecidableEq F] [DecidableEq C] {W : Web F C} [∀ t x, Decidable (W.active t x)]
  {store : F → C} {cs : List C} {c₀ : C} {ks : List F} {T n : Nat} {f g : F}

/-- What gives in the graded flow from the stores gives to the family and is an active member
other than `f`. -/
theorem gradedStoreDrawn_gives {t : Nat} {x : F} {c : C}
    (gives : 0 < (gradedStoreDrawn W store cs c₀ ks T n f g).give t x c) :
    c ∈ cs ∧ x ∈ ks ∧ W.active t x ∧ x ≠ f :=
  sharedDrawn_gives (W := W) (cap := W.shortCapacity (W.storeFall store) cs ks g) (cs := cs)
    (c₀ := c₀) (ks := ks) (T := T) (n := n) (f := f) (g := f) gives

/-- The graded flow from the stores balances on the family at every step of the stretch, where
`g`, a member, can give its shortfall under the stores' falls, `f` is not a member and no store is
in the family. -/
theorem gradedStoreDrawn_balancesOn (distinct : Distinct cs) (inside : c₀ ∈ cs)
    (apart : Distinct ks) (outside : ¬ f ∈ ks) (member : g ∈ ks)
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs)
    (able : ∀ t, T ≤ t → t < T + n →
      W.shortfall (W.storeFall store) cs ks g t ≤ W.otherCapacity (W.storeFall store) f t g) :
    ∀ t, T ≤ t → t < T + n → (gradedStoreDrawn W store cs c₀ ks T n f g).BalancesOn W cs t := by
  intro t from_ to c inFamily
  have present : (gradedStoreDrawn W store cs c₀ ks T n f g).present t = f :: ks :=
    if_pos ⟨from_, to⟩
  have takeSelf : (gradedStoreDrawn W store cs c₀ ks T n f g).take t f c =
      fall (fun s => W.level s c) t + W.drawnUnit cs c₀ t c := if_pos ⟨rfl, ⟨c, inFamily, rfl⟩⟩
  have takeOthers :
      total ks (fun x => (gradedStoreDrawn W store cs c₀ ks T n f g).take t x c) = 0 :=
    total_eq_zero fun x inks =>
      (if_neg fun both => outside (Eq.subst (motive := fun y => y ∈ ks) both.1 inks)).trans
        (if_neg fun both => separate x inks (Eq.subst (motive := fun y => y ∈ cs) both.2 inFamily))
  have giveSelf : (gradedStoreDrawn W store cs c₀ ks T n f g).give t f c = 0 :=
    eq_zero_of_not_pos fun pos => outside (gradedStoreDrawn_gives pos).2.1
  have giveOthers :
      total ks (fun x => (gradedStoreDrawn W store cs c₀ ks T n f g).give t x c) =
        rise (fun s => W.level s c) t + W.drawnUnit cs c₀ t c :=
    sharedDrawn_given_members (W := W) (cap := W.shortCapacity (W.storeFall store) cs ks g)
      (T := T) (n := n) (f := f) (g := f) distinct inside apart
      (Nat.le_trans (le_add_excess (W.demand cs t) (W.capacityWithout (W.storeFall store) ks g t))
        (Nat.le_of_eq (capacityWithout_short apart outside member (able t from_ to)).symm)) inFamily
  show W.level (t + 1) c + total ((gradedStoreDrawn W store cs c₀ ks T n f g).present t)
      (fun x => (gradedStoreDrawn W store cs c₀ ks T n f g).take t x c) =
    W.level t c + total ((gradedStoreDrawn W store cs c₀ ks T n f g).present t)
      (fun x => (gradedStoreDrawn W store cs c₀ ks T n f g).give t x c)
  rw [present]
  show W.level (t + 1) c + ((gradedStoreDrawn W store cs c₀ ks T n f g).take t f c +
      total ks (fun x => (gradedStoreDrawn W store cs c₀ ks T n f g).take t x c)) =
    W.level t c + ((gradedStoreDrawn W store cs c₀ ks T n f g).give t f c +
      total ks (fun x => (gradedStoreDrawn W store cs c₀ ks T n f g).give t x c))
  rw [takeSelf, takeOthers, giveSelf, giveOthers]
  exact (congrArg (W.level (t + 1) c + ·) (Nat.add_zero _)).trans ((Nat.add_assoc _ _ _).symm.trans
    ((congrArg (· + W.drawnUnit cs c₀ t c) (across (fun s => W.level s c) t)).trans
      ((Nat.add_assoc _ _ _).trans (congrArg (W.level t c + ·) (Nat.zero_add _).symm))))

/-- Each member's store balances in the graded flow from the stores, where the store does not
rise across the step. -/
theorem gradedStoreDrawn_balances_store (apart : Distinct ks) (outside : ¬ f ∈ ks)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    {h : F} (member : h ∈ ks) (steady : ¬ W.Rises t (store h)) :
    (gradedStoreDrawn W store cs c₀ ks T n f g).BalancesOn W [store h] t := by
  intro c mem
  have same : c = store h := match mem_cons_cases mem with
    | .inl same => same
    | .inr empty => nomatch empty
  subst same
  have present : (gradedStoreDrawn W store cs c₀ ks T n f g).present t = f :: ks :=
    if_pos ⟨from_, to⟩
  have given : (gradedStoreDrawn W store cs c₀ ks T n f g).given t (store h) = 0 :=
    total_eq_zero fun _ _ => eq_zero_of_not_pos fun pos =>
      separate h member (gradedStoreDrawn_gives pos).1
  have takeSelf : (gradedStoreDrawn W store cs c₀ ks T n f g).take t f (store h) = 0 :=
    (if_neg fun both => match both.2 with
      | ⟨_, dIn, same⟩ => separate h member (Eq.subst (motive := fun y => y ∈ cs) same dIn)).trans
      (if_neg fun both => match both.1 with
        | ⟨_, mem', same⟩ => outside (Eq.subst (motive := fun y => y ∈ ks) same mem'))
  have takenOthers :
      total ks (fun x => (gradedStoreDrawn W store cs c₀ ks T n f g).take t x (store h)) =
        W.storeFall store t h :=
    storeDrawn_taken_store (W := W) (cs := cs) (c₀ := c₀) (T := T) (n := n) (f := f) (g := g)
      apart outside own separate member
  have flat : rise (fun s => W.level s (store h)) t = 0 :=
    eq_zero_of_not_pos fun pos => steady (excess_pos.mp pos)
  show W.level (t + 1) (store h) + total ((gradedStoreDrawn W store cs c₀ ks T n f g).present t)
      (fun x => (gradedStoreDrawn W store cs c₀ ks T n f g).take t x (store h)) =
    W.level t (store h) + (gradedStoreDrawn W store cs c₀ ks T n f g).given t (store h)
  rw [present, given]
  show W.level (t + 1) (store h) + ((gradedStoreDrawn W store cs c₀ ks T n f g).take t f (store h) +
      total ks (fun x => (gradedStoreDrawn W store cs c₀ ks T n f g).take t x (store h))) =
    W.level t (store h) + 0
  rw [takeSelf, takenOthers]
  exact (congrArg (W.level (t + 1) (store h) + ·) (Nat.zero_add _)).trans
    ((across (fun s => W.level s (store h)) t).trans (congrArg (W.level t (store h) + ·) flat))

/-- **The graded flow from the stores is a flow of the family fed from its feeders' own stores**,
where `g`, a member, can give its shortfall at every step of the stretch, `f` is not a member, the
stores are the members' own and not in the family, and no store rises within the stretch. -/
theorem gradedStoreDrawn_fedFromStores (distinct : Distinct cs) (inside : c₀ ∈ cs)
    (apart : Distinct ks) (outside : ¬ f ∈ ks) (member : g ∈ ks)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs)
    (steady : ∀ t, T ≤ t → t < T + n → ∀ h, h ∈ ks → ¬ W.Rises t (store h))
    (able : ∀ t, T ≤ t → t < T + n →
      W.shortfall (W.storeFall store) cs ks g t ≤ W.otherCapacity (W.storeFall store) f t g) :
    FedFromStores W store cs ks T n (gradedStoreDrawn W store cs c₀ ks T n f g) :=
  ⟨⟨gradedStoreDrawn_balancesOn distinct inside apart outside member separate able,
    fun _ _ _ _ gives => (gradedStoreDrawn_gives gives).2.2.1,
    fun _ _ _ _ _ gives => (gradedStoreDrawn_gives gives).2.1⟩,
   fun t from_ to =>
    have present : (gradedStoreDrawn W store cs c₀ ks T n f g).present t = f :: ks :=
      if_pos ⟨from_, to⟩
    ⟨Eq.subst (motive := fun l => Distinct l) present.symm ⟨outside, apart⟩, fun h inks =>
      ⟨gradedStoreDrawn_balances_store apart outside own separate from_ to inks
          (steady t from_ to h inks),
       total_eq_zero fun _ _ => eq_zero_of_not_pos fun pos =>
         separate h inks (gradedStoreDrawn_gives pos).1,
       fun _ => Nat.le_trans (sharedDrawn_given_le (W := W)
           (cap := W.shortCapacity (W.storeFall store) cs ks g) (c₀ := c₀) (T := T) (n := n)
           (f := f) (g := f) distinct apart t h)
         (Nat.le_trans (Web.otherCapacity_le (W.shortCapacity (W.storeFall store) cs ks g) f t h)
           (Nat.le_trans (shortCapacity_le (able t from_ to) h)
             (Nat.le_of_eq ((if_pos ⟨⟨h, inks, rfl⟩, rfl⟩).symm.trans
               (if_neg fun both => outside
                 (Eq.subst (motive := fun y => y ∈ ks) both.1 inks)).symm))))⟩⟩⟩

/-- In the graded flow from the stores `f` draws past the family's stock, where it is active
across a stretch longer than the stock and the family holds `c₀`. -/
theorem gradedStoreDrawn_drawsPast (inside : c₀ ∈ cs)
    (alive : ∀ t, T ≤ t → t < T + n → W.active t f) (below : W.stock cs T < n) :
    DrawsPast cs T n (gradedStoreDrawn W store cs c₀ ks T n f g, W) f :=
  ⟨below, fun t from_ to =>
    have present : (gradedStoreDrawn W store cs c₀ ks T n f g).present t = f :: ks :=
      if_pos ⟨from_, to⟩
    ⟨alive t from_ to, Eq.subst (motive := fun l => f ∈ l) present.symm (.head _),
     match W.decSomeFalls cs t with
     | isTrue ⟨c, mem, falls⟩ =>
       total_pos_of_mem (q := (gradedStoreDrawn W store cs c₀ ks T n f g).take t f) mem
        (Nat.lt_of_lt_of_le (excess_pos.mpr falls) (Nat.le_trans (Nat.le_add_right _ _)
          (Nat.le_of_eq (if_pos ⟨rfl, ⟨c, mem, rfl⟩⟩).symm)))
     | isFalse steady =>
       total_pos_of_mem (q := (gradedStoreDrawn W store cs c₀ ks T n f g).take t f) inside
        (Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_trans (Nat.le_add_left _ _)
          (Nat.le_trans (Nat.le_of_eq (congrArg (fall (fun s => W.level s c₀) t + ·)
            (if_pos ⟨rfl, steady⟩)).symm)
            (Nat.le_of_eq (if_pos ⟨rfl, ⟨c₀, inside, rfl⟩⟩).symm))))⟩⟩

/-- In the graded flow from the stores `g` gives at each step of the stretch at most its
shortfall under the stores' falls. -/
theorem gradedStoreDrawn_givenFrom_le (distinct : Distinct cs) (apart : Distinct ks)
    (outside : ¬ f ∈ ks) (member : g ∈ ks) {t : Nat} (from_ : T ≤ t) (to : t < T + n) :
    (gradedStoreDrawn W store cs c₀ ks T n f g).givenFrom cs t g ≤
      W.shortfall (W.storeFall store) cs ks g t :=
  gradedDrawn_givenFrom_le (W := W) (cap := W.storeFall store) (c₀ := c₀) (T := T) (n := n)
    (f := f) (g := g) distinct apart outside member from_ to

end GradedStored

/-- **With capacities read off the stores, the least a feeder gives is the sum of its
shortfalls.** Over the flows of a family fed from its feeders' own stores, with the premises of the
store law, every flow in which `f` draws past the stock has a member `g` giving across the stretch
at least the sum of its shortfalls under the stores' falls; where `g` can give each of them, some
such flow has it give exactly that. -/
theorem least_giving_from_stores [DecidableEq F] [DecidableEq C] {W : Web F C}
    [∀ t x, Decidable (W.active t x)] {store : F → C} {cs : List C} (distinct : Distinct cs)
    {c₀ : C} (inside : c₀ ∈ cs) {ks : List F} (apart : Distinct ks) {T n : Nat} {f g : F}
    (outside : ¬ f ∈ ks) (member : g ∈ ks) (alive : ∀ t, T ≤ t → t < T + n → W.active t f)
    (below : W.stock cs T < n) (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs)
    (steady : ∀ t, T ≤ t → t < T + n → ∀ h, h ∈ ks → ¬ W.Rises t (store h)) :
    (∀ L, FedFromStores W store cs ks T n L → DrawsPast cs T n (L, W) f →
      total (steps T n) (W.shortfall (W.storeFall store) cs ks g) ≤
        total (steps T n) fun t => L.givenFrom cs t g) ∧
    ((∀ t, T ≤ t → t < T + n →
        W.shortfall (W.storeFall store) cs ks g t ≤ W.otherCapacity (W.storeFall store) f t g) →
      ∃ L, FedFromStores W store cs ks T n L ∧ DrawsPast cs T n (L, W) f ∧
        total (steps T n) (fun t => L.givenFrom cs t g) =
          total (steps T n) (W.shortfall (W.storeFall store) cs ks g)) :=
  ⟨fun _ fed draws => shortfalls_le_given (fedFromStores_within fed) draws,
   fun able =>
    have fed := gradedStoreDrawn_fedFromStores (c₀ := c₀) distinct inside apart outside member own
      separate steady able
    have draws : DrawsPast cs T n (gradedStoreDrawn W store cs c₀ ks T n f g, W) f :=
      gradedStoreDrawn_drawsPast inside alive below
    ⟨gradedStoreDrawn W store cs c₀ ks T n f g, fed, draws, Nat.le_antisymm
      (Amounts.total_steps_le T n fun _ from_ to =>
        gradedStoreDrawn_givenFrom_le distinct apart outside member from_ to)
      (shortfalls_le_given (fedFromStores_within fed) draws)⟩⟩

end Flow

/-! ## Need across two tiers, the upper dividing its giving among the stores -/

section Restricted

variable {α : Type}

/-- **A total over a list without repetition of what is positive, among its members, at one of
them alone is at most its value there.** -/
theorem total_le_at_on {q : α → Nat} {a : α} :
    ∀ {as : List α}, (∀ b, b ∈ as → 0 < q b → b = a) → Distinct as → total as q ≤ q a
  | [], _, _ => Nat.zero_le _
  | b :: as, only, ⟨fresh, distinct⟩ => match Nat.decEq (q b) 0 with
    | isTrue zero => Nat.le_trans
        (Nat.le_of_eq ((congrArg (· + total as q) zero).trans (Nat.zero_add _)))
        (total_le_at_on (fun e mem pos => only e (.tail b mem) pos) distinct)
    | isFalse positive =>
      have same : b = a := only b (.head as) (Nat.pos_of_ne_zero positive)
      have rest : total as q = 0 := total_eq_zero fun e mem => eq_zero_of_not_pos fun pos =>
        fresh (Eq.subst (motive := fun x => x ∈ as) ((only e (.tail b mem) pos).trans same.symm) mem)
      Nat.le_of_eq ((congrArg (q b + ·) rest).trans ((Nat.add_zero _).trans (congrArg q same)))

end Restricted

/-- What `a` with `b` stays within exceeds `b` by at least `a`. -/
theorem le_excess_of_add_le {a b c : Nat} (le : a + b ≤ c) : a ≤ excess c b :=
  Naturals.le_of_add_le_add_left (Nat.le_trans (Nat.le_of_eq (Nat.add_comm b a))
    (Nat.le_trans le (Nat.le_trans (Nat.le_add_right c (excess b c))
      (Nat.le_of_eq (excess_balance c b)))))

/-- An amount at least `b` is its excess over `b` with `b`. -/
theorem excess_add_of_le {a b : Nat} (le : b ≤ a) : excess a b + b = a :=
  have none : excess b a = 0 :=
    eq_zero_of_not_pos fun pos => Nat.not_lt_of_le le (excess_pos.mp pos)
  (Nat.add_comm _ _).trans ((excess_balance a b).symm.trans
    ((congrArg (a + ·) none).trans (Nat.add_zero a)))

namespace Web

variable {C : Type} (W : Web F C)

/-- Some member of `ks` other than `e` is active at `t`: one to route the upper tier's giving. -/
def RoutesAt (ks : List F) (e : F) (t : Nat) : Prop :=
  ∃ h, h ∈ ks ∧ W.active t h ∧ h ≠ e

instance decRoutesAt [∀ t x, Decidable (W.active t x)] [DecidableEq F] (ks : List F) (e : F)
    (t : Nat) : Decidable (W.RoutesAt ks e t) :=
  decideSome (p := fun h => W.active t h ∧ h ≠ e) ks

/-- What `h`'s own store rises across the step from `t`. -/
def storeRise (store : F → C) (t : Nat) (h : F) : Nat :=
  rise (fun s => W.level s (store h)) t

/-- What the stores of the members of `ks` rise together across the step from `t`. -/
def storesRisen (store : F → C) (ks : List F) (t : Nat) : Nat :=
  total ks (W.storeRise store t)

/-- What the formations other than `e` could give the family through a two-tier hierarchy at the
step from `t`: the falls of the stores of the active lower members other than `e`, and, while one
of them is active to route it, what the active upper members other than `e` can give beyond what
the lower members' stores rise together. -/
def othersThrough [∀ t x, Decidable (W.active t x)] [DecidableEq F] (store : F → C)
    (cap₂ : Nat → F → Nat) (ks js : List F) (e : F) (t : Nat) : Nat :=
  W.capacityWithout (W.storeFall store) ks e t +
    if W.RoutesAt ks e t then excess (W.capacityWithout cap₂ js e t) (W.storesRisen store ks t)
    else 0

end Web

namespace Flow

variable {C : Type}

/-- The flows read off a web for a family fed from the members of `ks`, each giving what it takes
from its own store, the stores fed only from the members of `js` within their capacities `cap₂`:
read off the web for the family, with the formations taking part distinct at each step of the
stretch, every lower member's store balancing and given only by upper members, every lower member
giving the family at most what it takes from its own store, and every upper member giving the
stores at most its capacity. -/
def FedThroughStores (W : Web F C) (store : F → C) (cs : List C) (ks js : List F)
    (cap₂ : Nat → F → Nat) (T n : Nat) (L : Flow F C) : Prop :=
  FedOnlyOn W cs (· ∈ ks) T n L ∧ ∀ t, T ≤ t → t < T + n →
    Distinct (L.present t) ∧
    (∀ h, h ∈ ks → L.BalancesOn W [store h] t ∧
      (h ∈ L.present t → total cs (L.give t h) ≤ L.take t h (store h)) ∧
      ∀ x, x ∈ L.present t → 0 < L.give t x (store h) → x ∈ js) ∧
    ∀ x, x ∈ L.present t → x ∈ js → total ks (fun h => L.give t x (store h)) ≤ cap₂ t x

/-- `e` gives into the hierarchy within the stretch: at some step of it `e` takes part and gives to
the family or to a lower member's store. -/
def GivesInto (cs : List C) (ks : List F) (store : F → C) (T n : Nat) (ω : Flow F C × Web F C)
    (e : F) : Prop :=
  ∃ t, T ≤ t ∧ t < T + n ∧ e ∈ ω.1.present t ∧
    0 < total cs (ω.1.give t e) + total ks (fun h => ω.1.give t e (store h))

section Through

variable [DecidableEq F] {W : Web F C} [∀ t x, Decidable (W.active t x)] {store : F → C}
  {cs : List C} {ks js : List F} {cap₂ : Nat → F → Nat} {T n : Nat} {e : F}

omit [DecidableEq F] [∀ t x, Decidable (W.active t x)] in
/-- What is taken from a store that balances is what it falls and what it is given beyond what it
rises. -/
theorem taken_store {L : Flow F C} {t : Nat} {h : F} (balances : L.BalancesOn W [store h] t) :
    L.taken t (store h) =
      W.storeFall store t h + excess (L.given t (store h)) (W.storeRise store t h) :=
  have filled : excess (L.given t (store h)) (W.storeRise store t h) + W.storeRise store t h =
      L.given t (store h) := excess_add_of_le (rise_le_given balances (.head []))
  Naturals.add_left_cancel ((balances (store h) (.head [])).trans
    ((congrArg (W.level t (store h) + ·) (filled.symm.trans (Nat.add_comm _ _))).trans
      ((Nat.add_assoc _ _ _).symm.trans ((congrArg (· + excess (L.given t (store h))
        (W.storeRise store t h)) (across (fun s => W.level s (store h)) t).symm).trans
        (Nat.add_assoc _ _ _)))))

/-- **What the lower members other than `e` give the family is at most what is taken from their
stores**, in a flow of the two-tier hierarchy at a step of the stretch where `e`, if it takes part,
gives the family nothing. -/
theorem replenishment_le_taken {L : Flow F C} (fed : FedThroughStores W store cs ks js cap₂ T n L)
    {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    (quiet : e ∈ L.present t → total cs (L.give t e) = 0) :
    L.replenishment cs t ≤
      total ks (fun h => if W.active t h ∧ h ≠ e then L.taken t (store h) else 0) :=
  have each : ∀ x, x ∈ L.present t → total cs (L.give t x) ≤
      total ks (fun h => if h = x then
        (if W.active t h ∧ h ≠ e then L.take t h (store h) else 0) else 0) := fun x present =>
    match Nat.decEq (total cs (L.give t x)) 0 with
    | isTrue zero => Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le _)
    | isFalse pos => match total_pos cs (Nat.pos_of_ne_zero pos) with
      | ⟨c, inside, positive⟩ =>
        have member : x ∈ ks := fed.1.2.2 t x c inside present positive
        have other : x ≠ e := fun same => pos (Eq.subst (motive := fun y => total cs (L.give t y) = 0)
          same.symm (quiet (Eq.subst (motive := fun y => y ∈ L.present t) same present)))
        Nat.le_trans (((fed.2 t from_ to).2.1 x member).2.1 present) (Nat.le_trans
          (Nat.le_of_eq ((if_pos ⟨fed.1.2.1 t x c present positive, other⟩).symm.trans
            (if_pos rfl).symm))
          (le_total_of_mem (q := fun h => if h = x then
            (if W.active t h ∧ h ≠ e then L.take t h (store h) else 0) else 0) member))
  Nat.le_trans (Nat.le_of_eq (total_swap (fun x c => L.give t x c) cs (L.present t)).symm)
    (Nat.le_trans (total_le _ each) (Nat.le_trans
      (Nat.le_of_eq (total_swap (fun x h => if h = x then
        (if W.active t h ∧ h ≠ e then L.take t h (store h) else 0) else 0) ks (L.present t)))
      (total_le ks fun h _ => match (instDecidableAnd : Decidable (W.active t h ∧ h ≠ e)) with
        | isTrue both => Nat.le_trans (total_le (L.present t) fun x _ => match decEq h x with
              | isTrue same => Nat.le_of_eq ((if_pos same).trans ((if_pos both).trans
                  (congrArg (fun y => L.take t y (store h)) same)))
              | isFalse other => Nat.le_trans (Nat.le_of_eq (if_neg other)) (Nat.zero_le _))
            (Nat.le_of_eq (if_pos both).symm)
        | isFalse no => Nat.le_trans (Nat.le_of_eq (total_eq_zero fun x _ =>
              match decEq h x with
              | isTrue same => (if_pos same).trans (if_neg no)
              | isFalse other => if_neg other)) (Nat.zero_le _))))

/-- **What the upper members other than `e` give the stores is at most what they can give
together**, in a flow of the two-tier hierarchy at a step of the stretch where `e`, if it takes
part, gives the stores nothing. -/
theorem stores_given_le {L : Flow F C} (fed : FedThroughStores W store cs ks js cap₂ T n L)
    {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    (quiet : e ∈ L.present t → total ks (fun h => L.give t e (store h)) = 0) :
    total ks (fun h => L.given t (store h)) ≤ W.capacityWithout cap₂ js e t :=
  have each : ∀ x, x ∈ L.present t → total ks (fun h => L.give t x (store h)) ≤
      total js (fun j => if j = x then W.otherCapacity cap₂ e t j else 0) := fun x present =>
    match Nat.decEq (total ks (fun h => L.give t x (store h))) 0 with
    | isTrue zero => Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le _)
    | isFalse pos => match total_pos ks (Nat.pos_of_ne_zero pos) with
      | ⟨h, inks, positive⟩ =>
        have upper : x ∈ js := ((fed.2 t from_ to).2.1 h inks).2.2 x present positive
        have other : x ≠ e := fun same => pos (Eq.subst
          (motive := fun y => total ks (fun h => L.give t y (store h)) = 0) same.symm
          (quiet (Eq.subst (motive := fun y => y ∈ L.present t) same present)))
        Nat.le_trans ((fed.2 t from_ to).2.2 x present upper) (Nat.le_trans
          (Nat.le_of_eq ((if_pos ⟨fed.1.2.1 t x (store h) present positive, other⟩).symm.trans
            (if_pos rfl).symm))
          (le_total_of_mem (q := fun j => if j = x then W.otherCapacity cap₂ e t j else 0) upper))
  Nat.le_trans (Nat.le_of_eq (total_swap (fun x h => L.give t x (store h)) ks (L.present t)).symm)
    (Nat.le_trans (total_le _ each) (Nat.le_trans
      (Nat.le_of_eq (total_swap (fun x j => if j = x then W.otherCapacity cap₂ e t j else 0) js
        (L.present t)))
      (total_le js fun j _ => Nat.le_trans (total_le_at (a := j) (fun b pos => match decEq j b with
          | isTrue same => same.symm
          | isFalse other => absurd pos (fun p => Nat.lt_irrefl 0
              (Nat.lt_of_lt_of_le p (Nat.le_of_eq (if_neg other))))) (fed.2 t from_ to).1)
        (Nat.le_of_eq (if_pos rfl)))))

omit [DecidableEq F] [∀ t x, Decidable (W.active t x)] in
/-- **The lower members' stores are given at least what they rise together**, in a flow of the
two-tier hierarchy at a step of the stretch. -/
theorem storesRisen_le_given {L : Flow F C} (fed : FedThroughStores W store cs ks js cap₂ T n L)
    {t : Nat} (from_ : T ≤ t) (to : t < T + n) :
    W.storesRisen store ks t ≤ total ks (fun h => L.given t (store h)) :=
  total_le ks fun h inks => rise_le_given (((fed.2 t from_ to).2.1 h inks).1) (.head [])

/-- **What the stores rise together is within what the upper members other than `e` can give**, in
a flow of the two-tier hierarchy at a step of the stretch where `e`, if it takes part, gives the
stores nothing. -/
theorem storesRisen_le_capacity {L : Flow F C} (fed : FedThroughStores W store cs ks js cap₂ T n L)
    {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    (quiet : e ∈ L.present t → total ks (fun h => L.give t e (store h)) = 0) :
    W.storesRisen store ks t ≤ W.capacityWithout cap₂ js e t :=
  Nat.le_trans (storesRisen_le_given fed from_ to) (stores_given_le fed from_ to quiet)

/-- **The family is given at most what the others could give it through the hierarchy.** In a flow
of the two-tier hierarchy at a step of the stretch where `e`, if it takes part, gives nothing into
the hierarchy, the family is given at most `W.othersThrough`: the lower members other than `e` pass
on their stores' falls and what their stores are given beyond their rises, and the stores are
given, beyond what they all rise, at most what the upper members other than `e` can give. -/
theorem replenishment_le_othersThrough {L : Flow F C}
    (fed : FedThroughStores W store cs ks js cap₂ T n L) {t : Nat} (from_ : T ≤ t)
    (to : t < T + n)
    (quiet : e ∈ L.present t →
      total cs (L.give t e) + total ks (fun h => L.give t e (store h)) = 0) :
    L.replenishment cs t ≤ W.othersThrough store cap₂ ks js e t :=
  have quietFamily : e ∈ L.present t → total cs (L.give t e) = 0 := fun present =>
    Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (quiet present)))
  have quietStores : e ∈ L.present t → total ks (fun h => L.give t e (store h)) = 0 :=
    fun present => Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_left _ _)
      (Nat.le_of_eq (quiet present)))
  have split : total ks (fun h => if W.active t h ∧ h ≠ e then L.taken t (store h) else 0) =
      W.capacityWithout (W.storeFall store) ks e t +
        total ks (fun h => if W.active t h ∧ h ≠ e then
          excess (L.given t (store h)) (W.storeRise store t h) else 0) :=
    (total_congr_on fun h inks =>
      match (instDecidableAnd : Decidable (W.active t h ∧ h ≠ e)) with
      | isTrue both => (if_pos both).trans ((taken_store (((fed.2 t from_ to).2.1 h inks).1)).trans
          ((congrArg (· + excess (L.given t (store h)) (W.storeRise store t h))
            (if_pos (t := W.storeFall store t h) (e := (0 : Nat)) both).symm).trans
            (congrArg (W.otherCapacity (W.storeFall store) e t h + ·)
              (if_pos (t := excess (L.given t (store h)) (W.storeRise store t h)) (e := (0 : Nat))
                both).symm)))
      | isFalse no => (if_neg no).trans ((Nat.add_zero 0).symm.trans
          ((congrArg (· + 0) (if_neg (t := W.storeFall store t h) (e := (0 : Nat)) no).symm).trans
            (congrArg (W.otherCapacity (W.storeFall store) e t h + ·)
              (if_neg (t := excess (L.given t (store h)) (W.storeRise store t h)) (e := (0 : Nat))
                no).symm)))).trans
      (total_add _ _ ks)
  have gained : total ks (fun h => excess (L.given t (store h)) (W.storeRise store t h)) +
      W.storesRisen store ks t = total ks (fun h => L.given t (store h)) :=
    (total_add (fun h => excess (L.given t (store h)) (W.storeRise store t h))
      (W.storeRise store t) ks).symm.trans
      (total_congr_on fun h inks => excess_add_of_le
        (rise_le_given (((fed.2 t from_ to).2.1 h inks).1) (.head [])))
  have beyond : total ks (fun h => excess (L.given t (store h)) (W.storeRise store t h)) ≤
      excess (W.capacityWithout cap₂ js e t) (W.storesRisen store ks t) :=
    le_excess_of_add_le (Nat.le_trans (Nat.le_of_eq gained)
      (stores_given_le fed from_ to quietStores))
  Nat.le_trans (replenishment_le_taken fed from_ to quietFamily)
    (Nat.le_trans (Nat.le_of_eq split) (Nat.add_le_add_left
      (match (inferInstance : Decidable (W.RoutesAt ks e t)) with
      | isTrue routes => Nat.le_trans (total_le ks fun h _ =>
            match (instDecidableAnd : Decidable (W.active t h ∧ h ≠ e)) with
            | isTrue both => Nat.le_of_eq (if_pos both)
            | isFalse no => Nat.le_trans (Nat.le_of_eq (if_neg no)) (Nat.zero_le _))
          (Nat.le_trans beyond (Nat.le_of_eq (if_pos routes).symm))
      | isFalse noRoute => Nat.le_trans (Nat.le_of_eq (total_eq_zero fun h inks =>
            if_neg fun both => noRoute ⟨h, inks, both⟩)) (Nat.zero_le _)) _))

end Through

end Flow

namespace Web

variable {C : Type} (W : Web F C)

/-- The part of the step's demand beyond the falls of the stores of the active lower members
other than `e`: what the upper tier is to route through a lower member. -/
def routed [∀ t x, Decidable (W.active t x)] [DecidableEq F] (store : F → C) (cs : List C)
    (ks : List F) (e : F) (t : Nat) : Nat :=
  excess (W.demand cs t) (W.capacityWithout (W.storeFall store) ks e t)

/-- What each lower member can pass on at a step in the routed flow: its store's fall, and, for
the router (the first active lower member other than `e`), what is routed through it. -/
def routedCapacity [∀ t x, Decidable (W.active t x)] [DecidableEq F] (store : F → C)
    (cs : List C) (ks : List F) (e : F) (t : Nat) (h : F) : Nat :=
  W.storeFall store t h + if h = Flow.firstActiveOther W e t ks then W.routed store cs ks e t else 0

/-- What each lower member's store is to be given at a step in the routed flow: what it rises,
and, for the router's store, what is routed through it. -/
def storeNeed [∀ t x, Decidable (W.active t x)] [DecidableEq F] (store : F → C) (cs : List C)
    (ks : List F) (e : F) (t : Nat) (h : F) : Nat :=
  W.storeRise store t h + if h = Flow.firstActiveOther W e t ks then W.routed store cs ks e t else 0

/-- The upper tier's shares at the step from `t`: the units each lower member's store is to be
given, in order, paired with the units the upper members other than `e` can give, in order. -/
def routedShares [∀ t x, Decidable (W.active t x)] [DecidableEq F] (store : F → C)
    (cap₂ : Nat → F → Nat) (cs : List C) (ks js : List F) (e : F) (t : Nat) : List (F × F) :=
  pairUp (unitsOn (W.storeNeed store cs ks e t) ks) (unitsOn (W.otherCapacity cap₂ e t) js)

/-- What an upper member gives a condition at the step from `t` as the upper tier's shares pair
them. -/
def routedGive [∀ t x, Decidable (W.active t x)] [DecidableEq F] [DecidableEq C] (store : F → C)
    (cap₂ : Nat → F → Nat) (cs : List C) (ks js : List F) (e : F) (t : Nat) (x : F) (c : C) : Nat :=
  total (W.routedShares store cap₂ cs ks js e t) fun z => if store z.1 = c ∧ z.2 = x then 1 else 0

end Web

namespace Flow

variable {C : Type}

/-- Across a stretch, the routed flow of a two-tier hierarchy with `e` left out: the consumer
takes as in the least flow; every lower member takes from its own store what the store falls, the
router also what is routed through it; the upper members other than `e` give each lower member's
store what it rises and the router's store also what is routed, within their capacities
(`Web.routedGive`), and the lower members other than `e` give the family as the shares pair them,
within what they can pass on (`Web.routedCapacity`). -/
def routedDrawn [DecidableEq F] [DecidableEq C] (W : Web F C) [∀ t x, Decidable (W.active t x)]
    (store : F → C) (cap₂ : Nat → F → Nat) (cs : List C) (c₀ : C) (ks js : List F) (T n : Nat)
    (f e : F) : Flow F C where
  present t := if T ≤ t ∧ t < T + n then f :: (ks ++ js) else []
  take t x c := if x = f ∧ (∃ d, d ∈ cs ∧ d = c) then
      fall (fun s => W.level s c) t + W.drawnUnit cs c₀ t c
    else if (∃ h, h ∈ ks ∧ h = x) ∧ c = store x then W.routedCapacity store cs ks e t x else 0
  give t x c := (sharedDrawn W (W.routedCapacity store cs ks e) cs c₀ ks T n f e).give t x c +
    W.routedGive store cap₂ cs ks js e t x c

section Routed

variable [DecidableEq F] [DecidableEq C] {W : Web F C} [∀ t x, Decidable (W.active t x)]
  {store : F → C} {cap₂ : Nat → F → Nat} {cs : List C} {c₀ : C} {ks js : List F} {T n : Nat}
  {f e : F}

omit [DecidableEq C] in
/-- Where the others cover the demand and no lower member other than `e` is active, nothing is
routed. -/
theorem routed_zero {t : Nat} (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t)
    (noRoute : ¬ W.RoutesAt ks e t) : W.routed store cs ks e t = 0 :=
  eq_zero_of_not_pos fun pos => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le (excess_pos.mp pos)
    (Nat.le_trans covers (Nat.le_of_eq ((congrArg (W.capacityWithout (W.storeFall store) ks e t + ·)
      (if_neg noRoute)).trans (Nat.add_zero _)))))

omit [DecidableEq C] in
/-- Where the others cover the demand and some lower member other than `e` is active, what is
routed is at most what the upper members other than `e` can give beyond what the stores rise. -/
theorem routed_le {t : Nat} (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t)
    (routes : W.RoutesAt ks e t) :
    W.routed store cs ks e t ≤
      excess (W.capacityWithout cap₂ js e t) (W.storesRisen store ks t) :=
  excess_le_of_le_add (Nat.le_trans covers (Nat.le_of_eq
    (congrArg (W.capacityWithout (W.storeFall store) ks e t + ·) (if_pos routes))))

omit [DecidableEq C] in
/-- Where something is routed and the others cover the demand, the router is an active lower
member other than `e`. -/
theorem router_of_routed {t : Nat} (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t)
    (pos : 0 < W.routed store cs ks e t) :
    firstActiveOther W e t ks ∈ ks ∧ W.active t (firstActiveOther W e t ks) ∧
      firstActiveOther W e t ks ≠ e :=
  match (inferInstance : Decidable (W.RoutesAt ks e t)) with
  | isTrue routes =>
    have active := firstActiveOther_active (W := W) (g := e) (t := t) ks routes
    match firstActiveOther_mem (W := W) (g := e) (t := t) ks with
    | .inl mem => ⟨mem, active.1, active.2⟩
    | .inr same => absurd same active.2
  | isFalse noRoute => (Nat.lt_irrefl 0 (Eq.subst (motive := fun k => 0 < k)
      (routed_zero covers noRoute) pos)).elim

omit [DecidableEq C] in
/-- **What the stores are to be given is within what the upper members other than `e` can give**,
where those can give what the stores rise and the others cover the demand. -/
theorem storeNeed_total_le (apartK : Distinct ks) {t : Nat}
    (fills : W.storesRisen store ks t ≤ W.capacityWithout cap₂ js e t)
    (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) :
    total ks (W.storeNeed store cs ks e t) ≤ W.capacityWithout cap₂ js e t :=
  have atRouter : total ks (fun h => if h = firstActiveOther W e t ks then
      W.routed store cs ks e t else 0) ≤ W.routed store cs ks e t :=
    Nat.le_trans (total_le_at (a := firstActiveOther W e t ks) (fun b pos =>
        match decEq b (firstActiveOther W e t ks) with
        | isTrue same => same
        | isFalse other => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (if_neg other)))
            (Nat.lt_irrefl 0)) apartK)
      (Nat.le_of_eq (if_pos rfl))
  have both : W.storesRisen store ks t + W.routed store cs ks e t ≤
      W.capacityWithout cap₂ js e t :=
    match (inferInstance : Decidable (W.RoutesAt ks e t)) with
    | isTrue routes => Nat.le_trans (Nat.add_le_add_left (routed_le covers routes) _)
        (Nat.le_of_eq ((Nat.add_comm _ _).trans (excess_add_of_le fills)))
    | isFalse noRoute => Nat.le_trans (Nat.le_of_eq ((congrArg (W.storesRisen store ks t + ·)
        (routed_zero covers noRoute)).trans (Nat.add_zero _))) fills
  Nat.le_trans (Nat.le_of_eq (total_add (W.storeRise store t)
      (fun h => if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0) ks))
    (Nat.le_trans (Nat.add_le_add_left atRouter _) both)

/-- What an upper member gives as the shares pair them goes to a lower member's store, and the
giver is an active upper member other than `e`. -/
theorem routedGive_pos {t : Nat} {x : F} {c : C}
    (gives : 0 < W.routedGive store cap₂ cs ks js e t x c) :
    (∃ h, h ∈ ks ∧ store h = c) ∧ x ∈ js ∧ W.active t x ∧ x ≠ e :=
  match total_pos (W.routedShares store cap₂ cs ks js e t) gives with
  | ⟨z, mem, positive⟩ =>
    match (instDecidableAnd : Decidable (store z.1 = c ∧ z.2 = x)) with
    | isFalse no =>
      absurd (Nat.lt_of_lt_of_le positive (Nat.le_of_eq (if_neg no))) (Nat.lt_irrefl 0)
    | isTrue ⟨first, second⟩ => match mem_pairUp mem with
      | ⟨units, givers⟩ => match mem_unitsOn units, mem_unitsOn givers with
        | ⟨lower, _⟩, ⟨upper, spare⟩ =>
          have able : W.active t z.2 ∧ z.2 ≠ e :=
            match (instDecidableAnd : Decidable (W.active t z.2 ∧ z.2 ≠ e)) with
            | isTrue both => both
            | isFalse no =>
              absurd (Nat.lt_of_lt_of_le spare (Nat.le_of_eq (if_neg no))) (Nat.lt_irrefl 0)
          ⟨⟨z.1, lower, first⟩,
           Eq.subst (motive := fun y => y ∈ js) second upper,
           Eq.subst (motive := fun y => W.active t y) second able.1,
           Eq.subst (motive := fun y => y ≠ e) second able.2⟩

/-- Nothing the upper tier gives goes to a condition of the family, where no lower member's store
is in the family. -/
theorem routedGive_family (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} {x : F} {c : C}
    (inside : c ∈ cs) : W.routedGive store cap₂ cs ks js e t x c = 0 :=
  eq_zero_of_not_pos fun pos => match (routedGive_pos pos).1 with
  | ⟨h, member, same⟩ => separate h member (Eq.subst (motive := fun y => y ∈ cs) same.symm inside)

/-- **The upper members give each lower member's store exactly what it is to be given**, where
they can give what the stores rise, the others cover the demand and the stores are the lower
members' own. -/
theorem routedGive_store (apartK : Distinct ks) (apartJ : Distinct js)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h') {t : Nat}
    (fills : W.storesRisen store ks t ≤ W.capacityWithout cap₂ js e t)
    (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) {h : F} (member : h ∈ ks) :
    total js (fun x => W.routedGive store cap₂ cs ks js e t x (store h)) =
      W.storeNeed store cs ks e t h :=
  have long : total (unitsOn (W.storeNeed store cs ks e t) ks) (fun _ => 1) ≤
      total (unitsOn (W.otherCapacity cap₂ e t) js) (fun _ => 1) :=
    Nat.le_trans (Nat.le_of_eq ((total_unitsOn (fun _ => 1) (W.storeNeed store cs ks e t) ks).trans
        (total_congr_on fun _ _ => Nat.mul_one _)))
      (Nat.le_trans (storeNeed_total_le apartK fills covers)
        (Nat.le_of_eq ((total_unitsOn (fun _ => 1) (W.otherCapacity cap₂ e t) js).trans
          (total_congr_on fun _ _ => Nat.mul_one _)).symm))
  show total js (fun x => total (W.routedShares store cap₂ cs ks js e t)
      fun z => if store z.1 = store h ∧ z.2 = x then 1 else 0) = _ from
  (total_swap (fun (x : F) (z : F × F) => if store z.1 = store h ∧ z.2 = x then 1 else 0)
    (W.routedShares store cap₂ cs ks js e t) js).trans
    ((total_congr_on (g := fun (z : F × F) => if z.1 = h then 1 else 0) fun z mem =>
      match mem_pairUp mem with
      | ⟨units, givers⟩ => match mem_unitsOn units, mem_unitsOn givers with
        | ⟨lower, _⟩, ⟨upper, _⟩ => match decEq z.1 h with
          | isTrue same => (total_eq_at (a := z.2) (fun (x : F) pos =>
                match (instDecidableAnd : Decidable (store z.1 = store h ∧ z.2 = x)) with
                | isTrue both => both.2.symm
                | isFalse no =>
                  absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (if_neg no))) (Nat.lt_irrefl 0))
              apartJ upper).trans ((if_pos ⟨congrArg store same, rfl⟩).trans (if_pos same).symm)
          | isFalse other =>
            (total_eq_zero fun _ _ => if_neg fun both => other (own _ h lower member both.1)).trans
              (if_neg other).symm).trans
      ((total_pairUp_fst (fun a => if a = h then 1 else 0) _ _ long).trans
        ((total_unitsOn (fun a => if a = h then 1 else 0) _ ks).trans
          ((total_eq_at (a := h) (fun b pos => match decEq b h with
              | isTrue same => same
              | isFalse other => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
                  ((congrArg (W.storeNeed store cs ks e t b * ·) (if_neg other)).trans
                    (Nat.mul_zero _)))) (Nat.lt_irrefl 0)) apartK member).trans
            ((congrArg (W.storeNeed store cs ks e t h * ·) (if_pos rfl)).trans (Nat.mul_one _))))))

/-- **What an upper member gives the lower members' stores is at most its capacity**, however the
shares fall, where the stores are the lower members' own. -/
theorem routedGive_le (apartK : Distinct ks) (apartJ : Distinct js)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h') (t : Nat) (x : F) :
    total ks (fun h => W.routedGive store cap₂ cs ks js e t x (store h)) ≤ cap₂ t x :=
  show total ks (fun h => total (W.routedShares store cap₂ cs ks js e t)
      fun z => if store z.1 = store h ∧ z.2 = x then 1 else 0) ≤ cap₂ t x from
  Nat.le_trans (Nat.le_of_eq (total_swap (fun (h : F) (z : F × F) =>
      if store z.1 = store h ∧ z.2 = x then 1 else 0) (W.routedShares store cap₂ cs ks js e t) ks))
    (Nat.le_trans (total_le (q := fun (z : F × F) => if z.2 = x then 1 else 0) _ fun z mem =>
        match mem_pairUp mem with
        | ⟨units, _⟩ => match mem_unitsOn units with
          | ⟨lower, _⟩ => Nat.le_trans (total_le_at_on (a := z.1) (fun b bin pos =>
                match (instDecidableAnd : Decidable (store z.1 = store b ∧ z.2 = x)) with
                | isTrue both => own b z.1 bin lower both.1.symm
                | isFalse no => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (if_neg no)))
                    (Nat.lt_irrefl 0)) apartK)
              (match decEq z.2 x with
                | isTrue same => Nat.le_of_eq ((if_pos ⟨rfl, same⟩).trans (if_pos same).symm)
                | isFalse other => Nat.le_trans (Nat.le_of_eq (if_neg fun both => other both.2))
                    (Nat.zero_le _)))
      (Nat.le_trans (total_pairUp_snd_le (fun j => if j = x then 1 else 0) _ _)
        (Nat.le_trans (Nat.le_of_eq (total_unitsOn (fun j => if j = x then 1 else 0) _ js))
          (Nat.le_trans (total_le_at (a := x) (fun (j : F) pos => match decEq j x with
              | isTrue same => same
              | isFalse other => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
                  ((congrArg (W.otherCapacity cap₂ e t j * ·) (if_neg other)).trans
                    (Nat.mul_zero _)))) (Nat.lt_irrefl 0)) apartJ)
            (Nat.le_trans (Nat.le_of_eq ((congrArg (W.otherCapacity cap₂ e t x * ·)
              (if_pos rfl)).trans (Nat.mul_one _))) (Web.otherCapacity_le cap₂ e t x))))))

end Routed

end Flow

namespace Flow

variable {C : Type}

section RoutedFlow

variable [DecidableEq F] [DecidableEq C] {W : Web F C} [∀ t x, Decidable (W.active t x)]
  {store : F → C} {cap₂ : Nat → F → Nat} {cs : List C} {c₀ : C} {ks js : List F} {T n : Nat}
  {f e : F}

omit [DecidableEq C] in
/-- The lower members other than `e` can pass on the step's demand in the routed flow, where the
others cover it. -/
theorem routedCapacity_covers {t : Nat}
    (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) :
    W.demand cs t ≤ W.capacityWithout (W.routedCapacity store cs ks e) ks e t :=
  have split : W.capacityWithout (W.routedCapacity store cs ks e) ks e t =
      W.capacityWithout (W.storeFall store) ks e t +
        total ks (fun h => if W.active t h ∧ h ≠ e then
          (if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0) else 0) :=
    (total_congr_on fun h _ =>
      match (instDecidableAnd : Decidable (W.active t h ∧ h ≠ e)) with
      | isTrue both => (if_pos both).trans
          ((congrArg (· + (if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0))
            (if_pos (t := W.storeFall store t h) (e := (0 : Nat)) both).symm).trans
            (congrArg (W.otherCapacity (W.storeFall store) e t h + ·)
              (if_pos (t := if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0)
                (e := (0 : Nat)) both).symm))
      | isFalse no => (if_neg no).trans ((Nat.add_zero 0).symm.trans
          ((congrArg (· + 0) (if_neg (t := W.storeFall store t h) (e := (0 : Nat)) no).symm).trans
            (congrArg (W.otherCapacity (W.storeFall store) e t h + ·)
              (if_neg (t := if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0)
                (e := (0 : Nat)) no).symm)))).trans (total_add _ _ ks)
  match (inferInstance : Decidable (W.RoutesAt ks e t)) with
  | isTrue routes =>
    have router := firstActiveOther_active (W := W) (g := e) (t := t) ks routes
    have member : firstActiveOther W e t ks ∈ ks :=
      match firstActiveOther_mem (W := W) (g := e) (t := t) ks with
      | .inl mem => mem
      | .inr same => absurd same router.2
    Nat.le_trans (le_add_excess (W.demand cs t) (W.capacityWithout (W.storeFall store) ks e t))
      (Nat.le_trans (Nat.add_le_add_left (Nat.le_trans
          (Nat.le_of_eq ((if_pos (rfl : firstActiveOther W e t ks = firstActiveOther W e t ks)).symm.trans
            (if_pos router).symm))
          (le_total_of_mem (q := fun h => if W.active t h ∧ h ≠ e then
            (if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0) else 0) member)) _)
        (Nat.le_of_eq split.symm))
  | isFalse noRoute =>
    Nat.le_trans (Nat.le_trans covers (Nat.le_of_eq ((congrArg
        (W.capacityWithout (W.storeFall store) ks e t + ·) (if_neg noRoute)).trans (Nat.add_zero _))))
      (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq split.symm))

/-- In the routed flow what is given to a condition of the family is the lower members' giving,
where no lower member's store is in the family. -/
theorem routedDrawn_give_family (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} {x : F}
    {c : C} (inside : c ∈ cs) :
    (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x c =
      (sharedDrawn W (W.routedCapacity store cs ks e) cs c₀ ks T n f e).give t x c :=
  (congrArg ((sharedDrawn W (W.routedCapacity store cs ks e) cs c₀ ks T n f e).give t x c + ·)
    (routedGive_family separate inside)).trans (Nat.add_zero _)

/-- In the routed flow nothing given to a lower member's store is the lower members' giving: it is
an upper member's share. -/
theorem routedDrawn_give_store (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} {x h : F}
    (member : h ∈ ks) :
    (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x (store h) =
      W.routedGive store cap₂ cs ks js e t x (store h) :=
  (congrArg (· + W.routedGive store cap₂ cs ks js e t x (store h))
    (eq_zero_of_not_pos fun pos => separate h member
      (sharedDrawn_gives (W := W) (cap := W.routedCapacity store cs ks e) (cs := cs) (c₀ := c₀)
        (ks := ks) (T := T) (n := n) (f := f) (g := e) pos).1)).trans (Nat.zero_add _)

/-- The routed flow balances on the family at every step of the stretch, where the others cover the
demand there, `f` is in neither tier, the tiers are apart and no store is in the family. -/
theorem routedDrawn_balancesOn (distinct : Distinct cs) (inside : c₀ ∈ cs) (apartK : Distinct ks)
    (outsideK : ¬ f ∈ ks) (outsideJ : ¬ f ∈ js) (tiers : ∀ h, h ∈ ks → ¬ h ∈ js)
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs)
    (covers : ∀ t, T ≤ t → t < T + n → W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) :
    ∀ t, T ≤ t → t < T + n → (routedDrawn W store cap₂ cs c₀ ks js T n f e).BalancesOn W cs t := by
  intro t from_ to c member
  have present : (routedDrawn W store cap₂ cs c₀ ks js T n f e).present t = f :: (ks ++ js) :=
    if_pos ⟨from_, to⟩
  have takeSelf : (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t f c =
      fall (fun s => W.level s c) t + W.drawnUnit cs c₀ t c := if_pos ⟨rfl, ⟨c, member, rfl⟩⟩
  have takeOthers :
      total (ks ++ js) (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x c) = 0 :=
    total_eq_zero fun x mem =>
      (if_neg fun both => match ListTests.mem_append_iff.mp mem with
        | .inl k => outsideK (Eq.subst (motive := fun y => y ∈ ks) both.1 k)
        | .inr j => outsideJ (Eq.subst (motive := fun y => y ∈ js) both.1 j)).trans
        (if_neg fun both => match both.1 with
          | ⟨k, kin, same⟩ => separate x (Eq.subst (motive := fun y => y ∈ ks) same kin)
              (Eq.subst (motive := fun y => y ∈ cs) both.2 member))
  have giveSelf : (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t f c = 0 :=
    (routedDrawn_give_family separate member).trans
      (eq_zero_of_not_pos fun pos => outsideK (sharedDrawn_gives (W := W)
        (cap := W.routedCapacity store cs ks e) (cs := cs) (c₀ := c₀) (ks := ks) (T := T) (n := n)
        (f := f) (g := e) pos).2.1)
  have giveLower : total ks (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x c) =
      rise (fun s => W.level s c) t + W.drawnUnit cs c₀ t c :=
    (total_congr_on fun _ _ => routedDrawn_give_family separate member).trans
      (sharedDrawn_given_members (W := W) (cap := W.routedCapacity store cs ks e) (T := T) (n := n)
        (f := f) (g := e) distinct inside apartK (routedCapacity_covers (covers t from_ to)) member)
  have giveUpper : total js (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x c) = 0 :=
    total_eq_zero fun x xin => (routedDrawn_give_family separate member).trans
      (eq_zero_of_not_pos fun pos => tiers x (sharedDrawn_gives (W := W)
        (cap := W.routedCapacity store cs ks e) (cs := cs) (c₀ := c₀) (ks := ks) (T := T) (n := n)
        (f := f) (g := e) pos).2.1 xin)
  have giveOthers : total (ks ++ js) (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x c) =
      rise (fun s => W.level s c) t + W.drawnUnit cs c₀ t c := by
    rw [total_append, giveLower, giveUpper, Nat.add_zero]
  show W.level (t + 1) c + total ((routedDrawn W store cap₂ cs c₀ ks js T n f e).present t)
      (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x c) =
    W.level t c + total ((routedDrawn W store cap₂ cs c₀ ks js T n f e).present t)
      (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x c)
  rw [present]
  show W.level (t + 1) c + ((routedDrawn W store cap₂ cs c₀ ks js T n f e).take t f c +
      total (ks ++ js) (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x c)) =
    W.level t c + ((routedDrawn W store cap₂ cs c₀ ks js T n f e).give t f c +
      total (ks ++ js) (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x c))
  rw [takeSelf, takeOthers, giveSelf, giveOthers]
  exact (congrArg (W.level (t + 1) c + ·) (Nat.add_zero _)).trans ((Nat.add_assoc _ _ _).symm.trans
    ((congrArg (· + W.drawnUnit cs c₀ t c) (across (fun s => W.level s c) t)).trans
      ((Nat.add_assoc _ _ _).trans (congrArg (W.level t c + ·) (Nat.zero_add _).symm))))

end RoutedFlow

end Flow

namespace Flow

variable {C : Type}

section RoutedStores

variable [DecidableEq F] [DecidableEq C] {W : Web F C} [∀ t x, Decidable (W.active t x)]
  {store : F → C} {cap₂ : Nat → F → Nat} {cs : List C} {c₀ : C} {ks js : List F} {T n : Nat}
  {f e : F}

/-- In the routed flow each lower member takes from its own store what it can pass on, and nothing
else takes from it, where the stores are the lower members' own and not in the family, the tiers
are apart and `f` is in neither. -/
theorem routedDrawn_taken_store (apartK : Distinct ks) (outsideK : ¬ f ∈ ks)
    (tiers : ∀ h, h ∈ ks → ¬ h ∈ js)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    {h : F} (member : h ∈ ks) :
    (routedDrawn W store cap₂ cs c₀ ks js T n f e).taken t (store h) =
      W.routedCapacity store cs ks e t h := by
  have present : (routedDrawn W store cap₂ cs c₀ ks js T n f e).present t = f :: (ks ++ js) :=
    if_pos ⟨from_, to⟩
  have inFamily : ¬ ∃ d, d ∈ cs ∧ d = store h := fun ⟨_, dIn, same⟩ =>
    separate h member (Eq.subst (motive := fun y => y ∈ cs) same dIn)
  have takeSelf : (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t f (store h) = 0 :=
    (if_neg fun both => inFamily both.2).trans
      (if_neg fun both => match both.1 with
        | ⟨_, kin, same⟩ => outsideK (Eq.subst (motive := fun y => y ∈ ks) same kin))
  have takeLower :
      total ks (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x (store h)) =
        W.routedCapacity store cs ks e t h :=
    (total_eq_at (a := h) (fun x pos =>
        match (instDecidableAnd : Decidable (x = f ∧ ∃ d, d ∈ cs ∧ d = store h)) with
        | isTrue both => absurd both.2 inFamily
        | isFalse first =>
          match (instDecidableAnd : Decidable ((∃ k, k ∈ ks ∧ k = x) ∧ store h = store x)) with
          | isTrue ⟨⟨_, kin, same⟩, stores⟩ =>
            (own h x member (Eq.subst (motive := fun y => y ∈ ks) same kin) stores).symm
          | isFalse second => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
              ((if_neg first).trans (if_neg second)))) (Nat.lt_irrefl 0))
      apartK member).trans
      ((if_neg fun both => outsideK (Eq.subst (motive := fun y => y ∈ ks) both.1 member)).trans
        (if_pos ⟨⟨h, member, rfl⟩, rfl⟩))
  have takeUpper :
      total js (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x (store h)) = 0 :=
    total_eq_zero fun x xin =>
      (if_neg fun both => inFamily both.2).trans
        (if_neg fun both => match both.1 with
          | ⟨_, kin, same⟩ => tiers x (Eq.subst (motive := fun y => y ∈ ks) same kin) xin)
  show total ((routedDrawn W store cap₂ cs c₀ ks js T n f e).present t)
      (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x (store h)) = _
  rw [present]
  show (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t f (store h) +
      total (ks ++ js) (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x (store h)) = _
  rw [takeSelf, total_append, takeLower, takeUpper, Nat.add_zero, Nat.zero_add]

/-- In the routed flow each lower member's store is given what it is to be given, where the upper
members other than `e` can give what the stores rise and the others cover the demand. -/
theorem routedDrawn_given_store (apartK : Distinct ks) (apartJ : Distinct js)
    (outsideJ : ¬ f ∈ js) (tiers : ∀ h, h ∈ ks → ¬ h ∈ js)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    (fills : W.storesRisen store ks t ≤ W.capacityWithout cap₂ js e t)
    (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) {h : F} (member : h ∈ ks) :
    (routedDrawn W store cap₂ cs c₀ ks js T n f e).given t (store h) =
      W.storeNeed store cs ks e t h := by
  have present : (routedDrawn W store cap₂ cs c₀ ks js T n f e).present t = f :: (ks ++ js) :=
    if_pos ⟨from_, to⟩
  have giveSelf : (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t f (store h) = 0 :=
    (routedDrawn_give_store separate member).trans
      (eq_zero_of_not_pos fun pos => outsideJ (routedGive_pos pos).2.1)
  have giveLower :
      total ks (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x (store h)) = 0 :=
    total_eq_zero fun x xin => (routedDrawn_give_store separate member).trans
      (eq_zero_of_not_pos fun pos => tiers x xin (routedGive_pos pos).2.1)
  have giveUpper :
      total js (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x (store h)) =
        W.storeNeed store cs ks e t h :=
    (total_congr_on fun _ _ => routedDrawn_give_store separate member).trans
      (routedGive_store apartK apartJ own fills covers member)
  show total ((routedDrawn W store cap₂ cs c₀ ks js T n f e).present t)
      (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x (store h)) = _
  rw [present]
  show (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t f (store h) +
      total (ks ++ js) (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x (store h)) = _
  rw [giveSelf, total_append, giveLower, giveUpper, Nat.zero_add, Nat.zero_add]

/-- Each lower member's store balances in the routed flow, where the upper members other than `e`
can give what the stores rise and the others cover the demand. -/
theorem routedDrawn_balances_store (apartK : Distinct ks) (apartJ : Distinct js)
    (outsideK : ¬ f ∈ ks) (outsideJ : ¬ f ∈ js) (tiers : ∀ h, h ∈ ks → ¬ h ∈ js)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    (fills : W.storesRisen store ks t ≤ W.capacityWithout cap₂ js e t)
    (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) {h : F} (member : h ∈ ks) :
    (routedDrawn W store cap₂ cs c₀ ks js T n f e).BalancesOn W [store h] t := by
  intro c mem
  have same : c = store h := match mem_cons_cases mem with
    | .inl same => same
    | .inr empty => nomatch empty
  subst same
  show W.level (t + 1) (store h) + (routedDrawn W store cap₂ cs c₀ ks js T n f e).taken t (store h) =
    W.level t (store h) + (routedDrawn W store cap₂ cs c₀ ks js T n f e).given t (store h)
  rw [routedDrawn_taken_store apartK outsideK tiers own separate from_ to member,
    routedDrawn_given_store apartK apartJ outsideJ tiers own separate from_ to fills covers member]
  show W.level (t + 1) (store h) + (W.storeFall store t h +
      (if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0)) =
    W.level t (store h) + (W.storeRise store t h +
      (if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0))
  exact (Nat.add_assoc _ _ _).symm.trans ((congrArg (· + _)
    (across (fun s => W.level s (store h)) t)).trans (Nat.add_assoc _ _ _))

/-- **The routed flow is a flow of the two-tier hierarchy**, where at every step of the stretch
the upper members other than `e` can give what the stores rise and the others cover the demand,
`f` is in neither tier, the tiers are apart, and the stores are the lower members' own and not in
the family. -/
theorem routedDrawn_fedThroughStores (distinct : Distinct cs) (inside : c₀ ∈ cs)
    (apartK : Distinct ks) (apartJ : Distinct js) (outsideK : ¬ f ∈ ks) (outsideJ : ¬ f ∈ js)
    (tiers : ∀ h, h ∈ ks → ¬ h ∈ js)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs)
    (fills : ∀ t, T ≤ t → t < T + n → W.storesRisen store ks t ≤ W.capacityWithout cap₂ js e t)
    (covers : ∀ t, T ≤ t → t < T + n → W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) :
    FedThroughStores W store cs ks js cap₂ T n (routedDrawn W store cap₂ cs c₀ ks js T n f e) :=
  ⟨⟨routedDrawn_balancesOn distinct inside apartK outsideK outsideJ tiers separate covers,
    fun _ _ _ _ gives => match Naturals.pos_or_of_add_pos gives with
      | .inl shared => (sharedDrawn_gives (W := W) (cap := W.routedCapacity store cs ks e) (cs := cs)
          (c₀ := c₀) (ks := ks) (T := T) (n := n) (f := f) (g := e) shared).2.2.1
      | .inr upper => (routedGive_pos upper).2.2.1,
    fun _ _ _ inFamily _ gives =>
      (sharedDrawn_gives (W := W) (cap := W.routedCapacity store cs ks e) (cs := cs) (c₀ := c₀)
        (ks := ks) (T := T) (n := n) (f := f) (g := e)
        (Nat.lt_of_lt_of_le gives (Nat.le_of_eq
          (routedDrawn_give_family separate inFamily)))).2.1⟩,
   fun t from_ to =>
    have present : (routedDrawn W store cap₂ cs c₀ ks js T n f e).present t = f :: (ks ++ js) :=
      if_pos ⟨from_, to⟩
    ⟨Eq.subst (motive := fun l => Distinct l) present.symm
        ⟨fun mem => match ListTests.mem_append_iff.mp mem with
          | .inl k => outsideK k
          | .inr j => outsideJ j, distinct_append apartK apartJ tiers⟩,
     fun h member =>
      ⟨routedDrawn_balances_store apartK apartJ outsideK outsideJ tiers own separate from_ to
          (fills t from_ to) (covers t from_ to) member,
       fun _ => Nat.le_trans (Nat.le_of_eq (total_congr_on fun _ inFamily =>
           routedDrawn_give_family separate inFamily))
         (Nat.le_trans (sharedDrawn_given_le (W := W) (cap := W.routedCapacity store cs ks e)
             (c₀ := c₀) (T := T) (n := n) (f := f) (g := e) distinct apartK t h)
           (Nat.le_trans (Web.otherCapacity_le (W.routedCapacity store cs ks e) e t h)
             (Nat.le_of_eq ((if_pos ⟨⟨h, member, rfl⟩, rfl⟩).symm.trans
               (if_neg fun both => outsideK
                 (Eq.subst (motive := fun y => y ∈ ks) both.1 member)).symm)))),
       fun _ _ gives => (routedGive_pos (Nat.lt_of_lt_of_le gives
         (Nat.le_of_eq (routedDrawn_give_store separate member)))).2.1⟩,
     fun x _ _ => Nat.le_trans (Nat.le_of_eq (total_congr_on fun _ inks =>
         routedDrawn_give_store separate inks)) (routedGive_le apartK apartJ own t x)⟩⟩

/-- In the routed flow `f` draws past the family's stock, where it is active across a stretch
longer than the stock and the family holds `c₀`. -/
theorem routedDrawn_drawsPast (inside : c₀ ∈ cs)
    (alive : ∀ t, T ≤ t → t < T + n → W.active t f) (below : W.stock cs T < n) :
    DrawsPast cs T n (routedDrawn W store cap₂ cs c₀ ks js T n f e, W) f :=
  ⟨below, fun t from_ to =>
    have present : (routedDrawn W store cap₂ cs c₀ ks js T n f e).present t = f :: (ks ++ js) :=
      if_pos ⟨from_, to⟩
    ⟨alive t from_ to, Eq.subst (motive := fun l => f ∈ l) present.symm (.head _),
     match W.decSomeFalls cs t with
     | isTrue ⟨c, mem, falls⟩ =>
       total_pos_of_mem (q := (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t f) mem
        (Nat.lt_of_lt_of_le (excess_pos.mpr falls) (Nat.le_trans (Nat.le_add_right _ _)
          (Nat.le_of_eq (if_pos ⟨rfl, ⟨c, mem, rfl⟩⟩).symm)))
     | isFalse steady =>
       total_pos_of_mem (q := (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t f) inside
        (Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_trans (Nat.le_add_left _ _)
          (Nat.le_trans (Nat.le_of_eq (congrArg (fall (fun s => W.level s c₀) t + ·)
            (if_pos ⟨rfl, steady⟩)).symm)
            (Nat.le_of_eq (if_pos ⟨rfl, ⟨c₀, inside, rfl⟩⟩).symm))))⟩⟩

/-- In the routed flow `e` gives nothing into the hierarchy, where no store is in the family. -/
theorem routedDrawn_not_gives (distinct : Distinct cs) (apartK : Distinct ks)
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) :
    ¬ GivesInto cs ks store T n (routedDrawn W store cap₂ cs c₀ ks js T n f e, W) e :=
  fun ⟨t, _, _, _, gives⟩ =>
    have family : total cs ((routedDrawn W store cap₂ cs c₀ ks js T n f e).give t e) = 0 :=
      (total_congr_on fun _ inFamily => routedDrawn_give_family separate inFamily).trans
        (sharedDrawn_quiet (W := W) (cap := W.routedCapacity store cs ks e) (c₀ := c₀) (T := T)
          (n := n) (f := f) (g := e) distinct apartK t)
    have stores :
        total ks (fun h => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t e (store h)) = 0 :=
      total_eq_zero fun _ inks => (routedDrawn_give_store separate inks).trans
        (eq_zero_of_not_pos fun pos => (routedGive_pos pos).2.2.2 rfl)
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives (Nat.le_of_eq
      ((congrArg (· + _) family).trans ((congrArg (0 + ·) stores).trans (Nat.zero_add 0)))))

end RoutedStores

/-- **A formation is needed across two tiers exactly where the others cannot both give what the
stores rise and give the demand through the hierarchy.** Over the flows of a family fed from lower
members, each passing on what it takes from its own store (the stores not in the family and none
shared), the stores given only by upper members within supplied capacities, with activity and
identity decided and the family and both tiers listed without repetition and apart, let `f`, in
neither tier, be active across a stretch longer than the family's stock. Then `f` drawing past the
stock needs `e`'s giving into the hierarchy exactly where, at some step of the stretch, what the
upper members other than `e` can give together falls short of what the stores rise, or what the
others could give the family through the hierarchy (`Web.othersThrough`) falls short of the step's
demand. -/
theorem needs_iff_through_short [DecidableEq F] [DecidableEq C] {W : Web F C}
    [∀ t x, Decidable (W.active t x)] {store : F → C} {cap₂ : Nat → F → Nat} {cs : List C}
    (distinct : Distinct cs) {c₀ : C} (inside : c₀ ∈ cs) {ks js : List F} (apartK : Distinct ks)
    (apartJ : Distinct js) (tiers : ∀ h, h ∈ ks → ¬ h ∈ js) {T n : Nat} {f e : F}
    (outsideK : ¬ f ∈ ks) (outsideJ : ¬ f ∈ js) (alive : ∀ t, T ≤ t → t < T + n → W.active t f)
    (below : W.stock cs T < n) (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) :
    NeedsPart (FedThroughStores W store cs ks js cap₂ T n) (fun L => DrawsPast cs T n (L, W))
        (fun L => GivesInto cs ks store T n (L, W)) f e ↔
      ∃ t, T ≤ t ∧ t < T + n ∧ (W.capacityWithout cap₂ js e t < W.storesRisen store ks t ∨
        W.othersThrough store cap₂ ks js e t < W.demand cs t) :=
  ⟨fun needs => match decideSome (p := fun t => W.capacityWithout cap₂ js e t <
        W.storesRisen store ks t ∨ W.othersThrough store cap₂ ks js e t < W.demand cs t)
      (steps T n) with
    | isTrue ⟨t, mem, short⟩ => match between_of_mem_steps mem with
      | ⟨from_, to⟩ => ⟨t, from_, to, short⟩
    | isFalse covered =>
      absurd (needs _ (routedDrawn_fedThroughStores (c₀ := c₀) (f := f) distinct inside apartK
          apartJ outsideK outsideJ tiers own separate
          (fun t from_ to => Nat.ge_of_not_lt fun short =>
            covered ⟨t, steps_of_within from_ to, .inl short⟩)
          (fun t from_ to => Nat.ge_of_not_lt fun short =>
            covered ⟨t, steps_of_within from_ to, .inr short⟩))
        (routedDrawn_drawsPast inside alive below))
        (routedDrawn_not_gives distinct apartK separate),
   fun ⟨t, from_, to, short⟩ L fed ⟨_, draws⟩ =>
    match decideSome (p := fun x => x = e ∧
        0 < total cs (L.give t x) + total ks (fun h => L.give t x (store h))) (L.present t) with
    | isTrue ⟨_, present, same, gives⟩ => ⟨t, from_, to, same ▸ present, same ▸ gives⟩
    | isFalse loud =>
      have quiet : e ∈ L.present t →
          total cs (L.give t e) + total ks (fun h => L.give t e (store h)) = 0 :=
        fun present => eq_zero_of_not_pos fun pos => loud ⟨e, present, rfl, pos⟩
      False.elim (match short with
        | .inl over => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le over
            (storesRisen_le_capacity fed from_ to fun present =>
              Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_left _ _)
                (Nat.le_of_eq (quiet present)))))
        | .inr under => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le under
            (Nat.le_trans (demand_le_replenishment (fed.1.1 t from_ to) (draws t from_ to).2.1
              (draws t from_ to).2.2) (replenishment_le_othersThrough fed from_ to quiet))))⟩

end Flow

/-! ## Need and feeding, read with time -/

namespace Flow

variable {C : Type}

/-- In a flow in which only active formations give, a formation giving to a family within a stretch
is active at some step of it. -/
theorem active_of_givesWithin {L : Flow F C} {W : Web F C} (acting : L.Acting W) {cs : List C}
    {T n : Nat} {e : F} (gives : GivesWithin cs T n (L, W) e) :
    ∃ t, T ≤ t ∧ t < T + n ∧ W.active t e :=
  match gives with
  | ⟨t, from_, to, present, pos⟩ => match total_pos cs pos with
    | ⟨c, _, positive⟩ => ⟨t, from_, to, acting t e c present positive⟩

/-- In a flow in which only active formations give, a formation giving into a two-tier hierarchy
within a stretch is active at some step of it. -/
theorem active_of_givesInto {L : Flow F C} {W : Web F C} (acting : L.Acting W) {cs : List C}
    {ks : List F} {store : F → C} {T n : Nat} {e : F} (gives : GivesInto cs ks store T n (L, W) e) :
    ∃ t, T ≤ t ∧ t < T + n ∧ W.active t e :=
  match gives with
  | ⟨t, from_, to, present, pos⟩ => match Naturals.pos_or_of_add_pos pos with
    | .inl family => match total_pos cs family with
      | ⟨c, _, positive⟩ => ⟨t, from_, to, acting t e c present positive⟩
    | .inr stores => match total_pos ks stores with
      | ⟨h, _, positive⟩ => ⟨t, from_, to, acting t e (store h) present positive⟩

/-- **Need ends at the end.** Over any flows read off a web in which only active formations give, a
formation active at no step of the stretch is needed exactly where no such flow lets the consumer
draw past the stock: need reaches only what is active within the stretch it is read across, and
nothing active only before or after it. -/
theorem needs_iff_none_of_inactive {W : Web F C} {possible : Flow F C → Prop}
    (acting : ∀ L, possible L → L.Acting W) {cs : List C} {T n : Nat} {f e : F}
    (inactive : ∀ t, T ≤ t → t < T + n → ¬ W.active t e) :
    NeedsPart possible (fun L => DrawsPast cs T n (L, W)) (fun L => GivesWithin cs T n (L, W)) f e ↔
      ¬ ∃ L, possible L ∧ DrawsPast cs T n (L, W) f :=
  ⟨fun needs ⟨L, here, draws⟩ => match active_of_givesWithin (acting L here) (needs L here draws) with
    | ⟨t, from_, to, active⟩ => inactive t from_ to active,
   fun none L here draws => absurd ⟨L, here, draws⟩ none⟩

/-- **Need ends at the end, across two tiers**: a formation active at no step of the stretch is
needed for its giving into a two-tier hierarchy exactly where no flow of the hierarchy lets the
consumer draw past the stock. -/
theorem needs_into_iff_none_of_inactive {W : Web F C} {store : F → C} {cs : List C}
    {ks js : List F} {cap₂ : Nat → F → Nat} {T n : Nat} {f e : F}
    (inactive : ∀ t, T ≤ t → t < T + n → ¬ W.active t e) :
    NeedsPart (FedThroughStores W store cs ks js cap₂ T n) (fun L => DrawsPast cs T n (L, W))
        (fun L => GivesInto cs ks store T n (L, W)) f e ↔
      ¬ ∃ L, FedThroughStores W store cs ks js cap₂ T n L ∧ DrawsPast cs T n (L, W) f :=
  ⟨fun needs ⟨L, fed, draws⟩ => match active_of_givesInto fed.1.2.1 (needs L fed draws) with
    | ⟨t, from_, to, active⟩ => inactive t from_ to active,
   fun none L fed draws => absurd ⟨L, fed, draws⟩ none⟩

/-- `h` feeds `g`'s continuation at a step no later than the step `g` is read at: the link of a
feeding closure read with time. -/
def FedUpTo (L : Flow F C) (W : Web F C) (e e' : F × Nat) : Prop :=
  e'.2 ≤ e.2 ∧ L.FedBy W (e.1, e'.2) e'

/-- `g` lies within `f`'s feeding closure read with time up to `T`: from `f` read at `T`, it is
reached at some step by links each no later than the one before. -/
def WithinFeedingUpTo (L : Flow F C) (W : Web F C) (f : F) (T : Nat) (g : F) : Prop :=
  ∃ s, WithinClosure (L.FedUpTo W) (f, T) (g, s)

/-- **Read with time, a feeding closure holds only what gives up to the step it is read up to.**
Every formation within `f`'s feeding closure up to `T`, other than `f`, takes part and gives at
some step no later than `T`. -/
theorem gives_of_withinFeedingUpTo {L : Flow F C} {W : Web F C} {f : F} {T : Nat} {g : F}
    (within : L.WithinFeedingUpTo W f T g) :
    g = f ∨ ∃ s, s ≤ T ∧ g ∈ L.present s ∧ ∃ c, 0 < L.give s g c :=
  match within with
  | ⟨s, reached⟩ =>
    match (reached (fun e => e.2 ≤ T ∧ (e.1 = f ∨ (e.1 ∈ L.present e.2 ∧ ∃ c, 0 < L.give e.2 e.1 c)))
        (fun _ _ ⟨before, _⟩ ⟨earlier, _, c, _, present, gives⟩ =>
          ⟨Nat.le_trans earlier before, .inr ⟨present, c, gives⟩⟩)
        ⟨Nat.le_refl T, .inl rfl⟩ : s ≤ T ∧ (g = f ∨ (g ∈ L.present s ∧ ∃ c, 0 < L.give s g c))) with
    | ⟨_, .inl same⟩ => .inl same
    | ⟨by_, .inr ⟨present, c, gives⟩⟩ => .inr ⟨s, by_, present, c, gives⟩

/-- Where only active formations give, every formation within `f`'s feeding closure up to `T`, other
than `f`, is active at some step no later than `T`: a formation active only after `T` lies outside
it. -/
theorem active_of_withinFeedingUpTo {L : Flow F C} {W : Web F C} (acting : L.Acting W) {f : F}
    {T : Nat} {g : F} (within : L.WithinFeedingUpTo W f T g) :
    g = f ∨ ∃ s, s ≤ T ∧ W.active s g :=
  match gives_of_withinFeedingUpTo within with
  | .inl same => .inl same
  | .inr ⟨s, by_, present, c, gives⟩ => .inr ⟨s, by_, acting s g c present gives⟩

/-- The feeding closure read with time lies within the feeding closure read across every step. -/
theorem withinFeeding_of_upTo {L : Flow F C} {W : Web F C} {f : F} {T : Nat} {g : F}
    (within : L.WithinFeedingUpTo W f T g) : L.WithinFeeding W f g :=
  match within with
  | ⟨_, reached⟩ => fun region closed holds =>
    reached (fun e => region e.1) (fun e e' inside ⟨_, fed⟩ => closed e.1 e'.1 inside ⟨e'.2, fed⟩)
      holds

end Flow

namespace Feeders

open Copies (Part copies)

/-- The flow in which the first copy feeds: at every step the user and the first take part, the
user takes one unit of the one condition and the first gives one. -/
def withFirst : Flow Part Unit where
  present := fun _ => [.user, .first]
  take := fun _ x _ => match x with
    | .user => 1
    | .first => 0
    | .second => 0
  give := fun _ x _ => match x with
    | .user => 0
    | .first => 1
    | .second => 0

/-- The flow in which the second copy feeds. -/
def withSecond : Flow Part Unit where
  present := fun _ => [.user, .second]
  take := fun _ x _ => match x with
    | .user => 1
    | .first => 0
    | .second => 0
  give := fun _ x _ => match x with
    | .user => 0
    | .first => 0
    | .second => 1

/-- The web: the condition stands at zero, and every formation is active. -/
def web : Web Part Unit :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 0, fun _ _ _ => True⟩

/-- What takes part in either flow is the user or that flow's copy. -/
theorem mem_pair {x a b : Part} (mem : x ∈ [a, b]) : x = a ∨ x = b :=
  match mem_cons_cases mem with
  | .inl same => .inl same
  | .inr rest => match mem_cons_cases rest with
    | .inl same => .inr same
    | .inr empty => nomatch empty

theorem fedOnlyBy_withFirst : Flow.FedOnlyBy [()] copies (withFirst, web) :=
  ⟨fun _ _ => rfl, fun _ _ _ _ _ => trivial, fun t _ c _ present gives =>
    match mem_pair present with
    | .inl user => absurd gives (Eq.subst (motive := fun y => ¬ 0 < withFirst.give t y c) user.symm
        (Nat.lt_irrefl 0))
    | .inr first => .inl first⟩

theorem fedOnlyBy_withSecond : Flow.FedOnlyBy [()] copies (withSecond, web) :=
  ⟨fun _ _ => rfl, fun _ _ _ _ _ => trivial, fun t _ c _ present gives =>
    match mem_pair present with
    | .inl user => absurd gives (Eq.subst (motive := fun y => ¬ 0 < withSecond.give t y c) user.symm
        (Nat.lt_irrefl 0))
    | .inr second => .inr second⟩

theorem drawsPast_withFirst : Flow.DrawsPast [()] 0 1 (withFirst, web) .user :=
  ⟨Nat.one_pos, fun _ _ _ => ⟨trivial, .head _, Nat.one_pos⟩⟩

theorem drawsPast_withSecond : Flow.DrawsPast [()] 0 1 (withSecond, web) .user :=
  ⟨Nat.one_pos, fun _ _ _ => ⟨trivial, .head _, Nat.one_pos⟩⟩

/-- Each copy feeds the user alone. -/
theorem partAlone :
    PartAlone (Flow.FedOnlyBy [()] copies) (Flow.DrawsPast [()] 0 1) (Flow.GivesWithin [()] 0 1)
      .user copies :=
  fun g member => match g, member with
    | .user, member => absurd member Copies.user_not_copy
    | .first, _ => ⟨(withFirst, web), fedOnlyBy_withFirst, drawsPast_withFirst,
        ⟨0, Nat.le_refl 0, Nat.one_pos, .tail _ (.head _), Nat.one_pos⟩,
        fun _ other ⟨_, _, _, present, _⟩ => match mem_pair present with
          | .inl user => absurd (Eq.subst (motive := copies) user other) Copies.user_not_copy
          | .inr first => first⟩
    | .second, _ => ⟨(withSecond, web), fedOnlyBy_withSecond, drawsPast_withSecond,
        ⟨0, Nat.le_refl 0, Nat.one_pos, .tail _ (.head _), Nat.one_pos⟩,
        fun _ other ⟨_, _, _, present, _⟩ => match mem_pair present with
          | .inl user => absurd (Eq.subst (motive := copies) user other) Copies.user_not_copy
          | .inr second => second⟩

/-- **Two feeders on a flow: the user, drawing past the stock, needs some feeder's giving and
neither feeder's.** -/
theorem two_feeders :
    NeedsSomePart (Flow.FedOnlyBy [()] copies) (Flow.DrawsPast [()] 0 1)
        (Flow.GivesWithin [()] 0 1) .user copies ∧
      ¬ NeedsPart (Flow.FedOnlyBy [()] copies) (Flow.DrawsPast [()] 0 1)
        (Flow.GivesWithin [()] 0 1) .user .first ∧
      ¬ NeedsPart (Flow.FedOnlyBy [()] copies) (Flow.DrawsPast [()] 0 1)
        (Flow.GivesWithin [()] 0 1) .user .second :=
  ⟨Flow.needsSome_of_drawsPast [()] copies 0 1 .user,
   fun needs => Part.noConfusion
     ((Flow.needs_giver_iff_only partAlone (.inl rfl)).mp needs .second (.inr rfl)),
   fun needs => Part.noConfusion
     ((Flow.needs_giver_iff_only partAlone (.inr rfl)).mp needs .first (.inl rfl))⟩


instance decEqPart : DecidableEq Part := fun a b => match a, b with
  | .user, .user => isTrue rfl
  | .first, .first => isTrue rfl
  | .second, .second => isTrue rfl
  | .user, .first => isFalse fun same => Part.noConfusion same
  | .user, .second => isFalse fun same => Part.noConfusion same
  | .first, .user => isFalse fun same => Part.noConfusion same
  | .first, .second => isFalse fun same => Part.noConfusion same
  | .second, .user => isFalse fun same => Part.noConfusion same
  | .second, .first => isFalse fun same => Part.noConfusion same

/-- The user is neither copy. -/
theorem user_outside : ¬ Part.user ∈ [Part.first, .second] :=
  fun mem => match mem_pair mem with
  | .inl same => Part.noConfusion same
  | .inr same => Part.noConfusion same

/-- **Read off the web, neither feeder is needed.** On `web`, every formation is active at every
step, so each copy can feed the condition alone, and over the flows read off the web the user,
drawing past the stock, needs neither copy's giving. -/
theorem two_feeders_on :
    ¬ NeedsPart (Flow.FedOnlyOn web [()] (· ∈ [Part.first, .second]) 0 1)
        (fun L => Flow.DrawsPast [()] 0 1 (L, web)) (fun L => Flow.GivesWithin [()] 0 1 (L, web))
        .user .first ∧
      ¬ NeedsPart (Flow.FedOnlyOn web [()] (· ∈ [Part.first, .second]) 0 1)
        (fun L => Flow.DrawsPast [()] 0 1 (L, web)) (fun L => Flow.GivesWithin [()] 0 1 (L, web))
        .user .second :=
  ⟨fun needs => Part.noConfusion ((Flow.needs_giver_iff_only_on (List.Mem.head []) user_outside
      (fun _ _ _ => trivial) Nat.one_pos (fun _ _ _ _ _ _ => trivial) (.head _)).mp needs .second
      (.tail _ (.head _))),
   fun needs => Part.noConfusion ((Flow.needs_giver_iff_only_on (List.Mem.head []) user_outside
      (fun _ _ _ => trivial) Nat.one_pos (fun _ _ _ _ _ _ => trivial) (.tail _ (.head _))).mp needs
      .first (.head _))⟩

end Feeders

namespace FeedersInTurn

open Copies (Part)

/-- Who is active at a step: the user always, the first copy at step `0`, the second at step `1`. -/
def activeAt (t : Nat) : Part → Bool
  | .user => true
  | .first => Nat.beq t 0
  | .second => Nat.beq t 1

/-- The web of the shifts: the condition stands at zero, and the copies are active in turn. -/
def web : Web Part Unit :=
  ⟨fun _ _ => 0, fun t x => activeAt t x = true, fun _ _ _ => True, fun _ _ _ => 0,
   fun _ _ _ => True⟩

instance decActive : ∀ t x, Decidable (web.active t x) :=
  fun t x => instDecidableEqBool (activeAt t x) true

/-- The condition stands still, so every step calls for giving. -/
theorem calls (t : Nat) : web.CallsForGiving [()] t :=
  .inr fun ⟨_, _, falls⟩ => Nat.lt_irrefl 0 falls

/-- **Two feeders in turn: the user needs both.** At step `0` only the first copy is active and at
step `1` only the second, and both steps call for giving, so over the flows read off the web the
user, drawing past the stock across the two steps, needs each copy's giving. -/
theorem needs_both :
    NeedsPart (Flow.FedOnlyOn web [()] (· ∈ [Part.first, .second]) 0 2)
        (fun L => Flow.DrawsPast [()] 0 2 (L, web)) (fun L => Flow.GivesWithin [()] 0 2 (L, web))
        .user .first ∧
      NeedsPart (Flow.FedOnlyOn web [()] (· ∈ [Part.first, .second]) 0 2)
        (fun L => Flow.DrawsPast [()] 0 2 (L, web)) (fun L => Flow.GivesWithin [()] 0 2 (L, web))
        .user .second :=
  ⟨(Flow.needs_giver_iff_alone (List.Mem.head []) Feeders.user_outside (.head _)
      (fun _ _ _ => rfl) (Nat.succ_pos 1)).mpr ⟨0, Nat.le_refl 0, Nat.succ_pos 1, calls 0,
      fun _ inks active => match Feeders.mem_pair inks with
        | .inl same => same
        | .inr same => absurd (Eq.subst (motive := fun x => web.active 0 x) same active)
            (fun on => Bool.noConfusion on)⟩,
   (Flow.needs_giver_iff_alone (List.Mem.head []) Feeders.user_outside (.tail _ (.head _))
      (fun _ _ _ => rfl) (Nat.succ_pos 1)).mpr ⟨1, Nat.zero_le 1, Nat.succ_lt_succ (Nat.succ_pos 0),
      calls 1, fun _ inks active => match Feeders.mem_pair inks with
        | .inl same => absurd (Eq.subst (motive := fun x => web.active 1 x) same active)
            (fun on => Bool.noConfusion on)
        | .inr same => same⟩⟩

end FeedersInTurn

namespace Capacities

open Copies (Part)

/-- One condition rising by one at every step, every formation active. -/
def web : Web Part Unit :=
  ⟨fun t _ => t, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 0, fun _ _ _ => True⟩

/-- What each can give at a step: the first copy one unit, the second two. -/
def cap (_ : Nat) : Part → Nat
  | .user => 0
  | .first => 1
  | .second => 2

instance decActive : ∀ t x, Decidable (web.active t x) := fun _ _ => instDecidableTrue

/-- One more than a number exceeds it by one. -/
theorem excess_succ : ∀ t : Nat, excess (t + 1) t = 1
  | 0 => rfl
  | t + 1 => excess_succ t

/-- The condition never falls. -/
theorem steady (t : Nat) : ¬ ∃ d, d ∈ [()] ∧ web.Falls t d :=
  fun ⟨_, _, falls⟩ => Nat.lt_irrefl t (Nat.lt_trans (Nat.lt_succ_self t) falls)

/-- Every step demands two units: one the condition rises, and one the user draws. -/
theorem demand_two (t : Nat) : web.demand [()] t = 2 := by
  show (excess (t + 1) t + 0) + (if ¬ ∃ d, d ∈ [()] ∧ web.Falls t d then 1 else 0) = 2
  rw [excess_succ, if_pos (steady t)]

/-- Every step calls for giving. -/
theorem calls (t : Nat) : web.CallsForGiving [()] t :=
  .inl ⟨(), .head [], Nat.lt_succ_self t⟩

theorem distinct : Distinct [()] := ⟨(fun empty => nomatch empty), trivial⟩

/-- **The second copy can feed the condition alone, and the first cannot.** -/
theorem second_alone_first_not :
    (∃ L, Flow.FedOnlyWithin web cap [()] (· ∈ [Part.first, .second]) 0 1 L ∧
      Flow.DrawsPast [()] 0 1 (L, web) .user ∧ Flow.GivesWithin [()] 0 1 (L, web) .second ∧
      ∀ h, h ∈ [Part.first, .second] → Flow.GivesWithin [()] 0 1 (L, web) h → h = .second) ∧
    ¬ ∃ L, Flow.FedOnlyWithin web cap [()] (· ∈ [Part.first, .second]) 0 1 L ∧
      Flow.DrawsPast [()] 0 1 (L, web) .user ∧ Flow.GivesWithin [()] 0 1 (L, web) .first ∧
      ∀ h, h ∈ [Part.first, .second] → Flow.GivesWithin [()] 0 1 (L, web) h → h = .first :=
  ⟨(Flow.feedsAlone_iff distinct (List.Mem.head []) Feeders.user_outside (.tail _ (.head _))
      (fun _ _ _ => trivial) Nat.one_pos).mpr fun t _ _ _ => ⟨trivial, Nat.le_of_eq (demand_two t)⟩,
   fun can => Nat.not_succ_le_self 1 (Eq.subst (motive := fun d => d ≤ 1) (demand_two 0)
     ((Flow.feedsAlone_iff distinct (List.Mem.head []) Feeders.user_outside (.head _)
       (fun _ _ _ => trivial) Nat.one_pos).mp can 0 (Nat.le_refl 0) Nat.one_pos (calls 0)).2)⟩

/-- **The user needs the second copy's giving**: the first alone can give one unit a step, short
of the two each step demands. -/
theorem needs_second :
    NeedsPart (Flow.FedOnlyWithin web cap [()] (· ∈ [Part.first, .second]) 0 1)
      (fun L => Flow.DrawsPast [()] 0 1 (L, web)) (fun L => Flow.GivesWithin [()] 0 1 (L, web))
      .user .second :=
  Flow.needs_giver_of_short ⟨0, Nat.le_refl 0, Nat.one_pos, by decide⟩

/-- **The user does not need the first copy's giving**: the second can feed the condition alone. -/
theorem not_needs_first :
    ¬ NeedsPart (Flow.FedOnlyWithin web cap [()] (· ∈ [Part.first, .second]) 0 1)
      (fun L => Flow.DrawsPast [()] 0 1 (L, web)) (fun L => Flow.GivesWithin [()] 0 1 (L, web))
      .user .first :=
  fun needs => match second_alone_first_not.1 with
  | ⟨L, possible, draws, _, alone⟩ =>
    Part.noConfusion (alone .first (.head _) (needs L possible draws))

/-- What each copy can give at a step in the second reading: one unit each. -/
def capOne (_ : Nat) : Part → Nat
  | .user => 0
  | .first => 1
  | .second => 1

/-- The flow in which both copies give: at every step the user takes one unit of the condition and
each copy gives one. -/
def jointly : Flow Part Unit where
  present := fun _ => [.user, .first, .second]
  take := fun _ x _ => match x with
    | .user => 1
    | .first => 0
    | .second => 0
  give := fun _ x _ => match x with
    | .user => 0
    | .first => 1
    | .second => 1

/-- With one unit each, both copies giving feed the condition while the user draws past its
stock. -/
theorem jointly_feeds :
    Flow.FedOnlyWithin web capOne [()] (· ∈ [Part.first, .second]) 0 1 jointly ∧
      Flow.DrawsPast [()] 0 1 (jointly, web) .user :=
  ⟨⟨⟨fun _ _ _ _ _ => rfl, fun _ _ _ _ _ => trivial, fun _ g _ _ _ gives => match g, gives with
      | .user, gives => absurd gives (Nat.lt_irrefl 0)
      | .first, _ => .head _
      | .second, _ => .tail _ (.head _)⟩,
    fun _ _ _ => ⟨⟨Feeders.user_outside, (fun mem => match mem_cons_cases mem with
        | .inl same => Part.noConfusion same
        | .inr empty => nomatch empty), (fun empty => nomatch empty), trivial⟩,
      fun x _ => match x with
      | .user => Nat.le_refl _
      | .first => Nat.le_refl _
      | .second => Nat.le_refl _⟩⟩,
   ⟨Nat.one_pos, fun _ _ _ => ⟨trivial, .head _, Nat.one_pos⟩⟩⟩

/-- **Neither copy can feed the condition alone**: each gives one unit a step, short of the two
each step demands. -/
theorem neither_alone :
    ¬ web.CanFeedAlone capOne [()] 0 1 .first ∧ ¬ web.CanFeedAlone capOne [()] 0 1 .second :=
  ⟨fun can => Nat.not_succ_le_self 1 (Eq.subst (motive := fun d => d ≤ 1) (demand_two 0)
      (can 0 (Nat.le_refl 0) Nat.one_pos (calls 0)).2),
   fun can => Nat.not_succ_le_self 1 (Eq.subst (motive := fun d => d ≤ 1) (demand_two 0)
      (can 0 (Nat.le_refl 0) Nat.one_pos (calls 0)).2)⟩

/-- **The user needs both copies' giving**: what either gives alone falls short of the demand. Two
copies in number are not two in capacity. -/
theorem needs_both :
    NeedsPart (Flow.FedOnlyWithin web capOne [()] (· ∈ [Part.first, .second]) 0 1)
        (fun L => Flow.DrawsPast [()] 0 1 (L, web)) (fun L => Flow.GivesWithin [()] 0 1 (L, web))
        .user .first ∧
      NeedsPart (Flow.FedOnlyWithin web capOne [()] (· ∈ [Part.first, .second]) 0 1)
        (fun L => Flow.DrawsPast [()] 0 1 (L, web)) (fun L => Flow.GivesWithin [()] 0 1 (L, web))
        .user .second :=
  ⟨Flow.needs_giver_of_short ⟨0, Nat.le_refl 0, Nat.one_pos, by decide⟩,
   Flow.needs_giver_of_short ⟨0, Nat.le_refl 0, Nat.one_pos, by decide⟩⟩

end Capacities

namespace SharedCopies

/-- Formation `0` is the user and `1`, `2`, `3` three copies: one condition rising by one at
every step, every formation active. -/
def web : Web Nat Unit :=
  ⟨fun t _ => t, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 0, fun _ _ _ => True⟩

/-- What each can give at a step: the user nothing, each copy one unit. -/
def cap (_ : Nat) : Nat → Nat
  | 0 => 0
  | _ + 1 => 1

instance decActive : ∀ t x, Decidable (web.active t x) := fun _ _ => instDecidableTrue

/-- No formation can give more than one unit a step. -/
theorem cap_le_one (t x : Nat) : cap t x ≤ 1 :=
  match x with
  | 0 => Nat.zero_le 1
  | _ + 1 => Nat.le_refl 1

/-- The condition never falls. -/
theorem steady (t : Nat) : ¬ ∃ d, d ∈ [()] ∧ web.Falls t d :=
  fun ⟨_, _, falls⟩ => Nat.lt_irrefl t (Nat.lt_trans (Nat.lt_succ_self t) falls)

/-- Every step demands two units: one the condition rises, and one the user draws. -/
theorem demand_two (t : Nat) : web.demand [()] t = 2 := by
  show (excess (t + 1) t + 0) + (if ¬ ∃ d, d ∈ [()] ∧ web.Falls t d then 1 else 0) = 2
  rw [Capacities.excess_succ, if_pos (steady t)]

/-- Every step calls for giving. -/
theorem calls (t : Nat) : web.CallsForGiving [()] t :=
  .inl ⟨(), .head [], Nat.lt_succ_self t⟩

theorem distinct : Distinct [()] := ⟨(fun empty => nomatch empty), trivial⟩

/-- The copies are listed without repetition. -/
theorem apart : Distinct [1, 2, 3] :=
  ⟨(fun mem => match mem_cons_cases mem with
      | .inl same => absurd same (by decide)
      | .inr rest => match mem_cons_cases rest with
        | .inl same => absurd same (by decide)
        | .inr empty => nomatch empty),
   (fun mem => match mem_cons_cases mem with
      | .inl same => absurd same (by decide)
      | .inr empty => nomatch empty),
   (fun empty => nomatch empty), trivial⟩

/-- The user is no copy. -/
theorem user_outside : ¬ (0 : Nat) ∈ [1, 2, 3] :=
  fun mem => match mem_cons_cases mem with
  | .inl same => absurd same (by decide)
  | .inr rest => match mem_cons_cases rest with
    | .inl same => absurd same (by decide)
    | .inr rest' => match mem_cons_cases rest' with
      | .inl same => absurd same (by decide)
      | .inr empty => nomatch empty

/-- Without any one copy, the other two can give two units a step together. -/
theorem without_two {g : Nat} (member : g ∈ [1, 2, 3]) (t : Nat) :
    web.capacityWithout cap [1, 2, 3] g t = 2 :=
  match mem_cons_cases member with
  | .inl same => Eq.subst (motive := fun x => web.capacityWithout cap [1, 2, 3] x t = 2) same.symm rfl
  | .inr rest => match mem_cons_cases rest with
    | .inl same =>
      Eq.subst (motive := fun x => web.capacityWithout cap [1, 2, 3] x t = 2) same.symm rfl
    | .inr rest' => match mem_cons_cases rest' with
      | .inl same =>
        Eq.subst (motive := fun x => web.capacityWithout cap [1, 2, 3] x t = 2) same.symm rfl
      | .inr empty => nomatch empty

/-- **No copy can feed the condition alone**: each gives one unit a step, short of the two each
step demands. -/
theorem none_alone (g : Nat) : ¬ web.CanFeedAlone cap [()] 0 1 g :=
  fun can => Nat.not_succ_le_self 1 (Nat.le_trans (Nat.le_of_eq (demand_two 0).symm)
    (Nat.le_trans (can 0 (Nat.le_refl 0) Nat.one_pos (calls 0)).2 (cap_le_one 0 g)))

/-- The user needs some copy's giving. -/
theorem needs_some :
    NeedsSomePart (Flow.FedOnlyWithin web cap [()] (· ∈ [1, 2, 3]) 0 1)
      (fun L => Flow.DrawsPast [()] 0 1 (L, web)) (fun L => Flow.GivesWithin [()] 0 1 (L, web)) 0
      (· ∈ [1, 2, 3]) :=
  Flow.needsSome_within web cap [()] (· ∈ [1, 2, 3]) 0 1 0

/-- **The user needs no copy's giving**: without any one, the other two can give together the two
units each step demands. -/
theorem none_needed {g : Nat} (member : g ∈ [1, 2, 3]) :
    ¬ NeedsPart (Flow.FedOnlyWithin web cap [()] (· ∈ [1, 2, 3]) 0 1)
      (fun L => Flow.DrawsPast [()] 0 1 (L, web)) (fun L => Flow.GivesWithin [()] 0 1 (L, web))
      0 g :=
  fun needs => match (Flow.needs_giver_iff_short distinct (List.Mem.head []) apart user_outside
      (fun _ _ _ => trivial) Nat.one_pos).mp needs with
  | ⟨t, _, _, short⟩ => Nat.lt_irrefl 2 (Eq.subst (motive := fun d => 2 < d) (demand_two t)
      (Eq.subst (motive := fun w => w < web.demand [()] t) (without_two member t) short))

end SharedCopies

namespace TwoTiers

/-- A user, a feeder and its source. -/
inductive Part where
  | user
  | feeder
  | source

/-- The condition the user draws on, and the feeder's supply. -/
inductive Place where
  | drawn
  | supply

/-- Both conditions stand empty, and every formation is active. -/
def web : Web Part Place :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 0, fun _ _ _ => True⟩

/-- At every step the user takes one unit of what it draws on, the feeder gives it one and takes
one from its supply, and the source gives the supply one. -/
def chain : Flow Part Place where
  present := fun _ => [.user, .feeder, .source]
  take := fun _ x c => match x, c with
    | .user, .drawn => 1
    | .user, .supply => 0
    | .feeder, .drawn => 0
    | .feeder, .supply => 1
    | .source, .drawn => 0
    | .source, .supply => 0
  give := fun _ x c => match x, c with
    | .user, .drawn => 0
    | .user, .supply => 0
    | .feeder, .drawn => 1
    | .feeder, .supply => 0
    | .source, .drawn => 0
    | .source, .supply => 1

/-- What the user draws on is not the supply. -/
theorem drawn_not_supply : ¬ Place.drawn ∈ [Place.supply] :=
  fun mem => match mem_cons_cases mem with
  | .inl same => Place.noConfusion same
  | .inr empty => nomatch empty

/-- **The chain is a flow of the hierarchy fed at its top only by the source, in which the user
draws past what the hierarchy holds.** -/
theorem possible :
    Flow.FedThroughTiers web [.drawn] [[.supply]] (· = Part.source) 0 1 chain ∧
      Flow.DrawsPastTiers [.drawn] [[.supply]] 0 1 (chain, web) .user :=
  ⟨⟨fun _ _ _ => ⟨fun c _ => match c with
        | .drawn => rfl
        | .supply => rfl, fun c _ => match c with
        | .drawn => rfl
        | .supply => rfl⟩,
    fun _ _ _ _ _ => trivial,
    fun _ _ _ => ⟨fun x _ => match x with
        | .user => Nat.le_refl _
        | .feeder => Nat.le_refl _
        | .source => Nat.le_refl _, trivial⟩,
    fun _ g c inside _ gives => match g, c, inside, gives with
      | .user, .drawn, inside, _ => absurd inside drawn_not_supply
      | .user, .supply, _, gives => absurd gives (Nat.lt_irrefl 0)
      | .feeder, .drawn, inside, _ => absurd inside drawn_not_supply
      | .feeder, .supply, _, gives => absurd gives (Nat.lt_irrefl 0)
      | .source, .drawn, _, _ => rfl
      | .source, .supply, _, _ => rfl⟩,
   ⟨Nat.one_pos, fun _ _ _ => ⟨trivial, .head _, Nat.one_pos⟩⟩⟩

/-- **The user needs the source's giving to the feeder's supply**: drawing past what the
hierarchy holds needs giving into its top. -/
theorem needs_source :
    NeedsPart (Flow.FedThroughTiers web [.drawn] [[.supply]] (· = Part.source) 0 1)
      (fun L => Flow.DrawsPastTiers [.drawn] [[.supply]] 0 1 (L, web))
      (fun L => Flow.GivesWithin [.supply] 0 1 (L, web)) .user .source :=
  fun L fed draws =>
    match Flow.needsSome_tiers web [.drawn] [[.supply]] (· = Part.source) 0 1 .user L fed draws with
    | ⟨_, same, gives⟩ =>
      Eq.subst (motive := fun x => Flow.GivesWithin [Place.supply] 0 1 (L, web) x) same gives

end TwoTiers

namespace OwnStores

/-- Formation `0` is the user and `1`, `2` two feeders; condition `0` is what the user draws on
and condition `h` is feeder `h`'s store. What the user draws on stands empty; the first store
holds three and falls by one at each of steps 0, 1 and 2, the second holds one and falls at step 0
only. -/
def level (t c : Nat) : Nat :=
  match c with
  | 0 => 0
  | 1 => (match t with
    | 0 => 3
    | 1 => 2
    | 2 => 1
    | _ + 3 => 0)
  | 2 => (match t with
    | 0 => 1
    | _ + 1 => 0)
  | _ + 3 => 0

/-- The levels, every formation active. -/
def web : Web Nat Nat :=
  ⟨level, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 0, fun _ _ _ => True⟩

/-- Each feeder's store is the condition of its own number. -/
def store (h : Nat) : Nat := h

instance decActive : ∀ t x, Decidable (web.active t x) := fun _ _ => instDecidableTrue

theorem distinct : Distinct [(0 : Nat)] := ⟨(fun empty => nomatch empty), trivial⟩

/-- The feeders are listed without repetition. -/
theorem apart : Distinct [(1 : Nat), 2] :=
  ⟨(fun mem => match mem_cons_cases mem with
      | .inl same => absurd same (by decide)
      | .inr empty => nomatch empty), (fun empty => nomatch empty), trivial⟩

/-- The user is no feeder. -/
theorem user_outside : ¬ (0 : Nat) ∈ [1, 2] :=
  fun mem => match mem_cons_cases mem with
  | .inl same => absurd same (by decide)
  | .inr rest => match mem_cons_cases rest with
    | .inl same => absurd same (by decide)
    | .inr empty => nomatch empty

/-- Each feeder's store is its own. -/
theorem own : ∀ h h', h ∈ [(1 : Nat), 2] → h' ∈ [(1 : Nat), 2] → store h = store h' → h = h' :=
  fun _ _ _ _ same => same

/-- No store is what the user draws on. -/
theorem separate : ∀ h, h ∈ [(1 : Nat), 2] → ¬ store h ∈ [(0 : Nat)] :=
  fun _ member inZero => match mem_cons_cases inZero with
  | .inl same => user_outside (Eq.subst (motive := fun x => x ∈ [(1 : Nat), 2]) same member)
  | .inr empty => nomatch empty

/-- The first store does not rise within the first three steps. -/
theorem first_steady : ∀ t, t < 0 + 3 → ¬ web.Rises t (store 1)
  | 0, _ => (by decide : ¬ ((3 : Nat) < 2))
  | 1, _ => (by decide : ¬ ((2 : Nat) < 1))
  | 2, _ => (by decide : ¬ ((1 : Nat) < 0))
  | _ + 3, to => absurd to (Nat.not_lt_of_le (Nat.le_add_left 3 _))

/-- The second store does not rise within the first three steps. -/
theorem second_steady : ∀ t, t < 0 + 3 → ¬ web.Rises t (store 2)
  | 0, _ => (by decide : ¬ ((1 : Nat) < 0))
  | 1, _ => (by decide : ¬ ((0 : Nat) < 0))
  | 2, _ => (by decide : ¬ ((0 : Nat) < 0))
  | _ + 3, to => absurd to (Nat.not_lt_of_le (Nat.le_add_left 3 _))

/-- No store rises within the first three steps. -/
theorem steady : ∀ t, 0 ≤ t → t < 0 + 3 → ∀ h, h ∈ [(1 : Nat), 2] → ¬ web.Rises t (store h) :=
  fun t _ to _ member => match mem_cons_cases member with
  | .inl same => Eq.subst (motive := fun x => ¬ web.Rises t (store x)) same.symm (first_steady t to)
  | .inr rest => match mem_cons_cases rest with
    | .inl same =>
      Eq.subst (motive := fun x => ¬ web.Rises t (store x)) same.symm (second_steady t to)
    | .inr empty => nomatch empty

/-- After step 0 the second store falls no more. -/
theorem second_store_spent : ∀ t, 1 ≤ t → web.storeFall store t 2 = 0
  | 0, from_ => absurd from_ (by decide)
  | _ + 1, _ => rfl

/-- **After its store runs out, the second feeder gives the user's condition nothing.** -/
theorem second_spent {L : Flow Nat Nat} (fed : Flow.FedFromStores web store [0] [1, 2] 0 3 L)
    {t : Nat} (from_ : 1 ≤ t) (to : t < 0 + 3) (present : 2 ∈ L.present t) :
    total [0] (L.give t 2) = 0 :=
  Nat.eq_zero_of_le_zero (Nat.le_trans
    (((Flow.fedFromStores_within fed).2 t (Nat.zero_le t) to).2 2 present)
    (Nat.le_of_eq (second_store_spent t from_)))

/-- **The user needs the first feeder's giving**: at step 1 the second store is empty, so the
second feeder can give nothing. -/
theorem needs_first :
    NeedsPart (Flow.FedFromStores web store [0] [1, 2] 0 3)
      (fun L => Flow.DrawsPast [0] 0 3 (L, web)) (fun L => Flow.GivesWithin [0] 0 3 (L, web)) 0 1 :=
  (Flow.needs_giver_iff_store_short distinct (List.Mem.head []) apart user_outside
    (fun _ _ _ => trivial) (Nat.zero_lt_succ 2) own separate steady).mpr
    ⟨1, Nat.zero_le 1, (by decide), (by decide)⟩

/-- **The user does not need the second feeder's giving**: the first store falls by one at every
step of the stretch, enough for the demand of one. -/
theorem not_needs_second :
    ¬ NeedsPart (Flow.FedFromStores web store [0] [1, 2] 0 3)
      (fun L => Flow.DrawsPast [0] 0 3 (L, web)) (fun L => Flow.GivesWithin [0] 0 3 (L, web)) 0 2 :=
  fun needs => match (Flow.needs_giver_iff_store_short distinct (List.Mem.head []) apart
      user_outside (fun _ _ _ => trivial) (Nat.zero_lt_succ 2) own separate steady).mp needs with
  | ⟨t, _, to, short⟩ => match t, to, short with
    | 0, _, short => absurd short (by decide)
    | 1, _, short => absurd short (by decide)
    | 2, _, short => absurd short (by decide)
    | _ + 3, to, _ => absurd to (Nat.not_lt_of_le (Nat.le_add_left 3 _))

end OwnStores

namespace Capacities

open Copies (Part)

/-- The two copies are listed without repetition. -/
theorem copies_apart : Distinct [Part.first, .second] :=
  ⟨(fun mem => match mem_cons_cases mem with
      | .inl same => Part.noConfusion same
      | .inr empty => nomatch empty), (fun empty => nomatch empty), trivial⟩

/-- **The user needs the second copy's giving in degree one**: every flow in which the user draws
past the stock has the second copy give at least one unit, and some has it give exactly one; the
first copy is needed in degree zero. -/
theorem second_in_degree :
    (∀ L, Flow.FedOnlyWithin web cap [()] (· ∈ [Part.first, .second]) 0 1 L →
      Flow.DrawsPast [()] 0 1 (L, web) .user →
        1 ≤ total (steps 0 1) fun t => L.givenFrom [()] t .second) ∧
    (∃ L, Flow.FedOnlyWithin web cap [()] (· ∈ [Part.first, .second]) 0 1 L ∧
      Flow.DrawsPast [()] 0 1 (L, web) .user ∧ total (steps 0 1) (fun t => L.givenFrom [()] t .second) = 1) ∧
    total (steps 0 1) (web.shortfall cap [()] [Part.first, .second] .first) = 0 :=
  match Flow.least_giving (g := Part.second) distinct (List.Mem.head []) copies_apart
      Feeders.user_outside (.tail _ (.head _)) (fun _ _ _ => trivial) Nat.one_pos with
  | ⟨low, attain⟩ =>
    ⟨fun L fed draws => Nat.le_trans (by decide) (low L fed draws),
     match attain (fun t _ to => match t, to with
       | 0, _ => by decide
       | _ + 1, to => absurd to (Nat.not_lt_of_le (Nat.le_add_left 1 _))) with
     | ⟨L, fed, draws, exact⟩ => ⟨L, fed, draws, exact.trans (by decide)⟩,
     by decide⟩

end Capacities

namespace FeedersInTurn

open Copies (Part)

/-- Who gives at a step: the first copy at step `0`, the second after it. -/
def turn : Nat → Part
  | 0 => .first
  | _ + 1 => .second

/-- **Some flow read off the web lets the user draw past the stock**: the flow drawn across the
two steps with the copy active at each giving. The user's need of both copies is not vacuous. -/
theorem possible :
    Flow.FedOnlyOn web [()] (· ∈ [Part.first, .second]) 0 2
        (Flow.drawnAcross web [()] 0 2 .user turn) ∧
      Flow.DrawsPast [()] 0 2 (Flow.drawnAcross web [()] 0 2 .user turn, web) .user :=
  ⟨Flow.drawnAcross_fedOnlyOn
      (fun t => match t with
        | 0 => fun same => Part.noConfusion same
        | _ + 1 => fun same => Part.noConfusion same)
      (fun t _ to _ => match t, to with
        | 0, _ => rfl
        | 1, _ => rfl
        | _ + 2, to => absurd to (Nat.not_lt_of_le (Nat.le_add_left 2 _)))
      (fun t => match t with
        | 0 => .head _
        | _ + 1 => .tail _ (.head _)),
   Flow.drawnAcross_drawsPast (List.Mem.head []) (fun _ _ _ => rfl) (Nat.succ_pos 1)⟩

end FeedersInTurn

namespace OwnStores

/-- **The user needs the first feeder in degree two and the second in degree zero.** Every flow
from the stores in which the user draws past the stock has the first feeder give at least two
units across the stretch, the units the second's empty store cannot give at steps 1 and 2, and
some such flow has it give exactly two; the second's shortfalls total zero. -/
theorem first_in_degree :
    (∀ L, Flow.FedFromStores web store [0] [1, 2] 0 3 L → Flow.DrawsPast [0] 0 3 (L, web) 0 →
      2 ≤ total (steps 0 3) fun t => L.givenFrom [0] t 1) ∧
    (∃ L, Flow.FedFromStores web store [0] [1, 2] 0 3 L ∧ Flow.DrawsPast [0] 0 3 (L, web) 0 ∧
      total (steps 0 3) (fun t => L.givenFrom [0] t 1) = 2) ∧
    total (steps 0 3) (web.shortfall (web.storeFall store) [0] [1, 2] 2) = 0 :=
  match Flow.least_giving_from_stores (g := 1) distinct (List.Mem.head []) apart user_outside
      (.head _) (fun _ _ _ => trivial) (Nat.zero_lt_succ 2) own separate steady with
  | ⟨low, attain⟩ =>
    ⟨fun L fed draws => Nat.le_trans (by decide) (low L fed draws),
     match attain (fun t _ to => match t, to with
       | 0, _ => by decide
       | 1, _ => by decide
       | 2, _ => by decide
       | _ + 3, to => absurd to (Nat.not_lt_of_le (Nat.le_add_left 3 _))) with
     | ⟨L, fed, draws, exact⟩ => ⟨L, fed, draws, exact.trans (by decide)⟩,
     by decide⟩

end OwnStores

namespace Routing

/-- Formation `0` is the user, `1` and `2` the lower members, `3` and `4` the upper members;
condition `0` is what the user draws on and condition `h` is lower member `h`'s store. Every level
stands at zero. -/
def still : Web Nat Nat :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 0, fun _ _ _ => True⟩

/-- The second lower member's store rises from zero to one across step 0; every other level stands
at zero. -/
def risingLevel (t c : Nat) : Nat :=
  match c with
  | 0 => 0
  | 1 => 0
  | 2 => (match t with
    | 0 => 0
    | _ + 1 => 1)
  | _ + 3 => 0

/-- As `still`, with the second lower member's store rising across step 0. -/
def rising : Web Nat Nat :=
  ⟨risingLevel, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 0, fun _ _ _ => True⟩

/-- Each lower member's store is the condition of its own number. -/
def store (h : Nat) : Nat := h

/-- Each upper member can give one unit a step. -/
def cap (_ _ : Nat) : Nat := 1

instance decStill : ∀ t x, Decidable (still.active t x) := fun _ _ => instDecidableTrue

instance decRising : ∀ t x, Decidable (rising.active t x) := fun _ _ => instDecidableTrue

/-- A number is not in a list where it differs from the head and is not in the rest. -/
theorem absent {a b : Nat} {l : List Nat} (other : a ≠ b) (rest : ¬ a ∈ l) : ¬ a ∈ b :: l :=
  fun mem => match mem_cons_cases mem with
  | .inl same => other same
  | .inr later => rest later

/-- Nothing is in the empty list. -/
theorem absent_nil {a : Nat} : ¬ a ∈ ([] : List Nat) := fun empty => nomatch empty

/-- What holds of the head and of every member of the rest holds of every member. -/
theorem every {P : Nat → Prop} {b : Nat} {l : List Nat} (head : P b) (rest : ∀ h, h ∈ l → P h) :
    ∀ h, h ∈ b :: l → P h :=
  fun h mem => match mem_cons_cases mem with
  | .inl same => Eq.subst (motive := P) same.symm head
  | .inr later => rest h later

/-- Every member of the empty list. -/
theorem every_nil {P : Nat → Prop} : ∀ h, h ∈ ([] : List Nat) → P h := fun _ empty => nomatch empty

theorem distinct : Distinct [(0 : Nat)] := ⟨absent_nil, trivial⟩

theorem apart_one : Distinct [(1 : Nat)] := ⟨absent_nil, trivial⟩

theorem apart_two : Distinct [(1 : Nat), 2] := ⟨absent (by decide) absent_nil, absent_nil, trivial⟩

theorem apart_three : Distinct [(3 : Nat)] := ⟨absent_nil, trivial⟩

theorem apart_four : Distinct [(3 : Nat), 4] := ⟨absent (by decide) absent_nil, absent_nil, trivial⟩

/-- The tiers are apart. -/
theorem tiers : ∀ h, h ∈ [(1 : Nat), 2] → ¬ h ∈ [(3 : Nat), 4] :=
  every (absent (by decide) (absent (by decide) absent_nil))
    (every (absent (by decide) (absent (by decide) absent_nil)) every_nil)

/-- The tiers are apart, the upper tier one member. -/
theorem tiers_three : ∀ h, h ∈ [(1 : Nat), 2] → ¬ h ∈ [(3 : Nat)] :=
  every (absent (by decide) absent_nil) (every (absent (by decide) absent_nil) every_nil)

/-- The tiers are apart, each one member. -/
theorem tiers_one : ∀ h, h ∈ [(1 : Nat)] → ¬ h ∈ [(3 : Nat)] :=
  every (absent (by decide) absent_nil) every_nil

/-- Each lower member's store is its own. -/
theorem own {ks : List Nat} : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h' :=
  fun _ _ _ _ same => same

/-- No store is what the user draws on. -/
theorem separate : ∀ h, h ∈ [(1 : Nat), 2] → ¬ store h ∈ [(0 : Nat)] :=
  every (P := fun h => ¬ store h ∈ [(0 : Nat)]) (absent (by decide) absent_nil)
    (every (P := fun h => ¬ store h ∈ [(0 : Nat)]) (absent (by decide) absent_nil) every_nil)

/-- No store is what the user draws on, one lower member. -/
theorem separate_one : ∀ h, h ∈ [(1 : Nat)] → ¬ store h ∈ [(0 : Nat)] :=
  every (P := fun h => ¬ store h ∈ [(0 : Nat)]) (absent (by decide) absent_nil) every_nil

/-- **With one upper member, the user needs its giving**: the lower members' stores hold nothing,
so all the user draws comes from the top. -/
theorem top_needed :
    NeedsPart (Flow.FedThroughStores still store [0] [1, 2] [3] cap 0 1)
      (fun L => Flow.DrawsPast [0] 0 1 (L, still))
      (fun L => Flow.GivesInto [0] [1, 2] store 0 1 (L, still)) 0 3 :=
  (Flow.needs_iff_through_short distinct (.head []) apart_two apart_three tiers_three
    (absent (by decide) (absent (by decide) absent_nil)) (absent (by decide) absent_nil)
    (fun _ _ _ => trivial) (by decide) own separate).mpr
    ⟨0, Nat.le_refl 0, by decide, .inr (by decide)⟩

/-- The two-tier law for the still web over one step, the user drawing on condition `0`. -/
theorem still_law {ks js : List Nat} (apartK : Distinct ks) (apartJ : Distinct js)
    (tiersApart : ∀ h, h ∈ ks → ¬ h ∈ js) (outsideK : ¬ (0 : Nat) ∈ ks) (outsideJ : ¬ (0 : Nat) ∈ js)
    (separateK : ∀ h, h ∈ ks → ¬ store h ∈ [(0 : Nat)]) (e : Nat) :
    NeedsPart (Flow.FedThroughStores still store [0] ks js cap 0 1)
        (fun L => Flow.DrawsPast [0] 0 1 (L, still))
        (fun L => Flow.GivesInto [0] ks store 0 1 (L, still)) 0 e ↔
      ∃ t, 0 ≤ t ∧ t < 0 + 1 ∧ (still.capacityWithout cap js e t < still.storesRisen store ks t ∨
        still.othersThrough store cap ks js e t < still.demand [0] t) :=
  Flow.needs_iff_through_short distinct (.head []) apartK apartJ tiersApart outsideK outsideJ
    (fun _ _ _ => trivial) (by decide) own separateK

/-- **With two lower members, the user needs neither's giving**: either can route the upper
member's giving, though neither holds anything. -/
theorem router_not_needed :
    ¬ NeedsPart (Flow.FedThroughStores still store [0] [1, 2] [3] cap 0 1)
        (fun L => Flow.DrawsPast [0] 0 1 (L, still))
        (fun L => Flow.GivesInto [0] [1, 2] store 0 1 (L, still)) 0 1 ∧
      ¬ NeedsPart (Flow.FedThroughStores still store [0] [1, 2] [3] cap 0 1)
        (fun L => Flow.DrawsPast [0] 0 1 (L, still))
        (fun L => Flow.GivesInto [0] [1, 2] store 0 1 (L, still)) 0 2 :=
  ⟨fun needs => match (still_law apart_two apart_three tiers_three
      (absent (by decide) (absent (by decide) absent_nil)) (absent (by decide) absent_nil)
      separate 1).mp needs with
    | ⟨0, _, _, short⟩ => absurd short (by decide)
    | ⟨_ + 1, _, to, _⟩ => absurd to (Nat.not_lt_of_le (Nat.le_add_left 1 _)),
   fun needs => match (still_law apart_two apart_three tiers_three
      (absent (by decide) (absent (by decide) absent_nil)) (absent (by decide) absent_nil)
      separate 2).mp needs with
    | ⟨0, _, _, short⟩ => absurd short (by decide)
    | ⟨_ + 1, _, to, _⟩ => absurd to (Nat.not_lt_of_le (Nat.le_add_left 1 _))⟩

/-- **With one lower member, the user needs its giving**, though its store holds nothing: all the
upper member gives must pass through it. -/
theorem lone_router_needed :
    NeedsPart (Flow.FedThroughStores still store [0] [1] [3] cap 0 1)
      (fun L => Flow.DrawsPast [0] 0 1 (L, still))
      (fun L => Flow.GivesInto [0] [1] store 0 1 (L, still)) 0 1 :=
  (Flow.needs_iff_through_short distinct (.head []) apart_one apart_three tiers_one
    (absent (by decide) absent_nil) (absent (by decide) absent_nil) (fun _ _ _ => trivial)
    (by decide) own separate_one).mpr
    ⟨0, Nat.le_refl 0, by decide, .inr (by decide)⟩

/-- **With two upper members and no store rising, the user needs neither's giving**: either can
give the one unit drawn. -/
theorem tops_not_needed :
    ¬ NeedsPart (Flow.FedThroughStores still store [0] [1, 2] [3, 4] cap 0 1)
        (fun L => Flow.DrawsPast [0] 0 1 (L, still))
        (fun L => Flow.GivesInto [0] [1, 2] store 0 1 (L, still)) 0 3 ∧
      ¬ NeedsPart (Flow.FedThroughStores still store [0] [1, 2] [3, 4] cap 0 1)
        (fun L => Flow.DrawsPast [0] 0 1 (L, still))
        (fun L => Flow.GivesInto [0] [1, 2] store 0 1 (L, still)) 0 4 :=
  ⟨fun needs => match (still_law apart_two apart_four tiers
      (absent (by decide) (absent (by decide) absent_nil))
      (absent (by decide) (absent (by decide) absent_nil)) separate 3).mp needs with
    | ⟨0, _, _, short⟩ => absurd short (by decide)
    | ⟨_ + 1, _, to, _⟩ => absurd to (Nat.not_lt_of_le (Nat.le_add_left 1 _)),
   fun needs => match (still_law apart_two apart_four tiers
      (absent (by decide) (absent (by decide) absent_nil))
      (absent (by decide) (absent (by decide) absent_nil)) separate 4).mp needs with
    | ⟨0, _, _, short⟩ => absurd short (by decide)
    | ⟨_ + 1, _, to, _⟩ => absurd to (Nat.not_lt_of_le (Nat.le_add_left 1 _))⟩

/-- **Where a lower store rises, the user needs each upper member's giving**: what the other upper
member can give goes to the rising store, and nothing is left to route to the user. -/
theorem rise_needs_top :
    NeedsPart (Flow.FedThroughStores rising store [0] [1, 2] [3, 4] cap 0 1)
        (fun L => Flow.DrawsPast [0] 0 1 (L, rising))
        (fun L => Flow.GivesInto [0] [1, 2] store 0 1 (L, rising)) 0 3 ∧
      NeedsPart (Flow.FedThroughStores rising store [0] [1, 2] [3, 4] cap 0 1)
        (fun L => Flow.DrawsPast [0] 0 1 (L, rising))
        (fun L => Flow.GivesInto [0] [1, 2] store 0 1 (L, rising)) 0 4 :=
  ⟨(Flow.needs_iff_through_short distinct (.head []) apart_two apart_four tiers
      (absent (by decide) (absent (by decide) absent_nil))
      (absent (by decide) (absent (by decide) absent_nil)) (fun _ _ _ => trivial) (by decide) own
      separate).mpr ⟨0, Nat.le_refl 0, by decide, .inr (by decide)⟩,
   (Flow.needs_iff_through_short distinct (.head []) apart_two apart_four tiers
      (absent (by decide) (absent (by decide) absent_nil))
      (absent (by decide) (absent (by decide) absent_nil)) (fun _ _ _ => trivial) (by decide) own
      separate).mpr ⟨0, Nat.le_refl 0, by decide, .inr (by decide)⟩⟩

/-- The first lower member's store falls from one to zero across step 0 and the second's rises from
zero to one; what the user draws on stands at zero. -/
def fillingLevel (t c : Nat) : Nat :=
  match c with
  | 0 => 0
  | 1 => (match t with
    | 0 => 1
    | _ + 1 => 0)
  | 2 => (match t with
    | 0 => 0
    | _ + 1 => 1)
  | _ + 3 => 0

/-- As `still`, with the first lower store falling and the second rising across step 0. -/
def filling : Web Nat Nat :=
  ⟨fillingLevel, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 0, fun _ _ _ => True⟩

instance decFilling : ∀ t x, Decidable (filling.active t x) := fun _ _ => instDecidableTrue

/-- **Where a store rises that only one upper member can give, the user needs that member's giving,
though the others could feed it through the hierarchy**: the first store's fall gives the unit the
user draws, but every flow of this web gives the second store its rise, and only the upper member
can. -/
theorem fill_needs_top :
    NeedsPart (Flow.FedThroughStores filling store [0] [1, 2] [3] cap 0 1)
        (fun L => Flow.DrawsPast [0] 0 1 (L, filling))
        (fun L => Flow.GivesInto [0] [1, 2] store 0 1 (L, filling)) 0 3 ∧
      filling.demand [0] 0 ≤ filling.othersThrough store cap [1, 2] [3] 3 0 :=
  ⟨(Flow.needs_iff_through_short distinct (.head []) apart_two apart_three tiers_three
      (absent (by decide) (absent (by decide) absent_nil)) (absent (by decide) absent_nil)
      (fun _ _ _ => trivial) (by decide) own separate).mpr
      ⟨0, Nat.le_refl 0, by decide, .inl (by decide)⟩,
   by decide⟩

/-- **In each setting where a need is read above, some flow lets the user draw past the stock**: the
routed flow with a formation outside both tiers left out (formation `9`) is a flow of the hierarchy
in which the user draws past its stock, with one lower member and one upper member, with a lower
store rising and two upper members, and with one lower store falling and the other rising. So
`lone_router_needed`, `rise_needs_top` and `fill_needs_top` are not vacuous. -/
theorem possible :
    (∃ L, Flow.FedThroughStores still store [0] [1] [3] cap 0 1 L ∧
      Flow.DrawsPast [0] 0 1 (L, still) 0) ∧
    (∃ L, Flow.FedThroughStores rising store [0] [1, 2] [3, 4] cap 0 1 L ∧
      Flow.DrawsPast [0] 0 1 (L, rising) 0) ∧
    (∃ L, Flow.FedThroughStores filling store [0] [1, 2] [3] cap 0 1 L ∧
      Flow.DrawsPast [0] 0 1 (L, filling) 0) :=
  ⟨⟨_, Flow.routedDrawn_fedThroughStores (c₀ := 0) (f := 0) (e := 9) distinct (.head []) apart_one
      apart_three (absent (by decide) absent_nil) (absent (by decide) absent_nil) tiers_one own
      separate_one
      (fun t _ to => match t, to with
        | 0, _ => by decide
        | _ + 1, to => absurd to (Nat.not_lt_of_le (Nat.le_add_left 1 _)))
      (fun t _ to => match t, to with
        | 0, _ => by decide
        | _ + 1, to => absurd to (Nat.not_lt_of_le (Nat.le_add_left 1 _))),
    Flow.routedDrawn_drawsPast (.head []) (fun _ _ _ => trivial) (by decide)⟩,
   ⟨_, Flow.routedDrawn_fedThroughStores (c₀ := 0) (f := 0) (e := 9) distinct (.head []) apart_two
      apart_four (absent (by decide) (absent (by decide) absent_nil))
      (absent (by decide) (absent (by decide) absent_nil)) tiers own separate
      (fun t _ to => match t, to with
        | 0, _ => by decide
        | _ + 1, to => absurd to (Nat.not_lt_of_le (Nat.le_add_left 1 _)))
      (fun t _ to => match t, to with
        | 0, _ => by decide
        | _ + 1, to => absurd to (Nat.not_lt_of_le (Nat.le_add_left 1 _))),
    Flow.routedDrawn_drawsPast (.head []) (fun _ _ _ => trivial) (by decide)⟩,
   ⟨_, Flow.routedDrawn_fedThroughStores (c₀ := 0) (f := 0) (e := 9) distinct (.head []) apart_two
      apart_three (absent (by decide) (absent (by decide) absent_nil))
      (absent (by decide) absent_nil) tiers_three own separate
      (fun t _ to => match t, to with
        | 0, _ => by decide
        | _ + 1, to => absurd to (Nat.not_lt_of_le (Nat.le_add_left 1 _)))
      (fun t _ to => match t, to with
        | 0, _ => by decide
        | _ + 1, to => absurd to (Nat.not_lt_of_le (Nat.le_add_left 1 _))),
    Flow.routedDrawn_drawsPast (.head []) (fun _ _ _ => trivial) (by decide)⟩⟩

end Routing

namespace Overlapping

/-- Condition `0`, what formation `0` draws on, holds one unit at step 0 and none after; every
other level stands at zero. -/
def level (t c : Nat) : Nat :=
  match c with
  | 0 => (match t with
    | 0 => 1
    | _ + 1 => 0)
  | _ + 1 => 0

/-- Three formations overlapping in turn: formation `0` is active at steps 0 and 1, formation `1`
at steps 1 and 2, formation `2` at steps 2 and 3. -/
def active (t x : Nat) : Prop :=
  match x with
  | 0 => t ≤ 1
  | 1 => 1 ≤ t ∧ t ≤ 2
  | 2 => 2 ≤ t ∧ t ≤ 3
  | _ + 3 => False

/-- Formation `0` requires condition `0` and formation `1` condition `1`. -/
def web : Web Nat Nat :=
  ⟨level, active, fun _ x c => x = c ∧ x ≤ 1, fun _ _ _ => 0, fun _ _ _ => True⟩

/-- Formation `0` takes one unit of condition `0` at steps 0 and 1. -/
def take (t x c : Nat) : Nat :=
  match x with
  | 0 => (match c with
    | 0 => (match t with
      | 0 => 1
      | 1 => 1
      | _ + 2 => 0)
    | _ + 1 => 0)
  | _ + 1 => 0

/-- Formation `1` gives condition `0` one unit at step 1; formation `2` gives condition `1` one unit
at step 2. -/
def give (t x c : Nat) : Nat :=
  match x with
  | 0 => 0
  | 1 => (match c with
    | 0 => (match t with
      | 0 => 0
      | 1 => 1
      | _ + 2 => 0)
    | _ + 1 => 0)
  | 2 => (match c with
    | 0 => 0
    | 1 => (match t with
      | 0 => 0
      | 1 => 0
      | 2 => 1
      | _ + 3 => 0)
    | _ + 2 => 0)
  | _ + 3 => 0

/-- The three formations take part at every step. -/
def flow : Flow Nat Nat :=
  ⟨fun _ => [0, 1, 2], take, give⟩

/-- Where something is given, it is the middle formation's unit at step 1 or the last formation's
at step 2. -/
theorem give_pos {t x c : Nat} (pos : 0 < flow.give t x c) :
    (x = 1 ∧ c = 0 ∧ t = 1) ∨ (x = 2 ∧ c = 1 ∧ t = 2) :=
  match x, c, t, pos with
  | 0, _, _, pos => absurd pos (Nat.lt_irrefl 0)
  | 1, 0, 0, pos => absurd pos (Nat.lt_irrefl 0)
  | 1, 0, 1, _ => .inl ⟨rfl, rfl, rfl⟩
  | 1, 0, _ + 2, pos => absurd pos (Nat.lt_irrefl 0)
  | 1, _ + 1, _, pos => absurd pos (Nat.lt_irrefl 0)
  | 2, 0, _, pos => absurd pos (Nat.lt_irrefl 0)
  | 2, 1, 0, pos => absurd pos (Nat.lt_irrefl 0)
  | 2, 1, 1, pos => absurd pos (Nat.lt_irrefl 0)
  | 2, 1, 2, _ => .inr ⟨rfl, rfl, rfl⟩
  | 2, 1, _ + 3, pos => absurd pos (Nat.lt_irrefl 0)
  | 2, _ + 2, _, pos => absurd pos (Nat.lt_irrefl 0)
  | _ + 3, _, _, pos => absurd pos (Nat.lt_irrefl 0)

/-- Only active formations give. -/
theorem acting : flow.Acting web :=
  fun t x _ _ pos => match give_pos pos with
  | .inl ⟨sx, _, st⟩ => Eq.subst (motive := fun y => web.active t y) sx.symm
      (Eq.subst (motive := fun s => web.active s 1) st.symm
        (show (1 : Nat) ≤ 1 ∧ (1 : Nat) ≤ 2 from ⟨Nat.le_refl 1, by decide⟩))
  | .inr ⟨sx, _, st⟩ => Eq.subst (motive := fun y => web.active t y) sx.symm
      (Eq.subst (motive := fun s => web.active s 2) st.symm
        (show (2 : Nat) ≤ 2 ∧ (2 : Nat) ≤ 3 from ⟨Nat.le_refl 2, by decide⟩))

/-- The flow of the first formation's drawing: across steps 0 and 1 it balances on condition `0`,
only active formations give, and only the later two give to condition `0`. -/
theorem fed : Flow.FedOnlyOn web [0] (· ∈ [1, 2]) 0 2 flow :=
  ⟨fun t _ to c mem => match t, to, mem_cons_cases mem with
    | 0, _, .inl same => Eq.subst (motive := fun c => web.level 1 c + flow.taken 0 c =
          web.level 0 c + flow.given 0 c) same.symm (by decide)
    | 1, _, .inl same => Eq.subst (motive := fun c => web.level 2 c + flow.taken 1 c =
          web.level 1 c + flow.given 1 c) same.symm (by decide)
    | _ + 2, to, _ => absurd to (Nat.not_lt_of_le (Nat.le_add_left 2 _))
    | _, _, .inr empty => (nomatch empty),
   acting,
   fun _ g _ _ _ pos => match give_pos pos with
    | .inl ⟨sx, _, _⟩ => Eq.subst (motive := fun y => y ∈ [1, 2]) sx.symm (List.Mem.head _)
    | .inr ⟨sx, _, _⟩ => Eq.subst (motive := fun y => y ∈ [1, 2]) sx.symm
        (List.Mem.tail _ (List.Mem.head _))⟩

/-- The first formation draws past its condition's stock across steps 0 and 1. -/
theorem draws : Flow.DrawsPast [0] 0 2 (flow, web) 0 :=
  ⟨by decide, fun t _ to => match t, to with
    | 0, _ => ⟨Nat.zero_le 1, List.Mem.head _, by decide⟩
    | 1, _ => ⟨Nat.le_refl 1, List.Mem.head _, by decide⟩
    | _ + 2, to => absurd to (Nat.not_lt_of_le (Nat.le_add_left 2 _))⟩

/-- The middle formation feeds the first's continuation at step 1. -/
theorem fed_first : flow.FedBy web (0, 1) (1, 1) :=
  ⟨rfl, 0, ⟨rfl, by decide⟩, List.Mem.tail _ (List.Mem.head _), by decide⟩

/-- The last formation feeds the middle one's continuation at step 2. -/
theorem fed_middle : flow.FedBy web (1, 2) (2, 2) :=
  ⟨rfl, 1, ⟨rfl, by decide⟩, List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)), by decide⟩

/-- Formation `2` gives nothing at steps 0 and 1. -/
theorem last_quiet : ∀ s c, s ≤ 1 → flow.give s 2 c = 0
  | 0, 0, _ => rfl
  | 0, 1, _ => rfl
  | 0, _ + 2, _ => rfl
  | 1, 0, _ => rfl
  | 1, 1, _ => rfl
  | 1, _ + 2, _ => rfl
  | _ + 2, _, le => absurd le (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (by decide : 1 < 2)
      (Nat.le_add_left 2 _)))

/-- **Read across every step, the feeding closure runs forward past the end of what it carries; read
with time, it does not, and need does not reach past that end.** The last formation lies within the
first's feeding closure, since it feeds the middle one after the first has ended, but not within the
first's feeding closure read with time up to its last step, which holds the middle one; and the
first, drawing past its condition's stock across its two steps, does not need the last's giving. -/
theorem closure_overreaches :
    flow.WithinFeeding web 0 2 ∧ ¬ flow.WithinFeedingUpTo web 0 1 2 ∧
      flow.WithinFeedingUpTo web 0 1 1 ∧
      ¬ NeedsPart (Flow.FedOnlyOn web [0] (· ∈ [1, 2]) 0 2) (fun L => Flow.DrawsPast [0] 0 2 (L, web))
        (fun L => Flow.GivesWithin [0] 0 2 (L, web)) 0 2 :=
  ⟨(Flow.WithinFeeding.of_fedBy fed_first).trans (Flow.WithinFeeding.of_fedBy fed_middle),
   fun within => match Flow.gives_of_withinFeedingUpTo within with
    | .inl same => absurd same (by decide)
    | .inr ⟨s, by_, _, c, gives⟩ =>
      absurd (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (last_quiet s c by_))) (Nat.lt_irrefl 0),
   ⟨1, WithinClosure.of_rel ⟨Nat.le_refl 1, fed_first⟩⟩,
   fun needs => (Flow.needs_iff_none_of_inactive (fun _ on => on.2.1)
      (fun t _ to => match t, to with
        | 0, _ => fun active => absurd active.1 (by decide)
        | 1, _ => fun active => absurd active.1 (by decide)
        | _ + 2, to => absurd to (Nat.not_lt_of_le (Nat.le_add_left 2 _)))).mp needs
      ⟨flow, fed, draws⟩⟩

end Overlapping

/-! ## What self-concern alone ranks -/

namespace Weighting

variable {X : Type}

/-- `a` adds to what `own` marks beyond `b`: it admits a listed item `own` marks that `b` does
not. -/
def AddsOwn (items : List X) (own : X → Bool) (a b : X → Bool) : Prop :=
  ∃ x, x ∈ items ∧ own x = true ∧ a x = true ∧ b x = false

/-- An order is increasing in its own continuation, the items `own` marks, when it ranks above
what it widens every widening that adds to them. `R b a` reads "`a` is ranked above `b`". -/
def IncreasingInOwn (items : List X) (own : X → Bool)
    (R : (X → Bool) → (X → Bool) → Prop) : Prop :=
  ∀ a b, WidensOn items a b → AddsOwn items own a b → R b a

/-- An order increasing in admission is increasing in its own continuation. -/
theorem increasingInOwn_of_increasing {items : List X} {own : X → Bool}
    {R : (X → Bool) → (X → Bool) → Prop} (increasing : Increasing items R) :
    IncreasingInOwn items own R :=
  fun a b widens _ => increasing a b widens

/-- An order is *increasing in its own continuation on the pairs `met` relates*: wherever `met` relates
`a` to `b` and `a` widens `b` adding to what `own` marks, it ranks `a` above `b`. `R b a` reads "`a` is
ranked above `b`", as in `IncreasingInOwn`. -/
def IncreasingInOwnOn (met : (X → Bool) → (X → Bool) → Prop) (items : List X) (own : X → Bool)
    (R : (X → Bool) → (X → Bool) → Prop) : Prop :=
  ∀ a b, met a b → WidensOn items a b → AddsOwn items own a b → R b a

/-- An order increasing in its own continuation is so on any pairs. -/
theorem increasingInOwnOn_of_increasingInOwn {met : (X → Bool) → (X → Bool) → Prop} {items : List X}
    {own : X → Bool} {R : (X → Bool) → (X → Bool) → Prop} (increasing : IncreasingInOwn items own R) :
    IncreasingInOwnOn met items own R :=
  fun a b _ => increasing a b

/-- On every pair, it is being increasing in its own continuation. -/
theorem increasingInOwnOn_every_iff {items : List X} {own : X → Bool}
    {R : (X → Bool) → (X → Bool) → Prop} :
    IncreasingInOwnOn (fun _ _ => True) items own R ↔ IncreasingInOwn items own R :=
  ⟨fun on a b => on a b trivial, increasingInOwnOn_of_increasingInOwn⟩

/-- **Drawn as everything listed, the self's monotonicity is C's premise.** Where `own` marks
every listed item, an order is increasing in its own continuation exactly when it is increasing
in admission. -/
theorem increasingInOwn_iff_increasing {items : List X} {own : X → Bool}
    {R : (X → Bool) → (X → Bool) → Prop} (all : ∀ x, x ∈ items → own x = true) :
    IncreasingInOwn items own R ↔ Increasing items R :=
  ⟨fun increasing a b widens => match widens.2 with
    | ⟨x, listed, admits, not⟩ => increasing a b widens ⟨x, listed, all x listed, admits, not⟩,
   increasingInOwn_of_increasing⟩

/-- **What every order increasing in its own continuation shares.** Every such order ranks `a`
above `b` exactly when `a` widens `b` and adds to its own continuation. -/
theorem widensOwn_iff_every_increasingInOwn {items : List X} {own : X → Bool}
    {a b : X → Bool} :
    WidensOn items a b ∧ AddsOwn items own a b ↔ ∀ R, IncreasingInOwn items own R → R b a :=
  ⟨fun ⟨widens, adds⟩ _ increasing => increasing a b widens adds,
   fun every => every (fun b a => WidensOn items a b ∧ AddsOwn items own a b)
     fun _ _ widens adds => ⟨widens, adds⟩⟩

/-- **Self-concern alone ranks a course above another exactly where the other keeps nothing
beyond it.** Where `a` adds to its own continuation beyond `b`, every order increasing in its own
continuation ranks `a` above `b` exactly when `b` admits no listed item `a` does not. -/
theorem every_increasingInOwn_iff_includes {items : List X} {own : X → Bool} {a b : X → Bool}
    (adds : AddsOwn items own a b) :
    (∀ R, IncreasingInOwn items own R → R b a) ↔ IncludesOn items a b :=
  ⟨fun every => (widensOwn_iff_every_increasingInOwn.mpr every).1.1,
   fun includes _ increasing => match adds with
    | ⟨x, listed, _, admits, not⟩ => increasing a b ⟨includes, x, listed, admits, not⟩ adds⟩

/-- **Where the other course keeps an item beyond, some such order ranks it higher.** Where `b`
admits a listed item `a` does not, some positive weighting, an order increasing in admission and
so in its own continuation, ranks `b` above `a` and not `a` above `b`, whatever `a` adds to its
own continuation. -/
theorem some_increasingInOwn_reverses {items : List X} {own : X → Bool} {a b : X → Bool}
    (beyond : ExceedsOn items b a) :
    ∃ R, IncreasingInOwn items own R ∧ R a b ∧ ¬ R b a :=
  match outweighs beyond with
  | ⟨w, positive, lt⟩ =>
    ⟨ranks items w, increasingInOwn_of_increasing (increasing_ranks positive), lt,
     Nat.lt_asymm lt⟩

/-- A course that admits no item marked `late`, and with which `a` agrees on every other item, is
included in `a`. -/
theorem includes_of_ended {items : List X} {late : X → Bool} {a b : X → Bool}
    (ended : ∀ x, x ∈ items → late x = true → b x = false)
    (agree : ∀ x, x ∈ items → late x = false → a x = b x) : IncludesOn items a b :=
  fun x listed admits => match h : late x with
    | true => Bool.noConfusion ((ended x listed h).symm.trans admits)
    | false => (agree x listed h).trans admits

/-- **The ending of what everything needs is ranked below from every standpoint.** Let `b` admit
no item marked `late` (from its ending on, nothing that needs the ended condition continues) and
let `a` agree with `b` on every other item. Then from every standpoint whose own continuation `a`
adds to beyond `b`, every order increasing in its own continuation ranks `a` above `b`. -/
theorem ended_below {items : List X} {own : Pos → X → Bool} {late : X → Bool} {a b : X → Bool}
    (ended : ∀ x, x ∈ items → late x = true → b x = false)
    (agree : ∀ x, x ∈ items → late x = false → a x = b x) (p : Pos)
    (adds : AddsOwn items (own p) a b) :
    ∀ R, IncreasingInOwn items (own p) R → R b a :=
  (every_increasingInOwn_iff_includes adds).mpr (includes_of_ended ended agree)

end Weighting

/-- **The coupled ending, ranked below by self-concern, in one theorem.** Under balance, with only
active formations giving, activity needing support and the renewal of a family of conditions gated
on the family as one, let the family's uptake exceed its replenishment over `n` steps from `T`,
from a stock below `n + m`, and let every member of every generation of descent from `T + n` on
depend on some condition of the family at a need of at least `m`. Then no generation after `T + n`
has a member; so a course over listed (step, formation) items admitting only members of their
generation is ranked below, by every order increasing in a standpoint's own continuation, every
course that agrees with it up to `T + n` and adds to that standpoint's continuation. -/
theorem Flow.coupled_ending_ranked_below {X : Type} {L : Flow X X} {W : Web X X}
    (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {G : SelectionTerm.Generations X} (descended : SelectionTerm.Flow.Descended L W G)
    {ds : List X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m)
    (coupled : ∀ k p, p ∈ G.family (T + n + k) →
      ∃ e, e ∈ ds ∧ W.requires (T + n + k) p e ∧ m ≤ W.need (T + n + k) p e)
    {items : List (Nat × X)} {a b : Nat × X → Bool}
    (reads : ∀ x, x ∈ items → b x = true → x.2 ∈ G.family x.1)
    (agree : ∀ x, x ∈ items → x.1 ≤ T + n → a x = b x)
    {own : Pos → Nat × X → Bool} (p : Pos) (adds : Weighting.AddsOwn items (own p) a b) :
    ∀ R, Weighting.IncreasingInOwn items (own p) R → R b a :=
  have ended : ∀ k y, ¬ y ∈ G.family (T + n + k + 1) := fun k =>
    GroupEnding.Flow.coupled_generation_childless balances acting dependent descended gated excess
      start k (coupled k)
  (Weighting.every_increasingInOwn_iff_includes adds).mpr fun x listed admits =>
    match Nat.lt_or_ge (T + n) x.1 with
    | .inl after => match Nat.le.dest after with
      | ⟨k, at_⟩ => absurd (Eq.subst (motive := fun s => x.2 ∈ G.family s)
          ((Nat.add_right_comm (T + n) 1 k).symm.trans at_).symm (reads x listed admits))
          (ended k x.2)
    | .inr before => (agree x listed before).trans admits

/-! ## Grades: standing and status -/

namespace Weighting

variable {X : Type}

/-- A graded significance is invariant when every standpoint gives every item the same grade. -/
def GradeInvariant (grade : Pos → X → Nat) : Prop :=
  ∀ p q x, grade p x = grade q x

/-- Its standing is invariant when an item counts at all from one standpoint exactly when it does
from another: the two-valued significance of a grade, standpoint-invariant. -/
def StandingInvariant (grade : Pos → X → Nat) : Prop :=
  ∀ p q x, 0 < grade p x → 0 < grade q x

/-- Invariant grades have invariant standing. -/
theorem standingInvariant_of_gradeInvariant {grade : Pos → X → Nat}
    (invariant : GradeInvariant grade) : StandingInvariant grade :=
  fun p q x positive => Eq.subst (motive := fun n => 0 < n) (invariant p q x) positive

/-- **Invariant grades rank alike from every standpoint.** -/
theorem weighed_eq_of_gradeInvariant {grade : Pos → X → Nat} (invariant : GradeInvariant grade)
    (items : List X) (a : X → Bool) (p q : Pos) :
    weighed items (grade p) a = weighed items (grade q) a :=
  total_congr (fun x => congrArg (fun n => cond (a x) n 0) (invariant p q x)) items

theorem ranks_alike_of_gradeInvariant {grade : Pos → X → Nat} (invariant : GradeInvariant grade)
    (items : List X) (a b : X → Bool) (p q : Pos) :
    weighed items (grade p) b < weighed items (grade p) a ↔
      weighed items (grade q) b < weighed items (grade q) a :=
  Eq.subst (motive := fun n => weighed items (grade p) b < weighed items (grade p) a ↔
      n < weighed items (grade q) a) (weighed_eq_of_gradeInvariant invariant items b p q)
    (Eq.subst (motive := fun n => weighed items (grade p) b < weighed items (grade p) a ↔
      weighed items (grade p) b < n) (weighed_eq_of_gradeInvariant invariant items a p q) Iff.rfl)

/-! ### Levels of continuation, priority and sufficiency -/

/-- A formation's level in a course: how many of its listed items (`of`) the course admits, the
steps at which its continuation is admitted. -/
def level (items : List X) (of : X → Bool) (a : X → Bool) : Nat :=
  weighed items (fun x => cond (of x) 1 0) a

/-- Inclusion never lowers a level. -/
theorem level_le_of_includes {items : List X} {a b : X → Bool} (of : X → Bool)
    (includes : IncludesOn items a b) : level items of b ≤ level items of a :=
  weighed_le_of_includes _ includes

/-- A course including another and admitting one more item of a formation raises its level. -/
theorem level_lt_of_includes_at {items : List X} {a b : X → Bool} {of : X → Bool}
    (includes : IncludesOn items a b) {x : X} (listed : x ∈ items) (admits : a x = true)
    (not : b x = false) (own : of x = true) : level items of b < level items of a :=
  total_lt (fun y member => term_le (includes y member))
    ⟨x, listed, term_lt (cond_one_pos own) admits not⟩

/-- The sum over listed formations of a transform of their levels: utilitarian for the identity,
prioritarian for a strictly increasing, strictly concave transform. -/
def prior (gs : List F) (owner : F → X → Bool) (items : List X) (f : Nat → Nat) (a : X → Bool) :
    Nat :=
  total gs fun g => f (level items (owner g) a)

theorem le_of_strict {f : Nat → Nat} (increasing : ∀ m n, m < n → f m < f n) {m n : Nat}
    (le : m ≤ n) : f m ≤ f n :=
  match Nat.eq_or_lt_of_le le with
  | .inl same => Nat.le_of_eq (congrArg f same)
  | .inr less => Nat.le_of_lt (increasing m n less)

/-- **Every strictly increasing transform of levels ranks a widening higher**, where every
listed item belongs to some listed formation. Priority to the worse off, and the utilitarian
sum, agree with C wherever C ranks. -/
theorem prior_lt_of_widens {gs : List F} {owner : F → X → Bool} {items : List X} {f : Nat → Nat}
    (increasing : ∀ m n, m < n → f m < f n) (covers : ∀ x, x ∈ items → ∃ g, g ∈ gs ∧ owner g x = true)
    {a b : X → Bool} (widens : WidensOn items a b) :
    prior gs owner items f b < prior gs owner items f a :=
  match widens.2 with
  | ⟨x, listed, admits, not⟩ => match covers x listed with
    | ⟨g, member, own⟩ =>
      total_lt (fun h _ => le_of_strict increasing (level_le_of_includes (owner h) widens.1))
        ⟨g, member, increasing _ _ (level_lt_of_includes_at widens.1 listed admits not own)⟩

/-- **Priority to the worse off is increasing in admission**, so a class holding the positive
weightings and the prioritarian orders shares exactly widening (`widens_iff_every_of_class`). -/
theorem increasing_prior {gs : List F} {owner : F → X → Bool} {items : List X} {f : Nat → Nat}
    (increasing : ∀ m n, m < n → f m < f n)
    (covers : ∀ x, x ∈ items → ∃ g, g ∈ gs ∧ owner g x = true) :
    Increasing items (fun b a => prior gs owner items f b < prior gs owner items f a) :=
  fun _ _ widens => prior_lt_of_widens increasing covers widens

/-- A transform is strictly concave up to `n`: up to `n`, each increment is smaller than the one
before. (No transform of whole numbers into whole numbers is strictly concave everywhere: its
increments would fall without end; levels are bounded by the listed steps.) -/
def ConcaveTo (n : Nat) (f : Nat → Nat) : Prop :=
  ∀ k, k + 2 ≤ n → f k + f (k + 2) < f (k + 1) + f (k + 1)

theorem concave_gap {n : Nat} {f : Nat → Nat} (concave : ConcaveTo n f) (a : Nat) :
    ∀ d, a + d + 2 ≤ n → f a + f (a + d + 2) < f (a + 1) + f (a + d + 1)
  | 0, bound => concave a bound
  | d + 1, bound => by
    show f a + f (a + d + 3) < f (a + 1) + f (a + d + 2)
    have step : f (a + d + 1) + f (a + d + 3) < f (a + d + 2) + f (a + d + 2) :=
      concave (a + d + 1) bound
    have sum := Nat.add_lt_add (concave_gap concave a d (Nat.le_of_succ_le bound)) step
    rw [Integers.nat_rearrange (f a) (f (a + d + 2)) (f (a + d + 1)) (f (a + d + 3)),
      Nat.add_add_add_comm (f (a + 1)) (f (a + d + 1)) (f (a + d + 2)) (f (a + d + 2))] at sum
    exact Nat.lt_of_add_lt_add_right sum

/-- **Priority decides a transfer that C leaves mixed.** Where one course gives a formation at
level `a` one step more and another at level `a + d + 2` one step less than another course, every
other listed formation's level the same, a strictly concave transform ranks the first higher. -/
theorem prior_transfer {n : Nat} {f : Nat → Nat} (concave : ConcaveTo n f) {g h : F}
    {rest : List F} {L L' : F → Nat} (a d : Nat) (bound : a + d + 2 ≤ n) (atG : L g = a + 1)
    (atH : L h = a + d + 1) (atG' : L' g = a) (atH' : L' h = a + d + 2)
    (same : ∀ k, k ∈ rest → L k = L' k) :
    total (g :: h :: rest) (fun k => f (L' k)) < total (g :: h :: rest) (fun k => f (L k)) :=
  have pair : f (L' g) + f (L' h) < f (L g) + f (L h) :=
    Eq.subst (motive := fun n => f (L' g) + f (L' h) < f n + f (L h)) atG.symm
      (Eq.subst (motive := fun n => f (L' g) + f (L' h) < f (a + 1) + f n) atH.symm
        (Eq.subst (motive := fun n => f n + f (L' h) < f (a + 1) + f (a + d + 1)) atG'.symm
          (Eq.subst (motive := fun n => f a + f n < f (a + 1) + f (a + d + 1)) atH'.symm
            (concave_gap concave a d bound))))
  have others : total rest (fun k => f (L' k)) = total rest (fun k => f (L k)) :=
    total_congr_on fun k member => congrArg f (same k member).symm
  Eq.subst (motive := fun n => f (L' g) + (f (L' h) + n) < f (L g) + (f (L h) + total rest fun k => f (L k)))
    others.symm
    (Eq.subst (motive := fun n => n < f (L g) + (f (L h) + total rest fun k => f (L k)))
      (Nat.add_assoc (f (L' g)) (f (L' h)) (total rest fun k => f (L k)))
      (Eq.subst (motive := fun n => f (L' g) + f (L' h) + total rest (fun k => f (L k)) < n)
        (Nat.add_assoc (f (L g)) (f (L h)) (total rest fun k => f (L k)))
        (Nat.add_lt_add_right pair _)))

/-- A transform is sufficient at `θ` when it rises no further from `θ` on. -/
def SufficientAt (θ : Nat) (f : Nat → Nat) : Prop :=
  ∀ k, θ ≤ k → f k = f θ

/-- **A threshold of sufficiency weighs alike above it.** Where every listed formation's level is
the same in two courses or at least `θ` in both, a transform sufficient at `θ` weighs them alike:
continuation beyond enough is not counted. -/
theorem sufficient_ties {θ : Nat} {f : Nat → Nat} (sufficient : SufficientAt θ f) {gs : List F}
    {L L' : F → Nat} (above : ∀ k, k ∈ gs → L k = L' k ∨ (θ ≤ L k ∧ θ ≤ L' k)) :
    total gs (fun k => f (L k)) = total gs (fun k => f (L' k)) :=
  total_congr_on fun k member => match above k member with
    | .inl same => congrArg f same
    | .inr ⟨high, high'⟩ => (sufficient _ high).trans (sufficient _ high').symm

end Weighting

namespace Partial

/-- Two standpoints and two formations at one step; each standpoint grades its own formation two
and the other one. -/
def grade (p : Bool) (x : Bool) : Nat :=
  cond (x == p) 2 1

/-- Standing is invariant: every formation counts from every standpoint. -/
theorem cond_pos : ∀ v : Bool, 0 < cond v 2 1
  | true => Nat.succ_pos 1
  | false => Nat.succ_pos 0

theorem standing : Weighting.StandingInvariant grade :=
  fun _ q x _ => cond_pos (x == q)

/-- Grades are not invariant. -/
theorem not_gradeInvariant : ¬ Weighting.GradeInvariant grade :=
  fun invariant => absurd (invariant true false true) (by decide)

/-- From the first standpoint the course keeping its own formation ranks higher, from the second
the other course: invariant standing leaves the mixed comparison to each standpoint's grades. -/
theorem ranks_differ :
    Weighting.weighed [true, false] (grade true) (fun x => !x) <
        Weighting.weighed [true, false] (grade true) (fun x => x) ∧
      Weighting.weighed [true, false] (grade false) (fun x => x) <
        Weighting.weighed [true, false] (grade false) (fun x => !x) :=
  ⟨by decide, by decide⟩

end Partial

namespace LevelTransfer

/-- Two formations over three steps; an item is a step and a formation. -/
def items : List (Nat × Bool) :=
  [(0, true), (1, true), (2, true), (0, false), (1, false), (2, false)]

/-- The formation an item belongs to. -/
def owner (g : Bool) (x : Nat × Bool) : Bool :=
  x.2 == g

/-- The first formation continues for three steps and the second for one. -/
def uneven (x : Nat × Bool) : Bool :=
  cond x.2 (x.1 < 3) (x.1 < 1)

/-- Both formations continue for two steps. -/
def even (x : Nat × Bool) : Bool :=
  x.1 < 2

/-- The comparison is mixed. -/
theorem mixed : Weighting.MixedOn items even uneven :=
  ⟨⟨(1, false), .tail _ (.tail _ (.tail _ (.tail _ (.head _)))), rfl, rfl⟩,
   ⟨(2, true), .tail _ (.tail _ (.head _)), rfl, rfl⟩⟩

/-- A strictly concave transform: increments 6, 4, 2. -/
def concave (k : Nat) : Nat :=
  k * (7 - k)

theorem concave_to : Weighting.ConcaveTo 3 concave
  | 0, _ => by decide
  | 1, _ => by decide
  | k + 2, bound => absurd (Nat.le_trans (Nat.le_add_left 4 k) bound) (by decide)

/-- **The general law decides the witness**: with the formation that continues for one step
listed first, `prior_transfer` ranks the even course higher. -/
theorem by_law :
    Weighting.prior [false, true] owner items concave uneven <
      Weighting.prior [false, true] owner items concave even :=
  Weighting.prior_transfer concave_to (rest := []) 1 0 (Nat.le_refl 3) (by decide) (by decide)
    (by decide) (by decide) (fun _ member => nomatch member)

/-- Priority ranks the even course higher, the sum of levels ties them, and a convex transform
ranks the uneven course higher. -/
theorem decided :
    Weighting.prior [true, false] owner items concave uneven <
        Weighting.prior [true, false] owner items concave even ∧
      Weighting.prior [true, false] owner items (fun k => k) uneven =
        Weighting.prior [true, false] owner items (fun k => k) even ∧
      Weighting.prior [true, false] owner items (fun k => k * k) even <
        Weighting.prior [true, false] owner items (fun k => k * k) uneven :=
  ⟨by decide, by decide, by decide⟩

end LevelTransfer

namespace Framed

/-- One item; a presentation keeps it or not (`.1`) and is framed or not (`.2`). -/
def kept (p : Bool × Bool) : Unit → Bool :=
  fun _ => p.1

/-- A ranking that puts a framed presentation above an unframed one, and otherwise the one that
keeps the item above the one that does not: it depends on the wording, not only on the sets. -/
def ranks (b a : Bool × Bool) : Prop :=
  (a.2 = true ∧ b.2 = false) ∨ (a.2 = b.2 ∧ a.1 = true ∧ b.1 = false)

/-- The item weighs one for and nothing against: the order on courses increases at it. -/
theorem increasing :
    Weighting.IncreasingAt [()] (Weighting.ranksNet [()] (fun _ => 1) (fun _ => 0)) () :=
  Weighting.ranksNet_increasingAt (Nat.succ_pos 0)

theorem widensBy : Weighting.WidensBy [()] () (kept (true, false)) (kept (false, true)) :=
  ⟨fun _ _ _ => rfl, .head _, rfl, rfl, fun _ _ _ _ => rfl⟩

/-- **A framing alone puts a narrowing above its widening**: the framed plan that keeps nothing is
ranked above the unframed plan that keeps the item, though the item weighs above zero; so the
ranking does not read the sets on that pair. -/
theorem framing_alone :
    ranks (true, false) (false, true) ∧
      ¬ Weighting.ReadsSetsOn kept ranks (Weighting.ranksNet [()] (fun _ => 1) (fun _ => 0))
        (true, false) (false, true) :=
  ⟨.inl ⟨rfl, rfl⟩, fun reads => (Weighting.reads_increasingAt widensBy reads increasing).2 (.inl ⟨rfl, rfl⟩)⟩

end Framed

namespace Interacting

/-- Two items, `true` and `false`. A course is scored by how it keeps them together: `true` kept
scores one with or without `false`, `false` kept alone scores two, neither nothing. Adding
`true` raises a course that keeps nothing and lowers one that keeps `false`. -/
def score (c : Bool → Bool) : Nat :=
  cond (c true) 1 (cond (c false) 2 0)

/-- The order of the score. -/
def order (b a : Bool → Bool) : Prop :=
  score b < score a

def items : List Bool := [true, false]

def neither : Bool → Bool := fun _ => false
def onlyTrue : Bool → Bool := fun z => z
def onlyFalse : Bool → Bool := fun z => !z
def both : Bool → Bool := fun _ => true

theorem eq_true_of_not_false : ∀ {v : Bool}, (!v) = false → v = true
  | true, _ => rfl
  | false, no => Bool.noConfusion no

theorem alone : Weighting.WidensBy items true onlyTrue neither :=
  ⟨fun _ _ no => Bool.noConfusion no, .head _, rfl, rfl, fun _ _ admits _ => admits⟩

theorem jointly : Weighting.WidensBy items true both onlyFalse :=
  ⟨fun _ _ _ => rfl, .head _, rfl, rfl, fun _ _ _ not => eq_true_of_not_false not⟩

/-- **The increment at an item can depend on what else is kept.** Adding `true` to a course that
keeps nothing is ranked a gain of it (its ending, measured apart, a loss), and adding it to the
course that keeps `false` is ranked below: the sign measured alone is not the sign in the joint
context, so a ranking that reads the sets exactly puts the narrowing that keeps `false` above
its widening by `true`. -/
theorem increment_differs :
    Weighting.IncrementIs order neither onlyTrue .gt ∧
      Weighting.IncrementIs order onlyFalse both .lt :=
  ⟨⟨(by decide : score neither < score onlyTrue), (by decide : ¬ score onlyTrue < score neither)⟩,
   ⟨(by decide : score both < score onlyFalse), (by decide : ¬ score onlyFalse < score both)⟩⟩

/-- **No net weighting gives this order**: a net weighting's increment at an item is the same in
every context (`Weighting.ranksNet_increment_alike`). -/
theorem not_net :
    ¬ ∃ pos neg : Bool → Nat, ∀ b a, order b a ↔ Weighting.ranksNet items pos neg b a :=
  fun ⟨_, _, same⟩ =>
    match Weighting.ranksNet_increment_alike alone jointly
      (Weighting.increment_transfer (same neither onlyTrue) (same onlyTrue neither)
        increment_differs.1) with
    | ⟨_, not⟩ => not ((same both onlyFalse).mp increment_differs.2.1)

end Interacting

end Becoming
