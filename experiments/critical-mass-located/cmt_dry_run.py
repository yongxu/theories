"""The dry run of CMT (DESIGN.md section 9): python3 -B cmt_dry_run.py, writing results/dry-run.json.

It reads no data. Through cmt_rule.py's own functions it checks:
  - that the location is the Lean's: over small natural games and counts, the rule's f* gives the drawn model's favours
    exactly (drawn_favours_iff, critical_iff), for several a and p (drawn_favours_alike), and its regimes are
    favours_everywhere_iff's and disfavours_strictly_everywhere_iff's; and that no round with one kind absent is classified;
  - planted tables, each with a known answer: a population moving away from f* on both sides (parted from one half);
    the outer starts followed and the inner ones still (both sides, not parted); one moving toward f* from inner
    starts (contradicted) and one doing so from outer starts only (not contradicted, the outer bin reported against); a
    majority rule (contradicted through the inner bins); reversion to one half (unresolved, not parted); a shift pair
    resolved apart in an inner bin (contradicted), apart in an outer bin only (reported, not counted), alike (parted),
    scaled or across studies (no pair); the two everywhere regimes followed and broken; each of the screen's thirteen
    conditions alone (set aside with its reason); too few groups (void); shares at the mass and shares standing still
    (unresolved); one side only (one side); a start near one half (in no bin); a pass from one game's inner bin
    beside a game with outer starts alone (parted, the second game named as not told from a mass at one half), and
    beside a game whose own starts in that bin are too few to test (parted, that game named as not told) or against
    (parted, that game named as not told and listed apart: its own inner bin is against, at the level that would
    contradict the law alone, and the pooled rule does not count it); and beside a game favoured everywhere whose own
    inner starts fall, pooled with one rising (parted, the falling game listed apart in the same words);
  - the refusals: no FROZEN.sha256, one not listing a required file, a frozen file changed, FROZEN.sha256 uncommitted or
    committed twice, the freeze committed after the data or with the search, a readout already there, the cases, the
    codings or the layout missing, the cases uncommitted, a study added or missing, a game or group listed twice, a group
    beyond its coded size or rounds, a cased coding differing from data/codings.json, a coded game dropped, a group
    dropped, its rounds changed or a study set aside after data/layout.json, the search, the codings, the layout and the
    cases out of order or committed more than once, a table not in the layout, a count outside its group, a layout
    carrying choices (refused by the run and by the power tool), and python3 -O;
  - the power and the false verdicts, by simulation with fixed seeds: groups following the bridge (proportional
    imitation of a sampled member's higher payoff, or logit response) under three noise forms (a tremble of play,
    exploration persisting into the held action, logit response) and several numbers of groups, a majority rule, a
    population whose mass lies at 0.9, one whose mass is displaced outward from f* toward the nearer end (which the rule
    cannot tell from f*), and a population that does not revise, each in 100 replications; shift pairs under the bridge
    whose two games' starts lie apart in the outer range (testing only that outer bins do not count) or in the inner
    range (testing the inner-only rule), and one whose shifted game's mass lies at 0.9; two games of different f*, one
    following the bridge from uniform starts and one a majority rule (or the bridge) from starts that seldom reach its
    inner starts (about one group a replication), a game of f* 1/4 following a majority rule from starts in 0.30 to
    0.42, about half of them inner starts in the bin that passes, or a game not revising; and, reported beside them and
    not used, the plan's example (the change from round 1 to round 2) in three of those worlds.
dry-run.json is the same on every run: it holds no timing and no temporary path.

    python3 -B cmt_dry_run.py --layout data/layout.json   # at the run's step 4: the power at the layout, reported only"""
import hashlib
import json
import math
import random
import subprocess
import sys
import tempfile
from fractions import Fraction as Fr
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import cmt_rule as R  # noqa: E402

OUT = HERE / 'results' / 'dry-run.json'
CODE = ['cmt_rule.py', 'cmt_dry_run.py', 'studies.json', 'write_frozen.py']
REPS = 100
N_SIM, T_SIM, REVISE = 12, 10, Fr(1, 2)


def refused(fn, why):
    try:
        fn()
    except SystemExit as e:
        return why in str(e)
    return False


# --- synthetic tables in the layout -----------------------------------------------------------------------------------
def coding(ss, sh, c, hh=None, n=12, t=10, shift_of=None, **over):
    d = {'two_actions_symmetric': True, 'payoff': {'SS': ss, 'SH': sh, 'HS': c, 'HH': c if hh is None else hh},
         'status_quo': 'H', 'matching': 'random pairs', 'constant_parameters': True, 'committed_members': False,
         'communication': False, 'first_game_of_group': True, 'feedback_own_payoff': True, 'independent_groups': True,
         'group_size': n, 'rounds': t, 'shift_of': shift_of}
    d.update(over)
    return d


def game(gid, cod, groups, study='s1', b=None):
    return {'game_id': gid, 'study_id': study, 'codings': {'A': cod, 'B': b if b is not None else dict(cod)},
            'groups': [{'group_id': f'{gid}-{i}', 'size': n, 'adopters': ks} for i, (n, ks) in enumerate(groups)]}


def table(*games):
    return {'layout': R.LAYOUT, 'games': list(games), 'set_aside': []}


def pairs(gm):
    """A game's groups back as (size, adopters) pairs."""
    return [(gr['size'], gr['adopters']) for gr in gm['groups']]


def codings_of(cases):
    """data/codings.json as step 3 would commit it: each game's codings, no choice."""
    return {'layout': R.CODINGS_LAYOUT, 'games': [{'game_id': g['game_id'], 'study_id': g['study_id'],
                                                   'codings': g['codings']} for g in cases['games']]}


def layout_of(cases):
    """data/layout.json as step 4 would commit it: each cased game's groups (ids, sizes, rounds) and the set-asides."""
    return {'layout': R.GROUPS_LAYOUT,
            'games': [{'game_id': g['game_id'], 'study_id': g['study_id'],
                       'groups': [{'group_id': gr['group_id'], 'size': gr['size'], 'rounds': len(gr['adopters'])}
                                  for gr in g['groups']]} for g in cases['games']],
            'set_aside': [dict(a) for a in cases.get('set_aside', [])]}


def with_choices(lay, cases):
    """A layout whose groups carry their choices beside their rounds: what step 4 must not write."""
    ks = {gr['group_id']: gr['adopters'] for g in cases['games'] for gr in g['groups']}
    for g in lay['games']:
        for gr in g['groups']:
            gr['adopters'] = ks[gr['group_id']]
    return lay


def path(k0, step, n=12, t=10):
    """A planted course: k0 adopters, then step at every round, held at 0 and n."""
    return (n, [min(n, max(0, k0 + step * i)) for i in range(t)])


G1 = (12, 0, 3)   # f* = 1/4: above k 4..5 inner, 6..11 outer; below k 1..2, outer (12 members)
G2 = (12, 0, 9)   # f* = 3/4: above k 10..11, outer; below k 7..8 inner, 1..6 outer (12 members)
UP1_IN, UP1_OUT, DOWN1_OUT = [4, 5, 4, 5, 4, 5], [6, 7, 8, 9, 6, 7], [2, 2, 2, 2, 2, 2]
UP2_OUT, DOWN2_IN, DOWN2_OUT = [10] * 6, [7, 8, 7, 8, 7, 8], [6, 5, 4, 3, 2, 6]


def moves(up_in=1, up_out=1, down_in=-1, down_out=-1):
    """Two games' planted groups, each part moving by its step: the law's direction is +1 above and -1 below."""
    g1 = ([path(k, up_in) for k in UP1_IN] + [path(k, up_out) for k in UP1_OUT] +
          [path(k, down_out) for k in DOWN1_OUT])
    g2 = ([path(k, up_out) for k in UP2_OUT] + [path(k, down_in) for k in DOWN2_IN] +
          [path(k, down_out) for k in DOWN2_OUT])
    return game('g1', coding(*G1), g1), game('g2', coding(*G2), g2)


TOLD = 'bistable games told from a mass at one half: own bin predicted in a pooled inner bin predicted'
NOT_TOLD = ('bistable games not told from a mass at one half: no start, not testable or unresolved there, or against '
            '(each game against there is also listed under its own inner bin against)')
OWN_OUTER = 'bistable games, own outer bins: told from reversion to one half only on a side predicted'
AGAINST_ALONE = ('admitted games whose own inner bin is against, in any of the four inner bins: at the level that would '
                 'contradict the law alone; the pooled rule counts it only where the pooled bin is against too')
