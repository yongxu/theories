import json, sys
cov, old_r, new_r, W = sys.argv[1:5]
c = json.load(open(cov))
names = sorted({d for r in c['rows'] for d in r['declarations']})
print(len(names), 'distinct central declarations')
body = r'''
open Lean Elab Command
partial def closure (env : Environment) (start : Name) : NameSet := Id.run do
  let mut seen : NameSet := {}
  let mut stack : Array Name := #[start]
  while !stack.isEmpty do
    let n := stack.back!
    stack := stack.pop
    if seen.contains n then continue
    seen := seen.insert n
    if let some ci := env.find? n then
      for c in ci.type.getUsedConstants do
        if !seen.contains c then stack := stack.push c
      if let some v := ci.value? then
        for c in v.getUsedConstants do
          if !seen.contains c then stack := stack.push c
  return seen
#eval show CommandElabM Unit from do
  let env ← getEnv
  let mut out : Array String := #[]
  for s in NAMES do
    let n := s.toName
    if (env.find? n).isNone then
      out := out.push s!"{s}\tMISSING"
      continue
    let cl := closure env n
    let mut gram : Nat := 0
    let mut via : Bool := false
    for c in cl.toList do
      match env.getModuleIdxFor? c with
      | some idx =>
        let m := env.header.moduleNames[idx.toNat]!
        if m.toString.startsWith "Becoming.Grammar" then gram := gram + 1
      | none => pure ()
      if c == `Becoming.factors_image || c == `Becoming.Image.least then via := true
    out := out.push s!"{s}\t{gram}\t{via}"
  IO.FS.writeFile "OUTFILE" (String.intercalate "\n" out.toList ++ "\n")
'''
lean_names = '#[' + ', '.join(json.dumps(n, ensure_ascii=False) for n in names) + ']'
for tag, rec in (('old', old_r), ('new', new_r)):
    r = json.load(open(rec))
    src = '\n'.join('import ' + m for m in r['compile_order']) + '\nimport Lean\n' + body.replace('NAMES', lean_names).replace('OUTFILE', f'{W}/central-{tag}.tsv')
    open(f'{W}/Central{tag.capitalize()}.lean', 'w').write(src)
