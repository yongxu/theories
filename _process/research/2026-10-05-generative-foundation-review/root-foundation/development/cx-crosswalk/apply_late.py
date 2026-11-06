#!/usr/bin/env python3
"""The last layer of the crosswalk's reads: the second critic's fixes, then the live text's own corrections.

usage: python3 -B apply_late.py [--dry-run]

Reads reads/<item>.5-compare.json, applies every `fix` in reads/critic2-share-*.json (the second critic read both sides of
each), then replaces in entries what the live account no longer says since this crosswalk's corrections (LIVE_NOW and
LIVE_LATER below), what AA's errata renamed (LIVE_AA) and what main changed since (main_drift, from
reads/main-drift-*.json as their checks amend them), and writes reads/<item>.6-final.json, each with a `changes` list
naming why. Stops on a fix to an unknown entry or field,
on a replacement that matches nothing, and writes nothing then. Validation is check_entries.py's.
"""
import argparse
import glob
import json
import re
import sys
from pathlib import Path

READS = Path(__file__).resolve().parent / 'reads'
SETTABLE = {'carried', 'relation', 'agreement_of', 'same_as', 'reading', 'source_adds', 'account_adds', 'absence', 'targets'}
CD5 = ('One kind of institution has one minimal model on the root [AI reading], a rule rebuilt from the members it limits '
       '(05 §12), and no actual institution is shown to meet its hypotheses')
# COLLECTIVE-DIRECTION §5 said "No institution is modelled on the spine" until this crosswalk's correction; entries that
# quoted it now quote what it says. Each pair: an exact string in the entry's JSON text, and what replaces it.
LIVE_NOW = {
    'cx-asc-selection-on-cognition': [("'no institution is modelled on the spine'", 'no actual institution is shown to meet the hypotheses of the one minimal model of an institution on the root')],
    'cx-asc-training-ground': [("'No institution is modelled on the spine; no field test", f"'{CD5}; no field test")],
    'cx-asc-four-layer-loop': [("'No institution is modelled on the spine; no field test", f"'{CD5}; no field test")],
    'cx-fork-two-fates': [('No institution is modelled on the spine; no field test', f'{CD5}; no field test')],
    'cx-zhishan-present-diagnosis': [('no institution is modelled on the spine,', 'no actual institution is shown to meet the hypotheses of the one minimal model of an institution,'),
                                     ('No institution is modelled on the spine; no field test', f'{CD5}; no field test')],
}
# The other corrections this crosswalk made at home (apply_corrections.py), found quoted in their old wording by a search of
# every entry for each correction's removed words; each entry now quotes what its home says, or says what it said until when.
WHY_LATER = 'a correction this crosswalk made at the home: the entry quotes what the home says now, or says what it said until 7 November 2026'
A08 = ("Goodhart's and Campbell's laws (Goodhart 1975; Campbell 1979; Manheim and Garrabrant 2018) describe informally a measure that "
       "stops measuring once it is used as a target or for decisions; that the measure is then kept is the record's addition, and T7 "
       "states that it outlives its refutation as a conjecture about a lock.")
A08_OLD = ("Goodhart's and Campbell's laws (Manheim and Garrabrant 2018; Campbell 1979) describe informally a measure that keeps its "
           "standing after it stops measuring. T7 states that as a conjecture about a lock.")
POWER = ("the corpus's meta-attractor in its account of power is the closed loop:",
         "the closed loop is one part of the corpus's meta-attractor in its account of power, which also speaks of carriers, domains and correction:")
