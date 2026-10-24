"""ZE: check a coder's answer against its packet and FC1's schema (every segment answered once, fields and enums).

    python3 -I validate_coding.py PACKET ANSWER      # exit 1 on any failure
"""
import json, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
SCHEMA = json.loads((HERE.parent / 'zhonghua/fidelity/briefs/code.schema.json').read_text())


def check(obj, schema, path, fail):
    t = schema.get('type')
    if t == 'object':
        if not isinstance(obj, dict):
            return fail.append('%s: not an object' % path)
        for k in schema.get('required', []):
            if k not in obj:
                fail.append('%s: missing %s' % (path, k))
        for k, v in obj.items():
            if k not in schema.get('properties', {}):
                fail.append('%s: extra field %s' % (path, k))
            else:
                check(v, schema['properties'][k], path + '.' + k, fail)
    elif t == 'array':
        if not isinstance(obj, list):
            return fail.append('%s: not an array' % path)
        for i, x in enumerate(obj):
            check(x, schema['items'], '%s[%d]' % (path, i), fail)
    elif t == 'string':
        if not isinstance(obj, str):
            fail.append('%s: not a string' % path)
        elif 'enum' in schema and obj not in schema['enum']:
            fail.append('%s: %r not in %s' % (path, obj, schema['enum']))


def main():
    packet = json.loads(Path(sys.argv[1]).read_text())
    ans = json.loads(Path(sys.argv[2]).read_text())
    fail = []
    check(ans, SCHEMA, 'answer', fail)
    want = [s['seg_id'] for s in packet['segments']]
    got = [s.get('seg_id') for s in ans.get('segments', [])]
    if sorted(want) != sorted(got):
        fail.append('segments: missing %s, extra %s' % (sorted(set(want) - set(got)), sorted(set(got) - set(want))))
    for x in fail[:30]:
        print('FAIL', x)
    print('%s: %d segments, %s' % (Path(sys.argv[2]).name, len(got), 'FAILED %d' % len(fail) if fail else 'ok'))
    sys.exit(1 if fail else 0)


if __name__ == '__main__':
    main()
