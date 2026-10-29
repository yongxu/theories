"""Write a Lean driver that imports every module of a receipt and dumps, for every constant of the package,
its module, kind, universe parameters, a full structural rendering of its type (names, levels, binder names
and infos) and the structural hash of its value."""
import json, sys
from pathlib import Path
r = json.loads(Path(sys.argv[1]).read_text())
out_lean, out_txt = sys.argv[2], sys.argv[3]
mods = r['compile_order']
body = r'''
open Lean Elab Command

partial def ser : Expr → String
  | .bvar i => s!"#{i}"
  | .fvar _ => "FVAR"
  | .mvar _ => "MVAR"
  | .sort l => s!"(Sort {l})"
  | .const n ls => s!"(c {n} {ls})"
  | .app f a => s!"({ser f} {ser a})"
  | .lam n t b bi => s!"(fun {n} {reprStr bi} {ser t} {ser b})"
  | .forallE n t b bi => s!"(pi {n} {reprStr bi} {ser t} {ser b})"
  | .letE n t v b _ => s!"(let {n} {ser t} {ser v} {ser b})"
  | .lit (.natVal k) => s!"{k}"
  | .lit (.strVal s) => reprStr s
  | .mdata _ e => ser e
  | .proj s i e => s!"(proj {s} {i} {ser e})"

def kindOf : ConstantInfo → String
  | .axiomInfo _ => "axiom" | .defnInfo _ => "def" | .thmInfo _ => "theorem" | .opaqueInfo _ => "opaque"
  | .quotInfo _ => "quot" | .inductInfo _ => "inductive" | .ctorInfo _ => "ctor" | .recInfo _ => "rec"

def valueHash : ConstantInfo → String
  | .defnInfo d => toString d.value.hash
  | .thmInfo t => toString t.value.hash
  | .opaqueInfo o => toString o.value.hash
  | _ => "-"

#eval show CommandElabM Unit from do
  let env ← getEnv
  let mut lines : Array String := #[]
  for (n, ci) in env.constants.toList do
    match env.getModuleIdxFor? n with
    | none => pure ()
    | some idx =>
      let m := env.header.moduleNames[idx.toNat]!
      let ms := m.toString
      if ms.startsWith "Becoming" || ms == "GenerativeCore" || ms == "InquirySufficiency" || ms == "RelationalRenewal" then
        lines := lines.push s!"{n}\t{ms}\t{kindOf ci}\t{ci.levelParams}\t{valueHash ci}\t{ser ci.type}"
  IO.FS.writeFile "OUT_TXT" (String.intercalate "\n" (lines.qsort (· < ·)).toList ++ "\n")
  logInfo m!"dumped {lines.size}"
'''.replace('OUT_TXT', out_txt)
Path(out_lean).write_text('\n'.join('import ' + m for m in mods) + '\nimport Lean\n' + body)
print(len(mods), 'imports')
