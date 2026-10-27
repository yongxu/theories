#!/usr/bin/env python3
"""Check that every passage the review quotes occurs in its file (whitespace runs collapsed, for wrapped lines).
usage: python3 -I check_report_quotes.py WORKTREE REVIEWDIR"""
import json, re, sys
from pathlib import Path
WT, R = Path(sys.argv[1]), Path(sys.argv[2])
PKG = WT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
def norm(s): return re.sub(r'\s+', ' ', s)
def jtext(p):
    out = []
    def walk(x):
        if isinstance(x, str): out.append(x)
        elif isinstance(x, dict): [walk(v) for v in x.values()]
        elif isinstance(x, list): [walk(v) for v in x]
    walk(json.loads(p.read_text(encoding='utf-8')))
    return '\n'.join(out)
F = {
 'ch7': (WT / 'theories/becoming/chapters/07-SIGNIFICANCE.md').read_text(encoding='utf-8'),
 'p20': (WT / 'theories/becoming/review/PHILOSOPHY.md').read_text(encoding='utf-8'),
 'gp': (PKG / 'Becoming/GrammarPath.lean').read_text(encoding='utf-8'),
 'root': (PKG / 'Becoming.lean').read_text(encoding='utf-8'),
 'readme': (PKG / 'README.md').read_text(encoding='utf-8'),
 'scope': (PKG / 'check_becoming.py').read_text(encoding='utf-8'),
 'study': (R / 'study-section-draft.md').read_text(encoding='utf-8'),
 'rec': jtext(R / 'record-draft.json'),
 'old': jtext(R / 'record-before.json'),
}
Q = [
 ('rec', "Where the member acts, it and alike occurrences must follow each other, so only its own leaving effects bear on the division outside."),
 ('rec', "员有所缘时，员与同类者须相随，故唯其己出类之效系于类外之分。"),
 ('rec', "With them the condition at the member's class gives the reach, and holds the effects of every alike occurrence, but the reach does not need it:"),
 ('rec', "持之，则员之类之至终有常足致此及，并持每一同类者之所缘，而此及不须之："),
 ('rec', "so only what is alike to the member's own effects that leave the class bears on it"),
 ('rec', "故唯与员己出类之效同类者系于此条件"),
 ('rec', "which the condition gives but the reach does not need (OtherLeaves)"),
 ('rec', "此条件致之而此及不须之（OtherLeaves）"),
 ('rec', "The path itself asks less: that the class hold the effects of the self and of every stage downstream of its acts;"),
 ('rec', "That the class of an actual agent's line holds the effects of every stage downstream of its acts, with P2 or without it (a correspondence)."),
 ('rec', "holds the effects of every stage downstream of its acts"),
 ('rec', "其行之下游每一阶之所缘"),
 ('rec', "Which of these one presupposes is put to philosophers (P-20)."),
 ('rec', "所预设者为何，交哲学家（P-20）。"),
 ('rec', "…and of everything downstream of it, with no regularity;".lstrip('…')),
 ('rec', "Constancy read at a member's class, and how what lies outside it is divided"),
 ('rec', "故唯与员己出类之效同类者系于此条件，类持员之所缘时，类外如何分无关。"),
 ('rec', "so only what is alike to the member's own effects that leave the class bears on it, and where the class holds the member's effects, how what lies outside is divided is idle."),
 ('rec', "the reach needs only that the class hold the effects of the member and all after it."),
 ('old', "The crux, P4, is put to philosophers."),
 ('ch7', "- **Witnesses.** Neither premise can be dropped:"),
 ('ch7', "In a net where a member conditions one thing, that thing conditions another, and an occurrence alike to the member conditions only something outside the class, the class holds the member's effects and everything downstream of the member lies on its line, while the class fails the condition at the member and does not hold the other occurrence's effects (`OtherLeaves.reach_without_condition`, `OtherLeaves.other_not_held`)."),
 ('ch7', "So only the member's own effects that leave the class bear on it: two classes that give the member the same class, and agree on what is alike to each of those effects, give the same verdict (`«外分唯系己出之同»`)."),
 ('ch7', "P4 is its first step and cannot be dropped at all (`«后皆续则所缘同于»`): an effect not alike to oneself lies on no line under one's class (`«线内同类»`), as `Unclosed` shows for a line that runs through a condition."),
 ('ch7', "But it is not the only way: a class can hold one's effects while everything downstream of one's acts lies on one's line without it (`OtherLeaves.reach_without_condition`), and, given P4 and acting, it gives more than the reach asks, the holding of the effects of every occurrence alike to oneself, on one's line or not (`«本类常闭则所缘同类»`, `OtherLeaves.other_not_held`)."),
 ('ch7', "Denying it does not by itself take the reach away: without P2, the reach holds exactly where the class of one's line holds the effects of everything downstream of one's acts as well as one's own (`«后皆同类当且仅当自与后皆闭»`, `OtherLeaves`)."),
 ('ch7', "Denying P2 is coherent, since one can presuppose the significance of a line that ends while its last stage still conditions something."),
 ('ch7', "The path uses no more ([above](#r-constancy-read-at-a-members-class))."),
 ('ch7', "is alike to oneself, with no regularity (`«后皆续当且仅当后皆同类»`)"),
 ('ch7', "So the reach asks that the class hold the member's effects (`«后皆续则所缘同于»`)."),
 ('ch7', "how the class divides what lies outside oneself enters only through what is alike to one's own effects that leave it (`«外分唯系己出之同»`)"),
 ('p20', "Where one acts, that is, oneself and each occurrence alike to oneself follow each other in what they condition (`«本类常当且仅当与己相随»`, a root theorem)."),
 ('p20', "But the regularity is not needed: a class can meet the path's need without it, and, given P4 and acting, it gives more, the holding of the effects of every occurrence alike to oneself, on one's line or not (`OtherLeaves.reach_without_condition`, `OtherLeaves.other_not_held`, `«本类常闭则所缘同类»`)."),
 ('p20', "if P2 fails, it is reached exactly where the class of one's line still holds the effects of everything downstream of one's acts (`«后皆同类当且仅当自与后皆闭»`, as in `OtherLeaves`), and otherwise rests on the step."),
 ('p20', "6. The path needs less than P2: that the class of one's line hold the effects of oneself and of everything downstream of one's acts (`«后皆同类当且仅当自与后皆闭»`)."),
 ('p20', "If what one presupposes is a regularity of one's own, must it reach beyond one's own line?"),
 ('p20', "is alike to oneself, with no regularity:"),
 ('p20', "Given P4 and acting, P2 gives that and more: the class then holds the effects of every occurrence alike to oneself, off one's line included (`«本类常闭则所缘同类»`); and a class can meet the path's need without P2 (`OtherLeaves.reach_without_condition`)."),
 ('gp', "so that reach asks that the class hold the member's effects (`«后皆续则所缘同于»`)."),
 ('gp', "So only what is alike to the member's own effects that leave the class bears on it (`«外分唯系己出之同»`), and where the class holds those effects, none leaves and the division is idle (`«闭则外分无关»`)."),
 ('gp', "* **Neither premise can be dropped.** Where a member's line runs through a condition but the member's"),
 ('gp', "Holding the member's effects is needed for the reach itself (`«后皆续则所缘同于»`); the regularity is not:"),
 ('gp', "where another occurrence alike to it, off its line, conditions only what leaves the class (`OtherLeaves`)"),
 ('gp', "/-! ## Neither premise can be dropped -/"),
 ('gp', "/-- **What leaves the class follows each alike step (出类随行), at the member's class.**"),
 ('gp', "/-- **What leaves the class follows each alike step (出类随行).**"),
 ('gp', "/-- **The occurrence alike to the member, off its line, does not have its effects held.** -/"),
 ('gp', "The regularity cannot be dropped (`Inconstant`) but is not needed for the reach."),
 ('root', "Witnesses that neither premise can be dropped (`Unclosed`, `Inconstant`),"),
 ('root', "so only what is alike to its own effects that leave the class bears on it"),
 ('root', "and not that it meet the condition at the member's class"),
 ('readme', "so only its own effects that leave the class carry the division of what lies outside"),
 ('readme', "with no regularity, which needs the member's effects held and not the condition at its class"),
 ('scope', "witnesses that neither premise can be dropped, a finite net with two families"),
 ('scope', "with no regularity, which needs the member's effects "),
 ('study', "holds the effects of every stage downstream of its acts"),
]
bad = 0
for f, q in Q:
    ok = q in F[f] or norm(q) in norm(F[f])
    exact = q in F[f]
    if not ok: bad += 1
    print('OK ' if ok else 'MISSING', '(wrapped)' if ok and not exact else '', f, '|', q[:90])
print(len(Q), 'quotes,', bad, 'missing')
