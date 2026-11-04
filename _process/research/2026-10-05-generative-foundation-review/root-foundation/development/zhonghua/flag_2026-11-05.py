"""A dated flagging in the ZH coverage (board item RAE3, 5 November 2026; ED3's classical reader's E3C-06).

coverage.json is the sweep's triage (25 agents, 20 October 2026): for each judgment a primary cluster c, or "-" where
the sweep read no structure of the spine. Fifteen judgments the sweep left at "-" were placed in the map all the same:
the mappers made thirteen of them the evidence of an entry (seven entries rest on them alone) and two the parallels of
entries. They bear on a structure, as their entries show, so the data did not agree with itself: 3,499 flagged against
3,514 read in the map. Here each is flagged for the one cluster that places it, with the kind of that place, and
w names this script; the sweep's own verdict ("-") is kept in `swept`. Run once; a second run finds nothing to flag and
refuses. verify_zh.py now refuses an unflagged judgment found in the map."""
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from build_tables import places  # noqa: E402

C = HERE / 'coverage.json'
CODE = {'agreement': 'a', 'scope': 's', 'divergence': 'd'}


def main():
    raw = C.read_text(encoding='utf-8')
    cov = json.loads(raw)
    assert json.dumps(cov, ensure_ascii=False, indent=0) == raw, 'coverage.json is not in the form this script writes'
    P = json.loads((HERE / 'passages.json').read_text(encoding='utf-8'))['clusters']
    pl = places(P)
    todo = [r for r, v in cov['verdicts'].items() if v['c'] == '-' and r in pl]
    if not todo:
        raise SystemExit('nothing to flag: already applied')
    for r in todo:
        kept = [(c, k) for c, how, k in pl[r] if how != 'rejected']
        assert len({c for c, _ in kept}) == 1, (r, pl[r])
        c, k = kept[0]
        old = cov['verdicts'][r]
        cov['verdicts'][r] = {'c': c, 's': [], 'k': CODE[k], 'w': 'placed in the map, not flagged by the sweep (RAE3, flag_2026-11-05.py)',
                              'swept': old}
    cov['about'] += (' Fifteen verdicts are not the sweep\'s: judgments it left at "-" that the map places are flagged for '
                     'the cluster that places them, with k the kind of that place, their swept verdict kept under "swept" '
                     '(board item RAE3, flag_2026-11-05.py, 5 November 2026).')
    C.write_text(json.dumps(cov, ensure_ascii=False, indent=0), encoding='utf-8')
    print(len(todo), 'flagged:', ', '.join(todo))
    return 0


if __name__ == '__main__':
    sys.exit(main())