PLAIN = "this game's own inner bin is against, at the level that would contradict the law alone; the pooled rule does not count it"
POOLED_TOO = ("this game's own inner bin is against, at the level that would contradict the law alone; here the pooled "
              'bin is against too, and contradicts')


def located_games():
    return list(moves())


def verdict_of(cases):
    return R.evaluate(cases, sorted({g['study_id'] for g in cases['games']} |
                                    {s['study_id'] for s in cases.get('set_aside', [])}))


def res(v, *bins):
    return tuple(v['bins'][b]['result'] for b in bins)


SCREEN_PLANTS = [  # one condition each, with the reason it must give
    ({'two_actions_symmetric': False}, None, '(a) not a symmetric game of two actions'),
    ({}, dict(hh=5), "(b) the status quo's payoff depends on the partner"),
    ({'matching': 'fixed partners'}, None, '(c) not well-mixed counting (random pairs or mean matching)'),
    ({'independent_groups': False}, None, '(c) matching groups not independent'),
    ({'constant_parameters': False}, None, '(d) payoffs not constant over the rounds'),
    ({'committed_members': True}, None, '(e) committed members, confederates or programmed players'),
    ({'communication': True}, None, '(e) communication or another stage'),
    ({'first_game_of_group': False}, None, "(e) not the group's first game"),
    ({'feedback_own_payoff': False}, None, '(e) no feedback of the own payoff'),
    ({}, 'lo > hi', '(f) lo > hi: the rule read reads against the share (drawn_against)'),
    ({'group_size': 3}, None, '(g) matching groups smaller than 4'),
    ({'rounds': 2}, None, '(g) fewer than 3 rounds'),
]


def plants():
    out = {}
    v = verdict_of(table(*located_games()))
    out['moving away from f* on both sides: parted from one half'] = (
        v['verdict'] == 'parted from one half'
        and res(v, 'above, inner', 'above, outer', 'below, inner', 'below, outer') == ('predicted',) * 4
        and v['outer bins against'] == [])
    v = verdict_of(table(*moves(up_in=0, down_in=0)))
    out['the outer starts followed, the inner ones still: both sides, not parted'] = (
        v['verdict'] == 'both sides'
        and res(v, 'above, outer', 'below, outer') == ('predicted', 'predicted'))
    v = verdict_of(table(*moves(up_in=-1)))
    out['falling at inner starts above f*: contradicted, the above inner bin against'] = (
        v['verdict'] == 'contradicted' and res(v, 'above, inner') == ('against',))
    v = verdict_of(table(*moves(down_in=1)))
    out['rising at inner starts below f*: contradicted, the below inner bin against'] = (
        v['verdict'] == 'contradicted' and res(v, 'below, inner') == ('against',))
    v = verdict_of(table(*moves(up_out=-1)))
    out['falling at outer starts above f* only: not contradicted, one side, the outer bin against reported'] = (
        v['verdict'] == 'one side' and v['outer bins against'] == ['above, outer'])
    v = verdict_of(table(*moves(up_in=-1, down_in=1)))
    out['a majority rule (the mass at one half): contradicted through both inner bins, no outer bin against'] = (
        v['verdict'] == 'contradicted' and res(v, 'above, inner', 'below, inner') == ('against', 'against')
        and v['outer bins against'] == [])
    v = verdict_of(table(*moves(up_out=-1, down_out=1)))
    out['reversion to one half (no revision, exploration persisting): unresolved, not parted, both outer bins against'] = (
        v['verdict'] == 'unresolved'
        and v['outer bins against'] == ['above, outer', 'below, outer']
        and res(v, 'above, inner', 'below, inner') == ('predicted', 'predicted'))
    g1 = located_games()[0]
    g1s = game('g1s', coding(17, 5, 8, shift_of='g1'), [path(k, -1) for k in UP1_IN + UP1_OUT] +
               [path(k, 1) for k in DOWN1_OUT])
    v = verdict_of(table(g1, g1s))
    out['a shift pair resolved apart in an inner bin at one f*: contradicted, the bins pooled not against'] = (
        v['verdict'] == 'contradicted' and len(v['shift pairs']) == 1
        and v['shift pairs'][0]['inner bins resolved apart'] == ['above, inner']
        and v['shift pairs'][0]['outer bins resolved apart, not counted'] == ['above, outer', 'below, outer']
        and all(b['result'] != 'against' for b in v['bins'].values()))
    g1o = game('g1', coding(*G1), [path(k, -1) for k in [10, 11, 10, 11, 10, 11]])
    g1so = game('g1s', coding(17, 5, 8, shift_of='g1'), [path(k, 1) for k in [7, 8, 7, 8, 7, 8]])
    v = verdict_of(table(g1o, g1so))
    out['a shift pair apart in an outer bin only (starts near 1 falling, starts near 2/3 rising): reported, not contradicted'] = (
        v['verdict'] != 'contradicted' and v['shift pairs'][0]['inner bins resolved apart'] == []
        and v['shift pairs'][0]['outer bins resolved apart, not counted'] == ['above, outer'])
    g1a = game('g1s', coding(17, 5, 8, shift_of='g1'), pairs(located_games()[0]))
    v = verdict_of(table(g1, g1a))
    out['a shift pair alike: parted from one half, nothing resolved apart'] = (
        v['verdict'] == 'parted from one half' and v['shift pairs'][0]['inner bins resolved apart'] == []
        and v['shift pairs'][0]['outer bins resolved apart, not counted'] == [])
    g1x = game('g1x', coding(24, 0, 6, shift_of='g1'), pairs(g1s))
    v = verdict_of(table(g1, g1x))
    out['a scaled pair coded as a shift (24, 0, 6 against 12, 0, 3, both f* 1/4): no shift pair, not contradicted'] = (
        v['shift pairs'] == [] and v['verdict'] != 'contradicted')
    g1t = dict(g1s, study_id='s2')
    v = verdict_of(table(g1, g1t))
    out['a shift coded across two studies: no shift pair, not contradicted'] = (
        v['shift pairs'] == [] and v['verdict'] != 'contradicted')
    fav = game('g3', coding(12, 2, 1), [path(k, 1) for k in [1, 3, 5, 2, 4, 5, 6, 7, 8, 9, 10, 6]])
    dis = game('g4', coding(12, 0, 12), [path(k, -1) for k in [7, 8, 9, 10, 10, 7, 6, 5, 4, 3, 2, 6]])
    v = verdict_of(table(fav, dis))
    out['the everywhere regimes followed: every regime bin predicted, beside the location void'] = (
        v['verdict'] == 'void' and v['regime bins predicted'] == [b for b in R.BINS if b.startswith('everywhere')]
        and [g['regime'] for g in v['games']] == ['everywhere favoured', 'everywhere disfavoured'])
    v = verdict_of(table(game('g3', coding(12, 2, 1), [path(k, -1) for k in [2, 3, 5, 4, 5, 3]])))
    out['favoured everywhere, yet falling from inner starts: contradicted'] = (
        v['verdict'] == 'contradicted' and res(v, 'everywhere favoured, inner') == ('against',))
    reasons = []
    for over, extra, why in SCREEN_PLANTS:
        if extra == 'lo > hi':
            cod = coding(5, 12, 3, **over)
        else:
            cod = coding(*G1, **(extra or {}), **over)
        t = cod['rounds'] if isinstance(cod['rounds'], int) else 10
        vv = verdict_of(table(game('g1', cod, [path(k, 1, t=t) for k in UP1_IN + UP1_OUT])))
        reasons.append(vv['games'][0]['admitted'] is False and vv['games'][0]['set aside'] == [why]
                       and vv['verdict'] == 'void')
    vv = verdict_of(table(game('g5', coding(*G2), [path(k, 1) for k in UP2_OUT], b=coding(12, 0, 8))))
    reasons.append(vv['games'][0]['set aside'] == ['the deciding codings differ'] and vv['verdict'] == 'void')
    out['each of the screen\'s thirteen conditions alone (twelve items and coders who differ): set aside with its reason, void'] = (
        len(reasons) == 13 and all(reasons))
    v = verdict_of(table(game('g1', coding(*G1), [path(k, 1) for k in [6, 7, 8]] + [path(k, -1) for k in [2, 2]])))
    out['too few groups (5): void by the layout, before any choice'] = (
        v['verdict'] == 'void' and v['layout']['void by layout'] and v['layout']['bistable groups usable'] == 5)
    v = verdict_of(table(game('g1', coding(*G1), [(12, [3] * 10)] * 8)))
    out['every share at the mass: unresolved, nothing classified'] = (
        v['verdict'] == 'unresolved' and all(b['groups'] == 0 for b in v['bins'].values()))
    v = verdict_of(table(game('g1', coding(*G1), [(12, [8] * 10)] * 8)))
    out['shares standing still above: unresolved, every group a zero'] = (
        v['verdict'] == 'unresolved' and v['bins']['above, outer']['zero'] == 8)
    v = verdict_of(table(game('g1', coding(*G1), [path(k, 1) for k in [6, 7, 8, 9, 6, 7, 8]] + [(12, [3] * 10)] * 2)))
    out['above followed, below unseen: one side'] = v['verdict'] == 'one side'
    v = verdict_of(table(game('g1', coding(*G1), [path(5, 1, n=11)] * 6)))
    out['a start near one half (5 of 11 at f* 1/4): classified, in no bin'] = (
        v['games'][0]['groups classified near one half, in no bin'] == 6
        and all(b['groups'] == 0 for b in v['bins'].values()))
    # reader round 4: the pass from g1's above, inner bin; g2 has outer starts alone, which a majority rule moves alike
    g2m = game('g2', coding(*G2), [path(k, 1) for k in UP2_OUT] + [path(k, -1) for k in DOWN2_OUT])
    v = verdict_of(table(located_games()[0], g2m))
    out['a pass from one game\'s inner bin, the other game with outer starts alone: parted, the other named as not told from one half'] = (
        v['verdict'] == 'parted from one half' and v['inner bins predicted, pooled'] == ['above, inner']
        and list(v[TOLD]) == ['g1'] and v[TOLD]['g1']['above, inner']['own result'] == 'predicted'
        and v[NOT_TOLD] == {'g2': {'above, inner': {'groups': 0, 'own result': 'no start'}}}
        and v[OWN_OUTER]['g2']['above, outer']['own result'] == 'predicted'
        and v[OWN_OUTER]['g2']['below, outer']['own result'] == 'predicted')
    # reader round 5: a game with starts in the pooled inner bin predicted is told only where its own bin there is
    # predicted; g2 (24, 0, 6), f* 1/4 too, its inner starts too few to test (3) or moving against (6), is not told
    g1m = game('g1', coding(*G1), [path(k, 1) for k in [4, 5] * 10] + [path(k, 1) for k in UP1_OUT]
               + [path(k, -1) for k in DOWN1_OUT])
    for n_in, own_result in ((3, 'not testable'), (6, 'against')):
        g2f = game('g2', coding(24, 0, 6), [path(k, -1) for k in [4, 5, 4, 5, 4, 5][:n_in]]
                   + [path(k, 1) for k in UP1_OUT] + [path(k, -1) for k in DOWN1_OUT])
        v = verdict_of(table(g1m, g2f))
        own = v[NOT_TOLD].get('g2', {}).get('above, inner', {})
        out[f'a pass beside a game whose own inner starts there are {own_result} ({n_in} falling): parted, '
            'that game named as not told from one half, with its signs'] = (
            v['verdict'] == 'parted from one half' and v['inner bins predicted, pooled'] == ['above, inner']
            and list(v[TOLD]) == ['g1'] and list(v[NOT_TOLD]) == ['g2']
            and own == {'groups': n_in, 'predicted sign': 0, 'against': n_in, 'zero': 0, 'own result': own_result})
        # reader round 6: at 6 falling, g2's own inner bin is against at the level that would contradict alone; the
        # readout names it as such, in plain words, while the pooled bin stays predicted and the verdict parted
        expect = ({'g2': {'above, inner': {'groups': 6, 'predicted sign': 0, 'against': 6, 'zero': 0,
                                           'own result': 'against', 'pooled result': 'predicted',
                                           'what it shows': PLAIN}}} if n_in == 6 else {})
        out[f'the same pass, {n_in} falling: g2 listed among the games whose own inner bin is against, in plain words, '
            'only where it is'] = v[AGAINST_ALONE] == expect
    # reader round 6: the field is filled under any verdict; where the pooled inner bin is against too, it says so
    v = verdict_of(table(game('g1', coding(*G1), [path(k, -1) for k in [4, 5] * 3] + [path(k, 1) for k in UP1_OUT]
                              + [path(k, -1) for k in DOWN1_OUT])))
    out['a game falling from inner starts above: contradicted, and listed among the games whose own inner bin is against'] = (
        v['verdict'] == 'contradicted' and list(v[AGAINST_ALONE]) == ['g1']
        and v[AGAINST_ALONE]['g1']['above, inner']['pooled result'] == 'against'
        and v[AGAINST_ALONE]['g1']['above, inner']['what it shows'] == POOLED_TOO)
    # reader round 7: the field covers every admitted game's own inner bin, an everywhere regime's too. g4, favoured
    # everywhere (12, 2, 1), its 6 inner starts falling, pools with g3, favoured everywhere and rising from 20 inner
    # starts, so the pooled 'everywhere favoured, inner' bin is predicted, and beside g1 and g2 the verdict is parted;
    # g4 must still be listed, in plain words
    g3r = game('g3', coding(12, 2, 1), [path(k, 1) for k in [1, 2, 3, 4, 5] * 4])
    g4f = game('g4', coding(12, 2, 1), [path(k, -1) for k in [2, 3, 4, 5, 2, 3]])
    v = verdict_of(table(*located_games(), g3r, g4f))
    out['a pass beside a game favoured everywhere (12, 2, 1) whose 6 inner starts fall, pooled with one rising: parted, '
        'the pooled regime bin predicted, the falling game listed among the games whose own inner bin is against'] = (
        v['verdict'] == 'parted from one half' and res(v, 'everywhere favoured, inner') == ('predicted',)
        and v[AGAINST_ALONE] == {'g4': {'everywhere favoured, inner': {
            'groups': 6, 'predicted sign': 0, 'against': 6, 'zero': 0, 'own result': 'against',
            'pooled result': 'predicted', 'what it shows': PLAIN}}})
    return out


