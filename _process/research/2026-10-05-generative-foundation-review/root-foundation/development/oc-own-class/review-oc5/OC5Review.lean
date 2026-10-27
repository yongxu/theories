/-! OC5 review scratch. The grammar's definitions and OC5's declarations are copied verbatim from the
worktree (branch oc5) by gen.py; only Init is imported. The checks follow, then `#print axioms`. -/

namespace Scratch

universe u

section Path

variable {α : Type u}

/-- A relation on a carrier: the grammar's one kind of symbol (际). -/
abbrev «际» (α : Type u) : Type u := α → α → Prop

/-- Sequential composition (而): first `R`, then `S`. -/
def «而» (R S : «际» α) : «际» α := fun x z => ∃ y, R x y ∧ S y z

/-- Converse (逆). -/
def «逆» (R : «际» α) : «际» α := fun x y => R y x

/-- Inclusion (则): whatever `R` relates, `S` relates. -/
def «则» (R S : «际» α) : Prop := ∀ x y, R x y → S x y

/-- Meet (合): related by both. -/
def «合» (R S : «际» α) : «际» α := fun x y => R x y ∧ S x y

/-- The full relation (一). -/
def «一» : «际» α := fun _ _ => True

/-- Reach (及): the transitive closure of a relation; each witness is a finite chain of steps. -/
inductive «及» (R : «际» α) : «际» α
  | one {x y : α} : R x y → «及» R x y
  | more {x y z : α} : R x y → «及» R y z → «及» R x z

/-- A class (类): a reflexive, symmetric, transitive relation. It is plural: the 墨经 names four
kinds of sameness, each one class. -/
structure «类» (E : «际» α) : Prop where
  refl : ∀ x, E x x
  symm : ∀ {x y}, E x y → E y x
  trans : ∀ {x y z}, E x y → E y z → E x z

theorem «及之传递» {R : «际» α} {x y z : α} (h₁ : «及» R x y) (h₂ : «及» R y z) :
    «及» R x z := by
  induction h₁ with
  | one h => exact .more h h₂
  | more h _ ih => exact .more h (ih h₂)

theorem «及之单调» {R S : «际» α} (h : «则» R S) : «则» («及» R) («及» S) := by
  intro x y hr
  induction hr with
  | one h' => exact .one (h _ _ h')
  | more h' _ ih => exact .more (h _ _ h') ih

/-- Continuation (续): `y` continues `x` under the class `E` when `x` is a condition of `y`
(`R x y`, read as 缘) and the two are alike under `E`. The criterion is `E`; no other choice
enters. -/
def «续» (R E : «际» α) : «际» α := «合» R E

/-- A line of continuation (相续): the transitive closure of `«续»`. -/
def «相续» (R E : «际» α) : «际» α := «及» («续» R E)

/-- `x` has a successor in a line under `E`. -/
def «有后» (R E : «际» α) (x : α) : Prop := ∃ y, «续» R E x y

/-- Ends (亡): nothing continues it. -/
def «亡» (R E : «际» α) (x : α) : Prop := ¬ «有后» R E x

/-- `E` is constant under `R` (有常): `E˘;R ⊆ R;E˘`. Whatever an `E`-mate of `x` becomes, `x`
becomes something `E`-alike to it. -/
def «有常» (R E : «际» α) : Prop := «则» («而» («逆» E) R) («而» R («逆» E))

/-- The pointwise form of constancy. -/
theorem «有常之逐点» (R E : «际» α) :
    «有常» R E ↔ ∀ u u', E u u' → ∀ v, R u v → ∃ v', R u' v' ∧ E v v' := by
  constructor
  · intro h u u' he v hr
    match h u' v ⟨u, he, hr⟩ with
    | ⟨v', hr', he'⟩ => exact ⟨v', hr', he'⟩
  · intro h x z ⟨y, he, hr⟩
    match h y x he z hr with
    | ⟨v', hr', he'⟩ => exact ⟨v', hr', he'⟩

/-- A line (相续) under a class stays within the class: its ends are alike. -/
theorem «线内同类» {R E : «际» α} (hE : «类» E) {x y : α}
    (line : «相续» R E x y) : E x y := by
  induction line with
  | one c => exact c.2
  | more c _ ih => exact hE.trans c.2 ih

/-- Reached on the coarse line from `x`: `x` itself or what the line reaches. -/
def «所及» (R L : «际» α) (x y : α) : Prop := x = y ∨ «相续» R L x y

/-- A member's effects are *held* by a relation where everything it conditions is alike to it
(所缘同于). This is a property of one member, not the constancy of a coarse net that
`«闭合当且仅当有常»` calls closure. -/
def «所缘同于» (R E : «际» α) (m : α) : Prop := ∀ v, R m v → E m v

