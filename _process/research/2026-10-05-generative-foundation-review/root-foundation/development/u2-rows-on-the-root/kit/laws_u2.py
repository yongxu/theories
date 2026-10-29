"""U2's twenty laws at the model, one per reading, each for its row's own record (OU's owner's decision (2),
29 October 2026, under rule 3's fallback). Each entry: the record, the row's declaration, the reading's
declaration, the law's declarations, and its English and Chinese text. The row's statement and proof
stay unchanged; the law states the row at its model, a representation, not a derivation."""

M = 'Becoming.ModelStatements.'

LAWS = [
    ('life-as-condition-of-life', 'Becoming.Web.roles_supported', M + 'roles_supported_reading',
     [M + 'roles_supported_reading', M + 'supported_iff'],
     "At the occurrence model of the one-kind reading, a web's support at an occurrence is an inclusion: what the "
     "occurrence requires within its step lies within the needs met there. The partial identity of one occurrence "
     "is added to WRT2's relations.",
     "在一类读法的出现模型上，网在一个出现处的支持即一包含：该出现于其步内所需者，皆在该步已满足之需之中。于 WRT2 之关系之外，仅添一个出现之部分恒等。"),
    ('life-as-condition-of-life', 'Becoming.Web.roles_dependent', M + 'roles_dependent_reading',
     [M + 'roles_dependent_reading', M + 'dependent_iff'],
     "At the same model, dependence is requiring from the active occurrences lying within the needs met: WRT2's "
     "relations within a step alone.",
     "在同一模型上，依存即由活跃出现出发之所需含于已满足之需之中：仅用 WRT2 之步内关系。"),
    ('life-as-condition-of-life', 'Becoming.Web.roles_alive', M + 'roles_alive_reading',
     [M + 'roles_alive_reading', M + 'living_iff', M + 'underminingAt_iff', M + 'undermined'],
     "At the same model, a living event is an active occurrence from which no drawing reaches a condition whose "
     "dependence is undermined across the step, the undermining reading the dependence's history along the names.",
     "在同一模型上，活事件即一活跃出现，自其出发之汲取不及于任何其依存跨步而被削弱之条件；削弱沿名字读该依存之历史。"),
    ('represented-boundary-against-dependence', 'Becoming.Web.renewingAt_iff_over_all',
     M + 'renewingAt_iff_over_all_reading',
     [M + 'renewingAt_iff_over_all_reading', M + 'renewingAt_reading', M + 'renewingOver_reading',
      M + 'roles_renewingAt', M + 'roles_renewingOver', M + 'keptAcross'],
     "At the occurrence model, renewal at a step is an inclusion: the occurrence is active, and requiring, from the "
     "conditions it takes part in, lies within the relation kept across the step. Renewal over a region is the same "
     "with the source met with the region, and the row is their equivalence for the region of every condition.",
     "在出现模型上，一步之更新即一包含：该出现活跃，且由其所参与之条件出发之所需，含于跨步而保持之关系。一区域上之更新同此，惟其源与该区域相交；本行即二者于一切条件之区域上相等。"),
    ('transmission-is-inheritance-and-need', 'Becoming.Web.transmits_at_iff', M + 'transmits_at_reading',
     [M + 'transmits_at_reading', M + 'transmits_at_one_kind', M + 'inheritsAt_iff', M + 'needsWithinAt_iff'],
     "At the occurrence model, transmission at a descent is two inclusions. What the descendant requires of a "
     "condition at its first step, read from the giver and carried back one step along the names, the giver "
     "requires; and the pair, where both require it, lies within the need within δ, read from amounts with an "
     "addition.",
     "在出现模型上，一次传承处之传递即二包含。后代于其首步对某条件之所需，自给予者读出并沿名字回退一步，给予者亦需之；二者皆需之时，此对含于 δ 内之需，一以加法由量读出之关系。"),
    ('learning-through-a-map-is-tracking-in-the-limit', 'Becoming.Limit.identifies_iff_tracks',
     M + 'identifies_iff_reading',
     [M + 'identifies_iff_reading', M + 'tracks_iff', M + 'withinSteps_iff_le'],
     "On the step index, identification reads its horizon through the steps' closure: on each run, from some "
     "horizon, the closure of the steps from it lies within agreement with the constant target, coming no earlier "
     "being lying within that closure.",
     "在步之指标上，辨识以诸步之闭包读其界：于每一历程，自某界起，由之出发之诸步闭包含于与恒定目标之一致；不早于即在该闭包之中。"),
    ('what-a-finite-stretch-verifies', 'Becoming.Ideals.verifiableBy_iff_interior', M + 'verifiableBy_reading',
     [M + 'verifiableBy_reading', M + 'interiorBy_iff', M + 'member'],
     "On one carrier of points and stretches, a reading is verifiable exactly where every point it holds bears "
     "membership to a stretch every bearer of which the reading holds (what every condition held, «承»).",
     "在点与段同一载体上，一读法可验证，恰当其所持之每一点皆属于某段，而该段之每一所属者皆为该读法所持（凡其条件皆持者，«承»）。"),
    ('living-significance-on-held-lives', 'Becoming.Valuation.significant_iff_held',
     M + 'significant_iff_held_reading',
     [M + 'significant_iff_held_reading', M + 'significant_iff_reading', M + 'selfSignificance_iff_reading',
      M + 'shares_iff_reading', M + 'held_iff_reading'],
     "On the claims, with regions as partial identities: where living lies within the own regions together, living "
     "lies within every position's significance exactly where each position's own living lies within its "
     "significance (S0) and what is living and significant from one position lies within every other's (N_std).",
     "在主张上，域以部分恒等持之：当活者含于诸自有域之合中，活者含于每一位置之意义，恰当每一位置自有之活者含于其意义（S0），且自一位置为活且有意义者含于每一其他位置之意义（N_std）。"),
    ('continuation-condition-yields-living-significance', 'Becoming.Web.significance_undetermined',
     M + 'significance_undetermined_reading',
     [M + 'significance_undetermined_reading', M + 'retains_iff', M + 'adds_iff', M + 'livingClaim'],
     "At the model, retaining is an inclusion and adding is exceeding at what the paths admit, met with a region "
     "of significance. With the empty region, what one path admits with it lies within what every other admits and "
     "exceeds nothing; with the full region the living claims lie within significance, and with the empty region "
     "they do not.",
     "在模型上，保留即包含、增添即超出，于诸路径所容纳者与一意义域相交处读之。以空域，一路径所容纳者含于每一其他路径所容纳者而无所超出；以满域，活主张含于意义之中，以空域则否。"),
    ('joint-difference-making', 'Becoming.Dependence.Overdetermined.only_together', M + 'only_together_reading',
     [M + 'only_together_reading', M + 'overdetermined_iff', M + 'differenceAt', M + 'withholdAll_iff_li'],
     "At a process's model, withholding all parts is passing through their withholdings in turn («历»). Where the "
     "move's relation meets the breaking from the configuration and from what each withholding leaves, the but-for "
     "statement for the parts together holds for no single part.",
     "在过程之模型上，扣除诸部分即依次历经其各扣除（«历»）。当着之关系自该构型及自每一扣除所留者皆与破坏相交，诸部分合之之“若无”陈述于任一单一部分皆不成立。"),
    ('joint-difference-making', 'Becoming.Dependence.differenceOnlyTogether_iff', M + 'differenceOnlyTogether_reading',
     [M + 'differenceOnlyTogether_reading', M + 'differenceOnlyTogether_iff_model', M + 'makesDifference_iff',
      M + 'makesDifferenceTogether_iff'],
     "At the same model, each move's relation fixing its successor, and the move available from what each "
     "withholding leaves with the dependence required and met there: the parts make the difference only together "
     "exactly where they do together and from what each withholding leaves the move's relation meets the breaking.",
     "在同一模型上，每一着之关系定其后继，且自每一扣除所留者该着可行、依存所需且被满足：诸部分唯合之方造成差别，恰当其合之造成差别，且自每一扣除所留者着之关系与破坏相交。"),
    ('what-a-pools-acts-respond-to', 'Becoming.ExchangeLaw.response_not_fixed_by_coupling',
     M + 'response_not_fixed_reading',
     [M + 'response_not_fixed_reading', M + 'through_iff_inclusion', M + 'couplingAlike', M + 'exchangingAlike'],
     "On level histories, reading through a coupling is an inclusion of its class in exchanging alike, the meet "
     "of the classes of what is taken and given. Where a formation couples two histories apart, some such law does "
     "not relate them by what it takes from a condition, and some has the full relation at every step.",
     "在水平历史上，经由耦合而读即其类含于同样交换之中，后者为所取与所给之类之交。当一形成将两历史耦合为异，某此类律不依其自某条件所取者关联二者，另一此类律则于每一步皆为满关系。"),
    ('conditions-kept-together', 'Becoming.Viability.kernel_and_iff', M + 'kernel_and_reading',
     [M + 'kernel_and_reading', M + 'kernel_iff'],
     "At a process's model, a kernel is the closure of the steps from a configuration lying within the guard; it "
     "lies within a meet of guards exactly where it lies within each, a law of logic for any relation.",
     "在过程之模型上，核即自某构型出发之诸步闭包含于守域之中；其含于诸守域之交，恰当其含于每一守域，于任何关系皆成立之逻辑律。"),
    ('experiment-needs-return', 'Becoming.Run.not_fixes_of_untaken', M + 'not_fixes_reading',
     [M + 'not_fixes_reading', M + 'fixes_iff', M + 'takes_iff', M + 'before_iff_lt'],
     "At a process's model, with runs as its lines: where each move's relation fixes its successor and two "
     "configurations differ, a move the run's line has not passed through at the configuration before t is "
     "related by no record to one outcome, a record fixing one exactly where every family of relations indexed by "
     "moves and holding the run's steps does.",
     "在过程之模型上，以历程为其线：当每一着之关系定其后继且有二构型相异，历程之线于 t 前未于该构型经过之着，不为任何记录关联于单一结果；记录定一结果，恰当每一以着为指标、保有历程诸步之关系族皆定之。"),
    ('a-code-formed-between-formations', 'Becoming.SharedCodes.run_agrees_every_start_iff',
     M + 'run_agrees_every_start_reading',
     [M + 'run_agrees_every_start_reading', M + 'runs_agree_iff_reached', M + 'reached_iff', M + 'origin_iff_li',
      M + 'copies'],
     "At the hearing process's model, where two forms differ: every code the first k hearings reach from any start "
     "(«历» of the moves) has all formations alike at a sense exactly where every two formations are reached from "
     "one formation through the hearings' copying relations in turn; an origin is what passes in along them.",
     "在听闻过程之模型上，当二形式相异：前 k 次听闻自任一起点所达之每一码（诸着之 «历»），于某义上诸形成皆同，恰当每二形成皆经诸听闻之抄录关系依次自同一形成所达；起源即沿之传入者。"),
    ('what-an-optimum-does-beyond-what-couples-in', 'Becoming.Web.optimum_broken_iff', M + 'optimum_broken_reading',
     [M + 'optimum_broken_reading', M + 'rising_iff', M + 'room_iff', M + 'frontier_iff', M + 'metOn_iff',
      M + 'broken_iff'],
     "On outcomes and the occurrence model: where the order contains exceeding on the family, with room beyond, the "
     "levels after the step eligible and unbeaten, and each condition beyond required and met, a dependence beyond "
     "is broken across the step exactly where some eligible outcome stands below its need. Exceeding and standing "
     "lower compare given levels.",
     "在结果与出现模型上：当序含族上之超出、彼外有余地、步后之水平合格而不被胜、彼外每一条件皆被所需且满足，彼外之一依存跨步被破，恰当某合格结果低于其需。超出与较低皆比较给定之水平。"),
    ('living-on-and-descent', 'Becoming.Web.living_on_reaches', M + 'living_on_reaches_reading',
     [M + 'living_on_reaches_reading', M + 'sustenance_neutral_iff', M + 'neutral_transmits_iff', M + 'livesOn_iff',
      M + 'interacts_iff'],
     "At the occurrence model, relational neutrality for the sustenance valuation is significance closed under "
     "the formed relation into living occurrences («闭»), the relation interacting or living on either way. The row "
     "is one step of that closure along living on, read as drawing with a dependence at a positive need.",
     "在出现模型上，维生价值之关系中立，即意义于所形成之关系入于活出现之下封闭（«闭»），该关系为互动或任一方向之依其而生。本行为此闭包沿依其而生之一步，读为汲取并以正需依存。"),
    ('living-on-and-descent', 'Becoming.Flow.descent_reaches', M + 'descent_reaches_reading',
     [M + 'descent_reaches_reading', M + 'descent_neutral_iff', M + 'descends_iff', M + 'descentStep'],
     "The same along descent: the descent valuation's relation read on occurrences as interacting or descent "
     "either way, descent being the giver present and giving within the step and the receiver coming to stand "
     "across it, between relata at any steps.",
     "沿传承亦同：传承价值之关系于出现上读为互动或任一方向之传承；传承即给予者在场且于步内给予、接受者跨步而立，于任意步之关系项之间。"),
    ('generalization-through-lumping', 'Becoming.Learning.Training.unselected_beyond_data',
     M + 'unselected_beyond_data_reading',
     [M + 'unselected_beyond_data_reading', M + 'through_of_closed', M + 'free_iff', M + 'agreeingOn'],
     "On functions, agreeing on the data is the meet of the value classes there. A selection closed along it is a "
     "selection through the data, and a class free beyond the data is an inclusion; with both, a selected member is "
     "related to every member through a selected member agreeing with it on the data and alike with that member at "
     "the untried point.",
     "在函数上，于数据上一致即诸值类之交。沿之封闭之选取即经数据之选取，类于数据外自由即一包含；二者俱在时，一被选成员经一于数据上与之一致、于未试之点与彼成员同值之被选成员，关联于每一成员。"),
    ('becoming-finite-horizon', 'Becoming.Renewable.no_exact_finite_reading', M + 'finite_reading_not_exact',
     [M + 'finite_reading_not_exact', M + 'renewing_not_closed', M + 'finite_reading_iff', M + 'agreeUpTo_iff',
      M + 'renewing_iff_along', M + 'renewingIn_iff'],
     "At a process's model, with runs as its lines and agreeing up to h read through the steps' closure: no region "
     "of runs closed under that agreement is the region of runs along which the focal formation renews, read at the "
     "occurrence model of the run's web; equivalently that region is not so closed.",
     "在过程之模型上，以历程为其线，并以诸步之闭包读至 h 之一致：无一于此一致下封闭之历程域，等于焦点形成沿之更新之历程域（在历程之网之出现模型上读）；等价地，该域不如此封闭。"),
]