def lean_location():
    """The rule's f* against the drawn model's counts (RuleShaping.shaped pooled by ClosedCapture.Drawn.pool)."""
    ok_fav, ok_strict, ok_regime, cases = True, True, True, 0
    for hi in range(7):
        for lo in range(hi + 1):
            for c in range(8):
                for a in (1, 5):
                    for p in (0, 3):
                        base = a + p
                        cod = coding(base + hi, base + lo, base + c)
                        regime, f = R.location(cod)
                        for car in range(1, 7):
                            for oth in range(1, 7):
                                cases += 1
                                up = car * (a + hi + p) + oth * (a + lo + p)
                                down = (car + oth) * (a + c + p)
                                x = Fr(car, car + oth)
                                if f is None:
                                    fav, strict = lo >= c, lo > c
                                else:
                                    fav, strict = x >= f, x > f
                                ok_fav &= (up >= down) == fav
                                ok_strict &= (up > down) == strict
                if lo < hi:
                    regime, f = R.location(coding(hi, lo, c))
                    ok_regime &= ((regime == 'everywhere favoured') == (c <= lo and c <= hi) and
                                  (regime == 'everywhere disfavoured') == (lo < c and hi <= c) and
                                  (regime == 'bistable') == (lo < c < hi))
                    if regime == 'bistable':
                        ok_regime &= f == Fr(c - lo, hi - lo)
    ends = all(R.side(k, n, 'bistable', Fr(1, 2)) == 0 for n in range(2, 20) for k in (0, n))
    return {'favours exactly where the share is at least f* (drawn_favours_iff, critical_iff), a and p moving nothing':
            ok_fav, 'strictly exactly where above f*': ok_strict,
            'the regimes are critical_mass_iff, favours_everywhere_iff and disfavours_strictly_everywhere_iff': ok_regime,
            'no round with one kind absent is classified': ends, 'cases enumerated': cases}