/-- **Where everything downstream is alike, everything downstream lies on the line (后皆同类则后皆续).** Where
everything downstream of `c` is alike to it under a class, everything downstream of `c` lies on a line under the
class from `c`; no regularity is assumed. -/
theorem «后皆同类则后皆续» {R E : «际» α} (hE : «类» E) {c t : α} (all : ∀ s, «及» R c s → E c s)
    (down : «及» R c t) : «相续» R E c t := by
  induction down with
  | one step => exact .one ⟨step, all _ (.one step)⟩
  | @more a b _ step _ ih =>
    have ab : E a b := all b (.one step)
    exact .more ⟨step, ab⟩ (ih (fun s rest => hE.trans (hE.symm ab) (all s (.more step rest))))

/-- **Everything downstream of a member lies on its line under a class exactly where everything downstream
of it is alike to it (后皆续当且仅当后皆同类).** No regularity is assumed: the forward direction is that a
line under a class stays in it (`«线内同类»`), the backward one `«后皆同类则后皆续»`. -/
theorem «后皆续当且仅当后皆同类» {R E : «际» α} (hE : «类» E) {m : α} :
    (∀ t, «及» R m t → «所及» R E m t) ↔ (∀ t, «及» R m t → E m t) :=
  ⟨fun reach t down => match reach t down with
     | .inl e => e ▸ hE.refl m
     | .inr line => «线内同类» hE line,
   fun all _ down => .inr («后皆同类则后皆续» hE all down)⟩

/-- **Where everything downstream of a member lies on its line under a class, the class holds the member's
effects (后皆续则所缘同于).** The one-step case of `«后皆续当且仅当后皆同类»`. -/
theorem «后皆续则所缘同于» {R E : «际» α} (hE : «类» E) {m : α}
    (reach : ∀ t, «及» R m t → «所及» R E m t) : «所缘同于» R E m :=
  fun v step => («后皆续当且仅当后皆同类» hE).mp reach v (.one step)

/-- **Everything downstream of a member is alike to it exactly where the class holds the effects of the member
and of everything downstream of it (后皆同类当且仅当自与后皆闭).** No regularity is assumed. -/
theorem «后皆同类当且仅当自与后皆闭» {R E : «际» α} (hE : «类» E) {m : α} :
    (∀ t, «及» R m t → E m t) ↔ «所缘同于» R E m ∧ ∀ t, «及» R m t → «所缘同于» R E t :=
  ⟨fun all => ⟨fun v step => all v (.one step),
     fun t down v step => hE.trans (hE.symm (all t down)) (all v («及之传递» down (.one step)))⟩,
   fun both t down => by
     induction down with
     | one step => exact both.1 _ step
     | @more a b _ step _ ih =>
       exact hE.trans (both.1 b step) (ih ⟨both.2 b (.one step), fun s rest => both.2 s (.more step rest)⟩)⟩

/-- **Constancy up to the net's end (至终有常).** Whatever an alike occurrence conditions, this one
conditions something alike to it, unless this one conditions nothing at all; so a line under the class
ends only at an occurrence that conditions nothing. -/
def «至终有常» (R E : «际» α) : Prop :=
  ∀ u u', E u u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w

/-- **Constancy up to the net's end at a member's class (本类至终有常).** Whatever an occurrence alike to
the member conditions, every occurrence alike to the member conditions something alike to it, unless that
occurrence conditions nothing at all. It is `«至终有常»` asked only of the occurrences alike to the member:
it asks nothing of what occurrences outside the member's class condition, but how what lies outside is
divided enters through "alike to it", for an effect that leaves the class (`«外分唯系出类之同»`,
`FinerOutside`). -/
def «本类至终有常» (R E : «际» α) (m : α) : Prop :=
  ∀ u u', E m u → E m u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w

/-- Constancy up to the net's end gives it at every member's class. -/
theorem «至终有常则本类至终有常» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) (m : α) :
    «本类至终有常» R E m :=
  fun u u' mu mu' => constant u u' (hE.trans (hE.symm mu) mu')

/-- **At a member's class, whatever is alike to a member that conditions something, and whose effects the
class holds, conditions only what is alike to it.** -/
theorem «本类常闭则所缘同类» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m)
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m :=
  match atClass u m (hE.symm alike) (hE.refl m) v step with
  | .inl ⟨v', hv', ev⟩ => hE.trans ev (hE.symm (held v' hv'))
  | .inr stops => match goes with
    | ⟨w, hw⟩ => absurd hw (stops w)

