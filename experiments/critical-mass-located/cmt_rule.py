"""CMT (board item CMT; DESIGN.md): the critical mass located before the adoption data.

    python3 -B cmt_rule.py check    # the freeze's files against FROZEN.sha256; writes nothing
    python3 -B cmt_rule.py run      # on Ren's yes, after the screen and the reader: data/cases.json -> results/readout.json, once

What it reads. data/cases.json, in the layout LAYOUT names (DESIGN.md section 5): for each game of a study on the closed
list, the two deciding coders' codings of its design documents (made before any choice is seen) and, for each matching
group, its size and the number of members choosing the new practice in each round. Nothing else of the data is read.

What it computes. A game is admitted only where both deciding codings are identical, equal those committed in
data/codings.json before any choice was seen, and pass every screen item (screen()). For an admitted game with SS, SH
the new practice's payoffs against the new practice and against the status quo, and C the status quo's payoff against
anyone, the location is f* = (C - SH)/(SS - SH): critical_iff's ratio (c - lo)/(hi - lo) over any common base, inside
the regime lo < c < hi of critical_mass_iff (0 < f* < 1); at or beyond an end outside it (favours_everywhere_iff,
disfavours_strictly_everywhere_iff). A group whose start (round 1) has k adopters among N, both kinds present, is
classified above where every finite reading of the share, (k-1)/(N-1), k/N and k/(N-1), lies strictly above
f* + MARGIN, below where every one lies strictly below f* - MARGIN. A classified start is inner or outer (part()):
exploration that persists into the state moves the share toward one half, so only an inner bin's 'against' contradicts,
and only the outer bins locate; a shift pair is compared on its inner bins alone. Its statistic is the side's sign times
the change of its adopters from round 2 to its last round, so that the classifying round and the change share no
observation. Across groups, each bin is a one-sided exact sign test at ALPHA each way, testable from N_MIN groups with a
nonzero statistic. The verdict (decide()) is fixed in DESIGN.md section 6: 'parted from one half' needs both outer bins
and an inner bin of the bistable games predicted; 'both sides' (both outer bins, no inner bin) is also what a majority
rule gives. Neither tells f* from a mass lying between f* and the nearer end: under noise the outer bins cannot be made
to contradict, so the mass is bounded on the side of one half only. And every bin pools games of different f*, so a
pass describes the pooled groups: it tells a game's mass from one half only where that game's own bin is predicted in a
pooled inner bin predicted, on that side, and from reversion to one half only on a side where its own outer bin is
predicted. The readout lists the bistable games told and not told (no start, not testable or unresolved there), with
each game's own counts, and each game's own outer bins. An admitted game whose own inner bin is against, in any of the
four inner bins (a bistable game's or an everywhere regime's), is listed apart, under any verdict: this game's own inner
bin is against, at the level that would contradict the law alone; the pooled rule does not count it (or, where the
pooled bin is against too, it contradicts).

It refuses unless FROZEN.sha256 lists every file REQUIRED names, each at its bytes and committed unchanged, FROZEN.sha256
has one commit, that commit is a strict ancestor of data/search.json's, data/search.json, data/codings.json,
data/layout.json and data/cases.json are each committed unchanged and once, in that order, the cased games' codings are
those committed in data/codings.json, the cased games, their groups (ids, sizes, rounds) and the set-asides are those
committed in data/layout.json, the cases' studies are exactly the closed list (no study added, none missing, no game or
group twice), and no readout is there; and it refuses under python3 -O. All arithmetic on the data is exact (integers and
fractions), so no platform is pinned."""
import argparse
import hashlib
import json
import os
import subprocess
import sys
from fractions import Fraction as Fr
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]                      # the repository's root: FROZEN.sha256 lists paths from it
FOLDER = 'experiments/critical-mass-located'
FROZEN = HERE / 'FROZEN.sha256'
REQUIRED = [f'{FOLDER}/{f}' for f in ('cmt_rule.py', 'cmt_dry_run.py', 'studies.json', 'write_frozen.py',
                                      'results/dry-run.json')]
