"""The rehearsal's tree and targets, from a finished dry run, for the package's scratch_build.py:

  python3 -B <kit>/rehearsal_tree.py DRY_TREE OUT

OUT/tree gets every Lean file the kit's apply and the stages changed or added, at its package path, each checked
against the source hash the dry run's synthetic receipt recorded right after apply; a file that differs (a throwaway
stage of stage_check.py, an edit after apply) stops it, nothing written. OUT/targets.txt names every module downstream
of those changes, and the root: the modules the landing's core run rebuilds. Run from the checkout whose package holds
every other module, then, from the package folder:

  python3 -B scratch_build.py OUT/tree $(cat OUT/targets.txt)"""
import hashlib
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

DRY, OUT = Path(sys.argv[1]).resolve(), Path(sys.argv[2]).resolve()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
HERE = Path(subprocess.run(['git', 'rev-parse', '--show-toplevel'], capture_output=True, text=True,
                           check=True).stdout.strip()) / PKG
assert not OUT.exists(), ('OUT exists', str(OUT))


def module(rel):
    return '.'.join(Path(rel).with_suffix('').parts)


listed = subprocess.run(['git', 'status', '--porcelain', '--untracked-files=all', '--', PKG], cwd=DRY,
                        capture_output=True, text=True, check=True).stdout
changed = sorted(line[3:][len(PKG):] for line in listed.splitlines() if line.endswith('.lean'))
receipt = max((DRY / PKG / 'becoming-checks').glob('*/verification.json'))
recorded = json.loads(receipt.read_text(encoding='utf-8'))['source_sha256']
added = {m['module'] for m in json.loads(receipt.read_text(encoding='utf-8'))['modules']} - set(recorded)
bad = [rel for rel in changed if module(rel) in recorded and
       recorded[module(rel)] != hashlib.sha256((DRY / PKG / rel).read_bytes()).hexdigest()]
assert not bad, ('not the files apply left (the receipt records others)', bad)
unknown = [rel for rel in changed if module(rel) not in recorded and module(rel) not in added]
assert not unknown, ('Lean files neither in the receipt nor a leaf it models', unknown)
files = {module(p.relative_to(HERE).as_posix()): p for p in (HERE / 'Becoming').rglob('*.lean')}
files['Becoming'] = HERE / 'Becoming.lean'
files.update({module(rel): DRY / PKG / rel for rel in changed})
imports = {m: re.findall(r'^import (\S+)', p.read_text(encoding='utf-8'), re.M) for m, p in files.items()}
importers = {m: [k for k, v in imports.items() if m in v] for m in files}
down, todo = {module(rel) for rel in changed}, [module(rel) for rel in changed]
while todo:
    for k in importers[todo.pop()]:
        if k not in down:
            down.add(k)
            todo.append(k)
for rel in changed:
    (OUT / 'tree' / rel).parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(DRY / PKG / rel, OUT / 'tree' / rel)
(OUT / 'targets.txt').write_text('\n'.join(sorted(down - {'Becoming'}) + ['Becoming']) + '\n', encoding='utf-8')
print(f'{len(changed)} Lean files, each the one apply left (receipt {receipt.parent.name}); {len(down)} targets of '
      f'the package\'s {len(files)} modules')