/-- **A regularity that holds a member's effects takes in all that follows (常闭则后皆续), at the member's
class.** Under a class constant up to the net's end at a member's class, everything downstream of anything
alike to the member, where the member conditions something and the class holds its effects, is alike to it
and so lies on a line under the class from there (`«后皆同类则后皆续»`). That the member conditions something
is needed where the start is another occurrence alike to it. -/
theorem «本类常闭则后皆续» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m)
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) :
    E t m ∧ «相续» R E c t :=
  have after : ∀ {a s : α}, E a m → «及» R a s → E s m := fun am d => by
    induction d with
    | one step => exact «本类常闭则所缘同类» hE atClass goes held am step
    | more step _ ih => exact ih («本类常闭则所缘同类» hE atClass goes held am step)
  ⟨after alike down, «后皆同类则后皆续» hE (fun _ d => hE.trans alike (hE.symm (after alike d))) down⟩

/-- **At a member's class, the class holds the member's effects exactly where everything downstream of
the member is alike to it.** The backward direction is the one-step case; the forward direction is where
the condition at the member's class does its work. -/
theorem «本类常则闭当且仅当后皆同类» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) :
    «所缘同于» R E m ↔ ∀ t, «及» R m t → E m t :=
  ⟨fun held _ down =>
     match down with
     | .one step => hE.symm («本类常闭则后皆续» hE atClass ⟨_, step⟩ held (hE.refl m) (.one step)).1
     | .more step rest =>
       hE.symm («本类常闭则后皆续» hE atClass ⟨_, step⟩ held (hE.refl m) (.more step rest)).1,
   fun all v step => all v (.one step)⟩

/-- **Where the member conditions something, the condition at its class is that it and each alike occurrence
follow each other (本类常当且仅当与己相随).** Constancy up to the net's end at `m`'s class holds exactly where
whatever an occurrence alike to `m` conditions is alike to something `m` conditions, and whatever `m` conditions,
each occurrence alike to `m` conditions something alike to it, unless that occurrence conditions nothing. -/
theorem «本类常当且仅当与己相随» {R E : «际» α} (hE : «类» E) {m : α} (goes : ∃ w, R m w) :
    «本类至终有常» R E m ↔
      (∀ u v, E m u → R u v → ∃ w, R m w ∧ E v w) ∧
        (∀ u w, E m u → R m w → (∃ v, R u v ∧ E w v) ∨ ∀ z, ¬ R u z) :=
  ⟨fun atClass =>
     ⟨fun u v mu step => match atClass u m mu (hE.refl m) v step with
        | .inl found => found
        | .inr stops => match goes with
          | ⟨w, hw⟩ => absurd hw (stops w),
      fun u w mu step => atClass m u (hE.refl m) mu w step⟩,
   fun ⟨toSelf, fromSelf⟩ u u' mu mu' v step => match toSelf u v mu step with
     | ⟨w, hw, vw⟩ => match fromSelf u' w mu' hw with
       | .inl ⟨v', hv', wv'⟩ => .inl ⟨v', hv', hE.trans vw wv'⟩
       | .inr stops => .inr stops⟩

/-- **Where the member conditions something, how what lies outside is divided bears on the condition at its
class only through what is alike to its own effects that leave the class (外分唯系己出之同).** Where classes `E`
and `F` hold the same occurrences alike to `m`, `m` conditions something, and for each of `m`'s effects either it
is alike to `m` or `E` and `F` agree on what is alike to it, constancy up to the net's end at `m`'s class holds
under `E` exactly where it holds under `F`: the condition compares what each alike occurrence conditions only with
what `m` conditions (`«本类常当且仅当与己相随»`). -/
theorem «外分唯系己出之同» {R E F : «际» α} (hE : «类» E) (hF : «类» F) {m : α}
    (same : ∀ x, E m x ↔ F m x) (goes : ∃ w, R m w)
    (own : ∀ w x, R m w → E m w ∨ (E w x ↔ F w x)) :
    «本类至终有常» R E m ↔ «本类至终有常» R F m :=
  have agree : ∀ w x, R m w → (E w x ↔ F w x) := fun w x step =>
    match own w x step with
    | .inl mw =>
      ⟨fun ex => hF.trans (hF.symm ((same w).mp mw)) ((same x).mp (hE.trans mw ex)),
       fun fx => hE.trans (hE.symm mw) ((same x).mpr (hF.trans ((same w).mp mw) fx))⟩
    | .inr both => both
  ⟨fun atClass => match («本类常当且仅当与己相随» hE goes).mp atClass with
     | ⟨toSelf, fromSelf⟩ => («本类常当且仅当与己相随» hF goes).mpr
       ⟨fun u v fu step => match toSelf u v ((same u).mpr fu) step with
          | ⟨w, hw, vw⟩ => ⟨w, hw, hF.symm ((agree w v hw).mp (hE.symm vw))⟩,
        fun u w fu hw => match fromSelf u w ((same u).mpr fu) hw with
          | .inl ⟨v, hv, wv⟩ => .inl ⟨v, hv, (agree w v hw).mp wv⟩
          | .inr stops => .inr stops⟩,
   fun atClass => match («本类常当且仅当与己相随» hF goes).mp atClass with
     | ⟨toSelf, fromSelf⟩ => («本类常当且仅当与己相随» hE goes).mpr
       ⟨fun u v eu step => match toSelf u v ((same u).mp eu) step with
          | ⟨w, hw, vw⟩ => ⟨w, hw, hE.symm ((agree w v hw).mpr (hF.symm vw))⟩,
        fun u w eu hw => match fromSelf u w ((same u).mp eu) hw with
          | .inl ⟨v, hv, wv⟩ => .inl ⟨v, hv, (agree w v hw).mpr wv⟩
          | .inr stops => .inr stops⟩⟩