# MV's F5 field (its owner's draft, 30 October 2026, final after its review): on each law at the model,
# model_statements: [{"states": the row's declaration, "by": the reading's declaration}], "by" among the law's
# own declarations, "states" a declared reference of the record and not among the law's declarations. Row 24
# has two readings, the row's form and its statement of closure.
EXTRA_READINGS = {'Becoming.Renewable.no_exact_finite_reading': [M + 'renewing_not_closed']}


# The models each reading is stated at, from DESIGN §2's Model column (MV's draft 2, 30 October 2026, before
# its final shape): "occurrence" (a World's occurrence model), "process" (a process's model of its moves'
# relations) and "own" (the row's own carrier). Rows wholly on their own carrier MV reports apart.
MODELS = {
    'Becoming.Web.roles_supported': ['occurrence'],
    'Becoming.Web.roles_dependent': ['occurrence'],
    'Becoming.Web.roles_alive': ['occurrence'],
    'Becoming.Web.renewingAt_iff_over_all': ['occurrence'],
    'Becoming.Web.transmits_at_iff': ['occurrence'],
    'Becoming.Limit.identifies_iff_tracks': ['process'],
    'Becoming.Ideals.verifiableBy_iff_interior': ['own'],
    'Becoming.Valuation.significant_iff_held': ['own'],
    'Becoming.Web.significance_undetermined': ['own', 'occurrence'],
    'Becoming.Dependence.Overdetermined.only_together': ['process'],
    'Becoming.ExchangeLaw.response_not_fixed_by_coupling': ['own'],
    'Becoming.Viability.kernel_and_iff': ['process'],
    'Becoming.Dependence.differenceOnlyTogether_iff': ['process'],
    'Becoming.Run.not_fixes_of_untaken': ['process'],
    'Becoming.SharedCodes.run_agrees_every_start_iff': ['process', 'own'],
    'Becoming.Web.optimum_broken_iff': ['own', 'occurrence'],
    'Becoming.Web.living_on_reaches': ['occurrence'],
    'Becoming.Flow.descent_reaches': ['occurrence'],
    'Becoming.Learning.Training.unselected_beyond_data': ['own'],
    'Becoming.Renewable.no_exact_finite_reading': ['process', 'occurrence'],
}


def model_statements(row, reading):
    return [{'states': row, 'by': by} for by in [reading] + EXTRA_READINGS.get(row, [])]


if __name__ == '__main__':
    assert set(MODELS) == {row for _, row, *_ in LAWS}
    for record, row, reading, decls, en, zh in LAWS:
        for pair in model_statements(row, reading):
            assert pair['by'] in decls and pair['states'] not in decls, (record, pair)
    import collections
    assert len(LAWS) == 20
    over = [(r, len(en)) for r, _, _, _, en, _ in LAWS if len(en) > 420]
    print('records:', len({r for r, *_ in LAWS}), '| laws:', len(LAWS), '| English over 420:', over)
    print('per record:', collections.Counter(r for r, *_ in LAWS))
