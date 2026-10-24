"""The fidelity count (FC1; FIDELITY.md §2, §6): the Lean statement L(d) of each declaration.

Writes a periphery driver (it imports Lean, which the core may not) into a scratch TREE outside the repository, builds
its import closure with the package's scratch_build.py (the checker's Lean and shared step cache; nothing is written to
the repository), then runs the driver once with Lean and parses its `FIDELITY {json}` lines: for each declaration, its
binders (name, type, binder info, whether a Prop), its conclusion, the ∀/∃ nested in the conclusion through ↔, ∧, ∨
and ¬, the Becoming and Generative constants of its type, and one level of unfolding (U1): a definition's binders and
body, a structure's fields. Long pretty-printed bodies are cut at CUT characters and marked.

    python3 -I fidelity/lean_dump.py TREE     # needs data/decls.txt; writes data/lean_dump.jsonl
"""
import json, os, re, subprocess, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[6]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CHUNK = 150

DRIVER = r'''import Lean
import Becoming
open Lean Meta Elab Command

set_option pp.fullNames true
set_option pp.proofs false
set_option maxHeartbeats 0
set_option maxRecDepth 4096

def cut (s : String) : String := if s.length > 1500 then String.ofList (s.toList.take 1500) ++ " …[cut]" else s

def pp (e : Expr) : MetaM String := do return cut (toString (← ppExpr e))

partial def nested (e : Expr) (acc : Array Json) (depth : Nat) : MetaM (Array Json) := do
  if depth > 16 then return acc
  match e with
  | .forallE n t b bi => withLocalDecl n bi t fun x => do
      nested (b.instantiate1 x) (acc.push (Json.mkObj [("q", "∀"), ("name", toJson n.toString),
        ("type", toJson (← pp t))])) (depth + 1)
  | _ =>
    if e.isAppOfArity ``Exists 2 then
      match e.appArg! with
      | .lam n t b bi => withLocalDecl n bi t fun x => do
          nested (b.instantiate1 x) (acc.push (Json.mkObj [("q", "∃"), ("name", toJson n.toString),
            ("type", toJson (← pp t))])) (depth + 1)
      | _ => pure acc
    else if e.isAppOfArity ``Iff 2 || e.isAppOfArity ``And 2 || e.isAppOfArity ``Or 2 then do
      nested (e.getArg! 1) (← nested (e.getArg! 0) acc (depth + 1)) (depth + 1)
    else if e.isAppOfArity ``Not 1 then nested e.appArg! acc (depth + 1)
    else pure acc

def binders (xs : Array Expr) : MetaM (Array Json) := xs.mapM fun x => do
  let d ← x.fvarId!.getDecl
  return Json.mkObj [("name", toJson d.userName.toString), ("type", toJson (← pp d.type)),
    ("info", toJson (toString (repr d.binderInfo))), ("prop", toJson (← isProp d.type))]

def ours (c : Name) : Bool := (`Becoming).isPrefixOf c || (`Generative).isPrefixOf c

def unfoldOne (c : Name) : MetaM (Option Json) := do
  let env ← getEnv
  match (← getConstInfo c) with
  | .defnInfo v => lambdaTelescope v.value fun ys b => do
      return some (Json.mkObj [("const", toJson c.toString), ("kind", "def"), ("binders", toJson (← binders ys)),
        ("body", toJson (← pp b))])
  | .inductInfo _ =>
      if isStructure env c then
        let fs := getStructureFields env c
        let tys ← fs.mapM fun f => do
          let t ← (try (do let i ← getConstInfo (c ++ f); pp i.type) catch _ => pure "")
          return Json.mkObj [("field", toJson f.toString), ("type", toJson t)]
        return some (Json.mkObj [("const", toJson c.toString), ("kind", "structure"), ("fields", toJson tys)])
      else
        return some (Json.mkObj [("const", toJson c.toString), ("kind", "inductive")])
  | _ => return none

def dumpOne (n : Name) : MetaM Json := do
  let ci ← getConstInfo n
  let kind := match ci with
    | .thmInfo _ => "theorem" | .defnInfo _ => "def" | .inductInfo _ => "inductive"
    | .axiomInfo _ => "axiom" | .opaqueInfo _ => "opaque" | .ctorInfo _ => "constructor"
    | .recInfo _ => "recursor" | .quotInfo _ => "quot"
  let cs := (ci.type.getUsedConstants.filter ours).filter (· != n)
  forallTelescope ci.type fun xs body => do
    let unfold ← cs.filterMapM fun c => (try unfoldOne c catch _ => pure none)
    let own ← match ci with
      | .defnInfo _ => (try unfoldOne n catch _ => pure none)
      | .inductInfo _ => (try unfoldOne n catch _ => pure none)
      | _ => pure none
    return Json.mkObj [("decl", toJson n.toString), ("kind", toJson kind), ("binders", toJson (← binders xs)),
      ("conclusion", toJson (← pp body)), ("nested", toJson (← nested body #[] 0)),
      ("consts", toJson (cs.map toString)), ("unfold1", toJson unfold), ("self", toJson own)]

elab "#fidelity_dump " ss:str* : command => do
  for s in ss do
    let n := s.getString.toName
    try
      let j ← liftTermElabM (dumpOne n)
      logInfo m!"FIDELITY {j.compress}"
    catch e =>
      logInfo m!"FIDELITYERR {n} {e.toMessageData}"
'''