GLOSS = ('that sense is wider, and the formal', 'that sense is another, neither shown to contain the other: the formal')
WORKING = ("the corpus's working definition is wider.", "the corpus's working definition is another, not shown to contain closed capture or to be contained by it.")
IMP = 'the reading counts the imperial examination as this case, its fit to these premises read, not tested'
MQ1 = "across domains conjectured (T3); in simulation the draw against margin forecast an exact best response's side effects (8 of 8) and failed for tabular learners (80 of 151; MQ1)"
LIVE_LATER = {
    'cx-econ-campbell-corruption': [(A08_OLD, A08)],
    'cx-pal-goodhart-taxonomy': [(A08_OLD, A08),
        ("A-08's gloss, a measure keeping its standing after it stops measuring, is T7's claim: as I recall them the sources state collapse and corruption, not persistence.",
         "A-08 glossed them, until 7 November 2026, as a measure keeping its standing after it stops measuring, which is T7's claim: as I recall them the sources state collapse and corruption, not persistence, and A-08 now says so."),
        ("across domains conjectured (T3), supported in simulation (MQ1; dossier A: for exact best responses, and failed for tabular learners, 80 of 151);", MQ1 + ';')],
    'cx-ma-rule-loop': [POWER],
    'cx-sspiral-winner-justifies-all': [POWER,
        ("'the metric survives its own refutation' is lock_outlives_loss.",
         "'the metric survives its own refutation' is read as lock_outlives_loss, the refutation as a loss the loop does not read.")],
    'cx-ma-metric-survives-refutation': [
        ('refutation\\" is `lock_outlives_loss`.', 'refutation" is read as `lock_outlives_loss`, the refutation as a loss the loop does not read (evidence and refutation are unformalized).'),
        ("02 reads the source's phrase directly as `lock_outlives_loss`, a reading.",
         "02 reads the source's phrase as `lock_outlives_loss`, the refutation as a loss the loop does not read, a reading.")],
    'cx-drives-attractor-geometry': [GLOSS],
    'cx-zhishan-totalizing-attractor': [('that sense is wider, and the formal term', 'that sense is another, neither shown to contain the other: the formal term'), WORKING],
    'cx-oi-karma-across-carriers': [GLOSS],
    'cx-modphil-marx-capital-self-valorizing': [GLOSS],
    'cx-ma-wide-regime-across-carriers': [WORKING],
    'cx-ma-the-word': [('that sense is wider, the formal', 'that sense is another, neither shown to contain the other: the formal')],
    'cx-sspiral-attractor-no-subject': [('that sense is wider, the formal', 'that sense is another, neither shown to contain the other: the formal')],
    'cx-modphil-marx-reproduces-the-relation': [("is not the formal term: 'that sense is wider'.", "is not the formal term: 'that sense is another, neither shown to contain the other'.")],
    'cx-asc-token-same-shape': [('The imperial examination is read as this case.', 'The reading counts the imperial examination as this case, its fit to these premises read, not tested.')],
    'cx-drives-virtue-does-not-self-install': [('the imperial examination is this case, as read in the meta-attractor line.', IMP + '.')],
    'cx-drives-confucian-engineering': [('the imperial examination is this case, as read in the meta-attractor line: designed to dilute hereditary capture, it later became a proxy trap.',
        'the reading counts the imperial examination as this case; the meta-attractor line says that, designed to dilute hereditary capture, it later became a proxy trap, and its fit to these premises is read, not tested.')],
    'cx-ma-anti-attractor': [('The imperial examination is this case, as read in the meta-attractor line', 'The reading counts the imperial examination as this case, a counter-rule whose rule came to be read from the share it selected')],
    'cx-wamo-we-are-not-them': [('as the imperial examination is read: designed to dilute hereditary capture, it later became a proxy trap of its own.',
        'as the reading counts the imperial examination: designed to dilute hereditary capture, it later became a proxy trap of its own, the meta-attractor line says, and its fit to these premises is read, not tested.')],
    'cx-zhishan-criticism-absorbed': [('the imperial examination is this case, as read in the meta-attractor line.', IMP + '.')],
    'cx-cc-huang-xuexiao': [('The imperial examination is this case, as read in the meta-attractor line: designed to dilute hereditary capture, it later became a proxy trap of its own.',
        'The reading counts the imperial examination as this case; the meta-attractor line says that, designed to dilute hereditary capture, it later became a proxy trap of its own, and its fit to these premises is read, not tested.')],
    'cx-memories-verification-instrumental': [('across domains conjectured (T3), supported in simulation.', MQ1 + '.')],
    'cx-ma-vs-goodhart-and-lock-in': [('across domains conjectured (T3), supported in simulation (MQ1);', MQ1 + ';')],
    'cx-econ-goodhart-regularity': [
        ('across domains conjectured (T3), supported in simulation (MQ1)', MQ1),
        ("08's 'supported in simulation (MQ1)' omits the failure, so I add it here.",
         "08 said 'supported in simulation (MQ1)', omitting the failure, until 7 November 2026; it now states both."),
        ("'Goodhart (1975) says a measure made a target stops measuring; this states",
         "'Goodhart (1975) says a statistical regularity tends to collapse once pressure is put on it for control, which Strathern (1997) put as a measure made a target ceasing to be a good measure; this states")],
    'cx-pal-lawvere-diagonal': [('Theorem (labelled any type, on finitely many sentences closed among themselves; L-27 notes no type parameter occurs).',
        "Theorem (Kleene's three-valued sentences, a named model, finitely many closed among themselves; labelled any type until 7 November 2026, as L-27 noted).")],
    'cx-dpc-phase-transition': [('the two earlier phase results and this absorbing end are its three forms under this reading.',
        'the two earlier boundary results and this absorbing end are its three forms under this reading, boundaries and none a proved phase transition.')],
    'cx-dpc-entropy-arrow': [("'the low-entropy beginning physics supplies is the beginning of the kept history, and is derived'.",
        "'the low-entropy beginning physics supplies reads as the beginning of the kept history', while a coarse-grained entropy rising from an ordered start needs a premise about the start and is not stated.")],
    'cx-ecoevo-recovery-beyond-removing-the-pressure': [('Correspondence: hysteresis of collapse.',
        "Correspondence: a collapse that support's return does not undo, one-sided only: hysteresis's distinct collapse and recovery thresholds are not stated.")],
    'cx-ecoevo-metapopulations': [("The record's gloss, patches 'persist or go extinct together', fits this law and not Levins, whose patches end apart.",
        "The record's gloss read patches as persisting or going extinct together, which fits this law and not Levins, whose patches end apart; since 7 November 2026 the record says they go extinct apart and are recolonized.")],
    'cx-modphil-jonas-imperative': [("'Jonas (1979): the existence of the whole is never to be staked;", "'Jonas (1979): the existence of humanity as a whole is never to be staked;"),
        ("The record's 'the existence of the whole' is wider than his human object.",
         "The record said 'the existence of the whole', wider than his human object, until 7 November 2026; it now says humanity as a whole.")],
    'cx-pal-constructive-calibrations': [("08's gloss of the double-negation row, 'reach without a path', misdescribes the law: its conclusion is reach, which carries a path; what needs the principle is the step from the absence of an invariant separation to such a path.",
        "08's gloss of the double-negation row read 'reach without a path' until 7 November 2026, which misdescribed the law: its conclusion is reach, which carries a path; what needs the principle is the step from the absence of an invariant separation to such a path. 08 now says so.")],
}
# AA's errata, landed on main on 7 November 2026, renamed COLLECTIVE-DIRECTION's exit "Give first, with a reserve" to "Spare all
# one waits on": `Tolerance.sparing_gives` has no reserve in it. Entries that named the old row name the new one.
WHY_AA = "COLLECTIVE-DIRECTION's exit 'Give first, with a reserve' is 'Spare all one waits on' since AA's errata (7 November 2026): the law has no reserve in it"
LIVE_AA = {
    'cx-asc-founding-restraint-armored': [
        ('Give first, with a reserve; without one, total withholding stays.',
         'Spare all one waits on: a formation that does gives from step 1 whatever the start; where none does, total withholding, once reached, stays.'),
        ('Restraint within the joint slack; Give first, with a reserve', 'Restraint within the joint slack; Spare all one waits on'),
        ('that a first giver needs a reserve.', 'that one sparing all it waits on gives from step 1 whatever the start.')],
    'cx-archearth-security-and-cooperation': [('lists this as the exit Give first, with a reserve.', 'lists this as the exit Spare all one waits on.')],
    'cx-kpso-the-transition': [('give first with a reserve, and others.', 'spare all one waits on, and others.')],
    'cx-ma-exit-sequence': [('stepwise reward, give first, independent causes', 'stepwise reward, spare all one waits on, independent causes')],
    'cx-zhishan-prohibition-needs-mechanism': [('give first with a reserve, count reviewers by causes.', 'spare all one waits on, count reviewers by causes.')],
    'cx-syscyb-trap-escalation': [('has a form only on waiting (giving first, with a reserve);', 'has a form only on waiting (sparing all one waits on, which gives from step 1);')],
}
# Round two found two more wordings that give ranking to C alone, at their homes (apply_ranking.py): 05's D65 label and
# eight records' "ranking goes through the comparison C". Every entry quoting them quotes the corrected home.
WHY_RANKING = "05's D65 label and eight records gave ranking to C alone; corrected at home (apply_ranking.py, 7 November 2026): the entry quotes what it says now"
LIVE_RANKING = [("any ranking is C's, under the two premises of 07", "scope by the continuation condition, and a ranking needs C or a premise in its place (07 §4)"),
                ('ranking goes through the comparison C.', 'ranking goes through the comparison C or a premise in its place.')]
