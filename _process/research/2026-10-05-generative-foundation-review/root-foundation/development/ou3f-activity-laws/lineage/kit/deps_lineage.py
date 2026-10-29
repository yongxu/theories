#!/usr/bin/env python3
"""OU3f, lineage laws: the landing's check that each derivation has no induction of its own and reaches the grammar law
the design names. The review's check (review/checks/Deps.lean) is adapted: for each declaration, the constants its proof
uses directly, with its own compiler-made matchers unfolded, are scanned for the marks of an induction (`brecOn`,
`below`, `rec`, `recOn`, `binductionOn`, `WellFounded.fix`, a `_unary` helper, or its own name), and its proof is
followed transitively to each named constant. The connectivity dump cannot do this, since it leaves out Init's
constants (`Nat.brecOn` among them). On main every one of the eight carries `Nat.brecOn`.
usage: python3 -B <kit>/deps_lineage.py BUILD_DIR   (a scratch build's TREE/.build, or the checker's compiled tree)"""
import os
import subprocess
import sys
import tempfile
from pathlib import Path

W = 'Becoming.Web.'
DERIVED = {
    W + 'Lineage.unique': ['Becoming.«迭之定»'],
    W + 'Lineage.origin': ['Becoming.«迭之定前»'],
    W + 'Lineage.split': ['Becoming.«迭之分»'],
    W + 'Lineage.through': ['Becoming.«迭之分»', W + 'Lineage.split'],
    W + 'Lineage.onward': ['Becoming.«或有后则或迭»'],
    W + 'Lineage.back': ['Becoming.«或有后则或迭»', 'Becoming.«迭之逆»'],
    W + 'Lineage.line': ['Becoming.«迭则及»', 'Becoming.«及之单调»'],
    W + 'line_lineage': ['Becoming.«闭之及»', 'Becoming.«及即迭»'],
}
FOLLOW = {W + 'Lineage.ends': ['Becoming.«迭之定»', 'Becoming.«迭之分»'],
          W + 'lineages_apart': ['Becoming.«迭之定前»', 'Becoming.«迭之分»'],
          W + 'lineage_iff_line': ['Becoming.«迭则及»', 'Becoming.«闭之及»']}
KEPT = [W + 'steps_iff_lineage', W + 'lineage_of_steps', W + 'steps_advance', W + 'steps_start_active']

HEAD = r'''import Becoming.Identity
import Lean

open Lean Meta Elab Command

partial def lineageDirect (env : Environment) (n : Name) (seen : NameSet := {}) : NameSet := Id.run do
  let some ci := env.find? n | return seen
  let some v := ci.value? (allowOpaque := true) | return seen
  let mut acc := seen
  for c in v.getUsedConstants do
    if acc.contains c then continue
    acc := acc.insert c
    if (c.getPrefix == n) && (c.toString.splitOn "match_").length > 1 then
      acc := lineageDirect env c acc
  return acc

partial def lineageReaches (env : Environment) (target : Name) : Name → StateM NameSet Bool
  | n => do
    if n == target then return true
    if (← get).contains n then return false
    modify (·.insert n)
    let some ci := env.find? n | return false
    let some v := ci.value? (allowOpaque := true) | return false
    for c in v.getUsedConstants do
      if ← lineageReaches env target c then return true
    return false

def lineageInduction (n c : Name) : Bool :=
  let s := c.toString
  c == n || s.endsWith ".brecOn" || s.endsWith ".below" || s.endsWith ".rec" || s.endsWith ".binductionOn"
    || s == "WellFounded.fix" || s.endsWith "._unary" || s.endsWith ".recOn"

elab "#lineage_deps " n:ident laws:ident* : command => do
  let env ← getEnv
  let some _ := env.find? n.getId | do IO.println s!"DECL {n.getId} MISSING"; return
  let ind := (lineageDirect env n.getId).toList.filter (lineageInduction n.getId) |>.map toString
  IO.println s!"DECL {n.getId} INDUCTION {ind}"
  for l in laws do
    let (r, _) := (lineageReaches env l.getId n.getId).run {}
    IO.println s!"REACH {n.getId} {l.getId} {r}"
'''


build = Path(sys.argv[1]).resolve()
lines = [HEAD]
for n, laws in {**DERIVED, **FOLLOW}.items():
    lines.append(f'#lineage_deps {n} {" ".join(laws)}')
for n in KEPT:
    lines.append(f'#lineage_deps {n}')
lean = Path.home() / '.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean'
with tempfile.TemporaryDirectory(prefix='lineage-deps-') as tmp:
    src = Path(tmp) / 'LineageDeps.lean'
    src.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    out = subprocess.run([str(lean), str(src)], capture_output=True, text=True,
                         env={**os.environ, 'LEAN_PATH': str(build)})
if out.returncode != 0:
    sys.exit(out.stdout + out.stderr)
induction, reach = {}, {}
for line in out.stdout.splitlines():
    if line.startswith('DECL '):
        parts = line.split(' ', 3)
        induction[parts[1]] = parts[3] if parts[2] == 'INDUCTION' else 'MISSING'
    elif line.startswith('REACH '):
        _, n, law, value = line.split(' ')
        reach[(n, law)] = value == 'true'
bad = []
for n, laws in {**DERIVED, **FOLLOW}.items():
    missing = [law for law in laws if not reach.get((n, law))]
    print(n, '| induction marks:', induction[n], '| reaches', 'all named laws' if not missing else f'NOT {missing}')
    if missing or (n in DERIVED and induction[n] != '[]'):
        bad.append(n)
for n in KEPT:
    print(n, '| induction marks (kept):', induction[n])
print('OK' if not bad else f'UNEXPECTED: {bad}')
sys.exit(1 if bad else 0)