CASES = HERE / 'data' / 'cases.json'
CODINGS = HERE / 'data' / 'codings.json'
LAYOUT_PATH = HERE / 'data' / 'layout.json'
SEARCH = HERE / 'data' / 'search.json'
READOUT = HERE / 'results' / 'readout.json'
STUDIES = HERE / 'studies.json'

if sys.flags.optimize:
    raise SystemExit('refused: run without -O; the checks here are asserts')

# --- the rule, fixed at the freeze ------------------------------------------------------------------------------------
LAYOUT = 'cmt-cases-1'
MARGIN = Fr(0)        # beyond the finite readings' band; the dry run reports 1/20 beside it
ALPHA = Fr(1, 40)     # each one-sided sign test, each way
N_MIN = 6             # the fewest groups at which a one-sided sign test can reach ALPHA: (1/2)^6 = 1/64 <= 1/40 < 1/32
MIN_SIZE = 4          # members in a matching group
MIN_ROUNDS = 3        # a classifying round and one change after it
DECIDING = ('A', 'B')
BINS = tuple(f'{name}, {prt}' for name in ('above', 'below', 'everywhere favoured', 'everywhere disfavoured')
             for prt in ('inner', 'outer'))
CONTRADICTING = tuple(b for b in BINS if b.endswith('inner'))   # the only bins whose 'against' contradicts
# What an admitted game whose own inner bin is against shows (reported, deciding nothing): where its pooled bin is not
# against, AGAINST_ALONE; where the pooled bin is against too, AGAINST_POOLED_TOO
AGAINST_ALONE = ("this game's own inner bin is against, at the level that would contradict the law alone; "
                 'the pooled rule does not count it')
AGAINST_POOLED_TOO = ("this game's own inner bin is against, at the level that would contradict the law alone; "
                      'here the pooled bin is against too, and contradicts')
CODINGS_LAYOUT = 'cmt-codings-1'
GROUPS_LAYOUT = 'cmt-layout-1'   # data/layout.json: the cased games' groups (ids, sizes, rounds) and the set-asides
MATCHING_ADMITTED = ('random pairs', 'mean matching')
CODING_KEYS = ('two_actions_symmetric', 'payoff', 'status_quo', 'matching', 'constant_parameters', 'committed_members',
               'communication', 'first_game_of_group', 'feedback_own_payoff', 'independent_groups', 'group_size',
               'rounds', 'shift_of')


# --- the screen (DESIGN.md section 4) ---------------------------------------------------------------------------------
def payoffs(coding):
    """SS, SH, HS, HH as fractions: the row player's payoff, S the new practice, H the status quo (coding['status_quo'])."""
    p = coding['payoff']
    return tuple(Fr(str(p[k])) for k in ('SS', 'SH', 'HS', 'HH'))


def screen(coding):
    """The items a game fails, in the order of DESIGN.md section 4; empty where it is admitted."""
    fails = []
    if coding['two_actions_symmetric'] is not True:
        fails.append('(a) not a symmetric game of two actions')
        return fails
    ss, sh, hs, hh = payoffs(coding)
    if hs != hh:
        fails.append("(b) the status quo's payoff depends on the partner")
    if coding['matching'] not in MATCHING_ADMITTED:
        fails.append('(c) not well-mixed counting (random pairs or mean matching)')
    if coding['independent_groups'] is not True:
        fails.append('(c) matching groups not independent')
    if coding['constant_parameters'] is not True:
        fails.append('(d) payoffs not constant over the rounds')
    if coding['committed_members'] is not False:
        fails.append('(e) committed members, confederates or programmed players')
    if coding['communication'] is not False:
        fails.append('(e) communication or another stage')
    if coding['first_game_of_group'] is not True:
        fails.append("(e) not the group's first game")
    if coding['feedback_own_payoff'] is not True:
        fails.append('(e) no feedback of the own payoff')
    if sh > ss:
        fails.append('(f) lo > hi: the rule read reads against the share (drawn_against)')
    if not (isinstance(coding['group_size'], int) and coding['group_size'] >= MIN_SIZE):
        fails.append(f'(g) matching groups smaller than {MIN_SIZE}')
    if not (isinstance(coding['rounds'], int) and coding['rounds'] >= MIN_ROUNDS):
        fails.append(f'(g) fewer than {MIN_ROUNDS} rounds')
    return fails


