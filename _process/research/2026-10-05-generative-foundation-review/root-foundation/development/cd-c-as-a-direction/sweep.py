#!/usr/bin/env python3
"""CD's sweep: every comparison word in 07, the fronts and the glossary, sorted by rule where a rule is sure and
otherwise left to be read in its sentence.

usage: python3 -B sweep.py ROOT OUT.tsv
Columns: file, line, word, class, context. Classes:
  textual  a place in the text ("below", "the laws above")
  amount   an amount with its basis (a level above a need, a weight above zero)
  named    an order a theorem or the sentence names (a weighting's order, a valuer's ranking, a lexical order)
  field    a field's own frame (a reward's optimum, a best response, Pareto, POWER)
  read     none of the rules is sure: read in the sentence; DESIGN.md §6 gives the counts and the two that needed action, names-test.json the judged names
"""
import re
import sys

FILES = [
    'theories/becoming/chapters/07-SIGNIFICANCE.md',
    '_process/navigation/README-FIRST-SCREEN.md',
    'theories/becoming/ONE-PAGE.md',
    'theories/becoming/ONE-PAGE.zh.md',
    'theories/becoming/THE-THEORY-OF-BECOMING.md',
    'theories/becoming/THE-THEORY-OF-BECOMING.zh.md',
    'GLOSSARY.md',
    'theories/becoming/ONE-ARGUMENT.md',
    'theories/becoming/COLLECTIVE-DIRECTION.md',
]
EN = re.compile(r'\b(better|worse|best|worst|higher|highest|lower|lowest|rank\w*|optim\w*|superior\w*|inferior\w*|'
                r'winners?|losers?|domina\w*|maximi\w*|minimi\w*|above|below|prefer\w*)\b', re.I)
ZH = re.compile(r'(更好|更差|最好|最优|最佳|排序|排名|排得|排在|排定|定序|更高|更低|高于|低于|优于|劣于|胜者|赢家|输家|优越|最大化|支配|偏好)')
WINDOW = 140

TEXTUAL = re.compile(r'(\[(above|below)\]|\((above|below)\)|(above|below)\]\(|\b(above|below)[:,;)]|\b(above|below)\.\s|'
                     r'\b(above|below)\.$|\b(the|as|see|read|stated|listed|named|shown|given|cases?|laws?|results?|'
                     r'theorems?|sections?|table|rows?|items?|terms?|readings?|premises?|steps?|chain|list|paragraph|'
                     r'parts?) (above|below)\b|\b(above|below) (is|are|was|reads|holds|says|lists|names|gives|shows)\b|'
                     r'\bbelow (in|on|at) \[|\babove (in|on|at) \[)', re.I)
AMOUNT = re.compile(r'(\b(above|below) (zero|\d|its need|the need|a need|need|its own need|the threshold|threshold|'
                    r'the floor|its floor|the bound|a bound|its bound|its stock|the stock|`|n \+|m\b|k\b)|'
                    r'\b(levels?|stocks?|weights?|amounts?|scores?|grades?|needs?|uptake|replenishment|share|count|'
                    r'value|members?|tiers?|scales?) (\w+ ){0,3}(higher|lower|above|below)\b|'
                    r'\b(higher|lower)[- ](level|order|tier|bound|rate|share|amount|grade|weight)s?\b|'
                    r'\b(higher|lower) than (its|the|a) (need|level|stock|bound|threshold)|'
                    r'\b(minimi\w*|maximi\w*) (the |its |a )?(free energy|surprise|loss|cost|error|prediction)|'
                    r'(高于|低于)(零|其需|需要|阈|下限|上限))', re.I)
NAMED = re.compile(r'(`[A-Za-z.]*(rank|Rank|order|Order|Lex|lex|Weight|weight|Grade|grade|Valuer|valuer|'
                   r'Increasing|Pareto|Prior|prior)[A-Za-z_.]*`|\b(weighting|weightings|valuer|valuers|lexical|'
                   r'lexicographic|positive weighting|every order|some order|an order|the order|such order|'
                   r'score|grades?|standpoint|self-concerned|increasing in)\b)', re.I)
FIELD = re.compile(r'(\breward|\bRLHF|\bPOWER\b|\bPareto|Pigou|Dalton|priorit\w+ to the worse|best response|'
                   r'\bNash|\boptimi[sz]er|\bfree energy|\bFEP\b|\bgradient|\btraining|\btrained|\bloss function|'
                   r'\bpolicy|\bpolicies|\butilit|\bevolution\w* (game|stable)|\bfitness|\bmarket|\bprice|'
                   r'奖励|训练|最优化器|帕累托|效用)', re.I)


def classify(word, ctx):
    low = word.lower()
    if low in ('above', 'below') or word in ('高于', '低于'):
        if TEXTUAL.search(ctx):
            return 'textual'
        if AMOUNT.search(ctx):
            return 'amount'
    if low in ('higher', 'lower', 'highest', 'lowest') or word in ('更高', '更低'):
        if AMOUNT.search(ctx):
            return 'amount'
    if FIELD.search(ctx) and (low.startswith('optim') or word in ('最优', '最佳') or low in ('best', 'preference',
                                                                                          'preferences', 'preferring',
                                                                                          'prefers', 'prefer')):
        return 'field'
    if low.startswith('rank') or low in ('above', 'below', 'higher', 'lower') or word in ('排序', '排名', '排得', '排在', '排定', '定序'):
        if NAMED.search(ctx):
            return 'named'
    if low.startswith(('minimi', 'maximi')) and AMOUNT.search(ctx):
        return 'amount'
    return 'read'


def main():
    root, out = sys.argv[1], sys.argv[2]
    rows = []
    for f in FILES:
        for n, line in enumerate(open(f'{root}/{f}', encoding='utf-8').read().split('\n'), 1):
            for rx in (EN, ZH):
                for m in rx.finditer(line):
                    a, b = max(0, m.start() - WINDOW), min(len(line), m.end() + WINDOW)
                    ctx = line[a:b].replace('\t', ' ')
                    rows.append((f, n, m.group(0), classify(m.group(0), ctx), ctx))
    with open(out, 'w', encoding='utf-8') as o:
        o.write('file\tline\tword\tclass\tcontext\n')
        for r in rows:
            o.write('\t'.join(map(str, r)) + '\n')
    counts = {}
    for r in rows:
        counts[r[3]] = counts.get(r[3], 0) + 1
    print(len(rows), 'hits;', ', '.join(f'{k} {v}' for k, v in sorted(counts.items())))


if __name__ == '__main__':
    main()
