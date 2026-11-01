p='experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/KeepingWidening.lean'
s=open(p).read()
kind=open('/private/tmp/claude-501/-Users-ren-theories/6e883b66-baef-49e6-bd45-0e63629106ab/scratchpad/el6/kind_witness.lean').read()
def rep(a,b,n=1):
    global s
    assert s.count(a)==n,(s.count(a),a[:90])
    s=s.replace(a,b)
rep("""theorem kindClass_within {V : Web F C} {Q : F → F → Prop} :
    ∀ x y, V.kindClass Q x y → V.activityClass x y :=
  fun _ _ alike => alike.1
""","""theorem kindClass_within {V : Web F C} {Q : F → F → Prop} :
    ∀ x y, V.kindClass Q x y → V.activityClass x y :=
  fun _ _ alike => alike.1

/-- **Degeneration at the kind grain**: for every kind relation `Q` and every continuation, the
lineage continuation `Web.withinKind W Q passes` included, a line from an active occurrence along
which nothing reached at a step is active ends on every branch under the kind class. The kind
instance of `Web.every_branch_ends_of_gone`. -/
theorem kind_every_branch_ends_of_gone {R : Nat → F → F → Prop} {Q : F → F → Prop}
    {x : Nat × F} {N : Nat} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) (W.kindClass Q) x y → y.1 = N →
      ¬ W.active y.1 y.2) :
    «退化» (continuationStep R) (W.kindClass Q) x :=
  every_branch_ends_of_gone kindClass_within start le gone
""")
rep("""end Fed

end KindRelay

end Becoming""","""end Fed

end KindRelay

/-! ### Degeneration at the kind grain, witnessed -/

namespace Map.Undecided

"""+kind.rstrip('\n')+"""

end Map.Undecided

end Becoming""")
rep("""  a renewal one grain up. The grains one formation, kind and activity read the map's orders
  (`Web.kindGrains`).
""","""  a renewal one grain up. The grains one formation, kind and activity read the map's orders
  (`Web.kindGrains`).
* **Degeneration at the kind grain.** Wherever a uniform horizon is known, one step at which
  nothing the line reaches under the kind class is active, a line from an active occurrence ends on
  every branch under the kind class (`«退化»`, `Web.kind_every_branch_ends_of_gone`), for every kind
  relation and every continuation, the lineage continuation included: the kind instance of
  `Becoming.MapInstances`' law (`Web.every_branch_ends_of_gone`), and the other side of the kind
  grain's generation laws. The horizon is a modelling choice. `Map.Undecided.kind_degenerates`
  meets its premise at every kind relation, on `Becoming.MapInstances`' witness `Map.Undecided`.
""")
open(p,'w').write(s)
print('ok')