def location(coding):
    """(regime, f*): f* = (C - SH)/(SS - SH), critical_iff's ratio; None where SS = SH (the two readings alike)."""
    ss, sh, c, _ = payoffs(coding)
    if ss == sh:
        return ('alike, favoured' if sh > c else 'alike, disfavoured' if sh < c else 'alike, tied'), None
    f = (c - sh) / (ss - sh)
    if f <= 0:
        return 'everywhere favoured', f
    if f >= 1:
        return 'everywhere disfavoured', f
    return 'bistable', f


def side(k, n, regime, f, margin=MARGIN):
    """+1 above, -1 below, 0 unclassified, for k adopters among n, both kinds present. Every finite reading of the
    share must lie strictly on the side: (k-1)/(n-1) for an adopter's partner, k/n the model's count, k/(n-1) for the
    status quo's member's partner were it to adopt."""
    if k <= 0 or k >= n:
        return 0
    if regime.startswith('alike'):
        return 1 if regime == 'alike, favoured' else -1 if regime == 'alike, disfavoured' else 0
    lo_r, hi_r = Fr(k - 1, n - 1), Fr(k, n - 1)
    if lo_r > f + margin:
        return 1
    if hi_r < f - margin:
        return -1
    return 0


def discriminating(k, n, s, f, margin=MARGIN):
    """A classified start at which f = 1/2 (a majority rule) gives the other side: every finite reading on f*'s side
    of the predicted direction and on the other side of one half. These are the inner starts of a bistable game."""
    lo_r, hi_r = Fr(k - 1, n - 1), Fr(k, n - 1)
    return (s > 0 and hi_r < Fr(1, 2) - margin) or (s < 0 and lo_r > Fr(1, 2) + margin)


def part(k, n, regime, s, f, margin=MARGIN):
    """'inner', 'outer' or None (near one half) for a classified start (DESIGN.md section 6). Exploration or random
    choice that persists into the state moves the share toward one half. At an inner start that motion has the
    predicted sign, so a bin of inner starts can be against only through revision; at an outer start it has the other
    sign or none, so a bin of outer starts can be predicted only through revision. Bistable: inner where every finite
    reading lies between f* and one half (discriminating()); outer where the share k/n lies at or beyond one half on the
    side away from f* (above: 2k >= n; below: 2k <= n); between them, near one half, in no bin. Everywhere regimes:
    inner where k/n lies strictly on the side of one half from which the predicted direction runs toward it."""
    if regime == 'bistable':
        if discriminating(k, n, s, f, margin):
            return 'inner'
        if (s > 0 and 2 * k >= n) or (s < 0 and 2 * k <= n):
            return 'outer'
        return None
    return 'inner' if (s > 0 and 2 * k < n) or (s < 0 and 2 * k > n) else 'outer'


def bin_of(regime, s, prt):
    """The bin's name: the side (bistable) or the regime, and the part."""
    if regime == 'bistable':
        name = 'above' if s > 0 else 'below'
    else:
        name = 'everywhere favoured' if s > 0 else 'everywhere disfavoured'
    return f'{name}, {prt}'


def group_stat(group, regime, f, margin=MARGIN):
    """(bin, side * (k[last] - k[2])) for one group, classified by its start (round 1); None where the start is not
    classified, and bin None where it is near one half. Round 1 classifies and the change runs from round 2 to the last
    round, so that no observation does both."""
    n, ks = group['size'], group['adopters']
    s = side(ks[0], n, regime, f, margin)
    if not s:
        return None
    prt = part(ks[0], n, regime, s, f, margin)
    return (bin_of(regime, s, prt) if prt else None), s * (ks[-1] - ks[1])


def tail(n, x):
    """P(X >= x) for X binomial(n, 1/2), exactly."""
    from math import comb
    return Fr(sum(comb(n, j) for j in range(x, n + 1)), 2 ** n)


