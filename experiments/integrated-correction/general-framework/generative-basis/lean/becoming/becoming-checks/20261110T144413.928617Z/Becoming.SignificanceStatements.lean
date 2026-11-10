import Becoming.Relevance
import Becoming.Extension
import Becoming.GrammarScope

/-!
# The significance rows stated on the root

The central significance rows, each stated where its terms are the root's. Every statement here is a
representation, not a derivation: each is proved through its row, and nothing ethical follows from the
root. Two names recur below:
* the continuation condition, which fixes scope (whose losses count) and ranks nothing;
* C (`Comparison`), the requirement that an order rank each course above every course it extends.

The free predicate `sig` stays the general form, and no statement reading only the dynamics entails the
condition (`ReadsOnlyDynamics.not_entails`). The statements below are its instance at one reading, or
their anchors' grammar forms:
* **The condition, at the own-closure reading.** A claim's significance from a standpoint is that its formation lies
  within that standpoint's center's closure under a relation (`selfAscribed (ownClosure rel) center`).
  So read, the condition is the root's `«续无外» rel «一» center`: every formation lies on every center's
  line under the one of that relation (`ownClosure_unrestricted_iff_noOutside`, GS2). That the reading is
  the right one, held de se along that relation, is the step of invariance's question, and stays open.
* **Widening.** On a web's level paths, widening what can form is the grammar's `«广»` of what the paths
  admit (`Web.widens_iff`).

On level paths:
* row 1, the condition as living significance (`noOutside_iff_paths_livingSignificance`);
* rows 5 and 7, an extension counting every claim as `«广»`, and the order ranking by `«广»` meeting C
  for every reading of `living` (`paths_extension_iff_grammar`, `paths_comparison_grammar`): row 7
  restates row 5's extension as widening, and that courses are so ranked is supplied, not shown;
* row 8, widening as retaining and adding what lies within one's own line, where the condition holds
  (`widens_iff_retains_adds_root`);
* row 9, the three readings of one predicate (`paths_one_object_root`).

Row 10, widening as what every positive weighting ranks higher, is stated beside its anchor in
`Becoming.Weightings` (`Weighting.grammar_widens_iff_every_positive`), an interface law of amounts
assigned to what is admitted.

**The boundary on acyclic nets.** Where `rel` is acyclic, `«续无外» rel «一» center` forces every
existing center to coincide (`«续无外则同一中心»`): a necessary consequence of the condition, not a
sufficient condition for it. Rows 1, 8 and 9 hold with distinct centers too; their condition side then
fails.

A leaf: the statements are read by records and the measure, and no law below needs them.
-/

namespace Becoming
namespace SignificanceStatements

variable {F C Pos : Type}

/-- **Row 1 on the root** (`unrestricted_iff_livingSignificance` on a web's level paths, at the
own-closure reading): every formation lying on every center's line under the one of a relation
(`«续无外»`) is exactly living significance over admission, a claim's significance from a standpoint
being that its formation lies within that standpoint's center's closure. On an acyclic `rel` the
condition side forces every existing center to coincide (`«续无外则同一中心»`). -/
theorem noOutside_iff_paths_livingSignificance (W : Web F C) {rel : F → F → Prop}
    {center : Pos → F} :
    «续无外» rel «一» center ↔
      LivingSignificance W.paths (fun _ => True)
        (fun _ e => ∀ p, selfAscribed (ownClosure rel) center p e.2 e.1) :=
  ownClosure_unrestricted_iff_noOutside.symm.trans W.unrestricted_iff_paths_livingSignificance

/-- **Row 5 on the root** (`Web.paths_extension_iff_widens`): on level paths, an extension counting
every claim is the grammar's widening of what the paths admit. The anchor's grammar form; the proof is
the anchor's. -/
theorem paths_extension_iff_grammar (W : Web F C) {l l' : Nat → C → Nat} :
    Extension W.paths (fun _ => True) l' l ↔ «广» (W.admitted l) (W.admitted l') :=
  W.paths_extension_iff_widens.trans Web.widens_iff

/-- **Row 7 on the root** (`Web.paths_comparison_widens`, at its own scope): for every reading of
`living`, the order ranking by the grammar's widening of what the paths admit meets C on level paths.
The order is set to widening, so this restates row 5's extension as widening; that courses are ranked
by this relation is supplied, and not shown here. -/
theorem paths_comparison_grammar (W : Web F C) (living : F × Nat → Prop) :
    Comparison W.paths living (fun l' l => «广» (W.admitted l) (W.admitted l')) :=
  fun l' l ext => Web.widens_iff.mp (W.paths_comparison_widens living l' l ext)

/-- **Row 8 on the root** (`Web.widens_iff_retains_adds`, at the own-closure reading): where every
formation lies on every center's line under the one of a relation, the grammar's widening of what the
paths admit is retaining and adding what lies within one's own line, from any standpoint. The grammar's
closure law converts the supplied condition (through `ownClosure_unrestricted_iff_noOutside`, from
`withinClosure_iff_reached`); the reduction is the row's, not a new law of closure. On an acyclic `rel`
the hypothesis forces every existing center to coincide. -/
theorem widens_iff_retains_adds_root (W : Web F C) {rel : F → F → Prop} {center : Pos → F}
    (noOutside : «续无外» rel «一» center) (p : Pos) {l l' : Nat → C → Nat} :
    «广» (W.admitted l) (W.admitted l') ↔
      W.Retains (selfAscribed (ownClosure rel) center) p l l' ∧
        W.Adds (selfAscribed (ownClosure rel) center) p l l' :=
  Web.widens_iff.symm.trans
    (Web.widens_iff_retains_adds (ownClosure_unrestricted_iff_noOutside.mpr noOutside) p)

/-- **Row 9 on the root** (`Web.paths_one_object`, at the own-closure reading): the condition read on
the root, living significance over admission, C's extension, and retaining and adding read one
predicate, a formation's admission at a step, with widening the grammar's `«广»`. Proved through the
row, each part converted by GS2's reading of the condition and by `Web.widens_iff`. On an acyclic `rel`
the condition side forces every existing center to coincide. -/
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
  have one := W.paths_one_object (sig := selfAscribed (ownClosure rel) center)
  ⟨ownClosure_unrestricted_iff_noOutside.symm.trans one.1,
   fun l l' => (one.2.1 l l').trans Web.widens_iff,
   fun noOutside p l l' =>
    Web.widens_iff.symm.trans (one.2.2 (ownClosure_unrestricted_iff_noOutside.mpr noOutside) p l l')⟩

end SignificanceStatements
end Becoming
