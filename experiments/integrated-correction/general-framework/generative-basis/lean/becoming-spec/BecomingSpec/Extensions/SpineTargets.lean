import Init

/-!
# BecomingSpec Extensions: Spine-Level Stability, 3D Non-Collapse & Ethics Firewall Targets

AI-written (Wave 3, 2026-11-24). `import Init` ONLY, 0 axioms, 0 `.injEq`.
Freezes four top-level structural targets across `OpenComposition`, `DoubleKernel`,
and `MasterSpine`:
1. `hiddenCouplingCollapseTarget`: closed component stays `≥ 3` while composed fails at `t = 4`.
2. `widenHealsBlindnessTarget`: narrow interface blind crash (`= 0` at `t = 6`) vs widened healing (`≥ 3`).
3. `directed3DNonCollapseTarget`: reversible 2D equality (`EqCert`) vs irreversible directed 3-cell (`HasEndpoints3`).
4. `masterSpineEthicsFirewallTarget`: `MasterSpine` / `WholeArchitectureViableProp` never entails `Unrestricted`.
-/

set_option genInjectivity false

namespace BecomingSpec.Extensions

def specOrbit {S : Type} (next : S → S) (s : S) : Nat → S
  | 0 => s
  | n + 1 => next (specOrbit next s n)

def specRegimeStep (g : Nat → Nat) (H x : Nat) : Nat :=
  (x - H) + g (x - H)

def wideningRenewal (z : Nat) : Nat :=
  if 3 ≤ z then 1 else 0

def hiddenCouplingCollapseTarget : Prop :=
  ∃ (S₁ S₂ : Type) (step₁ : S₁ → S₁) (stock₁ : S₁ → Nat) (s₁₀ : S₁)
    (step₂ : S₂ → S₂) (stock₂ : S₂ → Nat) (s₂₀ : S₂),
    stock₁ s₁₀ = 4 ∧ stock₂ s₂₀ = 4 ∧
    (∀ t, 3 ≤ stock₁ (specOrbit step₁ s₁₀ t)) ∧
    stock₂ (specOrbit step₂ s₂₀ 4) = 0

def widenHealsBlindnessTarget : Prop :=
  (∀ (drawA drawB : Nat → Nat) (nextA nextB : Nat → Unit → Nat) (rA rB : Nat),
    (∀ r, 1 ≤ drawA r) → (∀ r, 1 ≤ drawB r) →
    (specOrbit (fun st : Nat × (Nat × Nat) =>
      (specRegimeStep wideningRenewal (drawA st.2.1 + drawB st.2.2) st.1,
       (nextA st.2.1 (), nextB st.2.2 ()))) (6, (rA, rB)) 6).1 = 0) ∧
  (∃ (Sw : Type) (stepW : Sw → Sw) (stockW : Sw → Nat) (sW₀ : Sw),
    stockW sW₀ = 6 ∧ ∀ t, 3 ≤ stockW (specOrbit stepW sW₀ t))

def directed3DNonCollapseTarget : Prop :=
  ∃ (Cell2 Cell3 : Type) (Eq2 : Cell2 → Cell2 → Prop) (Has3 : Cell3 → Cell2 → Cell2 → Prop)
    (w : Cell2 → Nat),
    (∀ P Q, Eq2 P Q → w P = w Q) ∧
    (∀ Γ P Q, Has3 Γ P Q → w P ≤ w Q) ∧
    (∃ (P Q : Cell2) (Γ₀ : Cell3), Has3 Γ₀ P Q ∧ ¬ Eq2 P Q ∧ ∀ Γ, ¬ Has3 Γ Q P)

def masterSpineEthicsFirewallTarget : Prop :=
  (∀ (Pos F D : Type) (MasterLaw : D → Prop) (_p : Pos) (_f : F) (d : D),
    MasterLaw d → ¬ (∀ d' (sig : Pos → Nat → F → Prop), MasterLaw d' → ∀ q t g, sig q t g)) ∧
  (∃ (Arch : Type) (Viable : Arch → Prop) (a₀ : Arch),
    Viable a₀ ∧ ¬ (∀ a (sig : Unit → Nat → Unit → Prop), Viable a → ∀ q t g, sig q t g))

end BecomingSpec.Extensions
