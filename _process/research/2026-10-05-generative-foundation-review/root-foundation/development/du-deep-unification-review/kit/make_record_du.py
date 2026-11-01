#!/usr/bin/env python3
"""DU's three records, from its two core leaves (U1b's make_record_u1b.py, the same pattern, for three records):

  premises-met-and-failed                      Becoming.PremiseWitnesses, home 08 §7 after one-root-to-its-edge
  self-concern-and-c-under-the-condition       Becoming.PremiseWitnesses, home 07 §4 (scope and order), before 4.1
  standings-not-read-off-the-occurrence-model  Becoming.UnreadStandings, home 01 §8.6 after amounts-by-unit-matchings

From the checkout root:
  python3 -B <dir>/make_record_du.py --draft OUTDIR      the three records without receipt or binding (status open)
  python3 -B <dir>/make_record_du.py --validate          the drafts checked by the registry's own validation, in memory,
                                                         beside every record of the checkout (nothing is written)
  python3 -B <dir>/make_record_du.py RECEIPT STUDY       the three records, bound to the core run's receipt; STUDY is
                                                         the study section of the landing (integrate_du.py record
                                                         calls this after the home sections are in place)

The prose fields are records-text.json's, verbatim; this script adds the fixed fields, the zh of the drafted
dependency and related details, the references (each record's own declarations of its leaf, in source order) and the
history note. It asserts that the kit's leaves and the package's are the same bytes, that every declaration of each
leaf stands in exactly one law of DU's records, each schema-2 length limit the lint treats as an error, and, given a
receipt, that it passed, binds both leaves' bytes, elaborated every declaration and reports every axiom list empty.
"""
import hashlib
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/du-deep-unification-review/'
KIT = DEV + 'kit/'
MODULES = {'Becoming.PremiseWitnesses': PKG + 'Becoming/PremiseWitnesses.lean',
           'Becoming.UnreadStandings': PKG + 'Becoming/UnreadStandings.lean'}
COUNTS = {'Becoming.PremiseWitnesses': (37, 35), 'Becoming.UnreadStandings': (40, 32)}  # declarations, theorems
CHAPTERS = {'method': 'theories/becoming/chapters/08-METHOD.md',
            'significance': 'theories/becoming/chapters/07-SIGNIFICANCE.md',
            'root': 'theories/becoming/chapters/01-ROOT.md'}
TEXT = json.loads((HERE / 'records-text.json').read_text(encoding='utf-8'))
RECORDS = {t['id']: t for t in TEXT['records']}
RIDS = list(RECORDS)
assert RIDS == ['premises-met-and-failed', 'self-concern-and-c-under-the-condition',
                'standings-not-read-off-the-occurrence-model'], RIDS


def rec_path(rid):
    return f'theories/becoming/results/records/{rid}.json'


