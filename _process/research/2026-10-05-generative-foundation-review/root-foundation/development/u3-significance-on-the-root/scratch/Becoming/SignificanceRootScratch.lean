import Becoming.Relevance
import Becoming.Extension
import Becoming.GrammarScope
import Becoming.Regions
import Becoming.Weightings
import Becoming.GrammarTransport

/-!
# Scratch for U3 (not a module of the package): the significance rows on the root

Each of the five central significance rows read on the root. Nothing ethical is derived: the
continuation condition (scope) and C (order) stay premises, named where used; the free predicate
`sig` stays the general form (SD1); the root forms below are its instance at the structural reading
(lying within a center's line under the one of a relation, GS2) or the anchors' grammar forms.
-/

namespace Becoming
namespace SignificanceRootScratch

variable {F C Pos : Type}

/-- **Row 1 on the root** (`unrestricted_iff_livingSignificance` on a web's level paths, at the
structural reading): every formation lying on every center's line under the one of a relation
(`«续无外»`) is exactly living significance over admission with each claim's significance from
every standpoint its lying within that standpoint's center's closure. Boundary: where `rel` is acyclic,
`«续无外» rel «一» center` forces every existing center to coincide (`«续无外则同一中心»`), a necessary
consequence, not a sufficient condition; the equivalence holds with distinct centers, whose condition side
then fails. -/
theorem noOutside_iff_paths_livingSignificance (W : Web F C) {rel : F → F → Prop}
    {center : Pos → F} :
    «续无外» rel «一» center ↔
      LivingSignificance W.paths (fun _ => True)
        (fun _ e => ∀ p, selfAscribed (ownClosure rel) center p e.2 e.1) :=
  ownClosure_unrestricted_iff_noOutside.symm.trans W.unrestricted_iff_paths_livingSignificance

/-- **Row 8 on the root** (`Web.widens_iff_retains_adds` at the structural reading): where every
formation lies on every center's line under the one of a relation, widening what can form, read as
the grammar's `«广»` on what the paths admit, is retaining and adding what lies within one's own
line, from every standpoint. The grammar's closure law converts the supplied condition (through
`ownClosure_unrestricted_iff_noOutside`, from `withinClosure_iff_reached`); the reduction itself is
`Web.widens_iff_retains_adds`'s, not a new law of closure. Boundary: as for row 1, on an acyclic `rel` the
hypothesis forces every existing center to coincide. -/
theorem widens_iff_retains_adds_root (W : Web F C) {rel : F → F → Prop} {center : Pos → F}
    (none : «续无外» rel «一» center) (p : Pos) {l l' : Nat → C → Nat} :
    «广» (W.admitted l) (W.admitted l') ↔
      W.Retains (selfAscribed (ownClosure rel) center) p l l' ∧
        W.Adds (selfAscribed (ownClosure rel) center) p l l' :=
  Web.widens_iff.symm.trans
    (Web.widens_iff_retains_adds (ownClosure_unrestricted_iff_noOutside.mpr none) p)

/-- **Rows 5 and 7 on the root** (`Web.paths_extension_iff_widens`): on level paths, an extension
counting every claim is the grammar's widening of what the paths admit (the anchor's grammar form;
a representation: the proof is the anchor's, the statement the grammar's). -/
theorem paths_extension_iff_grammar (W : Web F C) {l l' : Nat → C → Nat} :
    Extension W.paths (fun _ => True) l' l ↔ «广» (W.admitted l) (W.admitted l') :=
  W.paths_extension_iff_widens.trans Web.widens_iff

/-- **Row 7 on the root** (`Web.paths_comparison_widens`, at its own scope): for every reading of
`living`, C holds on level paths with "better" read as the grammar's widening of what the paths
admit. That this relation is "better" is supplied by the reading of "better", C's normative content;
nothing here shows it. -/
theorem paths_comparison_grammar (W : Web F C) (living : F × Nat → Prop) :
    Comparison W.paths living (fun l' l => «广» (W.admitted l) (W.admitted l')) :=
  fun l' l ext => Web.widens_iff.mp (W.paths_comparison_widens living l' l ext)

