"""K4's plan for the atlas: route (b)'s dynamics as entries and extensions, with their exits. Writes plan.json beside
this file, which apply.py applies. Judgments: Fable (fable-judgments.md), revised by the writer (Opus) where noted in
NOTE.md, and after each of the cold reader's rounds (READER.md). Run from the checkout root on the atlas as it stood
before K4 (`git show 5411279cb:theories/becoming/results/atlas/entries/dynamics.json`), then apply.py."""
import json
from pathlib import Path

CH = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
REC = 'theories/becoming/results/records/'
DNS = '.md#does-not-show--未表明'
B = 'Becoming.'


def t(s):
    return {'en': s}


def x(to, law, strength, edge, records, source, seen=None):
    e = {'to': to if isinstance(to, str) else t(to[0]), 'law': law, 'edge': t(edge), 'strength': strength,
         'records': records, 'source': source}
    if seen:
        assert law is None and strength is None and records == []
        e['standing_without_law'] = seen
    return e


def text(s):
    return (s,)


def hyp(record, *idx):
    return [{'record': record, 'index': i} for i in idx]


def o(en, source):
    return {'en': en, 'source': source}


def entry(**k):
    base = dict(forbids=None, transitions=[], tests=[], valence='none asserted', beyond=None, standing_without_record=None)
    base.update(k)
    return base


