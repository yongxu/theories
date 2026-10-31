#!/usr/bin/env python3
"""LA4's formal part, into the package (from the checkout root, in a worktree off main):
- the leaves Becoming.OptimumSeason and Becoming.WeightedCommuting, copied from the kit's tree;
- the root module's imports and its description of each (L1, after Becoming.Optimum's and Becoming.Commuting's);
- the checker's core list and its description of each module;
- the package README's L1 rows, English and Chinese, after Becoming.Optimum's and Becoming.Commuting's.
usage: python3 -B integrate_la4.py [--check]   (--check: assert everything applies; writes nothing)"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
CHECK = '--check' in sys.argv
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
TREE = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/la4-formal/tree/Becoming'

LEAVES = {
    'Becoming.OptimumSeason': {
        'after': 'Becoming.Optimum',
        'bullet': (
            "* `Becoming.OptimumSeason` (L1): LA4's test season and the optimum laws it meets. The season as\n"
            "  `season.py` runs it (a ground of ten renewing, at most four taken a step, a bay of six, two\n"
            "  landing sites, ten steps) has three independent parts, the ground's catch, the bay's fish and\n"
            "  the landings; the ground's best catch is 34, by a table checked against every take. The catch\n"
            "  shares units with the bay, so every optimum of every order rising with the catch empties the\n"
            "  bay (`Optimum.Season.bay_drained`); the landing site, and the bay ranked by the ground's catch\n"
            "  alone, give no room, and the orders by the catch alone and by the ground's have optima keeping\n"
            "  and ending. Over seasons with natural-number weights the bay left is at most `40(1 − ν)` and\n"
            "  `ν ≤ 1 − 3p/40`. A leaf (board item LA4).\n"),
        'en': (
            "| L1 | [`Becoming.OptimumSeason`](Becoming/OptimumSeason.lean) | LA4's test season and the optimum laws it "
            "meets (no premise; the season as `season.py` runs it): three independent parts, the ground's catch, the "
            "bay's fish and the landings (`Optimum.Season.eligible_of`); the ground's best catch is 34 "
            "(`Optimum.Season.bellman`, `Optimum.Season.ground_le`); with shared units every optimum of every order "
            "rising with the catch empties the bay (`Optimum.Season.bay_drained`); no room at the site, nor at the bay "
            "ranked by the ground's catch alone, and under the orders by the catch alone and by the ground's, optima "
            "that keep and that end (`Optimum.Season.site_no_room`, `Optimum.Season.unshared_optima`); over seasons "
            "with natural-number weights the bay left is at most `40(1 − ν)` (`Optimum.Season.mix_bay_catch`) |"),
        'zh': (
            "| L1 | [`Becoming.OptimumSeason`](Becoming/OptimumSeason.lean) | LA4 之检验季及其所合之最优之律（不加前提；季如 "
            "`season.py` 所运行）：三独立部分，地之获、湾之鱼与登陆（`Optimum.Season.eligible_of`）；地之最佳获为 34"
            "（`Optimum.Season.bellman`、`Optimum.Season.ground_le`）；共享单位时，每一随获而升之序之每一最优皆空其湾"
            "（`Optimum.Season.bay_drained`）；登陆之地无余地，只以地之获排序时之湾亦然；只以获或只以地之获排序者，最优兼有留与尽"
            "（`Optimum.Season.site_no_room`、`Optimum.Season.unshared_optima`）；于自然数加权之季上，湾余至多 `40(1 − ν)`"
            "（`Optimum.Season.mix_bay_catch`） |"),
        'description': (
            '    "OptimumSeason: LA4\'s test season as season.py runs it has three independent parts, the ground\'s "\n'
            '    "catch, the bay\'s fish and the landings; the ground\'s best catch is 34; with shared units every "\n'
            '    "optimum of every order rising with the catch empties the bay; the landing site, and the bay ranked "\n'
            '    "by the ground\'s catch alone, give no room, and the orders by the catch alone and by the ground\'s "\n'
            '    "have optima keeping and ending; over seasons with natural weights the bay left is at most 40 times "\n'
            '    "one less the nearness. "\n'),
    },
    'Becoming.WeightedCommuting': {
        'after': 'Becoming.Commuting',
        'bullet': (
            "* `Becoming.WeightedCommuting` (L1): what a commuting law keeps in expectation. A law going to\n"
            "  finitely many weighted successors, the weights of any type and no law of their arithmetic\n"
            "  used, commuting with a map carries every expectation through the map\n"
            "  (`Weighted.Commutes.carried`), so from a start the map leaves unchanged the expectations stay\n"
            "  symmetric at every step; a law drawing samples commutes where a map of the samples permutes\n"
            "  them and the map carries their weights and the update (`Weighted.Commutes.of_samples`); a\n"
            "  determined commuting law is a case. Reinforcing keeps equal expectations while runs drawing\n"
            "  one value for any number of steps have positive weight; Pooling wears a start's preference\n"
            "  away. A leaf (board item LA4).\n"),
        'en': (
            "| L1 | [`Becoming.WeightedCommuting`](Becoming/WeightedCommuting.lean) | what a commuting law keeps in "
            "expectation (no premise; weights of any type, no law of their arithmetic used): a weighted law commuting "
            "with a map carries every expectation through it (`Weighted.Commutes.carried`), so from a start it leaves "
            "unchanged the expectations stay symmetric (`Weighted.Commutes.fixed_expect`, "
            "`Weighted.Commutes.start_expect`); a sampling law commutes where the map permutes the samples and carries "
            "weights and update (`Weighted.Commutes.of_samples`); Reinforcing keeps equal expectations while one-sided "
            "runs of any length have positive weight (`Weighted.Reinforcing.oneSided`); Pooling wears a start's "
            "preference away "
            "(`Weighted.Pooling.share_rises`) |"),
        'zh': (
            "| L1 | [`Becoming.WeightedCommuting`](Becoming/WeightedCommuting.lean) | 交换之律于期望中保持什么（不加前提；"
            "权为任意类型，不用其算术之任何律）：与一映射交换之加权之律，经此映射携每一期望（`Weighted.Commutes.carried`），"
            "故自映射不改之起点，期望保持对称（`Weighted.Commutes.fixed_expect`、`Weighted.Commutes.start_expect`）；"
            "映射置换样本并携权与更新时，抽样之律交换（`Weighted.Commutes.of_samples`）；强化之律期望相等，而任意长之单边运行有正之权"
            "（`Weighted.Reinforcing.oneSided`）；汇聚之律磨去起点之偏（`Weighted.Pooling.share_rises`） |"),
        'description': (
            '    "WeightedCommuting: a law to finitely many weighted successors, the weights of any type, commuting "\n'
            '    "with a map carries every expectation through the map, so from a start the map leaves unchanged "\n'
            '    "the expectations stay symmetric; a sampling law commutes where the map permutes the samples and "\n'
            '    "carries weights and update; Reinforcing keeps equal expectations while one-sided runs of any "\n'
            '    "length have positive weight; Pooling wears a start\'s preference away. "\n'),
    },
}


def write(path, text):
    if not CHECK:
        path.write_text(text, encoding='utf-8')


def after_line(text, old, new):
    assert text.count(old) == 1, (old[:60], text.count(old))
    assert new not in text, (new[:60], 'present already')
    return text.replace(old, old + new, 1)


def after_block(text, head, new, starts):
    """Insert new after the block whose first line starts with head; the block ends before the next line that starts
    with one of starts or is blank."""
    lines = text.split('\n')
    hits = [i for i, l in enumerate(lines) if l.startswith(head)]
    assert len(hits) == 1, (head, hits)
    j = hits[0] + 1
    while j < len(lines) and lines[j].strip() and not lines[j].startswith(starts):
        j += 1
    assert new not in text, (new[:60], 'present already')
    return '\n'.join(lines[:j] + new.rstrip('\n').split('\n') + lines[j:])


root = (PKG / 'Becoming.lean').read_text(encoding='utf-8')
checker = (PKG / 'check_becoming.py').read_text(encoding='utf-8')
readme = {name: (PKG / name).read_text(encoding='utf-8') for name in ('README.md', 'README.zh.md')}
for leaf, x in LEAVES.items():
    short = leaf.split('.', 1)[1]
    assert not (PKG / f'Becoming/{short}.lean').exists(), leaf
    source = (TREE / f'{short}.lean').read_text(encoding='utf-8')
    assert f'import {x["after"]}\n' in source, (leaf, 'imports its parent')
    write(PKG / f'Becoming/{short}.lean', source)
    root = after_line(root, f'import {x["after"]}\n', f'import {leaf}\n')
    root = after_block(root, f'* `{x["after"]}` (L1):', x['bullet'], ('* ',))
    checker = after_line(checker, f'"{x["after"]}", ', f'"{leaf}", ')
    lines = checker.split('\n')
    head = f'    "{x["after"].split(".", 1)[1]}: '
    hits = [i for i, l in enumerate(lines) if l.startswith(head)]
    assert len(hits) == 1, (head, hits)
    j = hits[0] + 1
    entry = re.compile(r'    "([A-Z][A-Za-z0-9]*): ')
    while not (entry.match(lines[j]) and f'"Becoming.{entry.match(lines[j]).group(1)}"' in checker):
        assert lines[j].startswith('    "'), (leaf, 'description block ends', lines[j][:60])
        j += 1
    assert x['description'] not in checker
    checker = '\n'.join(lines[:j] + x['description'].rstrip('\n').split('\n') + lines[j:])
    for name, row in (('README.md', x['en']), ('README.zh.md', x['zh'])):
        t = readme[name]
        line = [l for l in t.split('\n') if l.startswith(f'| L1 | [`{x["after"]}`]')]
        if not line and name == 'README.zh.md':
            print('no Chinese row for', x['after'], '(the edition is partial): none added for', leaf)
            continue
        assert len(line) == 1, (name, x['after'], len(line))
        readme[name] = after_line(t, line[0] + '\n', row + '\n')
write(PKG / 'Becoming.lean', root)
write(PKG / 'check_becoming.py', checker)
for name, t in readme.items():
    write(PKG / name, t)
print('checked' if CHECK else 'integrated', ', '.join(LEAVES))
