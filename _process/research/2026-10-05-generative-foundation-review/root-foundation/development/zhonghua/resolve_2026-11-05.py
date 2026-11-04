"""A dated resolution in the ZH passage map (board item RAE3, 5 November 2026; AA Phase 0's E4).

TP-H22-X4-R01 (贲六四「當位疑也」), flagged for C07, was rejected there and kept in C17 as a parallel of the entry
xiaoxiang-weidang. C17's structure checker found the line in Lean's Hexagram.placeStatements (as (22, .p4, true)) and
asked for it as a parallel of that entry (agents/verify-structure-C17.json); C17's reviser made it one and asked that
the integrator move it out of C07's rejections, so that one candidate is not in two places with opposite verdicts
(agents/revise-C17.json); that was not done. Here it is: C07's rejection becomes a parallel of the same C17 entry,
xiaoxiang-weidang, the census of the 小象's statements of place that carries the line, rather than C07's own scope
entry lin-tuan-gang-zhong-er-ying, which the rejection named for the relation of places but which reads the 彖 of 臨,
not this line. The rejection's words are kept in the note. Run once; a second run finds nothing to change and refuses."""
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
P = HERE / 'passages.json'
R = 'TP-H22-X4-R01'


def main():
    raw = P.read_text(encoding='utf-8')
    data = json.loads(raw)
    assert json.dumps(data, ensure_ascii=False, indent=1) == raw, 'passages.json is not in the form this script writes'
    c07 = data['clusters']['C07']
    old = [x for x in c07['rejected'] if x['record_id'] == R]
    if not old:
        raise SystemExit('nothing to resolve: already applied')
    assert len(old) == 1 and any(e['id'] == 'xiaoxiang-weidang' for e in data['clusters']['C17']['entries'])
    c07['rejected'] = [x for x in c07['rejected'] if x['record_id'] != R]
    c07['parallels'].append({
        'record_id': R, 'same_as_entry': 'C17:xiaoxiang-weidang',
        'note': ('RAE3 (5 November 2026, AA E4): moved here from C07\'s rejections, as C17\'s reviser asked: the line is '
                 'in Lean\'s Hexagram.placeStatements as (22, .p4, true), carried by placeStatements_agree, so it is a '
                 'parallel of C17\'s census entry xiaoxiang-weidang, not of a C07 entry. The rejection, which read the line '
                 'as having no structure to check, said: ' + old[0]['why'])})
    P.write_text(json.dumps(data, ensure_ascii=False, indent=1), encoding='utf-8')
    print('resolved', R)
    return 0


if __name__ == '__main__':
    sys.exit(main())
