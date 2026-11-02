import Becoming.RuleRebuilding
open Becoming.RuleRebuilding
def lists : List (List Nat) := [[], [1], [2,0], [0,2], [1,1,1], [3,0,1,2]]
def srcs : List (Source × String) := [(.members,"members"),(.outside,"outside"),(.none,"none")]
def moves : List Move := [⟨true,none⟩,⟨false,none⟩,⟨true,some 0⟩,⟨true,some 2⟩,⟨false,some 2⟩]
def showL (l : List Nat) : String := toString l
def main' : IO Unit := do
  let mut out : Array String := #[]
  for s in [0,1,2,3] do for l in [0,1,3] do for g in [0,2,5] do for f in [0,1,4] do for c in [0,2] do
    for (src,n) in srcs do
      for q in [0,2] do for L in [0,1,4] do
        for hs in lists do for os in lists do
          for m in moves do
            let r : Rule := ⟨s,l,g,f,c,src⟩
            let y := step r m ⟨q,L,hs,os⟩
            out := out.push s!"{s} {l} {g} {f} {c} {n} {q} {L} {hs} {os} {m.on} {m.rev} -> {y.quota} {y.level} {y.holders} {y.others}"
  IO.FS.writeFile "lean.txt" ("\n".intercalate out.toList ++ "\n")
#eval main'