def digest(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def declarations(text):
    """Full names of a module's declarations in source order, and its theorems' (namespaces read, sections and
    comments skipped)."""
    text = re.sub(r'/-.*?-/', '', text, flags=re.S)
    stack, out, theorems = [], [], []
    for line in text.split('\n'):
        m = re.match(r'(namespace|section)\b\s*(\S*)', line)
        if m:
            stack.append((m.group(1), m.group(2)))
            continue
        m = re.match(r'end\b\s*(\S*)', line)
        if m:
            kind, name = stack.pop()
            assert name == m.group(1), ('unbalanced end', name, m.group(1))
            continue
        m = re.match(r'(theorem|def|structure|inductive|abbrev)\s+(\S+)', line)
        if m:
            out.append('.'.join([n for k, n in stack if k == 'namespace'] + [m.group(2)]))
            if m.group(1) == 'theorem':
                theorems.append(out[-1])
    assert not stack, stack
    return out, theorems


LEAF, THEOREMS, THEOREM_NAMES = {}, {}, {}
for module, source in MODULES.items():
    kit_copy = HERE / 'Becoming' / Path(source).name
    assert (ROOT / source).read_bytes() == kit_copy.read_bytes(), ('the kit and package leaf differ', module)
    LEAF[module], theorem_names = declarations((ROOT / source).read_text(encoding='utf-8'))
    THEOREM_NAMES[module], THEOREMS[module] = set(theorem_names), len(theorem_names)
    assert (len(LEAF[module]), THEOREMS[module]) == COUNTS[module], (module, len(LEAF[module]), THEOREMS[module])
    assert len(set(LEAF[module])) == len(LEAF[module]), module

# Every declaration of each leaf stands in exactly one law of DU's records, and a record's laws name only its leaf's.
placed = {}
for rid, t in RECORDS.items():
    for i, law in enumerate(t['laws'], 1):
        for d in law['declarations']:
            assert d in LEAF[t['module']], ('a law names a declaration its leaf does not have', rid, i, d)
            assert d not in placed, ('a declaration in two laws', d, placed[d], (rid, i))
            placed[d] = (rid, i)
for module, names in LEAF.items():
    missing = [d for d in names if d not in placed]
    assert not missing, ('declarations of the leaf in no law', module, missing)


def own(rid):
    """The record's declarations, in the leaf's source order."""
    mine = {d for law in RECORDS[rid]['laws'] for d in law['declarations']}
    return [d for d in LEAF[RECORDS[rid]['module']] if d in mine]


# The drafted fields' zh (AI-written, 1 November 2026), in the register of records-text.json's own zh.
DEPENDENCY_ZH = {
    ('premises-met-and-failed', 'the-continuation-condition-on-the-root'):
        '«续无外»、«族无外»、«续无外则族无外» 与 LineOfDescent 之模型，及首对用为成之见证之 LineOfDescent.Endless.descent_no_outside。',
    ('premises-met-and-failed', 'the-source-texts-test-systems'):
        'TwoLines 与 ThirdThing，及予不成之见证之 TwoLines.other_line_outside 与 ThirdThing.fixed_class。',
    ('premises-met-and-failed', 'becoming-spine-instances'):
        'LiftModel 之框与 LiftModel.lift_needs_live_middle，其末部即此处 L 之不成。',
    ('premises-met-and-failed', 'a-narrowing-above-its-widening'):
        'Weighting.WidensBy 与 Weighting.widensOn_of_widensBy：唯以一项之扩大为扩大。',
    ('self-concern-and-c-under-the-condition', 'what-self-concern-alone-ranks'):
        'Weighting.IncreasingInOwn、Weighting.AddsOwn 与 Weighting.increasingInOwn_iff_increasing，此记录证其逆。',
    ('self-concern-and-c-under-the-condition', 'the-continuation-condition-on-the-root'):
        '«续无外»、withinClosure_iff_reached、ownClosure_unrestricted_iff_noOutside 与 ownClosure_unrestricted_iff，及传承线之模型。',
    ('self-concern-and-c-under-the-condition', 'comparison-by-widening'):
        'Web.paths_extension_iff_widens：网之层径上之扩展即所接纳者之扩大。',
    ('self-concern-and-c-under-the-condition', 'eventual-widening'):
        'Web.ListsAdmitted、Web.DecidesAdmission、Web.stepBound 与 Web.lt_stepBound，及 Web.widens_iff_every_weighting。',
    ('standings-not-read-off-the-occurrence-model', 'the-world-represented-both-ways'):
        '出现模型（World.conservationStep、Web.partialIdentity、World.withinStep）、F1 之世界（World.standingAt、Witnesses.unrequired、Flow.still）与 Becoming.GrammarTransport 之保持定理（«对应之像»、«同族之对应»、«生之对应»、«亡之对应»）。',
}
RELATED_ZH = {
    ('premises-met-and-failed', 'one-root-to-its-edge'):
        '一根之边另列伦理之二前提，条件定范围、C 定序；此记录予条件之根形与 C 以见证。',
    ('premises-met-and-failed', 'what-the-dynamics-leave-open'):
        '不被蕴含之模式：ReadsOnlyDynamics.not_entails 就条件，此处以次序代意义。',
    ('self-concern-and-c-under-the-condition', 'premises-met-and-failed'):
        '根上之条件于其上成与不成之诸网，第四律就自关切读之。',
    ('self-concern-and-c-under-the-condition', 'widening-as-what-every-weighting-ranks'):
        '扩大即每一正权重所排高者；经之，于接纳上递增之次序把所列径间之每一扩展皆排定。',
    ('standings-not-read-off-the-occurrence-model', 'amounts-by-unit-matchings'):
        '以所选单位配对之平衡：数量所代推出者；此记录陈出现模型于其中所留之自由。',
}
ALIASES = {
    'premises-met-and-failed': [
        'the condition on the root varies with the net', '根上之条件随网而变', 'C entailed by no statement reading no order where it holds',
        'Becoming.«续无外随网»', 'Becoming.«族无外随网»', 'Becoming.«逆缘续无外随网»', 'Becoming.ReadsNoOrder.not_entails',
        'Becoming.LiftModel.met_and_failed', 'Becoming.Weighting.widensOn_iff_reach'],
    'self-concern-and-c-under-the-condition': [
        'self-concern gives what C asks between listed level paths, one way', '自关切于所列层径间单向给出 C 之所求',
        'Becoming.Weighting.increasingInOwn_iff_increasing_iff_noOutside',
        'Becoming.Weighting.increasingInOwn_iff_increasing_iff_unrestricted',
        'Becoming.Web.extension_ranked_of_increasingInOwn', 'Becoming.increasingInOwn_with_net'],
    'standings-not-read-off-the-occurrence-model': [
        'the unit is not read off the occurrence model', '单位不由出现模型读出', 'a world at a finer unit',
        'Becoming.World.atFinerUnit_agree', 'Becoming.World.standing_not_read',
        'Becoming.World.standing_not_read_up_to_unit', 'Becoming.World.stillAt_relabel_agree'],
}
for rid, names in ALIASES.items():
    assert all(a in own(rid) for a in names if a.startswith('Becoming.')), rid
REVIEWS = {
    'premises-met-and-failed': [(DEV + 'REVIEW-LEAF.md', 'review'), (DEV + 'REVIEW-LEAF-2.md', 'review'),
                                (DEV + 'REVIEW.md', 'integration'), (DEV + 'texts/TEXTS.md', 'integration')],
    'self-concern-and-c-under-the-condition': [(DEV + 'REVIEW-LEAF.md', 'review'), (DEV + 'REVIEW-LEAF-2.md', 'review'),
                                               (DEV + 'REVIEW.md', 'integration')],
    'standings-not-read-off-the-occurrence-model': [(DEV + 'scratch/units/REVIEW.md', 'review'), (DEV + 'REVIEW.md', 'integration')],
}
HISTORY = {
    'premises-met-and-failed': (
        'added. The premise card\'s pairs for the condition\'s root form, C and L, and the law of widening by one item, '
        'from the deeper unification review\'s leaf, Becoming.PremiseWitnesses; two independent AI reviews of the leaf '
        'and a third look, every finding taken.',
        '增。前提卡就条件之根形、C 与 L 之成对见证，及以一项扩大之律，出自更深统一审阅之叶 Becoming.PremiseWitnesses；'
        '此叶经二独立之 AI 审阅与第三次复读，所见皆取。'),
    'self-concern-and-c-under-the-condition': (
        'added. Self-concern joined to the condition on the root and held de se, and one way to C between listed level '
        'paths, from Becoming.PremiseWitnesses; the vacuous form on every level path replaced at the third look by the '
        'pairwise one, its vacuity proved; every finding of the leaf\'s reviews taken.',
        '增。自关切与根上之条件及自承之条件相接，并单向接于所列层径间之 C，出自 Becoming.PremiseWitnesses；'
        '于全部层径上之空真形于第三次复读时代以成对之形，其空真已证；此叶审阅所见皆取。'),
    'standings-not-read-off-the-occurrence-model': (
        'added. What the occurrence model leaves free in the standings, the unit in every world and more in still '
        'worlds, from the review\'s units scratch, ported as Becoming.UnreadStandings, its helper lemmas\' namespace '
        'renamed to the module\'s at the kit review and every other declaration unchanged; an independent AI review, '
        'every finding taken.',
        '增。出现模型于立度所留之自由：每一世界之单位，静止世界中更多；出自审阅之单位草稿，移为 '
        'Becoming.UnreadStandings，其辅助引理之命名空间于套件审阅时改为模块之名，余声明不变；经一独立之 AI 审阅，所见皆取。'),
}

# Schema-2 limits (RESULT-WORKFLOW, "Writing a record"), per language: (en, zh, items or None, an error or a warning).
LIMITS = {'title': (100, 40, None, True), 'statement': (300, 150, None, True), 'laws': (420, 190, None, False),
          'hypotheses': (420, 190, 9, False), 'does_not_show': (240, 110, 8, False),
          'validation_scope': (600, 260, None, True), 'next_delta': (400, 180, None, True),
          'correspondence': (1200, 500, None, False)}


def limits(r):
    """Assert the caps the lint treats as errors; list the others' excess (the lint warns)."""
    for key, (en, zh, items, error) in LIMITS.items():
        value = r[key]
        entries = value if isinstance(value, list) else [value]
        assert items is None or len(entries) <= items, (r['id'], key, len(entries))
        for i, e in enumerate(entries, 1):
            n_en, n_zh = len(e.get('en', '')), len(e.get('zh', ''))
            if n_en > en or n_zh > zh:
                assert not error, (r['id'], key, n_en, n_zh)
                print(f'over a warning cap (records-text.json\'s prose): {r["id"]} {key} {i}: {n_en}/{en} en, '
                      f'{n_zh}/{zh} zh', file=sys.stderr)


def receipt_module(receipt, module):
    data = json.loads((ROOT / receipt).read_text(encoding='utf-8'))
    assert data['status'] == 'passed', receipt
    assert data['source_sha256'][module] == digest(MODULES[module]), ('the receipt does not bind the leaf', module)
    m = {x['module']: x for x in data['modules']}[module]
    names = [d['name'] for d in m['declarations']]
    assert set(LEAF[module]) <= set(names), sorted(set(LEAF[module]) - set(names))
    assert not any(m['axiom_dependencies'].values()), [n for n, a in m['axiom_dependencies'].items() if a]
    assert m['theorems'] == THEOREMS[module] and len(names) == len(LEAF[module]), (module, m['theorems'], len(names))
    assert m['layer'] == 'core', (module, m['layer'])
    return m


def record(rid, receipt=None, study=None, reviewed=None):
    t = RECORDS[rid]
    module, source, chapter = t['module'], MODULES[t['module']], CHAPTERS[t['region']]
    mine = own(rid)
    refs = [{'path': source, 'role': 'proof', 'declarations': mine, 'sha256': digest(source)}]
    if receipt:
        receipt_module(receipt, module)
        assert f'<a id="r-{rid}"></a>' in (ROOT / chapter).read_text(encoding='utf-8'), \
            ('the home section is not in place: integrate_du.py record inserts it before writing the record', rid)
        refs.append({'path': receipt, 'role': 'receipt', 'sha256': digest(receipt), 'declarations': []})
    for path, role in REVIEWS[rid] + [(chapter, 'statement')]:
        assert (ROOT / path).is_file(), path
        refs.append({'path': path, 'role': role, 'sha256': digest(path), 'declarations': []})
    now = reviewed or datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    day = datetime.fromisoformat(now)
    vs = t['validation_scope_draft']
    n_thm = sum(1 for d in mine if d in THEOREM_NAMES[module])
    en_h, zh_h = HISTORY[rid]
    r = {
        'schema_version': 2,
        'id': rid,
        'title': t['title'],
        'kind': 'theorem',
        'status': 'recorded-checked' if receipt else 'open',
        'family': t['family'],
        'reviewed_at_utc': now,
        'statement': t['statement'],
        'laws': t['laws'],
        'hypotheses': t['hypotheses'],
        'does_not_show': t['does_not_show'],
        'counterexamples': [],
        'standard_boundaries': STANDARD[rid],
        'validation_scope': {
            'en': vs['en'] + f' The record\'s {len(mine)} declarations ({n_thm} theorems) compile with the whole '
                             'package in the core run whose receipt the record binds.',
            'zh': vs['zh'] + f'此记录 {len(mine)} 声明（定理 {n_thm}）与全包同编译于记录所系收据之核心运行。'},
        'next_delta': t['next_delta'],
        'correspondence': t['correspondence'],
        'canonical_source': source,
        'aliases': ALIASES[rid],
        'dependencies': [{'id': d['id'], 'relation': d['relation'],
                          'detail': {'en': d['detail_en'], 'zh': DEPENDENCY_ZH[(rid, d['id'])]}}
                         for d in t['dependencies_draft']],
        'related': [{'id': d['id'], 'detail': {'en': d['detail_en'], 'zh': RELATED_ZH[(rid, d['id'])]}}
                    for d in t['related_draft']],
        'references': refs,
        'proof_bindings': ([{'source': source, 'receipt': receipt, 'sha256_pointer': f'/source_sha256/{module}',
                             'success_pointer': '/status', 'success_value': 'passed'}] if receipt else []),
        'history': [{
            'en': f'{day.day} {day:%B %Y}, board item DU (study section {study or "…"}): ' + en_h,
            'zh': f'{day.year}年{day.month}月{day.day}日，工作板条目 DU（研究第 {study or "…"} 节）：' + zh_h}],
    }
    limits(r)
    unused = {'module', 'home', 'region', 'base', 'validation_scope_draft', 'dependencies_draft',
              'related_draft'}
    assert set(t) - set(r) == unused, set(t) - set(r) - unused
    return r


# Shared boundaries (standard-boundaries.json), cited only where the sentence is true of the record.
STANDARD = {
    # no ethical premise (C and L are what is witnessed, not premises), no axiom; equality of items decided
    'premises-met-and-failed': ['no-ethical-premise', 'decidability', 'formal-not-empirical', 'names-provisional',
                                'omission-not-refutation'],
    # the condition and self-concern are hypotheses: significance related, not asserted
    'self-concern-and-c-under-the-condition': ['significance-related-not-asserted', 'decidability',
                                               'conditional-not-universal', 'formal-not-empirical', 'names-provisional'],
    'standings-not-read-off-the-occurrence-model': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                                        'names-provisional', 'omission-not-refutation'],
}


