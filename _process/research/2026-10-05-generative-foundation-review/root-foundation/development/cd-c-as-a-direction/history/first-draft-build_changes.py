#!/usr/bin/env python3
"""CD's list of changes: each entry's text checked against the tree, its line found, written to changes.tsv.

usage: python3 -B build_changes.py ROOT OUT.tsv
Fails if a quoted text is not in its file exactly as many times as stated.
When: "freeze" is the fronts' owner's small change on ranking before the freeze, which leaves C's statement alone;
"next" is the next edition, through the generativity chain's maintenance record, with each file's owner.
"""
import sys

OP, OPZ = 'theories/becoming/ONE-PAGE.md', 'theories/becoming/ONE-PAGE.zh.md'
OV, OVZ = 'theories/becoming/THE-THEORY-OF-BECOMING.md', 'theories/becoming/THE-THEORY-OF-BECOMING.zh.md'
CH7, CD, OA = 'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/COLLECTIVE-DIRECTION.md', \
    'theories/becoming/ONE-ARGUMENT.md'
FRONTS = "the fronts' owner"
CHAIN = "CD, through the chain's maintenance record"

# (file, now, proposed, when, carrier, why)
ENTRIES = [
    # the freeze: reader-facing lines on ranking; C's statement untouched
    (OP, "The community's best course, 50 tons a month, ends it",
     "The course that maximizes the community's total catch, 50 tons a month, ends it", 'freeze', FRONTS,
     "a comparison with its basis left out: exact.py's COMM, the community's total catch this season and after it"),
    (OV, "The community's best course, 50 tons a month, ends it",
     "The course that maximizes the community's total catch, 50 tons a month, ends it", 'freeze', FRONTS, 'as above'),
    (OPZ, '社群的最优进程，每月 50 吨，终结它', '使社群总渔获最大的进程，每月 50 吨，终结它', 'freeze', FRONTS, 'as above'),
    (OVZ, '社群的最优进程，每月 50 吨，终结它', '使社群总渔获最大的进程，每月 50 吨，终结它', 'freeze', FRONTS, 'as above'),
    (OP, 'C gives order; a ranking needs it or a premise in its place.',
     'C gives order; an order of courses needs it or a premise in its place.', 'freeze', FRONTS,
     '"a ranking" read as a scale of every course; what needs C is any order of courses'),
    (OPZ, 'C 给出次序；排序需要它，或一个代替它的前提。', 'C 给出次序；进程之间的次序需要它，或一个代替它的前提。', 'freeze', FRONTS,
     'as above'),
    (OV, 'A ranking of courses needs C or a premise in its place.',
     'An order of courses needs C or a premise in its place.', 'freeze', FRONTS, 'as above'),
    (OVZ, '对进程的排序需要 C，或一个代替它的前提。', '进程之间的次序需要 C，或一个代替它的前提。', 'freeze', FRONTS, 'as above'),
    (OP, 'the two are mixed and C leaves them unranked', 'the two are mixed and C does not decide between them',
     'freeze', FRONTS, 'the overview says "C silent"; "unranked" suggests a ranking left incomplete'),
    (OPZ, '二者便是混合的，C 不予排序', '二者便是混合的，C 不作声', 'freeze', FRONTS, "the overview's Chinese wording"),
    # the next edition: C's statement and role
    ('GLOSSARY.md', 'the widening comparison: widening what can form is better; it gives order, in general alone '
     '(self-concern ranks one case with no C)',
     'the widening comparison: widening what can form is the direction to take, and of two courses the one that '
     'widens the other is the better; it gives order, read from the difference between two options, in general alone '
     '(self-concern orders one case with no C)', 'next', CHAIN, "C's statement and role"),
    ('GLOSSARY.md', '| C | the widening comparison',
     'a new row before it: | direction | the way C compares: from a course toward one that widens it; it orders two '
     'courses by their difference alone, never on a scale or to a best; not continuing capacity, per-step growth or '
     'maximization; 生生 its object | [07 §4](...#scope-and-order), [the collective page §1](...) |', 'next', CHAIN,
     'AGENTS.md asks that direction be kept apart from three terms the glossary has no row for it'),
    ('_process/navigation/README-FIRST-SCREEN.md', 'C (widening what can form is better) gives order.',
     'C (widening what can form is the direction to take) gives order, read from the difference between two '
     'options.', 'next', CHAIN, "C's statement and role; README renders from it"),
    ('AGENTS.md', 'C (widening what can form is better) alone gives order.',
     "after the rewrite: C (widening what can form is the direction to take) gives order, read from the difference "
     "between two options", 'next', 'proposed to the coordinator after the rewrite lands', "C's statement and role"),
    (OP, '*C*: widening what can form is better.', '*C*: widening what can form is the direction to take.', 'next',
     FRONTS + ', with ' + CHAIN, "C's statement"),
    (OPZ, '*C*：扩大可形成者更好。', '*C*：扩大可形成者是应取的方向。', 'next', FRONTS + ', with ' + CHAIN, "C's statement"),
    (OP, 'it widens fifty and C ranks it higher', 'it widens fifty, and C takes it over fifty', 'next',
     FRONTS + ', with ' + CHAIN, 'the comparison of two courses, said as the direction'),
    (OPZ, 'C 把它排得更高', 'C 取它而不取五十吨', 'next', FRONTS + ', with ' + CHAIN, 'as above'),
    (OV, 'C, the premise that widening what can form is better, ranks it higher',
     'C, the premise that widening what can form is the direction to take, takes it over fifty', 'next',
     FRONTS + ', with ' + CHAIN, "C's statement; the comparison of two courses"),
    (OVZ, 'C，即扩大可形成者更好这一前提，把它排得更高', 'C，即扩大可形成者是应取的方向这一前提，取它而不取五十吨', 'next',
     FRONTS + ', with ' + CHAIN, 'as above'),
    (OV, 'Order: C, widening what can form is better (§7)', 'Order: C, widening what can form is the direction to take (§7)',
     'next', FRONTS + ', with ' + CHAIN, "C's statement"),
    (OVZ, '次序：C，即扩大可形成者更好（§7）', '次序：C，即扩大可形成者是应取的方向（§7）', 'next', FRONTS + ', with ' + CHAIN,
     "C's statement"),
    (OV, '*C*, that widening what can form is better, fixes *order*: it ranks a course above every course it widens '
     'and leaves mixed comparisons unranked.',
     '*C*, that widening what can form is the direction to take, fixes *order*: of two courses it takes the one that '
     'widens the other, and it decides no mixed comparison.', 'next', FRONTS + ', with ' + CHAIN,
     "C's statement and role"),
    (OVZ, '*C*，即扩大可形成者更好，确定*次序*：它把一个进程排在它所扩大的每一个进程之上，而让混合的比较不予排序。',
     '*C*，即扩大可形成者是应取的方向，确定*次序*：两个进程之间，它取扩大另一个的那个，而不判定任何混合的比较。', 'next',
     FRONTS + ', with ' + CHAIN, "C's statement and role"),
    (CH7, 'C fixes order (that widening is better), the order every positive weighting shares',
     'C fixes order (that widening is the direction to take), read from the difference between two courses, the order '
     'every positive weighting shares', 'next', CHAIN, "C's statement and role"),
    (CH7, '| C: widening what can form is better | **order** | ranks a course above every course it widens | rank mixed '
     'comparisons |',
     '| C: widening what can form is the direction to take | **order** | of two courses, takes the one that widens the '
     'other | decide mixed comparisons |', 'next', CHAIN, "C's statement and role"),
    (CH7, 'The condition alone ranks nothing', 'The condition alone orders nothing', 'next', CHAIN,
     'the same word for every order'),
    (CH7, 'A ranking of courses needs C or a premise in its place: C gives order, in general alone, and an order rising '
     'with one\'s own continuation ranks one case with no C',
     'An order of courses needs C or a premise in its place: C gives order, read from the difference between two '
     'courses, in general alone, and an order rising with one\'s own continuation orders one case with no C', 'next',
     CHAIN, 'as on the fronts'),
    (CH7, 'C ranks courses; choices take more', 'C orders two courses by their difference; choices take more', 'next',
     CHAIN, 'C compares two courses; choosing a move needs L and J'),
    (CH7, '(C, for the ranking)', '(C, for the order)', 'next', CHAIN, 'the same word for every order'),
    ('theories/becoming/chapters/02-MAP.md', 'C for order (that widening is better)',
     'C for order (that widening is the direction to take)', 'next', CHAIN, "C's statement"),
    ('theories/becoming/chapters/08-METHOD.md', '- C fixes order: widening what can form is better.',
     '- C fixes order: widening what can form is the direction to take.', 'next', CHAIN, "C's statement"),
    (CD, "that widening is better is C's (order)", "that widening is the direction to take is C's (order)", 'next',
     CHAIN, "C's statement"),
    (OA, '**C** (widening what can form is better) gives order.',
     '**C** (widening what can form is the direction to take) gives order.', 'next', CHAIN, "C's statement"),
    (OA, 'that wider is better is C', 'that the wider course is the one to take is C', 'next', CHAIN, "C's statement"),
    (OA, 'neither ranks a mixed case', 'neither decides a mixed case', 'next', CHAIN, 'the same word for every order'),
    ('theories/becoming/review/PHILOSOPHY.md', '### P-07 C: widening is better',
     "the dossier's statement of C, with its owner; the heading's anchor kept", 'next', "the dossier's owner, with " + CHAIN,
     "C's statement"),
    ('theories/becoming/review/ALIGNMENT.md', 'C (that widening is better)',
     'C (that widening is the direction to take)', 'next', "the dossier's owner, with " + CHAIN, "C's statement"),
    ('theories/becoming/review/LOGIC.md', 'C (that widening what can form is better) for order',
     'C (that widening what can form is the direction to take) for order', 'next', "the dossier's owner, with " + CHAIN,
     "C's statement"),
    ('theories/becoming/results/GENERATIVITY-CHAIN.md', 'C, widening what can form is better, gives order, in general alone',
     "C, widening what can form is the direction to take, gives order, read from the difference between two options, "
     "in general alone; through the chain's key and the entries that state it", 'next', CHAIN, "C's statement and role"),
]


def main():
    root, out = sys.argv[1], sys.argv[2]
    rows, bad = [], []
    for f, now, new, when, carrier, why in ENTRIES:
        text = open(f'{root}/{f}', encoding='utf-8').read()
        n = text.count(now)
        if n == 0:
            bad.append(f'{f}: not found: {now[:70]}')
            continue
        lines = [i + 1 for i, l in enumerate(text.split('\n')) if now in l]
        rows.append((f, ','.join(map(str, lines)) if lines else 'spans lines', str(n), when, carrier, now, new, why))
    if bad:
        raise SystemExit('\n'.join(bad))
    with open(out, 'w', encoding='utf-8') as o:
        o.write('file\tline\ttimes\twhen\tcarrier\tnow\tproposed\twhy\n')
        for r in rows:
            o.write('\t'.join(r) + '\n')
    print(len(rows), 'entries;', sum(r[3] == 'freeze' for r in rows), 'for the freeze,',
          sum(r[3] == 'next' for r in rows), 'for the next edition')


if __name__ == '__main__':
    main()
