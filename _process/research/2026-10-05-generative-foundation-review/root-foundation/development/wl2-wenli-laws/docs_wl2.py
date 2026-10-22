#!/usr/bin/env python3
"""WL2 module text: for each module that gained laws, a sentence in its package-root entry and in its checker
scope, and a clause in its README rows (EN, ZH); the module headers carry their bullets already. Each anchor must
match once. usage (from the checkout root): python3 -B docs_wl2.py"""
import re
import textwrap
from pathlib import Path

PKG = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming')
D = {
 'IdentificationRuns': (
   "The same course through the map is the coarsest relation keeping a map's values that a determined law keeps; a class keeping the values and carrying the law is coarser than every such relation exactly where it merges exactly the configurations with the same course, and, where a list holds every configuration, coarsest among such classes into the universe of the values exactly there. Where a reading gives the values of what couples into a formation, being alike through its couplings up to a step is one prefix of its own course, a selection through them selects by that prefix, and own courses with at most N and N' states fix what it tells apart within N + N' - 1 steps, a bound attained.",
   "the coarsest class keeping the map's values and carrying the law (`Law.KeepsAndCarries`, `Law.sameFuture_coarsest`, "
   "`Law.coarsest_iff`, `Law.coarsest_class`); " + "a formation's own course (`Web.ValuesThrough`, `Web.courseThrough`, `Web.alikeThroughUpTo_iff_prefix`, `Web.selectsThrough_iff_prefix`, `Web.alike_of_bounded`, `Web.bounded_exact`, `Web.alike_of_joint_bounded`, `Web.states_by_reading`)",
   "守象之值而载法之最粗之类（`Law.KeepsAndCarries`、`Law.sameFuture_coarsest`、`Law.coarsest_iff`、`Law.coarsest_class`）；"
   "待者自身之文（`Web.courseThrough`、`Web.alikeThroughUpTo_iff_prefix`、`Web.selectsThrough_iff_prefix`、"
   "`Web.alike_of_bounded`、`Web.bounded_exact`）"),
 'SharedCodes': (
   'Through a code the course of forms of every course of senses is one state at exactly the moments the course of senses is, exactly where the code tells the senses apart; where resolution reads every encoded sequence, it reads the course of forms of every course of words as its course of meanings, step by step.',
   "the course of forms (`course_states_iff`, `course_read`, `code_read_every`)",
   "名之文（`course_states_iff`、`course_read`、`code_read_every`）"),
}


def wrap(text, first, rest, width=100):
    lines = textwrap.wrap(text, width=width - len(rest), break_long_words=False, break_on_hyphens=False)
    return first + lines[0] + '\n' + ''.join(rest + l + '\n' for l in lines[1:])


root = (PKG / 'Becoming.lean').read_text(encoding='utf-8')
chk = (PKG / 'check_becoming.py').read_text(encoding='utf-8')
rd = (PKG / 'README.md').read_text(encoding='utf-8')
zh = (PKG / 'README.zh.md').read_text(encoding='utf-8')
missing = []
for mod, (rootline, readme, readme_zh) in D.items():
    start = root.index(f'* `Becoming.{mod}` (')
    nxt = root.index('\n* `Becoming.', start + 1)
    entry = root[start:nxt].rstrip('\n')
    root = root[:start] + (entry + '\n' + wrap(rootline, '  ', '  ')).rstrip('\n') + root[nxt:]
    m = re.search(rf'^    "{mod}: ', chk, re.M)
    after = re.search(r'^    "[A-Z][A-Za-z]+(, section [A-Za-z]+)?: ', chk[m.end():], re.M)
    pos = m.end() + after.start()
    assert chk[pos - 3:pos - 1] == ' "', (mod, chk[pos - 6:pos])
    chk = chk[:pos] + f'    "{rootline} "\n' + chk[pos:]
    for name, clause in (('README.md', readme), ('README.zh.md', readme_zh)):
        text = rd if name == 'README.md' else zh
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
