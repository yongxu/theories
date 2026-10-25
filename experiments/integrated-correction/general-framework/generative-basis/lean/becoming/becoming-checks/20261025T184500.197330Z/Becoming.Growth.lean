import Becoming.Regions

/-!
# Growth: widening along a reading, and over a grown world

`Web.Widens` compares two level paths of one web: which members of its fixed type of formations
`F` they admit at the web's needs. A course that brings about a formation of a kind not in `F`, or
a requirement on a condition not in `C`, widens nothing on that measure (§6.1). Comparing a world
with the world it grows into needs a reading of the first world's formations in the second's. This
module states widening along such a reading and the exact law of widening over a grown world. No
condition, ranking or axiom occurs.

* **Widening along a reading.** For webs `W` on `F`, `C` and `W'` on `F'`, `C'`, a map
  `e : F → F'` reading each formation of the first in the second, and level paths `l` of the first
  and `l'` of the second, `l'` includes `l` along `e` where every formation `l` admits is, read,
  admitted by `l'` (`Web.IncludesAlong`), exceeds it where `l'` admits a formation that is the
  reading of none `l` admits (`Web.ExceedsAlong`), and widens it where both hold
  (`Web.WidensAlong`). Along the identity these are `Web.Includes`, `Web.Exceeds` and
  `Web.Widens` exactly (`Web.widensAlong_id_iff`). Inclusion composes along readings
  (`Web.IncludesAlong.comp`); widening composes where the later step widens
  (`Web.IncludesAlong.widensAlong_comp`) or where the later reading is one to one
  (`Web.WidensAlong.comp`).
* **A grown world.** A growth (`Web.Growth`) adds formations `N` and conditions `D` to a web:
  the new formations are active, require, need and draw as it says, the old formations may draw
  on the new conditions, and the old formations' requirements are not changed (`Web.grow`). An
  old formation is admitted in the grown web exactly where it is admitted by the old levels
  (`Web.grow_admits_old`).
* **Widening over a grown world, exactly.** The grown web at `l'` widens the old web at `l` along
  the inclusion exactly where the old levels of `l'` include `l` and either exceed it or admit
  some new formation at some step (`Web.grow_widensAlong_iff`). So a growth that leaves the old
  levels as they were widens exactly where a new formation is admitted at some step
  (`Web.grow_widensAlong_iff_new`), while on the old formations nothing widens
  (`Web.grow_widens_unregistered`). Attaching one formation by one new condition, as an entry of
  `Flow.GrownBy` does, widens exactly where the new condition meets the new formation's need at
  some step (`Web.attach_widensAlong_iff`).
-/

namespace Becoming

namespace Web

variable {F C F' C' F'' C'' : Type}

/-! ## Widening along a reading -/

section Along