/-- **Where the class holds a member's effects, how what lies outside is divided is idle (闭则外分无关).**
Where classes `E` and `F` hold the same occurrences alike to `m`, and `m` conditions something, constancy up
to the net's end at `m`'s class, with the holding of `m`'s effects, under `E` gives both under `F`: none of
`m`'s effects leaves the class, so the division bears on nothing (`«外分唯系己出之同»`). -/
theorem «闭则外分无关» {R E F : «际» α} (hE : «类» E) (hF : «类» F) {m : α}
    (same : ∀ x, E m x ↔ F m x) (goes : ∃ w, R m w) (held : «所缘同于» R E m)
    (atClass : «本类至终有常» R E m) : «本类至终有常» R F m ∧ «所缘同于» R F m :=
  ⟨(«外分唯系己出之同» hE hF same goes (fun w _ step => .inl (held w step))).mp atClass,
   fun v step => (same v).mp (held v step)⟩

/-- **The split by a decided predicate (二分).** Two occurrences are alike where `P` gives both the same
value: the class of two blocks, what `P` marks and the rest. -/
def «二分» (P : α → Bool) : «际» α := fun x y => P x = P y

/-- The split is a class. -/
theorem «二分为类» (P : α → Bool) : «类» («二分» P) := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

end Path

namespace OtherLeaves

/-! A member `m` conditioning `v`, `v` conditioning `w`, and an occurrence `c` alike to `m` conditioning `x`;
`m`, `v`, `w` and `c` in one class, `x` in another. Everything downstream of the member is alike to it, so lies
on its line under the class, and the class holds its effects; but `m` conditions `v`, and `c` conditions only
`x`, which is not alike to `v`, so the class is not constant up to the net's end at the member's class, and
does not hold `c`'s effects. The regularity cannot be dropped (`Inconstant`) but is not needed for the reach. -/

inductive Occ | m | v | w | c | x

def step : «际» Occ
  | .m, .m => False
  | .m, .v => True
  | .m, .w => False
  | .m, .c => False
  | .m, .x => False
  | .v, .m => False
  | .v, .v => False
  | .v, .w => True
  | .v, .c => False
  | .v, .x => False
  | .w, .m => False
  | .w, .v => False
  | .w, .w => False
  | .w, .c => False
  | .w, .x => False
  | .c, .m => False
  | .c, .v => False
  | .c, .w => False
  | .c, .c => False
  | .c, .x => True
  | .x, .m => False
  | .x, .v => False
  | .x, .w => False
  | .x, .c => False
  | .x, .x => False

/-- The member's class, as against `x`. -/
def inClass : Occ → Bool
  | .m => true
  | .v => true
  | .w => true
  | .c => true
  | .x => false

/-- The member and what follows it: `m`, `v` and `w`. -/
def reached : Occ → Bool
  | .m => true
  | .v => true
  | .w => true
  | .c => false
  | .x => false

/-- A step from `m`, `v` or `w` stays among them. -/
theorem reached_step {a b : Occ} (r : step a b) (ra : reached a = true) : reached b = true := by
  cases a <;> cases b <;> first | rfl | exact False.elim r | exact Bool.noConfusion ra

/-- So does everything downstream of them. -/
theorem reached_after {a t : Occ} (down : «及» step a t) (ra : reached a = true) : reached t = true := by
  induction down with
  | one r => exact reached_step r ra
  | more r _ ih => exact ih (reached_step r ra)

/-- **Everything downstream of the member is alike to it.** -/
theorem all_alike : ∀ t, «及» step .m t → «二分» inClass .m t := fun t down =>
  match t, reached_after down rfl with
  | .m, _ => rfl
  | .v, _ => rfl
  | .w, _ => rfl
  | .c, e => Bool.noConfusion e
  | .x, e => Bool.noConfusion e