def bin_result(stats, alpha=ALPHA, n_min=N_MIN):
    """A bin's result from its groups' statistics (signed sums): predicted, against, unresolved or not testable."""
    plus = sum(1 for v in stats if v > 0)
    minus = sum(1 for v in stats if v < 0)
    zero = len(stats) - plus - minus
    n = plus + minus
    row = {'groups': len(stats), 'predicted sign': plus, 'against': minus, 'zero': zero}
    if n < n_min:
        row['result'] = 'not testable'
        return row
    pp, pa = tail(n, plus), tail(n, minus)
    row['p predicted'], row['p against'] = str(pp), str(pa)
    row['result'] = 'predicted' if pp <= alpha else 'against' if pa <= alpha else 'unresolved'
    return row


def decide(res, shift_moved, admitted, bistable_groups, n_min=N_MIN):
    """The verdict (DESIGN.md section 6) from the pooled bins' results, in order: contradicted (an inner bin against,
    or a shift pair's inner bins resolved apart); void (no game admitted, or fewer than n_min usable groups of bistable
    games, by the layout); parted from one half (both outer bins of the bistable games predicted, and an inner one; the
    bins are pooled, so this describes the pooled groups: in a game whose own bin is predicted in that inner bin, the
    mass lies short of those starts, on the side of one half, and is not told from any mass nearer the end; any other
    game is not told from a mass at one half, and the readout names it; an admitted game whose own inner bin, of any of
    the four, is against is listed apart, under any verdict, since that is the level that would contradict the law
    alone, though the pooled rule counts it only where the pooled bin is against too; a game is told from reversion
    to one half only on a side where its own outer bin is predicted); both sides (both outer bins predicted, no inner
    bin: also what a majority rule gives); one side; unresolved."""
    if any(res[b] == 'against' for b in CONTRADICTING) or shift_moved:
        return 'contradicted'
    if not admitted or bistable_groups < n_min:
        return 'void'
    if res['above, outer'] == res['below, outer'] == 'predicted':
        return 'parted from one half' if 'predicted' in (res['above, inner'], res['below, inner']) else 'both sides'
    if 'predicted' in (res['above, outer'], res['below, outer']):
        return 'one side'
    return 'unresolved'


def is_shift(a, b):
    """Two codings whose every payoff differs by one constant (drawn_favours_alike's a and p), not by a scale."""
    pa, pb = payoffs(a), payoffs(b)
    return len({y - x for x, y in zip(pa, pb)}) == 1


# --- the layout, the closed list and the verdict (DESIGN.md sections 5 and 6) -----------------------------------------
def validate(cases, closed):
    """Refuse a table not in the layout, or not of the closed list: no study added, none missing, no game or group
    listed twice."""
    if cases.get('layout') != LAYOUT:
        raise SystemExit(f'refused: the cases are not in layout {LAYOUT}')
    seen, game_ids = set(), set()
    for g in cases['games']:
        if g['study_id'] not in closed:
            raise SystemExit(f"refused: {g['study_id']} is not on the closed list; the run is enlarged")
        seen.add(g['study_id'])
        if g['game_id'] in game_ids:
            raise SystemExit(f"refused: game {g['game_id']} is listed twice")
        game_ids.add(g['game_id'])
        for who in DECIDING:
            c = g['codings'][who]
            if set(c) != set(CODING_KEYS):
                raise SystemExit(f"refused: {g['game_id']}: coding {who} has keys other than the layout's")
        group_ids = set()
        for gr in g['groups']:
            if gr['group_id'] in group_ids:
                raise SystemExit(f"refused: {g['game_id']}/{gr['group_id']}: a group listed twice")
            group_ids.add(gr['group_id'])
            n, ks = gr['size'], gr['adopters']
            if not (isinstance(n, int) and n >= 2 and all(isinstance(k, int) and 0 <= k <= n for k in ks)):
                raise SystemExit(f"refused: {g['game_id']}/{gr['group_id']}: a count outside 0..size")
    for s in cases.get('set_aside', []):
        if s['study_id'] not in closed:
            raise SystemExit(f"refused: {s['study_id']} is not on the closed list; the run is enlarged")
        if not s.get('reason'):
            raise SystemExit(f"refused: {s['study_id']} set aside with no reason")
        seen.add(s['study_id'])
    missing = sorted(set(closed) - seen)
    if missing:
        raise SystemExit(f'refused: listed studies neither cased nor set aside: {missing}; the run is incomplete')