/-- **Row 9 on the root** (`Web.paths_one_object`, at the structural reading): the condition read on
the root, living significance over admission, C's extension and retaining and adding read one
predicate, a formation's admission at a step, with widening the grammar's `«广»`. Boundary: on an
acyclic `rel` the condition side forces every existing center to coincide, as for rows 1 and 8. -/
theorem paths_one_object_root (W : Web F C) {rel : F → F → Prop} {center : Pos → F} :
    («续无外» rel «一» center ↔
        LivingSignificance W.paths (fun _ => True)
          (fun _ e => ∀ p, selfAscribed (ownClosure rel) center p e.2 e.1)) ∧
      (∀ l l' : Nat → C → Nat,
        Extension W.paths (fun _ => True) l' l ↔ «广» (W.admitted l) (W.admitted l')) ∧
      («续无外» rel «一» center → ∀ (p : Pos) (l l' : Nat → C → Nat),
        «广» (W.admitted l) (W.admitted l') ↔
          W.Retains (selfAscribed (ownClosure rel) center) p l l' ∧
            W.Adds (selfAscribed (ownClosure rel) center) p l l') :=
  ⟨noOutside_iff_paths_livingSignificance W, fun _ _ => paths_extension_iff_grammar W,
   fun none p _ _ => widens_iff_retains_adds_root W none p⟩

/-- **Row 10 as an interface law of the second sort** (`Weighting.widens_iff_every_positive`): on a
finite list of items, with Boolean admission and additive natural-number weights strictly positive on the
listed items, the grammar's widening of what two choices admit is exactly what every such weighting
ranks higher. The left side is the root's order; the weightings are amounts assigned to what is admitted
(U1's second sort). Mixed comparisons have no unanimous ranking: some positive weighting ranks each
direction (`Weighting.mixed_either_way`). -/
theorem grammar_widens_iff_every_positive {X : Type} {items : List X} {a b : X → Bool} :
    «广» (Weighting.admittedOn items a) (Weighting.admittedOn items b) ↔
      ∀ w, Weighting.Positive items w → Weighting.weighed items w b < Weighting.weighed items w a :=
  Weighting.widensOn_iff.symm.trans Weighting.widens_iff_every_positive

universe u v

/-- **Widening kept by a one-to-one correspondence** (proposed for `Becoming.GrammarTransport`'s
owner, `«广之对应»`): where a correspondence carries `A` to `A'` and `B` to `B'`, `A` widens `B`
exactly where `A'` widens `B'`. -/
theorem guang_correspondence {α : Type u} {β : Type v} (e : «一一对应» α β) {A B : «际» α} {A' B' : «际» β}
    (hA : «谓» («像» e.to A) A') (hB : «谓» («像» e.to B) B') :
    «广» A B ↔ «广» A' B' := by
  have pa := «对应之逐点» (e := e) hA
  have pb := «对应之逐点» (e := e) hB
  have ra := «对应之回» (e := e) hA
  have rb := «对应之回» (e := e) hB
  constructor
  · intro ⟨inc, x, y, ax, nbx⟩
    refine ⟨fun u v b' => ?_, e.to x, e.to y, (pa x y).mp ax, fun b' => nbx ((pb x y).mpr b')⟩
    exact (ra u v).mpr ((rb u v).mp b' |> inc _ _)
  · intro ⟨inc, u, v, a', nbv⟩
    refine ⟨fun x y bx => (pa x y).mpr (inc _ _ ((pb x y).mp bx)), ?_⟩
    exact ⟨e.symm.to u, e.symm.to v, (ra u v).mp a', fun bx => nbv ((rb u v).mpr bx)⟩

end SignificanceRootScratch
end Becoming