/-- **The class is not constant up to the net's end at the member's class**: `m` conditions `v`, and `c`,
alike to `m`, conditions only `x`, which is not alike to `v`. -/
theorem not_constant_at : ¬ «本类至终有常» step («二分» inClass) .m := fun atClass =>
  match atClass .m .c rfl rfl .v trivial with
  | .inl ⟨v', r, e⟩ => match v', r, e with
    | .x, _, e => Bool.noConfusion e
  | .inr stops => stops .x trivial

/-- **The occurrence alike to the member, off its line, does not have its effects held.** -/
theorem other_not_held : «二分» inClass .m .c ∧ ¬ «所缘同于» step («二分» inClass) .c :=
  ⟨rfl, fun held => Bool.noConfusion (held .x trivial)⟩

/-- **Without the condition at the member's class, the class holds the member's effects and everything
downstream of it lies on its line.** -/
theorem reach_without_condition :
    ¬ «本类至终有常» step («二分» inClass) .m ∧ «所缘同于» step («二分» inClass) .m ∧
      ∀ t, «及» step .m t → «所及» step («二分» inClass) .m t :=
  have reach : ∀ t, «及» step .m t → «所及» step («二分» inClass) .m t :=
    («后皆续当且仅当后皆同类» («二分为类» inClass)).mpr all_alike
  ⟨not_constant_at, «后皆续则所缘同于» («二分为类» inClass) reach, reach⟩

end OtherLeaves

namespace FiniteWake

inductive Occ | m | i | j | u | u₂

def step : «际» Occ
  | .m, .m => False
  | .m, .i => True
  | .m, .j => False
  | .m, .u => True
  | .m, .u₂ => False
  | .i, .m => False
  | .i, .i => False
  | .i, .j => True
  | .i, .u => False
  | .i, .u₂ => True
  | .j, .m => False
  | .j, .i => False
  | .j, .j => False
  | .j, .u => False
  | .j, .u₂ => False
  | .u, .m => False
  | .u, .i => False
  | .u, .j => False
  | .u, .u => False
  | .u, .u₂ => False
  | .u₂, .m => False
  | .u₂, .i => False
  | .u₂, .j => False
  | .u₂, .u => False
  | .u₂, .u₂ => False

def line : Occ → Bool
  | .m => true
  | .i => true
  | .j => true
  | .u => false
  | .u₂ => false

def own : «际» Occ := fun x y => line x = line y

theorem own_class : «类» own := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- **The class is constant up to the net's end.** -/
theorem constant_to_end : «至终有常» step own := by
  intro x x' e v r
  cases x <;> cases v <;> cases x' <;>
    first
    | exact False.elim r
    | exact Bool.noConfusion e
    | exact .inl ⟨.i, trivial, rfl⟩
    | exact .inl ⟨.j, trivial, rfl⟩
    | exact .inl ⟨.u, trivial, rfl⟩
    | exact .inl ⟨.u₂, trivial, rfl⟩
    | exact .inr (fun w h => by cases w <;> exact False.elim h)

/-- **It does not hold the member's effects.** -/
theorem not_held : ¬ «所缘同于» step own .m := fun held => Bool.noConfusion (held .u trivial)

end FiniteWake

namespace FiniteFamilies

abbrev Occ := Bool × Nat

/-- Within a family, each stage below the last conditions the next. -/
def step : «际» Occ := fun x y => x.1 = y.1 ∧ y.2 = x.2 + 1 ∧ x.2 < 3

/-- The class of one member: its family and whether it is the second member. -/
def member : «际» Occ := fun x y => x.1 = y.1 ∧ (decide (2 ≤ x.2) = decide (2 ≤ y.2))

/-- The organism's relation is a class. -/
theorem member_class : «类» member :=
  ⟨fun _ => ⟨rfl, rfl⟩, fun ⟨a, b⟩ => ⟨a.symm, b.symm⟩, fun ⟨a, b⟩ ⟨c, d⟩ => ⟨a.trans c, b.trans d⟩⟩

end FiniteFamilies

/-! ## The reviewer's checks -/

section Checks

variable {α : Type u}

/-- **(C1) The reach lets one's line end only where the net does.** Where everything downstream of `m` lies on its
line under a class, no occurrence on that line (`m` included) ends while it still conditions something. -/
theorem reach_ends_where_net_ends {R E : «际» α} (hE : «类» E) {m y : α}
    (reach : ∀ t, «及» R m t → «所及» R E m t) (onLine : «所及» R E m y) (ends : «亡» R E y) :
    ∀ w, ¬ R y w := fun w step =>
  have all := («后皆续当且仅当后皆同类» hE).mp reach
  have my : E m y := match onLine with
    | .inl e => e ▸ hE.refl m
    | .inr line => «线内同类» hE line
  have down : «及» R m w := match onLine with
    | .inl e => by cases e; exact .one step
    | .inr line => «及之传递» («及之单调» (R := «续» R E) (S := R) (fun _ _ c => c.1) m y line) (.one step)
  ends ⟨w, step, hE.trans (hE.symm my) (all w down)⟩

