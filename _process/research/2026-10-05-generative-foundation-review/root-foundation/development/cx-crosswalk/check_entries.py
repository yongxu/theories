#!/usr/bin/env python3
"""Check one or more crosswalk read files against BRIEF.md's schema, without running anything heavy.

usage: python3 -B check_entries.py FILE.json [FILE.json ...]

Checks shape and closed lists; that each record exists and each anchor resolves in the live account; that an entry's
fields fit its `carried`; that a quote is verbatim in the repository file it cites; that agreement says what it is
agreement with and what each target does (REPAIR.md); and that no summary counts by hand. It cannot check that a reading is
right: that is what the reads are for. Exit 1 on any error; warnings name what a reader should look at again.
"""
import json
import re
import sys
import unicodedata
from pathlib import Path

ROOT = next(p for p in Path(__file__).resolve().parents if (p / 'AGENTS.md').is_file())
RECORDS = ROOT / 'theories/becoming/results/records'
LIVE = ('theories/becoming/ONE-PAGE', 'theories/becoming/THE-THEORY-OF-BECOMING', 'theories/becoming/chapters/',
        'theories/becoming/COLLECTIVE-DIRECTION', 'theories/becoming/FREE-ENERGY-PRINCIPLE',
        'theories/becoming/ONE-ARGUMENT', 'theories/becoming/review/', 'GLOSSARY', 'theories/becoming/results/records/')
DOMAINS = ('earlier-folders', 'chinese-classical', 'buddhist', 'other-indian', 'greek-roman', 'abrahamic-islamic',
           'indigenous-african', 'modern-philosophy', 'systems-cybernetics', 'dynamics-physics-complexity',
           'ecology-evolution', 'economics-politics-sociology', 'psychology-alignment-logic')
KINDS = ('theory', 'design', 'method', 'provenance', 'exploration', 'domain')
CARRIED = ('carried', 'carried-in-part', 'changed', 'history-only', 'not-carried', 'fresh-reading')
RELATIONS = ('agreement', 'scope', 'divergence', 'contrary-reading')
BASES = ('read-in-repo', 'ai-knowledge')
AGREEMENT_OF = ('law', 'thesis-or-method', 'reading')
ROLES = ('carries', 'neighbour', 'limit')
ENTRY = ('id', 'name', 'domain', 'group', 'source', 'sense', 'quote', 'carried', 'relation', 'agreement_of', 'reading', 'targets',
         'account_adds', 'source_adds', 'absence', 'same_as', 'labels')
MANY_STATEMENTS = ('theories/becoming/chapters/07-SIGNIFICANCE.md#alignment-without-premise',)
HAND_COUNT = re.compile(r'\b\d+\s+(?:agreement|scope|divergence|contrary|carried|not[- ]carried|fresh|changed|history)', re.I)
TRACE = re.compile(r'\b(?:this attempt|earlier attempt|an earlier run|earlier check|previous attempt)\b', re.I)
OWN_JOIN = re.compile(r'\b(?:is mine|are mine|my reading|my composition|this read\'s|this reading\'s|no live text)\b', re.I)
GROUP = ('id', 'domain', 'title', 'kind', 'summary', 'read', 'skimmed', 'searched', 'not_mapped', 'coverage')
ID = re.compile(r'cx-[a-z0-9][a-z0-9-]*$')
ANCHOR = re.compile(r'<a id="([^"]+)"')
HEADING = re.compile(r'^#{1,6}\s+(.+?)\s*$', re.M)


def slug(heading):
    heading = re.sub(r'\[([^\]]+)\]\([^)]*\)', r'\1', heading)
    heading = re.sub(r'<[^>]*>', '', heading).replace('`', '').lower()
    kept = ''.join(c for c in heading if c in '-_' or not unicodedata.category(c).startswith(('P', 'S')))
    return kept.replace(' ', '-')


_anchors = {}


def anchors(path):
    if path not in _anchors:
        text = (ROOT / path).read_text(encoding='utf-8')
        found = set(ANCHOR.findall(text))
        for h in HEADING.findall(text):
            found.add(slug(h))
        _anchors[path] = found
    return _anchors[path]


def text(value):
    return isinstance(value, dict) and isinstance(value.get('en'), str) and value['en'].strip() != ''