# ---------------------------------------------------------------- new: H, persisting as a filter
persisting = entry(
    after='the-selection-term-and-a-lineages-fate',
    id='persisting-filters-what-was-chosen',
    name=t('Persisting is a filter on what was chosen: keeping above ending, on the occasions met'),
    family='H',
    mechanism=t(
        'World for the survivorship laws; any type for the laws of choice. A line of descent persists where it has members '
        'in arbitrarily late cohorts. Under balance, only active formations giving, activity needing support, descent, a '
        "family's renewal gated on it and every member of every cohort depending on it at a need of at least m, a persisting "
        "line never had the family's uptake exceed its replenishment for n steps from a stock below n + m: the contrapositive "
        "of a coupled generation's ending; a member at a step past such a window rules the window out, the finite and dated "
        'form. Where a chosen course ending what the line depends on is realized as such an overdraw (a premise) and the '
        "choices come from some strict order (nothing shown returns), the persisting line's choices are consistent with "
        'keeping ranked above ending on the occasions met, and with an order increasing in its own continuation there '
        'wherever only ending was at stake. Consistent with, not held: in Forgoing a persisting line choosing the line as it '
        'is over one more child is consistent with no strict order increasing in its own continuation on the occasion met; off '
        'the occasions met a consistent order is free; and with every course met, no consistent order need be increasing in '
        'its own continuation on every pair (Crossed). Where the shown relation with the own-widenings met added has no '
        'cycle, what every consistent order increasing in its own continuation on the pairs met ranks is exactly that '
        "relation's reach. Under only active formations giving, activity needing support and descent, no finite listing "
        "holds a persisting line's actual levels, so an order between listed level paths never ranks the course taken. A "
        "filter on what happened, not a mechanism forming an order; the laws of choice are 03 §11's on enlarged occasions, "
        'near-definitional.'),
    records=['what-persisting-shows-of-an-order', 'a-line-alive-after-a-window', 'route-b-joined'],
    declarations=[B + n for n in (
        'SelectionTerm.Generations.Persists', 'Flow.persists_never_overdraws', 'Flow.member_after_never_overdrew',
        'GroupEnding.Flow.coupled_generation_childless', 'Flow.persisting_keeping_above_ending',
        'Flow.persisting_consistent_with_selfConcern', 'ChoiceOccasions.keeping_above_ending',
        'ChoiceOccasions.selfConcerned_consistent_iff', 'ChoiceOccasions.selfConcerned_consistent_of_kept',
        'ChoiceOccasions.increasingInOwnOn_of_keeping', 'ChoiceOccasions.reversed_off_met',
        'ChoiceOccasions.selfConcerned_above_iff_reach', 'PersistingChoices.Forgoing.persists_not_selfConcerned',
        'PersistingChoices.Crossed.not_selfConcerned', 'Flow.persists_not_listsAdmitted',
        'FromTheDynamics.Alternating.joined', 'FromTheDynamics.Alternating.crossed_joined')],
    base='World',
    hypotheses=hyp('what-persisting-shows-of-an-order', 1, 2, 3, 4, 5) + hyp('a-line-alive-after-a-window', 1)
    + hyp('route-b-joined', 4, 5),
    exits=[
        x('selection-among-groups-by-ending', B + 'GroupEnding.Flow.coupled_generation_childless', 'sufficient',
          'A course that overdraws leaves the line: under balance, only active formations giving, activity needing support, '
          "descent and the gate, n steps of the family's uptake exceeding its replenishment from a stock below n + m leave a "
          "later cohort coupled to the family childless (GroupEnding.Flow.coupled_generation_childless). Persisting is that "
          "ending's contrapositive (Flow.persists_never_overdraws; Flow.member_after_never_overdrew for a member past the window)",
          ['route-b-joined', 'what-persisting-shows-of-an-order'], CH + '#r-what-persisting-shows-of-an-order'),
        x(text('the self-preservation half of instrumental convergence, where a reward channel or an operator\'s assent is '
               'among what the line depends on'), None, None,
          "Read where a reward channel or an operator's assent is among the conditions a line depends on, choices consistent "
          'with keeping above ending read as the self-preservation half of instrumental convergence. AJ\'s plan reads its '
          'resource-keeping half, under a fixed order, as courses over a horizon holding a base at its greatest renewal '
          '(horizon-optima-hold-the-greatest-renewal, in the plan), of the same kind as the drain beyond what couples in. The '
          'filter shows no order held, and the horizon law takes an order. What tells an ethics from self-keeping '
          'here is the scope, not the order', [], CH + '#route-b-joined', seen='reading'),
        x('what-training-installs', None, None,
          'Read with training, this is where goal misgeneralization sits: what survival or a selection installs, if it '
          'installs anything, is fixed on the occasions met (Training.response_free_where_unlumped), and where some consistent '
          'order is increasing in its own continuation there, a course never met that widens another and adds to the own '
          'continuation can be ranked below it by strict orders consistent with every choice (ChoiceOccasions.reversed_off_met, '
          'proved). That a survival or a selection is a training is the reading',
          [], CH + '#what-persisting-shows', seen='reading'),
    ],
    open=[
        o('That any order is held: the choices are consistent with one, which does not show that the chooser carries it; '
          'and anything between degrees of keeping (Forgoing).', REC + 'what-persisting-shows-of-an-order' + DNS),
        o('That a chosen ending is realized as an overdraw, or that actual formations choose by a strict order among such '
          'courses.',
          REC + 'what-persisting-shows-of-an-order' + DNS),
        o('Selection by share among several lines: persisting here is members in arbitrarily late cohorts, with no rate or '
          'fitness.', REC + 'what-persisting-shows-of-an-order' + DNS),
        o("Anything of a window that closes at or after the member's step.", REC + 'a-line-alive-after-a-window' + DNS),
        o('That the flow forms the chooser: in the joint witness the chooser is supplied, tied to the flow only by the '
          'realization premise.', REC + 'route-b-joined' + DNS),
    ],
    sources=[CH + '#r-what-persisting-shows-of-an-order', CH + '#r-a-line-alive-after-a-window', CH + '#r-route-b-joined',
             CH + '#what-persisting-shows'],
)