variable (W : Web F C) (W' : Web F' C')

/-- **Inclusion along a reading.** Every formation the levels `l` of `W` admit is, read by `e`,
admitted by the levels `l'` of `W'` at the same step. -/
def IncludesAlong (e : F → F') (l : Nat → C → Nat) (l' : Nat → C' → Nat) : Prop :=
  ∀ t f, W.Admits (l t) t f → W'.Admits (l' t) t (e f)

/-- **Exceeding along a reading.** At some step the levels `l'` of `W'` admit a formation that is
the reading of no formation the levels `l` of `W` admit. -/
def ExceedsAlong (e : F → F') (l : Nat → C → Nat) (l' : Nat → C' → Nat) : Prop :=
  ∃ t g, W'.Admits (l' t) t g ∧ ∀ f, e f = g → ¬ W.Admits (l t) t f

/-- **Widening along a reading**: `l'` of `W'` includes `l` of `W` along `e` and exceeds it. -/
def WidensAlong (e : F → F') (l : Nat → C → Nat) (l' : Nat → C' → Nat) : Prop :=
  W.IncludesAlong W' e l l' ∧ W.ExceedsAlong W' e l l'

variable {W W'}

/-- Along the identity, inclusion is inclusion. -/
theorem includesAlong_id_iff {l l' : Nat → C → Nat} :
    W.IncludesAlong W id l l' ↔ W.Includes l' l :=
  Iff.rfl

/-- Along the identity, exceeding is exceeding. -/
theorem exceedsAlong_id_iff {l l' : Nat → C → Nat} :
    W.ExceedsAlong W id l l' ↔ W.Exceeds l' l :=
  ⟨fun ⟨t, g, admitted, beyond⟩ => ⟨t, g, admitted, beyond g rfl⟩,
   fun ⟨t, g, admitted, not⟩ => ⟨t, g, admitted, fun _ same held => not (same ▸ held)⟩⟩

/-- **Along the identity, widening along a reading is widening.** -/
theorem widensAlong_id_iff {l l' : Nat → C → Nat} :
    W.WidensAlong W id l l' ↔ W.Widens l' l :=
  ⟨fun widens => ⟨widens.1, exceedsAlong_id_iff.mp widens.2⟩,
   fun widens => ⟨widens.1, exceedsAlong_id_iff.mpr widens.2⟩⟩

variable {W'' : Web F'' C''} {e : F → F'} {e' : F' → F''} {l : Nat → C → Nat}
  {l' : Nat → C' → Nat} {l'' : Nat → C'' → Nat}

/-- Inclusion along readings composes. -/
theorem IncludesAlong.comp (first : W.IncludesAlong W' e l l')
    (second : W'.IncludesAlong W'' e' l' l'') : W.IncludesAlong W'' (e' ∘ e) l l'' :=
  fun t f admitted => second t (e f) (first t f admitted)

/-- **Widening composes where the later step widens.** If `l'` includes `l` along `e` and `l''`
widens `l'` along `e'`, then `l''` widens `l` along the composite reading. -/
theorem IncludesAlong.widensAlong_comp (first : W.IncludesAlong W' e l l')
    (second : W'.WidensAlong W'' e' l' l'') : W.WidensAlong W'' (e' ∘ e) l l'' :=
  ⟨first.comp second.1, match second.2 with
    | ⟨t, g, admitted, beyond⟩ =>
      ⟨t, g, admitted, fun f same held => beyond (e f) same (first t f held)⟩⟩

/-- **Widening composes along a one-to-one later reading.** If `l'` widens `l` along `e`, `l''`
includes `l'` along `e'`, and `e'` reads distinct formations as distinct, then `l''` widens `l`
along the composite reading. -/
theorem WidensAlong.comp (first : W.WidensAlong W' e l l')
    (second : W'.IncludesAlong W'' e' l' l'')
    (oneToOne : ∀ g g', e' g = e' g' → g = g') : W.WidensAlong W'' (e' ∘ e) l l'' :=
  ⟨first.1.comp second, match first.2 with
    | ⟨t, g, admitted, beyond⟩ =>
      ⟨t, e' g, second t g admitted, fun f same held => beyond f (oneToOne _ _ same) held⟩⟩

end Along

/-! ## A grown world -/

variable {N D : Type}

/-- **A growth of a web by new formations `N` and new conditions `D`**: the new conditions'
levels, how the new formations are active, require, need and draw on any condition, and how the
old formations draw on the new conditions. The old formations' requirements are not changed. -/
structure Growth (F N D : Type) (C : Type) where
  level : Nat → D → Nat
  active : Nat → N → Prop
  requires : Nat → N → C ⊕ D → Prop
  need : Nat → N → C ⊕ D → Nat
  draws : Nat → N → C ⊕ D → Prop
  drawsNew : Nat → F → D → Prop

/-- **The grown web**: the old web on the old formations and conditions, the growth on the new.
An old formation requires only old conditions, as it did. -/
def grow (W : Web F C) (X : Growth F N D C) : Web (F ⊕ N) (C ⊕ D) where
  level t c := match c with
    | .inl c => W.level t c
    | .inr d => X.level t d
  active t f := match f with
    | .inl f => W.active t f
    | .inr n => X.active t n
  requires t f c := match f, c with
    | .inl f, .inl c => W.requires t f c
    | .inl _, .inr _ => False
    | .inr n, c => X.requires t n c
  need t f c := match f, c with
    | .inl f, .inl c => W.need t f c
    | .inl _, .inr _ => 0
    | .inr n, c => X.need t n c
  draws t f c := match f, c with
    | .inl f, .inl c => W.draws t f c
    | .inl f, .inr d => X.drawsNew t f d
    | .inr n, c => X.draws t n c

/-- The old conditions' levels of a level path of the grown web. -/
def oldLevels (l' : Nat → C ⊕ D → Nat) : Nat → C → Nat :=
  fun t c => l' t (.inl c)

variable {W : Web F C} {X : Growth F N D C} {l : Nat → C → Nat} {l' : Nat → C ⊕ D → Nat}

/-- **An old formation is admitted in the grown web exactly as by the old levels.** -/
theorem grow_admits_old {t : Nat} {f : F} :
    (W.grow X).Admits (l' t) t (.inl f) ↔ W.Admits (oldLevels l' t) t f :=
  ⟨fun admitted c requires => admitted (.inl c) requires,
   fun admitted c => match c with
    | .inl c => fun requires => admitted c requires
    | .inr _ => fun no => False.elim no⟩

/-- Inclusion along the inclusion of the old formations is inclusion by the old levels. -/
theorem grow_includesAlong_iff :
    W.IncludesAlong (W.grow X) Sum.inl l l' ↔ W.Includes (oldLevels l') l :=
  ⟨fun includes t f admitted => grow_admits_old.mp (includes t f admitted),
   fun includes t f admitted => grow_admits_old.mpr (includes t f admitted)⟩

/-- **Widening over a grown world, exactly.** The grown web at `l'` widens the old web at `l` along
the inclusion of the old formations exactly where the old levels of `l'` include `l`, and either
they exceed `l` or `l'` admits some new formation at some step. -/
theorem grow_widensAlong_iff :
    W.WidensAlong (W.grow X) Sum.inl l l' ↔
      W.Includes (oldLevels l') l ∧
        (W.Exceeds (oldLevels l') l ∨ ∃ t n, (W.grow X).Admits (l' t) t (.inr n)) :=
  ⟨fun ⟨includes, exceeds⟩ => ⟨grow_includesAlong_iff.mp includes, match exceeds with
    | ⟨t, .inl f, admitted, beyond⟩ => .inl ⟨t, f, grow_admits_old.mp admitted, beyond f rfl⟩
    | ⟨t, .inr n, admitted, _⟩ => .inr ⟨t, n, admitted⟩⟩,
   fun ⟨includes, exceeds⟩ => ⟨grow_includesAlong_iff.mpr includes, match exceeds with
    | .inl ⟨t, f, admitted, not⟩ => ⟨t, .inl f, grow_admits_old.mpr admitted,
        fun _ same held => not (Sum.inl.inj same ▸ held)⟩
    | .inr ⟨t, n, admitted⟩ => ⟨t, .inr n, admitted, fun _ same _ => nomatch same⟩⟩⟩

/-- **A growth that leaves the old levels as they were widens exactly where a new formation is
admitted.** -/
theorem grow_widensAlong_iff_new (keep : ∀ t c, l' t (.inl c) = l t c) :
    W.WidensAlong (W.grow X) Sum.inl l l' ↔ ∃ t n, (W.grow X).Admits (l' t) t (.inr n) :=
  have back : W.Includes l (oldLevels l') := fun t _ admitted c requires =>
    Nat.le_trans (admitted c requires) (Nat.le_of_eq (keep t c))
  have forth : W.Includes (oldLevels l') l := fun t _ admitted c requires =>
    Nat.le_trans (admitted c requires) (Nat.le_of_eq (keep t c).symm)
  ⟨fun widens => match (grow_widensAlong_iff.mp widens).2 with
    | .inl exceeds => absurd exceeds back.not_exceeded
    | .inr added => added,
   fun added => grow_widensAlong_iff.mpr ⟨forth, .inr added⟩⟩

/-- **A widening the old formations alone do not show.** Where a growth leaves the old
levels as they were and admits a new formation at some step, the grown web widens the old along
the inclusion, while on the old formations the levels neither widen nor narrow. -/
theorem grow_widens_unregistered (keep : ∀ t c, l' t (.inl c) = l t c)
    (added : ∃ t n, (W.grow X).Admits (l' t) t (.inr n)) :
    W.WidensAlong (W.grow X) Sum.inl l l' ∧ ¬ W.Widens (oldLevels l') l ∧
      ¬ W.Widens l (oldLevels l') :=
  have back : W.Includes l (oldLevels l') := fun t _ admitted c requires =>
    Nat.le_trans (admitted c requires) (Nat.le_of_eq (keep t c))
  have forth : W.Includes (oldLevels l') l := fun t _ admitted c requires =>
    Nat.le_trans (admitted c requires) (Nat.le_of_eq (keep t c).symm)
  ⟨(grow_widensAlong_iff_new keep).mpr added, fun widens => back.not_exceeded widens.2,
   fun widens => forth.not_exceeded widens.2⟩

/-! ## Attaching one formation by one new condition -/

/-- **Attaching one formation by one new condition**, as an entry `(p, n)` of `Flow.GrownBy`
does: the new formation requires only the new condition, at need `k`, draws on it, and is active
where the condition's level meets its need; the old formation `p` draws on the new condition. -/
def attach (p : F) (k : Nat) (level : Nat → Nat) : Growth F Unit Unit C where
  level t _ := level t
  active t _ := k ≤ level t
  requires _ _ c := match c with
    | .inl _ => False
    | .inr _ => True
  need _ _ _ := k
  draws _ _ c := match c with
    | .inl _ => False
    | .inr _ => True
  drawsNew _ f _ := f = p

/-- **An attachment widens exactly where the new condition meets the new formation's need.** With
the old levels as they were, the grown web widens the old along the inclusion exactly where, at
some step, the new condition's level reaches `k`. -/
theorem attach_widensAlong_iff {p : F} {k : Nat} {level : Nat → Nat}
    {m : Nat → C ⊕ Unit → Nat} (keep : ∀ t c, m t (.inl c) = l t c) :
    W.WidensAlong (W.grow (attach p k level)) Sum.inl l m ↔ ∃ t, k ≤ m t (.inr ()) :=
  (grow_widensAlong_iff_new keep).trans
    ⟨fun ⟨t, _, admitted⟩ => ⟨t, admitted (.inr ()) trivial⟩,
     fun ⟨t, meets⟩ => ⟨t, (), fun c => match c with
      | .inl _ => fun no => False.elim no
      | .inr () => fun _ => meets⟩⟩

end Web

end Becoming
