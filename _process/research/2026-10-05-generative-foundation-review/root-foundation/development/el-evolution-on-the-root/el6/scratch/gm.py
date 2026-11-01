p='experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarMap.lean'
s=open(p).read()
def rep(a,b,n=1):
    global s
    assert s.count(a)==n,(s.count(a),a[:80])
    s=s.replace(a,b)
# header: inhabited forms + rename
rep("""inhabited (`Map.Endless.generation`, `Map.Still.keeping`, `Map.Short.degeneration`; the last states
only an end, 有终, and that the same point degenerates is `Map.Short.ends`), and with excluded""",
"""inhabited (`Map.Endless.generation`, `Map.Still.keeping`, `Map.Short.reaches_end`; the last states
only an end, 有终, and that the same point degenerates is `Map.Short.ends`), and with excluded""")
# header: add paragraph on 尽 and 有终 after the excluded-middle sentence
rep("""(`«全三域之定当且仅当排中»`): the boundary between them is where a line's going on is not decided.
""","""(`«全三域之定当且仅当排中»`): the boundary between them is where a line's going on is not decided.

Ending on every branch and reaching an end. What ends on every branch reaches an end up to double
negation (`«尽则非无终»`), and reaches one where going on is decided at the points of its line
(`«尽而续可定则有终»`). The decision cannot be dropped: on the short life's two points, with its one
step taken exactly where a proposition `P` holds (`Map.StepWhere`), the line from `false` ends on
every branch while an end decides `P`, so that every line ending on every branch reaches an end is
exactly excluded middle (`«尽则有终当且仅当排中»`). The two calibrations above ask which region a
point lies in; this one knows the region, every branch ending, and asks where an end lies.
""")
# section doc: the relation of 有终 to 退化 is now stated here
rep("""which `«守»` forbids (`Map.Once.keeping`, `Map.Once.not_keeps`); how `«有终»` stands to `«退化»` is not
stated. -/""","""which `«守»` forbids (`Map.Once.keeping`, `Map.Once.not_keeps`). How `«有终»` stands to `«退化»` is
stated here: `«尽»` gives `«有终»` up to double negation (`«尽则非无终»`) and where going on is
decided (`«尽而续可定则有终»`), and with no decision exactly under excluded middle
(`«尽则有终当且仅当排中»`). -/""")
# the two laws beside 尽则非不穷
rep("""theorem «尽则非不穷» {R L : «际» α} {x : α} (h : «尽» R L x) : ¬ «不穷» R L x :=
  fun n => «延尽不并» h («不穷则延» n)
""","""theorem «尽则非不穷» {R L : «际» α} {x : α} (h : «尽» R L x) : ¬ «不穷» R L x :=
  fun n => «延尽不并» h («不穷则延» n)

/-- **Ending on every branch reaches an end, up to double negation.** -/
theorem «尽则非无终» {R L : «际» α} {x : α} (h : «尽» R L x) : ¬ ¬ «有终» R L x := by
  induction h with
  | mk _ ih =>
    intro none
    exact none ⟨_, .inl rfl, fun ⟨y, c⟩ =>
      ih y c fun ⟨w, hw, ends⟩ => none ⟨w, «所及之传递» (.inr (.one c)) hw, ends⟩⟩

/-- **Ending on every branch reaches an end where going on is decided** at the points of the
line. -/
theorem «尽而续可定则有终» {R L : «际» α} {x : α} (h : «尽» R L x) :
    (∀ y, «所及» R L x y → «有后» R L y ∨ ¬ «有后» R L y) → «有终» R L x := by
  induction h with
  | mk _ ih =>
    intro decided
    exact match decided _ (.inl rfl) with
      | .inr ends => ⟨_, .inl rfl, ends⟩
      | .inl ⟨y, c⟩ =>
        match ih y c (fun z hz => decided z («所及之传递» (.inr (.one c)) hz)) with
        | ⟨w, hw, ends⟩ => ⟨w, «所及之传递» (.inr (.one c)) hw, ends⟩
""")
# rename Short.degeneration
rep("""/-- An end is inhabited: the short life reaches an end (有终). The name is older than the distinction;
that the same point degenerates is `Map.Short.ends`. -/
theorem Short.degeneration : «有终» short «一» false :=""","""/-- An end is inhabited: the short life reaches an end (有终); that the same point degenerates is
`Map.Short.ends`. -/
theorem Short.reaches_end : «有终» short «一» false :=""")
rep("""  refine ⟨Short.degeneration, false, true, .inl rfl, ⟨⟨rfl, rfl⟩, trivial⟩, ?_⟩""",
    """  refine ⟨Short.reaches_end, false, true, .inl rfl, ⟨⟨rfl, rfl⟩, trivial⟩, ?_⟩""")