# ---------------------------------------------------------------- new: H, readings carried and filtered
readings = entry(
    after='persisting-filters-what-was-chosen',
    id='readings-carried-and-filtered',
    name=t('Readings carried along a line, told apart by its standing late only within its coupling closure'),
    family='H',
    mechanism=t(
        'World. Each relatum carries a reading and exchanges as the act that reading gives, the act supplied. A balanced '
        'flow in which every formation exchanges as a law of what has stood gives has the levels the law generates, and its '
        'course is feasible, so the world is the course its acts generate. The line read off a flow from founders and a '
        'listing of the relata is descended by construction, and where readings are inherited along descent (a premise) '
        "every member of every cohort carries the founders' reading. Where every occasion picks the carried reading and "
        "ending is read as that course's overdraw, the persisting filter's realization premise is the identity. Standing "
        'late, some slot of the line standing at arbitrarily late steps, which persistence implies (not conversely), tells '
        "two readings apart only by what their acts do within the line's coupling closure: with the rest reading through "
        "coupling, the two acts laws of what has stood agreeing under every history on what couples into the closure drawn "
        "through both courses, the first reading each slot's couplings only, both courses feasible and each slot's own "
        'standing coupled in, the slots stand late in the one course exactly when in the other. That is the blindness beyond '
        'the coupling closure with standing late as the selection, near-definitional; a witness meets every premise. '
        'Readings are carried and filtered, never varied or learned; selection here is persistence, all or nothing.'),
    records=['readings-carried-on-their-course', 'which-readings-persist'],
    declarations=[B + n for n in (
        'ExchangeLaw.byReading', 'ExchangeLaw.byReading_withAct', 'ExchangeLaw.levels_of_follows',
        'ExchangeLaw.feasible_of_follows', 'Flow.lineOf', 'Flow.lineOf_descended', 'Flow.InheritsReading',
        'Flow.lineOf_carries', 'Flow.carried_keeping_above_ending', 'Flow.LineAlive', 'Flow.LineReachesBefore',
        'Flow.LineReachesBefore.affects', 'StandsLate', 'Flow.lineOf_standsLate', 'line_standing_unselected',
        'line_standing_unselected_of_reads', 'ReadingsPersist.Habitat.generated', 'ReadingsPersist.Habitat.beyond_which_persist',
        'ReadingsPersist.Habitat.beyond_standing_unselected', 'ReadingsPersist.Habitat.back_which_persist')],
    base='World',
    hypotheses=hyp('readings-carried-on-their-course', 1, 2, 3) + hyp('which-readings-persist', 1, 2, 3, 4),
    exits=[
        x('persisting-filters-what-was-chosen', B + 'Flow.carried_keeping_above_ending', 'sufficient',
          'Where a line carries its reading, every occasion picks it, the world is the course that reading generates and a '
          "reading ends where that course overdraws a family from a short stock, the filter's realization premise is the "
          'identity, ending being defined as that overdraw, so nothing is derived about the stake; under the filter\'s '
          'remaining premises some strict order according with the choices puts every reading that does not end above every '
          'ending one met with it', ['readings-carried-on-their-course'], CH + '#r-readings-carried-on-their-course'),
        x('unselected-beyond-the-coupling-closure', B + 'line_standing_unselected', 'sufficient',
          "With the rest reading through coupling, the two acts laws of what has stood, the first reading each slot's "
          "couplings only, agreeing under every history on what couples into the line's coupling closure drawn through both "
          "courses, both courses feasible and each slot's own standing coupled in, the line's slots stand late in the one "
          'course exactly when in the other, whatever the readings say of what lies beyond: the blindness with standing late '
          'as the selection', ['which-readings-persist'], CH + '#r-which-readings-persist'),
        x(text('where the dweller\'s line renews the source, the line that clears its habitat ends after it'),
          B + 'ReadingsPersist.Habitat.back_which_persist', 'witness',
          "Where the dweller's line renews the source, the line reading itself and its source clears the habitat and is gone "
          "from the fourth step, after the dweller's line, while the line reading everything persists with it "
          '(Habitat.back_which_persist); where nothing comes back, the line reading itself alone overdraws its source and '
          'ends, and the clearing and the sparing lines both persist (Habitat.beyond_which_persist). Which conduct each '
          'reading gives is designed', ['which-readings-persist'], CH + '#r-which-readings-persist'),
        x('selection-read-off-its-own-survivors', B + 'ReadingsPersist.Habitat.cleared_removes_its_readers', 'witness',
          "In the course where the line reads its source and nothing comes back, selection by persistence read off the "
          "course's pool holds while the course removes the dweller's line, read as a reader of the habitat; read off the "
          'fixed pool of both lines it fails there', ['a-selection-removing-its-readers'],
          CH + '#r-a-selection-removing-its-readers'),
    ],
    open=[
        o('How a reading arises or changes: readings here are carried along descent, never varied or learned; occasions '
          'picking different readings need a run made of the picks.', REC + 'readings-carried-on-their-course' + DNS),
        o('That carrying the index makes the act read it only within a closure: ActReadsWithin stays a premise.',
          REC + 'readings-carried-on-their-course' + DNS),
        o('Which readings persist among several lines competing for a share; that a wider reading persists because it is '
          'wider.', REC + 'which-readings-persist' + DNS),
    ],
    beyond=t("Where nothing comes back from a dweller, the line reading itself and its source clears the dweller's habitat "
             "and persists as the line reading everything does, while the dweller's line ends: a loss beyond the line's "
             'coupling closure that its standing late does not register (Habitat.beyond_which_persist, '
             "Habitat.beyond_standing_unselected, a witness). Where the dweller's line renews the source, the clearing line "
             'ends with it (Habitat.back_which_persist).'),
    sources=[CH + '#r-readings-carried-on-their-course', CH + '#r-which-readings-persist', CH + '#readings-persist'],
)