RUNS = [  # (name, the commits in order, the refusal or None); a step ending in None is written and not committed
    ('a run with the freeze, then the search, codings, layout and cases each committed once: parted from one half, the freeze an '
     'ancestor of the search', [['freeze'], ['search'], ['codings'], ['layout'], ['cases']], None),
    ('no cases: refused', [['freeze'], ['search'], ['codings'], ['layout']], 'no data/cases.json'),
    ('the cases uncommitted: refused', [['freeze'], ['search'], ['codings'], ['layout'], ['cases', None]],
     'cases.json is uncommitted'),
    ('no codings at the run: refused', [['freeze'], ['search'], ['layout'], ['cases']], 'no data/codings.json'),
    ('no layout at the run: refused', [['freeze'], ['search'], ['codings'], ['cases']], 'no data/layout.json'),
    ('the data committed before the freeze: refused', [['search'], ['codings'], ['layout'], ['cases'], ['freeze']],
     'the freeze was not committed before data/search.json'),
    ('the freeze committed with the search: refused', [['freeze', 'search'], ['codings'], ['layout'], ['cases']],
     'the freeze was not committed before data/search.json'),
    ('a layout carrying choices, committed in order: refused by the run',
     [['freeze'], ['search'], ['codings'], ['layout, carrying choices'], ['cases']], 'carries keys beyond'),
]


def run_in_repo(r, steps):
    """A repository with the freeze and the data committed in the order given; returns the run and its readout path."""
    x = r / 'x'
    d = x / 'data'
    d.mkdir(parents=True)
    (x / 'results').mkdir()

    def g(*a):
        subprocess.run(['git', '-C', str(r), *a], capture_output=True, text=True, check=True)
    g('init', '-q')
    g('config', 'user.email', 'dry@run')
    g('config', 'user.name', 'dry run')
    (x / 'studies.json').write_text(json.dumps({'studies': [{'id': 's1'}]}))
    (x / 'a.py').write_text('a\n')
    g('add', '-A')
    g('commit', '-q', '-m', 'studies')
    t = table(*located_games())
    t['set_aside'] = [{'study_id': 'h1', 'reason': 'a deposit of s1, recorded apart'}]
    files = {'freeze': (x / 'FROZEN.sha256', R.sha(x / 'a.py') + '  x/a.py\n'),
             'search': (d / 'search.json', json.dumps({'hits': [{'id': 'h1'}]})),
             'codings': (d / 'codings.json', json.dumps(codings_of(t))),
             'layout': (d / 'layout.json', json.dumps(layout_of(t))),
             'layout, carrying choices': (d / 'layout.json', json.dumps(with_choices(layout_of(t), t))),
             'cases': (d / 'cases.json', json.dumps(t))}
    for step in steps:
        commit = step[-1] is not None
        for f in (step if commit else step[:-1]):
            files[f][0].write_text(files[f][1])
        if commit:
            g('add', '-A')
            g('commit', '-q', '-m', ', '.join(step))
    readout = x / 'results' / 'readout.json'
    run = lambda: R.run(readout, d / 'cases.json', r,  # noqa: E731
                        lambda: R.frozen_check(x / 'FROZEN.sha256', r, ['x/a.py']),
                        lambda: R.closed_list(r, x / 'studies.json', d / 'search.json', d / 'cases.json',
                                              d / 'codings.json', d / 'layout.json'),
                        d / 'codings.json', d / 'layout.json')
    return run, readout


