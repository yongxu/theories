#!/usr/bin/env python3
"""Review of OU3f's coarse-to-fine pair: set up the statement comparison (read-only on the repository).

tree-new/  the design's Persistence (coarse-to-fine/tree), at its package path;
tree-main/ empty, so that `scratch_build.py tree-main Becoming.Persistence` builds main's bytes from the checkout
           (they match tree/BASE.sha256).
ReviewCtfCheck.lean.txt prints `#check @name` for every declaration the checker registers for Persistence, the two
theorems again under pp.all, and, by a meta program, every constant Lean put in the module with its kind, the hash of
its type and the hash of its value. BecomingPersistenceSignatures.lean.txt is the checker's own signature driver for
Persistence (import, then `#check @` of each theorem). The check files sit beside the trees, not in them (scratch_build
cannot resolve `import Lean`), and end in .lean.txt so that the Lean catalogue does not index them; `lean` runs them
as they are. run_checks.sh builds both trees and runs every check. The trees are scratch: delete them after the run.
usage (from the package folder): python3 -B <this>"""
import shutil
import sys
from pathlib import Path

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
CTF = HERE.parent.parent
PKG = Path.cwd()
assert (PKG / 'check_becoming.py').is_file(), 'run from the package folder'
sys.path.insert(0, str(PKG))
import check_becoming as cb  # noqa: E402

new_src = CTF / 'tree' / 'Becoming' / 'Persistence.lean'
registry = cb.declarations((PKG / 'Becoming' / 'Persistence.lean').read_bytes())
assert registry == cb.declarations(new_src.read_bytes())
names = [d['name'] for d in registry]
check = ['import Lean', 'import Becoming.Persistence', '', 'open Lean Elab Command', '']
check += ['#check @' + n for n in names]
check += ['', 'set_option pp.all true in', '#check @Becoming.Web.wang_state_of_change',
          'set_option pp.all true in', '#check @Becoming.Web.sheng_state_of_change', '']
check += r'''
#eval show CommandElabM Unit from do
  let env ← getEnv
  let some idx := env.getModuleIdx? `Becoming.Persistence | throwError "no module"
  let mut found : Array (String × ConstantInfo) := #[]
  for (n, ci) in env.constants.map₁.toList do
    if env.getModuleIdxFor? n == some idx then
      found := found.push (n.toString, ci)
  let sorted := found.qsort (fun a b => a.1 < b.1)
  for (n, ci) in sorted do
    let kind := match ci with
      | .thmInfo _ => "theorem" | .defnInfo _ => "def" | .axiomInfo _ => "axiom"
      | .opaqueInfo _ => "opaque" | .quotInfo _ => "quot" | .inductInfo _ => "inductive"
      | .ctorInfo _ => "ctor" | .recInfo _ => "rec"
    let value := match ci.value? (allowOpaque := true) with
      | some v => toString v.hash
      | none => "-"
    logInfo m!"CONST {n} {kind} {ci.type.hash} {value}"
'''.strip('\n').split('\n')
(HERE / 'ReviewCtfCheck.lean.txt').write_text('\n'.join(check) + '\n', encoding='utf-8')
signatures = 'import Becoming.Persistence\n' + '\n'.join(
    '#check @' + d['name'] for d in registry if d['kind'] == 'theorem') + '\n'
(HERE / 'BecomingPersistenceSignatures.lean.txt').write_text(signatures, encoding='utf-8')
(HERE / 'tree-main').mkdir(exist_ok=True)
(HERE / 'tree-new' / 'Becoming').mkdir(parents=True, exist_ok=True)
shutil.copyfile(new_src, HERE / 'tree-new' / 'Becoming' / 'Persistence.lean')
print('check files and trees written:', len(names), 'declarations,', signatures.count('#check'), 'theorems')
