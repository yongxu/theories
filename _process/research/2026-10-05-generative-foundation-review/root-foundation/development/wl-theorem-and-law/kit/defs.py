#!/usr/bin/env python3
"""defs <tree>: rewrite the defining entries (08's word table row, 08 section 10's paragraph, the glossary rows, the Chinese glossary rows).
Run after the pieces are joined. Each target line is found by its opening words and must be found exactly once."""
import sys
tree = sys.argv[1]
REVIEW = '[the deep unification review](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/du-deep-unification-review/REVIEW.md)'
WORDS = '[Ren, 13 November 2026](../../../sources/15-codex-theory-conversations/2026-11-13-what-a-law-is-and-the-words.md)'
def edit(path, jobs):
    p = f'{tree}/{path}'
    s = open(p, encoding='utf-8').read()
    L = s.split('\n')
    for start, fn in jobs:
        idx = [i for i, l in enumerate(L) if l.startswith(start)]
        assert len(idx) == 1, (path, start, len(idx))
        new = fn(L[idx[0]])
        assert isinstance(new, list)
        L[idx[0]:idx[0] + 1] = new
    out = '\n'.join(L)
    with open(p, 'w', encoding='utf-8') as f:
        f.write(out)
    print('edited', path)

# ---- chapter 08
def table_row(old):
    assert old == '| law, theorem | a rule of change; a checked statement | |', old
    return ['| law | a determined step (`Law`), one next for each configuration; what holds in every model of a class; a science\'s law, named with its science ([§10](#law)) | one of the account\'s own proved statements, which is a *theorem*; a rule that someone holds |',
            '| theorem | a checked statement, holding of everything its hypotheses admit ([§10](#law)) | a "law of the theory", its name here until 13 November 2026; a *result*, which is any registered record |']
def law_par(old):
    head = '**Law.** The word has three senses, kept apart. A law of the theory is a statement that holds of every relation, carrier or model its hypotheses admit. It is read off what it holds of and does not stand over it: a law of the root holds of every carrier, relation and class, so it forbids no relation, and a law with content is conditional and forbids through its hypotheses (' + REVIEW + '). `Law`, the spine\'s name for a determined step, is one relation, `next x = y`, among the others: its configurations are related by it, not ruled by it. A science\'s law is named with its science (thermodynamics\' first and second laws). The account\'s laws are laws of the theory. One with content can become a science\'s law for a domain only once the domain is shown to meet its hypotheses. '
    assert old.startswith(head), old[:200]
    rest = old[len(head):]
    assert rest.startswith('That runs through a stated correspondence'), rest[:80]
    p1 = ('**Theorem and law.** The account calls its own proved statements *theorems* (定理). A theorem holds of every relation, carrier or model its hypotheses admit. '
          'It is read off what it holds of and does not stand over it: a theorem of the root holds of every carrier, relation and class, so it forbids no relation, and a theorem with content is conditional and forbids through its hypotheses (' + REVIEW + '). '
          'Until 13 November 2026 these were called laws of the theory. The word was changed because it states a wrong meaning: a reader takes a law for a regularity of the world, or for a rule with someone behind it, and the account claims neither of what it has proved (' + WORDS + ').')
    p2 = ('"Law" stays in three senses, kept apart. `Law`, the spine\'s name for a determined step, is one relation, `next x = y`, among the others, in the ordinary sense of a law of motion: its configurations are related by it, not ruled by it. '
          'A law of a class of models is what holds in every model of the class, the thing a completeness theorem counts ("the premises add at most one law"). '
          'A science\'s law is named with its science (thermodynamics\' first and second laws). '
          'A theorem with content can become a science\'s law for a domain only once the domain is shown to meet its hypotheses. ' + rest)
    p3 = ('Names given before the change keep the word until they are revised: "shared law" (共律), a record\'s numbered "law 5", and the titles and ids of records. '
          'The records\' pages, the Chinese editions and [chapter 06](06-CLASSICAL-TEXTS.md) are not yet revised; where one of them says "law" (律) of something the account has proved, it means a theorem.')
    return [p1, '', p2, '', p3]