def evaluate(cases, closed, margin=MARGIN, alpha=ALPHA, n_min=N_MIN):
    """The readout's body: every game's screen, regime and bins, the pooled bins, the shift pairs and the verdict."""
    validate(cases, closed)
    games, pooled = [], {b: [] for b in BINS}
    by_id = {}
    for g in cases['games']:
        a, b = (g['codings'][w] for w in DECIDING)
        row = {'game_id': g['game_id'], 'study_id': g['study_id'], 'groups': len(g['groups'])}
        if a != b:
            row['admitted'], row['set aside'] = False, ['the deciding codings differ']
        else:
            fails = screen(a)
            row['admitted'], row['set aside'] = not fails, fails
        if 'apart' in g['codings']:
            row['coding reported apart agrees'] = g['codings']['apart'] == a
        if row['admitted']:
            for gr in g['groups']:
                if gr['size'] > a['group_size'] or len(gr['adopters']) > a['rounds']:
                    raise SystemExit(f"refused: {g['game_id']}/{gr['group_id']}: more members or rounds than the "
                                     'coded design')
            regime, f = location(a)
            row['regime'], row['f*'] = regime, (None if f is None else str(f))
            ss, sh, c, _ = payoffs(a)
            row['new practice risk dominant (2c < hi + lo)'] = 2 * c < ss + sh
            per = {bn: [] for bn in BINS}
            short = near = 0
            for gr in g['groups']:
                if gr['size'] < MIN_SIZE or len(gr['adopters']) < MIN_ROUNDS:
                    short += 1
                    continue
                st = group_stat(gr, regime, f, margin)
                if st is None:
                    continue
                if st[0] is None:
                    near += 1
                else:
                    per[st[0]].append(st[1])
            row['groups too small or short'] = short
            row['groups classified near one half, in no bin'] = near
            row['bins'] = {bn: bin_result(v, alpha, n_min) for bn, v in per.items() if v}
            for bn, v in per.items():
                pooled[bn] += v
            row['_layout groups'] = len(g['groups']) - short
        games.append(row)
        by_id[g['game_id']] = (row, a)
    bistable_groups = sum(r['_layout groups'] for r in games if r.get('regime') == 'bistable')
    shifts = []
    for gid, (row, a) in by_id.items():
        other = a['shift_of'] if row['admitted'] else None
        if not (other and other in by_id and by_id[other][0]['admitted']):
            continue
        r2, a2 = by_id[other]
        if r2['study_id'] == row['study_id'] and r2.get('f*') == row.get('f*') and is_shift(a2, a):
            apart = [bn for bn in BINS
                     if {row['bins'].get(bn, {}).get('result'), r2['bins'].get(bn, {}).get('result')} == {'predicted', 'against'}]
            # Only the inner bins count: where the starts fall inside an outer bin moves its direction under persistent
            # exploration or logit response, and two games' starts may fall differently (DESIGN.md section 6).
            shifts.append({'game': gid, 'shift of': other, 'f*': row.get('f*'),
                           'inner bins resolved apart': [bn for bn in apart if bn in CONTRADICTING],
                           'outer bins resolved apart, not counted': [bn for bn in apart if bn not in CONTRADICTING]})
    for r in games:
        r.pop('_layout groups', None)
    bins = {bn: bin_result(v, alpha, n_min) for bn, v in pooled.items()}
    res = {bn: bins[bn]['result'] for bn in BINS}
    admitted = [r for r in games if r['admitted']]
    shift_moved = any(s['inner bins resolved apart'] for s in shifts)
    verdict = decide(res, shift_moved, admitted, bistable_groups, n_min)
    # Reported, deciding nothing: every bin pools games of different f*, so a pooled result describes the pooled groups.
    # A game is told from a mass at one half only where its own bin is predicted in a pooled inner bin predicted, on that
    # side, and from reversion to one half only on a side where its own outer bin is predicted (DESIGN.md section 6).
    def own(r, bn):
        b = r['bins'].get(bn)
        if not b:
            return {'groups': 0, 'own result': 'no start'}
        return {'groups': b['groups'], 'predicted sign': b['predicted sign'], 'against': b['against'],
                'zero': b['zero'], 'own result': b['result']}
    bistable = [r for r in admitted if r.get('regime') == 'bistable']
    inner_predicted = [bn for bn in ('above, inner', 'below, inner') if res[bn] == 'predicted']
    own_inner = {r['game_id']: {bn: own(r, bn) for bn in inner_predicted} for r in bistable}
    told = {g: e for g, e in own_inner.items() if any(x['own result'] == 'predicted' for x in e.values())}
    own_outer = {r['game_id']: {bn: own(r, bn) for bn in ('above, outer', 'below, outer')} for r in bistable}
    # Reported, deciding nothing, under any verdict: an admitted game whose own bin, in any of the four contradicting
    # bins (a bistable game's two inner bins, or an everywhere regime's inner bin, where SS = SH games pool too), is
    # against at ALPHA, the level at which the pooled bin would contradict. Revision alone gives that direction there,
    # but the rule counts only the pooled bins, so such a game is named as what it is, not merely as not told from one
    # half (DESIGN.md section 6).
    against_alone = {}
    for r in admitted:
        for bn in CONTRADICTING:
            e = own(r, bn)
            if e['own result'] == 'against':
                e['pooled result'] = res[bn]
                e['what it shows'] = AGAINST_POOLED_TOO if res[bn] == 'against' else AGAINST_ALONE
                against_alone.setdefault(r['game_id'], {})[bn] = e
    return {'verdict': verdict,
            'inner bins predicted, pooled': inner_predicted,
            'bistable games told from a mass at one half: own bin predicted in a pooled inner bin predicted': told,
            'bistable games not told from a mass at one half: no start, not testable or unresolved there, or against '
            '(each game against there is also listed under its own inner bin against)':
                {g: e for g, e in own_inner.items() if g not in told},
            'bistable games, own outer bins: told from reversion to one half only on a side predicted': own_outer,
            'admitted games whose own inner bin is against, in any of the four inner bins: at the level that would '
            'contradict the law alone; the pooled rule counts it only where the pooled bin is against too': against_alone,
            'outer bins against': [bn for bn in BINS if bn.endswith('outer') and res[bn] == 'against'],
            'regime bins predicted': [bn for bn in BINS if bn.startswith('everywhere') and res[bn] == 'predicted'],
            'layout': {'games': len(games), 'admitted': len(admitted), 'bistable groups usable': bistable_groups,
                       'void by layout': (not admitted) or bistable_groups < n_min},
            'bins': bins, 'shift pairs': shifts, 'games': games,
            'rule': {'margin': str(margin), 'alpha': str(alpha), 'n_min': n_min, 'min_size': MIN_SIZE,
                     'min_rounds': MIN_ROUNDS, 'contradicting bins': list(CONTRADICTING)}}


