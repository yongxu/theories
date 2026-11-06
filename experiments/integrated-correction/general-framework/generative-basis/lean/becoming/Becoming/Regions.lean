import Becoming.Admission

/-!
# Regions: self, system and whole, and represented boundaries

On 10 October 2026 Ren wrote of levels: “i think it should be the whole, and a weaker
version is within the system that one is in, then the self. not saying this is what life
does, but what's good for being generative, and the self is a cognitive model which can not
justify itself without some sort of "belief"”. Of centers, Ren wrote that “recognizing the
formation of the center is also with in the system, and the "boundary" is also with in the
same cognitive system”.

This module states, with no premise beyond the representation, two comparisons. First, how
a part's contribution, compared by inclusion as in `Becoming.Admission`, reads over nested
regions of formations. Second, how renewal over a region of conditions compares with the
conditions a formation actually requires and takes part in.

* **Nested regions.** Within a region of formations, levels admit everything other levels
  admit there (`Web.AdmitsWithin`). Beyond it, some formation is admitted by the other
  levels and not by these (`Web.LosesBeyond`). Inclusion is admission within the whole at
  every step (`Web.includes_iff_within_whole`).
  - What holds within a region holds within every region inside it
    (`Web.AdmitsWithin.narrow`).
  - What is lost beyond a region is lost beyond every region inside it
    (`Web.LosesBeyond.narrow`): the smaller the region, the more lies beyond it.
  - Nothing lies beyond the whole (`Web.not_losesBeyond_whole`), and what holds within the
    whole leaves nothing lost beyond any region (`Web.AdmitsWithin.not_losesBeyond`).
  - Within one formation, what holds is its own admission wherever the other levels admit
    it (`Web.admitsWithin_self`).
  - The whole first: the comparison over the whole is the comparison within every region at
    once (`Web.includes_iff_within_every`). A region's comparison takes the region as an
    input; the whole's takes none.
* **The generative space, with no axiom.** Ren, 11 October 2026: “these are space where
  generatively happens”. One level path *widens* another when it admits everything the
  other admits and one more (`Web.Widens`); two *keep* what can form the same when each
  includes the other (`Web.Keeps`), and are *mixed* when each exceeds the other
  (`Web.Mixed`). A part is generative where the levels with it widen those without it,
  degenerative where those without it widen those with it. Widening goes one way and is
  transitive, and the four cases exclude one another (`Web.Widens.not_reverse`,
  `Web.Widens.trans`, `Web.Widens.not_keeps`, `Web.Widens.not_mixed`,
  `Web.Keeps.not_mixed`): these are the grammar's order laws (`Becoming.GrammarLaws`) at what the
  paths admit, read as a relation on (step, formation) pairs (`Web.admitted`), where including,
  exceeding, widening, keeping and being mixed are the grammar's (`Web.includes_iff`,
  `Web.exceeds_iff`, `Web.widens_iff`, `Web.keeps_iff`, `Web.mixed_iff`). No significance,
  standpoint or boundary enters.
* **Losing beyond the dependence** (the witness `Clearing`, stated in `Becoming.Clearing`). In
  `Clearing`, the levels without the clearer's part
  exist (`Clearing.withheld`): the resource rises by one at each step and the habitat
  stays at two.
  - At every step the clearer is active and supported. Within itself and the source that
    feeds its resource, the levels with its part admit everything the levels without it
    admit.
  - From the third step on, beyond that region, the dweller is admitted without the
    clearer's part and not with it (`Clearing.loses_beyond`).
  - Over the whole, the clearer's part narrows: it opens nothing and closes the dweller
    (`Clearing.narrows`).
  So a part can continue while closing what lies beyond its dependence.
* **Represented boundaries.** A formation's event is *within renewal over* a region of
  conditions when it is active and the step keeps every dependence on every condition of
  the region that it takes part in (`Web.RenewingOver`). Renewal at a step is renewal over
  every region (`Web.RenewingAt.over`, `Web.renewingAt_iff_over_all`), and renewal over a
  region is renewal over every region inside it (`Web.RenewingOver.narrow`). Compared with
  the formation's actual relations:
  - over a region covering every condition it takes part in, it is within renewal
    (`Web.RenewingOver.at`);
  - over a region covering every condition it requires, where its requirements do not
    tighten, it keeps its own support (`Web.RenewingOver.keeps_own`), yet it may still
    undermine another: the clearer renews over its resource at every step and undermines
    at step one (`Clearing.renewing_over_resource`, in `Becoming.Clearing`);
  - over a region omitting a condition it requires, its own draw can undermine its own
    dependence, and it loses its support while renewing over the region
    (`Omitted.loses_own`).

The region `Clearing.alongDependence` (`Becoming.Clearing`) is the clearer with the source that feeds the one
condition it requires. On formations it is the reach of the extent `Becoming.Continuation`
derives along dependence.