def check_target(where, t, errors):
    if not isinstance(t, dict):
        errors.append(f'{where}: a target is not an object')
        return
    if not t.get('record') and not t.get('anchor'):
        errors.append(f'{where}: a target names neither a record nor an anchor')
    if t.get('record') and not (RECORDS / (t['record'] + '.json')).is_file():
        errors.append(f'{where}: no record {t["record"]}')
    if t.get('anchor'):
        path, mark, anchor = t['anchor'].partition('#')
        if not (ROOT / path).is_file():
            errors.append(f'{where}: no file {path}')
        elif not path.startswith(LIVE):
            errors.append(f'{where}: {path} is not in the live account (see BRIEF: What is live)')
        elif mark and anchor not in anchors(path):
            errors.append(f'{where}: {path} has no anchor {anchor}')
    if not text(t.get('says')):
        errors.append(f'{where}: a target must say, in `says.en`, what it states')
    if t.get('role') not in ROLES:
        errors.append(f'{where}: a target\'s role must be one of {ROLES}')
    if t.get('anchor') in MANY_STATEMENTS and not t.get('part'):
        errors.append(f'{where}: {t["anchor"]} holds many statements; `part` names the one meant')
    extra = set(t) - {'record', 'anchor', 'says', 'role', 'part'}
    if extra:
        errors.append(f'{where}: unknown target fields {sorted(extra)}')


def record_is_law(record):
    data = json.loads((RECORDS / (record + '.json')).read_text(encoding='utf-8'))
    return data.get('status') == 'recorded-checked' and data.get('kind') == 'theorem'


def check_entry(e, group_id, domain, seen, errors, warnings):
    where = e.get('id', '<no id>') if isinstance(e, dict) else '<not an object>'
    if not isinstance(e, dict):
        errors.append(f'{where}')
        return
    for field in ENTRY:
        if field not in e:
            errors.append(f'{where}: missing {field}')
    extra = set(e) - set(ENTRY)
    if extra:
        errors.append(f'{where}: unknown fields {sorted(extra)}')
    if not ID.match(str(e.get('id', ''))):
        errors.append(f'{where}: id must match cx-[a-z0-9-]+')
    if e.get('id') in seen:
        errors.append(f'{where}: duplicate id')
    seen.add(e.get('id'))
    if e.get('group') != group_id:
        errors.append(f'{where}: group is not {group_id}')
    if e.get('domain') != domain:
        errors.append(f'{where}: domain is not {domain}')
    for field in ('name', 'sense', 'reading'):
        if not text(e.get(field)):
            errors.append(f'{where}: {field}.en is empty')
    for field in ('account_adds', 'source_adds'):
        if e.get(field) is not None and not text(e.get(field)):
            errors.append(f'{where}: {field} must be null or carry en')
    if 'AI reading' not in (e.get('labels') or []):
        errors.append(f'{where}: labels must include "AI reading"')
    source = e.get('source') or {}
    if source.get('basis') not in BASES:
        errors.append(f'{where}: source.basis must be one of {BASES}')
    if not source.get('work') or not source.get('locator'):
        errors.append(f'{where}: source needs work and locator')
    quote = e.get('quote')
    if source.get('basis') == 'ai-knowledge' and quote:
        errors.append(f'{where}: an ai-knowledge source has no stored text, so its quote must be null')
    if source.get('basis') == 'read-in-repo':
        p = ROOT / str(source.get('work', ''))
        if not p.is_file():
            errors.append(f'{where}: read-in-repo source {source.get("work")} is not a repository file')
        elif quote and quote not in p.read_text(encoding='utf-8'):
            errors.append(f'{where}: quote is not verbatim in {source["work"]}')
    if quote and len(quote) > 160:
        errors.append(f'{where}: quote is too long; keep it short')
    carried, relation, targets, absence = e.get('carried'), e.get('relation'), e.get('targets'), e.get('absence')
    if carried not in CARRIED:
        errors.append(f'{where}: carried must be one of {CARRIED}')
    if relation is not None and relation not in RELATIONS:
        errors.append(f'{where}: relation must be null or one of {RELATIONS}')
    if not isinstance(targets, list):
        errors.append(f'{where}: targets must be a list')
        targets = []
    if carried in ('carried', 'carried-in-part', 'changed', 'fresh-reading'):
        if relation is None:
            errors.append(f'{where}: {carried} needs a relation')
        if not targets:
            errors.append(f'{where}: {carried} needs targets')
        if targets and not any(isinstance(t, dict) and t.get('role') == 'carries' for t in targets):
            errors.append(f'{where}: {carried} needs a target whose role is carries')
    if carried == 'carried-in-part' and not e.get('source_adds'):
        errors.append(f'{where}: carried-in-part must say in source_adds what is not stated')
    if carried == 'history-only' and any(isinstance(t, dict) and t.get('role') == 'carries' for t in targets):
        errors.append(f'{where}: nothing carries a history-only entry; its targets are neighbours')
    of = e.get('agreement_of')
    if relation == 'agreement' and of not in AGREEMENT_OF:
        errors.append(f'{where}: agreement must say agreement_of, one of {AGREEMENT_OF}')
    if relation != 'agreement' and of is not None:
        errors.append(f'{where}: agreement_of is only for agreement')
    if of == 'law' and not any(isinstance(t, dict) and t.get('role') == 'carries' and t.get('record')
                               and (RECORDS / (t['record'] + '.json')).is_file() and record_is_law(t['record']) for t in targets):
        errors.append(f'{where}: agreement_of law needs a carrying target that is a checked theorem record')
    reading = (e.get('reading') or {}).get('en', '') if isinstance(e.get('reading'), dict) else ''
    if OWN_JOIN.search(reading) and (carried == 'carried-in-part' or of == 'law'):
        warnings.append(f'{where}: the reading declares its own join; stays {carried}/{of} only if that is one link of a stated claim')
    same = e.get('same_as')
    if same is not None and not (isinstance(same, list) and all(isinstance(i, str) and ID.match(i) for i in same)):
        errors.append(f'{where}: same_as is null or a list of entry ids')
    if carried == 'not-carried' and (relation is not None or targets):
        errors.append(f'{where}: not-carried has no relation and no targets')
    if carried in ('not-carried', 'history-only'):
        if not (isinstance(absence, dict) and absence.get('searched')):
            errors.append(f'{where}: {carried} needs absence.searched')
    elif absence is not None:
        errors.append(f'{where}: absence is only for not-carried and history-only')
    for t in targets:
        check_target(where, t, errors)


