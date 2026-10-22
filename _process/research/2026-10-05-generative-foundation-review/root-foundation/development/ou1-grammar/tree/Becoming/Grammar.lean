/-!
# The grammar: a relational calculus with continuation relative to a class at its centre (文法)

The root of the one-unfolding plan (`one-unfolding-root/PLAN.md`, version 10): classical Chinese
grammar read as a point-free relational calculus whose theorems hold for every carrier and every
relation, so in every frame. Nothing here chooses a frame: the carrier `α` and every relation are
universally quantified, and the carrier is a parameter of the statements, not a claim that its
elements exist apart from their relations. The grammar's terms are its Lean names; the table gives
each with a short English gloss.

| name | gloss |
|---|---|
| `«际»` | a relation on a carrier (the one kind of symbol) |
| `«而»`, `«逆»`, `«合»`, `«非»` | composition (first, then), converse, meet, complement |
| `«则»`, `«谓»` | inclusion; pointwise equivalence (the form of a definition) |
| `«一»`, `«静»` | the full relation (the one); identity (the change that stays in place) |
| `«及»` | reach: the transitive closure of a relation |
| `«无环»` | no occurrence reaches itself; only then is reach an order of precedence |
| `«类»` | a class: an equivalence relation (墨经 「有以同，類同也」) |
| `«续»` | continuation: linked by 缘 (`R`) and alike under a class `E` |
| `«相续»`, `«同族»` | a line (reach of continuation); a family (its equivalence closure) |
| `«有前»`, `«有后»` | has a predecessor, has a successor, in a line |
| `«生»`, `«住»`, `«亡»`, `«异»` | begins, abides, ends; alters (continues while a finer class tells apart) |
| `«不穷»` | the line from an occurrence never ends |
| `«复生»`, `«生生»` | renews (conditions a beginning that goes on); renewal without end |
| `«有常»` | `E` is constant under `R`: `E˘;R ⊆ R;E˘` |
| `«核»`, `«位核»` | the core: the greatest symmetric constant relation inside `E`; read both ways |
| `«粗»`, `«粗复生»` | the coarse net (缘 between classes); renewal at the grain of a class |

The main reading of a relation `R` is 缘: `R x y` reads "`x` is a condition of `y`". In one
history the successors of an occurrence are its co-occurring effects; in a net of possibilities
they are alternatives and a conflict relation is declared beside it. Constancy and the core are the
same formulas under both readings.

Every result is pointwise; no equality of relations is used, so neither `propext` nor `funext`
appears, and every declaration has an empty axiom report. Equality on the carrier is a commitment
of the model: what tells two occurrences apart beyond their relations is that equality, and the
statements that use it (`«静»`, the flame) say so.
-/

namespace Becoming

universe u

/-- A relation on a carrier: the grammar's one kind of symbol (际). -/
abbrev «际» (α : Type u) : Type u := α → α → Prop

section Operations

variable {α : Type u}

/-- Sequential composition (而): first `R`, then `S`. -/
def «而» (R S : «际» α) : «际» α := fun x z => ∃ y, R x y ∧ S y z

/-- Converse (逆). -/
def «逆» (R : «际» α) : «际» α := fun x y => R y x

/-- Inclusion (则): whatever `R` relates, `S` relates. -/
def «则» (R S : «际» α) : Prop := ∀ x y, R x y → S x y

/-- Pointwise equivalence (谓): the form of a definition. -/
def «谓» (R S : «际» α) : Prop := ∀ x y, R x y ↔ S x y

/-- Meet (合): related by both. -/
def «合» (R S : «际» α) : «际» α := fun x y => R x y ∧ S x y

/-- The full relation (一). -/
def «一» : «际» α := fun _ _ => True

/-- Identity (静): the change that stays in place. -/
def «静» : «际» α := fun x y => x = y

/-- Complement (非): related exactly where `R` does not relate. -/
def «非» (R : «际» α) : «际» α := fun x y => ¬ R x y

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

theorem «则».refl (R : «际» α) : «则» R R := fun _ _ h => h

theorem «则».trans {R S T : «际» α} (h₁ : «则» R S) (h₂ : «则» S T) : «则» R T :=
  fun x y h => h₂ x y (h₁ x y h)

