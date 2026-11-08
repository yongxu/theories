#!/usr/bin/env python3
"""WB: astra's second-round findings (review/readers/round2-astra.md). Exact replacements, each counted; an applied one
is skipped. The pattern astra names: a particular assumption restated as a universal requirement (every ranking on
two readings; every unreturned loss only through the condition; a measure for every further judgment), and a lost
guarantee read as a lost conclusion (P4)."""
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else '.')


def rep(path, pairs, js=False):
    p = ROOT / path
    s = p.read_text(encoding='utf-8')
    for item in pairs:
        a, b, n = item if len(item) == 3 else (*item, 1)
        if js:
            a, b = json.dumps(a, ensure_ascii=False)[1:-1], json.dumps(b, ensure_ascii=False)[1:-1]
        if s.count(a) == 0 and s.count(b) >= 1:
            continue
        if s.count(a) != n:
            raise SystemExit(f'{path}: {s.count(a)} of {a[:80]!r}, expected {n}')
        s = s.replace(a, b)
    if js:
        json.loads(s)
    p.write_text(s, encoding='utf-8')


B = 'theories/becoming/'
C7 = B + 'chapters/07-SIGNIFICANCE.md'
IN1_OLD = "T4's frozen test was designed for T4, not for this thesis, and does not test it: the bed gives the fishers nothing, so keeping it is not forgoing a draw on a renewal they depend on."
IN1_NEW = ("T4's frozen test was designed for T4, not for this thesis, and does not test it: keeping the bed forgoes part of the fishers' catch, "
           "but their largest steady catch already stays within the fish's renewal while ending the bed, so the test asks nothing of selecting a draw beyond a renewal its readers depend on.")
P4_OLD = "If P4 fails, one route toward part of scope is gone, and so is [T8](#theses)'s reading that the line of any actor whose acts reach living lines runs through life; the makers' offer itself does not rest on this path."
P4_NEW = ("If P4 fails, one route toward part of scope is gone: the theorem no longer establishes that everything downstream of one's acts lies on one's line, "
          "and whether an actor's line runs through life, as [T8](#theses) reads it under P2 and P4, is a separate question; the makers' offer itself does not rest on this path.")

rep(C7, [
    ("The chapter's ranking results are conditional on two readings it names, neither the account's own:",
     "Each of the chapter's ranking results states what it is conditional on, none the account's own; most use two readings:"),
    ("C fixes order (a course above every course it widens), the order every positive weighting shares. Claimed:",
     "C fixes order (a course above every course it widens), the order every positive weighting shares; the self-concern results use the narrower order they state. Claimed:"),
    ("Ordering a mixed part needs a measure.", "Widening alone does not settle a mixed part; a further judgment names its criterion and who holds it, and the criterion need not be a number."),
    ("and ordering them needs a measure ([above](#r-four-cases-of-a-part)), a premise beyond C and the condition.",
     "and widening alone does not settle them: a further judgment names its criterion and who holds it ([above](#r-four-cases-of-a-part)), a premise beyond C and the condition."),
    ("telling harm from non-harm among them needs a measure.", "telling harm from non-harm among them takes a judgment that names its criterion and who holds it, not necessarily a number."),
    (P4_OLD, P4_NEW),
    (IN1_OLD, IN1_NEW),
    ("an expansion that ends forms of life another course keeps both exceeds that course and fails to include it, so the two are mixed and C does not rank them, and T8, the makers' offer, ranks neither ([§8](#theses));",
     "where an expansion admits something another course does not and ends forms of life that course keeps, the two are mixed: C alone gives no verdict, and T8, the makers' offer, ranks neither ([§8](#theses));"),
    ("(each point decided at each moment, and something new found after each step)",
     "(each point refuted or unrefuted at each moment, and something new found after each step after which not everything held was held before)"),
])
rep(B + 'chapters/08-METHOD.md', [
    ("under the continuation condition it is retaining and adding; a ranking is under two named readings, the continuation condition for scope and C for order |",
     "under the continuation condition it is retaining and adding; that the wider is better is C's reading, with the continuation condition for scope |"),
    ("Where a result ranks courses it names two readings with two roles, listed apart:", "Most ranking results use two readings with two roles, listed apart:"),
    ("| the finite theorem `Weighting.widens_iff_every_of_class` beside it, and T4's test |",
     "| the finite theorem `Weighting.widens_iff_every_of_class` beside it; T4's test bears on keeping what another depends on, not on this prediction |"),
])
rep(B + 'results/completion/COVERAGE.json', [
    ("under the continuation condition it is retaining and adding; a ranking is under two named readings, the continuation condition for scope and C for order",
     "under the continuation condition it is retaining and adding; that the wider is better is C's reading, with the continuation condition for scope"),
])
rep(B + 'ONE-PAGE.md', [
    ("where it ranks courses it names two readings, neither asserted, each a hypothesis wherever used,",
     "where it ranks courses it names what it ranks under, most often two readings, neither asserted, each a hypothesis wherever used,"),
])
rep(B + 'ONE-PAGE.zh.md', [
    ("凡它对进程排序之处，都指名两种读法，二者都不被断言，", "凡它对进程排序之处，都指名其所据，最常是两种读法，二者都不被断言，"),
])
rep('_process/navigation/README-FIRST-SCREEN.md', [
    ("where it ranks courses it names [two readings](../../theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order), neither asserted:",
     "where it ranks courses it names what it ranks under, most often [two readings](../../theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order), neither asserted:"),
])
rep('_process/navigation/README-ZH.md', [
    ("凡它对进程排序之处，都指名[两种读法](../../theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order)，二者都不被断言。",
     "凡它对进程排序之处，都指名其所据，最常是[两种读法](../../theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order)，二者都不被断言。"),
])
rep('tools/research/navigation.py', [
    ("'No law here evaluates; where a result ranks courses, it names the two readings it ranks under, neither asserted: '",
     "'No law here evaluates; each ranking result names what it ranks under, most often two readings, neither asserted: '"),
])
rep(B + 'OPENING.md', [
    ("orders nothing: where the work ranks, it uses comparison by widening (C), and acting on significance",
     "orders nothing: where the work ranks, it uses C, comparison by widening, or a narrower order it names, and acting on significance"),
])
rep('AGENTS.md', [
    ("Neither follows from a satisfiable statement reading only the represented dynamics, with significance or order left free and a standpoint, formation or extension given (",
     "Neither follows from a satisfiable statement reading only the represented dynamics, with significance left free and a standpoint and a formation given, or with order left free on a frame with an extension ("),
])
rep(B + 'review/PHILOSOPHY.md', [
    ("T8 reads, under P2 and P4, the line of any actor whose acts reach living lines as running through life; if P4 fails that reading goes, and Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: \"the makers' offer itself does not rest on this path.\"",
     "T8 reads, under P2 and P4, the line of any actor whose acts reach living lines as running through life; if P4 fails, the theorem no longer establishes it, whether it holds being a separate question, and Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: \"the makers' offer itself does not rest on this path.\""),
    ("Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: \"the bed gives the fishers nothing, so keeping it is not forgoing a draw on a renewal they depend on.\"",
     "Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: \"keeping the bed forgoes part of the fishers' catch, but their largest steady catch already stays within the fish's renewal while ending the bed\"."),
])
rep(B + 'review/CLASSICAL-TEXTS.md', [
    ("「天地之大德曰生」读作一项比较之承诺，相当于理论的另一读法 C（以广为愈：能形成者更广，即为更好；它给出次序，凡排序者，以它或别一种所指名的次序排序；理论也不断言它），不是定理。",
     "「天地之大德曰生」可与重生之评价相参，不因此等同于 C，也不是定理；C 是以广为愈的比较读法，本论不断言它。"),
])

