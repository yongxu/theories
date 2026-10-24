#!/usr/bin/env python3
"""Join Becoming.PoolCourse, Becoming.Latency and Becoming.Centers to the root, the checker's core list and
scope, and the package README (idempotent).  usage: python3 -B join_modules.py  (from the checkout root)"""
import re
from pathlib import Path

LEAN = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming')

MODULES = [
    # (module, imported after, doc anchor module, doc bullet, scope sentence, readme anchor module, readme row)
    ('PoolCourse', 'PoolResponse',
     "* `Becoming.PoolCourse` (L1): how a pool's membership forms along a run, and what it can come\n"
     "  to couple into. A member that has coupled two histories apart keeps the pool apart while it\n"
     "  stays. A pool that admits its next members through its own pooled coupling has the same\n"
     "  members under two histories up to and including the first step it couples them apart, and the\n"
     "  pool along either history separates them there; it never couples them apart exactly when the\n"
     "  pool along the other never does, and then every selection through it selects them alike. So a\n"
     "  pool recruiting through itself comes to couple into a loss only as its course without the loss\n"
     "  would; an admission by what no member couples into, or a member its course holds anyway, is\n"
     "  needed for more (`PoolCourse`).\n",
     '    "PoolCourse: a member that has coupled two histories apart keeps the pool apart while it stays; "\n'
     '    "a pool admitting its next members through its own pooled coupling has the same members under "\n'
     '    "two histories up to the first step it couples them apart, separates them there along either, "\n'
     '    "and never separates them exactly when the pool along the other never does, every selection "\n'
     '    "through it then selecting them alike; an admission by what no member couples into separates "\n'
     '    "a loss the self-recruiting pool never does. "\n',
     'Rejoining',
     "| L1 | [`Becoming.PoolCourse`](Becoming/PoolCourse.lean) | how a pool's membership forms along a run (no axiom; recruiting through the pool and the same members at the start are hypotheses of the theorems): a member that has coupled two histories apart keeps the pool apart while it stays (`Web.apart_while_member`); a pool admitting its next members through its own pooled coupling (`Web.RecruitsThrough`) has the same members under both histories up to the first step it couples them apart (`Web.RecruitsThrough.members_alike`), separates them there along either (`Web.RecruitsThrough.first_apart`), and never separates them exactly when the pool along the other never does (`Web.RecruitsThrough.alike_iff`), every selection through it then selecting them alike (`Web.RecruitsThrough.selects_alike`); a keeper alone never couples a lost habitat apart, a pool calling a reader where the habitat reads empty does not recruit through itself and couples the loss apart at once, and a pool scheduling the reader in every history couples it apart through a member the course without the loss holds too (`PoolCourse`) |\n"),
    ('Latency', 'TimedResponse',
     "* `Becoming.Latency` (L1): what a reader can come to know of an act, step by step. Routes\n"
     "  counted by coupling links (`TimedResponse.Linked`): where every source step is at `S` or later,\n"
     "  a potential route reaches a condition at step `t` only within `t - S` links, so under\n"
     "  TimedResponse's deadline premises no answer a reader gives through its couplings differs by `T`\n"
     "  unless a condition coupled into it lies within `T - S` links of the source. The region a reader\n"
     "  can represent from what it reads is drawn along coupling links and grows by at most one link a\n"
     "  step; in `Relay` the bound is attained at two links.\n",
     '    "Latency: routes counted by coupling links; from sources at S or later a route reaches a "\n'
     '    "condition at t only within t - S links, so no answer a reader gives through its couplings "\n'
     '    "differs by T unless a condition coupled into it lies within T - S links; attained at two links "\n'
     '    "in Relay. "\n',
     None,
     "| L1 | [`Becoming.Latency`](Becoming/Latency.lean) | what a reader can come to know of an act, step by step (no axiom; TimedResponse's deadline premises and that every source step is at `S` or later are hypotheses of the theorems): routes counted by coupling links (`TimedResponse.Linked`, `Linked.one_le`); a potential route reaches a condition at step `t` only within `t − S` links (`TimedResponse.Spread.linked`), so whatever reaches a reader by `T` came through a condition coupled into it within `T − S` links (`TimedResponse.reachedBy_linked`, `TimedResponse.not_reached_of_far`), and no answer it gives through its couplings differs by `T` otherwise (`TimedResponse.answer_alike_far`); in `Relay` the reader's answer is alike at step 2 and differs at step 3 (`Relay.answers_two_and_three`, `Relay.not_reached_at_two`, `Relay.reached_at_three`) |\n"),
    ('Centers', 'Latency',
     "* `Becoming.Centers` (L1): where what a formation does comes back to it. Two formations lie in\n"
     "  one loop where each can affect the other's continuation at some remove, an equivalence; a\n"
     "  formation's acts return where whatever it can affect can affect it, exactly where its loop is\n"
     "  closed under affecting, a property of the whole loop. Where its acts return, everything it acts\n"
     "  on lies within what it can represent, exactly so with coupling by threshold only. Loops only\n"
     "  merge as exchange grows, and in `Line` closing one link makes one returning loop; with finitely\n"
     "  many formations and reach decided, every formation's reach holds a formation whose acts return.\n",
     '    "Centers: two formations lie in one loop where each can affect the other at some remove; a "\n'
     '    "formation\'s acts return exactly where its loop is closed under affecting, and then all it acts on "\n'
     '    "lies within what it can represent, exactly with coupling by threshold only; loops only merge as "\n'
     '    "exchange grows, and over finitely many formations with reach decided every reach holds a "\n'
     '    "returning formation. "\n',
     None,
     "| L1 | [`Becoming.Centers`](Becoming/Centers.lean) | where what a formation does comes back to it (no axiom; finitely many formations listed and reach decided are hypotheses where stated): one loop of mutual reach, an equivalence (`Flow.InOneLoop`); acts that return (`Flow.ReachReturns`) exactly where the loop is closed under affecting (`Flow.reachReturns_iff_closed`), a property of the loop (`ReachReturns.of_loop`); then all that is acted on lies within the coupling closure (`ReachReturns.represented`), exactly with coupling by threshold only (`Flow.reachReturns_iff_represented`); loops only merge as exchange grows (`InOneLoop.mono`); every reach holds a returning formation over finitely many formations (`Flow.exists_reachReturns`); in `Line` closing one link makes one returning loop |\n"),
]