/-- **(C2) A line that ends while its last stage still conditions something has no reach.** -/
theorem ending_line_no_reach {R E : «际» α} (hE : «类» E) {m y : α}
    (line : «相续» R E m y) (ends : «亡» R E y) (goes : ∃ w, R y w) :
    ¬ ∀ t, «及» R m t → «所及» R E m t := fun reach =>
  match goes with
  | ⟨w, hw⟩ => reach_ends_where_net_ends hE reach (.inr line) ends w hw

/-- **(C6) Given P2, P4 and acting, the class holds the effects of every occurrence alike to the member.** -/
theorem all_alike_held {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m)
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) : ∀ u, E m u → «所缘同于» R E u :=
  fun _ mu _ step =>
    hE.trans (hE.symm mu) (hE.symm («本类常闭则所缘同类» hE atClass goes held (hE.symm mu) step))

/-- **(C7) Conversely, where each alike occurrence decides whether it conditions anything, the holding of the
effects of every occurrence alike to the member gives P2 and P4.** -/
theorem held_all_alike_gives_condition {R E : «际» α} (hE : «类» E) {m : α}
    (decided : ∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w)
    (all : ∀ u, E m u → «所缘同于» R E u) : «本类至终有常» R E m ∧ «所缘同于» R E m :=
  ⟨fun u u' mu mu' v step => match decided u' mu' with
     | .inl ⟨w, hw⟩ => .inl ⟨w, hw, hE.trans (hE.symm (all u mu v step))
         (hE.trans (hE.symm mu) (hE.trans mu' (all u' mu' w hw)))⟩
     | .inr stops => .inr stops,
   all m (hE.refl m)⟩

/-- **(C8) The chapter's "of each kind that one leaves, and nothing of a kind one does not leave".** Where the member
acts and the condition holds at its class: every alike occurrence that conditions anything conditions something of
the kind of each of the member's leaving effects, itself leaving; and whatever an alike occurrence conditions that
leaves the class is of the kind of some leaving effect of the member. -/
theorem leaves_each_kind_one_leaves {R E : «际» α} (hE : «类» E) {m : α} (goes : ∃ w, R m w)
    (atClass : «本类至终有常» R E m) :
    (∀ u w, E m u → R m w → ¬ E m w → (∃ z, R u z) → ∃ v, R u v ∧ E w v ∧ ¬ E m v) ∧
      (∀ u v, E m u → R u v → ¬ E m v → ∃ w, R m w ∧ E v w ∧ ¬ E m w) :=
  match («本类常当且仅当与己相随» hE goes).mp atClass with
  | ⟨toSelf, fromSelf⟩ =>
    ⟨fun u w mu hw out acts => match fromSelf u w mu hw with
       | .inl ⟨v, hv, wv⟩ => ⟨v, hv, wv, fun mv => out (hE.trans mv (hE.symm wv))⟩
       | .inr stops => match acts with
         | ⟨z, hz⟩ => absurd hz (stops z),
     fun u v mu hv out => match toSelf u v mu hv with
       | ⟨w, hw, vw⟩ => ⟨w, hw, vw, fun mw => out (hE.trans mw (hE.symm vw))⟩⟩

/-- **(C11) Where the member acts, P2 with P4 is exactly that the class holds the effects of every occurrence alike to
the member, each of which settles whether it conditions anything.** The second conjunct is what the pure core needs
for the backward direction, and P2 itself gives it where the member acts. -/
theorem p2p4_iff_all_held {R E : «际» α} (hE : «类» E) {m : α} (goes : ∃ w, R m w) :
    («本类至终有常» R E m ∧ «所缘同于» R E m) ↔
      (∀ u, E m u → «所缘同于» R E u) ∧ (∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w) :=
  ⟨fun ⟨atClass, held⟩ =>
     ⟨all_alike_held hE atClass goes held,
      fun u mu => match goes with
        | ⟨w, hw⟩ => match atClass m u (hE.refl m) mu w hw with
          | .inl ⟨v, hv, _⟩ => .inl ⟨v, hv⟩
          | .inr stops => .inr stops⟩,
   fun ⟨all, decided⟩ => held_all_alike_gives_condition hE decided all⟩

/-- **(C10) The proposed law, as one declaration (亡而网续则后不皆续).** Where a line from a member ends while it
still conditions something, not everything downstream of the member lies on its line; no regularity is assumed. -/
theorem «亡而网续则后不皆续» {R E : «际» α} (hE : «类» E) {m y : α} (line : «相续» R E m y)
    (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ ∀ t, «及» R m t → «所及» R E m t := fun reach =>
  match goes with
  | ⟨w, hw⟩ => ends ⟨w, hw, hE.trans (hE.symm («线内同类» hE line))
      ((«后皆续当且仅当后皆同类» hE).mp reach w
        («及之传递» («及之单调» (R := «续» R E) (S := R) (fun _ _ c => c.1) m y line) (.one hw)))⟩

/-- **(C12) C11 as one declaration, for landing.** Where the member acts, the condition at its class with the holding
of its effects is exactly that the class holds the effects of every occurrence alike to it, each of which settles
whether it conditions anything. -/
theorem «本类常闭当且仅当同类皆闭» {R E : «际» α} (hE : «类» E) {m : α} (goes : ∃ w, R m w) :
    («本类至终有常» R E m ∧ «所缘同于» R E m) ↔
      (∀ u, E m u → «所缘同于» R E u) ∧ (∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w) :=
  ⟨fun ⟨atClass, held⟩ =>
     ⟨fun _ mu _ step =>
        hE.trans (hE.symm mu) (hE.symm («本类常闭则所缘同类» hE atClass goes held (hE.symm mu) step)),
      fun u mu => match goes with
        | ⟨w, hw⟩ => match atClass m u (hE.refl m) mu w hw with
          | .inl ⟨v, hv, _⟩ => .inl ⟨v, hv⟩
          | .inr stops => .inr stops⟩,
   fun ⟨all, decided⟩ =>
     ⟨fun u u' mu mu' v step => match decided u' mu' with
        | .inl ⟨w, hw⟩ => .inl ⟨w, hw, hE.trans (hE.symm (all u mu v step))
            (hE.trans (hE.symm mu) (hE.trans mu' (all u' mu' w hw)))⟩
        | .inr stops => .inr stops,
      all m (hE.refl m)⟩⟩

/-- **(C14) The path's need is the holding of effects at the member and along its own line (后皆续当且仅当自与线皆闭).**
Everything downstream of `m` lies on its line under a class exactly where the class holds the effects of `m` and of
every occurrence on its line from `m`; no regularity is assumed. -/
theorem «后皆续当且仅当自与线皆闭» {R E : «际» α} (hE : «类» E) {m : α} :
    (∀ t, «及» R m t → «所及» R E m t) ↔
      «所缘同于» R E m ∧ ∀ y, «相续» R E m y → «所缘同于» R E y :=
  ⟨fun reach =>
     ⟨«后皆续则所缘同于» hE reach,
      fun y line v step => hE.trans (hE.symm («线内同类» hE line))
        ((«后皆续当且仅当后皆同类» hE).mp reach v
          («及之传递» («及之单调» (R := «续» R E) (S := R) (fun _ _ c => c.1) m y line) (.one step)))⟩,
   fun ⟨held, along⟩ =>
     have next : ∀ {a b : α}, «所及» R E m a → R a b → «相续» R E m b := fun onLine step =>
       match onLine with
       | .inl e => by cases e; exact .one ⟨step, held _ step⟩
       | .inr line => «及之传递» line (.one ⟨step, along _ line _ step⟩)
     have go : ∀ {a t : α}, «及» R a t → «所及» R E m a → «相续» R E m t := fun d => by
       induction d with
       | one step => exact fun onLine => next onLine step
       | more step _ ih => exact fun onLine => ih (.inr (next onLine step))
     fun _ down => .inr (go down (.inl rfl))⟩

end Checks

/-- **(C3) The organism's class of `FiniteFamilies` has no reach from the first birth**: its line ends at old age,
which still conditions the second member's birth. -/
theorem organism_no_reach :
    ¬ ∀ t, «及» FiniteFamilies.step (false, 0) t →
      «所及» FiniteFamilies.step FiniteFamilies.member (false, 0) t :=
  ending_line_no_reach (m := (false, 0)) (y := (false, 1)) FiniteFamilies.member_class
    («及».one ⟨⟨rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 0))⟩, rfl, rfl⟩)
    (fun ⟨z, ⟨_, e2, _⟩, ⟨_, d⟩⟩ => by
      have hz : z.2 = 2 := e2
      rw [hz] at d
      exact Bool.noConfusion d)
    ⟨(false, 2), rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_refl 1))⟩

namespace FiniteFamilies

/-- **(C13) The proposed witness, through the proposed law**: the organism's class does not take in everything
downstream of the first birth; its line ends at old age, which still conditions the second member's birth. -/
theorem member_no_reach : ¬ ∀ t, «及» step (false, 0) t → «所及» step member (false, 0) t :=
  «亡而网续则后不皆续» (m := (false, 0)) (y := (false, 1)) member_class
    («及».one ⟨⟨rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 0))⟩, rfl, rfl⟩)
    (fun ⟨z, ⟨_, e2, _⟩, ⟨_, d⟩⟩ => by
      have hz : z.2 = 2 := e2
      rw [hz] at d
      exact Bool.noConfusion d)
    ⟨(false, 2), rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_refl 1))⟩

