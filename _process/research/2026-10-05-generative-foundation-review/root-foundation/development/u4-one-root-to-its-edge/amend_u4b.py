#!/usr/bin/env python3
"""U4b's amendment, from the checkout root of the landing worktree:

  python3 -B <dir>/amend_u4b.py N   in the record one-root-to-its-edge, row 13 at counting and the bases of rows 7, 8
                                    and 14 rewritten (the four entries from make_record_u4.py, reviewed in
                                    REVIEW-U4B.md), the note, its test and its review among the references,
                                    DESIGN-BOUNDARY's hash for its dated §8, a history line; 08 §7's home paragraph
                                    from the new counts; the study's section N (the next free one)

Each edit asserts that it applies exactly once, or that it is already applied. After it: master_laws.py,
integrate_u4.py check, render, strict check, links, lint, tests. No core run: no Lean changes.
"""
import hashlib
import importlib.util
import json
import re
import sys
import textwrap
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('make_record_u4', HERE / 'make_record_u4.py')
mr = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mr)

DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge/'
REC = ROOT / mr.REC
CHAPTER = ROOT / 'theories/becoming/chapters/08-METHOD.md'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
ROW = 'Becoming.SelectionLevels.rises_exact_iff_levels'
# Row 13 moves; rows 7, 8 and 14 keep amounts with their bases rewritten on the line (REVIEW-U4B.md, finding 1).
ROWS = [ROW] + ['Becoming.' + d for d in ['SelectionTerm.Flow.support_not_lower', 'SelectionTerm.Flow.support_moved_rises',
                                          'GroupEnding.Flow.rises_iff_inactive']]
NOTE, REVIEW = DEV + 'COUNTING-AND-AMOUNTS.md', DEV + 'REVIEW-U4B.md'