def main():
    root = LEAN / 'Becoming.lean'
    checker = LEAN / 'check_becoming.py'
    readme = LEAN / 'README.md'
    r, c, m = root.read_text(), checker.read_text(), readme.read_text()
    for mod, after, bullet, scope, readme_before, row in MODULES:
        name = f'Becoming.{mod}'
        if f'import {name}\n' not in r:
            r = r.replace(f'import Becoming.{after}\n', f'import Becoming.{after}\nimport {name}\n', 1)
            assert f'import {name}\n' in r, mod
        if f'* `{name}` (L1)' not in r:
            i = r.index(f'* `Becoming.{after}` (L1)')
            j = r.index('\n* ', i + 1)
            r = r[:j + 1] + bullet + r[j + 1:]
        if f'"{name}", ' not in c:
            assert f'"Becoming.{after}", ' in c, after
            c = c.replace(f'"Becoming.{after}", ', f'"Becoming.{after}", "{name}", ', 1)
        if f'"{mod}: ' not in c:
            i = c.index(f'    "{after}: ')
            k = re.compile(r'\n    "[A-Z][A-Za-z]+: ').search(c, i + 1)
            c = c[:k.start() + 1] + scope + c[k.start() + 1:]
        if f'[`{name}`]' not in m:
            if readme_before:
                i = m.index(f'| L1 | [`Becoming.{readme_before}`]')
                m = m[:i] + row + m[i:]
            else:
                i = m.index(f'| L1 | [`Becoming.{after}`]')
                j = m.index('\n', i)
                m = m[:j + 1] + row + m[j + 1:]
    root.write_text(r)
    checker.write_text(c)
    readme.write_text(m)
    print('joined')


if __name__ == '__main__':
    main()
