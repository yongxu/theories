#!/usr/bin/env python3
"""WRP2's signature audit (GrammarLaws' owner's decision (a), condition 4): every declaration of
`Becoming.GrammarLaws` and `Becoming.GrammarTransport` at the latest core receipt keeps its statement
(`#check @name`) and, for a definition or structure, its body (`#print name`) in the scratch tree's
version, which only adds declarations and changes proofs. Restores the compiled modules of both versions
from the checker's cache, so nothing is compiled: run scratch_build.py on the tree first. Messages are
read from `lean --json`, each by its line. Also lists the landed theorems whose source block changed (the
changed proofs) and the declarations added.
usage (from the checkout root): python3 -B <kit>/signatures_wrp2.py [--json OUT]"""
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree'
sys.path.insert(0, str(PKG))
import check_becoming as cb  # noqa: E402

MODULES = ['Becoming.GrammarLaws', 'Becoming.GrammarTransport']
KEYWORDS = r'(?:theorem|def|abbrev|structure|inductive|instance)'


def latest_receipt():
    return sorted(p for p in (PKG / 'becoming-checks').iterdir() if re.fullmatch(r'\d{8}T\d{6}\.\d+Z', p.name))[-1]


def restore(work, overlay):
    """The compiled closure of MODULES, restored from the cache into `work`; returns Lean's command."""
    index = cb.module_index()
    for name, path in overlay.items():
        index[name] = [path]
    order = cb.closure(index, MODULES)
    sources = {name: index[name][0].read_bytes() for name in order}
    command, binary, _ = cb.resolve_lean()
    context = [cb.audit_support.TOOLCHAIN, cb.audit_support.digest(binary.read_bytes())]
    keys = cb.module_keys(context, sources, order)
    missing = []
    for name in order:
        target = work / cb.source_file(name)
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(sources[name])
        if not cb.reuse(keys[name], [work / (cb.source_file(name)[:-5] + '.olean')]):
            missing.append(name)
    assert not missing, ('not in the cache for these sources (run scratch_build.py first)', missing)
    return command


def messages(work, command, lines):
    """Lean's messages for a driver of `lines`, by line number (1-based, the import lines first)."""
    driver = work / 'SignatureAudit.lean'
    driver.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    env = {**os.environ, 'LEAN_PATH': str(work)}
    p = subprocess.run(command + ['--json', driver.name], cwd=work, env=env, text=True,
                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=1800)
    found = {}
    for raw in p.stdout.splitlines():
        try:
            m = json.loads(raw)
        except ValueError:
            continue
        assert m.get('severity') == 'information', m
        found.setdefault(m['pos']['line'], []).append(m['data'])
    assert p.returncode == 0, p.stdout[-2000:]
    return found


def short(name):
    return name.split('Becoming.', 1)[1].removeprefix('GrammarLaws.').removeprefix('«一一对应».')


def block(text, name):
    """The source of a declaration: from its keyword line to the next top-level declaration or doc."""
    for s in (name.split('Becoming.', 1)[1], short(name)):
        m = re.search(r'^' + KEYWORDS + r' ' + re.escape(s) + r'(?=[\s:({\[])', text, re.M)
        if m:
            break
    assert m, name
    end = re.search(r'^(?:/--|/-!|' + KEYWORDS + r' |end |section |namespace |variable )', text[m.end():], re.M)
    return text[m.start():m.end() + (end.start() if end else len(text))].rstrip()


def main():
    receipt = latest_receipt()
    R = json.load(open(receipt / 'verification.json'))
    old_decls = {m['module']: m['declarations'] for m in R['modules'] if m['module'] in MODULES}
    new_decls = {}
    for module in MODULES:
        audit = TREE / '.build' / ('Becoming' + module.split('.', 1)[1] + 'AxiomAudit.lean')
        new_decls[module] = re.findall(r'^#print axioms (\S+)$', audit.read_text(encoding='utf-8'), re.M)
    names = [d['name'] for module in MODULES for d in old_decls[module]]
    kinds = {d['name']: d['kind'] for module in MODULES for d in old_decls[module]}
    lines = ['import ' + module for module in MODULES]
    lines += ['#check @' + n for n in names]
    lines += ['#print ' + n for n in names if kinds[n] != 'theorem']
    out = {}
    for label, overlay in (('landed', {}), ('tree', {m: TREE / cb.source_file(m) for m in MODULES})):
        with tempfile.TemporaryDirectory(prefix='wrp2-signatures-') as scratch:
            work = Path(scratch)
            command = restore(work, overlay)
            out[label] = messages(work, command, lines)
    differ = [lines[i - 1] for i in range(len(MODULES) + 1, len(lines) + 1)
              if out['landed'].get(i) != out['tree'].get(i)]
    missing = [lines[i - 1] for i in range(len(MODULES) + 1, len(lines) + 1)
               if not out['landed'].get(i) or not out['tree'].get(i)]
    report = {'receipt': receipt.name, 'modules': {}}
    for module in MODULES:
        old_names = [d['name'] for d in old_decls[module]]
        landed_text = (PKG / cb.source_file(module)).read_text(encoding='utf-8')
        tree_text = (TREE / cb.source_file(module)).read_text(encoding='utf-8')
        proof_changed = [n for n in old_names if kinds[n] == 'theorem' and block(landed_text, n) != block(tree_text, n)]
        report['modules'][module] = {
            'landed_declarations': len(old_names),
            'landed_theorems': sum(1 for d in old_decls[module] if d['kind'] == 'theorem'),
            'tree_declarations': len(new_decls[module]),
            'removed': sorted(set(old_names) - set(new_decls[module])),
            'added': [n for n in new_decls[module] if n not in set(old_names)],
            'theorems_whose_source_changed': proof_changed,
        }
    report['statements_or_bodies_differing'] = differ
    report['without_output'] = missing
    report['checked'] = {'statements': len(names), 'bodies': sum(1 for n in names if kinds[n] != 'theorem')}
    print(json.dumps(report, indent=1, ensure_ascii=False))
    if '--json' in sys.argv:
        Path(sys.argv[sys.argv.index('--json') + 1]).write_text(json.dumps(report, indent=1, ensure_ascii=False) + '\n',
                                                               encoding='utf-8')
    assert not differ and not missing and all(not v['removed'] for v in report['modules'].values()), 'signature change'


if __name__ == '__main__':
    main()