def main():
    tree = Path(sys.argv[1]).resolve()
    tree.mkdir(parents=True, exist_ok=True)
    names = [n for n in (HERE / 'data/decls.txt').read_text().split('\n') if n.strip()]
    body = [DRIVER]
    for i in range(0, len(names), CHUNK):
        body.append('#fidelity_dump ' + ' '.join(json.dumps(n) for n in names[i:i + CHUNK]))
    # scratch_build resolves imports within the package only, so it builds the closure of `Becoming` (an empty
    # TREE: every module from this checkout, restored from the shared cache); the driver, which imports Lean as
    # well, is then run against that build with the same Lean
    for stale in tree.glob('*.lean'):
        stale.unlink()
    build = subprocess.run([sys.executable, '-B', str(PKG / 'scratch_build.py'), str(tree), 'Becoming'],
                           cwd=PKG, text=True, capture_output=True)
    (tree / '.build').mkdir(exist_ok=True)
    (tree / '.build' / 'FidelityDump.lean').write_text('\n'.join(body) + '\n')
    (tree / 'scratch_build.out').write_text(build.stdout + '\n' + build.stderr)
    if build.returncode != 0:
        print(build.stdout[-3000:], build.stderr[-3000:])
        sys.exit(1)
    sys.path.insert(0, str(PKG))
    import check_becoming as cb
    command, _, _ = cb.resolve_lean()
    run = subprocess.run(command + ['FidelityDump.lean'], cwd=tree / '.build', text=True, capture_output=True,
                         env={**os.environ, 'LEAN_PATH': str(tree / '.build')})
    (tree / 'dump.log').write_text(run.stdout + run.stderr)
    out, errs = [], []
    for m in re.finditer(r'FIDELITY (\{.*?\})\s*$', run.stdout, re.M):
        out.append(json.loads(m.group(1)))
    for m in re.finditer(r'FIDELITYERR (\S+) (.*)$', run.stdout, re.M):
        errs.append({'decl': m.group(1), 'error': m.group(2)[:300]})
    with open(HERE / 'data/lean_dump.jsonl', 'w', encoding='utf-8') as f:
        for o in out:
            f.write(json.dumps(o, ensure_ascii=False) + '\n')
    (HERE / 'data/lean_dump_errors.json').write_text(json.dumps(errs, ensure_ascii=False, indent=1))
    print(json.dumps({'names': len(names), 'dumped': len(out), 'errors': len(errs), 'lean_exit': run.returncode}))


if __name__ == '__main__':
    main()
