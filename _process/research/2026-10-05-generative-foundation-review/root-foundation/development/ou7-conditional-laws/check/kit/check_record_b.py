"""Check part B's record text before landing: its declarations against a build's axiom audits, and
its fields against the record lint (tools/research/style.py) and the schema-2 field validator
(tools/research/registry.py), on a record completed with stand-in fixed fields.

Run from the repository root:  python3 -B <this file> [declarations file]
The declarations file lists one full name per line, read from the scratch build's axiom audits;
built-declarations.txt beside this file is the list for the build the kit holds.
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
sys.path.insert(0, str(ROOT))
from tools.research import style, registry  # noqa: E402

KIT = Path(__file__).resolve().parent
text = json.loads((KIT / 'record-text.json').read_text(encoding='utf-8'))


def built_declarations(path):
    """Every declaration the scratch build audited."""
    return {line.strip() for line in Path(path).read_text(encoding='utf-8').splitlines() if line.strip()}


def main():
    log = sys.argv[1] if len(sys.argv) > 1 else KIT / 'built-declarations.txt'
    record = {k: v for k, v in text.items() if k not in ('about', 'home', 'modules')}
    modules = text['modules']
    used = sorted({d for law in record['laws'] for d in law['declarations']} |
                  {x['witness'] for x in record['does_not_show'] if 'witness' in x} |
                  {a for a in record['aliases'] if a.startswith('Becoming.')})
    problems = []
    if log:
        names = built_declarations(log)
        missing = [d for d in used if d not in names]
        problems += [f'not built: {d}' for d in missing]
        print(f'{len(used)} declarations named, {len(names)} built, {len(missing)} not built')
    record.update({
        'schema_version': 2, 'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01',
        'reviewed_at_utc': '2026-11-01T00:00:00+00:00', 'canonical_source': modules['Becoming.RoomNet'],
        'references': [{'path': p, 'role': 'proof', 'sha256': '0' * 64, 'declarations': used} for p in modules.values()],
        'proof_bindings': [], 'history': [{'en': 'stand-in'}],
    })
    findings = style.lint(record)
    for f in findings:
        print(f"lint {f['severity']}: {f['field']} {f['rule']} {f['detail']}")
    errors = registry.validate_v2_fields(record)
    paths = {x['path'] for x in record['references']}
    for edge in record['dependencies']:
        c = edge.get('interface', {})
        if not all(registry.pair(c.get(k)) for k in ('output', 'input', 'conditions')):
            errors.append(f"{edge['id']}: interface needs output, input and conditions")
        if c and c.get('evidence') not in paths:
            errors.append(f"{edge['id']}: interface evidence not a reference")
    for c in record['counterexamples']:
        if c.get('path') not in paths or not registry.pair(c.get('detail')):
            errors.append('counterexample needs a reference path and a detail')
    boundaries = json.loads((ROOT / 'theories/becoming/results/data/standard-boundaries.json').read_text())
    known = set(boundaries.get('boundaries', boundaries))
    errors += [f'unknown standard boundary {k}' for k in record['standard_boundaries'] if k not in known]
    records = ROOT / 'theories/becoming/results/records'
    ids = {p.stem for p in records.glob('*.json')}
    errors += [f'unknown record {e["id"]}' for e in record['dependencies'] + record['related'] if e['id'] not in ids]
    if record['id'] in ids:
        errors.append(f"id {record['id']} is taken")
    taken = {}
    for p in records.glob('*.json'):
        r = json.loads(p.read_text(encoding='utf-8'))
        for a in [r.get('id')] + r.get('aliases', []):
            taken[str(a).casefold()] = r.get('id')
    errors += [f'alias {a} is owned by {taken[a.casefold()]}' for a in record['aliases'] if a.casefold() in taken]
    for e in problems + errors:
        print('error:', e)
    hard = [f for f in findings if f['severity'] == 'error']
    print(f'{len(findings)} lint findings ({len(hard)} errors), {len(problems) + len(errors)} other errors')
    return 1 if hard or problems or errors else 0


if __name__ == '__main__':
    sys.exit(main())
