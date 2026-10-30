"""U3's six laws on the root, one per row, each for its row's own record. Each entry: the record, the row's
declaration, the root form's declaration, the law's declarations, and its English and Chinese text. Every row's
statement and proof stay unchanged, and each root form is proved through its row: a restatement, not a derivation,
and nothing ethical follows from the root. The condition (scope) and C (order) stay premises, named where used.
Rows 5, 7 and 10 keep their row's full generality, restated in the grammar's terms on the row's own carrier: each
carries F5's item, model `own`. Rows 1, 8 and 9 fix significance at the own-closure reading, so each is a
specialization of its row; F5's spec does not take a specialization as an item (§4, "U3's forms"), so these land as
ordinary laws with no item. Their acyclic boundary cites GrammarScope's «续无外则同一中心»."""

S = 'Becoming.SignificanceStatements.'
W = 'Becoming.Weighting.'
ONE = 'Becoming.«续无外则同一中心»'
OWN = 'Becoming.ownClosure_unrestricted_iff_noOutside'

LAWS = [
    ('continuation-condition-yields-living-significance', 'Becoming.unrestricted_iff_livingSignificance',
     S + 'noOutside_iff_paths_livingSignificance', [S + 'noOutside_iff_paths_livingSignificance', OWN, ONE],
     "On the root, on a web's level paths, a specialization of the row: where a claim's significance from a standpoint is that its formation lies "
     "within that standpoint's center's closure under a relation, the condition is «续无外» at the one of that "
     "relation, and it holds exactly when living significance does over admission. On an acyclic relation the condition forces every center to coincide.",
     "在根上、网的水平路径上，为本行之特化：若一主张从一立场之意义为其形成位于该立场之中心沿一关系之闭包内，则延续条件即该关系之一下的「续无外」，"
     "它恰在生生之意义于接纳上成立时成立。关系无环时，该条件迫使一切中心重合。"),
    ('comparison-by-widening', 'Becoming.Web.paths_extension_iff_widens',
     S + 'paths_extension_iff_grammar', [S + 'paths_extension_iff_grammar'],
     "On the root: with every claim counted, an extension of one level path by another is the grammar's widening, "
     "«广», of what the second admits over what the first admits.",
     "在根上：每个主张都计入时，一条水平路径被另一条扩展，即后者所接纳者对前者所接纳者之文法之「广」。"),
    ('comparison-by-widening', 'Becoming.Web.paths_comparison_widens',
     S + 'paths_comparison_grammar', [S + 'paths_comparison_grammar'],
     "On the root, for every reading of living, C holds on level paths with “better” read as the grammar's "
     "widening, «广», of what the paths admit; that this relation is better is C's content, supplied, not shown.",
     "在根上，对 living 的每种读法，以“更好”读作路径所接纳者之文法之「广」时，C 在水平路径上成立；此关系之为更好是 C 的内容，系所给，非所证。"),
    ('comparison-by-widening', 'Becoming.Web.paths_one_object',
     S + 'paths_one_object_root', [S + 'paths_one_object_root', OWN, ONE],
     "On the root, at the own-closure reading of significance, a specialization of the row: the condition («续无外»), "
     "living significance over admission and an extension with every claim counted read one predicate, admission, "
     "with widening the grammar's «广»; and under «续无外», «广» is retaining and adding from each standpoint; proved "
     "through the row. On an acyclic relation the condition forces every center to coincide.",
     "在根上，于意义之自闭包读法下，为本行之特化：延续条件（「续无外」）、接纳上的生生之意义与计入每个主张之扩展，读同一谓词即接纳，扩大为文法之「广」；"
     "在「续无外」之下，「广」即从每一立场保留并增加；经本行证明。关系无环时，该条件迫使一切中心重合。"),
    ('significance-retained-within-margin', 'Becoming.Web.widens_iff_retains_adds',
     S + 'widens_iff_retains_adds_root', [S + 'widens_iff_retains_adds_root', ONE],
     "On the root, at the own-closure reading of significance, a specialization of the row: where every formation lies on every center's line under the one of a relation («续无外»), the "
     "grammar's widening, «广», of what the level paths admit is retaining and adding what lies within one's own "
     "line, from any standpoint. On an acyclic relation the condition forces every center to coincide.",
     "在根上，于意义之自闭包读法下，为本行之特化：若每一形成皆在每一中心于一关系之一下的相续上（「续无外」），则水平路径所接纳者之文法之「广」，即从任一立场保留并增加位于自身"
     "相续之内者。关系无环时，该条件迫使一切中心重合。"),
    ('widening-as-what-every-weighting-ranks', 'Becoming.Weighting.widens_iff_every_positive',
     W + 'grammar_widens_iff_every_positive', [W + 'grammar_widens_iff_every_positive'],
     "On the root, on a finite list with two-valued admission and additive natural-number weights positive on every "
     "listed item: the grammar's widening, «广», of what one course admits over another is exactly what every such "
     "weighting ranks higher. The weights are amounts assigned to what is admitted, a second sort the grammar has "
     "none of.",
     "在根上，于有限所列项、二值接纳、及在每一所列项上为正的可加自然数权重之下：一条进程所接纳者对另一条之文法之「广」，恰是每个这样的加权"
     "都排得更高者。权重是赋予所接纳者之量，为文法所无的第二种类。"),
]

# The root forms keeping their row's full generality carry F5's item, model `own` (a web's level paths, or a finite
# list); the three specializations at the own-closure reading carry none.
SPECIALIZATIONS = {'Becoming.unrestricted_iff_livingSignificance', 'Becoming.Web.paths_one_object',
                   'Becoming.Web.widens_iff_retains_adds'}
MODELS = {row: ['own'] for _, row, *_ in LAWS if row not in SPECIALIZATIONS}

# Each law's label (08 §2): the row's own base, which the root form keeps, and, where the root form takes «续无外»
# as a hypothesis, the condition it is conditional on, as GS2's laws are labelled in 07 §4.5.
ROOT_CONDITION = "the root's condition at the one, the own-closure reading"
BASES = {
    'Becoming.unrestricted_iff_livingSignificance': '**Theorem** (World)',
    'Becoming.Web.paths_extension_iff_widens': '**Theorem** (World)',
    'Becoming.Web.paths_comparison_widens': '**Theorem** (World)',
    'Becoming.Web.paths_one_object': f'**Theorem** (World) **and Conditional** ({ROOT_CONDITION})',
    'Becoming.Web.widens_iff_retains_adds': f'**Conditional** ({ROOT_CONDITION})',
    'Becoming.Weighting.widens_iff_every_positive': '**Theorem** (any type)',
}

# The source each declaration is proved in: the leaf, row 10's module beside its anchor, or GrammarScope (GS2).
SOURCES = {S: 'Becoming.SignificanceStatements', W: 'Becoming.Weightings', ONE: 'Becoming.GrammarScope',
           OWN: 'Becoming.GrammarScope'}


def source_of(declaration):
    return next(module for prefix, module in SOURCES.items() if declaration.startswith(prefix))


if __name__ == '__main__':
    assert set(MODELS) | SPECIALIZATIONS == set(BASES) and not set(MODELS) & SPECIALIZATIONS
    for record, row, by, decls, en, zh in LAWS:
        assert by in decls and row not in decls, (record, by)
    over = [(r, len(en), len(zh)) for r, _, _, _, en, zh in LAWS if len(en) > 420 or len(zh) > 190]
    print('records:', len({r for r, *_ in LAWS}), '| laws:', len(LAWS), '| over the caps:', over)