end FiniteFamilies

/-- **(C4) P2 and the path's need are incomparable.** In `FiniteWake` the condition holds at the member's class,
the member acts, and the reach fails (the member's effects are not held); in `OtherLeaves` the reach holds and the
condition fails. -/
theorem p2_and_need_incomparable :
    ((∃ w, FiniteWake.step FiniteWake.Occ.m w) ∧
      «本类至终有常» FiniteWake.step FiniteWake.own FiniteWake.Occ.m ∧
      ¬ ∀ t, «及» FiniteWake.step FiniteWake.Occ.m t → «所及» FiniteWake.step FiniteWake.own FiniteWake.Occ.m t) ∧
    ((∀ t, «及» OtherLeaves.step OtherLeaves.Occ.m t →
        «所及» OtherLeaves.step («二分» OtherLeaves.inClass) OtherLeaves.Occ.m t) ∧
      ¬ «本类至终有常» OtherLeaves.step («二分» OtherLeaves.inClass) OtherLeaves.Occ.m) :=
  ⟨⟨⟨FiniteWake.Occ.i, trivial⟩,
    «至终有常则本类至终有常» FiniteWake.own_class FiniteWake.constant_to_end FiniteWake.Occ.m,
    fun reach => FiniteWake.not_held («后皆续则所缘同于» FiniteWake.own_class reach)⟩,
   ⟨OtherLeaves.reach_without_condition.2.2, OtherLeaves.reach_without_condition.1⟩⟩

/-! (C5) Record law 7 drops "where the member conditions something": a member that conditions nothing, an
occurrence `u` alike to it conditioning `x` outside the class. The condition holds at the member's class, the class
holds the member's effects (vacuously), and it does not hold the effects of `u`, an alike occurrence. -/
namespace Idle

inductive Occ | m | u | x

def step : «际» Occ
  | .m, .m => False
  | .m, .u => False
  | .m, .x => False
  | .u, .m => False
  | .u, .u => False
  | .u, .x => True
  | .x, .m => False
  | .x, .u => False
  | .x, .x => False

def inClass : Occ → Bool
  | .m => true
  | .u => true
  | .x => false

theorem counter :
    (∀ w, ¬ step .m w) ∧ «本类至终有常» step («二分» inClass) .m ∧ «所缘同于» step («二分» inClass) .m ∧
      «二分» inClass .m .u ∧ ¬ «所缘同于» step («二分» inClass) .u :=
  ⟨fun w h => by cases w <;> exact h,
   fun a b ma mb v r => by
     cases a <;> cases b <;> cases v <;>
       first
       | exact False.elim r
       | exact Bool.noConfusion ma
       | exact Bool.noConfusion mb
       | exact .inl ⟨.x, trivial, rfl⟩
       | exact .inr (fun w h => by cases w <;> exact h),
   fun v h => by cases v <;> exact False.elim h,
   rfl,
   fun held => Bool.noConfusion (held .x trivial)⟩

end Idle

/-- **(C9) In `OtherLeaves` the other alike occurrence is off the member's line**: nothing downstream of `m` is `c`.
The texts say "off its line"; `other_not_held` does not state it. -/
theorem other_off_line : ¬ «及» OtherLeaves.step OtherLeaves.Occ.m OtherLeaves.Occ.c := fun down =>
  Bool.noConfusion (OtherLeaves.reached_after down rfl)

#print axioms «后皆同类则后皆续»
#print axioms «后皆续当且仅当后皆同类»
#print axioms «后皆续则所缘同于»
#print axioms «后皆同类当且仅当自与后皆闭»
#print axioms «本类常闭则后皆续»
#print axioms «本类常当且仅当与己相随»
#print axioms «外分唯系己出之同»
#print axioms «闭则外分无关»
#print axioms OtherLeaves.reach_without_condition
#print axioms OtherLeaves.other_not_held
#print axioms reach_ends_where_net_ends
#print axioms ending_line_no_reach
#print axioms organism_no_reach
#print axioms p2_and_need_incomparable
#print axioms Idle.counter
#print axioms all_alike_held
#print axioms held_all_alike_gives_condition
#print axioms leaves_each_kind_one_leaves
#print axioms other_off_line
#print axioms «亡而网续则后不皆续»
#print axioms p2p4_iff_all_held
#print axioms «本类常闭当且仅当同类皆闭»
#print axioms FiniteFamilies.member_no_reach
#print axioms «后皆续当且仅当自与线皆闭»

end Scratch