# Three entries round two's checker named and no group listed: they keep 02's label "any giving law" and drop its premises.
WHY_GIVING = "02's margin of a regime is exact under its premises on giving, which the entry dropped (round two's checker, 7 November 2026)"
PREMISES = 'short of the draw below y, nothing from nothing, meeting it at every z from y with z + H at most a top the step keeps, and 0 < H + y'
LIVE_GIVING = {
    'cx-syscyb-holling-resilience-stability': [('For one condition under a standing draw, a level up to the top ends exactly',
        f'For one condition under a standing draw H, under its premises ({PREMISES}), a level up to the top ends exactly')],
    'cx-dpc-fold': [('Exactness for any giving law in whole numbers;', f"Exactness in whole numbers under the regime's premises ({PREMISES});")],
    'cx-ecoevo-allee-effects': [('for any giving law short of the draw below y, with nothing from nothing, a level up to a top ends exactly below H + y.',
        'for any giving law short of a standing draw H below y, with nothing from nothing, meeting it at every z from y with z + H at most a top the step keeps, and 0 < H + y, a level up to that top ends exactly where it starts below H + y.')],
}
# Its checker found six more entry fields, and one group summary, giving ranking to C alone in other words.
LIVE_RANKING_MORE = {
    'cx-ecs-organization-as-object-of-learning': [("any ranking there is C's, with the continuation condition for scope, neither asserted.",
        'any ranking there needs C, or a premise in its place, for order, with the continuation condition for scope, neither asserted.')],
    'cx-sspiral-multicellular-question': [('or that sequestration is better, which goes through C.', 'or that sequestration is better, which goes through C or a premise in its place.')],
    'cx-sty-rules-revised-like-software': [("Any 'better' is C's, the condition for scope, neither asserted.", "Any 'better' needs C or a premise in its place, the condition for scope, neither asserted.")],
    'cx-fork-landscape-deformation': [('a preference among courses needs C for order,', 'a preference among courses needs C, or a premise in its place, for order,')],
    'cx-abr-talion-and-pardon': [('Ranking closing above keeping would need C for order,', 'Ranking closing above keeping would need C, or a premise in its place, for order,')],
    'cx-pal-natural-selection-among-ais': [('a ranking would need C with the continuation condition,', 'a ranking would need C, or a premise in its place, with the continuation condition for scope,')],
}
GROUP_RANKING = {'systems-cybernetics': ('where any order needs C and scope the continuation condition', 'where any order needs C or a premise in its place and scope the continuation condition')}

