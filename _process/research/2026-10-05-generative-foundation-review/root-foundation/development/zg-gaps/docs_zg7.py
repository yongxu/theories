#!/usr/bin/env python3
"""ZG7 module text: for each module that gained laws, a bullet in its header, a sentence in its package-root
entry and in its checker scope, and a clause in its README rows (EN, ZH). Each anchor must match once.
usage (from the checkout root): python3 -B docs_zg7.py"""
import re
import textwrap
from pathlib import Path

PKG = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming')
D = {
 'RuleCapture': ("**Two rules, and a reading against the share.** Two rules each read monotonically from one share are read so together (`ReadsShare.pair`), so where both favour at every share the pair is locked from the step after the first reading step (`pair_locks`). Read against the share (`ReadsShare P (reverse M) h`), along a course whose rules favour the share falls at no stretch (`share_kept_along`) and the rule read at a later reading step is not above the rule read at an earlier one (`against_not_rising`): the rise the lock rests on does not form.",
   "Two rules read from one share lock together; a rule read against the share does not ratchet.",
   "two rules lock together (`pairOrder`, `pairReading`, `ReadsShare.pair`, `pair_locks`); a reading against the share does not ratchet (`share_kept_along`, `against_not_rising`)",
   "两条规则同锁（`pairOrder`、`pairReading`、`ReadsShare.pair`、`pair_locks`）；逆份额之读法不棘轮（`share_kept_along`、`against_not_rising`）"),
 'Lexical': ("**What the claims do not read.** `Above` reads the claims alone (`Above.congr_left`, `Above.congr_right`, through `Included.congr`, `StrictIncluded.congr`), so under `BasicPriority` two alternatives realizing the same claims are compared alike, neither better than the other (`BasicPriority.same_claims_alike`): a loss imposed by another's part and the same loss self-borne are not ordered unless the agent is among the claims; adjoined as a basic claim, it orders them (`Above.agent_adjoined`).",
   "The comparison cannot weigh what the claims do not read; with the agent among the basic claims, imposed and self-borne loss are ordered.",
   "what the claims do not read (`Above.congr_left`, `Above.congr_right`, `BasicPriority.same_claims_alike`, `Above.agent_adjoined`)",
   "主张所不读者比较不能权衡（`Above.congr_left`、`Above.congr_right`、`BasicPriority.same_claims_alike`、`Above.agent_adjoined`）"),
 'BoundedSignificance': ("**Feeding from a step.** The feeding closure from step `s` (`Flow.WithinFeedingFrom`) is the feeding closure from the first step (`Flow.withinFeedingFrom_zero`) and shrinks with time (`Flow.WithinFeedingFrom.earlier`); what gives to no requirement from `s` on lies outside every other closure from `s` (`Flow.not_withinFeedingFrom`). So care bounded by feeding from each step permits ending a formation that feeds no more (`Flow.feedingFrom_permits`), which the continuation condition counts as a loss (`Flow.feedingFrom_parts`).",
   "Care bounded by feeding from each step withdraws as feeding stops, and permits what the condition counts as a loss.",
   "feeding from a step (`Flow.FedFromAfter`, `Flow.WithinFeedingFrom`, `Flow.withinFeedingFrom_zero`, `Flow.WithinFeedingFrom.earlier`, `Flow.not_withinFeedingFrom`, `Flow.feedingFrom_permits`, `Flow.feedingFrom_parts`)",
   "自一步起之资域（`Flow.FedFromAfter`、`Flow.WithinFeedingFrom`、`Flow.withinFeedingFrom_zero`、`Flow.WithinFeedingFrom.earlier`、`Flow.not_withinFeedingFrom`、`Flow.feedingFrom_permits`、`Flow.feedingFrom_parts`）"),
 'Evolution': ("**A goal along a lineage.** A goal carried at each step passes down a lineage where it passes across each descent and each member keeps it until it gives (`Flow.goal_along`); descendants of carriers carry it exactly where it passes across every descent from a carrier (`Flow.goal_descends_iff`): the condition is the passing at a single descent, and nothing in descent makes it hold.",
   "A goal descends exactly where it passes across each descent from a carrier.",
   "a goal along a lineage (`Flow.goal_along`, `Flow.goal_descends_iff`)",
   "目标沿世系（`Flow.goal_along`、`Flow.goal_descends_iff`）"),
 'Junctures': ("**A source arriving before a juncture.** With `Becoming.TimedResponse`: where a source has not reached a reader by `D`, a reader whose step at `x` is chosen from its answer read through its couplings up to `D` takes the same step in both courses, so a losing step in one is losing in the other (`TimedResponse.same_step_unreached`); where the chosen steps keep `s` in one course and lose it in the other, `x` is a juncture and the source has, not not, reached the reader by `D` (`TimedResponse.turned_at_juncture`).",
   "To turn a reader's step at a juncture, a source must reach it before.",
   "a source arriving before a juncture (`TimedResponse.same_step_unreached`, `TimedResponse.turned_at_juncture`)",
   "至期所及与机（`TimedResponse.same_step_unreached`、`TimedResponse.turned_at_juncture`）"),
 'SelectionPool': ("**A pool read by what most members read.** Taking what more than half the members read (`Web.MajorityHolds`, counted by `Web.holdsCount`) selects through the pooled coupling where each member reads through its own (`Web.majority_through_all`), so it separates no more than the pool; and where more than half read alike on two histories it goes alike on them, however many tell them apart (`Web.majority_outvoted`): shares, not only the couplings present, decide what it separates.",
   "A pool read by its majority separates by shares: a distinction held by fewer than half is outvoted.",
   "a pool read by its majority (`Web.holdsCount`, `Web.MajorityHolds`, `Web.majority_through_all`, `Web.majority_outvoted`)",
   "按多数读取之池（`Web.holdsCount`、`Web.MajorityHolds`、`Web.majority_through_all`、`Web.majority_outvoted`）"),
}