# --- the refusals -----------------------------------------------------------------------------------------------------
def refusals():
    rf = {}
    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        x = root / 'x'
        (x / 'data').mkdir(parents=True)
        (x / 'results').mkdir()
        fz = x / 'FROZEN.sha256'

        def g(*a):
            subprocess.run(['git', '-C', str(root), *a], capture_output=True, text=True, check=True)
        g('init', '-q')
        g('config', 'user.email', 'dry@run')
        g('config', 'user.name', 'dry run')
        (x / 'a.py').write_text('a\n')
        (x / 'b.py').write_text('b\n')
        rf['no FROZEN.sha256: refused'] = refused(lambda: R.frozen_check(fz, root, ['x/a.py']), 'no FROZEN.sha256')
        fz.write_text(R.sha(x / 'a.py') + '  x/a.py\n')
        g('add', '-A')
        g('commit', '-q', '-m', 'freeze')
        rf['the freeze as committed: accepted'] = R.frozen_check(fz, root, ['x/a.py'])[0] == {'x/a.py': R.sha(x / 'a.py')}
        rf['a required file not listed: refused'] = refused(lambda: R.frozen_check(fz, root, ['x/a.py', 'x/b.py']),
                                                            'does not list')
        (x / 'a.py').write_text('a changed\n')
        rf['a frozen file changed: refused'] = refused(lambda: R.frozen_check(fz, root, ['x/a.py']), 'differs from FROZEN.sha256')
        g('checkout', '-q', '--', 'x/a.py')
        fz.write_text(fz.read_text() + '\n')
        rf['FROZEN.sha256 itself uncommitted: refused'] = refused(lambda: R.frozen_check(fz, root, ['x/a.py']),
                                                                  'uncommitted or changed')
        g('add', 'x/FROZEN.sha256')
        g('commit', '-q', '-m', 'again')
        rf['FROZEN.sha256 committed twice: refused'] = refused(lambda: R.frozen_check(fz, root, ['x/a.py']), 'has 2 commits')
        rf['a study added to the closed list: refused (enlarged)'] = refused(
            lambda: R.evaluate(table(*located_games()), []), 'the run is enlarged')
        rf['a listed study neither cased nor set aside: refused (incomplete)'] = refused(
            lambda: R.evaluate(table(*located_games()), ['s1', 's2']), 'the run is incomplete')
        t = table(*located_games())
        t['set_aside'] = [{'study_id': 's2', 'reason': '(a) three actions'}]
        rf['a listed study set aside with its reason: accepted'] = R.evaluate(t, ['s1', 's2'])['verdict'] == 'parted from one half'
        t['set_aside'] = [{'study_id': 's2', 'reason': ''}]
        rf['a study set aside with no reason: refused'] = refused(lambda: R.evaluate(t, ['s1', 's2']), 'with no reason')
        t = table(*located_games())
        t['layout'] = 'other'
        rf['a table in another layout: refused'] = refused(lambda: R.evaluate(t, ['s1']), 'not in layout')
        t = table(*located_games())
        t['games'][0]['groups'][0]['adopters'][3] = 13
        rf['a count above its group: refused'] = refused(lambda: R.evaluate(t, ['s1']), 'outside 0..size')
        t = table(*located_games())
        t['games'][0]['codings']['A']['extra'] = 1
        rf['a coding with keys beyond the form: refused'] = refused(lambda: R.evaluate(t, ['s1']), 'other than the layout')
        t = table(*located_games())
        t['games'].append(json.loads(json.dumps(t['games'][0])))
        rf['a game listed twice: refused'] = refused(lambda: R.evaluate(t, ['s1']), 'listed twice')
        t = table(*located_games())
        t['games'][0]['groups'].append(dict(t['games'][0]['groups'][0]))
        rf['a group listed twice in a game: refused'] = refused(lambda: R.evaluate(t, ['s1']), 'a group listed twice')
        t = table(*located_games())
        t['games'][0]['groups'][0] = {'group_id': 'g1-0', 'size': 14, 'adopters': [4] + [5] * 9}
        rf['a group larger than the coded group size: refused'] = refused(lambda: R.evaluate(t, ['s1']),
                                                                         'more members or rounds')
        t = table(*located_games())
        t['games'][0]['groups'][0]['adopters'].append(12)
        rf['a group with more rounds than the coded rounds: refused'] = refused(lambda: R.evaluate(t, ['s1']),
                                                                               'more members or rounds')
        t = table(*located_games())
        cd = codings_of(t)
        rf['the codings as committed: accepted'] = R.coded_as_committed(t, cd) is None
        cd2 = json.loads(json.dumps(cd))
        cd2['games'][0]['codings']['A']['first_game_of_group'] = False
        cd2['games'][0]['codings']['B']['first_game_of_group'] = False
        rf['a cased coding edited after the codings were committed: refused'] = refused(
            lambda: R.coded_as_committed(t, cd2), 'differ from those committed')
        t2 = table(*located_games())
        t2['games'] = t2['games'][:1]
        rf['a coded game dropped from the cases, its study cased: refused'] = refused(
            lambda: R.coded_as_committed(t2, cd), 'neither cased nor its study set aside whole')
        cd3 = json.loads(json.dumps(cd))
        cd3['games'].append(json.loads(json.dumps(cd3['games'][0])))
        rf['a game coded twice: refused'] = refused(lambda: R.coded_as_committed(t, cd3), 'coded twice')
        t3 = {'layout': R.LAYOUT, 'games': [], 'set_aside': [{'study_id': 's1', 'reason': 'no per-round data'}]}
        rf['coded games of a study set aside whole: accepted'] = R.coded_as_committed(t3, cd) is None
        t = table(*moves(up_in=-1))
        t['set_aside'] = [{'study_id': 's2', 'reason': '(a) three actions'}]
        lay = layout_of(t)
        rf['the cases as laid out: accepted'] = R.as_laid_out(t, lay) is None
        t4 = json.loads(json.dumps(t))
        t4['games'][0]['groups'] = [gr for gr in t4['games'][0]['groups']
                                    if gr['adopters'][0] not in UP1_IN]   # the six inner groups above, falling
        rf["the reader's plant: a contradicted table's six inner groups dropped gives parted from one half"] = (
            R.evaluate(t, ['s1', 's2'])['verdict'] == 'contradicted'
            and R.evaluate(t4, ['s1', 's2'])['verdict'] == 'parted from one half')
        rf['groups dropped from the cases after the layout: refused'] = refused(
            lambda: R.as_laid_out(t4, lay), 'differ from data/layout.json')
        t5 = json.loads(json.dumps(t))
        t5['games'][1]['groups'][0]['adopters'].pop()
        rf["a group's rounds changed after the layout: refused"] = refused(
            lambda: R.as_laid_out(t5, lay), 'differ from data/layout.json')
        t6 = json.loads(json.dumps(t))
        t6['games'] = t6['games'][:1]
        t6['set_aside'].append({'study_id': 's1', 'reason': 'no per-group per-round choices'})
        rf['a game removed and its study set aside after the layout: refused'] = refused(
            lambda: R.as_laid_out(t6, lay), 'differ from data/layout.json')
        t7 = json.loads(json.dumps(t))
        t7['set_aside'] = [{'study_id': 's2', 'reason': 'no per-group per-round choices'}]
        rf["a set-aside's reason changed after the layout: refused"] = refused(
            lambda: R.as_laid_out(t7, lay), 'the studies set aside differ')
        lay2 = dict(lay, layout='other')
        rf['a layout in another layout: refused'] = refused(lambda: R.as_laid_out(t, lay2), 'not in layout')
        for where, edit in (('a group', lambda L: L['games'][0]['groups'][0].update(adopters=[4, 5, 4])),
                            ('a game', lambda L: L['games'][0].update(adopters_total=[40, 41])),
                            ('a set-aside', lambda L: L['set_aside'][0].update(adopters=[1])),
                            ('the layout', lambda L: L.update(choices=[]))):
            lay3 = json.loads(json.dumps(lay))
            edit(lay3)
            rf[f'a layout carrying choices in {where}, at the run: refused'] = refused(
                lambda: R.as_laid_out(t, lay3), 'carries keys beyond')
    with tempfile.TemporaryDirectory() as tmp:
        for name, steps, why in RUNS:
            run, readout = run_in_repo(Path(tmp) / f'run{len(rf)}', steps)
            if why is None:
                r = run()
                rf[name] = (readout.exists() and r['verdict'] == 'parted from one half'
                            and r['the freeze a strict ancestor of the search'] is True and len(r['commits']) == 6)
                rf['a readout already there: refused'] = refused(run, 'is there')
            else:
                rf[name] = refused(run, why)
    with tempfile.TemporaryDirectory() as tmp:
        base = Path(tmp)
        seq = {'search': json.dumps({'hits': [{'id': 'h1'}, {'id': 'h2'}]}),
               'search, a hit removed': json.dumps({'hits': [{'id': 'h1'}]}),
               'codings': json.dumps(codings_of(table(*located_games()))),
               'codings, edited': json.dumps(codings_of(table(game('g1', coding(*G1, first_game_of_group=False),
                                                                    pairs(located_games()[0])),
                                                               located_games()[1]))),
               'layout': json.dumps(layout_of(table(*located_games()))),
               'layout, edited': json.dumps(layout_of(table(located_games()[0]))),
               'cases': json.dumps(table(*located_games())),
               'cases, edited': json.dumps(table(*moves(up_in=-1)))}
        orders = [
            ('the search, codings, layout and cases committed once each, in order: the hits on the closed list',
             [['search'], ['codings'], ['layout'], ['cases']], None),
            ('no search: refused', [['codings'], ['layout'], ['cases']], 'no data/search.json'),
            ('the search uncommitted: refused', [['codings'], ['layout'], ['cases'], ['search', None]],
             'search.json is uncommitted'),
            ('the search committed with the codings, layout and cases: refused', [['search', 'codings', 'layout', 'cases']],
             'search.json was not committed before data/codings.json'),
            ('the search committed after the cases: refused', [['codings'], ['layout'], ['cases'], ['search']],
             'search.json was not committed before data/codings.json'),
            ('a hit removed from the search after the cases were committed: refused',
             [['search'], ['codings'], ['layout'], ['cases'], ['search, a hit removed']], 'search.json has 2 commits'),
            ('no codings: refused', [['search'], ['layout'], ['cases']], 'no data/codings.json'),
            ('the codings committed with the layout and cases: refused', [['search'], ['codings', 'layout', 'cases']],
             'codings.json was not committed before data/layout.json'),
            ('the codings committed after the cases: refused', [['search'], ['layout'], ['cases'], ['codings']],
             'codings.json was not committed before data/layout.json'),
            ('the codings committed twice: refused',
             [['search'], ['codings'], ['codings, edited'], ['layout'], ['cases']], 'codings.json has 2 commits'),
            ('no layout: refused', [['search'], ['codings'], ['cases']], 'no data/layout.json'),
            ('the layout committed with the cases: refused', [['search'], ['codings'], ['layout', 'cases']],
             'layout.json was not committed before data/cases.json'),
            ('the layout committed after the cases: refused', [['search'], ['codings'], ['cases'], ['layout']],
             'layout.json was not committed before data/cases.json'),
            ('the layout committed twice: refused',
             [['search'], ['codings'], ['layout'], ['layout, edited'], ['cases']], 'layout.json has 2 commits'),
            ('the cases committed twice: refused', [['search'], ['codings'], ['layout'], ['cases'], ['cases, edited']],
             'cases.json has 2 commits'),
        ]
        for i, (name, steps, why) in enumerate(orders):
            r2 = base / f'r{i}'
            d2 = r2 / 'x' / 'data'
            d2.mkdir(parents=True)
            g2 = lambda *a: subprocess.run(['git', '-C', str(r2), *a], capture_output=True, text=True, check=True)  # noqa: E731,E501
            g2('init', '-q')
            g2('config', 'user.email', 'dry@run')
            g2('config', 'user.name', 'dry run')
            st2 = r2 / 'x' / 'studies.json'
            st2.write_text(json.dumps({'studies': [{'id': 's1'}]}))
            g2('add', '-A')
            g2('commit', '-q', '-m', 'studies')
            for step in steps:
                commit = step[-1] is not None
                for f in (step if commit else step[:-1]):
                    (d2 / (f.split(',')[0] + '.json')).write_text(seq[f])
                if commit:
                    g2('add', '-A')
                    g2('commit', '-q', '-m', ', '.join(step))
            call = lambda: R.closed_list(r2, st2, d2 / 'search.json', d2 / 'cases.json', d2 / 'codings.json',  # noqa: E731
                                         d2 / 'layout.json')
            if why is None:
                ids, order = call()
                rf[name] = ids == ['s1', 'h1', 'h2'] and len(order) == 4
            else:
                rf[name] = refused(call, why)
    o = subprocess.run([sys.executable, '-O', '-B', '-c', f'import sys; sys.path.insert(0, {str(HERE)!r}); import cmt_rule'],
                       capture_output=True, text=True)
    rf['python3 -O: refused'] = o.returncode != 0 and 'refused: run without -O' in o.stderr
    with tempfile.TemporaryDirectory() as tmp:
        d = Path(tmp)
        # g9 set aside by item (f); g10 admitted with SS = SH (reader round 4) and g11 favoured everywhere at f* below 0
        t = table(*located_games(), game('g9', coding(5, 12, 3), [path(6, 1)] * 2),
                  game('g10', coding(6, 6, 3), [path(6, 1)] * 2), game('g11', coding(12, 2, 1), [path(6, 1)] * 2))
        (d / 'codings.json').write_text(json.dumps(codings_of(t)))
        (d / 'layout.json').write_text(json.dumps(layout_of(t)))
        rows = layout_power(d / 'layout.json', reps=2, out=d / 'layout-power.json')
        def raises(g):
            try:
                simulate_group(random.Random(0), g, 'mass at 0.10 and 0.90', 0.05)
            except ValueError:
                return True
            return False
        rf['the fixed outward rival refused where SS = SH or f* lies outside 0.10 to 0.90, allowed at f* 1/4 and 3/4'] = (
            raises((6.0, 6.0, 3.0)) and raises((12.0, 0.0, 0.6)) and raises((12.0, 2.0, 1.0))
            and not raises(tuple(map(float, G1))) and not raises(tuple(map(float, G2))))
        rf['the power at a layout (an SS = SH game and an everywhere game admitted): the admitted games simulated, '
           'the outward rival placed by f*, written beside, deciding nothing'] = (
            len(rows) == 10 and all(sum(r['verdicts'].values()) == 2 for r in rows)
            and json.loads((d / 'layout-power.json').read_text())['admitted games'] == ['g1', 'g2', 'g10', 'g11'])
        bad = layout_of(t)
        bad['games'][0]['groups'][0]['adopters'] = [1, 2]
        (d / 'layout.json').write_text(json.dumps(bad))
        rf['a layout carrying choices: refused'] = refused(
            lambda: layout_power(d / 'layout.json', reps=2, out=d / 'layout-power.json'), 'sizes and rounds alone')
    rf["the required paths are the folder's, from the repository's root"] = all(
        p.startswith(R.FOLDER + '/') for p in R.REQUIRED) and all(
        (R.ROOT / p).exists() for p in R.REQUIRED if not p.endswith('dry-run.json'))
    return rf