# The crosswalk.
CW = B + 'results/atlas/entries/correspondences.json'
rep(CW, [
    ("a comparison uses a stated order and scope, C and the continuation condition where the account ranks,",
     "a comparison uses a stated order and scope, most often C and the continuation condition,"),
    ("Where it ranks, it names the continuation condition (scope) and C (order), neither asserted,",
     "Where it ranks, it names what it ranks under, most often the continuation condition (scope) and C (order), neither asserted,"),
    ("Where evaluation enters, it rests on two readings, neither asserted: the continuation condition for scope and C for order.",
     "Where a ranking enters, it names what it ranks under, most often two readings, neither asserted: the continuation condition for scope and C for order."),
    ("T8, with the continuation condition for scope and C for order, neither asserted, starts from what acting presupposes; the nearest evidence, acts aimed past one's death, is read as supporting neither side alone.",
     "The separate P1–P4 argument starts from what acting presupposes; acts aimed past one's death are read as supporting neither side of that argument alone. T8 is the makers' offer, binding no one."),
    ("T8's stance starts from what acting presupposes, held de se (§4.6, P1).", "P1 begins §4.6's separate argument; T8's offer does not rest on it."),
    ("T8's \"for life\" comes nearest his kind-relative good, yet starts from what acting presupposes.",
     "T8's \"for life\" comes nearest his kind-relative good; it names the makers' offer and is not derived from what acting presupposes."),
    ("“No ending is ranked above keeping by retaining”.", "“Retaining adds no ending and ranks nothing”."),
    ("Mixed comparisons are left unranked by both;", "Neither the continuation condition nor C alone orders a mixed pair;"),
    ("A full ranking of courses needs C, or another order, for order, and counting losses that return to no one needs the continuation condition for scope;",
     "A full ranking of courses rests on C or another named order; the continuation condition counts every unreturned loss, while narrower scopes can count particular ones without satisfying it;"),
], js=True)
p = ROOT / CW
s = p.read_text(encoding='utf-8')
s, k = re.subn(r', and counting (the )?losses that return to no one needs the continuation condition\.',
               '; the continuation condition counts every unreturned loss, while narrower scopes can count particular ones without satisfying it.', s)
json.loads(s)
p.write_text(s, encoding='utf-8')
print('crosswalk clause', k)
print('done')
