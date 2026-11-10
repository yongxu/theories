"""AA six-family pass: a Lean module that prints, for every Becoming declaration the atlas lists (all eight families),
its kind, every binder of its statement whose type is a proposition (as step2b/binders_lean.py does), the head constant
of its proof after the leading lambdas (the law it is a direct application of, if any), and the Becoming theorems its
proof uses. Also writes a stub module importing the same modules, to build their closure with scratch_build.py.
Usage: lister.py WORKTREE TREE"""
import json, re, sys
from pathlib import Path

W, T = Path(sys.argv[1]), Path(sys.argv[2])
LB = W / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
D = json.loads((W / 'theories/becoming/results/atlas/entries/dynamics.json').read_text(encoding='utf-8'))
names = []
for e in D:
    for n in e.get('declarations', []):
        if n not in names:
            names.append(n)
core = [n for n in names if n.startswith('Becoming.')]
files = {p: p.read_text(encoding='utf-8') for p in (LB / 'Becoming').glob('*.lean')}
mods, unfound, found = set(), [], []
DECL = re.compile(r'^\s*(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+|noncomputable\s+)*(?:theorem|lemma|def|abbrev|structure|class|inductive|instance)\s+'
                  r'((?:[\w.\'«»]*\.)?([\w\'«»]+))(?=[\s:({\[⦃]|$)', re.M)
where = {}
for p, t in files.items():
    for m in DECL.finditer(t):
        where.setdefault(m.group(2), set()).add(p)
for n in core:
    hit = where.get(n.rsplit('.', 1)[1])
    if hit:
        mods.update('Becoming.' + p.stem for p in hit); found.append(n)
    else:
        unfound.append(n)
def quote(n):
    return '`' + '.'.join(c if c.startswith('«') or re.fullmatch(r"[A-Za-z_][A-Za-z0-9_']*", c) else '«' + c + '»' for c in n.split('.'))
head = ['import Lean\n' + '\n'.join(f'import {m}' for m in sorted(mods)), '', 'open Lean Meta', '']
fn = r'''partial def aaStrip : Expr → Expr
  | .lam _ _ b _ => aaStrip b
  | .mdata _ e => aaStrip e
  | e => e

def aaRow (n : Name) : MetaM String := do
  let env ← getEnv
  match env.find? n with
  | none => return "{\"law\": " ++ (toString n).quote ++ ", \"missing\": true}"
  | some ci =>
    let kind := match ci with
      | .thmInfo _ => "theorem" | .defnInfo _ => "def" | .inductInfo _ => "inductive" | .ctorInfo _ => "ctor"
      | .axiomInfo _ => "axiom" | .opaqueInfo _ => "opaque" | .recInfo _ => "recursor" | _ => "other"
    let val : Option Expr := match ci with
      | .thmInfo t => some t.value | _ => none
    let hd := match val with
      | some v => match (aaStrip v).getAppFn.constName? with | some c => (toString c).quote | none => "null"
      | none => "null"
    let uses := match val with
      | some v => v.getUsedConstants.filter (fun c => (`Becoming).isPrefixOf c && match env.find? c with
          | some (.thmInfo _) => c != n | _ => false)
      | none => #[]
    forallTelescope ci.type fun xs _ => do
      let mut parts : Array String := #[]
      let mut i := 0
      for x in xs do
        i := i + 1
        let t ← inferType x
        if ← isProp t then
          let d ← x.fvarId!.getDecl
          let s := toString (← ppExpr t)
          let bi := match d.binderInfo with
            | .default => "explicit" | .implicit => "implicit" | .strictImplicit => "strict" | .instImplicit => "instance"
          parts := parts.push ("{\"name\": " ++ (toString d.userName).quote ++ ", \"position\": " ++ toString i
            ++ ", \"info\": " ++ bi.quote ++ ", \"type\": " ++ s.quote ++ "}")
      return "{\"law\": " ++ (toString n).quote ++ ", \"kind\": " ++ kind.quote ++ ", \"arity\": " ++ toString xs.size
        ++ ", \"head\": " ++ hd ++ ", \"uses\": [" ++ ", ".intercalate (uses.toList.map (fun c => (toString c).quote))
        ++ "], \"binders\": [" ++ ", ".intercalate parts.toList ++ "]}"
'''
evals = [f'#eval show MetaM Unit from do IO.println ("AAROW " ++ (← aaRow {quote(n)}))' for n in found]
(T / 'Becoming').mkdir(parents=True, exist_ok=True)
(T / 'AASix.lean.keep').write_text('\n'.join(head) + '\n' + fn + '\n' + '\n'.join(evals) + '\n', encoding='utf-8')
(T / 'Becoming' / 'AASixStub.lean').write_text('\n'.join(f'import {m}' for m in sorted(mods)) + '\n', encoding='utf-8')
json.dump({'names': names, 'core': found, 'unfound': unfound, 'modules': sorted(mods)}, open(T / 'plan.json', 'w'), indent=1)
print('declarations', len(names), 'core found', len(found), 'modules', len(mods), 'unfound core', len(unfound), unfound[:8])