theorem «及».trans {R : «际» α} {x y z : α} (h₁ : «及» R x y) (h₂ : «及» R y z) :
    «及» R x z := by
  induction h₁ with
  | one h => exact .more h h₂
  | more h _ ih => exact .more h (ih h₂)

theorem «及».mono {R S : «际» α} (h : «则» R S) : «则» («及» R) («及» S) := by
  intro x y hr
  induction hr with
  | one h' => exact .one (h _ _ h')
  | more h' _ ih => exact .more (h _ _ h') ih

theorem «一».«类» : «类» («一» : «际» α) :=
  ⟨fun _ => trivial, fun _ => trivial, fun _ _ => trivial⟩

end Operations

/-! ## Continuation (续): the centre -/

section Continuation

variable {α : Type u}

/-- Continuation (续): `y` continues `x` under the class `E` when `x` is a condition of `y`
(`R x y`, read as 缘) and the two are alike under `E`. The criterion is `E`; no other choice
enters. -/
def «续» (R E : «际» α) : «际» α := «合» R E

/-- A line of continuation (相续): the transitive closure of `«续»`. -/
def «相续» (R E : «际» α) : «际» α := «及» («续» R E)

/-- `y` has a predecessor in a line under `E`. -/
def «有前» (R E : «际» α) (y : α) : Prop := ∃ x, «续» R E x y

/-- `x` has a successor in a line under `E`. -/
def «有后» (R E : «际» α) (x : α) : Prop := ∃ y, «续» R E x y

/-- Begins (生): nothing it is a continuation of. -/
def «生» (R E : «际» α) (y : α) : Prop := ¬ «有前» R E y

/-- Ends (亡): nothing continues it. -/
def «亡» (R E : «际» α) (x : α) : Prop := ¬ «有后» R E x

/-- Abides (住): continues something and is continued. -/
def «住» (R E : «际» α) (x : α) : Prop := «有前» R E x ∧ «有后» R E x

/-- Alteration (异): `y` continues `x` under `E` while a finer class `F` tells them apart. -/
def «异» (R E F : «际» α) : «际» α := fun x y => «续» R E x y ∧ ¬ F x y

/-- Renews (复生): `x` is a condition of an occurrence `y` that begins a line under `E`, and the
line goes on from `y` (it is not a single flash). Renewal depends on the class: it is said with
its class or not at all. -/
def «复生» (R E : «际» α) (x : α) : Prop := ∃ y, R x y ∧ «生» R E y ∧ «有后» R E y

/-- Continuation is contained in 缘: whatever continues, continues by a condition. -/
theorem «续含于缘» (R E : «际» α) : «则» («续» R E) R := fun _ _ h => h.1

/-- A line runs along 缘: it is contained in the reach of `R`. -/
theorem «相续含于及» (R E : «际» α) : «则» («相续» R E) («及» R) :=
  «及».mono («续含于缘» R E)

/-- Continuation under the one (`«一»`) is 缘 itself: the whole net continues as one. -/
theorem «一之续» (R : «际» α) : «谓» («续» R «一») R :=
  fun _ _ => ⟨fun h => h.1, fun h => ⟨h, trivial⟩⟩