def coded_as_committed(cases, codings):
    """Refuse unless each cased game's codings equal those committed at step 3 in data/codings.json, and every coded
    game is cased or its study set aside whole: no coding edited after the choices are seen, no coded game dropped."""
    if codings.get('layout') != CODINGS_LAYOUT:
        raise SystemExit(f'refused: data/codings.json is not in layout {CODINGS_LAYOUT}')
    coded = {}
    for g in codings['games']:
        if g['game_id'] in coded:
            raise SystemExit(f"refused: game {g['game_id']} is coded twice in data/codings.json")
        coded[g['game_id']] = g
    cased = {g['game_id']: g for g in cases['games']}
    for gid, g in cased.items():
        if gid not in coded or coded[gid]['study_id'] != g['study_id'] or coded[gid]['codings'] != g['codings']:
            raise SystemExit(f'refused: {gid}: its codings differ from those committed in data/codings.json')
    aside = {s['study_id'] for s in cases.get('set_aside', [])}
    cased_studies = {g['study_id'] for g in cases['games']}
    for gid, g in coded.items():
        if gid not in cased and (g['study_id'] not in aside or g['study_id'] in cased_studies):
            raise SystemExit(f'refused: coded game {gid} is neither cased nor its study set aside whole')


def as_laid_out(cases, layout):
    """Refuse unless the cased games, each one's study and groups (id, size, rounds of data) and the set-asides with
    their reasons are exactly those committed at step 4 in data/layout.json, before any choice was read: no group
    dropped, no game removed and no study set aside after the counts are seen. A layout whose games, groups or
    set-asides carry any other key (choices, for one) is refused."""
    if layout.get('layout') != GROUPS_LAYOUT:
        raise SystemExit(f'refused: data/layout.json is not in layout {GROUPS_LAYOUT}')
    # Written from the data files' headers and no choice (DESIGN.md section 5): a key beyond these is a sign that a
    # choice was read at step 4, before the cases.
    if (not set(layout) <= {'layout', 'games', 'set_aside'}
            or any(set(g) != {'game_id', 'study_id', 'groups'} for g in layout['games'])
            or any(set(gr) != {'group_id', 'size', 'rounds'} for g in layout['games'] for gr in g['groups'])
            or any(set(s) != {'study_id', 'reason'} for s in layout.get('set_aside', []))):
        raise SystemExit('refused: data/layout.json carries keys beyond ids, sizes, rounds and set-asides')

    def shape(games, rounds):
        out = {}
        for g in games:
            if g['game_id'] in out:
                raise SystemExit(f"refused: game {g['game_id']} is listed twice")
            out[g['game_id']] = (g['study_id'], sorted((gr['group_id'], gr['size'], rounds(gr)) for gr in g['groups']))
        return out
    laid = shape(layout['games'], lambda gr: gr['rounds'])
    cased = shape(cases['games'], lambda gr: len(gr['adopters']))
    for gid in sorted(set(laid) | set(cased)):
        if laid.get(gid) != cased.get(gid):
            raise SystemExit(f'refused: {gid}: its study, groups, sizes or rounds differ from data/layout.json')
    aside = lambda t: sorted((s['study_id'], s['reason']) for s in t.get('set_aside', []))  # noqa: E731
    if aside(layout) != aside(cases):
        raise SystemExit('refused: the studies set aside differ from data/layout.json')


