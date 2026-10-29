#!/usr/bin/env python3
"""OU3b: compare the printed statements (`#check @name`, the checker's signature audit) of every declaration of the
fourteen changed modules between main's receipt (the one HEAD holds) and the landing's receipt. The logs come from the
checker's shared cache (each step's key in the receipt) or, failing that, from the retained run folder. A declaration
whose statement changed, or that is gone, is reported; new declarations are listed. The definitions whose bodies
OU3b rewrote (ClosedUnder, WithinClosure, skipAt) print the same type; their bodies are the old ones by `rfl`
(OU3b2Check.lean.txt). Importable (`compare()`), or run to print the report.
usage (from the checkout root, after the checker): python3 -B <kit>/signatures_ou3b.py [RECEIPT_ID]"""
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CHANGED = ('Frame', 'Recurrence', 'Attraction', 'Laws', 'Mechanism', 'IdentificationRuns', 'GrammarRegularity',
           'GrammarScope', 'Regions', 'Admission', 'Flow', 'Amounts', 'InAmounts', 'Weightings')


def receipt_at_head():
    out = subprocess.run(['git', 'show', f'HEAD:{PKG}/becoming-verification.json'], cwd=ROOT, capture_output=True,
                         text=True, check=True).stdout
    return json.loads(out)


def receipt(rid=None):
    path = ROOT / PKG / ('becoming-verification.json' if rid is None else f'becoming-checks/{rid}/verification.json')
    return json.loads(path.read_text())


def log_of(r, step):
    key = r['lean_steps']['keys'][step]
    cached = Path(r['lean_steps']['cache']) / f'{key}.json'
    if cached.exists():
        return json.loads(cached.read_text())['log']
    retained = Path(r['retained_run']) / step if r.get('retained_run') else None
    if retained and retained.exists():
        return retained.read_text()
    raise SystemExit(f'no log for {step} (key {key}): neither in the cache nor in the retained run')


def parse(log):
    """name -> printed statement; an entry starts at column 0, its continuation lines are indented."""
    out, name, lines = {}, None, []
    for line in log.split('\n'):
        if line and not line[0].isspace():
            if name:
                out[name] = '\n'.join(lines)
            head = line.split(' : ', 1)[0]
            name, lines = head.lstrip('@'), [line]
        elif name is not None:
            lines.append(line)
    if name:
        out[name] = '\n'.join(lines)
    return {n: s.rstrip() for n, s in out.items()}


DEF_RE = re.compile(r'^(?:@\[[^\]]*\]\s*)?(?:private |protected |noncomputable )*(def|abbrev|structure|inductive|class) (\S+)')
STARTS = ('def ', 'abbrev ', 'structure ', 'inductive ', 'class ', 'theorem ', 'lemma ', 'instance ', 'example ',
          'namespace ', 'end ', 'section', 'variable ', 'open ', '/-', '@[', 'private ', 'protected ', 'noncomputable ',
          'universe ', 'set_option ', 'attribute ', 'local ', '#')


def blank_comments(text):
    """The text with every comment (block comments, nested, docstrings and module docs among them, and line comments)
    and the contents of every string literal replaced by spaces, line breaks kept, so that a scan reads code only.
    Character literals ('x', '\\n') are kept as they are. (Added 30 October 2026, after HE: a reflowed docstring
    line starting "class constant ..." was read as a definition; the catalogue's parser blanks comments the same way.)"""
    out, i, n, depth, in_string = [], 0, len(text), 0, False
    while i < n:
        c, two = text[i], text[i:i + 2]
        if depth:
            if two == '/-':
                depth, i = depth + 1, i + 2
                out.append('  ')
            elif two == '-/':
                depth, i = depth - 1, i + 2
                out.append('  ')
            else:
                out.append('\n' if c == '\n' else ' ')
                i += 1
        elif in_string:
            if c == '\\' and i + 1 < n:
                out.append(' \n' if text[i + 1] == '\n' else '  ')
                i += 2
            else:
                if c == '"':
                    in_string = False
                out.append(c if c in '"\n' else ' ')
                i += 1
        elif two == '/-':
            depth, i = 1, i + 2
            out.append('  ')
        elif two == '--':
            j = text.find('\n', i)
            j = n if j < 0 else j
            out.append(' ' * (j - i))
            i = j
        elif c == "'" and i + 2 < n and text[i + 1] != '\\' and text[i + 2] == "'":
            out.append(text[i:i + 3])
            i += 3
        elif c == "'" and i + 3 < n and text[i + 1] == '\\' and text[i + 3] == "'":
            out.append(text[i:i + 4])
            i += 4
        else:
            if c == '"':
                in_string = True
            out.append(c)
            i += 1
    return ''.join(out)


def definitions(text):
    """name (with the enclosing namespaces) -> the definition's text, comments and docstrings left out (read through
    blank_comments, so that no comment line is read as a definition and no comment edit as a rewrite)."""
    out, ns, name, body = {}, [], None, []
    for line in blank_comments(text).split('\n'):
        if line.startswith(STARTS) or (line and not line[0].isspace() and line[0] != '|'):
            if name:
                out[name] = '\n'.join(body).rstrip()
                name = None
            m = DEF_RE.match(line)
            if line.startswith('namespace '):
                ns.append(line.split()[1])
            elif line.startswith('end ') and ns and line.split()[1] == ns[-1]:
                ns.pop()
            elif m:
                name, body = '.'.join(ns + [m.group(2)]), [line]
        elif name is not None:
            body.append(line)
    if name:
        out[name] = '\n'.join(body).rstrip()
    return out


def source_at_head(m):
    return subprocess.run(['git', 'show', f'HEAD:{PKG}/Becoming/{m}.lean'], cwd=ROOT, capture_output=True, text=True,
                          check=True).stdout


def compare(new_id=None):
    old, new = receipt_at_head(), receipt(new_id)
    report = {}
    for m in CHANGED:
        step = f'Becoming{m}Signatures.log'
        a, b = parse(log_of(old, step)), parse(log_of(new, step))
        da = definitions(source_at_head(m))
        db = definitions((ROOT / PKG / f'Becoming/{m}.lean').read_text(encoding='utf-8'))
        report[m] = {'old': len(a), 'new': len(b),
                     'changed': sorted(n for n in a if n in b and a[n] != b[n]),
                     'gone': sorted(n for n in a if n not in b),
                     'added': sorted(n for n in b if n not in a),
                     'definitions_rewritten': sorted(n for n in da if n in db and da[n] != db[n]),
                     'definitions_gone': sorted(n for n in da if n not in db),
                     'definitions_added': sorted(n for n in db if n not in da)}
    return old, new, report


if __name__ == '__main__':
    old, new, report = compare(sys.argv[1] if len(sys.argv) > 1 else None)
    print(json.dumps({'old_receipt': old['utc'], 'new_receipt': new['utc'], 'modules': report}, indent=1,
                     ensure_ascii=False))
    rewritten = {m: r['definitions_rewritten'] for m, r in report.items() if r['definitions_rewritten']}
    print('definitions whose bodies changed (expected: ClosedUnder, WithinClosure, skipAt; bodies equal by rfl):',
          rewritten)
    expected = {'Frame': ['Becoming.ClosedUnder', 'Becoming.WithinClosure'], 'Recurrence': ['Becoming.skipAt']}
    bad = {m: r for m, r in report.items() if r['changed'] or r['gone'] or r['definitions_gone']}
    if rewritten != expected:
        bad['definitions'] = rewritten
    print('statements unchanged in every changed module' if not bad else f'CHANGED OR GONE: {bad}')
    sys.exit(1 if bad else 0)
