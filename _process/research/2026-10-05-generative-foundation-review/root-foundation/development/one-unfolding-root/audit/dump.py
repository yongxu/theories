#!/usr/bin/env python3
"""Produce the dumps the audit reads: python3 -B dump.py OUTDIR

Restores the spine run's compiled modules from the checker's cache exactly as
THEOREM-CONNECTIVITY.py does (same keys, nothing compiled), then runs, in a temporary folder,
the unchanged THEOREM-CONNECTIVITY-DUMP.lean (to OUTDIR/dump.jsonl) and this folder's PROJ-DUMP.lean
(to OUTDIR/proj.jsonl). Writes nothing in the repository; OUTDIR should be outside it."""
import importlib.util
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
TC_PATH = HERE.parents[2] / 'THEOREM-CONNECTIVITY.py'
spec = importlib.util.spec_from_file_location('theorem_connectivity', TC_PATH)
tc = importlib.util.module_from_spec(spec)
spec.loader.exec_module(tc)
cb = tc.cb


def main(outdir):
    outdir = Path(outdir).resolve()
    outdir.mkdir(parents=True, exist_ok=True)
    index = cb.module_index()
    order = cb.closure(index)
    sources = {name: index[name][0].read_bytes() for name in order}
    binary = Path.home() / '.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean'
    context = [cb.audit_support.TOOLCHAIN, cb.audit_support.digest(binary.read_bytes())]
    keys = cb.module_keys(context, sources, order)
    with tempfile.TemporaryDirectory(prefix='dependency-audit-') as scratch:
        work = Path(scratch)
        missing = []
        for name in order:
            target = work / cb.source_file(name)
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(sources[name])
            if not cb.reuse(keys[name], [work / (cb.source_file(name)[:-5] + '.olean')]):
                missing.append(name)
        if missing:
            sys.exit(f'not in the cache for the current sources: {missing}')
        dump = tc.DUMP.read_text()
        joins = ''.join(f'import {n}\n' for n in getattr(cb, 'PERIPHERY_JOINS', []) if f'import {n}\n' not in dump)
        (work / tc.DUMP.name).write_text(dump.replace('import Lean\n', 'import Lean\n' + joins, 1))
        (work / 'PROJ-DUMP.lean').write_text((HERE / 'PROJ-DUMP.lean').read_text())
        lean = [str(Path.home() / '.elan/bin/lean'), '+' + cb.audit_support.TOOLCHAIN]
        for file, var, out in ((tc.DUMP.name, 'THEOREM_CONNECTIVITY_OUT', 'dump.jsonl'),
                               ('PROJ-DUMP.lean', 'AUDIT_PROJ_OUT', 'proj.jsonl')):
            env = {**os.environ, 'LEAN_PATH': str(work), var: str(outdir / out)}
            p = subprocess.run(lean + [file], cwd=work, env=env, text=True,
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=cb.TIMEOUT)
            assert p.returncode == 0 and not re.search(r'\berror:', p.stdout), p.stdout
            print(file, p.stdout.strip()[-200:])
    registry = {name: [d for d in cb.declarations(sources[name])] for name in order}
    import json
    (outdir / 'registry.json').write_text(json.dumps(
        {'spine': list(cb.SPINE), 'rings': {'instances': list(getattr(cb, 'INSTANCES', [])),
                                            'applications': list(getattr(cb, 'APPLICATIONS', []))},
         'declarations': registry}, ensure_ascii=False))
    head = subprocess.run(['git', '-C', str(HERE), 'rev-parse', 'HEAD'], text=True, stdout=subprocess.PIPE).stdout.strip()
    paths = [str(index[n][0].resolve()) for n in order]
    clean = subprocess.run(['git', '-C', str(HERE), 'diff', '--quiet', 'HEAD', '--', *paths]).returncode == 0
    (outdir / 'meta.json').write_text(json.dumps({'commit': head, 'sources_match_commit': clean, 'modules': len(order)}))


if __name__ == '__main__':
    main(sys.argv[1])