# ---------------------------------------------------------------- new: B, selection read off its own survivors
survivors = entry(
    after='unselected-beyond-the-coupling-closure',
    id='selection-read-off-its-own-survivors',
    name=t('A selection read off the pool its own course gives registers no removal'),
    family='B',
    mechanism=t(
        'World. Among listed lines, a line is alive in a course at a step where one of its slots stands then; the pool a '
        'course gives at a step is the lines alive then. Selection by persistence read off that pool holds where, from some '
        'step on, every line alive persists; read off a fixed pool, where every line persists. A course removes a line alive '
        'at the start and, from some step on, not; a selection removes its own readers where it holds at a course removing a '
        'line of readers, which lines are readers being supplied. Read off its own pool, selection by persistence registers '
        'no removal: every course in which, from some step on, each line persists or is not alive passes it, a course '
        'removing every line included (classically every course with finitely many lines settles; argued, not in Lean). Read '
        'off a fixed pool every removal turns it, and passing it there passes it read off the course\'s pool. Under the '
        "blindness's premises on the two acts and the rest, a reader within the group's coupling closure drawn through both "
        'courses, its own standing coupled in, stands at every step in the one course exactly when in the other. '
        'Near-definitional. Nothing makes a selection prefer a course removing its readers: the shape of the meta-attractor '
        'with persistence for the share, not the meta-attractor.'),
    records=['a-selection-removing-its-readers'],
    declarations=[B + n for n in (
        'AliveIn', 'SurvivorsPersist', 'AllPersist', 'RemovesLine', 'RemovesItsReaders', 'RemovesLine.not_standsLate',
        'survivorsPersist_of_settled', 'not_allPersist_of_removes', 'AllPersist.survivors', 'reader_kept_alike',
        'ReadingsPersist.Habitat.cleared_removes_its_readers', 'ReadingsPersist.Habitat.clearedBack_removes_both',
        'ReadingsPersist.Habitat.clearedBack_survivors_pass')],
    base='World',
    hypotheses=hyp('a-selection-removing-its-readers', 1, 2, 3),
    exits=[
        x(text('the removal registered: read off a fixed pool, selection by persistence fails at every course that removes a '
               'line'), B + 'not_allPersist_of_removes', 'sufficient',
          'Read off a fixed pool, selection by persistence fails at every course removing a line alive at the start '
          "(not_allPersist_of_removes); passing it there passes it read off the course's own pool (AllPersist.survivors), not "
          'conversely (Habitat.cleared_removes_its_readers)', ['a-selection-removing-its-readers'],
          CH + '#r-a-selection-removing-its-readers'),
        x('closed-capture', None, None,
          "Read off the pool its course gives, selection by persistence reads nothing beyond its survivors, as 02's closed "
          'capture reads nothing beyond its share, a likeness of shape (SurvivorsPersist beside Unread), not a law; here with '
          'persistence for the share and no rule formed from it: the '
          "meta-attractor's shape, not the meta-attractor. A selection by share coming to select for control of its rule "
          "needs RuleShaping's counts read off the pool the course gives; that join is not made",
          [], CH + '#r-a-selection-removing-its-readers', seen='open'),
        x('readers-drawn-from-the-selected', None, None,
          "Read as generative alignment's first condition on the flow: keep the readers in a pool that does not depend on the "
          "course selected, or couple their loss back into the selectors' own continuation; where the loss returns, what "
          "turns is the selecting line's own persistence, the selection read off its survivors still passing "
          '(Habitat.clearedBack_survivors_pass)', [], CH + '#readings-persist', seen='reading'),
    ],
    open=[
        o("The meta-attractor as a selection by share coming to select for control of its rule: RuleShaping's counts are "
          'not joined here.', REC + 'a-selection-removing-its-readers' + DNS),
        o("That a reader whose loss returns to the selectors is kept in general: one world, where the selecting line's own "
          'persistence turns.', REC + 'a-selection-removing-its-readers' + DNS),
        o('A reading in time, before a loss passes its point of no return.', REC + 'a-selection-removing-its-readers' + DNS),
    ],
    beyond=t("In the witness where the dweller's line renews the source, the course removing it removes the selecting line "
             "too, and selection by persistence read off the course's pool still passes it: what turns there is the line's "
             'own persistence, not the selection read off its survivors (Habitat.clearedBack_removes_both, '
             'Habitat.clearedBack_survivors_pass).'),
    sources=[CH + '#r-a-selection-removing-its-readers', CH + '#readings-persist'],
)