def check_file(path, errors, warnings):
    data = json.loads(Path(path).read_text(encoding='utf-8'))
    group = data.get('group') or {}
    for field in GROUP:
        if field not in group:
            errors.append(f'group: missing {field}')
    if group.get('domain') not in DOMAINS:
        errors.append(f'group: domain must be one of {DOMAINS}')
    if group.get('kind') not in KINDS:
        errors.append(f'group: kind must be one of {KINDS}')
    for field in ('title', 'summary'):
        if not text(group.get(field)):
            errors.append(f'group: {field}.en is empty')
    if text(group.get('summary')) and HAND_COUNT.search(group['summary']['en']):
        errors.append('group: the summary counts by hand; counts come from the entries')
    if TRACE.search(json.dumps([group.get(k) for k in ('read', 'skimmed', 'searched', 'summary')], ensure_ascii=False)):
        errors.append('group: a trace of an earlier attempt; say what this file rests on')
    if group.get('domain') != 'earlier-folders':
        cov = group.get('coverage')
        if not (isinstance(cov, dict) and 'present' in cov and 'absent' in cov):
            errors.append('group: a domain needs coverage with present and absent')
        else:
            for item in cov.get('present', []):
                where = str(item.get('where', '')).partition('#')[0]
                if where and not (ROOT / where).exists():
                    errors.append(f'coverage: no path {where}')
    seen = set()
    entries = data.get('entries')
    if not isinstance(entries, list) or not entries:
        errors.append('entries: missing or empty')
        return 0
    for e in entries:
        check_entry(e, group.get('id'), group.get('domain'), seen, errors, warnings)
    changes = data.get('changes')
    if changes is not None:
        for c in changes:
            if c.get('what') not in ('kept', 'changed', 'added', 'dropped') or not c.get('id'):
                errors.append(f'changes: bad item {c}')
    return len(entries)


def main(argv):
    if not argv:
        print(__doc__)
        return 2
    bad = 0
    for path in argv:
        errors, warnings = [], []
        try:
            n = check_file(path, errors, warnings)
        except (OSError, ValueError) as exc:
            errors, n = [f'cannot read: {exc}'], 0
        if errors:
            bad += 1
            print(f'{path}: {len(errors)} errors')
            for line in errors:
                print('  ' + line)
        else:
            print(f'{path}: ok, {n} entries')
        for line in warnings:
            print('  warning: ' + line)
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
