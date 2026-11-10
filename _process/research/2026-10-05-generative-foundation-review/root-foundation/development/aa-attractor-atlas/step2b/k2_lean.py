"""K2's entry: a Lean module that prints, for each declaration the three K2 records name, its kind and every binder of
its statement whose type is a proposition (as step2b/binders_lean.py does). Usage: k2_lean.py WORKTREE TREE"""
import json, re, sys
from pathlib import Path
W, T = Path(sys.argv[1]), Path(sys.argv[2])
names = []
for r in ('the-lock-draws-its-readers-out', 'a-pool-read-off-the-course', 'on-whom-the-loss-falls'):
    d = json.loads((W / f'theories/becoming/results/records/{r}.json').read_text(encoding='utf-8'))
    for law in d['laws']:
        names += [n for n in law.get('declarations', []) if n not in names]
def quote(n):
    return '`' + '.'.join(c if c.startswith('«') or re.fullmatch(r"[A-Za-z_][A-Za-z0-9_']*", c) else '«' + c + '»' for c in n.split('.'))
src = ['import Lean\nimport Becoming.PoolFromCourse', '', 'open Lean Meta', '',
'''def aaRow (n : Name) : MetaM String := do
  match (← getEnv).find? n with
  | none => return "{\\"law\\": " ++ (toString n).quote ++ ", \\"missing\\": true}"
  | some ci =>
    let kind := match ci with
      | .thmInfo _ => "theorem" | .defnInfo _ => "def" | .inductInfo _ => "inductive" | .ctorInfo _ => "ctor"
      | .axiomInfo _ => "axiom" | .opaqueInfo _ => "opaque" | _ => "other"
    forallTelescope ci.type fun xs _ => do
      let mut parts : Array String := #[]
      let mut i := 0
      for x in xs do
        i := i + 1
        let t ← inferType x
        if ← isProp t then
          let d ← x.fvarId!.getDecl
          let s := toString (← ppExpr t)
          parts := parts.push ("{\\"name\\": " ++ (toString d.userName).quote ++ ", \\"position\\": " ++ toString i
            ++ ", \\"type\\": " ++ s.quote ++ "}")
      return "{\\"law\\": " ++ (toString n).quote ++ ", \\"kind\\": " ++ kind.quote ++ ", \\"arity\\": " ++ toString xs.size
        ++ ", \\"binders\\": [" ++ ", ".intercalate parts.toList ++ "]}"
''']
src += [f'#eval show MetaM Unit from do IO.println ("AAROW " ++ (← aaRow {quote(n)}))' for n in names]
(T / 'Becoming').mkdir(parents=True, exist_ok=True)
(T / 'Becoming' / 'AAK2.lean').write_text('\n'.join(src) + '\n', encoding='utf-8')
print(len(names), 'declarations')