# ---------------------------------------------------------------- extension: H mutual dependence
mutual = dict(
    id='mutual-dependence-and-its-pace',
    records=['mutual-dependence-gives-the-condition-de-se', 'standpoints-read-off-a-flow', 'route-b-joined',
             'what-the-one-center-bound-counts'],
    declarations=[B + n for n in (
        'Flow.unrestricted_of_mutuallyDependent', 'Flow.mutuallyDependent_iff_unrestricted',
        'Clearing.not_unrestricted_ownClosure', 'Flow.returning_unrestricted_iff_mutuallyDependent',
        'Flow.MutuallyDependent.reachReturns', 'Flow.mutuallyFed_iff_unrestricted', 'Drawing.returning_feeding_apart',
        'Clearing.returning_apart', 'Flow.returning_downstream_iff_mutuallyDependent',
        'Flow.unrestrictedEventually_iff_mutuallyDependentInTime', 'Flow.unrestrictedAfter_iff_coupledEachStep',
        'Flow.returningInTime_unrestricted', '«续无外当且仅当后与独»', '«独则同一中心»', 'TwoSources.apart',
        'ownClosure_not_unrestricted_of_acyclic')],
    hypotheses=hyp('mutual-dependence-gives-the-condition-de-se', 1, 2) + hyp('standpoints-read-off-a-flow', 1, 2, 3)
    + hyp('route-b-joined', 1, 2) + hyp('what-the-one-center-bound-counts', 1, 2),
    mechanism_append=(
        'Read de se as own closure, significance held as what lies within each center\'s closure under being affected, or '
        'under affecting, is the continuation condition in a mutually dependent flow, and with every formation a center '
        'each is exactly mutual dependence; in Clearing, every formation a center, neither holds. With the standpoints read '
        'off the flow as the formations whose acts return, along affecting and given one, the condition is again exactly '
        "mutual dependence, and so under each standpoint's least class, itself with everything downstream; along feeding, "
        'with every formation a standpoint, it is mutual feeding, which is stronger. Which relation, which standpoints, which '
        'class, and that significance is own closure at all are readings; what the dynamics decide is whether every closure '
        'is the whole, near-definitional. Mutual dependence is closure under being affected and counts taking as well as '
        'giving. In time, with every occurrence a standpoint, the condition from some step on is exactly mutual dependence '
        'in time from every step, and over every later step it is coupling at every next step; at the returning occurrences '
        "it is vacuous. On a net going forward in time the root's condition is the condition over what comes after together "
        "with nothing else at or before the center's step; the second part alone admits one center, and over what comes "
        'after two centers can meet it.'),
    beyond=t('Mutual dependence includes mutual drain. In Drawing each of two formations takes one unit, across the first '
             'step, from the condition the other requires at need one, and nothing gives; both stand at the first step only. '
             "The pair balances, is mutually dependent, every formation's acts return, and the condition held de se at them "
             'holds along affecting and along being affected, not along feeding (Drawing.returning_feeding_apart). What the '
             'closures make the whole is contact, not benefit.'),
    exits=[
        x(text('mutual drain: a pair each taking from what the other depends on, mutually dependent, every formation\'s acts '
               'returning, both gone after the first step'), B + 'Drawing.returning_feeding_apart', 'witness',
          "In Drawing, a balanced pair each taking one unit across the first step from the condition the other requires, "
          "every formation's acts return and the condition held de se at them holds along affecting and along being "
          'affected, not along feeding: exchanging counts taking as well as giving', ['standpoints-read-off-a-flow'],
          CH + '#r-standpoints-read-off-a-flow'),
    ],
    open=[
        o("Which of the flow's relations a self is drawn along, which formations are the standpoints, and which class a "
          "center's own line runs under: the net fixes the least class holding one's effects only granted P4, and a class "
          "drawn on the coupling closure reaches exactly the formation's loop with coupling by threshold only; which is one's "
          'own stays a reading.', CH + '#own-class'),
        o("That the four pieces' centers are one object: no theorem identifies them; Alternating is a witness, not an "
          'identification.', REC + 'route-b-joined' + DNS),
        o('The condition over every step in time: nothing reaches an earlier step, so held de se in time at every occurrence '
          'it fails wherever there is a formation; at the returning occurrences it is vacuous.',
          REC + 'the-condition-in-time' + DNS),
    ],
    sources=[CH + '#r-mutual-dependence-gives-the-condition-de-se', CH + '#r-standpoints-read-off-a-flow',
             CH + '#r-route-b-joined', CH + '#r-what-the-one-center-bound-counts'],
    amend_exit={'law': B + 'Drawing.lapses', 'to': t('mutual dependence in time lapsed: from the next step some formation '
                                                      "no longer reaches another formation's continuation at any later step")},
)

