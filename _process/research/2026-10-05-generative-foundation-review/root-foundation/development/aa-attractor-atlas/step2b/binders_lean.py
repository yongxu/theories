"""AA step 2b: write a Lean module that prints, for each Becoming law of families C and D, every binder of its
statement whose type is a proposition (forallTelescope over the elaborated type: the binders before the colon and the
leading hypotheses after it), as JSON lines. Usage: binders_lean.py WORKTREE TREE"""
import json, re, sys
from pathlib import Path

W, T = Path(sys.argv[1]), Path(sys.argv[2])
LB = W / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
D = json.loads((W / 'theories/becoming/results/atlas/entries/dynamics.json').read_text(encoding='utf-8'))
laws = sorted({h['law'] for e in D if e['family'] in ('C', 'D') for h in e.get('premises') or []})
core = [l for l in laws if l.startswith('Becoming.')]
files = {p: p.read_text(encoding='utf-8') for p in (LB / 'Becoming').glob('*.lean')}
mods, unfound = set(), []
for l in core:
    last = l.rsplit('.', 1)[1]
    pat = re.compile(r'^\s*(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+|noncomputable\s+)*(?:theorem|lemma|def|abbrev)\s+'
                     + r'(?:[\w.]*\.)?' + re.escape(last) + r'(?=[\s:({\[⦃])', re.M)
    hit = [p for p, t in files.items() if pat.search(t)]
    if hit:
        mods.update('Becoming.' + p.stem for p in hit)
    else:
        unfound.append(l)
def quote(n):
    return '`' + '.'.join(c if c.startswith('«') or re.fullmatch(r'[A-Za-z_][A-Za-z0-9_\']*', c) else '«' + c + '»' for c in n.split('.'))
src = ['import Lean\n' + '\n'.join(f'import {m}' for m in sorted(mods)), '', 'open Lean Meta', '',
'''def aaRow (n : Name) : MetaM String := do
  match (← getEnv).find? n with
  | none => return "{\\"law\\": " ++ (toString n).quote ++ ", \\"missing\\": true}"
  | some ci =>
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
          parts := parts.push ("{\\"name\\": " ++ (toString d.userName).quote ++ ", \\"position\\": " ++ toString i
            ++ ", \\"info\\": " ++ bi.quote ++ ", \\"type\\": " ++ s.quote ++ "}")
      return "{\\"law\\": " ++ (toString n).quote ++ ", \\"arity\\": " ++ toString xs.size ++ ", \\"binders\\": ["
        ++ ", ".intercalate parts.toList ++ "]}"
''']
src += [f'#eval show MetaM Unit from do IO.println ("AAROW " ++ (← aaRow {quote(l)}))' for l in core]
(T / 'Becoming').mkdir(parents=True, exist_ok=True)
(T / 'Becoming' / 'AABinders.lean').write_text('\n'.join(src) + '\n', encoding='utf-8')
json.dump({'laws': laws, 'core': core, 'modules': sorted(mods), 'unfound': unfound}, open(T / 'plan.json', 'w'), indent=1)
print('laws', len(laws), 'Becoming', len(core), 'modules', len(mods), 'unfound', unfound[:10])