# LM2, landed on main on 7 November 2026, wrote "arising" for "generation" where the Lean meant arising; 04 now says the
# record's id keeps the older word, not its title. main_drift.py's third run found one entry quoting the old parenthesis.
WHY_LM2 = "LM2 (7 November 2026): 04 says the record's id, not its title, keeps the older word 'generation'"
LIVE_LM2 = {'cx-sty-generators': [("the record's title 'uses \\\"generation\\\" in the older sense of arising'",
                                   "the record's id, `generation-is-replenishment`, 'keeps the older word'")]}
# Words the corrections removed at home; no entry may still state them as what the home says.
GONE = ['keeps its standing after it stops measuring. T7', 'account of power is the closed loop', 'that sense is wider',
        'working definition is wider', 'imperial examination is this case', 'imperial examination is read', 'supported in simulation (MQ1;',
        'conjectured (T3), supported in simulation', 'says a measure made a target stops measuring', 'two earlier phase results',
        'supplies is the beginning of the kept history', 'Correspondence: hysteresis of collapse', "Jonas (1979): the existence of the whole",
        'labelled any type, on finitely many', "any ranking is C's", "ranking there is C's", 'which goes through C.', "Any 'better' is C's", 'needs C for order,', 'need C for order,', 'need C with the continuation condition', 'any order needs C and scope', 'goes through the comparison C.', 'Give first, with a reserve', 'give first with a reserve', 'giving first, with a reserve', 'a first giver needs a reserve', 'give first, independent', "refutation\\\" is `lock_outlives_loss`", "refutation' is lock_outlives_loss"]