# ---------------------------------------------------------------- extension: B the blindness beyond the coupling closure
blind = dict(
    id='unselected-beyond-the-coupling-closure',
    records=['route-b-universal-form-closed', 'covering-by-the-returning-formations', 'route-b-joined'],
    declarations=[B + n for n in (
        'routeB_universal_closed', 'Flow.ownClosure_rival_of_within', 'Flow.couplingIn_ownClosure_rival',
        'Flow.reachReturns_ownClosure_rival', 'Clearing.couplingIn_leaves_dweller', 'Clearing.dweller_beyond_every_coupling',
        'Flow.covered_by_returning', 'Flow.returning_pool_covers', 'Flow.returning_beyond_coupling')],
    hypotheses=hyp('selection-read-off-continuations', 1, 5) + hyp('route-b-universal-form-closed', 1, 3)
    + hyp('covering-by-the-returning-formations', 1) + hyp('route-b-joined', 2),
    mechanism_append=(
        "For a significance read as each center's own closure: where a center's own closure lies within its coupling "
        'closure, what lies beyond the coupling closure has no significance from its standpoint at any step, and the '
        'significance is a rival; so along every relation within coupling in, and along affecting at a center whose acts '
        "return. In Clearing the dweller lies beyond the clearer's coupling closure for every coupling by level, though "
        'within its reach. The bound has content only for a pool that leaves some returning formation out: on a finite flow '
        'with reach decided every formation lies within the influence closure of a formation whose acts return, so within '
        'their pooled coupling closure; in Clearing the clearer alone leaves out the dweller. Near-definitional '
        'compositions, the relation and the centers supplied. The group and the pool are fixed across the two courses, and '
        'the selection is read over the whole run.'),
    beyond_append=('From a returning standpoint, for any coupling by level, what lies beyond its coupling closure has, read '
                   'as own closure along affecting and held de se, no significance from it at any step '
                   '(Flow.returning_beyond_coupling).'),
    exits=[
        x('readers-drawn-from-the-selected', None, None,
          'One level up: read the two acts as a rule that keeps a reader of the dweller and one that does not, that keeping '
          "the reader gives the sparing act being supplied. The shapers' selection of the rule, read off what couples into "
          "them, selects the two alike wherever keeping the reader changes nothing that couples into them (Clearing's "
          "shape); where keeping the reader costs them it can select against keeping it (Diversion's shape). Which way a "
          "coupled-in loss turns the selection is the rule's: readers drawn from the selected and the loss read in time by "
          'the others take it from there', [], CH + '#beyond-coupling', seen='reading'),
        x('selection-read-off-its-own-survivors', None, None,
          'Here the group and the pool are fixed across the two courses, so the pool keeps the dweller even in the course '
          'that ends it; a selection that removes its own readers needs the pool read off the course. Read so, the lines '
          'alive at each step, selection by persistence passes every course whose lines settle, a course removing every '
          'line included (survivorsPersist_of_settled, a law of that selection alone; the change of what the pool is read '
          'off is the step argued)', [], CH + '#beyond-coupling', seen='argued'),
        x('several-optimizers-drain-by-their-joint-capacity', None, None,
          "Coupling a consequence beyond into the selection, the way out of this blindness, is necessary for it to be "
          'selected and not sufficient: at a mutual best response of optimizers, each ranking by its own order rising with '
          'its own family, restraint at a condition beyond its own family is no best response wherever something stands '
          'there after the step', [], CH + '#direction', seen='argued'),
        x('the-rest-outruns-the-renewal', None, None,
          "Coupling a consequence beyond into the selection is necessary for it to be selected and not sufficient: where "
          "the rest outruns the renewal, no weight of a later reading selects a member's restraint",
          [], CH + '#direction', seen='argued'),
    ],
    open=[
        o("Which class a center's own line runs under, and that significance is own closure: a free significance is the "
          'case of what the dynamics leave open.', REC + 'route-b-universal-form-closed' + DNS),
    ],
    sources=[CH + '#r-selection-read-off-continuations', CH + '#r-where-the-blindness-lifts',
             CH + '#r-route-b-universal-form-closed', CH + '#r-covering-by-the-returning-formations', CH + '#beyond-coupling'],
)

# ---------------------------------------------------------------- extension: H the selection term, one exit in
term = dict(
    id='the-selection-term-and-a-lineages-fate',
    exits=[
        x('persisting-filters-what-was-chosen', B + 'SelectionShift.Generations.never_empties_of_unbounded', 'sufficient',
          'Where past every step there is a later one at which the selection term proper is positive, every generation is '
          'nonempty, so the line has a member in every cohort and persists (SelectionTerm.Generations.persists_of_alive); '
          'under balance, only active formations giving, activity needing support, descent, the gate and every cohort '
          'coupled to the family at a need of at least m, such a line never overdrew it (Flow.persists_never_overdraws)',
          ['the-selection-term-and-a-lineages-fate'], 'theories/becoming/chapters/04-LIFE.md#r-the-selection-term-and-a-lineages-fate'),
    ],
)

plan = {'new': [persisting, readings, survivors], 'extend': [mutual, blind, term]}
Path(__file__).with_name('plan.json').write_text(json.dumps(plan, ensure_ascii=False, indent=1) + '\n')
print('plan written')
