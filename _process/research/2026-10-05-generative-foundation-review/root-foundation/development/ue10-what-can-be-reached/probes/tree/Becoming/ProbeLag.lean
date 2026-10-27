import Becoming.ProbeWitnesses
import Becoming.ComparingCourses

/-!
# UE10 review probes, part 5: covering with a lag

Probes of the draft `Becoming.ReachableRanges` (review REVIEW-UE10.md). Covering compares courses at
the same offsets, so it never ranks a configuration above one admitting more now (probe B12).
Covering with a lag (probe B10's `CoversLater`), joined to widening what can be reached by UE9's
order lemma (`strictJoin_trans`, in the UE9 kit's `Becoming.ComparingCourses`), is a strict partial
order containing widening what can be reached, never reversing it, and it decides `Silent`'s pair
for the climb. A proposal for the fix round, not a result; `strictJoin_trans` is stated at `Type`,
so the probe is.
-/

namespace Becoming

namespace ProbeUE10

open Generative Web

section Lag

variable {S : Type} {A : Type} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- Covering is covering with lag `0`. -/
theorem coversLater_zero {s s' : S} (covers : Reaching.Covers P adm s s') :
    CoversLater P adm 0 s s' :=
  fun r' start' => match covers r' start' with
    | ⟨r, start, includes⟩ => ⟨r, start, fun t x admitted => includes t x admitted⟩

/-- Lags add along covering with a lag. -/
theorem CoversLater.trans {d e : Nat} {s s' s'' : S} (first : CoversLater P adm d s s')
    (second : CoversLater P adm e s' s'') : CoversLater P adm (e + d) s s'' :=
  fun r'' start'' => match second r'' start'' with
    | ⟨r', start', later'⟩ => match first r' start' with
      | ⟨r, start, later⟩ => ⟨r, start, fun t x admitted =>
          Eq.subst (motive := fun m => adm (r.state m) x) (Nat.add_assoc t e d)
            (later (t + e) x (later' t x admitted))⟩

/-- Widening what can be reached, or covering with some lag and not covered back at any lag. -/
def WidensOrLater (P : Process S A) (adm : S → X → Prop) (s s' : S) : Prop :=
  Reaching.Widens P adm s s' ∨
    ((∃ d, CoversLater P adm d s s') ∧ ¬ ∃ d, CoversLater P adm d s' s)

theorem WidensOrLater.irrefl (s : S) : ¬ WidensOrLater P adm s s :=
  strictJoin_irrefl (S := Reaching.Widens P adm) (P := fun a b => ∃ d, CoversLater P adm d a b)
    (Reaching.Widens.irrefl s)

/-- **Probe L1.** The join is transitive, by UE9's order lemma. -/
theorem WidensOrLater.trans {s s' s'' : S} :
    WidensOrLater P adm s s' → WidensOrLater P adm s' s'' → WidensOrLater P adm s s'' :=
  strictJoin_trans (S := Reaching.Widens P adm) (P := fun a b => ∃ d, CoversLater P adm d a b)
    Reaching.Widens.trans (fun ⟨d, first⟩ ⟨e, second⟩ => ⟨e + d, first.trans second⟩)
    (fun widens => ⟨0, coversLater_zero widens.1⟩)

/-- **Probe L1.** The join never reverses widening what can be reached. -/
theorem WidensOrLater.not_reversed {s s' : S} (widens : Reaching.Widens P adm s s') :
    ¬ WidensOrLater P adm s' s
  | .inl back => widens_not_covered widens back.1
  | .inr ⟨_, notBack⟩ => notBack ⟨0, coversLater_zero widens.1⟩

end Lag

/-- **Probe L1.** The join ranks the climb above `none`, which admits now what the climb does not:
`Silent`'s pair, on which widening what can be reached and the lexical order are silent. -/
theorem silent_decided :
    WidensOrLater Silent.process Silent.adm (some 0) none ∧
      ¬ WidensOrLater Silent.process Silent.adm none (some 0) :=
  ⟨.inr ⟨⟨1, Silent.lag_decides.1⟩, Silent.lag_decides.2⟩,
   fun | .inl widens => Silent.silent.2.2.2.2.1 widens
       | .inr ⟨_, notBack⟩ => notBack ⟨1, Silent.lag_decides.1⟩⟩

end ProbeUE10

end Becoming