def wrap(text, first, rest, width=100):
    lines = textwrap.wrap(text, width=width - len(rest), break_long_words=False, break_on_hyphens=False)
    return first + lines[0] + '\n' + ''.join(rest + l + '\n' for l in lines[1:])

root = (PKG / 'Becoming.lean').read_text(encoding='utf-8')
chk = (PKG / 'check_becoming.py').read_text(encoding='utf-8')
rd = (PKG / 'README.md').read_text(encoding='utf-8')
zh = (PKG / 'README.zh.md').read_text(encoding='utf-8')
missing = []
for mod, (head, rootline, readme, readme_zh) in D.items():
    p = PKG / 'Becoming' / f'{mod}.lean'
    s = p.read_text(encoding='utf-8')
    i = s.index('-/')
    s = s[:i].rstrip('\n') + '\n' + wrap(head, '* ', '  ') + s[i:]
    p.write_text(s, encoding='utf-8')
    # root entry: append before the next bullet
    start = root.index(f'* `Becoming.{mod}` (')
    nxt = root.index('\n* `Becoming.', start + 1)
    entry = root[start:nxt].rstrip('\n')
    new_entry = entry + '\n' + wrap(rootline, '  ', '  ')
    root = root[:start] + new_entry.rstrip('\n') + root[nxt:]
    # checker scope
    m = re.search(rf'^    "{mod}: ', chk, re.M)
    if m:
        after = re.search(r'^    "[A-Z][A-Za-z]+: ', chk[m.end():], re.M)
        pos = m.end() + after.start()
        prev_line_end = chk.rindex('\n', 0, pos - 1)
        assert chk[pos - 3:pos - 1] == ' "', (mod, chk[pos - 6:pos])
        chk = chk[:pos] + f'    "{rootline} "\n' + chk[pos:]
    else:
        missing.append(('scope', mod))
    # READMEs
    for name, text, clause in (('README.md', rd, readme), ('README.zh.md', zh, readme_zh)):
        key = f'[`Becoming.{mod}`](Becoming/{mod}.lean) |'
        lines = text.split('\n')
        hits = [k for k, l in enumerate(lines) if key in l]
        if len(hits) != 1:
            missing.append((name, mod, len(hits)))
            continue
        l = lines[hits[0]]
        assert l.endswith(' |'), (name, mod)
        sep = '；' if name == 'README.zh.md' else '; '
        lines[hits[0]] = l[:-2] + sep + clause + ' |'
        if name == 'README.md':
            rd = '\n'.join(lines)
        else:
            zh = '\n'.join(lines)
(PKG / 'Becoming.lean').write_text(root, encoding='utf-8')
(PKG / 'check_becoming.py').write_text(chk, encoding='utf-8')
(PKG / 'README.md').write_text(rd, encoding='utf-8')
(PKG / 'README.zh.md').write_text(zh, encoding='utf-8')
print('missing', missing)