# --- the power, by simulation -----------------------------------------------------------------------------------------
def perm(rng, n):
    a = list(range(n))
    for i in range(n - 1, 0, -1):
        j = int(rng.random() * (i + 1))
        a[i], a[j] = a[j], a[i]
    return a


def simulate_group(rng, g, pop, eps, n=N_SIM, t=T_SIM, revise=float(REVISE), noise='tremble', start=(0.05, 0.9)):
    """One matching group: random pairs each round, then revision, read with the status quo's payoff the population's
    own (bridge), or one placing the mass at one half (majority) or at 0.9 (mass at 0.9), or displaced outward from f*
    toward the nearer end ('mass at 0.10 and 0.90': at 0.10 where f* < 1/2, at 0.90 otherwise, only in a bistable game
    whose f* lies strictly between the two, so that the mass lies outward; 'mass displaced outward': at f*/2 where
    f* < 1/2 and (1 + f*)/2 otherwise in a bistable game, the bridge in a game of another regime, which has no mass to
    displace); 'still' does not revise.
    The noise has three forms. 'tremble': each member's play departs from the held action at rate eps, at random, and
    the held action changes only by imitation (proportional imitation, Schlag, of a sampled other's higher payoff).
    'persist': each member's held action is replaced by a random one at rate eps before each round's play, so that
    exploration persists into the state (Kandori, Mailath and Rob's mutation), then the same imitation. 'logit': each
    revising member takes the new practice with chance 1 / (1 + exp(-eps * (its expected payoff against the others'
    play - the status quo's payoff))), eps the logit's precision per payoff unit. The group's start share is drawn
    uniformly from start[0] to start[0] + start[1]."""
    ss, sh, c = g
    q0 = start[0] + start[1] * rng.random()
    held = [1 if rng.random() < q0 else 0 for _ in range(n)]
    f = (c - sh) / (ss - sh) if ss > sh else None   # f*, None where the two readings are alike (SS = SH)
    if pop.startswith('mass at ') and ' and ' in pop:   # the mass displaced outward: toward 0 where f* < 1/2, else 1
        near0, near1 = (float(x) for x in pop[len('mass at '):].split(' and '))
        if f is None or not near0 < f < near1:
            raise ValueError(f'{pop}: outward only in a bistable game whose f* lies strictly between {near0} and {near1}')
        seen_c = sh + (near0 if f < 0.5 else near1) * (ss - sh)
    elif pop == 'mass displaced outward':
        seen_c = c if f is None or not 0 < f < 1 else sh + (f / 2 if f < 0.5 else (1 + f) / 2) * (ss - sh)
    else:
        seen_c = {'bridge': c, 'still': c, 'majority': sh + 0.5 * (ss - sh), 'mass at 0.9': sh + 0.9 * (ss - sh)}[pop]
    span = max(ss, seen_c) - min(sh, seen_c)
    ks = []
    for r in range(t):
        if noise == 'tremble':
            played = [h if rng.random() >= eps else (1 if rng.random() < 0.5 else 0) for h in held]
        elif noise == 'persist':
            held = [h if rng.random() >= eps else (1 if rng.random() < 0.5 else 0) for h in held]
            played = held[:]
        else:
            played = held[:]
        ks.append(sum(played))
        if r == t - 1 or pop == 'still':
            continue
        new = held[:]
        if noise == 'logit':
            k = sum(played)
            for i in range(n):
                if rng.random() < revise:
                    ko = k - played[i]
                    pi_s = (ko * ss + (n - 1 - ko) * sh) / (n - 1)
                    new[i] = 1 if rng.random() < 1 / (1 + math.exp(-eps * (pi_s - seen_c))) else 0
            held = new
            continue
        o = perm(rng, n)
        seen = [0.0] * n
        for i in range(0, n - 1, 2):
            u, v = o[i], o[i + 1]
            for me, you in ((u, v), (v, u)):
                seen[me] = (ss if played[you] else sh) if played[me] else seen_c
        if n % 2:
            u = o[n - 1]
            you = int(rng.random() * (n - 1))
            you += you >= u
            seen[u] = (ss if played[you] else sh) if played[u] else seen_c
        for i in range(n):
            if rng.random() < revise:
                j = int(rng.random() * (n - 1))
                j += j >= i
                if seen[j] > seen[i] and rng.random() < (seen[j] - seen[i]) / span:
                    new[i] = played[j]
        held = new
    return (n, ks)


def world(rng, pop, eps, groups, noise='tremble', revise=float(REVISE)):
    gs = [game(f'g{i}', coding(*gm, n=N_SIM, t=T_SIM),
               [simulate_group(rng, gm, pop, eps, revise=revise, noise=noise) for _ in range(groups)])
          for i, gm in enumerate((G1, G2))]
    return table(*gs)


H = Fr(1, 2)
# (population, noise, its level, groups per game, margin, revision chance); the first 19 cells are round 0's, in order
CELLS = ([('bridge', 'tremble', e, gr, R.MARGIN, H) for e in ('0', '0.05', '0.1', '0.2') for gr in (12, 24, 48)] +
         [('bridge', 'tremble', '0.1', 24, Fr(1, 20), H)] +
         [('majority', 'tremble', '0.05', gr, R.MARGIN, H) for gr in (24, 48)] +
         [('mass at 0.9', 'tremble', '0.05', gr, R.MARGIN, H) for gr in (6, 12)] +
         [('still', 'tremble', e, 48, R.MARGIN, H) for e in ('0.05', '0.2')] +
         [('bridge', 'persist', e, 48, R.MARGIN, H) for e in ('0.05', '0.1', '0.2')] +
         [('bridge', 'persist', e, 48, R.MARGIN, Fr(1, 4)) for e in ('0.15', '0.2')] +
         [('bridge', 'persist', '0.1', 24, R.MARGIN, H)] +
         [('bridge', 'logit', b, 48, R.MARGIN, H) for b in ('0.5', '0.25')] +
         [('still', 'persist', '0.2', 48, R.MARGIN, H)] +
         [('majority', 'persist', '0.1', 48, R.MARGIN, H), ('mass at 0.9', 'persist', '0.1', 12, R.MARGIN, H)] +
         [('mass at 0.9', 'tremble', '0.05', 48, R.MARGIN, H), ('mass at 0.9', 'persist', '0.1', 48, R.MARGIN, H)] +
         # reader round 3: the mass displaced outward, between f* and the nearer end, in both games
         [('mass at 0.10 and 0.90', 'tremble', e, gr, R.MARGIN, H) for e, gr in (('0.05', 24), ('0.05', 48), ('0.1', 48))] +
         [('mass at 0.10 and 0.90', 'persist', '0.1', 48, R.MARGIN, H)] +
         [('mass at 0.15 and 0.85', 'tremble', e, 48, R.MARGIN, H) for e in ('0.05', '0.1')] +
         [('mass at 0.05 and 0.95', 'tremble', e, 48, R.MARGIN, H) for e in ('0.05', '0.1')])
