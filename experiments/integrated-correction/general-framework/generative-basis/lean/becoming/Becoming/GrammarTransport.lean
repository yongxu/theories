import Becoming.GrammarLaws

/-!
# The grammar kept by one-to-one correspondence (一一对应)

The grammar's terms are stated for every carrier and every relation (`Becoming.Grammar`,
`Becoming.GrammarMap`, `Becoming.GrammarLaws`). This module shows, for the terms listed below, that
they are kept by a one-to-one correspondence of models. Where a correspondence `e` carries the
relations a listed term reads, the term holds at `x` exactly where it holds at `e.to x`. So such a
term's truth at a model is fixed by the model up to correspondence, which is what a representation of
a model in the grammar needs if it is not to depend on how its carrier is named
(`Becoming.WorldRepresentation`). In the names below, «对应» abbreviates «一一对应».

| name | reading |
|---|---|
| `«一一对应»` | a one-to-one correspondence of carriers: a map with a two-sided inverse |
| `«一一对应».prod` | correspondences side by side: each coordinate of a pair carried by its own |
| `«对应之像»` | carrying, read through the grammar's image: `«谓» («像» e.to R) R'` exactly where `R x y ↔ R' (e.to x) (e.to y)` |
| `«反对应之像»`, `«合成之像»` | the inverse correspondence carries back; composites carry the composite |
| `«静之像»`, `«一之像»`, `«部分恒等之像»` | identity, the one and a predicate's partial identity are carried |
| `«合之像»`, `«逆之像»`, `«而之像»`, `«及之像»`, `«历之像»`, `«迭之像»`, `«则之对应»` | carrying kept by the grammar's operations, by passing through a word (its letters renamed) and by steps, and inclusion kept |
| `«X之对应»` | the listed term `X` kept by a correspondence carrying what it reads |
| `«保之像»` | preserving (保), read through the image: `«则» («像» φ R) R'` exactly where `R x y → R' (φ x) (φ y)`; a map preserving a relation, not a relation kept (守) nor two kept each within the other (齐) |
| `«尽之拉回»`, `«延之拉回»` | ending on every branch pulled back along a map carrying continuation from a closed region; going on along some branch pulled back along a map lifting continuation |

* **Carrying through the image.** That `e` carries `R` to `R'` is written with no new term, as the image of
  `R` along `e.to` being `R'` (`«谓» («像» e.to R) R'`). Along a one-to-one correspondence this is exactly
  being related where the images are (`«对应之像»`). A predicate `P` is carried as its partial identity,
  `«合» «静» (fun x _ => P x)` (`«部分恒等之像»`), the reading 01 §7 gives of what a path admits.
* **The terms kept.** These are the terms the World's instance theorems, `Becoming.WorldRepresentation`
  and `Becoming.ProcessRepresentation` read (the last through the bridges of determination, merging
  nothing, going alike, invariants, reach, returning, traces and going on, which a renaming of a
  process keeps):
  * the continuation family (`«续»`, `«相续»`, `«有前»`, `«有后»`, `«生»`, `«亡»`, `«住»`, `«异»`,
    `«复生»`, `«不穷»`, `«同族»`, `«尽»`, `«延»`);
  * reach and closure (`«及»`, `«所闭»`, `«所及»`), steps and words (`«迭»`, `«迭内»`, `«历»`) and
    closed regions (`«闭»`);
  * the class, acyclicity, constancy and the core (`«类»`, `«无环»`, `«有常»`, `«核»`), and
    determination and going alike (`«定后»`, `«定前»`, `«同行»`);
  * the map's terms (`«传»`, `«全生成»`, `«全守»`, `«有终»`).

  The other terms of the grammar are not stated here; each would be kept the same way, and is added when
  a consumer reads it.
* **Along maps.** A map preserves a relation exactly where the image lies within the other
  (`«保之像»`), the inclusion counterpart of carrying. Ending on every branch (`«尽»`) reflects along any
  map that carries continuation from a region closed under it (`«尽之拉回»`), and going on along some
  branch (`«延»`) along any map that lifts continuation (`«延之拉回»`): no inverse is needed for either.
  `«尽之对应»` and `«延之对应»` are two cases of each, and the World reads the amounts' law of falls
  ending through the first.

That a listed term makes its notion keep to correspondences is what is shown here. That every notion
keeping to correspondences is a term is no statement this embedding of the grammar can make, since it
has no syntax of terms. Invariance of definable terms under a one-to-one correspondence is a fact of
the definitional style, so these are lemmas of the World's representation and of the processes'
(`Becoming.ProcessRepresentation`). Every declaration has an empty axiom report.
-/

namespace Becoming

universe u v w u'

/-- **A one-to-one correspondence of carriers (一一对应)**: a map with a two-sided inverse. -/
structure «一一对应» (α : Type u) (β : Type v) where
  to : α → β
  back : β → α
  back_to : ∀ x, back (to x) = x
  to_back : ∀ y, to (back y) = y

namespace «一一对应»

variable {α : Type u} {β : Type v}

/-- The inverse correspondence. -/
def symm (e : «一一对应» α β) : «一一对应» β α :=
  ⟨e.back, e.to, e.to_back, e.back_to⟩