A region of conditions is a parameter of the statement. Nothing here models how a center
comes to represent it, and the region has no status outside the unfolding.

**AI reading, adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D20).**
- Regions of formations read as Ren's self, system and whole; a region of conditions reads
  as the boundary a center represents.
- These theorems order the criteria by strength. They do not say which criterion a
  formation should follow, and none licenses ending a part.
-/

namespace Becoming

variable {F C : Type}

/-! ## Nested regions -/

namespace Web

variable (W : Web F C)

/-- Within a region of formations, the levels `l` admit at `t` every formation the levels
`l'` admit there. -/
def AdmitsWithin (region : F → Prop) (l l' : C → Nat) (t : Nat) : Prop :=
  ∀ f, region f → W.Admits l' t f → W.Admits l t f

/-- Beyond a region of formations, some formation the levels `l'` admit at `t`, the levels
`l` do not. -/
def LosesBeyond (region : F → Prop) (l l' : C → Nat) (t : Nat) : Prop :=
  ∃ f, ¬ region f ∧ W.Admits l' t f ∧ ¬ W.Admits l t f

variable {W}

/-- Inclusion is admission within the whole at every step. -/
theorem includes_iff_within_whole {l l' : Nat → C → Nat} :
    W.Includes l l' ↔ ∀ t, W.AdmitsWithin (fun _ => True) (l t) (l' t) t :=
  ⟨fun includes t f _ => includes t f, fun within t f => within t f trivial⟩

/-- What holds within a region holds within every region inside it. -/
theorem AdmitsWithin.narrow {region region' : F → Prop} {l l' : C → Nat} {t : Nat}
    (inside : ∀ f, region' f → region f) (within : W.AdmitsWithin region l l' t) :
    W.AdmitsWithin region' l l' t :=
  fun f member => within f (inside f member)

/-- What is lost beyond a region is lost beyond every region inside it. -/
theorem LosesBeyond.narrow {region region' : F → Prop} {l l' : C → Nat} {t : Nat}
    (inside : ∀ f, region' f → region f) :
    W.LosesBeyond region l l' t → W.LosesBeyond region' l l' t
  | ⟨f, outside, admitted, lost⟩ => ⟨f, fun member => outside (inside f member), admitted, lost⟩

/-- Nothing lies beyond the whole. -/
theorem not_losesBeyond_whole {l l' : C → Nat} {t : Nat} :
    ¬ W.LosesBeyond (fun _ => True) l l' t
  | ⟨_, outside, _, _⟩ => outside trivial

/-- What holds within the whole leaves nothing lost beyond any region. -/
theorem AdmitsWithin.not_losesBeyond {l l' : C → Nat} {t : Nat}
    (whole : W.AdmitsWithin (fun _ => True) l l' t) (region : F → Prop) :
    ¬ W.LosesBeyond region l l' t
  | ⟨f, _, admitted, lost⟩ => lost (whole f trivial admitted)

/-- Within one formation, what holds is its own admission wherever `l'` admits it. -/
theorem admitsWithin_self {l l' : C → Nat} {t : Nat} {f : F} :
    W.AdmitsWithin (· = f) l l' t ↔ (W.Admits l' t f → W.Admits l t f) :=
  ⟨fun within => within f rfl, fun own g same => match g, same with
    | _, rfl => own⟩

/-! ## The generative space, with no axiom

Ren, 11 October 2026: “for anything, its continuation into the future leads to more
futures(flourishes/plurality) from generatively”, read as “these are space where generatively
happens”. Two level paths are compared by what can form along them; no significance, standpoint
or boundary enters. -/

variable (W)

/-- The level path `l` widens `l'`: it admits every formation `l'` admits and, at some step, one
more. A part whose levels widen those without it is generative. Widening counts admissions of
members of the fixed type `F` at the needs the web gives: a formation or requirement of a kind not
in `F` widens nothing, so growth by new kinds (as along `Flow.GrownBy`) is not compared here. -/
def Widens (l l' : Nat → C → Nat) : Prop :=
  W.Includes l l' ∧ W.Exceeds l l'

/-- The level paths `l` and `l'` keep what can form the same: each admits what the other admits. -/
def Keeps (l l' : Nat → C → Nat) : Prop :=
  W.Includes l l' ∧ W.Includes l' l

/-- The level paths `l` and `l'` are mixed: each admits, at some step, a formation the other does
not. -/
def Mixed (l l' : Nat → C → Nat) : Prop :=
  W.Exceeds l l' ∧ W.Exceeds l' l

variable {W}

/-! ### The comparison on the grammar

Including and exceeding are the grammar's (`«则»`, `«逾»`) at what the paths admit
(`Web.admitted`, `Web.includes_iff`, `Web.exceeds_iff` of `Becoming.Admission`); so are widening,
keeping and being mixed (`«广»`, `«齐»`, `«杂»` of `Becoming.GrammarLaws`), both ways, with no
hypothesis, and the laws of the four cases below are the grammar's order laws there. -/

/-- **Widening is the grammar's widening** of what the paths admit. -/
theorem widens_iff {l l' : Nat → C → Nat} : W.Widens l l' ↔ «广» (W.admitted l) (W.admitted l') :=
  ⟨fun ⟨includes, exceeds⟩ => ⟨includes_iff.mp includes, exceeds_iff.mp exceeds⟩,
   fun ⟨inside, exceeds⟩ => ⟨includes_iff.mpr inside, exceeds_iff.mpr exceeds⟩⟩

/-- **Keeping the same is the grammar's.** -/
theorem keeps_iff {l l' : Nat → C → Nat} : W.Keeps l l' ↔ «齐» (W.admitted l) (W.admitted l') :=
  ⟨fun ⟨one, other⟩ => ⟨includes_iff.mp other, includes_iff.mp one⟩,
   fun ⟨one, other⟩ => ⟨includes_iff.mpr other, includes_iff.mpr one⟩⟩

/-- **Being mixed is the grammar's.** -/
theorem mixed_iff {l l' : Nat → C → Nat} : W.Mixed l l' ↔ «杂» (W.admitted l) (W.admitted l') :=
  ⟨fun ⟨one, other⟩ => ⟨exceeds_iff.mp one, exceeds_iff.mp other⟩,
   fun ⟨one, other⟩ => ⟨exceeds_iff.mpr one, exceeds_iff.mpr other⟩⟩

/-- Widening goes one way (`«广不可逆»`). -/
theorem Widens.not_reverse {l l' : Nat → C → Nat} (widens : W.Widens l l') : ¬ W.Widens l' l :=
  fun back => «广不可逆» (widens_iff.mp widens) (widens_iff.mp back)

/-- Widening is transitive (`«广之传递»`). -/
theorem Widens.trans {l l' l'' : Nat → C → Nat} (first : W.Widens l l') (second : W.Widens l' l'') :
    W.Widens l l'' :=
  widens_iff.mpr («广之传递» (widens_iff.mp first) (widens_iff.mp second))

/-- Keeping the same is symmetric (`«齐之对称»`). -/
theorem Keeps.symm {l l' : Nat → C → Nat} (keeps : W.Keeps l l') : W.Keeps l' l :=
  keeps_iff.mpr («齐之对称» (keeps_iff.mp keeps))

/-- Being mixed is symmetric (`«杂之对称»`). -/
theorem Mixed.symm {l l' : Nat → C → Nat} (mixed : W.Mixed l l') : W.Mixed l' l :=
  mixed_iff.mpr («杂之对称» (mixed_iff.mp mixed))

/-- Widening is not keeping the same (`«广则非齐»`). -/
theorem Widens.not_keeps {l l' : Nat → C → Nat} (widens : W.Widens l l') : ¬ W.Keeps l l' :=
  fun keeps => «广则非齐» (widens_iff.mp widens) (keeps_iff.mp keeps)

/-- Widening is not mixed (`«广则非杂»`). -/
theorem Widens.not_mixed {l l' : Nat → C → Nat} (widens : W.Widens l l') : ¬ W.Mixed l l' :=
  fun mixed => «广则非杂» (widens_iff.mp widens) (mixed_iff.mp mixed)

/-- Keeping the same is not mixed (`«齐则非杂»`). -/
theorem Keeps.not_mixed {l l' : Nat → C → Nat} (keeps : W.Keeps l l') : ¬ W.Mixed l l' :=
  fun mixed => «齐则非杂» (keeps_iff.mp keeps) (mixed_iff.mp mixed)

/-- The whole first. The comparison over the whole is the comparison within every region at
once: `l` includes `l'` exactly when, at every step and within every region, it admits what `l'`
admits there. A region's comparison takes the region as an input; the whole's takes none. -/
theorem includes_iff_within_every {l l' : Nat → C → Nat} :
    W.Includes l l' ↔ ∀ (region : F → Prop) t, W.AdmitsWithin region (l t) (l' t) t :=
  ⟨fun includes _ t f _ admits => includes t f admits,
   fun within t f admits => within (fun _ => True) t f trivial admits⟩

/-! ## Represented boundaries -/

variable (W)

/-- A formation's event at `t` is within renewal over a region of conditions: it is active,
and the step keeps every dependence on every condition of the region it takes part in. -/
def RenewingOver (region : C → Prop) (t : Nat) (f : F) : Prop :=
  W.active t f ∧ ∀ c, region c → W.Participates t f c → ∀ g, W.requires t g c → W.Kept t g c

variable {W}

/-- An event within renewal is within renewal over every region. -/
theorem RenewingAt.over {t : Nat} {f : F} (renewing : W.RenewingAt t f) (region : C → Prop) :
    W.RenewingOver region t f :=
  ⟨renewing.1, fun c _ joins => renewing.2 c joins⟩

/-- Over a region covering every condition the formation takes part in, renewal over the
region is renewal at the step. -/
theorem RenewingOver.at {region : C → Prop} {t : Nat} {f : F}
    (covers : ∀ c, W.Participates t f c → region c) (renewing : W.RenewingOver region t f) :
    W.RenewingAt t f :=
  ⟨renewing.1, fun c joins => renewing.2 c (covers c joins) joins⟩

/-- Renewal at a step is renewal over every condition. -/
theorem renewingAt_iff_over_all {t : Nat} {f : F} :
    W.RenewingAt t f ↔ W.RenewingOver (fun _ => True) t f :=
  ⟨fun renewing => renewing.over _, fun renewing => renewing.at fun _ _ => trivial⟩

/-- Renewal over a region is renewal over every region inside it. -/
theorem RenewingOver.narrow {region region' : C → Prop} {t : Nat} {f : F}
    (inside : ∀ c, region' c → region c) (renewing : W.RenewingOver region t f) :
    W.RenewingOver region' t f :=
  ⟨renewing.1, fun c member => renewing.2 c (inside c member)⟩

/-- Its own support kept. Over a region covering every condition the formation requires,
where its requirements do not tighten across the step, a formation renewing over the region
is supported after the step. -/
theorem RenewingOver.keeps_own {region : C → Prop} {t : Nat} {f : F}
    (covers : ∀ c, W.requires t f c → region c) (untightened : W.Untightened t f)
    (renewing : W.RenewingOver region t f) : W.Supported (t + 1) f :=
  fun c requires => match untightened c requires with
  | ⟨had, need⟩ => Nat.le_trans need (renewing.2 c (covers c had) (Or.inl had) f had).2

end Web

/-! A represented region omitting a requirement: one formation requires two conditions,
and across the first step it draws on the one its region omits. -/

namespace Omitted

/-- Across the first step the formation takes the unit of `true`. -/
def flow : Flow Unit Bool where
  present _ := [()]
  take t _ c := match t, c with
    | 0, true => 1
    | 0, false => 0
    | _ + 1, _ => 0
  give _ _ _ := 0

/-- The formation requires both conditions at need one and is active at the first step. -/
def web : Web Unit Bool where
  level t c := match c with
    | false => 1
    | true => unitDrop t
  active t _ := match t with
    | 0 => True
    | _ + 1 => False
  requires _ _ _ := True
  need _ _ _ := 1
  draws t _ c := match t, c with
    | 0, true => True
    | 0, false => False
    | _ + 1, _ => False

/-- Renewing over a region that omits a requirement. Across the first step the formation is
within renewal over `false`, and its requirements do not tighten. It also requires `true`,
which the region omits, and its own draw on `true` undermines. After the step it is not
supported. -/
theorem loses_own :
    flow.Balances web ∧ flow.Acting web ∧ flow.Taking web ∧ web.Dependent ∧
      web.RenewingOver (· = false) 0 () ∧ web.Untightened 0 () ∧ web.requires 0 () true ∧
      web.UnderminingAt 0 () ∧ ¬ web.Supported 1 () :=
  ⟨fun t c => match t, c with
    | 0, false => rfl
    | 0, true => rfl
    | _ + 1, false => rfl
    | _ + 1, true => rfl,
   fun _ _ _ _ gives => absurd gives (Nat.lt_irrefl 0),
   fun t _ c _ takes => match t, c, takes with
    | 0, true, _ => ⟨trivial, trivial⟩
    | 0, false, takes => absurd takes (Nat.lt_irrefl 0)
    | _ + 1, _, takes => absurd takes (Nat.lt_irrefl 0),
   fun t _ active c _ => match t, active, c with
    | 0, _, false => Nat.le_refl 1
    | 0, _, true => Nat.le_refl 1
    | _ + 1, no, _ => (nomatch no),
   ⟨trivial, fun c same => match c, same with
    | _, rfl => fun _ _ _ => ⟨Nat.le_refl 1, Nat.le_refl 1⟩⟩,
   fun _ _ => ⟨trivial, Nat.le_refl 1⟩, trivial,
   ⟨true, trivial, (), trivial,
    Web.MetAbove.now (W := web) (t := 0) (g := ()) (c := true) trivial (Nat.le_refl 1)
      Nat.zero_lt_one,
    Nat.zero_lt_one⟩,
   fun supported => Nat.not_succ_le_zero 0 (supported true trivial)⟩

end Omitted

end Becoming
