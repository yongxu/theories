import Becoming.Space
import Becoming.Witnesses

/-!
# Admission: what can form next, and what a part opens or closes

On 10 October 2026 Ren wrote that being generative is that “its existence creates more
possibilities of becoming - more future, not less”, and that “"not harm" - this is a phase
transition with a clear boundary, not some "outside will or belief"”, with “neutral and
generative dynamics that can be identified (degenerative/neutral/generative)”. Ren confirmed
two readings. Possibilities are what can form next from what exists, and one future has
more than another when it keeps everything the other has and adds some. The whole is never
any center's model of it, so a comparison by inclusion licenses no imposed ending. This
module states the first reading on flows and webs, with no premise beyond the
representation. Its names describe the dynamics.

* **Admission.** Levels *admit* a formation at a step when they meet every requirement it
  then has (`Web.Admits`). Support is admission by the levels that stand
  (`Web.supported_iff_admits`), and levels no lower admit no less (`Web.Admits.mono`).
* **Crossing a threshold.** Where a formation's requirements do not loosen across a step,
  it gains support only if a condition it requires rises (`Web.GainsSupport.rises`). Where
  they do not tighten, it loses support only if one falls (`Web.LosesSupport.falls`).
* **Support comes from the supported.** Consider a balanced flow where only active
  formations give and activity needs support. Every rise is given by a supported formation
  (`Flow.rise_given_by_supported`). So a formation whose requirements do not loosen gains
  support only where a supported formation gives to a condition it requires
  (`Flow.gains_from_supported`).
* **The end absorbs.** If no member of a family is supported, requirements do not loosen,
  and only members give to what members require, then no member is supported again
  (`Flow.unsupported_stays`). Of the whole, once nothing is supported, nothing is supported
  or active again (`Flow.nothing_supported_stays`). Each premise is needed (`Restoring`):
  - a requirement dissolves (`Restoring.Adapting`);
  - something beyond the family gives (`Restoring.Inflow`);
  - a giver is not active (`Restoring.Idle`);
  - an active giver is not supported (`Restoring.Carried`);
  - a rise is given by nothing (`Restoring.Spontaneous`).
* **A part withheld.** A part is a decided family of formations (`part : F → Bool`), a
  single formation or a system of them. The flow with the part withheld leaves the rest of
  the exchange as it was (`Flow.withhold`). The levels without the part are those that
  balance this flow from the same start (`Flow.WithheldLevels`); where they exist they are
  unique (`Flow.WithheldLevels.unique`). The difference is exact
  (`Flow.Balances.withheld`): at every step, each level, with what the part has taken from
  the condition so far, equals the level without the part with what the part has given it.
* **The boundary is a net exchange.** At a step a formation is supported exactly when, on
  every condition it requires, its need with what the part has taken from the condition so
  far is at most the level without the part with what the part has given it so far
  (`Flow.Balances.supported_iff_within_margin`). The part's net draw must stay within the
  margin by which the levels without it meet the need. Suppose that, up to a step, the part
  has given each condition a formation requires at least what it took from it. Then
  wherever the levels without the part admit the formation, it is supported
  (`Flow.Balances.supported_of_net_give`). So a part closes what can form only through a
  net draw on a condition that formation requires, beyond its margin, and it opens one only
  through a net give (`Flow.Balances.admits_of_net_draw`).
* **Comparison by inclusion.** One level path *includes* another when, at every step, it
  admits every formation the other admits (`Web.Includes`), a preorder
  (`Web.Includes.refl`, `Web.Includes.trans`). It *exceeds* the other when at some step it
  admits a formation the other does not (`Web.Exceeds`), which no path it includes does
  (`Web.Includes.not_exceeded`). Three cases follow
  from the part's exchange at every step:
  - giving each condition at least what it takes closes nothing (`Flow.Balances.closes_nothing`);
  - giving no more than it takes opens nothing (`Flow.Balances.opens_nothing`);
  - giving exactly what it takes changes nothing (`Flow.Balances.changes_nothing`).
* **Four cases.** Compared by inclusion with the levels without it, a part does one of four
  things:
  - it *widens*: the levels with it include and exceed those without it (`Restoring.Inflow.widens`);
  - it *narrows*, the converse (`Clearing.narrows` in `Becoming.Regions`);
  - it keeps them the *same*;
  - it is *mixed*: each exceeds the other (`Transfer.mixed`).
  A mixed part is not ordered by inclusion, and ordering it needs a measure, which is a
  further premise.

The phase results this module builds on are those of `Becoming.Continuation`:
- no condition is drawn down without end (`Flow.excess_bounded`);
- joint excess that brings a level below a need ends the renewal there, and ends every
  formation depending on the condition at that need (`Flow.joint_excess_ends`).

The comparison holds the rest of the exchange fixed, as the but-for test of `Becoming.Joint`
holds the move fixed. Where no level path balances the flow without the part, there is
nothing to compare. Each witness exhibits its levels without the part.

**AI reading, adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D2, D22, D35).** The
mapping onto Ren's terms is the AI's reading:
- inclusion and exceeding read as Ren's “more future, not less”;
- widening reads as generative, narrowing as degenerative, keeping the same as neutral;
- support gained only from the supported reads as the continuation of becoming continuing
  itself.

The comparison counts formations admitted. It does not compare renewal capacity or
richness of relations, which Ren also named. The representation commits to discrete steps,
natural quantities and a decided part.
* **A need with a cap, and no arising without change.** Levels keep a formation within its band
  where each required condition stands between its need and its cap (`Web.FitsBand`); with balance
  the band is exact on both sides, the part opening it from below by giving and closing it from
  above by giving beyond the margin to the cap (`Flow.fitsBand_iff_within_margins_at`). A formation
  active exactly where supported does not arise across a step at which what it reads does not change
  (`Web.not_arises_of_unchanged`).
-/

namespace Becoming

variable {F C : Type}

/-- None at the first step, one after it. -/
def unitStep : Nat → Nat := Witnesses.profile [0] 1

theorem unitStep_pos : ∀ {t : Nat}, 0 < t → 1 ≤ unitStep t
  | _ + 1, _ => Nat.le_refl 1

/-- One at the first step, none after it. -/
def unitDrop : Nat → Nat := Witnesses.profile [1] 0

/-! ## Gaining and losing support -/

namespace Web

variable (W : Web F C)