def digest(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def amend_record(n):
    r = json.loads(REC.read_text(encoding='utf-8'))
    new = {e['declaration']: e for e in mr.STANDINGS}
    assert new[ROW]['standing'] == 'counting' and all(new[d]['review'] == REVIEW for d in ROWS), 'make_record_u4.py'
    standings = r['boundary']['standings']
    for d in ROWS:
        k = [i for i, e in enumerate(standings) if e['declaration'] == d]
        assert len(k) == 1, d
        if standings[k[0]] != new[d]:
            assert standings[k[0]]['standing'] == ('amounts' if d == ROW else new[d]['standing']), d
            standings[k[0]] = new[d]
    rest = [e['declaration'] for e in standings if e['declaration'] not in ROWS and e != new.get(e['declaration'])]
    assert not rest, ('entries U4b does not change differ from make_record_u4.py', rest)
    refs = r['references']
    for path, role in [(REVIEW, 'review'), (NOTE, 'integration'), (DEV + 'counting_test.py', 'integration')]:
        assert (ROOT / path).is_file(), path
        got = [x for x in refs if x['path'] == path]
        if got:
            got[0]['sha256'] = digest(path)
        else:
            refs.append({'path': path, 'role': role, 'sha256': digest(path), 'declarations': []})
    design = [x for x in refs if x['path'] == DEV + 'DESIGN-BOUNDARY.md']
    assert len(design) == 1 and '## 8. After landing: row 13 at counting (U4b)' in (ROOT / design[0]['path']).read_text(
        encoding='utf-8')
    design[0]['sha256'] = digest(design[0]['path'])  # its dated §8 points to the note; §0–§7 are unchanged
    for x in refs:  # the statement's chapter changes below; its hash is refreshed after the home paragraph
        if x['path'] == 'theories/becoming/chapters/08-METHOD.md':
            x['sha256'] = None
    day = datetime.now(timezone.utc)
    line = {'en': f'{day.day} {day:%B %Y}, board item U4b (study section {n}): SelectionLevels.rises_exact_iff_levels '
                  'moved from amounts to counting. Its statement says nothing of the dynamics and holds for every '
                  'carrier, listing, map and parameter it quantifies over, as SelectionTerm.covariation, '
                  'SelectionLevels.levels_sized and Drift.falls_back do. SelectionTerm.Flow.support_not_lower, '
                  'SelectionTerm.Flow.support_moved_rises and GroupEnding.Flow.rises_iff_inactive stay at amounts, '
                  'using the gate and descent as hypotheses and constraining an arbitrary trait\'s values, with their '
                  'bases rewritten on that line (COUNTING-AND-AMOUNTS.md, reviewed in REVIEW-U4B.md).',
            'zh': f'{day.year}年{day.month}月{day.day}日，工作板条目 U4b（研究第 {n} 节）：'
                  'SelectionLevels.rises_exact_iff_levels 由量移至计数。其陈述不言动力，于其所量化之任一载体、列表、映射与参数皆成立，'
                  '如 SelectionTerm.covariation、SelectionLevels.levels_sized 与 Drift.falls_back。'
                  'SelectionTerm.Flow.support_not_lower、SelectionTerm.Flow.support_moved_rises 与 '
                  'GroupEnding.Flow.rises_iff_inactive 仍在量：以门与传为假设，且约束任一性状之值；其理据依此线重写'
                  '（COUNTING-AND-AMOUNTS.md，经 REVIEW-U4B.md 审阅）。'}
    if not any('U4b' in h.get('en', '') for h in r['history']):
        r['history'].append(line)
    REC.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    return r


def amend_home():
    """Only the three count phrases change, inside the paragraph under the record's anchor, so the amendment also
    applies after another item has edited another sentence of it (DU's C and «续无外» sentence)."""
    new_c = mr.counts()
    assert new_c['counting'] == 7 and new_c['amounts'] == 18 and new_c['unplaced'] == 0, new_c
    text = CHAPTER.read_text(encoding='utf-8')
    start = text.index('<a id="r-one-root-to-its-edge"></a>')
    end = text.index('\n\n', start)
    para = text[start:end]
    pairs = [('Six are counting, below the grammar.', 'Seven are counting, below the grammar.'),
             ('The other 101 stand at a named distance', 'The other 100 stand at a named distance'),
             ('; 19 on amounts;', '; 18 on amounts;')]
    if all(new in para for _, new in pairs):
        print('08 §7: already amended')
        return
    for old, new in pairs:
        assert para.count(old) == 1, old
        para = para.replace(old, new)
    CHAPTER.write_text(text[:start] + para + text[end:], encoding='utf-8')
    print('08 §7: the three counts amended')


def amend_study(n):
    text = STUDY.read_text(encoding='utf-8')
    title = f'## {n}. Counting and amounts: one line (U4b)'
    if title in text:
        print('study §', n, 'already in place')
        return
    free = max(int(x) for x in re.findall(r'^## (\d+)\. ', text, re.M)) + 1
    assert int(n) == free, ('the next free section is', free)
    wrap = lambda s: textwrap.fill(s, width=118, initial_indent='  - ', subsequent_indent='    ')
    section = f"""{title}

Board item U4b, the decision the [deep unification review](development/du-deep-unification-review/REVIEW.md) (§3, evolution) left U4's owner: the design labels a law over lists and maps to `Nat` counting, yet the record placed evolution rows 7, 8, 13 and 14, which compare an arbitrary trait map, at amounts ([the note](development/u4-one-root-to-its-edge/COUNTING-AND-AMOUNTS.md), [its independent review](development/u4-one-root-to-its-edge/REVIEW-U4B.md)).

```text
Result(s): one-root-to-its-edge (row 13's standing; the bases of rows 7, 8 and 14; the counts in its home section, 08 §7).
Delta:
{wrap("The line, by what a statement says of the dynamics: a row is counting when it says nothing of the dynamics beyond the arbitrary predicate of a counting law and holds for every carrier, listing, map and parameter it quantifies over; hypotheses equating or ordering values of those maps are counting too. A row using the dynamics, as a hypothesis (the gate, K3's premises, and descent in the flow), in its conclusion (carried_iff_rising) or through a run's states (the RegimeMargin rows), stands above counting; amounts is its distance when it also compares or constrains numbers the grammar has no terms for, an arbitrary trait's values included.")}
{wrap("counting_test.py walks each counting and amounts row's statement (never a proof) on a core run's constants, against a stated list of the dynamics' carriers (lever 2's model constants among them) and their natural-number fields; a name test by namespace, it supports the readings and gives the same partition on all 25 rows, three rows decided by a reading it names.")}
{wrap("SelectionLevels.rises_exact_iff_levels (row 13) moves from amounts to counting: its hypotheses are listed, equal and exact, and it reaches nothing of the dynamics. Rows 7, 8 and 14 stay at amounts, using the gate and descent as hypotheses, their bases rewritten: they had said trait comparisons constrain amounts, the reason the line rejects as a distance from counting; of their hypotheses on the trait, unlowered, exact and moved are counting, while top and inactive tie the trait to the dynamics. CensusWebs.keep_pace stays counting, the dynamics only as its predicate; the two RegimeMargin rows stay at amounts by reading, a law's run reaching 0 exactly where its start is below H + y.")}
{wrap("Counts: 7 counting and 18 at amounts (were 6 and 19); 10 derived, 1 under a stated hypothesis, 100 at a distance, none unplaced. Of the 18 evolution rows, 1 is under a stated hypothesis, 4 are counting, 1 at a represented model, 5 with balance in their statements and 7 at amounts.")}
Supplied premises / correspondence: none; DYNAMICS and AMOUNT are the theory's vocabulary for the dynamics, stated in
       the script, not measured. The first boundary review's finding B1 (no hypothesis of a root form constrains an
       amount) stands for standing 2; it no longer draws the distance from counting.
Evidence: the test's output on main's core receipt `20261031T152525.956467Z`, in the note; master_laws.py reads the
       amended record, nothing unverified or unplaced (U4's check gates the landing); an independent review and its
       re-check, every finding taken. No Lean changes and no core run.
Standing: a reading made exact, with a computed test where the vocabulary allows one.
Boundary:
  - That counting rows are derived: they stay below the grammar.
  - That the gate rows' amounts are needed, or that DYNAMICS and AMOUNT are complete.
  - The design table (boundary_table.py, boundary-table.json) keeps the design phase's readings; DESIGN-BOUNDARY §8
    points to the note.
Output -> input: DU's owner brings 04's Bases and Open to these standings.
```
"""
    STUDY.write_text(text.rstrip('\n') + '\n\n' + section, encoding='utf-8')
    print('study §', n, 'written')


def refresh_chapter_hash():
    r = json.loads(REC.read_text(encoding='utf-8'))
    for x in r['references']:
        if x['path'] == 'theories/becoming/chapters/08-METHOD.md':
            x['sha256'] = digest(x['path'])
    REC.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    amend_record(sys.argv[1])
    amend_home()
    refresh_chapter_hash()
    amend_study(sys.argv[1])
    print('counts', mr.counts())