G1S = (17, 5, 8)   # G1 with 5 added to every payoff: f* 1/4
APART = ((0.88, 0.09), (0.55, 0.2))   # the reader's starts: 0.88 to 0.97 in g1, 0.55 to 0.75 in its shift
UNIFORM = ((0.05, 0.9), (0.05, 0.9))
INNER_APART = ((0.27, 0.08), (0.36, 0.12))   # reader round 3: both games' starts in the inner range, apart
# shift pairs: (population of g1, of its shift, noise, level, groups per game, starts)
PAIR_CELLS = ([('bridge', 'bridge', nz, e, 48, APART) for nz, e in (('tremble', '0.1'), ('persist', '0.1'),
                                                                   ('persist', '0.15'), ('logit', '0.2'),
                                                                   ('logit', '0.25'))] +
              [('bridge', 'bridge', nz, e, 48, UNIFORM) for nz, e in (('persist', '0.15'), ('logit', '0.25'))] +
              [('bridge', 'mass at 0.9', 'tremble', '0.05', 48, UNIFORM)] +
              [('bridge', 'bridge', nz, e, 48, INNER_APART) for nz, e in (('tremble', '0.1'), ('persist', '0.1'),
                                                                         ('persist', '0.15'), ('logit', '0.2'),
                                                                         ('logit', '0.25'))])
NEXT_ROUND = [('bridge', '0.1', 24), ('mass at 0.9', '0.05', 12), ('still', '0.2', 48)]
# reader round 4: two games of different f*, G1 from uniform starts and G2 from starts 0.05 to 0.40, which seldom reach
# its inner starts (7 and 8 of 12; about one group a replication, counted in each row); reader round 5: G1 beside a game
# of f* 1/4 (24, 0, 6) following a majority rule from starts 0.30 to 0.42 (about half of them inner starts), and beside
# G2 not revising from uniform starts; (population of G1, its groups, population of the second game, its groups, noise, level, its table, its starts)
LOW = (0.05, 0.35)
MIXED_CELLS = ([('bridge', 48, 'majority', 24, 'tremble', e, G2, LOW) for e in ('0.05', '0.1')] +
               [('bridge', 48, 'bridge', 24, 'tremble', '0.1', G2, LOW)] +
               [('bridge', 96, pop2, 24, 'tremble', '0.1', G2, LOW) for pop2 in ('majority', 'bridge')] +
               [('bridge', 96, 'majority', 6, 'tremble', '0.1', (24, 0, 6), (0.30, 0.12)),
                ('bridge', 192, 'still', 12, 'tremble', '0.1', G2, (0.05, 0.9)),
                ('bridge', 192, 'majority', 6, 'tremble', '0.1', (24, 0, 6), (0.30, 0.12))])


def next_round_verdict(cases):
    """The plan's example, reported beside the rule and not used: the start classified at round 1 and the change from
    round 1 to round 2, so that the classifying round's noise enters the change; the same bins and verdict otherwise."""
    pooled = {b: [] for b in R.BINS}
    for g in cases['games']:
        regime, f = R.location(g['codings']['A'])
        for gr in g['groups']:
            ks, n = gr['adopters'], gr['size']
            s = R.side(ks[0], n, regime, f)
            prt = R.part(ks[0], n, regime, s, f) if s else None
            if prt:
                pooled[R.bin_of(regime, s, prt)].append(s * (ks[1] - ks[0]))
    res = {b: R.bin_result(v)['result'] for b, v in pooled.items()}
    return R.decide(res, False, True, 10 ** 6)


def power():
    rows = []
    for ci, (pop, noise, eps, groups, margin, revise) in enumerate(CELLS):
        rng = random.Random(20261105 + 1000 * ci)
        tally, both_outer, bins_against = {}, 0, {}
        for _ in range(REPS):
            cases = world(rng, pop, float(eps), groups, noise, float(revise))
            v = R.evaluate(cases, ['s1'], margin=margin)
            tally[v['verdict']] = tally.get(v['verdict'], 0) + 1
            both_outer += v['outer bins against'] == ['above, outer', 'below, outer']
            for b, row in v['bins'].items():
                if row['result'] == 'against':
                    bins_against[b] = bins_against.get(b, 0) + 1
        rows.append({'population': pop, 'noise': noise, 'level': eps, 'revise': str(revise),
                     'groups per game': groups, 'margin': str(margin), 'replications': REPS,
                     'verdicts': dict(sorted(tally.items())), 'both outer bins against': both_outer,
                     'bins against': dict(sorted(bins_against.items()))})
    return rows


def pair_power():
    """Shift pairs (DESIGN.md section 6): G1 and its shift by 5, one study, each game's groups simulated with its own
    starts; the pair is counted on its inner bins alone, and the outer bins resolved apart are reported."""
    rows = []
    for ci, (pop1, pop2, noise, eps, groups, starts) in enumerate(PAIR_CELLS):
        rng = random.Random(20261105 + 1000 * (300 + ci))
        tally, inner, outer, testable, bins_against = {}, 0, 0, 0, {}
        for _ in range(REPS):
            g1 = game('g1', coding(*G1), [simulate_group(rng, G1, pop1, float(eps), noise=noise, start=starts[0])
                                          for _ in range(groups)])
            g2 = game('g1s', coding(*G1S, shift_of='g1'),
                      [simulate_group(rng, G1S, pop2, float(eps), noise=noise, start=starts[1]) for _ in range(groups)])
            v = R.evaluate(table(g1, g2), ['s1'])
            tally[v['verdict']] = tally.get(v['verdict'], 0) + 1
            inner += bool(v['shift pairs'][0]['inner bins resolved apart'])
            outer += bool(v['shift pairs'][0]['outer bins resolved apart, not counted'])
            testable += any(all(gm['bins'].get(b, {}).get('result', 'not testable') != 'not testable'
                                for gm in v['games']) for b in R.CONTRADICTING)
            for b, row in v['bins'].items():
                if row['result'] == 'against':
                    bins_against[b] = bins_against.get(b, 0) + 1
        rows.append({'population': pop1, 'shifted game': pop2, 'noise': noise, 'level': eps, 'revise': str(REVISE),
                     'groups per game': groups, 'starts': [f'{a} to {round(a + b, 2)}' for a, b in starts],
                     'replications': REPS, 'verdicts': dict(sorted(tally.items())),
                     'an inner bin testable in both games': testable,
                     'pair resolved apart in an inner bin (counted)': inner,
                     'pair resolved apart in an outer bin (reported, not counted)': outer,
                     'pooled bins against': dict(sorted(bins_against.items()))})
    return rows


def mixed_power():
    """Two games of different f* pooled (DESIGN.md section 9): a pass from G1's inner bin given while the second game
    follows a majority rule, the bridge or no revision. The second game is named as told from a mass at one half only
    where its own bin is predicted in a pooled inner bin predicted; each row counts the passes in which it is told and
    not told, those in which it has a start in a pooled inner bin predicted and is still not told, the passes by how many
    of its own outer bins are predicted (it is told from reversion to one half only on those sides), and its groups at
    an inner start."""
    rows = []
    for ci, (pop1, n1, pop2, n2, noise, eps, g2t, st2) in enumerate(MIXED_CELLS):
        rng = random.Random(20261105 + 1000 * (400 + ci))
        tally, named, told, started, inner_groups, inner_reps, own_testable, outer_sides = {}, 0, 0, 0, 0, 0, 0, {}
        f2 = Fr(g2t[2] - g2t[1], g2t[0] - g2t[1])
        for _ in range(REPS):
            g1 = game('g1', coding(*G1), [simulate_group(rng, G1, pop1, float(eps), noise=noise) for _ in range(n1)])
            g2 = game('g2', coding(*g2t), [simulate_group(rng, g2t, pop2, float(eps), noise=noise, start=st2)
                                           for _ in range(n2)])
            v = R.evaluate(table(g1, g2), ['s1'])
            tally[v['verdict']] = tally.get(v['verdict'], 0) + 1
            inner = 0
            for gr in g2['groups']:
                n, k0 = gr['size'], gr['adopters'][0]
                s = R.side(k0, n, 'bistable', f2)
                inner += bool(s) and R.part(k0, n, 'bistable', s, f2) == 'inner'
            inner_groups += inner
            inner_reps += inner > 0
            own_testable += any(b['result'] != 'not testable' for bn, b in v['games'][1]['bins'].items()
                                if bn.endswith('inner'))
            if v['verdict'] == 'parted from one half':
                told += 'g2' in v[TOLD]
                named += 'g2' in v[NOT_TOLD]
                started += 'g2' in v[NOT_TOLD] and any(e['groups'] for e in v[NOT_TOLD]['g2'].values())
                sides = sum(e['own result'] == 'predicted' for e in v[OWN_OUTER]['g2'].values())
                outer_sides[str(sides)] = outer_sides.get(str(sides), 0) + 1
        rows.append({'population of g1 (f* 1/4)': pop1, 'groups of g1': n1, 'population of g2': pop2,
                     'table of g2 (SS, SH, C)': list(g2t), 'f* of g2': str(f2), 'groups of g2': n2,
                     'starts of g2': f'{st2[0]} to {round(st2[0] + st2[1], 2)}', 'noise': noise,
                     'level': eps, 'replications': REPS, 'verdicts': dict(sorted(tally.items())),
                     'parted, with g2 told from one half': told,
                     'parted, with g2 named as not told from one half': named,
                     'parted, g2 not told though it has a start in a pooled inner bin predicted': started,
                     'parted, by the number of g2\'s own outer bins predicted (told from reversion on those sides)':
                         dict(sorted(outer_sides.items())),
                     'g2 groups at an inner start, all replications': inner_groups,
                     'replications with a g2 group at an inner start': inner_reps,
                     'replications with an own inner bin of g2 testable': own_testable})
    return rows