def _field(entry, path):
    """The holder and key of a field named like 'reading' or 'targets[2].says'; English text sits under 'en'."""
    m = re.fullmatch(r'targets\[(\d+)\]\.(says|part|role)', path)
    holder, key = (entry['targets'][int(m.group(1))], m.group(2)) if m else (entry, path)
    if isinstance(holder.get(key), dict):
        holder, key = holder[key], 'en'
    return holder, key


def main_drift(entries, why, problems):
    """Apply reads/main-drift-<cluster>.json and reads/claims-<group>.json (the second round, searched by claim), as their
    checkers' .check.json amend them: each entry field that stated what main changed at its home (LM1, AA's errata and
    restatements) states what the home says now. The checker's edits replace the author's where it
    says fix. Stops on an edit that does not match exactly once, or on a label it cannot set."""
    # Round one (by words) before round two (by claim): the second was read against the text the first left.
    for path in [*sorted(READS.glob('main-drift-*.json')), *sorted(READS.glob('claims-*.json'))]:
        if path.name.endswith(('.in.json', '.check.json')):
            continue
        author = json.loads(path.read_text(encoding='utf-8'))
        checks = {(i['id'], i['field']): i for i in json.loads(path.with_suffix('.check.json').read_text(encoding='utf-8'))['items']}
        listed = {(i['id'], i['field']) for i in author['items']}
        # A checker's fix to a field the author did not list stands as an item of its own, with no author edits.
        author['items'] += [{'id': i['id'], 'field': i['field'], 'verdict': 'leave', 'edits': [], 'labels': None}
                            for k, i in checks.items() if k not in listed and i['verdict'] == 'fix']
        for item in author['items']:
            check = checks.get((item['id'], item['field']))
            if check is None:
                problems.append(f'{path.name}: {item["id"]} {item["field"]} has no check')
                continue
            fixed = check['verdict'] == 'fix'
            edits = check.get('edits') or [] if fixed else (item.get('edits') or [] if item['verdict'] != 'leave' else [])
            labels = (check.get('labels') if fixed else None) or item.get('labels') or {}
            if not edits and not labels:
                continue
            entry = entries.get(item['id'])
            if entry is None:
                problems.append(f'{path.name}: no entry {item["id"]}')
                continue
            holder, key = _field(entry, item['field'])
            for e in edits:
                if holder[key].count(e['old']) != 1:
                    problems.append(f'{path.name}: {item["id"]} {item["field"]}: {e["old"][:60]!r} occurs {holder[key].count(e["old"])} times')
                    continue
                holder[key] = holder[key].replace(e['old'], e['new'])
            for k, v in labels.items():
                m = re.fullmatch(r'targets\[(\d+)\]\.role', k)
                if m:
                    entry['targets'][int(m.group(1))]['role'] = v
                elif k in ('carried', 'relation', 'agreement_of'):
                    entry[k] = v
                else:
                    problems.append(f'{path.name}: {item["id"]}: cannot set {k}')
            home = json.loads(path.with_name(path.name.replace('.json', '.in.json')).read_text(encoding='utf-8'))
            given = next((i for i in home['items'] if (i['id'], i['field']) == (item['id'], item['field'])), {})
            src = given.get('home') or (f"the {given['family']} claims" if given.get('family') else 'a home its checker read')
            why.setdefault(item['id'], []).append(f'main changed {src} (LM1 or AA, 7 November 2026): {item["field"]} states what it says now'
                                                  + (' (as its checker amended)' if fixed else '') + (f'; labels {labels}' if labels else ''))