/-- Correspondences compose. -/
def trans {γ : Type w} (e : «一一对应» α β) (e' : «一一对应» β γ) : «一一对应» α γ :=
  ⟨fun x => e'.to (e.to x), fun z => e.back (e'.back z),
   fun x => (congrArg e.back (e'.back_to (e.to x))).trans (e.back_to x),
   fun z => (congrArg e'.to (e.to_back (e'.back z))).trans (e'.to_back z)⟩

/-- A correspondence tells apart what it is given apart. -/
theorem to_eq_iff (e : «一一对应» α β) {x y : α} : e.to x = e.to y ↔ x = y :=
  ⟨fun same => (e.back_to x).symm.trans ((congrArg e.back same).trans (e.back_to y)),
   fun same => congrArg e.to same⟩

/-- Correspondences side by side: each coordinate of a pair carried by its own correspondence. -/
def prod {γ : Type w} {δ : Type u'} (e : «一一对应» α β) (e' : «一一对应» γ δ) :
    «一一对应» (α × γ) (β × δ) :=
  ⟨fun x => (e.to x.1, e'.to x.2), fun y => (e.back y.1, e'.back y.2),
   fun ⟨a, c⟩ => (congrArg (fun p => (p, e'.back (e'.to c))) (e.back_to a)).trans
     (congrArg (fun q => (a, q)) (e'.back_to c)),
   fun ⟨b, d⟩ => (congrArg (fun p => (p, e'.to (e'.back d))) (e.to_back b)).trans
     (congrArg (fun q => (b, q)) (e'.to_back d))⟩

end «一一对应»

/-! ## Along maps: pulled back, and preserving -/

/-- **Ending on every branch, pulled back (尽之拉回).** Along a map carrying continuation from a region
`P` closed under it into continuation of another model, ending on every branch at an image gives it at
the source: no inverse is needed. -/
theorem «尽之拉回» {α : Type u} {κ : Type v} {R L : «际» α} {R' L' : «际» κ} (φ : α → κ)
    (P : α → Prop) (closed : «闭» («续» R L) P)
    (maps : ∀ x y, P x → «续» R L x y → «续» R' L' (φ x) (φ y)) :
    ∀ x, P x → «尽» R' L' (φ x) → «尽» R L x := by
  have key : ∀ a, «尽» R' L' a → ∀ x, φ x = a → P x → «尽» R L x := by
    intro a h
    induction h with
    | mk _ ih =>
      intro x same hx
      exact .mk fun y c =>
        ih (φ y) (Eq.subst (motive := fun b => «续» R' L' b (φ y)) same (maps x y hx c)) y rfl
          (closed x y hx c)
  exact fun x hx h => key (φ x) h x rfl hx

/-- **Going on along some branch, pulled back along lifting (延之拉回).** Where every continuation
step from an image lifts to a continuation step from the source to something read as its end,
going on along some branch at the image gives it at the source: the region read back keeps going
on. -/
theorem «延之拉回» {α : Type u} {κ : Type v} {R L : «际» α} {R' L' : «际» κ} (φ : α → κ)
    (lifts : ∀ x r, «续» R' L' (φ x) r → ∃ y, «续» R L x y ∧ φ y = r) (x : α) :
    «延» R' L' (φ x) → «延» R L x :=
  fun ⟨S', held, goes⟩ => ⟨fun y => S' (φ y), held, fun z inside =>
    match goes (φ z) inside with
    | ⟨w', next, c'⟩ => match lifts z w' c' with
      | ⟨y, c, same⟩ => ⟨y, Eq.subst (motive := S') same.symm next, c⟩⟩

/-- **Preserving, read through the image (保之像).** A map takes every pair `R` relates to a pair `R'`
relates exactly where the image of `R` along it lies within `R'`. -/
theorem «保之像» {α : Type u} {κ : Type v} (φ : α → κ) (R : «际» α) (R' : «际» κ) :
    «则» («像» φ R) R' ↔ ∀ x y, R x y → R' (φ x) (φ y) :=
  ⟨fun within x y r => within _ _ ⟨x, y, rfl, r, rfl⟩,
   fun keeps _ _ ⟨x, y, hx, r, hy⟩ => Eq.subst (motive := fun b => R' _ b) hy
     (Eq.subst (motive := fun a => R' a (φ y)) hx (keeps x y r))⟩

/-- Every relation is the relation it is (`«谓»` is reflexive). -/
theorem «谓之自反» {α : Type u} (R : «际» α) : «谓» R R :=
  fun _ _ => Iff.rfl

namespace GrammarTransport

/-- Copies read through a map letter by letter are copies of the image, by induction (as
GrammarLaws' list lemmas are, stated without `simp`). -/
theorem map_replicate {A : Type w} {B : Type u'} (f : A → B) (c : A) :
    ∀ n, (List.replicate n c).map f = List.replicate n (f c)
  | 0 => rfl
  | n + 1 => congrArg (f c :: ·) (map_replicate f c n)

end GrammarTransport

section Carrying

variable {α : Type u} {β : Type v} (e : «一一对应» α β)

/-- **Carrying, read through the grammar's image.** Along a one-to-one correspondence, the image of
`R` is `R'` exactly where two things are related by `R` exactly where their images are related by
`R'`. -/
theorem «对应之像» (R : «际» α) (R' : «际» β) :
    «谓» («像» e.to R) R' ↔ ∀ x y, R x y ↔ R' (e.to x) (e.to y) :=
  ⟨fun same x y =>
    ⟨fun r => (same (e.to x) (e.to y)).mp ⟨x, y, rfl, r, rfl⟩,
     fun r' => match (same (e.to x) (e.to y)).mpr r' with
      | ⟨_, u, hs, r, hu⟩ =>
        Eq.subst (motive := fun b => R x b) ((e.to_eq_iff).mp hu)
          (Eq.subst (motive := fun a => R a u) ((e.to_eq_iff).mp hs) r)⟩,
   fun carries k k' =>
    ⟨fun ⟨s, u, hs, r, hu⟩ => Eq.subst (motive := fun b => R' k b) hu
        (Eq.subst (motive := fun a => R' a (e.to u)) hs ((carries s u).mp r)),
     fun r' => ⟨e.back k, e.back k', e.to_back k,
        (carries (e.back k) (e.back k')).mpr
          (Eq.subst (motive := fun b => R' (e.to (e.back k)) b) (e.to_back k').symm
            (Eq.subst (motive := fun a => R' a k') (e.to_back k).symm r')),
        e.to_back k'⟩⟩⟩

variable {e}

/-- Carrying, pointwise. -/
theorem «对应之逐点» {R : «际» α} {R' : «际» β} (h : «谓» («像» e.to R) R') (x y : α) :
    R x y ↔ R' (e.to x) (e.to y) :=
  («对应之像» e R R').mp h x y

/-- Carrying, read back. -/
theorem «对应之回» {R : «际» α} {R' : «际» β} (h : «谓» («像» e.to R) R') (u v : β) :
    R' u v ↔ R (e.back u) (e.back v) :=
  Eq.subst (motive := fun b => R' u b ↔ R (e.back u) (e.back v)) (e.to_back v)
    (Eq.subst (motive := fun a => R' a (e.to (e.back v)) ↔ R (e.back u) (e.back v)) (e.to_back u)
      («对应之逐点» h (e.back u) (e.back v)).symm)


/-- Every relation on the second carrier is the image of the relation it reads back. -/
theorem «回之像» (S' : «际» β) : «谓» («像» e.to (fun a b => S' (e.to a) (e.to b))) S' :=
  («对应之像» e _ S').mpr fun _ _ => Iff.rfl

/-- Identity is carried. -/
theorem «静之像» : «谓» («像» e.to «静») «静» :=
  («对应之像» e _ _).mpr fun _ _ => (e.to_eq_iff).symm

/-- The one is carried. -/
theorem «一之像» : «谓» («像» e.to «一») («一» : «际» β) :=
  («对应之像» e _ _).mpr fun _ _ => Iff.rfl

/-- **A predicate's partial identity is carried** where the predicate holds exactly where it holds at
the image. -/
theorem «部分恒等之像» {P : α → Prop} {P' : β → Prop} (hP : ∀ x, P x ↔ P' (e.to x)) :
    «谓» («像» e.to («合» «静» (fun x _ => P x))) («合» «静» (fun x _ => P' x)) :=
  («对应之像» e _ _).mpr fun x _ =>
    ⟨fun ⟨same, held⟩ => ⟨congrArg e.to same, (hP x).mp held⟩,
     fun ⟨same, held⟩ => ⟨(e.to_eq_iff).mp same, (hP x).mpr held⟩⟩

/-- The inverse correspondence carries back. -/
theorem «反对应之像» {R : «际» α} {R' : «际» β} (h : «谓» («像» e.to R) R') :
    «谓» («像» e.symm.to R') R :=
  («对应之像» e.symm R' R).mpr fun u v => «对应之回» h u v

/-- Composite correspondences carry the composite. -/
theorem «合成之像» {γ : Type w} {e' : «一一对应» β γ} {R : «际» α} {R' : «际» β} {R'' : «际» γ}
    (h : «谓» («像» e.to R) R') (h' : «谓» («像» e'.to R') R'') :
    «谓» («像» (e.trans e').to R) R'' :=
  («对应之像» (e.trans e') R R'').mpr fun x y =>
    («对应之逐点» h x y).trans («对应之逐点» h' (e.to x) (e.to y))

/-! ## Carrying is kept by the grammar's operations -/

theorem «合之像» {R E : «际» α} {R' E' : «际» β} (hR : «谓» («像» e.to R) R')
    (hE : «谓» («像» e.to E) E') : «谓» («像» e.to («合» R E)) («合» R' E') :=
  («对应之像» e _ _).mpr fun x y =>
    ⟨fun ⟨r, s⟩ => ⟨(«对应之逐点» hR x y).mp r, («对应之逐点» hE x y).mp s⟩,
     fun ⟨r, s⟩ => ⟨(«对应之逐点» hR x y).mpr r, («对应之逐点» hE x y).mpr s⟩⟩

theorem «逆之像» {R : «际» α} {R' : «际» β} (hR : «谓» («像» e.to R) R') :
    «谓» («像» e.to («逆» R)) («逆» R') :=
  («对应之像» e _ _).mpr fun x y => «对应之逐点» hR y x

theorem «而之像» {R S : «际» α} {R' S' : «际» β} (hR : «谓» («像» e.to R) R')
    (hS : «谓» («像» e.to S) S') : «谓» («像» e.to («而» R S)) («而» R' S') :=
  («对应之像» e _ _).mpr fun x z =>
    ⟨fun ⟨y, r, s⟩ => ⟨e.to y, («对应之逐点» hR x y).mp r, («对应之逐点» hS y z).mp s⟩,
     fun ⟨y', r', s'⟩ => ⟨e.back y',
       («对应之逐点» hR x (e.back y')).mpr
         (Eq.subst (motive := fun b => R' (e.to x) b) (e.to_back y').symm r'),
       («对应之逐点» hS (e.back y') z).mpr
         (Eq.subst (motive := fun a => S' a (e.to z)) (e.to_back y').symm s')⟩⟩

/-- **Reach kept (及之对应).** -/
theorem «及之对应» {R : «际» α} {R' : «际» β} (hR : «谓» («像» e.to R) R') (x y : α) :
    «及» R x y ↔ «及» R' (e.to x) (e.to y) :=
  ⟨fun r => by
    induction r with
    | one c => exact .one ((«对应之逐点» hR _ _).mp c)
    | more c _ ih => exact .more ((«对应之逐点» hR _ _).mp c) ih,
   fun r =>
    have back : ∀ {u v}, «及» R' u v → «及» R (e.back u) (e.back v) := fun r => by
      induction r with
      | one c => exact .one ((«对应之回» hR _ _).mp c)
      | more c _ ih => exact .more ((«对应之回» hR _ _).mp c) ih
    Eq.subst (motive := fun b => «及» R x b) (e.back_to y)
      (Eq.subst (motive := fun a => «及» R a (e.back (e.to y))) (e.back_to x) (back r))⟩

theorem «及之像» {R : «际» α} {R' : «际» β} (hR : «谓» («像» e.to R) R') :
    «谓» («像» e.to («及» R)) («及» R') :=
  («对应之像» e _ _).mpr («及之对应» hR)

/-- Inclusion of relations kept. -/
theorem «则之对应» {A B : «际» α} {A' B' : «际» β} (hA : «谓» («像» e.to A) A')
    (hB : «谓» («像» e.to B) B') : «则» A B ↔ «则» A' B' :=
  ⟨fun incl u v a' => («对应之回» hB u v).mpr (incl _ _ ((«对应之回» hA u v).mp a')),
   fun incl x y a => («对应之逐点» hB x y).mpr (incl _ _ ((«对应之逐点» hA x y).mp a))⟩

/-! ## The continuation family -/

variable {R E F L : «际» α} {R' E' F' L' : «际» β}

/-- **Continuation kept (续之对应).** -/
theorem «续之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') (x y : α) :
    «续» R E x y ↔ «续» R' E' (e.to x) (e.to y) :=
  «对应之逐点» («合之像» hR hE) x y

/-- **A line kept (相续之对应).** -/
theorem «相续之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') (x y : α) :
    «相续» R E x y ↔ «相续» R' E' (e.to x) (e.to y) :=
  «及之对应» («合之像» hR hE) x y

/-- **Reached on the line, kept (所及之对应).** -/
theorem «所及之对应» (hR : «谓» («像» e.to R) R') (hL : «谓» («像» e.to L) L') (x y : α) :
    «所及» R L x y ↔ «所及» R' L' (e.to x) (e.to y) :=
  ⟨fun reached => match reached with
    | .inl same => .inl (congrArg e.to same)
    | .inr line => .inr ((«相续之对应» hR hL x y).mp line),
   fun reached => match reached with
    | .inl same => .inl ((e.to_eq_iff).mp same)
    | .inr line => .inr ((«相续之对应» hR hL x y).mpr line)⟩

/-- **Lying within the closure, kept (所闭之对应).** -/
theorem «所闭之对应» (hR : «谓» («像» e.to R) R') (x y : α) :
    «所闭» R x y ↔ «所闭» R' (e.to x) (e.to y) :=
  ⟨fun within P' closed held =>
    within (fun a => P' (e.to a)) (fun a b inside r => closed _ _ inside ((«对应之逐点» hR a b).mp r))
      held,
   fun within P closed held =>
    have reads : P (e.back (e.to y)) :=
      within (fun b => P (e.back b)) (fun u v inside r' => closed _ _ inside ((«对应之回» hR u v).mp r'))
        (Eq.subst (motive := P) (e.back_to x).symm held)
    Eq.subst (motive := P) (e.back_to y) reads⟩

/-- **The family kept (同族之对应).** -/
theorem «同族之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') (x y : α) :
    «同族» R E x y ↔ «同族» R' E' (e.to x) (e.to y) :=
  ⟨fun fam => by
    induction fam with
    | refl x => exact .refl _
    | step c => exact .step ((«续之对应» hR hE _ _).mp c)
    | symm _ ih => exact .symm ih
    | trans _ _ ih₁ ih₂ => exact .trans ih₁ ih₂,
   fun fam =>
    have back : ∀ {u v}, «同族» R' E' u v → «同族» R E (e.back u) (e.back v) := fun fam => by
      induction fam with
      | refl u => exact .refl _
      | step c => exact .step ((«续之对应» hR hE _ _).mpr
          (Eq.subst (motive := fun b => «续» R' E' _ b) (e.to_back _).symm
            (Eq.subst (motive := fun a => «续» R' E' a _) (e.to_back _).symm c)))
      | symm _ ih => exact .symm ih
      | trans _ _ ih₁ ih₂ => exact .trans ih₁ ih₂
    Eq.subst (motive := fun b => «同族» R E x b) (e.back_to y)
      (Eq.subst (motive := fun a => «同族» R E a (e.back (e.to y))) (e.back_to x) (back fam))⟩

/-- **Having a condition, kept (有前之对应).** -/
theorem «有前之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') (y : α) :
    «有前» R E y ↔ «有前» R' E' (e.to y) :=
  ⟨fun ⟨x, c⟩ => ⟨e.to x, («续之对应» hR hE x y).mp c⟩,
   fun ⟨x', c'⟩ => ⟨e.back x', («续之对应» hR hE (e.back x') y).mpr
     (Eq.subst (motive := fun a => «续» R' E' a (e.to y)) (e.to_back x').symm c')⟩⟩

/-- **Having a consequence, kept (有后之对应).** -/
theorem «有后之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') (x : α) :
    «有后» R E x ↔ «有后» R' E' (e.to x) :=
  ⟨fun ⟨y, c⟩ => ⟨e.to y, («续之对应» hR hE x y).mp c⟩,
   fun ⟨y', c'⟩ => ⟨e.back y', («续之对应» hR hE x (e.back y')).mpr
     (Eq.subst (motive := fun b => «续» R' E' (e.to x) b) (e.to_back y').symm c')⟩⟩

/-- **Beginning kept (生之对应).** -/
theorem «生之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') (y : α) :
    «生» R E y ↔ «生» R' E' (e.to y) :=
  ⟨fun begins has => begins ((«有前之对应» hR hE y).mpr has),
   fun begins has => begins ((«有前之对应» hR hE y).mp has)⟩

/-- **Ending kept (亡之对应).** -/
theorem «亡之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') (x : α) :
    «亡» R E x ↔ «亡» R' E' (e.to x) :=
  ⟨fun ends has => ends ((«有后之对应» hR hE x).mpr has),
   fun ends has => ends ((«有后之对应» hR hE x).mp has)⟩

/-- **Abiding kept (住之对应).** -/
theorem «住之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') (x : α) :
    «住» R E x ↔ «住» R' E' (e.to x) :=
  ⟨fun ⟨p, s⟩ => ⟨(«有前之对应» hR hE x).mp p, («有后之对应» hR hE x).mp s⟩,
   fun ⟨p, s⟩ => ⟨(«有前之对应» hR hE x).mpr p, («有后之对应» hR hE x).mpr s⟩⟩

/-- **Alteration kept (异之对应).** -/
theorem «异之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E')
    (hF : «谓» («像» e.to F) F') (x y : α) :
    «异» R E F x y ↔ «异» R' E' F' (e.to x) (e.to y) :=
  ⟨fun ⟨c, apart⟩ => ⟨(«续之对应» hR hE x y).mp c, fun f => apart ((«对应之逐点» hF x y).mpr f)⟩,
   fun ⟨c, apart⟩ => ⟨(«续之对应» hR hE x y).mpr c, fun f => apart ((«对应之逐点» hF x y).mp f)⟩⟩

/-- **Renewal kept (复生之对应).** -/
theorem «复生之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') (x : α) :
    «复生» R E x ↔ «复生» R' E' (e.to x) :=
  ⟨fun ⟨y, r, begins, goes⟩ => ⟨e.to y, («对应之逐点» hR x y).mp r, («生之对应» hR hE y).mp begins,
     («有后之对应» hR hE y).mp goes⟩,
   fun ⟨y', r', begins, goes⟩ =>
    have r : R' (e.to x) (e.to (e.back y')) :=
      Eq.subst (motive := fun b => R' (e.to x) b) (e.to_back y').symm r'
    have b : «生» R' E' (e.to (e.back y')) :=
      Eq.subst (motive := fun b => «生» R' E' b) (e.to_back y').symm begins
    have g : «有后» R' E' (e.to (e.back y')) :=
      Eq.subst (motive := fun b => «有后» R' E' b) (e.to_back y').symm goes
    ⟨e.back y', («对应之逐点» hR x (e.back y')).mpr r, («生之对应» hR hE _).mpr b,
     («有后之对应» hR hE _).mpr g⟩⟩

/-- **Going on without end, kept (不穷之对应).** -/
theorem «不穷之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') (x : α) :
    «不穷» R E x ↔ «不穷» R' E' (e.to x) :=
  ⟨fun endless y' reached =>
    have back : «所及» R E x (e.back y') := («所及之对应» hR hE x (e.back y')).mpr
      (Eq.subst (motive := fun b => «所及» R' E' (e.to x) b) (e.to_back y').symm reached)
    Eq.subst (motive := fun b => «有后» R' E' b) (e.to_back y')
      ((«有后之对应» hR hE _).mp (endless _ back)),
   fun endless y reached =>
    («有后之对应» hR hE y).mpr (endless _ ((«所及之对应» hR hE x y).mp reached))⟩

/-- **Ending on every branch, kept (尽之对应)**: two cases of `«尽之拉回»`, along `e.back` and along
`e.to`. -/
theorem «尽之对应» (hR : «谓» («像» e.to R) R') (hL : «谓» («像» e.to L) L') (x : α) :
    «尽» R L x ↔ «尽» R' L' (e.to x) :=
  ⟨fun ends => «尽之拉回» e.back (fun _ => True) (fun _ _ _ _ => trivial)
      (fun u v _ c => («续之对应» hR hL (e.back u) (e.back v)).mpr
        (Eq.subst (motive := fun b => «续» R' L' (e.to (e.back u)) b) (e.to_back v).symm
          (Eq.subst (motive := fun a => «续» R' L' a v) (e.to_back u).symm c)))
      (e.to x) trivial (Eq.subst (motive := fun a => «尽» R L a) (e.back_to x).symm ends),
   fun ends => «尽之拉回» e.to (fun _ => True) (fun _ _ _ _ => trivial)
      (fun a b _ c => («续之对应» hR hL a b).mp c) x trivial ends⟩

/-! ## The class, acyclicity, constancy and the core -/

/-- **A class kept (类之对应).** -/
theorem «类之对应» (hE : «谓» («像» e.to E) E') : «类» E ↔ «类» E' :=
  ⟨fun cls => ⟨fun u => Eq.subst (motive := fun b => E' b b) (e.to_back u)
      ((«对应之逐点» hE _ _).mp (cls.refl (e.back u))),
    fun s => («对应之回» hE _ _).mpr (cls.symm ((«对应之回» hE _ _).mp s)),
    fun s t => («对应之回» hE _ _).mpr (cls.trans ((«对应之回» hE _ _).mp s) ((«对应之回» hE _ _).mp t))⟩,
   fun cls => ⟨fun x => («对应之逐点» hE x x).mpr (cls.refl _),
    fun s => («对应之逐点» hE _ _).mpr (cls.symm ((«对应之逐点» hE _ _).mp s)),
    fun s t => («对应之逐点» hE _ _).mpr (cls.trans ((«对应之逐点» hE _ _).mp s) ((«对应之逐点» hE _ _).mp t))⟩⟩

/-- **Acyclicity kept (无环之对应).** -/
theorem «无环之对应» (hR : «谓» («像» e.to R) R') : «无环» R ↔ «无环» R' :=
  ⟨fun none u cycle => none (e.back u)
      ((«及之对应» hR _ _).mpr
        (Eq.subst (motive := fun b => «及» R' b b) (e.to_back u).symm cycle)),
   fun none x cycle => none (e.to x) ((«及之对应» hR x x).mp cycle)⟩

/-- **Constancy kept (有常之对应).** -/
theorem «有常之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') :
    «有常» R E ↔ «有常» R' E' :=
  «则之对应» («而之像» («逆之像» hE) hR) («而之像» hR («逆之像» hE))

/-- **The core kept (核之对应).** -/
theorem «核之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') (x y : α) :
    «核» R E x y ↔ «核» R' E' (e.to x) (e.to y) :=
  ⟨fun ⟨S, within, symm, const, held⟩ =>
    have hS : «谓» («像» e.to S) («像» e.to S) := «谓之自反» («像» e.to S)
    ⟨«像» e.to S, («则之对应» hS hE).mp within, («则之对应» hS («逆之像» hS)).mp symm,
     («有常之对应» hR hS).mp const, («对应之逐点» hS x y).mp held⟩,
   fun ⟨S', within, symm, const, held⟩ =>
    have hS : «谓» («像» e.to (fun a b => S' (e.to a) (e.to b))) S' := «回之像» S'
    ⟨fun a b => S' (e.to a) (e.to b), («则之对应» hS hE).mpr within,
     («则之对应» hS («逆之像» hS)).mpr symm, («有常之对应» hR hS).mpr const, held⟩⟩

/-! ## The map's terms -/

/-- **Carrying renewal kept (传之对应).** -/
theorem «传之对应» (hR : «谓» («像» e.to R) R') (hL : «谓» («像» e.to L) L')
    (hE : «谓» («像» e.to E) E') (x y : α) :
    «传» R L E x y ↔ «传» R' L' E' (e.to x) (e.to y) :=
  ⟨fun ⟨c, begins⟩ => ⟨(«续之对应» hR hL x y).mp c, («生之对应» hR hE y).mp begins⟩,
   fun ⟨c, begins⟩ => ⟨(«续之对应» hR hL x y).mpr c, («生之对应» hR hE y).mpr begins⟩⟩

/-- A carrying renewal within reach, kept: some `z` reached and some `w` it carries into. -/
theorem «所及有传之对应» (hR : «谓» («像» e.to R) R') (hL : «谓» («像» e.to L) L')
    (hE : «谓» («像» e.to E) E') (y : α) :
    (∃ z w, «所及» R L y z ∧ «传» R L E z w) ↔
      ∃ z' w', «所及» R' L' (e.to y) z' ∧ «传» R' L' E' z' w' :=
  ⟨fun ⟨z, w, reached, carries⟩ =>
    ⟨e.to z, e.to w, («所及之对应» hR hL y z).mp reached, («传之对应» hR hL hE z w).mp carries⟩,
   fun ⟨z', w', reached, carries⟩ =>
    ⟨e.back z', e.back w',
     («所及之对应» hR hL y _).mpr
       (Eq.subst (motive := fun b => «所及» R' L' (e.to y) b) (e.to_back z').symm reached),
     («传之对应» hR hL hE _ _).mpr
       (Eq.subst (motive := fun b => «传» R' L' E' _ b) (e.to_back w').symm
         (Eq.subst (motive := fun a => «传» R' L' E' a w') (e.to_back z').symm carries))⟩⟩

/-- **Generation in the strong form kept (全生成之对应).** -/
theorem «全生成之对应» (hR : «谓» («像» e.to R) R') (hL : «谓» («像» e.to L) L')
    (hE : «谓» («像» e.to E) E') (x : α) :
    «全生成» R L E x ↔ «全生成» R' L' E' (e.to x) :=
  ⟨fun ⟨endless, ahead⟩ => ⟨(«不穷之对应» hR hL x).mp endless, fun y' reached =>
     have back : «所及» R L x (e.back y') := («所及之对应» hR hL x _).mpr
       (Eq.subst (motive := fun b => «所及» R' L' (e.to x) b) (e.to_back y').symm reached)
     Eq.subst (motive := fun b => ∃ z' w', «所及» R' L' b z' ∧ «传» R' L' E' z' w') (e.to_back y')
       ((«所及有传之对应» hR hL hE _).mp (ahead _ back))⟩,
   fun ⟨endless, ahead⟩ => ⟨(«不穷之对应» hR hL x).mpr endless, fun y reached =>
     («所及有传之对应» hR hL hE y).mpr (ahead _ ((«所及之对应» hR hL x y).mp reached))⟩⟩

/-- **Keeping in the strong form kept (全守之对应).** -/
theorem «全守之对应» (hR : «谓» («像» e.to R) R') (hL : «谓» («像» e.to L) L')
    (hE : «谓» («像» e.to E) E') (x : α) :
    «全守» R L E x ↔ «全守» R' L' E' (e.to x) :=
  ⟨fun ⟨endless, y, reached, never⟩ => ⟨(«不穷之对应» hR hL x).mp endless, e.to y,
     («所及之对应» hR hL x y).mp reached, fun z' w' reached' carries =>
       never (e.back z') (e.back w')
         ((«所及之对应» hR hL y _).mpr
           (Eq.subst (motive := fun b => «所及» R' L' (e.to y) b) (e.to_back z').symm reached'))
         ((«传之对应» hR hL hE _ _).mpr
           (Eq.subst (motive := fun b => «传» R' L' E' _ b) (e.to_back w').symm
             (Eq.subst (motive := fun a => «传» R' L' E' a w') (e.to_back z').symm carries)))⟩,
   fun ⟨endless, y', reached, never⟩ => ⟨(«不穷之对应» hR hL x).mpr endless, e.back y',
     («所及之对应» hR hL x _).mpr
       (Eq.subst (motive := fun b => «所及» R' L' (e.to x) b) (e.to_back y').symm reached),
     fun z w reached' carries => never (e.to z) (e.to w)
       (Eq.subst (motive := fun a => «所及» R' L' a (e.to z)) (e.to_back y')
         ((«所及之对应» hR hL _ z).mp reached'))
       ((«传之对应» hR hL hE z w).mp carries)⟩⟩

/-- **Reaching an end kept (有终之对应).** -/
theorem «有终之对应» (hR : «谓» («像» e.to R) R') (hL : «谓» («像» e.to L) L') (x : α) :
    «有终» R L x ↔ «有终» R' L' (e.to x) :=
  ⟨fun ⟨y, reached, ends⟩ => ⟨e.to y, («所及之对应» hR hL x y).mp reached, («亡之对应» hR hL y).mp ends⟩,
   fun ⟨y', reached, ends⟩ => ⟨e.back y',
     («所及之对应» hR hL x _).mpr
       (Eq.subst (motive := fun b => «所及» R' L' (e.to x) b) (e.to_back y').symm reached),
     («亡之对应» hR hL _).mpr (Eq.subst (motive := fun b => «亡» R' L' b) (e.to_back y').symm ends)⟩⟩

/-! ## Words, steps, regions, determination and going on -/

/-- **Passing through a word, carried (历之像)**: where each letter's relation is carried to the
relation of its renamed letter, passing through every word is carried to passing through the renamed
word. -/
theorem «历之像» {A : Type w} {B : Type u'} {G : A → «际» α} {G' : B → «际» β} (f : A → B)
    (hG : ∀ a, «谓» («像» e.to (G a)) (G' (f a))) : ∀ as, «谓» («像» e.to («历» G as)) («历» G' (as.map f))
  | [] => «静之像»
  | a :: as => «而之像» (hG a) («历之像» f hG as)

/-- **Passing through a word, kept (历之对应).** -/
theorem «历之对应» {A : Type w} {B : Type u'} {G : A → «际» α} {G' : B → «际» β} (f : A → B)
    (hG : ∀ a, «谓» («像» e.to (G a)) (G' (f a))) (as : List A) (x y : α) :
    «历» G as x y ↔ «历» G' (as.map f) (e.to x) (e.to y) :=
  «对应之逐点» («历之像» f hG as) x y

/-- **Steps carried (迭之像)**: the case of `«历之像»` for one relation, `«迭»` being passing through a
word of copies (`«迭即历»`). -/
theorem «迭之像» (hR : «谓» («像» e.to R) R') (n : Nat) : «谓» («像» e.to («迭» R n)) («迭» R' n) :=
  («对应之像» e _ _).mpr fun x y =>
    ((«迭即历» R n x y).symm.trans («历之对应» (G := fun (_ : Unit) => R) (G' := fun (_ : Unit) => R') id
      (fun _ => hR) (List.replicate n ()) x y)).trans
    ((Iff.of_eq (congrArg (fun l => «历» (fun (_ : Unit) => R') l (e.to x) (e.to y))
        (GrammarTransport.map_replicate id () n))).trans («迭即历» R' n (e.to x) (e.to y)))

/-- **Steps kept (迭之对应).** -/
theorem «迭之对应» (hR : «谓» («像» e.to R) R') (n : Nat) (x y : α) :
    «迭» R n x y ↔ «迭» R' n (e.to x) (e.to y) :=
  «对应之逐点» («迭之像» hR n) x y

/-- **Within `n` steps, kept (迭内之对应).** -/
theorem «迭内之对应» (hR : «谓» («像» e.to R) R') (n : Nat) (x y : α) :
    «迭内» R n x y ↔ «迭内» R' n (e.to x) (e.to y) :=
  ⟨fun ⟨k, le, steps⟩ => ⟨k, le, («迭之对应» hR k x y).mp steps⟩,
   fun ⟨k, le, steps⟩ => ⟨k, le, («迭之对应» hR k x y).mpr steps⟩⟩

/-- **A closed region, kept (闭之对应)**, where membership is carried. -/
theorem «闭之对应» {P : α → Prop} {P' : β → Prop} (hR : «谓» («像» e.to R) R')
    (hP : ∀ x, P x ↔ P' (e.to x)) : «闭» R P ↔ «闭» R' P' :=
  ⟨fun closed u v held r' =>
    have back : P (e.back u) := (hP (e.back u)).mpr (Eq.subst (motive := P') (e.to_back u).symm held)
    Eq.subst (motive := P') (e.to_back v)
      ((hP (e.back v)).mp (closed _ _ back ((«对应之回» hR u v).mp r'))),
   fun closed x y held r => (hP y).mpr (closed _ _ ((hP x).mp held) ((«对应之逐点» hR x y).mp r))⟩

/-- **A fixed successor, kept (定后之对应).** -/
theorem «定后之对应» (hR : «谓» («像» e.to R) R') : «定后» R ↔ «定后» R' :=
  «则之对应» («而之像» («逆之像» hR) hR) «静之像»

/-- **Merging nothing, kept (定前之对应).** -/
theorem «定前之对应» (hR : «谓» («像» e.to R) R') : «定前» R ↔ «定前» R' :=
  «则之对应» («而之像» hR («逆之像» hR)) «静之像»

/-- **Going alike, kept (同行之对应).** -/
theorem «同行之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') :
    «同行» R E ↔ «同行» R' E' :=
  «则之对应» («而之像» («而之像» («逆之像» hR) hE) hR) hE

/-- **Going on along some branch, kept (延之对应)**: two cases of `«延之拉回»`, along `e.back` and
along `e.to`. -/
theorem «延之对应» (hR : «谓» («像» e.to R) R') (hL : «谓» («像» e.to L) L') (x : α) :
    «延» R L x ↔ «延» R' L' (e.to x) :=
  ⟨fun goes => «延之拉回» e.back
      (fun u r c => ⟨e.to r, Eq.subst (motive := fun a => «续» R' L' a (e.to r)) (e.to_back u)
          ((«续之对应» hR hL (e.back u) r).mp c), e.back_to r⟩)
      (e.to x) (Eq.subst (motive := fun a => «延» R L a) (e.back_to x).symm goes),
   fun goes => «延之拉回» e.to
      (fun a r c => ⟨e.back r, («续之对应» hR hL a (e.back r)).mpr
          (Eq.subst (motive := fun b => «续» R' L' (e.to a) b) (e.to_back r).symm c), e.to_back r⟩)
      x goes⟩

end Carrying

end Becoming