def next_round():
    rows = []
    for ci, (pop, eps, groups) in enumerate(NEXT_ROUND):
        rng = random.Random(20261105 + 1000 * (100 + ci))
        tally = {}
        for _ in range(REPS):
            v = next_round_verdict(world(rng, pop, float(eps), groups))
            tally[v] = tally.get(v, 0) + 1
        rows.append({'population': pop, 'noise': 'tremble', 'level': eps, 'groups per game': groups,
                     'replications': REPS, 'verdicts': dict(sorted(tally.items()))})
    return rows


def layout_power(layout_path, reps=REPS, out=HERE / 'results' / 'layout-power.json'):
    """The power at the layout (DESIGN.md section 8, step 4): the group sizes and rounds read from data/layout.json,
    which holds no choice, and the payoffs from data/codings.json beside it, for the games the screen admits; written to
    results/layout-power.json, reported, deciding nothing."""
    lay = json.loads(Path(layout_path).read_text(encoding='utf-8'))
    if lay.get('layout') != R.GROUPS_LAYOUT or any(set(gr) != {'group_id', 'size', 'rounds'}
                                                    for g in lay['games'] for gr in g['groups']):
        raise SystemExit('refused: not a layout of sizes and rounds alone')
    coded = {g['game_id']: g['codings'] for g in
             json.loads((Path(layout_path).parent / 'codings.json').read_text(encoding='utf-8'))['games']}
    admitted = [g for g in lay['games'] if g['game_id'] in coded and coded[g['game_id']]['A'] == coded[g['game_id']]['B']
                and not R.screen(coded[g['game_id']]['A']) and g['groups']]
    rows = []
    for ci, (pop, noise, eps) in enumerate((('bridge', 'tremble', 0.05), ('bridge', 'tremble', 0.1),
                                            ('bridge', 'tremble', 0.2), ('bridge', 'persist', 0.1),
                                            ('bridge', 'logit', 0.5), ('majority', 'tremble', 0.05),
                                            ('mass at 0.9', 'tremble', 0.05), ('still', 'tremble', 0.1),
                                            ('still', 'persist', 0.2), ('mass displaced outward', 'tremble', 0.05))):
        rng = random.Random(20261105 + 1000 * (200 + ci))
        tally = {}
        for _ in range(reps):
            gs = []
            for g in admitted:
                pf = coded[g['game_id']]['A']['payoff']
                gm = (float(Fr(str(pf['SS']))), float(Fr(str(pf['SH']))), float(Fr(str(pf['HH']))))
                cod = coding(pf['SS'], pf['SH'], pf['HS'], hh=pf['HH'], n=max(gr['size'] for gr in g['groups']),
                             t=max(gr['rounds'] for gr in g['groups']))
                gs.append(game(g['game_id'], cod, [simulate_group(rng, gm, pop, eps, gr['size'], gr['rounds'],
                                                                  noise=noise) for gr in g['groups']]))
            v = R.evaluate(table(*gs), ['s1'])
            tally[v['verdict']] = tally.get(v['verdict'], 0) + 1
        rows.append({'population': pop, 'noise': noise, 'level': eps, 'replications': reps,
                     'verdicts': dict(sorted(tally.items()))})
    out.write_text(json.dumps({'about': 'CMT power at the layout: uniform starts, reported, deciding nothing.',
                               'mass displaced outward': 'in a bistable game, the mass at f*/2 where f* < 1/2 and at '
                                                         '(1 + f*)/2 otherwise; in a game of another regime (alike, or '
                                                         'everywhere), no mass to displace, so the bridge',
                               'layout sha256': hashlib.sha256(Path(layout_path).read_bytes()).hexdigest(),
                               'admitted games': [g['game_id'] for g in admitted], 'cells': rows}, indent=1) + '\n',
                   encoding='utf-8')
    return rows


def main():
    if len(sys.argv) == 3 and sys.argv[1] == '--layout':
        print(json.dumps(layout_power(sys.argv[2]), indent=1))
        return
    out = {'about': 'CMT dry run (DESIGN.md section 9): no data read; every check through cmt_rule.py.',
           'code sha256': {f: hashlib.sha256((HERE / f).read_bytes()).hexdigest() for f in CODE},
           'rule': {'margin': str(R.MARGIN), 'alpha': str(R.ALPHA), 'n_min': R.N_MIN,
                    'n_min is the fewest groups reaching alpha': R.tail(R.N_MIN, R.N_MIN) <= R.ALPHA < R.tail(R.N_MIN - 1, R.N_MIN - 1)},
           'the location is the Lean model\'s': lean_location(),
           'planted tables': plants(),
           'refusals': refusals(),
           'simulation': {'groups': f'{N_SIM} members, {T_SIM} rounds, random pairs; two games, SS 12, SH 0 and C 3 '
                                    '(f* 1/4) or C 9 (f* 3/4); each group starting at a share drawn uniformly in '
                                    '0.05 to 0.95; each member revising with the cell\'s chance a round; the noise '
                                    'a tremble of play, exploration persisting into the held action, or logit '
                                    'response at the cell\'s level (simulate_group)',
                          'seeds': '20261105 + 1000 * the cell index, one random.Random per cell',
                          'cells': power(),
                          'shift pairs': pair_power(),
                          'two games of different f*': mixed_power(),
                          'the next round from the start, reported and not used': next_round()}}
    checks = [v for k in ('planted tables', 'refusals') for v in out[k].values()]
    checks += [v for k, v in out["the location is the Lean model's"].items() if isinstance(v, bool)]
    checks.append(out['rule']['n_min is the fewest groups reaching alpha'])
    out['checks'] = len(checks)
    out['ok'] = all(c is True for c in checks)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(out, indent=1, ensure_ascii=True) + '\n', encoding='utf-8')
    print(json.dumps({'ok': out['ok'], 'checks': out['checks']}))
    for k in ('planted tables', 'refusals'):
        for name, v in out[k].items():
            if v is not True:
                print('FAILED', k, name)
    for row in out['simulation']['cells'] + out['simulation']['the next round from the start, reported and not used']:
        print(row['population'], row['noise'], row['level'], row.get('revise'), row['groups per game'], row.get('margin'),
              row['verdicts'], row.get('both outer bins against'), row.get('bins against'))
    for row in out['simulation']['shift pairs']:
        print('pair', row['population'], row['shifted game'], row['noise'], row['level'], row['starts'], row['verdicts'],
              row['an inner bin testable in both games'], row['pair resolved apart in an inner bin (counted)'],
              row['pair resolved apart in an outer bin (reported, not counted)'], row['pooled bins against'])
    for row in out['simulation']['two games of different f*']:
        print('mixed', row['population of g1 (f* 1/4)'], row['groups of g1'], row['population of g2'], row['f* of g2'],
              row['groups of g2'], row['level'], row['verdicts'], row['parted, with g2 told from one half'],
              row['parted, with g2 named as not told from one half'],
              row['parted, g2 not told though it has a start in a pooled inner bin predicted'],
              row["parted, by the number of g2's own outer bins predicted (told from reversion on those sides)"],
              row['g2 groups at an inner start, all replications'], row['replications with a g2 group at an inner start'],
              row['replications with an own inner bin of g2 testable'])
    if not out['ok']:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
