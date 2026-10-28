#!/usr/bin/env python3
"""UE14: join Becoming.Presence to the core as a leaf. Copies the new module (no landed module changes); adds it to
the checker's core list (after Becoming.CausalGrowth, UE13's module) and its scope text (after causal growth's); imports
it in the root module with an L1 doc bullet after CausalGrowth's (its import closure holds no L2 module, and it names no
ethical predicate); adds the package README rows (EN, ZH) after CausalGrowth's. Every name the texts cite is checked
against the scratch build's axiom audit, so a renamed declaration fails here and not at render. Mirrors UE13's
integrate_ue13.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue14.py"""
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree/Becoming'
AUDIT = HERE.parent / 'tree/.build/BecomingPresenceAxiomAudit.lean'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))


def cited(text):
    """Every backticked Presence name in text is a declaration of the module."""
    names = set(re.findall(r'`(Presence\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in names if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# the new module
target = PKG / 'Becoming/Presence.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'Presence.lean', target)

# the checker: core list and scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.CausalGrowth", ', '"Becoming.CausalGrowth", "Becoming.Presence", ')
edit(checker, """    "widening, and up to relabelling the kinds of birth do not reverse precedence. "
    "Standpoints: """, """    "widening, and up to relabelling the kinds of birth do not reverse precedence. "
    "Presence: the present on causal-set growth, read as the maximal elements of what a course has born. "
    "The renumberings of a causal set keeping precedence are exactly the orders of birth of the courses "
    "growing a configuration of its kind, and births of unrelated elements commute and only they. With "
    "precedence decided, an element is born before another on every course exactly where it precedes it, "
    "so what is born no later than an element on every course is its past with itself, the largest relation every "
    "course respects; with precedence weakly decided, on some course exactly where the two differ and it "
    "is not preceded by the other. The present at a stage is an antichain, and with precedence weakly "
    "decided every antichain given by a test is one; two elements are present together on some course exactly where "
    "unrelated and, precedence decided, on every course exactly where they have the same future; a "
    "condition is present at the birth of what it conditions on some course exactly where it is a link "
    "below it (precedence weakly decided) and on every course exactly where that is the one element it is "
    "linked to (no decision). Asked of every causal set, each calibrated decision is exactly excluded middle or its "
    "weak form. On Wuthrich and Callender's four elements their relation, kept by every automorphism, is "
    "the past with the pair present together on every course, and elsewhere that join need not be "
    "transitive. Each main law is also stated on the courses of the growth themselves. "
    "Standpoints: """)

# the root module: import, and the new bullet after CausalGrowth's
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.CausalGrowth\n', 'import Becoming.CausalGrowth\nimport Becoming.Presence\n')
edit(root, """  calibration. A leaf (board item UE13).
* `Becoming.Growth` (L1):""", """  calibration. A leaf (board item UE13).
* `Becoming.Presence` (L1): the present on causal-set growth, read as the maximal elements of what a
  course has born (`Presence.MaximalBorn`, the grammar's ending on what is born:
  `Presence.maximalBorn_iff_ends`). The renumberings of a causal set keeping precedence
  (`Presence.NaturalLabelling`) are exactly the orders of birth of the courses growing a configuration
  of its kind (`Presence.natural_iff_course`), and births of unrelated elements commute and only they
  (`Presence.rearranges_iff_natural`, the core's `rearranges_iff`). With precedence decided, an element
  is born before another on every course exactly where it precedes it (`Presence.prec_iff_every`), so
  what is born no later than an element on every course is its past with itself, the largest relation
  every course respects (`Presence.past_every_iff`, `Presence.past_largest`); with precedence weakly
  decided, on some course exactly where the two differ and it is not preceded by the other
  (`Presence.before_some_iff`), and two different unrelated elements are born in either order
  (`Presence.either_order`). The present at a stage is an antichain (`Presence.maximalBorn_unrelated`),
  and with precedence weakly decided every antichain given by a test is one
  (`Presence.antichain_present`); two elements are present together on some course exactly where
  unrelated (`Presence.together_some_iff`) and, precedence decided, on every course exactly where they
  have the same future (`Presence.together_every_iff`); a condition is present at the birth of what it
  conditions on some course exactly where it is a link below it (`Presence.present_some_iff_link`), and
  on every course, with no decision, exactly where that is the one element it is linked to
  (`Presence.present_every_iff_only_link`). Asked of every causal set, each calibrated decision is
  exactly excluded middle or its weak form (`Presence.every_iff_em`, `Presence.present_some_iff_weakly`). On
  Wüthrich and Callender's four elements their relation, kept by every automorphism, is the past with
  the pair present together on every course (`Presence.Diamond.pastOrPair_kept`,
  `Presence.Diamond.pastOrPair_iff_together`), and elsewhere that join need not be transitive
  (`Presence.SameFuture.pastOrTogether_not_trans`). Each main law is also stated on the courses of the
  growth themselves (`Presence.every_course_iff`, `Presence.present_every_course_only_link`). Each law is
  near-definitional, a lemma, a witness or a calibration. A leaf (board item UE14).
* `Becoming.Growth` (L1):""")


def readme_row(path, row):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.CausalGrowth`]')]
    assert len(at) == 1, at
    assert not any('[`Becoming.Presence`]' in line for line in lines)
    lines[at[0] + 1:at[0] + 1] = [cited(row)]
    path.write_text('\n'.join(lines), encoding='utf-8')


# the package README rows (EN, ZH), after CausalGrowth's
readme_row(PKG / 'README.md',
    '| L1 | [`Becoming.Presence`](Becoming/Presence.lean) | the present on causal-set growth, read as the maximal elements '
    'of what a course has born (no ethical predicate): natural labellings are exactly the orders of birth '
    '(`Presence.natural_iff_course`), births of unrelated elements commute and only they '
    '(`Presence.rearranges_iff_natural`); with precedence decided, born before on every course is precedence '
    '(`Presence.prec_iff_every`, `Presence.past_every_iff`), and weakly decided, on some course differing and not '
    'being preceded (`Presence.before_some_iff`); presents are antichains, and with precedence weakly decided every '
    'antichain given by a test is one (`Presence.maximalBorn_unrelated`, `Presence.antichain_present`); present together on some course where unrelated, on every course where the future '
    'is the same (`Presence.together_some_iff`, `Presence.together_every_iff`); a condition present at a birth on some '
    'course where it is a link (precedence weakly decided), on every course where it is the one link (no decision) '
    '(`Presence.present_some_iff_link`, `Presence.present_every_iff_only_link`); each calibrated decision exact '
    '(`Presence.every_iff_em`, `Presence.present_some_iff_weakly`); each main law also on the courses '
    '(`Presence.every_course_iff`); Wüthrich and Callender\'s relation on their four '
    'elements (`Presence.Diamond.pastOrPair_iff_together`); near-definitional |')

readme_row(PKG / 'README.zh.md',
    '| L1 | [`Becoming.Presence`](Becoming/Presence.lean) | 因果集生长上之现在，读作一历程所已生者之极大元（无伦理谓词）：自然编号恰为生之次序'
    '（`Presence.natural_iff_course`），无先后者之生可互换，且唯其可换（`Presence.rearranges_iff_natural`）；'
    '先后可判定时，于每一历程皆先生即先后（`Presence.prec_iff_every`、`Presence.past_every_iff`），弱可判定时，于某一历程先生即相异且不为其所先'
    '（`Presence.before_some_iff`）；现在皆为反链，先后弱可判定时以检验给出之每一反链皆为一现在（`Presence.maximalBorn_unrelated`、'
    '`Presence.antichain_present`）；于某一历程同处现在即无先后，'
    '于每一历程同处现在即其后相同（`Presence.together_some_iff`、`Presence.together_every_iff`）；缘于其果之生时在现在，于某一历程即其为覆盖'
    '（先后弱可判定），于每一历程即其为唯一之覆盖（无需判定）（`Presence.present_some_iff_link`、`Presence.present_every_iff_only_link`）；'
    '每一校准之判定皆确切'
    '（`Presence.every_iff_em`、`Presence.present_some_iff_weakly`）；每一主律亦述于诸历程之上（`Presence.every_course_iff`）；'
    'Wüthrich 与 Callender 之关系于其四元（`Presence.Diamond.pastOrPair_iff_together`）；近乎定义 |')
print('integrated: Becoming.Presence joined (root import and L1 bullet, checker core list and scope, README rows EN '
      'and ZH); no landed module changed')