def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args(argv)
    files = {p.name.split('.')[0]: json.loads(p.read_text(encoding='utf-8')) for p in sorted(READS.glob('*.5-compare.json'))}
    entries = {e['id']: e for data in files.values() for e in data['entries']}
    why, problems = {}, []
    for path in sorted(READS.glob('critic2-share-*.json')):
        for v in json.loads(path.read_text(encoding='utf-8'))['verdicts']:
            if v['verdict'] == 'holds' or not v.get('fix'):
                continue
            if v['id'] not in entries:
                problems.append(f'{path.name}: no entry {v["id"]}')
                continue
            for field, value in v['fix'].items():
                if field not in SETTABLE:
                    problems.append(f'{path.name}: {v["id"]}: {field} cannot be set')
                    continue
                entries[v['id']][field] = value
            why.setdefault(v['id'], []).append(f'second critic ({v["verdict"]}): {v["why"]}')
    for id_, pairs in LIVE_NOW.items():
        text = json.dumps(entries[id_], ensure_ascii=False)
        for old, new in pairs:
            if old not in text:
                problems.append(f'{id_}: {old[:60]!r} not found')
                continue
            text = text.replace(old, json.dumps(new, ensure_ascii=False)[1:-1])
        entries[id_].clear()
        entries[id_].update(json.loads(text))
        why.setdefault(id_, []).append('COLLECTIVE-DIRECTION §5 corrected by this crosswalk: the entry quotes what it says now')
    for id_, pairs in LIVE_LATER.items():
        text = json.dumps(entries[id_], ensure_ascii=False)
        for old, new in pairs:
            if old not in text:
                problems.append(f'{id_}: {old[:60]!r} not found')
                continue
            text = text.replace(old, json.dumps(new, ensure_ascii=False)[1:-1])
        entries[id_].clear()
        entries[id_].update(json.loads(text))
        why.setdefault(id_, []).append(WHY_LATER)
    for id_, pairs in LIVE_AA.items():
        text = json.dumps(entries[id_], ensure_ascii=False)
        for old, new in pairs:
            if old not in text:
                problems.append(f'{id_}: {old[:60]!r} not found')
                continue
            text = text.replace(old, json.dumps(new, ensure_ascii=False)[1:-1])
        entries[id_].clear()
        entries[id_].update(json.loads(text))
        why.setdefault(id_, []).append(WHY_AA)
    main_drift(entries, why, problems)
    for id_, e in entries.items():
        text = json.dumps(e, ensure_ascii=False)
        if any(old in text for old, _ in LIVE_RANKING):
            for old, new in LIVE_RANKING:
                text = text.replace(old, json.dumps(new, ensure_ascii=False)[1:-1])
            e.clear()
            e.update(json.loads(text))
            why.setdefault(id_, []).append(WHY_RANKING)
    for id_, pairs in LIVE_RANKING_MORE.items():
        text = json.dumps(entries[id_], ensure_ascii=False)
        for old, new in pairs:
            if old not in text:
                problems.append(f'{id_}: {old[:60]!r} not found')
                continue
            text = text.replace(old, json.dumps(new, ensure_ascii=False)[1:-1])
        entries[id_].clear()
        entries[id_].update(json.loads(text))
        why.setdefault(id_, []).append(WHY_RANKING)
    for item, (old, new) in GROUP_RANKING.items():
        group = files[item]['group']
        if group['summary']['en'].count(old) != 1:
            problems.append(f'{item}: group summary: {old[:60]!r} not found once')
        else:
            group['summary']['en'] = group['summary']['en'].replace(old, new)
    for id_, pairs in LIVE_LM2.items():
        text = json.dumps(entries[id_], ensure_ascii=False)
        for old, new in pairs:
            if old not in text:
                problems.append(f'{id_}: {old[:60]!r} not found')
                continue
            text = text.replace(old, json.dumps(new, ensure_ascii=False)[1:-1])
        entries[id_].clear()
        entries[id_].update(json.loads(text))
        why.setdefault(id_, []).append(WHY_LM2)
    for id_, pairs in LIVE_GIVING.items():
        text = json.dumps(entries[id_], ensure_ascii=False)
        for old, new in pairs:
            if old not in text:
                problems.append(f'{id_}: {old[:60]!r} not found')
                continue
            text = text.replace(old, json.dumps(new, ensure_ascii=False)[1:-1])
        entries[id_].clear()
        entries[id_].update(json.loads(text))
        why.setdefault(id_, []).append(WHY_GIVING)
    stale = [i for i, e in entries.items() if 'institution is modelled' in json.dumps(e, ensure_ascii=False)]
    problems += [f'{i}: still states {g!r}' for i, e in entries.items() for g in GONE if g in json.dumps(e, ensure_ascii=False)]
    problems += [f'{i}: still quotes the old CD §5 sentence' for i in stale]
    if problems:
        print('\n'.join(problems))
        return 1
    for item, data in files.items():
        data['changes'] = [{'id': e['id'], 'what': 'changed', 'why': ' / '.join(why[e['id']])} for e in data['entries'] if e['id'] in why]
        if not args.dry_run:
            (READS / f'{item}.6-final.json').write_text(json.dumps(data, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    print(f'{len(why)} entries changed in {len(files)} items')
    return 0


if __name__ == '__main__':
    sys.exit(main())