edit('theories/becoming/chapters/08-METHOD.md', [('| law, theorem |', table_row), ('**Law.** The word has three senses', law_par)])

# ---- glossary (English)
LINK10 = '[08 §10](theories/becoming/chapters/08-METHOD.md#law)'
def g_law(old):
    assert old.startswith('| law (律, *lǜ*) | a statement holding of every relation, carrier or model its hypotheses admit, read off what it holds of and not set over it; with content only through its hypotheses. `Law` is'), old[:120]
    assert old.endswith('| ' + LINK10 + ' |'), old[-120:]
    return ['| theorem (定理, *dìnglǐ*) | one of the account\'s own proved statements: it holds of every relation, carrier or model its hypotheses admit, is read off what it holds of and not set over it, and has content only through its hypotheses. Called a law of the theory until 13 November 2026 | ' + LINK10 + ' |',
            '| law (律, *lǜ*) | `Law` is the spine\'s name for a determined step, one relation (`next x = y`), not a rule its configurations obey; a law of a class of models is what holds in every model of the class; a science\'s law is named with its science. None of the three is a *theorem*, and a rule that someone holds is none of them | ' + LINK10 + ' |']
def g_shared(old):
    a = '| shared law (共律, *gònglǜ*) | a law that many central results share and are proved through, stated once at the lowest layer that holds it: closure, balance, finite runs, lumping, widening. It ranks no law and rules nothing; formerly "master law"'
    assert old.startswith(a), old[:200]
    return ['| shared law (共律, *gònglǜ*) | a theorem that many central results share and are proved through, stated once at the lowest layer that holds it: closure, balance, finite runs, lumping, widening. It ranks no theorem and rules nothing. The name keeps the earlier word for a theorem until the names are revised; formerly "master law"' + old[len(a):]]
edit('GLOSSARY.md', [('| law (律, *lǜ*) |', g_law), ('| shared law (共律', g_shared)])

# ---- glossary (Chinese)
ZL = '[第八章 §10](theories/becoming/chapters/08-METHOD.md#law)'
def z_law(old):
    assert old.startswith('| 律（law） | 一个陈述，对其假设所容许的每一个关系、载体或模型都成立'), old[:60]
    assert old.endswith('| ' + ZL + ' |'), old[-100:]
    return ['| 定理（theorem） | 本理论自己已证明的一个陈述：对其假设所容许的每一个关系、载体或模型都成立，从它所成立的对象上读出，而不是加于其上；只经由其假设而有内容。2026 年 11 月 13 日以前称为本理论的“律” | ' + ZL + ' |',
            '| 律（law） | `Law` 是一个确定之步的脊柱之名，即一个关系（`next x = y`），不是其构形所遵从的一条规则；一类模型的律，是在该类每一个模型中都成立者；一门科学的律，冠以该科学之名。三者都不是*定理*，为人所执持的规则也不在其中 | ' + ZL + ' |']
def z_cal(old):
    assert '一条律在何处需要一个全知原理' in old
    return [old.replace('一条律在何处需要一个全知原理', '一条定理在何处需要一个全知原理')]
def z_hyp(old):
    assert '一条律自身的局部前提' in old
    return [old.replace('一条律自身的局部前提', '一条定理自身的局部前提')]
def z_shared(old):
    assert '许多核心结果共有、并经由它而证明的一条律' in old and '它不给任何律排序，也不统辖任何东西；' in old
    return [old.replace('许多核心结果共有、并经由它而证明的一条律', '许多核心结果共有、并经由它而证明的一条定理')
               .replace('它不给任何律排序，也不统辖任何东西；', '它不给任何定理排序，也不统辖任何东西。此名在诸名修订之前，仍用旧字称定理；')]
edit('GLOSSARY.zh.md', [('| 律（law） |', z_law), ('| 校准（calibration） |', z_cal), ('| 假设（hypotheses） |', z_hyp), ('| 共律（shared law） |', z_shared)])