/-- `f` gains support across the step from `t`: not supported at `t`, supported after it. -/
def GainsSupport (t : Nat) (f : F) : Prop :=
  ¬ W.Supported t f ∧ W.Supported (t + 1) f

/-- `f` loses support across the step from `t`: supported at `t`, not after it. -/
def LosesSupport (t : Nat) (f : F) : Prop :=
  W.Supported t f ∧ ¬ W.Supported (t + 1) f

/-- Across the step from `t`, `f`'s requirements do not loosen: each one it has at `t` it
still has after the step, at no lower need. -/
def Unloosened (t : Nat) (f : F) : Prop :=
  ∀ c, W.requires t f c → W.requires (t + 1) f c ∧ W.need t f c ≤ W.need (t + 1) f c

/-- Across the step from `t`, `f`'s requirements do not tighten: each one it has after the
step it had at `t`, at no greater need. -/
def Untightened (t : Nat) (f : F) : Prop :=
  ∀ c, W.requires (t + 1) f c → W.requires t f c ∧ W.need (t + 1) f c ≤ W.need t f c

variable {W}

/-- Gaining support needs a rise or a loosening: where `f`'s requirements do not loosen
across a step, it gains support only if a condition it requires rises. -/
theorem GainsSupport.rises {t : Nat} {f : F} (gains : W.GainsSupport t f)
    (unloosened : W.Unloosened t f) : ¬ ∀ c, W.requires t f c → ¬ W.Rises t c :=
  fun still => gains.1 (W.supported_of gains.2 fun c requires =>
    match unloosened c requires with
    | ⟨kept, need⟩ => ⟨kept, need, Nat.not_lt.mp (still c requires)⟩)

/-- Losing support needs a fall or a tightening: where `f`'s requirements do not tighten
across a step, it loses support only if a condition it requires falls. -/
theorem LosesSupport.falls {t : Nat} {f : F} (loses : W.LosesSupport t f)
    (untightened : W.Untightened t f) : ¬ ∀ c, W.requires (t + 1) f c → ¬ W.Falls t c :=
  fun still => loses.2 (W.supported_of loses.1 fun c requires =>
    match untightened c requires with
    | ⟨had, need⟩ => ⟨had, need, Nat.not_lt.mp (still c requires)⟩)

end Web

/-! ## Support is gained only from the supported -/

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- With balance at the condition across the step, a rise is given by a formation taking
part; where whatever gives to it there is supported, by a supported one. -/
theorem rise_given_by_supported_at {t : Nat} {c : C} (balances : L.BalancesOn W [c] t)
    (givers : L.GiversSupported W t c) (rises : W.Rises t c) : ∃ g, g ∈ L.present t ∧ 0 < L.give t g c ∧ W.Supported t g :=
  match total_pos (L.present t) (balances.rise_given (.head []) rises) with
  | ⟨g, mem, gives⟩ => ⟨g, mem, gives, givers g mem gives⟩

