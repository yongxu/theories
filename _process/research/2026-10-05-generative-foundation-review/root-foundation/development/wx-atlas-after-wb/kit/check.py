#!/usr/bin/env python3
"""WX: the claim scan over both atlas files. Narrow forms of each shape WB's readers named, plus quotations of homes
that no longer say them (exact removed phrases). Prints every hit with its entry and field; a hit is either fixed or
listed in the note with its reason (dated history, or a home that still says it).

usage: python3 -B check.py [ROOT]"""
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else '.')
E = ROOT / 'theories/becoming/results/atlas/entries'
PROSE = {'sense', 'quote', 'reading', 'account_adds', 'source_adds', 'says', 'part', 'name', 'mechanism', 'edge',
         'open', 'condition', 'beyond', 'forbids'}
I = re.I
SHAPES = {
    'T8 as way, verdict or resting on readings': r"T8[^.;]*(life's way|the way for life|thesis: for life|verdict binding|binds those|is argued as|under (the )?(two readings|two premises|P[1-4]\b|the (continuation )?condition|C for order)|rests? on (P[1-4]|the two|two))|T8 (offers|is) 生生|生生 as (life's|the) way",
    'compulsory scope': r"(?<!most often )(?<!one pair, )(with|under|and|plus) (the )?(continuation )?condition (for|fixing|fixes) scope|scope from the (continuation )?condition|[Ss]cope comes from the (continuation )?condition|scope,? the (continuation )?condition's|order C's and scope|premise becomes two|(takes|needs?|needing|would need) (the )?(continuation )?condition (for scope|beside)|the condition fixing (scope|only)|condition fixes only whose|asked (only )?under (the )?(continuation condition|two readings|the two)|(scope|scopes?),? the (continuation )?condition[;,]|is under the (continuation )?condition for scope",
    'the ethics only under the readings': r"bears? on (the |its )?ethic\w* only|ethic\w* (rests?|stands?) on (two|the two)|rests its ethics|the ethics' (premises|question|comparison)|in the ethics the condition|the (live )?ethics (stands|is|ranks)",
    'unreturned loss only under the condition': r"(counts?|counted|significance) only under the (continuation )?condition|(needs|requires) the (continuation )?condition for scope|returning to no one[^.]*(needs|only under)|returns? to no one[^.]*counts? only",
    'J1-J4 as what choosing needs': r"(choice|choosing|choices)[^.;]{0,30}(need|needs|take|takes|rest on|rests on)[^.;]{0,20}J1|J1[^.;]{0,30}(needed|required) for (choice|choosing)",
    '生生 tied to widening': r"asks widening|compared by widening|direction of 生生|life in the whole|the whole's 生生|(supports|damages|enriches) 生生|生生[^.;]{0,20}(is|as) the (live )?direction|生生 is generation of|生生 read as widening is",
    'occurrence and counting of a loss': r"(it )?loses nothing\.|whether [^.;]{0,40}is a (loss|harm) is (07|the ethics|no law)|no harm without|is a loss only under|whether a loss counts takes",
    'mixed comparisons unranked as such': r"(?<!by both)(?<!by C)mixed (comparisons|cases|parts)?,? ?(stay|stays|remain) (unranked|undecided|open)|mixed stays unranked|mixed parts need a measure|a measure for mixed parts is open",
    'warrant said open': r"warrants? (stays|stay|is|are|still|left) open|(leaves|holds) open[^.;]{0,30}warrant|warrant question the account leaves open|both warrants open|life's stance",
    'two readings as the account\'s ethics': r"(the account|it) (names|states|has|rests on) two (readings|premises)|two unasserted premises|ranks only under two|under two unasserted|Two premises, neither asserted|the two readings[^.;]{0,40}(the ethics|its ethics)",
    'quotation of a removed home phrase': r"none says a loss is a harm|whether meeting it has significance|without warranting|'should' is what a center does|a reason to pool, not to govern|The direction proposed|direction proposed:|warranted transformation|says whether a (locked loop|code) keeps|premise in C's place|needs the condition beside|which needs no premise; that the wider is better does|can succeed while what it cannot read|支持、丰富或损害生生|一体有伦理内容|warranting whatever universal content|no verdict binding every possible mind is claimed|Open: whether practical reasons|numbers count only if status",
}
RX = {k: re.compile(v, I) for k, v in SHAPES.items()}


def leaves(x, path):
    if isinstance(x, str):
        yield path, x
    elif isinstance(x, dict):
        for k, v in x.items():
            yield from leaves(v, path + [k])
    elif isinstance(x, list):
        for i, v in enumerate(x):
            yield from leaves(v, path + [i])


n = 0
for fn in ('correspondences.json', 'dynamics.json'):
    for e in json.loads((E / fn).read_text(encoding='utf-8')):
        for p, s in leaves(e, []):
            keys = [k for k in p if isinstance(k, str)]
            if not set(keys) & PROSE:
                continue
            for name, rx in RX.items():
                for m in rx.finditer(s):
                    a, b = max(0, m.start() - 120), min(len(s), m.end() + 120)
                    n += 1
                    print(f"[{name}] {e['id']} {'.'.join(map(str, p))}\n    ...{s[a:b]}...")
print('hits', n)
