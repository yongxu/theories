"""Check 3b: the definitions whose scanned bodies differ before and after blank_comments, and why (read-only)."""
import importlib.util, json, subprocess, sys, types, difflib
from pathlib import Path
sys.dont_write_bytecode = True
ROOT = Path.cwd()
REL = ('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
       'ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py')
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
spec = importlib.util.spec_from_file_location('s3b_new', ROOT / REL)
new = importlib.util.module_from_spec(spec); spec.loader.exec_module(new)
old = types.ModuleType('s3b_old')
exec(compile(subprocess.run(['git', 'show', f'c9d47a06f~1:{REL}'], cwd=ROOT, capture_output=True, text=True,
                            check=True).stdout, 's3b_old', 'exec'), old.__dict__)
receipt = json.loads((PKG / 'becoming-verification.json').read_text())
for m in receipt['modules']:
    text = (PKG.parent / receipt['source_paths'][m['module']]).read_text(encoding='utf-8')
    b, a = old.definitions(text), new.definitions(text)
    for n in sorted(set(b) & set(a)):
        if b[n] != a[n]:
            bl, al = b[n].split('\n'), a[n].split('\n')
            diff = [l for l in difflib.unified_diff(bl, al, lineterm='', n=0) if l[:1] in '+-' and l[:3] not in ('+++', '---')]
            print(m['module'], n, f'{len(bl)}->{len(al)} lines;', 'first diff:', diff[:2])