/-- In a balanced flow where only active formations give and activity needs support,
every rise is given by a supported formation taking part. -/
theorem rise_given_by_supported (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {t : Nat} {c : C} (rises : W.Rises t c) :
    ∃ g, g ∈ L.present t ∧ 0 < L.give t g c ∧ W.Supported t g :=
  rise_given_by_supported_at (balances.on [c] t) (acting.giversSupported dependent t c) rises

/-- Support is gained only from the supported, at the step it is gained: with balance
across the step at each condition the formation requires, and whatever gives to such a
condition there supported, a formation whose requirements do not loosen gains support only
where a supported formation taking part gives to a condition it requires. -/
theorem gains_from_supported_at {t : Nat} {f : F}
    (balances : ∀ c, W.requires t f c → L.BalancesOn W [c] t)
    (givers : ∀ c, W.requires t f c → L.GiversSupported W t c) (gains : W.GainsSupport t f) (unloosened : W.Unloosened t f) :
    ¬ ∀ c, W.requires t f c → ∀ g, g ∈ L.present t → 0 < L.give t g c → ¬ W.Supported t g :=
  fun none => gains.rises unloosened fun c requires rises =>
    match rise_given_by_supported_at (balances c requires) (givers c requires) rises with
    | ⟨g, mem, gives, supported⟩ => none c requires g mem gives supported

/-- Support is gained only from the supported: in a balanced flow where only active
formations give and activity needs support, a formation whose requirements do not loosen
across a step gains support only where a supported formation taking part gives to a
condition it requires. -/
theorem gains_from_supported (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {t : Nat} {f : F} (gains : W.GainsSupport t f)
    (unloosened : W.Unloosened t f) :
    ¬ ∀ c, W.requires t f c → ∀ g, g ∈ L.present t → 0 < L.give t g c → ¬ W.Supported t g :=
  gains_from_supported_at (fun c _ => balances.on [c] t)
    (fun c _ => acting.giversSupported dependent t c) gains unloosened

/-- What holds at the end of a stretch and not at every step of it came to hold across one of its
steps: this cannot be refuted, with nothing decided. -/
theorem comes_within_not_not {p : Nat → Prop} {S : Nat} : ∀ {K : Nat}, p (S + K) →
    ¬ (∀ i, i ≤ K → p (S + i)) → ¬ ¬ ∃ u, S ≤ u ∧ u < S + K ∧ ¬ p u ∧ p (u + 1)
  | 0, holds, notAll => absurd (fun _ le => Eq.subst (motive := fun j => p (S + j))
      (Nat.eq_zero_of_le_zero le).symm holds) notAll
  | K + 1, holds, notAll => fun none =>
    (fun em : ¬ ¬ (p (S + K) ∨ ¬ p (S + K)) => em fun decided => match decided with
      | .inr fails => none ⟨S + K, Nat.le_add_right S K, Nat.lt_succ_self _, fails, holds⟩
      | .inl prev => comes_within_not_not prev
          (fun all => notAll fun i le => match Nat.lt_or_ge i (K + 1) with
            | .inl lt => all i (Nat.le_of_lt_succ lt)
            | .inr ge => Eq.subst (motive := fun j => p (S + j)) (Nat.le_antisymm ge le) holds)
          fun ⟨u, from_, below, fails, after⟩ =>
            none ⟨u, from_, Nat.lt_succ_of_lt below, fails, after⟩)
      (fun k => k (.inr fun h => k (.inl h)))

/-- **Support is passed on by formations that gained it later.** In a balanced flow where only
active formations give and activity needs support, with requirements never loosening and no
formation supported for more than `K + 1` steps in a row: where some formation gains support at
arbitrarily late steps, then for every `T` and `N` it cannot be refuted that, at some step from
`N` on, a formation gains support through the giving of a supported formation that itself gained
support after `T`. Support runs as a chain of gains, each giver a newer gainer; a chain of support
is not yet 生生, which asks a direction as well (chapter §6.1). -/
theorem support_passes_on (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    (unloosened : ∀ t f, W.Unloosened t f) {K : Nat}
    (brief : ∀ t g, ¬ ∀ i, i ≤ K → W.Supported (t + i) g)
    (recurs : ∀ N, ∃ t f, N ≤ t ∧ W.GainsSupport t f) (T N : Nat) :
    ¬ ¬ ∃ t f c g u, N ≤ t ∧ W.GainsSupport t f ∧ W.requires t f c ∧ g ∈ L.present t ∧
      0 < L.give t g c ∧ W.Supported t g ∧ T ≤ u ∧ u < t ∧ W.GainsSupport u g :=
  match recurs (N + (K + (T + 1))) with
  | ⟨t, f, late, gains⟩ => fun none =>
    have span : K + (T + 1) ≤ t := Naturals.le_of_add_le_left late
    have back : t - K + K = t := Naturals.sub_add_cancel (Naturals.le_of_add_le_right span)
    have after : T + 1 ≤ t - K := Naturals.le_sub_of_add_le span
    gains_from_supported balances acting dependent gains (unloosened t f)
      fun c requires g mem gives supported =>
        comes_within_not_not (p := fun j => W.Supported j g) (S := t - K)
          (Eq.subst (motive := fun j => W.Supported j g) back.symm supported) (brief (t - K) g)
          fun ⟨u, from_, below, fails, holds⟩ =>
            none ⟨t, f, c, g, u, Nat.le_trans (Nat.le_add_right N _) late, gains, requires, mem, gives,
              supported, Nat.le_trans (Nat.le_succ T) (Nat.le_trans after from_),
              Nat.lt_of_lt_of_le below (Nat.le_of_eq back), fails, holds⟩

/-- Where nothing beyond gives, the end absorbs, over the steps it is used at: with balance
at each condition a member requires and whatever gives to such a condition supported, across
each of the `n` steps from `T`, no member is supported at `T + n`. -/
theorem unsupported_stays_at {member : F → Prop} {T : Nat}
    (unloosened : ∀ n f, member f → W.Unloosened (T + n) f)
    (within : ∀ n f c, member f → W.requires (T + n) f c → ∀ g, g ∈ L.present (T + n) →
      0 < L.give (T + n) g c → member g)
    (none : ∀ f, member f → ¬ W.Supported T f) :
    ∀ n, (∀ k f c, k < n → member f → W.requires (T + k) f c → L.BalancesOn W [c] (T + k)) →
      (∀ k f c, k < n → member f → W.requires (T + k) f c →
        L.GiversSupported W (T + k) c) →
      ∀ f, member f → ¬ W.Supported (T + n) f
  | 0, _, _, f, m => none f m
  | n + 1, balances, givers, f, m => fun supported =>
    have before := unsupported_stays_at unloosened within none n
      (fun k f c below => balances k f c (Nat.lt_succ_of_lt below))
      fun k f c below => givers k f c (Nat.lt_succ_of_lt below)
    gains_from_supported_at (fun c requires => balances n f c (Nat.lt_succ_self n) m requires)
      (fun c requires => givers n f c (Nat.lt_succ_self n) m requires)
      ⟨before f m, supported⟩ (unloosened n f m)
      fun c requires g mem gives => before g (within n f c m requires g mem gives)

/-- Where nothing beyond gives, the end absorbs. If no member of a family is supported
at `T`, the members' requirements do not loosen from `T` on, and only members give to what
members require, then no member is supported at any later step. -/
theorem unsupported_stays (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {member : F → Prop} {T : Nat}
    (unloosened : ∀ n f, member f → W.Unloosened (T + n) f)
    (within : ∀ n f c, member f → W.requires (T + n) f c → ∀ g, g ∈ L.present (T + n) →
      0 < L.give (T + n) g c → member g)
    (none : ∀ f, member f → ¬ W.Supported T f) :
    ∀ n f, member f → ¬ W.Supported (T + n) f :=
  fun n => unsupported_stays_at unloosened within none n
    (fun k _ c _ _ _ => balances.on [c] (T + k))
    fun k _ c _ _ _ => acting.giversSupported dependent (T + k) c

/-- Of the whole nothing is beyond, over the steps it is used at: once nothing is supported,
while requirements do not loosen, with balance at each required condition and whatever gives
to it supported across each of the `n` steps from `T`, nothing is supported at `T + n`, and
a formation active there only while supported is not active. -/
theorem nothing_supported_stays_at {T n : Nat} (unloosened : ∀ n f, W.Unloosened (T + n) f)
    (none : ∀ f, ¬ W.Supported T f)
    (balances : ∀ k f c, k < n → W.requires (T + k) f c → L.BalancesOn W [c] (T + k))
    (givers : ∀ k f c, k < n → W.requires (T + k) f c → L.GiversSupported W (T + k) c)
    (f : F) (dependent : W.active (T + n) f → W.Supported (T + n) f) :
    ¬ W.Supported (T + n) f ∧ ¬ W.active (T + n) f :=
  have unsupported := unsupported_stays_at (member := fun _ => True)
    (fun n f _ => unloosened n f) (fun _ _ _ _ _ _ _ _ => trivial) (fun f _ => none f) n
    (fun k f c below _ requires => balances k f c below requires)
    (fun k f c below _ requires => givers k f c below requires) f trivial
  ⟨unsupported, fun active => unsupported (dependent active)⟩

/-- Of the whole nothing is beyond. In a balanced flow where only active formations give and
activity needs support, once nothing is supported, while requirements do not loosen,
nothing is supported or active again. -/
theorem nothing_supported_stays (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {T : Nat} (unloosened : ∀ n f, W.Unloosened (T + n) f)
    (none : ∀ f, ¬ W.Supported T f) :
    ∀ n f, ¬ W.Supported (T + n) f ∧ ¬ W.active (T + n) f :=
  fun n f => nothing_supported_stays_at unloosened none
    (fun k _ c _ _ => balances.on [c] (T + k))
    (fun k _ c _ _ => acting.giversSupported dependent (T + k) c)
    f (dependent (T + n) f)

end Flow

/-! ## What levels admit -/

namespace Web

variable (W : Web F C)

/-- The levels `l` admit `f` at `t`: they meet every requirement `f` then has. -/
def Admits (l : C → Nat) (t : Nat) (f : F) : Prop :=
  ∀ c, W.requires t f c → W.need t f c ≤ l c

/-- The levels `l` keep `f` within its band at `t`: each condition `f` then requires stands at
least at its need and at most at its cap. A need with a cap is harmed by too much as by too
little. -/
def FitsBand (cap : Nat → F → C → Nat) (l : C → Nat) (t : Nat) (f : F) : Prop :=
  ∀ c, W.requires t f c → W.need t f c ≤ l c ∧ l c ≤ cap t f c

/-- The level path `l` includes `l'`: at every step it admits every formation `l'` admits. -/
def Includes (l l' : Nat → C → Nat) : Prop :=
  ∀ t f, W.Admits (l' t) t f → W.Admits (l t) t f

/-- The level path `l` exceeds `l'`: at some step it admits a formation `l'` does not. -/
def Exceeds (l l' : Nat → C → Nat) : Prop :=
  ∃ t f, W.Admits (l t) t f ∧ ¬ W.Admits (l' t) t f

variable {W}

/-- Levels within a band admit. -/
theorem FitsBand.admits {cap : Nat → F → C → Nat} {l : C → Nat} {t : Nat} {f : F}
    (fits : W.FitsBand cap l t f) : W.Admits l t f :=
  fun c requires => (fits c requires).1

/-- **What does not change gives no arising.** A formation active exactly where it is supported,
at a step and the next, whose requirements do not grow, whose needs stay and the levels of every
condition stay across the step, does not arise across it: arising needs a change in what is
read. -/
theorem not_arises_of_unchanged {t : Nat} {g : F}
    (reads : ∀ s, (s = t ∨ s = t + 1) → (W.active s g ↔ W.Supported s g))
    (requires : ∀ c, W.requires t g c → W.requires (t + 1) g c)
    (needs : ∀ c, W.need t g c = W.need (t + 1) g c)
    (levels : ∀ c, W.level (t + 1) c = W.level t c) : ¬ W.Arises t g :=
  fun ⟨before, after⟩ => before ((reads t (.inl rfl)).mpr fun c depends =>
    Nat.le_trans (Nat.le_of_eq (needs c))
      (Nat.le_trans ((reads (t + 1) (.inr rfl)).mp after c (requires c depends))
        (Nat.le_of_eq (levels c))))

/-- Support is admission by the levels that stand. -/
theorem supported_iff_admits {t : Nat} {f : F} : W.Supported t f ↔ W.Admits (W.level t) t f :=
  Iff.rfl

/-- Levels no lower admit whatever lower levels admit. -/
theorem Admits.mono {l l' : C → Nat} {t : Nat} {f : F} (le : ∀ c, l' c ≤ l c)
    (admits : W.Admits l' t f) : W.Admits l t f :=
  fun c requires => Nat.le_trans (admits c requires) (le c)

/-- Inclusion is reflexive. -/
theorem Includes.refl (l : Nat → C → Nat) : W.Includes l l :=
  fun _ _ admits => admits

/-- Inclusion is transitive. -/
theorem Includes.trans {l l' l'' : Nat → C → Nat} (first : W.Includes l l')
    (second : W.Includes l' l'') : W.Includes l l'' :=
  fun t f admits => first t f (second t f admits)

/-- A level path that includes another and is exceeded by it does not exist. -/
theorem Includes.not_exceeded {l l' : Nat → C → Nat} (includes : W.Includes l l') :
    ¬ W.Exceeds l' l
  | ⟨t, f, admitted, not⟩ => not (includes t f admitted)

end Web

/-! ## A part withheld -/

/-- One step of the difference: `a` after a step with what is taken, `b` before it with what is
given; the same for `m` and `k` with only the withheld exchange; and the running sums
`P` and `Q` of the part's taking and giving before the step. -/
theorem rebalance {a b x y p q P Q m k : Nat} (step : a + (x + p) = b + (y + q))
    (withheld : m + x = k + y) (before : b + P = k + Q) : a + (P + p) = m + (Q + q) :=
  add_right_cancel x (calc
    a + (P + p) + x = a + ((P + p) + x) := Nat.add_assoc a (P + p) x
    _ = a + (P + (p + x)) := congrArg (a + ·) (Nat.add_assoc P p x)
    _ = a + (P + (x + p)) := congrArg (fun r => a + (P + r)) (Nat.add_comm p x)
    _ = a + ((x + p) + P) := congrArg (a + ·) (Nat.add_comm P (x + p))
    _ = (a + (x + p)) + P := (Nat.add_assoc a (x + p) P).symm
    _ = (b + (y + q)) + P := congrArg (· + P) step
    _ = b + ((y + q) + P) := Nat.add_assoc b (y + q) P
    _ = b + (P + (y + q)) := congrArg (b + ·) (Nat.add_comm (y + q) P)
    _ = (b + P) + (y + q) := (Nat.add_assoc b P (y + q)).symm
    _ = (k + Q) + (y + q) := congrArg (· + (y + q)) before
    _ = k + (Q + (y + q)) := Nat.add_assoc k Q (y + q)
    _ = k + (y + (Q + q)) := congrArg (k + ·) (Nat.add_left_comm Q y q)
    _ = (k + y) + (Q + q) := (Nat.add_assoc k y (Q + q)).symm
    _ = (m + x) + (Q + q) := congrArg (· + (Q + q)) withheld.symm
    _ = m + (x + (Q + q)) := Nat.add_assoc m x (Q + q)
    _ = m + ((Q + q) + x) := congrArg (m + ·) (Nat.add_comm x (Q + q))
    _ = (m + (Q + q)) + x := (Nat.add_assoc m (Q + q) x).symm)

namespace Flow

section Withholding

variable (L : Flow F C) (part : F → Bool)

/-- The flow with a part withheld: the formations of the part take and give nothing, and the
rest of the exchange is as it was. -/
def withhold : Flow F C :=
  ⟨L.present, fun t f c => if part f then 0 else L.take t f c,
    fun t f c => if part f then 0 else L.give t f c⟩

/-- What the part takes from `c` across the step from `t`. -/
def partTaken (t : Nat) (c : C) : Nat :=
  total (L.present t) fun f => if part f then L.take t f c else 0

/-- What the part gives to `c` across the step from `t`. -/
def partGiven (t : Nat) (c : C) : Nat :=
  total (L.present t) fun f => if part f then L.give t f c else 0

/-- `l` are the levels without the part: from the start of `W`, across every step, they change
by what the flow with the part withheld takes and gives. -/
def WithheldLevels (W : Web F C) (l : Nat → C → Nat) : Prop :=
  (∀ t c, l (t + 1) c + (L.withhold part).taken t c = l t c + (L.withhold part).given t c) ∧
    ∀ c, l 0 c = W.level 0 c

theorem split_at (q : F → Nat) (f : F) :
    q f = (if part f then 0 else q f) + (if part f then q f else 0) :=
  match part f with
  | true => (Nat.zero_add (q f)).symm
  | false => (Nat.add_zero (q f)).symm

/-- What is taken is what the rest take with the part withheld, and what the part takes. -/
theorem taken_withhold (t : Nat) (c : C) :
    L.taken t c = (L.withhold part).taken t c + L.partTaken part t c :=
  (total_congr (split_at part fun f => L.take t f c) (L.present t)).trans
    (total_add _ _ (L.present t))

/-- What is given is what the rest give with the part withheld, and what the part gives. -/
theorem given_withhold (t : Nat) (c : C) :
    L.given t c = (L.withhold part).given t c + L.partGiven part t c :=
  (total_congr (split_at part fun f => L.give t f c) (L.present t)).trans
    (total_add _ _ (L.present t))

variable {L part} {W : Web F C}

/-- The levels without a part, where they exist, are unique. -/
theorem WithheldLevels.unique {l l' : Nat → C → Nat} (without : L.WithheldLevels part W l)
    (without' : L.WithheldLevels part W l') : ∀ t c, l t c = l' t c
  | 0, c => (without.2 c).trans (without'.2 c).symm
  | t + 1, c => add_right_cancel ((L.withhold part).taken t c)
      ((without.1 t c).trans ((congrArg (· + (L.withhold part).given t c)
        (WithheldLevels.unique without without' t c)).trans (without'.1 t c).symm))

/-- The difference a part makes, at one condition up to one step: with balance at the
condition across every step before `t`, the level at `t` with what the part has taken from
the condition so far is the level without the part with what the part has given it so far. -/
theorem withheld_at {l : Nat → C → Nat} (without : L.WithheldLevels part W l) {c : C} :
    ∀ t, (∀ s, s < t → L.BalancesOn W [c] s) →
      W.level t c + total (steps 0 t) (fun s => L.partTaken part s c) =
        l t c + total (steps 0 t) (fun s => L.partGiven part s c)
  | 0, _ => congrArg (· + 0) (without.2 c).symm
  | t + 1, balances =>
    have last : ∀ q : Nat → Nat, total (steps 0 (t + 1)) q = total (steps 0 t) q + q t :=
      fun q => (steps_last q 0 t).trans (congrArg (total (steps 0 t) q + ·)
        (congrArg q (Nat.zero_add t)))
    (congrArg (W.level (t + 1) c + ·) (last _)).trans
      ((rebalance
        (((congrArg (W.level (t + 1) c + ·) (taken_withhold L part t c)).symm.trans
          ((balances t (Nat.lt_succ_self t)) c (.head []))).trans
            (congrArg (W.level t c + ·) (given_withhold L part t c)))
        (without.1 t c) (withheld_at without t fun s below =>
          balances s (Nat.lt_succ_of_lt below))).trans
        (congrArg (l (t + 1) c + ·) (last _).symm))

/-- The difference a part makes. At every step, each level with what the part has taken from
the condition so far is the level without the part with what the part has given it so far. -/
theorem Balances.withheld (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) :
    ∀ t c, W.level t c + total (steps 0 t) (fun s => L.partTaken part s c) =
      l t c + total (steps 0 t) (fun s => L.partGiven part s c) :=
  fun t c => withheld_at without t fun s _ => balances.on [c] s

/-- Closing needs a net draw, with balance only at the conditions `f` requires, across the
steps before `t`. -/
theorem supported_of_net_give_at {l : Nat → C → Nat} (without : L.WithheldLevels part W l)
    {t : Nat} {f : F} (balances : ∀ c, W.requires t f c → ∀ s, s < t → L.BalancesOn W [c] s)
    (net : ∀ c, W.requires t f c → total (steps 0 t) (fun s => L.partTaken part s c) ≤
      total (steps 0 t) (fun s => L.partGiven part s c))
    (admits : W.Admits (l t) t f) : W.Supported t f :=
  fun c requires => Nat.le_trans (admits c requires)
    (le_of_add_le_add_right (total (steps 0 t) fun s => L.partGiven part s c)
      (Nat.le_trans (Nat.le_of_eq (withheld_at without t (balances c requires)).symm)
        (Nat.add_le_add_left (net c requires) _)))

/-- Opening needs a net give, with balance only at the conditions `f` requires, across the
steps before `t`. -/
theorem admits_of_net_draw_at {l : Nat → C → Nat} (without : L.WithheldLevels part W l)
    {t : Nat} {f : F} (balances : ∀ c, W.requires t f c → ∀ s, s < t → L.BalancesOn W [c] s)
    (net : ∀ c, W.requires t f c → total (steps 0 t) (fun s => L.partGiven part s c) ≤
      total (steps 0 t) (fun s => L.partTaken part s c))
    (supported : W.Supported t f) : W.Admits (l t) t f :=
  fun c requires => Nat.le_trans (supported c requires)
    (le_of_add_le_add_right (total (steps 0 t) fun s => L.partTaken part s c)
      (Nat.le_trans (Nat.le_of_eq (withheld_at without t (balances c requires)))
        (Nat.add_le_add_left (net c requires) _)))

/-- The boundary is exact, with balance only at the conditions `f` requires, across the steps
before `t`: `f` is supported at `t` exactly when its need with what the part has taken from
each such condition so far is at most the level without the part with what the part has
given it so far. -/
theorem supported_iff_within_margin_at {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {t : Nat} {f : F}
    (balances : ∀ c, W.requires t f c → ∀ s, s < t → L.BalancesOn W [c] s) :
    W.Supported t f ↔ ∀ c, W.requires t f c →
      W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
        l t c + total (steps 0 t) (fun s => L.partGiven part s c) :=
  ⟨fun supported c requires => Nat.le_trans
      (Nat.add_le_add_right (supported c requires) (total (steps 0 t) fun s => L.partTaken part s c))
      (Nat.le_of_eq (withheld_at without t (balances c requires))),
   fun within c requires => le_of_add_le_add_right (total (steps 0 t) fun s => L.partTaken part s c)
      (Nat.le_trans (within c requires)
        (Nat.le_of_eq (withheld_at without t (balances c requires)).symm))⟩

/-- Closing needs a net draw. Where, up to `t`, the part has given each condition `f`
requires at least what it has taken from it, `f` is supported at `t` wherever the levels
without the part admit it. -/
theorem Balances.supported_of_net_give (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {t : Nat} {f : F}
    (net : ∀ c, W.requires t f c → total (steps 0 t) (fun s => L.partTaken part s c) ≤
      total (steps 0 t) (fun s => L.partGiven part s c))
    (admits : W.Admits (l t) t f) : W.Supported t f :=
  supported_of_net_give_at without (fun c _ s _ => balances.on [c] s) net admits

/-- Opening needs a net give. Where, up to `t`, the part has taken from each condition `f`
requires at least what it has given to it, the levels without the part admit `f` at `t`
wherever it is supported. -/
theorem Balances.admits_of_net_draw (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {t : Nat} {f : F}
    (net : ∀ c, W.requires t f c → total (steps 0 t) (fun s => L.partGiven part s c) ≤
      total (steps 0 t) (fun s => L.partTaken part s c))
    (supported : W.Supported t f) : W.Admits (l t) t f :=
  admits_of_net_draw_at without (fun c _ s _ => balances.on [c] s) net supported

/-- The boundary is exact. At `t`, `f` is supported exactly when, on every condition it
requires, its need with what the part has taken from the condition so far is at most the
level without the part with what the part has given it so far: the part's net draw stays
within the margin by which the levels without it meet the need. -/
theorem Balances.supported_iff_within_margin (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {t : Nat} {f : F} :
    W.Supported t f ↔ ∀ c, W.requires t f c →
      W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
        l t c + total (steps 0 t) (fun s => L.partGiven part s c) :=
  supported_iff_within_margin_at without fun c _ s _ => balances.on [c] s

/-- A part that gives each condition at every step at least what it takes from it closes
nothing: the levels with it include those without it. -/
theorem Balances.closes_nothing (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l)
    (returns : ∀ t c, L.partTaken part t c ≤ L.partGiven part t c) : W.Includes W.level l :=
  fun t _ admits => balances.supported_of_net_give without
    (fun c _ => total_le (steps 0 t) fun s _ => returns s c) admits

/-- A part that gives each condition at every step no more than it takes from it opens
nothing: the levels without it include those with it. -/
theorem Balances.opens_nothing (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l)
    (keeps : ∀ t c, L.partGiven part t c ≤ L.partTaken part t c) : W.Includes l W.level :=
  fun t _ supported => balances.admits_of_net_draw without
    (fun c _ => total_le (steps 0 t) fun s _ => keeps s c) supported

/-- A part that gives each condition at every step exactly what it takes from it changes
nothing that can form. -/
theorem Balances.changes_nothing (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l)
    (even : ∀ t c, L.partTaken part t c = L.partGiven part t c) :
    W.Includes W.level l ∧ W.Includes l W.level :=
  ⟨balances.closes_nothing without fun t c => Nat.le_of_eq (even t c),
   balances.opens_nothing without fun t c => Nat.le_of_eq (even t c).symm⟩

/-- **The band is exact on both sides.** With balance only at the conditions `f` requires,
across the steps before `t`, the levels that stand keep `f` within its band exactly when, at each
such condition, its need with what the part has taken is at most the level without the part with
what the part has given, and that is at most the cap with what the part has taken: the part opens
the band from below by giving and closes it from above by giving beyond the margin to the cap. -/
theorem fitsBand_iff_within_margins_at {cap : Nat → F → C → Nat} {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {t : Nat} {f : F}
    (balances : ∀ c, W.requires t f c → ∀ s, s < t → L.BalancesOn W [c] s) :
    W.FitsBand cap (W.level t) t f ↔ ∀ c, W.requires t f c →
      W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
          l t c + total (steps 0 t) (fun s => L.partGiven part s c) ∧
        l t c + total (steps 0 t) (fun s => L.partGiven part s c) ≤
          cap t f c + total (steps 0 t) (fun s => L.partTaken part s c) :=
  ⟨fun fits c requires =>
    have same := withheld_at without t (balances c requires)
    ⟨Nat.le_trans (Nat.add_le_add_right (fits c requires).1 _) (Nat.le_of_eq same),
     Nat.le_trans (Nat.le_of_eq same.symm) (Nat.add_le_add_right (fits c requires).2 _)⟩,
   fun within c requires =>
    have same := withheld_at without t (balances c requires)
    ⟨le_of_add_le_add_right (total (steps 0 t) fun s => L.partTaken part s c)
        (Nat.le_trans (within c requires).1 (Nat.le_of_eq same.symm)),
     le_of_add_le_add_right (total (steps 0 t) fun s => L.partTaken part s c)
        (Nat.le_trans (Nat.le_of_eq same) (within c requires).2)⟩⟩

end Withholding

end Flow

/-! ## Each premise of the absorbing end is needed -/

namespace Restoring

/-- Across the first step the giver `true` gives the one condition one unit; nothing else
takes or gives. -/
def flow : Flow Bool Unit where
  present t := match t with
    | 0 => [true]
    | _ + 1 => []
  take _ _ _ := 0
  give t x _ := match t, x with
    | 0, true => 1
    | 0, false => 0
    | _ + 1, _ => 0

theorem balances_unitStep (active : Nat → Bool → Prop) (requires : Nat → Bool → Unit → Prop)
    (need : Nat → Bool → Unit → Nat) :
    flow.Balances ⟨fun t _ => unitStep t, active, requires, need, fun _ _ _ => False⟩
  | 0, () => rfl
  | _ + 1, () => rfl

/-- `false` depends on the condition at need one and `true` at need two, which no level here
meets. -/
def need : Nat → Bool → Unit → Nat
  | _, true, _ => 2
  | _, false, _ => 1

/-! A requirement dissolves: `false` depends on the condition only at the first step, at a
level of zero throughout, and nothing takes part. -/

namespace Adapting

def web : Web Bool Unit where
  level _ _ := 0
  active t x := x = false ∧ 0 < t
  requires t _ _ := t = 0
  need _ _ _ := 1
  draws _ _ _ := False

theorem restores :
    (Flow.still : Flow Bool Unit).Balances web ∧ (Flow.still : Flow Bool Unit).Acting web ∧
      web.Dependent ∧ (∀ x, ¬ web.Supported 0 x) ∧ ¬ web.Unloosened 0 false ∧
      web.Supported 1 false :=
  ⟨fun _ _ => rfl, fun _ _ _ mem _ => (nomatch mem),
   fun _ _ active _ requires => absurd (Eq.subst (motive := fun n => 0 < n) requires active.2)
     (Nat.lt_irrefl 0),
   fun _ supported => Nat.not_succ_le_zero 0 (supported () rfl),
   fun unloosened => Nat.noConfusion (unloosened () rfl).1,
   fun _ no => Nat.noConfusion no⟩

end Adapting

/-! Given from beyond: `true`, which requires nothing, gives the condition that `false`
requires. -/

namespace Inflow

def web : Web Bool Unit :=
  ⟨fun t _ => unitStep t, fun t x => match x with
    | true => t = 0
    | false => 0 < t,
   fun _ x _ => x = false, fun _ _ _ => 1, fun _ _ _ => False⟩

theorem restores :
    flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧ (∀ n, web.Unloosened n false) ∧
      ¬ web.Supported 0 false ∧ web.Supported 1 false ∧
      0 < flow.give 0 true () ∧ web.requires 0 false () :=
  ⟨balances_unitStep _ _ _,
   fun t x _ _ gives => match t, x, gives with
    | 0, true, _ => rfl
    | 0, false, gives => absurd gives (Nat.lt_irrefl 0),
   fun _ x active _ requires => match x, active, requires with
    | false, later, _ => unitStep_pos later,
   fun _ _ requires => ⟨requires, Nat.le_refl 1⟩,
   fun supported => Nat.not_succ_le_zero 0 (supported () rfl),
   fun _ _ => Nat.le_refl 1, Nat.zero_lt_one, rfl⟩

/-- The giver's part. -/
def giverPart : Bool → Bool
  | true => true
  | false => false

/-- Without the giver's part, the condition stays at zero. -/
theorem withheld : flow.WithheldLevels giverPart web fun _ _ => 0 :=
  ⟨fun t () => match t with
    | 0 => rfl
    | _ + 1 => rfl,
   fun () => rfl⟩

/-- Given from beyond widens what can form. With the giver's part, the levels include those
without it, and `false`, admitted at no step without it, is supported from the second step
on. -/
theorem widens {l : Nat → Unit → Nat} (without : flow.WithheldLevels giverPart web l) :
    web.Includes web.level l ∧ web.Exceeds web.level l ∧
      ∀ t, ¬ web.Admits (l t) t false ∧ web.Supported (t + 1) false :=
  have none : ∀ t, l t () = 0 := fun t => without.unique withheld t ()
  have closed : ∀ t, ¬ web.Admits (l t) t false := fun t admits =>
    Nat.not_succ_le_zero 0 (Nat.le_trans (admits () rfl) (Nat.le_of_eq (none t)))
  ⟨(balances_unitStep _ _ _).closes_nothing without fun t () => match t with
      | 0 => Nat.zero_le _
      | _ + 1 => Nat.zero_le _,
   ⟨1, false, fun _ _ => Nat.le_refl 1, closed 1⟩,
   fun t => ⟨closed t, fun _ _ => Nat.le_refl 1⟩⟩

end Inflow

/-! A giver that is not active: `true` gives across the first step though it is never active. -/

namespace Idle

def web : Web Bool Unit :=
  ⟨fun t _ => unitStep t, fun t x => x = false ∧ 0 < t, fun _ _ _ => True, need,
   fun _ _ _ => False⟩

theorem restores :
    flow.Balances web ∧ ¬ flow.Acting web ∧ web.Dependent ∧ (∀ n x, web.Unloosened n x) ∧
      (∀ x, ¬ web.Supported 0 x) ∧ web.Supported 1 false :=
  ⟨balances_unitStep _ _ _,
   fun acting => (nomatch (acting 0 true () (.head _) Nat.zero_lt_one).1),
   fun _ x active _ _ => match x, active with
    | false, ⟨_, later⟩ => unitStep_pos later,
   fun _ x _ _ => ⟨trivial, match x with | true => Nat.le_refl 2 | false => Nat.le_refl 1⟩,
   fun x supported => match x with
    | true => Nat.not_succ_le_zero 1 (supported () trivial)
    | false => Nat.not_succ_le_zero 0 (supported () trivial),
   fun _ _ => Nat.le_refl 1⟩

end Idle

/-! An active giver that is not supported: `true` is active across the first step, where its
need is not met, and gives. -/

namespace Carried

def web : Web Bool Unit :=
  ⟨fun t _ => unitStep t, fun t x => match x with
    | true => t = 0
    | false => 0 < t,
   fun _ _ _ => True, need, fun _ _ _ => False⟩

theorem restores :
    flow.Balances web ∧ flow.Acting web ∧ ¬ web.Dependent ∧ (∀ n x, web.Unloosened n x) ∧
      (∀ x, ¬ web.Supported 0 x) ∧ web.Supported 1 false :=
  ⟨balances_unitStep _ _ _,
   fun t x _ _ gives => match t, x, gives with
    | 0, true, _ => rfl
    | 0, false, gives => absurd gives (Nat.lt_irrefl 0),
   fun dependent => Nat.not_succ_le_zero 1 (dependent 0 true rfl () trivial),
   fun _ x _ _ => ⟨trivial, match x with | true => Nat.le_refl 2 | false => Nat.le_refl 1⟩,
   fun x supported => match x with
    | true => Nat.not_succ_le_zero 1 (supported () trivial)
    | false => Nat.not_succ_le_zero 0 (supported () trivial),
   fun _ _ => Nat.le_refl 1⟩

end Carried

/-! A rise that nothing gives: the condition rises across the first step while nothing takes
part. -/

namespace Spontaneous

def web : Web Bool Unit :=
  ⟨fun t _ => unitStep t, fun t x => x = false ∧ 0 < t, fun _ _ _ => True, need,
   fun _ _ _ => False⟩

theorem restores :
    ¬ (Flow.still : Flow Bool Unit).Balances web ∧ (Flow.still : Flow Bool Unit).Acting web ∧
      web.Dependent ∧ (∀ n x, web.Unloosened n x) ∧ (∀ x, ¬ web.Supported 0 x) ∧
      web.Supported 1 false :=
  ⟨fun balances => Nat.noConfusion (balances 0 ()),
   fun _ _ _ mem _ => (nomatch mem),
   fun _ x active _ _ => match x, active with
    | false, ⟨_, later⟩ => unitStep_pos later,
   fun _ x _ _ => ⟨trivial, match x with | true => Nat.le_refl 2 | false => Nat.le_refl 1⟩,
   fun x supported => match x with
    | true => Nat.not_succ_le_zero 1 (supported () trivial)
    | false => Nat.not_succ_le_zero 0 (supported () trivial),
   fun _ _ => Nat.le_refl 1⟩

end Spontaneous

end Restoring

/-! A conveyor: across the first step one formation takes a unit from one condition and gives
it to another. With its part it opens one formation's support and closes another's. -/

namespace Transfer

/-- The conveyor, a formation depending on the first condition (`false`) and one depending
on the second (`true`). -/
inductive Formation where
  | conveyor
  | first
  | second

/-- Across the first step the conveyor takes a unit from the first condition and gives one
to the second. -/
def flow : Flow Formation Bool where
  present t := match t with
    | 0 => [.conveyor]
    | _ + 1 => []
  take _ f c := match f, c with
    | .conveyor, false => 1
    | .conveyor, true => 0
    | .first, _ => 0
    | .second, _ => 0
  give _ f c := match f, c with
    | .conveyor, true => 1
    | .conveyor, false => 0
    | .first, _ => 0
    | .second, _ => 0

def web : Web Formation Bool where
  level t c := match c with
    | false => unitDrop t
    | true => unitStep t
  active t f := match f with
    | .conveyor => t = 0
    | .first => t = 0
    | .second => 0 < t
  requires _ f c := match f, c with
    | .first, false => True
    | .second, true => True
    | .first, true => False
    | .second, false => False
    | .conveyor, _ => False
  need _ _ _ := 1
  draws _ f c := match f, c with
    | .conveyor, false => True
    | .conveyor, true => False
    | .first, _ => False
    | .second, _ => False

theorem balances : flow.Balances web
  | 0, false => rfl
  | 0, true => rfl
  | _ + 1, false => rfl
  | _ + 1, true => rfl

theorem acting : flow.Acting web
  | 0, .conveyor, _, _, _ => rfl
  | 0, .first, false, _, gives => absurd gives (Nat.lt_irrefl 0)
  | 0, .first, true, _, gives => absurd gives (Nat.lt_irrefl 0)
  | 0, .second, false, _, gives => absurd gives (Nat.lt_irrefl 0)
  | 0, .second, true, _, gives => absurd gives (Nat.lt_irrefl 0)
  | _ + 1, _, _, mem, _ => nomatch mem

theorem taking : flow.Taking web
  | 0, .conveyor, false, _, _ => ⟨rfl, trivial⟩
  | 0, .conveyor, true, _, takes => absurd takes (Nat.lt_irrefl 0)
  | 0, .first, false, _, takes => absurd takes (Nat.lt_irrefl 0)
  | 0, .first, true, _, takes => absurd takes (Nat.lt_irrefl 0)
  | 0, .second, false, _, takes => absurd takes (Nat.lt_irrefl 0)
  | 0, .second, true, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _ + 1, _, _, mem, _ => nomatch mem

theorem dependent : web.Dependent
  | 0, .first, _, false, _ => Nat.le_refl 1
  | _, .second, later, true, _ => unitStep_pos later
  | _, .conveyor, _, false, no => nomatch no
  | _, .conveyor, _, true, no => nomatch no
  | _, .first, _, true, no => nomatch no
  | _, .second, _, false, no => nomatch no

/-- The conveyor's part. -/
def conveyorPart : Formation → Bool
  | .conveyor => true
  | .first => false
  | .second => false

/-- The levels without the conveyor's part: the first condition stays at one and the
second at zero. -/
def withheldLevel (_ : Nat) : Bool → Nat
  | false => 1
  | true => 0

theorem withheld : flow.WithheldLevels conveyorPart web withheldLevel :=
  ⟨fun t c => match t, c with
    | 0, false => rfl
    | 0, true => rfl
    | _ + 1, false => rfl
    | _ + 1, true => rfl,
   fun c => match c with
    | false => rfl
    | true => rfl⟩

/-- The conveyor's part is mixed. With it, from the second step on, the second formation is
supported and the first is not; without it, at every step the first is admitted and the
second is not. So each level path exceeds the other. -/
theorem mixed {l : Nat → Bool → Nat} (without : flow.WithheldLevels conveyorPart web l) :
    web.Exceeds web.level l ∧ web.Exceeds l web.level ∧
      ∀ t, web.Admits (l t) t .first ∧ ¬ web.Admits (l t) t .second ∧
        web.Supported (t + 1) .second ∧ ¬ web.Supported (t + 1) .first :=
  have same : ∀ t c, l t c = withheldLevel t c := without.unique withheld
  have each : ∀ t, web.Admits (l t) t .first ∧ ¬ web.Admits (l t) t .second ∧
      web.Supported (t + 1) .second ∧ ¬ web.Supported (t + 1) .first := fun t =>
    ⟨fun c requires => match c, requires with
      | false, _ => Nat.le_of_eq (same t false).symm,
     fun admits => Nat.not_succ_le_zero 0 (Nat.le_trans (admits true trivial)
       (Nat.le_of_eq (same t true))),
     fun c requires => match c, requires with
      | true, _ => Nat.le_refl 1,
     fun supported => Nat.not_succ_le_zero 0 (supported false trivial)⟩
  ⟨⟨1, .second, (each 0).2.2.1, (each 1).2.1⟩, ⟨1, .first, (each 1).1, (each 0).2.2.2⟩, each⟩

end Transfer

end Becoming
