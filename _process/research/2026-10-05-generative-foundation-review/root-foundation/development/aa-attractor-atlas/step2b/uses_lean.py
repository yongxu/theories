"""AA step 2b: write a Lean module that prints, for each Becoming law the binder lister read, whether its elaborated
statement uses a constant of `Becoming.RuleCapture.CarrierCounts` (the counts whose field `other_pos` holds others
present), and whether the bodies of the Becoming definitions the statement names do (one definition deeper): one line
`AAUSE <law> <in the statement> <one definition deeper>` per law, or `AAUSE <law> MISSING`. It reuses the imports and the law list of binders_lean.py's module.
Usage: uses_lean.py TREE  (TREE/.build/Becoming/AABinders.lean written and its imports built, as for binders_lean.py)"""
import json, re, sys
from pathlib import Path
T = Path(sys.argv[1])
src = (T / '.build/Becoming/AABinders.lean').read_text(encoding='utf-8').split('\n')
head = [l for l in src if not l.startswith('#eval')]
plan = json.load(open(T / 'plan.json'))
def quote(n):
    return '`' + '.'.join(c if c.startswith('«') or re.fullmatch(r"[A-Za-z_][A-Za-z0-9_']*", c) else '«' + c + '»' for c in n.split('.'))
body = '''
def aaUses (n : Name) : MetaM String := do
  let env ← getEnv
  match env.find? n with
  | none => return (toString n) ++ " MISSING"
  | some ci =>
    let cs := ci.type.getUsedConstants
    let on := fun (c : Name) => (`Becoming.RuleCapture.CarrierCounts).isPrefixOf c
    -- one definition deeper: the constants of the bodies of the Becoming definitions the statement names
    let deeper := cs.foldl (fun acc c => match env.find? c with
      | some (.defnInfo d) => if (`Becoming).isPrefixOf c then acc ++ d.value.getUsedConstants else acc
      | _ => acc) #[]
    return (toString n) ++ " " ++ toString (cs.any on) ++ " " ++ toString (deeper.any on)
'''
evals = [f'#eval show MetaM Unit from do IO.println ("AAUSE " ++ (← aaUses {quote(l)}))' for l in plan['core']]
(T / '.build/Becoming/AAUses.lean').write_text('\n'.join(head) + '\n' + body + '\n' + '\n'.join(evals) + '\n', encoding='utf-8')
print('written', len(evals))
