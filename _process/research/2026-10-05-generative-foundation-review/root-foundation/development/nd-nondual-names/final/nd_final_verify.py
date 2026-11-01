"""ND's final stage: the regenerated files equal the old ones but for the names (argv: OLD NEW [OLD NEW ...]).

Each OLD is read with every key and string mapped as the stage maps them (master_laws → shared_laws, 'master law' →
'shared law', 'no master law' → 'no shared law', the record id master-laws-on-the-grammar → shared-laws-on-the-grammar,
the generator's and the data's file names), and compared with NEW. Two fields may differ beyond the names, and are
reported, not compared: `inputs_sha256`, whose paths and digests follow the renamed and edited inputs, and `about`.
Anything else that differs is printed and the exit is 1."""
import json, re, sys

STR = [(re.compile(r'(?<![\w-])master-laws-on-the-grammar(?![\w-])'), 'shared-laws-on-the-grammar'),
       (re.compile(r'master_law'), 'shared_law'), (re.compile(r'(?<![\w-])master-laws\.json'), 'shared-laws.json'),
       (re.compile(r'(?<![\w-])master law'), 'shared law')]
SKIP = {'inputs_sha256', 'about'}


def m(s):
    for a, b in STR:
        s = a.sub(b, s)
    return s


def mapped(x):
    if isinstance(x, dict):
        return {m(k): mapped(v) for k, v in x.items()}
    if isinstance(x, list):
        return [mapped(v) for v in x]
    return m(x) if isinstance(x, str) else x


def diff(a, b, path, out):
    if isinstance(a, dict) and isinstance(b, dict):
        for k in sorted(set(a) | set(b)):
            if k in SKIP and path == '':
                continue
            if k not in a or k not in b:
                out.append(f'{path}/{k}: only in {"new" if k in b else "old"}')
            else:
                diff(a[k], b[k], f'{path}/{k}', out)
    elif isinstance(a, list) and isinstance(b, list) and len(a) == len(b):
        for i, (x, y) in enumerate(zip(a, b)):
            diff(x, y, f'{path}[{i}]', out)
    elif a != b:
        out.append(f'{path}: {json.dumps(a, ensure_ascii=False)[:160]} -> {json.dumps(b, ensure_ascii=False)[:160]}')


bad = 0
for old, new in zip(sys.argv[1::2], sys.argv[2::2]):
    a, b = mapped(json.load(open(old))), json.load(open(new))
    out = []
    diff(a, b, '', out)
    for k in SKIP:
        if isinstance(a, dict) and k in a and a.get(k) != b.get(k):
            print(f'{new}: {k} differs (expected where inputs were renamed or edited)')
    print(f'{new}: {len(out)} difference(s) beyond the names')
    for line in out[:40]:
        print('  ' + line)
    bad |= bool(out)
sys.exit(bad)