# StepWhere after Short.renews_and_ends_everywhere
rep("""theorem Short.renews_and_ends_everywhere : «新而尽» short «一» «静» false :=
  ⟨Short.ends, false, true, .inl rfl, ⟨⟨rfl, rfl⟩, trivial⟩, fun ⟨z, hz, e⟩ => by
    cases e; exact Bool.noConfusion hz.1⟩
""","""theorem Short.renews_and_ends_everywhere : «新而尽» short «一» «静» false :=
  ⟨Short.ends, false, true, .inl rfl, ⟨⟨rfl, rfl⟩, trivial⟩, fun ⟨z, hz, e⟩ => by
    cases e; exact Bool.noConfusion hz.1⟩

/-! ### Reaching an end needs the decision -/

namespace StepWhere

/-- The short life gated by `P`: its one step, from `false` to `true`, taken exactly where `P`
holds. -/
def relation (P : Prop) : «际» Bool := fun x y => short x y ∧ P

/-- Witness lemma: under the one (`«一»`), the line from `false` ends on every branch, at every
proposition: a step from `false` reaches `true`, and nothing steps from `true`. -/
theorem ends (P : Prop) : «尽» (relation P) «一» false :=
  .mk fun _ c => .mk fun _ c' => Bool.noConfusion (c.1.1.2.symm.trans c'.1.1.1)

/-- Witness lemma: `false` has a continuation exactly where `P` holds. -/
theorem has_next_iff (P : Prop) : «有后» (relation P) «一» false ↔ P :=
  ⟨fun ⟨_, c⟩ => c.1.2, fun p => ⟨true, ⟨⟨rfl, rfl⟩, p⟩, trivial⟩⟩

/-- Witness lemma: **reaching an end from `false` decides `P`.** -/
theorem end_decides {P : Prop} (h : «有终» (relation P) «一» false) : P ∨ ¬ P :=
  match h with
  | ⟨_, .inl same, ends⟩ =>
    .inr fun p => ends (Eq.subst (motive := fun z => «有后» (relation P) «一» z) same
      ((has_next_iff P).mpr p))
  | ⟨_, .inr (.one c), _⟩ => .inl c.1.2
  | ⟨_, .inr (.more c _), _⟩ => .inl c.1.2

end StepWhere
""")
# calibration at top level, after the witnesses
rep("""    | .still, .still, _, _ => exact hb ⟨.still, trivial, rfl⟩

end Map

end Becoming""","""    | .still, .still, _, _ => exact hb ⟨.still, trivial, rfl⟩

end Map

/-! ## Ending on every branch and reaching an end -/

/-- **That every line ending on every branch reaches an end is exactly excluded middle**, at every
carrier and relation. The forward direction is witnessed by `Map.StepWhere` alone: what is
undecided is not whether a course goes on without end, since every branch ends, but whether its
one step is taken. -/
theorem «尽则有终当且仅当排中» :
    (∀ (β : Type) (R L : «际» β) (x : β), «尽» R L x → «有终» R L x) ↔ ∀ P : Prop, P ∨ ¬ P :=
  ⟨fun h P => Map.StepWhere.end_decides (h _ _ _ _ (Map.StepWhere.ends P)),
   fun em _ _ _ _ ends => «尽而续可定则有终» ends fun _ _ => em _⟩

end Becoming""")
open(p,'w').write(s)
print("ok")