def validate(records):
    """The registry's validation of every record of the checkout with these in place, in memory."""
    sys.path.insert(0, str(ROOT))
    from tools.research import registry
    loaded, errors = registry.load_records()
    assert not errors, errors[:3]
    ids = {r['id'] for r in records}
    rest = [x for x in loaded if x.get('id') not in ids] + [dict(r, _record_path=rec_path(r['id'])) for r in records]
    findings, drift = registry.validate(rest)
    mine = [f for f in findings if any(f.startswith(i + ':') or i in f for i in ids)]
    others = [f for f in findings if f not in mine]
    for f in mine:
        print('FINDING', f)
    from tools.research import style
    for r in records:
        for f in style.lint(r):
            print('lint', r['id'], f['severity'], f['field'], f['rule'], str(f['detail'])[:160])
    print(f'{len(mine)} findings on DU\'s records; {len(others)} elsewhere in the checkout; drift entries {len(drift)}')
    return not mine


if __name__ == '__main__':
    if sys.argv[1] == '--draft':
        out = Path(sys.argv[2])
        out.mkdir(parents=True, exist_ok=True)
        for rid in RIDS:
            (out / f'{rid}.json').write_text(json.dumps(record(rid), ensure_ascii=False, indent=2) + '\n',
                                             encoding='utf-8')
        print('drafts written to', out)
    elif sys.argv[1] == '--validate':
        sys.exit(0 if validate([record(rid) for rid in RIDS]) else 1)
    else:
        receipt, study = sys.argv[1], sys.argv[2]
        stamp = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
        for rid in RIDS:
            (ROOT / rec_path(rid)).write_text(json.dumps(record(rid, receipt, study, stamp), ensure_ascii=False,
                                                         indent=2) + '\n', encoding='utf-8')
            print('written', rec_path(rid))
