import Becoming.Identity
import Becoming.MapInstances
import Lean

/-! Reviewer's check, not for landing: for each re-proved lineage law, the bridge and its helpers,
the constants its proof uses directly (with the compiler's matchers unfolded, since a matcher is
case analysis inside the proof), split into grammar laws («…»), web declarations, and the marks
of an induction of its own (`brecOn`, `below`, `rec`, `WellFounded.fix`, a `_unary` helper, or
the theorem's own name); and whether its proof reaches each named grammar law transitively. Run
against main's build and the tree's. -/

open Lean Meta Elab Command

partial def reviewDirect (env : Environment) (n : Name) (seen : NameSet := {}) : NameSet := Id.run do
  let some ci := env.find? n | return seen
  let some v := ci.value? (allowOpaque := true) | return seen
  let mut acc := seen
  for c in v.getUsedConstants do
    if acc.contains c then continue
    acc := acc.insert c
    -- unfold the compiler's matchers and proof auxiliaries of this declaration only
    if (c.getPrefix == n) && (c.toString.splitOn "match_").length > 1 then
      acc := reviewDirect env c acc
  return acc

partial def reviewReaches (env : Environment) (target : Name) : Name → StateM NameSet Bool
  | n => do
    if n == target then return true
    if (← get).contains n then return false
    modify (·.insert n)
    let some ci := env.find? n | return false
    let some v := ci.value? (allowOpaque := true) | return false
    for c in v.getUsedConstants do
      if ← reviewReaches env target c then return true
    return false

def reviewInduction (n c : Name) : Bool :=
  let s := c.toString
  c == n || s.endsWith ".brecOn" || s.endsWith ".below" || s.endsWith ".rec" || s.endsWith ".binductionOn"
    || s == "WellFounded.fix" || s.endsWith "._unary" || s.endsWith ".recOn"

elab "#review_deps " n:ident laws:ident* : command => do
  let env ← getEnv
  let some _ := env.find? n.getId | do IO.println s!"{n.getId}: not in this build"; return
  let direct := (reviewDirect env n.getId).toList.map toString |>.toArray.qsort (· < ·)
  let grammar := direct.filter (fun s => (s.splitOn "«").length > 1)
  let web := direct.filter (fun s => s.startsWith "Becoming.Web." && (s.splitOn "match_").length == 1)
  let ind := (reviewDirect env n.getId).toList.filter (reviewInduction n.getId) |>.map toString
  IO.println s!"{n.getId}"
  IO.println s!"  grammar, direct: {grammar.toList}"
  IO.println s!"  web, direct: {web.toList}"
  IO.println s!"  own induction marks: {ind}"
  for l in laws do
    let (r, _) := (reviewReaches env l.getId n.getId).run {}
    IO.println s!"  reaches {l.getId}: {r}"

#review_deps Becoming.Web.Lineage.unique Becoming.«迭之定» Becoming.«迭之定于»
#review_deps Becoming.Web.Lineage.origin Becoming.«迭之定前» Becoming.«历之定前»
#review_deps Becoming.Web.Lineage.split Becoming.«迭之分» Becoming.«历之接»
#review_deps Becoming.Web.Lineage.through Becoming.«迭之分» Becoming.Web.Lineage.split
#review_deps Becoming.Web.Lineage.onward Becoming.«或有后则或迭»
#review_deps Becoming.Web.Lineage.back Becoming.«或有后则或迭» Becoming.«迭之逆» Becoming.Web.steps_advance
#review_deps Becoming.Web.Lineage.ends Becoming.«迭之定» Becoming.«迭之分»
#review_deps Becoming.Web.lineages_apart Becoming.«迭之定前» Becoming.«迭之分»
#review_deps Becoming.Web.steps_iff_lineage Becoming.«迭之末步» Becoming.«历之末步»
#review_deps Becoming.Web.steps_start_active
#review_deps Becoming.Web.lineage_of_steps
#review_deps Becoming.Web.steps_advance
#review_deps Becoming.Web.reaches_onward Becoming.«不穷则迭»
#review_deps Becoming.Web.not_not_arisingFrom_covered Becoming.«或有后则或迭» Becoming.«迭之定» Becoming.«迭之分»
#review_deps Becoming.Web.arisingFrom_not_stopping_covered Becoming.«或有后则或迭» Becoming.«迭之定»
#review_deps Becoming.Web.ceasingFrom_not_stopping_covered Becoming.«或有后则或迭» Becoming.«迭之定前» Becoming.«迭之分»
#review_deps Becoming.Web.Lineage.cons
#review_deps Becoming.Web.Lineage.line Becoming.«迭则及» Becoming.«及之单调»
#review_deps Becoming.Web.line_lineage Becoming.«闭之及» Becoming.«及即迭»
#review_deps Becoming.Web.lineage_iff_line Becoming.«迭则及» Becoming.«闭之及» Becoming.«及即迭»
#review_deps Becoming.Web.Lineage.active