/-- Coarsening: under a coarser class, every continuation remains one. -/
theorem «粗化» (R : «际» α) {E E' : «际» α} (h : «则» E E') : «则» («续» R E) («续» R E') :=
  fun x y hc => ⟨hc.1, h x y hc.2⟩

/-- What ends under a coarser class ends under the finer one. -/
theorem «亡于粗则亡于细» (R : «际» α) {E E' : «际» α} (h : «则» E E') {x : α}
    (hx : «亡» R E' x) : «亡» R E x :=
  fun ⟨y, hy⟩ => hx ⟨y, «粗化» R h x y hy⟩

/-- What abides under a finer class abides under the coarser one. -/
theorem «住于细则住于粗» (R : «际» α) {E E' : «际» α} (h : «则» E E') {x : α}
    (hx : «住» R E x) : «住» R E' x :=
  ⟨let ⟨w, hw⟩ := hx.1; ⟨w, «粗化» R h w x hw⟩, let ⟨y, hy⟩ := hx.2; ⟨y, «粗化» R h x y hy⟩⟩

/-- The converse fails: something can end under the finer class while it abides under the
coarser one (a line of two occurrences, the second unlike the first under the finer `«静»`). -/
theorem «亡于细者不必亡于粗» :
    ∃ (α : Type) (R E E' : «际» α) (x : α), «则» E E' ∧ «亡» R E x ∧ ¬ «亡» R E' x := by
  refine ⟨Bool, fun x y => x = false ∧ y = true, «静», «一», false, fun _ _ _ => trivial, ?_, ?_⟩
  · intro ⟨y, ⟨_, hy⟩, he⟩
    cases hy; exact Bool.noConfusion he
  · intro h; exact h ⟨true, ⟨rfl, rfl⟩, trivial⟩

/-- Which of the positions an occurrence holds is not always decidable: that every occurrence, in
every model, either begins or has a predecessor is exactly excluded middle. -/
theorem «四相之定当且仅当排中» :
    (∀ (α : Type) (R E : «际» α) (x : α), «生» R E x ∨ «有前» R E x) ↔ ∀ P : Prop, P ∨ ¬ P := by
  constructor
  · intro h P
    match h Unit (fun _ _ => P) «一» () with
    | .inl hb => exact .inr fun hp => hb ⟨(), hp, trivial⟩
    | .inr ⟨_, hp, _⟩ => exact .inl hp
  · intro em α R E x
    match em («有前» R E x) with
    | .inl hp => exact .inr hp
    | .inr hn => exact .inl hn

/-- Fission: where one occurrence is continued by two that are not continued further, sameness
(one line, read either way, or identity) is not transitive. -/
theorem «分叉» :
    ∃ (α : Type) (R : «际» α) (a b c : α),
      «相续» R «一» a b ∧ «相续» R «一» a c ∧ ¬ «相续» R «一» b c ∧ ¬ «相续» R «一» c b ∧ b ≠ c := by
  refine ⟨Option Bool, fun x _ => x = none, none, some false, some true,
    .one ⟨rfl, trivial⟩, .one ⟨rfl, trivial⟩, ?_, ?_, fun h => Bool.noConfusion (Option.some.inj h)⟩
  · intro h
    cases h with
    | one h => cases (show (some false : Option Bool) = none from h.1)
    | more h _ => cases (show (some false : Option Bool) = none from h.1)
  · intro h
    cases h with
    | one h => cases (show (some true : Option Bool) = none from h.1)
    | more h _ => cases (show (some true : Option Bool) = none from h.1)

/-- A relation without cycles (无环): nothing reaches itself. Only then is reach an order of
precedence. -/
def «无环» (R : «际» α) : Prop := ∀ x, ¬ «及» R x x

/-- Without cycles, reach is a strict order: irreflexive, transitive and asymmetric. -/
theorem «无环则及为序» {R : «际» α} (h : «无环» R) :
    (∀ x, ¬ «及» R x x) ∧ (∀ {x y z}, «及» R x y → «及» R y z → «及» R x z) ∧
      (∀ {x y}, «及» R x y → ¬ «及» R y x) :=
  ⟨h, «及».trans, fun hxy hyx => h _ (hxy.trans hyx)⟩

/-- One family of continuation (同族): the equivalence closure of continuation under `E`. A line
may split and merge; its family gathers every occurrence joined to it by continuation read either
way. The family, not the line, is what the coarse net takes as one occurrence. -/
inductive «同族» (R E : «际» α) : «际» α
  | refl (x : α) : «同族» R E x x
  | step {x y : α} : «续» R E x y → «同族» R E x y
  | symm {x y : α} : «同族» R E x y → «同族» R E y x
  | trans {x y z : α} : «同族» R E x y → «同族» R E y z → «同族» R E x z

theorem «同族».«类» (R E : «际» α) : «类» («同族» R E) :=
  ⟨«同族».refl, «同族».symm, «同族».trans⟩

/-- The line from `x` never ends (不穷): every occurrence it reaches has a successor. That some
endless chain of occurrences then exists is a further step, which takes dependent choice. -/
def «不穷» (R E : «际» α) (x : α) : Prop :=
  ∀ y, (x = y ∨ «相续» R E x y) → «有后» R E y

/-- Under the one, an occurrence begins exactly when nothing conditions it. -/
theorem «一之生» (R : «际» α) (y : α) : «生» R «一» y ↔ ∀ x, ¬ R x y :=
  ⟨fun h x hr => h ⟨x, hr, trivial⟩, fun h ⟨x, hr, _⟩ => h x hr⟩

/-- Under the one nothing new begins from a condition: no occurrence conditions a beginning. -/
theorem «一之下无复生» (R : «际» α) (x : α) : ¬ «复生» R «一» x :=
  fun ⟨_, hr, hb, _⟩ => hb ⟨x, hr, trivial⟩

/-- Renewal without end (生生, as continuation and renewal only): `x` lies in some family of
occurrences each of which conditions a beginning whose line goes on and reaches a member of the
family again.
It is the greatest such family. It does not yet tell renewal that sustains life from turnover
that destroys it; that takes more than continuation (`PLAN.md` §七). -/
def «生生» (R E : «际» α) (x : α) : Prop :=
  ∃ S : α → Prop,
    (∀ z, S z → ∃ y w, R z y ∧ «生» R E y ∧ «相续» R E y w ∧ S w) ∧ S x

/-- Renewal without end renews: it conditions a beginning whose line goes on to renewal again. -/
theorem «生生».unfold {R E : «际» α} {x : α} (h : «生生» R E x) :
    ∃ y w, R x y ∧ «生» R E y ∧ «相续» R E y w ∧ «生生» R E w :=
  match h with
  | ⟨S, hS, hx⟩ =>
    match hS x hx with
    | ⟨y, w, hr, hb, hl, hw⟩ => ⟨y, w, hr, hb, hl, S, hS, hw⟩

/-- Every family that keeps renewing lies inside renewal without end. -/
theorem «生生».greatest {R E : «际» α} {S : α → Prop}
    (hS : ∀ z, S z → ∃ y w, R z y ∧ «生» R E y ∧ «相续» R E y w ∧ S w)
    {x : α} (hx : S x) : «生生» R E x :=
  ⟨S, hS, hx⟩

/-- Renewal without end is renewal. -/
theorem «生生则复生» {R E : «际» α} {x : α} (h : «生生» R E x) : «复生» R E x :=
  match h.unfold with
  | ⟨y, _, hr, hb, hl, _⟩ =>
    ⟨y, hr, hb, match hl with
      | .one c => ⟨_, c⟩
      | .more c _ => ⟨_, c⟩⟩

/-- Under the one there is no renewal without end. -/
theorem «一之下无生生» (R : «际» α) (x : α) : ¬ «生生» R «一» x :=
  fun h => match h.unfold with
    | ⟨_, _, hr, hb, _, _⟩ => hb ⟨x, hr, trivial⟩

/-- Beginning and abiding exclude each other. -/
theorem «生住不并» {R E : «际» α} {x : α} : ¬ («生» R E x ∧ «住» R E x) :=
  fun ⟨hb, hp, _⟩ => hb hp

/-- Abiding and ending exclude each other. -/
theorem «住亡不并» {R E : «际» α} {x : α} : ¬ («住» R E x ∧ «亡» R E x) :=
  fun ⟨⟨_, hs⟩, he⟩ => he hs

/-- **No position stands by itself (四相无自立).** In a net without self-conditioning, an occurrence
with a condition and a consequence abides under the one, and under identity it both begins and
ends: the same occurrence holds different positions at once, each relative to a class. -/
theorem «四相无自立» {R : «际» α} (irr : ∀ z, ¬ R z z) {x y z : α} (hxy : R x y) (hyz : R y z) :
    «住» R «一» y ∧ «生» R «静» y ∧ «亡» R «静» y :=
  ⟨⟨⟨x, hxy, trivial⟩, ⟨z, hyz, trivial⟩⟩,
   fun ⟨w, hw, he⟩ => by cases he; exact irr _ hw,
   fun ⟨w, hw, he⟩ => by cases he; exact irr _ hw⟩

/-- Continuation contained in 缘 is a necessary condition only: every single 缘 is a continuation
under the class that puts its two ends together and everything else apart. -/
theorem «任一缘可为续» {R : «际» α} {x y : α} (h : R x y) :
    ∃ E : «际» α, «类» E ∧ «续» R E x y :=
  ⟨fun a b => (a = x ∨ a = y) ↔ (b = x ∨ b = y),
   ⟨fun _ => Iff.rfl, Iff.symm, Iff.trans⟩,
   h, ⟨fun _ => .inr rfl, fun _ => .inl rfl⟩⟩

/-- Two conditions of one occurrence, alike under a class, make a merge: the occurrence continues
both (the two candles: the heat of one is among the conditions of the other's first flame). -/
theorem «蜡烛之合» {R E : «际» α} {a c b : α} (ha : R a b) (hc : R c b) (ea : E a b) (ec : E c b) :
    «续» R E a b ∧ «续» R E c b :=
  ⟨⟨ha, ea⟩, ⟨hc, ec⟩⟩

end Continuation

/-! ## Constancy (有常) and the core (核): whether a line has its own 理 -/

section Constancy

variable {α : Type u}

/-- `E` is constant under `R` (有常): `E˘;R ⊆ R;E˘`. Whatever an `E`-mate of `x` becomes, `x`
becomes something `E`-alike to it. -/
def «有常» (R E : «际» α) : Prop := «则» («而» («逆» E) R) («而» R («逆» E))

/-- The pointwise form of constancy. -/
theorem «有常».iff (R E : «际» α) :
    «有常» R E ↔ ∀ u u', E u u' → ∀ v, R u v → ∃ v', R u' v' ∧ E v v' := by
  constructor
  · intro h u u' he v hr
    match h u' v ⟨u, he, hr⟩ with
    | ⟨v', hr', he'⟩ => exact ⟨v', hr', he'⟩
  · intro h x z ⟨y, he, hr⟩
    match h y x he z hr with
    | ⟨v', hr', he'⟩ => exact ⟨v', hr', he'⟩

/-- **Constancy never lets a continuation end (有常则续不尽).** Under a class constant for `R`
(symmetric or not), whatever continues something is itself continued. So a line that ends is a
line under a class that is not constant: its own regularity is the class's core, not the class. -/
theorem «有常则续不尽» {R E : «际» α} (h : «有常» R E) {y : α} (hy : «有前» R E y) : «有后» R E y :=
  match hy with
  | ⟨x, hxy, exy⟩ =>
    match h y y ⟨x, exy, hxy⟩ with
    | ⟨w, hyw, eyw⟩ => ⟨w, hyw, eyw⟩

/-- Under a constant class, a line never ends after its first step. -/
theorem «有常则相续不尽» {R E : «际» α} (h : «有常» R E) {x y : α} (hxy : «相续» R E x y) :
    «有后» R E y := by
  induction hxy with
  | one c => exact «有常则续不尽» h ⟨_, c⟩
  | more _ _ ih => exact ih

/-- So a class under which some line ends is not constant. -/
theorem «有亡之续则不有常» {R E : «际» α} {x y : α} (hxy : «续» R E x y) (hy : «亡» R E y) :
    ¬ «有常» R E :=
  fun h => hy («有常则续不尽» h ⟨x, hxy⟩)

/-- The core (核) of `E` under `R`: related by some symmetric constant relation inside `E`. -/
def «核» (R E : «际» α) : «际» α :=
  fun u u' => ∃ S : «际» α, «则» S E ∧ «则» S («逆» S) ∧ «有常» R S ∧ S u u'

/-- **The root theorem.** The core lies inside `E`, is constant and symmetric, and contains every
symmetric constant relation inside `E`: it is the greatest one. -/
theorem «根» (R E : «际» α) :
    «则» («核» R E) E ∧ «有常» R («核» R E) ∧ «则» («核» R E) («逆» («核» R E)) ∧
      ∀ S, «则» S E → «则» S («逆» S) → «有常» R S → «则» S («核» R E) := by
  refine ⟨fun _ _ ⟨_, hS, _, _, h⟩ => hS _ _ h, ?_, ?_, fun S hS hs hc x y h => ⟨S, hS, hs, hc, h⟩⟩
  · intro x z ⟨y, ⟨S, hSE, hsym, hc, hyx⟩, hr⟩
    match hc x z ⟨y, hyx, hr⟩ with
    | ⟨w, hxw, hzw⟩ => exact ⟨w, hxw, S, hSE, hsym, hc, hzw⟩
  · intro x y ⟨S, hSE, hsym, hc, h⟩
    exact ⟨S, hSE, hsym, hc, hsym x y h⟩

/-- Constant relations compose. -/
theorem «有常».comp {R S₁ S₂ : «际» α} (h₁ : «有常» R S₁) (h₂ : «有常» R S₂) :
    «有常» R («而» S₁ S₂) := by
  apply («有常».iff R _).mpr
  intro u u' ⟨m, hum, hmu'⟩ v hr
  match («有常».iff R S₁).mp h₁ u m hum v hr with
  | ⟨v₁, hr₁, hv₁⟩ =>
    match («有常».iff R S₂).mp h₂ m u' hmu' v₁ hr₁ with
    | ⟨v', hr', hv'⟩ => exact ⟨v', hr', v₁, hv₁, hv'⟩

/-- Identity is constant under every relation. -/
theorem «有常».«静» (R : «际» α) : «有常» R «静» := by
  intro a c ⟨b, hba, hbc⟩
  exact ⟨c, by cases hba; exact hbc, rfl⟩

/-- Where `E` is a class, so is its core. -/
theorem «核».«类» (R : «际» α) {E : «际» α} (hE : «类» E) : «类» («核» R E) := by
  refine ⟨fun x => ⟨«静», fun a b h => by cases h; exact hE.refl a, fun a b h => h.symm,
    «有常».«静» R, rfl⟩, ?_, ?_⟩
  · intro x y ⟨S, hSE, hsym, hc, h⟩
    exact ⟨S, hSE, hsym, hc, hsym x y h⟩
  · intro x y z ⟨S₁, h₁E, h₁s, h₁c, h₁⟩ ⟨S₂, h₂E, h₂s, h₂c, h₂⟩
    refine ⟨fun a c => «而» S₁ S₂ a c ∨ «而» S₂ S₁ a c, ?_, ?_, ?_, .inl ⟨y, h₁, h₂⟩⟩
    · intro a c h
      match h with
      | .inl ⟨b, hab, hbc⟩ => exact hE.trans (h₁E a b hab) (h₂E b c hbc)
      | .inr ⟨b, hab, hbc⟩ => exact hE.trans (h₂E a b hab) (h₁E b c hbc)
    · intro a c h
      match h with
      | .inl ⟨b, hab, hbc⟩ => exact .inr ⟨b, h₂s b c hbc, h₁s a b hab⟩
      | .inr ⟨b, hab, hbc⟩ => exact .inl ⟨b, h₁s b c hbc, h₂s a b hab⟩
    · apply («有常».iff R _).mpr
      intro u u' h v hr
      match h with
      | .inl hm =>
        match («有常».iff R _).mp («有常».comp h₁c h₂c) u u' hm v hr with
        | ⟨v', hr', hv'⟩ => exact ⟨v', hr', .inl hv'⟩
      | .inr hm =>
        match («有常».iff R _).mp («有常».comp h₂c h₁c) u u' hm v hr with
        | ⟨v', hr', hv'⟩ => exact ⟨v', hr', .inr hv'⟩

/-- **Closure.** For a class `E`, constancy is exactly closure of the coarse net: what an
occurrence's class conditions is fixed by the occurrence's own conditions, without looking at the
rest of its class (`E;R;E ⊆ R;E`). For a class this is bisimulation equivalence (Park, Milner);
lumpability (Kemeny and Snell) and computational closure (Rosas et al.) are its probabilistic and
informational analogues, a correspondence not proved here. -/
theorem «闭合当且仅当有常» (R : «际» α) {E : «际» α} (hE : «类» E) :
    «有常» R E ↔ «则» («而» («而» E R) E) («而» R E) := by
  constructor
  · intro h x z ⟨b, ⟨a, hxa, hab⟩, hbz⟩
    match («有常».iff R E).mp h a x (hE.symm hxa) b hab with
    | ⟨w, hxw, hbw⟩ => exact ⟨w, hxw, hE.trans (hE.symm hbw) hbz⟩
  · intro h
    apply («有常».iff R E).mpr
    intro u u' he v hr
    match h u' v ⟨v, ⟨u, hE.symm he, hr⟩, hE.refl v⟩ with
    | ⟨w, hw, hwv⟩ => exact ⟨w, hw, hE.symm hwv⟩

end Constancy

section Grains

variable {α : Type u}

/-- Reading `R` at the grain of a class `L` without taking its classes apart: every 缘 inside a
class becomes a loop at both its ends. This is why the coarse net takes 缘 between classes. -/
theorem «类内之缘成环» {R L : «际» α} (hL : «类» L) {x y : α} (h : R x y) (l : L x y) :
    «而» («而» L R) L x x ∧ «而» («而» L R) L y y :=
  ⟨⟨y, ⟨x, hL.refl x, h⟩, hL.symm l⟩, ⟨y, ⟨x, hL.symm l, h⟩, hL.refl y⟩⟩

/-- The coarse net (粗) of `R` at the grain of a class `L`: one occurrence conditions another at
that grain when something in the first's class conditions something in the second's class that
lies in a different class. -/
def «粗» (R L : «际» α) : «际» α := «而» («而» L («合» R («非» L))) L

/-- The coarse net joins only different classes. -/
theorem «粗只连异类» {R L : «际» α} (hL : «类» L) {x z : α} (h : «粗» R L x z) : ¬ L x z :=
  fun hxz => match h with
    | ⟨_, ⟨_, hxa, _, hab⟩, hbz⟩ =>
      hab (hL.trans (hL.trans (hL.symm hxa) hxz) (hL.symm hbz))

/-- Renewal at the grain of `L` (粗复生): something in `x`'s class is a condition of an
occurrence that begins a line under `E`, and the line goes on. One relation, read at two grains:
the fine net is read in the coarse one, and nothing at the coarse grain sets the fine. -/
def «粗复生» (L R E : «际» α) (x : α) : Prop :=
  ∃ y, «而» L R x y ∧ «生» R E y ∧ «有后» R E y

/-- Every renewal is a renewal at the grain of every class. -/
theorem «复生则粗复生» {L R E : «际» α} (hL : «类» L) {x : α} (h : «复生» R E x) : «粗复生» L R E x :=
  match h with
  | ⟨y, hr, hb, hs⟩ => ⟨y, ⟨x, hL.refl x, hr⟩, hb, hs⟩

end Grains

section Position

variable {α : Type u}

/-- The core of `E` under `R` read both ways (位核): related by a symmetric relation inside `E` that
is constant under `R` and under its converse. Two occurrences share a position when nothing that
conditions them, nor anything they condition, tells them apart: the position is fixed by all of
its relations in the net (位由其际定), not only by what follows. -/
def «位核» (R E : «际» α) : «际» α :=
  fun u u' => ∃ S : «际» α, «则» S E ∧ «则» S («逆» S) ∧ «有常» R S ∧ «有常» («逆» R) S ∧ S u u'

/-- The two-way core is the greatest symmetric relation inside `E` constant both ways. -/
theorem «位根» (R E : «际» α) :
    «则» («位核» R E) E ∧ «有常» R («位核» R E) ∧ «有常» («逆» R) («位核» R E) ∧
      «则» («位核» R E) («逆» («位核» R E)) ∧
      ∀ S, «则» S E → «则» S («逆» S) → «有常» R S → «有常» («逆» R) S → «则» S («位核» R E) := by
  refine ⟨fun _ _ ⟨_, hS, _, _, _, h⟩ => hS _ _ h, ?_, ?_, ?_,
    fun S hS hs hc hc' x y h => ⟨S, hS, hs, hc, hc', h⟩⟩
  · intro x z ⟨y, ⟨S, hSE, hsym, hc, hc', hyx⟩, hr⟩
    match hc x z ⟨y, hyx, hr⟩ with
    | ⟨w, hxw, hzw⟩ => exact ⟨w, hxw, S, hSE, hsym, hc, hc', hzw⟩
  · intro x z ⟨y, ⟨S, hSE, hsym, hc, hc', hyx⟩, hr⟩
    match hc' x z ⟨y, hyx, hr⟩ with
    | ⟨w, hxw, hzw⟩ => exact ⟨w, hxw, S, hSE, hsym, hc, hc', hzw⟩
  · intro x y ⟨S, hSE, hsym, hc, hc', h⟩
    exact ⟨S, hSE, hsym, hc, hc', hsym x y h⟩

/-- Read both ways, the core is finer than read forward: sharing a position implies sharing a
future. -/
theorem «位核含于核» (R E : «际» α) : «则» («位核» R E) («核» R E) :=
  fun _ _ ⟨S, hSE, hs, hc, _, h⟩ => ⟨S, hSE, hs, hc, h⟩

/-- Ending does not tell apart what the core does not: for a class `E`, an occurrence that ends
under `E` has every occurrence of its core class ending too. -/
theorem «亡于核下不变» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «核» R E y y')
    (hy : «亡» R E y) : «亡» R E y' :=
  fun ⟨z', hr, he⟩ => match hk with
    | ⟨S, hSE, hs, hc, hyy⟩ =>
      match («有常».iff R S).mp hc y' y (hs y y' hyy) z' hr with
      | ⟨z, hrz, hzz⟩ =>
        hy ⟨z, hrz, hE.trans (hE.trans (hSE y y' hyy) he) (hSE z' z hzz)⟩

/-- Beginning does not tell apart what the two-way core does not. -/
theorem «生于位核下不变» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «位核» R E y y')
    (hy : «生» R E y) : «生» R E y' :=
  fun ⟨w', hr, he⟩ => match hk with
    | ⟨S, hSE, hs, _, hc', hyy⟩ =>
      match («有常».iff («逆» R) S).mp hc' y' y (hs y y' hyy) w' hr with
      | ⟨w, hrw, hww⟩ =>
        hy ⟨w, hrw, hE.trans (hE.trans (hE.symm (hSE w' w hww)) he) (hE.symm (hSE y y' hyy))⟩

/-- So the positions are read off the two-way core: what shares a position shares beginning,
abiding and ending. -/
theorem «位同则四相同» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «位核» R E y y') :
    («生» R E y → «生» R E y') ∧ («亡» R E y → «亡» R E y') :=
  ⟨«生于位核下不变» hE hk, «亡于核下不变» hE («位核含于核» R E y y' hk)⟩

end Position

/-! ## Why continuation is not defined through the core -/

/-- Three moments of a flame and its ash. -/
inductive Flame | f₀ | f₁ | f₂ | ash

namespace Flame

/-- Each moment is a condition of the next. -/
def step : «际» Flame
  | f₀, y => Flame.casesOn (motive := fun _ => Prop) y False True False False
  | f₁, y => Flame.casesOn (motive := fun _ => Prop) y False False True False
  | f₂, y => Flame.casesOn (motive := fun _ => Prop) y False False False True
  | ash, _ => False

/-- Whether a moment burns. -/
def burns : Flame → Bool
  | f₀ => true
  | f₁ => true
  | f₂ => true
  | ash => false

/-- The class "flame or not". -/
def alike : «际» Flame := fun x y => burns x = burns y

theorem alike_class : «类» alike := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- No symmetric constant relation inside `alike` relates `f₁` to `f₂`. -/
theorem not_core_f₁ {S : «际» Flame} (hSE : «则» S alike) (hs : «则» S («逆» S))
    (hc : «有常» step S) (h : S f₁ f₂) : False := by
  match («有常».iff step S).mp hc f₂ f₁ (hs _ _ h) ash trivial with
  | ⟨v, hr, hv⟩ =>
    cases v with
    | f₂ => exact Bool.noConfusion (hSE _ _ hv)
    | f₀ => exact False.elim hr
    | f₁ => exact False.elim hr
    | ash => exact False.elim hr

/-- Nor `f₀` to `f₁`. -/
theorem not_core_f₀ {S : «际» Flame} (hSE : «则» S alike) (hs : «则» S («逆» S))
    (hc : «有常» step S) (h : S f₀ f₁) : False := by
  match («有常».iff step S).mp hc f₀ f₁ h f₁ trivial with
  | ⟨v, hr, hv⟩ =>
    cases v with
    | f₂ => exact not_core_f₁ hSE hs hc hv
    | f₀ => exact False.elim hr
    | f₁ => exact False.elim hr
    | ash => exact False.elim hr

end Flame

/-- **Continuation is not defined through the core.** In a flame of three moments that ends in ash,
the moments continue one another under the class "flame or not", yet no two consecutive
moments lie in one class of its core: the core's futures differ by how long is left. Taking the
core as the criterion, the flame would have no continuation at all. -/
theorem «以核为判据则火无续» :
    «续» Flame.step Flame.alike Flame.f₀ Flame.f₁ ∧ «续» Flame.step Flame.alike Flame.f₁ Flame.f₂ ∧
      ∀ x y, ¬ «续» Flame.step («核» Flame.step Flame.alike) x y := by
  refine ⟨⟨trivial, rfl⟩, ⟨trivial, rfl⟩, ?_⟩
  intro x y ⟨hr, S, hSE, hs, hc, h⟩
  cases x <;> cases y
  all_goals first
    | exact False.elim hr
    | exact Flame.not_core_f₀ hSE hs hc h
    | exact Flame.not_core_f₁ hSE hs hc h
    | exact Bool.noConfusion (hSE _ _ h)

end Becoming
