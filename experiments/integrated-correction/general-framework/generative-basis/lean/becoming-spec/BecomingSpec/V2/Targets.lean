import Init

/-!
# BecomingSpec V2: View Refinement Specification (`import Init` ONLY, 0 axioms, 0 `.injEq`)

AI-written (Track S1, 2026-11-24). `View₁` exposes `(openingStock, announcements, nextStock)`;
`View₂` adds realized `bedAliveThroughout`, with `erase : View₂ → View₁` and `Pass₂` refining `Pass₁`.
-/

set_option genInjectivity false

namespace BecomingSpec.V2

abbrev Triple := Nat × Nat × Nat

structure MonthRecord where
  said : Triple
  requested : Triple

structure LakeState where
  stock : Nat
  bedAlive : Bool
  collapsed : Bool

structure LakeHistory where
  openingStock : Nat
  months : List MonthRecord

def lakeStep (st : LakeState) (req : Triple) : LakeState × Nat :=
  let total := req.1 + req.2.1 + req.2.2
  let caught := if total ≤ st.stock then req
    else (req.1 * st.stock / total, req.2.1 * st.stock / total, req.2.2 * st.stock / total)
  let left := st.stock - (caught.1 + caught.2.1 + caught.2.2)
  let collapsed' := st.collapsed || decide (left < 5)
  let bed' := st.bedAlive && decide (70 ≤ left)
  let nextStock := if collapsed' then 0 else if 2 * left ≤ 100 then 2 * left else 100
  (⟨nextStock, bed', collapsed'⟩, left)

def runLake (st : LakeState) : List MonthRecord → LakeState × Nat
  | [] => (st, st.stock)
  | m :: ms =>
    let (st', left) := lakeStep st m.requested
    match ms with | [] => (st', left) | _ :: _ => runLake st' ms

def evalHistory (h : LakeHistory) : LakeState × Nat := runLake ⟨h.openingStock, true, false⟩ h.months

structure View₁ where
  openingStock : Nat
  announcements : List Triple
  nextStock : Nat

structure View₂ where
  openingStock : Nat
  announcements : List Triple
  nextStock : Nat
  bedAliveThroughout : Bool

def erase (v : View₂) : View₁ := ⟨v.openingStock, v.announcements, v.nextStock⟩
def Pass₁ (v : View₁) : Prop := 70 ≤ v.nextStock
def Pass₂ (v : View₂) : Prop := Pass₁ (erase v) ∧ v.bedAliveThroughout = true

def q₁ (h : LakeHistory) : View₁ := ⟨h.openingStock, h.months.map MonthRecord.said, (evalHistory h).1.stock⟩
def q₂ (h : LakeHistory) : View₂ :=
  ⟨h.openingStock, h.months.map MonthRecord.said, (evalHistory h).1.stock, (evalHistory h).1.bedAlive⟩

def eraseCommutesTarget : Prop := ∀ h : LakeHistory, erase (q₂ h) = q₁ h
def pass2RefinesPass1Target : Prop := ∀ v : View₂, Pass₂ v → Pass₁ (erase v)
def v1BlindnessTarget : Prop :=
  ∀ h₀ h₁ : LakeHistory, q₁ h₀ = q₁ h₁ → Pass₂ (q₂ h₀) → ¬ Pass₂ (q₂ h₁) →
    ∀ dec : View₁ → Bool, dec (q₁ h₀) = dec (q₁ h₁)

end BecomingSpec.V2