# --- the freeze and the run -------------------------------------------------------------------------------------------
def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def git(root, *a):
    return subprocess.run(['git', '-C', str(root), *a], capture_output=True, text=True)


def committed_unchanged(root, paths):
    st, tr = git(root, 'status', '--porcelain', '--', *paths), git(root, 'ls-files', '--error-unmatch', '--', *paths)
    return not (st.returncode or st.stdout.strip() or tr.returncode), (st.stdout or tr.stderr)


def frozen_check(frozen=FROZEN, root=ROOT, required=REQUIRED):
    """FROZEN.sha256 lists every required file, each line's file has that sha256 and is committed unchanged, and
    FROZEN.sha256 is committed once (a second commit would make a new freeze). Returns the listing and the commits."""
    if not frozen.exists():
        raise SystemExit(f'refused: no {frozen.name}; the freeze is not committed')
    listed = {}
    for line in frozen.read_text().splitlines():
        if line.strip():
            h, p = line.split(None, 1)
            listed[p] = h
    missing = [p for p in required if p not in listed]
    if missing:
        raise SystemExit(f'refused: FROZEN.sha256 does not list {missing}')
    for p, h in listed.items():
        if not (root / p).exists() or sha(root / p) != h:
            raise SystemExit(f'refused: {p} differs from FROZEN.sha256')
    rel = str(frozen.relative_to(root))
    ok, why = committed_unchanged(root, [rel] + list(listed))
    if not ok:
        raise SystemExit('refused: a frozen file is uncommitted or changed:\n' + why)
    commits = git(root, 'rev-list', 'HEAD', '--', rel).stdout.split()
    if len(commits) != 1:
        raise SystemExit(f'refused: {rel} has {len(commits)} commits; the freeze is the one that added it')
    return listed, {'the freeze commit': commits[0], 'HEAD': git(root, 'rev-parse', 'HEAD').stdout.strip()}


def commits_of(root, rel):
    return git(root, 'log', '--format=%H', '--', rel).stdout.split()


def closed_list(root=ROOT, studies=STUDIES, search=SEARCH, cases=CASES, codings=CODINGS, layout=LAYOUT_PATH):
    """The studies the run must account for, and the order's commits. studies.json's list and the frozen search's hits,
    in data/search.json. data/search.json, data/codings.json, data/layout.json and data/cases.json must each be there,
    committed unchanged and committed exactly once, in that order, each commit strictly before the next: the search
    before any coding, the codings (made before any choice is seen) before the layout, the layout (groups, sizes, rounds
    and set-asides, no choice) before the cases. A second commit of any of them, a hit removed, a coding edited or a
    group dropped after the choices are seen, is refused."""
    ids = [s['id'] for s in json.loads(studies.read_text(encoding='utf-8'))['studies']]
    order = {}
    for name, path in (('search', search), ('codings', codings), ('layout', layout), ('cases', cases)):
        if not path.exists():
            raise SystemExit(f'refused: no data/{path.name}; the order is search, codings, layout, cases')
        rel = str(path.relative_to(root))
        ok, why = committed_unchanged(root, [rel])
        if not ok:
            raise SystemExit(f'refused: data/{path.name} is uncommitted or changed:\n' + why)
        c = commits_of(root, rel)
        if len(c) != 1:
            raise SystemExit(f'refused: data/{path.name} has {len(c)} commits; it is committed once')
        order[name] = c[0]
    for first, then in (('search', 'codings'), ('codings', 'layout'), ('layout', 'cases')):
        a, b = order[first], order[then]
        if a == b or git(root, 'merge-base', '--is-ancestor', a, b).returncode:
            raise SystemExit(f'refused: data/{first}.json was not committed before data/{then}.json')
    ids += [h['id'] for h in json.loads(search.read_text(encoding='utf-8'))['hits']]
    if len(set(ids)) != len(ids):
        raise SystemExit('refused: a study is listed twice')
    return ids, {f'data/{k}.json commit': v for k, v in order.items()}


def durable(path, data):
    """Write a file whole: a temporary name, synced, renamed, the folder synced."""
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_name(path.name + '.tmp')
    with open(tmp, 'wb') as f:
        f.write(data)
        f.flush()
        os.fsync(f.fileno())
    os.replace(tmp, path)
    fd = os.open(path.parent, os.O_RDONLY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


def run(out=READOUT, cases_path=CASES, root=ROOT, frozen=None, closed=None, codings_path=CODINGS,
        layout_path=LAYOUT_PATH):
    """The readout, written once: the freeze, the cases committed, the closed list and the order, the freeze before the
    data, the codings as committed, the cases as laid out, then evaluate()."""
    if out.exists():
        raise SystemExit(f'refused: {out.name} is there; a run is written once')
    listed, commits = frozen() if frozen else frozen_check()
    if not cases_path.exists():
        raise SystemExit('refused: no data/cases.json')
    ok, why = committed_unchanged(root, [str(cases_path.relative_to(root))])
    if not ok:
        raise SystemExit('refused: data/cases.json is uncommitted or changed:\n' + why)
    ids, order = closed() if closed else closed_list(root)
    fc, sc = commits.get('the freeze commit'), order.get('data/search.json commit')
    if not (fc and sc) or fc == sc or git(root, 'merge-base', '--is-ancestor', fc, sc).returncode:
        raise SystemExit('refused: the freeze was not committed before data/search.json; the rule precedes the data')
    for p in (codings_path, layout_path):
        if not p.exists():
            raise SystemExit(f'refused: no data/{p.name}')
    cases = json.loads(cases_path.read_text(encoding='utf-8'))
    coded_as_committed(cases, json.loads(codings_path.read_text(encoding='utf-8')))
    as_laid_out(cases, json.loads(layout_path.read_text(encoding='utf-8')))
    body = evaluate(cases, ids)
    readout = {'about': 'CMT (DESIGN.md): the critical mass located before the adoption data; the verdict by frozen code.',
               'frozen': listed, 'commits': {**commits, **order}, 'the freeze a strict ancestor of the search': True,
               'cases sha256': sha(cases_path), 'codings sha256': sha(codings_path),
               'layout sha256': sha(layout_path), 'closed list': ids, **body}
    durable(out, (json.dumps(readout, indent=1, ensure_ascii=True, sort_keys=True) + '\n').encode())
    return readout


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('command', choices=('check', 'run'))
    cmd = ap.parse_args().command
    if cmd == 'check':
        listed, commits = frozen_check()
        print(json.dumps({'frozen': listed, 'commits': commits}, indent=1))
    else:
        r = run()
        print(r['verdict'])


if __name__ == '__main__':
    main()
